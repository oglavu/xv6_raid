
user/_javni_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <init_raid>:
#include "user/user.h"

void check_data(uint blocks, uchar *blk, uint block_size);

enum RAID_TYPE {RAID0, RAID1, RAID0_1, RAID4, RAID5};
int init_raid(enum RAID_TYPE raid){return 0;};
   0:	1101                	addi	sp,sp,-32
   2:	ec22                	sd	s0,24(sp)
   4:	1000                	addi	s0,sp,32
   6:	87aa                	mv	a5,a0
   8:	fef42623          	sw	a5,-20(s0)
   c:	4781                	li	a5,0
   e:	853e                	mv	a0,a5
  10:	6462                	ld	s0,24(sp)
  12:	6105                	addi	sp,sp,32
  14:	8082                	ret

0000000000000016 <read_raid>:
int read_raid(int blkn, uchar* data){return 0;};
  16:	1101                	addi	sp,sp,-32
  18:	ec22                	sd	s0,24(sp)
  1a:	1000                	addi	s0,sp,32
  1c:	87aa                	mv	a5,a0
  1e:	feb43023          	sd	a1,-32(s0)
  22:	fef42623          	sw	a5,-20(s0)
  26:	4781                	li	a5,0
  28:	853e                	mv	a0,a5
  2a:	6462                	ld	s0,24(sp)
  2c:	6105                	addi	sp,sp,32
  2e:	8082                	ret

