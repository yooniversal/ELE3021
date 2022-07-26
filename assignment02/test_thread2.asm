
_test_thread2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stridetest",
};

int
main(int argc, char *argv[])
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	57                   	push   %edi
       e:	56                   	push   %esi
       f:	53                   	push   %ebx
      10:	51                   	push   %ecx
      11:	83 ec 18             	sub    $0x18,%esp
      14:	8b 31                	mov    (%ecx),%esi
      16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  if (argc >= 2)
      19:	83 fe 01             	cmp    $0x1,%esi
      1c:	0f 8f eb 00 00 00    	jg     10d <main+0x10d>
  int end = NTEST-1;
      22:	be 0d 00 00 00       	mov    $0xd,%esi
  int start = 0;
      27:	31 db                	xor    %ebx,%ebx
      write(gpipe[1], (char*)&ret, sizeof(ret));
      close(gpipe[1]);
      exit();
    } else{
      close(gpipe[1]);
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
      29:	8d 7d e4             	lea    -0x1c(%ebp),%edi
      2c:	e9 9e 00 00 00       	jmp    cf <main+0xcf>
      31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = 0;
      38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if ((pid = fork()) < 0){
      3f:	e8 86 13 00 00       	call   13ca <fork>
      44:	85 c0                	test   %eax,%eax
      46:	0f 88 10 01 00 00    	js     15c <main+0x15c>
    if (pid == 0){
      4c:	0f 84 1d 01 00 00    	je     16f <main+0x16f>
      close(gpipe[1]);
      52:	83 ec 0c             	sub    $0xc,%esp
      55:	ff 35 ac 23 00 00    	pushl  0x23ac
      5b:	e8 9a 13 00 00       	call   13fa <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
      60:	e8 75 13 00 00       	call   13da <wait>
      65:	83 c4 10             	add    $0x10,%esp
      68:	83 f8 ff             	cmp    $0xffffffff,%eax
      6b:	0f 84 d2 00 00 00    	je     143 <main+0x143>
      71:	83 ec 04             	sub    $0x4,%esp
      74:	6a 04                	push   $0x4
      76:	57                   	push   %edi
      77:	ff 35 a8 23 00 00    	pushl  0x23a8
      7d:	e8 68 13 00 00       	call   13ea <read>
      82:	83 c4 10             	add    $0x10,%esp
      85:	83 f8 ff             	cmp    $0xffffffff,%eax
      88:	0f 84 b5 00 00 00    	je     143 <main+0x143>
      8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      91:	85 c0                	test   %eax,%eax
      93:	0f 85 aa 00 00 00    	jne    143 <main+0x143>
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
      99:	83 ec 0c             	sub    $0xc,%esp
      9c:	ff 35 a8 23 00 00    	pushl  0x23a8
      a2:	e8 53 13 00 00       	call   13fa <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
      a7:	ff 34 9d 20 23 00 00 	pushl  0x2320(,%ebx,4)
      ae:	53                   	push   %ebx
  for (i = start; i <= end; i++){
      af:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%d. %s finish\n", i, testname[i]);
      b2:	68 54 1a 00 00       	push   $0x1a54
      b7:	6a 01                	push   $0x1
      b9:	e8 a2 14 00 00       	call   1560 <printf>
    sleep(100);
      be:	83 c4 14             	add    $0x14,%esp
      c1:	6a 64                	push   $0x64
      c3:	e8 9a 13 00 00       	call   1462 <sleep>
  for (i = start; i <= end; i++){
      c8:	83 c4 10             	add    $0x10,%esp
      cb:	39 f3                	cmp    %esi,%ebx
      cd:	7f 6f                	jg     13e <main+0x13e>
    printf(1,"%d. %s start\n", i, testname[i]);
      cf:	ff 34 9d 20 23 00 00 	pushl  0x2320(,%ebx,4)
      d6:	53                   	push   %ebx
      d7:	68 20 1a 00 00       	push   $0x1a20
      dc:	6a 01                	push   $0x1
      de:	e8 7d 14 00 00       	call   1560 <printf>
    if (pipe(gpipe) < 0){
      e3:	c7 04 24 a8 23 00 00 	movl   $0x23a8,(%esp)
      ea:	e8 f3 12 00 00       	call   13e2 <pipe>
      ef:	83 c4 10             	add    $0x10,%esp
      f2:	85 c0                	test   %eax,%eax
      f4:	0f 89 3e ff ff ff    	jns    38 <main+0x38>
      printf(1,"pipe panic\n");
      fa:	53                   	push   %ebx
      fb:	53                   	push   %ebx
      fc:	68 2e 1a 00 00       	push   $0x1a2e
     101:	6a 01                	push   $0x1
     103:	e8 58 14 00 00       	call   1560 <printf>
      exit();
     108:	e8 c5 12 00 00       	call   13d2 <exit>
    start = atoi(argv[1]);
     10d:	83 ec 0c             	sub    $0xc,%esp
     110:	ff 77 04             	pushl  0x4(%edi)
     113:	e8 48 12 00 00       	call   1360 <atoi>
  if (argc >= 3)
     118:	83 c4 10             	add    $0x10,%esp
     11b:	83 fe 02             	cmp    $0x2,%esi
    start = atoi(argv[1]);
     11e:	89 c3                	mov    %eax,%ebx
  if (argc >= 3)
     120:	0f 84 86 00 00 00    	je     1ac <main+0x1ac>
    end = atoi(argv[2]);
     126:	83 ec 0c             	sub    $0xc,%esp
     129:	ff 77 08             	pushl  0x8(%edi)
     12c:	e8 2f 12 00 00       	call   1360 <atoi>
     131:	83 c4 10             	add    $0x10,%esp
     134:	89 c6                	mov    %eax,%esi
  for (i = start; i <= end; i++){
     136:	39 de                	cmp    %ebx,%esi
     138:	0f 8d eb fe ff ff    	jge    29 <main+0x29>
  }
  exit();
     13e:	e8 8f 12 00 00       	call   13d2 <exit>
        printf(1,"%d. %s panic\n", i, testname[i]);
     143:	ff 34 9d 20 23 00 00 	pushl  0x2320(,%ebx,4)
     14a:	53                   	push   %ebx
     14b:	68 46 1a 00 00       	push   $0x1a46
     150:	6a 01                	push   $0x1
     152:	e8 09 14 00 00       	call   1560 <printf>
        exit();
     157:	e8 76 12 00 00       	call   13d2 <exit>
      printf(1,"fork panic\n");
     15c:	51                   	push   %ecx
     15d:	51                   	push   %ecx
     15e:	68 3a 1a 00 00       	push   $0x1a3a
     163:	6a 01                	push   $0x1
     165:	e8 f6 13 00 00       	call   1560 <printf>
      exit();
     16a:	e8 63 12 00 00       	call   13d2 <exit>
      close(gpipe[0]);
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	ff 35 a8 23 00 00    	pushl  0x23a8
     178:	e8 7d 12 00 00       	call   13fa <close>
      ret = testfunc[i]();
     17d:	ff 14 9d 60 23 00 00 	call   *0x2360(,%ebx,4)
     184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
     187:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     18a:	83 c4 0c             	add    $0xc,%esp
     18d:	6a 04                	push   $0x4
     18f:	50                   	push   %eax
     190:	ff 35 ac 23 00 00    	pushl  0x23ac
     196:	e8 57 12 00 00       	call   13f2 <write>
      close(gpipe[1]);
     19b:	5a                   	pop    %edx
     19c:	ff 35 ac 23 00 00    	pushl  0x23ac
     1a2:	e8 53 12 00 00       	call   13fa <close>
      exit();
     1a7:	e8 26 12 00 00       	call   13d2 <exit>
  int end = NTEST-1;
     1ac:	be 0d 00 00 00       	mov    $0xd,%esi
     1b1:	eb 83                	jmp    136 <main+0x136>
     1b3:	66 90                	xchg   %ax,%ax
     1b5:	66 90                	xchg   %ax,%ax
     1b7:	66 90                	xchg   %ax,%ax
     1b9:	66 90                	xchg   %ax,%ax
     1bb:	66 90                	xchg   %ax,%ax
     1bd:	66 90                	xchg   %ax,%ax
     1bf:	90                   	nop

000001c0 <nop>:
}

// ============================================================================
void nop(){ }
     1c0:	55                   	push   %ebp
     1c1:	89 e5                	mov    %esp,%ebp
     1c3:	5d                   	pop    %ebp
     1c4:	c3                   	ret    
     1c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <racingthreadmain>:

void*
racingthreadmain(void *arg)
{
     1d0:	55                   	push   %ebp
  int tid = (int) arg;
     1d1:	ba 80 96 98 00       	mov    $0x989680,%edx
{
     1d6:	89 e5                	mov    %esp,%ebp
     1d8:	83 ec 08             	sub    $0x8,%esp
     1db:	90                   	nop
     1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  int tmp;
  for (i = 0; i < 10000000; i++){
    tmp = gcnt;
     1e0:	a1 a4 23 00 00       	mov    0x23a4,%eax
    tmp++;
     1e5:	83 c0 01             	add    $0x1,%eax
	asm volatile("call %P0"::"i"(nop));
     1e8:	e8 d3 ff ff ff       	call   1c0 <nop>
  for (i = 0; i < 10000000; i++){
     1ed:	83 ea 01             	sub    $0x1,%edx
    gcnt = tmp;
     1f0:	a3 a4 23 00 00       	mov    %eax,0x23a4
  for (i = 0; i < 10000000; i++){
     1f5:	75 e9                	jne    1e0 <racingthreadmain+0x10>
  }
  thread_exit((void *)(tid+1));
     1f7:	8b 45 08             	mov    0x8(%ebp),%eax
     1fa:	83 ec 0c             	sub    $0xc,%esp
     1fd:	83 c0 01             	add    $0x1,%eax
     200:	50                   	push   %eax
     201:	e8 9c 12 00 00       	call   14a2 <thread_exit>

  return 0;
}
     206:	31 c0                	xor    %eax,%eax
     208:	c9                   	leave  
     209:	c3                   	ret    
     20a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000210 <basicthreadmain>:
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
     210:	55                   	push   %ebp
     211:	89 e5                	mov    %esp,%ebp
     213:	57                   	push   %edi
     214:	56                   	push   %esi
     215:	53                   	push   %ebx
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
    if (i % 20000000 == 0){
     216:	bf 6b ca 5f 6b       	mov    $0x6b5fca6b,%edi
  for (i = 0; i < 100000000; i++){
     21b:	31 db                	xor    %ebx,%ebx
{
     21d:	83 ec 0c             	sub    $0xc,%esp
     220:	8b 75 08             	mov    0x8(%ebp),%esi
     223:	eb 0e                	jmp    233 <basicthreadmain+0x23>
     225:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < 100000000; i++){
     228:	83 c3 01             	add    $0x1,%ebx
     22b:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
     231:	74 2f                	je     262 <basicthreadmain+0x52>
    if (i % 20000000 == 0){
     233:	89 d8                	mov    %ebx,%eax
     235:	f7 e7                	mul    %edi
     237:	c1 ea 17             	shr    $0x17,%edx
     23a:	69 d2 00 2d 31 01    	imul   $0x1312d00,%edx,%edx
     240:	39 d3                	cmp    %edx,%ebx
     242:	75 e4                	jne    228 <basicthreadmain+0x18>
      printf(1, "%d", tid);
     244:	83 ec 04             	sub    $0x4,%esp
  for (i = 0; i < 100000000; i++){
     247:	83 c3 01             	add    $0x1,%ebx
      printf(1, "%d", tid);
     24a:	56                   	push   %esi
     24b:	68 b8 18 00 00       	push   $0x18b8
     250:	6a 01                	push   $0x1
     252:	e8 09 13 00 00       	call   1560 <printf>
     257:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100000000; i++){
     25a:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
     260:	75 d1                	jne    233 <basicthreadmain+0x23>
    }
  }
  thread_exit((void *)(tid+1));
     262:	83 ec 0c             	sub    $0xc,%esp
     265:	83 c6 01             	add    $0x1,%esi
     268:	56                   	push   %esi
     269:	e8 34 12 00 00       	call   14a2 <thread_exit>

  return 0;
}
     26e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     271:	31 c0                	xor    %eax,%eax
     273:	5b                   	pop    %ebx
     274:	5e                   	pop    %esi
     275:	5f                   	pop    %edi
     276:	5d                   	pop    %ebp
     277:	c3                   	ret    
     278:	90                   	nop
     279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
     280:	55                   	push   %ebp
     281:	89 e5                	mov    %esp,%ebp
     283:	83 ec 14             	sub    $0x14,%esp
  int val = (int)arg;
  sleep(200);
     286:	68 c8 00 00 00       	push   $0xc8
     28b:	e8 d2 11 00 00       	call   1462 <sleep>
  printf(1, "thread_exit...\n");
     290:	58                   	pop    %eax
     291:	5a                   	pop    %edx
     292:	68 bb 18 00 00       	push   $0x18bb
     297:	6a 01                	push   $0x1
     299:	e8 c2 12 00 00       	call   1560 <printf>
  thread_exit((void *)(val*2));
     29e:	8b 45 08             	mov    0x8(%ebp),%eax
     2a1:	01 c0                	add    %eax,%eax
     2a3:	89 04 24             	mov    %eax,(%esp)
     2a6:	e8 f7 11 00 00       	call   14a2 <thread_exit>

  return 0;
}
     2ab:	31 c0                	xor    %eax,%eax
     2ad:	c9                   	leave  
     2ae:	c3                   	ret    
     2af:	90                   	nop

000002b0 <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 14             	sub    $0x14,%esp
  thread_exit(0);
     2b6:	6a 00                	push   $0x0
     2b8:	e8 e5 11 00 00       	call   14a2 <thread_exit>

  return 0;
}
     2bd:	31 c0                	xor    %eax,%eax
     2bf:	c9                   	leave  
     2c0:	c3                   	ret    
     2c1:	eb 0d                	jmp    2d0 <sleepthreadmain>
     2c3:	90                   	nop
     2c4:	90                   	nop
     2c5:	90                   	nop
     2c6:	90                   	nop
     2c7:	90                   	nop
     2c8:	90                   	nop
     2c9:	90                   	nop
     2ca:	90                   	nop
     2cb:	90                   	nop
     2cc:	90                   	nop
     2cd:	90                   	nop
     2ce:	90                   	nop
     2cf:	90                   	nop

000002d0 <sleepthreadmain>:

// ============================================================================

void*
sleepthreadmain(void *arg)
{
     2d0:	55                   	push   %ebp
     2d1:	89 e5                	mov    %esp,%ebp
     2d3:	83 ec 14             	sub    $0x14,%esp
  sleep(1000000);
     2d6:	68 40 42 0f 00       	push   $0xf4240
     2db:	e8 82 11 00 00       	call   1462 <sleep>
  thread_exit(0);
     2e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2e7:	e8 b6 11 00 00       	call   14a2 <thread_exit>

  return 0;
}
     2ec:	31 c0                	xor    %eax,%eax
     2ee:	c9                   	leave  
     2ef:	c3                   	ret    

000002f0 <exittest2>:
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	56                   	push   %esi
     2f4:	53                   	push   %ebx
     2f5:	8d 75 f8             	lea    -0x8(%ebp),%esi
     2f8:	8d 5d d0             	lea    -0x30(%ebp),%ebx
     2fb:	83 ec 30             	sub    $0x30,%esp
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
     2fe:	83 ec 04             	sub    $0x4,%esp
     301:	6a 02                	push   $0x2
     303:	68 10 09 00 00       	push   $0x910
     308:	53                   	push   %ebx
     309:	e8 8c 11 00 00       	call   149a <thread_create>
     30e:	83 c4 10             	add    $0x10,%esp
     311:	85 c0                	test   %eax,%eax
     313:	75 0b                	jne    320 <exittest2+0x30>
     315:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     318:	39 f3                	cmp    %esi,%ebx
     31a:	75 e2                	jne    2fe <exittest2+0xe>
     31c:	eb fe                	jmp    31c <exittest2+0x2c>
     31e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_create\n");
     320:	83 ec 08             	sub    $0x8,%esp
     323:	68 cb 18 00 00       	push   $0x18cb
     328:	6a 01                	push   $0x1
     32a:	e8 31 12 00 00       	call   1560 <printf>
}
     32f:	8d 65 f8             	lea    -0x8(%ebp),%esp
     332:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     337:	5b                   	pop    %ebx
     338:	5e                   	pop    %esi
     339:	5d                   	pop    %ebp
     33a:	c3                   	ret    
     33b:	90                   	nop
     33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000340 <jointest2>:
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	56                   	push   %esi
     344:	53                   	push   %ebx
     345:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
     348:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     34d:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
     350:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
     353:	83 ec 04             	sub    $0x4,%esp
     356:	53                   	push   %ebx
     357:	68 80 02 00 00       	push   $0x280
     35c:	50                   	push   %eax
     35d:	e8 38 11 00 00       	call   149a <thread_create>
     362:	83 c4 10             	add    $0x10,%esp
     365:	85 c0                	test   %eax,%eax
     367:	75 77                	jne    3e0 <jointest2+0xa0>
  for (i = 1; i <= NUM_THREAD; i++){
     369:	83 c3 01             	add    $0x1,%ebx
     36c:	83 fb 0b             	cmp    $0xb,%ebx
     36f:	75 df                	jne    350 <jointest2+0x10>
  sleep(500);
     371:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "thread_join!!!\n");
     374:	bb 02 00 00 00       	mov    $0x2,%ebx
  sleep(500);
     379:	68 f4 01 00 00       	push   $0x1f4
     37e:	e8 df 10 00 00       	call   1462 <sleep>
  printf(1, "thread_join!!!\n");
     383:	58                   	pop    %eax
     384:	5a                   	pop    %edx
     385:	68 e3 18 00 00       	push   $0x18e3
     38a:	6a 01                	push   $0x1
     38c:	e8 cf 11 00 00       	call   1560 <printf>
     391:	83 c4 10             	add    $0x10,%esp
     394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     398:	83 ec 08             	sub    $0x8,%esp
     39b:	56                   	push   %esi
     39c:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
     3a0:	e8 05 11 00 00       	call   14aa <thread_join>
     3a5:	83 c4 10             	add    $0x10,%esp
     3a8:	85 c0                	test   %eax,%eax
     3aa:	75 54                	jne    400 <jointest2+0xc0>
     3ac:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     3af:	75 4f                	jne    400 <jointest2+0xc0>
     3b1:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
     3b4:	83 fb 16             	cmp    $0x16,%ebx
     3b7:	75 df                	jne    398 <jointest2+0x58>
  printf(1,"\n");
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     3bf:	68 f1 18 00 00       	push   $0x18f1
     3c4:	6a 01                	push   $0x1
     3c6:	e8 95 11 00 00       	call   1560 <printf>
  return 0;
     3cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     3ce:	83 c4 10             	add    $0x10,%esp
}
     3d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
     3d4:	5b                   	pop    %ebx
     3d5:	5e                   	pop    %esi
     3d6:	5d                   	pop    %ebp
     3d7:	c3                   	ret    
     3d8:	90                   	nop
     3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     3e0:	83 ec 08             	sub    $0x8,%esp
     3e3:	68 cb 18 00 00       	push   $0x18cb
     3e8:	6a 01                	push   $0x1
     3ea:	e8 71 11 00 00       	call   1560 <printf>
      return -1;
     3ef:	83 c4 10             	add    $0x10,%esp
}
     3f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     3f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     3fa:	5b                   	pop    %ebx
     3fb:	5e                   	pop    %esi
     3fc:	5d                   	pop    %ebp
     3fd:	c3                   	ret    
     3fe:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     400:	83 ec 08             	sub    $0x8,%esp
     403:	68 f3 18 00 00       	push   $0x18f3
     408:	6a 01                	push   $0x1
     40a:	e8 51 11 00 00       	call   1560 <printf>
      return -1;
     40f:	83 c4 10             	add    $0x10,%esp
}
     412:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     41a:	5b                   	pop    %ebx
     41b:	5e                   	pop    %esi
     41c:	5d                   	pop    %ebp
     41d:	c3                   	ret    
     41e:	66 90                	xchg   %ax,%ax

00000420 <pipetest>:
{
     420:	55                   	push   %ebp
     421:	89 e5                	mov    %esp,%ebp
     423:	57                   	push   %edi
     424:	56                   	push   %esi
     425:	53                   	push   %ebx
  if (pipe(fd) < 0){
     426:	8d 45 ac             	lea    -0x54(%ebp),%eax
{
     429:	83 ec 68             	sub    $0x68,%esp
  if (pipe(fd) < 0){
     42c:	50                   	push   %eax
     42d:	e8 b0 0f 00 00       	call   13e2 <pipe>
     432:	83 c4 10             	add    $0x10,%esp
     435:	85 c0                	test   %eax,%eax
     437:	0f 88 94 01 00 00    	js     5d1 <pipetest+0x1b1>
  arg[1] = fd[0];
     43d:	8b 45 ac             	mov    -0x54(%ebp),%eax
     440:	89 45 b8             	mov    %eax,-0x48(%ebp)
  arg[2] = fd[1];
     443:	8b 45 b0             	mov    -0x50(%ebp),%eax
     446:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if ((pid = fork()) < 0){
     449:	e8 7c 0f 00 00       	call   13ca <fork>
     44e:	85 c0                	test   %eax,%eax
     450:	0f 88 94 01 00 00    	js     5ea <pipetest+0x1ca>
  } else if (pid == 0){
     456:	75 78                	jne    4d0 <pipetest+0xb0>
    close(fd[0]);
     458:	83 ec 0c             	sub    $0xc,%esp
     45b:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     45e:	ff 75 ac             	pushl  -0x54(%ebp)
     461:	8d 75 b4             	lea    -0x4c(%ebp),%esi
     464:	e8 91 0f 00 00       	call   13fa <close>
    arg[0] = 0;
     469:	89 df                	mov    %ebx,%edi
     46b:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
     472:	83 c4 10             	add    $0x10,%esp
     475:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     478:	83 ec 04             	sub    $0x4,%esp
     47b:	56                   	push   %esi
     47c:	68 90 06 00 00       	push   $0x690
     481:	57                   	push   %edi
     482:	e8 13 10 00 00       	call   149a <thread_create>
     487:	83 c4 10             	add    $0x10,%esp
     48a:	85 c0                	test   %eax,%eax
     48c:	0f 85 f6 00 00 00    	jne    588 <pipetest+0x168>
    for (i = 0; i < NUM_THREAD; i++){
     492:	8d 45 e8             	lea    -0x18(%ebp),%eax
     495:	83 c7 04             	add    $0x4,%edi
     498:	39 c7                	cmp    %eax,%edi
     49a:	75 dc                	jne    478 <pipetest+0x58>
     49c:	8d 75 a8             	lea    -0x58(%ebp),%esi
     49f:	90                   	nop
      if (thread_join(threads[i], &retval) != 0){
     4a0:	83 ec 08             	sub    $0x8,%esp
     4a3:	56                   	push   %esi
     4a4:	ff 33                	pushl  (%ebx)
     4a6:	e8 ff 0f 00 00       	call   14aa <thread_join>
     4ab:	83 c4 10             	add    $0x10,%esp
     4ae:	85 c0                	test   %eax,%eax
     4b0:	0f 85 fa 00 00 00    	jne    5b0 <pipetest+0x190>
     4b6:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NUM_THREAD; i++){
     4b9:	39 df                	cmp    %ebx,%edi
     4bb:	75 e3                	jne    4a0 <pipetest+0x80>
    close(fd[1]);
     4bd:	83 ec 0c             	sub    $0xc,%esp
     4c0:	ff 75 b0             	pushl  -0x50(%ebp)
     4c3:	e8 32 0f 00 00       	call   13fa <close>
    exit();
     4c8:	e8 05 0f 00 00       	call   13d2 <exit>
     4cd:	8d 76 00             	lea    0x0(%esi),%esi
    close(fd[1]);
     4d0:	83 ec 0c             	sub    $0xc,%esp
     4d3:	ff 75 b0             	pushl  -0x50(%ebp)
     4d6:	8d 7d e8             	lea    -0x18(%ebp),%edi
     4d9:	8d 75 b4             	lea    -0x4c(%ebp),%esi
     4dc:	e8 19 0f 00 00       	call   13fa <close>
     4e1:	8d 45 c0             	lea    -0x40(%ebp),%eax
    arg[0] = 1;
     4e4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
    gcnt = 0;
     4eb:	c7 05 a4 23 00 00 00 	movl   $0x0,0x23a4
     4f2:	00 00 00 
     4f5:	83 c4 10             	add    $0x10,%esp
     4f8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
     4fb:	89 c3                	mov    %eax,%ebx
     4fd:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     500:	83 ec 04             	sub    $0x4,%esp
     503:	56                   	push   %esi
     504:	68 90 06 00 00       	push   $0x690
     509:	53                   	push   %ebx
     50a:	e8 8b 0f 00 00       	call   149a <thread_create>
     50f:	83 c4 10             	add    $0x10,%esp
     512:	85 c0                	test   %eax,%eax
     514:	75 72                	jne    588 <pipetest+0x168>
     516:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NUM_THREAD; i++){
     519:	39 fb                	cmp    %edi,%ebx
     51b:	75 e3                	jne    500 <pipetest+0xe0>
     51d:	8d 75 a8             	lea    -0x58(%ebp),%esi
      if (thread_join(threads[i], &retval) != 0){
     520:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     523:	83 ec 08             	sub    $0x8,%esp
     526:	56                   	push   %esi
     527:	ff 30                	pushl  (%eax)
     529:	e8 7c 0f 00 00       	call   14aa <thread_join>
     52e:	83 c4 10             	add    $0x10,%esp
     531:	85 c0                	test   %eax,%eax
     533:	89 c7                	mov    %eax,%edi
     535:	75 79                	jne    5b0 <pipetest+0x190>
     537:	83 45 a4 04          	addl   $0x4,-0x5c(%ebp)
     53b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    for (i = 0; i < NUM_THREAD; i++){
     53e:	39 d8                	cmp    %ebx,%eax
     540:	75 de                	jne    520 <pipetest+0x100>
    close(fd[0]);
     542:	83 ec 0c             	sub    $0xc,%esp
     545:	ff 75 ac             	pushl  -0x54(%ebp)
     548:	e8 ad 0e 00 00       	call   13fa <close>
  if (wait() == -1){
     54d:	e8 88 0e 00 00       	call   13da <wait>
     552:	83 c4 10             	add    $0x10,%esp
     555:	83 f8 ff             	cmp    $0xffffffff,%eax
     558:	0f 84 a5 00 00 00    	je     603 <pipetest+0x1e3>
  if (gcnt != 0)
     55e:	a1 a4 23 00 00       	mov    0x23a4,%eax
     563:	85 c0                	test   %eax,%eax
     565:	74 38                	je     59f <pipetest+0x17f>
    printf(1,"panic at validation in pipetest : %d\n", gcnt);
     567:	a1 a4 23 00 00       	mov    0x23a4,%eax
     56c:	83 ec 04             	sub    $0x4,%esp
     56f:	50                   	push   %eax
     570:	68 f0 1a 00 00       	push   $0x1af0
     575:	6a 01                	push   $0x1
     577:	e8 e4 0f 00 00       	call   1560 <printf>
     57c:	83 c4 10             	add    $0x10,%esp
     57f:	eb 1e                	jmp    59f <pipetest+0x17f>
     581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_create\n");
     588:	83 ec 08             	sub    $0x8,%esp
        return -1;
     58b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        printf(1, "panic at thread_create\n");
     590:	68 cb 18 00 00       	push   $0x18cb
     595:	6a 01                	push   $0x1
     597:	e8 c4 0f 00 00       	call   1560 <printf>
        return -1;
     59c:	83 c4 10             	add    $0x10,%esp
}
     59f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5a2:	89 f8                	mov    %edi,%eax
     5a4:	5b                   	pop    %ebx
     5a5:	5e                   	pop    %esi
     5a6:	5f                   	pop    %edi
     5a7:	5d                   	pop    %ebp
     5a8:	c3                   	ret    
     5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_join\n");
     5b0:	83 ec 08             	sub    $0x8,%esp
        return -1;
     5b3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        printf(1, "panic at thread_join\n");
     5b8:	68 f3 18 00 00       	push   $0x18f3
     5bd:	6a 01                	push   $0x1
     5bf:	e8 9c 0f 00 00       	call   1560 <printf>
        return -1;
     5c4:	83 c4 10             	add    $0x10,%esp
}
     5c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5ca:	89 f8                	mov    %edi,%eax
     5cc:	5b                   	pop    %ebx
     5cd:	5e                   	pop    %esi
     5ce:	5f                   	pop    %edi
     5cf:	5d                   	pop    %ebp
     5d0:	c3                   	ret    
    printf(1, "panic at pipe in pipetest\n");
     5d1:	83 ec 08             	sub    $0x8,%esp
    return -1;
     5d4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    printf(1, "panic at pipe in pipetest\n");
     5d9:	68 09 19 00 00       	push   $0x1909
     5de:	6a 01                	push   $0x1
     5e0:	e8 7b 0f 00 00       	call   1560 <printf>
    return -1;
     5e5:	83 c4 10             	add    $0x10,%esp
     5e8:	eb b5                	jmp    59f <pipetest+0x17f>
      printf(1, "panic at fork in pipetest\n");
     5ea:	83 ec 08             	sub    $0x8,%esp
      return -1;
     5ed:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at fork in pipetest\n");
     5f2:	68 24 19 00 00       	push   $0x1924
     5f7:	6a 01                	push   $0x1
     5f9:	e8 62 0f 00 00       	call   1560 <printf>
      return -1;
     5fe:	83 c4 10             	add    $0x10,%esp
     601:	eb 9c                	jmp    59f <pipetest+0x17f>
    printf(1, "panic at wait in pipetest\n");
     603:	50                   	push   %eax
     604:	50                   	push   %eax
    return -1;
     605:	83 cf ff             	or     $0xffffffff,%edi
    printf(1, "panic at wait in pipetest\n");
     608:	68 3f 19 00 00       	push   $0x193f
     60d:	6a 01                	push   $0x1
     60f:	e8 4c 0f 00 00       	call   1560 <printf>
    return -1;
     614:	83 c4 10             	add    $0x10,%esp
     617:	eb 86                	jmp    59f <pipetest+0x17f>
     619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000620 <execthreadmain>:
{
     620:	55                   	push   %ebp
     621:	89 e5                	mov    %esp,%ebp
     623:	83 ec 24             	sub    $0x24,%esp
  sleep(1);
     626:	6a 01                	push   $0x1
  char *args[3] = {"echo", "echo is executed!", 0}; 
     628:	c7 45 ec 5a 19 00 00 	movl   $0x195a,-0x14(%ebp)
     62f:	c7 45 f0 5f 19 00 00 	movl   $0x195f,-0x10(%ebp)
     636:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  sleep(1);
     63d:	e8 20 0e 00 00       	call   1462 <sleep>
  exec("echo", args);
     642:	58                   	pop    %eax
     643:	8d 45 ec             	lea    -0x14(%ebp),%eax
     646:	5a                   	pop    %edx
     647:	50                   	push   %eax
     648:	68 5a 19 00 00       	push   $0x195a
     64d:	e8 b8 0d 00 00       	call   140a <exec>
  printf(1, "panic at execthreadmain\n");
     652:	59                   	pop    %ecx
     653:	58                   	pop    %eax
     654:	68 71 19 00 00       	push   $0x1971
     659:	6a 01                	push   $0x1
     65b:	e8 00 0f 00 00       	call   1560 <printf>
  exit();
     660:	e8 6d 0d 00 00       	call   13d2 <exit>
     665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000670 <killthreadmain>:
{
     670:	55                   	push   %ebp
     671:	89 e5                	mov    %esp,%ebp
     673:	83 ec 08             	sub    $0x8,%esp
  kill(getpid());
     676:	e8 d7 0d 00 00       	call   1452 <getpid>
     67b:	83 ec 0c             	sub    $0xc,%esp
     67e:	50                   	push   %eax
     67f:	e8 7e 0d 00 00       	call   1402 <kill>
     684:	83 c4 10             	add    $0x10,%esp
     687:	eb fe                	jmp    687 <killthreadmain+0x17>
     689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000690 <pipethreadmain>:
{
     690:	55                   	push   %ebp
     691:	89 e5                	mov    %esp,%ebp
     693:	57                   	push   %edi
     694:	56                   	push   %esi
     695:	53                   	push   %ebx
      write(fd[1], &i, sizeof(int));
     696:	8d 7d e0             	lea    -0x20(%ebp),%edi
{
     699:	83 ec 1c             	sub    $0x1c,%esp
     69c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = -5; i <= 5; i++){
     69f:	c7 45 e0 fb ff ff ff 	movl   $0xfffffffb,-0x20(%ebp)
  int type = ((int*)arg)[0];
     6a6:	8b 33                	mov    (%ebx),%esi
     6a8:	eb 32                	jmp    6dc <pipethreadmain+0x4c>
     6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      read(fd[0], &input, sizeof(int));
     6b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     6b3:	83 ec 04             	sub    $0x4,%esp
     6b6:	6a 04                	push   $0x4
     6b8:	50                   	push   %eax
     6b9:	ff 73 04             	pushl  0x4(%ebx)
     6bc:	e8 29 0d 00 00       	call   13ea <read>
      __sync_fetch_and_add(&gcnt, input);
     6c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6c4:	f0 01 05 a4 23 00 00 	lock add %eax,0x23a4
  for (i = -5; i <= 5; i++){
     6cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     6ce:	83 c4 10             	add    $0x10,%esp
     6d1:	83 c0 01             	add    $0x1,%eax
     6d4:	83 f8 05             	cmp    $0x5,%eax
     6d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
     6da:	7f 23                	jg     6ff <pipethreadmain+0x6f>
    if (type){
     6dc:	85 f6                	test   %esi,%esi
     6de:	75 d0                	jne    6b0 <pipethreadmain+0x20>
      write(fd[1], &i, sizeof(int));
     6e0:	83 ec 04             	sub    $0x4,%esp
     6e3:	6a 04                	push   $0x4
     6e5:	57                   	push   %edi
     6e6:	ff 73 08             	pushl  0x8(%ebx)
     6e9:	e8 04 0d 00 00       	call   13f2 <write>
  for (i = -5; i <= 5; i++){
     6ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
      write(fd[1], &i, sizeof(int));
     6f1:	83 c4 10             	add    $0x10,%esp
  for (i = -5; i <= 5; i++){
     6f4:	83 c0 01             	add    $0x1,%eax
     6f7:	83 f8 05             	cmp    $0x5,%eax
     6fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
     6fd:	7e dd                	jle    6dc <pipethreadmain+0x4c>
  thread_exit(0);
     6ff:	83 ec 0c             	sub    $0xc,%esp
     702:	6a 00                	push   $0x0
     704:	e8 99 0d 00 00       	call   14a2 <thread_exit>
}
     709:	8d 65 f4             	lea    -0xc(%ebp),%esp
     70c:	31 c0                	xor    %eax,%eax
     70e:	5b                   	pop    %ebx
     70f:	5e                   	pop    %esi
     710:	5f                   	pop    %edi
     711:	5d                   	pop    %ebp
     712:	c3                   	ret    
     713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000720 <stridethreadmain>:

// ============================================================================

void*
stridethreadmain(void *arg)
{
     720:	55                   	push   %ebp
     721:	89 e5                	mov    %esp,%ebp
     723:	83 ec 08             	sub    $0x8,%esp
     726:	8b 55 08             	mov    0x8(%ebp),%edx
     729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  volatile int *flag = (int*)arg;
  int t;
  while(*flag){
     730:	8b 02                	mov    (%edx),%eax
     732:	85 c0                	test   %eax,%eax
     734:	74 22                	je     758 <stridethreadmain+0x38>
     736:	8d 76 00             	lea    0x0(%esi),%esi
     739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    while(*flag == 1){
     740:	8b 02                	mov    (%edx),%eax
     742:	83 f8 01             	cmp    $0x1,%eax
     745:	75 e9                	jne    730 <stridethreadmain+0x10>
      for (t = 0; t < 5; t++);
      __sync_fetch_and_add(&gcnt, 1);
     747:	f0 83 05 a4 23 00 00 	lock addl $0x1,0x23a4
     74e:	01 
     74f:	eb ef                	jmp    740 <stridethreadmain+0x20>
     751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  thread_exit(0);
     758:	83 ec 0c             	sub    $0xc,%esp
     75b:	6a 00                	push   $0x0
     75d:	e8 40 0d 00 00       	call   14a2 <thread_exit>

  return 0;
}
     762:	31 c0                	xor    %eax,%eax
     764:	c9                   	leave  
     765:	c3                   	ret    
     766:	8d 76 00             	lea    0x0(%esi),%esi
     769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000770 <stridetest>:

int
stridetest(void)
{
     770:	55                   	push   %ebp
     771:	89 e5                	mov    %esp,%ebp
     773:	57                   	push   %edi
     774:	56                   	push   %esi
     775:	53                   	push   %ebx
     776:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
     779:	c7 05 a4 23 00 00 00 	movl   $0x0,0x23a4
     780:	00 00 00 
  flag = 2;
     783:	c7 45 b8 02 00 00 00 	movl   $0x2,-0x48(%ebp)
  if ((pid = fork()) == -1){
     78a:	e8 3b 0c 00 00       	call   13ca <fork>
     78f:	83 f8 ff             	cmp    $0xffffffff,%eax
     792:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     795:	0f 84 2e 01 00 00    	je     8c9 <stridetest+0x159>
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
     79b:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
     79e:	85 db                	test   %ebx,%ebx
     7a0:	0f 85 c2 00 00 00    	jne    868 <stridetest+0xf8>
    set_cpu_share(2);
     7a6:	83 ec 0c             	sub    $0xc,%esp
     7a9:	6a 02                	push   $0x2
     7ab:	e8 da 0c 00 00       	call   148a <set_cpu_share>
     7b0:	83 c4 10             	add    $0x10,%esp
     7b3:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     7b6:	8d 7d b8             	lea    -0x48(%ebp),%edi
{
     7b9:	89 de                	mov    %ebx,%esi
     7bb:	90                   	nop
     7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else{
    set_cpu_share(10);
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
     7c0:	83 ec 04             	sub    $0x4,%esp
     7c3:	57                   	push   %edi
     7c4:	68 20 07 00 00       	push   $0x720
     7c9:	56                   	push   %esi
     7ca:	e8 cb 0c 00 00       	call   149a <thread_create>
     7cf:	83 c4 10             	add    $0x10,%esp
     7d2:	85 c0                	test   %eax,%eax
     7d4:	0f 85 a6 00 00 00    	jne    880 <stridetest+0x110>
  for (i = 0; i < NUM_THREAD; i++){
     7da:	8d 45 e8             	lea    -0x18(%ebp),%eax
     7dd:	83 c6 04             	add    $0x4,%esi
     7e0:	39 c6                	cmp    %eax,%esi
     7e2:	75 dc                	jne    7c0 <stridetest+0x50>
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  flag = 1;
  sleep(500);
     7e4:	83 ec 0c             	sub    $0xc,%esp
  flag = 1;
     7e7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  sleep(500);
     7ee:	68 f4 01 00 00       	push   $0x1f4
     7f3:	e8 6a 0c 00 00       	call   1462 <sleep>
  flag = 0;
     7f8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
     7ff:	83 c4 10             	add    $0x10,%esp
     802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
     808:	8d 45 bc             	lea    -0x44(%ebp),%eax
     80b:	83 ec 08             	sub    $0x8,%esp
     80e:	50                   	push   %eax
     80f:	ff 33                	pushl  (%ebx)
     811:	e8 94 0c 00 00       	call   14aa <thread_join>
     816:	83 c4 10             	add    $0x10,%esp
     819:	85 c0                	test   %eax,%eax
     81b:	89 c7                	mov    %eax,%edi
     81d:	0f 85 85 00 00 00    	jne    8a8 <stridetest+0x138>
     823:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     826:	39 f3                	cmp    %esi,%ebx
     828:	75 de                	jne    808 <stridetest+0x98>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
     82a:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
    printf(1, " 2% : %d\n", gcnt);
     82d:	a1 a4 23 00 00       	mov    0x23a4,%eax
  if (pid == 0){
     832:	85 c9                	test   %ecx,%ecx
     834:	0f 84 a2 00 00 00    	je     8dc <stridetest+0x16c>
    exit();
  } else{
    printf(1, "10% : %d\n", gcnt);
     83a:	83 ec 04             	sub    $0x4,%esp
     83d:	50                   	push   %eax
     83e:	68 af 19 00 00       	push   $0x19af
     843:	6a 01                	push   $0x1
     845:	e8 16 0d 00 00       	call   1560 <printf>
    if (wait() == -1){
     84a:	e8 8b 0b 00 00       	call   13da <wait>
     84f:	83 c4 10             	add    $0x10,%esp
     852:	83 f8 ff             	cmp    $0xffffffff,%eax
     855:	0f 84 94 00 00 00    	je     8ef <stridetest+0x17f>
      exit();
    }
  }

  return 0;
}
     85b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     85e:	89 f8                	mov    %edi,%eax
     860:	5b                   	pop    %ebx
     861:	5e                   	pop    %esi
     862:	5f                   	pop    %edi
     863:	5d                   	pop    %ebp
     864:	c3                   	ret    
     865:	8d 76 00             	lea    0x0(%esi),%esi
    set_cpu_share(10);
     868:	83 ec 0c             	sub    $0xc,%esp
     86b:	6a 0a                	push   $0xa
     86d:	e8 18 0c 00 00       	call   148a <set_cpu_share>
     872:	83 c4 10             	add    $0x10,%esp
     875:	e9 39 ff ff ff       	jmp    7b3 <stridetest+0x43>
     87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
     880:	83 ec 08             	sub    $0x8,%esp
      return -1;
     883:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at thread_create\n");
     888:	68 cb 18 00 00       	push   $0x18cb
     88d:	6a 01                	push   $0x1
     88f:	e8 cc 0c 00 00       	call   1560 <printf>
      return -1;
     894:	83 c4 10             	add    $0x10,%esp
}
     897:	8d 65 f4             	lea    -0xc(%ebp),%esp
     89a:	89 f8                	mov    %edi,%eax
     89c:	5b                   	pop    %ebx
     89d:	5e                   	pop    %esi
     89e:	5f                   	pop    %edi
     89f:	5d                   	pop    %ebp
     8a0:	c3                   	ret    
     8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_join\n");
     8a8:	83 ec 08             	sub    $0x8,%esp
      return -1;
     8ab:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at thread_join\n");
     8b0:	68 f3 18 00 00       	push   $0x18f3
     8b5:	6a 01                	push   $0x1
     8b7:	e8 a4 0c 00 00       	call   1560 <printf>
      return -1;
     8bc:	83 c4 10             	add    $0x10,%esp
}
     8bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8c2:	89 f8                	mov    %edi,%eax
     8c4:	5b                   	pop    %ebx
     8c5:	5e                   	pop    %esi
     8c6:	5f                   	pop    %edi
     8c7:	5d                   	pop    %ebp
     8c8:	c3                   	ret    
    printf(1, "panic at fork in forktest\n");
     8c9:	56                   	push   %esi
     8ca:	56                   	push   %esi
     8cb:	68 8a 19 00 00       	push   $0x198a
     8d0:	6a 01                	push   $0x1
     8d2:	e8 89 0c 00 00       	call   1560 <printf>
    exit();
     8d7:	e8 f6 0a 00 00       	call   13d2 <exit>
    printf(1, " 2% : %d\n", gcnt);
     8dc:	52                   	push   %edx
     8dd:	50                   	push   %eax
     8de:	68 a5 19 00 00       	push   $0x19a5
     8e3:	6a 01                	push   $0x1
     8e5:	e8 76 0c 00 00       	call   1560 <printf>
    exit();
     8ea:	e8 e3 0a 00 00       	call   13d2 <exit>
      printf(1, "panic at wait in forktest\n");
     8ef:	50                   	push   %eax
     8f0:	50                   	push   %eax
     8f1:	68 b9 19 00 00       	push   $0x19b9
     8f6:	6a 01                	push   $0x1
     8f8:	e8 63 0c 00 00       	call   1560 <printf>
      exit();
     8fd:	e8 d0 0a 00 00       	call   13d2 <exit>
     902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000910 <exitthreadmain>:
{
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	83 ec 08             	sub    $0x8,%esp
     916:	8b 45 08             	mov    0x8(%ebp),%eax
  if ((int)arg == 1){
     919:	83 f8 01             	cmp    $0x1,%eax
     91c:	74 1a                	je     938 <exitthreadmain+0x28>
  } else if ((int)arg == 2){
     91e:	83 f8 02             	cmp    $0x2,%eax
     921:	74 29                	je     94c <exitthreadmain+0x3c>
  thread_exit(0);
     923:	83 ec 0c             	sub    $0xc,%esp
     926:	6a 00                	push   $0x0
     928:	e8 75 0b 00 00       	call   14a2 <thread_exit>
}
     92d:	31 c0                	xor    %eax,%eax
     92f:	c9                   	leave  
     930:	c3                   	ret    
     931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "thread_exit ...\n");
     938:	83 ec 08             	sub    $0x8,%esp
     93b:	68 d4 19 00 00       	push   $0x19d4
     940:	6a 01                	push   $0x1
     942:	e8 19 0c 00 00       	call   1560 <printf>
     947:	83 c4 10             	add    $0x10,%esp
     94a:	eb ec                	jmp    938 <exitthreadmain+0x28>
    exit();
     94c:	e8 81 0a 00 00       	call   13d2 <exit>
     951:	eb 0d                	jmp    960 <forkthreadmain>
     953:	90                   	nop
     954:	90                   	nop
     955:	90                   	nop
     956:	90                   	nop
     957:	90                   	nop
     958:	90                   	nop
     959:	90                   	nop
     95a:	90                   	nop
     95b:	90                   	nop
     95c:	90                   	nop
     95d:	90                   	nop
     95e:	90                   	nop
     95f:	90                   	nop

00000960 <forkthreadmain>:
{
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	83 ec 08             	sub    $0x8,%esp
  if ((pid = fork()) == -1){
     966:	e8 5f 0a 00 00       	call   13ca <fork>
     96b:	83 f8 ff             	cmp    $0xffffffff,%eax
     96e:	74 2e                	je     99e <forkthreadmain+0x3e>
  } else if (pid == 0){
     970:	85 c0                	test   %eax,%eax
     972:	74 50                	je     9c4 <forkthreadmain+0x64>
    printf(1, "parent\n");
     974:	83 ec 08             	sub    $0x8,%esp
     977:	68 ec 19 00 00       	push   $0x19ec
     97c:	6a 01                	push   $0x1
     97e:	e8 dd 0b 00 00       	call   1560 <printf>
    if (wait() == -1){
     983:	e8 52 0a 00 00       	call   13da <wait>
     988:	83 c4 10             	add    $0x10,%esp
     98b:	83 f8 ff             	cmp    $0xffffffff,%eax
     98e:	74 21                	je     9b1 <forkthreadmain+0x51>
  thread_exit(0);
     990:	83 ec 0c             	sub    $0xc,%esp
     993:	6a 00                	push   $0x0
     995:	e8 08 0b 00 00       	call   14a2 <thread_exit>
}
     99a:	31 c0                	xor    %eax,%eax
     99c:	c9                   	leave  
     99d:	c3                   	ret    
    printf(1, "panic at fork in forktest\n");
     99e:	51                   	push   %ecx
     99f:	51                   	push   %ecx
     9a0:	68 8a 19 00 00       	push   $0x198a
     9a5:	6a 01                	push   $0x1
     9a7:	e8 b4 0b 00 00       	call   1560 <printf>
    exit();
     9ac:	e8 21 0a 00 00       	call   13d2 <exit>
      printf(1, "panic at wait in forktest\n");
     9b1:	50                   	push   %eax
     9b2:	50                   	push   %eax
     9b3:	68 b9 19 00 00       	push   $0x19b9
     9b8:	6a 01                	push   $0x1
     9ba:	e8 a1 0b 00 00       	call   1560 <printf>
      exit();
     9bf:	e8 0e 0a 00 00       	call   13d2 <exit>
    printf(1, "child\n");
     9c4:	52                   	push   %edx
     9c5:	52                   	push   %edx
     9c6:	68 e5 19 00 00       	push   $0x19e5
     9cb:	6a 01                	push   $0x1
     9cd:	e8 8e 0b 00 00       	call   1560 <printf>
    exit();
     9d2:	e8 fb 09 00 00       	call   13d2 <exit>
     9d7:	89 f6                	mov    %esi,%esi
     9d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009e0 <exittest1>:
{
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	57                   	push   %edi
     9e4:	56                   	push   %esi
     9e5:	53                   	push   %ebx
     9e6:	8d 7d e8             	lea    -0x18(%ebp),%edi
     9e9:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     9ec:	83 ec 3c             	sub    $0x3c,%esp
     9ef:	90                   	nop
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
     9f0:	83 ec 04             	sub    $0x4,%esp
     9f3:	6a 01                	push   $0x1
     9f5:	68 10 09 00 00       	push   $0x910
     9fa:	53                   	push   %ebx
     9fb:	e8 9a 0a 00 00       	call   149a <thread_create>
     a00:	83 c4 10             	add    $0x10,%esp
     a03:	85 c0                	test   %eax,%eax
     a05:	89 c6                	mov    %eax,%esi
     a07:	75 27                	jne    a30 <exittest1+0x50>
     a09:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     a0c:	39 fb                	cmp    %edi,%ebx
     a0e:	75 e0                	jne    9f0 <exittest1+0x10>
  sleep(1);
     a10:	83 ec 0c             	sub    $0xc,%esp
     a13:	6a 01                	push   $0x1
     a15:	e8 48 0a 00 00       	call   1462 <sleep>
  return 0;
     a1a:	83 c4 10             	add    $0x10,%esp
}
     a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a20:	89 f0                	mov    %esi,%eax
     a22:	5b                   	pop    %ebx
     a23:	5e                   	pop    %esi
     a24:	5f                   	pop    %edi
     a25:	5d                   	pop    %ebp
     a26:	c3                   	ret    
     a27:	89 f6                	mov    %esi,%esi
     a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
     a30:	83 ec 08             	sub    $0x8,%esp
     a33:	be ff ff ff ff       	mov    $0xffffffff,%esi
     a38:	68 cb 18 00 00       	push   $0x18cb
     a3d:	6a 01                	push   $0x1
     a3f:	e8 1c 0b 00 00       	call   1560 <printf>
     a44:	83 c4 10             	add    $0x10,%esp
}
     a47:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a4a:	89 f0                	mov    %esi,%eax
     a4c:	5b                   	pop    %ebx
     a4d:	5e                   	pop    %esi
     a4e:	5f                   	pop    %edi
     a4f:	5d                   	pop    %ebp
     a50:	c3                   	ret    
     a51:	eb 0d                	jmp    a60 <jointest1>
     a53:	90                   	nop
     a54:	90                   	nop
     a55:	90                   	nop
     a56:	90                   	nop
     a57:	90                   	nop
     a58:	90                   	nop
     a59:	90                   	nop
     a5a:	90                   	nop
     a5b:	90                   	nop
     a5c:	90                   	nop
     a5d:	90                   	nop
     a5e:	90                   	nop
     a5f:	90                   	nop

00000a60 <jointest1>:
{
     a60:	55                   	push   %ebp
     a61:	89 e5                	mov    %esp,%ebp
     a63:	56                   	push   %esi
     a64:	53                   	push   %ebx
     a65:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
     a68:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     a6d:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
     a70:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
     a73:	83 ec 04             	sub    $0x4,%esp
     a76:	53                   	push   %ebx
     a77:	68 80 02 00 00       	push   $0x280
     a7c:	50                   	push   %eax
     a7d:	e8 18 0a 00 00       	call   149a <thread_create>
     a82:	83 c4 10             	add    $0x10,%esp
     a85:	85 c0                	test   %eax,%eax
     a87:	75 67                	jne    af0 <jointest1+0x90>
  for (i = 1; i <= NUM_THREAD; i++){
     a89:	83 c3 01             	add    $0x1,%ebx
     a8c:	83 fb 0b             	cmp    $0xb,%ebx
     a8f:	75 df                	jne    a70 <jointest1+0x10>
  printf(1, "thread_join!!!\n");
     a91:	83 ec 08             	sub    $0x8,%esp
     a94:	bb 02 00 00 00       	mov    $0x2,%ebx
     a99:	68 e3 18 00 00       	push   $0x18e3
     a9e:	6a 01                	push   $0x1
     aa0:	e8 bb 0a 00 00       	call   1560 <printf>
     aa5:	83 c4 10             	add    $0x10,%esp
     aa8:	90                   	nop
     aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     ab0:	83 ec 08             	sub    $0x8,%esp
     ab3:	56                   	push   %esi
     ab4:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
     ab8:	e8 ed 09 00 00       	call   14aa <thread_join>
     abd:	83 c4 10             	add    $0x10,%esp
     ac0:	85 c0                	test   %eax,%eax
     ac2:	75 4c                	jne    b10 <jointest1+0xb0>
     ac4:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     ac7:	75 47                	jne    b10 <jointest1+0xb0>
     ac9:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
     acc:	83 fb 16             	cmp    $0x16,%ebx
     acf:	75 df                	jne    ab0 <jointest1+0x50>
  printf(1,"\n");
     ad1:	83 ec 08             	sub    $0x8,%esp
     ad4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     ad7:	68 f1 18 00 00       	push   $0x18f1
     adc:	6a 01                	push   $0x1
     ade:	e8 7d 0a 00 00       	call   1560 <printf>
  return 0;
     ae3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     ae6:	83 c4 10             	add    $0x10,%esp
}
     ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
     aec:	5b                   	pop    %ebx
     aed:	5e                   	pop    %esi
     aee:	5d                   	pop    %ebp
     aef:	c3                   	ret    
      printf(1, "panic at thread_create\n");
     af0:	83 ec 08             	sub    $0x8,%esp
     af3:	68 cb 18 00 00       	push   $0x18cb
     af8:	6a 01                	push   $0x1
     afa:	e8 61 0a 00 00       	call   1560 <printf>
      return -1;
     aff:	83 c4 10             	add    $0x10,%esp
}
     b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b0a:	5b                   	pop    %ebx
     b0b:	5e                   	pop    %esi
     b0c:	5d                   	pop    %ebp
     b0d:	c3                   	ret    
     b0e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     b10:	83 ec 08             	sub    $0x8,%esp
     b13:	68 f3 18 00 00       	push   $0x18f3
     b18:	6a 01                	push   $0x1
     b1a:	e8 41 0a 00 00       	call   1560 <printf>
     b1f:	83 c4 10             	add    $0x10,%esp
}
     b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
     b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b2a:	5b                   	pop    %ebx
     b2b:	5e                   	pop    %esi
     b2c:	5d                   	pop    %ebp
     b2d:	c3                   	ret    
     b2e:	66 90                	xchg   %ax,%ax

00000b30 <stresstest>:
{
     b30:	55                   	push   %ebp
     b31:	89 e5                	mov    %esp,%ebp
     b33:	57                   	push   %edi
     b34:	56                   	push   %esi
     b35:	53                   	push   %ebx
     b36:	8d 75 bc             	lea    -0x44(%ebp),%esi
     b39:	83 ec 4c             	sub    $0x4c,%esp
  for (n = 1; n <= nstress; n++){
     b3c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
     b43:	31 ff                	xor    %edi,%edi
     b45:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
     b48:	8d 44 bd c0          	lea    -0x40(%ebp,%edi,4),%eax
     b4c:	83 ec 04             	sub    $0x4,%esp
     b4f:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     b52:	57                   	push   %edi
     b53:	68 b0 02 00 00       	push   $0x2b0
     b58:	50                   	push   %eax
     b59:	e8 3c 09 00 00       	call   149a <thread_create>
     b5e:	83 c4 10             	add    $0x10,%esp
     b61:	85 c0                	test   %eax,%eax
     b63:	75 6b                	jne    bd0 <stresstest+0xa0>
    for (i = 0; i < NUM_THREAD; i++){
     b65:	83 c7 01             	add    $0x1,%edi
     b68:	83 ff 0a             	cmp    $0xa,%edi
     b6b:	75 db                	jne    b48 <stresstest+0x18>
     b6d:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_join(threads[i], &retval) != 0){
     b70:	83 ec 08             	sub    $0x8,%esp
     b73:	56                   	push   %esi
     b74:	ff 33                	pushl  (%ebx)
     b76:	e8 2f 09 00 00       	call   14aa <thread_join>
     b7b:	83 c4 10             	add    $0x10,%esp
     b7e:	85 c0                	test   %eax,%eax
     b80:	75 6e                	jne    bf0 <stresstest+0xc0>
    for (i = 0; i < NUM_THREAD; i++){
     b82:	8d 4d e8             	lea    -0x18(%ebp),%ecx
     b85:	83 c3 04             	add    $0x4,%ebx
     b88:	39 cb                	cmp    %ecx,%ebx
     b8a:	75 e4                	jne    b70 <stresstest+0x40>
  for (n = 1; n <= nstress; n++){
     b8c:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
     b90:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     b93:	81 fa b9 88 00 00    	cmp    $0x88b9,%edx
     b99:	74 74                	je     c0f <stresstest+0xdf>
    if (n % 1000 == 0)
     b9b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     b9e:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
     ba3:	f7 e2                	mul    %edx
     ba5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     ba8:	c1 ea 06             	shr    $0x6,%edx
     bab:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
     bb1:	39 d0                	cmp    %edx,%eax
     bb3:	75 8e                	jne    b43 <stresstest+0x13>
      printf(1, "%d\n", n);
     bb5:	83 ec 04             	sub    $0x4,%esp
     bb8:	50                   	push   %eax
     bb9:	68 b5 19 00 00       	push   $0x19b5
     bbe:	6a 01                	push   $0x1
     bc0:	e8 9b 09 00 00       	call   1560 <printf>
     bc5:	83 c4 10             	add    $0x10,%esp
     bc8:	e9 76 ff ff ff       	jmp    b43 <stresstest+0x13>
     bcd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
     bd0:	83 ec 08             	sub    $0x8,%esp
     bd3:	68 cb 18 00 00       	push   $0x18cb
     bd8:	6a 01                	push   $0x1
     bda:	e8 81 09 00 00       	call   1560 <printf>
        return -1;
     bdf:	83 c4 10             	add    $0x10,%esp
     be2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bea:	5b                   	pop    %ebx
     beb:	5e                   	pop    %esi
     bec:	5f                   	pop    %edi
     bed:	5d                   	pop    %ebp
     bee:	c3                   	ret    
     bef:	90                   	nop
        printf(1, "panic at thread_join\n");
     bf0:	83 ec 08             	sub    $0x8,%esp
     bf3:	68 f3 18 00 00       	push   $0x18f3
     bf8:	6a 01                	push   $0x1
     bfa:	e8 61 09 00 00       	call   1560 <printf>
        return -1;
     bff:	83 c4 10             	add    $0x10,%esp
}
     c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
     c05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     c0a:	5b                   	pop    %ebx
     c0b:	5e                   	pop    %esi
     c0c:	5f                   	pop    %edi
     c0d:	5d                   	pop    %ebp
     c0e:	c3                   	ret    
  printf(1, "\n");
     c0f:	83 ec 08             	sub    $0x8,%esp
     c12:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     c15:	68 f1 18 00 00       	push   $0x18f1
     c1a:	6a 01                	push   $0x1
     c1c:	e8 3f 09 00 00       	call   1560 <printf>
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     c27:	eb be                	jmp    be7 <stresstest+0xb7>
     c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c30 <killtest>:
{
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	57                   	push   %edi
     c34:	56                   	push   %esi
     c35:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     c36:	31 db                	xor    %ebx,%ebx
{
     c38:	83 ec 3c             	sub    $0x3c,%esp
     c3b:	90                   	nop
     c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
     c40:	8d 44 9d c0          	lea    -0x40(%ebp,%ebx,4),%eax
     c44:	83 ec 04             	sub    $0x4,%esp
     c47:	8d 75 c0             	lea    -0x40(%ebp),%esi
     c4a:	53                   	push   %ebx
     c4b:	68 70 06 00 00       	push   $0x670
     c50:	50                   	push   %eax
     c51:	e8 44 08 00 00       	call   149a <thread_create>
     c56:	83 c4 10             	add    $0x10,%esp
     c59:	85 c0                	test   %eax,%eax
     c5b:	75 53                	jne    cb0 <killtest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
     c5d:	83 c3 01             	add    $0x1,%ebx
     c60:	83 fb 0a             	cmp    $0xa,%ebx
     c63:	75 db                	jne    c40 <killtest+0x10>
     c65:	8d 7d e8             	lea    -0x18(%ebp),%edi
     c68:	8d 5d bc             	lea    -0x44(%ebp),%ebx
    if (thread_join(threads[i], &retval) != 0){
     c6b:	83 ec 08             	sub    $0x8,%esp
     c6e:	53                   	push   %ebx
     c6f:	ff 36                	pushl  (%esi)
     c71:	e8 34 08 00 00       	call   14aa <thread_join>
     c76:	83 c4 10             	add    $0x10,%esp
     c79:	85 c0                	test   %eax,%eax
     c7b:	75 13                	jne    c90 <killtest+0x60>
     c7d:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     c80:	39 fe                	cmp    %edi,%esi
     c82:	75 e7                	jne    c6b <killtest+0x3b>
     c84:	eb fe                	jmp    c84 <killtest+0x54>
     c86:	8d 76 00             	lea    0x0(%esi),%esi
     c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     c90:	83 ec 08             	sub    $0x8,%esp
     c93:	68 f3 18 00 00       	push   $0x18f3
     c98:	6a 01                	push   $0x1
     c9a:	e8 c1 08 00 00       	call   1560 <printf>
      return -1;
     c9f:	83 c4 10             	add    $0x10,%esp
}
     ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ca5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     caa:	5b                   	pop    %ebx
     cab:	5e                   	pop    %esi
     cac:	5f                   	pop    %edi
     cad:	5d                   	pop    %ebp
     cae:	c3                   	ret    
     caf:	90                   	nop
      printf(1, "panic at thread_create\n");
     cb0:	83 ec 08             	sub    $0x8,%esp
     cb3:	68 cb 18 00 00       	push   $0x18cb
     cb8:	6a 01                	push   $0x1
     cba:	e8 a1 08 00 00       	call   1560 <printf>
     cbf:	83 c4 10             	add    $0x10,%esp
}
     cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cca:	5b                   	pop    %ebx
     ccb:	5e                   	pop    %esi
     ccc:	5f                   	pop    %edi
     ccd:	5d                   	pop    %ebp
     cce:	c3                   	ret    
     ccf:	90                   	nop

00000cd0 <sbrkthreadmain>:
{
     cd0:	55                   	push   %ebp
     cd1:	89 e5                	mov    %esp,%ebp
     cd3:	57                   	push   %edi
     cd4:	56                   	push   %esi
     cd5:	53                   	push   %ebx
     cd6:	83 ec 18             	sub    $0x18,%esp
     cd9:	8b 75 08             	mov    0x8(%ebp),%esi
  oldbrk = sbrk(1000);
     cdc:	68 e8 03 00 00       	push   $0x3e8
     ce1:	e8 74 07 00 00       	call   145a <sbrk>
     ce6:	8d 56 01             	lea    0x1(%esi),%edx
  end = oldbrk + 1000;
     ce9:	8d b8 e8 03 00 00    	lea    0x3e8(%eax),%edi
  oldbrk = sbrk(1000);
     cef:	89 c3                	mov    %eax,%ebx
     cf1:	83 c4 10             	add    $0x10,%esp
     cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *c = tid+1;
     cf8:	88 10                	mov    %dl,(%eax)
  for (c = oldbrk; c < end; c++){
     cfa:	83 c0 01             	add    $0x1,%eax
     cfd:	39 c7                	cmp    %eax,%edi
     cff:	75 f7                	jne    cf8 <sbrkthreadmain+0x28>
  sleep(1);
     d01:	83 ec 0c             	sub    $0xc,%esp
    if (*c != tid+1){
     d04:	83 c6 01             	add    $0x1,%esi
  sleep(1);
     d07:	6a 01                	push   $0x1
     d09:	e8 54 07 00 00       	call   1462 <sleep>
    if (*c != tid+1){
     d0e:	0f be 13             	movsbl (%ebx),%edx
     d11:	83 c4 10             	add    $0x10,%esp
     d14:	39 d6                	cmp    %edx,%esi
     d16:	89 d0                	mov    %edx,%eax
     d18:	74 0a                	je     d24 <sbrkthreadmain+0x54>
     d1a:	eb 23                	jmp    d3f <sbrkthreadmain+0x6f>
     d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d20:	38 03                	cmp    %al,(%ebx)
     d22:	75 1b                	jne    d3f <sbrkthreadmain+0x6f>
  for (c = oldbrk; c < end; c++){
     d24:	83 c3 01             	add    $0x1,%ebx
     d27:	39 df                	cmp    %ebx,%edi
     d29:	75 f5                	jne    d20 <sbrkthreadmain+0x50>
  thread_exit(0);
     d2b:	83 ec 0c             	sub    $0xc,%esp
     d2e:	6a 00                	push   $0x0
     d30:	e8 6d 07 00 00       	call   14a2 <thread_exit>
}
     d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d38:	31 c0                	xor    %eax,%eax
     d3a:	5b                   	pop    %ebx
     d3b:	5e                   	pop    %esi
     d3c:	5f                   	pop    %edi
     d3d:	5d                   	pop    %ebp
     d3e:	c3                   	ret    
      printf(1, "panic at sbrkthreadmain\n");
     d3f:	83 ec 08             	sub    $0x8,%esp
     d42:	68 f4 19 00 00       	push   $0x19f4
     d47:	6a 01                	push   $0x1
     d49:	e8 12 08 00 00       	call   1560 <printf>
      exit();
     d4e:	e8 7f 06 00 00       	call   13d2 <exit>
     d53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d60 <sleeptest>:
{
     d60:	55                   	push   %ebp
     d61:	89 e5                	mov    %esp,%ebp
     d63:	56                   	push   %esi
     d64:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     d65:	31 db                	xor    %ebx,%ebx
{
     d67:	83 ec 30             	sub    $0x30,%esp
     d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
     d70:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
     d74:	83 ec 04             	sub    $0x4,%esp
     d77:	53                   	push   %ebx
     d78:	68 d0 02 00 00       	push   $0x2d0
     d7d:	50                   	push   %eax
     d7e:	e8 17 07 00 00       	call   149a <thread_create>
     d83:	83 c4 10             	add    $0x10,%esp
     d86:	85 c0                	test   %eax,%eax
     d88:	89 c6                	mov    %eax,%esi
     d8a:	75 24                	jne    db0 <sleeptest+0x50>
  for (i = 0; i < NUM_THREAD; i++){
     d8c:	83 c3 01             	add    $0x1,%ebx
     d8f:	83 fb 0a             	cmp    $0xa,%ebx
     d92:	75 dc                	jne    d70 <sleeptest+0x10>
  sleep(10);
     d94:	83 ec 0c             	sub    $0xc,%esp
     d97:	6a 0a                	push   $0xa
     d99:	e8 c4 06 00 00       	call   1462 <sleep>
  return 0;
     d9e:	83 c4 10             	add    $0x10,%esp
}
     da1:	8d 65 f8             	lea    -0x8(%ebp),%esp
     da4:	89 f0                	mov    %esi,%eax
     da6:	5b                   	pop    %ebx
     da7:	5e                   	pop    %esi
     da8:	5d                   	pop    %ebp
     da9:	c3                   	ret    
     daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
     db0:	83 ec 08             	sub    $0x8,%esp
     db3:	be ff ff ff ff       	mov    $0xffffffff,%esi
     db8:	68 cb 18 00 00       	push   $0x18cb
     dbd:	6a 01                	push   $0x1
     dbf:	e8 9c 07 00 00       	call   1560 <printf>
     dc4:	83 c4 10             	add    $0x10,%esp
}
     dc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dca:	89 f0                	mov    %esi,%eax
     dcc:	5b                   	pop    %ebx
     dcd:	5e                   	pop    %esi
     dce:	5d                   	pop    %ebp
     dcf:	c3                   	ret    

00000dd0 <forktest>:
{
     dd0:	55                   	push   %ebp
     dd1:	89 e5                	mov    %esp,%ebp
     dd3:	57                   	push   %edi
     dd4:	56                   	push   %esi
     dd5:	8d 75 c0             	lea    -0x40(%ebp),%esi
     dd8:	53                   	push   %ebx
     dd9:	8d 7d e8             	lea    -0x18(%ebp),%edi
     ddc:	83 ec 3c             	sub    $0x3c,%esp
     ddf:	89 f3                	mov    %esi,%ebx
     de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
     de8:	83 ec 04             	sub    $0x4,%esp
     deb:	6a 00                	push   $0x0
     ded:	68 60 09 00 00       	push   $0x960
     df2:	53                   	push   %ebx
     df3:	e8 a2 06 00 00       	call   149a <thread_create>
     df8:	83 c4 10             	add    $0x10,%esp
     dfb:	85 c0                	test   %eax,%eax
     dfd:	75 39                	jne    e38 <forktest+0x68>
     dff:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     e02:	39 fb                	cmp    %edi,%ebx
     e04:	75 e2                	jne    de8 <forktest+0x18>
     e06:	8d 7d bc             	lea    -0x44(%ebp),%edi
     e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     e10:	83 ec 08             	sub    $0x8,%esp
     e13:	57                   	push   %edi
     e14:	ff 36                	pushl  (%esi)
     e16:	e8 8f 06 00 00       	call   14aa <thread_join>
     e1b:	83 c4 10             	add    $0x10,%esp
     e1e:	85 c0                	test   %eax,%eax
     e20:	75 3e                	jne    e60 <forktest+0x90>
     e22:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     e25:	39 de                	cmp    %ebx,%esi
     e27:	75 e7                	jne    e10 <forktest+0x40>
}
     e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e2c:	5b                   	pop    %ebx
     e2d:	5e                   	pop    %esi
     e2e:	5f                   	pop    %edi
     e2f:	5d                   	pop    %ebp
     e30:	c3                   	ret    
     e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     e38:	83 ec 08             	sub    $0x8,%esp
     e3b:	68 cb 18 00 00       	push   $0x18cb
     e40:	6a 01                	push   $0x1
     e42:	e8 19 07 00 00       	call   1560 <printf>
      return -1;
     e47:	83 c4 10             	add    $0x10,%esp
}
     e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
     e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     e52:	5b                   	pop    %ebx
     e53:	5e                   	pop    %esi
     e54:	5f                   	pop    %edi
     e55:	5d                   	pop    %ebp
     e56:	c3                   	ret    
     e57:	89 f6                	mov    %esi,%esi
     e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     e60:	83 ec 08             	sub    $0x8,%esp
     e63:	68 f3 18 00 00       	push   $0x18f3
     e68:	6a 01                	push   $0x1
     e6a:	e8 f1 06 00 00       	call   1560 <printf>
     e6f:	83 c4 10             	add    $0x10,%esp
}
     e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
     e75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     e7a:	5b                   	pop    %ebx
     e7b:	5e                   	pop    %esi
     e7c:	5f                   	pop    %edi
     e7d:	5d                   	pop    %ebp
     e7e:	c3                   	ret    
     e7f:	90                   	nop

00000e80 <sbrktest>:
{
     e80:	55                   	push   %ebp
     e81:	89 e5                	mov    %esp,%ebp
     e83:	57                   	push   %edi
     e84:	56                   	push   %esi
     e85:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     e86:	31 db                	xor    %ebx,%ebx
{
     e88:	83 ec 3c             	sub    $0x3c,%esp
     e8b:	90                   	nop
     e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
     e90:	8d 44 9d c0          	lea    -0x40(%ebp,%ebx,4),%eax
     e94:	83 ec 04             	sub    $0x4,%esp
     e97:	8d 75 c0             	lea    -0x40(%ebp),%esi
     e9a:	53                   	push   %ebx
     e9b:	68 d0 0c 00 00       	push   $0xcd0
     ea0:	50                   	push   %eax
     ea1:	e8 f4 05 00 00       	call   149a <thread_create>
     ea6:	83 c4 10             	add    $0x10,%esp
     ea9:	85 c0                	test   %eax,%eax
     eab:	75 3b                	jne    ee8 <sbrktest+0x68>
  for (i = 0; i < NUM_THREAD; i++){
     ead:	83 c3 01             	add    $0x1,%ebx
     eb0:	83 fb 0a             	cmp    $0xa,%ebx
     eb3:	75 db                	jne    e90 <sbrktest+0x10>
     eb5:	8d 7d e8             	lea    -0x18(%ebp),%edi
     eb8:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     ebb:	90                   	nop
     ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     ec0:	83 ec 08             	sub    $0x8,%esp
     ec3:	53                   	push   %ebx
     ec4:	ff 36                	pushl  (%esi)
     ec6:	e8 df 05 00 00       	call   14aa <thread_join>
     ecb:	83 c4 10             	add    $0x10,%esp
     ece:	85 c0                	test   %eax,%eax
     ed0:	75 3e                	jne    f10 <sbrktest+0x90>
     ed2:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     ed5:	39 fe                	cmp    %edi,%esi
     ed7:	75 e7                	jne    ec0 <sbrktest+0x40>
}
     ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     edc:	5b                   	pop    %ebx
     edd:	5e                   	pop    %esi
     ede:	5f                   	pop    %edi
     edf:	5d                   	pop    %ebp
     ee0:	c3                   	ret    
     ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     ee8:	83 ec 08             	sub    $0x8,%esp
     eeb:	68 cb 18 00 00       	push   $0x18cb
     ef0:	6a 01                	push   $0x1
     ef2:	e8 69 06 00 00       	call   1560 <printf>
      return -1;
     ef7:	83 c4 10             	add    $0x10,%esp
}
     efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
     efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f02:	5b                   	pop    %ebx
     f03:	5e                   	pop    %esi
     f04:	5f                   	pop    %edi
     f05:	5d                   	pop    %ebp
     f06:	c3                   	ret    
     f07:	89 f6                	mov    %esi,%esi
     f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     f10:	83 ec 08             	sub    $0x8,%esp
     f13:	68 f3 18 00 00       	push   $0x18f3
     f18:	6a 01                	push   $0x1
     f1a:	e8 41 06 00 00       	call   1560 <printf>
     f1f:	83 c4 10             	add    $0x10,%esp
}
     f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
     f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f2a:	5b                   	pop    %ebx
     f2b:	5e                   	pop    %esi
     f2c:	5f                   	pop    %edi
     f2d:	5d                   	pop    %ebp
     f2e:	c3                   	ret    
     f2f:	90                   	nop

00000f30 <basictest>:
{
     f30:	55                   	push   %ebp
     f31:	89 e5                	mov    %esp,%ebp
     f33:	56                   	push   %esi
     f34:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     f35:	31 db                	xor    %ebx,%ebx
{
     f37:	83 ec 40             	sub    $0x40,%esp
     f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
     f40:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
     f44:	83 ec 04             	sub    $0x4,%esp
     f47:	53                   	push   %ebx
     f48:	68 10 02 00 00       	push   $0x210
     f4d:	50                   	push   %eax
     f4e:	e8 47 05 00 00       	call   149a <thread_create>
     f53:	83 c4 10             	add    $0x10,%esp
     f56:	85 c0                	test   %eax,%eax
     f58:	89 c6                	mov    %eax,%esi
     f5a:	75 54                	jne    fb0 <basictest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
     f5c:	83 c3 01             	add    $0x1,%ebx
     f5f:	83 fb 0a             	cmp    $0xa,%ebx
     f62:	75 dc                	jne    f40 <basictest+0x10>
     f64:	8d 5d cc             	lea    -0x34(%ebp),%ebx
     f67:	89 f6                	mov    %esi,%esi
     f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     f70:	83 ec 08             	sub    $0x8,%esp
     f73:	53                   	push   %ebx
     f74:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
     f78:	e8 2d 05 00 00       	call   14aa <thread_join>
     f7d:	83 c4 10             	add    $0x10,%esp
     f80:	85 c0                	test   %eax,%eax
     f82:	75 4c                	jne    fd0 <basictest+0xa0>
     f84:	83 c6 01             	add    $0x1,%esi
     f87:	39 75 cc             	cmp    %esi,-0x34(%ebp)
     f8a:	75 44                	jne    fd0 <basictest+0xa0>
  for (i = 0; i < NUM_THREAD; i++){
     f8c:	83 fe 0a             	cmp    $0xa,%esi
     f8f:	75 df                	jne    f70 <basictest+0x40>
  printf(1,"\n");
     f91:	83 ec 08             	sub    $0x8,%esp
     f94:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     f97:	68 f1 18 00 00       	push   $0x18f1
     f9c:	6a 01                	push   $0x1
     f9e:	e8 bd 05 00 00       	call   1560 <printf>
  return 0;
     fa3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     fa6:	83 c4 10             	add    $0x10,%esp
}
     fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
     fac:	5b                   	pop    %ebx
     fad:	5e                   	pop    %esi
     fae:	5d                   	pop    %ebp
     faf:	c3                   	ret    
      printf(1, "panic at thread_create\n");
     fb0:	83 ec 08             	sub    $0x8,%esp
     fb3:	68 cb 18 00 00       	push   $0x18cb
     fb8:	6a 01                	push   $0x1
     fba:	e8 a1 05 00 00       	call   1560 <printf>
      return -1;
     fbf:	83 c4 10             	add    $0x10,%esp
}
     fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     fca:	5b                   	pop    %ebx
     fcb:	5e                   	pop    %esi
     fcc:	5d                   	pop    %ebp
     fcd:	c3                   	ret    
     fce:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     fd0:	83 ec 08             	sub    $0x8,%esp
     fd3:	68 f3 18 00 00       	push   $0x18f3
     fd8:	6a 01                	push   $0x1
     fda:	e8 81 05 00 00       	call   1560 <printf>
     fdf:	83 c4 10             	add    $0x10,%esp
}
     fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
     fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     fea:	5b                   	pop    %ebx
     feb:	5e                   	pop    %esi
     fec:	5d                   	pop    %ebp
     fed:	c3                   	ret    
     fee:	66 90                	xchg   %ax,%ax

00000ff0 <exectest>:
{
     ff0:	55                   	push   %ebp
     ff1:	89 e5                	mov    %esp,%ebp
     ff3:	57                   	push   %edi
     ff4:	56                   	push   %esi
     ff5:	8d 75 c0             	lea    -0x40(%ebp),%esi
     ff8:	53                   	push   %ebx
     ff9:	8d 7d e8             	lea    -0x18(%ebp),%edi
     ffc:	83 ec 4c             	sub    $0x4c,%esp
     fff:	89 f3                	mov    %esi,%ebx
    1001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
    1008:	83 ec 04             	sub    $0x4,%esp
    100b:	6a 00                	push   $0x0
    100d:	68 20 06 00 00       	push   $0x620
    1012:	53                   	push   %ebx
    1013:	e8 82 04 00 00       	call   149a <thread_create>
    1018:	83 c4 10             	add    $0x10,%esp
    101b:	85 c0                	test   %eax,%eax
    101d:	75 51                	jne    1070 <exectest+0x80>
    101f:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
    1022:	39 fb                	cmp    %edi,%ebx
    1024:	75 e2                	jne    1008 <exectest+0x18>
    1026:	8d 7d bc             	lea    -0x44(%ebp),%edi
    1029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
    1030:	83 ec 08             	sub    $0x8,%esp
    1033:	57                   	push   %edi
    1034:	ff 36                	pushl  (%esi)
    1036:	e8 6f 04 00 00       	call   14aa <thread_join>
    103b:	83 c4 10             	add    $0x10,%esp
    103e:	85 c0                	test   %eax,%eax
    1040:	75 4e                	jne    1090 <exectest+0xa0>
    1042:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
    1045:	39 de                	cmp    %ebx,%esi
    1047:	75 e7                	jne    1030 <exectest+0x40>
  printf(1, "panic at exectest\n");
    1049:	83 ec 08             	sub    $0x8,%esp
    104c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    104f:	68 0d 1a 00 00       	push   $0x1a0d
    1054:	6a 01                	push   $0x1
    1056:	e8 05 05 00 00       	call   1560 <printf>
  return 0;
    105b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    105e:	83 c4 10             	add    $0x10,%esp
}
    1061:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1064:	5b                   	pop    %ebx
    1065:	5e                   	pop    %esi
    1066:	5f                   	pop    %edi
    1067:	5d                   	pop    %ebp
    1068:	c3                   	ret    
    1069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
    1070:	83 ec 08             	sub    $0x8,%esp
    1073:	68 cb 18 00 00       	push   $0x18cb
    1078:	6a 01                	push   $0x1
    107a:	e8 e1 04 00 00       	call   1560 <printf>
      return -1;
    107f:	83 c4 10             	add    $0x10,%esp
}
    1082:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
    1085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    108a:	5b                   	pop    %ebx
    108b:	5e                   	pop    %esi
    108c:	5f                   	pop    %edi
    108d:	5d                   	pop    %ebp
    108e:	c3                   	ret    
    108f:	90                   	nop
      printf(1, "panic at thread_join\n");
    1090:	83 ec 08             	sub    $0x8,%esp
    1093:	68 f3 18 00 00       	push   $0x18f3
    1098:	6a 01                	push   $0x1
    109a:	e8 c1 04 00 00       	call   1560 <printf>
    109f:	83 c4 10             	add    $0x10,%esp
}
    10a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
    10a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    10aa:	5b                   	pop    %ebx
    10ab:	5e                   	pop    %esi
    10ac:	5f                   	pop    %edi
    10ad:	5d                   	pop    %ebp
    10ae:	c3                   	ret    
    10af:	90                   	nop

000010b0 <racingtest>:
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	56                   	push   %esi
    10b4:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
    10b5:	31 db                	xor    %ebx,%ebx
{
    10b7:	83 ec 40             	sub    $0x40,%esp
  gcnt = 0;
    10ba:	c7 05 a4 23 00 00 00 	movl   $0x0,0x23a4
    10c1:	00 00 00 
    10c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
    10c8:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
    10cc:	83 ec 04             	sub    $0x4,%esp
    10cf:	53                   	push   %ebx
    10d0:	68 d0 01 00 00       	push   $0x1d0
    10d5:	50                   	push   %eax
    10d6:	e8 bf 03 00 00       	call   149a <thread_create>
    10db:	83 c4 10             	add    $0x10,%esp
    10de:	85 c0                	test   %eax,%eax
    10e0:	89 c6                	mov    %eax,%esi
    10e2:	75 5c                	jne    1140 <racingtest+0x90>
  for (i = 0; i < NUM_THREAD; i++){
    10e4:	83 c3 01             	add    $0x1,%ebx
    10e7:	83 fb 0a             	cmp    $0xa,%ebx
    10ea:	75 dc                	jne    10c8 <racingtest+0x18>
    10ec:	8d 5d cc             	lea    -0x34(%ebp),%ebx
    10ef:	90                   	nop
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
    10f0:	83 ec 08             	sub    $0x8,%esp
    10f3:	53                   	push   %ebx
    10f4:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
    10f8:	e8 ad 03 00 00       	call   14aa <thread_join>
    10fd:	83 c4 10             	add    $0x10,%esp
    1100:	85 c0                	test   %eax,%eax
    1102:	75 5c                	jne    1160 <racingtest+0xb0>
    1104:	83 c6 01             	add    $0x1,%esi
    1107:	39 75 cc             	cmp    %esi,-0x34(%ebp)
    110a:	75 54                	jne    1160 <racingtest+0xb0>
  for (i = 0; i < NUM_THREAD; i++){
    110c:	83 fe 0a             	cmp    $0xa,%esi
    110f:	75 df                	jne    10f0 <racingtest+0x40>
  printf(1,"%d\n", gcnt);
    1111:	8b 15 a4 23 00 00    	mov    0x23a4,%edx
    1117:	83 ec 04             	sub    $0x4,%esp
    111a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    111d:	52                   	push   %edx
    111e:	68 b5 19 00 00       	push   $0x19b5
    1123:	6a 01                	push   $0x1
    1125:	e8 36 04 00 00       	call   1560 <printf>
  return 0;
    112a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    112d:	83 c4 10             	add    $0x10,%esp
}
    1130:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1133:	5b                   	pop    %ebx
    1134:	5e                   	pop    %esi
    1135:	5d                   	pop    %ebp
    1136:	c3                   	ret    
    1137:	89 f6                	mov    %esi,%esi
    1139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
    1140:	83 ec 08             	sub    $0x8,%esp
    1143:	68 cb 18 00 00       	push   $0x18cb
    1148:	6a 01                	push   $0x1
    114a:	e8 11 04 00 00       	call   1560 <printf>
      return -1;
    114f:	83 c4 10             	add    $0x10,%esp
}
    1152:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
    1155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    115a:	5b                   	pop    %ebx
    115b:	5e                   	pop    %esi
    115c:	5d                   	pop    %ebp
    115d:	c3                   	ret    
    115e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
    1160:	83 ec 08             	sub    $0x8,%esp
    1163:	68 f3 18 00 00       	push   $0x18f3
    1168:	6a 01                	push   $0x1
    116a:	e8 f1 03 00 00       	call   1560 <printf>
    116f:	83 c4 10             	add    $0x10,%esp
}
    1172:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
    1175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    117a:	5b                   	pop    %ebx
    117b:	5e                   	pop    %esi
    117c:	5d                   	pop    %ebp
    117d:	c3                   	ret    
    117e:	66 90                	xchg   %ax,%ax

00001180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	53                   	push   %ebx
    1184:	8b 45 08             	mov    0x8(%ebp),%eax
    1187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    118a:	89 c2                	mov    %eax,%edx
    118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1190:	83 c1 01             	add    $0x1,%ecx
    1193:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1197:	83 c2 01             	add    $0x1,%edx
    119a:	84 db                	test   %bl,%bl
    119c:	88 5a ff             	mov    %bl,-0x1(%edx)
    119f:	75 ef                	jne    1190 <strcpy+0x10>
    ;
  return os;
}
    11a1:	5b                   	pop    %ebx
    11a2:	5d                   	pop    %ebp
    11a3:	c3                   	ret    
    11a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000011b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	53                   	push   %ebx
    11b4:	8b 55 08             	mov    0x8(%ebp),%edx
    11b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    11ba:	0f b6 02             	movzbl (%edx),%eax
    11bd:	0f b6 19             	movzbl (%ecx),%ebx
    11c0:	84 c0                	test   %al,%al
    11c2:	75 1c                	jne    11e0 <strcmp+0x30>
    11c4:	eb 2a                	jmp    11f0 <strcmp+0x40>
    11c6:	8d 76 00             	lea    0x0(%esi),%esi
    11c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    11d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    11d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    11d6:	83 c1 01             	add    $0x1,%ecx
    11d9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    11dc:	84 c0                	test   %al,%al
    11de:	74 10                	je     11f0 <strcmp+0x40>
    11e0:	38 d8                	cmp    %bl,%al
    11e2:	74 ec                	je     11d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    11e4:	29 d8                	sub    %ebx,%eax
}
    11e6:	5b                   	pop    %ebx
    11e7:	5d                   	pop    %ebp
    11e8:	c3                   	ret    
    11e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    11f2:	29 d8                	sub    %ebx,%eax
}
    11f4:	5b                   	pop    %ebx
    11f5:	5d                   	pop    %ebp
    11f6:	c3                   	ret    
    11f7:	89 f6                	mov    %esi,%esi
    11f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001200 <strlen>:

uint
strlen(const char *s)
{
    1200:	55                   	push   %ebp
    1201:	89 e5                	mov    %esp,%ebp
    1203:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1206:	80 39 00             	cmpb   $0x0,(%ecx)
    1209:	74 15                	je     1220 <strlen+0x20>
    120b:	31 d2                	xor    %edx,%edx
    120d:	8d 76 00             	lea    0x0(%esi),%esi
    1210:	83 c2 01             	add    $0x1,%edx
    1213:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1217:	89 d0                	mov    %edx,%eax
    1219:	75 f5                	jne    1210 <strlen+0x10>
    ;
  return n;
}
    121b:	5d                   	pop    %ebp
    121c:	c3                   	ret    
    121d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    1220:	31 c0                	xor    %eax,%eax
}
    1222:	5d                   	pop    %ebp
    1223:	c3                   	ret    
    1224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    122a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001230 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1230:	55                   	push   %ebp
    1231:	89 e5                	mov    %esp,%ebp
    1233:	57                   	push   %edi
    1234:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1237:	8b 4d 10             	mov    0x10(%ebp),%ecx
    123a:	8b 45 0c             	mov    0xc(%ebp),%eax
    123d:	89 d7                	mov    %edx,%edi
    123f:	fc                   	cld    
    1240:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1242:	89 d0                	mov    %edx,%eax
    1244:	5f                   	pop    %edi
    1245:	5d                   	pop    %ebp
    1246:	c3                   	ret    
    1247:	89 f6                	mov    %esi,%esi
    1249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001250 <strchr>:

char*
strchr(const char *s, char c)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	53                   	push   %ebx
    1254:	8b 45 08             	mov    0x8(%ebp),%eax
    1257:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    125a:	0f b6 10             	movzbl (%eax),%edx
    125d:	84 d2                	test   %dl,%dl
    125f:	74 1d                	je     127e <strchr+0x2e>
    if(*s == c)
    1261:	38 d3                	cmp    %dl,%bl
    1263:	89 d9                	mov    %ebx,%ecx
    1265:	75 0d                	jne    1274 <strchr+0x24>
    1267:	eb 17                	jmp    1280 <strchr+0x30>
    1269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1270:	38 ca                	cmp    %cl,%dl
    1272:	74 0c                	je     1280 <strchr+0x30>
  for(; *s; s++)
    1274:	83 c0 01             	add    $0x1,%eax
    1277:	0f b6 10             	movzbl (%eax),%edx
    127a:	84 d2                	test   %dl,%dl
    127c:	75 f2                	jne    1270 <strchr+0x20>
      return (char*)s;
  return 0;
    127e:	31 c0                	xor    %eax,%eax
}
    1280:	5b                   	pop    %ebx
    1281:	5d                   	pop    %ebp
    1282:	c3                   	ret    
    1283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001290 <gets>:

char*
gets(char *buf, int max)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	57                   	push   %edi
    1294:	56                   	push   %esi
    1295:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1296:	31 f6                	xor    %esi,%esi
    1298:	89 f3                	mov    %esi,%ebx
{
    129a:	83 ec 1c             	sub    $0x1c,%esp
    129d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    12a0:	eb 2f                	jmp    12d1 <gets+0x41>
    12a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    12a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
    12ab:	83 ec 04             	sub    $0x4,%esp
    12ae:	6a 01                	push   $0x1
    12b0:	50                   	push   %eax
    12b1:	6a 00                	push   $0x0
    12b3:	e8 32 01 00 00       	call   13ea <read>
    if(cc < 1)
    12b8:	83 c4 10             	add    $0x10,%esp
    12bb:	85 c0                	test   %eax,%eax
    12bd:	7e 1c                	jle    12db <gets+0x4b>
      break;
    buf[i++] = c;
    12bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    12c3:	83 c7 01             	add    $0x1,%edi
    12c6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    12c9:	3c 0a                	cmp    $0xa,%al
    12cb:	74 23                	je     12f0 <gets+0x60>
    12cd:	3c 0d                	cmp    $0xd,%al
    12cf:	74 1f                	je     12f0 <gets+0x60>
  for(i=0; i+1 < max; ){
    12d1:	83 c3 01             	add    $0x1,%ebx
    12d4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    12d7:	89 fe                	mov    %edi,%esi
    12d9:	7c cd                	jl     12a8 <gets+0x18>
    12db:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    12dd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    12e0:	c6 03 00             	movb   $0x0,(%ebx)
}
    12e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12e6:	5b                   	pop    %ebx
    12e7:	5e                   	pop    %esi
    12e8:	5f                   	pop    %edi
    12e9:	5d                   	pop    %ebp
    12ea:	c3                   	ret    
    12eb:	90                   	nop
    12ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12f0:	8b 75 08             	mov    0x8(%ebp),%esi
    12f3:	8b 45 08             	mov    0x8(%ebp),%eax
    12f6:	01 de                	add    %ebx,%esi
    12f8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    12fa:	c6 03 00             	movb   $0x0,(%ebx)
}
    12fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1300:	5b                   	pop    %ebx
    1301:	5e                   	pop    %esi
    1302:	5f                   	pop    %edi
    1303:	5d                   	pop    %ebp
    1304:	c3                   	ret    
    1305:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001310 <stat>:

int
stat(const char *n, struct stat *st)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	56                   	push   %esi
    1314:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1315:	83 ec 08             	sub    $0x8,%esp
    1318:	6a 00                	push   $0x0
    131a:	ff 75 08             	pushl  0x8(%ebp)
    131d:	e8 f0 00 00 00       	call   1412 <open>
  if(fd < 0)
    1322:	83 c4 10             	add    $0x10,%esp
    1325:	85 c0                	test   %eax,%eax
    1327:	78 27                	js     1350 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1329:	83 ec 08             	sub    $0x8,%esp
    132c:	ff 75 0c             	pushl  0xc(%ebp)
    132f:	89 c3                	mov    %eax,%ebx
    1331:	50                   	push   %eax
    1332:	e8 f3 00 00 00       	call   142a <fstat>
  close(fd);
    1337:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    133a:	89 c6                	mov    %eax,%esi
  close(fd);
    133c:	e8 b9 00 00 00       	call   13fa <close>
  return r;
    1341:	83 c4 10             	add    $0x10,%esp
}
    1344:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1347:	89 f0                	mov    %esi,%eax
    1349:	5b                   	pop    %ebx
    134a:	5e                   	pop    %esi
    134b:	5d                   	pop    %ebp
    134c:	c3                   	ret    
    134d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1350:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1355:	eb ed                	jmp    1344 <stat+0x34>
    1357:	89 f6                	mov    %esi,%esi
    1359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001360 <atoi>:

int
atoi(const char *s)
{
    1360:	55                   	push   %ebp
    1361:	89 e5                	mov    %esp,%ebp
    1363:	53                   	push   %ebx
    1364:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1367:	0f be 11             	movsbl (%ecx),%edx
    136a:	8d 42 d0             	lea    -0x30(%edx),%eax
    136d:	3c 09                	cmp    $0x9,%al
  n = 0;
    136f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1374:	77 1f                	ja     1395 <atoi+0x35>
    1376:	8d 76 00             	lea    0x0(%esi),%esi
    1379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1380:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1383:	83 c1 01             	add    $0x1,%ecx
    1386:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    138a:	0f be 11             	movsbl (%ecx),%edx
    138d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1390:	80 fb 09             	cmp    $0x9,%bl
    1393:	76 eb                	jbe    1380 <atoi+0x20>
  return n;
}
    1395:	5b                   	pop    %ebx
    1396:	5d                   	pop    %ebp
    1397:	c3                   	ret    
    1398:	90                   	nop
    1399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000013a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    13a0:	55                   	push   %ebp
    13a1:	89 e5                	mov    %esp,%ebp
    13a3:	56                   	push   %esi
    13a4:	53                   	push   %ebx
    13a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13a8:	8b 45 08             	mov    0x8(%ebp),%eax
    13ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13ae:	85 db                	test   %ebx,%ebx
    13b0:	7e 14                	jle    13c6 <memmove+0x26>
    13b2:	31 d2                	xor    %edx,%edx
    13b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    13b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    13bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    13bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    13c2:	39 d3                	cmp    %edx,%ebx
    13c4:	75 f2                	jne    13b8 <memmove+0x18>
  return vdst;
}
    13c6:	5b                   	pop    %ebx
    13c7:	5e                   	pop    %esi
    13c8:	5d                   	pop    %ebp
    13c9:	c3                   	ret    

000013ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13ca:	b8 01 00 00 00       	mov    $0x1,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <exit>:
SYSCALL(exit)
    13d2:	b8 02 00 00 00       	mov    $0x2,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <wait>:
SYSCALL(wait)
    13da:	b8 03 00 00 00       	mov    $0x3,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <pipe>:
SYSCALL(pipe)
    13e2:	b8 04 00 00 00       	mov    $0x4,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <read>:
SYSCALL(read)
    13ea:	b8 05 00 00 00       	mov    $0x5,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <write>:
SYSCALL(write)
    13f2:	b8 10 00 00 00       	mov    $0x10,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <close>:
SYSCALL(close)
    13fa:	b8 15 00 00 00       	mov    $0x15,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <kill>:
SYSCALL(kill)
    1402:	b8 06 00 00 00       	mov    $0x6,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <exec>:
SYSCALL(exec)
    140a:	b8 07 00 00 00       	mov    $0x7,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <open>:
SYSCALL(open)
    1412:	b8 0f 00 00 00       	mov    $0xf,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <mknod>:
SYSCALL(mknod)
    141a:	b8 11 00 00 00       	mov    $0x11,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <unlink>:
SYSCALL(unlink)
    1422:	b8 12 00 00 00       	mov    $0x12,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <fstat>:
SYSCALL(fstat)
    142a:	b8 08 00 00 00       	mov    $0x8,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <link>:
SYSCALL(link)
    1432:	b8 13 00 00 00       	mov    $0x13,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <mkdir>:
SYSCALL(mkdir)
    143a:	b8 14 00 00 00       	mov    $0x14,%eax
    143f:	cd 40                	int    $0x40
    1441:	c3                   	ret    

00001442 <chdir>:
SYSCALL(chdir)
    1442:	b8 09 00 00 00       	mov    $0x9,%eax
    1447:	cd 40                	int    $0x40
    1449:	c3                   	ret    

0000144a <dup>:
SYSCALL(dup)
    144a:	b8 0a 00 00 00       	mov    $0xa,%eax
    144f:	cd 40                	int    $0x40
    1451:	c3                   	ret    

00001452 <getpid>:
SYSCALL(getpid)
    1452:	b8 0b 00 00 00       	mov    $0xb,%eax
    1457:	cd 40                	int    $0x40
    1459:	c3                   	ret    

0000145a <sbrk>:
SYSCALL(sbrk)
    145a:	b8 0c 00 00 00       	mov    $0xc,%eax
    145f:	cd 40                	int    $0x40
    1461:	c3                   	ret    

00001462 <sleep>:
SYSCALL(sleep)
    1462:	b8 0d 00 00 00       	mov    $0xd,%eax
    1467:	cd 40                	int    $0x40
    1469:	c3                   	ret    

0000146a <uptime>:
SYSCALL(uptime)
    146a:	b8 0e 00 00 00       	mov    $0xe,%eax
    146f:	cd 40                	int    $0x40
    1471:	c3                   	ret    

00001472 <my_syscall>:
SYSCALL(my_syscall)
    1472:	b8 16 00 00 00       	mov    $0x16,%eax
    1477:	cd 40                	int    $0x40
    1479:	c3                   	ret    

0000147a <getppid>:
SYSCALL(getppid)
    147a:	b8 17 00 00 00       	mov    $0x17,%eax
    147f:	cd 40                	int    $0x40
    1481:	c3                   	ret    

00001482 <yield>:
SYSCALL(yield)
    1482:	b8 18 00 00 00       	mov    $0x18,%eax
    1487:	cd 40                	int    $0x40
    1489:	c3                   	ret    

0000148a <set_cpu_share>:
SYSCALL(set_cpu_share)
    148a:	b8 19 00 00 00       	mov    $0x19,%eax
    148f:	cd 40                	int    $0x40
    1491:	c3                   	ret    

00001492 <getlev>:
SYSCALL(getlev)
    1492:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1497:	cd 40                	int    $0x40
    1499:	c3                   	ret    

0000149a <thread_create>:
SYSCALL(thread_create)
    149a:	b8 1b 00 00 00       	mov    $0x1b,%eax
    149f:	cd 40                	int    $0x40
    14a1:	c3                   	ret    

000014a2 <thread_exit>:
SYSCALL(thread_exit)
    14a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
    14a7:	cd 40                	int    $0x40
    14a9:	c3                   	ret    

000014aa <thread_join>:
SYSCALL(thread_join)
    14aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
    14af:	cd 40                	int    $0x40
    14b1:	c3                   	ret    
    14b2:	66 90                	xchg   %ax,%ax
    14b4:	66 90                	xchg   %ax,%ax
    14b6:	66 90                	xchg   %ax,%ax
    14b8:	66 90                	xchg   %ax,%ax
    14ba:	66 90                	xchg   %ax,%ax
    14bc:	66 90                	xchg   %ax,%ax
    14be:	66 90                	xchg   %ax,%ax

000014c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    14c0:	55                   	push   %ebp
    14c1:	89 e5                	mov    %esp,%ebp
    14c3:	57                   	push   %edi
    14c4:	56                   	push   %esi
    14c5:	53                   	push   %ebx
    14c6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    14c9:	85 d2                	test   %edx,%edx
{
    14cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    14ce:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    14d0:	79 76                	jns    1548 <printint+0x88>
    14d2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    14d6:	74 70                	je     1548 <printint+0x88>
    x = -xx;
    14d8:	f7 d8                	neg    %eax
    neg = 1;
    14da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    14e1:	31 f6                	xor    %esi,%esi
    14e3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    14e6:	eb 0a                	jmp    14f2 <printint+0x32>
    14e8:	90                   	nop
    14e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    14f0:	89 fe                	mov    %edi,%esi
    14f2:	31 d2                	xor    %edx,%edx
    14f4:	8d 7e 01             	lea    0x1(%esi),%edi
    14f7:	f7 f1                	div    %ecx
    14f9:	0f b6 92 20 1b 00 00 	movzbl 0x1b20(%edx),%edx
  }while((x /= base) != 0);
    1500:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    1502:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    1505:	75 e9                	jne    14f0 <printint+0x30>
  if(neg)
    1507:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    150a:	85 c0                	test   %eax,%eax
    150c:	74 08                	je     1516 <printint+0x56>
    buf[i++] = '-';
    150e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    1513:	8d 7e 02             	lea    0x2(%esi),%edi
    1516:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    151a:	8b 7d c0             	mov    -0x40(%ebp),%edi
    151d:	8d 76 00             	lea    0x0(%esi),%esi
    1520:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    1523:	83 ec 04             	sub    $0x4,%esp
    1526:	83 ee 01             	sub    $0x1,%esi
    1529:	6a 01                	push   $0x1
    152b:	53                   	push   %ebx
    152c:	57                   	push   %edi
    152d:	88 45 d7             	mov    %al,-0x29(%ebp)
    1530:	e8 bd fe ff ff       	call   13f2 <write>

  while(--i >= 0)
    1535:	83 c4 10             	add    $0x10,%esp
    1538:	39 de                	cmp    %ebx,%esi
    153a:	75 e4                	jne    1520 <printint+0x60>
    putc(fd, buf[i]);
}
    153c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    153f:	5b                   	pop    %ebx
    1540:	5e                   	pop    %esi
    1541:	5f                   	pop    %edi
    1542:	5d                   	pop    %ebp
    1543:	c3                   	ret    
    1544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1548:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    154f:	eb 90                	jmp    14e1 <printint+0x21>
    1551:	eb 0d                	jmp    1560 <printf>
    1553:	90                   	nop
    1554:	90                   	nop
    1555:	90                   	nop
    1556:	90                   	nop
    1557:	90                   	nop
    1558:	90                   	nop
    1559:	90                   	nop
    155a:	90                   	nop
    155b:	90                   	nop
    155c:	90                   	nop
    155d:	90                   	nop
    155e:	90                   	nop
    155f:	90                   	nop

00001560 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1560:	55                   	push   %ebp
    1561:	89 e5                	mov    %esp,%ebp
    1563:	57                   	push   %edi
    1564:	56                   	push   %esi
    1565:	53                   	push   %ebx
    1566:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1569:	8b 75 0c             	mov    0xc(%ebp),%esi
    156c:	0f b6 1e             	movzbl (%esi),%ebx
    156f:	84 db                	test   %bl,%bl
    1571:	0f 84 b3 00 00 00    	je     162a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    1577:	8d 45 10             	lea    0x10(%ebp),%eax
    157a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    157d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    157f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1582:	eb 2f                	jmp    15b3 <printf+0x53>
    1584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1588:	83 f8 25             	cmp    $0x25,%eax
    158b:	0f 84 a7 00 00 00    	je     1638 <printf+0xd8>
  write(fd, &c, 1);
    1591:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1594:	83 ec 04             	sub    $0x4,%esp
    1597:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    159a:	6a 01                	push   $0x1
    159c:	50                   	push   %eax
    159d:	ff 75 08             	pushl  0x8(%ebp)
    15a0:	e8 4d fe ff ff       	call   13f2 <write>
    15a5:	83 c4 10             	add    $0x10,%esp
    15a8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    15ab:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    15af:	84 db                	test   %bl,%bl
    15b1:	74 77                	je     162a <printf+0xca>
    if(state == 0){
    15b3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    15b5:	0f be cb             	movsbl %bl,%ecx
    15b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    15bb:	74 cb                	je     1588 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    15bd:	83 ff 25             	cmp    $0x25,%edi
    15c0:	75 e6                	jne    15a8 <printf+0x48>
      if(c == 'd'){
    15c2:	83 f8 64             	cmp    $0x64,%eax
    15c5:	0f 84 05 01 00 00    	je     16d0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    15cb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    15d1:	83 f9 70             	cmp    $0x70,%ecx
    15d4:	74 72                	je     1648 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    15d6:	83 f8 73             	cmp    $0x73,%eax
    15d9:	0f 84 99 00 00 00    	je     1678 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15df:	83 f8 63             	cmp    $0x63,%eax
    15e2:	0f 84 08 01 00 00    	je     16f0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    15e8:	83 f8 25             	cmp    $0x25,%eax
    15eb:	0f 84 ef 00 00 00    	je     16e0 <printf+0x180>
  write(fd, &c, 1);
    15f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
    15f4:	83 ec 04             	sub    $0x4,%esp
    15f7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    15fb:	6a 01                	push   $0x1
    15fd:	50                   	push   %eax
    15fe:	ff 75 08             	pushl  0x8(%ebp)
    1601:	e8 ec fd ff ff       	call   13f2 <write>
    1606:	83 c4 0c             	add    $0xc,%esp
    1609:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    160c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    160f:	6a 01                	push   $0x1
    1611:	50                   	push   %eax
    1612:	ff 75 08             	pushl  0x8(%ebp)
    1615:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1618:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    161a:	e8 d3 fd ff ff       	call   13f2 <write>
  for(i = 0; fmt[i]; i++){
    161f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    1623:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1626:	84 db                	test   %bl,%bl
    1628:	75 89                	jne    15b3 <printf+0x53>
    }
  }
}
    162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    162d:	5b                   	pop    %ebx
    162e:	5e                   	pop    %esi
    162f:	5f                   	pop    %edi
    1630:	5d                   	pop    %ebp
    1631:	c3                   	ret    
    1632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    1638:	bf 25 00 00 00       	mov    $0x25,%edi
    163d:	e9 66 ff ff ff       	jmp    15a8 <printf+0x48>
    1642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1648:	83 ec 0c             	sub    $0xc,%esp
    164b:	b9 10 00 00 00       	mov    $0x10,%ecx
    1650:	6a 00                	push   $0x0
    1652:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1655:	8b 45 08             	mov    0x8(%ebp),%eax
    1658:	8b 17                	mov    (%edi),%edx
    165a:	e8 61 fe ff ff       	call   14c0 <printint>
        ap++;
    165f:	89 f8                	mov    %edi,%eax
    1661:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1664:	31 ff                	xor    %edi,%edi
        ap++;
    1666:	83 c0 04             	add    $0x4,%eax
    1669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    166c:	e9 37 ff ff ff       	jmp    15a8 <printf+0x48>
    1671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    167b:	8b 08                	mov    (%eax),%ecx
        ap++;
    167d:	83 c0 04             	add    $0x4,%eax
    1680:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1683:	85 c9                	test   %ecx,%ecx
    1685:	0f 84 8e 00 00 00    	je     1719 <printf+0x1b9>
        while(*s != 0){
    168b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    168e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1690:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1692:	84 c0                	test   %al,%al
    1694:	0f 84 0e ff ff ff    	je     15a8 <printf+0x48>
    169a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    169d:	89 de                	mov    %ebx,%esi
    169f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    16a5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    16a8:	83 ec 04             	sub    $0x4,%esp
          s++;
    16ab:	83 c6 01             	add    $0x1,%esi
    16ae:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    16b1:	6a 01                	push   $0x1
    16b3:	57                   	push   %edi
    16b4:	53                   	push   %ebx
    16b5:	e8 38 fd ff ff       	call   13f2 <write>
        while(*s != 0){
    16ba:	0f b6 06             	movzbl (%esi),%eax
    16bd:	83 c4 10             	add    $0x10,%esp
    16c0:	84 c0                	test   %al,%al
    16c2:	75 e4                	jne    16a8 <printf+0x148>
    16c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    16c7:	31 ff                	xor    %edi,%edi
    16c9:	e9 da fe ff ff       	jmp    15a8 <printf+0x48>
    16ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    16d0:	83 ec 0c             	sub    $0xc,%esp
    16d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    16d8:	6a 01                	push   $0x1
    16da:	e9 73 ff ff ff       	jmp    1652 <printf+0xf2>
    16df:	90                   	nop
  write(fd, &c, 1);
    16e0:	83 ec 04             	sub    $0x4,%esp
    16e3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    16e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16e9:	6a 01                	push   $0x1
    16eb:	e9 21 ff ff ff       	jmp    1611 <printf+0xb1>
        putc(fd, *ap);
    16f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    16f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    16f6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    16f8:	6a 01                	push   $0x1
        ap++;
    16fa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    16fd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1703:	50                   	push   %eax
    1704:	ff 75 08             	pushl  0x8(%ebp)
    1707:	e8 e6 fc ff ff       	call   13f2 <write>
        ap++;
    170c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    170f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1712:	31 ff                	xor    %edi,%edi
    1714:	e9 8f fe ff ff       	jmp    15a8 <printf+0x48>
          s = "(null)";
    1719:	bb 18 1b 00 00       	mov    $0x1b18,%ebx
        while(*s != 0){
    171e:	b8 28 00 00 00       	mov    $0x28,%eax
    1723:	e9 72 ff ff ff       	jmp    169a <printf+0x13a>
    1728:	66 90                	xchg   %ax,%ax
    172a:	66 90                	xchg   %ax,%ax
    172c:	66 90                	xchg   %ax,%ax
    172e:	66 90                	xchg   %ax,%ax

00001730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1731:	a1 98 23 00 00       	mov    0x2398,%eax
{
    1736:	89 e5                	mov    %esp,%ebp
    1738:	57                   	push   %edi
    1739:	56                   	push   %esi
    173a:	53                   	push   %ebx
    173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    173e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1748:	39 c8                	cmp    %ecx,%eax
    174a:	8b 10                	mov    (%eax),%edx
    174c:	73 32                	jae    1780 <free+0x50>
    174e:	39 d1                	cmp    %edx,%ecx
    1750:	72 04                	jb     1756 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1752:	39 d0                	cmp    %edx,%eax
    1754:	72 32                	jb     1788 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1756:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1759:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    175c:	39 fa                	cmp    %edi,%edx
    175e:	74 30                	je     1790 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1760:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1763:	8b 50 04             	mov    0x4(%eax),%edx
    1766:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1769:	39 f1                	cmp    %esi,%ecx
    176b:	74 3a                	je     17a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    176d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    176f:	a3 98 23 00 00       	mov    %eax,0x2398
}
    1774:	5b                   	pop    %ebx
    1775:	5e                   	pop    %esi
    1776:	5f                   	pop    %edi
    1777:	5d                   	pop    %ebp
    1778:	c3                   	ret    
    1779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1780:	39 d0                	cmp    %edx,%eax
    1782:	72 04                	jb     1788 <free+0x58>
    1784:	39 d1                	cmp    %edx,%ecx
    1786:	72 ce                	jb     1756 <free+0x26>
{
    1788:	89 d0                	mov    %edx,%eax
    178a:	eb bc                	jmp    1748 <free+0x18>
    178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1790:	03 72 04             	add    0x4(%edx),%esi
    1793:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1796:	8b 10                	mov    (%eax),%edx
    1798:	8b 12                	mov    (%edx),%edx
    179a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    179d:	8b 50 04             	mov    0x4(%eax),%edx
    17a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    17a3:	39 f1                	cmp    %esi,%ecx
    17a5:	75 c6                	jne    176d <free+0x3d>
    p->s.size += bp->s.size;
    17a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    17aa:	a3 98 23 00 00       	mov    %eax,0x2398
    p->s.size += bp->s.size;
    17af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    17b5:	89 10                	mov    %edx,(%eax)
}
    17b7:	5b                   	pop    %ebx
    17b8:	5e                   	pop    %esi
    17b9:	5f                   	pop    %edi
    17ba:	5d                   	pop    %ebp
    17bb:	c3                   	ret    
    17bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000017c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17c0:	55                   	push   %ebp
    17c1:	89 e5                	mov    %esp,%ebp
    17c3:	57                   	push   %edi
    17c4:	56                   	push   %esi
    17c5:	53                   	push   %ebx
    17c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    17cc:	8b 15 98 23 00 00    	mov    0x2398,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17d2:	8d 78 07             	lea    0x7(%eax),%edi
    17d5:	c1 ef 03             	shr    $0x3,%edi
    17d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    17db:	85 d2                	test   %edx,%edx
    17dd:	0f 84 9d 00 00 00    	je     1880 <malloc+0xc0>
    17e3:	8b 02                	mov    (%edx),%eax
    17e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    17e8:	39 cf                	cmp    %ecx,%edi
    17ea:	76 6c                	jbe    1858 <malloc+0x98>
    17ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    17f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
    17f7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    17fa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    1801:	eb 0e                	jmp    1811 <malloc+0x51>
    1803:	90                   	nop
    1804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1808:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    180a:	8b 48 04             	mov    0x4(%eax),%ecx
    180d:	39 f9                	cmp    %edi,%ecx
    180f:	73 47                	jae    1858 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1811:	39 05 98 23 00 00    	cmp    %eax,0x2398
    1817:	89 c2                	mov    %eax,%edx
    1819:	75 ed                	jne    1808 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    181b:	83 ec 0c             	sub    $0xc,%esp
    181e:	56                   	push   %esi
    181f:	e8 36 fc ff ff       	call   145a <sbrk>
  if(p == (char*)-1)
    1824:	83 c4 10             	add    $0x10,%esp
    1827:	83 f8 ff             	cmp    $0xffffffff,%eax
    182a:	74 1c                	je     1848 <malloc+0x88>
  hp->s.size = nu;
    182c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    182f:	83 ec 0c             	sub    $0xc,%esp
    1832:	83 c0 08             	add    $0x8,%eax
    1835:	50                   	push   %eax
    1836:	e8 f5 fe ff ff       	call   1730 <free>
  return freep;
    183b:	8b 15 98 23 00 00    	mov    0x2398,%edx
      if((p = morecore(nunits)) == 0)
    1841:	83 c4 10             	add    $0x10,%esp
    1844:	85 d2                	test   %edx,%edx
    1846:	75 c0                	jne    1808 <malloc+0x48>
        return 0;
  }
}
    1848:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    184b:	31 c0                	xor    %eax,%eax
}
    184d:	5b                   	pop    %ebx
    184e:	5e                   	pop    %esi
    184f:	5f                   	pop    %edi
    1850:	5d                   	pop    %ebp
    1851:	c3                   	ret    
    1852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1858:	39 cf                	cmp    %ecx,%edi
    185a:	74 54                	je     18b0 <malloc+0xf0>
        p->s.size -= nunits;
    185c:	29 f9                	sub    %edi,%ecx
    185e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1861:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1864:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1867:	89 15 98 23 00 00    	mov    %edx,0x2398
}
    186d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1870:	83 c0 08             	add    $0x8,%eax
}
    1873:	5b                   	pop    %ebx
    1874:	5e                   	pop    %esi
    1875:	5f                   	pop    %edi
    1876:	5d                   	pop    %ebp
    1877:	c3                   	ret    
    1878:	90                   	nop
    1879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1880:	c7 05 98 23 00 00 9c 	movl   $0x239c,0x2398
    1887:	23 00 00 
    188a:	c7 05 9c 23 00 00 9c 	movl   $0x239c,0x239c
    1891:	23 00 00 
    base.s.size = 0;
    1894:	b8 9c 23 00 00       	mov    $0x239c,%eax
    1899:	c7 05 a0 23 00 00 00 	movl   $0x0,0x23a0
    18a0:	00 00 00 
    18a3:	e9 44 ff ff ff       	jmp    17ec <malloc+0x2c>
    18a8:	90                   	nop
    18a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    18b0:	8b 08                	mov    (%eax),%ecx
    18b2:	89 0a                	mov    %ecx,(%edx)
    18b4:	eb b1                	jmp    1867 <malloc+0xa7>
