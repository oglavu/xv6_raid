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

#define AVAIL_BLOCKS ((RAID_DISKS - 1) * (MAX_BLOCKS - 1))
#define XOR(a,b) ((~a | ~b) & (a | b))

uint64
raid_init_5() {
  // raid_5 requires at least three hdds
  if (RAID_DISKS < 3)
    return -1;

  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].magic = RAID_MAGIC;
    raidHeaders[ix].raidType = ENUM_raid_5;
    raidHeaders[ix].raidRole = MIXED;
    raidHeaders[ix].diskIx = ix;
    raidHeaders[ix].diskNo = RAID_DISKS;
    raidHeaders[ix].faulty = faultyDisks;
  }

  // parity block must be zero set
  uchar* buf = (uchar*)kalloc();
  memset(buf, 0, BSIZE);
  for (int ix1=RAID_DISKS_START; ix1 <= RAID_DISKS_END; ix1++) {
    for (int ix2=HEADER_OFFSET; ix2 < MAX_BLOCKS; ix2++) {
      write_block(ix1, ix2, buf);
    }
  }
  kfree(buf);

  return 0;
}

uint64
raid_read_5(int blkn, uchar* data) {
    
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int blkNo = blkn / (RAID_DISKS - 1) + HEADER_OFFSET; // dobro
  int diskNo = (blkn + ((blkn % (RAID_DISKS - 1) + HEADER_OFFSET) >= blkNo)) % RAID_DISKS + RAID_DISKS_START;

  read_block(diskNo, blkNo, data);
  return 0;
}

uint64
raid_write_5(int blkn, uchar* data) {
     
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int blkNo = blkn / (RAID_DISKS - 1) + HEADER_OFFSET; // dobro
  int diskNo = (blkn + ((blkn % (RAID_DISKS - 1) + HEADER_OFFSET) >= blkNo)) % RAID_DISKS + RAID_DISKS_START;

  write_block(diskNo, blkNo, data);
  return 0;
}

uint64
raid_fail_5(int diskn) {
    return 0;
}

uint64
raid_repair_5(int diskn) {
    return 0;
}

uint64
raid_info_5(uint* blkn, uint* blks, uint* diskn) {
    
  *blkn = AVAIL_BLOCKS;
  *blks = BSIZE;
  *diskn = RAID_DISKS;

  return 0;
}

uint64
raid_destroy_5() {
    return 0;
}
