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
#include "../sleeplock.h"
#include "../proc.h"
#include "../fs.h"
#include "../defs.h"

#define AVAIL_BLOCKS ((RAID_DISKS - 1) * (MAX_BLOCKS - 1))
#define XOR(a,b) ((~a | ~b) & (a | b))

static struct sleeplock strip_locks[MAX_BLOCKS];

static void pair_block(int diskNo, int blkNo, uchar* new_buf) {

  int p_dsk = (blkNo - HEADER_OFFSET) % RAID_DISKS + RAID_DISKS_START;

  uchar* buf = (uchar*)kalloc();
  uchar* parity = (uchar*)kalloc();
  read_block(diskNo, blkNo, buf);
  read_block(p_dsk, blkNo, parity);

  for (int ix=0; ix<BSIZE; ix++) {
    uchar tmp = XOR(buf[ix], new_buf[ix]);
    parity[ix] = XOR(parity[ix], tmp);
  } 
  write_block(p_dsk, blkNo, parity);

}

static void retrive_block(int diskn, int blkn, uchar* buf) {
  uchar* tmp = (uchar*)kalloc();
  memset(buf, 0, BSIZE);
  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    if (ix == diskn) continue;

    read_block(ix, blkn, tmp);
    
    for (int ix2=0; ix2 < BSIZE; ix2++) {
      buf[ix2] = XOR(buf[ix2], tmp[ix2]);
    }

  }
  kfree(tmp);

}

static void pair_failed_block(int diskNo, int blkNo, uchar* new_buf) {
  // MUST BE CALLED ON _not_ FUNCTIONING DISK
  // new_buf is NEW content of disk (diskNo), block (blkNo)

  int p_dsk = (blkNo - HEADER_OFFSET) % RAID_DISKS + RAID_DISKS_START;

  uchar* parity = (uchar*)kalloc();
  uchar* tmp = (uchar*)kalloc();
  memmove(parity, new_buf, BSIZE);
  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ++ix) {
    if (diskNo == ix) continue;
    if (p_dsk == ix) continue;
    
    read_block(ix, blkNo, tmp);
    for (int ix=0; ix < BSIZE; ix++) {
      parity[ix] = XOR(parity[ix], tmp[ix]);
    }
  }
  
  write_block(p_dsk, blkNo, parity);
  kfree(parity);
  kfree(tmp);

}

static int count_ones(uchar n) {
  int count = 0;
  for (count = 0; n; count++) {
    n &= n - 1;
  }
  return count;
}

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

  // init sleep locks
  for (int ix = 0; ix < MAX_BLOCKS; ix++) {
    initsleeplock(&strip_locks[ix], "strip_lock_5");
  }

  // parity block must be zero set
  uchar* buf = (uchar*)kalloc();
  memset(buf, 0, BSIZE);
  for (int ix1=HEADER_OFFSET; ix1 < MAX_BLOCKS; ix1++) {
    acquiresleep(&strip_locks[ix1]);
    for (int ix2=RAID_DISKS_START; ix2 <= RAID_DISKS_END; ix2++) {
      write_block(ix1, ix2, buf);
    }
    releasesleep(&strip_locks[ix1]);
  }
  kfree(buf);

  return 0;
}

uint64
raid_read_5(int blkn, uchar* data) {
    
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int row = blkn / (RAID_DISKS - 1);
  int p_blk = row % RAID_DISKS;
  int unadj_col = blkn % (RAID_DISKS - 1);
  int col = (unadj_col >= p_blk) ? (unadj_col+1) : (unadj_col);

  int blkNo = row + HEADER_OFFSET;
  int diskNo = col + RAID_DISKS_START;

  uint8 mask = 1 << diskNo;
  if (faultyDisks & mask) {
    if (count_ones(faultyDisks) > 1) {
      return -2;
    } else {
      acquiresleep(&strip_locks[blkNo]);
      retrive_block(diskNo, blkNo, data);
    }
  } else {
    acquiresleep(&strip_locks[blkNo]);
    read_block(diskNo, blkNo, data);
  }
  releasesleep(&strip_locks[blkNo]);
  return 0;
}

uint64
raid_write_5(int blkn, uchar* data) {
     
  // block out of bound
  if (blkn < 0 || blkn >= AVAIL_BLOCKS) 
    return -1;

  int row = blkn / (RAID_DISKS - 1);
  int p_blk = row % RAID_DISKS;
  int unadj_col = blkn % (RAID_DISKS - 1);
  int col = (unadj_col >= p_blk) ? (unadj_col+1) : (unadj_col);

  int blkNo = row + HEADER_OFFSET;
  int diskNo = col + RAID_DISKS_START;

  // disk faulty
  uint8 mask = 1 << diskNo;
  if (faultyDisks & mask) {
    if (count_ones(faultyDisks) > 1) {
      return -2;
    } else {
      acquiresleep(&strip_locks[blkNo]);
      pair_failed_block(diskNo, blkNo, data);
    }
  } else {
    acquiresleep(&strip_locks[blkNo]);
    pair_block(diskNo, blkNo, data);
    write_block(diskNo, blkNo, data);
  }
  releasesleep(&strip_locks[blkNo]);
  return 0;
}

uint64
raid_fail_5(int diskn) {
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
raid_repair_5(int diskn) {
  if (diskn <= 0 || diskn > RAID_DISKS_END)
    return -1;
  
  // disk not faulty
  uint8 mask = 1 << diskn;
  if (!(faultyDisks & mask))
    return -2;

  // too many failed, can't repair
  if (count_ones(faultyDisks) > 1)
    return -3;

  uchar* buf = (uchar*) kalloc();
  uchar* tmp = (uchar*) kalloc();
  memset(buf, 0, BSIZE);
  for (int ix1 = HEADER_OFFSET; ix1 < MAX_BLOCKS; ix1++) {
    acquiresleep(&strip_locks[ix1]);
    for (int ix2 = RAID_DISKS_START; ix2<= RAID_DISKS_END; ix2++) {
      if (diskn == ix2) continue;
      
      read_block(ix2, ix1, tmp);
      for (int ix3 = 0; ix3 < BSIZE; ix3++) {
        buf[ix3] = XOR(buf[ix3], tmp[ix3]);
      }
    }
    write_block(diskn, ix1, buf);
    releasesleep(&strip_locks[ix1]);
    memset(buf, 0, BSIZE);
  }
  kfree(buf);
  kfree(tmp);

  faultyDisks &= ~mask;
  for (uint8 ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    raidHeaders[ix].faulty = faultyDisks;
  }
  store_raid();

  return 0;
}

uint64
raid_info_5(uint* blkn, uint* blks, uint* diskn) {
    
  *blkn = AVAIL_BLOCKS;
  *blks = BSIZE;
  *diskn = RAID_DISKS;

  return 0;
}
