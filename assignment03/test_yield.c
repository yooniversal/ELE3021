#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{

  int i, pid;  
  for(i=0; i<10; i++)
  {
	  pid = fork();
	  yield();

	  if(pid < 0)
	  {
		  printf(1, "fork failed\n");
		  exit();
	  }
	  if(pid > 0)
	  {		
		
		wait();			
		printf(1, "Parent\n");
  	  }
	  if(pid == 0)
	  {
		  printf(1, "Child\n");  
		  exit();
	  }
  }

  exit();
}
