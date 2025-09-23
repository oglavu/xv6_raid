#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Test purpose: repair/fail some disk(s)
// Note: Repairs/Failiures propagate; Disks are firstly repaired and then failed

int main(int argc, char *argv[]) {
  
  if (argc < 2) {
    printf("Invalid usage. Try %s <raid_type> [*<repair_diskn>] 0 [*<fail_diskn>].\n", argv[0]);
    exit(-1);
  }

  const int type = atoi(argv[1]);
  
  int n_r, n_f;
  int arr_r[8], arr_f[8];
  
  uint8 is_f = 0;
  for (int ix=2; ix < argc; ix++) {
    if (argv[ix][0] == 'o') {
      is_f = 1;
      n_r = ix-2;
      continue;
    }
    if (is_f) {
      arr_f[ix-3-n_r] = atoi(argv[ix]);
    } else {
      arr_r[ix-2] = atoi(argv[ix]);
    }
  }
  n_f = argc-3-n_r;

  printf("n_f: %d; n_r: %d\n", n_f, n_r);

  if (init_raid(type) < 0) {
    printf("Initialisation unsuccessful\n");
    exit(-1);
  }

  uint disk_num = 2, block_num = 3, block_size =4;
  info_raid(&block_num, &block_size, &disk_num);

  printf("disk_num = %d, block_size = %d, block_num = %d\n", disk_num, block_size, block_num);

  int ret;
  for (int i=0; i<n_r; i++) {
    ret = disk_repaired_raid(arr_r[i]);
    printf("Repairing disk %d... Status: %d\n", arr_r[i], ret);
  }

  for (int i=0; i<n_f; i++) {
    ret = disk_fail_raid(arr_f[i]);
    printf("Failing disk %d... Status: %d\n", arr_f[i], ret);
  }

  exit(0);
}
