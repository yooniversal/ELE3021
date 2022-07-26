#include "types.h"
#include "defs.h"
#include "stat.h"
#include "param.h"
#include "spinlock.h"

/*
struct _xem_t {
  struct spinlock lock;
  int value;
};

struct _rwlock_t {
  xem_t lock;
  xem_t writelock;
  int readers;
};
*/

extern int rwlock_init(rwlock_t*);
extern int rwlock_acquire_readlock(rwlock_t*);
extern int rwlock_release_readlock(rwlock_t*);
extern int rwlock_acquire_writelock(rwlock_t*);
extern int rwlock_release_writelock(rwlock_t*);
extern int pread(int, void*, int, int);
extern int pwrite(int, void*, int, int);
extern void *malloc(uint);
extern void free(void*);

typedef struct _thread_safe_guard {
  int fd;
  rwlock_t rwlock;
} thread_safe_guard;

thread_safe_guard*
thread_safe_guard_init(int fd)
{
  thread_safe_guard *guard = (thread_safe_guard*)malloc(sizeof(thread_safe_guard));
  guard->fd = fd;
  rwlock_init(&guard->rwlock);
  
  return guard;
}

int
thread_safe_pread(thread_safe_guard *file_guard, void *addr, int n, int off)
{
  rwlock_acquire_readlock(&file_guard->rwlock);
  int ret = pread(file_guard->fd, addr, n, off);
  rwlock_release_readlock(&file_guard->rwlock);

  return ret;
}

int
thread_safe_pwrite(thread_safe_guard *file_guard, void *addr, int n, int off)
{
  rwlock_acquire_writelock(&file_guard->rwlock);
  int ret = pwrite(file_guard->fd, addr, n, off);
  rwlock_release_writelock(&file_guard->rwlock);

  return ret;
}

void
thread_safe_guard_destroy(thread_safe_guard *file_guard)
{
  free(file_guard);
}
