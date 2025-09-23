//
// Created by os on 12/8/24.
//

#include "raid.h"
#include "raid_defs.h"
#include "raid_types.h"
#include "../param.h"
#include "../memlayout.h"
#include "../riscv.h"
#include "../spinlock.h"
#include "../proc.h"
#include "../fs.h"
#include "../defs.h"

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

int current_raid = -1;
uint8 faultyDisks = 0;
struct RaidHeader raidHeaders[RAID_DISKS_START + RAID_DISKS];

uint64
sys_init_raid(void) {
  int type;
  argint(0, &type);

  if (!(ENUM_raid_0 <= type && type <= ENUM_raid_5))
    return -1;

  current_raid = type;

  uint64 ret;
  int loaded_raid;
  uint8 loaded_faulty;
  if (load_raid(&loaded_raid, &loaded_faulty) == 0 && 
      loaded_raid == type) {
    // appropriate raid already initialised
    faultyDisks |= loaded_faulty;
    ret = 0;
  } else {
    ret = raid_inits[type]();
    store_raid();
  }

  return ret;
}

uint64
sys_read_raid(void){
  if (current_raid < 0) {
    // raid uninitialised
    return -1;
  }
  int blkn = 0;
  uchar* data = 0;

  argint(0, &blkn);
  argaddr(1, (uint64*)&data);

  // blkn is logical block
  // blkp is physical block

  struct proc* p = myproc();
  uchar* paData = (uchar*) (walkaddr(p->pagetable, (uint64)data)  + (uint64)data%PGSIZE);

  return raid_reads[current_raid](blkn, paData);
}

uint64
sys_write_raid(void){
  if (current_raid < 0) {
    // raid uninitialised
    return -1;
  }
  int blkn;
  uchar* data;

  argint(0, &blkn);
  argaddr(1, (uint64*)&data);

  // blkn is logical block
  // blkp is physical block
  // 0-th blk is for disc header
  
  struct proc* p = myproc();
  uchar* paData = (uchar*) (walkaddr(p->pagetable, (uint64)data)  + (uint64)data%PGSIZE);

  return raid_writes[current_raid](blkn, paData);
}

uint64
sys_disk_fail_raid(void){
  if (current_raid < 0) {
    // raid uninitialised
    return -1;
  }
  int diskn;
  argint(0, &diskn);

  if (diskn < RAID_DISKS_START || diskn > RAID_DISKS_END)
    return -2;

  return raid_fails[current_raid](diskn);
}

uint64
sys_disk_repaired_raid(void){
  if (current_raid < 0) {
    // raid uninitialised
    return -1;
  }

  int diskn;
  argint(0, &diskn);

  if (diskn < RAID_DISKS_START || diskn > RAID_DISKS_END)
    return -2;

  return raid_repairs[current_raid](diskn);
}

uint64
sys_info_raid(void){
  if (current_raid < 0) {
    // raid uninitialised
    return -1;
  }

  uint64 blkn, blks, diskn;

  argaddr(0, &blkn);
  argaddr(1, &blks);
  argaddr(2, &diskn);

  // get physical address of user space variables
  struct proc* p = myproc();
  uint* paBlkn = (uint*) (walkaddr(p->pagetable, blkn)  + blkn%PGSIZE);
  uint* paBlks = (uint*) (walkaddr(p->pagetable, blks)  + blks%PGSIZE);
  uint* paDisk = (uint*) (walkaddr(p->pagetable, diskn) + diskn%PGSIZE);

  return raid_infos[current_raid](paBlkn, paBlks, paDisk);
}

uint64
sys_destroy_raid(void){
  if (current_raid < 0)
    return -1;

  for (uint8 ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].magic = 0x0;
  }
  store_raid();
  current_raid = -1;
  faultyDisks = 0;
  return 0;
}

uint64
sys_load_raid(void){
  int loaded_raid;
  uint8 loaded_faulty;
  
  if (load_raid(&loaded_raid, &loaded_faulty) == 0) {
    current_raid = loaded_raid;
    faultyDisks = loaded_faulty;
  }

  return 0;
}

uint64
sys_store_raid(void){
  if (current_raid < 0) {
    // raid uninitialised
    return -1;
  }
  store_raid();
  return 0;
}

