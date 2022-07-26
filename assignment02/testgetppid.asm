
_testgetppid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp

  int pid, ppid;
  pid = getpid();
  13:	e8 0a 03 00 00       	call   322 <getpid>
  18:	89 c6                	mov    %eax,%esi
  ppid = getppid();
  1a:	e8 2b 03 00 00       	call   34a <getppid>

  printf(1, "getpid  : %d\n", pid);
  1f:	83 ec 04             	sub    $0x4,%esp
  ppid = getppid();
  22:	89 c3                	mov    %eax,%ebx
  printf(1, "getpid  : %d\n", pid);
  24:	56                   	push   %esi
  25:	68 88 07 00 00       	push   $0x788
  2a:	6a 01                	push   $0x1
  2c:	e8 ff 03 00 00       	call   430 <printf>
  printf(1, "getppid : %d\n", ppid);
  31:	83 c4 0c             	add    $0xc,%esp
  34:	53                   	push   %ebx
  35:	68 96 07 00 00       	push   $0x796
  3a:	6a 01                	push   $0x1
  3c:	e8 ef 03 00 00       	call   430 <printf>

  exit();
  41:	e8 5c 02 00 00       	call   2a2 <exit>
  46:	66 90                	xchg   %ax,%ax
  48:	66 90                	xchg   %ax,%ax
  4a:	66 90                	xchg   %ax,%ax
  4c:	66 90                	xchg   %ax,%ax
  4e:	66 90                	xchg   %ax,%ax

00000050 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	89 c2                	mov    %eax,%edx
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  60:	83 c1 01             	add    $0x1,%ecx
  63:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  67:	83 c2 01             	add    $0x1,%edx
  6a:	84 db                	test   %bl,%bl
  6c:	88 5a ff             	mov    %bl,-0x1(%edx)
  6f:	75 ef                	jne    60 <strcpy+0x10>
    ;
  return os;
}
  71:	5b                   	pop    %ebx
  72:	5d                   	pop    %ebp
  73:	c3                   	ret    
  74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	8b 55 08             	mov    0x8(%ebp),%edx
  87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  8a:	0f b6 02             	movzbl (%edx),%eax
  8d:	0f b6 19             	movzbl (%ecx),%ebx
  90:	84 c0                	test   %al,%al
  92:	75 1c                	jne    b0 <strcmp+0x30>
  94:	eb 2a                	jmp    c0 <strcmp+0x40>
  96:	8d 76 00             	lea    0x0(%esi),%esi
  99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  a0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  a6:	83 c1 01             	add    $0x1,%ecx
  a9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  ac:	84 c0                	test   %al,%al
  ae:	74 10                	je     c0 <strcmp+0x40>
  b0:	38 d8                	cmp    %bl,%al
  b2:	74 ec                	je     a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  b4:	29 d8                	sub    %ebx,%eax
}
  b6:	5b                   	pop    %ebx
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    
  b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  c2:	29 d8                	sub    %ebx,%eax
}
  c4:	5b                   	pop    %ebx
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	89 f6                	mov    %esi,%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000d0 <strlen>:

