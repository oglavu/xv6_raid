
// Test purpose: parallel raid operations

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

typedef struct command_t {
  char *path;
  char **argv;
} command_t;

int main(int argc, char *argv[]) {

  char *path1 = "/populate_test";
  char *argv1[4] = {"populate_test", "5", "0", 0};

  char *path2 = "/consistency_test";
  char *argv2[4] = {"consistency_test", "5", "0", 0};

  char *path3 = "/fr_test";
  char *argv3[5] = {"fr_test", "5", "o", "2", 0};

  struct command_t commands[] = {
    {path1, argv1},
    {path2, argv2},
    {path3, argv3}
  };

  static const int N = sizeof(commands)/sizeof(command_t);
  for (int i=0; i<N; ++i) {
    int pid = fork();

    if (pid < 0) {
      printf("Couldnt start process\n");
    } else if (pid == 0) {
      // child
      printf("Starting child: %\n", pid);
      exec(commands[i].path, commands[i].argv);
      exit(0);
    }
  }

  printf("Waiting...\n");
  for (int i=0; i<N; ++i) {
    wait(0);
    printf("Child finished.\n");
  }

  exit(0);
}

