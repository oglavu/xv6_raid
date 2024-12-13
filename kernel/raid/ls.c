
#include "raid.h"
#include "raid_defs.h"

extern void printf(char*, ...);
extern void write_block(int diskn, int blockno, uchar* data);
extern void read_block(int diskn, int blockno, uchar* data);

static int validate(struct RaidHeader* model, struct RaidHeader* comparator) {
  return ( model->magic == comparator->magic &&
      model->raidType == comparator->raidType &&
      model->raidRole == comparator->raidRole &&
      model->diskIx   == comparator->diskIx &&
      model->diskNo   == comparator->diskNo &&
      model->faulty   == comparator->faulty );
}

static void assign(struct RaidHeader* model, struct RaidHeader* comparator) {
  model->magic    = comparator->magic;
  model->raidType = comparator->raidType;
  model->raidRole = comparator->raidRole;
  model->diskIx   = comparator->diskIx;
  model->diskNo   = comparator->diskNo;
  model->faulty   = comparator->faulty;
}

void load_raid(void) {

  int first = 0;
  struct RaidHeader model;
  for (int ix=1; ix<=DISKS; ix++) {
    
    printf("Pre citanja\n");
    read_block(ix, 0, (uchar*)&raidHeaders[ix]);
    printf("Posle citanja\n");
    
    if (first == 0) {
      // check magic number
      if (raidHeaders[ix].magic != RAID_MAGIC) {
        printf("Raid disks not initialised\n");
        return;
      }
      first = 1;
      assign(&model, &raidHeaders[ix]);
      continue;
    }
    // 0 -> unanimous
    if (validate(&model, &raidHeaders[ix]) == 0) {
      printf("Raid disks NOT unanimous | Waiting raid initialisation\n");
      break;
    }
  }
  current_raid = model.raidType;
  printf("Raid disks unanimous | Raid already initialised\n");

}

void store_raid(void) {

  for (int ix=1; ix<=DISKS; ix++) {

    write_block(ix, 0, (uchar*)&raidHeaders[ix]);

  }

}