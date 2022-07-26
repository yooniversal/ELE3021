typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;
typedef uint thread_t;
//typedef struct _xem_t xem_t;
//typedef struct _rwlock_t rwlock_t;

#ifndef SPINLOCK__H_
#define SPINLOCK__H_
struct spinlock {
  uint locked;
  char *name;
  struct cpu *cpu;
  uint pcs[10];
};
#endif

typedef struct _xem_t {
  struct spinlock lock;
  int value;
} xem_t;

typedef struct _rwlock_t {
  xem_t lock;
  xem_t writelock;
  int readers;
} rwlock_t;

