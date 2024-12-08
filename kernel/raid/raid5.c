//
// Created by os on 12/8/24.
//

#include "kernel/types.h"

uint64
raid_init_5() {
    return 0;
}

uint64
raid_read_5(int blkn, uchar* data) {
    return 0;
}

uint64
raid_write_5(int blkn, uchar* data) {
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
    return 0;
}

uint64
raid_destroy_5() {
    return 0;
}