0000000000000030 <write_raid>:
int write_raid(int blkn, uchar* data){return 0;};
  30:	1101                	addi	sp,sp,-32
  32:	ec22                	sd	s0,24(sp)
  34:	1000                	addi	s0,sp,32
  36:	87aa                	mv	a5,a0
  38:	feb43023          	sd	a1,-32(s0)
  3c:	fef42623          	sw	a5,-20(s0)
  40:	4781                	li	a5,0
  42:	853e                	mv	a0,a5
  44:	6462                	ld	s0,24(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret

000000000000004a <disk_fail_raid>:
int disk_fail_raid(int diskn){return 0;};
  4a:	1101                	addi	sp,sp,-32
  4c:	ec22                	sd	s0,24(sp)
  4e:	1000                	addi	s0,sp,32
  50:	87aa                	mv	a5,a0
  52:	fef42623          	sw	a5,-20(s0)
  56:	4781                	li	a5,0
  58:	853e                	mv	a0,a5
  5a:	6462                	ld	s0,24(sp)
  5c:	6105                	addi	sp,sp,32
  5e:	8082                	ret

0000000000000060 <disk_repaired_raid>:
int disk_repaired_raid(int diskn){return 0;};
  60:	1101                	addi	sp,sp,-32
  62:	ec22                	sd	s0,24(sp)
  64:	1000                	addi	s0,sp,32
  66:	87aa                	mv	a5,a0
  68:	fef42623          	sw	a5,-20(s0)
  6c:	4781                	li	a5,0
  6e:	853e                	mv	a0,a5
  70:	6462                	ld	s0,24(sp)
  72:	6105                	addi	sp,sp,32
  74:	8082                	ret

0000000000000076 <info_raid>:
int info_raid(uint *blkn, uint *blks, uint *diskn){return 0;};
  76:	7179                	addi	sp,sp,-48
  78:	f422                	sd	s0,40(sp)
  7a:	1800                	addi	s0,sp,48
  7c:	fea43423          	sd	a0,-24(s0)
  80:	feb43023          	sd	a1,-32(s0)
  84:	fcc43c23          	sd	a2,-40(s0)
  88:	4781                	li	a5,0
  8a:	853e                	mv	a0,a5
  8c:	7422                	ld	s0,40(sp)
  8e:	6145                	addi	sp,sp,48
  90:	8082                	ret

0000000000000092 <destroy_raid>:
int destroy_raid(){return 0;};
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  98:	4781                	li	a5,0
  9a:	853e                	mv	a0,a5
  9c:	6422                	ld	s0,8(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <main>:


int
main(int argc, char *argv[])
{
  a2:	715d                	addi	sp,sp,-80
  a4:	e486                	sd	ra,72(sp)
  a6:	e0a2                	sd	s0,64(sp)
  a8:	0880                	addi	s0,sp,80
  aa:	87aa                	mv	a5,a0
  ac:	fab43823          	sd	a1,-80(s0)
  b0:	faf42e23          	sw	a5,-68(s0)
  
  init_raid(RAID1);
  b4:	4505                	li	a0,1
  b6:	00000097          	auipc	ra,0x0
  ba:	f4a080e7          	jalr	-182(ra) # 0 <init_raid>

  uint disk_num, block_num, block_size;
  info_raid(&block_num, &block_size, &disk_num);
  be:	fd440693          	addi	a3,s0,-44
  c2:	fcc40713          	addi	a4,s0,-52
  c6:	fd040793          	addi	a5,s0,-48
  ca:	8636                	mv	a2,a3
  cc:	85ba                	mv	a1,a4
  ce:	853e                	mv	a0,a5
  d0:	00000097          	auipc	ra,0x0
  d4:	fa6080e7          	jalr	-90(ra) # 76 <info_raid>

  uint blocks = (512 > block_num ? block_num : 512);
  d8:	fd042783          	lw	a5,-48(s0)
  dc:	0007869b          	sext.w	a3,a5
  e0:	20000713          	li	a4,512
  e4:	00d77463          	bgeu	a4,a3,ec <main+0x4a>
  e8:	20000793          	li	a5,512
  ec:	fef42223          	sw	a5,-28(s0)

  uchar* blk = malloc(block_size);
  f0:	fcc42783          	lw	a5,-52(s0)
  f4:	853e                	mv	a0,a5
  f6:	00001097          	auipc	ra,0x1
  fa:	dac080e7          	jalr	-596(ra) # ea2 <malloc>
  fe:	fca43c23          	sd	a0,-40(s0)
  for (uint i = 0; i < blocks; i++) {
 102:	fe042623          	sw	zero,-20(s0)
 106:	a085                	j	166 <main+0xc4>
    for (uint j = 0; j < block_size; j++) {
 108:	fe042423          	sw	zero,-24(s0)
 10c:	a805                	j	13c <main+0x9a>
      blk[j] = j + i;
 10e:	fe842783          	lw	a5,-24(s0)
 112:	0ff7f693          	zext.b	a3,a5
 116:	fec42783          	lw	a5,-20(s0)
 11a:	0ff7f713          	zext.b	a4,a5
 11e:	fe846783          	lwu	a5,-24(s0)
 122:	fd843603          	ld	a2,-40(s0)
 126:	97b2                	add	a5,a5,a2
 128:	9f35                	addw	a4,a4,a3
 12a:	0ff77713          	zext.b	a4,a4
 12e:	00e78023          	sb	a4,0(a5)
    for (uint j = 0; j < block_size; j++) {
 132:	fe842783          	lw	a5,-24(s0)
 136:	2785                	addiw	a5,a5,1
 138:	fef42423          	sw	a5,-24(s0)
 13c:	fcc42703          	lw	a4,-52(s0)
 140:	fe842783          	lw	a5,-24(s0)
 144:	2781                	sext.w	a5,a5
 146:	fce7e4e3          	bltu	a5,a4,10e <main+0x6c>
    }
    write_raid(i, blk);
 14a:	fec42783          	lw	a5,-20(s0)
 14e:	fd843583          	ld	a1,-40(s0)
 152:	853e                	mv	a0,a5
 154:	00000097          	auipc	ra,0x0
 158:	edc080e7          	jalr	-292(ra) # 30 <write_raid>
  for (uint i = 0; i < blocks; i++) {
 15c:	fec42783          	lw	a5,-20(s0)
 160:	2785                	addiw	a5,a5,1
 162:	fef42623          	sw	a5,-20(s0)
 166:	fec42783          	lw	a5,-20(s0)
 16a:	873e                	mv	a4,a5
 16c:	fe442783          	lw	a5,-28(s0)
 170:	2701                	sext.w	a4,a4
 172:	2781                	sext.w	a5,a5
 174:	f8f76ae3          	bltu	a4,a5,108 <main+0x66>
  }

  check_data(blocks, blk, block_size);
 178:	fcc42703          	lw	a4,-52(s0)
 17c:	fe442783          	lw	a5,-28(s0)
 180:	863a                	mv	a2,a4
 182:	fd843583          	ld	a1,-40(s0)
 186:	853e                	mv	a0,a5
 188:	00000097          	auipc	ra,0x0
 18c:	062080e7          	jalr	98(ra) # 1ea <check_data>

  disk_fail_raid(2);
 190:	4509                	li	a0,2
 192:	00000097          	auipc	ra,0x0
 196:	eb8080e7          	jalr	-328(ra) # 4a <disk_fail_raid>

  check_data(blocks, blk, block_size);
 19a:	fcc42703          	lw	a4,-52(s0)
 19e:	fe442783          	lw	a5,-28(s0)
 1a2:	863a                	mv	a2,a4
 1a4:	fd843583          	ld	a1,-40(s0)
 1a8:	853e                	mv	a0,a5
 1aa:	00000097          	auipc	ra,0x0
 1ae:	040080e7          	jalr	64(ra) # 1ea <check_data>

  disk_repaired_raid(2);
 1b2:	4509                	li	a0,2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	eac080e7          	jalr	-340(ra) # 60 <disk_repaired_raid>

  check_data(blocks, blk, block_size);
 1bc:	fcc42703          	lw	a4,-52(s0)
 1c0:	fe442783          	lw	a5,-28(s0)
 1c4:	863a                	mv	a2,a4
 1c6:	fd843583          	ld	a1,-40(s0)
 1ca:	853e                	mv	a0,a5
 1cc:	00000097          	auipc	ra,0x0
 1d0:	01e080e7          	jalr	30(ra) # 1ea <check_data>

  free(blk);
 1d4:	fd843503          	ld	a0,-40(s0)
 1d8:	00001097          	auipc	ra,0x1
 1dc:	b28080e7          	jalr	-1240(ra) # d00 <free>

  exit(0);
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	5a6080e7          	jalr	1446(ra) # 788 <exit>

00000000000001ea <check_data>:
}

void check_data(uint blocks, uchar *blk, uint block_size)
{
 1ea:	7179                	addi	sp,sp,-48
 1ec:	f406                	sd	ra,40(sp)
 1ee:	f022                	sd	s0,32(sp)
 1f0:	1800                	addi	s0,sp,48
 1f2:	87aa                	mv	a5,a0
 1f4:	fcb43823          	sd	a1,-48(s0)
 1f8:	8732                	mv	a4,a2
 1fa:	fcf42e23          	sw	a5,-36(s0)
 1fe:	87ba                	mv	a5,a4
 200:	fcf42c23          	sw	a5,-40(s0)
  for (uint i = 0; i < blocks; i++)
 204:	fe042623          	sw	zero,-20(s0)
 208:	a85d                	j	2be <check_data+0xd4>
  {
    read_raid(i, blk);
 20a:	fec42783          	lw	a5,-20(s0)
 20e:	fd043583          	ld	a1,-48(s0)
 212:	853e                	mv	a0,a5
 214:	00000097          	auipc	ra,0x0
 218:	e02080e7          	jalr	-510(ra) # 16 <read_raid>
    for (uint j = 0; j < block_size; j++)
 21c:	fe042423          	sw	zero,-24(s0)
 220:	a049                	j	2a2 <check_data+0xb8>
    {
      if ((uchar)(j + i) != blk[j])
 222:	fe842783          	lw	a5,-24(s0)
 226:	0ff7f713          	zext.b	a4,a5
 22a:	fec42783          	lw	a5,-20(s0)
 22e:	0ff7f793          	zext.b	a5,a5
 232:	9fb9                	addw	a5,a5,a4
 234:	0ff7f693          	zext.b	a3,a5
 238:	fe846783          	lwu	a5,-24(s0)
 23c:	fd043703          	ld	a4,-48(s0)
 240:	97ba                	add	a5,a5,a4
 242:	0007c783          	lbu	a5,0(a5)
 246:	8736                	mv	a4,a3
 248:	04f70863          	beq	a4,a5,298 <check_data+0xae>
      {
        printf("expected=%d got=%d", j + i, blk[j]);
 24c:	fe842783          	lw	a5,-24(s0)
 250:	873e                	mv	a4,a5
 252:	fec42783          	lw	a5,-20(s0)
 256:	9fb9                	addw	a5,a5,a4
 258:	0007869b          	sext.w	a3,a5
 25c:	fe846783          	lwu	a5,-24(s0)
 260:	fd043703          	ld	a4,-48(s0)
 264:	97ba                	add	a5,a5,a4
 266:	0007c783          	lbu	a5,0(a5)
 26a:	2781                	sext.w	a5,a5
 26c:	863e                	mv	a2,a5
 26e:	85b6                	mv	a1,a3
 270:	00001517          	auipc	a0,0x1
 274:	d7050513          	addi	a0,a0,-656 # fe0 <malloc+0x13e>
 278:	00001097          	auipc	ra,0x1
 27c:	a38080e7          	jalr	-1480(ra) # cb0 <printf>
        printf("Data in the block %d faulty\n", i);
 280:	fec42783          	lw	a5,-20(s0)
 284:	85be                	mv	a1,a5
 286:	00001517          	auipc	a0,0x1
 28a:	d7250513          	addi	a0,a0,-654 # ff8 <malloc+0x156>
 28e:	00001097          	auipc	ra,0x1
 292:	a22080e7          	jalr	-1502(ra) # cb0 <printf>
        break;
 296:	a839                	j	2b4 <check_data+0xca>
    for (uint j = 0; j < block_size; j++)
 298:	fe842783          	lw	a5,-24(s0)
 29c:	2785                	addiw	a5,a5,1
 29e:	fef42423          	sw	a5,-24(s0)
 2a2:	fe842783          	lw	a5,-24(s0)
 2a6:	873e                	mv	a4,a5
 2a8:	fd842783          	lw	a5,-40(s0)
 2ac:	2701                	sext.w	a4,a4
 2ae:	2781                	sext.w	a5,a5
 2b0:	f6f769e3          	bltu	a4,a5,222 <check_data+0x38>
  for (uint i = 0; i < blocks; i++)
 2b4:	fec42783          	lw	a5,-20(s0)
 2b8:	2785                	addiw	a5,a5,1
 2ba:	fef42623          	sw	a5,-20(s0)
 2be:	fec42783          	lw	a5,-20(s0)
 2c2:	873e                	mv	a4,a5
 2c4:	fdc42783          	lw	a5,-36(s0)
 2c8:	2701                	sext.w	a4,a4
 2ca:	2781                	sext.w	a5,a5
 2cc:	f2f76fe3          	bltu	a4,a5,20a <check_data+0x20>
      }
    }
  }
}
 2d0:	0001                	nop
 2d2:	0001                	nop
 2d4:	70a2                	ld	ra,40(sp)
 2d6:	7402                	ld	s0,32(sp)
 2d8:	6145                	addi	sp,sp,48
 2da:	8082                	ret

00000000000002dc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e4:	00000097          	auipc	ra,0x0
 2e8:	dbe080e7          	jalr	-578(ra) # a2 <main>
  exit(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	49a080e7          	jalr	1178(ra) # 788 <exit>

00000000000002f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f6:	7179                	addi	sp,sp,-48
 2f8:	f422                	sd	s0,40(sp)
 2fa:	1800                	addi	s0,sp,48
 2fc:	fca43c23          	sd	a0,-40(s0)
 300:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
 304:	fd843783          	ld	a5,-40(s0)
 308:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
 30c:	0001                	nop
 30e:	fd043703          	ld	a4,-48(s0)
 312:	00170793          	addi	a5,a4,1
 316:	fcf43823          	sd	a5,-48(s0)
 31a:	fd843783          	ld	a5,-40(s0)
 31e:	00178693          	addi	a3,a5,1
 322:	fcd43c23          	sd	a3,-40(s0)
 326:	00074703          	lbu	a4,0(a4)
 32a:	00e78023          	sb	a4,0(a5)
 32e:	0007c783          	lbu	a5,0(a5)
 332:	fff1                	bnez	a5,30e <strcpy+0x18>
    ;
  return os;
 334:	fe843783          	ld	a5,-24(s0)
}
 338:	853e                	mv	a0,a5
 33a:	7422                	ld	s0,40(sp)
 33c:	6145                	addi	sp,sp,48
 33e:	8082                	ret

0000000000000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	1101                	addi	sp,sp,-32
 342:	ec22                	sd	s0,24(sp)
 344:	1000                	addi	s0,sp,32
 346:	fea43423          	sd	a0,-24(s0)
 34a:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
 34e:	a819                	j	364 <strcmp+0x24>
    p++, q++;
 350:	fe843783          	ld	a5,-24(s0)
 354:	0785                	addi	a5,a5,1
 356:	fef43423          	sd	a5,-24(s0)
 35a:	fe043783          	ld	a5,-32(s0)
 35e:	0785                	addi	a5,a5,1
 360:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
 364:	fe843783          	ld	a5,-24(s0)
 368:	0007c783          	lbu	a5,0(a5)
 36c:	cb99                	beqz	a5,382 <strcmp+0x42>
 36e:	fe843783          	ld	a5,-24(s0)
 372:	0007c703          	lbu	a4,0(a5)
 376:	fe043783          	ld	a5,-32(s0)
 37a:	0007c783          	lbu	a5,0(a5)
 37e:	fcf709e3          	beq	a4,a5,350 <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
 382:	fe843783          	ld	a5,-24(s0)
 386:	0007c783          	lbu	a5,0(a5)
 38a:	0007871b          	sext.w	a4,a5
 38e:	fe043783          	ld	a5,-32(s0)
 392:	0007c783          	lbu	a5,0(a5)
 396:	2781                	sext.w	a5,a5
 398:	40f707bb          	subw	a5,a4,a5
 39c:	2781                	sext.w	a5,a5
}
 39e:	853e                	mv	a0,a5
 3a0:	6462                	ld	s0,24(sp)
 3a2:	6105                	addi	sp,sp,32
 3a4:	8082                	ret

00000000000003a6 <strlen>:

uint
strlen(const char *s)
{
 3a6:	7179                	addi	sp,sp,-48
 3a8:	f422                	sd	s0,40(sp)
 3aa:	1800                	addi	s0,sp,48
 3ac:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
 3b0:	fe042623          	sw	zero,-20(s0)
 3b4:	a031                	j	3c0 <strlen+0x1a>
 3b6:	fec42783          	lw	a5,-20(s0)
 3ba:	2785                	addiw	a5,a5,1
 3bc:	fef42623          	sw	a5,-20(s0)
 3c0:	fec42783          	lw	a5,-20(s0)
 3c4:	fd843703          	ld	a4,-40(s0)
 3c8:	97ba                	add	a5,a5,a4
 3ca:	0007c783          	lbu	a5,0(a5)
 3ce:	f7e5                	bnez	a5,3b6 <strlen+0x10>
    ;
  return n;
 3d0:	fec42783          	lw	a5,-20(s0)
}
 3d4:	853e                	mv	a0,a5
 3d6:	7422                	ld	s0,40(sp)
 3d8:	6145                	addi	sp,sp,48
 3da:	8082                	ret

00000000000003dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 3dc:	7179                	addi	sp,sp,-48
 3de:	f422                	sd	s0,40(sp)
 3e0:	1800                	addi	s0,sp,48
 3e2:	fca43c23          	sd	a0,-40(s0)
 3e6:	87ae                	mv	a5,a1
 3e8:	8732                	mv	a4,a2
 3ea:	fcf42a23          	sw	a5,-44(s0)
 3ee:	87ba                	mv	a5,a4
 3f0:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
 3f4:	fd843783          	ld	a5,-40(s0)
 3f8:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
 3fc:	fe042623          	sw	zero,-20(s0)
 400:	a00d                	j	422 <memset+0x46>
    cdst[i] = c;
 402:	fec42783          	lw	a5,-20(s0)
 406:	fe043703          	ld	a4,-32(s0)
 40a:	97ba                	add	a5,a5,a4
 40c:	fd442703          	lw	a4,-44(s0)
 410:	0ff77713          	zext.b	a4,a4
 414:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
 418:	fec42783          	lw	a5,-20(s0)
 41c:	2785                	addiw	a5,a5,1
 41e:	fef42623          	sw	a5,-20(s0)
 422:	fec42703          	lw	a4,-20(s0)
 426:	fd042783          	lw	a5,-48(s0)
 42a:	2781                	sext.w	a5,a5
 42c:	fcf76be3          	bltu	a4,a5,402 <memset+0x26>
  }
  return dst;
 430:	fd843783          	ld	a5,-40(s0)
}
 434:	853e                	mv	a0,a5
 436:	7422                	ld	s0,40(sp)
 438:	6145                	addi	sp,sp,48
 43a:	8082                	ret

000000000000043c <strchr>:

char*
strchr(const char *s, char c)
{
 43c:	1101                	addi	sp,sp,-32
 43e:	ec22                	sd	s0,24(sp)
 440:	1000                	addi	s0,sp,32
 442:	fea43423          	sd	a0,-24(s0)
 446:	87ae                	mv	a5,a1
 448:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
 44c:	a01d                	j	472 <strchr+0x36>
    if(*s == c)
 44e:	fe843783          	ld	a5,-24(s0)
 452:	0007c703          	lbu	a4,0(a5)
 456:	fe744783          	lbu	a5,-25(s0)
 45a:	0ff7f793          	zext.b	a5,a5
 45e:	00e79563          	bne	a5,a4,468 <strchr+0x2c>
      return (char*)s;
 462:	fe843783          	ld	a5,-24(s0)
 466:	a821                	j	47e <strchr+0x42>
  for(; *s; s++)
 468:	fe843783          	ld	a5,-24(s0)
 46c:	0785                	addi	a5,a5,1
 46e:	fef43423          	sd	a5,-24(s0)
 472:	fe843783          	ld	a5,-24(s0)
 476:	0007c783          	lbu	a5,0(a5)
 47a:	fbf1                	bnez	a5,44e <strchr+0x12>
  return 0;
 47c:	4781                	li	a5,0
}
 47e:	853e                	mv	a0,a5
 480:	6462                	ld	s0,24(sp)
 482:	6105                	addi	sp,sp,32
 484:	8082                	ret

0000000000000486 <gets>:

char*
gets(char *buf, int max)
{
 486:	7179                	addi	sp,sp,-48
 488:	f406                	sd	ra,40(sp)
 48a:	f022                	sd	s0,32(sp)
 48c:	1800                	addi	s0,sp,48
 48e:	fca43c23          	sd	a0,-40(s0)
 492:	87ae                	mv	a5,a1
 494:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 498:	fe042623          	sw	zero,-20(s0)
 49c:	a8a1                	j	4f4 <gets+0x6e>
    cc = read(0, &c, 1);
 49e:	fe740793          	addi	a5,s0,-25
 4a2:	4605                	li	a2,1
 4a4:	85be                	mv	a1,a5
 4a6:	4501                	li	a0,0
 4a8:	00000097          	auipc	ra,0x0
 4ac:	2f8080e7          	jalr	760(ra) # 7a0 <read>
 4b0:	87aa                	mv	a5,a0
 4b2:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
 4b6:	fe842783          	lw	a5,-24(s0)
 4ba:	2781                	sext.w	a5,a5
 4bc:	04f05763          	blez	a5,50a <gets+0x84>
      break;
    buf[i++] = c;
 4c0:	fec42783          	lw	a5,-20(s0)
 4c4:	0017871b          	addiw	a4,a5,1
 4c8:	fee42623          	sw	a4,-20(s0)
 4cc:	873e                	mv	a4,a5
 4ce:	fd843783          	ld	a5,-40(s0)
 4d2:	97ba                	add	a5,a5,a4
 4d4:	fe744703          	lbu	a4,-25(s0)
 4d8:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
 4dc:	fe744783          	lbu	a5,-25(s0)
 4e0:	873e                	mv	a4,a5
 4e2:	47a9                	li	a5,10
 4e4:	02f70463          	beq	a4,a5,50c <gets+0x86>
 4e8:	fe744783          	lbu	a5,-25(s0)
 4ec:	873e                	mv	a4,a5
 4ee:	47b5                	li	a5,13
 4f0:	00f70e63          	beq	a4,a5,50c <gets+0x86>
  for(i=0; i+1 < max; ){
 4f4:	fec42783          	lw	a5,-20(s0)
 4f8:	2785                	addiw	a5,a5,1
 4fa:	0007871b          	sext.w	a4,a5
 4fe:	fd442783          	lw	a5,-44(s0)
 502:	2781                	sext.w	a5,a5
 504:	f8f74de3          	blt	a4,a5,49e <gets+0x18>
 508:	a011                	j	50c <gets+0x86>
      break;
 50a:	0001                	nop
      break;
  }
  buf[i] = '\0';
 50c:	fec42783          	lw	a5,-20(s0)
 510:	fd843703          	ld	a4,-40(s0)
 514:	97ba                	add	a5,a5,a4
 516:	00078023          	sb	zero,0(a5)
  return buf;
 51a:	fd843783          	ld	a5,-40(s0)
}
 51e:	853e                	mv	a0,a5
 520:	70a2                	ld	ra,40(sp)
 522:	7402                	ld	s0,32(sp)
 524:	6145                	addi	sp,sp,48
 526:	8082                	ret

0000000000000528 <stat>:

int
stat(const char *n, struct stat *st)
{
 528:	7179                	addi	sp,sp,-48
 52a:	f406                	sd	ra,40(sp)
 52c:	f022                	sd	s0,32(sp)
 52e:	1800                	addi	s0,sp,48
 530:	fca43c23          	sd	a0,-40(s0)
 534:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 538:	4581                	li	a1,0
 53a:	fd843503          	ld	a0,-40(s0)
 53e:	00000097          	auipc	ra,0x0
 542:	28a080e7          	jalr	650(ra) # 7c8 <open>
 546:	87aa                	mv	a5,a0
 548:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
 54c:	fec42783          	lw	a5,-20(s0)
 550:	2781                	sext.w	a5,a5
 552:	0007d463          	bgez	a5,55a <stat+0x32>
    return -1;
 556:	57fd                	li	a5,-1
 558:	a035                	j	584 <stat+0x5c>
  r = fstat(fd, st);
 55a:	fec42783          	lw	a5,-20(s0)
 55e:	fd043583          	ld	a1,-48(s0)
 562:	853e                	mv	a0,a5
 564:	00000097          	auipc	ra,0x0
 568:	27c080e7          	jalr	636(ra) # 7e0 <fstat>
 56c:	87aa                	mv	a5,a0
 56e:	fef42423          	sw	a5,-24(s0)
  close(fd);
 572:	fec42783          	lw	a5,-20(s0)
 576:	853e                	mv	a0,a5
 578:	00000097          	auipc	ra,0x0
 57c:	238080e7          	jalr	568(ra) # 7b0 <close>
  return r;
 580:	fe842783          	lw	a5,-24(s0)
}
 584:	853e                	mv	a0,a5
 586:	70a2                	ld	ra,40(sp)
 588:	7402                	ld	s0,32(sp)
 58a:	6145                	addi	sp,sp,48
 58c:	8082                	ret

000000000000058e <atoi>:

int
atoi(const char *s)
{
 58e:	7179                	addi	sp,sp,-48
 590:	f422                	sd	s0,40(sp)
 592:	1800                	addi	s0,sp,48
 594:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
 598:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
 59c:	a81d                	j	5d2 <atoi+0x44>
    n = n*10 + *s++ - '0';
 59e:	fec42783          	lw	a5,-20(s0)
 5a2:	873e                	mv	a4,a5
 5a4:	87ba                	mv	a5,a4
 5a6:	0027979b          	slliw	a5,a5,0x2
 5aa:	9fb9                	addw	a5,a5,a4
 5ac:	0017979b          	slliw	a5,a5,0x1
 5b0:	0007871b          	sext.w	a4,a5
 5b4:	fd843783          	ld	a5,-40(s0)
 5b8:	00178693          	addi	a3,a5,1
 5bc:	fcd43c23          	sd	a3,-40(s0)
 5c0:	0007c783          	lbu	a5,0(a5)
 5c4:	2781                	sext.w	a5,a5
 5c6:	9fb9                	addw	a5,a5,a4
 5c8:	2781                	sext.w	a5,a5
 5ca:	fd07879b          	addiw	a5,a5,-48
 5ce:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
 5d2:	fd843783          	ld	a5,-40(s0)
 5d6:	0007c783          	lbu	a5,0(a5)
 5da:	873e                	mv	a4,a5
 5dc:	02f00793          	li	a5,47
 5e0:	00e7fb63          	bgeu	a5,a4,5f6 <atoi+0x68>
 5e4:	fd843783          	ld	a5,-40(s0)
 5e8:	0007c783          	lbu	a5,0(a5)
 5ec:	873e                	mv	a4,a5
 5ee:	03900793          	li	a5,57
 5f2:	fae7f6e3          	bgeu	a5,a4,59e <atoi+0x10>
  return n;
 5f6:	fec42783          	lw	a5,-20(s0)
}
 5fa:	853e                	mv	a0,a5
 5fc:	7422                	ld	s0,40(sp)
 5fe:	6145                	addi	sp,sp,48
 600:	8082                	ret

0000000000000602 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 602:	7139                	addi	sp,sp,-64
 604:	fc22                	sd	s0,56(sp)
 606:	0080                	addi	s0,sp,64
 608:	fca43c23          	sd	a0,-40(s0)
 60c:	fcb43823          	sd	a1,-48(s0)
 610:	87b2                	mv	a5,a2
 612:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
 616:	fd843783          	ld	a5,-40(s0)
 61a:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
 61e:	fd043783          	ld	a5,-48(s0)
 622:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
 626:	fe043703          	ld	a4,-32(s0)
 62a:	fe843783          	ld	a5,-24(s0)
 62e:	02e7fc63          	bgeu	a5,a4,666 <memmove+0x64>
    while(n-- > 0)
 632:	a00d                	j	654 <memmove+0x52>
      *dst++ = *src++;
 634:	fe043703          	ld	a4,-32(s0)
 638:	00170793          	addi	a5,a4,1
 63c:	fef43023          	sd	a5,-32(s0)
 640:	fe843783          	ld	a5,-24(s0)
 644:	00178693          	addi	a3,a5,1
 648:	fed43423          	sd	a3,-24(s0)
 64c:	00074703          	lbu	a4,0(a4)
 650:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 654:	fcc42783          	lw	a5,-52(s0)
 658:	fff7871b          	addiw	a4,a5,-1
 65c:	fce42623          	sw	a4,-52(s0)
 660:	fcf04ae3          	bgtz	a5,634 <memmove+0x32>
 664:	a891                	j	6b8 <memmove+0xb6>
  } else {
    dst += n;
 666:	fcc42783          	lw	a5,-52(s0)
 66a:	fe843703          	ld	a4,-24(s0)
 66e:	97ba                	add	a5,a5,a4
 670:	fef43423          	sd	a5,-24(s0)
    src += n;
 674:	fcc42783          	lw	a5,-52(s0)
 678:	fe043703          	ld	a4,-32(s0)
 67c:	97ba                	add	a5,a5,a4
 67e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
 682:	a01d                	j	6a8 <memmove+0xa6>
      *--dst = *--src;
 684:	fe043783          	ld	a5,-32(s0)
 688:	17fd                	addi	a5,a5,-1
 68a:	fef43023          	sd	a5,-32(s0)
 68e:	fe843783          	ld	a5,-24(s0)
 692:	17fd                	addi	a5,a5,-1
 694:	fef43423          	sd	a5,-24(s0)
 698:	fe043783          	ld	a5,-32(s0)
 69c:	0007c703          	lbu	a4,0(a5)
 6a0:	fe843783          	ld	a5,-24(s0)
 6a4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
 6a8:	fcc42783          	lw	a5,-52(s0)
 6ac:	fff7871b          	addiw	a4,a5,-1
 6b0:	fce42623          	sw	a4,-52(s0)
 6b4:	fcf048e3          	bgtz	a5,684 <memmove+0x82>
  }
  return vdst;
 6b8:	fd843783          	ld	a5,-40(s0)
}
 6bc:	853e                	mv	a0,a5
 6be:	7462                	ld	s0,56(sp)
 6c0:	6121                	addi	sp,sp,64
 6c2:	8082                	ret

