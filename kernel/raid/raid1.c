//
// Created by os on 12/8/24.
//

#include "kernel/types.h"

uint64
raid_init_1() {
    return 0;
}

uint64
raid_read_1(int blkn, uchar* data) {
    return 0;
}

uint64
raid_write_1(int blkn, uchar* data) {
    return 0;
}

uint64
raid_fail_1(int diskn) {
    return 0;
}

uint64
raid_repair_1(int diskn) {
    return 0;
}

uint64
raid_info_1(uint* blkn, uint* blks, uint* diskn) {
    return 0;
}

uint64
raid_destroy_1() {
    return 0;
}
