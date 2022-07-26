#include "types.h"
#include "defs.h"
#include "stat.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"

extern struct proc* myproc(void);
extern void switchuvm(struct proc*);
extern void switchkvm(void);
extern void swtch(struct context**, struct context*);

struct queue mlfq = {{0}, TOTAL_TICKETS, 0, 0};
struct queue sq = {{0}, 0, 0, 0};

int
getlev(void)
{
  if(myproc()->in_mlfq)
	return myproc()->lev;

  return -1;
}

void
priority_boost(void)
{
  struct proc *p;

  for(p=mlfq.ps[1]; p<=mlfq.ps[mlfq.cnt]; p++) {
	if(!p || p->state != RUNNABLE)
		continue;
	
	p->lev = 0;
	p->used_time = 0;
  }

  mlfq.used_time = 0;
}

int
enqueue_to_mlfq(struct proc* p)
{
  if(mlfq.cnt >= NPROC)
	return -1;

  int idx;
  idx = ++mlfq.cnt;

  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
  	mlfq.ps[idx] = mlfq.ps[idx/2];
	idx /= 2;
  }

  mlfq.ps[idx] = p;

  return 1;
}

struct proc*
dequeue_from_mlfq(void)
{
  if(mlfq.cnt <= 0)
	return 0;

  struct proc *p;
  struct proc *tmp;
  int parent;
  int child;

  p = mlfq.ps[1];
  mlfq.ps[1] = mlfq.ps[mlfq.cnt--];
  tmp = mlfq.ps[1];

  parent = 1;
  child = parent*2;

  while(child <= mlfq.cnt) {
	if((child < mlfq.cnt) && (mlfq.ps[child]->lev > mlfq.ps[child+1]->lev))
		child++;

	if(tmp->lev <= mlfq.ps[child]->lev)
		break;

	mlfq.ps[parent] = mlfq.ps[child];
	parent = child;
	child *= 2;
  }

  mlfq.ps[parent] = tmp;

  return p;
}

int
enqueue_to_sq(struct proc* p)
{
  if(sq.cnt >= NPROC)
	return -1;

  int idx;
  idx = ++sq.cnt;

  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
  	sq.ps[idx] = sq.ps[idx/2];
	idx /= 2;
  }

  sq.ps[idx] = p;

  return 1;
}

struct proc*
dequeue_from_sq(void)
{
  if(sq.cnt <= 0)
	return 0;

  struct proc *p;
  int parent;
  int child;

  p = sq.ps[1];
  sq.ps[1] = sq.ps[sq.cnt--];
  parent = 1;
  child = parent*2;

  while (1) {
	child = parent*2;

	if(child+1 <= sq.cnt && sq.ps[child]->pass > sq.ps[child+1]->pass)
		child++;

	if(child > sq.cnt || sq.ps[child]->pass > sq.ps[parent]->pass)
		break;

	struct proc *tmp;
	tmp = sq.ps[parent];
	sq.ps[parent] = sq.ps[child];
	sq.ps[child] = tmp;
	parent = child;
  }

  return p;
}

double
get_min_pass(void)
{
  if(mlfq.cnt <= 0 && sq.cnt <= 0)
	return 0;

  double min_pass;
  min_pass = 987654321.0;

  struct proc *p;

  for(p=sq.ps[1]; p<=sq.ps[sq.cnt]; p++) {
	if(!p || p->state != RUNNABLE)
		continue;
	
	if(min_pass > p->pass) {
		min_pass = p->pass;
	}
  }

  for(p=mlfq.ps[1]; p<=mlfq.ps[mlfq.cnt]; p++) {
	if(!p || p->state != RUNNABLE)
		continue;
	
	if(min_pass > p->pass) {
		min_pass = p->pass;
	}
  }

  if(min_pass == 987654321.0)
	return 0;

  return min_pass;
}

int
set_cpu_share(int share)
{
  if(sq.cnt >= NPROC || share <= 0)
	return -1;
  
  struct proc *p;
  int cur_t;

  int mlfq_sum;
  int sq_sum;
  
  p = myproc();
  cur_t = TOTAL_TICKETS * share / 100;

  mlfq_sum = mlfq.tickets - cur_t;
  sq_sum = sq.tickets + cur_t;

  if((mlfq_sum * 100.0 / TOTAL_TICKETS < 20.0) || (sq_sum * 100.0 / TOTAL_TICKETS > 80.0))
	return -1;

  // Initialize process
  p->tickets = cur_t;
  p->lev = 3;
  p->used_time = 0;
  p->in_mlfq = 0;
  p->pass = get_min_pass();
  p->stride = TOTAL_TICKETS / cur_t;
  enqueue_to_sq(p);

  mlfq.tickets = mlfq_sum;
  sq.tickets = sq_sum;

  mlfq.cnt--;

  return 0;
}

void
select_and_run(struct cpu *c)
{
  struct proc *mp;
  struct proc *sp;

  mp = dequeue_from_mlfq();
  sp = dequeue_from_sq();

  if(mp)
	mp->stride = TOTAL_TICKETS / mlfq.tickets;

  if((mp && mp->state == RUNNABLE) && (sp && sp->state == RUNNABLE)) {
	if(mp->pass <= sp->pass) {
		c->proc = mp;
		switchuvm(mp);
		mp->state = RUNNING;
		
		swtch(&(c->scheduler), mp->context);
		switchkvm();
		
		c->proc = 0;
	} else {
		c->proc = sp;
		switchuvm(sp);
		sp->state = RUNNING;
		
		swtch(&(c->scheduler), sp->context);
		switchkvm();

		c->proc = 0;
	}

	enqueue_to_mlfq(mp);
	enqueue_to_sq(sp);

  } else if((mp && mp->state == RUNNABLE) && (!sp || sp->state != RUNNABLE)) {
	c->proc = mp;
	switchuvm(mp);
	mp->state = RUNNING;
	
	swtch(&(c->scheduler), mp->context);
	switchkvm();

	enqueue_to_mlfq(mp);
	if(sp && sp->state == SLEEPING) {
		sp->pass = sq.ps[sq.cnt]->pass;
		enqueue_to_sq(sp);
	}

	c->proc = 0;

  } else if((!mp || mp->state != RUNNABLE) && (sp && sp->state == RUNNABLE)) {
	c->proc = sp;
	switchuvm(sp);
	sp->state = RUNNING;
	
	swtch(&(c->scheduler), sp->context);
	switchkvm();
	
	c->proc = 0;

	enqueue_to_sq(sp);
	if(mp && mp->state == SLEEPING) {
		mp->lev = 2;
		mp->used_time = 0;
		enqueue_to_mlfq(mp);		
	}


  } else {
	if(mp && mp->state == SLEEPING) {
		mp->lev = 2;
		mp->used_time = 0;
		enqueue_to_mlfq(mp);
	}

	if(sp && sp->state == SLEEPING) {
		sp->pass = sq.ps[sq.cnt]->pass;
		enqueue_to_sq(sp);
	}
  }

}

void
init_process(struct proc* p)
{
	p->tickets = mlfq.tickets; 
	p->lev = 0;
	p->used_time = 0;
	p->in_mlfq = 1;
	p->pass = get_min_pass();
	p->stride = TOTAL_TICKETS / mlfq.tickets;

	enqueue_to_mlfq(p);
}