00000000000006c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6c4:	7139                	addi	sp,sp,-64
 6c6:	fc22                	sd	s0,56(sp)
 6c8:	0080                	addi	s0,sp,64
 6ca:	fca43c23          	sd	a0,-40(s0)
 6ce:	fcb43823          	sd	a1,-48(s0)
 6d2:	87b2                	mv	a5,a2
 6d4:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
 6d8:	fd843783          	ld	a5,-40(s0)
 6dc:	fef43423          	sd	a5,-24(s0)
 6e0:	fd043783          	ld	a5,-48(s0)
 6e4:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 6e8:	a0a1                	j	730 <memcmp+0x6c>
    if (*p1 != *p2) {
 6ea:	fe843783          	ld	a5,-24(s0)
 6ee:	0007c703          	lbu	a4,0(a5)
 6f2:	fe043783          	ld	a5,-32(s0)
 6f6:	0007c783          	lbu	a5,0(a5)
 6fa:	02f70163          	beq	a4,a5,71c <memcmp+0x58>
      return *p1 - *p2;
 6fe:	fe843783          	ld	a5,-24(s0)
 702:	0007c783          	lbu	a5,0(a5)
 706:	0007871b          	sext.w	a4,a5
 70a:	fe043783          	ld	a5,-32(s0)
 70e:	0007c783          	lbu	a5,0(a5)
 712:	2781                	sext.w	a5,a5
 714:	40f707bb          	subw	a5,a4,a5
 718:	2781                	sext.w	a5,a5
 71a:	a01d                	j	740 <memcmp+0x7c>
    }
    p1++;
 71c:	fe843783          	ld	a5,-24(s0)
 720:	0785                	addi	a5,a5,1
 722:	fef43423          	sd	a5,-24(s0)
    p2++;
 726:	fe043783          	ld	a5,-32(s0)
 72a:	0785                	addi	a5,a5,1
 72c:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
 730:	fcc42783          	lw	a5,-52(s0)
 734:	fff7871b          	addiw	a4,a5,-1
 738:	fce42623          	sw	a4,-52(s0)
 73c:	f7dd                	bnez	a5,6ea <memcmp+0x26>
  }
  return 0;
 73e:	4781                	li	a5,0
}
 740:	853e                	mv	a0,a5
 742:	7462                	ld	s0,56(sp)
 744:	6121                	addi	sp,sp,64
 746:	8082                	ret

