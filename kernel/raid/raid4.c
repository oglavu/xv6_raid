//
// Created by os on 12/8/24.
//

#include "kernel/types.h"

uint64
raid_init_4() {
    return 0;
}

uint64
raid_read_4(int blkn, uchar* data) {
    return 0;
}

uint64
raid_write_4(int blkn, uchar* data) {
    return 0;
}

uint64
raid_fail_4(int diskn) {
    return 0;
}

uint64
raid_repair_4(int diskn) {
    return 0;
}

uint64
raid_info_4(uint* blkn, uint* blks, uint* diskn) {
    return 0;
}

uint64
raid_destroy_4() {
    return 0;
}
