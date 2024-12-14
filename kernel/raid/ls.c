
#include "raid.h"
#include "raid_defs.h"

extern void printf(char*, ...);
extern void write_block(int diskn, int blockno, uchar* data);
extern void read_block(int diskn, int blockno, uchar* data);

extern void* kalloc();
extern void kfree(void*);

static int validate(struct RaidHeader* model, struct RaidHeader* comparator) {
  return ( (model->magic == comparator->magic) &&
      (model->raidType == comparator->raidType) &&
      (model->raidRole == comparator->raidRole) &&
      (model->diskNo   == comparator->diskNo) &&
      (model->faulty   == comparator->faulty) );
}

static void assign(struct RaidHeader* model, struct RaidHeader* comparator) {
  model->magic    = comparator->magic;
  model->raidType = comparator->raidType;
  model->raidRole = comparator->raidRole;
  model->diskIx   = comparator->diskIx;
  model->diskNo   = comparator->diskNo;
  model->faulty   = comparator->faulty;
}

// static void printHeader(struct RaidHeader* header) {
//   printf("-> Magic number: %p\n", header->magic);
//   printf("-> Raid Type: %d\n", header->raidType);
//   printf("-> Raid Role: %d\n", header->raidRole);
//   printf("-> Disk Index: %d\n", header->diskIx);
//   printf("-> Disk Number: %d\n", header->diskNo);
// }


// load 0-th block from hdd
// raid uninitialised initialised: returns -1
// raid initialised: returns ENUM_raidX
int load_raid(void) {

  int first = 0;
  struct RaidHeader model;
  uchar* buf = (uchar*) kalloc();
  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    read_block(ix, 0, buf);

    assign(&raidHeaders[ix], (struct RaidHeader*)buf);
    printf("Loading Raid | %d\n", ix);
    //printHeader(&raidHeaders[ix]);
    
    if (first == 0) {
      // check magic number
      if (raidHeaders[ix].magic != RAID_MAGIC) {
        printf("Raid disks not initialised\n");
        kfree(buf);
        return -1;
      }
      first = 1;
      assign(&model, &raidHeaders[ix]);
      continue;
    }
    // 0 -> not unanimous
    if (validate(&model, &raidHeaders[ix]) == 0) {
      printf("Raid disks NOT unanimous | Waiting raid initialisation\n");
      kfree(buf);
      return -2;
    }
  }
  kfree(buf);
  printf("Raid disks unanimous | Raid %d already initialised\n", model.raidType-1);
  return model.raidType;
}

int store_raid(void) {

  for (int ix=RAID_DISKS_START; ix <= RAID_DISKS_END; ix++) {
    printf("Storing Raid | %d\n", ix);
    //printHeader(&raidHeaders[ix]);
    write_block(ix, 0, (uchar*)&raidHeaders[ix]);

  }

  return 0;
}