0000000000000748 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 748:	7179                	addi	sp,sp,-48
 74a:	f406                	sd	ra,40(sp)
 74c:	f022                	sd	s0,32(sp)
 74e:	1800                	addi	s0,sp,48
 750:	fea43423          	sd	a0,-24(s0)
 754:	feb43023          	sd	a1,-32(s0)
 758:	87b2                	mv	a5,a2
 75a:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
 75e:	fdc42783          	lw	a5,-36(s0)
 762:	863e                	mv	a2,a5
 764:	fe043583          	ld	a1,-32(s0)
 768:	fe843503          	ld	a0,-24(s0)
 76c:	00000097          	auipc	ra,0x0
 770:	e96080e7          	jalr	-362(ra) # 602 <memmove>
 774:	87aa                	mv	a5,a0
}
 776:	853e                	mv	a0,a5
 778:	70a2                	ld	ra,40(sp)
 77a:	7402                	ld	s0,32(sp)
 77c:	6145                	addi	sp,sp,48
 77e:	8082                	ret

0000000000000780 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 780:	4885                	li	a7,1
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <exit>:
.global exit
exit:
 li a7, SYS_exit
 788:	4889                	li	a7,2
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <wait>:
.global wait
wait:
 li a7, SYS_wait
 790:	488d                	li	a7,3
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 798:	4891                	li	a7,4
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <read>:
.global read
read:
 li a7, SYS_read
 7a0:	4895                	li	a7,5
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <write>:
.global write
write:
 li a7, SYS_write
 7a8:	48c1                	li	a7,16
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <close>:
.global close
close:
 li a7, SYS_close
 7b0:	48d5                	li	a7,21
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7b8:	4899                	li	a7,6
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7c0:	489d                	li	a7,7
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <open>:
.global open
open:
 li a7, SYS_open
 7c8:	48bd                	li	a7,15
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7d0:	48c5                	li	a7,17
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7d8:	48c9                	li	a7,18
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7e0:	48a1                	li	a7,8
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <link>:
.global link
link:
 li a7, SYS_link
 7e8:	48cd                	li	a7,19
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7f0:	48d1                	li	a7,20
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7f8:	48a5                	li	a7,9
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <dup>:
.global dup
dup:
 li a7, SYS_dup
 800:	48a9                	li	a7,10
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 808:	48ad                	li	a7,11
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 810:	48b1                	li	a7,12
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 818:	48b5                	li	a7,13
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 820:	48b9                	li	a7,14
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 828:	1101                	addi	sp,sp,-32
 82a:	ec06                	sd	ra,24(sp)
 82c:	e822                	sd	s0,16(sp)
 82e:	1000                	addi	s0,sp,32
 830:	87aa                	mv	a5,a0
 832:	872e                	mv	a4,a1
 834:	fef42623          	sw	a5,-20(s0)
 838:	87ba                	mv	a5,a4
 83a:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
 83e:	feb40713          	addi	a4,s0,-21
 842:	fec42783          	lw	a5,-20(s0)
 846:	4605                	li	a2,1
 848:	85ba                	mv	a1,a4
 84a:	853e                	mv	a0,a5
 84c:	00000097          	auipc	ra,0x0
 850:	f5c080e7          	jalr	-164(ra) # 7a8 <write>
}
 854:	0001                	nop
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6105                	addi	sp,sp,32
 85c:	8082                	ret

