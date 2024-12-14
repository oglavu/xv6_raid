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

uint64
raid_init_0() {
  for (int ix=RAID_DISKS_START; ix < RAID_DISKS_END; ix++) {
    raidHeaders[ix].magic = RAID_MAGIC;
    raidHeaders[ix].raidType = ENUM_raid_0;
    raidHeaders[ix].raidRole = DATA;
    raidHeaders[ix].diskIx = ix;
    raidHeaders[ix].diskNo = RAID_DISKS;
    raidHeaders[ix].faulty = faultyDisks;
  }
  return 0;
}

uint64
raid_read_0(int blkn, uchar* data) {

  // block out of bound
  if (blkn < 0 || blkn > MAX_BLOCKS) 
    return -1;

  // blkn is logical block
  // blkp is physical block

  struct proc* p = myproc();
  uchar* paData = (uchar*) (walkaddr(p->pagetable, (uint64)data)  + (uint64)data%PGSIZE);

  int diskn = blkn % RAID_DISKS + 1;
  int blkp = blkn / RAID_DISKS + 1;

  // disk faulty
  uint8 mask = 1 << diskn;
  if (faultyDisks && mask)
    return -2;

  read_block(diskn, blkp, paData);

  return 0;
}

uint64
raid_write_0(int blkn, uchar* data) {

  // block out of bound
  if (blkn < 0 || blkn > MAX_BLOCKS) 
    return -1;

  // blkn is logical block
  // blkp is physical block
  // 0-th blk is for disc header

  struct proc* p = myproc();
  uchar* paData = (uchar*) (walkaddr(p->pagetable, (uint64)data)  + (uint64)data%PGSIZE);

  int diskn = blkn % RAID_DISKS + 1;
  int blkp = blkn / RAID_DISKS + 1;

  // disk faulty
  uint8 mask = 1 << diskn;
  if (faultyDisks && mask) {
    return -2;
  }

  write_block(diskn, blkp, paData);

  return 0;
}

uint64
raid_fail_0(int diskn) {
  return 0;
}

uint64
raid_repair_0(int diskn) {
  return 0;
}

uint64
raid_info_0(uint64 blkn, uint64 blks, uint64 diskn) {

  // get physical address of user space variables
  struct proc* p = myproc();
  uint* pBlkn = (uint*) (walkaddr(p->pagetable, blkn)  + blkn%PGSIZE);
  uint* pBlks = (uint*) (walkaddr(p->pagetable, blks)  + blks%PGSIZE);
  uint* pDisk = (uint*) (walkaddr(p->pagetable, diskn) + diskn%PGSIZE);

  *pBlkn = RAID_DISKS * (DISK_SIZE / BSIZE -1);
  *pBlks = BSIZE;
  *pDisk = RAID_DISKS;

  return 0;
}

uint64
raid_destroy_0() {
  return 0;
}
