#include "types.h"
#include "stat.h"
#include "user.h"

#define LARGENUM 10000000

xem_t sem1;
//xem_t sem2;

void nop(){ }

void *
test_without_sem(void *arg)
{
  int denominator = (LARGENUM / 10);
  int id = (int)arg;
  for(int i = 0; i < LARGENUM; ++i) {
	asm volatile("call %P0"::"i"(nop));
	if(i == (i / denominator) * denominator) {
	  printf(1, "%d", id % 10);
	}
  }
  thread_exit(0);
  return 0;
}


void *
test_with_sem1(void *arg)
{
  int denominator = (LARGENUM / 10);
  int id = (int)arg;
  xem_wait(&sem1);
  for(int i = 0; i < LARGENUM; ++i) {
	asm volatile("call %P0"::"i"(nop));
	if(i == (i / denominator) * denominator) {
	  printf(1, "%d", id % 10);
	}
  }
  xem_unlock(&sem1);
  thread_exit(0);
  return 0;
}

/*
void *
test_with_sem2(void *arg)
{
  int denominator = (LARGENUM / 10);
  int id = (int)arg;
  xem_wait(&sem2);
  for(int i = 0; i < LARGENUM; ++i) {
	asm volatile("call %P0"::"i"(nop));
	if(i == (i / denominator) * denominator) {
	  printf(1, "%d", id % 10);
	}
  } 
  xem_unlock(&sem2);
  thread_exit(0);
  return 0;
}
*/

int
main(int argc, char *argv[])
{
  void *ret;
  const int N = 10;
  thread_t t[N];

  for(int u = 0; u < 3; u++) {
    printf(1, "1. Test without any synchronization\n");
	for(int i = 0; i < N; ++i) {
	  if(thread_create(&t[i], test_without_sem, (void*)(i)) < 0) {
		printf(1, "panic at thread create\n");
		exit();
	  }
	}
    for(int i = 0; i < N; ++i) {
	  if(thread_join(t[i], &ret) < 0) {
	    printf(1, "panic at thread join\n");
	    exit();
	  }
	}
	printf(1, "\nIts sequence could be mixed\n");
  }

  printf(1, "2. Test with synchronization of a binary semaphore\n");
  xem_init(&sem1);
  xem_wait(&sem1);
  for(int i = 0; i < N; ++i) {
    if(thread_create(&t[i], test_with_sem1, (void*)(i)) < 0) {
      printf(1, "panic at thread create\n");
      exit();
    }
  }
  printf(1, "create done\n");
  xem_unlock(&sem1);
  for(int i = 0; i < N; ++i) {
    if(thread_join(t[i], &ret) < 0) {
      printf(1, "panic at thread join\n");
      exit();
    }
  }
  printf(1, "\nIts sequence must be sorted\n");
  
  // Code below is test for sem with init value over 1. 
  // Because our xem_t api doesn't have set initial value
  // of semaphore, this part can be ignored and setting
  // an initial value of xem_t is not right way.
/*
  printf(1, "3. Test with synchronization of a semaphore with 3 users\n");
  xem_init(&sem2);
  
  // These two lines below are not right way. 
  // (Just cheat to set initial value of semaphore)
  sem2.val = 3; 
  sem2.init_val = 3;
  xem_wait(&sem2);
  for(int i = 0; i < N; ++i) {
    if(thread_create(&t[i], test_with_sem2, (void*)(i)) < 0) {
      printf(1, "panic at thread create\n");
      exit();
    }
  }
  xem_unlock(&sem2);
  for(int i = 0; i < N; ++i) {
    if(thread_join(t[i], &ret) < 0) {
      printf(1, "panic at thread join\n");
      exit();
    }
  }
  printf(1, "\nIts sequence could be messy\n");
*/
  exit();

}
