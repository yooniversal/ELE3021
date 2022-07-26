
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 10 d8 10 80       	mov    $0x8010d810,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 30 10 80       	mov    $0x80103020,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 d8 10 80       	mov    $0x8010d854,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 91 10 80       	push   $0x801091c0
80100051:	68 20 d8 10 80       	push   $0x8010d820
80100056:	e8 45 4c 00 00       	call   80104ca0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 6c 1f 11 80 1c 	movl   $0x80111f1c,0x80111f6c
80100062:	1f 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 70 1f 11 80 1c 	movl   $0x80111f1c,0x80111f70
8010006c:	1f 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 1c 1f 11 80       	mov    $0x80111f1c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 1f 11 80 	movl   $0x80111f1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 91 10 80       	push   $0x801091c7
80100097:	50                   	push   %eax
80100098:	e8 d3 4a 00 00       	call   80104b70 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 1f 11 80       	mov    0x80111f70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 70 1f 11 80    	mov    %ebx,0x80111f70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 1c 1f 11 80       	cmp    $0x80111f1c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 d8 10 80       	push   $0x8010d820
801000e4:	e8 f7 4c 00 00       	call   80104de0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 1f 11 80    	mov    0x80111f70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 1f 11 80    	cmp    $0x80111f1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 1f 11 80    	cmp    $0x80111f1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 1f 11 80    	mov    0x80111f6c,%ebx
80100126:	81 fb 1c 1f 11 80    	cmp    $0x80111f1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 1f 11 80    	cmp    $0x80111f1c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 d8 10 80       	push   $0x8010d820
80100162:	e8 39 4d 00 00       	call   80104ea0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 4a 00 00       	call   80104bb0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

//  cprintf("bread function start\n");
  b = bget(dev, blockno);
//  cprintf("[bread] pass bget()\n");
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
//	cprintf("[bread] if. befo iderw(b)\n");
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 1d 21 00 00       	call   801022a0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 91 10 80       	push   $0x801091ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 9d 4a 00 00       	call   80104c50 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 d7 20 00 00       	jmp    801022a0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 91 10 80       	push   $0x801091df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 5c 4a 00 00       	call   80104c50 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 4a 00 00       	call   80104c10 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 20 d8 10 80 	movl   $0x8010d820,(%esp)
8010020b:	e8 d0 4b 00 00       	call   80104de0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 70 1f 11 80       	mov    0x80111f70,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 1c 1f 11 80 	movl   $0x80111f1c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 70 1f 11 80       	mov    0x80111f70,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 70 1f 11 80    	mov    %ebx,0x80111f70
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 20 d8 10 80 	movl   $0x8010d820,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 3f 4c 00 00       	jmp    80104ea0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 91 10 80       	push   $0x801091e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 5b 16 00 00       	call   801018e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010028c:	e8 4f 4b 00 00       	call   80104de0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 00 22 11 80    	mov    0x80112200,%edx
801002a7:	39 15 04 22 11 80    	cmp    %edx,0x80112204
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 40 c6 10 80       	push   $0x8010c640
801002c0:	68 00 22 11 80       	push   $0x80112200
801002c5:	e8 f6 3e 00 00       	call   801041c0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 00 22 11 80    	mov    0x80112200,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 04 22 11 80    	cmp    0x80112204,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 36 00 00       	call   801039a0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 40 c6 10 80       	push   $0x8010c640
801002ef:	e8 ac 4b 00 00       	call   80104ea0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 04 15 00 00       	call   80101800 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 00 22 11 80       	mov    %eax,0x80112200
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 80 21 11 80 	movsbl -0x7feede80(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 40 c6 10 80       	push   $0x8010c640
8010034d:	e8 4e 4b 00 00       	call   80104ea0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 a6 14 00 00       	call   80101800 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 00 22 11 80    	mov    %edx,0x80112200
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 74 c6 10 80 00 	movl   $0x0,0x8010c674
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 02 25 00 00       	call   801028b0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 91 10 80       	push   $0x801091ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 ff 9b 10 80 	movl   $0x80109bff,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 e3 48 00 00       	call   80104cc0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 92 10 80       	push   $0x80109201
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 78 c6 10 80    	mov    0x8010c678,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 a1 66 00 00       	call   80106ae0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ef 65 00 00       	call   80106ae0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 e3 65 00 00       	call   80106ae0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 d7 65 00 00       	call   80106ae0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 4a 00 00       	call   80104fc0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 49 00 00       	call   80104f10 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 92 10 80       	push   $0x80109205
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 92 10 80 	movzbl -0x7fef6dd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 cc 12 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010061b:	e8 c0 47 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 40 c6 10 80       	push   $0x8010c640
80100647:	e8 54 48 00 00       	call   80104ea0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 ab 11 00 00       	call   80101800 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 74 c6 10 80       	mov    0x8010c674,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 40 c6 10 80       	push   $0x8010c640
8010071f:	e8 7c 47 00 00       	call   80104ea0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 92 10 80       	mov    $0x80109218,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 40 c6 10 80       	push   $0x8010c640
801007f0:	e8 eb 45 00 00       	call   80104de0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 92 10 80       	push   $0x8010921f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 40 c6 10 80       	push   $0x8010c640
80100823:	e8 b8 45 00 00       	call   80104de0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 08 22 11 80       	mov    0x80112208,%eax
80100856:	3b 05 04 22 11 80    	cmp    0x80112204,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 08 22 11 80       	mov    %eax,0x80112208
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 40 c6 10 80       	push   $0x8010c640
80100888:	e8 13 46 00 00       	call   80104ea0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 08 22 11 80       	mov    0x80112208,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 00 22 11 80    	sub    0x80112200,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 08 22 11 80    	mov    %edx,0x80112208
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 80 21 11 80    	mov    %cl,-0x7feede80(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 00 22 11 80       	mov    0x80112200,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 08 22 11 80    	cmp    %eax,0x80112208
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 04 22 11 80       	mov    %eax,0x80112204
          wakeup(&input.r);
80100911:	68 00 22 11 80       	push   $0x80112200
80100916:	e8 d5 3a 00 00       	call   801043f0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 08 22 11 80       	mov    0x80112208,%eax
8010093d:	39 05 04 22 11 80    	cmp    %eax,0x80112204
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 08 22 11 80       	mov    %eax,0x80112208
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 08 22 11 80       	mov    0x80112208,%eax
80100964:	3b 05 04 22 11 80    	cmp    0x80112204,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 80 21 11 80 0a 	cmpb   $0xa,-0x7feede80(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 44 3c 00 00       	jmp    801045e0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 80 21 11 80 0a 	movb   $0xa,-0x7feede80(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 08 22 11 80       	mov    0x80112208,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 92 10 80       	push   $0x80109228
801009cb:	68 40 c6 10 80       	push   $0x8010c640
801009d0:	e8 cb 42 00 00       	call   80104ca0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 cc 2b 11 80 00 	movl   $0x80100600,0x80112bcc
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 c8 2b 11 80 70 	movl   $0x80100270,0x80112bc8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 74 c6 10 80 01 	movl   $0x1,0x8010c674
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 52 1a 00 00       	call   80102450 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:

extern struct PTABLE ptable;

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 7f 2f 00 00       	call   801039a0 <myproc>
80100a21:	89 c7                	mov    %eax,%edi
  struct proc *p;

  begin_op();
80100a23:	e8 f8 22 00 00       	call   80102d20 <begin_op>

  if((ip = namei(path)) == 0){
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 2d 16 00 00       	call   80102060 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 ab 01 00 00    	je     80100be9 <exec+0x1d9>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	89 c3                	mov    %eax,%ebx
80100a43:	50                   	push   %eax
80100a44:	e8 b7 0d 00 00       	call   80101800 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a49:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a4f:	6a 34                	push   $0x34
80100a51:	6a 00                	push   $0x0
80100a53:	50                   	push   %eax
80100a54:	53                   	push   %ebx
80100a55:	e8 86 10 00 00       	call   80101ae0 <readi>
80100a5a:	83 c4 20             	add    $0x20,%esp
80100a5d:	83 f8 34             	cmp    $0x34,%eax
80100a60:	74 1e                	je     80100a80 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a62:	83 ec 0c             	sub    $0xc,%esp
80100a65:	53                   	push   %ebx
80100a66:	e8 25 10 00 00       	call   80101a90 <iunlockput>
    end_op();
80100a6b:	e8 20 23 00 00       	call   80102d90 <end_op>
80100a70:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7b:	5b                   	pop    %ebx
80100a7c:	5e                   	pop    %esi
80100a7d:	5f                   	pop    %edi
80100a7e:	5d                   	pop    %ebp
80100a7f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a80:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a87:	45 4c 46 
80100a8a:	75 d6                	jne    80100a62 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100a8c:	e8 9f 71 00 00       	call   80107c30 <setupkvm>
80100a91:	85 c0                	test   %eax,%eax
80100a93:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a99:	74 c7                	je     80100a62 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a9b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100aa1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  sz = 0;
80100aa7:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa9:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ab0:	00 
80100ab1:	0f 84 a8 03 00 00    	je     80100e5f <exec+0x44f>
80100ab7:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100abd:	31 f6                	xor    %esi,%esi
80100abf:	89 c7                	mov    %eax,%edi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100af6:	e8 55 6f 00 00       	call   80107a50 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b28:	e8 63 6e 00 00       	call   80107990 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 83 0f 00 00       	call   80101ae0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b72:	e8 39 70 00 00       	call   80107bb0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e3 fe ff ff       	jmp    80100a62 <exec+0x52>
80100b7f:	89 f8                	mov    %edi,%eax
80100b81:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b87:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100b91:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  iunlockput(ip);
80100b97:	83 ec 0c             	sub    $0xc,%esp
80100b9a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba0:	53                   	push   %ebx
80100ba1:	e8 ea 0e 00 00       	call   80101a90 <iunlockput>
  end_op();
80100ba6:	e8 e5 21 00 00       	call   80102d90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bab:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bb1:	83 c4 0c             	add    $0xc,%esp
80100bb4:	56                   	push   %esi
80100bb5:	50                   	push   %eax
80100bb6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bbc:	e8 8f 6e 00 00       	call   80107a50 <allocuvm>
80100bc1:	83 c4 10             	add    $0x10,%esp
80100bc4:	85 c0                	test   %eax,%eax
80100bc6:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100bcc:	75 3a                	jne    80100c08 <exec+0x1f8>
    freevm(pgdir);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd7:	e8 d4 6f 00 00       	call   80107bb0 <freevm>
80100bdc:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be4:	e9 8f fe ff ff       	jmp    80100a78 <exec+0x68>
    end_op();
80100be9:	e8 a2 21 00 00       	call   80102d90 <end_op>
    cprintf("exec: fail\n");
80100bee:	83 ec 0c             	sub    $0xc,%esp
80100bf1:	68 41 92 10 80       	push   $0x80109241
80100bf6:	e8 65 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bfb:	83 c4 10             	add    $0x10,%esp
80100bfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c03:	e9 70 fe ff ff       	jmp    80100a78 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c08:	89 c3                	mov    %eax,%ebx
80100c0a:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c10:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c13:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c15:	50                   	push   %eax
80100c16:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c1c:	e8 af 70 00 00       	call   80107cd0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c21:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c24:	83 c4 10             	add    $0x10,%esp
80100c27:	8b 00                	mov    (%eax),%eax
80100c29:	85 c0                	test   %eax,%eax
80100c2b:	0f 84 91 02 00 00    	je     80100ec2 <exec+0x4b2>
80100c31:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c37:	89 f7                	mov    %esi,%edi
80100c39:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c3f:	eb 0c                	jmp    80100c4d <exec+0x23d>
80100c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c48:	83 ff 20             	cmp    $0x20,%edi
80100c4b:	74 81                	je     80100bce <exec+0x1be>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4d:	83 ec 0c             	sub    $0xc,%esp
80100c50:	50                   	push   %eax
80100c51:	e8 da 44 00 00       	call   80105130 <strlen>
80100c56:	f7 d0                	not    %eax
80100c58:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c5a:	58                   	pop    %eax
80100c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c5e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c61:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c64:	e8 c7 44 00 00       	call   80105130 <strlen>
80100c69:	83 c0 01             	add    $0x1,%eax
80100c6c:	50                   	push   %eax
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c73:	53                   	push   %ebx
80100c74:	56                   	push   %esi
80100c75:	e8 b6 71 00 00       	call   80107e30 <copyout>
80100c7a:	83 c4 20             	add    $0x20,%esp
80100c7d:	85 c0                	test   %eax,%eax
80100c7f:	0f 88 49 ff ff ff    	js     80100bce <exec+0x1be>
  for(argc = 0; argv[argc]; argc++) {
80100c85:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c88:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8f:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c92:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c98:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c9b:	85 c0                	test   %eax,%eax
80100c9d:	75 a9                	jne    80100c48 <exec+0x238>
80100c9f:	89 fe                	mov    %edi,%esi
80100ca1:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca7:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100cae:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cb0:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100cb7:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100cbb:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cc2:	ff ff ff 
  ustack[1] = argc;
80100cc5:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ccb:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100ccd:	83 c0 0c             	add    $0xc,%eax
80100cd0:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cd2:	50                   	push   %eax
80100cd3:	52                   	push   %edx
80100cd4:	53                   	push   %ebx
80100cd5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cdb:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100ce1:	89 9d e8 fe ff ff    	mov    %ebx,-0x118(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ce7:	e8 44 71 00 00       	call   80107e30 <copyout>
80100cec:	83 c4 10             	add    $0x10,%esp
80100cef:	85 c0                	test   %eax,%eax
80100cf1:	0f 88 d7 fe ff ff    	js     80100bce <exec+0x1be>
  for(last=s=path; *s; s++)
80100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cfa:	0f b6 00             	movzbl (%eax),%eax
80100cfd:	84 c0                	test   %al,%al
80100cff:	74 17                	je     80100d18 <exec+0x308>
80100d01:	8b 55 08             	mov    0x8(%ebp),%edx
80100d04:	89 d1                	mov    %edx,%ecx
80100d06:	83 c1 01             	add    $0x1,%ecx
80100d09:	3c 2f                	cmp    $0x2f,%al
80100d0b:	0f b6 01             	movzbl (%ecx),%eax
80100d0e:	0f 44 d1             	cmove  %ecx,%edx
80100d11:	84 c0                	test   %al,%al
80100d13:	75 f1                	jne    80100d06 <exec+0x2f6>
80100d15:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d18:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d1b:	51                   	push   %ecx
80100d1c:	6a 10                	push   $0x10
80100d1e:	ff 75 08             	pushl  0x8(%ebp)
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++) {
80100d21:	be b4 6d 11 80       	mov    $0x80116db4,%esi
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d26:	50                   	push   %eax
80100d27:	e8 c4 43 00 00       	call   801050f0 <safestrcpy>
  acquire(&ptable.lock);
80100d2c:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80100d33:	e8 a8 40 00 00       	call   80104de0 <acquire>
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++) {
80100d38:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
  acquire(&ptable.lock);
80100d3e:	83 c4 10             	add    $0x10,%esp
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++) {
80100d41:	89 f7                	mov    %esi,%edi
80100d43:	eb 15                	jmp    80100d5a <exec+0x34a>
80100d45:	8d 76 00             	lea    0x0(%esi),%esi
80100d48:	81 c7 c4 00 00 00    	add    $0xc4,%edi
80100d4e:	81 ff b4 9e 11 80    	cmp    $0x80119eb4,%edi
80100d54:	0f 83 0f 01 00 00    	jae    80100e69 <exec+0x459>
	if(!p || p->is_thread == 0 || p->pid != curproc->pid)
80100d5a:	8b 97 9c 00 00 00    	mov    0x9c(%edi),%edx
80100d60:	85 d2                	test   %edx,%edx
80100d62:	74 e4                	je     80100d48 <exec+0x338>
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d6a:	8b 40 10             	mov    0x10(%eax),%eax
80100d6d:	39 47 10             	cmp    %eax,0x10(%edi)
80100d70:	75 d6                	jne    80100d48 <exec+0x338>
	release(&ptable.lock);
80100d72:	83 ec 0c             	sub    $0xc,%esp
80100d75:	8d 5f 28             	lea    0x28(%edi),%ebx
80100d78:	8d 77 68             	lea    0x68(%edi),%esi
80100d7b:	68 80 6d 11 80       	push   $0x80116d80
80100d80:	e8 1b 41 00 00       	call   80104ea0 <release>
80100d85:	83 c4 10             	add    $0x10,%esp
80100d88:	90                   	nop
80100d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if(p->ofile[fd]) {
80100d90:	8b 03                	mov    (%ebx),%eax
80100d92:	85 c0                	test   %eax,%eax
80100d94:	74 12                	je     80100da8 <exec+0x398>
			fileclose(p->ofile[fd]);
80100d96:	83 ec 0c             	sub    $0xc,%esp
80100d99:	50                   	push   %eax
80100d9a:	e8 21 02 00 00       	call   80100fc0 <fileclose>
			p->ofile[fd] = 0;
80100d9f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	83 c3 04             	add    $0x4,%ebx
	for(fd=0; fd<NOFILE; ++fd)
80100dab:	39 de                	cmp    %ebx,%esi
80100dad:	75 e1                	jne    80100d90 <exec+0x380>
	begin_op();
80100daf:	e8 6c 1f 00 00       	call   80102d20 <begin_op>
	iput(p->cwd);
80100db4:	83 ec 0c             	sub    $0xc,%esp
80100db7:	ff 77 68             	pushl  0x68(%edi)
80100dba:	e8 71 0b 00 00       	call   80101930 <iput>
	end_op();
80100dbf:	e8 cc 1f 00 00       	call   80102d90 <end_op>
	p->cwd = 0;
80100dc4:	c7 47 68 00 00 00 00 	movl   $0x0,0x68(%edi)
	acquire(&ptable.lock);
80100dcb:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80100dd2:	e8 09 40 00 00       	call   80104de0 <acquire>
	deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);
80100dd7:	8b 87 b4 00 00 00    	mov    0xb4(%edi),%eax
80100ddd:	83 c4 0c             	add    $0xc,%esp
80100de0:	50                   	push   %eax
80100de1:	05 00 20 00 00       	add    $0x2000,%eax
80100de6:	50                   	push   %eax
80100de7:	ff 77 04             	pushl  0x4(%edi)
80100dea:	e8 91 6d 00 00       	call   80107b80 <deallocuvm>
	kfree(p->kstack);
80100def:	58                   	pop    %eax
80100df0:	ff 77 08             	pushl  0x8(%edi)
80100df3:	e8 98 16 00 00       	call   80102490 <kfree>
	p->kstack = 0;
80100df8:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
	p->sz = 0;
80100dff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	p->ret_val = 0;
80100e05:	83 c4 10             	add    $0x10,%esp
	p->state = UNUSED;
80100e08:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
	p->pid = 0;
80100e0f:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
	p->parent = 0;
80100e16:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
	p->killed = 0;
80100e1d:	c7 47 24 00 00 00 00 	movl   $0x0,0x24(%edi)
	p->name[0] = 0;
80100e24:	c6 47 6c 00          	movb   $0x0,0x6c(%edi)
	p->tid = 0;
80100e28:	c7 87 a0 00 00 00 00 	movl   $0x0,0xa0(%edi)
80100e2f:	00 00 00 
	p->master = 0;
80100e32:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80100e39:	00 00 00 
	p->stack = 0;
80100e3c:	c7 87 b4 00 00 00 00 	movl   $0x0,0xb4(%edi)
80100e43:	00 00 00 
	p->stack_id = 0;
80100e46:	c7 87 b8 00 00 00 00 	movl   $0x0,0xb8(%edi)
80100e4d:	00 00 00 
	p->ret_val = 0;
80100e50:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
80100e57:	00 00 00 
80100e5a:	e9 e9 fe ff ff       	jmp    80100d48 <exec+0x338>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e5f:	be 00 20 00 00       	mov    $0x2000,%esi
80100e64:	e9 2e fd ff ff       	jmp    80100b97 <exec+0x187>
  release(&ptable.lock);
80100e69:	83 ec 0c             	sub    $0xc,%esp
80100e6c:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e72:	68 80 6d 11 80       	push   $0x80116d80
80100e77:	e8 24 40 00 00       	call   80104ea0 <release>
  curproc->pgdir = pgdir;
80100e7c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e82:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100e85:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100e88:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100e8e:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100e90:	8b 47 18             	mov    0x18(%edi),%eax
80100e93:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e99:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e9c:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80100ea2:	8b 47 18             	mov    0x18(%edi),%eax
80100ea5:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100ea8:	89 3c 24             	mov    %edi,(%esp)
80100eab:	e8 50 69 00 00       	call   80107800 <switchuvm>
  freevm(oldpgdir);
80100eb0:	89 1c 24             	mov    %ebx,(%esp)
80100eb3:	e8 f8 6c 00 00       	call   80107bb0 <freevm>
  return 0;
80100eb8:	83 c4 10             	add    $0x10,%esp
80100ebb:	31 c0                	xor    %eax,%eax
80100ebd:	e9 b6 fb ff ff       	jmp    80100a78 <exec+0x68>
  for(argc = 0; argv[argc]; argc++) {
80100ec2:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100ec8:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100ece:	e9 d4 fd ff ff       	jmp    80100ca7 <exec+0x297>
80100ed3:	66 90                	xchg   %ax,%ax
80100ed5:	66 90                	xchg   %ax,%ax
80100ed7:	66 90                	xchg   %ax,%ax
80100ed9:	66 90                	xchg   %ax,%ax
80100edb:	66 90                	xchg   %ax,%ax
80100edd:	66 90                	xchg   %ax,%ax
80100edf:	90                   	nop

80100ee0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ee6:	68 4d 92 10 80       	push   $0x8010924d
80100eeb:	68 20 22 11 80       	push   $0x80112220
80100ef0:	e8 ab 3d 00 00       	call   80104ca0 <initlock>
}
80100ef5:	83 c4 10             	add    $0x10,%esp
80100ef8:	c9                   	leave  
80100ef9:	c3                   	ret    
80100efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f04:	bb 54 22 11 80       	mov    $0x80112254,%ebx
{
80100f09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f0c:	68 20 22 11 80       	push   $0x80112220
80100f11:	e8 ca 3e 00 00       	call   80104de0 <acquire>
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	eb 10                	jmp    80100f2b <filealloc+0x2b>
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f20:	83 c3 18             	add    $0x18,%ebx
80100f23:	81 fb b4 2b 11 80    	cmp    $0x80112bb4,%ebx
80100f29:	73 25                	jae    80100f50 <filealloc+0x50>
    if(f->ref == 0){
80100f2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f2e:	85 c0                	test   %eax,%eax
80100f30:	75 ee                	jne    80100f20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f3c:	68 20 22 11 80       	push   $0x80112220
80100f41:	e8 5a 3f 00 00       	call   80104ea0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f46:	89 d8                	mov    %ebx,%eax
      return f;
80100f48:	83 c4 10             	add    $0x10,%esp
}
80100f4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f4e:	c9                   	leave  
80100f4f:	c3                   	ret    
  release(&ftable.lock);
80100f50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f55:	68 20 22 11 80       	push   $0x80112220
80100f5a:	e8 41 3f 00 00       	call   80104ea0 <release>
}
80100f5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f61:	83 c4 10             	add    $0x10,%esp
}
80100f64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f67:	c9                   	leave  
80100f68:	c3                   	ret    
80100f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	53                   	push   %ebx
80100f74:	83 ec 10             	sub    $0x10,%esp
80100f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f7a:	68 20 22 11 80       	push   $0x80112220
80100f7f:	e8 5c 3e 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
80100f84:	8b 43 04             	mov    0x4(%ebx),%eax
80100f87:	83 c4 10             	add    $0x10,%esp
80100f8a:	85 c0                	test   %eax,%eax
80100f8c:	7e 1a                	jle    80100fa8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f97:	68 20 22 11 80       	push   $0x80112220
80100f9c:	e8 ff 3e 00 00       	call   80104ea0 <release>
  return f;
}
80100fa1:	89 d8                	mov    %ebx,%eax
80100fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fa6:	c9                   	leave  
80100fa7:	c3                   	ret    
    panic("filedup");
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	68 54 92 10 80       	push   $0x80109254
80100fb0:	e8 db f3 ff ff       	call   80100390 <panic>
80100fb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 28             	sub    $0x28,%esp
80100fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100fcc:	68 20 22 11 80       	push   $0x80112220
80100fd1:	e8 0a 3e 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
80100fd6:	8b 43 04             	mov    0x4(%ebx),%eax
80100fd9:	83 c4 10             	add    $0x10,%esp
80100fdc:	85 c0                	test   %eax,%eax
80100fde:	0f 8e 9b 00 00 00    	jle    8010107f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100fe4:	83 e8 01             	sub    $0x1,%eax
80100fe7:	85 c0                	test   %eax,%eax
80100fe9:	89 43 04             	mov    %eax,0x4(%ebx)
80100fec:	74 1a                	je     80101008 <fileclose+0x48>
    release(&ftable.lock);
80100fee:	c7 45 08 20 22 11 80 	movl   $0x80112220,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff8:	5b                   	pop    %ebx
80100ff9:	5e                   	pop    %esi
80100ffa:	5f                   	pop    %edi
80100ffb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ffc:	e9 9f 3e 00 00       	jmp    80104ea0 <release>
80101001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101008:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010100c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010100e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101011:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101014:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010101a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010101d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101020:	68 20 22 11 80       	push   $0x80112220
  ff = *f;
80101025:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101028:	e8 73 3e 00 00       	call   80104ea0 <release>
  if(ff.type == FD_PIPE)
8010102d:	83 c4 10             	add    $0x10,%esp
80101030:	83 ff 01             	cmp    $0x1,%edi
80101033:	74 13                	je     80101048 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101035:	83 ff 02             	cmp    $0x2,%edi
80101038:	74 26                	je     80101060 <fileclose+0xa0>
}
8010103a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010103d:	5b                   	pop    %ebx
8010103e:	5e                   	pop    %esi
8010103f:	5f                   	pop    %edi
80101040:	5d                   	pop    %ebp
80101041:	c3                   	ret    
80101042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101048:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010104c:	83 ec 08             	sub    $0x8,%esp
8010104f:	53                   	push   %ebx
80101050:	56                   	push   %esi
80101051:	e8 7a 24 00 00       	call   801034d0 <pipeclose>
80101056:	83 c4 10             	add    $0x10,%esp
80101059:	eb df                	jmp    8010103a <fileclose+0x7a>
8010105b:	90                   	nop
8010105c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101060:	e8 bb 1c 00 00       	call   80102d20 <begin_op>
    iput(ff.ip);
80101065:	83 ec 0c             	sub    $0xc,%esp
80101068:	ff 75 e0             	pushl  -0x20(%ebp)
8010106b:	e8 c0 08 00 00       	call   80101930 <iput>
    end_op();
80101070:	83 c4 10             	add    $0x10,%esp
}
80101073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101076:	5b                   	pop    %ebx
80101077:	5e                   	pop    %esi
80101078:	5f                   	pop    %edi
80101079:	5d                   	pop    %ebp
    end_op();
8010107a:	e9 11 1d 00 00       	jmp    80102d90 <end_op>
    panic("fileclose");
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	68 5c 92 10 80       	push   $0x8010925c
80101087:	e8 04 f3 ff ff       	call   80100390 <panic>
8010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101090 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	53                   	push   %ebx
80101094:	83 ec 04             	sub    $0x4,%esp
80101097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010109a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010109d:	75 31                	jne    801010d0 <filestat+0x40>
    ilock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 73 10             	pushl  0x10(%ebx)
801010a5:	e8 56 07 00 00       	call   80101800 <ilock>
    stati(f->ip, st);
801010aa:	58                   	pop    %eax
801010ab:	5a                   	pop    %edx
801010ac:	ff 75 0c             	pushl  0xc(%ebp)
801010af:	ff 73 10             	pushl  0x10(%ebx)
801010b2:	e8 f9 09 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
801010b7:	59                   	pop    %ecx
801010b8:	ff 73 10             	pushl  0x10(%ebx)
801010bb:	e8 20 08 00 00       	call   801018e0 <iunlock>
    return 0;
801010c0:	83 c4 10             	add    $0x10,%esp
801010c3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801010c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010c8:	c9                   	leave  
801010c9:	c3                   	ret    
801010ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801010d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010d5:	eb ee                	jmp    801010c5 <filestat+0x35>
801010d7:	89 f6                	mov    %esi,%esi
801010d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801010e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 0c             	sub    $0xc,%esp
801010e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801010ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010f2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010f6:	74 60                	je     80101158 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010f8:	8b 03                	mov    (%ebx),%eax
801010fa:	83 f8 01             	cmp    $0x1,%eax
801010fd:	74 41                	je     80101140 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ff:	83 f8 02             	cmp    $0x2,%eax
80101102:	75 5b                	jne    8010115f <fileread+0x7f>
    ilock(f->ip);
80101104:	83 ec 0c             	sub    $0xc,%esp
80101107:	ff 73 10             	pushl  0x10(%ebx)
8010110a:	e8 f1 06 00 00       	call   80101800 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010110f:	57                   	push   %edi
80101110:	ff 73 14             	pushl  0x14(%ebx)
80101113:	56                   	push   %esi
80101114:	ff 73 10             	pushl  0x10(%ebx)
80101117:	e8 c4 09 00 00       	call   80101ae0 <readi>
8010111c:	83 c4 20             	add    $0x20,%esp
8010111f:	85 c0                	test   %eax,%eax
80101121:	89 c6                	mov    %eax,%esi
80101123:	7e 03                	jle    80101128 <fileread+0x48>
      f->off += r;
80101125:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	ff 73 10             	pushl  0x10(%ebx)
8010112e:	e8 ad 07 00 00       	call   801018e0 <iunlock>
    return r;
80101133:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101139:	89 f0                	mov    %esi,%eax
8010113b:	5b                   	pop    %ebx
8010113c:	5e                   	pop    %esi
8010113d:	5f                   	pop    %edi
8010113e:	5d                   	pop    %ebp
8010113f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101140:	8b 43 0c             	mov    0xc(%ebx),%eax
80101143:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101149:	5b                   	pop    %ebx
8010114a:	5e                   	pop    %esi
8010114b:	5f                   	pop    %edi
8010114c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010114d:	e9 2e 25 00 00       	jmp    80103680 <piperead>
80101152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101158:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010115d:	eb d7                	jmp    80101136 <fileread+0x56>
  panic("fileread");
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	68 66 92 10 80       	push   $0x80109266
80101167:	e8 24 f2 ff ff       	call   80100390 <panic>
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101170 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
80101179:	8b 75 08             	mov    0x8(%ebp),%esi
8010117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010117f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101183:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101186:	8b 45 10             	mov    0x10(%ebp),%eax
80101189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010118c:	0f 84 aa 00 00 00    	je     8010123c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101192:	8b 06                	mov    (%esi),%eax
80101194:	83 f8 01             	cmp    $0x1,%eax
80101197:	0f 84 c3 00 00 00    	je     80101260 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010119d:	83 f8 02             	cmp    $0x2,%eax
801011a0:	0f 85 d9 00 00 00    	jne    8010127f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011a9:	31 ff                	xor    %edi,%edi
    while(i < n){
801011ab:	85 c0                	test   %eax,%eax
801011ad:	7f 34                	jg     801011e3 <filewrite+0x73>
801011af:	e9 9c 00 00 00       	jmp    80101250 <filewrite+0xe0>
801011b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011b8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801011bb:	83 ec 0c             	sub    $0xc,%esp
801011be:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801011c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011c4:	e8 17 07 00 00       	call   801018e0 <iunlock>
      end_op();
801011c9:	e8 c2 1b 00 00       	call   80102d90 <end_op>
801011ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011d1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801011d4:	39 c3                	cmp    %eax,%ebx
801011d6:	0f 85 96 00 00 00    	jne    80101272 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801011dc:	01 df                	add    %ebx,%edi
    while(i < n){
801011de:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011e1:	7e 6d                	jle    80101250 <filewrite+0xe0>
      int n1 = n - i;
801011e3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011e6:	b8 00 06 00 00       	mov    $0x600,%eax
801011eb:	29 fb                	sub    %edi,%ebx
801011ed:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801011f3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011f6:	e8 25 1b 00 00       	call   80102d20 <begin_op>
      ilock(f->ip);
801011fb:	83 ec 0c             	sub    $0xc,%esp
801011fe:	ff 76 10             	pushl  0x10(%esi)
80101201:	e8 fa 05 00 00       	call   80101800 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101206:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101209:	53                   	push   %ebx
8010120a:	ff 76 14             	pushl  0x14(%esi)
8010120d:	01 f8                	add    %edi,%eax
8010120f:	50                   	push   %eax
80101210:	ff 76 10             	pushl  0x10(%esi)
80101213:	e8 c8 09 00 00       	call   80101be0 <writei>
80101218:	83 c4 20             	add    $0x20,%esp
8010121b:	85 c0                	test   %eax,%eax
8010121d:	7f 99                	jg     801011b8 <filewrite+0x48>
      iunlock(f->ip);
8010121f:	83 ec 0c             	sub    $0xc,%esp
80101222:	ff 76 10             	pushl  0x10(%esi)
80101225:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101228:	e8 b3 06 00 00       	call   801018e0 <iunlock>
      end_op();
8010122d:	e8 5e 1b 00 00       	call   80102d90 <end_op>
      if(r < 0)
80101232:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101235:	83 c4 10             	add    $0x10,%esp
80101238:	85 c0                	test   %eax,%eax
8010123a:	74 98                	je     801011d4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010123c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010123f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101244:	89 f8                	mov    %edi,%eax
80101246:	5b                   	pop    %ebx
80101247:	5e                   	pop    %esi
80101248:	5f                   	pop    %edi
80101249:	5d                   	pop    %ebp
8010124a:	c3                   	ret    
8010124b:	90                   	nop
8010124c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101250:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101253:	75 e7                	jne    8010123c <filewrite+0xcc>
}
80101255:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101258:	89 f8                	mov    %edi,%eax
8010125a:	5b                   	pop    %ebx
8010125b:	5e                   	pop    %esi
8010125c:	5f                   	pop    %edi
8010125d:	5d                   	pop    %ebp
8010125e:	c3                   	ret    
8010125f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101260:	8b 46 0c             	mov    0xc(%esi),%eax
80101263:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101266:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101269:	5b                   	pop    %ebx
8010126a:	5e                   	pop    %esi
8010126b:	5f                   	pop    %edi
8010126c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010126d:	e9 fe 22 00 00       	jmp    80103570 <pipewrite>
        panic("short filewrite");
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	68 6f 92 10 80       	push   $0x8010926f
8010127a:	e8 11 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	68 75 92 10 80       	push   $0x80109275
80101287:	e8 04 f1 ff ff       	call   80100390 <panic>
8010128c:	66 90                	xchg   %ax,%ax
8010128e:	66 90                	xchg   %ax,%ax

80101290 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	56                   	push   %esi
80101294:	53                   	push   %ebx
80101295:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101297:	c1 ea 0c             	shr    $0xc,%edx
8010129a:	03 15 38 2c 11 80    	add    0x80112c38,%edx
801012a0:	83 ec 08             	sub    $0x8,%esp
801012a3:	52                   	push   %edx
801012a4:	50                   	push   %eax
801012a5:	e8 26 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801012aa:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801012ac:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801012af:	ba 01 00 00 00       	mov    $0x1,%edx
801012b4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801012b7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801012bd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801012c0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801012c2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801012c7:	85 d1                	test   %edx,%ecx
801012c9:	74 25                	je     801012f0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801012cb:	f7 d2                	not    %edx
801012cd:	89 c6                	mov    %eax,%esi
  log_write(bp);
801012cf:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801012d2:	21 ca                	and    %ecx,%edx
801012d4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801012d8:	56                   	push   %esi
801012d9:	e8 12 1c 00 00       	call   80102ef0 <log_write>
  brelse(bp);
801012de:	89 34 24             	mov    %esi,(%esp)
801012e1:	e8 fa ee ff ff       	call   801001e0 <brelse>
}
801012e6:	83 c4 10             	add    $0x10,%esp
801012e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012ec:	5b                   	pop    %ebx
801012ed:	5e                   	pop    %esi
801012ee:	5d                   	pop    %ebp
801012ef:	c3                   	ret    
    panic("freeing free block");
801012f0:	83 ec 0c             	sub    $0xc,%esp
801012f3:	68 7f 92 10 80       	push   $0x8010927f
801012f8:	e8 93 f0 ff ff       	call   80100390 <panic>
801012fd:	8d 76 00             	lea    0x0(%esi),%esi

80101300 <balloc>:
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101309:	8b 0d 20 2c 11 80    	mov    0x80112c20,%ecx
{
8010130f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101312:	85 c9                	test   %ecx,%ecx
80101314:	0f 84 87 00 00 00    	je     801013a1 <balloc+0xa1>
8010131a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101321:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	89 f0                	mov    %esi,%eax
80101329:	c1 f8 0c             	sar    $0xc,%eax
8010132c:	03 05 38 2c 11 80    	add    0x80112c38,%eax
80101332:	50                   	push   %eax
80101333:	ff 75 d8             	pushl  -0x28(%ebp)
80101336:	e8 95 ed ff ff       	call   801000d0 <bread>
8010133b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010133e:	a1 20 2c 11 80       	mov    0x80112c20,%eax
80101343:	83 c4 10             	add    $0x10,%esp
80101346:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101349:	31 c0                	xor    %eax,%eax
8010134b:	eb 2f                	jmp    8010137c <balloc+0x7c>
8010134d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101350:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101355:	bb 01 00 00 00       	mov    $0x1,%ebx
8010135a:	83 e1 07             	and    $0x7,%ecx
8010135d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010135f:	89 c1                	mov    %eax,%ecx
80101361:	c1 f9 03             	sar    $0x3,%ecx
80101364:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101369:	85 df                	test   %ebx,%edi
8010136b:	89 fa                	mov    %edi,%edx
8010136d:	74 41                	je     801013b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010136f:	83 c0 01             	add    $0x1,%eax
80101372:	83 c6 01             	add    $0x1,%esi
80101375:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010137a:	74 05                	je     80101381 <balloc+0x81>
8010137c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010137f:	77 cf                	ja     80101350 <balloc+0x50>
    brelse(bp);
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	ff 75 e4             	pushl  -0x1c(%ebp)
80101387:	e8 54 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010138c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101399:	39 05 20 2c 11 80    	cmp    %eax,0x80112c20
8010139f:	77 80                	ja     80101321 <balloc+0x21>
  panic("balloc: out of blocks");
801013a1:	83 ec 0c             	sub    $0xc,%esp
801013a4:	68 92 92 10 80       	push   $0x80109292
801013a9:	e8 e2 ef ff ff       	call   80100390 <panic>
801013ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801013b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801013b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801013b6:	09 da                	or     %ebx,%edx
801013b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 2e 1b 00 00       	call   80102ef0 <log_write>
        brelse(bp);
801013c2:	89 3c 24             	mov    %edi,(%esp)
801013c5:	e8 16 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801013ca:	58                   	pop    %eax
801013cb:	5a                   	pop    %edx
801013cc:	56                   	push   %esi
801013cd:	ff 75 d8             	pushl  -0x28(%ebp)
801013d0:	e8 fb ec ff ff       	call   801000d0 <bread>
801013d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013da:	83 c4 0c             	add    $0xc,%esp
801013dd:	68 00 02 00 00       	push   $0x200
801013e2:	6a 00                	push   $0x0
801013e4:	50                   	push   %eax
801013e5:	e8 26 3b 00 00       	call   80104f10 <memset>
  log_write(bp);
801013ea:	89 1c 24             	mov    %ebx,(%esp)
801013ed:	e8 fe 1a 00 00       	call   80102ef0 <log_write>
  brelse(bp);
801013f2:	89 1c 24             	mov    %ebx,(%esp)
801013f5:	e8 e6 ed ff ff       	call   801001e0 <brelse>
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	89 f0                	mov    %esi,%eax
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5f                   	pop    %edi
80101402:	5d                   	pop    %ebp
80101403:	c3                   	ret    
80101404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010140a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101410 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101418:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010141a:	bb 74 2c 11 80       	mov    $0x80112c74,%ebx
{
8010141f:	83 ec 28             	sub    $0x28,%esp
80101422:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101425:	68 40 2c 11 80       	push   $0x80112c40
8010142a:	e8 b1 39 00 00       	call   80104de0 <acquire>
8010142f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101435:	eb 17                	jmp    8010144e <iget+0x3e>
80101437:	89 f6                	mov    %esi,%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101440:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101446:	81 fb 94 48 11 80    	cmp    $0x80114894,%ebx
8010144c:	73 22                	jae    80101470 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010144e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101451:	85 c9                	test   %ecx,%ecx
80101453:	7e 04                	jle    80101459 <iget+0x49>
80101455:	39 3b                	cmp    %edi,(%ebx)
80101457:	74 4f                	je     801014a8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101459:	85 f6                	test   %esi,%esi
8010145b:	75 e3                	jne    80101440 <iget+0x30>
8010145d:	85 c9                	test   %ecx,%ecx
8010145f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101462:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101468:	81 fb 94 48 11 80    	cmp    $0x80114894,%ebx
8010146e:	72 de                	jb     8010144e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101470:	85 f6                	test   %esi,%esi
80101472:	74 5b                	je     801014cf <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101474:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101477:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101479:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010147c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101483:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010148a:	68 40 2c 11 80       	push   $0x80112c40
8010148f:	e8 0c 3a 00 00       	call   80104ea0 <release>

  return ip;
80101494:	83 c4 10             	add    $0x10,%esp
}
80101497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149a:	89 f0                	mov    %esi,%eax
8010149c:	5b                   	pop    %ebx
8010149d:	5e                   	pop    %esi
8010149e:	5f                   	pop    %edi
8010149f:	5d                   	pop    %ebp
801014a0:	c3                   	ret    
801014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a8:	39 53 04             	cmp    %edx,0x4(%ebx)
801014ab:	75 ac                	jne    80101459 <iget+0x49>
      release(&icache.lock);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801014b0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801014b3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801014b5:	68 40 2c 11 80       	push   $0x80112c40
      ip->ref++;
801014ba:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801014bd:	e8 de 39 00 00       	call   80104ea0 <release>
      return ip;
801014c2:	83 c4 10             	add    $0x10,%esp
}
801014c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c8:	89 f0                	mov    %esi,%eax
801014ca:	5b                   	pop    %ebx
801014cb:	5e                   	pop    %esi
801014cc:	5f                   	pop    %edi
801014cd:	5d                   	pop    %ebp
801014ce:	c3                   	ret    
    panic("iget: no inodes");
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	68 a8 92 10 80       	push   $0x801092a8
801014d7:	e8 b4 ee ff ff       	call   80100390 <panic>
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	89 c6                	mov    %eax,%esi
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	77 18                	ja     80101508 <bmap+0x28>
801014f0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801014f3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014f6:	85 db                	test   %ebx,%ebx
801014f8:	74 76                	je     80101570 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801014fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014fd:	89 d8                	mov    %ebx,%eax
801014ff:	5b                   	pop    %ebx
80101500:	5e                   	pop    %esi
80101501:	5f                   	pop    %edi
80101502:	5d                   	pop    %ebp
80101503:	c3                   	ret    
80101504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101508:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010150b:	83 fb 7f             	cmp    $0x7f,%ebx
8010150e:	0f 87 90 00 00 00    	ja     801015a4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101514:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010151a:	8b 00                	mov    (%eax),%eax
8010151c:	85 d2                	test   %edx,%edx
8010151e:	74 70                	je     80101590 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101520:	83 ec 08             	sub    $0x8,%esp
80101523:	52                   	push   %edx
80101524:	50                   	push   %eax
80101525:	e8 a6 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010152a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010152e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101531:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101533:	8b 1a                	mov    (%edx),%ebx
80101535:	85 db                	test   %ebx,%ebx
80101537:	75 1d                	jne    80101556 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101539:	8b 06                	mov    (%esi),%eax
8010153b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010153e:	e8 bd fd ff ff       	call   80101300 <balloc>
80101543:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101546:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101549:	89 c3                	mov    %eax,%ebx
8010154b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010154d:	57                   	push   %edi
8010154e:	e8 9d 19 00 00       	call   80102ef0 <log_write>
80101553:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	57                   	push   %edi
8010155a:	e8 81 ec ff ff       	call   801001e0 <brelse>
8010155f:	83 c4 10             	add    $0x10,%esp
}
80101562:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101565:	89 d8                	mov    %ebx,%eax
80101567:	5b                   	pop    %ebx
80101568:	5e                   	pop    %esi
80101569:	5f                   	pop    %edi
8010156a:	5d                   	pop    %ebp
8010156b:	c3                   	ret    
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101570:	8b 00                	mov    (%eax),%eax
80101572:	e8 89 fd ff ff       	call   80101300 <balloc>
80101577:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010157a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010157d:	89 c3                	mov    %eax,%ebx
}
8010157f:	89 d8                	mov    %ebx,%eax
80101581:	5b                   	pop    %ebx
80101582:	5e                   	pop    %esi
80101583:	5f                   	pop    %edi
80101584:	5d                   	pop    %ebp
80101585:	c3                   	ret    
80101586:	8d 76 00             	lea    0x0(%esi),%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101590:	e8 6b fd ff ff       	call   80101300 <balloc>
80101595:	89 c2                	mov    %eax,%edx
80101597:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010159d:	8b 06                	mov    (%esi),%eax
8010159f:	e9 7c ff ff ff       	jmp    80101520 <bmap+0x40>
  panic("bmap: out of range");
801015a4:	83 ec 0c             	sub    $0xc,%esp
801015a7:	68 b8 92 10 80       	push   $0x801092b8
801015ac:	e8 df ed ff ff       	call   80100390 <panic>
801015b1:	eb 0d                	jmp    801015c0 <readsb>
801015b3:	90                   	nop
801015b4:	90                   	nop
801015b5:	90                   	nop
801015b6:	90                   	nop
801015b7:	90                   	nop
801015b8:	90                   	nop
801015b9:	90                   	nop
801015ba:	90                   	nop
801015bb:	90                   	nop
801015bc:	90                   	nop
801015bd:	90                   	nop
801015be:	90                   	nop
801015bf:	90                   	nop

801015c0 <readsb>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	6a 01                	push   $0x1
801015cd:	ff 75 08             	pushl  0x8(%ebp)
801015d0:	e8 fb ea ff ff       	call   801000d0 <bread>
801015d5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801015da:	83 c4 0c             	add    $0xc,%esp
801015dd:	6a 1c                	push   $0x1c
801015df:	50                   	push   %eax
801015e0:	56                   	push   %esi
801015e1:	e8 da 39 00 00       	call   80104fc0 <memmove>
  brelse(bp);
801015e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015e9:	83 c4 10             	add    $0x10,%esp
}
801015ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ef:	5b                   	pop    %ebx
801015f0:	5e                   	pop    %esi
801015f1:	5d                   	pop    %ebp
  brelse(bp);
801015f2:	e9 e9 eb ff ff       	jmp    801001e0 <brelse>
801015f7:	89 f6                	mov    %esi,%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101600 <iinit>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	53                   	push   %ebx
80101604:	bb 80 2c 11 80       	mov    $0x80112c80,%ebx
80101609:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010160c:	68 cb 92 10 80       	push   $0x801092cb
80101611:	68 40 2c 11 80       	push   $0x80112c40
80101616:	e8 85 36 00 00       	call   80104ca0 <initlock>
8010161b:	83 c4 10             	add    $0x10,%esp
8010161e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101620:	83 ec 08             	sub    $0x8,%esp
80101623:	68 d2 92 10 80       	push   $0x801092d2
80101628:	53                   	push   %ebx
80101629:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010162f:	e8 3c 35 00 00       	call   80104b70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101634:	83 c4 10             	add    $0x10,%esp
80101637:	81 fb a0 48 11 80    	cmp    $0x801148a0,%ebx
8010163d:	75 e1                	jne    80101620 <iinit+0x20>
  readsb(dev, &sb);
8010163f:	83 ec 08             	sub    $0x8,%esp
80101642:	68 20 2c 11 80       	push   $0x80112c20
80101647:	ff 75 08             	pushl  0x8(%ebp)
8010164a:	e8 71 ff ff ff       	call   801015c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010164f:	ff 35 38 2c 11 80    	pushl  0x80112c38
80101655:	ff 35 34 2c 11 80    	pushl  0x80112c34
8010165b:	ff 35 30 2c 11 80    	pushl  0x80112c30
80101661:	ff 35 2c 2c 11 80    	pushl  0x80112c2c
80101667:	ff 35 28 2c 11 80    	pushl  0x80112c28
8010166d:	ff 35 24 2c 11 80    	pushl  0x80112c24
80101673:	ff 35 20 2c 11 80    	pushl  0x80112c20
80101679:	68 38 93 10 80       	push   $0x80109338
8010167e:	e8 dd ef ff ff       	call   80100660 <cprintf>
}
80101683:	83 c4 30             	add    $0x30,%esp
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ialloc>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	57                   	push   %edi
80101694:	56                   	push   %esi
80101695:	53                   	push   %ebx
80101696:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	83 3d 28 2c 11 80 01 	cmpl   $0x1,0x80112c28
{
801016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016a3:	8b 75 08             	mov    0x8(%ebp),%esi
801016a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016a9:	0f 86 91 00 00 00    	jbe    80101740 <ialloc+0xb0>
801016af:	bb 01 00 00 00       	mov    $0x1,%ebx
801016b4:	eb 21                	jmp    801016d7 <ialloc+0x47>
801016b6:	8d 76 00             	lea    0x0(%esi),%esi
801016b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801016c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016c3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801016c6:	57                   	push   %edi
801016c7:	e8 14 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016cc:	83 c4 10             	add    $0x10,%esp
801016cf:	39 1d 28 2c 11 80    	cmp    %ebx,0x80112c28
801016d5:	76 69                	jbe    80101740 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016d7:	89 d8                	mov    %ebx,%eax
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	c1 e8 03             	shr    $0x3,%eax
801016df:	03 05 34 2c 11 80    	add    0x80112c34,%eax
801016e5:	50                   	push   %eax
801016e6:	56                   	push   %esi
801016e7:	e8 e4 e9 ff ff       	call   801000d0 <bread>
801016ec:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801016ee:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801016f0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801016f3:	83 e0 07             	and    $0x7,%eax
801016f6:	c1 e0 06             	shl    $0x6,%eax
801016f9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101701:	75 bd                	jne    801016c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101703:	83 ec 04             	sub    $0x4,%esp
80101706:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101709:	6a 40                	push   $0x40
8010170b:	6a 00                	push   $0x0
8010170d:	51                   	push   %ecx
8010170e:	e8 fd 37 00 00       	call   80104f10 <memset>
      dip->type = type;
80101713:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101717:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010171a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010171d:	89 3c 24             	mov    %edi,(%esp)
80101720:	e8 cb 17 00 00       	call   80102ef0 <log_write>
      brelse(bp);
80101725:	89 3c 24             	mov    %edi,(%esp)
80101728:	e8 b3 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010172d:	83 c4 10             	add    $0x10,%esp
}
80101730:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101733:	89 da                	mov    %ebx,%edx
80101735:	89 f0                	mov    %esi,%eax
}
80101737:	5b                   	pop    %ebx
80101738:	5e                   	pop    %esi
80101739:	5f                   	pop    %edi
8010173a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010173b:	e9 d0 fc ff ff       	jmp    80101410 <iget>
  panic("ialloc: no inodes");
80101740:	83 ec 0c             	sub    $0xc,%esp
80101743:	68 d8 92 10 80       	push   $0x801092d8
80101748:	e8 43 ec ff ff       	call   80100390 <panic>
8010174d:	8d 76 00             	lea    0x0(%esi),%esi

80101750 <iupdate>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101758:	83 ec 08             	sub    $0x8,%esp
8010175b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101761:	c1 e8 03             	shr    $0x3,%eax
80101764:	03 05 34 2c 11 80    	add    0x80112c34,%eax
8010176a:	50                   	push   %eax
8010176b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010176e:	e8 5d e9 ff ff       	call   801000d0 <bread>
80101773:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101775:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101778:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101789:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010178c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101790:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101793:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101797:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010179b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010179f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ad:	6a 34                	push   $0x34
801017af:	53                   	push   %ebx
801017b0:	50                   	push   %eax
801017b1:	e8 0a 38 00 00       	call   80104fc0 <memmove>
  log_write(bp);
801017b6:	89 34 24             	mov    %esi,(%esp)
801017b9:	e8 32 17 00 00       	call   80102ef0 <log_write>
  brelse(bp);
801017be:	89 75 08             	mov    %esi,0x8(%ebp)
801017c1:	83 c4 10             	add    $0x10,%esp
}
801017c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c7:	5b                   	pop    %ebx
801017c8:	5e                   	pop    %esi
801017c9:	5d                   	pop    %ebp
  brelse(bp);
801017ca:	e9 11 ea ff ff       	jmp    801001e0 <brelse>
801017cf:	90                   	nop

801017d0 <idup>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	53                   	push   %ebx
801017d4:	83 ec 10             	sub    $0x10,%esp
801017d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017da:	68 40 2c 11 80       	push   $0x80112c40
801017df:	e8 fc 35 00 00       	call   80104de0 <acquire>
  ip->ref++;
801017e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017e8:	c7 04 24 40 2c 11 80 	movl   $0x80112c40,(%esp)
801017ef:	e8 ac 36 00 00       	call   80104ea0 <release>
}
801017f4:	89 d8                	mov    %ebx,%eax
801017f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017f9:	c9                   	leave  
801017fa:	c3                   	ret    
801017fb:	90                   	nop
801017fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101800 <ilock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	0f 84 b7 00 00 00    	je     801018c7 <ilock+0xc7>
80101810:	8b 53 08             	mov    0x8(%ebx),%edx
80101813:	85 d2                	test   %edx,%edx
80101815:	0f 8e ac 00 00 00    	jle    801018c7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010181b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010181e:	83 ec 0c             	sub    $0xc,%esp
80101821:	50                   	push   %eax
80101822:	e8 89 33 00 00       	call   80104bb0 <acquiresleep>
  if(ip->valid == 0){
80101827:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010182a:	83 c4 10             	add    $0x10,%esp
8010182d:	85 c0                	test   %eax,%eax
8010182f:	74 0f                	je     80101840 <ilock+0x40>
}
80101831:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101834:	5b                   	pop    %ebx
80101835:	5e                   	pop    %esi
80101836:	5d                   	pop    %ebp
80101837:	c3                   	ret    
80101838:	90                   	nop
80101839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101840:	8b 43 04             	mov    0x4(%ebx),%eax
80101843:	83 ec 08             	sub    $0x8,%esp
80101846:	c1 e8 03             	shr    $0x3,%eax
80101849:	03 05 34 2c 11 80    	add    0x80112c34,%eax
8010184f:	50                   	push   %eax
80101850:	ff 33                	pushl  (%ebx)
80101852:	e8 79 e8 ff ff       	call   801000d0 <bread>
80101857:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101859:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185f:	83 e0 07             	and    $0x7,%eax
80101862:	c1 e0 06             	shl    $0x6,%eax
80101865:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101869:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010186c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010186f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101873:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101877:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010187b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010187f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101883:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101887:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010188b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010188e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101891:	6a 34                	push   $0x34
80101893:	50                   	push   %eax
80101894:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101897:	50                   	push   %eax
80101898:	e8 23 37 00 00       	call   80104fc0 <memmove>
    brelse(bp);
8010189d:	89 34 24             	mov    %esi,(%esp)
801018a0:	e8 3b e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801018a5:	83 c4 10             	add    $0x10,%esp
801018a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018b4:	0f 85 77 ff ff ff    	jne    80101831 <ilock+0x31>
      panic("ilock: no type");
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	68 f0 92 10 80       	push   $0x801092f0
801018c2:	e8 c9 ea ff ff       	call   80100390 <panic>
    panic("ilock");
801018c7:	83 ec 0c             	sub    $0xc,%esp
801018ca:	68 ea 92 10 80       	push   $0x801092ea
801018cf:	e8 bc ea ff ff       	call   80100390 <panic>
801018d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801018e0 <iunlock>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	56                   	push   %esi
801018e4:	53                   	push   %ebx
801018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018e8:	85 db                	test   %ebx,%ebx
801018ea:	74 28                	je     80101914 <iunlock+0x34>
801018ec:	8d 73 0c             	lea    0xc(%ebx),%esi
801018ef:	83 ec 0c             	sub    $0xc,%esp
801018f2:	56                   	push   %esi
801018f3:	e8 58 33 00 00       	call   80104c50 <holdingsleep>
801018f8:	83 c4 10             	add    $0x10,%esp
801018fb:	85 c0                	test   %eax,%eax
801018fd:	74 15                	je     80101914 <iunlock+0x34>
801018ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	7e 0e                	jle    80101914 <iunlock+0x34>
  releasesleep(&ip->lock);
80101906:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101909:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010190f:	e9 fc 32 00 00       	jmp    80104c10 <releasesleep>
    panic("iunlock");
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 ff 92 10 80       	push   $0x801092ff
8010191c:	e8 6f ea ff ff       	call   80100390 <panic>
80101921:	eb 0d                	jmp    80101930 <iput>
80101923:	90                   	nop
80101924:	90                   	nop
80101925:	90                   	nop
80101926:	90                   	nop
80101927:	90                   	nop
80101928:	90                   	nop
80101929:	90                   	nop
8010192a:	90                   	nop
8010192b:	90                   	nop
8010192c:	90                   	nop
8010192d:	90                   	nop
8010192e:	90                   	nop
8010192f:	90                   	nop

80101930 <iput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 28             	sub    $0x28,%esp
80101939:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010193c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010193f:	57                   	push   %edi
80101940:	e8 6b 32 00 00       	call   80104bb0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101945:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101948:	83 c4 10             	add    $0x10,%esp
8010194b:	85 d2                	test   %edx,%edx
8010194d:	74 07                	je     80101956 <iput+0x26>
8010194f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101954:	74 32                	je     80101988 <iput+0x58>
  releasesleep(&ip->lock);
80101956:	83 ec 0c             	sub    $0xc,%esp
80101959:	57                   	push   %edi
8010195a:	e8 b1 32 00 00       	call   80104c10 <releasesleep>
  acquire(&icache.lock);
8010195f:	c7 04 24 40 2c 11 80 	movl   $0x80112c40,(%esp)
80101966:	e8 75 34 00 00       	call   80104de0 <acquire>
  ip->ref--;
8010196b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010196f:	83 c4 10             	add    $0x10,%esp
80101972:	c7 45 08 40 2c 11 80 	movl   $0x80112c40,0x8(%ebp)
}
80101979:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5f                   	pop    %edi
8010197f:	5d                   	pop    %ebp
  release(&icache.lock);
80101980:	e9 1b 35 00 00       	jmp    80104ea0 <release>
80101985:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101988:	83 ec 0c             	sub    $0xc,%esp
8010198b:	68 40 2c 11 80       	push   $0x80112c40
80101990:	e8 4b 34 00 00       	call   80104de0 <acquire>
    int r = ip->ref;
80101995:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101998:	c7 04 24 40 2c 11 80 	movl   $0x80112c40,(%esp)
8010199f:	e8 fc 34 00 00       	call   80104ea0 <release>
    if(r == 1){
801019a4:	83 c4 10             	add    $0x10,%esp
801019a7:	83 fe 01             	cmp    $0x1,%esi
801019aa:	75 aa                	jne    80101956 <iput+0x26>
801019ac:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019b8:	89 cf                	mov    %ecx,%edi
801019ba:	eb 0b                	jmp    801019c7 <iput+0x97>
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019c3:	39 fe                	cmp    %edi,%esi
801019c5:	74 19                	je     801019e0 <iput+0xb0>
    if(ip->addrs[i]){
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 bc f8 ff ff       	call   80101290 <bfree>
      ip->addrs[i] = 0;
801019d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019da:	eb e4                	jmp    801019c0 <iput+0x90>
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019e0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019e9:	85 c0                	test   %eax,%eax
801019eb:	75 33                	jne    80101a20 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019ed:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019f0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019f7:	53                   	push   %ebx
801019f8:	e8 53 fd ff ff       	call   80101750 <iupdate>
      ip->type = 0;
801019fd:	31 c0                	xor    %eax,%eax
801019ff:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a03:	89 1c 24             	mov    %ebx,(%esp)
80101a06:	e8 45 fd ff ff       	call   80101750 <iupdate>
      ip->valid = 0;
80101a0b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	e9 3c ff ff ff       	jmp    80101956 <iput+0x26>
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a20:	83 ec 08             	sub    $0x8,%esp
80101a23:	50                   	push   %eax
80101a24:	ff 33                	pushl  (%ebx)
80101a26:	e8 a5 e6 ff ff       	call   801000d0 <bread>
80101a2b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a31:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a37:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a3a:	83 c4 10             	add    $0x10,%esp
80101a3d:	89 cf                	mov    %ecx,%edi
80101a3f:	eb 0e                	jmp    80101a4f <iput+0x11f>
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a48:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101a4b:	39 fe                	cmp    %edi,%esi
80101a4d:	74 0f                	je     80101a5e <iput+0x12e>
      if(a[j])
80101a4f:	8b 16                	mov    (%esi),%edx
80101a51:	85 d2                	test   %edx,%edx
80101a53:	74 f3                	je     80101a48 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a55:	8b 03                	mov    (%ebx),%eax
80101a57:	e8 34 f8 ff ff       	call   80101290 <bfree>
80101a5c:	eb ea                	jmp    80101a48 <iput+0x118>
    brelse(bp);
80101a5e:	83 ec 0c             	sub    $0xc,%esp
80101a61:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a64:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a67:	e8 74 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a6c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a72:	8b 03                	mov    (%ebx),%eax
80101a74:	e8 17 f8 ff ff       	call   80101290 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a79:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a80:	00 00 00 
80101a83:	83 c4 10             	add    $0x10,%esp
80101a86:	e9 62 ff ff ff       	jmp    801019ed <iput+0xbd>
80101a8b:	90                   	nop
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a90 <iunlockput>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	53                   	push   %ebx
80101a94:	83 ec 10             	sub    $0x10,%esp
80101a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a9a:	53                   	push   %ebx
80101a9b:	e8 40 fe ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101aa0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101aa3:	83 c4 10             	add    $0x10,%esp
}
80101aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101aa9:	c9                   	leave  
  iput(ip);
80101aaa:	e9 81 fe ff ff       	jmp    80101930 <iput>
80101aaf:	90                   	nop

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ab9:	8b 0a                	mov    (%edx),%ecx
80101abb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101abe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ac8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101acf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad3:	8b 52 58             	mov    0x58(%edx),%edx
80101ad6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ad9:	5d                   	pop    %ebp
80101ada:	c3                   	ret    
80101adb:	90                   	nop
80101adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ae0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101af7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101afa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101afd:	8b 75 10             	mov    0x10(%ebp),%esi
80101b00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b03:	0f 84 a7 00 00 00    	je     80101bb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0c:	8b 40 58             	mov    0x58(%eax),%eax
80101b0f:	39 c6                	cmp    %eax,%esi
80101b11:	0f 87 ba 00 00 00    	ja     80101bd1 <readi+0xf1>
80101b17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b1a:	89 f9                	mov    %edi,%ecx
80101b1c:	01 f1                	add    %esi,%ecx
80101b1e:	0f 82 ad 00 00 00    	jb     80101bd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b24:	89 c2                	mov    %eax,%edx
80101b26:	29 f2                	sub    %esi,%edx
80101b28:	39 c8                	cmp    %ecx,%eax
80101b2a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2d:	31 ff                	xor    %edi,%edi
80101b2f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b31:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b34:	74 6c                	je     80101ba2 <readi+0xc2>
80101b36:	8d 76 00             	lea    0x0(%esi),%esi
80101b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b43:	89 f2                	mov    %esi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 d8                	mov    %ebx,%eax
80101b4a:	e8 91 f9 ff ff       	call   801014e0 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 33                	pushl  (%ebx)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b5d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5f:	89 f0                	mov    %esi,%eax
80101b61:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b66:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b6b:	83 c4 0c             	add    $0xc,%esp
80101b6e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b70:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101b74:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	29 fb                	sub    %edi,%ebx
80101b79:	39 d9                	cmp    %ebx,%ecx
80101b7b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b7e:	53                   	push   %ebx
80101b7f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b80:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b82:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b85:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b87:	e8 34 34 00 00       	call   80104fc0 <memmove>
    brelse(bp);
80101b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b8f:	89 14 24             	mov    %edx,(%esp)
80101b92:	e8 49 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ba0:	77 9e                	ja     80101b40 <readi+0x60>
  }
  return n;
80101ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba8:	5b                   	pop    %ebx
80101ba9:	5e                   	pop    %esi
80101baa:	5f                   	pop    %edi
80101bab:	5d                   	pop    %ebp
80101bac:	c3                   	ret    
80101bad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bb4:	66 83 f8 09          	cmp    $0x9,%ax
80101bb8:	77 17                	ja     80101bd1 <readi+0xf1>
80101bba:	8b 04 c5 c0 2b 11 80 	mov    -0x7feed440(,%eax,8),%eax
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	74 0c                	je     80101bd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bcf:	ff e0                	jmp    *%eax
      return -1;
80101bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd6:	eb cd                	jmp    80101ba5 <readi+0xc5>
80101bd8:	90                   	nop
80101bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101be0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bfd:	8b 75 10             	mov    0x10(%ebp),%esi
80101c00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c03:	0f 84 b7 00 00 00    	je     80101cc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c0f:	0f 82 eb 00 00 00    	jb     80101d00 <writei+0x120>
80101c15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c18:	31 d2                	xor    %edx,%edx
80101c1a:	89 f8                	mov    %edi,%eax
80101c1c:	01 f0                	add    %esi,%eax
80101c1e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c21:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c26:	0f 87 d4 00 00 00    	ja     80101d00 <writei+0x120>
80101c2c:	85 d2                	test   %edx,%edx
80101c2e:	0f 85 cc 00 00 00    	jne    80101d00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c34:	85 ff                	test   %edi,%edi
80101c36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c3d:	74 72                	je     80101cb1 <writei+0xd1>
80101c3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c43:	89 f2                	mov    %esi,%edx
80101c45:	c1 ea 09             	shr    $0x9,%edx
80101c48:	89 f8                	mov    %edi,%eax
80101c4a:	e8 91 f8 ff ff       	call   801014e0 <bmap>
80101c4f:	83 ec 08             	sub    $0x8,%esp
80101c52:	50                   	push   %eax
80101c53:	ff 37                	pushl  (%edi)
80101c55:	e8 76 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c5d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c62:	89 f0                	mov    %esi,%eax
80101c64:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c69:	83 c4 0c             	add    $0xc,%esp
80101c6c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c71:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c73:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	39 d9                	cmp    %ebx,%ecx
80101c79:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c7c:	53                   	push   %ebx
80101c7d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c80:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c82:	50                   	push   %eax
80101c83:	e8 38 33 00 00       	call   80104fc0 <memmove>
    log_write(bp);
80101c88:	89 3c 24             	mov    %edi,(%esp)
80101c8b:	e8 60 12 00 00       	call   80102ef0 <log_write>
    brelse(bp);
80101c90:	89 3c 24             	mov    %edi,(%esp)
80101c93:	e8 48 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c98:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c9b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ca7:	77 97                	ja     80101c40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ca9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cac:	3b 70 58             	cmp    0x58(%eax),%esi
80101caf:	77 37                	ja     80101ce8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb7:	5b                   	pop    %ebx
80101cb8:	5e                   	pop    %esi
80101cb9:	5f                   	pop    %edi
80101cba:	5d                   	pop    %ebp
80101cbb:	c3                   	ret    
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cc4:	66 83 f8 09          	cmp    $0x9,%ax
80101cc8:	77 36                	ja     80101d00 <writei+0x120>
80101cca:	8b 04 c5 c4 2b 11 80 	mov    -0x7feed43c(,%eax,8),%eax
80101cd1:	85 c0                	test   %eax,%eax
80101cd3:	74 2b                	je     80101d00 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101cd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cdf:	ff e0                	jmp    *%eax
80101ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101ceb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cf1:	50                   	push   %eax
80101cf2:	e8 59 fa ff ff       	call   80101750 <iupdate>
80101cf7:	83 c4 10             	add    $0x10,%esp
80101cfa:	eb b5                	jmp    80101cb1 <writei+0xd1>
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d05:	eb ad                	jmp    80101cb4 <writei+0xd4>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d16:	6a 0e                	push   $0xe
80101d18:	ff 75 0c             	pushl  0xc(%ebp)
80101d1b:	ff 75 08             	pushl  0x8(%ebp)
80101d1e:	e8 0d 33 00 00       	call   80105030 <strncmp>
}
80101d23:	c9                   	leave  
80101d24:	c3                   	ret    
80101d25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	83 ec 1c             	sub    $0x1c,%esp
80101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d41:	0f 85 85 00 00 00    	jne    80101dcc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d47:	8b 53 58             	mov    0x58(%ebx),%edx
80101d4a:	31 ff                	xor    %edi,%edi
80101d4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d4f:	85 d2                	test   %edx,%edx
80101d51:	74 3e                	je     80101d91 <dirlookup+0x61>
80101d53:	90                   	nop
80101d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d58:	6a 10                	push   $0x10
80101d5a:	57                   	push   %edi
80101d5b:	56                   	push   %esi
80101d5c:	53                   	push   %ebx
80101d5d:	e8 7e fd ff ff       	call   80101ae0 <readi>
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	83 f8 10             	cmp    $0x10,%eax
80101d68:	75 55                	jne    80101dbf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d6f:	74 18                	je     80101d89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d74:	83 ec 04             	sub    $0x4,%esp
80101d77:	6a 0e                	push   $0xe
80101d79:	50                   	push   %eax
80101d7a:	ff 75 0c             	pushl  0xc(%ebp)
80101d7d:	e8 ae 32 00 00       	call   80105030 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	85 c0                	test   %eax,%eax
80101d87:	74 17                	je     80101da0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d89:	83 c7 10             	add    $0x10,%edi
80101d8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d8f:	72 c7                	jb     80101d58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d94:	31 c0                	xor    %eax,%eax
}
80101d96:	5b                   	pop    %ebx
80101d97:	5e                   	pop    %esi
80101d98:	5f                   	pop    %edi
80101d99:	5d                   	pop    %ebp
80101d9a:	c3                   	ret    
80101d9b:	90                   	nop
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101da0:	8b 45 10             	mov    0x10(%ebp),%eax
80101da3:	85 c0                	test   %eax,%eax
80101da5:	74 05                	je     80101dac <dirlookup+0x7c>
        *poff = off;
80101da7:	8b 45 10             	mov    0x10(%ebp),%eax
80101daa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101db0:	8b 03                	mov    (%ebx),%eax
80101db2:	e8 59 f6 ff ff       	call   80101410 <iget>
}
80101db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dba:	5b                   	pop    %ebx
80101dbb:	5e                   	pop    %esi
80101dbc:	5f                   	pop    %edi
80101dbd:	5d                   	pop    %ebp
80101dbe:	c3                   	ret    
      panic("dirlookup read");
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	68 19 93 10 80       	push   $0x80109319
80101dc7:	e8 c4 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	68 07 93 10 80       	push   $0x80109307
80101dd4:	e8 b7 e5 ff ff       	call   80100390 <panic>
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101de0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	89 cf                	mov    %ecx,%edi
80101de8:	89 c3                	mov    %eax,%ebx
80101dea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ded:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101df0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101df3:	0f 84 67 01 00 00    	je     80101f60 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101df9:	e8 a2 1b 00 00       	call   801039a0 <myproc>
  acquire(&icache.lock);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e01:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e04:	68 40 2c 11 80       	push   $0x80112c40
80101e09:	e8 d2 2f 00 00       	call   80104de0 <acquire>
  ip->ref++;
80101e0e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e12:	c7 04 24 40 2c 11 80 	movl   $0x80112c40,(%esp)
80101e19:	e8 82 30 00 00       	call   80104ea0 <release>
80101e1e:	83 c4 10             	add    $0x10,%esp
80101e21:	eb 08                	jmp    80101e2b <namex+0x4b>
80101e23:	90                   	nop
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e2b:	0f b6 03             	movzbl (%ebx),%eax
80101e2e:	3c 2f                	cmp    $0x2f,%al
80101e30:	74 f6                	je     80101e28 <namex+0x48>
  if(*path == 0)
80101e32:	84 c0                	test   %al,%al
80101e34:	0f 84 ee 00 00 00    	je     80101f28 <namex+0x148>
  while(*path != '/' && *path != 0)
80101e3a:	0f b6 03             	movzbl (%ebx),%eax
80101e3d:	3c 2f                	cmp    $0x2f,%al
80101e3f:	0f 84 b3 00 00 00    	je     80101ef8 <namex+0x118>
80101e45:	84 c0                	test   %al,%al
80101e47:	89 da                	mov    %ebx,%edx
80101e49:	75 09                	jne    80101e54 <namex+0x74>
80101e4b:	e9 a8 00 00 00       	jmp    80101ef8 <namex+0x118>
80101e50:	84 c0                	test   %al,%al
80101e52:	74 0a                	je     80101e5e <namex+0x7e>
    path++;
80101e54:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e57:	0f b6 02             	movzbl (%edx),%eax
80101e5a:	3c 2f                	cmp    $0x2f,%al
80101e5c:	75 f2                	jne    80101e50 <namex+0x70>
80101e5e:	89 d1                	mov    %edx,%ecx
80101e60:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101e62:	83 f9 0d             	cmp    $0xd,%ecx
80101e65:	0f 8e 91 00 00 00    	jle    80101efc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101e6b:	83 ec 04             	sub    $0x4,%esp
80101e6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e71:	6a 0e                	push   $0xe
80101e73:	53                   	push   %ebx
80101e74:	57                   	push   %edi
80101e75:	e8 46 31 00 00       	call   80104fc0 <memmove>
    path++;
80101e7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101e7d:	83 c4 10             	add    $0x10,%esp
    path++;
80101e80:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101e82:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e85:	75 11                	jne    80101e98 <namex+0xb8>
80101e87:	89 f6                	mov    %esi,%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101e90:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e96:	74 f8                	je     80101e90 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	56                   	push   %esi
80101e9c:	e8 5f f9 ff ff       	call   80101800 <ilock>
    if(ip->type != T_DIR){
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ea9:	0f 85 91 00 00 00    	jne    80101f40 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eaf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eb2:	85 d2                	test   %edx,%edx
80101eb4:	74 09                	je     80101ebf <namex+0xdf>
80101eb6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101eb9:	0f 84 b7 00 00 00    	je     80101f76 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ebf:	83 ec 04             	sub    $0x4,%esp
80101ec2:	6a 00                	push   $0x0
80101ec4:	57                   	push   %edi
80101ec5:	56                   	push   %esi
80101ec6:	e8 65 fe ff ff       	call   80101d30 <dirlookup>
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	85 c0                	test   %eax,%eax
80101ed0:	74 6e                	je     80101f40 <namex+0x160>
  iunlock(ip);
80101ed2:	83 ec 0c             	sub    $0xc,%esp
80101ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ed8:	56                   	push   %esi
80101ed9:	e8 02 fa ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101ede:	89 34 24             	mov    %esi,(%esp)
80101ee1:	e8 4a fa ff ff       	call   80101930 <iput>
80101ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ee9:	83 c4 10             	add    $0x10,%esp
80101eec:	89 c6                	mov    %eax,%esi
80101eee:	e9 38 ff ff ff       	jmp    80101e2b <namex+0x4b>
80101ef3:	90                   	nop
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101ef8:	89 da                	mov    %ebx,%edx
80101efa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101efc:	83 ec 04             	sub    $0x4,%esp
80101eff:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f02:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f05:	51                   	push   %ecx
80101f06:	53                   	push   %ebx
80101f07:	57                   	push   %edi
80101f08:	e8 b3 30 00 00       	call   80104fc0 <memmove>
    name[len] = 0;
80101f0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f10:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f13:	83 c4 10             	add    $0x10,%esp
80101f16:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f1a:	89 d3                	mov    %edx,%ebx
80101f1c:	e9 61 ff ff ff       	jmp    80101e82 <namex+0xa2>
80101f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f2b:	85 c0                	test   %eax,%eax
80101f2d:	75 5d                	jne    80101f8c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f32:	89 f0                	mov    %esi,%eax
80101f34:	5b                   	pop    %ebx
80101f35:	5e                   	pop    %esi
80101f36:	5f                   	pop    %edi
80101f37:	5d                   	pop    %ebp
80101f38:	c3                   	ret    
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 97 f9 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101f49:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f4c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f4e:	e8 dd f9 ff ff       	call   80101930 <iput>
      return 0;
80101f53:	83 c4 10             	add    $0x10,%esp
}
80101f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f59:	89 f0                	mov    %esi,%eax
80101f5b:	5b                   	pop    %ebx
80101f5c:	5e                   	pop    %esi
80101f5d:	5f                   	pop    %edi
80101f5e:	5d                   	pop    %ebp
80101f5f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101f60:	ba 01 00 00 00       	mov    $0x1,%edx
80101f65:	b8 01 00 00 00       	mov    $0x1,%eax
80101f6a:	e8 a1 f4 ff ff       	call   80101410 <iget>
80101f6f:	89 c6                	mov    %eax,%esi
80101f71:	e9 b5 fe ff ff       	jmp    80101e2b <namex+0x4b>
      iunlock(ip);
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	56                   	push   %esi
80101f7a:	e8 61 f9 ff ff       	call   801018e0 <iunlock>
      return ip;
80101f7f:	83 c4 10             	add    $0x10,%esp
}
80101f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f85:	89 f0                	mov    %esi,%eax
80101f87:	5b                   	pop    %ebx
80101f88:	5e                   	pop    %esi
80101f89:	5f                   	pop    %edi
80101f8a:	5d                   	pop    %ebp
80101f8b:	c3                   	ret    
    iput(ip);
80101f8c:	83 ec 0c             	sub    $0xc,%esp
80101f8f:	56                   	push   %esi
    return 0;
80101f90:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f92:	e8 99 f9 ff ff       	call   80101930 <iput>
    return 0;
80101f97:	83 c4 10             	add    $0x10,%esp
80101f9a:	eb 93                	jmp    80101f2f <namex+0x14f>
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fa0 <dirlink>:
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
80101fa6:	83 ec 20             	sub    $0x20,%esp
80101fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fac:	6a 00                	push   $0x0
80101fae:	ff 75 0c             	pushl  0xc(%ebp)
80101fb1:	53                   	push   %ebx
80101fb2:	e8 79 fd ff ff       	call   80101d30 <dirlookup>
80101fb7:	83 c4 10             	add    $0x10,%esp
80101fba:	85 c0                	test   %eax,%eax
80101fbc:	75 67                	jne    80102025 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fbe:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fc1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fc4:	85 ff                	test   %edi,%edi
80101fc6:	74 29                	je     80101ff1 <dirlink+0x51>
80101fc8:	31 ff                	xor    %edi,%edi
80101fca:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fcd:	eb 09                	jmp    80101fd8 <dirlink+0x38>
80101fcf:	90                   	nop
80101fd0:	83 c7 10             	add    $0x10,%edi
80101fd3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fd6:	73 19                	jae    80101ff1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fd8:	6a 10                	push   $0x10
80101fda:	57                   	push   %edi
80101fdb:	56                   	push   %esi
80101fdc:	53                   	push   %ebx
80101fdd:	e8 fe fa ff ff       	call   80101ae0 <readi>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	83 f8 10             	cmp    $0x10,%eax
80101fe8:	75 4e                	jne    80102038 <dirlink+0x98>
    if(de.inum == 0)
80101fea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fef:	75 df                	jne    80101fd0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ff1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ff4:	83 ec 04             	sub    $0x4,%esp
80101ff7:	6a 0e                	push   $0xe
80101ff9:	ff 75 0c             	pushl  0xc(%ebp)
80101ffc:	50                   	push   %eax
80101ffd:	e8 8e 30 00 00       	call   80105090 <strncpy>
  de.inum = inum;
80102002:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102005:	6a 10                	push   $0x10
80102007:	57                   	push   %edi
80102008:	56                   	push   %esi
80102009:	53                   	push   %ebx
  de.inum = inum;
8010200a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010200e:	e8 cd fb ff ff       	call   80101be0 <writei>
80102013:	83 c4 20             	add    $0x20,%esp
80102016:	83 f8 10             	cmp    $0x10,%eax
80102019:	75 2a                	jne    80102045 <dirlink+0xa5>
  return 0;
8010201b:	31 c0                	xor    %eax,%eax
}
8010201d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102020:	5b                   	pop    %ebx
80102021:	5e                   	pop    %esi
80102022:	5f                   	pop    %edi
80102023:	5d                   	pop    %ebp
80102024:	c3                   	ret    
    iput(ip);
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	50                   	push   %eax
80102029:	e8 02 f9 ff ff       	call   80101930 <iput>
    return -1;
8010202e:	83 c4 10             	add    $0x10,%esp
80102031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102036:	eb e5                	jmp    8010201d <dirlink+0x7d>
      panic("dirlink read");
80102038:	83 ec 0c             	sub    $0xc,%esp
8010203b:	68 28 93 10 80       	push   $0x80109328
80102040:	e8 4b e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	68 de 99 10 80       	push   $0x801099de
8010204d:	e8 3e e3 ff ff       	call   80100390 <panic>
80102052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102060 <namei>:

struct inode*
namei(char *path)
{
80102060:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102061:	31 d2                	xor    %edx,%edx
{
80102063:	89 e5                	mov    %esp,%ebp
80102065:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102068:	8b 45 08             	mov    0x8(%ebp),%eax
8010206b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010206e:	e8 6d fd ff ff       	call   80101de0 <namex>
}
80102073:	c9                   	leave  
80102074:	c3                   	ret    
80102075:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102080 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102080:	55                   	push   %ebp
  return namex(path, 1, name);
80102081:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102086:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010208b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010208e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010208f:	e9 4c fd ff ff       	jmp    80101de0 <namex>
80102094:	66 90                	xchg   %ax,%ax
80102096:	66 90                	xchg   %ax,%ax
80102098:	66 90                	xchg   %ax,%ax
8010209a:	66 90                	xchg   %ax,%ax
8010209c:	66 90                	xchg   %ax,%ax
8010209e:	66 90                	xchg   %ax,%ax

801020a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020a9:	85 c0                	test   %eax,%eax
801020ab:	0f 84 b4 00 00 00    	je     80102165 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020b1:	8b 58 08             	mov    0x8(%eax),%ebx
801020b4:	89 c6                	mov    %eax,%esi
801020b6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801020bc:	0f 87 96 00 00 00    	ja     80102158 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	89 ca                	mov    %ecx,%edx
801020d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d3:	83 e0 c0             	and    $0xffffffc0,%eax
801020d6:	3c 40                	cmp    $0x40,%al
801020d8:	75 f6                	jne    801020d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020da:	31 ff                	xor    %edi,%edi
801020dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020e1:	89 f8                	mov    %edi,%eax
801020e3:	ee                   	out    %al,(%dx)
801020e4:	b8 01 00 00 00       	mov    $0x1,%eax
801020e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ee:	ee                   	out    %al,(%dx)
801020ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020f4:	89 d8                	mov    %ebx,%eax
801020f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020f7:	89 d8                	mov    %ebx,%eax
801020f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020fe:	c1 f8 08             	sar    $0x8,%eax
80102101:	ee                   	out    %al,(%dx)
80102102:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102107:	89 f8                	mov    %edi,%eax
80102109:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010210a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010210e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102113:	c1 e0 04             	shl    $0x4,%eax
80102116:	83 e0 10             	and    $0x10,%eax
80102119:	83 c8 e0             	or     $0xffffffe0,%eax
8010211c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010211d:	f6 06 04             	testb  $0x4,(%esi)
80102120:	75 16                	jne    80102138 <idestart+0x98>
80102122:	b8 20 00 00 00       	mov    $0x20,%eax
80102127:	89 ca                	mov    %ecx,%edx
80102129:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010212a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212d:	5b                   	pop    %ebx
8010212e:	5e                   	pop    %esi
8010212f:	5f                   	pop    %edi
80102130:	5d                   	pop    %ebp
80102131:	c3                   	ret    
80102132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102138:	b8 30 00 00 00       	mov    $0x30,%eax
8010213d:	89 ca                	mov    %ecx,%edx
8010213f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102140:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102145:	83 c6 5c             	add    $0x5c,%esi
80102148:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010214d:	fc                   	cld    
8010214e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102153:	5b                   	pop    %ebx
80102154:	5e                   	pop    %esi
80102155:	5f                   	pop    %edi
80102156:	5d                   	pop    %ebp
80102157:	c3                   	ret    
    panic("incorrect blockno");
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	68 94 93 10 80       	push   $0x80109394
80102160:	e8 2b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 8b 93 10 80       	push   $0x8010938b
8010216d:	e8 1e e2 ff ff       	call   80100390 <panic>
80102172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <ideinit>:
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102186:	68 a6 93 10 80       	push   $0x801093a6
8010218b:	68 a0 c6 10 80       	push   $0x8010c6a0
80102190:	e8 0b 2b 00 00       	call   80104ca0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102195:	58                   	pop    %eax
80102196:	a1 60 4f 11 80       	mov    0x80114f60,%eax
8010219b:	5a                   	pop    %edx
8010219c:	83 e8 01             	sub    $0x1,%eax
8010219f:	50                   	push   %eax
801021a0:	6a 0e                	push   $0xe
801021a2:	e8 a9 02 00 00       	call   80102450 <ioapicenable>
801021a7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021aa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021af:	90                   	nop
801021b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b1:	83 e0 c0             	and    $0xffffffc0,%eax
801021b4:	3c 40                	cmp    $0x40,%al
801021b6:	75 f8                	jne    801021b0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021bd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021c2:	ee                   	out    %al,(%dx)
801021c3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021cd:	eb 06                	jmp    801021d5 <ideinit+0x55>
801021cf:	90                   	nop
  for(i=0; i<1000; i++){
801021d0:	83 e9 01             	sub    $0x1,%ecx
801021d3:	74 0f                	je     801021e4 <ideinit+0x64>
801021d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021d6:	84 c0                	test   %al,%al
801021d8:	74 f6                	je     801021d0 <ideinit+0x50>
      havedisk1 = 1;
801021da:	c7 05 80 c6 10 80 01 	movl   $0x1,0x8010c680
801021e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ee:	ee                   	out    %al,(%dx)
}
801021ef:	c9                   	leave  
801021f0:	c3                   	ret    
801021f1:	eb 0d                	jmp    80102200 <ideintr>
801021f3:	90                   	nop
801021f4:	90                   	nop
801021f5:	90                   	nop
801021f6:	90                   	nop
801021f7:	90                   	nop
801021f8:	90                   	nop
801021f9:	90                   	nop
801021fa:	90                   	nop
801021fb:	90                   	nop
801021fc:	90                   	nop
801021fd:	90                   	nop
801021fe:	90                   	nop
801021ff:	90                   	nop

80102200 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	57                   	push   %edi
80102204:	56                   	push   %esi
80102205:	53                   	push   %ebx
80102206:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102209:	68 a0 c6 10 80       	push   $0x8010c6a0
8010220e:	e8 cd 2b 00 00       	call   80104de0 <acquire>

  if((b = idequeue) == 0){
80102213:	8b 1d 84 c6 10 80    	mov    0x8010c684,%ebx
80102219:	83 c4 10             	add    $0x10,%esp
8010221c:	85 db                	test   %ebx,%ebx
8010221e:	74 67                	je     80102287 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102220:	8b 43 58             	mov    0x58(%ebx),%eax
80102223:	a3 84 c6 10 80       	mov    %eax,0x8010c684

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102228:	8b 3b                	mov    (%ebx),%edi
8010222a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102230:	75 31                	jne    80102263 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102232:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102237:	89 f6                	mov    %esi,%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102240:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102241:	89 c6                	mov    %eax,%esi
80102243:	83 e6 c0             	and    $0xffffffc0,%esi
80102246:	89 f1                	mov    %esi,%ecx
80102248:	80 f9 40             	cmp    $0x40,%cl
8010224b:	75 f3                	jne    80102240 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010224d:	a8 21                	test   $0x21,%al
8010224f:	75 12                	jne    80102263 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102251:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102254:	b9 80 00 00 00       	mov    $0x80,%ecx
80102259:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010225e:	fc                   	cld    
8010225f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102261:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102263:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102266:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102269:	89 f9                	mov    %edi,%ecx
8010226b:	83 c9 02             	or     $0x2,%ecx
8010226e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102270:	53                   	push   %ebx
80102271:	e8 7a 21 00 00       	call   801043f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102276:	a1 84 c6 10 80       	mov    0x8010c684,%eax
8010227b:	83 c4 10             	add    $0x10,%esp
8010227e:	85 c0                	test   %eax,%eax
80102280:	74 05                	je     80102287 <ideintr+0x87>
    idestart(idequeue);
80102282:	e8 19 fe ff ff       	call   801020a0 <idestart>
    release(&idelock);
80102287:	83 ec 0c             	sub    $0xc,%esp
8010228a:	68 a0 c6 10 80       	push   $0x8010c6a0
8010228f:	e8 0c 2c 00 00       	call   80104ea0 <release>

  release(&idelock);
}
80102294:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102297:	5b                   	pop    %ebx
80102298:	5e                   	pop    %esi
80102299:	5f                   	pop    %edi
8010229a:	5d                   	pop    %ebp
8010229b:	c3                   	ret    
8010229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	53                   	push   %ebx
801022a4:	83 ec 10             	sub    $0x10,%esp
801022a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;
 
  if(!holdingsleep(&b->lock))
801022aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ad:	50                   	push   %eax
801022ae:	e8 9d 29 00 00       	call   80104c50 <holdingsleep>
801022b3:	83 c4 10             	add    $0x10,%esp
801022b6:	85 c0                	test   %eax,%eax
801022b8:	0f 84 c6 00 00 00    	je     80102384 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022be:	8b 03                	mov    (%ebx),%eax
801022c0:	83 e0 06             	and    $0x6,%eax
801022c3:	83 f8 02             	cmp    $0x2,%eax
801022c6:	0f 84 ab 00 00 00    	je     80102377 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022cc:	8b 53 04             	mov    0x4(%ebx),%edx
801022cf:	85 d2                	test   %edx,%edx
801022d1:	74 0d                	je     801022e0 <iderw+0x40>
801022d3:	a1 80 c6 10 80       	mov    0x8010c680,%eax
801022d8:	85 c0                	test   %eax,%eax
801022da:	0f 84 b1 00 00 00    	je     80102391 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022e0:	83 ec 0c             	sub    $0xc,%esp
801022e3:	68 a0 c6 10 80       	push   $0x8010c6a0
801022e8:	e8 f3 2a 00 00       	call   80104de0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	8b 15 84 c6 10 80    	mov    0x8010c684,%edx
801022f3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801022f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022fd:	85 d2                	test   %edx,%edx
801022ff:	75 09                	jne    8010230a <iderw+0x6a>
80102301:	eb 6d                	jmp    80102370 <iderw+0xd0>
80102303:	90                   	nop
80102304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102308:	89 c2                	mov    %eax,%edx
8010230a:	8b 42 58             	mov    0x58(%edx),%eax
8010230d:	85 c0                	test   %eax,%eax
8010230f:	75 f7                	jne    80102308 <iderw+0x68>
80102311:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102314:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102316:	39 1d 84 c6 10 80    	cmp    %ebx,0x8010c684
8010231c:	74 42                	je     80102360 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	74 23                	je     8010234b <iderw+0xab>
80102328:	90                   	nop
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102330:	83 ec 08             	sub    $0x8,%esp
80102333:	68 a0 c6 10 80       	push   $0x8010c6a0
80102338:	53                   	push   %ebx
80102339:	e8 82 1e 00 00       	call   801041c0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	83 e0 06             	and    $0x6,%eax
80102346:	83 f8 02             	cmp    $0x2,%eax
80102349:	75 e5                	jne    80102330 <iderw+0x90>
  }

  release(&idelock);
8010234b:	c7 45 08 a0 c6 10 80 	movl   $0x8010c6a0,0x8(%ebp)
}
80102352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102355:	c9                   	leave  
  release(&idelock);
80102356:	e9 45 2b 00 00       	jmp    80104ea0 <release>
8010235b:	90                   	nop
8010235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102360:	89 d8                	mov    %ebx,%eax
80102362:	e8 39 fd ff ff       	call   801020a0 <idestart>
80102367:	eb b5                	jmp    8010231e <iderw+0x7e>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102370:	ba 84 c6 10 80       	mov    $0x8010c684,%edx
80102375:	eb 9d                	jmp    80102314 <iderw+0x74>
    panic("iderw: nothing to do");
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 c0 93 10 80       	push   $0x801093c0
8010237f:	e8 0c e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102384:	83 ec 0c             	sub    $0xc,%esp
80102387:	68 aa 93 10 80       	push   $0x801093aa
8010238c:	e8 ff df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102391:	83 ec 0c             	sub    $0xc,%esp
80102394:	68 d5 93 10 80       	push   $0x801093d5
80102399:	e8 f2 df ff ff       	call   80100390 <panic>
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023a0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023a1:	c7 05 94 48 11 80 00 	movl   $0xfec00000,0x80114894
801023a8:	00 c0 fe 
{
801023ab:	89 e5                	mov    %esp,%ebp
801023ad:	56                   	push   %esi
801023ae:	53                   	push   %ebx
  ioapic->reg = reg;
801023af:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023b6:	00 00 00 
  return ioapic->data;
801023b9:	a1 94 48 11 80       	mov    0x80114894,%eax
801023be:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801023c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801023c7:	8b 0d 94 48 11 80    	mov    0x80114894,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023cd:	0f b6 15 c0 49 11 80 	movzbl 0x801149c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023d4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801023d7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023da:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801023dd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023e0:	39 c2                	cmp    %eax,%edx
801023e2:	74 16                	je     801023fa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023e4:	83 ec 0c             	sub    $0xc,%esp
801023e7:	68 f4 93 10 80       	push   $0x801093f4
801023ec:	e8 6f e2 ff ff       	call   80100660 <cprintf>
801023f1:	8b 0d 94 48 11 80    	mov    0x80114894,%ecx
801023f7:	83 c4 10             	add    $0x10,%esp
801023fa:	83 c3 21             	add    $0x21,%ebx
{
801023fd:	ba 10 00 00 00       	mov    $0x10,%edx
80102402:	b8 20 00 00 00       	mov    $0x20,%eax
80102407:	89 f6                	mov    %esi,%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102410:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102412:	8b 0d 94 48 11 80    	mov    0x80114894,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102418:	89 c6                	mov    %eax,%esi
8010241a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102420:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102423:	89 71 10             	mov    %esi,0x10(%ecx)
80102426:	8d 72 01             	lea    0x1(%edx),%esi
80102429:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010242c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010242e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102430:	8b 0d 94 48 11 80    	mov    0x80114894,%ecx
80102436:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010243d:	75 d1                	jne    80102410 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010243f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102442:	5b                   	pop    %ebx
80102443:	5e                   	pop    %esi
80102444:	5d                   	pop    %ebp
80102445:	c3                   	ret    
80102446:	8d 76 00             	lea    0x0(%esi),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102450:	55                   	push   %ebp
  ioapic->reg = reg;
80102451:	8b 0d 94 48 11 80    	mov    0x80114894,%ecx
{
80102457:	89 e5                	mov    %esp,%ebp
80102459:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010245c:	8d 50 20             	lea    0x20(%eax),%edx
8010245f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102463:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102465:	8b 0d 94 48 11 80    	mov    0x80114894,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010246e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102471:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102474:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102476:	a1 94 48 11 80       	mov    0x80114894,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010247e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102481:	5d                   	pop    %ebp
80102482:	c3                   	ret    
80102483:	66 90                	xchg   %ax,%ax
80102485:	66 90                	xchg   %ax,%ax
80102487:	66 90                	xchg   %ax,%ax
80102489:	66 90                	xchg   %ax,%ax
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010249a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024a0:	75 70                	jne    80102512 <kfree+0x82>
801024a2:	81 fb 08 a7 11 80    	cmp    $0x8011a708,%ebx
801024a8:	72 68                	jb     80102512 <kfree+0x82>
801024aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024b5:	77 5b                	ja     80102512 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024b7:	83 ec 04             	sub    $0x4,%esp
801024ba:	68 00 10 00 00       	push   $0x1000
801024bf:	6a 01                	push   $0x1
801024c1:	53                   	push   %ebx
801024c2:	e8 49 2a 00 00       	call   80104f10 <memset>

  if(kmem.use_lock)
801024c7:	8b 15 d4 48 11 80    	mov    0x801148d4,%edx
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	85 d2                	test   %edx,%edx
801024d2:	75 2c                	jne    80102500 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024d4:	a1 d8 48 11 80       	mov    0x801148d8,%eax
801024d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024db:	a1 d4 48 11 80       	mov    0x801148d4,%eax
  kmem.freelist = r;
801024e0:	89 1d d8 48 11 80    	mov    %ebx,0x801148d8
  if(kmem.use_lock)
801024e6:	85 c0                	test   %eax,%eax
801024e8:	75 06                	jne    801024f0 <kfree+0x60>
    release(&kmem.lock);
}
801024ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ed:	c9                   	leave  
801024ee:	c3                   	ret    
801024ef:	90                   	nop
    release(&kmem.lock);
801024f0:	c7 45 08 a0 48 11 80 	movl   $0x801148a0,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 a0 29 00 00       	jmp    80104ea0 <release>
    acquire(&kmem.lock);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 a0 48 11 80       	push   $0x801148a0
80102508:	e8 d3 28 00 00       	call   80104de0 <acquire>
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	eb c2                	jmp    801024d4 <kfree+0x44>
    panic("kfree");
80102512:	83 ec 0c             	sub    $0xc,%esp
80102515:	68 26 94 10 80       	push   $0x80109426
8010251a:	e8 71 de ff ff       	call   80100390 <panic>
8010251f:	90                   	nop

80102520 <freerange>:
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	56                   	push   %esi
80102524:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102525:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102528:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010252b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102531:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102537:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010253d:	39 de                	cmp    %ebx,%esi
8010253f:	72 23                	jb     80102564 <freerange+0x44>
80102541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102548:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010254e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 33 ff ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	90                   	nop
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <kinit1>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
80102575:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102578:	83 ec 08             	sub    $0x8,%esp
8010257b:	68 2c 94 10 80       	push   $0x8010942c
80102580:	68 a0 48 11 80       	push   $0x801148a0
80102585:	e8 16 27 00 00       	call   80104ca0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102590:	c7 05 d4 48 11 80 00 	movl   $0x0,0x801148d4
80102597:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ac:	39 de                	cmp    %ebx,%esi
801025ae:	72 1c                	jb     801025cc <kinit1+0x5c>
    kfree(p);
801025b0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025b6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025bf:	50                   	push   %eax
801025c0:	e8 cb fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c5:	83 c4 10             	add    $0x10,%esp
801025c8:	39 de                	cmp    %ebx,%esi
801025ca:	73 e4                	jae    801025b0 <kinit1+0x40>
}
801025cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025cf:	5b                   	pop    %ebx
801025d0:	5e                   	pop    %esi
801025d1:	5d                   	pop    %ebp
801025d2:	c3                   	ret    
801025d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kinit2>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <kinit2+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010260e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 73 fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 d4 48 11 80 01 	movl   $0x1,0x801148d4
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102640:	a1 d4 48 11 80       	mov    0x801148d4,%eax
80102645:	85 c0                	test   %eax,%eax
80102647:	75 1f                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102649:	a1 d8 48 11 80       	mov    0x801148d8,%eax
  if(r)
8010264e:	85 c0                	test   %eax,%eax
80102650:	74 0e                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102652:	8b 10                	mov    (%eax),%edx
80102654:	89 15 d8 48 11 80    	mov    %edx,0x801148d8
8010265a:	c3                   	ret    
8010265b:	90                   	nop
8010265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102660:	f3 c3                	repz ret 
80102662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 a0 48 11 80       	push   $0x801148a0
80102673:	e8 68 27 00 00       	call   80104de0 <acquire>
  r = kmem.freelist;
80102678:	a1 d8 48 11 80       	mov    0x801148d8,%eax
  if(r)
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	8b 15 d4 48 11 80    	mov    0x801148d4,%edx
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d d8 48 11 80    	mov    %ecx,0x801148d8
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 a0 48 11 80       	push   $0x801148a0
801026a1:	e8 fa 27 00 00       	call   80104ea0 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b0:	ba 64 00 00 00       	mov    $0x64,%edx
801026b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026b6:	a8 01                	test   $0x1,%al
801026b8:	0f 84 c2 00 00 00    	je     80102780 <kbdgetc+0xd0>
801026be:	ba 60 00 00 00       	mov    $0x60,%edx
801026c3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026c4:	0f b6 d0             	movzbl %al,%edx
801026c7:	8b 0d d4 c6 10 80    	mov    0x8010c6d4,%ecx

  if(data == 0xE0){
801026cd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026d3:	0f 84 7f 00 00 00    	je     80102758 <kbdgetc+0xa8>
{
801026d9:	55                   	push   %ebp
801026da:	89 e5                	mov    %esp,%ebp
801026dc:	53                   	push   %ebx
801026dd:	89 cb                	mov    %ecx,%ebx
801026df:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026e2:	84 c0                	test   %al,%al
801026e4:	78 4a                	js     80102730 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e6:	85 db                	test   %ebx,%ebx
801026e8:	74 09                	je     801026f3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026ea:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026ed:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801026f0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026f3:	0f b6 82 60 95 10 80 	movzbl -0x7fef6aa0(%edx),%eax
801026fa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801026fc:	0f b6 82 60 94 10 80 	movzbl -0x7fef6ba0(%edx),%eax
80102703:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102705:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102707:	89 0d d4 c6 10 80    	mov    %ecx,0x8010c6d4
  c = charcode[shift & (CTL | SHIFT)][data];
8010270d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102710:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102713:	8b 04 85 40 94 10 80 	mov    -0x7fef6bc0(,%eax,4),%eax
8010271a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271e:	74 31                	je     80102751 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102720:	8d 50 9f             	lea    -0x61(%eax),%edx
80102723:	83 fa 19             	cmp    $0x19,%edx
80102726:	77 40                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102728:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 db                	test   %ebx,%ebx
80102735:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102738:	0f b6 82 60 95 10 80 	movzbl -0x7fef6aa0(%edx),%eax
8010273f:	83 c8 40             	or     $0x40,%eax
80102742:	0f b6 c0             	movzbl %al,%eax
80102745:	f7 d0                	not    %eax
80102747:	21 c1                	and    %eax,%ecx
    return 0;
80102749:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274b:	89 0d d4 c6 10 80    	mov    %ecx,0x8010c6d4
}
80102751:	5b                   	pop    %ebx
80102752:	5d                   	pop    %ebp
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102758:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010275b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010275d:	89 0d d4 c6 10 80    	mov    %ecx,0x8010c6d4
    return 0;
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010276f:	83 f9 1a             	cmp    $0x1a,%ecx
80102772:	0f 42 c2             	cmovb  %edx,%eax
}
80102775:	5d                   	pop    %ebp
80102776:	c3                   	ret    
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d 76 00             	lea    0x0(%esi),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102796:	68 b0 26 10 80       	push   $0x801026b0
8010279b:	e8 70 e0 ff ff       	call   80100810 <consoleintr>
}
801027a0:	83 c4 10             	add    $0x10,%esp
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	66 90                	xchg   %ax,%ax
801027a7:	66 90                	xchg   %ax,%ax
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027b0:	a1 dc 48 11 80       	mov    0x801148dc,%eax
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	0f 84 c8 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102808:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280e:	8b 50 30             	mov    0x30(%eax),%edx
80102811:	c1 ea 10             	shr    $0x10,%edx
80102814:	80 fa 03             	cmp    $0x3,%dl
80102817:	77 77                	ja     80102890 <lapicinit+0xe0>
  lapic[index] = value;
80102819:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102820:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102826:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102830:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102833:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102840:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102847:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102854:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102861:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
80102867:	89 f6                	mov    %esi,%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	5d                   	pop    %ebp
80102889:	c3                   	ret    
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
8010289d:	e9 77 ff ff ff       	jmp    80102819 <lapicinit+0x69>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028b0:	8b 15 dc 48 11 80    	mov    0x801148dc,%edx
{
801028b6:	55                   	push   %ebp
801028b7:	31 c0                	xor    %eax,%eax
801028b9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028bb:	85 d2                	test   %edx,%edx
801028bd:	74 06                	je     801028c5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801028bf:	8b 42 20             	mov    0x20(%edx),%eax
801028c2:	c1 e8 18             	shr    $0x18,%eax
}
801028c5:	5d                   	pop    %ebp
801028c6:	c3                   	ret    
801028c7:	89 f6                	mov    %esi,%esi
801028c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028d0:	a1 dc 48 11 80       	mov    0x801148dc,%eax
{
801028d5:	55                   	push   %ebp
801028d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028d8:	85 c0                	test   %eax,%eax
801028da:	74 0d                	je     801028e9 <lapiceoi+0x19>
  lapic[index] = value;
801028dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028e9:	5d                   	pop    %ebp
801028ea:	c3                   	ret    
801028eb:	90                   	nop
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
}
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    
801028f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102901:	b8 0f 00 00 00       	mov    $0xf,%eax
80102906:	ba 70 00 00 00       	mov    $0x70,%edx
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	53                   	push   %ebx
8010290e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102911:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102914:	ee                   	out    %al,(%dx)
80102915:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291a:	ba 71 00 00 00       	mov    $0x71,%edx
8010291f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102920:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102922:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102925:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010292d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102930:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102933:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102935:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102938:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010293e:	a1 dc 48 11 80       	mov    0x801148dc,%eax
80102943:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102949:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102953:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102956:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102959:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102960:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102963:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102966:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010296c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102975:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102978:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010297e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102981:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010298a:	5b                   	pop    %ebx
8010298b:	5d                   	pop    %ebp
8010298c:	c3                   	ret    
8010298d:	8d 76 00             	lea    0x0(%esi),%esi

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	55                   	push   %ebp
80102991:	b8 0b 00 00 00       	mov    $0xb,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	57                   	push   %edi
8010299e:	56                   	push   %esi
8010299f:	53                   	push   %ebx
801029a0:	83 ec 4c             	sub    $0x4c,%esp
801029a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a4:	ba 71 00 00 00       	mov    $0x71,%edx
801029a9:	ec                   	in     (%dx),%al
801029aa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ad:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b5:	8d 76 00             	lea    0x0(%esi),%esi
801029b8:	31 c0                	xor    %eax,%eax
801029ba:	89 da                	mov    %ebx,%edx
801029bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029c2:	89 ca                	mov    %ecx,%edx
801029c4:	ec                   	in     (%dx),%al
801029c5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c8:	89 da                	mov    %ebx,%edx
801029ca:	b8 02 00 00 00       	mov    $0x2,%eax
801029cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d0:	89 ca                	mov    %ecx,%edx
801029d2:	ec                   	in     (%dx),%al
801029d3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d6:	89 da                	mov    %ebx,%edx
801029d8:	b8 04 00 00 00       	mov    $0x4,%eax
801029dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029de:	89 ca                	mov    %ecx,%edx
801029e0:	ec                   	in     (%dx),%al
801029e1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e4:	89 da                	mov    %ebx,%edx
801029e6:	b8 07 00 00 00       	mov    $0x7,%eax
801029eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ec:	89 ca                	mov    %ecx,%edx
801029ee:	ec                   	in     (%dx),%al
801029ef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f2:	89 da                	mov    %ebx,%edx
801029f4:	b8 08 00 00 00       	mov    $0x8,%eax
801029f9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fa:	89 ca                	mov    %ecx,%edx
801029fc:	ec                   	in     (%dx),%al
801029fd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ff:	89 da                	mov    %ebx,%edx
80102a01:	b8 09 00 00 00       	mov    $0x9,%eax
80102a06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a07:	89 ca                	mov    %ecx,%edx
80102a09:	ec                   	in     (%dx),%al
80102a0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0c:	89 da                	mov    %ebx,%edx
80102a0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	89 ca                	mov    %ecx,%edx
80102a16:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a17:	84 c0                	test   %al,%al
80102a19:	78 9d                	js     801029b8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	0f b6 fa             	movzbl %dl,%edi
80102a24:	89 f2                	mov    %esi,%edx
80102a26:	0f b6 f2             	movzbl %dl,%esi
80102a29:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a31:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a34:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a38:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a3b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a49:	31 c0                	xor    %eax,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a57:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5d:	89 ca                	mov    %ecx,%edx
80102a5f:	ec                   	in     (%dx),%al
80102a60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a63:	89 da                	mov    %ebx,%edx
80102a65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 da                	mov    %ebx,%edx
80102a76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a79:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7f:	89 ca                	mov    %ecx,%edx
80102a81:	ec                   	in     (%dx),%al
80102a82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a85:	89 da                	mov    %ebx,%edx
80102a87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a90:	89 ca                	mov    %ecx,%edx
80102a92:	ec                   	in     (%dx),%al
80102a93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a96:	89 da                	mov    %ebx,%edx
80102a98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa1:	89 ca                	mov    %ecx,%edx
80102aa3:	ec                   	in     (%dx),%al
80102aa4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aa7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab0:	6a 18                	push   $0x18
80102ab2:	50                   	push   %eax
80102ab3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ab6:	50                   	push   %eax
80102ab7:	e8 a4 24 00 00       	call   80104f60 <memcmp>
80102abc:	83 c4 10             	add    $0x10,%esp
80102abf:	85 c0                	test   %eax,%eax
80102ac1:	0f 85 f1 fe ff ff    	jne    801029b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ac7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102acb:	75 78                	jne    80102b45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102acd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad0:	89 c2                	mov    %eax,%edx
80102ad2:	83 e0 0f             	and    $0xf,%eax
80102ad5:	c1 ea 04             	shr    $0x4,%edx
80102ad8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ade:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	83 e0 0f             	and    $0xf,%eax
80102ae9:	c1 ea 04             	shr    $0x4,%edx
80102aec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102af5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102af8:	89 c2                	mov    %eax,%edx
80102afa:	83 e0 0f             	and    $0xf,%eax
80102afd:	c1 ea 04             	shr    $0x4,%edx
80102b00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b0c:	89 c2                	mov    %eax,%edx
80102b0e:	83 e0 0f             	and    $0xf,%eax
80102b11:	c1 ea 04             	shr    $0x4,%edx
80102b14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b45:	8b 75 08             	mov    0x8(%ebp),%esi
80102b48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b4b:	89 06                	mov    %eax,(%esi)
80102b4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b50:	89 46 04             	mov    %eax,0x4(%esi)
80102b53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b56:	89 46 08             	mov    %eax,0x8(%esi)
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b62:	89 46 10             	mov    %eax,0x10(%esi)
80102b65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b75:	5b                   	pop    %ebx
80102b76:	5e                   	pop    %esi
80102b77:	5f                   	pop    %edi
80102b78:	5d                   	pop    %ebp
80102b79:	c3                   	ret    
80102b7a:	66 90                	xchg   %ax,%ax
80102b7c:	66 90                	xchg   %ax,%ax
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b80:	8b 0d 28 49 11 80    	mov    0x80114928,%ecx
80102b86:	85 c9                	test   %ecx,%ecx
80102b88:	0f 8e 8a 00 00 00    	jle    80102c18 <install_trans+0x98>
{
80102b8e:	55                   	push   %ebp
80102b8f:	89 e5                	mov    %esp,%ebp
80102b91:	57                   	push   %edi
80102b92:	56                   	push   %esi
80102b93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b94:	31 db                	xor    %ebx,%ebx
{
80102b96:	83 ec 0c             	sub    $0xc,%esp
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ba0:	a1 14 49 11 80       	mov    0x80114914,%eax
80102ba5:	83 ec 08             	sub    $0x8,%esp
80102ba8:	01 d8                	add    %ebx,%eax
80102baa:	83 c0 01             	add    $0x1,%eax
80102bad:	50                   	push   %eax
80102bae:	ff 35 24 49 11 80    	pushl  0x80114924
80102bb4:	e8 17 d5 ff ff       	call   801000d0 <bread>
80102bb9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bbb:	58                   	pop    %eax
80102bbc:	5a                   	pop    %edx
80102bbd:	ff 34 9d 2c 49 11 80 	pushl  -0x7feeb6d4(,%ebx,4)
80102bc4:	ff 35 24 49 11 80    	pushl  0x80114924
  for (tail = 0; tail < log.lh.n; tail++) {
80102bca:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcd:	e8 fe d4 ff ff       	call   801000d0 <bread>
80102bd2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bd4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bd7:	83 c4 0c             	add    $0xc,%esp
80102bda:	68 00 02 00 00       	push   $0x200
80102bdf:	50                   	push   %eax
80102be0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102be3:	50                   	push   %eax
80102be4:	e8 d7 23 00 00       	call   80104fc0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102be9:	89 34 24             	mov    %esi,(%esp)
80102bec:	e8 af d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bf1:	89 3c 24             	mov    %edi,(%esp)
80102bf4:	e8 e7 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102bf9:	89 34 24             	mov    %esi,(%esp)
80102bfc:	e8 df d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	39 1d 28 49 11 80    	cmp    %ebx,0x80114928
80102c0a:	7f 94                	jg     80102ba0 <install_trans+0x20>
  }
}
80102c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0f:	5b                   	pop    %ebx
80102c10:	5e                   	pop    %esi
80102c11:	5f                   	pop    %edi
80102c12:	5d                   	pop    %ebp
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c18:	f3 c3                	repz ret 
80102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	56                   	push   %esi
80102c24:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c25:	83 ec 08             	sub    $0x8,%esp
80102c28:	ff 35 14 49 11 80    	pushl  0x80114914
80102c2e:	ff 35 24 49 11 80    	pushl  0x80114924
80102c34:	e8 97 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c39:	8b 1d 28 49 11 80    	mov    0x80114928,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c3f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c42:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c44:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c46:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c49:	7e 16                	jle    80102c61 <write_head+0x41>
80102c4b:	c1 e3 02             	shl    $0x2,%ebx
80102c4e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c50:	8b 8a 2c 49 11 80    	mov    -0x7feeb6d4(%edx),%ecx
80102c56:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c5a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c5d:	39 da                	cmp    %ebx,%edx
80102c5f:	75 ef                	jne    80102c50 <write_head+0x30>
  }
  bwrite(buf);
80102c61:	83 ec 0c             	sub    $0xc,%esp
80102c64:	56                   	push   %esi
80102c65:	e8 36 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c6a:	89 34 24             	mov    %esi,(%esp)
80102c6d:	e8 6e d5 ff ff       	call   801001e0 <brelse>
}
80102c72:	83 c4 10             	add    $0x10,%esp
80102c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c78:	5b                   	pop    %ebx
80102c79:	5e                   	pop    %esi
80102c7a:	5d                   	pop    %ebp
80102c7b:	c3                   	ret    
80102c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c80 <initlog>:
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 2c             	sub    $0x2c,%esp
80102c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c8a:	68 60 96 10 80       	push   $0x80109660
80102c8f:	68 e0 48 11 80       	push   $0x801148e0
80102c94:	e8 07 20 00 00       	call   80104ca0 <initlock>
  readsb(dev, &sb);
80102c99:	58                   	pop    %eax
80102c9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c9d:	5a                   	pop    %edx
80102c9e:	50                   	push   %eax
80102c9f:	53                   	push   %ebx
80102ca0:	e8 1b e9 ff ff       	call   801015c0 <readsb>
  log.size = sb.nlog;
80102ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cab:	59                   	pop    %ecx
  log.dev = dev;
80102cac:	89 1d 24 49 11 80    	mov    %ebx,0x80114924
  log.size = sb.nlog;
80102cb2:	89 15 18 49 11 80    	mov    %edx,0x80114918
  log.start = sb.logstart;
80102cb8:	a3 14 49 11 80       	mov    %eax,0x80114914
  struct buf *buf = bread(log.dev, log.start);
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 0b d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102cc5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
80102ccb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ccd:	89 1d 28 49 11 80    	mov    %ebx,0x80114928
  for (i = 0; i < log.lh.n; i++) {
80102cd3:	7e 1c                	jle    80102cf1 <initlog+0x71>
80102cd5:	c1 e3 02             	shl    $0x2,%ebx
80102cd8:	31 d2                	xor    %edx,%edx
80102cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ce0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ce4:	83 c2 04             	add    $0x4,%edx
80102ce7:	89 8a 28 49 11 80    	mov    %ecx,-0x7feeb6d8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102ced:	39 d3                	cmp    %edx,%ebx
80102cef:	75 ef                	jne    80102ce0 <initlog+0x60>
  brelse(buf);
80102cf1:	83 ec 0c             	sub    $0xc,%esp
80102cf4:	50                   	push   %eax
80102cf5:	e8 e6 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cfa:	e8 81 fe ff ff       	call   80102b80 <install_trans>
  log.lh.n = 0;
80102cff:	c7 05 28 49 11 80 00 	movl   $0x0,0x80114928
80102d06:	00 00 00 
  write_head(); // clear the log
80102d09:	e8 12 ff ff ff       	call   80102c20 <write_head>
}
80102d0e:	83 c4 10             	add    $0x10,%esp
80102d11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d14:	c9                   	leave  
80102d15:	c3                   	ret    
80102d16:	8d 76 00             	lea    0x0(%esi),%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d26:	68 e0 48 11 80       	push   $0x801148e0
80102d2b:	e8 b0 20 00 00       	call   80104de0 <acquire>
80102d30:	83 c4 10             	add    $0x10,%esp
80102d33:	eb 18                	jmp    80102d4d <begin_op+0x2d>
80102d35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d38:	83 ec 08             	sub    $0x8,%esp
80102d3b:	68 e0 48 11 80       	push   $0x801148e0
80102d40:	68 e0 48 11 80       	push   $0x801148e0
80102d45:	e8 76 14 00 00       	call   801041c0 <sleep>
80102d4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d4d:	a1 20 49 11 80       	mov    0x80114920,%eax
80102d52:	85 c0                	test   %eax,%eax
80102d54:	75 e2                	jne    80102d38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d56:	a1 1c 49 11 80       	mov    0x8011491c,%eax
80102d5b:	8b 15 28 49 11 80    	mov    0x80114928,%edx
80102d61:	83 c0 01             	add    $0x1,%eax
80102d64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d6a:	83 fa 1e             	cmp    $0x1e,%edx
80102d6d:	7f c9                	jg     80102d38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d72:	a3 1c 49 11 80       	mov    %eax,0x8011491c
      release(&log.lock);
80102d77:	68 e0 48 11 80       	push   $0x801148e0
80102d7c:	e8 1f 21 00 00       	call   80104ea0 <release>
      break;
    }
  }
}
80102d81:	83 c4 10             	add    $0x10,%esp
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    
80102d86:	8d 76 00             	lea    0x0(%esi),%esi
80102d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	57                   	push   %edi
80102d94:	56                   	push   %esi
80102d95:	53                   	push   %ebx
80102d96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d99:	68 e0 48 11 80       	push   $0x801148e0
80102d9e:	e8 3d 20 00 00       	call   80104de0 <acquire>
  log.outstanding -= 1;
80102da3:	a1 1c 49 11 80       	mov    0x8011491c,%eax
  if(log.committing)
80102da8:	8b 35 20 49 11 80    	mov    0x80114920,%esi
80102dae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102db1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102db4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102db6:	89 1d 1c 49 11 80    	mov    %ebx,0x8011491c
  if(log.committing)
80102dbc:	0f 85 1a 01 00 00    	jne    80102edc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102dc2:	85 db                	test   %ebx,%ebx
80102dc4:	0f 85 ee 00 00 00    	jne    80102eb8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102dca:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102dcd:	c7 05 20 49 11 80 01 	movl   $0x1,0x80114920
80102dd4:	00 00 00 
  release(&log.lock);
80102dd7:	68 e0 48 11 80       	push   $0x801148e0
80102ddc:	e8 bf 20 00 00       	call   80104ea0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102de1:	8b 0d 28 49 11 80    	mov    0x80114928,%ecx
80102de7:	83 c4 10             	add    $0x10,%esp
80102dea:	85 c9                	test   %ecx,%ecx
80102dec:	0f 8e 85 00 00 00    	jle    80102e77 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102df2:	a1 14 49 11 80       	mov    0x80114914,%eax
80102df7:	83 ec 08             	sub    $0x8,%esp
80102dfa:	01 d8                	add    %ebx,%eax
80102dfc:	83 c0 01             	add    $0x1,%eax
80102dff:	50                   	push   %eax
80102e00:	ff 35 24 49 11 80    	pushl  0x80114924
80102e06:	e8 c5 d2 ff ff       	call   801000d0 <bread>
80102e0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e0d:	58                   	pop    %eax
80102e0e:	5a                   	pop    %edx
80102e0f:	ff 34 9d 2c 49 11 80 	pushl  -0x7feeb6d4(,%ebx,4)
80102e16:	ff 35 24 49 11 80    	pushl  0x80114924
  for (tail = 0; tail < log.lh.n; tail++) {
80102e1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e1f:	e8 ac d2 ff ff       	call   801000d0 <bread>
80102e24:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e26:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e29:	83 c4 0c             	add    $0xc,%esp
80102e2c:	68 00 02 00 00       	push   $0x200
80102e31:	50                   	push   %eax
80102e32:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e35:	50                   	push   %eax
80102e36:	e8 85 21 00 00       	call   80104fc0 <memmove>
    bwrite(to);  // write the log
80102e3b:	89 34 24             	mov    %esi,(%esp)
80102e3e:	e8 5d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e43:	89 3c 24             	mov    %edi,(%esp)
80102e46:	e8 95 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e4b:	89 34 24             	mov    %esi,(%esp)
80102e4e:	e8 8d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e53:	83 c4 10             	add    $0x10,%esp
80102e56:	3b 1d 28 49 11 80    	cmp    0x80114928,%ebx
80102e5c:	7c 94                	jl     80102df2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e5e:	e8 bd fd ff ff       	call   80102c20 <write_head>
    install_trans(); // Now install writes to home locations
80102e63:	e8 18 fd ff ff       	call   80102b80 <install_trans>
    log.lh.n = 0;
80102e68:	c7 05 28 49 11 80 00 	movl   $0x0,0x80114928
80102e6f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e72:	e8 a9 fd ff ff       	call   80102c20 <write_head>
    acquire(&log.lock);
80102e77:	83 ec 0c             	sub    $0xc,%esp
80102e7a:	68 e0 48 11 80       	push   $0x801148e0
80102e7f:	e8 5c 1f 00 00       	call   80104de0 <acquire>
    wakeup(&log);
80102e84:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
    log.committing = 0;
80102e8b:	c7 05 20 49 11 80 00 	movl   $0x0,0x80114920
80102e92:	00 00 00 
    wakeup(&log);
80102e95:	e8 56 15 00 00       	call   801043f0 <wakeup>
    release(&log.lock);
80102e9a:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80102ea1:	e8 fa 1f 00 00       	call   80104ea0 <release>
80102ea6:	83 c4 10             	add    $0x10,%esp
}
80102ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eac:	5b                   	pop    %ebx
80102ead:	5e                   	pop    %esi
80102eae:	5f                   	pop    %edi
80102eaf:	5d                   	pop    %ebp
80102eb0:	c3                   	ret    
80102eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102eb8:	83 ec 0c             	sub    $0xc,%esp
80102ebb:	68 e0 48 11 80       	push   $0x801148e0
80102ec0:	e8 2b 15 00 00       	call   801043f0 <wakeup>
  release(&log.lock);
80102ec5:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80102ecc:	e8 cf 1f 00 00       	call   80104ea0 <release>
80102ed1:	83 c4 10             	add    $0x10,%esp
}
80102ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed7:	5b                   	pop    %ebx
80102ed8:	5e                   	pop    %esi
80102ed9:	5f                   	pop    %edi
80102eda:	5d                   	pop    %ebp
80102edb:	c3                   	ret    
    panic("log.committing");
80102edc:	83 ec 0c             	sub    $0xc,%esp
80102edf:	68 64 96 10 80       	push   $0x80109664
80102ee4:	e8 a7 d4 ff ff       	call   80100390 <panic>
80102ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ef0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	53                   	push   %ebx
80102ef4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ef7:	8b 15 28 49 11 80    	mov    0x80114928,%edx
{
80102efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f00:	83 fa 1d             	cmp    $0x1d,%edx
80102f03:	0f 8f 9d 00 00 00    	jg     80102fa6 <log_write+0xb6>
80102f09:	a1 18 49 11 80       	mov    0x80114918,%eax
80102f0e:	83 e8 01             	sub    $0x1,%eax
80102f11:	39 c2                	cmp    %eax,%edx
80102f13:	0f 8d 8d 00 00 00    	jge    80102fa6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f19:	a1 1c 49 11 80       	mov    0x8011491c,%eax
80102f1e:	85 c0                	test   %eax,%eax
80102f20:	0f 8e 8d 00 00 00    	jle    80102fb3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f26:	83 ec 0c             	sub    $0xc,%esp
80102f29:	68 e0 48 11 80       	push   $0x801148e0
80102f2e:	e8 ad 1e 00 00       	call   80104de0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f33:	8b 0d 28 49 11 80    	mov    0x80114928,%ecx
80102f39:	83 c4 10             	add    $0x10,%esp
80102f3c:	83 f9 00             	cmp    $0x0,%ecx
80102f3f:	7e 57                	jle    80102f98 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f41:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f44:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f46:	3b 15 2c 49 11 80    	cmp    0x8011492c,%edx
80102f4c:	75 0b                	jne    80102f59 <log_write+0x69>
80102f4e:	eb 38                	jmp    80102f88 <log_write+0x98>
80102f50:	39 14 85 2c 49 11 80 	cmp    %edx,-0x7feeb6d4(,%eax,4)
80102f57:	74 2f                	je     80102f88 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f59:	83 c0 01             	add    $0x1,%eax
80102f5c:	39 c1                	cmp    %eax,%ecx
80102f5e:	75 f0                	jne    80102f50 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f60:	89 14 85 2c 49 11 80 	mov    %edx,-0x7feeb6d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f67:	83 c0 01             	add    $0x1,%eax
80102f6a:	a3 28 49 11 80       	mov    %eax,0x80114928
  b->flags |= B_DIRTY; // prevent eviction
80102f6f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f72:	c7 45 08 e0 48 11 80 	movl   $0x801148e0,0x8(%ebp)
}
80102f79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f7c:	c9                   	leave  
  release(&log.lock);
80102f7d:	e9 1e 1f 00 00       	jmp    80104ea0 <release>
80102f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f88:	89 14 85 2c 49 11 80 	mov    %edx,-0x7feeb6d4(,%eax,4)
80102f8f:	eb de                	jmp    80102f6f <log_write+0x7f>
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f98:	8b 43 08             	mov    0x8(%ebx),%eax
80102f9b:	a3 2c 49 11 80       	mov    %eax,0x8011492c
  if (i == log.lh.n)
80102fa0:	75 cd                	jne    80102f6f <log_write+0x7f>
80102fa2:	31 c0                	xor    %eax,%eax
80102fa4:	eb c1                	jmp    80102f67 <log_write+0x77>
    panic("too big a transaction");
80102fa6:	83 ec 0c             	sub    $0xc,%esp
80102fa9:	68 73 96 10 80       	push   $0x80109673
80102fae:	e8 dd d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fb3:	83 ec 0c             	sub    $0xc,%esp
80102fb6:	68 89 96 10 80       	push   $0x80109689
80102fbb:	e8 d0 d3 ff ff       	call   80100390 <panic>

80102fc0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	53                   	push   %ebx
80102fc4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fc7:	e8 b4 09 00 00       	call   80103980 <cpuid>
80102fcc:	89 c3                	mov    %eax,%ebx
80102fce:	e8 ad 09 00 00       	call   80103980 <cpuid>
80102fd3:	83 ec 04             	sub    $0x4,%esp
80102fd6:	53                   	push   %ebx
80102fd7:	50                   	push   %eax
80102fd8:	68 a4 96 10 80       	push   $0x801096a4
80102fdd:	e8 7e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102fe2:	e8 29 35 00 00       	call   80106510 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fe7:	e8 14 09 00 00       	call   80103900 <mycpu>
80102fec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fee:	b8 01 00 00 00       	mov    $0x1,%eax
80102ff3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ffa:	e8 11 0d 00 00       	call   80103d10 <scheduler>
80102fff:	90                   	nop

80103000 <mpenter>:
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103006:	e8 d5 47 00 00       	call   801077e0 <switchkvm>
  seginit();
8010300b:	e8 40 47 00 00       	call   80107750 <seginit>
  lapicinit();
80103010:	e8 9b f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103015:	e8 a6 ff ff ff       	call   80102fc0 <mpmain>
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <main>:
{
80103020:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103024:	83 e4 f0             	and    $0xfffffff0,%esp
80103027:	ff 71 fc             	pushl  -0x4(%ecx)
8010302a:	55                   	push   %ebp
8010302b:	89 e5                	mov    %esp,%ebp
8010302d:	53                   	push   %ebx
8010302e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010302f:	83 ec 08             	sub    $0x8,%esp
80103032:	68 00 00 40 80       	push   $0x80400000
80103037:	68 08 a7 11 80       	push   $0x8011a708
8010303c:	e8 2f f5 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103041:	e8 6a 4c 00 00       	call   80107cb0 <kvmalloc>
  mpinit();        // detect other processors
80103046:	e8 75 01 00 00       	call   801031c0 <mpinit>
  lapicinit();     // interrupt controller
8010304b:	e8 60 f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103050:	e8 fb 46 00 00       	call   80107750 <seginit>
  picinit();       // disable pic
80103055:	e8 46 03 00 00       	call   801033a0 <picinit>
  ioapicinit();    // another interrupt controller
8010305a:	e8 41 f3 ff ff       	call   801023a0 <ioapicinit>
  consoleinit();   // console hardware
8010305f:	e8 5c d9 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103064:	e8 b7 39 00 00       	call   80106a20 <uartinit>
  pinit();         // process table
80103069:	e8 72 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
8010306e:	e8 1d 34 00 00       	call   80106490 <tvinit>
  binit();         // buffer cache
80103073:	e8 c8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103078:	e8 63 de ff ff       	call   80100ee0 <fileinit>
  ideinit();       // disk 
8010307d:	e8 fe f0 ff ff       	call   80102180 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103082:	83 c4 0c             	add    $0xc,%esp
80103085:	68 8a 00 00 00       	push   $0x8a
8010308a:	68 9c c5 10 80       	push   $0x8010c59c
8010308f:	68 00 70 00 80       	push   $0x80007000
80103094:	e8 27 1f 00 00       	call   80104fc0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103099:	69 05 60 4f 11 80 b0 	imul   $0xb0,0x80114f60,%eax
801030a0:	00 00 00 
801030a3:	83 c4 10             	add    $0x10,%esp
801030a6:	05 e0 49 11 80       	add    $0x801149e0,%eax
801030ab:	3d e0 49 11 80       	cmp    $0x801149e0,%eax
801030b0:	76 71                	jbe    80103123 <main+0x103>
801030b2:	bb e0 49 11 80       	mov    $0x801149e0,%ebx
801030b7:	89 f6                	mov    %esi,%esi
801030b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801030c0:	e8 3b 08 00 00       	call   80103900 <mycpu>
801030c5:	39 d8                	cmp    %ebx,%eax
801030c7:	74 41                	je     8010310a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030c9:	e8 72 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ce:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801030d3:	c7 05 f8 6f 00 80 00 	movl   $0x80103000,0x80006ff8
801030da:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030dd:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801030e4:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801030e7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801030ec:	0f b6 03             	movzbl (%ebx),%eax
801030ef:	83 ec 08             	sub    $0x8,%esp
801030f2:	68 00 70 00 00       	push   $0x7000
801030f7:	50                   	push   %eax
801030f8:	e8 03 f8 ff ff       	call   80102900 <lapicstartap>
801030fd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103100:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103106:	85 c0                	test   %eax,%eax
80103108:	74 f6                	je     80103100 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010310a:	69 05 60 4f 11 80 b0 	imul   $0xb0,0x80114f60,%eax
80103111:	00 00 00 
80103114:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010311a:	05 e0 49 11 80       	add    $0x801149e0,%eax
8010311f:	39 c3                	cmp    %eax,%ebx
80103121:	72 9d                	jb     801030c0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103123:	83 ec 08             	sub    $0x8,%esp
80103126:	68 00 00 00 8e       	push   $0x8e000000
8010312b:	68 00 00 40 80       	push   $0x80400000
80103130:	e8 ab f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103135:	e8 96 08 00 00       	call   801039d0 <userinit>
  mpmain();        // finish this processor's setup
8010313a:	e8 81 fe ff ff       	call   80102fc0 <mpmain>
8010313f:	90                   	nop

80103140 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	57                   	push   %edi
80103144:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103145:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010314b:	53                   	push   %ebx
  e = addr+len;
8010314c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010314f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103152:	39 de                	cmp    %ebx,%esi
80103154:	72 10                	jb     80103166 <mpsearch1+0x26>
80103156:	eb 50                	jmp    801031a8 <mpsearch1+0x68>
80103158:	90                   	nop
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	39 fb                	cmp    %edi,%ebx
80103162:	89 fe                	mov    %edi,%esi
80103164:	76 42                	jbe    801031a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103166:	83 ec 04             	sub    $0x4,%esp
80103169:	8d 7e 10             	lea    0x10(%esi),%edi
8010316c:	6a 04                	push   $0x4
8010316e:	68 b8 96 10 80       	push   $0x801096b8
80103173:	56                   	push   %esi
80103174:	e8 e7 1d 00 00       	call   80104f60 <memcmp>
80103179:	83 c4 10             	add    $0x10,%esp
8010317c:	85 c0                	test   %eax,%eax
8010317e:	75 e0                	jne    80103160 <mpsearch1+0x20>
80103180:	89 f1                	mov    %esi,%ecx
80103182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103188:	0f b6 11             	movzbl (%ecx),%edx
8010318b:	83 c1 01             	add    $0x1,%ecx
8010318e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103190:	39 f9                	cmp    %edi,%ecx
80103192:	75 f4                	jne    80103188 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103194:	84 c0                	test   %al,%al
80103196:	75 c8                	jne    80103160 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103198:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010319b:	89 f0                	mov    %esi,%eax
8010319d:	5b                   	pop    %ebx
8010319e:	5e                   	pop    %esi
8010319f:	5f                   	pop    %edi
801031a0:	5d                   	pop    %ebp
801031a1:	c3                   	ret    
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031ab:	31 f6                	xor    %esi,%esi
}
801031ad:	89 f0                	mov    %esi,%eax
801031af:	5b                   	pop    %ebx
801031b0:	5e                   	pop    %esi
801031b1:	5f                   	pop    %edi
801031b2:	5d                   	pop    %ebp
801031b3:	c3                   	ret    
801031b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801031c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
801031c5:	53                   	push   %ebx
801031c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031d7:	c1 e0 08             	shl    $0x8,%eax
801031da:	09 d0                	or     %edx,%eax
801031dc:	c1 e0 04             	shl    $0x4,%eax
801031df:	85 c0                	test   %eax,%eax
801031e1:	75 1b                	jne    801031fe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031f1:	c1 e0 08             	shl    $0x8,%eax
801031f4:	09 d0                	or     %edx,%eax
801031f6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031f9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103203:	e8 38 ff ff ff       	call   80103140 <mpsearch1>
80103208:	85 c0                	test   %eax,%eax
8010320a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010320d:	0f 84 3d 01 00 00    	je     80103350 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103216:	8b 58 04             	mov    0x4(%eax),%ebx
80103219:	85 db                	test   %ebx,%ebx
8010321b:	0f 84 4f 01 00 00    	je     80103370 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103221:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103227:	83 ec 04             	sub    $0x4,%esp
8010322a:	6a 04                	push   $0x4
8010322c:	68 d5 96 10 80       	push   $0x801096d5
80103231:	56                   	push   %esi
80103232:	e8 29 1d 00 00       	call   80104f60 <memcmp>
80103237:	83 c4 10             	add    $0x10,%esp
8010323a:	85 c0                	test   %eax,%eax
8010323c:	0f 85 2e 01 00 00    	jne    80103370 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103242:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103249:	3c 01                	cmp    $0x1,%al
8010324b:	0f 95 c2             	setne  %dl
8010324e:	3c 04                	cmp    $0x4,%al
80103250:	0f 95 c0             	setne  %al
80103253:	20 c2                	and    %al,%dl
80103255:	0f 85 15 01 00 00    	jne    80103370 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010325b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103262:	66 85 ff             	test   %di,%di
80103265:	74 1a                	je     80103281 <mpinit+0xc1>
80103267:	89 f0                	mov    %esi,%eax
80103269:	01 f7                	add    %esi,%edi
  sum = 0;
8010326b:	31 d2                	xor    %edx,%edx
8010326d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103270:	0f b6 08             	movzbl (%eax),%ecx
80103273:	83 c0 01             	add    $0x1,%eax
80103276:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103278:	39 c7                	cmp    %eax,%edi
8010327a:	75 f4                	jne    80103270 <mpinit+0xb0>
8010327c:	84 d2                	test   %dl,%dl
8010327e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103281:	85 f6                	test   %esi,%esi
80103283:	0f 84 e7 00 00 00    	je     80103370 <mpinit+0x1b0>
80103289:	84 d2                	test   %dl,%dl
8010328b:	0f 85 df 00 00 00    	jne    80103370 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103291:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103297:	a3 dc 48 11 80       	mov    %eax,0x801148dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010329c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032a9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ae:	01 d6                	add    %edx,%esi
801032b0:	39 c6                	cmp    %eax,%esi
801032b2:	76 23                	jbe    801032d7 <mpinit+0x117>
    switch(*p){
801032b4:	0f b6 10             	movzbl (%eax),%edx
801032b7:	80 fa 04             	cmp    $0x4,%dl
801032ba:	0f 87 ca 00 00 00    	ja     8010338a <mpinit+0x1ca>
801032c0:	ff 24 95 fc 96 10 80 	jmp    *-0x7fef6904(,%edx,4)
801032c7:	89 f6                	mov    %esi,%esi
801032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	39 c6                	cmp    %eax,%esi
801032d5:	77 dd                	ja     801032b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032d7:	85 db                	test   %ebx,%ebx
801032d9:	0f 84 9e 00 00 00    	je     8010337d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801032e6:	74 15                	je     801032fd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032e8:	b8 70 00 00 00       	mov    $0x70,%eax
801032ed:	ba 22 00 00 00       	mov    $0x22,%edx
801032f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f3:	ba 23 00 00 00       	mov    $0x23,%edx
801032f8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032f9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fc:	ee                   	out    %al,(%dx)
  }
}
801032fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103300:	5b                   	pop    %ebx
80103301:	5e                   	pop    %esi
80103302:	5f                   	pop    %edi
80103303:	5d                   	pop    %ebp
80103304:	c3                   	ret    
80103305:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103308:	8b 0d 60 4f 11 80    	mov    0x80114f60,%ecx
8010330e:	83 f9 07             	cmp    $0x7,%ecx
80103311:	7f 19                	jg     8010332c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103313:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103317:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010331d:	83 c1 01             	add    $0x1,%ecx
80103320:	89 0d 60 4f 11 80    	mov    %ecx,0x80114f60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103326:	88 97 e0 49 11 80    	mov    %dl,-0x7feeb620(%edi)
      p += sizeof(struct mpproc);
8010332c:	83 c0 14             	add    $0x14,%eax
      continue;
8010332f:	e9 7c ff ff ff       	jmp    801032b0 <mpinit+0xf0>
80103334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103338:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010333c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010333f:	88 15 c0 49 11 80    	mov    %dl,0x801149c0
      continue;
80103345:	e9 66 ff ff ff       	jmp    801032b0 <mpinit+0xf0>
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103350:	ba 00 00 01 00       	mov    $0x10000,%edx
80103355:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010335a:	e8 e1 fd ff ff       	call   80103140 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010335f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103364:	0f 85 a9 fe ff ff    	jne    80103213 <mpinit+0x53>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	68 bd 96 10 80       	push   $0x801096bd
80103378:	e8 13 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010337d:	83 ec 0c             	sub    $0xc,%esp
80103380:	68 dc 96 10 80       	push   $0x801096dc
80103385:	e8 06 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
8010338a:	31 db                	xor    %ebx,%ebx
8010338c:	e9 26 ff ff ff       	jmp    801032b7 <mpinit+0xf7>
80103391:	66 90                	xchg   %ax,%ax
80103393:	66 90                	xchg   %ax,%ax
80103395:	66 90                	xchg   %ax,%ax
80103397:	66 90                	xchg   %ax,%ax
80103399:	66 90                	xchg   %ax,%ax
8010339b:	66 90                	xchg   %ax,%ax
8010339d:	66 90                	xchg   %ax,%ax
8010339f:	90                   	nop

801033a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033a0:	55                   	push   %ebp
801033a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033a6:	ba 21 00 00 00       	mov    $0x21,%edx
801033ab:	89 e5                	mov    %esp,%ebp
801033ad:	ee                   	out    %al,(%dx)
801033ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801033b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033b4:	5d                   	pop    %ebp
801033b5:	c3                   	ret    
801033b6:	66 90                	xchg   %ax,%ax
801033b8:	66 90                	xchg   %ax,%ax
801033ba:	66 90                	xchg   %ax,%ax
801033bc:	66 90                	xchg   %ax,%ax
801033be:	66 90                	xchg   %ax,%ax

801033c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 0c             	sub    $0xc,%esp
801033c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033db:	e8 20 db ff ff       	call   80100f00 <filealloc>
801033e0:	85 c0                	test   %eax,%eax
801033e2:	89 03                	mov    %eax,(%ebx)
801033e4:	74 22                	je     80103408 <pipealloc+0x48>
801033e6:	e8 15 db ff ff       	call   80100f00 <filealloc>
801033eb:	85 c0                	test   %eax,%eax
801033ed:	89 06                	mov    %eax,(%esi)
801033ef:	74 3f                	je     80103430 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033f1:	e8 4a f2 ff ff       	call   80102640 <kalloc>
801033f6:	85 c0                	test   %eax,%eax
801033f8:	89 c7                	mov    %eax,%edi
801033fa:	75 54                	jne    80103450 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033fc:	8b 03                	mov    (%ebx),%eax
801033fe:	85 c0                	test   %eax,%eax
80103400:	75 34                	jne    80103436 <pipealloc+0x76>
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103408:	8b 06                	mov    (%esi),%eax
8010340a:	85 c0                	test   %eax,%eax
8010340c:	74 0c                	je     8010341a <pipealloc+0x5a>
    fileclose(*f1);
8010340e:	83 ec 0c             	sub    $0xc,%esp
80103411:	50                   	push   %eax
80103412:	e8 a9 db ff ff       	call   80100fc0 <fileclose>
80103417:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010341a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010341d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5f                   	pop    %edi
80103425:	5d                   	pop    %ebp
80103426:	c3                   	ret    
80103427:	89 f6                	mov    %esi,%esi
80103429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103430:	8b 03                	mov    (%ebx),%eax
80103432:	85 c0                	test   %eax,%eax
80103434:	74 e4                	je     8010341a <pipealloc+0x5a>
    fileclose(*f0);
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	50                   	push   %eax
8010343a:	e8 81 db ff ff       	call   80100fc0 <fileclose>
  if(*f1)
8010343f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103441:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103444:	85 c0                	test   %eax,%eax
80103446:	75 c6                	jne    8010340e <pipealloc+0x4e>
80103448:	eb d0                	jmp    8010341a <pipealloc+0x5a>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103450:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103453:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010345a:	00 00 00 
  p->writeopen = 1;
8010345d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103464:	00 00 00 
  p->nwrite = 0;
80103467:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346e:	00 00 00 
  p->nread = 0;
80103471:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103478:	00 00 00 
  initlock(&p->lock, "pipe");
8010347b:	68 10 97 10 80       	push   $0x80109710
80103480:	50                   	push   %eax
80103481:	e8 1a 18 00 00       	call   80104ca0 <initlock>
  (*f0)->type = FD_PIPE;
80103486:	8b 03                	mov    (%ebx),%eax
  return 0;
80103488:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010348b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103491:	8b 03                	mov    (%ebx),%eax
80103493:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103497:	8b 03                	mov    (%ebx),%eax
80103499:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010349d:	8b 03                	mov    (%ebx),%eax
8010349f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034aa:	8b 06                	mov    (%esi),%eax
801034ac:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034b0:	8b 06                	mov    (%esi),%eax
801034b2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b6:	8b 06                	mov    (%esi),%eax
801034b8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034be:	31 c0                	xor    %eax,%eax
}
801034c0:	5b                   	pop    %ebx
801034c1:	5e                   	pop    %esi
801034c2:	5f                   	pop    %edi
801034c3:	5d                   	pop    %ebp
801034c4:	c3                   	ret    
801034c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	56                   	push   %esi
801034d4:	53                   	push   %ebx
801034d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034db:	83 ec 0c             	sub    $0xc,%esp
801034de:	53                   	push   %ebx
801034df:	e8 fc 18 00 00       	call   80104de0 <acquire>
  if(writable){
801034e4:	83 c4 10             	add    $0x10,%esp
801034e7:	85 f6                	test   %esi,%esi
801034e9:	74 45                	je     80103530 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801034eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034f1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801034f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034fb:	00 00 00 
    wakeup(&p->nread);
801034fe:	50                   	push   %eax
801034ff:	e8 ec 0e 00 00       	call   801043f0 <wakeup>
80103504:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103507:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010350d:	85 d2                	test   %edx,%edx
8010350f:	75 0a                	jne    8010351b <pipeclose+0x4b>
80103511:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103517:	85 c0                	test   %eax,%eax
80103519:	74 35                	je     80103550 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010351b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010351e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103521:	5b                   	pop    %ebx
80103522:	5e                   	pop    %esi
80103523:	5d                   	pop    %ebp
    release(&p->lock);
80103524:	e9 77 19 00 00       	jmp    80104ea0 <release>
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103530:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103536:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103539:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103540:	00 00 00 
    wakeup(&p->nwrite);
80103543:	50                   	push   %eax
80103544:	e8 a7 0e 00 00       	call   801043f0 <wakeup>
80103549:	83 c4 10             	add    $0x10,%esp
8010354c:	eb b9                	jmp    80103507 <pipeclose+0x37>
8010354e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	53                   	push   %ebx
80103554:	e8 47 19 00 00       	call   80104ea0 <release>
    kfree((char*)p);
80103559:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010355c:	83 c4 10             	add    $0x10,%esp
}
8010355f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103562:	5b                   	pop    %ebx
80103563:	5e                   	pop    %esi
80103564:	5d                   	pop    %ebp
    kfree((char*)p);
80103565:	e9 26 ef ff ff       	jmp    80102490 <kfree>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103570 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 28             	sub    $0x28,%esp
80103579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010357c:	53                   	push   %ebx
8010357d:	e8 5e 18 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++){
80103582:	8b 45 10             	mov    0x10(%ebp),%eax
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	85 c0                	test   %eax,%eax
8010358a:	0f 8e c9 00 00 00    	jle    80103659 <pipewrite+0xe9>
80103590:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103593:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103599:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010359f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035a2:	03 4d 10             	add    0x10(%ebp),%ecx
801035a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035ae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035b4:	39 d0                	cmp    %edx,%eax
801035b6:	75 71                	jne    80103629 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035b8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035be:	85 c0                	test   %eax,%eax
801035c0:	74 4e                	je     80103610 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035c8:	eb 3a                	jmp    80103604 <pipewrite+0x94>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	57                   	push   %edi
801035d4:	e8 17 0e 00 00       	call   801043f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035d9:	5a                   	pop    %edx
801035da:	59                   	pop    %ecx
801035db:	53                   	push   %ebx
801035dc:	56                   	push   %esi
801035dd:	e8 de 0b 00 00       	call   801041c0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035e8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035ee:	83 c4 10             	add    $0x10,%esp
801035f1:	05 00 02 00 00       	add    $0x200,%eax
801035f6:	39 c2                	cmp    %eax,%edx
801035f8:	75 36                	jne    80103630 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801035fa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103600:	85 c0                	test   %eax,%eax
80103602:	74 0c                	je     80103610 <pipewrite+0xa0>
80103604:	e8 97 03 00 00       	call   801039a0 <myproc>
80103609:	8b 40 24             	mov    0x24(%eax),%eax
8010360c:	85 c0                	test   %eax,%eax
8010360e:	74 c0                	je     801035d0 <pipewrite+0x60>
        release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 87 18 00 00       	call   80104ea0 <release>
        return -1;
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103624:	5b                   	pop    %ebx
80103625:	5e                   	pop    %esi
80103626:	5f                   	pop    %edi
80103627:	5d                   	pop    %ebp
80103628:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103629:	89 c2                	mov    %eax,%edx
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103630:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103633:	8d 42 01             	lea    0x1(%edx),%eax
80103636:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010363c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103642:	83 c6 01             	add    $0x1,%esi
80103645:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103649:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010364c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010364f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103653:	0f 85 4f ff ff ff    	jne    801035a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103659:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010365f:	83 ec 0c             	sub    $0xc,%esp
80103662:	50                   	push   %eax
80103663:	e8 88 0d 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
80103668:	89 1c 24             	mov    %ebx,(%esp)
8010366b:	e8 30 18 00 00       	call   80104ea0 <release>
  return n;
80103670:	83 c4 10             	add    $0x10,%esp
80103673:	8b 45 10             	mov    0x10(%ebp),%eax
80103676:	eb a9                	jmp    80103621 <pipewrite+0xb1>
80103678:	90                   	nop
80103679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103680 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 18             	sub    $0x18,%esp
80103689:	8b 75 08             	mov    0x8(%ebp),%esi
8010368c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010368f:	56                   	push   %esi
80103690:	e8 4b 17 00 00       	call   80104de0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010369e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036a4:	75 6a                	jne    80103710 <piperead+0x90>
801036a6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036ac:	85 db                	test   %ebx,%ebx
801036ae:	0f 84 c4 00 00 00    	je     80103778 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	eb 2d                	jmp    801036e9 <piperead+0x69>
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c0:	83 ec 08             	sub    $0x8,%esp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	e8 f6 0a 00 00       	call   801041c0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036d3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036d9:	75 35                	jne    80103710 <piperead+0x90>
801036db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801036e1:	85 d2                	test   %edx,%edx
801036e3:	0f 84 8f 00 00 00    	je     80103778 <piperead+0xf8>
    if(myproc()->killed){
801036e9:	e8 b2 02 00 00       	call   801039a0 <myproc>
801036ee:	8b 48 24             	mov    0x24(%eax),%ecx
801036f1:	85 c9                	test   %ecx,%ecx
801036f3:	74 cb                	je     801036c0 <piperead+0x40>
      release(&p->lock);
801036f5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801036f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801036fd:	56                   	push   %esi
801036fe:	e8 9d 17 00 00       	call   80104ea0 <release>
      return -1;
80103703:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103706:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103709:	89 d8                	mov    %ebx,%eax
8010370b:	5b                   	pop    %ebx
8010370c:	5e                   	pop    %esi
8010370d:	5f                   	pop    %edi
8010370e:	5d                   	pop    %ebp
8010370f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103710:	8b 45 10             	mov    0x10(%ebp),%eax
80103713:	85 c0                	test   %eax,%eax
80103715:	7e 61                	jle    80103778 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103717:	31 db                	xor    %ebx,%ebx
80103719:	eb 13                	jmp    8010372e <piperead+0xae>
8010371b:	90                   	nop
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103720:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103726:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010372c:	74 1f                	je     8010374d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010372e:	8d 41 01             	lea    0x1(%ecx),%eax
80103731:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103737:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010373d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103742:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	83 c3 01             	add    $0x1,%ebx
80103748:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374b:	75 d3                	jne    80103720 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103753:	83 ec 0c             	sub    $0xc,%esp
80103756:	50                   	push   %eax
80103757:	e8 94 0c 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
8010375c:	89 34 24             	mov    %esi,(%esp)
8010375f:	e8 3c 17 00 00       	call   80104ea0 <release>
  return i;
80103764:	83 c4 10             	add    $0x10,%esp
}
80103767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010376a:	89 d8                	mov    %ebx,%eax
8010376c:	5b                   	pop    %ebx
8010376d:	5e                   	pop    %esi
8010376e:	5f                   	pop    %edi
8010376f:	5d                   	pop    %ebp
80103770:	c3                   	ret    
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103778:	31 db                	xor    %ebx,%ebx
8010377a:	eb d1                	jmp    8010374d <piperead+0xcd>
8010377c:	66 90                	xchg   %ax,%ax
8010377e:	66 90                	xchg   %ax,%ax

80103780 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103784:	bb b4 6d 11 80       	mov    $0x80116db4,%ebx
{
80103789:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010378c:	68 80 6d 11 80       	push   $0x80116d80
80103791:	e8 4a 16 00 00       	call   80104de0 <acquire>
80103796:	83 c4 10             	add    $0x10,%esp
80103799:	eb 13                	jmp    801037ae <allocproc+0x2e>
8010379b:	90                   	nop
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a0:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
801037a6:	81 fb b4 9e 11 80    	cmp    $0x80119eb4,%ebx
801037ac:	73 7a                	jae    80103828 <allocproc+0xa8>
    if(p->state == UNUSED)
801037ae:	8b 43 0c             	mov    0xc(%ebx),%eax
801037b1:	85 c0                	test   %eax,%eax
801037b3:	75 eb                	jne    801037a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037b5:	a1 08 c0 10 80       	mov    0x8010c008,%eax

  release(&ptable.lock);
801037ba:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037bd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037c4:	8d 50 01             	lea    0x1(%eax),%edx
801037c7:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801037ca:	68 80 6d 11 80       	push   $0x80116d80
  p->pid = nextpid++;
801037cf:	89 15 08 c0 10 80    	mov    %edx,0x8010c008
  release(&ptable.lock);
801037d5:	e8 c6 16 00 00       	call   80104ea0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037da:	e8 61 ee ff ff       	call   80102640 <kalloc>
801037df:	83 c4 10             	add    $0x10,%esp
801037e2:	85 c0                	test   %eax,%eax
801037e4:	89 43 08             	mov    %eax,0x8(%ebx)
801037e7:	74 58                	je     80103841 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037e9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ef:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037f2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037f7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037fa:	c7 40 14 7f 64 10 80 	movl   $0x8010647f,0x14(%eax)
  p->context = (struct context*)sp;
80103801:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103804:	6a 14                	push   $0x14
80103806:	6a 00                	push   $0x0
80103808:	50                   	push   %eax
80103809:	e8 02 17 00 00       	call   80104f10 <memset>
  p->context->eip = (uint)forkret;
8010380e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103811:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103814:	c7 40 10 50 38 10 80 	movl   $0x80103850,0x10(%eax)
}
8010381b:	89 d8                	mov    %ebx,%eax
8010381d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103820:	c9                   	leave  
80103821:	c3                   	ret    
80103822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103828:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010382b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010382d:	68 80 6d 11 80       	push   $0x80116d80
80103832:	e8 69 16 00 00       	call   80104ea0 <release>
}
80103837:	89 d8                	mov    %ebx,%eax
  return 0;
80103839:	83 c4 10             	add    $0x10,%esp
}
8010383c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383f:	c9                   	leave  
80103840:	c3                   	ret    
    p->state = UNUSED;
80103841:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	eb cf                	jmp    8010381b <allocproc+0x9b>
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103850 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103856:	68 80 6d 11 80       	push   $0x80116d80
8010385b:	e8 40 16 00 00       	call   80104ea0 <release>

  if (first) {
80103860:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	85 c0                	test   %eax,%eax
8010386a:	75 04                	jne    80103870 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010386c:	c9                   	leave  
8010386d:	c3                   	ret    
8010386e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103870:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103873:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
8010387a:	00 00 00 
    iinit(ROOTDEV);
8010387d:	6a 01                	push   $0x1
8010387f:	e8 7c dd ff ff       	call   80101600 <iinit>
    initlog(ROOTDEV);
80103884:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010388b:	e8 f0 f3 ff ff       	call   80102c80 <initlog>
80103890:	83 c4 10             	add    $0x10,%esp
}
80103893:	c9                   	leave  
80103894:	c3                   	ret    
80103895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <xem_init>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
  semaphore->value = 1;
801038a3:	8b 45 08             	mov    0x8(%ebp),%eax
801038a6:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
}
801038ad:	31 c0                	xor    %eax,%eax
801038af:	5d                   	pop    %ebp
801038b0:	c3                   	ret    
801038b1:	eb 0d                	jmp    801038c0 <rwlock_init>
801038b3:	90                   	nop
801038b4:	90                   	nop
801038b5:	90                   	nop
801038b6:	90                   	nop
801038b7:	90                   	nop
801038b8:	90                   	nop
801038b9:	90                   	nop
801038ba:	90                   	nop
801038bb:	90                   	nop
801038bc:	90                   	nop
801038bd:	90                   	nop
801038be:	90                   	nop
801038bf:	90                   	nop

801038c0 <rwlock_init>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  semaphore->value = 1;
801038c6:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
801038cd:	c7 40 6c 01 00 00 00 	movl   $0x1,0x6c(%eax)
  rwlock->readers = 0;
801038d4:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
}
801038db:	31 c0                	xor    %eax,%eax
801038dd:	5d                   	pop    %ebp
801038de:	c3                   	ret    
801038df:	90                   	nop

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 15 97 10 80       	push   $0x80109715
801038eb:	68 80 6d 11 80       	push   $0x80116d80
801038f0:	e8 ab 13 00 00       	call   80104ca0 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf  
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 5e                	jne    8010396a <mycpu+0x6a>
  apicid = lapicid();
8010390c:	e8 9f ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 60 4f 11 80    	mov    0x80114f60,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 42                	jle    8010395d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010391b:	0f b6 15 e0 49 11 80 	movzbl 0x801149e0,%edx
80103922:	39 d0                	cmp    %edx,%eax
80103924:	74 30                	je     80103956 <mycpu+0x56>
80103926:	b9 90 4a 11 80       	mov    $0x80114a90,%ecx
  for (i = 0; i < ncpu; ++i) {
8010392b:	31 d2                	xor    %edx,%edx
8010392d:	8d 76 00             	lea    0x0(%esi),%esi
80103930:	83 c2 01             	add    $0x1,%edx
80103933:	39 f2                	cmp    %esi,%edx
80103935:	74 26                	je     8010395d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103937:	0f b6 19             	movzbl (%ecx),%ebx
8010393a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103940:	39 c3                	cmp    %eax,%ebx
80103942:	75 ec                	jne    80103930 <mycpu+0x30>
80103944:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010394a:	05 e0 49 11 80       	add    $0x801149e0,%eax
}
8010394f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103952:	5b                   	pop    %ebx
80103953:	5e                   	pop    %esi
80103954:	5d                   	pop    %ebp
80103955:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103956:	b8 e0 49 11 80       	mov    $0x801149e0,%eax
      return &cpus[i];
8010395b:	eb f2                	jmp    8010394f <mycpu+0x4f>
  panic("unknown apicid\n");
8010395d:	83 ec 0c             	sub    $0xc,%esp
80103960:	68 1c 97 10 80       	push   $0x8010971c
80103965:	e8 26 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	68 4c 98 10 80       	push   $0x8010984c
80103972:	e8 19 ca ff ff       	call   80100390 <panic>
80103977:	89 f6                	mov    %esi,%esi
80103979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103980 <cpuid>:
cpuid() {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103986:	e8 75 ff ff ff       	call   80103900 <mycpu>
8010398b:	2d e0 49 11 80       	sub    $0x801149e0,%eax
}
80103990:	c9                   	leave  
  return mycpu()-cpus;
80103991:	c1 f8 04             	sar    $0x4,%eax
80103994:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399a:	c3                   	ret    
8010399b:	90                   	nop
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039a0 <myproc>:
myproc(void) {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039a7:	e8 64 13 00 00       	call   80104d10 <pushcli>
  c = mycpu();
801039ac:	e8 4f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
801039b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b7:	e8 94 13 00 00       	call   80104d50 <popcli>
}
801039bc:	83 c4 04             	add    $0x4,%esp
801039bf:	89 d8                	mov    %ebx,%eax
801039c1:	5b                   	pop    %ebx
801039c2:	5d                   	pop    %ebp
801039c3:	c3                   	ret    
801039c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039d0 <userinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039d7:	e8 a4 fd ff ff       	call   80103780 <allocproc>
801039dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039de:	a3 dc c6 10 80       	mov    %eax,0x8010c6dc
  if((p->pgdir = setupkvm()) == 0)
801039e3:	e8 48 42 00 00       	call   80107c30 <setupkvm>
801039e8:	85 c0                	test   %eax,%eax
801039ea:	89 43 04             	mov    %eax,0x4(%ebx)
801039ed:	0f 84 c5 00 00 00    	je     80103ab8 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039f3:	83 ec 04             	sub    $0x4,%esp
801039f6:	68 2c 00 00 00       	push   $0x2c
801039fb:	68 70 c5 10 80       	push   $0x8010c570
80103a00:	50                   	push   %eax
80103a01:	e8 0a 3f 00 00       	call   80107910 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a0f:	6a 4c                	push   $0x4c
80103a11:	6a 00                	push   $0x0
80103a13:	ff 73 18             	pushl  0x18(%ebx)
80103a16:	e8 f5 14 00 00       	call   80104f10 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a23:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a28:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a41:	8b 43 18             	mov    0x18(%ebx),%eax
80103a44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a6d:	6a 10                	push   $0x10
80103a6f:	68 45 97 10 80       	push   $0x80109745
80103a74:	50                   	push   %eax
80103a75:	e8 76 16 00 00       	call   801050f0 <safestrcpy>
  p->cwd = namei("/");
80103a7a:	c7 04 24 4e 97 10 80 	movl   $0x8010974e,(%esp)
80103a81:	e8 da e5 ff ff       	call   80102060 <namei>
80103a86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a89:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80103a90:	e8 4b 13 00 00       	call   80104de0 <acquire>
  p->state = RUNNABLE;
80103a95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a9c:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80103aa3:	e8 f8 13 00 00       	call   80104ea0 <release>
  init_process(p);
80103aa8:	89 1c 24             	mov    %ebx,(%esp)
80103aab:	e8 20 56 00 00       	call   801090d0 <init_process>
}
80103ab0:	83 c4 10             	add    $0x10,%esp
80103ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab6:	c9                   	leave  
80103ab7:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab8:	83 ec 0c             	sub    $0xc,%esp
80103abb:	68 2c 97 10 80       	push   $0x8010972c
80103ac0:	e8 cb c8 ff ff       	call   80100390 <panic>
80103ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <growproc>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 0c             	sub    $0xc,%esp
80103ad9:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80103adc:	e8 2f 12 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103ae1:	e8 1a fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ae6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aec:	e8 5f 12 00 00       	call   80104d50 <popcli>
  acquire(&ptable.lock);
80103af1:	83 ec 0c             	sub    $0xc,%esp
80103af4:	68 80 6d 11 80       	push   $0x80116d80
80103af9:	e8 e2 12 00 00       	call   80104de0 <acquire>
  if(n > 0){
80103afe:	83 c4 10             	add    $0x10,%esp
80103b01:	83 ff 00             	cmp    $0x0,%edi
  sz = curproc->sz;
80103b04:	8b 33                	mov    (%ebx),%esi
  if(n > 0){
80103b06:	7f 28                	jg     80103b30 <growproc+0x60>
  } else if(n < 0){
80103b08:	75 46                	jne    80103b50 <growproc+0x80>
  release(&ptable.lock);
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	68 80 6d 11 80       	push   $0x80116d80
80103b12:	e8 89 13 00 00       	call   80104ea0 <release>
  curproc->sz = sz;
80103b17:	89 33                	mov    %esi,(%ebx)
  switchuvm(curproc);
80103b19:	89 1c 24             	mov    %ebx,(%esp)
80103b1c:	e8 df 3c 00 00       	call   80107800 <switchuvm>
  return 0;
80103b21:	83 c4 10             	add    $0x10,%esp
80103b24:	31 c0                	xor    %eax,%eax
}
80103b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b29:	5b                   	pop    %ebx
80103b2a:	5e                   	pop    %esi
80103b2b:	5f                   	pop    %edi
80103b2c:	5d                   	pop    %ebp
80103b2d:	c3                   	ret    
80103b2e:	66 90                	xchg   %ax,%ax
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 f7                	add    %esi,%edi
80103b35:	57                   	push   %edi
80103b36:	56                   	push   %esi
80103b37:	ff 73 04             	pushl  0x4(%ebx)
80103b3a:	e8 11 3f 00 00       	call   80107a50 <allocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	89 c6                	mov    %eax,%esi
80103b46:	75 c2                	jne    80103b0a <growproc+0x3a>
      return -1;
80103b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b4d:	eb d7                	jmp    80103b26 <growproc+0x56>
80103b4f:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 f7                	add    %esi,%edi
80103b55:	57                   	push   %edi
80103b56:	56                   	push   %esi
80103b57:	ff 73 04             	pushl  0x4(%ebx)
80103b5a:	e8 21 40 00 00       	call   80107b80 <deallocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	89 c6                	mov    %eax,%esi
80103b66:	75 a2                	jne    80103b0a <growproc+0x3a>
80103b68:	eb de                	jmp    80103b48 <growproc+0x78>
80103b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b70 <fork>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b79:	e8 92 11 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103b7e:	e8 7d fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b89:	e8 c2 11 00 00       	call   80104d50 <popcli>
  if((np = allocproc()) == 0){
80103b8e:	e8 ed fb ff ff       	call   80103780 <allocproc>
80103b93:	85 c0                	test   %eax,%eax
80103b95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b98:	0f 84 bf 00 00 00    	je     80103c5d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b9e:	83 ec 08             	sub    $0x8,%esp
80103ba1:	ff 33                	pushl  (%ebx)
80103ba3:	ff 73 04             	pushl  0x4(%ebx)
80103ba6:	89 c7                	mov    %eax,%edi
80103ba8:	e8 53 41 00 00       	call   80107d00 <copyuvm>
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	85 c0                	test   %eax,%eax
80103bb2:	89 47 04             	mov    %eax,0x4(%edi)
80103bb5:	0f 84 a9 00 00 00    	je     80103c64 <fork+0xf4>
  np->sz = curproc->sz;
80103bbb:	8b 03                	mov    (%ebx),%eax
80103bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bc0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103bc2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103bc5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103bc7:	8b 79 18             	mov    0x18(%ecx),%edi
80103bca:	8b 73 18             	mov    0x18(%ebx),%esi
80103bcd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bd6:	8b 40 18             	mov    0x18(%eax),%eax
80103bd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 7f d3 ff ff       	call   80100f70 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 bf db ff ff       	call   801017d0 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 ca 14 00 00       	call   801050f0 <safestrcpy>
  pid = np->pid;
80103c26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c29:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80103c30:	e8 ab 11 00 00       	call   80104de0 <acquire>
  np->state = RUNNABLE;
80103c35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c3c:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80103c43:	e8 58 12 00 00       	call   80104ea0 <release>
  init_process(np);
80103c48:	89 3c 24             	mov    %edi,(%esp)
80103c4b:	e8 80 54 00 00       	call   801090d0 <init_process>
  return pid;
80103c50:	83 c4 10             	add    $0x10,%esp
}
80103c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c56:	89 d8                	mov    %ebx,%eax
80103c58:	5b                   	pop    %ebx
80103c59:	5e                   	pop    %esi
80103c5a:	5f                   	pop    %edi
80103c5b:	5d                   	pop    %ebp
80103c5c:	c3                   	ret    
    return -1;
80103c5d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c62:	eb ef                	jmp    80103c53 <fork+0xe3>
    kfree(np->kstack);
80103c64:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	ff 73 08             	pushl  0x8(%ebx)
80103c6d:	e8 1e e8 ff ff       	call   80102490 <kfree>
    np->kstack = 0;
80103c72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c88:	eb c9                	jmp    80103c53 <fork+0xe3>
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c90 <select_thread>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
  int i, searched = mp->master->searched;
80103c95:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103c98:	53                   	push   %ebx
  int i, searched = mp->master->searched;
80103c99:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
  if(thd_cnt == 0)
80103c9f:	a1 d8 c6 10 80       	mov    0x8010c6d8,%eax
80103ca4:	85 c0                	test   %eax,%eax
  int i, searched = mp->master->searched;
80103ca6:	8b b9 c0 00 00 00    	mov    0xc0(%ecx),%edi
  if(thd_cnt == 0)
80103cac:	74 5a                	je     80103d08 <select_thread+0x78>
80103cae:	83 f8 01             	cmp    $0x1,%eax
80103cb1:	0f 9f c0             	setg   %al
  for(i=0; i<NPROC; ++i) {
80103cb4:	31 d2                	xor    %edx,%edx
80103cb6:	89 c6                	mov    %eax,%esi
80103cb8:	b8 c0 6d 11 80       	mov    $0x80116dc0,%eax
80103cbd:	eb 0e                	jmp    80103ccd <select_thread+0x3d>
80103cbf:	90                   	nop
80103cc0:	83 c2 01             	add    $0x1,%edx
80103cc3:	05 c4 00 00 00       	add    $0xc4,%eax
80103cc8:	83 fa 40             	cmp    $0x40,%edx
80103ccb:	74 3b                	je     80103d08 <select_thread+0x78>
	if(i == searched && thd_cnt > 1)
80103ccd:	39 d7                	cmp    %edx,%edi
80103ccf:	75 06                	jne    80103cd7 <select_thread+0x47>
80103cd1:	89 f3                	mov    %esi,%ebx
80103cd3:	84 db                	test   %bl,%bl
80103cd5:	75 e9                	jne    80103cc0 <select_thread+0x30>
	if(!p || p->is_thread == 0 || p->pid != mp->master->pid || p->state != RUNNABLE)
80103cd7:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
80103cdd:	85 db                	test   %ebx,%ebx
80103cdf:	74 df                	je     80103cc0 <select_thread+0x30>
80103ce1:	8b 59 10             	mov    0x10(%ecx),%ebx
80103ce4:	39 58 04             	cmp    %ebx,0x4(%eax)
80103ce7:	75 d7                	jne    80103cc0 <select_thread+0x30>
80103ce9:	83 38 03             	cmpl   $0x3,(%eax)
80103cec:	75 d2                	jne    80103cc0 <select_thread+0x30>
	p = &ptable.proc[i];
80103cee:	69 c2 c4 00 00 00    	imul   $0xc4,%edx,%eax
	mp->master->searched = i;
80103cf4:	89 91 c0 00 00 00    	mov    %edx,0xc0(%ecx)
}
80103cfa:	5b                   	pop    %ebx
80103cfb:	5e                   	pop    %esi
	p = &ptable.proc[i];
80103cfc:	05 b4 6d 11 80       	add    $0x80116db4,%eax
}
80103d01:	5f                   	pop    %edi
80103d02:	5d                   	pop    %ebp
80103d03:	c3                   	ret    
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d08:	5b                   	pop    %ebx
	return 0;
80103d09:	31 c0                	xor    %eax,%eax
}
80103d0b:	5e                   	pop    %esi
80103d0c:	5f                   	pop    %edi
80103d0d:	5d                   	pop    %ebp
80103d0e:	c3                   	ret    
80103d0f:	90                   	nop

80103d10 <scheduler>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d19:	e8 e2 fb ff ff       	call   80103900 <mycpu>
80103d1e:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103d20:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d27:	00 00 00 
80103d2a:	8d 70 04             	lea    0x4(%eax),%esi
80103d2d:	eb 1b                	jmp    80103d4a <scheduler+0x3a>
80103d2f:	90                   	nop
    release(&ptable.lock);
80103d30:	83 ec 0c             	sub    $0xc,%esp
    c->proc = 0;
80103d33:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d3a:	00 00 00 
    release(&ptable.lock);
80103d3d:	68 80 6d 11 80       	push   $0x80116d80
80103d42:	e8 59 11 00 00       	call   80104ea0 <release>
    sti();
80103d47:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103d4a:	fb                   	sti    
    acquire(&ptable.lock);
80103d4b:	83 ec 0c             	sub    $0xc,%esp
80103d4e:	68 80 6d 11 80       	push   $0x80116d80
80103d53:	e8 88 10 00 00       	call   80104de0 <acquire>
    sleep_p = select_and_run(c);
80103d58:	89 1c 24             	mov    %ebx,(%esp)
80103d5b:	e8 d0 4a 00 00       	call   80108830 <select_and_run>
    if(sleep_p && thd_cnt > 0) {
80103d60:	83 c4 10             	add    $0x10,%esp
80103d63:	85 c0                	test   %eax,%eax
80103d65:	74 c9                	je     80103d30 <scheduler+0x20>
80103d67:	8b 3d d8 c6 10 80    	mov    0x8010c6d8,%edi
80103d6d:	85 ff                	test   %edi,%edi
80103d6f:	7e bf                	jle    80103d30 <scheduler+0x20>
	thd = select_thread(sleep_p);
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	50                   	push   %eax
80103d75:	e8 16 ff ff ff       	call   80103c90 <select_thread>
	if(thd) {
80103d7a:	83 c4 10             	add    $0x10,%esp
80103d7d:	85 c0                	test   %eax,%eax
	thd = select_thread(sleep_p);
80103d7f:	89 c7                	mov    %eax,%edi
	if(thd) {
80103d81:	74 ad                	je     80103d30 <scheduler+0x20>
		switchuvm(thd);
80103d83:	83 ec 0c             	sub    $0xc,%esp
		c->proc = thd;
80103d86:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
		switchuvm(thd);
80103d8c:	50                   	push   %eax
80103d8d:	e8 6e 3a 00 00       	call   80107800 <switchuvm>
		thd->state = RUNNING;
80103d92:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
		swtch(&(c->scheduler), thd->context);
80103d99:	58                   	pop    %eax
80103d9a:	5a                   	pop    %edx
80103d9b:	ff 77 1c             	pushl  0x1c(%edi)
80103d9e:	56                   	push   %esi
80103d9f:	e8 a7 13 00 00       	call   8010514b <swtch>
		switchkvm();
80103da4:	e8 37 3a 00 00       	call   801077e0 <switchkvm>
		if(thd->in_mlfq) enqueue_to_mlfq(thd);
80103da9:	8b 8f 88 00 00 00    	mov    0x88(%edi),%ecx
80103daf:	83 c4 10             	add    $0x10,%esp
80103db2:	85 c9                	test   %ecx,%ecx
80103db4:	74 1a                	je     80103dd0 <scheduler+0xc0>
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	57                   	push   %edi
80103dba:	e8 f1 41 00 00       	call   80107fb0 <enqueue_to_mlfq>
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	e9 69 ff ff ff       	jmp    80103d30 <scheduler+0x20>
80103dc7:	89 f6                	mov    %esi,%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		else enqueue_to_sq(thd);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	57                   	push   %edi
80103dd4:	e8 d7 43 00 00       	call   801081b0 <enqueue_to_sq>
80103dd9:	83 c4 10             	add    $0x10,%esp
80103ddc:	e9 4f ff ff ff       	jmp    80103d30 <scheduler+0x20>
80103de1:	eb 0d                	jmp    80103df0 <sched>
80103de3:	90                   	nop
80103de4:	90                   	nop
80103de5:	90                   	nop
80103de6:	90                   	nop
80103de7:	90                   	nop
80103de8:	90                   	nop
80103de9:	90                   	nop
80103dea:	90                   	nop
80103deb:	90                   	nop
80103dec:	90                   	nop
80103ded:	90                   	nop
80103dee:	90                   	nop
80103def:	90                   	nop

80103df0 <sched>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103df9:	e8 12 0f 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103dfe:	e8 fd fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103e03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e09:	e8 42 0f 00 00       	call   80104d50 <popcli>
  if(!holding(&ptable.lock))
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	68 80 6d 11 80       	push   $0x80116d80
80103e16:	e8 95 0f 00 00       	call   80104db0 <holding>
80103e1b:	83 c4 10             	add    $0x10,%esp
80103e1e:	85 c0                	test   %eax,%eax
80103e20:	0f 84 cb 00 00 00    	je     80103ef1 <sched+0x101>
  if(mycpu()->ncli != 1)
80103e26:	e8 d5 fa ff ff       	call   80103900 <mycpu>
80103e2b:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e32:	0f 85 e0 00 00 00    	jne    80103f18 <sched+0x128>
  if(p->state == RUNNING)
80103e38:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e3c:	0f 84 c9 00 00 00    	je     80103f0b <sched+0x11b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e42:	9c                   	pushf  
80103e43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e44:	f6 c4 02             	test   $0x2,%ah
80103e47:	0f 85 b1 00 00 00    	jne    80103efe <sched+0x10e>
  intena = mycpu()->intena;
80103e4d:	e8 ae fa ff ff       	call   80103900 <mycpu>
80103e52:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  if(p->master->used_all_time) {
80103e58:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
80103e5e:	8d 7b 1c             	lea    0x1c(%ebx),%edi
80103e61:	8b 90 bc 00 00 00    	mov    0xbc(%eax),%edx
80103e67:	85 d2                	test   %edx,%edx
80103e69:	75 55                	jne    80103ec0 <sched+0xd0>
	if(p->is_thread) {
80103e6b:	8b 9b 9c 00 00 00    	mov    0x9c(%ebx),%ebx
80103e71:	85 db                	test   %ebx,%ebx
80103e73:	74 55                	je     80103eca <sched+0xda>
		np = thd_cnt > 0 ? select_thread(p->master) : 0;
80103e75:	8b 0d d8 c6 10 80    	mov    0x8010c6d8,%ecx
80103e7b:	85 c9                	test   %ecx,%ecx
80103e7d:	7e 4b                	jle    80103eca <sched+0xda>
80103e7f:	83 ec 0c             	sub    $0xc,%esp
80103e82:	50                   	push   %eax
80103e83:	e8 08 fe ff ff       	call   80103c90 <select_thread>
		if(!np) {
80103e88:	83 c4 10             	add    $0x10,%esp
80103e8b:	85 c0                	test   %eax,%eax
		np = thd_cnt > 0 ? select_thread(p->master) : 0;
80103e8d:	89 c3                	mov    %eax,%ebx
		if(!np) {
80103e8f:	74 39                	je     80103eca <sched+0xda>
			mycpu()->proc = np;
80103e91:	e8 6a fa ff ff       	call   80103900 <mycpu>
			switchuvm(np);
80103e96:	83 ec 0c             	sub    $0xc,%esp
			mycpu()->proc = np;
80103e99:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
			switchuvm(np);
80103e9f:	53                   	push   %ebx
80103ea0:	e8 5b 39 00 00       	call   80107800 <switchuvm>
			np->state = RUNNING;
80103ea5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
			swtch(&p->context, np->context);
80103eac:	58                   	pop    %eax
80103ead:	5a                   	pop    %edx
80103eae:	ff 73 1c             	pushl  0x1c(%ebx)
80103eb1:	57                   	push   %edi
80103eb2:	e8 94 12 00 00       	call   8010514b <swtch>
80103eb7:	83 c4 10             	add    $0x10,%esp
80103eba:	eb 22                	jmp    80103ede <sched+0xee>
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p->master->used_all_time = 0;
80103ec0:	c7 80 bc 00 00 00 00 	movl   $0x0,0xbc(%eax)
80103ec7:	00 00 00 
		swtch(&p->context, mycpu()->scheduler);
80103eca:	e8 31 fa ff ff       	call   80103900 <mycpu>
80103ecf:	83 ec 08             	sub    $0x8,%esp
80103ed2:	ff 70 04             	pushl  0x4(%eax)
80103ed5:	57                   	push   %edi
80103ed6:	e8 70 12 00 00       	call   8010514b <swtch>
80103edb:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ede:	e8 1d fa ff ff       	call   80103900 <mycpu>
80103ee3:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eec:	5b                   	pop    %ebx
80103eed:	5e                   	pop    %esi
80103eee:	5f                   	pop    %edi
80103eef:	5d                   	pop    %ebp
80103ef0:	c3                   	ret    
    panic("sched ptable.lock");
80103ef1:	83 ec 0c             	sub    $0xc,%esp
80103ef4:	68 50 97 10 80       	push   $0x80109750
80103ef9:	e8 92 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	68 7c 97 10 80       	push   $0x8010977c
80103f06:	e8 85 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f0b:	83 ec 0c             	sub    $0xc,%esp
80103f0e:	68 6e 97 10 80       	push   $0x8010976e
80103f13:	e8 78 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f18:	83 ec 0c             	sub    $0xc,%esp
80103f1b:	68 62 97 10 80       	push   $0x80109762
80103f20:	e8 6b c4 ff ff       	call   80100390 <panic>
80103f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f30 <exit>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f39:	e8 d2 0d 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103f3e:	e8 bd f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f43:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f49:	e8 02 0e 00 00       	call   80104d50 <popcli>
  if(curproc == initproc)
80103f4e:	39 35 dc c6 10 80    	cmp    %esi,0x8010c6dc
80103f54:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f57:	8d 7e 68             	lea    0x68(%esi),%edi
80103f5a:	0f 84 01 02 00 00    	je     80104161 <exit+0x231>
    if(curproc->ofile[fd]){
80103f60:	8b 03                	mov    (%ebx),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	74 12                	je     80103f78 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	50                   	push   %eax
80103f6a:	e8 51 d0 ff ff       	call   80100fc0 <fileclose>
      curproc->ofile[fd] = 0;
80103f6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f75:	83 c4 10             	add    $0x10,%esp
80103f78:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f7b:	39 df                	cmp    %ebx,%edi
80103f7d:	75 e1                	jne    80103f60 <exit+0x30>
  begin_op();
80103f7f:	e8 9c ed ff ff       	call   80102d20 <begin_op>
  iput(curproc->cwd);
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	ff 76 68             	pushl  0x68(%esi)
80103f8a:	e8 a1 d9 ff ff       	call   80101930 <iput>
  end_op();
80103f8f:	e8 fc ed ff ff       	call   80102d90 <end_op>
  curproc->cwd = 0;
80103f94:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f9b:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
80103fa2:	e8 39 0e 00 00       	call   80104de0 <acquire>
  if(curproc->is_thread == 0) {
80103fa7:	8b 8e 9c 00 00 00    	mov    0x9c(%esi),%ecx
80103fad:	83 c4 10             	add    $0x10,%esp
80103fb0:	85 c9                	test   %ecx,%ecx
80103fb2:	0f 85 fa 00 00 00    	jne    801040b2 <exit+0x182>
	  for(p=ptable.proc; p<&ptable.proc[NPROC]; ++p) {
80103fb8:	bb b4 6d 11 80       	mov    $0x80116db4,%ebx
80103fbd:	eb 13                	jmp    80103fd2 <exit+0xa2>
80103fbf:	90                   	nop
80103fc0:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80103fc6:	81 fb b4 9e 11 80    	cmp    $0x80119eb4,%ebx
80103fcc:	0f 83 e0 00 00 00    	jae    801040b2 <exit+0x182>
		if(!p || p->is_thread == 0 || p->pid != curproc->pid)
80103fd2:	8b 93 9c 00 00 00    	mov    0x9c(%ebx),%edx
80103fd8:	85 d2                	test   %edx,%edx
80103fda:	74 e4                	je     80103fc0 <exit+0x90>
80103fdc:	8b 46 10             	mov    0x10(%esi),%eax
80103fdf:	39 43 10             	cmp    %eax,0x10(%ebx)
80103fe2:	75 dc                	jne    80103fc0 <exit+0x90>
		deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);
80103fe4:	8b 83 b4 00 00 00    	mov    0xb4(%ebx),%eax
80103fea:	83 ec 04             	sub    $0x4,%esp
80103fed:	50                   	push   %eax
80103fee:	05 00 20 00 00       	add    $0x2000,%eax
80103ff3:	50                   	push   %eax
80103ff4:	ff 73 04             	pushl  0x4(%ebx)
80103ff7:	e8 84 3b 00 00       	call   80107b80 <deallocuvm>
		kfree(p->kstack);
80103ffc:	58                   	pop    %eax
80103ffd:	ff 73 08             	pushl  0x8(%ebx)
80104000:	e8 8b e4 ff ff       	call   80102490 <kfree>
		stack_st[p->stack_id] = 0;
80104005:	8b 83 b8 00 00 00    	mov    0xb8(%ebx),%eax
		--thd_cnt;
8010400b:	83 2d d8 c6 10 80 01 	subl   $0x1,0x8010c6d8
		p->kstack = 0;
80104012:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
		p->sz = 0;
80104019:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		p->state = UNUSED;
8010401f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		p->pid = 0;
80104026:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
		p->parent = 0;
8010402d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
		p->killed = 0;
80104034:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
		p->name[0] = 0;
8010403b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
		p->tickets = 0;
8010403f:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
		p->lev = 0;
80104046:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010404d:	00 00 00 
		p->in_mlfq = 0;
80104050:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104057:	00 00 00 
		stack_st[p->stack_id] = 0;
8010405a:	c7 04 85 80 4f 11 80 	movl   $0x0,-0x7feeb080(,%eax,4)
80104061:	00 00 00 00 
		p->is_thread = 0;
80104065:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010406c:	00 00 00 
		p->tid = 0;
8010406f:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80104076:	00 00 00 
		p->master = 0;
80104079:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104080:	00 00 00 
		p->stack = 0;
80104083:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
8010408a:	00 00 00 
		p->stack_id = 0;
8010408d:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
80104094:	00 00 00 
		p->used_all_time = 0;
80104097:	c7 83 bc 00 00 00 00 	movl   $0x0,0xbc(%ebx)
8010409e:	00 00 00 
		p->ret_val = 0;
801040a1:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
801040a8:	00 00 00 
		p->master->tcnt--;
801040ab:	a1 a4 00 00 00       	mov    0xa4,%eax
801040b0:	0f 0b                	ud2    
  wakeup1(curproc->parent);
801040b2:	8b 56 14             	mov    0x14(%esi),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b5:	b8 b4 6d 11 80       	mov    $0x80116db4,%eax
801040ba:	eb 10                	jmp    801040cc <exit+0x19c>
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c0:	05 c4 00 00 00       	add    $0xc4,%eax
801040c5:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
801040ca:	73 1e                	jae    801040ea <exit+0x1ba>
    if(p->state == SLEEPING && p->chan == chan) {
801040cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040d0:	75 ee                	jne    801040c0 <exit+0x190>
801040d2:	3b 50 20             	cmp    0x20(%eax),%edx
801040d5:	75 e9                	jne    801040c0 <exit+0x190>
      p->state = RUNNABLE;
801040d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040de:	05 c4 00 00 00       	add    $0xc4,%eax
801040e3:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
801040e8:	72 e2                	jb     801040cc <exit+0x19c>
      p->parent = initproc;
801040ea:	8b 0d dc c6 10 80    	mov    0x8010c6dc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f0:	ba b4 6d 11 80       	mov    $0x80116db4,%edx
801040f5:	eb 17                	jmp    8010410e <exit+0x1de>
801040f7:	89 f6                	mov    %esi,%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104100:	81 c2 c4 00 00 00    	add    $0xc4,%edx
80104106:	81 fa b4 9e 11 80    	cmp    $0x80119eb4,%edx
8010410c:	73 3a                	jae    80104148 <exit+0x218>
    if(p->parent == curproc){
8010410e:	39 72 14             	cmp    %esi,0x14(%edx)
80104111:	75 ed                	jne    80104100 <exit+0x1d0>
      if(p->state == ZOMBIE)
80104113:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104117:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010411a:	75 e4                	jne    80104100 <exit+0x1d0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411c:	b8 b4 6d 11 80       	mov    $0x80116db4,%eax
80104121:	eb 11                	jmp    80104134 <exit+0x204>
80104123:	90                   	nop
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104128:	05 c4 00 00 00       	add    $0xc4,%eax
8010412d:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
80104132:	73 cc                	jae    80104100 <exit+0x1d0>
    if(p->state == SLEEPING && p->chan == chan) {
80104134:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104138:	75 ee                	jne    80104128 <exit+0x1f8>
8010413a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010413d:	75 e9                	jne    80104128 <exit+0x1f8>
      p->state = RUNNABLE;
8010413f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104146:	eb e0                	jmp    80104128 <exit+0x1f8>
  curproc->state = ZOMBIE;
80104148:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010414f:	e8 9c fc ff ff       	call   80103df0 <sched>
  panic("zombie exit");
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	68 9d 97 10 80       	push   $0x8010979d
8010415c:	e8 2f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104161:	83 ec 0c             	sub    $0xc,%esp
80104164:	68 90 97 10 80       	push   $0x80109790
80104169:	e8 22 c2 ff ff       	call   80100390 <panic>
8010416e:	66 90                	xchg   %ax,%ax

80104170 <yield>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104177:	68 80 6d 11 80       	push   $0x80116d80
8010417c:	e8 5f 0c 00 00       	call   80104de0 <acquire>
  pushcli();
80104181:	e8 8a 0b 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80104186:	e8 75 f7 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010418b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104191:	e8 ba 0b 00 00       	call   80104d50 <popcli>
  myproc()->state = RUNNABLE;
80104196:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010419d:	e8 4e fc ff ff       	call   80103df0 <sched>
  release(&ptable.lock);
801041a2:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
801041a9:	e8 f2 0c 00 00       	call   80104ea0 <release>
}
801041ae:	83 c4 10             	add    $0x10,%esp
801041b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b4:	c9                   	leave  
801041b5:	c3                   	ret    
801041b6:	8d 76 00             	lea    0x0(%esi),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041c0 <sleep>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	57                   	push   %edi
801041c4:	56                   	push   %esi
801041c5:	53                   	push   %ebx
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041cf:	e8 3c 0b 00 00       	call   80104d10 <pushcli>
  c = mycpu();
801041d4:	e8 27 f7 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801041d9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041df:	e8 6c 0b 00 00       	call   80104d50 <popcli>
  if(p == 0)
801041e4:	85 db                	test   %ebx,%ebx
801041e6:	0f 84 87 00 00 00    	je     80104273 <sleep+0xb3>
  if(lk == 0)
801041ec:	85 f6                	test   %esi,%esi
801041ee:	74 76                	je     80104266 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041f0:	81 fe 80 6d 11 80    	cmp    $0x80116d80,%esi
801041f6:	74 50                	je     80104248 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 80 6d 11 80       	push   $0x80116d80
80104200:	e8 db 0b 00 00       	call   80104de0 <acquire>
    release(lk);
80104205:	89 34 24             	mov    %esi,(%esp)
80104208:	e8 93 0c 00 00       	call   80104ea0 <release>
  p->chan = chan;
8010420d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104210:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104217:	e8 d4 fb ff ff       	call   80103df0 <sched>
  p->chan = 0;
8010421c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104223:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
8010422a:	e8 71 0c 00 00       	call   80104ea0 <release>
    acquire(lk);
8010422f:	89 75 08             	mov    %esi,0x8(%ebp)
80104232:	83 c4 10             	add    $0x10,%esp
}
80104235:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104238:	5b                   	pop    %ebx
80104239:	5e                   	pop    %esi
8010423a:	5f                   	pop    %edi
8010423b:	5d                   	pop    %ebp
    acquire(lk);
8010423c:	e9 9f 0b 00 00       	jmp    80104de0 <acquire>
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104248:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010424b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104252:	e8 99 fb ff ff       	call   80103df0 <sched>
  p->chan = 0;
80104257:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010425e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104261:	5b                   	pop    %ebx
80104262:	5e                   	pop    %esi
80104263:	5f                   	pop    %edi
80104264:	5d                   	pop    %ebp
80104265:	c3                   	ret    
    panic("sleep without lk");
80104266:	83 ec 0c             	sub    $0xc,%esp
80104269:	68 af 97 10 80       	push   $0x801097af
8010426e:	e8 1d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104273:	83 ec 0c             	sub    $0xc,%esp
80104276:	68 a9 97 10 80       	push   $0x801097a9
8010427b:	e8 10 c1 ff ff       	call   80100390 <panic>

80104280 <xem_wait>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 10             	sub    $0x10,%esp
80104287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&semaphore->lock);
8010428a:	53                   	push   %ebx
8010428b:	e8 50 0b 00 00       	call   80104de0 <acquire>
  semaphore->value--;
80104290:	8b 43 34             	mov    0x34(%ebx),%eax
  while(semaphore->value < 0)
80104293:	83 c4 10             	add    $0x10,%esp
  semaphore->value--;
80104296:	83 e8 01             	sub    $0x1,%eax
  while(semaphore->value < 0)
80104299:	85 c0                	test   %eax,%eax
  semaphore->value--;
8010429b:	89 43 34             	mov    %eax,0x34(%ebx)
  while(semaphore->value < 0)
8010429e:	79 14                	jns    801042b4 <xem_wait+0x34>
	sleep((void *)semaphore, &semaphore->lock);
801042a0:	83 ec 08             	sub    $0x8,%esp
801042a3:	53                   	push   %ebx
801042a4:	53                   	push   %ebx
801042a5:	e8 16 ff ff ff       	call   801041c0 <sleep>
  while(semaphore->value < 0)
801042aa:	8b 43 34             	mov    0x34(%ebx),%eax
801042ad:	83 c4 10             	add    $0x10,%esp
801042b0:	85 c0                	test   %eax,%eax
801042b2:	78 ec                	js     801042a0 <xem_wait+0x20>
  release(&semaphore->lock);
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	53                   	push   %ebx
801042b8:	e8 e3 0b 00 00       	call   80104ea0 <release>
}
801042bd:	31 c0                	xor    %eax,%eax
801042bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c2:	c9                   	leave  
801042c3:	c3                   	ret    
801042c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801042d0 <rwlock_acquire_writelock>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	83 ec 14             	sub    $0x14,%esp
  xem_wait(&rwlock->writelock);
801042d6:	8b 45 08             	mov    0x8(%ebp),%eax
801042d9:	83 c0 38             	add    $0x38,%eax
801042dc:	50                   	push   %eax
801042dd:	e8 9e ff ff ff       	call   80104280 <xem_wait>
}
801042e2:	31 c0                	xor    %eax,%eax
801042e4:	c9                   	leave  
801042e5:	c3                   	ret    
801042e6:	8d 76 00             	lea    0x0(%esi),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042f0 <wait>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
  pushcli();
801042f5:	e8 16 0a 00 00       	call   80104d10 <pushcli>
  c = mycpu();
801042fa:	e8 01 f6 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801042ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104305:	e8 46 0a 00 00       	call   80104d50 <popcli>
  acquire(&ptable.lock);
8010430a:	83 ec 0c             	sub    $0xc,%esp
8010430d:	68 80 6d 11 80       	push   $0x80116d80
80104312:	e8 c9 0a 00 00       	call   80104de0 <acquire>
80104317:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010431a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010431c:	bb b4 6d 11 80       	mov    $0x80116db4,%ebx
80104321:	eb 13                	jmp    80104336 <wait+0x46>
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104328:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
8010432e:	81 fb b4 9e 11 80    	cmp    $0x80119eb4,%ebx
80104334:	73 1e                	jae    80104354 <wait+0x64>
      if(p->parent != curproc)
80104336:	39 73 14             	cmp    %esi,0x14(%ebx)
80104339:	75 ed                	jne    80104328 <wait+0x38>
      if(p->state == ZOMBIE){
8010433b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010433f:	74 37                	je     80104378 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104341:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
      havekids = 1;
80104347:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010434c:	81 fb b4 9e 11 80    	cmp    $0x80119eb4,%ebx
80104352:	72 e2                	jb     80104336 <wait+0x46>
    if(!havekids || curproc->killed){
80104354:	85 c0                	test   %eax,%eax
80104356:	74 76                	je     801043ce <wait+0xde>
80104358:	8b 46 24             	mov    0x24(%esi),%eax
8010435b:	85 c0                	test   %eax,%eax
8010435d:	75 6f                	jne    801043ce <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010435f:	83 ec 08             	sub    $0x8,%esp
80104362:	68 80 6d 11 80       	push   $0x80116d80
80104367:	56                   	push   %esi
80104368:	e8 53 fe ff ff       	call   801041c0 <sleep>
    havekids = 0;
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	eb a8                	jmp    8010431a <wait+0x2a>
80104372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010437e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104381:	e8 0a e1 ff ff       	call   80102490 <kfree>
        freevm(p->pgdir);
80104386:	5a                   	pop    %edx
80104387:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010438a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104391:	e8 1a 38 00 00       	call   80107bb0 <freevm>
        release(&ptable.lock);
80104396:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
        p->pid = 0;
8010439d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043a4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043ab:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043af:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043b6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801043bd:	e8 de 0a 00 00       	call   80104ea0 <release>
        return pid;
801043c2:	83 c4 10             	add    $0x10,%esp
}
801043c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c8:	89 f0                	mov    %esi,%eax
801043ca:	5b                   	pop    %ebx
801043cb:	5e                   	pop    %esi
801043cc:	5d                   	pop    %ebp
801043cd:	c3                   	ret    
      release(&ptable.lock);
801043ce:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801043d1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801043d6:	68 80 6d 11 80       	push   $0x80116d80
801043db:	e8 c0 0a 00 00       	call   80104ea0 <release>
      return -1;
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	eb e0                	jmp    801043c5 <wait+0xd5>
801043e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 10             	sub    $0x10,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043fa:	68 80 6d 11 80       	push   $0x80116d80
801043ff:	e8 dc 09 00 00       	call   80104de0 <acquire>
80104404:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104407:	b8 b4 6d 11 80       	mov    $0x80116db4,%eax
8010440c:	eb 0e                	jmp    8010441c <wakeup+0x2c>
8010440e:	66 90                	xchg   %ax,%ax
80104410:	05 c4 00 00 00       	add    $0xc4,%eax
80104415:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
8010441a:	73 1e                	jae    8010443a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan) {
8010441c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104420:	75 ee                	jne    80104410 <wakeup+0x20>
80104422:	3b 58 20             	cmp    0x20(%eax),%ebx
80104425:	75 e9                	jne    80104410 <wakeup+0x20>
      p->state = RUNNABLE;
80104427:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442e:	05 c4 00 00 00       	add    $0xc4,%eax
80104433:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
80104438:	72 e2                	jb     8010441c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010443a:	c7 45 08 80 6d 11 80 	movl   $0x80116d80,0x8(%ebp)
}
80104441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104444:	c9                   	leave  
  release(&ptable.lock);
80104445:	e9 56 0a 00 00       	jmp    80104ea0 <release>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <xem_unlock>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&semaphore->lock);
8010445a:	53                   	push   %ebx
8010445b:	e8 80 09 00 00       	call   80104de0 <acquire>
  semaphore->value++;
80104460:	8b 43 34             	mov    0x34(%ebx),%eax
  if(semaphore->value <= 0)
80104463:	83 c4 10             	add    $0x10,%esp
  semaphore->value++;
80104466:	83 c0 01             	add    $0x1,%eax
  if(semaphore->value <= 0)
80104469:	85 c0                	test   %eax,%eax
  semaphore->value++;
8010446b:	89 43 34             	mov    %eax,0x34(%ebx)
  if(semaphore->value <= 0)
8010446e:	7e 10                	jle    80104480 <xem_unlock+0x30>
  release(&semaphore->lock);
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	53                   	push   %ebx
80104474:	e8 27 0a 00 00       	call   80104ea0 <release>
}
80104479:	31 c0                	xor    %eax,%eax
8010447b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447e:	c9                   	leave  
8010447f:	c3                   	ret    
	wakeup((void *)semaphore);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	53                   	push   %ebx
80104484:	e8 67 ff ff ff       	call   801043f0 <wakeup>
80104489:	83 c4 10             	add    $0x10,%esp
  release(&semaphore->lock);
8010448c:	83 ec 0c             	sub    $0xc,%esp
8010448f:	53                   	push   %ebx
80104490:	e8 0b 0a 00 00       	call   80104ea0 <release>
}
80104495:	31 c0                	xor    %eax,%eax
80104497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010449a:	c9                   	leave  
8010449b:	c3                   	ret    
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <rwlock_acquire_readlock>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 10             	sub    $0x10,%esp
801044a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  xem_wait(&rwlock->lock);
801044aa:	53                   	push   %ebx
801044ab:	e8 d0 fd ff ff       	call   80104280 <xem_wait>
  rwlock->readers++;
801044b0:	8b 43 70             	mov    0x70(%ebx),%eax
  if(rwlock->readers == 1)
801044b3:	83 c4 10             	add    $0x10,%esp
  rwlock->readers++;
801044b6:	83 c0 01             	add    $0x1,%eax
  if(rwlock->readers == 1)
801044b9:	83 f8 01             	cmp    $0x1,%eax
  rwlock->readers++;
801044bc:	89 43 70             	mov    %eax,0x70(%ebx)
  if(rwlock->readers == 1)
801044bf:	74 17                	je     801044d8 <rwlock_acquire_readlock+0x38>
  xem_unlock(&rwlock->lock);
801044c1:	83 ec 0c             	sub    $0xc,%esp
801044c4:	53                   	push   %ebx
801044c5:	e8 86 ff ff ff       	call   80104450 <xem_unlock>
}
801044ca:	31 c0                	xor    %eax,%eax
801044cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044cf:	c9                   	leave  
801044d0:	c3                   	ret    
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	xem_wait(&rwlock->writelock);
801044d8:	8d 43 38             	lea    0x38(%ebx),%eax
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	50                   	push   %eax
801044df:	e8 9c fd ff ff       	call   80104280 <xem_wait>
801044e4:	83 c4 10             	add    $0x10,%esp
  xem_unlock(&rwlock->lock);
801044e7:	83 ec 0c             	sub    $0xc,%esp
801044ea:	53                   	push   %ebx
801044eb:	e8 60 ff ff ff       	call   80104450 <xem_unlock>
}
801044f0:	31 c0                	xor    %eax,%eax
801044f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f5:	c9                   	leave  
801044f6:	c3                   	ret    
801044f7:	89 f6                	mov    %esi,%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <rwlock_release_readlock>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 10             	sub    $0x10,%esp
80104507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  xem_wait(&rwlock->lock);
8010450a:	53                   	push   %ebx
8010450b:	e8 70 fd ff ff       	call   80104280 <xem_wait>
  rwlock->readers--;
80104510:	8b 43 70             	mov    0x70(%ebx),%eax
  if(rwlock->readers == 0)
80104513:	83 c4 10             	add    $0x10,%esp
  rwlock->readers--;
80104516:	83 e8 01             	sub    $0x1,%eax
  if(rwlock->readers == 0)
80104519:	85 c0                	test   %eax,%eax
  rwlock->readers--;
8010451b:	89 43 70             	mov    %eax,0x70(%ebx)
  if(rwlock->readers == 0)
8010451e:	75 0f                	jne    8010452f <rwlock_release_readlock+0x2f>
	xem_unlock(&rwlock->writelock);
80104520:	8d 43 38             	lea    0x38(%ebx),%eax
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	50                   	push   %eax
80104527:	e8 24 ff ff ff       	call   80104450 <xem_unlock>
8010452c:	83 c4 10             	add    $0x10,%esp
  xem_unlock(&rwlock->lock);
8010452f:	83 ec 0c             	sub    $0xc,%esp
80104532:	53                   	push   %ebx
80104533:	e8 18 ff ff ff       	call   80104450 <xem_unlock>
}
80104538:	31 c0                	xor    %eax,%eax
8010453a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010453d:	c9                   	leave  
8010453e:	c3                   	ret    
8010453f:	90                   	nop

80104540 <rwlock_release_writelock>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	83 ec 14             	sub    $0x14,%esp
  xem_unlock(&rwlock->writelock);
80104546:	8b 45 08             	mov    0x8(%ebp),%eax
80104549:	83 c0 38             	add    $0x38,%eax
8010454c:	50                   	push   %eax
8010454d:	e8 fe fe ff ff       	call   80104450 <xem_unlock>
}
80104552:	31 c0                	xor    %eax,%eax
80104554:	c9                   	leave  
80104555:	c3                   	ret    
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 10             	sub    $0x10,%esp
80104567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010456a:	68 80 6d 11 80       	push   $0x80116d80
8010456f:	e8 6c 08 00 00       	call   80104de0 <acquire>
80104574:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104577:	b8 b4 6d 11 80       	mov    $0x80116db4,%eax
8010457c:	eb 0e                	jmp    8010458c <kill+0x2c>
8010457e:	66 90                	xchg   %ax,%ax
80104580:	05 c4 00 00 00       	add    $0xc4,%eax
80104585:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
8010458a:	73 34                	jae    801045c0 <kill+0x60>
    // The threads have same pid which master process has
    // So the threads are killed in here
    if(p->pid == pid){
8010458c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010458f:	75 ef                	jne    80104580 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104591:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104595:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010459c:	75 07                	jne    801045a5 <kill+0x45>
        p->state = RUNNABLE;
8010459e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801045a5:	83 ec 0c             	sub    $0xc,%esp
801045a8:	68 80 6d 11 80       	push   $0x80116d80
801045ad:	e8 ee 08 00 00       	call   80104ea0 <release>
      return 0;
801045b2:	83 c4 10             	add    $0x10,%esp
801045b5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);

  return -1;
}
801045b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045ba:	c9                   	leave  
801045bb:	c3                   	ret    
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801045c0:	83 ec 0c             	sub    $0xc,%esp
801045c3:	68 80 6d 11 80       	push   $0x80116d80
801045c8:	e8 d3 08 00 00       	call   80104ea0 <release>
  return -1;
801045cd:	83 c4 10             	add    $0x10,%esp
801045d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d8:	c9                   	leave  
801045d9:	c3                   	ret    
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e9:	bb b4 6d 11 80       	mov    $0x80116db4,%ebx
{
801045ee:	83 ec 3c             	sub    $0x3c,%esp
801045f1:	eb 27                	jmp    8010461a <procdump+0x3a>
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 ff 9b 10 80       	push   $0x80109bff
80104600:	e8 5b c0 ff ff       	call   80100660 <cprintf>
80104605:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104608:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
8010460e:	81 fb b4 9e 11 80    	cmp    $0x80119eb4,%ebx
80104614:	0f 83 86 00 00 00    	jae    801046a0 <procdump+0xc0>
    if(p->state == UNUSED)
8010461a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010461d:	85 c0                	test   %eax,%eax
8010461f:	74 e7                	je     80104608 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104621:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104624:	ba c0 97 10 80       	mov    $0x801097c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104629:	77 11                	ja     8010463c <procdump+0x5c>
8010462b:	8b 14 85 74 98 10 80 	mov    -0x7fef678c(,%eax,4),%edx
      state = "???";
80104632:	b8 c0 97 10 80       	mov    $0x801097c0,%eax
80104637:	85 d2                	test   %edx,%edx
80104639:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010463c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010463f:	50                   	push   %eax
80104640:	52                   	push   %edx
80104641:	ff 73 10             	pushl  0x10(%ebx)
80104644:	68 c4 97 10 80       	push   $0x801097c4
80104649:	e8 12 c0 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010464e:	83 c4 10             	add    $0x10,%esp
80104651:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104655:	75 a1                	jne    801045f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104657:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010465a:	83 ec 08             	sub    $0x8,%esp
8010465d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104660:	50                   	push   %eax
80104661:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104664:	8b 40 0c             	mov    0xc(%eax),%eax
80104667:	83 c0 08             	add    $0x8,%eax
8010466a:	50                   	push   %eax
8010466b:	e8 50 06 00 00       	call   80104cc0 <getcallerpcs>
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	90                   	nop
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104678:	8b 17                	mov    (%edi),%edx
8010467a:	85 d2                	test   %edx,%edx
8010467c:	0f 84 76 ff ff ff    	je     801045f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104682:	83 ec 08             	sub    $0x8,%esp
80104685:	83 c7 04             	add    $0x4,%edi
80104688:	52                   	push   %edx
80104689:	68 01 92 10 80       	push   $0x80109201
8010468e:	e8 cd bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104693:	83 c4 10             	add    $0x10,%esp
80104696:	39 fe                	cmp    %edi,%esi
80104698:	75 de                	jne    80104678 <procdump+0x98>
8010469a:	e9 59 ff ff ff       	jmp    801045f8 <procdump+0x18>
8010469f:	90                   	nop
  }
}
801046a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046a3:	5b                   	pop    %ebx
801046a4:	5e                   	pop    %esi
801046a5:	5f                   	pop    %edi
801046a6:	5d                   	pop    %ebp
801046a7:	c3                   	ret    
801046a8:	90                   	nop
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <thread_create>:

int
thread_create(thread_t *thread, void *(*start_routine)(void*), void *arg)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	53                   	push   %ebx
801046b6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
801046b9:	e8 52 06 00 00       	call   80104d10 <pushcli>
  c = mycpu();
801046be:	e8 3d f2 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801046c3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801046c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  popcli();
801046cc:	e8 7f 06 00 00       	call   80104d50 <popcli>
  struct proc *curproc = myproc();
  struct proc *np;
  uint sp, ustack[2];
  int i, sidx = -1;

  if((np = allocproc()) == 0) {
801046d1:	e8 aa f0 ff ff       	call   80103780 <allocproc>
801046d6:	85 c0                	test   %eax,%eax
801046d8:	0f 84 0c 02 00 00    	je     801048ea <thread_create+0x23a>
	return -1;
  }

  acquire(&ptable.lock);
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	89 c3                	mov    %eax,%ebx
801046e3:	68 80 6d 11 80       	push   $0x80116d80
801046e8:	e8 f3 06 00 00       	call   80104de0 <acquire>
801046ed:	83 c4 10             	add    $0x10,%esp

  for(i=0; i<NPROC*30; i++) {
801046f0:	31 d2                	xor    %edx,%edx
	if(stack_st[i])
801046f2:	8b 0c 95 80 4f 11 80 	mov    -0x7feeb080(,%edx,4),%ecx
801046f9:	8d 42 01             	lea    0x1(%edx),%eax
801046fc:	85 c9                	test   %ecx,%ecx
801046fe:	0f 85 cc 01 00 00    	jne    801048d0 <thread_create+0x220>

  if(sidx == -1)
	panic("cannot allocate stack");

  np->stack_id = sidx++;
  np->stack = curproc->master->sz + (uint)(2*PGSIZE * sidx);
80104704:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	stack_st[i] = 1;
80104707:	c7 04 95 80 4f 11 80 	movl   $0x1,-0x7feeb080(,%edx,4)
8010470e:	01 00 00 00 
  np->stack = curproc->master->sz + (uint)(2*PGSIZE * sidx);
80104712:	c1 e0 0d             	shl    $0xd,%eax
  np->stack_id = sidx++;
80104715:	89 93 b8 00 00 00    	mov    %edx,0xb8(%ebx)
8010471b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  np->pid = curproc->master->pid;
  np->tid = nextthd++;
  np->is_thread = 1;
  np->master = curproc->master;
  np->pgdir = curproc->master->pgdir;
  *np->tf = *curproc->master->tf;
8010471e:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->cwd = curproc->master->cwd;  

  *thread = np->tid;

  if((np->sz = allocuvm(np->pgdir, np->stack, np->stack + 2*PGSIZE)) == 0) {
80104723:	83 ec 04             	sub    $0x4,%esp
  np->stack = curproc->master->sz + (uint)(2*PGSIZE * sidx);
80104726:	8b 97 ac 00 00 00    	mov    0xac(%edi),%edx
8010472c:	03 02                	add    (%edx),%eax
8010472e:	89 83 b4 00 00 00    	mov    %eax,0xb4(%ebx)
  np->tickets = curproc->master->tickets;
80104734:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
8010473a:	8b 40 7c             	mov    0x7c(%eax),%eax
  np->lev = 0;
8010473d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104744:	00 00 00 
  np->tickets = curproc->master->tickets;
80104747:	89 43 7c             	mov    %eax,0x7c(%ebx)
  np->in_mlfq = curproc->master->in_mlfq;
8010474a:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
80104750:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104756:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  np->pid = curproc->master->pid;
8010475c:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
80104762:	8b 40 10             	mov    0x10(%eax),%eax
  np->is_thread = 1;
80104765:	c7 83 9c 00 00 00 01 	movl   $0x1,0x9c(%ebx)
8010476c:	00 00 00 
  np->pid = curproc->master->pid;
8010476f:	89 43 10             	mov    %eax,0x10(%ebx)
  np->tid = nextthd++;
80104772:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104777:	89 83 a0 00 00 00    	mov    %eax,0xa0(%ebx)
8010477d:	8d 50 01             	lea    0x1(%eax),%edx
  np->master = curproc->master;
80104780:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
  np->tid = nextthd++;
80104786:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  np->master = curproc->master;
8010478c:	89 fa                	mov    %edi,%edx
8010478e:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
  np->pgdir = curproc->master->pgdir;
80104794:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
8010479a:	8b 40 04             	mov    0x4(%eax),%eax
8010479d:	89 43 04             	mov    %eax,0x4(%ebx)
  *np->tf = *curproc->master->tf;
801047a0:	8b 87 ac 00 00 00    	mov    0xac(%edi),%eax
801047a6:	8b 7b 18             	mov    0x18(%ebx),%edi
801047a9:	8b 70 18             	mov    0x18(%eax),%esi
801047ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->cwd = curproc->master->cwd;  
801047ae:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801047b4:	8b 40 68             	mov    0x68(%eax),%eax
  *thread = np->tid;
801047b7:	8b 93 a0 00 00 00    	mov    0xa0(%ebx),%edx
  np->cwd = curproc->master->cwd;  
801047bd:	89 43 68             	mov    %eax,0x68(%ebx)
  *thread = np->tid;
801047c0:	8b 45 08             	mov    0x8(%ebp),%eax
801047c3:	89 10                	mov    %edx,(%eax)
  if((np->sz = allocuvm(np->pgdir, np->stack, np->stack + 2*PGSIZE)) == 0) {
801047c5:	8b 83 b4 00 00 00    	mov    0xb4(%ebx),%eax
801047cb:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
801047d1:	52                   	push   %edx
801047d2:	50                   	push   %eax
801047d3:	ff 73 04             	pushl  0x4(%ebx)
801047d6:	e8 75 32 00 00       	call   80107a50 <allocuvm>
801047db:	83 c4 10             	add    $0x10,%esp
801047de:	85 c0                	test   %eax,%eax
801047e0:	89 03                	mov    %eax,(%ebx)
801047e2:	0f 84 18 01 00 00    	je     80104900 <thread_create+0x250>
	panic("cannot allocate ustack");
	np->state = UNUSED;
	return -1;
  }

  clearpteu(np->pgdir, (char*)(np->master->sz - 2*PGSIZE));
801047e8:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
801047ee:	83 ec 08             	sub    $0x8,%esp
801047f1:	8b 00                	mov    (%eax),%eax
801047f3:	2d 00 20 00 00       	sub    $0x2000,%eax
801047f8:	50                   	push   %eax
801047f9:	ff 73 04             	pushl  0x4(%ebx)
801047fc:	e8 cf 34 00 00       	call   80107cd0 <clearpteu>

  sp = np->sz;
  sp -= 8;
80104801:	8b 03                	mov    (%ebx),%eax
  ustack[0] = 0xffffffff;
  ustack[1] = (uint)arg;
  
  if(copyout(np->pgdir, sp, ustack, 8) < 0) {
80104803:	6a 08                	push   $0x8
  ustack[0] = 0xffffffff;
80104805:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  sp -= 8;
8010480c:	8d 70 f8             	lea    -0x8(%eax),%esi
  ustack[1] = (uint)arg;
8010480f:	8b 45 10             	mov    0x10(%ebp),%eax
80104812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(copyout(np->pgdir, sp, ustack, 8) < 0) {
80104815:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104818:	50                   	push   %eax
80104819:	56                   	push   %esi
8010481a:	ff 73 04             	pushl  0x4(%ebx)
8010481d:	e8 0e 36 00 00       	call   80107e30 <copyout>
80104822:	83 c4 20             	add    $0x20,%esp
80104825:	85 c0                	test   %eax,%eax
80104827:	0f 88 c6 00 00 00    	js     801048f3 <thread_create+0x243>
	panic("cannot copy ustack");
	return -1;
  }

  np->tf->eip = (uint)start_routine;
8010482d:	8b 43 18             	mov    0x18(%ebx),%eax
80104830:	8b 55 0c             	mov    0xc(%ebp),%edx
80104833:	89 50 38             	mov    %edx,0x38(%eax)
  np->tf->esp = sp;
80104836:	8b 43 18             	mov    0x18(%ebx),%eax
80104839:	89 70 44             	mov    %esi,0x44(%eax)
8010483c:	8b 93 ac 00 00 00    	mov    0xac(%ebx),%edx

  for(i=0; i<NOFILE; i++)
80104842:	31 f6                	xor    %esi,%esi
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(np->master->ofile[i])
80104848:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
8010484c:	85 c0                	test   %eax,%eax
8010484e:	74 16                	je     80104866 <thread_create+0x1b6>
		np->ofile[i] = filedup(np->master->ofile[i]);
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	50                   	push   %eax
80104854:	e8 17 c7 ff ff       	call   80100f70 <filedup>
80104859:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
8010485d:	8b 93 ac 00 00 00    	mov    0xac(%ebx),%edx
80104863:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<NOFILE; i++)
80104866:	83 c6 01             	add    $0x1,%esi
80104869:	83 fe 10             	cmp    $0x10,%esi
8010486c:	75 da                	jne    80104848 <thread_create+0x198>

  safestrcpy(np->name, np->master->name, sizeof(np->master->name));
8010486e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104871:	83 ec 04             	sub    $0x4,%esp
80104874:	83 c2 6c             	add    $0x6c,%edx
80104877:	6a 10                	push   $0x10
80104879:	52                   	push   %edx
8010487a:	50                   	push   %eax
8010487b:	e8 70 08 00 00       	call   801050f0 <safestrcpy>
  
  np->state = RUNNABLE;
  thd_cnt++;
  curproc->master->tcnt++;
80104880:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  np->state = RUNNABLE;
80104883:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  thd_cnt++;
8010488a:	83 05 d8 c6 10 80 01 	addl   $0x1,0x8010c6d8
  curproc->master->tcnt++;
80104891:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104897:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
  curproc->master->made_thd = 1;
8010489e:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801048a4:	c7 80 a8 00 00 00 01 	movl   $0x1,0xa8(%eax)
801048ab:	00 00 00 

  release(&ptable.lock);
801048ae:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
801048b5:	e8 e6 05 00 00       	call   80104ea0 <release>

  return 0;
801048ba:	83 c4 10             	add    $0x10,%esp
}
801048bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
801048c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c3:	5b                   	pop    %ebx
801048c4:	5e                   	pop    %esi
801048c5:	5f                   	pop    %edi
801048c6:	5d                   	pop    %ebp
801048c7:	c3                   	ret    
801048c8:	90                   	nop
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<NPROC*30; i++) {
801048d0:	3d 80 07 00 00       	cmp    $0x780,%eax
801048d5:	89 c2                	mov    %eax,%edx
801048d7:	0f 85 15 fe ff ff    	jne    801046f2 <thread_create+0x42>
	panic("cannot allocate stack");
801048dd:	83 ec 0c             	sub    $0xc,%esp
801048e0:	68 f7 97 10 80       	push   $0x801097f7
801048e5:	e8 a6 ba ff ff       	call   80100390 <panic>
	return -1;
801048ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
801048f1:	eb ca                	jmp    801048bd <thread_create+0x20d>
	panic("cannot copy ustack");
801048f3:	83 ec 0c             	sub    $0xc,%esp
801048f6:	68 e4 97 10 80       	push   $0x801097e4
801048fb:	e8 90 ba ff ff       	call   80100390 <panic>
	panic("cannot allocate ustack");
80104900:	83 ec 0c             	sub    $0xc,%esp
80104903:	68 cd 97 10 80       	push   $0x801097cd
80104908:	e8 83 ba ff ff       	call   80100390 <panic>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <thread_exit>:

void
thread_exit(void *retval)
{
  if(thd_cnt <= 0) return;
80104910:	a1 d8 c6 10 80       	mov    0x8010c6d8,%eax
80104915:	85 c0                	test   %eax,%eax
80104917:	7f 02                	jg     8010491b <thread_exit+0xb>
80104919:	f3 c3                	repz ret 
{
8010491b:	55                   	push   %ebp
8010491c:	89 e5                	mov    %esp,%ebp
8010491e:	53                   	push   %ebx
8010491f:	83 ec 10             	sub    $0x10,%esp

  acquire(&ptable.lock);
80104922:	68 80 6d 11 80       	push   $0x80116d80
80104927:	e8 b4 04 00 00       	call   80104de0 <acquire>
  pushcli();
8010492c:	e8 df 03 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80104931:	e8 ca ef ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104936:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010493c:	e8 0f 04 00 00       	call   80104d50 <popcli>
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	8d 43 28             	lea    0x28(%ebx),%eax
80104947:	8d 53 68             	lea    0x68(%ebx),%edx

  struct proc *curproc = myproc();
  int fd;

  for(fd=0; fd<NOFILE; fd++)
	if(curproc->ofile[fd])
8010494a:	8b 08                	mov    (%eax),%ecx
8010494c:	85 c9                	test   %ecx,%ecx
8010494e:	74 06                	je     80104956 <thread_exit+0x46>
		curproc->ofile[fd] = 0;
80104950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104956:	83 c0 04             	add    $0x4,%eax
  for(fd=0; fd<NOFILE; fd++)
80104959:	39 c2                	cmp    %eax,%edx
8010495b:	75 ed                	jne    8010494a <thread_exit+0x3a>

  curproc->cwd = 0;
8010495d:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  // wake up sleeping thread in thread_join()
  wakeup1(curproc->master);
80104964:	8b 93 ac 00 00 00    	mov    0xac(%ebx),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010496a:	b8 b4 6d 11 80       	mov    $0x80116db4,%eax
8010496f:	eb 13                	jmp    80104984 <thread_exit+0x74>
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104978:	05 c4 00 00 00       	add    $0xc4,%eax
8010497d:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
80104982:	73 14                	jae    80104998 <thread_exit+0x88>
    if(p->state == SLEEPING && p->chan == chan) {
80104984:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104988:	75 ee                	jne    80104978 <thread_exit+0x68>
8010498a:	3b 50 20             	cmp    0x20(%eax),%edx
8010498d:	75 e9                	jne    80104978 <thread_exit+0x68>
      p->state = RUNNABLE;
8010498f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104996:	eb e0                	jmp    80104978 <thread_exit+0x68>

  curproc->state = ZOMBIE;
  curproc->ret_val = retval;
80104998:	8b 45 08             	mov    0x8(%ebp),%eax
  curproc->state = ZOMBIE;
8010499b:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->master->tcnt--;
  thd_cnt--;
801049a2:	83 2d d8 c6 10 80 01 	subl   $0x1,0x8010c6d8
  curproc->ret_val = retval;
801049a9:	89 83 b0 00 00 00    	mov    %eax,0xb0(%ebx)
  curproc->master->tcnt--;
801049af:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
801049b5:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)

  sched();
801049bc:	e8 2f f4 ff ff       	call   80103df0 <sched>

  panic("exit ZOMBIE thread");
801049c1:	83 ec 0c             	sub    $0xc,%esp
801049c4:	68 0d 98 10 80       	push   $0x8010980d
801049c9:	e8 c2 b9 ff ff       	call   80100390 <panic>
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <thread_join>:
}

int
thread_join(thread_t thread, void **retval)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	83 ec 0c             	sub    $0xc,%esp
801049d9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801049dc:	e8 2f 03 00 00       	call   80104d10 <pushcli>
  c = mycpu();
801049e1:	e8 1a ef ff ff       	call   80103900 <mycpu>
  p = c->proc;
801049e6:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801049ec:	e8 5f 03 00 00       	call   80104d50 <popcli>
  struct proc *curproc = myproc();
  struct proc *p;

  if(curproc->master != curproc)
801049f1:	39 bf ac 00 00 00    	cmp    %edi,0xac(%edi)
801049f7:	0f 85 50 01 00 00    	jne    80104b4d <thread_join+0x17d>
	return -1;

  acquire(&ptable.lock);
801049fd:	83 ec 0c             	sub    $0xc,%esp
80104a00:	68 80 6d 11 80       	push   $0x80116d80
80104a05:	e8 d6 03 00 00       	call   80104de0 <acquire>
80104a0a:	83 c4 10             	add    $0x10,%esp

  for(;;) {
	 // find expected thread
	 for(p=ptable.proc; p<&ptable.proc[NPROC]; p++) {
80104a0d:	bb b4 6d 11 80       	mov    $0x80116db4,%ebx
80104a12:	eb 16                	jmp    80104a2a <thread_join+0x5a>
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a18:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80104a1e:	81 fb b4 9e 11 80    	cmp    $0x80119eb4,%ebx
80104a24:	0f 83 06 01 00 00    	jae    80104b30 <thread_join+0x160>
		if(p->tid != thread || p->is_thread == 0 || curproc->pid != p->pid || p->state != ZOMBIE)
80104a2a:	39 b3 a0 00 00 00    	cmp    %esi,0xa0(%ebx)
80104a30:	75 e6                	jne    80104a18 <thread_join+0x48>
80104a32:	8b 8b 9c 00 00 00    	mov    0x9c(%ebx),%ecx
80104a38:	85 c9                	test   %ecx,%ecx
80104a3a:	74 dc                	je     80104a18 <thread_join+0x48>
80104a3c:	8b 43 10             	mov    0x10(%ebx),%eax
80104a3f:	39 47 10             	cmp    %eax,0x10(%edi)
80104a42:	75 d4                	jne    80104a18 <thread_join+0x48>
80104a44:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a48:	75 ce                	jne    80104a18 <thread_join+0x48>
			continue;

		*retval = p->ret_val;
80104a4a:	8b 93 b0 00 00 00    	mov    0xb0(%ebx),%edx
80104a50:	8b 45 0c             	mov    0xc(%ebp),%eax
		p->ret_val = 0;

		deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);
80104a53:	83 ec 04             	sub    $0x4,%esp
		*retval = p->ret_val;
80104a56:	89 10                	mov    %edx,(%eax)
		deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);
80104a58:	8b 83 b4 00 00 00    	mov    0xb4(%ebx),%eax
		p->ret_val = 0;
80104a5e:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
80104a65:	00 00 00 
		deallocuvm(p->pgdir, p->stack + 2*PGSIZE, p->stack);
80104a68:	50                   	push   %eax
80104a69:	05 00 20 00 00       	add    $0x2000,%eax
80104a6e:	50                   	push   %eax
80104a6f:	ff 73 04             	pushl  0x4(%ebx)
80104a72:	e8 09 31 00 00       	call   80107b80 <deallocuvm>
		kfree(p->kstack);
80104a77:	5a                   	pop    %edx
80104a78:	ff 73 08             	pushl  0x8(%ebx)
80104a7b:	e8 10 da ff ff       	call   80102490 <kfree>

		p->tickets = 0;
		p->lev = 0;
		p->in_mlfq = 0;

		stack_st[p->stack_id] = 0;
80104a80:	8b 83 b8 00 00 00    	mov    0xb8(%ebx),%eax
		p->master = 0;
		p->stack = 0;
		p->stack_id = 0;
		p->used_all_time = 0;

		release(&ptable.lock);		
80104a86:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
		p->kstack = 0;
80104a8d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
		p->sz = 0;
80104a94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		p->state = UNUSED;
80104a9a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		p->pid = 0;
80104aa1:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
		stack_st[p->stack_id] = 0;
80104aa8:	c7 04 85 80 4f 11 80 	movl   $0x0,-0x7feeb080(,%eax,4)
80104aaf:	00 00 00 00 
		p->parent = 0;
80104ab3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
		p->killed = 0;
80104aba:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
		p->name[0] = 0;
80104ac1:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
		p->tickets = 0;
80104ac5:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
		p->lev = 0;
80104acc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104ad3:	00 00 00 
		p->in_mlfq = 0;
80104ad6:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104add:	00 00 00 
		p->is_thread = 0;	
80104ae0:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80104ae7:	00 00 00 
		p->tid = 0;
80104aea:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80104af1:	00 00 00 
		p->master = 0;
80104af4:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104afb:	00 00 00 
		p->stack = 0;
80104afe:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
80104b05:	00 00 00 
		p->stack_id = 0;
80104b08:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
80104b0f:	00 00 00 
		p->used_all_time = 0;
80104b12:	c7 83 bc 00 00 00 00 	movl   $0x0,0xbc(%ebx)
80104b19:	00 00 00 
		release(&ptable.lock);		
80104b1c:	e8 7f 03 00 00       	call   80104ea0 <release>
		return 0;
80104b21:	83 c4 10             	add    $0x10,%esp
80104b24:	31 c0                	xor    %eax,%eax
	  sleep(curproc, &ptable.lock);
  }

  release(&ptable.lock);
  return -1;
}
80104b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b29:	5b                   	pop    %ebx
80104b2a:	5e                   	pop    %esi
80104b2b:	5f                   	pop    %edi
80104b2c:	5d                   	pop    %ebp
80104b2d:	c3                   	ret    
80104b2e:	66 90                	xchg   %ax,%ax
	  if(curproc->killed) {
80104b30:	8b 47 24             	mov    0x24(%edi),%eax
80104b33:	85 c0                	test   %eax,%eax
80104b35:	75 1d                	jne    80104b54 <thread_join+0x184>
	  sleep(curproc, &ptable.lock);
80104b37:	83 ec 08             	sub    $0x8,%esp
80104b3a:	68 80 6d 11 80       	push   $0x80116d80
80104b3f:	57                   	push   %edi
80104b40:	e8 7b f6 ff ff       	call   801041c0 <sleep>
	 for(p=ptable.proc; p<&ptable.proc[NPROC]; p++) {
80104b45:	83 c4 10             	add    $0x10,%esp
80104b48:	e9 c0 fe ff ff       	jmp    80104a0d <thread_join+0x3d>
	return -1;
80104b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b52:	eb d2                	jmp    80104b26 <thread_join+0x156>
		release(&ptable.lock);
80104b54:	83 ec 0c             	sub    $0xc,%esp
80104b57:	68 80 6d 11 80       	push   $0x80116d80
80104b5c:	e8 3f 03 00 00       	call   80104ea0 <release>
		return -1;
80104b61:	83 c4 10             	add    $0x10,%esp
80104b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b69:	eb bb                	jmp    80104b26 <thread_join+0x156>
80104b6b:	66 90                	xchg   %ax,%ax
80104b6d:	66 90                	xchg   %ax,%ax
80104b6f:	90                   	nop

80104b70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b7a:	68 8c 98 10 80       	push   $0x8010988c
80104b7f:	8d 43 04             	lea    0x4(%ebx),%eax
80104b82:	50                   	push   %eax
80104b83:	e8 18 01 00 00       	call   80104ca0 <initlock>
  lk->name = name;
80104b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b8b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b91:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b94:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b9b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba1:	c9                   	leave  
80104ba2:	c3                   	ret    
80104ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	8d 73 04             	lea    0x4(%ebx),%esi
80104bbe:	56                   	push   %esi
80104bbf:	e8 1c 02 00 00       	call   80104de0 <acquire>
  while (lk->locked) {
80104bc4:	8b 13                	mov    (%ebx),%edx
80104bc6:	83 c4 10             	add    $0x10,%esp
80104bc9:	85 d2                	test   %edx,%edx
80104bcb:	74 16                	je     80104be3 <acquiresleep+0x33>
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104bd0:	83 ec 08             	sub    $0x8,%esp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	e8 e6 f5 ff ff       	call   801041c0 <sleep>
  while (lk->locked) {
80104bda:	8b 03                	mov    (%ebx),%eax
80104bdc:	83 c4 10             	add    $0x10,%esp
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	75 ed                	jne    80104bd0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104be3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104be9:	e8 b2 ed ff ff       	call   801039a0 <myproc>
80104bee:	8b 40 10             	mov    0x10(%eax),%eax
80104bf1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bf4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104bf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bfa:	5b                   	pop    %ebx
80104bfb:	5e                   	pop    %esi
80104bfc:	5d                   	pop    %ebp
  release(&lk->lk);
80104bfd:	e9 9e 02 00 00       	jmp    80104ea0 <release>
80104c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
80104c15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c1e:	56                   	push   %esi
80104c1f:	e8 bc 01 00 00       	call   80104de0 <acquire>
  lk->locked = 0;
80104c24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c2a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c31:	89 1c 24             	mov    %ebx,(%esp)
80104c34:	e8 b7 f7 ff ff       	call   801043f0 <wakeup>
  release(&lk->lk);
80104c39:	89 75 08             	mov    %esi,0x8(%ebp)
80104c3c:	83 c4 10             	add    $0x10,%esp
}
80104c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c42:	5b                   	pop    %ebx
80104c43:	5e                   	pop    %esi
80104c44:	5d                   	pop    %ebp
  release(&lk->lk);
80104c45:	e9 56 02 00 00       	jmp    80104ea0 <release>
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	56                   	push   %esi
80104c55:	53                   	push   %ebx
80104c56:	31 ff                	xor    %edi,%edi
80104c58:	83 ec 18             	sub    $0x18,%esp
80104c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c5e:	8d 73 04             	lea    0x4(%ebx),%esi
80104c61:	56                   	push   %esi
80104c62:	e8 79 01 00 00       	call   80104de0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c67:	8b 03                	mov    (%ebx),%eax
80104c69:	83 c4 10             	add    $0x10,%esp
80104c6c:	85 c0                	test   %eax,%eax
80104c6e:	74 13                	je     80104c83 <holdingsleep+0x33>
80104c70:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c73:	e8 28 ed ff ff       	call   801039a0 <myproc>
80104c78:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c7b:	0f 94 c0             	sete   %al
80104c7e:	0f b6 c0             	movzbl %al,%eax
80104c81:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104c83:	83 ec 0c             	sub    $0xc,%esp
80104c86:	56                   	push   %esi
80104c87:	e8 14 02 00 00       	call   80104ea0 <release>
  return r;
}
80104c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c8f:	89 f8                	mov    %edi,%eax
80104c91:	5b                   	pop    %ebx
80104c92:	5e                   	pop    %esi
80104c93:	5f                   	pop    %edi
80104c94:	5d                   	pop    %ebp
80104c95:	c3                   	ret    
80104c96:	66 90                	xchg   %ax,%ax
80104c98:	66 90                	xchg   %ax,%ax
80104c9a:	66 90                	xchg   %ax,%ax
80104c9c:	66 90                	xchg   %ax,%ax
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <initlock>:

extern struct proc* myproc(void);

void
initlock(struct spinlock *lk, char *name)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ca9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104caf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cc0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cc1:	31 d2                	xor    %edx,%edx
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ccc:	83 e8 08             	sub    $0x8,%eax
80104ccf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cd0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cd6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cdc:	77 1a                	ja     80104cf8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cde:	8b 58 04             	mov    0x4(%eax),%ebx
80104ce1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ce4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ce7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ce9:	83 fa 0a             	cmp    $0xa,%edx
80104cec:	75 e2                	jne    80104cd0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cee:	5b                   	pop    %ebx
80104cef:	5d                   	pop    %ebp
80104cf0:	c3                   	ret    
80104cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104cfb:	83 c1 28             	add    $0x28,%ecx
80104cfe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d06:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d09:	39 c1                	cmp    %eax,%ecx
80104d0b:	75 f3                	jne    80104d00 <getcallerpcs+0x40>
}
80104d0d:	5b                   	pop    %ebx
80104d0e:	5d                   	pop    %ebp
80104d0f:	c3                   	ret    

80104d10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
80104d17:	9c                   	pushf  
80104d18:	5b                   	pop    %ebx
  asm volatile("cli");
80104d19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d1a:	e8 e1 eb ff ff       	call   80103900 <mycpu>
80104d1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d25:	85 c0                	test   %eax,%eax
80104d27:	75 11                	jne    80104d3a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104d29:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d2f:	e8 cc eb ff ff       	call   80103900 <mycpu>
80104d34:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104d3a:	e8 c1 eb ff ff       	call   80103900 <mycpu>
80104d3f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d46:	83 c4 04             	add    $0x4,%esp
80104d49:	5b                   	pop    %ebx
80104d4a:	5d                   	pop    %ebp
80104d4b:	c3                   	ret    
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d50 <popcli>:

void
popcli(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d56:	9c                   	pushf  
80104d57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d58:	f6 c4 02             	test   $0x2,%ah
80104d5b:	75 35                	jne    80104d92 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d5d:	e8 9e eb ff ff       	call   80103900 <mycpu>
80104d62:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d69:	78 34                	js     80104d9f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d6b:	e8 90 eb ff ff       	call   80103900 <mycpu>
80104d70:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d76:	85 d2                	test   %edx,%edx
80104d78:	74 06                	je     80104d80 <popcli+0x30>
    sti();
}
80104d7a:	c9                   	leave  
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d80:	e8 7b eb ff ff       	call   80103900 <mycpu>
80104d85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	74 eb                	je     80104d7a <popcli+0x2a>
  asm volatile("sti");
80104d8f:	fb                   	sti    
}
80104d90:	c9                   	leave  
80104d91:	c3                   	ret    
    panic("popcli - interruptible");
80104d92:	83 ec 0c             	sub    $0xc,%esp
80104d95:	68 97 98 10 80       	push   $0x80109897
80104d9a:	e8 f1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d9f:	83 ec 0c             	sub    $0xc,%esp
80104da2:	68 ae 98 10 80       	push   $0x801098ae
80104da7:	e8 e4 b5 ff ff       	call   80100390 <panic>
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104db0 <holding>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	8b 75 08             	mov    0x8(%ebp),%esi
80104db8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dba:	e8 51 ff ff ff       	call   80104d10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104dbf:	8b 06                	mov    (%esi),%eax
80104dc1:	85 c0                	test   %eax,%eax
80104dc3:	74 10                	je     80104dd5 <holding+0x25>
80104dc5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dc8:	e8 33 eb ff ff       	call   80103900 <mycpu>
80104dcd:	39 c3                	cmp    %eax,%ebx
80104dcf:	0f 94 c3             	sete   %bl
80104dd2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104dd5:	e8 76 ff ff ff       	call   80104d50 <popcli>
}
80104dda:	89 d8                	mov    %ebx,%eax
80104ddc:	5b                   	pop    %ebx
80104ddd:	5e                   	pop    %esi
80104dde:	5d                   	pop    %ebp
80104ddf:	c3                   	ret    

80104de0 <acquire>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104de5:	e8 26 ff ff ff       	call   80104d10 <pushcli>
  if(holding(lk))
80104dea:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ded:	83 ec 0c             	sub    $0xc,%esp
80104df0:	53                   	push   %ebx
80104df1:	e8 ba ff ff ff       	call   80104db0 <holding>
80104df6:	83 c4 10             	add    $0x10,%esp
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	0f 85 83 00 00 00    	jne    80104e84 <acquire+0xa4>
80104e01:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e03:	ba 01 00 00 00       	mov    $0x1,%edx
80104e08:	eb 09                	jmp    80104e13 <acquire+0x33>
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e13:	89 d0                	mov    %edx,%eax
80104e15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e18:	85 c0                	test   %eax,%eax
80104e1a:	75 f4                	jne    80104e10 <acquire+0x30>
  __sync_synchronize();
80104e1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e24:	e8 d7 ea ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e29:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104e2c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e2f:	89 e8                	mov    %ebp,%eax
80104e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e38:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104e3e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104e44:	77 1a                	ja     80104e60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e46:	8b 48 04             	mov    0x4(%eax),%ecx
80104e49:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104e4c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e4f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e51:	83 fe 0a             	cmp    $0xa,%esi
80104e54:	75 e2                	jne    80104e38 <acquire+0x58>
}
80104e56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e59:	5b                   	pop    %ebx
80104e5a:	5e                   	pop    %esi
80104e5b:	5d                   	pop    %ebp
80104e5c:	c3                   	ret    
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
80104e60:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104e63:	83 c2 28             	add    $0x28,%edx
80104e66:	8d 76 00             	lea    0x0(%esi),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104e70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e76:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e79:	39 d0                	cmp    %edx,%eax
80104e7b:	75 f3                	jne    80104e70 <acquire+0x90>
}
80104e7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e80:	5b                   	pop    %ebx
80104e81:	5e                   	pop    %esi
80104e82:	5d                   	pop    %ebp
80104e83:	c3                   	ret    
    panic("acquire");
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	68 b5 98 10 80       	push   $0x801098b5
80104e8c:	e8 ff b4 ff ff       	call   80100390 <panic>
80104e91:	eb 0d                	jmp    80104ea0 <release>
80104e93:	90                   	nop
80104e94:	90                   	nop
80104e95:	90                   	nop
80104e96:	90                   	nop
80104e97:	90                   	nop
80104e98:	90                   	nop
80104e99:	90                   	nop
80104e9a:	90                   	nop
80104e9b:	90                   	nop
80104e9c:	90                   	nop
80104e9d:	90                   	nop
80104e9e:	90                   	nop
80104e9f:	90                   	nop

80104ea0 <release>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 10             	sub    $0x10,%esp
80104ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk)) {
80104eaa:	53                   	push   %ebx
80104eab:	e8 00 ff ff ff       	call   80104db0 <holding>
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	85 c0                	test   %eax,%eax
80104eb5:	74 22                	je     80104ed9 <release+0x39>
  lk->pcs[0] = 0;
80104eb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ebe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ec5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104eca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ed0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed3:	c9                   	leave  
  popcli();
80104ed4:	e9 77 fe ff ff       	jmp    80104d50 <popcli>
struct proc* p = myproc();
80104ed9:	e8 c2 ea ff ff       	call   801039a0 <myproc>
cprintf("NOT RELEASED ** PID:%d TID:%d eip:0x%x\n", p->pid,p->tid,p->tf->eip); 
80104ede:	8b 50 18             	mov    0x18(%eax),%edx
80104ee1:	ff 72 38             	pushl  0x38(%edx)
80104ee4:	ff b0 a0 00 00 00    	pushl  0xa0(%eax)
80104eea:	ff 70 10             	pushl  0x10(%eax)
80104eed:	68 c8 98 10 80       	push   $0x801098c8
80104ef2:	e8 69 b7 ff ff       	call   80100660 <cprintf>
    panic("release");
80104ef7:	c7 04 24 bd 98 10 80 	movl   $0x801098bd,(%esp)
80104efe:	e8 8d b4 ff ff       	call   80100390 <panic>
80104f03:	66 90                	xchg   %ax,%ax
80104f05:	66 90                	xchg   %ax,%ax
80104f07:	66 90                	xchg   %ax,%ax
80104f09:	66 90                	xchg   %ax,%ax
80104f0b:	66 90                	xchg   %ax,%ax
80104f0d:	66 90                	xchg   %ax,%ax
80104f0f:	90                   	nop

80104f10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	53                   	push   %ebx
80104f15:	8b 55 08             	mov    0x8(%ebp),%edx
80104f18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f1b:	f6 c2 03             	test   $0x3,%dl
80104f1e:	75 05                	jne    80104f25 <memset+0x15>
80104f20:	f6 c1 03             	test   $0x3,%cl
80104f23:	74 13                	je     80104f38 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f25:	89 d7                	mov    %edx,%edi
80104f27:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2a:	fc                   	cld    
80104f2b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f2d:	5b                   	pop    %ebx
80104f2e:	89 d0                	mov    %edx,%eax
80104f30:	5f                   	pop    %edi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	90                   	nop
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f38:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f3c:	c1 e9 02             	shr    $0x2,%ecx
80104f3f:	89 f8                	mov    %edi,%eax
80104f41:	89 fb                	mov    %edi,%ebx
80104f43:	c1 e0 18             	shl    $0x18,%eax
80104f46:	c1 e3 10             	shl    $0x10,%ebx
80104f49:	09 d8                	or     %ebx,%eax
80104f4b:	09 f8                	or     %edi,%eax
80104f4d:	c1 e7 08             	shl    $0x8,%edi
80104f50:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f52:	89 d7                	mov    %edx,%edi
80104f54:	fc                   	cld    
80104f55:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f57:	5b                   	pop    %ebx
80104f58:	89 d0                	mov    %edx,%eax
80104f5a:	5f                   	pop    %edi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi

80104f60 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
80104f65:	53                   	push   %ebx
80104f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f69:	8b 75 08             	mov    0x8(%ebp),%esi
80104f6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f6f:	85 db                	test   %ebx,%ebx
80104f71:	74 29                	je     80104f9c <memcmp+0x3c>
    if(*s1 != *s2)
80104f73:	0f b6 16             	movzbl (%esi),%edx
80104f76:	0f b6 0f             	movzbl (%edi),%ecx
80104f79:	38 d1                	cmp    %dl,%cl
80104f7b:	75 2b                	jne    80104fa8 <memcmp+0x48>
80104f7d:	b8 01 00 00 00       	mov    $0x1,%eax
80104f82:	eb 14                	jmp    80104f98 <memcmp+0x38>
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f88:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104f8c:	83 c0 01             	add    $0x1,%eax
80104f8f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104f94:	38 ca                	cmp    %cl,%dl
80104f96:	75 10                	jne    80104fa8 <memcmp+0x48>
  while(n-- > 0){
80104f98:	39 d8                	cmp    %ebx,%eax
80104f9a:	75 ec                	jne    80104f88 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104f9c:	5b                   	pop    %ebx
  return 0;
80104f9d:	31 c0                	xor    %eax,%eax
}
80104f9f:	5e                   	pop    %esi
80104fa0:	5f                   	pop    %edi
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret    
80104fa3:	90                   	nop
80104fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104fa8:	0f b6 c2             	movzbl %dl,%eax
}
80104fab:	5b                   	pop    %ebx
      return *s1 - *s2;
80104fac:	29 c8                	sub    %ecx,%eax
}
80104fae:	5e                   	pop    %esi
80104faf:	5f                   	pop    %edi
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    
80104fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
80104fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104fcb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fce:	39 c3                	cmp    %eax,%ebx
80104fd0:	73 26                	jae    80104ff8 <memmove+0x38>
80104fd2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104fd5:	39 c8                	cmp    %ecx,%eax
80104fd7:	73 1f                	jae    80104ff8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104fd9:	85 f6                	test   %esi,%esi
80104fdb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104fde:	74 0f                	je     80104fef <memmove+0x2f>
      *--d = *--s;
80104fe0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104fe4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104fe7:	83 ea 01             	sub    $0x1,%edx
80104fea:	83 fa ff             	cmp    $0xffffffff,%edx
80104fed:	75 f1                	jne    80104fe0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fef:	5b                   	pop    %ebx
80104ff0:	5e                   	pop    %esi
80104ff1:	5d                   	pop    %ebp
80104ff2:	c3                   	ret    
80104ff3:	90                   	nop
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ff8:	31 d2                	xor    %edx,%edx
80104ffa:	85 f6                	test   %esi,%esi
80104ffc:	74 f1                	je     80104fef <memmove+0x2f>
80104ffe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105000:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105004:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105007:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010500a:	39 d6                	cmp    %edx,%esi
8010500c:	75 f2                	jne    80105000 <memmove+0x40>
}
8010500e:	5b                   	pop    %ebx
8010500f:	5e                   	pop    %esi
80105010:	5d                   	pop    %ebp
80105011:	c3                   	ret    
80105012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105023:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105024:	eb 9a                	jmp    80104fc0 <memmove>
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	8b 7d 10             	mov    0x10(%ebp),%edi
80105038:	53                   	push   %ebx
80105039:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010503c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010503f:	85 ff                	test   %edi,%edi
80105041:	74 2f                	je     80105072 <strncmp+0x42>
80105043:	0f b6 01             	movzbl (%ecx),%eax
80105046:	0f b6 1e             	movzbl (%esi),%ebx
80105049:	84 c0                	test   %al,%al
8010504b:	74 37                	je     80105084 <strncmp+0x54>
8010504d:	38 c3                	cmp    %al,%bl
8010504f:	75 33                	jne    80105084 <strncmp+0x54>
80105051:	01 f7                	add    %esi,%edi
80105053:	eb 13                	jmp    80105068 <strncmp+0x38>
80105055:	8d 76 00             	lea    0x0(%esi),%esi
80105058:	0f b6 01             	movzbl (%ecx),%eax
8010505b:	84 c0                	test   %al,%al
8010505d:	74 21                	je     80105080 <strncmp+0x50>
8010505f:	0f b6 1a             	movzbl (%edx),%ebx
80105062:	89 d6                	mov    %edx,%esi
80105064:	38 d8                	cmp    %bl,%al
80105066:	75 1c                	jne    80105084 <strncmp+0x54>
    n--, p++, q++;
80105068:	8d 56 01             	lea    0x1(%esi),%edx
8010506b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010506e:	39 fa                	cmp    %edi,%edx
80105070:	75 e6                	jne    80105058 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105072:	5b                   	pop    %ebx
    return 0;
80105073:	31 c0                	xor    %eax,%eax
}
80105075:	5e                   	pop    %esi
80105076:	5f                   	pop    %edi
80105077:	5d                   	pop    %ebp
80105078:	c3                   	ret    
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105080:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105084:	29 d8                	sub    %ebx,%eax
}
80105086:	5b                   	pop    %ebx
80105087:	5e                   	pop    %esi
80105088:	5f                   	pop    %edi
80105089:	5d                   	pop    %ebp
8010508a:	c3                   	ret    
8010508b:	90                   	nop
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
80105095:	8b 45 08             	mov    0x8(%ebp),%eax
80105098:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010509b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010509e:	89 c2                	mov    %eax,%edx
801050a0:	eb 19                	jmp    801050bb <strncpy+0x2b>
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050a8:	83 c3 01             	add    $0x1,%ebx
801050ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801050af:	83 c2 01             	add    $0x1,%edx
801050b2:	84 c9                	test   %cl,%cl
801050b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050b7:	74 09                	je     801050c2 <strncpy+0x32>
801050b9:	89 f1                	mov    %esi,%ecx
801050bb:	85 c9                	test   %ecx,%ecx
801050bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801050c0:	7f e6                	jg     801050a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050c2:	31 c9                	xor    %ecx,%ecx
801050c4:	85 f6                	test   %esi,%esi
801050c6:	7e 17                	jle    801050df <strncpy+0x4f>
801050c8:	90                   	nop
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801050d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801050d4:	89 f3                	mov    %esi,%ebx
801050d6:	83 c1 01             	add    $0x1,%ecx
801050d9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801050db:	85 db                	test   %ebx,%ebx
801050dd:	7f f1                	jg     801050d0 <strncpy+0x40>
  return os;
}
801050df:	5b                   	pop    %ebx
801050e0:	5e                   	pop    %esi
801050e1:	5d                   	pop    %ebp
801050e2:	c3                   	ret    
801050e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
801050f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050f8:	8b 45 08             	mov    0x8(%ebp),%eax
801050fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801050fe:	85 c9                	test   %ecx,%ecx
80105100:	7e 26                	jle    80105128 <safestrcpy+0x38>
80105102:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105106:	89 c1                	mov    %eax,%ecx
80105108:	eb 17                	jmp    80105121 <safestrcpy+0x31>
8010510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105110:	83 c2 01             	add    $0x1,%edx
80105113:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105117:	83 c1 01             	add    $0x1,%ecx
8010511a:	84 db                	test   %bl,%bl
8010511c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010511f:	74 04                	je     80105125 <safestrcpy+0x35>
80105121:	39 f2                	cmp    %esi,%edx
80105123:	75 eb                	jne    80105110 <safestrcpy+0x20>
    ;
  *s = 0;
80105125:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105128:	5b                   	pop    %ebx
80105129:	5e                   	pop    %esi
8010512a:	5d                   	pop    %ebp
8010512b:	c3                   	ret    
8010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105130 <strlen>:

int
strlen(const char *s)
{
80105130:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105131:	31 c0                	xor    %eax,%eax
{
80105133:	89 e5                	mov    %esp,%ebp
80105135:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105138:	80 3a 00             	cmpb   $0x0,(%edx)
8010513b:	74 0c                	je     80105149 <strlen+0x19>
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
80105140:	83 c0 01             	add    $0x1,%eax
80105143:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105147:	75 f7                	jne    80105140 <strlen+0x10>
    ;
  return n;
}
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    

8010514b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010514b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010514f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105153:	55                   	push   %ebp
  pushl %ebx
80105154:	53                   	push   %ebx
  pushl %esi
80105155:	56                   	push   %esi
  pushl %edi
80105156:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105157:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105159:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010515b:	5f                   	pop    %edi
  popl %esi
8010515c:	5e                   	pop    %esi
  popl %ebx
8010515d:	5b                   	pop    %ebx
  popl %ebp
8010515e:	5d                   	pop    %ebp
  ret
8010515f:	c3                   	ret    

80105160 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	53                   	push   %ebx
80105164:	83 ec 04             	sub    $0x4,%esp
80105167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010516a:	e8 31 e8 ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010516f:	8b 00                	mov    (%eax),%eax
80105171:	39 d8                	cmp    %ebx,%eax
80105173:	76 1b                	jbe    80105190 <fetchint+0x30>
80105175:	8d 53 04             	lea    0x4(%ebx),%edx
80105178:	39 d0                	cmp    %edx,%eax
8010517a:	72 14                	jb     80105190 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010517c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517f:	8b 13                	mov    (%ebx),%edx
80105181:	89 10                	mov    %edx,(%eax)
  return 0;
80105183:	31 c0                	xor    %eax,%eax
}
80105185:	83 c4 04             	add    $0x4,%esp
80105188:	5b                   	pop    %ebx
80105189:	5d                   	pop    %ebp
8010518a:	c3                   	ret    
8010518b:	90                   	nop
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105195:	eb ee                	jmp    80105185 <fetchint+0x25>
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	53                   	push   %ebx
801051a4:	83 ec 04             	sub    $0x4,%esp
801051a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051aa:	e8 f1 e7 ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz)
801051af:	39 18                	cmp    %ebx,(%eax)
801051b1:	76 29                	jbe    801051dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801051b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051b6:	89 da                	mov    %ebx,%edx
801051b8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801051ba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801051bc:	39 c3                	cmp    %eax,%ebx
801051be:	73 1c                	jae    801051dc <fetchstr+0x3c>
    if(*s == 0)
801051c0:	80 3b 00             	cmpb   $0x0,(%ebx)
801051c3:	75 10                	jne    801051d5 <fetchstr+0x35>
801051c5:	eb 39                	jmp    80105200 <fetchstr+0x60>
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801051d0:	80 3a 00             	cmpb   $0x0,(%edx)
801051d3:	74 1b                	je     801051f0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801051d5:	83 c2 01             	add    $0x1,%edx
801051d8:	39 d0                	cmp    %edx,%eax
801051da:	77 f4                	ja     801051d0 <fetchstr+0x30>
    return -1;
801051dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801051e1:	83 c4 04             	add    $0x4,%esp
801051e4:	5b                   	pop    %ebx
801051e5:	5d                   	pop    %ebp
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801051f0:	83 c4 04             	add    $0x4,%esp
801051f3:	89 d0                	mov    %edx,%eax
801051f5:	29 d8                	sub    %ebx,%eax
801051f7:	5b                   	pop    %ebx
801051f8:	5d                   	pop    %ebp
801051f9:	c3                   	ret    
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105200:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105202:	eb dd                	jmp    801051e1 <fetchstr+0x41>
80105204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010520a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105210 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105215:	e8 86 e7 ff ff       	call   801039a0 <myproc>
8010521a:	8b 40 18             	mov    0x18(%eax),%eax
8010521d:	8b 55 08             	mov    0x8(%ebp),%edx
80105220:	8b 40 44             	mov    0x44(%eax),%eax
80105223:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105226:	e8 75 e7 ff ff       	call   801039a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010522b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010522d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105230:	39 c6                	cmp    %eax,%esi
80105232:	73 1c                	jae    80105250 <argint+0x40>
80105234:	8d 53 08             	lea    0x8(%ebx),%edx
80105237:	39 d0                	cmp    %edx,%eax
80105239:	72 15                	jb     80105250 <argint+0x40>
  *ip = *(int*)(addr);
8010523b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010523e:	8b 53 04             	mov    0x4(%ebx),%edx
80105241:	89 10                	mov    %edx,(%eax)
  return 0;
80105243:	31 c0                	xor    %eax,%eax
}
80105245:	5b                   	pop    %ebx
80105246:	5e                   	pop    %esi
80105247:	5d                   	pop    %ebp
80105248:	c3                   	ret    
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105255:	eb ee                	jmp    80105245 <argint+0x35>
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
80105265:	83 ec 10             	sub    $0x10,%esp
80105268:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010526b:	e8 30 e7 ff ff       	call   801039a0 <myproc>
80105270:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105272:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	50                   	push   %eax
80105279:	ff 75 08             	pushl  0x8(%ebp)
8010527c:	e8 8f ff ff ff       	call   80105210 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	85 c0                	test   %eax,%eax
80105286:	78 28                	js     801052b0 <argptr+0x50>
80105288:	85 db                	test   %ebx,%ebx
8010528a:	78 24                	js     801052b0 <argptr+0x50>
8010528c:	8b 16                	mov    (%esi),%edx
8010528e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105291:	39 c2                	cmp    %eax,%edx
80105293:	76 1b                	jbe    801052b0 <argptr+0x50>
80105295:	01 c3                	add    %eax,%ebx
80105297:	39 da                	cmp    %ebx,%edx
80105299:	72 15                	jb     801052b0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010529b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010529e:	89 02                	mov    %eax,(%edx)
  return 0;
801052a0:	31 c0                	xor    %eax,%eax
}
801052a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a5:	5b                   	pop    %ebx
801052a6:	5e                   	pop    %esi
801052a7:	5d                   	pop    %ebp
801052a8:	c3                   	ret    
801052a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b5:	eb eb                	jmp    801052a2 <argptr+0x42>
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c9:	50                   	push   %eax
801052ca:	ff 75 08             	pushl  0x8(%ebp)
801052cd:	e8 3e ff ff ff       	call   80105210 <argint>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 17                	js     801052f0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052d9:	83 ec 08             	sub    $0x8,%esp
801052dc:	ff 75 0c             	pushl  0xc(%ebp)
801052df:	ff 75 f4             	pushl  -0xc(%ebp)
801052e2:	e8 b9 fe ff ff       	call   801051a0 <fetchstr>
801052e7:	83 c4 10             	add    $0x10,%esp
}
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <syscall>:
[SYS_rwlock_release_writelock] sys_rwlock_release_writelock,
};

void
syscall(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105307:	e8 94 e6 ff ff       	call   801039a0 <myproc>
8010530c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010530e:	8b 40 18             	mov    0x18(%eax),%eax
80105311:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105314:	8d 50 ff             	lea    -0x1(%eax),%edx
80105317:	83 fa 24             	cmp    $0x24,%edx
8010531a:	77 1c                	ja     80105338 <syscall+0x38>
8010531c:	8b 14 85 20 99 10 80 	mov    -0x7fef66e0(,%eax,4),%edx
80105323:	85 d2                	test   %edx,%edx
80105325:	74 11                	je     80105338 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105327:	ff d2                	call   *%edx
80105329:	8b 53 18             	mov    0x18(%ebx),%edx
8010532c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010532f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105332:	c9                   	leave  
80105333:	c3                   	ret    
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105338:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105339:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010533c:	50                   	push   %eax
8010533d:	ff 73 10             	pushl  0x10(%ebx)
80105340:	68 f0 98 10 80       	push   $0x801098f0
80105345:	e8 16 b3 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010534a:	8b 43 18             	mov    0x18(%ebx),%eax
8010534d:	83 c4 10             	add    $0x10,%esp
80105350:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    
8010535c:	66 90                	xchg   %ax,%ax
8010535e:	66 90                	xchg   %ax,%ax

80105360 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105366:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105369:	83 ec 34             	sub    $0x34,%esp
8010536c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010536f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105372:	56                   	push   %esi
80105373:	50                   	push   %eax
{
80105374:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105377:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010537a:	e8 01 cd ff ff       	call   80102080 <nameiparent>
8010537f:	83 c4 10             	add    $0x10,%esp
80105382:	85 c0                	test   %eax,%eax
80105384:	0f 84 46 01 00 00    	je     801054d0 <create+0x170>
    return 0;
  ilock(dp);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	89 c3                	mov    %eax,%ebx
8010538f:	50                   	push   %eax
80105390:	e8 6b c4 ff ff       	call   80101800 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105395:	83 c4 0c             	add    $0xc,%esp
80105398:	6a 00                	push   $0x0
8010539a:	56                   	push   %esi
8010539b:	53                   	push   %ebx
8010539c:	e8 8f c9 ff ff       	call   80101d30 <dirlookup>
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	85 c0                	test   %eax,%eax
801053a6:	89 c7                	mov    %eax,%edi
801053a8:	74 36                	je     801053e0 <create+0x80>
    iunlockput(dp);
801053aa:	83 ec 0c             	sub    $0xc,%esp
801053ad:	53                   	push   %ebx
801053ae:	e8 dd c6 ff ff       	call   80101a90 <iunlockput>
    ilock(ip);
801053b3:	89 3c 24             	mov    %edi,(%esp)
801053b6:	e8 45 c4 ff ff       	call   80101800 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053bb:	83 c4 10             	add    $0x10,%esp
801053be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053c3:	0f 85 97 00 00 00    	jne    80105460 <create+0x100>
801053c9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801053ce:	0f 85 8c 00 00 00    	jne    80105460 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d7:	89 f8                	mov    %edi,%eax
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801053e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	50                   	push   %eax
801053e8:	ff 33                	pushl  (%ebx)
801053ea:	e8 a1 c2 ff ff       	call   80101690 <ialloc>
801053ef:	83 c4 10             	add    $0x10,%esp
801053f2:	85 c0                	test   %eax,%eax
801053f4:	89 c7                	mov    %eax,%edi
801053f6:	0f 84 e8 00 00 00    	je     801054e4 <create+0x184>
  ilock(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	50                   	push   %eax
80105400:	e8 fb c3 ff ff       	call   80101800 <ilock>
  ip->major = major;
80105405:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105409:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010540d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105411:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105415:	b8 01 00 00 00       	mov    $0x1,%eax
8010541a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010541e:	89 3c 24             	mov    %edi,(%esp)
80105421:	e8 2a c3 ff ff       	call   80101750 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010542e:	74 50                	je     80105480 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105430:	83 ec 04             	sub    $0x4,%esp
80105433:	ff 77 04             	pushl  0x4(%edi)
80105436:	56                   	push   %esi
80105437:	53                   	push   %ebx
80105438:	e8 63 cb ff ff       	call   80101fa0 <dirlink>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	0f 88 8f 00 00 00    	js     801054d7 <create+0x177>
  iunlockput(dp);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	53                   	push   %ebx
8010544c:	e8 3f c6 ff ff       	call   80101a90 <iunlockput>
  return ip;
80105451:	83 c4 10             	add    $0x10,%esp
}
80105454:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105457:	89 f8                	mov    %edi,%eax
80105459:	5b                   	pop    %ebx
8010545a:	5e                   	pop    %esi
8010545b:	5f                   	pop    %edi
8010545c:	5d                   	pop    %ebp
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	57                   	push   %edi
    return 0;
80105464:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105466:	e8 25 c6 ff ff       	call   80101a90 <iunlockput>
    return 0;
8010546b:	83 c4 10             	add    $0x10,%esp
}
8010546e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105471:	89 f8                	mov    %edi,%eax
80105473:	5b                   	pop    %ebx
80105474:	5e                   	pop    %esi
80105475:	5f                   	pop    %edi
80105476:	5d                   	pop    %ebp
80105477:	c3                   	ret    
80105478:	90                   	nop
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105480:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	53                   	push   %ebx
80105489:	e8 c2 c2 ff ff       	call   80101750 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010548e:	83 c4 0c             	add    $0xc,%esp
80105491:	ff 77 04             	pushl  0x4(%edi)
80105494:	68 d4 99 10 80       	push   $0x801099d4
80105499:	57                   	push   %edi
8010549a:	e8 01 cb ff ff       	call   80101fa0 <dirlink>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	85 c0                	test   %eax,%eax
801054a4:	78 1c                	js     801054c2 <create+0x162>
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	ff 73 04             	pushl  0x4(%ebx)
801054ac:	68 d3 99 10 80       	push   $0x801099d3
801054b1:	57                   	push   %edi
801054b2:	e8 e9 ca ff ff       	call   80101fa0 <dirlink>
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	85 c0                	test   %eax,%eax
801054bc:	0f 89 6e ff ff ff    	jns    80105430 <create+0xd0>
      panic("create dots");
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	68 c7 99 10 80       	push   $0x801099c7
801054ca:	e8 c1 ae ff ff       	call   80100390 <panic>
801054cf:	90                   	nop
    return 0;
801054d0:	31 ff                	xor    %edi,%edi
801054d2:	e9 fd fe ff ff       	jmp    801053d4 <create+0x74>
    panic("create: dirlink");
801054d7:	83 ec 0c             	sub    $0xc,%esp
801054da:	68 d6 99 10 80       	push   $0x801099d6
801054df:	e8 ac ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	68 b8 99 10 80       	push   $0x801099b8
801054ec:	e8 9f ae ff ff       	call   80100390 <panic>
801054f1:	eb 0d                	jmp    80105500 <argfd.constprop.0>
801054f3:	90                   	nop
801054f4:	90                   	nop
801054f5:	90                   	nop
801054f6:	90                   	nop
801054f7:	90                   	nop
801054f8:	90                   	nop
801054f9:	90                   	nop
801054fa:	90                   	nop
801054fb:	90                   	nop
801054fc:	90                   	nop
801054fd:	90                   	nop
801054fe:	90                   	nop
801054ff:	90                   	nop

80105500 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105507:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010550a:	89 d6                	mov    %edx,%esi
8010550c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010550f:	50                   	push   %eax
80105510:	6a 00                	push   $0x0
80105512:	e8 f9 fc ff ff       	call   80105210 <argint>
80105517:	83 c4 10             	add    $0x10,%esp
8010551a:	85 c0                	test   %eax,%eax
8010551c:	78 2a                	js     80105548 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010551e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105522:	77 24                	ja     80105548 <argfd.constprop.0+0x48>
80105524:	e8 77 e4 ff ff       	call   801039a0 <myproc>
80105529:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010552c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105530:	85 c0                	test   %eax,%eax
80105532:	74 14                	je     80105548 <argfd.constprop.0+0x48>
  if(pfd)
80105534:	85 db                	test   %ebx,%ebx
80105536:	74 02                	je     8010553a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105538:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010553a:	89 06                	mov    %eax,(%esi)
  return 0;
8010553c:	31 c0                	xor    %eax,%eax
}
8010553e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105541:	5b                   	pop    %ebx
80105542:	5e                   	pop    %esi
80105543:	5d                   	pop    %ebp
80105544:	c3                   	ret    
80105545:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	eb ef                	jmp    8010553e <argfd.constprop.0+0x3e>
8010554f:	90                   	nop

80105550 <sys_dup>:
{
80105550:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105551:	31 c0                	xor    %eax,%eax
{
80105553:	89 e5                	mov    %esp,%ebp
80105555:	56                   	push   %esi
80105556:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105557:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010555a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010555d:	e8 9e ff ff ff       	call   80105500 <argfd.constprop.0>
80105562:	85 c0                	test   %eax,%eax
80105564:	78 42                	js     801055a8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105566:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105569:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010556b:	e8 30 e4 ff ff       	call   801039a0 <myproc>
80105570:	eb 0e                	jmp    80105580 <sys_dup+0x30>
80105572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105578:	83 c3 01             	add    $0x1,%ebx
8010557b:	83 fb 10             	cmp    $0x10,%ebx
8010557e:	74 28                	je     801055a8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105580:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105584:	85 d2                	test   %edx,%edx
80105586:	75 f0                	jne    80105578 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105588:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	ff 75 f4             	pushl  -0xc(%ebp)
80105592:	e8 d9 b9 ff ff       	call   80100f70 <filedup>
  return fd;
80105597:	83 c4 10             	add    $0x10,%esp
}
8010559a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010559d:	89 d8                	mov    %ebx,%eax
8010559f:	5b                   	pop    %ebx
801055a0:	5e                   	pop    %esi
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret    
801055a3:	90                   	nop
801055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055b0:	89 d8                	mov    %ebx,%eax
801055b2:	5b                   	pop    %ebx
801055b3:	5e                   	pop    %esi
801055b4:	5d                   	pop    %ebp
801055b5:	c3                   	ret    
801055b6:	8d 76 00             	lea    0x0(%esi),%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_read>:
{
801055c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c1:	31 c0                	xor    %eax,%eax
{
801055c3:	89 e5                	mov    %esp,%ebp
801055c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055cb:	e8 30 ff ff ff       	call   80105500 <argfd.constprop.0>
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 4c                	js     80105620 <sys_read+0x60>
801055d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055d7:	83 ec 08             	sub    $0x8,%esp
801055da:	50                   	push   %eax
801055db:	6a 02                	push   $0x2
801055dd:	e8 2e fc ff ff       	call   80105210 <argint>
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	85 c0                	test   %eax,%eax
801055e7:	78 37                	js     80105620 <sys_read+0x60>
801055e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ec:	83 ec 04             	sub    $0x4,%esp
801055ef:	ff 75 f0             	pushl  -0x10(%ebp)
801055f2:	50                   	push   %eax
801055f3:	6a 01                	push   $0x1
801055f5:	e8 66 fc ff ff       	call   80105260 <argptr>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	78 1f                	js     80105620 <sys_read+0x60>
  return fileread(f, p, n);
80105601:	83 ec 04             	sub    $0x4,%esp
80105604:	ff 75 f0             	pushl  -0x10(%ebp)
80105607:	ff 75 f4             	pushl  -0xc(%ebp)
8010560a:	ff 75 ec             	pushl  -0x14(%ebp)
8010560d:	e8 ce ba ff ff       	call   801010e0 <fileread>
80105612:	83 c4 10             	add    $0x10,%esp
}
80105615:	c9                   	leave  
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105625:	c9                   	leave  
80105626:	c3                   	ret    
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_write>:
{
80105630:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105631:	31 c0                	xor    %eax,%eax
{
80105633:	89 e5                	mov    %esp,%ebp
80105635:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105638:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010563b:	e8 c0 fe ff ff       	call   80105500 <argfd.constprop.0>
80105640:	85 c0                	test   %eax,%eax
80105642:	78 4c                	js     80105690 <sys_write+0x60>
80105644:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105647:	83 ec 08             	sub    $0x8,%esp
8010564a:	50                   	push   %eax
8010564b:	6a 02                	push   $0x2
8010564d:	e8 be fb ff ff       	call   80105210 <argint>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	85 c0                	test   %eax,%eax
80105657:	78 37                	js     80105690 <sys_write+0x60>
80105659:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010565c:	83 ec 04             	sub    $0x4,%esp
8010565f:	ff 75 f0             	pushl  -0x10(%ebp)
80105662:	50                   	push   %eax
80105663:	6a 01                	push   $0x1
80105665:	e8 f6 fb ff ff       	call   80105260 <argptr>
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	85 c0                	test   %eax,%eax
8010566f:	78 1f                	js     80105690 <sys_write+0x60>
  return filewrite(f, p, n);
80105671:	83 ec 04             	sub    $0x4,%esp
80105674:	ff 75 f0             	pushl  -0x10(%ebp)
80105677:	ff 75 f4             	pushl  -0xc(%ebp)
8010567a:	ff 75 ec             	pushl  -0x14(%ebp)
8010567d:	e8 ee ba ff ff       	call   80101170 <filewrite>
80105682:	83 c4 10             	add    $0x10,%esp
}
80105685:	c9                   	leave  
80105686:	c3                   	ret    
80105687:	89 f6                	mov    %esi,%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105695:	c9                   	leave  
80105696:	c3                   	ret    
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <sys_close>:
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801056a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ac:	e8 4f fe ff ff       	call   80105500 <argfd.constprop.0>
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 2b                	js     801056e0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801056b5:	e8 e6 e2 ff ff       	call   801039a0 <myproc>
801056ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056bd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056c0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801056c7:	00 
  fileclose(f);
801056c8:	ff 75 f4             	pushl  -0xc(%ebp)
801056cb:	e8 f0 b8 ff ff       	call   80100fc0 <fileclose>
  return 0;
801056d0:	83 c4 10             	add    $0x10,%esp
801056d3:	31 c0                	xor    %eax,%eax
}
801056d5:	c9                   	leave  
801056d6:	c3                   	ret    
801056d7:	89 f6                	mov    %esi,%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056f0 <sys_fstat>:
{
801056f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056f1:	31 c0                	xor    %eax,%eax
{
801056f3:	89 e5                	mov    %esp,%ebp
801056f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056fb:	e8 00 fe ff ff       	call   80105500 <argfd.constprop.0>
80105700:	85 c0                	test   %eax,%eax
80105702:	78 2c                	js     80105730 <sys_fstat+0x40>
80105704:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105707:	83 ec 04             	sub    $0x4,%esp
8010570a:	6a 14                	push   $0x14
8010570c:	50                   	push   %eax
8010570d:	6a 01                	push   $0x1
8010570f:	e8 4c fb ff ff       	call   80105260 <argptr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	78 15                	js     80105730 <sys_fstat+0x40>
  return filestat(f, st);
8010571b:	83 ec 08             	sub    $0x8,%esp
8010571e:	ff 75 f4             	pushl  -0xc(%ebp)
80105721:	ff 75 f0             	pushl  -0x10(%ebp)
80105724:	e8 67 b9 ff ff       	call   80101090 <filestat>
80105729:	83 c4 10             	add    $0x10,%esp
}
8010572c:	c9                   	leave  
8010572d:	c3                   	ret    
8010572e:	66 90                	xchg   %ax,%ax
    return -1;
80105730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105735:	c9                   	leave  
80105736:	c3                   	ret    
80105737:	89 f6                	mov    %esi,%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <sys_link>:
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
80105745:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105746:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105749:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010574c:	50                   	push   %eax
8010574d:	6a 00                	push   $0x0
8010574f:	e8 6c fb ff ff       	call   801052c0 <argstr>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	0f 88 fb 00 00 00    	js     8010585a <sys_link+0x11a>
8010575f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105762:	83 ec 08             	sub    $0x8,%esp
80105765:	50                   	push   %eax
80105766:	6a 01                	push   $0x1
80105768:	e8 53 fb ff ff       	call   801052c0 <argstr>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	85 c0                	test   %eax,%eax
80105772:	0f 88 e2 00 00 00    	js     8010585a <sys_link+0x11a>
  begin_op();
80105778:	e8 a3 d5 ff ff       	call   80102d20 <begin_op>
  if((ip = namei(old)) == 0){
8010577d:	83 ec 0c             	sub    $0xc,%esp
80105780:	ff 75 d4             	pushl  -0x2c(%ebp)
80105783:	e8 d8 c8 ff ff       	call   80102060 <namei>
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	85 c0                	test   %eax,%eax
8010578d:	89 c3                	mov    %eax,%ebx
8010578f:	0f 84 ea 00 00 00    	je     8010587f <sys_link+0x13f>
  ilock(ip);
80105795:	83 ec 0c             	sub    $0xc,%esp
80105798:	50                   	push   %eax
80105799:	e8 62 c0 ff ff       	call   80101800 <ilock>
  if(ip->type == T_DIR){
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057a6:	0f 84 bb 00 00 00    	je     80105867 <sys_link+0x127>
  ip->nlink++;
801057ac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801057b1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801057b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057b7:	53                   	push   %ebx
801057b8:	e8 93 bf ff ff       	call   80101750 <iupdate>
  iunlock(ip);
801057bd:	89 1c 24             	mov    %ebx,(%esp)
801057c0:	e8 1b c1 ff ff       	call   801018e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057c5:	58                   	pop    %eax
801057c6:	5a                   	pop    %edx
801057c7:	57                   	push   %edi
801057c8:	ff 75 d0             	pushl  -0x30(%ebp)
801057cb:	e8 b0 c8 ff ff       	call   80102080 <nameiparent>
801057d0:	83 c4 10             	add    $0x10,%esp
801057d3:	85 c0                	test   %eax,%eax
801057d5:	89 c6                	mov    %eax,%esi
801057d7:	74 5b                	je     80105834 <sys_link+0xf4>
  ilock(dp);
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	50                   	push   %eax
801057dd:	e8 1e c0 ff ff       	call   80101800 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	8b 03                	mov    (%ebx),%eax
801057e7:	39 06                	cmp    %eax,(%esi)
801057e9:	75 3d                	jne    80105828 <sys_link+0xe8>
801057eb:	83 ec 04             	sub    $0x4,%esp
801057ee:	ff 73 04             	pushl  0x4(%ebx)
801057f1:	57                   	push   %edi
801057f2:	56                   	push   %esi
801057f3:	e8 a8 c7 ff ff       	call   80101fa0 <dirlink>
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	85 c0                	test   %eax,%eax
801057fd:	78 29                	js     80105828 <sys_link+0xe8>
  iunlockput(dp);
801057ff:	83 ec 0c             	sub    $0xc,%esp
80105802:	56                   	push   %esi
80105803:	e8 88 c2 ff ff       	call   80101a90 <iunlockput>
  iput(ip);
80105808:	89 1c 24             	mov    %ebx,(%esp)
8010580b:	e8 20 c1 ff ff       	call   80101930 <iput>
  end_op();
80105810:	e8 7b d5 ff ff       	call   80102d90 <end_op>
  return 0;
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	31 c0                	xor    %eax,%eax
}
8010581a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010581d:	5b                   	pop    %ebx
8010581e:	5e                   	pop    %esi
8010581f:	5f                   	pop    %edi
80105820:	5d                   	pop    %ebp
80105821:	c3                   	ret    
80105822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	56                   	push   %esi
8010582c:	e8 5f c2 ff ff       	call   80101a90 <iunlockput>
    goto bad;
80105831:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	53                   	push   %ebx
80105838:	e8 c3 bf ff ff       	call   80101800 <ilock>
  ip->nlink--;
8010583d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105842:	89 1c 24             	mov    %ebx,(%esp)
80105845:	e8 06 bf ff ff       	call   80101750 <iupdate>
  iunlockput(ip);
8010584a:	89 1c 24             	mov    %ebx,(%esp)
8010584d:	e8 3e c2 ff ff       	call   80101a90 <iunlockput>
  end_op();
80105852:	e8 39 d5 ff ff       	call   80102d90 <end_op>
  return -1;
80105857:	83 c4 10             	add    $0x10,%esp
}
8010585a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010585d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105862:	5b                   	pop    %ebx
80105863:	5e                   	pop    %esi
80105864:	5f                   	pop    %edi
80105865:	5d                   	pop    %ebp
80105866:	c3                   	ret    
    iunlockput(ip);
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	53                   	push   %ebx
8010586b:	e8 20 c2 ff ff       	call   80101a90 <iunlockput>
    end_op();
80105870:	e8 1b d5 ff ff       	call   80102d90 <end_op>
    return -1;
80105875:	83 c4 10             	add    $0x10,%esp
80105878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587d:	eb 9b                	jmp    8010581a <sys_link+0xda>
    end_op();
8010587f:	e8 0c d5 ff ff       	call   80102d90 <end_op>
    return -1;
80105884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105889:	eb 8f                	jmp    8010581a <sys_link+0xda>
8010588b:	90                   	nop
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_unlink>:
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105896:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105899:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010589c:	50                   	push   %eax
8010589d:	6a 00                	push   $0x0
8010589f:	e8 1c fa ff ff       	call   801052c0 <argstr>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	85 c0                	test   %eax,%eax
801058a9:	0f 88 77 01 00 00    	js     80105a26 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801058af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801058b2:	e8 69 d4 ff ff       	call   80102d20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058b7:	83 ec 08             	sub    $0x8,%esp
801058ba:	53                   	push   %ebx
801058bb:	ff 75 c0             	pushl  -0x40(%ebp)
801058be:	e8 bd c7 ff ff       	call   80102080 <nameiparent>
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	89 c6                	mov    %eax,%esi
801058ca:	0f 84 60 01 00 00    	je     80105a30 <sys_unlink+0x1a0>
  ilock(dp);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	50                   	push   %eax
801058d4:	e8 27 bf ff ff       	call   80101800 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058d9:	58                   	pop    %eax
801058da:	5a                   	pop    %edx
801058db:	68 d4 99 10 80       	push   $0x801099d4
801058e0:	53                   	push   %ebx
801058e1:	e8 2a c4 ff ff       	call   80101d10 <namecmp>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 84 03 01 00 00    	je     801059f4 <sys_unlink+0x164>
801058f1:	83 ec 08             	sub    $0x8,%esp
801058f4:	68 d3 99 10 80       	push   $0x801099d3
801058f9:	53                   	push   %ebx
801058fa:	e8 11 c4 ff ff       	call   80101d10 <namecmp>
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	85 c0                	test   %eax,%eax
80105904:	0f 84 ea 00 00 00    	je     801059f4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010590a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010590d:	83 ec 04             	sub    $0x4,%esp
80105910:	50                   	push   %eax
80105911:	53                   	push   %ebx
80105912:	56                   	push   %esi
80105913:	e8 18 c4 ff ff       	call   80101d30 <dirlookup>
80105918:	83 c4 10             	add    $0x10,%esp
8010591b:	85 c0                	test   %eax,%eax
8010591d:	89 c3                	mov    %eax,%ebx
8010591f:	0f 84 cf 00 00 00    	je     801059f4 <sys_unlink+0x164>
  ilock(ip);
80105925:	83 ec 0c             	sub    $0xc,%esp
80105928:	50                   	push   %eax
80105929:	e8 d2 be ff ff       	call   80101800 <ilock>
  if(ip->nlink < 1)
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105936:	0f 8e 10 01 00 00    	jle    80105a4c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010593c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105941:	74 6d                	je     801059b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105943:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105946:	83 ec 04             	sub    $0x4,%esp
80105949:	6a 10                	push   $0x10
8010594b:	6a 00                	push   $0x0
8010594d:	50                   	push   %eax
8010594e:	e8 bd f5 ff ff       	call   80104f10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105953:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105956:	6a 10                	push   $0x10
80105958:	ff 75 c4             	pushl  -0x3c(%ebp)
8010595b:	50                   	push   %eax
8010595c:	56                   	push   %esi
8010595d:	e8 7e c2 ff ff       	call   80101be0 <writei>
80105962:	83 c4 20             	add    $0x20,%esp
80105965:	83 f8 10             	cmp    $0x10,%eax
80105968:	0f 85 eb 00 00 00    	jne    80105a59 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010596e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105973:	0f 84 97 00 00 00    	je     80105a10 <sys_unlink+0x180>
  iunlockput(dp);
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	56                   	push   %esi
8010597d:	e8 0e c1 ff ff       	call   80101a90 <iunlockput>
  ip->nlink--;
80105982:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105987:	89 1c 24             	mov    %ebx,(%esp)
8010598a:	e8 c1 bd ff ff       	call   80101750 <iupdate>
  iunlockput(ip);
8010598f:	89 1c 24             	mov    %ebx,(%esp)
80105992:	e8 f9 c0 ff ff       	call   80101a90 <iunlockput>
  end_op();
80105997:	e8 f4 d3 ff ff       	call   80102d90 <end_op>
  return 0;
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	31 c0                	xor    %eax,%eax
}
801059a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a4:	5b                   	pop    %ebx
801059a5:	5e                   	pop    %esi
801059a6:	5f                   	pop    %edi
801059a7:	5d                   	pop    %ebp
801059a8:	c3                   	ret    
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059b4:	76 8d                	jbe    80105943 <sys_unlink+0xb3>
801059b6:	bf 20 00 00 00       	mov    $0x20,%edi
801059bb:	eb 0f                	jmp    801059cc <sys_unlink+0x13c>
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
801059c0:	83 c7 10             	add    $0x10,%edi
801059c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801059c6:	0f 83 77 ff ff ff    	jae    80105943 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059cc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059cf:	6a 10                	push   $0x10
801059d1:	57                   	push   %edi
801059d2:	50                   	push   %eax
801059d3:	53                   	push   %ebx
801059d4:	e8 07 c1 ff ff       	call   80101ae0 <readi>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	83 f8 10             	cmp    $0x10,%eax
801059df:	75 5e                	jne    80105a3f <sys_unlink+0x1af>
    if(de.inum != 0)
801059e1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059e6:	74 d8                	je     801059c0 <sys_unlink+0x130>
    iunlockput(ip);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	53                   	push   %ebx
801059ec:	e8 9f c0 ff ff       	call   80101a90 <iunlockput>
    goto bad;
801059f1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801059f4:	83 ec 0c             	sub    $0xc,%esp
801059f7:	56                   	push   %esi
801059f8:	e8 93 c0 ff ff       	call   80101a90 <iunlockput>
  end_op();
801059fd:	e8 8e d3 ff ff       	call   80102d90 <end_op>
  return -1;
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0a:	eb 95                	jmp    801059a1 <sys_unlink+0x111>
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105a10:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a15:	83 ec 0c             	sub    $0xc,%esp
80105a18:	56                   	push   %esi
80105a19:	e8 32 bd ff ff       	call   80101750 <iupdate>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	e9 53 ff ff ff       	jmp    80105979 <sys_unlink+0xe9>
    return -1;
80105a26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2b:	e9 71 ff ff ff       	jmp    801059a1 <sys_unlink+0x111>
    end_op();
80105a30:	e8 5b d3 ff ff       	call   80102d90 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	e9 62 ff ff ff       	jmp    801059a1 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105a3f:	83 ec 0c             	sub    $0xc,%esp
80105a42:	68 f8 99 10 80       	push   $0x801099f8
80105a47:	e8 44 a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a4c:	83 ec 0c             	sub    $0xc,%esp
80105a4f:	68 e6 99 10 80       	push   $0x801099e6
80105a54:	e8 37 a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	68 0a 9a 10 80       	push   $0x80109a0a
80105a61:	e8 2a a9 ff ff       	call   80100390 <panic>
80105a66:	8d 76 00             	lea    0x0(%esi),%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <sys_open>:

int
sys_open(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	57                   	push   %edi
80105a74:	56                   	push   %esi
80105a75:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a76:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a79:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a7c:	50                   	push   %eax
80105a7d:	6a 00                	push   $0x0
80105a7f:	e8 3c f8 ff ff       	call   801052c0 <argstr>
80105a84:	83 c4 10             	add    $0x10,%esp
80105a87:	85 c0                	test   %eax,%eax
80105a89:	0f 88 1d 01 00 00    	js     80105bac <sys_open+0x13c>
80105a8f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a92:	83 ec 08             	sub    $0x8,%esp
80105a95:	50                   	push   %eax
80105a96:	6a 01                	push   $0x1
80105a98:	e8 73 f7 ff ff       	call   80105210 <argint>
80105a9d:	83 c4 10             	add    $0x10,%esp
80105aa0:	85 c0                	test   %eax,%eax
80105aa2:	0f 88 04 01 00 00    	js     80105bac <sys_open+0x13c>
    return -1;

  begin_op();
80105aa8:	e8 73 d2 ff ff       	call   80102d20 <begin_op>

  if(omode & O_CREATE){
80105aad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ab1:	0f 85 a9 00 00 00    	jne    80105b60 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ab7:	83 ec 0c             	sub    $0xc,%esp
80105aba:	ff 75 e0             	pushl  -0x20(%ebp)
80105abd:	e8 9e c5 ff ff       	call   80102060 <namei>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	89 c6                	mov    %eax,%esi
80105ac9:	0f 84 b2 00 00 00    	je     80105b81 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	50                   	push   %eax
80105ad3:	e8 28 bd ff ff       	call   80101800 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ad8:	83 c4 10             	add    $0x10,%esp
80105adb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ae0:	0f 84 aa 00 00 00    	je     80105b90 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ae6:	e8 15 b4 ff ff       	call   80100f00 <filealloc>
80105aeb:	85 c0                	test   %eax,%eax
80105aed:	89 c7                	mov    %eax,%edi
80105aef:	0f 84 a6 00 00 00    	je     80105b9b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105af5:	e8 a6 de ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105afa:	31 db                	xor    %ebx,%ebx
80105afc:	eb 0e                	jmp    80105b0c <sys_open+0x9c>
80105afe:	66 90                	xchg   %ax,%ax
80105b00:	83 c3 01             	add    $0x1,%ebx
80105b03:	83 fb 10             	cmp    $0x10,%ebx
80105b06:	0f 84 ac 00 00 00    	je     80105bb8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105b0c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b10:	85 d2                	test   %edx,%edx
80105b12:	75 ec                	jne    80105b00 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b14:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b17:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b1b:	56                   	push   %esi
80105b1c:	e8 bf bd ff ff       	call   801018e0 <iunlock>
  end_op();
80105b21:	e8 6a d2 ff ff       	call   80102d90 <end_op>

  f->type = FD_INODE;
80105b26:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b2f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b32:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105b35:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b3c:	89 d0                	mov    %edx,%eax
80105b3e:	f7 d0                	not    %eax
80105b40:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b43:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b46:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b49:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b50:	89 d8                	mov    %ebx,%eax
80105b52:	5b                   	pop    %ebx
80105b53:	5e                   	pop    %esi
80105b54:	5f                   	pop    %edi
80105b55:	5d                   	pop    %ebp
80105b56:	c3                   	ret    
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b66:	31 c9                	xor    %ecx,%ecx
80105b68:	6a 00                	push   $0x0
80105b6a:	ba 02 00 00 00       	mov    $0x2,%edx
80105b6f:	e8 ec f7 ff ff       	call   80105360 <create>
    if(ip == 0){
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105b79:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b7b:	0f 85 65 ff ff ff    	jne    80105ae6 <sys_open+0x76>
      end_op();
80105b81:	e8 0a d2 ff ff       	call   80102d90 <end_op>
      return -1;
80105b86:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b8b:	eb c0                	jmp    80105b4d <sys_open+0xdd>
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b93:	85 c9                	test   %ecx,%ecx
80105b95:	0f 84 4b ff ff ff    	je     80105ae6 <sys_open+0x76>
    iunlockput(ip);
80105b9b:	83 ec 0c             	sub    $0xc,%esp
80105b9e:	56                   	push   %esi
80105b9f:	e8 ec be ff ff       	call   80101a90 <iunlockput>
    end_op();
80105ba4:	e8 e7 d1 ff ff       	call   80102d90 <end_op>
    return -1;
80105ba9:	83 c4 10             	add    $0x10,%esp
80105bac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bb1:	eb 9a                	jmp    80105b4d <sys_open+0xdd>
80105bb3:	90                   	nop
80105bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105bb8:	83 ec 0c             	sub    $0xc,%esp
80105bbb:	57                   	push   %edi
80105bbc:	e8 ff b3 ff ff       	call   80100fc0 <fileclose>
80105bc1:	83 c4 10             	add    $0x10,%esp
80105bc4:	eb d5                	jmp    80105b9b <sys_open+0x12b>
80105bc6:	8d 76 00             	lea    0x0(%esi),%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bd0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bd6:	e8 45 d1 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bde:	83 ec 08             	sub    $0x8,%esp
80105be1:	50                   	push   %eax
80105be2:	6a 00                	push   $0x0
80105be4:	e8 d7 f6 ff ff       	call   801052c0 <argstr>
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	85 c0                	test   %eax,%eax
80105bee:	78 30                	js     80105c20 <sys_mkdir+0x50>
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf6:	31 c9                	xor    %ecx,%ecx
80105bf8:	6a 00                	push   $0x0
80105bfa:	ba 01 00 00 00       	mov    $0x1,%edx
80105bff:	e8 5c f7 ff ff       	call   80105360 <create>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
80105c09:	74 15                	je     80105c20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c0b:	83 ec 0c             	sub    $0xc,%esp
80105c0e:	50                   	push   %eax
80105c0f:	e8 7c be ff ff       	call   80101a90 <iunlockput>
  end_op();
80105c14:	e8 77 d1 ff ff       	call   80102d90 <end_op>
  return 0;
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	31 c0                	xor    %eax,%eax
}
80105c1e:	c9                   	leave  
80105c1f:	c3                   	ret    
    end_op();
80105c20:	e8 6b d1 ff ff       	call   80102d90 <end_op>
    return -1;
80105c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c2a:	c9                   	leave  
80105c2b:	c3                   	ret    
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_mknod>:

int
sys_mknod(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c36:	e8 e5 d0 ff ff       	call   80102d20 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c3e:	83 ec 08             	sub    $0x8,%esp
80105c41:	50                   	push   %eax
80105c42:	6a 00                	push   $0x0
80105c44:	e8 77 f6 ff ff       	call   801052c0 <argstr>
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	85 c0                	test   %eax,%eax
80105c4e:	78 60                	js     80105cb0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c50:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c53:	83 ec 08             	sub    $0x8,%esp
80105c56:	50                   	push   %eax
80105c57:	6a 01                	push   $0x1
80105c59:	e8 b2 f5 ff ff       	call   80105210 <argint>
  if((argstr(0, &path)) < 0 ||
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	85 c0                	test   %eax,%eax
80105c63:	78 4b                	js     80105cb0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	50                   	push   %eax
80105c6c:	6a 02                	push   $0x2
80105c6e:	e8 9d f5 ff ff       	call   80105210 <argint>
     argint(1, &major) < 0 ||
80105c73:	83 c4 10             	add    $0x10,%esp
80105c76:	85 c0                	test   %eax,%eax
80105c78:	78 36                	js     80105cb0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105c7e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c81:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105c85:	ba 03 00 00 00       	mov    $0x3,%edx
80105c8a:	50                   	push   %eax
80105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c8e:	e8 cd f6 ff ff       	call   80105360 <create>
80105c93:	83 c4 10             	add    $0x10,%esp
80105c96:	85 c0                	test   %eax,%eax
80105c98:	74 16                	je     80105cb0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	50                   	push   %eax
80105c9e:	e8 ed bd ff ff       	call   80101a90 <iunlockput>
  end_op();
80105ca3:	e8 e8 d0 ff ff       	call   80102d90 <end_op>
  return 0;
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	31 c0                	xor    %eax,%eax
}
80105cad:	c9                   	leave  
80105cae:	c3                   	ret    
80105caf:	90                   	nop
    end_op();
80105cb0:	e8 db d0 ff ff       	call   80102d90 <end_op>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_chdir>:

int
sys_chdir(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	56                   	push   %esi
80105cc4:	53                   	push   %ebx
80105cc5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cc8:	e8 d3 dc ff ff       	call   801039a0 <myproc>
80105ccd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ccf:	e8 4c d0 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd7:	83 ec 08             	sub    $0x8,%esp
80105cda:	50                   	push   %eax
80105cdb:	6a 00                	push   $0x0
80105cdd:	e8 de f5 ff ff       	call   801052c0 <argstr>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 77                	js     80105d60 <sys_chdir+0xa0>
80105ce9:	83 ec 0c             	sub    $0xc,%esp
80105cec:	ff 75 f4             	pushl  -0xc(%ebp)
80105cef:	e8 6c c3 ff ff       	call   80102060 <namei>
80105cf4:	83 c4 10             	add    $0x10,%esp
80105cf7:	85 c0                	test   %eax,%eax
80105cf9:	89 c3                	mov    %eax,%ebx
80105cfb:	74 63                	je     80105d60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	50                   	push   %eax
80105d01:	e8 fa ba ff ff       	call   80101800 <ilock>
  if(ip->type != T_DIR){
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d0e:	75 30                	jne    80105d40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	53                   	push   %ebx
80105d14:	e8 c7 bb ff ff       	call   801018e0 <iunlock>
  iput(curproc->cwd);
80105d19:	58                   	pop    %eax
80105d1a:	ff 76 68             	pushl  0x68(%esi)
80105d1d:	e8 0e bc ff ff       	call   80101930 <iput>
  end_op();
80105d22:	e8 69 d0 ff ff       	call   80102d90 <end_op>
  curproc->cwd = ip;
80105d27:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	31 c0                	xor    %eax,%eax
}
80105d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d32:	5b                   	pop    %ebx
80105d33:	5e                   	pop    %esi
80105d34:	5d                   	pop    %ebp
80105d35:	c3                   	ret    
80105d36:	8d 76 00             	lea    0x0(%esi),%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 47 bd ff ff       	call   80101a90 <iunlockput>
    end_op();
80105d49:	e8 42 d0 ff ff       	call   80102d90 <end_op>
    return -1;
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	eb d7                	jmp    80105d2f <sys_chdir+0x6f>
80105d58:	90                   	nop
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d60:	e8 2b d0 ff ff       	call   80102d90 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6a:	eb c3                	jmp    80105d2f <sys_chdir+0x6f>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_exec>:

int
sys_exec(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d76:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d82:	50                   	push   %eax
80105d83:	6a 00                	push   $0x0
80105d85:	e8 36 f5 ff ff       	call   801052c0 <argstr>
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	0f 88 87 00 00 00    	js     80105e1c <sys_exec+0xac>
80105d95:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d9b:	83 ec 08             	sub    $0x8,%esp
80105d9e:	50                   	push   %eax
80105d9f:	6a 01                	push   $0x1
80105da1:	e8 6a f4 ff ff       	call   80105210 <argint>
80105da6:	83 c4 10             	add    $0x10,%esp
80105da9:	85 c0                	test   %eax,%eax
80105dab:	78 6f                	js     80105e1c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105dad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105db3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105db6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105db8:	68 80 00 00 00       	push   $0x80
80105dbd:	6a 00                	push   $0x0
80105dbf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105dc5:	50                   	push   %eax
80105dc6:	e8 45 f1 ff ff       	call   80104f10 <memset>
80105dcb:	83 c4 10             	add    $0x10,%esp
80105dce:	eb 2c                	jmp    80105dfc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105dd0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	74 56                	je     80105e30 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105dda:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105de0:	83 ec 08             	sub    $0x8,%esp
80105de3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105de6:	52                   	push   %edx
80105de7:	50                   	push   %eax
80105de8:	e8 b3 f3 ff ff       	call   801051a0 <fetchstr>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	78 28                	js     80105e1c <sys_exec+0xac>
  for(i=0;; i++){
80105df4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105df7:	83 fb 20             	cmp    $0x20,%ebx
80105dfa:	74 20                	je     80105e1c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dfc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e02:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e09:	83 ec 08             	sub    $0x8,%esp
80105e0c:	57                   	push   %edi
80105e0d:	01 f0                	add    %esi,%eax
80105e0f:	50                   	push   %eax
80105e10:	e8 4b f3 ff ff       	call   80105160 <fetchint>
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	85 c0                	test   %eax,%eax
80105e1a:	79 b4                	jns    80105dd0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e24:	5b                   	pop    %ebx
80105e25:	5e                   	pop    %esi
80105e26:	5f                   	pop    %edi
80105e27:	5d                   	pop    %ebp
80105e28:	c3                   	ret    
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e30:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e36:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105e39:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e40:	00 00 00 00 
  return exec(path, argv);
80105e44:	50                   	push   %eax
80105e45:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e4b:	e8 c0 ab ff ff       	call   80100a10 <exec>
80105e50:	83 c4 10             	add    $0x10,%esp
}
80105e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e56:	5b                   	pop    %ebx
80105e57:	5e                   	pop    %esi
80105e58:	5f                   	pop    %edi
80105e59:	5d                   	pop    %ebp
80105e5a:	c3                   	ret    
80105e5b:	90                   	nop
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e60 <sys_pipe>:

int
sys_pipe(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	57                   	push   %edi
80105e64:	56                   	push   %esi
80105e65:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e66:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e69:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e6c:	6a 08                	push   $0x8
80105e6e:	50                   	push   %eax
80105e6f:	6a 00                	push   $0x0
80105e71:	e8 ea f3 ff ff       	call   80105260 <argptr>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	0f 88 ae 00 00 00    	js     80105f2f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e81:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e84:	83 ec 08             	sub    $0x8,%esp
80105e87:	50                   	push   %eax
80105e88:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e8b:	50                   	push   %eax
80105e8c:	e8 2f d5 ff ff       	call   801033c0 <pipealloc>
80105e91:	83 c4 10             	add    $0x10,%esp
80105e94:	85 c0                	test   %eax,%eax
80105e96:	0f 88 93 00 00 00    	js     80105f2f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e9c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e9f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ea1:	e8 fa da ff ff       	call   801039a0 <myproc>
80105ea6:	eb 10                	jmp    80105eb8 <sys_pipe+0x58>
80105ea8:	90                   	nop
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105eb0:	83 c3 01             	add    $0x1,%ebx
80105eb3:	83 fb 10             	cmp    $0x10,%ebx
80105eb6:	74 60                	je     80105f18 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105eb8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ebc:	85 f6                	test   %esi,%esi
80105ebe:	75 f0                	jne    80105eb0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ec0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ec3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ec7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105eca:	e8 d1 da ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ecf:	31 d2                	xor    %edx,%edx
80105ed1:	eb 0d                	jmp    80105ee0 <sys_pipe+0x80>
80105ed3:	90                   	nop
80105ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ed8:	83 c2 01             	add    $0x1,%edx
80105edb:	83 fa 10             	cmp    $0x10,%edx
80105ede:	74 28                	je     80105f08 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105ee0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ee4:	85 c9                	test   %ecx,%ecx
80105ee6:	75 f0                	jne    80105ed8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105ee8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ef4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ef7:	31 c0                	xor    %eax,%eax
}
80105ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105efc:	5b                   	pop    %ebx
80105efd:	5e                   	pop    %esi
80105efe:	5f                   	pop    %edi
80105eff:	5d                   	pop    %ebp
80105f00:	c3                   	ret    
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105f08:	e8 93 da ff ff       	call   801039a0 <myproc>
80105f0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f14:	00 
80105f15:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105f18:	83 ec 0c             	sub    $0xc,%esp
80105f1b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f1e:	e8 9d b0 ff ff       	call   80100fc0 <fileclose>
    fileclose(wf);
80105f23:	58                   	pop    %eax
80105f24:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f27:	e8 94 b0 ff ff       	call   80100fc0 <fileclose>
    return -1;
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f34:	eb c3                	jmp    80105ef9 <sys_pipe+0x99>
80105f36:	66 90                	xchg   %ax,%ax
80105f38:	66 90                	xchg   %ax,%ax
80105f3a:	66 90                	xchg   %ax,%ax
80105f3c:	66 90                	xchg   %ax,%ax
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105f43:	5d                   	pop    %ebp
  return fork();
80105f44:	e9 27 dc ff ff       	jmp    80103b70 <fork>
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f50 <sys_exit>:

int
sys_exit(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f56:	e8 d5 df ff ff       	call   80103f30 <exit>
  return 0;  // not reached
}
80105f5b:	31 c0                	xor    %eax,%eax
80105f5d:	c9                   	leave  
80105f5e:	c3                   	ret    
80105f5f:	90                   	nop

80105f60 <sys_wait>:

int
sys_wait(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105f63:	5d                   	pop    %ebp
  return wait();
80105f64:	e9 87 e3 ff ff       	jmp    801042f0 <wait>
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <sys_kill>:

int
sys_kill(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f79:	50                   	push   %eax
80105f7a:	6a 00                	push   $0x0
80105f7c:	e8 8f f2 ff ff       	call   80105210 <argint>
80105f81:	83 c4 10             	add    $0x10,%esp
80105f84:	85 c0                	test   %eax,%eax
80105f86:	78 18                	js     80105fa0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8e:	e8 cd e5 ff ff       	call   80104560 <kill>
80105f93:	83 c4 10             	add    $0x10,%esp
}
80105f96:	c9                   	leave  
80105f97:	c3                   	ret    
80105f98:	90                   	nop
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa5:	c9                   	leave  
80105fa6:	c3                   	ret    
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fb0 <sys_getppid>:

int
sys_getppid(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80105fb6:	e8 e5 d9 ff ff       	call   801039a0 <myproc>
80105fbb:	8b 40 14             	mov    0x14(%eax),%eax
80105fbe:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fc1:	c9                   	leave  
80105fc2:	c3                   	ret    
80105fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fd0 <sys_getpid>:

int
sys_getpid(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fd6:	e8 c5 d9 ff ff       	call   801039a0 <myproc>
80105fdb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fde:	c9                   	leave  
80105fdf:	c3                   	ret    

80105fe0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fe4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fe7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fea:	50                   	push   %eax
80105feb:	6a 00                	push   $0x0
80105fed:	e8 1e f2 ff ff       	call   80105210 <argint>
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	78 27                	js     80106020 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ff9:	e8 a2 d9 ff ff       	call   801039a0 <myproc>
  if(growproc(n) < 0)
80105ffe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106001:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106003:	ff 75 f4             	pushl  -0xc(%ebp)
80106006:	e8 c5 da ff ff       	call   80103ad0 <growproc>
8010600b:	83 c4 10             	add    $0x10,%esp
8010600e:	85 c0                	test   %eax,%eax
80106010:	78 0e                	js     80106020 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106012:	89 d8                	mov    %ebx,%eax
80106014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106017:	c9                   	leave  
80106018:	c3                   	ret    
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106020:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106025:	eb eb                	jmp    80106012 <sys_sbrk+0x32>
80106027:	89 f6                	mov    %esi,%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <sys_sleep>:

int
sys_sleep(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106034:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106037:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010603a:	50                   	push   %eax
8010603b:	6a 00                	push   $0x0
8010603d:	e8 ce f1 ff ff       	call   80105210 <argint>
80106042:	83 c4 10             	add    $0x10,%esp
80106045:	85 c0                	test   %eax,%eax
80106047:	0f 88 8a 00 00 00    	js     801060d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010604d:	83 ec 0c             	sub    $0xc,%esp
80106050:	68 c0 9e 11 80       	push   $0x80119ec0
80106055:	e8 86 ed ff ff       	call   80104de0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010605a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010605d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106060:	8b 1d 00 a7 11 80    	mov    0x8011a700,%ebx
  while(ticks - ticks0 < n){
80106066:	85 d2                	test   %edx,%edx
80106068:	75 27                	jne    80106091 <sys_sleep+0x61>
8010606a:	eb 54                	jmp    801060c0 <sys_sleep+0x90>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106070:	83 ec 08             	sub    $0x8,%esp
80106073:	68 c0 9e 11 80       	push   $0x80119ec0
80106078:	68 00 a7 11 80       	push   $0x8011a700
8010607d:	e8 3e e1 ff ff       	call   801041c0 <sleep>
  while(ticks - ticks0 < n){
80106082:	a1 00 a7 11 80       	mov    0x8011a700,%eax
80106087:	83 c4 10             	add    $0x10,%esp
8010608a:	29 d8                	sub    %ebx,%eax
8010608c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010608f:	73 2f                	jae    801060c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106091:	e8 0a d9 ff ff       	call   801039a0 <myproc>
80106096:	8b 40 24             	mov    0x24(%eax),%eax
80106099:	85 c0                	test   %eax,%eax
8010609b:	74 d3                	je     80106070 <sys_sleep+0x40>
      release(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 c0 9e 11 80       	push   $0x80119ec0
801060a5:	e8 f6 ed ff ff       	call   80104ea0 <release>
      return -1;
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801060b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060b5:	c9                   	leave  
801060b6:	c3                   	ret    
801060b7:	89 f6                	mov    %esi,%esi
801060b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	68 c0 9e 11 80       	push   $0x80119ec0
801060c8:	e8 d3 ed ff ff       	call   80104ea0 <release>
  return 0;
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	31 c0                	xor    %eax,%eax
}
801060d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    
    return -1;
801060d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060dc:	eb f4                	jmp    801060d2 <sys_sleep+0xa2>
801060de:	66 90                	xchg   %ax,%ax

801060e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	53                   	push   %ebx
801060e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060e7:	68 c0 9e 11 80       	push   $0x80119ec0
801060ec:	e8 ef ec ff ff       	call   80104de0 <acquire>
  xticks = ticks;
801060f1:	8b 1d 00 a7 11 80    	mov    0x8011a700,%ebx
  release(&tickslock);
801060f7:	c7 04 24 c0 9e 11 80 	movl   $0x80119ec0,(%esp)
801060fe:	e8 9d ed ff ff       	call   80104ea0 <release>
  return xticks;
}
80106103:	89 d8                	mov    %ebx,%eax
80106105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106108:	c9                   	leave  
80106109:	c3                   	ret    
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106110 <sys_yield>:

int
sys_yield(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 08             	sub    $0x8,%esp
  yield();
80106116:	e8 55 e0 ff ff       	call   80104170 <yield>

  return 0;
}
8010611b:	31 c0                	xor    %eax,%eax
8010611d:	c9                   	leave  
8010611e:	c3                   	ret    
8010611f:	90                   	nop

80106120 <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 20             	sub    $0x20,%esp
	int share;
	if(argint(0, &share) < 0)
80106126:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106129:	50                   	push   %eax
8010612a:	6a 00                	push   $0x0
8010612c:	e8 df f0 ff ff       	call   80105210 <argint>
80106131:	83 c4 10             	add    $0x10,%esp
80106134:	85 c0                	test   %eax,%eax
80106136:	78 18                	js     80106150 <sys_set_cpu_share+0x30>
		return -1;

	return set_cpu_share(share);
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	ff 75 f4             	pushl  -0xc(%ebp)
8010613e:	e8 fd 22 00 00       	call   80108440 <set_cpu_share>
80106143:	83 c4 10             	add    $0x10,%esp
}
80106146:	c9                   	leave  
80106147:	c3                   	ret    
80106148:	90                   	nop
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80106150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106155:	c9                   	leave  
80106156:	c3                   	ret    
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106160 <sys_getlev>:

int
sys_getlev(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
	return getlev();
}
80106163:	5d                   	pop    %ebp
	return getlev();
80106164:	e9 c7 1d 00 00       	jmp    80107f30 <getlev>
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106170 <sys_thread_create>:

int
sys_thread_create(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 20             	sub    $0x20,%esp
  int thread;
  int start_routine;
  int arg;

  if((argint(0, &thread) < 0) || (argint(1, &start_routine) < 0) || (argint(2, &arg) < 0))
80106176:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106179:	50                   	push   %eax
8010617a:	6a 00                	push   $0x0
8010617c:	e8 8f f0 ff ff       	call   80105210 <argint>
80106181:	83 c4 10             	add    $0x10,%esp
80106184:	85 c0                	test   %eax,%eax
80106186:	78 48                	js     801061d0 <sys_thread_create+0x60>
80106188:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010618b:	83 ec 08             	sub    $0x8,%esp
8010618e:	50                   	push   %eax
8010618f:	6a 01                	push   $0x1
80106191:	e8 7a f0 ff ff       	call   80105210 <argint>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	78 33                	js     801061d0 <sys_thread_create+0x60>
8010619d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061a0:	83 ec 08             	sub    $0x8,%esp
801061a3:	50                   	push   %eax
801061a4:	6a 02                	push   $0x2
801061a6:	e8 65 f0 ff ff       	call   80105210 <argint>
801061ab:	83 c4 10             	add    $0x10,%esp
801061ae:	85 c0                	test   %eax,%eax
801061b0:	78 1e                	js     801061d0 <sys_thread_create+0x60>
	return -1;

  return thread_create((thread_t*)thread, (void *)start_routine, (void *)arg);
801061b2:	83 ec 04             	sub    $0x4,%esp
801061b5:	ff 75 f4             	pushl  -0xc(%ebp)
801061b8:	ff 75 f0             	pushl  -0x10(%ebp)
801061bb:	ff 75 ec             	pushl  -0x14(%ebp)
801061be:	e8 ed e4 ff ff       	call   801046b0 <thread_create>
801061c3:	83 c4 10             	add    $0x10,%esp
}
801061c6:	c9                   	leave  
801061c7:	c3                   	ret    
801061c8:	90                   	nop
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
801061d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
801061d7:	89 f6                	mov    %esi,%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061e0 <sys_thread_exit>:

int
sys_thread_exit(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	83 ec 20             	sub    $0x20,%esp
  int retval;

  if(argint(0, &retval) < 0)
801061e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061e9:	50                   	push   %eax
801061ea:	6a 00                	push   $0x0
801061ec:	e8 1f f0 ff ff       	call   80105210 <argint>
801061f1:	83 c4 10             	add    $0x10,%esp
801061f4:	85 c0                	test   %eax,%eax
801061f6:	78 18                	js     80106210 <sys_thread_exit+0x30>
	return -1;

  thread_exit((void *)retval);
801061f8:	83 ec 0c             	sub    $0xc,%esp
801061fb:	ff 75 f4             	pushl  -0xc(%ebp)
801061fe:	e8 0d e7 ff ff       	call   80104910 <thread_exit>

  return 0;
80106203:	83 c4 10             	add    $0x10,%esp
80106206:	31 c0                	xor    %eax,%eax
}
80106208:	c9                   	leave  
80106209:	c3                   	ret    
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	return -1;
80106210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106220 <sys_thread_join>:

int
sys_thread_join(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 20             	sub    $0x20,%esp
  int thread;
  int retval;

  if((argint(0, &thread) < 0) || (argint(1, &retval) < 0))
80106226:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106229:	50                   	push   %eax
8010622a:	6a 00                	push   $0x0
8010622c:	e8 df ef ff ff       	call   80105210 <argint>
80106231:	83 c4 10             	add    $0x10,%esp
80106234:	85 c0                	test   %eax,%eax
80106236:	78 28                	js     80106260 <sys_thread_join+0x40>
80106238:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010623b:	83 ec 08             	sub    $0x8,%esp
8010623e:	50                   	push   %eax
8010623f:	6a 01                	push   $0x1
80106241:	e8 ca ef ff ff       	call   80105210 <argint>
80106246:	83 c4 10             	add    $0x10,%esp
80106249:	85 c0                	test   %eax,%eax
8010624b:	78 13                	js     80106260 <sys_thread_join+0x40>
	return -1;

  return thread_join((thread_t)thread, (void **)retval);
8010624d:	83 ec 08             	sub    $0x8,%esp
80106250:	ff 75 f4             	pushl  -0xc(%ebp)
80106253:	ff 75 f0             	pushl  -0x10(%ebp)
80106256:	e8 75 e7 ff ff       	call   801049d0 <thread_join>
8010625b:	83 c4 10             	add    $0x10,%esp
}
8010625e:	c9                   	leave  
8010625f:	c3                   	ret    
	return -1;
80106260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106265:	c9                   	leave  
80106266:	c3                   	ret    
80106267:	89 f6                	mov    %esi,%esi
80106269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106270 <sys_xem_init>:

int
sys_xem_init(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	83 ec 20             	sub    $0x20,%esp
  int semaphore;

  if(argint(0, &semaphore) < 0)
80106276:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106279:	50                   	push   %eax
8010627a:	6a 00                	push   $0x0
8010627c:	e8 8f ef ff ff       	call   80105210 <argint>
80106281:	83 c4 10             	add    $0x10,%esp
80106284:	85 c0                	test   %eax,%eax
80106286:	78 18                	js     801062a0 <sys_xem_init+0x30>
	return -1;

  return xem_init((xem_t *)semaphore);
80106288:	83 ec 0c             	sub    $0xc,%esp
8010628b:	ff 75 f4             	pushl  -0xc(%ebp)
8010628e:	e8 0d d6 ff ff       	call   801038a0 <xem_init>
80106293:	83 c4 10             	add    $0x10,%esp
}
80106296:	c9                   	leave  
80106297:	c3                   	ret    
80106298:	90                   	nop
80106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
801062a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062a5:	c9                   	leave  
801062a6:	c3                   	ret    
801062a7:	89 f6                	mov    %esi,%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062b0 <sys_xem_wait>:

int
sys_xem_wait(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 20             	sub    $0x20,%esp
  int semaphore;

  if(argint(0, &semaphore) < 0)
801062b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b9:	50                   	push   %eax
801062ba:	6a 00                	push   $0x0
801062bc:	e8 4f ef ff ff       	call   80105210 <argint>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	78 18                	js     801062e0 <sys_xem_wait+0x30>
	return -1;

  return xem_wait((xem_t *)semaphore);
801062c8:	83 ec 0c             	sub    $0xc,%esp
801062cb:	ff 75 f4             	pushl  -0xc(%ebp)
801062ce:	e8 ad df ff ff       	call   80104280 <xem_wait>
801062d3:	83 c4 10             	add    $0x10,%esp
}
801062d6:	c9                   	leave  
801062d7:	c3                   	ret    
801062d8:	90                   	nop
801062d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
801062e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062f0 <sys_xem_unlock>:

int
sys_xem_unlock(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 20             	sub    $0x20,%esp
  int semaphore;

  if(argint(0, &semaphore) < 0)
801062f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062f9:	50                   	push   %eax
801062fa:	6a 00                	push   $0x0
801062fc:	e8 0f ef ff ff       	call   80105210 <argint>
80106301:	83 c4 10             	add    $0x10,%esp
80106304:	85 c0                	test   %eax,%eax
80106306:	78 18                	js     80106320 <sys_xem_unlock+0x30>
	return -1;

  return xem_unlock((xem_t *)semaphore);
80106308:	83 ec 0c             	sub    $0xc,%esp
8010630b:	ff 75 f4             	pushl  -0xc(%ebp)
8010630e:	e8 3d e1 ff ff       	call   80104450 <xem_unlock>
80106313:	83 c4 10             	add    $0x10,%esp
}
80106316:	c9                   	leave  
80106317:	c3                   	ret    
80106318:	90                   	nop
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
80106320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106325:	c9                   	leave  
80106326:	c3                   	ret    
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106330 <sys_rwlock_init>:

int
sys_rwlock_init(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 20             	sub    $0x20,%esp
  int rwlock;

  if(argint(0, &rwlock) < 0)
80106336:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106339:	50                   	push   %eax
8010633a:	6a 00                	push   $0x0
8010633c:	e8 cf ee ff ff       	call   80105210 <argint>
80106341:	83 c4 10             	add    $0x10,%esp
80106344:	85 c0                	test   %eax,%eax
80106346:	78 18                	js     80106360 <sys_rwlock_init+0x30>
	return -1;

  return rwlock_init((rwlock_t *)rwlock);
80106348:	83 ec 0c             	sub    $0xc,%esp
8010634b:	ff 75 f4             	pushl  -0xc(%ebp)
8010634e:	e8 6d d5 ff ff       	call   801038c0 <rwlock_init>
80106353:	83 c4 10             	add    $0x10,%esp
}
80106356:	c9                   	leave  
80106357:	c3                   	ret    
80106358:	90                   	nop
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
80106360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106365:	c9                   	leave  
80106366:	c3                   	ret    
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106370 <sys_rwlock_acquire_readlock>:

int
sys_rwlock_acquire_readlock(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	83 ec 20             	sub    $0x20,%esp
  int rwlock;

  if(argint(0, &rwlock) < 0)
80106376:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106379:	50                   	push   %eax
8010637a:	6a 00                	push   $0x0
8010637c:	e8 8f ee ff ff       	call   80105210 <argint>
80106381:	83 c4 10             	add    $0x10,%esp
80106384:	85 c0                	test   %eax,%eax
80106386:	78 18                	js     801063a0 <sys_rwlock_acquire_readlock+0x30>
	return -1;

  return rwlock_acquire_readlock((rwlock_t *)rwlock);
80106388:	83 ec 0c             	sub    $0xc,%esp
8010638b:	ff 75 f4             	pushl  -0xc(%ebp)
8010638e:	e8 0d e1 ff ff       	call   801044a0 <rwlock_acquire_readlock>
80106393:	83 c4 10             	add    $0x10,%esp
}
80106396:	c9                   	leave  
80106397:	c3                   	ret    
80106398:	90                   	nop
80106399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
801063a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063a5:	c9                   	leave  
801063a6:	c3                   	ret    
801063a7:	89 f6                	mov    %esi,%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <sys_rwlock_release_readlock>:

int
sys_rwlock_release_readlock(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 20             	sub    $0x20,%esp
  int rwlock;

  if(argint(0, &rwlock) < 0)
801063b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063b9:	50                   	push   %eax
801063ba:	6a 00                	push   $0x0
801063bc:	e8 4f ee ff ff       	call   80105210 <argint>
801063c1:	83 c4 10             	add    $0x10,%esp
801063c4:	85 c0                	test   %eax,%eax
801063c6:	78 18                	js     801063e0 <sys_rwlock_release_readlock+0x30>
	return -1;

  return rwlock_release_readlock((rwlock_t *)rwlock);
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	ff 75 f4             	pushl  -0xc(%ebp)
801063ce:	e8 2d e1 ff ff       	call   80104500 <rwlock_release_readlock>
801063d3:	83 c4 10             	add    $0x10,%esp
}
801063d6:	c9                   	leave  
801063d7:	c3                   	ret    
801063d8:	90                   	nop
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
801063e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    
801063e7:	89 f6                	mov    %esi,%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063f0 <sys_rwlock_acquire_writelock>:

int
sys_rwlock_acquire_writelock(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	83 ec 20             	sub    $0x20,%esp
  int rwlock;

  if(argint(0, &rwlock) < 0)
801063f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063f9:	50                   	push   %eax
801063fa:	6a 00                	push   $0x0
801063fc:	e8 0f ee ff ff       	call   80105210 <argint>
80106401:	83 c4 10             	add    $0x10,%esp
80106404:	85 c0                	test   %eax,%eax
80106406:	78 18                	js     80106420 <sys_rwlock_acquire_writelock+0x30>
	return -1;

  return rwlock_acquire_writelock((rwlock_t *)rwlock);
80106408:	83 ec 0c             	sub    $0xc,%esp
8010640b:	ff 75 f4             	pushl  -0xc(%ebp)
8010640e:	e8 bd de ff ff       	call   801042d0 <rwlock_acquire_writelock>
80106413:	83 c4 10             	add    $0x10,%esp
}
80106416:	c9                   	leave  
80106417:	c3                   	ret    
80106418:	90                   	nop
80106419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
80106420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    
80106427:	89 f6                	mov    %esi,%esi
80106429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106430 <sys_rwlock_release_writelock>:

int
sys_rwlock_release_writelock(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 20             	sub    $0x20,%esp
  int rwlock;

  if(argint(0, &rwlock) < 0)
80106436:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106439:	50                   	push   %eax
8010643a:	6a 00                	push   $0x0
8010643c:	e8 cf ed ff ff       	call   80105210 <argint>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	78 18                	js     80106460 <sys_rwlock_release_writelock+0x30>
	return -1;

  return rwlock_release_writelock((rwlock_t *)rwlock);
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	ff 75 f4             	pushl  -0xc(%ebp)
8010644e:	e8 ed e0 ff ff       	call   80104540 <rwlock_release_writelock>
80106453:	83 c4 10             	add    $0x10,%esp
}
80106456:	c9                   	leave  
80106457:	c3                   	ret    
80106458:	90                   	nop
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106465:	c9                   	leave  
80106466:	c3                   	ret    

80106467 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106467:	1e                   	push   %ds
  pushl %es
80106468:	06                   	push   %es
  pushl %fs
80106469:	0f a0                	push   %fs
  pushl %gs
8010646b:	0f a8                	push   %gs
  pushal
8010646d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010646e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106472:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106474:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106476:	54                   	push   %esp
  call trap
80106477:	e8 c4 00 00 00       	call   80106540 <trap>
  addl $4, %esp
8010647c:	83 c4 04             	add    $0x4,%esp

8010647f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010647f:	61                   	popa   
  popl %gs
80106480:	0f a9                	pop    %gs
  popl %fs
80106482:	0f a1                	pop    %fs
  popl %es
80106484:	07                   	pop    %es
  popl %ds
80106485:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106486:	83 c4 08             	add    $0x8,%esp
  iret
80106489:	cf                   	iret   
8010648a:	66 90                	xchg   %ax,%ax
8010648c:	66 90                	xchg   %ax,%ax
8010648e:	66 90                	xchg   %ax,%ax

80106490 <tvinit>:
extern void priority_boost(void);
extern void update_pass(struct proc*);

void
tvinit(void)
{
80106490:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106491:	31 c0                	xor    %eax,%eax
{
80106493:	89 e5                	mov    %esp,%ebp
80106495:	83 ec 08             	sub    $0x8,%esp
80106498:	90                   	nop
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801064a0:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
801064a7:	c7 04 c5 02 9f 11 80 	movl   $0x8e000008,-0x7fee60fe(,%eax,8)
801064ae:	08 00 00 8e 
801064b2:	66 89 14 c5 00 9f 11 	mov    %dx,-0x7fee6100(,%eax,8)
801064b9:	80 
801064ba:	c1 ea 10             	shr    $0x10,%edx
801064bd:	66 89 14 c5 06 9f 11 	mov    %dx,-0x7fee60fa(,%eax,8)
801064c4:	80 
  for(i = 0; i < 256; i++)
801064c5:	83 c0 01             	add    $0x1,%eax
801064c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801064cd:	75 d1                	jne    801064a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064cf:	a1 0c c1 10 80       	mov    0x8010c10c,%eax

  initlock(&tickslock, "time");
801064d4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064d7:	c7 05 02 a1 11 80 08 	movl   $0xef000008,0x8011a102
801064de:	00 00 ef 
  initlock(&tickslock, "time");
801064e1:	68 19 9a 10 80       	push   $0x80109a19
801064e6:	68 c0 9e 11 80       	push   $0x80119ec0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064eb:	66 a3 00 a1 11 80    	mov    %ax,0x8011a100
801064f1:	c1 e8 10             	shr    $0x10,%eax
801064f4:	66 a3 06 a1 11 80    	mov    %ax,0x8011a106
  initlock(&tickslock, "time");
801064fa:	e8 a1 e7 ff ff       	call   80104ca0 <initlock>
}
801064ff:	83 c4 10             	add    $0x10,%esp
80106502:	c9                   	leave  
80106503:	c3                   	ret    
80106504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010650a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106510 <idtinit>:

void
idtinit(void)
{
80106510:	55                   	push   %ebp
  pd[0] = size-1;
80106511:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106516:	89 e5                	mov    %esp,%ebp
80106518:	83 ec 10             	sub    $0x10,%esp
8010651b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010651f:	b8 00 9f 11 80       	mov    $0x80119f00,%eax
80106524:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106528:	c1 e8 10             	shr    $0x10,%eax
8010652b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010652f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106532:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106535:	c9                   	leave  
80106536:	c3                   	ret    
80106537:	89 f6                	mov    %esi,%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106540 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	57                   	push   %edi
80106544:	56                   	push   %esi
80106545:	53                   	push   %ebx
80106546:	83 ec 2c             	sub    $0x2c,%esp
80106549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010654c:	8b 43 30             	mov    0x30(%ebx),%eax
8010654f:	83 f8 40             	cmp    $0x40,%eax
80106552:	0f 84 08 01 00 00    	je     80106660 <trap+0x120>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106558:	83 e8 20             	sub    $0x20,%eax
8010655b:	83 f8 1f             	cmp    $0x1f,%eax
8010655e:	77 10                	ja     80106570 <trap+0x30>
80106560:	ff 24 85 c8 9a 10 80 	jmp    *-0x7fef6538(,%eax,4)
80106567:	89 f6                	mov    %esi,%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106570:	e8 2b d4 ff ff       	call   801039a0 <myproc>
80106575:	85 c0                	test   %eax,%eax
80106577:	8b 73 38             	mov    0x38(%ebx),%esi
8010657a:	0f 84 f7 03 00 00    	je     80106977 <trap+0x437>
80106580:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106584:	0f 84 ed 03 00 00    	je     80106977 <trap+0x437>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010658a:	0f 20 d1             	mov    %cr2,%ecx
8010658d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
80106590:	e8 eb d3 ff ff       	call   80103980 <cpuid>
80106595:	8b 7b 30             	mov    0x30(%ebx),%edi
80106598:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010659b:	8b 43 34             	mov    0x34(%ebx),%eax
8010659e:	89 7d e0             	mov    %edi,-0x20(%ebp)
801065a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->tid, myproc()->name, tf->trapno,
801065a4:	e8 f7 d3 ff ff       	call   801039a0 <myproc>
801065a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801065ac:	e8 ef d3 ff ff       	call   801039a0 <myproc>
    cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
801065b1:	8b b8 a0 00 00 00    	mov    0xa0(%eax),%edi
            myproc()->pid, myproc()->tid, myproc()->name, tf->trapno,
801065b7:	e8 e4 d3 ff ff       	call   801039a0 <myproc>
    cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
801065bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
801065bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
801065c2:	83 ec 0c             	sub    $0xc,%esp
801065c5:	51                   	push   %ecx
801065c6:	56                   	push   %esi
801065c7:	52                   	push   %edx
            myproc()->pid, myproc()->tid, myproc()->name, tf->trapno,
801065c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
    cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
801065cb:	ff 75 e4             	pushl  -0x1c(%ebp)
801065ce:	ff 75 e0             	pushl  -0x20(%ebp)
            myproc()->pid, myproc()->tid, myproc()->name, tf->trapno,
801065d1:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d tid %d %s: trap %d err %d on cpu %d "
801065d4:	52                   	push   %edx
801065d5:	57                   	push   %edi
801065d6:	ff 70 10             	pushl  0x10(%eax)
801065d9:	68 7c 9a 10 80       	push   $0x80109a7c
801065de:	e8 7d a0 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801065e3:	83 c4 30             	add    $0x30,%esp
801065e6:	e8 b5 d3 ff ff       	call   801039a0 <myproc>
801065eb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065f2:	e8 a9 d3 ff ff       	call   801039a0 <myproc>
801065f7:	85 c0                	test   %eax,%eax
801065f9:	74 1d                	je     80106618 <trap+0xd8>
801065fb:	e8 a0 d3 ff ff       	call   801039a0 <myproc>
80106600:	8b 40 24             	mov    0x24(%eax),%eax
80106603:	85 c0                	test   %eax,%eax
80106605:	74 11                	je     80106618 <trap+0xd8>
80106607:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010660b:	83 e0 03             	and    $0x3,%eax
8010660e:	66 83 f8 03          	cmp    $0x3,%ax
80106612:	0f 84 08 02 00 00    	je     80106820 <trap+0x2e0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106618:	e8 83 d3 ff ff       	call   801039a0 <myproc>
8010661d:	85 c0                	test   %eax,%eax
8010661f:	74 0b                	je     8010662c <trap+0xec>
80106621:	e8 7a d3 ff ff       	call   801039a0 <myproc>
80106626:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010662a:	74 6c                	je     80106698 <trap+0x158>
	}

  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010662c:	e8 6f d3 ff ff       	call   801039a0 <myproc>
80106631:	85 c0                	test   %eax,%eax
80106633:	74 19                	je     8010664e <trap+0x10e>
80106635:	e8 66 d3 ff ff       	call   801039a0 <myproc>
8010663a:	8b 40 24             	mov    0x24(%eax),%eax
8010663d:	85 c0                	test   %eax,%eax
8010663f:	74 0d                	je     8010664e <trap+0x10e>
80106641:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106645:	83 e0 03             	and    $0x3,%eax
80106648:	66 83 f8 03          	cmp    $0x3,%ax
8010664c:	74 3b                	je     80106689 <trap+0x149>
    exit();
}
8010664e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106651:	5b                   	pop    %ebx
80106652:	5e                   	pop    %esi
80106653:	5f                   	pop    %edi
80106654:	5d                   	pop    %ebp
80106655:	c3                   	ret    
80106656:	8d 76 00             	lea    0x0(%esi),%esi
80106659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80106660:	e8 3b d3 ff ff       	call   801039a0 <myproc>
80106665:	8b 40 24             	mov    0x24(%eax),%eax
80106668:	85 c0                	test   %eax,%eax
8010666a:	0f 85 a0 01 00 00    	jne    80106810 <trap+0x2d0>
    myproc()->tf = tf;
80106670:	e8 2b d3 ff ff       	call   801039a0 <myproc>
80106675:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106678:	e8 83 ec ff ff       	call   80105300 <syscall>
    if(myproc()->killed)
8010667d:	e8 1e d3 ff ff       	call   801039a0 <myproc>
80106682:	8b 40 24             	mov    0x24(%eax),%eax
80106685:	85 c0                	test   %eax,%eax
80106687:	74 c5                	je     8010664e <trap+0x10e>
}
80106689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010668c:	5b                   	pop    %ebx
8010668d:	5e                   	pop    %esi
8010668e:	5f                   	pop    %edi
8010668f:	5d                   	pop    %ebp
      exit();
80106690:	e9 9b d8 ff ff       	jmp    80103f30 <exit>
80106695:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106698:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010669c:	75 8e                	jne    8010662c <trap+0xec>
	struct proc* p = myproc();
8010669e:	e8 fd d2 ff ff       	call   801039a0 <myproc>
	struct proc* mp = p->master;
801066a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	update_pass(mp);
801066a9:	83 ec 0c             	sub    $0xc,%esp
	struct proc* p = myproc();
801066ac:	89 c7                	mov    %eax,%edi
	mp->pass += mp->stride;
801066ae:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
	mp->used_time++;
801066b4:	83 86 84 00 00 00 01 	addl   $0x1,0x84(%esi)
	mp->pass += mp->stride;
801066bb:	dc 86 94 00 00 00    	faddl  0x94(%esi)
801066c1:	dd 9e 8c 00 00 00    	fstpl  0x8c(%esi)
	update_pass(mp);
801066c7:	56                   	push   %esi
801066c8:	e8 23 21 00 00       	call   801087f0 <update_pass>
	if(mp->in_mlfq) {
801066cd:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
801066d3:	83 c4 10             	add    $0x10,%esp
801066d6:	85 c0                	test   %eax,%eax
801066d8:	0f 84 8a 01 00 00    	je     80106868 <trap+0x328>
		mlfq.used_time++;
801066de:	a1 68 c5 10 80       	mov    0x8010c568,%eax
801066e3:	83 c0 01             	add    $0x1,%eax
801066e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066e9:	a3 68 c5 10 80       	mov    %eax,0x8010c568
		lev = mp->lev;
801066ee:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
		if(lev == 0) {
801066f4:	85 c0                	test   %eax,%eax
801066f6:	0f 85 a8 01 00 00    	jne    801068a4 <trap+0x364>
			if(mp->used_time >= TA_0) {
801066fc:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
80106702:	83 f8 13             	cmp    $0x13,%eax
80106705:	0f 8e f0 01 00 00    	jle    801068fb <trap+0x3bb>
				mp->lev++;
8010670b:	c7 86 80 00 00 00 01 	movl   $0x1,0x80(%esi)
80106712:	00 00 00 
				mp->used_time = 0;
80106715:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
8010671c:	00 00 00 
				mp->used_all_time = 1;
8010671f:	c7 86 bc 00 00 00 01 	movl   $0x1,0xbc(%esi)
80106726:	00 00 00 
80106729:	a1 68 c5 10 80       	mov    0x8010c568,%eax
8010672e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(mlfq.used_time >= BOOST_LIMIT) {
80106731:	81 7d e4 c7 00 00 00 	cmpl   $0xc7,-0x1c(%ebp)
80106738:	0f 8f a9 01 00 00    	jg     801068e7 <trap+0x3a7>
	if(p->is_thread || mp->used_all_time) {
8010673e:	8b 8f 9c 00 00 00    	mov    0x9c(%edi),%ecx
80106744:	85 c9                	test   %ecx,%ecx
80106746:	75 0e                	jne    80106756 <trap+0x216>
80106748:	8b 96 bc 00 00 00    	mov    0xbc(%esi),%edx
8010674e:	85 d2                	test   %edx,%edx
80106750:	0f 84 d6 fe ff ff    	je     8010662c <trap+0xec>
		yield();
80106756:	e8 15 da ff ff       	call   80104170 <yield>
8010675b:	e9 cc fe ff ff       	jmp    8010662c <trap+0xec>
    if(cpuid() == 0){
80106760:	e8 1b d2 ff ff       	call   80103980 <cpuid>
80106765:	85 c0                	test   %eax,%eax
80106767:	0f 84 c3 00 00 00    	je     80106830 <trap+0x2f0>
    lapiceoi();
8010676d:	e8 5e c1 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106772:	e8 29 d2 ff ff       	call   801039a0 <myproc>
80106777:	85 c0                	test   %eax,%eax
80106779:	0f 85 7c fe ff ff    	jne    801065fb <trap+0xbb>
8010677f:	e9 94 fe ff ff       	jmp    80106618 <trap+0xd8>
80106784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106788:	e8 03 c0 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
8010678d:	e8 3e c1 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106792:	e8 09 d2 ff ff       	call   801039a0 <myproc>
80106797:	85 c0                	test   %eax,%eax
80106799:	0f 85 5c fe ff ff    	jne    801065fb <trap+0xbb>
8010679f:	e9 74 fe ff ff       	jmp    80106618 <trap+0xd8>
801067a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801067a8:	e8 63 03 00 00       	call   80106b10 <uartintr>
    lapiceoi();
801067ad:	e8 1e c1 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067b2:	e8 e9 d1 ff ff       	call   801039a0 <myproc>
801067b7:	85 c0                	test   %eax,%eax
801067b9:	0f 85 3c fe ff ff    	jne    801065fb <trap+0xbb>
801067bf:	e9 54 fe ff ff       	jmp    80106618 <trap+0xd8>
801067c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067c8:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801067cc:	8b 7b 38             	mov    0x38(%ebx),%edi
801067cf:	e8 ac d1 ff ff       	call   80103980 <cpuid>
801067d4:	57                   	push   %edi
801067d5:	56                   	push   %esi
801067d6:	50                   	push   %eax
801067d7:	68 24 9a 10 80       	push   $0x80109a24
801067dc:	e8 7f 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
801067e1:	e8 ea c0 ff ff       	call   801028d0 <lapiceoi>
    break;
801067e6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067e9:	e8 b2 d1 ff ff       	call   801039a0 <myproc>
801067ee:	85 c0                	test   %eax,%eax
801067f0:	0f 85 05 fe ff ff    	jne    801065fb <trap+0xbb>
801067f6:	e9 1d fe ff ff       	jmp    80106618 <trap+0xd8>
801067fb:	90                   	nop
801067fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106800:	e8 fb b9 ff ff       	call   80102200 <ideintr>
80106805:	e9 63 ff ff ff       	jmp    8010676d <trap+0x22d>
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106810:	e8 1b d7 ff ff       	call   80103f30 <exit>
80106815:	e9 56 fe ff ff       	jmp    80106670 <trap+0x130>
8010681a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106820:	e8 0b d7 ff ff       	call   80103f30 <exit>
80106825:	e9 ee fd ff ff       	jmp    80106618 <trap+0xd8>
8010682a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106830:	83 ec 0c             	sub    $0xc,%esp
80106833:	68 c0 9e 11 80       	push   $0x80119ec0
80106838:	e8 a3 e5 ff ff       	call   80104de0 <acquire>
      wakeup(&ticks);
8010683d:	c7 04 24 00 a7 11 80 	movl   $0x8011a700,(%esp)
      ticks++;
80106844:	83 05 00 a7 11 80 01 	addl   $0x1,0x8011a700
      wakeup(&ticks);
8010684b:	e8 a0 db ff ff       	call   801043f0 <wakeup>
      release(&tickslock);
80106850:	c7 04 24 c0 9e 11 80 	movl   $0x80119ec0,(%esp)
80106857:	e8 44 e6 ff ff       	call   80104ea0 <release>
8010685c:	83 c4 10             	add    $0x10,%esp
8010685f:	e9 09 ff ff ff       	jmp    8010676d <trap+0x22d>
80106864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(mp->used_time != 0 && mp->used_time % TQ_H == 0) {
80106868:	8b 8e 84 00 00 00    	mov    0x84(%esi),%ecx
8010686e:	85 c9                	test   %ecx,%ecx
80106870:	0f 84 c8 fe ff ff    	je     8010673e <trap+0x1fe>
80106876:	89 c8                	mov    %ecx,%eax
80106878:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010687d:	f7 ea                	imul   %edx
8010687f:	89 d0                	mov    %edx,%eax
80106881:	89 ca                	mov    %ecx,%edx
80106883:	d1 f8                	sar    %eax
80106885:	c1 fa 1f             	sar    $0x1f,%edx
80106888:	29 d0                	sub    %edx,%eax
8010688a:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010688d:	39 c1                	cmp    %eax,%ecx
8010688f:	0f 85 a9 fe ff ff    	jne    8010673e <trap+0x1fe>
			mp->used_all_time = 1;
80106895:	c7 86 bc 00 00 00 01 	movl   $0x1,0xbc(%esi)
8010689c:	00 00 00 
8010689f:	e9 b2 fe ff ff       	jmp    80106756 <trap+0x216>
		} else if(lev == 1) {
801068a4:	83 f8 01             	cmp    $0x1,%eax
801068a7:	74 7b                	je     80106924 <trap+0x3e4>
		} else if(lev == 2) {
801068a9:	83 f8 02             	cmp    $0x2,%eax
801068ac:	0f 85 7f fe ff ff    	jne    80106731 <trap+0x1f1>
			if(mp->used_time != 0 && mp->used_time % TQ_2 == 0) {
801068b2:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
801068b8:	85 c0                	test   %eax,%eax
801068ba:	0f 84 71 fe ff ff    	je     80106731 <trap+0x1f1>
801068c0:	99                   	cltd   
801068c1:	b9 14 00 00 00       	mov    $0x14,%ecx
801068c6:	f7 f9                	idiv   %ecx
801068c8:	85 d2                	test   %edx,%edx
801068ca:	0f 85 61 fe ff ff    	jne    80106731 <trap+0x1f1>
				mp->used_all_time = 1;
801068d0:	c7 86 bc 00 00 00 01 	movl   $0x1,0xbc(%esi)
801068d7:	00 00 00 
801068da:	a1 68 c5 10 80       	mov    0x8010c568,%eax
801068df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068e2:	e9 4a fe ff ff       	jmp    80106731 <trap+0x1f1>
			mlfq.used_time = 0;
801068e7:	c7 05 68 c5 10 80 00 	movl   $0x0,0x8010c568
801068ee:	00 00 00 
			priority_boost();
801068f1:	e8 6a 16 00 00       	call   80107f60 <priority_boost>
801068f6:	e9 43 fe ff ff       	jmp    8010673e <trap+0x1fe>
			} else if(mp->used_time != 0 && mp->used_time % TQ_0 == 0) {
801068fb:	85 c0                	test   %eax,%eax
801068fd:	89 c1                	mov    %eax,%ecx
801068ff:	0f 84 2c fe ff ff    	je     80106731 <trap+0x1f1>
80106905:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010690a:	f7 ea                	imul   %edx
8010690c:	89 d0                	mov    %edx,%eax
8010690e:	89 ca                	mov    %ecx,%edx
80106910:	d1 f8                	sar    %eax
80106912:	c1 fa 1f             	sar    $0x1f,%edx
80106915:	29 d0                	sub    %edx,%eax
80106917:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010691a:	39 c1                	cmp    %eax,%ecx
8010691c:	0f 85 0f fe ff ff    	jne    80106731 <trap+0x1f1>
80106922:	eb ac                	jmp    801068d0 <trap+0x390>
			if(mp->used_time >= TA_1) {
80106924:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
8010692a:	83 f8 27             	cmp    $0x27,%eax
8010692d:	7e 2b                	jle    8010695a <trap+0x41a>
				mp->lev++;
8010692f:	c7 86 80 00 00 00 02 	movl   $0x2,0x80(%esi)
80106936:	00 00 00 
				mp->used_time = 0;
80106939:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80106940:	00 00 00 
				mp->used_all_time = 1;
80106943:	c7 86 bc 00 00 00 01 	movl   $0x1,0xbc(%esi)
8010694a:	00 00 00 
8010694d:	a1 68 c5 10 80       	mov    0x8010c568,%eax
80106952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106955:	e9 d7 fd ff ff       	jmp    80106731 <trap+0x1f1>
			} else if(mp->used_time != 0 && mp->used_time % TQ_1 == 0) {
8010695a:	85 c0                	test   %eax,%eax
8010695c:	0f 84 cf fd ff ff    	je     80106731 <trap+0x1f1>
80106962:	99                   	cltd   
80106963:	b9 0a 00 00 00       	mov    $0xa,%ecx
80106968:	f7 f9                	idiv   %ecx
8010696a:	85 d2                	test   %edx,%edx
8010696c:	0f 85 bf fd ff ff    	jne    80106731 <trap+0x1f1>
80106972:	e9 59 ff ff ff       	jmp    801068d0 <trap+0x390>
80106977:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010697a:	e8 01 d0 ff ff       	call   80103980 <cpuid>
8010697f:	83 ec 0c             	sub    $0xc,%esp
80106982:	57                   	push   %edi
80106983:	56                   	push   %esi
80106984:	50                   	push   %eax
80106985:	ff 73 30             	pushl  0x30(%ebx)
80106988:	68 48 9a 10 80       	push   $0x80109a48
8010698d:	e8 ce 9c ff ff       	call   80100660 <cprintf>
      panic("trap");
80106992:	83 c4 14             	add    $0x14,%esp
80106995:	68 1e 9a 10 80       	push   $0x80109a1e
8010699a:	e8 f1 99 ff ff       	call   80100390 <panic>
8010699f:	90                   	nop

801069a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801069a0:	a1 e0 c6 10 80       	mov    0x8010c6e0,%eax
{
801069a5:	55                   	push   %ebp
801069a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801069a8:	85 c0                	test   %eax,%eax
801069aa:	74 1c                	je     801069c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801069b2:	a8 01                	test   $0x1,%al
801069b4:	74 12                	je     801069c8 <uartgetc+0x28>
801069b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069bb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801069bc:	0f b6 c0             	movzbl %al,%eax
}
801069bf:	5d                   	pop    %ebp
801069c0:	c3                   	ret    
801069c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069cd:	5d                   	pop    %ebp
801069ce:	c3                   	ret    
801069cf:	90                   	nop

801069d0 <uartputc.part.0>:
uartputc(int c)
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	89 c7                	mov    %eax,%edi
801069d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801069dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801069e2:	83 ec 0c             	sub    $0xc,%esp
801069e5:	eb 1b                	jmp    80106a02 <uartputc.part.0+0x32>
801069e7:	89 f6                	mov    %esi,%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801069f0:	83 ec 0c             	sub    $0xc,%esp
801069f3:	6a 0a                	push   $0xa
801069f5:	e8 f6 be ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801069fa:	83 c4 10             	add    $0x10,%esp
801069fd:	83 eb 01             	sub    $0x1,%ebx
80106a00:	74 07                	je     80106a09 <uartputc.part.0+0x39>
80106a02:	89 f2                	mov    %esi,%edx
80106a04:	ec                   	in     (%dx),%al
80106a05:	a8 20                	test   $0x20,%al
80106a07:	74 e7                	je     801069f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a0e:	89 f8                	mov    %edi,%eax
80106a10:	ee                   	out    %al,(%dx)
}
80106a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a14:	5b                   	pop    %ebx
80106a15:	5e                   	pop    %esi
80106a16:	5f                   	pop    %edi
80106a17:	5d                   	pop    %ebp
80106a18:	c3                   	ret    
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a20 <uartinit>:
{
80106a20:	55                   	push   %ebp
80106a21:	31 c9                	xor    %ecx,%ecx
80106a23:	89 c8                	mov    %ecx,%eax
80106a25:	89 e5                	mov    %esp,%ebp
80106a27:	57                   	push   %edi
80106a28:	56                   	push   %esi
80106a29:	53                   	push   %ebx
80106a2a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106a2f:	89 da                	mov    %ebx,%edx
80106a31:	83 ec 0c             	sub    $0xc,%esp
80106a34:	ee                   	out    %al,(%dx)
80106a35:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106a3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106a3f:	89 fa                	mov    %edi,%edx
80106a41:	ee                   	out    %al,(%dx)
80106a42:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a4c:	ee                   	out    %al,(%dx)
80106a4d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106a52:	89 c8                	mov    %ecx,%eax
80106a54:	89 f2                	mov    %esi,%edx
80106a56:	ee                   	out    %al,(%dx)
80106a57:	b8 03 00 00 00       	mov    $0x3,%eax
80106a5c:	89 fa                	mov    %edi,%edx
80106a5e:	ee                   	out    %al,(%dx)
80106a5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a64:	89 c8                	mov    %ecx,%eax
80106a66:	ee                   	out    %al,(%dx)
80106a67:	b8 01 00 00 00       	mov    $0x1,%eax
80106a6c:	89 f2                	mov    %esi,%edx
80106a6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a75:	3c ff                	cmp    $0xff,%al
80106a77:	74 5a                	je     80106ad3 <uartinit+0xb3>
  uart = 1;
80106a79:	c7 05 e0 c6 10 80 01 	movl   $0x1,0x8010c6e0
80106a80:	00 00 00 
80106a83:	89 da                	mov    %ebx,%edx
80106a85:	ec                   	in     (%dx),%al
80106a86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106a8c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106a8f:	bb 48 9b 10 80       	mov    $0x80109b48,%ebx
  ioapicenable(IRQ_COM1, 0);
80106a94:	6a 00                	push   $0x0
80106a96:	6a 04                	push   $0x4
80106a98:	e8 b3 b9 ff ff       	call   80102450 <ioapicenable>
80106a9d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106aa0:	b8 78 00 00 00       	mov    $0x78,%eax
80106aa5:	eb 13                	jmp    80106aba <uartinit+0x9a>
80106aa7:	89 f6                	mov    %esi,%esi
80106aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ab0:	83 c3 01             	add    $0x1,%ebx
80106ab3:	0f be 03             	movsbl (%ebx),%eax
80106ab6:	84 c0                	test   %al,%al
80106ab8:	74 19                	je     80106ad3 <uartinit+0xb3>
  if(!uart)
80106aba:	8b 15 e0 c6 10 80    	mov    0x8010c6e0,%edx
80106ac0:	85 d2                	test   %edx,%edx
80106ac2:	74 ec                	je     80106ab0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106ac4:	83 c3 01             	add    $0x1,%ebx
80106ac7:	e8 04 ff ff ff       	call   801069d0 <uartputc.part.0>
80106acc:	0f be 03             	movsbl (%ebx),%eax
80106acf:	84 c0                	test   %al,%al
80106ad1:	75 e7                	jne    80106aba <uartinit+0x9a>
}
80106ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ad6:	5b                   	pop    %ebx
80106ad7:	5e                   	pop    %esi
80106ad8:	5f                   	pop    %edi
80106ad9:	5d                   	pop    %ebp
80106ada:	c3                   	ret    
80106adb:	90                   	nop
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <uartputc>:
  if(!uart)
80106ae0:	8b 15 e0 c6 10 80    	mov    0x8010c6e0,%edx
{
80106ae6:	55                   	push   %ebp
80106ae7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ae9:	85 d2                	test   %edx,%edx
{
80106aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106aee:	74 10                	je     80106b00 <uartputc+0x20>
}
80106af0:	5d                   	pop    %ebp
80106af1:	e9 da fe ff ff       	jmp    801069d0 <uartputc.part.0>
80106af6:	8d 76 00             	lea    0x0(%esi),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106b00:	5d                   	pop    %ebp
80106b01:	c3                   	ret    
80106b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b10 <uartintr>:

void
uartintr(void)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106b16:	68 a0 69 10 80       	push   $0x801069a0
80106b1b:	e8 f0 9c ff ff       	call   80100810 <consoleintr>
}
80106b20:	83 c4 10             	add    $0x10,%esp
80106b23:	c9                   	leave  
80106b24:	c3                   	ret    

80106b25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $0
80106b27:	6a 00                	push   $0x0
  jmp alltraps
80106b29:	e9 39 f9 ff ff       	jmp    80106467 <alltraps>

80106b2e <vector1>:
.globl vector1
vector1:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $1
80106b30:	6a 01                	push   $0x1
  jmp alltraps
80106b32:	e9 30 f9 ff ff       	jmp    80106467 <alltraps>

80106b37 <vector2>:
.globl vector2
vector2:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $2
80106b39:	6a 02                	push   $0x2
  jmp alltraps
80106b3b:	e9 27 f9 ff ff       	jmp    80106467 <alltraps>

80106b40 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $3
80106b42:	6a 03                	push   $0x3
  jmp alltraps
80106b44:	e9 1e f9 ff ff       	jmp    80106467 <alltraps>

80106b49 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $4
80106b4b:	6a 04                	push   $0x4
  jmp alltraps
80106b4d:	e9 15 f9 ff ff       	jmp    80106467 <alltraps>

80106b52 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $5
80106b54:	6a 05                	push   $0x5
  jmp alltraps
80106b56:	e9 0c f9 ff ff       	jmp    80106467 <alltraps>

80106b5b <vector6>:
.globl vector6
vector6:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $6
80106b5d:	6a 06                	push   $0x6
  jmp alltraps
80106b5f:	e9 03 f9 ff ff       	jmp    80106467 <alltraps>

80106b64 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $7
80106b66:	6a 07                	push   $0x7
  jmp alltraps
80106b68:	e9 fa f8 ff ff       	jmp    80106467 <alltraps>

80106b6d <vector8>:
.globl vector8
vector8:
  pushl $8
80106b6d:	6a 08                	push   $0x8
  jmp alltraps
80106b6f:	e9 f3 f8 ff ff       	jmp    80106467 <alltraps>

80106b74 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $9
80106b76:	6a 09                	push   $0x9
  jmp alltraps
80106b78:	e9 ea f8 ff ff       	jmp    80106467 <alltraps>

80106b7d <vector10>:
.globl vector10
vector10:
  pushl $10
80106b7d:	6a 0a                	push   $0xa
  jmp alltraps
80106b7f:	e9 e3 f8 ff ff       	jmp    80106467 <alltraps>

80106b84 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b84:	6a 0b                	push   $0xb
  jmp alltraps
80106b86:	e9 dc f8 ff ff       	jmp    80106467 <alltraps>

80106b8b <vector12>:
.globl vector12
vector12:
  pushl $12
80106b8b:	6a 0c                	push   $0xc
  jmp alltraps
80106b8d:	e9 d5 f8 ff ff       	jmp    80106467 <alltraps>

80106b92 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b92:	6a 0d                	push   $0xd
  jmp alltraps
80106b94:	e9 ce f8 ff ff       	jmp    80106467 <alltraps>

80106b99 <vector14>:
.globl vector14
vector14:
  pushl $14
80106b99:	6a 0e                	push   $0xe
  jmp alltraps
80106b9b:	e9 c7 f8 ff ff       	jmp    80106467 <alltraps>

80106ba0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ba0:	6a 00                	push   $0x0
  pushl $15
80106ba2:	6a 0f                	push   $0xf
  jmp alltraps
80106ba4:	e9 be f8 ff ff       	jmp    80106467 <alltraps>

80106ba9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ba9:	6a 00                	push   $0x0
  pushl $16
80106bab:	6a 10                	push   $0x10
  jmp alltraps
80106bad:	e9 b5 f8 ff ff       	jmp    80106467 <alltraps>

80106bb2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106bb2:	6a 11                	push   $0x11
  jmp alltraps
80106bb4:	e9 ae f8 ff ff       	jmp    80106467 <alltraps>

80106bb9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $18
80106bbb:	6a 12                	push   $0x12
  jmp alltraps
80106bbd:	e9 a5 f8 ff ff       	jmp    80106467 <alltraps>

80106bc2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $19
80106bc4:	6a 13                	push   $0x13
  jmp alltraps
80106bc6:	e9 9c f8 ff ff       	jmp    80106467 <alltraps>

80106bcb <vector20>:
.globl vector20
vector20:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $20
80106bcd:	6a 14                	push   $0x14
  jmp alltraps
80106bcf:	e9 93 f8 ff ff       	jmp    80106467 <alltraps>

80106bd4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106bd4:	6a 00                	push   $0x0
  pushl $21
80106bd6:	6a 15                	push   $0x15
  jmp alltraps
80106bd8:	e9 8a f8 ff ff       	jmp    80106467 <alltraps>

80106bdd <vector22>:
.globl vector22
vector22:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $22
80106bdf:	6a 16                	push   $0x16
  jmp alltraps
80106be1:	e9 81 f8 ff ff       	jmp    80106467 <alltraps>

80106be6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $23
80106be8:	6a 17                	push   $0x17
  jmp alltraps
80106bea:	e9 78 f8 ff ff       	jmp    80106467 <alltraps>

80106bef <vector24>:
.globl vector24
vector24:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $24
80106bf1:	6a 18                	push   $0x18
  jmp alltraps
80106bf3:	e9 6f f8 ff ff       	jmp    80106467 <alltraps>

80106bf8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $25
80106bfa:	6a 19                	push   $0x19
  jmp alltraps
80106bfc:	e9 66 f8 ff ff       	jmp    80106467 <alltraps>

80106c01 <vector26>:
.globl vector26
vector26:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $26
80106c03:	6a 1a                	push   $0x1a
  jmp alltraps
80106c05:	e9 5d f8 ff ff       	jmp    80106467 <alltraps>

80106c0a <vector27>:
.globl vector27
vector27:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $27
80106c0c:	6a 1b                	push   $0x1b
  jmp alltraps
80106c0e:	e9 54 f8 ff ff       	jmp    80106467 <alltraps>

80106c13 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $28
80106c15:	6a 1c                	push   $0x1c
  jmp alltraps
80106c17:	e9 4b f8 ff ff       	jmp    80106467 <alltraps>

80106c1c <vector29>:
.globl vector29
vector29:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $29
80106c1e:	6a 1d                	push   $0x1d
  jmp alltraps
80106c20:	e9 42 f8 ff ff       	jmp    80106467 <alltraps>

80106c25 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $30
80106c27:	6a 1e                	push   $0x1e
  jmp alltraps
80106c29:	e9 39 f8 ff ff       	jmp    80106467 <alltraps>

80106c2e <vector31>:
.globl vector31
vector31:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $31
80106c30:	6a 1f                	push   $0x1f
  jmp alltraps
80106c32:	e9 30 f8 ff ff       	jmp    80106467 <alltraps>

80106c37 <vector32>:
.globl vector32
vector32:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $32
80106c39:	6a 20                	push   $0x20
  jmp alltraps
80106c3b:	e9 27 f8 ff ff       	jmp    80106467 <alltraps>

80106c40 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $33
80106c42:	6a 21                	push   $0x21
  jmp alltraps
80106c44:	e9 1e f8 ff ff       	jmp    80106467 <alltraps>

80106c49 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $34
80106c4b:	6a 22                	push   $0x22
  jmp alltraps
80106c4d:	e9 15 f8 ff ff       	jmp    80106467 <alltraps>

80106c52 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $35
80106c54:	6a 23                	push   $0x23
  jmp alltraps
80106c56:	e9 0c f8 ff ff       	jmp    80106467 <alltraps>

80106c5b <vector36>:
.globl vector36
vector36:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $36
80106c5d:	6a 24                	push   $0x24
  jmp alltraps
80106c5f:	e9 03 f8 ff ff       	jmp    80106467 <alltraps>

80106c64 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c64:	6a 00                	push   $0x0
  pushl $37
80106c66:	6a 25                	push   $0x25
  jmp alltraps
80106c68:	e9 fa f7 ff ff       	jmp    80106467 <alltraps>

80106c6d <vector38>:
.globl vector38
vector38:
  pushl $0
80106c6d:	6a 00                	push   $0x0
  pushl $38
80106c6f:	6a 26                	push   $0x26
  jmp alltraps
80106c71:	e9 f1 f7 ff ff       	jmp    80106467 <alltraps>

80106c76 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $39
80106c78:	6a 27                	push   $0x27
  jmp alltraps
80106c7a:	e9 e8 f7 ff ff       	jmp    80106467 <alltraps>

80106c7f <vector40>:
.globl vector40
vector40:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $40
80106c81:	6a 28                	push   $0x28
  jmp alltraps
80106c83:	e9 df f7 ff ff       	jmp    80106467 <alltraps>

80106c88 <vector41>:
.globl vector41
vector41:
  pushl $0
80106c88:	6a 00                	push   $0x0
  pushl $41
80106c8a:	6a 29                	push   $0x29
  jmp alltraps
80106c8c:	e9 d6 f7 ff ff       	jmp    80106467 <alltraps>

80106c91 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c91:	6a 00                	push   $0x0
  pushl $42
80106c93:	6a 2a                	push   $0x2a
  jmp alltraps
80106c95:	e9 cd f7 ff ff       	jmp    80106467 <alltraps>

80106c9a <vector43>:
.globl vector43
vector43:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $43
80106c9c:	6a 2b                	push   $0x2b
  jmp alltraps
80106c9e:	e9 c4 f7 ff ff       	jmp    80106467 <alltraps>

80106ca3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $44
80106ca5:	6a 2c                	push   $0x2c
  jmp alltraps
80106ca7:	e9 bb f7 ff ff       	jmp    80106467 <alltraps>

80106cac <vector45>:
.globl vector45
vector45:
  pushl $0
80106cac:	6a 00                	push   $0x0
  pushl $45
80106cae:	6a 2d                	push   $0x2d
  jmp alltraps
80106cb0:	e9 b2 f7 ff ff       	jmp    80106467 <alltraps>

80106cb5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $46
80106cb7:	6a 2e                	push   $0x2e
  jmp alltraps
80106cb9:	e9 a9 f7 ff ff       	jmp    80106467 <alltraps>

80106cbe <vector47>:
.globl vector47
vector47:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $47
80106cc0:	6a 2f                	push   $0x2f
  jmp alltraps
80106cc2:	e9 a0 f7 ff ff       	jmp    80106467 <alltraps>

80106cc7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $48
80106cc9:	6a 30                	push   $0x30
  jmp alltraps
80106ccb:	e9 97 f7 ff ff       	jmp    80106467 <alltraps>

80106cd0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $49
80106cd2:	6a 31                	push   $0x31
  jmp alltraps
80106cd4:	e9 8e f7 ff ff       	jmp    80106467 <alltraps>

80106cd9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $50
80106cdb:	6a 32                	push   $0x32
  jmp alltraps
80106cdd:	e9 85 f7 ff ff       	jmp    80106467 <alltraps>

80106ce2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $51
80106ce4:	6a 33                	push   $0x33
  jmp alltraps
80106ce6:	e9 7c f7 ff ff       	jmp    80106467 <alltraps>

80106ceb <vector52>:
.globl vector52
vector52:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $52
80106ced:	6a 34                	push   $0x34
  jmp alltraps
80106cef:	e9 73 f7 ff ff       	jmp    80106467 <alltraps>

80106cf4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $53
80106cf6:	6a 35                	push   $0x35
  jmp alltraps
80106cf8:	e9 6a f7 ff ff       	jmp    80106467 <alltraps>

80106cfd <vector54>:
.globl vector54
vector54:
  pushl $0
80106cfd:	6a 00                	push   $0x0
  pushl $54
80106cff:	6a 36                	push   $0x36
  jmp alltraps
80106d01:	e9 61 f7 ff ff       	jmp    80106467 <alltraps>

80106d06 <vector55>:
.globl vector55
vector55:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $55
80106d08:	6a 37                	push   $0x37
  jmp alltraps
80106d0a:	e9 58 f7 ff ff       	jmp    80106467 <alltraps>

80106d0f <vector56>:
.globl vector56
vector56:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $56
80106d11:	6a 38                	push   $0x38
  jmp alltraps
80106d13:	e9 4f f7 ff ff       	jmp    80106467 <alltraps>

80106d18 <vector57>:
.globl vector57
vector57:
  pushl $0
80106d18:	6a 00                	push   $0x0
  pushl $57
80106d1a:	6a 39                	push   $0x39
  jmp alltraps
80106d1c:	e9 46 f7 ff ff       	jmp    80106467 <alltraps>

80106d21 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d21:	6a 00                	push   $0x0
  pushl $58
80106d23:	6a 3a                	push   $0x3a
  jmp alltraps
80106d25:	e9 3d f7 ff ff       	jmp    80106467 <alltraps>

80106d2a <vector59>:
.globl vector59
vector59:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $59
80106d2c:	6a 3b                	push   $0x3b
  jmp alltraps
80106d2e:	e9 34 f7 ff ff       	jmp    80106467 <alltraps>

80106d33 <vector60>:
.globl vector60
vector60:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $60
80106d35:	6a 3c                	push   $0x3c
  jmp alltraps
80106d37:	e9 2b f7 ff ff       	jmp    80106467 <alltraps>

80106d3c <vector61>:
.globl vector61
vector61:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $61
80106d3e:	6a 3d                	push   $0x3d
  jmp alltraps
80106d40:	e9 22 f7 ff ff       	jmp    80106467 <alltraps>

80106d45 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $62
80106d47:	6a 3e                	push   $0x3e
  jmp alltraps
80106d49:	e9 19 f7 ff ff       	jmp    80106467 <alltraps>

80106d4e <vector63>:
.globl vector63
vector63:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $63
80106d50:	6a 3f                	push   $0x3f
  jmp alltraps
80106d52:	e9 10 f7 ff ff       	jmp    80106467 <alltraps>

80106d57 <vector64>:
.globl vector64
vector64:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $64
80106d59:	6a 40                	push   $0x40
  jmp alltraps
80106d5b:	e9 07 f7 ff ff       	jmp    80106467 <alltraps>

80106d60 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $65
80106d62:	6a 41                	push   $0x41
  jmp alltraps
80106d64:	e9 fe f6 ff ff       	jmp    80106467 <alltraps>

80106d69 <vector66>:
.globl vector66
vector66:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $66
80106d6b:	6a 42                	push   $0x42
  jmp alltraps
80106d6d:	e9 f5 f6 ff ff       	jmp    80106467 <alltraps>

80106d72 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $67
80106d74:	6a 43                	push   $0x43
  jmp alltraps
80106d76:	e9 ec f6 ff ff       	jmp    80106467 <alltraps>

80106d7b <vector68>:
.globl vector68
vector68:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $68
80106d7d:	6a 44                	push   $0x44
  jmp alltraps
80106d7f:	e9 e3 f6 ff ff       	jmp    80106467 <alltraps>

80106d84 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $69
80106d86:	6a 45                	push   $0x45
  jmp alltraps
80106d88:	e9 da f6 ff ff       	jmp    80106467 <alltraps>

80106d8d <vector70>:
.globl vector70
vector70:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $70
80106d8f:	6a 46                	push   $0x46
  jmp alltraps
80106d91:	e9 d1 f6 ff ff       	jmp    80106467 <alltraps>

80106d96 <vector71>:
.globl vector71
vector71:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $71
80106d98:	6a 47                	push   $0x47
  jmp alltraps
80106d9a:	e9 c8 f6 ff ff       	jmp    80106467 <alltraps>

80106d9f <vector72>:
.globl vector72
vector72:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $72
80106da1:	6a 48                	push   $0x48
  jmp alltraps
80106da3:	e9 bf f6 ff ff       	jmp    80106467 <alltraps>

80106da8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $73
80106daa:	6a 49                	push   $0x49
  jmp alltraps
80106dac:	e9 b6 f6 ff ff       	jmp    80106467 <alltraps>

80106db1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $74
80106db3:	6a 4a                	push   $0x4a
  jmp alltraps
80106db5:	e9 ad f6 ff ff       	jmp    80106467 <alltraps>

80106dba <vector75>:
.globl vector75
vector75:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $75
80106dbc:	6a 4b                	push   $0x4b
  jmp alltraps
80106dbe:	e9 a4 f6 ff ff       	jmp    80106467 <alltraps>

80106dc3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $76
80106dc5:	6a 4c                	push   $0x4c
  jmp alltraps
80106dc7:	e9 9b f6 ff ff       	jmp    80106467 <alltraps>

80106dcc <vector77>:
.globl vector77
vector77:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $77
80106dce:	6a 4d                	push   $0x4d
  jmp alltraps
80106dd0:	e9 92 f6 ff ff       	jmp    80106467 <alltraps>

80106dd5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $78
80106dd7:	6a 4e                	push   $0x4e
  jmp alltraps
80106dd9:	e9 89 f6 ff ff       	jmp    80106467 <alltraps>

80106dde <vector79>:
.globl vector79
vector79:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $79
80106de0:	6a 4f                	push   $0x4f
  jmp alltraps
80106de2:	e9 80 f6 ff ff       	jmp    80106467 <alltraps>

80106de7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $80
80106de9:	6a 50                	push   $0x50
  jmp alltraps
80106deb:	e9 77 f6 ff ff       	jmp    80106467 <alltraps>

80106df0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $81
80106df2:	6a 51                	push   $0x51
  jmp alltraps
80106df4:	e9 6e f6 ff ff       	jmp    80106467 <alltraps>

80106df9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $82
80106dfb:	6a 52                	push   $0x52
  jmp alltraps
80106dfd:	e9 65 f6 ff ff       	jmp    80106467 <alltraps>

80106e02 <vector83>:
.globl vector83
vector83:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $83
80106e04:	6a 53                	push   $0x53
  jmp alltraps
80106e06:	e9 5c f6 ff ff       	jmp    80106467 <alltraps>

80106e0b <vector84>:
.globl vector84
vector84:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $84
80106e0d:	6a 54                	push   $0x54
  jmp alltraps
80106e0f:	e9 53 f6 ff ff       	jmp    80106467 <alltraps>

80106e14 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $85
80106e16:	6a 55                	push   $0x55
  jmp alltraps
80106e18:	e9 4a f6 ff ff       	jmp    80106467 <alltraps>

80106e1d <vector86>:
.globl vector86
vector86:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $86
80106e1f:	6a 56                	push   $0x56
  jmp alltraps
80106e21:	e9 41 f6 ff ff       	jmp    80106467 <alltraps>

80106e26 <vector87>:
.globl vector87
vector87:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $87
80106e28:	6a 57                	push   $0x57
  jmp alltraps
80106e2a:	e9 38 f6 ff ff       	jmp    80106467 <alltraps>

80106e2f <vector88>:
.globl vector88
vector88:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $88
80106e31:	6a 58                	push   $0x58
  jmp alltraps
80106e33:	e9 2f f6 ff ff       	jmp    80106467 <alltraps>

80106e38 <vector89>:
.globl vector89
vector89:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $89
80106e3a:	6a 59                	push   $0x59
  jmp alltraps
80106e3c:	e9 26 f6 ff ff       	jmp    80106467 <alltraps>

80106e41 <vector90>:
.globl vector90
vector90:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $90
80106e43:	6a 5a                	push   $0x5a
  jmp alltraps
80106e45:	e9 1d f6 ff ff       	jmp    80106467 <alltraps>

80106e4a <vector91>:
.globl vector91
vector91:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $91
80106e4c:	6a 5b                	push   $0x5b
  jmp alltraps
80106e4e:	e9 14 f6 ff ff       	jmp    80106467 <alltraps>

80106e53 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $92
80106e55:	6a 5c                	push   $0x5c
  jmp alltraps
80106e57:	e9 0b f6 ff ff       	jmp    80106467 <alltraps>

80106e5c <vector93>:
.globl vector93
vector93:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $93
80106e5e:	6a 5d                	push   $0x5d
  jmp alltraps
80106e60:	e9 02 f6 ff ff       	jmp    80106467 <alltraps>

80106e65 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $94
80106e67:	6a 5e                	push   $0x5e
  jmp alltraps
80106e69:	e9 f9 f5 ff ff       	jmp    80106467 <alltraps>

80106e6e <vector95>:
.globl vector95
vector95:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $95
80106e70:	6a 5f                	push   $0x5f
  jmp alltraps
80106e72:	e9 f0 f5 ff ff       	jmp    80106467 <alltraps>

80106e77 <vector96>:
.globl vector96
vector96:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $96
80106e79:	6a 60                	push   $0x60
  jmp alltraps
80106e7b:	e9 e7 f5 ff ff       	jmp    80106467 <alltraps>

80106e80 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $97
80106e82:	6a 61                	push   $0x61
  jmp alltraps
80106e84:	e9 de f5 ff ff       	jmp    80106467 <alltraps>

80106e89 <vector98>:
.globl vector98
vector98:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $98
80106e8b:	6a 62                	push   $0x62
  jmp alltraps
80106e8d:	e9 d5 f5 ff ff       	jmp    80106467 <alltraps>

80106e92 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $99
80106e94:	6a 63                	push   $0x63
  jmp alltraps
80106e96:	e9 cc f5 ff ff       	jmp    80106467 <alltraps>

80106e9b <vector100>:
.globl vector100
vector100:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $100
80106e9d:	6a 64                	push   $0x64
  jmp alltraps
80106e9f:	e9 c3 f5 ff ff       	jmp    80106467 <alltraps>

80106ea4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $101
80106ea6:	6a 65                	push   $0x65
  jmp alltraps
80106ea8:	e9 ba f5 ff ff       	jmp    80106467 <alltraps>

80106ead <vector102>:
.globl vector102
vector102:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $102
80106eaf:	6a 66                	push   $0x66
  jmp alltraps
80106eb1:	e9 b1 f5 ff ff       	jmp    80106467 <alltraps>

80106eb6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $103
80106eb8:	6a 67                	push   $0x67
  jmp alltraps
80106eba:	e9 a8 f5 ff ff       	jmp    80106467 <alltraps>

80106ebf <vector104>:
.globl vector104
vector104:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $104
80106ec1:	6a 68                	push   $0x68
  jmp alltraps
80106ec3:	e9 9f f5 ff ff       	jmp    80106467 <alltraps>

80106ec8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $105
80106eca:	6a 69                	push   $0x69
  jmp alltraps
80106ecc:	e9 96 f5 ff ff       	jmp    80106467 <alltraps>

80106ed1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $106
80106ed3:	6a 6a                	push   $0x6a
  jmp alltraps
80106ed5:	e9 8d f5 ff ff       	jmp    80106467 <alltraps>

80106eda <vector107>:
.globl vector107
vector107:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $107
80106edc:	6a 6b                	push   $0x6b
  jmp alltraps
80106ede:	e9 84 f5 ff ff       	jmp    80106467 <alltraps>

80106ee3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $108
80106ee5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ee7:	e9 7b f5 ff ff       	jmp    80106467 <alltraps>

80106eec <vector109>:
.globl vector109
vector109:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $109
80106eee:	6a 6d                	push   $0x6d
  jmp alltraps
80106ef0:	e9 72 f5 ff ff       	jmp    80106467 <alltraps>

80106ef5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $110
80106ef7:	6a 6e                	push   $0x6e
  jmp alltraps
80106ef9:	e9 69 f5 ff ff       	jmp    80106467 <alltraps>

80106efe <vector111>:
.globl vector111
vector111:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $111
80106f00:	6a 6f                	push   $0x6f
  jmp alltraps
80106f02:	e9 60 f5 ff ff       	jmp    80106467 <alltraps>

80106f07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $112
80106f09:	6a 70                	push   $0x70
  jmp alltraps
80106f0b:	e9 57 f5 ff ff       	jmp    80106467 <alltraps>

80106f10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $113
80106f12:	6a 71                	push   $0x71
  jmp alltraps
80106f14:	e9 4e f5 ff ff       	jmp    80106467 <alltraps>

80106f19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $114
80106f1b:	6a 72                	push   $0x72
  jmp alltraps
80106f1d:	e9 45 f5 ff ff       	jmp    80106467 <alltraps>

80106f22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $115
80106f24:	6a 73                	push   $0x73
  jmp alltraps
80106f26:	e9 3c f5 ff ff       	jmp    80106467 <alltraps>

80106f2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $116
80106f2d:	6a 74                	push   $0x74
  jmp alltraps
80106f2f:	e9 33 f5 ff ff       	jmp    80106467 <alltraps>

80106f34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $117
80106f36:	6a 75                	push   $0x75
  jmp alltraps
80106f38:	e9 2a f5 ff ff       	jmp    80106467 <alltraps>

80106f3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $118
80106f3f:	6a 76                	push   $0x76
  jmp alltraps
80106f41:	e9 21 f5 ff ff       	jmp    80106467 <alltraps>

80106f46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $119
80106f48:	6a 77                	push   $0x77
  jmp alltraps
80106f4a:	e9 18 f5 ff ff       	jmp    80106467 <alltraps>

80106f4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $120
80106f51:	6a 78                	push   $0x78
  jmp alltraps
80106f53:	e9 0f f5 ff ff       	jmp    80106467 <alltraps>

80106f58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $121
80106f5a:	6a 79                	push   $0x79
  jmp alltraps
80106f5c:	e9 06 f5 ff ff       	jmp    80106467 <alltraps>

80106f61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $122
80106f63:	6a 7a                	push   $0x7a
  jmp alltraps
80106f65:	e9 fd f4 ff ff       	jmp    80106467 <alltraps>

80106f6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $123
80106f6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106f6e:	e9 f4 f4 ff ff       	jmp    80106467 <alltraps>

80106f73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $124
80106f75:	6a 7c                	push   $0x7c
  jmp alltraps
80106f77:	e9 eb f4 ff ff       	jmp    80106467 <alltraps>

80106f7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $125
80106f7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106f80:	e9 e2 f4 ff ff       	jmp    80106467 <alltraps>

80106f85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $126
80106f87:	6a 7e                	push   $0x7e
  jmp alltraps
80106f89:	e9 d9 f4 ff ff       	jmp    80106467 <alltraps>

80106f8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $127
80106f90:	6a 7f                	push   $0x7f
  jmp alltraps
80106f92:	e9 d0 f4 ff ff       	jmp    80106467 <alltraps>

80106f97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $128
80106f99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f9e:	e9 c4 f4 ff ff       	jmp    80106467 <alltraps>

80106fa3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $129
80106fa5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106faa:	e9 b8 f4 ff ff       	jmp    80106467 <alltraps>

80106faf <vector130>:
.globl vector130
vector130:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $130
80106fb1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106fb6:	e9 ac f4 ff ff       	jmp    80106467 <alltraps>

80106fbb <vector131>:
.globl vector131
vector131:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $131
80106fbd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106fc2:	e9 a0 f4 ff ff       	jmp    80106467 <alltraps>

80106fc7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $132
80106fc9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106fce:	e9 94 f4 ff ff       	jmp    80106467 <alltraps>

80106fd3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $133
80106fd5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106fda:	e9 88 f4 ff ff       	jmp    80106467 <alltraps>

80106fdf <vector134>:
.globl vector134
vector134:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $134
80106fe1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106fe6:	e9 7c f4 ff ff       	jmp    80106467 <alltraps>

80106feb <vector135>:
.globl vector135
vector135:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $135
80106fed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ff2:	e9 70 f4 ff ff       	jmp    80106467 <alltraps>

80106ff7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $136
80106ff9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ffe:	e9 64 f4 ff ff       	jmp    80106467 <alltraps>

80107003 <vector137>:
.globl vector137
vector137:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $137
80107005:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010700a:	e9 58 f4 ff ff       	jmp    80106467 <alltraps>

8010700f <vector138>:
.globl vector138
vector138:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $138
80107011:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107016:	e9 4c f4 ff ff       	jmp    80106467 <alltraps>

8010701b <vector139>:
.globl vector139
vector139:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $139
8010701d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107022:	e9 40 f4 ff ff       	jmp    80106467 <alltraps>

80107027 <vector140>:
.globl vector140
vector140:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $140
80107029:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010702e:	e9 34 f4 ff ff       	jmp    80106467 <alltraps>

80107033 <vector141>:
.globl vector141
vector141:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $141
80107035:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010703a:	e9 28 f4 ff ff       	jmp    80106467 <alltraps>

8010703f <vector142>:
.globl vector142
vector142:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $142
80107041:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107046:	e9 1c f4 ff ff       	jmp    80106467 <alltraps>

8010704b <vector143>:
.globl vector143
vector143:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $143
8010704d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107052:	e9 10 f4 ff ff       	jmp    80106467 <alltraps>

80107057 <vector144>:
.globl vector144
vector144:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $144
80107059:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010705e:	e9 04 f4 ff ff       	jmp    80106467 <alltraps>

80107063 <vector145>:
.globl vector145
vector145:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $145
80107065:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010706a:	e9 f8 f3 ff ff       	jmp    80106467 <alltraps>

8010706f <vector146>:
.globl vector146
vector146:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $146
80107071:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107076:	e9 ec f3 ff ff       	jmp    80106467 <alltraps>

8010707b <vector147>:
.globl vector147
vector147:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $147
8010707d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107082:	e9 e0 f3 ff ff       	jmp    80106467 <alltraps>

80107087 <vector148>:
.globl vector148
vector148:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $148
80107089:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010708e:	e9 d4 f3 ff ff       	jmp    80106467 <alltraps>

80107093 <vector149>:
.globl vector149
vector149:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $149
80107095:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010709a:	e9 c8 f3 ff ff       	jmp    80106467 <alltraps>

8010709f <vector150>:
.globl vector150
vector150:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $150
801070a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801070a6:	e9 bc f3 ff ff       	jmp    80106467 <alltraps>

801070ab <vector151>:
.globl vector151
vector151:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $151
801070ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801070b2:	e9 b0 f3 ff ff       	jmp    80106467 <alltraps>

801070b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $152
801070b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801070be:	e9 a4 f3 ff ff       	jmp    80106467 <alltraps>

801070c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $153
801070c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801070ca:	e9 98 f3 ff ff       	jmp    80106467 <alltraps>

801070cf <vector154>:
.globl vector154
vector154:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $154
801070d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801070d6:	e9 8c f3 ff ff       	jmp    80106467 <alltraps>

801070db <vector155>:
.globl vector155
vector155:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $155
801070dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801070e2:	e9 80 f3 ff ff       	jmp    80106467 <alltraps>

801070e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $156
801070e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070ee:	e9 74 f3 ff ff       	jmp    80106467 <alltraps>

801070f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $157
801070f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801070fa:	e9 68 f3 ff ff       	jmp    80106467 <alltraps>

801070ff <vector158>:
.globl vector158
vector158:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $158
80107101:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107106:	e9 5c f3 ff ff       	jmp    80106467 <alltraps>

8010710b <vector159>:
.globl vector159
vector159:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $159
8010710d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107112:	e9 50 f3 ff ff       	jmp    80106467 <alltraps>

80107117 <vector160>:
.globl vector160
vector160:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $160
80107119:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010711e:	e9 44 f3 ff ff       	jmp    80106467 <alltraps>

80107123 <vector161>:
.globl vector161
vector161:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $161
80107125:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010712a:	e9 38 f3 ff ff       	jmp    80106467 <alltraps>

8010712f <vector162>:
.globl vector162
vector162:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $162
80107131:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107136:	e9 2c f3 ff ff       	jmp    80106467 <alltraps>

8010713b <vector163>:
.globl vector163
vector163:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $163
8010713d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107142:	e9 20 f3 ff ff       	jmp    80106467 <alltraps>

80107147 <vector164>:
.globl vector164
vector164:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $164
80107149:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010714e:	e9 14 f3 ff ff       	jmp    80106467 <alltraps>

80107153 <vector165>:
.globl vector165
vector165:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $165
80107155:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010715a:	e9 08 f3 ff ff       	jmp    80106467 <alltraps>

8010715f <vector166>:
.globl vector166
vector166:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $166
80107161:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107166:	e9 fc f2 ff ff       	jmp    80106467 <alltraps>

8010716b <vector167>:
.globl vector167
vector167:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $167
8010716d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107172:	e9 f0 f2 ff ff       	jmp    80106467 <alltraps>

80107177 <vector168>:
.globl vector168
vector168:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $168
80107179:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010717e:	e9 e4 f2 ff ff       	jmp    80106467 <alltraps>

80107183 <vector169>:
.globl vector169
vector169:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $169
80107185:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010718a:	e9 d8 f2 ff ff       	jmp    80106467 <alltraps>

8010718f <vector170>:
.globl vector170
vector170:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $170
80107191:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107196:	e9 cc f2 ff ff       	jmp    80106467 <alltraps>

8010719b <vector171>:
.globl vector171
vector171:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $171
8010719d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801071a2:	e9 c0 f2 ff ff       	jmp    80106467 <alltraps>

801071a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $172
801071a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801071ae:	e9 b4 f2 ff ff       	jmp    80106467 <alltraps>

801071b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $173
801071b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801071ba:	e9 a8 f2 ff ff       	jmp    80106467 <alltraps>

801071bf <vector174>:
.globl vector174
vector174:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $174
801071c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801071c6:	e9 9c f2 ff ff       	jmp    80106467 <alltraps>

801071cb <vector175>:
.globl vector175
vector175:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $175
801071cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801071d2:	e9 90 f2 ff ff       	jmp    80106467 <alltraps>

801071d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $176
801071d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801071de:	e9 84 f2 ff ff       	jmp    80106467 <alltraps>

801071e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $177
801071e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801071ea:	e9 78 f2 ff ff       	jmp    80106467 <alltraps>

801071ef <vector178>:
.globl vector178
vector178:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $178
801071f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801071f6:	e9 6c f2 ff ff       	jmp    80106467 <alltraps>

801071fb <vector179>:
.globl vector179
vector179:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $179
801071fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107202:	e9 60 f2 ff ff       	jmp    80106467 <alltraps>

80107207 <vector180>:
.globl vector180
vector180:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $180
80107209:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010720e:	e9 54 f2 ff ff       	jmp    80106467 <alltraps>

80107213 <vector181>:
.globl vector181
vector181:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $181
80107215:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010721a:	e9 48 f2 ff ff       	jmp    80106467 <alltraps>

8010721f <vector182>:
.globl vector182
vector182:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $182
80107221:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107226:	e9 3c f2 ff ff       	jmp    80106467 <alltraps>

8010722b <vector183>:
.globl vector183
vector183:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $183
8010722d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107232:	e9 30 f2 ff ff       	jmp    80106467 <alltraps>

80107237 <vector184>:
.globl vector184
vector184:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $184
80107239:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010723e:	e9 24 f2 ff ff       	jmp    80106467 <alltraps>

80107243 <vector185>:
.globl vector185
vector185:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $185
80107245:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010724a:	e9 18 f2 ff ff       	jmp    80106467 <alltraps>

8010724f <vector186>:
.globl vector186
vector186:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $186
80107251:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107256:	e9 0c f2 ff ff       	jmp    80106467 <alltraps>

8010725b <vector187>:
.globl vector187
vector187:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $187
8010725d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107262:	e9 00 f2 ff ff       	jmp    80106467 <alltraps>

80107267 <vector188>:
.globl vector188
vector188:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $188
80107269:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010726e:	e9 f4 f1 ff ff       	jmp    80106467 <alltraps>

80107273 <vector189>:
.globl vector189
vector189:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $189
80107275:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010727a:	e9 e8 f1 ff ff       	jmp    80106467 <alltraps>

8010727f <vector190>:
.globl vector190
vector190:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $190
80107281:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107286:	e9 dc f1 ff ff       	jmp    80106467 <alltraps>

8010728b <vector191>:
.globl vector191
vector191:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $191
8010728d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107292:	e9 d0 f1 ff ff       	jmp    80106467 <alltraps>

80107297 <vector192>:
.globl vector192
vector192:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $192
80107299:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010729e:	e9 c4 f1 ff ff       	jmp    80106467 <alltraps>

801072a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $193
801072a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801072aa:	e9 b8 f1 ff ff       	jmp    80106467 <alltraps>

801072af <vector194>:
.globl vector194
vector194:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $194
801072b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801072b6:	e9 ac f1 ff ff       	jmp    80106467 <alltraps>

801072bb <vector195>:
.globl vector195
vector195:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $195
801072bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801072c2:	e9 a0 f1 ff ff       	jmp    80106467 <alltraps>

801072c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $196
801072c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801072ce:	e9 94 f1 ff ff       	jmp    80106467 <alltraps>

801072d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $197
801072d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801072da:	e9 88 f1 ff ff       	jmp    80106467 <alltraps>

801072df <vector198>:
.globl vector198
vector198:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $198
801072e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801072e6:	e9 7c f1 ff ff       	jmp    80106467 <alltraps>

801072eb <vector199>:
.globl vector199
vector199:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $199
801072ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072f2:	e9 70 f1 ff ff       	jmp    80106467 <alltraps>

801072f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $200
801072f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801072fe:	e9 64 f1 ff ff       	jmp    80106467 <alltraps>

80107303 <vector201>:
.globl vector201
vector201:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $201
80107305:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010730a:	e9 58 f1 ff ff       	jmp    80106467 <alltraps>

8010730f <vector202>:
.globl vector202
vector202:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $202
80107311:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107316:	e9 4c f1 ff ff       	jmp    80106467 <alltraps>

8010731b <vector203>:
.globl vector203
vector203:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $203
8010731d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107322:	e9 40 f1 ff ff       	jmp    80106467 <alltraps>

80107327 <vector204>:
.globl vector204
vector204:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $204
80107329:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010732e:	e9 34 f1 ff ff       	jmp    80106467 <alltraps>

80107333 <vector205>:
.globl vector205
vector205:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $205
80107335:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010733a:	e9 28 f1 ff ff       	jmp    80106467 <alltraps>

8010733f <vector206>:
.globl vector206
vector206:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $206
80107341:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107346:	e9 1c f1 ff ff       	jmp    80106467 <alltraps>

8010734b <vector207>:
.globl vector207
vector207:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $207
8010734d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107352:	e9 10 f1 ff ff       	jmp    80106467 <alltraps>

80107357 <vector208>:
.globl vector208
vector208:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $208
80107359:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010735e:	e9 04 f1 ff ff       	jmp    80106467 <alltraps>

80107363 <vector209>:
.globl vector209
vector209:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $209
80107365:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010736a:	e9 f8 f0 ff ff       	jmp    80106467 <alltraps>

8010736f <vector210>:
.globl vector210
vector210:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $210
80107371:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107376:	e9 ec f0 ff ff       	jmp    80106467 <alltraps>

8010737b <vector211>:
.globl vector211
vector211:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $211
8010737d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107382:	e9 e0 f0 ff ff       	jmp    80106467 <alltraps>

80107387 <vector212>:
.globl vector212
vector212:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $212
80107389:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010738e:	e9 d4 f0 ff ff       	jmp    80106467 <alltraps>

80107393 <vector213>:
.globl vector213
vector213:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $213
80107395:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010739a:	e9 c8 f0 ff ff       	jmp    80106467 <alltraps>

8010739f <vector214>:
.globl vector214
vector214:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $214
801073a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801073a6:	e9 bc f0 ff ff       	jmp    80106467 <alltraps>

801073ab <vector215>:
.globl vector215
vector215:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $215
801073ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801073b2:	e9 b0 f0 ff ff       	jmp    80106467 <alltraps>

801073b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $216
801073b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801073be:	e9 a4 f0 ff ff       	jmp    80106467 <alltraps>

801073c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $217
801073c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801073ca:	e9 98 f0 ff ff       	jmp    80106467 <alltraps>

801073cf <vector218>:
.globl vector218
vector218:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $218
801073d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801073d6:	e9 8c f0 ff ff       	jmp    80106467 <alltraps>

801073db <vector219>:
.globl vector219
vector219:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $219
801073dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801073e2:	e9 80 f0 ff ff       	jmp    80106467 <alltraps>

801073e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $220
801073e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073ee:	e9 74 f0 ff ff       	jmp    80106467 <alltraps>

801073f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $221
801073f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801073fa:	e9 68 f0 ff ff       	jmp    80106467 <alltraps>

801073ff <vector222>:
.globl vector222
vector222:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $222
80107401:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107406:	e9 5c f0 ff ff       	jmp    80106467 <alltraps>

8010740b <vector223>:
.globl vector223
vector223:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $223
8010740d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107412:	e9 50 f0 ff ff       	jmp    80106467 <alltraps>

80107417 <vector224>:
.globl vector224
vector224:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $224
80107419:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010741e:	e9 44 f0 ff ff       	jmp    80106467 <alltraps>

80107423 <vector225>:
.globl vector225
vector225:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $225
80107425:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010742a:	e9 38 f0 ff ff       	jmp    80106467 <alltraps>

8010742f <vector226>:
.globl vector226
vector226:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $226
80107431:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107436:	e9 2c f0 ff ff       	jmp    80106467 <alltraps>

8010743b <vector227>:
.globl vector227
vector227:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $227
8010743d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107442:	e9 20 f0 ff ff       	jmp    80106467 <alltraps>

80107447 <vector228>:
.globl vector228
vector228:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $228
80107449:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010744e:	e9 14 f0 ff ff       	jmp    80106467 <alltraps>

80107453 <vector229>:
.globl vector229
vector229:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $229
80107455:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010745a:	e9 08 f0 ff ff       	jmp    80106467 <alltraps>

8010745f <vector230>:
.globl vector230
vector230:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $230
80107461:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107466:	e9 fc ef ff ff       	jmp    80106467 <alltraps>

8010746b <vector231>:
.globl vector231
vector231:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $231
8010746d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107472:	e9 f0 ef ff ff       	jmp    80106467 <alltraps>

80107477 <vector232>:
.globl vector232
vector232:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $232
80107479:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010747e:	e9 e4 ef ff ff       	jmp    80106467 <alltraps>

80107483 <vector233>:
.globl vector233
vector233:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $233
80107485:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010748a:	e9 d8 ef ff ff       	jmp    80106467 <alltraps>

8010748f <vector234>:
.globl vector234
vector234:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $234
80107491:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107496:	e9 cc ef ff ff       	jmp    80106467 <alltraps>

8010749b <vector235>:
.globl vector235
vector235:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $235
8010749d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801074a2:	e9 c0 ef ff ff       	jmp    80106467 <alltraps>

801074a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $236
801074a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801074ae:	e9 b4 ef ff ff       	jmp    80106467 <alltraps>

801074b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $237
801074b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801074ba:	e9 a8 ef ff ff       	jmp    80106467 <alltraps>

801074bf <vector238>:
.globl vector238
vector238:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $238
801074c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801074c6:	e9 9c ef ff ff       	jmp    80106467 <alltraps>

801074cb <vector239>:
.globl vector239
vector239:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $239
801074cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801074d2:	e9 90 ef ff ff       	jmp    80106467 <alltraps>

801074d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $240
801074d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801074de:	e9 84 ef ff ff       	jmp    80106467 <alltraps>

801074e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $241
801074e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801074ea:	e9 78 ef ff ff       	jmp    80106467 <alltraps>

801074ef <vector242>:
.globl vector242
vector242:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $242
801074f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801074f6:	e9 6c ef ff ff       	jmp    80106467 <alltraps>

801074fb <vector243>:
.globl vector243
vector243:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $243
801074fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107502:	e9 60 ef ff ff       	jmp    80106467 <alltraps>

80107507 <vector244>:
.globl vector244
vector244:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $244
80107509:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010750e:	e9 54 ef ff ff       	jmp    80106467 <alltraps>

80107513 <vector245>:
.globl vector245
vector245:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $245
80107515:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010751a:	e9 48 ef ff ff       	jmp    80106467 <alltraps>

8010751f <vector246>:
.globl vector246
vector246:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $246
80107521:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107526:	e9 3c ef ff ff       	jmp    80106467 <alltraps>

8010752b <vector247>:
.globl vector247
vector247:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $247
8010752d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107532:	e9 30 ef ff ff       	jmp    80106467 <alltraps>

80107537 <vector248>:
.globl vector248
vector248:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $248
80107539:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010753e:	e9 24 ef ff ff       	jmp    80106467 <alltraps>

80107543 <vector249>:
.globl vector249
vector249:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $249
80107545:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010754a:	e9 18 ef ff ff       	jmp    80106467 <alltraps>

8010754f <vector250>:
.globl vector250
vector250:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $250
80107551:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107556:	e9 0c ef ff ff       	jmp    80106467 <alltraps>

8010755b <vector251>:
.globl vector251
vector251:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $251
8010755d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107562:	e9 00 ef ff ff       	jmp    80106467 <alltraps>

80107567 <vector252>:
.globl vector252
vector252:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $252
80107569:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010756e:	e9 f4 ee ff ff       	jmp    80106467 <alltraps>

80107573 <vector253>:
.globl vector253
vector253:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $253
80107575:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010757a:	e9 e8 ee ff ff       	jmp    80106467 <alltraps>

8010757f <vector254>:
.globl vector254
vector254:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $254
80107581:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107586:	e9 dc ee ff ff       	jmp    80106467 <alltraps>

8010758b <vector255>:
.globl vector255
vector255:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $255
8010758d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107592:	e9 d0 ee ff ff       	jmp    80106467 <alltraps>
80107597:	66 90                	xchg   %ax,%ax
80107599:	66 90                	xchg   %ax,%ax
8010759b:	66 90                	xchg   %ax,%ax
8010759d:	66 90                	xchg   %ax,%ax
8010759f:	90                   	nop

801075a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801075a6:	89 d3                	mov    %edx,%ebx
{
801075a8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801075aa:	c1 eb 16             	shr    $0x16,%ebx
801075ad:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801075b0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801075b3:	8b 06                	mov    (%esi),%eax
801075b5:	a8 01                	test   $0x1,%al
801075b7:	74 27                	je     801075e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075be:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801075c4:	c1 ef 0a             	shr    $0xa,%edi
}
801075c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801075ca:	89 fa                	mov    %edi,%edx
801075cc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075d2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801075d5:	5b                   	pop    %ebx
801075d6:	5e                   	pop    %esi
801075d7:	5f                   	pop    %edi
801075d8:	5d                   	pop    %ebp
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801075e0:	85 c9                	test   %ecx,%ecx
801075e2:	74 2c                	je     80107610 <walkpgdir+0x70>
801075e4:	e8 57 b0 ff ff       	call   80102640 <kalloc>
801075e9:	85 c0                	test   %eax,%eax
801075eb:	89 c3                	mov    %eax,%ebx
801075ed:	74 21                	je     80107610 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801075ef:	83 ec 04             	sub    $0x4,%esp
801075f2:	68 00 10 00 00       	push   $0x1000
801075f7:	6a 00                	push   $0x0
801075f9:	50                   	push   %eax
801075fa:	e8 11 d9 ff ff       	call   80104f10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801075ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107605:	83 c4 10             	add    $0x10,%esp
80107608:	83 c8 07             	or     $0x7,%eax
8010760b:	89 06                	mov    %eax,(%esi)
8010760d:	eb b5                	jmp    801075c4 <walkpgdir+0x24>
8010760f:	90                   	nop
}
80107610:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107613:	31 c0                	xor    %eax,%eax
}
80107615:	5b                   	pop    %ebx
80107616:	5e                   	pop    %esi
80107617:	5f                   	pop    %edi
80107618:	5d                   	pop    %ebp
80107619:	c3                   	ret    
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107620 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107626:	89 d3                	mov    %edx,%ebx
80107628:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010762e:	83 ec 1c             	sub    $0x1c,%esp
80107631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107634:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107638:	8b 7d 08             	mov    0x8(%ebp),%edi
8010763b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107643:	8b 45 0c             	mov    0xc(%ebp),%eax
80107646:	29 df                	sub    %ebx,%edi
80107648:	83 c8 01             	or     $0x1,%eax
8010764b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010764e:	eb 15                	jmp    80107665 <mappages+0x45>
    if(*pte & PTE_P)
80107650:	f6 00 01             	testb  $0x1,(%eax)
80107653:	75 45                	jne    8010769a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107655:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107658:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010765b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010765d:	74 31                	je     80107690 <mappages+0x70>
      break;
    a += PGSIZE;
8010765f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107668:	b9 01 00 00 00       	mov    $0x1,%ecx
8010766d:	89 da                	mov    %ebx,%edx
8010766f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107672:	e8 29 ff ff ff       	call   801075a0 <walkpgdir>
80107677:	85 c0                	test   %eax,%eax
80107679:	75 d5                	jne    80107650 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010767b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010767e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107683:	5b                   	pop    %ebx
80107684:	5e                   	pop    %esi
80107685:	5f                   	pop    %edi
80107686:	5d                   	pop    %ebp
80107687:	c3                   	ret    
80107688:	90                   	nop
80107689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107693:	31 c0                	xor    %eax,%eax
}
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret    
      panic("remap");
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	68 50 9b 10 80       	push   $0x80109b50
801076a2:	e8 e9 8c ff ff       	call   80100390 <panic>
801076a7:	89 f6                	mov    %esi,%esi
801076a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801076b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076bc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801076be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076c4:	83 ec 1c             	sub    $0x1c,%esp
801076c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801076ca:	39 d3                	cmp    %edx,%ebx
801076cc:	73 66                	jae    80107734 <deallocuvm.part.0+0x84>
801076ce:	89 d6                	mov    %edx,%esi
801076d0:	eb 3d                	jmp    8010770f <deallocuvm.part.0+0x5f>
801076d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801076d8:	8b 10                	mov    (%eax),%edx
801076da:	f6 c2 01             	test   $0x1,%dl
801076dd:	74 26                	je     80107705 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801076df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076e5:	74 58                	je     8010773f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801076e7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076ea:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801076f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801076f3:	52                   	push   %edx
801076f4:	e8 97 ad ff ff       	call   80102490 <kfree>
      *pte = 0;
801076f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076fc:	83 c4 10             	add    $0x10,%esp
801076ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107705:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010770b:	39 f3                	cmp    %esi,%ebx
8010770d:	73 25                	jae    80107734 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010770f:	31 c9                	xor    %ecx,%ecx
80107711:	89 da                	mov    %ebx,%edx
80107713:	89 f8                	mov    %edi,%eax
80107715:	e8 86 fe ff ff       	call   801075a0 <walkpgdir>
    if(!pte)
8010771a:	85 c0                	test   %eax,%eax
8010771c:	75 ba                	jne    801076d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010771e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107724:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010772a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107730:	39 f3                	cmp    %esi,%ebx
80107732:	72 db                	jb     8010770f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107734:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773a:	5b                   	pop    %ebx
8010773b:	5e                   	pop    %esi
8010773c:	5f                   	pop    %edi
8010773d:	5d                   	pop    %ebp
8010773e:	c3                   	ret    
        panic("kfree");
8010773f:	83 ec 0c             	sub    $0xc,%esp
80107742:	68 26 94 10 80       	push   $0x80109426
80107747:	e8 44 8c ff ff       	call   80100390 <panic>
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107750 <seginit>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107756:	e8 25 c2 ff ff       	call   80103980 <cpuid>
8010775b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107761:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107766:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010776a:	c7 80 58 4a 11 80 ff 	movl   $0xffff,-0x7feeb5a8(%eax)
80107771:	ff 00 00 
80107774:	c7 80 5c 4a 11 80 00 	movl   $0xcf9a00,-0x7feeb5a4(%eax)
8010777b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010777e:	c7 80 60 4a 11 80 ff 	movl   $0xffff,-0x7feeb5a0(%eax)
80107785:	ff 00 00 
80107788:	c7 80 64 4a 11 80 00 	movl   $0xcf9200,-0x7feeb59c(%eax)
8010778f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107792:	c7 80 68 4a 11 80 ff 	movl   $0xffff,-0x7feeb598(%eax)
80107799:	ff 00 00 
8010779c:	c7 80 6c 4a 11 80 00 	movl   $0xcffa00,-0x7feeb594(%eax)
801077a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801077a6:	c7 80 70 4a 11 80 ff 	movl   $0xffff,-0x7feeb590(%eax)
801077ad:	ff 00 00 
801077b0:	c7 80 74 4a 11 80 00 	movl   $0xcff200,-0x7feeb58c(%eax)
801077b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801077ba:	05 50 4a 11 80       	add    $0x80114a50,%eax
  pd[1] = (uint)p;
801077bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801077c3:	c1 e8 10             	shr    $0x10,%eax
801077c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077cd:	0f 01 10             	lgdtl  (%eax)
}
801077d0:	c9                   	leave  
801077d1:	c3                   	ret    
801077d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077e0:	a1 04 a7 11 80       	mov    0x8011a704,%eax
{
801077e5:	55                   	push   %ebp
801077e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077ed:	0f 22 d8             	mov    %eax,%cr3
}
801077f0:	5d                   	pop    %ebp
801077f1:	c3                   	ret    
801077f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107800 <switchuvm>:
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	83 ec 1c             	sub    $0x1c,%esp
80107809:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010780c:	85 db                	test   %ebx,%ebx
8010780e:	0f 84 cb 00 00 00    	je     801078df <switchuvm+0xdf>
  if(p->kstack == 0)
80107814:	8b 43 08             	mov    0x8(%ebx),%eax
80107817:	85 c0                	test   %eax,%eax
80107819:	0f 84 da 00 00 00    	je     801078f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010781f:	8b 43 04             	mov    0x4(%ebx),%eax
80107822:	85 c0                	test   %eax,%eax
80107824:	0f 84 c2 00 00 00    	je     801078ec <switchuvm+0xec>
  pushcli();
8010782a:	e8 e1 d4 ff ff       	call   80104d10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010782f:	e8 cc c0 ff ff       	call   80103900 <mycpu>
80107834:	89 c6                	mov    %eax,%esi
80107836:	e8 c5 c0 ff ff       	call   80103900 <mycpu>
8010783b:	89 c7                	mov    %eax,%edi
8010783d:	e8 be c0 ff ff       	call   80103900 <mycpu>
80107842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107845:	83 c7 08             	add    $0x8,%edi
80107848:	e8 b3 c0 ff ff       	call   80103900 <mycpu>
8010784d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107850:	83 c0 08             	add    $0x8,%eax
80107853:	ba 67 00 00 00       	mov    $0x67,%edx
80107858:	c1 e8 18             	shr    $0x18,%eax
8010785b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107862:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107869:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010786f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107874:	83 c1 08             	add    $0x8,%ecx
80107877:	c1 e9 10             	shr    $0x10,%ecx
8010787a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107880:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107885:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010788c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107891:	e8 6a c0 ff ff       	call   80103900 <mycpu>
80107896:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010789d:	e8 5e c0 ff ff       	call   80103900 <mycpu>
801078a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801078a6:	8b 73 08             	mov    0x8(%ebx),%esi
801078a9:	e8 52 c0 ff ff       	call   80103900 <mycpu>
801078ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078b7:	e8 44 c0 ff ff       	call   80103900 <mycpu>
801078bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801078c0:	b8 28 00 00 00       	mov    $0x28,%eax
801078c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801078c8:	8b 43 04             	mov    0x4(%ebx),%eax
801078cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078d0:	0f 22 d8             	mov    %eax,%cr3
}
801078d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d6:	5b                   	pop    %ebx
801078d7:	5e                   	pop    %esi
801078d8:	5f                   	pop    %edi
801078d9:	5d                   	pop    %ebp
  popcli();
801078da:	e9 71 d4 ff ff       	jmp    80104d50 <popcli>
    panic("switchuvm: no process");
801078df:	83 ec 0c             	sub    $0xc,%esp
801078e2:	68 56 9b 10 80       	push   $0x80109b56
801078e7:	e8 a4 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801078ec:	83 ec 0c             	sub    $0xc,%esp
801078ef:	68 81 9b 10 80       	push   $0x80109b81
801078f4:	e8 97 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078f9:	83 ec 0c             	sub    $0xc,%esp
801078fc:	68 6c 9b 10 80       	push   $0x80109b6c
80107901:	e8 8a 8a ff ff       	call   80100390 <panic>
80107906:	8d 76 00             	lea    0x0(%esi),%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107910 <inituvm>:
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	57                   	push   %edi
80107914:	56                   	push   %esi
80107915:	53                   	push   %ebx
80107916:	83 ec 1c             	sub    $0x1c,%esp
80107919:	8b 75 10             	mov    0x10(%ebp),%esi
8010791c:	8b 45 08             	mov    0x8(%ebp),%eax
8010791f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107922:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107928:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010792b:	77 49                	ja     80107976 <inituvm+0x66>
  mem = kalloc();
8010792d:	e8 0e ad ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80107932:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107935:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107937:	68 00 10 00 00       	push   $0x1000
8010793c:	6a 00                	push   $0x0
8010793e:	50                   	push   %eax
8010793f:	e8 cc d5 ff ff       	call   80104f10 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107944:	58                   	pop    %eax
80107945:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010794b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107950:	5a                   	pop    %edx
80107951:	6a 06                	push   $0x6
80107953:	50                   	push   %eax
80107954:	31 d2                	xor    %edx,%edx
80107956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107959:	e8 c2 fc ff ff       	call   80107620 <mappages>
  memmove(mem, init, sz);
8010795e:	89 75 10             	mov    %esi,0x10(%ebp)
80107961:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107964:	83 c4 10             	add    $0x10,%esp
80107967:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010796a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010796d:	5b                   	pop    %ebx
8010796e:	5e                   	pop    %esi
8010796f:	5f                   	pop    %edi
80107970:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107971:	e9 4a d6 ff ff       	jmp    80104fc0 <memmove>
    panic("inituvm: more than a page");
80107976:	83 ec 0c             	sub    $0xc,%esp
80107979:	68 95 9b 10 80       	push   $0x80109b95
8010797e:	e8 0d 8a ff ff       	call   80100390 <panic>
80107983:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107990 <loaduvm>:
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107999:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801079a0:	0f 85 91 00 00 00    	jne    80107a37 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801079a6:	8b 75 18             	mov    0x18(%ebp),%esi
801079a9:	31 db                	xor    %ebx,%ebx
801079ab:	85 f6                	test   %esi,%esi
801079ad:	75 1a                	jne    801079c9 <loaduvm+0x39>
801079af:	eb 6f                	jmp    80107a20 <loaduvm+0x90>
801079b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801079c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801079c7:	76 57                	jbe    80107a20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801079c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801079cc:	8b 45 08             	mov    0x8(%ebp),%eax
801079cf:	31 c9                	xor    %ecx,%ecx
801079d1:	01 da                	add    %ebx,%edx
801079d3:	e8 c8 fb ff ff       	call   801075a0 <walkpgdir>
801079d8:	85 c0                	test   %eax,%eax
801079da:	74 4e                	je     80107a2a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801079dc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079de:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801079e1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801079e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801079eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079f1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079f4:	01 d9                	add    %ebx,%ecx
801079f6:	05 00 00 00 80       	add    $0x80000000,%eax
801079fb:	57                   	push   %edi
801079fc:	51                   	push   %ecx
801079fd:	50                   	push   %eax
801079fe:	ff 75 10             	pushl  0x10(%ebp)
80107a01:	e8 da a0 ff ff       	call   80101ae0 <readi>
80107a06:	83 c4 10             	add    $0x10,%esp
80107a09:	39 f8                	cmp    %edi,%eax
80107a0b:	74 ab                	je     801079b8 <loaduvm+0x28>
}
80107a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a15:	5b                   	pop    %ebx
80107a16:	5e                   	pop    %esi
80107a17:	5f                   	pop    %edi
80107a18:	5d                   	pop    %ebp
80107a19:	c3                   	ret    
80107a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a23:	31 c0                	xor    %eax,%eax
}
80107a25:	5b                   	pop    %ebx
80107a26:	5e                   	pop    %esi
80107a27:	5f                   	pop    %edi
80107a28:	5d                   	pop    %ebp
80107a29:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a2a:	83 ec 0c             	sub    $0xc,%esp
80107a2d:	68 af 9b 10 80       	push   $0x80109baf
80107a32:	e8 59 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107a37:	83 ec 0c             	sub    $0xc,%esp
80107a3a:	68 50 9c 10 80       	push   $0x80109c50
80107a3f:	e8 4c 89 ff ff       	call   80100390 <panic>
80107a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a50 <allocuvm>:
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	53                   	push   %ebx
80107a56:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107a59:	8b 7d 10             	mov    0x10(%ebp),%edi
80107a5c:	85 ff                	test   %edi,%edi
80107a5e:	0f 88 8e 00 00 00    	js     80107af2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107a64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107a67:	0f 82 93 00 00 00    	jb     80107b00 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107a76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107a7c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107a7f:	0f 86 7e 00 00 00    	jbe    80107b03 <allocuvm+0xb3>
80107a85:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107a88:	8b 7d 08             	mov    0x8(%ebp),%edi
80107a8b:	eb 42                	jmp    80107acf <allocuvm+0x7f>
80107a8d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107a90:	83 ec 04             	sub    $0x4,%esp
80107a93:	68 00 10 00 00       	push   $0x1000
80107a98:	6a 00                	push   $0x0
80107a9a:	50                   	push   %eax
80107a9b:	e8 70 d4 ff ff       	call   80104f10 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107aa0:	58                   	pop    %eax
80107aa1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107aa7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107aac:	5a                   	pop    %edx
80107aad:	6a 06                	push   $0x6
80107aaf:	50                   	push   %eax
80107ab0:	89 da                	mov    %ebx,%edx
80107ab2:	89 f8                	mov    %edi,%eax
80107ab4:	e8 67 fb ff ff       	call   80107620 <mappages>
80107ab9:	83 c4 10             	add    $0x10,%esp
80107abc:	85 c0                	test   %eax,%eax
80107abe:	78 50                	js     80107b10 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107ac0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ac6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107ac9:	0f 86 81 00 00 00    	jbe    80107b50 <allocuvm+0x100>
    mem = kalloc();
80107acf:	e8 6c ab ff ff       	call   80102640 <kalloc>
    if(mem == 0){
80107ad4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107ad6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107ad8:	75 b6                	jne    80107a90 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107ada:	83 ec 0c             	sub    $0xc,%esp
80107add:	68 cd 9b 10 80       	push   $0x80109bcd
80107ae2:	e8 79 8b ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107ae7:	83 c4 10             	add    $0x10,%esp
80107aea:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aed:	39 45 10             	cmp    %eax,0x10(%ebp)
80107af0:	77 6e                	ja     80107b60 <allocuvm+0x110>
}
80107af2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107af5:	31 ff                	xor    %edi,%edi
}
80107af7:	89 f8                	mov    %edi,%eax
80107af9:	5b                   	pop    %ebx
80107afa:	5e                   	pop    %esi
80107afb:	5f                   	pop    %edi
80107afc:	5d                   	pop    %ebp
80107afd:	c3                   	ret    
80107afe:	66 90                	xchg   %ax,%ax
    return oldsz;
80107b00:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b06:	89 f8                	mov    %edi,%eax
80107b08:	5b                   	pop    %ebx
80107b09:	5e                   	pop    %esi
80107b0a:	5f                   	pop    %edi
80107b0b:	5d                   	pop    %ebp
80107b0c:	c3                   	ret    
80107b0d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107b10:	83 ec 0c             	sub    $0xc,%esp
80107b13:	68 e5 9b 10 80       	push   $0x80109be5
80107b18:	e8 43 8b ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107b1d:	83 c4 10             	add    $0x10,%esp
80107b20:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b23:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b26:	76 0d                	jbe    80107b35 <allocuvm+0xe5>
80107b28:	89 c1                	mov    %eax,%ecx
80107b2a:	8b 55 10             	mov    0x10(%ebp),%edx
80107b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b30:	e8 7b fb ff ff       	call   801076b0 <deallocuvm.part.0>
      kfree(mem);
80107b35:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107b38:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107b3a:	56                   	push   %esi
80107b3b:	e8 50 a9 ff ff       	call   80102490 <kfree>
      return 0;
80107b40:	83 c4 10             	add    $0x10,%esp
}
80107b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b46:	89 f8                	mov    %edi,%eax
80107b48:	5b                   	pop    %ebx
80107b49:	5e                   	pop    %esi
80107b4a:	5f                   	pop    %edi
80107b4b:	5d                   	pop    %ebp
80107b4c:	c3                   	ret    
80107b4d:	8d 76 00             	lea    0x0(%esi),%esi
80107b50:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b56:	5b                   	pop    %ebx
80107b57:	89 f8                	mov    %edi,%eax
80107b59:	5e                   	pop    %esi
80107b5a:	5f                   	pop    %edi
80107b5b:	5d                   	pop    %ebp
80107b5c:	c3                   	ret    
80107b5d:	8d 76 00             	lea    0x0(%esi),%esi
80107b60:	89 c1                	mov    %eax,%ecx
80107b62:	8b 55 10             	mov    0x10(%ebp),%edx
80107b65:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107b68:	31 ff                	xor    %edi,%edi
80107b6a:	e8 41 fb ff ff       	call   801076b0 <deallocuvm.part.0>
80107b6f:	eb 92                	jmp    80107b03 <allocuvm+0xb3>
80107b71:	eb 0d                	jmp    80107b80 <deallocuvm>
80107b73:	90                   	nop
80107b74:	90                   	nop
80107b75:	90                   	nop
80107b76:	90                   	nop
80107b77:	90                   	nop
80107b78:	90                   	nop
80107b79:	90                   	nop
80107b7a:	90                   	nop
80107b7b:	90                   	nop
80107b7c:	90                   	nop
80107b7d:	90                   	nop
80107b7e:	90                   	nop
80107b7f:	90                   	nop

80107b80 <deallocuvm>:
{
80107b80:	55                   	push   %ebp
80107b81:	89 e5                	mov    %esp,%ebp
80107b83:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107b89:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107b8c:	39 d1                	cmp    %edx,%ecx
80107b8e:	73 10                	jae    80107ba0 <deallocuvm+0x20>
}
80107b90:	5d                   	pop    %ebp
80107b91:	e9 1a fb ff ff       	jmp    801076b0 <deallocuvm.part.0>
80107b96:	8d 76 00             	lea    0x0(%esi),%esi
80107b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107ba0:	89 d0                	mov    %edx,%eax
80107ba2:	5d                   	pop    %ebp
80107ba3:	c3                   	ret    
80107ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107bb0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107bb0:	55                   	push   %ebp
80107bb1:	89 e5                	mov    %esp,%ebp
80107bb3:	57                   	push   %edi
80107bb4:	56                   	push   %esi
80107bb5:	53                   	push   %ebx
80107bb6:	83 ec 0c             	sub    $0xc,%esp
80107bb9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107bbc:	85 f6                	test   %esi,%esi
80107bbe:	74 59                	je     80107c19 <freevm+0x69>
80107bc0:	31 c9                	xor    %ecx,%ecx
80107bc2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107bc7:	89 f0                	mov    %esi,%eax
80107bc9:	e8 e2 fa ff ff       	call   801076b0 <deallocuvm.part.0>
80107bce:	89 f3                	mov    %esi,%ebx
80107bd0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107bd6:	eb 0f                	jmp    80107be7 <freevm+0x37>
80107bd8:	90                   	nop
80107bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107be0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107be3:	39 fb                	cmp    %edi,%ebx
80107be5:	74 23                	je     80107c0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107be7:	8b 03                	mov    (%ebx),%eax
80107be9:	a8 01                	test   $0x1,%al
80107beb:	74 f3                	je     80107be0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107bf2:	83 ec 0c             	sub    $0xc,%esp
80107bf5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bf8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107bfd:	50                   	push   %eax
80107bfe:	e8 8d a8 ff ff       	call   80102490 <kfree>
80107c03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c06:	39 fb                	cmp    %edi,%ebx
80107c08:	75 dd                	jne    80107be7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107c0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c10:	5b                   	pop    %ebx
80107c11:	5e                   	pop    %esi
80107c12:	5f                   	pop    %edi
80107c13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107c14:	e9 77 a8 ff ff       	jmp    80102490 <kfree>
    panic("freevm: no pgdir");
80107c19:	83 ec 0c             	sub    $0xc,%esp
80107c1c:	68 01 9c 10 80       	push   $0x80109c01
80107c21:	e8 6a 87 ff ff       	call   80100390 <panic>
80107c26:	8d 76 00             	lea    0x0(%esi),%esi
80107c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c30 <setupkvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	56                   	push   %esi
80107c34:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107c35:	e8 06 aa ff ff       	call   80102640 <kalloc>
80107c3a:	85 c0                	test   %eax,%eax
80107c3c:	89 c6                	mov    %eax,%esi
80107c3e:	74 42                	je     80107c82 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107c40:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c43:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107c48:	68 00 10 00 00       	push   $0x1000
80107c4d:	6a 00                	push   $0x0
80107c4f:	50                   	push   %eax
80107c50:	e8 bb d2 ff ff       	call   80104f10 <memset>
80107c55:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107c58:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c5b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107c5e:	83 ec 08             	sub    $0x8,%esp
80107c61:	8b 13                	mov    (%ebx),%edx
80107c63:	ff 73 0c             	pushl  0xc(%ebx)
80107c66:	50                   	push   %eax
80107c67:	29 c1                	sub    %eax,%ecx
80107c69:	89 f0                	mov    %esi,%eax
80107c6b:	e8 b0 f9 ff ff       	call   80107620 <mappages>
80107c70:	83 c4 10             	add    $0x10,%esp
80107c73:	85 c0                	test   %eax,%eax
80107c75:	78 19                	js     80107c90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c77:	83 c3 10             	add    $0x10,%ebx
80107c7a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107c80:	75 d6                	jne    80107c58 <setupkvm+0x28>
}
80107c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c85:	89 f0                	mov    %esi,%eax
80107c87:	5b                   	pop    %ebx
80107c88:	5e                   	pop    %esi
80107c89:	5d                   	pop    %ebp
80107c8a:	c3                   	ret    
80107c8b:	90                   	nop
80107c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107c90:	83 ec 0c             	sub    $0xc,%esp
80107c93:	56                   	push   %esi
      return 0;
80107c94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107c96:	e8 15 ff ff ff       	call   80107bb0 <freevm>
      return 0;
80107c9b:	83 c4 10             	add    $0x10,%esp
}
80107c9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ca1:	89 f0                	mov    %esi,%eax
80107ca3:	5b                   	pop    %ebx
80107ca4:	5e                   	pop    %esi
80107ca5:	5d                   	pop    %ebp
80107ca6:	c3                   	ret    
80107ca7:	89 f6                	mov    %esi,%esi
80107ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107cb0 <kvmalloc>:
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107cb6:	e8 75 ff ff ff       	call   80107c30 <setupkvm>
80107cbb:	a3 04 a7 11 80       	mov    %eax,0x8011a704
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107cc0:	05 00 00 00 80       	add    $0x80000000,%eax
80107cc5:	0f 22 d8             	mov    %eax,%cr3
}
80107cc8:	c9                   	leave  
80107cc9:	c3                   	ret    
80107cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107cd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107cd1:	31 c9                	xor    %ecx,%ecx
{
80107cd3:	89 e5                	mov    %esp,%ebp
80107cd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107cde:	e8 bd f8 ff ff       	call   801075a0 <walkpgdir>
  if(pte == 0)
80107ce3:	85 c0                	test   %eax,%eax
80107ce5:	74 05                	je     80107cec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ce7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107cea:	c9                   	leave  
80107ceb:	c3                   	ret    
    panic("clearpteu");
80107cec:	83 ec 0c             	sub    $0xc,%esp
80107cef:	68 12 9c 10 80       	push   $0x80109c12
80107cf4:	e8 97 86 ff ff       	call   80100390 <panic>
80107cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107d00:	55                   	push   %ebp
80107d01:	89 e5                	mov    %esp,%ebp
80107d03:	57                   	push   %edi
80107d04:	56                   	push   %esi
80107d05:	53                   	push   %ebx
80107d06:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107d09:	e8 22 ff ff ff       	call   80107c30 <setupkvm>
80107d0e:	85 c0                	test   %eax,%eax
80107d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d13:	0f 84 9f 00 00 00    	je     80107db8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107d19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107d1c:	85 c9                	test   %ecx,%ecx
80107d1e:	0f 84 94 00 00 00    	je     80107db8 <copyuvm+0xb8>
80107d24:	31 ff                	xor    %edi,%edi
80107d26:	eb 4a                	jmp    80107d72 <copyuvm+0x72>
80107d28:	90                   	nop
80107d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d30:	83 ec 04             	sub    $0x4,%esp
80107d33:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107d39:	68 00 10 00 00       	push   $0x1000
80107d3e:	53                   	push   %ebx
80107d3f:	50                   	push   %eax
80107d40:	e8 7b d2 ff ff       	call   80104fc0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107d45:	58                   	pop    %eax
80107d46:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107d4c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d51:	5a                   	pop    %edx
80107d52:	ff 75 e4             	pushl  -0x1c(%ebp)
80107d55:	50                   	push   %eax
80107d56:	89 fa                	mov    %edi,%edx
80107d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d5b:	e8 c0 f8 ff ff       	call   80107620 <mappages>
80107d60:	83 c4 10             	add    $0x10,%esp
80107d63:	85 c0                	test   %eax,%eax
80107d65:	78 61                	js     80107dc8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107d67:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107d6d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107d70:	76 46                	jbe    80107db8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107d72:	8b 45 08             	mov    0x8(%ebp),%eax
80107d75:	31 c9                	xor    %ecx,%ecx
80107d77:	89 fa                	mov    %edi,%edx
80107d79:	e8 22 f8 ff ff       	call   801075a0 <walkpgdir>
80107d7e:	85 c0                	test   %eax,%eax
80107d80:	74 61                	je     80107de3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107d82:	8b 00                	mov    (%eax),%eax
80107d84:	a8 01                	test   $0x1,%al
80107d86:	74 4e                	je     80107dd6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107d88:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107d8a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107d8f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107d98:	e8 a3 a8 ff ff       	call   80102640 <kalloc>
80107d9d:	85 c0                	test   %eax,%eax
80107d9f:	89 c6                	mov    %eax,%esi
80107da1:	75 8d                	jne    80107d30 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107da3:	83 ec 0c             	sub    $0xc,%esp
80107da6:	ff 75 e0             	pushl  -0x20(%ebp)
80107da9:	e8 02 fe ff ff       	call   80107bb0 <freevm>
  return 0;
80107dae:	83 c4 10             	add    $0x10,%esp
80107db1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dbe:	5b                   	pop    %ebx
80107dbf:	5e                   	pop    %esi
80107dc0:	5f                   	pop    %edi
80107dc1:	5d                   	pop    %ebp
80107dc2:	c3                   	ret    
80107dc3:	90                   	nop
80107dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107dc8:	83 ec 0c             	sub    $0xc,%esp
80107dcb:	56                   	push   %esi
80107dcc:	e8 bf a6 ff ff       	call   80102490 <kfree>
      goto bad;
80107dd1:	83 c4 10             	add    $0x10,%esp
80107dd4:	eb cd                	jmp    80107da3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107dd6:	83 ec 0c             	sub    $0xc,%esp
80107dd9:	68 36 9c 10 80       	push   $0x80109c36
80107dde:	e8 ad 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107de3:	83 ec 0c             	sub    $0xc,%esp
80107de6:	68 1c 9c 10 80       	push   $0x80109c1c
80107deb:	e8 a0 85 ff ff       	call   80100390 <panic>

80107df0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107df0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107df1:	31 c9                	xor    %ecx,%ecx
{
80107df3:	89 e5                	mov    %esp,%ebp
80107df5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107df8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dfe:	e8 9d f7 ff ff       	call   801075a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107e03:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107e05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107e06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107e0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107e10:	05 00 00 00 80       	add    $0x80000000,%eax
80107e15:	83 fa 05             	cmp    $0x5,%edx
80107e18:	ba 00 00 00 00       	mov    $0x0,%edx
80107e1d:	0f 45 c2             	cmovne %edx,%eax
}
80107e20:	c3                   	ret    
80107e21:	eb 0d                	jmp    80107e30 <copyout>
80107e23:	90                   	nop
80107e24:	90                   	nop
80107e25:	90                   	nop
80107e26:	90                   	nop
80107e27:	90                   	nop
80107e28:	90                   	nop
80107e29:	90                   	nop
80107e2a:	90                   	nop
80107e2b:	90                   	nop
80107e2c:	90                   	nop
80107e2d:	90                   	nop
80107e2e:	90                   	nop
80107e2f:	90                   	nop

80107e30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107e30:	55                   	push   %ebp
80107e31:	89 e5                	mov    %esp,%ebp
80107e33:	57                   	push   %edi
80107e34:	56                   	push   %esi
80107e35:	53                   	push   %ebx
80107e36:	83 ec 1c             	sub    $0x1c,%esp
80107e39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107e42:	85 db                	test   %ebx,%ebx
80107e44:	75 40                	jne    80107e86 <copyout+0x56>
80107e46:	eb 70                	jmp    80107eb8 <copyout+0x88>
80107e48:	90                   	nop
80107e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107e50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107e53:	89 f1                	mov    %esi,%ecx
80107e55:	29 d1                	sub    %edx,%ecx
80107e57:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107e5d:	39 d9                	cmp    %ebx,%ecx
80107e5f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107e62:	29 f2                	sub    %esi,%edx
80107e64:	83 ec 04             	sub    $0x4,%esp
80107e67:	01 d0                	add    %edx,%eax
80107e69:	51                   	push   %ecx
80107e6a:	57                   	push   %edi
80107e6b:	50                   	push   %eax
80107e6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107e6f:	e8 4c d1 ff ff       	call   80104fc0 <memmove>
    len -= n;
    buf += n;
80107e74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107e77:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107e7a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107e80:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107e82:	29 cb                	sub    %ecx,%ebx
80107e84:	74 32                	je     80107eb8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107e86:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e88:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107e8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107e8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e94:	56                   	push   %esi
80107e95:	ff 75 08             	pushl  0x8(%ebp)
80107e98:	e8 53 ff ff ff       	call   80107df0 <uva2ka>
    if(pa0 == 0)
80107e9d:	83 c4 10             	add    $0x10,%esp
80107ea0:	85 c0                	test   %eax,%eax
80107ea2:	75 ac                	jne    80107e50 <copyout+0x20>
  }
  return 0;
}
80107ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107eac:	5b                   	pop    %ebx
80107ead:	5e                   	pop    %esi
80107eae:	5f                   	pop    %edi
80107eaf:	5d                   	pop    %ebp
80107eb0:	c3                   	ret    
80107eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ebb:	31 c0                	xor    %eax,%eax
}
80107ebd:	5b                   	pop    %ebx
80107ebe:	5e                   	pop    %esi
80107ebf:	5f                   	pop    %edi
80107ec0:	5d                   	pop    %ebp
80107ec1:	c3                   	ret    
80107ec2:	66 90                	xchg   %ax,%ax
80107ec4:	66 90                	xchg   %ax,%ax
80107ec6:	66 90                	xchg   %ax,%ax
80107ec8:	66 90                	xchg   %ax,%ax
80107eca:	66 90                	xchg   %ax,%ax
80107ecc:	66 90                	xchg   %ax,%ax
80107ece:	66 90                	xchg   %ax,%ax

80107ed0 <my_syscall>:
#include "defs.h"

// Simple system call
int
my_syscall(char *str)
{
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
80107ed3:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", str);
80107ed6:	ff 75 08             	pushl  0x8(%ebp)
80107ed9:	68 74 9c 10 80       	push   $0x80109c74
80107ede:	e8 7d 87 ff ff       	call   80100660 <cprintf>
	return 0xABCDABCD;
}
80107ee3:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80107ee8:	c9                   	leave  
80107ee9:	c3                   	ret    
80107eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ef0 <sys_my_syscall>:

// Wrapper for my_syscall
int
sys_my_syscall(void)
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	83 ec 20             	sub    $0x20,%esp
	char *str;
	// Decode argument using argstr
	if (argstr(0, &str) < 0)
80107ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ef9:	50                   	push   %eax
80107efa:	6a 00                	push   $0x0
80107efc:	e8 bf d3 ff ff       	call   801052c0 <argstr>
80107f01:	83 c4 10             	add    $0x10,%esp
80107f04:	85 c0                	test   %eax,%eax
80107f06:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107f0b:	78 18                	js     80107f25 <sys_my_syscall+0x35>
	cprintf("%s\n", str);
80107f0d:	83 ec 08             	sub    $0x8,%esp
80107f10:	ff 75 f4             	pushl  -0xc(%ebp)
80107f13:	68 74 9c 10 80       	push   $0x80109c74
80107f18:	e8 43 87 ff ff       	call   80100660 <cprintf>
		return -1;
	return my_syscall(str);
80107f1d:	83 c4 10             	add    $0x10,%esp
80107f20:	ba cd ab cd ab       	mov    $0xabcdabcd,%edx
}
80107f25:	89 d0                	mov    %edx,%eax
80107f27:	c9                   	leave  
80107f28:	c3                   	ret    
80107f29:	66 90                	xchg   %ax,%ax
80107f2b:	66 90                	xchg   %ax,%ax
80107f2d:	66 90                	xchg   %ax,%ax
80107f2f:	90                   	nop

80107f30 <getlev>:
struct queue sq = {{0}, 0, 0, 0};


int
getlev(void)
{
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
80107f33:	83 ec 08             	sub    $0x8,%esp
  if(myproc()->in_mlfq)
80107f36:	e8 65 ba ff ff       	call   801039a0 <myproc>
80107f3b:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80107f41:	85 c0                	test   %eax,%eax
80107f43:	74 13                	je     80107f58 <getlev+0x28>
	return myproc()->lev;
80107f45:	e8 56 ba ff ff       	call   801039a0 <myproc>
80107f4a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax

  return -1;
}
80107f50:	c9                   	leave  
80107f51:	c3                   	ret    
80107f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80107f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f5d:	c9                   	leave  
80107f5e:	c3                   	ret    
80107f5f:	90                   	nop

80107f60 <priority_boost>:

void
priority_boost(void)
{
80107f60:	55                   	push   %ebp
80107f61:	b8 64 c4 10 80       	mov    $0x8010c464,%eax
80107f66:	89 e5                	mov    %esp,%ebp
80107f68:	90                   	nop
80107f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p;
  int i;

  for(i=1; i<=NPROC; i++) {
	p = mlfq.ps[i];
80107f70:	8b 10                	mov    (%eax),%edx
80107f72:	83 c0 04             	add    $0x4,%eax
  for(i=1; i<=NPROC; i++) {
80107f75:	3d 64 c5 10 80       	cmp    $0x8010c564,%eax
	p->lev = 0;
80107f7a:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80107f81:	00 00 00 
	p->used_time = 0;
80107f84:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
80107f8b:	00 00 00 
	p->used_all_time = 0;
80107f8e:	c7 82 bc 00 00 00 00 	movl   $0x0,0xbc(%edx)
80107f95:	00 00 00 
  for(i=1; i<=NPROC; i++) {
80107f98:	75 d6                	jne    80107f70 <priority_boost+0x10>
  }

  mlfq.used_time = 0;
80107f9a:	c7 05 68 c5 10 80 00 	movl   $0x0,0x8010c568
80107fa1:	00 00 00 
}
80107fa4:	5d                   	pop    %ebp
80107fa5:	c3                   	ret    
80107fa6:	8d 76 00             	lea    0x0(%esi),%esi
80107fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107fb0 <enqueue_to_mlfq>:

int
enqueue_to_mlfq(struct proc* p)
{
  if(mlfq.cnt >= NPROC)
80107fb0:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
{
80107fb6:	55                   	push   %ebp
80107fb7:	89 e5                	mov    %esp,%ebp
80107fb9:	57                   	push   %edi
80107fba:	56                   	push   %esi
  if(mlfq.cnt >= NPROC)
80107fbb:	83 f9 3f             	cmp    $0x3f,%ecx
{
80107fbe:	53                   	push   %ebx
80107fbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(mlfq.cnt >= NPROC)
80107fc2:	0f 8f 84 00 00 00    	jg     8010804c <enqueue_to_mlfq+0x9c>
	return -1;

  int idx;
  idx = ++mlfq.cnt;
80107fc8:	83 c1 01             	add    $0x1,%ecx

  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80107fcb:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
80107fce:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80107fd4:	74 58                	je     8010802e <enqueue_to_mlfq+0x7e>
80107fd6:	89 ca                	mov    %ecx,%edx
80107fd8:	c1 ea 1f             	shr    $0x1f,%edx
80107fdb:	01 ca                	add    %ecx,%edx
80107fdd:	d1 fa                	sar    %edx
80107fdf:	8b 34 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%esi
80107fe6:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80107fec:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
80107ff2:	7c 2e                	jl     80108022 <enqueue_to_mlfq+0x72>
80107ff4:	eb 52                	jmp    80108048 <enqueue_to_mlfq+0x98>
80107ff6:	8d 76 00             	lea    0x0(%esi),%esi
80107ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108000:	89 d0                	mov    %edx,%eax
80108002:	89 d1                	mov    %edx,%ecx
80108004:	c1 e8 1f             	shr    $0x1f,%eax
80108007:	01 d0                	add    %edx,%eax
80108009:	d1 f8                	sar    %eax
8010800b:	8b 34 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%esi
80108012:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
80108018:	39 bb 80 00 00 00    	cmp    %edi,0x80(%ebx)
8010801e:	7d 13                	jge    80108033 <enqueue_to_mlfq+0x83>
80108020:	89 c2                	mov    %eax,%edx
80108022:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108025:	89 34 8d 60 c4 10 80 	mov    %esi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
8010802c:	75 d2                	jne    80108000 <enqueue_to_mlfq+0x50>
8010802e:	ba 01 00 00 00       	mov    $0x1,%edx
	idx /= 2;
  }

  mlfq.ps[idx] = p;
80108033:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)

  return 1;
8010803a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010803f:	5b                   	pop    %ebx
80108040:	5e                   	pop    %esi
80108041:	5f                   	pop    %edi
80108042:	5d                   	pop    %ebp
80108043:	c3                   	ret    
80108044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108048:	89 ca                	mov    %ecx,%edx
8010804a:	eb e7                	jmp    80108033 <enqueue_to_mlfq+0x83>
	return -1;
8010804c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108051:	eb ec                	jmp    8010803f <enqueue_to_mlfq+0x8f>
80108053:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108060 <dequeue_from_mlfq>:

struct proc*
dequeue_from_mlfq(void)
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
80108066:	83 ec 14             	sub    $0x14,%esp
  if(mlfq.cnt <= 0)
80108069:	a1 6c c5 10 80       	mov    0x8010c56c,%eax
8010806e:	85 c0                	test   %eax,%eax
80108070:	0f 8e 31 01 00 00    	jle    801081a7 <dequeue_from_mlfq+0x147>
  struct proc *tmp;
  int parent;
  int child;

  p = mlfq.ps[1];
  mlfq.ps[1] = mlfq.ps[mlfq.cnt--];
80108076:	8d 78 ff             	lea    -0x1(%eax),%edi
  p = mlfq.ps[1];
80108079:	8b 35 64 c4 10 80    	mov    0x8010c464,%esi
  mlfq.ps[1] = mlfq.ps[mlfq.cnt--];
8010807f:	8b 04 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%eax
  tmp = mlfq.ps[1];

  parent = 1;
  child = parent*2;

  while(child <= mlfq.cnt) {
80108086:	83 ff 01             	cmp    $0x1,%edi
  mlfq.ps[1] = mlfq.ps[mlfq.cnt--];
80108089:	89 3d 6c c5 10 80    	mov    %edi,0x8010c56c
  p = mlfq.ps[1];
8010808f:	89 75 e0             	mov    %esi,-0x20(%ebp)
  mlfq.ps[1] = mlfq.ps[mlfq.cnt--];
80108092:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108095:	a3 64 c4 10 80       	mov    %eax,0x8010c464
  while(child <= mlfq.cnt) {
8010809a:	0f 8e 00 01 00 00    	jle    801081a0 <dequeue_from_mlfq+0x140>
  child = parent*2;
801080a0:	bb 02 00 00 00       	mov    $0x2,%ebx
  parent = 1;
801080a5:	be 01 00 00 00       	mov    $0x1,%esi
801080aa:	eb 2f                	jmp    801080db <dequeue_from_mlfq+0x7b>
801080ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080b0:	89 d8                	mov    %ebx,%eax
	if(child < mlfq.cnt) {
		if(mlfq.ps[child]->lev > mlfq.ps[child+1]->lev) child++;
		else if(mlfq.ps[child]->lev == mlfq.ps[child+1]->lev) {
801080b2:	0f 84 a0 00 00 00    	je     80108158 <dequeue_from_mlfq+0xf8>
801080b8:	90                   	nop
801080b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		}
	}
	if((child < mlfq.cnt) && (mlfq.ps[child]->lev > mlfq.ps[child+1]->lev))
		child++;

	if(tmp->lev < mlfq.ps[child]->lev)
801080c0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
801080c3:	39 8b 80 00 00 00    	cmp    %ecx,0x80(%ebx)
801080c9:	7c 75                	jl     80108140 <dequeue_from_mlfq+0xe0>
		break;

	mlfq.ps[parent] = mlfq.ps[child];
	parent = child;
	child *= 2;
801080cb:	8d 1c 00             	lea    (%eax,%eax,1),%ebx
	mlfq.ps[parent] = mlfq.ps[child];
801080ce:	89 14 b5 60 c4 10 80 	mov    %edx,-0x7fef3ba0(,%esi,4)
801080d5:	89 c6                	mov    %eax,%esi
  while(child <= mlfq.cnt) {
801080d7:	39 df                	cmp    %ebx,%edi
801080d9:	7c 65                	jl     80108140 <dequeue_from_mlfq+0xe0>
801080db:	8b 14 9d 60 c4 10 80 	mov    -0x7fef3ba0(,%ebx,4),%edx
	if(child < mlfq.cnt) {
801080e2:	39 df                	cmp    %ebx,%edi
801080e4:	89 d8                	mov    %ebx,%eax
801080e6:	8b 8a 80 00 00 00    	mov    0x80(%edx),%ecx
801080ec:	7e d2                	jle    801080c0 <dequeue_from_mlfq+0x60>
		if(mlfq.ps[child]->lev > mlfq.ps[child+1]->lev) child++;
801080ee:	8d 43 01             	lea    0x1(%ebx),%eax
801080f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080f4:	8b 04 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%eax
801080fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080fe:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80108104:	39 c1                	cmp    %eax,%ecx
80108106:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108109:	7e a5                	jle    801080b0 <dequeue_from_mlfq+0x50>
	if((child < mlfq.cnt) && (mlfq.ps[child]->lev > mlfq.ps[child+1]->lev))
8010810b:	3b 7d ec             	cmp    -0x14(%ebp),%edi
8010810e:	7e 15                	jle    80108125 <dequeue_from_mlfq+0xc5>
80108110:	8d 43 02             	lea    0x2(%ebx),%eax
80108113:	8b 14 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%edx
8010811a:	8b 8a 80 00 00 00    	mov    0x80(%edx),%ecx
80108120:	39 4d e8             	cmp    %ecx,-0x18(%ebp)
80108123:	7f 9b                	jg     801080c0 <dequeue_from_mlfq+0x60>
		if(mlfq.ps[child]->lev > mlfq.ps[child+1]->lev) child++;
80108125:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80108128:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010812b:	8b 45 ec             	mov    -0x14(%ebp),%eax
	if(tmp->lev < mlfq.ps[child]->lev)
8010812e:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80108131:	39 8b 80 00 00 00    	cmp    %ecx,0x80(%ebx)
80108137:	7d 92                	jge    801080cb <dequeue_from_mlfq+0x6b>
80108139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  mlfq.ps[parent] = tmp;
80108140:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108143:	89 04 b5 60 c4 10 80 	mov    %eax,-0x7fef3ba0(,%esi,4)

  return p;
}
8010814a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010814d:	83 c4 14             	add    $0x14,%esp
80108150:	5b                   	pop    %ebx
80108151:	5e                   	pop    %esi
80108152:	5f                   	pop    %edi
80108153:	5d                   	pop    %ebp
80108154:	c3                   	ret    
80108155:	8d 76 00             	lea    0x0(%esi),%esi
			if(mlfq.ps[child]->tcnt < mlfq.ps[child+1]->tcnt) child++;
80108158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010815b:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80108161:	39 82 a4 00 00 00    	cmp    %eax,0xa4(%edx)
80108167:	7c a2                	jl     8010810b <dequeue_from_mlfq+0xab>
			else if(mlfq.ps[child]->tcnt == mlfq.ps[child+1]->tcnt
80108169:	74 15                	je     80108180 <dequeue_from_mlfq+0x120>
8010816b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010816e:	89 5d ec             	mov    %ebx,-0x14(%ebp)
		if(mlfq.ps[child]->lev > mlfq.ps[child+1]->lev) child++;
80108171:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80108174:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108177:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010817a:	eb b2                	jmp    8010812e <dequeue_from_mlfq+0xce>
8010817c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			&& !mlfq.ps[child]->made_thd && mlfq.ps[child+1]->made_thd) child++;
80108180:	8b 8a a8 00 00 00    	mov    0xa8(%edx),%ecx
80108186:	85 c9                	test   %ecx,%ecx
80108188:	75 e1                	jne    8010816b <dequeue_from_mlfq+0x10b>
8010818a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010818d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80108193:	85 c0                	test   %eax,%eax
80108195:	74 d4                	je     8010816b <dequeue_from_mlfq+0x10b>
80108197:	e9 6f ff ff ff       	jmp    8010810b <dequeue_from_mlfq+0xab>
8010819c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  parent = 1;
801081a0:	be 01 00 00 00       	mov    $0x1,%esi
801081a5:	eb 99                	jmp    80108140 <dequeue_from_mlfq+0xe0>
	return 0;
801081a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801081ae:	eb 9a                	jmp    8010814a <dequeue_from_mlfq+0xea>

801081b0 <enqueue_to_sq>:

int
enqueue_to_sq(struct proc* p)
{
  if(sq.cnt >= NPROC)
801081b0:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
{
801081b6:	55                   	push   %ebp
801081b7:	89 e5                	mov    %esp,%ebp
801081b9:	56                   	push   %esi
801081ba:	53                   	push   %ebx
  if(sq.cnt >= NPROC)
801081bb:	83 f9 3f             	cmp    $0x3f,%ecx
{
801081be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(sq.cnt >= NPROC)
801081c1:	0f 8f 8d 00 00 00    	jg     80108254 <enqueue_to_sq+0xa4>
	return -1;

  int idx;
  idx = ++sq.cnt;
801081c7:	83 c1 01             	add    $0x1,%ecx

  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801081ca:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++sq.cnt;
801081cd:	89 0d 0c c8 10 80    	mov    %ecx,0x8010c80c
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801081d3:	74 5d                	je     80108232 <enqueue_to_sq+0x82>
801081d5:	89 ca                	mov    %ecx,%edx
801081d7:	c1 ea 1f             	shr    $0x1f,%edx
801081da:	01 ca                	add    %ecx,%edx
801081dc:	d1 fa                	sar    %edx
801081de:	8b 34 95 00 c7 10 80 	mov    -0x7fef3900(,%edx,4),%esi
801081e5:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
801081eb:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
801081f1:	df e9                	fucomip %st(1),%st
801081f3:	dd d8                	fstp   %st(0)
801081f5:	77 2f                	ja     80108226 <enqueue_to_sq+0x76>
801081f7:	eb 57                	jmp    80108250 <enqueue_to_sq+0xa0>
801081f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108200:	89 d0                	mov    %edx,%eax
80108202:	89 d1                	mov    %edx,%ecx
80108204:	c1 e8 1f             	shr    $0x1f,%eax
80108207:	01 d0                	add    %edx,%eax
80108209:	d1 f8                	sar    %eax
8010820b:	8b 34 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%esi
80108212:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108218:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
8010821e:	df e9                	fucomip %st(1),%st
80108220:	dd d8                	fstp   %st(0)
80108222:	76 13                	jbe    80108237 <enqueue_to_sq+0x87>
80108224:	89 c2                	mov    %eax,%edx
80108226:	83 fa 01             	cmp    $0x1,%edx
  	sq.ps[idx] = sq.ps[idx/2];
80108229:	89 34 8d 00 c7 10 80 	mov    %esi,-0x7fef3900(,%ecx,4)
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108230:	75 ce                	jne    80108200 <enqueue_to_sq+0x50>
80108232:	ba 01 00 00 00       	mov    $0x1,%edx
	idx /= 2;
  }

  sq.ps[idx] = p;
80108237:	89 1c 95 00 c7 10 80 	mov    %ebx,-0x7fef3900(,%edx,4)

  return 1;
8010823e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80108243:	5b                   	pop    %ebx
80108244:	5e                   	pop    %esi
80108245:	5d                   	pop    %ebp
80108246:	c3                   	ret    
80108247:	89 f6                	mov    %esi,%esi
80108249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108250:	89 ca                	mov    %ecx,%edx
80108252:	eb e3                	jmp    80108237 <enqueue_to_sq+0x87>
	return -1;
80108254:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108259:	eb e8                	jmp    80108243 <enqueue_to_sq+0x93>
8010825b:	90                   	nop
8010825c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108260 <dequeue_from_sq>:

struct proc*
dequeue_from_sq(void)
{
80108260:	55                   	push   %ebp
80108261:	89 e5                	mov    %esp,%ebp
80108263:	57                   	push   %edi
80108264:	56                   	push   %esi
80108265:	53                   	push   %ebx
80108266:	83 ec 0c             	sub    $0xc,%esp
  if(sq.cnt <= 0)
80108269:	a1 0c c8 10 80       	mov    0x8010c80c,%eax
8010826e:	85 c0                	test   %eax,%eax
80108270:	0f 8e 96 00 00 00    	jle    8010830c <dequeue_from_sq+0xac>

  struct proc *p;
  int parent;
  int child;

  p = sq.ps[1];
80108276:	8b 35 04 c7 10 80    	mov    0x8010c704,%esi
  sq.ps[1] = sq.ps[sq.cnt--];
8010827c:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010827f:	8b 04 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%eax
  parent = 1;
80108286:	ba 01 00 00 00       	mov    $0x1,%edx
  sq.ps[1] = sq.ps[sq.cnt--];
8010828b:	89 0d 0c c8 10 80    	mov    %ecx,0x8010c80c
80108291:	a3 04 c7 10 80       	mov    %eax,0x8010c704
  parent = 1;
80108296:	89 75 ec             	mov    %esi,-0x14(%ebp)
80108299:	eb 35                	jmp    801082d0 <dequeue_from_sq+0x70>
8010829b:	90                   	nop
8010829c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	child = parent*2;

	if(child+1 <= sq.cnt && sq.ps[child]->pass > sq.ps[child+1]->pass)
		child++;

	if(child > sq.cnt || sq.ps[child]->pass > sq.ps[parent]->pass)
801082a0:	8b 34 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%esi
801082a7:	8b 1c 95 00 c7 10 80 	mov    -0x7fef3900(,%edx,4),%ebx
801082ae:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
801082b4:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
801082ba:	df e9                	fucomip %st(1),%st
801082bc:	dd d8                	fstp   %st(0)
801082be:	77 3f                	ja     801082ff <dequeue_from_sq+0x9f>
		break;

	struct proc *tmp;
	tmp = sq.ps[parent];
	sq.ps[parent] = sq.ps[child];
801082c0:	89 34 95 00 c7 10 80 	mov    %esi,-0x7fef3900(,%edx,4)
	sq.ps[child] = tmp;
801082c7:	89 1c 85 00 c7 10 80 	mov    %ebx,-0x7fef3900(,%eax,4)
  while (1) {
801082ce:	89 c2                	mov    %eax,%edx
	child = parent*2;
801082d0:	8d 04 12             	lea    (%edx,%edx,1),%eax
	if(child+1 <= sq.cnt && sq.ps[child]->pass > sq.ps[child+1]->pass)
801082d3:	39 c1                	cmp    %eax,%ecx
801082d5:	7e 24                	jle    801082fb <dequeue_from_sq+0x9b>
801082d7:	8d 58 01             	lea    0x1(%eax),%ebx
801082da:	8b 3c 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%edi
801082e1:	8b 34 9d 00 c7 10 80 	mov    -0x7fef3900(,%ebx,4),%esi
801082e8:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
801082ee:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
		child++;
801082f4:	df e9                	fucomip %st(1),%st
801082f6:	dd d8                	fstp   %st(0)
801082f8:	0f 47 c3             	cmova  %ebx,%eax
	if(child > sq.cnt || sq.ps[child]->pass > sq.ps[parent]->pass)
801082fb:	39 c1                	cmp    %eax,%ecx
801082fd:	7d a1                	jge    801082a0 <dequeue_from_sq+0x40>
801082ff:	8b 75 ec             	mov    -0x14(%ebp),%esi
	parent = child;
  }

  return p;
}
80108302:	83 c4 0c             	add    $0xc,%esp
80108305:	89 f0                	mov    %esi,%eax
80108307:	5b                   	pop    %ebx
80108308:	5e                   	pop    %esi
80108309:	5f                   	pop    %edi
8010830a:	5d                   	pop    %ebp
8010830b:	c3                   	ret    
	return 0;
8010830c:	31 f6                	xor    %esi,%esi
8010830e:	eb f2                	jmp    80108302 <dequeue_from_sq+0xa2>

80108310 <get_min_pass>:

double
get_min_pass(void)
{
  if(mlfq.cnt <= 0 && sq.cnt <= 0)
80108310:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80108316:	8b 15 0c c8 10 80    	mov    0x8010c80c,%edx
8010831c:	85 c9                	test   %ecx,%ecx
8010831e:	0f 8e ac 00 00 00    	jle    801083d0 <get_min_pass+0xc0>
  min_pass = 987654321.0;

  struct proc *p;
  int i;

  for(i=1; i<=sq.cnt; i++) {
80108324:	85 d2                	test   %edx,%edx
80108326:	0f 8e c4 00 00 00    	jle    801083f0 <get_min_pass+0xe0>
{
8010832c:	55                   	push   %ebp
8010832d:	dd 05 78 9c 10 80    	fldl   0x80109c78
80108333:	b8 00 c7 10 80       	mov    $0x8010c700,%eax
80108338:	89 e5                	mov    %esp,%ebp
8010833a:	53                   	push   %ebx
8010833b:	8d 1c 95 00 c7 10 80 	lea    -0x7fef3900(,%edx,4),%ebx
80108342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	p = sq.ps[i];	
80108348:	8b 50 04             	mov    0x4(%eax),%edx

	if(!p || p->in_mlfq == 1)
8010834b:	85 d2                	test   %edx,%edx
8010834d:	74 17                	je     80108366 <get_min_pass+0x56>
8010834f:	83 ba 88 00 00 00 01 	cmpl   $0x1,0x88(%edx)
80108356:	74 0e                	je     80108366 <get_min_pass+0x56>
		continue;
	
	if(min_pass > p->pass) {
80108358:	dd 82 8c 00 00 00    	fldl   0x8c(%edx)
8010835e:	d9 c9                	fxch   %st(1)
		min_pass = p->pass;
80108360:	db e9                	fucomi %st(1),%st
80108362:	db d1                	fcmovnbe %st(1),%st
80108364:	dd d9                	fstp   %st(1)
80108366:	83 c0 04             	add    $0x4,%eax
  for(i=1; i<=sq.cnt; i++) {
80108369:	39 c3                	cmp    %eax,%ebx
8010836b:	75 db                	jne    80108348 <get_min_pass+0x38>
	}
  }

  for(i=1; i<=mlfq.cnt; i++) {
8010836d:	85 c9                	test   %ecx,%ecx
8010836f:	7e 39                	jle    801083aa <get_min_pass+0x9a>
  for(i=1; i<=sq.cnt; i++) {
80108371:	b8 01 00 00 00       	mov    $0x1,%eax
80108376:	8d 76 00             	lea    0x0(%esi),%esi
80108379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	p = mlfq.ps[i];
80108380:	8b 14 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%edx

	if(!p || p->in_mlfq == 0)
80108387:	85 d2                	test   %edx,%edx
80108389:	74 18                	je     801083a3 <get_min_pass+0x93>
8010838b:	8b 9a 88 00 00 00    	mov    0x88(%edx),%ebx
80108391:	85 db                	test   %ebx,%ebx
80108393:	74 0e                	je     801083a3 <get_min_pass+0x93>
		continue;
	
	if(min_pass > p->pass) {
80108395:	dd 82 8c 00 00 00    	fldl   0x8c(%edx)
8010839b:	d9 c9                	fxch   %st(1)
		min_pass = p->pass;
8010839d:	db e9                	fucomi %st(1),%st
8010839f:	db d1                	fcmovnbe %st(1),%st
801083a1:	dd d9                	fstp   %st(1)
  for(i=1; i<=mlfq.cnt; i++) {
801083a3:	83 c0 01             	add    $0x1,%eax
801083a6:	39 c1                	cmp    %eax,%ecx
801083a8:	7d d6                	jge    80108380 <get_min_pass+0x70>
	}
  }

  if(min_pass == 987654321.0)
801083aa:	dd 05 78 9c 10 80    	fldl   0x80109c78
801083b0:	d9 c9                	fxch   %st(1)
801083b2:	db e9                	fucomi %st(1),%st
801083b4:	dd d9                	fstp   %st(1)
801083b6:	7a 02                	jp     801083ba <get_min_pass+0xaa>
801083b8:	74 06                	je     801083c0 <get_min_pass+0xb0>
	return 0;

  return min_pass;
}
801083ba:	5b                   	pop    %ebx
801083bb:	5d                   	pop    %ebp
801083bc:	c3                   	ret    
801083bd:	8d 76 00             	lea    0x0(%esi),%esi
801083c0:	dd d8                	fstp   %st(0)
	return 0;
801083c2:	d9 ee                	fldz   
}
801083c4:	5b                   	pop    %ebx
801083c5:	5d                   	pop    %ebp
801083c6:	c3                   	ret    
801083c7:	89 f6                	mov    %esi,%esi
801083c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(mlfq.cnt <= 0 && sq.cnt <= 0)
801083d0:	85 d2                	test   %edx,%edx
801083d2:	0f 8f 54 ff ff ff    	jg     8010832c <get_min_pass+0x1c>
801083d8:	eb 08                	jmp    801083e2 <get_min_pass+0xd2>
801083da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801083e0:	dd d8                	fstp   %st(0)
	return 0;
801083e2:	d9 ee                	fldz   
}
801083e4:	f3 c3                	repz ret 
801083e6:	8d 76 00             	lea    0x0(%esi),%esi
801083e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i=1; i<=sq.cnt; i++) {
801083f0:	dd 05 78 9c 10 80    	fldl   0x80109c78
801083f6:	b8 01 00 00 00       	mov    $0x1,%eax
801083fb:	90                   	nop
801083fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p = mlfq.ps[i];
80108400:	8b 14 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%edx
	if(!p || p->in_mlfq == 0)
80108407:	85 d2                	test   %edx,%edx
80108409:	74 17                	je     80108422 <get_min_pass+0x112>
8010840b:	83 ba 88 00 00 00 00 	cmpl   $0x0,0x88(%edx)
80108412:	74 0e                	je     80108422 <get_min_pass+0x112>
	if(min_pass > p->pass) {
80108414:	dd 82 8c 00 00 00    	fldl   0x8c(%edx)
8010841a:	d9 c9                	fxch   %st(1)
		min_pass = p->pass;
8010841c:	db e9                	fucomi %st(1),%st
8010841e:	db d1                	fcmovnbe %st(1),%st
80108420:	dd d9                	fstp   %st(1)
  for(i=1; i<=mlfq.cnt; i++) {
80108422:	83 c0 01             	add    $0x1,%eax
80108425:	39 c1                	cmp    %eax,%ecx
80108427:	7d d7                	jge    80108400 <get_min_pass+0xf0>
  if(min_pass == 987654321.0)
80108429:	dd 05 78 9c 10 80    	fldl   0x80109c78
8010842f:	d9 c9                	fxch   %st(1)
80108431:	db e9                	fucomi %st(1),%st
80108433:	dd d9                	fstp   %st(1)
80108435:	7a ad                	jp     801083e4 <get_min_pass+0xd4>
80108437:	74 a7                	je     801083e0 <get_min_pass+0xd0>
}
80108439:	f3 c3                	repz ret 
8010843b:	90                   	nop
8010843c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108440 <set_cpu_share>:

int
set_cpu_share(int share)
{
  if(sq.cnt >= NPROC || share <= 0)
80108440:	83 3d 0c c8 10 80 3f 	cmpl   $0x3f,0x8010c80c
80108447:	0f 8f 94 03 00 00    	jg     801087e1 <set_cpu_share+0x3a1>
{
8010844d:	55                   	push   %ebp
8010844e:	89 e5                	mov    %esp,%ebp
80108450:	57                   	push   %edi
80108451:	56                   	push   %esi
80108452:	53                   	push   %ebx
80108453:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  if(sq.cnt >= NPROC || share <= 0)
80108459:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010845c:	85 db                	test   %ebx,%ebx
8010845e:	0f 8e d6 02 00 00    	jle    8010873a <set_cpu_share+0x2fa>
	return -1;

  acquire(&ptable.lock);
80108464:	83 ec 0c             	sub    $0xc,%esp
  int mlfq_sum;
  int sq_sum;

  struct proc* ps[NPROC];
  struct proc* np;
  int ps_idx = 0, push_idx = 0;
80108467:	31 f6                	xor    %esi,%esi
  acquire(&ptable.lock);
80108469:	68 80 6d 11 80       	push   $0x80116d80
8010846e:	e8 6d c9 ff ff       	call   80104de0 <acquire>
  
  p = myproc();
80108473:	e8 28 b5 ff ff       	call   801039a0 <myproc>
  while(mlfq.cnt > 0) {
80108478:	83 c4 10             	add    $0x10,%esp
  p = myproc();
8010847b:	89 c3                	mov    %eax,%ebx
  while(mlfq.cnt > 0) {
8010847d:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80108483:	85 c9                	test   %ecx,%ecx
80108485:	7e 21                	jle    801084a8 <set_cpu_share+0x68>
	np = dequeue_from_mlfq();
80108487:	e8 d4 fb ff ff       	call   80108060 <dequeue_from_mlfq>
	if(!np) continue;
8010848c:	85 c0                	test   %eax,%eax
8010848e:	74 ed                	je     8010847d <set_cpu_share+0x3d>
	if(np == p) break;
80108490:	39 c3                	cmp    %eax,%ebx
80108492:	74 14                	je     801084a8 <set_cpu_share+0x68>
  while(mlfq.cnt > 0) {
80108494:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx

	ps[ps_idx++] = np;
8010849a:	83 c6 01             	add    $0x1,%esi
8010849d:	89 84 b5 e4 fe ff ff 	mov    %eax,-0x11c(%ebp,%esi,4)
  while(mlfq.cnt > 0) {
801084a4:	85 c9                	test   %ecx,%ecx
801084a6:	7f df                	jg     80108487 <set_cpu_share+0x47>
  }

  while(push_idx < ps_idx) {
801084a8:	85 f6                	test   %esi,%esi
801084aa:	0f 84 d9 00 00 00    	je     80108589 <set_cpu_share+0x149>
801084b0:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
801084b6:	89 9d dc fe ff ff    	mov    %ebx,-0x124(%ebp)
801084bc:	8d 04 b7             	lea    (%edi,%esi,4),%eax
801084bf:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
801084c5:	eb 18                	jmp    801084df <set_cpu_share+0x9f>
801084c7:	89 f6                	mov    %esi,%esi
801084c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801084d0:	83 c7 04             	add    $0x4,%edi
801084d3:	39 bd e4 fe ff ff    	cmp    %edi,-0x11c(%ebp)
801084d9:	0f 84 a4 00 00 00    	je     80108583 <set_cpu_share+0x143>
	np = ps[push_idx++];
801084df:	8b 37                	mov    (%edi),%esi
	if(!np) continue;
801084e1:	85 f6                	test   %esi,%esi
801084e3:	74 eb                	je     801084d0 <set_cpu_share+0x90>
  if(mlfq.cnt >= NPROC)
801084e5:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
801084eb:	83 f9 3f             	cmp    $0x3f,%ecx
801084ee:	7f e0                	jg     801084d0 <set_cpu_share+0x90>
  idx = ++mlfq.cnt;
801084f0:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801084f3:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
801084f6:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801084fc:	74 6a                	je     80108568 <set_cpu_share+0x128>
801084fe:	89 ca                	mov    %ecx,%edx
80108500:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80108506:	c1 ea 1f             	shr    $0x1f,%edx
80108509:	01 ca                	add    %ecx,%edx
8010850b:	d1 fa                	sar    %edx
8010850d:	8b 1c 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%ebx
80108514:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
8010851a:	0f 8e b3 02 00 00    	jle    801087d3 <set_cpu_share+0x393>
80108520:	89 bd e0 fe ff ff    	mov    %edi,-0x120(%ebp)
80108526:	eb 2e                	jmp    80108556 <set_cpu_share+0x116>
80108528:	90                   	nop
80108529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108530:	89 d0                	mov    %edx,%eax
80108532:	89 d1                	mov    %edx,%ecx
80108534:	c1 e8 1f             	shr    $0x1f,%eax
80108537:	01 d0                	add    %edx,%eax
80108539:	d1 f8                	sar    %eax
8010853b:	8b 1c 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%ebx
80108542:	8b bb 80 00 00 00    	mov    0x80(%ebx),%edi
80108548:	39 be 80 00 00 00    	cmp    %edi,0x80(%esi)
8010854e:	0f 8d fc 01 00 00    	jge    80108750 <set_cpu_share+0x310>
80108554:	89 c2                	mov    %eax,%edx
80108556:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108559:	89 1c 8d 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108560:	75 ce                	jne    80108530 <set_cpu_share+0xf0>
80108562:	8b bd e0 fe ff ff    	mov    -0x120(%ebp),%edi
80108568:	ba 01 00 00 00       	mov    $0x1,%edx
8010856d:	83 c7 04             	add    $0x4,%edi
  while(push_idx < ps_idx) {
80108570:	39 bd e4 fe ff ff    	cmp    %edi,-0x11c(%ebp)
  mlfq.ps[idx] = p;
80108576:	89 34 95 60 c4 10 80 	mov    %esi,-0x7fef3ba0(,%edx,4)
  while(push_idx < ps_idx) {
8010857d:	0f 85 5c ff ff ff    	jne    801084df <set_cpu_share+0x9f>
80108583:	8b 9d dc fe ff ff    	mov    -0x124(%ebp),%ebx

	enqueue_to_mlfq(np);
  }

  cur_t = TOTAL_TICKETS * share / 100;
80108589:	6b 7d 08 64          	imul   $0x64,0x8(%ebp),%edi

  mlfq_sum = mlfq.tickets - cur_t;
8010858d:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80108592:	29 f8                	sub    %edi,%eax
80108594:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  sq_sum = sq.tickets + cur_t;

  if((mlfq_sum * 100.0 / TOTAL_TICKETS < 20.0) || (sq_sum * 100.0 / TOTAL_TICKETS > 80.0)) {
8010859a:	db 85 e4 fe ff ff    	fildl  -0x11c(%ebp)
801085a0:	d9 05 88 9c 10 80    	flds   0x80109c88
801085a6:	dc c9                	fmul   %st,%st(1)
801085a8:	d9 05 8c 9c 10 80    	flds   0x80109c8c
801085ae:	dc fa                	fdivr  %st,%st(2)
801085b0:	d9 05 90 9c 10 80    	flds   0x80109c90
801085b6:	df eb                	fucomip %st(3),%st
801085b8:	dd da                	fstp   %st(2)
801085ba:	0f 87 f8 00 00 00    	ja     801086b8 <set_cpu_share+0x278>
  sq_sum = sq.tickets + cur_t;
801085c0:	8b 35 04 c8 10 80    	mov    0x8010c804,%esi
801085c6:	01 fe                	add    %edi,%esi
  if((mlfq_sum * 100.0 / TOTAL_TICKETS < 20.0) || (sq_sum * 100.0 / TOTAL_TICKETS > 80.0)) {
801085c8:	89 b5 e0 fe ff ff    	mov    %esi,-0x120(%ebp)
801085ce:	db 85 e0 fe ff ff    	fildl  -0x120(%ebp)
801085d4:	de c9                	fmulp  %st,%st(1)
801085d6:	de f1                	fdivp  %st,%st(1)
801085d8:	d9 05 94 9c 10 80    	flds   0x80109c94
801085de:	d9 c9                	fxch   %st(1)
801085e0:	df e9                	fucomip %st(1),%st
801085e2:	dd d8                	fstp   %st(0)
801085e4:	0f 87 d2 00 00 00    	ja     801086bc <set_cpu_share+0x27c>
	enqueue_to_mlfq(p);
	return -1;
  }

  // Initialize process
  p->tickets = cur_t;
801085ea:	89 7b 7c             	mov    %edi,0x7c(%ebx)
  p->lev = 3;
801085ed:	c7 83 80 00 00 00 03 	movl   $0x3,0x80(%ebx)
801085f4:	00 00 00 
  p->used_time = 0;
801085f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801085fe:	00 00 00 
  p->in_mlfq = 0;
80108601:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80108608:	00 00 00 
  p->pass = get_min_pass();
8010860b:	e8 00 fd ff ff       	call   80108310 <get_min_pass>
  p->stride = TOTAL_TICKETS / cur_t;
80108610:	b8 10 27 00 00       	mov    $0x2710,%eax
  p->pass = get_min_pass();
80108615:	dd 9b 8c 00 00 00    	fstpl  0x8c(%ebx)
  p->stride = TOTAL_TICKETS / cur_t;
8010861b:	99                   	cltd   
8010861c:	f7 ff                	idiv   %edi
8010861e:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
80108624:	db 85 e0 fe ff ff    	fildl  -0x120(%ebp)
8010862a:	dd 9b 94 00 00 00    	fstpl  0x94(%ebx)
  if(sq.cnt >= NPROC)
80108630:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
80108636:	83 f9 3f             	cmp    $0x3f,%ecx
80108639:	0f 8e 1c 01 00 00    	jle    8010875b <set_cpu_share+0x31b>
  enqueue_to_sq(p);

  mlfq.tickets = mlfq_sum;
8010863f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  sq.tickets = sq_sum;

  mlfq.cnt--;
80108645:	83 2d 6c c5 10 80 01 	subl   $0x1,0x8010c56c
  sq.tickets = sq_sum;
8010864c:	89 35 04 c8 10 80    	mov    %esi,0x8010c804
  mlfq.tickets = mlfq_sum;
80108652:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Initialize threads of current process
  struct proc *thd;
  for(thd=ptable.proc; thd<&ptable.proc[NPROC]; ++thd) {
80108657:	b8 b4 6d 11 80       	mov    $0x80116db4,%eax
8010865c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(!thd || thd->is_thread == 0 || thd->pid != p->pid)
80108660:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80108666:	85 d2                	test   %edx,%edx
80108668:	74 22                	je     8010868c <set_cpu_share+0x24c>
8010866a:	8b 7b 10             	mov    0x10(%ebx),%edi
8010866d:	39 78 10             	cmp    %edi,0x10(%eax)
80108670:	75 1a                	jne    8010868c <set_cpu_share+0x24c>
		continue;

	thd->lev = 3;
80108672:	c7 80 80 00 00 00 03 	movl   $0x3,0x80(%eax)
80108679:	00 00 00 
	thd->in_mlfq = 0;
8010867c:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80108683:	00 00 00 
	thd->tickets = p->tickets;
80108686:	8b 53 7c             	mov    0x7c(%ebx),%edx
80108689:	89 50 7c             	mov    %edx,0x7c(%eax)
  for(thd=ptable.proc; thd<&ptable.proc[NPROC]; ++thd) {
8010868c:	05 c4 00 00 00       	add    $0xc4,%eax
80108691:	3d b4 9e 11 80       	cmp    $0x80119eb4,%eax
80108696:	72 c8                	jb     80108660 <set_cpu_share+0x220>
  }

  release(&ptable.lock);
80108698:	83 ec 0c             	sub    $0xc,%esp
8010869b:	68 80 6d 11 80       	push   $0x80116d80
801086a0:	e8 fb c7 ff ff       	call   80104ea0 <release>

  return 0;
801086a5:	83 c4 10             	add    $0x10,%esp
}
801086a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801086ab:	31 c0                	xor    %eax,%eax
}
801086ad:	5b                   	pop    %ebx
801086ae:	5e                   	pop    %esi
801086af:	5f                   	pop    %edi
801086b0:	5d                   	pop    %ebp
801086b1:	c3                   	ret    
801086b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801086b8:	dd d8                	fstp   %st(0)
801086ba:	dd d8                	fstp   %st(0)
  if(mlfq.cnt >= NPROC)
801086bc:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
801086c2:	83 f9 3f             	cmp    $0x3f,%ecx
801086c5:	7f 73                	jg     8010873a <set_cpu_share+0x2fa>
  idx = ++mlfq.cnt;
801086c7:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801086ca:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
801086cd:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801086d3:	74 59                	je     8010872e <set_cpu_share+0x2ee>
801086d5:	89 ca                	mov    %ecx,%edx
801086d7:	c1 ea 1f             	shr    $0x1f,%edx
801086da:	01 ca                	add    %ecx,%edx
801086dc:	d1 fa                	sar    %edx
801086de:	8b 34 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%esi
801086e5:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
801086eb:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
801086f1:	7c 2f                	jl     80108722 <set_cpu_share+0x2e2>
801086f3:	e9 e2 00 00 00       	jmp    801087da <set_cpu_share+0x39a>
801086f8:	90                   	nop
801086f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108700:	89 d0                	mov    %edx,%eax
80108702:	89 d1                	mov    %edx,%ecx
80108704:	c1 e8 1f             	shr    $0x1f,%eax
80108707:	01 d0                	add    %edx,%eax
80108709:	d1 f8                	sar    %eax
8010870b:	8b 34 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%esi
80108712:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
80108718:	39 bb 80 00 00 00    	cmp    %edi,0x80(%ebx)
8010871e:	7d 13                	jge    80108733 <set_cpu_share+0x2f3>
80108720:	89 c2                	mov    %eax,%edx
80108722:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108725:	89 34 8d 60 c4 10 80 	mov    %esi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
8010872c:	75 d2                	jne    80108700 <set_cpu_share+0x2c0>
8010872e:	ba 01 00 00 00       	mov    $0x1,%edx
  mlfq.ps[idx] = p;
80108733:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)
}
8010873a:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
8010873d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108742:	5b                   	pop    %ebx
80108743:	5e                   	pop    %esi
80108744:	5f                   	pop    %edi
80108745:	5d                   	pop    %ebp
80108746:	c3                   	ret    
80108747:	89 f6                	mov    %esi,%esi
80108749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108750:	8b bd e0 fe ff ff    	mov    -0x120(%ebp),%edi
80108756:	e9 12 fe ff ff       	jmp    8010856d <set_cpu_share+0x12d>
  idx = ++sq.cnt;
8010875b:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
8010875e:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++sq.cnt;
80108761:	89 0d 0c c8 10 80    	mov    %ecx,0x8010c80c
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108767:	74 59                	je     801087c2 <set_cpu_share+0x382>
80108769:	89 ca                	mov    %ecx,%edx
8010876b:	c1 ea 1f             	shr    $0x1f,%edx
8010876e:	01 ca                	add    %ecx,%edx
80108770:	d1 fa                	sar    %edx
80108772:	8b 3c 95 00 c7 10 80 	mov    -0x7fef3900(,%edx,4),%edi
80108779:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
8010877f:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
80108785:	df e9                	fucomip %st(1),%st
80108787:	dd d8                	fstp   %st(0)
80108789:	77 2b                	ja     801087b6 <set_cpu_share+0x376>
8010878b:	eb 5a                	jmp    801087e7 <set_cpu_share+0x3a7>
8010878d:	8d 76 00             	lea    0x0(%esi),%esi
80108790:	89 d0                	mov    %edx,%eax
80108792:	89 d1                	mov    %edx,%ecx
80108794:	c1 e8 1f             	shr    $0x1f,%eax
80108797:	01 d0                	add    %edx,%eax
80108799:	d1 f8                	sar    %eax
8010879b:	8b 3c 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%edi
801087a2:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
801087a8:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
801087ae:	df e9                	fucomip %st(1),%st
801087b0:	dd d8                	fstp   %st(0)
801087b2:	76 13                	jbe    801087c7 <set_cpu_share+0x387>
801087b4:	89 c2                	mov    %eax,%edx
801087b6:	83 fa 01             	cmp    $0x1,%edx
  	sq.ps[idx] = sq.ps[idx/2];
801087b9:	89 3c 8d 00 c7 10 80 	mov    %edi,-0x7fef3900(,%ecx,4)
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801087c0:	75 ce                	jne    80108790 <set_cpu_share+0x350>
801087c2:	ba 01 00 00 00       	mov    $0x1,%edx
  sq.ps[idx] = p;
801087c7:	89 1c 95 00 c7 10 80 	mov    %ebx,-0x7fef3900(,%edx,4)
801087ce:	e9 6c fe ff ff       	jmp    8010863f <set_cpu_share+0x1ff>
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801087d3:	89 ca                	mov    %ecx,%edx
801087d5:	e9 93 fd ff ff       	jmp    8010856d <set_cpu_share+0x12d>
801087da:	89 ca                	mov    %ecx,%edx
801087dc:	e9 52 ff ff ff       	jmp    80108733 <set_cpu_share+0x2f3>
	return -1;
801087e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801087e6:	c3                   	ret    
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801087e7:	89 ca                	mov    %ecx,%edx
801087e9:	eb dc                	jmp    801087c7 <set_cpu_share+0x387>
801087eb:	90                   	nop
801087ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801087f0 <update_pass>:

void
update_pass(struct proc* p)
{
801087f0:	55                   	push   %ebp
801087f1:	89 e5                	mov    %esp,%ebp
801087f3:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->pass < 0x2fffffff)
801087f6:	dd 80 8c 00 00 00    	fldl   0x8c(%eax)
801087fc:	dd 05 80 9c 10 80    	fldl   0x80109c80
80108802:	df e9                	fucomip %st(1),%st
80108804:	dd d8                	fstp   %st(0)
80108806:	77 1b                	ja     80108823 <update_pass+0x33>
80108808:	90                   	nop
80108809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return;

  struct proc* np;
  for(np=ptable.proc; np<&ptable.proc[NPROC]; p++) {
	if(!p)
80108810:	85 c0                	test   %eax,%eax
80108812:	74 08                	je     8010881c <update_pass+0x2c>
		continue;
	p->pass = 0;
80108814:	d9 ee                	fldz   
80108816:	dd 98 8c 00 00 00    	fstpl  0x8c(%eax)
  for(np=ptable.proc; np<&ptable.proc[NPROC]; p++) {
8010881c:	05 c4 00 00 00       	add    $0xc4,%eax
80108821:	eb ed                	jmp    80108810 <update_pass+0x20>
  }
}
80108823:	5d                   	pop    %ebp
80108824:	c3                   	ret    
80108825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108830 <select_and_run>:

struct proc*
select_and_run(struct cpu *c)
{
80108830:	55                   	push   %ebp
80108831:	89 e5                	mov    %esp,%ebp
80108833:	57                   	push   %edi
80108834:	56                   	push   %esi
80108835:	53                   	push   %ebx
80108836:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *sp;
  struct proc *sleep_p = 0;

  int flag = 1; // whether it is run

  mp = dequeue_from_mlfq();
80108839:	e8 22 f8 ff ff       	call   80108060 <dequeue_from_mlfq>
8010883e:	89 c3                	mov    %eax,%ebx
  sp = dequeue_from_sq();
80108840:	e8 1b fa ff ff       	call   80108260 <dequeue_from_sq>

//  if(mp && !(mp->state == RUNNABLE || mp->state == SLEEPING)) mp = 0;
//  if(sp && !(sp->state == RUNNABLE || sp->state == SLEEPING)) sp = 0;

  if(mp) {
80108845:	85 db                	test   %ebx,%ebx
  sp = dequeue_from_sq();
80108847:	89 c6                	mov    %eax,%esi
  if(mp) {
80108849:	0f 84 41 01 00 00    	je     80108990 <select_and_run+0x160>

	if(mp->in_mlfq) {
8010884f:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
80108855:	85 c9                	test   %ecx,%ecx
80108857:	0f 85 eb 00 00 00    	jne    80108948 <select_and_run+0x118>
		mp->stride = TOTAL_TICKETS / mlfq.tickets;

	// handle exception (Stride queue's process dequeued from MLFQ)
	} else {
		if(mp == sp)
8010885d:	39 c3                	cmp    %eax,%ebx
8010885f:	0f 84 53 05 00 00    	je     80108db8 <select_and_run+0x588>
			mp = 0;
	}
  }

  if((mp && mp->state == RUNNABLE) && (sp && sp->state == RUNNABLE)) {
80108865:	8b 43 0c             	mov    0xc(%ebx),%eax
80108868:	85 f6                	test   %esi,%esi
8010886a:	0f 95 c1             	setne  %cl
8010886d:	83 f8 03             	cmp    $0x3,%eax
80108870:	0f 94 c2             	sete   %dl
80108873:	20 d1                	and    %dl,%cl
80108875:	88 4d e4             	mov    %cl,-0x1c(%ebp)
80108878:	0f 85 d2 03 00 00    	jne    80108c50 <select_and_run+0x420>
	}

	enqueue_to_mlfq(mp);
	enqueue_to_sq(sp);

  } else if((mp && mp->state == RUNNABLE) && (!sp || sp->state != RUNNABLE)) {
8010887e:	83 f8 03             	cmp    $0x3,%eax
80108881:	0f 84 c1 02 00 00    	je     80108b48 <select_and_run+0x318>
	if(sp && sp->state == SLEEPING) {
		sp->pass = sq.ps[sq.cnt]->pass;
		enqueue_to_sq(sp);
	}

  } else if((!mp || mp->state != RUNNABLE) && (sp && sp->state == RUNNABLE)) {
80108887:	85 f6                	test   %esi,%esi
80108889:	74 0a                	je     80108895 <select_and_run+0x65>
8010888b:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
8010888f:	0f 84 4b 05 00 00    	je     80108de0 <select_and_run+0x5b0>

  } else {

	flag = 0;

	if(mp && mp->state == SLEEPING) {
80108895:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80108899:	0f 85 d2 00 00 00    	jne    80108971 <select_and_run+0x141>
		mp->lev = 2;
8010889f:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
801088a6:	00 00 00 
		mp->used_time = 0;
801088a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801088b0:	00 00 00 
  if(mlfq.cnt >= NPROC)
801088b3:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
801088b9:	83 f9 3f             	cmp    $0x3f,%ecx
801088bc:	0f 8f b1 00 00 00    	jg     80108973 <select_and_run+0x143>
  idx = ++mlfq.cnt;
801088c2:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801088c5:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
801088c8:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801088ce:	74 65                	je     80108935 <select_and_run+0x105>
801088d0:	89 ca                	mov    %ecx,%edx
801088d2:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801088d8:	c1 ea 1f             	shr    $0x1f,%edx
801088db:	01 ca                	add    %ecx,%edx
801088dd:	d1 fa                	sar    %edx
801088df:	8b 3c 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%edi
801088e6:	39 87 80 00 00 00    	cmp    %eax,0x80(%edi)
801088ec:	0f 8e 9d 07 00 00    	jle    8010908f <select_and_run+0x85f>
801088f2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801088f5:	eb 2f                	jmp    80108926 <select_and_run+0xf6>
801088f7:	89 f6                	mov    %esi,%esi
801088f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108900:	89 d0                	mov    %edx,%eax
80108902:	89 d1                	mov    %edx,%ecx
80108904:	c1 e8 1f             	shr    $0x1f,%eax
80108907:	01 d0                	add    %edx,%eax
80108909:	d1 f8                	sar    %eax
8010890b:	8b 3c 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%edi
80108912:	8b b7 80 00 00 00    	mov    0x80(%edi),%esi
80108918:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
8010891e:	0f 8d f4 06 00 00    	jge    80109018 <select_and_run+0x7e8>
80108924:	89 c2                	mov    %eax,%edx
80108926:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108929:	89 3c 8d 60 c4 10 80 	mov    %edi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108930:	75 ce                	jne    80108900 <select_and_run+0xd0>
80108932:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80108935:	ba 01 00 00 00       	mov    $0x1,%edx
  mlfq.ps[idx] = p;
8010893a:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)
80108941:	eb 30                	jmp    80108973 <select_and_run+0x143>
80108943:	90                   	nop
80108944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		mp->stride = TOTAL_TICKETS / mlfq.tickets;
80108948:	b8 10 27 00 00       	mov    $0x2710,%eax
8010894d:	99                   	cltd   
8010894e:	f7 3d 64 c5 10 80    	idivl  0x8010c564
80108954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108957:	db 45 e4             	fildl  -0x1c(%ebp)
8010895a:	dd 9b 94 00 00 00    	fstpl  0x94(%ebx)
80108960:	e9 00 ff ff ff       	jmp    80108865 <select_and_run+0x35>
80108965:	8d 76 00             	lea    0x0(%esi),%esi
  } else if((!mp || mp->state != RUNNABLE) && (sp && sp->state == RUNNABLE)) {
80108968:	83 f8 03             	cmp    $0x3,%eax
8010896b:	0f 85 16 ff ff ff    	jne    80108887 <select_and_run+0x57>
  struct proc *sleep_p = 0;
80108971:	31 db                	xor    %ebx,%ebx
		enqueue_to_mlfq(mp);
		sleep_p = mp;
	}

	if(sp && sp->state == SLEEPING) {
80108973:	85 f6                	test   %esi,%esi
80108975:	74 0c                	je     80108983 <select_and_run+0x153>
80108977:	8b 46 0c             	mov    0xc(%esi),%eax
8010897a:	83 f8 02             	cmp    $0x2,%eax
8010897d:	0f 84 fd 00 00 00    	je     80108a80 <select_and_run+0x250>

  if(flag)
	return 0;

  return sleep_p;
}
80108983:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108986:	89 d8                	mov    %ebx,%eax
80108988:	5b                   	pop    %ebx
80108989:	5e                   	pop    %esi
8010898a:	5f                   	pop    %edi
8010898b:	5d                   	pop    %ebp
8010898c:	c3                   	ret    
8010898d:	8d 76 00             	lea    0x0(%esi),%esi
  } else if((!mp || mp->state != RUNNABLE) && (sp && sp->state == RUNNABLE)) {
80108990:	85 c0                	test   %eax,%eax
80108992:	0f 84 d8 00 00 00    	je     80108a70 <select_and_run+0x240>
80108998:	8b 40 0c             	mov    0xc(%eax),%eax
8010899b:	83 f8 03             	cmp    $0x3,%eax
8010899e:	75 da                	jne    8010897a <select_and_run+0x14a>
	c->proc = sp;
801089a0:	8b 45 08             	mov    0x8(%ebp),%eax
	switchuvm(sp);
801089a3:	83 ec 0c             	sub    $0xc,%esp
	c->proc = sp;
801089a6:	89 b0 ac 00 00 00    	mov    %esi,0xac(%eax)
	switchuvm(sp);
801089ac:	56                   	push   %esi
801089ad:	e8 4e ee ff ff       	call   80107800 <switchuvm>
	sp->state = RUNNING;
801089b2:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
	swtch(&(c->scheduler), sp->context);
801089b9:	58                   	pop    %eax
801089ba:	8b 45 08             	mov    0x8(%ebp),%eax
801089bd:	5a                   	pop    %edx
801089be:	ff 76 1c             	pushl  0x1c(%esi)
801089c1:	83 c0 04             	add    $0x4,%eax
801089c4:	50                   	push   %eax
801089c5:	e8 81 c7 ff ff       	call   8010514b <swtch>
	switchkvm();
801089ca:	e8 11 ee ff ff       	call   801077e0 <switchkvm>
  if(sq.cnt >= NPROC)
801089cf:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
801089d5:	83 c4 10             	add    $0x10,%esp
801089d8:	83 f9 3f             	cmp    $0x3f,%ecx
801089db:	0f 8f 8f 00 00 00    	jg     80108a70 <select_and_run+0x240>
  idx = ++sq.cnt;
801089e1:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801089e4:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++sq.cnt;
801089e7:	89 0d 0c c8 10 80    	mov    %ecx,0x8010c80c
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801089ed:	74 63                	je     80108a52 <select_and_run+0x222>
801089ef:	89 ca                	mov    %ecx,%edx
801089f1:	c1 ea 1f             	shr    $0x1f,%edx
801089f4:	01 ca                	add    %ecx,%edx
801089f6:	d1 fa                	sar    %edx
801089f8:	8b 3c 95 00 c7 10 80 	mov    -0x7fef3900(,%edx,4),%edi
801089ff:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108a05:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
80108a0b:	df e9                	fucomip %st(1),%st
80108a0d:	dd d8                	fstp   %st(0)
80108a0f:	77 35                	ja     80108a46 <select_and_run+0x216>
80108a11:	e9 94 06 00 00       	jmp    801090aa <select_and_run+0x87a>
80108a16:	8d 76 00             	lea    0x0(%esi),%esi
80108a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108a20:	89 d0                	mov    %edx,%eax
80108a22:	89 d1                	mov    %edx,%ecx
80108a24:	c1 e8 1f             	shr    $0x1f,%eax
80108a27:	01 d0                	add    %edx,%eax
80108a29:	d1 f8                	sar    %eax
80108a2b:	8b 3c 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%edi
80108a32:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108a38:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
80108a3e:	df e9                	fucomip %st(1),%st
80108a40:	dd d8                	fstp   %st(0)
80108a42:	76 13                	jbe    80108a57 <select_and_run+0x227>
80108a44:	89 c2                	mov    %eax,%edx
80108a46:	83 fa 01             	cmp    $0x1,%edx
  	sq.ps[idx] = sq.ps[idx/2];
80108a49:	89 3c 8d 00 c7 10 80 	mov    %edi,-0x7fef3900(,%ecx,4)
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108a50:	75 ce                	jne    80108a20 <select_and_run+0x1f0>
80108a52:	ba 01 00 00 00       	mov    $0x1,%edx
	if(mp && mp->state == SLEEPING) {
80108a57:	85 db                	test   %ebx,%ebx
  sq.ps[idx] = p;
80108a59:	89 34 95 00 c7 10 80 	mov    %esi,-0x7fef3900(,%edx,4)
	if(mp && mp->state == SLEEPING) {
80108a60:	0f 85 bb 03 00 00    	jne    80108e21 <select_and_run+0x5f1>
80108a66:	8d 76 00             	lea    0x0(%esi),%esi
80108a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	return 0;
80108a70:	31 db                	xor    %ebx,%ebx
}
80108a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a75:	89 d8                	mov    %ebx,%eax
80108a77:	5b                   	pop    %ebx
80108a78:	5e                   	pop    %esi
80108a79:	5f                   	pop    %edi
80108a7a:	5d                   	pop    %ebp
80108a7b:	c3                   	ret    
80108a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		sp->pass = sq.ps[sq.cnt]->pass;
80108a80:	a1 0c c8 10 80       	mov    0x8010c80c,%eax
80108a85:	8b 04 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%eax
80108a8c:	dd 80 8c 00 00 00    	fldl   0x8c(%eax)
80108a92:	dd 9e 8c 00 00 00    	fstpl  0x8c(%esi)
  if(sq.cnt >= NPROC)
80108a98:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
80108a9e:	83 f9 3f             	cmp    $0x3f,%ecx
80108aa1:	7f 7b                	jg     80108b1e <select_and_run+0x2ee>
  idx = ++sq.cnt;
80108aa3:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108aa6:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++sq.cnt;
80108aa9:	89 0d 0c c8 10 80    	mov    %ecx,0x8010c80c
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108aaf:	74 61                	je     80108b12 <select_and_run+0x2e2>
80108ab1:	89 ca                	mov    %ecx,%edx
80108ab3:	c1 ea 1f             	shr    $0x1f,%edx
80108ab6:	01 ca                	add    %ecx,%edx
80108ab8:	d1 fa                	sar    %edx
80108aba:	8b 3c 95 00 c7 10 80 	mov    -0x7fef3900(,%edx,4),%edi
80108ac1:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108ac7:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
80108acd:	df e9                	fucomip %st(1),%st
80108acf:	dd d8                	fstp   %st(0)
80108ad1:	77 33                	ja     80108b06 <select_and_run+0x2d6>
80108ad3:	e9 b0 05 00 00       	jmp    80109088 <select_and_run+0x858>
80108ad8:	90                   	nop
80108ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108ae0:	89 d0                	mov    %edx,%eax
80108ae2:	89 d1                	mov    %edx,%ecx
80108ae4:	c1 e8 1f             	shr    $0x1f,%eax
80108ae7:	01 d0                	add    %edx,%eax
80108ae9:	d1 f8                	sar    %eax
80108aeb:	8b 3c 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%edi
80108af2:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108af8:	dd 87 8c 00 00 00    	fldl   0x8c(%edi)
80108afe:	df e9                	fucomip %st(1),%st
80108b00:	dd d8                	fstp   %st(0)
80108b02:	76 13                	jbe    80108b17 <select_and_run+0x2e7>
80108b04:	89 c2                	mov    %eax,%edx
80108b06:	83 fa 01             	cmp    $0x1,%edx
  	sq.ps[idx] = sq.ps[idx/2];
80108b09:	89 3c 8d 00 c7 10 80 	mov    %edi,-0x7fef3900(,%ecx,4)
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108b10:	75 ce                	jne    80108ae0 <select_and_run+0x2b0>
80108b12:	ba 01 00 00 00       	mov    $0x1,%edx
  sq.ps[idx] = p;
80108b17:	89 34 95 00 c7 10 80 	mov    %esi,-0x7fef3900(,%edx,4)
		if(sleep_p && sleep_p->pass > sp->pass) sleep_p = sp;
80108b1e:	85 db                	test   %ebx,%ebx
80108b20:	0f 84 aa 02 00 00    	je     80108dd0 <select_and_run+0x5a0>
80108b26:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108b2c:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108b32:	df e9                	fucomip %st(1),%st
80108b34:	dd d8                	fstp   %st(0)
80108b36:	0f 47 de             	cmova  %esi,%ebx
}
80108b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b3c:	89 d8                	mov    %ebx,%eax
80108b3e:	5b                   	pop    %ebx
80108b3f:	5e                   	pop    %esi
80108b40:	5f                   	pop    %edi
80108b41:	5d                   	pop    %ebp
80108b42:	c3                   	ret    
80108b43:	90                   	nop
80108b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else if((mp && mp->state == RUNNABLE) && (!sp || sp->state != RUNNABLE)) {
80108b48:	85 f6                	test   %esi,%esi
80108b4a:	0f 84 40 04 00 00    	je     80108f90 <select_and_run+0x760>
80108b50:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80108b54:	0f 84 0e fe ff ff    	je     80108968 <select_and_run+0x138>
	c->proc = mp;
80108b5a:	8b 45 08             	mov    0x8(%ebp),%eax
	switchuvm(mp);
80108b5d:	83 ec 0c             	sub    $0xc,%esp
	c->proc = mp;
80108b60:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
	switchuvm(mp);
80108b66:	53                   	push   %ebx
80108b67:	e8 94 ec ff ff       	call   80107800 <switchuvm>
	swtch(&(c->scheduler), mp->context);
80108b6c:	8b 45 08             	mov    0x8(%ebp),%eax
	mp->state = RUNNING;
80108b6f:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
	swtch(&(c->scheduler), mp->context);
80108b76:	59                   	pop    %ecx
80108b77:	5f                   	pop    %edi
80108b78:	83 c0 04             	add    $0x4,%eax
80108b7b:	ff 73 1c             	pushl  0x1c(%ebx)
80108b7e:	50                   	push   %eax
80108b7f:	e8 c7 c5 ff ff       	call   8010514b <swtch>
	switchkvm();
80108b84:	e8 57 ec ff ff       	call   801077e0 <switchkvm>
  if(mlfq.cnt >= NPROC)
80108b89:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80108b8f:	83 c4 10             	add    $0x10,%esp
80108b92:	83 f9 3f             	cmp    $0x3f,%ecx
80108b95:	0f 8e 65 03 00 00    	jle    80108f00 <select_and_run+0x6d0>
	if(sp && sp->state == SLEEPING) {
80108b9b:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
80108b9f:	0f 85 cb fe ff ff    	jne    80108a70 <select_and_run+0x240>
		sp->pass = sq.ps[sq.cnt]->pass;
80108ba5:	a1 0c c8 10 80       	mov    0x8010c80c,%eax
80108baa:	8b 04 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%eax
80108bb1:	dd 80 8c 00 00 00    	fldl   0x8c(%eax)
80108bb7:	dd 9e 8c 00 00 00    	fstpl  0x8c(%esi)
  if(sq.cnt >= NPROC)
80108bbd:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
80108bc3:	83 f9 3f             	cmp    $0x3f,%ecx
80108bc6:	0f 8f a4 fe ff ff    	jg     80108a70 <select_and_run+0x240>
  idx = ++sq.cnt;
80108bcc:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108bcf:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++sq.cnt;
80108bd2:	89 0d 0c c8 10 80    	mov    %ecx,0x8010c80c
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108bd8:	74 60                	je     80108c3a <select_and_run+0x40a>
80108bda:	89 ca                	mov    %ecx,%edx
80108bdc:	c1 ea 1f             	shr    $0x1f,%edx
80108bdf:	01 ca                	add    %ecx,%edx
80108be1:	d1 fa                	sar    %edx
80108be3:	8b 1c 95 00 c7 10 80 	mov    -0x7fef3900(,%edx,4),%ebx
80108bea:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108bf0:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108bf6:	df e9                	fucomip %st(1),%st
80108bf8:	dd d8                	fstp   %st(0)
80108bfa:	77 32                	ja     80108c2e <select_and_run+0x3fe>
80108bfc:	e9 95 04 00 00       	jmp    80109096 <select_and_run+0x866>
80108c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c08:	89 d0                	mov    %edx,%eax
80108c0a:	89 d1                	mov    %edx,%ecx
80108c0c:	c1 e8 1f             	shr    $0x1f,%eax
80108c0f:	01 d0                	add    %edx,%eax
80108c11:	d1 f8                	sar    %eax
80108c13:	8b 1c 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%ebx
80108c1a:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108c20:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108c26:	df e9                	fucomip %st(1),%st
80108c28:	dd d8                	fstp   %st(0)
80108c2a:	76 13                	jbe    80108c3f <select_and_run+0x40f>
80108c2c:	89 c2                	mov    %eax,%edx
80108c2e:	83 fa 01             	cmp    $0x1,%edx
  	sq.ps[idx] = sq.ps[idx/2];
80108c31:	89 1c 8d 00 c7 10 80 	mov    %ebx,-0x7fef3900(,%ecx,4)
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108c38:	75 ce                	jne    80108c08 <select_and_run+0x3d8>
80108c3a:	ba 01 00 00 00       	mov    $0x1,%edx
  sq.ps[idx] = p;
80108c3f:	89 34 95 00 c7 10 80 	mov    %esi,-0x7fef3900(,%edx,4)
	return 0;
80108c46:	31 db                	xor    %ebx,%ebx
80108c48:	e9 36 fd ff ff       	jmp    80108983 <select_and_run+0x153>
80108c4d:	8d 76 00             	lea    0x0(%esi),%esi
  if((mp && mp->state == RUNNABLE) && (sp && sp->state == RUNNABLE)) {
80108c50:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80108c54:	0f 85 f6 fe ff ff    	jne    80108b50 <select_and_run+0x320>
	if(mp->pass <= sp->pass) {
80108c5a:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108c60:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108c66:	8b 45 08             	mov    0x8(%ebp),%eax
80108c69:	8d 78 04             	lea    0x4(%eax),%edi
80108c6c:	df e9                	fucomip %st(1),%st
80108c6e:	dd d8                	fstp   %st(0)
80108c70:	0f 83 52 02 00 00    	jae    80108ec8 <select_and_run+0x698>
		c->proc = sp;
80108c76:	8b 45 08             	mov    0x8(%ebp),%eax
		switchuvm(sp);
80108c79:	83 ec 0c             	sub    $0xc,%esp
		c->proc = sp;
80108c7c:	89 b0 ac 00 00 00    	mov    %esi,0xac(%eax)
		switchuvm(sp);
80108c82:	56                   	push   %esi
80108c83:	e8 78 eb ff ff       	call   80107800 <switchuvm>
		sp->state = RUNNING;
80108c88:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
		swtch(&(c->scheduler), sp->context);
80108c8f:	59                   	pop    %ecx
80108c90:	58                   	pop    %eax
80108c91:	ff 76 1c             	pushl  0x1c(%esi)
80108c94:	57                   	push   %edi
80108c95:	e8 b1 c4 ff ff       	call   8010514b <swtch>
		switchkvm();
80108c9a:	e8 41 eb ff ff       	call   801077e0 <switchkvm>
80108c9f:	83 c4 10             	add    $0x10,%esp
  if(mlfq.cnt >= NPROC)
80108ca2:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80108ca8:	83 f9 3f             	cmp    $0x3f,%ecx
80108cab:	7f 7c                	jg     80108d29 <select_and_run+0x4f9>
  idx = ++mlfq.cnt;
80108cad:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108cb0:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
80108cb3:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108cb9:	74 62                	je     80108d1d <select_and_run+0x4ed>
80108cbb:	89 ca                	mov    %ecx,%edx
80108cbd:	c1 ea 1f             	shr    $0x1f,%edx
80108cc0:	01 ca                	add    %ecx,%edx
80108cc2:	d1 fa                	sar    %edx
80108cc4:	8b 3c 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%edi
80108ccb:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80108cd1:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
80108cd7:	0f 8d e2 03 00 00    	jge    801090bf <select_and_run+0x88f>
80108cdd:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80108ce0:	eb 2c                	jmp    80108d0e <select_and_run+0x4de>
80108ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108ce8:	89 d0                	mov    %edx,%eax
80108cea:	89 d1                	mov    %edx,%ecx
80108cec:	c1 e8 1f             	shr    $0x1f,%eax
80108cef:	01 d0                	add    %edx,%eax
80108cf1:	d1 f8                	sar    %eax
80108cf3:	8b 3c 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%edi
80108cfa:	8b b7 80 00 00 00    	mov    0x80(%edi),%esi
80108d00:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
80108d06:	0f 8d 74 03 00 00    	jge    80109080 <select_and_run+0x850>
80108d0c:	89 c2                	mov    %eax,%edx
80108d0e:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108d11:	89 3c 8d 60 c4 10 80 	mov    %edi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108d18:	75 ce                	jne    80108ce8 <select_and_run+0x4b8>
80108d1a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80108d1d:	ba 01 00 00 00       	mov    $0x1,%edx
  mlfq.ps[idx] = p;
80108d22:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)
  if(sq.cnt >= NPROC)
80108d29:	8b 15 0c c8 10 80    	mov    0x8010c80c,%edx
80108d2f:	83 fa 3f             	cmp    $0x3f,%edx
80108d32:	0f 8f 38 fd ff ff    	jg     80108a70 <select_and_run+0x240>
  idx = ++sq.cnt;
80108d38:	83 c2 01             	add    $0x1,%edx
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108d3b:	83 fa 01             	cmp    $0x1,%edx
  idx = ++sq.cnt;
80108d3e:	89 15 0c c8 10 80    	mov    %edx,0x8010c80c
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108d44:	74 5c                	je     80108da2 <select_and_run+0x572>
80108d46:	89 d1                	mov    %edx,%ecx
80108d48:	c1 e9 1f             	shr    $0x1f,%ecx
80108d4b:	01 d1                	add    %edx,%ecx
80108d4d:	d1 f9                	sar    %ecx
80108d4f:	8b 1c 8d 00 c7 10 80 	mov    -0x7fef3900(,%ecx,4),%ebx
80108d56:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108d5c:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108d62:	df e9                	fucomip %st(1),%st
80108d64:	dd d8                	fstp   %st(0)
80108d66:	77 2e                	ja     80108d96 <select_and_run+0x566>
80108d68:	e9 59 03 00 00       	jmp    801090c6 <select_and_run+0x896>
80108d6d:	8d 76 00             	lea    0x0(%esi),%esi
80108d70:	89 c8                	mov    %ecx,%eax
80108d72:	89 ca                	mov    %ecx,%edx
80108d74:	c1 e8 1f             	shr    $0x1f,%eax
80108d77:	01 c8                	add    %ecx,%eax
80108d79:	d1 f8                	sar    %eax
80108d7b:	8b 1c 85 00 c7 10 80 	mov    -0x7fef3900(,%eax,4),%ebx
80108d82:	dd 86 8c 00 00 00    	fldl   0x8c(%esi)
80108d88:	dd 83 8c 00 00 00    	fldl   0x8c(%ebx)
80108d8e:	df e9                	fucomip %st(1),%st
80108d90:	dd d8                	fstp   %st(0)
80108d92:	76 13                	jbe    80108da7 <select_and_run+0x577>
80108d94:	89 c1                	mov    %eax,%ecx
80108d96:	83 f9 01             	cmp    $0x1,%ecx
  	sq.ps[idx] = sq.ps[idx/2];
80108d99:	89 1c 95 00 c7 10 80 	mov    %ebx,-0x7fef3900(,%edx,4)
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80108da0:	75 ce                	jne    80108d70 <select_and_run+0x540>
80108da2:	b9 01 00 00 00       	mov    $0x1,%ecx
  sq.ps[idx] = p;
80108da7:	89 34 8d 00 c7 10 80 	mov    %esi,-0x7fef3900(,%ecx,4)
	return 0;
80108dae:	31 db                	xor    %ebx,%ebx
80108db0:	e9 ce fb ff ff       	jmp    80108983 <select_and_run+0x153>
80108db5:	8d 76 00             	lea    0x0(%esi),%esi
  } else if((!mp || mp->state != RUNNABLE) && (sp && sp->state == RUNNABLE)) {
80108db8:	8b 43 0c             	mov    0xc(%ebx),%eax
80108dbb:	83 f8 03             	cmp    $0x3,%eax
80108dbe:	0f 84 6c 02 00 00    	je     80109030 <select_and_run+0x800>
  struct proc *sleep_p = 0;
80108dc4:	31 db                	xor    %ebx,%ebx
80108dc6:	e9 af fb ff ff       	jmp    8010897a <select_and_run+0x14a>
80108dcb:	90                   	nop
80108dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108dd0:	89 f3                	mov    %esi,%ebx
80108dd2:	e9 ac fb ff ff       	jmp    80108983 <select_and_run+0x153>
80108dd7:	89 f6                	mov    %esi,%esi
80108dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	c->proc = sp;
80108de0:	8b 45 08             	mov    0x8(%ebp),%eax
	switchuvm(sp);
80108de3:	83 ec 0c             	sub    $0xc,%esp
	c->proc = sp;
80108de6:	89 b0 ac 00 00 00    	mov    %esi,0xac(%eax)
	switchuvm(sp);
80108dec:	56                   	push   %esi
80108ded:	e8 0e ea ff ff       	call   80107800 <switchuvm>
	swtch(&(c->scheduler), sp->context);
80108df2:	8b 45 08             	mov    0x8(%ebp),%eax
	sp->state = RUNNING;
80108df5:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
	swtch(&(c->scheduler), sp->context);
80108dfc:	59                   	pop    %ecx
80108dfd:	5f                   	pop    %edi
80108dfe:	83 c0 04             	add    $0x4,%eax
80108e01:	ff 76 1c             	pushl  0x1c(%esi)
80108e04:	50                   	push   %eax
80108e05:	e8 41 c3 ff ff       	call   8010514b <swtch>
	switchkvm();
80108e0a:	e8 d1 e9 ff ff       	call   801077e0 <switchkvm>
  if(sq.cnt >= NPROC)
80108e0f:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
80108e15:	83 c4 10             	add    $0x10,%esp
80108e18:	83 f9 3f             	cmp    $0x3f,%ecx
80108e1b:	0f 8e c0 fb ff ff    	jle    801089e1 <select_and_run+0x1b1>
	if(mp && mp->state == SLEEPING) {
80108e21:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80108e25:	0f 85 45 fc ff ff    	jne    80108a70 <select_and_run+0x240>
		mp->lev = 2;
80108e2b:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
80108e32:	00 00 00 
		mp->used_time = 0;
80108e35:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80108e3c:	00 00 00 
  if(mlfq.cnt >= NPROC)
80108e3f:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80108e45:	83 f9 3f             	cmp    $0x3f,%ecx
80108e48:	0f 8f 22 fc ff ff    	jg     80108a70 <select_and_run+0x240>
  idx = ++mlfq.cnt;
80108e4e:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108e51:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
80108e54:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108e5a:	74 52                	je     80108eae <select_and_run+0x67e>
80108e5c:	89 ca                	mov    %ecx,%edx
80108e5e:	c1 ea 1f             	shr    $0x1f,%edx
80108e61:	01 ca                	add    %ecx,%edx
80108e63:	d1 fa                	sar    %edx
80108e65:	8b 34 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%esi
80108e6c:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80108e72:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
80108e78:	7c 28                	jl     80108ea2 <select_and_run+0x672>
80108e7a:	e9 39 02 00 00       	jmp    801090b8 <select_and_run+0x888>
80108e7f:	90                   	nop
80108e80:	89 d0                	mov    %edx,%eax
80108e82:	89 d1                	mov    %edx,%ecx
80108e84:	c1 e8 1f             	shr    $0x1f,%eax
80108e87:	01 d0                	add    %edx,%eax
80108e89:	d1 f8                	sar    %eax
80108e8b:	8b 34 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%esi
80108e92:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
80108e98:	39 bb 80 00 00 00    	cmp    %edi,0x80(%ebx)
80108e9e:	7d 13                	jge    80108eb3 <select_and_run+0x683>
80108ea0:	89 c2                	mov    %eax,%edx
80108ea2:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108ea5:	89 34 8d 60 c4 10 80 	mov    %esi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108eac:	75 d2                	jne    80108e80 <select_and_run+0x650>
80108eae:	ba 01 00 00 00       	mov    $0x1,%edx
  mlfq.ps[idx] = p;
80108eb3:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)
	return 0;
80108eba:	31 db                	xor    %ebx,%ebx
80108ebc:	e9 b1 fb ff ff       	jmp    80108a72 <select_and_run+0x242>
80108ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		switchuvm(mp);
80108ec8:	83 ec 0c             	sub    $0xc,%esp
		c->proc = mp;
80108ecb:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
		switchuvm(mp);
80108ed1:	53                   	push   %ebx
80108ed2:	e8 29 e9 ff ff       	call   80107800 <switchuvm>
		mp->state = RUNNING;
80108ed7:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
		swtch(&(c->scheduler), mp->context);
80108ede:	58                   	pop    %eax
80108edf:	5a                   	pop    %edx
80108ee0:	ff 73 1c             	pushl  0x1c(%ebx)
80108ee3:	57                   	push   %edi
80108ee4:	e8 62 c2 ff ff       	call   8010514b <swtch>
		switchkvm();
80108ee9:	e8 f2 e8 ff ff       	call   801077e0 <switchkvm>
80108eee:	83 c4 10             	add    $0x10,%esp
80108ef1:	e9 ac fd ff ff       	jmp    80108ca2 <select_and_run+0x472>
80108ef6:	8d 76 00             	lea    0x0(%esi),%esi
80108ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  idx = ++mlfq.cnt;
80108f00:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108f03:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
80108f06:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108f0c:	74 5f                	je     80108f6d <select_and_run+0x73d>
80108f0e:	89 ca                	mov    %ecx,%edx
80108f10:	c1 ea 1f             	shr    $0x1f,%edx
80108f13:	01 ca                	add    %ecx,%edx
80108f15:	d1 fa                	sar    %edx
80108f17:	8b 3c 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%edi
80108f1e:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80108f24:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
80108f2a:	0f 8d 81 01 00 00    	jge    801090b1 <select_and_run+0x881>
80108f30:	89 75 e0             	mov    %esi,-0x20(%ebp)
80108f33:	eb 29                	jmp    80108f5e <select_and_run+0x72e>
80108f35:	8d 76 00             	lea    0x0(%esi),%esi
80108f38:	89 d0                	mov    %edx,%eax
80108f3a:	89 d1                	mov    %edx,%ecx
80108f3c:	c1 e8 1f             	shr    $0x1f,%eax
80108f3f:	01 d0                	add    %edx,%eax
80108f41:	d1 f8                	sar    %eax
80108f43:	8b 3c 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%edi
80108f4a:	8b b7 80 00 00 00    	mov    0x80(%edi),%esi
80108f50:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
80108f56:	0f 8d c4 00 00 00    	jge    80109020 <select_and_run+0x7f0>
80108f5c:	89 c2                	mov    %eax,%edx
80108f5e:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80108f61:	89 3c 8d 60 c4 10 80 	mov    %edi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108f68:	75 ce                	jne    80108f38 <select_and_run+0x708>
80108f6a:	8b 75 e0             	mov    -0x20(%ebp),%esi
  idx = ++mlfq.cnt;
80108f6d:	ba 01 00 00 00       	mov    $0x1,%edx
	if(sp && sp->state == SLEEPING) {
80108f72:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
  mlfq.ps[idx] = p;
80108f76:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)
	if(sp && sp->state == SLEEPING) {
80108f7d:	0f 85 18 fc ff ff    	jne    80108b9b <select_and_run+0x36b>
	return 0;
80108f83:	31 db                	xor    %ebx,%ebx
80108f85:	e9 e8 fa ff ff       	jmp    80108a72 <select_and_run+0x242>
80108f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	c->proc = mp;
80108f90:	8b 45 08             	mov    0x8(%ebp),%eax
	switchuvm(mp);
80108f93:	83 ec 0c             	sub    $0xc,%esp
	c->proc = mp;
80108f96:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
	switchuvm(mp);
80108f9c:	53                   	push   %ebx
80108f9d:	e8 5e e8 ff ff       	call   80107800 <switchuvm>
	mp->state = RUNNING;
80108fa2:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
	swtch(&(c->scheduler), mp->context);
80108fa9:	58                   	pop    %eax
80108faa:	8b 45 08             	mov    0x8(%ebp),%eax
80108fad:	5a                   	pop    %edx
80108fae:	ff 73 1c             	pushl  0x1c(%ebx)
80108fb1:	83 c0 04             	add    $0x4,%eax
80108fb4:	50                   	push   %eax
80108fb5:	e8 91 c1 ff ff       	call   8010514b <swtch>
	switchkvm();
80108fba:	e8 21 e8 ff ff       	call   801077e0 <switchkvm>
  if(mlfq.cnt >= NPROC)
80108fbf:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80108fc5:	83 c4 10             	add    $0x10,%esp
80108fc8:	83 f9 3f             	cmp    $0x3f,%ecx
80108fcb:	0f 8f 9f fa ff ff    	jg     80108a70 <select_and_run+0x240>
  idx = ++mlfq.cnt;
80108fd1:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108fd4:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
80108fd7:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80108fdd:	0f 84 ba 00 00 00    	je     8010909d <select_and_run+0x86d>
80108fe3:	89 ca                	mov    %ecx,%edx
80108fe5:	c1 ea 1f             	shr    $0x1f,%edx
80108fe8:	01 ca                	add    %ecx,%edx
80108fea:	d1 fa                	sar    %edx
80108fec:	8b 3c 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%edi
80108ff3:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80108ff9:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
80108fff:	0f 8c 2b ff ff ff    	jl     80108f30 <select_and_run+0x700>
  mlfq.ps[idx] = p;
80109005:	89 1c 8d 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%ecx,4)
	return 0;
8010900c:	31 db                	xor    %ebx,%ebx
8010900e:	e9 5f fa ff ff       	jmp    80108a72 <select_and_run+0x242>
80109013:	90                   	nop
80109014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80109018:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010901b:	e9 1a f9 ff ff       	jmp    8010893a <select_and_run+0x10a>
80109020:	8b 75 e0             	mov    -0x20(%ebp),%esi
80109023:	e9 4a ff ff ff       	jmp    80108f72 <select_and_run+0x742>
80109028:	90                   	nop
80109029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	c->proc = sp;
80109030:	8b 45 08             	mov    0x8(%ebp),%eax
	switchuvm(sp);
80109033:	83 ec 0c             	sub    $0xc,%esp
	c->proc = sp;
80109036:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
	switchuvm(sp);
8010903c:	53                   	push   %ebx
8010903d:	e8 be e7 ff ff       	call   80107800 <switchuvm>
	sp->state = RUNNING;
80109042:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
	swtch(&(c->scheduler), sp->context);
80109049:	58                   	pop    %eax
8010904a:	8b 45 08             	mov    0x8(%ebp),%eax
8010904d:	5a                   	pop    %edx
8010904e:	ff 73 1c             	pushl  0x1c(%ebx)
80109051:	83 c0 04             	add    $0x4,%eax
80109054:	50                   	push   %eax
80109055:	e8 f1 c0 ff ff       	call   8010514b <swtch>
	switchkvm();
8010905a:	e8 81 e7 ff ff       	call   801077e0 <switchkvm>
  if(sq.cnt >= NPROC)
8010905f:	8b 0d 0c c8 10 80    	mov    0x8010c80c,%ecx
80109065:	83 c4 10             	add    $0x10,%esp
80109068:	83 f9 3f             	cmp    $0x3f,%ecx
8010906b:	0f 8f ff f9 ff ff    	jg     80108a70 <select_and_run+0x240>
80109071:	31 db                	xor    %ebx,%ebx
80109073:	e9 69 f9 ff ff       	jmp    801089e1 <select_and_run+0x1b1>
80109078:	90                   	nop
80109079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109080:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80109083:	e9 9a fc ff ff       	jmp    80108d22 <select_and_run+0x4f2>
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80109088:	89 ca                	mov    %ecx,%edx
8010908a:	e9 88 fa ff ff       	jmp    80108b17 <select_and_run+0x2e7>
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
8010908f:	89 ca                	mov    %ecx,%edx
80109091:	e9 a4 f8 ff ff       	jmp    8010893a <select_and_run+0x10a>
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
80109096:	89 ca                	mov    %ecx,%edx
80109098:	e9 a2 fb ff ff       	jmp    80108c3f <select_and_run+0x40f>
  mlfq.ps[idx] = p;
8010909d:	89 1d 64 c4 10 80    	mov    %ebx,0x8010c464
	return 0;
801090a3:	31 db                	xor    %ebx,%ebx
801090a5:	e9 d9 f8 ff ff       	jmp    80108983 <select_and_run+0x153>
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801090aa:	89 ca                	mov    %ecx,%edx
801090ac:	e9 a6 f9 ff ff       	jmp    80108a57 <select_and_run+0x227>
  idx = ++mlfq.cnt;
801090b1:	89 ca                	mov    %ecx,%edx
801090b3:	e9 ba fe ff ff       	jmp    80108f72 <select_and_run+0x742>
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801090b8:	89 ca                	mov    %ecx,%edx
801090ba:	e9 f4 fd ff ff       	jmp    80108eb3 <select_and_run+0x683>
801090bf:	89 ca                	mov    %ecx,%edx
801090c1:	e9 5c fc ff ff       	jmp    80108d22 <select_and_run+0x4f2>
  while((idx != 1) && (p->pass < sq.ps[idx/2]->pass)) {
801090c6:	89 d1                	mov    %edx,%ecx
801090c8:	e9 da fc ff ff       	jmp    80108da7 <select_and_run+0x577>
801090cd:	8d 76 00             	lea    0x0(%esi),%esi

801090d0 <init_process>:

void
init_process(struct proc* p)
{
801090d0:	55                   	push   %ebp
801090d1:	89 e5                	mov    %esp,%ebp
801090d3:	57                   	push   %edi
801090d4:	56                   	push   %esi
801090d5:	53                   	push   %ebx
801090d6:	83 ec 04             	sub    $0x4,%esp
	p->tickets = mlfq.tickets;
801090d9:	a1 64 c5 10 80       	mov    0x8010c564,%eax
{
801090de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	p->tickets = mlfq.tickets;
801090e1:	89 43 7c             	mov    %eax,0x7c(%ebx)
	p->lev = 0;
801090e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801090eb:	00 00 00 
	p->used_time = 0;
801090ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801090f5:	00 00 00 
	p->in_mlfq = 1;
801090f8:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801090ff:	00 00 00 
	p->pass = get_min_pass();
80109102:	e8 09 f2 ff ff       	call   80108310 <get_min_pass>
80109107:	dd 9b 8c 00 00 00    	fstpl  0x8c(%ebx)
	p->stride = (double)TOTAL_TICKETS / mlfq.tickets;
8010910d:	db 05 64 c5 10 80    	fildl  0x8010c564
	p->searched = -1;
80109113:	c7 83 c0 00 00 00 ff 	movl   $0xffffffff,0xc0(%ebx)
8010911a:	ff ff ff 

	p->master = p; // It is master process
8010911d:	89 9b ac 00 00 00    	mov    %ebx,0xac(%ebx)
	p->stride = (double)TOTAL_TICKETS / mlfq.tickets;
80109123:	d8 3d 8c 9c 10 80    	fdivrs 0x80109c8c
80109129:	dd 9b 94 00 00 00    	fstpl  0x94(%ebx)
  if(mlfq.cnt >= NPROC)
8010912f:	8b 0d 6c c5 10 80    	mov    0x8010c56c,%ecx
80109135:	83 f9 3f             	cmp    $0x3f,%ecx
80109138:	7f 70                	jg     801091aa <init_process+0xda>
  idx = ++mlfq.cnt;
8010913a:	83 c1 01             	add    $0x1,%ecx
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
8010913d:	83 f9 01             	cmp    $0x1,%ecx
  idx = ++mlfq.cnt;
80109140:	89 0d 6c c5 10 80    	mov    %ecx,0x8010c56c
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
80109146:	74 56                	je     8010919e <init_process+0xce>
80109148:	89 ca                	mov    %ecx,%edx
8010914a:	c1 ea 1f             	shr    $0x1f,%edx
8010914d:	01 ca                	add    %ecx,%edx
8010914f:	d1 fa                	sar    %edx
80109151:	8b 34 95 60 c4 10 80 	mov    -0x7fef3ba0(,%edx,4),%esi
80109158:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010915e:	39 83 80 00 00 00    	cmp    %eax,0x80(%ebx)
80109164:	7c 2c                	jl     80109192 <init_process+0xc2>
80109166:	eb 50                	jmp    801091b8 <init_process+0xe8>
80109168:	90                   	nop
80109169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109170:	89 d0                	mov    %edx,%eax
80109172:	89 d1                	mov    %edx,%ecx
80109174:	c1 e8 1f             	shr    $0x1f,%eax
80109177:	01 d0                	add    %edx,%eax
80109179:	d1 f8                	sar    %eax
8010917b:	8b 34 85 60 c4 10 80 	mov    -0x7fef3ba0(,%eax,4),%esi
80109182:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
80109188:	39 bb 80 00 00 00    	cmp    %edi,0x80(%ebx)
8010918e:	7d 13                	jge    801091a3 <init_process+0xd3>
80109190:	89 c2                	mov    %eax,%edx
80109192:	83 fa 01             	cmp    $0x1,%edx
  	mlfq.ps[idx] = mlfq.ps[idx/2];
80109195:	89 34 8d 60 c4 10 80 	mov    %esi,-0x7fef3ba0(,%ecx,4)
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
8010919c:	75 d2                	jne    80109170 <init_process+0xa0>
8010919e:	ba 01 00 00 00       	mov    $0x1,%edx
  mlfq.ps[idx] = p;
801091a3:	89 1c 95 60 c4 10 80 	mov    %ebx,-0x7fef3ba0(,%edx,4)

	enqueue_to_mlfq(p);
}
801091aa:	83 c4 04             	add    $0x4,%esp
801091ad:	5b                   	pop    %ebx
801091ae:	5e                   	pop    %esi
801091af:	5f                   	pop    %edi
801091b0:	5d                   	pop    %ebp
801091b1:	c3                   	ret    
801091b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((idx != 1) && (p->lev < mlfq.ps[idx/2]->lev)) {
801091b8:	89 ca                	mov    %ecx,%edx
801091ba:	eb e7                	jmp    801091a3 <init_process+0xd3>
