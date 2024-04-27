
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sub_process>:
    exit(0);

}

void sub_process(int input_fd[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    close(input_fd[1]); // 关闭上层递归传入的管道写入口
   c:	4148                	lw	a0,4(a0)
   e:	00000097          	auipc	ra,0x0
  12:	44c080e7          	jalr	1100(ra) # 45a <close>
    int sub_pid, sub_fd[2], prime, value, n; // prime为读到的第一个数，value为其他数

    read(input_fd[0], &prime, sizeof(int)); // 读取写入的第一个数，这个数为素数。
  16:	4611                	li	a2,4
  18:	fd440593          	addi	a1,s0,-44
  1c:	4088                	lw	a0,0(s1)
  1e:	00000097          	auipc	ra,0x0
  22:	42c080e7          	jalr	1068(ra) # 44a <read>
    printf("prime %d\n", prime);
  26:	fd442583          	lw	a1,-44(s0)
  2a:	00001517          	auipc	a0,0x1
  2e:	92650513          	addi	a0,a0,-1754 # 950 <malloc+0xe8>
  32:	00000097          	auipc	ra,0x0
  36:	778080e7          	jalr	1912(ra) # 7aa <printf>

    if((n = read(input_fd[0], &value, sizeof(int))) == 0) // 判断语句执行已经读入一个value
  3a:	4611                	li	a2,4
  3c:	fd040593          	addi	a1,s0,-48
  40:	4088                	lw	a0,0(s1)
  42:	00000097          	auipc	ra,0x0
  46:	408080e7          	jalr	1032(ra) # 44a <read>
  4a:	c51d                	beqz	a0,78 <sub_process+0x78>
    {
        exit(0); // 上层递归无写入,递归出口
    }

    else if(n < 0)
  4c:	02054a63          	bltz	a0,80 <sub_process+0x80>
    {
        exit(1); //读发生错误，返回值为-1
    }
    else // 问题还可以分解成子问题
    {   
        pipe(sub_fd);
  50:	fd840513          	addi	a0,s0,-40
  54:	00000097          	auipc	ra,0x0
  58:	3ee080e7          	jalr	1006(ra) # 442 <pipe>
        sub_pid = fork(); //fork()和pipe()的顺序不能改变
  5c:	00000097          	auipc	ra,0x0
  60:	3ce080e7          	jalr	974(ra) # 42a <fork>
        
        if(sub_pid == 0)
  64:	c11d                	beqz	a0,8a <sub_process+0x8a>
        {
            sub_process(sub_fd); // 递归处理子问题
        }
        else if(sub_pid > 0)
  66:	08a05763          	blez	a0,f4 <sub_process+0xf4>
        {
            close(sub_fd[0]); // 关闭读端口，仅仅写入
  6a:	fd842503          	lw	a0,-40(s0)
  6e:	00000097          	auipc	ra,0x0
  72:	3ec080e7          	jalr	1004(ra) # 45a <close>
  76:	a0b9                	j	c4 <sub_process+0xc4>
        exit(0); // 上层递归无写入,递归出口
  78:	00000097          	auipc	ra,0x0
  7c:	3ba080e7          	jalr	954(ra) # 432 <exit>
        exit(1); //读发生错误，返回值为-1
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	3b0080e7          	jalr	944(ra) # 432 <exit>
            sub_process(sub_fd); // 递归处理子问题
  8a:	fd840513          	addi	a0,s0,-40
  8e:	00000097          	auipc	ra,0x0
  92:	f72080e7          	jalr	-142(ra) # 0 <sub_process>
            exit(1);
        }

    }
   
}
  96:	70a2                	ld	ra,40(sp)
  98:	7402                	ld	s0,32(sp)
  9a:	64e2                	ld	s1,24(sp)
  9c:	6145                	addi	sp,sp,48
  9e:	8082                	ret
                    if((value % prime) != 0) write(sub_fd[1], &value, sizeof(value));
  a0:	4611                	li	a2,4
  a2:	fd040593          	addi	a1,s0,-48
  a6:	fdc42503          	lw	a0,-36(s0)
  aa:	00000097          	auipc	ra,0x0
  ae:	3a8080e7          	jalr	936(ra) # 452 <write>
            }while(read(input_fd[0], &value, sizeof(value)));
  b2:	4611                	li	a2,4
  b4:	fd040593          	addi	a1,s0,-48
  b8:	4088                	lw	a0,0(s1)
  ba:	00000097          	auipc	ra,0x0
  be:	390080e7          	jalr	912(ra) # 44a <read>
  c2:	c909                	beqz	a0,d4 <sub_process+0xd4>
                    if((value % prime) != 0) write(sub_fd[1], &value, sizeof(value));
  c4:	fd042783          	lw	a5,-48(s0)
  c8:	fd442703          	lw	a4,-44(s0)
  cc:	02e7e7bb          	remw	a5,a5,a4
  d0:	d3ed                	beqz	a5,b2 <sub_process+0xb2>
  d2:	b7f9                	j	a0 <sub_process+0xa0>
            close(sub_fd[1]);
  d4:	fdc42503          	lw	a0,-36(s0)
  d8:	00000097          	auipc	ra,0x0
  dc:	382080e7          	jalr	898(ra) # 45a <close>
            wait(0);// 等待递归的子问题完成
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	358080e7          	jalr	856(ra) # 43a <wait>
            exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	346080e7          	jalr	838(ra) # 432 <exit>
            printf("fork error!!!\n");
  f4:	00001517          	auipc	a0,0x1
  f8:	86c50513          	addi	a0,a0,-1940 # 960 <malloc+0xf8>
  fc:	00000097          	auipc	ra,0x0
 100:	6ae080e7          	jalr	1710(ra) # 7aa <printf>
            exit(1);
 104:	4505                	li	a0,1
 106:	00000097          	auipc	ra,0x0
 10a:	32c080e7          	jalr	812(ra) # 432 <exit>

