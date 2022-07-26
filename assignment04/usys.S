#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(my_syscall)
SYSCALL(getppid)
SYSCALL(yield)
SYSCALL(set_cpu_share)
SYSCALL(getlev)
SYSCALL(thread_create)
SYSCALL(thread_exit)
SYSCALL(thread_join)
SYSCALL(xem_init)
SYSCALL(xem_wait)
SYSCALL(xem_unlock)
SYSCALL(rwlock_init)
SYSCALL(rwlock_acquire_readlock)
SYSCALL(rwlock_release_readlock)
SYSCALL(rwlock_acquire_writelock)
SYSCALL(rwlock_release_writelock)
SYSCALL(pread)
SYSCALL(pwrite)
