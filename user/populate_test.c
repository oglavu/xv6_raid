
// Test purpose: write to disk memory

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

static uint8 add(uint8 x, uint8 y) { return x+y; }
static uint8 sub(uint8 x, uint8 y) { return x-y; }
static uint8 mul(uint8 x, uint8 y) { return x*y; }
static uint8 xor(uint8 x, uint8 y) { return x^y; }

static uint8 (*operations[])(uint8, uint8) = {
  add, sub, mul, xor
};

int main(int argc, char *argv[]) {

  if (argc != 3) {
    printf("Invalid usage. Try %s <raid_type> <op_code>.\n", argv[0]);
    exit(-1);
  }

  const int type = atoi(argv[1]);
  const int op = atoi(argv[2]);

  if (init_raid(type) < 0) {
    printf("Initialisation unsuccessful\n");
    exit(-1);
  }

  uint disk_num = 2, block_num = 3, block_size =4;
  info_raid(&block_num, &block_size, &disk_num);

  printf("disk_num = %d, block_size = %d, block_num = %d\n", disk_num, block_size, block_num);

  uint blocks = (512 > block_num ? block_num : 512);

  printf("Starting populating...\n");
  uchar* blk = malloc(block_size);
  for (uint i = 0; i < blocks; i++) {
    for (uint j = 0; j < block_size; j++) {
      blk[j] = operations[op](i, j);
    }
    int ret = write_raid(i, blk);
    if (0 > ret) {
      printf("Error on writing block %d: %d\n", i, ret);
    }
  }
  printf("Finished populating.\n");

  free(blk);

  exit(0);
}