uint
strlen(const char *s)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d6:	80 39 00             	cmpb   $0x0,(%ecx)
  d9:	74 15                	je     f0 <strlen+0x20>
  db:	31 d2                	xor    %edx,%edx
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	83 c2 01             	add    $0x1,%edx
  e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  e7:	89 d0                	mov    %edx,%eax
  e9:	75 f5                	jne    e0 <strlen+0x10>
    ;
  return n;
}
  eb:	5d                   	pop    %ebp
  ec:	c3                   	ret    
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  f0:	31 c0                	xor    %eax,%eax
}
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    
  f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 d7                	mov    %edx,%edi
 10f:	fc                   	cld    
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	89 d0                	mov    %edx,%eax
 114:	5f                   	pop    %edi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    
 117:	89 f6                	mov    %esi,%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	84 d2                	test   %dl,%dl
 12f:	74 1d                	je     14e <strchr+0x2e>
    if(*s == c)
 131:	38 d3                	cmp    %dl,%bl
 133:	89 d9                	mov    %ebx,%ecx
 135:	75 0d                	jne    144 <strchr+0x24>
 137:	eb 17                	jmp    150 <strchr+0x30>
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 140:	38 ca                	cmp    %cl,%dl
 142:	74 0c                	je     150 <strchr+0x30>
  for(; *s; s++)
 144:	83 c0 01             	add    $0x1,%eax
 147:	0f b6 10             	movzbl (%eax),%edx
 14a:	84 d2                	test   %dl,%dl
 14c:	75 f2                	jne    140 <strchr+0x20>
      return (char*)s;
  return 0;
 14e:	31 c0                	xor    %eax,%eax
}
 150:	5b                   	pop    %ebx
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    
 153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 166:	31 f6                	xor    %esi,%esi
 168:	89 f3                	mov    %esi,%ebx
{
 16a:	83 ec 1c             	sub    $0x1c,%esp
 16d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 170:	eb 2f                	jmp    1a1 <gets+0x41>
 172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 178:	8d 45 e7             	lea    -0x19(%ebp),%eax
 17b:	83 ec 04             	sub    $0x4,%esp
 17e:	6a 01                	push   $0x1
 180:	50                   	push   %eax
 181:	6a 00                	push   $0x0
 183:	e8 32 01 00 00       	call   2ba <read>
    if(cc < 1)
 188:	83 c4 10             	add    $0x10,%esp
 18b:	85 c0                	test   %eax,%eax
 18d:	7e 1c                	jle    1ab <gets+0x4b>
      break;
    buf[i++] = c;
 18f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 193:	83 c7 01             	add    $0x1,%edi
 196:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 199:	3c 0a                	cmp    $0xa,%al
 19b:	74 23                	je     1c0 <gets+0x60>
 19d:	3c 0d                	cmp    $0xd,%al
 19f:	74 1f                	je     1c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1a1:	83 c3 01             	add    $0x1,%ebx
 1a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1a7:	89 fe                	mov    %edi,%esi
 1a9:	7c cd                	jl     178 <gets+0x18>
 1ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1b6:	5b                   	pop    %ebx
 1b7:	5e                   	pop    %esi
 1b8:	5f                   	pop    %edi
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    
 1bb:	90                   	nop
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c0:	8b 75 08             	mov    0x8(%ebp),%esi
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	01 de                	add    %ebx,%esi
 1c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 1cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d0:	5b                   	pop    %ebx
 1d1:	5e                   	pop    %esi
 1d2:	5f                   	pop    %edi
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
 1d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	56                   	push   %esi
 1e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	6a 00                	push   $0x0
 1ea:	ff 75 08             	pushl  0x8(%ebp)
 1ed:	e8 f0 00 00 00       	call   2e2 <open>
  if(fd < 0)
 1f2:	83 c4 10             	add    $0x10,%esp
 1f5:	85 c0                	test   %eax,%eax
 1f7:	78 27                	js     220 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1f9:	83 ec 08             	sub    $0x8,%esp
 1fc:	ff 75 0c             	pushl  0xc(%ebp)
 1ff:	89 c3                	mov    %eax,%ebx
 201:	50                   	push   %eax
 202:	e8 f3 00 00 00       	call   2fa <fstat>
  close(fd);
 207:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 20a:	89 c6                	mov    %eax,%esi
  close(fd);
 20c:	e8 b9 00 00 00       	call   2ca <close>
  return r;
 211:	83 c4 10             	add    $0x10,%esp
}
 214:	8d 65 f8             	lea    -0x8(%ebp),%esp
 217:	89 f0                	mov    %esi,%eax
 219:	5b                   	pop    %ebx
 21a:	5e                   	pop    %esi
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret    
 21d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 220:	be ff ff ff ff       	mov    $0xffffffff,%esi
 225:	eb ed                	jmp    214 <stat+0x34>
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <atoi>:

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	0f be 11             	movsbl (%ecx),%edx
 23a:	8d 42 d0             	lea    -0x30(%edx),%eax
 23d:	3c 09                	cmp    $0x9,%al
  n = 0;
 23f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 244:	77 1f                	ja     265 <atoi+0x35>
 246:	8d 76 00             	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 250:	8d 04 80             	lea    (%eax,%eax,4),%eax
 253:	83 c1 01             	add    $0x1,%ecx
 256:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 25a:	0f be 11             	movsbl (%ecx),%edx
 25d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 260:	80 fb 09             	cmp    $0x9,%bl
 263:	76 eb                	jbe    250 <atoi+0x20>
  return n;
}
 265:	5b                   	pop    %ebx
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
 275:	8b 5d 10             	mov    0x10(%ebp),%ebx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 14                	jle    296 <memmove+0x26>
 282:	31 d2                	xor    %edx,%edx
 284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 288:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 28c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 28f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 292:	39 d3                	cmp    %edx,%ebx
 294:	75 f2                	jne    288 <memmove+0x18>
  return vdst;
}
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    

