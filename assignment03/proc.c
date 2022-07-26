#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct PTABLE {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct _xem_t {
  struct spinlock lock;
  int value;
};

struct _rwlock_t {
  xem_t lock;
  xem_t writelock;
  int readers;
};

static struct proc *initproc;

int nextpid = 1;
int nextthd = 1;
int thd_cnt = 0;
int stack_st[NPROC*30];

extern void forkret(void);
extern void trapret(void);

extern struct proc* select_and_run(struct cpu*);
extern void init_process(struct proc*);
extern int enqueue_to_mlfq(struct proc*);
extern int enqueue_to_sq(struct proc*);

extern struct queue mlfq;

static void wakeup1(void *chan);

int
xem_init(xem_t *semaphore)
{
  semaphore->value = 1;
  return 0;
}

int
xem_wait(xem_t *semaphore)
{
  acquire(&semaphore->lock);
  semaphore->value--;
  while(semaphore->value < 0)
	sleep((void *)semaphore, &semaphore->lock);
  release(&semaphore->lock);
  return 0;
}

int xem_unlock(xem_t *semaphore)
{
  acquire(&semaphore->lock);
  semaphore->value++;
  if(semaphore->value <= 0)
	wakeup((void *)semaphore);
  release(&semaphore->lock);
  return 0;
}

int
rwlock_init(rwlock_t *rwlock)
{
  xem_init(&rwlock->lock);
  xem_init(&rwlock->writelock);
  rwlock->readers = 0;
  return 0;
}

int
rwlock_acquire_readlock(rwlock_t *rwlock)
{
  xem_wait(&rwlock->lock);
  rwlock->readers++;
  if(rwlock->readers == 1)
	xem_wait(&rwlock->writelock);
  xem_unlock(&rwlock->lock);
  return 0;
}

int
rwlock_release_readlock(rwlock_t *rwlock)
{
  xem_wait(&rwlock->lock);
  rwlock->readers--;
  if(rwlock->readers == 0)
	xem_unlock(&rwlock->writelock);
  xem_unlock(&rwlock->lock);
  return 0;
}

int
rwlock_acquire_writelock(rwlock_t *rwlock)
{
  xem_wait(&rwlock->writelock);
  return 0;
}

int
rwlock_release_writelock(rwlock_t *rwlock)
{
  xem_unlock(&rwlock->writelock);
  return 0;
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);

  init_process(p);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  // Make multiple threads do not influence each other by locking
  acquire(&ptable.lock);

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }

  release(&ptable.lock);

  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  
  release(&ptable.lock);

  init_process(np);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // clear all threads of current process
  if(curproc->is_thread == 0) {
	  for(p=ptable.proc; p<&ptable.proc[NPROC]; ++p) {
		if(!p || p->is_thread == 0 || p->pid != curproc->pid)
			continue;

		deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);

		kfree(p->kstack);
		p->kstack = 0;
		p->sz = 0;
		p->state = UNUSED;
		p->pid = 0;
		p->parent = 0;
		p->killed = 0;
		p->name[0] = 0;

		p->tickets = 0;
		p->lev = 0;
		p->in_mlfq = 0;

		stack_st[p->stack_id] = 0;

		p->is_thread = 0;
		p->tid = 0;
		p->master = 0;
		p->stack = 0;
		p->stack_id = 0;
		p->used_all_time = 0;

		p->ret_val = 0;

		--thd_cnt;
		p->master->tcnt--;
	  }
  }

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();

  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

