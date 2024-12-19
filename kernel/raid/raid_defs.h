//
// Created by os on 12/8/24.
//

#include "../types.h"

#define RAID_MAGIC 0x21022020
#define RAID_DISKS (DISKS)
#define MAX_BLOCKS (DISK_SIZE / BSIZE) // per disk
#define RAID_DISKS_START (1)
#define RAID_DISKS_END (DISKS)

enum DISK_ROLE {NONE = 0, DATA = 1, PARITY = 2, MIRROR = 3, MIXED = 4 };

struct RaidHeader {
    uint32 magic;
    int raidType;
    int raidRole;

    int diskIx;
    int diskNo;

    uint8 faulty;
};

extern uint8 faultyDisks;
extern int current_raid;
extern struct RaidHeader raidHeaders[RAID_DISKS_START + RAID_DISKS_END];

// raid0.c
uint64 raid_init_0();
uint64 raid_read_0(int, uchar*);
uint64 raid_write_0(int, uchar*);
uint64 raid_fail_0(int);
uint64 raid_repair_0(int);
uint64 raid_info_0(uint*, uint*, uint*);

// raid1.c
uint64 raid_init_1();
uint64 raid_read_1(int, uchar*);
uint64 raid_write_1(int, uchar*);
uint64 raid_fail_1(int);
uint64 raid_repair_1(int);
uint64 raid_info_1(uint*, uint*, uint*);

// raid01.c
uint64 raid_init_01();
uint64 raid_read_01(int, uchar*);
uint64 raid_write_01(int, uchar*);
uint64 raid_fail_01(int);
uint64 raid_repair_01(int);
uint64 raid_info_01(uint*, uint*, uint*);

// raid4.c
uint64 raid_init_4();
uint64 raid_read_4(int, uchar*);
uint64 raid_write_4(int, uchar*);
uint64 raid_fail_4(int);
uint64 raid_repair_4(int);
uint64 raid_info_4(uint*, uint*, uint*);

// raid5.c
uint64 raid_init_5();
uint64 raid_read_5(int, uchar*);
uint64 raid_write_5(int, uchar*);
uint64 raid_fail_5(int);
uint64 raid_repair_5(int);
uint64 raid_info_5(uint*, uint*, uint*);

