//
// Created by os on 12/8/24.
//

#include "kernel/types.h"

uint64
raid_init_01() {
    return 0;
}

uint64
raid_read_01(int blkn, uchar* data) {
    return 0;
}

uint64
raid_write_01(int blkn, uchar* data) {
    return 0;
}

uint64
raid_fail_01(int diskn) {
    return 0;
}

uint64
raid_repair_01(int diskn) {
    return 0;
}

uint64
raid_info_01(uint* blkn, uint* blks, uint* diskn) {
    return 0;
}

uint64
raid_destroy_01() {
    return 0;
}
