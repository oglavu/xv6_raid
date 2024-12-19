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

#define AVAIL_BLOCKS (RAID_DISKS * (MAX_BLOCKS - 1))

uint64
raid_init_0() {
  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
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
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int diskNo = blkn % RAID_DISKS + RAID_DISKS_START;
  int blkNo = blkn / RAID_DISKS + HEADER_OFFSET;

  // disk faulty
  uint8 mask = 1 << diskNo;
  if (faultyDisks & mask)
    return -2;

  read_block(diskNo, blkNo, data);

  return 0;
}

uint64
raid_write_0(int blkn, uchar* data) {

  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int diskNo = blkn % RAID_DISKS + RAID_DISKS_START;
  int blkNo = blkn / RAID_DISKS + HEADER_OFFSET;

  // disk faulty
  uint8 mask = 1 << diskNo;
  if (faultyDisks & mask) {
    return -2;
  }

  write_block(diskNo, blkNo, data);

  return 0;
}

uint64
raid_fail_0(int diskn) {

  uint8 mask = 1 << diskn;

  // disk already faulty
  if (faultyDisks & mask)
    return -1;
  if (diskn <= 0 || diskn > RAID_DISKS_END)
    return -2;

  faultyDisks |= mask;
  for (uint8 ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].faulty = faultyDisks;
  }
  store_raid();

  return 0;
}

uint64
raid_repair_0(int diskn) {
  return -1;
}

uint64
raid_info_0(uint* blkn, uint* blks, uint* diskn) {

  *blkn = AVAIL_BLOCKS;
  *blks = BSIZE;
  *diskn = RAID_DISKS;

  return 0;
}
