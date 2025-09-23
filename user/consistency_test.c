
// Test purpose: check if disk memory has expected contents
// Note: operation and raid must be same ones that were used before shutdown

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void check_data(const uint blocks, uchar *blk, const uint block_size, const int op);

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

  uchar* blk = malloc(block_size);
  for (uint i = 0; i < blocks; i++) {
    for (uint j = 0; j < block_size; j++) {
      blk[j] = operations[op](i, j);
    }
  }

  printf("Preparation finished\n");
  check_data(blocks, blk, block_size, op);
  printf("Content checked\n");

  free(blk);

  exit(0);
}

void check_data(const uint blocks, uchar *blk, const uint block_size, const int op) {
  for (uint i = 0; i < blocks; i++) {
    int ret = read_raid(i, blk);
    if ( ret != 0) {
      printf("Error on reading block %d: %d\n", i, ret);
      continue;
    }
    for (uint j = 0; j < block_size; j++) {
      uint8 value = operations[op](i,j);
      if (blk[j] != value) {
        printf("expected=%d got=%d in %dth byte\n", value, blk[j], j);
        printf("Data in the block %d faulty\n", i);
        break;
      }
    }
  }
}