000000000000085e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 85e:	7139                	addi	sp,sp,-64
 860:	fc06                	sd	ra,56(sp)
 862:	f822                	sd	s0,48(sp)
 864:	0080                	addi	s0,sp,64
 866:	87aa                	mv	a5,a0
 868:	8736                	mv	a4,a3
 86a:	fcf42623          	sw	a5,-52(s0)
 86e:	87ae                	mv	a5,a1
 870:	fcf42423          	sw	a5,-56(s0)
 874:	87b2                	mv	a5,a2
 876:	fcf42223          	sw	a5,-60(s0)
 87a:	87ba                	mv	a5,a4
 87c:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 880:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
 884:	fc042783          	lw	a5,-64(s0)
 888:	2781                	sext.w	a5,a5
 88a:	c38d                	beqz	a5,8ac <printint+0x4e>
 88c:	fc842783          	lw	a5,-56(s0)
 890:	2781                	sext.w	a5,a5
 892:	0007dd63          	bgez	a5,8ac <printint+0x4e>
    neg = 1;
 896:	4785                	li	a5,1
 898:	fef42423          	sw	a5,-24(s0)
    x = -xx;
 89c:	fc842783          	lw	a5,-56(s0)
 8a0:	40f007bb          	negw	a5,a5
 8a4:	2781                	sext.w	a5,a5
 8a6:	fef42223          	sw	a5,-28(s0)
 8aa:	a029                	j	8b4 <printint+0x56>
  } else {
    x = xx;
 8ac:	fc842783          	lw	a5,-56(s0)
 8b0:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
 8b4:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
 8b8:	fc442783          	lw	a5,-60(s0)
 8bc:	fe442703          	lw	a4,-28(s0)
 8c0:	02f777bb          	remuw	a5,a4,a5
 8c4:	0007861b          	sext.w	a2,a5
 8c8:	fec42783          	lw	a5,-20(s0)
 8cc:	0017871b          	addiw	a4,a5,1
 8d0:	fee42623          	sw	a4,-20(s0)
 8d4:	00002697          	auipc	a3,0x2
 8d8:	bbc68693          	addi	a3,a3,-1092 # 2490 <digits>
 8dc:	02061713          	slli	a4,a2,0x20
 8e0:	9301                	srli	a4,a4,0x20
 8e2:	9736                	add	a4,a4,a3
 8e4:	00074703          	lbu	a4,0(a4)
 8e8:	17c1                	addi	a5,a5,-16
 8ea:	97a2                	add	a5,a5,s0
 8ec:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
 8f0:	fc442783          	lw	a5,-60(s0)
 8f4:	fe442703          	lw	a4,-28(s0)
 8f8:	02f757bb          	divuw	a5,a4,a5
 8fc:	fef42223          	sw	a5,-28(s0)
 900:	fe442783          	lw	a5,-28(s0)
 904:	2781                	sext.w	a5,a5
 906:	fbcd                	bnez	a5,8b8 <printint+0x5a>
  if(neg)
 908:	fe842783          	lw	a5,-24(s0)
 90c:	2781                	sext.w	a5,a5
 90e:	cf85                	beqz	a5,946 <printint+0xe8>
    buf[i++] = '-';
 910:	fec42783          	lw	a5,-20(s0)
 914:	0017871b          	addiw	a4,a5,1
 918:	fee42623          	sw	a4,-20(s0)
 91c:	17c1                	addi	a5,a5,-16
 91e:	97a2                	add	a5,a5,s0
 920:	02d00713          	li	a4,45
 924:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
 928:	a839                	j	946 <printint+0xe8>
    putc(fd, buf[i]);
 92a:	fec42783          	lw	a5,-20(s0)
 92e:	17c1                	addi	a5,a5,-16
 930:	97a2                	add	a5,a5,s0
 932:	fe07c703          	lbu	a4,-32(a5)
 936:	fcc42783          	lw	a5,-52(s0)
 93a:	85ba                	mv	a1,a4
 93c:	853e                	mv	a0,a5
 93e:	00000097          	auipc	ra,0x0
 942:	eea080e7          	jalr	-278(ra) # 828 <putc>
  while(--i >= 0)
 946:	fec42783          	lw	a5,-20(s0)
 94a:	37fd                	addiw	a5,a5,-1
 94c:	fef42623          	sw	a5,-20(s0)
 950:	fec42783          	lw	a5,-20(s0)
 954:	2781                	sext.w	a5,a5
 956:	fc07dae3          	bgez	a5,92a <printint+0xcc>
}
 95a:	0001                	nop
 95c:	0001                	nop
 95e:	70e2                	ld	ra,56(sp)
 960:	7442                	ld	s0,48(sp)
 962:	6121                	addi	sp,sp,64
 964:	8082                	ret

0000000000000966 <printptr>:

static void
printptr(int fd, uint64 x) {
 966:	7179                	addi	sp,sp,-48
 968:	f406                	sd	ra,40(sp)
 96a:	f022                	sd	s0,32(sp)
 96c:	1800                	addi	s0,sp,48
 96e:	87aa                	mv	a5,a0
 970:	fcb43823          	sd	a1,-48(s0)
 974:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
 978:	fdc42783          	lw	a5,-36(s0)
 97c:	03000593          	li	a1,48
 980:	853e                	mv	a0,a5
 982:	00000097          	auipc	ra,0x0
 986:	ea6080e7          	jalr	-346(ra) # 828 <putc>
  putc(fd, 'x');
 98a:	fdc42783          	lw	a5,-36(s0)
 98e:	07800593          	li	a1,120
 992:	853e                	mv	a0,a5
 994:	00000097          	auipc	ra,0x0
 998:	e94080e7          	jalr	-364(ra) # 828 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 99c:	fe042623          	sw	zero,-20(s0)
 9a0:	a82d                	j	9da <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9a2:	fd043783          	ld	a5,-48(s0)
 9a6:	93f1                	srli	a5,a5,0x3c
 9a8:	00002717          	auipc	a4,0x2
 9ac:	ae870713          	addi	a4,a4,-1304 # 2490 <digits>
 9b0:	97ba                	add	a5,a5,a4
 9b2:	0007c703          	lbu	a4,0(a5)
 9b6:	fdc42783          	lw	a5,-36(s0)
 9ba:	85ba                	mv	a1,a4
 9bc:	853e                	mv	a0,a5
 9be:	00000097          	auipc	ra,0x0
 9c2:	e6a080e7          	jalr	-406(ra) # 828 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c6:	fec42783          	lw	a5,-20(s0)
 9ca:	2785                	addiw	a5,a5,1
 9cc:	fef42623          	sw	a5,-20(s0)
 9d0:	fd043783          	ld	a5,-48(s0)
 9d4:	0792                	slli	a5,a5,0x4
 9d6:	fcf43823          	sd	a5,-48(s0)
 9da:	fec42783          	lw	a5,-20(s0)
 9de:	873e                	mv	a4,a5
 9e0:	47bd                	li	a5,15
 9e2:	fce7f0e3          	bgeu	a5,a4,9a2 <printptr+0x3c>
}
 9e6:	0001                	nop
 9e8:	0001                	nop
 9ea:	70a2                	ld	ra,40(sp)
 9ec:	7402                	ld	s0,32(sp)
 9ee:	6145                	addi	sp,sp,48
 9f0:	8082                	ret

