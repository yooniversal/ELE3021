# ELE3021 : Operating Systems (Prof. Hyungsoo Jung)
[기존의 xv6](https://github.com/mit-pdos/xv6-public)에서 보다 효율적으로 동작할 수 있도록 개선합니다.<br>
총 4번의 단계로 진행됐으며 내용은 다음과 같습니다.<br>

## Project 01. MLFQ and Stride Scheduling
xv6 스케쥴러는 Round Robin 알고리즘을 기반으로 동작하기 때문에 response time이 짧다는 장점을 가지고 있으나, 각 프로세스의 priority와 무관하게 context switch를 수행합니다. 
또한, 스케쥴러는 turnaround time이 길다는 단점을 갖습니다. 기존의 스케쥴링 정책에서 priority를 고려하면서 turnaround time이 길다는 단점까지 보완하기 위해 
**Multi-Level Feedback Queue**와 **Stride Queue**를 같이 사용합니다. MLFQ 정책에 의해 priority를 고려하는 대신 fairness를 보장하지 
못하므로 이를 Stride Scheduling으로 보완하는 방식으로 동작합니다.
- [milestone 1: 구현 계획](https://github.com/yooniversal/ELE3021/wiki/Project-01.-MLFQ-and-Stride-Scheduling-(milestone1))
- [miltesone 2: 구현 및 테스트 결과](https://github.com/yooniversal/ELE3021/wiki/Project-01.-MLFQ-and-Stride-Scheduling-(milestone2))

## Project 02. Light weight Process(LWP)
xv6는 스케쥴링 시 **프로세스 단위**로 context switch를 수행합니다. 하지만 프로세스끼리 리소스를 공유하지 않으므로 context switch를 할 때마다 
오버헤드가 크다는 단점이 있는데, 각 프로세스를 일부 리소스를 공유하는 **스레드로 구성되도록** 한다면 스레드 간 context switch가 발생할 때 오버헤드가 
상대적으로 작아진다는 장점이 있습니다. 동작 방식은 *POSIX thread*를 따릅니다.
- [milestone 1: 구현 계획](https://github.com/yooniversal/ELE3021/wiki/Project-02.-Light-weight-Process-(milestone1))
- [milestone 2: 구현 - thread](https://github.com/yooniversal/ELE3021/wiki/Project-02.-Light-weight-Process-(milestone2))
- [milestone 3: 구현 - xv6](https://github.com/yooniversal/ELE3021/wiki/Project-02.-Light-weight-Process-(milestone3))

## Project 03. Semaphore and Readers Writer Lock
xv6는 프로세스 간의 critical section 접근을 방지하기 위해 **spinlock**을 사용합니다. spinlock은 확실히 locking을 보장할 수는 있으나, 
`sleep()`을 활용함에도 오버헤드가 크다는 단점을 갖고 있습니다. critical section에 writer가 아닌 여러 reader가 접근한다면 동시에 접근하더라도 
데이터 유실을 걱정할 필요가 없으므로 **Semaphore**와 **Readers-writer Lock**을 활용합니다. 동작 방식은 각각 *POSIX semaphore*과 *POSIX reader-writer lock*을 
따릅니다.
- [구현 내용](https://github.com/yooniversal/ELE3021/wiki/Project-03.-Semaphore-and-Readers-Writer-Lock)

## Project 04. File System
xv6의 inode는 **12 direct block number**와 **1 single indirect pointer**를 관리합니다. Single indirect pointer는 direct block을 가리키는 
pointers로 구성된 block을 가리키며, Double indirect pointer는 Single indirect pointers로 구성된 block을, Triple indirect pointer는 
Double indirect pointers로 구성된 block을 가리킵니다. 이 프로젝트에서는 inode가 **Double indirect pointer**와 **Triple indirect pointer**를 
관리하도록 개선합니다.
- [구현 내용](https://github.com/yooniversal/ELE3021/wiki/Project-04.-File-System)
