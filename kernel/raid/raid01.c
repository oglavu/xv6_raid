//
// Created by os on 12/8/24.
//

#include "raid.h"
#include "raid_types.h"
#include "raid_defs.h"
#include "../param.h"
#include "../memlayout.h"
#include "../riscv.h"
#include "../spinlock.h"
#include "../proc.h"
#include "../fs.h"
#include "../defs.h"

#define AVAIL_BLOCKS (RAID_DISKS * (MAX_BLOCKS - 1) / 2)

// static void printHeader(struct RaidHeader* header) {
//   printf("-> Magic number: %p\n", header->magic);
//   printf("-> Raid Type: %d\n", header->raidType);
//   printf("-> Raid Role: %d\n", header->raidRole);
//   printf("-> Disk Index: %d\n", header->diskIx);
//   printf("-> Disk Number: %d\n", header->diskNo);
// }

static void copy_disk(int diskNo, int pairNo) {
  uchar* buf = (uchar*)kalloc();
  for (int ix=HEADER_OFFSET; ix < MAX_BLOCKS; ix++) {
    read_block(pairNo, ix, buf);
    write_block(diskNo, ix, buf);
  }
  kfree(buf);
}

uint64
raid_init_01() {
    // raid_01 requires at least four hdds
  if (RAID_DISKS < 4)
    return -1;
  // raid_01 requires even number of hdds
  if (RAID_DISKS % 2 == 1)
    return -2;

  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].magic = RAID_MAGIC;
    raidHeaders[ix].raidType = ENUM_raid_01;
    raidHeaders[ix].raidRole = (ix % 2 == 1) ? DATA : MIRROR;
    raidHeaders[ix].diskIx = ix;
    raidHeaders[ix].diskNo = RAID_DISKS;
    raidHeaders[ix].faulty = faultyDisks;
  }
  return 0;
}

uint64
raid_read_01(int blkn, uchar* data) {
    
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int diskNo = 2 * blkn % RAID_DISKS + RAID_DISKS_START;
  int blkNo  = 2 * blkn / RAID_DISKS + HEADER_OFFSET;

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
raid_write_01(int blkn, uchar* data) {
       
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int diskNo = 2 * blkn % RAID_DISKS + RAID_DISKS_START;
  int blkNo  = 2 * blkn / RAID_DISKS + HEADER_OFFSET;

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
raid_fail_01(int diskn) {
  uint8 mask = 1 << diskn;
  // disk already faulty
  if (diskn <= 0 || diskn > RAID_DISKS_END)
    return -1;
  if (faultyDisks & mask)
    return -2;

  faultyDisks |= mask;
  for (uint8 ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].faulty = faultyDisks;
  }
  store_raid();

  return 0;
}

uint64
raid_repair_01(int diskn) {
  if (diskn <= 0 || diskn > RAID_DISKS_END)
    return -1;
  
  // disk not faulty
  uint8 mask = 1 << diskn;
  if (!(faultyDisks & mask))
    return -2;
  
  faultyDisks &= ~mask;
  for (uint8 ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].faulty = faultyDisks;
  }
  store_raid();

  int pair = diskn ^ 0x1;

  // pair is faulty as well
  uint8 pair_mask = 1 << pair;
  if (faultyDisks & pair_mask)
    return -3;

  copy_disk(diskn, pair);

  return 0;
}

uint64
raid_info_01(uint* blkn, uint* blks, uint* diskn) {
        
  *blkn = AVAIL_BLOCKS;
  *blks = BSIZE;
  *diskn = RAID_DISKS;

  return 0;
}