00000000000009f2 <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9f2:	715d                	addi	sp,sp,-80
 9f4:	e486                	sd	ra,72(sp)
 9f6:	e0a2                	sd	s0,64(sp)
 9f8:	0880                	addi	s0,sp,80
 9fa:	87aa                	mv	a5,a0
 9fc:	fcb43023          	sd	a1,-64(s0)
 a00:	fac43c23          	sd	a2,-72(s0)
 a04:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
 a08:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 a0c:	fe042223          	sw	zero,-28(s0)
 a10:	a42d                	j	c3a <vprintf+0x248>
    c = fmt[i] & 0xff;
 a12:	fe442783          	lw	a5,-28(s0)
 a16:	fc043703          	ld	a4,-64(s0)
 a1a:	97ba                	add	a5,a5,a4
 a1c:	0007c783          	lbu	a5,0(a5)
 a20:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
 a24:	fe042783          	lw	a5,-32(s0)
 a28:	2781                	sext.w	a5,a5
 a2a:	eb9d                	bnez	a5,a60 <vprintf+0x6e>
      if(c == '%'){
 a2c:	fdc42783          	lw	a5,-36(s0)
 a30:	0007871b          	sext.w	a4,a5
 a34:	02500793          	li	a5,37
 a38:	00f71763          	bne	a4,a5,a46 <vprintf+0x54>
        state = '%';
 a3c:	02500793          	li	a5,37
 a40:	fef42023          	sw	a5,-32(s0)
 a44:	a2f5                	j	c30 <vprintf+0x23e>
      } else {
        putc(fd, c);
 a46:	fdc42783          	lw	a5,-36(s0)
 a4a:	0ff7f713          	zext.b	a4,a5
 a4e:	fcc42783          	lw	a5,-52(s0)
 a52:	85ba                	mv	a1,a4
 a54:	853e                	mv	a0,a5
 a56:	00000097          	auipc	ra,0x0
 a5a:	dd2080e7          	jalr	-558(ra) # 828 <putc>
 a5e:	aac9                	j	c30 <vprintf+0x23e>
      }
    } else if(state == '%'){
 a60:	fe042783          	lw	a5,-32(s0)
 a64:	0007871b          	sext.w	a4,a5
 a68:	02500793          	li	a5,37
 a6c:	1cf71263          	bne	a4,a5,c30 <vprintf+0x23e>
      if(c == 'd'){
 a70:	fdc42783          	lw	a5,-36(s0)
 a74:	0007871b          	sext.w	a4,a5
 a78:	06400793          	li	a5,100
 a7c:	02f71463          	bne	a4,a5,aa4 <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
 a80:	fb843783          	ld	a5,-72(s0)
 a84:	00878713          	addi	a4,a5,8
 a88:	fae43c23          	sd	a4,-72(s0)
 a8c:	4398                	lw	a4,0(a5)
 a8e:	fcc42783          	lw	a5,-52(s0)
 a92:	4685                	li	a3,1
 a94:	4629                	li	a2,10
 a96:	85ba                	mv	a1,a4
 a98:	853e                	mv	a0,a5
 a9a:	00000097          	auipc	ra,0x0
 a9e:	dc4080e7          	jalr	-572(ra) # 85e <printint>
 aa2:	a269                	j	c2c <vprintf+0x23a>
      } else if(c == 'l') {
 aa4:	fdc42783          	lw	a5,-36(s0)
 aa8:	0007871b          	sext.w	a4,a5
 aac:	06c00793          	li	a5,108
 ab0:	02f71663          	bne	a4,a5,adc <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab4:	fb843783          	ld	a5,-72(s0)
 ab8:	00878713          	addi	a4,a5,8
 abc:	fae43c23          	sd	a4,-72(s0)
 ac0:	639c                	ld	a5,0(a5)
 ac2:	0007871b          	sext.w	a4,a5
 ac6:	fcc42783          	lw	a5,-52(s0)
 aca:	4681                	li	a3,0
 acc:	4629                	li	a2,10
 ace:	85ba                	mv	a1,a4
 ad0:	853e                	mv	a0,a5
 ad2:	00000097          	auipc	ra,0x0
 ad6:	d8c080e7          	jalr	-628(ra) # 85e <printint>
 ada:	aa89                	j	c2c <vprintf+0x23a>
      } else if(c == 'x') {
 adc:	fdc42783          	lw	a5,-36(s0)
 ae0:	0007871b          	sext.w	a4,a5
 ae4:	07800793          	li	a5,120
 ae8:	02f71463          	bne	a4,a5,b10 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
 aec:	fb843783          	ld	a5,-72(s0)
 af0:	00878713          	addi	a4,a5,8
 af4:	fae43c23          	sd	a4,-72(s0)
 af8:	4398                	lw	a4,0(a5)
 afa:	fcc42783          	lw	a5,-52(s0)
 afe:	4681                	li	a3,0
 b00:	4641                	li	a2,16
 b02:	85ba                	mv	a1,a4
 b04:	853e                	mv	a0,a5
 b06:	00000097          	auipc	ra,0x0
 b0a:	d58080e7          	jalr	-680(ra) # 85e <printint>
 b0e:	aa39                	j	c2c <vprintf+0x23a>
      } else if(c == 'p') {
 b10:	fdc42783          	lw	a5,-36(s0)
 b14:	0007871b          	sext.w	a4,a5
 b18:	07000793          	li	a5,112
 b1c:	02f71263          	bne	a4,a5,b40 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
 b20:	fb843783          	ld	a5,-72(s0)
 b24:	00878713          	addi	a4,a5,8
 b28:	fae43c23          	sd	a4,-72(s0)
 b2c:	6398                	ld	a4,0(a5)
 b2e:	fcc42783          	lw	a5,-52(s0)
 b32:	85ba                	mv	a1,a4
 b34:	853e                	mv	a0,a5
 b36:	00000097          	auipc	ra,0x0
 b3a:	e30080e7          	jalr	-464(ra) # 966 <printptr>
 b3e:	a0fd                	j	c2c <vprintf+0x23a>
      } else if(c == 's'){
 b40:	fdc42783          	lw	a5,-36(s0)
 b44:	0007871b          	sext.w	a4,a5
 b48:	07300793          	li	a5,115
 b4c:	04f71c63          	bne	a4,a5,ba4 <vprintf+0x1b2>
        s = va_arg(ap, char*);
 b50:	fb843783          	ld	a5,-72(s0)
 b54:	00878713          	addi	a4,a5,8
 b58:	fae43c23          	sd	a4,-72(s0)
 b5c:	639c                	ld	a5,0(a5)
 b5e:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
 b62:	fe843783          	ld	a5,-24(s0)
 b66:	eb8d                	bnez	a5,b98 <vprintf+0x1a6>
          s = "(null)";
 b68:	00000797          	auipc	a5,0x0
 b6c:	4b078793          	addi	a5,a5,1200 # 1018 <malloc+0x176>
 b70:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 b74:	a015                	j	b98 <vprintf+0x1a6>
          putc(fd, *s);
 b76:	fe843783          	ld	a5,-24(s0)
 b7a:	0007c703          	lbu	a4,0(a5)
 b7e:	fcc42783          	lw	a5,-52(s0)
 b82:	85ba                	mv	a1,a4
 b84:	853e                	mv	a0,a5
 b86:	00000097          	auipc	ra,0x0
 b8a:	ca2080e7          	jalr	-862(ra) # 828 <putc>
          s++;
 b8e:	fe843783          	ld	a5,-24(s0)
 b92:	0785                	addi	a5,a5,1
 b94:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
 b98:	fe843783          	ld	a5,-24(s0)
 b9c:	0007c783          	lbu	a5,0(a5)
 ba0:	fbf9                	bnez	a5,b76 <vprintf+0x184>
 ba2:	a069                	j	c2c <vprintf+0x23a>
        }
      } else if(c == 'c'){
 ba4:	fdc42783          	lw	a5,-36(s0)
 ba8:	0007871b          	sext.w	a4,a5
 bac:	06300793          	li	a5,99
 bb0:	02f71463          	bne	a4,a5,bd8 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
 bb4:	fb843783          	ld	a5,-72(s0)
 bb8:	00878713          	addi	a4,a5,8
 bbc:	fae43c23          	sd	a4,-72(s0)
 bc0:	439c                	lw	a5,0(a5)
 bc2:	0ff7f713          	zext.b	a4,a5
 bc6:	fcc42783          	lw	a5,-52(s0)
 bca:	85ba                	mv	a1,a4
 bcc:	853e                	mv	a0,a5
 bce:	00000097          	auipc	ra,0x0
 bd2:	c5a080e7          	jalr	-934(ra) # 828 <putc>
 bd6:	a899                	j	c2c <vprintf+0x23a>
      } else if(c == '%'){
 bd8:	fdc42783          	lw	a5,-36(s0)
 bdc:	0007871b          	sext.w	a4,a5
 be0:	02500793          	li	a5,37
 be4:	00f71f63          	bne	a4,a5,c02 <vprintf+0x210>
        putc(fd, c);
 be8:	fdc42783          	lw	a5,-36(s0)
 bec:	0ff7f713          	zext.b	a4,a5
 bf0:	fcc42783          	lw	a5,-52(s0)
 bf4:	85ba                	mv	a1,a4
 bf6:	853e                	mv	a0,a5
 bf8:	00000097          	auipc	ra,0x0
 bfc:	c30080e7          	jalr	-976(ra) # 828 <putc>
 c00:	a035                	j	c2c <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c02:	fcc42783          	lw	a5,-52(s0)
 c06:	02500593          	li	a1,37
 c0a:	853e                	mv	a0,a5
 c0c:	00000097          	auipc	ra,0x0
 c10:	c1c080e7          	jalr	-996(ra) # 828 <putc>
        putc(fd, c);
 c14:	fdc42783          	lw	a5,-36(s0)
 c18:	0ff7f713          	zext.b	a4,a5
 c1c:	fcc42783          	lw	a5,-52(s0)
 c20:	85ba                	mv	a1,a4
 c22:	853e                	mv	a0,a5
 c24:	00000097          	auipc	ra,0x0
 c28:	c04080e7          	jalr	-1020(ra) # 828 <putc>
      }
      state = 0;
 c2c:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
 c30:	fe442783          	lw	a5,-28(s0)
 c34:	2785                	addiw	a5,a5,1
 c36:	fef42223          	sw	a5,-28(s0)
 c3a:	fe442783          	lw	a5,-28(s0)
 c3e:	fc043703          	ld	a4,-64(s0)
 c42:	97ba                	add	a5,a5,a4
 c44:	0007c783          	lbu	a5,0(a5)
 c48:	dc0795e3          	bnez	a5,a12 <vprintf+0x20>
    }
  }
}
 c4c:	0001                	nop
 c4e:	0001                	nop
 c50:	60a6                	ld	ra,72(sp)
 c52:	6406                	ld	s0,64(sp)
 c54:	6161                	addi	sp,sp,80
 c56:	8082                	ret

