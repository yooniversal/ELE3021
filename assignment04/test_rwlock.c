#include "types.h"
#include "stat.h"
#include "user.h"

xem_t sem;
rwlock_t rwlock;
int readerElapsedTicks;
int writerElapsedTicks;

#define REP 50
#define NTHREADS 10
#define READERS_RATIO 0.9

void * reader_with_rwlock(void *arg);
void * writer_with_rwlock(void *arg);
void * reader2_with_sem(void *arg);
void * writer2_with_sem(void *arg);
void * reader2_with_rwlock(void *arg);
void * writer2_with_rwlock(void *arg);

void test1(void);
void test2(void);

int
main(int argc, char *argv[])
{
  xem_init(&sem);
  rwlock_init(&rwlock);

  /* TEST for checking lock acquisition order */
  test1();

  /* TEST for efficiency of performance of RW lock */
  test2();

  exit();
}

void
test1(void)
{
  thread_t t[NTHREADS];
  void *ret;

  printf(1, "1. Logging the lock acquisition of a RW lock\n");
  for(int i = 0; i < NTHREADS; ++i) {
    void* (*start_routine)(void *) = i >= READERS_RATIO * NTHREADS ? writer_with_rwlock : reader_with_rwlock;
    if(thread_create(&t[i], start_routine, (void *)(i)) < 0) {
      printf(1, "panic at thread create\n");
      exit();
    }
  }
  for(int i = 0; i < NTHREADS; ++i) {
    if(thread_join(t[i], &ret) < 0) {
      printf(1, "panic at thread join\n");
      exit();
    }
  }
}

void
test2(void)
{
  thread_t t[NTHREADS];
  void *ret;
  int readerResults[2];
  int writerResults[2];

  printf(1, "2. Lock Efficiency Test\n");
  printf(1, "\ta. Using a simple binary semaphore\n");

  readerElapsedTicks = 0;
  writerElapsedTicks = 0;
  for(int i = 0; i < NTHREADS; ++i) {
    void* (*start_routine)(void *) = i >= READERS_RATIO * NTHREADS ? writer2_with_sem : reader2_with_sem;
    if(thread_create(&t[i], start_routine, (void *)(i)) < 0) {
      printf(1, "panic at thread create\n");
      exit();
    }
  }
  for(int i = 0; i < NTHREADS; ++i) {
    if(thread_join(t[i], &ret) < 0) {
      printf(1, "panic at thread join\n");
      exit();
    }
  }
  readerResults[0] = readerElapsedTicks;
  writerResults[0] = writerElapsedTicks;
  
  printf(1, "\tb. Using a readers-writer lock\n");
  readerElapsedTicks = 0;
  writerElapsedTicks = 0;
  for(int i = 0; i < NTHREADS; ++i) {
    void* (*start_routine)(void *) = i >= READERS_RATIO * NTHREADS ? writer2_with_rwlock : reader2_with_rwlock;
    if(thread_create(&t[i], start_routine, (void *)(i)) < 0) {
      printf(1, "panic at thread create\n");
      exit();
    }
  }
  for(int i = 0; i < NTHREADS; ++i) {
    if(thread_join(t[i], &ret) < 0) {
      printf(1, "panic at thread join\n");
      exit();
    }
  }
  readerResults[1] = readerElapsedTicks;
  writerResults[1] = writerElapsedTicks;

  printf(1, "\n\tReader Elapsed Ticks 2-a) %d ticks\t2-b) %d ticks\n", readerResults[0], readerResults[1]);
  printf(1, "\tWriter Elapsed Ticks 2-a) %d ticks\t2-b) %d ticks\n", writerResults[0], writerResults[1]);
}

void *
reader_with_rwlock(void *arg)
{
  int id = (int)arg;

  for(int rep = 0; rep < REP; ++rep) {
    rwlock_acquire_readlock(&rwlock);
    xem_wait(&sem);
    printf(1, "Reader Accquired %d\n", id);
    xem_unlock(&sem);
    rwlock_release_readlock(&rwlock);
  }

  thread_exit(0);
  return 0;
}

void *
writer_with_rwlock(void *arg)
{
  int id = (int)arg;

  for(int rep = 0; rep < REP; ++rep) {
    rwlock_acquire_writelock(&rwlock);
    
    xem_wait(&sem);
    printf(1, "Writer Accquired %d\n", id);
    xem_unlock(&sem);

    volatile int n = 0;
    while(++n < 10000000); // Do something

    xem_wait(&sem);
    printf(1, "Writer Released %d\n", id);
    xem_unlock(&sem);

    rwlock_release_writelock(&rwlock);
  }

  thread_exit(0);
  return 0;
}

volatile int data[10000];

void *
reader2_with_sem(void *arg)
{
  int sum;

  for(int rep = 0; rep < REP; ++rep) {
    sum = 0;
    int startTick = uptime();
    xem_wait(&sem);
    for(int i = 0; i < 10000; ++i)
      sum += data[i];
    if(!(sum == 0 || sum == 5000 * 10001))
      printf(1, "Race detected\n");
    xem_unlock(&sem);
    int elapsedTick = uptime() - startTick;
    __sync_add_and_fetch(&readerElapsedTicks, elapsedTick);
  }

  thread_exit(0);
  return 0;
}

void *
writer2_with_sem(void *arg)
{
  int id = (int)arg;

  for(int rep = 0; rep < REP; ++rep) {
    int startTick = uptime();
    if(id % 2 == 0){
      xem_wait(&sem);
      for(int i = 0; i < 10000; ++i)
        data[i] = i + 1;
      xem_unlock(&sem);
    }else{
      xem_wait(&sem);
      for(int i = 0; i < 10000; ++i)
        data[i] = 10000 - i;
      xem_unlock(&sem);
    }
    int elapsedTick = uptime() - startTick;
    __sync_add_and_fetch(&writerElapsedTicks, elapsedTick);
  }

  thread_exit(0);
  return 0;
}

void *
reader2_with_rwlock(void *arg)
{
  int sum;

  for(int rep = 0; rep < REP; ++rep) {
    sum = 0;
    int startTick = uptime();
    rwlock_acquire_readlock(&rwlock);
    for(int i = 0; i < 10000; ++i)
      sum += data[i];
    if(!(sum == 0 || sum == 5000 * 10001))
      printf(1, "Race detected\n");
    rwlock_release_readlock(&rwlock);
    int elapsedTick = uptime() - startTick;
    __sync_add_and_fetch(&readerElapsedTicks, elapsedTick);
  }

  thread_exit(0);
  return 0;
}

void *
writer2_with_rwlock(void *arg)
{
  int id = (int)arg;

  for(int rep = 0; rep < REP; ++rep) {
    int startTick = uptime();
    if(id % 2 == 0){
      rwlock_acquire_writelock(&rwlock);
      for(int i = 0; i < 10000; ++i)
        data[i] = i + 1;
      rwlock_release_writelock(&rwlock);
    }else{
      rwlock_acquire_writelock(&rwlock);
      for(int i = 0; i < 10000; ++i)
        data[i] = 10000 - i;
      rwlock_release_writelock(&rwlock);
    }
    int elapsedTick = uptime() - startTick;
    __sync_add_and_fetch(&writerElapsedTicks, elapsedTick);
  }

  thread_exit(0);
  return 0;
}
