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

#define AVAIL_BLOCKS (RAID_DISKS * (MAX_BLOCKS - 1) / 2)

uint64
raid_init_1() {
  // raid_1 requires at least two hdds
  if (RAID_DISKS < 2)
    return -1;
  // raid_1 requires even number of hdds
  if (RAID_DISKS % 2 == 1)
    return -2;

  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].magic = RAID_MAGIC;
    raidHeaders[ix].raidType = ENUM_raid_1;
    raidHeaders[ix].raidRole = (ix % 2 == 1) ? DATA : MIRROR;
    raidHeaders[ix].diskIx = ix;
    raidHeaders[ix].diskNo = RAID_DISKS;
    raidHeaders[ix].faulty = faultyDisks;
  }
  return 0;
}

uint64
raid_read_1(int blkn, uchar* data) {

  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  uint64 blks_per_disk = MAX_BLOCKS - 1;

  int diskNo = 2 * blkn / blks_per_disk + RAID_DISKS_START;
  int blkNo  = blkn % blks_per_disk + HEADER_OFFSET;

  // disk faulty
  uint8 mask = 1 << diskNo;
  if (faultyDisks & mask)
    diskNo++;
  mask = 1 << diskNo;
  if (faultyDisks & mask)
    return -2;

  read_block(diskNo, blkNo, data);

  return 0;
}

uint64
raid_write_1(int blkn, uchar* data) {
    
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  uint64 blks_per_disk = MAX_BLOCKS - 1;

  int diskNo = 2 * blkn / blks_per_disk + RAID_DISKS_START;
  int blkNo  = blkn % blks_per_disk + HEADER_OFFSET;

  // disk faulty
  uint8 mask = 1 << diskNo;
  uint8 dataFaulty = (faultyDisks & mask);
  uint8 mirrorFaulty = (faultyDisks & (mask << 1));

  if (dataFaulty && mirrorFaulty)
    return -2;

  if (!dataFaulty)
    write_block(diskNo, blkNo, data); // data disk
  if (!mirrorFaulty)
    write_block(diskNo + 1, blkNo, data); // mirror disk
  
  return 0;
}

uint64
raid_fail_1(int diskn) {
    
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
raid_repair_1(int diskn) {

  if (diskn <= 0 || diskn > RAID_DISKS_END)
    return -1;
  
  // disk not faulty
  uint8 mask = 1 << diskn;
  if (!(faultyDisks & mask))
    return -2;
  
  int pair = (diskn % 2 == 0) ? (diskn - 1) : (diskn + 1);
  
  // pair is faulty as well
  uint8 pair_mask = 1 << pair;
  if (faultyDisks & pair_mask)
    return -3;

  // TODO: copy whole disk
  // uchar* buf = (uchar*)kalloc();
  // for (int ix=HEADER_OFFSET; ix < MAX_BLOCKS; ix++) {
  //   printf("Block: %d\n", ix);
  //   read_block(pair, ix, buf);
  //   write_block(diskn, ix, buf);
  // }
  // kfree(buf);

  faultyDisks &= ~mask;
  for (uint8 ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].faulty = faultyDisks;
  }
  store_raid();

  return 0;
}

uint64
raid_info_1(uint* blkn, uint* blks, uint* diskn) {
    
  *blkn = AVAIL_BLOCKS;
  *blks = BSIZE;
  *diskn = RAID_DISKS;

  return 0;
}