0000000000000c58 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c58:	7159                	addi	sp,sp,-112
 c5a:	fc06                	sd	ra,56(sp)
 c5c:	f822                	sd	s0,48(sp)
 c5e:	0080                	addi	s0,sp,64
 c60:	fcb43823          	sd	a1,-48(s0)
 c64:	e010                	sd	a2,0(s0)
 c66:	e414                	sd	a3,8(s0)
 c68:	e818                	sd	a4,16(s0)
 c6a:	ec1c                	sd	a5,24(s0)
 c6c:	03043023          	sd	a6,32(s0)
 c70:	03143423          	sd	a7,40(s0)
 c74:	87aa                	mv	a5,a0
 c76:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
 c7a:	03040793          	addi	a5,s0,48
 c7e:	fcf43423          	sd	a5,-56(s0)
 c82:	fc843783          	ld	a5,-56(s0)
 c86:	fd078793          	addi	a5,a5,-48
 c8a:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
 c8e:	fe843703          	ld	a4,-24(s0)
 c92:	fdc42783          	lw	a5,-36(s0)
 c96:	863a                	mv	a2,a4
 c98:	fd043583          	ld	a1,-48(s0)
 c9c:	853e                	mv	a0,a5
 c9e:	00000097          	auipc	ra,0x0
 ca2:	d54080e7          	jalr	-684(ra) # 9f2 <vprintf>
}
 ca6:	0001                	nop
 ca8:	70e2                	ld	ra,56(sp)
 caa:	7442                	ld	s0,48(sp)
 cac:	6165                	addi	sp,sp,112
 cae:	8082                	ret

0000000000000cb0 <printf>:

void
printf(const char *fmt, ...)
{
 cb0:	7159                	addi	sp,sp,-112
 cb2:	f406                	sd	ra,40(sp)
 cb4:	f022                	sd	s0,32(sp)
 cb6:	1800                	addi	s0,sp,48
 cb8:	fca43c23          	sd	a0,-40(s0)
 cbc:	e40c                	sd	a1,8(s0)
 cbe:	e810                	sd	a2,16(s0)
 cc0:	ec14                	sd	a3,24(s0)
 cc2:	f018                	sd	a4,32(s0)
 cc4:	f41c                	sd	a5,40(s0)
 cc6:	03043823          	sd	a6,48(s0)
 cca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cce:	04040793          	addi	a5,s0,64
 cd2:	fcf43823          	sd	a5,-48(s0)
 cd6:	fd043783          	ld	a5,-48(s0)
 cda:	fc878793          	addi	a5,a5,-56
 cde:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
 ce2:	fe843783          	ld	a5,-24(s0)
 ce6:	863e                	mv	a2,a5
 ce8:	fd843583          	ld	a1,-40(s0)
 cec:	4505                	li	a0,1
 cee:	00000097          	auipc	ra,0x0
 cf2:	d04080e7          	jalr	-764(ra) # 9f2 <vprintf>
}
 cf6:	0001                	nop
 cf8:	70a2                	ld	ra,40(sp)
 cfa:	7402                	ld	s0,32(sp)
 cfc:	6165                	addi	sp,sp,112
 cfe:	8082                	ret

0000000000000d00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d00:	7179                	addi	sp,sp,-48
 d02:	f422                	sd	s0,40(sp)
 d04:	1800                	addi	s0,sp,48
 d06:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d0a:	fd843783          	ld	a5,-40(s0)
 d0e:	17c1                	addi	a5,a5,-16
 d10:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d14:	00001797          	auipc	a5,0x1
 d18:	7ac78793          	addi	a5,a5,1964 # 24c0 <freep>
 d1c:	639c                	ld	a5,0(a5)
 d1e:	fef43423          	sd	a5,-24(s0)
 d22:	a815                	j	d56 <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d24:	fe843783          	ld	a5,-24(s0)
 d28:	639c                	ld	a5,0(a5)
 d2a:	fe843703          	ld	a4,-24(s0)
 d2e:	00f76f63          	bltu	a4,a5,d4c <free+0x4c>
 d32:	fe043703          	ld	a4,-32(s0)
 d36:	fe843783          	ld	a5,-24(s0)
 d3a:	02e7eb63          	bltu	a5,a4,d70 <free+0x70>
 d3e:	fe843783          	ld	a5,-24(s0)
 d42:	639c                	ld	a5,0(a5)
 d44:	fe043703          	ld	a4,-32(s0)
 d48:	02f76463          	bltu	a4,a5,d70 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d4c:	fe843783          	ld	a5,-24(s0)
 d50:	639c                	ld	a5,0(a5)
 d52:	fef43423          	sd	a5,-24(s0)
 d56:	fe043703          	ld	a4,-32(s0)
 d5a:	fe843783          	ld	a5,-24(s0)
 d5e:	fce7f3e3          	bgeu	a5,a4,d24 <free+0x24>
 d62:	fe843783          	ld	a5,-24(s0)
 d66:	639c                	ld	a5,0(a5)
 d68:	fe043703          	ld	a4,-32(s0)
 d6c:	faf77ce3          	bgeu	a4,a5,d24 <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
 d70:	fe043783          	ld	a5,-32(s0)
 d74:	479c                	lw	a5,8(a5)
 d76:	1782                	slli	a5,a5,0x20
 d78:	9381                	srli	a5,a5,0x20
 d7a:	0792                	slli	a5,a5,0x4
 d7c:	fe043703          	ld	a4,-32(s0)
 d80:	973e                	add	a4,a4,a5
 d82:	fe843783          	ld	a5,-24(s0)
 d86:	639c                	ld	a5,0(a5)
 d88:	02f71763          	bne	a4,a5,db6 <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
 d8c:	fe043783          	ld	a5,-32(s0)
 d90:	4798                	lw	a4,8(a5)
 d92:	fe843783          	ld	a5,-24(s0)
 d96:	639c                	ld	a5,0(a5)
 d98:	479c                	lw	a5,8(a5)
 d9a:	9fb9                	addw	a5,a5,a4
 d9c:	0007871b          	sext.w	a4,a5
 da0:	fe043783          	ld	a5,-32(s0)
 da4:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
 da6:	fe843783          	ld	a5,-24(s0)
 daa:	639c                	ld	a5,0(a5)
 dac:	6398                	ld	a4,0(a5)
 dae:	fe043783          	ld	a5,-32(s0)
 db2:	e398                	sd	a4,0(a5)
 db4:	a039                	j	dc2 <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
 db6:	fe843783          	ld	a5,-24(s0)
 dba:	6398                	ld	a4,0(a5)
 dbc:	fe043783          	ld	a5,-32(s0)
 dc0:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
 dc2:	fe843783          	ld	a5,-24(s0)
 dc6:	479c                	lw	a5,8(a5)
 dc8:	1782                	slli	a5,a5,0x20
 dca:	9381                	srli	a5,a5,0x20
 dcc:	0792                	slli	a5,a5,0x4
 dce:	fe843703          	ld	a4,-24(s0)
 dd2:	97ba                	add	a5,a5,a4
 dd4:	fe043703          	ld	a4,-32(s0)
 dd8:	02f71563          	bne	a4,a5,e02 <free+0x102>
    p->s.size += bp->s.size;
 ddc:	fe843783          	ld	a5,-24(s0)
 de0:	4798                	lw	a4,8(a5)
 de2:	fe043783          	ld	a5,-32(s0)
 de6:	479c                	lw	a5,8(a5)
 de8:	9fb9                	addw	a5,a5,a4
 dea:	0007871b          	sext.w	a4,a5
 dee:	fe843783          	ld	a5,-24(s0)
 df2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 df4:	fe043783          	ld	a5,-32(s0)
 df8:	6398                	ld	a4,0(a5)
 dfa:	fe843783          	ld	a5,-24(s0)
 dfe:	e398                	sd	a4,0(a5)
 e00:	a031                	j	e0c <free+0x10c>
  } else
    p->s.ptr = bp;
 e02:	fe843783          	ld	a5,-24(s0)
 e06:	fe043703          	ld	a4,-32(s0)
 e0a:	e398                	sd	a4,0(a5)
  freep = p;
 e0c:	00001797          	auipc	a5,0x1
 e10:	6b478793          	addi	a5,a5,1716 # 24c0 <freep>
 e14:	fe843703          	ld	a4,-24(s0)
 e18:	e398                	sd	a4,0(a5)
}
 e1a:	0001                	nop
 e1c:	7422                	ld	s0,40(sp)
 e1e:	6145                	addi	sp,sp,48
 e20:	8082                	ret