000000000000010e <main>:
{
 10e:	7179                	addi	sp,sp,-48
 110:	f406                	sd	ra,40(sp)
 112:	f022                	sd	s0,32(sp)
 114:	ec26                	sd	s1,24(sp)
 116:	1800                	addi	s0,sp,48
    pipe(parent_fd);
 118:	fd840513          	addi	a0,s0,-40
 11c:	00000097          	auipc	ra,0x0
 120:	326080e7          	jalr	806(ra) # 442 <pipe>
    pid = fork();
 124:	00000097          	auipc	ra,0x0
 128:	306080e7          	jalr	774(ra) # 42a <fork>
    if(pid == 0) // 子进程
 12c:	c125                	beqz	a0,18c <main+0x7e>
    else if(pid > 0) //父进程
 12e:	06a05a63          	blez	a0,1a2 <main+0x94>
        close(parent_fd[0]);
 132:	fd842503          	lw	a0,-40(s0)
 136:	00000097          	auipc	ra,0x0
 13a:	324080e7          	jalr	804(ra) # 45a <close>
        for(i = 2; i <= 35; i++)
 13e:	4789                	li	a5,2
 140:	fcf42a23          	sw	a5,-44(s0)
 144:	02300493          	li	s1,35
            write(parent_fd[1], &i, sizeof(int));
 148:	4611                	li	a2,4
 14a:	fd440593          	addi	a1,s0,-44
 14e:	fdc42503          	lw	a0,-36(s0)
 152:	00000097          	auipc	ra,0x0
 156:	300080e7          	jalr	768(ra) # 452 <write>
        for(i = 2; i <= 35; i++)
 15a:	fd442783          	lw	a5,-44(s0)
 15e:	2785                	addiw	a5,a5,1
 160:	0007871b          	sext.w	a4,a5
 164:	fcf42a23          	sw	a5,-44(s0)
 168:	fee4d0e3          	bge	s1,a4,148 <main+0x3a>
        close(parent_fd[1]);
 16c:	fdc42503          	lw	a0,-36(s0)
 170:	00000097          	auipc	ra,0x0
 174:	2ea080e7          	jalr	746(ra) # 45a <close>
        wait(0);
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	2c0080e7          	jalr	704(ra) # 43a <wait>
    exit(0);
 182:	4501                	li	a0,0
 184:	00000097          	auipc	ra,0x0
 188:	2ae080e7          	jalr	686(ra) # 432 <exit>
        sub_process(parent_fd);
 18c:	fd840513          	addi	a0,s0,-40
 190:	00000097          	auipc	ra,0x0
 194:	e70080e7          	jalr	-400(ra) # 0 <sub_process>
        exit(0);
 198:	4501                	li	a0,0
 19a:	00000097          	auipc	ra,0x0
 19e:	298080e7          	jalr	664(ra) # 432 <exit>
        printf("fork error!!!\n");
 1a2:	00000517          	auipc	a0,0x0
 1a6:	7be50513          	addi	a0,a0,1982 # 960 <malloc+0xf8>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	600080e7          	jalr	1536(ra) # 7aa <printf>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	27e080e7          	jalr	638(ra) # 432 <exit>

00000000000001bc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c2:	87aa                	mv	a5,a0
 1c4:	0585                	addi	a1,a1,1
 1c6:	0785                	addi	a5,a5,1
 1c8:	fff5c703          	lbu	a4,-1(a1)
 1cc:	fee78fa3          	sb	a4,-1(a5)
 1d0:	fb75                	bnez	a4,1c4 <strcpy+0x8>
    ;
  return os;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb91                	beqz	a5,1f6 <strcmp+0x1e>
 1e4:	0005c703          	lbu	a4,0(a1)
 1e8:	00f71763          	bne	a4,a5,1f6 <strcmp+0x1e>
    p++, q++;
 1ec:	0505                	addi	a0,a0,1
 1ee:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f0:	00054783          	lbu	a5,0(a0)
 1f4:	fbe5                	bnez	a5,1e4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f6:	0005c503          	lbu	a0,0(a1)
}
 1fa:	40a7853b          	subw	a0,a5,a0
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strlen>:

uint
strlen(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cf91                	beqz	a5,22a <strlen+0x26>
 210:	0505                	addi	a0,a0,1
 212:	87aa                	mv	a5,a0
 214:	4685                	li	a3,1
 216:	9e89                	subw	a3,a3,a0
 218:	00f6853b          	addw	a0,a3,a5
 21c:	0785                	addi	a5,a5,1
 21e:	fff7c703          	lbu	a4,-1(a5)
 222:	fb7d                	bnez	a4,218 <strlen+0x14>
    ;
  return n;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  for(n = 0; s[n]; n++)
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <strlen+0x20>

000000000000022e <memset>:

void*
memset(void *dst, int c, uint n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 234:	ce09                	beqz	a2,24e <memset+0x20>
 236:	87aa                	mv	a5,a0
 238:	fff6071b          	addiw	a4,a2,-1
 23c:	1702                	slli	a4,a4,0x20
 23e:	9301                	srli	a4,a4,0x20
 240:	0705                	addi	a4,a4,1
 242:	972a                	add	a4,a4,a0
    cdst[i] = c;
 244:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 248:	0785                	addi	a5,a5,1
 24a:	fee79de3          	bne	a5,a4,244 <memset+0x16>
  }
  return dst;
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret

0000000000000254 <strchr>:

char*
strchr(const char *s, char c)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
  for(; *s; s++)
 25a:	00054783          	lbu	a5,0(a0)
 25e:	cb99                	beqz	a5,274 <strchr+0x20>
    if(*s == c)
 260:	00f58763          	beq	a1,a5,26e <strchr+0x1a>
  for(; *s; s++)
 264:	0505                	addi	a0,a0,1
 266:	00054783          	lbu	a5,0(a0)
 26a:	fbfd                	bnez	a5,260 <strchr+0xc>
      return (char*)s;
  return 0;
 26c:	4501                	li	a0,0
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  return 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <strchr+0x1a>

0000000000000278 <gets>:

char*
gets(char *buf, int max)
{
 278:	711d                	addi	sp,sp,-96
 27a:	ec86                	sd	ra,88(sp)
 27c:	e8a2                	sd	s0,80(sp)
 27e:	e4a6                	sd	s1,72(sp)
 280:	e0ca                	sd	s2,64(sp)
 282:	fc4e                	sd	s3,56(sp)
 284:	f852                	sd	s4,48(sp)
 286:	f456                	sd	s5,40(sp)
 288:	f05a                	sd	s6,32(sp)
 28a:	ec5e                	sd	s7,24(sp)
 28c:	1080                	addi	s0,sp,96
 28e:	8baa                	mv	s7,a0
 290:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 292:	892a                	mv	s2,a0
 294:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 296:	4aa9                	li	s5,10
 298:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 29a:	89a6                	mv	s3,s1
 29c:	2485                	addiw	s1,s1,1
 29e:	0344d863          	bge	s1,s4,2ce <gets+0x56>
    cc = read(0, &c, 1);
 2a2:	4605                	li	a2,1
 2a4:	faf40593          	addi	a1,s0,-81
 2a8:	4501                	li	a0,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	1a0080e7          	jalr	416(ra) # 44a <read>
    if(cc < 1)
 2b2:	00a05e63          	blez	a0,2ce <gets+0x56>
    buf[i++] = c;
 2b6:	faf44783          	lbu	a5,-81(s0)
 2ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2be:	01578763          	beq	a5,s5,2cc <gets+0x54>
 2c2:	0905                	addi	s2,s2,1
 2c4:	fd679be3          	bne	a5,s6,29a <gets+0x22>
  for(i=0; i+1 < max; ){
 2c8:	89a6                	mv	s3,s1
 2ca:	a011                	j	2ce <gets+0x56>
 2cc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ce:	99de                	add	s3,s3,s7
 2d0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d4:	855e                	mv	a0,s7
 2d6:	60e6                	ld	ra,88(sp)
 2d8:	6446                	ld	s0,80(sp)
 2da:	64a6                	ld	s1,72(sp)
 2dc:	6906                	ld	s2,64(sp)
 2de:	79e2                	ld	s3,56(sp)
 2e0:	7a42                	ld	s4,48(sp)
 2e2:	7aa2                	ld	s5,40(sp)
 2e4:	7b02                	ld	s6,32(sp)
 2e6:	6be2                	ld	s7,24(sp)
 2e8:	6125                	addi	sp,sp,96
 2ea:	8082                	ret

00000000000002ec <stat>:

int
stat(const char *n, struct stat *st)
{
 2ec:	1101                	addi	sp,sp,-32
 2ee:	ec06                	sd	ra,24(sp)
 2f0:	e822                	sd	s0,16(sp)
 2f2:	e426                	sd	s1,8(sp)
 2f4:	e04a                	sd	s2,0(sp)
 2f6:	1000                	addi	s0,sp,32
 2f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fa:	4581                	li	a1,0
 2fc:	00000097          	auipc	ra,0x0
 300:	176080e7          	jalr	374(ra) # 472 <open>
  if(fd < 0)
 304:	02054563          	bltz	a0,32e <stat+0x42>
 308:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 30a:	85ca                	mv	a1,s2
 30c:	00000097          	auipc	ra,0x0
 310:	17e080e7          	jalr	382(ra) # 48a <fstat>
 314:	892a                	mv	s2,a0
  close(fd);
 316:	8526                	mv	a0,s1
 318:	00000097          	auipc	ra,0x0
 31c:	142080e7          	jalr	322(ra) # 45a <close>
  return r;
}
 320:	854a                	mv	a0,s2
 322:	60e2                	ld	ra,24(sp)
 324:	6442                	ld	s0,16(sp)
 326:	64a2                	ld	s1,8(sp)
 328:	6902                	ld	s2,0(sp)
 32a:	6105                	addi	sp,sp,32
 32c:	8082                	ret
    return -1;
 32e:	597d                	li	s2,-1
 330:	bfc5                	j	320 <stat+0x34>

0000000000000332 <atoi>:

int
atoi(const char *s)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 338:	00054603          	lbu	a2,0(a0)
 33c:	fd06079b          	addiw	a5,a2,-48
 340:	0ff7f793          	andi	a5,a5,255
 344:	4725                	li	a4,9
 346:	02f76963          	bltu	a4,a5,378 <atoi+0x46>
 34a:	86aa                	mv	a3,a0
  n = 0;
 34c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 34e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 350:	0685                	addi	a3,a3,1
 352:	0025179b          	slliw	a5,a0,0x2
 356:	9fa9                	addw	a5,a5,a0
 358:	0017979b          	slliw	a5,a5,0x1
 35c:	9fb1                	addw	a5,a5,a2
 35e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 362:	0006c603          	lbu	a2,0(a3)
 366:	fd06071b          	addiw	a4,a2,-48
 36a:	0ff77713          	andi	a4,a4,255
 36e:	fee5f1e3          	bgeu	a1,a4,350 <atoi+0x1e>
  return n;
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  n = 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <atoi+0x40>

000000000000037c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 382:	02b57663          	bgeu	a0,a1,3ae <memmove+0x32>
    while(n-- > 0)
 386:	02c05163          	blez	a2,3a8 <memmove+0x2c>
 38a:	fff6079b          	addiw	a5,a2,-1
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	0785                	addi	a5,a5,1
 394:	97aa                	add	a5,a5,a0
  dst = vdst;
 396:	872a                	mv	a4,a0
      *dst++ = *src++;
 398:	0585                	addi	a1,a1,1
 39a:	0705                	addi	a4,a4,1
 39c:	fff5c683          	lbu	a3,-1(a1)
 3a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a4:	fee79ae3          	bne	a5,a4,398 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
    dst += n;
 3ae:	00c50733          	add	a4,a0,a2
    src += n;
 3b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b4:	fec05ae3          	blez	a2,3a8 <memmove+0x2c>
 3b8:	fff6079b          	addiw	a5,a2,-1
 3bc:	1782                	slli	a5,a5,0x20
 3be:	9381                	srli	a5,a5,0x20
 3c0:	fff7c793          	not	a5,a5
 3c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c6:	15fd                	addi	a1,a1,-1
 3c8:	177d                	addi	a4,a4,-1
 3ca:	0005c683          	lbu	a3,0(a1)
 3ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d2:	fee79ae3          	bne	a5,a4,3c6 <memmove+0x4a>
 3d6:	bfc9                	j	3a8 <memmove+0x2c>

00000000000003d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3de:	ca05                	beqz	a2,40e <memcmp+0x36>
 3e0:	fff6069b          	addiw	a3,a2,-1
 3e4:	1682                	slli	a3,a3,0x20
 3e6:	9281                	srli	a3,a3,0x20
 3e8:	0685                	addi	a3,a3,1
 3ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ec:	00054783          	lbu	a5,0(a0)
 3f0:	0005c703          	lbu	a4,0(a1)
 3f4:	00e79863          	bne	a5,a4,404 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3f8:	0505                	addi	a0,a0,1
    p2++;
 3fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3fc:	fed518e3          	bne	a0,a3,3ec <memcmp+0x14>
  }
  return 0;
 400:	4501                	li	a0,0
 402:	a019                	j	408 <memcmp+0x30>
      return *p1 - *p2;
 404:	40e7853b          	subw	a0,a5,a4
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret
  return 0;
 40e:	4501                	li	a0,0
 410:	bfe5                	j	408 <memcmp+0x30>

0000000000000412 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 412:	1141                	addi	sp,sp,-16
 414:	e406                	sd	ra,8(sp)
 416:	e022                	sd	s0,0(sp)
 418:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 41a:	00000097          	auipc	ra,0x0
 41e:	f62080e7          	jalr	-158(ra) # 37c <memmove>
}
 422:	60a2                	ld	ra,8(sp)
 424:	6402                	ld	s0,0(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret

000000000000042a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 42a:	4885                	li	a7,1
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exit>:
.global exit
exit:
 li a7, SYS_exit
 432:	4889                	li	a7,2
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <wait>:
.global wait
wait:
 li a7, SYS_wait
 43a:	488d                	li	a7,3
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 442:	4891                	li	a7,4
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <read>:
.global read
read:
 li a7, SYS_read
 44a:	4895                	li	a7,5
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <write>:
.global write
write:
 li a7, SYS_write
 452:	48c1                	li	a7,16
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <close>:
.global close
close:
 li a7, SYS_close
 45a:	48d5                	li	a7,21
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <kill>:
.global kill
kill:
 li a7, SYS_kill
 462:	4899                	li	a7,6
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <exec>:
.global exec
exec:
 li a7, SYS_exec
 46a:	489d                	li	a7,7
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <open>:
.global open
open:
 li a7, SYS_open
 472:	48bd                	li	a7,15
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 47a:	48c5                	li	a7,17
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 482:	48c9                	li	a7,18
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 48a:	48a1                	li	a7,8
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <link>:
.global link
link:
 li a7, SYS_link
 492:	48cd                	li	a7,19
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 49a:	48d1                	li	a7,20
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a2:	48a5                	li	a7,9
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 4aa:	48a9                	li	a7,10
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b2:	48ad                	li	a7,11
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ba:	48b1                	li	a7,12
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c2:	48b5                	li	a7,13
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ca:	48b9                	li	a7,14
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d2:	1101                	addi	sp,sp,-32
 4d4:	ec06                	sd	ra,24(sp)
 4d6:	e822                	sd	s0,16(sp)
 4d8:	1000                	addi	s0,sp,32
 4da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4de:	4605                	li	a2,1
 4e0:	fef40593          	addi	a1,s0,-17
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f6e080e7          	jalr	-146(ra) # 452 <write>
}
 4ec:	60e2                	ld	ra,24(sp)
 4ee:	6442                	ld	s0,16(sp)
 4f0:	6105                	addi	sp,sp,32
 4f2:	8082                	ret

00000000000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	7139                	addi	sp,sp,-64
 4f6:	fc06                	sd	ra,56(sp)
 4f8:	f822                	sd	s0,48(sp)
 4fa:	f426                	sd	s1,40(sp)
 4fc:	f04a                	sd	s2,32(sp)
 4fe:	ec4e                	sd	s3,24(sp)
 500:	0080                	addi	s0,sp,64
 502:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 504:	c299                	beqz	a3,50a <printint+0x16>
 506:	0805c863          	bltz	a1,596 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50a:	2581                	sext.w	a1,a1
  neg = 0;
 50c:	4881                	li	a7,0
 50e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 512:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 514:	2601                	sext.w	a2,a2
 516:	00000517          	auipc	a0,0x0
 51a:	46250513          	addi	a0,a0,1122 # 978 <digits>
 51e:	883a                	mv	a6,a4
 520:	2705                	addiw	a4,a4,1
 522:	02c5f7bb          	remuw	a5,a1,a2
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	97aa                	add	a5,a5,a0
 52c:	0007c783          	lbu	a5,0(a5)
 530:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 534:	0005879b          	sext.w	a5,a1
 538:	02c5d5bb          	divuw	a1,a1,a2
 53c:	0685                	addi	a3,a3,1
 53e:	fec7f0e3          	bgeu	a5,a2,51e <printint+0x2a>
  if(neg)
 542:	00088b63          	beqz	a7,558 <printint+0x64>
    buf[i++] = '-';
 546:	fd040793          	addi	a5,s0,-48
 54a:	973e                	add	a4,a4,a5
 54c:	02d00793          	li	a5,45
 550:	fef70823          	sb	a5,-16(a4)
 554:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 558:	02e05863          	blez	a4,588 <printint+0x94>
 55c:	fc040793          	addi	a5,s0,-64
 560:	00e78933          	add	s2,a5,a4
 564:	fff78993          	addi	s3,a5,-1
 568:	99ba                	add	s3,s3,a4
 56a:	377d                	addiw	a4,a4,-1
 56c:	1702                	slli	a4,a4,0x20
 56e:	9301                	srli	a4,a4,0x20
 570:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 574:	fff94583          	lbu	a1,-1(s2)
 578:	8526                	mv	a0,s1
 57a:	00000097          	auipc	ra,0x0
 57e:	f58080e7          	jalr	-168(ra) # 4d2 <putc>
  while(--i >= 0)
 582:	197d                	addi	s2,s2,-1
 584:	ff3918e3          	bne	s2,s3,574 <printint+0x80>
}
 588:	70e2                	ld	ra,56(sp)
 58a:	7442                	ld	s0,48(sp)
 58c:	74a2                	ld	s1,40(sp)
 58e:	7902                	ld	s2,32(sp)
 590:	69e2                	ld	s3,24(sp)
 592:	6121                	addi	sp,sp,64
 594:	8082                	ret
    x = -xx;
 596:	40b005bb          	negw	a1,a1
    neg = 1;
 59a:	4885                	li	a7,1
    x = -xx;
 59c:	bf8d                	j	50e <printint+0x1a>

