
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <r_sp>:
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64
r_sp()
{
       0:	1101                	addi	sp,sp,-32
       2:	ec22                	sd	s0,24(sp)
       4:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
       6:	878a                	mv	a5,sp
       8:	fef43423          	sd	a5,-24(s0)
  return x;
       c:	fe843783          	ld	a5,-24(s0)
}
      10:	853e                	mv	a0,a5
      12:	6462                	ld	s0,24(sp)
      14:	6105                	addi	sp,sp,32
      16:	8082                	ret

0000000000000018 <copyin>:

// what if you pass ridiculous pointers to system calls
// that read user memory with copyin?
void
copyin(char *s)
{
      18:	715d                	addi	sp,sp,-80
      1a:	e486                	sd	ra,72(sp)
      1c:	e0a2                	sd	s0,64(sp)
      1e:	0880                	addi	s0,sp,80
      20:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
      24:	4785                	li	a5,1
      26:	07fe                	slli	a5,a5,0x1f
      28:	fcf43423          	sd	a5,-56(s0)
      2c:	57fd                	li	a5,-1
      2e:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
      32:	fe042623          	sw	zero,-20(s0)
      36:	aa79                	j	1d4 <copyin+0x1bc>
    uint64 addr = addrs[ai];
      38:	fec42783          	lw	a5,-20(s0)
      3c:	078e                	slli	a5,a5,0x3
      3e:	17c1                	addi	a5,a5,-16
      40:	97a2                	add	a5,a5,s0
      42:	fd87b783          	ld	a5,-40(a5)
      46:	fef43023          	sd	a5,-32(s0)

    int fd = open("copyin1", O_CREATE|O_WRONLY);
      4a:	20100593          	li	a1,513
      4e:	00008517          	auipc	a0,0x8
      52:	06250513          	addi	a0,a0,98 # 80b0 <malloc+0x142>
      56:	00008097          	auipc	ra,0x8
      5a:	83e080e7          	jalr	-1986(ra) # 7894 <open>
      5e:	87aa                	mv	a5,a0
      60:	fcf42e23          	sw	a5,-36(s0)
    if(fd < 0){
      64:	fdc42783          	lw	a5,-36(s0)
      68:	2781                	sext.w	a5,a5
      6a:	0007df63          	bgez	a5,88 <copyin+0x70>
      printf("open(copyin1) failed\n");
      6e:	00008517          	auipc	a0,0x8
      72:	04a50513          	addi	a0,a0,74 # 80b8 <malloc+0x14a>
      76:	00008097          	auipc	ra,0x8
      7a:	d06080e7          	jalr	-762(ra) # 7d7c <printf>
      exit(1);
      7e:	4505                	li	a0,1
      80:	00007097          	auipc	ra,0x7
      84:	7d4080e7          	jalr	2004(ra) # 7854 <exit>
    }
    int n = write(fd, (void*)addr, 8192);
      88:	fe043703          	ld	a4,-32(s0)
      8c:	fdc42783          	lw	a5,-36(s0)
      90:	6609                	lui	a2,0x2
      92:	85ba                	mv	a1,a4
      94:	853e                	mv	a0,a5
      96:	00007097          	auipc	ra,0x7
      9a:	7de080e7          	jalr	2014(ra) # 7874 <write>
      9e:	87aa                	mv	a5,a0
      a0:	fcf42c23          	sw	a5,-40(s0)
    if(n >= 0){
      a4:	fd842783          	lw	a5,-40(s0)
      a8:	2781                	sext.w	a5,a5
      aa:	0207c463          	bltz	a5,d2 <copyin+0xba>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
      ae:	fd842783          	lw	a5,-40(s0)
      b2:	863e                	mv	a2,a5
      b4:	fe043583          	ld	a1,-32(s0)
      b8:	00008517          	auipc	a0,0x8
      bc:	01850513          	addi	a0,a0,24 # 80d0 <malloc+0x162>
      c0:	00008097          	auipc	ra,0x8
      c4:	cbc080e7          	jalr	-836(ra) # 7d7c <printf>
      exit(1);
      c8:	4505                	li	a0,1
      ca:	00007097          	auipc	ra,0x7
      ce:	78a080e7          	jalr	1930(ra) # 7854 <exit>
    }
    close(fd);
      d2:	fdc42783          	lw	a5,-36(s0)
      d6:	853e                	mv	a0,a5
      d8:	00007097          	auipc	ra,0x7
      dc:	7a4080e7          	jalr	1956(ra) # 787c <close>
    unlink("copyin1");
      e0:	00008517          	auipc	a0,0x8
      e4:	fd050513          	addi	a0,a0,-48 # 80b0 <malloc+0x142>
      e8:	00007097          	auipc	ra,0x7
      ec:	7bc080e7          	jalr	1980(ra) # 78a4 <unlink>

    n = write(1, (char*)addr, 8192);
      f0:	fe043783          	ld	a5,-32(s0)
      f4:	6609                	lui	a2,0x2
      f6:	85be                	mv	a1,a5
      f8:	4505                	li	a0,1
      fa:	00007097          	auipc	ra,0x7
      fe:	77a080e7          	jalr	1914(ra) # 7874 <write>
     102:	87aa                	mv	a5,a0
     104:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     108:	fd842783          	lw	a5,-40(s0)
     10c:	2781                	sext.w	a5,a5
     10e:	02f05463          	blez	a5,136 <copyin+0x11e>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     112:	fd842783          	lw	a5,-40(s0)
     116:	863e                	mv	a2,a5
     118:	fe043583          	ld	a1,-32(s0)
     11c:	00008517          	auipc	a0,0x8
     120:	fe450513          	addi	a0,a0,-28 # 8100 <malloc+0x192>
     124:	00008097          	auipc	ra,0x8
     128:	c58080e7          	jalr	-936(ra) # 7d7c <printf>
      exit(1);
     12c:	4505                	li	a0,1
     12e:	00007097          	auipc	ra,0x7
     132:	726080e7          	jalr	1830(ra) # 7854 <exit>
    }

    int fds[2];
    if(pipe(fds) < 0){
     136:	fc040793          	addi	a5,s0,-64
     13a:	853e                	mv	a0,a5
     13c:	00007097          	auipc	ra,0x7
     140:	728080e7          	jalr	1832(ra) # 7864 <pipe>
     144:	87aa                	mv	a5,a0
     146:	0007df63          	bgez	a5,164 <copyin+0x14c>
      printf("pipe() failed\n");
     14a:	00008517          	auipc	a0,0x8
     14e:	fe650513          	addi	a0,a0,-26 # 8130 <malloc+0x1c2>
     152:	00008097          	auipc	ra,0x8
     156:	c2a080e7          	jalr	-982(ra) # 7d7c <printf>
      exit(1);
     15a:	4505                	li	a0,1
     15c:	00007097          	auipc	ra,0x7
     160:	6f8080e7          	jalr	1784(ra) # 7854 <exit>
    }
    n = write(fds[1], (char*)addr, 8192);
     164:	fc442783          	lw	a5,-60(s0)
     168:	fe043703          	ld	a4,-32(s0)
     16c:	6609                	lui	a2,0x2
     16e:	85ba                	mv	a1,a4
     170:	853e                	mv	a0,a5
     172:	00007097          	auipc	ra,0x7
     176:	702080e7          	jalr	1794(ra) # 7874 <write>
     17a:	87aa                	mv	a5,a0
     17c:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     180:	fd842783          	lw	a5,-40(s0)
     184:	2781                	sext.w	a5,a5
     186:	02f05463          	blez	a5,1ae <copyin+0x196>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     18a:	fd842783          	lw	a5,-40(s0)
     18e:	863e                	mv	a2,a5
     190:	fe043583          	ld	a1,-32(s0)
     194:	00008517          	auipc	a0,0x8
     198:	fac50513          	addi	a0,a0,-84 # 8140 <malloc+0x1d2>
     19c:	00008097          	auipc	ra,0x8
     1a0:	be0080e7          	jalr	-1056(ra) # 7d7c <printf>
      exit(1);
     1a4:	4505                	li	a0,1
     1a6:	00007097          	auipc	ra,0x7
     1aa:	6ae080e7          	jalr	1710(ra) # 7854 <exit>
    }
    close(fds[0]);
     1ae:	fc042783          	lw	a5,-64(s0)
     1b2:	853e                	mv	a0,a5
     1b4:	00007097          	auipc	ra,0x7
     1b8:	6c8080e7          	jalr	1736(ra) # 787c <close>
    close(fds[1]);
     1bc:	fc442783          	lw	a5,-60(s0)
     1c0:	853e                	mv	a0,a5
     1c2:	00007097          	auipc	ra,0x7
     1c6:	6ba080e7          	jalr	1722(ra) # 787c <close>
  for(int ai = 0; ai < 2; ai++){
     1ca:	fec42783          	lw	a5,-20(s0)
     1ce:	2785                	addiw	a5,a5,1
     1d0:	fef42623          	sw	a5,-20(s0)
     1d4:	fec42783          	lw	a5,-20(s0)
     1d8:	0007871b          	sext.w	a4,a5
     1dc:	4785                	li	a5,1
     1de:	e4e7dde3          	bge	a5,a4,38 <copyin+0x20>
  }
}
     1e2:	0001                	nop
     1e4:	0001                	nop
     1e6:	60a6                	ld	ra,72(sp)
     1e8:	6406                	ld	s0,64(sp)
     1ea:	6161                	addi	sp,sp,80
     1ec:	8082                	ret

00000000000001ee <copyout>:

// what if you pass ridiculous pointers to system calls
// that write user memory with copyout?
void
copyout(char *s)
{
     1ee:	715d                	addi	sp,sp,-80
     1f0:	e486                	sd	ra,72(sp)
     1f2:	e0a2                	sd	s0,64(sp)
     1f4:	0880                	addi	s0,sp,80
     1f6:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     1fa:	4785                	li	a5,1
     1fc:	07fe                	slli	a5,a5,0x1f
     1fe:	fcf43423          	sd	a5,-56(s0)
     202:	57fd                	li	a5,-1
     204:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
     208:	fe042623          	sw	zero,-20(s0)
     20c:	a271                	j	398 <copyout+0x1aa>
    uint64 addr = addrs[ai];
     20e:	fec42783          	lw	a5,-20(s0)
     212:	078e                	slli	a5,a5,0x3
     214:	17c1                	addi	a5,a5,-16
     216:	97a2                	add	a5,a5,s0
     218:	fd87b783          	ld	a5,-40(a5)
     21c:	fef43023          	sd	a5,-32(s0)

    int fd = open("README", 0);
     220:	4581                	li	a1,0
     222:	00008517          	auipc	a0,0x8
     226:	f4e50513          	addi	a0,a0,-178 # 8170 <malloc+0x202>
     22a:	00007097          	auipc	ra,0x7
     22e:	66a080e7          	jalr	1642(ra) # 7894 <open>
     232:	87aa                	mv	a5,a0
     234:	fcf42e23          	sw	a5,-36(s0)
    if(fd < 0){
     238:	fdc42783          	lw	a5,-36(s0)
     23c:	2781                	sext.w	a5,a5
     23e:	0007df63          	bgez	a5,25c <copyout+0x6e>
      printf("open(README) failed\n");
     242:	00008517          	auipc	a0,0x8
     246:	f3650513          	addi	a0,a0,-202 # 8178 <malloc+0x20a>
     24a:	00008097          	auipc	ra,0x8
     24e:	b32080e7          	jalr	-1230(ra) # 7d7c <printf>
      exit(1);
     252:	4505                	li	a0,1
     254:	00007097          	auipc	ra,0x7
     258:	600080e7          	jalr	1536(ra) # 7854 <exit>
    }
    int n = read(fd, (void*)addr, 8192);
     25c:	fe043703          	ld	a4,-32(s0)
     260:	fdc42783          	lw	a5,-36(s0)
     264:	6609                	lui	a2,0x2
     266:	85ba                	mv	a1,a4
     268:	853e                	mv	a0,a5
     26a:	00007097          	auipc	ra,0x7
     26e:	602080e7          	jalr	1538(ra) # 786c <read>
     272:	87aa                	mv	a5,a0
     274:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     278:	fd842783          	lw	a5,-40(s0)
     27c:	2781                	sext.w	a5,a5
     27e:	02f05463          	blez	a5,2a6 <copyout+0xb8>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     282:	fd842783          	lw	a5,-40(s0)
     286:	863e                	mv	a2,a5
     288:	fe043583          	ld	a1,-32(s0)
     28c:	00008517          	auipc	a0,0x8
     290:	f0450513          	addi	a0,a0,-252 # 8190 <malloc+0x222>
     294:	00008097          	auipc	ra,0x8
     298:	ae8080e7          	jalr	-1304(ra) # 7d7c <printf>
      exit(1);
     29c:	4505                	li	a0,1
     29e:	00007097          	auipc	ra,0x7
     2a2:	5b6080e7          	jalr	1462(ra) # 7854 <exit>
    }
    close(fd);
     2a6:	fdc42783          	lw	a5,-36(s0)
     2aa:	853e                	mv	a0,a5
     2ac:	00007097          	auipc	ra,0x7
     2b0:	5d0080e7          	jalr	1488(ra) # 787c <close>

    int fds[2];
    if(pipe(fds) < 0){
     2b4:	fc040793          	addi	a5,s0,-64
     2b8:	853e                	mv	a0,a5
     2ba:	00007097          	auipc	ra,0x7
     2be:	5aa080e7          	jalr	1450(ra) # 7864 <pipe>
     2c2:	87aa                	mv	a5,a0
     2c4:	0007df63          	bgez	a5,2e2 <copyout+0xf4>
      printf("pipe() failed\n");
     2c8:	00008517          	auipc	a0,0x8
     2cc:	e6850513          	addi	a0,a0,-408 # 8130 <malloc+0x1c2>
     2d0:	00008097          	auipc	ra,0x8
     2d4:	aac080e7          	jalr	-1364(ra) # 7d7c <printf>
      exit(1);
     2d8:	4505                	li	a0,1
     2da:	00007097          	auipc	ra,0x7
     2de:	57a080e7          	jalr	1402(ra) # 7854 <exit>
    }
    n = write(fds[1], "x", 1);
     2e2:	fc442783          	lw	a5,-60(s0)
     2e6:	4605                	li	a2,1
     2e8:	00008597          	auipc	a1,0x8
     2ec:	ed858593          	addi	a1,a1,-296 # 81c0 <malloc+0x252>
     2f0:	853e                	mv	a0,a5
     2f2:	00007097          	auipc	ra,0x7
     2f6:	582080e7          	jalr	1410(ra) # 7874 <write>
     2fa:	87aa                	mv	a5,a0
     2fc:	fcf42c23          	sw	a5,-40(s0)
    if(n != 1){
     300:	fd842783          	lw	a5,-40(s0)
     304:	0007871b          	sext.w	a4,a5
     308:	4785                	li	a5,1
     30a:	00f70f63          	beq	a4,a5,328 <copyout+0x13a>
      printf("pipe write failed\n");
     30e:	00008517          	auipc	a0,0x8
     312:	eba50513          	addi	a0,a0,-326 # 81c8 <malloc+0x25a>
     316:	00008097          	auipc	ra,0x8
     31a:	a66080e7          	jalr	-1434(ra) # 7d7c <printf>
      exit(1);
     31e:	4505                	li	a0,1
     320:	00007097          	auipc	ra,0x7
     324:	534080e7          	jalr	1332(ra) # 7854 <exit>
    }
    n = read(fds[0], (void*)addr, 8192);
     328:	fc042783          	lw	a5,-64(s0)
     32c:	fe043703          	ld	a4,-32(s0)
     330:	6609                	lui	a2,0x2
     332:	85ba                	mv	a1,a4
     334:	853e                	mv	a0,a5
     336:	00007097          	auipc	ra,0x7
     33a:	536080e7          	jalr	1334(ra) # 786c <read>
     33e:	87aa                	mv	a5,a0
     340:	fcf42c23          	sw	a5,-40(s0)
    if(n > 0){
     344:	fd842783          	lw	a5,-40(s0)
     348:	2781                	sext.w	a5,a5
     34a:	02f05463          	blez	a5,372 <copyout+0x184>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     34e:	fd842783          	lw	a5,-40(s0)
     352:	863e                	mv	a2,a5
     354:	fe043583          	ld	a1,-32(s0)
     358:	00008517          	auipc	a0,0x8
     35c:	e8850513          	addi	a0,a0,-376 # 81e0 <malloc+0x272>
     360:	00008097          	auipc	ra,0x8
     364:	a1c080e7          	jalr	-1508(ra) # 7d7c <printf>
      exit(1);
     368:	4505                	li	a0,1
     36a:	00007097          	auipc	ra,0x7
     36e:	4ea080e7          	jalr	1258(ra) # 7854 <exit>
    }
    close(fds[0]);
     372:	fc042783          	lw	a5,-64(s0)
     376:	853e                	mv	a0,a5
     378:	00007097          	auipc	ra,0x7
     37c:	504080e7          	jalr	1284(ra) # 787c <close>
    close(fds[1]);
     380:	fc442783          	lw	a5,-60(s0)
     384:	853e                	mv	a0,a5
     386:	00007097          	auipc	ra,0x7
     38a:	4f6080e7          	jalr	1270(ra) # 787c <close>
  for(int ai = 0; ai < 2; ai++){
     38e:	fec42783          	lw	a5,-20(s0)
     392:	2785                	addiw	a5,a5,1
     394:	fef42623          	sw	a5,-20(s0)
     398:	fec42783          	lw	a5,-20(s0)
     39c:	0007871b          	sext.w	a4,a5
     3a0:	4785                	li	a5,1
     3a2:	e6e7d6e3          	bge	a5,a4,20e <copyout+0x20>
  }
}
     3a6:	0001                	nop
     3a8:	0001                	nop
     3aa:	60a6                	ld	ra,72(sp)
     3ac:	6406                	ld	s0,64(sp)
     3ae:	6161                	addi	sp,sp,80
     3b0:	8082                	ret

00000000000003b2 <copyinstr1>:

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
     3b2:	715d                	addi	sp,sp,-80
     3b4:	e486                	sd	ra,72(sp)
     3b6:	e0a2                	sd	s0,64(sp)
     3b8:	0880                	addi	s0,sp,80
     3ba:	faa43c23          	sd	a0,-72(s0)
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     3be:	4785                	li	a5,1
     3c0:	07fe                	slli	a5,a5,0x1f
     3c2:	fcf43423          	sd	a5,-56(s0)
     3c6:	57fd                	li	a5,-1
     3c8:	fcf43823          	sd	a5,-48(s0)

  for(int ai = 0; ai < 2; ai++){
     3cc:	fe042623          	sw	zero,-20(s0)
     3d0:	a095                	j	434 <copyinstr1+0x82>
    uint64 addr = addrs[ai];
     3d2:	fec42783          	lw	a5,-20(s0)
     3d6:	078e                	slli	a5,a5,0x3
     3d8:	17c1                	addi	a5,a5,-16
     3da:	97a2                	add	a5,a5,s0
     3dc:	fd87b783          	ld	a5,-40(a5)
     3e0:	fef43023          	sd	a5,-32(s0)

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     3e4:	fe043783          	ld	a5,-32(s0)
     3e8:	20100593          	li	a1,513
     3ec:	853e                	mv	a0,a5
     3ee:	00007097          	auipc	ra,0x7
     3f2:	4a6080e7          	jalr	1190(ra) # 7894 <open>
     3f6:	87aa                	mv	a5,a0
     3f8:	fcf42e23          	sw	a5,-36(s0)
    if(fd >= 0){
     3fc:	fdc42783          	lw	a5,-36(s0)
     400:	2781                	sext.w	a5,a5
     402:	0207c463          	bltz	a5,42a <copyinstr1+0x78>
      printf("open(%p) returned %d, not -1\n", addr, fd);
     406:	fdc42783          	lw	a5,-36(s0)
     40a:	863e                	mv	a2,a5
     40c:	fe043583          	ld	a1,-32(s0)
     410:	00008517          	auipc	a0,0x8
     414:	e0050513          	addi	a0,a0,-512 # 8210 <malloc+0x2a2>
     418:	00008097          	auipc	ra,0x8
     41c:	964080e7          	jalr	-1692(ra) # 7d7c <printf>
      exit(1);
     420:	4505                	li	a0,1
     422:	00007097          	auipc	ra,0x7
     426:	432080e7          	jalr	1074(ra) # 7854 <exit>
  for(int ai = 0; ai < 2; ai++){
     42a:	fec42783          	lw	a5,-20(s0)
     42e:	2785                	addiw	a5,a5,1
     430:	fef42623          	sw	a5,-20(s0)
     434:	fec42783          	lw	a5,-20(s0)
     438:	0007871b          	sext.w	a4,a5
     43c:	4785                	li	a5,1
     43e:	f8e7dae3          	bge	a5,a4,3d2 <copyinstr1+0x20>
    }
  }
}
     442:	0001                	nop
     444:	0001                	nop
     446:	60a6                	ld	ra,72(sp)
     448:	6406                	ld	s0,64(sp)
     44a:	6161                	addi	sp,sp,80
     44c:	8082                	ret

000000000000044e <copyinstr2>:
// what if a string system call argument is exactly the size
// of the kernel buffer it is copied into, so that the null
// would fall just beyond the end of the kernel buffer?
void
copyinstr2(char *s)
{
     44e:	7151                	addi	sp,sp,-240
     450:	f586                	sd	ra,232(sp)
     452:	f1a2                	sd	s0,224(sp)
     454:	1980                	addi	s0,sp,240
     456:	f0a43c23          	sd	a0,-232(s0)
  char b[MAXPATH+1];

  for(int i = 0; i < MAXPATH; i++)
     45a:	fe042623          	sw	zero,-20(s0)
     45e:	a831                	j	47a <copyinstr2+0x2c>
    b[i] = 'x';
     460:	fec42783          	lw	a5,-20(s0)
     464:	17c1                	addi	a5,a5,-16
     466:	97a2                	add	a5,a5,s0
     468:	07800713          	li	a4,120
     46c:	f6e78423          	sb	a4,-152(a5)
  for(int i = 0; i < MAXPATH; i++)
     470:	fec42783          	lw	a5,-20(s0)
     474:	2785                	addiw	a5,a5,1
     476:	fef42623          	sw	a5,-20(s0)
     47a:	fec42783          	lw	a5,-20(s0)
     47e:	0007871b          	sext.w	a4,a5
     482:	07f00793          	li	a5,127
     486:	fce7dde3          	bge	a5,a4,460 <copyinstr2+0x12>
  b[MAXPATH] = '\0';
     48a:	fc040c23          	sb	zero,-40(s0)

  int ret = unlink(b);
     48e:	f5840793          	addi	a5,s0,-168
     492:	853e                	mv	a0,a5
     494:	00007097          	auipc	ra,0x7
     498:	410080e7          	jalr	1040(ra) # 78a4 <unlink>
     49c:	87aa                	mv	a5,a0
     49e:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     4a2:	fe442783          	lw	a5,-28(s0)
     4a6:	0007871b          	sext.w	a4,a5
     4aa:	57fd                	li	a5,-1
     4ac:	02f70563          	beq	a4,a5,4d6 <copyinstr2+0x88>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     4b0:	fe442703          	lw	a4,-28(s0)
     4b4:	f5840793          	addi	a5,s0,-168
     4b8:	863a                	mv	a2,a4
     4ba:	85be                	mv	a1,a5
     4bc:	00008517          	auipc	a0,0x8
     4c0:	d7450513          	addi	a0,a0,-652 # 8230 <malloc+0x2c2>
     4c4:	00008097          	auipc	ra,0x8
     4c8:	8b8080e7          	jalr	-1864(ra) # 7d7c <printf>
    exit(1);
     4cc:	4505                	li	a0,1
     4ce:	00007097          	auipc	ra,0x7
     4d2:	386080e7          	jalr	902(ra) # 7854 <exit>
  }

  int fd = open(b, O_CREATE | O_WRONLY);
     4d6:	f5840793          	addi	a5,s0,-168
     4da:	20100593          	li	a1,513
     4de:	853e                	mv	a0,a5
     4e0:	00007097          	auipc	ra,0x7
     4e4:	3b4080e7          	jalr	948(ra) # 7894 <open>
     4e8:	87aa                	mv	a5,a0
     4ea:	fef42023          	sw	a5,-32(s0)
  if(fd != -1){
     4ee:	fe042783          	lw	a5,-32(s0)
     4f2:	0007871b          	sext.w	a4,a5
     4f6:	57fd                	li	a5,-1
     4f8:	02f70563          	beq	a4,a5,522 <copyinstr2+0xd4>
    printf("open(%s) returned %d, not -1\n", b, fd);
     4fc:	fe042703          	lw	a4,-32(s0)
     500:	f5840793          	addi	a5,s0,-168
     504:	863a                	mv	a2,a4
     506:	85be                	mv	a1,a5
     508:	00008517          	auipc	a0,0x8
     50c:	d4850513          	addi	a0,a0,-696 # 8250 <malloc+0x2e2>
     510:	00008097          	auipc	ra,0x8
     514:	86c080e7          	jalr	-1940(ra) # 7d7c <printf>
    exit(1);
     518:	4505                	li	a0,1
     51a:	00007097          	auipc	ra,0x7
     51e:	33a080e7          	jalr	826(ra) # 7854 <exit>
  }

  ret = link(b, b);
     522:	f5840713          	addi	a4,s0,-168
     526:	f5840793          	addi	a5,s0,-168
     52a:	85ba                	mv	a1,a4
     52c:	853e                	mv	a0,a5
     52e:	00007097          	auipc	ra,0x7
     532:	386080e7          	jalr	902(ra) # 78b4 <link>
     536:	87aa                	mv	a5,a0
     538:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     53c:	fe442783          	lw	a5,-28(s0)
     540:	0007871b          	sext.w	a4,a5
     544:	57fd                	li	a5,-1
     546:	02f70763          	beq	a4,a5,574 <copyinstr2+0x126>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     54a:	fe442683          	lw	a3,-28(s0)
     54e:	f5840713          	addi	a4,s0,-168
     552:	f5840793          	addi	a5,s0,-168
     556:	863a                	mv	a2,a4
     558:	85be                	mv	a1,a5
     55a:	00008517          	auipc	a0,0x8
     55e:	d1650513          	addi	a0,a0,-746 # 8270 <malloc+0x302>
     562:	00008097          	auipc	ra,0x8
     566:	81a080e7          	jalr	-2022(ra) # 7d7c <printf>
    exit(1);
     56a:	4505                	li	a0,1
     56c:	00007097          	auipc	ra,0x7
     570:	2e8080e7          	jalr	744(ra) # 7854 <exit>
  }

  char *args[] = { "xx", 0 };
     574:	00008797          	auipc	a5,0x8
     578:	d2478793          	addi	a5,a5,-732 # 8298 <malloc+0x32a>
     57c:	f4f43423          	sd	a5,-184(s0)
     580:	f4043823          	sd	zero,-176(s0)
  ret = exec(b, args);
     584:	f4840713          	addi	a4,s0,-184
     588:	f5840793          	addi	a5,s0,-168
     58c:	85ba                	mv	a1,a4
     58e:	853e                	mv	a0,a5
     590:	00007097          	auipc	ra,0x7
     594:	2fc080e7          	jalr	764(ra) # 788c <exec>
     598:	87aa                	mv	a5,a0
     59a:	fef42223          	sw	a5,-28(s0)
  if(ret != -1){
     59e:	fe442783          	lw	a5,-28(s0)
     5a2:	0007871b          	sext.w	a4,a5
     5a6:	57fd                	li	a5,-1
     5a8:	02f70563          	beq	a4,a5,5d2 <copyinstr2+0x184>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     5ac:	fe042703          	lw	a4,-32(s0)
     5b0:	f5840793          	addi	a5,s0,-168
     5b4:	863a                	mv	a2,a4
     5b6:	85be                	mv	a1,a5
     5b8:	00008517          	auipc	a0,0x8
     5bc:	ce850513          	addi	a0,a0,-792 # 82a0 <malloc+0x332>
     5c0:	00007097          	auipc	ra,0x7
     5c4:	7bc080e7          	jalr	1980(ra) # 7d7c <printf>
    exit(1);
     5c8:	4505                	li	a0,1
     5ca:	00007097          	auipc	ra,0x7
     5ce:	28a080e7          	jalr	650(ra) # 7854 <exit>
  }

  int pid = fork();
     5d2:	00007097          	auipc	ra,0x7
     5d6:	27a080e7          	jalr	634(ra) # 784c <fork>
     5da:	87aa                	mv	a5,a0
     5dc:	fcf42e23          	sw	a5,-36(s0)
  if(pid < 0){
     5e0:	fdc42783          	lw	a5,-36(s0)
     5e4:	2781                	sext.w	a5,a5
     5e6:	0007df63          	bgez	a5,604 <copyinstr2+0x1b6>
    printf("fork failed\n");
     5ea:	00008517          	auipc	a0,0x8
     5ee:	cd650513          	addi	a0,a0,-810 # 82c0 <malloc+0x352>
     5f2:	00007097          	auipc	ra,0x7
     5f6:	78a080e7          	jalr	1930(ra) # 7d7c <printf>
    exit(1);
     5fa:	4505                	li	a0,1
     5fc:	00007097          	auipc	ra,0x7
     600:	258080e7          	jalr	600(ra) # 7854 <exit>
  }
  if(pid == 0){
     604:	fdc42783          	lw	a5,-36(s0)
     608:	2781                	sext.w	a5,a5
     60a:	efd5                	bnez	a5,6c6 <copyinstr2+0x278>
    static char big[PGSIZE+1];
    for(int i = 0; i < PGSIZE; i++)
     60c:	fe042423          	sw	zero,-24(s0)
     610:	a00d                	j	632 <copyinstr2+0x1e4>
      big[i] = 'x';
     612:	00011717          	auipc	a4,0x11
     616:	3de70713          	addi	a4,a4,990 # 119f0 <big.0>
     61a:	fe842783          	lw	a5,-24(s0)
     61e:	97ba                	add	a5,a5,a4
     620:	07800713          	li	a4,120
     624:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
     628:	fe842783          	lw	a5,-24(s0)
     62c:	2785                	addiw	a5,a5,1
     62e:	fef42423          	sw	a5,-24(s0)
     632:	fe842783          	lw	a5,-24(s0)
     636:	0007871b          	sext.w	a4,a5
     63a:	6785                	lui	a5,0x1
     63c:	fcf74be3          	blt	a4,a5,612 <copyinstr2+0x1c4>
    big[PGSIZE] = '\0';
     640:	00011717          	auipc	a4,0x11
     644:	3b070713          	addi	a4,a4,944 # 119f0 <big.0>
     648:	6785                	lui	a5,0x1
     64a:	97ba                	add	a5,a5,a4
     64c:	00078023          	sb	zero,0(a5) # 1000 <truncate3+0x1b2>
    char *args2[] = { big, big, big, 0 };
     650:	00008797          	auipc	a5,0x8
     654:	ce078793          	addi	a5,a5,-800 # 8330 <malloc+0x3c2>
     658:	6390                	ld	a2,0(a5)
     65a:	6794                	ld	a3,8(a5)
     65c:	6b98                	ld	a4,16(a5)
     65e:	6f9c                	ld	a5,24(a5)
     660:	f2c43023          	sd	a2,-224(s0)
     664:	f2d43423          	sd	a3,-216(s0)
     668:	f2e43823          	sd	a4,-208(s0)
     66c:	f2f43c23          	sd	a5,-200(s0)
    ret = exec("echo", args2);
     670:	f2040793          	addi	a5,s0,-224
     674:	85be                	mv	a1,a5
     676:	00008517          	auipc	a0,0x8
     67a:	c5a50513          	addi	a0,a0,-934 # 82d0 <malloc+0x362>
     67e:	00007097          	auipc	ra,0x7
     682:	20e080e7          	jalr	526(ra) # 788c <exec>
     686:	87aa                	mv	a5,a0
     688:	fef42223          	sw	a5,-28(s0)
    if(ret != -1){
     68c:	fe442783          	lw	a5,-28(s0)
     690:	0007871b          	sext.w	a4,a5
     694:	57fd                	li	a5,-1
     696:	02f70263          	beq	a4,a5,6ba <copyinstr2+0x26c>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
     69a:	fe042783          	lw	a5,-32(s0)
     69e:	85be                	mv	a1,a5
     6a0:	00008517          	auipc	a0,0x8
     6a4:	c3850513          	addi	a0,a0,-968 # 82d8 <malloc+0x36a>
     6a8:	00007097          	auipc	ra,0x7
     6ac:	6d4080e7          	jalr	1748(ra) # 7d7c <printf>
      exit(1);
     6b0:	4505                	li	a0,1
     6b2:	00007097          	auipc	ra,0x7
     6b6:	1a2080e7          	jalr	418(ra) # 7854 <exit>
    }
    exit(747); // OK
     6ba:	2eb00513          	li	a0,747
     6be:	00007097          	auipc	ra,0x7
     6c2:	196080e7          	jalr	406(ra) # 7854 <exit>
  }

  int st = 0;
     6c6:	f4042223          	sw	zero,-188(s0)
  wait(&st);
     6ca:	f4440793          	addi	a5,s0,-188
     6ce:	853e                	mv	a0,a5
     6d0:	00007097          	auipc	ra,0x7
     6d4:	18c080e7          	jalr	396(ra) # 785c <wait>
  if(st != 747){
     6d8:	f4442783          	lw	a5,-188(s0)
     6dc:	873e                	mv	a4,a5
     6de:	2eb00793          	li	a5,747
     6e2:	00f70f63          	beq	a4,a5,700 <copyinstr2+0x2b2>
    printf("exec(echo, BIG) succeeded, should have failed\n");
     6e6:	00008517          	auipc	a0,0x8
     6ea:	c1a50513          	addi	a0,a0,-998 # 8300 <malloc+0x392>
     6ee:	00007097          	auipc	ra,0x7
     6f2:	68e080e7          	jalr	1678(ra) # 7d7c <printf>
    exit(1);
     6f6:	4505                	li	a0,1
     6f8:	00007097          	auipc	ra,0x7
     6fc:	15c080e7          	jalr	348(ra) # 7854 <exit>
  }
}
     700:	0001                	nop
     702:	70ae                	ld	ra,232(sp)
     704:	740e                	ld	s0,224(sp)
     706:	616d                	addi	sp,sp,240
     708:	8082                	ret

000000000000070a <copyinstr3>:

// what if a string argument crosses over the end of last user page?
void
copyinstr3(char *s)
{
     70a:	715d                	addi	sp,sp,-80
     70c:	e486                	sd	ra,72(sp)
     70e:	e0a2                	sd	s0,64(sp)
     710:	0880                	addi	s0,sp,80
     712:	faa43c23          	sd	a0,-72(s0)
  sbrk(8192);
     716:	6509                	lui	a0,0x2
     718:	00007097          	auipc	ra,0x7
     71c:	1c4080e7          	jalr	452(ra) # 78dc <sbrk>
  uint64 top = (uint64) sbrk(0);
     720:	4501                	li	a0,0
     722:	00007097          	auipc	ra,0x7
     726:	1ba080e7          	jalr	442(ra) # 78dc <sbrk>
     72a:	87aa                	mv	a5,a0
     72c:	fef43423          	sd	a5,-24(s0)
  if((top % PGSIZE) != 0){
     730:	fe843703          	ld	a4,-24(s0)
     734:	6785                	lui	a5,0x1
     736:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     738:	8ff9                	and	a5,a5,a4
     73a:	c39d                	beqz	a5,760 <copyinstr3+0x56>
    sbrk(PGSIZE - (top % PGSIZE));
     73c:	fe843783          	ld	a5,-24(s0)
     740:	2781                	sext.w	a5,a5
     742:	873e                	mv	a4,a5
     744:	6785                	lui	a5,0x1
     746:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     748:	8ff9                	and	a5,a5,a4
     74a:	2781                	sext.w	a5,a5
     74c:	6705                	lui	a4,0x1
     74e:	40f707bb          	subw	a5,a4,a5
     752:	2781                	sext.w	a5,a5
     754:	2781                	sext.w	a5,a5
     756:	853e                	mv	a0,a5
     758:	00007097          	auipc	ra,0x7
     75c:	184080e7          	jalr	388(ra) # 78dc <sbrk>
  }
  top = (uint64) sbrk(0);
     760:	4501                	li	a0,0
     762:	00007097          	auipc	ra,0x7
     766:	17a080e7          	jalr	378(ra) # 78dc <sbrk>
     76a:	87aa                	mv	a5,a0
     76c:	fef43423          	sd	a5,-24(s0)
  if(top % PGSIZE){
     770:	fe843703          	ld	a4,-24(s0)
     774:	6785                	lui	a5,0x1
     776:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
     778:	8ff9                	and	a5,a5,a4
     77a:	cf91                	beqz	a5,796 <copyinstr3+0x8c>
    printf("oops\n");
     77c:	00008517          	auipc	a0,0x8
     780:	bd450513          	addi	a0,a0,-1068 # 8350 <malloc+0x3e2>
     784:	00007097          	auipc	ra,0x7
     788:	5f8080e7          	jalr	1528(ra) # 7d7c <printf>
    exit(1);
     78c:	4505                	li	a0,1
     78e:	00007097          	auipc	ra,0x7
     792:	0c6080e7          	jalr	198(ra) # 7854 <exit>
  }

  char *b = (char *) (top - 1);
     796:	fe843783          	ld	a5,-24(s0)
     79a:	17fd                	addi	a5,a5,-1
     79c:	fef43023          	sd	a5,-32(s0)
  *b = 'x';
     7a0:	fe043783          	ld	a5,-32(s0)
     7a4:	07800713          	li	a4,120
     7a8:	00e78023          	sb	a4,0(a5)

  int ret = unlink(b);
     7ac:	fe043503          	ld	a0,-32(s0)
     7b0:	00007097          	auipc	ra,0x7
     7b4:	0f4080e7          	jalr	244(ra) # 78a4 <unlink>
     7b8:	87aa                	mv	a5,a0
     7ba:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     7be:	fdc42783          	lw	a5,-36(s0)
     7c2:	0007871b          	sext.w	a4,a5
     7c6:	57fd                	li	a5,-1
     7c8:	02f70463          	beq	a4,a5,7f0 <copyinstr3+0xe6>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     7cc:	fdc42783          	lw	a5,-36(s0)
     7d0:	863e                	mv	a2,a5
     7d2:	fe043583          	ld	a1,-32(s0)
     7d6:	00008517          	auipc	a0,0x8
     7da:	a5a50513          	addi	a0,a0,-1446 # 8230 <malloc+0x2c2>
     7de:	00007097          	auipc	ra,0x7
     7e2:	59e080e7          	jalr	1438(ra) # 7d7c <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00007097          	auipc	ra,0x7
     7ec:	06c080e7          	jalr	108(ra) # 7854 <exit>
  }

  int fd = open(b, O_CREATE | O_WRONLY);
     7f0:	20100593          	li	a1,513
     7f4:	fe043503          	ld	a0,-32(s0)
     7f8:	00007097          	auipc	ra,0x7
     7fc:	09c080e7          	jalr	156(ra) # 7894 <open>
     800:	87aa                	mv	a5,a0
     802:	fcf42c23          	sw	a5,-40(s0)
  if(fd != -1){
     806:	fd842783          	lw	a5,-40(s0)
     80a:	0007871b          	sext.w	a4,a5
     80e:	57fd                	li	a5,-1
     810:	02f70463          	beq	a4,a5,838 <copyinstr3+0x12e>
    printf("open(%s) returned %d, not -1\n", b, fd);
     814:	fd842783          	lw	a5,-40(s0)
     818:	863e                	mv	a2,a5
     81a:	fe043583          	ld	a1,-32(s0)
     81e:	00008517          	auipc	a0,0x8
     822:	a3250513          	addi	a0,a0,-1486 # 8250 <malloc+0x2e2>
     826:	00007097          	auipc	ra,0x7
     82a:	556080e7          	jalr	1366(ra) # 7d7c <printf>
    exit(1);
     82e:	4505                	li	a0,1
     830:	00007097          	auipc	ra,0x7
     834:	024080e7          	jalr	36(ra) # 7854 <exit>
  }

  ret = link(b, b);
     838:	fe043583          	ld	a1,-32(s0)
     83c:	fe043503          	ld	a0,-32(s0)
     840:	00007097          	auipc	ra,0x7
     844:	074080e7          	jalr	116(ra) # 78b4 <link>
     848:	87aa                	mv	a5,a0
     84a:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     84e:	fdc42783          	lw	a5,-36(s0)
     852:	0007871b          	sext.w	a4,a5
     856:	57fd                	li	a5,-1
     858:	02f70663          	beq	a4,a5,884 <copyinstr3+0x17a>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     85c:	fdc42783          	lw	a5,-36(s0)
     860:	86be                	mv	a3,a5
     862:	fe043603          	ld	a2,-32(s0)
     866:	fe043583          	ld	a1,-32(s0)
     86a:	00008517          	auipc	a0,0x8
     86e:	a0650513          	addi	a0,a0,-1530 # 8270 <malloc+0x302>
     872:	00007097          	auipc	ra,0x7
     876:	50a080e7          	jalr	1290(ra) # 7d7c <printf>
    exit(1);
     87a:	4505                	li	a0,1
     87c:	00007097          	auipc	ra,0x7
     880:	fd8080e7          	jalr	-40(ra) # 7854 <exit>
  }

  char *args[] = { "xx", 0 };
     884:	00008797          	auipc	a5,0x8
     888:	a1478793          	addi	a5,a5,-1516 # 8298 <malloc+0x32a>
     88c:	fcf43423          	sd	a5,-56(s0)
     890:	fc043823          	sd	zero,-48(s0)
  ret = exec(b, args);
     894:	fc840793          	addi	a5,s0,-56
     898:	85be                	mv	a1,a5
     89a:	fe043503          	ld	a0,-32(s0)
     89e:	00007097          	auipc	ra,0x7
     8a2:	fee080e7          	jalr	-18(ra) # 788c <exec>
     8a6:	87aa                	mv	a5,a0
     8a8:	fcf42e23          	sw	a5,-36(s0)
  if(ret != -1){
     8ac:	fdc42783          	lw	a5,-36(s0)
     8b0:	0007871b          	sext.w	a4,a5
     8b4:	57fd                	li	a5,-1
     8b6:	02f70463          	beq	a4,a5,8de <copyinstr3+0x1d4>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     8ba:	fd842783          	lw	a5,-40(s0)
     8be:	863e                	mv	a2,a5
     8c0:	fe043583          	ld	a1,-32(s0)
     8c4:	00008517          	auipc	a0,0x8
     8c8:	9dc50513          	addi	a0,a0,-1572 # 82a0 <malloc+0x332>
     8cc:	00007097          	auipc	ra,0x7
     8d0:	4b0080e7          	jalr	1200(ra) # 7d7c <printf>
    exit(1);
     8d4:	4505                	li	a0,1
     8d6:	00007097          	auipc	ra,0x7
     8da:	f7e080e7          	jalr	-130(ra) # 7854 <exit>
  }
}
     8de:	0001                	nop
     8e0:	60a6                	ld	ra,72(sp)
     8e2:	6406                	ld	s0,64(sp)
     8e4:	6161                	addi	sp,sp,80
     8e6:	8082                	ret

00000000000008e8 <rwsbrk>:

// See if the kernel refuses to read/write user memory that the
// application doesn't have anymore, because it returned it.
void
rwsbrk()
{
     8e8:	1101                	addi	sp,sp,-32
     8ea:	ec06                	sd	ra,24(sp)
     8ec:	e822                	sd	s0,16(sp)
     8ee:	1000                	addi	s0,sp,32
  int fd, n;

  uint64 a = (uint64) sbrk(8192);
     8f0:	6509                	lui	a0,0x2
     8f2:	00007097          	auipc	ra,0x7
     8f6:	fea080e7          	jalr	-22(ra) # 78dc <sbrk>
     8fa:	87aa                	mv	a5,a0
     8fc:	fef43423          	sd	a5,-24(s0)

  if(a == 0xffffffffffffffffLL) {
     900:	fe843703          	ld	a4,-24(s0)
     904:	57fd                	li	a5,-1
     906:	00f71f63          	bne	a4,a5,924 <rwsbrk+0x3c>
    printf("sbrk(rwsbrk) failed\n");
     90a:	00008517          	auipc	a0,0x8
     90e:	a4e50513          	addi	a0,a0,-1458 # 8358 <malloc+0x3ea>
     912:	00007097          	auipc	ra,0x7
     916:	46a080e7          	jalr	1130(ra) # 7d7c <printf>
    exit(1);
     91a:	4505                	li	a0,1
     91c:	00007097          	auipc	ra,0x7
     920:	f38080e7          	jalr	-200(ra) # 7854 <exit>
  }

  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
     924:	7579                	lui	a0,0xffffe
     926:	00007097          	auipc	ra,0x7
     92a:	fb6080e7          	jalr	-74(ra) # 78dc <sbrk>
     92e:	872a                	mv	a4,a0
     930:	57fd                	li	a5,-1
     932:	00f71f63          	bne	a4,a5,950 <rwsbrk+0x68>
    printf("sbrk(rwsbrk) shrink failed\n");
     936:	00008517          	auipc	a0,0x8
     93a:	a3a50513          	addi	a0,a0,-1478 # 8370 <malloc+0x402>
     93e:	00007097          	auipc	ra,0x7
     942:	43e080e7          	jalr	1086(ra) # 7d7c <printf>
    exit(1);
     946:	4505                	li	a0,1
     948:	00007097          	auipc	ra,0x7
     94c:	f0c080e7          	jalr	-244(ra) # 7854 <exit>
  }

  fd = open("rwsbrk", O_CREATE|O_WRONLY);
     950:	20100593          	li	a1,513
     954:	00008517          	auipc	a0,0x8
     958:	a3c50513          	addi	a0,a0,-1476 # 8390 <malloc+0x422>
     95c:	00007097          	auipc	ra,0x7
     960:	f38080e7          	jalr	-200(ra) # 7894 <open>
     964:	87aa                	mv	a5,a0
     966:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
     96a:	fe442783          	lw	a5,-28(s0)
     96e:	2781                	sext.w	a5,a5
     970:	0007df63          	bgez	a5,98e <rwsbrk+0xa6>
    printf("open(rwsbrk) failed\n");
     974:	00008517          	auipc	a0,0x8
     978:	a2450513          	addi	a0,a0,-1500 # 8398 <malloc+0x42a>
     97c:	00007097          	auipc	ra,0x7
     980:	400080e7          	jalr	1024(ra) # 7d7c <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00007097          	auipc	ra,0x7
     98a:	ece080e7          	jalr	-306(ra) # 7854 <exit>
  }
  n = write(fd, (void*)(a+4096), 1024);
     98e:	fe843703          	ld	a4,-24(s0)
     992:	6785                	lui	a5,0x1
     994:	97ba                	add	a5,a5,a4
     996:	873e                	mv	a4,a5
     998:	fe442783          	lw	a5,-28(s0)
     99c:	40000613          	li	a2,1024
     9a0:	85ba                	mv	a1,a4
     9a2:	853e                	mv	a0,a5
     9a4:	00007097          	auipc	ra,0x7
     9a8:	ed0080e7          	jalr	-304(ra) # 7874 <write>
     9ac:	87aa                	mv	a5,a0
     9ae:	fef42023          	sw	a5,-32(s0)
  if(n >= 0){
     9b2:	fe042783          	lw	a5,-32(s0)
     9b6:	2781                	sext.w	a5,a5
     9b8:	0207c763          	bltz	a5,9e6 <rwsbrk+0xfe>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
     9bc:	fe843703          	ld	a4,-24(s0)
     9c0:	6785                	lui	a5,0x1
     9c2:	97ba                	add	a5,a5,a4
     9c4:	fe042703          	lw	a4,-32(s0)
     9c8:	863a                	mv	a2,a4
     9ca:	85be                	mv	a1,a5
     9cc:	00008517          	auipc	a0,0x8
     9d0:	9e450513          	addi	a0,a0,-1564 # 83b0 <malloc+0x442>
     9d4:	00007097          	auipc	ra,0x7
     9d8:	3a8080e7          	jalr	936(ra) # 7d7c <printf>
    exit(1);
     9dc:	4505                	li	a0,1
     9de:	00007097          	auipc	ra,0x7
     9e2:	e76080e7          	jalr	-394(ra) # 7854 <exit>
  }
  close(fd);
     9e6:	fe442783          	lw	a5,-28(s0)
     9ea:	853e                	mv	a0,a5
     9ec:	00007097          	auipc	ra,0x7
     9f0:	e90080e7          	jalr	-368(ra) # 787c <close>
  unlink("rwsbrk");
     9f4:	00008517          	auipc	a0,0x8
     9f8:	99c50513          	addi	a0,a0,-1636 # 8390 <malloc+0x422>
     9fc:	00007097          	auipc	ra,0x7
     a00:	ea8080e7          	jalr	-344(ra) # 78a4 <unlink>

  fd = open("README", O_RDONLY);
     a04:	4581                	li	a1,0
     a06:	00007517          	auipc	a0,0x7
     a0a:	76a50513          	addi	a0,a0,1898 # 8170 <malloc+0x202>
     a0e:	00007097          	auipc	ra,0x7
     a12:	e86080e7          	jalr	-378(ra) # 7894 <open>
     a16:	87aa                	mv	a5,a0
     a18:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
     a1c:	fe442783          	lw	a5,-28(s0)
     a20:	2781                	sext.w	a5,a5
     a22:	0007df63          	bgez	a5,a40 <rwsbrk+0x158>
    printf("open(rwsbrk) failed\n");
     a26:	00008517          	auipc	a0,0x8
     a2a:	97250513          	addi	a0,a0,-1678 # 8398 <malloc+0x42a>
     a2e:	00007097          	auipc	ra,0x7
     a32:	34e080e7          	jalr	846(ra) # 7d7c <printf>
    exit(1);
     a36:	4505                	li	a0,1
     a38:	00007097          	auipc	ra,0x7
     a3c:	e1c080e7          	jalr	-484(ra) # 7854 <exit>
  }
  n = read(fd, (void*)(a+4096), 10);
     a40:	fe843703          	ld	a4,-24(s0)
     a44:	6785                	lui	a5,0x1
     a46:	97ba                	add	a5,a5,a4
     a48:	873e                	mv	a4,a5
     a4a:	fe442783          	lw	a5,-28(s0)
     a4e:	4629                	li	a2,10
     a50:	85ba                	mv	a1,a4
     a52:	853e                	mv	a0,a5
     a54:	00007097          	auipc	ra,0x7
     a58:	e18080e7          	jalr	-488(ra) # 786c <read>
     a5c:	87aa                	mv	a5,a0
     a5e:	fef42023          	sw	a5,-32(s0)
  if(n >= 0){
     a62:	fe042783          	lw	a5,-32(s0)
     a66:	2781                	sext.w	a5,a5
     a68:	0207c763          	bltz	a5,a96 <rwsbrk+0x1ae>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
     a6c:	fe843703          	ld	a4,-24(s0)
     a70:	6785                	lui	a5,0x1
     a72:	97ba                	add	a5,a5,a4
     a74:	fe042703          	lw	a4,-32(s0)
     a78:	863a                	mv	a2,a4
     a7a:	85be                	mv	a1,a5
     a7c:	00008517          	auipc	a0,0x8
     a80:	96450513          	addi	a0,a0,-1692 # 83e0 <malloc+0x472>
     a84:	00007097          	auipc	ra,0x7
     a88:	2f8080e7          	jalr	760(ra) # 7d7c <printf>
    exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00007097          	auipc	ra,0x7
     a92:	dc6080e7          	jalr	-570(ra) # 7854 <exit>
  }
  close(fd);
     a96:	fe442783          	lw	a5,-28(s0)
     a9a:	853e                	mv	a0,a5
     a9c:	00007097          	auipc	ra,0x7
     aa0:	de0080e7          	jalr	-544(ra) # 787c <close>

  exit(0);
     aa4:	4501                	li	a0,0
     aa6:	00007097          	auipc	ra,0x7
     aaa:	dae080e7          	jalr	-594(ra) # 7854 <exit>

0000000000000aae <truncate1>:
}

// test O_TRUNC.
void
truncate1(char *s)
{
     aae:	715d                	addi	sp,sp,-80
     ab0:	e486                	sd	ra,72(sp)
     ab2:	e0a2                	sd	s0,64(sp)
     ab4:	0880                	addi	s0,sp,80
     ab6:	faa43c23          	sd	a0,-72(s0)
  char buf[32];

  unlink("truncfile");
     aba:	00008517          	auipc	a0,0x8
     abe:	94e50513          	addi	a0,a0,-1714 # 8408 <malloc+0x49a>
     ac2:	00007097          	auipc	ra,0x7
     ac6:	de2080e7          	jalr	-542(ra) # 78a4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     aca:	60100593          	li	a1,1537
     ace:	00008517          	auipc	a0,0x8
     ad2:	93a50513          	addi	a0,a0,-1734 # 8408 <malloc+0x49a>
     ad6:	00007097          	auipc	ra,0x7
     ada:	dbe080e7          	jalr	-578(ra) # 7894 <open>
     ade:	87aa                	mv	a5,a0
     ae0:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     ae4:	fec42783          	lw	a5,-20(s0)
     ae8:	4611                	li	a2,4
     aea:	00008597          	auipc	a1,0x8
     aee:	92e58593          	addi	a1,a1,-1746 # 8418 <malloc+0x4aa>
     af2:	853e                	mv	a0,a5
     af4:	00007097          	auipc	ra,0x7
     af8:	d80080e7          	jalr	-640(ra) # 7874 <write>
  close(fd1);
     afc:	fec42783          	lw	a5,-20(s0)
     b00:	853e                	mv	a0,a5
     b02:	00007097          	auipc	ra,0x7
     b06:	d7a080e7          	jalr	-646(ra) # 787c <close>

  int fd2 = open("truncfile", O_RDONLY);
     b0a:	4581                	li	a1,0
     b0c:	00008517          	auipc	a0,0x8
     b10:	8fc50513          	addi	a0,a0,-1796 # 8408 <malloc+0x49a>
     b14:	00007097          	auipc	ra,0x7
     b18:	d80080e7          	jalr	-640(ra) # 7894 <open>
     b1c:	87aa                	mv	a5,a0
     b1e:	fef42423          	sw	a5,-24(s0)
  int n = read(fd2, buf, sizeof(buf));
     b22:	fc040713          	addi	a4,s0,-64
     b26:	fe842783          	lw	a5,-24(s0)
     b2a:	02000613          	li	a2,32
     b2e:	85ba                	mv	a1,a4
     b30:	853e                	mv	a0,a5
     b32:	00007097          	auipc	ra,0x7
     b36:	d3a080e7          	jalr	-710(ra) # 786c <read>
     b3a:	87aa                	mv	a5,a0
     b3c:	fef42223          	sw	a5,-28(s0)
  if(n != 4){
     b40:	fe442783          	lw	a5,-28(s0)
     b44:	0007871b          	sext.w	a4,a5
     b48:	4791                	li	a5,4
     b4a:	02f70463          	beq	a4,a5,b72 <truncate1+0xc4>
    printf("%s: read %d bytes, wanted 4\n", s, n);
     b4e:	fe442783          	lw	a5,-28(s0)
     b52:	863e                	mv	a2,a5
     b54:	fb843583          	ld	a1,-72(s0)
     b58:	00008517          	auipc	a0,0x8
     b5c:	8c850513          	addi	a0,a0,-1848 # 8420 <malloc+0x4b2>
     b60:	00007097          	auipc	ra,0x7
     b64:	21c080e7          	jalr	540(ra) # 7d7c <printf>
    exit(1);
     b68:	4505                	li	a0,1
     b6a:	00007097          	auipc	ra,0x7
     b6e:	cea080e7          	jalr	-790(ra) # 7854 <exit>
  }

  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     b72:	40100593          	li	a1,1025
     b76:	00008517          	auipc	a0,0x8
     b7a:	89250513          	addi	a0,a0,-1902 # 8408 <malloc+0x49a>
     b7e:	00007097          	auipc	ra,0x7
     b82:	d16080e7          	jalr	-746(ra) # 7894 <open>
     b86:	87aa                	mv	a5,a0
     b88:	fef42623          	sw	a5,-20(s0)

  int fd3 = open("truncfile", O_RDONLY);
     b8c:	4581                	li	a1,0
     b8e:	00008517          	auipc	a0,0x8
     b92:	87a50513          	addi	a0,a0,-1926 # 8408 <malloc+0x49a>
     b96:	00007097          	auipc	ra,0x7
     b9a:	cfe080e7          	jalr	-770(ra) # 7894 <open>
     b9e:	87aa                	mv	a5,a0
     ba0:	fef42023          	sw	a5,-32(s0)
  n = read(fd3, buf, sizeof(buf));
     ba4:	fc040713          	addi	a4,s0,-64
     ba8:	fe042783          	lw	a5,-32(s0)
     bac:	02000613          	li	a2,32
     bb0:	85ba                	mv	a1,a4
     bb2:	853e                	mv	a0,a5
     bb4:	00007097          	auipc	ra,0x7
     bb8:	cb8080e7          	jalr	-840(ra) # 786c <read>
     bbc:	87aa                	mv	a5,a0
     bbe:	fef42223          	sw	a5,-28(s0)
  if(n != 0){
     bc2:	fe442783          	lw	a5,-28(s0)
     bc6:	2781                	sext.w	a5,a5
     bc8:	cf95                	beqz	a5,c04 <truncate1+0x156>
    printf("aaa fd3=%d\n", fd3);
     bca:	fe042783          	lw	a5,-32(s0)
     bce:	85be                	mv	a1,a5
     bd0:	00008517          	auipc	a0,0x8
     bd4:	87050513          	addi	a0,a0,-1936 # 8440 <malloc+0x4d2>
     bd8:	00007097          	auipc	ra,0x7
     bdc:	1a4080e7          	jalr	420(ra) # 7d7c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     be0:	fe442783          	lw	a5,-28(s0)
     be4:	863e                	mv	a2,a5
     be6:	fb843583          	ld	a1,-72(s0)
     bea:	00008517          	auipc	a0,0x8
     bee:	86650513          	addi	a0,a0,-1946 # 8450 <malloc+0x4e2>
     bf2:	00007097          	auipc	ra,0x7
     bf6:	18a080e7          	jalr	394(ra) # 7d7c <printf>
    exit(1);
     bfa:	4505                	li	a0,1
     bfc:	00007097          	auipc	ra,0x7
     c00:	c58080e7          	jalr	-936(ra) # 7854 <exit>
  }

  n = read(fd2, buf, sizeof(buf));
     c04:	fc040713          	addi	a4,s0,-64
     c08:	fe842783          	lw	a5,-24(s0)
     c0c:	02000613          	li	a2,32
     c10:	85ba                	mv	a1,a4
     c12:	853e                	mv	a0,a5
     c14:	00007097          	auipc	ra,0x7
     c18:	c58080e7          	jalr	-936(ra) # 786c <read>
     c1c:	87aa                	mv	a5,a0
     c1e:	fef42223          	sw	a5,-28(s0)
  if(n != 0){
     c22:	fe442783          	lw	a5,-28(s0)
     c26:	2781                	sext.w	a5,a5
     c28:	cf95                	beqz	a5,c64 <truncate1+0x1b6>
    printf("bbb fd2=%d\n", fd2);
     c2a:	fe842783          	lw	a5,-24(s0)
     c2e:	85be                	mv	a1,a5
     c30:	00008517          	auipc	a0,0x8
     c34:	84050513          	addi	a0,a0,-1984 # 8470 <malloc+0x502>
     c38:	00007097          	auipc	ra,0x7
     c3c:	144080e7          	jalr	324(ra) # 7d7c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     c40:	fe442783          	lw	a5,-28(s0)
     c44:	863e                	mv	a2,a5
     c46:	fb843583          	ld	a1,-72(s0)
     c4a:	00008517          	auipc	a0,0x8
     c4e:	80650513          	addi	a0,a0,-2042 # 8450 <malloc+0x4e2>
     c52:	00007097          	auipc	ra,0x7
     c56:	12a080e7          	jalr	298(ra) # 7d7c <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	00007097          	auipc	ra,0x7
     c60:	bf8080e7          	jalr	-1032(ra) # 7854 <exit>
  }

  write(fd1, "abcdef", 6);
     c64:	fec42783          	lw	a5,-20(s0)
     c68:	4619                	li	a2,6
     c6a:	00008597          	auipc	a1,0x8
     c6e:	81658593          	addi	a1,a1,-2026 # 8480 <malloc+0x512>
     c72:	853e                	mv	a0,a5
     c74:	00007097          	auipc	ra,0x7
     c78:	c00080e7          	jalr	-1024(ra) # 7874 <write>

  n = read(fd3, buf, sizeof(buf));
     c7c:	fc040713          	addi	a4,s0,-64
     c80:	fe042783          	lw	a5,-32(s0)
     c84:	02000613          	li	a2,32
     c88:	85ba                	mv	a1,a4
     c8a:	853e                	mv	a0,a5
     c8c:	00007097          	auipc	ra,0x7
     c90:	be0080e7          	jalr	-1056(ra) # 786c <read>
     c94:	87aa                	mv	a5,a0
     c96:	fef42223          	sw	a5,-28(s0)
  if(n != 6){
     c9a:	fe442783          	lw	a5,-28(s0)
     c9e:	0007871b          	sext.w	a4,a5
     ca2:	4799                	li	a5,6
     ca4:	02f70463          	beq	a4,a5,ccc <truncate1+0x21e>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     ca8:	fe442783          	lw	a5,-28(s0)
     cac:	863e                	mv	a2,a5
     cae:	fb843583          	ld	a1,-72(s0)
     cb2:	00007517          	auipc	a0,0x7
     cb6:	7d650513          	addi	a0,a0,2006 # 8488 <malloc+0x51a>
     cba:	00007097          	auipc	ra,0x7
     cbe:	0c2080e7          	jalr	194(ra) # 7d7c <printf>
    exit(1);
     cc2:	4505                	li	a0,1
     cc4:	00007097          	auipc	ra,0x7
     cc8:	b90080e7          	jalr	-1136(ra) # 7854 <exit>
  }

  n = read(fd2, buf, sizeof(buf));
     ccc:	fc040713          	addi	a4,s0,-64
     cd0:	fe842783          	lw	a5,-24(s0)
     cd4:	02000613          	li	a2,32
     cd8:	85ba                	mv	a1,a4
     cda:	853e                	mv	a0,a5
     cdc:	00007097          	auipc	ra,0x7
     ce0:	b90080e7          	jalr	-1136(ra) # 786c <read>
     ce4:	87aa                	mv	a5,a0
     ce6:	fef42223          	sw	a5,-28(s0)
  if(n != 2){
     cea:	fe442783          	lw	a5,-28(s0)
     cee:	0007871b          	sext.w	a4,a5
     cf2:	4789                	li	a5,2
     cf4:	02f70463          	beq	a4,a5,d1c <truncate1+0x26e>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     cf8:	fe442783          	lw	a5,-28(s0)
     cfc:	863e                	mv	a2,a5
     cfe:	fb843583          	ld	a1,-72(s0)
     d02:	00007517          	auipc	a0,0x7
     d06:	7a650513          	addi	a0,a0,1958 # 84a8 <malloc+0x53a>
     d0a:	00007097          	auipc	ra,0x7
     d0e:	072080e7          	jalr	114(ra) # 7d7c <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00007097          	auipc	ra,0x7
     d18:	b40080e7          	jalr	-1216(ra) # 7854 <exit>
  }

  unlink("truncfile");
     d1c:	00007517          	auipc	a0,0x7
     d20:	6ec50513          	addi	a0,a0,1772 # 8408 <malloc+0x49a>
     d24:	00007097          	auipc	ra,0x7
     d28:	b80080e7          	jalr	-1152(ra) # 78a4 <unlink>

  close(fd1);
     d2c:	fec42783          	lw	a5,-20(s0)
     d30:	853e                	mv	a0,a5
     d32:	00007097          	auipc	ra,0x7
     d36:	b4a080e7          	jalr	-1206(ra) # 787c <close>
  close(fd2);
     d3a:	fe842783          	lw	a5,-24(s0)
     d3e:	853e                	mv	a0,a5
     d40:	00007097          	auipc	ra,0x7
     d44:	b3c080e7          	jalr	-1220(ra) # 787c <close>
  close(fd3);
     d48:	fe042783          	lw	a5,-32(s0)
     d4c:	853e                	mv	a0,a5
     d4e:	00007097          	auipc	ra,0x7
     d52:	b2e080e7          	jalr	-1234(ra) # 787c <close>
}
     d56:	0001                	nop
     d58:	60a6                	ld	ra,72(sp)
     d5a:	6406                	ld	s0,64(sp)
     d5c:	6161                	addi	sp,sp,80
     d5e:	8082                	ret

0000000000000d60 <truncate2>:
// this causes a write at an offset beyond the end of the file.
// such writes fail on xv6 (unlike POSIX) but at least
// they don't crash.
void
truncate2(char *s)
{
     d60:	7179                	addi	sp,sp,-48
     d62:	f406                	sd	ra,40(sp)
     d64:	f022                	sd	s0,32(sp)
     d66:	1800                	addi	s0,sp,48
     d68:	fca43c23          	sd	a0,-40(s0)
  unlink("truncfile");
     d6c:	00007517          	auipc	a0,0x7
     d70:	69c50513          	addi	a0,a0,1692 # 8408 <malloc+0x49a>
     d74:	00007097          	auipc	ra,0x7
     d78:	b30080e7          	jalr	-1232(ra) # 78a4 <unlink>

  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     d7c:	60100593          	li	a1,1537
     d80:	00007517          	auipc	a0,0x7
     d84:	68850513          	addi	a0,a0,1672 # 8408 <malloc+0x49a>
     d88:	00007097          	auipc	ra,0x7
     d8c:	b0c080e7          	jalr	-1268(ra) # 7894 <open>
     d90:	87aa                	mv	a5,a0
     d92:	fef42623          	sw	a5,-20(s0)
  write(fd1, "abcd", 4);
     d96:	fec42783          	lw	a5,-20(s0)
     d9a:	4611                	li	a2,4
     d9c:	00007597          	auipc	a1,0x7
     da0:	67c58593          	addi	a1,a1,1660 # 8418 <malloc+0x4aa>
     da4:	853e                	mv	a0,a5
     da6:	00007097          	auipc	ra,0x7
     daa:	ace080e7          	jalr	-1330(ra) # 7874 <write>

  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     dae:	40100593          	li	a1,1025
     db2:	00007517          	auipc	a0,0x7
     db6:	65650513          	addi	a0,a0,1622 # 8408 <malloc+0x49a>
     dba:	00007097          	auipc	ra,0x7
     dbe:	ada080e7          	jalr	-1318(ra) # 7894 <open>
     dc2:	87aa                	mv	a5,a0
     dc4:	fef42423          	sw	a5,-24(s0)

  int n = write(fd1, "x", 1);
     dc8:	fec42783          	lw	a5,-20(s0)
     dcc:	4605                	li	a2,1
     dce:	00007597          	auipc	a1,0x7
     dd2:	3f258593          	addi	a1,a1,1010 # 81c0 <malloc+0x252>
     dd6:	853e                	mv	a0,a5
     dd8:	00007097          	auipc	ra,0x7
     ddc:	a9c080e7          	jalr	-1380(ra) # 7874 <write>
     de0:	87aa                	mv	a5,a0
     de2:	fef42223          	sw	a5,-28(s0)
  if(n != -1){
     de6:	fe442783          	lw	a5,-28(s0)
     dea:	0007871b          	sext.w	a4,a5
     dee:	57fd                	li	a5,-1
     df0:	02f70463          	beq	a4,a5,e18 <truncate2+0xb8>
    printf("%s: write returned %d, expected -1\n", s, n);
     df4:	fe442783          	lw	a5,-28(s0)
     df8:	863e                	mv	a2,a5
     dfa:	fd843583          	ld	a1,-40(s0)
     dfe:	00007517          	auipc	a0,0x7
     e02:	6ca50513          	addi	a0,a0,1738 # 84c8 <malloc+0x55a>
     e06:	00007097          	auipc	ra,0x7
     e0a:	f76080e7          	jalr	-138(ra) # 7d7c <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	00007097          	auipc	ra,0x7
     e14:	a44080e7          	jalr	-1468(ra) # 7854 <exit>
  }

  unlink("truncfile");
     e18:	00007517          	auipc	a0,0x7
     e1c:	5f050513          	addi	a0,a0,1520 # 8408 <malloc+0x49a>
     e20:	00007097          	auipc	ra,0x7
     e24:	a84080e7          	jalr	-1404(ra) # 78a4 <unlink>
  close(fd1);
     e28:	fec42783          	lw	a5,-20(s0)
     e2c:	853e                	mv	a0,a5
     e2e:	00007097          	auipc	ra,0x7
     e32:	a4e080e7          	jalr	-1458(ra) # 787c <close>
  close(fd2);
     e36:	fe842783          	lw	a5,-24(s0)
     e3a:	853e                	mv	a0,a5
     e3c:	00007097          	auipc	ra,0x7
     e40:	a40080e7          	jalr	-1472(ra) # 787c <close>
}
     e44:	0001                	nop
     e46:	70a2                	ld	ra,40(sp)
     e48:	7402                	ld	s0,32(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret

0000000000000e4e <truncate3>:

void
truncate3(char *s)
{
     e4e:	711d                	addi	sp,sp,-96
     e50:	ec86                	sd	ra,88(sp)
     e52:	e8a2                	sd	s0,80(sp)
     e54:	1080                	addi	s0,sp,96
     e56:	faa43423          	sd	a0,-88(s0)
  int pid, xstatus;

  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
     e5a:	60100593          	li	a1,1537
     e5e:	00007517          	auipc	a0,0x7
     e62:	5aa50513          	addi	a0,a0,1450 # 8408 <malloc+0x49a>
     e66:	00007097          	auipc	ra,0x7
     e6a:	a2e080e7          	jalr	-1490(ra) # 7894 <open>
     e6e:	87aa                	mv	a5,a0
     e70:	853e                	mv	a0,a5
     e72:	00007097          	auipc	ra,0x7
     e76:	a0a080e7          	jalr	-1526(ra) # 787c <close>

  pid = fork();
     e7a:	00007097          	auipc	ra,0x7
     e7e:	9d2080e7          	jalr	-1582(ra) # 784c <fork>
     e82:	87aa                	mv	a5,a0
     e84:	fef42223          	sw	a5,-28(s0)
  if(pid < 0){
     e88:	fe442783          	lw	a5,-28(s0)
     e8c:	2781                	sext.w	a5,a5
     e8e:	0207d163          	bgez	a5,eb0 <truncate3+0x62>
    printf("%s: fork failed\n", s);
     e92:	fa843583          	ld	a1,-88(s0)
     e96:	00007517          	auipc	a0,0x7
     e9a:	65a50513          	addi	a0,a0,1626 # 84f0 <malloc+0x582>
     e9e:	00007097          	auipc	ra,0x7
     ea2:	ede080e7          	jalr	-290(ra) # 7d7c <printf>
    exit(1);
     ea6:	4505                	li	a0,1
     ea8:	00007097          	auipc	ra,0x7
     eac:	9ac080e7          	jalr	-1620(ra) # 7854 <exit>
  }

  if(pid == 0){
     eb0:	fe442783          	lw	a5,-28(s0)
     eb4:	2781                	sext.w	a5,a5
     eb6:	10079563          	bnez	a5,fc0 <truncate3+0x172>
    for(int i = 0; i < 100; i++){
     eba:	fe042623          	sw	zero,-20(s0)
     ebe:	a0e5                	j	fa6 <truncate3+0x158>
      char buf[32];
      int fd = open("truncfile", O_WRONLY);
     ec0:	4585                	li	a1,1
     ec2:	00007517          	auipc	a0,0x7
     ec6:	54650513          	addi	a0,a0,1350 # 8408 <malloc+0x49a>
     eca:	00007097          	auipc	ra,0x7
     ece:	9ca080e7          	jalr	-1590(ra) # 7894 <open>
     ed2:	87aa                	mv	a5,a0
     ed4:	fcf42c23          	sw	a5,-40(s0)
      if(fd < 0){
     ed8:	fd842783          	lw	a5,-40(s0)
     edc:	2781                	sext.w	a5,a5
     ede:	0207d163          	bgez	a5,f00 <truncate3+0xb2>
        printf("%s: open failed\n", s);
     ee2:	fa843583          	ld	a1,-88(s0)
     ee6:	00007517          	auipc	a0,0x7
     eea:	62250513          	addi	a0,a0,1570 # 8508 <malloc+0x59a>
     eee:	00007097          	auipc	ra,0x7
     ef2:	e8e080e7          	jalr	-370(ra) # 7d7c <printf>
        exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00007097          	auipc	ra,0x7
     efc:	95c080e7          	jalr	-1700(ra) # 7854 <exit>
      }
      int n = write(fd, "1234567890", 10);
     f00:	fd842783          	lw	a5,-40(s0)
     f04:	4629                	li	a2,10
     f06:	00007597          	auipc	a1,0x7
     f0a:	61a58593          	addi	a1,a1,1562 # 8520 <malloc+0x5b2>
     f0e:	853e                	mv	a0,a5
     f10:	00007097          	auipc	ra,0x7
     f14:	964080e7          	jalr	-1692(ra) # 7874 <write>
     f18:	87aa                	mv	a5,a0
     f1a:	fcf42a23          	sw	a5,-44(s0)
      if(n != 10){
     f1e:	fd442783          	lw	a5,-44(s0)
     f22:	0007871b          	sext.w	a4,a5
     f26:	47a9                	li	a5,10
     f28:	02f70463          	beq	a4,a5,f50 <truncate3+0x102>
        printf("%s: write got %d, expected 10\n", s, n);
     f2c:	fd442783          	lw	a5,-44(s0)
     f30:	863e                	mv	a2,a5
     f32:	fa843583          	ld	a1,-88(s0)
     f36:	00007517          	auipc	a0,0x7
     f3a:	5fa50513          	addi	a0,a0,1530 # 8530 <malloc+0x5c2>
     f3e:	00007097          	auipc	ra,0x7
     f42:	e3e080e7          	jalr	-450(ra) # 7d7c <printf>
        exit(1);
     f46:	4505                	li	a0,1
     f48:	00007097          	auipc	ra,0x7
     f4c:	90c080e7          	jalr	-1780(ra) # 7854 <exit>
      }
      close(fd);
     f50:	fd842783          	lw	a5,-40(s0)
     f54:	853e                	mv	a0,a5
     f56:	00007097          	auipc	ra,0x7
     f5a:	926080e7          	jalr	-1754(ra) # 787c <close>
      fd = open("truncfile", O_RDONLY);
     f5e:	4581                	li	a1,0
     f60:	00007517          	auipc	a0,0x7
     f64:	4a850513          	addi	a0,a0,1192 # 8408 <malloc+0x49a>
     f68:	00007097          	auipc	ra,0x7
     f6c:	92c080e7          	jalr	-1748(ra) # 7894 <open>
     f70:	87aa                	mv	a5,a0
     f72:	fcf42c23          	sw	a5,-40(s0)
      read(fd, buf, sizeof(buf));
     f76:	fb040713          	addi	a4,s0,-80
     f7a:	fd842783          	lw	a5,-40(s0)
     f7e:	02000613          	li	a2,32
     f82:	85ba                	mv	a1,a4
     f84:	853e                	mv	a0,a5
     f86:	00007097          	auipc	ra,0x7
     f8a:	8e6080e7          	jalr	-1818(ra) # 786c <read>
      close(fd);
     f8e:	fd842783          	lw	a5,-40(s0)
     f92:	853e                	mv	a0,a5
     f94:	00007097          	auipc	ra,0x7
     f98:	8e8080e7          	jalr	-1816(ra) # 787c <close>
    for(int i = 0; i < 100; i++){
     f9c:	fec42783          	lw	a5,-20(s0)
     fa0:	2785                	addiw	a5,a5,1 # 1001 <truncate3+0x1b3>
     fa2:	fef42623          	sw	a5,-20(s0)
     fa6:	fec42783          	lw	a5,-20(s0)
     faa:	0007871b          	sext.w	a4,a5
     fae:	06300793          	li	a5,99
     fb2:	f0e7d7e3          	bge	a5,a4,ec0 <truncate3+0x72>
    }
    exit(0);
     fb6:	4501                	li	a0,0
     fb8:	00007097          	auipc	ra,0x7
     fbc:	89c080e7          	jalr	-1892(ra) # 7854 <exit>
  }

  for(int i = 0; i < 150; i++){
     fc0:	fe042423          	sw	zero,-24(s0)
     fc4:	a075                	j	1070 <truncate3+0x222>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     fc6:	60100593          	li	a1,1537
     fca:	00007517          	auipc	a0,0x7
     fce:	43e50513          	addi	a0,a0,1086 # 8408 <malloc+0x49a>
     fd2:	00007097          	auipc	ra,0x7
     fd6:	8c2080e7          	jalr	-1854(ra) # 7894 <open>
     fda:	87aa                	mv	a5,a0
     fdc:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
     fe0:	fe042783          	lw	a5,-32(s0)
     fe4:	2781                	sext.w	a5,a5
     fe6:	0207d163          	bgez	a5,1008 <truncate3+0x1ba>
      printf("%s: open failed\n", s);
     fea:	fa843583          	ld	a1,-88(s0)
     fee:	00007517          	auipc	a0,0x7
     ff2:	51a50513          	addi	a0,a0,1306 # 8508 <malloc+0x59a>
     ff6:	00007097          	auipc	ra,0x7
     ffa:	d86080e7          	jalr	-634(ra) # 7d7c <printf>
      exit(1);
     ffe:	4505                	li	a0,1
    1000:	00007097          	auipc	ra,0x7
    1004:	854080e7          	jalr	-1964(ra) # 7854 <exit>
    }
    int n = write(fd, "xxx", 3);
    1008:	fe042783          	lw	a5,-32(s0)
    100c:	460d                	li	a2,3
    100e:	00007597          	auipc	a1,0x7
    1012:	54258593          	addi	a1,a1,1346 # 8550 <malloc+0x5e2>
    1016:	853e                	mv	a0,a5
    1018:	00007097          	auipc	ra,0x7
    101c:	85c080e7          	jalr	-1956(ra) # 7874 <write>
    1020:	87aa                	mv	a5,a0
    1022:	fcf42e23          	sw	a5,-36(s0)
    if(n != 3){
    1026:	fdc42783          	lw	a5,-36(s0)
    102a:	0007871b          	sext.w	a4,a5
    102e:	478d                	li	a5,3
    1030:	02f70463          	beq	a4,a5,1058 <truncate3+0x20a>
      printf("%s: write got %d, expected 3\n", s, n);
    1034:	fdc42783          	lw	a5,-36(s0)
    1038:	863e                	mv	a2,a5
    103a:	fa843583          	ld	a1,-88(s0)
    103e:	00007517          	auipc	a0,0x7
    1042:	51a50513          	addi	a0,a0,1306 # 8558 <malloc+0x5ea>
    1046:	00007097          	auipc	ra,0x7
    104a:	d36080e7          	jalr	-714(ra) # 7d7c <printf>
      exit(1);
    104e:	4505                	li	a0,1
    1050:	00007097          	auipc	ra,0x7
    1054:	804080e7          	jalr	-2044(ra) # 7854 <exit>
    }
    close(fd);
    1058:	fe042783          	lw	a5,-32(s0)
    105c:	853e                	mv	a0,a5
    105e:	00007097          	auipc	ra,0x7
    1062:	81e080e7          	jalr	-2018(ra) # 787c <close>
  for(int i = 0; i < 150; i++){
    1066:	fe842783          	lw	a5,-24(s0)
    106a:	2785                	addiw	a5,a5,1
    106c:	fef42423          	sw	a5,-24(s0)
    1070:	fe842783          	lw	a5,-24(s0)
    1074:	0007871b          	sext.w	a4,a5
    1078:	09500793          	li	a5,149
    107c:	f4e7d5e3          	bge	a5,a4,fc6 <truncate3+0x178>
  }

  wait(&xstatus);
    1080:	fd040793          	addi	a5,s0,-48
    1084:	853e                	mv	a0,a5
    1086:	00006097          	auipc	ra,0x6
    108a:	7d6080e7          	jalr	2006(ra) # 785c <wait>
  unlink("truncfile");
    108e:	00007517          	auipc	a0,0x7
    1092:	37a50513          	addi	a0,a0,890 # 8408 <malloc+0x49a>
    1096:	00007097          	auipc	ra,0x7
    109a:	80e080e7          	jalr	-2034(ra) # 78a4 <unlink>
  exit(xstatus);
    109e:	fd042783          	lw	a5,-48(s0)
    10a2:	853e                	mv	a0,a5
    10a4:	00006097          	auipc	ra,0x6
    10a8:	7b0080e7          	jalr	1968(ra) # 7854 <exit>

00000000000010ac <iputtest>:


// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(char *s)
{
    10ac:	1101                	addi	sp,sp,-32
    10ae:	ec06                	sd	ra,24(sp)
    10b0:	e822                	sd	s0,16(sp)
    10b2:	1000                	addi	s0,sp,32
    10b4:	fea43423          	sd	a0,-24(s0)
  if(mkdir("iputdir") < 0){
    10b8:	00007517          	auipc	a0,0x7
    10bc:	4c050513          	addi	a0,a0,1216 # 8578 <malloc+0x60a>
    10c0:	00006097          	auipc	ra,0x6
    10c4:	7fc080e7          	jalr	2044(ra) # 78bc <mkdir>
    10c8:	87aa                	mv	a5,a0
    10ca:	0207d163          	bgez	a5,10ec <iputtest+0x40>
    printf("%s: mkdir failed\n", s);
    10ce:	fe843583          	ld	a1,-24(s0)
    10d2:	00007517          	auipc	a0,0x7
    10d6:	4ae50513          	addi	a0,a0,1198 # 8580 <malloc+0x612>
    10da:	00007097          	auipc	ra,0x7
    10de:	ca2080e7          	jalr	-862(ra) # 7d7c <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00006097          	auipc	ra,0x6
    10e8:	770080e7          	jalr	1904(ra) # 7854 <exit>
  }
  if(chdir("iputdir") < 0){
    10ec:	00007517          	auipc	a0,0x7
    10f0:	48c50513          	addi	a0,a0,1164 # 8578 <malloc+0x60a>
    10f4:	00006097          	auipc	ra,0x6
    10f8:	7d0080e7          	jalr	2000(ra) # 78c4 <chdir>
    10fc:	87aa                	mv	a5,a0
    10fe:	0207d163          	bgez	a5,1120 <iputtest+0x74>
    printf("%s: chdir iputdir failed\n", s);
    1102:	fe843583          	ld	a1,-24(s0)
    1106:	00007517          	auipc	a0,0x7
    110a:	49250513          	addi	a0,a0,1170 # 8598 <malloc+0x62a>
    110e:	00007097          	auipc	ra,0x7
    1112:	c6e080e7          	jalr	-914(ra) # 7d7c <printf>
    exit(1);
    1116:	4505                	li	a0,1
    1118:	00006097          	auipc	ra,0x6
    111c:	73c080e7          	jalr	1852(ra) # 7854 <exit>
  }
  if(unlink("../iputdir") < 0){
    1120:	00007517          	auipc	a0,0x7
    1124:	49850513          	addi	a0,a0,1176 # 85b8 <malloc+0x64a>
    1128:	00006097          	auipc	ra,0x6
    112c:	77c080e7          	jalr	1916(ra) # 78a4 <unlink>
    1130:	87aa                	mv	a5,a0
    1132:	0207d163          	bgez	a5,1154 <iputtest+0xa8>
    printf("%s: unlink ../iputdir failed\n", s);
    1136:	fe843583          	ld	a1,-24(s0)
    113a:	00007517          	auipc	a0,0x7
    113e:	48e50513          	addi	a0,a0,1166 # 85c8 <malloc+0x65a>
    1142:	00007097          	auipc	ra,0x7
    1146:	c3a080e7          	jalr	-966(ra) # 7d7c <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00006097          	auipc	ra,0x6
    1150:	708080e7          	jalr	1800(ra) # 7854 <exit>
  }
  if(chdir("/") < 0){
    1154:	00007517          	auipc	a0,0x7
    1158:	49450513          	addi	a0,a0,1172 # 85e8 <malloc+0x67a>
    115c:	00006097          	auipc	ra,0x6
    1160:	768080e7          	jalr	1896(ra) # 78c4 <chdir>
    1164:	87aa                	mv	a5,a0
    1166:	0207d163          	bgez	a5,1188 <iputtest+0xdc>
    printf("%s: chdir / failed\n", s);
    116a:	fe843583          	ld	a1,-24(s0)
    116e:	00007517          	auipc	a0,0x7
    1172:	48250513          	addi	a0,a0,1154 # 85f0 <malloc+0x682>
    1176:	00007097          	auipc	ra,0x7
    117a:	c06080e7          	jalr	-1018(ra) # 7d7c <printf>
    exit(1);
    117e:	4505                	li	a0,1
    1180:	00006097          	auipc	ra,0x6
    1184:	6d4080e7          	jalr	1748(ra) # 7854 <exit>
  }
}
    1188:	0001                	nop
    118a:	60e2                	ld	ra,24(sp)
    118c:	6442                	ld	s0,16(sp)
    118e:	6105                	addi	sp,sp,32
    1190:	8082                	ret

0000000000001192 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(char *s)
{
    1192:	7179                	addi	sp,sp,-48
    1194:	f406                	sd	ra,40(sp)
    1196:	f022                	sd	s0,32(sp)
    1198:	1800                	addi	s0,sp,48
    119a:	fca43c23          	sd	a0,-40(s0)
  int pid, xstatus;

  pid = fork();
    119e:	00006097          	auipc	ra,0x6
    11a2:	6ae080e7          	jalr	1710(ra) # 784c <fork>
    11a6:	87aa                	mv	a5,a0
    11a8:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    11ac:	fec42783          	lw	a5,-20(s0)
    11b0:	2781                	sext.w	a5,a5
    11b2:	0207d163          	bgez	a5,11d4 <exitiputtest+0x42>
    printf("%s: fork failed\n", s);
    11b6:	fd843583          	ld	a1,-40(s0)
    11ba:	00007517          	auipc	a0,0x7
    11be:	33650513          	addi	a0,a0,822 # 84f0 <malloc+0x582>
    11c2:	00007097          	auipc	ra,0x7
    11c6:	bba080e7          	jalr	-1094(ra) # 7d7c <printf>
    exit(1);
    11ca:	4505                	li	a0,1
    11cc:	00006097          	auipc	ra,0x6
    11d0:	688080e7          	jalr	1672(ra) # 7854 <exit>
  }
  if(pid == 0){
    11d4:	fec42783          	lw	a5,-20(s0)
    11d8:	2781                	sext.w	a5,a5
    11da:	e7c5                	bnez	a5,1282 <exitiputtest+0xf0>
    if(mkdir("iputdir") < 0){
    11dc:	00007517          	auipc	a0,0x7
    11e0:	39c50513          	addi	a0,a0,924 # 8578 <malloc+0x60a>
    11e4:	00006097          	auipc	ra,0x6
    11e8:	6d8080e7          	jalr	1752(ra) # 78bc <mkdir>
    11ec:	87aa                	mv	a5,a0
    11ee:	0207d163          	bgez	a5,1210 <exitiputtest+0x7e>
      printf("%s: mkdir failed\n", s);
    11f2:	fd843583          	ld	a1,-40(s0)
    11f6:	00007517          	auipc	a0,0x7
    11fa:	38a50513          	addi	a0,a0,906 # 8580 <malloc+0x612>
    11fe:	00007097          	auipc	ra,0x7
    1202:	b7e080e7          	jalr	-1154(ra) # 7d7c <printf>
      exit(1);
    1206:	4505                	li	a0,1
    1208:	00006097          	auipc	ra,0x6
    120c:	64c080e7          	jalr	1612(ra) # 7854 <exit>
    }
    if(chdir("iputdir") < 0){
    1210:	00007517          	auipc	a0,0x7
    1214:	36850513          	addi	a0,a0,872 # 8578 <malloc+0x60a>
    1218:	00006097          	auipc	ra,0x6
    121c:	6ac080e7          	jalr	1708(ra) # 78c4 <chdir>
    1220:	87aa                	mv	a5,a0
    1222:	0207d163          	bgez	a5,1244 <exitiputtest+0xb2>
      printf("%s: child chdir failed\n", s);
    1226:	fd843583          	ld	a1,-40(s0)
    122a:	00007517          	auipc	a0,0x7
    122e:	3de50513          	addi	a0,a0,990 # 8608 <malloc+0x69a>
    1232:	00007097          	auipc	ra,0x7
    1236:	b4a080e7          	jalr	-1206(ra) # 7d7c <printf>
      exit(1);
    123a:	4505                	li	a0,1
    123c:	00006097          	auipc	ra,0x6
    1240:	618080e7          	jalr	1560(ra) # 7854 <exit>
    }
    if(unlink("../iputdir") < 0){
    1244:	00007517          	auipc	a0,0x7
    1248:	37450513          	addi	a0,a0,884 # 85b8 <malloc+0x64a>
    124c:	00006097          	auipc	ra,0x6
    1250:	658080e7          	jalr	1624(ra) # 78a4 <unlink>
    1254:	87aa                	mv	a5,a0
    1256:	0207d163          	bgez	a5,1278 <exitiputtest+0xe6>
      printf("%s: unlink ../iputdir failed\n", s);
    125a:	fd843583          	ld	a1,-40(s0)
    125e:	00007517          	auipc	a0,0x7
    1262:	36a50513          	addi	a0,a0,874 # 85c8 <malloc+0x65a>
    1266:	00007097          	auipc	ra,0x7
    126a:	b16080e7          	jalr	-1258(ra) # 7d7c <printf>
      exit(1);
    126e:	4505                	li	a0,1
    1270:	00006097          	auipc	ra,0x6
    1274:	5e4080e7          	jalr	1508(ra) # 7854 <exit>
    }
    exit(0);
    1278:	4501                	li	a0,0
    127a:	00006097          	auipc	ra,0x6
    127e:	5da080e7          	jalr	1498(ra) # 7854 <exit>
  }
  wait(&xstatus);
    1282:	fe840793          	addi	a5,s0,-24
    1286:	853e                	mv	a0,a5
    1288:	00006097          	auipc	ra,0x6
    128c:	5d4080e7          	jalr	1492(ra) # 785c <wait>
  exit(xstatus);
    1290:	fe842783          	lw	a5,-24(s0)
    1294:	853e                	mv	a0,a5
    1296:	00006097          	auipc	ra,0x6
    129a:	5be080e7          	jalr	1470(ra) # 7854 <exit>

000000000000129e <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(char *s)
{
    129e:	7179                	addi	sp,sp,-48
    12a0:	f406                	sd	ra,40(sp)
    12a2:	f022                	sd	s0,32(sp)
    12a4:	1800                	addi	s0,sp,48
    12a6:	fca43c23          	sd	a0,-40(s0)
  int pid, xstatus;

  if(mkdir("oidir") < 0){
    12aa:	00007517          	auipc	a0,0x7
    12ae:	37650513          	addi	a0,a0,886 # 8620 <malloc+0x6b2>
    12b2:	00006097          	auipc	ra,0x6
    12b6:	60a080e7          	jalr	1546(ra) # 78bc <mkdir>
    12ba:	87aa                	mv	a5,a0
    12bc:	0207d163          	bgez	a5,12de <openiputtest+0x40>
    printf("%s: mkdir oidir failed\n", s);
    12c0:	fd843583          	ld	a1,-40(s0)
    12c4:	00007517          	auipc	a0,0x7
    12c8:	36450513          	addi	a0,a0,868 # 8628 <malloc+0x6ba>
    12cc:	00007097          	auipc	ra,0x7
    12d0:	ab0080e7          	jalr	-1360(ra) # 7d7c <printf>
    exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00006097          	auipc	ra,0x6
    12da:	57e080e7          	jalr	1406(ra) # 7854 <exit>
  }
  pid = fork();
    12de:	00006097          	auipc	ra,0x6
    12e2:	56e080e7          	jalr	1390(ra) # 784c <fork>
    12e6:	87aa                	mv	a5,a0
    12e8:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    12ec:	fec42783          	lw	a5,-20(s0)
    12f0:	2781                	sext.w	a5,a5
    12f2:	0207d163          	bgez	a5,1314 <openiputtest+0x76>
    printf("%s: fork failed\n", s);
    12f6:	fd843583          	ld	a1,-40(s0)
    12fa:	00007517          	auipc	a0,0x7
    12fe:	1f650513          	addi	a0,a0,502 # 84f0 <malloc+0x582>
    1302:	00007097          	auipc	ra,0x7
    1306:	a7a080e7          	jalr	-1414(ra) # 7d7c <printf>
    exit(1);
    130a:	4505                	li	a0,1
    130c:	00006097          	auipc	ra,0x6
    1310:	548080e7          	jalr	1352(ra) # 7854 <exit>
  }
  if(pid == 0){
    1314:	fec42783          	lw	a5,-20(s0)
    1318:	2781                	sext.w	a5,a5
    131a:	e7b1                	bnez	a5,1366 <openiputtest+0xc8>
    int fd = open("oidir", O_RDWR);
    131c:	4589                	li	a1,2
    131e:	00007517          	auipc	a0,0x7
    1322:	30250513          	addi	a0,a0,770 # 8620 <malloc+0x6b2>
    1326:	00006097          	auipc	ra,0x6
    132a:	56e080e7          	jalr	1390(ra) # 7894 <open>
    132e:	87aa                	mv	a5,a0
    1330:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0){
    1334:	fe842783          	lw	a5,-24(s0)
    1338:	2781                	sext.w	a5,a5
    133a:	0207c163          	bltz	a5,135c <openiputtest+0xbe>
      printf("%s: open directory for write succeeded\n", s);
    133e:	fd843583          	ld	a1,-40(s0)
    1342:	00007517          	auipc	a0,0x7
    1346:	2fe50513          	addi	a0,a0,766 # 8640 <malloc+0x6d2>
    134a:	00007097          	auipc	ra,0x7
    134e:	a32080e7          	jalr	-1486(ra) # 7d7c <printf>
      exit(1);
    1352:	4505                	li	a0,1
    1354:	00006097          	auipc	ra,0x6
    1358:	500080e7          	jalr	1280(ra) # 7854 <exit>
    }
    exit(0);
    135c:	4501                	li	a0,0
    135e:	00006097          	auipc	ra,0x6
    1362:	4f6080e7          	jalr	1270(ra) # 7854 <exit>
  }
  sleep(1);
    1366:	4505                	li	a0,1
    1368:	00006097          	auipc	ra,0x6
    136c:	57c080e7          	jalr	1404(ra) # 78e4 <sleep>
  if(unlink("oidir") != 0){
    1370:	00007517          	auipc	a0,0x7
    1374:	2b050513          	addi	a0,a0,688 # 8620 <malloc+0x6b2>
    1378:	00006097          	auipc	ra,0x6
    137c:	52c080e7          	jalr	1324(ra) # 78a4 <unlink>
    1380:	87aa                	mv	a5,a0
    1382:	c385                	beqz	a5,13a2 <openiputtest+0x104>
    printf("%s: unlink failed\n", s);
    1384:	fd843583          	ld	a1,-40(s0)
    1388:	00007517          	auipc	a0,0x7
    138c:	2e050513          	addi	a0,a0,736 # 8668 <malloc+0x6fa>
    1390:	00007097          	auipc	ra,0x7
    1394:	9ec080e7          	jalr	-1556(ra) # 7d7c <printf>
    exit(1);
    1398:	4505                	li	a0,1
    139a:	00006097          	auipc	ra,0x6
    139e:	4ba080e7          	jalr	1210(ra) # 7854 <exit>
  }
  wait(&xstatus);
    13a2:	fe440793          	addi	a5,s0,-28
    13a6:	853e                	mv	a0,a5
    13a8:	00006097          	auipc	ra,0x6
    13ac:	4b4080e7          	jalr	1204(ra) # 785c <wait>
  exit(xstatus);
    13b0:	fe442783          	lw	a5,-28(s0)
    13b4:	853e                	mv	a0,a5
    13b6:	00006097          	auipc	ra,0x6
    13ba:	49e080e7          	jalr	1182(ra) # 7854 <exit>

00000000000013be <opentest>:

// simple file system tests

void
opentest(char *s)
{
    13be:	7179                	addi	sp,sp,-48
    13c0:	f406                	sd	ra,40(sp)
    13c2:	f022                	sd	s0,32(sp)
    13c4:	1800                	addi	s0,sp,48
    13c6:	fca43c23          	sd	a0,-40(s0)
  int fd;

  fd = open("echo", 0);
    13ca:	4581                	li	a1,0
    13cc:	00007517          	auipc	a0,0x7
    13d0:	f0450513          	addi	a0,a0,-252 # 82d0 <malloc+0x362>
    13d4:	00006097          	auipc	ra,0x6
    13d8:	4c0080e7          	jalr	1216(ra) # 7894 <open>
    13dc:	87aa                	mv	a5,a0
    13de:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    13e2:	fec42783          	lw	a5,-20(s0)
    13e6:	2781                	sext.w	a5,a5
    13e8:	0207d163          	bgez	a5,140a <opentest+0x4c>
    printf("%s: open echo failed!\n", s);
    13ec:	fd843583          	ld	a1,-40(s0)
    13f0:	00007517          	auipc	a0,0x7
    13f4:	29050513          	addi	a0,a0,656 # 8680 <malloc+0x712>
    13f8:	00007097          	auipc	ra,0x7
    13fc:	984080e7          	jalr	-1660(ra) # 7d7c <printf>
    exit(1);
    1400:	4505                	li	a0,1
    1402:	00006097          	auipc	ra,0x6
    1406:	452080e7          	jalr	1106(ra) # 7854 <exit>
  }
  close(fd);
    140a:	fec42783          	lw	a5,-20(s0)
    140e:	853e                	mv	a0,a5
    1410:	00006097          	auipc	ra,0x6
    1414:	46c080e7          	jalr	1132(ra) # 787c <close>
  fd = open("doesnotexist", 0);
    1418:	4581                	li	a1,0
    141a:	00007517          	auipc	a0,0x7
    141e:	27e50513          	addi	a0,a0,638 # 8698 <malloc+0x72a>
    1422:	00006097          	auipc	ra,0x6
    1426:	472080e7          	jalr	1138(ra) # 7894 <open>
    142a:	87aa                	mv	a5,a0
    142c:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    1430:	fec42783          	lw	a5,-20(s0)
    1434:	2781                	sext.w	a5,a5
    1436:	0207c163          	bltz	a5,1458 <opentest+0x9a>
    printf("%s: open doesnotexist succeeded!\n", s);
    143a:	fd843583          	ld	a1,-40(s0)
    143e:	00007517          	auipc	a0,0x7
    1442:	26a50513          	addi	a0,a0,618 # 86a8 <malloc+0x73a>
    1446:	00007097          	auipc	ra,0x7
    144a:	936080e7          	jalr	-1738(ra) # 7d7c <printf>
    exit(1);
    144e:	4505                	li	a0,1
    1450:	00006097          	auipc	ra,0x6
    1454:	404080e7          	jalr	1028(ra) # 7854 <exit>
  }
}
    1458:	0001                	nop
    145a:	70a2                	ld	ra,40(sp)
    145c:	7402                	ld	s0,32(sp)
    145e:	6145                	addi	sp,sp,48
    1460:	8082                	ret

0000000000001462 <writetest>:

void
writetest(char *s)
{
    1462:	7179                	addi	sp,sp,-48
    1464:	f406                	sd	ra,40(sp)
    1466:	f022                	sd	s0,32(sp)
    1468:	1800                	addi	s0,sp,48
    146a:	fca43c23          	sd	a0,-40(s0)
  int fd;
  int i;
  enum { N=100, SZ=10 };

  fd = open("small", O_CREATE|O_RDWR);
    146e:	20200593          	li	a1,514
    1472:	00007517          	auipc	a0,0x7
    1476:	25e50513          	addi	a0,a0,606 # 86d0 <malloc+0x762>
    147a:	00006097          	auipc	ra,0x6
    147e:	41a080e7          	jalr	1050(ra) # 7894 <open>
    1482:	87aa                	mv	a5,a0
    1484:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    1488:	fe842783          	lw	a5,-24(s0)
    148c:	2781                	sext.w	a5,a5
    148e:	0207d163          	bgez	a5,14b0 <writetest+0x4e>
    printf("%s: error: creat small failed!\n", s);
    1492:	fd843583          	ld	a1,-40(s0)
    1496:	00007517          	auipc	a0,0x7
    149a:	24250513          	addi	a0,a0,578 # 86d8 <malloc+0x76a>
    149e:	00007097          	auipc	ra,0x7
    14a2:	8de080e7          	jalr	-1826(ra) # 7d7c <printf>
    exit(1);
    14a6:	4505                	li	a0,1
    14a8:	00006097          	auipc	ra,0x6
    14ac:	3ac080e7          	jalr	940(ra) # 7854 <exit>
  }
  for(i = 0; i < N; i++){
    14b0:	fe042623          	sw	zero,-20(s0)
    14b4:	a861                	j	154c <writetest+0xea>
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    14b6:	fe842783          	lw	a5,-24(s0)
    14ba:	4629                	li	a2,10
    14bc:	00007597          	auipc	a1,0x7
    14c0:	23c58593          	addi	a1,a1,572 # 86f8 <malloc+0x78a>
    14c4:	853e                	mv	a0,a5
    14c6:	00006097          	auipc	ra,0x6
    14ca:	3ae080e7          	jalr	942(ra) # 7874 <write>
    14ce:	87aa                	mv	a5,a0
    14d0:	873e                	mv	a4,a5
    14d2:	47a9                	li	a5,10
    14d4:	02f70463          	beq	a4,a5,14fc <writetest+0x9a>
      printf("%s: error: write aa %d new file failed\n", s, i);
    14d8:	fec42783          	lw	a5,-20(s0)
    14dc:	863e                	mv	a2,a5
    14de:	fd843583          	ld	a1,-40(s0)
    14e2:	00007517          	auipc	a0,0x7
    14e6:	22650513          	addi	a0,a0,550 # 8708 <malloc+0x79a>
    14ea:	00007097          	auipc	ra,0x7
    14ee:	892080e7          	jalr	-1902(ra) # 7d7c <printf>
      exit(1);
    14f2:	4505                	li	a0,1
    14f4:	00006097          	auipc	ra,0x6
    14f8:	360080e7          	jalr	864(ra) # 7854 <exit>
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    14fc:	fe842783          	lw	a5,-24(s0)
    1500:	4629                	li	a2,10
    1502:	00007597          	auipc	a1,0x7
    1506:	22e58593          	addi	a1,a1,558 # 8730 <malloc+0x7c2>
    150a:	853e                	mv	a0,a5
    150c:	00006097          	auipc	ra,0x6
    1510:	368080e7          	jalr	872(ra) # 7874 <write>
    1514:	87aa                	mv	a5,a0
    1516:	873e                	mv	a4,a5
    1518:	47a9                	li	a5,10
    151a:	02f70463          	beq	a4,a5,1542 <writetest+0xe0>
      printf("%s: error: write bb %d new file failed\n", s, i);
    151e:	fec42783          	lw	a5,-20(s0)
    1522:	863e                	mv	a2,a5
    1524:	fd843583          	ld	a1,-40(s0)
    1528:	00007517          	auipc	a0,0x7
    152c:	21850513          	addi	a0,a0,536 # 8740 <malloc+0x7d2>
    1530:	00007097          	auipc	ra,0x7
    1534:	84c080e7          	jalr	-1972(ra) # 7d7c <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00006097          	auipc	ra,0x6
    153e:	31a080e7          	jalr	794(ra) # 7854 <exit>
  for(i = 0; i < N; i++){
    1542:	fec42783          	lw	a5,-20(s0)
    1546:	2785                	addiw	a5,a5,1
    1548:	fef42623          	sw	a5,-20(s0)
    154c:	fec42783          	lw	a5,-20(s0)
    1550:	0007871b          	sext.w	a4,a5
    1554:	06300793          	li	a5,99
    1558:	f4e7dfe3          	bge	a5,a4,14b6 <writetest+0x54>
    }
  }
  close(fd);
    155c:	fe842783          	lw	a5,-24(s0)
    1560:	853e                	mv	a0,a5
    1562:	00006097          	auipc	ra,0x6
    1566:	31a080e7          	jalr	794(ra) # 787c <close>
  fd = open("small", O_RDONLY);
    156a:	4581                	li	a1,0
    156c:	00007517          	auipc	a0,0x7
    1570:	16450513          	addi	a0,a0,356 # 86d0 <malloc+0x762>
    1574:	00006097          	auipc	ra,0x6
    1578:	320080e7          	jalr	800(ra) # 7894 <open>
    157c:	87aa                	mv	a5,a0
    157e:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    1582:	fe842783          	lw	a5,-24(s0)
    1586:	2781                	sext.w	a5,a5
    1588:	0207d163          	bgez	a5,15aa <writetest+0x148>
    printf("%s: error: open small failed!\n", s);
    158c:	fd843583          	ld	a1,-40(s0)
    1590:	00007517          	auipc	a0,0x7
    1594:	1d850513          	addi	a0,a0,472 # 8768 <malloc+0x7fa>
    1598:	00006097          	auipc	ra,0x6
    159c:	7e4080e7          	jalr	2020(ra) # 7d7c <printf>
    exit(1);
    15a0:	4505                	li	a0,1
    15a2:	00006097          	auipc	ra,0x6
    15a6:	2b2080e7          	jalr	690(ra) # 7854 <exit>
  }
  i = read(fd, buf, N*SZ*2);
    15aa:	fe842783          	lw	a5,-24(s0)
    15ae:	7d000613          	li	a2,2000
    15b2:	0000b597          	auipc	a1,0xb
    15b6:	d2e58593          	addi	a1,a1,-722 # c2e0 <buf>
    15ba:	853e                	mv	a0,a5
    15bc:	00006097          	auipc	ra,0x6
    15c0:	2b0080e7          	jalr	688(ra) # 786c <read>
    15c4:	87aa                	mv	a5,a0
    15c6:	fef42623          	sw	a5,-20(s0)
  if(i != N*SZ*2){
    15ca:	fec42783          	lw	a5,-20(s0)
    15ce:	0007871b          	sext.w	a4,a5
    15d2:	7d000793          	li	a5,2000
    15d6:	02f70163          	beq	a4,a5,15f8 <writetest+0x196>
    printf("%s: read failed\n", s);
    15da:	fd843583          	ld	a1,-40(s0)
    15de:	00007517          	auipc	a0,0x7
    15e2:	1aa50513          	addi	a0,a0,426 # 8788 <malloc+0x81a>
    15e6:	00006097          	auipc	ra,0x6
    15ea:	796080e7          	jalr	1942(ra) # 7d7c <printf>
    exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00006097          	auipc	ra,0x6
    15f4:	264080e7          	jalr	612(ra) # 7854 <exit>
  }
  close(fd);
    15f8:	fe842783          	lw	a5,-24(s0)
    15fc:	853e                	mv	a0,a5
    15fe:	00006097          	auipc	ra,0x6
    1602:	27e080e7          	jalr	638(ra) # 787c <close>

  if(unlink("small") < 0){
    1606:	00007517          	auipc	a0,0x7
    160a:	0ca50513          	addi	a0,a0,202 # 86d0 <malloc+0x762>
    160e:	00006097          	auipc	ra,0x6
    1612:	296080e7          	jalr	662(ra) # 78a4 <unlink>
    1616:	87aa                	mv	a5,a0
    1618:	0207d163          	bgez	a5,163a <writetest+0x1d8>
    printf("%s: unlink small failed\n", s);
    161c:	fd843583          	ld	a1,-40(s0)
    1620:	00007517          	auipc	a0,0x7
    1624:	18050513          	addi	a0,a0,384 # 87a0 <malloc+0x832>
    1628:	00006097          	auipc	ra,0x6
    162c:	754080e7          	jalr	1876(ra) # 7d7c <printf>
    exit(1);
    1630:	4505                	li	a0,1
    1632:	00006097          	auipc	ra,0x6
    1636:	222080e7          	jalr	546(ra) # 7854 <exit>
  }
}
    163a:	0001                	nop
    163c:	70a2                	ld	ra,40(sp)
    163e:	7402                	ld	s0,32(sp)
    1640:	6145                	addi	sp,sp,48
    1642:	8082                	ret

0000000000001644 <writebig>:

void
writebig(char *s)
{
    1644:	7179                	addi	sp,sp,-48
    1646:	f406                	sd	ra,40(sp)
    1648:	f022                	sd	s0,32(sp)
    164a:	1800                	addi	s0,sp,48
    164c:	fca43c23          	sd	a0,-40(s0)
  int i, fd, n;

  fd = open("big", O_CREATE|O_RDWR);
    1650:	20200593          	li	a1,514
    1654:	00007517          	auipc	a0,0x7
    1658:	16c50513          	addi	a0,a0,364 # 87c0 <malloc+0x852>
    165c:	00006097          	auipc	ra,0x6
    1660:	238080e7          	jalr	568(ra) # 7894 <open>
    1664:	87aa                	mv	a5,a0
    1666:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    166a:	fe442783          	lw	a5,-28(s0)
    166e:	2781                	sext.w	a5,a5
    1670:	0207d163          	bgez	a5,1692 <writebig+0x4e>
    printf("%s: error: creat big failed!\n", s);
    1674:	fd843583          	ld	a1,-40(s0)
    1678:	00007517          	auipc	a0,0x7
    167c:	15050513          	addi	a0,a0,336 # 87c8 <malloc+0x85a>
    1680:	00006097          	auipc	ra,0x6
    1684:	6fc080e7          	jalr	1788(ra) # 7d7c <printf>
    exit(1);
    1688:	4505                	li	a0,1
    168a:	00006097          	auipc	ra,0x6
    168e:	1ca080e7          	jalr	458(ra) # 7854 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
    1692:	fe042623          	sw	zero,-20(s0)
    1696:	a095                	j	16fa <writebig+0xb6>
    ((int*)buf)[0] = i;
    1698:	0000b797          	auipc	a5,0xb
    169c:	c4878793          	addi	a5,a5,-952 # c2e0 <buf>
    16a0:	fec42703          	lw	a4,-20(s0)
    16a4:	c398                	sw	a4,0(a5)
    if(write(fd, buf, BSIZE) != BSIZE){
    16a6:	fe442783          	lw	a5,-28(s0)
    16aa:	40000613          	li	a2,1024
    16ae:	0000b597          	auipc	a1,0xb
    16b2:	c3258593          	addi	a1,a1,-974 # c2e0 <buf>
    16b6:	853e                	mv	a0,a5
    16b8:	00006097          	auipc	ra,0x6
    16bc:	1bc080e7          	jalr	444(ra) # 7874 <write>
    16c0:	87aa                	mv	a5,a0
    16c2:	873e                	mv	a4,a5
    16c4:	40000793          	li	a5,1024
    16c8:	02f70463          	beq	a4,a5,16f0 <writebig+0xac>
      printf("%s: error: write big file failed\n", s, i);
    16cc:	fec42783          	lw	a5,-20(s0)
    16d0:	863e                	mv	a2,a5
    16d2:	fd843583          	ld	a1,-40(s0)
    16d6:	00007517          	auipc	a0,0x7
    16da:	11250513          	addi	a0,a0,274 # 87e8 <malloc+0x87a>
    16de:	00006097          	auipc	ra,0x6
    16e2:	69e080e7          	jalr	1694(ra) # 7d7c <printf>
      exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00006097          	auipc	ra,0x6
    16ec:	16c080e7          	jalr	364(ra) # 7854 <exit>
  for(i = 0; i < MAXFILE; i++){
    16f0:	fec42783          	lw	a5,-20(s0)
    16f4:	2785                	addiw	a5,a5,1
    16f6:	fef42623          	sw	a5,-20(s0)
    16fa:	fec42783          	lw	a5,-20(s0)
    16fe:	873e                	mv	a4,a5
    1700:	10b00793          	li	a5,267
    1704:	f8e7fae3          	bgeu	a5,a4,1698 <writebig+0x54>
    }
  }

  close(fd);
    1708:	fe442783          	lw	a5,-28(s0)
    170c:	853e                	mv	a0,a5
    170e:	00006097          	auipc	ra,0x6
    1712:	16e080e7          	jalr	366(ra) # 787c <close>

  fd = open("big", O_RDONLY);
    1716:	4581                	li	a1,0
    1718:	00007517          	auipc	a0,0x7
    171c:	0a850513          	addi	a0,a0,168 # 87c0 <malloc+0x852>
    1720:	00006097          	auipc	ra,0x6
    1724:	174080e7          	jalr	372(ra) # 7894 <open>
    1728:	87aa                	mv	a5,a0
    172a:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    172e:	fe442783          	lw	a5,-28(s0)
    1732:	2781                	sext.w	a5,a5
    1734:	0207d163          	bgez	a5,1756 <writebig+0x112>
    printf("%s: error: open big failed!\n", s);
    1738:	fd843583          	ld	a1,-40(s0)
    173c:	00007517          	auipc	a0,0x7
    1740:	0d450513          	addi	a0,a0,212 # 8810 <malloc+0x8a2>
    1744:	00006097          	auipc	ra,0x6
    1748:	638080e7          	jalr	1592(ra) # 7d7c <printf>
    exit(1);
    174c:	4505                	li	a0,1
    174e:	00006097          	auipc	ra,0x6
    1752:	106080e7          	jalr	262(ra) # 7854 <exit>
  }

  n = 0;
    1756:	fe042423          	sw	zero,-24(s0)
  for(;;){
    i = read(fd, buf, BSIZE);
    175a:	fe442783          	lw	a5,-28(s0)
    175e:	40000613          	li	a2,1024
    1762:	0000b597          	auipc	a1,0xb
    1766:	b7e58593          	addi	a1,a1,-1154 # c2e0 <buf>
    176a:	853e                	mv	a0,a5
    176c:	00006097          	auipc	ra,0x6
    1770:	100080e7          	jalr	256(ra) # 786c <read>
    1774:	87aa                	mv	a5,a0
    1776:	fef42623          	sw	a5,-20(s0)
    if(i == 0){
    177a:	fec42783          	lw	a5,-20(s0)
    177e:	2781                	sext.w	a5,a5
    1780:	eb9d                	bnez	a5,17b6 <writebig+0x172>
      if(n == MAXFILE - 1){
    1782:	fe842783          	lw	a5,-24(s0)
    1786:	0007871b          	sext.w	a4,a5
    178a:	10b00793          	li	a5,267
    178e:	0af71663          	bne	a4,a5,183a <writebig+0x1f6>
        printf("%s: read only %d blocks from big", s, n);
    1792:	fe842783          	lw	a5,-24(s0)
    1796:	863e                	mv	a2,a5
    1798:	fd843583          	ld	a1,-40(s0)
    179c:	00007517          	auipc	a0,0x7
    17a0:	09450513          	addi	a0,a0,148 # 8830 <malloc+0x8c2>
    17a4:	00006097          	auipc	ra,0x6
    17a8:	5d8080e7          	jalr	1496(ra) # 7d7c <printf>
        exit(1);
    17ac:	4505                	li	a0,1
    17ae:	00006097          	auipc	ra,0x6
    17b2:	0a6080e7          	jalr	166(ra) # 7854 <exit>
      }
      break;
    } else if(i != BSIZE){
    17b6:	fec42783          	lw	a5,-20(s0)
    17ba:	0007871b          	sext.w	a4,a5
    17be:	40000793          	li	a5,1024
    17c2:	02f70463          	beq	a4,a5,17ea <writebig+0x1a6>
      printf("%s: read failed %d\n", s, i);
    17c6:	fec42783          	lw	a5,-20(s0)
    17ca:	863e                	mv	a2,a5
    17cc:	fd843583          	ld	a1,-40(s0)
    17d0:	00007517          	auipc	a0,0x7
    17d4:	08850513          	addi	a0,a0,136 # 8858 <malloc+0x8ea>
    17d8:	00006097          	auipc	ra,0x6
    17dc:	5a4080e7          	jalr	1444(ra) # 7d7c <printf>
      exit(1);
    17e0:	4505                	li	a0,1
    17e2:	00006097          	auipc	ra,0x6
    17e6:	072080e7          	jalr	114(ra) # 7854 <exit>
    }
    if(((int*)buf)[0] != n){
    17ea:	0000b797          	auipc	a5,0xb
    17ee:	af678793          	addi	a5,a5,-1290 # c2e0 <buf>
    17f2:	4398                	lw	a4,0(a5)
    17f4:	fe842783          	lw	a5,-24(s0)
    17f8:	2781                	sext.w	a5,a5
    17fa:	02e78a63          	beq	a5,a4,182e <writebig+0x1ea>
      printf("%s: read content of block %d is %d\n", s,
             n, ((int*)buf)[0]);
    17fe:	0000b797          	auipc	a5,0xb
    1802:	ae278793          	addi	a5,a5,-1310 # c2e0 <buf>
      printf("%s: read content of block %d is %d\n", s,
    1806:	4398                	lw	a4,0(a5)
    1808:	fe842783          	lw	a5,-24(s0)
    180c:	86ba                	mv	a3,a4
    180e:	863e                	mv	a2,a5
    1810:	fd843583          	ld	a1,-40(s0)
    1814:	00007517          	auipc	a0,0x7
    1818:	05c50513          	addi	a0,a0,92 # 8870 <malloc+0x902>
    181c:	00006097          	auipc	ra,0x6
    1820:	560080e7          	jalr	1376(ra) # 7d7c <printf>
      exit(1);
    1824:	4505                	li	a0,1
    1826:	00006097          	auipc	ra,0x6
    182a:	02e080e7          	jalr	46(ra) # 7854 <exit>
    }
    n++;
    182e:	fe842783          	lw	a5,-24(s0)
    1832:	2785                	addiw	a5,a5,1
    1834:	fef42423          	sw	a5,-24(s0)
    i = read(fd, buf, BSIZE);
    1838:	b70d                	j	175a <writebig+0x116>
      break;
    183a:	0001                	nop
  }
  close(fd);
    183c:	fe442783          	lw	a5,-28(s0)
    1840:	853e                	mv	a0,a5
    1842:	00006097          	auipc	ra,0x6
    1846:	03a080e7          	jalr	58(ra) # 787c <close>
  if(unlink("big") < 0){
    184a:	00007517          	auipc	a0,0x7
    184e:	f7650513          	addi	a0,a0,-138 # 87c0 <malloc+0x852>
    1852:	00006097          	auipc	ra,0x6
    1856:	052080e7          	jalr	82(ra) # 78a4 <unlink>
    185a:	87aa                	mv	a5,a0
    185c:	0207d163          	bgez	a5,187e <writebig+0x23a>
    printf("%s: unlink big failed\n", s);
    1860:	fd843583          	ld	a1,-40(s0)
    1864:	00007517          	auipc	a0,0x7
    1868:	03450513          	addi	a0,a0,52 # 8898 <malloc+0x92a>
    186c:	00006097          	auipc	ra,0x6
    1870:	510080e7          	jalr	1296(ra) # 7d7c <printf>
    exit(1);
    1874:	4505                	li	a0,1
    1876:	00006097          	auipc	ra,0x6
    187a:	fde080e7          	jalr	-34(ra) # 7854 <exit>
  }
}
    187e:	0001                	nop
    1880:	70a2                	ld	ra,40(sp)
    1882:	7402                	ld	s0,32(sp)
    1884:	6145                	addi	sp,sp,48
    1886:	8082                	ret

0000000000001888 <createtest>:

// many creates, followed by unlink test
void
createtest(char *s)
{
    1888:	7179                	addi	sp,sp,-48
    188a:	f406                	sd	ra,40(sp)
    188c:	f022                	sd	s0,32(sp)
    188e:	1800                	addi	s0,sp,48
    1890:	fca43c23          	sd	a0,-40(s0)
  int i, fd;
  enum { N=52 };

  char name[3];
  name[0] = 'a';
    1894:	06100793          	li	a5,97
    1898:	fef40023          	sb	a5,-32(s0)
  name[2] = '\0';
    189c:	fe040123          	sb	zero,-30(s0)
  for(i = 0; i < N; i++){
    18a0:	fe042623          	sw	zero,-20(s0)
    18a4:	a099                	j	18ea <createtest+0x62>
    name[1] = '0' + i;
    18a6:	fec42783          	lw	a5,-20(s0)
    18aa:	0ff7f793          	zext.b	a5,a5
    18ae:	0307879b          	addiw	a5,a5,48
    18b2:	0ff7f793          	zext.b	a5,a5
    18b6:	fef400a3          	sb	a5,-31(s0)
    fd = open(name, O_CREATE|O_RDWR);
    18ba:	fe040793          	addi	a5,s0,-32
    18be:	20200593          	li	a1,514
    18c2:	853e                	mv	a0,a5
    18c4:	00006097          	auipc	ra,0x6
    18c8:	fd0080e7          	jalr	-48(ra) # 7894 <open>
    18cc:	87aa                	mv	a5,a0
    18ce:	fef42423          	sw	a5,-24(s0)
    close(fd);
    18d2:	fe842783          	lw	a5,-24(s0)
    18d6:	853e                	mv	a0,a5
    18d8:	00006097          	auipc	ra,0x6
    18dc:	fa4080e7          	jalr	-92(ra) # 787c <close>
  for(i = 0; i < N; i++){
    18e0:	fec42783          	lw	a5,-20(s0)
    18e4:	2785                	addiw	a5,a5,1
    18e6:	fef42623          	sw	a5,-20(s0)
    18ea:	fec42783          	lw	a5,-20(s0)
    18ee:	0007871b          	sext.w	a4,a5
    18f2:	03300793          	li	a5,51
    18f6:	fae7d8e3          	bge	a5,a4,18a6 <createtest+0x1e>
  }
  name[0] = 'a';
    18fa:	06100793          	li	a5,97
    18fe:	fef40023          	sb	a5,-32(s0)
  name[2] = '\0';
    1902:	fe040123          	sb	zero,-30(s0)
  for(i = 0; i < N; i++){
    1906:	fe042623          	sw	zero,-20(s0)
    190a:	a03d                	j	1938 <createtest+0xb0>
    name[1] = '0' + i;
    190c:	fec42783          	lw	a5,-20(s0)
    1910:	0ff7f793          	zext.b	a5,a5
    1914:	0307879b          	addiw	a5,a5,48
    1918:	0ff7f793          	zext.b	a5,a5
    191c:	fef400a3          	sb	a5,-31(s0)
    unlink(name);
    1920:	fe040793          	addi	a5,s0,-32
    1924:	853e                	mv	a0,a5
    1926:	00006097          	auipc	ra,0x6
    192a:	f7e080e7          	jalr	-130(ra) # 78a4 <unlink>
  for(i = 0; i < N; i++){
    192e:	fec42783          	lw	a5,-20(s0)
    1932:	2785                	addiw	a5,a5,1
    1934:	fef42623          	sw	a5,-20(s0)
    1938:	fec42783          	lw	a5,-20(s0)
    193c:	0007871b          	sext.w	a4,a5
    1940:	03300793          	li	a5,51
    1944:	fce7d4e3          	bge	a5,a4,190c <createtest+0x84>
  }
}
    1948:	0001                	nop
    194a:	0001                	nop
    194c:	70a2                	ld	ra,40(sp)
    194e:	7402                	ld	s0,32(sp)
    1950:	6145                	addi	sp,sp,48
    1952:	8082                	ret

0000000000001954 <dirtest>:

void dirtest(char *s)
{
    1954:	1101                	addi	sp,sp,-32
    1956:	ec06                	sd	ra,24(sp)
    1958:	e822                	sd	s0,16(sp)
    195a:	1000                	addi	s0,sp,32
    195c:	fea43423          	sd	a0,-24(s0)
  if(mkdir("dir0") < 0){
    1960:	00007517          	auipc	a0,0x7
    1964:	f5050513          	addi	a0,a0,-176 # 88b0 <malloc+0x942>
    1968:	00006097          	auipc	ra,0x6
    196c:	f54080e7          	jalr	-172(ra) # 78bc <mkdir>
    1970:	87aa                	mv	a5,a0
    1972:	0207d163          	bgez	a5,1994 <dirtest+0x40>
    printf("%s: mkdir failed\n", s);
    1976:	fe843583          	ld	a1,-24(s0)
    197a:	00007517          	auipc	a0,0x7
    197e:	c0650513          	addi	a0,a0,-1018 # 8580 <malloc+0x612>
    1982:	00006097          	auipc	ra,0x6
    1986:	3fa080e7          	jalr	1018(ra) # 7d7c <printf>
    exit(1);
    198a:	4505                	li	a0,1
    198c:	00006097          	auipc	ra,0x6
    1990:	ec8080e7          	jalr	-312(ra) # 7854 <exit>
  }

  if(chdir("dir0") < 0){
    1994:	00007517          	auipc	a0,0x7
    1998:	f1c50513          	addi	a0,a0,-228 # 88b0 <malloc+0x942>
    199c:	00006097          	auipc	ra,0x6
    19a0:	f28080e7          	jalr	-216(ra) # 78c4 <chdir>
    19a4:	87aa                	mv	a5,a0
    19a6:	0207d163          	bgez	a5,19c8 <dirtest+0x74>
    printf("%s: chdir dir0 failed\n", s);
    19aa:	fe843583          	ld	a1,-24(s0)
    19ae:	00007517          	auipc	a0,0x7
    19b2:	f0a50513          	addi	a0,a0,-246 # 88b8 <malloc+0x94a>
    19b6:	00006097          	auipc	ra,0x6
    19ba:	3c6080e7          	jalr	966(ra) # 7d7c <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	00006097          	auipc	ra,0x6
    19c4:	e94080e7          	jalr	-364(ra) # 7854 <exit>
  }

  if(chdir("..") < 0){
    19c8:	00007517          	auipc	a0,0x7
    19cc:	f0850513          	addi	a0,a0,-248 # 88d0 <malloc+0x962>
    19d0:	00006097          	auipc	ra,0x6
    19d4:	ef4080e7          	jalr	-268(ra) # 78c4 <chdir>
    19d8:	87aa                	mv	a5,a0
    19da:	0207d163          	bgez	a5,19fc <dirtest+0xa8>
    printf("%s: chdir .. failed\n", s);
    19de:	fe843583          	ld	a1,-24(s0)
    19e2:	00007517          	auipc	a0,0x7
    19e6:	ef650513          	addi	a0,a0,-266 # 88d8 <malloc+0x96a>
    19ea:	00006097          	auipc	ra,0x6
    19ee:	392080e7          	jalr	914(ra) # 7d7c <printf>
    exit(1);
    19f2:	4505                	li	a0,1
    19f4:	00006097          	auipc	ra,0x6
    19f8:	e60080e7          	jalr	-416(ra) # 7854 <exit>
  }

  if(unlink("dir0") < 0){
    19fc:	00007517          	auipc	a0,0x7
    1a00:	eb450513          	addi	a0,a0,-332 # 88b0 <malloc+0x942>
    1a04:	00006097          	auipc	ra,0x6
    1a08:	ea0080e7          	jalr	-352(ra) # 78a4 <unlink>
    1a0c:	87aa                	mv	a5,a0
    1a0e:	0207d163          	bgez	a5,1a30 <dirtest+0xdc>
    printf("%s: unlink dir0 failed\n", s);
    1a12:	fe843583          	ld	a1,-24(s0)
    1a16:	00007517          	auipc	a0,0x7
    1a1a:	eda50513          	addi	a0,a0,-294 # 88f0 <malloc+0x982>
    1a1e:	00006097          	auipc	ra,0x6
    1a22:	35e080e7          	jalr	862(ra) # 7d7c <printf>
    exit(1);
    1a26:	4505                	li	a0,1
    1a28:	00006097          	auipc	ra,0x6
    1a2c:	e2c080e7          	jalr	-468(ra) # 7854 <exit>
  }
}
    1a30:	0001                	nop
    1a32:	60e2                	ld	ra,24(sp)
    1a34:	6442                	ld	s0,16(sp)
    1a36:	6105                	addi	sp,sp,32
    1a38:	8082                	ret

0000000000001a3a <exectest>:

void
exectest(char *s)
{
    1a3a:	715d                	addi	sp,sp,-80
    1a3c:	e486                	sd	ra,72(sp)
    1a3e:	e0a2                	sd	s0,64(sp)
    1a40:	0880                	addi	s0,sp,80
    1a42:	faa43c23          	sd	a0,-72(s0)
  int fd, xstatus, pid;
  char *echoargv[] = { "echo", "OK", 0 };
    1a46:	00007797          	auipc	a5,0x7
    1a4a:	88a78793          	addi	a5,a5,-1910 # 82d0 <malloc+0x362>
    1a4e:	fcf43423          	sd	a5,-56(s0)
    1a52:	00007797          	auipc	a5,0x7
    1a56:	eb678793          	addi	a5,a5,-330 # 8908 <malloc+0x99a>
    1a5a:	fcf43823          	sd	a5,-48(s0)
    1a5e:	fc043c23          	sd	zero,-40(s0)
  char buf[3];

  unlink("echo-ok");
    1a62:	00007517          	auipc	a0,0x7
    1a66:	eae50513          	addi	a0,a0,-338 # 8910 <malloc+0x9a2>
    1a6a:	00006097          	auipc	ra,0x6
    1a6e:	e3a080e7          	jalr	-454(ra) # 78a4 <unlink>
  pid = fork();
    1a72:	00006097          	auipc	ra,0x6
    1a76:	dda080e7          	jalr	-550(ra) # 784c <fork>
    1a7a:	87aa                	mv	a5,a0
    1a7c:	fef42623          	sw	a5,-20(s0)
  if(pid < 0) {
    1a80:	fec42783          	lw	a5,-20(s0)
    1a84:	2781                	sext.w	a5,a5
    1a86:	0207d163          	bgez	a5,1aa8 <exectest+0x6e>
     printf("%s: fork failed\n", s);
    1a8a:	fb843583          	ld	a1,-72(s0)
    1a8e:	00007517          	auipc	a0,0x7
    1a92:	a6250513          	addi	a0,a0,-1438 # 84f0 <malloc+0x582>
    1a96:	00006097          	auipc	ra,0x6
    1a9a:	2e6080e7          	jalr	742(ra) # 7d7c <printf>
     exit(1);
    1a9e:	4505                	li	a0,1
    1aa0:	00006097          	auipc	ra,0x6
    1aa4:	db4080e7          	jalr	-588(ra) # 7854 <exit>
  }
  if(pid == 0) {
    1aa8:	fec42783          	lw	a5,-20(s0)
    1aac:	2781                	sext.w	a5,a5
    1aae:	ebd5                	bnez	a5,1b62 <exectest+0x128>
    close(1);
    1ab0:	4505                	li	a0,1
    1ab2:	00006097          	auipc	ra,0x6
    1ab6:	dca080e7          	jalr	-566(ra) # 787c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1aba:	20100593          	li	a1,513
    1abe:	00007517          	auipc	a0,0x7
    1ac2:	e5250513          	addi	a0,a0,-430 # 8910 <malloc+0x9a2>
    1ac6:	00006097          	auipc	ra,0x6
    1aca:	dce080e7          	jalr	-562(ra) # 7894 <open>
    1ace:	87aa                	mv	a5,a0
    1ad0:	fef42423          	sw	a5,-24(s0)
    if(fd < 0) {
    1ad4:	fe842783          	lw	a5,-24(s0)
    1ad8:	2781                	sext.w	a5,a5
    1ada:	0207d163          	bgez	a5,1afc <exectest+0xc2>
      printf("%s: create failed\n", s);
    1ade:	fb843583          	ld	a1,-72(s0)
    1ae2:	00007517          	auipc	a0,0x7
    1ae6:	e3650513          	addi	a0,a0,-458 # 8918 <malloc+0x9aa>
    1aea:	00006097          	auipc	ra,0x6
    1aee:	292080e7          	jalr	658(ra) # 7d7c <printf>
      exit(1);
    1af2:	4505                	li	a0,1
    1af4:	00006097          	auipc	ra,0x6
    1af8:	d60080e7          	jalr	-672(ra) # 7854 <exit>
    }
    if(fd != 1) {
    1afc:	fe842783          	lw	a5,-24(s0)
    1b00:	0007871b          	sext.w	a4,a5
    1b04:	4785                	li	a5,1
    1b06:	02f70163          	beq	a4,a5,1b28 <exectest+0xee>
      printf("%s: wrong fd\n", s);
    1b0a:	fb843583          	ld	a1,-72(s0)
    1b0e:	00007517          	auipc	a0,0x7
    1b12:	e2250513          	addi	a0,a0,-478 # 8930 <malloc+0x9c2>
    1b16:	00006097          	auipc	ra,0x6
    1b1a:	266080e7          	jalr	614(ra) # 7d7c <printf>
      exit(1);
    1b1e:	4505                	li	a0,1
    1b20:	00006097          	auipc	ra,0x6
    1b24:	d34080e7          	jalr	-716(ra) # 7854 <exit>
    }
    if(exec("echo", echoargv) < 0){
    1b28:	fc840793          	addi	a5,s0,-56
    1b2c:	85be                	mv	a1,a5
    1b2e:	00006517          	auipc	a0,0x6
    1b32:	7a250513          	addi	a0,a0,1954 # 82d0 <malloc+0x362>
    1b36:	00006097          	auipc	ra,0x6
    1b3a:	d56080e7          	jalr	-682(ra) # 788c <exec>
    1b3e:	87aa                	mv	a5,a0
    1b40:	0207d163          	bgez	a5,1b62 <exectest+0x128>
      printf("%s: exec echo failed\n", s);
    1b44:	fb843583          	ld	a1,-72(s0)
    1b48:	00007517          	auipc	a0,0x7
    1b4c:	df850513          	addi	a0,a0,-520 # 8940 <malloc+0x9d2>
    1b50:	00006097          	auipc	ra,0x6
    1b54:	22c080e7          	jalr	556(ra) # 7d7c <printf>
      exit(1);
    1b58:	4505                	li	a0,1
    1b5a:	00006097          	auipc	ra,0x6
    1b5e:	cfa080e7          	jalr	-774(ra) # 7854 <exit>
    }
    // won't get to here
  }
  if (wait(&xstatus) != pid) {
    1b62:	fe440793          	addi	a5,s0,-28
    1b66:	853e                	mv	a0,a5
    1b68:	00006097          	auipc	ra,0x6
    1b6c:	cf4080e7          	jalr	-780(ra) # 785c <wait>
    1b70:	87aa                	mv	a5,a0
    1b72:	873e                	mv	a4,a5
    1b74:	fec42783          	lw	a5,-20(s0)
    1b78:	2781                	sext.w	a5,a5
    1b7a:	00e78c63          	beq	a5,a4,1b92 <exectest+0x158>
    printf("%s: wait failed!\n", s);
    1b7e:	fb843583          	ld	a1,-72(s0)
    1b82:	00007517          	auipc	a0,0x7
    1b86:	dd650513          	addi	a0,a0,-554 # 8958 <malloc+0x9ea>
    1b8a:	00006097          	auipc	ra,0x6
    1b8e:	1f2080e7          	jalr	498(ra) # 7d7c <printf>
  }
  if(xstatus != 0)
    1b92:	fe442783          	lw	a5,-28(s0)
    1b96:	cb81                	beqz	a5,1ba6 <exectest+0x16c>
    exit(xstatus);
    1b98:	fe442783          	lw	a5,-28(s0)
    1b9c:	853e                	mv	a0,a5
    1b9e:	00006097          	auipc	ra,0x6
    1ba2:	cb6080e7          	jalr	-842(ra) # 7854 <exit>

  fd = open("echo-ok", O_RDONLY);
    1ba6:	4581                	li	a1,0
    1ba8:	00007517          	auipc	a0,0x7
    1bac:	d6850513          	addi	a0,a0,-664 # 8910 <malloc+0x9a2>
    1bb0:	00006097          	auipc	ra,0x6
    1bb4:	ce4080e7          	jalr	-796(ra) # 7894 <open>
    1bb8:	87aa                	mv	a5,a0
    1bba:	fef42423          	sw	a5,-24(s0)
  if(fd < 0) {
    1bbe:	fe842783          	lw	a5,-24(s0)
    1bc2:	2781                	sext.w	a5,a5
    1bc4:	0207d163          	bgez	a5,1be6 <exectest+0x1ac>
    printf("%s: open failed\n", s);
    1bc8:	fb843583          	ld	a1,-72(s0)
    1bcc:	00007517          	auipc	a0,0x7
    1bd0:	93c50513          	addi	a0,a0,-1732 # 8508 <malloc+0x59a>
    1bd4:	00006097          	auipc	ra,0x6
    1bd8:	1a8080e7          	jalr	424(ra) # 7d7c <printf>
    exit(1);
    1bdc:	4505                	li	a0,1
    1bde:	00006097          	auipc	ra,0x6
    1be2:	c76080e7          	jalr	-906(ra) # 7854 <exit>
  }
  if (read(fd, buf, 2) != 2) {
    1be6:	fc040713          	addi	a4,s0,-64
    1bea:	fe842783          	lw	a5,-24(s0)
    1bee:	4609                	li	a2,2
    1bf0:	85ba                	mv	a1,a4
    1bf2:	853e                	mv	a0,a5
    1bf4:	00006097          	auipc	ra,0x6
    1bf8:	c78080e7          	jalr	-904(ra) # 786c <read>
    1bfc:	87aa                	mv	a5,a0
    1bfe:	873e                	mv	a4,a5
    1c00:	4789                	li	a5,2
    1c02:	02f70163          	beq	a4,a5,1c24 <exectest+0x1ea>
    printf("%s: read failed\n", s);
    1c06:	fb843583          	ld	a1,-72(s0)
    1c0a:	00007517          	auipc	a0,0x7
    1c0e:	b7e50513          	addi	a0,a0,-1154 # 8788 <malloc+0x81a>
    1c12:	00006097          	auipc	ra,0x6
    1c16:	16a080e7          	jalr	362(ra) # 7d7c <printf>
    exit(1);
    1c1a:	4505                	li	a0,1
    1c1c:	00006097          	auipc	ra,0x6
    1c20:	c38080e7          	jalr	-968(ra) # 7854 <exit>
  }
  unlink("echo-ok");
    1c24:	00007517          	auipc	a0,0x7
    1c28:	cec50513          	addi	a0,a0,-788 # 8910 <malloc+0x9a2>
    1c2c:	00006097          	auipc	ra,0x6
    1c30:	c78080e7          	jalr	-904(ra) # 78a4 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1c34:	fc044783          	lbu	a5,-64(s0)
    1c38:	873e                	mv	a4,a5
    1c3a:	04f00793          	li	a5,79
    1c3e:	00f71e63          	bne	a4,a5,1c5a <exectest+0x220>
    1c42:	fc144783          	lbu	a5,-63(s0)
    1c46:	873e                	mv	a4,a5
    1c48:	04b00793          	li	a5,75
    1c4c:	00f71763          	bne	a4,a5,1c5a <exectest+0x220>
    exit(0);
    1c50:	4501                	li	a0,0
    1c52:	00006097          	auipc	ra,0x6
    1c56:	c02080e7          	jalr	-1022(ra) # 7854 <exit>
  else {
    printf("%s: wrong output\n", s);
    1c5a:	fb843583          	ld	a1,-72(s0)
    1c5e:	00007517          	auipc	a0,0x7
    1c62:	d1250513          	addi	a0,a0,-750 # 8970 <malloc+0xa02>
    1c66:	00006097          	auipc	ra,0x6
    1c6a:	116080e7          	jalr	278(ra) # 7d7c <printf>
    exit(1);
    1c6e:	4505                	li	a0,1
    1c70:	00006097          	auipc	ra,0x6
    1c74:	be4080e7          	jalr	-1052(ra) # 7854 <exit>

0000000000001c78 <pipe1>:

// simple fork and pipe read/write

void
pipe1(char *s)
{
    1c78:	715d                	addi	sp,sp,-80
    1c7a:	e486                	sd	ra,72(sp)
    1c7c:	e0a2                	sd	s0,64(sp)
    1c7e:	0880                	addi	s0,sp,80
    1c80:	faa43c23          	sd	a0,-72(s0)
  int fds[2], pid, xstatus;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };

  if(pipe(fds) != 0){
    1c84:	fd040793          	addi	a5,s0,-48
    1c88:	853e                	mv	a0,a5
    1c8a:	00006097          	auipc	ra,0x6
    1c8e:	bda080e7          	jalr	-1062(ra) # 7864 <pipe>
    1c92:	87aa                	mv	a5,a0
    1c94:	c385                	beqz	a5,1cb4 <pipe1+0x3c>
    printf("%s: pipe() failed\n", s);
    1c96:	fb843583          	ld	a1,-72(s0)
    1c9a:	00007517          	auipc	a0,0x7
    1c9e:	cee50513          	addi	a0,a0,-786 # 8988 <malloc+0xa1a>
    1ca2:	00006097          	auipc	ra,0x6
    1ca6:	0da080e7          	jalr	218(ra) # 7d7c <printf>
    exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00006097          	auipc	ra,0x6
    1cb0:	ba8080e7          	jalr	-1112(ra) # 7854 <exit>
  }
  pid = fork();
    1cb4:	00006097          	auipc	ra,0x6
    1cb8:	b98080e7          	jalr	-1128(ra) # 784c <fork>
    1cbc:	87aa                	mv	a5,a0
    1cbe:	fcf42c23          	sw	a5,-40(s0)
  seq = 0;
    1cc2:	fe042623          	sw	zero,-20(s0)
  if(pid == 0){
    1cc6:	fd842783          	lw	a5,-40(s0)
    1cca:	2781                	sext.w	a5,a5
    1ccc:	efdd                	bnez	a5,1d8a <pipe1+0x112>
    close(fds[0]);
    1cce:	fd042783          	lw	a5,-48(s0)
    1cd2:	853e                	mv	a0,a5
    1cd4:	00006097          	auipc	ra,0x6
    1cd8:	ba8080e7          	jalr	-1112(ra) # 787c <close>
    for(n = 0; n < N; n++){
    1cdc:	fe042223          	sw	zero,-28(s0)
    1ce0:	a849                	j	1d72 <pipe1+0xfa>
      for(i = 0; i < SZ; i++)
    1ce2:	fe042423          	sw	zero,-24(s0)
    1ce6:	a03d                	j	1d14 <pipe1+0x9c>
        buf[i] = seq++;
    1ce8:	fec42783          	lw	a5,-20(s0)
    1cec:	0017871b          	addiw	a4,a5,1
    1cf0:	fee42623          	sw	a4,-20(s0)
    1cf4:	0ff7f713          	zext.b	a4,a5
    1cf8:	0000a697          	auipc	a3,0xa
    1cfc:	5e868693          	addi	a3,a3,1512 # c2e0 <buf>
    1d00:	fe842783          	lw	a5,-24(s0)
    1d04:	97b6                	add	a5,a5,a3
    1d06:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1d0a:	fe842783          	lw	a5,-24(s0)
    1d0e:	2785                	addiw	a5,a5,1
    1d10:	fef42423          	sw	a5,-24(s0)
    1d14:	fe842783          	lw	a5,-24(s0)
    1d18:	0007871b          	sext.w	a4,a5
    1d1c:	40800793          	li	a5,1032
    1d20:	fce7d4e3          	bge	a5,a4,1ce8 <pipe1+0x70>
      if(write(fds[1], buf, SZ) != SZ){
    1d24:	fd442783          	lw	a5,-44(s0)
    1d28:	40900613          	li	a2,1033
    1d2c:	0000a597          	auipc	a1,0xa
    1d30:	5b458593          	addi	a1,a1,1460 # c2e0 <buf>
    1d34:	853e                	mv	a0,a5
    1d36:	00006097          	auipc	ra,0x6
    1d3a:	b3e080e7          	jalr	-1218(ra) # 7874 <write>
    1d3e:	87aa                	mv	a5,a0
    1d40:	873e                	mv	a4,a5
    1d42:	40900793          	li	a5,1033
    1d46:	02f70163          	beq	a4,a5,1d68 <pipe1+0xf0>
        printf("%s: pipe1 oops 1\n", s);
    1d4a:	fb843583          	ld	a1,-72(s0)
    1d4e:	00007517          	auipc	a0,0x7
    1d52:	c5250513          	addi	a0,a0,-942 # 89a0 <malloc+0xa32>
    1d56:	00006097          	auipc	ra,0x6
    1d5a:	026080e7          	jalr	38(ra) # 7d7c <printf>
        exit(1);
    1d5e:	4505                	li	a0,1
    1d60:	00006097          	auipc	ra,0x6
    1d64:	af4080e7          	jalr	-1292(ra) # 7854 <exit>
    for(n = 0; n < N; n++){
    1d68:	fe442783          	lw	a5,-28(s0)
    1d6c:	2785                	addiw	a5,a5,1
    1d6e:	fef42223          	sw	a5,-28(s0)
    1d72:	fe442783          	lw	a5,-28(s0)
    1d76:	0007871b          	sext.w	a4,a5
    1d7a:	4791                	li	a5,4
    1d7c:	f6e7d3e3          	bge	a5,a4,1ce2 <pipe1+0x6a>
      }
    }
    exit(0);
    1d80:	4501                	li	a0,0
    1d82:	00006097          	auipc	ra,0x6
    1d86:	ad2080e7          	jalr	-1326(ra) # 7854 <exit>
  } else if(pid > 0){
    1d8a:	fd842783          	lw	a5,-40(s0)
    1d8e:	2781                	sext.w	a5,a5
    1d90:	12f05d63          	blez	a5,1eca <pipe1+0x252>
    close(fds[1]);
    1d94:	fd442783          	lw	a5,-44(s0)
    1d98:	853e                	mv	a0,a5
    1d9a:	00006097          	auipc	ra,0x6
    1d9e:	ae2080e7          	jalr	-1310(ra) # 787c <close>
    total = 0;
    1da2:	fc042e23          	sw	zero,-36(s0)
    cc = 1;
    1da6:	4785                	li	a5,1
    1da8:	fef42023          	sw	a5,-32(s0)
    while((n = read(fds[0], buf, cc)) > 0){
    1dac:	a859                	j	1e42 <pipe1+0x1ca>
      for(i = 0; i < n; i++){
    1dae:	fe042423          	sw	zero,-24(s0)
    1db2:	a881                	j	1e02 <pipe1+0x18a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1db4:	0000a717          	auipc	a4,0xa
    1db8:	52c70713          	addi	a4,a4,1324 # c2e0 <buf>
    1dbc:	fe842783          	lw	a5,-24(s0)
    1dc0:	97ba                	add	a5,a5,a4
    1dc2:	0007c783          	lbu	a5,0(a5)
    1dc6:	0007869b          	sext.w	a3,a5
    1dca:	fec42783          	lw	a5,-20(s0)
    1dce:	0017871b          	addiw	a4,a5,1
    1dd2:	fee42623          	sw	a4,-20(s0)
    1dd6:	0ff7f793          	zext.b	a5,a5
    1dda:	2781                	sext.w	a5,a5
    1ddc:	8736                	mv	a4,a3
    1dde:	00f70d63          	beq	a4,a5,1df8 <pipe1+0x180>
          printf("%s: pipe1 oops 2\n", s);
    1de2:	fb843583          	ld	a1,-72(s0)
    1de6:	00007517          	auipc	a0,0x7
    1dea:	bd250513          	addi	a0,a0,-1070 # 89b8 <malloc+0xa4a>
    1dee:	00006097          	auipc	ra,0x6
    1df2:	f8e080e7          	jalr	-114(ra) # 7d7c <printf>
          return;
    1df6:	a8cd                	j	1ee8 <pipe1+0x270>
      for(i = 0; i < n; i++){
    1df8:	fe842783          	lw	a5,-24(s0)
    1dfc:	2785                	addiw	a5,a5,1
    1dfe:	fef42423          	sw	a5,-24(s0)
    1e02:	fe842783          	lw	a5,-24(s0)
    1e06:	873e                	mv	a4,a5
    1e08:	fe442783          	lw	a5,-28(s0)
    1e0c:	2701                	sext.w	a4,a4
    1e0e:	2781                	sext.w	a5,a5
    1e10:	faf742e3          	blt	a4,a5,1db4 <pipe1+0x13c>
        }
      }
      total += n;
    1e14:	fdc42783          	lw	a5,-36(s0)
    1e18:	873e                	mv	a4,a5
    1e1a:	fe442783          	lw	a5,-28(s0)
    1e1e:	9fb9                	addw	a5,a5,a4
    1e20:	fcf42e23          	sw	a5,-36(s0)
      cc = cc * 2;
    1e24:	fe042783          	lw	a5,-32(s0)
    1e28:	0017979b          	slliw	a5,a5,0x1
    1e2c:	fef42023          	sw	a5,-32(s0)
      if(cc > sizeof(buf))
    1e30:	fe042783          	lw	a5,-32(s0)
    1e34:	873e                	mv	a4,a5
    1e36:	678d                	lui	a5,0x3
    1e38:	00e7f563          	bgeu	a5,a4,1e42 <pipe1+0x1ca>
        cc = sizeof(buf);
    1e3c:	678d                	lui	a5,0x3
    1e3e:	fef42023          	sw	a5,-32(s0)
    while((n = read(fds[0], buf, cc)) > 0){
    1e42:	fd042783          	lw	a5,-48(s0)
    1e46:	fe042703          	lw	a4,-32(s0)
    1e4a:	863a                	mv	a2,a4
    1e4c:	0000a597          	auipc	a1,0xa
    1e50:	49458593          	addi	a1,a1,1172 # c2e0 <buf>
    1e54:	853e                	mv	a0,a5
    1e56:	00006097          	auipc	ra,0x6
    1e5a:	a16080e7          	jalr	-1514(ra) # 786c <read>
    1e5e:	87aa                	mv	a5,a0
    1e60:	fef42223          	sw	a5,-28(s0)
    1e64:	fe442783          	lw	a5,-28(s0)
    1e68:	2781                	sext.w	a5,a5
    1e6a:	f4f042e3          	bgtz	a5,1dae <pipe1+0x136>
    }
    if(total != N * SZ){
    1e6e:	fdc42783          	lw	a5,-36(s0)
    1e72:	0007871b          	sext.w	a4,a5
    1e76:	6785                	lui	a5,0x1
    1e78:	42d78793          	addi	a5,a5,1069 # 142d <opentest+0x6f>
    1e7c:	02f70263          	beq	a4,a5,1ea0 <pipe1+0x228>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1e80:	fdc42783          	lw	a5,-36(s0)
    1e84:	85be                	mv	a1,a5
    1e86:	00007517          	auipc	a0,0x7
    1e8a:	b4a50513          	addi	a0,a0,-1206 # 89d0 <malloc+0xa62>
    1e8e:	00006097          	auipc	ra,0x6
    1e92:	eee080e7          	jalr	-274(ra) # 7d7c <printf>
      exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00006097          	auipc	ra,0x6
    1e9c:	9bc080e7          	jalr	-1604(ra) # 7854 <exit>
    }
    close(fds[0]);
    1ea0:	fd042783          	lw	a5,-48(s0)
    1ea4:	853e                	mv	a0,a5
    1ea6:	00006097          	auipc	ra,0x6
    1eaa:	9d6080e7          	jalr	-1578(ra) # 787c <close>
    wait(&xstatus);
    1eae:	fcc40793          	addi	a5,s0,-52
    1eb2:	853e                	mv	a0,a5
    1eb4:	00006097          	auipc	ra,0x6
    1eb8:	9a8080e7          	jalr	-1624(ra) # 785c <wait>
    exit(xstatus);
    1ebc:	fcc42783          	lw	a5,-52(s0)
    1ec0:	853e                	mv	a0,a5
    1ec2:	00006097          	auipc	ra,0x6
    1ec6:	992080e7          	jalr	-1646(ra) # 7854 <exit>
  } else {
    printf("%s: fork() failed\n", s);
    1eca:	fb843583          	ld	a1,-72(s0)
    1ece:	00007517          	auipc	a0,0x7
    1ed2:	b2250513          	addi	a0,a0,-1246 # 89f0 <malloc+0xa82>
    1ed6:	00006097          	auipc	ra,0x6
    1eda:	ea6080e7          	jalr	-346(ra) # 7d7c <printf>
    exit(1);
    1ede:	4505                	li	a0,1
    1ee0:	00006097          	auipc	ra,0x6
    1ee4:	974080e7          	jalr	-1676(ra) # 7854 <exit>
  }
}
    1ee8:	60a6                	ld	ra,72(sp)
    1eea:	6406                	ld	s0,64(sp)
    1eec:	6161                	addi	sp,sp,80
    1eee:	8082                	ret

0000000000001ef0 <killstatus>:


// test if child is killed (status = -1)
void
killstatus(char *s)
{
    1ef0:	7179                	addi	sp,sp,-48
    1ef2:	f406                	sd	ra,40(sp)
    1ef4:	f022                	sd	s0,32(sp)
    1ef6:	1800                	addi	s0,sp,48
    1ef8:	fca43c23          	sd	a0,-40(s0)
  int xst;

  for(int i = 0; i < 100; i++){
    1efc:	fe042623          	sw	zero,-20(s0)
    1f00:	a055                	j	1fa4 <killstatus+0xb4>
    int pid1 = fork();
    1f02:	00006097          	auipc	ra,0x6
    1f06:	94a080e7          	jalr	-1718(ra) # 784c <fork>
    1f0a:	87aa                	mv	a5,a0
    1f0c:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    1f10:	fe842783          	lw	a5,-24(s0)
    1f14:	2781                	sext.w	a5,a5
    1f16:	0207d163          	bgez	a5,1f38 <killstatus+0x48>
      printf("%s: fork failed\n", s);
    1f1a:	fd843583          	ld	a1,-40(s0)
    1f1e:	00006517          	auipc	a0,0x6
    1f22:	5d250513          	addi	a0,a0,1490 # 84f0 <malloc+0x582>
    1f26:	00006097          	auipc	ra,0x6
    1f2a:	e56080e7          	jalr	-426(ra) # 7d7c <printf>
      exit(1);
    1f2e:	4505                	li	a0,1
    1f30:	00006097          	auipc	ra,0x6
    1f34:	924080e7          	jalr	-1756(ra) # 7854 <exit>
    }
    if(pid1 == 0){
    1f38:	fe842783          	lw	a5,-24(s0)
    1f3c:	2781                	sext.w	a5,a5
    1f3e:	e791                	bnez	a5,1f4a <killstatus+0x5a>
      while(1) {
        getpid();
    1f40:	00006097          	auipc	ra,0x6
    1f44:	994080e7          	jalr	-1644(ra) # 78d4 <getpid>
    1f48:	bfe5                	j	1f40 <killstatus+0x50>
      }
      exit(0);
    }
    sleep(1);
    1f4a:	4505                	li	a0,1
    1f4c:	00006097          	auipc	ra,0x6
    1f50:	998080e7          	jalr	-1640(ra) # 78e4 <sleep>
    kill(pid1);
    1f54:	fe842783          	lw	a5,-24(s0)
    1f58:	853e                	mv	a0,a5
    1f5a:	00006097          	auipc	ra,0x6
    1f5e:	92a080e7          	jalr	-1750(ra) # 7884 <kill>
    wait(&xst);
    1f62:	fe440793          	addi	a5,s0,-28
    1f66:	853e                	mv	a0,a5
    1f68:	00006097          	auipc	ra,0x6
    1f6c:	8f4080e7          	jalr	-1804(ra) # 785c <wait>
    if(xst != -1) {
    1f70:	fe442783          	lw	a5,-28(s0)
    1f74:	873e                	mv	a4,a5
    1f76:	57fd                	li	a5,-1
    1f78:	02f70163          	beq	a4,a5,1f9a <killstatus+0xaa>
       printf("%s: status should be -1\n", s);
    1f7c:	fd843583          	ld	a1,-40(s0)
    1f80:	00007517          	auipc	a0,0x7
    1f84:	a8850513          	addi	a0,a0,-1400 # 8a08 <malloc+0xa9a>
    1f88:	00006097          	auipc	ra,0x6
    1f8c:	df4080e7          	jalr	-524(ra) # 7d7c <printf>
       exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00006097          	auipc	ra,0x6
    1f96:	8c2080e7          	jalr	-1854(ra) # 7854 <exit>
  for(int i = 0; i < 100; i++){
    1f9a:	fec42783          	lw	a5,-20(s0)
    1f9e:	2785                	addiw	a5,a5,1
    1fa0:	fef42623          	sw	a5,-20(s0)
    1fa4:	fec42783          	lw	a5,-20(s0)
    1fa8:	0007871b          	sext.w	a4,a5
    1fac:	06300793          	li	a5,99
    1fb0:	f4e7d9e3          	bge	a5,a4,1f02 <killstatus+0x12>
    }
  }
  exit(0);
    1fb4:	4501                	li	a0,0
    1fb6:	00006097          	auipc	ra,0x6
    1fba:	89e080e7          	jalr	-1890(ra) # 7854 <exit>

0000000000001fbe <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(char *s)
{
    1fbe:	7139                	addi	sp,sp,-64
    1fc0:	fc06                	sd	ra,56(sp)
    1fc2:	f822                	sd	s0,48(sp)
    1fc4:	0080                	addi	s0,sp,64
    1fc6:	fca43423          	sd	a0,-56(s0)
  int pid1, pid2, pid3;
  int pfds[2];

  pid1 = fork();
    1fca:	00006097          	auipc	ra,0x6
    1fce:	882080e7          	jalr	-1918(ra) # 784c <fork>
    1fd2:	87aa                	mv	a5,a0
    1fd4:	fef42623          	sw	a5,-20(s0)
  if(pid1 < 0) {
    1fd8:	fec42783          	lw	a5,-20(s0)
    1fdc:	2781                	sext.w	a5,a5
    1fde:	0207d163          	bgez	a5,2000 <preempt+0x42>
    printf("%s: fork failed", s);
    1fe2:	fc843583          	ld	a1,-56(s0)
    1fe6:	00007517          	auipc	a0,0x7
    1fea:	a4250513          	addi	a0,a0,-1470 # 8a28 <malloc+0xaba>
    1fee:	00006097          	auipc	ra,0x6
    1ff2:	d8e080e7          	jalr	-626(ra) # 7d7c <printf>
    exit(1);
    1ff6:	4505                	li	a0,1
    1ff8:	00006097          	auipc	ra,0x6
    1ffc:	85c080e7          	jalr	-1956(ra) # 7854 <exit>
  }
  if(pid1 == 0)
    2000:	fec42783          	lw	a5,-20(s0)
    2004:	2781                	sext.w	a5,a5
    2006:	e399                	bnez	a5,200c <preempt+0x4e>
    for(;;)
    2008:	0001                	nop
    200a:	bffd                	j	2008 <preempt+0x4a>
      ;

  pid2 = fork();
    200c:	00006097          	auipc	ra,0x6
    2010:	840080e7          	jalr	-1984(ra) # 784c <fork>
    2014:	87aa                	mv	a5,a0
    2016:	fef42423          	sw	a5,-24(s0)
  if(pid2 < 0) {
    201a:	fe842783          	lw	a5,-24(s0)
    201e:	2781                	sext.w	a5,a5
    2020:	0207d163          	bgez	a5,2042 <preempt+0x84>
    printf("%s: fork failed\n", s);
    2024:	fc843583          	ld	a1,-56(s0)
    2028:	00006517          	auipc	a0,0x6
    202c:	4c850513          	addi	a0,a0,1224 # 84f0 <malloc+0x582>
    2030:	00006097          	auipc	ra,0x6
    2034:	d4c080e7          	jalr	-692(ra) # 7d7c <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00006097          	auipc	ra,0x6
    203e:	81a080e7          	jalr	-2022(ra) # 7854 <exit>
  }
  if(pid2 == 0)
    2042:	fe842783          	lw	a5,-24(s0)
    2046:	2781                	sext.w	a5,a5
    2048:	e399                	bnez	a5,204e <preempt+0x90>
    for(;;)
    204a:	0001                	nop
    204c:	bffd                	j	204a <preempt+0x8c>
      ;

  pipe(pfds);
    204e:	fd840793          	addi	a5,s0,-40
    2052:	853e                	mv	a0,a5
    2054:	00006097          	auipc	ra,0x6
    2058:	810080e7          	jalr	-2032(ra) # 7864 <pipe>
  pid3 = fork();
    205c:	00005097          	auipc	ra,0x5
    2060:	7f0080e7          	jalr	2032(ra) # 784c <fork>
    2064:	87aa                	mv	a5,a0
    2066:	fef42223          	sw	a5,-28(s0)
  if(pid3 < 0) {
    206a:	fe442783          	lw	a5,-28(s0)
    206e:	2781                	sext.w	a5,a5
    2070:	0207d163          	bgez	a5,2092 <preempt+0xd4>
     printf("%s: fork failed\n", s);
    2074:	fc843583          	ld	a1,-56(s0)
    2078:	00006517          	auipc	a0,0x6
    207c:	47850513          	addi	a0,a0,1144 # 84f0 <malloc+0x582>
    2080:	00006097          	auipc	ra,0x6
    2084:	cfc080e7          	jalr	-772(ra) # 7d7c <printf>
     exit(1);
    2088:	4505                	li	a0,1
    208a:	00005097          	auipc	ra,0x5
    208e:	7ca080e7          	jalr	1994(ra) # 7854 <exit>
  }
  if(pid3 == 0){
    2092:	fe442783          	lw	a5,-28(s0)
    2096:	2781                	sext.w	a5,a5
    2098:	efa1                	bnez	a5,20f0 <preempt+0x132>
    close(pfds[0]);
    209a:	fd842783          	lw	a5,-40(s0)
    209e:	853e                	mv	a0,a5
    20a0:	00005097          	auipc	ra,0x5
    20a4:	7dc080e7          	jalr	2012(ra) # 787c <close>
    if(write(pfds[1], "x", 1) != 1)
    20a8:	fdc42783          	lw	a5,-36(s0)
    20ac:	4605                	li	a2,1
    20ae:	00006597          	auipc	a1,0x6
    20b2:	11258593          	addi	a1,a1,274 # 81c0 <malloc+0x252>
    20b6:	853e                	mv	a0,a5
    20b8:	00005097          	auipc	ra,0x5
    20bc:	7bc080e7          	jalr	1980(ra) # 7874 <write>
    20c0:	87aa                	mv	a5,a0
    20c2:	873e                	mv	a4,a5
    20c4:	4785                	li	a5,1
    20c6:	00f70c63          	beq	a4,a5,20de <preempt+0x120>
      printf("%s: preempt write error", s);
    20ca:	fc843583          	ld	a1,-56(s0)
    20ce:	00007517          	auipc	a0,0x7
    20d2:	96a50513          	addi	a0,a0,-1686 # 8a38 <malloc+0xaca>
    20d6:	00006097          	auipc	ra,0x6
    20da:	ca6080e7          	jalr	-858(ra) # 7d7c <printf>
    close(pfds[1]);
    20de:	fdc42783          	lw	a5,-36(s0)
    20e2:	853e                	mv	a0,a5
    20e4:	00005097          	auipc	ra,0x5
    20e8:	798080e7          	jalr	1944(ra) # 787c <close>
    for(;;)
    20ec:	0001                	nop
    20ee:	bffd                	j	20ec <preempt+0x12e>
      ;
  }

  close(pfds[1]);
    20f0:	fdc42783          	lw	a5,-36(s0)
    20f4:	853e                	mv	a0,a5
    20f6:	00005097          	auipc	ra,0x5
    20fa:	786080e7          	jalr	1926(ra) # 787c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    20fe:	fd842783          	lw	a5,-40(s0)
    2102:	660d                	lui	a2,0x3
    2104:	0000a597          	auipc	a1,0xa
    2108:	1dc58593          	addi	a1,a1,476 # c2e0 <buf>
    210c:	853e                	mv	a0,a5
    210e:	00005097          	auipc	ra,0x5
    2112:	75e080e7          	jalr	1886(ra) # 786c <read>
    2116:	87aa                	mv	a5,a0
    2118:	873e                	mv	a4,a5
    211a:	4785                	li	a5,1
    211c:	00f70d63          	beq	a4,a5,2136 <preempt+0x178>
    printf("%s: preempt read error", s);
    2120:	fc843583          	ld	a1,-56(s0)
    2124:	00007517          	auipc	a0,0x7
    2128:	92c50513          	addi	a0,a0,-1748 # 8a50 <malloc+0xae2>
    212c:	00006097          	auipc	ra,0x6
    2130:	c50080e7          	jalr	-944(ra) # 7d7c <printf>
    2134:	a8a5                	j	21ac <preempt+0x1ee>
    return;
  }
  close(pfds[0]);
    2136:	fd842783          	lw	a5,-40(s0)
    213a:	853e                	mv	a0,a5
    213c:	00005097          	auipc	ra,0x5
    2140:	740080e7          	jalr	1856(ra) # 787c <close>
  printf("kill... ");
    2144:	00007517          	auipc	a0,0x7
    2148:	92450513          	addi	a0,a0,-1756 # 8a68 <malloc+0xafa>
    214c:	00006097          	auipc	ra,0x6
    2150:	c30080e7          	jalr	-976(ra) # 7d7c <printf>
  kill(pid1);
    2154:	fec42783          	lw	a5,-20(s0)
    2158:	853e                	mv	a0,a5
    215a:	00005097          	auipc	ra,0x5
    215e:	72a080e7          	jalr	1834(ra) # 7884 <kill>
  kill(pid2);
    2162:	fe842783          	lw	a5,-24(s0)
    2166:	853e                	mv	a0,a5
    2168:	00005097          	auipc	ra,0x5
    216c:	71c080e7          	jalr	1820(ra) # 7884 <kill>
  kill(pid3);
    2170:	fe442783          	lw	a5,-28(s0)
    2174:	853e                	mv	a0,a5
    2176:	00005097          	auipc	ra,0x5
    217a:	70e080e7          	jalr	1806(ra) # 7884 <kill>
  printf("wait... ");
    217e:	00007517          	auipc	a0,0x7
    2182:	8fa50513          	addi	a0,a0,-1798 # 8a78 <malloc+0xb0a>
    2186:	00006097          	auipc	ra,0x6
    218a:	bf6080e7          	jalr	-1034(ra) # 7d7c <printf>
  wait(0);
    218e:	4501                	li	a0,0
    2190:	00005097          	auipc	ra,0x5
    2194:	6cc080e7          	jalr	1740(ra) # 785c <wait>
  wait(0);
    2198:	4501                	li	a0,0
    219a:	00005097          	auipc	ra,0x5
    219e:	6c2080e7          	jalr	1730(ra) # 785c <wait>
  wait(0);
    21a2:	4501                	li	a0,0
    21a4:	00005097          	auipc	ra,0x5
    21a8:	6b8080e7          	jalr	1720(ra) # 785c <wait>
}
    21ac:	70e2                	ld	ra,56(sp)
    21ae:	7442                	ld	s0,48(sp)
    21b0:	6121                	addi	sp,sp,64
    21b2:	8082                	ret

00000000000021b4 <exitwait>:

// try to find any races between exit and wait
void
exitwait(char *s)
{
    21b4:	7179                	addi	sp,sp,-48
    21b6:	f406                	sd	ra,40(sp)
    21b8:	f022                	sd	s0,32(sp)
    21ba:	1800                	addi	s0,sp,48
    21bc:	fca43c23          	sd	a0,-40(s0)
  int i, pid;

  for(i = 0; i < 100; i++){
    21c0:	fe042623          	sw	zero,-20(s0)
    21c4:	a87d                	j	2282 <exitwait+0xce>
    pid = fork();
    21c6:	00005097          	auipc	ra,0x5
    21ca:	686080e7          	jalr	1670(ra) # 784c <fork>
    21ce:	87aa                	mv	a5,a0
    21d0:	fef42423          	sw	a5,-24(s0)
    if(pid < 0){
    21d4:	fe842783          	lw	a5,-24(s0)
    21d8:	2781                	sext.w	a5,a5
    21da:	0207d163          	bgez	a5,21fc <exitwait+0x48>
      printf("%s: fork failed\n", s);
    21de:	fd843583          	ld	a1,-40(s0)
    21e2:	00006517          	auipc	a0,0x6
    21e6:	30e50513          	addi	a0,a0,782 # 84f0 <malloc+0x582>
    21ea:	00006097          	auipc	ra,0x6
    21ee:	b92080e7          	jalr	-1134(ra) # 7d7c <printf>
      exit(1);
    21f2:	4505                	li	a0,1
    21f4:	00005097          	auipc	ra,0x5
    21f8:	660080e7          	jalr	1632(ra) # 7854 <exit>
    }
    if(pid){
    21fc:	fe842783          	lw	a5,-24(s0)
    2200:	2781                	sext.w	a5,a5
    2202:	c7a5                	beqz	a5,226a <exitwait+0xb6>
      int xstate;
      if(wait(&xstate) != pid){
    2204:	fe440793          	addi	a5,s0,-28
    2208:	853e                	mv	a0,a5
    220a:	00005097          	auipc	ra,0x5
    220e:	652080e7          	jalr	1618(ra) # 785c <wait>
    2212:	87aa                	mv	a5,a0
    2214:	873e                	mv	a4,a5
    2216:	fe842783          	lw	a5,-24(s0)
    221a:	2781                	sext.w	a5,a5
    221c:	02e78163          	beq	a5,a4,223e <exitwait+0x8a>
        printf("%s: wait wrong pid\n", s);
    2220:	fd843583          	ld	a1,-40(s0)
    2224:	00007517          	auipc	a0,0x7
    2228:	86450513          	addi	a0,a0,-1948 # 8a88 <malloc+0xb1a>
    222c:	00006097          	auipc	ra,0x6
    2230:	b50080e7          	jalr	-1200(ra) # 7d7c <printf>
        exit(1);
    2234:	4505                	li	a0,1
    2236:	00005097          	auipc	ra,0x5
    223a:	61e080e7          	jalr	1566(ra) # 7854 <exit>
      }
      if(i != xstate) {
    223e:	fe442703          	lw	a4,-28(s0)
    2242:	fec42783          	lw	a5,-20(s0)
    2246:	2781                	sext.w	a5,a5
    2248:	02e78863          	beq	a5,a4,2278 <exitwait+0xc4>
        printf("%s: wait wrong exit status\n", s);
    224c:	fd843583          	ld	a1,-40(s0)
    2250:	00007517          	auipc	a0,0x7
    2254:	85050513          	addi	a0,a0,-1968 # 8aa0 <malloc+0xb32>
    2258:	00006097          	auipc	ra,0x6
    225c:	b24080e7          	jalr	-1244(ra) # 7d7c <printf>
        exit(1);
    2260:	4505                	li	a0,1
    2262:	00005097          	auipc	ra,0x5
    2266:	5f2080e7          	jalr	1522(ra) # 7854 <exit>
      }
    } else {
      exit(i);
    226a:	fec42783          	lw	a5,-20(s0)
    226e:	853e                	mv	a0,a5
    2270:	00005097          	auipc	ra,0x5
    2274:	5e4080e7          	jalr	1508(ra) # 7854 <exit>
  for(i = 0; i < 100; i++){
    2278:	fec42783          	lw	a5,-20(s0)
    227c:	2785                	addiw	a5,a5,1
    227e:	fef42623          	sw	a5,-20(s0)
    2282:	fec42783          	lw	a5,-20(s0)
    2286:	0007871b          	sext.w	a4,a5
    228a:	06300793          	li	a5,99
    228e:	f2e7dce3          	bge	a5,a4,21c6 <exitwait+0x12>
    }
  }
}
    2292:	0001                	nop
    2294:	0001                	nop
    2296:	70a2                	ld	ra,40(sp)
    2298:	7402                	ld	s0,32(sp)
    229a:	6145                	addi	sp,sp,48
    229c:	8082                	ret

000000000000229e <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(char *s)
{
    229e:	7179                	addi	sp,sp,-48
    22a0:	f406                	sd	ra,40(sp)
    22a2:	f022                	sd	s0,32(sp)
    22a4:	1800                	addi	s0,sp,48
    22a6:	fca43c23          	sd	a0,-40(s0)
  int master_pid = getpid();
    22aa:	00005097          	auipc	ra,0x5
    22ae:	62a080e7          	jalr	1578(ra) # 78d4 <getpid>
    22b2:	87aa                	mv	a5,a0
    22b4:	fef42423          	sw	a5,-24(s0)
  for(int i = 0; i < 200; i++){
    22b8:	fe042623          	sw	zero,-20(s0)
    22bc:	a86d                	j	2376 <reparent+0xd8>
    int pid = fork();
    22be:	00005097          	auipc	ra,0x5
    22c2:	58e080e7          	jalr	1422(ra) # 784c <fork>
    22c6:	87aa                	mv	a5,a0
    22c8:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    22cc:	fe442783          	lw	a5,-28(s0)
    22d0:	2781                	sext.w	a5,a5
    22d2:	0207d163          	bgez	a5,22f4 <reparent+0x56>
      printf("%s: fork failed\n", s);
    22d6:	fd843583          	ld	a1,-40(s0)
    22da:	00006517          	auipc	a0,0x6
    22de:	21650513          	addi	a0,a0,534 # 84f0 <malloc+0x582>
    22e2:	00006097          	auipc	ra,0x6
    22e6:	a9a080e7          	jalr	-1382(ra) # 7d7c <printf>
      exit(1);
    22ea:	4505                	li	a0,1
    22ec:	00005097          	auipc	ra,0x5
    22f0:	568080e7          	jalr	1384(ra) # 7854 <exit>
    }
    if(pid){
    22f4:	fe442783          	lw	a5,-28(s0)
    22f8:	2781                	sext.w	a5,a5
    22fa:	cf85                	beqz	a5,2332 <reparent+0x94>
      if(wait(0) != pid){
    22fc:	4501                	li	a0,0
    22fe:	00005097          	auipc	ra,0x5
    2302:	55e080e7          	jalr	1374(ra) # 785c <wait>
    2306:	87aa                	mv	a5,a0
    2308:	873e                	mv	a4,a5
    230a:	fe442783          	lw	a5,-28(s0)
    230e:	2781                	sext.w	a5,a5
    2310:	04e78e63          	beq	a5,a4,236c <reparent+0xce>
        printf("%s: wait wrong pid\n", s);
    2314:	fd843583          	ld	a1,-40(s0)
    2318:	00006517          	auipc	a0,0x6
    231c:	77050513          	addi	a0,a0,1904 # 8a88 <malloc+0xb1a>
    2320:	00006097          	auipc	ra,0x6
    2324:	a5c080e7          	jalr	-1444(ra) # 7d7c <printf>
        exit(1);
    2328:	4505                	li	a0,1
    232a:	00005097          	auipc	ra,0x5
    232e:	52a080e7          	jalr	1322(ra) # 7854 <exit>
      }
    } else {
      int pid2 = fork();
    2332:	00005097          	auipc	ra,0x5
    2336:	51a080e7          	jalr	1306(ra) # 784c <fork>
    233a:	87aa                	mv	a5,a0
    233c:	fef42023          	sw	a5,-32(s0)
      if(pid2 < 0){
    2340:	fe042783          	lw	a5,-32(s0)
    2344:	2781                	sext.w	a5,a5
    2346:	0007de63          	bgez	a5,2362 <reparent+0xc4>
        kill(master_pid);
    234a:	fe842783          	lw	a5,-24(s0)
    234e:	853e                	mv	a0,a5
    2350:	00005097          	auipc	ra,0x5
    2354:	534080e7          	jalr	1332(ra) # 7884 <kill>
        exit(1);
    2358:	4505                	li	a0,1
    235a:	00005097          	auipc	ra,0x5
    235e:	4fa080e7          	jalr	1274(ra) # 7854 <exit>
      }
      exit(0);
    2362:	4501                	li	a0,0
    2364:	00005097          	auipc	ra,0x5
    2368:	4f0080e7          	jalr	1264(ra) # 7854 <exit>
  for(int i = 0; i < 200; i++){
    236c:	fec42783          	lw	a5,-20(s0)
    2370:	2785                	addiw	a5,a5,1
    2372:	fef42623          	sw	a5,-20(s0)
    2376:	fec42783          	lw	a5,-20(s0)
    237a:	0007871b          	sext.w	a4,a5
    237e:	0c700793          	li	a5,199
    2382:	f2e7dee3          	bge	a5,a4,22be <reparent+0x20>
    }
  }
  exit(0);
    2386:	4501                	li	a0,0
    2388:	00005097          	auipc	ra,0x5
    238c:	4cc080e7          	jalr	1228(ra) # 7854 <exit>

0000000000002390 <twochildren>:
}

// what if two children exit() at the same time?
void
twochildren(char *s)
{
    2390:	7179                	addi	sp,sp,-48
    2392:	f406                	sd	ra,40(sp)
    2394:	f022                	sd	s0,32(sp)
    2396:	1800                	addi	s0,sp,48
    2398:	fca43c23          	sd	a0,-40(s0)
  for(int i = 0; i < 1000; i++){
    239c:	fe042623          	sw	zero,-20(s0)
    23a0:	a845                	j	2450 <twochildren+0xc0>
    int pid1 = fork();
    23a2:	00005097          	auipc	ra,0x5
    23a6:	4aa080e7          	jalr	1194(ra) # 784c <fork>
    23aa:	87aa                	mv	a5,a0
    23ac:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    23b0:	fe842783          	lw	a5,-24(s0)
    23b4:	2781                	sext.w	a5,a5
    23b6:	0207d163          	bgez	a5,23d8 <twochildren+0x48>
      printf("%s: fork failed\n", s);
    23ba:	fd843583          	ld	a1,-40(s0)
    23be:	00006517          	auipc	a0,0x6
    23c2:	13250513          	addi	a0,a0,306 # 84f0 <malloc+0x582>
    23c6:	00006097          	auipc	ra,0x6
    23ca:	9b6080e7          	jalr	-1610(ra) # 7d7c <printf>
      exit(1);
    23ce:	4505                	li	a0,1
    23d0:	00005097          	auipc	ra,0x5
    23d4:	484080e7          	jalr	1156(ra) # 7854 <exit>
    }
    if(pid1 == 0){
    23d8:	fe842783          	lw	a5,-24(s0)
    23dc:	2781                	sext.w	a5,a5
    23de:	e791                	bnez	a5,23ea <twochildren+0x5a>
      exit(0);
    23e0:	4501                	li	a0,0
    23e2:	00005097          	auipc	ra,0x5
    23e6:	472080e7          	jalr	1138(ra) # 7854 <exit>
    } else {
      int pid2 = fork();
    23ea:	00005097          	auipc	ra,0x5
    23ee:	462080e7          	jalr	1122(ra) # 784c <fork>
    23f2:	87aa                	mv	a5,a0
    23f4:	fef42223          	sw	a5,-28(s0)
      if(pid2 < 0){
    23f8:	fe442783          	lw	a5,-28(s0)
    23fc:	2781                	sext.w	a5,a5
    23fe:	0207d163          	bgez	a5,2420 <twochildren+0x90>
        printf("%s: fork failed\n", s);
    2402:	fd843583          	ld	a1,-40(s0)
    2406:	00006517          	auipc	a0,0x6
    240a:	0ea50513          	addi	a0,a0,234 # 84f0 <malloc+0x582>
    240e:	00006097          	auipc	ra,0x6
    2412:	96e080e7          	jalr	-1682(ra) # 7d7c <printf>
        exit(1);
    2416:	4505                	li	a0,1
    2418:	00005097          	auipc	ra,0x5
    241c:	43c080e7          	jalr	1084(ra) # 7854 <exit>
      }
      if(pid2 == 0){
    2420:	fe442783          	lw	a5,-28(s0)
    2424:	2781                	sext.w	a5,a5
    2426:	e791                	bnez	a5,2432 <twochildren+0xa2>
        exit(0);
    2428:	4501                	li	a0,0
    242a:	00005097          	auipc	ra,0x5
    242e:	42a080e7          	jalr	1066(ra) # 7854 <exit>
      } else {
        wait(0);
    2432:	4501                	li	a0,0
    2434:	00005097          	auipc	ra,0x5
    2438:	428080e7          	jalr	1064(ra) # 785c <wait>
        wait(0);
    243c:	4501                	li	a0,0
    243e:	00005097          	auipc	ra,0x5
    2442:	41e080e7          	jalr	1054(ra) # 785c <wait>
  for(int i = 0; i < 1000; i++){
    2446:	fec42783          	lw	a5,-20(s0)
    244a:	2785                	addiw	a5,a5,1
    244c:	fef42623          	sw	a5,-20(s0)
    2450:	fec42783          	lw	a5,-20(s0)
    2454:	0007871b          	sext.w	a4,a5
    2458:	3e700793          	li	a5,999
    245c:	f4e7d3e3          	bge	a5,a4,23a2 <twochildren+0x12>
      }
    }
  }
}
    2460:	0001                	nop
    2462:	0001                	nop
    2464:	70a2                	ld	ra,40(sp)
    2466:	7402                	ld	s0,32(sp)
    2468:	6145                	addi	sp,sp,48
    246a:	8082                	ret

000000000000246c <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(char *s)
{
    246c:	7139                	addi	sp,sp,-64
    246e:	fc06                	sd	ra,56(sp)
    2470:	f822                	sd	s0,48(sp)
    2472:	0080                	addi	s0,sp,64
    2474:	fca43423          	sd	a0,-56(s0)
  enum { N=2 };

  for(int i = 0; i < N; i++){
    2478:	fe042623          	sw	zero,-20(s0)
    247c:	a84d                	j	252e <forkfork+0xc2>
    int pid = fork();
    247e:	00005097          	auipc	ra,0x5
    2482:	3ce080e7          	jalr	974(ra) # 784c <fork>
    2486:	87aa                	mv	a5,a0
    2488:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    248c:	fe042783          	lw	a5,-32(s0)
    2490:	2781                	sext.w	a5,a5
    2492:	0207d163          	bgez	a5,24b4 <forkfork+0x48>
      printf("%s: fork failed", s);
    2496:	fc843583          	ld	a1,-56(s0)
    249a:	00006517          	auipc	a0,0x6
    249e:	58e50513          	addi	a0,a0,1422 # 8a28 <malloc+0xaba>
    24a2:	00006097          	auipc	ra,0x6
    24a6:	8da080e7          	jalr	-1830(ra) # 7d7c <printf>
      exit(1);
    24aa:	4505                	li	a0,1
    24ac:	00005097          	auipc	ra,0x5
    24b0:	3a8080e7          	jalr	936(ra) # 7854 <exit>
    }
    if(pid == 0){
    24b4:	fe042783          	lw	a5,-32(s0)
    24b8:	2781                	sext.w	a5,a5
    24ba:	e7ad                	bnez	a5,2524 <forkfork+0xb8>
      for(int j = 0; j < 200; j++){
    24bc:	fe042423          	sw	zero,-24(s0)
    24c0:	a0a9                	j	250a <forkfork+0x9e>
        int pid1 = fork();
    24c2:	00005097          	auipc	ra,0x5
    24c6:	38a080e7          	jalr	906(ra) # 784c <fork>
    24ca:	87aa                	mv	a5,a0
    24cc:	fcf42e23          	sw	a5,-36(s0)
        if(pid1 < 0){
    24d0:	fdc42783          	lw	a5,-36(s0)
    24d4:	2781                	sext.w	a5,a5
    24d6:	0007d763          	bgez	a5,24e4 <forkfork+0x78>
          exit(1);
    24da:	4505                	li	a0,1
    24dc:	00005097          	auipc	ra,0x5
    24e0:	378080e7          	jalr	888(ra) # 7854 <exit>
        }
        if(pid1 == 0){
    24e4:	fdc42783          	lw	a5,-36(s0)
    24e8:	2781                	sext.w	a5,a5
    24ea:	e791                	bnez	a5,24f6 <forkfork+0x8a>
          exit(0);
    24ec:	4501                	li	a0,0
    24ee:	00005097          	auipc	ra,0x5
    24f2:	366080e7          	jalr	870(ra) # 7854 <exit>
        }
        wait(0);
    24f6:	4501                	li	a0,0
    24f8:	00005097          	auipc	ra,0x5
    24fc:	364080e7          	jalr	868(ra) # 785c <wait>
      for(int j = 0; j < 200; j++){
    2500:	fe842783          	lw	a5,-24(s0)
    2504:	2785                	addiw	a5,a5,1
    2506:	fef42423          	sw	a5,-24(s0)
    250a:	fe842783          	lw	a5,-24(s0)
    250e:	0007871b          	sext.w	a4,a5
    2512:	0c700793          	li	a5,199
    2516:	fae7d6e3          	bge	a5,a4,24c2 <forkfork+0x56>
      }
      exit(0);
    251a:	4501                	li	a0,0
    251c:	00005097          	auipc	ra,0x5
    2520:	338080e7          	jalr	824(ra) # 7854 <exit>
  for(int i = 0; i < N; i++){
    2524:	fec42783          	lw	a5,-20(s0)
    2528:	2785                	addiw	a5,a5,1
    252a:	fef42623          	sw	a5,-20(s0)
    252e:	fec42783          	lw	a5,-20(s0)
    2532:	0007871b          	sext.w	a4,a5
    2536:	4785                	li	a5,1
    2538:	f4e7d3e3          	bge	a5,a4,247e <forkfork+0x12>
    }
  }

  int xstatus;
  for(int i = 0; i < N; i++){
    253c:	fe042223          	sw	zero,-28(s0)
    2540:	a83d                	j	257e <forkfork+0x112>
    wait(&xstatus);
    2542:	fd840793          	addi	a5,s0,-40
    2546:	853e                	mv	a0,a5
    2548:	00005097          	auipc	ra,0x5
    254c:	314080e7          	jalr	788(ra) # 785c <wait>
    if(xstatus != 0) {
    2550:	fd842783          	lw	a5,-40(s0)
    2554:	c385                	beqz	a5,2574 <forkfork+0x108>
      printf("%s: fork in child failed", s);
    2556:	fc843583          	ld	a1,-56(s0)
    255a:	00006517          	auipc	a0,0x6
    255e:	56650513          	addi	a0,a0,1382 # 8ac0 <malloc+0xb52>
    2562:	00006097          	auipc	ra,0x6
    2566:	81a080e7          	jalr	-2022(ra) # 7d7c <printf>
      exit(1);
    256a:	4505                	li	a0,1
    256c:	00005097          	auipc	ra,0x5
    2570:	2e8080e7          	jalr	744(ra) # 7854 <exit>
  for(int i = 0; i < N; i++){
    2574:	fe442783          	lw	a5,-28(s0)
    2578:	2785                	addiw	a5,a5,1
    257a:	fef42223          	sw	a5,-28(s0)
    257e:	fe442783          	lw	a5,-28(s0)
    2582:	0007871b          	sext.w	a4,a5
    2586:	4785                	li	a5,1
    2588:	fae7dde3          	bge	a5,a4,2542 <forkfork+0xd6>
    }
  }
}
    258c:	0001                	nop
    258e:	0001                	nop
    2590:	70e2                	ld	ra,56(sp)
    2592:	7442                	ld	s0,48(sp)
    2594:	6121                	addi	sp,sp,64
    2596:	8082                	ret

0000000000002598 <forkforkfork>:

void
forkforkfork(char *s)
{
    2598:	7179                	addi	sp,sp,-48
    259a:	f406                	sd	ra,40(sp)
    259c:	f022                	sd	s0,32(sp)
    259e:	1800                	addi	s0,sp,48
    25a0:	fca43c23          	sd	a0,-40(s0)
  unlink("stopforking");
    25a4:	00006517          	auipc	a0,0x6
    25a8:	53c50513          	addi	a0,a0,1340 # 8ae0 <malloc+0xb72>
    25ac:	00005097          	auipc	ra,0x5
    25b0:	2f8080e7          	jalr	760(ra) # 78a4 <unlink>

  int pid = fork();
    25b4:	00005097          	auipc	ra,0x5
    25b8:	298080e7          	jalr	664(ra) # 784c <fork>
    25bc:	87aa                	mv	a5,a0
    25be:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    25c2:	fec42783          	lw	a5,-20(s0)
    25c6:	2781                	sext.w	a5,a5
    25c8:	0207d163          	bgez	a5,25ea <forkforkfork+0x52>
    printf("%s: fork failed", s);
    25cc:	fd843583          	ld	a1,-40(s0)
    25d0:	00006517          	auipc	a0,0x6
    25d4:	45850513          	addi	a0,a0,1112 # 8a28 <malloc+0xaba>
    25d8:	00005097          	auipc	ra,0x5
    25dc:	7a4080e7          	jalr	1956(ra) # 7d7c <printf>
    exit(1);
    25e0:	4505                	li	a0,1
    25e2:	00005097          	auipc	ra,0x5
    25e6:	272080e7          	jalr	626(ra) # 7854 <exit>
  }
  if(pid == 0){
    25ea:	fec42783          	lw	a5,-20(s0)
    25ee:	2781                	sext.w	a5,a5
    25f0:	efb9                	bnez	a5,264e <forkforkfork+0xb6>
    while(1){
      int fd = open("stopforking", 0);
    25f2:	4581                	li	a1,0
    25f4:	00006517          	auipc	a0,0x6
    25f8:	4ec50513          	addi	a0,a0,1260 # 8ae0 <malloc+0xb72>
    25fc:	00005097          	auipc	ra,0x5
    2600:	298080e7          	jalr	664(ra) # 7894 <open>
    2604:	87aa                	mv	a5,a0
    2606:	fef42423          	sw	a5,-24(s0)
      if(fd >= 0){
    260a:	fe842783          	lw	a5,-24(s0)
    260e:	2781                	sext.w	a5,a5
    2610:	0007c763          	bltz	a5,261e <forkforkfork+0x86>
        exit(0);
    2614:	4501                	li	a0,0
    2616:	00005097          	auipc	ra,0x5
    261a:	23e080e7          	jalr	574(ra) # 7854 <exit>
      }
      if(fork() < 0){
    261e:	00005097          	auipc	ra,0x5
    2622:	22e080e7          	jalr	558(ra) # 784c <fork>
    2626:	87aa                	mv	a5,a0
    2628:	fc07d5e3          	bgez	a5,25f2 <forkforkfork+0x5a>
        close(open("stopforking", O_CREATE|O_RDWR));
    262c:	20200593          	li	a1,514
    2630:	00006517          	auipc	a0,0x6
    2634:	4b050513          	addi	a0,a0,1200 # 8ae0 <malloc+0xb72>
    2638:	00005097          	auipc	ra,0x5
    263c:	25c080e7          	jalr	604(ra) # 7894 <open>
    2640:	87aa                	mv	a5,a0
    2642:	853e                	mv	a0,a5
    2644:	00005097          	auipc	ra,0x5
    2648:	238080e7          	jalr	568(ra) # 787c <close>
    while(1){
    264c:	b75d                	j	25f2 <forkforkfork+0x5a>
    }

    exit(0);
  }

  sleep(20); // two seconds
    264e:	4551                	li	a0,20
    2650:	00005097          	auipc	ra,0x5
    2654:	294080e7          	jalr	660(ra) # 78e4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    2658:	20200593          	li	a1,514
    265c:	00006517          	auipc	a0,0x6
    2660:	48450513          	addi	a0,a0,1156 # 8ae0 <malloc+0xb72>
    2664:	00005097          	auipc	ra,0x5
    2668:	230080e7          	jalr	560(ra) # 7894 <open>
    266c:	87aa                	mv	a5,a0
    266e:	853e                	mv	a0,a5
    2670:	00005097          	auipc	ra,0x5
    2674:	20c080e7          	jalr	524(ra) # 787c <close>
  wait(0);
    2678:	4501                	li	a0,0
    267a:	00005097          	auipc	ra,0x5
    267e:	1e2080e7          	jalr	482(ra) # 785c <wait>
  sleep(10); // one second
    2682:	4529                	li	a0,10
    2684:	00005097          	auipc	ra,0x5
    2688:	260080e7          	jalr	608(ra) # 78e4 <sleep>
}
    268c:	0001                	nop
    268e:	70a2                	ld	ra,40(sp)
    2690:	7402                	ld	s0,32(sp)
    2692:	6145                	addi	sp,sp,48
    2694:	8082                	ret

0000000000002696 <reparent2>:
// deadlocks against init's wait()? also used to trigger a "panic:
// release" due to exit() releasing a different p->parent->lock than
// it acquired.
void
reparent2(char *s)
{
    2696:	7179                	addi	sp,sp,-48
    2698:	f406                	sd	ra,40(sp)
    269a:	f022                	sd	s0,32(sp)
    269c:	1800                	addi	s0,sp,48
    269e:	fca43c23          	sd	a0,-40(s0)
  for(int i = 0; i < 800; i++){
    26a2:	fe042623          	sw	zero,-20(s0)
    26a6:	a0ad                	j	2710 <reparent2+0x7a>
    int pid1 = fork();
    26a8:	00005097          	auipc	ra,0x5
    26ac:	1a4080e7          	jalr	420(ra) # 784c <fork>
    26b0:	87aa                	mv	a5,a0
    26b2:	fef42423          	sw	a5,-24(s0)
    if(pid1 < 0){
    26b6:	fe842783          	lw	a5,-24(s0)
    26ba:	2781                	sext.w	a5,a5
    26bc:	0007df63          	bgez	a5,26da <reparent2+0x44>
      printf("fork failed\n");
    26c0:	00006517          	auipc	a0,0x6
    26c4:	c0050513          	addi	a0,a0,-1024 # 82c0 <malloc+0x352>
    26c8:	00005097          	auipc	ra,0x5
    26cc:	6b4080e7          	jalr	1716(ra) # 7d7c <printf>
      exit(1);
    26d0:	4505                	li	a0,1
    26d2:	00005097          	auipc	ra,0x5
    26d6:	182080e7          	jalr	386(ra) # 7854 <exit>
    }
    if(pid1 == 0){
    26da:	fe842783          	lw	a5,-24(s0)
    26de:	2781                	sext.w	a5,a5
    26e0:	ef91                	bnez	a5,26fc <reparent2+0x66>
      fork();
    26e2:	00005097          	auipc	ra,0x5
    26e6:	16a080e7          	jalr	362(ra) # 784c <fork>
      fork();
    26ea:	00005097          	auipc	ra,0x5
    26ee:	162080e7          	jalr	354(ra) # 784c <fork>
      exit(0);
    26f2:	4501                	li	a0,0
    26f4:	00005097          	auipc	ra,0x5
    26f8:	160080e7          	jalr	352(ra) # 7854 <exit>
    }
    wait(0);
    26fc:	4501                	li	a0,0
    26fe:	00005097          	auipc	ra,0x5
    2702:	15e080e7          	jalr	350(ra) # 785c <wait>
  for(int i = 0; i < 800; i++){
    2706:	fec42783          	lw	a5,-20(s0)
    270a:	2785                	addiw	a5,a5,1
    270c:	fef42623          	sw	a5,-20(s0)
    2710:	fec42783          	lw	a5,-20(s0)
    2714:	0007871b          	sext.w	a4,a5
    2718:	31f00793          	li	a5,799
    271c:	f8e7d6e3          	bge	a5,a4,26a8 <reparent2+0x12>
  }

  exit(0);
    2720:	4501                	li	a0,0
    2722:	00005097          	auipc	ra,0x5
    2726:	132080e7          	jalr	306(ra) # 7854 <exit>

000000000000272a <mem>:
}

// allocate all mem, free it, and allocate again
void
mem(char *s)
{
    272a:	7139                	addi	sp,sp,-64
    272c:	fc06                	sd	ra,56(sp)
    272e:	f822                	sd	s0,48(sp)
    2730:	0080                	addi	s0,sp,64
    2732:	fca43423          	sd	a0,-56(s0)
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    2736:	00005097          	auipc	ra,0x5
    273a:	116080e7          	jalr	278(ra) # 784c <fork>
    273e:	87aa                	mv	a5,a0
    2740:	fef42223          	sw	a5,-28(s0)
    2744:	fe442783          	lw	a5,-28(s0)
    2748:	2781                	sext.w	a5,a5
    274a:	e3c5                	bnez	a5,27ea <mem+0xc0>
    m1 = 0;
    274c:	fe043423          	sd	zero,-24(s0)
    while((m2 = malloc(10001)) != 0){
    2750:	a811                	j	2764 <mem+0x3a>
      *(char**)m2 = m1;
    2752:	fd843783          	ld	a5,-40(s0)
    2756:	fe843703          	ld	a4,-24(s0)
    275a:	e398                	sd	a4,0(a5)
      m1 = m2;
    275c:	fd843783          	ld	a5,-40(s0)
    2760:	fef43423          	sd	a5,-24(s0)
    while((m2 = malloc(10001)) != 0){
    2764:	6789                	lui	a5,0x2
    2766:	71178513          	addi	a0,a5,1809 # 2711 <reparent2+0x7b>
    276a:	00006097          	auipc	ra,0x6
    276e:	804080e7          	jalr	-2044(ra) # 7f6e <malloc>
    2772:	fca43c23          	sd	a0,-40(s0)
    2776:	fd843783          	ld	a5,-40(s0)
    277a:	ffe1                	bnez	a5,2752 <mem+0x28>
    }
    while(m1){
    277c:	a005                	j	279c <mem+0x72>
      m2 = *(char**)m1;
    277e:	fe843783          	ld	a5,-24(s0)
    2782:	639c                	ld	a5,0(a5)
    2784:	fcf43c23          	sd	a5,-40(s0)
      free(m1);
    2788:	fe843503          	ld	a0,-24(s0)
    278c:	00005097          	auipc	ra,0x5
    2790:	640080e7          	jalr	1600(ra) # 7dcc <free>
      m1 = m2;
    2794:	fd843783          	ld	a5,-40(s0)
    2798:	fef43423          	sd	a5,-24(s0)
    while(m1){
    279c:	fe843783          	ld	a5,-24(s0)
    27a0:	fff9                	bnez	a5,277e <mem+0x54>
    }
    m1 = malloc(1024*20);
    27a2:	6515                	lui	a0,0x5
    27a4:	00005097          	auipc	ra,0x5
    27a8:	7ca080e7          	jalr	1994(ra) # 7f6e <malloc>
    27ac:	fea43423          	sd	a0,-24(s0)
    if(m1 == 0){
    27b0:	fe843783          	ld	a5,-24(s0)
    27b4:	e385                	bnez	a5,27d4 <mem+0xaa>
      printf("couldn't allocate mem?!!\n", s);
    27b6:	fc843583          	ld	a1,-56(s0)
    27ba:	00006517          	auipc	a0,0x6
    27be:	33650513          	addi	a0,a0,822 # 8af0 <malloc+0xb82>
    27c2:	00005097          	auipc	ra,0x5
    27c6:	5ba080e7          	jalr	1466(ra) # 7d7c <printf>
      exit(1);
    27ca:	4505                	li	a0,1
    27cc:	00005097          	auipc	ra,0x5
    27d0:	088080e7          	jalr	136(ra) # 7854 <exit>
    }
    free(m1);
    27d4:	fe843503          	ld	a0,-24(s0)
    27d8:	00005097          	auipc	ra,0x5
    27dc:	5f4080e7          	jalr	1524(ra) # 7dcc <free>
    exit(0);
    27e0:	4501                	li	a0,0
    27e2:	00005097          	auipc	ra,0x5
    27e6:	072080e7          	jalr	114(ra) # 7854 <exit>
  } else {
    int xstatus;
    wait(&xstatus);
    27ea:	fd440793          	addi	a5,s0,-44
    27ee:	853e                	mv	a0,a5
    27f0:	00005097          	auipc	ra,0x5
    27f4:	06c080e7          	jalr	108(ra) # 785c <wait>
    if(xstatus == -1){
    27f8:	fd442783          	lw	a5,-44(s0)
    27fc:	873e                	mv	a4,a5
    27fe:	57fd                	li	a5,-1
    2800:	00f71763          	bne	a4,a5,280e <mem+0xe4>
      // probably page fault, so might be lazy lab,
      // so OK.
      exit(0);
    2804:	4501                	li	a0,0
    2806:	00005097          	auipc	ra,0x5
    280a:	04e080e7          	jalr	78(ra) # 7854 <exit>
    }
    exit(xstatus);
    280e:	fd442783          	lw	a5,-44(s0)
    2812:	853e                	mv	a0,a5
    2814:	00005097          	auipc	ra,0x5
    2818:	040080e7          	jalr	64(ra) # 7854 <exit>

000000000000281c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(char *s)
{
    281c:	715d                	addi	sp,sp,-80
    281e:	e486                	sd	ra,72(sp)
    2820:	e0a2                	sd	s0,64(sp)
    2822:	0880                	addi	s0,sp,80
    2824:	faa43c23          	sd	a0,-72(s0)
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  unlink("sharedfd");
    2828:	00006517          	auipc	a0,0x6
    282c:	2e850513          	addi	a0,a0,744 # 8b10 <malloc+0xba2>
    2830:	00005097          	auipc	ra,0x5
    2834:	074080e7          	jalr	116(ra) # 78a4 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2838:	20200593          	li	a1,514
    283c:	00006517          	auipc	a0,0x6
    2840:	2d450513          	addi	a0,a0,724 # 8b10 <malloc+0xba2>
    2844:	00005097          	auipc	ra,0x5
    2848:	050080e7          	jalr	80(ra) # 7894 <open>
    284c:	87aa                	mv	a5,a0
    284e:	fef42023          	sw	a5,-32(s0)
  if(fd < 0){
    2852:	fe042783          	lw	a5,-32(s0)
    2856:	2781                	sext.w	a5,a5
    2858:	0207d163          	bgez	a5,287a <sharedfd+0x5e>
    printf("%s: cannot open sharedfd for writing", s);
    285c:	fb843583          	ld	a1,-72(s0)
    2860:	00006517          	auipc	a0,0x6
    2864:	2c050513          	addi	a0,a0,704 # 8b20 <malloc+0xbb2>
    2868:	00005097          	auipc	ra,0x5
    286c:	514080e7          	jalr	1300(ra) # 7d7c <printf>
    exit(1);
    2870:	4505                	li	a0,1
    2872:	00005097          	auipc	ra,0x5
    2876:	fe2080e7          	jalr	-30(ra) # 7854 <exit>
  }
  pid = fork();
    287a:	00005097          	auipc	ra,0x5
    287e:	fd2080e7          	jalr	-46(ra) # 784c <fork>
    2882:	87aa                	mv	a5,a0
    2884:	fcf42e23          	sw	a5,-36(s0)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2888:	fdc42783          	lw	a5,-36(s0)
    288c:	2781                	sext.w	a5,a5
    288e:	e781                	bnez	a5,2896 <sharedfd+0x7a>
    2890:	06300793          	li	a5,99
    2894:	a019                	j	289a <sharedfd+0x7e>
    2896:	07000793          	li	a5,112
    289a:	fc840713          	addi	a4,s0,-56
    289e:	4629                	li	a2,10
    28a0:	85be                	mv	a1,a5
    28a2:	853a                	mv	a0,a4
    28a4:	00005097          	auipc	ra,0x5
    28a8:	c04080e7          	jalr	-1020(ra) # 74a8 <memset>
  for(i = 0; i < N; i++){
    28ac:	fe042623          	sw	zero,-20(s0)
    28b0:	a0a9                	j	28fa <sharedfd+0xde>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    28b2:	fc840713          	addi	a4,s0,-56
    28b6:	fe042783          	lw	a5,-32(s0)
    28ba:	4629                	li	a2,10
    28bc:	85ba                	mv	a1,a4
    28be:	853e                	mv	a0,a5
    28c0:	00005097          	auipc	ra,0x5
    28c4:	fb4080e7          	jalr	-76(ra) # 7874 <write>
    28c8:	87aa                	mv	a5,a0
    28ca:	873e                	mv	a4,a5
    28cc:	47a9                	li	a5,10
    28ce:	02f70163          	beq	a4,a5,28f0 <sharedfd+0xd4>
      printf("%s: write sharedfd failed\n", s);
    28d2:	fb843583          	ld	a1,-72(s0)
    28d6:	00006517          	auipc	a0,0x6
    28da:	27250513          	addi	a0,a0,626 # 8b48 <malloc+0xbda>
    28de:	00005097          	auipc	ra,0x5
    28e2:	49e080e7          	jalr	1182(ra) # 7d7c <printf>
      exit(1);
    28e6:	4505                	li	a0,1
    28e8:	00005097          	auipc	ra,0x5
    28ec:	f6c080e7          	jalr	-148(ra) # 7854 <exit>
  for(i = 0; i < N; i++){
    28f0:	fec42783          	lw	a5,-20(s0)
    28f4:	2785                	addiw	a5,a5,1
    28f6:	fef42623          	sw	a5,-20(s0)
    28fa:	fec42783          	lw	a5,-20(s0)
    28fe:	0007871b          	sext.w	a4,a5
    2902:	3e700793          	li	a5,999
    2906:	fae7d6e3          	bge	a5,a4,28b2 <sharedfd+0x96>
    }
  }
  if(pid == 0) {
    290a:	fdc42783          	lw	a5,-36(s0)
    290e:	2781                	sext.w	a5,a5
    2910:	e791                	bnez	a5,291c <sharedfd+0x100>
    exit(0);
    2912:	4501                	li	a0,0
    2914:	00005097          	auipc	ra,0x5
    2918:	f40080e7          	jalr	-192(ra) # 7854 <exit>
  } else {
    int xstatus;
    wait(&xstatus);
    291c:	fc440793          	addi	a5,s0,-60
    2920:	853e                	mv	a0,a5
    2922:	00005097          	auipc	ra,0x5
    2926:	f3a080e7          	jalr	-198(ra) # 785c <wait>
    if(xstatus != 0)
    292a:	fc442783          	lw	a5,-60(s0)
    292e:	cb81                	beqz	a5,293e <sharedfd+0x122>
      exit(xstatus);
    2930:	fc442783          	lw	a5,-60(s0)
    2934:	853e                	mv	a0,a5
    2936:	00005097          	auipc	ra,0x5
    293a:	f1e080e7          	jalr	-226(ra) # 7854 <exit>
  }

  close(fd);
    293e:	fe042783          	lw	a5,-32(s0)
    2942:	853e                	mv	a0,a5
    2944:	00005097          	auipc	ra,0x5
    2948:	f38080e7          	jalr	-200(ra) # 787c <close>
  fd = open("sharedfd", 0);
    294c:	4581                	li	a1,0
    294e:	00006517          	auipc	a0,0x6
    2952:	1c250513          	addi	a0,a0,450 # 8b10 <malloc+0xba2>
    2956:	00005097          	auipc	ra,0x5
    295a:	f3e080e7          	jalr	-194(ra) # 7894 <open>
    295e:	87aa                	mv	a5,a0
    2960:	fef42023          	sw	a5,-32(s0)
  if(fd < 0){
    2964:	fe042783          	lw	a5,-32(s0)
    2968:	2781                	sext.w	a5,a5
    296a:	0207d163          	bgez	a5,298c <sharedfd+0x170>
    printf("%s: cannot open sharedfd for reading\n", s);
    296e:	fb843583          	ld	a1,-72(s0)
    2972:	00006517          	auipc	a0,0x6
    2976:	1f650513          	addi	a0,a0,502 # 8b68 <malloc+0xbfa>
    297a:	00005097          	auipc	ra,0x5
    297e:	402080e7          	jalr	1026(ra) # 7d7c <printf>
    exit(1);
    2982:	4505                	li	a0,1
    2984:	00005097          	auipc	ra,0x5
    2988:	ed0080e7          	jalr	-304(ra) # 7854 <exit>
  }
  nc = np = 0;
    298c:	fe042223          	sw	zero,-28(s0)
    2990:	fe442783          	lw	a5,-28(s0)
    2994:	fef42423          	sw	a5,-24(s0)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    2998:	a8b9                	j	29f6 <sharedfd+0x1da>
    for(i = 0; i < sizeof(buf); i++){
    299a:	fe042623          	sw	zero,-20(s0)
    299e:	a0b1                	j	29ea <sharedfd+0x1ce>
      if(buf[i] == 'c')
    29a0:	fec42783          	lw	a5,-20(s0)
    29a4:	17c1                	addi	a5,a5,-16
    29a6:	97a2                	add	a5,a5,s0
    29a8:	fd87c783          	lbu	a5,-40(a5)
    29ac:	873e                	mv	a4,a5
    29ae:	06300793          	li	a5,99
    29b2:	00f71763          	bne	a4,a5,29c0 <sharedfd+0x1a4>
        nc++;
    29b6:	fe842783          	lw	a5,-24(s0)
    29ba:	2785                	addiw	a5,a5,1
    29bc:	fef42423          	sw	a5,-24(s0)
      if(buf[i] == 'p')
    29c0:	fec42783          	lw	a5,-20(s0)
    29c4:	17c1                	addi	a5,a5,-16
    29c6:	97a2                	add	a5,a5,s0
    29c8:	fd87c783          	lbu	a5,-40(a5)
    29cc:	873e                	mv	a4,a5
    29ce:	07000793          	li	a5,112
    29d2:	00f71763          	bne	a4,a5,29e0 <sharedfd+0x1c4>
        np++;
    29d6:	fe442783          	lw	a5,-28(s0)
    29da:	2785                	addiw	a5,a5,1
    29dc:	fef42223          	sw	a5,-28(s0)
    for(i = 0; i < sizeof(buf); i++){
    29e0:	fec42783          	lw	a5,-20(s0)
    29e4:	2785                	addiw	a5,a5,1
    29e6:	fef42623          	sw	a5,-20(s0)
    29ea:	fec42783          	lw	a5,-20(s0)
    29ee:	873e                	mv	a4,a5
    29f0:	47a5                	li	a5,9
    29f2:	fae7f7e3          	bgeu	a5,a4,29a0 <sharedfd+0x184>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    29f6:	fc840713          	addi	a4,s0,-56
    29fa:	fe042783          	lw	a5,-32(s0)
    29fe:	4629                	li	a2,10
    2a00:	85ba                	mv	a1,a4
    2a02:	853e                	mv	a0,a5
    2a04:	00005097          	auipc	ra,0x5
    2a08:	e68080e7          	jalr	-408(ra) # 786c <read>
    2a0c:	87aa                	mv	a5,a0
    2a0e:	fcf42c23          	sw	a5,-40(s0)
    2a12:	fd842783          	lw	a5,-40(s0)
    2a16:	2781                	sext.w	a5,a5
    2a18:	f8f041e3          	bgtz	a5,299a <sharedfd+0x17e>
    }
  }
  close(fd);
    2a1c:	fe042783          	lw	a5,-32(s0)
    2a20:	853e                	mv	a0,a5
    2a22:	00005097          	auipc	ra,0x5
    2a26:	e5a080e7          	jalr	-422(ra) # 787c <close>
  unlink("sharedfd");
    2a2a:	00006517          	auipc	a0,0x6
    2a2e:	0e650513          	addi	a0,a0,230 # 8b10 <malloc+0xba2>
    2a32:	00005097          	auipc	ra,0x5
    2a36:	e72080e7          	jalr	-398(ra) # 78a4 <unlink>
  if(nc == N*SZ && np == N*SZ){
    2a3a:	fe842783          	lw	a5,-24(s0)
    2a3e:	0007871b          	sext.w	a4,a5
    2a42:	6789                	lui	a5,0x2
    2a44:	71078793          	addi	a5,a5,1808 # 2710 <reparent2+0x7a>
    2a48:	02f71063          	bne	a4,a5,2a68 <sharedfd+0x24c>
    2a4c:	fe442783          	lw	a5,-28(s0)
    2a50:	0007871b          	sext.w	a4,a5
    2a54:	6789                	lui	a5,0x2
    2a56:	71078793          	addi	a5,a5,1808 # 2710 <reparent2+0x7a>
    2a5a:	00f71763          	bne	a4,a5,2a68 <sharedfd+0x24c>
    exit(0);
    2a5e:	4501                	li	a0,0
    2a60:	00005097          	auipc	ra,0x5
    2a64:	df4080e7          	jalr	-524(ra) # 7854 <exit>
  } else {
    printf("%s: nc/np test fails\n", s);
    2a68:	fb843583          	ld	a1,-72(s0)
    2a6c:	00006517          	auipc	a0,0x6
    2a70:	12450513          	addi	a0,a0,292 # 8b90 <malloc+0xc22>
    2a74:	00005097          	auipc	ra,0x5
    2a78:	308080e7          	jalr	776(ra) # 7d7c <printf>
    exit(1);
    2a7c:	4505                	li	a0,1
    2a7e:	00005097          	auipc	ra,0x5
    2a82:	dd6080e7          	jalr	-554(ra) # 7854 <exit>

0000000000002a86 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(char *s)
{
    2a86:	7159                	addi	sp,sp,-112
    2a88:	f486                	sd	ra,104(sp)
    2a8a:	f0a2                	sd	s0,96(sp)
    2a8c:	1880                	addi	s0,sp,112
    2a8e:	f8a43c23          	sd	a0,-104(s0)
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    2a92:	00006797          	auipc	a5,0x6
    2a96:	18678793          	addi	a5,a5,390 # 8c18 <malloc+0xcaa>
    2a9a:	6390                	ld	a2,0(a5)
    2a9c:	6794                	ld	a3,8(a5)
    2a9e:	6b98                	ld	a4,16(a5)
    2aa0:	6f9c                	ld	a5,24(a5)
    2aa2:	fac43423          	sd	a2,-88(s0)
    2aa6:	fad43823          	sd	a3,-80(s0)
    2aaa:	fae43c23          	sd	a4,-72(s0)
    2aae:	fcf43023          	sd	a5,-64(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };

  for(pi = 0; pi < NCHILD; pi++){
    2ab2:	fe042023          	sw	zero,-32(s0)
    2ab6:	aa3d                	j	2bf4 <fourfiles+0x16e>
    fname = names[pi];
    2ab8:	fe042783          	lw	a5,-32(s0)
    2abc:	078e                	slli	a5,a5,0x3
    2abe:	17c1                	addi	a5,a5,-16
    2ac0:	97a2                	add	a5,a5,s0
    2ac2:	fb87b783          	ld	a5,-72(a5)
    2ac6:	fcf43c23          	sd	a5,-40(s0)
    unlink(fname);
    2aca:	fd843503          	ld	a0,-40(s0)
    2ace:	00005097          	auipc	ra,0x5
    2ad2:	dd6080e7          	jalr	-554(ra) # 78a4 <unlink>

    pid = fork();
    2ad6:	00005097          	auipc	ra,0x5
    2ada:	d76080e7          	jalr	-650(ra) # 784c <fork>
    2ade:	87aa                	mv	a5,a0
    2ae0:	fcf42623          	sw	a5,-52(s0)
    if(pid < 0){
    2ae4:	fcc42783          	lw	a5,-52(s0)
    2ae8:	2781                	sext.w	a5,a5
    2aea:	0207d163          	bgez	a5,2b0c <fourfiles+0x86>
      printf("fork failed\n", s);
    2aee:	f9843583          	ld	a1,-104(s0)
    2af2:	00005517          	auipc	a0,0x5
    2af6:	7ce50513          	addi	a0,a0,1998 # 82c0 <malloc+0x352>
    2afa:	00005097          	auipc	ra,0x5
    2afe:	282080e7          	jalr	642(ra) # 7d7c <printf>
      exit(1);
    2b02:	4505                	li	a0,1
    2b04:	00005097          	auipc	ra,0x5
    2b08:	d50080e7          	jalr	-688(ra) # 7854 <exit>
    }

    if(pid == 0){
    2b0c:	fcc42783          	lw	a5,-52(s0)
    2b10:	2781                	sext.w	a5,a5
    2b12:	efe1                	bnez	a5,2bea <fourfiles+0x164>
      fd = open(fname, O_CREATE | O_RDWR);
    2b14:	20200593          	li	a1,514
    2b18:	fd843503          	ld	a0,-40(s0)
    2b1c:	00005097          	auipc	ra,0x5
    2b20:	d78080e7          	jalr	-648(ra) # 7894 <open>
    2b24:	87aa                	mv	a5,a0
    2b26:	fcf42a23          	sw	a5,-44(s0)
      if(fd < 0){
    2b2a:	fd442783          	lw	a5,-44(s0)
    2b2e:	2781                	sext.w	a5,a5
    2b30:	0207d163          	bgez	a5,2b52 <fourfiles+0xcc>
        printf("create failed\n", s);
    2b34:	f9843583          	ld	a1,-104(s0)
    2b38:	00006517          	auipc	a0,0x6
    2b3c:	07050513          	addi	a0,a0,112 # 8ba8 <malloc+0xc3a>
    2b40:	00005097          	auipc	ra,0x5
    2b44:	23c080e7          	jalr	572(ra) # 7d7c <printf>
        exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	00005097          	auipc	ra,0x5
    2b4e:	d0a080e7          	jalr	-758(ra) # 7854 <exit>
      }

      memset(buf, '0'+pi, SZ);
    2b52:	fe042783          	lw	a5,-32(s0)
    2b56:	0307879b          	addiw	a5,a5,48
    2b5a:	2781                	sext.w	a5,a5
    2b5c:	1f400613          	li	a2,500
    2b60:	85be                	mv	a1,a5
    2b62:	00009517          	auipc	a0,0x9
    2b66:	77e50513          	addi	a0,a0,1918 # c2e0 <buf>
    2b6a:	00005097          	auipc	ra,0x5
    2b6e:	93e080e7          	jalr	-1730(ra) # 74a8 <memset>
      for(i = 0; i < N; i++){
    2b72:	fe042623          	sw	zero,-20(s0)
    2b76:	a8b1                	j	2bd2 <fourfiles+0x14c>
        if((n = write(fd, buf, SZ)) != SZ){
    2b78:	fd442783          	lw	a5,-44(s0)
    2b7c:	1f400613          	li	a2,500
    2b80:	00009597          	auipc	a1,0x9
    2b84:	76058593          	addi	a1,a1,1888 # c2e0 <buf>
    2b88:	853e                	mv	a0,a5
    2b8a:	00005097          	auipc	ra,0x5
    2b8e:	cea080e7          	jalr	-790(ra) # 7874 <write>
    2b92:	87aa                	mv	a5,a0
    2b94:	fcf42823          	sw	a5,-48(s0)
    2b98:	fd042783          	lw	a5,-48(s0)
    2b9c:	0007871b          	sext.w	a4,a5
    2ba0:	1f400793          	li	a5,500
    2ba4:	02f70263          	beq	a4,a5,2bc8 <fourfiles+0x142>
          printf("write failed %d\n", n);
    2ba8:	fd042783          	lw	a5,-48(s0)
    2bac:	85be                	mv	a1,a5
    2bae:	00006517          	auipc	a0,0x6
    2bb2:	00a50513          	addi	a0,a0,10 # 8bb8 <malloc+0xc4a>
    2bb6:	00005097          	auipc	ra,0x5
    2bba:	1c6080e7          	jalr	454(ra) # 7d7c <printf>
          exit(1);
    2bbe:	4505                	li	a0,1
    2bc0:	00005097          	auipc	ra,0x5
    2bc4:	c94080e7          	jalr	-876(ra) # 7854 <exit>
      for(i = 0; i < N; i++){
    2bc8:	fec42783          	lw	a5,-20(s0)
    2bcc:	2785                	addiw	a5,a5,1
    2bce:	fef42623          	sw	a5,-20(s0)
    2bd2:	fec42783          	lw	a5,-20(s0)
    2bd6:	0007871b          	sext.w	a4,a5
    2bda:	47ad                	li	a5,11
    2bdc:	f8e7dee3          	bge	a5,a4,2b78 <fourfiles+0xf2>
        }
      }
      exit(0);
    2be0:	4501                	li	a0,0
    2be2:	00005097          	auipc	ra,0x5
    2be6:	c72080e7          	jalr	-910(ra) # 7854 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2bea:	fe042783          	lw	a5,-32(s0)
    2bee:	2785                	addiw	a5,a5,1
    2bf0:	fef42023          	sw	a5,-32(s0)
    2bf4:	fe042783          	lw	a5,-32(s0)
    2bf8:	0007871b          	sext.w	a4,a5
    2bfc:	478d                	li	a5,3
    2bfe:	eae7dde3          	bge	a5,a4,2ab8 <fourfiles+0x32>
    }
  }

  int xstatus;
  for(pi = 0; pi < NCHILD; pi++){
    2c02:	fe042023          	sw	zero,-32(s0)
    2c06:	a03d                	j	2c34 <fourfiles+0x1ae>
    wait(&xstatus);
    2c08:	fa440793          	addi	a5,s0,-92
    2c0c:	853e                	mv	a0,a5
    2c0e:	00005097          	auipc	ra,0x5
    2c12:	c4e080e7          	jalr	-946(ra) # 785c <wait>
    if(xstatus != 0)
    2c16:	fa442783          	lw	a5,-92(s0)
    2c1a:	cb81                	beqz	a5,2c2a <fourfiles+0x1a4>
      exit(xstatus);
    2c1c:	fa442783          	lw	a5,-92(s0)
    2c20:	853e                	mv	a0,a5
    2c22:	00005097          	auipc	ra,0x5
    2c26:	c32080e7          	jalr	-974(ra) # 7854 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2c2a:	fe042783          	lw	a5,-32(s0)
    2c2e:	2785                	addiw	a5,a5,1
    2c30:	fef42023          	sw	a5,-32(s0)
    2c34:	fe042783          	lw	a5,-32(s0)
    2c38:	0007871b          	sext.w	a4,a5
    2c3c:	478d                	li	a5,3
    2c3e:	fce7d5e3          	bge	a5,a4,2c08 <fourfiles+0x182>
  }

  for(i = 0; i < NCHILD; i++){
    2c42:	fe042623          	sw	zero,-20(s0)
    2c46:	a205                	j	2d66 <fourfiles+0x2e0>
    fname = names[i];
    2c48:	fec42783          	lw	a5,-20(s0)
    2c4c:	078e                	slli	a5,a5,0x3
    2c4e:	17c1                	addi	a5,a5,-16
    2c50:	97a2                	add	a5,a5,s0
    2c52:	fb87b783          	ld	a5,-72(a5)
    2c56:	fcf43c23          	sd	a5,-40(s0)
    fd = open(fname, 0);
    2c5a:	4581                	li	a1,0
    2c5c:	fd843503          	ld	a0,-40(s0)
    2c60:	00005097          	auipc	ra,0x5
    2c64:	c34080e7          	jalr	-972(ra) # 7894 <open>
    2c68:	87aa                	mv	a5,a0
    2c6a:	fcf42a23          	sw	a5,-44(s0)
    total = 0;
    2c6e:	fe042223          	sw	zero,-28(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2c72:	a89d                	j	2ce8 <fourfiles+0x262>
      for(j = 0; j < n; j++){
    2c74:	fe042423          	sw	zero,-24(s0)
    2c78:	a0b9                	j	2cc6 <fourfiles+0x240>
        if(buf[j] != '0'+i){
    2c7a:	00009717          	auipc	a4,0x9
    2c7e:	66670713          	addi	a4,a4,1638 # c2e0 <buf>
    2c82:	fe842783          	lw	a5,-24(s0)
    2c86:	97ba                	add	a5,a5,a4
    2c88:	0007c783          	lbu	a5,0(a5)
    2c8c:	0007871b          	sext.w	a4,a5
    2c90:	fec42783          	lw	a5,-20(s0)
    2c94:	0307879b          	addiw	a5,a5,48
    2c98:	2781                	sext.w	a5,a5
    2c9a:	02f70163          	beq	a4,a5,2cbc <fourfiles+0x236>
          printf("wrong char\n", s);
    2c9e:	f9843583          	ld	a1,-104(s0)
    2ca2:	00006517          	auipc	a0,0x6
    2ca6:	f2e50513          	addi	a0,a0,-210 # 8bd0 <malloc+0xc62>
    2caa:	00005097          	auipc	ra,0x5
    2cae:	0d2080e7          	jalr	210(ra) # 7d7c <printf>
          exit(1);
    2cb2:	4505                	li	a0,1
    2cb4:	00005097          	auipc	ra,0x5
    2cb8:	ba0080e7          	jalr	-1120(ra) # 7854 <exit>
      for(j = 0; j < n; j++){
    2cbc:	fe842783          	lw	a5,-24(s0)
    2cc0:	2785                	addiw	a5,a5,1
    2cc2:	fef42423          	sw	a5,-24(s0)
    2cc6:	fe842783          	lw	a5,-24(s0)
    2cca:	873e                	mv	a4,a5
    2ccc:	fd042783          	lw	a5,-48(s0)
    2cd0:	2701                	sext.w	a4,a4
    2cd2:	2781                	sext.w	a5,a5
    2cd4:	faf743e3          	blt	a4,a5,2c7a <fourfiles+0x1f4>
        }
      }
      total += n;
    2cd8:	fe442783          	lw	a5,-28(s0)
    2cdc:	873e                	mv	a4,a5
    2cde:	fd042783          	lw	a5,-48(s0)
    2ce2:	9fb9                	addw	a5,a5,a4
    2ce4:	fef42223          	sw	a5,-28(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2ce8:	fd442783          	lw	a5,-44(s0)
    2cec:	660d                	lui	a2,0x3
    2cee:	00009597          	auipc	a1,0x9
    2cf2:	5f258593          	addi	a1,a1,1522 # c2e0 <buf>
    2cf6:	853e                	mv	a0,a5
    2cf8:	00005097          	auipc	ra,0x5
    2cfc:	b74080e7          	jalr	-1164(ra) # 786c <read>
    2d00:	87aa                	mv	a5,a0
    2d02:	fcf42823          	sw	a5,-48(s0)
    2d06:	fd042783          	lw	a5,-48(s0)
    2d0a:	2781                	sext.w	a5,a5
    2d0c:	f6f044e3          	bgtz	a5,2c74 <fourfiles+0x1ee>
    }
    close(fd);
    2d10:	fd442783          	lw	a5,-44(s0)
    2d14:	853e                	mv	a0,a5
    2d16:	00005097          	auipc	ra,0x5
    2d1a:	b66080e7          	jalr	-1178(ra) # 787c <close>
    if(total != N*SZ){
    2d1e:	fe442783          	lw	a5,-28(s0)
    2d22:	0007871b          	sext.w	a4,a5
    2d26:	6785                	lui	a5,0x1
    2d28:	77078793          	addi	a5,a5,1904 # 1770 <writebig+0x12c>
    2d2c:	02f70263          	beq	a4,a5,2d50 <fourfiles+0x2ca>
      printf("wrong length %d\n", total);
    2d30:	fe442783          	lw	a5,-28(s0)
    2d34:	85be                	mv	a1,a5
    2d36:	00006517          	auipc	a0,0x6
    2d3a:	eaa50513          	addi	a0,a0,-342 # 8be0 <malloc+0xc72>
    2d3e:	00005097          	auipc	ra,0x5
    2d42:	03e080e7          	jalr	62(ra) # 7d7c <printf>
      exit(1);
    2d46:	4505                	li	a0,1
    2d48:	00005097          	auipc	ra,0x5
    2d4c:	b0c080e7          	jalr	-1268(ra) # 7854 <exit>
    }
    unlink(fname);
    2d50:	fd843503          	ld	a0,-40(s0)
    2d54:	00005097          	auipc	ra,0x5
    2d58:	b50080e7          	jalr	-1200(ra) # 78a4 <unlink>
  for(i = 0; i < NCHILD; i++){
    2d5c:	fec42783          	lw	a5,-20(s0)
    2d60:	2785                	addiw	a5,a5,1
    2d62:	fef42623          	sw	a5,-20(s0)
    2d66:	fec42783          	lw	a5,-20(s0)
    2d6a:	0007871b          	sext.w	a4,a5
    2d6e:	478d                	li	a5,3
    2d70:	ece7dce3          	bge	a5,a4,2c48 <fourfiles+0x1c2>
  }
}
    2d74:	0001                	nop
    2d76:	0001                	nop
    2d78:	70a6                	ld	ra,104(sp)
    2d7a:	7406                	ld	s0,96(sp)
    2d7c:	6165                	addi	sp,sp,112
    2d7e:	8082                	ret

0000000000002d80 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(char *s)
{
    2d80:	711d                	addi	sp,sp,-96
    2d82:	ec86                	sd	ra,88(sp)
    2d84:	e8a2                	sd	s0,80(sp)
    2d86:	1080                	addi	s0,sp,96
    2d88:	faa43423          	sd	a0,-88(s0)
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  for(pi = 0; pi < NCHILD; pi++){
    2d8c:	fe042423          	sw	zero,-24(s0)
    2d90:	aa91                	j	2ee4 <createdelete+0x164>
    pid = fork();
    2d92:	00005097          	auipc	ra,0x5
    2d96:	aba080e7          	jalr	-1350(ra) # 784c <fork>
    2d9a:	87aa                	mv	a5,a0
    2d9c:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    2da0:	fe042783          	lw	a5,-32(s0)
    2da4:	2781                	sext.w	a5,a5
    2da6:	0207d163          	bgez	a5,2dc8 <createdelete+0x48>
      printf("fork failed\n", s);
    2daa:	fa843583          	ld	a1,-88(s0)
    2dae:	00005517          	auipc	a0,0x5
    2db2:	51250513          	addi	a0,a0,1298 # 82c0 <malloc+0x352>
    2db6:	00005097          	auipc	ra,0x5
    2dba:	fc6080e7          	jalr	-58(ra) # 7d7c <printf>
      exit(1);
    2dbe:	4505                	li	a0,1
    2dc0:	00005097          	auipc	ra,0x5
    2dc4:	a94080e7          	jalr	-1388(ra) # 7854 <exit>
    }

    if(pid == 0){
    2dc8:	fe042783          	lw	a5,-32(s0)
    2dcc:	2781                	sext.w	a5,a5
    2dce:	10079663          	bnez	a5,2eda <createdelete+0x15a>
      name[0] = 'p' + pi;
    2dd2:	fe842783          	lw	a5,-24(s0)
    2dd6:	0ff7f793          	zext.b	a5,a5
    2dda:	0707879b          	addiw	a5,a5,112
    2dde:	0ff7f793          	zext.b	a5,a5
    2de2:	fcf40023          	sb	a5,-64(s0)
      name[2] = '\0';
    2de6:	fc040123          	sb	zero,-62(s0)
      for(i = 0; i < N; i++){
    2dea:	fe042623          	sw	zero,-20(s0)
    2dee:	a8d1                	j	2ec2 <createdelete+0x142>
        name[1] = '0' + i;
    2df0:	fec42783          	lw	a5,-20(s0)
    2df4:	0ff7f793          	zext.b	a5,a5
    2df8:	0307879b          	addiw	a5,a5,48
    2dfc:	0ff7f793          	zext.b	a5,a5
    2e00:	fcf400a3          	sb	a5,-63(s0)
        fd = open(name, O_CREATE | O_RDWR);
    2e04:	fc040793          	addi	a5,s0,-64
    2e08:	20200593          	li	a1,514
    2e0c:	853e                	mv	a0,a5
    2e0e:	00005097          	auipc	ra,0x5
    2e12:	a86080e7          	jalr	-1402(ra) # 7894 <open>
    2e16:	87aa                	mv	a5,a0
    2e18:	fef42223          	sw	a5,-28(s0)
        if(fd < 0){
    2e1c:	fe442783          	lw	a5,-28(s0)
    2e20:	2781                	sext.w	a5,a5
    2e22:	0207d163          	bgez	a5,2e44 <createdelete+0xc4>
          printf("%s: create failed\n", s);
    2e26:	fa843583          	ld	a1,-88(s0)
    2e2a:	00006517          	auipc	a0,0x6
    2e2e:	aee50513          	addi	a0,a0,-1298 # 8918 <malloc+0x9aa>
    2e32:	00005097          	auipc	ra,0x5
    2e36:	f4a080e7          	jalr	-182(ra) # 7d7c <printf>
          exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00005097          	auipc	ra,0x5
    2e40:	a18080e7          	jalr	-1512(ra) # 7854 <exit>
        }
        close(fd);
    2e44:	fe442783          	lw	a5,-28(s0)
    2e48:	853e                	mv	a0,a5
    2e4a:	00005097          	auipc	ra,0x5
    2e4e:	a32080e7          	jalr	-1486(ra) # 787c <close>
        if(i > 0 && (i % 2 ) == 0){
    2e52:	fec42783          	lw	a5,-20(s0)
    2e56:	2781                	sext.w	a5,a5
    2e58:	06f05063          	blez	a5,2eb8 <createdelete+0x138>
    2e5c:	fec42783          	lw	a5,-20(s0)
    2e60:	8b85                	andi	a5,a5,1
    2e62:	2781                	sext.w	a5,a5
    2e64:	ebb1                	bnez	a5,2eb8 <createdelete+0x138>
          name[1] = '0' + (i / 2);
    2e66:	fec42783          	lw	a5,-20(s0)
    2e6a:	01f7d71b          	srliw	a4,a5,0x1f
    2e6e:	9fb9                	addw	a5,a5,a4
    2e70:	4017d79b          	sraiw	a5,a5,0x1
    2e74:	2781                	sext.w	a5,a5
    2e76:	0ff7f793          	zext.b	a5,a5
    2e7a:	0307879b          	addiw	a5,a5,48
    2e7e:	0ff7f793          	zext.b	a5,a5
    2e82:	fcf400a3          	sb	a5,-63(s0)
          if(unlink(name) < 0){
    2e86:	fc040793          	addi	a5,s0,-64
    2e8a:	853e                	mv	a0,a5
    2e8c:	00005097          	auipc	ra,0x5
    2e90:	a18080e7          	jalr	-1512(ra) # 78a4 <unlink>
    2e94:	87aa                	mv	a5,a0
    2e96:	0207d163          	bgez	a5,2eb8 <createdelete+0x138>
            printf("%s: unlink failed\n", s);
    2e9a:	fa843583          	ld	a1,-88(s0)
    2e9e:	00005517          	auipc	a0,0x5
    2ea2:	7ca50513          	addi	a0,a0,1994 # 8668 <malloc+0x6fa>
    2ea6:	00005097          	auipc	ra,0x5
    2eaa:	ed6080e7          	jalr	-298(ra) # 7d7c <printf>
            exit(1);
    2eae:	4505                	li	a0,1
    2eb0:	00005097          	auipc	ra,0x5
    2eb4:	9a4080e7          	jalr	-1628(ra) # 7854 <exit>
      for(i = 0; i < N; i++){
    2eb8:	fec42783          	lw	a5,-20(s0)
    2ebc:	2785                	addiw	a5,a5,1
    2ebe:	fef42623          	sw	a5,-20(s0)
    2ec2:	fec42783          	lw	a5,-20(s0)
    2ec6:	0007871b          	sext.w	a4,a5
    2eca:	47cd                	li	a5,19
    2ecc:	f2e7d2e3          	bge	a5,a4,2df0 <createdelete+0x70>
          }
        }
      }
      exit(0);
    2ed0:	4501                	li	a0,0
    2ed2:	00005097          	auipc	ra,0x5
    2ed6:	982080e7          	jalr	-1662(ra) # 7854 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2eda:	fe842783          	lw	a5,-24(s0)
    2ede:	2785                	addiw	a5,a5,1
    2ee0:	fef42423          	sw	a5,-24(s0)
    2ee4:	fe842783          	lw	a5,-24(s0)
    2ee8:	0007871b          	sext.w	a4,a5
    2eec:	478d                	li	a5,3
    2eee:	eae7d2e3          	bge	a5,a4,2d92 <createdelete+0x12>
    }
  }

  int xstatus;
  for(pi = 0; pi < NCHILD; pi++){
    2ef2:	fe042423          	sw	zero,-24(s0)
    2ef6:	a02d                	j	2f20 <createdelete+0x1a0>
    wait(&xstatus);
    2ef8:	fbc40793          	addi	a5,s0,-68
    2efc:	853e                	mv	a0,a5
    2efe:	00005097          	auipc	ra,0x5
    2f02:	95e080e7          	jalr	-1698(ra) # 785c <wait>
    if(xstatus != 0)
    2f06:	fbc42783          	lw	a5,-68(s0)
    2f0a:	c791                	beqz	a5,2f16 <createdelete+0x196>
      exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00005097          	auipc	ra,0x5
    2f12:	946080e7          	jalr	-1722(ra) # 7854 <exit>
  for(pi = 0; pi < NCHILD; pi++){
    2f16:	fe842783          	lw	a5,-24(s0)
    2f1a:	2785                	addiw	a5,a5,1
    2f1c:	fef42423          	sw	a5,-24(s0)
    2f20:	fe842783          	lw	a5,-24(s0)
    2f24:	0007871b          	sext.w	a4,a5
    2f28:	478d                	li	a5,3
    2f2a:	fce7d7e3          	bge	a5,a4,2ef8 <createdelete+0x178>
  }

  name[0] = name[1] = name[2] = 0;
    2f2e:	fc040123          	sb	zero,-62(s0)
    2f32:	fc244783          	lbu	a5,-62(s0)
    2f36:	fcf400a3          	sb	a5,-63(s0)
    2f3a:	fc144783          	lbu	a5,-63(s0)
    2f3e:	fcf40023          	sb	a5,-64(s0)
  for(i = 0; i < N; i++){
    2f42:	fe042623          	sw	zero,-20(s0)
    2f46:	a229                	j	3050 <createdelete+0x2d0>
    for(pi = 0; pi < NCHILD; pi++){
    2f48:	fe042423          	sw	zero,-24(s0)
    2f4c:	a0f5                	j	3038 <createdelete+0x2b8>
      name[0] = 'p' + pi;
    2f4e:	fe842783          	lw	a5,-24(s0)
    2f52:	0ff7f793          	zext.b	a5,a5
    2f56:	0707879b          	addiw	a5,a5,112
    2f5a:	0ff7f793          	zext.b	a5,a5
    2f5e:	fcf40023          	sb	a5,-64(s0)
      name[1] = '0' + i;
    2f62:	fec42783          	lw	a5,-20(s0)
    2f66:	0ff7f793          	zext.b	a5,a5
    2f6a:	0307879b          	addiw	a5,a5,48
    2f6e:	0ff7f793          	zext.b	a5,a5
    2f72:	fcf400a3          	sb	a5,-63(s0)
      fd = open(name, 0);
    2f76:	fc040793          	addi	a5,s0,-64
    2f7a:	4581                	li	a1,0
    2f7c:	853e                	mv	a0,a5
    2f7e:	00005097          	auipc	ra,0x5
    2f82:	916080e7          	jalr	-1770(ra) # 7894 <open>
    2f86:	87aa                	mv	a5,a0
    2f88:	fef42223          	sw	a5,-28(s0)
      if((i == 0 || i >= N/2) && fd < 0){
    2f8c:	fec42783          	lw	a5,-20(s0)
    2f90:	2781                	sext.w	a5,a5
    2f92:	cb81                	beqz	a5,2fa2 <createdelete+0x222>
    2f94:	fec42783          	lw	a5,-20(s0)
    2f98:	0007871b          	sext.w	a4,a5
    2f9c:	47a5                	li	a5,9
    2f9e:	02e7d963          	bge	a5,a4,2fd0 <createdelete+0x250>
    2fa2:	fe442783          	lw	a5,-28(s0)
    2fa6:	2781                	sext.w	a5,a5
    2fa8:	0207d463          	bgez	a5,2fd0 <createdelete+0x250>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    2fac:	fc040793          	addi	a5,s0,-64
    2fb0:	863e                	mv	a2,a5
    2fb2:	fa843583          	ld	a1,-88(s0)
    2fb6:	00006517          	auipc	a0,0x6
    2fba:	c8250513          	addi	a0,a0,-894 # 8c38 <malloc+0xcca>
    2fbe:	00005097          	auipc	ra,0x5
    2fc2:	dbe080e7          	jalr	-578(ra) # 7d7c <printf>
        exit(1);
    2fc6:	4505                	li	a0,1
    2fc8:	00005097          	auipc	ra,0x5
    2fcc:	88c080e7          	jalr	-1908(ra) # 7854 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2fd0:	fec42783          	lw	a5,-20(s0)
    2fd4:	2781                	sext.w	a5,a5
    2fd6:	04f05063          	blez	a5,3016 <createdelete+0x296>
    2fda:	fec42783          	lw	a5,-20(s0)
    2fde:	0007871b          	sext.w	a4,a5
    2fe2:	47a5                	li	a5,9
    2fe4:	02e7c963          	blt	a5,a4,3016 <createdelete+0x296>
    2fe8:	fe442783          	lw	a5,-28(s0)
    2fec:	2781                	sext.w	a5,a5
    2fee:	0207c463          	bltz	a5,3016 <createdelete+0x296>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2ff2:	fc040793          	addi	a5,s0,-64
    2ff6:	863e                	mv	a2,a5
    2ff8:	fa843583          	ld	a1,-88(s0)
    2ffc:	00006517          	auipc	a0,0x6
    3000:	c6450513          	addi	a0,a0,-924 # 8c60 <malloc+0xcf2>
    3004:	00005097          	auipc	ra,0x5
    3008:	d78080e7          	jalr	-648(ra) # 7d7c <printf>
        exit(1);
    300c:	4505                	li	a0,1
    300e:	00005097          	auipc	ra,0x5
    3012:	846080e7          	jalr	-1978(ra) # 7854 <exit>
      }
      if(fd >= 0)
    3016:	fe442783          	lw	a5,-28(s0)
    301a:	2781                	sext.w	a5,a5
    301c:	0007c963          	bltz	a5,302e <createdelete+0x2ae>
        close(fd);
    3020:	fe442783          	lw	a5,-28(s0)
    3024:	853e                	mv	a0,a5
    3026:	00005097          	auipc	ra,0x5
    302a:	856080e7          	jalr	-1962(ra) # 787c <close>
    for(pi = 0; pi < NCHILD; pi++){
    302e:	fe842783          	lw	a5,-24(s0)
    3032:	2785                	addiw	a5,a5,1
    3034:	fef42423          	sw	a5,-24(s0)
    3038:	fe842783          	lw	a5,-24(s0)
    303c:	0007871b          	sext.w	a4,a5
    3040:	478d                	li	a5,3
    3042:	f0e7d6e3          	bge	a5,a4,2f4e <createdelete+0x1ce>
  for(i = 0; i < N; i++){
    3046:	fec42783          	lw	a5,-20(s0)
    304a:	2785                	addiw	a5,a5,1
    304c:	fef42623          	sw	a5,-20(s0)
    3050:	fec42783          	lw	a5,-20(s0)
    3054:	0007871b          	sext.w	a4,a5
    3058:	47cd                	li	a5,19
    305a:	eee7d7e3          	bge	a5,a4,2f48 <createdelete+0x1c8>
    }
  }

  for(i = 0; i < N; i++){
    305e:	fe042623          	sw	zero,-20(s0)
    3062:	a085                	j	30c2 <createdelete+0x342>
    for(pi = 0; pi < NCHILD; pi++){
    3064:	fe042423          	sw	zero,-24(s0)
    3068:	a089                	j	30aa <createdelete+0x32a>
      name[0] = 'p' + i;
    306a:	fec42783          	lw	a5,-20(s0)
    306e:	0ff7f793          	zext.b	a5,a5
    3072:	0707879b          	addiw	a5,a5,112
    3076:	0ff7f793          	zext.b	a5,a5
    307a:	fcf40023          	sb	a5,-64(s0)
      name[1] = '0' + i;
    307e:	fec42783          	lw	a5,-20(s0)
    3082:	0ff7f793          	zext.b	a5,a5
    3086:	0307879b          	addiw	a5,a5,48
    308a:	0ff7f793          	zext.b	a5,a5
    308e:	fcf400a3          	sb	a5,-63(s0)
      unlink(name);
    3092:	fc040793          	addi	a5,s0,-64
    3096:	853e                	mv	a0,a5
    3098:	00005097          	auipc	ra,0x5
    309c:	80c080e7          	jalr	-2036(ra) # 78a4 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    30a0:	fe842783          	lw	a5,-24(s0)
    30a4:	2785                	addiw	a5,a5,1
    30a6:	fef42423          	sw	a5,-24(s0)
    30aa:	fe842783          	lw	a5,-24(s0)
    30ae:	0007871b          	sext.w	a4,a5
    30b2:	478d                	li	a5,3
    30b4:	fae7dbe3          	bge	a5,a4,306a <createdelete+0x2ea>
  for(i = 0; i < N; i++){
    30b8:	fec42783          	lw	a5,-20(s0)
    30bc:	2785                	addiw	a5,a5,1
    30be:	fef42623          	sw	a5,-20(s0)
    30c2:	fec42783          	lw	a5,-20(s0)
    30c6:	0007871b          	sext.w	a4,a5
    30ca:	47cd                	li	a5,19
    30cc:	f8e7dce3          	bge	a5,a4,3064 <createdelete+0x2e4>
    }
  }
}
    30d0:	0001                	nop
    30d2:	0001                	nop
    30d4:	60e6                	ld	ra,88(sp)
    30d6:	6446                	ld	s0,80(sp)
    30d8:	6125                	addi	sp,sp,96
    30da:	8082                	ret

00000000000030dc <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(char *s)
{
    30dc:	7179                	addi	sp,sp,-48
    30de:	f406                	sd	ra,40(sp)
    30e0:	f022                	sd	s0,32(sp)
    30e2:	1800                	addi	s0,sp,48
    30e4:	fca43c23          	sd	a0,-40(s0)
  enum { SZ = 5 };
  int fd, fd1;

  fd = open("unlinkread", O_CREATE | O_RDWR);
    30e8:	20200593          	li	a1,514
    30ec:	00006517          	auipc	a0,0x6
    30f0:	b9c50513          	addi	a0,a0,-1124 # 8c88 <malloc+0xd1a>
    30f4:	00004097          	auipc	ra,0x4
    30f8:	7a0080e7          	jalr	1952(ra) # 7894 <open>
    30fc:	87aa                	mv	a5,a0
    30fe:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3102:	fec42783          	lw	a5,-20(s0)
    3106:	2781                	sext.w	a5,a5
    3108:	0207d163          	bgez	a5,312a <unlinkread+0x4e>
    printf("%s: create unlinkread failed\n", s);
    310c:	fd843583          	ld	a1,-40(s0)
    3110:	00006517          	auipc	a0,0x6
    3114:	b8850513          	addi	a0,a0,-1144 # 8c98 <malloc+0xd2a>
    3118:	00005097          	auipc	ra,0x5
    311c:	c64080e7          	jalr	-924(ra) # 7d7c <printf>
    exit(1);
    3120:	4505                	li	a0,1
    3122:	00004097          	auipc	ra,0x4
    3126:	732080e7          	jalr	1842(ra) # 7854 <exit>
  }
  write(fd, "hello", SZ);
    312a:	fec42783          	lw	a5,-20(s0)
    312e:	4615                	li	a2,5
    3130:	00006597          	auipc	a1,0x6
    3134:	b8858593          	addi	a1,a1,-1144 # 8cb8 <malloc+0xd4a>
    3138:	853e                	mv	a0,a5
    313a:	00004097          	auipc	ra,0x4
    313e:	73a080e7          	jalr	1850(ra) # 7874 <write>
  close(fd);
    3142:	fec42783          	lw	a5,-20(s0)
    3146:	853e                	mv	a0,a5
    3148:	00004097          	auipc	ra,0x4
    314c:	734080e7          	jalr	1844(ra) # 787c <close>

  fd = open("unlinkread", O_RDWR);
    3150:	4589                	li	a1,2
    3152:	00006517          	auipc	a0,0x6
    3156:	b3650513          	addi	a0,a0,-1226 # 8c88 <malloc+0xd1a>
    315a:	00004097          	auipc	ra,0x4
    315e:	73a080e7          	jalr	1850(ra) # 7894 <open>
    3162:	87aa                	mv	a5,a0
    3164:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3168:	fec42783          	lw	a5,-20(s0)
    316c:	2781                	sext.w	a5,a5
    316e:	0207d163          	bgez	a5,3190 <unlinkread+0xb4>
    printf("%s: open unlinkread failed\n", s);
    3172:	fd843583          	ld	a1,-40(s0)
    3176:	00006517          	auipc	a0,0x6
    317a:	b4a50513          	addi	a0,a0,-1206 # 8cc0 <malloc+0xd52>
    317e:	00005097          	auipc	ra,0x5
    3182:	bfe080e7          	jalr	-1026(ra) # 7d7c <printf>
    exit(1);
    3186:	4505                	li	a0,1
    3188:	00004097          	auipc	ra,0x4
    318c:	6cc080e7          	jalr	1740(ra) # 7854 <exit>
  }
  if(unlink("unlinkread") != 0){
    3190:	00006517          	auipc	a0,0x6
    3194:	af850513          	addi	a0,a0,-1288 # 8c88 <malloc+0xd1a>
    3198:	00004097          	auipc	ra,0x4
    319c:	70c080e7          	jalr	1804(ra) # 78a4 <unlink>
    31a0:	87aa                	mv	a5,a0
    31a2:	c385                	beqz	a5,31c2 <unlinkread+0xe6>
    printf("%s: unlink unlinkread failed\n", s);
    31a4:	fd843583          	ld	a1,-40(s0)
    31a8:	00006517          	auipc	a0,0x6
    31ac:	b3850513          	addi	a0,a0,-1224 # 8ce0 <malloc+0xd72>
    31b0:	00005097          	auipc	ra,0x5
    31b4:	bcc080e7          	jalr	-1076(ra) # 7d7c <printf>
    exit(1);
    31b8:	4505                	li	a0,1
    31ba:	00004097          	auipc	ra,0x4
    31be:	69a080e7          	jalr	1690(ra) # 7854 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    31c2:	20200593          	li	a1,514
    31c6:	00006517          	auipc	a0,0x6
    31ca:	ac250513          	addi	a0,a0,-1342 # 8c88 <malloc+0xd1a>
    31ce:	00004097          	auipc	ra,0x4
    31d2:	6c6080e7          	jalr	1734(ra) # 7894 <open>
    31d6:	87aa                	mv	a5,a0
    31d8:	fef42423          	sw	a5,-24(s0)
  write(fd1, "yyy", 3);
    31dc:	fe842783          	lw	a5,-24(s0)
    31e0:	460d                	li	a2,3
    31e2:	00006597          	auipc	a1,0x6
    31e6:	b1e58593          	addi	a1,a1,-1250 # 8d00 <malloc+0xd92>
    31ea:	853e                	mv	a0,a5
    31ec:	00004097          	auipc	ra,0x4
    31f0:	688080e7          	jalr	1672(ra) # 7874 <write>
  close(fd1);
    31f4:	fe842783          	lw	a5,-24(s0)
    31f8:	853e                	mv	a0,a5
    31fa:	00004097          	auipc	ra,0x4
    31fe:	682080e7          	jalr	1666(ra) # 787c <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    3202:	fec42783          	lw	a5,-20(s0)
    3206:	660d                	lui	a2,0x3
    3208:	00009597          	auipc	a1,0x9
    320c:	0d858593          	addi	a1,a1,216 # c2e0 <buf>
    3210:	853e                	mv	a0,a5
    3212:	00004097          	auipc	ra,0x4
    3216:	65a080e7          	jalr	1626(ra) # 786c <read>
    321a:	87aa                	mv	a5,a0
    321c:	873e                	mv	a4,a5
    321e:	4795                	li	a5,5
    3220:	02f70163          	beq	a4,a5,3242 <unlinkread+0x166>
    printf("%s: unlinkread read failed", s);
    3224:	fd843583          	ld	a1,-40(s0)
    3228:	00006517          	auipc	a0,0x6
    322c:	ae050513          	addi	a0,a0,-1312 # 8d08 <malloc+0xd9a>
    3230:	00005097          	auipc	ra,0x5
    3234:	b4c080e7          	jalr	-1204(ra) # 7d7c <printf>
    exit(1);
    3238:	4505                	li	a0,1
    323a:	00004097          	auipc	ra,0x4
    323e:	61a080e7          	jalr	1562(ra) # 7854 <exit>
  }
  if(buf[0] != 'h'){
    3242:	00009797          	auipc	a5,0x9
    3246:	09e78793          	addi	a5,a5,158 # c2e0 <buf>
    324a:	0007c783          	lbu	a5,0(a5)
    324e:	873e                	mv	a4,a5
    3250:	06800793          	li	a5,104
    3254:	02f70163          	beq	a4,a5,3276 <unlinkread+0x19a>
    printf("%s: unlinkread wrong data\n", s);
    3258:	fd843583          	ld	a1,-40(s0)
    325c:	00006517          	auipc	a0,0x6
    3260:	acc50513          	addi	a0,a0,-1332 # 8d28 <malloc+0xdba>
    3264:	00005097          	auipc	ra,0x5
    3268:	b18080e7          	jalr	-1256(ra) # 7d7c <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	00004097          	auipc	ra,0x4
    3272:	5e6080e7          	jalr	1510(ra) # 7854 <exit>
  }
  if(write(fd, buf, 10) != 10){
    3276:	fec42783          	lw	a5,-20(s0)
    327a:	4629                	li	a2,10
    327c:	00009597          	auipc	a1,0x9
    3280:	06458593          	addi	a1,a1,100 # c2e0 <buf>
    3284:	853e                	mv	a0,a5
    3286:	00004097          	auipc	ra,0x4
    328a:	5ee080e7          	jalr	1518(ra) # 7874 <write>
    328e:	87aa                	mv	a5,a0
    3290:	873e                	mv	a4,a5
    3292:	47a9                	li	a5,10
    3294:	02f70163          	beq	a4,a5,32b6 <unlinkread+0x1da>
    printf("%s: unlinkread write failed\n", s);
    3298:	fd843583          	ld	a1,-40(s0)
    329c:	00006517          	auipc	a0,0x6
    32a0:	aac50513          	addi	a0,a0,-1364 # 8d48 <malloc+0xdda>
    32a4:	00005097          	auipc	ra,0x5
    32a8:	ad8080e7          	jalr	-1320(ra) # 7d7c <printf>
    exit(1);
    32ac:	4505                	li	a0,1
    32ae:	00004097          	auipc	ra,0x4
    32b2:	5a6080e7          	jalr	1446(ra) # 7854 <exit>
  }
  close(fd);
    32b6:	fec42783          	lw	a5,-20(s0)
    32ba:	853e                	mv	a0,a5
    32bc:	00004097          	auipc	ra,0x4
    32c0:	5c0080e7          	jalr	1472(ra) # 787c <close>
  unlink("unlinkread");
    32c4:	00006517          	auipc	a0,0x6
    32c8:	9c450513          	addi	a0,a0,-1596 # 8c88 <malloc+0xd1a>
    32cc:	00004097          	auipc	ra,0x4
    32d0:	5d8080e7          	jalr	1496(ra) # 78a4 <unlink>
}
    32d4:	0001                	nop
    32d6:	70a2                	ld	ra,40(sp)
    32d8:	7402                	ld	s0,32(sp)
    32da:	6145                	addi	sp,sp,48
    32dc:	8082                	ret

00000000000032de <linktest>:

void
linktest(char *s)
{
    32de:	7179                	addi	sp,sp,-48
    32e0:	f406                	sd	ra,40(sp)
    32e2:	f022                	sd	s0,32(sp)
    32e4:	1800                	addi	s0,sp,48
    32e6:	fca43c23          	sd	a0,-40(s0)
  enum { SZ = 5 };
  int fd;

  unlink("lf1");
    32ea:	00006517          	auipc	a0,0x6
    32ee:	a7e50513          	addi	a0,a0,-1410 # 8d68 <malloc+0xdfa>
    32f2:	00004097          	auipc	ra,0x4
    32f6:	5b2080e7          	jalr	1458(ra) # 78a4 <unlink>
  unlink("lf2");
    32fa:	00006517          	auipc	a0,0x6
    32fe:	a7650513          	addi	a0,a0,-1418 # 8d70 <malloc+0xe02>
    3302:	00004097          	auipc	ra,0x4
    3306:	5a2080e7          	jalr	1442(ra) # 78a4 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    330a:	20200593          	li	a1,514
    330e:	00006517          	auipc	a0,0x6
    3312:	a5a50513          	addi	a0,a0,-1446 # 8d68 <malloc+0xdfa>
    3316:	00004097          	auipc	ra,0x4
    331a:	57e080e7          	jalr	1406(ra) # 7894 <open>
    331e:	87aa                	mv	a5,a0
    3320:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3324:	fec42783          	lw	a5,-20(s0)
    3328:	2781                	sext.w	a5,a5
    332a:	0207d163          	bgez	a5,334c <linktest+0x6e>
    printf("%s: create lf1 failed\n", s);
    332e:	fd843583          	ld	a1,-40(s0)
    3332:	00006517          	auipc	a0,0x6
    3336:	a4650513          	addi	a0,a0,-1466 # 8d78 <malloc+0xe0a>
    333a:	00005097          	auipc	ra,0x5
    333e:	a42080e7          	jalr	-1470(ra) # 7d7c <printf>
    exit(1);
    3342:	4505                	li	a0,1
    3344:	00004097          	auipc	ra,0x4
    3348:	510080e7          	jalr	1296(ra) # 7854 <exit>
  }
  if(write(fd, "hello", SZ) != SZ){
    334c:	fec42783          	lw	a5,-20(s0)
    3350:	4615                	li	a2,5
    3352:	00006597          	auipc	a1,0x6
    3356:	96658593          	addi	a1,a1,-1690 # 8cb8 <malloc+0xd4a>
    335a:	853e                	mv	a0,a5
    335c:	00004097          	auipc	ra,0x4
    3360:	518080e7          	jalr	1304(ra) # 7874 <write>
    3364:	87aa                	mv	a5,a0
    3366:	873e                	mv	a4,a5
    3368:	4795                	li	a5,5
    336a:	02f70163          	beq	a4,a5,338c <linktest+0xae>
    printf("%s: write lf1 failed\n", s);
    336e:	fd843583          	ld	a1,-40(s0)
    3372:	00006517          	auipc	a0,0x6
    3376:	a1e50513          	addi	a0,a0,-1506 # 8d90 <malloc+0xe22>
    337a:	00005097          	auipc	ra,0x5
    337e:	a02080e7          	jalr	-1534(ra) # 7d7c <printf>
    exit(1);
    3382:	4505                	li	a0,1
    3384:	00004097          	auipc	ra,0x4
    3388:	4d0080e7          	jalr	1232(ra) # 7854 <exit>
  }
  close(fd);
    338c:	fec42783          	lw	a5,-20(s0)
    3390:	853e                	mv	a0,a5
    3392:	00004097          	auipc	ra,0x4
    3396:	4ea080e7          	jalr	1258(ra) # 787c <close>

  if(link("lf1", "lf2") < 0){
    339a:	00006597          	auipc	a1,0x6
    339e:	9d658593          	addi	a1,a1,-1578 # 8d70 <malloc+0xe02>
    33a2:	00006517          	auipc	a0,0x6
    33a6:	9c650513          	addi	a0,a0,-1594 # 8d68 <malloc+0xdfa>
    33aa:	00004097          	auipc	ra,0x4
    33ae:	50a080e7          	jalr	1290(ra) # 78b4 <link>
    33b2:	87aa                	mv	a5,a0
    33b4:	0207d163          	bgez	a5,33d6 <linktest+0xf8>
    printf("%s: link lf1 lf2 failed\n", s);
    33b8:	fd843583          	ld	a1,-40(s0)
    33bc:	00006517          	auipc	a0,0x6
    33c0:	9ec50513          	addi	a0,a0,-1556 # 8da8 <malloc+0xe3a>
    33c4:	00005097          	auipc	ra,0x5
    33c8:	9b8080e7          	jalr	-1608(ra) # 7d7c <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	00004097          	auipc	ra,0x4
    33d2:	486080e7          	jalr	1158(ra) # 7854 <exit>
  }
  unlink("lf1");
    33d6:	00006517          	auipc	a0,0x6
    33da:	99250513          	addi	a0,a0,-1646 # 8d68 <malloc+0xdfa>
    33de:	00004097          	auipc	ra,0x4
    33e2:	4c6080e7          	jalr	1222(ra) # 78a4 <unlink>

  if(open("lf1", 0) >= 0){
    33e6:	4581                	li	a1,0
    33e8:	00006517          	auipc	a0,0x6
    33ec:	98050513          	addi	a0,a0,-1664 # 8d68 <malloc+0xdfa>
    33f0:	00004097          	auipc	ra,0x4
    33f4:	4a4080e7          	jalr	1188(ra) # 7894 <open>
    33f8:	87aa                	mv	a5,a0
    33fa:	0207c163          	bltz	a5,341c <linktest+0x13e>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    33fe:	fd843583          	ld	a1,-40(s0)
    3402:	00006517          	auipc	a0,0x6
    3406:	9c650513          	addi	a0,a0,-1594 # 8dc8 <malloc+0xe5a>
    340a:	00005097          	auipc	ra,0x5
    340e:	972080e7          	jalr	-1678(ra) # 7d7c <printf>
    exit(1);
    3412:	4505                	li	a0,1
    3414:	00004097          	auipc	ra,0x4
    3418:	440080e7          	jalr	1088(ra) # 7854 <exit>
  }

  fd = open("lf2", 0);
    341c:	4581                	li	a1,0
    341e:	00006517          	auipc	a0,0x6
    3422:	95250513          	addi	a0,a0,-1710 # 8d70 <malloc+0xe02>
    3426:	00004097          	auipc	ra,0x4
    342a:	46e080e7          	jalr	1134(ra) # 7894 <open>
    342e:	87aa                	mv	a5,a0
    3430:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3434:	fec42783          	lw	a5,-20(s0)
    3438:	2781                	sext.w	a5,a5
    343a:	0207d163          	bgez	a5,345c <linktest+0x17e>
    printf("%s: open lf2 failed\n", s);
    343e:	fd843583          	ld	a1,-40(s0)
    3442:	00006517          	auipc	a0,0x6
    3446:	9b650513          	addi	a0,a0,-1610 # 8df8 <malloc+0xe8a>
    344a:	00005097          	auipc	ra,0x5
    344e:	932080e7          	jalr	-1742(ra) # 7d7c <printf>
    exit(1);
    3452:	4505                	li	a0,1
    3454:	00004097          	auipc	ra,0x4
    3458:	400080e7          	jalr	1024(ra) # 7854 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    345c:	fec42783          	lw	a5,-20(s0)
    3460:	660d                	lui	a2,0x3
    3462:	00009597          	auipc	a1,0x9
    3466:	e7e58593          	addi	a1,a1,-386 # c2e0 <buf>
    346a:	853e                	mv	a0,a5
    346c:	00004097          	auipc	ra,0x4
    3470:	400080e7          	jalr	1024(ra) # 786c <read>
    3474:	87aa                	mv	a5,a0
    3476:	873e                	mv	a4,a5
    3478:	4795                	li	a5,5
    347a:	02f70163          	beq	a4,a5,349c <linktest+0x1be>
    printf("%s: read lf2 failed\n", s);
    347e:	fd843583          	ld	a1,-40(s0)
    3482:	00006517          	auipc	a0,0x6
    3486:	98e50513          	addi	a0,a0,-1650 # 8e10 <malloc+0xea2>
    348a:	00005097          	auipc	ra,0x5
    348e:	8f2080e7          	jalr	-1806(ra) # 7d7c <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00004097          	auipc	ra,0x4
    3498:	3c0080e7          	jalr	960(ra) # 7854 <exit>
  }
  close(fd);
    349c:	fec42783          	lw	a5,-20(s0)
    34a0:	853e                	mv	a0,a5
    34a2:	00004097          	auipc	ra,0x4
    34a6:	3da080e7          	jalr	986(ra) # 787c <close>

  if(link("lf2", "lf2") >= 0){
    34aa:	00006597          	auipc	a1,0x6
    34ae:	8c658593          	addi	a1,a1,-1850 # 8d70 <malloc+0xe02>
    34b2:	00006517          	auipc	a0,0x6
    34b6:	8be50513          	addi	a0,a0,-1858 # 8d70 <malloc+0xe02>
    34ba:	00004097          	auipc	ra,0x4
    34be:	3fa080e7          	jalr	1018(ra) # 78b4 <link>
    34c2:	87aa                	mv	a5,a0
    34c4:	0207c163          	bltz	a5,34e6 <linktest+0x208>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    34c8:	fd843583          	ld	a1,-40(s0)
    34cc:	00006517          	auipc	a0,0x6
    34d0:	95c50513          	addi	a0,a0,-1700 # 8e28 <malloc+0xeba>
    34d4:	00005097          	auipc	ra,0x5
    34d8:	8a8080e7          	jalr	-1880(ra) # 7d7c <printf>
    exit(1);
    34dc:	4505                	li	a0,1
    34de:	00004097          	auipc	ra,0x4
    34e2:	376080e7          	jalr	886(ra) # 7854 <exit>
  }

  unlink("lf2");
    34e6:	00006517          	auipc	a0,0x6
    34ea:	88a50513          	addi	a0,a0,-1910 # 8d70 <malloc+0xe02>
    34ee:	00004097          	auipc	ra,0x4
    34f2:	3b6080e7          	jalr	950(ra) # 78a4 <unlink>
  if(link("lf2", "lf1") >= 0){
    34f6:	00006597          	auipc	a1,0x6
    34fa:	87258593          	addi	a1,a1,-1934 # 8d68 <malloc+0xdfa>
    34fe:	00006517          	auipc	a0,0x6
    3502:	87250513          	addi	a0,a0,-1934 # 8d70 <malloc+0xe02>
    3506:	00004097          	auipc	ra,0x4
    350a:	3ae080e7          	jalr	942(ra) # 78b4 <link>
    350e:	87aa                	mv	a5,a0
    3510:	0207c163          	bltz	a5,3532 <linktest+0x254>
    printf("%s: link non-existent succeeded! oops\n", s);
    3514:	fd843583          	ld	a1,-40(s0)
    3518:	00006517          	auipc	a0,0x6
    351c:	93850513          	addi	a0,a0,-1736 # 8e50 <malloc+0xee2>
    3520:	00005097          	auipc	ra,0x5
    3524:	85c080e7          	jalr	-1956(ra) # 7d7c <printf>
    exit(1);
    3528:	4505                	li	a0,1
    352a:	00004097          	auipc	ra,0x4
    352e:	32a080e7          	jalr	810(ra) # 7854 <exit>
  }

  if(link(".", "lf1") >= 0){
    3532:	00006597          	auipc	a1,0x6
    3536:	83658593          	addi	a1,a1,-1994 # 8d68 <malloc+0xdfa>
    353a:	00006517          	auipc	a0,0x6
    353e:	93e50513          	addi	a0,a0,-1730 # 8e78 <malloc+0xf0a>
    3542:	00004097          	auipc	ra,0x4
    3546:	372080e7          	jalr	882(ra) # 78b4 <link>
    354a:	87aa                	mv	a5,a0
    354c:	0207c163          	bltz	a5,356e <linktest+0x290>
    printf("%s: link . lf1 succeeded! oops\n", s);
    3550:	fd843583          	ld	a1,-40(s0)
    3554:	00006517          	auipc	a0,0x6
    3558:	92c50513          	addi	a0,a0,-1748 # 8e80 <malloc+0xf12>
    355c:	00005097          	auipc	ra,0x5
    3560:	820080e7          	jalr	-2016(ra) # 7d7c <printf>
    exit(1);
    3564:	4505                	li	a0,1
    3566:	00004097          	auipc	ra,0x4
    356a:	2ee080e7          	jalr	750(ra) # 7854 <exit>
  }
}
    356e:	0001                	nop
    3570:	70a2                	ld	ra,40(sp)
    3572:	7402                	ld	s0,32(sp)
    3574:	6145                	addi	sp,sp,48
    3576:	8082                	ret

0000000000003578 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(char *s)
{
    3578:	7119                	addi	sp,sp,-128
    357a:	fc86                	sd	ra,120(sp)
    357c:	f8a2                	sd	s0,112(sp)
    357e:	0100                	addi	s0,sp,128
    3580:	f8a43423          	sd	a0,-120(s0)
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  file[0] = 'C';
    3584:	04300793          	li	a5,67
    3588:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
    358c:	fc040d23          	sb	zero,-38(s0)
  for(i = 0; i < N; i++){
    3590:	fe042623          	sw	zero,-20(s0)
    3594:	a225                	j	36bc <concreate+0x144>
    file[1] = '0' + i;
    3596:	fec42783          	lw	a5,-20(s0)
    359a:	0ff7f793          	zext.b	a5,a5
    359e:	0307879b          	addiw	a5,a5,48
    35a2:	0ff7f793          	zext.b	a5,a5
    35a6:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
    35aa:	fd840793          	addi	a5,s0,-40
    35ae:	853e                	mv	a0,a5
    35b0:	00004097          	auipc	ra,0x4
    35b4:	2f4080e7          	jalr	756(ra) # 78a4 <unlink>
    pid = fork();
    35b8:	00004097          	auipc	ra,0x4
    35bc:	294080e7          	jalr	660(ra) # 784c <fork>
    35c0:	87aa                	mv	a5,a0
    35c2:	fef42023          	sw	a5,-32(s0)
    if(pid && (i % 3) == 1){
    35c6:	fe042783          	lw	a5,-32(s0)
    35ca:	2781                	sext.w	a5,a5
    35cc:	cb85                	beqz	a5,35fc <concreate+0x84>
    35ce:	fec42783          	lw	a5,-20(s0)
    35d2:	873e                	mv	a4,a5
    35d4:	478d                	li	a5,3
    35d6:	02f767bb          	remw	a5,a4,a5
    35da:	2781                	sext.w	a5,a5
    35dc:	873e                	mv	a4,a5
    35de:	4785                	li	a5,1
    35e0:	00f71e63          	bne	a4,a5,35fc <concreate+0x84>
      link("C0", file);
    35e4:	fd840793          	addi	a5,s0,-40
    35e8:	85be                	mv	a1,a5
    35ea:	00006517          	auipc	a0,0x6
    35ee:	8b650513          	addi	a0,a0,-1866 # 8ea0 <malloc+0xf32>
    35f2:	00004097          	auipc	ra,0x4
    35f6:	2c2080e7          	jalr	706(ra) # 78b4 <link>
    35fa:	a061                	j	3682 <concreate+0x10a>
    } else if(pid == 0 && (i % 5) == 1){
    35fc:	fe042783          	lw	a5,-32(s0)
    3600:	2781                	sext.w	a5,a5
    3602:	eb85                	bnez	a5,3632 <concreate+0xba>
    3604:	fec42783          	lw	a5,-20(s0)
    3608:	873e                	mv	a4,a5
    360a:	4795                	li	a5,5
    360c:	02f767bb          	remw	a5,a4,a5
    3610:	2781                	sext.w	a5,a5
    3612:	873e                	mv	a4,a5
    3614:	4785                	li	a5,1
    3616:	00f71e63          	bne	a4,a5,3632 <concreate+0xba>
      link("C0", file);
    361a:	fd840793          	addi	a5,s0,-40
    361e:	85be                	mv	a1,a5
    3620:	00006517          	auipc	a0,0x6
    3624:	88050513          	addi	a0,a0,-1920 # 8ea0 <malloc+0xf32>
    3628:	00004097          	auipc	ra,0x4
    362c:	28c080e7          	jalr	652(ra) # 78b4 <link>
    3630:	a889                	j	3682 <concreate+0x10a>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    3632:	fd840793          	addi	a5,s0,-40
    3636:	20200593          	li	a1,514
    363a:	853e                	mv	a0,a5
    363c:	00004097          	auipc	ra,0x4
    3640:	258080e7          	jalr	600(ra) # 7894 <open>
    3644:	87aa                	mv	a5,a0
    3646:	fef42223          	sw	a5,-28(s0)
      if(fd < 0){
    364a:	fe442783          	lw	a5,-28(s0)
    364e:	2781                	sext.w	a5,a5
    3650:	0207d263          	bgez	a5,3674 <concreate+0xfc>
        printf("concreate create %s failed\n", file);
    3654:	fd840793          	addi	a5,s0,-40
    3658:	85be                	mv	a1,a5
    365a:	00006517          	auipc	a0,0x6
    365e:	84e50513          	addi	a0,a0,-1970 # 8ea8 <malloc+0xf3a>
    3662:	00004097          	auipc	ra,0x4
    3666:	71a080e7          	jalr	1818(ra) # 7d7c <printf>
        exit(1);
    366a:	4505                	li	a0,1
    366c:	00004097          	auipc	ra,0x4
    3670:	1e8080e7          	jalr	488(ra) # 7854 <exit>
      }
      close(fd);
    3674:	fe442783          	lw	a5,-28(s0)
    3678:	853e                	mv	a0,a5
    367a:	00004097          	auipc	ra,0x4
    367e:	202080e7          	jalr	514(ra) # 787c <close>
    }
    if(pid == 0) {
    3682:	fe042783          	lw	a5,-32(s0)
    3686:	2781                	sext.w	a5,a5
    3688:	e791                	bnez	a5,3694 <concreate+0x11c>
      exit(0);
    368a:	4501                	li	a0,0
    368c:	00004097          	auipc	ra,0x4
    3690:	1c8080e7          	jalr	456(ra) # 7854 <exit>
    } else {
      int xstatus;
      wait(&xstatus);
    3694:	f9c40793          	addi	a5,s0,-100
    3698:	853e                	mv	a0,a5
    369a:	00004097          	auipc	ra,0x4
    369e:	1c2080e7          	jalr	450(ra) # 785c <wait>
      if(xstatus != 0)
    36a2:	f9c42783          	lw	a5,-100(s0)
    36a6:	c791                	beqz	a5,36b2 <concreate+0x13a>
        exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00004097          	auipc	ra,0x4
    36ae:	1aa080e7          	jalr	426(ra) # 7854 <exit>
  for(i = 0; i < N; i++){
    36b2:	fec42783          	lw	a5,-20(s0)
    36b6:	2785                	addiw	a5,a5,1
    36b8:	fef42623          	sw	a5,-20(s0)
    36bc:	fec42783          	lw	a5,-20(s0)
    36c0:	0007871b          	sext.w	a4,a5
    36c4:	02700793          	li	a5,39
    36c8:	ece7d7e3          	bge	a5,a4,3596 <concreate+0x1e>
    }
  }

  memset(fa, 0, sizeof(fa));
    36cc:	fb040793          	addi	a5,s0,-80
    36d0:	02800613          	li	a2,40
    36d4:	4581                	li	a1,0
    36d6:	853e                	mv	a0,a5
    36d8:	00004097          	auipc	ra,0x4
    36dc:	dd0080e7          	jalr	-560(ra) # 74a8 <memset>
  fd = open(".", 0);
    36e0:	4581                	li	a1,0
    36e2:	00005517          	auipc	a0,0x5
    36e6:	79650513          	addi	a0,a0,1942 # 8e78 <malloc+0xf0a>
    36ea:	00004097          	auipc	ra,0x4
    36ee:	1aa080e7          	jalr	426(ra) # 7894 <open>
    36f2:	87aa                	mv	a5,a0
    36f4:	fef42223          	sw	a5,-28(s0)
  n = 0;
    36f8:	fe042423          	sw	zero,-24(s0)
  while(read(fd, &de, sizeof(de)) > 0){
    36fc:	a865                	j	37b4 <concreate+0x23c>
    if(de.inum == 0)
    36fe:	fa045783          	lhu	a5,-96(s0)
    3702:	cbc5                	beqz	a5,37b2 <concreate+0x23a>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3704:	fa244783          	lbu	a5,-94(s0)
    3708:	873e                	mv	a4,a5
    370a:	04300793          	li	a5,67
    370e:	0af71363          	bne	a4,a5,37b4 <concreate+0x23c>
    3712:	fa444783          	lbu	a5,-92(s0)
    3716:	efd9                	bnez	a5,37b4 <concreate+0x23c>
      i = de.name[1] - '0';
    3718:	fa344783          	lbu	a5,-93(s0)
    371c:	2781                	sext.w	a5,a5
    371e:	fd07879b          	addiw	a5,a5,-48
    3722:	fef42623          	sw	a5,-20(s0)
      if(i < 0 || i >= sizeof(fa)){
    3726:	fec42783          	lw	a5,-20(s0)
    372a:	2781                	sext.w	a5,a5
    372c:	0007c963          	bltz	a5,373e <concreate+0x1c6>
    3730:	fec42783          	lw	a5,-20(s0)
    3734:	873e                	mv	a4,a5
    3736:	02700793          	li	a5,39
    373a:	02e7f563          	bgeu	a5,a4,3764 <concreate+0x1ec>
        printf("%s: concreate weird file %s\n", s, de.name);
    373e:	fa040793          	addi	a5,s0,-96
    3742:	0789                	addi	a5,a5,2
    3744:	863e                	mv	a2,a5
    3746:	f8843583          	ld	a1,-120(s0)
    374a:	00005517          	auipc	a0,0x5
    374e:	77e50513          	addi	a0,a0,1918 # 8ec8 <malloc+0xf5a>
    3752:	00004097          	auipc	ra,0x4
    3756:	62a080e7          	jalr	1578(ra) # 7d7c <printf>
        exit(1);
    375a:	4505                	li	a0,1
    375c:	00004097          	auipc	ra,0x4
    3760:	0f8080e7          	jalr	248(ra) # 7854 <exit>
      }
      if(fa[i]){
    3764:	fec42783          	lw	a5,-20(s0)
    3768:	17c1                	addi	a5,a5,-16
    376a:	97a2                	add	a5,a5,s0
    376c:	fc07c783          	lbu	a5,-64(a5)
    3770:	c785                	beqz	a5,3798 <concreate+0x220>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3772:	fa040793          	addi	a5,s0,-96
    3776:	0789                	addi	a5,a5,2
    3778:	863e                	mv	a2,a5
    377a:	f8843583          	ld	a1,-120(s0)
    377e:	00005517          	auipc	a0,0x5
    3782:	76a50513          	addi	a0,a0,1898 # 8ee8 <malloc+0xf7a>
    3786:	00004097          	auipc	ra,0x4
    378a:	5f6080e7          	jalr	1526(ra) # 7d7c <printf>
        exit(1);
    378e:	4505                	li	a0,1
    3790:	00004097          	auipc	ra,0x4
    3794:	0c4080e7          	jalr	196(ra) # 7854 <exit>
      }
      fa[i] = 1;
    3798:	fec42783          	lw	a5,-20(s0)
    379c:	17c1                	addi	a5,a5,-16
    379e:	97a2                	add	a5,a5,s0
    37a0:	4705                	li	a4,1
    37a2:	fce78023          	sb	a4,-64(a5)
      n++;
    37a6:	fe842783          	lw	a5,-24(s0)
    37aa:	2785                	addiw	a5,a5,1
    37ac:	fef42423          	sw	a5,-24(s0)
    37b0:	a011                	j	37b4 <concreate+0x23c>
      continue;
    37b2:	0001                	nop
  while(read(fd, &de, sizeof(de)) > 0){
    37b4:	fa040713          	addi	a4,s0,-96
    37b8:	fe442783          	lw	a5,-28(s0)
    37bc:	4641                	li	a2,16
    37be:	85ba                	mv	a1,a4
    37c0:	853e                	mv	a0,a5
    37c2:	00004097          	auipc	ra,0x4
    37c6:	0aa080e7          	jalr	170(ra) # 786c <read>
    37ca:	87aa                	mv	a5,a0
    37cc:	f2f049e3          	bgtz	a5,36fe <concreate+0x186>
    }
  }
  close(fd);
    37d0:	fe442783          	lw	a5,-28(s0)
    37d4:	853e                	mv	a0,a5
    37d6:	00004097          	auipc	ra,0x4
    37da:	0a6080e7          	jalr	166(ra) # 787c <close>

  if(n != N){
    37de:	fe842783          	lw	a5,-24(s0)
    37e2:	0007871b          	sext.w	a4,a5
    37e6:	02800793          	li	a5,40
    37ea:	02f70163          	beq	a4,a5,380c <concreate+0x294>
    printf("%s: concreate not enough files in directory listing\n", s);
    37ee:	f8843583          	ld	a1,-120(s0)
    37f2:	00005517          	auipc	a0,0x5
    37f6:	71e50513          	addi	a0,a0,1822 # 8f10 <malloc+0xfa2>
    37fa:	00004097          	auipc	ra,0x4
    37fe:	582080e7          	jalr	1410(ra) # 7d7c <printf>
    exit(1);
    3802:	4505                	li	a0,1
    3804:	00004097          	auipc	ra,0x4
    3808:	050080e7          	jalr	80(ra) # 7854 <exit>
  }

  for(i = 0; i < N; i++){
    380c:	fe042623          	sw	zero,-20(s0)
    3810:	a25d                	j	39b6 <concreate+0x43e>
    file[1] = '0' + i;
    3812:	fec42783          	lw	a5,-20(s0)
    3816:	0ff7f793          	zext.b	a5,a5
    381a:	0307879b          	addiw	a5,a5,48
    381e:	0ff7f793          	zext.b	a5,a5
    3822:	fcf40ca3          	sb	a5,-39(s0)
    pid = fork();
    3826:	00004097          	auipc	ra,0x4
    382a:	026080e7          	jalr	38(ra) # 784c <fork>
    382e:	87aa                	mv	a5,a0
    3830:	fef42023          	sw	a5,-32(s0)
    if(pid < 0){
    3834:	fe042783          	lw	a5,-32(s0)
    3838:	2781                	sext.w	a5,a5
    383a:	0207d163          	bgez	a5,385c <concreate+0x2e4>
      printf("%s: fork failed\n", s);
    383e:	f8843583          	ld	a1,-120(s0)
    3842:	00005517          	auipc	a0,0x5
    3846:	cae50513          	addi	a0,a0,-850 # 84f0 <malloc+0x582>
    384a:	00004097          	auipc	ra,0x4
    384e:	532080e7          	jalr	1330(ra) # 7d7c <printf>
      exit(1);
    3852:	4505                	li	a0,1
    3854:	00004097          	auipc	ra,0x4
    3858:	000080e7          	jalr	ra # 7854 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    385c:	fec42783          	lw	a5,-20(s0)
    3860:	873e                	mv	a4,a5
    3862:	478d                	li	a5,3
    3864:	02f767bb          	remw	a5,a4,a5
    3868:	2781                	sext.w	a5,a5
    386a:	e789                	bnez	a5,3874 <concreate+0x2fc>
    386c:	fe042783          	lw	a5,-32(s0)
    3870:	2781                	sext.w	a5,a5
    3872:	c385                	beqz	a5,3892 <concreate+0x31a>
       ((i % 3) == 1 && pid != 0)){
    3874:	fec42783          	lw	a5,-20(s0)
    3878:	873e                	mv	a4,a5
    387a:	478d                	li	a5,3
    387c:	02f767bb          	remw	a5,a4,a5
    3880:	2781                	sext.w	a5,a5
    if(((i % 3) == 0 && pid == 0) ||
    3882:	873e                	mv	a4,a5
    3884:	4785                	li	a5,1
    3886:	0af71b63          	bne	a4,a5,393c <concreate+0x3c4>
       ((i % 3) == 1 && pid != 0)){
    388a:	fe042783          	lw	a5,-32(s0)
    388e:	2781                	sext.w	a5,a5
    3890:	c7d5                	beqz	a5,393c <concreate+0x3c4>
      close(open(file, 0));
    3892:	fd840793          	addi	a5,s0,-40
    3896:	4581                	li	a1,0
    3898:	853e                	mv	a0,a5
    389a:	00004097          	auipc	ra,0x4
    389e:	ffa080e7          	jalr	-6(ra) # 7894 <open>
    38a2:	87aa                	mv	a5,a0
    38a4:	853e                	mv	a0,a5
    38a6:	00004097          	auipc	ra,0x4
    38aa:	fd6080e7          	jalr	-42(ra) # 787c <close>
      close(open(file, 0));
    38ae:	fd840793          	addi	a5,s0,-40
    38b2:	4581                	li	a1,0
    38b4:	853e                	mv	a0,a5
    38b6:	00004097          	auipc	ra,0x4
    38ba:	fde080e7          	jalr	-34(ra) # 7894 <open>
    38be:	87aa                	mv	a5,a0
    38c0:	853e                	mv	a0,a5
    38c2:	00004097          	auipc	ra,0x4
    38c6:	fba080e7          	jalr	-70(ra) # 787c <close>
      close(open(file, 0));
    38ca:	fd840793          	addi	a5,s0,-40
    38ce:	4581                	li	a1,0
    38d0:	853e                	mv	a0,a5
    38d2:	00004097          	auipc	ra,0x4
    38d6:	fc2080e7          	jalr	-62(ra) # 7894 <open>
    38da:	87aa                	mv	a5,a0
    38dc:	853e                	mv	a0,a5
    38de:	00004097          	auipc	ra,0x4
    38e2:	f9e080e7          	jalr	-98(ra) # 787c <close>
      close(open(file, 0));
    38e6:	fd840793          	addi	a5,s0,-40
    38ea:	4581                	li	a1,0
    38ec:	853e                	mv	a0,a5
    38ee:	00004097          	auipc	ra,0x4
    38f2:	fa6080e7          	jalr	-90(ra) # 7894 <open>
    38f6:	87aa                	mv	a5,a0
    38f8:	853e                	mv	a0,a5
    38fa:	00004097          	auipc	ra,0x4
    38fe:	f82080e7          	jalr	-126(ra) # 787c <close>
      close(open(file, 0));
    3902:	fd840793          	addi	a5,s0,-40
    3906:	4581                	li	a1,0
    3908:	853e                	mv	a0,a5
    390a:	00004097          	auipc	ra,0x4
    390e:	f8a080e7          	jalr	-118(ra) # 7894 <open>
    3912:	87aa                	mv	a5,a0
    3914:	853e                	mv	a0,a5
    3916:	00004097          	auipc	ra,0x4
    391a:	f66080e7          	jalr	-154(ra) # 787c <close>
      close(open(file, 0));
    391e:	fd840793          	addi	a5,s0,-40
    3922:	4581                	li	a1,0
    3924:	853e                	mv	a0,a5
    3926:	00004097          	auipc	ra,0x4
    392a:	f6e080e7          	jalr	-146(ra) # 7894 <open>
    392e:	87aa                	mv	a5,a0
    3930:	853e                	mv	a0,a5
    3932:	00004097          	auipc	ra,0x4
    3936:	f4a080e7          	jalr	-182(ra) # 787c <close>
    393a:	a899                	j	3990 <concreate+0x418>
    } else {
      unlink(file);
    393c:	fd840793          	addi	a5,s0,-40
    3940:	853e                	mv	a0,a5
    3942:	00004097          	auipc	ra,0x4
    3946:	f62080e7          	jalr	-158(ra) # 78a4 <unlink>
      unlink(file);
    394a:	fd840793          	addi	a5,s0,-40
    394e:	853e                	mv	a0,a5
    3950:	00004097          	auipc	ra,0x4
    3954:	f54080e7          	jalr	-172(ra) # 78a4 <unlink>
      unlink(file);
    3958:	fd840793          	addi	a5,s0,-40
    395c:	853e                	mv	a0,a5
    395e:	00004097          	auipc	ra,0x4
    3962:	f46080e7          	jalr	-186(ra) # 78a4 <unlink>
      unlink(file);
    3966:	fd840793          	addi	a5,s0,-40
    396a:	853e                	mv	a0,a5
    396c:	00004097          	auipc	ra,0x4
    3970:	f38080e7          	jalr	-200(ra) # 78a4 <unlink>
      unlink(file);
    3974:	fd840793          	addi	a5,s0,-40
    3978:	853e                	mv	a0,a5
    397a:	00004097          	auipc	ra,0x4
    397e:	f2a080e7          	jalr	-214(ra) # 78a4 <unlink>
      unlink(file);
    3982:	fd840793          	addi	a5,s0,-40
    3986:	853e                	mv	a0,a5
    3988:	00004097          	auipc	ra,0x4
    398c:	f1c080e7          	jalr	-228(ra) # 78a4 <unlink>
    }
    if(pid == 0)
    3990:	fe042783          	lw	a5,-32(s0)
    3994:	2781                	sext.w	a5,a5
    3996:	e791                	bnez	a5,39a2 <concreate+0x42a>
      exit(0);
    3998:	4501                	li	a0,0
    399a:	00004097          	auipc	ra,0x4
    399e:	eba080e7          	jalr	-326(ra) # 7854 <exit>
    else
      wait(0);
    39a2:	4501                	li	a0,0
    39a4:	00004097          	auipc	ra,0x4
    39a8:	eb8080e7          	jalr	-328(ra) # 785c <wait>
  for(i = 0; i < N; i++){
    39ac:	fec42783          	lw	a5,-20(s0)
    39b0:	2785                	addiw	a5,a5,1
    39b2:	fef42623          	sw	a5,-20(s0)
    39b6:	fec42783          	lw	a5,-20(s0)
    39ba:	0007871b          	sext.w	a4,a5
    39be:	02700793          	li	a5,39
    39c2:	e4e7d8e3          	bge	a5,a4,3812 <concreate+0x29a>
  }
}
    39c6:	0001                	nop
    39c8:	0001                	nop
    39ca:	70e6                	ld	ra,120(sp)
    39cc:	7446                	ld	s0,112(sp)
    39ce:	6109                	addi	sp,sp,128
    39d0:	8082                	ret

00000000000039d2 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink(char *s)
{
    39d2:	7179                	addi	sp,sp,-48
    39d4:	f406                	sd	ra,40(sp)
    39d6:	f022                	sd	s0,32(sp)
    39d8:	1800                	addi	s0,sp,48
    39da:	fca43c23          	sd	a0,-40(s0)
  int pid, i;

  unlink("x");
    39de:	00004517          	auipc	a0,0x4
    39e2:	7e250513          	addi	a0,a0,2018 # 81c0 <malloc+0x252>
    39e6:	00004097          	auipc	ra,0x4
    39ea:	ebe080e7          	jalr	-322(ra) # 78a4 <unlink>
  pid = fork();
    39ee:	00004097          	auipc	ra,0x4
    39f2:	e5e080e7          	jalr	-418(ra) # 784c <fork>
    39f6:	87aa                	mv	a5,a0
    39f8:	fef42223          	sw	a5,-28(s0)
  if(pid < 0){
    39fc:	fe442783          	lw	a5,-28(s0)
    3a00:	2781                	sext.w	a5,a5
    3a02:	0207d163          	bgez	a5,3a24 <linkunlink+0x52>
    printf("%s: fork failed\n", s);
    3a06:	fd843583          	ld	a1,-40(s0)
    3a0a:	00005517          	auipc	a0,0x5
    3a0e:	ae650513          	addi	a0,a0,-1306 # 84f0 <malloc+0x582>
    3a12:	00004097          	auipc	ra,0x4
    3a16:	36a080e7          	jalr	874(ra) # 7d7c <printf>
    exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	00004097          	auipc	ra,0x4
    3a20:	e38080e7          	jalr	-456(ra) # 7854 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    3a24:	fe442783          	lw	a5,-28(s0)
    3a28:	2781                	sext.w	a5,a5
    3a2a:	c399                	beqz	a5,3a30 <linkunlink+0x5e>
    3a2c:	4785                	li	a5,1
    3a2e:	a019                	j	3a34 <linkunlink+0x62>
    3a30:	06100793          	li	a5,97
    3a34:	fef42423          	sw	a5,-24(s0)
  for(i = 0; i < 100; i++){
    3a38:	fe042623          	sw	zero,-20(s0)
    3a3c:	a045                	j	3adc <linkunlink+0x10a>
    x = x * 1103515245 + 12345;
    3a3e:	fe842783          	lw	a5,-24(s0)
    3a42:	873e                	mv	a4,a5
    3a44:	41c657b7          	lui	a5,0x41c65
    3a48:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <freep+0x41c52365>
    3a4c:	02f707bb          	mulw	a5,a4,a5
    3a50:	0007871b          	sext.w	a4,a5
    3a54:	678d                	lui	a5,0x3
    3a56:	0397879b          	addiw	a5,a5,57 # 3039 <createdelete+0x2b9>
    3a5a:	9fb9                	addw	a5,a5,a4
    3a5c:	fef42423          	sw	a5,-24(s0)
    if((x % 3) == 0){
    3a60:	fe842783          	lw	a5,-24(s0)
    3a64:	873e                	mv	a4,a5
    3a66:	478d                	li	a5,3
    3a68:	02f777bb          	remuw	a5,a4,a5
    3a6c:	2781                	sext.w	a5,a5
    3a6e:	e395                	bnez	a5,3a92 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    3a70:	20200593          	li	a1,514
    3a74:	00004517          	auipc	a0,0x4
    3a78:	74c50513          	addi	a0,a0,1868 # 81c0 <malloc+0x252>
    3a7c:	00004097          	auipc	ra,0x4
    3a80:	e18080e7          	jalr	-488(ra) # 7894 <open>
    3a84:	87aa                	mv	a5,a0
    3a86:	853e                	mv	a0,a5
    3a88:	00004097          	auipc	ra,0x4
    3a8c:	df4080e7          	jalr	-524(ra) # 787c <close>
    3a90:	a089                	j	3ad2 <linkunlink+0x100>
    } else if((x % 3) == 1){
    3a92:	fe842783          	lw	a5,-24(s0)
    3a96:	873e                	mv	a4,a5
    3a98:	478d                	li	a5,3
    3a9a:	02f777bb          	remuw	a5,a4,a5
    3a9e:	2781                	sext.w	a5,a5
    3aa0:	873e                	mv	a4,a5
    3aa2:	4785                	li	a5,1
    3aa4:	00f71f63          	bne	a4,a5,3ac2 <linkunlink+0xf0>
      link("cat", "x");
    3aa8:	00004597          	auipc	a1,0x4
    3aac:	71858593          	addi	a1,a1,1816 # 81c0 <malloc+0x252>
    3ab0:	00005517          	auipc	a0,0x5
    3ab4:	49850513          	addi	a0,a0,1176 # 8f48 <malloc+0xfda>
    3ab8:	00004097          	auipc	ra,0x4
    3abc:	dfc080e7          	jalr	-516(ra) # 78b4 <link>
    3ac0:	a809                	j	3ad2 <linkunlink+0x100>
    } else {
      unlink("x");
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	6fe50513          	addi	a0,a0,1790 # 81c0 <malloc+0x252>
    3aca:	00004097          	auipc	ra,0x4
    3ace:	dda080e7          	jalr	-550(ra) # 78a4 <unlink>
  for(i = 0; i < 100; i++){
    3ad2:	fec42783          	lw	a5,-20(s0)
    3ad6:	2785                	addiw	a5,a5,1
    3ad8:	fef42623          	sw	a5,-20(s0)
    3adc:	fec42783          	lw	a5,-20(s0)
    3ae0:	0007871b          	sext.w	a4,a5
    3ae4:	06300793          	li	a5,99
    3ae8:	f4e7dbe3          	bge	a5,a4,3a3e <linkunlink+0x6c>
    }
  }

  if(pid)
    3aec:	fe442783          	lw	a5,-28(s0)
    3af0:	2781                	sext.w	a5,a5
    3af2:	c799                	beqz	a5,3b00 <linkunlink+0x12e>
    wait(0);
    3af4:	4501                	li	a0,0
    3af6:	00004097          	auipc	ra,0x4
    3afa:	d66080e7          	jalr	-666(ra) # 785c <wait>
  else
    exit(0);
}
    3afe:	a031                	j	3b0a <linkunlink+0x138>
    exit(0);
    3b00:	4501                	li	a0,0
    3b02:	00004097          	auipc	ra,0x4
    3b06:	d52080e7          	jalr	-686(ra) # 7854 <exit>
}
    3b0a:	70a2                	ld	ra,40(sp)
    3b0c:	7402                	ld	s0,32(sp)
    3b0e:	6145                	addi	sp,sp,48
    3b10:	8082                	ret

0000000000003b12 <subdir>:


void
subdir(char *s)
{
    3b12:	7179                	addi	sp,sp,-48
    3b14:	f406                	sd	ra,40(sp)
    3b16:	f022                	sd	s0,32(sp)
    3b18:	1800                	addi	s0,sp,48
    3b1a:	fca43c23          	sd	a0,-40(s0)
  int fd, cc;

  unlink("ff");
    3b1e:	00005517          	auipc	a0,0x5
    3b22:	43250513          	addi	a0,a0,1074 # 8f50 <malloc+0xfe2>
    3b26:	00004097          	auipc	ra,0x4
    3b2a:	d7e080e7          	jalr	-642(ra) # 78a4 <unlink>
  if(mkdir("dd") != 0){
    3b2e:	00005517          	auipc	a0,0x5
    3b32:	42a50513          	addi	a0,a0,1066 # 8f58 <malloc+0xfea>
    3b36:	00004097          	auipc	ra,0x4
    3b3a:	d86080e7          	jalr	-634(ra) # 78bc <mkdir>
    3b3e:	87aa                	mv	a5,a0
    3b40:	c385                	beqz	a5,3b60 <subdir+0x4e>
    printf("%s: mkdir dd failed\n", s);
    3b42:	fd843583          	ld	a1,-40(s0)
    3b46:	00005517          	auipc	a0,0x5
    3b4a:	41a50513          	addi	a0,a0,1050 # 8f60 <malloc+0xff2>
    3b4e:	00004097          	auipc	ra,0x4
    3b52:	22e080e7          	jalr	558(ra) # 7d7c <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00004097          	auipc	ra,0x4
    3b5c:	cfc080e7          	jalr	-772(ra) # 7854 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    3b60:	20200593          	li	a1,514
    3b64:	00005517          	auipc	a0,0x5
    3b68:	41450513          	addi	a0,a0,1044 # 8f78 <malloc+0x100a>
    3b6c:	00004097          	auipc	ra,0x4
    3b70:	d28080e7          	jalr	-728(ra) # 7894 <open>
    3b74:	87aa                	mv	a5,a0
    3b76:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3b7a:	fec42783          	lw	a5,-20(s0)
    3b7e:	2781                	sext.w	a5,a5
    3b80:	0207d163          	bgez	a5,3ba2 <subdir+0x90>
    printf("%s: create dd/ff failed\n", s);
    3b84:	fd843583          	ld	a1,-40(s0)
    3b88:	00005517          	auipc	a0,0x5
    3b8c:	3f850513          	addi	a0,a0,1016 # 8f80 <malloc+0x1012>
    3b90:	00004097          	auipc	ra,0x4
    3b94:	1ec080e7          	jalr	492(ra) # 7d7c <printf>
    exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	00004097          	auipc	ra,0x4
    3b9e:	cba080e7          	jalr	-838(ra) # 7854 <exit>
  }
  write(fd, "ff", 2);
    3ba2:	fec42783          	lw	a5,-20(s0)
    3ba6:	4609                	li	a2,2
    3ba8:	00005597          	auipc	a1,0x5
    3bac:	3a858593          	addi	a1,a1,936 # 8f50 <malloc+0xfe2>
    3bb0:	853e                	mv	a0,a5
    3bb2:	00004097          	auipc	ra,0x4
    3bb6:	cc2080e7          	jalr	-830(ra) # 7874 <write>
  close(fd);
    3bba:	fec42783          	lw	a5,-20(s0)
    3bbe:	853e                	mv	a0,a5
    3bc0:	00004097          	auipc	ra,0x4
    3bc4:	cbc080e7          	jalr	-836(ra) # 787c <close>

  if(unlink("dd") >= 0){
    3bc8:	00005517          	auipc	a0,0x5
    3bcc:	39050513          	addi	a0,a0,912 # 8f58 <malloc+0xfea>
    3bd0:	00004097          	auipc	ra,0x4
    3bd4:	cd4080e7          	jalr	-812(ra) # 78a4 <unlink>
    3bd8:	87aa                	mv	a5,a0
    3bda:	0207c163          	bltz	a5,3bfc <subdir+0xea>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3bde:	fd843583          	ld	a1,-40(s0)
    3be2:	00005517          	auipc	a0,0x5
    3be6:	3be50513          	addi	a0,a0,958 # 8fa0 <malloc+0x1032>
    3bea:	00004097          	auipc	ra,0x4
    3bee:	192080e7          	jalr	402(ra) # 7d7c <printf>
    exit(1);
    3bf2:	4505                	li	a0,1
    3bf4:	00004097          	auipc	ra,0x4
    3bf8:	c60080e7          	jalr	-928(ra) # 7854 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    3bfc:	00005517          	auipc	a0,0x5
    3c00:	3d450513          	addi	a0,a0,980 # 8fd0 <malloc+0x1062>
    3c04:	00004097          	auipc	ra,0x4
    3c08:	cb8080e7          	jalr	-840(ra) # 78bc <mkdir>
    3c0c:	87aa                	mv	a5,a0
    3c0e:	c385                	beqz	a5,3c2e <subdir+0x11c>
    printf("subdir mkdir dd/dd failed\n", s);
    3c10:	fd843583          	ld	a1,-40(s0)
    3c14:	00005517          	auipc	a0,0x5
    3c18:	3c450513          	addi	a0,a0,964 # 8fd8 <malloc+0x106a>
    3c1c:	00004097          	auipc	ra,0x4
    3c20:	160080e7          	jalr	352(ra) # 7d7c <printf>
    exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00004097          	auipc	ra,0x4
    3c2a:	c2e080e7          	jalr	-978(ra) # 7854 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3c2e:	20200593          	li	a1,514
    3c32:	00005517          	auipc	a0,0x5
    3c36:	3c650513          	addi	a0,a0,966 # 8ff8 <malloc+0x108a>
    3c3a:	00004097          	auipc	ra,0x4
    3c3e:	c5a080e7          	jalr	-934(ra) # 7894 <open>
    3c42:	87aa                	mv	a5,a0
    3c44:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3c48:	fec42783          	lw	a5,-20(s0)
    3c4c:	2781                	sext.w	a5,a5
    3c4e:	0207d163          	bgez	a5,3c70 <subdir+0x15e>
    printf("%s: create dd/dd/ff failed\n", s);
    3c52:	fd843583          	ld	a1,-40(s0)
    3c56:	00005517          	auipc	a0,0x5
    3c5a:	3b250513          	addi	a0,a0,946 # 9008 <malloc+0x109a>
    3c5e:	00004097          	auipc	ra,0x4
    3c62:	11e080e7          	jalr	286(ra) # 7d7c <printf>
    exit(1);
    3c66:	4505                	li	a0,1
    3c68:	00004097          	auipc	ra,0x4
    3c6c:	bec080e7          	jalr	-1044(ra) # 7854 <exit>
  }
  write(fd, "FF", 2);
    3c70:	fec42783          	lw	a5,-20(s0)
    3c74:	4609                	li	a2,2
    3c76:	00005597          	auipc	a1,0x5
    3c7a:	3b258593          	addi	a1,a1,946 # 9028 <malloc+0x10ba>
    3c7e:	853e                	mv	a0,a5
    3c80:	00004097          	auipc	ra,0x4
    3c84:	bf4080e7          	jalr	-1036(ra) # 7874 <write>
  close(fd);
    3c88:	fec42783          	lw	a5,-20(s0)
    3c8c:	853e                	mv	a0,a5
    3c8e:	00004097          	auipc	ra,0x4
    3c92:	bee080e7          	jalr	-1042(ra) # 787c <close>

  fd = open("dd/dd/../ff", 0);
    3c96:	4581                	li	a1,0
    3c98:	00005517          	auipc	a0,0x5
    3c9c:	39850513          	addi	a0,a0,920 # 9030 <malloc+0x10c2>
    3ca0:	00004097          	auipc	ra,0x4
    3ca4:	bf4080e7          	jalr	-1036(ra) # 7894 <open>
    3ca8:	87aa                	mv	a5,a0
    3caa:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3cae:	fec42783          	lw	a5,-20(s0)
    3cb2:	2781                	sext.w	a5,a5
    3cb4:	0207d163          	bgez	a5,3cd6 <subdir+0x1c4>
    printf("%s: open dd/dd/../ff failed\n", s);
    3cb8:	fd843583          	ld	a1,-40(s0)
    3cbc:	00005517          	auipc	a0,0x5
    3cc0:	38450513          	addi	a0,a0,900 # 9040 <malloc+0x10d2>
    3cc4:	00004097          	auipc	ra,0x4
    3cc8:	0b8080e7          	jalr	184(ra) # 7d7c <printf>
    exit(1);
    3ccc:	4505                	li	a0,1
    3cce:	00004097          	auipc	ra,0x4
    3cd2:	b86080e7          	jalr	-1146(ra) # 7854 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    3cd6:	fec42783          	lw	a5,-20(s0)
    3cda:	660d                	lui	a2,0x3
    3cdc:	00008597          	auipc	a1,0x8
    3ce0:	60458593          	addi	a1,a1,1540 # c2e0 <buf>
    3ce4:	853e                	mv	a0,a5
    3ce6:	00004097          	auipc	ra,0x4
    3cea:	b86080e7          	jalr	-1146(ra) # 786c <read>
    3cee:	87aa                	mv	a5,a0
    3cf0:	fef42423          	sw	a5,-24(s0)
  if(cc != 2 || buf[0] != 'f'){
    3cf4:	fe842783          	lw	a5,-24(s0)
    3cf8:	0007871b          	sext.w	a4,a5
    3cfc:	4789                	li	a5,2
    3cfe:	00f71d63          	bne	a4,a5,3d18 <subdir+0x206>
    3d02:	00008797          	auipc	a5,0x8
    3d06:	5de78793          	addi	a5,a5,1502 # c2e0 <buf>
    3d0a:	0007c783          	lbu	a5,0(a5)
    3d0e:	873e                	mv	a4,a5
    3d10:	06600793          	li	a5,102
    3d14:	02f70163          	beq	a4,a5,3d36 <subdir+0x224>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3d18:	fd843583          	ld	a1,-40(s0)
    3d1c:	00005517          	auipc	a0,0x5
    3d20:	34450513          	addi	a0,a0,836 # 9060 <malloc+0x10f2>
    3d24:	00004097          	auipc	ra,0x4
    3d28:	058080e7          	jalr	88(ra) # 7d7c <printf>
    exit(1);
    3d2c:	4505                	li	a0,1
    3d2e:	00004097          	auipc	ra,0x4
    3d32:	b26080e7          	jalr	-1242(ra) # 7854 <exit>
  }
  close(fd);
    3d36:	fec42783          	lw	a5,-20(s0)
    3d3a:	853e                	mv	a0,a5
    3d3c:	00004097          	auipc	ra,0x4
    3d40:	b40080e7          	jalr	-1216(ra) # 787c <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3d44:	00005597          	auipc	a1,0x5
    3d48:	33c58593          	addi	a1,a1,828 # 9080 <malloc+0x1112>
    3d4c:	00005517          	auipc	a0,0x5
    3d50:	2ac50513          	addi	a0,a0,684 # 8ff8 <malloc+0x108a>
    3d54:	00004097          	auipc	ra,0x4
    3d58:	b60080e7          	jalr	-1184(ra) # 78b4 <link>
    3d5c:	87aa                	mv	a5,a0
    3d5e:	c385                	beqz	a5,3d7e <subdir+0x26c>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3d60:	fd843583          	ld	a1,-40(s0)
    3d64:	00005517          	auipc	a0,0x5
    3d68:	32c50513          	addi	a0,a0,812 # 9090 <malloc+0x1122>
    3d6c:	00004097          	auipc	ra,0x4
    3d70:	010080e7          	jalr	16(ra) # 7d7c <printf>
    exit(1);
    3d74:	4505                	li	a0,1
    3d76:	00004097          	auipc	ra,0x4
    3d7a:	ade080e7          	jalr	-1314(ra) # 7854 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    3d7e:	00005517          	auipc	a0,0x5
    3d82:	27a50513          	addi	a0,a0,634 # 8ff8 <malloc+0x108a>
    3d86:	00004097          	auipc	ra,0x4
    3d8a:	b1e080e7          	jalr	-1250(ra) # 78a4 <unlink>
    3d8e:	87aa                	mv	a5,a0
    3d90:	c385                	beqz	a5,3db0 <subdir+0x29e>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3d92:	fd843583          	ld	a1,-40(s0)
    3d96:	00005517          	auipc	a0,0x5
    3d9a:	32250513          	addi	a0,a0,802 # 90b8 <malloc+0x114a>
    3d9e:	00004097          	auipc	ra,0x4
    3da2:	fde080e7          	jalr	-34(ra) # 7d7c <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00004097          	auipc	ra,0x4
    3dac:	aac080e7          	jalr	-1364(ra) # 7854 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3db0:	4581                	li	a1,0
    3db2:	00005517          	auipc	a0,0x5
    3db6:	24650513          	addi	a0,a0,582 # 8ff8 <malloc+0x108a>
    3dba:	00004097          	auipc	ra,0x4
    3dbe:	ada080e7          	jalr	-1318(ra) # 7894 <open>
    3dc2:	87aa                	mv	a5,a0
    3dc4:	0207c163          	bltz	a5,3de6 <subdir+0x2d4>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3dc8:	fd843583          	ld	a1,-40(s0)
    3dcc:	00005517          	auipc	a0,0x5
    3dd0:	30c50513          	addi	a0,a0,780 # 90d8 <malloc+0x116a>
    3dd4:	00004097          	auipc	ra,0x4
    3dd8:	fa8080e7          	jalr	-88(ra) # 7d7c <printf>
    exit(1);
    3ddc:	4505                	li	a0,1
    3dde:	00004097          	auipc	ra,0x4
    3de2:	a76080e7          	jalr	-1418(ra) # 7854 <exit>
  }

  if(chdir("dd") != 0){
    3de6:	00005517          	auipc	a0,0x5
    3dea:	17250513          	addi	a0,a0,370 # 8f58 <malloc+0xfea>
    3dee:	00004097          	auipc	ra,0x4
    3df2:	ad6080e7          	jalr	-1322(ra) # 78c4 <chdir>
    3df6:	87aa                	mv	a5,a0
    3df8:	c385                	beqz	a5,3e18 <subdir+0x306>
    printf("%s: chdir dd failed\n", s);
    3dfa:	fd843583          	ld	a1,-40(s0)
    3dfe:	00005517          	auipc	a0,0x5
    3e02:	30250513          	addi	a0,a0,770 # 9100 <malloc+0x1192>
    3e06:	00004097          	auipc	ra,0x4
    3e0a:	f76080e7          	jalr	-138(ra) # 7d7c <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	00004097          	auipc	ra,0x4
    3e14:	a44080e7          	jalr	-1468(ra) # 7854 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    3e18:	00005517          	auipc	a0,0x5
    3e1c:	30050513          	addi	a0,a0,768 # 9118 <malloc+0x11aa>
    3e20:	00004097          	auipc	ra,0x4
    3e24:	aa4080e7          	jalr	-1372(ra) # 78c4 <chdir>
    3e28:	87aa                	mv	a5,a0
    3e2a:	c385                	beqz	a5,3e4a <subdir+0x338>
    printf("%s: chdir dd/../../dd failed\n", s);
    3e2c:	fd843583          	ld	a1,-40(s0)
    3e30:	00005517          	auipc	a0,0x5
    3e34:	2f850513          	addi	a0,a0,760 # 9128 <malloc+0x11ba>
    3e38:	00004097          	auipc	ra,0x4
    3e3c:	f44080e7          	jalr	-188(ra) # 7d7c <printf>
    exit(1);
    3e40:	4505                	li	a0,1
    3e42:	00004097          	auipc	ra,0x4
    3e46:	a12080e7          	jalr	-1518(ra) # 7854 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    3e4a:	00005517          	auipc	a0,0x5
    3e4e:	2fe50513          	addi	a0,a0,766 # 9148 <malloc+0x11da>
    3e52:	00004097          	auipc	ra,0x4
    3e56:	a72080e7          	jalr	-1422(ra) # 78c4 <chdir>
    3e5a:	87aa                	mv	a5,a0
    3e5c:	c385                	beqz	a5,3e7c <subdir+0x36a>
    printf("chdir dd/../../dd failed\n", s);
    3e5e:	fd843583          	ld	a1,-40(s0)
    3e62:	00005517          	auipc	a0,0x5
    3e66:	2f650513          	addi	a0,a0,758 # 9158 <malloc+0x11ea>
    3e6a:	00004097          	auipc	ra,0x4
    3e6e:	f12080e7          	jalr	-238(ra) # 7d7c <printf>
    exit(1);
    3e72:	4505                	li	a0,1
    3e74:	00004097          	auipc	ra,0x4
    3e78:	9e0080e7          	jalr	-1568(ra) # 7854 <exit>
  }
  if(chdir("./..") != 0){
    3e7c:	00005517          	auipc	a0,0x5
    3e80:	2fc50513          	addi	a0,a0,764 # 9178 <malloc+0x120a>
    3e84:	00004097          	auipc	ra,0x4
    3e88:	a40080e7          	jalr	-1472(ra) # 78c4 <chdir>
    3e8c:	87aa                	mv	a5,a0
    3e8e:	c385                	beqz	a5,3eae <subdir+0x39c>
    printf("%s: chdir ./.. failed\n", s);
    3e90:	fd843583          	ld	a1,-40(s0)
    3e94:	00005517          	auipc	a0,0x5
    3e98:	2ec50513          	addi	a0,a0,748 # 9180 <malloc+0x1212>
    3e9c:	00004097          	auipc	ra,0x4
    3ea0:	ee0080e7          	jalr	-288(ra) # 7d7c <printf>
    exit(1);
    3ea4:	4505                	li	a0,1
    3ea6:	00004097          	auipc	ra,0x4
    3eaa:	9ae080e7          	jalr	-1618(ra) # 7854 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    3eae:	4581                	li	a1,0
    3eb0:	00005517          	auipc	a0,0x5
    3eb4:	1d050513          	addi	a0,a0,464 # 9080 <malloc+0x1112>
    3eb8:	00004097          	auipc	ra,0x4
    3ebc:	9dc080e7          	jalr	-1572(ra) # 7894 <open>
    3ec0:	87aa                	mv	a5,a0
    3ec2:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    3ec6:	fec42783          	lw	a5,-20(s0)
    3eca:	2781                	sext.w	a5,a5
    3ecc:	0207d163          	bgez	a5,3eee <subdir+0x3dc>
    printf("%s: open dd/dd/ffff failed\n", s);
    3ed0:	fd843583          	ld	a1,-40(s0)
    3ed4:	00005517          	auipc	a0,0x5
    3ed8:	2c450513          	addi	a0,a0,708 # 9198 <malloc+0x122a>
    3edc:	00004097          	auipc	ra,0x4
    3ee0:	ea0080e7          	jalr	-352(ra) # 7d7c <printf>
    exit(1);
    3ee4:	4505                	li	a0,1
    3ee6:	00004097          	auipc	ra,0x4
    3eea:	96e080e7          	jalr	-1682(ra) # 7854 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    3eee:	fec42783          	lw	a5,-20(s0)
    3ef2:	660d                	lui	a2,0x3
    3ef4:	00008597          	auipc	a1,0x8
    3ef8:	3ec58593          	addi	a1,a1,1004 # c2e0 <buf>
    3efc:	853e                	mv	a0,a5
    3efe:	00004097          	auipc	ra,0x4
    3f02:	96e080e7          	jalr	-1682(ra) # 786c <read>
    3f06:	87aa                	mv	a5,a0
    3f08:	873e                	mv	a4,a5
    3f0a:	4789                	li	a5,2
    3f0c:	02f70163          	beq	a4,a5,3f2e <subdir+0x41c>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3f10:	fd843583          	ld	a1,-40(s0)
    3f14:	00005517          	auipc	a0,0x5
    3f18:	2a450513          	addi	a0,a0,676 # 91b8 <malloc+0x124a>
    3f1c:	00004097          	auipc	ra,0x4
    3f20:	e60080e7          	jalr	-416(ra) # 7d7c <printf>
    exit(1);
    3f24:	4505                	li	a0,1
    3f26:	00004097          	auipc	ra,0x4
    3f2a:	92e080e7          	jalr	-1746(ra) # 7854 <exit>
  }
  close(fd);
    3f2e:	fec42783          	lw	a5,-20(s0)
    3f32:	853e                	mv	a0,a5
    3f34:	00004097          	auipc	ra,0x4
    3f38:	948080e7          	jalr	-1720(ra) # 787c <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3f3c:	4581                	li	a1,0
    3f3e:	00005517          	auipc	a0,0x5
    3f42:	0ba50513          	addi	a0,a0,186 # 8ff8 <malloc+0x108a>
    3f46:	00004097          	auipc	ra,0x4
    3f4a:	94e080e7          	jalr	-1714(ra) # 7894 <open>
    3f4e:	87aa                	mv	a5,a0
    3f50:	0207c163          	bltz	a5,3f72 <subdir+0x460>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3f54:	fd843583          	ld	a1,-40(s0)
    3f58:	00005517          	auipc	a0,0x5
    3f5c:	28050513          	addi	a0,a0,640 # 91d8 <malloc+0x126a>
    3f60:	00004097          	auipc	ra,0x4
    3f64:	e1c080e7          	jalr	-484(ra) # 7d7c <printf>
    exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	00004097          	auipc	ra,0x4
    3f6e:	8ea080e7          	jalr	-1814(ra) # 7854 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3f72:	20200593          	li	a1,514
    3f76:	00005517          	auipc	a0,0x5
    3f7a:	29250513          	addi	a0,a0,658 # 9208 <malloc+0x129a>
    3f7e:	00004097          	auipc	ra,0x4
    3f82:	916080e7          	jalr	-1770(ra) # 7894 <open>
    3f86:	87aa                	mv	a5,a0
    3f88:	0207c163          	bltz	a5,3faa <subdir+0x498>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3f8c:	fd843583          	ld	a1,-40(s0)
    3f90:	00005517          	auipc	a0,0x5
    3f94:	28850513          	addi	a0,a0,648 # 9218 <malloc+0x12aa>
    3f98:	00004097          	auipc	ra,0x4
    3f9c:	de4080e7          	jalr	-540(ra) # 7d7c <printf>
    exit(1);
    3fa0:	4505                	li	a0,1
    3fa2:	00004097          	auipc	ra,0x4
    3fa6:	8b2080e7          	jalr	-1870(ra) # 7854 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3faa:	20200593          	li	a1,514
    3fae:	00005517          	auipc	a0,0x5
    3fb2:	28a50513          	addi	a0,a0,650 # 9238 <malloc+0x12ca>
    3fb6:	00004097          	auipc	ra,0x4
    3fba:	8de080e7          	jalr	-1826(ra) # 7894 <open>
    3fbe:	87aa                	mv	a5,a0
    3fc0:	0207c163          	bltz	a5,3fe2 <subdir+0x4d0>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3fc4:	fd843583          	ld	a1,-40(s0)
    3fc8:	00005517          	auipc	a0,0x5
    3fcc:	28050513          	addi	a0,a0,640 # 9248 <malloc+0x12da>
    3fd0:	00004097          	auipc	ra,0x4
    3fd4:	dac080e7          	jalr	-596(ra) # 7d7c <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00004097          	auipc	ra,0x4
    3fde:	87a080e7          	jalr	-1926(ra) # 7854 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    3fe2:	20000593          	li	a1,512
    3fe6:	00005517          	auipc	a0,0x5
    3fea:	f7250513          	addi	a0,a0,-142 # 8f58 <malloc+0xfea>
    3fee:	00004097          	auipc	ra,0x4
    3ff2:	8a6080e7          	jalr	-1882(ra) # 7894 <open>
    3ff6:	87aa                	mv	a5,a0
    3ff8:	0207c163          	bltz	a5,401a <subdir+0x508>
    printf("%s: create dd succeeded!\n", s);
    3ffc:	fd843583          	ld	a1,-40(s0)
    4000:	00005517          	auipc	a0,0x5
    4004:	26850513          	addi	a0,a0,616 # 9268 <malloc+0x12fa>
    4008:	00004097          	auipc	ra,0x4
    400c:	d74080e7          	jalr	-652(ra) # 7d7c <printf>
    exit(1);
    4010:	4505                	li	a0,1
    4012:	00004097          	auipc	ra,0x4
    4016:	842080e7          	jalr	-1982(ra) # 7854 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    401a:	4589                	li	a1,2
    401c:	00005517          	auipc	a0,0x5
    4020:	f3c50513          	addi	a0,a0,-196 # 8f58 <malloc+0xfea>
    4024:	00004097          	auipc	ra,0x4
    4028:	870080e7          	jalr	-1936(ra) # 7894 <open>
    402c:	87aa                	mv	a5,a0
    402e:	0207c163          	bltz	a5,4050 <subdir+0x53e>
    printf("%s: open dd rdwr succeeded!\n", s);
    4032:	fd843583          	ld	a1,-40(s0)
    4036:	00005517          	auipc	a0,0x5
    403a:	25250513          	addi	a0,a0,594 # 9288 <malloc+0x131a>
    403e:	00004097          	auipc	ra,0x4
    4042:	d3e080e7          	jalr	-706(ra) # 7d7c <printf>
    exit(1);
    4046:	4505                	li	a0,1
    4048:	00004097          	auipc	ra,0x4
    404c:	80c080e7          	jalr	-2036(ra) # 7854 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    4050:	4585                	li	a1,1
    4052:	00005517          	auipc	a0,0x5
    4056:	f0650513          	addi	a0,a0,-250 # 8f58 <malloc+0xfea>
    405a:	00004097          	auipc	ra,0x4
    405e:	83a080e7          	jalr	-1990(ra) # 7894 <open>
    4062:	87aa                	mv	a5,a0
    4064:	0207c163          	bltz	a5,4086 <subdir+0x574>
    printf("%s: open dd wronly succeeded!\n", s);
    4068:	fd843583          	ld	a1,-40(s0)
    406c:	00005517          	auipc	a0,0x5
    4070:	23c50513          	addi	a0,a0,572 # 92a8 <malloc+0x133a>
    4074:	00004097          	auipc	ra,0x4
    4078:	d08080e7          	jalr	-760(ra) # 7d7c <printf>
    exit(1);
    407c:	4505                	li	a0,1
    407e:	00003097          	auipc	ra,0x3
    4082:	7d6080e7          	jalr	2006(ra) # 7854 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    4086:	00005597          	auipc	a1,0x5
    408a:	24258593          	addi	a1,a1,578 # 92c8 <malloc+0x135a>
    408e:	00005517          	auipc	a0,0x5
    4092:	17a50513          	addi	a0,a0,378 # 9208 <malloc+0x129a>
    4096:	00004097          	auipc	ra,0x4
    409a:	81e080e7          	jalr	-2018(ra) # 78b4 <link>
    409e:	87aa                	mv	a5,a0
    40a0:	e385                	bnez	a5,40c0 <subdir+0x5ae>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    40a2:	fd843583          	ld	a1,-40(s0)
    40a6:	00005517          	auipc	a0,0x5
    40aa:	23250513          	addi	a0,a0,562 # 92d8 <malloc+0x136a>
    40ae:	00004097          	auipc	ra,0x4
    40b2:	cce080e7          	jalr	-818(ra) # 7d7c <printf>
    exit(1);
    40b6:	4505                	li	a0,1
    40b8:	00003097          	auipc	ra,0x3
    40bc:	79c080e7          	jalr	1948(ra) # 7854 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    40c0:	00005597          	auipc	a1,0x5
    40c4:	20858593          	addi	a1,a1,520 # 92c8 <malloc+0x135a>
    40c8:	00005517          	auipc	a0,0x5
    40cc:	17050513          	addi	a0,a0,368 # 9238 <malloc+0x12ca>
    40d0:	00003097          	auipc	ra,0x3
    40d4:	7e4080e7          	jalr	2020(ra) # 78b4 <link>
    40d8:	87aa                	mv	a5,a0
    40da:	e385                	bnez	a5,40fa <subdir+0x5e8>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    40dc:	fd843583          	ld	a1,-40(s0)
    40e0:	00005517          	auipc	a0,0x5
    40e4:	22050513          	addi	a0,a0,544 # 9300 <malloc+0x1392>
    40e8:	00004097          	auipc	ra,0x4
    40ec:	c94080e7          	jalr	-876(ra) # 7d7c <printf>
    exit(1);
    40f0:	4505                	li	a0,1
    40f2:	00003097          	auipc	ra,0x3
    40f6:	762080e7          	jalr	1890(ra) # 7854 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    40fa:	00005597          	auipc	a1,0x5
    40fe:	f8658593          	addi	a1,a1,-122 # 9080 <malloc+0x1112>
    4102:	00005517          	auipc	a0,0x5
    4106:	e7650513          	addi	a0,a0,-394 # 8f78 <malloc+0x100a>
    410a:	00003097          	auipc	ra,0x3
    410e:	7aa080e7          	jalr	1962(ra) # 78b4 <link>
    4112:	87aa                	mv	a5,a0
    4114:	e385                	bnez	a5,4134 <subdir+0x622>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    4116:	fd843583          	ld	a1,-40(s0)
    411a:	00005517          	auipc	a0,0x5
    411e:	20e50513          	addi	a0,a0,526 # 9328 <malloc+0x13ba>
    4122:	00004097          	auipc	ra,0x4
    4126:	c5a080e7          	jalr	-934(ra) # 7d7c <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00003097          	auipc	ra,0x3
    4130:	728080e7          	jalr	1832(ra) # 7854 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    4134:	00005517          	auipc	a0,0x5
    4138:	0d450513          	addi	a0,a0,212 # 9208 <malloc+0x129a>
    413c:	00003097          	auipc	ra,0x3
    4140:	780080e7          	jalr	1920(ra) # 78bc <mkdir>
    4144:	87aa                	mv	a5,a0
    4146:	e385                	bnez	a5,4166 <subdir+0x654>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    4148:	fd843583          	ld	a1,-40(s0)
    414c:	00005517          	auipc	a0,0x5
    4150:	20450513          	addi	a0,a0,516 # 9350 <malloc+0x13e2>
    4154:	00004097          	auipc	ra,0x4
    4158:	c28080e7          	jalr	-984(ra) # 7d7c <printf>
    exit(1);
    415c:	4505                	li	a0,1
    415e:	00003097          	auipc	ra,0x3
    4162:	6f6080e7          	jalr	1782(ra) # 7854 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    4166:	00005517          	auipc	a0,0x5
    416a:	0d250513          	addi	a0,a0,210 # 9238 <malloc+0x12ca>
    416e:	00003097          	auipc	ra,0x3
    4172:	74e080e7          	jalr	1870(ra) # 78bc <mkdir>
    4176:	87aa                	mv	a5,a0
    4178:	e385                	bnez	a5,4198 <subdir+0x686>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    417a:	fd843583          	ld	a1,-40(s0)
    417e:	00005517          	auipc	a0,0x5
    4182:	1f250513          	addi	a0,a0,498 # 9370 <malloc+0x1402>
    4186:	00004097          	auipc	ra,0x4
    418a:	bf6080e7          	jalr	-1034(ra) # 7d7c <printf>
    exit(1);
    418e:	4505                	li	a0,1
    4190:	00003097          	auipc	ra,0x3
    4194:	6c4080e7          	jalr	1732(ra) # 7854 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    4198:	00005517          	auipc	a0,0x5
    419c:	ee850513          	addi	a0,a0,-280 # 9080 <malloc+0x1112>
    41a0:	00003097          	auipc	ra,0x3
    41a4:	71c080e7          	jalr	1820(ra) # 78bc <mkdir>
    41a8:	87aa                	mv	a5,a0
    41aa:	e385                	bnez	a5,41ca <subdir+0x6b8>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    41ac:	fd843583          	ld	a1,-40(s0)
    41b0:	00005517          	auipc	a0,0x5
    41b4:	1e050513          	addi	a0,a0,480 # 9390 <malloc+0x1422>
    41b8:	00004097          	auipc	ra,0x4
    41bc:	bc4080e7          	jalr	-1084(ra) # 7d7c <printf>
    exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00003097          	auipc	ra,0x3
    41c6:	692080e7          	jalr	1682(ra) # 7854 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    41ca:	00005517          	auipc	a0,0x5
    41ce:	06e50513          	addi	a0,a0,110 # 9238 <malloc+0x12ca>
    41d2:	00003097          	auipc	ra,0x3
    41d6:	6d2080e7          	jalr	1746(ra) # 78a4 <unlink>
    41da:	87aa                	mv	a5,a0
    41dc:	e385                	bnez	a5,41fc <subdir+0x6ea>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    41de:	fd843583          	ld	a1,-40(s0)
    41e2:	00005517          	auipc	a0,0x5
    41e6:	1d650513          	addi	a0,a0,470 # 93b8 <malloc+0x144a>
    41ea:	00004097          	auipc	ra,0x4
    41ee:	b92080e7          	jalr	-1134(ra) # 7d7c <printf>
    exit(1);
    41f2:	4505                	li	a0,1
    41f4:	00003097          	auipc	ra,0x3
    41f8:	660080e7          	jalr	1632(ra) # 7854 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    41fc:	00005517          	auipc	a0,0x5
    4200:	00c50513          	addi	a0,a0,12 # 9208 <malloc+0x129a>
    4204:	00003097          	auipc	ra,0x3
    4208:	6a0080e7          	jalr	1696(ra) # 78a4 <unlink>
    420c:	87aa                	mv	a5,a0
    420e:	e385                	bnez	a5,422e <subdir+0x71c>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    4210:	fd843583          	ld	a1,-40(s0)
    4214:	00005517          	auipc	a0,0x5
    4218:	1c450513          	addi	a0,a0,452 # 93d8 <malloc+0x146a>
    421c:	00004097          	auipc	ra,0x4
    4220:	b60080e7          	jalr	-1184(ra) # 7d7c <printf>
    exit(1);
    4224:	4505                	li	a0,1
    4226:	00003097          	auipc	ra,0x3
    422a:	62e080e7          	jalr	1582(ra) # 7854 <exit>
  }
  if(chdir("dd/ff") == 0){
    422e:	00005517          	auipc	a0,0x5
    4232:	d4a50513          	addi	a0,a0,-694 # 8f78 <malloc+0x100a>
    4236:	00003097          	auipc	ra,0x3
    423a:	68e080e7          	jalr	1678(ra) # 78c4 <chdir>
    423e:	87aa                	mv	a5,a0
    4240:	e385                	bnez	a5,4260 <subdir+0x74e>
    printf("%s: chdir dd/ff succeeded!\n", s);
    4242:	fd843583          	ld	a1,-40(s0)
    4246:	00005517          	auipc	a0,0x5
    424a:	1b250513          	addi	a0,a0,434 # 93f8 <malloc+0x148a>
    424e:	00004097          	auipc	ra,0x4
    4252:	b2e080e7          	jalr	-1234(ra) # 7d7c <printf>
    exit(1);
    4256:	4505                	li	a0,1
    4258:	00003097          	auipc	ra,0x3
    425c:	5fc080e7          	jalr	1532(ra) # 7854 <exit>
  }
  if(chdir("dd/xx") == 0){
    4260:	00005517          	auipc	a0,0x5
    4264:	1b850513          	addi	a0,a0,440 # 9418 <malloc+0x14aa>
    4268:	00003097          	auipc	ra,0x3
    426c:	65c080e7          	jalr	1628(ra) # 78c4 <chdir>
    4270:	87aa                	mv	a5,a0
    4272:	e385                	bnez	a5,4292 <subdir+0x780>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4274:	fd843583          	ld	a1,-40(s0)
    4278:	00005517          	auipc	a0,0x5
    427c:	1a850513          	addi	a0,a0,424 # 9420 <malloc+0x14b2>
    4280:	00004097          	auipc	ra,0x4
    4284:	afc080e7          	jalr	-1284(ra) # 7d7c <printf>
    exit(1);
    4288:	4505                	li	a0,1
    428a:	00003097          	auipc	ra,0x3
    428e:	5ca080e7          	jalr	1482(ra) # 7854 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    4292:	00005517          	auipc	a0,0x5
    4296:	dee50513          	addi	a0,a0,-530 # 9080 <malloc+0x1112>
    429a:	00003097          	auipc	ra,0x3
    429e:	60a080e7          	jalr	1546(ra) # 78a4 <unlink>
    42a2:	87aa                	mv	a5,a0
    42a4:	c385                	beqz	a5,42c4 <subdir+0x7b2>
    printf("%s: unlink dd/dd/ff failed\n", s);
    42a6:	fd843583          	ld	a1,-40(s0)
    42aa:	00005517          	auipc	a0,0x5
    42ae:	e0e50513          	addi	a0,a0,-498 # 90b8 <malloc+0x114a>
    42b2:	00004097          	auipc	ra,0x4
    42b6:	aca080e7          	jalr	-1334(ra) # 7d7c <printf>
    exit(1);
    42ba:	4505                	li	a0,1
    42bc:	00003097          	auipc	ra,0x3
    42c0:	598080e7          	jalr	1432(ra) # 7854 <exit>
  }
  if(unlink("dd/ff") != 0){
    42c4:	00005517          	auipc	a0,0x5
    42c8:	cb450513          	addi	a0,a0,-844 # 8f78 <malloc+0x100a>
    42cc:	00003097          	auipc	ra,0x3
    42d0:	5d8080e7          	jalr	1496(ra) # 78a4 <unlink>
    42d4:	87aa                	mv	a5,a0
    42d6:	c385                	beqz	a5,42f6 <subdir+0x7e4>
    printf("%s: unlink dd/ff failed\n", s);
    42d8:	fd843583          	ld	a1,-40(s0)
    42dc:	00005517          	auipc	a0,0x5
    42e0:	16450513          	addi	a0,a0,356 # 9440 <malloc+0x14d2>
    42e4:	00004097          	auipc	ra,0x4
    42e8:	a98080e7          	jalr	-1384(ra) # 7d7c <printf>
    exit(1);
    42ec:	4505                	li	a0,1
    42ee:	00003097          	auipc	ra,0x3
    42f2:	566080e7          	jalr	1382(ra) # 7854 <exit>
  }
  if(unlink("dd") == 0){
    42f6:	00005517          	auipc	a0,0x5
    42fa:	c6250513          	addi	a0,a0,-926 # 8f58 <malloc+0xfea>
    42fe:	00003097          	auipc	ra,0x3
    4302:	5a6080e7          	jalr	1446(ra) # 78a4 <unlink>
    4306:	87aa                	mv	a5,a0
    4308:	e385                	bnez	a5,4328 <subdir+0x816>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    430a:	fd843583          	ld	a1,-40(s0)
    430e:	00005517          	auipc	a0,0x5
    4312:	15250513          	addi	a0,a0,338 # 9460 <malloc+0x14f2>
    4316:	00004097          	auipc	ra,0x4
    431a:	a66080e7          	jalr	-1434(ra) # 7d7c <printf>
    exit(1);
    431e:	4505                	li	a0,1
    4320:	00003097          	auipc	ra,0x3
    4324:	534080e7          	jalr	1332(ra) # 7854 <exit>
  }
  if(unlink("dd/dd") < 0){
    4328:	00005517          	auipc	a0,0x5
    432c:	16050513          	addi	a0,a0,352 # 9488 <malloc+0x151a>
    4330:	00003097          	auipc	ra,0x3
    4334:	574080e7          	jalr	1396(ra) # 78a4 <unlink>
    4338:	87aa                	mv	a5,a0
    433a:	0207d163          	bgez	a5,435c <subdir+0x84a>
    printf("%s: unlink dd/dd failed\n", s);
    433e:	fd843583          	ld	a1,-40(s0)
    4342:	00005517          	auipc	a0,0x5
    4346:	14e50513          	addi	a0,a0,334 # 9490 <malloc+0x1522>
    434a:	00004097          	auipc	ra,0x4
    434e:	a32080e7          	jalr	-1486(ra) # 7d7c <printf>
    exit(1);
    4352:	4505                	li	a0,1
    4354:	00003097          	auipc	ra,0x3
    4358:	500080e7          	jalr	1280(ra) # 7854 <exit>
  }
  if(unlink("dd") < 0){
    435c:	00005517          	auipc	a0,0x5
    4360:	bfc50513          	addi	a0,a0,-1028 # 8f58 <malloc+0xfea>
    4364:	00003097          	auipc	ra,0x3
    4368:	540080e7          	jalr	1344(ra) # 78a4 <unlink>
    436c:	87aa                	mv	a5,a0
    436e:	0207d163          	bgez	a5,4390 <subdir+0x87e>
    printf("%s: unlink dd failed\n", s);
    4372:	fd843583          	ld	a1,-40(s0)
    4376:	00005517          	auipc	a0,0x5
    437a:	13a50513          	addi	a0,a0,314 # 94b0 <malloc+0x1542>
    437e:	00004097          	auipc	ra,0x4
    4382:	9fe080e7          	jalr	-1538(ra) # 7d7c <printf>
    exit(1);
    4386:	4505                	li	a0,1
    4388:	00003097          	auipc	ra,0x3
    438c:	4cc080e7          	jalr	1228(ra) # 7854 <exit>
  }
}
    4390:	0001                	nop
    4392:	70a2                	ld	ra,40(sp)
    4394:	7402                	ld	s0,32(sp)
    4396:	6145                	addi	sp,sp,48
    4398:	8082                	ret

000000000000439a <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(char *s)
{
    439a:	7179                	addi	sp,sp,-48
    439c:	f406                	sd	ra,40(sp)
    439e:	f022                	sd	s0,32(sp)
    43a0:	1800                	addi	s0,sp,48
    43a2:	fca43c23          	sd	a0,-40(s0)
  int fd, sz;

  unlink("bigwrite");
    43a6:	00005517          	auipc	a0,0x5
    43aa:	12250513          	addi	a0,a0,290 # 94c8 <malloc+0x155a>
    43ae:	00003097          	auipc	ra,0x3
    43b2:	4f6080e7          	jalr	1270(ra) # 78a4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    43b6:	1f300793          	li	a5,499
    43ba:	fef42623          	sw	a5,-20(s0)
    43be:	a0ed                	j	44a8 <bigwrite+0x10e>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    43c0:	20200593          	li	a1,514
    43c4:	00005517          	auipc	a0,0x5
    43c8:	10450513          	addi	a0,a0,260 # 94c8 <malloc+0x155a>
    43cc:	00003097          	auipc	ra,0x3
    43d0:	4c8080e7          	jalr	1224(ra) # 7894 <open>
    43d4:	87aa                	mv	a5,a0
    43d6:	fef42223          	sw	a5,-28(s0)
    if(fd < 0){
    43da:	fe442783          	lw	a5,-28(s0)
    43de:	2781                	sext.w	a5,a5
    43e0:	0207d163          	bgez	a5,4402 <bigwrite+0x68>
      printf("%s: cannot create bigwrite\n", s);
    43e4:	fd843583          	ld	a1,-40(s0)
    43e8:	00005517          	auipc	a0,0x5
    43ec:	0f050513          	addi	a0,a0,240 # 94d8 <malloc+0x156a>
    43f0:	00004097          	auipc	ra,0x4
    43f4:	98c080e7          	jalr	-1652(ra) # 7d7c <printf>
      exit(1);
    43f8:	4505                	li	a0,1
    43fa:	00003097          	auipc	ra,0x3
    43fe:	45a080e7          	jalr	1114(ra) # 7854 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    4402:	fe042423          	sw	zero,-24(s0)
    4406:	a0ad                	j	4470 <bigwrite+0xd6>
      int cc = write(fd, buf, sz);
    4408:	fec42703          	lw	a4,-20(s0)
    440c:	fe442783          	lw	a5,-28(s0)
    4410:	863a                	mv	a2,a4
    4412:	00008597          	auipc	a1,0x8
    4416:	ece58593          	addi	a1,a1,-306 # c2e0 <buf>
    441a:	853e                	mv	a0,a5
    441c:	00003097          	auipc	ra,0x3
    4420:	458080e7          	jalr	1112(ra) # 7874 <write>
    4424:	87aa                	mv	a5,a0
    4426:	fef42023          	sw	a5,-32(s0)
      if(cc != sz){
    442a:	fe042783          	lw	a5,-32(s0)
    442e:	873e                	mv	a4,a5
    4430:	fec42783          	lw	a5,-20(s0)
    4434:	2701                	sext.w	a4,a4
    4436:	2781                	sext.w	a5,a5
    4438:	02f70763          	beq	a4,a5,4466 <bigwrite+0xcc>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
    443c:	fe042703          	lw	a4,-32(s0)
    4440:	fec42783          	lw	a5,-20(s0)
    4444:	86ba                	mv	a3,a4
    4446:	863e                	mv	a2,a5
    4448:	fd843583          	ld	a1,-40(s0)
    444c:	00005517          	auipc	a0,0x5
    4450:	0ac50513          	addi	a0,a0,172 # 94f8 <malloc+0x158a>
    4454:	00004097          	auipc	ra,0x4
    4458:	928080e7          	jalr	-1752(ra) # 7d7c <printf>
        exit(1);
    445c:	4505                	li	a0,1
    445e:	00003097          	auipc	ra,0x3
    4462:	3f6080e7          	jalr	1014(ra) # 7854 <exit>
    for(i = 0; i < 2; i++){
    4466:	fe842783          	lw	a5,-24(s0)
    446a:	2785                	addiw	a5,a5,1
    446c:	fef42423          	sw	a5,-24(s0)
    4470:	fe842783          	lw	a5,-24(s0)
    4474:	0007871b          	sext.w	a4,a5
    4478:	4785                	li	a5,1
    447a:	f8e7d7e3          	bge	a5,a4,4408 <bigwrite+0x6e>
      }
    }
    close(fd);
    447e:	fe442783          	lw	a5,-28(s0)
    4482:	853e                	mv	a0,a5
    4484:	00003097          	auipc	ra,0x3
    4488:	3f8080e7          	jalr	1016(ra) # 787c <close>
    unlink("bigwrite");
    448c:	00005517          	auipc	a0,0x5
    4490:	03c50513          	addi	a0,a0,60 # 94c8 <malloc+0x155a>
    4494:	00003097          	auipc	ra,0x3
    4498:	410080e7          	jalr	1040(ra) # 78a4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    449c:	fec42783          	lw	a5,-20(s0)
    44a0:	1d77879b          	addiw	a5,a5,471
    44a4:	fef42623          	sw	a5,-20(s0)
    44a8:	fec42783          	lw	a5,-20(s0)
    44ac:	0007871b          	sext.w	a4,a5
    44b0:	678d                	lui	a5,0x3
    44b2:	f0f747e3          	blt	a4,a5,43c0 <bigwrite+0x26>
  }
}
    44b6:	0001                	nop
    44b8:	0001                	nop
    44ba:	70a2                	ld	ra,40(sp)
    44bc:	7402                	ld	s0,32(sp)
    44be:	6145                	addi	sp,sp,48
    44c0:	8082                	ret

00000000000044c2 <bigfile>:


void
bigfile(char *s)
{
    44c2:	7179                	addi	sp,sp,-48
    44c4:	f406                	sd	ra,40(sp)
    44c6:	f022                	sd	s0,32(sp)
    44c8:	1800                	addi	s0,sp,48
    44ca:	fca43c23          	sd	a0,-40(s0)
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  unlink("bigfile.dat");
    44ce:	00005517          	auipc	a0,0x5
    44d2:	04250513          	addi	a0,a0,66 # 9510 <malloc+0x15a2>
    44d6:	00003097          	auipc	ra,0x3
    44da:	3ce080e7          	jalr	974(ra) # 78a4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    44de:	20200593          	li	a1,514
    44e2:	00005517          	auipc	a0,0x5
    44e6:	02e50513          	addi	a0,a0,46 # 9510 <malloc+0x15a2>
    44ea:	00003097          	auipc	ra,0x3
    44ee:	3aa080e7          	jalr	938(ra) # 7894 <open>
    44f2:	87aa                	mv	a5,a0
    44f4:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    44f8:	fe442783          	lw	a5,-28(s0)
    44fc:	2781                	sext.w	a5,a5
    44fe:	0207d163          	bgez	a5,4520 <bigfile+0x5e>
    printf("%s: cannot create bigfile", s);
    4502:	fd843583          	ld	a1,-40(s0)
    4506:	00005517          	auipc	a0,0x5
    450a:	01a50513          	addi	a0,a0,26 # 9520 <malloc+0x15b2>
    450e:	00004097          	auipc	ra,0x4
    4512:	86e080e7          	jalr	-1938(ra) # 7d7c <printf>
    exit(1);
    4516:	4505                	li	a0,1
    4518:	00003097          	auipc	ra,0x3
    451c:	33c080e7          	jalr	828(ra) # 7854 <exit>
  }
  for(i = 0; i < N; i++){
    4520:	fe042623          	sw	zero,-20(s0)
    4524:	a0ad                	j	458e <bigfile+0xcc>
    memset(buf, i, SZ);
    4526:	fec42783          	lw	a5,-20(s0)
    452a:	25800613          	li	a2,600
    452e:	85be                	mv	a1,a5
    4530:	00008517          	auipc	a0,0x8
    4534:	db050513          	addi	a0,a0,-592 # c2e0 <buf>
    4538:	00003097          	auipc	ra,0x3
    453c:	f70080e7          	jalr	-144(ra) # 74a8 <memset>
    if(write(fd, buf, SZ) != SZ){
    4540:	fe442783          	lw	a5,-28(s0)
    4544:	25800613          	li	a2,600
    4548:	00008597          	auipc	a1,0x8
    454c:	d9858593          	addi	a1,a1,-616 # c2e0 <buf>
    4550:	853e                	mv	a0,a5
    4552:	00003097          	auipc	ra,0x3
    4556:	322080e7          	jalr	802(ra) # 7874 <write>
    455a:	87aa                	mv	a5,a0
    455c:	873e                	mv	a4,a5
    455e:	25800793          	li	a5,600
    4562:	02f70163          	beq	a4,a5,4584 <bigfile+0xc2>
      printf("%s: write bigfile failed\n", s);
    4566:	fd843583          	ld	a1,-40(s0)
    456a:	00005517          	auipc	a0,0x5
    456e:	fd650513          	addi	a0,a0,-42 # 9540 <malloc+0x15d2>
    4572:	00004097          	auipc	ra,0x4
    4576:	80a080e7          	jalr	-2038(ra) # 7d7c <printf>
      exit(1);
    457a:	4505                	li	a0,1
    457c:	00003097          	auipc	ra,0x3
    4580:	2d8080e7          	jalr	728(ra) # 7854 <exit>
  for(i = 0; i < N; i++){
    4584:	fec42783          	lw	a5,-20(s0)
    4588:	2785                	addiw	a5,a5,1 # 3001 <createdelete+0x281>
    458a:	fef42623          	sw	a5,-20(s0)
    458e:	fec42783          	lw	a5,-20(s0)
    4592:	0007871b          	sext.w	a4,a5
    4596:	47cd                	li	a5,19
    4598:	f8e7d7e3          	bge	a5,a4,4526 <bigfile+0x64>
    }
  }
  close(fd);
    459c:	fe442783          	lw	a5,-28(s0)
    45a0:	853e                	mv	a0,a5
    45a2:	00003097          	auipc	ra,0x3
    45a6:	2da080e7          	jalr	730(ra) # 787c <close>

  fd = open("bigfile.dat", 0);
    45aa:	4581                	li	a1,0
    45ac:	00005517          	auipc	a0,0x5
    45b0:	f6450513          	addi	a0,a0,-156 # 9510 <malloc+0x15a2>
    45b4:	00003097          	auipc	ra,0x3
    45b8:	2e0080e7          	jalr	736(ra) # 7894 <open>
    45bc:	87aa                	mv	a5,a0
    45be:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    45c2:	fe442783          	lw	a5,-28(s0)
    45c6:	2781                	sext.w	a5,a5
    45c8:	0207d163          	bgez	a5,45ea <bigfile+0x128>
    printf("%s: cannot open bigfile\n", s);
    45cc:	fd843583          	ld	a1,-40(s0)
    45d0:	00005517          	auipc	a0,0x5
    45d4:	f9050513          	addi	a0,a0,-112 # 9560 <malloc+0x15f2>
    45d8:	00003097          	auipc	ra,0x3
    45dc:	7a4080e7          	jalr	1956(ra) # 7d7c <printf>
    exit(1);
    45e0:	4505                	li	a0,1
    45e2:	00003097          	auipc	ra,0x3
    45e6:	272080e7          	jalr	626(ra) # 7854 <exit>
  }
  total = 0;
    45ea:	fe042423          	sw	zero,-24(s0)
  for(i = 0; ; i++){
    45ee:	fe042623          	sw	zero,-20(s0)
    cc = read(fd, buf, SZ/2);
    45f2:	fe442783          	lw	a5,-28(s0)
    45f6:	12c00613          	li	a2,300
    45fa:	00008597          	auipc	a1,0x8
    45fe:	ce658593          	addi	a1,a1,-794 # c2e0 <buf>
    4602:	853e                	mv	a0,a5
    4604:	00003097          	auipc	ra,0x3
    4608:	268080e7          	jalr	616(ra) # 786c <read>
    460c:	87aa                	mv	a5,a0
    460e:	fef42023          	sw	a5,-32(s0)
    if(cc < 0){
    4612:	fe042783          	lw	a5,-32(s0)
    4616:	2781                	sext.w	a5,a5
    4618:	0207d163          	bgez	a5,463a <bigfile+0x178>
      printf("%s: read bigfile failed\n", s);
    461c:	fd843583          	ld	a1,-40(s0)
    4620:	00005517          	auipc	a0,0x5
    4624:	f6050513          	addi	a0,a0,-160 # 9580 <malloc+0x1612>
    4628:	00003097          	auipc	ra,0x3
    462c:	754080e7          	jalr	1876(ra) # 7d7c <printf>
      exit(1);
    4630:	4505                	li	a0,1
    4632:	00003097          	auipc	ra,0x3
    4636:	222080e7          	jalr	546(ra) # 7854 <exit>
    }
    if(cc == 0)
    463a:	fe042783          	lw	a5,-32(s0)
    463e:	2781                	sext.w	a5,a5
    4640:	cbdd                	beqz	a5,46f6 <bigfile+0x234>
      break;
    if(cc != SZ/2){
    4642:	fe042783          	lw	a5,-32(s0)
    4646:	0007871b          	sext.w	a4,a5
    464a:	12c00793          	li	a5,300
    464e:	02f70163          	beq	a4,a5,4670 <bigfile+0x1ae>
      printf("%s: short read bigfile\n", s);
    4652:	fd843583          	ld	a1,-40(s0)
    4656:	00005517          	auipc	a0,0x5
    465a:	f4a50513          	addi	a0,a0,-182 # 95a0 <malloc+0x1632>
    465e:	00003097          	auipc	ra,0x3
    4662:	71e080e7          	jalr	1822(ra) # 7d7c <printf>
      exit(1);
    4666:	4505                	li	a0,1
    4668:	00003097          	auipc	ra,0x3
    466c:	1ec080e7          	jalr	492(ra) # 7854 <exit>
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4670:	00008797          	auipc	a5,0x8
    4674:	c7078793          	addi	a5,a5,-912 # c2e0 <buf>
    4678:	0007c783          	lbu	a5,0(a5)
    467c:	0007869b          	sext.w	a3,a5
    4680:	fec42783          	lw	a5,-20(s0)
    4684:	01f7d71b          	srliw	a4,a5,0x1f
    4688:	9fb9                	addw	a5,a5,a4
    468a:	4017d79b          	sraiw	a5,a5,0x1
    468e:	2781                	sext.w	a5,a5
    4690:	8736                	mv	a4,a3
    4692:	02f71563          	bne	a4,a5,46bc <bigfile+0x1fa>
    4696:	00008797          	auipc	a5,0x8
    469a:	c4a78793          	addi	a5,a5,-950 # c2e0 <buf>
    469e:	12b7c783          	lbu	a5,299(a5)
    46a2:	0007869b          	sext.w	a3,a5
    46a6:	fec42783          	lw	a5,-20(s0)
    46aa:	01f7d71b          	srliw	a4,a5,0x1f
    46ae:	9fb9                	addw	a5,a5,a4
    46b0:	4017d79b          	sraiw	a5,a5,0x1
    46b4:	2781                	sext.w	a5,a5
    46b6:	8736                	mv	a4,a3
    46b8:	02f70163          	beq	a4,a5,46da <bigfile+0x218>
      printf("%s: read bigfile wrong data\n", s);
    46bc:	fd843583          	ld	a1,-40(s0)
    46c0:	00005517          	auipc	a0,0x5
    46c4:	ef850513          	addi	a0,a0,-264 # 95b8 <malloc+0x164a>
    46c8:	00003097          	auipc	ra,0x3
    46cc:	6b4080e7          	jalr	1716(ra) # 7d7c <printf>
      exit(1);
    46d0:	4505                	li	a0,1
    46d2:	00003097          	auipc	ra,0x3
    46d6:	182080e7          	jalr	386(ra) # 7854 <exit>
    }
    total += cc;
    46da:	fe842783          	lw	a5,-24(s0)
    46de:	873e                	mv	a4,a5
    46e0:	fe042783          	lw	a5,-32(s0)
    46e4:	9fb9                	addw	a5,a5,a4
    46e6:	fef42423          	sw	a5,-24(s0)
  for(i = 0; ; i++){
    46ea:	fec42783          	lw	a5,-20(s0)
    46ee:	2785                	addiw	a5,a5,1
    46f0:	fef42623          	sw	a5,-20(s0)
    cc = read(fd, buf, SZ/2);
    46f4:	bdfd                	j	45f2 <bigfile+0x130>
      break;
    46f6:	0001                	nop
  }
  close(fd);
    46f8:	fe442783          	lw	a5,-28(s0)
    46fc:	853e                	mv	a0,a5
    46fe:	00003097          	auipc	ra,0x3
    4702:	17e080e7          	jalr	382(ra) # 787c <close>
  if(total != N*SZ){
    4706:	fe842783          	lw	a5,-24(s0)
    470a:	0007871b          	sext.w	a4,a5
    470e:	678d                	lui	a5,0x3
    4710:	ee078793          	addi	a5,a5,-288 # 2ee0 <createdelete+0x160>
    4714:	02f70163          	beq	a4,a5,4736 <bigfile+0x274>
    printf("%s: read bigfile wrong total\n", s);
    4718:	fd843583          	ld	a1,-40(s0)
    471c:	00005517          	auipc	a0,0x5
    4720:	ebc50513          	addi	a0,a0,-324 # 95d8 <malloc+0x166a>
    4724:	00003097          	auipc	ra,0x3
    4728:	658080e7          	jalr	1624(ra) # 7d7c <printf>
    exit(1);
    472c:	4505                	li	a0,1
    472e:	00003097          	auipc	ra,0x3
    4732:	126080e7          	jalr	294(ra) # 7854 <exit>
  }
  unlink("bigfile.dat");
    4736:	00005517          	auipc	a0,0x5
    473a:	dda50513          	addi	a0,a0,-550 # 9510 <malloc+0x15a2>
    473e:	00003097          	auipc	ra,0x3
    4742:	166080e7          	jalr	358(ra) # 78a4 <unlink>
}
    4746:	0001                	nop
    4748:	70a2                	ld	ra,40(sp)
    474a:	7402                	ld	s0,32(sp)
    474c:	6145                	addi	sp,sp,48
    474e:	8082                	ret

0000000000004750 <fourteen>:

void
fourteen(char *s)
{
    4750:	7179                	addi	sp,sp,-48
    4752:	f406                	sd	ra,40(sp)
    4754:	f022                	sd	s0,32(sp)
    4756:	1800                	addi	s0,sp,48
    4758:	fca43c23          	sd	a0,-40(s0)
  int fd;

  // DIRSIZ is 14.

  if(mkdir("12345678901234") != 0){
    475c:	00005517          	auipc	a0,0x5
    4760:	e9c50513          	addi	a0,a0,-356 # 95f8 <malloc+0x168a>
    4764:	00003097          	auipc	ra,0x3
    4768:	158080e7          	jalr	344(ra) # 78bc <mkdir>
    476c:	87aa                	mv	a5,a0
    476e:	c385                	beqz	a5,478e <fourteen+0x3e>
    printf("%s: mkdir 12345678901234 failed\n", s);
    4770:	fd843583          	ld	a1,-40(s0)
    4774:	00005517          	auipc	a0,0x5
    4778:	e9450513          	addi	a0,a0,-364 # 9608 <malloc+0x169a>
    477c:	00003097          	auipc	ra,0x3
    4780:	600080e7          	jalr	1536(ra) # 7d7c <printf>
    exit(1);
    4784:	4505                	li	a0,1
    4786:	00003097          	auipc	ra,0x3
    478a:	0ce080e7          	jalr	206(ra) # 7854 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    478e:	00005517          	auipc	a0,0x5
    4792:	ea250513          	addi	a0,a0,-350 # 9630 <malloc+0x16c2>
    4796:	00003097          	auipc	ra,0x3
    479a:	126080e7          	jalr	294(ra) # 78bc <mkdir>
    479e:	87aa                	mv	a5,a0
    47a0:	c385                	beqz	a5,47c0 <fourteen+0x70>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    47a2:	fd843583          	ld	a1,-40(s0)
    47a6:	00005517          	auipc	a0,0x5
    47aa:	eaa50513          	addi	a0,a0,-342 # 9650 <malloc+0x16e2>
    47ae:	00003097          	auipc	ra,0x3
    47b2:	5ce080e7          	jalr	1486(ra) # 7d7c <printf>
    exit(1);
    47b6:	4505                	li	a0,1
    47b8:	00003097          	auipc	ra,0x3
    47bc:	09c080e7          	jalr	156(ra) # 7854 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    47c0:	20000593          	li	a1,512
    47c4:	00005517          	auipc	a0,0x5
    47c8:	ec450513          	addi	a0,a0,-316 # 9688 <malloc+0x171a>
    47cc:	00003097          	auipc	ra,0x3
    47d0:	0c8080e7          	jalr	200(ra) # 7894 <open>
    47d4:	87aa                	mv	a5,a0
    47d6:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    47da:	fec42783          	lw	a5,-20(s0)
    47de:	2781                	sext.w	a5,a5
    47e0:	0207d163          	bgez	a5,4802 <fourteen+0xb2>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    47e4:	fd843583          	ld	a1,-40(s0)
    47e8:	00005517          	auipc	a0,0x5
    47ec:	ed050513          	addi	a0,a0,-304 # 96b8 <malloc+0x174a>
    47f0:	00003097          	auipc	ra,0x3
    47f4:	58c080e7          	jalr	1420(ra) # 7d7c <printf>
    exit(1);
    47f8:	4505                	li	a0,1
    47fa:	00003097          	auipc	ra,0x3
    47fe:	05a080e7          	jalr	90(ra) # 7854 <exit>
  }
  close(fd);
    4802:	fec42783          	lw	a5,-20(s0)
    4806:	853e                	mv	a0,a5
    4808:	00003097          	auipc	ra,0x3
    480c:	074080e7          	jalr	116(ra) # 787c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    4810:	4581                	li	a1,0
    4812:	00005517          	auipc	a0,0x5
    4816:	eee50513          	addi	a0,a0,-274 # 9700 <malloc+0x1792>
    481a:	00003097          	auipc	ra,0x3
    481e:	07a080e7          	jalr	122(ra) # 7894 <open>
    4822:	87aa                	mv	a5,a0
    4824:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    4828:	fec42783          	lw	a5,-20(s0)
    482c:	2781                	sext.w	a5,a5
    482e:	0207d163          	bgez	a5,4850 <fourteen+0x100>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    4832:	fd843583          	ld	a1,-40(s0)
    4836:	00005517          	auipc	a0,0x5
    483a:	efa50513          	addi	a0,a0,-262 # 9730 <malloc+0x17c2>
    483e:	00003097          	auipc	ra,0x3
    4842:	53e080e7          	jalr	1342(ra) # 7d7c <printf>
    exit(1);
    4846:	4505                	li	a0,1
    4848:	00003097          	auipc	ra,0x3
    484c:	00c080e7          	jalr	12(ra) # 7854 <exit>
  }
  close(fd);
    4850:	fec42783          	lw	a5,-20(s0)
    4854:	853e                	mv	a0,a5
    4856:	00003097          	auipc	ra,0x3
    485a:	026080e7          	jalr	38(ra) # 787c <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    485e:	00005517          	auipc	a0,0x5
    4862:	f1250513          	addi	a0,a0,-238 # 9770 <malloc+0x1802>
    4866:	00003097          	auipc	ra,0x3
    486a:	056080e7          	jalr	86(ra) # 78bc <mkdir>
    486e:	87aa                	mv	a5,a0
    4870:	e385                	bnez	a5,4890 <fourteen+0x140>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    4872:	fd843583          	ld	a1,-40(s0)
    4876:	00005517          	auipc	a0,0x5
    487a:	f1a50513          	addi	a0,a0,-230 # 9790 <malloc+0x1822>
    487e:	00003097          	auipc	ra,0x3
    4882:	4fe080e7          	jalr	1278(ra) # 7d7c <printf>
    exit(1);
    4886:	4505                	li	a0,1
    4888:	00003097          	auipc	ra,0x3
    488c:	fcc080e7          	jalr	-52(ra) # 7854 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    4890:	00005517          	auipc	a0,0x5
    4894:	f3850513          	addi	a0,a0,-200 # 97c8 <malloc+0x185a>
    4898:	00003097          	auipc	ra,0x3
    489c:	024080e7          	jalr	36(ra) # 78bc <mkdir>
    48a0:	87aa                	mv	a5,a0
    48a2:	e385                	bnez	a5,48c2 <fourteen+0x172>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    48a4:	fd843583          	ld	a1,-40(s0)
    48a8:	00005517          	auipc	a0,0x5
    48ac:	f4050513          	addi	a0,a0,-192 # 97e8 <malloc+0x187a>
    48b0:	00003097          	auipc	ra,0x3
    48b4:	4cc080e7          	jalr	1228(ra) # 7d7c <printf>
    exit(1);
    48b8:	4505                	li	a0,1
    48ba:	00003097          	auipc	ra,0x3
    48be:	f9a080e7          	jalr	-102(ra) # 7854 <exit>
  }

  // clean up
  unlink("123456789012345/12345678901234");
    48c2:	00005517          	auipc	a0,0x5
    48c6:	f0650513          	addi	a0,a0,-250 # 97c8 <malloc+0x185a>
    48ca:	00003097          	auipc	ra,0x3
    48ce:	fda080e7          	jalr	-38(ra) # 78a4 <unlink>
  unlink("12345678901234/12345678901234");
    48d2:	00005517          	auipc	a0,0x5
    48d6:	e9e50513          	addi	a0,a0,-354 # 9770 <malloc+0x1802>
    48da:	00003097          	auipc	ra,0x3
    48de:	fca080e7          	jalr	-54(ra) # 78a4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    48e2:	00005517          	auipc	a0,0x5
    48e6:	e1e50513          	addi	a0,a0,-482 # 9700 <malloc+0x1792>
    48ea:	00003097          	auipc	ra,0x3
    48ee:	fba080e7          	jalr	-70(ra) # 78a4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    48f2:	00005517          	auipc	a0,0x5
    48f6:	d9650513          	addi	a0,a0,-618 # 9688 <malloc+0x171a>
    48fa:	00003097          	auipc	ra,0x3
    48fe:	faa080e7          	jalr	-86(ra) # 78a4 <unlink>
  unlink("12345678901234/123456789012345");
    4902:	00005517          	auipc	a0,0x5
    4906:	d2e50513          	addi	a0,a0,-722 # 9630 <malloc+0x16c2>
    490a:	00003097          	auipc	ra,0x3
    490e:	f9a080e7          	jalr	-102(ra) # 78a4 <unlink>
  unlink("12345678901234");
    4912:	00005517          	auipc	a0,0x5
    4916:	ce650513          	addi	a0,a0,-794 # 95f8 <malloc+0x168a>
    491a:	00003097          	auipc	ra,0x3
    491e:	f8a080e7          	jalr	-118(ra) # 78a4 <unlink>
}
    4922:	0001                	nop
    4924:	70a2                	ld	ra,40(sp)
    4926:	7402                	ld	s0,32(sp)
    4928:	6145                	addi	sp,sp,48
    492a:	8082                	ret

000000000000492c <rmdot>:

void
rmdot(char *s)
{
    492c:	1101                	addi	sp,sp,-32
    492e:	ec06                	sd	ra,24(sp)
    4930:	e822                	sd	s0,16(sp)
    4932:	1000                	addi	s0,sp,32
    4934:	fea43423          	sd	a0,-24(s0)
  if(mkdir("dots") != 0){
    4938:	00005517          	auipc	a0,0x5
    493c:	ee850513          	addi	a0,a0,-280 # 9820 <malloc+0x18b2>
    4940:	00003097          	auipc	ra,0x3
    4944:	f7c080e7          	jalr	-132(ra) # 78bc <mkdir>
    4948:	87aa                	mv	a5,a0
    494a:	c385                	beqz	a5,496a <rmdot+0x3e>
    printf("%s: mkdir dots failed\n", s);
    494c:	fe843583          	ld	a1,-24(s0)
    4950:	00005517          	auipc	a0,0x5
    4954:	ed850513          	addi	a0,a0,-296 # 9828 <malloc+0x18ba>
    4958:	00003097          	auipc	ra,0x3
    495c:	424080e7          	jalr	1060(ra) # 7d7c <printf>
    exit(1);
    4960:	4505                	li	a0,1
    4962:	00003097          	auipc	ra,0x3
    4966:	ef2080e7          	jalr	-270(ra) # 7854 <exit>
  }
  if(chdir("dots") != 0){
    496a:	00005517          	auipc	a0,0x5
    496e:	eb650513          	addi	a0,a0,-330 # 9820 <malloc+0x18b2>
    4972:	00003097          	auipc	ra,0x3
    4976:	f52080e7          	jalr	-174(ra) # 78c4 <chdir>
    497a:	87aa                	mv	a5,a0
    497c:	c385                	beqz	a5,499c <rmdot+0x70>
    printf("%s: chdir dots failed\n", s);
    497e:	fe843583          	ld	a1,-24(s0)
    4982:	00005517          	auipc	a0,0x5
    4986:	ebe50513          	addi	a0,a0,-322 # 9840 <malloc+0x18d2>
    498a:	00003097          	auipc	ra,0x3
    498e:	3f2080e7          	jalr	1010(ra) # 7d7c <printf>
    exit(1);
    4992:	4505                	li	a0,1
    4994:	00003097          	auipc	ra,0x3
    4998:	ec0080e7          	jalr	-320(ra) # 7854 <exit>
  }
  if(unlink(".") == 0){
    499c:	00004517          	auipc	a0,0x4
    49a0:	4dc50513          	addi	a0,a0,1244 # 8e78 <malloc+0xf0a>
    49a4:	00003097          	auipc	ra,0x3
    49a8:	f00080e7          	jalr	-256(ra) # 78a4 <unlink>
    49ac:	87aa                	mv	a5,a0
    49ae:	e385                	bnez	a5,49ce <rmdot+0xa2>
    printf("%s: rm . worked!\n", s);
    49b0:	fe843583          	ld	a1,-24(s0)
    49b4:	00005517          	auipc	a0,0x5
    49b8:	ea450513          	addi	a0,a0,-348 # 9858 <malloc+0x18ea>
    49bc:	00003097          	auipc	ra,0x3
    49c0:	3c0080e7          	jalr	960(ra) # 7d7c <printf>
    exit(1);
    49c4:	4505                	li	a0,1
    49c6:	00003097          	auipc	ra,0x3
    49ca:	e8e080e7          	jalr	-370(ra) # 7854 <exit>
  }
  if(unlink("..") == 0){
    49ce:	00004517          	auipc	a0,0x4
    49d2:	f0250513          	addi	a0,a0,-254 # 88d0 <malloc+0x962>
    49d6:	00003097          	auipc	ra,0x3
    49da:	ece080e7          	jalr	-306(ra) # 78a4 <unlink>
    49de:	87aa                	mv	a5,a0
    49e0:	e385                	bnez	a5,4a00 <rmdot+0xd4>
    printf("%s: rm .. worked!\n", s);
    49e2:	fe843583          	ld	a1,-24(s0)
    49e6:	00005517          	auipc	a0,0x5
    49ea:	e8a50513          	addi	a0,a0,-374 # 9870 <malloc+0x1902>
    49ee:	00003097          	auipc	ra,0x3
    49f2:	38e080e7          	jalr	910(ra) # 7d7c <printf>
    exit(1);
    49f6:	4505                	li	a0,1
    49f8:	00003097          	auipc	ra,0x3
    49fc:	e5c080e7          	jalr	-420(ra) # 7854 <exit>
  }
  if(chdir("/") != 0){
    4a00:	00004517          	auipc	a0,0x4
    4a04:	be850513          	addi	a0,a0,-1048 # 85e8 <malloc+0x67a>
    4a08:	00003097          	auipc	ra,0x3
    4a0c:	ebc080e7          	jalr	-324(ra) # 78c4 <chdir>
    4a10:	87aa                	mv	a5,a0
    4a12:	c385                	beqz	a5,4a32 <rmdot+0x106>
    printf("%s: chdir / failed\n", s);
    4a14:	fe843583          	ld	a1,-24(s0)
    4a18:	00004517          	auipc	a0,0x4
    4a1c:	bd850513          	addi	a0,a0,-1064 # 85f0 <malloc+0x682>
    4a20:	00003097          	auipc	ra,0x3
    4a24:	35c080e7          	jalr	860(ra) # 7d7c <printf>
    exit(1);
    4a28:	4505                	li	a0,1
    4a2a:	00003097          	auipc	ra,0x3
    4a2e:	e2a080e7          	jalr	-470(ra) # 7854 <exit>
  }
  if(unlink("dots/.") == 0){
    4a32:	00005517          	auipc	a0,0x5
    4a36:	e5650513          	addi	a0,a0,-426 # 9888 <malloc+0x191a>
    4a3a:	00003097          	auipc	ra,0x3
    4a3e:	e6a080e7          	jalr	-406(ra) # 78a4 <unlink>
    4a42:	87aa                	mv	a5,a0
    4a44:	e385                	bnez	a5,4a64 <rmdot+0x138>
    printf("%s: unlink dots/. worked!\n", s);
    4a46:	fe843583          	ld	a1,-24(s0)
    4a4a:	00005517          	auipc	a0,0x5
    4a4e:	e4650513          	addi	a0,a0,-442 # 9890 <malloc+0x1922>
    4a52:	00003097          	auipc	ra,0x3
    4a56:	32a080e7          	jalr	810(ra) # 7d7c <printf>
    exit(1);
    4a5a:	4505                	li	a0,1
    4a5c:	00003097          	auipc	ra,0x3
    4a60:	df8080e7          	jalr	-520(ra) # 7854 <exit>
  }
  if(unlink("dots/..") == 0){
    4a64:	00005517          	auipc	a0,0x5
    4a68:	e4c50513          	addi	a0,a0,-436 # 98b0 <malloc+0x1942>
    4a6c:	00003097          	auipc	ra,0x3
    4a70:	e38080e7          	jalr	-456(ra) # 78a4 <unlink>
    4a74:	87aa                	mv	a5,a0
    4a76:	e385                	bnez	a5,4a96 <rmdot+0x16a>
    printf("%s: unlink dots/.. worked!\n", s);
    4a78:	fe843583          	ld	a1,-24(s0)
    4a7c:	00005517          	auipc	a0,0x5
    4a80:	e3c50513          	addi	a0,a0,-452 # 98b8 <malloc+0x194a>
    4a84:	00003097          	auipc	ra,0x3
    4a88:	2f8080e7          	jalr	760(ra) # 7d7c <printf>
    exit(1);
    4a8c:	4505                	li	a0,1
    4a8e:	00003097          	auipc	ra,0x3
    4a92:	dc6080e7          	jalr	-570(ra) # 7854 <exit>
  }
  if(unlink("dots") != 0){
    4a96:	00005517          	auipc	a0,0x5
    4a9a:	d8a50513          	addi	a0,a0,-630 # 9820 <malloc+0x18b2>
    4a9e:	00003097          	auipc	ra,0x3
    4aa2:	e06080e7          	jalr	-506(ra) # 78a4 <unlink>
    4aa6:	87aa                	mv	a5,a0
    4aa8:	c385                	beqz	a5,4ac8 <rmdot+0x19c>
    printf("%s: unlink dots failed!\n", s);
    4aaa:	fe843583          	ld	a1,-24(s0)
    4aae:	00005517          	auipc	a0,0x5
    4ab2:	e2a50513          	addi	a0,a0,-470 # 98d8 <malloc+0x196a>
    4ab6:	00003097          	auipc	ra,0x3
    4aba:	2c6080e7          	jalr	710(ra) # 7d7c <printf>
    exit(1);
    4abe:	4505                	li	a0,1
    4ac0:	00003097          	auipc	ra,0x3
    4ac4:	d94080e7          	jalr	-620(ra) # 7854 <exit>
  }
}
    4ac8:	0001                	nop
    4aca:	60e2                	ld	ra,24(sp)
    4acc:	6442                	ld	s0,16(sp)
    4ace:	6105                	addi	sp,sp,32
    4ad0:	8082                	ret

0000000000004ad2 <dirfile>:

void
dirfile(char *s)
{
    4ad2:	7179                	addi	sp,sp,-48
    4ad4:	f406                	sd	ra,40(sp)
    4ad6:	f022                	sd	s0,32(sp)
    4ad8:	1800                	addi	s0,sp,48
    4ada:	fca43c23          	sd	a0,-40(s0)
  int fd;

  fd = open("dirfile", O_CREATE);
    4ade:	20000593          	li	a1,512
    4ae2:	00005517          	auipc	a0,0x5
    4ae6:	e1650513          	addi	a0,a0,-490 # 98f8 <malloc+0x198a>
    4aea:	00003097          	auipc	ra,0x3
    4aee:	daa080e7          	jalr	-598(ra) # 7894 <open>
    4af2:	87aa                	mv	a5,a0
    4af4:	fef42623          	sw	a5,-20(s0)
  if(fd < 0){
    4af8:	fec42783          	lw	a5,-20(s0)
    4afc:	2781                	sext.w	a5,a5
    4afe:	0207d163          	bgez	a5,4b20 <dirfile+0x4e>
    printf("%s: create dirfile failed\n", s);
    4b02:	fd843583          	ld	a1,-40(s0)
    4b06:	00005517          	auipc	a0,0x5
    4b0a:	dfa50513          	addi	a0,a0,-518 # 9900 <malloc+0x1992>
    4b0e:	00003097          	auipc	ra,0x3
    4b12:	26e080e7          	jalr	622(ra) # 7d7c <printf>
    exit(1);
    4b16:	4505                	li	a0,1
    4b18:	00003097          	auipc	ra,0x3
    4b1c:	d3c080e7          	jalr	-708(ra) # 7854 <exit>
  }
  close(fd);
    4b20:	fec42783          	lw	a5,-20(s0)
    4b24:	853e                	mv	a0,a5
    4b26:	00003097          	auipc	ra,0x3
    4b2a:	d56080e7          	jalr	-682(ra) # 787c <close>
  if(chdir("dirfile") == 0){
    4b2e:	00005517          	auipc	a0,0x5
    4b32:	dca50513          	addi	a0,a0,-566 # 98f8 <malloc+0x198a>
    4b36:	00003097          	auipc	ra,0x3
    4b3a:	d8e080e7          	jalr	-626(ra) # 78c4 <chdir>
    4b3e:	87aa                	mv	a5,a0
    4b40:	e385                	bnez	a5,4b60 <dirfile+0x8e>
    printf("%s: chdir dirfile succeeded!\n", s);
    4b42:	fd843583          	ld	a1,-40(s0)
    4b46:	00005517          	auipc	a0,0x5
    4b4a:	dda50513          	addi	a0,a0,-550 # 9920 <malloc+0x19b2>
    4b4e:	00003097          	auipc	ra,0x3
    4b52:	22e080e7          	jalr	558(ra) # 7d7c <printf>
    exit(1);
    4b56:	4505                	li	a0,1
    4b58:	00003097          	auipc	ra,0x3
    4b5c:	cfc080e7          	jalr	-772(ra) # 7854 <exit>
  }
  fd = open("dirfile/xx", 0);
    4b60:	4581                	li	a1,0
    4b62:	00005517          	auipc	a0,0x5
    4b66:	dde50513          	addi	a0,a0,-546 # 9940 <malloc+0x19d2>
    4b6a:	00003097          	auipc	ra,0x3
    4b6e:	d2a080e7          	jalr	-726(ra) # 7894 <open>
    4b72:	87aa                	mv	a5,a0
    4b74:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4b78:	fec42783          	lw	a5,-20(s0)
    4b7c:	2781                	sext.w	a5,a5
    4b7e:	0207c163          	bltz	a5,4ba0 <dirfile+0xce>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4b82:	fd843583          	ld	a1,-40(s0)
    4b86:	00005517          	auipc	a0,0x5
    4b8a:	dca50513          	addi	a0,a0,-566 # 9950 <malloc+0x19e2>
    4b8e:	00003097          	auipc	ra,0x3
    4b92:	1ee080e7          	jalr	494(ra) # 7d7c <printf>
    exit(1);
    4b96:	4505                	li	a0,1
    4b98:	00003097          	auipc	ra,0x3
    4b9c:	cbc080e7          	jalr	-836(ra) # 7854 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    4ba0:	20000593          	li	a1,512
    4ba4:	00005517          	auipc	a0,0x5
    4ba8:	d9c50513          	addi	a0,a0,-612 # 9940 <malloc+0x19d2>
    4bac:	00003097          	auipc	ra,0x3
    4bb0:	ce8080e7          	jalr	-792(ra) # 7894 <open>
    4bb4:	87aa                	mv	a5,a0
    4bb6:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4bba:	fec42783          	lw	a5,-20(s0)
    4bbe:	2781                	sext.w	a5,a5
    4bc0:	0207c163          	bltz	a5,4be2 <dirfile+0x110>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4bc4:	fd843583          	ld	a1,-40(s0)
    4bc8:	00005517          	auipc	a0,0x5
    4bcc:	d8850513          	addi	a0,a0,-632 # 9950 <malloc+0x19e2>
    4bd0:	00003097          	auipc	ra,0x3
    4bd4:	1ac080e7          	jalr	428(ra) # 7d7c <printf>
    exit(1);
    4bd8:	4505                	li	a0,1
    4bda:	00003097          	auipc	ra,0x3
    4bde:	c7a080e7          	jalr	-902(ra) # 7854 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    4be2:	00005517          	auipc	a0,0x5
    4be6:	d5e50513          	addi	a0,a0,-674 # 9940 <malloc+0x19d2>
    4bea:	00003097          	auipc	ra,0x3
    4bee:	cd2080e7          	jalr	-814(ra) # 78bc <mkdir>
    4bf2:	87aa                	mv	a5,a0
    4bf4:	e385                	bnez	a5,4c14 <dirfile+0x142>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4bf6:	fd843583          	ld	a1,-40(s0)
    4bfa:	00005517          	auipc	a0,0x5
    4bfe:	d7e50513          	addi	a0,a0,-642 # 9978 <malloc+0x1a0a>
    4c02:	00003097          	auipc	ra,0x3
    4c06:	17a080e7          	jalr	378(ra) # 7d7c <printf>
    exit(1);
    4c0a:	4505                	li	a0,1
    4c0c:	00003097          	auipc	ra,0x3
    4c10:	c48080e7          	jalr	-952(ra) # 7854 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    4c14:	00005517          	auipc	a0,0x5
    4c18:	d2c50513          	addi	a0,a0,-724 # 9940 <malloc+0x19d2>
    4c1c:	00003097          	auipc	ra,0x3
    4c20:	c88080e7          	jalr	-888(ra) # 78a4 <unlink>
    4c24:	87aa                	mv	a5,a0
    4c26:	e385                	bnez	a5,4c46 <dirfile+0x174>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4c28:	fd843583          	ld	a1,-40(s0)
    4c2c:	00005517          	auipc	a0,0x5
    4c30:	d7450513          	addi	a0,a0,-652 # 99a0 <malloc+0x1a32>
    4c34:	00003097          	auipc	ra,0x3
    4c38:	148080e7          	jalr	328(ra) # 7d7c <printf>
    exit(1);
    4c3c:	4505                	li	a0,1
    4c3e:	00003097          	auipc	ra,0x3
    4c42:	c16080e7          	jalr	-1002(ra) # 7854 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    4c46:	00005597          	auipc	a1,0x5
    4c4a:	cfa58593          	addi	a1,a1,-774 # 9940 <malloc+0x19d2>
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	52250513          	addi	a0,a0,1314 # 8170 <malloc+0x202>
    4c56:	00003097          	auipc	ra,0x3
    4c5a:	c5e080e7          	jalr	-930(ra) # 78b4 <link>
    4c5e:	87aa                	mv	a5,a0
    4c60:	e385                	bnez	a5,4c80 <dirfile+0x1ae>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4c62:	fd843583          	ld	a1,-40(s0)
    4c66:	00005517          	auipc	a0,0x5
    4c6a:	d6250513          	addi	a0,a0,-670 # 99c8 <malloc+0x1a5a>
    4c6e:	00003097          	auipc	ra,0x3
    4c72:	10e080e7          	jalr	270(ra) # 7d7c <printf>
    exit(1);
    4c76:	4505                	li	a0,1
    4c78:	00003097          	auipc	ra,0x3
    4c7c:	bdc080e7          	jalr	-1060(ra) # 7854 <exit>
  }
  if(unlink("dirfile") != 0){
    4c80:	00005517          	auipc	a0,0x5
    4c84:	c7850513          	addi	a0,a0,-904 # 98f8 <malloc+0x198a>
    4c88:	00003097          	auipc	ra,0x3
    4c8c:	c1c080e7          	jalr	-996(ra) # 78a4 <unlink>
    4c90:	87aa                	mv	a5,a0
    4c92:	c385                	beqz	a5,4cb2 <dirfile+0x1e0>
    printf("%s: unlink dirfile failed!\n", s);
    4c94:	fd843583          	ld	a1,-40(s0)
    4c98:	00005517          	auipc	a0,0x5
    4c9c:	d5850513          	addi	a0,a0,-680 # 99f0 <malloc+0x1a82>
    4ca0:	00003097          	auipc	ra,0x3
    4ca4:	0dc080e7          	jalr	220(ra) # 7d7c <printf>
    exit(1);
    4ca8:	4505                	li	a0,1
    4caa:	00003097          	auipc	ra,0x3
    4cae:	baa080e7          	jalr	-1110(ra) # 7854 <exit>
  }

  fd = open(".", O_RDWR);
    4cb2:	4589                	li	a1,2
    4cb4:	00004517          	auipc	a0,0x4
    4cb8:	1c450513          	addi	a0,a0,452 # 8e78 <malloc+0xf0a>
    4cbc:	00003097          	auipc	ra,0x3
    4cc0:	bd8080e7          	jalr	-1064(ra) # 7894 <open>
    4cc4:	87aa                	mv	a5,a0
    4cc6:	fef42623          	sw	a5,-20(s0)
  if(fd >= 0){
    4cca:	fec42783          	lw	a5,-20(s0)
    4cce:	2781                	sext.w	a5,a5
    4cd0:	0207c163          	bltz	a5,4cf2 <dirfile+0x220>
    printf("%s: open . for writing succeeded!\n", s);
    4cd4:	fd843583          	ld	a1,-40(s0)
    4cd8:	00005517          	auipc	a0,0x5
    4cdc:	d3850513          	addi	a0,a0,-712 # 9a10 <malloc+0x1aa2>
    4ce0:	00003097          	auipc	ra,0x3
    4ce4:	09c080e7          	jalr	156(ra) # 7d7c <printf>
    exit(1);
    4ce8:	4505                	li	a0,1
    4cea:	00003097          	auipc	ra,0x3
    4cee:	b6a080e7          	jalr	-1174(ra) # 7854 <exit>
  }
  fd = open(".", 0);
    4cf2:	4581                	li	a1,0
    4cf4:	00004517          	auipc	a0,0x4
    4cf8:	18450513          	addi	a0,a0,388 # 8e78 <malloc+0xf0a>
    4cfc:	00003097          	auipc	ra,0x3
    4d00:	b98080e7          	jalr	-1128(ra) # 7894 <open>
    4d04:	87aa                	mv	a5,a0
    4d06:	fef42623          	sw	a5,-20(s0)
  if(write(fd, "x", 1) > 0){
    4d0a:	fec42783          	lw	a5,-20(s0)
    4d0e:	4605                	li	a2,1
    4d10:	00003597          	auipc	a1,0x3
    4d14:	4b058593          	addi	a1,a1,1200 # 81c0 <malloc+0x252>
    4d18:	853e                	mv	a0,a5
    4d1a:	00003097          	auipc	ra,0x3
    4d1e:	b5a080e7          	jalr	-1190(ra) # 7874 <write>
    4d22:	87aa                	mv	a5,a0
    4d24:	02f05163          	blez	a5,4d46 <dirfile+0x274>
    printf("%s: write . succeeded!\n", s);
    4d28:	fd843583          	ld	a1,-40(s0)
    4d2c:	00005517          	auipc	a0,0x5
    4d30:	d0c50513          	addi	a0,a0,-756 # 9a38 <malloc+0x1aca>
    4d34:	00003097          	auipc	ra,0x3
    4d38:	048080e7          	jalr	72(ra) # 7d7c <printf>
    exit(1);
    4d3c:	4505                	li	a0,1
    4d3e:	00003097          	auipc	ra,0x3
    4d42:	b16080e7          	jalr	-1258(ra) # 7854 <exit>
  }
  close(fd);
    4d46:	fec42783          	lw	a5,-20(s0)
    4d4a:	853e                	mv	a0,a5
    4d4c:	00003097          	auipc	ra,0x3
    4d50:	b30080e7          	jalr	-1232(ra) # 787c <close>
}
    4d54:	0001                	nop
    4d56:	70a2                	ld	ra,40(sp)
    4d58:	7402                	ld	s0,32(sp)
    4d5a:	6145                	addi	sp,sp,48
    4d5c:	8082                	ret

0000000000004d5e <iref>:

// test that iput() is called at the end of _namei().
// also tests empty file names.
void
iref(char *s)
{
    4d5e:	7179                	addi	sp,sp,-48
    4d60:	f406                	sd	ra,40(sp)
    4d62:	f022                	sd	s0,32(sp)
    4d64:	1800                	addi	s0,sp,48
    4d66:	fca43c23          	sd	a0,-40(s0)
  int i, fd;

  for(i = 0; i < NINODE + 1; i++){
    4d6a:	fe042623          	sw	zero,-20(s0)
    4d6e:	a231                	j	4e7a <iref+0x11c>
    if(mkdir("irefd") != 0){
    4d70:	00005517          	auipc	a0,0x5
    4d74:	ce050513          	addi	a0,a0,-800 # 9a50 <malloc+0x1ae2>
    4d78:	00003097          	auipc	ra,0x3
    4d7c:	b44080e7          	jalr	-1212(ra) # 78bc <mkdir>
    4d80:	87aa                	mv	a5,a0
    4d82:	c385                	beqz	a5,4da2 <iref+0x44>
      printf("%s: mkdir irefd failed\n", s);
    4d84:	fd843583          	ld	a1,-40(s0)
    4d88:	00005517          	auipc	a0,0x5
    4d8c:	cd050513          	addi	a0,a0,-816 # 9a58 <malloc+0x1aea>
    4d90:	00003097          	auipc	ra,0x3
    4d94:	fec080e7          	jalr	-20(ra) # 7d7c <printf>
      exit(1);
    4d98:	4505                	li	a0,1
    4d9a:	00003097          	auipc	ra,0x3
    4d9e:	aba080e7          	jalr	-1350(ra) # 7854 <exit>
    }
    if(chdir("irefd") != 0){
    4da2:	00005517          	auipc	a0,0x5
    4da6:	cae50513          	addi	a0,a0,-850 # 9a50 <malloc+0x1ae2>
    4daa:	00003097          	auipc	ra,0x3
    4dae:	b1a080e7          	jalr	-1254(ra) # 78c4 <chdir>
    4db2:	87aa                	mv	a5,a0
    4db4:	c385                	beqz	a5,4dd4 <iref+0x76>
      printf("%s: chdir irefd failed\n", s);
    4db6:	fd843583          	ld	a1,-40(s0)
    4dba:	00005517          	auipc	a0,0x5
    4dbe:	cb650513          	addi	a0,a0,-842 # 9a70 <malloc+0x1b02>
    4dc2:	00003097          	auipc	ra,0x3
    4dc6:	fba080e7          	jalr	-70(ra) # 7d7c <printf>
      exit(1);
    4dca:	4505                	li	a0,1
    4dcc:	00003097          	auipc	ra,0x3
    4dd0:	a88080e7          	jalr	-1400(ra) # 7854 <exit>
    }

    mkdir("");
    4dd4:	00005517          	auipc	a0,0x5
    4dd8:	cb450513          	addi	a0,a0,-844 # 9a88 <malloc+0x1b1a>
    4ddc:	00003097          	auipc	ra,0x3
    4de0:	ae0080e7          	jalr	-1312(ra) # 78bc <mkdir>
    link("README", "");
    4de4:	00005597          	auipc	a1,0x5
    4de8:	ca458593          	addi	a1,a1,-860 # 9a88 <malloc+0x1b1a>
    4dec:	00003517          	auipc	a0,0x3
    4df0:	38450513          	addi	a0,a0,900 # 8170 <malloc+0x202>
    4df4:	00003097          	auipc	ra,0x3
    4df8:	ac0080e7          	jalr	-1344(ra) # 78b4 <link>
    fd = open("", O_CREATE);
    4dfc:	20000593          	li	a1,512
    4e00:	00005517          	auipc	a0,0x5
    4e04:	c8850513          	addi	a0,a0,-888 # 9a88 <malloc+0x1b1a>
    4e08:	00003097          	auipc	ra,0x3
    4e0c:	a8c080e7          	jalr	-1396(ra) # 7894 <open>
    4e10:	87aa                	mv	a5,a0
    4e12:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0)
    4e16:	fe842783          	lw	a5,-24(s0)
    4e1a:	2781                	sext.w	a5,a5
    4e1c:	0007c963          	bltz	a5,4e2e <iref+0xd0>
      close(fd);
    4e20:	fe842783          	lw	a5,-24(s0)
    4e24:	853e                	mv	a0,a5
    4e26:	00003097          	auipc	ra,0x3
    4e2a:	a56080e7          	jalr	-1450(ra) # 787c <close>
    fd = open("xx", O_CREATE);
    4e2e:	20000593          	li	a1,512
    4e32:	00003517          	auipc	a0,0x3
    4e36:	46650513          	addi	a0,a0,1126 # 8298 <malloc+0x32a>
    4e3a:	00003097          	auipc	ra,0x3
    4e3e:	a5a080e7          	jalr	-1446(ra) # 7894 <open>
    4e42:	87aa                	mv	a5,a0
    4e44:	fef42423          	sw	a5,-24(s0)
    if(fd >= 0)
    4e48:	fe842783          	lw	a5,-24(s0)
    4e4c:	2781                	sext.w	a5,a5
    4e4e:	0007c963          	bltz	a5,4e60 <iref+0x102>
      close(fd);
    4e52:	fe842783          	lw	a5,-24(s0)
    4e56:	853e                	mv	a0,a5
    4e58:	00003097          	auipc	ra,0x3
    4e5c:	a24080e7          	jalr	-1500(ra) # 787c <close>
    unlink("xx");
    4e60:	00003517          	auipc	a0,0x3
    4e64:	43850513          	addi	a0,a0,1080 # 8298 <malloc+0x32a>
    4e68:	00003097          	auipc	ra,0x3
    4e6c:	a3c080e7          	jalr	-1476(ra) # 78a4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4e70:	fec42783          	lw	a5,-20(s0)
    4e74:	2785                	addiw	a5,a5,1
    4e76:	fef42623          	sw	a5,-20(s0)
    4e7a:	fec42783          	lw	a5,-20(s0)
    4e7e:	0007871b          	sext.w	a4,a5
    4e82:	03200793          	li	a5,50
    4e86:	eee7d5e3          	bge	a5,a4,4d70 <iref+0x12>
  }

  // clean up
  for(i = 0; i < NINODE + 1; i++){
    4e8a:	fe042623          	sw	zero,-20(s0)
    4e8e:	a035                	j	4eba <iref+0x15c>
    chdir("..");
    4e90:	00004517          	auipc	a0,0x4
    4e94:	a4050513          	addi	a0,a0,-1472 # 88d0 <malloc+0x962>
    4e98:	00003097          	auipc	ra,0x3
    4e9c:	a2c080e7          	jalr	-1492(ra) # 78c4 <chdir>
    unlink("irefd");
    4ea0:	00005517          	auipc	a0,0x5
    4ea4:	bb050513          	addi	a0,a0,-1104 # 9a50 <malloc+0x1ae2>
    4ea8:	00003097          	auipc	ra,0x3
    4eac:	9fc080e7          	jalr	-1540(ra) # 78a4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4eb0:	fec42783          	lw	a5,-20(s0)
    4eb4:	2785                	addiw	a5,a5,1
    4eb6:	fef42623          	sw	a5,-20(s0)
    4eba:	fec42783          	lw	a5,-20(s0)
    4ebe:	0007871b          	sext.w	a4,a5
    4ec2:	03200793          	li	a5,50
    4ec6:	fce7d5e3          	bge	a5,a4,4e90 <iref+0x132>
  }

  chdir("/");
    4eca:	00003517          	auipc	a0,0x3
    4ece:	71e50513          	addi	a0,a0,1822 # 85e8 <malloc+0x67a>
    4ed2:	00003097          	auipc	ra,0x3
    4ed6:	9f2080e7          	jalr	-1550(ra) # 78c4 <chdir>
}
    4eda:	0001                	nop
    4edc:	70a2                	ld	ra,40(sp)
    4ede:	7402                	ld	s0,32(sp)
    4ee0:	6145                	addi	sp,sp,48
    4ee2:	8082                	ret

0000000000004ee4 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(char *s)
{
    4ee4:	7179                	addi	sp,sp,-48
    4ee6:	f406                	sd	ra,40(sp)
    4ee8:	f022                	sd	s0,32(sp)
    4eea:	1800                	addi	s0,sp,48
    4eec:	fca43c23          	sd	a0,-40(s0)
  enum{ N = 1000 };
  int n, pid;

  for(n=0; n<N; n++){
    4ef0:	fe042623          	sw	zero,-20(s0)
    4ef4:	a81d                	j	4f2a <forktest+0x46>
    pid = fork();
    4ef6:	00003097          	auipc	ra,0x3
    4efa:	956080e7          	jalr	-1706(ra) # 784c <fork>
    4efe:	87aa                	mv	a5,a0
    4f00:	fef42423          	sw	a5,-24(s0)
    if(pid < 0)
    4f04:	fe842783          	lw	a5,-24(s0)
    4f08:	2781                	sext.w	a5,a5
    4f0a:	0207c963          	bltz	a5,4f3c <forktest+0x58>
      break;
    if(pid == 0)
    4f0e:	fe842783          	lw	a5,-24(s0)
    4f12:	2781                	sext.w	a5,a5
    4f14:	e791                	bnez	a5,4f20 <forktest+0x3c>
      exit(0);
    4f16:	4501                	li	a0,0
    4f18:	00003097          	auipc	ra,0x3
    4f1c:	93c080e7          	jalr	-1732(ra) # 7854 <exit>
  for(n=0; n<N; n++){
    4f20:	fec42783          	lw	a5,-20(s0)
    4f24:	2785                	addiw	a5,a5,1
    4f26:	fef42623          	sw	a5,-20(s0)
    4f2a:	fec42783          	lw	a5,-20(s0)
    4f2e:	0007871b          	sext.w	a4,a5
    4f32:	3e700793          	li	a5,999
    4f36:	fce7d0e3          	bge	a5,a4,4ef6 <forktest+0x12>
    4f3a:	a011                	j	4f3e <forktest+0x5a>
      break;
    4f3c:	0001                	nop
  }

  if (n == 0) {
    4f3e:	fec42783          	lw	a5,-20(s0)
    4f42:	2781                	sext.w	a5,a5
    4f44:	e385                	bnez	a5,4f64 <forktest+0x80>
    printf("%s: no fork at all!\n", s);
    4f46:	fd843583          	ld	a1,-40(s0)
    4f4a:	00005517          	auipc	a0,0x5
    4f4e:	b4650513          	addi	a0,a0,-1210 # 9a90 <malloc+0x1b22>
    4f52:	00003097          	auipc	ra,0x3
    4f56:	e2a080e7          	jalr	-470(ra) # 7d7c <printf>
    exit(1);
    4f5a:	4505                	li	a0,1
    4f5c:	00003097          	auipc	ra,0x3
    4f60:	8f8080e7          	jalr	-1800(ra) # 7854 <exit>
  }

  if(n == N){
    4f64:	fec42783          	lw	a5,-20(s0)
    4f68:	0007871b          	sext.w	a4,a5
    4f6c:	3e800793          	li	a5,1000
    4f70:	04f71d63          	bne	a4,a5,4fca <forktest+0xe6>
    printf("%s: fork claimed to work 1000 times!\n", s);
    4f74:	fd843583          	ld	a1,-40(s0)
    4f78:	00005517          	auipc	a0,0x5
    4f7c:	b3050513          	addi	a0,a0,-1232 # 9aa8 <malloc+0x1b3a>
    4f80:	00003097          	auipc	ra,0x3
    4f84:	dfc080e7          	jalr	-516(ra) # 7d7c <printf>
    exit(1);
    4f88:	4505                	li	a0,1
    4f8a:	00003097          	auipc	ra,0x3
    4f8e:	8ca080e7          	jalr	-1846(ra) # 7854 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
    4f92:	4501                	li	a0,0
    4f94:	00003097          	auipc	ra,0x3
    4f98:	8c8080e7          	jalr	-1848(ra) # 785c <wait>
    4f9c:	87aa                	mv	a5,a0
    4f9e:	0207d163          	bgez	a5,4fc0 <forktest+0xdc>
      printf("%s: wait stopped early\n", s);
    4fa2:	fd843583          	ld	a1,-40(s0)
    4fa6:	00005517          	auipc	a0,0x5
    4faa:	b2a50513          	addi	a0,a0,-1238 # 9ad0 <malloc+0x1b62>
    4fae:	00003097          	auipc	ra,0x3
    4fb2:	dce080e7          	jalr	-562(ra) # 7d7c <printf>
      exit(1);
    4fb6:	4505                	li	a0,1
    4fb8:	00003097          	auipc	ra,0x3
    4fbc:	89c080e7          	jalr	-1892(ra) # 7854 <exit>
  for(; n > 0; n--){
    4fc0:	fec42783          	lw	a5,-20(s0)
    4fc4:	37fd                	addiw	a5,a5,-1
    4fc6:	fef42623          	sw	a5,-20(s0)
    4fca:	fec42783          	lw	a5,-20(s0)
    4fce:	2781                	sext.w	a5,a5
    4fd0:	fcf041e3          	bgtz	a5,4f92 <forktest+0xae>
    }
  }

  if(wait(0) != -1){
    4fd4:	4501                	li	a0,0
    4fd6:	00003097          	auipc	ra,0x3
    4fda:	886080e7          	jalr	-1914(ra) # 785c <wait>
    4fde:	87aa                	mv	a5,a0
    4fe0:	873e                	mv	a4,a5
    4fe2:	57fd                	li	a5,-1
    4fe4:	02f70163          	beq	a4,a5,5006 <forktest+0x122>
    printf("%s: wait got too many\n", s);
    4fe8:	fd843583          	ld	a1,-40(s0)
    4fec:	00005517          	auipc	a0,0x5
    4ff0:	afc50513          	addi	a0,a0,-1284 # 9ae8 <malloc+0x1b7a>
    4ff4:	00003097          	auipc	ra,0x3
    4ff8:	d88080e7          	jalr	-632(ra) # 7d7c <printf>
    exit(1);
    4ffc:	4505                	li	a0,1
    4ffe:	00003097          	auipc	ra,0x3
    5002:	856080e7          	jalr	-1962(ra) # 7854 <exit>
  }
}
    5006:	0001                	nop
    5008:	70a2                	ld	ra,40(sp)
    500a:	7402                	ld	s0,32(sp)
    500c:	6145                	addi	sp,sp,48
    500e:	8082                	ret

0000000000005010 <sbrkbasic>:

void
sbrkbasic(char *s)
{
    5010:	715d                	addi	sp,sp,-80
    5012:	e486                	sd	ra,72(sp)
    5014:	e0a2                	sd	s0,64(sp)
    5016:	0880                	addi	s0,sp,80
    5018:	faa43c23          	sd	a0,-72(s0)
  enum { TOOMUCH=1024*1024*1024};
  int i, pid, xstatus;
  char *c, *a, *b;

  // does sbrk() return the expected failure value?
  pid = fork();
    501c:	00003097          	auipc	ra,0x3
    5020:	830080e7          	jalr	-2000(ra) # 784c <fork>
    5024:	87aa                	mv	a5,a0
    5026:	fcf42a23          	sw	a5,-44(s0)
  if(pid < 0){
    502a:	fd442783          	lw	a5,-44(s0)
    502e:	2781                	sext.w	a5,a5
    5030:	0007df63          	bgez	a5,504e <sbrkbasic+0x3e>
    printf("fork failed in sbrkbasic\n");
    5034:	00005517          	auipc	a0,0x5
    5038:	acc50513          	addi	a0,a0,-1332 # 9b00 <malloc+0x1b92>
    503c:	00003097          	auipc	ra,0x3
    5040:	d40080e7          	jalr	-704(ra) # 7d7c <printf>
    exit(1);
    5044:	4505                	li	a0,1
    5046:	00003097          	auipc	ra,0x3
    504a:	80e080e7          	jalr	-2034(ra) # 7854 <exit>
  }
  if(pid == 0){
    504e:	fd442783          	lw	a5,-44(s0)
    5052:	2781                	sext.w	a5,a5
    5054:	e3b5                	bnez	a5,50b8 <sbrkbasic+0xa8>
    a = sbrk(TOOMUCH);
    5056:	40000537          	lui	a0,0x40000
    505a:	00003097          	auipc	ra,0x3
    505e:	882080e7          	jalr	-1918(ra) # 78dc <sbrk>
    5062:	fea43023          	sd	a0,-32(s0)
    if(a == (char*)0xffffffffffffffffL){
    5066:	fe043703          	ld	a4,-32(s0)
    506a:	57fd                	li	a5,-1
    506c:	00f71763          	bne	a4,a5,507a <sbrkbasic+0x6a>
      // it's OK if this fails.
      exit(0);
    5070:	4501                	li	a0,0
    5072:	00002097          	auipc	ra,0x2
    5076:	7e2080e7          	jalr	2018(ra) # 7854 <exit>
    }

    for(b = a; b < a+TOOMUCH; b += 4096){
    507a:	fe043783          	ld	a5,-32(s0)
    507e:	fcf43c23          	sd	a5,-40(s0)
    5082:	a829                	j	509c <sbrkbasic+0x8c>
      *b = 99;
    5084:	fd843783          	ld	a5,-40(s0)
    5088:	06300713          	li	a4,99
    508c:	00e78023          	sb	a4,0(a5)
    for(b = a; b < a+TOOMUCH; b += 4096){
    5090:	fd843703          	ld	a4,-40(s0)
    5094:	6785                	lui	a5,0x1
    5096:	97ba                	add	a5,a5,a4
    5098:	fcf43c23          	sd	a5,-40(s0)
    509c:	fe043703          	ld	a4,-32(s0)
    50a0:	400007b7          	lui	a5,0x40000
    50a4:	97ba                	add	a5,a5,a4
    50a6:	fd843703          	ld	a4,-40(s0)
    50aa:	fcf76de3          	bltu	a4,a5,5084 <sbrkbasic+0x74>
    }

    // we should not get here! either sbrk(TOOMUCH)
    // should have failed, or (with lazy allocation)
    // a pagefault should have killed this process.
    exit(1);
    50ae:	4505                	li	a0,1
    50b0:	00002097          	auipc	ra,0x2
    50b4:	7a4080e7          	jalr	1956(ra) # 7854 <exit>
  }

  wait(&xstatus);
    50b8:	fc440793          	addi	a5,s0,-60
    50bc:	853e                	mv	a0,a5
    50be:	00002097          	auipc	ra,0x2
    50c2:	79e080e7          	jalr	1950(ra) # 785c <wait>
  if(xstatus == 1){
    50c6:	fc442783          	lw	a5,-60(s0)
    50ca:	873e                	mv	a4,a5
    50cc:	4785                	li	a5,1
    50ce:	02f71163          	bne	a4,a5,50f0 <sbrkbasic+0xe0>
    printf("%s: too much memory allocated!\n", s);
    50d2:	fb843583          	ld	a1,-72(s0)
    50d6:	00005517          	auipc	a0,0x5
    50da:	a4a50513          	addi	a0,a0,-1462 # 9b20 <malloc+0x1bb2>
    50de:	00003097          	auipc	ra,0x3
    50e2:	c9e080e7          	jalr	-866(ra) # 7d7c <printf>
    exit(1);
    50e6:	4505                	li	a0,1
    50e8:	00002097          	auipc	ra,0x2
    50ec:	76c080e7          	jalr	1900(ra) # 7854 <exit>
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    50f0:	4501                	li	a0,0
    50f2:	00002097          	auipc	ra,0x2
    50f6:	7ea080e7          	jalr	2026(ra) # 78dc <sbrk>
    50fa:	fea43023          	sd	a0,-32(s0)
  for(i = 0; i < 5000; i++){
    50fe:	fe042623          	sw	zero,-20(s0)
    5102:	a09d                	j	5168 <sbrkbasic+0x158>
    b = sbrk(1);
    5104:	4505                	li	a0,1
    5106:	00002097          	auipc	ra,0x2
    510a:	7d6080e7          	jalr	2006(ra) # 78dc <sbrk>
    510e:	fca43c23          	sd	a0,-40(s0)
    if(b != a){
    5112:	fd843703          	ld	a4,-40(s0)
    5116:	fe043783          	ld	a5,-32(s0)
    511a:	02f70863          	beq	a4,a5,514a <sbrkbasic+0x13a>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    511e:	fec42783          	lw	a5,-20(s0)
    5122:	fd843703          	ld	a4,-40(s0)
    5126:	fe043683          	ld	a3,-32(s0)
    512a:	863e                	mv	a2,a5
    512c:	fb843583          	ld	a1,-72(s0)
    5130:	00005517          	auipc	a0,0x5
    5134:	a1050513          	addi	a0,a0,-1520 # 9b40 <malloc+0x1bd2>
    5138:	00003097          	auipc	ra,0x3
    513c:	c44080e7          	jalr	-956(ra) # 7d7c <printf>
      exit(1);
    5140:	4505                	li	a0,1
    5142:	00002097          	auipc	ra,0x2
    5146:	712080e7          	jalr	1810(ra) # 7854 <exit>
    }
    *b = 1;
    514a:	fd843783          	ld	a5,-40(s0)
    514e:	4705                	li	a4,1
    5150:	00e78023          	sb	a4,0(a5) # 40000000 <freep+0x3ffed4f8>
    a = b + 1;
    5154:	fd843783          	ld	a5,-40(s0)
    5158:	0785                	addi	a5,a5,1
    515a:	fef43023          	sd	a5,-32(s0)
  for(i = 0; i < 5000; i++){
    515e:	fec42783          	lw	a5,-20(s0)
    5162:	2785                	addiw	a5,a5,1
    5164:	fef42623          	sw	a5,-20(s0)
    5168:	fec42783          	lw	a5,-20(s0)
    516c:	0007871b          	sext.w	a4,a5
    5170:	6785                	lui	a5,0x1
    5172:	38778793          	addi	a5,a5,903 # 1387 <openiputtest+0xe9>
    5176:	f8e7d7e3          	bge	a5,a4,5104 <sbrkbasic+0xf4>
  }
  pid = fork();
    517a:	00002097          	auipc	ra,0x2
    517e:	6d2080e7          	jalr	1746(ra) # 784c <fork>
    5182:	87aa                	mv	a5,a0
    5184:	fcf42a23          	sw	a5,-44(s0)
  if(pid < 0){
    5188:	fd442783          	lw	a5,-44(s0)
    518c:	2781                	sext.w	a5,a5
    518e:	0207d163          	bgez	a5,51b0 <sbrkbasic+0x1a0>
    printf("%s: sbrk test fork failed\n", s);
    5192:	fb843583          	ld	a1,-72(s0)
    5196:	00005517          	auipc	a0,0x5
    519a:	9ca50513          	addi	a0,a0,-1590 # 9b60 <malloc+0x1bf2>
    519e:	00003097          	auipc	ra,0x3
    51a2:	bde080e7          	jalr	-1058(ra) # 7d7c <printf>
    exit(1);
    51a6:	4505                	li	a0,1
    51a8:	00002097          	auipc	ra,0x2
    51ac:	6ac080e7          	jalr	1708(ra) # 7854 <exit>
  }
  c = sbrk(1);
    51b0:	4505                	li	a0,1
    51b2:	00002097          	auipc	ra,0x2
    51b6:	72a080e7          	jalr	1834(ra) # 78dc <sbrk>
    51ba:	fca43423          	sd	a0,-56(s0)
  c = sbrk(1);
    51be:	4505                	li	a0,1
    51c0:	00002097          	auipc	ra,0x2
    51c4:	71c080e7          	jalr	1820(ra) # 78dc <sbrk>
    51c8:	fca43423          	sd	a0,-56(s0)
  if(c != a + 1){
    51cc:	fe043783          	ld	a5,-32(s0)
    51d0:	0785                	addi	a5,a5,1
    51d2:	fc843703          	ld	a4,-56(s0)
    51d6:	02f70163          	beq	a4,a5,51f8 <sbrkbasic+0x1e8>
    printf("%s: sbrk test failed post-fork\n", s);
    51da:	fb843583          	ld	a1,-72(s0)
    51de:	00005517          	auipc	a0,0x5
    51e2:	9a250513          	addi	a0,a0,-1630 # 9b80 <malloc+0x1c12>
    51e6:	00003097          	auipc	ra,0x3
    51ea:	b96080e7          	jalr	-1130(ra) # 7d7c <printf>
    exit(1);
    51ee:	4505                	li	a0,1
    51f0:	00002097          	auipc	ra,0x2
    51f4:	664080e7          	jalr	1636(ra) # 7854 <exit>
  }
  if(pid == 0)
    51f8:	fd442783          	lw	a5,-44(s0)
    51fc:	2781                	sext.w	a5,a5
    51fe:	e791                	bnez	a5,520a <sbrkbasic+0x1fa>
    exit(0);
    5200:	4501                	li	a0,0
    5202:	00002097          	auipc	ra,0x2
    5206:	652080e7          	jalr	1618(ra) # 7854 <exit>
  wait(&xstatus);
    520a:	fc440793          	addi	a5,s0,-60
    520e:	853e                	mv	a0,a5
    5210:	00002097          	auipc	ra,0x2
    5214:	64c080e7          	jalr	1612(ra) # 785c <wait>
  exit(xstatus);
    5218:	fc442783          	lw	a5,-60(s0)
    521c:	853e                	mv	a0,a5
    521e:	00002097          	auipc	ra,0x2
    5222:	636080e7          	jalr	1590(ra) # 7854 <exit>

0000000000005226 <sbrkmuch>:
}

void
sbrkmuch(char *s)
{
    5226:	711d                	addi	sp,sp,-96
    5228:	ec86                	sd	ra,88(sp)
    522a:	e8a2                	sd	s0,80(sp)
    522c:	1080                	addi	s0,sp,96
    522e:	faa43423          	sd	a0,-88(s0)
  enum { BIG=18*1024*1024 };
  char *c, *oldbrk, *a, *lastaddr, *p;
  uint64 amt;

  oldbrk = sbrk(0);
    5232:	4501                	li	a0,0
    5234:	00002097          	auipc	ra,0x2
    5238:	6a8080e7          	jalr	1704(ra) # 78dc <sbrk>
    523c:	fea43023          	sd	a0,-32(s0)

  // can one grow address space to something big?
  a = sbrk(0);
    5240:	4501                	li	a0,0
    5242:	00002097          	auipc	ra,0x2
    5246:	69a080e7          	jalr	1690(ra) # 78dc <sbrk>
    524a:	fca43c23          	sd	a0,-40(s0)
  amt = BIG - (uint64)a;
    524e:	fd843783          	ld	a5,-40(s0)
    5252:	01200737          	lui	a4,0x1200
    5256:	40f707b3          	sub	a5,a4,a5
    525a:	fcf43823          	sd	a5,-48(s0)
  p = sbrk(amt);
    525e:	fd043783          	ld	a5,-48(s0)
    5262:	2781                	sext.w	a5,a5
    5264:	853e                	mv	a0,a5
    5266:	00002097          	auipc	ra,0x2
    526a:	676080e7          	jalr	1654(ra) # 78dc <sbrk>
    526e:	fca43423          	sd	a0,-56(s0)

  if (p != a) {
    5272:	fc843703          	ld	a4,-56(s0)
    5276:	fd843783          	ld	a5,-40(s0)
    527a:	02f70163          	beq	a4,a5,529c <sbrkmuch+0x76>
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    527e:	fa843583          	ld	a1,-88(s0)
    5282:	00005517          	auipc	a0,0x5
    5286:	91e50513          	addi	a0,a0,-1762 # 9ba0 <malloc+0x1c32>
    528a:	00003097          	auipc	ra,0x3
    528e:	af2080e7          	jalr	-1294(ra) # 7d7c <printf>
    exit(1);
    5292:	4505                	li	a0,1
    5294:	00002097          	auipc	ra,0x2
    5298:	5c0080e7          	jalr	1472(ra) # 7854 <exit>
  }

  // touch each page to make sure it exists.
  char *eee = sbrk(0);
    529c:	4501                	li	a0,0
    529e:	00002097          	auipc	ra,0x2
    52a2:	63e080e7          	jalr	1598(ra) # 78dc <sbrk>
    52a6:	fca43023          	sd	a0,-64(s0)
  for(char *pp = eee-4096; pp > a; pp -= 4096)
    52aa:	fc043703          	ld	a4,-64(s0)
    52ae:	77fd                	lui	a5,0xfffff
    52b0:	97ba                	add	a5,a5,a4
    52b2:	fef43423          	sd	a5,-24(s0)
    52b6:	a821                	j	52ce <sbrkmuch+0xa8>
    *pp = 1;
    52b8:	fe843783          	ld	a5,-24(s0)
    52bc:	4705                	li	a4,1
    52be:	00e78023          	sb	a4,0(a5) # fffffffffffff000 <freep+0xfffffffffffec4f8>
  for(char *pp = eee-4096; pp > a; pp -= 4096)
    52c2:	fe843703          	ld	a4,-24(s0)
    52c6:	77fd                	lui	a5,0xfffff
    52c8:	97ba                	add	a5,a5,a4
    52ca:	fef43423          	sd	a5,-24(s0)
    52ce:	fe843703          	ld	a4,-24(s0)
    52d2:	fd843783          	ld	a5,-40(s0)
    52d6:	fee7e1e3          	bltu	a5,a4,52b8 <sbrkmuch+0x92>

  lastaddr = (char*) (BIG-1);
    52da:	012007b7          	lui	a5,0x1200
    52de:	17fd                	addi	a5,a5,-1 # 11fffff <freep+0x11ed4f7>
    52e0:	faf43c23          	sd	a5,-72(s0)
  *lastaddr = 99;
    52e4:	fb843783          	ld	a5,-72(s0)
    52e8:	06300713          	li	a4,99
    52ec:	00e78023          	sb	a4,0(a5)

  // can one de-allocate?
  a = sbrk(0);
    52f0:	4501                	li	a0,0
    52f2:	00002097          	auipc	ra,0x2
    52f6:	5ea080e7          	jalr	1514(ra) # 78dc <sbrk>
    52fa:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(-PGSIZE);
    52fe:	757d                	lui	a0,0xfffff
    5300:	00002097          	auipc	ra,0x2
    5304:	5dc080e7          	jalr	1500(ra) # 78dc <sbrk>
    5308:	faa43823          	sd	a0,-80(s0)
  if(c == (char*)0xffffffffffffffffL){
    530c:	fb043703          	ld	a4,-80(s0)
    5310:	57fd                	li	a5,-1
    5312:	02f71163          	bne	a4,a5,5334 <sbrkmuch+0x10e>
    printf("%s: sbrk could not deallocate\n", s);
    5316:	fa843583          	ld	a1,-88(s0)
    531a:	00005517          	auipc	a0,0x5
    531e:	8ce50513          	addi	a0,a0,-1842 # 9be8 <malloc+0x1c7a>
    5322:	00003097          	auipc	ra,0x3
    5326:	a5a080e7          	jalr	-1446(ra) # 7d7c <printf>
    exit(1);
    532a:	4505                	li	a0,1
    532c:	00002097          	auipc	ra,0x2
    5330:	528080e7          	jalr	1320(ra) # 7854 <exit>
  }

  c = sbrk(0);
    5334:	4501                	li	a0,0
    5336:	00002097          	auipc	ra,0x2
    533a:	5a6080e7          	jalr	1446(ra) # 78dc <sbrk>
    533e:	faa43823          	sd	a0,-80(s0)
  if(c != a - PGSIZE){
    5342:	fd843703          	ld	a4,-40(s0)
    5346:	77fd                	lui	a5,0xfffff
    5348:	97ba                	add	a5,a5,a4
    534a:	fb043703          	ld	a4,-80(s0)
    534e:	02f70563          	beq	a4,a5,5378 <sbrkmuch+0x152>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    5352:	fb043683          	ld	a3,-80(s0)
    5356:	fd843603          	ld	a2,-40(s0)
    535a:	fa843583          	ld	a1,-88(s0)
    535e:	00005517          	auipc	a0,0x5
    5362:	8aa50513          	addi	a0,a0,-1878 # 9c08 <malloc+0x1c9a>
    5366:	00003097          	auipc	ra,0x3
    536a:	a16080e7          	jalr	-1514(ra) # 7d7c <printf>
    exit(1);
    536e:	4505                	li	a0,1
    5370:	00002097          	auipc	ra,0x2
    5374:	4e4080e7          	jalr	1252(ra) # 7854 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    5378:	4501                	li	a0,0
    537a:	00002097          	auipc	ra,0x2
    537e:	562080e7          	jalr	1378(ra) # 78dc <sbrk>
    5382:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(PGSIZE);
    5386:	6505                	lui	a0,0x1
    5388:	00002097          	auipc	ra,0x2
    538c:	554080e7          	jalr	1364(ra) # 78dc <sbrk>
    5390:	faa43823          	sd	a0,-80(s0)
  if(c != a || sbrk(0) != a + PGSIZE){
    5394:	fb043703          	ld	a4,-80(s0)
    5398:	fd843783          	ld	a5,-40(s0)
    539c:	00f71e63          	bne	a4,a5,53b8 <sbrkmuch+0x192>
    53a0:	4501                	li	a0,0
    53a2:	00002097          	auipc	ra,0x2
    53a6:	53a080e7          	jalr	1338(ra) # 78dc <sbrk>
    53aa:	86aa                	mv	a3,a0
    53ac:	fd843703          	ld	a4,-40(s0)
    53b0:	6785                	lui	a5,0x1
    53b2:	97ba                	add	a5,a5,a4
    53b4:	02f68563          	beq	a3,a5,53de <sbrkmuch+0x1b8>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    53b8:	fb043683          	ld	a3,-80(s0)
    53bc:	fd843603          	ld	a2,-40(s0)
    53c0:	fa843583          	ld	a1,-88(s0)
    53c4:	00005517          	auipc	a0,0x5
    53c8:	88450513          	addi	a0,a0,-1916 # 9c48 <malloc+0x1cda>
    53cc:	00003097          	auipc	ra,0x3
    53d0:	9b0080e7          	jalr	-1616(ra) # 7d7c <printf>
    exit(1);
    53d4:	4505                	li	a0,1
    53d6:	00002097          	auipc	ra,0x2
    53da:	47e080e7          	jalr	1150(ra) # 7854 <exit>
  }

  if(*lastaddr == 99){
    53de:	fb843783          	ld	a5,-72(s0)
    53e2:	0007c783          	lbu	a5,0(a5) # 1000 <truncate3+0x1b2>
    53e6:	873e                	mv	a4,a5
    53e8:	06300793          	li	a5,99
    53ec:	02f71163          	bne	a4,a5,540e <sbrkmuch+0x1e8>
    // should be zero
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    53f0:	fa843583          	ld	a1,-88(s0)
    53f4:	00005517          	auipc	a0,0x5
    53f8:	88450513          	addi	a0,a0,-1916 # 9c78 <malloc+0x1d0a>
    53fc:	00003097          	auipc	ra,0x3
    5400:	980080e7          	jalr	-1664(ra) # 7d7c <printf>
    exit(1);
    5404:	4505                	li	a0,1
    5406:	00002097          	auipc	ra,0x2
    540a:	44e080e7          	jalr	1102(ra) # 7854 <exit>
  }

  a = sbrk(0);
    540e:	4501                	li	a0,0
    5410:	00002097          	auipc	ra,0x2
    5414:	4cc080e7          	jalr	1228(ra) # 78dc <sbrk>
    5418:	fca43c23          	sd	a0,-40(s0)
  c = sbrk(-(sbrk(0) - oldbrk));
    541c:	4501                	li	a0,0
    541e:	00002097          	auipc	ra,0x2
    5422:	4be080e7          	jalr	1214(ra) # 78dc <sbrk>
    5426:	872a                	mv	a4,a0
    5428:	fe043783          	ld	a5,-32(s0)
    542c:	8f99                	sub	a5,a5,a4
    542e:	2781                	sext.w	a5,a5
    5430:	853e                	mv	a0,a5
    5432:	00002097          	auipc	ra,0x2
    5436:	4aa080e7          	jalr	1194(ra) # 78dc <sbrk>
    543a:	faa43823          	sd	a0,-80(s0)
  if(c != a){
    543e:	fb043703          	ld	a4,-80(s0)
    5442:	fd843783          	ld	a5,-40(s0)
    5446:	02f70563          	beq	a4,a5,5470 <sbrkmuch+0x24a>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    544a:	fb043683          	ld	a3,-80(s0)
    544e:	fd843603          	ld	a2,-40(s0)
    5452:	fa843583          	ld	a1,-88(s0)
    5456:	00005517          	auipc	a0,0x5
    545a:	85a50513          	addi	a0,a0,-1958 # 9cb0 <malloc+0x1d42>
    545e:	00003097          	auipc	ra,0x3
    5462:	91e080e7          	jalr	-1762(ra) # 7d7c <printf>
    exit(1);
    5466:	4505                	li	a0,1
    5468:	00002097          	auipc	ra,0x2
    546c:	3ec080e7          	jalr	1004(ra) # 7854 <exit>
  }
}
    5470:	0001                	nop
    5472:	60e6                	ld	ra,88(sp)
    5474:	6446                	ld	s0,80(sp)
    5476:	6125                	addi	sp,sp,96
    5478:	8082                	ret

000000000000547a <kernmem>:

// can we read the kernel's memory?
void
kernmem(char *s)
{
    547a:	7179                	addi	sp,sp,-48
    547c:	f406                	sd	ra,40(sp)
    547e:	f022                	sd	s0,32(sp)
    5480:	1800                	addi	s0,sp,48
    5482:	fca43c23          	sd	a0,-40(s0)
  char *a;
  int pid;

  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    5486:	4785                	li	a5,1
    5488:	07fe                	slli	a5,a5,0x1f
    548a:	fef43423          	sd	a5,-24(s0)
    548e:	a04d                	j	5530 <kernmem+0xb6>
    pid = fork();
    5490:	00002097          	auipc	ra,0x2
    5494:	3bc080e7          	jalr	956(ra) # 784c <fork>
    5498:	87aa                	mv	a5,a0
    549a:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    549e:	fe442783          	lw	a5,-28(s0)
    54a2:	2781                	sext.w	a5,a5
    54a4:	0207d163          	bgez	a5,54c6 <kernmem+0x4c>
      printf("%s: fork failed\n", s);
    54a8:	fd843583          	ld	a1,-40(s0)
    54ac:	00003517          	auipc	a0,0x3
    54b0:	04450513          	addi	a0,a0,68 # 84f0 <malloc+0x582>
    54b4:	00003097          	auipc	ra,0x3
    54b8:	8c8080e7          	jalr	-1848(ra) # 7d7c <printf>
      exit(1);
    54bc:	4505                	li	a0,1
    54be:	00002097          	auipc	ra,0x2
    54c2:	396080e7          	jalr	918(ra) # 7854 <exit>
    }
    if(pid == 0){
    54c6:	fe442783          	lw	a5,-28(s0)
    54ca:	2781                	sext.w	a5,a5
    54cc:	eb85                	bnez	a5,54fc <kernmem+0x82>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    54ce:	fe843783          	ld	a5,-24(s0)
    54d2:	0007c783          	lbu	a5,0(a5)
    54d6:	2781                	sext.w	a5,a5
    54d8:	86be                	mv	a3,a5
    54da:	fe843603          	ld	a2,-24(s0)
    54de:	fd843583          	ld	a1,-40(s0)
    54e2:	00004517          	auipc	a0,0x4
    54e6:	7f650513          	addi	a0,a0,2038 # 9cd8 <malloc+0x1d6a>
    54ea:	00003097          	auipc	ra,0x3
    54ee:	892080e7          	jalr	-1902(ra) # 7d7c <printf>
      exit(1);
    54f2:	4505                	li	a0,1
    54f4:	00002097          	auipc	ra,0x2
    54f8:	360080e7          	jalr	864(ra) # 7854 <exit>
    }
    int xstatus;
    wait(&xstatus);
    54fc:	fe040793          	addi	a5,s0,-32
    5500:	853e                	mv	a0,a5
    5502:	00002097          	auipc	ra,0x2
    5506:	35a080e7          	jalr	858(ra) # 785c <wait>
    if(xstatus != -1)  // did kernel kill child?
    550a:	fe042783          	lw	a5,-32(s0)
    550e:	873e                	mv	a4,a5
    5510:	57fd                	li	a5,-1
    5512:	00f70763          	beq	a4,a5,5520 <kernmem+0xa6>
      exit(1);
    5516:	4505                	li	a0,1
    5518:	00002097          	auipc	ra,0x2
    551c:	33c080e7          	jalr	828(ra) # 7854 <exit>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    5520:	fe843703          	ld	a4,-24(s0)
    5524:	67b1                	lui	a5,0xc
    5526:	35078793          	addi	a5,a5,848 # c350 <buf+0x70>
    552a:	97ba                	add	a5,a5,a4
    552c:	fef43423          	sd	a5,-24(s0)
    5530:	fe843703          	ld	a4,-24(s0)
    5534:	1003d7b7          	lui	a5,0x1003d
    5538:	078e                	slli	a5,a5,0x3
    553a:	47f78793          	addi	a5,a5,1151 # 1003d47f <freep+0x1002a977>
    553e:	f4e7f9e3          	bgeu	a5,a4,5490 <kernmem+0x16>
  }
}
    5542:	0001                	nop
    5544:	0001                	nop
    5546:	70a2                	ld	ra,40(sp)
    5548:	7402                	ld	s0,32(sp)
    554a:	6145                	addi	sp,sp,48
    554c:	8082                	ret

000000000000554e <MAXVAplus>:

// user code should not be able to write to addresses above MAXVA.
void
MAXVAplus(char *s)
{
    554e:	7139                	addi	sp,sp,-64
    5550:	fc06                	sd	ra,56(sp)
    5552:	f822                	sd	s0,48(sp)
    5554:	0080                	addi	s0,sp,64
    5556:	fca43423          	sd	a0,-56(s0)
  volatile uint64 a = MAXVA;
    555a:	4785                	li	a5,1
    555c:	179a                	slli	a5,a5,0x26
    555e:	fef43023          	sd	a5,-32(s0)
  for( ; a != 0; a <<= 1){
    5562:	a045                	j	5602 <MAXVAplus+0xb4>
    int pid;
    pid = fork();
    5564:	00002097          	auipc	ra,0x2
    5568:	2e8080e7          	jalr	744(ra) # 784c <fork>
    556c:	87aa                	mv	a5,a0
    556e:	fef42623          	sw	a5,-20(s0)
    if(pid < 0){
    5572:	fec42783          	lw	a5,-20(s0)
    5576:	2781                	sext.w	a5,a5
    5578:	0207d163          	bgez	a5,559a <MAXVAplus+0x4c>
      printf("%s: fork failed\n", s);
    557c:	fc843583          	ld	a1,-56(s0)
    5580:	00003517          	auipc	a0,0x3
    5584:	f7050513          	addi	a0,a0,-144 # 84f0 <malloc+0x582>
    5588:	00002097          	auipc	ra,0x2
    558c:	7f4080e7          	jalr	2036(ra) # 7d7c <printf>
      exit(1);
    5590:	4505                	li	a0,1
    5592:	00002097          	auipc	ra,0x2
    5596:	2c2080e7          	jalr	706(ra) # 7854 <exit>
    }
    if(pid == 0){
    559a:	fec42783          	lw	a5,-20(s0)
    559e:	2781                	sext.w	a5,a5
    55a0:	eb95                	bnez	a5,55d4 <MAXVAplus+0x86>
      *(char*)a = 99;
    55a2:	fe043783          	ld	a5,-32(s0)
    55a6:	873e                	mv	a4,a5
    55a8:	06300793          	li	a5,99
    55ac:	00f70023          	sb	a5,0(a4) # 1200000 <freep+0x11ed4f8>
      printf("%s: oops wrote %x\n", s, a);
    55b0:	fe043783          	ld	a5,-32(s0)
    55b4:	863e                	mv	a2,a5
    55b6:	fc843583          	ld	a1,-56(s0)
    55ba:	00004517          	auipc	a0,0x4
    55be:	73e50513          	addi	a0,a0,1854 # 9cf8 <malloc+0x1d8a>
    55c2:	00002097          	auipc	ra,0x2
    55c6:	7ba080e7          	jalr	1978(ra) # 7d7c <printf>
      exit(1);
    55ca:	4505                	li	a0,1
    55cc:	00002097          	auipc	ra,0x2
    55d0:	288080e7          	jalr	648(ra) # 7854 <exit>
    }
    int xstatus;
    wait(&xstatus);
    55d4:	fdc40793          	addi	a5,s0,-36
    55d8:	853e                	mv	a0,a5
    55da:	00002097          	auipc	ra,0x2
    55de:	282080e7          	jalr	642(ra) # 785c <wait>
    if(xstatus != -1)  // did kernel kill child?
    55e2:	fdc42783          	lw	a5,-36(s0)
    55e6:	873e                	mv	a4,a5
    55e8:	57fd                	li	a5,-1
    55ea:	00f70763          	beq	a4,a5,55f8 <MAXVAplus+0xaa>
      exit(1);
    55ee:	4505                	li	a0,1
    55f0:	00002097          	auipc	ra,0x2
    55f4:	264080e7          	jalr	612(ra) # 7854 <exit>
  for( ; a != 0; a <<= 1){
    55f8:	fe043783          	ld	a5,-32(s0)
    55fc:	0786                	slli	a5,a5,0x1
    55fe:	fef43023          	sd	a5,-32(s0)
    5602:	fe043783          	ld	a5,-32(s0)
    5606:	ffb9                	bnez	a5,5564 <MAXVAplus+0x16>
  }
}
    5608:	0001                	nop
    560a:	0001                	nop
    560c:	70e2                	ld	ra,56(sp)
    560e:	7442                	ld	s0,48(sp)
    5610:	6121                	addi	sp,sp,64
    5612:	8082                	ret

0000000000005614 <sbrkfail>:

// if we run the system out of memory, does it clean up the last
// failed allocation?
void
sbrkfail(char *s)
{
    5614:	7119                	addi	sp,sp,-128
    5616:	fc86                	sd	ra,120(sp)
    5618:	f8a2                	sd	s0,112(sp)
    561a:	0100                	addi	s0,sp,128
    561c:	f8a43423          	sd	a0,-120(s0)
  char scratch;
  char *c, *a;
  int pids[10];
  int pid;

  if(pipe(fds) != 0){
    5620:	fc040793          	addi	a5,s0,-64
    5624:	853e                	mv	a0,a5
    5626:	00002097          	auipc	ra,0x2
    562a:	23e080e7          	jalr	574(ra) # 7864 <pipe>
    562e:	87aa                	mv	a5,a0
    5630:	c385                	beqz	a5,5650 <sbrkfail+0x3c>
    printf("%s: pipe() failed\n", s);
    5632:	f8843583          	ld	a1,-120(s0)
    5636:	00003517          	auipc	a0,0x3
    563a:	35250513          	addi	a0,a0,850 # 8988 <malloc+0xa1a>
    563e:	00002097          	auipc	ra,0x2
    5642:	73e080e7          	jalr	1854(ra) # 7d7c <printf>
    exit(1);
    5646:	4505                	li	a0,1
    5648:	00002097          	auipc	ra,0x2
    564c:	20c080e7          	jalr	524(ra) # 7854 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5650:	fe042623          	sw	zero,-20(s0)
    5654:	a075                	j	5700 <sbrkfail+0xec>
    if((pids[i] = fork()) == 0){
    5656:	00002097          	auipc	ra,0x2
    565a:	1f6080e7          	jalr	502(ra) # 784c <fork>
    565e:	87aa                	mv	a5,a0
    5660:	873e                	mv	a4,a5
    5662:	fec42783          	lw	a5,-20(s0)
    5666:	078a                	slli	a5,a5,0x2
    5668:	17c1                	addi	a5,a5,-16
    566a:	97a2                	add	a5,a5,s0
    566c:	fae7a023          	sw	a4,-96(a5)
    5670:	fec42783          	lw	a5,-20(s0)
    5674:	078a                	slli	a5,a5,0x2
    5676:	17c1                	addi	a5,a5,-16
    5678:	97a2                	add	a5,a5,s0
    567a:	fa07a783          	lw	a5,-96(a5)
    567e:	e7b1                	bnez	a5,56ca <sbrkfail+0xb6>
      // allocate a lot of memory
      sbrk(BIG - (uint64)sbrk(0));
    5680:	4501                	li	a0,0
    5682:	00002097          	auipc	ra,0x2
    5686:	25a080e7          	jalr	602(ra) # 78dc <sbrk>
    568a:	87aa                	mv	a5,a0
    568c:	2781                	sext.w	a5,a5
    568e:	06400737          	lui	a4,0x6400
    5692:	40f707bb          	subw	a5,a4,a5
    5696:	2781                	sext.w	a5,a5
    5698:	2781                	sext.w	a5,a5
    569a:	853e                	mv	a0,a5
    569c:	00002097          	auipc	ra,0x2
    56a0:	240080e7          	jalr	576(ra) # 78dc <sbrk>
      write(fds[1], "x", 1);
    56a4:	fc442783          	lw	a5,-60(s0)
    56a8:	4605                	li	a2,1
    56aa:	00003597          	auipc	a1,0x3
    56ae:	b1658593          	addi	a1,a1,-1258 # 81c0 <malloc+0x252>
    56b2:	853e                	mv	a0,a5
    56b4:	00002097          	auipc	ra,0x2
    56b8:	1c0080e7          	jalr	448(ra) # 7874 <write>
      // sit around until killed
      for(;;) sleep(1000);
    56bc:	3e800513          	li	a0,1000
    56c0:	00002097          	auipc	ra,0x2
    56c4:	224080e7          	jalr	548(ra) # 78e4 <sleep>
    56c8:	bfd5                	j	56bc <sbrkfail+0xa8>
    }
    if(pids[i] != -1)
    56ca:	fec42783          	lw	a5,-20(s0)
    56ce:	078a                	slli	a5,a5,0x2
    56d0:	17c1                	addi	a5,a5,-16
    56d2:	97a2                	add	a5,a5,s0
    56d4:	fa07a783          	lw	a5,-96(a5)
    56d8:	873e                	mv	a4,a5
    56da:	57fd                	li	a5,-1
    56dc:	00f70d63          	beq	a4,a5,56f6 <sbrkfail+0xe2>
      read(fds[0], &scratch, 1);
    56e0:	fc042783          	lw	a5,-64(s0)
    56e4:	fbf40713          	addi	a4,s0,-65
    56e8:	4605                	li	a2,1
    56ea:	85ba                	mv	a1,a4
    56ec:	853e                	mv	a0,a5
    56ee:	00002097          	auipc	ra,0x2
    56f2:	17e080e7          	jalr	382(ra) # 786c <read>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    56f6:	fec42783          	lw	a5,-20(s0)
    56fa:	2785                	addiw	a5,a5,1
    56fc:	fef42623          	sw	a5,-20(s0)
    5700:	fec42783          	lw	a5,-20(s0)
    5704:	873e                	mv	a4,a5
    5706:	47a5                	li	a5,9
    5708:	f4e7f7e3          	bgeu	a5,a4,5656 <sbrkfail+0x42>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    570c:	6505                	lui	a0,0x1
    570e:	00002097          	auipc	ra,0x2
    5712:	1ce080e7          	jalr	462(ra) # 78dc <sbrk>
    5716:	fea43023          	sd	a0,-32(s0)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    571a:	fe042623          	sw	zero,-20(s0)
    571e:	a0a1                	j	5766 <sbrkfail+0x152>
    if(pids[i] == -1)
    5720:	fec42783          	lw	a5,-20(s0)
    5724:	078a                	slli	a5,a5,0x2
    5726:	17c1                	addi	a5,a5,-16
    5728:	97a2                	add	a5,a5,s0
    572a:	fa07a783          	lw	a5,-96(a5)
    572e:	873e                	mv	a4,a5
    5730:	57fd                	li	a5,-1
    5732:	02f70463          	beq	a4,a5,575a <sbrkfail+0x146>
      continue;
    kill(pids[i]);
    5736:	fec42783          	lw	a5,-20(s0)
    573a:	078a                	slli	a5,a5,0x2
    573c:	17c1                	addi	a5,a5,-16
    573e:	97a2                	add	a5,a5,s0
    5740:	fa07a783          	lw	a5,-96(a5)
    5744:	853e                	mv	a0,a5
    5746:	00002097          	auipc	ra,0x2
    574a:	13e080e7          	jalr	318(ra) # 7884 <kill>
    wait(0);
    574e:	4501                	li	a0,0
    5750:	00002097          	auipc	ra,0x2
    5754:	10c080e7          	jalr	268(ra) # 785c <wait>
    5758:	a011                	j	575c <sbrkfail+0x148>
      continue;
    575a:	0001                	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    575c:	fec42783          	lw	a5,-20(s0)
    5760:	2785                	addiw	a5,a5,1
    5762:	fef42623          	sw	a5,-20(s0)
    5766:	fec42783          	lw	a5,-20(s0)
    576a:	873e                	mv	a4,a5
    576c:	47a5                	li	a5,9
    576e:	fae7f9e3          	bgeu	a5,a4,5720 <sbrkfail+0x10c>
  }
  if(c == (char*)0xffffffffffffffffL){
    5772:	fe043703          	ld	a4,-32(s0)
    5776:	57fd                	li	a5,-1
    5778:	02f71163          	bne	a4,a5,579a <sbrkfail+0x186>
    printf("%s: failed sbrk leaked memory\n", s);
    577c:	f8843583          	ld	a1,-120(s0)
    5780:	00004517          	auipc	a0,0x4
    5784:	59050513          	addi	a0,a0,1424 # 9d10 <malloc+0x1da2>
    5788:	00002097          	auipc	ra,0x2
    578c:	5f4080e7          	jalr	1524(ra) # 7d7c <printf>
    exit(1);
    5790:	4505                	li	a0,1
    5792:	00002097          	auipc	ra,0x2
    5796:	0c2080e7          	jalr	194(ra) # 7854 <exit>
  }

  // test running fork with the above allocated page
  pid = fork();
    579a:	00002097          	auipc	ra,0x2
    579e:	0b2080e7          	jalr	178(ra) # 784c <fork>
    57a2:	87aa                	mv	a5,a0
    57a4:	fcf42e23          	sw	a5,-36(s0)
  if(pid < 0){
    57a8:	fdc42783          	lw	a5,-36(s0)
    57ac:	2781                	sext.w	a5,a5
    57ae:	0207d163          	bgez	a5,57d0 <sbrkfail+0x1bc>
    printf("%s: fork failed\n", s);
    57b2:	f8843583          	ld	a1,-120(s0)
    57b6:	00003517          	auipc	a0,0x3
    57ba:	d3a50513          	addi	a0,a0,-710 # 84f0 <malloc+0x582>
    57be:	00002097          	auipc	ra,0x2
    57c2:	5be080e7          	jalr	1470(ra) # 7d7c <printf>
    exit(1);
    57c6:	4505                	li	a0,1
    57c8:	00002097          	auipc	ra,0x2
    57cc:	08c080e7          	jalr	140(ra) # 7854 <exit>
  }
  if(pid == 0){
    57d0:	fdc42783          	lw	a5,-36(s0)
    57d4:	2781                	sext.w	a5,a5
    57d6:	e3c9                	bnez	a5,5858 <sbrkfail+0x244>
    // allocate a lot of memory.
    // this should produce a page fault,
    // and thus not complete.
    a = sbrk(0);
    57d8:	4501                	li	a0,0
    57da:	00002097          	auipc	ra,0x2
    57de:	102080e7          	jalr	258(ra) # 78dc <sbrk>
    57e2:	fca43823          	sd	a0,-48(s0)
    sbrk(10*BIG);
    57e6:	3e800537          	lui	a0,0x3e800
    57ea:	00002097          	auipc	ra,0x2
    57ee:	0f2080e7          	jalr	242(ra) # 78dc <sbrk>
    int n = 0;
    57f2:	fe042423          	sw	zero,-24(s0)
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    57f6:	fe042623          	sw	zero,-20(s0)
    57fa:	a02d                	j	5824 <sbrkfail+0x210>
      n += *(a+i);
    57fc:	fec42783          	lw	a5,-20(s0)
    5800:	fd043703          	ld	a4,-48(s0)
    5804:	97ba                	add	a5,a5,a4
    5806:	0007c783          	lbu	a5,0(a5)
    580a:	2781                	sext.w	a5,a5
    580c:	fe842703          	lw	a4,-24(s0)
    5810:	9fb9                	addw	a5,a5,a4
    5812:	fef42423          	sw	a5,-24(s0)
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    5816:	fec42783          	lw	a5,-20(s0)
    581a:	873e                	mv	a4,a5
    581c:	6785                	lui	a5,0x1
    581e:	9fb9                	addw	a5,a5,a4
    5820:	fef42623          	sw	a5,-20(s0)
    5824:	fec42783          	lw	a5,-20(s0)
    5828:	0007871b          	sext.w	a4,a5
    582c:	3e8007b7          	lui	a5,0x3e800
    5830:	fcf746e3          	blt	a4,a5,57fc <sbrkfail+0x1e8>
    }
    // print n so the compiler doesn't optimize away
    // the for loop.
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    5834:	fe842783          	lw	a5,-24(s0)
    5838:	863e                	mv	a2,a5
    583a:	f8843583          	ld	a1,-120(s0)
    583e:	00004517          	auipc	a0,0x4
    5842:	4f250513          	addi	a0,a0,1266 # 9d30 <malloc+0x1dc2>
    5846:	00002097          	auipc	ra,0x2
    584a:	536080e7          	jalr	1334(ra) # 7d7c <printf>
    exit(1);
    584e:	4505                	li	a0,1
    5850:	00002097          	auipc	ra,0x2
    5854:	004080e7          	jalr	4(ra) # 7854 <exit>
  }
  wait(&xstatus);
    5858:	fcc40793          	addi	a5,s0,-52
    585c:	853e                	mv	a0,a5
    585e:	00002097          	auipc	ra,0x2
    5862:	ffe080e7          	jalr	-2(ra) # 785c <wait>
  if(xstatus != -1 && xstatus != 2)
    5866:	fcc42783          	lw	a5,-52(s0)
    586a:	873e                	mv	a4,a5
    586c:	57fd                	li	a5,-1
    586e:	00f70d63          	beq	a4,a5,5888 <sbrkfail+0x274>
    5872:	fcc42783          	lw	a5,-52(s0)
    5876:	873e                	mv	a4,a5
    5878:	4789                	li	a5,2
    587a:	00f70763          	beq	a4,a5,5888 <sbrkfail+0x274>
    exit(1);
    587e:	4505                	li	a0,1
    5880:	00002097          	auipc	ra,0x2
    5884:	fd4080e7          	jalr	-44(ra) # 7854 <exit>
}
    5888:	0001                	nop
    588a:	70e6                	ld	ra,120(sp)
    588c:	7446                	ld	s0,112(sp)
    588e:	6109                	addi	sp,sp,128
    5890:	8082                	ret

0000000000005892 <sbrkarg>:


// test reads/writes from/to allocated memory
void
sbrkarg(char *s)
{
    5892:	7179                	addi	sp,sp,-48
    5894:	f406                	sd	ra,40(sp)
    5896:	f022                	sd	s0,32(sp)
    5898:	1800                	addi	s0,sp,48
    589a:	fca43c23          	sd	a0,-40(s0)
  char *a;
  int fd, n;

  a = sbrk(PGSIZE);
    589e:	6505                	lui	a0,0x1
    58a0:	00002097          	auipc	ra,0x2
    58a4:	03c080e7          	jalr	60(ra) # 78dc <sbrk>
    58a8:	fea43423          	sd	a0,-24(s0)
  fd = open("sbrk", O_CREATE|O_WRONLY);
    58ac:	20100593          	li	a1,513
    58b0:	00004517          	auipc	a0,0x4
    58b4:	4b050513          	addi	a0,a0,1200 # 9d60 <malloc+0x1df2>
    58b8:	00002097          	auipc	ra,0x2
    58bc:	fdc080e7          	jalr	-36(ra) # 7894 <open>
    58c0:	87aa                	mv	a5,a0
    58c2:	fef42223          	sw	a5,-28(s0)
  unlink("sbrk");
    58c6:	00004517          	auipc	a0,0x4
    58ca:	49a50513          	addi	a0,a0,1178 # 9d60 <malloc+0x1df2>
    58ce:	00002097          	auipc	ra,0x2
    58d2:	fd6080e7          	jalr	-42(ra) # 78a4 <unlink>
  if(fd < 0)  {
    58d6:	fe442783          	lw	a5,-28(s0)
    58da:	2781                	sext.w	a5,a5
    58dc:	0207d163          	bgez	a5,58fe <sbrkarg+0x6c>
    printf("%s: open sbrk failed\n", s);
    58e0:	fd843583          	ld	a1,-40(s0)
    58e4:	00004517          	auipc	a0,0x4
    58e8:	48450513          	addi	a0,a0,1156 # 9d68 <malloc+0x1dfa>
    58ec:	00002097          	auipc	ra,0x2
    58f0:	490080e7          	jalr	1168(ra) # 7d7c <printf>
    exit(1);
    58f4:	4505                	li	a0,1
    58f6:	00002097          	auipc	ra,0x2
    58fa:	f5e080e7          	jalr	-162(ra) # 7854 <exit>
  }
  if ((n = write(fd, a, PGSIZE)) < 0) {
    58fe:	fe442783          	lw	a5,-28(s0)
    5902:	6605                	lui	a2,0x1
    5904:	fe843583          	ld	a1,-24(s0)
    5908:	853e                	mv	a0,a5
    590a:	00002097          	auipc	ra,0x2
    590e:	f6a080e7          	jalr	-150(ra) # 7874 <write>
    5912:	87aa                	mv	a5,a0
    5914:	fef42023          	sw	a5,-32(s0)
    5918:	fe042783          	lw	a5,-32(s0)
    591c:	2781                	sext.w	a5,a5
    591e:	0207d163          	bgez	a5,5940 <sbrkarg+0xae>
    printf("%s: write sbrk failed\n", s);
    5922:	fd843583          	ld	a1,-40(s0)
    5926:	00004517          	auipc	a0,0x4
    592a:	45a50513          	addi	a0,a0,1114 # 9d80 <malloc+0x1e12>
    592e:	00002097          	auipc	ra,0x2
    5932:	44e080e7          	jalr	1102(ra) # 7d7c <printf>
    exit(1);
    5936:	4505                	li	a0,1
    5938:	00002097          	auipc	ra,0x2
    593c:	f1c080e7          	jalr	-228(ra) # 7854 <exit>
  }
  close(fd);
    5940:	fe442783          	lw	a5,-28(s0)
    5944:	853e                	mv	a0,a5
    5946:	00002097          	auipc	ra,0x2
    594a:	f36080e7          	jalr	-202(ra) # 787c <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    594e:	6505                	lui	a0,0x1
    5950:	00002097          	auipc	ra,0x2
    5954:	f8c080e7          	jalr	-116(ra) # 78dc <sbrk>
    5958:	fea43423          	sd	a0,-24(s0)
  if(pipe((int *) a) != 0){
    595c:	fe843503          	ld	a0,-24(s0)
    5960:	00002097          	auipc	ra,0x2
    5964:	f04080e7          	jalr	-252(ra) # 7864 <pipe>
    5968:	87aa                	mv	a5,a0
    596a:	c385                	beqz	a5,598a <sbrkarg+0xf8>
    printf("%s: pipe() failed\n", s);
    596c:	fd843583          	ld	a1,-40(s0)
    5970:	00003517          	auipc	a0,0x3
    5974:	01850513          	addi	a0,a0,24 # 8988 <malloc+0xa1a>
    5978:	00002097          	auipc	ra,0x2
    597c:	404080e7          	jalr	1028(ra) # 7d7c <printf>
    exit(1);
    5980:	4505                	li	a0,1
    5982:	00002097          	auipc	ra,0x2
    5986:	ed2080e7          	jalr	-302(ra) # 7854 <exit>
  }
}
    598a:	0001                	nop
    598c:	70a2                	ld	ra,40(sp)
    598e:	7402                	ld	s0,32(sp)
    5990:	6145                	addi	sp,sp,48
    5992:	8082                	ret

0000000000005994 <validatetest>:

void
validatetest(char *s)
{
    5994:	7179                	addi	sp,sp,-48
    5996:	f406                	sd	ra,40(sp)
    5998:	f022                	sd	s0,32(sp)
    599a:	1800                	addi	s0,sp,48
    599c:	fca43c23          	sd	a0,-40(s0)
  int hi;
  uint64 p;

  hi = 1100*1024;
    59a0:	001137b7          	lui	a5,0x113
    59a4:	fef42223          	sw	a5,-28(s0)
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    59a8:	fe043423          	sd	zero,-24(s0)
    59ac:	a0b1                	j	59f8 <validatetest+0x64>
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    59ae:	fe843783          	ld	a5,-24(s0)
    59b2:	85be                	mv	a1,a5
    59b4:	00004517          	auipc	a0,0x4
    59b8:	3e450513          	addi	a0,a0,996 # 9d98 <malloc+0x1e2a>
    59bc:	00002097          	auipc	ra,0x2
    59c0:	ef8080e7          	jalr	-264(ra) # 78b4 <link>
    59c4:	87aa                	mv	a5,a0
    59c6:	873e                	mv	a4,a5
    59c8:	57fd                	li	a5,-1
    59ca:	02f70163          	beq	a4,a5,59ec <validatetest+0x58>
      printf("%s: link should not succeed\n", s);
    59ce:	fd843583          	ld	a1,-40(s0)
    59d2:	00004517          	auipc	a0,0x4
    59d6:	3d650513          	addi	a0,a0,982 # 9da8 <malloc+0x1e3a>
    59da:	00002097          	auipc	ra,0x2
    59de:	3a2080e7          	jalr	930(ra) # 7d7c <printf>
      exit(1);
    59e2:	4505                	li	a0,1
    59e4:	00002097          	auipc	ra,0x2
    59e8:	e70080e7          	jalr	-400(ra) # 7854 <exit>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    59ec:	fe843703          	ld	a4,-24(s0)
    59f0:	6785                	lui	a5,0x1
    59f2:	97ba                	add	a5,a5,a4
    59f4:	fef43423          	sd	a5,-24(s0)
    59f8:	fe442783          	lw	a5,-28(s0)
    59fc:	1782                	slli	a5,a5,0x20
    59fe:	9381                	srli	a5,a5,0x20
    5a00:	fe843703          	ld	a4,-24(s0)
    5a04:	fae7f5e3          	bgeu	a5,a4,59ae <validatetest+0x1a>
    }
  }
}
    5a08:	0001                	nop
    5a0a:	0001                	nop
    5a0c:	70a2                	ld	ra,40(sp)
    5a0e:	7402                	ld	s0,32(sp)
    5a10:	6145                	addi	sp,sp,48
    5a12:	8082                	ret

0000000000005a14 <bsstest>:

// does uninitialized data start out zero?
char uninit[10000];
void
bsstest(char *s)
{
    5a14:	7179                	addi	sp,sp,-48
    5a16:	f406                	sd	ra,40(sp)
    5a18:	f022                	sd	s0,32(sp)
    5a1a:	1800                	addi	s0,sp,48
    5a1c:	fca43c23          	sd	a0,-40(s0)
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    5a20:	fe042623          	sw	zero,-20(s0)
    5a24:	a83d                	j	5a62 <bsstest+0x4e>
    if(uninit[i] != '\0'){
    5a26:	0000a717          	auipc	a4,0xa
    5a2a:	8ba70713          	addi	a4,a4,-1862 # f2e0 <uninit>
    5a2e:	fec42783          	lw	a5,-20(s0)
    5a32:	97ba                	add	a5,a5,a4
    5a34:	0007c783          	lbu	a5,0(a5) # 1000 <truncate3+0x1b2>
    5a38:	c385                	beqz	a5,5a58 <bsstest+0x44>
      printf("%s: bss test failed\n", s);
    5a3a:	fd843583          	ld	a1,-40(s0)
    5a3e:	00004517          	auipc	a0,0x4
    5a42:	38a50513          	addi	a0,a0,906 # 9dc8 <malloc+0x1e5a>
    5a46:	00002097          	auipc	ra,0x2
    5a4a:	336080e7          	jalr	822(ra) # 7d7c <printf>
      exit(1);
    5a4e:	4505                	li	a0,1
    5a50:	00002097          	auipc	ra,0x2
    5a54:	e04080e7          	jalr	-508(ra) # 7854 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    5a58:	fec42783          	lw	a5,-20(s0)
    5a5c:	2785                	addiw	a5,a5,1
    5a5e:	fef42623          	sw	a5,-20(s0)
    5a62:	fec42783          	lw	a5,-20(s0)
    5a66:	873e                	mv	a4,a5
    5a68:	6789                	lui	a5,0x2
    5a6a:	70f78793          	addi	a5,a5,1807 # 270f <reparent2+0x79>
    5a6e:	fae7fce3          	bgeu	a5,a4,5a26 <bsstest+0x12>
    }
  }
}
    5a72:	0001                	nop
    5a74:	0001                	nop
    5a76:	70a2                	ld	ra,40(sp)
    5a78:	7402                	ld	s0,32(sp)
    5a7a:	6145                	addi	sp,sp,48
    5a7c:	8082                	ret

0000000000005a7e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(char *s)
{
    5a7e:	7179                	addi	sp,sp,-48
    5a80:	f406                	sd	ra,40(sp)
    5a82:	f022                	sd	s0,32(sp)
    5a84:	1800                	addi	s0,sp,48
    5a86:	fca43c23          	sd	a0,-40(s0)
  int pid, fd, xstatus;

  unlink("bigarg-ok");
    5a8a:	00004517          	auipc	a0,0x4
    5a8e:	35650513          	addi	a0,a0,854 # 9de0 <malloc+0x1e72>
    5a92:	00002097          	auipc	ra,0x2
    5a96:	e12080e7          	jalr	-494(ra) # 78a4 <unlink>
  pid = fork();
    5a9a:	00002097          	auipc	ra,0x2
    5a9e:	db2080e7          	jalr	-590(ra) # 784c <fork>
    5aa2:	87aa                	mv	a5,a0
    5aa4:	fef42423          	sw	a5,-24(s0)
  if(pid == 0){
    5aa8:	fe842783          	lw	a5,-24(s0)
    5aac:	2781                	sext.w	a5,a5
    5aae:	ebc1                	bnez	a5,5b3e <bigargtest+0xc0>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    5ab0:	fe042623          	sw	zero,-20(s0)
    5ab4:	a01d                	j	5ada <bigargtest+0x5c>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    5ab6:	0000d717          	auipc	a4,0xd
    5aba:	f4270713          	addi	a4,a4,-190 # 129f8 <args.1>
    5abe:	fec42783          	lw	a5,-20(s0)
    5ac2:	078e                	slli	a5,a5,0x3
    5ac4:	97ba                	add	a5,a5,a4
    5ac6:	00004717          	auipc	a4,0x4
    5aca:	32a70713          	addi	a4,a4,810 # 9df0 <malloc+0x1e82>
    5ace:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    5ad0:	fec42783          	lw	a5,-20(s0)
    5ad4:	2785                	addiw	a5,a5,1
    5ad6:	fef42623          	sw	a5,-20(s0)
    5ada:	fec42783          	lw	a5,-20(s0)
    5ade:	0007871b          	sext.w	a4,a5
    5ae2:	47f9                	li	a5,30
    5ae4:	fce7d9e3          	bge	a5,a4,5ab6 <bigargtest+0x38>
    args[MAXARG-1] = 0;
    5ae8:	0000d797          	auipc	a5,0xd
    5aec:	f1078793          	addi	a5,a5,-240 # 129f8 <args.1>
    5af0:	0e07bc23          	sd	zero,248(a5)
    exec("echo", args);
    5af4:	0000d597          	auipc	a1,0xd
    5af8:	f0458593          	addi	a1,a1,-252 # 129f8 <args.1>
    5afc:	00002517          	auipc	a0,0x2
    5b00:	7d450513          	addi	a0,a0,2004 # 82d0 <malloc+0x362>
    5b04:	00002097          	auipc	ra,0x2
    5b08:	d88080e7          	jalr	-632(ra) # 788c <exec>
    fd = open("bigarg-ok", O_CREATE);
    5b0c:	20000593          	li	a1,512
    5b10:	00004517          	auipc	a0,0x4
    5b14:	2d050513          	addi	a0,a0,720 # 9de0 <malloc+0x1e72>
    5b18:	00002097          	auipc	ra,0x2
    5b1c:	d7c080e7          	jalr	-644(ra) # 7894 <open>
    5b20:	87aa                	mv	a5,a0
    5b22:	fef42223          	sw	a5,-28(s0)
    close(fd);
    5b26:	fe442783          	lw	a5,-28(s0)
    5b2a:	853e                	mv	a0,a5
    5b2c:	00002097          	auipc	ra,0x2
    5b30:	d50080e7          	jalr	-688(ra) # 787c <close>
    exit(0);
    5b34:	4501                	li	a0,0
    5b36:	00002097          	auipc	ra,0x2
    5b3a:	d1e080e7          	jalr	-738(ra) # 7854 <exit>
  } else if(pid < 0){
    5b3e:	fe842783          	lw	a5,-24(s0)
    5b42:	2781                	sext.w	a5,a5
    5b44:	0207d163          	bgez	a5,5b66 <bigargtest+0xe8>
    printf("%s: bigargtest: fork failed\n", s);
    5b48:	fd843583          	ld	a1,-40(s0)
    5b4c:	00004517          	auipc	a0,0x4
    5b50:	38450513          	addi	a0,a0,900 # 9ed0 <malloc+0x1f62>
    5b54:	00002097          	auipc	ra,0x2
    5b58:	228080e7          	jalr	552(ra) # 7d7c <printf>
    exit(1);
    5b5c:	4505                	li	a0,1
    5b5e:	00002097          	auipc	ra,0x2
    5b62:	cf6080e7          	jalr	-778(ra) # 7854 <exit>
  }

  wait(&xstatus);
    5b66:	fe040793          	addi	a5,s0,-32
    5b6a:	853e                	mv	a0,a5
    5b6c:	00002097          	auipc	ra,0x2
    5b70:	cf0080e7          	jalr	-784(ra) # 785c <wait>
  if(xstatus != 0)
    5b74:	fe042783          	lw	a5,-32(s0)
    5b78:	cb81                	beqz	a5,5b88 <bigargtest+0x10a>
    exit(xstatus);
    5b7a:	fe042783          	lw	a5,-32(s0)
    5b7e:	853e                	mv	a0,a5
    5b80:	00002097          	auipc	ra,0x2
    5b84:	cd4080e7          	jalr	-812(ra) # 7854 <exit>
  fd = open("bigarg-ok", 0);
    5b88:	4581                	li	a1,0
    5b8a:	00004517          	auipc	a0,0x4
    5b8e:	25650513          	addi	a0,a0,598 # 9de0 <malloc+0x1e72>
    5b92:	00002097          	auipc	ra,0x2
    5b96:	d02080e7          	jalr	-766(ra) # 7894 <open>
    5b9a:	87aa                	mv	a5,a0
    5b9c:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    5ba0:	fe442783          	lw	a5,-28(s0)
    5ba4:	2781                	sext.w	a5,a5
    5ba6:	0207d163          	bgez	a5,5bc8 <bigargtest+0x14a>
    printf("%s: bigarg test failed!\n", s);
    5baa:	fd843583          	ld	a1,-40(s0)
    5bae:	00004517          	auipc	a0,0x4
    5bb2:	34250513          	addi	a0,a0,834 # 9ef0 <malloc+0x1f82>
    5bb6:	00002097          	auipc	ra,0x2
    5bba:	1c6080e7          	jalr	454(ra) # 7d7c <printf>
    exit(1);
    5bbe:	4505                	li	a0,1
    5bc0:	00002097          	auipc	ra,0x2
    5bc4:	c94080e7          	jalr	-876(ra) # 7854 <exit>
  }
  close(fd);
    5bc8:	fe442783          	lw	a5,-28(s0)
    5bcc:	853e                	mv	a0,a5
    5bce:	00002097          	auipc	ra,0x2
    5bd2:	cae080e7          	jalr	-850(ra) # 787c <close>
}
    5bd6:	0001                	nop
    5bd8:	70a2                	ld	ra,40(sp)
    5bda:	7402                	ld	s0,32(sp)
    5bdc:	6145                	addi	sp,sp,48
    5bde:	8082                	ret

0000000000005be0 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    5be0:	7159                	addi	sp,sp,-112
    5be2:	f486                	sd	ra,104(sp)
    5be4:	f0a2                	sd	s0,96(sp)
    5be6:	1880                	addi	s0,sp,112
  int nfiles;
  int fsblocks = 0;
    5be8:	fe042423          	sw	zero,-24(s0)

  printf("fsfull test\n");
    5bec:	00004517          	auipc	a0,0x4
    5bf0:	32450513          	addi	a0,a0,804 # 9f10 <malloc+0x1fa2>
    5bf4:	00002097          	auipc	ra,0x2
    5bf8:	188080e7          	jalr	392(ra) # 7d7c <printf>

  for(nfiles = 0; ; nfiles++){
    5bfc:	fe042623          	sw	zero,-20(s0)
    char name[64];
    name[0] = 'f';
    5c00:	06600793          	li	a5,102
    5c04:	f8f40c23          	sb	a5,-104(s0)
    name[1] = '0' + nfiles / 1000;
    5c08:	fec42783          	lw	a5,-20(s0)
    5c0c:	873e                	mv	a4,a5
    5c0e:	3e800793          	li	a5,1000
    5c12:	02f747bb          	divw	a5,a4,a5
    5c16:	2781                	sext.w	a5,a5
    5c18:	0ff7f793          	zext.b	a5,a5
    5c1c:	0307879b          	addiw	a5,a5,48
    5c20:	0ff7f793          	zext.b	a5,a5
    5c24:	f8f40ca3          	sb	a5,-103(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5c28:	fec42783          	lw	a5,-20(s0)
    5c2c:	873e                	mv	a4,a5
    5c2e:	3e800793          	li	a5,1000
    5c32:	02f767bb          	remw	a5,a4,a5
    5c36:	2781                	sext.w	a5,a5
    5c38:	873e                	mv	a4,a5
    5c3a:	06400793          	li	a5,100
    5c3e:	02f747bb          	divw	a5,a4,a5
    5c42:	2781                	sext.w	a5,a5
    5c44:	0ff7f793          	zext.b	a5,a5
    5c48:	0307879b          	addiw	a5,a5,48
    5c4c:	0ff7f793          	zext.b	a5,a5
    5c50:	f8f40d23          	sb	a5,-102(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5c54:	fec42783          	lw	a5,-20(s0)
    5c58:	873e                	mv	a4,a5
    5c5a:	06400793          	li	a5,100
    5c5e:	02f767bb          	remw	a5,a4,a5
    5c62:	2781                	sext.w	a5,a5
    5c64:	873e                	mv	a4,a5
    5c66:	47a9                	li	a5,10
    5c68:	02f747bb          	divw	a5,a4,a5
    5c6c:	2781                	sext.w	a5,a5
    5c6e:	0ff7f793          	zext.b	a5,a5
    5c72:	0307879b          	addiw	a5,a5,48
    5c76:	0ff7f793          	zext.b	a5,a5
    5c7a:	f8f40da3          	sb	a5,-101(s0)
    name[4] = '0' + (nfiles % 10);
    5c7e:	fec42783          	lw	a5,-20(s0)
    5c82:	873e                	mv	a4,a5
    5c84:	47a9                	li	a5,10
    5c86:	02f767bb          	remw	a5,a4,a5
    5c8a:	2781                	sext.w	a5,a5
    5c8c:	0ff7f793          	zext.b	a5,a5
    5c90:	0307879b          	addiw	a5,a5,48
    5c94:	0ff7f793          	zext.b	a5,a5
    5c98:	f8f40e23          	sb	a5,-100(s0)
    name[5] = '\0';
    5c9c:	f8040ea3          	sb	zero,-99(s0)
    printf("writing %s\n", name);
    5ca0:	f9840793          	addi	a5,s0,-104
    5ca4:	85be                	mv	a1,a5
    5ca6:	00004517          	auipc	a0,0x4
    5caa:	27a50513          	addi	a0,a0,634 # 9f20 <malloc+0x1fb2>
    5cae:	00002097          	auipc	ra,0x2
    5cb2:	0ce080e7          	jalr	206(ra) # 7d7c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5cb6:	f9840793          	addi	a5,s0,-104
    5cba:	20200593          	li	a1,514
    5cbe:	853e                	mv	a0,a5
    5cc0:	00002097          	auipc	ra,0x2
    5cc4:	bd4080e7          	jalr	-1068(ra) # 7894 <open>
    5cc8:	87aa                	mv	a5,a0
    5cca:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    5cce:	fe042783          	lw	a5,-32(s0)
    5cd2:	2781                	sext.w	a5,a5
    5cd4:	0007de63          	bgez	a5,5cf0 <fsfull+0x110>
      printf("open %s failed\n", name);
    5cd8:	f9840793          	addi	a5,s0,-104
    5cdc:	85be                	mv	a1,a5
    5cde:	00004517          	auipc	a0,0x4
    5ce2:	25250513          	addi	a0,a0,594 # 9f30 <malloc+0x1fc2>
    5ce6:	00002097          	auipc	ra,0x2
    5cea:	096080e7          	jalr	150(ra) # 7d7c <printf>
      break;
    5cee:	a079                	j	5d7c <fsfull+0x19c>
    }
    int total = 0;
    5cf0:	fe042223          	sw	zero,-28(s0)
    while(1){
      int cc = write(fd, buf, BSIZE);
    5cf4:	fe042783          	lw	a5,-32(s0)
    5cf8:	40000613          	li	a2,1024
    5cfc:	00006597          	auipc	a1,0x6
    5d00:	5e458593          	addi	a1,a1,1508 # c2e0 <buf>
    5d04:	853e                	mv	a0,a5
    5d06:	00002097          	auipc	ra,0x2
    5d0a:	b6e080e7          	jalr	-1170(ra) # 7874 <write>
    5d0e:	87aa                	mv	a5,a0
    5d10:	fcf42e23          	sw	a5,-36(s0)
      if(cc < BSIZE)
    5d14:	fdc42783          	lw	a5,-36(s0)
    5d18:	0007871b          	sext.w	a4,a5
    5d1c:	3ff00793          	li	a5,1023
    5d20:	02e7d063          	bge	a5,a4,5d40 <fsfull+0x160>
        break;
      total += cc;
    5d24:	fe442783          	lw	a5,-28(s0)
    5d28:	873e                	mv	a4,a5
    5d2a:	fdc42783          	lw	a5,-36(s0)
    5d2e:	9fb9                	addw	a5,a5,a4
    5d30:	fef42223          	sw	a5,-28(s0)
      fsblocks++;
    5d34:	fe842783          	lw	a5,-24(s0)
    5d38:	2785                	addiw	a5,a5,1
    5d3a:	fef42423          	sw	a5,-24(s0)
    while(1){
    5d3e:	bf5d                	j	5cf4 <fsfull+0x114>
        break;
    5d40:	0001                	nop
    }
    printf("wrote %d bytes\n", total);
    5d42:	fe442783          	lw	a5,-28(s0)
    5d46:	85be                	mv	a1,a5
    5d48:	00004517          	auipc	a0,0x4
    5d4c:	1f850513          	addi	a0,a0,504 # 9f40 <malloc+0x1fd2>
    5d50:	00002097          	auipc	ra,0x2
    5d54:	02c080e7          	jalr	44(ra) # 7d7c <printf>
    close(fd);
    5d58:	fe042783          	lw	a5,-32(s0)
    5d5c:	853e                	mv	a0,a5
    5d5e:	00002097          	auipc	ra,0x2
    5d62:	b1e080e7          	jalr	-1250(ra) # 787c <close>
    if(total == 0)
    5d66:	fe442783          	lw	a5,-28(s0)
    5d6a:	2781                	sext.w	a5,a5
    5d6c:	c799                	beqz	a5,5d7a <fsfull+0x19a>
  for(nfiles = 0; ; nfiles++){
    5d6e:	fec42783          	lw	a5,-20(s0)
    5d72:	2785                	addiw	a5,a5,1
    5d74:	fef42623          	sw	a5,-20(s0)
    5d78:	b561                	j	5c00 <fsfull+0x20>
      break;
    5d7a:	0001                	nop
  }

  while(nfiles >= 0){
    5d7c:	a86d                	j	5e36 <fsfull+0x256>
    char name[64];
    name[0] = 'f';
    5d7e:	06600793          	li	a5,102
    5d82:	f8f40c23          	sb	a5,-104(s0)
    name[1] = '0' + nfiles / 1000;
    5d86:	fec42783          	lw	a5,-20(s0)
    5d8a:	873e                	mv	a4,a5
    5d8c:	3e800793          	li	a5,1000
    5d90:	02f747bb          	divw	a5,a4,a5
    5d94:	2781                	sext.w	a5,a5
    5d96:	0ff7f793          	zext.b	a5,a5
    5d9a:	0307879b          	addiw	a5,a5,48
    5d9e:	0ff7f793          	zext.b	a5,a5
    5da2:	f8f40ca3          	sb	a5,-103(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5da6:	fec42783          	lw	a5,-20(s0)
    5daa:	873e                	mv	a4,a5
    5dac:	3e800793          	li	a5,1000
    5db0:	02f767bb          	remw	a5,a4,a5
    5db4:	2781                	sext.w	a5,a5
    5db6:	873e                	mv	a4,a5
    5db8:	06400793          	li	a5,100
    5dbc:	02f747bb          	divw	a5,a4,a5
    5dc0:	2781                	sext.w	a5,a5
    5dc2:	0ff7f793          	zext.b	a5,a5
    5dc6:	0307879b          	addiw	a5,a5,48
    5dca:	0ff7f793          	zext.b	a5,a5
    5dce:	f8f40d23          	sb	a5,-102(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5dd2:	fec42783          	lw	a5,-20(s0)
    5dd6:	873e                	mv	a4,a5
    5dd8:	06400793          	li	a5,100
    5ddc:	02f767bb          	remw	a5,a4,a5
    5de0:	2781                	sext.w	a5,a5
    5de2:	873e                	mv	a4,a5
    5de4:	47a9                	li	a5,10
    5de6:	02f747bb          	divw	a5,a4,a5
    5dea:	2781                	sext.w	a5,a5
    5dec:	0ff7f793          	zext.b	a5,a5
    5df0:	0307879b          	addiw	a5,a5,48
    5df4:	0ff7f793          	zext.b	a5,a5
    5df8:	f8f40da3          	sb	a5,-101(s0)
    name[4] = '0' + (nfiles % 10);
    5dfc:	fec42783          	lw	a5,-20(s0)
    5e00:	873e                	mv	a4,a5
    5e02:	47a9                	li	a5,10
    5e04:	02f767bb          	remw	a5,a4,a5
    5e08:	2781                	sext.w	a5,a5
    5e0a:	0ff7f793          	zext.b	a5,a5
    5e0e:	0307879b          	addiw	a5,a5,48
    5e12:	0ff7f793          	zext.b	a5,a5
    5e16:	f8f40e23          	sb	a5,-100(s0)
    name[5] = '\0';
    5e1a:	f8040ea3          	sb	zero,-99(s0)
    unlink(name);
    5e1e:	f9840793          	addi	a5,s0,-104
    5e22:	853e                	mv	a0,a5
    5e24:	00002097          	auipc	ra,0x2
    5e28:	a80080e7          	jalr	-1408(ra) # 78a4 <unlink>
    nfiles--;
    5e2c:	fec42783          	lw	a5,-20(s0)
    5e30:	37fd                	addiw	a5,a5,-1
    5e32:	fef42623          	sw	a5,-20(s0)
  while(nfiles >= 0){
    5e36:	fec42783          	lw	a5,-20(s0)
    5e3a:	2781                	sext.w	a5,a5
    5e3c:	f407d1e3          	bgez	a5,5d7e <fsfull+0x19e>
  }

  printf("fsfull test finished\n");
    5e40:	00004517          	auipc	a0,0x4
    5e44:	11050513          	addi	a0,a0,272 # 9f50 <malloc+0x1fe2>
    5e48:	00002097          	auipc	ra,0x2
    5e4c:	f34080e7          	jalr	-204(ra) # 7d7c <printf>
}
    5e50:	0001                	nop
    5e52:	70a6                	ld	ra,104(sp)
    5e54:	7406                	ld	s0,96(sp)
    5e56:	6165                	addi	sp,sp,112
    5e58:	8082                	ret

0000000000005e5a <argptest>:

void argptest(char *s)
{
    5e5a:	7179                	addi	sp,sp,-48
    5e5c:	f406                	sd	ra,40(sp)
    5e5e:	f022                	sd	s0,32(sp)
    5e60:	1800                	addi	s0,sp,48
    5e62:	fca43c23          	sd	a0,-40(s0)
  int fd;
  fd = open("init", O_RDONLY);
    5e66:	4581                	li	a1,0
    5e68:	00004517          	auipc	a0,0x4
    5e6c:	10050513          	addi	a0,a0,256 # 9f68 <malloc+0x1ffa>
    5e70:	00002097          	auipc	ra,0x2
    5e74:	a24080e7          	jalr	-1500(ra) # 7894 <open>
    5e78:	87aa                	mv	a5,a0
    5e7a:	fef42623          	sw	a5,-20(s0)
  if (fd < 0) {
    5e7e:	fec42783          	lw	a5,-20(s0)
    5e82:	2781                	sext.w	a5,a5
    5e84:	0207d163          	bgez	a5,5ea6 <argptest+0x4c>
    printf("%s: open failed\n", s);
    5e88:	fd843583          	ld	a1,-40(s0)
    5e8c:	00002517          	auipc	a0,0x2
    5e90:	67c50513          	addi	a0,a0,1660 # 8508 <malloc+0x59a>
    5e94:	00002097          	auipc	ra,0x2
    5e98:	ee8080e7          	jalr	-280(ra) # 7d7c <printf>
    exit(1);
    5e9c:	4505                	li	a0,1
    5e9e:	00002097          	auipc	ra,0x2
    5ea2:	9b6080e7          	jalr	-1610(ra) # 7854 <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    5ea6:	4501                	li	a0,0
    5ea8:	00002097          	auipc	ra,0x2
    5eac:	a34080e7          	jalr	-1484(ra) # 78dc <sbrk>
    5eb0:	87aa                	mv	a5,a0
    5eb2:	fff78713          	addi	a4,a5,-1
    5eb6:	fec42783          	lw	a5,-20(s0)
    5eba:	567d                	li	a2,-1
    5ebc:	85ba                	mv	a1,a4
    5ebe:	853e                	mv	a0,a5
    5ec0:	00002097          	auipc	ra,0x2
    5ec4:	9ac080e7          	jalr	-1620(ra) # 786c <read>
  close(fd);
    5ec8:	fec42783          	lw	a5,-20(s0)
    5ecc:	853e                	mv	a0,a5
    5ece:	00002097          	auipc	ra,0x2
    5ed2:	9ae080e7          	jalr	-1618(ra) # 787c <close>
}
    5ed6:	0001                	nop
    5ed8:	70a2                	ld	ra,40(sp)
    5eda:	7402                	ld	s0,32(sp)
    5edc:	6145                	addi	sp,sp,48
    5ede:	8082                	ret

0000000000005ee0 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
    5ee0:	7139                	addi	sp,sp,-64
    5ee2:	fc06                	sd	ra,56(sp)
    5ee4:	f822                	sd	s0,48(sp)
    5ee6:	0080                	addi	s0,sp,64
    5ee8:	fca43423          	sd	a0,-56(s0)
  int pid;
  int xstatus;

  pid = fork();
    5eec:	00002097          	auipc	ra,0x2
    5ef0:	960080e7          	jalr	-1696(ra) # 784c <fork>
    5ef4:	87aa                	mv	a5,a0
    5ef6:	fef42623          	sw	a5,-20(s0)
  if(pid == 0) {
    5efa:	fec42783          	lw	a5,-20(s0)
    5efe:	2781                	sext.w	a5,a5
    5f00:	e3b9                	bnez	a5,5f46 <stacktest+0x66>
    char *sp = (char *) r_sp();
    5f02:	ffffa097          	auipc	ra,0xffffa
    5f06:	0fe080e7          	jalr	254(ra) # 0 <r_sp>
    5f0a:	87aa                	mv	a5,a0
    5f0c:	fef43023          	sd	a5,-32(s0)
    sp -= PGSIZE;
    5f10:	fe043703          	ld	a4,-32(s0)
    5f14:	77fd                	lui	a5,0xfffff
    5f16:	97ba                	add	a5,a5,a4
    5f18:	fef43023          	sd	a5,-32(s0)
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    5f1c:	fe043783          	ld	a5,-32(s0)
    5f20:	0007c783          	lbu	a5,0(a5) # fffffffffffff000 <freep+0xfffffffffffec4f8>
    5f24:	2781                	sext.w	a5,a5
    5f26:	863e                	mv	a2,a5
    5f28:	fc843583          	ld	a1,-56(s0)
    5f2c:	00004517          	auipc	a0,0x4
    5f30:	04450513          	addi	a0,a0,68 # 9f70 <malloc+0x2002>
    5f34:	00002097          	auipc	ra,0x2
    5f38:	e48080e7          	jalr	-440(ra) # 7d7c <printf>
    exit(1);
    5f3c:	4505                	li	a0,1
    5f3e:	00002097          	auipc	ra,0x2
    5f42:	916080e7          	jalr	-1770(ra) # 7854 <exit>
  } else if(pid < 0){
    5f46:	fec42783          	lw	a5,-20(s0)
    5f4a:	2781                	sext.w	a5,a5
    5f4c:	0207d163          	bgez	a5,5f6e <stacktest+0x8e>
    printf("%s: fork failed\n", s);
    5f50:	fc843583          	ld	a1,-56(s0)
    5f54:	00002517          	auipc	a0,0x2
    5f58:	59c50513          	addi	a0,a0,1436 # 84f0 <malloc+0x582>
    5f5c:	00002097          	auipc	ra,0x2
    5f60:	e20080e7          	jalr	-480(ra) # 7d7c <printf>
    exit(1);
    5f64:	4505                	li	a0,1
    5f66:	00002097          	auipc	ra,0x2
    5f6a:	8ee080e7          	jalr	-1810(ra) # 7854 <exit>
  }
  wait(&xstatus);
    5f6e:	fdc40793          	addi	a5,s0,-36
    5f72:	853e                	mv	a0,a5
    5f74:	00002097          	auipc	ra,0x2
    5f78:	8e8080e7          	jalr	-1816(ra) # 785c <wait>
  if(xstatus == -1)  // kernel killed child?
    5f7c:	fdc42783          	lw	a5,-36(s0)
    5f80:	873e                	mv	a4,a5
    5f82:	57fd                	li	a5,-1
    5f84:	00f71763          	bne	a4,a5,5f92 <stacktest+0xb2>
    exit(0);
    5f88:	4501                	li	a0,0
    5f8a:	00002097          	auipc	ra,0x2
    5f8e:	8ca080e7          	jalr	-1846(ra) # 7854 <exit>
  else
    exit(xstatus);
    5f92:	fdc42783          	lw	a5,-36(s0)
    5f96:	853e                	mv	a0,a5
    5f98:	00002097          	auipc	ra,0x2
    5f9c:	8bc080e7          	jalr	-1860(ra) # 7854 <exit>

0000000000005fa0 <textwrite>:
}

// check that writes to text segment fault
void
textwrite(char *s)
{
    5fa0:	7139                	addi	sp,sp,-64
    5fa2:	fc06                	sd	ra,56(sp)
    5fa4:	f822                	sd	s0,48(sp)
    5fa6:	0080                	addi	s0,sp,64
    5fa8:	fca43423          	sd	a0,-56(s0)
  int pid;
  int xstatus;

  pid = fork();
    5fac:	00002097          	auipc	ra,0x2
    5fb0:	8a0080e7          	jalr	-1888(ra) # 784c <fork>
    5fb4:	87aa                	mv	a5,a0
    5fb6:	fef42623          	sw	a5,-20(s0)
  if(pid == 0) {
    5fba:	fec42783          	lw	a5,-20(s0)
    5fbe:	2781                	sext.w	a5,a5
    5fc0:	ef81                	bnez	a5,5fd8 <textwrite+0x38>
    volatile int *addr = (int *) 0;
    5fc2:	fe043023          	sd	zero,-32(s0)
    *addr = 10;
    5fc6:	fe043783          	ld	a5,-32(s0)
    5fca:	4729                	li	a4,10
    5fcc:	c398                	sw	a4,0(a5)
    exit(1);
    5fce:	4505                	li	a0,1
    5fd0:	00002097          	auipc	ra,0x2
    5fd4:	884080e7          	jalr	-1916(ra) # 7854 <exit>
  } else if(pid < 0){
    5fd8:	fec42783          	lw	a5,-20(s0)
    5fdc:	2781                	sext.w	a5,a5
    5fde:	0207d163          	bgez	a5,6000 <textwrite+0x60>
    printf("%s: fork failed\n", s);
    5fe2:	fc843583          	ld	a1,-56(s0)
    5fe6:	00002517          	auipc	a0,0x2
    5fea:	50a50513          	addi	a0,a0,1290 # 84f0 <malloc+0x582>
    5fee:	00002097          	auipc	ra,0x2
    5ff2:	d8e080e7          	jalr	-626(ra) # 7d7c <printf>
    exit(1);
    5ff6:	4505                	li	a0,1
    5ff8:	00002097          	auipc	ra,0x2
    5ffc:	85c080e7          	jalr	-1956(ra) # 7854 <exit>
  }
  wait(&xstatus);
    6000:	fdc40793          	addi	a5,s0,-36
    6004:	853e                	mv	a0,a5
    6006:	00002097          	auipc	ra,0x2
    600a:	856080e7          	jalr	-1962(ra) # 785c <wait>
  if(xstatus == -1)  // kernel killed child?
    600e:	fdc42783          	lw	a5,-36(s0)
    6012:	873e                	mv	a4,a5
    6014:	57fd                	li	a5,-1
    6016:	00f71763          	bne	a4,a5,6024 <textwrite+0x84>
    exit(0);
    601a:	4501                	li	a0,0
    601c:	00002097          	auipc	ra,0x2
    6020:	838080e7          	jalr	-1992(ra) # 7854 <exit>
  else
    exit(xstatus);
    6024:	fdc42783          	lw	a5,-36(s0)
    6028:	853e                	mv	a0,a5
    602a:	00002097          	auipc	ra,0x2
    602e:	82a080e7          	jalr	-2006(ra) # 7854 <exit>

0000000000006032 <pgbug>:
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void *big = (void*) 0xeaeb0b5b00002f5e;
void
pgbug(char *s)
{
    6032:	7179                	addi	sp,sp,-48
    6034:	f406                	sd	ra,40(sp)
    6036:	f022                	sd	s0,32(sp)
    6038:	1800                	addi	s0,sp,48
    603a:	fca43c23          	sd	a0,-40(s0)
  char *argv[1];
  argv[0] = 0;
    603e:	fe043423          	sd	zero,-24(s0)
  exec(big, argv);
    6042:	00006797          	auipc	a5,0x6
    6046:	e4e78793          	addi	a5,a5,-434 # be90 <big>
    604a:	639c                	ld	a5,0(a5)
    604c:	fe840713          	addi	a4,s0,-24
    6050:	85ba                	mv	a1,a4
    6052:	853e                	mv	a0,a5
    6054:	00002097          	auipc	ra,0x2
    6058:	838080e7          	jalr	-1992(ra) # 788c <exec>
  pipe(big);
    605c:	00006797          	auipc	a5,0x6
    6060:	e3478793          	addi	a5,a5,-460 # be90 <big>
    6064:	639c                	ld	a5,0(a5)
    6066:	853e                	mv	a0,a5
    6068:	00001097          	auipc	ra,0x1
    606c:	7fc080e7          	jalr	2044(ra) # 7864 <pipe>

  exit(0);
    6070:	4501                	li	a0,0
    6072:	00001097          	auipc	ra,0x1
    6076:	7e2080e7          	jalr	2018(ra) # 7854 <exit>

000000000000607a <sbrkbugs>:
// regression test. does the kernel panic if a process sbrk()s its
// size to be less than a page, or zero, or reduces the break by an
// amount too small to cause a page to be freed?
void
sbrkbugs(char *s)
{
    607a:	7179                	addi	sp,sp,-48
    607c:	f406                	sd	ra,40(sp)
    607e:	f022                	sd	s0,32(sp)
    6080:	1800                	addi	s0,sp,48
    6082:	fca43c23          	sd	a0,-40(s0)
  int pid = fork();
    6086:	00001097          	auipc	ra,0x1
    608a:	7c6080e7          	jalr	1990(ra) # 784c <fork>
    608e:	87aa                	mv	a5,a0
    6090:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6094:	fec42783          	lw	a5,-20(s0)
    6098:	2781                	sext.w	a5,a5
    609a:	0007df63          	bgez	a5,60b8 <sbrkbugs+0x3e>
    printf("fork failed\n");
    609e:	00002517          	auipc	a0,0x2
    60a2:	22250513          	addi	a0,a0,546 # 82c0 <malloc+0x352>
    60a6:	00002097          	auipc	ra,0x2
    60aa:	cd6080e7          	jalr	-810(ra) # 7d7c <printf>
    exit(1);
    60ae:	4505                	li	a0,1
    60b0:	00001097          	auipc	ra,0x1
    60b4:	7a4080e7          	jalr	1956(ra) # 7854 <exit>
  }
  if(pid == 0){
    60b8:	fec42783          	lw	a5,-20(s0)
    60bc:	2781                	sext.w	a5,a5
    60be:	eb85                	bnez	a5,60ee <sbrkbugs+0x74>
    int sz = (uint64) sbrk(0);
    60c0:	4501                	li	a0,0
    60c2:	00002097          	auipc	ra,0x2
    60c6:	81a080e7          	jalr	-2022(ra) # 78dc <sbrk>
    60ca:	87aa                	mv	a5,a0
    60cc:	fef42223          	sw	a5,-28(s0)
    // free all user memory; there used to be a bug that
    // would not adjust p->sz correctly in this case,
    // causing exit() to panic.
    sbrk(-sz);
    60d0:	fe442783          	lw	a5,-28(s0)
    60d4:	40f007bb          	negw	a5,a5
    60d8:	2781                	sext.w	a5,a5
    60da:	853e                	mv	a0,a5
    60dc:	00002097          	auipc	ra,0x2
    60e0:	800080e7          	jalr	-2048(ra) # 78dc <sbrk>
    // user page fault here.
    exit(0);
    60e4:	4501                	li	a0,0
    60e6:	00001097          	auipc	ra,0x1
    60ea:	76e080e7          	jalr	1902(ra) # 7854 <exit>
  }
  wait(0);
    60ee:	4501                	li	a0,0
    60f0:	00001097          	auipc	ra,0x1
    60f4:	76c080e7          	jalr	1900(ra) # 785c <wait>

  pid = fork();
    60f8:	00001097          	auipc	ra,0x1
    60fc:	754080e7          	jalr	1876(ra) # 784c <fork>
    6100:	87aa                	mv	a5,a0
    6102:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    6106:	fec42783          	lw	a5,-20(s0)
    610a:	2781                	sext.w	a5,a5
    610c:	0007df63          	bgez	a5,612a <sbrkbugs+0xb0>
    printf("fork failed\n");
    6110:	00002517          	auipc	a0,0x2
    6114:	1b050513          	addi	a0,a0,432 # 82c0 <malloc+0x352>
    6118:	00002097          	auipc	ra,0x2
    611c:	c64080e7          	jalr	-924(ra) # 7d7c <printf>
    exit(1);
    6120:	4505                	li	a0,1
    6122:	00001097          	auipc	ra,0x1
    6126:	732080e7          	jalr	1842(ra) # 7854 <exit>
  }
  if(pid == 0){
    612a:	fec42783          	lw	a5,-20(s0)
    612e:	2781                	sext.w	a5,a5
    6130:	eb95                	bnez	a5,6164 <sbrkbugs+0xea>
    int sz = (uint64) sbrk(0);
    6132:	4501                	li	a0,0
    6134:	00001097          	auipc	ra,0x1
    6138:	7a8080e7          	jalr	1960(ra) # 78dc <sbrk>
    613c:	87aa                	mv	a5,a0
    613e:	fef42423          	sw	a5,-24(s0)
    // set the break to somewhere in the very first
    // page; there used to be a bug that would incorrectly
    // free the first page.
    sbrk(-(sz - 3500));
    6142:	6785                	lui	a5,0x1
    6144:	dac7879b          	addiw	a5,a5,-596 # dac <truncate2+0x4c>
    6148:	fe842703          	lw	a4,-24(s0)
    614c:	9f99                	subw	a5,a5,a4
    614e:	2781                	sext.w	a5,a5
    6150:	853e                	mv	a0,a5
    6152:	00001097          	auipc	ra,0x1
    6156:	78a080e7          	jalr	1930(ra) # 78dc <sbrk>
    exit(0);
    615a:	4501                	li	a0,0
    615c:	00001097          	auipc	ra,0x1
    6160:	6f8080e7          	jalr	1784(ra) # 7854 <exit>
  }
  wait(0);
    6164:	4501                	li	a0,0
    6166:	00001097          	auipc	ra,0x1
    616a:	6f6080e7          	jalr	1782(ra) # 785c <wait>

  pid = fork();
    616e:	00001097          	auipc	ra,0x1
    6172:	6de080e7          	jalr	1758(ra) # 784c <fork>
    6176:	87aa                	mv	a5,a0
    6178:	fef42623          	sw	a5,-20(s0)
  if(pid < 0){
    617c:	fec42783          	lw	a5,-20(s0)
    6180:	2781                	sext.w	a5,a5
    6182:	0007df63          	bgez	a5,61a0 <sbrkbugs+0x126>
    printf("fork failed\n");
    6186:	00002517          	auipc	a0,0x2
    618a:	13a50513          	addi	a0,a0,314 # 82c0 <malloc+0x352>
    618e:	00002097          	auipc	ra,0x2
    6192:	bee080e7          	jalr	-1042(ra) # 7d7c <printf>
    exit(1);
    6196:	4505                	li	a0,1
    6198:	00001097          	auipc	ra,0x1
    619c:	6bc080e7          	jalr	1724(ra) # 7854 <exit>
  }
  if(pid == 0){
    61a0:	fec42783          	lw	a5,-20(s0)
    61a4:	2781                	sext.w	a5,a5
    61a6:	ef95                	bnez	a5,61e2 <sbrkbugs+0x168>
    // set the break in the middle of a page.
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    61a8:	4501                	li	a0,0
    61aa:	00001097          	auipc	ra,0x1
    61ae:	732080e7          	jalr	1842(ra) # 78dc <sbrk>
    61b2:	87aa                	mv	a5,a0
    61b4:	2781                	sext.w	a5,a5
    61b6:	672d                	lui	a4,0xb
    61b8:	8007071b          	addiw	a4,a4,-2048 # a800 <malloc+0x2892>
    61bc:	40f707bb          	subw	a5,a4,a5
    61c0:	2781                	sext.w	a5,a5
    61c2:	2781                	sext.w	a5,a5
    61c4:	853e                	mv	a0,a5
    61c6:	00001097          	auipc	ra,0x1
    61ca:	716080e7          	jalr	1814(ra) # 78dc <sbrk>

    // reduce the break a bit, but not enough to
    // cause a page to be freed. this used to cause
    // a panic.
    sbrk(-10);
    61ce:	5559                	li	a0,-10
    61d0:	00001097          	auipc	ra,0x1
    61d4:	70c080e7          	jalr	1804(ra) # 78dc <sbrk>

    exit(0);
    61d8:	4501                	li	a0,0
    61da:	00001097          	auipc	ra,0x1
    61de:	67a080e7          	jalr	1658(ra) # 7854 <exit>
  }
  wait(0);
    61e2:	4501                	li	a0,0
    61e4:	00001097          	auipc	ra,0x1
    61e8:	678080e7          	jalr	1656(ra) # 785c <wait>

  exit(0);
    61ec:	4501                	li	a0,0
    61ee:	00001097          	auipc	ra,0x1
    61f2:	666080e7          	jalr	1638(ra) # 7854 <exit>

00000000000061f6 <sbrklast>:
// if process size was somewhat more than a page boundary, and then
// shrunk to be somewhat less than that page boundary, can the kernel
// still copyin() from addresses in the last page?
void
sbrklast(char *s)
{
    61f6:	7139                	addi	sp,sp,-64
    61f8:	fc06                	sd	ra,56(sp)
    61fa:	f822                	sd	s0,48(sp)
    61fc:	0080                	addi	s0,sp,64
    61fe:	fca43423          	sd	a0,-56(s0)
  uint64 top = (uint64) sbrk(0);
    6202:	4501                	li	a0,0
    6204:	00001097          	auipc	ra,0x1
    6208:	6d8080e7          	jalr	1752(ra) # 78dc <sbrk>
    620c:	87aa                	mv	a5,a0
    620e:	fef43423          	sd	a5,-24(s0)
  if((top % 4096) != 0)
    6212:	fe843703          	ld	a4,-24(s0)
    6216:	6785                	lui	a5,0x1
    6218:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    621a:	8ff9                	and	a5,a5,a4
    621c:	c39d                	beqz	a5,6242 <sbrklast+0x4c>
    sbrk(4096 - (top % 4096));
    621e:	fe843783          	ld	a5,-24(s0)
    6222:	2781                	sext.w	a5,a5
    6224:	873e                	mv	a4,a5
    6226:	6785                	lui	a5,0x1
    6228:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    622a:	8ff9                	and	a5,a5,a4
    622c:	2781                	sext.w	a5,a5
    622e:	6705                	lui	a4,0x1
    6230:	40f707bb          	subw	a5,a4,a5
    6234:	2781                	sext.w	a5,a5
    6236:	2781                	sext.w	a5,a5
    6238:	853e                	mv	a0,a5
    623a:	00001097          	auipc	ra,0x1
    623e:	6a2080e7          	jalr	1698(ra) # 78dc <sbrk>
  sbrk(4096);
    6242:	6505                	lui	a0,0x1
    6244:	00001097          	auipc	ra,0x1
    6248:	698080e7          	jalr	1688(ra) # 78dc <sbrk>
  sbrk(10);
    624c:	4529                	li	a0,10
    624e:	00001097          	auipc	ra,0x1
    6252:	68e080e7          	jalr	1678(ra) # 78dc <sbrk>
  sbrk(-20);
    6256:	5531                	li	a0,-20
    6258:	00001097          	auipc	ra,0x1
    625c:	684080e7          	jalr	1668(ra) # 78dc <sbrk>
  top = (uint64) sbrk(0);
    6260:	4501                	li	a0,0
    6262:	00001097          	auipc	ra,0x1
    6266:	67a080e7          	jalr	1658(ra) # 78dc <sbrk>
    626a:	87aa                	mv	a5,a0
    626c:	fef43423          	sd	a5,-24(s0)
  char *p = (char *) (top - 64);
    6270:	fe843783          	ld	a5,-24(s0)
    6274:	fc078793          	addi	a5,a5,-64
    6278:	fef43023          	sd	a5,-32(s0)
  p[0] = 'x';
    627c:	fe043783          	ld	a5,-32(s0)
    6280:	07800713          	li	a4,120
    6284:	00e78023          	sb	a4,0(a5)
  p[1] = '\0';
    6288:	fe043783          	ld	a5,-32(s0)
    628c:	0785                	addi	a5,a5,1
    628e:	00078023          	sb	zero,0(a5)
  int fd = open(p, O_RDWR|O_CREATE);
    6292:	20200593          	li	a1,514
    6296:	fe043503          	ld	a0,-32(s0)
    629a:	00001097          	auipc	ra,0x1
    629e:	5fa080e7          	jalr	1530(ra) # 7894 <open>
    62a2:	87aa                	mv	a5,a0
    62a4:	fcf42e23          	sw	a5,-36(s0)
  write(fd, p, 1);
    62a8:	fdc42783          	lw	a5,-36(s0)
    62ac:	4605                	li	a2,1
    62ae:	fe043583          	ld	a1,-32(s0)
    62b2:	853e                	mv	a0,a5
    62b4:	00001097          	auipc	ra,0x1
    62b8:	5c0080e7          	jalr	1472(ra) # 7874 <write>
  close(fd);
    62bc:	fdc42783          	lw	a5,-36(s0)
    62c0:	853e                	mv	a0,a5
    62c2:	00001097          	auipc	ra,0x1
    62c6:	5ba080e7          	jalr	1466(ra) # 787c <close>
  fd = open(p, O_RDWR);
    62ca:	4589                	li	a1,2
    62cc:	fe043503          	ld	a0,-32(s0)
    62d0:	00001097          	auipc	ra,0x1
    62d4:	5c4080e7          	jalr	1476(ra) # 7894 <open>
    62d8:	87aa                	mv	a5,a0
    62da:	fcf42e23          	sw	a5,-36(s0)
  p[0] = '\0';
    62de:	fe043783          	ld	a5,-32(s0)
    62e2:	00078023          	sb	zero,0(a5)
  read(fd, p, 1);
    62e6:	fdc42783          	lw	a5,-36(s0)
    62ea:	4605                	li	a2,1
    62ec:	fe043583          	ld	a1,-32(s0)
    62f0:	853e                	mv	a0,a5
    62f2:	00001097          	auipc	ra,0x1
    62f6:	57a080e7          	jalr	1402(ra) # 786c <read>
  if(p[0] != 'x')
    62fa:	fe043783          	ld	a5,-32(s0)
    62fe:	0007c783          	lbu	a5,0(a5)
    6302:	873e                	mv	a4,a5
    6304:	07800793          	li	a5,120
    6308:	00f70763          	beq	a4,a5,6316 <sbrklast+0x120>
    exit(1);
    630c:	4505                	li	a0,1
    630e:	00001097          	auipc	ra,0x1
    6312:	546080e7          	jalr	1350(ra) # 7854 <exit>
}
    6316:	0001                	nop
    6318:	70e2                	ld	ra,56(sp)
    631a:	7442                	ld	s0,48(sp)
    631c:	6121                	addi	sp,sp,64
    631e:	8082                	ret

0000000000006320 <sbrk8000>:

// does sbrk handle signed int32 wrap-around with
// negative arguments?
void
sbrk8000(char *s)
{
    6320:	7179                	addi	sp,sp,-48
    6322:	f406                	sd	ra,40(sp)
    6324:	f022                	sd	s0,32(sp)
    6326:	1800                	addi	s0,sp,48
    6328:	fca43c23          	sd	a0,-40(s0)
  sbrk(0x80000004);
    632c:	800007b7          	lui	a5,0x80000
    6330:	00478513          	addi	a0,a5,4 # ffffffff80000004 <freep+0xffffffff7ffed4fc>
    6334:	00001097          	auipc	ra,0x1
    6338:	5a8080e7          	jalr	1448(ra) # 78dc <sbrk>
  volatile char *top = sbrk(0);
    633c:	4501                	li	a0,0
    633e:	00001097          	auipc	ra,0x1
    6342:	59e080e7          	jalr	1438(ra) # 78dc <sbrk>
    6346:	fea43423          	sd	a0,-24(s0)
  *(top-1) = *(top-1) + 1;
    634a:	fe843783          	ld	a5,-24(s0)
    634e:	17fd                	addi	a5,a5,-1
    6350:	0007c783          	lbu	a5,0(a5)
    6354:	0ff7f713          	zext.b	a4,a5
    6358:	fe843783          	ld	a5,-24(s0)
    635c:	17fd                	addi	a5,a5,-1
    635e:	2705                	addiw	a4,a4,1 # 1001 <truncate3+0x1b3>
    6360:	0ff77713          	zext.b	a4,a4
    6364:	00e78023          	sb	a4,0(a5)
}
    6368:	0001                	nop
    636a:	70a2                	ld	ra,40(sp)
    636c:	7402                	ld	s0,32(sp)
    636e:	6145                	addi	sp,sp,48
    6370:	8082                	ret

0000000000006372 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    6372:	7139                	addi	sp,sp,-64
    6374:	fc06                	sd	ra,56(sp)
    6376:	f822                	sd	s0,48(sp)
    6378:	0080                	addi	s0,sp,64
    637a:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 50000; i++){
    637e:	fe042623          	sw	zero,-20(s0)
    6382:	a03d                	j	63b0 <badarg+0x3e>
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    6384:	57fd                	li	a5,-1
    6386:	9381                	srli	a5,a5,0x20
    6388:	fcf43c23          	sd	a5,-40(s0)
    argv[1] = 0;
    638c:	fe043023          	sd	zero,-32(s0)
    exec("echo", argv);
    6390:	fd840793          	addi	a5,s0,-40
    6394:	85be                	mv	a1,a5
    6396:	00002517          	auipc	a0,0x2
    639a:	f3a50513          	addi	a0,a0,-198 # 82d0 <malloc+0x362>
    639e:	00001097          	auipc	ra,0x1
    63a2:	4ee080e7          	jalr	1262(ra) # 788c <exec>
  for(int i = 0; i < 50000; i++){
    63a6:	fec42783          	lw	a5,-20(s0)
    63aa:	2785                	addiw	a5,a5,1
    63ac:	fef42623          	sw	a5,-20(s0)
    63b0:	fec42783          	lw	a5,-20(s0)
    63b4:	0007871b          	sext.w	a4,a5
    63b8:	67b1                	lui	a5,0xc
    63ba:	34f78793          	addi	a5,a5,847 # c34f <buf+0x6f>
    63be:	fce7d3e3          	bge	a5,a4,6384 <badarg+0x12>
  }

  exit(0);
    63c2:	4501                	li	a0,0
    63c4:	00001097          	auipc	ra,0x1
    63c8:	490080e7          	jalr	1168(ra) # 7854 <exit>

00000000000063cc <bigdir>:
//

// directory that uses indirect blocks
void
bigdir(char *s)
{
    63cc:	7139                	addi	sp,sp,-64
    63ce:	fc06                	sd	ra,56(sp)
    63d0:	f822                	sd	s0,48(sp)
    63d2:	0080                	addi	s0,sp,64
    63d4:	fca43423          	sd	a0,-56(s0)
  enum { N = 500 };
  int i, fd;
  char name[10];

  unlink("bd");
    63d8:	00004517          	auipc	a0,0x4
    63dc:	e9850513          	addi	a0,a0,-360 # a270 <malloc+0x2302>
    63e0:	00001097          	auipc	ra,0x1
    63e4:	4c4080e7          	jalr	1220(ra) # 78a4 <unlink>

  fd = open("bd", O_CREATE);
    63e8:	20000593          	li	a1,512
    63ec:	00004517          	auipc	a0,0x4
    63f0:	e8450513          	addi	a0,a0,-380 # a270 <malloc+0x2302>
    63f4:	00001097          	auipc	ra,0x1
    63f8:	4a0080e7          	jalr	1184(ra) # 7894 <open>
    63fc:	87aa                	mv	a5,a0
    63fe:	fef42423          	sw	a5,-24(s0)
  if(fd < 0){
    6402:	fe842783          	lw	a5,-24(s0)
    6406:	2781                	sext.w	a5,a5
    6408:	0207d163          	bgez	a5,642a <bigdir+0x5e>
    printf("%s: bigdir create failed\n", s);
    640c:	fc843583          	ld	a1,-56(s0)
    6410:	00004517          	auipc	a0,0x4
    6414:	e6850513          	addi	a0,a0,-408 # a278 <malloc+0x230a>
    6418:	00002097          	auipc	ra,0x2
    641c:	964080e7          	jalr	-1692(ra) # 7d7c <printf>
    exit(1);
    6420:	4505                	li	a0,1
    6422:	00001097          	auipc	ra,0x1
    6426:	432080e7          	jalr	1074(ra) # 7854 <exit>
  }
  close(fd);
    642a:	fe842783          	lw	a5,-24(s0)
    642e:	853e                	mv	a0,a5
    6430:	00001097          	auipc	ra,0x1
    6434:	44c080e7          	jalr	1100(ra) # 787c <close>

  for(i = 0; i < N; i++){
    6438:	fe042623          	sw	zero,-20(s0)
    643c:	a055                	j	64e0 <bigdir+0x114>
    name[0] = 'x';
    643e:	07800793          	li	a5,120
    6442:	fcf40c23          	sb	a5,-40(s0)
    name[1] = '0' + (i / 64);
    6446:	fec42783          	lw	a5,-20(s0)
    644a:	41f7d71b          	sraiw	a4,a5,0x1f
    644e:	01a7571b          	srliw	a4,a4,0x1a
    6452:	9fb9                	addw	a5,a5,a4
    6454:	4067d79b          	sraiw	a5,a5,0x6
    6458:	2781                	sext.w	a5,a5
    645a:	0ff7f793          	zext.b	a5,a5
    645e:	0307879b          	addiw	a5,a5,48
    6462:	0ff7f793          	zext.b	a5,a5
    6466:	fcf40ca3          	sb	a5,-39(s0)
    name[2] = '0' + (i % 64);
    646a:	fec42783          	lw	a5,-20(s0)
    646e:	873e                	mv	a4,a5
    6470:	41f7579b          	sraiw	a5,a4,0x1f
    6474:	01a7d79b          	srliw	a5,a5,0x1a
    6478:	9f3d                	addw	a4,a4,a5
    647a:	03f77713          	andi	a4,a4,63
    647e:	40f707bb          	subw	a5,a4,a5
    6482:	2781                	sext.w	a5,a5
    6484:	0ff7f793          	zext.b	a5,a5
    6488:	0307879b          	addiw	a5,a5,48
    648c:	0ff7f793          	zext.b	a5,a5
    6490:	fcf40d23          	sb	a5,-38(s0)
    name[3] = '\0';
    6494:	fc040da3          	sb	zero,-37(s0)
    if(link("bd", name) != 0){
    6498:	fd840793          	addi	a5,s0,-40
    649c:	85be                	mv	a1,a5
    649e:	00004517          	auipc	a0,0x4
    64a2:	dd250513          	addi	a0,a0,-558 # a270 <malloc+0x2302>
    64a6:	00001097          	auipc	ra,0x1
    64aa:	40e080e7          	jalr	1038(ra) # 78b4 <link>
    64ae:	87aa                	mv	a5,a0
    64b0:	c39d                	beqz	a5,64d6 <bigdir+0x10a>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    64b2:	fd840793          	addi	a5,s0,-40
    64b6:	863e                	mv	a2,a5
    64b8:	fc843583          	ld	a1,-56(s0)
    64bc:	00004517          	auipc	a0,0x4
    64c0:	ddc50513          	addi	a0,a0,-548 # a298 <malloc+0x232a>
    64c4:	00002097          	auipc	ra,0x2
    64c8:	8b8080e7          	jalr	-1864(ra) # 7d7c <printf>
      exit(1);
    64cc:	4505                	li	a0,1
    64ce:	00001097          	auipc	ra,0x1
    64d2:	386080e7          	jalr	902(ra) # 7854 <exit>
  for(i = 0; i < N; i++){
    64d6:	fec42783          	lw	a5,-20(s0)
    64da:	2785                	addiw	a5,a5,1
    64dc:	fef42623          	sw	a5,-20(s0)
    64e0:	fec42783          	lw	a5,-20(s0)
    64e4:	0007871b          	sext.w	a4,a5
    64e8:	1f300793          	li	a5,499
    64ec:	f4e7d9e3          	bge	a5,a4,643e <bigdir+0x72>
    }
  }

  unlink("bd");
    64f0:	00004517          	auipc	a0,0x4
    64f4:	d8050513          	addi	a0,a0,-640 # a270 <malloc+0x2302>
    64f8:	00001097          	auipc	ra,0x1
    64fc:	3ac080e7          	jalr	940(ra) # 78a4 <unlink>
  for(i = 0; i < N; i++){
    6500:	fe042623          	sw	zero,-20(s0)
    6504:	a859                	j	659a <bigdir+0x1ce>
    name[0] = 'x';
    6506:	07800793          	li	a5,120
    650a:	fcf40c23          	sb	a5,-40(s0)
    name[1] = '0' + (i / 64);
    650e:	fec42783          	lw	a5,-20(s0)
    6512:	41f7d71b          	sraiw	a4,a5,0x1f
    6516:	01a7571b          	srliw	a4,a4,0x1a
    651a:	9fb9                	addw	a5,a5,a4
    651c:	4067d79b          	sraiw	a5,a5,0x6
    6520:	2781                	sext.w	a5,a5
    6522:	0ff7f793          	zext.b	a5,a5
    6526:	0307879b          	addiw	a5,a5,48
    652a:	0ff7f793          	zext.b	a5,a5
    652e:	fcf40ca3          	sb	a5,-39(s0)
    name[2] = '0' + (i % 64);
    6532:	fec42783          	lw	a5,-20(s0)
    6536:	873e                	mv	a4,a5
    6538:	41f7579b          	sraiw	a5,a4,0x1f
    653c:	01a7d79b          	srliw	a5,a5,0x1a
    6540:	9f3d                	addw	a4,a4,a5
    6542:	03f77713          	andi	a4,a4,63
    6546:	40f707bb          	subw	a5,a4,a5
    654a:	2781                	sext.w	a5,a5
    654c:	0ff7f793          	zext.b	a5,a5
    6550:	0307879b          	addiw	a5,a5,48
    6554:	0ff7f793          	zext.b	a5,a5
    6558:	fcf40d23          	sb	a5,-38(s0)
    name[3] = '\0';
    655c:	fc040da3          	sb	zero,-37(s0)
    if(unlink(name) != 0){
    6560:	fd840793          	addi	a5,s0,-40
    6564:	853e                	mv	a0,a5
    6566:	00001097          	auipc	ra,0x1
    656a:	33e080e7          	jalr	830(ra) # 78a4 <unlink>
    656e:	87aa                	mv	a5,a0
    6570:	c385                	beqz	a5,6590 <bigdir+0x1c4>
      printf("%s: bigdir unlink failed", s);
    6572:	fc843583          	ld	a1,-56(s0)
    6576:	00004517          	auipc	a0,0x4
    657a:	d4250513          	addi	a0,a0,-702 # a2b8 <malloc+0x234a>
    657e:	00001097          	auipc	ra,0x1
    6582:	7fe080e7          	jalr	2046(ra) # 7d7c <printf>
      exit(1);
    6586:	4505                	li	a0,1
    6588:	00001097          	auipc	ra,0x1
    658c:	2cc080e7          	jalr	716(ra) # 7854 <exit>
  for(i = 0; i < N; i++){
    6590:	fec42783          	lw	a5,-20(s0)
    6594:	2785                	addiw	a5,a5,1
    6596:	fef42623          	sw	a5,-20(s0)
    659a:	fec42783          	lw	a5,-20(s0)
    659e:	0007871b          	sext.w	a4,a5
    65a2:	1f300793          	li	a5,499
    65a6:	f6e7d0e3          	bge	a5,a4,6506 <bigdir+0x13a>
    }
  }
}
    65aa:	0001                	nop
    65ac:	0001                	nop
    65ae:	70e2                	ld	ra,56(sp)
    65b0:	7442                	ld	s0,48(sp)
    65b2:	6121                	addi	sp,sp,64
    65b4:	8082                	ret

00000000000065b6 <manywrites>:

// concurrent writes to try to provoke deadlock in the virtio disk
// driver.
void
manywrites(char *s)
{
    65b6:	711d                	addi	sp,sp,-96
    65b8:	ec86                	sd	ra,88(sp)
    65ba:	e8a2                	sd	s0,80(sp)
    65bc:	1080                	addi	s0,sp,96
    65be:	faa43423          	sd	a0,-88(s0)
  int nchildren = 4;
    65c2:	4791                	li	a5,4
    65c4:	fcf42e23          	sw	a5,-36(s0)
  int howmany = 30; // increase to look for deadlock
    65c8:	47f9                	li	a5,30
    65ca:	fcf42c23          	sw	a5,-40(s0)

  for(int ci = 0; ci < nchildren; ci++){
    65ce:	fe042623          	sw	zero,-20(s0)
    65d2:	aa61                	j	676a <manywrites+0x1b4>
    int pid = fork();
    65d4:	00001097          	auipc	ra,0x1
    65d8:	278080e7          	jalr	632(ra) # 784c <fork>
    65dc:	87aa                	mv	a5,a0
    65de:	fcf42a23          	sw	a5,-44(s0)
    if(pid < 0){
    65e2:	fd442783          	lw	a5,-44(s0)
    65e6:	2781                	sext.w	a5,a5
    65e8:	0007df63          	bgez	a5,6606 <manywrites+0x50>
      printf("fork failed\n");
    65ec:	00002517          	auipc	a0,0x2
    65f0:	cd450513          	addi	a0,a0,-812 # 82c0 <malloc+0x352>
    65f4:	00001097          	auipc	ra,0x1
    65f8:	788080e7          	jalr	1928(ra) # 7d7c <printf>
      exit(1);
    65fc:	4505                	li	a0,1
    65fe:	00001097          	auipc	ra,0x1
    6602:	256080e7          	jalr	598(ra) # 7854 <exit>
    }

    if(pid == 0){
    6606:	fd442783          	lw	a5,-44(s0)
    660a:	2781                	sext.w	a5,a5
    660c:	14079a63          	bnez	a5,6760 <manywrites+0x1aa>
      char name[3];
      name[0] = 'b';
    6610:	06200793          	li	a5,98
    6614:	fcf40023          	sb	a5,-64(s0)
      name[1] = 'a' + ci;
    6618:	fec42783          	lw	a5,-20(s0)
    661c:	0ff7f793          	zext.b	a5,a5
    6620:	0617879b          	addiw	a5,a5,97
    6624:	0ff7f793          	zext.b	a5,a5
    6628:	fcf400a3          	sb	a5,-63(s0)
      name[2] = '\0';
    662c:	fc040123          	sb	zero,-62(s0)
      unlink(name);
    6630:	fc040793          	addi	a5,s0,-64
    6634:	853e                	mv	a0,a5
    6636:	00001097          	auipc	ra,0x1
    663a:	26e080e7          	jalr	622(ra) # 78a4 <unlink>

      for(int iters = 0; iters < howmany; iters++){
    663e:	fe042423          	sw	zero,-24(s0)
    6642:	a8d5                	j	6736 <manywrites+0x180>
        for(int i = 0; i < ci+1; i++){
    6644:	fe042223          	sw	zero,-28(s0)
    6648:	a0d1                	j	670c <manywrites+0x156>
          int fd = open(name, O_CREATE | O_RDWR);
    664a:	fc040793          	addi	a5,s0,-64
    664e:	20200593          	li	a1,514
    6652:	853e                	mv	a0,a5
    6654:	00001097          	auipc	ra,0x1
    6658:	240080e7          	jalr	576(ra) # 7894 <open>
    665c:	87aa                	mv	a5,a0
    665e:	fcf42823          	sw	a5,-48(s0)
          if(fd < 0){
    6662:	fd042783          	lw	a5,-48(s0)
    6666:	2781                	sext.w	a5,a5
    6668:	0207d463          	bgez	a5,6690 <manywrites+0xda>
            printf("%s: cannot create %s\n", s, name);
    666c:	fc040793          	addi	a5,s0,-64
    6670:	863e                	mv	a2,a5
    6672:	fa843583          	ld	a1,-88(s0)
    6676:	00004517          	auipc	a0,0x4
    667a:	c6250513          	addi	a0,a0,-926 # a2d8 <malloc+0x236a>
    667e:	00001097          	auipc	ra,0x1
    6682:	6fe080e7          	jalr	1790(ra) # 7d7c <printf>
            exit(1);
    6686:	4505                	li	a0,1
    6688:	00001097          	auipc	ra,0x1
    668c:	1cc080e7          	jalr	460(ra) # 7854 <exit>
          }
          int sz = sizeof(buf);
    6690:	678d                	lui	a5,0x3
    6692:	fcf42623          	sw	a5,-52(s0)
          int cc = write(fd, buf, sz);
    6696:	fcc42703          	lw	a4,-52(s0)
    669a:	fd042783          	lw	a5,-48(s0)
    669e:	863a                	mv	a2,a4
    66a0:	00006597          	auipc	a1,0x6
    66a4:	c4058593          	addi	a1,a1,-960 # c2e0 <buf>
    66a8:	853e                	mv	a0,a5
    66aa:	00001097          	auipc	ra,0x1
    66ae:	1ca080e7          	jalr	458(ra) # 7874 <write>
    66b2:	87aa                	mv	a5,a0
    66b4:	fcf42423          	sw	a5,-56(s0)
          if(cc != sz){
    66b8:	fc842783          	lw	a5,-56(s0)
    66bc:	873e                	mv	a4,a5
    66be:	fcc42783          	lw	a5,-52(s0)
    66c2:	2701                	sext.w	a4,a4
    66c4:	2781                	sext.w	a5,a5
    66c6:	02f70763          	beq	a4,a5,66f4 <manywrites+0x13e>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    66ca:	fc842703          	lw	a4,-56(s0)
    66ce:	fcc42783          	lw	a5,-52(s0)
    66d2:	86ba                	mv	a3,a4
    66d4:	863e                	mv	a2,a5
    66d6:	fa843583          	ld	a1,-88(s0)
    66da:	00003517          	auipc	a0,0x3
    66de:	e1e50513          	addi	a0,a0,-482 # 94f8 <malloc+0x158a>
    66e2:	00001097          	auipc	ra,0x1
    66e6:	69a080e7          	jalr	1690(ra) # 7d7c <printf>
            exit(1);
    66ea:	4505                	li	a0,1
    66ec:	00001097          	auipc	ra,0x1
    66f0:	168080e7          	jalr	360(ra) # 7854 <exit>
          }
          close(fd);
    66f4:	fd042783          	lw	a5,-48(s0)
    66f8:	853e                	mv	a0,a5
    66fa:	00001097          	auipc	ra,0x1
    66fe:	182080e7          	jalr	386(ra) # 787c <close>
        for(int i = 0; i < ci+1; i++){
    6702:	fe442783          	lw	a5,-28(s0)
    6706:	2785                	addiw	a5,a5,1 # 3001 <createdelete+0x281>
    6708:	fef42223          	sw	a5,-28(s0)
    670c:	fec42783          	lw	a5,-20(s0)
    6710:	873e                	mv	a4,a5
    6712:	fe442783          	lw	a5,-28(s0)
    6716:	2701                	sext.w	a4,a4
    6718:	2781                	sext.w	a5,a5
    671a:	f2f758e3          	bge	a4,a5,664a <manywrites+0x94>
        }
        unlink(name);
    671e:	fc040793          	addi	a5,s0,-64
    6722:	853e                	mv	a0,a5
    6724:	00001097          	auipc	ra,0x1
    6728:	180080e7          	jalr	384(ra) # 78a4 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    672c:	fe842783          	lw	a5,-24(s0)
    6730:	2785                	addiw	a5,a5,1
    6732:	fef42423          	sw	a5,-24(s0)
    6736:	fe842783          	lw	a5,-24(s0)
    673a:	873e                	mv	a4,a5
    673c:	fd842783          	lw	a5,-40(s0)
    6740:	2701                	sext.w	a4,a4
    6742:	2781                	sext.w	a5,a5
    6744:	f0f740e3          	blt	a4,a5,6644 <manywrites+0x8e>
      }

      unlink(name);
    6748:	fc040793          	addi	a5,s0,-64
    674c:	853e                	mv	a0,a5
    674e:	00001097          	auipc	ra,0x1
    6752:	156080e7          	jalr	342(ra) # 78a4 <unlink>
      exit(0);
    6756:	4501                	li	a0,0
    6758:	00001097          	auipc	ra,0x1
    675c:	0fc080e7          	jalr	252(ra) # 7854 <exit>
  for(int ci = 0; ci < nchildren; ci++){
    6760:	fec42783          	lw	a5,-20(s0)
    6764:	2785                	addiw	a5,a5,1
    6766:	fef42623          	sw	a5,-20(s0)
    676a:	fec42783          	lw	a5,-20(s0)
    676e:	873e                	mv	a4,a5
    6770:	fdc42783          	lw	a5,-36(s0)
    6774:	2701                	sext.w	a4,a4
    6776:	2781                	sext.w	a5,a5
    6778:	e4f74ee3          	blt	a4,a5,65d4 <manywrites+0x1e>
    }
  }

  for(int ci = 0; ci < nchildren; ci++){
    677c:	fe042023          	sw	zero,-32(s0)
    6780:	a80d                	j	67b2 <manywrites+0x1fc>
    int st = 0;
    6782:	fa042e23          	sw	zero,-68(s0)
    wait(&st);
    6786:	fbc40793          	addi	a5,s0,-68
    678a:	853e                	mv	a0,a5
    678c:	00001097          	auipc	ra,0x1
    6790:	0d0080e7          	jalr	208(ra) # 785c <wait>
    if(st != 0)
    6794:	fbc42783          	lw	a5,-68(s0)
    6798:	cb81                	beqz	a5,67a8 <manywrites+0x1f2>
      exit(st);
    679a:	fbc42783          	lw	a5,-68(s0)
    679e:	853e                	mv	a0,a5
    67a0:	00001097          	auipc	ra,0x1
    67a4:	0b4080e7          	jalr	180(ra) # 7854 <exit>
  for(int ci = 0; ci < nchildren; ci++){
    67a8:	fe042783          	lw	a5,-32(s0)
    67ac:	2785                	addiw	a5,a5,1
    67ae:	fef42023          	sw	a5,-32(s0)
    67b2:	fe042783          	lw	a5,-32(s0)
    67b6:	873e                	mv	a4,a5
    67b8:	fdc42783          	lw	a5,-36(s0)
    67bc:	2701                	sext.w	a4,a4
    67be:	2781                	sext.w	a5,a5
    67c0:	fcf741e3          	blt	a4,a5,6782 <manywrites+0x1cc>
  }
  exit(0);
    67c4:	4501                	li	a0,0
    67c6:	00001097          	auipc	ra,0x1
    67ca:	08e080e7          	jalr	142(ra) # 7854 <exit>

00000000000067ce <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
    67ce:	7179                	addi	sp,sp,-48
    67d0:	f406                	sd	ra,40(sp)
    67d2:	f022                	sd	s0,32(sp)
    67d4:	1800                	addi	s0,sp,48
    67d6:	fca43c23          	sd	a0,-40(s0)
  int assumed_free = 600;
    67da:	25800793          	li	a5,600
    67de:	fef42423          	sw	a5,-24(s0)

  unlink("junk");
    67e2:	00004517          	auipc	a0,0x4
    67e6:	b0e50513          	addi	a0,a0,-1266 # a2f0 <malloc+0x2382>
    67ea:	00001097          	auipc	ra,0x1
    67ee:	0ba080e7          	jalr	186(ra) # 78a4 <unlink>
  for(int i = 0; i < assumed_free; i++){
    67f2:	fe042623          	sw	zero,-20(s0)
    67f6:	a8bd                	j	6874 <badwrite+0xa6>
    int fd = open("junk", O_CREATE|O_WRONLY);
    67f8:	20100593          	li	a1,513
    67fc:	00004517          	auipc	a0,0x4
    6800:	af450513          	addi	a0,a0,-1292 # a2f0 <malloc+0x2382>
    6804:	00001097          	auipc	ra,0x1
    6808:	090080e7          	jalr	144(ra) # 7894 <open>
    680c:	87aa                	mv	a5,a0
    680e:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    6812:	fe042783          	lw	a5,-32(s0)
    6816:	2781                	sext.w	a5,a5
    6818:	0007df63          	bgez	a5,6836 <badwrite+0x68>
      printf("open junk failed\n");
    681c:	00004517          	auipc	a0,0x4
    6820:	adc50513          	addi	a0,a0,-1316 # a2f8 <malloc+0x238a>
    6824:	00001097          	auipc	ra,0x1
    6828:	558080e7          	jalr	1368(ra) # 7d7c <printf>
      exit(1);
    682c:	4505                	li	a0,1
    682e:	00001097          	auipc	ra,0x1
    6832:	026080e7          	jalr	38(ra) # 7854 <exit>
    }
    write(fd, (char*)0xffffffffffL, 1);
    6836:	fe042703          	lw	a4,-32(s0)
    683a:	4605                	li	a2,1
    683c:	57fd                	li	a5,-1
    683e:	0187d593          	srli	a1,a5,0x18
    6842:	853a                	mv	a0,a4
    6844:	00001097          	auipc	ra,0x1
    6848:	030080e7          	jalr	48(ra) # 7874 <write>
    close(fd);
    684c:	fe042783          	lw	a5,-32(s0)
    6850:	853e                	mv	a0,a5
    6852:	00001097          	auipc	ra,0x1
    6856:	02a080e7          	jalr	42(ra) # 787c <close>
    unlink("junk");
    685a:	00004517          	auipc	a0,0x4
    685e:	a9650513          	addi	a0,a0,-1386 # a2f0 <malloc+0x2382>
    6862:	00001097          	auipc	ra,0x1
    6866:	042080e7          	jalr	66(ra) # 78a4 <unlink>
  for(int i = 0; i < assumed_free; i++){
    686a:	fec42783          	lw	a5,-20(s0)
    686e:	2785                	addiw	a5,a5,1
    6870:	fef42623          	sw	a5,-20(s0)
    6874:	fec42783          	lw	a5,-20(s0)
    6878:	873e                	mv	a4,a5
    687a:	fe842783          	lw	a5,-24(s0)
    687e:	2701                	sext.w	a4,a4
    6880:	2781                	sext.w	a5,a5
    6882:	f6f74be3          	blt	a4,a5,67f8 <badwrite+0x2a>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
    6886:	20100593          	li	a1,513
    688a:	00004517          	auipc	a0,0x4
    688e:	a6650513          	addi	a0,a0,-1434 # a2f0 <malloc+0x2382>
    6892:	00001097          	auipc	ra,0x1
    6896:	002080e7          	jalr	2(ra) # 7894 <open>
    689a:	87aa                	mv	a5,a0
    689c:	fef42223          	sw	a5,-28(s0)
  if(fd < 0){
    68a0:	fe442783          	lw	a5,-28(s0)
    68a4:	2781                	sext.w	a5,a5
    68a6:	0007df63          	bgez	a5,68c4 <badwrite+0xf6>
    printf("open junk failed\n");
    68aa:	00004517          	auipc	a0,0x4
    68ae:	a4e50513          	addi	a0,a0,-1458 # a2f8 <malloc+0x238a>
    68b2:	00001097          	auipc	ra,0x1
    68b6:	4ca080e7          	jalr	1226(ra) # 7d7c <printf>
    exit(1);
    68ba:	4505                	li	a0,1
    68bc:	00001097          	auipc	ra,0x1
    68c0:	f98080e7          	jalr	-104(ra) # 7854 <exit>
  }
  if(write(fd, "x", 1) != 1){
    68c4:	fe442783          	lw	a5,-28(s0)
    68c8:	4605                	li	a2,1
    68ca:	00002597          	auipc	a1,0x2
    68ce:	8f658593          	addi	a1,a1,-1802 # 81c0 <malloc+0x252>
    68d2:	853e                	mv	a0,a5
    68d4:	00001097          	auipc	ra,0x1
    68d8:	fa0080e7          	jalr	-96(ra) # 7874 <write>
    68dc:	87aa                	mv	a5,a0
    68de:	873e                	mv	a4,a5
    68e0:	4785                	li	a5,1
    68e2:	00f70f63          	beq	a4,a5,6900 <badwrite+0x132>
    printf("write failed\n");
    68e6:	00004517          	auipc	a0,0x4
    68ea:	a2a50513          	addi	a0,a0,-1494 # a310 <malloc+0x23a2>
    68ee:	00001097          	auipc	ra,0x1
    68f2:	48e080e7          	jalr	1166(ra) # 7d7c <printf>
    exit(1);
    68f6:	4505                	li	a0,1
    68f8:	00001097          	auipc	ra,0x1
    68fc:	f5c080e7          	jalr	-164(ra) # 7854 <exit>
  }
  close(fd);
    6900:	fe442783          	lw	a5,-28(s0)
    6904:	853e                	mv	a0,a5
    6906:	00001097          	auipc	ra,0x1
    690a:	f76080e7          	jalr	-138(ra) # 787c <close>
  unlink("junk");
    690e:	00004517          	auipc	a0,0x4
    6912:	9e250513          	addi	a0,a0,-1566 # a2f0 <malloc+0x2382>
    6916:	00001097          	auipc	ra,0x1
    691a:	f8e080e7          	jalr	-114(ra) # 78a4 <unlink>

  exit(0);
    691e:	4501                	li	a0,0
    6920:	00001097          	auipc	ra,0x1
    6924:	f34080e7          	jalr	-204(ra) # 7854 <exit>

0000000000006928 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    6928:	715d                	addi	sp,sp,-80
    692a:	e486                	sd	ra,72(sp)
    692c:	e0a2                	sd	s0,64(sp)
    692e:	0880                	addi	s0,sp,80
    6930:	faa43c23          	sd	a0,-72(s0)
  for(int avail = 0; avail < 15; avail++){
    6934:	fe042623          	sw	zero,-20(s0)
    6938:	a8cd                	j	6a2a <execout+0x102>
    int pid = fork();
    693a:	00001097          	auipc	ra,0x1
    693e:	f12080e7          	jalr	-238(ra) # 784c <fork>
    6942:	87aa                	mv	a5,a0
    6944:	fef42223          	sw	a5,-28(s0)
    if(pid < 0){
    6948:	fe442783          	lw	a5,-28(s0)
    694c:	2781                	sext.w	a5,a5
    694e:	0007df63          	bgez	a5,696c <execout+0x44>
      printf("fork failed\n");
    6952:	00002517          	auipc	a0,0x2
    6956:	96e50513          	addi	a0,a0,-1682 # 82c0 <malloc+0x352>
    695a:	00001097          	auipc	ra,0x1
    695e:	422080e7          	jalr	1058(ra) # 7d7c <printf>
      exit(1);
    6962:	4505                	li	a0,1
    6964:	00001097          	auipc	ra,0x1
    6968:	ef0080e7          	jalr	-272(ra) # 7854 <exit>
    } else if(pid == 0){
    696c:	fe442783          	lw	a5,-28(s0)
    6970:	2781                	sext.w	a5,a5
    6972:	e3d5                	bnez	a5,6a16 <execout+0xee>
      // allocate all of memory.
      while(1){
        uint64 a = (uint64) sbrk(4096);
    6974:	6505                	lui	a0,0x1
    6976:	00001097          	auipc	ra,0x1
    697a:	f66080e7          	jalr	-154(ra) # 78dc <sbrk>
    697e:	87aa                	mv	a5,a0
    6980:	fcf43c23          	sd	a5,-40(s0)
        if(a == 0xffffffffffffffffLL)
    6984:	fd843703          	ld	a4,-40(s0)
    6988:	57fd                	li	a5,-1
    698a:	00f70c63          	beq	a4,a5,69a2 <execout+0x7a>
          break;
        *(char*)(a + 4096 - 1) = 1;
    698e:	fd843703          	ld	a4,-40(s0)
    6992:	6785                	lui	a5,0x1
    6994:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    6996:	97ba                	add	a5,a5,a4
    6998:	873e                	mv	a4,a5
    699a:	4785                	li	a5,1
    699c:	00f70023          	sb	a5,0(a4)
      while(1){
    69a0:	bfd1                	j	6974 <execout+0x4c>
          break;
    69a2:	0001                	nop
      }

      // free a few pages, in order to let exec() make some
      // progress.
      for(int i = 0; i < avail; i++)
    69a4:	fe042423          	sw	zero,-24(s0)
    69a8:	a819                	j	69be <execout+0x96>
        sbrk(-4096);
    69aa:	757d                	lui	a0,0xfffff
    69ac:	00001097          	auipc	ra,0x1
    69b0:	f30080e7          	jalr	-208(ra) # 78dc <sbrk>
      for(int i = 0; i < avail; i++)
    69b4:	fe842783          	lw	a5,-24(s0)
    69b8:	2785                	addiw	a5,a5,1
    69ba:	fef42423          	sw	a5,-24(s0)
    69be:	fe842783          	lw	a5,-24(s0)
    69c2:	873e                	mv	a4,a5
    69c4:	fec42783          	lw	a5,-20(s0)
    69c8:	2701                	sext.w	a4,a4
    69ca:	2781                	sext.w	a5,a5
    69cc:	fcf74fe3          	blt	a4,a5,69aa <execout+0x82>

      close(1);
    69d0:	4505                	li	a0,1
    69d2:	00001097          	auipc	ra,0x1
    69d6:	eaa080e7          	jalr	-342(ra) # 787c <close>
      char *args[] = { "echo", "x", 0 };
    69da:	00002797          	auipc	a5,0x2
    69de:	8f678793          	addi	a5,a5,-1802 # 82d0 <malloc+0x362>
    69e2:	fcf43023          	sd	a5,-64(s0)
    69e6:	00001797          	auipc	a5,0x1
    69ea:	7da78793          	addi	a5,a5,2010 # 81c0 <malloc+0x252>
    69ee:	fcf43423          	sd	a5,-56(s0)
    69f2:	fc043823          	sd	zero,-48(s0)
      exec("echo", args);
    69f6:	fc040793          	addi	a5,s0,-64
    69fa:	85be                	mv	a1,a5
    69fc:	00002517          	auipc	a0,0x2
    6a00:	8d450513          	addi	a0,a0,-1836 # 82d0 <malloc+0x362>
    6a04:	00001097          	auipc	ra,0x1
    6a08:	e88080e7          	jalr	-376(ra) # 788c <exec>
      exit(0);
    6a0c:	4501                	li	a0,0
    6a0e:	00001097          	auipc	ra,0x1
    6a12:	e46080e7          	jalr	-442(ra) # 7854 <exit>
    } else {
      wait((int*)0);
    6a16:	4501                	li	a0,0
    6a18:	00001097          	auipc	ra,0x1
    6a1c:	e44080e7          	jalr	-444(ra) # 785c <wait>
  for(int avail = 0; avail < 15; avail++){
    6a20:	fec42783          	lw	a5,-20(s0)
    6a24:	2785                	addiw	a5,a5,1
    6a26:	fef42623          	sw	a5,-20(s0)
    6a2a:	fec42783          	lw	a5,-20(s0)
    6a2e:	0007871b          	sext.w	a4,a5
    6a32:	47b9                	li	a5,14
    6a34:	f0e7d3e3          	bge	a5,a4,693a <execout+0x12>
    }
  }

  exit(0);
    6a38:	4501                	li	a0,0
    6a3a:	00001097          	auipc	ra,0x1
    6a3e:	e1a080e7          	jalr	-486(ra) # 7854 <exit>

0000000000006a42 <diskfull>:
}

// can the kernel tolerate running out of disk space?
void
diskfull(char *s)
{
    6a42:	b9010113          	addi	sp,sp,-1136
    6a46:	46113423          	sd	ra,1128(sp)
    6a4a:	46813023          	sd	s0,1120(sp)
    6a4e:	47010413          	addi	s0,sp,1136
    6a52:	b8a43c23          	sd	a0,-1128(s0)
  int fi;
  int done = 0;
    6a56:	fe042423          	sw	zero,-24(s0)

  unlink("diskfulldir");
    6a5a:	00004517          	auipc	a0,0x4
    6a5e:	8c650513          	addi	a0,a0,-1850 # a320 <malloc+0x23b2>
    6a62:	00001097          	auipc	ra,0x1
    6a66:	e42080e7          	jalr	-446(ra) # 78a4 <unlink>

  for(fi = 0; done == 0; fi++){
    6a6a:	fe042623          	sw	zero,-20(s0)
    6a6e:	a8d5                	j	6b62 <diskfull+0x120>
    char name[32];
    name[0] = 'b';
    6a70:	06200793          	li	a5,98
    6a74:	baf40423          	sb	a5,-1112(s0)
    name[1] = 'i';
    6a78:	06900793          	li	a5,105
    6a7c:	baf404a3          	sb	a5,-1111(s0)
    name[2] = 'g';
    6a80:	06700793          	li	a5,103
    6a84:	baf40523          	sb	a5,-1110(s0)
    name[3] = '0' + fi;
    6a88:	fec42783          	lw	a5,-20(s0)
    6a8c:	0ff7f793          	zext.b	a5,a5
    6a90:	0307879b          	addiw	a5,a5,48
    6a94:	0ff7f793          	zext.b	a5,a5
    6a98:	baf405a3          	sb	a5,-1109(s0)
    name[4] = '\0';
    6a9c:	ba040623          	sb	zero,-1108(s0)
    unlink(name);
    6aa0:	ba840793          	addi	a5,s0,-1112
    6aa4:	853e                	mv	a0,a5
    6aa6:	00001097          	auipc	ra,0x1
    6aaa:	dfe080e7          	jalr	-514(ra) # 78a4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6aae:	ba840793          	addi	a5,s0,-1112
    6ab2:	60200593          	li	a1,1538
    6ab6:	853e                	mv	a0,a5
    6ab8:	00001097          	auipc	ra,0x1
    6abc:	ddc080e7          	jalr	-548(ra) # 7894 <open>
    6ac0:	87aa                	mv	a5,a0
    6ac2:	fcf42a23          	sw	a5,-44(s0)
    if(fd < 0){
    6ac6:	fd442783          	lw	a5,-44(s0)
    6aca:	2781                	sext.w	a5,a5
    6acc:	0207d363          	bgez	a5,6af2 <diskfull+0xb0>
      // oops, ran out of inodes before running out of blocks.
      printf("%s: could not create file %s\n", s, name);
    6ad0:	ba840793          	addi	a5,s0,-1112
    6ad4:	863e                	mv	a2,a5
    6ad6:	b9843583          	ld	a1,-1128(s0)
    6ada:	00004517          	auipc	a0,0x4
    6ade:	85650513          	addi	a0,a0,-1962 # a330 <malloc+0x23c2>
    6ae2:	00001097          	auipc	ra,0x1
    6ae6:	29a080e7          	jalr	666(ra) # 7d7c <printf>
      done = 1;
    6aea:	4785                	li	a5,1
    6aec:	fef42423          	sw	a5,-24(s0)
    6af0:	a8ad                	j	6b6a <diskfull+0x128>
      break;
    }
    for(int i = 0; i < MAXFILE; i++){
    6af2:	fe042223          	sw	zero,-28(s0)
    6af6:	a099                	j	6b3c <diskfull+0xfa>
      char buf[BSIZE];
      if(write(fd, buf, BSIZE) != BSIZE){
    6af8:	bc840713          	addi	a4,s0,-1080
    6afc:	fd442783          	lw	a5,-44(s0)
    6b00:	40000613          	li	a2,1024
    6b04:	85ba                	mv	a1,a4
    6b06:	853e                	mv	a0,a5
    6b08:	00001097          	auipc	ra,0x1
    6b0c:	d6c080e7          	jalr	-660(ra) # 7874 <write>
    6b10:	87aa                	mv	a5,a0
    6b12:	873e                	mv	a4,a5
    6b14:	40000793          	li	a5,1024
    6b18:	00f70d63          	beq	a4,a5,6b32 <diskfull+0xf0>
        done = 1;
    6b1c:	4785                	li	a5,1
    6b1e:	fef42423          	sw	a5,-24(s0)
        close(fd);
    6b22:	fd442783          	lw	a5,-44(s0)
    6b26:	853e                	mv	a0,a5
    6b28:	00001097          	auipc	ra,0x1
    6b2c:	d54080e7          	jalr	-684(ra) # 787c <close>
    6b30:	a829                	j	6b4a <diskfull+0x108>
    for(int i = 0; i < MAXFILE; i++){
    6b32:	fe442783          	lw	a5,-28(s0)
    6b36:	2785                	addiw	a5,a5,1
    6b38:	fef42223          	sw	a5,-28(s0)
    6b3c:	fe442783          	lw	a5,-28(s0)
    6b40:	873e                	mv	a4,a5
    6b42:	10b00793          	li	a5,267
    6b46:	fae7f9e3          	bgeu	a5,a4,6af8 <diskfull+0xb6>
        break;
      }
    }
    close(fd);
    6b4a:	fd442783          	lw	a5,-44(s0)
    6b4e:	853e                	mv	a0,a5
    6b50:	00001097          	auipc	ra,0x1
    6b54:	d2c080e7          	jalr	-724(ra) # 787c <close>
  for(fi = 0; done == 0; fi++){
    6b58:	fec42783          	lw	a5,-20(s0)
    6b5c:	2785                	addiw	a5,a5,1
    6b5e:	fef42623          	sw	a5,-20(s0)
    6b62:	fe842783          	lw	a5,-24(s0)
    6b66:	2781                	sext.w	a5,a5
    6b68:	d781                	beqz	a5,6a70 <diskfull+0x2e>

  // now that there are no free blocks, test that dirlink()
  // merely fails (doesn't panic) if it can't extend
  // directory content. one of these file creations
  // is expected to fail.
  int nzz = 128;
    6b6a:	08000793          	li	a5,128
    6b6e:	fcf42823          	sw	a5,-48(s0)
  for(int i = 0; i < nzz; i++){
    6b72:	fe042023          	sw	zero,-32(s0)
    6b76:	a06d                	j	6c20 <diskfull+0x1de>
    char name[32];
    name[0] = 'z';
    6b78:	07a00793          	li	a5,122
    6b7c:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'z';
    6b80:	07a00793          	li	a5,122
    6b84:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = '0' + (i / 32);
    6b88:	fe042783          	lw	a5,-32(s0)
    6b8c:	41f7d71b          	sraiw	a4,a5,0x1f
    6b90:	01b7571b          	srliw	a4,a4,0x1b
    6b94:	9fb9                	addw	a5,a5,a4
    6b96:	4057d79b          	sraiw	a5,a5,0x5
    6b9a:	2781                	sext.w	a5,a5
    6b9c:	0ff7f793          	zext.b	a5,a5
    6ba0:	0307879b          	addiw	a5,a5,48
    6ba4:	0ff7f793          	zext.b	a5,a5
    6ba8:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + (i % 32);
    6bac:	fe042783          	lw	a5,-32(s0)
    6bb0:	873e                	mv	a4,a5
    6bb2:	41f7579b          	sraiw	a5,a4,0x1f
    6bb6:	01b7d79b          	srliw	a5,a5,0x1b
    6bba:	9f3d                	addw	a4,a4,a5
    6bbc:	8b7d                	andi	a4,a4,31
    6bbe:	40f707bb          	subw	a5,a4,a5
    6bc2:	2781                	sext.w	a5,a5
    6bc4:	0ff7f793          	zext.b	a5,a5
    6bc8:	0307879b          	addiw	a5,a5,48
    6bcc:	0ff7f793          	zext.b	a5,a5
    6bd0:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6bd4:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6bd8:	bc840793          	addi	a5,s0,-1080
    6bdc:	853e                	mv	a0,a5
    6bde:	00001097          	auipc	ra,0x1
    6be2:	cc6080e7          	jalr	-826(ra) # 78a4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6be6:	bc840793          	addi	a5,s0,-1080
    6bea:	60200593          	li	a1,1538
    6bee:	853e                	mv	a0,a5
    6bf0:	00001097          	auipc	ra,0x1
    6bf4:	ca4080e7          	jalr	-860(ra) # 7894 <open>
    6bf8:	87aa                	mv	a5,a0
    6bfa:	fcf42623          	sw	a5,-52(s0)
    if(fd < 0)
    6bfe:	fcc42783          	lw	a5,-52(s0)
    6c02:	2781                	sext.w	a5,a5
    6c04:	0207c863          	bltz	a5,6c34 <diskfull+0x1f2>
      break;
    close(fd);
    6c08:	fcc42783          	lw	a5,-52(s0)
    6c0c:	853e                	mv	a0,a5
    6c0e:	00001097          	auipc	ra,0x1
    6c12:	c6e080e7          	jalr	-914(ra) # 787c <close>
  for(int i = 0; i < nzz; i++){
    6c16:	fe042783          	lw	a5,-32(s0)
    6c1a:	2785                	addiw	a5,a5,1
    6c1c:	fef42023          	sw	a5,-32(s0)
    6c20:	fe042783          	lw	a5,-32(s0)
    6c24:	873e                	mv	a4,a5
    6c26:	fd042783          	lw	a5,-48(s0)
    6c2a:	2701                	sext.w	a4,a4
    6c2c:	2781                	sext.w	a5,a5
    6c2e:	f4f745e3          	blt	a4,a5,6b78 <diskfull+0x136>
    6c32:	a011                	j	6c36 <diskfull+0x1f4>
      break;
    6c34:	0001                	nop
  }

  // this mkdir() is expected to fail.
  if(mkdir("diskfulldir") == 0)
    6c36:	00003517          	auipc	a0,0x3
    6c3a:	6ea50513          	addi	a0,a0,1770 # a320 <malloc+0x23b2>
    6c3e:	00001097          	auipc	ra,0x1
    6c42:	c7e080e7          	jalr	-898(ra) # 78bc <mkdir>
    6c46:	87aa                	mv	a5,a0
    6c48:	eb89                	bnez	a5,6c5a <diskfull+0x218>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    6c4a:	00003517          	auipc	a0,0x3
    6c4e:	70650513          	addi	a0,a0,1798 # a350 <malloc+0x23e2>
    6c52:	00001097          	auipc	ra,0x1
    6c56:	12a080e7          	jalr	298(ra) # 7d7c <printf>

  unlink("diskfulldir");
    6c5a:	00003517          	auipc	a0,0x3
    6c5e:	6c650513          	addi	a0,a0,1734 # a320 <malloc+0x23b2>
    6c62:	00001097          	auipc	ra,0x1
    6c66:	c42080e7          	jalr	-958(ra) # 78a4 <unlink>

  for(int i = 0; i < nzz; i++){
    6c6a:	fc042e23          	sw	zero,-36(s0)
    6c6e:	a8ad                	j	6ce8 <diskfull+0x2a6>
    char name[32];
    name[0] = 'z';
    6c70:	07a00793          	li	a5,122
    6c74:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'z';
    6c78:	07a00793          	li	a5,122
    6c7c:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = '0' + (i / 32);
    6c80:	fdc42783          	lw	a5,-36(s0)
    6c84:	41f7d71b          	sraiw	a4,a5,0x1f
    6c88:	01b7571b          	srliw	a4,a4,0x1b
    6c8c:	9fb9                	addw	a5,a5,a4
    6c8e:	4057d79b          	sraiw	a5,a5,0x5
    6c92:	2781                	sext.w	a5,a5
    6c94:	0ff7f793          	zext.b	a5,a5
    6c98:	0307879b          	addiw	a5,a5,48
    6c9c:	0ff7f793          	zext.b	a5,a5
    6ca0:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + (i % 32);
    6ca4:	fdc42783          	lw	a5,-36(s0)
    6ca8:	873e                	mv	a4,a5
    6caa:	41f7579b          	sraiw	a5,a4,0x1f
    6cae:	01b7d79b          	srliw	a5,a5,0x1b
    6cb2:	9f3d                	addw	a4,a4,a5
    6cb4:	8b7d                	andi	a4,a4,31
    6cb6:	40f707bb          	subw	a5,a4,a5
    6cba:	2781                	sext.w	a5,a5
    6cbc:	0ff7f793          	zext.b	a5,a5
    6cc0:	0307879b          	addiw	a5,a5,48
    6cc4:	0ff7f793          	zext.b	a5,a5
    6cc8:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6ccc:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6cd0:	bc840793          	addi	a5,s0,-1080
    6cd4:	853e                	mv	a0,a5
    6cd6:	00001097          	auipc	ra,0x1
    6cda:	bce080e7          	jalr	-1074(ra) # 78a4 <unlink>
  for(int i = 0; i < nzz; i++){
    6cde:	fdc42783          	lw	a5,-36(s0)
    6ce2:	2785                	addiw	a5,a5,1
    6ce4:	fcf42e23          	sw	a5,-36(s0)
    6ce8:	fdc42783          	lw	a5,-36(s0)
    6cec:	873e                	mv	a4,a5
    6cee:	fd042783          	lw	a5,-48(s0)
    6cf2:	2701                	sext.w	a4,a4
    6cf4:	2781                	sext.w	a5,a5
    6cf6:	f6f74de3          	blt	a4,a5,6c70 <diskfull+0x22e>
  }

  for(int i = 0; i < fi; i++){
    6cfa:	fc042c23          	sw	zero,-40(s0)
    6cfe:	a0a9                	j	6d48 <diskfull+0x306>
    char name[32];
    name[0] = 'b';
    6d00:	06200793          	li	a5,98
    6d04:	bcf40423          	sb	a5,-1080(s0)
    name[1] = 'i';
    6d08:	06900793          	li	a5,105
    6d0c:	bcf404a3          	sb	a5,-1079(s0)
    name[2] = 'g';
    6d10:	06700793          	li	a5,103
    6d14:	bcf40523          	sb	a5,-1078(s0)
    name[3] = '0' + i;
    6d18:	fd842783          	lw	a5,-40(s0)
    6d1c:	0ff7f793          	zext.b	a5,a5
    6d20:	0307879b          	addiw	a5,a5,48
    6d24:	0ff7f793          	zext.b	a5,a5
    6d28:	bcf405a3          	sb	a5,-1077(s0)
    name[4] = '\0';
    6d2c:	bc040623          	sb	zero,-1076(s0)
    unlink(name);
    6d30:	bc840793          	addi	a5,s0,-1080
    6d34:	853e                	mv	a0,a5
    6d36:	00001097          	auipc	ra,0x1
    6d3a:	b6e080e7          	jalr	-1170(ra) # 78a4 <unlink>
  for(int i = 0; i < fi; i++){
    6d3e:	fd842783          	lw	a5,-40(s0)
    6d42:	2785                	addiw	a5,a5,1
    6d44:	fcf42c23          	sw	a5,-40(s0)
    6d48:	fd842783          	lw	a5,-40(s0)
    6d4c:	873e                	mv	a4,a5
    6d4e:	fec42783          	lw	a5,-20(s0)
    6d52:	2701                	sext.w	a4,a4
    6d54:	2781                	sext.w	a5,a5
    6d56:	faf745e3          	blt	a4,a5,6d00 <diskfull+0x2be>
  }
}
    6d5a:	0001                	nop
    6d5c:	0001                	nop
    6d5e:	46813083          	ld	ra,1128(sp)
    6d62:	46013403          	ld	s0,1120(sp)
    6d66:	47010113          	addi	sp,sp,1136
    6d6a:	8082                	ret

0000000000006d6c <outofinodes>:

void
outofinodes(char *s)
{
    6d6c:	715d                	addi	sp,sp,-80
    6d6e:	e486                	sd	ra,72(sp)
    6d70:	e0a2                	sd	s0,64(sp)
    6d72:	0880                	addi	s0,sp,80
    6d74:	faa43c23          	sd	a0,-72(s0)
  int nzz = 32*32;
    6d78:	40000793          	li	a5,1024
    6d7c:	fef42223          	sw	a5,-28(s0)
  for(int i = 0; i < nzz; i++){
    6d80:	fe042623          	sw	zero,-20(s0)
    6d84:	a06d                	j	6e2e <outofinodes+0xc2>
    char name[32];
    name[0] = 'z';
    6d86:	07a00793          	li	a5,122
    6d8a:	fcf40023          	sb	a5,-64(s0)
    name[1] = 'z';
    6d8e:	07a00793          	li	a5,122
    6d92:	fcf400a3          	sb	a5,-63(s0)
    name[2] = '0' + (i / 32);
    6d96:	fec42783          	lw	a5,-20(s0)
    6d9a:	41f7d71b          	sraiw	a4,a5,0x1f
    6d9e:	01b7571b          	srliw	a4,a4,0x1b
    6da2:	9fb9                	addw	a5,a5,a4
    6da4:	4057d79b          	sraiw	a5,a5,0x5
    6da8:	2781                	sext.w	a5,a5
    6daa:	0ff7f793          	zext.b	a5,a5
    6dae:	0307879b          	addiw	a5,a5,48
    6db2:	0ff7f793          	zext.b	a5,a5
    6db6:	fcf40123          	sb	a5,-62(s0)
    name[3] = '0' + (i % 32);
    6dba:	fec42783          	lw	a5,-20(s0)
    6dbe:	873e                	mv	a4,a5
    6dc0:	41f7579b          	sraiw	a5,a4,0x1f
    6dc4:	01b7d79b          	srliw	a5,a5,0x1b
    6dc8:	9f3d                	addw	a4,a4,a5
    6dca:	8b7d                	andi	a4,a4,31
    6dcc:	40f707bb          	subw	a5,a4,a5
    6dd0:	2781                	sext.w	a5,a5
    6dd2:	0ff7f793          	zext.b	a5,a5
    6dd6:	0307879b          	addiw	a5,a5,48
    6dda:	0ff7f793          	zext.b	a5,a5
    6dde:	fcf401a3          	sb	a5,-61(s0)
    name[4] = '\0';
    6de2:	fc040223          	sb	zero,-60(s0)
    unlink(name);
    6de6:	fc040793          	addi	a5,s0,-64
    6dea:	853e                	mv	a0,a5
    6dec:	00001097          	auipc	ra,0x1
    6df0:	ab8080e7          	jalr	-1352(ra) # 78a4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    6df4:	fc040793          	addi	a5,s0,-64
    6df8:	60200593          	li	a1,1538
    6dfc:	853e                	mv	a0,a5
    6dfe:	00001097          	auipc	ra,0x1
    6e02:	a96080e7          	jalr	-1386(ra) # 7894 <open>
    6e06:	87aa                	mv	a5,a0
    6e08:	fef42023          	sw	a5,-32(s0)
    if(fd < 0){
    6e0c:	fe042783          	lw	a5,-32(s0)
    6e10:	2781                	sext.w	a5,a5
    6e12:	0207c863          	bltz	a5,6e42 <outofinodes+0xd6>
      // failure is eventually expected.
      break;
    }
    close(fd);
    6e16:	fe042783          	lw	a5,-32(s0)
    6e1a:	853e                	mv	a0,a5
    6e1c:	00001097          	auipc	ra,0x1
    6e20:	a60080e7          	jalr	-1440(ra) # 787c <close>
  for(int i = 0; i < nzz; i++){
    6e24:	fec42783          	lw	a5,-20(s0)
    6e28:	2785                	addiw	a5,a5,1
    6e2a:	fef42623          	sw	a5,-20(s0)
    6e2e:	fec42783          	lw	a5,-20(s0)
    6e32:	873e                	mv	a4,a5
    6e34:	fe442783          	lw	a5,-28(s0)
    6e38:	2701                	sext.w	a4,a4
    6e3a:	2781                	sext.w	a5,a5
    6e3c:	f4f745e3          	blt	a4,a5,6d86 <outofinodes+0x1a>
    6e40:	a011                	j	6e44 <outofinodes+0xd8>
      break;
    6e42:	0001                	nop
  }

  for(int i = 0; i < nzz; i++){
    6e44:	fe042423          	sw	zero,-24(s0)
    6e48:	a8ad                	j	6ec2 <outofinodes+0x156>
    char name[32];
    name[0] = 'z';
    6e4a:	07a00793          	li	a5,122
    6e4e:	fcf40023          	sb	a5,-64(s0)
    name[1] = 'z';
    6e52:	07a00793          	li	a5,122
    6e56:	fcf400a3          	sb	a5,-63(s0)
    name[2] = '0' + (i / 32);
    6e5a:	fe842783          	lw	a5,-24(s0)
    6e5e:	41f7d71b          	sraiw	a4,a5,0x1f
    6e62:	01b7571b          	srliw	a4,a4,0x1b
    6e66:	9fb9                	addw	a5,a5,a4
    6e68:	4057d79b          	sraiw	a5,a5,0x5
    6e6c:	2781                	sext.w	a5,a5
    6e6e:	0ff7f793          	zext.b	a5,a5
    6e72:	0307879b          	addiw	a5,a5,48
    6e76:	0ff7f793          	zext.b	a5,a5
    6e7a:	fcf40123          	sb	a5,-62(s0)
    name[3] = '0' + (i % 32);
    6e7e:	fe842783          	lw	a5,-24(s0)
    6e82:	873e                	mv	a4,a5
    6e84:	41f7579b          	sraiw	a5,a4,0x1f
    6e88:	01b7d79b          	srliw	a5,a5,0x1b
    6e8c:	9f3d                	addw	a4,a4,a5
    6e8e:	8b7d                	andi	a4,a4,31
    6e90:	40f707bb          	subw	a5,a4,a5
    6e94:	2781                	sext.w	a5,a5
    6e96:	0ff7f793          	zext.b	a5,a5
    6e9a:	0307879b          	addiw	a5,a5,48
    6e9e:	0ff7f793          	zext.b	a5,a5
    6ea2:	fcf401a3          	sb	a5,-61(s0)
    name[4] = '\0';
    6ea6:	fc040223          	sb	zero,-60(s0)
    unlink(name);
    6eaa:	fc040793          	addi	a5,s0,-64
    6eae:	853e                	mv	a0,a5
    6eb0:	00001097          	auipc	ra,0x1
    6eb4:	9f4080e7          	jalr	-1548(ra) # 78a4 <unlink>
  for(int i = 0; i < nzz; i++){
    6eb8:	fe842783          	lw	a5,-24(s0)
    6ebc:	2785                	addiw	a5,a5,1
    6ebe:	fef42423          	sw	a5,-24(s0)
    6ec2:	fe842783          	lw	a5,-24(s0)
    6ec6:	873e                	mv	a4,a5
    6ec8:	fe442783          	lw	a5,-28(s0)
    6ecc:	2701                	sext.w	a4,a4
    6ece:	2781                	sext.w	a5,a5
    6ed0:	f6f74de3          	blt	a4,a5,6e4a <outofinodes+0xde>
  }
}
    6ed4:	0001                	nop
    6ed6:	0001                	nop
    6ed8:	60a6                	ld	ra,72(sp)
    6eda:	6406                	ld	s0,64(sp)
    6edc:	6161                	addi	sp,sp,80
    6ede:	8082                	ret

0000000000006ee0 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    6ee0:	7179                	addi	sp,sp,-48
    6ee2:	f406                	sd	ra,40(sp)
    6ee4:	f022                	sd	s0,32(sp)
    6ee6:	1800                	addi	s0,sp,48
    6ee8:	fca43c23          	sd	a0,-40(s0)
    6eec:	fcb43823          	sd	a1,-48(s0)
  int pid;
  int xstatus;

  printf("test %s: ", s);
    6ef0:	fd043583          	ld	a1,-48(s0)
    6ef4:	00003517          	auipc	a0,0x3
    6ef8:	4dc50513          	addi	a0,a0,1244 # a3d0 <malloc+0x2462>
    6efc:	00001097          	auipc	ra,0x1
    6f00:	e80080e7          	jalr	-384(ra) # 7d7c <printf>
  if((pid = fork()) < 0) {
    6f04:	00001097          	auipc	ra,0x1
    6f08:	948080e7          	jalr	-1720(ra) # 784c <fork>
    6f0c:	87aa                	mv	a5,a0
    6f0e:	fef42623          	sw	a5,-20(s0)
    6f12:	fec42783          	lw	a5,-20(s0)
    6f16:	2781                	sext.w	a5,a5
    6f18:	0007df63          	bgez	a5,6f36 <run+0x56>
    printf("runtest: fork error\n");
    6f1c:	00003517          	auipc	a0,0x3
    6f20:	4c450513          	addi	a0,a0,1220 # a3e0 <malloc+0x2472>
    6f24:	00001097          	auipc	ra,0x1
    6f28:	e58080e7          	jalr	-424(ra) # 7d7c <printf>
    exit(1);
    6f2c:	4505                	li	a0,1
    6f2e:	00001097          	auipc	ra,0x1
    6f32:	926080e7          	jalr	-1754(ra) # 7854 <exit>
  }
  if(pid == 0) {
    6f36:	fec42783          	lw	a5,-20(s0)
    6f3a:	2781                	sext.w	a5,a5
    6f3c:	eb99                	bnez	a5,6f52 <run+0x72>
    f(s);
    6f3e:	fd843783          	ld	a5,-40(s0)
    6f42:	fd043503          	ld	a0,-48(s0)
    6f46:	9782                	jalr	a5
    exit(0);
    6f48:	4501                	li	a0,0
    6f4a:	00001097          	auipc	ra,0x1
    6f4e:	90a080e7          	jalr	-1782(ra) # 7854 <exit>
  } else {
    wait(&xstatus);
    6f52:	fe840793          	addi	a5,s0,-24
    6f56:	853e                	mv	a0,a5
    6f58:	00001097          	auipc	ra,0x1
    6f5c:	904080e7          	jalr	-1788(ra) # 785c <wait>
    if(xstatus != 0)
    6f60:	fe842783          	lw	a5,-24(s0)
    6f64:	cb91                	beqz	a5,6f78 <run+0x98>
      printf("FAILED\n");
    6f66:	00003517          	auipc	a0,0x3
    6f6a:	49250513          	addi	a0,a0,1170 # a3f8 <malloc+0x248a>
    6f6e:	00001097          	auipc	ra,0x1
    6f72:	e0e080e7          	jalr	-498(ra) # 7d7c <printf>
    6f76:	a809                	j	6f88 <run+0xa8>
    else
      printf("OK\n");
    6f78:	00003517          	auipc	a0,0x3
    6f7c:	48850513          	addi	a0,a0,1160 # a400 <malloc+0x2492>
    6f80:	00001097          	auipc	ra,0x1
    6f84:	dfc080e7          	jalr	-516(ra) # 7d7c <printf>
    return xstatus == 0;
    6f88:	fe842783          	lw	a5,-24(s0)
    6f8c:	0017b793          	seqz	a5,a5
    6f90:	0ff7f793          	zext.b	a5,a5
    6f94:	2781                	sext.w	a5,a5
  }
}
    6f96:	853e                	mv	a0,a5
    6f98:	70a2                	ld	ra,40(sp)
    6f9a:	7402                	ld	s0,32(sp)
    6f9c:	6145                	addi	sp,sp,48
    6f9e:	8082                	ret

0000000000006fa0 <runtests>:

int
runtests(struct test *tests, char *justone) {
    6fa0:	7179                	addi	sp,sp,-48
    6fa2:	f406                	sd	ra,40(sp)
    6fa4:	f022                	sd	s0,32(sp)
    6fa6:	1800                	addi	s0,sp,48
    6fa8:	fca43c23          	sd	a0,-40(s0)
    6fac:	fcb43823          	sd	a1,-48(s0)
  for (struct test *t = tests; t->s != 0; t++) {
    6fb0:	fd843783          	ld	a5,-40(s0)
    6fb4:	fef43423          	sd	a5,-24(s0)
    6fb8:	a8a9                	j	7012 <runtests+0x72>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    6fba:	fd043783          	ld	a5,-48(s0)
    6fbe:	cf89                	beqz	a5,6fd8 <runtests+0x38>
    6fc0:	fe843783          	ld	a5,-24(s0)
    6fc4:	679c                	ld	a5,8(a5)
    6fc6:	fd043583          	ld	a1,-48(s0)
    6fca:	853e                	mv	a0,a5
    6fcc:	00000097          	auipc	ra,0x0
    6fd0:	440080e7          	jalr	1088(ra) # 740c <strcmp>
    6fd4:	87aa                	mv	a5,a0
    6fd6:	eb8d                	bnez	a5,7008 <runtests+0x68>
      if(!run(t->f, t->s)){
    6fd8:	fe843783          	ld	a5,-24(s0)
    6fdc:	6398                	ld	a4,0(a5)
    6fde:	fe843783          	ld	a5,-24(s0)
    6fe2:	679c                	ld	a5,8(a5)
    6fe4:	85be                	mv	a1,a5
    6fe6:	853a                	mv	a0,a4
    6fe8:	00000097          	auipc	ra,0x0
    6fec:	ef8080e7          	jalr	-264(ra) # 6ee0 <run>
    6ff0:	87aa                	mv	a5,a0
    6ff2:	eb99                	bnez	a5,7008 <runtests+0x68>
        printf("SOME TESTS FAILED\n");
    6ff4:	00003517          	auipc	a0,0x3
    6ff8:	41450513          	addi	a0,a0,1044 # a408 <malloc+0x249a>
    6ffc:	00001097          	auipc	ra,0x1
    7000:	d80080e7          	jalr	-640(ra) # 7d7c <printf>
        return 1;
    7004:	4785                	li	a5,1
    7006:	a819                	j	701c <runtests+0x7c>
  for (struct test *t = tests; t->s != 0; t++) {
    7008:	fe843783          	ld	a5,-24(s0)
    700c:	07c1                	addi	a5,a5,16
    700e:	fef43423          	sd	a5,-24(s0)
    7012:	fe843783          	ld	a5,-24(s0)
    7016:	679c                	ld	a5,8(a5)
    7018:	f3cd                	bnez	a5,6fba <runtests+0x1a>
      }
    }
  }
  return 0;
    701a:	4781                	li	a5,0
}
    701c:	853e                	mv	a0,a5
    701e:	70a2                	ld	ra,40(sp)
    7020:	7402                	ld	s0,32(sp)
    7022:	6145                	addi	sp,sp,48
    7024:	8082                	ret

0000000000007026 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    7026:	7139                	addi	sp,sp,-64
    7028:	fc06                	sd	ra,56(sp)
    702a:	f822                	sd	s0,48(sp)
    702c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    702e:	fd040793          	addi	a5,s0,-48
    7032:	853e                	mv	a0,a5
    7034:	00001097          	auipc	ra,0x1
    7038:	830080e7          	jalr	-2000(ra) # 7864 <pipe>
    703c:	87aa                	mv	a5,a0
    703e:	0007df63          	bgez	a5,705c <countfree+0x36>
    printf("pipe() failed in countfree()\n");
    7042:	00003517          	auipc	a0,0x3
    7046:	3de50513          	addi	a0,a0,990 # a420 <malloc+0x24b2>
    704a:	00001097          	auipc	ra,0x1
    704e:	d32080e7          	jalr	-718(ra) # 7d7c <printf>
    exit(1);
    7052:	4505                	li	a0,1
    7054:	00001097          	auipc	ra,0x1
    7058:	800080e7          	jalr	-2048(ra) # 7854 <exit>
  }

  int pid = fork();
    705c:	00000097          	auipc	ra,0x0
    7060:	7f0080e7          	jalr	2032(ra) # 784c <fork>
    7064:	87aa                	mv	a5,a0
    7066:	fef42423          	sw	a5,-24(s0)

  if(pid < 0){
    706a:	fe842783          	lw	a5,-24(s0)
    706e:	2781                	sext.w	a5,a5
    7070:	0007df63          	bgez	a5,708e <countfree+0x68>
    printf("fork failed in countfree()\n");
    7074:	00003517          	auipc	a0,0x3
    7078:	3cc50513          	addi	a0,a0,972 # a440 <malloc+0x24d2>
    707c:	00001097          	auipc	ra,0x1
    7080:	d00080e7          	jalr	-768(ra) # 7d7c <printf>
    exit(1);
    7084:	4505                	li	a0,1
    7086:	00000097          	auipc	ra,0x0
    708a:	7ce080e7          	jalr	1998(ra) # 7854 <exit>
  }

  if(pid == 0){
    708e:	fe842783          	lw	a5,-24(s0)
    7092:	2781                	sext.w	a5,a5
    7094:	e3d1                	bnez	a5,7118 <countfree+0xf2>
    close(fds[0]);
    7096:	fd042783          	lw	a5,-48(s0)
    709a:	853e                	mv	a0,a5
    709c:	00000097          	auipc	ra,0x0
    70a0:	7e0080e7          	jalr	2016(ra) # 787c <close>

    while(1){
      uint64 a = (uint64) sbrk(4096);
    70a4:	6505                	lui	a0,0x1
    70a6:	00001097          	auipc	ra,0x1
    70aa:	836080e7          	jalr	-1994(ra) # 78dc <sbrk>
    70ae:	87aa                	mv	a5,a0
    70b0:	fcf43c23          	sd	a5,-40(s0)
      if(a == 0xffffffffffffffff){
    70b4:	fd843703          	ld	a4,-40(s0)
    70b8:	57fd                	li	a5,-1
    70ba:	04f70963          	beq	a4,a5,710c <countfree+0xe6>
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    70be:	fd843703          	ld	a4,-40(s0)
    70c2:	6785                	lui	a5,0x1
    70c4:	17fd                	addi	a5,a5,-1 # fff <truncate3+0x1b1>
    70c6:	97ba                	add	a5,a5,a4
    70c8:	873e                	mv	a4,a5
    70ca:	4785                	li	a5,1
    70cc:	00f70023          	sb	a5,0(a4)

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    70d0:	fd442783          	lw	a5,-44(s0)
    70d4:	4605                	li	a2,1
    70d6:	00001597          	auipc	a1,0x1
    70da:	0ea58593          	addi	a1,a1,234 # 81c0 <malloc+0x252>
    70de:	853e                	mv	a0,a5
    70e0:	00000097          	auipc	ra,0x0
    70e4:	794080e7          	jalr	1940(ra) # 7874 <write>
    70e8:	87aa                	mv	a5,a0
    70ea:	873e                	mv	a4,a5
    70ec:	4785                	li	a5,1
    70ee:	faf70be3          	beq	a4,a5,70a4 <countfree+0x7e>
        printf("write() failed in countfree()\n");
    70f2:	00003517          	auipc	a0,0x3
    70f6:	36e50513          	addi	a0,a0,878 # a460 <malloc+0x24f2>
    70fa:	00001097          	auipc	ra,0x1
    70fe:	c82080e7          	jalr	-894(ra) # 7d7c <printf>
        exit(1);
    7102:	4505                	li	a0,1
    7104:	00000097          	auipc	ra,0x0
    7108:	750080e7          	jalr	1872(ra) # 7854 <exit>
        break;
    710c:	0001                	nop
      }
    }

    exit(0);
    710e:	4501                	li	a0,0
    7110:	00000097          	auipc	ra,0x0
    7114:	744080e7          	jalr	1860(ra) # 7854 <exit>
  }

  close(fds[1]);
    7118:	fd442783          	lw	a5,-44(s0)
    711c:	853e                	mv	a0,a5
    711e:	00000097          	auipc	ra,0x0
    7122:	75e080e7          	jalr	1886(ra) # 787c <close>

  int n = 0;
    7126:	fe042623          	sw	zero,-20(s0)
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    712a:	fd042783          	lw	a5,-48(s0)
    712e:	fcf40713          	addi	a4,s0,-49
    7132:	4605                	li	a2,1
    7134:	85ba                	mv	a1,a4
    7136:	853e                	mv	a0,a5
    7138:	00000097          	auipc	ra,0x0
    713c:	734080e7          	jalr	1844(ra) # 786c <read>
    7140:	87aa                	mv	a5,a0
    7142:	fef42223          	sw	a5,-28(s0)
    if(cc < 0){
    7146:	fe442783          	lw	a5,-28(s0)
    714a:	2781                	sext.w	a5,a5
    714c:	0007df63          	bgez	a5,716a <countfree+0x144>
      printf("read() failed in countfree()\n");
    7150:	00003517          	auipc	a0,0x3
    7154:	33050513          	addi	a0,a0,816 # a480 <malloc+0x2512>
    7158:	00001097          	auipc	ra,0x1
    715c:	c24080e7          	jalr	-988(ra) # 7d7c <printf>
      exit(1);
    7160:	4505                	li	a0,1
    7162:	00000097          	auipc	ra,0x0
    7166:	6f2080e7          	jalr	1778(ra) # 7854 <exit>
    }
    if(cc == 0)
    716a:	fe442783          	lw	a5,-28(s0)
    716e:	2781                	sext.w	a5,a5
    7170:	e385                	bnez	a5,7190 <countfree+0x16a>
      break;
    n += 1;
  }

  close(fds[0]);
    7172:	fd042783          	lw	a5,-48(s0)
    7176:	853e                	mv	a0,a5
    7178:	00000097          	auipc	ra,0x0
    717c:	704080e7          	jalr	1796(ra) # 787c <close>
  wait((int*)0);
    7180:	4501                	li	a0,0
    7182:	00000097          	auipc	ra,0x0
    7186:	6da080e7          	jalr	1754(ra) # 785c <wait>

  return n;
    718a:	fec42783          	lw	a5,-20(s0)
    718e:	a039                	j	719c <countfree+0x176>
    n += 1;
    7190:	fec42783          	lw	a5,-20(s0)
    7194:	2785                	addiw	a5,a5,1
    7196:	fef42623          	sw	a5,-20(s0)
  while(1){
    719a:	bf41                	j	712a <countfree+0x104>
}
    719c:	853e                	mv	a0,a5
    719e:	70e2                	ld	ra,56(sp)
    71a0:	7442                	ld	s0,48(sp)
    71a2:	6121                	addi	sp,sp,64
    71a4:	8082                	ret

00000000000071a6 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    71a6:	1101                	addi	sp,sp,-32
    71a8:	ec06                	sd	ra,24(sp)
    71aa:	e822                	sd	s0,16(sp)
    71ac:	1000                	addi	s0,sp,32
    71ae:	87aa                	mv	a5,a0
    71b0:	872e                	mv	a4,a1
    71b2:	fec43023          	sd	a2,-32(s0)
    71b6:	fef42623          	sw	a5,-20(s0)
    71ba:	87ba                	mv	a5,a4
    71bc:	fef42423          	sw	a5,-24(s0)
  do {
    printf("usertests starting\n");
    71c0:	00003517          	auipc	a0,0x3
    71c4:	2e050513          	addi	a0,a0,736 # a4a0 <malloc+0x2532>
    71c8:	00001097          	auipc	ra,0x1
    71cc:	bb4080e7          	jalr	-1100(ra) # 7d7c <printf>
    if (runtests(quicktests, justone)) {
    71d0:	fe043583          	ld	a1,-32(s0)
    71d4:	00005517          	auipc	a0,0x5
    71d8:	ccc50513          	addi	a0,a0,-820 # bea0 <quicktests>
    71dc:	00000097          	auipc	ra,0x0
    71e0:	dc4080e7          	jalr	-572(ra) # 6fa0 <runtests>
    71e4:	87aa                	mv	a5,a0
    71e6:	cb91                	beqz	a5,71fa <drivetests+0x54>
      if(continuous != 2) {
    71e8:	fe842783          	lw	a5,-24(s0)
    71ec:	0007871b          	sext.w	a4,a5
    71f0:	4789                	li	a5,2
    71f2:	00f70463          	beq	a4,a5,71fa <drivetests+0x54>
        return 1;
    71f6:	4785                	li	a5,1
    71f8:	a891                	j	724c <drivetests+0xa6>
      }
    }
    if(!quick) {
    71fa:	fec42783          	lw	a5,-20(s0)
    71fe:	2781                	sext.w	a5,a5
    7200:	e3a9                	bnez	a5,7242 <drivetests+0x9c>
      if (justone == 0)
    7202:	fe043783          	ld	a5,-32(s0)
    7206:	eb89                	bnez	a5,7218 <drivetests+0x72>
        printf("usertests slow tests starting\n");
    7208:	00003517          	auipc	a0,0x3
    720c:	2b050513          	addi	a0,a0,688 # a4b8 <malloc+0x254a>
    7210:	00001097          	auipc	ra,0x1
    7214:	b6c080e7          	jalr	-1172(ra) # 7d7c <printf>
      if (runtests(slowtests, justone)) {
    7218:	fe043583          	ld	a1,-32(s0)
    721c:	00005517          	auipc	a0,0x5
    7220:	03450513          	addi	a0,a0,52 # c250 <slowtests>
    7224:	00000097          	auipc	ra,0x0
    7228:	d7c080e7          	jalr	-644(ra) # 6fa0 <runtests>
    722c:	87aa                	mv	a5,a0
    722e:	cb91                	beqz	a5,7242 <drivetests+0x9c>
        if(continuous != 2) {
    7230:	fe842783          	lw	a5,-24(s0)
    7234:	0007871b          	sext.w	a4,a5
    7238:	4789                	li	a5,2
    723a:	00f70463          	beq	a4,a5,7242 <drivetests+0x9c>
          return 1;
    723e:	4785                	li	a5,1
    7240:	a031                	j	724c <drivetests+0xa6>
        }
      }
    }
  } while(continuous);
    7242:	fe842783          	lw	a5,-24(s0)
    7246:	2781                	sext.w	a5,a5
    7248:	ffa5                	bnez	a5,71c0 <drivetests+0x1a>
  return 0;
    724a:	4781                	li	a5,0
}
    724c:	853e                	mv	a0,a5
    724e:	60e2                	ld	ra,24(sp)
    7250:	6442                	ld	s0,16(sp)
    7252:	6105                	addi	sp,sp,32
    7254:	8082                	ret

0000000000007256 <main>:

int
main(int argc, char *argv[])
{
    7256:	7179                	addi	sp,sp,-48
    7258:	f406                	sd	ra,40(sp)
    725a:	f022                	sd	s0,32(sp)
    725c:	1800                	addi	s0,sp,48
    725e:	87aa                	mv	a5,a0
    7260:	fcb43823          	sd	a1,-48(s0)
    7264:	fcf42e23          	sw	a5,-36(s0)
  int continuous = 0;
    7268:	fe042623          	sw	zero,-20(s0)
  int quick = 0;
    726c:	fe042423          	sw	zero,-24(s0)
  char *justone = 0;
    7270:	fe043023          	sd	zero,-32(s0)

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    7274:	fdc42783          	lw	a5,-36(s0)
    7278:	0007871b          	sext.w	a4,a5
    727c:	4789                	li	a5,2
    727e:	02f71563          	bne	a4,a5,72a8 <main+0x52>
    7282:	fd043783          	ld	a5,-48(s0)
    7286:	07a1                	addi	a5,a5,8
    7288:	639c                	ld	a5,0(a5)
    728a:	00003597          	auipc	a1,0x3
    728e:	24e58593          	addi	a1,a1,590 # a4d8 <malloc+0x256a>
    7292:	853e                	mv	a0,a5
    7294:	00000097          	auipc	ra,0x0
    7298:	178080e7          	jalr	376(ra) # 740c <strcmp>
    729c:	87aa                	mv	a5,a0
    729e:	e789                	bnez	a5,72a8 <main+0x52>
    quick = 1;
    72a0:	4785                	li	a5,1
    72a2:	fef42423          	sw	a5,-24(s0)
    72a6:	a0c9                	j	7368 <main+0x112>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    72a8:	fdc42783          	lw	a5,-36(s0)
    72ac:	0007871b          	sext.w	a4,a5
    72b0:	4789                	li	a5,2
    72b2:	02f71563          	bne	a4,a5,72dc <main+0x86>
    72b6:	fd043783          	ld	a5,-48(s0)
    72ba:	07a1                	addi	a5,a5,8
    72bc:	639c                	ld	a5,0(a5)
    72be:	00003597          	auipc	a1,0x3
    72c2:	22258593          	addi	a1,a1,546 # a4e0 <malloc+0x2572>
    72c6:	853e                	mv	a0,a5
    72c8:	00000097          	auipc	ra,0x0
    72cc:	144080e7          	jalr	324(ra) # 740c <strcmp>
    72d0:	87aa                	mv	a5,a0
    72d2:	e789                	bnez	a5,72dc <main+0x86>
    continuous = 1;
    72d4:	4785                	li	a5,1
    72d6:	fef42623          	sw	a5,-20(s0)
    72da:	a079                	j	7368 <main+0x112>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    72dc:	fdc42783          	lw	a5,-36(s0)
    72e0:	0007871b          	sext.w	a4,a5
    72e4:	4789                	li	a5,2
    72e6:	02f71563          	bne	a4,a5,7310 <main+0xba>
    72ea:	fd043783          	ld	a5,-48(s0)
    72ee:	07a1                	addi	a5,a5,8
    72f0:	639c                	ld	a5,0(a5)
    72f2:	00003597          	auipc	a1,0x3
    72f6:	1f658593          	addi	a1,a1,502 # a4e8 <malloc+0x257a>
    72fa:	853e                	mv	a0,a5
    72fc:	00000097          	auipc	ra,0x0
    7300:	110080e7          	jalr	272(ra) # 740c <strcmp>
    7304:	87aa                	mv	a5,a0
    7306:	e789                	bnez	a5,7310 <main+0xba>
    continuous = 2;
    7308:	4789                	li	a5,2
    730a:	fef42623          	sw	a5,-20(s0)
    730e:	a8a9                	j	7368 <main+0x112>
  } else if(argc == 2 && argv[1][0] != '-'){
    7310:	fdc42783          	lw	a5,-36(s0)
    7314:	0007871b          	sext.w	a4,a5
    7318:	4789                	li	a5,2
    731a:	02f71363          	bne	a4,a5,7340 <main+0xea>
    731e:	fd043783          	ld	a5,-48(s0)
    7322:	07a1                	addi	a5,a5,8
    7324:	639c                	ld	a5,0(a5)
    7326:	0007c783          	lbu	a5,0(a5)
    732a:	873e                	mv	a4,a5
    732c:	02d00793          	li	a5,45
    7330:	00f70863          	beq	a4,a5,7340 <main+0xea>
    justone = argv[1];
    7334:	fd043783          	ld	a5,-48(s0)
    7338:	679c                	ld	a5,8(a5)
    733a:	fef43023          	sd	a5,-32(s0)
    733e:	a02d                	j	7368 <main+0x112>
  } else if(argc > 1){
    7340:	fdc42783          	lw	a5,-36(s0)
    7344:	0007871b          	sext.w	a4,a5
    7348:	4785                	li	a5,1
    734a:	00e7df63          	bge	a5,a4,7368 <main+0x112>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    734e:	00003517          	auipc	a0,0x3
    7352:	1a250513          	addi	a0,a0,418 # a4f0 <malloc+0x2582>
    7356:	00001097          	auipc	ra,0x1
    735a:	a26080e7          	jalr	-1498(ra) # 7d7c <printf>
    exit(1);
    735e:	4505                	li	a0,1
    7360:	00000097          	auipc	ra,0x0
    7364:	4f4080e7          	jalr	1268(ra) # 7854 <exit>
  }
  if (drivetests(quick, continuous, justone)) {
    7368:	fec42703          	lw	a4,-20(s0)
    736c:	fe842783          	lw	a5,-24(s0)
    7370:	fe043603          	ld	a2,-32(s0)
    7374:	85ba                	mv	a1,a4
    7376:	853e                	mv	a0,a5
    7378:	00000097          	auipc	ra,0x0
    737c:	e2e080e7          	jalr	-466(ra) # 71a6 <drivetests>
    7380:	87aa                	mv	a5,a0
    7382:	c791                	beqz	a5,738e <main+0x138>
    exit(1);
    7384:	4505                	li	a0,1
    7386:	00000097          	auipc	ra,0x0
    738a:	4ce080e7          	jalr	1230(ra) # 7854 <exit>
  }
  printf("ALL TESTS PASSED\n");
    738e:	00003517          	auipc	a0,0x3
    7392:	19250513          	addi	a0,a0,402 # a520 <malloc+0x25b2>
    7396:	00001097          	auipc	ra,0x1
    739a:	9e6080e7          	jalr	-1562(ra) # 7d7c <printf>
  exit(0);
    739e:	4501                	li	a0,0
    73a0:	00000097          	auipc	ra,0x0
    73a4:	4b4080e7          	jalr	1204(ra) # 7854 <exit>

00000000000073a8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    73a8:	1141                	addi	sp,sp,-16
    73aa:	e406                	sd	ra,8(sp)
    73ac:	e022                	sd	s0,0(sp)
    73ae:	0800                	addi	s0,sp,16
  extern int main();
  main();
    73b0:	00000097          	auipc	ra,0x0
    73b4:	ea6080e7          	jalr	-346(ra) # 7256 <main>
  exit(0);
    73b8:	4501                	li	a0,0
    73ba:	00000097          	auipc	ra,0x0
    73be:	49a080e7          	jalr	1178(ra) # 7854 <exit>

00000000000073c2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    73c2:	7179                	addi	sp,sp,-48
    73c4:	f422                	sd	s0,40(sp)
    73c6:	1800                	addi	s0,sp,48
    73c8:	fca43c23          	sd	a0,-40(s0)
    73cc:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
    73d0:	fd843783          	ld	a5,-40(s0)
    73d4:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
    73d8:	0001                	nop
    73da:	fd043703          	ld	a4,-48(s0)
    73de:	00170793          	addi	a5,a4,1
    73e2:	fcf43823          	sd	a5,-48(s0)
    73e6:	fd843783          	ld	a5,-40(s0)
    73ea:	00178693          	addi	a3,a5,1
    73ee:	fcd43c23          	sd	a3,-40(s0)
    73f2:	00074703          	lbu	a4,0(a4)
    73f6:	00e78023          	sb	a4,0(a5)
    73fa:	0007c783          	lbu	a5,0(a5)
    73fe:	fff1                	bnez	a5,73da <strcpy+0x18>
    ;
  return os;
    7400:	fe843783          	ld	a5,-24(s0)
}
    7404:	853e                	mv	a0,a5
    7406:	7422                	ld	s0,40(sp)
    7408:	6145                	addi	sp,sp,48
    740a:	8082                	ret

000000000000740c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    740c:	1101                	addi	sp,sp,-32
    740e:	ec22                	sd	s0,24(sp)
    7410:	1000                	addi	s0,sp,32
    7412:	fea43423          	sd	a0,-24(s0)
    7416:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
    741a:	a819                	j	7430 <strcmp+0x24>
    p++, q++;
    741c:	fe843783          	ld	a5,-24(s0)
    7420:	0785                	addi	a5,a5,1
    7422:	fef43423          	sd	a5,-24(s0)
    7426:	fe043783          	ld	a5,-32(s0)
    742a:	0785                	addi	a5,a5,1
    742c:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
    7430:	fe843783          	ld	a5,-24(s0)
    7434:	0007c783          	lbu	a5,0(a5)
    7438:	cb99                	beqz	a5,744e <strcmp+0x42>
    743a:	fe843783          	ld	a5,-24(s0)
    743e:	0007c703          	lbu	a4,0(a5)
    7442:	fe043783          	ld	a5,-32(s0)
    7446:	0007c783          	lbu	a5,0(a5)
    744a:	fcf709e3          	beq	a4,a5,741c <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
    744e:	fe843783          	ld	a5,-24(s0)
    7452:	0007c783          	lbu	a5,0(a5)
    7456:	0007871b          	sext.w	a4,a5
    745a:	fe043783          	ld	a5,-32(s0)
    745e:	0007c783          	lbu	a5,0(a5)
    7462:	2781                	sext.w	a5,a5
    7464:	40f707bb          	subw	a5,a4,a5
    7468:	2781                	sext.w	a5,a5
}
    746a:	853e                	mv	a0,a5
    746c:	6462                	ld	s0,24(sp)
    746e:	6105                	addi	sp,sp,32
    7470:	8082                	ret

0000000000007472 <strlen>:

uint
strlen(const char *s)
{
    7472:	7179                	addi	sp,sp,-48
    7474:	f422                	sd	s0,40(sp)
    7476:	1800                	addi	s0,sp,48
    7478:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    747c:	fe042623          	sw	zero,-20(s0)
    7480:	a031                	j	748c <strlen+0x1a>
    7482:	fec42783          	lw	a5,-20(s0)
    7486:	2785                	addiw	a5,a5,1
    7488:	fef42623          	sw	a5,-20(s0)
    748c:	fec42783          	lw	a5,-20(s0)
    7490:	fd843703          	ld	a4,-40(s0)
    7494:	97ba                	add	a5,a5,a4
    7496:	0007c783          	lbu	a5,0(a5)
    749a:	f7e5                	bnez	a5,7482 <strlen+0x10>
    ;
  return n;
    749c:	fec42783          	lw	a5,-20(s0)
}
    74a0:	853e                	mv	a0,a5
    74a2:	7422                	ld	s0,40(sp)
    74a4:	6145                	addi	sp,sp,48
    74a6:	8082                	ret

00000000000074a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    74a8:	7179                	addi	sp,sp,-48
    74aa:	f422                	sd	s0,40(sp)
    74ac:	1800                	addi	s0,sp,48
    74ae:	fca43c23          	sd	a0,-40(s0)
    74b2:	87ae                	mv	a5,a1
    74b4:	8732                	mv	a4,a2
    74b6:	fcf42a23          	sw	a5,-44(s0)
    74ba:	87ba                	mv	a5,a4
    74bc:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    74c0:	fd843783          	ld	a5,-40(s0)
    74c4:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    74c8:	fe042623          	sw	zero,-20(s0)
    74cc:	a00d                	j	74ee <memset+0x46>
    cdst[i] = c;
    74ce:	fec42783          	lw	a5,-20(s0)
    74d2:	fe043703          	ld	a4,-32(s0)
    74d6:	97ba                	add	a5,a5,a4
    74d8:	fd442703          	lw	a4,-44(s0)
    74dc:	0ff77713          	zext.b	a4,a4
    74e0:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    74e4:	fec42783          	lw	a5,-20(s0)
    74e8:	2785                	addiw	a5,a5,1
    74ea:	fef42623          	sw	a5,-20(s0)
    74ee:	fec42703          	lw	a4,-20(s0)
    74f2:	fd042783          	lw	a5,-48(s0)
    74f6:	2781                	sext.w	a5,a5
    74f8:	fcf76be3          	bltu	a4,a5,74ce <memset+0x26>
  }
  return dst;
    74fc:	fd843783          	ld	a5,-40(s0)
}
    7500:	853e                	mv	a0,a5
    7502:	7422                	ld	s0,40(sp)
    7504:	6145                	addi	sp,sp,48
    7506:	8082                	ret

0000000000007508 <strchr>:

char*
strchr(const char *s, char c)
{
    7508:	1101                	addi	sp,sp,-32
    750a:	ec22                	sd	s0,24(sp)
    750c:	1000                	addi	s0,sp,32
    750e:	fea43423          	sd	a0,-24(s0)
    7512:	87ae                	mv	a5,a1
    7514:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
    7518:	a01d                	j	753e <strchr+0x36>
    if(*s == c)
    751a:	fe843783          	ld	a5,-24(s0)
    751e:	0007c703          	lbu	a4,0(a5)
    7522:	fe744783          	lbu	a5,-25(s0)
    7526:	0ff7f793          	zext.b	a5,a5
    752a:	00e79563          	bne	a5,a4,7534 <strchr+0x2c>
      return (char*)s;
    752e:	fe843783          	ld	a5,-24(s0)
    7532:	a821                	j	754a <strchr+0x42>
  for(; *s; s++)
    7534:	fe843783          	ld	a5,-24(s0)
    7538:	0785                	addi	a5,a5,1
    753a:	fef43423          	sd	a5,-24(s0)
    753e:	fe843783          	ld	a5,-24(s0)
    7542:	0007c783          	lbu	a5,0(a5)
    7546:	fbf1                	bnez	a5,751a <strchr+0x12>
  return 0;
    7548:	4781                	li	a5,0
}
    754a:	853e                	mv	a0,a5
    754c:	6462                	ld	s0,24(sp)
    754e:	6105                	addi	sp,sp,32
    7550:	8082                	ret

0000000000007552 <gets>:

char*
gets(char *buf, int max)
{
    7552:	7179                	addi	sp,sp,-48
    7554:	f406                	sd	ra,40(sp)
    7556:	f022                	sd	s0,32(sp)
    7558:	1800                	addi	s0,sp,48
    755a:	fca43c23          	sd	a0,-40(s0)
    755e:	87ae                	mv	a5,a1
    7560:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    7564:	fe042623          	sw	zero,-20(s0)
    7568:	a8a1                	j	75c0 <gets+0x6e>
    cc = read(0, &c, 1);
    756a:	fe740793          	addi	a5,s0,-25
    756e:	4605                	li	a2,1
    7570:	85be                	mv	a1,a5
    7572:	4501                	li	a0,0
    7574:	00000097          	auipc	ra,0x0
    7578:	2f8080e7          	jalr	760(ra) # 786c <read>
    757c:	87aa                	mv	a5,a0
    757e:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
    7582:	fe842783          	lw	a5,-24(s0)
    7586:	2781                	sext.w	a5,a5
    7588:	04f05763          	blez	a5,75d6 <gets+0x84>
      break;
    buf[i++] = c;
    758c:	fec42783          	lw	a5,-20(s0)
    7590:	0017871b          	addiw	a4,a5,1
    7594:	fee42623          	sw	a4,-20(s0)
    7598:	873e                	mv	a4,a5
    759a:	fd843783          	ld	a5,-40(s0)
    759e:	97ba                	add	a5,a5,a4
    75a0:	fe744703          	lbu	a4,-25(s0)
    75a4:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
    75a8:	fe744783          	lbu	a5,-25(s0)
    75ac:	873e                	mv	a4,a5
    75ae:	47a9                	li	a5,10
    75b0:	02f70463          	beq	a4,a5,75d8 <gets+0x86>
    75b4:	fe744783          	lbu	a5,-25(s0)
    75b8:	873e                	mv	a4,a5
    75ba:	47b5                	li	a5,13
    75bc:	00f70e63          	beq	a4,a5,75d8 <gets+0x86>
  for(i=0; i+1 < max; ){
    75c0:	fec42783          	lw	a5,-20(s0)
    75c4:	2785                	addiw	a5,a5,1
    75c6:	0007871b          	sext.w	a4,a5
    75ca:	fd442783          	lw	a5,-44(s0)
    75ce:	2781                	sext.w	a5,a5
    75d0:	f8f74de3          	blt	a4,a5,756a <gets+0x18>
    75d4:	a011                	j	75d8 <gets+0x86>
      break;
    75d6:	0001                	nop
      break;
  }
  buf[i] = '\0';
    75d8:	fec42783          	lw	a5,-20(s0)
    75dc:	fd843703          	ld	a4,-40(s0)
    75e0:	97ba                	add	a5,a5,a4
    75e2:	00078023          	sb	zero,0(a5)
  return buf;
    75e6:	fd843783          	ld	a5,-40(s0)
}
    75ea:	853e                	mv	a0,a5
    75ec:	70a2                	ld	ra,40(sp)
    75ee:	7402                	ld	s0,32(sp)
    75f0:	6145                	addi	sp,sp,48
    75f2:	8082                	ret

00000000000075f4 <stat>:

int
stat(const char *n, struct stat *st)
{
    75f4:	7179                	addi	sp,sp,-48
    75f6:	f406                	sd	ra,40(sp)
    75f8:	f022                	sd	s0,32(sp)
    75fa:	1800                	addi	s0,sp,48
    75fc:	fca43c23          	sd	a0,-40(s0)
    7600:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    7604:	4581                	li	a1,0
    7606:	fd843503          	ld	a0,-40(s0)
    760a:	00000097          	auipc	ra,0x0
    760e:	28a080e7          	jalr	650(ra) # 7894 <open>
    7612:	87aa                	mv	a5,a0
    7614:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
    7618:	fec42783          	lw	a5,-20(s0)
    761c:	2781                	sext.w	a5,a5
    761e:	0007d463          	bgez	a5,7626 <stat+0x32>
    return -1;
    7622:	57fd                	li	a5,-1
    7624:	a035                	j	7650 <stat+0x5c>
  r = fstat(fd, st);
    7626:	fec42783          	lw	a5,-20(s0)
    762a:	fd043583          	ld	a1,-48(s0)
    762e:	853e                	mv	a0,a5
    7630:	00000097          	auipc	ra,0x0
    7634:	27c080e7          	jalr	636(ra) # 78ac <fstat>
    7638:	87aa                	mv	a5,a0
    763a:	fef42423          	sw	a5,-24(s0)
  close(fd);
    763e:	fec42783          	lw	a5,-20(s0)
    7642:	853e                	mv	a0,a5
    7644:	00000097          	auipc	ra,0x0
    7648:	238080e7          	jalr	568(ra) # 787c <close>
  return r;
    764c:	fe842783          	lw	a5,-24(s0)
}
    7650:	853e                	mv	a0,a5
    7652:	70a2                	ld	ra,40(sp)
    7654:	7402                	ld	s0,32(sp)
    7656:	6145                	addi	sp,sp,48
    7658:	8082                	ret

000000000000765a <atoi>:

int
atoi(const char *s)
{
    765a:	7179                	addi	sp,sp,-48
    765c:	f422                	sd	s0,40(sp)
    765e:	1800                	addi	s0,sp,48
    7660:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
    7664:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
    7668:	a81d                	j	769e <atoi+0x44>
    n = n*10 + *s++ - '0';
    766a:	fec42783          	lw	a5,-20(s0)
    766e:	873e                	mv	a4,a5
    7670:	87ba                	mv	a5,a4
    7672:	0027979b          	slliw	a5,a5,0x2
    7676:	9fb9                	addw	a5,a5,a4
    7678:	0017979b          	slliw	a5,a5,0x1
    767c:	0007871b          	sext.w	a4,a5
    7680:	fd843783          	ld	a5,-40(s0)
    7684:	00178693          	addi	a3,a5,1
    7688:	fcd43c23          	sd	a3,-40(s0)
    768c:	0007c783          	lbu	a5,0(a5)
    7690:	2781                	sext.w	a5,a5
    7692:	9fb9                	addw	a5,a5,a4
    7694:	2781                	sext.w	a5,a5
    7696:	fd07879b          	addiw	a5,a5,-48
    769a:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
    769e:	fd843783          	ld	a5,-40(s0)
    76a2:	0007c783          	lbu	a5,0(a5)
    76a6:	873e                	mv	a4,a5
    76a8:	02f00793          	li	a5,47
    76ac:	00e7fb63          	bgeu	a5,a4,76c2 <atoi+0x68>
    76b0:	fd843783          	ld	a5,-40(s0)
    76b4:	0007c783          	lbu	a5,0(a5)
    76b8:	873e                	mv	a4,a5
    76ba:	03900793          	li	a5,57
    76be:	fae7f6e3          	bgeu	a5,a4,766a <atoi+0x10>
  return n;
    76c2:	fec42783          	lw	a5,-20(s0)
}
    76c6:	853e                	mv	a0,a5
    76c8:	7422                	ld	s0,40(sp)
    76ca:	6145                	addi	sp,sp,48
    76cc:	8082                	ret

00000000000076ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    76ce:	7139                	addi	sp,sp,-64
    76d0:	fc22                	sd	s0,56(sp)
    76d2:	0080                	addi	s0,sp,64
    76d4:	fca43c23          	sd	a0,-40(s0)
    76d8:	fcb43823          	sd	a1,-48(s0)
    76dc:	87b2                	mv	a5,a2
    76de:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
    76e2:	fd843783          	ld	a5,-40(s0)
    76e6:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
    76ea:	fd043783          	ld	a5,-48(s0)
    76ee:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
    76f2:	fe043703          	ld	a4,-32(s0)
    76f6:	fe843783          	ld	a5,-24(s0)
    76fa:	02e7fc63          	bgeu	a5,a4,7732 <memmove+0x64>
    while(n-- > 0)
    76fe:	a00d                	j	7720 <memmove+0x52>
      *dst++ = *src++;
    7700:	fe043703          	ld	a4,-32(s0)
    7704:	00170793          	addi	a5,a4,1
    7708:	fef43023          	sd	a5,-32(s0)
    770c:	fe843783          	ld	a5,-24(s0)
    7710:	00178693          	addi	a3,a5,1
    7714:	fed43423          	sd	a3,-24(s0)
    7718:	00074703          	lbu	a4,0(a4)
    771c:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    7720:	fcc42783          	lw	a5,-52(s0)
    7724:	fff7871b          	addiw	a4,a5,-1
    7728:	fce42623          	sw	a4,-52(s0)
    772c:	fcf04ae3          	bgtz	a5,7700 <memmove+0x32>
    7730:	a891                	j	7784 <memmove+0xb6>
  } else {
    dst += n;
    7732:	fcc42783          	lw	a5,-52(s0)
    7736:	fe843703          	ld	a4,-24(s0)
    773a:	97ba                	add	a5,a5,a4
    773c:	fef43423          	sd	a5,-24(s0)
    src += n;
    7740:	fcc42783          	lw	a5,-52(s0)
    7744:	fe043703          	ld	a4,-32(s0)
    7748:	97ba                	add	a5,a5,a4
    774a:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    774e:	a01d                	j	7774 <memmove+0xa6>
      *--dst = *--src;
    7750:	fe043783          	ld	a5,-32(s0)
    7754:	17fd                	addi	a5,a5,-1
    7756:	fef43023          	sd	a5,-32(s0)
    775a:	fe843783          	ld	a5,-24(s0)
    775e:	17fd                	addi	a5,a5,-1
    7760:	fef43423          	sd	a5,-24(s0)
    7764:	fe043783          	ld	a5,-32(s0)
    7768:	0007c703          	lbu	a4,0(a5)
    776c:	fe843783          	ld	a5,-24(s0)
    7770:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    7774:	fcc42783          	lw	a5,-52(s0)
    7778:	fff7871b          	addiw	a4,a5,-1
    777c:	fce42623          	sw	a4,-52(s0)
    7780:	fcf048e3          	bgtz	a5,7750 <memmove+0x82>
  }
  return vdst;
    7784:	fd843783          	ld	a5,-40(s0)
}
    7788:	853e                	mv	a0,a5
    778a:	7462                	ld	s0,56(sp)
    778c:	6121                	addi	sp,sp,64
    778e:	8082                	ret

0000000000007790 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    7790:	7139                	addi	sp,sp,-64
    7792:	fc22                	sd	s0,56(sp)
    7794:	0080                	addi	s0,sp,64
    7796:	fca43c23          	sd	a0,-40(s0)
    779a:	fcb43823          	sd	a1,-48(s0)
    779e:	87b2                	mv	a5,a2
    77a0:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
    77a4:	fd843783          	ld	a5,-40(s0)
    77a8:	fef43423          	sd	a5,-24(s0)
    77ac:	fd043783          	ld	a5,-48(s0)
    77b0:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    77b4:	a0a1                	j	77fc <memcmp+0x6c>
    if (*p1 != *p2) {
    77b6:	fe843783          	ld	a5,-24(s0)
    77ba:	0007c703          	lbu	a4,0(a5)
    77be:	fe043783          	ld	a5,-32(s0)
    77c2:	0007c783          	lbu	a5,0(a5)
    77c6:	02f70163          	beq	a4,a5,77e8 <memcmp+0x58>
      return *p1 - *p2;
    77ca:	fe843783          	ld	a5,-24(s0)
    77ce:	0007c783          	lbu	a5,0(a5)
    77d2:	0007871b          	sext.w	a4,a5
    77d6:	fe043783          	ld	a5,-32(s0)
    77da:	0007c783          	lbu	a5,0(a5)
    77de:	2781                	sext.w	a5,a5
    77e0:	40f707bb          	subw	a5,a4,a5
    77e4:	2781                	sext.w	a5,a5
    77e6:	a01d                	j	780c <memcmp+0x7c>
    }
    p1++;
    77e8:	fe843783          	ld	a5,-24(s0)
    77ec:	0785                	addi	a5,a5,1
    77ee:	fef43423          	sd	a5,-24(s0)
    p2++;
    77f2:	fe043783          	ld	a5,-32(s0)
    77f6:	0785                	addi	a5,a5,1
    77f8:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
    77fc:	fcc42783          	lw	a5,-52(s0)
    7800:	fff7871b          	addiw	a4,a5,-1
    7804:	fce42623          	sw	a4,-52(s0)
    7808:	f7dd                	bnez	a5,77b6 <memcmp+0x26>
  }
  return 0;
    780a:	4781                	li	a5,0
}
    780c:	853e                	mv	a0,a5
    780e:	7462                	ld	s0,56(sp)
    7810:	6121                	addi	sp,sp,64
    7812:	8082                	ret

0000000000007814 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    7814:	7179                	addi	sp,sp,-48
    7816:	f406                	sd	ra,40(sp)
    7818:	f022                	sd	s0,32(sp)
    781a:	1800                	addi	s0,sp,48
    781c:	fea43423          	sd	a0,-24(s0)
    7820:	feb43023          	sd	a1,-32(s0)
    7824:	87b2                	mv	a5,a2
    7826:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    782a:	fdc42783          	lw	a5,-36(s0)
    782e:	863e                	mv	a2,a5
    7830:	fe043583          	ld	a1,-32(s0)
    7834:	fe843503          	ld	a0,-24(s0)
    7838:	00000097          	auipc	ra,0x0
    783c:	e96080e7          	jalr	-362(ra) # 76ce <memmove>
    7840:	87aa                	mv	a5,a0
}
    7842:	853e                	mv	a0,a5
    7844:	70a2                	ld	ra,40(sp)
    7846:	7402                	ld	s0,32(sp)
    7848:	6145                	addi	sp,sp,48
    784a:	8082                	ret

000000000000784c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    784c:	4885                	li	a7,1
 ecall
    784e:	00000073          	ecall
 ret
    7852:	8082                	ret

0000000000007854 <exit>:
.global exit
exit:
 li a7, SYS_exit
    7854:	4889                	li	a7,2
 ecall
    7856:	00000073          	ecall
 ret
    785a:	8082                	ret

000000000000785c <wait>:
.global wait
wait:
 li a7, SYS_wait
    785c:	488d                	li	a7,3
 ecall
    785e:	00000073          	ecall
 ret
    7862:	8082                	ret

0000000000007864 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    7864:	4891                	li	a7,4
 ecall
    7866:	00000073          	ecall
 ret
    786a:	8082                	ret

000000000000786c <read>:
.global read
read:
 li a7, SYS_read
    786c:	4895                	li	a7,5
 ecall
    786e:	00000073          	ecall
 ret
    7872:	8082                	ret

0000000000007874 <write>:
.global write
write:
 li a7, SYS_write
    7874:	48c1                	li	a7,16
 ecall
    7876:	00000073          	ecall
 ret
    787a:	8082                	ret

000000000000787c <close>:
.global close
close:
 li a7, SYS_close
    787c:	48d5                	li	a7,21
 ecall
    787e:	00000073          	ecall
 ret
    7882:	8082                	ret

0000000000007884 <kill>:
.global kill
kill:
 li a7, SYS_kill
    7884:	4899                	li	a7,6
 ecall
    7886:	00000073          	ecall
 ret
    788a:	8082                	ret

000000000000788c <exec>:
.global exec
exec:
 li a7, SYS_exec
    788c:	489d                	li	a7,7
 ecall
    788e:	00000073          	ecall
 ret
    7892:	8082                	ret

0000000000007894 <open>:
.global open
open:
 li a7, SYS_open
    7894:	48bd                	li	a7,15
 ecall
    7896:	00000073          	ecall
 ret
    789a:	8082                	ret

000000000000789c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    789c:	48c5                	li	a7,17
 ecall
    789e:	00000073          	ecall
 ret
    78a2:	8082                	ret

00000000000078a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    78a4:	48c9                	li	a7,18
 ecall
    78a6:	00000073          	ecall
 ret
    78aa:	8082                	ret

00000000000078ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    78ac:	48a1                	li	a7,8
 ecall
    78ae:	00000073          	ecall
 ret
    78b2:	8082                	ret

00000000000078b4 <link>:
.global link
link:
 li a7, SYS_link
    78b4:	48cd                	li	a7,19
 ecall
    78b6:	00000073          	ecall
 ret
    78ba:	8082                	ret

00000000000078bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    78bc:	48d1                	li	a7,20
 ecall
    78be:	00000073          	ecall
 ret
    78c2:	8082                	ret

00000000000078c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    78c4:	48a5                	li	a7,9
 ecall
    78c6:	00000073          	ecall
 ret
    78ca:	8082                	ret

00000000000078cc <dup>:
.global dup
dup:
 li a7, SYS_dup
    78cc:	48a9                	li	a7,10
 ecall
    78ce:	00000073          	ecall
 ret
    78d2:	8082                	ret

00000000000078d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    78d4:	48ad                	li	a7,11
 ecall
    78d6:	00000073          	ecall
 ret
    78da:	8082                	ret

00000000000078dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    78dc:	48b1                	li	a7,12
 ecall
    78de:	00000073          	ecall
 ret
    78e2:	8082                	ret

00000000000078e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    78e4:	48b5                	li	a7,13
 ecall
    78e6:	00000073          	ecall
 ret
    78ea:	8082                	ret

00000000000078ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    78ec:	48b9                	li	a7,14
 ecall
    78ee:	00000073          	ecall
 ret
    78f2:	8082                	ret

00000000000078f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    78f4:	1101                	addi	sp,sp,-32
    78f6:	ec06                	sd	ra,24(sp)
    78f8:	e822                	sd	s0,16(sp)
    78fa:	1000                	addi	s0,sp,32
    78fc:	87aa                	mv	a5,a0
    78fe:	872e                	mv	a4,a1
    7900:	fef42623          	sw	a5,-20(s0)
    7904:	87ba                	mv	a5,a4
    7906:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
    790a:	feb40713          	addi	a4,s0,-21
    790e:	fec42783          	lw	a5,-20(s0)
    7912:	4605                	li	a2,1
    7914:	85ba                	mv	a1,a4
    7916:	853e                	mv	a0,a5
    7918:	00000097          	auipc	ra,0x0
    791c:	f5c080e7          	jalr	-164(ra) # 7874 <write>
}
    7920:	0001                	nop
    7922:	60e2                	ld	ra,24(sp)
    7924:	6442                	ld	s0,16(sp)
    7926:	6105                	addi	sp,sp,32
    7928:	8082                	ret

000000000000792a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    792a:	7139                	addi	sp,sp,-64
    792c:	fc06                	sd	ra,56(sp)
    792e:	f822                	sd	s0,48(sp)
    7930:	0080                	addi	s0,sp,64
    7932:	87aa                	mv	a5,a0
    7934:	8736                	mv	a4,a3
    7936:	fcf42623          	sw	a5,-52(s0)
    793a:	87ae                	mv	a5,a1
    793c:	fcf42423          	sw	a5,-56(s0)
    7940:	87b2                	mv	a5,a2
    7942:	fcf42223          	sw	a5,-60(s0)
    7946:	87ba                	mv	a5,a4
    7948:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    794c:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
    7950:	fc042783          	lw	a5,-64(s0)
    7954:	2781                	sext.w	a5,a5
    7956:	c38d                	beqz	a5,7978 <printint+0x4e>
    7958:	fc842783          	lw	a5,-56(s0)
    795c:	2781                	sext.w	a5,a5
    795e:	0007dd63          	bgez	a5,7978 <printint+0x4e>
    neg = 1;
    7962:	4785                	li	a5,1
    7964:	fef42423          	sw	a5,-24(s0)
    x = -xx;
    7968:	fc842783          	lw	a5,-56(s0)
    796c:	40f007bb          	negw	a5,a5
    7970:	2781                	sext.w	a5,a5
    7972:	fef42223          	sw	a5,-28(s0)
    7976:	a029                	j	7980 <printint+0x56>
  } else {
    x = xx;
    7978:	fc842783          	lw	a5,-56(s0)
    797c:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
    7980:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
    7984:	fc442783          	lw	a5,-60(s0)
    7988:	fe442703          	lw	a4,-28(s0)
    798c:	02f777bb          	remuw	a5,a4,a5
    7990:	0007861b          	sext.w	a2,a5
    7994:	fec42783          	lw	a5,-20(s0)
    7998:	0017871b          	addiw	a4,a5,1
    799c:	fee42623          	sw	a4,-20(s0)
    79a0:	00005697          	auipc	a3,0x5
    79a4:	92068693          	addi	a3,a3,-1760 # c2c0 <digits>
    79a8:	02061713          	slli	a4,a2,0x20
    79ac:	9301                	srli	a4,a4,0x20
    79ae:	9736                	add	a4,a4,a3
    79b0:	00074703          	lbu	a4,0(a4)
    79b4:	17c1                	addi	a5,a5,-16
    79b6:	97a2                	add	a5,a5,s0
    79b8:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
    79bc:	fc442783          	lw	a5,-60(s0)
    79c0:	fe442703          	lw	a4,-28(s0)
    79c4:	02f757bb          	divuw	a5,a4,a5
    79c8:	fef42223          	sw	a5,-28(s0)
    79cc:	fe442783          	lw	a5,-28(s0)
    79d0:	2781                	sext.w	a5,a5
    79d2:	fbcd                	bnez	a5,7984 <printint+0x5a>
  if(neg)
    79d4:	fe842783          	lw	a5,-24(s0)
    79d8:	2781                	sext.w	a5,a5
    79da:	cf85                	beqz	a5,7a12 <printint+0xe8>
    buf[i++] = '-';
    79dc:	fec42783          	lw	a5,-20(s0)
    79e0:	0017871b          	addiw	a4,a5,1
    79e4:	fee42623          	sw	a4,-20(s0)
    79e8:	17c1                	addi	a5,a5,-16
    79ea:	97a2                	add	a5,a5,s0
    79ec:	02d00713          	li	a4,45
    79f0:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
    79f4:	a839                	j	7a12 <printint+0xe8>
    putc(fd, buf[i]);
    79f6:	fec42783          	lw	a5,-20(s0)
    79fa:	17c1                	addi	a5,a5,-16
    79fc:	97a2                	add	a5,a5,s0
    79fe:	fe07c703          	lbu	a4,-32(a5)
    7a02:	fcc42783          	lw	a5,-52(s0)
    7a06:	85ba                	mv	a1,a4
    7a08:	853e                	mv	a0,a5
    7a0a:	00000097          	auipc	ra,0x0
    7a0e:	eea080e7          	jalr	-278(ra) # 78f4 <putc>
  while(--i >= 0)
    7a12:	fec42783          	lw	a5,-20(s0)
    7a16:	37fd                	addiw	a5,a5,-1
    7a18:	fef42623          	sw	a5,-20(s0)
    7a1c:	fec42783          	lw	a5,-20(s0)
    7a20:	2781                	sext.w	a5,a5
    7a22:	fc07dae3          	bgez	a5,79f6 <printint+0xcc>
}
    7a26:	0001                	nop
    7a28:	0001                	nop
    7a2a:	70e2                	ld	ra,56(sp)
    7a2c:	7442                	ld	s0,48(sp)
    7a2e:	6121                	addi	sp,sp,64
    7a30:	8082                	ret

0000000000007a32 <printptr>:

static void
printptr(int fd, uint64 x) {
    7a32:	7179                	addi	sp,sp,-48
    7a34:	f406                	sd	ra,40(sp)
    7a36:	f022                	sd	s0,32(sp)
    7a38:	1800                	addi	s0,sp,48
    7a3a:	87aa                	mv	a5,a0
    7a3c:	fcb43823          	sd	a1,-48(s0)
    7a40:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
    7a44:	fdc42783          	lw	a5,-36(s0)
    7a48:	03000593          	li	a1,48
    7a4c:	853e                	mv	a0,a5
    7a4e:	00000097          	auipc	ra,0x0
    7a52:	ea6080e7          	jalr	-346(ra) # 78f4 <putc>
  putc(fd, 'x');
    7a56:	fdc42783          	lw	a5,-36(s0)
    7a5a:	07800593          	li	a1,120
    7a5e:	853e                	mv	a0,a5
    7a60:	00000097          	auipc	ra,0x0
    7a64:	e94080e7          	jalr	-364(ra) # 78f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7a68:	fe042623          	sw	zero,-20(s0)
    7a6c:	a82d                	j	7aa6 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    7a6e:	fd043783          	ld	a5,-48(s0)
    7a72:	93f1                	srli	a5,a5,0x3c
    7a74:	00005717          	auipc	a4,0x5
    7a78:	84c70713          	addi	a4,a4,-1972 # c2c0 <digits>
    7a7c:	97ba                	add	a5,a5,a4
    7a7e:	0007c703          	lbu	a4,0(a5)
    7a82:	fdc42783          	lw	a5,-36(s0)
    7a86:	85ba                	mv	a1,a4
    7a88:	853e                	mv	a0,a5
    7a8a:	00000097          	auipc	ra,0x0
    7a8e:	e6a080e7          	jalr	-406(ra) # 78f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    7a92:	fec42783          	lw	a5,-20(s0)
    7a96:	2785                	addiw	a5,a5,1
    7a98:	fef42623          	sw	a5,-20(s0)
    7a9c:	fd043783          	ld	a5,-48(s0)
    7aa0:	0792                	slli	a5,a5,0x4
    7aa2:	fcf43823          	sd	a5,-48(s0)
    7aa6:	fec42783          	lw	a5,-20(s0)
    7aaa:	873e                	mv	a4,a5
    7aac:	47bd                	li	a5,15
    7aae:	fce7f0e3          	bgeu	a5,a4,7a6e <printptr+0x3c>
}
    7ab2:	0001                	nop
    7ab4:	0001                	nop
    7ab6:	70a2                	ld	ra,40(sp)
    7ab8:	7402                	ld	s0,32(sp)
    7aba:	6145                	addi	sp,sp,48
    7abc:	8082                	ret

0000000000007abe <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    7abe:	715d                	addi	sp,sp,-80
    7ac0:	e486                	sd	ra,72(sp)
    7ac2:	e0a2                	sd	s0,64(sp)
    7ac4:	0880                	addi	s0,sp,80
    7ac6:	87aa                	mv	a5,a0
    7ac8:	fcb43023          	sd	a1,-64(s0)
    7acc:	fac43c23          	sd	a2,-72(s0)
    7ad0:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
    7ad4:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7ad8:	fe042223          	sw	zero,-28(s0)
    7adc:	a42d                	j	7d06 <vprintf+0x248>
    c = fmt[i] & 0xff;
    7ade:	fe442783          	lw	a5,-28(s0)
    7ae2:	fc043703          	ld	a4,-64(s0)
    7ae6:	97ba                	add	a5,a5,a4
    7ae8:	0007c783          	lbu	a5,0(a5)
    7aec:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
    7af0:	fe042783          	lw	a5,-32(s0)
    7af4:	2781                	sext.w	a5,a5
    7af6:	eb9d                	bnez	a5,7b2c <vprintf+0x6e>
      if(c == '%'){
    7af8:	fdc42783          	lw	a5,-36(s0)
    7afc:	0007871b          	sext.w	a4,a5
    7b00:	02500793          	li	a5,37
    7b04:	00f71763          	bne	a4,a5,7b12 <vprintf+0x54>
        state = '%';
    7b08:	02500793          	li	a5,37
    7b0c:	fef42023          	sw	a5,-32(s0)
    7b10:	a2f5                	j	7cfc <vprintf+0x23e>
      } else {
        putc(fd, c);
    7b12:	fdc42783          	lw	a5,-36(s0)
    7b16:	0ff7f713          	zext.b	a4,a5
    7b1a:	fcc42783          	lw	a5,-52(s0)
    7b1e:	85ba                	mv	a1,a4
    7b20:	853e                	mv	a0,a5
    7b22:	00000097          	auipc	ra,0x0
    7b26:	dd2080e7          	jalr	-558(ra) # 78f4 <putc>
    7b2a:	aac9                	j	7cfc <vprintf+0x23e>
      }
    } else if(state == '%'){
    7b2c:	fe042783          	lw	a5,-32(s0)
    7b30:	0007871b          	sext.w	a4,a5
    7b34:	02500793          	li	a5,37
    7b38:	1cf71263          	bne	a4,a5,7cfc <vprintf+0x23e>
      if(c == 'd'){
    7b3c:	fdc42783          	lw	a5,-36(s0)
    7b40:	0007871b          	sext.w	a4,a5
    7b44:	06400793          	li	a5,100
    7b48:	02f71463          	bne	a4,a5,7b70 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
    7b4c:	fb843783          	ld	a5,-72(s0)
    7b50:	00878713          	addi	a4,a5,8
    7b54:	fae43c23          	sd	a4,-72(s0)
    7b58:	4398                	lw	a4,0(a5)
    7b5a:	fcc42783          	lw	a5,-52(s0)
    7b5e:	4685                	li	a3,1
    7b60:	4629                	li	a2,10
    7b62:	85ba                	mv	a1,a4
    7b64:	853e                	mv	a0,a5
    7b66:	00000097          	auipc	ra,0x0
    7b6a:	dc4080e7          	jalr	-572(ra) # 792a <printint>
    7b6e:	a269                	j	7cf8 <vprintf+0x23a>
      } else if(c == 'l') {
    7b70:	fdc42783          	lw	a5,-36(s0)
    7b74:	0007871b          	sext.w	a4,a5
    7b78:	06c00793          	li	a5,108
    7b7c:	02f71663          	bne	a4,a5,7ba8 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
    7b80:	fb843783          	ld	a5,-72(s0)
    7b84:	00878713          	addi	a4,a5,8
    7b88:	fae43c23          	sd	a4,-72(s0)
    7b8c:	639c                	ld	a5,0(a5)
    7b8e:	0007871b          	sext.w	a4,a5
    7b92:	fcc42783          	lw	a5,-52(s0)
    7b96:	4681                	li	a3,0
    7b98:	4629                	li	a2,10
    7b9a:	85ba                	mv	a1,a4
    7b9c:	853e                	mv	a0,a5
    7b9e:	00000097          	auipc	ra,0x0
    7ba2:	d8c080e7          	jalr	-628(ra) # 792a <printint>
    7ba6:	aa89                	j	7cf8 <vprintf+0x23a>
      } else if(c == 'x') {
    7ba8:	fdc42783          	lw	a5,-36(s0)
    7bac:	0007871b          	sext.w	a4,a5
    7bb0:	07800793          	li	a5,120
    7bb4:	02f71463          	bne	a4,a5,7bdc <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
    7bb8:	fb843783          	ld	a5,-72(s0)
    7bbc:	00878713          	addi	a4,a5,8
    7bc0:	fae43c23          	sd	a4,-72(s0)
    7bc4:	4398                	lw	a4,0(a5)
    7bc6:	fcc42783          	lw	a5,-52(s0)
    7bca:	4681                	li	a3,0
    7bcc:	4641                	li	a2,16
    7bce:	85ba                	mv	a1,a4
    7bd0:	853e                	mv	a0,a5
    7bd2:	00000097          	auipc	ra,0x0
    7bd6:	d58080e7          	jalr	-680(ra) # 792a <printint>
    7bda:	aa39                	j	7cf8 <vprintf+0x23a>
      } else if(c == 'p') {
    7bdc:	fdc42783          	lw	a5,-36(s0)
    7be0:	0007871b          	sext.w	a4,a5
    7be4:	07000793          	li	a5,112
    7be8:	02f71263          	bne	a4,a5,7c0c <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
    7bec:	fb843783          	ld	a5,-72(s0)
    7bf0:	00878713          	addi	a4,a5,8
    7bf4:	fae43c23          	sd	a4,-72(s0)
    7bf8:	6398                	ld	a4,0(a5)
    7bfa:	fcc42783          	lw	a5,-52(s0)
    7bfe:	85ba                	mv	a1,a4
    7c00:	853e                	mv	a0,a5
    7c02:	00000097          	auipc	ra,0x0
    7c06:	e30080e7          	jalr	-464(ra) # 7a32 <printptr>
    7c0a:	a0fd                	j	7cf8 <vprintf+0x23a>
      } else if(c == 's'){
    7c0c:	fdc42783          	lw	a5,-36(s0)
    7c10:	0007871b          	sext.w	a4,a5
    7c14:	07300793          	li	a5,115
    7c18:	04f71c63          	bne	a4,a5,7c70 <vprintf+0x1b2>
        s = va_arg(ap, char*);
    7c1c:	fb843783          	ld	a5,-72(s0)
    7c20:	00878713          	addi	a4,a5,8
    7c24:	fae43c23          	sd	a4,-72(s0)
    7c28:	639c                	ld	a5,0(a5)
    7c2a:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
    7c2e:	fe843783          	ld	a5,-24(s0)
    7c32:	eb8d                	bnez	a5,7c64 <vprintf+0x1a6>
          s = "(null)";
    7c34:	00003797          	auipc	a5,0x3
    7c38:	90478793          	addi	a5,a5,-1788 # a538 <malloc+0x25ca>
    7c3c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7c40:	a015                	j	7c64 <vprintf+0x1a6>
          putc(fd, *s);
    7c42:	fe843783          	ld	a5,-24(s0)
    7c46:	0007c703          	lbu	a4,0(a5)
    7c4a:	fcc42783          	lw	a5,-52(s0)
    7c4e:	85ba                	mv	a1,a4
    7c50:	853e                	mv	a0,a5
    7c52:	00000097          	auipc	ra,0x0
    7c56:	ca2080e7          	jalr	-862(ra) # 78f4 <putc>
          s++;
    7c5a:	fe843783          	ld	a5,-24(s0)
    7c5e:	0785                	addi	a5,a5,1
    7c60:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
    7c64:	fe843783          	ld	a5,-24(s0)
    7c68:	0007c783          	lbu	a5,0(a5)
    7c6c:	fbf9                	bnez	a5,7c42 <vprintf+0x184>
    7c6e:	a069                	j	7cf8 <vprintf+0x23a>
        }
      } else if(c == 'c'){
    7c70:	fdc42783          	lw	a5,-36(s0)
    7c74:	0007871b          	sext.w	a4,a5
    7c78:	06300793          	li	a5,99
    7c7c:	02f71463          	bne	a4,a5,7ca4 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
    7c80:	fb843783          	ld	a5,-72(s0)
    7c84:	00878713          	addi	a4,a5,8
    7c88:	fae43c23          	sd	a4,-72(s0)
    7c8c:	439c                	lw	a5,0(a5)
    7c8e:	0ff7f713          	zext.b	a4,a5
    7c92:	fcc42783          	lw	a5,-52(s0)
    7c96:	85ba                	mv	a1,a4
    7c98:	853e                	mv	a0,a5
    7c9a:	00000097          	auipc	ra,0x0
    7c9e:	c5a080e7          	jalr	-934(ra) # 78f4 <putc>
    7ca2:	a899                	j	7cf8 <vprintf+0x23a>
      } else if(c == '%'){
    7ca4:	fdc42783          	lw	a5,-36(s0)
    7ca8:	0007871b          	sext.w	a4,a5
    7cac:	02500793          	li	a5,37
    7cb0:	00f71f63          	bne	a4,a5,7cce <vprintf+0x210>
        putc(fd, c);
    7cb4:	fdc42783          	lw	a5,-36(s0)
    7cb8:	0ff7f713          	zext.b	a4,a5
    7cbc:	fcc42783          	lw	a5,-52(s0)
    7cc0:	85ba                	mv	a1,a4
    7cc2:	853e                	mv	a0,a5
    7cc4:	00000097          	auipc	ra,0x0
    7cc8:	c30080e7          	jalr	-976(ra) # 78f4 <putc>
    7ccc:	a035                	j	7cf8 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    7cce:	fcc42783          	lw	a5,-52(s0)
    7cd2:	02500593          	li	a1,37
    7cd6:	853e                	mv	a0,a5
    7cd8:	00000097          	auipc	ra,0x0
    7cdc:	c1c080e7          	jalr	-996(ra) # 78f4 <putc>
        putc(fd, c);
    7ce0:	fdc42783          	lw	a5,-36(s0)
    7ce4:	0ff7f713          	zext.b	a4,a5
    7ce8:	fcc42783          	lw	a5,-52(s0)
    7cec:	85ba                	mv	a1,a4
    7cee:	853e                	mv	a0,a5
    7cf0:	00000097          	auipc	ra,0x0
    7cf4:	c04080e7          	jalr	-1020(ra) # 78f4 <putc>
      }
      state = 0;
    7cf8:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
    7cfc:	fe442783          	lw	a5,-28(s0)
    7d00:	2785                	addiw	a5,a5,1
    7d02:	fef42223          	sw	a5,-28(s0)
    7d06:	fe442783          	lw	a5,-28(s0)
    7d0a:	fc043703          	ld	a4,-64(s0)
    7d0e:	97ba                	add	a5,a5,a4
    7d10:	0007c783          	lbu	a5,0(a5)
    7d14:	dc0795e3          	bnez	a5,7ade <vprintf+0x20>
    }
  }
}
    7d18:	0001                	nop
    7d1a:	0001                	nop
    7d1c:	60a6                	ld	ra,72(sp)
    7d1e:	6406                	ld	s0,64(sp)
    7d20:	6161                	addi	sp,sp,80
    7d22:	8082                	ret

0000000000007d24 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    7d24:	7159                	addi	sp,sp,-112
    7d26:	fc06                	sd	ra,56(sp)
    7d28:	f822                	sd	s0,48(sp)
    7d2a:	0080                	addi	s0,sp,64
    7d2c:	fcb43823          	sd	a1,-48(s0)
    7d30:	e010                	sd	a2,0(s0)
    7d32:	e414                	sd	a3,8(s0)
    7d34:	e818                	sd	a4,16(s0)
    7d36:	ec1c                	sd	a5,24(s0)
    7d38:	03043023          	sd	a6,32(s0)
    7d3c:	03143423          	sd	a7,40(s0)
    7d40:	87aa                	mv	a5,a0
    7d42:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
    7d46:	03040793          	addi	a5,s0,48
    7d4a:	fcf43423          	sd	a5,-56(s0)
    7d4e:	fc843783          	ld	a5,-56(s0)
    7d52:	fd078793          	addi	a5,a5,-48
    7d56:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
    7d5a:	fe843703          	ld	a4,-24(s0)
    7d5e:	fdc42783          	lw	a5,-36(s0)
    7d62:	863a                	mv	a2,a4
    7d64:	fd043583          	ld	a1,-48(s0)
    7d68:	853e                	mv	a0,a5
    7d6a:	00000097          	auipc	ra,0x0
    7d6e:	d54080e7          	jalr	-684(ra) # 7abe <vprintf>
}
    7d72:	0001                	nop
    7d74:	70e2                	ld	ra,56(sp)
    7d76:	7442                	ld	s0,48(sp)
    7d78:	6165                	addi	sp,sp,112
    7d7a:	8082                	ret

0000000000007d7c <printf>:

void
printf(const char *fmt, ...)
{
    7d7c:	7159                	addi	sp,sp,-112
    7d7e:	f406                	sd	ra,40(sp)
    7d80:	f022                	sd	s0,32(sp)
    7d82:	1800                	addi	s0,sp,48
    7d84:	fca43c23          	sd	a0,-40(s0)
    7d88:	e40c                	sd	a1,8(s0)
    7d8a:	e810                	sd	a2,16(s0)
    7d8c:	ec14                	sd	a3,24(s0)
    7d8e:	f018                	sd	a4,32(s0)
    7d90:	f41c                	sd	a5,40(s0)
    7d92:	03043823          	sd	a6,48(s0)
    7d96:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    7d9a:	04040793          	addi	a5,s0,64
    7d9e:	fcf43823          	sd	a5,-48(s0)
    7da2:	fd043783          	ld	a5,-48(s0)
    7da6:	fc878793          	addi	a5,a5,-56
    7daa:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
    7dae:	fe843783          	ld	a5,-24(s0)
    7db2:	863e                	mv	a2,a5
    7db4:	fd843583          	ld	a1,-40(s0)
    7db8:	4505                	li	a0,1
    7dba:	00000097          	auipc	ra,0x0
    7dbe:	d04080e7          	jalr	-764(ra) # 7abe <vprintf>
}
    7dc2:	0001                	nop
    7dc4:	70a2                	ld	ra,40(sp)
    7dc6:	7402                	ld	s0,32(sp)
    7dc8:	6165                	addi	sp,sp,112
    7dca:	8082                	ret

0000000000007dcc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    7dcc:	7179                	addi	sp,sp,-48
    7dce:	f422                	sd	s0,40(sp)
    7dd0:	1800                	addi	s0,sp,48
    7dd2:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    7dd6:	fd843783          	ld	a5,-40(s0)
    7dda:	17c1                	addi	a5,a5,-16
    7ddc:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    7de0:	0000b797          	auipc	a5,0xb
    7de4:	d2878793          	addi	a5,a5,-728 # 12b08 <freep>
    7de8:	639c                	ld	a5,0(a5)
    7dea:	fef43423          	sd	a5,-24(s0)
    7dee:	a815                	j	7e22 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    7df0:	fe843783          	ld	a5,-24(s0)
    7df4:	639c                	ld	a5,0(a5)
    7df6:	fe843703          	ld	a4,-24(s0)
    7dfa:	00f76f63          	bltu	a4,a5,7e18 <free+0x4c>
    7dfe:	fe043703          	ld	a4,-32(s0)
    7e02:	fe843783          	ld	a5,-24(s0)
    7e06:	02e7eb63          	bltu	a5,a4,7e3c <free+0x70>
    7e0a:	fe843783          	ld	a5,-24(s0)
    7e0e:	639c                	ld	a5,0(a5)
    7e10:	fe043703          	ld	a4,-32(s0)
    7e14:	02f76463          	bltu	a4,a5,7e3c <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    7e18:	fe843783          	ld	a5,-24(s0)
    7e1c:	639c                	ld	a5,0(a5)
    7e1e:	fef43423          	sd	a5,-24(s0)
    7e22:	fe043703          	ld	a4,-32(s0)
    7e26:	fe843783          	ld	a5,-24(s0)
    7e2a:	fce7f3e3          	bgeu	a5,a4,7df0 <free+0x24>
    7e2e:	fe843783          	ld	a5,-24(s0)
    7e32:	639c                	ld	a5,0(a5)
    7e34:	fe043703          	ld	a4,-32(s0)
    7e38:	faf77ce3          	bgeu	a4,a5,7df0 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
    7e3c:	fe043783          	ld	a5,-32(s0)
    7e40:	479c                	lw	a5,8(a5)
    7e42:	1782                	slli	a5,a5,0x20
    7e44:	9381                	srli	a5,a5,0x20
    7e46:	0792                	slli	a5,a5,0x4
    7e48:	fe043703          	ld	a4,-32(s0)
    7e4c:	973e                	add	a4,a4,a5
    7e4e:	fe843783          	ld	a5,-24(s0)
    7e52:	639c                	ld	a5,0(a5)
    7e54:	02f71763          	bne	a4,a5,7e82 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
    7e58:	fe043783          	ld	a5,-32(s0)
    7e5c:	4798                	lw	a4,8(a5)
    7e5e:	fe843783          	ld	a5,-24(s0)
    7e62:	639c                	ld	a5,0(a5)
    7e64:	479c                	lw	a5,8(a5)
    7e66:	9fb9                	addw	a5,a5,a4
    7e68:	0007871b          	sext.w	a4,a5
    7e6c:	fe043783          	ld	a5,-32(s0)
    7e70:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
    7e72:	fe843783          	ld	a5,-24(s0)
    7e76:	639c                	ld	a5,0(a5)
    7e78:	6398                	ld	a4,0(a5)
    7e7a:	fe043783          	ld	a5,-32(s0)
    7e7e:	e398                	sd	a4,0(a5)
    7e80:	a039                	j	7e8e <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
    7e82:	fe843783          	ld	a5,-24(s0)
    7e86:	6398                	ld	a4,0(a5)
    7e88:	fe043783          	ld	a5,-32(s0)
    7e8c:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
    7e8e:	fe843783          	ld	a5,-24(s0)
    7e92:	479c                	lw	a5,8(a5)
    7e94:	1782                	slli	a5,a5,0x20
    7e96:	9381                	srli	a5,a5,0x20
    7e98:	0792                	slli	a5,a5,0x4
    7e9a:	fe843703          	ld	a4,-24(s0)
    7e9e:	97ba                	add	a5,a5,a4
    7ea0:	fe043703          	ld	a4,-32(s0)
    7ea4:	02f71563          	bne	a4,a5,7ece <free+0x102>
    p->s.size += bp->s.size;
    7ea8:	fe843783          	ld	a5,-24(s0)
    7eac:	4798                	lw	a4,8(a5)
    7eae:	fe043783          	ld	a5,-32(s0)
    7eb2:	479c                	lw	a5,8(a5)
    7eb4:	9fb9                	addw	a5,a5,a4
    7eb6:	0007871b          	sext.w	a4,a5
    7eba:	fe843783          	ld	a5,-24(s0)
    7ebe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    7ec0:	fe043783          	ld	a5,-32(s0)
    7ec4:	6398                	ld	a4,0(a5)
    7ec6:	fe843783          	ld	a5,-24(s0)
    7eca:	e398                	sd	a4,0(a5)
    7ecc:	a031                	j	7ed8 <free+0x10c>
  } else
    p->s.ptr = bp;
    7ece:	fe843783          	ld	a5,-24(s0)
    7ed2:	fe043703          	ld	a4,-32(s0)
    7ed6:	e398                	sd	a4,0(a5)
  freep = p;
    7ed8:	0000b797          	auipc	a5,0xb
    7edc:	c3078793          	addi	a5,a5,-976 # 12b08 <freep>
    7ee0:	fe843703          	ld	a4,-24(s0)
    7ee4:	e398                	sd	a4,0(a5)
}
    7ee6:	0001                	nop
    7ee8:	7422                	ld	s0,40(sp)
    7eea:	6145                	addi	sp,sp,48
    7eec:	8082                	ret

0000000000007eee <morecore>:

static Header*
morecore(uint nu)
{
    7eee:	7179                	addi	sp,sp,-48
    7ef0:	f406                	sd	ra,40(sp)
    7ef2:	f022                	sd	s0,32(sp)
    7ef4:	1800                	addi	s0,sp,48
    7ef6:	87aa                	mv	a5,a0
    7ef8:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
    7efc:	fdc42783          	lw	a5,-36(s0)
    7f00:	0007871b          	sext.w	a4,a5
    7f04:	6785                	lui	a5,0x1
    7f06:	00f77563          	bgeu	a4,a5,7f10 <morecore+0x22>
    nu = 4096;
    7f0a:	6785                	lui	a5,0x1
    7f0c:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
    7f10:	fdc42783          	lw	a5,-36(s0)
    7f14:	0047979b          	slliw	a5,a5,0x4
    7f18:	2781                	sext.w	a5,a5
    7f1a:	2781                	sext.w	a5,a5
    7f1c:	853e                	mv	a0,a5
    7f1e:	00000097          	auipc	ra,0x0
    7f22:	9be080e7          	jalr	-1602(ra) # 78dc <sbrk>
    7f26:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
    7f2a:	fe843703          	ld	a4,-24(s0)
    7f2e:	57fd                	li	a5,-1
    7f30:	00f71463          	bne	a4,a5,7f38 <morecore+0x4a>
    return 0;
    7f34:	4781                	li	a5,0
    7f36:	a03d                	j	7f64 <morecore+0x76>
  hp = (Header*)p;
    7f38:	fe843783          	ld	a5,-24(s0)
    7f3c:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
    7f40:	fe043783          	ld	a5,-32(s0)
    7f44:	fdc42703          	lw	a4,-36(s0)
    7f48:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
    7f4a:	fe043783          	ld	a5,-32(s0)
    7f4e:	07c1                	addi	a5,a5,16 # 1010 <truncate3+0x1c2>
    7f50:	853e                	mv	a0,a5
    7f52:	00000097          	auipc	ra,0x0
    7f56:	e7a080e7          	jalr	-390(ra) # 7dcc <free>
  return freep;
    7f5a:	0000b797          	auipc	a5,0xb
    7f5e:	bae78793          	addi	a5,a5,-1106 # 12b08 <freep>
    7f62:	639c                	ld	a5,0(a5)
}
    7f64:	853e                	mv	a0,a5
    7f66:	70a2                	ld	ra,40(sp)
    7f68:	7402                	ld	s0,32(sp)
    7f6a:	6145                	addi	sp,sp,48
    7f6c:	8082                	ret

0000000000007f6e <malloc>:

void*
malloc(uint nbytes)
{
    7f6e:	7139                	addi	sp,sp,-64
    7f70:	fc06                	sd	ra,56(sp)
    7f72:	f822                	sd	s0,48(sp)
    7f74:	0080                	addi	s0,sp,64
    7f76:	87aa                	mv	a5,a0
    7f78:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    7f7c:	fcc46783          	lwu	a5,-52(s0)
    7f80:	07bd                	addi	a5,a5,15
    7f82:	8391                	srli	a5,a5,0x4
    7f84:	2781                	sext.w	a5,a5
    7f86:	2785                	addiw	a5,a5,1
    7f88:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
    7f8c:	0000b797          	auipc	a5,0xb
    7f90:	b7c78793          	addi	a5,a5,-1156 # 12b08 <freep>
    7f94:	639c                	ld	a5,0(a5)
    7f96:	fef43023          	sd	a5,-32(s0)
    7f9a:	fe043783          	ld	a5,-32(s0)
    7f9e:	ef95                	bnez	a5,7fda <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
    7fa0:	0000b797          	auipc	a5,0xb
    7fa4:	b5878793          	addi	a5,a5,-1192 # 12af8 <base>
    7fa8:	fef43023          	sd	a5,-32(s0)
    7fac:	0000b797          	auipc	a5,0xb
    7fb0:	b5c78793          	addi	a5,a5,-1188 # 12b08 <freep>
    7fb4:	fe043703          	ld	a4,-32(s0)
    7fb8:	e398                	sd	a4,0(a5)
    7fba:	0000b797          	auipc	a5,0xb
    7fbe:	b4e78793          	addi	a5,a5,-1202 # 12b08 <freep>
    7fc2:	6398                	ld	a4,0(a5)
    7fc4:	0000b797          	auipc	a5,0xb
    7fc8:	b3478793          	addi	a5,a5,-1228 # 12af8 <base>
    7fcc:	e398                	sd	a4,0(a5)
    base.s.size = 0;
    7fce:	0000b797          	auipc	a5,0xb
    7fd2:	b2a78793          	addi	a5,a5,-1238 # 12af8 <base>
    7fd6:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    7fda:	fe043783          	ld	a5,-32(s0)
    7fde:	639c                	ld	a5,0(a5)
    7fe0:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    7fe4:	fe843783          	ld	a5,-24(s0)
    7fe8:	4798                	lw	a4,8(a5)
    7fea:	fdc42783          	lw	a5,-36(s0)
    7fee:	2781                	sext.w	a5,a5
    7ff0:	06f76763          	bltu	a4,a5,805e <malloc+0xf0>
      if(p->s.size == nunits)
    7ff4:	fe843783          	ld	a5,-24(s0)
    7ff8:	4798                	lw	a4,8(a5)
    7ffa:	fdc42783          	lw	a5,-36(s0)
    7ffe:	2781                	sext.w	a5,a5
    8000:	00e79963          	bne	a5,a4,8012 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
    8004:	fe843783          	ld	a5,-24(s0)
    8008:	6398                	ld	a4,0(a5)
    800a:	fe043783          	ld	a5,-32(s0)
    800e:	e398                	sd	a4,0(a5)
    8010:	a825                	j	8048 <malloc+0xda>
      else {
        p->s.size -= nunits;
    8012:	fe843783          	ld	a5,-24(s0)
    8016:	479c                	lw	a5,8(a5)
    8018:	fdc42703          	lw	a4,-36(s0)
    801c:	9f99                	subw	a5,a5,a4
    801e:	0007871b          	sext.w	a4,a5
    8022:	fe843783          	ld	a5,-24(s0)
    8026:	c798                	sw	a4,8(a5)
        p += p->s.size;
    8028:	fe843783          	ld	a5,-24(s0)
    802c:	479c                	lw	a5,8(a5)
    802e:	1782                	slli	a5,a5,0x20
    8030:	9381                	srli	a5,a5,0x20
    8032:	0792                	slli	a5,a5,0x4
    8034:	fe843703          	ld	a4,-24(s0)
    8038:	97ba                	add	a5,a5,a4
    803a:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
    803e:	fe843783          	ld	a5,-24(s0)
    8042:	fdc42703          	lw	a4,-36(s0)
    8046:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
    8048:	0000b797          	auipc	a5,0xb
    804c:	ac078793          	addi	a5,a5,-1344 # 12b08 <freep>
    8050:	fe043703          	ld	a4,-32(s0)
    8054:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
    8056:	fe843783          	ld	a5,-24(s0)
    805a:	07c1                	addi	a5,a5,16
    805c:	a091                	j	80a0 <malloc+0x132>
    }
    if(p == freep)
    805e:	0000b797          	auipc	a5,0xb
    8062:	aaa78793          	addi	a5,a5,-1366 # 12b08 <freep>
    8066:	639c                	ld	a5,0(a5)
    8068:	fe843703          	ld	a4,-24(s0)
    806c:	02f71063          	bne	a4,a5,808c <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
    8070:	fdc42783          	lw	a5,-36(s0)
    8074:	853e                	mv	a0,a5
    8076:	00000097          	auipc	ra,0x0
    807a:	e78080e7          	jalr	-392(ra) # 7eee <morecore>
    807e:	fea43423          	sd	a0,-24(s0)
    8082:	fe843783          	ld	a5,-24(s0)
    8086:	e399                	bnez	a5,808c <malloc+0x11e>
        return 0;
    8088:	4781                	li	a5,0
    808a:	a819                	j	80a0 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    808c:	fe843783          	ld	a5,-24(s0)
    8090:	fef43023          	sd	a5,-32(s0)
    8094:	fe843783          	ld	a5,-24(s0)
    8098:	639c                	ld	a5,0(a5)
    809a:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
    809e:	b799                	j	7fe4 <malloc+0x76>
  }
}
    80a0:	853e                	mv	a0,a5
    80a2:	70e2                	ld	ra,56(sp)
    80a4:	7442                	ld	s0,48(sp)
    80a6:	6121                	addi	sp,sp,64
    80a8:	8082                	ret