0000000000000e22 <morecore>:

static Header*
morecore(uint nu)
{
 e22:	7179                	addi	sp,sp,-48
 e24:	f406                	sd	ra,40(sp)
 e26:	f022                	sd	s0,32(sp)
 e28:	1800                	addi	s0,sp,48
 e2a:	87aa                	mv	a5,a0
 e2c:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
 e30:	fdc42783          	lw	a5,-36(s0)
 e34:	0007871b          	sext.w	a4,a5
 e38:	6785                	lui	a5,0x1
 e3a:	00f77563          	bgeu	a4,a5,e44 <morecore+0x22>
    nu = 4096;
 e3e:	6785                	lui	a5,0x1
 e40:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
 e44:	fdc42783          	lw	a5,-36(s0)
 e48:	0047979b          	slliw	a5,a5,0x4
 e4c:	2781                	sext.w	a5,a5
 e4e:	2781                	sext.w	a5,a5
 e50:	853e                	mv	a0,a5
 e52:	00000097          	auipc	ra,0x0
 e56:	9be080e7          	jalr	-1602(ra) # 810 <sbrk>
 e5a:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
 e5e:	fe843703          	ld	a4,-24(s0)
 e62:	57fd                	li	a5,-1
 e64:	00f71463          	bne	a4,a5,e6c <morecore+0x4a>
    return 0;
 e68:	4781                	li	a5,0
 e6a:	a03d                	j	e98 <morecore+0x76>
  hp = (Header*)p;
 e6c:	fe843783          	ld	a5,-24(s0)
 e70:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
 e74:	fe043783          	ld	a5,-32(s0)
 e78:	fdc42703          	lw	a4,-36(s0)
 e7c:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
 e7e:	fe043783          	ld	a5,-32(s0)
 e82:	07c1                	addi	a5,a5,16 # 1010 <malloc+0x16e>
 e84:	853e                	mv	a0,a5
 e86:	00000097          	auipc	ra,0x0
 e8a:	e7a080e7          	jalr	-390(ra) # d00 <free>
  return freep;
 e8e:	00001797          	auipc	a5,0x1
 e92:	63278793          	addi	a5,a5,1586 # 24c0 <freep>
 e96:	639c                	ld	a5,0(a5)
}
 e98:	853e                	mv	a0,a5
 e9a:	70a2                	ld	ra,40(sp)
 e9c:	7402                	ld	s0,32(sp)
 e9e:	6145                	addi	sp,sp,48
 ea0:	8082                	ret

0000000000000ea2 <malloc>:

void*
malloc(uint nbytes)
{
 ea2:	7139                	addi	sp,sp,-64
 ea4:	fc06                	sd	ra,56(sp)
 ea6:	f822                	sd	s0,48(sp)
 ea8:	0080                	addi	s0,sp,64
 eaa:	87aa                	mv	a5,a0
 eac:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 eb0:	fcc46783          	lwu	a5,-52(s0)
 eb4:	07bd                	addi	a5,a5,15
 eb6:	8391                	srli	a5,a5,0x4
 eb8:	2781                	sext.w	a5,a5
 eba:	2785                	addiw	a5,a5,1
 ebc:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
 ec0:	00001797          	auipc	a5,0x1
 ec4:	60078793          	addi	a5,a5,1536 # 24c0 <freep>
 ec8:	639c                	ld	a5,0(a5)
 eca:	fef43023          	sd	a5,-32(s0)
 ece:	fe043783          	ld	a5,-32(s0)
 ed2:	ef95                	bnez	a5,f0e <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
 ed4:	00001797          	auipc	a5,0x1
 ed8:	5dc78793          	addi	a5,a5,1500 # 24b0 <base>
 edc:	fef43023          	sd	a5,-32(s0)
 ee0:	00001797          	auipc	a5,0x1
 ee4:	5e078793          	addi	a5,a5,1504 # 24c0 <freep>
 ee8:	fe043703          	ld	a4,-32(s0)
 eec:	e398                	sd	a4,0(a5)
 eee:	00001797          	auipc	a5,0x1
 ef2:	5d278793          	addi	a5,a5,1490 # 24c0 <freep>
 ef6:	6398                	ld	a4,0(a5)
 ef8:	00001797          	auipc	a5,0x1
 efc:	5b878793          	addi	a5,a5,1464 # 24b0 <base>
 f00:	e398                	sd	a4,0(a5)
    base.s.size = 0;
 f02:	00001797          	auipc	a5,0x1
 f06:	5ae78793          	addi	a5,a5,1454 # 24b0 <base>
 f0a:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f0e:	fe043783          	ld	a5,-32(s0)
 f12:	639c                	ld	a5,0(a5)
 f14:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 f18:	fe843783          	ld	a5,-24(s0)
 f1c:	4798                	lw	a4,8(a5)
 f1e:	fdc42783          	lw	a5,-36(s0)
 f22:	2781                	sext.w	a5,a5
 f24:	06f76763          	bltu	a4,a5,f92 <malloc+0xf0>
      if(p->s.size == nunits)
 f28:	fe843783          	ld	a5,-24(s0)
 f2c:	4798                	lw	a4,8(a5)
 f2e:	fdc42783          	lw	a5,-36(s0)
 f32:	2781                	sext.w	a5,a5
 f34:	00e79963          	bne	a5,a4,f46 <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
 f38:	fe843783          	ld	a5,-24(s0)
 f3c:	6398                	ld	a4,0(a5)
 f3e:	fe043783          	ld	a5,-32(s0)
 f42:	e398                	sd	a4,0(a5)
 f44:	a825                	j	f7c <malloc+0xda>
      else {
        p->s.size -= nunits;
 f46:	fe843783          	ld	a5,-24(s0)
 f4a:	479c                	lw	a5,8(a5)
 f4c:	fdc42703          	lw	a4,-36(s0)
 f50:	9f99                	subw	a5,a5,a4
 f52:	0007871b          	sext.w	a4,a5
 f56:	fe843783          	ld	a5,-24(s0)
 f5a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 f5c:	fe843783          	ld	a5,-24(s0)
 f60:	479c                	lw	a5,8(a5)
 f62:	1782                	slli	a5,a5,0x20
 f64:	9381                	srli	a5,a5,0x20
 f66:	0792                	slli	a5,a5,0x4
 f68:	fe843703          	ld	a4,-24(s0)
 f6c:	97ba                	add	a5,a5,a4
 f6e:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
 f72:	fe843783          	ld	a5,-24(s0)
 f76:	fdc42703          	lw	a4,-36(s0)
 f7a:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
 f7c:	00001797          	auipc	a5,0x1
 f80:	54478793          	addi	a5,a5,1348 # 24c0 <freep>
 f84:	fe043703          	ld	a4,-32(s0)
 f88:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
 f8a:	fe843783          	ld	a5,-24(s0)
 f8e:	07c1                	addi	a5,a5,16
 f90:	a091                	j	fd4 <malloc+0x132>
    }
    if(p == freep)
 f92:	00001797          	auipc	a5,0x1
 f96:	52e78793          	addi	a5,a5,1326 # 24c0 <freep>
 f9a:	639c                	ld	a5,0(a5)
 f9c:	fe843703          	ld	a4,-24(s0)
 fa0:	02f71063          	bne	a4,a5,fc0 <malloc+0x11e>
      if((p = morecore(nunits)) == 0)
 fa4:	fdc42783          	lw	a5,-36(s0)
 fa8:	853e                	mv	a0,a5
 faa:	00000097          	auipc	ra,0x0
 fae:	e78080e7          	jalr	-392(ra) # e22 <morecore>
 fb2:	fea43423          	sd	a0,-24(s0)
 fb6:	fe843783          	ld	a5,-24(s0)
 fba:	e399                	bnez	a5,fc0 <malloc+0x11e>
        return 0;
 fbc:	4781                	li	a5,0
 fbe:	a819                	j	fd4 <malloc+0x132>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 fc0:	fe843783          	ld	a5,-24(s0)
 fc4:	fef43023          	sd	a5,-32(s0)
 fc8:	fe843783          	ld	a5,-24(s0)
 fcc:	639c                	ld	a5,0(a5)
 fce:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
 fd2:	b799                	j	f18 <malloc+0x76>
  }
}
 fd4:	853e                	mv	a0,a5
 fd6:	70e2                	ld	ra,56(sp)
 fd8:	7442                	ld	s0,48(sp)
 fda:	6121                	addi	sp,sp,64
 fdc:	8082                	ret
