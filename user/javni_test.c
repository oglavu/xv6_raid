#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void check_data(uint blocks, uchar *blk, uint block_size);

enum RAID_TYPE {RAID0, RAID1, RAID0_1, RAID4, RAID5};
int init_raid(enum RAID_TYPE raid){return 0;};
int read_raid(int blkn, uchar* data){return 0;};
int write_raid(int blkn, uchar* data){return 0;};
int disk_fail_raid(int diskn){return 0;};
int disk_repaired_raid(int diskn){return 0;};
int info_raid(uint *blkn, uint *blks, uint *diskn){return 0;};
int destroy_raid(){return 0;};


int
main(int argc, char *argv[])
{
  
  init_raid(RAID1);

  uint disk_num, block_num, block_size;
  info_raid(&block_num, &block_size, &disk_num);

  uint blocks = (512 > block_num ? block_num : 512);

  uchar* blk = malloc(block_size);
  for (uint i = 0; i < blocks; i++) {
    for (uint j = 0; j < block_size; j++) {
      blk[j] = j + i;
    }
    write_raid(i, blk);
  }

  check_data(blocks, blk, block_size);

  disk_fail_raid(2);

  check_data(blocks, blk, block_size);

  disk_repaired_raid(2);

  check_data(blocks, blk, block_size);

  free(blk);

  exit(0);
}

void check_data(uint blocks, uchar *blk, uint block_size)
{
  for (uint i = 0; i < blocks; i++)
  {
    read_raid(i, blk);
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
