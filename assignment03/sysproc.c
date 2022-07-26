#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getppid(void)
{
  return myproc()->parent->pid;
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_yield(void)
{
  yield();

  return 0;
}

int
sys_set_cpu_share(void)
{
	int share;
	if(argint(0, &share) < 0)
		return -1;

	return set_cpu_share(share);
}

int
sys_getlev(void)
{
	return getlev();
}

int
sys_thread_create(void)
{
  int thread;
  int start_routine;
  int arg;

  if((argint(0, &thread) < 0) || (argint(1, &start_routine) < 0) || (argint(2, &arg) < 0))
	return -1;

  return thread_create((thread_t*)thread, (void *)start_routine, (void *)arg);
}

int
sys_thread_exit(void)
{
  int retval;

  if(argint(0, &retval) < 0)
	return -1;

  thread_exit((void *)retval);

  return 0;
}

int
sys_thread_join(void)
{
  int thread;
  int retval;

  if((argint(0, &thread) < 0) || (argint(1, &retval) < 0))
	return -1;

  return thread_join((thread_t)thread, (void **)retval);
}

int
sys_xem_init(void)
{
  int semaphore;

  if(argint(0, &semaphore) < 0)
	return -1;

  return xem_init((xem_t *)semaphore);
}

int
sys_xem_wait(void)
{
  int semaphore;

  if(argint(0, &semaphore) < 0)
	return -1;

  return xem_wait((xem_t *)semaphore);
}

int
sys_xem_unlock(void)
{
  int semaphore;

  if(argint(0, &semaphore) < 0)
	return -1;

  return xem_unlock((xem_t *)semaphore);
}

int
sys_rwlock_init(void)
{
  int rwlock;

  if(argint(0, &rwlock) < 0)
	return -1;

  return rwlock_init((rwlock_t *)rwlock);
}

int
sys_rwlock_acquire_readlock(void)
{
  int rwlock;

  if(argint(0, &rwlock) < 0)
	return -1;

  return rwlock_acquire_readlock((rwlock_t *)rwlock);
}

int
sys_rwlock_release_readlock(void)
{
  int rwlock;

  if(argint(0, &rwlock) < 0)
	return -1;

  return rwlock_release_readlock((rwlock_t *)rwlock);
}

int
sys_rwlock_acquire_writelock(void)
{
  int rwlock;

  if(argint(0, &rwlock) < 0)
	return -1;

  return rwlock_acquire_writelock((rwlock_t *)rwlock);
}

int
sys_rwlock_release_writelock(void)
{
  int rwlock;

  if(argint(0, &rwlock) < 0)
	return -1;

  return rwlock_release_writelock((rwlock_t *)rwlock);
}

