#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void check_data(uint blocks, uchar *blk, uint block_size);

int
main(int argc, char *argv[])
{
  
  init_raid(RAID0);

  uint disk_num = 2, block_num = 3, block_size =4;
  info_raid(&block_num, &block_size, &disk_num);

  printf("disk_num = %d, block_size = %d, block_num = %d\n", disk_num, block_size, block_num);

  uint blocks = (512 > block_num ? block_num : 512);

  uchar* blk = malloc(block_size);
  for (uint i = 0; i < blocks; i++) {
    for (uint j = 0; j < block_size; j++) {
      blk[j] = j + i;
      //printf("%d ", blk[j]);
    }
    //printf("Writing to block %d\n", i);
    write_raid(i, blk);
  }
  printf("Writing finished\n");
  check_data(blocks, blk, block_size);
  printf("Content is fine\n");

  disk_fail_raid(1);

  check_data(blocks, blk, block_size);
  printf("Content is checked\n");

  disk_repaired_raid(1);

  check_data(blocks, blk, block_size);
  printf("Content is checked\n");

  free(blk);

  exit(0);
}

void check_data(uint blocks, uchar *blk, uint block_size)
{
  int dead = 0;
  for (uint i = 0; i < blocks; i++)
  {
    if (read_raid(i, blk) != 0) {
      if (dead == 0) {
        printf("Disk dead\n"); 
        dead = 1;
      }
      continue;
    }
    dead = 0;
    for (uint j = 0; j < block_size; j++)
    {
      if ((uchar)(j + i) != blk[j])
      {
        printf("expected=%d got=%d", j + i, blk[j]);
        printf("Data in the block %d faulty\n", i);
        break;
      }
    }
  }
}
