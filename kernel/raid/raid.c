//
// Created by os on 12/8/24.
//

#include "raid.h"
#include "raid_defs.h"
#include "raid_types.h"

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
static uint64 (*raid_infos[])(uint*,uint*,uint*) = {
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

static int current_raid;

uint64
sys_init_raid(void) {
  int type = 0;
  current_raid = type;
  return raid_inits[type]();
}

uint64
sys_read_raid(void){
  int blkn = 0;
  uchar* data = 0;
  return raid_reads[current_raid](blkn, data);
}

uint64
sys_write_raid(void){
  int blkn = 0;
  uchar* data = 0;
  return raid_writes[current_raid](blkn, data);
}

uint64
sys_disk_fail_raid(void){
  int blkn = 0;
  return raid_fails[current_raid](blkn);
}

uint64
sys_disk_repaired_raid(void){
  int blkn = 0;
  return raid_repairs[current_raid](blkn);
}

uint64
sys_info_raid(void){
  uint64 blkn = 0, blks = 0, diskn = 0;
  return raid_infos[current_raid]((uint*)blkn, (uint*)blks, (uint*)diskn);
}

uint64
sys_destroy_raid(void){
  return raid_destroys[current_raid]();
}

