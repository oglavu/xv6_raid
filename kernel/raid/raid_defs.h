//
// Created by os on 12/8/24.
//

//
// Created by os on 12/8/24.
//

#include "kernel/types.h"

// raid0.c
uint64 raid_init_0();
uint64 raid_read_0(int, uchar*);
uint64 raid_write_0(int, uchar*);
uint64 raid_fail_0(int);
uint64 raid_repair_0(int);
uint64 raid_info_0(uint*, uint*, uint*);
uint64 raid_destroy_0();

// raid1.c
uint64 raid_init_1();
uint64 raid_read_1(int, uchar*);
uint64 raid_write_1(int, uchar*);
uint64 raid_fail_1(int);
uint64 raid_repair_1(int);
uint64 raid_info_1(uint*, uint*, uint*);
uint64 raid_destroy_1();

// raid01.c
uint64 raid_init_01();
uint64 raid_read_01(int, uchar*);
uint64 raid_write_01(int, uchar*);
uint64 raid_fail_01(int);
uint64 raid_repair_01(int);
uint64 raid_info_01(uint*, uint*, uint*);
uint64 raid_destroy_01();

// raid4.c
uint64 raid_init_4();
uint64 raid_read_4(int, uchar*);
uint64 raid_write_4(int, uchar*);
uint64 raid_fail_4(int);
uint64 raid_repair_4(int);
uint64 raid_info_4(uint*, uint*, uint*);
uint64 raid_destroy_4();

// raid5.c
uint64 raid_init_5();
uint64 raid_read_5(int, uchar*);
uint64 raid_write_5(int, uchar*);
uint64 raid_fail_5(int);
uint64 raid_repair_5(int);
uint64 raid_info_5(uint*, uint*, uint*);
uint64 raid_destroy_5();

