#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{

  int pid, ppid;
  pid = getpid();
  ppid = getppid();

  printf(1, "getpid  : %d\n", pid);
  printf(1, "getppid : %d\n", ppid);

  exit();
}