0000029a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29a:	b8 01 00 00 00       	mov    $0x1,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exit>:
SYSCALL(exit)
 2a2:	b8 02 00 00 00       	mov    $0x2,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <wait>:
SYSCALL(wait)
 2aa:	b8 03 00 00 00       	mov    $0x3,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <pipe>:
SYSCALL(pipe)
 2b2:	b8 04 00 00 00       	mov    $0x4,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <read>:
SYSCALL(read)
 2ba:	b8 05 00 00 00       	mov    $0x5,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <write>:
SYSCALL(write)
 2c2:	b8 10 00 00 00       	mov    $0x10,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <close>:
SYSCALL(close)
 2ca:	b8 15 00 00 00       	mov    $0x15,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <kill>:
SYSCALL(kill)
 2d2:	b8 06 00 00 00       	mov    $0x6,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <exec>:
SYSCALL(exec)
 2da:	b8 07 00 00 00       	mov    $0x7,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <open>:
SYSCALL(open)
 2e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <mknod>:
SYSCALL(mknod)
 2ea:	b8 11 00 00 00       	mov    $0x11,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <unlink>:
SYSCALL(unlink)
 2f2:	b8 12 00 00 00       	mov    $0x12,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <fstat>:
SYSCALL(fstat)
 2fa:	b8 08 00 00 00       	mov    $0x8,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <link>:
SYSCALL(link)
 302:	b8 13 00 00 00       	mov    $0x13,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mkdir>:
SYSCALL(mkdir)
 30a:	b8 14 00 00 00       	mov    $0x14,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <chdir>:
SYSCALL(chdir)
 312:	b8 09 00 00 00       	mov    $0x9,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <dup>:
SYSCALL(dup)
 31a:	b8 0a 00 00 00       	mov    $0xa,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <getpid>:
SYSCALL(getpid)
 322:	b8 0b 00 00 00       	mov    $0xb,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sbrk>:
SYSCALL(sbrk)
 32a:	b8 0c 00 00 00       	mov    $0xc,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sleep>:
SYSCALL(sleep)
 332:	b8 0d 00 00 00       	mov    $0xd,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <uptime>:
SYSCALL(uptime)
 33a:	b8 0e 00 00 00       	mov    $0xe,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <my_syscall>:
SYSCALL(my_syscall)
 342:	b8 16 00 00 00       	mov    $0x16,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <getppid>:
SYSCALL(getppid)
 34a:	b8 17 00 00 00       	mov    $0x17,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <yield>:
SYSCALL(yield)
 352:	b8 18 00 00 00       	mov    $0x18,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <set_cpu_share>:
SYSCALL(set_cpu_share)
 35a:	b8 19 00 00 00       	mov    $0x19,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getlev>:
SYSCALL(getlev)
 362:	b8 1a 00 00 00       	mov    $0x1a,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <thread_create>:
SYSCALL(thread_create)
 36a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <thread_exit>:
SYSCALL(thread_exit)
 372:	b8 1c 00 00 00       	mov    $0x1c,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <thread_join>:
SYSCALL(thread_join)
 37a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    
 382:	66 90                	xchg   %ax,%ax
 384:	66 90                	xchg   %ax,%ax
 386:	66 90                	xchg   %ax,%ax
 388:	66 90                	xchg   %ax,%ax
 38a:	66 90                	xchg   %ax,%ax
 38c:	66 90                	xchg   %ax,%ax
 38e:	66 90                	xchg   %ax,%ax

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 399:	85 d2                	test   %edx,%edx
{
 39b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 39e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3a0:	79 76                	jns    418 <printint+0x88>
 3a2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3a6:	74 70                	je     418 <printint+0x88>
    x = -xx;
 3a8:	f7 d8                	neg    %eax
    neg = 1;
 3aa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b1:	31 f6                	xor    %esi,%esi
 3b3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3b6:	eb 0a                	jmp    3c2 <printint+0x32>
 3b8:	90                   	nop
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 3c0:	89 fe                	mov    %edi,%esi
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	8d 7e 01             	lea    0x1(%esi),%edi
 3c7:	f7 f1                	div    %ecx
 3c9:	0f b6 92 ac 07 00 00 	movzbl 0x7ac(%edx),%edx
  }while((x /= base) != 0);
 3d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3d2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3d5:	75 e9                	jne    3c0 <printint+0x30>
  if(neg)
 3d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3da:	85 c0                	test   %eax,%eax
 3dc:	74 08                	je     3e6 <printint+0x56>
    buf[i++] = '-';
 3de:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3e3:	8d 7e 02             	lea    0x2(%esi),%edi
 3e6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 3ea:	8b 7d c0             	mov    -0x40(%ebp),%edi
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
 3f0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	83 ee 01             	sub    $0x1,%esi
 3f9:	6a 01                	push   $0x1
 3fb:	53                   	push   %ebx
 3fc:	57                   	push   %edi
 3fd:	88 45 d7             	mov    %al,-0x29(%ebp)
 400:	e8 bd fe ff ff       	call   2c2 <write>

  while(--i >= 0)
 405:	83 c4 10             	add    $0x10,%esp
 408:	39 de                	cmp    %ebx,%esi
 40a:	75 e4                	jne    3f0 <printint+0x60>
    putc(fd, buf[i]);
}
 40c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 418:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 41f:	eb 90                	jmp    3b1 <printint+0x21>
 421:	eb 0d                	jmp    430 <printf>
 423:	90                   	nop
 424:	90                   	nop
 425:	90                   	nop
 426:	90                   	nop
 427:	90                   	nop
 428:	90                   	nop
 429:	90                   	nop
 42a:	90                   	nop
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	90                   	nop
 42e:	90                   	nop
 42f:	90                   	nop

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 75 0c             	mov    0xc(%ebp),%esi
 43c:	0f b6 1e             	movzbl (%esi),%ebx
 43f:	84 db                	test   %bl,%bl
 441:	0f 84 b3 00 00 00    	je     4fa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 447:	8d 45 10             	lea    0x10(%ebp),%eax
 44a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 44d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 44f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 452:	eb 2f                	jmp    483 <printf+0x53>
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 458:	83 f8 25             	cmp    $0x25,%eax
 45b:	0f 84 a7 00 00 00    	je     508 <printf+0xd8>
  write(fd, &c, 1);
 461:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 464:	83 ec 04             	sub    $0x4,%esp
 467:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 46a:	6a 01                	push   $0x1
 46c:	50                   	push   %eax
 46d:	ff 75 08             	pushl  0x8(%ebp)
 470:	e8 4d fe ff ff       	call   2c2 <write>
 475:	83 c4 10             	add    $0x10,%esp
 478:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 47b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 47f:	84 db                	test   %bl,%bl
 481:	74 77                	je     4fa <printf+0xca>
    if(state == 0){
 483:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 485:	0f be cb             	movsbl %bl,%ecx
 488:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 48b:	74 cb                	je     458 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48d:	83 ff 25             	cmp    $0x25,%edi
 490:	75 e6                	jne    478 <printf+0x48>
      if(c == 'd'){
 492:	83 f8 64             	cmp    $0x64,%eax
 495:	0f 84 05 01 00 00    	je     5a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 49b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4a1:	83 f9 70             	cmp    $0x70,%ecx
 4a4:	74 72                	je     518 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a6:	83 f8 73             	cmp    $0x73,%eax
 4a9:	0f 84 99 00 00 00    	je     548 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4af:	83 f8 63             	cmp    $0x63,%eax
 4b2:	0f 84 08 01 00 00    	je     5c0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	0f 84 ef 00 00 00    	je     5b0 <printf+0x180>
  write(fd, &c, 1);
 4c1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c4:	83 ec 04             	sub    $0x4,%esp
 4c7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4cb:	6a 01                	push   $0x1
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 ec fd ff ff       	call   2c2 <write>
 4d6:	83 c4 0c             	add    $0xc,%esp
 4d9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4dc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4df:	6a 01                	push   $0x1
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 4ea:	e8 d3 fd ff ff       	call   2c2 <write>
  for(i = 0; fmt[i]; i++){
 4ef:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 4f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4f6:	84 db                	test   %bl,%bl
 4f8:	75 89                	jne    483 <printf+0x53>
    }
  }
}
 4fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fd:	5b                   	pop    %ebx
 4fe:	5e                   	pop    %esi
 4ff:	5f                   	pop    %edi
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    
 502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 508:	bf 25 00 00 00       	mov    $0x25,%edi
 50d:	e9 66 ff ff ff       	jmp    478 <printf+0x48>
 512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 518:	83 ec 0c             	sub    $0xc,%esp
 51b:	b9 10 00 00 00       	mov    $0x10,%ecx
 520:	6a 00                	push   $0x0
 522:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	8b 17                	mov    (%edi),%edx
 52a:	e8 61 fe ff ff       	call   390 <printint>
        ap++;
 52f:	89 f8                	mov    %edi,%eax
 531:	83 c4 10             	add    $0x10,%esp
      state = 0;
 534:	31 ff                	xor    %edi,%edi
        ap++;
 536:	83 c0 04             	add    $0x4,%eax
 539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53c:	e9 37 ff ff ff       	jmp    478 <printf+0x48>
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 548:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 54b:	8b 08                	mov    (%eax),%ecx
        ap++;
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 553:	85 c9                	test   %ecx,%ecx
 555:	0f 84 8e 00 00 00    	je     5e9 <printf+0x1b9>
        while(*s != 0){
 55b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 55e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 560:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 562:	84 c0                	test   %al,%al
 564:	0f 84 0e ff ff ff    	je     478 <printf+0x48>
 56a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 56d:	89 de                	mov    %ebx,%esi
 56f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 572:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 575:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 578:	83 ec 04             	sub    $0x4,%esp
          s++;
 57b:	83 c6 01             	add    $0x1,%esi
 57e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 581:	6a 01                	push   $0x1
 583:	57                   	push   %edi
 584:	53                   	push   %ebx
 585:	e8 38 fd ff ff       	call   2c2 <write>
        while(*s != 0){
 58a:	0f b6 06             	movzbl (%esi),%eax
 58d:	83 c4 10             	add    $0x10,%esp
 590:	84 c0                	test   %al,%al
 592:	75 e4                	jne    578 <printf+0x148>
 594:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 597:	31 ff                	xor    %edi,%edi
 599:	e9 da fe ff ff       	jmp    478 <printf+0x48>
 59e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a8:	6a 01                	push   $0x1
 5aa:	e9 73 ff ff ff       	jmp    522 <printf+0xf2>
 5af:	90                   	nop
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	e9 21 ff ff ff       	jmp    4e1 <printf+0xb1>
        putc(fd, *ap);
 5c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 5c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5c6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 5c8:	6a 01                	push   $0x1
        ap++;
 5ca:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 5cd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5d3:	50                   	push   %eax
 5d4:	ff 75 08             	pushl  0x8(%ebp)
 5d7:	e8 e6 fc ff ff       	call   2c2 <write>
        ap++;
 5dc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5df:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e2:	31 ff                	xor    %edi,%edi
 5e4:	e9 8f fe ff ff       	jmp    478 <printf+0x48>
          s = "(null)";
 5e9:	bb a4 07 00 00       	mov    $0x7a4,%ebx
        while(*s != 0){
 5ee:	b8 28 00 00 00       	mov    $0x28,%eax
 5f3:	e9 72 ff ff ff       	jmp    56a <printf+0x13a>
 5f8:	66 90                	xchg   %ax,%ax
 5fa:	66 90                	xchg   %ax,%ax
 5fc:	66 90                	xchg   %ax,%ax
 5fe:	66 90                	xchg   %ax,%ax

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 58 0a 00 00       	mov    0xa58,%eax
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 618:	39 c8                	cmp    %ecx,%eax
 61a:	8b 10                	mov    (%eax),%edx
 61c:	73 32                	jae    650 <free+0x50>
 61e:	39 d1                	cmp    %edx,%ecx
 620:	72 04                	jb     626 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 622:	39 d0                	cmp    %edx,%eax
 624:	72 32                	jb     658 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 626:	8b 73 fc             	mov    -0x4(%ebx),%esi
 629:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62c:	39 fa                	cmp    %edi,%edx
 62e:	74 30                	je     660 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 630:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 633:	8b 50 04             	mov    0x4(%eax),%edx
 636:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 639:	39 f1                	cmp    %esi,%ecx
 63b:	74 3a                	je     677 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 63d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 63f:	a3 58 0a 00 00       	mov    %eax,0xa58
}
 644:	5b                   	pop    %ebx
 645:	5e                   	pop    %esi
 646:	5f                   	pop    %edi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret    
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 d0                	cmp    %edx,%eax
 652:	72 04                	jb     658 <free+0x58>
 654:	39 d1                	cmp    %edx,%ecx
 656:	72 ce                	jb     626 <free+0x26>
{
 658:	89 d0                	mov    %edx,%eax
 65a:	eb bc                	jmp    618 <free+0x18>
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 660:	03 72 04             	add    0x4(%edx),%esi
 663:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 12                	mov    (%edx),%edx
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 f1                	cmp    %esi,%ecx
 675:	75 c6                	jne    63d <free+0x3d>
    p->s.size += bp->s.size;
 677:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 67a:	a3 58 0a 00 00       	mov    %eax,0xa58
    p->s.size += bp->s.size;
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 682:	8b 53 f8             	mov    -0x8(%ebx),%edx
 685:	89 10                	mov    %edx,(%eax)
}
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 58 0a 00 00    	mov    0xa58,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 78 07             	lea    0x7(%eax),%edi
 6a5:	c1 ef 03             	shr    $0x3,%edi
 6a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6ab:	85 d2                	test   %edx,%edx
 6ad:	0f 84 9d 00 00 00    	je     750 <malloc+0xc0>
 6b3:	8b 02                	mov    (%edx),%eax
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6b8:	39 cf                	cmp    %ecx,%edi
 6ba:	76 6c                	jbe    728 <malloc+0x98>
 6bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6d1:	eb 0e                	jmp    6e1 <malloc+0x51>
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 f9                	cmp    %edi,%ecx
 6df:	73 47                	jae    728 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	39 05 58 0a 00 00    	cmp    %eax,0xa58
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	75 ed                	jne    6d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	56                   	push   %esi
 6ef:	e8 36 fc ff ff       	call   32a <sbrk>
  if(p == (char*)-1)
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fa:	74 1c                	je     718 <malloc+0x88>
  hp->s.size = nu;
 6fc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ff:	83 ec 0c             	sub    $0xc,%esp
 702:	83 c0 08             	add    $0x8,%eax
 705:	50                   	push   %eax
 706:	e8 f5 fe ff ff       	call   600 <free>
  return freep;
 70b:	8b 15 58 0a 00 00    	mov    0xa58,%edx
      if((p = morecore(nunits)) == 0)
 711:	83 c4 10             	add    $0x10,%esp
 714:	85 d2                	test   %edx,%edx
 716:	75 c0                	jne    6d8 <malloc+0x48>
        return 0;
  }
}
 718:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 71b:	31 c0                	xor    %eax,%eax
}
 71d:	5b                   	pop    %ebx
 71e:	5e                   	pop    %esi
 71f:	5f                   	pop    %edi
 720:	5d                   	pop    %ebp
 721:	c3                   	ret    
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 728:	39 cf                	cmp    %ecx,%edi
 72a:	74 54                	je     780 <malloc+0xf0>
        p->s.size -= nunits;
 72c:	29 f9                	sub    %edi,%ecx
 72e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 731:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 734:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 737:	89 15 58 0a 00 00    	mov    %edx,0xa58
}
 73d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 740:	83 c0 08             	add    $0x8,%eax
}
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	90                   	nop
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 750:	c7 05 58 0a 00 00 5c 	movl   $0xa5c,0xa58
 757:	0a 00 00 
 75a:	c7 05 5c 0a 00 00 5c 	movl   $0xa5c,0xa5c
 761:	0a 00 00 
    base.s.size = 0;
 764:	b8 5c 0a 00 00       	mov    $0xa5c,%eax
 769:	c7 05 60 0a 00 00 00 	movl   $0x0,0xa60
 770:	00 00 00 
 773:	e9 44 ff ff ff       	jmp    6bc <malloc+0x2c>
 778:	90                   	nop
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb b1                	jmp    737 <malloc+0xa7>