000000000000059e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59e:	7119                	addi	sp,sp,-128
 5a0:	fc86                	sd	ra,120(sp)
 5a2:	f8a2                	sd	s0,112(sp)
 5a4:	f4a6                	sd	s1,104(sp)
 5a6:	f0ca                	sd	s2,96(sp)
 5a8:	ecce                	sd	s3,88(sp)
 5aa:	e8d2                	sd	s4,80(sp)
 5ac:	e4d6                	sd	s5,72(sp)
 5ae:	e0da                	sd	s6,64(sp)
 5b0:	fc5e                	sd	s7,56(sp)
 5b2:	f862                	sd	s8,48(sp)
 5b4:	f466                	sd	s9,40(sp)
 5b6:	f06a                	sd	s10,32(sp)
 5b8:	ec6e                	sd	s11,24(sp)
 5ba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5bc:	0005c903          	lbu	s2,0(a1)
 5c0:	18090f63          	beqz	s2,75e <vprintf+0x1c0>
 5c4:	8aaa                	mv	s5,a0
 5c6:	8b32                	mv	s6,a2
 5c8:	00158493          	addi	s1,a1,1
  state = 0;
 5cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ce:	02500a13          	li	s4,37
      if(c == 'd'){
 5d2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5d6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5da:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5de:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e2:	00000b97          	auipc	s7,0x0
 5e6:	396b8b93          	addi	s7,s7,918 # 978 <digits>
 5ea:	a839                	j	608 <vprintf+0x6a>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	ee2080e7          	jalr	-286(ra) # 4d2 <putc>
 5f8:	a019                	j	5fe <vprintf+0x60>
    } else if(state == '%'){
 5fa:	01498f63          	beq	s3,s4,618 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5fe:	0485                	addi	s1,s1,1
 600:	fff4c903          	lbu	s2,-1(s1)
 604:	14090d63          	beqz	s2,75e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 608:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60c:	fe0997e3          	bnez	s3,5fa <vprintf+0x5c>
      if(c == '%'){
 610:	fd479ee3          	bne	a5,s4,5ec <vprintf+0x4e>
        state = '%';
 614:	89be                	mv	s3,a5
 616:	b7e5                	j	5fe <vprintf+0x60>
      if(c == 'd'){
 618:	05878063          	beq	a5,s8,658 <vprintf+0xba>
      } else if(c == 'l') {
 61c:	05978c63          	beq	a5,s9,674 <vprintf+0xd6>
      } else if(c == 'x') {
 620:	07a78863          	beq	a5,s10,690 <vprintf+0xf2>
      } else if(c == 'p') {
 624:	09b78463          	beq	a5,s11,6ac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 628:	07300713          	li	a4,115
 62c:	0ce78663          	beq	a5,a4,6f8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 630:	06300713          	li	a4,99
 634:	0ee78e63          	beq	a5,a4,730 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 638:	11478863          	beq	a5,s4,748 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63c:	85d2                	mv	a1,s4
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e92080e7          	jalr	-366(ra) # 4d2 <putc>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e86080e7          	jalr	-378(ra) # 4d2 <putc>
      }
      state = 0;
 654:	4981                	li	s3,0
 656:	b765                	j	5fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 658:	008b0913          	addi	s2,s6,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000b2583          	lw	a1,0(s6)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e8e080e7          	jalr	-370(ra) # 4f4 <printint>
 66e:	8b4a                	mv	s6,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b771                	j	5fe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b0913          	addi	s2,s6,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000b2583          	lw	a1,0(s6)
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e72080e7          	jalr	-398(ra) # 4f4 <printint>
 68a:	8b4a                	mv	s6,s2
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bf85                	j	5fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 690:	008b0913          	addi	s2,s6,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000b2583          	lw	a1,0(s6)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e56080e7          	jalr	-426(ra) # 4f4 <printint>
 6a6:	8b4a                	mv	s6,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bf91                	j	5fe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b0793          	addi	a5,s6,8
 6b0:	f8f43423          	sd	a5,-120(s0)
 6b4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6b8:	03000593          	li	a1,48
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e14080e7          	jalr	-492(ra) # 4d2 <putc>
  putc(fd, 'x');
 6c6:	85ea                	mv	a1,s10
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e08080e7          	jalr	-504(ra) # 4d2 <putc>
 6d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d4:	03c9d793          	srli	a5,s3,0x3c
 6d8:	97de                	add	a5,a5,s7
 6da:	0007c583          	lbu	a1,0(a5)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	df2080e7          	jalr	-526(ra) # 4d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e8:	0992                	slli	s3,s3,0x4
 6ea:	397d                	addiw	s2,s2,-1
 6ec:	fe0914e3          	bnez	s2,6d4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b721                	j	5fe <vprintf+0x60>
        s = va_arg(ap, char*);
 6f8:	008b0993          	addi	s3,s6,8
 6fc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 700:	02090163          	beqz	s2,722 <vprintf+0x184>
        while(*s != 0){
 704:	00094583          	lbu	a1,0(s2)
 708:	c9a1                	beqz	a1,758 <vprintf+0x1ba>
          putc(fd, *s);
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	dc6080e7          	jalr	-570(ra) # 4d2 <putc>
          s++;
 714:	0905                	addi	s2,s2,1
        while(*s != 0){
 716:	00094583          	lbu	a1,0(s2)
 71a:	f9e5                	bnez	a1,70a <vprintf+0x16c>
        s = va_arg(ap, char*);
 71c:	8b4e                	mv	s6,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	bdf9                	j	5fe <vprintf+0x60>
          s = "(null)";
 722:	00000917          	auipc	s2,0x0
 726:	24e90913          	addi	s2,s2,590 # 970 <malloc+0x108>
        while(*s != 0){
 72a:	02800593          	li	a1,40
 72e:	bff1                	j	70a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 730:	008b0913          	addi	s2,s6,8
 734:	000b4583          	lbu	a1,0(s6)
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	d98080e7          	jalr	-616(ra) # 4d2 <putc>
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bd65                	j	5fe <vprintf+0x60>
        putc(fd, c);
 748:	85d2                	mv	a1,s4
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	d86080e7          	jalr	-634(ra) # 4d2 <putc>
      state = 0;
 754:	4981                	li	s3,0
 756:	b565                	j	5fe <vprintf+0x60>
        s = va_arg(ap, char*);
 758:	8b4e                	mv	s6,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b54d                	j	5fe <vprintf+0x60>
    }
  }
}
 75e:	70e6                	ld	ra,120(sp)
 760:	7446                	ld	s0,112(sp)
 762:	74a6                	ld	s1,104(sp)
 764:	7906                	ld	s2,96(sp)
 766:	69e6                	ld	s3,88(sp)
 768:	6a46                	ld	s4,80(sp)
 76a:	6aa6                	ld	s5,72(sp)
 76c:	6b06                	ld	s6,64(sp)
 76e:	7be2                	ld	s7,56(sp)
 770:	7c42                	ld	s8,48(sp)
 772:	7ca2                	ld	s9,40(sp)
 774:	7d02                	ld	s10,32(sp)
 776:	6de2                	ld	s11,24(sp)
 778:	6109                	addi	sp,sp,128
 77a:	8082                	ret

000000000000077c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e010                	sd	a2,0(s0)
 786:	e414                	sd	a3,8(s0)
 788:	e818                	sd	a4,16(s0)
 78a:	ec1c                	sd	a5,24(s0)
 78c:	03043023          	sd	a6,32(s0)
 790:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 794:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 798:	8622                	mv	a2,s0
 79a:	00000097          	auipc	ra,0x0
 79e:	e04080e7          	jalr	-508(ra) # 59e <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6161                	addi	sp,sp,80
 7a8:	8082                	ret

00000000000007aa <printf>:

void
printf(const char *fmt, ...)
{
 7aa:	711d                	addi	sp,sp,-96
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e40c                	sd	a1,8(s0)
 7b4:	e810                	sd	a2,16(s0)
 7b6:	ec14                	sd	a3,24(s0)
 7b8:	f018                	sd	a4,32(s0)
 7ba:	f41c                	sd	a5,40(s0)
 7bc:	03043823          	sd	a6,48(s0)
 7c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	00840613          	addi	a2,s0,8
 7c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7cc:	85aa                	mv	a1,a0
 7ce:	4505                	li	a0,1
 7d0:	00000097          	auipc	ra,0x0
 7d4:	dce080e7          	jalr	-562(ra) # 59e <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e422                	sd	s0,8(sp)
 7e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	00000797          	auipc	a5,0x0
 7ee:	1a67b783          	ld	a5,422(a5) # 990 <freep>
 7f2:	a805                	j	822 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f4:	4618                	lw	a4,8(a2)
 7f6:	9db9                	addw	a1,a1,a4
 7f8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	6318                	ld	a4,0(a4)
 800:	fee53823          	sd	a4,-16(a0)
 804:	a091                	j	848 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 806:	ff852703          	lw	a4,-8(a0)
 80a:	9e39                	addw	a2,a2,a4
 80c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 80e:	ff053703          	ld	a4,-16(a0)
 812:	e398                	sd	a4,0(a5)
 814:	a099                	j	85a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	6398                	ld	a4,0(a5)
 818:	00e7e463          	bltu	a5,a4,820 <free+0x40>
 81c:	00e6ea63          	bltu	a3,a4,830 <free+0x50>
{
 820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	fed7fae3          	bgeu	a5,a3,816 <free+0x36>
 826:	6398                	ld	a4,0(a5)
 828:	00e6e463          	bltu	a3,a4,830 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	fee7eae3          	bltu	a5,a4,820 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059713          	slli	a4,a1,0x20
 83a:	9301                	srli	a4,a4,0x20
 83c:	0712                	slli	a4,a4,0x4
 83e:	9736                	add	a4,a4,a3
 840:	fae60ae3          	beq	a2,a4,7f4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 848:	4790                	lw	a2,8(a5)
 84a:	02061713          	slli	a4,a2,0x20
 84e:	9301                	srli	a4,a4,0x20
 850:	0712                	slli	a4,a4,0x4
 852:	973e                	add	a4,a4,a5
 854:	fae689e3          	beq	a3,a4,806 <free+0x26>
  } else
    p->s.ptr = bp;
 858:	e394                	sd	a3,0(a5)
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	12f73b23          	sd	a5,310(a4) # 990 <freep>
}
 862:	6422                	ld	s0,8(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	f04a                	sd	s2,32(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
 87a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87c:	02051493          	slli	s1,a0,0x20
 880:	9081                	srli	s1,s1,0x20
 882:	04bd                	addi	s1,s1,15
 884:	8091                	srli	s1,s1,0x4
 886:	0014899b          	addiw	s3,s1,1
 88a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88c:	00000517          	auipc	a0,0x0
 890:	10453503          	ld	a0,260(a0) # 990 <freep>
 894:	c515                	beqz	a0,8c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 898:	4798                	lw	a4,8(a5)
 89a:	02977f63          	bgeu	a4,s1,8d8 <malloc+0x70>
 89e:	8a4e                	mv	s4,s3
 8a0:	0009871b          	sext.w	a4,s3
 8a4:	6685                	lui	a3,0x1
 8a6:	00d77363          	bgeu	a4,a3,8ac <malloc+0x44>
 8aa:	6a05                	lui	s4,0x1
 8ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b4:	00000917          	auipc	s2,0x0
 8b8:	0dc90913          	addi	s2,s2,220 # 990 <freep>
  if(p == (char*)-1)
 8bc:	5afd                	li	s5,-1
 8be:	a88d                	j	930 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c0:	00000797          	auipc	a5,0x0
 8c4:	0d878793          	addi	a5,a5,216 # 998 <base>
 8c8:	00000717          	auipc	a4,0x0
 8cc:	0cf73423          	sd	a5,200(a4) # 990 <freep>
 8d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d6:	b7e1                	j	89e <malloc+0x36>
      if(p->s.size == nunits)
 8d8:	02e48b63          	beq	s1,a4,90e <malloc+0xa6>
        p->s.size -= nunits;
 8dc:	4137073b          	subw	a4,a4,s3
 8e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e2:	1702                	slli	a4,a4,0x20
 8e4:	9301                	srli	a4,a4,0x20
 8e6:	0712                	slli	a4,a4,0x4
 8e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	0aa73123          	sd	a0,162(a4) # 990 <freep>
      return (void*)(p + 1);
 8f6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fa:	70e2                	ld	ra,56(sp)
 8fc:	7442                	ld	s0,48(sp)
 8fe:	74a2                	ld	s1,40(sp)
 900:	7902                	ld	s2,32(sp)
 902:	69e2                	ld	s3,24(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	6121                	addi	sp,sp,64
 90c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 90e:	6398                	ld	a4,0(a5)
 910:	e118                	sd	a4,0(a0)
 912:	bff1                	j	8ee <malloc+0x86>
  hp->s.size = nu;
 914:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 918:	0541                	addi	a0,a0,16
 91a:	00000097          	auipc	ra,0x0
 91e:	ec6080e7          	jalr	-314(ra) # 7e0 <free>
  return freep;
 922:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 926:	d971                	beqz	a0,8fa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	fa9776e3          	bgeu	a4,s1,8d8 <malloc+0x70>
    if(p == freep)
 930:	00093703          	ld	a4,0(s2)
 934:	853e                	mv	a0,a5
 936:	fef719e3          	bne	a4,a5,928 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 93a:	8552                	mv	a0,s4
 93c:	00000097          	auipc	ra,0x0
 940:	b7e080e7          	jalr	-1154(ra) # 4ba <sbrk>
  if(p == (char*)-1)
 944:	fd5518e3          	bne	a0,s5,914 <malloc+0xac>
        return 0;
 948:	4501                	li	a0,0
 94a:	bf45                	j	8fa <malloc+0x92>
