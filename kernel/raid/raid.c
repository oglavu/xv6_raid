//
// Created by os on 12/8/24.
//

#include "raid.h"
#include "raid_defs.h"
#include "raid_types.h"

extern void argint(int, int*);
extern void argaddr(int, uint64*);
extern void printf(char*, ...);

// raid_init_X
static uint64 (*raid_inits[])(void) = {
[ENUM_raid_0]  raid_init_0,
[ENUM_raid_1]  raid_init_1,
[ENUM_raid_01] raid_init_01,
[ENUM_raid_4]  raid_init_4,
[ENUM_raid_5]  raid_init_5
};

// raid_read_X
static uint64 (*raid_reads[])(int, uchar*) = {
[ENUM_raid_0]  raid_read_0,
[ENUM_raid_1]  raid_read_1,
[ENUM_raid_01] raid_read_01,
[ENUM_raid_4]  raid_read_4,
[ENUM_raid_5]  raid_read_5
};

// raid_write_X
static uint64 (*raid_writes[])(int, uchar*) = {
[ENUM_raid_0]  raid_write_0,
[ENUM_raid_1]  raid_write_1,
[ENUM_raid_01] raid_write_01,
[ENUM_raid_4]  raid_write_4,
[ENUM_raid_5]  raid_write_5
};

// raid_fail_X
static uint64 (*raid_fails[])(int) = {
[ENUM_raid_0]  raid_fail_0,
[ENUM_raid_1]  raid_fail_1,
[ENUM_raid_01] raid_fail_01,
[ENUM_raid_4]  raid_fail_4,
[ENUM_raid_5]  raid_fail_5
};

// raid_repair_X
static uint64 (*raid_repairs[])(int) = {
[ENUM_raid_0]  raid_repair_0,
[ENUM_raid_1]  raid_repair_1,
[ENUM_raid_01] raid_repair_01,
[ENUM_raid_4]  raid_repair_4,
[ENUM_raid_5]  raid_repair_5
};

// raid_info_X
static uint64 (*raid_infos[])(uint64,uint64,uint64) = {
[ENUM_raid_0]  raid_info_0,
[ENUM_raid_1]  raid_info_1,
[ENUM_raid_01] raid_info_01,
[ENUM_raid_4]  raid_info_4,
[ENUM_raid_5]  raid_info_5
};

// raid_destroy_X
static uint64 (*raid_destroys[])() = {
[ENUM_raid_0]  raid_destroy_0,
[ENUM_raid_1]  raid_destroy_1,
[ENUM_raid_01] raid_destroy_01,
[ENUM_raid_4]  raid_destroy_4,
[ENUM_raid_5]  raid_destroy_5
};

int current_raid = -1;
uint8 faultyDisks = 0;
struct RaidHeader raidHeaders[RAID_DISKS];

uint64
sys_init_raid(void) {
  int type;
  argint(0, &type);
  current_raid = type;
  return raid_inits[type]();
}

uint64
sys_read_raid(void){
  int blkn = 0;
  uchar* data = 0;

  argint(0, &blkn);
  argaddr(1, (uint64*)&data);

  return raid_reads[current_raid](blkn, data);
}

uint64
sys_write_raid(void){
  int blkn;
  uchar* data;

  argint(0, &blkn);
  argaddr(1, (uint64*)&data);

  return raid_writes[current_raid](blkn, data);
}

uint64
sys_disk_fail_raid(void){
  int diskn;
  argint(0, &diskn);

  uint8 mask = 1 << diskn;

  //printf("diskn: %d | mask %d | faultyDisks: %d\n", diskn, mask, faultyDisks);

  // disk already faulty
  if (faultyDisks && mask)
    return -1;
  if (diskn <= 0 || diskn > RAID_DISKS)
    return -2;

  faultyDisks |= mask;
  raidHeaders[diskn].faulty = 1;

  return raid_fails[current_raid](diskn);
}

uint64
sys_disk_repaired_raid(void){
  int diskn;
  argint(0, &diskn);

  uint8 mask = ~(1 << diskn);

  //printf("diskn: %d | mask %d | faultyDisks: %d\n", diskn, mask, faultyDisks);

  // disk not faulty
  if ((faultyDisks | mask) != (uint8)-1)
    return -1;

  faultyDisks &= mask;
  raidHeaders[diskn].faulty = 0;

  return raid_repairs[current_raid](diskn);
}

uint64
sys_info_raid(void){
  uint64 blkn, blks, diskn;

  argaddr(0, &blkn);
  argaddr(1, &blks);
  argaddr(2, &diskn);

  return raid_infos[current_raid](blkn, blks, diskn);
}

uint64
sys_destroy_raid(void){
  return raid_destroys[current_raid]();
}

