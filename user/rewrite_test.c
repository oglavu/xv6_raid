#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define ABS(a) ((a>=0) ? a : -a)

void check_data(uint blocks, uchar *blk, uint block_size);

int
main(int argc, char *argv[])
{
  int n = argc - 1;
  int arr[8];
  for (int ix=1; ix < argc; ix++) {
    arr[ix-1] = atoi(argv[ix]);
  }

  uint disk_num = 2, block_num = 3, block_size =4;
  info_raid(&block_num, &block_size, &disk_num);

  printf("disk_num = %d, block_size = %d, block_num = %d\n", disk_num, block_size, block_num);

  uint blocks = (512 > block_num ? block_num : 512);

  uchar* blk = malloc(block_size);
  for (uint i = 0; i < blocks; i++) {
    for (uint j = 0; j < block_size; j++) {
      blk[j] = ABS(j - i);
    }
    write_raid(i, blk);
  }
  printf("Writing finished\n");
  check_data(blocks, blk, block_size);
  printf("Content is fine\n");

  for (int i=0; i<n; i++) {
    disk_fail_raid(arr[i]);
  }
  uchar* tmp = (uchar*)malloc(block_size);
  memset(tmp, 1, block_size);
  write_raid(0, tmp);
  
  memset(tmp, 0, block_size);
  if (read_raid(0, tmp) < 0) {
    printf("Read failed");
  };
  for (int ix=0; ix<block_size; ix++) {
    if (tmp[ix] != 1) {
        printf("expected=%d got=%d ", 1, tmp[ix]);
        printf("Data in the block %d faulty\n", 0);
    }
  }
  free(tmp);
  printf("Content is checked\n");


  check_data(blocks, blk, block_size);
  printf("Content is checked\n");

  for (int i=0; i<n; i++) {
    disk_repaired_raid(arr[i]);
  }

  check_data(blocks, blk, block_size);
  printf("Content is checked\n");

  free(blk);

  exit(0);
}

void check_data(uint blocks, uchar *blk, uint block_size)
{
  for (uint i = 1; i < blocks; i++)
  {
    if (read_raid(i, blk) != 0) {
      printf("Disk dead | Block: %d\n", i);
      continue;
    }
    for (uint j = 0; j < block_size; j++)
    {
      if ((uchar)ABS(j - i) != blk[j])
      {
        printf("expected=%d got=%d ", j * i, blk[j]);
        printf("Data in the block %d faulty\n", i);
        break;
      }
    }
  }

}