struct proc*
select_thread(struct proc* mp)
{
  struct proc *p;
  int i, searched = mp->master->searched;

  // no thread is alive
  if(thd_cnt == 0)
	return 0;

  // select next thread of master process
  for(i=0; i<NPROC; ++i) {
	if(i == searched && thd_cnt > 1)
		continue;

	p = &ptable.proc[i];
	
	if(!p || p->is_thread == 0 || p->pid != mp->master->pid || p->state != RUNNABLE)
		continue;

	mp->master->searched = i;

	return p;
  }

  // if no process was matched, return 0.
  return 0;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct cpu *c = mycpu();
  struct proc *sleep_p = 0, *thd = 0;

  c->proc = 0;
 
  for(;;){
    // Enable interrupts on this processor.
    sti();

    acquire(&ptable.lock);

    sleep_p = select_and_run(c);

    if(sleep_p && thd_cnt > 0) {
	// search thread of sleep_p which is not scheduled by select_and_run()
	thd = select_thread(sleep_p);

	if(thd) {
		c->proc = thd;
		switchuvm(thd);
		thd->state = RUNNING;

		swtch(&(c->scheduler), thd->context);
		switchkvm();

		if(thd->in_mlfq) enqueue_to_mlfq(thd);
		else enqueue_to_sq(thd);
	}
    }

    c->proc = 0;

    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
  struct proc *np;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");

  intena = mycpu()->intena;

  if(p->master->used_all_time) {
	p->master->used_all_time = 0;
	swtch(&p->context, mycpu()->scheduler);
  } else {
	if(p->is_thread) {
		np = thd_cnt > 0 ? select_thread(p->master) : 0;

		if(!np) {
			swtch(&p->context, mycpu()->scheduler);
		} else {

			//run thread
			mycpu()->proc = np;
			switchuvm(np);
			np->state = RUNNING;

			swtch(&p->context, np->context);

		}

	} else {
		swtch(&p->context, mycpu()->scheduler);
	}
  }

  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  sched();

  // Tidy up.
  p->chan = 0;
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan) {
      p->state = RUNNABLE;
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    // The threads have same pid which master process has
    // So the threads are killed in here
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);

  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
thread_create(thread_t *thread, void *(*start_routine)(void*), void *arg)
{
  struct proc *curproc = myproc();
  struct proc *np;
  uint sp, ustack[2];
  int i, sidx = -1;

  if((np = allocproc()) == 0) {
	return -1;
  }

  acquire(&ptable.lock);

  for(i=0; i<NPROC*30; i++) {
	if(stack_st[i])
		continue;

	stack_st[i] = 1;
	sidx = i;	

	break;
  }

  if(sidx == -1)
	panic("cannot allocate stack");

  np->stack_id = sidx++;
  np->stack = curproc->master->sz + (uint)(2*PGSIZE * sidx);

  np->tickets = curproc->master->tickets;
  np->lev = 0;
  np->in_mlfq = curproc->master->in_mlfq;

  np->pid = curproc->master->pid;
  np->tid = nextthd++;
  np->is_thread = 1;
  np->master = curproc->master;
  np->pgdir = curproc->master->pgdir;
  *np->tf = *curproc->master->tf;
  np->cwd = curproc->master->cwd;  

  *thread = np->tid;

  if((np->sz = allocuvm(np->pgdir, np->stack, np->stack + 2*PGSIZE)) == 0) {
	panic("cannot allocate ustack");
	np->state = UNUSED;
	return -1;
  }

  clearpteu(np->pgdir, (char*)(np->master->sz - 2*PGSIZE));

  sp = np->sz;
  sp -= 8;
  ustack[0] = 0xffffffff;
  ustack[1] = (uint)arg;
  
  if(copyout(np->pgdir, sp, ustack, 8) < 0) {
	panic("cannot copy ustack");
	return -1;
  }

  np->tf->eip = (uint)start_routine;
  np->tf->esp = sp;

  for(i=0; i<NOFILE; i++)
	if(np->master->ofile[i])
		np->ofile[i] = filedup(np->master->ofile[i]);

  safestrcpy(np->name, np->master->name, sizeof(np->master->name));
  
  np->state = RUNNABLE;
  thd_cnt++;
  curproc->master->tcnt++;
  curproc->master->made_thd = 1;

  release(&ptable.lock);

  return 0;
}

void
thread_exit(void *retval)
{
  if(thd_cnt <= 0) return;

  acquire(&ptable.lock);

  struct proc *curproc = myproc();
  int fd;

  for(fd=0; fd<NOFILE; fd++)
	if(curproc->ofile[fd])
		curproc->ofile[fd] = 0;

  curproc->cwd = 0;

  // wake up sleeping thread in thread_join()
  wakeup1(curproc->master);

  curproc->state = ZOMBIE;
  curproc->ret_val = retval;
  curproc->master->tcnt--;
  thd_cnt--;

  sched();

  panic("exit ZOMBIE thread");
}

int
thread_join(thread_t thread, void **retval)
{
  struct proc *curproc = myproc();
  struct proc *p;

  if(curproc->master != curproc)
	return -1;

  acquire(&ptable.lock);

  for(;;) {
	 // find expected thread
	 for(p=ptable.proc; p<&ptable.proc[NPROC]; p++) {
		if(p->tid != thread || p->is_thread == 0 || curproc->pid != p->pid || p->state != ZOMBIE)
			continue;

		*retval = p->ret_val;
		p->ret_val = 0;

		deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);
		kfree(p->kstack);
		p->kstack = 0;
		p->sz = 0;
		p->state = UNUSED;
		p->pid = 0;
		p->parent = 0;
		p->killed = 0;
		p->name[0] = 0;

		p->tickets = 0;
		p->lev = 0;
		p->in_mlfq = 0;

		stack_st[p->stack_id] = 0;

		p->is_thread = 0;	
		p->tid = 0;
		p->master = 0;
		p->stack = 0;
		p->stack_id = 0;
		p->used_all_time = 0;

		release(&ptable.lock);		
		return 0;
	  }

	  // master process is termineted
	  if(curproc->killed) {
		release(&ptable.lock);
		return -1;
	  }

	  sleep(curproc, &ptable.lock);
  }

  release(&ptable.lock);
  return -1;
}
