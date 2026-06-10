
flashboot.elf:     file format elf32-littleriscv


Disassembly of section .text.entry:

00a28300 <_start>:
  a28300:	0040006f          	j	a28304 <Reset_Handler>

00a28304 <Reset_Handler>:
  a28304:	00000293          	li	t0,0
  a28308:	3a029073          	csrw	pmpcfg0,t0
  a2830c:	00000293          	li	t0,0
  a28310:	3a129073          	csrw	pmpcfg1,t0
  a28314:	00000293          	li	t0,0
  a28318:	3a229073          	csrw	pmpcfg2,t0
  a2831c:	00000293          	li	t0,0
  a28320:	3a329073          	csrw	pmpcfg3,t0
  a28324:	00000293          	li	t0,0
  a28328:	7d929073          	csrw	0x7d9,t0
  a2832c:	fffdd297          	auipc	t0,0xfffdd
  a28330:	7dc28293          	addi	t0,t0,2012 # a05b08 <__bss_end__>
  a28334:	00050313          	mv	t1,a0
  a28338:	00032e03          	lw	t3,0(t1)
  a2833c:	01c2a023          	sw	t3,0(t0)
  a28340:	00009297          	auipc	t0,0x9
  a28344:	2fc28293          	addi	t0,t0,764 # a3163c <trap_vector>
  a28348:	00128293          	addi	t0,t0,1
  a2834c:	30529073          	csrw	mtvec,t0
  a28350:	30005073          	csrwi	mstatus,0
  a28354:	30405073          	csrwi	mie,0
  a28358:	0000c197          	auipc	gp,0xc
  a2835c:	4ec18193          	addi	gp,gp,1260 # a34844 <_gp_>
  a28360:	fffdd117          	auipc	sp,0xfffdd
  a28364:	9a010113          	addi	sp,sp,-1632 # a04d00 <__stack_top__>
  a28368:	fffdb297          	auipc	t0,0xfffdb
  a2836c:	d9828293          	addi	t0,t0,-616 # a03100 <g_system_stack_begin>
  a28370:	fffdd317          	auipc	t1,0xfffdd
  a28374:	19030313          	addi	t1,t1,400 # a05500 <g_flash_cmd_funcs>
  a28378:	00628c63          	beq	t0,t1,a28390 <end_set_stack_loop>
  a2837c:	efbeb3b7          	lui	t2,0xefbeb
  a28380:	dde38393          	addi	t2,t2,-546 # efbeadde <_gp_+0xef1b659a>

00a28384 <set_stack_loop>:
  a28384:	0072a023          	sw	t2,0(t0)
  a28388:	00428293          	addi	t0,t0,4
  a2838c:	fe62cce3          	blt	t0,t1,a28384 <set_stack_loop>

00a28390 <end_set_stack_loop>:
  a28390:	00000093          	li	ra,0
  a28394:	00000213          	li	tp,0
  a28398:	00000413          	li	s0,0
  a2839c:	00000493          	li	s1,0
  a283a0:	00000513          	li	a0,0
  a283a4:	00000593          	li	a1,0
  a283a8:	00000613          	li	a2,0
  a283ac:	00000693          	li	a3,0
  a283b0:	00000713          	li	a4,0
  a283b4:	00000793          	li	a5,0
  a283b8:	00000813          	li	a6,0
  a283bc:	00000893          	li	a7,0
  a283c0:	00000913          	li	s2,0
  a283c4:	00000993          	li	s3,0
  a283c8:	00000a13          	li	s4,0
  a283cc:	00000a93          	li	s5,0
  a283d0:	00000b13          	li	s6,0
  a283d4:	00000b93          	li	s7,0
  a283d8:	00000c13          	li	s8,0
  a283dc:	00000c93          	li	s9,0
  a283e0:	00000d13          	li	s10,0
  a283e4:	00000d93          	li	s11,0
  a283e8:	00000e13          	li	t3,0
  a283ec:	00000e93          	li	t4,0
  a283f0:	00000f13          	li	t5,0
  a283f4:	00000f93          	li	t6,0
  a283f8:	fffdd297          	auipc	t0,0xfffdd
  a283fc:	10828293          	addi	t0,t0,264 # a05500 <g_flash_cmd_funcs>
  a28400:	fffdd317          	auipc	t1,0xfffdd
  a28404:	70830313          	addi	t1,t1,1800 # a05b08 <__bss_end__>
  a28408:	00628a63          	beq	t0,t1,a2841c <end_clear_bss_loop>
  a2840c:	00000393          	li	t2,0

00a28410 <clear_bss_loop>:
  a28410:	0072a023          	sw	t2,0(t0)
  a28414:	00428293          	addi	t0,t0,4
  a28418:	fe62cce3          	blt	t0,t1,a28410 <clear_bss_loop>

00a2841c <end_clear_bss_loop>:
  a2841c:	25d0006f          	j	a28e78 <start_fastboot>

00a28420 <g_ram_exception_table>:
  a28420:	00a31540 00a2d37c 00a2d37c 00a2d37c     @...|...|...|...
  a28430:	00a2d37c 00a2d37c 00a2d37c 00a2d37c     |...|...|...|...
  a28440:	00a2d37c 00a2d37c 00a2d37c 00a2d37c     |...|...|...|...
  a28450:	00a2d390 00a2d37c 00a2d37c 00a2d37c     ....|...|...|...
  a28460:	00a2d37c 00a2d37c 00a2d37c 00a2d37c     |...|...|...|...
  a28470:	00a2d37c 00a2d37c 00a2d37c 00a2d37c     |...|...|...|...
  a28480:	00a2d37c 00a2d37c 00a2cf58 00a2cf58     |...|...X...X...
  a28490:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a284a0:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a284b0:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a284c0:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a284d0:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a284e0:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a284f0:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a28500:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a28510:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a28520:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a28530:	00a2cf58 00a2cf58 00a2cf58 00a2cf58     X...X...X...X...
  a28540:	00a2cf58 00a2cf58                       X...X...

Disassembly of section .text:

00a28550 <exc_syscall>:
  a28550:	8082                	ret

00a28552 <handle_syscall>:
  a28552:	0411                	addi	s0,s0,4
  a28554:	c022                	sw	s0,0(sp)
  a28556:	3fed                	jal	ra,a28550 <exc_syscall>
  a28558:	42d2                	lw	t0,20(sp)
  a2855a:	34129073          	csrw	mepc,t0
  a2855e:	5d82                	lw	s11,32(sp)
  a28560:	5d12                	lw	s10,36(sp)
  a28562:	5ca2                	lw	s9,40(sp)
  a28564:	5c32                	lw	s8,44(sp)
  a28566:	5bc2                	lw	s7,48(sp)
  a28568:	5b52                	lw	s6,52(sp)
  a2856a:	5ae2                	lw	s5,56(sp)
  a2856c:	5a72                	lw	s4,60(sp)
  a2856e:	4986                	lw	s3,64(sp)
  a28570:	4916                	lw	s2,68(sp)
  a28572:	44a6                	lw	s1,72(sp)
  a28574:	4436                	lw	s0,76(sp)
  a28576:	4fc6                	lw	t6,80(sp)
  a28578:	4f56                	lw	t5,84(sp)
  a2857a:	4ee6                	lw	t4,88(sp)
  a2857c:	4e76                	lw	t3,92(sp)
  a2857e:	5886                	lw	a7,96(sp)
  a28580:	5816                	lw	a6,100(sp)
  a28582:	57a6                	lw	a5,104(sp)
  a28584:	5736                	lw	a4,108(sp)
  a28586:	56c6                	lw	a3,112(sp)
  a28588:	5656                	lw	a2,116(sp)
  a2858a:	55e6                	lw	a1,120(sp)
  a2858c:	5576                	lw	a0,124(sp)
  a2858e:	438a                	lw	t2,128(sp)
  a28590:	431a                	lw	t1,132(sp)
  a28592:	42aa                	lw	t0,136(sp)
  a28594:	40ba                	lw	ra,140(sp)
  a28596:	6149                	addi	sp,sp,144
  a28598:	30200073          	mret

00a2859c <__udivdi3>:
  a2859c:	4701                	li	a4,0
  a2859e:	a039                	j	a285ac <__udivmoddi4>

00a285a0 <__umoddi3>:
  a285a0:	8118                	push	{ra},-32
  a285a2:	0038                	addi	a4,sp,8
  a285a4:	2021                	jal	ra,a285ac <__udivmoddi4>
  a285a6:	4522                	lw	a0,8(sp)
  a285a8:	45b2                	lw	a1,12(sp)
  a285aa:	8114                	popret	{ra},32

00a285ac <__udivmoddi4>:
  a285ac:	88b6                	mv	a7,a3
  a285ae:	8832                	mv	a6,a2
  a285b0:	87aa                	mv	a5,a0
  a285b2:	8e2e                	mv	t3,a1
  a285b4:	eedd                	bnez	a3,a28672 <__udivmoddi4+0xc6>
  a285b6:	12c5f163          	bgeu	a1,a2,a286d8 <__udivmoddi4+0x12c>
  a285ba:	66c1                	lui	a3,0x10
  a285bc:	1cd66a63          	bltu	a2,a3,a28790 <__udivmoddi4+0x1e4>
  a285c0:	010006b7          	lui	a3,0x1000
  a285c4:	3ad66563          	bltu	a2,a3,a2896e <__udivmoddi4+0x3c2>
  a285c8:	01865313          	srli	t1,a2,0x18
  a285cc:	48e1                	li	a7,24
  a285ce:	0000c697          	auipc	a3,0xc
  a285d2:	a6a6a683          	lw	a3,-1430(a3) # a34038 <_GLOBAL_OFFSET_TABLE_+0x4>
  a285d6:	969a                	add	a3,a3,t1
  a285d8:	2294                	lbu	a3,0(a3)
  a285da:	02000313          	li	t1,32
  a285de:	98b6                	add	a7,a7,a3
  a285e0:	41130333          	sub	t1,t1,a7
  a285e4:	00030c63          	beqz	t1,a285fc <__udivmoddi4+0x50>
  a285e8:	006595b3          	sll	a1,a1,t1
  a285ec:	011558b3          	srl	a7,a0,a7
  a285f0:	00661833          	sll	a6,a2,t1
  a285f4:	00b8ee33          	or	t3,a7,a1
  a285f8:	006517b3          	sll	a5,a0,t1
  a285fc:	01085e93          	srli	t4,a6,0x10
  a28600:	03de5f33          	divu	t5,t3,t4
  a28604:	01081613          	slli	a2,a6,0x10
  a28608:	8241                	srli	a2,a2,0x10
  a2860a:	0107d693          	srli	a3,a5,0x10
  a2860e:	03de75b3          	remu	a1,t3,t4
  a28612:	03e60fb3          	mul	t6,a2,t5
  a28616:	20b6a69b          	orshf	a3,a3,a1,sll,16
  a2861a:	01f6fa63          	bgeu	a3,t6,a2862e <__udivmoddi4+0x82>
  a2861e:	96c2                	add	a3,a3,a6
  a28620:	ffff0593          	addi	a1,t5,-1
  a28624:	0106e463          	bltu	a3,a6,a2862c <__udivmoddi4+0x80>
  a28628:	37f6e563          	bltu	a3,t6,a28992 <__udivmoddi4+0x3e6>
  a2862c:	8f2e                	mv	t5,a1
  a2862e:	41f685b3          	sub	a1,a3,t6
  a28632:	03d5d533          	divu	a0,a1,t4
  a28636:	01079693          	slli	a3,a5,0x10
  a2863a:	82c1                	srli	a3,a3,0x10
  a2863c:	03d5f5b3          	remu	a1,a1,t4
  a28640:	02a60633          	mul	a2,a2,a0
  a28644:	20b6a79b          	orshf	a5,a3,a1,sll,16
  a28648:	00c7fa63          	bgeu	a5,a2,a2865c <__udivmoddi4+0xb0>
  a2864c:	97c2                	add	a5,a5,a6
  a2864e:	fff50693          	addi	a3,a0,-1
  a28652:	0107e463          	bltu	a5,a6,a2865a <__udivmoddi4+0xae>
  a28656:	32c7eb63          	bltu	a5,a2,a2898c <__udivmoddi4+0x3e0>
  a2865a:	8536                	mv	a0,a3
  a2865c:	8f91                	sub	a5,a5,a2
  a2865e:	21e5251b          	orshf	a0,a0,t5,sll,16
  a28662:	4581                	li	a1,0
  a28664:	c711                	beqz	a4,a28670 <__udivmoddi4+0xc4>
  a28666:	0067d7b3          	srl	a5,a5,t1
  a2866a:	c31c                	sw	a5,0(a4)
  a2866c:	00072223          	sw	zero,4(a4)
  a28670:	8082                	ret
  a28672:	00d5f963          	bgeu	a1,a3,a28684 <__udivmoddi4+0xd8>
  a28676:	12070f63          	beqz	a4,a287b4 <__udivmoddi4+0x208>
  a2867a:	c308                	sw	a0,0(a4)
  a2867c:	c34c                	sw	a1,4(a4)
  a2867e:	4501                	li	a0,0
  a28680:	4581                	li	a1,0
  a28682:	8082                	ret
  a28684:	67c1                	lui	a5,0x10
  a28686:	0ef6ed63          	bltu	a3,a5,a28780 <__udivmoddi4+0x1d4>
  a2868a:	010007b7          	lui	a5,0x1000
  a2868e:	2cf6ea63          	bltu	a3,a5,a28962 <__udivmoddi4+0x3b6>
  a28692:	0186d893          	srli	a7,a3,0x18
  a28696:	4861                	li	a6,24
  a28698:	0000c797          	auipc	a5,0xc
  a2869c:	9a07a783          	lw	a5,-1632(a5) # a34038 <_GLOBAL_OFFSET_TABLE_+0x4>
  a286a0:	97c6                	add	a5,a5,a7
  a286a2:	0007c303          	lbu	t1,0(a5)
  a286a6:	02000e93          	li	t4,32
  a286aa:	9342                	add	t1,t1,a6
  a286ac:	406e8eb3          	sub	t4,t4,t1
  a286b0:	180e9563          	bnez	t4,a2883a <__udivmoddi4+0x28e>
  a286b4:	00b6e463          	bltu	a3,a1,a286bc <__udivmoddi4+0x110>
  a286b8:	2ec56363          	bltu	a0,a2,a2899e <__udivmoddi4+0x3f2>
  a286bc:	40c50633          	sub	a2,a0,a2
  a286c0:	00c53533          	sltu	a0,a0,a2
  a286c4:	8d95                	sub	a1,a1,a3
  a286c6:	40a58e33          	sub	t3,a1,a0
  a286ca:	4505                	li	a0,1
  a286cc:	4581                	li	a1,0
  a286ce:	d34d                	beqz	a4,a28670 <__udivmoddi4+0xc4>
  a286d0:	c310                	sw	a2,0(a4)
  a286d2:	01c72223          	sw	t3,4(a4)
  a286d6:	8082                	ret
  a286d8:	e601                	bnez	a2,a286e0 <__udivmoddi4+0x134>
  a286da:	4685                	li	a3,1
  a286dc:	02c6d833          	divu	a6,a3,a2
  a286e0:	66c1                	lui	a3,0x10
  a286e2:	0cd86063          	bltu	a6,a3,a287a2 <__udivmoddi4+0x1f6>
  a286e6:	010006b7          	lui	a3,0x1000
  a286ea:	26d86863          	bltu	a6,a3,a2895a <__udivmoddi4+0x3ae>
  a286ee:	01885613          	srli	a2,a6,0x18
  a286f2:	48e1                	li	a7,24
  a286f4:	0000c697          	auipc	a3,0xc
  a286f8:	9446a683          	lw	a3,-1724(a3) # a34038 <_GLOBAL_OFFSET_TABLE_+0x4>
  a286fc:	96b2                	add	a3,a3,a2
  a286fe:	2290                	lbu	a2,0(a3)
  a28700:	02000313          	li	t1,32
  a28704:	9646                	add	a2,a2,a7
  a28706:	40c30333          	sub	t1,t1,a2
  a2870a:	0a031863          	bnez	t1,a287ba <__udivmoddi4+0x20e>
  a2870e:	01081e93          	slli	t4,a6,0x10
  a28712:	410586b3          	sub	a3,a1,a6
  a28716:	01085f13          	srli	t5,a6,0x10
  a2871a:	010ede93          	srli	t4,t4,0x10
  a2871e:	4585                	li	a1,1
  a28720:	0107d893          	srli	a7,a5,0x10
  a28724:	03e6de33          	divu	t3,a3,t5
  a28728:	03e6f6b3          	remu	a3,a3,t5
  a2872c:	03de0633          	mul	a2,t3,t4
  a28730:	20d8a69b          	orshf	a3,a7,a3,sll,16
  a28734:	00c6fa63          	bgeu	a3,a2,a28748 <__udivmoddi4+0x19c>
  a28738:	96c2                	add	a3,a3,a6
  a2873a:	fffe0513          	addi	a0,t3,-1
  a2873e:	0106e463          	bltu	a3,a6,a28746 <__udivmoddi4+0x19a>
  a28742:	24c6eb63          	bltu	a3,a2,a28998 <__udivmoddi4+0x3ec>
  a28746:	8e2a                	mv	t3,a0
  a28748:	40c68633          	sub	a2,a3,a2
  a2874c:	03e65533          	divu	a0,a2,t5
  a28750:	01079693          	slli	a3,a5,0x10
  a28754:	82c1                	srli	a3,a3,0x10
  a28756:	03e67633          	remu	a2,a2,t5
  a2875a:	03d508b3          	mul	a7,a0,t4
  a2875e:	20c6a79b          	orshf	a5,a3,a2,sll,16
  a28762:	0117fa63          	bgeu	a5,a7,a28776 <__udivmoddi4+0x1ca>
  a28766:	97c2                	add	a5,a5,a6
  a28768:	fff50693          	addi	a3,a0,-1
  a2876c:	0107e463          	bltu	a5,a6,a28774 <__udivmoddi4+0x1c8>
  a28770:	2117eb63          	bltu	a5,a7,a28986 <__udivmoddi4+0x3da>
  a28774:	8536                	mv	a0,a3
  a28776:	411787b3          	sub	a5,a5,a7
  a2877a:	21c5251b          	orshf	a0,a0,t3,sll,16
  a2877e:	b5dd                	j	a28664 <__udivmoddi4+0xb8>
  a28780:	0ff00793          	li	a5,255
  a28784:	1ed7f363          	bgeu	a5,a3,a2896a <__udivmoddi4+0x3be>
  a28788:	0086d893          	srli	a7,a3,0x8
  a2878c:	4821                	li	a6,8
  a2878e:	b729                	j	a28698 <__udivmoddi4+0xec>
  a28790:	8332                	mv	t1,a2
  a28792:	0ff00693          	li	a3,255
  a28796:	e2c6fce3          	bgeu	a3,a2,a285ce <__udivmoddi4+0x22>
  a2879a:	00865313          	srli	t1,a2,0x8
  a2879e:	48a1                	li	a7,8
  a287a0:	b53d                	j	a285ce <__udivmoddi4+0x22>
  a287a2:	8642                	mv	a2,a6
  a287a4:	0ff00693          	li	a3,255
  a287a8:	f506f6e3          	bgeu	a3,a6,a286f4 <__udivmoddi4+0x148>
  a287ac:	00885613          	srli	a2,a6,0x8
  a287b0:	48a1                	li	a7,8
  a287b2:	b789                	j	a286f4 <__udivmoddi4+0x148>
  a287b4:	4581                	li	a1,0
  a287b6:	4501                	li	a0,0
  a287b8:	8082                	ret
  a287ba:	00681833          	sll	a6,a6,t1
  a287be:	00c5d8b3          	srl	a7,a1,a2
  a287c2:	01085f13          	srli	t5,a6,0x10
  a287c6:	03e8dfb3          	divu	t6,a7,t5
  a287ca:	01081e93          	slli	t4,a6,0x10
  a287ce:	006595b3          	sll	a1,a1,t1
  a287d2:	00c55633          	srl	a2,a0,a2
  a287d6:	010ede93          	srli	t4,t4,0x10
  a287da:	8e4d                	or	a2,a2,a1
  a287dc:	01065e13          	srli	t3,a2,0x10
  a287e0:	006517b3          	sll	a5,a0,t1
  a287e4:	03e8f8b3          	remu	a7,a7,t5
  a287e8:	03fe85b3          	mul	a1,t4,t6
  a287ec:	211e251b          	orshf	a0,t3,a7,sll,16
  a287f0:	00b57b63          	bgeu	a0,a1,a28806 <__udivmoddi4+0x25a>
  a287f4:	9542                	add	a0,a0,a6
  a287f6:	ffff8693          	addi	a3,t6,-1
  a287fa:	19056463          	bltu	a0,a6,a28982 <__udivmoddi4+0x3d6>
  a287fe:	18b57263          	bgeu	a0,a1,a28982 <__udivmoddi4+0x3d6>
  a28802:	1ff9                	addi	t6,t6,-2
  a28804:	9542                	add	a0,a0,a6
  a28806:	8d0d                	sub	a0,a0,a1
  a28808:	03e558b3          	divu	a7,a0,t5
  a2880c:	9e21                	uxth	a2
  a2880e:	03e57533          	remu	a0,a0,t5
  a28812:	031e86b3          	mul	a3,t4,a7
  a28816:	20a6259b          	orshf	a1,a2,a0,sll,16
  a2881a:	00d5fb63          	bgeu	a1,a3,a28830 <__udivmoddi4+0x284>
  a2881e:	95c2                	add	a1,a1,a6
  a28820:	fff88613          	addi	a2,a7,-1
  a28824:	1505eb63          	bltu	a1,a6,a2897a <__udivmoddi4+0x3ce>
  a28828:	14d5f963          	bgeu	a1,a3,a2897a <__udivmoddi4+0x3ce>
  a2882c:	18f9                	addi	a7,a7,-2
  a2882e:	95c2                	add	a1,a1,a6
  a28830:	40d586b3          	sub	a3,a1,a3
  a28834:	21f8a59b          	orshf	a1,a7,t6,sll,16
  a28838:	b5e5                	j	a28720 <__udivmoddi4+0x174>
  a2883a:	00665833          	srl	a6,a2,t1
  a2883e:	01d696b3          	sll	a3,a3,t4
  a28842:	00d866b3          	or	a3,a6,a3
  a28846:	0065d7b3          	srl	a5,a1,t1
  a2884a:	0106de13          	srli	t3,a3,0x10
  a2884e:	03c7dfb3          	divu	t6,a5,t3
  a28852:	01069893          	slli	a7,a3,0x10
  a28856:	0108d893          	srli	a7,a7,0x10
  a2885a:	00655833          	srl	a6,a0,t1
  a2885e:	01d51f33          	sll	t5,a0,t4
  a28862:	01d595b3          	sll	a1,a1,t4
  a28866:	00b865b3          	or	a1,a6,a1
  a2886a:	0105d813          	srli	a6,a1,0x10
  a2886e:	01d61633          	sll	a2,a2,t4
  a28872:	03c7f7b3          	remu	a5,a5,t3
  a28876:	03f88533          	mul	a0,a7,t6
  a2887a:	20f8279b          	orshf	a5,a6,a5,sll,16
  a2887e:	00a7fb63          	bgeu	a5,a0,a28894 <__udivmoddi4+0x2e8>
  a28882:	97b6                	add	a5,a5,a3
  a28884:	ffff8813          	addi	a6,t6,-1
  a28888:	0ed7eb63          	bltu	a5,a3,a2897e <__udivmoddi4+0x3d2>
  a2888c:	0ea7f963          	bgeu	a5,a0,a2897e <__udivmoddi4+0x3d2>
  a28890:	1ff9                	addi	t6,t6,-2
  a28892:	97b6                	add	a5,a5,a3
  a28894:	8f89                	sub	a5,a5,a0
  a28896:	03c7d533          	divu	a0,a5,t3
  a2889a:	9da1                	uxth	a1
  a2889c:	03c7f7b3          	remu	a5,a5,t3
  a288a0:	02a888b3          	mul	a7,a7,a0
  a288a4:	20f5a59b          	orshf	a1,a1,a5,sll,16
  a288a8:	0115fb63          	bgeu	a1,a7,a288be <__udivmoddi4+0x312>
  a288ac:	95b6                	add	a1,a1,a3
  a288ae:	fff50793          	addi	a5,a0,-1
  a288b2:	0cd5e263          	bltu	a1,a3,a28976 <__udivmoddi4+0x3ca>
  a288b6:	0d15f063          	bgeu	a1,a7,a28976 <__udivmoddi4+0x3ca>
  a288ba:	1579                	addi	a0,a0,-2
  a288bc:	95b6                	add	a1,a1,a3
  a288be:	63c1                	lui	t2,0x10
  a288c0:	21f5251b          	orshf	a0,a0,t6,sll,16
  a288c4:	fff38793          	addi	a5,t2,-1 # ffff <ccause+0xf03d>
  a288c8:	00f57833          	and	a6,a0,a5
  a288cc:	01055e13          	srli	t3,a0,0x10
  a288d0:	8ff1                	and	a5,a5,a2
  a288d2:	01065f93          	srli	t6,a2,0x10
  a288d6:	02fe02b3          	mul	t0,t3,a5
  a288da:	411588b3          	sub	a7,a1,a7
  a288de:	03f805b3          	mul	a1,a6,t6
  a288e2:	02f80833          	mul	a6,a6,a5
  a288e6:	9596                	add	a1,a1,t0
  a288e8:	6105859b          	addshf	a1,a1,a6,srl,16
  a288ec:	03fe0e33          	mul	t3,t3,t6
  a288f0:	0055f363          	bgeu	a1,t0,a288f6 <__udivmoddi4+0x34a>
  a288f4:	9e1e                	add	t3,t3,t2
  a288f6:	67c1                	lui	a5,0x10
  a288f8:	17fd                	addi	a5,a5,-1 # ffff <ccause+0xf03d>
  a288fa:	00f5ffb3          	and	t6,a1,a5
  a288fe:	00f877b3          	and	a5,a6,a5
  a28902:	60be081b          	addshf	a6,t3,a1,srl,16
  a28906:	21f7879b          	addshf	a5,a5,t6,sll,16
  a2890a:	0308ed63          	bltu	a7,a6,a28944 <__udivmoddi4+0x398>
  a2890e:	03088963          	beq	a7,a6,a28940 <__udivmoddi4+0x394>
  a28912:	4581                	li	a1,0
  a28914:	d4070ee3          	beqz	a4,a28670 <__udivmoddi4+0xc4>
  a28918:	40ff07b3          	sub	a5,t5,a5
  a2891c:	00ff3f33          	sltu	t5,t5,a5
  a28920:	410888b3          	sub	a7,a7,a6
  a28924:	41e888b3          	sub	a7,a7,t5
  a28928:	00689333          	sll	t1,a7,t1
  a2892c:	01d7d7b3          	srl	a5,a5,t4
  a28930:	00f367b3          	or	a5,t1,a5
  a28934:	01d8d8b3          	srl	a7,a7,t4
  a28938:	c31c                	sw	a5,0(a4)
  a2893a:	01172223          	sw	a7,4(a4)
  a2893e:	8082                	ret
  a28940:	fcff79e3          	bgeu	t5,a5,a28912 <__udivmoddi4+0x366>
  a28944:	40c78633          	sub	a2,a5,a2
  a28948:	00c7b7b3          	sltu	a5,a5,a2
  a2894c:	40d80833          	sub	a6,a6,a3
  a28950:	40f80833          	sub	a6,a6,a5
  a28954:	157d                	addi	a0,a0,-1
  a28956:	87b2                	mv	a5,a2
  a28958:	bf6d                	j	a28912 <__udivmoddi4+0x366>
  a2895a:	01085613          	srli	a2,a6,0x10
  a2895e:	48c1                	li	a7,16
  a28960:	bb51                	j	a286f4 <__udivmoddi4+0x148>
  a28962:	0106d893          	srli	a7,a3,0x10
  a28966:	4841                	li	a6,16
  a28968:	bb05                	j	a28698 <__udivmoddi4+0xec>
  a2896a:	4801                	li	a6,0
  a2896c:	b335                	j	a28698 <__udivmoddi4+0xec>
  a2896e:	01065313          	srli	t1,a2,0x10
  a28972:	48c1                	li	a7,16
  a28974:	b9a9                	j	a285ce <__udivmoddi4+0x22>
  a28976:	853e                	mv	a0,a5
  a28978:	b799                	j	a288be <__udivmoddi4+0x312>
  a2897a:	88b2                	mv	a7,a2
  a2897c:	bd55                	j	a28830 <__udivmoddi4+0x284>
  a2897e:	8fc2                	mv	t6,a6
  a28980:	bf11                	j	a28894 <__udivmoddi4+0x2e8>
  a28982:	8fb6                	mv	t6,a3
  a28984:	b549                	j	a28806 <__udivmoddi4+0x25a>
  a28986:	1579                	addi	a0,a0,-2
  a28988:	97c2                	add	a5,a5,a6
  a2898a:	b3f5                	j	a28776 <__udivmoddi4+0x1ca>
  a2898c:	1579                	addi	a0,a0,-2
  a2898e:	97c2                	add	a5,a5,a6
  a28990:	b1f1                	j	a2865c <__udivmoddi4+0xb0>
  a28992:	1f79                	addi	t5,t5,-2
  a28994:	96c2                	add	a3,a3,a6
  a28996:	b961                	j	a2862e <__udivmoddi4+0x82>
  a28998:	1e79                	addi	t3,t3,-2
  a2899a:	96c2                	add	a3,a3,a6
  a2899c:	b375                	j	a28748 <__udivmoddi4+0x19c>
  a2899e:	862a                	mv	a2,a0
  a289a0:	4501                	li	a0,0
  a289a2:	b32d                	j	a286cc <__udivmoddi4+0x120>

00a289a4 <memset>:
  a289a4:	ca59                	beqz	a2,a28a3a <memset+0x96>
  a289a6:	0ff5f793          	andi	a5,a1,255
  a289aa:	a11c                	sb	a5,0(a0)
  a289ac:	00c50733          	add	a4,a0,a2
  a289b0:	fef70fa3          	sb	a5,-1(a4)
  a289b4:	032661bb          	bltui	a2,3,a28a3a <memset+0x96>
  a289b8:	b11c                	sb	a5,1(a0)
  a289ba:	a13c                	sb	a5,2(a0)
  a289bc:	fef70f23          	sb	a5,-2(a4)
  a289c0:	fef70ea3          	sb	a5,-3(a4)
  a289c4:	07166dbb          	bltui	a2,7,a28a3a <memset+0x96>
  a289c8:	b13c                	sb	a5,3(a0)
  a289ca:	fef70e23          	sb	a5,-4(a4)
  a289ce:	46a1                	li	a3,8
  a289d0:	06c6f563          	bgeu	a3,a2,a28a3a <memset+0x96>
  a289d4:	40a007b3          	neg	a5,a0
  a289d8:	8b8d                	andi	a5,a5,3
  a289da:	00f50733          	add	a4,a0,a5
  a289de:	8e1d                	sub	a2,a2,a5
  a289e0:	0ff5f593          	andi	a1,a1,255
  a289e4:	0101 0101 079f      	l.li	a5,0x1010101
  a289ea:	02f585b3          	mul	a1,a1,a5
  a289ee:	9a71                	andi	a2,a2,-4
  a289f0:	00c707b3          	add	a5,a4,a2
  a289f4:	c30c                	sw	a1,0(a4)
  a289f6:	feb7ae23          	sw	a1,-4(a5)
  a289fa:	04c6f063          	bgeu	a3,a2,a28a3a <memset+0x96>
  a289fe:	c34c                	sw	a1,4(a4)
  a28a00:	c70c                	sw	a1,8(a4)
  a28a02:	feb7aa23          	sw	a1,-12(a5)
  a28a06:	feb7ac23          	sw	a1,-8(a5)
  a28a0a:	19066c3b          	bltui	a2,25,a28a3a <memset+0x96>
  a28a0e:	c74c                	sw	a1,12(a4)
  a28a10:	cb0c                	sw	a1,16(a4)
  a28a12:	cb4c                	sw	a1,20(a4)
  a28a14:	cf0c                	sw	a1,24(a4)
  a28a16:	feb7a223          	sw	a1,-28(a5)
  a28a1a:	feb7a423          	sw	a1,-24(a5)
  a28a1e:	feb7a623          	sw	a1,-20(a5)
  a28a22:	feb7a823          	sw	a1,-16(a5)
  a28a26:	00477793          	andi	a5,a4,4
  a28a2a:	07e1                	addi	a5,a5,24
  a28a2c:	97ba                	add	a5,a5,a4
  a28a2e:	46fd                	li	a3,31
  a28a30:	9732                	add	a4,a4,a2
  a28a32:	40f70633          	sub	a2,a4,a5
  a28a36:	00c6e363          	bltu	a3,a2,a28a3c <memset+0x98>
  a28a3a:	8082                	ret
  a28a3c:	c38c                	sw	a1,0(a5)
  a28a3e:	c3cc                	sw	a1,4(a5)
  a28a40:	c78c                	sw	a1,8(a5)
  a28a42:	c7cc                	sw	a1,12(a5)
  a28a44:	cb8c                	sw	a1,16(a5)
  a28a46:	cbcc                	sw	a1,20(a5)
  a28a48:	cf8c                	sw	a1,24(a5)
  a28a4a:	cfcc                	sw	a1,28(a5)
  a28a4c:	02078793          	addi	a5,a5,32
  a28a50:	b7cd                	j	a28a32 <memset+0x8e>

00a28a52 <memcpy>:
  a28a52:	87aa                	mv	a5,a0
  a28a54:	0035f713          	andi	a4,a1,3
  a28a58:	c319                	beqz	a4,a28a5e <memcpy+0xc>
  a28a5a:	16061963          	bnez	a2,a28bcc <memcpy+0x17a>
  a28a5e:	0037f813          	andi	a6,a5,3
  a28a62:	473d                	li	a4,15
  a28a64:	18080e63          	beqz	a6,a28c00 <memcpy+0x1ae>
  a28a68:	20166abb          	bltui	a2,32,a28ad2 <memcpy+0x80>
  a28a6c:	2194                	lbu	a3,0(a1)
  a28a6e:	4198                	lw	a4,0(a1)
  a28a70:	027807bb          	beqi	a6,2,a28c4e <memcpy+0x1fc>
  a28a74:	488d                	li	a7,3
  a28a76:	23180563          	beq	a6,a7,a28ca0 <memcpy+0x24e>
  a28a7a:	a394                	sb	a3,0(a5)
  a28a7c:	3194                	lbu	a3,1(a1)
  a28a7e:	1675                	addi	a2,a2,-3
  a28a80:	058d                	addi	a1,a1,3
  a28a82:	b394                	sb	a3,1(a5)
  a28a84:	fff5c683          	lbu	a3,-1(a1)
  a28a88:	078d                	addi	a5,a5,3
  a28a8a:	4e41                	li	t3,16
  a28a8c:	fed78fa3          	sb	a3,-1(a5)
  a28a90:	0015a303          	lw	t1,1(a1)
  a28a94:	0055a883          	lw	a7,5(a1)
  a28a98:	1641                	addi	a2,a2,-16
  a28a9a:	00831813          	slli	a6,t1,0x8
  a28a9e:	70e8271b          	orshf	a4,a6,a4,srl,24
  a28aa2:	0095a803          	lw	a6,9(a1)
  a28aa6:	c398                	sw	a4,0(a5)
  a28aa8:	00889693          	slli	a3,a7,0x8
  a28aac:	00881713          	slli	a4,a6,0x8
  a28ab0:	7117271b          	orshf	a4,a4,a7,srl,24
  a28ab4:	c798                	sw	a4,8(a5)
  a28ab6:	00d5a703          	lw	a4,13(a1)
  a28aba:	7066a69b          	orshf	a3,a3,t1,srl,24
  a28abe:	c3d4                	sw	a3,4(a5)
  a28ac0:	00871693          	slli	a3,a4,0x8
  a28ac4:	7106a69b          	orshf	a3,a3,a6,srl,24
  a28ac8:	c7d4                	sw	a3,12(a5)
  a28aca:	05c1                	addi	a1,a1,16
  a28acc:	07c1                	addi	a5,a5,16
  a28ace:	fcce61e3          	bltu	t3,a2,a28a90 <memcpy+0x3e>
  a28ad2:	01067713          	andi	a4,a2,16
  a28ad6:	c351                	beqz	a4,a28b5a <memcpy+0x108>
  a28ad8:	2198                	lbu	a4,0(a1)
  a28ada:	07c1                	addi	a5,a5,16
  a28adc:	05c1                	addi	a1,a1,16
  a28ade:	fee78823          	sb	a4,-16(a5)
  a28ae2:	ff15c703          	lbu	a4,-15(a1)
  a28ae6:	fee788a3          	sb	a4,-15(a5)
  a28aea:	ff25c703          	lbu	a4,-14(a1)
  a28aee:	fee78923          	sb	a4,-14(a5)
  a28af2:	ff35c703          	lbu	a4,-13(a1)
  a28af6:	fee789a3          	sb	a4,-13(a5)
  a28afa:	ff45c703          	lbu	a4,-12(a1)
  a28afe:	fee78a23          	sb	a4,-12(a5)
  a28b02:	ff55c703          	lbu	a4,-11(a1)
  a28b06:	fee78aa3          	sb	a4,-11(a5)
  a28b0a:	ff65c703          	lbu	a4,-10(a1)
  a28b0e:	fee78b23          	sb	a4,-10(a5)
  a28b12:	ff75c703          	lbu	a4,-9(a1)
  a28b16:	fee78ba3          	sb	a4,-9(a5)
  a28b1a:	ff85c703          	lbu	a4,-8(a1)
  a28b1e:	fee78c23          	sb	a4,-8(a5)
  a28b22:	ff95c703          	lbu	a4,-7(a1)
  a28b26:	fee78ca3          	sb	a4,-7(a5)
  a28b2a:	ffa5c703          	lbu	a4,-6(a1)
  a28b2e:	fee78d23          	sb	a4,-6(a5)
  a28b32:	ffb5c703          	lbu	a4,-5(a1)
  a28b36:	fee78da3          	sb	a4,-5(a5)
  a28b3a:	ffc5c703          	lbu	a4,-4(a1)
  a28b3e:	fee78e23          	sb	a4,-4(a5)
  a28b42:	ffd5c703          	lbu	a4,-3(a1)
  a28b46:	fee78ea3          	sb	a4,-3(a5)
  a28b4a:	ffe5c703          	lbu	a4,-2(a1)
  a28b4e:	fee78f23          	sb	a4,-2(a5)
  a28b52:	fff5c703          	lbu	a4,-1(a1)
  a28b56:	fee78fa3          	sb	a4,-1(a5)
  a28b5a:	00867713          	andi	a4,a2,8
  a28b5e:	c331                	beqz	a4,a28ba2 <memcpy+0x150>
  a28b60:	2198                	lbu	a4,0(a1)
  a28b62:	07a1                	addi	a5,a5,8
  a28b64:	05a1                	addi	a1,a1,8
  a28b66:	fee78c23          	sb	a4,-8(a5)
  a28b6a:	ff95c703          	lbu	a4,-7(a1)
  a28b6e:	fee78ca3          	sb	a4,-7(a5)
  a28b72:	ffa5c703          	lbu	a4,-6(a1)
  a28b76:	fee78d23          	sb	a4,-6(a5)
  a28b7a:	ffb5c703          	lbu	a4,-5(a1)
  a28b7e:	fee78da3          	sb	a4,-5(a5)
  a28b82:	ffc5c703          	lbu	a4,-4(a1)
  a28b86:	fee78e23          	sb	a4,-4(a5)
  a28b8a:	ffd5c703          	lbu	a4,-3(a1)
  a28b8e:	fee78ea3          	sb	a4,-3(a5)
  a28b92:	ffe5c703          	lbu	a4,-2(a1)
  a28b96:	fee78f23          	sb	a4,-2(a5)
  a28b9a:	fff5c703          	lbu	a4,-1(a1)
  a28b9e:	fee78fa3          	sb	a4,-1(a5)
  a28ba2:	00467713          	andi	a4,a2,4
  a28ba6:	c359                	beqz	a4,a28c2c <memcpy+0x1da>
  a28ba8:	2198                	lbu	a4,0(a1)
  a28baa:	0791                	addi	a5,a5,4
  a28bac:	0591                	addi	a1,a1,4
  a28bae:	fee78e23          	sb	a4,-4(a5)
  a28bb2:	ffd5c703          	lbu	a4,-3(a1)
  a28bb6:	fee78ea3          	sb	a4,-3(a5)
  a28bba:	ffe5c703          	lbu	a4,-2(a1)
  a28bbe:	fee78f23          	sb	a4,-2(a5)
  a28bc2:	fff5c703          	lbu	a4,-1(a1)
  a28bc6:	fee78fa3          	sb	a4,-1(a5)
  a28bca:	a08d                	j	a28c2c <memcpy+0x1da>
  a28bcc:	0585                	addi	a1,a1,1
  a28bce:	fff5c703          	lbu	a4,-1(a1)
  a28bd2:	0785                	addi	a5,a5,1
  a28bd4:	167d                	addi	a2,a2,-1
  a28bd6:	fee78fa3          	sb	a4,-1(a5)
  a28bda:	bdad                	j	a28a54 <memcpy+0x2>
  a28bdc:	4194                	lw	a3,0(a1)
  a28bde:	07c1                	addi	a5,a5,16
  a28be0:	05c1                	addi	a1,a1,16
  a28be2:	fed7a823          	sw	a3,-16(a5)
  a28be6:	ff45a683          	lw	a3,-12(a1)
  a28bea:	1641                	addi	a2,a2,-16
  a28bec:	fed7aa23          	sw	a3,-12(a5)
  a28bf0:	ff85a683          	lw	a3,-8(a1)
  a28bf4:	fed7ac23          	sw	a3,-8(a5)
  a28bf8:	ffc5a683          	lw	a3,-4(a1)
  a28bfc:	fed7ae23          	sw	a3,-4(a5)
  a28c00:	fcc76ee3          	bltu	a4,a2,a28bdc <memcpy+0x18a>
  a28c04:	00867713          	andi	a4,a2,8
  a28c08:	cb11                	beqz	a4,a28c1c <memcpy+0x1ca>
  a28c0a:	4198                	lw	a4,0(a1)
  a28c0c:	07a1                	addi	a5,a5,8
  a28c0e:	05a1                	addi	a1,a1,8
  a28c10:	fee7ac23          	sw	a4,-8(a5)
  a28c14:	ffc5a703          	lw	a4,-4(a1)
  a28c18:	fee7ae23          	sw	a4,-4(a5)
  a28c1c:	00467713          	andi	a4,a2,4
  a28c20:	c711                	beqz	a4,a28c2c <memcpy+0x1da>
  a28c22:	4198                	lw	a4,0(a1)
  a28c24:	0791                	addi	a5,a5,4
  a28c26:	0591                	addi	a1,a1,4
  a28c28:	fee7ae23          	sw	a4,-4(a5)
  a28c2c:	00267713          	andi	a4,a2,2
  a28c30:	cb11                	beqz	a4,a28c44 <memcpy+0x1f2>
  a28c32:	2198                	lbu	a4,0(a1)
  a28c34:	0789                	addi	a5,a5,2
  a28c36:	0589                	addi	a1,a1,2
  a28c38:	fee78f23          	sb	a4,-2(a5)
  a28c3c:	fff5c703          	lbu	a4,-1(a1)
  a28c40:	fee78fa3          	sb	a4,-1(a5)
  a28c44:	8a05                	andi	a2,a2,1
  a28c46:	c219                	beqz	a2,a28c4c <memcpy+0x1fa>
  a28c48:	2198                	lbu	a4,0(a1)
  a28c4a:	a398                	sb	a4,0(a5)
  a28c4c:	8082                	ret
  a28c4e:	a394                	sb	a3,0(a5)
  a28c50:	3194                	lbu	a3,1(a1)
  a28c52:	1679                	addi	a2,a2,-2
  a28c54:	0589                	addi	a1,a1,2
  a28c56:	b394                	sb	a3,1(a5)
  a28c58:	4e45                	li	t3,17
  a28c5a:	0789                	addi	a5,a5,2
  a28c5c:	0025a303          	lw	t1,2(a1)
  a28c60:	0065a883          	lw	a7,6(a1)
  a28c64:	1641                	addi	a2,a2,-16
  a28c66:	01031813          	slli	a6,t1,0x10
  a28c6a:	60e8271b          	orshf	a4,a6,a4,srl,16
  a28c6e:	00a5a803          	lw	a6,10(a1)
  a28c72:	c398                	sw	a4,0(a5)
  a28c74:	01089693          	slli	a3,a7,0x10
  a28c78:	01081713          	slli	a4,a6,0x10
  a28c7c:	6117271b          	orshf	a4,a4,a7,srl,16
  a28c80:	c798                	sw	a4,8(a5)
  a28c82:	00e5a703          	lw	a4,14(a1)
  a28c86:	6066a69b          	orshf	a3,a3,t1,srl,16
  a28c8a:	c3d4                	sw	a3,4(a5)
  a28c8c:	01071693          	slli	a3,a4,0x10
  a28c90:	6106a69b          	orshf	a3,a3,a6,srl,16
  a28c94:	c7d4                	sw	a3,12(a5)
  a28c96:	05c1                	addi	a1,a1,16
  a28c98:	07c1                	addi	a5,a5,16
  a28c9a:	fcce61e3          	bltu	t3,a2,a28c5c <memcpy+0x20a>
  a28c9e:	bd15                	j	a28ad2 <memcpy+0x80>
  a28ca0:	a394                	sb	a3,0(a5)
  a28ca2:	0585                	addi	a1,a1,1
  a28ca4:	167d                	addi	a2,a2,-1
  a28ca6:	0785                	addi	a5,a5,1
  a28ca8:	4e49                	li	t3,18
  a28caa:	0035a303          	lw	t1,3(a1)
  a28cae:	0075a883          	lw	a7,7(a1)
  a28cb2:	1641                	addi	a2,a2,-16
  a28cb4:	01831813          	slli	a6,t1,0x18
  a28cb8:	50e8271b          	orshf	a4,a6,a4,srl,8
  a28cbc:	00b5a803          	lw	a6,11(a1)
  a28cc0:	c398                	sw	a4,0(a5)
  a28cc2:	01889693          	slli	a3,a7,0x18
  a28cc6:	01881713          	slli	a4,a6,0x18
  a28cca:	5117271b          	orshf	a4,a4,a7,srl,8
  a28cce:	c798                	sw	a4,8(a5)
  a28cd0:	00f5a703          	lw	a4,15(a1)
  a28cd4:	5066a69b          	orshf	a3,a3,t1,srl,8
  a28cd8:	c3d4                	sw	a3,4(a5)
  a28cda:	01871693          	slli	a3,a4,0x18
  a28cde:	5106a69b          	orshf	a3,a3,a6,srl,8
  a28ce2:	c7d4                	sw	a3,12(a5)
  a28ce4:	05c1                	addi	a1,a1,16
  a28ce6:	07c1                	addi	a5,a5,16
  a28ce8:	fcce61e3          	bltu	t3,a2,a28caa <memcpy+0x258>
  a28cec:	b3dd                	j	a28ad2 <memcpy+0x80>

00a28cee <memcmp>:
  a28cee:	962a                	add	a2,a2,a0
  a28cf0:	00c50c63          	beq	a0,a2,a28d08 <memcmp+0x1a>
  a28cf4:	211c                	lbu	a5,0(a0)
  a28cf6:	2198                	lbu	a4,0(a1)
  a28cf8:	00e78563          	beq	a5,a4,a28d02 <memcmp+0x14>
  a28cfc:	40e78533          	sub	a0,a5,a4
  a28d00:	8082                	ret
  a28d02:	0505                	addi	a0,a0,1
  a28d04:	0585                	addi	a1,a1,1
  a28d06:	b7ed                	j	a28cf0 <memcmp+0x2>
  a28d08:	4501                	li	a0,0
  a28d0a:	8082                	ret

00a28d0c <strlen>:
  a28d0c:	87aa                	mv	a5,a0
  a28d0e:	0037f713          	andi	a4,a5,3
  a28d12:	e31d                	bnez	a4,a28d38 <strlen+0x2c>
  a28d14:	fefe feff 059f      	l.li	a1,0xfefefeff
  a28d1a:	8080 8080 061f      	l.li	a2,0x80808080
  a28d20:	4394                	lw	a3,0(a5)
  a28d22:	00b68733          	add	a4,a3,a1
  a28d26:	fff6c693          	not	a3,a3
  a28d2a:	8f75                	and	a4,a4,a3
  a28d2c:	8f71                	and	a4,a4,a2
  a28d2e:	cf01                	beqz	a4,a28d46 <strlen+0x3a>
  a28d30:	2398                	lbu	a4,0(a5)
  a28d32:	c709                	beqz	a4,a28d3c <strlen+0x30>
  a28d34:	0785                	addi	a5,a5,1
  a28d36:	bfed                	j	a28d30 <strlen+0x24>
  a28d38:	2398                	lbu	a4,0(a5)
  a28d3a:	e701                	bnez	a4,a28d42 <strlen+0x36>
  a28d3c:	40a78533          	sub	a0,a5,a0
  a28d40:	8082                	ret
  a28d42:	0785                	addi	a5,a5,1
  a28d44:	b7e9                	j	a28d0e <strlen+0x2>
  a28d46:	0791                	addi	a5,a5,4
  a28d48:	bfe1                	j	a28d20 <strlen+0x14>

00a28d4a <memmove>:
  a28d4a:	882a                	mv	a6,a0
  a28d4c:	872e                	mv	a4,a1
  a28d4e:	87b2                	mv	a5,a2
  a28d50:	02b50f63          	beq	a0,a1,a28d8e <memmove+0x44>
  a28d54:	56f9                	li	a3,-2
  a28d56:	02d606b3          	mul	a3,a2,a3
  a28d5a:	40a588b3          	sub	a7,a1,a0
  a28d5e:	40c888b3          	sub	a7,a7,a2
  a28d62:	0116e363          	bltu	a3,a7,a28d68 <memmove+0x1e>
  a28d66:	b1f5                	j	a28a52 <memcpy>
  a28d68:	00a5c6b3          	xor	a3,a1,a0
  a28d6c:	8a8d                	andi	a3,a3,3
  a28d6e:	04b57863          	bgeu	a0,a1,a28dbe <memmove+0x74>
  a28d72:	c6a1                	beqz	a3,a28dba <memmove+0x70>
  a28d74:	86aa                	mv	a3,a0
  a28d76:	97b6                	add	a5,a5,a3
  a28d78:	00f68a63          	beq	a3,a5,a28d8c <memmove+0x42>
  a28d7c:	0705                	addi	a4,a4,1
  a28d7e:	fff74603          	lbu	a2,-1(a4)
  a28d82:	0685                	addi	a3,a3,1
  a28d84:	fec68fa3          	sb	a2,-1(a3)
  a28d88:	bfc5                	j	a28d78 <memmove+0x2e>
  a28d8a:	e781                	bnez	a5,a28d92 <memmove+0x48>
  a28d8c:	8742                	mv	a4,a6
  a28d8e:	853a                	mv	a0,a4
  a28d90:	8082                	ret
  a28d92:	0705                	addi	a4,a4,1
  a28d94:	fff74603          	lbu	a2,-1(a4)
  a28d98:	0685                	addi	a3,a3,1
  a28d9a:	17fd                	addi	a5,a5,-1
  a28d9c:	fec68fa3          	sb	a2,-1(a3)
  a28da0:	0036f613          	andi	a2,a3,3
  a28da4:	f27d                	bnez	a2,a28d8a <memmove+0x40>
  a28da6:	460d                	li	a2,3
  a28da8:	fcf677e3          	bgeu	a2,a5,a28d76 <memmove+0x2c>
  a28dac:	430c                	lw	a1,0(a4)
  a28dae:	17f1                	addi	a5,a5,-4
  a28db0:	0691                	addi	a3,a3,4
  a28db2:	feb6ae23          	sw	a1,-4(a3)
  a28db6:	0711                	addi	a4,a4,4
  a28db8:	bfc5                	j	a28da8 <memmove+0x5e>
  a28dba:	86aa                	mv	a3,a0
  a28dbc:	b7d5                	j	a28da0 <memmove+0x56>
  a28dbe:	ee81                	bnez	a3,a28dd6 <memmove+0x8c>
  a28dc0:	962a                	add	a2,a2,a0
  a28dc2:	00f586b3          	add	a3,a1,a5
  a28dc6:	00367593          	andi	a1,a2,3
  a28dca:	40e687b3          	sub	a5,a3,a4
  a28dce:	ed89                	bnez	a1,a28de8 <memmove+0x9e>
  a28dd0:	468d                	li	a3,3
  a28dd2:	02f6e363          	bltu	a3,a5,a28df8 <memmove+0xae>
  a28dd6:	dbdd                	beqz	a5,a28d8c <memmove+0x42>
  a28dd8:	17fd                	addi	a5,a5,-1
  a28dda:	00f706b3          	add	a3,a4,a5
  a28dde:	2290                	lbu	a2,0(a3)
  a28de0:	00f806b3          	add	a3,a6,a5
  a28de4:	a290                	sb	a2,0(a3)
  a28de6:	bfc5                	j	a28dd6 <memmove+0x8c>
  a28de8:	167d                	addi	a2,a2,-1
  a28dea:	fad701e3          	beq	a4,a3,a28d8c <memmove+0x42>
  a28dee:	fff6c783          	lbu	a5,-1(a3)
  a28df2:	16fd                	addi	a3,a3,-1
  a28df4:	a21c                	sb	a5,0(a2)
  a28df6:	bfc1                	j	a28dc6 <memmove+0x7c>
  a28df8:	17f1                	addi	a5,a5,-4
  a28dfa:	00f70633          	add	a2,a4,a5
  a28dfe:	420c                	lw	a1,0(a2)
  a28e00:	00f80633          	add	a2,a6,a5
  a28e04:	c20c                	sw	a1,0(a2)
  a28e06:	b7f1                	j	a28dd2 <memmove+0x88>

00a28e08 <reset>:
  a28e08:	8018                	push	{ra},-16
  a28e0a:	739030ef          	jal	ra,a2cd42 <update_reset_count>
  a28e0e:	400027b7          	lui	a5,0x40002
  a28e12:	4711                	li	a4,4
  a28e14:	10e79823          	sh	a4,272(a5) # 40002110 <_gp_+0x3f5cd8cc>
  a28e18:	a001                	j	a28e18 <reset+0x10>

00a28e1a <boot_fail>:
  a28e1a:	a001                	j	a28e1a <boot_fail>

00a28e1c <boot_regist_flash_cmd>:
  a28e1c:	8018                	push	{ra},-16
  a28e1e:	862a                	mv	a2,a0
  a28e20:	46d1                	li	a3,20
  a28e22:	45d1                	li	a1,20
  a28e24:	00a0 5500 051f      	l.li	a0,0xa05500
  a28e2a:	4a5070ef          	jal	ra,a30ace <memcpy_s>
  a28e2e:	c501                	beqz	a0,a28e36 <boot_regist_flash_cmd+0x1a>
  a28e30:	80000537          	lui	a0,0x80000
  a28e34:	0511                	addi	a0,a0,4 # 80000004 <_gp_+0x7f5cb7c0>
  a28e36:	8014                	popret	{ra},16

00a28e38 <jump_to_execute_addr>:
  a28e38:	8018                	push	{ra},-16
  a28e3a:	9502                	jalr	a0
  a28e3c:	8010                	pop	{ra},16
  a28e3e:	bff1                	j	a28e1a <boot_fail>

00a28e40 <ws63_set_try_fix_cnt>:
  a28e40:	40000737          	lui	a4,0x40000
  a28e44:	471c                	lw	a5,8(a4)
  a28e46:	893d                	andi	a0,a0,15
  a28e48:	9bc1                	andi	a5,a5,-16
  a28e4a:	8fc9                	or	a5,a5,a0
  a28e4c:	c71c                	sw	a5,8(a4)
  a28e4e:	8082                	ret

00a28e50 <sfc_flash_erase>:
  a28e50:	ffe007b7          	lui	a5,0xffe00
  a28e54:	953e                	add	a0,a0,a5
  a28e56:	26d0306f          	j	a2c8c2 <uapi_sfc_reg_erase>

00a28e5a <sfc_flash_write>:
  a28e5a:	87b2                	mv	a5,a2
  a28e5c:	862e                	mv	a2,a1
  a28e5e:	85be                	mv	a1,a5
  a28e60:	1650306f          	j	a2c7c4 <uapi_sfc_reg_write>

00a28e64 <sfc_flash_read>:
  a28e64:	87b2                	mv	a5,a2
  a28e66:	862e                	mv	a2,a1
  a28e68:	85be                	mv	a1,a5
  a28e6a:	0870306f          	j	a2c6f0 <uapi_sfc_reg_read>

00a28e6e <sfc_flash_init>:
  a28e6e:	00a3 1e80 051f      	l.li	a0,0xa31e80
  a28e74:	7d20306f          	j	a2c646 <uapi_sfc_init>

00a28e78 <start_fastboot>:
  a28e78:	8b58                	push	{ra,s0-s3},-208
  a28e7a:	d602                	sw	zero,44(sp)
  a28e7c:	d802                	sw	zero,48(sp)
  a28e7e:	da02                	sw	zero,52(sp)
  a28e80:	40003637          	lui	a2,0x40003
  a28e84:	23862783          	lw	a5,568(a2) # 40003238 <_gp_+0x3f5ce9f4>
  a28e88:	0037d693          	srli	a3,a5,0x3
  a28e8c:	0027d713          	srli	a4,a5,0x2
  a28e90:	8a85                	andi	a3,a3,1
  a28e92:	8b05                	andi	a4,a4,1
  a28e94:	00e68a63          	beq	a3,a4,a28ea8 <start_fastboot+0x30>
  a28e98:	0047f713          	andi	a4,a5,4
  a28e9c:	e711                	bnez	a4,a28ea8 <start_fastboot+0x30>
  a28e9e:	9bf9                	andi	a5,a5,-2
  a28ea0:	0027e793          	ori	a5,a5,2
  a28ea4:	22f62c23          	sw	a5,568(a2)
  a28ea8:	40003737          	lui	a4,0x40003
  a28eac:	40872783          	lw	a5,1032(a4) # 40003408 <_gp_+0x3f5cebc4>
  a28eb0:	0387e793          	ori	a5,a5,56
  a28eb4:	40f72423          	sw	a5,1032(a4)
  a28eb8:	405030ef          	jal	ra,a2cabc <boot_clock_adapt>
  a28ebc:	451d                	li	a0,7
  a28ebe:	155010ef          	jal	ra,a2a812 <uapi_watchdog_init>
  a28ec2:	4501                	li	a0,0
  a28ec4:	1a1010ef          	jal	ra,a2a864 <uapi_watchdog_enable>
  a28ec8:	0001 c200 079f      	l.li	a5,0x1c200
  a28ece:	dc3e                	sw	a5,56(sp)
  a28ed0:	10800793          	li	a5,264
  a28ed4:	de3e                	sw	a5,60(sp)
  a28ed6:	0004 0102 079f      	l.li	a5,0x40102
  a28edc:	c0be                	sw	a5,64(sp)
  a28ede:	418010ef          	jal	ra,a2a2f6 <uapi_tcxo_init>
  a28ee2:	4631                	li	a2,12
  a28ee4:	182c                	addi	a1,sp,56
  a28ee6:	0808                	addi	a0,sp,16
  a28ee8:	36ad                	jal	ra,a28a52 <memcpy>
  a28eea:	4581                	li	a1,0
  a28eec:	0808                	addi	a0,sp,16
  a28eee:	5c5030ef          	jal	ra,a2ccb2 <hiburn_uart_init>
  a28ef2:	4a1030ef          	jal	ra,a2cb92 <serial_set_mute>
  a28ef6:	00a3 1e8c 051f      	l.li	a0,0xa31e8c
  a28efc:	557030ef          	jal	ra,a2cc52 <boot_msg0>
  a28f00:	595040ef          	jal	ra,a2dc94 <uapi_partition_init>
  a28f04:	22a030ef          	jal	ra,a2c12e <pmp_enable>
  a28f08:	34f030ef          	jal	ra,a2ca56 <malloc_port_init>
  a28f0c:	00a3 1ea8 051f      	l.li	a0,0xa31ea8
  a28f12:	541030ef          	jal	ra,a2cc52 <boot_msg0>
  a28f16:	00a2 8e6e 079f      	l.li	a5,0xa28e6e
  a28f1c:	c2be                	sw	a5,68(sp)
  a28f1e:	00a2 8e64 079f      	l.li	a5,0xa28e64
  a28f24:	c4be                	sw	a5,72(sp)
  a28f26:	00a2 8e5a 079f      	l.li	a5,0xa28e5a
  a28f2c:	c6be                	sw	a5,76(sp)
  a28f2e:	00c8                	addi	a0,sp,68
  a28f30:	00a2 8e50 079f      	l.li	a5,0xa28e50
  a28f36:	c8be                	sw	a5,80(sp)
  a28f38:	ca82                	sw	zero,84(sp)
  a28f3a:	35cd                	jal	ra,a28e1c <boot_regist_flash_cmd>
  a28f3c:	3f0d                	jal	ra,a28e6e <sfc_flash_init>
  a28f3e:	c62a                	sw	a0,12(sp)
  a28f40:	20050263          	beqz	a0,a29144 <start_fastboot+0x2cc>
  a28f44:	45b030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a28f48:	45b2                	lw	a1,12(sp)
  a28f4a:	00a3 1ec4 051f      	l.li	a0,0xa31ec4
  a28f50:	515030ef          	jal	ra,a2cc64 <boot_msg1>
  a28f54:	43f030ef          	jal	ra,a2cb92 <serial_set_mute>
  a28f58:	3a9030ef          	jal	ra,a2cb00 <switch_flash_clock_to_pll>
  a28f5c:	3d1030ef          	jal	ra,a2cb2c <config_sfc_ctrl_ds>
  a28f60:	4f4030ef          	jal	ra,a2c454 <sfc_port_fix_sr>
  a28f64:	cd01                	beqz	a0,a28f7c <start_fastboot+0x104>
  a28f66:	c62a                	sw	a0,12(sp)
  a28f68:	437030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a28f6c:	45b2                	lw	a1,12(sp)
  a28f6e:	00a3 1ef0 051f      	l.li	a0,0xa31ef0
  a28f74:	4f1030ef          	jal	ra,a2cc64 <boot_msg1>
  a28f78:	41b030ef          	jal	ra,a2cb92 <serial_set_mute>
  a28f7c:	400037b7          	lui	a5,0x40003
  a28f80:	2387a783          	lw	a5,568(a5) # 40003238 <_gp_+0x3f5ce9f4>
  a28f84:	0027f693          	andi	a3,a5,2
  a28f88:	0087f713          	andi	a4,a5,8
  a28f8c:	1c068263          	beqz	a3,a29150 <start_fastboot+0x2d8>
  a28f90:	8b85                	andi	a5,a5,1
  a28f92:	03300593          	li	a1,51
  a28f96:	c391                	beqz	a5,a28f9a <start_fastboot+0x122>
  a28f98:	45e1                	li	a1,24
  a28f9a:	03300613          	li	a2,51
  a28f9e:	c311                	beqz	a4,a28fa2 <start_fastboot+0x12a>
  a28fa0:	4661                	li	a2,24
  a28fa2:	00a3 1f04 051f      	l.li	a0,0xa31f04
  a28fa8:	4d9030ef          	jal	ra,a2cc80 <boot_msg2>
  a28fac:	291030ef          	jal	ra,a2ca3c <set_efuse_period>
  a28fb0:	195010ef          	jal	ra,a2a944 <uapi_efuse_init>
  a28fb4:	6b0040ef          	jal	ra,a2d664 <ws63_upg_init>
  a28fb8:	182c                	addi	a1,sp,56
  a28fba:	02100513          	li	a0,33
  a28fbe:	d402                	sw	zero,40(sp)
  a28fc0:	553040ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a28fc4:	e509                	bnez	a0,a28fce <start_fastboot+0x156>
  a28fc6:	03814783          	lbu	a5,56(sp)
  a28fca:	18078d63          	beqz	a5,a29164 <start_fastboot+0x2ec>
  a28fce:	10500593          	li	a1,261
  a28fd2:	00a3 1f38 051f      	l.li	a0,0xa31f38
  a28fd8:	48d030ef          	jal	ra,a2cc64 <boot_msg1>
  a28fdc:	106c                	addi	a1,sp,44
  a28fde:	02000513          	li	a0,32
  a28fe2:	531040ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a28fe6:	c919                	beqz	a0,a28ffc <start_fastboot+0x184>
  a28fe8:	3b7030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a28fec:	00a3 1fec 051f      	l.li	a0,0xa31fec
  a28ff2:	461030ef          	jal	ra,a2cc52 <boot_msg0>
  a28ff6:	39d030ef          	jal	ra,a2cb92 <serial_set_mute>
  a28ffa:	3539                	jal	ra,a28e08 <reset>
  a28ffc:	5442                	lw	s0,48(sp)
  a28ffe:	002007b7          	lui	a5,0x200
  a29002:	10078993          	addi	s3,a5,256 # 200100 <__heap_size+0x1e2b08>
  a29006:	99a2                	add	s3,s3,s0
  a29008:	c282                	sw	zero,68(sp)
  a2900a:	c482                	sw	zero,72(sp)
  a2900c:	c682                	sw	zero,76(sp)
  a2900e:	c882                	sw	zero,80(sp)
  a29010:	5952                	lw	s2,52(sp)
  a29012:	0489a703          	lw	a4,72(s3)
  a29016:	00f404b3          	add	s1,s0,a5
  a2901a:	30078793          	addi	a5,a5,768
  a2901e:	943e                	add	s0,s0,a5
  a29020:	3c78 96e1 079f      	l.li	a5,0x3c7896e1
  a29026:	9926                	add	s2,s2,s1
  a29028:	1cf71c63          	bne	a4,a5,a29200 <start_fastboot+0x388>
  a2902c:	00a3 2008 051f      	l.li	a0,0xa32008
  a29032:	421030ef          	jal	ra,a2cc52 <boot_msg0>
  a29036:	00a2 8080 059f      	l.li	a1,0xa28080
  a2903c:	8626                	mv	a2,s1
  a2903e:	4519                	li	a0,6
  a29040:	2321                	jal	ra,a29548 <verify_image_head>
  a29042:	85aa                	mv	a1,a0
  a29044:	26050c63          	beqz	a0,a292bc <start_fastboot+0x444>
  a29048:	00a3 2090 051f      	l.li	a0,0xa32090
  a2904e:	417030ef          	jal	ra,a2cc64 <boot_msg1>
  a29052:	34d030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a29056:	00a3 21e4 051f      	l.li	a0,0xa321e4
  a2905c:	3f7030ef          	jal	ra,a2cc52 <boot_msg0>
  a29060:	333030ef          	jal	ra,a2cb92 <serial_set_mute>
  a29064:	400007b7          	lui	a5,0x40000
  a29068:	4788                	lw	a0,8(a5)
  a2906a:	893d                	andi	a0,a0,15
  a2906c:	478d                	li	a5,3
  a2906e:	26f57163          	bgeu	a0,a5,a292d0 <start_fastboot+0x458>
  a29072:	0505                	addi	a0,a0,1
  a29074:	33f1                	jal	ra,a28e40 <ws63_set_try_fix_cnt>
  a29076:	3b49                	jal	ra,a28e08 <reset>
  a29078:	4501                	li	a0,0
  a2907a:	4b5030ef          	jal	ra,a2cd2e <set_reset_count>
  a2907e:	4501                	li	a0,0
  a29080:	33c1                	jal	ra,a28e40 <ws63_set_try_fix_cnt>
  a29082:	4671                	li	a2,28
  a29084:	4581                	li	a1,0
  a29086:	00c8                	addi	a0,sp,68
  a29088:	3a31                	jal	ra,a289a4 <memset>
  a2908a:	00c8                	addi	a0,sp,68
  a2908c:	1bf040ef          	jal	ra,a2da4a <mfg_get_ftm_run_region>
  a29090:	c939                	beqz	a0,a290e6 <start_fastboot+0x26e>
  a29092:	47a6                	lw	a5,72(sp)
  a29094:	cba9                	beqz	a5,a290e6 <start_fastboot+0x26e>
  a29096:	4394                	lw	a3,0(a5)
  a29098:	4b7c f333 071f      	l.li	a4,0x4b7cf333
  a2909e:	04e69463          	bne	a3,a4,a290e6 <start_fastboot+0x26e>
  a290a2:	4794                	lw	a3,8(a5)
  a290a4:	10000713          	li	a4,256
  a290a8:	02e69f63          	bne	a3,a4,a290e6 <start_fastboot+0x26e>
  a290ac:	4766                	lw	a4,88(sp)
  a290ae:	ef05                	bnez	a4,a290e6 <start_fastboot+0x26e>
  a290b0:	46f6                	lw	a3,92(sp)
  a290b2:	8f45 ba2f 071f      	l.li	a4,0x8f45ba2f
  a290b8:	02e69763          	bne	a3,a4,a290e6 <start_fastboot+0x26e>
  a290bc:	1247a683          	lw	a3,292(a5) # 40000124 <_gp_+0x3f5cb8e0>
  a290c0:	4746                	lw	a4,80(sp)
  a290c2:	30068693          	addi	a3,a3,768
  a290c6:	02d71063          	bne	a4,a3,a290e6 <start_fastboot+0x26e>
  a290ca:	00c4d693          	srli	a3,s1,0xc
  a290ce:	94ba                	add	s1,s1,a4
  a290d0:	44008737          	lui	a4,0x44008
  a290d4:	80d72023          	sw	a3,-2048(a4) # 44007800 <_gp_+0x435d2fbc>
  a290d8:	80b1                	srli	s1,s1,0xc
  a290da:	83b1                	srli	a5,a5,0xc
  a290dc:	82972023          	sw	s1,-2016(a4)
  a290e0:	8f95                	sub	a5,a5,a3
  a290e2:	84f72023          	sw	a5,-1984(a4)
  a290e6:	400007b7          	lui	a5,0x40000
  a290ea:	53d8                	lw	a4,36(a5)
  a290ec:	0207a223          	sw	zero,36(a5) # 40000024 <_gp_+0x3f5cb7e0>
  a290f0:	5a5a 5a5a 079f      	l.li	a5,0x5a5a5a5a
  a290f6:	04f71263          	bne	a4,a5,a2913a <start_fastboot+0x2c2>
  a290fa:	2a5030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a290fe:	01b010ef          	jal	ra,a2a918 <uapi_watchdog_kick>
  a29102:	00a3 2154 051f      	l.li	a0,0xa32154
  a29108:	34b030ef          	jal	ra,a2cc52 <boot_msg0>
  a2910c:	182c                	addi	a1,sp,56
  a2910e:	4509                	li	a0,2
  a29110:	dc02                	sw	zero,56(sp)
  a29112:	de02                	sw	zero,60(sp)
  a29114:	c082                	sw	zero,64(sp)
  a29116:	c282                	sw	zero,68(sp)
  a29118:	c482                	sw	zero,72(sp)
  a2911a:	c682                	sw	zero,76(sp)
  a2911c:	3f7040ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a29120:	84aa                	mv	s1,a0
  a29122:	00cc                	addi	a1,sp,68
  a29124:	4505                	li	a0,1
  a29126:	3ed040ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2912a:	8d45                	or	a0,a0,s1
  a2912c:	20050363          	beqz	a0,a29332 <start_fastboot+0x4ba>
  a29130:	00a3 2170 051f      	l.li	a0,0xa32170
  a29136:	31d030ef          	jal	ra,a2cc52 <boot_msg0>
  a2913a:	7de010ef          	jal	ra,a2a918 <uapi_watchdog_kick>
  a2913e:	8522                	mv	a0,s0
  a29140:	39e5                	jal	ra,a28e38 <jump_to_execute_addr>
  a29142:	8b54                	popret	{ra,s0-s3},208
  a29144:	00a3 1edc 051f      	l.li	a0,0xa31edc
  a2914a:	309030ef          	jal	ra,a2cc52 <boot_msg0>
  a2914e:	b529                	j	a28f58 <start_fastboot+0xe0>
  a29150:	03300593          	li	a1,51
  a29154:	c311                	beqz	a4,a29158 <start_fastboot+0x2e0>
  a29156:	45e1                	li	a1,24
  a29158:	00a3 1f20 051f      	l.li	a0,0xa31f20
  a2915e:	307030ef          	jal	ra,a2cc64 <boot_msg1>
  a29162:	b5a9                	j	a28fac <start_fastboot+0x134>
  a29164:	1028                	addi	a0,sp,40
  a29166:	352040ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2916a:	5522                	lw	a0,40(sp)
  a2916c:	06c00593          	li	a1,108
  a29170:	00d0                	addi	a2,sp,68
  a29172:	3e0040ef          	jal	ra,a2d552 <upg_flash_read>
  a29176:	85aa                	mv	a1,a0
  a29178:	c509                	beqz	a0,a29182 <start_fastboot+0x30a>
  a2917a:	00a3 1f58 051f      	l.li	a0,0xa31f58
  a29180:	bda1                	j	a28fd8 <start_fastboot+0x160>
  a29182:	4716                	lw	a4,68(sp)
  a29184:	55aa 55aa 079f      	l.li	a5,0x55aa55aa
  a2918a:	00f71a63          	bne	a4,a5,a2919e <start_fastboot+0x326>
  a2918e:	573a                	lw	a4,172(sp)
  a29190:	aa55 aa55 079f      	l.li	a5,0xaa55aa55
  a29196:	00f71463          	bne	a4,a5,a2919e <start_fastboot+0x326>
  a2919a:	57aa                	lw	a5,168(sp)
  a2919c:	e799                	bnez	a5,a291aa <start_fastboot+0x332>
  a2919e:	00a3 1f70 051f      	l.li	a0,0xa31f70
  a291a4:	2af030ef          	jal	ra,a2cc52 <boot_msg0>
  a291a8:	bd15                	j	a28fdc <start_fastboot+0x164>
  a291aa:	1f5030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a291ae:	00a3 1f88 051f      	l.li	a0,0xa31f88
  a291b4:	29f030ef          	jal	ra,a2cc52 <boot_msg0>
  a291b8:	2c1050ef          	jal	ra,a2ec78 <uapi_upg_start>
  a291bc:	800037b7          	lui	a5,0x80003
  a291c0:	04778693          	addi	a3,a5,71 # 80003047 <_gp_+0x7f5ce803>
  a291c4:	00a32737          	lui	a4,0xa32
  a291c8:	02d50463          	beq	a0,a3,a291f0 <start_fastboot+0x378>
  a291cc:	04078793          	addi	a5,a5,64
  a291d0:	02f50063          	beq	a0,a5,a291f0 <start_fastboot+0x378>
  a291d4:	cd11                	beqz	a0,a291f0 <start_fastboot+0x378>
  a291d6:	f9870513          	addi	a0,a4,-104 # a31f98 <sfc_cfg+0x118>
  a291da:	279030ef          	jal	ra,a2cc52 <boot_msg0>
  a291de:	00a3 1fb4 051f      	l.li	a0,0xa31fb4
  a291e4:	26f030ef          	jal	ra,a2cc52 <boot_msg0>
  a291e8:	1ab030ef          	jal	ra,a2cb92 <serial_set_mute>
  a291ec:	3931                	jal	ra,a28e08 <reset>
  a291ee:	b3fd                	j	a28fdc <start_fastboot+0x164>
  a291f0:	f9870513          	addi	a0,a4,-104
  a291f4:	25f030ef          	jal	ra,a2cc52 <boot_msg0>
  a291f8:	00a3 1fd0 051f      	l.li	a0,0xa31fd0
  a291fe:	b7dd                	j	a291e4 <start_fastboot+0x36c>
  a29200:	012467b3          	or	a5,s0,s2
  a29204:	0ff7f793          	andi	a5,a5,255
  a29208:	cf89                	beqz	a5,a29222 <start_fastboot+0x3aa>
  a2920a:	195030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a2920e:	864a                	mv	a2,s2
  a29210:	85a6                	mv	a1,s1
  a29212:	00a3 2020 051f      	l.li	a0,0xa32020
  a29218:	269030ef          	jal	ra,a2cc80 <boot_msg2>
  a2921c:	177030ef          	jal	ra,a2cb92 <serial_set_mute>
  a29220:	36e5                	jal	ra,a28e08 <reset>
  a29222:	00a3 203c 051f      	l.li	a0,0xa3203c
  a29228:	22b030ef          	jal	ra,a2cc52 <boot_msg0>
  a2922c:	04c98793          	addi	a5,s3,76
  a29230:	c4be                	sw	a5,72(sp)
  a29232:	47f1                	li	a5,28
  a29234:	c6be                	sw	a5,76(sp)
  a29236:	4641                	li	a2,16
  a29238:	4785                	li	a5,1
  a2923a:	00cc                	addi	a1,sp,68
  a2923c:	0808                	addi	a0,sp,16
  a2923e:	04f10823          	sb	a5,80(sp)
  a29242:	811ff0ef          	jal	ra,a28a52 <memcpy>
  a29246:	0808                	addi	a0,sp,16
  a29248:	1f1000ef          	jal	ra,a29c38 <drv_rom_cipher_config_odrk1>
  a2924c:	cd09                	beqz	a0,a29266 <start_fastboot+0x3ee>
  a2924e:	c62a                	sw	a0,12(sp)
  a29250:	14f030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a29254:	45b2                	lw	a1,12(sp)
  a29256:	00a3 2054 051f      	l.li	a0,0xa32054
  a2925c:	209030ef          	jal	ra,a2cc64 <boot_msg1>
  a29260:	133030ef          	jal	ra,a2cb92 <serial_set_mute>
  a29264:	3655                	jal	ra,a28e08 <reset>
  a29266:	4741                	li	a4,16
  a29268:	06c98693          	addi	a3,s3,108
  a2926c:	864a                	mv	a2,s2
  a2926e:	85a2                	mv	a1,s0
  a29270:	4501                	li	a0,0
  a29272:	22b000ef          	jal	ra,a29c9c <drv_rom_cipher_fapc_config>
  a29276:	cd09                	beqz	a0,a29290 <start_fastboot+0x418>
  a29278:	c62a                	sw	a0,12(sp)
  a2927a:	125030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a2927e:	45b2                	lw	a1,12(sp)
  a29280:	00a3 2068 051f      	l.li	a0,0xa32068
  a29286:	1df030ef          	jal	ra,a2cc64 <boot_msg1>
  a2928a:	109030ef          	jal	ra,a2cb92 <serial_set_mute>
  a2928e:	3ead                	jal	ra,a28e08 <reset>
  a29290:	4685                	li	a3,1
  a29292:	00a00637          	lui	a2,0xa00
  a29296:	85ca                	mv	a1,s2
  a29298:	4505                	li	a0,1
  a2929a:	249000ef          	jal	ra,a29ce2 <drv_rom_cipher_fapc_bypass_config>
  a2929e:	d8050ce3          	beqz	a0,a29036 <start_fastboot+0x1be>
  a292a2:	c62a                	sw	a0,12(sp)
  a292a4:	0fb030ef          	jal	ra,a2cb9e <serial_cancel_mute>
  a292a8:	45b2                	lw	a1,12(sp)
  a292aa:	00a3 207c 051f      	l.li	a0,0xa3207c
  a292b0:	1b5030ef          	jal	ra,a2cc64 <boot_msg1>
  a292b4:	0df030ef          	jal	ra,a2cb92 <serial_set_mute>
  a292b8:	3e81                	jal	ra,a28e08 <reset>
  a292ba:	bbb5                	j	a29036 <start_fastboot+0x1be>
  a292bc:	85a2                	mv	a1,s0
  a292be:	8526                	mv	a0,s1
  a292c0:	2195                	jal	ra,a29724 <verify_image_body>
  a292c2:	85aa                	mv	a1,a0
  a292c4:	da050ae3          	beqz	a0,a29078 <start_fastboot+0x200>
  a292c8:	00a3 20b0 051f      	l.li	a0,0xa320b0
  a292ce:	b341                	j	a2904e <start_fastboot+0x1d6>
  a292d0:	4799                	li	a5,6
  a292d2:	daf572e3          	bgeu	a0,a5,a29076 <start_fastboot+0x1fe>
  a292d6:	0505                	addi	a0,a0,1
  a292d8:	36a5                	jal	ra,a28e40 <ws63_set_try_fix_cnt>
  a292da:	00c8                	addi	a0,sp,68
  a292dc:	c282                	sw	zero,68(sp)
  a292de:	46b040ef          	jal	ra,a2df48 <upg_get_package_header>
  a292e2:	85aa                	mv	a1,a0
  a292e4:	e119                	bnez	a0,a292ea <start_fastboot+0x472>
  a292e6:	4516                	lw	a0,68(sp)
  a292e8:	e519                	bnez	a0,a292f6 <start_fastboot+0x47e>
  a292ea:	00a3 20d0 051f      	l.li	a0,0xa320d0
  a292f0:	175030ef          	jal	ra,a2cc64 <boot_msg1>
  a292f4:	b349                	j	a29076 <start_fastboot+0x1fe>
  a292f6:	390050ef          	jal	ra,a2e686 <uapi_upg_verify_file>
  a292fa:	85aa                	mv	a1,a0
  a292fc:	c509                	beqz	a0,a29306 <start_fastboot+0x48e>
  a292fe:	00a3 20ec 051f      	l.li	a0,0xa320ec
  a29304:	b7f5                	j	a292f0 <start_fastboot+0x478>
  a29306:	452050ef          	jal	ra,a2e758 <uapi_upg_reset_upgrade_flag>
  a2930a:	85aa                	mv	a1,a0
  a2930c:	c509                	beqz	a0,a29316 <start_fastboot+0x49e>
  a2930e:	00a3 2104 051f      	l.li	a0,0xa32104
  a29314:	bff1                	j	a292f0 <start_fastboot+0x478>
  a29316:	4b8050ef          	jal	ra,a2e7ce <uapi_upg_request_upgrade>
  a2931a:	85aa                	mv	a1,a0
  a2931c:	c509                	beqz	a0,a29326 <start_fastboot+0x4ae>
  a2931e:	00a3 2124 051f      	l.li	a0,0xa32124
  a29324:	b7f1                	j	a292f0 <start_fastboot+0x478>
  a29326:	00a3 2140 051f      	l.li	a0,0xa32140
  a2932c:	127030ef          	jal	ra,a2cc52 <boot_msg0>
  a29330:	b399                	j	a29076 <start_fastboot+0x1fe>
  a29332:	45b6                	lw	a1,76(sp)
  a29334:	4526                	lw	a0,72(sp)
  a29336:	58c030ef          	jal	ra,a2c8c2 <uapi_sfc_reg_erase>
  a2933a:	85aa                	mv	a1,a0
  a2933c:	c511                	beqz	a0,a29348 <start_fastboot+0x4d0>
  a2933e:	00a3 2194 051f      	l.li	a0,0xa32194
  a29344:	121030ef          	jal	ra,a2cc64 <boot_msg1>
  a29348:	57f2                	lw	a5,60(sp)
  a2934a:	4606                	lw	a2,64(sp)
  a2934c:	4526                	lw	a0,72(sp)
  a2934e:	002005b7          	lui	a1,0x200
  a29352:	95be                	add	a1,a1,a5
  a29354:	470030ef          	jal	ra,a2c7c4 <uapi_sfc_reg_write>
  a29358:	85aa                	mv	a1,a0
  a2935a:	c511                	beqz	a0,a29366 <start_fastboot+0x4ee>
  a2935c:	00a3 21b4 051f      	l.li	a0,0xa321b4
  a29362:	103030ef          	jal	ra,a2cc64 <boot_msg1>
  a29366:	00a3 21d4 051f      	l.li	a0,0xa321d4
  a2936c:	0e7030ef          	jal	ra,a2cc52 <boot_msg0>
  a29370:	023030ef          	jal	ra,a2cb92 <serial_set_mute>
  a29374:	b3d9                	j	a2913a <start_fastboot+0x2c2>

00a29376 <check_image_id>:
  a29376:	00a326b7          	lui	a3,0xa32
  a2937a:	29c68713          	addi	a4,a3,668 # a3229c <g_verify_table>
  a2937e:	4781                	li	a5,0
  a29380:	29c68693          	addi	a3,a3,668
  a29384:	4839                	li	a6,14
  a29386:	00074883          	lbu	a7,0(a4)
  a2938a:	02a89463          	bne	a7,a0,a293b2 <check_image_id+0x3c>
  a2938e:	00174883          	lbu	a7,1(a4)
  a29392:	02b89063          	bne	a7,a1,a293b2 <check_image_id+0x3c>
  a29396:	0cf697db          	muliadd	a5,a3,a5,12
  a2939a:	43dc                	lw	a5,4(a5)
  a2939c:	4501                	li	a0,0
  a2939e:	02c78063          	beq	a5,a2,a293be <check_image_id+0x48>
  a293a2:	8018                	push	{ra},-16
  a293a4:	00a3 221c 051f      	l.li	a0,0xa3221c
  a293aa:	0a9030ef          	jal	ra,a2cc52 <boot_msg0>
  a293ae:	557d                	li	a0,-1
  a293b0:	8014                	popret	{ra},16
  a293b2:	0785                	addi	a5,a5,1
  a293b4:	0731                	addi	a4,a4,12
  a293b6:	fd0798e3          	bne	a5,a6,a29386 <check_image_id+0x10>
  a293ba:	4781                	li	a5,0
  a293bc:	b7c5                	j	a2939c <check_image_id+0x26>
  a293be:	8082                	ret

00a293c0 <check_verify_enable>:
  a293c0:	8118                	push	{ra},-32
  a293c2:	57fd                	li	a5,-1
  a293c4:	4605                	li	a2,1
  a293c6:	00f10593          	addi	a1,sp,15
  a293ca:	451d                	li	a0,7
  a293cc:	00f107a3          	sb	a5,15(sp)
  a293d0:	65e030ef          	jal	ra,a2ca2e <efuse_read_item>
  a293d4:	c901                	beqz	a0,a293e4 <check_verify_enable+0x24>
  a293d6:	00a3 2260 051f      	l.li	a0,0xa32260
  a293dc:	077030ef          	jal	ra,a2cc52 <boot_msg0>
  a293e0:	557d                	li	a0,-1
  a293e2:	8114                	popret	{ra},32
  a293e4:	00f14783          	lbu	a5,15(sp)
  a293e8:	4501                	li	a0,0
  a293ea:	ffe5                	bnez	a5,a293e2 <check_verify_enable+0x22>
  a293ec:	80000537          	lui	a0,0x80000
  a293f0:	0509                	addi	a0,a0,2 # 80000002 <_gp_+0x7f5cb7be>
  a293f2:	bfc5                	j	a293e2 <check_verify_enable+0x22>

00a293f4 <check_msid>:
  a293f4:	8138                	push	{ra,s0-s1},-32
  a293f6:	842a                	mv	s0,a0
  a293f8:	84ae                	mv	s1,a1
  a293fa:	4611                	li	a2,4
  a293fc:	006c                	addi	a1,sp,12
  a293fe:	4519                	li	a0,6
  a29400:	c602                	sw	zero,12(sp)
  a29402:	62c030ef          	jal	ra,a2ca2e <efuse_read_item>
  a29406:	c901                	beqz	a0,a29416 <check_msid+0x22>
  a29408:	00a3 222c 051f      	l.li	a0,0xa3222c
  a2940e:	045030ef          	jal	ra,a2cc52 <boot_msg0>
  a29412:	557d                	li	a0,-1
  a29414:	8134                	popret	{ra,s0-s1},32
  a29416:	47b2                	lw	a5,12(sp)
  a29418:	4501                	li	a0,0
  a2941a:	8c3d                	xor	s0,s0,a5
  a2941c:	8c65                	and	s0,s0,s1
  a2941e:	d87d                	beqz	s0,a29414 <check_msid+0x20>
  a29420:	00a3 224c 051f      	l.li	a0,0xa3224c
  a29426:	b7e5                	j	a2940e <check_msid+0x1a>

00a29428 <secure_authenticate.constprop.2>:
  a29428:	8448                	push	{ra,s0-s2},-80
  a2942a:	02010913          	addi	s2,sp,32
  a2942e:	84aa                	mv	s1,a0
  a29430:	8436                	mv	s0,a3
  a29432:	852e                	mv	a0,a1
  a29434:	02000693          	li	a3,32
  a29438:	85b2                	mv	a1,a2
  a2943a:	864a                	mv	a2,s2
  a2943c:	c402                	sw	zero,8(sp)
  a2943e:	c602                	sw	zero,12(sp)
  a29440:	c802                	sw	zero,16(sp)
  a29442:	c002                	sw	zero,0(sp)
  a29444:	c202                	sw	zero,4(sp)
  a29446:	ca02                	sw	zero,20(sp)
  a29448:	cc02                	sw	zero,24(sp)
  a2944a:	ce02                	sw	zero,28(sp)
  a2944c:	61f000ef          	jal	ra,a2a26a <drv_rom_cipher_sha256>
  a29450:	c909                	beqz	a0,a29462 <secure_authenticate.constprop.2+0x3a>
  a29452:	00a3 2344 051f      	l.li	a0,0xa32344
  a29458:	7fa030ef          	jal	ra,a2cc52 <boot_msg0>
  a2945c:	57fd                	li	a5,-1
  a2945e:	853e                	mv	a0,a5
  a29460:	8444                	popret	{ra,s0-s2},80
  a29462:	02000793          	li	a5,32
  a29466:	c426                	sw	s1,8(sp)
  a29468:	ca22                	sw	s0,20(sp)
  a2946a:	02048493          	addi	s1,s1,32
  a2946e:	02040413          	addi	s0,s0,32
  a29472:	0850                	addi	a2,sp,20
  a29474:	858a                	mv	a1,sp
  a29476:	0028                	addi	a0,sp,8
  a29478:	c83e                	sw	a5,16(sp)
  a2947a:	c03e                	sw	a5,0(sp)
  a2947c:	ce3e                	sw	a5,28(sp)
  a2947e:	c626                	sw	s1,12(sp)
  a29480:	c24a                	sw	s2,4(sp)
  a29482:	cc22                	sw	s0,24(sp)
  a29484:	5df000ef          	jal	ra,a2a262 <drv_rom_cipher_pke_bp256r_verify>
  a29488:	4781                	li	a5,0
  a2948a:	d971                	beqz	a0,a2945e <secure_authenticate.constprop.2+0x36>
  a2948c:	00a3 2374 051f      	l.li	a0,0xa32374
  a29492:	b7d9                	j	a29458 <secure_authenticate.constprop.2+0x30>

00a29494 <check_die_id.constprop.3>:
  a29494:	8138                	push	{ra,s0-s1},-32
  a29496:	84aa                	mv	s1,a0
  a29498:	4641                	li	a2,16
  a2949a:	858a                	mv	a1,sp
  a2949c:	4505                	li	a0,1
  a2949e:	c002                	sw	zero,0(sp)
  a294a0:	c202                	sw	zero,4(sp)
  a294a2:	c402                	sw	zero,8(sp)
  a294a4:	c602                	sw	zero,12(sp)
  a294a6:	588030ef          	jal	ra,a2ca2e <efuse_read_item>
  a294aa:	c909                	beqz	a0,a294bc <check_die_id.constprop.3+0x28>
  a294ac:	00a3 21e8 051f      	l.li	a0,0xa321e8
  a294b2:	7a0030ef          	jal	ra,a2cc52 <boot_msg0>
  a294b6:	547d                	li	s0,-1
  a294b8:	8522                	mv	a0,s0
  a294ba:	8134                	popret	{ra,s0-s1},32
  a294bc:	842a                	mv	s0,a0
  a294be:	4641                	li	a2,16
  a294c0:	85a6                	mv	a1,s1
  a294c2:	850a                	mv	a0,sp
  a294c4:	82bff0ef          	jal	ra,a28cee <memcmp>
  a294c8:	d965                	beqz	a0,a294b8 <check_die_id.constprop.3+0x24>
  a294ca:	00a3 2208 051f      	l.li	a0,0xa32208
  a294d0:	b7cd                	j	a294b2 <check_die_id.constprop.3+0x1e>

00a294d2 <check_version>:
  a294d2:	8138                	push	{ra,s0-s1},-32
  a294d4:	00a32737          	lui	a4,0xa32
  a294d8:	84b2                	mv	s1,a2
  a294da:	29c70693          	addi	a3,a4,668 # a3229c <g_verify_table>
  a294de:	842e                	mv	s0,a1
  a294e0:	c602                	sw	zero,12(sp)
  a294e2:	4781                	li	a5,0
  a294e4:	29c70713          	addi	a4,a4,668
  a294e8:	4639                	li	a2,14
  a294ea:	228c                	lbu	a1,0(a3)
  a294ec:	02a59463          	bne	a1,a0,a29514 <check_version+0x42>
  a294f0:	0cf717db          	muliadd	a5,a4,a5,12
  a294f4:	2788                	lbu	a0,8(a5)
  a294f6:	006c                	addi	a1,sp,12
  a294f8:	4611                	li	a2,4
  a294fa:	534030ef          	jal	ra,a2ca2e <efuse_read_item>
  a294fe:	87aa                	mv	a5,a0
  a29500:	009475b3          	and	a1,s0,s1
  a29504:	c115                	beqz	a0,a29528 <check_version+0x56>
  a29506:	00a3 222c 051f      	l.li	a0,0xa3222c
  a2950c:	746030ef          	jal	ra,a2cc52 <boot_msg0>
  a29510:	557d                	li	a0,-1
  a29512:	8134                	popret	{ra,s0-s1},32
  a29514:	0785                	addi	a5,a5,1
  a29516:	06b1                	addi	a3,a3,12
  a29518:	fcc799e3          	bne	a5,a2,a294ea <check_version+0x18>
  a2951c:	4501                	li	a0,0
  a2951e:	bfe1                	j	a294f6 <check_version+0x24>
  a29520:	fff58713          	addi	a4,a1,-1 # 1fffff <__heap_size+0x1e2a07>
  a29524:	8df9                	and	a1,a1,a4
  a29526:	0785                	addi	a5,a5,1
  a29528:	fde5                	bnez	a1,a29520 <check_version+0x4e>
  a2952a:	4632                	lw	a2,12(sp)
  a2952c:	8e65                	and	a2,a2,s1
  a2952e:	ea01                	bnez	a2,a2953e <check_version+0x6c>
  a29530:	4501                	li	a0,0
  a29532:	feb7f0e3          	bgeu	a5,a1,a29512 <check_version+0x40>
  a29536:	00a3 2284 051f      	l.li	a0,0xa32284
  a2953c:	bfc1                	j	a2950c <check_version+0x3a>
  a2953e:	fff60713          	addi	a4,a2,-1 # 9fffff <__heap_size+0x9e2a07>
  a29542:	8e79                	and	a2,a2,a4
  a29544:	0585                	addi	a1,a1,1
  a29546:	b7e5                	j	a2952e <check_version+0x5c>

00a29548 <verify_image_head>:
  a29548:	8048                	push	{ra,s0-s2},-16
  a2954a:	1c060963          	beqz	a2,a2971c <verify_image_head+0x1d4>
  a2954e:	f0000793          	li	a5,-256
  a29552:	1cf60563          	beq	a2,a5,a2971c <verify_image_head+0x1d4>
  a29556:	8432                	mv	s0,a2
  a29558:	892e                	mv	s2,a1
  a2955a:	84aa                	mv	s1,a0
  a2955c:	3595                	jal	ra,a293c0 <check_verify_enable>
  a2955e:	800007b7          	lui	a5,0x80000
  a29562:	0789                	addi	a5,a5,2 # 80000002 <_gp_+0x7f5cb7be>
  a29564:	02f51563          	bne	a0,a5,a2958e <verify_image_head+0x46>
  a29568:	00a3 242c 051f      	l.li	a0,0xa3242c
  a2956e:	6e4030ef          	jal	ra,a2cc52 <boot_msg0>
  a29572:	35b9                	jal	ra,a293c0 <check_verify_enable>
  a29574:	800007b7          	lui	a5,0x80000
  a29578:	0789                	addi	a5,a5,2 # 80000002 <_gp_+0x7f5cb7be>
  a2957a:	0ef51e63          	bne	a0,a5,a29676 <verify_image_head+0x12e>
  a2957e:	00a3 259c 051f      	l.li	a0,0xa3259c
  a29584:	6ce030ef          	jal	ra,a2cc52 <boot_msg0>
  a29588:	4401                	li	s0,0
  a2958a:	8522                	mv	a0,s0
  a2958c:	8044                	popret	{ra,s0-s2},16
  a2958e:	ff05183b          	bnei	a0,-1,a295ae <verify_image_head+0x66>
  a29592:	00a3 245c 051f      	l.li	a0,0xa3245c
  a29598:	6ba030ef          	jal	ra,a2cc52 <boot_msg0>
  a2959c:	8000 15c0 041f      	l.li	s0,0x800015c0
  a295a2:	00a3 2580 051f      	l.li	a0,0xa32580
  a295a8:	6aa030ef          	jal	ra,a2cc52 <boot_msg0>
  a295ac:	bff9                	j	a2958a <verify_image_head+0x42>
  a295ae:	c491                	beqz	s1,a295ba <verify_image_head+0x72>
  a295b0:	ffe48793          	addi	a5,s1,-2
  a295b4:	9f81                	uxtb	a5
  a295b6:	0207f8bb          	bgeui	a5,2,a295d8 <verify_image_head+0x90>
  a295ba:	00a0 5514 079f      	l.li	a5,0xa05514
  a295c0:	439c                	lw	a5,0(a5)
  a295c2:	050785bb          	beqi	a5,5,a295d8 <verify_image_head+0x90>
  a295c6:	00a3 2488 051f      	l.li	a0,0xa32488
  a295cc:	686030ef          	jal	ra,a2cc52 <boot_msg0>
  a295d0:	8000 15c1 041f      	l.li	s0,0x800015c1
  a295d6:	b7f1                	j	a295a2 <verify_image_head+0x5a>
  a295d8:	4010                	lw	a2,0(s0)
  a295da:	4581                	li	a1,0
  a295dc:	8526                	mv	a0,s1
  a295de:	3b61                	jal	ra,a29376 <check_image_id>
  a295e0:	c911                	beqz	a0,a295f4 <verify_image_head+0xac>
  a295e2:	00a3 24b8 051f      	l.li	a0,0xa324b8
  a295e8:	66a030ef          	jal	ra,a2cc52 <boot_msg0>
  a295ec:	8000 15c2 041f      	l.li	s0,0x800015c2
  a295f2:	bf45                	j	a295a2 <verify_image_head+0x5a>
  a295f4:	0c040693          	addi	a3,s0,192
  a295f8:	0c000613          	li	a2,192
  a295fc:	85a2                	mv	a1,s0
  a295fe:	854a                	mv	a0,s2
  a29600:	3525                	jal	ra,a29428 <secure_authenticate.constprop.2>
  a29602:	c911                	beqz	a0,a29616 <verify_image_head+0xce>
  a29604:	00a3 24e0 051f      	l.li	a0,0xa324e0
  a2960a:	648030ef          	jal	ra,a2cc52 <boot_msg0>
  a2960e:	8000 15c3 041f      	l.li	s0,0x800015c3
  a29614:	b779                	j	a295a2 <verify_image_head+0x5a>
  a29616:	cc99                	beqz	s1,a29634 <verify_image_head+0xec>
  a29618:	5410                	lw	a2,40(s0)
  a2961a:	504c                	lw	a1,36(s0)
  a2961c:	8526                	mv	a0,s1
  a2961e:	3d55                	jal	ra,a294d2 <check_version>
  a29620:	c911                	beqz	a0,a29634 <verify_image_head+0xec>
  a29622:	00a3 250c 051f      	l.li	a0,0xa3250c
  a29628:	62a030ef          	jal	ra,a2cc52 <boot_msg0>
  a2962c:	8000 15c4 041f      	l.li	s0,0x800015c4
  a29632:	bf85                	j	a295a2 <verify_image_head+0x5a>
  a29634:	580c                	lw	a1,48(s0)
  a29636:	5448                	lw	a0,44(s0)
  a29638:	3b75                	jal	ra,a293f4 <check_msid>
  a2963a:	c911                	beqz	a0,a2964e <verify_image_head+0x106>
  a2963c:	00a3 2538 051f      	l.li	a0,0xa32538
  a29642:	610030ef          	jal	ra,a2cc52 <boot_msg0>
  a29646:	8000 15c5 041f      	l.li	s0,0x800015c5
  a2964c:	bf99                	j	a295a2 <verify_image_head+0x5a>
  a2964e:	5858                	lw	a4,52(s0)
  a29650:	2a13 c812 079f      	l.li	a5,0x2a13c812
  a29656:	f0f71ee3          	bne	a4,a5,a29572 <verify_image_head+0x2a>
  a2965a:	03840513          	addi	a0,s0,56
  a2965e:	3d1d                	jal	ra,a29494 <check_die_id.constprop.3>
  a29660:	f00509e3          	beqz	a0,a29572 <verify_image_head+0x2a>
  a29664:	00a3 255c 051f      	l.li	a0,0xa3255c
  a2966a:	5e8030ef          	jal	ra,a2cc52 <boot_msg0>
  a2966e:	8000 15c6 041f      	l.li	s0,0x800015c6
  a29674:	b73d                	j	a295a2 <verify_image_head+0x5a>
  a29676:	ff05173b          	bnei	a0,-1,a29692 <verify_image_head+0x14a>
  a2967a:	00a3 25cc 051f      	l.li	a0,0xa325cc
  a29680:	5d2030ef          	jal	ra,a2cc52 <boot_msg0>
  a29684:	8000 15c0 041f      	l.li	s0,0x800015c0
  a2968a:	00a3 269c 051f      	l.li	a0,0xa3269c
  a29690:	bf21                	j	a295a8 <verify_image_head+0x60>
  a29692:	10042603          	lw	a2,256(s0)
  a29696:	4585                	li	a1,1
  a29698:	8526                	mv	a0,s1
  a2969a:	10040913          	addi	s2,s0,256
  a2969e:	39e1                	jal	ra,a29376 <check_image_id>
  a296a0:	c911                	beqz	a0,a296b4 <verify_image_head+0x16c>
  a296a2:	00a3 25f8 051f      	l.li	a0,0xa325f8
  a296a8:	5aa030ef          	jal	ra,a2cc52 <boot_msg0>
  a296ac:	8000 15c2 041f      	l.li	s0,0x800015c2
  a296b2:	bfe1                	j	a2968a <verify_image_head+0x142>
  a296b4:	28040693          	addi	a3,s0,640
  a296b8:	18000613          	li	a2,384
  a296bc:	85ca                	mv	a1,s2
  a296be:	08040513          	addi	a0,s0,128
  a296c2:	339d                	jal	ra,a29428 <secure_authenticate.constprop.2>
  a296c4:	c911                	beqz	a0,a296d8 <verify_image_head+0x190>
  a296c6:	00a3 2620 051f      	l.li	a0,0xa32620
  a296cc:	586030ef          	jal	ra,a2cc52 <boot_msg0>
  a296d0:	8000 15c3 041f      	l.li	s0,0x800015c3
  a296d6:	bf55                	j	a2968a <verify_image_head+0x142>
  a296d8:	c08d                	beqz	s1,a296fa <verify_image_head+0x1b2>
  a296da:	01492603          	lw	a2,20(s2)
  a296de:	01092583          	lw	a1,16(s2)
  a296e2:	8526                	mv	a0,s1
  a296e4:	33fd                	jal	ra,a294d2 <check_version>
  a296e6:	c911                	beqz	a0,a296fa <verify_image_head+0x1b2>
  a296e8:	00a3 264c 051f      	l.li	a0,0xa3264c
  a296ee:	564030ef          	jal	ra,a2cc52 <boot_msg0>
  a296f2:	8000 15c4 041f      	l.li	s0,0x800015c4
  a296f8:	bf49                	j	a2968a <verify_image_head+0x142>
  a296fa:	01c92583          	lw	a1,28(s2)
  a296fe:	01892503          	lw	a0,24(s2)
  a29702:	39cd                	jal	ra,a293f4 <check_msid>
  a29704:	842a                	mv	s0,a0
  a29706:	e80502e3          	beqz	a0,a2958a <verify_image_head+0x42>
  a2970a:	00a3 2678 051f      	l.li	a0,0xa32678
  a29710:	542030ef          	jal	ra,a2cc52 <boot_msg0>
  a29714:	8000 15c5 041f      	l.li	s0,0x800015c5
  a2971a:	bf85                	j	a2968a <verify_image_head+0x142>
  a2971c:	8000 15ca 041f      	l.li	s0,0x800015ca
  a29722:	b5a5                	j	a2958a <verify_image_head+0x42>

00a29724 <verify_image_body>:
  a29724:	8248                	push	{ra,s0-s2},-48
  a29726:	f0000793          	li	a5,-256
  a2972a:	06f50763          	beq	a0,a5,a29798 <verify_image_body+0x74>
  a2972e:	c5ad                	beqz	a1,a29798 <verify_image_body+0x74>
  a29730:	84ae                	mv	s1,a1
  a29732:	842a                	mv	s0,a0
  a29734:	02000613          	li	a2,32
  a29738:	4581                	li	a1,0
  a2973a:	10050913          	addi	s2,a0,256
  a2973e:	850a                	mv	a0,sp
  a29740:	a64ff0ef          	jal	ra,a289a4 <memset>
  a29744:	12442583          	lw	a1,292(s0)
  a29748:	02000693          	li	a3,32
  a2974c:	860a                	mv	a2,sp
  a2974e:	8526                	mv	a0,s1
  a29750:	31b000ef          	jal	ra,a2a26a <drv_rom_cipher_sha256>
  a29754:	c105                	beqz	a0,a29774 <verify_image_body+0x50>
  a29756:	00a3 23b0 051f      	l.li	a0,0xa323b0
  a2975c:	4f6030ef          	jal	ra,a2cc52 <boot_msg0>
  a29760:	8000 15c7 041f      	l.li	s0,0x800015c7
  a29766:	00a3 240c 051f      	l.li	a0,0xa3240c
  a2976c:	4e6030ef          	jal	ra,a2cc52 <boot_msg0>
  a29770:	8522                	mv	a0,s0
  a29772:	8244                	popret	{ra,s0-s2},48
  a29774:	12840593          	addi	a1,s0,296
  a29778:	02000613          	li	a2,32
  a2977c:	850a                	mv	a0,sp
  a2977e:	d70ff0ef          	jal	ra,a28cee <memcmp>
  a29782:	4401                	li	s0,0
  a29784:	d575                	beqz	a0,a29770 <verify_image_body+0x4c>
  a29786:	00a3 23e0 051f      	l.li	a0,0xa323e0
  a2978c:	4c6030ef          	jal	ra,a2cc52 <boot_msg0>
  a29790:	8000 15c8 041f      	l.li	s0,0x800015c8
  a29796:	bfc1                	j	a29766 <verify_image_body+0x42>
  a29798:	8000 15ca 041f      	l.li	s0,0x800015ca
  a2979e:	bfc9                	j	a29770 <verify_image_body+0x4c>

00a297a0 <non_os_enter_critical>:
  a297a0:	8038                	push	{ra,s0-s1},-16
  a297a2:	300024f3          	csrr	s1,mstatus
  a297a6:	300477f3          	csrrci	a5,mstatus,8
  a297aa:	00a05437          	lui	s0,0xa05
  a297ae:	52440793          	addi	a5,s0,1316 # a05524 <g_non_os_critical_nesting>
  a297b2:	239e                	lhu	a5,0(a5)
  a297b4:	52440413          	addi	s0,s0,1316
  a297b8:	9fa1                	uxth	a5
  a297ba:	eb89                	bnez	a5,a297cc <non_os_enter_critical+0x2c>
  a297bc:	00a0 551c 079f      	l.li	a5,0xa0551c
  a297c2:	439c                	lw	a5,0(a5)
  a297c4:	c781                	beqz	a5,a297cc <non_os_enter_critical+0x2c>
  a297c6:	8586                	mv	a1,ra
  a297c8:	4501                	li	a0,0
  a297ca:	9782                	jalr	a5
  a297cc:	00a0 5518 079f      	l.li	a5,0xa05518
  a297d2:	439c                	lw	a5,0(a5)
  a297d4:	c789                	beqz	a5,a297de <non_os_enter_critical+0x3e>
  a297d6:	8586                	mv	a1,ra
  a297d8:	2012                	lhu	a2,0(s0)
  a297da:	4501                	li	a0,0
  a297dc:	9782                	jalr	a5
  a297de:	201e                	lhu	a5,0(s0)
  a297e0:	9fa1                	uxth	a5
  a297e2:	eb89                	bnez	a5,a297f4 <non_os_enter_critical+0x54>
  a297e4:	808d                	srli	s1,s1,0x3
  a297e6:	0014c493          	xori	s1,s1,1
  a297ea:	8885                	andi	s1,s1,1
  a297ec:	00a0 5520 079f      	l.li	a5,0xa05520
  a297f2:	c384                	sw	s1,0(a5)
  a297f4:	201e                	lhu	a5,0(s0)
  a297f6:	0785                	addi	a5,a5,1
  a297f8:	9fa1                	uxth	a5
  a297fa:	a01e                	sh	a5,0(s0)
  a297fc:	201e                	lhu	a5,0(s0)
  a297fe:	9fa1                	uxth	a5
  a29800:	eb81                	bnez	a5,a29810 <non_os_enter_critical+0x70>
  a29802:	06300593          	li	a1,99
  a29806:	03100513          	li	a0,49
  a2980a:	8030                	pop	{ra,s0-s1},16
  a2980c:	3700406f          	j	a2db7c <panic>
  a29810:	0ff0000f          	fence
  a29814:	0ff0000f          	fence
  a29818:	8034                	popret	{ra,s0-s1},16

00a2981a <non_os_exit_critical>:
  a2981a:	8038                	push	{ra,s0-s1},-16
  a2981c:	00a05437          	lui	s0,0xa05
  a29820:	52440793          	addi	a5,s0,1316 # a05524 <g_non_os_critical_nesting>
  a29824:	239e                	lhu	a5,0(a5)
  a29826:	9fa1                	uxth	a5
  a29828:	eb81                	bnez	a5,a29838 <non_os_exit_critical+0x1e>
  a2982a:	06f00593          	li	a1,111
  a2982e:	03100513          	li	a0,49
  a29832:	8030                	pop	{ra,s0-s1},16
  a29834:	3480406f          	j	a2db7c <panic>
  a29838:	52440413          	addi	s0,s0,1316
  a2983c:	201e                	lhu	a5,0(s0)
  a2983e:	8486                	mv	s1,ra
  a29840:	17fd                	addi	a5,a5,-1
  a29842:	9fa1                	uxth	a5
  a29844:	a01e                	sh	a5,0(s0)
  a29846:	00a0 5518 079f      	l.li	a5,0xa05518
  a2984c:	439c                	lw	a5,0(a5)
  a2984e:	c789                	beqz	a5,a29858 <non_os_exit_critical+0x3e>
  a29850:	8586                	mv	a1,ra
  a29852:	2012                	lhu	a2,0(s0)
  a29854:	4505                	li	a0,1
  a29856:	9782                	jalr	a5
  a29858:	201e                	lhu	a5,0(s0)
  a2985a:	9fa1                	uxth	a5
  a2985c:	e785                	bnez	a5,a29884 <non_os_exit_critical+0x6a>
  a2985e:	00a0 551c 079f      	l.li	a5,0xa0551c
  a29864:	439c                	lw	a5,0(a5)
  a29866:	c781                	beqz	a5,a2986e <non_os_exit_critical+0x54>
  a29868:	85a6                	mv	a1,s1
  a2986a:	4505                	li	a0,1
  a2986c:	9782                	jalr	a5
  a2986e:	00a0 5520 079f      	l.li	a5,0xa05520
  a29874:	439c                	lw	a5,0(a5)
  a29876:	e399                	bnez	a5,a2987c <non_os_exit_critical+0x62>
  a29878:	300467f3          	csrrsi	a5,mstatus,8
  a2987c:	0ff0000f          	fence
  a29880:	0ff0000f          	fence
  a29884:	8034                	popret	{ra,s0-s1},16

00a29886 <malloc_register_funcs>:
  a29886:	8018                	push	{ra},-16
  a29888:	862a                	mv	a2,a0
  a2988a:	46b1                	li	a3,12
  a2988c:	45b1                	li	a1,12
  a2988e:	00a0 5528 051f      	l.li	a0,0xa05528
  a29894:	23a070ef          	jal	ra,a30ace <memcpy_s>
  a29898:	4501                	li	a0,0
  a2989a:	8014                	popret	{ra},16

00a2989c <rom_malloc_init>:
  a2989c:	8038                	push	{ra,s0-s1},-16
  a2989e:	842e                	mv	s0,a1
  a298a0:	46e1                	li	a3,24
  a298a2:	4601                	li	a2,0
  a298a4:	45e1                	li	a1,24
  a298a6:	84aa                	mv	s1,a0
  a298a8:	2a2070ef          	jal	ra,a30b4a <memset_s>
  a298ac:	ff840793          	addi	a5,s0,-8
  a298b0:	00a0 5534 071f      	l.li	a4,0xa05534
  a298b6:	01b48513          	addi	a0,s1,27
  a298ba:	9bf1                	andi	a5,a5,-4
  a298bc:	9971                	andi	a0,a0,-4
  a298be:	cb1c                	sw	a5,16(a4)
  a298c0:	17e1                	addi	a5,a5,-8
  a298c2:	8f89                	sub	a5,a5,a0
  a298c4:	c748                	sw	a0,12(a4)
  a298c6:	9fa1                	uxth	a5
  a298c8:	a15e                	sh	a5,4(a0)
  a298ca:	c71c                	sw	a5,8(a4)
  a298cc:	679d                	lui	a5,0x7
  a298ce:	07478793          	addi	a5,a5,116 # 7074 <ccause+0x60b2>
  a298d2:	a17e                	sh	a5,6(a0)
  a298d4:	00052023          	sw	zero,0(a0)
  a298d8:	8034                	popret	{ra,s0-s1},16

00a298da <malloc_init>:
  a298da:	b7c9                	j	a2989c <rom_malloc_init>

00a298dc <rom_malloc>:
  a298dc:	00a056b7          	lui	a3,0xa05
  a298e0:	53468793          	addi	a5,a3,1332 # a05534 <g_st_dfx>
  a298e4:	47dc                	lw	a5,12(a5)
  a298e6:	53468693          	addi	a3,a3,1332
  a298ea:	e399                	bnez	a5,a298f0 <rom_malloc+0x14>
  a298ec:	4501                	li	a0,0
  a298ee:	8082                	ret
  a298f0:	dd75                	beqz	a0,a298ec <rom_malloc+0x10>
  a298f2:	23f2                	lhu	a2,6(a5)
  a298f4:	671d                	lui	a4,0x7
  a298f6:	07470813          	addi	a6,a4,116 # 7074 <ccause+0x60b2>
  a298fa:	01060663          	beq	a2,a6,a29906 <rom_malloc+0x2a>
  a298fe:	c6c70713          	addi	a4,a4,-916
  a29902:	fee615e3          	bne	a2,a4,a298ec <rom_malloc+0x10>
  a29906:	050d                	addi	a0,a0,3
  a29908:	9971                	andi	a0,a0,-4
  a2990a:	671d                	lui	a4,0x7
  a2990c:	9d21                	uxth	a0
  a2990e:	4881                	li	a7,0
  a29910:	07470613          	addi	a2,a4,116 # 7074 <ccause+0x60b2>
  a29914:	00850813          	addi	a6,a0,8
  a29918:	c6c70313          	addi	t1,a4,-916
  a2991c:	0067de03          	lhu	t3,6(a5)
  a29920:	23da                	lhu	a4,4(a5)
  a29922:	04ce1263          	bne	t3,a2,a29966 <rom_malloc+0x8a>
  a29926:	02e87563          	bgeu	a6,a4,a29950 <rom_malloc+0x74>
  a2992a:	8f09                	sub	a4,a4,a0
  a2992c:	983e                	add	a6,a6,a5
  a2992e:	1761                	addi	a4,a4,-8
  a29930:	00e81223          	sh	a4,4(a6)
  a29934:	00c81323          	sh	a2,6(a6)
  a29938:	671d                	lui	a4,0x7
  a2993a:	c6c70713          	addi	a4,a4,-916 # 6c6c <ccause+0x5caa>
  a2993e:	c38c                	sw	a1,0(a5)
  a29940:	a3fa                	sh	a4,6(a5)
  a29942:	4298                	lw	a4,0(a3)
  a29944:	a3ca                	sh	a0,4(a5)
  a29946:	953a                	add	a0,a0,a4
  a29948:	c288                	sw	a0,0(a3)
  a2994a:	00878513          	addi	a0,a5,8
  a2994e:	8082                	ret
  a29950:	00a76b63          	bltu	a4,a0,a29966 <rom_malloc+0x8a>
  a29954:	661d                	lui	a2,0x7
  a29956:	c6c60613          	addi	a2,a2,-916 # 6c6c <ccause+0x5caa>
  a2995a:	c38c                	sw	a1,0(a5)
  a2995c:	a3f2                	sh	a2,6(a5)
  a2995e:	4290                	lw	a2,0(a3)
  a29960:	9732                	add	a4,a4,a2
  a29962:	c298                	sw	a4,0(a3)
  a29964:	b7dd                	j	a2994a <rom_malloc+0x6e>
  a29966:	0721                	addi	a4,a4,8
  a29968:	97ba                	add	a5,a5,a4
  a2996a:	4a98                	lw	a4,16(a3)
  a2996c:	00e7ef63          	bltu	a5,a4,a2998a <rom_malloc+0xae>
  a29970:	f6089ee3          	bnez	a7,a298ec <rom_malloc+0x10>
  a29974:	46d8                	lw	a4,12(a3)
  a29976:	235e                	lhu	a5,4(a4)
  a29978:	0106ae03          	lw	t3,16(a3)
  a2997c:	07a1                	addi	a5,a5,8
  a2997e:	00f708b3          	add	a7,a4,a5
  a29982:	01c8ea63          	bltu	a7,t3,a29996 <rom_malloc+0xba>
  a29986:	46dc                	lw	a5,12(a3)
  a29988:	4885                	li	a7,1
  a2998a:	23fa                	lhu	a4,6(a5)
  a2998c:	f86708e3          	beq	a4,t1,a2991c <rom_malloc+0x40>
  a29990:	f8c706e3          	beq	a4,a2,a2991c <rom_malloc+0x40>
  a29994:	bfa1                	j	a298ec <rom_malloc+0x10>
  a29996:	00675e03          	lhu	t3,6(a4)
  a2999a:	00ce1b63          	bne	t3,a2,a299b0 <rom_malloc+0xd4>
  a2999e:	0068de03          	lhu	t3,6(a7)
  a299a2:	00ce1763          	bne	t3,a2,a299b0 <rom_malloc+0xd4>
  a299a6:	0048d883          	lhu	a7,4(a7)
  a299aa:	97c6                	add	a5,a5,a7
  a299ac:	a35e                	sh	a5,4(a4)
  a299ae:	88ba                	mv	a7,a4
  a299b0:	8746                	mv	a4,a7
  a299b2:	b7d1                	j	a29976 <rom_malloc+0x9a>

00a299b4 <malloc>:
  a299b4:	8018                	push	{ra},-16
  a299b6:	8586                	mv	a1,ra
  a299b8:	8010                	pop	{ra},16
  a299ba:	b70d                	j	a298dc <rom_malloc>

00a299bc <rom_free>:
  a299bc:	c50d                	beqz	a0,a299e6 <rom_free+0x2a>
  a299be:	ffe55703          	lhu	a4,-2(a0)
  a299c2:	0000 6c6c 079f      	l.li	a5,0x6c6c
  a299c8:	00f71f63          	bne	a4,a5,a299e6 <rom_free+0x2a>
  a299cc:	679d                	lui	a5,0x7
  a299ce:	07478793          	addi	a5,a5,116 # 7074 <ccause+0x60b2>
  a299d2:	fef51f23          	sh	a5,-2(a0)
  a299d6:	00a0 5534 071f      	l.li	a4,0xa05534
  a299dc:	ffc55683          	lhu	a3,-4(a0)
  a299e0:	435c                	lw	a5,4(a4)
  a299e2:	97b6                	add	a5,a5,a3
  a299e4:	c35c                	sw	a5,4(a4)
  a299e6:	4501                	li	a0,0
  a299e8:	8082                	ret

00a299ea <free>:
  a299ea:	bfc9                	j	a299bc <rom_free>

00a299ec <osal_irq_lock>:
  a299ec:	8018                	push	{ra},-16
  a299ee:	3b4d                	jal	ra,a297a0 <non_os_enter_critical>
  a299f0:	4501                	li	a0,0
  a299f2:	8014                	popret	{ra},16

00a299f4 <osal_irq_restore>:
  a299f4:	b51d                	j	a2981a <non_os_exit_critical>

00a299f6 <uapi_pmp_config>:
  a299f6:	8168                	push	{ra,s0-s4},-48
  a299f8:	842a                	mv	s0,a0
  a299fa:	84ae                	mv	s1,a1
  a299fc:	097020ef          	jal	ra,a2c292 <pmp_port_register_hal_funcs>
  a29a00:	246010ef          	jal	ra,a2ac46 <hal_pmp_get_funcs>
  a29a04:	89aa                	mv	s3,a0
  a29a06:	4901                	li	s2,0
  a29a08:	4a05                	li	s4,1
  a29a0a:	00991663          	bne	s2,s1,a29a16 <uapi_pmp_config+0x20>
  a29a0e:	0ff0000f          	fence
  a29a12:	4501                	li	a0,0
  a29a14:	8164                	popret	{ra,s0-s4},48
  a29a16:	4058                	lw	a4,4(s0)
  a29a18:	3454                	lbu	a3,13(s0)
  a29a1a:	00042803          	lw	a6,0(s0)
  a29a1e:	00842883          	lw	a7,8(s0)
  a29a22:	245c                	lbu	a5,12(s0)
  a29a24:	246c                	lbu	a1,14(s0)
  a29a26:	3468                	lbu	a0,15(s0)
  a29a28:	00275613          	srli	a2,a4,0x2
  a29a2c:	01468763          	beq	a3,s4,a29a3a <uapi_pmp_config+0x44>
  a29a30:	177d                	addi	a4,a4,-1
  a29a32:	4317071b          	addshf	a4,a4,a7,srl,1
  a29a36:	00275613          	srli	a2,a4,0x2
  a29a3a:	0077f713          	andi	a4,a5,7
  a29a3e:	00d14783          	lbu	a5,13(sp)
  a29a42:	8a8d                	andi	a3,a3,3
  a29a44:	00a10623          	sb	a0,12(sp)
  a29a48:	0e07f793          	andi	a5,a5,224
  a29a4c:	8fd9                	or	a5,a5,a4
  a29a4e:	06d7a79b          	orshf	a5,a5,a3,sll,3
  a29a52:	07f7f793          	andi	a5,a5,127
  a29a56:	0eb7a79b          	orshf	a5,a5,a1,sll,7
  a29a5a:	c242                	sw	a6,4(sp)
  a29a5c:	c432                	sw	a2,8(sp)
  a29a5e:	00f106a3          	sb	a5,13(sp)
  a29a62:	0009a783          	lw	a5,0(s3)
  a29a66:	0048                	addi	a0,sp,4
  a29a68:	0441                	addi	s0,s0,16
  a29a6a:	9782                	jalr	a5
  a29a6c:	f545                	bnez	a0,a29a14 <uapi_pmp_config+0x1e>
  a29a6e:	0905                	addi	s2,s2,1
  a29a70:	bf69                	j	a29a0a <uapi_pmp_config+0x14>

00a29a72 <drv_rom_hash>:
  a29a72:	8e78                	push	{ra,s0-s5},-256
  a29a74:	892a                	mv	s2,a0
  a29a76:	8aae                	mv	s5,a1
  a29a78:	84b2                	mv	s1,a2
  a29a7a:	4581                	li	a1,0
  a29a7c:	04000613          	li	a2,64
  a29a80:	1008                	addi	a0,sp,32
  a29a82:	c63a                	sw	a4,12(sp)
  a29a84:	8a36                	mv	s4,a3
  a29a86:	843e                	mv	s0,a5
  a29a88:	f1dfe0ef          	jal	ra,a289a4 <memset>
  a29a8c:	08000613          	li	a2,128
  a29a90:	4581                	li	a1,0
  a29a92:	1088                	addi	a0,sp,96
  a29a94:	f11fe0ef          	jal	ra,a289a4 <memset>
  a29a98:	ce02                	sw	zero,28(sp)
  a29a9a:	4732                	lw	a4,12(sp)
  a29a9c:	000a9463          	bnez	s5,a29aa4 <drv_rom_hash+0x32>
  a29aa0:	557d                	li	a0,-1
  a29aa2:	8e74                	popret	{ra,s0-s5},256
  a29aa4:	fe0a0ee3          	beqz	s4,a29aa0 <drv_rom_hash+0x2e>
  a29aa8:	010007b7          	lui	a5,0x1000
  a29aac:	fef4fae3          	bgeu	s1,a5,a29aa0 <drv_rom_hash+0x2e>
  a29ab0:	20f71c3b          	bnei	a4,32,a29aa0 <drv_rom_hash+0x2e>
  a29ab4:	0216 9100 079f      	l.li	a5,0x2169100
  a29aba:	0cf90963          	beq	s2,a5,a29b8c <drv_rom_hash+0x11a>
  a29abe:	00a3 26bc 061f      	l.li	a2,0xa326bc
  a29ac4:	85ca                	mv	a1,s2
  a29ac6:	8522                	mv	a0,s0
  a29ac8:	77a000ef          	jal	ra,a2a242 <hal_cipher_hash_config>
  a29acc:	f979                	bnez	a0,a29aa2 <drv_rom_hash+0x30>
  a29ace:	03f4f913          	andi	s2,s1,63
  a29ad2:	412489b3          	sub	s3,s1,s2
  a29ad6:	0a099f63          	bnez	s3,a29b94 <drv_rom_hash+0x122>
  a29ada:	08000693          	li	a3,128
  a29ade:	4601                	li	a2,0
  a29ae0:	08000593          	li	a1,128
  a29ae4:	1088                	addi	a0,sp,96
  a29ae6:	064070ef          	jal	ra,a30b4a <memset_s>
  a29aea:	86ca                	mv	a3,s2
  a29aec:	013a8633          	add	a2,s5,s3
  a29af0:	08000593          	li	a1,128
  a29af4:	1088                	addi	a0,sp,96
  a29af6:	7d9060ef          	jal	ra,a30ace <memcpy_s>
  a29afa:	f15d                	bnez	a0,a29aa0 <drv_rom_hash+0x2e>
  a29afc:	119c                	addi	a5,sp,224
  a29afe:	97ca                	add	a5,a5,s2
  a29b00:	f8000713          	li	a4,-128
  a29b04:	f8e78023          	sb	a4,-128(a5) # ffff80 <_gp_+0x5cb73c>
  a29b08:	04000993          	li	s3,64
  a29b0c:	3809623b          	bltui	s2,56,a29b14 <drv_rom_hash+0xa2>
  a29b10:	08000993          	li	s3,128
  a29b14:	00349713          	slli	a4,s1,0x3
  a29b18:	01b49613          	slli	a2,s1,0x1b
  a29b1c:	0000 ff00 079f      	l.li	a5,0xff00
  a29b22:	50e7c79b          	andshf	a5,a5,a4,srl,8
  a29b26:	70e6261b          	orshf	a2,a2,a4,srl,24
  a29b2a:	8e5d                	or	a2,a2,a5
  a29b2c:	00ff07b7          	lui	a5,0xff0
  a29b30:	1697c49b          	andshf	s1,a5,s1,sll,11
  a29b34:	8e45                	or	a2,a2,s1
  a29b36:	ffc98513          	addi	a0,s3,-4
  a29b3a:	109c                	addi	a5,sp,96
  a29b3c:	ce32                	sw	a2,28(sp)
  a29b3e:	4691                	li	a3,4
  a29b40:	0870                	addi	a2,sp,28
  a29b42:	4591                	li	a1,4
  a29b44:	953e                	add	a0,a0,a5
  a29b46:	789060ef          	jal	ra,a30ace <memcpy_s>
  a29b4a:	f939                	bnez	a0,a29aa0 <drv_rom_hash+0x2e>
  a29b4c:	4695                	li	a3,5
  a29b4e:	864e                	mv	a2,s3
  a29b50:	108c                	addi	a1,sp,96
  a29b52:	8522                	mv	a0,s0
  a29b54:	6f6000ef          	jal	ra,a2a24a <hal_cipher_hash_add_in_node>
  a29b58:	f529                	bnez	a0,a29aa2 <drv_rom_hash+0x30>
  a29b5a:	4581                	li	a1,0
  a29b5c:	8522                	mv	a0,s0
  a29b5e:	6f4000ef          	jal	ra,a2a252 <hal_cipher_hash_start>
  a29b62:	f121                	bnez	a0,a29aa2 <drv_rom_hash+0x30>
  a29b64:	04000613          	li	a2,64
  a29b68:	100c                	addi	a1,sp,32
  a29b6a:	8522                	mv	a0,s0
  a29b6c:	6ee000ef          	jal	ra,a2a25a <hal_cipher_hash_wait_done>
  a29b70:	f90d                	bnez	a0,a29aa2 <drv_rom_hash+0x30>
  a29b72:	02000693          	li	a3,32
  a29b76:	1010                	addi	a2,sp,32
  a29b78:	02000593          	li	a1,32
  a29b7c:	8552                	mv	a0,s4
  a29b7e:	751060ef          	jal	ra,a30ace <memcpy_s>
  a29b82:	00a03533          	snez	a0,a0
  a29b86:	40a00533          	neg	a0,a0
  a29b8a:	bf21                	j	a29aa2 <drv_rom_hash+0x30>
  a29b8c:	00a3 26dc 061f      	l.li	a2,0xa326dc
  a29b92:	bf0d                	j	a29ac4 <drv_rom_hash+0x52>
  a29b94:	4695                	li	a3,5
  a29b96:	864e                	mv	a2,s3
  a29b98:	85d6                	mv	a1,s5
  a29b9a:	8522                	mv	a0,s0
  a29b9c:	257d                	jal	ra,a2a24a <hal_cipher_hash_add_in_node>
  a29b9e:	f00512e3          	bnez	a0,a29aa2 <drv_rom_hash+0x30>
  a29ba2:	4581                	li	a1,0
  a29ba4:	8522                	mv	a0,s0
  a29ba6:	2575                	jal	ra,a2a252 <hal_cipher_hash_start>
  a29ba8:	ee051de3          	bnez	a0,a29aa2 <drv_rom_hash+0x30>
  a29bac:	4601                	li	a2,0
  a29bae:	4581                	li	a1,0
  a29bb0:	8522                	mv	a0,s0
  a29bb2:	2565                	jal	ra,a2a25a <hal_cipher_hash_wait_done>
  a29bb4:	f20503e3          	beqz	a0,a29ada <drv_rom_hash+0x68>
  a29bb8:	b5ed                	j	a29aa2 <drv_rom_hash+0x30>

00a29bba <drv_rom_cipher_create_keyslot>:
  a29bba:	8248                	push	{ra,s0-s2},-48
  a29bbc:	8432                	mv	s0,a2
  a29bbe:	84aa                	mv	s1,a0
  a29bc0:	4639                	li	a2,14
  a29bc2:	892e                	mv	s2,a1
  a29bc4:	01210513          	addi	a0,sp,18
  a29bc8:	4581                	li	a1,0
  a29bca:	ddbfe0ef          	jal	ra,a289a4 <memset>
  a29bce:	02000793          	li	a5,32
  a29bd2:	00f10823          	sb	a5,16(sp)
  a29bd6:	4581                	li	a1,0
  a29bd8:	4785                	li	a5,1
  a29bda:	0048                	addi	a0,sp,4
  a29bdc:	c622                	sw	s0,12(sp)
  a29bde:	00f108a3          	sb	a5,17(sp)
  a29be2:	00f10923          	sb	a5,18(sp)
  a29be6:	00f10b23          	sb	a5,22(sp)
  a29bea:	00f10c23          	sb	a5,24(sp)
  a29bee:	24f9                	jal	ra,a29ebc <drv_keyslot_create>
  a29bf0:	842a                	mv	s0,a0
  a29bf2:	ed0d                	bnez	a0,a29c2c <drv_rom_cipher_create_keyslot+0x72>
  a29bf4:	0028                	addi	a0,sp,8
  a29bf6:	2e91                	jal	ra,a29f4a <drv_klad_create>
  a29bf8:	842a                	mv	s0,a0
  a29bfa:	e91d                	bnez	a0,a29c30 <drv_rom_cipher_create_keyslot+0x76>
  a29bfc:	4612                	lw	a2,4(sp)
  a29bfe:	4522                	lw	a0,8(sp)
  a29c00:	4581                	li	a1,0
  a29c02:	2e4d                	jal	ra,a29fb4 <drv_klad_attach>
  a29c04:	842a                	mv	s0,a0
  a29c06:	e10d                	bnez	a0,a29c28 <drv_rom_cipher_create_keyslot+0x6e>
  a29c08:	4522                	lw	a0,8(sp)
  a29c0a:	006c                	addi	a1,sp,12
  a29c0c:	21a1                	jal	ra,a2a054 <drv_klad_set_attr>
  a29c0e:	842a                	mv	s0,a0
  a29c10:	e901                	bnez	a0,a29c20 <drv_rom_cipher_create_keyslot+0x66>
  a29c12:	4522                	lw	a0,8(sp)
  a29c14:	85ca                	mv	a1,s2
  a29c16:	2155                	jal	ra,a2a0ba <drv_klad_set_effective_key>
  a29c18:	842a                	mv	s0,a0
  a29c1a:	e119                	bnez	a0,a29c20 <drv_rom_cipher_create_keyslot+0x66>
  a29c1c:	4792                	lw	a5,4(sp)
  a29c1e:	c09c                	sw	a5,0(s1)
  a29c20:	4612                	lw	a2,4(sp)
  a29c22:	4522                	lw	a0,8(sp)
  a29c24:	4581                	li	a1,0
  a29c26:	2ec5                	jal	ra,a2a016 <drv_klad_detach>
  a29c28:	4522                	lw	a0,8(sp)
  a29c2a:	2e99                	jal	ra,a29f80 <drv_klad_destroy>
  a29c2c:	8522                	mv	a0,s0
  a29c2e:	8244                	popret	{ra,s0-s2},48
  a29c30:	4088                	lw	a0,0(s1)
  a29c32:	24c5                	jal	ra,a29f12 <drv_keyslot_destroy>
  a29c34:	bfe5                	j	a29c2c <drv_rom_cipher_create_keyslot+0x72>

00a29c36 <drv_rom_cipher_destroy_keyslot>:
  a29c36:	acf1                	j	a29f12 <drv_keyslot_destroy>

00a29c38 <drv_rom_cipher_config_odrk1>:
  a29c38:	8238                	push	{ra,s0-s1},-48
  a29c3a:	4639                	li	a2,14
  a29c3c:	4581                	li	a1,0
  a29c3e:	84aa                	mv	s1,a0
  a29c40:	01210513          	addi	a0,sp,18
  a29c44:	d61fe0ef          	jal	ra,a289a4 <memset>
  a29c48:	0300 000d 079f      	l.li	a5,0x300000d
  a29c4e:	c63e                	sw	a5,12(sp)
  a29c50:	02000793          	li	a5,32
  a29c54:	00f10823          	sb	a5,16(sp)
  a29c58:	0028                	addi	a0,sp,8
  a29c5a:	4785                	li	a5,1
  a29c5c:	00f108a3          	sb	a5,17(sp)
  a29c60:	00f10b23          	sb	a5,22(sp)
  a29c64:	00f10c23          	sb	a5,24(sp)
  a29c68:	24cd                	jal	ra,a29f4a <drv_klad_create>
  a29c6a:	842a                	mv	s0,a0
  a29c6c:	e515                	bnez	a0,a29c98 <drv_rom_cipher_config_odrk1+0x60>
  a29c6e:	4522                	lw	a0,8(sp)
  a29c70:	4601                	li	a2,0
  a29c72:	4589                	li	a1,2
  a29c74:	2681                	jal	ra,a29fb4 <drv_klad_attach>
  a29c76:	842a                	mv	s0,a0
  a29c78:	ed11                	bnez	a0,a29c94 <drv_rom_cipher_config_odrk1+0x5c>
  a29c7a:	4522                	lw	a0,8(sp)
  a29c7c:	006c                	addi	a1,sp,12
  a29c7e:	2ed9                	jal	ra,a2a054 <drv_klad_set_attr>
  a29c80:	842a                	mv	s0,a0
  a29c82:	e509                	bnez	a0,a29c8c <drv_rom_cipher_config_odrk1+0x54>
  a29c84:	4522                	lw	a0,8(sp)
  a29c86:	85a6                	mv	a1,s1
  a29c88:	290d                	jal	ra,a2a0ba <drv_klad_set_effective_key>
  a29c8a:	842a                	mv	s0,a0
  a29c8c:	4522                	lw	a0,8(sp)
  a29c8e:	4601                	li	a2,0
  a29c90:	4589                	li	a1,2
  a29c92:	2651                	jal	ra,a2a016 <drv_klad_detach>
  a29c94:	4522                	lw	a0,8(sp)
  a29c96:	24ed                	jal	ra,a29f80 <drv_klad_destroy>
  a29c98:	8522                	mv	a0,s0
  a29c9a:	8234                	popret	{ra,s0-s1},48

00a29c9c <drv_rom_cipher_fapc_config>:
  a29c9c:	8348                	push	{ra,s0-s2},-64
  a29c9e:	842e                	mv	s0,a1
  a29ca0:	8932                	mv	s2,a2
  a29ca2:	84aa                	mv	s1,a0
  a29ca4:	4661                	li	a2,24
  a29ca6:	4581                	li	a1,0
  a29ca8:	0828                	addi	a0,sp,24
  a29caa:	c636                	sw	a3,12(sp)
  a29cac:	c43a                	sw	a4,8(sp)
  a29cae:	cf7fe0ef          	jal	ra,a289a4 <memset>
  a29cb2:	4789                	li	a5,2
  a29cb4:	46b2                	lw	a3,12(sp)
  a29cb6:	d43e                	sw	a5,40(sp)
  a29cb8:	10100793          	li	a5,257
  a29cbc:	c822                	sw	s0,16(sp)
  a29cbe:	ca4a                	sw	s2,20(sp)
  a29cc0:	ce22                	sw	s0,28(sp)
  a29cc2:	02f11623          	sh	a5,44(sp)
  a29cc6:	557d                	li	a0,-1
  a29cc8:	ce81                	beqz	a3,a29ce0 <drv_rom_cipher_fapc_config+0x44>
  a29cca:	4722                	lw	a4,8(sp)
  a29ccc:	1007153b          	bnei	a4,16,a29ce0 <drv_rom_cipher_fapc_config+0x44>
  a29cd0:	4641                	li	a2,16
  a29cd2:	85b6                	mv	a1,a3
  a29cd4:	4501                	li	a0,0
  a29cd6:	2971                	jal	ra,a2a172 <drv_fapc_set_iv>
  a29cd8:	e501                	bnez	a0,a29ce0 <drv_rom_cipher_fapc_config+0x44>
  a29cda:	080c                	addi	a1,sp,16
  a29cdc:	8526                	mv	a0,s1
  a29cde:	2155                	jal	ra,a2a182 <drv_fapc_set_config>
  a29ce0:	8344                	popret	{ra,s0-s2},64

00a29ce2 <drv_rom_cipher_fapc_bypass_config>:
  a29ce2:	a325                	j	a2a20a <drv_fapc_set_bypass_config>

00a29ce4 <inner_symc_crypto>:
  a29ce4:	8168                	push	{ra,s0-s4},-48
  a29ce6:	03014803          	lbu	a6,48(sp)
  a29cea:	104618bb          	bnei	a2,16,a29e0c <inner_symc_crypto+0x128>
  a29cee:	01620737          	lui	a4,0x1620
  a29cf2:	00080463          	beqz	a6,a29cfa <inner_symc_crypto+0x16>
  a29cf6:	11620737          	lui	a4,0x11620
  a29cfa:	1ff57513          	andi	a0,a0,511
  a29cfe:	e0077713          	andi	a4,a4,-512
  a29d02:	8f49                	or	a4,a4,a0
  a29d04:	441044b7          	lui	s1,0x44104
  a29d08:	8946                	mv	s2,a7
  a29d0a:	8a3e                	mv	s4,a5
  a29d0c:	842e                	mv	s0,a1
  a29d0e:	10e4a823          	sw	a4,272(s1) # 44104110 <_gp_+0x436cf8cc>
  a29d12:	0ff0000f          	fence
  a29d16:	1004a223          	sw	zero,260(s1)
  a29d1a:	0ff0000f          	fence
  a29d1e:	00a0 55ac 099f      	l.li	s3,0xa055ac
  a29d24:	0009a703          	lw	a4,0(s3)
  a29d28:	00a0 554c 051f      	l.li	a0,0xa0554c
  a29d2e:	0716                	slli	a4,a4,0x5
  a29d30:	00e50633          	add	a2,a0,a4
  a29d34:	420c                	lw	a1,0(a2)
  a29d36:	0741                	addi	a4,a4,16 # 11620010 <_gp_+0x10beb7cc>
  a29d38:	01162223          	sw	a7,4(a2)
  a29d3c:	0035e593          	ori	a1,a1,3
  a29d40:	dff5f593          	andi	a1,a1,-513
  a29d44:	c20c                	sw	a1,0(a2)
  a29d46:	c614                	sw	a3,8(a2)
  a29d48:	00062623          	sw	zero,12(a2)
  a29d4c:	46c1                	li	a3,16
  a29d4e:	8622                	mv	a2,s0
  a29d50:	45c1                	li	a1,16
  a29d52:	953a                	add	a0,a0,a4
  a29d54:	57b060ef          	jal	ra,a30ace <memcpy_s>
  a29d58:	0009a703          	lw	a4,0(s3)
  a29d5c:	00a0 558c 069f      	l.li	a3,0xa0558c
  a29d62:	08e6869b          	addshf	a3,a3,a4,sll,4
  a29d66:	0705                	addi	a4,a4,1
  a29d68:	8b05                	andi	a4,a4,1
  a29d6a:	00e9a023          	sw	a4,0(s3)
  a29d6e:	0126a223          	sw	s2,4(a3)
  a29d72:	0146a423          	sw	s4,8(a3)
  a29d76:	0006a623          	sw	zero,12(a3)
  a29d7a:	4410d6b7          	lui	a3,0x4410d
  a29d7e:	5a9c                	lw	a5,48(a3)
  a29d80:	00178713          	addi	a4,a5,1 # ff0001 <_gp_+0x5bb7bd>
  a29d84:	8b05                	andi	a4,a4,1
  a29d86:	f007f793          	andi	a5,a5,-256
  a29d8a:	8fd9                	or	a5,a5,a4
  a29d8c:	da9c                	sw	a5,48(a3)
  a29d8e:	0ff0000f          	fence
  a29d92:	1304a783          	lw	a5,304(s1)
  a29d96:	00178713          	addi	a4,a5,1
  a29d9a:	8b05                	andi	a4,a4,1
  a29d9c:	f007f793          	andi	a5,a5,-256
  a29da0:	8fd9                	or	a5,a5,a4
  a29da2:	12f4a823          	sw	a5,304(s1)
  a29da6:	0ff0000f          	fence
  a29daa:	0000 2710 049f      	l.li	s1,0x2710
  a29db0:	4410c937          	lui	s2,0x4410c
  a29db4:	79c1                	lui	s3,0xffff0
  a29db6:	00092783          	lw	a5,0(s2) # 4410c000 <_gp_+0x436d77bc>
  a29dba:	0027f713          	andi	a4,a5,2
  a29dbe:	0137f7b3          	and	a5,a5,s3
  a29dc2:	8fd9                	or	a5,a5,a4
  a29dc4:	cf0d                	beqz	a4,a29dfe <inner_symc_crypto+0x11a>
  a29dc6:	00f92023          	sw	a5,0(s2)
  a29dca:	0ff0000f          	fence
  a29dce:	441097b7          	lui	a5,0x44109
  a29dd2:	0807a703          	lw	a4,128(a5) # 44109080 <_gp_+0x436d483c>
  a29dd6:	46c1                	li	a3,16
  a29dd8:	860a                	mv	a2,sp
  a29dda:	c03a                	sw	a4,0(sp)
  a29ddc:	0847a703          	lw	a4,132(a5)
  a29de0:	45c1                	li	a1,16
  a29de2:	8522                	mv	a0,s0
  a29de4:	c23a                	sw	a4,4(sp)
  a29de6:	0887a703          	lw	a4,136(a5)
  a29dea:	c43a                	sw	a4,8(sp)
  a29dec:	08c7a783          	lw	a5,140(a5)
  a29df0:	c63e                	sw	a5,12(sp)
  a29df2:	4dd060ef          	jal	ra,a30ace <memcpy_s>
  a29df6:	cd01                	beqz	a0,a29e0e <inner_symc_crypto+0x12a>
  a29df8:	04000513          	li	a0,64
  a29dfc:	a809                	j	a29e0e <inner_symc_crypto+0x12a>
  a29dfe:	4505                	li	a0,1
  a29e00:	14fd                	addi	s1,s1,-1
  a29e02:	236d                	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a29e04:	f8cd                	bnez	s1,a29db6 <inner_symc_crypto+0xd2>
  a29e06:	0b400513          	li	a0,180
  a29e0a:	a011                	j	a29e0e <inner_symc_crypto+0x12a>
  a29e0c:	557d                	li	a0,-1
  a29e0e:	8164                	popret	{ra,s0-s4},48

00a29e10 <drv_rom_cipher_symc_init>:
  a29e10:	441007b7          	lui	a5,0x44100
  a29e14:	4741                	li	a4,16
  a29e16:	d398                	sw	a4,32(a5)
  a29e18:	0ff0000f          	fence
  a29e1c:	441047b7          	lui	a5,0x44104
  a29e20:	00a0 554c 071f      	l.li	a4,0xa0554c
  a29e26:	12e7a223          	sw	a4,292(a5) # 44104124 <_gp_+0x436cf8e0>
  a29e2a:	0ff0000f          	fence
  a29e2e:	4689                	li	a3,2
  a29e30:	12d7a623          	sw	a3,300(a5)
  a29e34:	0ff0000f          	fence
  a29e38:	4410d737          	lui	a4,0x4410d
  a29e3c:	00a0 558c 061f      	l.li	a2,0xa0558c
  a29e42:	d350                	sw	a2,36(a4)
  a29e44:	0ff0000f          	fence
  a29e48:	d714                	sw	a3,40(a4)
  a29e4a:	0ff0000f          	fence
  a29e4e:	8000 aa00 071f      	l.li	a4,0x8000aa00
  a29e54:	10e7a023          	sw	a4,256(a5)
  a29e58:	0ff0000f          	fence
  a29e5c:	4501                	li	a0,0
  a29e5e:	8082                	ret

00a29e60 <drv_rom_cipher_symc_deinit>:
  a29e60:	441007b7          	lui	a5,0x44100
  a29e64:	0207a023          	sw	zero,32(a5) # 44100020 <_gp_+0x436cb7dc>
  a29e68:	0ff0000f          	fence
  a29e6c:	4501                	li	a0,0
  a29e6e:	8082                	ret

00a29e70 <drv_rom_cipher_symc_decrypt>:
  a29e70:	8118                	push	{ra},-32
  a29e72:	4305                	li	t1,1
  a29e74:	c01a                	sw	t1,0(sp)
  a29e76:	35bd                	jal	ra,a29ce4 <inner_symc_crypto>
  a29e78:	8114                	popret	{ra},32

00a29e7a <crypto_get_cpu_type>:
  a29e7a:	00a0 55b0 079f      	l.li	a5,0xa055b0
  a29e80:	01c7a303          	lw	t1,28(a5)
  a29e84:	00030363          	beqz	t1,a29e8a <crypto_get_cpu_type+0x10>
  a29e88:	8302                	jr	t1
  a29e8a:	4505                	li	a0,1
  a29e8c:	8082                	ret

00a29e8e <crypto_sm_support>:
  a29e8e:	4505                	li	a0,1
  a29e90:	8082                	ret

00a29e92 <crypto_get_value_by_index>:
  a29e92:	57fd                	li	a5,-1
  a29e94:	c105                	beqz	a0,a29eb4 <crypto_get_value_by_index+0x22>
  a29e96:	ce99                	beqz	a3,a29eb4 <crypto_get_value_by_index+0x22>
  a29e98:	4781                	li	a5,0
  a29e9a:	00b79463          	bne	a5,a1,a29ea2 <crypto_get_value_by_index+0x10>
  a29e9e:	57fd                	li	a5,-1
  a29ea0:	a811                	j	a29eb4 <crypto_get_value_by_index+0x22>
  a29ea2:	872a                	mv	a4,a0
  a29ea4:	0521                	addi	a0,a0,8
  a29ea6:	ff852803          	lw	a6,-8(a0)
  a29eaa:	00c81763          	bne	a6,a2,a29eb8 <crypto_get_value_by_index+0x26>
  a29eae:	435c                	lw	a5,4(a4)
  a29eb0:	c29c                	sw	a5,0(a3)
  a29eb2:	4781                	li	a5,0
  a29eb4:	853e                	mv	a0,a5
  a29eb6:	8082                	ret
  a29eb8:	0785                	addi	a5,a5,1
  a29eba:	b7c5                	j	a29e9a <crypto_get_value_by_index+0x8>

00a29ebc <drv_keyslot_create>:
  a29ebc:	8158                	push	{ra,s0-s3},-48
  a29ebe:	57fd                	li	a5,-1
  a29ec0:	c63e                	sw	a5,12(sp)
  a29ec2:	e119                	bnez	a0,a29ec8 <drv_keyslot_create+0xc>
  a29ec4:	557d                	li	a0,-1
  a29ec6:	8154                	popret	{ra,s0-s3},48
  a29ec8:	0205933b          	bnei	a1,2,a29ed4 <drv_keyslot_create+0x18>
  a29ecc:	00052023          	sw	zero,0(a0)
  a29ed0:	4501                	li	a0,0
  a29ed2:	bfd5                	j	a29ec6 <drv_keyslot_create+0xa>
  a29ed4:	c195                	beqz	a1,a29ef8 <drv_keyslot_create+0x3c>
  a29ed6:	01f59bbb          	bnei	a1,1,a29ec4 <drv_keyslot_create+0x8>
  a29eda:	4989                	li	s3,2
  a29edc:	842e                	mv	s0,a1
  a29ede:	892a                	mv	s2,a0
  a29ee0:	4481                	li	s1,0
  a29ee2:	85a2                	mv	a1,s0
  a29ee4:	8526                	mv	a0,s1
  a29ee6:	13a010ef          	jal	ra,a2b020 <hal_keyslot_lock>
  a29eea:	c62a                	sw	a0,12(sp)
  a29eec:	47b2                	lw	a5,12(sp)
  a29eee:	c799                	beqz	a5,a29efc <drv_keyslot_create+0x40>
  a29ef0:	0485                	addi	s1,s1,1
  a29ef2:	fe9998e3          	bne	s3,s1,a29ee2 <drv_keyslot_create+0x26>
  a29ef6:	b7f9                	j	a29ec4 <drv_keyslot_create+0x8>
  a29ef8:	49a1                	li	s3,8
  a29efa:	b7cd                	j	a29edc <drv_keyslot_create+0x20>
  a29efc:	fd34f4e3          	bgeu	s1,s3,a29ec4 <drv_keyslot_create+0x8>
  a29f00:	550005b7          	lui	a1,0x55000
  a29f04:	2085a59b          	orshf	a1,a1,s0,sll,16
  a29f08:	8ccd                	or	s1,s1,a1
  a29f0a:	00992023          	sw	s1,0(s2)
  a29f0e:	4532                	lw	a0,12(sp)
  a29f10:	bf5d                	j	a29ec6 <drv_keyslot_create+0xa>

00a29f12 <drv_keyslot_destroy>:
  a29f12:	c515                	beqz	a0,a29f3e <drv_keyslot_destroy+0x2c>
  a29f14:	01855793          	srli	a5,a0,0x18
  a29f18:	550797bb          	bnei	a5,85,a29f36 <drv_keyslot_destroy+0x24>
  a29f1c:	01055793          	srli	a5,a0,0x10
  a29f20:	0ff7f793          	andi	a5,a5,255
  a29f24:	4705                	li	a4,1
  a29f26:	00f76863          	bltu	a4,a5,a29f36 <drv_keyslot_destroy+0x24>
  a29f2a:	01051693          	slli	a3,a0,0x10
  a29f2e:	82c1                	srli	a3,a3,0x10
  a29f30:	e789                	bnez	a5,a29f3a <drv_keyslot_destroy+0x28>
  a29f32:	0806e33b          	bltui	a3,8,a29f3e <drv_keyslot_destroy+0x2c>
  a29f36:	557d                	li	a0,-1
  a29f38:	8082                	ret
  a29f3a:	fed76ee3          	bltu	a4,a3,a29f36 <drv_keyslot_destroy+0x24>
  a29f3e:	01055593          	srli	a1,a0,0x10
  a29f42:	9d81                	uxtb	a1
  a29f44:	9d21                	uxth	a0
  a29f46:	1760106f          	j	a2b0bc <hal_keyslot_unlock>

00a29f4a <drv_klad_create>:
  a29f4a:	e119                	bnez	a0,a29f50 <drv_klad_create+0x6>
  a29f4c:	557d                	li	a0,-1
  a29f4e:	8082                	ret
  a29f50:	8038                	push	{ra,s0-s1},-16
  a29f52:	842a                	mv	s0,a0
  a29f54:	00a05537          	lui	a0,0xa05
  a29f58:	5d450493          	addi	s1,a0,1492 # a055d4 <g_klad_ctx>
  a29f5c:	02400693          	li	a3,36
  a29f60:	4601                	li	a2,0
  a29f62:	02400593          	li	a1,36
  a29f66:	5d450513          	addi	a0,a0,1492
  a29f6a:	3e1060ef          	jal	ra,a30b4a <memset_s>
  a29f6e:	4785                	li	a5,1
  a29f70:	02f48023          	sb	a5,32(s1)
  a29f74:	2d3c 4b5a 079f      	l.li	a5,0x2d3c4b5a
  a29f7a:	c01c                	sw	a5,0(s0)
  a29f7c:	4501                	li	a0,0
  a29f7e:	8034                	popret	{ra,s0-s1},16

00a29f80 <drv_klad_destroy>:
  a29f80:	8028                	push	{ra,s0},-16
  a29f82:	2d3c 4b5a 079f      	l.li	a5,0x2d3c4b5a
  a29f88:	547d                	li	s0,-1
  a29f8a:	02f51363          	bne	a0,a5,a29fb0 <drv_klad_destroy+0x30>
  a29f8e:	00a05537          	lui	a0,0xa05
  a29f92:	5d450793          	addi	a5,a0,1492 # a055d4 <g_klad_ctx>
  a29f96:	0207c783          	lbu	a5,32(a5)
  a29f9a:	4401                	li	s0,0
  a29f9c:	cb91                	beqz	a5,a29fb0 <drv_klad_destroy+0x30>
  a29f9e:	02400693          	li	a3,36
  a29fa2:	4601                	li	a2,0
  a29fa4:	02400593          	li	a1,36
  a29fa8:	5d450513          	addi	a0,a0,1492
  a29fac:	39f060ef          	jal	ra,a30b4a <memset_s>
  a29fb0:	8522                	mv	a0,s0
  a29fb2:	8024                	popret	{ra,s0},16

00a29fb4 <drv_klad_attach>:
  a29fb4:	8148                	push	{ra,s0-s2},-32
  a29fb6:	57fd                	li	a5,-1
  a29fb8:	c63e                	sw	a5,12(sp)
  a29fba:	2d3c 4b5a 079f      	l.li	a5,0x2d3c4b5a
  a29fc0:	04f51963          	bne	a0,a5,a2a012 <drv_klad_attach+0x5e>
  a29fc4:	00a05437          	lui	s0,0xa05
  a29fc8:	5d440793          	addi	a5,s0,1492 # a055d4 <g_klad_ctx>
  a29fcc:	0207c783          	lbu	a5,32(a5)
  a29fd0:	5d440413          	addi	s0,s0,1492
  a29fd4:	557d                	li	a0,-1
  a29fd6:	c385                	beqz	a5,a29ff6 <drv_klad_attach+0x42>
  a29fd8:	84ae                	mv	s1,a1
  a29fda:	8932                	mv	s2,a2
  a29fdc:	0ff67593          	andi	a1,a2,255
  a29fe0:	0204863b          	beqi	s1,2,a29ff8 <drv_klad_attach+0x44>
  a29fe4:	85b2                	mv	a1,a2
  a29fe6:	8526                	mv	a0,s1
  a29fe8:	382010ef          	jal	ra,a2b36a <hal_klad_set_key_addr>
  a29fec:	c62a                	sw	a0,12(sp)
  a29fee:	47b2                	lw	a5,12(sp)
  a29ff0:	458d                	li	a1,3
  a29ff2:	c399                	beqz	a5,a29ff8 <drv_klad_attach+0x44>
  a29ff4:	4532                	lw	a0,12(sp)
  a29ff6:	8144                	popret	{ra,s0-s2},32
  a29ff8:	8526                	mv	a0,s1
  a29ffa:	2e6010ef          	jal	ra,a2b2e0 <hal_klad_set_key_dest_cfg>
  a29ffe:	c62a                	sw	a0,12(sp)
  a2a000:	47b2                	lw	a5,12(sp)
  a2a002:	fbed                	bnez	a5,a29ff4 <drv_klad_attach+0x40>
  a2a004:	4785                	li	a5,1
  a2a006:	01242e23          	sw	s2,28(s0)
  a2a00a:	a044                	sb	s1,4(s0)
  a2a00c:	02f400a3          	sb	a5,33(s0)
  a2a010:	b7d5                	j	a29ff4 <drv_klad_attach+0x40>
  a2a012:	557d                	li	a0,-1
  a2a014:	b7cd                	j	a29ff6 <drv_klad_attach+0x42>

00a2a016 <drv_klad_detach>:
  a2a016:	2d3c 4b5a 079f      	l.li	a5,0x2d3c4b5a
  a2a01c:	02f51a63          	bne	a0,a5,a2a050 <drv_klad_detach+0x3a>
  a2a020:	00a0 55d4 079f      	l.li	a5,0xa055d4
  a2a026:	0207c703          	lbu	a4,32(a5)
  a2a02a:	557d                	li	a0,-1
  a2a02c:	c31d                	beqz	a4,a2a052 <drv_klad_detach+0x3c>
  a2a02e:	23d8                	lbu	a4,4(a5)
  a2a030:	02b71163          	bne	a4,a1,a2a052 <drv_klad_detach+0x3c>
  a2a034:	4fd8                	lw	a4,28(a5)
  a2a036:	00c71e63          	bne	a4,a2,a2a052 <drv_klad_detach+0x3c>
  a2a03a:	0217c703          	lbu	a4,33(a5)
  a2a03e:	4501                	li	a0,0
  a2a040:	cb09                	beqz	a4,a2a052 <drv_klad_detach+0x3c>
  a2a042:	020780a3          	sb	zero,33(a5)
  a2a046:	0007ae23          	sw	zero,28(a5)
  a2a04a:	00078223          	sb	zero,4(a5)
  a2a04e:	8082                	ret
  a2a050:	557d                	li	a0,-1
  a2a052:	8082                	ret

00a2a054 <drv_klad_set_attr>:
  a2a054:	8138                	push	{ra,s0-s1},-32
  a2a056:	57fd                	li	a5,-1
  a2a058:	c63e                	sw	a5,12(sp)
  a2a05a:	e199                	bnez	a1,a2a060 <drv_klad_set_attr+0xc>
  a2a05c:	557d                	li	a0,-1
  a2a05e:	8134                	popret	{ra,s0-s1},32
  a2a060:	2d3c 4b5a 079f      	l.li	a5,0x2d3c4b5a
  a2a066:	fef51be3          	bne	a0,a5,a2a05c <drv_klad_set_attr+0x8>
  a2a06a:	00a0 55d4 049f      	l.li	s1,0xa055d4
  a2a070:	0204c783          	lbu	a5,32(s1)
  a2a074:	d7e5                	beqz	a5,a2a05c <drv_klad_set_attr+0x8>
  a2a076:	862e                	mv	a2,a1
  a2a078:	842e                	mv	s0,a1
  a2a07a:	46d1                	li	a3,20
  a2a07c:	45d1                	li	a1,20
  a2a07e:	00848513          	addi	a0,s1,8
  a2a082:	24d060ef          	jal	ra,a30ace <memcpy_s>
  a2a086:	c62a                	sw	a0,12(sp)
  a2a088:	47b2                	lw	a5,12(sp)
  a2a08a:	fbe9                	bnez	a5,a2a05c <drv_klad_set_attr+0x8>
  a2a08c:	2050                	lbu	a2,4(s0)
  a2a08e:	304c                	lbu	a1,5(s0)
  a2a090:	2068                	lbu	a0,6(s0)
  a2a092:	1e4010ef          	jal	ra,a2b276 <hal_klad_set_key_crypto_cfg>
  a2a096:	c62a                	sw	a0,12(sp)
  a2a098:	47b2                	lw	a5,12(sp)
  a2a09a:	c399                	beqz	a5,a2a0a0 <drv_klad_set_attr+0x4c>
  a2a09c:	4532                	lw	a0,12(sp)
  a2a09e:	b7c1                	j	a2a05e <drv_klad_set_attr+0xa>
  a2a0a0:	00740513          	addi	a0,s0,7
  a2a0a4:	274010ef          	jal	ra,a2b318 <hal_klad_set_key_secure_cfg>
  a2a0a8:	c62a                	sw	a0,12(sp)
  a2a0aa:	47b2                	lw	a5,12(sp)
  a2a0ac:	fbe5                	bnez	a5,a2a09c <drv_klad_set_attr+0x48>
  a2a0ae:	401c                	lw	a5,0(s0)
  a2a0b0:	c09c                	sw	a5,0(s1)
  a2a0b2:	4785                	li	a5,1
  a2a0b4:	02f48123          	sb	a5,34(s1)
  a2a0b8:	b7d5                	j	a2a09c <drv_klad_set_attr+0x48>

00a2a0ba <drv_klad_set_effective_key>:
  a2a0ba:	8238                	push	{ra,s0-s1},-48
  a2a0bc:	57fd                	li	a5,-1
  a2a0be:	c43e                	sw	a5,8(sp)
  a2a0c0:	c602                	sw	zero,12(sp)
  a2a0c2:	c802                	sw	zero,16(sp)
  a2a0c4:	ca02                	sw	zero,20(sp)
  a2a0c6:	cc02                	sw	zero,24(sp)
  a2a0c8:	ce02                	sw	zero,28(sp)
  a2a0ca:	e199                	bnez	a1,a2a0d0 <drv_klad_set_effective_key+0x16>
  a2a0cc:	557d                	li	a0,-1
  a2a0ce:	a895                	j	a2a142 <drv_klad_set_effective_key+0x88>
  a2a0d0:	41dc                	lw	a5,4(a1)
  a2a0d2:	dfed                	beqz	a5,a2a0cc <drv_klad_set_effective_key+0x12>
  a2a0d4:	219c                	lbu	a5,0(a1)
  a2a0d6:	842e                	mv	s0,a1
  a2a0d8:	84aa                	mv	s1,a0
  a2a0da:	01078e3b          	beqi	a5,1,a2a112 <drv_klad_set_effective_key+0x58>
  a2a0de:	2d3c 4b5a 079f      	l.li	a5,0x2d3c4b5a
  a2a0e4:	fef494e3          	bne	s1,a5,a2a0cc <drv_klad_set_effective_key+0x12>
  a2a0e8:	00a054b7          	lui	s1,0xa05
  a2a0ec:	5d448793          	addi	a5,s1,1492 # a055d4 <g_klad_ctx>
  a2a0f0:	0207c703          	lbu	a4,32(a5)
  a2a0f4:	5d448493          	addi	s1,s1,1492
  a2a0f8:	db71                	beqz	a4,a2a0cc <drv_klad_set_effective_key+0x12>
  a2a0fa:	0227c783          	lbu	a5,34(a5)
  a2a0fe:	d7f9                	beqz	a5,a2a0cc <drv_klad_set_effective_key+0x12>
  a2a100:	203c                	lbu	a5,2(s0)
  a2a102:	010782bb          	beqi	a5,1,a2a10c <drv_klad_set_effective_key+0x52>
  a2a106:	cb91                	beqz	a5,a2a11a <drv_klad_set_effective_key+0x60>
  a2a108:	02f7913b          	bnei	a5,2,a2a0cc <drv_klad_set_effective_key+0x12>
  a2a10c:	00f108a3          	sb	a5,17(sp)
  a2a110:	a039                	j	a2a11e <drv_klad_set_effective_key+0x64>
  a2a112:	4505                	li	a0,1
  a2a114:	3bad                	jal	ra,a29e8e <crypto_sm_support>
  a2a116:	f561                	bnez	a0,a2a0de <drv_klad_set_effective_key+0x24>
  a2a118:	bf55                	j	a2a0cc <drv_klad_set_effective_key+0x12>
  a2a11a:	000108a3          	sb	zero,17(sp)
  a2a11e:	409c                	lw	a5,0(s1)
  a2a120:	c63e                	sw	a5,12(sp)
  a2a122:	201c                	lbu	a5,0(s0)
  a2a124:	00f10823          	sb	a5,16(sp)
  a2a128:	405c                	lw	a5,4(s0)
  a2a12a:	ca3e                	sw	a5,20(sp)
  a2a12c:	441c                	lw	a5,8(s0)
  a2a12e:	cc3e                	sw	a5,24(sp)
  a2a130:	245c                	lbu	a5,12(s0)
  a2a132:	00f10e23          	sb	a5,28(sp)
  a2a136:	0aa010ef          	jal	ra,a2b1e0 <hal_klad_lock>
  a2a13a:	c42a                	sw	a0,8(sp)
  a2a13c:	47a2                	lw	a5,8(sp)
  a2a13e:	c399                	beqz	a5,a2a144 <drv_klad_set_effective_key+0x8a>
  a2a140:	4522                	lw	a0,8(sp)
  a2a142:	8234                	popret	{ra,s0-s1},48
  a2a144:	4d5000ef          	jal	ra,a2ae18 <hal_rkp_lock>
  a2a148:	c42a                	sw	a0,8(sp)
  a2a14a:	47a2                	lw	a5,8(sp)
  a2a14c:	e385                	bnez	a5,a2a16c <drv_klad_set_effective_key+0xb2>
  a2a14e:	0068                	addi	a0,sp,12
  a2a150:	55b000ef          	jal	ra,a2aeaa <hal_rkp_kdf_hard_calculation>
  a2a154:	c42a                	sw	a0,8(sp)
  a2a156:	47a2                	lw	a5,8(sp)
  a2a158:	eb81                	bnez	a5,a2a168 <drv_klad_set_effective_key+0xae>
  a2a15a:	20d0                	lbu	a2,4(s1)
  a2a15c:	4532                	lw	a0,12(sp)
  a2a15e:	85a2                	mv	a1,s0
  a2a160:	23c010ef          	jal	ra,a2b39c <hal_klad_start_com_route>
  a2a164:	c42a                	sw	a0,8(sp)
  a2a166:	47a2                	lw	a5,8(sp)
  a2a168:	4f3000ef          	jal	ra,a2ae5a <hal_rkp_unlock>
  a2a16c:	0ce010ef          	jal	ra,a2b23a <hal_klad_unlock>
  a2a170:	bfc1                	j	a2a140 <drv_klad_set_effective_key+0x86>

00a2a172 <drv_fapc_set_iv>:
  a2a172:	8118                	push	{ra},-32
  a2a174:	57fd                	li	a5,-1
  a2a176:	c63e                	sw	a5,12(sp)
  a2a178:	376010ef          	jal	ra,a2b4ee <hal_fapc_set_region_iv>
  a2a17c:	c62a                	sw	a0,12(sp)
  a2a17e:	4532                	lw	a0,12(sp)
  a2a180:	8114                	popret	{ra},32

00a2a182 <drv_fapc_set_config>:
  a2a182:	8148                	push	{ra,s0-s2},-32
  a2a184:	57fd                	li	a5,-1
  a2a186:	c63e                	sw	a5,12(sp)
  a2a188:	0015b793          	seqz	a5,a1
  a2a18c:	40f007b3          	neg	a5,a5
  a2a190:	c63e                	sw	a5,12(sp)
  a2a192:	47b2                	lw	a5,12(sp)
  a2a194:	c399                	beqz	a5,a2a19a <drv_fapc_set_config+0x18>
  a2a196:	4532                	lw	a0,12(sp)
  a2a198:	8144                	popret	{ra,s0-s2},32
  a2a19a:	4d84                	lw	s1,24(a1)
  a2a19c:	41d0                	lw	a2,4(a1)
  a2a19e:	842e                	mv	s0,a1
  a2a1a0:	418c                	lw	a1,0(a1)
  a2a1a2:	892a                	mv	s2,a0
  a2a1a4:	2be010ef          	jal	ra,a2b462 <hal_fapc_set_region_addr>
  a2a1a8:	c62a                	sw	a0,12(sp)
  a2a1aa:	47b2                	lw	a5,12(sp)
  a2a1ac:	f7ed                	bnez	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1ae:	4850                	lw	a2,20(s0)
  a2a1b0:	480c                	lw	a1,16(s0)
  a2a1b2:	854a                	mv	a0,s2
  a2a1b4:	2d0010ef          	jal	ra,a2b484 <hal_fapc_set_region_permission>
  a2a1b8:	c62a                	sw	a0,12(sp)
  a2a1ba:	47b2                	lw	a5,12(sp)
  a2a1bc:	ffe9                	bnez	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1be:	030494bb          	bnei	s1,3,a2a1d0 <drv_fapc_set_config+0x4e>
  a2a1c2:	440c                	lw	a1,8(s0)
  a2a1c4:	854a                	mv	a0,s2
  a2a1c6:	2c2010ef          	jal	ra,a2b488 <hal_fapc_set_region_mac_addr>
  a2a1ca:	c62a                	sw	a0,12(sp)
  a2a1cc:	47b2                	lw	a5,12(sp)
  a2a1ce:	f7e1                	bnez	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1d0:	85a6                	mv	a1,s1
  a2a1d2:	854a                	mv	a0,s2
  a2a1d4:	2b8010ef          	jal	ra,a2b48c <hal_fapc_set_region_mode>
  a2a1d8:	c62a                	sw	a0,12(sp)
  a2a1da:	47b2                	lw	a5,12(sp)
  a2a1dc:	ffcd                	bnez	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1de:	2c4c                	lbu	a1,28(s0)
  a2a1e0:	854a                	mv	a0,s2
  a2a1e2:	2e4010ef          	jal	ra,a2b4c6 <hal_fapc_region_enable>
  a2a1e6:	c62a                	sw	a0,12(sp)
  a2a1e8:	47b2                	lw	a5,12(sp)
  a2a1ea:	f7d5                	bnez	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1ec:	444c                	lw	a1,12(s0)
  a2a1ee:	854a                	mv	a0,s2
  a2a1f0:	346010ef          	jal	ra,a2b536 <hal_fapc_set_region_iv_start_addr>
  a2a1f4:	c62a                	sw	a0,12(sp)
  a2a1f6:	47b2                	lw	a5,12(sp)
  a2a1f8:	ffd9                	bnez	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1fa:	3c5c                	lbu	a5,29(s0)
  a2a1fc:	dfc9                	beqz	a5,a2a196 <drv_fapc_set_config+0x14>
  a2a1fe:	854a                	mv	a0,s2
  a2a200:	2ca010ef          	jal	ra,a2b4ca <hal_fapc_region_lock>
  a2a204:	c62a                	sw	a0,12(sp)
  a2a206:	47b2                	lw	a5,12(sp)
  a2a208:	b779                	j	a2a196 <drv_fapc_set_config+0x14>

00a2a20a <drv_fapc_set_bypass_config>:
  a2a20a:	8228                	push	{ra,s0},-48
  a2a20c:	57fd                	li	a5,-1
  a2a20e:	c636                	sw	a3,12(sp)
  a2a210:	ce3e                	sw	a5,28(sp)
  a2a212:	842a                	mv	s0,a0
  a2a214:	24e010ef          	jal	ra,a2b462 <hal_fapc_set_region_addr>
  a2a218:	ce2a                	sw	a0,28(sp)
  a2a21a:	47f2                	lw	a5,28(sp)
  a2a21c:	46b2                	lw	a3,12(sp)
  a2a21e:	c399                	beqz	a5,a2a224 <drv_fapc_set_bypass_config+0x1a>
  a2a220:	4572                	lw	a0,28(sp)
  a2a222:	8224                	popret	{ra,s0},48
  a2a224:	def5                	beqz	a3,a2a220 <drv_fapc_set_bypass_config+0x16>
  a2a226:	8522                	mv	a0,s0
  a2a228:	2a2010ef          	jal	ra,a2b4ca <hal_fapc_region_lock>
  a2a22c:	ce2a                	sw	a0,28(sp)
  a2a22e:	47f2                	lw	a5,28(sp)
  a2a230:	bfc5                	j	a2a220 <drv_fapc_set_bypass_config+0x16>

00a2a232 <hal_hash_lock>:
  a2a232:	0010 2fd4 031f      	l.li	t1,0x102fd4
  a2a238:	8302                	jr	t1

00a2a23a <hal_hash_unlock>:
  a2a23a:	0010 2d8a 031f      	l.li	t1,0x102d8a
  a2a240:	8302                	jr	t1

00a2a242 <hal_cipher_hash_config>:
  a2a242:	0010 2daa 031f      	l.li	t1,0x102daa
  a2a248:	8302                	jr	t1

00a2a24a <hal_cipher_hash_add_in_node>:
  a2a24a:	0010 2eb4 031f      	l.li	t1,0x102eb4
  a2a250:	8302                	jr	t1

00a2a252 <hal_cipher_hash_start>:
  a2a252:	0010 2f28 031f      	l.li	t1,0x102f28
  a2a258:	8302                	jr	t1

00a2a25a <hal_cipher_hash_wait_done>:
  a2a25a:	0010 30fc 031f      	l.li	t1,0x1030fc
  a2a260:	8302                	jr	t1

00a2a262 <drv_rom_cipher_pke_bp256r_verify>:
  a2a262:	0010 262a 031f      	l.li	t1,0x10262a
  a2a268:	8302                	jr	t1

00a2a26a <drv_rom_cipher_sha256>:
  a2a26a:	8128                	push	{ra,s0},-32
  a2a26c:	842a                	mv	s0,a0
  a2a26e:	4505                	li	a0,1
  a2a270:	c62e                	sw	a1,12(sp)
  a2a272:	c432                	sw	a2,8(sp)
  a2a274:	c236                	sw	a3,4(sp)
  a2a276:	3f75                	jal	ra,a2a232 <hal_hash_lock>
  a2a278:	4622                	lw	a2,8(sp)
  a2a27a:	45b2                	lw	a1,12(sp)
  a2a27c:	4712                	lw	a4,4(sp)
  a2a27e:	86b2                	mv	a3,a2
  a2a280:	4785                	li	a5,1
  a2a282:	862e                	mv	a2,a1
  a2a284:	0116 9100 051f      	l.li	a0,0x1169100
  a2a28a:	85a2                	mv	a1,s0
  a2a28c:	fe6ff0ef          	jal	ra,a29a72 <drv_rom_hash>
  a2a290:	842a                	mv	s0,a0
  a2a292:	4505                	li	a0,1
  a2a294:	375d                	jal	ra,a2a23a <hal_hash_unlock>
  a2a296:	8522                	mv	a0,s0
  a2a298:	8124                	popret	{ra,s0},32

00a2a29a <uapi_systick_get_count>:
  a2a29a:	8048                	push	{ra,s0-s2},-16
  a2a29c:	f50ff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a2a0:	00a0 55f8 079f      	l.li	a5,0xa055f8
  a2a2a6:	239c                	lbu	a5,0(a5)
  a2a2a8:	eb81                	bnez	a5,a2a2b8 <uapi_systick_get_count+0x1e>
  a2a2aa:	f4aff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a2ae:	4401                	li	s0,0
  a2a2b0:	4481                	li	s1,0
  a2a2b2:	8522                	mv	a0,s0
  a2a2b4:	85a6                	mv	a1,s1
  a2a2b6:	8044                	popret	{ra,s0-s2},16
  a2a2b8:	892a                	mv	s2,a0
  a2a2ba:	771010ef          	jal	ra,a2c22a <hal_systick_get_count>
  a2a2be:	842a                	mv	s0,a0
  a2a2c0:	854a                	mv	a0,s2
  a2a2c2:	84ae                	mv	s1,a1
  a2a2c4:	f30ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a2c8:	b7ed                	j	a2a2b2 <uapi_systick_get_count+0x18>

00a2a2ca <uapi_systick_get_us>:
  a2a2ca:	8128                	push	{ra,s0},-32
  a2a2cc:	37f9                	jal	ra,a2a29a <uapi_systick_get_count>
  a2a2ce:	842a                	mv	s0,a0
  a2a2d0:	c62e                	sw	a1,12(sp)
  a2a2d2:	769010ef          	jal	ra,a2c23a <systick_clock_get>
  a2a2d6:	45b2                	lw	a1,12(sp)
  a2a2d8:	000f 4240 079f      	l.li	a5,0xf4240
  a2a2de:	02f43733          	mulhu	a4,s0,a5
  a2a2e2:	862a                	mv	a2,a0
  a2a2e4:	4681                	li	a3,0
  a2a2e6:	02f585b3          	mul	a1,a1,a5
  a2a2ea:	02f40533          	mul	a0,s0,a5
  a2a2ee:	95ba                	add	a1,a1,a4
  a2a2f0:	aacfe0ef          	jal	ra,a2859c <__udivdi3>
  a2a2f4:	8124                	popret	{ra,s0},32

00a2a2f6 <uapi_tcxo_init>:
  a2a2f6:	8048                	push	{ra,s0-s2},-16
  a2a2f8:	ef4ff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a2fc:	00a0 55f9 091f      	l.li	s2,0xa055f9
  a2a302:	00094783          	lbu	a5,0(s2)
  a2a306:	c791                	beqz	a5,a2a312 <uapi_tcxo_init+0x1c>
  a2a308:	eecff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a30c:	4401                	li	s0,0
  a2a30e:	8522                	mv	a0,s0
  a2a310:	8044                	popret	{ra,s0-s2},16
  a2a312:	84aa                	mv	s1,a0
  a2a314:	23e010ef          	jal	ra,a2b552 <hal_tcxo_init>
  a2a318:	842a                	mv	s0,a0
  a2a31a:	c509                	beqz	a0,a2a324 <uapi_tcxo_init+0x2e>
  a2a31c:	8526                	mv	a0,s1
  a2a31e:	ed6ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a322:	b7f5                	j	a2a30e <uapi_tcxo_init+0x18>
  a2a324:	4785                	li	a5,1
  a2a326:	00f90023          	sb	a5,0(s2)
  a2a32a:	bfcd                	j	a2a31c <uapi_tcxo_init+0x26>

00a2a32c <uapi_tcxo_get_count>:
  a2a32c:	8048                	push	{ra,s0-s2},-16
  a2a32e:	ebeff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a332:	00a0 55f9 079f      	l.li	a5,0xa055f9
  a2a338:	239c                	lbu	a5,0(a5)
  a2a33a:	eb81                	bnez	a5,a2a34a <uapi_tcxo_get_count+0x1e>
  a2a33c:	eb8ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a340:	4401                	li	s0,0
  a2a342:	4481                	li	s1,0
  a2a344:	8522                	mv	a0,s0
  a2a346:	85a6                	mv	a1,s1
  a2a348:	8044                	popret	{ra,s0-s2},16
  a2a34a:	892a                	mv	s2,a0
  a2a34c:	232010ef          	jal	ra,a2b57e <hal_tcxo_get>
  a2a350:	842a                	mv	s0,a0
  a2a352:	854a                	mv	a0,s2
  a2a354:	84ae                	mv	s1,a1
  a2a356:	e9eff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a35a:	b7ed                	j	a2a344 <uapi_tcxo_get_count+0x18>

00a2a35c <uapi_tcxo_delay_ms>:
  a2a35c:	00a0 55f9 079f      	l.li	a5,0xa055f9
  a2a362:	239c                	lbu	a5,0(a5)
  a2a364:	c3b1                	beqz	a5,a2a3a8 <uapi_tcxo_delay_ms+0x4c>
  a2a366:	8048                	push	{ra,s0-s2},-16
  a2a368:	842a                	mv	s0,a0
  a2a36a:	6e3010ef          	jal	ra,a2c24c <tcxo_porting_ticks_per_usec_get>
  a2a36e:	3e800793          	li	a5,1000
  a2a372:	02f405b3          	mul	a1,s0,a5
  a2a376:	02f43433          	mulhu	s0,s0,a5
  a2a37a:	02a584b3          	mul	s1,a1,a0
  a2a37e:	02a40433          	mul	s0,s0,a0
  a2a382:	02a5b5b3          	mulhu	a1,a1,a0
  a2a386:	942e                	add	s0,s0,a1
  a2a388:	3755                	jal	ra,a2a32c <uapi_tcxo_get_count>
  a2a38a:	00a48933          	add	s2,s1,a0
  a2a38e:	009934b3          	sltu	s1,s2,s1
  a2a392:	95a2                	add	a1,a1,s0
  a2a394:	94ae                	add	s1,s1,a1
  a2a396:	3f59                	jal	ra,a2a32c <uapi_tcxo_get_count>
  a2a398:	fe95efe3          	bltu	a1,s1,a2a396 <uapi_tcxo_delay_ms+0x3a>
  a2a39c:	00b49463          	bne	s1,a1,a2a3a4 <uapi_tcxo_delay_ms+0x48>
  a2a3a0:	ff256be3          	bltu	a0,s2,a2a396 <uapi_tcxo_delay_ms+0x3a>
  a2a3a4:	4501                	li	a0,0
  a2a3a6:	8044                	popret	{ra,s0-s2},16
  a2a3a8:	557d                	li	a0,-1
  a2a3aa:	8082                	ret

00a2a3ac <uapi_tcxo_delay_us>:
  a2a3ac:	00a0 55f9 079f      	l.li	a5,0xa055f9
  a2a3b2:	239c                	lbu	a5,0(a5)
  a2a3b4:	cb8d                	beqz	a5,a2a3e6 <uapi_tcxo_delay_us+0x3a>
  a2a3b6:	8048                	push	{ra,s0-s2},-16
  a2a3b8:	842a                	mv	s0,a0
  a2a3ba:	693010ef          	jal	ra,a2c24c <tcxo_porting_ticks_per_usec_get>
  a2a3be:	02a404b3          	mul	s1,s0,a0
  a2a3c2:	02a43433          	mulhu	s0,s0,a0
  a2a3c6:	379d                	jal	ra,a2a32c <uapi_tcxo_get_count>
  a2a3c8:	00a48933          	add	s2,s1,a0
  a2a3cc:	009934b3          	sltu	s1,s2,s1
  a2a3d0:	942e                	add	s0,s0,a1
  a2a3d2:	9426                	add	s0,s0,s1
  a2a3d4:	3fa1                	jal	ra,a2a32c <uapi_tcxo_get_count>
  a2a3d6:	fe85efe3          	bltu	a1,s0,a2a3d4 <uapi_tcxo_delay_us+0x28>
  a2a3da:	00b41463          	bne	s0,a1,a2a3e2 <uapi_tcxo_delay_us+0x36>
  a2a3de:	ff256be3          	bltu	a0,s2,a2a3d4 <uapi_tcxo_delay_us+0x28>
  a2a3e2:	4501                	li	a0,0
  a2a3e4:	8044                	popret	{ra,s0-s2},16
  a2a3e6:	557d                	li	a0,-1
  a2a3e8:	8082                	ret

00a2a3ea <uart_rx_buffer_report>:
  a2a3ea:	8038                	push	{ra,s0-s1},-16
  a2a3ec:	00a05737          	lui	a4,0xa05
  a2a3f0:	60070793          	addi	a5,a4,1536 # a05600 <g_uart_rx_state_array>
  a2a3f4:	18a797db          	muliadd	a5,a5,a0,24
  a2a3f8:	4394                	lw	a3,0(a5)
  a2a3fa:	862e                	mv	a2,a1
  a2a3fc:	842a                	mv	s0,a0
  a2a3fe:	2bce                	lhu	a1,20(a5)
  a2a400:	60070493          	addi	s1,a4,1536
  a2a404:	c299                	beqz	a3,a2a40a <uart_rx_buffer_report+0x20>
  a2a406:	47c8                	lw	a0,12(a5)
  a2a408:	9682                	jalr	a3
  a2a40a:	1884945b          	muliadd	s0,s1,s0,24
  a2a40e:	00041a23          	sh	zero,20(s0)
  a2a412:	8034                	popret	{ra,s0-s1},16

00a2a414 <uapi_uart_param_check>:
  a2a414:	0305763b          	bgeui	a0,3,a2a42c <uapi_uart_param_check+0x18>
  a2a418:	c991                	beqz	a1,a2a42c <uapi_uart_param_check+0x18>
  a2a41a:	ca09                	beqz	a2,a2a42c <uapi_uart_param_check+0x18>
  a2a41c:	00a0 55fc 079f      	l.li	a5,0xa055fc
  a2a422:	953e                	add	a0,a0,a5
  a2a424:	211c                	lbu	a5,0(a0)
  a2a426:	c799                	beqz	a5,a2a434 <uapi_uart_param_check+0x20>
  a2a428:	4501                	li	a0,0
  a2a42a:	8082                	ret
  a2a42c:	80000537          	lui	a0,0x80000
  a2a430:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2a432:	8082                	ret
  a2a434:	8000 1040 051f      	l.li	a0,0x80001040
  a2a43a:	8082                	ret

00a2a43c <uart_helper_invoke_current_fragment_callback>:
  a2a43c:	00a0 5648 079f      	l.li	a5,0xa05648
  a2a442:	4ca7955b          	muliadd	a0,a5,a0,76
  a2a446:	411c                	lw	a5,0(a0)
  a2a448:	0087a303          	lw	t1,8(a5)
  a2a44c:	00030663          	beqz	t1,a2a458 <uart_helper_invoke_current_fragment_callback+0x1c>
  a2a450:	43d0                	lw	a2,4(a5)
  a2a452:	47cc                	lw	a1,12(a5)
  a2a454:	4388                	lw	a0,0(a5)
  a2a456:	8302                	jr	t1
  a2a458:	8082                	ret

00a2a45a <uart_helper_move_to_next_fragment>:
  a2a45a:	04c00793          	li	a5,76
  a2a45e:	02f507b3          	mul	a5,a0,a5
  a2a462:	00a056b7          	lui	a3,0xa05
  a2a466:	64868713          	addi	a4,a3,1608 # a05648 <g_uart_tx_state_array>
  a2a46a:	64868693          	addi	a3,a3,1608
  a2a46e:	00f705b3          	add	a1,a4,a5
  a2a472:	4190                	lw	a2,0(a1)
  a2a474:	07b1                	addi	a5,a5,12
  a2a476:	97ba                	add	a5,a5,a4
  a2a478:	0641                	addi	a2,a2,16
  a2a47a:	04078713          	addi	a4,a5,64
  a2a47e:	00e67b63          	bgeu	a2,a4,a2a494 <uart_helper_move_to_next_fragment+0x3a>
  a2a482:	c190                	sw	a2,0(a1)
  a2a484:	4ca6955b          	muliadd	a0,a3,a0,76
  a2a488:	251e                	lhu	a5,8(a0)
  a2a48a:	00051523          	sh	zero,10(a0)
  a2a48e:	17fd                	addi	a5,a5,-1
  a2a490:	a51e                	sh	a5,8(a0)
  a2a492:	8082                	ret
  a2a494:	c19c                	sw	a5,0(a1)
  a2a496:	b7fd                	j	a2a484 <uart_helper_move_to_next_fragment+0x2a>

00a2a498 <uart_helper_send_next_char>:
  a2a498:	8038                	push	{ra,s0-s1},-16
  a2a49a:	00a0 5648 041f      	l.li	s0,0xa05648
  a2a4a0:	4ca4145b          	muliadd	s0,s0,a0,76
  a2a4a4:	4004                	lw	s1,0(s0)
  a2a4a6:	243e                	lhu	a5,10(s0)
  a2a4a8:	4605                	li	a2,1
  a2a4aa:	408c                	lw	a1,0(s1)
  a2a4ac:	95be                	add	a1,a1,a5
  a2a4ae:	18a010ef          	jal	ra,a2b638 <hal_uart_write>
  a2a4b2:	242a                	lhu	a0,10(s0)
  a2a4b4:	0505                	addi	a0,a0,1
  a2a4b6:	9d21                	uxth	a0
  a2a4b8:	a42a                	sh	a0,10(s0)
  a2a4ba:	44dc                	lw	a5,12(s1)
  a2a4bc:	00f53533          	sltu	a0,a0,a5
  a2a4c0:	00154513          	xori	a0,a0,1
  a2a4c4:	8034                	popret	{ra,s0-s1},16

00a2a4c6 <uart_error_isr>:
  a2a4c6:	8148                	push	{ra,s0-s2},-32
  a2a4c8:	842a                	mv	s0,a0
  a2a4ca:	00f10613          	addi	a2,sp,15
  a2a4ce:	45a5                	li	a1,9
  a2a4d0:	00a0 5600 049f      	l.li	s1,0xa05600
  a2a4d6:	00010723          	sb	zero,14(sp)
  a2a4da:	000107a3          	sb	zero,15(sp)
  a2a4de:	1884995b          	muliadd	s2,s1,s0,24
  a2a4e2:	17a010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a4e6:	00f14783          	lbu	a5,15(sp)
  a2a4ea:	cb99                	beqz	a5,a2a500 <uart_error_isr+0x3a>
  a2a4ec:	188494db          	muliadd	s1,s1,s0,24
  a2a4f0:	28de                	lhu	a5,20(s1)
  a2a4f2:	c791                	beqz	a5,a2a4fe <uart_error_isr+0x38>
  a2a4f4:	409c                	lw	a5,0(s1)
  a2a4f6:	c781                	beqz	a5,a2a4fe <uart_error_isr+0x38>
  a2a4f8:	4585                	li	a1,1
  a2a4fa:	8522                	mv	a0,s0
  a2a4fc:	35fd                	jal	ra,a2a3ea <uart_rx_buffer_report>
  a2a4fe:	8144                	popret	{ra,s0-s2},32
  a2a500:	4605                	li	a2,1
  a2a502:	00e10593          	addi	a1,sp,14
  a2a506:	8522                	mv	a0,s0
  a2a508:	142010ef          	jal	ra,a2b64a <hal_uart_read>
  a2a50c:	01495683          	lhu	a3,20(s2)
  a2a510:	00c92783          	lw	a5,12(s2)
  a2a514:	00e14703          	lbu	a4,14(sp)
  a2a518:	97b6                	add	a5,a5,a3
  a2a51a:	a398                	sb	a4,0(a5)
  a2a51c:	01495783          	lhu	a5,20(s2)
  a2a520:	01095703          	lhu	a4,16(s2)
  a2a524:	0785                	addi	a5,a5,1
  a2a526:	9fa1                	uxth	a5
  a2a528:	00f91a23          	sh	a5,20(s2)
  a2a52c:	00e7e563          	bltu	a5,a4,a2a536 <uart_error_isr+0x70>
  a2a530:	4585                	li	a1,1
  a2a532:	8522                	mv	a0,s0
  a2a534:	3d5d                	jal	ra,a2a3ea <uart_rx_buffer_report>
  a2a536:	00f10613          	addi	a2,sp,15
  a2a53a:	45a5                	li	a1,9
  a2a53c:	8522                	mv	a0,s0
  a2a53e:	11e010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a542:	b755                	j	a2a4e6 <uart_error_isr+0x20>

00a2a544 <uart_evt_callback>:
  a2a544:	8158                	push	{ra,s0-s3},-48
  a2a546:	15fd                	addi	a1,a1,-1 # 54ffffff <_gp_+0x545cb7bb>
  a2a548:	0ff5f793          	andi	a5,a1,255
  a2a54c:	0567f3bb          	bgeui	a5,5,a2a6da <uart_evt_callback+0x196>
  a2a550:	00a325b7          	lui	a1,0xa32
  a2a554:	6fc58593          	addi	a1,a1,1788 # a326fc <g_sm3_ival+0x20>
  a2a558:	04f5859b          	addshf	a1,a1,a5,sll,2
  a2a55c:	419c                	lw	a5,0(a1)
  a2a55e:	842a                	mv	s0,a0
  a2a560:	8782                	jr	a5
  a2a562:	00a0 5648 049f      	l.li	s1,0xa05648
  a2a568:	000107a3          	sb	zero,15(sp)
  a2a56c:	4ca494db          	muliadd	s1,s1,a0,76
  a2a570:	249e                	lhu	a5,8(s1)
  a2a572:	eb81                	bnez	a5,a2a582 <uart_evt_callback+0x3e>
  a2a574:	4601                	li	a2,0
  a2a576:	4589                	li	a1,2
  a2a578:	8522                	mv	a0,s0
  a2a57a:	0e2010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a57e:	4501                	li	a0,0
  a2a580:	8154                	popret	{ra,s0-s3},48
  a2a582:	00f10613          	addi	a2,sp,15
  a2a586:	459d                	li	a1,7
  a2a588:	8522                	mv	a0,s0
  a2a58a:	0d2010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a58e:	00f14783          	lbu	a5,15(sp)
  a2a592:	f7f5                	bnez	a5,a2a57e <uart_evt_callback+0x3a>
  a2a594:	8522                	mv	a0,s0
  a2a596:	3709                	jal	ra,a2a498 <uart_helper_send_next_char>
  a2a598:	d56d                	beqz	a0,a2a582 <uart_evt_callback+0x3e>
  a2a59a:	8522                	mv	a0,s0
  a2a59c:	3545                	jal	ra,a2a43c <uart_helper_invoke_current_fragment_callback>
  a2a59e:	8522                	mv	a0,s0
  a2a5a0:	3d6d                	jal	ra,a2a45a <uart_helper_move_to_next_fragment>
  a2a5a2:	b7f9                	j	a2a570 <uart_evt_callback+0x2c>
  a2a5a4:	00f10613          	addi	a2,sp,15
  a2a5a8:	45a5                	li	a1,9
  a2a5aa:	00a0 5600 049f      	l.li	s1,0xa05600
  a2a5b0:	00010723          	sb	zero,14(sp)
  a2a5b4:	000107a3          	sb	zero,15(sp)
  a2a5b8:	4981                	li	s3,0
  a2a5ba:	0a2010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a5be:	1884995b          	muliadd	s2,s1,s0,24
  a2a5c2:	00f14783          	lbu	a5,15(sp)
  a2a5c6:	cf81                	beqz	a5,a2a5de <uart_evt_callback+0x9a>
  a2a5c8:	188497db          	muliadd	a5,s1,s0,24
  a2a5cc:	2bda                	lhu	a4,20(a5)
  a2a5ce:	db45                	beqz	a4,a2a57e <uart_evt_callback+0x3a>
  a2a5d0:	2bf8                	lbu	a4,22(a5)
  a2a5d2:	8b09                	andi	a4,a4,2
  a2a5d4:	d74d                	beqz	a4,a2a57e <uart_evt_callback+0x3a>
  a2a5d6:	2bbe                	lhu	a5,18(a5)
  a2a5d8:	faf9e3e3          	bltu	s3,a5,a2a57e <uart_evt_callback+0x3a>
  a2a5dc:	a071                	j	a2a668 <uart_evt_callback+0x124>
  a2a5de:	4605                	li	a2,1
  a2a5e0:	00e10593          	addi	a1,sp,14
  a2a5e4:	8522                	mv	a0,s0
  a2a5e6:	064010ef          	jal	ra,a2b64a <hal_uart_read>
  a2a5ea:	00092783          	lw	a5,0(s2)
  a2a5ee:	0985                	addi	s3,s3,1 # ffff0001 <_gp_+0xff5bb7bd>
  a2a5f0:	09c2                	slli	s3,s3,0x10
  a2a5f2:	0109d993          	srli	s3,s3,0x10
  a2a5f6:	eb81                	bnez	a5,a2a606 <uart_evt_callback+0xc2>
  a2a5f8:	00f10613          	addi	a2,sp,15
  a2a5fc:	45a5                	li	a1,9
  a2a5fe:	8522                	mv	a0,s0
  a2a600:	05c010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a604:	bf7d                	j	a2a5c2 <uart_evt_callback+0x7e>
  a2a606:	01495683          	lhu	a3,20(s2)
  a2a60a:	00c92783          	lw	a5,12(s2)
  a2a60e:	00e14703          	lbu	a4,14(sp)
  a2a612:	97b6                	add	a5,a5,a3
  a2a614:	a398                	sb	a4,0(a5)
  a2a616:	01495783          	lhu	a5,20(s2)
  a2a61a:	01095703          	lhu	a4,16(s2)
  a2a61e:	0785                	addi	a5,a5,1
  a2a620:	9fa1                	uxth	a5
  a2a622:	00f91a23          	sh	a5,20(s2)
  a2a626:	fce7e9e3          	bltu	a5,a4,a2a5f8 <uart_evt_callback+0xb4>
  a2a62a:	4581                	li	a1,0
  a2a62c:	8522                	mv	a0,s0
  a2a62e:	3b75                	jal	ra,a2a3ea <uart_rx_buffer_report>
  a2a630:	b7e1                	j	a2a5f8 <uart_evt_callback+0xb4>
  a2a632:	00f10613          	addi	a2,sp,15
  a2a636:	45a5                	li	a1,9
  a2a638:	00a0 5600 049f      	l.li	s1,0xa05600
  a2a63e:	00010723          	sb	zero,14(sp)
  a2a642:	000107a3          	sb	zero,15(sp)
  a2a646:	4981                	li	s3,0
  a2a648:	014010ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a64c:	1884995b          	muliadd	s2,s1,s0,24
  a2a650:	00f14783          	lbu	a5,15(sp)
  a2a654:	cf91                	beqz	a5,a2a670 <uart_evt_callback+0x12c>
  a2a656:	188497db          	muliadd	a5,s1,s0,24
  a2a65a:	2bda                	lhu	a4,20(a5)
  a2a65c:	f20701e3          	beqz	a4,a2a57e <uart_evt_callback+0x3a>
  a2a660:	2bf8                	lbu	a4,22(a5)
  a2a662:	00177693          	andi	a3,a4,1
  a2a666:	d6b5                	beqz	a3,a2a5d2 <uart_evt_callback+0x8e>
  a2a668:	4581                	li	a1,0
  a2a66a:	8522                	mv	a0,s0
  a2a66c:	3bbd                	jal	ra,a2a3ea <uart_rx_buffer_report>
  a2a66e:	bf01                	j	a2a57e <uart_evt_callback+0x3a>
  a2a670:	4605                	li	a2,1
  a2a672:	00e10593          	addi	a1,sp,14
  a2a676:	8522                	mv	a0,s0
  a2a678:	7d3000ef          	jal	ra,a2b64a <hal_uart_read>
  a2a67c:	00092783          	lw	a5,0(s2)
  a2a680:	0985                	addi	s3,s3,1
  a2a682:	09c2                	slli	s3,s3,0x10
  a2a684:	0109d993          	srli	s3,s3,0x10
  a2a688:	eb81                	bnez	a5,a2a698 <uart_evt_callback+0x154>
  a2a68a:	00f10613          	addi	a2,sp,15
  a2a68e:	45a5                	li	a1,9
  a2a690:	8522                	mv	a0,s0
  a2a692:	7cb000ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a696:	bf6d                	j	a2a650 <uart_evt_callback+0x10c>
  a2a698:	01495683          	lhu	a3,20(s2)
  a2a69c:	00c92783          	lw	a5,12(s2)
  a2a6a0:	00e14703          	lbu	a4,14(sp)
  a2a6a4:	97b6                	add	a5,a5,a3
  a2a6a6:	a398                	sb	a4,0(a5)
  a2a6a8:	01495783          	lhu	a5,20(s2)
  a2a6ac:	01095703          	lhu	a4,16(s2)
  a2a6b0:	0785                	addi	a5,a5,1
  a2a6b2:	9fa1                	uxth	a5
  a2a6b4:	00f91a23          	sh	a5,20(s2)
  a2a6b8:	fce7e9e3          	bltu	a5,a4,a2a68a <uart_evt_callback+0x146>
  a2a6bc:	4581                	li	a1,0
  a2a6be:	8522                	mv	a0,s0
  a2a6c0:	332d                	jal	ra,a2a3ea <uart_rx_buffer_report>
  a2a6c2:	b7e1                	j	a2a68a <uart_evt_callback+0x146>
  a2a6c4:	00a0 5600 079f      	l.li	a5,0xa05600
  a2a6ca:	18a797db          	muliadd	a5,a5,a0,24
  a2a6ce:	43dc                	lw	a5,4(a5)
  a2a6d0:	c781                	beqz	a5,a2a6d8 <uart_evt_callback+0x194>
  a2a6d2:	4581                	li	a1,0
  a2a6d4:	4501                	li	a0,0
  a2a6d6:	9782                	jalr	a5
  a2a6d8:	8522                	mv	a0,s0
  a2a6da:	33f5                	jal	ra,a2a4c6 <uart_error_isr>
  a2a6dc:	b54d                	j	a2a57e <uart_evt_callback+0x3a>
  a2a6de:	00a0 5600 079f      	l.li	a5,0xa05600
  a2a6e4:	18a797db          	muliadd	a5,a5,a0,24
  a2a6e8:	479c                	lw	a5,8(a5)
  a2a6ea:	b7dd                	j	a2a6d0 <uart_evt_callback+0x18c>

00a2a6ec <uapi_uart_init>:
  a2a6ec:	8158                	push	{ra,s0-s3},-48
  a2a6ee:	4789                	li	a5,2
  a2a6f0:	0aa7ed63          	bltu	a5,a0,a2a7aa <uapi_uart_init+0xbe>
  a2a6f4:	c9dd                	beqz	a1,a2a7aa <uapi_uart_init+0xbe>
  a2a6f6:	0015c883          	lbu	a7,1(a1)
  a2a6fa:	07200813          	li	a6,114
  a2a6fe:	0b186663          	bltu	a6,a7,a2a7aa <uapi_uart_init+0xbe>
  a2a702:	0005c883          	lbu	a7,0(a1)
  a2a706:	0b186263          	bltu	a6,a7,a2a7aa <uapi_uart_init+0xbe>
  a2a70a:	c245                	beqz	a2,a2a7aa <uapi_uart_init+0xbe>
  a2a70c:	00464803          	lbu	a6,4(a2)
  a2a710:	042876bb          	bgeui	a6,4,a2a7aa <uapi_uart_init+0xbe>
  a2a714:	00664803          	lbu	a6,6(a2)
  a2a718:	0907e963          	bltu	a5,a6,a2a7aa <uapi_uart_init+0xbe>
  a2a71c:	325c                	lbu	a5,5(a2)
  a2a71e:	0227f33b          	bgeui	a5,2,a2a7aa <uapi_uart_init+0xbe>
  a2a722:	00a05937          	lui	s2,0xa05
  a2a726:	5fc90793          	addi	a5,s2,1532 # a055fc <g_uart_inited>
  a2a72a:	97aa                	add	a5,a5,a0
  a2a72c:	239c                	lbu	a5,0(a5)
  a2a72e:	84aa                	mv	s1,a0
  a2a730:	5fc90913          	addi	s2,s2,1532
  a2a734:	4401                	li	s0,0
  a2a736:	eba5                	bnez	a5,a2a7a6 <uapi_uart_init+0xba>
  a2a738:	89ba                	mv	s3,a4
  a2a73a:	c636                	sw	a3,12(sp)
  a2a73c:	8432                	mv	s0,a2
  a2a73e:	c42e                	sw	a1,8(sp)
  a2a740:	29d010ef          	jal	ra,a2c1dc <uart_port_config_pinmux>
  a2a744:	06098763          	beqz	s3,a2a7b2 <uapi_uart_init+0xc6>
  a2a748:	0009a683          	lw	a3,0(s3)
  a2a74c:	c2bd                	beqz	a3,a2a7b2 <uapi_uart_init+0xc6>
  a2a74e:	0049a703          	lw	a4,4(s3)
  a2a752:	c325                	beqz	a4,a2a7b2 <uapi_uart_init+0xc6>
  a2a754:	04c00513          	li	a0,76
  a2a758:	02a48533          	mul	a0,s1,a0
  a2a75c:	00a0 5600 071f      	l.li	a4,0xa05600
  a2a762:	1897175b          	muliadd	a4,a4,s1,24
  a2a766:	c754                	sw	a3,12(a4)
  a2a768:	0049a683          	lw	a3,4(s3)
  a2a76c:	47b2                	lw	a5,12(sp)
  a2a76e:	4622                	lw	a2,8(sp)
  a2a770:	ab16                	sh	a3,16(a4)
  a2a772:	00a0 5648 071f      	l.li	a4,0xa05648
  a2a778:	86a2                	mv	a3,s0
  a2a77a:	00c50593          	addi	a1,a0,12
  a2a77e:	95ba                	add	a1,a1,a4
  a2a780:	972a                	add	a4,a4,a0
  a2a782:	c30c                	sw	a1,0(a4)
  a2a784:	c34c                	sw	a1,4(a4)
  a2a786:	8526                	mv	a0,s1
  a2a788:	4711                	li	a4,4
  a2a78a:	00a2 a544 059f      	l.li	a1,0xa2a544
  a2a790:	66b000ef          	jal	ra,a2b5fa <hal_uart_init>
  a2a794:	842a                	mv	s0,a0
  a2a796:	e901                	bnez	a0,a2a7a6 <uapi_uart_init+0xba>
  a2a798:	9926                	add	s2,s2,s1
  a2a79a:	4785                	li	a5,1
  a2a79c:	8526                	mv	a0,s1
  a2a79e:	00f90023          	sb	a5,0(s2)
  a2a7a2:	24b010ef          	jal	ra,a2c1ec <uart_port_register_irq>
  a2a7a6:	8522                	mv	a0,s0
  a2a7a8:	8154                	popret	{ra,s0-s3},48
  a2a7aa:	80000437          	lui	s0,0x80000
  a2a7ae:	0405                	addi	s0,s0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2a7b0:	bfdd                	j	a2a7a6 <uapi_uart_init+0xba>
  a2a7b2:	8000 1044 041f      	l.li	s0,0x80001044
  a2a7b8:	b7fd                	j	a2a7a6 <uapi_uart_init+0xba>

00a2a7ba <uapi_uart_write>:
  a2a7ba:	8178                	push	{ra,s0-s5},-48
  a2a7bc:	84aa                	mv	s1,a0
  a2a7be:	8a2e                	mv	s4,a1
  a2a7c0:	89b2                	mv	s3,a2
  a2a7c2:	000107a3          	sb	zero,15(sp)
  a2a7c6:	c4fff0ef          	jal	ra,a2a414 <uapi_uart_param_check>
  a2a7ca:	892a                	mv	s2,a0
  a2a7cc:	ed19                	bnez	a0,a2a7ea <uapi_uart_write+0x30>
  a2a7ce:	8526                	mv	a0,s1
  a2a7d0:	251010ef          	jal	ra,a2c220 <uart_porting_lock>
  a2a7d4:	8aaa                	mv	s5,a0
  a2a7d6:	99d2                	add	s3,s3,s4
  a2a7d8:	8452                	mv	s0,s4
  a2a7da:	41440933          	sub	s2,s0,s4
  a2a7de:	00899863          	bne	s3,s0,a2a7ee <uapi_uart_write+0x34>
  a2a7e2:	85d6                	mv	a1,s5
  a2a7e4:	8526                	mv	a0,s1
  a2a7e6:	23f010ef          	jal	ra,a2c224 <uart_porting_unlock>
  a2a7ea:	854a                	mv	a0,s2
  a2a7ec:	8174                	popret	{ra,s0-s5},48
  a2a7ee:	00f10613          	addi	a2,sp,15
  a2a7f2:	459d                	li	a1,7
  a2a7f4:	8526                	mv	a0,s1
  a2a7f6:	667000ef          	jal	ra,a2b65c <hal_uart_ctrl>
  a2a7fa:	00f14783          	lbu	a5,15(sp)
  a2a7fe:	f3e5                	bnez	a5,a2a7de <uapi_uart_write+0x24>
  a2a800:	85a2                	mv	a1,s0
  a2a802:	00140913          	addi	s2,s0,1
  a2a806:	4605                	li	a2,1
  a2a808:	8526                	mv	a0,s1
  a2a80a:	62f000ef          	jal	ra,a2b638 <hal_uart_write>
  a2a80e:	844a                	mv	s0,s2
  a2a810:	b7e9                	j	a2a7da <uapi_uart_write+0x20>

00a2a812 <uapi_watchdog_init>:
  a2a812:	8058                	push	{ra,s0-s3},-32
  a2a814:	89aa                	mv	s3,a0
  a2a816:	24b010ef          	jal	ra,a2c260 <watchdog_port_register_hal_funcs>
  a2a81a:	257010ef          	jal	ra,a2c270 <watchdog_port_register_irq>
  a2a81e:	9ceff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a822:	84aa                	mv	s1,a0
  a2a824:	286010ef          	jal	ra,a2baaa <hal_watchdog_get_funcs>
  a2a828:	411c                	lw	a5,0(a0)
  a2a82a:	00a0 572c 091f      	l.li	s2,0xa0572c
  a2a830:	00a92023          	sw	a0,0(s2)
  a2a834:	9782                	jalr	a5
  a2a836:	c519                	beqz	a0,a2a844 <uapi_watchdog_init+0x32>
  a2a838:	842a                	mv	s0,a0
  a2a83a:	8526                	mv	a0,s1
  a2a83c:	9b8ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a840:	8522                	mv	a0,s0
  a2a842:	8054                	popret	{ra,s0-s3},32
  a2a844:	00092783          	lw	a5,0(s2)
  a2a848:	854e                	mv	a0,s3
  a2a84a:	479c                	lw	a5,8(a5)
  a2a84c:	9782                	jalr	a5
  a2a84e:	842a                	mv	s0,a0
  a2a850:	8526                	mv	a0,s1
  a2a852:	9a2ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a856:	f46d                	bnez	s0,a2a840 <uapi_watchdog_init+0x2e>
  a2a858:	00a0 5731 079f      	l.li	a5,0xa05731
  a2a85e:	4705                	li	a4,1
  a2a860:	a398                	sb	a4,0(a5)
  a2a862:	bff9                	j	a2a840 <uapi_watchdog_init+0x2e>

00a2a864 <uapi_watchdog_enable>:
  a2a864:	00a0 5731 079f      	l.li	a5,0xa05731
  a2a86a:	239c                	lbu	a5,0(a5)
  a2a86c:	cb9d                	beqz	a5,a2a8a2 <uapi_watchdog_enable+0x3e>
  a2a86e:	8048                	push	{ra,s0-s2},-16
  a2a870:	4485                	li	s1,1
  a2a872:	57fd                	li	a5,-1
  a2a874:	02a4e563          	bltu	s1,a0,a2a89e <uapi_watchdog_enable+0x3a>
  a2a878:	842a                	mv	s0,a0
  a2a87a:	972ff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a87e:	00a0 572c 079f      	l.li	a5,0xa0572c
  a2a884:	439c                	lw	a5,0(a5)
  a2a886:	892a                	mv	s2,a0
  a2a888:	8522                	mv	a0,s0
  a2a88a:	4b9c                	lw	a5,16(a5)
  a2a88c:	9782                	jalr	a5
  a2a88e:	854a                	mv	a0,s2
  a2a890:	964ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a894:	00a0 5730 079f      	l.li	a5,0xa05730
  a2a89a:	a384                	sb	s1,0(a5)
  a2a89c:	4781                	li	a5,0
  a2a89e:	853e                	mv	a0,a5
  a2a8a0:	8044                	popret	{ra,s0-s2},16
  a2a8a2:	57fd                	li	a5,-1
  a2a8a4:	853e                	mv	a0,a5
  a2a8a6:	8082                	ret

00a2a8a8 <uapi_watchdog_disable>:
  a2a8a8:	00a0 5731 079f      	l.li	a5,0xa05731
  a2a8ae:	239c                	lbu	a5,0(a5)
  a2a8b0:	e399                	bnez	a5,a2a8b6 <uapi_watchdog_disable+0xe>
  a2a8b2:	557d                	li	a0,-1
  a2a8b4:	8082                	ret
  a2a8b6:	8118                	push	{ra},-32
  a2a8b8:	934ff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a8bc:	00a0 572c 079f      	l.li	a5,0xa0572c
  a2a8c2:	439c                	lw	a5,0(a5)
  a2a8c4:	c62a                	sw	a0,12(sp)
  a2a8c6:	4bdc                	lw	a5,20(a5)
  a2a8c8:	9782                	jalr	a5
  a2a8ca:	4532                	lw	a0,12(sp)
  a2a8cc:	928ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a8d0:	00a0 5730 079f      	l.li	a5,0xa05730
  a2a8d6:	00078023          	sb	zero,0(a5)
  a2a8da:	4501                	li	a0,0
  a2a8dc:	8114                	popret	{ra},32

00a2a8de <uapi_watchdog_deinit>:
  a2a8de:	00a057b7          	lui	a5,0xa05
  a2a8e2:	7317c703          	lbu	a4,1841(a5) # a05731 <g_watchdog_inited>
  a2a8e6:	c71d                	beqz	a4,a2a914 <uapi_watchdog_deinit+0x36>
  a2a8e8:	8028                	push	{ra,s0},-16
  a2a8ea:	73178413          	addi	s0,a5,1841
  a2a8ee:	00a0 5730 079f      	l.li	a5,0xa05730
  a2a8f4:	239c                	lbu	a5,0(a5)
  a2a8f6:	c391                	beqz	a5,a2a8fa <uapi_watchdog_deinit+0x1c>
  a2a8f8:	3f45                	jal	ra,a2a8a8 <uapi_watchdog_disable>
  a2a8fa:	00a0 572c 079f      	l.li	a5,0xa0572c
  a2a900:	439c                	lw	a5,0(a5)
  a2a902:	c399                	beqz	a5,a2a908 <uapi_watchdog_deinit+0x2a>
  a2a904:	43dc                	lw	a5,4(a5)
  a2a906:	9782                	jalr	a5
  a2a908:	165010ef          	jal	ra,a2c26c <watchdog_port_unregister_hal_funcs>
  a2a90c:	4501                	li	a0,0
  a2a90e:	00040023          	sb	zero,0(s0)
  a2a912:	8024                	popret	{ra,s0},16
  a2a914:	4501                	li	a0,0
  a2a916:	8082                	ret

00a2a918 <uapi_watchdog_kick>:
  a2a918:	00a0 5730 079f      	l.li	a5,0xa05730
  a2a91e:	239c                	lbu	a5,0(a5)
  a2a920:	e399                	bnez	a5,a2a926 <uapi_watchdog_kick+0xe>
  a2a922:	557d                	li	a0,-1
  a2a924:	8082                	ret
  a2a926:	8118                	push	{ra},-32
  a2a928:	8c4ff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a92c:	00a0 572c 079f      	l.li	a5,0xa0572c
  a2a932:	439c                	lw	a5,0(a5)
  a2a934:	c62a                	sw	a0,12(sp)
  a2a936:	4f9c                	lw	a5,24(a5)
  a2a938:	9782                	jalr	a5
  a2a93a:	4532                	lw	a0,12(sp)
  a2a93c:	8b8ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a940:	4501                	li	a0,0
  a2a942:	8114                	popret	{ra},32

00a2a944 <uapi_efuse_init>:
  a2a944:	8018                	push	{ra},-16
  a2a946:	0d2020ef          	jal	ra,a2ca18 <efuse_port_register_hal_funcs>
  a2a94a:	28c1                	jal	ra,a2aa1a <hal_efuse_get_funcs>
  a2a94c:	00052303          	lw	t1,0(a0)
  a2a950:	8010                	pop	{ra},16
  a2a952:	8302                	jr	t1

00a2a954 <uapi_efuse_read_bit>:
  a2a954:	8168                	push	{ra,s0-s4},-48
  a2a956:	000107a3          	sb	zero,15(sp)
  a2a95a:	547d                	li	s0,-1
  a2a95c:	0ff00793          	li	a5,255
  a2a960:	02b7ee63          	bltu	a5,a1,a2a99c <uapi_efuse_read_bit+0x48>
  a2a964:	cd05                	beqz	a0,a2a99c <uapi_efuse_read_bit+0x48>
  a2a966:	08067dbb          	bgeui	a2,8,a2a99c <uapi_efuse_read_bit+0x48>
  a2a96a:	842e                	mv	s0,a1
  a2a96c:	8932                	mv	s2,a2
  a2a96e:	84aa                	mv	s1,a0
  a2a970:	206d                	jal	ra,a2aa1a <hal_efuse_get_funcs>
  a2a972:	8a2a                	mv	s4,a0
  a2a974:	878ff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a978:	010a2783          	lw	a5,16(s4)
  a2a97c:	89aa                	mv	s3,a0
  a2a97e:	00f10593          	addi	a1,sp,15
  a2a982:	8522                	mv	a0,s0
  a2a984:	9782                	jalr	a5
  a2a986:	842a                	mv	s0,a0
  a2a988:	ed01                	bnez	a0,a2a9a0 <uapi_efuse_read_bit+0x4c>
  a2a98a:	00f14783          	lbu	a5,15(sp)
  a2a98e:	854e                	mv	a0,s3
  a2a990:	4127d633          	sra	a2,a5,s2
  a2a994:	8a05                	andi	a2,a2,1
  a2a996:	a090                	sb	a2,0(s1)
  a2a998:	85cff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a99c:	8522                	mv	a0,s0
  a2a99e:	8164                	popret	{ra,s0-s4},48
  a2a9a0:	854e                	mv	a0,s3
  a2a9a2:	852ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a9a6:	547d                	li	s0,-1
  a2a9a8:	bfd5                	j	a2a99c <uapi_efuse_read_bit+0x48>

00a2a9aa <uapi_efuse_read_buffer>:
  a2a9aa:	8088                	push	{ra,s0-s6},-32
  a2a9ac:	547d                	li	s0,-1
  a2a9ae:	c231                	beqz	a2,a2a9f2 <uapi_efuse_read_buffer+0x48>
  a2a9b0:	0ff00793          	li	a5,255
  a2a9b4:	02b7ef63          	bltu	a5,a1,a2a9f2 <uapi_efuse_read_buffer+0x48>
  a2a9b8:	00c587b3          	add	a5,a1,a2
  a2a9bc:	10000713          	li	a4,256
  a2a9c0:	02f76963          	bltu	a4,a5,a2a9f2 <uapi_efuse_read_buffer+0x48>
  a2a9c4:	c51d                	beqz	a0,a2a9f2 <uapi_efuse_read_buffer+0x48>
  a2a9c6:	8932                	mv	s2,a2
  a2a9c8:	89ae                	mv	s3,a1
  a2a9ca:	8a2a                	mv	s4,a0
  a2a9cc:	20b9                	jal	ra,a2aa1a <hal_efuse_get_funcs>
  a2a9ce:	8b2a                	mv	s6,a0
  a2a9d0:	81cff0ef          	jal	ra,a299ec <osal_irq_lock>
  a2a9d4:	8aaa                	mv	s5,a0
  a2a9d6:	4481                	li	s1,0
  a2a9d8:	010b2783          	lw	a5,16(s6)
  a2a9dc:	009a05b3          	add	a1,s4,s1
  a2a9e0:	00998533          	add	a0,s3,s1
  a2a9e4:	9782                	jalr	a5
  a2a9e6:	842a                	mv	s0,a0
  a2a9e8:	c519                	beqz	a0,a2a9f6 <uapi_efuse_read_buffer+0x4c>
  a2a9ea:	8556                	mv	a0,s5
  a2a9ec:	808ff0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2a9f0:	547d                	li	s0,-1
  a2a9f2:	8522                	mv	a0,s0
  a2a9f4:	8084                	popret	{ra,s0-s6},32
  a2a9f6:	0485                	addi	s1,s1,1
  a2a9f8:	ff24e0e3          	bltu	s1,s2,a2a9d8 <uapi_efuse_read_buffer+0x2e>
  a2a9fc:	8556                	mv	a0,s5
  a2a9fe:	ff7fe0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2aa02:	bfc5                	j	a2a9f2 <uapi_efuse_read_buffer+0x48>

00a2aa04 <hal_efuse_register_funcs>:
  a2aa04:	c519                	beqz	a0,a2aa12 <hal_efuse_register_funcs+0xe>
  a2aa06:	00a0 5734 079f      	l.li	a5,0xa05734
  a2aa0c:	c388                	sw	a0,0(a5)
  a2aa0e:	4501                	li	a0,0
  a2aa10:	8082                	ret
  a2aa12:	80000537          	lui	a0,0x80000
  a2aa16:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2aa18:	8082                	ret

00a2aa1a <hal_efuse_get_funcs>:
  a2aa1a:	00a0 5734 079f      	l.li	a5,0xa05734
  a2aa20:	4388                	lw	a0,0(a5)
  a2aa22:	8082                	ret

00a2aa24 <hal_efuse_deinit>:
  a2aa24:	00a0 5738 079f      	l.li	a5,0xa05738
  a2aa2a:	00078023          	sb	zero,0(a5)
  a2aa2e:	8082                	ret

00a2aa30 <hal_efuse_get_writeread_addr>:
  a2aa30:	8038                	push	{ra,s0-s1},-16
  a2aa32:	84aa                	mv	s1,a0
  a2aa34:	7f1010ef          	jal	ra,a2ca24 <hal_efuse_get_region>
  a2aa38:	842a                	mv	s0,a0
  a2aa3a:	8526                	mv	a0,s1
  a2aa3c:	7ef010ef          	jal	ra,a2ca2a <hal_efuse_get_byte_offset>
  a2aa40:	00a3 3fc8 079f      	l.li	a5,0xa33fc8
  a2aa46:	0487879b          	addshf	a5,a5,s0,sll,2
  a2aa4a:	439c                	lw	a5,0(a5)
  a2aa4c:	8105                	srli	a0,a0,0x1
  a2aa4e:	9d21                	uxth	a0
  a2aa50:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2aa54:	8034                	popret	{ra,s0-s1},16

00a2aa56 <hal_efuse_init>:
  a2aa56:	8018                	push	{ra},-16
  a2aa58:	4501                	li	a0,0
  a2aa5a:	2255                	jal	ra,a2abfe <hal_efuse_regs_init>
  a2aa5c:	00a057b7          	lui	a5,0xa05
  a2aa60:	7407a703          	lw	a4,1856(a5) # a05740 <g_efuse_regs>
  a2aa64:	00a3 3e5c 069f      	l.li	a3,0xa33e5c
  a2aa6a:	2294                	lbu	a3,0(a3)
  a2aa6c:	435c                	lw	a5,4(a4)
  a2aa6e:	4501                	li	a0,0
  a2aa70:	f007f793          	andi	a5,a5,-256
  a2aa74:	8fd5                	or	a5,a5,a3
  a2aa76:	c35c                	sw	a5,4(a4)
  a2aa78:	00a0 5738 079f      	l.li	a5,0xa05738
  a2aa7e:	4705                	li	a4,1
  a2aa80:	a398                	sb	a4,0(a5)
  a2aa82:	8014                	popret	{ra},16

00a2aa84 <hal_efuse_read_byte>:
  a2aa84:	00a0 5738 079f      	l.li	a5,0xa05738
  a2aa8a:	239c                	lbu	a5,0(a5)
  a2aa8c:	c7a1                	beqz	a5,a2aad4 <hal_efuse_read_byte+0x50>
  a2aa8e:	8048                	push	{ra,s0-s2},-16
  a2aa90:	842a                	mv	s0,a0
  a2aa92:	0ff00793          	li	a5,255
  a2aa96:	04a7e363          	bltu	a5,a0,a2aadc <hal_efuse_read_byte+0x58>
  a2aa9a:	c1a9                	beqz	a1,a2aadc <hal_efuse_read_byte+0x58>
  a2aa9c:	84ae                	mv	s1,a1
  a2aa9e:	3f49                	jal	ra,a2aa30 <hal_efuse_get_writeread_addr>
  a2aaa0:	892a                	mv	s2,a0
  a2aaa2:	8522                	mv	a0,s0
  a2aaa4:	781010ef          	jal	ra,a2ca24 <hal_efuse_get_region>
  a2aaa8:	00a0 5740 079f      	l.li	a5,0xa05740
  a2aaae:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2aab2:	4118                	lw	a4,0(a0)
  a2aab4:	76c1                	lui	a3,0xffff0
  a2aab6:	8805                	andi	s0,s0,1
  a2aab8:	431c                	lw	a5,0(a4)
  a2aaba:	8ff5                	and	a5,a5,a3
  a2aabc:	0000 5a5a 069f      	l.li	a3,0x5a5a
  a2aac2:	8fd5                	or	a5,a5,a3
  a2aac4:	c31c                	sw	a5,0(a4)
  a2aac6:	00092783          	lw	a5,0(s2)
  a2aaca:	c011                	beqz	s0,a2aace <hal_efuse_read_byte+0x4a>
  a2aacc:	83a1                	srli	a5,a5,0x8
  a2aace:	a09c                	sb	a5,0(s1)
  a2aad0:	4501                	li	a0,0
  a2aad2:	8044                	popret	{ra,s0-s2},16
  a2aad4:	8000 1391 051f      	l.li	a0,0x80001391
  a2aada:	8082                	ret
  a2aadc:	80000537          	lui	a0,0x80000
  a2aae0:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2aae2:	bfc5                	j	a2aad2 <hal_efuse_read_byte+0x4e>

00a2aae4 <hal_efuse_get_die_id>:
  a2aae4:	00a0 5738 079f      	l.li	a5,0xa05738
  a2aaea:	239c                	lbu	a5,0(a5)
  a2aaec:	ef99                	bnez	a5,a2ab0a <hal_efuse_get_die_id+0x26>
  a2aaee:	8000 1391 051f      	l.li	a0,0x80001391
  a2aaf4:	8082                	ret
  a2aaf6:	008905b3          	add	a1,s2,s0
  a2aafa:	8522                	mv	a0,s0
  a2aafc:	3761                	jal	ra,a2aa84 <hal_efuse_read_byte>
  a2aafe:	e919                	bnez	a0,a2ab14 <hal_efuse_get_die_id+0x30>
  a2ab00:	0405                	addi	s0,s0,1
  a2ab02:	fe946ae3          	bltu	s0,s1,a2aaf6 <hal_efuse_get_die_id+0x12>
  a2ab06:	4501                	li	a0,0
  a2ab08:	8044                	popret	{ra,s0-s2},16
  a2ab0a:	8048                	push	{ra,s0-s2},-16
  a2ab0c:	892a                	mv	s2,a0
  a2ab0e:	84ae                	mv	s1,a1
  a2ab10:	4401                	li	s0,0
  a2ab12:	bfc5                	j	a2ab02 <hal_efuse_get_die_id+0x1e>
  a2ab14:	557d                	li	a0,-1
  a2ab16:	bfcd                	j	a2ab08 <hal_efuse_get_die_id+0x24>

00a2ab18 <hal_efuse_write_operation>:
  a2ab18:	00a0 5738 079f      	l.li	a5,0xa05738
  a2ab1e:	239c                	lbu	a5,0(a5)
  a2ab20:	c3c1                	beqz	a5,a2aba0 <hal_efuse_write_operation+0x88>
  a2ab22:	8058                	push	{ra,s0-s3},-32
  a2ab24:	842a                	mv	s0,a0
  a2ab26:	0ff00793          	li	a5,255
  a2ab2a:	06a7ef63          	bltu	a5,a0,a2aba8 <hal_efuse_write_operation+0x90>
  a2ab2e:	00a054b7          	lui	s1,0xa05
  a2ab32:	892e                	mv	s2,a1
  a2ab34:	74048993          	addi	s3,s1,1856 # a05740 <g_efuse_regs>
  a2ab38:	6ed010ef          	jal	ra,a2ca24 <hal_efuse_get_region>
  a2ab3c:	04a9851b          	addshf	a0,s3,a0,sll,2
  a2ab40:	4118                	lw	a4,0(a0)
  a2ab42:	76c1                	lui	a3,0xffff0
  a2ab44:	8522                	mv	a0,s0
  a2ab46:	431c                	lw	a5,0(a4)
  a2ab48:	74048493          	addi	s1,s1,1856
  a2ab4c:	8ff5                	and	a5,a5,a3
  a2ab4e:	0000 a5a5 069f      	l.li	a3,0xa5a5
  a2ab54:	8fd5                	or	a5,a5,a3
  a2ab56:	c31c                	sw	a5,0(a4)
  a2ab58:	6cd010ef          	jal	ra,a2ca24 <hal_efuse_get_region>
  a2ab5c:	04a9851b          	addshf	a0,s3,a0,sll,2
  a2ab60:	4118                	lw	a4,0(a0)
  a2ab62:	06400513          	li	a0,100
  a2ab66:	475c                	lw	a5,12(a4)
  a2ab68:	0017e793          	ori	a5,a5,1
  a2ab6c:	c75c                	sw	a5,12(a4)
  a2ab6e:	83fff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2ab72:	8522                	mv	a0,s0
  a2ab74:	3d75                	jal	ra,a2aa30 <hal_efuse_get_writeread_addr>
  a2ab76:	00147793          	andi	a5,s0,1
  a2ab7a:	c391                	beqz	a5,a2ab7e <hal_efuse_write_operation+0x66>
  a2ab7c:	0922                	slli	s2,s2,0x8
  a2ab7e:	01252023          	sw	s2,0(a0)
  a2ab82:	8522                	mv	a0,s0
  a2ab84:	6a1010ef          	jal	ra,a2ca24 <hal_efuse_get_region>
  a2ab88:	04a4849b          	addshf	s1,s1,a0,sll,2
  a2ab8c:	4098                	lw	a4,0(s1)
  a2ab8e:	06400513          	li	a0,100
  a2ab92:	475c                	lw	a5,12(a4)
  a2ab94:	9bf9                	andi	a5,a5,-2
  a2ab96:	c75c                	sw	a5,12(a4)
  a2ab98:	815ff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2ab9c:	4501                	li	a0,0
  a2ab9e:	8054                	popret	{ra,s0-s3},32
  a2aba0:	8000 1391 051f      	l.li	a0,0x80001391
  a2aba6:	8082                	ret
  a2aba8:	80000537          	lui	a0,0x80000
  a2abac:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2abae:	bfc5                	j	a2ab9e <hal_efuse_write_operation+0x86>

00a2abb0 <hal_efuse_write_buffer_operation>:
  a2abb0:	00a0 5738 079f      	l.li	a5,0xa05738
  a2abb6:	239c                	lbu	a5,0(a5)
  a2abb8:	c795                	beqz	a5,a2abe4 <hal_efuse_write_buffer_operation+0x34>
  a2abba:	8058                	push	{ra,s0-s3},-32
  a2abbc:	89b2                	mv	s3,a2
  a2abbe:	842e                	mv	s0,a1
  a2abc0:	84ae                	mv	s1,a1
  a2abc2:	40b50933          	sub	s2,a0,a1
  a2abc6:	408487b3          	sub	a5,s1,s0
  a2abca:	0137e463          	bltu	a5,s3,a2abd2 <hal_efuse_write_buffer_operation+0x22>
  a2abce:	4501                	li	a0,0
  a2abd0:	8054                	popret	{ra,s0-s3},32
  a2abd2:	208c                	lbu	a1,0(s1)
  a2abd4:	00990533          	add	a0,s2,s1
  a2abd8:	4601                	li	a2,0
  a2abda:	3f3d                	jal	ra,a2ab18 <hal_efuse_write_operation>
  a2abdc:	0485                	addi	s1,s1,1
  a2abde:	d565                	beqz	a0,a2abc6 <hal_efuse_write_buffer_operation+0x16>
  a2abe0:	557d                	li	a0,-1
  a2abe2:	b7fd                	j	a2abd0 <hal_efuse_write_buffer_operation+0x20>
  a2abe4:	8000 1391 051f      	l.li	a0,0x80001391
  a2abea:	8082                	ret

00a2abec <hal_efuse_set_clock_period>:
  a2abec:	00a3 3e5c 079f      	l.li	a5,0xa33e5c
  a2abf2:	c388                	sw	a0,0(a5)
  a2abf4:	8082                	ret

00a2abf6 <hal_efuse_funcs_get>:
  a2abf6:	00a3 3e60 051f      	l.li	a0,0xa33e60
  a2abfc:	8082                	ret

00a2abfe <hal_efuse_regs_init>:
  a2abfe:	02a04763          	bgtz	a0,a2ac2c <hal_efuse_regs_init+0x2e>
  a2ac02:	050a                	slli	a0,a0,0x2
  a2ac04:	00a3 3fc0 071f      	l.li	a4,0xa33fc0
  a2ac0a:	00a0 5740 079f      	l.li	a5,0xa05740
  a2ac10:	97aa                	add	a5,a5,a0
  a2ac12:	953a                	add	a0,a0,a4
  a2ac14:	4118                	lw	a4,0(a0)
  a2ac16:	4501                	li	a0,0
  a2ac18:	c398                	sw	a4,0(a5)
  a2ac1a:	00a347b7          	lui	a5,0xa34
  a2ac1e:	fc47a703          	lw	a4,-60(a5) # a33fc4 <g_efuse_boot_done_addr>
  a2ac22:	00a0 573c 079f      	l.li	a5,0xa0573c
  a2ac28:	c398                	sw	a4,0(a5)
  a2ac2a:	8082                	ret
  a2ac2c:	557d                	li	a0,-1
  a2ac2e:	8082                	ret

00a2ac30 <hal_pmp_register_funcs>:
  a2ac30:	c519                	beqz	a0,a2ac3e <hal_pmp_register_funcs+0xe>
  a2ac32:	00a0 5744 079f      	l.li	a5,0xa05744
  a2ac38:	c388                	sw	a0,0(a5)
  a2ac3a:	4501                	li	a0,0
  a2ac3c:	8082                	ret
  a2ac3e:	80000537          	lui	a0,0x80000
  a2ac42:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2ac44:	8082                	ret

00a2ac46 <hal_pmp_get_funcs>:
  a2ac46:	00a0 5744 079f      	l.li	a5,0xa05744
  a2ac4c:	4388                	lw	a0,0(a5)
  a2ac4e:	8082                	ret

00a2ac50 <hal_pmp_riscv31_config>:
  a2ac50:	8048                	push	{ra,s0-s2},-16
  a2ac52:	00052903          	lw	s2,0(a0)
  a2ac56:	10097fbb          	bgeui	s2,16,a2ac94 <hal_pmp_riscv31_config+0x44>
  a2ac5a:	414c                	lw	a1,4(a0)
  a2ac5c:	2500                	lbu	s0,8(a0)
  a2ac5e:	84aa                	mv	s1,a0
  a2ac60:	854a                	mv	a0,s2
  a2ac62:	2089                	jal	ra,a2aca4 <hal_pmp_riscv31_regs_set_pmpaddr>
  a2ac64:	85a2                	mv	a1,s0
  a2ac66:	854a                	mv	a0,s2
  a2ac68:	28e9                	jal	ra,a2ad42 <hal_pmp_riscv31_regs_set_memxattr>
  a2ac6a:	4480                	lw	s0,8(s1)
  a2ac6c:	854a                	mv	a0,s2
  a2ac6e:	8021                	srli	s0,s0,0x8
  a2ac70:	881d                	andi	s0,s0,7
  a2ac72:	85a2                	mv	a1,s0
  a2ac74:	2a39                	jal	ra,a2ad92 <hal_pmp_riscv31_regs_set_pmpxcfg>
  a2ac76:	449c                	lw	a5,8(s1)
  a2ac78:	854a                	mv	a0,s2
  a2ac7a:	0087d713          	srli	a4,a5,0x8
  a2ac7e:	8b61                	andi	a4,a4,24
  a2ac80:	83a1                	srli	a5,a5,0x8
  a2ac82:	0807f593          	andi	a1,a5,128
  a2ac86:	8c59                	or	s0,s0,a4
  a2ac88:	8dc1                	or	a1,a1,s0
  a2ac8a:	2221                	jal	ra,a2ad92 <hal_pmp_riscv31_regs_set_pmpxcfg>
  a2ac8c:	0ff0000f          	fence
  a2ac90:	4501                	li	a0,0
  a2ac92:	8044                	popret	{ra,s0-s2},16
  a2ac94:	80000537          	lui	a0,0x80000
  a2ac98:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2ac9a:	bfe5                	j	a2ac92 <hal_pmp_riscv31_config+0x42>

00a2ac9c <hal_pmp_riscv31_funcs_get>:
  a2ac9c:	00a3 3e8c 051f      	l.li	a0,0xa33e8c
  a2aca2:	8082                	ret

00a2aca4 <hal_pmp_riscv31_regs_set_pmpaddr>:
  a2aca4:	e501                	bnez	a0,a2acac <hal_pmp_riscv31_regs_set_pmpaddr+0x8>
  a2aca6:	3b059073          	csrw	pmpaddr0,a1
  a2acaa:	8082                	ret
  a2acac:	010512bb          	bnei	a0,1,a2acb6 <hal_pmp_riscv31_regs_set_pmpaddr+0x12>
  a2acb0:	3b159073          	csrw	pmpaddr1,a1
  a2acb4:	8082                	ret
  a2acb6:	020512bb          	bnei	a0,2,a2acc0 <hal_pmp_riscv31_regs_set_pmpaddr+0x1c>
  a2acba:	3b259073          	csrw	pmpaddr2,a1
  a2acbe:	8082                	ret
  a2acc0:	030512bb          	bnei	a0,3,a2acca <hal_pmp_riscv31_regs_set_pmpaddr+0x26>
  a2acc4:	3b359073          	csrw	pmpaddr3,a1
  a2acc8:	8082                	ret
  a2acca:	040512bb          	bnei	a0,4,a2acd4 <hal_pmp_riscv31_regs_set_pmpaddr+0x30>
  a2acce:	3b459073          	csrw	pmpaddr4,a1
  a2acd2:	8082                	ret
  a2acd4:	050512bb          	bnei	a0,5,a2acde <hal_pmp_riscv31_regs_set_pmpaddr+0x3a>
  a2acd8:	3b559073          	csrw	pmpaddr5,a1
  a2acdc:	8082                	ret
  a2acde:	060512bb          	bnei	a0,6,a2ace8 <hal_pmp_riscv31_regs_set_pmpaddr+0x44>
  a2ace2:	3b659073          	csrw	pmpaddr6,a1
  a2ace6:	8082                	ret
  a2ace8:	070512bb          	bnei	a0,7,a2acf2 <hal_pmp_riscv31_regs_set_pmpaddr+0x4e>
  a2acec:	3b759073          	csrw	pmpaddr7,a1
  a2acf0:	8082                	ret
  a2acf2:	080512bb          	bnei	a0,8,a2acfc <hal_pmp_riscv31_regs_set_pmpaddr+0x58>
  a2acf6:	3b859073          	csrw	pmpaddr8,a1
  a2acfa:	8082                	ret
  a2acfc:	090512bb          	bnei	a0,9,a2ad06 <hal_pmp_riscv31_regs_set_pmpaddr+0x62>
  a2ad00:	3b959073          	csrw	pmpaddr9,a1
  a2ad04:	8082                	ret
  a2ad06:	0a0512bb          	bnei	a0,10,a2ad10 <hal_pmp_riscv31_regs_set_pmpaddr+0x6c>
  a2ad0a:	3ba59073          	csrw	pmpaddr10,a1
  a2ad0e:	8082                	ret
  a2ad10:	0b0512bb          	bnei	a0,11,a2ad1a <hal_pmp_riscv31_regs_set_pmpaddr+0x76>
  a2ad14:	3bb59073          	csrw	pmpaddr11,a1
  a2ad18:	8082                	ret
  a2ad1a:	0c0512bb          	bnei	a0,12,a2ad24 <hal_pmp_riscv31_regs_set_pmpaddr+0x80>
  a2ad1e:	3bc59073          	csrw	pmpaddr12,a1
  a2ad22:	8082                	ret
  a2ad24:	0d0512bb          	bnei	a0,13,a2ad2e <hal_pmp_riscv31_regs_set_pmpaddr+0x8a>
  a2ad28:	3bd59073          	csrw	pmpaddr13,a1
  a2ad2c:	8082                	ret
  a2ad2e:	0e0512bb          	bnei	a0,14,a2ad38 <hal_pmp_riscv31_regs_set_pmpaddr+0x94>
  a2ad32:	3be59073          	csrw	pmpaddr14,a1
  a2ad36:	8082                	ret
  a2ad38:	0f05123b          	bnei	a0,15,a2ad40 <hal_pmp_riscv31_regs_set_pmpaddr+0x9c>
  a2ad3c:	3bf59073          	csrw	pmpaddr15,a1
  a2ad40:	8082                	ret

00a2ad42 <hal_pmp_riscv31_regs_set_memxattr>:
  a2ad42:	0ff57713          	andi	a4,a0,255
  a2ad46:	080579bb          	bgeui	a0,8,a2ad6c <hal_pmp_riscv31_regs_set_memxattr+0x2a>
  a2ad4a:	7d8027f3          	csrr	a5,0x7d8
  a2ad4e:	070a                	slli	a4,a4,0x2
  a2ad50:	9f01                	uxtb	a4
  a2ad52:	46bd                	li	a3,15
  a2ad54:	00e696b3          	sll	a3,a3,a4
  a2ad58:	fff6c693          	not	a3,a3
  a2ad5c:	8efd                	and	a3,a3,a5
  a2ad5e:	00e59733          	sll	a4,a1,a4
  a2ad62:	8f55                	or	a4,a4,a3
  a2ad64:	82ba                	mv	t0,a4
  a2ad66:	7d829073          	csrw	0x7d8,t0
  a2ad6a:	8082                	ret
  a2ad6c:	7d902673          	csrr	a2,0x7d9
  a2ad70:	ff870793          	addi	a5,a4,-8
  a2ad74:	078a                	slli	a5,a5,0x2
  a2ad76:	9f81                	uxtb	a5
  a2ad78:	46bd                	li	a3,15
  a2ad7a:	00f696b3          	sll	a3,a3,a5
  a2ad7e:	fff6c693          	not	a3,a3
  a2ad82:	8ef1                	and	a3,a3,a2
  a2ad84:	00f597b3          	sll	a5,a1,a5
  a2ad88:	8fd5                	or	a5,a5,a3
  a2ad8a:	82be                	mv	t0,a5
  a2ad8c:	7d929073          	csrw	0x7d9,t0
  a2ad90:	8082                	ret

00a2ad92 <hal_pmp_riscv31_regs_set_pmpxcfg>:
  a2ad92:	00255793          	srli	a5,a0,0x2
  a2ad96:	1141                	addi	sp,sp,-16
  a2ad98:	01078a3b          	beqi	a5,1,a2adc0 <hal_pmp_riscv31_regs_set_pmpxcfg+0x2e>
  a2ad9c:	c799                	beqz	a5,a2adaa <hal_pmp_riscv31_regs_set_pmpxcfg+0x18>
  a2ad9e:	02078ebb          	beqi	a5,2,a2add8 <hal_pmp_riscv31_regs_set_pmpxcfg+0x46>
  a2ada2:	031783bb          	beqi	a5,3,a2adf0 <hal_pmp_riscv31_regs_set_pmpxcfg+0x5e>
  a2ada6:	0141                	addi	sp,sp,16
  a2ada8:	8082                	ret
  a2adaa:	3a0027f3          	csrr	a5,pmpcfg0
  a2adae:	c63e                	sw	a5,12(sp)
  a2adb0:	081c                	addi	a5,sp,16
  a2adb2:	953e                	add	a0,a0,a5
  a2adb4:	feb50e23          	sb	a1,-4(a0)
  a2adb8:	47b2                	lw	a5,12(sp)
  a2adba:	3a079073          	csrw	pmpcfg0,a5
  a2adbe:	b7e5                	j	a2ada6 <hal_pmp_riscv31_regs_set_pmpxcfg+0x14>
  a2adc0:	3a1027f3          	csrr	a5,pmpcfg1
  a2adc4:	c63e                	sw	a5,12(sp)
  a2adc6:	890d                	andi	a0,a0,3
  a2adc8:	081c                	addi	a5,sp,16
  a2adca:	953e                	add	a0,a0,a5
  a2adcc:	feb50e23          	sb	a1,-4(a0)
  a2add0:	47b2                	lw	a5,12(sp)
  a2add2:	3a179073          	csrw	pmpcfg1,a5
  a2add6:	bfc1                	j	a2ada6 <hal_pmp_riscv31_regs_set_pmpxcfg+0x14>
  a2add8:	3a2027f3          	csrr	a5,pmpcfg2
  a2addc:	c63e                	sw	a5,12(sp)
  a2adde:	890d                	andi	a0,a0,3
  a2ade0:	081c                	addi	a5,sp,16
  a2ade2:	953e                	add	a0,a0,a5
  a2ade4:	feb50e23          	sb	a1,-4(a0)
  a2ade8:	47b2                	lw	a5,12(sp)
  a2adea:	3a279073          	csrw	pmpcfg2,a5
  a2adee:	bf65                	j	a2ada6 <hal_pmp_riscv31_regs_set_pmpxcfg+0x14>
  a2adf0:	3a3027f3          	csrr	a5,pmpcfg3
  a2adf4:	c63e                	sw	a5,12(sp)
  a2adf6:	890d                	andi	a0,a0,3
  a2adf8:	081c                	addi	a5,sp,16
  a2adfa:	953e                	add	a0,a0,a5
  a2adfc:	feb50e23          	sb	a1,-4(a0)
  a2ae00:	47b2                	lw	a5,12(sp)
  a2ae02:	3a379073          	csrw	pmpcfg3,a5
  a2ae06:	b745                	j	a2ada6 <hal_pmp_riscv31_regs_set_pmpxcfg+0x14>

00a2ae08 <hal_reboot_chip>:
  a2ae08:	8018                	push	{ra},-16
  a2ae0a:	be3fe0ef          	jal	ra,a299ec <osal_irq_lock>
  a2ae0e:	5ad020ef          	jal	ra,a2dbba <set_cpu_utils_system_boot_magic>
  a2ae12:	47f010ef          	jal	ra,a2ca90 <reboot_port_reboot_chip>
  a2ae16:	a001                	j	a2ae16 <hal_reboot_chip+0xe>

00a2ae18 <hal_rkp_lock>:
  a2ae18:	8048                	push	{ra,s0-s2},-16
  a2ae1a:	860ff0ef          	jal	ra,a29e7a <crypto_get_cpu_type>
  a2ae1e:	c509                	beqz	a0,a2ae28 <hal_rkp_lock+0x10>
  a2ae20:	01050cbb          	beqi	a0,1,a2ae52 <hal_rkp_lock+0x3a>
  a2ae24:	557d                	li	a0,-1
  a2ae26:	8044                	popret	{ra,s0-s2},16
  a2ae28:	4489                	li	s1,2
  a2ae2a:	000f 4240 041f      	l.li	s0,0xf4240
  a2ae30:	44112937          	lui	s2,0x44112
  a2ae34:	00992023          	sw	s1,0(s2) # 44112000 <_gp_+0x436dd7bc>
  a2ae38:	0ff0000f          	fence
  a2ae3c:	00092783          	lw	a5,0(s2)
  a2ae40:	8b9d                	andi	a5,a5,7
  a2ae42:	00978a63          	beq	a5,s1,a2ae56 <hal_rkp_lock+0x3e>
  a2ae46:	4505                	li	a0,1
  a2ae48:	147d                	addi	s0,s0,-1
  a2ae4a:	d62ff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2ae4e:	f07d                	bnez	s0,a2ae34 <hal_rkp_lock+0x1c>
  a2ae50:	bfd1                	j	a2ae24 <hal_rkp_lock+0xc>
  a2ae52:	4485                	li	s1,1
  a2ae54:	bfd9                	j	a2ae2a <hal_rkp_lock+0x12>
  a2ae56:	4501                	li	a0,0
  a2ae58:	b7f9                	j	a2ae26 <hal_rkp_lock+0xe>

00a2ae5a <hal_rkp_unlock>:
  a2ae5a:	441127b7          	lui	a5,0x44112
  a2ae5e:	0007a023          	sw	zero,0(a5) # 44112000 <_gp_+0x436dd7bc>
  a2ae62:	0ff0000f          	fence
  a2ae66:	4501                	li	a0,0
  a2ae68:	8082                	ret

00a2ae6a <hal_rkp_kdf_wait_done>:
  a2ae6a:	8138                	push	{ra,s0-s1},-32
  a2ae6c:	57fd                	li	a5,-1
  a2ae6e:	c63e                	sw	a5,12(sp)
  a2ae70:	000f 4240 041f      	l.li	s0,0xf4240
  a2ae76:	441124b7          	lui	s1,0x44112
  a2ae7a:	40dc                	lw	a5,4(s1)
  a2ae7c:	8b85                	andi	a5,a5,1
  a2ae7e:	ef91                	bnez	a5,a2ae9a <hal_rkp_kdf_wait_done+0x30>
  a2ae80:	4785                	li	a5,1
  a2ae82:	c89c                	sw	a5,16(s1)
  a2ae84:	0ff0000f          	fence
  a2ae88:	c602                	sw	zero,12(sp)
  a2ae8a:	441127b7          	lui	a5,0x44112
  a2ae8e:	479c                	lw	a5,8(a5)
  a2ae90:	c399                	beqz	a5,a2ae96 <hal_rkp_kdf_wait_done+0x2c>
  a2ae92:	57fd                	li	a5,-1
  a2ae94:	c63e                	sw	a5,12(sp)
  a2ae96:	4532                	lw	a0,12(sp)
  a2ae98:	8134                	popret	{ra,s0-s1},32
  a2ae9a:	4505                	li	a0,1
  a2ae9c:	147d                	addi	s0,s0,-1
  a2ae9e:	d0eff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2aea2:	fc61                	bnez	s0,a2ae7a <hal_rkp_kdf_wait_done+0x10>
  a2aea4:	57fd                	li	a5,-1
  a2aea6:	c63e                	sw	a5,12(sp)
  a2aea8:	b7cd                	j	a2ae8a <hal_rkp_kdf_wait_done+0x20>

00a2aeaa <hal_rkp_kdf_hard_calculation>:
  a2aeaa:	8238                	push	{ra,s0-s1},-48
  a2aeac:	57fd                	li	a5,-1
  a2aeae:	c63e                	sw	a5,12(sp)
  a2aeb0:	c802                	sw	zero,16(sp)
  a2aeb2:	ca02                	sw	zero,20(sp)
  a2aeb4:	cc02                	sw	zero,24(sp)
  a2aeb6:	ce02                	sw	zero,28(sp)
  a2aeb8:	0e050863          	beqz	a0,a2afa8 <hal_rkp_kdf_hard_calculation+0xfe>
  a2aebc:	4504                	lw	s1,8(a0)
  a2aebe:	c485                	beqz	s1,a2aee6 <hal_rkp_kdf_hard_calculation+0x3c>
  a2aec0:	4558                	lw	a4,12(a0)
  a2aec2:	1c07193b          	bnei	a4,28,a2aee6 <hal_rkp_kdf_hard_calculation+0x3c>
  a2aec6:	2158                	lbu	a4,4(a0)
  a2aec8:	020777bb          	bgeui	a4,2,a2aee6 <hal_rkp_kdf_hard_calculation+0x3c>
  a2aecc:	4110                	lw	a2,0(a0)
  a2aece:	842a                	mv	s0,a0
  a2aed0:	0814                	addi	a3,sp,16
  a2aed2:	458d                	li	a1,3
  a2aed4:	00a3 3eb8 051f      	l.li	a0,0xa33eb8
  a2aeda:	fb9fe0ef          	jal	ra,a29e92 <crypto_get_value_by_index>
  a2aede:	c62a                	sw	a0,12(sp)
  a2aee0:	47b2                	lw	a5,12(sp)
  a2aee2:	c781                	beqz	a5,a2aeea <hal_rkp_kdf_hard_calculation+0x40>
  a2aee4:	47b2                	lw	a5,12(sp)
  a2aee6:	853e                	mv	a0,a5
  a2aee8:	8234                	popret	{ra,s0-s1},48
  a2aeea:	4010                	lw	a2,0(s0)
  a2aeec:	0874                	addi	a3,sp,28
  a2aeee:	458d                	li	a1,3
  a2aef0:	00a3 3ed0 051f      	l.li	a0,0xa33ed0
  a2aef6:	f9dfe0ef          	jal	ra,a29e92 <crypto_get_value_by_index>
  a2aefa:	c62a                	sw	a0,12(sp)
  a2aefc:	47b2                	lw	a5,12(sp)
  a2aefe:	f3fd                	bnez	a5,a2aee4 <hal_rkp_kdf_hard_calculation+0x3a>
  a2af00:	2050                	lbu	a2,4(s0)
  a2af02:	0854                	addi	a3,sp,20
  a2af04:	4589                	li	a1,2
  a2af06:	00a3 3e90 051f      	l.li	a0,0xa33e90
  a2af0c:	f87fe0ef          	jal	ra,a29e92 <crypto_get_value_by_index>
  a2af10:	c62a                	sw	a0,12(sp)
  a2af12:	47b2                	lw	a5,12(sp)
  a2af14:	fbe1                	bnez	a5,a2aee4 <hal_rkp_kdf_hard_calculation+0x3a>
  a2af16:	3050                	lbu	a2,5(s0)
  a2af18:	0834                	addi	a3,sp,24
  a2af1a:	458d                	li	a1,3
  a2af1c:	00a3 3ea0 051f      	l.li	a0,0xa33ea0
  a2af22:	f71fe0ef          	jal	ra,a29e92 <crypto_get_value_by_index>
  a2af26:	c62a                	sw	a0,12(sp)
  a2af28:	47b2                	lw	a5,12(sp)
  a2af2a:	ffcd                	bnez	a5,a2aee4 <hal_rkp_kdf_hard_calculation+0x3a>
  a2af2c:	44112737          	lui	a4,0x44112
  a2af30:	281c                	lbu	a5,16(s0)
  a2af32:	4672                	lw	a2,28(sp)
  a2af34:	36072683          	lw	a3,864(a4) # 44112360 <_gp_+0x436ddb1c>
  a2af38:	00c797b3          	sll	a5,a5,a2
  a2af3c:	8fd5                	or	a5,a5,a3
  a2af3e:	36f72023          	sw	a5,864(a4)
  a2af42:	0ff0000f          	fence
  a2af46:	4701                	li	a4,0
  a2af48:	87a6                	mv	a5,s1
  a2af4a:	1104 48d0 061f      	l.li	a2,0x110448d0
  a2af50:	4454                	lw	a3,12(s0)
  a2af52:	8289                	srli	a3,a3,0x2
  a2af54:	04d76063          	bltu	a4,a3,a2af94 <hal_rkp_kdf_hard_calculation+0xea>
  a2af58:	44112637          	lui	a2,0x44112
  a2af5c:	425c                	lw	a5,4(a2)
  a2af5e:	4762                	lw	a4,24(sp)
  a2af60:	76d1                	lui	a3,0xffff4
  a2af62:	16fd                	addi	a3,a3,-1 # ffff3fff <_gp_+0xff5bf7bb>
  a2af64:	8b0d                	andi	a4,a4,3
  a2af66:	8ff5                	and	a5,a5,a3
  a2af68:	1ce7a79b          	orshf	a5,a5,a4,sll,14
  a2af6c:	4752                	lw	a4,20(sp)
  a2af6e:	9bc5                	andi	a5,a5,-15
  a2af70:	8b1d                	andi	a4,a4,7
  a2af72:	02e7a79b          	orshf	a5,a5,a4,sll,1
  a2af76:	4742                	lw	a4,16(sp)
  a2af78:	e0f7f793          	andi	a5,a5,-497
  a2af7c:	8b7d                	andi	a4,a4,31
  a2af7e:	08e7a79b          	orshf	a5,a5,a4,sll,4
  a2af82:	0017e793          	ori	a5,a5,1
  a2af86:	c25c                	sw	a5,4(a2)
  a2af88:	0ff0000f          	fence
  a2af8c:	3df9                	jal	ra,a2ae6a <hal_rkp_kdf_wait_done>
  a2af8e:	c62a                	sw	a0,12(sp)
  a2af90:	47b2                	lw	a5,12(sp)
  a2af92:	bf89                	j	a2aee4 <hal_rkp_kdf_hard_calculation+0x3a>
  a2af94:	438c                	lw	a1,0(a5)
  a2af96:	00c706b3          	add	a3,a4,a2
  a2af9a:	068a                	slli	a3,a3,0x2
  a2af9c:	c28c                	sw	a1,0(a3)
  a2af9e:	0ff0000f          	fence
  a2afa2:	0705                	addi	a4,a4,1
  a2afa4:	0791                	addi	a5,a5,4 # 44112004 <_gp_+0x436dd7c0>
  a2afa6:	b76d                	j	a2af50 <hal_rkp_kdf_hard_calculation+0xa6>
  a2afa8:	57fd                	li	a5,-1
  a2afaa:	bf35                	j	a2aee6 <hal_rkp_kdf_hard_calculation+0x3c>

00a2afac <inner_kslot_chn_is_locked>:
  a2afac:	44114737          	lui	a4,0x44114
  a2afb0:	b3072783          	lw	a5,-1232(a4) # 44113b30 <_gp_+0x436df2ec>
  a2afb4:	76e1                	lui	a3,0xffff8
  a2afb6:	16fd                	addi	a3,a3,-1 # ffff7fff <_gp_+0xff5c37bb>
  a2afb8:	8985                	andi	a1,a1,1
  a2afba:	8ff5                	and	a5,a5,a3
  a2afbc:	1eb7a79b          	orshf	a5,a5,a1,sll,15
  a2afc0:	3ff57513          	andi	a0,a0,1023
  a2afc4:	c007f793          	andi	a5,a5,-1024
  a2afc8:	8fc9                	or	a5,a5,a0
  a2afca:	b2f72823          	sw	a5,-1232(a4)
  a2afce:	0ff0000f          	fence
  a2afd2:	b3472503          	lw	a0,-1228(a4)
  a2afd6:	891d                	andi	a0,a0,7
  a2afd8:	c211                	beqz	a2,a2afdc <inner_kslot_chn_is_locked+0x30>
  a2afda:	c208                	sw	a0,0(a2)
  a2afdc:	00a03533          	snez	a0,a0
  a2afe0:	8082                	ret

00a2afe2 <inner_chk_kslot_busy>:
  a2afe2:	8028                	push	{ra,s0},-16
  a2afe4:	842a                	mv	s0,a0
  a2afe6:	e95fe0ef          	jal	ra,a29e7a <crypto_get_cpu_type>
  a2afea:	c911                	beqz	a0,a2affe <inner_chk_kslot_busy+0x1c>
  a2afec:	0105173b          	bnei	a0,1,a2b008 <inner_chk_kslot_busy+0x26>
  a2aff0:	441147b7          	lui	a5,0x44114
  a2aff4:	b147a783          	lw	a5,-1260(a5) # 44113b14 <_gp_+0x436df2d0>
  a2aff8:	c01c                	sw	a5,0(s0)
  a2affa:	4501                	li	a0,0
  a2affc:	8024                	popret	{ra,s0},16
  a2affe:	441147b7          	lui	a5,0x44114
  a2b002:	b107a783          	lw	a5,-1264(a5) # 44113b10 <_gp_+0x436df2cc>
  a2b006:	bfcd                	j	a2aff8 <inner_chk_kslot_busy+0x16>
  a2b008:	4505                	li	a0,1
  a2b00a:	bfcd                	j	a2affc <inner_chk_kslot_busy+0x1a>

00a2b00c <inner_kslot_is_busy>:
  a2b00c:	8118                	push	{ra},-32
  a2b00e:	0068                	addi	a0,sp,12
  a2b010:	c602                	sw	zero,12(sp)
  a2b012:	3fc1                	jal	ra,a2afe2 <inner_chk_kslot_busy>
  a2b014:	4785                	li	a5,1
  a2b016:	e119                	bnez	a0,a2b01c <inner_kslot_is_busy+0x10>
  a2b018:	47b2                	lw	a5,12(sp)
  a2b01a:	8b85                	andi	a5,a5,1
  a2b01c:	853e                	mv	a0,a5
  a2b01e:	8114                	popret	{ra},32

00a2b020 <hal_keyslot_lock>:
  a2b020:	8248                	push	{ra,s0-s2},-48
  a2b022:	57fd                	li	a5,-1
  a2b024:	c62e                	sw	a1,12(sp)
  a2b026:	84aa                	mv	s1,a0
  a2b028:	cc3e                	sw	a5,24(sp)
  a2b02a:	e51fe0ef          	jal	ra,a29e7a <crypto_get_cpu_type>
  a2b02e:	45b2                	lw	a1,12(sp)
  a2b030:	ce02                	sw	zero,28(sp)
  a2b032:	892a                	mv	s2,a0
  a2b034:	c591                	beqz	a1,a2b040 <hal_keyslot_lock+0x20>
  a2b036:	0105863b          	beqi	a1,1,a2b04e <hal_keyslot_lock+0x2e>
  a2b03a:	4401                	li	s0,0
  a2b03c:	57fd                	li	a5,-1
  a2b03e:	a019                	j	a2b044 <hal_keyslot_lock+0x24>
  a2b040:	4401                	li	s0,0
  a2b042:	4781                	li	a5,0
  a2b044:	cc3e                	sw	a5,24(sp)
  a2b046:	47e2                	lw	a5,24(sp)
  a2b048:	c789                	beqz	a5,a2b052 <hal_keyslot_lock+0x32>
  a2b04a:	4562                	lw	a0,24(sp)
  a2b04c:	8244                	popret	{ra,s0-s2},48
  a2b04e:	4405                	li	s0,1
  a2b050:	bfcd                	j	a2b042 <hal_keyslot_lock+0x22>
  a2b052:	4601                	li	a2,0
  a2b054:	85a2                	mv	a1,s0
  a2b056:	8526                	mv	a0,s1
  a2b058:	3f91                	jal	ra,a2afac <inner_kslot_chn_is_locked>
  a2b05a:	c119                	beqz	a0,a2b060 <hal_keyslot_lock+0x40>
  a2b05c:	557d                	li	a0,-1
  a2b05e:	b7fd                	j	a2b04c <hal_keyslot_lock+0x2c>
  a2b060:	3775                	jal	ra,a2b00c <inner_kslot_is_busy>
  a2b062:	fd6d                	bnez	a0,a2b05c <hal_keyslot_lock+0x3c>
  a2b064:	04091763          	bnez	s2,a2b0b2 <hal_keyslot_lock+0x92>
  a2b068:	4909                	li	s2,2
  a2b06a:	0000 1b00 071f      	l.li	a4,0x1b00
  a2b070:	441127b7          	lui	a5,0x44112
  a2b074:	973e                	add	a4,a4,a5
  a2b076:	431c                	lw	a5,0(a4)
  a2b078:	76e1                	lui	a3,0xffff8
  a2b07a:	16fd                	addi	a3,a3,-1 # ffff7fff <_gp_+0xff5c37bb>
  a2b07c:	8ff5                	and	a5,a5,a3
  a2b07e:	1e87a79b          	orshf	a5,a5,s0,sll,15
  a2b082:	3ff4f693          	andi	a3,s1,1023
  a2b086:	c007f793          	andi	a5,a5,-1024
  a2b08a:	8fd5                	or	a5,a5,a3
  a2b08c:	001006b7          	lui	a3,0x100
  a2b090:	8fd5                	or	a5,a5,a3
  a2b092:	c31c                	sw	a5,0(a4)
  a2b094:	0ff0000f          	fence
  a2b098:	0870                	addi	a2,sp,28
  a2b09a:	85a2                	mv	a1,s0
  a2b09c:	8526                	mv	a0,s1
  a2b09e:	3739                	jal	ra,a2afac <inner_kslot_chn_is_locked>
  a2b0a0:	dd55                	beqz	a0,a2b05c <hal_keyslot_lock+0x3c>
  a2b0a2:	4572                	lw	a0,28(sp)
  a2b0a4:	41250533          	sub	a0,a0,s2
  a2b0a8:	00a03533          	snez	a0,a0
  a2b0ac:	40a00533          	neg	a0,a0
  a2b0b0:	bf71                	j	a2b04c <hal_keyslot_lock+0x2c>
  a2b0b2:	4905                	li	s2,1
  a2b0b4:	0000 1b04 071f      	l.li	a4,0x1b04
  a2b0ba:	bf5d                	j	a2b070 <hal_keyslot_lock+0x50>

00a2b0bc <hal_keyslot_unlock>:
  a2b0bc:	8248                	push	{ra,s0-s2},-48
  a2b0be:	57fd                	li	a5,-1
  a2b0c0:	c62e                	sw	a1,12(sp)
  a2b0c2:	842a                	mv	s0,a0
  a2b0c4:	cc3e                	sw	a5,24(sp)
  a2b0c6:	db5fe0ef          	jal	ra,a29e7a <crypto_get_cpu_type>
  a2b0ca:	45b2                	lw	a1,12(sp)
  a2b0cc:	892a                	mv	s2,a0
  a2b0ce:	c591                	beqz	a1,a2b0da <hal_keyslot_unlock+0x1e>
  a2b0d0:	010586bb          	beqi	a1,1,a2b0ea <hal_keyslot_unlock+0x2e>
  a2b0d4:	4481                	li	s1,0
  a2b0d6:	57fd                	li	a5,-1
  a2b0d8:	a019                	j	a2b0de <hal_keyslot_unlock+0x22>
  a2b0da:	4481                	li	s1,0
  a2b0dc:	4781                	li	a5,0
  a2b0de:	cc3e                	sw	a5,24(sp)
  a2b0e0:	47e2                	lw	a5,24(sp)
  a2b0e2:	c791                	beqz	a5,a2b0ee <hal_keyslot_unlock+0x32>
  a2b0e4:	47e2                	lw	a5,24(sp)
  a2b0e6:	853e                	mv	a0,a5
  a2b0e8:	8244                	popret	{ra,s0-s2},48
  a2b0ea:	4485                	li	s1,1
  a2b0ec:	bfc5                	j	a2b0dc <hal_keyslot_unlock+0x20>
  a2b0ee:	3f39                	jal	ra,a2b00c <inner_kslot_is_busy>
  a2b0f0:	57fd                	li	a5,-1
  a2b0f2:	f975                	bnez	a0,a2b0e6 <hal_keyslot_unlock+0x2a>
  a2b0f4:	4601                	li	a2,0
  a2b0f6:	85a6                	mv	a1,s1
  a2b0f8:	8522                	mv	a0,s0
  a2b0fa:	3d4d                	jal	ra,a2afac <inner_kslot_chn_is_locked>
  a2b0fc:	4781                	li	a5,0
  a2b0fe:	d565                	beqz	a0,a2b0e6 <hal_keyslot_unlock+0x2a>
  a2b100:	06090363          	beqz	s2,a2b166 <hal_keyslot_unlock+0xaa>
  a2b104:	011917bb          	bnei	s2,1,a2b162 <hal_keyslot_unlock+0xa6>
  a2b108:	0000 1b04 079f      	l.li	a5,0x1b04
  a2b10e:	44112737          	lui	a4,0x44112
  a2b112:	97ba                	add	a5,a5,a4
  a2b114:	4388                	lw	a0,0(a5)
  a2b116:	7761                	lui	a4,0xffff8
  a2b118:	177d                	addi	a4,a4,-1 # ffff7fff <_gp_+0xff5c37bb>
  a2b11a:	8d79                	and	a0,a0,a4
  a2b11c:	1e95251b          	orshf	a0,a0,s1,sll,15
  a2b120:	3ff47413          	andi	s0,s0,1023
  a2b124:	c0057513          	andi	a0,a0,-1024
  a2b128:	8d41                	or	a0,a0,s0
  a2b12a:	ffef ffff 071f      	l.li	a4,0xffefffff
  a2b130:	8d79                	and	a0,a0,a4
  a2b132:	c388                	sw	a0,0(a5)
  a2b134:	0ff0000f          	fence
  a2b138:	000f 4240 041f      	l.li	s0,0xf4240
  a2b13e:	35f9                	jal	ra,a2b00c <inner_kslot_is_busy>
  a2b140:	c51d                	beqz	a0,a2b16e <hal_keyslot_unlock+0xb2>
  a2b142:	4505                	li	a0,1
  a2b144:	147d                	addi	s0,s0,-1
  a2b146:	a66ff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2b14a:	f875                	bnez	s0,a2b13e <hal_keyslot_unlock+0x82>
  a2b14c:	57fd                	li	a5,-1
  a2b14e:	cc3e                	sw	a5,24(sp)
  a2b150:	47e2                	lw	a5,24(sp)
  a2b152:	fbc9                	bnez	a5,a2b0e4 <hal_keyslot_unlock+0x28>
  a2b154:	0868                	addi	a0,sp,28
  a2b156:	ce02                	sw	zero,28(sp)
  a2b158:	3569                	jal	ra,a2afe2 <inner_chk_kslot_busy>
  a2b15a:	e501                	bnez	a0,a2b162 <hal_keyslot_unlock+0xa6>
  a2b15c:	47f2                	lw	a5,28(sp)
  a2b15e:	8b89                	andi	a5,a5,2
  a2b160:	d3d9                	beqz	a5,a2b0e6 <hal_keyslot_unlock+0x2a>
  a2b162:	57fd                	li	a5,-1
  a2b164:	b749                	j	a2b0e6 <hal_keyslot_unlock+0x2a>
  a2b166:	0000 1b00 079f      	l.li	a5,0x1b00
  a2b16c:	b74d                	j	a2b10e <hal_keyslot_unlock+0x52>
  a2b16e:	4781                	li	a5,0
  a2b170:	bff9                	j	a2b14e <hal_keyslot_unlock+0x92>

00a2b172 <inner_klad_set_key_odd>:
  a2b172:	441137b7          	lui	a5,0x44113
  a2b176:	4b98                	lw	a4,16(a5)
  a2b178:	ffe77793          	andi	a5,a4,-2
  a2b17c:	c119                	beqz	a0,a2b182 <inner_klad_set_key_odd+0x10>
  a2b17e:	00176793          	ori	a5,a4,1
  a2b182:	44113737          	lui	a4,0x44113
  a2b186:	cb1c                	sw	a5,16(a4)
  a2b188:	0ff0000f          	fence
  a2b18c:	8082                	ret

00a2b18e <inner_klad_wait_com_route_done>:
  a2b18e:	8138                	push	{ra,s0-s1},-32
  a2b190:	57fd                	li	a5,-1
  a2b192:	c23e                	sw	a5,4(sp)
  a2b194:	000f 4240 041f      	l.li	s0,0xf4240
  a2b19a:	441134b7          	lui	s1,0x44113
  a2b19e:	0844a783          	lw	a5,132(s1) # 44113084 <_gp_+0x436de840>
  a2b1a2:	8b85                	andi	a5,a5,1
  a2b1a4:	eb85                	bnez	a5,a2b1d4 <inner_klad_wait_com_route_done+0x46>
  a2b1a6:	40fc                	lw	a5,68(s1)
  a2b1a8:	0017e793          	ori	a5,a5,1
  a2b1ac:	c43e                	sw	a5,8(sp)
  a2b1ae:	c0fc                	sw	a5,68(s1)
  a2b1b0:	0ff0000f          	fence
  a2b1b4:	c202                	sw	zero,4(sp)
  a2b1b6:	44113737          	lui	a4,0x44113
  a2b1ba:	08872783          	lw	a5,136(a4) # 44113088 <_gp_+0x436de844>
  a2b1be:	5f1c                	lw	a5,56(a4)
  a2b1c0:	5f58                	lw	a4,60(a4)
  a2b1c2:	8fd9                	or	a5,a5,a4
  a2b1c4:	00f037b3          	snez	a5,a5
  a2b1c8:	40f007b3          	neg	a5,a5
  a2b1cc:	c23e                	sw	a5,4(sp)
  a2b1ce:	4792                	lw	a5,4(sp)
  a2b1d0:	4512                	lw	a0,4(sp)
  a2b1d2:	8134                	popret	{ra,s0-s1},32
  a2b1d4:	4505                	li	a0,1
  a2b1d6:	147d                	addi	s0,s0,-1
  a2b1d8:	9d4ff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2b1dc:	f069                	bnez	s0,a2b19e <inner_klad_wait_com_route_done+0x10>
  a2b1de:	bfe1                	j	a2b1b6 <inner_klad_wait_com_route_done+0x28>

00a2b1e0 <hal_klad_lock>:
  a2b1e0:	8158                	push	{ra,s0-s3},-48
  a2b1e2:	57fd                	li	a5,-1
  a2b1e4:	c63e                	sw	a5,12(sp)
  a2b1e6:	0000 2710 041f      	l.li	s0,0x2710
  a2b1ec:	4905                	li	s2,1
  a2b1ee:	441134b7          	lui	s1,0x44113
  a2b1f2:	4991                	li	s3,4
  a2b1f4:	c87fe0ef          	jal	ra,a29e7a <crypto_get_cpu_type>
  a2b1f8:	57fd                	li	a5,-1
  a2b1fa:	03251463          	bne	a0,s2,a2b222 <hal_klad_lock+0x42>
  a2b1fe:	0724aa23          	sw	s2,116(s1) # 44113074 <_gp_+0x436de830>
  a2b202:	0ff0000f          	fence
  a2b206:	5cf8                	lw	a4,124(s1)
  a2b208:	57fd                	li	a5,-1
  a2b20a:	8b31                	andi	a4,a4,12
  a2b20c:	01370b63          	beq	a4,s3,a2b222 <hal_klad_lock+0x42>
  a2b210:	0804a783          	lw	a5,128(s1)
  a2b214:	9f81                	uxtb	a5
  a2b216:	f5678793          	addi	a5,a5,-170 # 44112f56 <_gp_+0x436de712>
  a2b21a:	00f037b3          	snez	a5,a5
  a2b21e:	40f007b3          	neg	a5,a5
  a2b222:	c63e                	sw	a5,12(sp)
  a2b224:	47b2                	lw	a5,12(sp)
  a2b226:	cb81                	beqz	a5,a2b236 <hal_klad_lock+0x56>
  a2b228:	4505                	li	a0,1
  a2b22a:	147d                	addi	s0,s0,-1
  a2b22c:	980ff0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2b230:	f071                	bnez	s0,a2b1f4 <hal_klad_lock+0x14>
  a2b232:	557d                	li	a0,-1
  a2b234:	8154                	popret	{ra,s0-s3},48
  a2b236:	4501                	li	a0,0
  a2b238:	bff5                	j	a2b234 <hal_klad_lock+0x54>

00a2b23a <hal_klad_unlock>:
  a2b23a:	8018                	push	{ra},-16
  a2b23c:	c3ffe0ef          	jal	ra,a29e7a <crypto_get_cpu_type>
  a2b240:	01051cbb          	bnei	a0,1,a2b272 <hal_klad_unlock+0x38>
  a2b244:	44113737          	lui	a4,0x44113
  a2b248:	08072683          	lw	a3,128(a4) # 44113080 <_gp_+0x436de83c>
  a2b24c:	0aa00613          	li	a2,170
  a2b250:	4781                	li	a5,0
  a2b252:	9e81                	uxtb	a3
  a2b254:	00c69d63          	bne	a3,a2,a2b26e <hal_klad_unlock+0x34>
  a2b258:	df28                	sw	a0,120(a4)
  a2b25a:	0ff0000f          	fence
  a2b25e:	5f7c                	lw	a5,124(a4)
  a2b260:	0307f793          	andi	a5,a5,48
  a2b264:	17c1                	addi	a5,a5,-16
  a2b266:	0017b793          	seqz	a5,a5
  a2b26a:	40f007b3          	neg	a5,a5
  a2b26e:	853e                	mv	a0,a5
  a2b270:	8014                	popret	{ra},16
  a2b272:	57fd                	li	a5,-1
  a2b274:	bfed                	j	a2b26e <hal_klad_unlock+0x34>

00a2b276 <hal_klad_set_key_crypto_cfg>:
  a2b276:	0a000793          	li	a5,160
  a2b27a:	02f60563          	beq	a2,a5,a2b2a4 <hal_klad_set_key_crypto_cfg+0x2e>
  a2b27e:	00c7e963          	bltu	a5,a2,a2b290 <hal_klad_set_key_crypto_cfg+0x1a>
  a2b282:	05000693          	li	a3,80
  a2b286:	200615bb          	bnei	a2,32,a2b29c <hal_klad_set_key_crypto_cfg+0x26>
  a2b28a:	02000693          	li	a3,32
  a2b28e:	a829                	j	a2b2a8 <hal_klad_set_key_crypto_cfg+0x32>
  a2b290:	0a100793          	li	a5,161
  a2b294:	04f60363          	beq	a2,a5,a2b2da <hal_klad_set_key_crypto_cfg+0x64>
  a2b298:	0a200693          	li	a3,162
  a2b29c:	00d60663          	beq	a2,a3,a2b2a8 <hal_klad_set_key_crypto_cfg+0x32>
  a2b2a0:	557d                	li	a0,-1
  a2b2a2:	8082                	ret
  a2b2a4:	0a000693          	li	a3,160
  a2b2a8:	44113637          	lui	a2,0x44113
  a2b2ac:	4a58                	lw	a4,20(a2)
  a2b2ae:	7781                	lui	a5,0xfffe0
  a2b2b0:	17fd                	addi	a5,a5,-1 # fffdffff <_gp_+0xff5ab7bb>
  a2b2b2:	8ff9                	and	a5,a5,a4
  a2b2b4:	8985                	andi	a1,a1,1
  a2b2b6:	22b7a59b          	orshf	a1,a5,a1,sll,17
  a2b2ba:	77c1                	lui	a5,0xffff0
  a2b2bc:	17fd                	addi	a5,a5,-1 # fffeffff <_gp_+0xff5bb7bb>
  a2b2be:	8905                	andi	a0,a0,1
  a2b2c0:	8fed                	and	a5,a5,a1
  a2b2c2:	20a7a79b          	orshf	a5,a5,a0,sll,16
  a2b2c6:	757d                	lui	a0,0xfffff
  a2b2c8:	053d                	addi	a0,a0,15 # fffff00f <_gp_+0xff5ca7cb>
  a2b2ca:	8fe9                	and	a5,a5,a0
  a2b2cc:	08d7a79b          	orshf	a5,a5,a3,sll,4
  a2b2d0:	ca5c                	sw	a5,20(a2)
  a2b2d2:	0ff0000f          	fence
  a2b2d6:	4501                	li	a0,0
  a2b2d8:	8082                	ret
  a2b2da:	0a100693          	li	a3,161
  a2b2de:	b7e9                	j	a2b2a8 <hal_klad_set_key_crypto_cfg+0x32>

00a2b2e0 <hal_klad_set_key_dest_cfg>:
  a2b2e0:	0205633b          	bltui	a0,2,a2b2ec <hal_klad_set_key_dest_cfg+0xc>
  a2b2e4:	02050bbb          	beqi	a0,2,a2b312 <hal_klad_set_key_dest_cfg+0x32>
  a2b2e8:	557d                	li	a0,-1
  a2b2ea:	8082                	ret
  a2b2ec:	4705                	li	a4,1
  a2b2ee:	441137b7          	lui	a5,0x44113
  a2b2f2:	4bdc                	lw	a5,20(a5)
  a2b2f4:	9be1                	andi	a5,a5,-8
  a2b2f6:	8fd9                	or	a5,a5,a4
  a2b2f8:	0205133b          	bnei	a0,2,a2b304 <hal_klad_set_key_dest_cfg+0x24>
  a2b2fc:	fff3 ffff 071f      	l.li	a4,0xfff3ffff
  a2b302:	8ff9                	and	a5,a5,a4
  a2b304:	44113737          	lui	a4,0x44113
  a2b308:	cb5c                	sw	a5,20(a4)
  a2b30a:	0ff0000f          	fence
  a2b30e:	4501                	li	a0,0
  a2b310:	8082                	ret
  a2b312:	471d                	li	a4,7
  a2b314:	dde9                	beqz	a1,a2b2ee <hal_klad_set_key_dest_cfg+0xe>
  a2b316:	bfc9                	j	a2b2e8 <hal_klad_set_key_dest_cfg+0x8>

00a2b318 <hal_klad_set_key_secure_cfg>:
  a2b318:	c539                	beqz	a0,a2b366 <hal_klad_set_key_secure_cfg+0x4e>
  a2b31a:	441136b7          	lui	a3,0x44113
  a2b31e:	4e9c                	lw	a5,24(a3)
  a2b320:	3118                	lbu	a4,1(a0)
  a2b322:	fdf7f793          	andi	a5,a5,-33
  a2b326:	8b05                	andi	a4,a4,1
  a2b328:	0ae7a79b          	orshf	a5,a5,a4,sll,5
  a2b32c:	2138                	lbu	a4,2(a0)
  a2b32e:	9bbd                	andi	a5,a5,-17
  a2b330:	8b05                	andi	a4,a4,1
  a2b332:	08e7a79b          	orshf	a5,a5,a4,sll,4
  a2b336:	3138                	lbu	a4,3(a0)
  a2b338:	9bdd                	andi	a5,a5,-9
  a2b33a:	8b05                	andi	a4,a4,1
  a2b33c:	06e7a79b          	orshf	a5,a5,a4,sll,3
  a2b340:	2158                	lbu	a4,4(a0)
  a2b342:	9bed                	andi	a5,a5,-5
  a2b344:	8b05                	andi	a4,a4,1
  a2b346:	04e7a79b          	orshf	a5,a5,a4,sll,2
  a2b34a:	3158                	lbu	a4,5(a0)
  a2b34c:	9bf5                	andi	a5,a5,-3
  a2b34e:	8b05                	andi	a4,a4,1
  a2b350:	02e7a79b          	orshf	a5,a5,a4,sll,1
  a2b354:	2118                	lbu	a4,0(a0)
  a2b356:	9bf9                	andi	a5,a5,-2
  a2b358:	8b05                	andi	a4,a4,1
  a2b35a:	8fd9                	or	a5,a5,a4
  a2b35c:	ce9c                	sw	a5,24(a3)
  a2b35e:	0ff0000f          	fence
  a2b362:	4501                	li	a0,0
  a2b364:	8082                	ret
  a2b366:	557d                	li	a0,-1
  a2b368:	8082                	ret

00a2b36a <hal_klad_set_key_addr>:
  a2b36a:	e105                	bnez	a0,a2b38a <hal_klad_set_key_addr+0x20>
  a2b36c:	44113737          	lui	a4,0x44113
  a2b370:	4b1c                	lw	a5,16(a4)
  a2b372:	0586                	slli	a1,a1,0x1
  a2b374:	3fe5f593          	andi	a1,a1,1022
  a2b378:	c007f793          	andi	a5,a5,-1024
  a2b37c:	8ddd                	or	a1,a1,a5
  a2b37e:	cb0c                	sw	a1,16(a4)
  a2b380:	0ff0000f          	fence
  a2b384:	4781                	li	a5,0
  a2b386:	853e                	mv	a0,a5
  a2b388:	8082                	ret
  a2b38a:	57fd                	li	a5,-1
  a2b38c:	01f51ebb          	bnei	a0,1,a2b386 <hal_klad_set_key_addr+0x1c>
  a2b390:	44113737          	lui	a4,0x44113
  a2b394:	4b1c                	lw	a5,16(a4)
  a2b396:	3ff5f593          	andi	a1,a1,1023
  a2b39a:	bff9                	j	a2b378 <hal_klad_set_key_addr+0xe>

00a2b39c <hal_klad_start_com_route>:
  a2b39c:	8148                	push	{ra,s0-s2},-32
  a2b39e:	57fd                	li	a5,-1
  a2b3a0:	c23e                	sw	a5,4(sp)
  a2b3a2:	c402                	sw	zero,8(sp)
  a2b3a4:	c602                	sw	zero,12(sp)
  a2b3a6:	cdc5                	beqz	a1,a2b45e <hal_klad_start_com_route+0xc2>
  a2b3a8:	41d8                	lw	a4,4(a1)
  a2b3aa:	cf19                	beqz	a4,a2b3c8 <hal_klad_start_com_route+0x2c>
  a2b3ac:	8932                	mv	s2,a2
  a2b3ae:	84ae                	mv	s1,a1
  a2b3b0:	862a                	mv	a2,a0
  a2b3b2:	0074                	addi	a3,sp,12
  a2b3b4:	458d                	li	a1,3
  a2b3b6:	00a3 3f00 051f      	l.li	a0,0xa33f00
  a2b3bc:	ad7fe0ef          	jal	ra,a29e92 <crypto_get_value_by_index>
  a2b3c0:	c22a                	sw	a0,4(sp)
  a2b3c2:	4792                	lw	a5,4(sp)
  a2b3c4:	c781                	beqz	a5,a2b3cc <hal_klad_start_com_route+0x30>
  a2b3c6:	4792                	lw	a5,4(sp)
  a2b3c8:	853e                	mv	a0,a5
  a2b3ca:	8144                	popret	{ra,s0-s2},32
  a2b3cc:	20b0                	lbu	a2,2(s1)
  a2b3ce:	0034                	addi	a3,sp,8
  a2b3d0:	458d                	li	a1,3
  a2b3d2:	00a3 3ee8 051f      	l.li	a0,0xa33ee8
  a2b3d8:	abbfe0ef          	jal	ra,a29e92 <crypto_get_value_by_index>
  a2b3dc:	c22a                	sw	a0,4(sp)
  a2b3de:	4792                	lw	a5,4(sp)
  a2b3e0:	f3fd                	bnez	a5,a2b3c6 <hal_klad_start_com_route+0x2a>
  a2b3e2:	20bc                	lbu	a5,2(s1)
  a2b3e4:	4501                	li	a0,0
  a2b3e6:	e391                	bnez	a5,a2b3ea <hal_klad_start_com_route+0x4e>
  a2b3e8:	3088                	lbu	a0,1(s1)
  a2b3ea:	00091463          	bnez	s2,a2b3f2 <hal_klad_start_com_route+0x56>
  a2b3ee:	d85ff0ef          	jal	ra,a2b172 <inner_klad_set_key_odd>
  a2b3f2:	4422                	lw	s0,8(sp)
  a2b3f4:	47b2                	lw	a5,12(sp)
  a2b3f6:	880d                	andi	s0,s0,3
  a2b3f8:	041a                	slli	s0,s0,0x6
  a2b3fa:	8bfd                	andi	a5,a5,31
  a2b3fc:	00146413          	ori	s0,s0,1
  a2b400:	10f4241b          	orshf	s0,s0,a5,sll,8
  a2b404:	441137b7          	lui	a5,0x44113
  a2b408:	0887a223          	sw	s0,132(a5) # 44113084 <_gp_+0x436de840>
  a2b40c:	0ff0000f          	fence
  a2b410:	d7fff0ef          	jal	ra,a2b18e <inner_klad_wait_com_route_done>
  a2b414:	c22a                	sw	a0,4(sp)
  a2b416:	4792                	lw	a5,4(sp)
  a2b418:	f7dd                	bnez	a5,a2b3c6 <hal_klad_start_com_route+0x2a>
  a2b41a:	20bc                	lbu	a5,2(s1)
  a2b41c:	d7cd                	beqz	a5,a2b3c6 <hal_klad_start_com_route+0x2a>
  a2b41e:	00091563          	bnez	s2,a2b428 <hal_klad_start_com_route+0x8c>
  a2b422:	4505                	li	a0,1
  a2b424:	d4fff0ef          	jal	ra,a2b172 <inner_klad_set_key_odd>
  a2b428:	47a2                	lw	a5,8(sp)
  a2b42a:	f3f47413          	andi	s0,s0,-193
  a2b42e:	ffff e0ff 071f      	l.li	a4,0xffffe0ff
  a2b434:	8b8d                	andi	a5,a5,3
  a2b436:	0cf4241b          	orshf	s0,s0,a5,sll,6
  a2b43a:	47b2                	lw	a5,12(sp)
  a2b43c:	8c79                	and	s0,s0,a4
  a2b43e:	8bfd                	andi	a5,a5,31
  a2b440:	10f4241b          	orshf	s0,s0,a5,sll,8
  a2b444:	00146413          	ori	s0,s0,1
  a2b448:	441137b7          	lui	a5,0x44113
  a2b44c:	0887a223          	sw	s0,132(a5) # 44113084 <_gp_+0x436de840>
  a2b450:	0ff0000f          	fence
  a2b454:	d3bff0ef          	jal	ra,a2b18e <inner_klad_wait_com_route_done>
  a2b458:	c22a                	sw	a0,4(sp)
  a2b45a:	4792                	lw	a5,4(sp)
  a2b45c:	b7ad                	j	a2b3c6 <hal_klad_start_com_route+0x2a>
  a2b45e:	57fd                	li	a5,-1
  a2b460:	b7a5                	j	a2b3c8 <hal_klad_start_com_route+0x2c>

00a2b462 <hal_fapc_set_region_addr>:
  a2b462:	040577bb          	bgeui	a0,4,a2b480 <hal_fapc_set_region_addr+0x1e>
  a2b466:	1200 0400 079f      	l.li	a5,0x12000400
  a2b46c:	953e                	add	a0,a0,a5
  a2b46e:	050a                	slli	a0,a0,0x2
  a2b470:	c10c                	sw	a1,0(a0)
  a2b472:	0ff0000f          	fence
  a2b476:	c130                	sw	a2,64(a0)
  a2b478:	0ff0000f          	fence
  a2b47c:	4501                	li	a0,0
  a2b47e:	8082                	ret
  a2b480:	557d                	li	a0,-1
  a2b482:	8082                	ret

00a2b484 <hal_fapc_set_region_permission>:
  a2b484:	4501                	li	a0,0
  a2b486:	8082                	ret

00a2b488 <hal_fapc_set_region_mac_addr>:
  a2b488:	4501                	li	a0,0
  a2b48a:	8082                	ret

00a2b48c <hal_fapc_set_region_mode>:
  a2b48c:	0405733b          	bgeui	a0,4,a2b498 <hal_fapc_set_region_mode+0xc>
  a2b490:	c591                	beqz	a1,a2b49c <hal_fapc_set_region_mode+0x10>
  a2b492:	4709                	li	a4,2
  a2b494:	020582bb          	beqi	a1,2,a2b49e <hal_fapc_set_region_mode+0x12>
  a2b498:	557d                	li	a0,-1
  a2b49a:	8082                	ret
  a2b49c:	4701                	li	a4,0
  a2b49e:	480016b7          	lui	a3,0x48001
  a2b4a2:	1806a603          	lw	a2,384(a3) # 48001180 <_gp_+0x475cc93c>
  a2b4a6:	0506                	slli	a0,a0,0x1
  a2b4a8:	478d                	li	a5,3
  a2b4aa:	00a797b3          	sll	a5,a5,a0
  a2b4ae:	fff7c793          	not	a5,a5
  a2b4b2:	8ff1                	and	a5,a5,a2
  a2b4b4:	00a71733          	sll	a4,a4,a0
  a2b4b8:	8fd9                	or	a5,a5,a4
  a2b4ba:	18f6a023          	sw	a5,384(a3)
  a2b4be:	0ff0000f          	fence
  a2b4c2:	4501                	li	a0,0
  a2b4c4:	8082                	ret

00a2b4c6 <hal_fapc_region_enable>:
  a2b4c6:	4501                	li	a0,0
  a2b4c8:	8082                	ret

00a2b4ca <hal_fapc_region_lock>:
  a2b4ca:	0405783b          	bgeui	a0,4,a2b4ea <hal_fapc_region_lock+0x20>
  a2b4ce:	48001737          	lui	a4,0x48001
  a2b4d2:	22072683          	lw	a3,544(a4) # 48001220 <_gp_+0x475cc9dc>
  a2b4d6:	4785                	li	a5,1
  a2b4d8:	00a79533          	sll	a0,a5,a0
  a2b4dc:	8d55                	or	a0,a0,a3
  a2b4de:	22a72023          	sw	a0,544(a4)
  a2b4e2:	0ff0000f          	fence
  a2b4e6:	4501                	li	a0,0
  a2b4e8:	8082                	ret
  a2b4ea:	557d                	li	a0,-1
  a2b4ec:	8082                	ret

00a2b4ee <hal_fapc_set_region_iv>:
  a2b4ee:	e131                	bnez	a0,a2b532 <hal_fapc_set_region_iv+0x44>
  a2b4f0:	557d                	li	a0,-1
  a2b4f2:	c1a9                	beqz	a1,a2b534 <hal_fapc_set_region_iv+0x46>
  a2b4f4:	1016103b          	bnei	a2,16,a2b534 <hal_fapc_set_region_iv+0x46>
  a2b4f8:	4198                	lw	a4,0(a1)
  a2b4fa:	480017b7          	lui	a5,0x48001
  a2b4fe:	62e7a023          	sw	a4,1568(a5) # 48001620 <_gp_+0x475ccddc>
  a2b502:	0ff0000f          	fence
  a2b506:	41d8                	lw	a4,4(a1)
  a2b508:	62e7a223          	sw	a4,1572(a5)
  a2b50c:	0ff0000f          	fence
  a2b510:	4598                	lw	a4,8(a1)
  a2b512:	62e7a423          	sw	a4,1576(a5)
  a2b516:	0ff0000f          	fence
  a2b51a:	45d8                	lw	a4,12(a1)
  a2b51c:	62e7a623          	sw	a4,1580(a5)
  a2b520:	0ff0000f          	fence
  a2b524:	4705                	li	a4,1
  a2b526:	60e7a023          	sw	a4,1536(a5)
  a2b52a:	0ff0000f          	fence
  a2b52e:	4501                	li	a0,0
  a2b530:	8082                	ret
  a2b532:	557d                	li	a0,-1
  a2b534:	8082                	ret

00a2b536 <hal_fapc_set_region_iv_start_addr>:
  a2b536:	0405763b          	bgeui	a0,4,a2b54e <hal_fapc_set_region_iv_start_addr+0x18>
  a2b53a:	1200 0590 079f      	l.li	a5,0x12000590
  a2b540:	953e                	add	a0,a0,a5
  a2b542:	050a                	slli	a0,a0,0x2
  a2b544:	c10c                	sw	a1,0(a0)
  a2b546:	0ff0000f          	fence
  a2b54a:	4501                	li	a0,0
  a2b54c:	8082                	ret
  a2b54e:	557d                	li	a0,-1
  a2b550:	8082                	ret

00a2b552 <hal_tcxo_init>:
  a2b552:	8018                	push	{ra},-16
  a2b554:	28a9                	jal	ra,a2b5ae <hal_tcxo_v150_regs_init>
  a2b556:	e105                	bnez	a0,a2b576 <hal_tcxo_init+0x24>
  a2b558:	00a05737          	lui	a4,0xa05
  a2b55c:	74872683          	lw	a3,1864(a4) # a05748 <g_tcxo_regs>
  a2b560:	429c                	lw	a5,0(a3)
  a2b562:	0047e793          	ori	a5,a5,4
  a2b566:	c29c                	sw	a5,0(a3)
  a2b568:	74872703          	lw	a4,1864(a4)
  a2b56c:	431c                	lw	a5,0(a4)
  a2b56e:	0027e793          	ori	a5,a5,2
  a2b572:	c31c                	sw	a5,0(a4)
  a2b574:	8014                	popret	{ra},16
  a2b576:	8000 1180 051f      	l.li	a0,0x80001180
  a2b57c:	bfe5                	j	a2b574 <hal_tcxo_init+0x22>

00a2b57e <hal_tcxo_get>:
  a2b57e:	00a057b7          	lui	a5,0xa05
  a2b582:	7487a683          	lw	a3,1864(a5) # a05748 <g_tcxo_regs>
  a2b586:	4605                	li	a2,1
  a2b588:	4298                	lw	a4,0(a3)
  a2b58a:	00176713          	ori	a4,a4,1
  a2b58e:	c298                	sw	a4,0(a3)
  a2b590:	56fd                	li	a3,-1
  a2b592:	873e                	mv	a4,a5
  a2b594:	74872783          	lw	a5,1864(a4)
  a2b598:	439c                	lw	a5,0(a5)
  a2b59a:	8391                	srli	a5,a5,0x4
  a2b59c:	8b85                	andi	a5,a5,1
  a2b59e:	00c78763          	beq	a5,a2,a2b5ac <hal_tcxo_get+0x2e>
  a2b5a2:	16fd                	addi	a3,a3,-1
  a2b5a4:	fae5                	bnez	a3,a2b594 <hal_tcxo_get+0x16>
  a2b5a6:	4501                	li	a0,0
  a2b5a8:	4581                	li	a1,0
  a2b5aa:	8082                	ret
  a2b5ac:	a00d                	j	a2b5ce <hal_tcxo_reg_count_get>

00a2b5ae <hal_tcxo_v150_regs_init>:
  a2b5ae:	8018                	push	{ra},-16
  a2b5b0:	495000ef          	jal	ra,a2c244 <tcxo_porting_base_addr_get>
  a2b5b4:	c909                	beqz	a0,a2b5c6 <hal_tcxo_v150_regs_init+0x18>
  a2b5b6:	48f000ef          	jal	ra,a2c244 <tcxo_porting_base_addr_get>
  a2b5ba:	00a0 5748 079f      	l.li	a5,0xa05748
  a2b5c0:	c388                	sw	a0,0(a5)
  a2b5c2:	4501                	li	a0,0
  a2b5c4:	8014                	popret	{ra},16
  a2b5c6:	8000 1180 051f      	l.li	a0,0x80001180
  a2b5cc:	bfe5                	j	a2b5c4 <hal_tcxo_v150_regs_init+0x16>

00a2b5ce <hal_tcxo_reg_count_get>:
  a2b5ce:	00a0 5748 079f      	l.li	a5,0xa05748
  a2b5d4:	439c                	lw	a5,0(a5)
  a2b5d6:	478c                	lw	a1,8(a5)
  a2b5d8:	43c8                	lw	a0,4(a5)
  a2b5da:	8082                	ret

00a2b5dc <hal_uart_register_funcs>:
  a2b5dc:	030575bb          	bgeui	a0,3,a2b5f2 <hal_uart_register_funcs+0x16>
  a2b5e0:	c989                	beqz	a1,a2b5f2 <hal_uart_register_funcs+0x16>
  a2b5e2:	00a0 574c 079f      	l.li	a5,0xa0574c
  a2b5e8:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b5ec:	c10c                	sw	a1,0(a0)
  a2b5ee:	4501                	li	a0,0
  a2b5f0:	8082                	ret
  a2b5f2:	80000537          	lui	a0,0x80000
  a2b5f6:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2b5f8:	8082                	ret

00a2b5fa <hal_uart_init>:
  a2b5fa:	8228                	push	{ra,s0},-48
  a2b5fc:	842a                	mv	s0,a0
  a2b5fe:	ce2e                	sw	a1,28(sp)
  a2b600:	cc32                	sw	a2,24(sp)
  a2b602:	ca36                	sw	a3,20(sp)
  a2b604:	c83a                	sw	a4,16(sp)
  a2b606:	c63e                	sw	a5,12(sp)
  a2b608:	3af000ef          	jal	ra,a2c1b6 <uart_port_register_hal_funcs>
  a2b60c:	00a0 574c 051f      	l.li	a0,0xa0574c
  a2b612:	0485051b          	addshf	a0,a0,s0,sll,2
  a2b616:	4108                	lw	a0,0(a0)
  a2b618:	cd01                	beqz	a0,a2b630 <hal_uart_init+0x36>
  a2b61a:	46d2                	lw	a3,20(sp)
  a2b61c:	ca91                	beqz	a3,a2b630 <hal_uart_init+0x36>
  a2b61e:	00052303          	lw	t1,0(a0)
  a2b622:	47b2                	lw	a5,12(sp)
  a2b624:	4742                	lw	a4,16(sp)
  a2b626:	4662                	lw	a2,24(sp)
  a2b628:	45f2                	lw	a1,28(sp)
  a2b62a:	8522                	mv	a0,s0
  a2b62c:	8220                	pop	{ra,s0},48
  a2b62e:	8302                	jr	t1
  a2b630:	8000 1047 051f      	l.li	a0,0x80001047
  a2b636:	8224                	popret	{ra,s0},48

00a2b638 <hal_uart_write>:
  a2b638:	00a0 574c 079f      	l.li	a5,0xa0574c
  a2b63e:	04a7879b          	addshf	a5,a5,a0,sll,2
  a2b642:	439c                	lw	a5,0(a5)
  a2b644:	00c7a303          	lw	t1,12(a5)
  a2b648:	8302                	jr	t1

00a2b64a <hal_uart_read>:
  a2b64a:	00a0 574c 079f      	l.li	a5,0xa0574c
  a2b650:	04a7879b          	addshf	a5,a5,a0,sll,2
  a2b654:	439c                	lw	a5,0(a5)
  a2b656:	0107a303          	lw	t1,16(a5)
  a2b65a:	8302                	jr	t1

00a2b65c <hal_uart_ctrl>:
  a2b65c:	00a0 574c 079f      	l.li	a5,0xa0574c
  a2b662:	04a7879b          	addshf	a5,a5,a0,sll,2
  a2b666:	439c                	lw	a5,0(a5)
  a2b668:	c781                	beqz	a5,a2b670 <hal_uart_ctrl+0x14>
  a2b66a:	0087a303          	lw	t1,8(a5)
  a2b66e:	8302                	jr	t1
  a2b670:	8000 1047 051f      	l.li	a0,0x80001047
  a2b676:	8082                	ret

00a2b678 <hal_uart_v151_ctrl_get_rxfifo_passnum>:
  a2b678:	c609                	beqz	a2,a2b682 <hal_uart_v151_ctrl_get_rxfifo_passnum+0xa>
  a2b67a:	57fd                	li	a5,-1
  a2b67c:	c21c                	sw	a5,0(a2)
  a2b67e:	4501                	li	a0,0
  a2b680:	8082                	ret
  a2b682:	80000537          	lui	a0,0x80000
  a2b686:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2b688:	8082                	ret

00a2b68a <hal_uart_v151_get_uart_rxfifo_threshold>:
  a2b68a:	00a0 5774 079f      	l.li	a5,0xa05774
  a2b690:	953e                	add	a0,a0,a5
  a2b692:	2114                	lbu	a3,0(a0)
  a2b694:	03e00713          	li	a4,62
  a2b698:	0306f3bb          	bgeui	a3,3,a2b6a6 <hal_uart_v151_get_uart_rxfifo_threshold+0x1c>
  a2b69c:	00a3 2748 079f      	l.li	a5,0xa32748
  a2b6a2:	97b6                	add	a5,a5,a3
  a2b6a4:	2398                	lbu	a4,0(a5)
  a2b6a6:	c218                	sw	a4,0(a2)
  a2b6a8:	4501                	li	a0,0
  a2b6aa:	8082                	ret

00a2b6ac <hal_uart_v151_deinit>:
  a2b6ac:	00a0 5758 079f      	l.li	a5,0xa05758
  a2b6b2:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b6b6:	00052023          	sw	zero,0(a0)
  a2b6ba:	4501                	li	a0,0
  a2b6bc:	8082                	ret

00a2b6be <hal_uart_set_diven>:
  a2b6be:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b6c4:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b6c8:	4118                	lw	a4,0(a0)
  a2b6ca:	8985                	andi	a1,a1,1
  a2b6cc:	471c                	lw	a5,8(a4)
  a2b6ce:	9bf9                	andi	a5,a5,-2
  a2b6d0:	8fcd                	or	a5,a5,a1
  a2b6d2:	c71c                	sw	a5,8(a4)
  a2b6d4:	8082                	ret

00a2b6d6 <hal_uart_is_tx_fifo_full>:
  a2b6d6:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b6dc:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b6e0:	411c                	lw	a5,0(a0)
  a2b6e2:	4501                	li	a0,0
  a2b6e4:	43fc                	lw	a5,68(a5)
  a2b6e6:	8b85                	andi	a5,a5,1
  a2b6e8:	a21c                	sb	a5,0(a2)
  a2b6ea:	8082                	ret

00a2b6ec <hal_uart_is_tx_fifo_empty>:
  a2b6ec:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b6f2:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b6f6:	411c                	lw	a5,0(a0)
  a2b6f8:	4501                	li	a0,0
  a2b6fa:	43fc                	lw	a5,68(a5)
  a2b6fc:	8385                	srli	a5,a5,0x1
  a2b6fe:	8b85                	andi	a5,a5,1
  a2b700:	a21c                	sb	a5,0(a2)
  a2b702:	8082                	ret

00a2b704 <hal_uart_is_busy>:
  a2b704:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b70a:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b70e:	411c                	lw	a5,0(a0)
  a2b710:	4501                	li	a0,0
  a2b712:	43fc                	lw	a5,68(a5)
  a2b714:	9f81                	uxtb	a5
  a2b716:	8385                	srli	a5,a5,0x1
  a2b718:	0017c793          	xori	a5,a5,1
  a2b71c:	8b85                	andi	a5,a5,1
  a2b71e:	a21c                	sb	a5,0(a2)
  a2b720:	8082                	ret

00a2b722 <hal_uart_is_rx_fifo_empty>:
  a2b722:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b728:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b72c:	411c                	lw	a5,0(a0)
  a2b72e:	4501                	li	a0,0
  a2b730:	43fc                	lw	a5,68(a5)
  a2b732:	838d                	srli	a5,a5,0x3
  a2b734:	8b85                	andi	a5,a5,1
  a2b736:	a21c                	sb	a5,0(a2)
  a2b738:	8082                	ret

00a2b73a <hal_uart_v151_write>:
  a2b73a:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b740:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b744:	e219                	bnez	a2,a2b74a <hal_uart_v151_write+0x10>
  a2b746:	4501                	li	a0,0
  a2b748:	8082                	ret
  a2b74a:	4118                	lw	a4,0(a0)
  a2b74c:	437c                	lw	a5,68(a4)
  a2b74e:	8b85                	andi	a5,a5,1
  a2b750:	fbf5                	bnez	a5,a2b744 <hal_uart_v151_write+0xa>
  a2b752:	0585                	addi	a1,a1,1
  a2b754:	fff5c783          	lbu	a5,-1(a1)
  a2b758:	167d                	addi	a2,a2,-1 # 44112fff <_gp_+0x436de7bb>
  a2b75a:	9e21                	uxth	a2
  a2b75c:	c35c                	sw	a5,4(a4)
  a2b75e:	b7dd                	j	a2b744 <hal_uart_v151_write+0xa>

00a2b760 <hal_uart_v151_read>:
  a2b760:	00a0 5768 071f      	l.li	a4,0xa05768
  a2b766:	4781                	li	a5,0
  a2b768:	04a7051b          	addshf	a0,a4,a0,sll,2
  a2b76c:	00c7c463          	blt	a5,a2,a2b774 <hal_uart_v151_read+0x14>
  a2b770:	853e                	mv	a0,a5
  a2b772:	8082                	ret
  a2b774:	4114                	lw	a3,0(a0)
  a2b776:	42f8                	lw	a4,68(a3)
  a2b778:	8b21                	andi	a4,a4,8
  a2b77a:	fb7d                	bnez	a4,a2b770 <hal_uart_v151_read+0x10>
  a2b77c:	42d4                	lw	a3,4(a3)
  a2b77e:	00f58733          	add	a4,a1,a5
  a2b782:	0785                	addi	a5,a5,1
  a2b784:	a314                	sb	a3,0(a4)
  a2b786:	b7dd                	j	a2b76c <hal_uart_v151_read+0xc>

00a2b788 <hal_uart_v151_ctrl>:
  a2b788:	00a3 274c 079f      	l.li	a5,0xa3274c
  a2b78e:	04b7879b          	addshf	a5,a5,a1,sll,2
  a2b792:	0007a303          	lw	t1,0(a5)
  a2b796:	00030363          	beqz	t1,a2b79c <hal_uart_v151_ctrl+0x14>
  a2b79a:	8302                	jr	t1
  a2b79c:	8000 1047 051f      	l.li	a0,0x80001047
  a2b7a2:	8082                	ret

00a2b7a4 <hal_uart_init_fifo>:
  a2b7a4:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b7aa:	04a7879b          	addshf	a5,a5,a0,sll,2
  a2b7ae:	4398                	lw	a4,0(a5)
  a2b7b0:	0035f693          	andi	a3,a1,3
  a2b7b4:	535c                	lw	a5,36(a4)
  a2b7b6:	9bcd                	andi	a5,a5,-13
  a2b7b8:	04d7a79b          	orshf	a5,a5,a3,sll,2
  a2b7bc:	9bf1                	andi	a5,a5,-4
  a2b7be:	00367693          	andi	a3,a2,3
  a2b7c2:	8fd5                	or	a5,a5,a3
  a2b7c4:	0107e793          	ori	a5,a5,16
  a2b7c8:	d35c                	sw	a5,36(a4)
  a2b7ca:	00a0 5774 079f      	l.li	a5,0xa05774
  a2b7d0:	97aa                	add	a5,a5,a0
  a2b7d2:	a38c                	sb	a1,0(a5)
  a2b7d4:	00a0 5778 079f      	l.li	a5,0xa05778
  a2b7da:	953e                	add	a0,a0,a5
  a2b7dc:	a110                	sb	a2,0(a0)
  a2b7de:	8082                	ret

00a2b7e0 <hal_uart_v151_ctrl_set_txfifo_int_level>:
  a2b7e0:	0406633b          	bltui	a2,4,a2b7ec <hal_uart_v151_ctrl_set_txfifo_int_level+0xc>
  a2b7e4:	80000537          	lui	a0,0x80000
  a2b7e8:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2b7ea:	8082                	ret
  a2b7ec:	8018                	push	{ra},-16
  a2b7ee:	00a0 5774 079f      	l.li	a5,0xa05774
  a2b7f4:	97aa                	add	a5,a5,a0
  a2b7f6:	238c                	lbu	a1,0(a5)
  a2b7f8:	9e01                	uxtb	a2
  a2b7fa:	376d                	jal	ra,a2b7a4 <hal_uart_init_fifo>
  a2b7fc:	4501                	li	a0,0
  a2b7fe:	8014                	popret	{ra},16

00a2b800 <hal_uart_v151_ctrl_set_rxfifo_int_level>:
  a2b800:	0406633b          	bltui	a2,4,a2b80c <hal_uart_v151_ctrl_set_rxfifo_int_level+0xc>
  a2b804:	80000537          	lui	a0,0x80000
  a2b808:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2b80a:	8082                	ret
  a2b80c:	8018                	push	{ra},-16
  a2b80e:	00a0 5778 079f      	l.li	a5,0xa05778
  a2b814:	97aa                	add	a5,a5,a0
  a2b816:	85b2                	mv	a1,a2
  a2b818:	2390                	lbu	a2,0(a5)
  a2b81a:	9d81                	uxtb	a1
  a2b81c:	3761                	jal	ra,a2b7a4 <hal_uart_init_fifo>
  a2b81e:	4501                	li	a0,0
  a2b820:	8014                	popret	{ra},16

00a2b822 <hal_uart_set_baud_rate>:
  a2b822:	c1b1                	beqz	a1,a2b866 <hal_uart_set_baud_rate+0x44>
  a2b824:	8048                	push	{ra,s0-s2},-16
  a2b826:	0592                	slli	a1,a1,0x4
  a2b828:	02b67433          	remu	s0,a2,a1
  a2b82c:	892a                	mv	s2,a0
  a2b82e:	02b654b3          	divu	s1,a2,a1
  a2b832:	041a                	slli	s0,s0,0x6
  a2b834:	02b45433          	divu	s0,s0,a1
  a2b838:	4585                	li	a1,1
  a2b83a:	e85ff0ef          	jal	ra,a2b6be <hal_uart_set_diven>
  a2b83e:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b844:	0527879b          	addshf	a5,a5,s2,sll,2
  a2b848:	439c                	lw	a5,0(a5)
  a2b84a:	0ff4f713          	andi	a4,s1,255
  a2b84e:	9ca1                	uxth	s1
  a2b850:	cb98                	sw	a4,16(a5)
  a2b852:	80a1                	srli	s1,s1,0x8
  a2b854:	c7c4                	sw	s1,12(a5)
  a2b856:	4581                	li	a1,0
  a2b858:	854a                	mv	a0,s2
  a2b85a:	03f47413          	andi	s0,s0,63
  a2b85e:	cbc0                	sw	s0,20(a5)
  a2b860:	8040                	pop	{ra,s0-s2},16
  a2b862:	e5dff06f          	j	a2b6be <hal_uart_set_diven>
  a2b866:	8082                	ret

00a2b868 <hal_uart_set_data_bits>:
  a2b868:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b86e:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b872:	4118                	lw	a4,0(a0)
  a2b874:	898d                	andi	a1,a1,3
  a2b876:	471c                	lw	a5,8(a4)
  a2b878:	9bcd                	andi	a5,a5,-13
  a2b87a:	04b7a79b          	orshf	a5,a5,a1,sll,2
  a2b87e:	c71c                	sw	a5,8(a4)
  a2b880:	8082                	ret

00a2b882 <hal_uart_set_stop_bits>:
  a2b882:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b888:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b88c:	4118                	lw	a4,0(a0)
  a2b88e:	8985                	andi	a1,a1,1
  a2b890:	471c                	lw	a5,8(a4)
  a2b892:	f7f7f793          	andi	a5,a5,-129
  a2b896:	0eb7a79b          	orshf	a5,a5,a1,sll,7
  a2b89a:	c71c                	sw	a5,8(a4)
  a2b89c:	8082                	ret

00a2b89e <hal_uart_auto_flow_ctl_en>:
  a2b89e:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b8a4:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b8a8:	4118                	lw	a4,0(a0)
  a2b8aa:	8985                	andi	a1,a1,1
  a2b8ac:	575c                	lw	a5,44(a4)
  a2b8ae:	9be9                	andi	a5,a5,-6
  a2b8b0:	8fcd                	or	a5,a5,a1
  a2b8b2:	04b7a59b          	orshf	a1,a5,a1,sll,2
  a2b8b6:	d74c                	sw	a1,44(a4)
  a2b8b8:	8082                	ret

00a2b8ba <hal_uart_enable_interrupt>:
  a2b8ba:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b8c0:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b8c4:	4114                	lw	a3,0(a0)
  a2b8c6:	4e9c                	lw	a5,24(a3)
  a2b8c8:	0e05f73b          	bgeui	a1,14,a2b8e4 <hal_uart_enable_interrupt+0x2a>
  a2b8cc:	00a32737          	lui	a4,0xa32
  a2b8d0:	71070713          	addi	a4,a4,1808 # a32710 <g_sm3_ival+0x34>
  a2b8d4:	04b7059b          	addshf	a1,a4,a1,sll,2
  a2b8d8:	4198                	lw	a4,0(a1)
  a2b8da:	8702                	jr	a4
  a2b8dc:	8a05                	andi	a2,a2,1
  a2b8de:	9bdd                	andi	a5,a5,-9
  a2b8e0:	06c7a79b          	orshf	a5,a5,a2,sll,3
  a2b8e4:	ce9c                	sw	a5,24(a3)
  a2b8e6:	8082                	ret
  a2b8e8:	8a05                	andi	a2,a2,1
  a2b8ea:	9bed                	andi	a5,a5,-5
  a2b8ec:	04c7a79b          	orshf	a5,a5,a2,sll,2
  a2b8f0:	bfd5                	j	a2b8e4 <hal_uart_enable_interrupt+0x2a>
  a2b8f2:	8a05                	andi	a2,a2,1
  a2b8f4:	9bf9                	andi	a5,a5,-2
  a2b8f6:	8fd1                	or	a5,a5,a2
  a2b8f8:	b7f5                	j	a2b8e4 <hal_uart_enable_interrupt+0x2a>
  a2b8fa:	8a05                	andi	a2,a2,1
  a2b8fc:	9bf5                	andi	a5,a5,-3
  a2b8fe:	02c7a79b          	orshf	a5,a5,a2,sll,1
  a2b902:	b7cd                	j	a2b8e4 <hal_uart_enable_interrupt+0x2a>

00a2b904 <hal_uart_en_para_err_int>:
  a2b904:	8018                	push	{ra},-16
  a2b906:	00c03633          	snez	a2,a2
  a2b90a:	45b5                	li	a1,13
  a2b90c:	377d                	jal	ra,a2b8ba <hal_uart_enable_interrupt>
  a2b90e:	4501                	li	a0,0
  a2b910:	8014                	popret	{ra},16

00a2b912 <hal_uart_en_idle_int>:
  a2b912:	8018                	push	{ra},-16
  a2b914:	00c03633          	snez	a2,a2
  a2b918:	45b1                	li	a1,12
  a2b91a:	3745                	jal	ra,a2b8ba <hal_uart_enable_interrupt>
  a2b91c:	4501                	li	a0,0
  a2b91e:	8014                	popret	{ra},16

00a2b920 <hal_uart_en_rx_int>:
  a2b920:	8018                	push	{ra},-16
  a2b922:	00c03633          	snez	a2,a2
  a2b926:	4591                	li	a1,4
  a2b928:	3f49                	jal	ra,a2b8ba <hal_uart_enable_interrupt>
  a2b92a:	4501                	li	a0,0
  a2b92c:	8014                	popret	{ra},16

00a2b92e <hal_uart_en_tx_int>:
  a2b92e:	8018                	push	{ra},-16
  a2b930:	00c03633          	snez	a2,a2
  a2b934:	4589                	li	a1,2
  a2b936:	3751                	jal	ra,a2b8ba <hal_uart_enable_interrupt>
  a2b938:	4501                	li	a0,0
  a2b93a:	8014                	popret	{ra},16

00a2b93c <hal_uart_check_en>:
  a2b93c:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b942:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b946:	4118                	lw	a4,0(a0)
  a2b948:	8985                	andi	a1,a1,1
  a2b94a:	471c                	lw	a5,8(a4)
  a2b94c:	fdf7f793          	andi	a5,a5,-33
  a2b950:	0ab7a79b          	orshf	a5,a5,a1,sll,5
  a2b954:	c71c                	sw	a5,8(a4)
  a2b956:	8082                	ret

00a2b958 <hal_uart_parity_en>:
  a2b958:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b95e:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b962:	4118                	lw	a4,0(a0)
  a2b964:	8985                	andi	a1,a1,1
  a2b966:	471c                	lw	a5,8(a4)
  a2b968:	9bbd                	andi	a5,a5,-17
  a2b96a:	08b7a79b          	orshf	a5,a5,a1,sll,4
  a2b96e:	c71c                	sw	a5,8(a4)
  a2b970:	8082                	ret

00a2b972 <hal_uart_set_parity>:
  a2b972:	8028                	push	{ra,s0},-16
  a2b974:	842a                	mv	s0,a0
  a2b976:	0105873b          	beqi	a1,1,a2b992 <hal_uart_set_parity+0x20>
  a2b97a:	c581                	beqz	a1,a2b982 <hal_uart_set_parity+0x10>
  a2b97c:	020582bb          	beqi	a1,2,a2b986 <hal_uart_set_parity+0x14>
  a2b980:	8024                	popret	{ra,s0},16
  a2b982:	8020                	pop	{ra,s0},16
  a2b984:	bf65                	j	a2b93c <hal_uart_check_en>
  a2b986:	4585                	li	a1,1
  a2b988:	3f55                	jal	ra,a2b93c <hal_uart_check_en>
  a2b98a:	4585                	li	a1,1
  a2b98c:	8522                	mv	a0,s0
  a2b98e:	8020                	pop	{ra,s0},16
  a2b990:	b7e1                	j	a2b958 <hal_uart_parity_en>
  a2b992:	376d                	jal	ra,a2b93c <hal_uart_check_en>
  a2b994:	4581                	li	a1,0
  a2b996:	bfdd                	j	a2b98c <hal_uart_set_parity+0x1a>

00a2b998 <hal_uart_v151_ctrl_set_attr>:
  a2b998:	8138                	push	{ra,s0-s1},-32
  a2b99a:	224c                	lbu	a1,4(a2)
  a2b99c:	84b2                	mv	s1,a2
  a2b99e:	842a                	mv	s0,a0
  a2b9a0:	ec9ff0ef          	jal	ra,a2b868 <hal_uart_set_data_bits>
  a2b9a4:	30cc                	lbu	a1,5(s1)
  a2b9a6:	8522                	mv	a0,s0
  a2b9a8:	3de9                	jal	ra,a2b882 <hal_uart_set_stop_bits>
  a2b9aa:	20ec                	lbu	a1,6(s1)
  a2b9ac:	8522                	mv	a0,s0
  a2b9ae:	37d1                	jal	ra,a2b972 <hal_uart_set_parity>
  a2b9b0:	408c                	lw	a1,0(s1)
  a2b9b2:	8522                	mv	a0,s0
  a2b9b4:	c62e                	sw	a1,12(sp)
  a2b9b6:	01d000ef          	jal	ra,a2c1d2 <uart_port_get_clock_value>
  a2b9ba:	45b2                	lw	a1,12(sp)
  a2b9bc:	862a                	mv	a2,a0
  a2b9be:	8522                	mv	a0,s0
  a2b9c0:	e63ff0ef          	jal	ra,a2b822 <hal_uart_set_baud_rate>
  a2b9c4:	4501                	li	a0,0
  a2b9c6:	8134                	popret	{ra,s0-s1},32

00a2b9c8 <hal_uart_tx_pause_en>:
  a2b9c8:	00a0 5768 079f      	l.li	a5,0xa05768
  a2b9ce:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2b9d2:	4118                	lw	a4,0(a0)
  a2b9d4:	8985                	andi	a1,a1,1
  a2b9d6:	4b3c                	lw	a5,80(a4)
  a2b9d8:	9bf9                	andi	a5,a5,-2
  a2b9da:	8fcd                	or	a5,a5,a1
  a2b9dc:	cb3c                	sw	a5,80(a4)
  a2b9de:	8082                	ret

00a2b9e0 <hal_uart_v151_init>:
  a2b9e0:	8168                	push	{ra,s0-s4},-48
  a2b9e2:	84b6                	mv	s1,a3
  a2b9e4:	00251913          	slli	s2,a0,0x2
  a2b9e8:	00a3 27a0 069f      	l.li	a3,0xa327a0
  a2b9ee:	8a2e                	mv	s4,a1
  a2b9f0:	012685b3          	add	a1,a3,s2
  a2b9f4:	418c                	lw	a1,0(a1)
  a2b9f6:	4294                	lw	a3,0(a3)
  a2b9f8:	89ba                	mv	s3,a4
  a2b9fa:	00a0 5768 071f      	l.li	a4,0xa05768
  a2ba00:	01270633          	add	a2,a4,s2
  a2ba04:	c20c                	sw	a1,0(a2)
  a2ba06:	c314                	sw	a3,0(a4)
  a2ba08:	20cc                	lbu	a1,4(s1)
  a2ba0a:	00a0 5764 071f      	l.li	a4,0xa05764
  a2ba10:	972a                	add	a4,a4,a0
  a2ba12:	c63e                	sw	a5,12(sp)
  a2ba14:	00070023          	sb	zero,0(a4)
  a2ba18:	842a                	mv	s0,a0
  a2ba1a:	e4fff0ef          	jal	ra,a2b868 <hal_uart_set_data_bits>
  a2ba1e:	30cc                	lbu	a1,5(s1)
  a2ba20:	8522                	mv	a0,s0
  a2ba22:	e61ff0ef          	jal	ra,a2b882 <hal_uart_set_stop_bits>
  a2ba26:	20ec                	lbu	a1,6(s1)
  a2ba28:	8522                	mv	a0,s0
  a2ba2a:	37a1                	jal	ra,a2b972 <hal_uart_set_parity>
  a2ba2c:	4581                	li	a1,0
  a2ba2e:	8522                	mv	a0,s0
  a2ba30:	3f61                	jal	ra,a2b9c8 <hal_uart_tx_pause_en>
  a2ba32:	408c                	lw	a1,0(s1)
  a2ba34:	8522                	mv	a0,s0
  a2ba36:	c42e                	sw	a1,8(sp)
  a2ba38:	79a000ef          	jal	ra,a2c1d2 <uart_port_get_clock_value>
  a2ba3c:	45a2                	lw	a1,8(sp)
  a2ba3e:	862a                	mv	a2,a0
  a2ba40:	8522                	mv	a0,s0
  a2ba42:	de1ff0ef          	jal	ra,a2b822 <hal_uart_set_baud_rate>
  a2ba46:	4529                	li	a0,10
  a2ba48:	965fe0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2ba4c:	47b2                	lw	a5,12(sp)
  a2ba4e:	c78d                	beqz	a5,a2ba78 <hal_uart_v151_init+0x98>
  a2ba50:	3390                	lbu	a2,1(a5)
  a2ba52:	33ac                	lbu	a1,3(a5)
  a2ba54:	8522                	mv	a0,s0
  a2ba56:	d4fff0ef          	jal	ra,a2b7a4 <hal_uart_init_fifo>
  a2ba5a:	00a0 5758 079f      	l.li	a5,0xa05758
  a2ba60:	97ca                	add	a5,a5,s2
  a2ba62:	0147a023          	sw	s4,0(a5)
  a2ba66:	4585                	li	a1,1
  a2ba68:	030981bb          	beqi	s3,3,a2ba6e <hal_uart_v151_init+0x8e>
  a2ba6c:	4581                	li	a1,0
  a2ba6e:	8522                	mv	a0,s0
  a2ba70:	e2fff0ef          	jal	ra,a2b89e <hal_uart_auto_flow_ctl_en>
  a2ba74:	4501                	li	a0,0
  a2ba76:	8164                	popret	{ra,s0-s4},48
  a2ba78:	4605                	li	a2,1
  a2ba7a:	4585                	li	a1,1
  a2ba7c:	bfe1                	j	a2ba54 <hal_uart_v151_init+0x74>

00a2ba7e <hal_uart_v151_funcs_get>:
  a2ba7e:	00a3 3f18 051f      	l.li	a0,0xa33f18
  a2ba84:	8082                	ret

00a2ba86 <hal_watchdog_register_funcs>:
  a2ba86:	c519                	beqz	a0,a2ba94 <hal_watchdog_register_funcs+0xe>
  a2ba88:	00a0 577c 079f      	l.li	a5,0xa0577c
  a2ba8e:	c388                	sw	a0,0(a5)
  a2ba90:	4501                	li	a0,0
  a2ba92:	8082                	ret
  a2ba94:	80000537          	lui	a0,0x80000
  a2ba98:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2ba9a:	8082                	ret

00a2ba9c <hal_watchdog_unregister_funcs>:
  a2ba9c:	00a0 577c 079f      	l.li	a5,0xa0577c
  a2baa2:	0007a023          	sw	zero,0(a5)
  a2baa6:	4501                	li	a0,0
  a2baa8:	8082                	ret

00a2baaa <hal_watchdog_get_funcs>:
  a2baaa:	00a0 577c 079f      	l.li	a5,0xa0577c
  a2bab0:	4388                	lw	a0,0(a5)
  a2bab2:	8082                	ret

00a2bab4 <hal_watchdog_regs_init>:
  a2bab4:	00a347b7          	lui	a5,0xa34
  a2bab8:	fb07a783          	lw	a5,-80(a5) # a33fb0 <g_watchdog_base_addr>
  a2babc:	c799                	beqz	a5,a2baca <hal_watchdog_regs_init+0x16>
  a2babe:	00a0 5780 071f      	l.li	a4,0xa05780
  a2bac4:	c31c                	sw	a5,0(a4)
  a2bac6:	4501                	li	a0,0
  a2bac8:	8082                	ret
  a2baca:	8000 1200 051f      	l.li	a0,0x80001200
  a2bad0:	8082                	ret

00a2bad2 <hal_watchdog_regs_deinit>:
  a2bad2:	00a0 5780 079f      	l.li	a5,0xa05780
  a2bad8:	0007a023          	sw	zero,0(a5)
  a2badc:	8082                	ret

00a2bade <hal_watchdog_v151_kick>:
  a2bade:	00a057b7          	lui	a5,0xa05
  a2bae2:	7807a783          	lw	a5,1920(a5) # a05780 <g_watchdog_regs>
  a2bae6:	5a5a 5a5a 071f      	l.li	a4,0x5a5a5a5a
  a2baec:	c798                	sw	a4,8(a5)
  a2baee:	8082                	ret

00a2baf0 <hal_watchdog_v151_get_attr>:
  a2baf0:	00a0 5788 079f      	l.li	a5,0xa05788
  a2baf6:	4388                	lw	a0,0(a5)
  a2baf8:	8082                	ret

00a2bafa <hal_register_watchdog_v151_callback>:
  a2bafa:	00a0 5784 079f      	l.li	a5,0xa05784
  a2bb00:	c388                	sw	a0,0(a5)
  a2bb02:	8082                	ret

00a2bb04 <hal_watchdog_v151_deinit>:
  a2bb04:	b7f9                	j	a2bad2 <hal_watchdog_regs_deinit>

00a2bb06 <hal_watchdog_v151_init>:
  a2bb06:	b77d                	j	a2bab4 <hal_watchdog_regs_init>

00a2bb08 <hal_watchdog_v151_get_left_time>:
  a2bb08:	8038                	push	{ra,s0-s1},-16
  a2bb0a:	00a057b7          	lui	a5,0xa05
  a2bb0e:	7807a683          	lw	a3,1920(a5) # a05780 <g_watchdog_regs>
  a2bb12:	7d100493          	li	s1,2001
  a2bb16:	843e                	mv	s0,a5
  a2bb18:	5698                	lw	a4,40(a3)
  a2bb1a:	00176713          	ori	a4,a4,1
  a2bb1e:	d698                	sw	a4,40(a3)
  a2bb20:	78042703          	lw	a4,1920(s0)
  a2bb24:	571c                	lw	a5,40(a4)
  a2bb26:	8385                	srli	a5,a5,0x1
  a2bb28:	8b85                	andi	a5,a5,1
  a2bb2a:	cf99                	beqz	a5,a2bb48 <hal_watchdog_v151_get_left_time+0x40>
  a2bb2c:	4b40                	lw	s0,20(a4)
  a2bb2e:	75a000ef          	jal	ra,a2c288 <watchdog_port_get_clock>
  a2bb32:	3e800793          	li	a5,1000
  a2bb36:	862a                	mv	a2,a0
  a2bb38:	02f435b3          	mulhu	a1,s0,a5
  a2bb3c:	4681                	li	a3,0
  a2bb3e:	02f40533          	mul	a0,s0,a5
  a2bb42:	a5bfc0ef          	jal	ra,a2859c <__udivdi3>
  a2bb46:	8034                	popret	{ra,s0-s1},16
  a2bb48:	14fd                	addi	s1,s1,-1
  a2bb4a:	c489                	beqz	s1,a2bb54 <hal_watchdog_v151_get_left_time+0x4c>
  a2bb4c:	4505                	li	a0,1
  a2bb4e:	85ffe0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2bb52:	b7f9                	j	a2bb20 <hal_watchdog_v151_get_left_time+0x18>
  a2bb54:	4501                	li	a0,0
  a2bb56:	bfc5                	j	a2bb46 <hal_watchdog_v151_get_left_time+0x3e>

00a2bb58 <hal_watchdog_v151_clear_interrupt>:
  a2bb58:	00a057b7          	lui	a5,0xa05
  a2bb5c:	7807a703          	lw	a4,1920(a5) # a05780 <g_watchdog_regs>
  a2bb60:	475c                	lw	a5,12(a4)
  a2bb62:	0017e793          	ori	a5,a5,1
  a2bb66:	c75c                	sw	a5,12(a4)
  a2bb68:	8082                	ret

00a2bb6a <hal_watchdog_v151_disable>:
  a2bb6a:	8018                	push	{ra},-16
  a2bb6c:	37f5                	jal	ra,a2bb58 <hal_watchdog_v151_clear_interrupt>
  a2bb6e:	00a057b7          	lui	a5,0xa05
  a2bb72:	7807a703          	lw	a4,1920(a5) # a05780 <g_watchdog_regs>
  a2bb76:	4b1c                	lw	a5,16(a4)
  a2bb78:	9bf9                	andi	a5,a5,-2
  a2bb7a:	cb1c                	sw	a5,16(a4)
  a2bb7c:	8014                	popret	{ra},16

00a2bb7e <hal_watchdog_v151_set_attr>:
  a2bb7e:	8048                	push	{ra,s0-s2},-16
  a2bb80:	84aa                	mv	s1,a0
  a2bb82:	706000ef          	jal	ra,a2c288 <watchdog_port_get_clock>
  a2bb86:	e489                	bnez	s1,a2bb90 <hal_watchdog_v151_set_attr+0x12>
  a2bb88:	80000537          	lui	a0,0x80000
  a2bb8c:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2bb8e:	8044                	popret	{ra,s0-s2},16
  a2bb90:	02950433          	mul	s0,a0,s1
  a2bb94:	02945933          	divu	s2,s0,s1
  a2bb98:	6f0000ef          	jal	ra,a2c288 <watchdog_port_get_clock>
  a2bb9c:	fea916e3          	bne	s2,a0,a2bb88 <hal_watchdog_v151_set_attr+0xa>
  a2bba0:	fff46a3b          	bltui	s0,255,a2bb88 <hal_watchdog_v151_set_attr+0xa>
  a2bba4:	00a0 5788 079f      	l.li	a5,0xa05788
  a2bbaa:	00a05937          	lui	s2,0xa05
  a2bbae:	c384                	sw	s1,0(a5)
  a2bbb0:	78092783          	lw	a5,1920(s2) # a05780 <g_watchdog_regs>
  a2bbb4:	5a5a 5a5a 049f      	l.li	s1,0x5a5a5a5a
  a2bbba:	f0047413          	andi	s0,s0,-256
  a2bbbe:	c384                	sw	s1,0(a5)
  a2bbc0:	376d                	jal	ra,a2bb6a <hal_watchdog_v151_disable>
  a2bbc2:	78092783          	lw	a5,1920(s2)
  a2bbc6:	4b98                	lw	a4,16(a5)
  a2bbc8:	00476713          	ori	a4,a4,4
  a2bbcc:	cb98                	sw	a4,16(a5)
  a2bbce:	4b98                	lw	a4,16(a5)
  a2bbd0:	fbf77713          	andi	a4,a4,-65
  a2bbd4:	cb98                	sw	a4,16(a5)
  a2bbd6:	4b98                	lw	a4,16(a5)
  a2bbd8:	03876713          	ori	a4,a4,56
  a2bbdc:	cb98                	sw	a4,16(a5)
  a2bbde:	43c8                	lw	a0,4(a5)
  a2bbe0:	0ff57513          	andi	a0,a0,255
  a2bbe4:	8c49                	or	s0,s0,a0
  a2bbe6:	c3c0                	sw	s0,4(a5)
  a2bbe8:	c784                	sw	s1,8(a5)
  a2bbea:	4501                	li	a0,0
  a2bbec:	b74d                	j	a2bb8e <hal_watchdog_v151_set_attr+0x10>

00a2bbee <hal_watchdog_v151_enable>:
  a2bbee:	8128                	push	{ra,s0},-32
  a2bbf0:	c62a                	sw	a0,12(sp)
  a2bbf2:	3fa5                	jal	ra,a2bb6a <hal_watchdog_v151_disable>
  a2bbf4:	4532                	lw	a0,12(sp)
  a2bbf6:	00a05437          	lui	s0,0xa05
  a2bbfa:	e10d                	bnez	a0,a2bc1c <hal_watchdog_v151_enable+0x2e>
  a2bbfc:	78042703          	lw	a4,1920(s0) # a05780 <g_watchdog_regs>
  a2bc00:	4b1c                	lw	a5,16(a4)
  a2bc02:	f7f7f793          	andi	a5,a5,-129
  a2bc06:	cb1c                	sw	a5,16(a4)
  a2bc08:	3f81                	jal	ra,a2bb58 <hal_watchdog_v151_clear_interrupt>
  a2bc0a:	78042703          	lw	a4,1920(s0)
  a2bc0e:	4b1c                	lw	a5,16(a4)
  a2bc10:	0017e793          	ori	a5,a5,1
  a2bc14:	cb1c                	sw	a5,16(a4)
  a2bc16:	8120                	pop	{ra,s0},32
  a2bc18:	ec7ff06f          	j	a2bade <hal_watchdog_v151_kick>
  a2bc1c:	01f51b3b          	bnei	a0,1,a2bc08 <hal_watchdog_v151_enable+0x1a>
  a2bc20:	78042703          	lw	a4,1920(s0)
  a2bc24:	4b1c                	lw	a5,16(a4)
  a2bc26:	0807e793          	ori	a5,a5,128
  a2bc2a:	bff1                	j	a2bc06 <hal_watchdog_v151_enable+0x18>

00a2bc2c <hal_watchdog_v151_funcs_get>:
  a2bc2c:	00a3 3f30 051f      	l.li	a0,0xa33f30
  a2bc32:	8082                	ret

00a2bc34 <hal_sfc_regs_init>:
  a2bc34:	8058                	push	{ra,s0-s3},-32
  a2bc36:	2569                	jal	ra,a2c2c0 <sfc_port_get_sfc_global_conf_base_addr>
  a2bc38:	00a0 579c 099f      	l.li	s3,0xa0579c
  a2bc3e:	00a9a023          	sw	a0,0(s3)
  a2bc42:	00a0 5790 091f      	l.li	s2,0xa05790
  a2bc48:	2541                	jal	ra,a2c2c8 <sfc_port_get_sfc_bus_regs_base_addr>
  a2bc4a:	00a92023          	sw	a0,0(s2)
  a2bc4e:	00a0 578c 049f      	l.li	s1,0xa0578c
  a2bc54:	2db5                	jal	ra,a2c2d0 <sfc_port_get_sfc_bus_dma_regs_base_addr>
  a2bc56:	c088                	sw	a0,0(s1)
  a2bc58:	00a0 5798 041f      	l.li	s0,0xa05798
  a2bc5e:	2dad                	jal	ra,a2c2d8 <sfc_port_get_sfc_cmd_regs_base_addr>
  a2bc60:	c008                	sw	a0,0(s0)
  a2bc62:	2dbd                	jal	ra,a2c2e0 <sfc_port_get_sfc_cmd_databuf_base_addr>
  a2bc64:	00a0 5794 079f      	l.li	a5,0xa05794
  a2bc6a:	c388                	sw	a0,0(a5)
  a2bc6c:	0009a783          	lw	a5,0(s3)
  a2bc70:	cb99                	beqz	a5,a2bc86 <hal_sfc_regs_init+0x52>
  a2bc72:	00092783          	lw	a5,0(s2)
  a2bc76:	cb81                	beqz	a5,a2bc86 <hal_sfc_regs_init+0x52>
  a2bc78:	409c                	lw	a5,0(s1)
  a2bc7a:	c791                	beqz	a5,a2bc86 <hal_sfc_regs_init+0x52>
  a2bc7c:	401c                	lw	a5,0(s0)
  a2bc7e:	c781                	beqz	a5,a2bc86 <hal_sfc_regs_init+0x52>
  a2bc80:	c119                	beqz	a0,a2bc86 <hal_sfc_regs_init+0x52>
  a2bc82:	4501                	li	a0,0
  a2bc84:	8054                	popret	{ra,s0-s3},32
  a2bc86:	8000 1343 051f      	l.li	a0,0x80001343
  a2bc8c:	bfe5                	j	a2bc84 <hal_sfc_regs_init+0x50>

00a2bc8e <hal_sfc_regs_set_cmd_addr>:
  a2bc8e:	00a057b7          	lui	a5,0xa05
  a2bc92:	7987a683          	lw	a3,1944(a5) # a05798 <g_sfc_cmd_regs>
  a2bc96:	3fff ffff 071f      	l.li	a4,0x3fffffff
  a2bc9c:	8d79                	and	a0,a0,a4
  a2bc9e:	46dc                	lw	a5,12(a3)
  a2bca0:	c0000737          	lui	a4,0xc0000
  a2bca4:	8ff9                	and	a5,a5,a4
  a2bca6:	8fc9                	or	a5,a5,a0
  a2bca8:	c6dc                	sw	a5,12(a3)
  a2bcaa:	8082                	ret

00a2bcac <hal_sfc_regs_wait_ready.constprop.3>:
  a2bcac:	8158                	push	{ra,s0-s3},-48
  a2bcae:	2591                	jal	ra,a2c2f2 <sfc_port_get_delay_times>
  a2bcb0:	84aa                	mv	s1,a0
  a2bcb2:	2d1d                	jal	ra,a2c2e8 <sfc_port_get_delay_once_time>
  a2bcb4:	4792                	lw	a5,4(sp)
  a2bcb6:	ffff c7ff 071f      	l.li	a4,0xffffc7ff
  a2bcbc:	892a                	mv	s2,a0
  a2bcbe:	8077f793          	andi	a5,a5,-2041
  a2bcc2:	0287e793          	ori	a5,a5,40
  a2bcc6:	8ff9                	and	a5,a5,a4
  a2bcc8:	c23e                	sw	a5,4(sp)
  a2bcca:	4785                	li	a5,1
  a2bccc:	c43e                	sw	a5,8(sp)
  a2bcce:	c602                	sw	zero,12(sp)
  a2bcd0:	4401                	li	s0,0
  a2bcd2:	00a059b7          	lui	s3,0xa05
  a2bcd6:	0048                	addi	a0,sp,4
  a2bcd8:	26bd                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2bcda:	4601                	li	a2,0
  a2bcdc:	4585                	li	a1,1
  a2bcde:	4505                	li	a0,1
  a2bce0:	2e79                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2bce2:	26e9                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2bce4:	7949a783          	lw	a5,1940(s3) # a05794 <g_sfc_cmd_databuf>
  a2bce8:	439c                	lw	a5,0(a5)
  a2bcea:	8b85                	andi	a5,a5,1
  a2bcec:	cf91                	beqz	a5,a2bd08 <hal_sfc_regs_wait_ready.constprop.3+0x5c>
  a2bcee:	854a                	mv	a0,s2
  a2bcf0:	ebcfe0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2bcf4:	00140793          	addi	a5,s0,1
  a2bcf8:	00946663          	bltu	s0,s1,a2bd04 <hal_sfc_regs_wait_ready.constprop.3+0x58>
  a2bcfc:	8000 1344 051f      	l.li	a0,0x80001344
  a2bd02:	8154                	popret	{ra,s0-s3},48
  a2bd04:	843e                	mv	s0,a5
  a2bd06:	bfc1                	j	a2bcd6 <hal_sfc_regs_wait_ready.constprop.3+0x2a>
  a2bd08:	4501                	li	a0,0
  a2bd0a:	bfe5                	j	a2bd02 <hal_sfc_regs_wait_ready.constprop.3+0x56>

00a2bd0c <hal_sfc_execute_type_cmd>:
  a2bd0c:	8148                	push	{ra,s0-s2},-32
  a2bd0e:	219c                	lbu	a5,0(a1)
  a2bd10:	842a                	mv	s0,a0
  a2bd12:	892e                	mv	s2,a1
  a2bd14:	078e                	slli	a5,a5,0x3
  a2bd16:	0017e793          	ori	a5,a5,1
  a2bd1a:	c23e                	sw	a5,4(sp)
  a2bd1c:	fff50793          	addi	a5,a0,-1
  a2bd20:	c43e                	sw	a5,8(sp)
  a2bd22:	c602                	sw	zero,12(sp)
  a2bd24:	f89ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2bd28:	84aa                	mv	s1,a0
  a2bd2a:	e50d                	bnez	a0,a2bd54 <hal_sfc_execute_type_cmd+0x48>
  a2bd2c:	0048                	addi	a0,sp,4
  a2bd2e:	2e21                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2bd30:	4785                	li	a5,1
  a2bd32:	c002                	sw	zero,0(sp)
  a2bd34:	0287e263          	bltu	a5,s0,a2bd58 <hal_sfc_execute_type_cmd+0x4c>
  a2bd38:	00a057b7          	lui	a5,0xa05
  a2bd3c:	7947a783          	lw	a5,1940(a5) # a05794 <g_sfc_cmd_databuf>
  a2bd40:	4702                	lw	a4,0(sp)
  a2bd42:	00243593          	sltiu	a1,s0,2
  a2bd46:	4601                	li	a2,0
  a2bd48:	c398                	sw	a4,0(a5)
  a2bd4a:	0015c593          	xori	a1,a1,1
  a2bd4e:	4501                	li	a0,0
  a2bd50:	263d                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2bd52:	2ea9                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2bd54:	8526                	mv	a0,s1
  a2bd56:	8144                	popret	{ra,s0-s2},32
  a2bd58:	00f906b3          	add	a3,s2,a5
  a2bd5c:	2294                	lbu	a3,0(a3)
  a2bd5e:	00f10733          	add	a4,sp,a5
  a2bd62:	0785                	addi	a5,a5,1
  a2bd64:	fed70fa3          	sb	a3,-1(a4) # bfffffff <_gp_+0xbf5cb7bb>
  a2bd68:	b7f1                	j	a2bd34 <hal_sfc_execute_type_cmd+0x28>

00a2bd6a <hal_sfc_write_enable>:
  a2bd6a:	8118                	push	{ra},-32
  a2bd6c:	f41ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2bd70:	4799                	li	a5,6
  a2bd72:	006c                	addi	a1,sp,12
  a2bd74:	4505                	li	a0,1
  a2bd76:	00f10623          	sb	a5,12(sp)
  a2bd7a:	f93ff0ef          	jal	ra,a2bd0c <hal_sfc_execute_type_cmd>
  a2bd7e:	e119                	bnez	a0,a2bd84 <hal_sfc_write_enable+0x1a>
  a2bd80:	f2dff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2bd84:	8114                	popret	{ra},32

00a2bd86 <hal_sfc_reg_write_once>:
  a2bd86:	8648                	push	{ra,s0-s2},-112
  a2bd88:	c636                	sw	a3,12(sp)
  a2bd8a:	892a                	mv	s2,a0
  a2bd8c:	84ae                	mv	s1,a1
  a2bd8e:	8432                	mv	s0,a2
  a2bd90:	3fe9                	jal	ra,a2bd6a <hal_sfc_write_enable>
  a2bd92:	87aa                	mv	a5,a0
  a2bd94:	46b2                	lw	a3,12(sp)
  a2bd96:	e939                	bnez	a0,a2bdec <hal_sfc_reg_write_once+0x66>
  a2bd98:	ca36                	sw	a3,20(sp)
  a2bd9a:	0848                	addi	a0,sp,20
  a2bd9c:	82b9                	srli	a3,a3,0xe
  a2bd9e:	ce36                	sw	a3,28(sp)
  a2bda0:	cc22                	sw	s0,24(sp)
  a2bda2:	2455                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2bda4:	854a                	mv	a0,s2
  a2bda6:	ee9ff0ef          	jal	ra,a2bc8e <hal_sfc_regs_set_cmd_addr>
  a2bdaa:	86a2                	mv	a3,s0
  a2bdac:	8626                	mv	a2,s1
  a2bdae:	04000593          	li	a1,64
  a2bdb2:	1008                	addi	a0,sp,32
  a2bdb4:	51b040ef          	jal	ra,a30ace <memcpy_s>
  a2bdb8:	57fd                	li	a5,-1
  a2bdba:	e90d                	bnez	a0,a2bdec <hal_sfc_reg_write_once+0x66>
  a2bdbc:	00347613          	andi	a2,s0,3
  a2bdc0:	00c03633          	snez	a2,a2
  a2bdc4:	4486061b          	addshf	a2,a2,s0,srl,2
  a2bdc8:	9e21                	uxth	a2
  a2bdca:	101c                	addi	a5,sp,32
  a2bdcc:	4701                	li	a4,0
  a2bdce:	00a055b7          	lui	a1,0xa05
  a2bdd2:	01071693          	slli	a3,a4,0x10
  a2bdd6:	82c1                	srli	a3,a3,0x10
  a2bdd8:	00c6ec63          	bltu	a3,a2,a2bdf0 <hal_sfc_reg_write_once+0x6a>
  a2bddc:	4605                	li	a2,1
  a2bdde:	4585                	li	a1,1
  a2bde0:	4501                	li	a0,0
  a2bde2:	2c71                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2bde4:	24e1                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2bde6:	ec7ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2bdea:	87aa                	mv	a5,a0
  a2bdec:	853e                	mv	a0,a5
  a2bdee:	8644                	popret	{ra,s0-s2},112
  a2bdf0:	7945a683          	lw	a3,1940(a1) # a05794 <g_sfc_cmd_databuf>
  a2bdf4:	4388                	lw	a0,0(a5)
  a2bdf6:	0791                	addi	a5,a5,4
  a2bdf8:	04e6869b          	addshf	a3,a3,a4,sll,2
  a2bdfc:	c288                	sw	a0,0(a3)
  a2bdfe:	0705                	addi	a4,a4,1
  a2be00:	bfc9                	j	a2bdd2 <hal_sfc_reg_write_once+0x4c>

00a2be02 <hal_sfc_get_flash_id>:
  a2be02:	8128                	push	{ra,s0},-32
  a2be04:	842a                	mv	s0,a0
  a2be06:	e2fff0ef          	jal	ra,a2bc34 <hal_sfc_regs_init>
  a2be0a:	ea3ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2be0e:	e91d                	bnez	a0,a2be44 <hal_sfc_get_flash_id+0x42>
  a2be10:	4631                	li	a2,12
  a2be12:	00a3 14dc 059f      	l.li	a1,0xa314dc
  a2be18:	0048                	addi	a0,sp,4
  a2be1a:	c39fc0ef          	jal	ra,a28a52 <memcpy>
  a2be1e:	0048                	addi	a0,sp,4
  a2be20:	241d                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2be22:	4601                	li	a2,0
  a2be24:	4585                	li	a1,1
  a2be26:	4505                	li	a0,1
  a2be28:	2c99                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2be2a:	2449                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2be2c:	00a057b7          	lui	a5,0xa05
  a2be30:	7947a783          	lw	a5,1940(a5) # a05794 <g_sfc_cmd_databuf>
  a2be34:	00ff ffff 071f      	l.li	a4,0xffffff
  a2be3a:	439c                	lw	a5,0(a5)
  a2be3c:	8ff9                	and	a5,a5,a4
  a2be3e:	c01c                	sw	a5,0(s0)
  a2be40:	e6dff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2be44:	8124                	popret	{ra,s0},32

00a2be46 <hal_sfc_init>:
  a2be46:	67c1                	lui	a5,0x10
  a2be48:	0cf66c63          	bltu	a2,a5,a2bf20 <hal_sfc_init+0xda>
  a2be4c:	8198                	push	{ra,s0-s7},-64
  a2be4e:	4940                	lw	s0,20(a0)
  a2be50:	84b2                	mv	s1,a2
  a2be52:	89ae                	mv	s3,a1
  a2be54:	892a                	mv	s2,a0
  a2be56:	4a05                	li	s4,1
  a2be58:	00a05ab7          	lui	s5,0xa05
  a2be5c:	e025                	bnez	s0,a2bebc <hal_sfc_init+0x76>
  a2be5e:	00a057b7          	lui	a5,0xa05
  a2be62:	7907a683          	lw	a3,1936(a5) # a05790 <g_sfc_bus_regs>
  a2be66:	0109d993          	srli	s3,s3,0x10
  a2be6a:	00f4d613          	srli	a2,s1,0xf
  a2be6e:	4e9c                	lw	a5,24(a3)
  a2be70:	4701                	li	a4,0
  a2be72:	01079593          	slli	a1,a5,0x10
  a2be76:	81c1                	srli	a1,a1,0x10
  a2be78:	2135a59b          	orshf	a1,a1,s3,sll,16
  a2be7c:	ce8c                	sw	a1,24(a3)
  a2be7e:	00167793          	andi	a5,a2,1
  a2be82:	cfc1                	beqz	a5,a2bf1a <hal_sfc_init+0xd4>
  a2be84:	4a9c                	lw	a5,16(a3)
  a2be86:	ffff f0ff 061f      	l.li	a2,0xfffff0ff
  a2be8c:	8b3d                	andi	a4,a4,15
  a2be8e:	8ff1                	and	a5,a5,a2
  a2be90:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a2be94:	ca9c                	sw	a5,16(a3)
  a2be96:	00492503          	lw	a0,4(s2)
  a2be9a:	240d                	jal	ra,a2c0bc <hal_sfc_regs_set_bus_read>
  a2be9c:	00c92503          	lw	a0,12(s2)
  a2bea0:	7f857793          	andi	a5,a0,2040
  a2bea4:	c391                	beqz	a5,a2bea8 <hal_sfc_init+0x62>
  a2bea6:	2c89                	jal	ra,a2c0f8 <hal_sfc_regs_set_bus_write>
  a2bea8:	00a057b7          	lui	a5,0xa05
  a2beac:	79c7a783          	lw	a5,1948(a5) # a0579c <g_sfc_global_conf_regs>
  a2beb0:	4705                	li	a4,1
  a2beb2:	cb98                	sw	a4,16(a5)
  a2beb4:	df9ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2beb8:	4501                	li	a0,0
  a2beba:	a00d                	j	a2bedc <hal_sfc_init+0x96>
  a2bebc:	201c                	lbu	a5,0(s0)
  a2bebe:	03478063          	beq	a5,s4,a2bede <hal_sfc_init+0x98>
  a2bec2:	c799                	beqz	a5,a2bed0 <hal_sfc_init+0x8a>
  a2bec4:	02e786bb          	beqi	a5,2,a2be5e <hal_sfc_init+0x18>
  a2bec8:	8000 1345 051f      	l.li	a0,0x80001345
  a2bece:	a039                	j	a2bedc <hal_sfc_init+0x96>
  a2bed0:	3008                	lbu	a0,1(s0)
  a2bed2:	00240593          	addi	a1,s0,2
  a2bed6:	e37ff0ef          	jal	ra,a2bd0c <hal_sfc_execute_type_cmd>
  a2beda:	cd15                	beqz	a0,a2bf16 <hal_sfc_init+0xd0>
  a2bedc:	8194                	popret	{ra,s0-s7},64
  a2bede:	2038                	lbu	a4,2(s0)
  a2bee0:	00344b83          	lbu	s7,3(s0)
  a2bee4:	00444b03          	lbu	s6,4(s0)
  a2bee8:	070e                	slli	a4,a4,0x3
  a2beea:	00176713          	ori	a4,a4,1
  a2beee:	c23a                	sw	a4,4(sp)
  a2bef0:	c452                	sw	s4,8(sp)
  a2bef2:	c602                	sw	zero,12(sp)
  a2bef4:	db9ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2bef8:	0048                	addi	a0,sp,4
  a2befa:	22b1                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2befc:	4601                	li	a2,0
  a2befe:	4585                	li	a1,1
  a2bf00:	4505                	li	a0,1
  a2bf02:	2ab5                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2bf04:	2265                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2bf06:	794aa783          	lw	a5,1940(s5) # a05794 <g_sfc_cmd_databuf>
  a2bf0a:	439c                	lw	a5,0(a5)
  a2bf0c:	0177d7b3          	srl	a5,a5,s7
  a2bf10:	8b85                	andi	a5,a5,1
  a2bf12:	fb679be3          	bne	a5,s6,a2bec8 <hal_sfc_init+0x82>
  a2bf16:	0419                	addi	s0,s0,6
  a2bf18:	b791                	j	a2be5c <hal_sfc_init+0x16>
  a2bf1a:	8205                	srli	a2,a2,0x1
  a2bf1c:	0705                	addi	a4,a4,1
  a2bf1e:	b785                	j	a2be7e <hal_sfc_init+0x38>
  a2bf20:	80000537          	lui	a0,0x80000
  a2bf24:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2bf26:	8082                	ret

00a2bf28 <hal_sfc_reg_read>:
  a2bf28:	8588                	push	{ra,s0-s6},-112
  a2bf2a:	89aa                	mv	s3,a0
  a2bf2c:	8a2e                	mv	s4,a1
  a2bf2e:	84b2                	mv	s1,a2
  a2bf30:	04000413          	li	s0,64
  a2bf34:	00e6da93          	srli	s5,a3,0xe
  a2bf38:	8936                	mv	s2,a3
  a2bf3a:	00a05b37          	lui	s6,0xa05
  a2bf3e:	e099                	bnez	s1,a2bf44 <hal_sfc_reg_read+0x1c>
  a2bf40:	4501                	li	a0,0
  a2bf42:	a8a1                	j	a2bf9a <hal_sfc_reg_read+0x72>
  a2bf44:	d69ff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2bf48:	e929                	bnez	a0,a2bf9a <hal_sfc_reg_read+0x72>
  a2bf4a:	0084f363          	bgeu	s1,s0,a2bf50 <hal_sfc_reg_read+0x28>
  a2bf4e:	8426                	mv	s0,s1
  a2bf50:	0048                	addi	a0,sp,4
  a2bf52:	c24a                	sw	s2,4(sp)
  a2bf54:	c422                	sw	s0,8(sp)
  a2bf56:	c656                	sw	s5,12(sp)
  a2bf58:	20fd                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2bf5a:	854e                	mv	a0,s3
  a2bf5c:	d33ff0ef          	jal	ra,a2bc8e <hal_sfc_regs_set_cmd_addr>
  a2bf60:	4605                	li	a2,1
  a2bf62:	4505                	li	a0,1
  a2bf64:	4585                	li	a1,1
  a2bf66:	2a21                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2bf68:	2291                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2bf6a:	00347793          	andi	a5,s0,3
  a2bf6e:	00f037b3          	snez	a5,a5
  a2bf72:	794b2503          	lw	a0,1940(s6) # a05794 <g_sfc_cmd_databuf>
  a2bf76:	4487879b          	addshf	a5,a5,s0,srl,2
  a2bf7a:	0814                	addi	a3,sp,16
  a2bf7c:	9fa1                	uxth	a5
  a2bf7e:	4701                	li	a4,0
  a2bf80:	8636                	mv	a2,a3
  a2bf82:	01071593          	slli	a1,a4,0x10
  a2bf86:	81c1                	srli	a1,a1,0x10
  a2bf88:	00f5ea63          	bltu	a1,a5,a2bf9c <hal_sfc_reg_read+0x74>
  a2bf8c:	86a2                	mv	a3,s0
  a2bf8e:	85a2                	mv	a1,s0
  a2bf90:	8552                	mv	a0,s4
  a2bf92:	33d040ef          	jal	ra,a30ace <memcpy_s>
  a2bf96:	c919                	beqz	a0,a2bfac <hal_sfc_reg_read+0x84>
  a2bf98:	557d                	li	a0,-1
  a2bf9a:	8584                	popret	{ra,s0-s6},112
  a2bf9c:	04e5059b          	addshf	a1,a0,a4,sll,2
  a2bfa0:	418c                	lw	a1,0(a1)
  a2bfa2:	0705                	addi	a4,a4,1
  a2bfa4:	0691                	addi	a3,a3,4
  a2bfa6:	feb6ae23          	sw	a1,-4(a3)
  a2bfaa:	bfe1                	j	a2bf82 <hal_sfc_reg_read+0x5a>
  a2bfac:	99a2                	add	s3,s3,s0
  a2bfae:	9a22                	add	s4,s4,s0
  a2bfb0:	8c81                	sub	s1,s1,s0
  a2bfb2:	b771                	j	a2bf3e <hal_sfc_reg_read+0x16>

00a2bfb4 <hal_sfc_reg_write>:
  a2bfb4:	8088                	push	{ra,s0-s6},-32
  a2bfb6:	03f57793          	andi	a5,a0,63
  a2bfba:	04000413          	li	s0,64
  a2bfbe:	8c1d                	sub	s0,s0,a5
  a2bfc0:	89aa                	mv	s3,a0
  a2bfc2:	892e                	mv	s2,a1
  a2bfc4:	84b2                	mv	s1,a2
  a2bfc6:	8ab6                	mv	s5,a3
  a2bfc8:	00867363          	bgeu	a2,s0,a2bfce <hal_sfc_reg_write+0x1a>
  a2bfcc:	8432                	mv	s0,a2
  a2bfce:	86d6                	mv	a3,s5
  a2bfd0:	8622                	mv	a2,s0
  a2bfd2:	85ca                	mv	a1,s2
  a2bfd4:	854e                	mv	a0,s3
  a2bfd6:	db1ff0ef          	jal	ra,a2bd86 <hal_sfc_reg_write_once>
  a2bfda:	8a2a                	mv	s4,a0
  a2bfdc:	e905                	bnez	a0,a2c00c <hal_sfc_reg_write+0x58>
  a2bfde:	8c81                	sub	s1,s1,s0
  a2bfe0:	c495                	beqz	s1,a2c00c <hal_sfc_reg_write+0x58>
  a2bfe2:	9922                	add	s2,s2,s0
  a2bfe4:	04000b13          	li	s6,64
  a2bfe8:	944e                	add	s0,s0,s3
  a2bfea:	89a6                	mv	s3,s1
  a2bfec:	009b7463          	bgeu	s6,s1,a2bff4 <hal_sfc_reg_write+0x40>
  a2bff0:	04000993          	li	s3,64
  a2bff4:	86d6                	mv	a3,s5
  a2bff6:	864e                	mv	a2,s3
  a2bff8:	85ca                	mv	a1,s2
  a2bffa:	8522                	mv	a0,s0
  a2bffc:	d8bff0ef          	jal	ra,a2bd86 <hal_sfc_reg_write_once>
  a2c000:	e901                	bnez	a0,a2c010 <hal_sfc_reg_write+0x5c>
  a2c002:	413484b3          	sub	s1,s1,s3
  a2c006:	994e                	add	s2,s2,s3
  a2c008:	944e                	add	s0,s0,s3
  a2c00a:	f0e5                	bnez	s1,a2bfea <hal_sfc_reg_write+0x36>
  a2c00c:	8552                	mv	a0,s4
  a2c00e:	8084                	popret	{ra,s0-s6},32
  a2c010:	8a2a                	mv	s4,a0
  a2c012:	bfed                	j	a2c00c <hal_sfc_reg_write+0x58>

00a2c014 <hal_sfc_reg_erase>:
  a2c014:	8238                	push	{ra,s0-s1},-48
  a2c016:	c62e                	sw	a1,12(sp)
  a2c018:	84aa                	mv	s1,a0
  a2c01a:	8432                	mv	s0,a2
  a2c01c:	d4fff0ef          	jal	ra,a2bd6a <hal_sfc_write_enable>
  a2c020:	45b2                	lw	a1,12(sp)
  a2c022:	e10d                	bnez	a0,a2c044 <hal_sfc_reg_erase+0x30>
  a2c024:	0848                	addi	a0,sp,20
  a2c026:	ca2e                	sw	a1,20(sp)
  a2c028:	cc02                	sw	zero,24(sp)
  a2c02a:	ce02                	sw	zero,28(sp)
  a2c02c:	2829                	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2c02e:	8526                	mv	a0,s1
  a2c030:	c5fff0ef          	jal	ra,a2bc8e <hal_sfc_regs_set_cmd_addr>
  a2c034:	00144613          	xori	a2,s0,1
  a2c038:	4581                	li	a1,0
  a2c03a:	4501                	li	a0,0
  a2c03c:	2089                	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2c03e:	20bd                	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2c040:	c6dff0ef          	jal	ra,a2bcac <hal_sfc_regs_wait_ready.constprop.3>
  a2c044:	8234                	popret	{ra,s0-s1},48

00a2c046 <hal_sfc_regs_set_opt>:
  a2c046:	00a057b7          	lui	a5,0xa05
  a2c04a:	7987a603          	lw	a2,1944(a5) # a05798 <g_sfc_cmd_regs>
  a2c04e:	411c                	lw	a5,0(a0)
  a2c050:	450c                	lw	a1,8(a0)
  a2c052:	4618                	lw	a4,8(a2)
  a2c054:	0037d693          	srli	a3,a5,0x3
  a2c058:	9e81                	uxtb	a3
  a2c05a:	f0077713          	andi	a4,a4,-256
  a2c05e:	8f55                	or	a4,a4,a3
  a2c060:	4154                	lw	a3,4(a0)
  a2c062:	83ad                	srli	a5,a5,0xb
  a2c064:	8b9d                	andi	a5,a5,7
  a2c066:	899d                	andi	a1,a1,7
  a2c068:	07c6                	slli	a5,a5,0x11
  a2c06a:	16fd                	addi	a3,a3,-1
  a2c06c:	03f6f693          	andi	a3,a3,63
  a2c070:	08b7a79b          	orshf	a5,a5,a1,sll,4
  a2c074:	12d7a79b          	orshf	a5,a5,a3,sll,9
  a2c078:	c618                	sw	a4,8(a2)
  a2c07a:	c21c                	sw	a5,0(a2)
  a2c07c:	8082                	ret

00a2c07e <hal_sfc_regs_set_opt_attr>:
  a2c07e:	00a057b7          	lui	a5,0xa05
  a2c082:	7987a703          	lw	a4,1944(a5) # a05798 <g_sfc_cmd_regs>
  a2c086:	8905                	andi	a0,a0,1
  a2c088:	8985                	andi	a1,a1,1
  a2c08a:	431c                	lw	a5,0(a4)
  a2c08c:	8a05                	andi	a2,a2,1
  a2c08e:	eff7f793          	andi	a5,a5,-257
  a2c092:	10a7a79b          	orshf	a5,a5,a0,sll,8
  a2c096:	f7f7f793          	andi	a5,a5,-129
  a2c09a:	0eb7a79b          	orshf	a5,a5,a1,sll,7
  a2c09e:	9bdd                	andi	a5,a5,-9
  a2c0a0:	06c7a79b          	orshf	a5,a5,a2,sll,3
  a2c0a4:	0037e793          	ori	a5,a5,3
  a2c0a8:	c31c                	sw	a5,0(a4)
  a2c0aa:	8082                	ret

00a2c0ac <hal_sfc_regs_wait_config>:
  a2c0ac:	00a057b7          	lui	a5,0xa05
  a2c0b0:	7987a703          	lw	a4,1944(a5) # a05798 <g_sfc_cmd_regs>
  a2c0b4:	431c                	lw	a5,0(a4)
  a2c0b6:	8b85                	andi	a5,a5,1
  a2c0b8:	fff5                	bnez	a5,a2c0b4 <hal_sfc_regs_wait_config+0x8>
  a2c0ba:	8082                	ret

00a2c0bc <hal_sfc_regs_set_bus_read>:
  a2c0bc:	00a057b7          	lui	a5,0xa05
  a2c0c0:	7907a603          	lw	a2,1936(a5) # a05790 <g_sfc_bus_regs>
  a2c0c4:	80000737          	lui	a4,0x80000
  a2c0c8:	ffff 00ff 069f      	l.li	a3,0xffff00ff
  a2c0ce:	421c                	lw	a5,0(a2)
  a2c0d0:	8fd9                	or	a5,a5,a4
  a2c0d2:	00355713          	srli	a4,a0,0x3
  a2c0d6:	9f01                	uxtb	a4
  a2c0d8:	8ff5                	and	a5,a5,a3
  a2c0da:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a2c0de:	00b55693          	srli	a3,a0,0xb
  a2c0e2:	8a9d                	andi	a3,a3,7
  a2c0e4:	812d                	srli	a0,a0,0xb
  a2c0e6:	fc07f793          	andi	a5,a5,-64
  a2c0ea:	03857713          	andi	a4,a0,56
  a2c0ee:	00d7e533          	or	a0,a5,a3
  a2c0f2:	8d59                	or	a0,a0,a4
  a2c0f4:	c208                	sw	a0,0(a2)
  a2c0f6:	8082                	ret

00a2c0f8 <hal_sfc_regs_set_bus_write>:
  a2c0f8:	00a057b7          	lui	a5,0xa05
  a2c0fc:	7907a683          	lw	a3,1936(a5) # a05790 <g_sfc_bus_regs>
  a2c100:	00355713          	srli	a4,a0,0x3
  a2c104:	c03f ffff 061f      	l.li	a2,0xc03fffff
  a2c10a:	429c                	lw	a5,0(a3)
  a2c10c:	9f01                	uxtb	a4
  a2c10e:	812d                	srli	a0,a0,0xb
  a2c110:	8ff1                	and	a5,a5,a2
  a2c112:	2ce7a79b          	orshf	a5,a5,a4,sll,22
  a2c116:	fff8 ffff 071f      	l.li	a4,0xfff8ffff
  a2c11c:	8ff9                	and	a5,a5,a4
  a2c11e:	891d                	andi	a0,a0,7
  a2c120:	20a7a79b          	orshf	a5,a5,a0,sll,16
  a2c124:	40000737          	lui	a4,0x40000
  a2c128:	8fd9                	or	a5,a5,a4
  a2c12a:	c29c                	sw	a5,0(a3)
  a2c12c:	8082                	ret

00a2c12e <pmp_enable>:
  a2c12e:	8148                	push	{ra,s0-s2},-32
  a2c130:	004c                	addi	a1,sp,4
  a2c132:	02000513          	li	a0,32
  a2c136:	c202                	sw	zero,4(sp)
  a2c138:	c402                	sw	zero,8(sp)
  a2c13a:	c602                	sw	zero,12(sp)
  a2c13c:	3d7010ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2c140:	4722                	lw	a4,8(sp)
  a2c142:	00a34437          	lui	s0,0xa34
  a2c146:	00200937          	lui	s2,0x200
  a2c14a:	974a                	add	a4,a4,s2
  a2c14c:	f5440493          	addi	s1,s0,-172 # a33f54 <g_region_attr>
  a2c150:	004c                	addi	a1,sp,4
  a2c152:	02100513          	li	a0,33
  a2c156:	d0d8                	sw	a4,36(s1)
  a2c158:	3bb010ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2c15c:	47a2                	lw	a5,8(sp)
  a2c15e:	4595                	li	a1,5
  a2c160:	f5440513          	addi	a0,s0,-172
  a2c164:	97ca                	add	a5,a5,s2
  a2c166:	d8dc                	sw	a5,52(s1)
  a2c168:	88ffd0ef          	jal	ra,a299f6 <uapi_pmp_config>
  a2c16c:	8144                	popret	{ra,s0-s2},32

00a2c16e <print_str_inner>:
  a2c16e:	8028                	push	{ra,s0},-16
  a2c170:	00a05437          	lui	s0,0xa05
  a2c174:	872e                	mv	a4,a1
  a2c176:	86aa                	mv	a3,a0
  a2c178:	07f00613          	li	a2,127
  a2c17c:	08000593          	li	a1,128
  a2c180:	7a440513          	addi	a0,s0,1956 # a057a4 <str_buf.3002>
  a2c184:	308050ef          	jal	ra,a3148c <vsnprintf_s>
  a2c188:	7a440793          	addi	a5,s0,1956
  a2c18c:	862a                	mv	a2,a0
  a2c18e:	ff0513bb          	bnei	a0,-1,a2c19c <print_str_inner+0x2e>
  a2c192:	2398                	lbu	a4,0(a5)
  a2c194:	07f00613          	li	a2,127
  a2c198:	e311                	bnez	a4,a2c19c <print_str_inner+0x2e>
  a2c19a:	8024                	popret	{ra,s0},16
  a2c19c:	97b2                	add	a5,a5,a2
  a2c19e:	00078023          	sb	zero,0(a5)
  a2c1a2:	00a0 57a0 079f      	l.li	a5,0xa057a0
  a2c1a8:	2388                	lbu	a0,0(a5)
  a2c1aa:	4681                	li	a3,0
  a2c1ac:	7a440593          	addi	a1,s0,1956
  a2c1b0:	8020                	pop	{ra,s0},16
  a2c1b2:	e08fe06f          	j	a2a7ba <uapi_uart_write>

00a2c1b6 <uart_port_register_hal_funcs>:
  a2c1b6:	8028                	push	{ra,s0},-16
  a2c1b8:	842a                	mv	s0,a0
  a2c1ba:	8c5ff0ef          	jal	ra,a2ba7e <hal_uart_v151_funcs_get>
  a2c1be:	85aa                	mv	a1,a0
  a2c1c0:	8522                	mv	a0,s0
  a2c1c2:	8020                	pop	{ra,s0},16
  a2c1c4:	c18ff06f          	j	a2b5dc <hal_uart_register_funcs>

00a2c1c8 <uart_port_set_clock_value>:
  a2c1c8:	00a3 3fa4 079f      	l.li	a5,0xa33fa4
  a2c1ce:	c38c                	sw	a1,0(a5)
  a2c1d0:	8082                	ret

00a2c1d2 <uart_port_get_clock_value>:
  a2c1d2:	00a3 3fa4 079f      	l.li	a5,0xa33fa4
  a2c1d8:	4388                	lw	a0,0(a5)
  a2c1da:	8082                	ret

00a2c1dc <uart_port_config_pinmux>:
  a2c1dc:	020513bb          	bnei	a0,2,a2c1ea <uart_port_config_pinmux+0xe>
  a2c1e0:	4400d7b7          	lui	a5,0x4400d
  a2c1e4:	4705                	li	a4,1
  a2c1e6:	db98                	sw	a4,48(a5)
  a2c1e8:	dbd8                	sw	a4,52(a5)
  a2c1ea:	8082                	ret

00a2c1ec <uart_port_register_irq>:
  a2c1ec:	8082                	ret

00a2c1ee <uart_port_unregister_irq>:
  a2c1ee:	8082                	ret

00a2c1f0 <print_str>:
  a2c1f0:	7139                	addi	sp,sp,-64
  a2c1f2:	ce06                	sw	ra,28(sp)
  a2c1f4:	cc22                	sw	s0,24(sp)
  a2c1f6:	d22e                	sw	a1,36(sp)
  a2c1f8:	d432                	sw	a2,40(sp)
  a2c1fa:	d636                	sw	a3,44(sp)
  a2c1fc:	d83a                	sw	a4,48(sp)
  a2c1fe:	da3e                	sw	a5,52(sp)
  a2c200:	dc42                	sw	a6,56(sp)
  a2c202:	de46                	sw	a7,60(sp)
  a2c204:	c911                	beqz	a0,a2c218 <print_str+0x28>
  a2c206:	842a                	mv	s0,a0
  a2c208:	b05fc0ef          	jal	ra,a28d0c <strlen>
  a2c20c:	c511                	beqz	a0,a2c218 <print_str+0x28>
  a2c20e:	104c                	addi	a1,sp,36
  a2c210:	8522                	mv	a0,s0
  a2c212:	c62e                	sw	a1,12(sp)
  a2c214:	f5bff0ef          	jal	ra,a2c16e <print_str_inner>
  a2c218:	40f2                	lw	ra,28(sp)
  a2c21a:	4462                	lw	s0,24(sp)
  a2c21c:	6121                	addi	sp,sp,64
  a2c21e:	8082                	ret

00a2c220 <uart_porting_lock>:
  a2c220:	fccfd06f          	j	a299ec <osal_irq_lock>

00a2c224 <uart_porting_unlock>:
  a2c224:	852e                	mv	a0,a1
  a2c226:	fcefd06f          	j	a299f4 <osal_irq_restore>

00a2c22a <hal_systick_get_count>:
  a2c22a:	400057b7          	lui	a5,0x40005
  a2c22e:	4fd8                	lw	a4,28(a5)
  a2c230:	4f98                	lw	a4,24(a5)
  a2c232:	4fc8                	lw	a0,28(a5)
  a2c234:	4f8c                	lw	a1,24(a5)
  a2c236:	9da1                	uxth	a1
  a2c238:	8082                	ret

00a2c23a <systick_clock_get>:
  a2c23a:	00a3 3fa8 079f      	l.li	a5,0xa33fa8
  a2c240:	4388                	lw	a0,0(a5)
  a2c242:	8082                	ret

00a2c244 <tcxo_porting_base_addr_get>:
  a2c244:	4400 04c0 051f      	l.li	a0,0x440004c0
  a2c24a:	8082                	ret

00a2c24c <tcxo_porting_ticks_per_usec_get>:
  a2c24c:	00a3 3fac 079f      	l.li	a5,0xa33fac
  a2c252:	4388                	lw	a0,0(a5)
  a2c254:	8082                	ret

00a2c256 <tcxo_porting_ticks_per_usec_set>:
  a2c256:	00a3 3fac 079f      	l.li	a5,0xa33fac
  a2c25c:	c388                	sw	a0,0(a5)
  a2c25e:	8082                	ret

00a2c260 <watchdog_port_register_hal_funcs>:
  a2c260:	8018                	push	{ra},-16
  a2c262:	9cbff0ef          	jal	ra,a2bc2c <hal_watchdog_v151_funcs_get>
  a2c266:	8010                	pop	{ra},16
  a2c268:	81fff06f          	j	a2ba86 <hal_watchdog_register_funcs>

00a2c26c <watchdog_port_unregister_hal_funcs>:
  a2c26c:	831ff06f          	j	a2ba9c <hal_watchdog_unregister_funcs>

00a2c270 <watchdog_port_register_irq>:
  a2c270:	8082                	ret

00a2c272 <watchdog_port_set_clock>:
  a2c272:	8028                	push	{ra,s0},-16
  a2c274:	842a                	mv	s0,a0
  a2c276:	f76fd0ef          	jal	ra,a299ec <osal_irq_lock>
  a2c27a:	00a3 3fb4 079f      	l.li	a5,0xa33fb4
  a2c280:	c380                	sw	s0,0(a5)
  a2c282:	8020                	pop	{ra,s0},16
  a2c284:	f70fd06f          	j	a299f4 <osal_irq_restore>

00a2c288 <watchdog_port_get_clock>:
  a2c288:	00a3 3fb4 079f      	l.li	a5,0xa33fb4
  a2c28e:	4388                	lw	a0,0(a5)
  a2c290:	8082                	ret

00a2c292 <pmp_port_register_hal_funcs>:
  a2c292:	8018                	push	{ra},-16
  a2c294:	a09fe0ef          	jal	ra,a2ac9c <hal_pmp_riscv31_funcs_get>
  a2c298:	8010                	pop	{ra},16
  a2c29a:	997fe06f          	j	a2ac30 <hal_pmp_register_funcs>

00a2c29e <sfc_port_get_flash_spi_infos>:
  a2c29e:	00a3 2820 051f      	l.li	a0,0xa32820
  a2c2a4:	8082                	ret

00a2c2a6 <sfc_port_get_flash_num>:
  a2c2a6:	4505                	li	a0,1
  a2c2a8:	8082                	ret

00a2c2aa <sfc_port_get_unknown_flash_info>:
  a2c2aa:	00a3 283c 051f      	l.li	a0,0xa3283c
  a2c2b0:	8082                	ret

00a2c2b2 <sfc_port_get_sfc_start_addr>:
  a2c2b2:	00200537          	lui	a0,0x200
  a2c2b6:	8082                	ret

00a2c2b8 <sfc_port_get_sfc_end_addr>:
  a2c2b8:	009f ffff 051f      	l.li	a0,0x9fffff
  a2c2be:	8082                	ret

00a2c2c0 <sfc_port_get_sfc_global_conf_base_addr>:
  a2c2c0:	4800 0100 051f      	l.li	a0,0x48000100
  a2c2c6:	8082                	ret

00a2c2c8 <sfc_port_get_sfc_bus_regs_base_addr>:
  a2c2c8:	4800 0200 051f      	l.li	a0,0x48000200
  a2c2ce:	8082                	ret

00a2c2d0 <sfc_port_get_sfc_bus_dma_regs_base_addr>:
  a2c2d0:	4800 0240 051f      	l.li	a0,0x48000240
  a2c2d6:	8082                	ret

00a2c2d8 <sfc_port_get_sfc_cmd_regs_base_addr>:
  a2c2d8:	4800 0300 051f      	l.li	a0,0x48000300
  a2c2de:	8082                	ret

00a2c2e0 <sfc_port_get_sfc_cmd_databuf_base_addr>:
  a2c2e0:	4800 0400 051f      	l.li	a0,0x48000400
  a2c2e6:	8082                	ret

00a2c2e8 <sfc_port_get_delay_once_time>:
  a2c2e8:	00a3 3fb8 079f      	l.li	a5,0xa33fb8
  a2c2ee:	4388                	lw	a0,0(a5)
  a2c2f0:	8082                	ret

00a2c2f2 <sfc_port_get_delay_times>:
  a2c2f2:	00a3 3fbc 079f      	l.li	a5,0xa33fbc
  a2c2f8:	4388                	lw	a0,0(a5)
  a2c2fa:	8082                	ret

00a2c2fc <sfc_port_lock_init>:
  a2c2fc:	8082                	ret

00a2c2fe <sfc_port_lock>:
  a2c2fe:	4501                	li	a0,0
  a2c300:	8082                	ret

00a2c302 <sfc_port_unlock>:
  a2c302:	8082                	ret

00a2c304 <hal_sfc_regs_wait_ready.constprop.0>:
  a2c304:	8158                	push	{ra,s0-s3},-48
  a2c306:	fedff0ef          	jal	ra,a2c2f2 <sfc_port_get_delay_times>
  a2c30a:	84aa                	mv	s1,a0
  a2c30c:	fddff0ef          	jal	ra,a2c2e8 <sfc_port_get_delay_once_time>
  a2c310:	02800793          	li	a5,40
  a2c314:	c23e                	sw	a5,4(sp)
  a2c316:	4785                	li	a5,1
  a2c318:	892a                	mv	s2,a0
  a2c31a:	c602                	sw	zero,12(sp)
  a2c31c:	c43e                	sw	a5,8(sp)
  a2c31e:	4401                	li	s0,0
  a2c320:	00a059b7          	lui	s3,0xa05
  a2c324:	0048                	addi	a0,sp,4
  a2c326:	d21ff0ef          	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2c32a:	4601                	li	a2,0
  a2c32c:	4585                	li	a1,1
  a2c32e:	4505                	li	a0,1
  a2c330:	d4fff0ef          	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2c334:	d79ff0ef          	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2c338:	7949a783          	lw	a5,1940(s3) # a05794 <g_sfc_cmd_databuf>
  a2c33c:	439c                	lw	a5,0(a5)
  a2c33e:	8b85                	andi	a5,a5,1
  a2c340:	cf91                	beqz	a5,a2c35c <hal_sfc_regs_wait_ready.constprop.0+0x58>
  a2c342:	854a                	mv	a0,s2
  a2c344:	868fe0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2c348:	00140793          	addi	a5,s0,1
  a2c34c:	00946663          	bltu	s0,s1,a2c358 <hal_sfc_regs_wait_ready.constprop.0+0x54>
  a2c350:	8000 1344 051f      	l.li	a0,0x80001344
  a2c356:	8154                	popret	{ra,s0-s3},48
  a2c358:	843e                	mv	s0,a5
  a2c35a:	b7e9                	j	a2c324 <hal_sfc_regs_wait_ready.constprop.0+0x20>
  a2c35c:	4501                	li	a0,0
  a2c35e:	bfe5                	j	a2c356 <hal_sfc_regs_wait_ready.constprop.0+0x52>

00a2c360 <sfc_port_write_sr>:
  a2c360:	8148                	push	{ra,s0-s2},-32
  a2c362:	892a                	mv	s2,a0
  a2c364:	842e                	mv	s0,a1
  a2c366:	84b2                	mv	s1,a2
  a2c368:	f9dff0ef          	jal	ra,a2c304 <hal_sfc_regs_wait_ready.constprop.0>
  a2c36c:	4792                	lw	a5,4(sp)
  a2c36e:	4719                	li	a4,6
  a2c370:	9be1                	andi	a5,a5,-8
  a2c372:	0017e793          	ori	a5,a5,1
  a2c376:	c23e                	sw	a5,4(sp)
  a2c378:	00090463          	beqz	s2,a2c380 <sfc_port_write_sr+0x20>
  a2c37c:	05000713          	li	a4,80
  a2c380:	4792                	lw	a5,4(sp)
  a2c382:	0048                	addi	a0,sp,4
  a2c384:	c402                	sw	zero,8(sp)
  a2c386:	8077f793          	andi	a5,a5,-2041
  a2c38a:	06e7a79b          	orshf	a5,a5,a4,sll,3
  a2c38e:	7ff7f793          	andi	a5,a5,2047
  a2c392:	c23e                	sw	a5,4(sp)
  a2c394:	c602                	sw	zero,12(sp)
  a2c396:	cb1ff0ef          	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2c39a:	4601                	li	a2,0
  a2c39c:	4581                	li	a1,0
  a2c39e:	4501                	li	a0,0
  a2c3a0:	cdfff0ef          	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2c3a4:	d09ff0ef          	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2c3a8:	4785                	li	a5,1
  a2c3aa:	c43e                	sw	a5,8(sp)
  a2c3ac:	00a057b7          	lui	a5,0xa05
  a2c3b0:	7947a783          	lw	a5,1940(a5) # a05794 <g_sfc_cmd_databuf>
  a2c3b4:	040e                	slli	s0,s0,0x3
  a2c3b6:	00146413          	ori	s0,s0,1
  a2c3ba:	c222                	sw	s0,4(sp)
  a2c3bc:	c602                	sw	zero,12(sp)
  a2c3be:	c384                	sw	s1,0(a5)
  a2c3c0:	0048                	addi	a0,sp,4
  a2c3c2:	c85ff0ef          	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2c3c6:	4601                	li	a2,0
  a2c3c8:	4585                	li	a1,1
  a2c3ca:	4501                	li	a0,0
  a2c3cc:	cb3ff0ef          	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2c3d0:	cddff0ef          	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2c3d4:	8144                	popret	{ra,s0-s2},32

00a2c3d6 <sfc_port_read_sr>:
  a2c3d6:	8118                	push	{ra},-32
  a2c3d8:	9d01                	uxtb	a0
  a2c3da:	4785                	li	a5,1
  a2c3dc:	050e                	slli	a0,a0,0x3
  a2c3de:	c43e                	sw	a5,8(sp)
  a2c3e0:	c602                	sw	zero,12(sp)
  a2c3e2:	c22a                	sw	a0,4(sp)
  a2c3e4:	f21ff0ef          	jal	ra,a2c304 <hal_sfc_regs_wait_ready.constprop.0>
  a2c3e8:	0048                	addi	a0,sp,4
  a2c3ea:	c5dff0ef          	jal	ra,a2c046 <hal_sfc_regs_set_opt>
  a2c3ee:	4601                	li	a2,0
  a2c3f0:	4585                	li	a1,1
  a2c3f2:	4505                	li	a0,1
  a2c3f4:	c8bff0ef          	jal	ra,a2c07e <hal_sfc_regs_set_opt_attr>
  a2c3f8:	cb5ff0ef          	jal	ra,a2c0ac <hal_sfc_regs_wait_config>
  a2c3fc:	00a057b7          	lui	a5,0xa05
  a2c400:	7947a783          	lw	a5,1940(a5) # a05794 <g_sfc_cmd_databuf>
  a2c404:	4388                	lw	a0,0(a5)
  a2c406:	8114                	popret	{ra},32

00a2c408 <sfc_port_write_lock>:
  a2c408:	000207b7          	lui	a5,0x20
  a2c40c:	02f56563          	bltu	a0,a5,a2c436 <sfc_port_write_lock+0x2e>
  a2c410:	004007b7          	lui	a5,0x400
  a2c414:	02b7e163          	bltu	a5,a1,a2c436 <sfc_port_write_lock+0x2e>
  a2c418:	8018                	push	{ra},-16
  a2c41a:	02800613          	li	a2,40
  a2c41e:	4585                	li	a1,1
  a2c420:	4505                	li	a0,1
  a2c422:	f3fff0ef          	jal	ra,a2c360 <sfc_port_write_sr>
  a2c426:	4609                	li	a2,2
  a2c428:	03100593          	li	a1,49
  a2c42c:	4505                	li	a0,1
  a2c42e:	f33ff0ef          	jal	ra,a2c360 <sfc_port_write_sr>
  a2c432:	4501                	li	a0,0
  a2c434:	8014                	popret	{ra},16
  a2c436:	4501                	li	a0,0
  a2c438:	8082                	ret

00a2c43a <sfc_port_write_unlock>:
  a2c43a:	8018                	push	{ra},-16
  a2c43c:	4671                	li	a2,28
  a2c43e:	4585                	li	a1,1
  a2c440:	4505                	li	a0,1
  a2c442:	f1fff0ef          	jal	ra,a2c360 <sfc_port_write_sr>
  a2c446:	4609                	li	a2,2
  a2c448:	03100593          	li	a1,49
  a2c44c:	4505                	li	a0,1
  a2c44e:	8010                	pop	{ra},16
  a2c450:	f11ff06f          	j	a2c360 <sfc_port_write_sr>

00a2c454 <sfc_port_fix_sr>:
  a2c454:	8118                	push	{ra},-32
  a2c456:	0068                	addi	a0,sp,12
  a2c458:	c602                	sw	zero,12(sp)
  a2c45a:	9a9ff0ef          	jal	ra,a2be02 <hal_sfc_get_flash_id>
  a2c45e:	e901                	bnez	a0,a2c46e <sfc_port_fix_sr+0x1a>
  a2c460:	4732                	lw	a4,12(sp)
  a2c462:	0016 40c8 079f      	l.li	a5,0x1640c8
  a2c468:	00f71463          	bne	a4,a5,a2c470 <sfc_port_fix_sr+0x1c>
  a2c46c:	2079                	jal	ra,a2c4fa <sfc_port_fix_sr_gd25q32>
  a2c46e:	8114                	popret	{ra},32
  a2c470:	80000537          	lui	a0,0x80000
  a2c474:	0509                	addi	a0,a0,2 # 80000002 <_gp_+0x7f5cb7be>
  a2c476:	bfe5                	j	a2c46e <sfc_port_fix_sr+0x1a>

00a2c478 <sfc_port_gd25q32_read_sr>:
  a2c478:	8078                	push	{ra,s0-s5},-32
  a2c47a:	892a                	mv	s2,a0
  a2c47c:	448d                	li	s1,3
  a2c47e:	4995                	li	s3,5
  a2c480:	03500a13          	li	s4,53
  a2c484:	00a33ab7          	lui	s5,0xa33
  a2c488:	854a                	mv	a0,s2
  a2c48a:	f4dff0ef          	jal	ra,a2c3d6 <sfc_port_read_sr>
  a2c48e:	0ff57413          	andi	s0,a0,255
  a2c492:	03391f63          	bne	s2,s3,a2c4d0 <sfc_port_gd25q32_read_sr+0x58>
  a2c496:	09c47413          	andi	s0,s0,156
  a2c49a:	1411                	addi	s0,s0,-28
  a2c49c:	00143413          	seqz	s0,s0
  a2c4a0:	4585                	li	a1,1
  a2c4a2:	46f1                	li	a3,28
  a2c4a4:	e419                	bnez	s0,a2c4b2 <sfc_port_gd25q32_read_sr+0x3a>
  a2c4a6:	0ff57613          	andi	a2,a0,255
  a2c4aa:	880a8513          	addi	a0,s5,-1920 # a32880 <g_flash_spi_unknown_info+0x44>
  a2c4ae:	d43ff0ef          	jal	ra,a2c1f0 <print_str>
  a2c4b2:	e7bfd0ef          	jal	ra,a2a32c <uapi_tcxo_get_count>
  a2c4b6:	06400613          	li	a2,100
  a2c4ba:	4681                	li	a3,0
  a2c4bc:	8e4fc0ef          	jal	ra,a285a0 <__umoddi3>
  a2c4c0:	0505                	addi	a0,a0,1
  a2c4c2:	eebfd0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2c4c6:	c805                	beqz	s0,a2c4f6 <sfc_port_gd25q32_read_sr+0x7e>
  a2c4c8:	14fd                	addi	s1,s1,-1
  a2c4ca:	fcdd                	bnez	s1,a2c488 <sfc_port_gd25q32_read_sr+0x10>
  a2c4cc:	4501                	li	a0,0
  a2c4ce:	8074                	popret	{ra,s0-s5},32
  a2c4d0:	01491a63          	bne	s2,s4,a2c4e4 <sfc_port_gd25q32_read_sr+0x6c>
  a2c4d4:	04347413          	andi	s0,s0,67
  a2c4d8:	1479                	addi	s0,s0,-2
  a2c4da:	00143413          	seqz	s0,s0
  a2c4de:	4589                	li	a1,2
  a2c4e0:	4689                	li	a3,2
  a2c4e2:	b7c9                	j	a2c4a4 <sfc_port_gd25q32_read_sr+0x2c>
  a2c4e4:	06147413          	andi	s0,s0,97
  a2c4e8:	1401                	addi	s0,s0,-32
  a2c4ea:	00143413          	seqz	s0,s0
  a2c4ee:	458d                	li	a1,3
  a2c4f0:	02000693          	li	a3,32
  a2c4f4:	bf45                	j	a2c4a4 <sfc_port_gd25q32_read_sr+0x2c>
  a2c4f6:	557d                	li	a0,-1
  a2c4f8:	bfd9                	j	a2c4ce <sfc_port_gd25q32_read_sr+0x56>

00a2c4fa <sfc_port_fix_sr_gd25q32>:
  a2c4fa:	8068                	push	{ra,s0-s4},-32
  a2c4fc:	4481                	li	s1,0
  a2c4fe:	498d                	li	s3,3
  a2c500:	4515                	li	a0,5
  a2c502:	f77ff0ef          	jal	ra,a2c478 <sfc_port_gd25q32_read_sr>
  a2c506:	8a2a                	mv	s4,a0
  a2c508:	03500513          	li	a0,53
  a2c50c:	f6dff0ef          	jal	ra,a2c478 <sfc_port_gd25q32_read_sr>
  a2c510:	892a                	mv	s2,a0
  a2c512:	4555                	li	a0,21
  a2c514:	f65ff0ef          	jal	ra,a2c478 <sfc_port_gd25q32_read_sr>
  a2c518:	842a                	mv	s0,a0
  a2c51a:	040a1763          	bnez	s4,a2c568 <sfc_port_fix_sr_gd25q32+0x6e>
  a2c51e:	02090863          	beqz	s2,a2c54e <sfc_port_fix_sr_gd25q32+0x54>
  a2c522:	4609                	li	a2,2
  a2c524:	03100593          	li	a1,49
  a2c528:	4501                	li	a0,0
  a2c52a:	e37ff0ef          	jal	ra,a2c360 <sfc_port_write_sr>
  a2c52e:	c419                	beqz	s0,a2c53c <sfc_port_fix_sr_gd25q32+0x42>
  a2c530:	02000613          	li	a2,32
  a2c534:	45c5                	li	a1,17
  a2c536:	4501                	li	a0,0
  a2c538:	e29ff0ef          	jal	ra,a2c360 <sfc_port_write_sr>
  a2c53c:	03c00513          	li	a0,60
  a2c540:	0485                	addi	s1,s1,1
  a2c542:	e1bfd0ef          	jal	ra,a2a35c <uapi_tcxo_delay_ms>
  a2c546:	fb349de3          	bne	s1,s3,a2c500 <sfc_port_fix_sr_gd25q32+0x6>
  a2c54a:	547d                	li	s0,-1
  a2c54c:	a801                	j	a2c55c <sfc_port_fix_sr_gd25q32+0x62>
  a2c54e:	f16d                	bnez	a0,a2c530 <sfc_port_fix_sr_gd25q32+0x36>
  a2c550:	e881                	bnez	s1,a2c560 <sfc_port_fix_sr_gd25q32+0x66>
  a2c552:	00a3 2858 051f      	l.li	a0,0xa32858
  a2c558:	6fa000ef          	jal	ra,a2cc52 <boot_msg0>
  a2c55c:	8522                	mv	a0,s0
  a2c55e:	8064                	popret	{ra,s0-s4},32
  a2c560:	00a3 2870 051f      	l.li	a0,0xa32870
  a2c566:	bfcd                	j	a2c558 <sfc_port_fix_sr_gd25q32+0x5e>
  a2c568:	4671                	li	a2,28
  a2c56a:	4585                	li	a1,1
  a2c56c:	4501                	li	a0,0
  a2c56e:	df3ff0ef          	jal	ra,a2c360 <sfc_port_write_sr>
  a2c572:	fa090ee3          	beqz	s2,a2c52e <sfc_port_fix_sr_gd25q32+0x34>
  a2c576:	b775                	j	a2c522 <sfc_port_fix_sr_gd25q32+0x28>

00a2c578 <build_flash_ctrl>:
  a2c578:	455c                	lw	a5,12(a0)
  a2c57a:	04b7859b          	addshf	a1,a5,a1,sll,2
  a2c57e:	4194                	lw	a3,0(a1)
  a2c580:	491c                	lw	a5,16(a0)
  a2c582:	04c7861b          	addshf	a2,a5,a2,sll,2
  a2c586:	0076f793          	andi	a5,a3,7
  a2c58a:	4218                	lw	a4,0(a2)
  a2c58c:	01079bbb          	bnei	a5,1,a2c5ba <build_flash_ctrl+0x42>
  a2c590:	8b1d                	andi	a4,a4,7
  a2c592:	02f71463          	bne	a4,a5,a2c5ba <build_flash_ctrl+0x42>
  a2c596:	00a0 5824 079f      	l.li	a5,0xa05824
  a2c59c:	c3d4                	sw	a3,4(a5)
  a2c59e:	4214                	lw	a3,0(a2)
  a2c5a0:	c7d4                	sw	a3,12(a5)
  a2c5a2:	4954                	lw	a3,20(a0)
  a2c5a4:	cb94                	sw	a3,16(a5)
  a2c5a6:	4154                	lw	a3,4(a0)
  a2c5a8:	c394                	sw	a3,0(a5)
  a2c5aa:	4514                	lw	a3,8(a0)
  a2c5ac:	00d77b63          	bgeu	a4,a3,a2c5c2 <build_flash_ctrl+0x4a>
  a2c5b0:	4d18                	lw	a4,24(a0)
  a2c5b2:	c794                	sw	a3,8(a5)
  a2c5b4:	4501                	li	a0,0
  a2c5b6:	cbd8                	sw	a4,20(a5)
  a2c5b8:	8082                	ret
  a2c5ba:	8000 1346 051f      	l.li	a0,0x80001346
  a2c5c0:	8082                	ret
  a2c5c2:	8000 1349 051f      	l.li	a0,0x80001349
  a2c5c8:	8082                	ret

00a2c5ca <check_opt_param>:
  a2c5ca:	00a0 583c 079f      	l.li	a5,0xa0583c
  a2c5d0:	239c                	lbu	a5,0(a5)
  a2c5d2:	cf99                	beqz	a5,a2c5f0 <check_opt_param+0x26>
  a2c5d4:	00a0 5824 071f      	l.li	a4,0xa05824
  a2c5da:	4318                	lw	a4,0(a4)
  a2c5dc:	00b507b3          	add	a5,a0,a1
  a2c5e0:	00f76c63          	bltu	a4,a5,a2c5f8 <check_opt_param+0x2e>
  a2c5e4:	00f57a63          	bgeu	a0,a5,a2c5f8 <check_opt_param+0x2e>
  a2c5e8:	00b7e863          	bltu	a5,a1,a2c5f8 <check_opt_param+0x2e>
  a2c5ec:	4501                	li	a0,0
  a2c5ee:	8082                	ret
  a2c5f0:	8000 1340 051f      	l.li	a0,0x80001340
  a2c5f6:	8082                	ret
  a2c5f8:	80000537          	lui	a0,0x80000
  a2c5fc:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2c5fe:	8082                	ret

00a2c600 <check_init_param>:
  a2c600:	8078                	push	{ra,s0-s5},-32
  a2c602:	00452a83          	lw	s5,4(a0)
  a2c606:	00a06937          	lui	s2,0xa06
  a2c60a:	89aa                	mv	s3,a0
  a2c60c:	82492403          	lw	s0,-2012(s2) # a05824 <g_flash_ctrl>
  a2c610:	00852a03          	lw	s4,8(a0)
  a2c614:	c9fff0ef          	jal	ra,a2c2b2 <sfc_port_get_sfc_start_addr>
  a2c618:	00aaf663          	bgeu	s5,a0,a2c624 <check_init_param+0x24>
  a2c61c:	8000 1342 051f      	l.li	a0,0x80001342
  a2c622:	8074                	popret	{ra,s0-s5},32
  a2c624:	82490913          	addi	s2,s2,-2012
  a2c628:	008a7363          	bgeu	s4,s0,a2c62e <check_init_param+0x2e>
  a2c62c:	8452                	mv	s0,s4
  a2c62e:	0049a483          	lw	s1,4(s3)
  a2c632:	14fd                	addi	s1,s1,-1
  a2c634:	94a2                	add	s1,s1,s0
  a2c636:	c83ff0ef          	jal	ra,a2c2b8 <sfc_port_get_sfc_end_addr>
  a2c63a:	fe9561e3          	bltu	a0,s1,a2c61c <check_init_param+0x1c>
  a2c63e:	00892023          	sw	s0,0(s2)
  a2c642:	4501                	li	a0,0
  a2c644:	bff9                	j	a2c622 <check_init_param+0x22>

00a2c646 <uapi_sfc_init>:
  a2c646:	00a067b7          	lui	a5,0xa06
  a2c64a:	83c7c703          	lbu	a4,-1988(a5) # a0583c <g_sfc_inited>
  a2c64e:	ef59                	bnez	a4,a2c6ec <uapi_sfc_init+0xa6>
  a2c650:	8258                	push	{ra,s0-s3},-64
  a2c652:	842a                	mv	s0,a0
  a2c654:	83c78913          	addi	s2,a5,-1988
  a2c658:	ca5ff0ef          	jal	ra,a2c2fc <sfc_port_lock_init>
  a2c65c:	0868                	addi	a0,sp,28
  a2c65e:	fa4ff0ef          	jal	ra,a2be02 <hal_sfc_get_flash_id>
  a2c662:	e151                	bnez	a0,a2c6e6 <uapi_sfc_init+0xa0>
  a2c664:	200c                	lbu	a1,0(s0)
  a2c666:	3010                	lbu	a2,1(s0)
  a2c668:	49f2                	lw	s3,28(sp)
  a2c66a:	c62e                	sw	a1,12(sp)
  a2c66c:	c432                	sw	a2,8(sp)
  a2c66e:	c31ff0ef          	jal	ra,a2c29e <sfc_port_get_flash_spi_infos>
  a2c672:	84aa                	mv	s1,a0
  a2c674:	c33ff0ef          	jal	ra,a2c2a6 <sfc_port_get_flash_num>
  a2c678:	4622                	lw	a2,8(sp)
  a2c67a:	45b2                	lw	a1,12(sp)
  a2c67c:	86aa                	mv	a3,a0
  a2c67e:	87a6                	mv	a5,s1
  a2c680:	4701                	li	a4,0
  a2c682:	04e69963          	bne	a3,a4,a2c6d4 <uapi_sfc_init+0x8e>
  a2c686:	c25ff0ef          	jal	ra,a2c2aa <sfc_port_get_unknown_flash_info>
  a2c68a:	4605                	li	a2,1
  a2c68c:	4581                	li	a1,0
  a2c68e:	eebff0ef          	jal	ra,a2c578 <build_flash_ctrl>
  a2c692:	e931                	bnez	a0,a2c6e6 <uapi_sfc_init+0xa0>
  a2c694:	00a0 583d 079f      	l.li	a5,0xa0583d
  a2c69a:	4705                	li	a4,1
  a2c69c:	a398                	sb	a4,0(a5)
  a2c69e:	8522                	mv	a0,s0
  a2c6a0:	f61ff0ef          	jal	ra,a2c600 <check_init_param>
  a2c6a4:	e129                	bnez	a0,a2c6e6 <uapi_sfc_init+0xa0>
  a2c6a6:	00a06537          	lui	a0,0xa06
  a2c6aa:	82452603          	lw	a2,-2012(a0) # a05824 <g_flash_ctrl>
  a2c6ae:	404c                	lw	a1,4(s0)
  a2c6b0:	82450513          	addi	a0,a0,-2012
  a2c6b4:	f92ff0ef          	jal	ra,a2be46 <hal_sfc_init>
  a2c6b8:	e51d                	bnez	a0,a2c6e6 <uapi_sfc_init+0xa0>
  a2c6ba:	4785                	li	a5,1
  a2c6bc:	00f90023          	sb	a5,0(s2)
  a2c6c0:	00a0 583d 079f      	l.li	a5,0xa0583d
  a2c6c6:	239c                	lbu	a5,0(a5)
  a2c6c8:	4501                	li	a0,0
  a2c6ca:	cf91                	beqz	a5,a2c6e6 <uapi_sfc_init+0xa0>
  a2c6cc:	8000 1341 051f      	l.li	a0,0x80001341
  a2c6d2:	a811                	j	a2c6e6 <uapi_sfc_init+0xa0>
  a2c6d4:	853e                	mv	a0,a5
  a2c6d6:	07f1                	addi	a5,a5,28
  a2c6d8:	fe47a803          	lw	a6,-28(a5)
  a2c6dc:	01099663          	bne	s3,a6,a2c6e8 <uapi_sfc_init+0xa2>
  a2c6e0:	e99ff0ef          	jal	ra,a2c578 <build_flash_ctrl>
  a2c6e4:	dd4d                	beqz	a0,a2c69e <uapi_sfc_init+0x58>
  a2c6e6:	8254                	popret	{ra,s0-s3},64
  a2c6e8:	0705                	addi	a4,a4,1 # 40000001 <_gp_+0x3f5cb7bd>
  a2c6ea:	bf61                	j	a2c682 <uapi_sfc_init+0x3c>
  a2c6ec:	4501                	li	a0,0
  a2c6ee:	8082                	ret

00a2c6f0 <uapi_sfc_reg_read>:
  a2c6f0:	8188                	push	{ra,s0-s6},-48
  a2c6f2:	8a2e                	mv	s4,a1
  a2c6f4:	85b2                	mv	a1,a2
  a2c6f6:	892a                	mv	s2,a0
  a2c6f8:	84b2                	mv	s1,a2
  a2c6fa:	ed1ff0ef          	jal	ra,a2c5ca <check_opt_param>
  a2c6fe:	e13d                	bnez	a0,a2c764 <uapi_sfc_reg_read+0x74>
  a2c700:	bffff0ef          	jal	ra,a2c2fe <sfc_port_lock>
  a2c704:	00397b13          	andi	s6,s2,3
  a2c708:	8aaa                	mv	s5,a0
  a2c70a:	060b0263          	beqz	s6,a2c76e <uapi_sfc_reg_read+0x7e>
  a2c70e:	4791                	li	a5,4
  a2c710:	416787b3          	sub	a5,a5,s6
  a2c714:	41690933          	sub	s2,s2,s6
  a2c718:	0ff4f993          	andi	s3,s1,255
  a2c71c:	00f4e763          	bltu	s1,a5,a2c72a <uapi_sfc_reg_read+0x3a>
  a2c720:	4991                	li	s3,4
  a2c722:	416989b3          	sub	s3,s3,s6
  a2c726:	0ff9f993          	andi	s3,s3,255
  a2c72a:	00a0 5824 079f      	l.li	a5,0xa05824
  a2c730:	43d4                	lw	a3,4(a5)
  a2c732:	4611                	li	a2,4
  a2c734:	006c                	addi	a1,sp,12
  a2c736:	854a                	mv	a0,s2
  a2c738:	c602                	sw	zero,12(sp)
  a2c73a:	feeff0ef          	jal	ra,a2bf28 <hal_sfc_reg_read>
  a2c73e:	842a                	mv	s0,a0
  a2c740:	ed11                	bnez	a0,a2c75c <uapi_sfc_reg_read+0x6c>
  a2c742:	007c                	addi	a5,sp,12
  a2c744:	86ce                	mv	a3,s3
  a2c746:	01678633          	add	a2,a5,s6
  a2c74a:	85ce                	mv	a1,s3
  a2c74c:	8552                	mv	a0,s4
  a2c74e:	380040ef          	jal	ra,a30ace <memcpy_s>
  a2c752:	c911                	beqz	a0,a2c766 <uapi_sfc_reg_read+0x76>
  a2c754:	80000537          	lui	a0,0x80000
  a2c758:	00450413          	addi	s0,a0,4 # 80000004 <_gp_+0x7f5cb7c0>
  a2c75c:	8556                	mv	a0,s5
  a2c75e:	ba5ff0ef          	jal	ra,a2c302 <sfc_port_unlock>
  a2c762:	8522                	mv	a0,s0
  a2c764:	8184                	popret	{ra,s0-s6},48
  a2c766:	0911                	addi	s2,s2,4
  a2c768:	9a4e                	add	s4,s4,s3
  a2c76a:	413484b3          	sub	s1,s1,s3
  a2c76e:	ffc4f993          	andi	s3,s1,-4
  a2c772:	02098163          	beqz	s3,a2c794 <uapi_sfc_reg_read+0xa4>
  a2c776:	00a0 5824 079f      	l.li	a5,0xa05824
  a2c77c:	43d4                	lw	a3,4(a5)
  a2c77e:	864e                	mv	a2,s3
  a2c780:	85d2                	mv	a1,s4
  a2c782:	854a                	mv	a0,s2
  a2c784:	fa4ff0ef          	jal	ra,a2bf28 <hal_sfc_reg_read>
  a2c788:	842a                	mv	s0,a0
  a2c78a:	f969                	bnez	a0,a2c75c <uapi_sfc_reg_read+0x6c>
  a2c78c:	9a4e                	add	s4,s4,s3
  a2c78e:	994e                	add	s2,s2,s3
  a2c790:	413484b3          	sub	s1,s1,s3
  a2c794:	4401                	li	s0,0
  a2c796:	d0f9                	beqz	s1,a2c75c <uapi_sfc_reg_read+0x6c>
  a2c798:	00a0 5824 079f      	l.li	a5,0xa05824
  a2c79e:	43d4                	lw	a3,4(a5)
  a2c7a0:	4611                	li	a2,4
  a2c7a2:	006c                	addi	a1,sp,12
  a2c7a4:	854a                	mv	a0,s2
  a2c7a6:	c602                	sw	zero,12(sp)
  a2c7a8:	f80ff0ef          	jal	ra,a2bf28 <hal_sfc_reg_read>
  a2c7ac:	842a                	mv	s0,a0
  a2c7ae:	86a6                	mv	a3,s1
  a2c7b0:	0070                	addi	a2,sp,12
  a2c7b2:	85a6                	mv	a1,s1
  a2c7b4:	8552                	mv	a0,s4
  a2c7b6:	318040ef          	jal	ra,a30ace <memcpy_s>
  a2c7ba:	d14d                	beqz	a0,a2c75c <uapi_sfc_reg_read+0x6c>
  a2c7bc:	80000437          	lui	s0,0x80000
  a2c7c0:	0411                	addi	s0,s0,4 # 80000004 <_gp_+0x7f5cb7c0>
  a2c7c2:	bf69                	j	a2c75c <uapi_sfc_reg_read+0x6c>

00a2c7c4 <uapi_sfc_reg_write>:
  a2c7c4:	8198                	push	{ra,s0-s7},-64
  a2c7c6:	8a2e                	mv	s4,a1
  a2c7c8:	85b2                	mv	a1,a2
  a2c7ca:	84aa                	mv	s1,a0
  a2c7cc:	8932                	mv	s2,a2
  a2c7ce:	dfdff0ef          	jal	ra,a2c5ca <check_opt_param>
  a2c7d2:	842a                	mv	s0,a0
  a2c7d4:	e571                	bnez	a0,a2c8a0 <uapi_sfc_reg_write+0xdc>
  a2c7d6:	012485b3          	add	a1,s1,s2
  a2c7da:	8526                	mv	a0,s1
  a2c7dc:	c2dff0ef          	jal	ra,a2c408 <sfc_port_write_lock>
  a2c7e0:	0034fa93          	andi	s5,s1,3
  a2c7e4:	8b2a                	mv	s6,a0
  a2c7e6:	060a8863          	beqz	s5,a2c856 <uapi_sfc_reg_write+0x92>
  a2c7ea:	4791                	li	a5,4
  a2c7ec:	415787b3          	sub	a5,a5,s5
  a2c7f0:	415484b3          	sub	s1,s1,s5
  a2c7f4:	0ff97993          	andi	s3,s2,255
  a2c7f8:	00f96763          	bltu	s2,a5,a2c806 <uapi_sfc_reg_write+0x42>
  a2c7fc:	4991                	li	s3,4
  a2c7fe:	415989b3          	sub	s3,s3,s5
  a2c802:	0ff9f993          	andi	s3,s3,255
  a2c806:	00a0 5824 0b9f      	l.li	s7,0xa05824
  a2c80c:	004ba683          	lw	a3,4(s7)
  a2c810:	4611                	li	a2,4
  a2c812:	006c                	addi	a1,sp,12
  a2c814:	8526                	mv	a0,s1
  a2c816:	f12ff0ef          	jal	ra,a2bf28 <hal_sfc_reg_read>
  a2c81a:	842a                	mv	s0,a0
  a2c81c:	ed09                	bnez	a0,a2c836 <uapi_sfc_reg_write+0x72>
  a2c81e:	007c                	addi	a5,sp,12
  a2c820:	86ce                	mv	a3,s3
  a2c822:	8652                	mv	a2,s4
  a2c824:	85ce                	mv	a1,s3
  a2c826:	01578533          	add	a0,a5,s5
  a2c82a:	2a4040ef          	jal	ra,a30ace <memcpy_s>
  a2c82e:	c901                	beqz	a0,a2c83e <uapi_sfc_reg_write+0x7a>
  a2c830:	80000437          	lui	s0,0x80000
  a2c834:	0411                	addi	s0,s0,4 # 80000004 <_gp_+0x7f5cb7c0>
  a2c836:	855a                	mv	a0,s6
  a2c838:	c03ff0ef          	jal	ra,a2c43a <sfc_port_write_unlock>
  a2c83c:	a095                	j	a2c8a0 <uapi_sfc_reg_write+0xdc>
  a2c83e:	00cba683          	lw	a3,12(s7)
  a2c842:	8526                	mv	a0,s1
  a2c844:	4611                	li	a2,4
  a2c846:	006c                	addi	a1,sp,12
  a2c848:	f6cff0ef          	jal	ra,a2bfb4 <hal_sfc_reg_write>
  a2c84c:	842a                	mv	s0,a0
  a2c84e:	0491                	addi	s1,s1,4
  a2c850:	9a4e                	add	s4,s4,s3
  a2c852:	41390933          	sub	s2,s2,s3
  a2c856:	ffc97993          	andi	s3,s2,-4
  a2c85a:	fc71                	bnez	s0,a2c836 <uapi_sfc_reg_write+0x72>
  a2c85c:	02098063          	beqz	s3,a2c87c <uapi_sfc_reg_write+0xb8>
  a2c860:	00a0 5824 079f      	l.li	a5,0xa05824
  a2c866:	47d4                	lw	a3,12(a5)
  a2c868:	85d2                	mv	a1,s4
  a2c86a:	8526                	mv	a0,s1
  a2c86c:	864e                	mv	a2,s3
  a2c86e:	f46ff0ef          	jal	ra,a2bfb4 <hal_sfc_reg_write>
  a2c872:	9a4e                	add	s4,s4,s3
  a2c874:	94ce                	add	s1,s1,s3
  a2c876:	41390933          	sub	s2,s2,s3
  a2c87a:	e131                	bnez	a0,a2c8be <uapi_sfc_reg_write+0xfa>
  a2c87c:	fa090de3          	beqz	s2,a2c836 <uapi_sfc_reg_write+0x72>
  a2c880:	00a0 5824 041f      	l.li	s0,0xa05824
  a2c886:	4054                	lw	a3,4(s0)
  a2c888:	4611                	li	a2,4
  a2c88a:	006c                	addi	a1,sp,12
  a2c88c:	8526                	mv	a0,s1
  a2c88e:	e9aff0ef          	jal	ra,a2bf28 <hal_sfc_reg_read>
  a2c892:	c909                	beqz	a0,a2c8a4 <uapi_sfc_reg_write+0xe0>
  a2c894:	855a                	mv	a0,s6
  a2c896:	80000437          	lui	s0,0x80000
  a2c89a:	ba1ff0ef          	jal	ra,a2c43a <sfc_port_write_unlock>
  a2c89e:	0411                	addi	s0,s0,4 # 80000004 <_gp_+0x7f5cb7c0>
  a2c8a0:	8522                	mv	a0,s0
  a2c8a2:	8194                	popret	{ra,s0-s7},64
  a2c8a4:	86ca                	mv	a3,s2
  a2c8a6:	8652                	mv	a2,s4
  a2c8a8:	4591                	li	a1,4
  a2c8aa:	0068                	addi	a0,sp,12
  a2c8ac:	222040ef          	jal	ra,a30ace <memcpy_s>
  a2c8b0:	f175                	bnez	a0,a2c894 <uapi_sfc_reg_write+0xd0>
  a2c8b2:	4454                	lw	a3,12(s0)
  a2c8b4:	4611                	li	a2,4
  a2c8b6:	006c                	addi	a1,sp,12
  a2c8b8:	8526                	mv	a0,s1
  a2c8ba:	efaff0ef          	jal	ra,a2bfb4 <hal_sfc_reg_write>
  a2c8be:	842a                	mv	s0,a0
  a2c8c0:	bf9d                	j	a2c836 <uapi_sfc_reg_write+0x72>

00a2c8c2 <uapi_sfc_reg_erase>:
  a2c8c2:	80a8                	push	{ra,s0-s8},-48
  a2c8c4:	892a                	mv	s2,a0
  a2c8c6:	842e                	mv	s0,a1
  a2c8c8:	d03ff0ef          	jal	ra,a2c5ca <check_opt_param>
  a2c8cc:	e921                	bnez	a0,a2c91c <uapi_sfc_reg_erase+0x5a>
  a2c8ce:	008905b3          	add	a1,s2,s0
  a2c8d2:	77fd                	lui	a5,0xfffff
  a2c8d4:	01459713          	slli	a4,a1,0x14
  a2c8d8:	00f974b3          	and	s1,s2,a5
  a2c8dc:	cf41                	beqz	a4,a2c974 <uapi_sfc_reg_erase+0xb2>
  a2c8de:	8fed                	and	a5,a5,a1
  a2c8e0:	6705                	lui	a4,0x1
  a2c8e2:	80000537          	lui	a0,0x80000
  a2c8e6:	97ba                	add	a5,a5,a4
  a2c8e8:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2c8ea:	02991963          	bne	s2,s1,a2c91c <uapi_sfc_reg_erase+0x5a>
  a2c8ee:	02f59763          	bne	a1,a5,a2c91c <uapi_sfc_reg_erase+0x5a>
  a2c8f2:	8526                	mv	a0,s1
  a2c8f4:	40958a33          	sub	s4,a1,s1
  a2c8f8:	6b11                	lui	s6,0x4
  a2c8fa:	b0fff0ef          	jal	ra,a2c408 <sfc_port_write_lock>
  a2c8fe:	8c2a                	mv	s8,a0
  a2c900:	4901                	li	s2,0
  a2c902:	4981                	li	s3,0
  a2c904:	4a81                	li	s5,0
  a2c906:	00a0 5824 0b9f      	l.li	s7,0xa05824
  a2c90c:	1b7d                	addi	s6,s6,-1 # 3fff <ccause+0x303d>
  a2c90e:	040a1d63          	bnez	s4,a2c968 <uapi_sfc_reg_erase+0xa6>
  a2c912:	4401                	li	s0,0
  a2c914:	8562                	mv	a0,s8
  a2c916:	b25ff0ef          	jal	ra,a2c43a <sfc_port_write_unlock>
  a2c91a:	8522                	mv	a0,s0
  a2c91c:	80a4                	popret	{ra,s0-s8},48
  a2c91e:	010ba703          	lw	a4,16(s7)
  a2c922:	04f7071b          	addshf	a4,a4,a5,sll,2
  a2c926:	00072903          	lw	s2,0(a4) # 1000 <ccause+0x3e>
  a2c92a:	00e95993          	srli	s3,s2,0xe
  a2c92e:	8ace                	mv	s5,s3
  a2c930:	013a6663          	bltu	s4,s3,a2c93c <uapi_sfc_reg_erase+0x7a>
  a2c934:	fff98713          	addi	a4,s3,-1
  a2c938:	8f65                	and	a4,a4,s1
  a2c93a:	cb01                	beqz	a4,a2c94a <uapi_sfc_reg_erase+0x88>
  a2c93c:	0785                	addi	a5,a5,1 # fffff001 <_gp_+0xff5ca7bd>
  a2c93e:	008ba703          	lw	a4,8(s7)
  a2c942:	fce7eee3          	bltu	a5,a4,a2c91e <uapi_sfc_reg_erase+0x5c>
  a2c946:	02e78363          	beq	a5,a4,a2c96c <uapi_sfc_reg_erase+0xaa>
  a2c94a:	01697933          	and	s2,s2,s6
  a2c94e:	1d39291b          	orshf	s2,s2,s3,sll,14
  a2c952:	4601                	li	a2,0
  a2c954:	85ca                	mv	a1,s2
  a2c956:	8526                	mv	a0,s1
  a2c958:	ebcff0ef          	jal	ra,a2c014 <hal_sfc_reg_erase>
  a2c95c:	842a                	mv	s0,a0
  a2c95e:	f95d                	bnez	a0,a2c914 <uapi_sfc_reg_erase+0x52>
  a2c960:	415a0a33          	sub	s4,s4,s5
  a2c964:	94d6                	add	s1,s1,s5
  a2c966:	b765                	j	a2c90e <uapi_sfc_reg_erase+0x4c>
  a2c968:	4785                	li	a5,1
  a2c96a:	bfd1                	j	a2c93e <uapi_sfc_reg_erase+0x7c>
  a2c96c:	8000 1347 041f      	l.li	s0,0x80001347
  a2c972:	b74d                	j	a2c914 <uapi_sfc_reg_erase+0x52>
  a2c974:	f6990fe3          	beq	s2,s1,a2c8f2 <uapi_sfc_reg_erase+0x30>
  a2c978:	80000537          	lui	a0,0x80000
  a2c97c:	0505                	addi	a0,a0,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2c97e:	bf79                	j	a2c91c <uapi_sfc_reg_erase+0x5a>

00a2c980 <efuse_read_item.part.1>:
  a2c980:	8188                	push	{ra,s0-s6},-48
  a2c982:	00a3 28a8 079f      	l.li	a5,0xa328a8
  a2c988:	06a7955b          	muliadd	a0,a5,a0,6
  a2c98c:	2126                	lhu	s1,2(a0)
  a2c98e:	00748a13          	addi	s4,s1,7
  a2c992:	003a5a13          	srli	s4,s4,0x3
  a2c996:	07466f63          	bltu	a2,s4,a2ca14 <efuse_read_item.part.1+0x94>
  a2c99a:	00055903          	lhu	s2,0(a0)
  a2c99e:	86b2                	mv	a3,a2
  a2c9a0:	89ae                	mv	s3,a1
  a2c9a2:	4601                	li	a2,0
  a2c9a4:	85b6                	mv	a1,a3
  a2c9a6:	854e                	mv	a0,s3
  a2c9a8:	1a2040ef          	jal	ra,a30b4a <memset_s>
  a2c9ac:	009967b3          	or	a5,s2,s1
  a2c9b0:	8b9d                	andi	a5,a5,7
  a2c9b2:	844a                	mv	s0,s2
  a2c9b4:	cb91                	beqz	a5,a2c9c8 <efuse_read_item.part.1+0x48>
  a2c9b6:	6a41                	lui	s4,0x10
  a2c9b8:	94ca                	add	s1,s1,s2
  a2c9ba:	4aa1                	li	s5,8
  a2c9bc:	1a7d                	addi	s4,s4,-1 # ffff <ccause+0xf03d>
  a2c9be:	4b05                	li	s6,1
  a2c9c0:	00944b63          	blt	s0,s1,a2c9d6 <efuse_read_item.part.1+0x56>
  a2c9c4:	4501                	li	a0,0
  a2c9c6:	a039                	j	a2c9d4 <efuse_read_item.part.1+0x54>
  a2c9c8:	8652                	mv	a2,s4
  a2c9ca:	00395593          	srli	a1,s2,0x3
  a2c9ce:	854e                	mv	a0,s3
  a2c9d0:	fdbfd0ef          	jal	ra,a2a9aa <uapi_efuse_read_buffer>
  a2c9d4:	8184                	popret	{ra,s0-s6},48
  a2c9d6:	00747613          	andi	a2,s0,7
  a2c9da:	00345593          	srli	a1,s0,0x3
  a2c9de:	00f10513          	addi	a0,sp,15
  a2c9e2:	f73fd0ef          	jal	ra,a2a954 <uapi_efuse_read_bit>
  a2c9e6:	f57d                	bnez	a0,a2c9d4 <efuse_read_item.part.1+0x54>
  a2c9e8:	00f14783          	lbu	a5,15(sp)
  a2c9ec:	c38d                	beqz	a5,a2ca0e <efuse_read_item.part.1+0x8e>
  a2c9ee:	412407b3          	sub	a5,s0,s2
  a2c9f2:	0357c733          	div	a4,a5,s5
  a2c9f6:	0357e7b3          	rem	a5,a5,s5
  a2c9fa:	01477733          	and	a4,a4,s4
  a2c9fe:	974e                	add	a4,a4,s3
  a2ca00:	2314                	lbu	a3,0(a4)
  a2ca02:	0147f7b3          	and	a5,a5,s4
  a2ca06:	00fb17b3          	sll	a5,s6,a5
  a2ca0a:	8fd5                	or	a5,a5,a3
  a2ca0c:	a31c                	sb	a5,0(a4)
  a2ca0e:	0405                	addi	s0,s0,1
  a2ca10:	9c21                	uxth	s0
  a2ca12:	b77d                	j	a2c9c0 <efuse_read_item.part.1+0x40>
  a2ca14:	557d                	li	a0,-1
  a2ca16:	bf7d                	j	a2c9d4 <efuse_read_item.part.1+0x54>

00a2ca18 <efuse_port_register_hal_funcs>:
  a2ca18:	8018                	push	{ra},-16
  a2ca1a:	9dcfe0ef          	jal	ra,a2abf6 <hal_efuse_funcs_get>
  a2ca1e:	8010                	pop	{ra},16
  a2ca20:	fe5fd06f          	j	a2aa04 <hal_efuse_register_funcs>

00a2ca24 <hal_efuse_get_region>:
  a2ca24:	8121                	srli	a0,a0,0x8
  a2ca26:	9d01                	uxtb	a0
  a2ca28:	8082                	ret

00a2ca2a <hal_efuse_get_byte_offset>:
  a2ca2a:	9d01                	uxtb	a0
  a2ca2c:	8082                	ret

00a2ca2e <efuse_read_item>:
  a2ca2e:	c589                	beqz	a1,a2ca38 <efuse_read_item+0xa>
  a2ca30:	1305723b          	bgeui	a0,19,a2ca38 <efuse_read_item+0xa>
  a2ca34:	f4dff06f          	j	a2c980 <efuse_read_item.part.1>
  a2ca38:	557d                	li	a0,-1
  a2ca3a:	8082                	ret

00a2ca3c <set_efuse_period>:
  a2ca3c:	8018                	push	{ra},-16
  a2ca3e:	2895                	jal	ra,a2cab2 <get_tcxo_freq>
  a2ca40:	010513bb          	bnei	a0,1,a2ca4e <set_efuse_period+0x12>
  a2ca44:	02900513          	li	a0,41
  a2ca48:	8010                	pop	{ra},16
  a2ca4a:	9a2fe06f          	j	a2abec <hal_efuse_set_clock_period>
  a2ca4e:	4565                	li	a0,25
  a2ca50:	bfe5                	j	a2ca48 <set_efuse_period+0xc>

00a2ca52 <malloc_port>:
  a2ca52:	f63fc06f          	j	a299b4 <malloc>

00a2ca56 <malloc_port_init>:
  a2ca56:	8118                	push	{ra},-32
  a2ca58:	00a2 98da 079f      	l.li	a5,0xa298da
  a2ca5e:	c23e                	sw	a5,4(sp)
  a2ca60:	00a2 99ea 079f      	l.li	a5,0xa299ea
  a2ca66:	c63e                	sw	a5,12(sp)
  a2ca68:	0048                	addi	a0,sp,4
  a2ca6a:	00a2 ca52 079f      	l.li	a5,0xa2ca52
  a2ca70:	c43e                	sw	a5,8(sp)
  a2ca72:	e15fc0ef          	jal	ra,a29886 <malloc_register_funcs>
  a2ca76:	00a06537          	lui	a0,0xa06
  a2ca7a:	0001 0000 079f      	l.li	a5,0x10000
  a2ca80:	b0850593          	addi	a1,a0,-1272 # a05b08 <__bss_end__>
  a2ca84:	95be                	add	a1,a1,a5
  a2ca86:	b0850513          	addi	a0,a0,-1272
  a2ca8a:	e51fc0ef          	jal	ra,a298da <malloc_init>
  a2ca8e:	8114                	popret	{ra},32

00a2ca90 <reboot_port_reboot_chip>:
  a2ca90:	8018                	push	{ra},-16
  a2ca92:	e4dfd0ef          	jal	ra,a2a8de <uapi_watchdog_deinit>
  a2ca96:	0000 0bb8 051f      	l.li	a0,0xbb8
  a2ca9c:	911fd0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2caa0:	40002737          	lui	a4,0x40002
  a2caa4:	11072783          	lw	a5,272(a4) # 40002110 <_gp_+0x3f5cd8cc>
  a2caa8:	0047e793          	ori	a5,a5,4
  a2caac:	10f72823          	sw	a5,272(a4)
  a2cab0:	8014                	popret	{ra},16

00a2cab2 <get_tcxo_freq>:
  a2cab2:	400007b7          	lui	a5,0x40000
  a2cab6:	4bc8                	lw	a0,20(a5)
  a2cab8:	8905                	andi	a0,a0,1
  a2caba:	8082                	ret

00a2cabc <boot_clock_adapt>:
  a2cabc:	8028                	push	{ra,s0},-16
  a2cabe:	ff5ff0ef          	jal	ra,a2cab2 <get_tcxo_freq>
  a2cac2:	010518bb          	bnei	a0,1,a2cae4 <boot_clock_adapt+0x28>
  a2cac6:	016e3437          	lui	s0,0x16e3
  a2caca:	60040593          	addi	a1,s0,1536 # 16e3600 <_gp_+0xcaedbc>
  a2cace:	4501                	li	a0,0
  a2cad0:	ef8ff0ef          	jal	ra,a2c1c8 <uart_port_set_clock_value>
  a2cad4:	4561                	li	a0,24
  a2cad6:	f80ff0ef          	jal	ra,a2c256 <tcxo_porting_ticks_per_usec_set>
  a2cada:	60040513          	addi	a0,s0,1536
  a2cade:	8020                	pop	{ra,s0},16
  a2cae0:	f92ff06f          	j	a2c272 <watchdog_port_set_clock>
  a2cae4:	02626437          	lui	s0,0x2626
  a2cae8:	a0040593          	addi	a1,s0,-1536 # 2625a00 <_gp_+0x1bf11bc>
  a2caec:	4501                	li	a0,0
  a2caee:	edaff0ef          	jal	ra,a2c1c8 <uart_port_set_clock_value>
  a2caf2:	02800513          	li	a0,40
  a2caf6:	f60ff0ef          	jal	ra,a2c256 <tcxo_porting_ticks_per_usec_set>
  a2cafa:	a0040513          	addi	a0,s0,-1536
  a2cafe:	b7c5                	j	a2cade <boot_clock_adapt+0x22>

00a2cb00 <switch_flash_clock_to_pll>:
  a2cb00:	8028                	push	{ra,s0},-16
  a2cb02:	40003437          	lui	s0,0x40003
  a2cb06:	4785                	li	a5,1
  a2cb08:	4af42223          	sw	a5,1188(s0) # 400034a4 <_gp_+0x3f5cec60>
  a2cb0c:	4505                	li	a0,1
  a2cb0e:	89ffd0ef          	jal	ra,a2a3ac <uapi_tcxo_delay_us>
  a2cb12:	478d                	li	a5,3
  a2cb14:	4af42223          	sw	a5,1188(s0)
  a2cb18:	44001737          	lui	a4,0x44001
  a2cb1c:	13472783          	lw	a5,308(a4) # 44001134 <_gp_+0x435cc8f0>
  a2cb20:	000406b7          	lui	a3,0x40
  a2cb24:	8fd5                	or	a5,a5,a3
  a2cb26:	12f72a23          	sw	a5,308(a4)
  a2cb2a:	8024                	popret	{ra,s0},16

00a2cb2c <config_sfc_ctrl_ds>:
  a2cb2c:	4400e7b7          	lui	a5,0x4400e
  a2cb30:	8687a703          	lw	a4,-1944(a5) # 4400d868 <_gp_+0x435d9024>
  a2cb34:	f8f77713          	andi	a4,a4,-113
  a2cb38:	03076713          	ori	a4,a4,48
  a2cb3c:	86e7a423          	sw	a4,-1944(a5)
  a2cb40:	86c7a703          	lw	a4,-1940(a5)
  a2cb44:	f8f77713          	andi	a4,a4,-113
  a2cb48:	02076713          	ori	a4,a4,32
  a2cb4c:	86e7a623          	sw	a4,-1940(a5)
  a2cb50:	8707a703          	lw	a4,-1936(a5)
  a2cb54:	f8f77713          	andi	a4,a4,-113
  a2cb58:	02076713          	ori	a4,a4,32
  a2cb5c:	86e7a823          	sw	a4,-1936(a5)
  a2cb60:	8747a703          	lw	a4,-1932(a5)
  a2cb64:	f8f77713          	andi	a4,a4,-113
  a2cb68:	02076713          	ori	a4,a4,32
  a2cb6c:	86e7aa23          	sw	a4,-1932(a5)
  a2cb70:	8787a703          	lw	a4,-1928(a5)
  a2cb74:	f8f77713          	andi	a4,a4,-113
  a2cb78:	02076713          	ori	a4,a4,32
  a2cb7c:	86e7ac23          	sw	a4,-1928(a5)
  a2cb80:	87c7a703          	lw	a4,-1924(a5)
  a2cb84:	f8f77713          	andi	a4,a4,-113
  a2cb88:	02076713          	ori	a4,a4,32
  a2cb8c:	86e7ae23          	sw	a4,-1924(a5)
  a2cb90:	8082                	ret

00a2cb92 <serial_set_mute>:
  a2cb92:	00a0 583f 079f      	l.li	a5,0xa0583f
  a2cb98:	4705                	li	a4,1
  a2cb9a:	a398                	sb	a4,0(a5)
  a2cb9c:	8082                	ret

00a2cb9e <serial_cancel_mute>:
  a2cb9e:	00a0 583f 079f      	l.li	a5,0xa0583f
  a2cba4:	00078023          	sb	zero,0(a5)
  a2cba8:	8082                	ret

00a2cbaa <serial_putc>:
  a2cbaa:	8118                	push	{ra},-32
  a2cbac:	00a0 583f 079f      	l.li	a5,0xa0583f
  a2cbb2:	239c                	lbu	a5,0(a5)
  a2cbb4:	00a107a3          	sb	a0,15(sp)
  a2cbb8:	eb81                	bnez	a5,a2cbc8 <serial_putc+0x1e>
  a2cbba:	4689                	li	a3,2
  a2cbbc:	4605                	li	a2,1
  a2cbbe:	00f10593          	addi	a1,sp,15
  a2cbc2:	4501                	li	a0,0
  a2cbc4:	bf7fd0ef          	jal	ra,a2a7ba <uapi_uart_write>
  a2cbc8:	8114                	popret	{ra},32

00a2cbca <serial_puts>:
  a2cbca:	00a0 583f 079f      	l.li	a5,0xa0583f
  a2cbd0:	239c                	lbu	a5,0(a5)
  a2cbd2:	ef89                	bnez	a5,a2cbec <serial_puts+0x22>
  a2cbd4:	8118                	push	{ra},-32
  a2cbd6:	c62a                	sw	a0,12(sp)
  a2cbd8:	934fc0ef          	jal	ra,a28d0c <strlen>
  a2cbdc:	45b2                	lw	a1,12(sp)
  a2cbde:	862a                	mv	a2,a0
  a2cbe0:	7d000693          	li	a3,2000
  a2cbe4:	4501                	li	a0,0
  a2cbe6:	8110                	pop	{ra},32
  a2cbe8:	bd3fd06f          	j	a2a7ba <uapi_uart_write>
  a2cbec:	8082                	ret

00a2cbee <serial_puthex>:
  a2cbee:	00a0 583f 079f      	l.li	a5,0xa0583f
  a2cbf4:	239c                	lbu	a5,0(a5)
  a2cbf6:	efa9                	bnez	a5,a2cc50 <serial_puthex+0x62>
  a2cbf8:	8098                	push	{ra,s0-s7},-48
  a2cbfa:	84aa                	mv	s1,a0
  a2cbfc:	00a3 2920 051f      	l.li	a0,0xa32920
  a2cc02:	8a2e                	mv	s4,a1
  a2cc04:	4401                	li	s0,0
  a2cc06:	fc5ff0ef          	jal	ra,a2cbca <serial_puts>
  a2cc0a:	4901                	li	s2,0
  a2cc0c:	4aa5                	li	s5,9
  a2cc0e:	4b1d                	li	s6,7
  a2cc10:	03000b93          	li	s7,48
  a2cc14:	49a1                	li	s3,8
  a2cc16:	01c4d713          	srli	a4,s1,0x1c
  a2cc1a:	0ff77793          	andi	a5,a4,255
  a2cc1e:	03078513          	addi	a0,a5,48
  a2cc22:	00eaf463          	bgeu	s5,a4,a2cc2a <serial_puthex+0x3c>
  a2cc26:	03778513          	addi	a0,a5,55
  a2cc2a:	0492                	slli	s1,s1,0x4
  a2cc2c:	000a0563          	beqz	s4,a2cc36 <serial_puthex+0x48>
  a2cc30:	f7bff0ef          	jal	ra,a2cbaa <serial_putc>
  a2cc34:	a811                	j	a2cc48 <serial_puthex+0x5a>
  a2cc36:	fe091de3          	bnez	s2,a2cc30 <serial_puthex+0x42>
  a2cc3a:	ff640be3          	beq	s0,s6,a2cc30 <serial_puthex+0x42>
  a2cc3e:	01750563          	beq	a0,s7,a2cc48 <serial_puthex+0x5a>
  a2cc42:	f69ff0ef          	jal	ra,a2cbaa <serial_putc>
  a2cc46:	4905                	li	s2,1
  a2cc48:	0405                	addi	s0,s0,1
  a2cc4a:	fd3416e3          	bne	s0,s3,a2cc16 <serial_puthex+0x28>
  a2cc4e:	8094                	popret	{ra,s0-s7},48
  a2cc50:	8082                	ret

00a2cc52 <boot_msg0>:
  a2cc52:	8018                	push	{ra},-16
  a2cc54:	f77ff0ef          	jal	ra,a2cbca <serial_puts>
  a2cc58:	00a3 3280 051f      	l.li	a0,0xa33280
  a2cc5e:	8010                	pop	{ra},16
  a2cc60:	f6bff06f          	j	a2cbca <serial_puts>

00a2cc64 <boot_msg1>:
  a2cc64:	8028                	push	{ra,s0},-16
  a2cc66:	842e                	mv	s0,a1
  a2cc68:	f63ff0ef          	jal	ra,a2cbca <serial_puts>
  a2cc6c:	8522                	mv	a0,s0
  a2cc6e:	4581                	li	a1,0
  a2cc70:	f7fff0ef          	jal	ra,a2cbee <serial_puthex>
  a2cc74:	00a3 3280 051f      	l.li	a0,0xa33280
  a2cc7a:	8020                	pop	{ra,s0},16
  a2cc7c:	f4fff06f          	j	a2cbca <serial_puts>

00a2cc80 <boot_msg2>:
  a2cc80:	8128                	push	{ra,s0},-32
  a2cc82:	842e                	mv	s0,a1
  a2cc84:	c632                	sw	a2,12(sp)
  a2cc86:	f45ff0ef          	jal	ra,a2cbca <serial_puts>
  a2cc8a:	4581                	li	a1,0
  a2cc8c:	8522                	mv	a0,s0
  a2cc8e:	f61ff0ef          	jal	ra,a2cbee <serial_puthex>
  a2cc92:	00a3 291c 051f      	l.li	a0,0xa3291c
  a2cc98:	f33ff0ef          	jal	ra,a2cbca <serial_puts>
  a2cc9c:	4632                	lw	a2,12(sp)
  a2cc9e:	4581                	li	a1,0
  a2cca0:	8532                	mv	a0,a2
  a2cca2:	f4dff0ef          	jal	ra,a2cbee <serial_puthex>
  a2cca6:	00a3 3280 051f      	l.li	a0,0xa33280
  a2ccac:	8120                	pop	{ra,s0},32
  a2ccae:	f1dff06f          	j	a2cbca <serial_puts>

00a2ccb2 <hiburn_uart_init>:
  a2ccb2:	8228                	push	{ra,s0},-48
  a2ccb4:	00a3 3fcc 079f      	l.li	a5,0xa33fcc
  a2ccba:	00078023          	sb	zero,0(a5)
  a2ccbe:	02900793          	li	a5,41
  a2ccc2:	00f10623          	sb	a5,12(sp)
  a2ccc6:	07300793          	li	a5,115
  a2ccca:	00f107a3          	sb	a5,15(sp)
  a2ccce:	00f10723          	sb	a5,14(sp)
  a2ccd2:	411c                	lw	a5,0(a0)
  a2ccd4:	02a00713          	li	a4,42
  a2ccd8:	00e106a3          	sb	a4,13(sp)
  a2ccdc:	c83e                	sw	a5,16(sp)
  a2ccde:	215c                	lbu	a5,4(a0)
  a2cce0:	2178                	lbu	a4,6(a0)
  a2cce2:	00010423          	sb	zero,8(sp)
  a2cce6:	17ed                	addi	a5,a5,-5
  a2cce8:	00f10a23          	sb	a5,20(sp)
  a2ccec:	fff70793          	addi	a5,a4,-1
  a2ccf0:	9f81                	uxtb	a5
  a2ccf2:	0207fdbb          	bgeui	a5,2,a2cd28 <hiburn_uart_init+0x76>
  a2ccf6:	00e10b23          	sb	a4,22(sp)
  a2ccfa:	315c                	lbu	a5,5(a0)
  a2ccfc:	4405                	li	s0,1
  a2ccfe:	0838                	addi	a4,sp,24
  a2cd00:	17fd                	addi	a5,a5,-1
  a2cd02:	00f10aa3          	sb	a5,21(sp)
  a2cd06:	4681                	li	a3,0
  a2cd08:	003c                	addi	a5,sp,8
  a2cd0a:	0810                	addi	a2,sp,16
  a2cd0c:	006c                	addi	a1,sp,12
  a2cd0e:	4501                	li	a0,0
  a2cd10:	cc3e                	sw	a5,24(sp)
  a2cd12:	ce22                	sw	s0,28(sp)
  a2cd14:	9d9fd0ef          	jal	ra,a2a6ec <uapi_uart_init>
  a2cd18:	4501                	li	a0,0
  a2cd1a:	cd4ff0ef          	jal	ra,a2c1ee <uart_port_unregister_irq>
  a2cd1e:	00a0 583e 079f      	l.li	a5,0xa0583e
  a2cd24:	a380                	sb	s0,0(a5)
  a2cd26:	8224                	popret	{ra,s0},48
  a2cd28:	00010b23          	sb	zero,22(sp)
  a2cd2c:	b7f9                	j	a2ccfa <hiburn_uart_init+0x48>

00a2cd2e <set_reset_count>:
  a2cd2e:	40000737          	lui	a4,0x40000
  a2cd32:	471c                	lw	a5,8(a4)
  a2cd34:	893d                	andi	a0,a0,15
  a2cd36:	f0f7f793          	andi	a5,a5,-241
  a2cd3a:	08a7a79b          	orshf	a5,a5,a0,sll,4
  a2cd3e:	c71c                	sw	a5,8(a4)
  a2cd40:	8082                	ret

00a2cd42 <update_reset_count>:
  a2cd42:	8038                	push	{ra,s0-s1},-16
  a2cd44:	400007b7          	lui	a5,0x40000
  a2cd48:	4780                	lw	s0,8(a5)
  a2cd4a:	00a3 2924 051f      	l.li	a0,0xa32924
  a2cd50:	8011                	srli	s0,s0,0x4
  a2cd52:	883d                	andi	s0,s0,15
  a2cd54:	00140493          	addi	s1,s0,1
  a2cd58:	85a6                	mv	a1,s1
  a2cd5a:	f0bff0ef          	jal	ra,a2cc64 <boot_msg1>
  a2cd5e:	06400513          	li	a0,100
  a2cd62:	dfafd0ef          	jal	ra,a2a35c <uapi_tcxo_delay_ms>
  a2cd66:	0f04033b          	beqi	s0,15,a2cd72 <update_reset_count+0x30>
  a2cd6a:	8526                	mv	a0,s1
  a2cd6c:	8030                	pop	{ra,s0-s1},16
  a2cd6e:	fc1ff06f          	j	a2cd2e <set_reset_count>
  a2cd72:	b37fd0ef          	jal	ra,a2a8a8 <uapi_watchdog_disable>
  a2cd76:	10500073          	wfi
  a2cd7a:	a001                	j	a2cd7a <update_reset_count+0x38>

00a2cd7c <interrupt0_handler>:
  a2cd7c:	8028                	push	{ra,s0},-16
  a2cd7e:	040007b7          	lui	a5,0x4000
  a2cd82:	3047b7f3          	csrrc	a5,mie,a5
  a2cd86:	00a06437          	lui	s0,0xa06
  a2cd8a:	84040713          	addi	a4,s0,-1984 # a05840 <g_interrupt_running>
  a2cd8e:	431c                	lw	a5,0(a4)
  a2cd90:	84040413          	addi	s0,s0,-1984
  a2cd94:	0785                	addi	a5,a5,1 # 4000001 <_gp_+0x35cb7bd>
  a2cd96:	c31c                	sw	a5,0(a4)
  a2cd98:	22c9                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cd9a:	5538                	lw	a4,104(a0)
  a2cd9c:	00a2 d37c 079f      	l.li	a5,0xa2d37c
  a2cda2:	00f70563          	beq	a4,a5,a2cdac <interrupt0_handler+0x30>
  a2cda6:	2a55                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cda8:	553c                	lw	a5,104(a0)
  a2cdaa:	9782                	jalr	a5
  a2cdac:	040007b7          	lui	a5,0x4000
  a2cdb0:	3047a7f3          	csrrs	a5,mie,a5
  a2cdb4:	401c                	lw	a5,0(s0)
  a2cdb6:	17fd                	addi	a5,a5,-1 # 3ffffff <_gp_+0x35cb7bb>
  a2cdb8:	c01c                	sw	a5,0(s0)
  a2cdba:	8024                	popret	{ra,s0},16

00a2cdbc <interrupt1_handler>:
  a2cdbc:	8028                	push	{ra,s0},-16
  a2cdbe:	080007b7          	lui	a5,0x8000
  a2cdc2:	3047b7f3          	csrrc	a5,mie,a5
  a2cdc6:	00a06437          	lui	s0,0xa06
  a2cdca:	84040713          	addi	a4,s0,-1984 # a05840 <g_interrupt_running>
  a2cdce:	431c                	lw	a5,0(a4)
  a2cdd0:	84040413          	addi	s0,s0,-1984
  a2cdd4:	0785                	addi	a5,a5,1 # 8000001 <_gp_+0x75cb7bd>
  a2cdd6:	c31c                	sw	a5,0(a4)
  a2cdd8:	2249                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cdda:	5578                	lw	a4,108(a0)
  a2cddc:	00a2 d37c 079f      	l.li	a5,0xa2d37c
  a2cde2:	00f70563          	beq	a4,a5,a2cdec <interrupt1_handler+0x30>
  a2cde6:	2a95                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cde8:	557c                	lw	a5,108(a0)
  a2cdea:	9782                	jalr	a5
  a2cdec:	080007b7          	lui	a5,0x8000
  a2cdf0:	3047a7f3          	csrrs	a5,mie,a5
  a2cdf4:	401c                	lw	a5,0(s0)
  a2cdf6:	17fd                	addi	a5,a5,-1 # 7ffffff <_gp_+0x75cb7bb>
  a2cdf8:	c01c                	sw	a5,0(s0)
  a2cdfa:	8024                	popret	{ra,s0},16

00a2cdfc <interrupt2_handler>:
  a2cdfc:	8028                	push	{ra,s0},-16
  a2cdfe:	100007b7          	lui	a5,0x10000
  a2ce02:	3047b7f3          	csrrc	a5,mie,a5
  a2ce06:	00a06437          	lui	s0,0xa06
  a2ce0a:	84040713          	addi	a4,s0,-1984 # a05840 <g_interrupt_running>
  a2ce0e:	431c                	lw	a5,0(a4)
  a2ce10:	84040413          	addi	s0,s0,-1984
  a2ce14:	0785                	addi	a5,a5,1 # 10000001 <_gp_+0xf5cb7bd>
  a2ce16:	c31c                	sw	a5,0(a4)
  a2ce18:	2289                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2ce1a:	5938                	lw	a4,112(a0)
  a2ce1c:	00a2 d37c 079f      	l.li	a5,0xa2d37c
  a2ce22:	00f70563          	beq	a4,a5,a2ce2c <interrupt2_handler+0x30>
  a2ce26:	2a15                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2ce28:	593c                	lw	a5,112(a0)
  a2ce2a:	9782                	jalr	a5
  a2ce2c:	100007b7          	lui	a5,0x10000
  a2ce30:	3047a7f3          	csrrs	a5,mie,a5
  a2ce34:	401c                	lw	a5,0(s0)
  a2ce36:	17fd                	addi	a5,a5,-1 # fffffff <_gp_+0xf5cb7bb>
  a2ce38:	c01c                	sw	a5,0(s0)
  a2ce3a:	8024                	popret	{ra,s0},16

00a2ce3c <interrupt3_handler>:
  a2ce3c:	8028                	push	{ra,s0},-16
  a2ce3e:	200007b7          	lui	a5,0x20000
  a2ce42:	3047b7f3          	csrrc	a5,mie,a5
  a2ce46:	00a06437          	lui	s0,0xa06
  a2ce4a:	84040713          	addi	a4,s0,-1984 # a05840 <g_interrupt_running>
  a2ce4e:	431c                	lw	a5,0(a4)
  a2ce50:	84040413          	addi	s0,s0,-1984
  a2ce54:	0785                	addi	a5,a5,1 # 20000001 <_gp_+0x1f5cb7bd>
  a2ce56:	c31c                	sw	a5,0(a4)
  a2ce58:	2209                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2ce5a:	5978                	lw	a4,116(a0)
  a2ce5c:	00a2 d37c 079f      	l.li	a5,0xa2d37c
  a2ce62:	00f70563          	beq	a4,a5,a2ce6c <interrupt3_handler+0x30>
  a2ce66:	28d5                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2ce68:	597c                	lw	a5,116(a0)
  a2ce6a:	9782                	jalr	a5
  a2ce6c:	200007b7          	lui	a5,0x20000
  a2ce70:	3047a7f3          	csrrs	a5,mie,a5
  a2ce74:	401c                	lw	a5,0(s0)
  a2ce76:	17fd                	addi	a5,a5,-1 # 1fffffff <_gp_+0x1f5cb7bb>
  a2ce78:	c01c                	sw	a5,0(s0)
  a2ce7a:	8024                	popret	{ra,s0},16

00a2ce7c <interrupt4_handler>:
  a2ce7c:	8028                	push	{ra,s0},-16
  a2ce7e:	400007b7          	lui	a5,0x40000
  a2ce82:	3047b7f3          	csrrc	a5,mie,a5
  a2ce86:	00a06437          	lui	s0,0xa06
  a2ce8a:	84040713          	addi	a4,s0,-1984 # a05840 <g_interrupt_running>
  a2ce8e:	431c                	lw	a5,0(a4)
  a2ce90:	84040413          	addi	s0,s0,-1984
  a2ce94:	0785                	addi	a5,a5,1 # 40000001 <_gp_+0x3f5cb7bd>
  a2ce96:	c31c                	sw	a5,0(a4)
  a2ce98:	20c9                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2ce9a:	5d38                	lw	a4,120(a0)
  a2ce9c:	00a2 d37c 079f      	l.li	a5,0xa2d37c
  a2cea2:	00f70563          	beq	a4,a5,a2ceac <interrupt4_handler+0x30>
  a2cea6:	2855                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cea8:	5d3c                	lw	a5,120(a0)
  a2ceaa:	9782                	jalr	a5
  a2ceac:	400007b7          	lui	a5,0x40000
  a2ceb0:	3047a7f3          	csrrs	a5,mie,a5
  a2ceb4:	401c                	lw	a5,0(s0)
  a2ceb6:	17fd                	addi	a5,a5,-1 # 3fffffff <_gp_+0x3f5cb7bb>
  a2ceb8:	c01c                	sw	a5,0(s0)
  a2ceba:	8024                	popret	{ra,s0},16

00a2cebc <interrupt5_handler>:
  a2cebc:	8028                	push	{ra,s0},-16
  a2cebe:	800007b7          	lui	a5,0x80000
  a2cec2:	3047b7f3          	csrrc	a5,mie,a5
  a2cec6:	00a06437          	lui	s0,0xa06
  a2ceca:	84040713          	addi	a4,s0,-1984 # a05840 <g_interrupt_running>
  a2cece:	431c                	lw	a5,0(a4)
  a2ced0:	84040413          	addi	s0,s0,-1984
  a2ced4:	0785                	addi	a5,a5,1 # 80000001 <_gp_+0x7f5cb7bd>
  a2ced6:	c31c                	sw	a5,0(a4)
  a2ced8:	2049                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2ceda:	5d78                	lw	a4,124(a0)
  a2cedc:	00a2 d37c 079f      	l.li	a5,0xa2d37c
  a2cee2:	00f70563          	beq	a4,a5,a2ceec <interrupt5_handler+0x30>
  a2cee6:	2895                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cee8:	5d7c                	lw	a5,124(a0)
  a2ceea:	9782                	jalr	a5
  a2ceec:	800007b7          	lui	a5,0x80000
  a2cef0:	3047a7f3          	csrrs	a5,mie,a5
  a2cef4:	401c                	lw	a5,0(s0)
  a2cef6:	17fd                	addi	a5,a5,-1 # 7fffffff <_gp_+0x7f5cb7bb>
  a2cef8:	c01c                	sw	a5,0(s0)
  a2cefa:	8024                	popret	{ra,s0},16

00a2cefc <local_interrupt_handler>:
  a2cefc:	8038                	push	{ra,s0-s1},-16
  a2cefe:	65b040ef          	jal	ra,a31d58 <global_interrupt_lock>
  a2cf02:	00a064b7          	lui	s1,0xa06
  a2cf06:	84048713          	addi	a4,s1,-1984 # a05840 <g_interrupt_running>
  a2cf0a:	431c                	lw	a5,0(a4)
  a2cf0c:	0785                	addi	a5,a5,1
  a2cf0e:	c31c                	sw	a5,0(a4)
  a2cf10:	661040ef          	jal	ra,a31d70 <global_interrupt_restore>
  a2cf14:	34202473          	csrr	s0,mcause
  a2cf18:	2089                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cf1a:	6785                	lui	a5,0x1
  a2cf1c:	17fd                	addi	a5,a5,-1 # fff <ccause+0x3d>
  a2cf1e:	8c7d                	and	s0,s0,a5
  a2cf20:	040a                	slli	s0,s0,0x2
  a2cf22:	9522                	add	a0,a0,s0
  a2cf24:	4118                	lw	a4,0(a0)
  a2cf26:	00a2 cf58 079f      	l.li	a5,0xa2cf58
  a2cf2c:	84048493          	addi	s1,s1,-1984
  a2cf30:	00f70663          	beq	a4,a5,a2cf3c <local_interrupt_handler+0x40>
  a2cf34:	201d                	jal	ra,a2cf5a <isr_get_ramexceptiontable_addr>
  a2cf36:	9522                	add	a0,a0,s0
  a2cf38:	411c                	lw	a5,0(a0)
  a2cf3a:	9782                	jalr	a5
  a2cf3c:	61d040ef          	jal	ra,a31d58 <global_interrupt_lock>
  a2cf40:	409c                	lw	a5,0(s1)
  a2cf42:	17fd                	addi	a5,a5,-1
  a2cf44:	c09c                	sw	a5,0(s1)
  a2cf46:	8030                	pop	{ra,s0-s1},16
  a2cf48:	6290406f          	j	a31d70 <global_interrupt_restore>

00a2cf4c <interrupt_number_get>:
  a2cf4c:	34202573          	csrr	a0,mcause
  a2cf50:	6785                	lui	a5,0x1
  a2cf52:	17fd                	addi	a5,a5,-1 # fff <ccause+0x3d>
  a2cf54:	8d7d                	and	a0,a0,a5
  a2cf56:	8082                	ret

00a2cf58 <b_sub_monitor_handler>:
  a2cf58:	a001                	j	a2cf58 <b_sub_monitor_handler>

00a2cf5a <isr_get_ramexceptiontable_addr>:
  a2cf5a:	00a2 8420 051f      	l.li	a0,0xa28420
  a2cf60:	8082                	ret

00a2cf62 <do_hard_fault_handler>:
  a2cf62:	c13d                	beqz	a0,a2cfc8 <do_hard_fault_handler+0x66>
  a2cf64:	8048                	push	{ra,s0-s2},-16
  a2cf66:	00452903          	lw	s2,4(a0)
  a2cf6a:	842a                	mv	s0,a0
  a2cf6c:	00a3 297c 051f      	l.li	a0,0xa3297c
  a2cf72:	85ca                	mv	a1,s2
  a2cf74:	a7cff0ef          	jal	ra,a2c1f0 <print_str>
  a2cf78:	800007b7          	lui	a5,0x80000
  a2cf7c:	07b1                	addi	a5,a5,12 # 8000000c <_gp_+0x7f5cb7c8>
  a2cf7e:	04f91263          	bne	s2,a5,a2cfc2 <do_hard_fault_handler+0x60>
  a2cf82:	00a3 2990 051f      	l.li	a0,0xa32990
  a2cf88:	6489                	lui	s1,0x2
  a2cf8a:	a66ff0ef          	jal	ra,a2c1f0 <print_str>
  a2cf8e:	04a1                	addi	s1,s1,8 # 2008 <ccause+0x1046>
  a2cf90:	8526                	mv	a0,s1
  a2cf92:	349000ef          	jal	ra,a2dada <cpu_utils_set_system_status_by_cause>
  a2cf96:	4c5c                	lw	a5,28(s0)
  a2cf98:	8522                	mv	a0,s0
  a2cf9a:	07c1                	addi	a5,a5,16
  a2cf9c:	cc5c                	sw	a5,28(s0)
  a2cf9e:	4a7000ef          	jal	ra,a2dc44 <set_exception_info_riscv>
  a2cfa2:	00a0 5858 079f      	l.li	a5,0xa05858
  a2cfa8:	439c                	lw	a5,0(a5)
  a2cfaa:	c781                	beqz	a5,a2cfb2 <do_hard_fault_handler+0x50>
  a2cfac:	85a2                	mv	a1,s0
  a2cfae:	854a                	mv	a0,s2
  a2cfb0:	9782                	jalr	a5
  a2cfb2:	85a6                	mv	a1,s1
  a2cfb4:	4509                	li	a0,2
  a2cfb6:	32d000ef          	jal	ra,a2dae2 <cpu_utils_reset_chip_with_log>
  a2cfba:	4501                	li	a0,0
  a2cfbc:	8040                	pop	{ra,s0-s2},16
  a2cfbe:	8a7fd06f          	j	a2a864 <uapi_watchdog_enable>
  a2cfc2:	6489                	lui	s1,0x2
  a2cfc4:	0491                	addi	s1,s1,4 # 2004 <ccause+0x1042>
  a2cfc6:	b7e9                	j	a2cf90 <do_hard_fault_handler+0x2e>
  a2cfc8:	8082                	ret

00a2cfca <exc_info_display.part.2>:
  a2cfca:	8028                	push	{ra,s0},-16
  a2cfcc:	842a                	mv	s0,a0
  a2cfce:	00a3 2bec 051f      	l.li	a0,0xa32bec
  a2cfd4:	a1cff0ef          	jal	ra,a2c1f0 <print_str>
  a2cfd8:	202e                	lhu	a1,2(s0)
  a2cfda:	00a3 2c24 051f      	l.li	a0,0xa32c24
  a2cfe0:	a10ff0ef          	jal	ra,a2c1f0 <print_str>
  a2cfe4:	481c                	lw	a5,16(s0)
  a2cfe6:	00a3 2c3c 051f      	l.li	a0,0xa32c3c
  a2cfec:	4bcc                	lw	a1,20(a5)
  a2cfee:	a02ff0ef          	jal	ra,a2c1f0 <print_str>
  a2cff2:	481c                	lw	a5,16(s0)
  a2cff4:	00a3 2c54 051f      	l.li	a0,0xa32c54
  a2cffa:	4b8c                	lw	a1,16(a5)
  a2cffc:	9f4ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d000:	481c                	lw	a5,16(s0)
  a2d002:	00a3 2c6c 051f      	l.li	a0,0xa32c6c
  a2d008:	478c                	lw	a1,8(a5)
  a2d00a:	9e6ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d00e:	481c                	lw	a5,16(s0)
  a2d010:	00a3 2c84 051f      	l.li	a0,0xa32c84
  a2d016:	43cc                	lw	a1,4(a5)
  a2d018:	9d8ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d01c:	481c                	lw	a5,16(s0)
  a2d01e:	00a3 2c9c 051f      	l.li	a0,0xa32c9c
  a2d024:	438c                	lw	a1,0(a5)
  a2d026:	9caff0ef          	jal	ra,a2c1f0 <print_str>
  a2d02a:	481c                	lw	a5,16(s0)
  a2d02c:	00a3 2cb4 051f      	l.li	a0,0xa32cb4
  a2d032:	08c7a583          	lw	a1,140(a5)
  a2d036:	9baff0ef          	jal	ra,a2c1f0 <print_str>
  a2d03a:	481c                	lw	a5,16(s0)
  a2d03c:	00a3 2ccc 051f      	l.li	a0,0xa32ccc
  a2d042:	4fcc                	lw	a1,28(a5)
  a2d044:	9acff0ef          	jal	ra,a2c1f0 <print_str>
  a2d048:	481c                	lw	a5,16(s0)
  a2d04a:	00a3 2ce4 051f      	l.li	a0,0xa32ce4
  a2d050:	47cc                	lw	a1,12(a5)
  a2d052:	99eff0ef          	jal	ra,a2c1f0 <print_str>
  a2d056:	481c                	lw	a5,16(s0)
  a2d058:	00a3 2cfc 051f      	l.li	a0,0xa32cfc
  a2d05e:	4f8c                	lw	a1,24(a5)
  a2d060:	990ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d064:	481c                	lw	a5,16(s0)
  a2d066:	00a3 2d14 051f      	l.li	a0,0xa32d14
  a2d06c:	0887a583          	lw	a1,136(a5)
  a2d070:	980ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d074:	481c                	lw	a5,16(s0)
  a2d076:	00a3 2d2c 051f      	l.li	a0,0xa32d2c
  a2d07c:	0847a583          	lw	a1,132(a5)
  a2d080:	970ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d084:	481c                	lw	a5,16(s0)
  a2d086:	00a3 2d44 051f      	l.li	a0,0xa32d44
  a2d08c:	0807a583          	lw	a1,128(a5)
  a2d090:	960ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d094:	481c                	lw	a5,16(s0)
  a2d096:	00a3 2d5c 051f      	l.li	a0,0xa32d5c
  a2d09c:	47ec                	lw	a1,76(a5)
  a2d09e:	952ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0a2:	481c                	lw	a5,16(s0)
  a2d0a4:	00a3 2d74 051f      	l.li	a0,0xa32d74
  a2d0aa:	47ac                	lw	a1,72(a5)
  a2d0ac:	944ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0b0:	481c                	lw	a5,16(s0)
  a2d0b2:	00a3 2d8c 051f      	l.li	a0,0xa32d8c
  a2d0b8:	5fec                	lw	a1,124(a5)
  a2d0ba:	936ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0be:	481c                	lw	a5,16(s0)
  a2d0c0:	00a3 2da4 051f      	l.li	a0,0xa32da4
  a2d0c6:	5fac                	lw	a1,120(a5)
  a2d0c8:	928ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0cc:	481c                	lw	a5,16(s0)
  a2d0ce:	00a3 2dbc 051f      	l.li	a0,0xa32dbc
  a2d0d4:	5bec                	lw	a1,116(a5)
  a2d0d6:	91aff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0da:	481c                	lw	a5,16(s0)
  a2d0dc:	00a3 2dd4 051f      	l.li	a0,0xa32dd4
  a2d0e2:	5bac                	lw	a1,112(a5)
  a2d0e4:	90cff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0e8:	481c                	lw	a5,16(s0)
  a2d0ea:	00a3 2dec 051f      	l.li	a0,0xa32dec
  a2d0f0:	57ec                	lw	a1,108(a5)
  a2d0f2:	8feff0ef          	jal	ra,a2c1f0 <print_str>
  a2d0f6:	481c                	lw	a5,16(s0)
  a2d0f8:	00a3 2e04 051f      	l.li	a0,0xa32e04
  a2d0fe:	57ac                	lw	a1,104(a5)
  a2d100:	8f0ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d104:	481c                	lw	a5,16(s0)
  a2d106:	00a3 2e1c 051f      	l.li	a0,0xa32e1c
  a2d10c:	53ec                	lw	a1,100(a5)
  a2d10e:	8e2ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d112:	481c                	lw	a5,16(s0)
  a2d114:	00a3 2e34 051f      	l.li	a0,0xa32e34
  a2d11a:	53ac                	lw	a1,96(a5)
  a2d11c:	8d4ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d120:	481c                	lw	a5,16(s0)
  a2d122:	00a3 2e4c 051f      	l.li	a0,0xa32e4c
  a2d128:	43ec                	lw	a1,68(a5)
  a2d12a:	8c6ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d12e:	481c                	lw	a5,16(s0)
  a2d130:	00a3 2e64 051f      	l.li	a0,0xa32e64
  a2d136:	43ac                	lw	a1,64(a5)
  a2d138:	8b8ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d13c:	481c                	lw	a5,16(s0)
  a2d13e:	00a3 2e7c 051f      	l.li	a0,0xa32e7c
  a2d144:	5fcc                	lw	a1,60(a5)
  a2d146:	8aaff0ef          	jal	ra,a2c1f0 <print_str>
  a2d14a:	481c                	lw	a5,16(s0)
  a2d14c:	00a3 2e94 051f      	l.li	a0,0xa32e94
  a2d152:	5f8c                	lw	a1,56(a5)
  a2d154:	89cff0ef          	jal	ra,a2c1f0 <print_str>
  a2d158:	481c                	lw	a5,16(s0)
  a2d15a:	00a3 2eac 051f      	l.li	a0,0xa32eac
  a2d160:	5bcc                	lw	a1,52(a5)
  a2d162:	88eff0ef          	jal	ra,a2c1f0 <print_str>
  a2d166:	481c                	lw	a5,16(s0)
  a2d168:	00a3 2ec4 051f      	l.li	a0,0xa32ec4
  a2d16e:	5b8c                	lw	a1,48(a5)
  a2d170:	880ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d174:	481c                	lw	a5,16(s0)
  a2d176:	00a3 2edc 051f      	l.li	a0,0xa32edc
  a2d17c:	57cc                	lw	a1,44(a5)
  a2d17e:	872ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d182:	481c                	lw	a5,16(s0)
  a2d184:	00a3 2ef4 051f      	l.li	a0,0xa32ef4
  a2d18a:	578c                	lw	a1,40(a5)
  a2d18c:	864ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d190:	481c                	lw	a5,16(s0)
  a2d192:	00a3 2f0c 051f      	l.li	a0,0xa32f0c
  a2d198:	53cc                	lw	a1,36(a5)
  a2d19a:	856ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d19e:	481c                	lw	a5,16(s0)
  a2d1a0:	00a3 2f24 051f      	l.li	a0,0xa32f24
  a2d1a6:	538c                	lw	a1,32(a5)
  a2d1a8:	848ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d1ac:	481c                	lw	a5,16(s0)
  a2d1ae:	00a3 2f3c 051f      	l.li	a0,0xa32f3c
  a2d1b4:	4fec                	lw	a1,92(a5)
  a2d1b6:	83aff0ef          	jal	ra,a2c1f0 <print_str>
  a2d1ba:	481c                	lw	a5,16(s0)
  a2d1bc:	00a3 2f54 051f      	l.li	a0,0xa32f54
  a2d1c2:	4fac                	lw	a1,88(a5)
  a2d1c4:	82cff0ef          	jal	ra,a2c1f0 <print_str>
  a2d1c8:	481c                	lw	a5,16(s0)
  a2d1ca:	00a3 2f6c 051f      	l.li	a0,0xa32f6c
  a2d1d0:	4bec                	lw	a1,84(a5)
  a2d1d2:	81eff0ef          	jal	ra,a2c1f0 <print_str>
  a2d1d6:	481c                	lw	a5,16(s0)
  a2d1d8:	00a3 2f84 051f      	l.li	a0,0xa32f84
  a2d1de:	4bac                	lw	a1,80(a5)
  a2d1e0:	810ff0ef          	jal	ra,a2c1f0 <print_str>
  a2d1e4:	00a3 2f9c 051f      	l.li	a0,0xa32f9c
  a2d1ea:	8020                	pop	{ra,s0},16
  a2d1ec:	804ff06f          	j	a2c1f0 <print_str>

00a2d1f0 <do_process_exception>:
  a2d1f0:	4154                	lw	a3,4(a0)
  a2d1f2:	00a067b7          	lui	a5,0xa06
  a2d1f6:	84478713          	addi	a4,a5,-1980 # a05844 <g_exc_info>
  a2d1fa:	cb08                	sw	a0,16(a4)
  a2d1fc:	84478513          	addi	a0,a5,-1980
  a2d200:	a336                	sh	a3,2(a4)
  a2d202:	dc9ff06f          	j	a2cfca <exc_info_display.part.2>

00a2d206 <do_trap_unknown>:
  a2d206:	8028                	push	{ra,s0},-16
  a2d208:	842a                	mv	s0,a0
  a2d20a:	00a3 2bcc 051f      	l.li	a0,0xa32bcc
  a2d210:	fe1fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d214:	8522                	mv	a0,s0
  a2d216:	8020                	pop	{ra,s0},16
  a2d218:	fd9ff06f          	j	a2d1f0 <do_process_exception>

00a2d21c <do_trap_insn_misaligned>:
  a2d21c:	8028                	push	{ra,s0},-16
  a2d21e:	842a                	mv	s0,a0
  a2d220:	00a3 2afc 051f      	l.li	a0,0xa32afc
  a2d226:	fcbfe0ef          	jal	ra,a2c1f0 <print_str>
  a2d22a:	8522                	mv	a0,s0
  a2d22c:	8020                	pop	{ra,s0},16
  a2d22e:	fc3ff06f          	j	a2d1f0 <do_process_exception>

00a2d232 <do_trap_insn_fault>:
  a2d232:	8028                	push	{ra,s0},-16
  a2d234:	842a                	mv	s0,a0
  a2d236:	00a3 2ab0 051f      	l.li	a0,0xa32ab0
  a2d23c:	fb5fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d240:	8522                	mv	a0,s0
  a2d242:	8020                	pop	{ra,s0},16
  a2d244:	fadff06f          	j	a2d1f0 <do_process_exception>

00a2d248 <do_trap_insn_illegal>:
  a2d248:	8028                	push	{ra,s0},-16
  a2d24a:	842a                	mv	s0,a0
  a2d24c:	00a3 2ad8 051f      	l.li	a0,0xa32ad8
  a2d252:	f9ffe0ef          	jal	ra,a2c1f0 <print_str>
  a2d256:	8522                	mv	a0,s0
  a2d258:	8020                	pop	{ra,s0},16
  a2d25a:	f97ff06f          	j	a2d1f0 <do_process_exception>

00a2d25e <do_trap_load_misaligned>:
  a2d25e:	8028                	push	{ra,s0},-16
  a2d260:	842a                	mv	s0,a0
  a2d262:	00a3 2b48 051f      	l.li	a0,0xa32b48
  a2d268:	f89fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d26c:	8522                	mv	a0,s0
  a2d26e:	8020                	pop	{ra,s0},16
  a2d270:	f81ff06f          	j	a2d1f0 <do_process_exception>

00a2d274 <do_trap_load_fault>:
  a2d274:	8028                	push	{ra,s0},-16
  a2d276:	842a                	mv	s0,a0
  a2d278:	00a3 2b28 051f      	l.li	a0,0xa32b28
  a2d27e:	f73fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d282:	8522                	mv	a0,s0
  a2d284:	8020                	pop	{ra,s0},16
  a2d286:	f6bff06f          	j	a2d1f0 <do_process_exception>

00a2d28a <do_trap_store_misaligned>:
  a2d28a:	8028                	push	{ra,s0},-16
  a2d28c:	842a                	mv	s0,a0
  a2d28e:	00a3 2b9c 051f      	l.li	a0,0xa32b9c
  a2d294:	f5dfe0ef          	jal	ra,a2c1f0 <print_str>
  a2d298:	8522                	mv	a0,s0
  a2d29a:	8020                	pop	{ra,s0},16
  a2d29c:	f55ff06f          	j	a2d1f0 <do_process_exception>

00a2d2a0 <do_trap_store_fault>:
  a2d2a0:	8028                	push	{ra,s0},-16
  a2d2a2:	842a                	mv	s0,a0
  a2d2a4:	00a3 2b70 051f      	l.li	a0,0xa32b70
  a2d2aa:	f47fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d2ae:	8522                	mv	a0,s0
  a2d2b0:	8020                	pop	{ra,s0},16
  a2d2b2:	f3fff06f          	j	a2d1f0 <do_process_exception>

00a2d2b6 <do_trap_ecall_u>:
  a2d2b6:	8028                	push	{ra,s0},-16
  a2d2b8:	842a                	mv	s0,a0
  a2d2ba:	00a3 2a84 051f      	l.li	a0,0xa32a84
  a2d2c0:	f31fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d2c4:	8522                	mv	a0,s0
  a2d2c6:	8020                	pop	{ra,s0},16
  a2d2c8:	f29ff06f          	j	a2d1f0 <do_process_exception>

00a2d2cc <do_trap_ecall_s>:
  a2d2cc:	8028                	push	{ra,s0},-16
  a2d2ce:	842a                	mv	s0,a0
  a2d2d0:	00a3 2a58 051f      	l.li	a0,0xa32a58
  a2d2d6:	f1bfe0ef          	jal	ra,a2c1f0 <print_str>
  a2d2da:	8522                	mv	a0,s0
  a2d2dc:	8020                	pop	{ra,s0},16
  a2d2de:	f13ff06f          	j	a2d1f0 <do_process_exception>

00a2d2e2 <do_trap_ecall_m>:
  a2d2e2:	8028                	push	{ra,s0},-16
  a2d2e4:	842a                	mv	s0,a0
  a2d2e6:	00a3 2a2c 051f      	l.li	a0,0xa32a2c
  a2d2ec:	f05fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d2f0:	8522                	mv	a0,s0
  a2d2f2:	8020                	pop	{ra,s0},16
  a2d2f4:	efdff06f          	j	a2d1f0 <do_process_exception>

00a2d2f8 <do_trap_break>:
  a2d2f8:	8028                	push	{ra,s0},-16
  a2d2fa:	842a                	mv	s0,a0
  a2d2fc:	00a3 2a18 051f      	l.li	a0,0xa32a18
  a2d302:	eeffe0ef          	jal	ra,a2c1f0 <print_str>
  a2d306:	8522                	mv	a0,s0
  a2d308:	8020                	pop	{ra,s0},16
  a2d30a:	ee7ff06f          	j	a2d1f0 <do_process_exception>

00a2d30e <do_insn_page_fault>:
  a2d30e:	8028                	push	{ra,s0},-16
  a2d310:	842a                	mv	s0,a0
  a2d312:	00a3 29a0 051f      	l.li	a0,0xa329a0
  a2d318:	ed9fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d31c:	8522                	mv	a0,s0
  a2d31e:	8020                	pop	{ra,s0},16
  a2d320:	ed1ff06f          	j	a2d1f0 <do_process_exception>

00a2d324 <do_load_page_fault>:
  a2d324:	8028                	push	{ra,s0},-16
  a2d326:	842a                	mv	s0,a0
  a2d328:	00a3 29c0 051f      	l.li	a0,0xa329c0
  a2d32e:	ec3fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d332:	8522                	mv	a0,s0
  a2d334:	8020                	pop	{ra,s0},16
  a2d336:	ebbff06f          	j	a2d1f0 <do_process_exception>

00a2d33a <do_store_page_fault>:
  a2d33a:	8028                	push	{ra,s0},-16
  a2d33c:	842a                	mv	s0,a0
  a2d33e:	00a3 29f8 051f      	l.li	a0,0xa329f8
  a2d344:	eadfe0ef          	jal	ra,a2c1f0 <print_str>
  a2d348:	8522                	mv	a0,s0
  a2d34a:	8020                	pop	{ra,s0},16
  a2d34c:	ea5ff06f          	j	a2d1f0 <do_process_exception>

00a2d350 <do_hard_fault>:
  a2d350:	8028                	push	{ra,s0},-16
  a2d352:	842a                	mv	s0,a0
  a2d354:	00a3 2964 051f      	l.li	a0,0xa32964
  a2d35a:	e97fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d35e:	8522                	mv	a0,s0
  a2d360:	8020                	pop	{ra,s0},16
  a2d362:	e8fff06f          	j	a2d1f0 <do_process_exception>

00a2d366 <do_lockup>:
  a2d366:	8028                	push	{ra,s0},-16
  a2d368:	842a                	mv	s0,a0
  a2d36a:	00a3 29e0 051f      	l.li	a0,0xa329e0
  a2d370:	e81fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d374:	8522                	mv	a0,s0
  a2d376:	8020                	pop	{ra,s0},16
  a2d378:	e79ff06f          	j	a2d1f0 <do_process_exception>

00a2d37c <default_handler>:
  a2d37c:	8018                	push	{ra},-16
  a2d37e:	bcfff0ef          	jal	ra,a2cf4c <interrupt_number_get>
  a2d382:	85aa                	mv	a1,a0
  a2d384:	00a3 2938 051f      	l.li	a0,0xa32938
  a2d38a:	e67fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d38e:	a001                	j	a2d38e <default_handler+0x12>

00a2d390 <nmi_handler>:
  a2d390:	8018                	push	{ra},-16
  a2d392:	bbbff0ef          	jal	ra,a2cf4c <interrupt_number_get>
  a2d396:	85aa                	mv	a1,a0
  a2d398:	00a3 2fd8 051f      	l.li	a0,0xa32fd8
  a2d39e:	e53fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d3a2:	a001                	j	a2d3a2 <nmi_handler+0x12>

00a2d3a4 <partition_get_addr>:
  a2d3a4:	0020 0380 051f      	l.li	a0,0x200380
  a2d3aa:	8082                	ret

00a2d3ac <partition_get_path_map>:
  a2d3ac:	00a0 585c 079f      	l.li	a5,0xa0585c
  a2d3b2:	c11c                	sw	a5,0(a0)
  a2d3b4:	4501                	li	a0,0
  a2d3b6:	8082                	ret

00a2d3b8 <upg_progress_callbck>:
  a2d3b8:	8128                	push	{ra,s0},-32
  a2d3ba:	842a                	mv	s0,a0
  a2d3bc:	00a3 305c 051f      	l.li	a0,0xa3305c
  a2d3c2:	809ff0ef          	jal	ra,a2cbca <serial_puts>
  a2d3c6:	640413bb          	bnei	s0,100,a2d3d4 <upg_progress_callbck+0x1c>
  a2d3ca:	00a3 3074 051f      	l.li	a0,0xa33074
  a2d3d0:	ffaff0ef          	jal	ra,a2cbca <serial_puts>
  a2d3d4:	47a9                	li	a5,10
  a2d3d6:	02f45733          	divu	a4,s0,a5
  a2d3da:	0068                	addi	a0,sp,12
  a2d3dc:	00010723          	sb	zero,14(sp)
  a2d3e0:	02f77733          	remu	a4,a4,a5
  a2d3e4:	02f477b3          	remu	a5,s0,a5
  a2d3e8:	03070713          	addi	a4,a4,48 # 40000030 <_gp_+0x3f5cb7ec>
  a2d3ec:	00e10623          	sb	a4,12(sp)
  a2d3f0:	03078793          	addi	a5,a5,48
  a2d3f4:	00f106a3          	sb	a5,13(sp)
  a2d3f8:	fd2ff0ef          	jal	ra,a2cbca <serial_puts>
  a2d3fc:	00a3 3078 051f      	l.li	a0,0xa33078
  a2d402:	fc8ff0ef          	jal	ra,a2cbca <serial_puts>
  a2d406:	640413bb          	bnei	s0,100,a2d414 <upg_progress_callbck+0x5c>
  a2d40a:	00a3 3110 051f      	l.li	a0,0xa33110
  a2d410:	fbaff0ef          	jal	ra,a2cbca <serial_puts>
  a2d414:	8124                	popret	{ra,s0},32

00a2d416 <check_fota_msid>:
  a2d416:	8138                	push	{ra,s0-s1},-32
  a2d418:	842a                	mv	s0,a0
  a2d41a:	84ae                	mv	s1,a1
  a2d41c:	4611                	li	a2,4
  a2d41e:	0f800593          	li	a1,248
  a2d422:	0068                	addi	a0,sp,12
  a2d424:	c602                	sw	zero,12(sp)
  a2d426:	d84fd0ef          	jal	ra,a2a9aa <uapi_efuse_read_buffer>
  a2d42a:	c519                	beqz	a0,a2d438 <check_fota_msid+0x22>
  a2d42c:	85aa                	mv	a1,a0
  a2d42e:	00a3 3000 051f      	l.li	a0,0xa33000
  a2d434:	dbdfe0ef          	jal	ra,a2c1f0 <print_str>
  a2d438:	47b2                	lw	a5,12(sp)
  a2d43a:	8c3d                	xor	s0,s0,a5
  a2d43c:	8c65                	and	s0,s0,s1
  a2d43e:	c411                	beqz	s0,a2d44a <check_fota_msid+0x34>
  a2d440:	00a3 3020 051f      	l.li	a0,0xa33020
  a2d446:	dabfe0ef          	jal	ra,a2c1f0 <print_str>
  a2d44a:	4501                	li	a0,0
  a2d44c:	8134                	popret	{ra,s0-s1},32

00a2d44e <ws63_upg_putc>:
  a2d44e:	f5cff06f          	j	a2cbaa <serial_putc>

00a2d452 <upg_free_port>:
  a2d452:	8038                	push	{ra,s0-s1},-16
  a2d454:	84aa                	mv	s1,a0
  a2d456:	103040ef          	jal	ra,a31d58 <global_interrupt_lock>
  a2d45a:	842a                	mv	s0,a0
  a2d45c:	8526                	mv	a0,s1
  a2d45e:	d8cfc0ef          	jal	ra,a299ea <free>
  a2d462:	8522                	mv	a0,s0
  a2d464:	8030                	pop	{ra,s0-s1},16
  a2d466:	10b0406f          	j	a31d70 <global_interrupt_restore>

00a2d46a <upg_malloc_port>:
  a2d46a:	8038                	push	{ra,s0-s1},-16
  a2d46c:	842a                	mv	s0,a0
  a2d46e:	0eb040ef          	jal	ra,a31d58 <global_interrupt_lock>
  a2d472:	84aa                	mv	s1,a0
  a2d474:	8522                	mv	a0,s0
  a2d476:	d3efc0ef          	jal	ra,a299b4 <malloc>
  a2d47a:	842a                	mv	s0,a0
  a2d47c:	8526                	mv	a0,s1
  a2d47e:	0f3040ef          	jal	ra,a31d70 <global_interrupt_restore>
  a2d482:	8522                	mv	a0,s0
  a2d484:	8034                	popret	{ra,s0-s1},16

00a2d486 <upg_get_ids_map>:
  a2d486:	00a3 3fd0 079f      	l.li	a5,0xa33fd0
  a2d48c:	c11c                	sw	a5,0(a0)
  a2d48e:	450d                	li	a0,3
  a2d490:	8082                	ret

00a2d492 <upg_img_in_set>:
  a2d492:	00a3 3ff8 079f      	l.li	a5,0xa33ff8
  a2d498:	43d4                	lw	a3,4(a5)
  a2d49a:	ce89                	beqz	a3,a2d4b4 <upg_img_in_set+0x22>
  a2d49c:	4398                	lw	a4,0(a5)
  a2d49e:	4781                	li	a5,0
  a2d4a0:	0711                	addi	a4,a4,4
  a2d4a2:	ffc72603          	lw	a2,-4(a4)
  a2d4a6:	00a60763          	beq	a2,a0,a2d4b4 <upg_img_in_set+0x22>
  a2d4aa:	0785                	addi	a5,a5,1
  a2d4ac:	fef69ae3          	bne	a3,a5,a2d4a0 <upg_img_in_set+0xe>
  a2d4b0:	4501                	li	a0,0
  a2d4b2:	8082                	ret
  a2d4b4:	4505                	li	a0,1
  a2d4b6:	8082                	ret

00a2d4b8 <upg_get_upgrade_flag_flash_start_addr>:
  a2d4b8:	8128                	push	{ra,s0},-32
  a2d4ba:	842a                	mv	s0,a0
  a2d4bc:	004c                	addi	a1,sp,4
  a2d4be:	02100513          	li	a0,33
  a2d4c2:	051000ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2d4c6:	e519                	bnez	a0,a2d4d4 <upg_get_upgrade_flag_flash_start_addr+0x1c>
  a2d4c8:	4732                	lw	a4,12(sp)
  a2d4ca:	47a2                	lw	a5,8(sp)
  a2d4cc:	97ba                	add	a5,a5,a4
  a2d4ce:	777d                	lui	a4,0xfffff
  a2d4d0:	97ba                	add	a5,a5,a4
  a2d4d2:	c01c                	sw	a5,0(s0)
  a2d4d4:	8124                	popret	{ra,s0},32

00a2d4d6 <upg_get_progress_status_start_addr>:
  a2d4d6:	8138                	push	{ra,s0-s1},-32
  a2d4d8:	84aa                	mv	s1,a0
  a2d4da:	842e                	mv	s0,a1
  a2d4dc:	02100513          	li	a0,33
  a2d4e0:	004c                	addi	a1,sp,4
  a2d4e2:	031000ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2d4e6:	e909                	bnez	a0,a2d4f8 <upg_get_progress_status_start_addr+0x22>
  a2d4e8:	4732                	lw	a4,12(sp)
  a2d4ea:	47a2                	lw	a5,8(sp)
  a2d4ec:	97ba                	add	a5,a5,a4
  a2d4ee:	7775                	lui	a4,0xffffd
  a2d4f0:	97ba                	add	a5,a5,a4
  a2d4f2:	c09c                	sw	a5,0(s1)
  a2d4f4:	678d                	lui	a5,0x3
  a2d4f6:	c01c                	sw	a5,0(s0)
  a2d4f8:	8134                	popret	{ra,s0-s1},32

00a2d4fa <upg_get_fota_partiton_area_addr>:
  a2d4fa:	8138                	push	{ra,s0-s1},-32
  a2d4fc:	84aa                	mv	s1,a0
  a2d4fe:	842e                	mv	s0,a1
  a2d500:	02100513          	li	a0,33
  a2d504:	004c                	addi	a1,sp,4
  a2d506:	00d000ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2d50a:	e509                	bnez	a0,a2d514 <upg_get_fota_partiton_area_addr+0x1a>
  a2d50c:	47a2                	lw	a5,8(sp)
  a2d50e:	c09c                	sw	a5,0(s1)
  a2d510:	47b2                	lw	a5,12(sp)
  a2d512:	c01c                	sw	a5,0(s0)
  a2d514:	8134                	popret	{ra,s0-s1},32

00a2d516 <upg_reboot>:
  a2d516:	8018                	push	{ra},-16
  a2d518:	1f400513          	li	a0,500
  a2d51c:	e41fc0ef          	jal	ra,a2a35c <uapi_tcxo_delay_ms>
  a2d520:	8010                	pop	{ra},16
  a2d522:	8e7fd06f          	j	a2ae08 <hal_reboot_chip>

00a2d526 <upg_progress_callback_register>:
  a2d526:	8018                	push	{ra},-16
  a2d528:	00a2 d3b8 051f      	l.li	a0,0xa2d3b8
  a2d52e:	341010ef          	jal	ra,a2f06e <uapi_upg_register_progress_callback>
  a2d532:	c519                	beqz	a0,a2d540 <upg_progress_callback_register+0x1a>
  a2d534:	00a3 3034 051f      	l.li	a0,0xa33034
  a2d53a:	8010                	pop	{ra},16
  a2d53c:	cb5fe06f          	j	a2c1f0 <print_str>
  a2d540:	8014                	popret	{ra},16

00a2d542 <upg_watchdog_kick>:
  a2d542:	bd6fd06f          	j	a2a918 <uapi_watchdog_kick>

00a2d546 <upg_get_flash_base_addr>:
  a2d546:	00200537          	lui	a0,0x200
  a2d54a:	8082                	ret

00a2d54c <upg_get_flash_size>:
  a2d54c:	00800537          	lui	a0,0x800
  a2d550:	8082                	ret

00a2d552 <upg_flash_read>:
  a2d552:	87b2                	mv	a5,a2
  a2d554:	862e                	mv	a2,a1
  a2d556:	85be                	mv	a1,a5
  a2d558:	998ff06f          	j	a2c6f0 <uapi_sfc_reg_read>

00a2d55c <upg_flash_erase>:
  a2d55c:	8098                	push	{ra,s0-s7},-48
  a2d55e:	00b50a33          	add	s4,a0,a1
  a2d562:	014a1793          	slli	a5,s4,0x14
  a2d566:	84aa                	mv	s1,a0
  a2d568:	89d2                	mv	s3,s4
  a2d56a:	c791                	beqz	a5,a2d576 <upg_flash_erase+0x1a>
  a2d56c:	79fd                	lui	s3,0xfffff
  a2d56e:	013a79b3          	and	s3,s4,s3
  a2d572:	6785                	lui	a5,0x1
  a2d574:	99be                	add	s3,s3,a5
  a2d576:	6505                	lui	a0,0x1
  a2d578:	01b000ef          	jal	ra,a2dd92 <upg_malloc>
  a2d57c:	8aaa                	mv	s5,a0
  a2d57e:	c909                	beqz	a0,a2d590 <upg_flash_erase+0x34>
  a2d580:	6505                	lui	a0,0x1
  a2d582:	011000ef          	jal	ra,a2dd92 <upg_malloc>
  a2d586:	8b2a                	mv	s6,a0
  a2d588:	e901                	bnez	a0,a2d598 <upg_flash_erase+0x3c>
  a2d58a:	8556                	mv	a0,s5
  a2d58c:	021000ef          	jal	ra,a2ddac <upg_free>
  a2d590:	80000437          	lui	s0,0x80000
  a2d594:	0415                	addi	s0,s0,5 # 80000005 <_gp_+0x7f5cb7c1>
  a2d596:	a881                	j	a2d5e6 <upg_flash_erase+0x8a>
  a2d598:	797d                	lui	s2,0xfffff
  a2d59a:	0124f933          	and	s2,s1,s2
  a2d59e:	412484b3          	sub	s1,s1,s2
  a2d5a2:	e48d                	bnez	s1,a2d5cc <upg_flash_erase+0x70>
  a2d5a4:	41498bb3          	sub	s7,s3,s4
  a2d5a8:	040b9163          	bnez	s7,a2d5ea <upg_flash_erase+0x8e>
  a2d5ac:	412985b3          	sub	a1,s3,s2
  a2d5b0:	854a                	mv	a0,s2
  a2d5b2:	b10ff0ef          	jal	ra,a2c8c2 <uapi_sfc_reg_erase>
  a2d5b6:	842a                	mv	s0,a0
  a2d5b8:	e10d                	bnez	a0,a2d5da <upg_flash_erase+0x7e>
  a2d5ba:	e0a1                	bnez	s1,a2d5fa <upg_flash_erase+0x9e>
  a2d5bc:	000b8f63          	beqz	s7,a2d5da <upg_flash_erase+0x7e>
  a2d5c0:	865e                	mv	a2,s7
  a2d5c2:	85da                	mv	a1,s6
  a2d5c4:	8552                	mv	a0,s4
  a2d5c6:	9feff0ef          	jal	ra,a2c7c4 <uapi_sfc_reg_write>
  a2d5ca:	a835                	j	a2d606 <upg_flash_erase+0xaa>
  a2d5cc:	8626                	mv	a2,s1
  a2d5ce:	85d6                	mv	a1,s5
  a2d5d0:	854a                	mv	a0,s2
  a2d5d2:	91eff0ef          	jal	ra,a2c6f0 <uapi_sfc_reg_read>
  a2d5d6:	842a                	mv	s0,a0
  a2d5d8:	d571                	beqz	a0,a2d5a4 <upg_flash_erase+0x48>
  a2d5da:	8556                	mv	a0,s5
  a2d5dc:	7d0000ef          	jal	ra,a2ddac <upg_free>
  a2d5e0:	855a                	mv	a0,s6
  a2d5e2:	7ca000ef          	jal	ra,a2ddac <upg_free>
  a2d5e6:	8522                	mv	a0,s0
  a2d5e8:	8094                	popret	{ra,s0-s7},48
  a2d5ea:	865e                	mv	a2,s7
  a2d5ec:	85da                	mv	a1,s6
  a2d5ee:	8552                	mv	a0,s4
  a2d5f0:	900ff0ef          	jal	ra,a2c6f0 <uapi_sfc_reg_read>
  a2d5f4:	842a                	mv	s0,a0
  a2d5f6:	f175                	bnez	a0,a2d5da <upg_flash_erase+0x7e>
  a2d5f8:	bf55                	j	a2d5ac <upg_flash_erase+0x50>
  a2d5fa:	8626                	mv	a2,s1
  a2d5fc:	85d6                	mv	a1,s5
  a2d5fe:	854a                	mv	a0,s2
  a2d600:	9c4ff0ef          	jal	ra,a2c7c4 <uapi_sfc_reg_write>
  a2d604:	dd45                	beqz	a0,a2d5bc <upg_flash_erase+0x60>
  a2d606:	842a                	mv	s0,a0
  a2d608:	bfc9                	j	a2d5da <upg_flash_erase+0x7e>

00a2d60a <upg_flash_write>:
  a2d60a:	8048                	push	{ra,s0-s2},-16
  a2d60c:	842a                	mv	s0,a0
  a2d60e:	84ae                	mv	s1,a1
  a2d610:	8932                	mv	s2,a2
  a2d612:	e699                	bnez	a3,a2d620 <upg_flash_write+0x16>
  a2d614:	8626                	mv	a2,s1
  a2d616:	85ca                	mv	a1,s2
  a2d618:	8522                	mv	a0,s0
  a2d61a:	8040                	pop	{ra,s0-s2},16
  a2d61c:	9a8ff06f          	j	a2c7c4 <uapi_sfc_reg_write>
  a2d620:	f3dff0ef          	jal	ra,a2d55c <upg_flash_erase>
  a2d624:	d965                	beqz	a0,a2d614 <upg_flash_write+0xa>
  a2d626:	8044                	popret	{ra,s0-s2},16

00a2d628 <upg_get_root_public_key>:
  a2d628:	8118                	push	{ra},-32
  a2d62a:	004c                	addi	a1,sp,4
  a2d62c:	450d                	li	a0,3
  a2d62e:	6e4000ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2d632:	4781                	li	a5,0
  a2d634:	e519                	bnez	a0,a2d642 <upg_get_root_public_key+0x1a>
  a2d636:	4722                	lw	a4,8(sp)
  a2d638:	002007b7          	lui	a5,0x200
  a2d63c:	97ba                	add	a5,a5,a4
  a2d63e:	04078793          	addi	a5,a5,64 # 200040 <__heap_size+0x1e2a48>
  a2d642:	853e                	mv	a0,a5
  a2d644:	8114                	popret	{ra},32

00a2d646 <upg_check_fota_information>:
  a2d646:	8028                	push	{ra,s0},-16
  a2d648:	842a                	mv	s0,a0
  a2d64a:	590c                	lw	a1,48(a0)
  a2d64c:	5548                	lw	a0,44(a0)
  a2d64e:	dc9ff0ef          	jal	ra,a2d416 <check_fota_msid>
  a2d652:	e901                	bnez	a0,a2d662 <upg_check_fota_information+0x1c>
  a2d654:	11c42583          	lw	a1,284(s0)
  a2d658:	11842503          	lw	a0,280(s0)
  a2d65c:	8020                	pop	{ra,s0},16
  a2d65e:	db9ff06f          	j	a2d416 <check_fota_msid>
  a2d662:	8024                	popret	{ra,s0},16

00a2d664 <ws63_upg_init>:
  a2d664:	8128                	push	{ra,s0},-32
  a2d666:	00a2 d46a 079f      	l.li	a5,0xa2d46a
  a2d66c:	c23e                	sw	a5,4(sp)
  a2d66e:	00a2 d452 079f      	l.li	a5,0xa2d452
  a2d674:	c43e                	sw	a5,8(sp)
  a2d676:	0048                	addi	a0,sp,4
  a2d678:	00a2 d44e 079f      	l.li	a5,0xa2d44e
  a2d67e:	c63e                	sw	a5,12(sp)
  a2d680:	49d000ef          	jal	ra,a2e31c <uapi_upg_init>
  a2d684:	842a                	mv	s0,a0
  a2d686:	c901                	beqz	a0,a2d696 <ws63_upg_init+0x32>
  a2d688:	00a3 307c 051f      	l.li	a0,0xa3307c
  a2d68e:	b63fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d692:	8522                	mv	a0,s0
  a2d694:	8124                	popret	{ra,s0},32
  a2d696:	e91ff0ef          	jal	ra,a2d526 <upg_progress_callback_register>
  a2d69a:	00a3 3094 051f      	l.li	a0,0xa33094
  a2d6a0:	db2ff0ef          	jal	ra,a2cc52 <boot_msg0>
  a2d6a4:	b7fd                	j	a2d692 <ws63_upg_init+0x2e>

00a2d6a6 <upg_erase_whole_image>:
  a2d6a6:	8118                	push	{ra},-32
  a2d6a8:	4148                	lw	a0,4(a0)
  a2d6aa:	004c                	addi	a1,sp,4
  a2d6ac:	79a000ef          	jal	ra,a2de46 <upg_get_image_info>
  a2d6b0:	e509                	bnez	a0,a2d6ba <upg_erase_whole_image+0x14>
  a2d6b2:	45b2                	lw	a1,12(sp)
  a2d6b4:	4522                	lw	a0,8(sp)
  a2d6b6:	ea7ff0ef          	jal	ra,a2d55c <upg_flash_erase>
  a2d6ba:	8114                	popret	{ra},32

00a2d6bc <upg_cryto_init>:
  a2d6bc:	8148                	push	{ra,s0-s2},-32
  a2d6be:	47f1                	li	a5,28
  a2d6c0:	5178                	lw	a4,100(a0)
  a2d6c2:	06c50913          	addi	s2,a0,108 # 106c <ccause+0xaa>
  a2d6c6:	c43e                	sw	a5,8(sp)
  a2d6c8:	4785                	li	a5,1
  a2d6ca:	00f10623          	sb	a5,12(sp)
  a2d6ce:	00010023          	sb	zero,0(sp)
  a2d6d2:	000100a3          	sb	zero,1(sp)
  a2d6d6:	00010123          	sb	zero,2(sp)
  a2d6da:	c24a                	sw	s2,4(sp)
  a2d6dc:	3c78 96e1 079f      	l.li	a5,0x3c7896e1
  a2d6e2:	4401                	li	s0,0
  a2d6e4:	02f71d63          	bne	a4,a5,a2d71e <upg_cryto_init+0x62>
  a2d6e8:	00a0 585c 049f      	l.li	s1,0xa0585c
  a2d6ee:	030007b7          	lui	a5,0x3000
  a2d6f2:	00d78713          	addi	a4,a5,13 # 300000d <_gp_+0x25cb7c9>
  a2d6f6:	842a                	mv	s0,a0
  a2d6f8:	07cd                	addi	a5,a5,19
  a2d6fa:	46f1                	li	a3,28
  a2d6fc:	864a                	mv	a2,s2
  a2d6fe:	45f1                	li	a1,28
  a2d700:	03c48513          	addi	a0,s1,60
  a2d704:	d8d8                	sw	a4,52(s1)
  a2d706:	c09c                	sw	a5,0(s1)
  a2d708:	3c6030ef          	jal	ra,a30ace <memcpy_s>
  a2d70c:	c919                	beqz	a0,a2d722 <upg_cryto_init+0x66>
  a2d70e:	00a3 30a4 051f      	l.li	a0,0xa330a4
  a2d714:	80000437          	lui	s0,0x80000
  a2d718:	ad9fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d71c:	0411                	addi	s0,s0,4 # 80000004 <_gp_+0x7f5cb7c0>
  a2d71e:	8522                	mv	a0,s0
  a2d720:	8144                	popret	{ra,s0-s2},32
  a2d722:	46f1                	li	a3,28
  a2d724:	864a                	mv	a2,s2
  a2d726:	45f1                	li	a1,28
  a2d728:	00848513          	addi	a0,s1,8
  a2d72c:	3a2030ef          	jal	ra,a30ace <memcpy_s>
  a2d730:	c509                	beqz	a0,a2d73a <upg_cryto_init+0x7e>
  a2d732:	00a3 30dc 051f      	l.li	a0,0xa330dc
  a2d738:	bff1                	j	a2d714 <upg_cryto_init+0x58>
  a2d73a:	08c40413          	addi	s0,s0,140
  a2d73e:	46c1                	li	a3,16
  a2d740:	8622                	mv	a2,s0
  a2d742:	45c1                	li	a1,16
  a2d744:	05848513          	addi	a0,s1,88
  a2d748:	386030ef          	jal	ra,a30ace <memcpy_s>
  a2d74c:	c509                	beqz	a0,a2d756 <upg_cryto_init+0x9a>
  a2d74e:	00a3 3114 051f      	l.li	a0,0xa33114
  a2d754:	b7c1                	j	a2d714 <upg_cryto_init+0x58>
  a2d756:	46c1                	li	a3,16
  a2d758:	8622                	mv	a2,s0
  a2d75a:	45c1                	li	a1,16
  a2d75c:	02448513          	addi	a0,s1,36
  a2d760:	36e030ef          	jal	ra,a30ace <memcpy_s>
  a2d764:	c509                	beqz	a0,a2d76e <upg_cryto_init+0xb2>
  a2d766:	00a3 3148 051f      	l.li	a0,0xa33148
  a2d76c:	b765                	j	a2d714 <upg_cryto_init+0x58>
  a2d76e:	ea2fc0ef          	jal	ra,a29e10 <drv_rom_cipher_symc_init>
  a2d772:	842a                	mv	s0,a0
  a2d774:	c901                	beqz	a0,a2d784 <upg_cryto_init+0xc8>
  a2d776:	85aa                	mv	a1,a0
  a2d778:	00a3 317c 051f      	l.li	a0,0xa3317c
  a2d77e:	a73fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d782:	bf71                	j	a2d71e <upg_cryto_init+0x62>
  a2d784:	58d0                	lw	a2,52(s1)
  a2d786:	858a                	mv	a1,sp
  a2d788:	03848513          	addi	a0,s1,56
  a2d78c:	c2efc0ef          	jal	ra,a29bba <drv_rom_cipher_create_keyslot>
  a2d790:	842a                	mv	s0,a0
  a2d792:	c911                	beqz	a0,a2d7a6 <upg_cryto_init+0xea>
  a2d794:	85aa                	mv	a1,a0
  a2d796:	00a3 31b0 051f      	l.li	a0,0xa331b0
  a2d79c:	a55fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d7a0:	ec0fc0ef          	jal	ra,a29e60 <drv_rom_cipher_symc_deinit>
  a2d7a4:	bfad                	j	a2d71e <upg_cryto_init+0x62>
  a2d7a6:	4090                	lw	a2,0(s1)
  a2d7a8:	858a                	mv	a1,sp
  a2d7aa:	00448513          	addi	a0,s1,4
  a2d7ae:	c0cfc0ef          	jal	ra,a29bba <drv_rom_cipher_create_keyslot>
  a2d7b2:	842a                	mv	s0,a0
  a2d7b4:	d52d                	beqz	a0,a2d71e <upg_cryto_init+0x62>
  a2d7b6:	85aa                	mv	a1,a0
  a2d7b8:	00a3 31f4 051f      	l.li	a0,0xa331f4
  a2d7be:	a33fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d7c2:	5c88                	lw	a0,56(s1)
  a2d7c4:	c72fc0ef          	jal	ra,a29c36 <drv_rom_cipher_destroy_keyslot>
  a2d7c8:	bfe1                	j	a2d7a0 <upg_cryto_init+0xe4>

00a2d7ca <upg_cryto_deinit>:
  a2d7ca:	5178                	lw	a4,100(a0)
  a2d7cc:	3c78 96e1 079f      	l.li	a5,0x3c7896e1
  a2d7d2:	00f70463          	beq	a4,a5,a2d7da <upg_cryto_deinit+0x10>
  a2d7d6:	4501                	li	a0,0
  a2d7d8:	8082                	ret
  a2d7da:	8038                	push	{ra,s0-s1},-16
  a2d7dc:	00a0 585c 049f      	l.li	s1,0xa0585c
  a2d7e2:	5c88                	lw	a0,56(s1)
  a2d7e4:	c52fc0ef          	jal	ra,a29c36 <drv_rom_cipher_destroy_keyslot>
  a2d7e8:	842a                	mv	s0,a0
  a2d7ea:	40c8                	lw	a0,4(s1)
  a2d7ec:	c4afc0ef          	jal	ra,a29c36 <drv_rom_cipher_destroy_keyslot>
  a2d7f0:	8c49                	or	s0,s0,a0
  a2d7f2:	e6efc0ef          	jal	ra,a29e60 <drv_rom_cipher_symc_deinit>
  a2d7f6:	8d41                	or	a0,a0,s0
  a2d7f8:	8034                	popret	{ra,s0-s1},16

00a2d7fa <upg_process_cryto_info>:
  a2d7fa:	219c                	lbu	a5,0(a1)
  a2d7fc:	e789                	bnez	a5,a2d806 <upg_process_cryto_info+0xc>
  a2d7fe:	00052023          	sw	zero,0(a0)
  a2d802:	4501                	li	a0,0
  a2d804:	8082                	ret
  a2d806:	30000793          	li	a5,768
  a2d80a:	c11c                	sw	a5,0(a0)
  a2d80c:	00058023          	sb	zero,0(a1)
  a2d810:	bfcd                	j	a2d802 <upg_process_cryto_info+0x8>

00a2d812 <upg_decry_fota_pkt>:
  a2d812:	8028                	push	{ra,s0},-16
  a2d814:	5278                	lw	a4,100(a2)
  a2d816:	3c78 96e1 079f      	l.li	a5,0x3c7896e1
  a2d81c:	4401                	li	s0,0
  a2d81e:	02f71863          	bne	a4,a5,a2d84e <upg_decry_fota_pkt+0x3c>
  a2d822:	87aa                	mv	a5,a0
  a2d824:	00a0 585c 051f      	l.li	a0,0xa0585c
  a2d82a:	88ae                	mv	a7,a1
  a2d82c:	02450593          	addi	a1,a0,36
  a2d830:	4148                	lw	a0,4(a0)
  a2d832:	4801                	li	a6,0
  a2d834:	86be                	mv	a3,a5
  a2d836:	4701                	li	a4,0
  a2d838:	4641                	li	a2,16
  a2d83a:	e36fc0ef          	jal	ra,a29e70 <drv_rom_cipher_symc_decrypt>
  a2d83e:	842a                	mv	s0,a0
  a2d840:	c519                	beqz	a0,a2d84e <upg_decry_fota_pkt+0x3c>
  a2d842:	85aa                	mv	a1,a0
  a2d844:	00a3 3238 051f      	l.li	a0,0xa33238
  a2d84a:	9a7fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d84e:	8522                	mv	a0,s0
  a2d850:	8024                	popret	{ra,s0},16

00a2d852 <upg_encry_fota_pkt>:
  a2d852:	8028                	push	{ra,s0},-16
  a2d854:	5278                	lw	a4,100(a2)
  a2d856:	3c78 96e1 079f      	l.li	a5,0x3c7896e1
  a2d85c:	4401                	li	s0,0
  a2d85e:	02f71863          	bne	a4,a5,a2d88e <upg_encry_fota_pkt+0x3c>
  a2d862:	87aa                	mv	a5,a0
  a2d864:	00a0 585c 051f      	l.li	a0,0xa0585c
  a2d86a:	88ae                	mv	a7,a1
  a2d86c:	05850593          	addi	a1,a0,88
  a2d870:	5d08                	lw	a0,56(a0)
  a2d872:	4801                	li	a6,0
  a2d874:	86be                	mv	a3,a5
  a2d876:	4701                	li	a4,0
  a2d878:	4641                	li	a2,16
  a2d87a:	df6fc0ef          	jal	ra,a29e70 <drv_rom_cipher_symc_decrypt>
  a2d87e:	842a                	mv	s0,a0
  a2d880:	c519                	beqz	a0,a2d88e <upg_encry_fota_pkt+0x3c>
  a2d882:	85aa                	mv	a1,a0
  a2d884:	00a3 3284 051f      	l.li	a0,0xa33284
  a2d88a:	967fe0ef          	jal	ra,a2c1f0 <print_str>
  a2d88e:	8522                	mv	a0,s0
  a2d890:	8024                	popret	{ra,s0},16

00a2d892 <mfg_malloc>:
  a2d892:	8038                	push	{ra,s0-s1},-16
  a2d894:	842a                	mv	s0,a0
  a2d896:	4c2040ef          	jal	ra,a31d58 <global_interrupt_lock>
  a2d89a:	84aa                	mv	s1,a0
  a2d89c:	8522                	mv	a0,s0
  a2d89e:	916fc0ef          	jal	ra,a299b4 <malloc>
  a2d8a2:	842a                	mv	s0,a0
  a2d8a4:	8526                	mv	a0,s1
  a2d8a6:	4ca040ef          	jal	ra,a31d70 <global_interrupt_restore>
  a2d8aa:	8522                	mv	a0,s0
  a2d8ac:	8034                	popret	{ra,s0-s1},16

00a2d8ae <mfg_free>:
  a2d8ae:	8038                	push	{ra,s0-s1},-16
  a2d8b0:	84aa                	mv	s1,a0
  a2d8b2:	4a6040ef          	jal	ra,a31d58 <global_interrupt_lock>
  a2d8b6:	842a                	mv	s0,a0
  a2d8b8:	8526                	mv	a0,s1
  a2d8ba:	930fc0ef          	jal	ra,a299ea <free>
  a2d8be:	8522                	mv	a0,s0
  a2d8c0:	8030                	pop	{ra,s0-s1},16
  a2d8c2:	4ae0406f          	j	a31d70 <global_interrupt_restore>

00a2d8c6 <mfg_flash_read>:
  a2d8c6:	8138                	push	{ra,s0-s1},-32
  a2d8c8:	84aa                	mv	s1,a0
  a2d8ca:	842e                	mv	s0,a1
  a2d8cc:	46b1                	li	a3,12
  a2d8ce:	45b1                	li	a1,12
  a2d8d0:	4601                	li	a2,0
  a2d8d2:	0048                	addi	a0,sp,4
  a2d8d4:	276030ef          	jal	ra,a30b4a <memset_s>
  a2d8d8:	004c                	addi	a1,sp,4
  a2d8da:	02100513          	li	a0,33
  a2d8de:	2915                	jal	ra,a2dd12 <uapi_partition_get_info>
  a2d8e0:	e505                	bnez	a0,a2d908 <mfg_flash_read+0x42>
  a2d8e2:	4532                	lw	a0,12(sp)
  a2d8e4:	47a2                	lw	a5,8(sp)
  a2d8e6:	004006b7          	lui	a3,0x400
  a2d8ea:	97aa                	add	a5,a5,a0
  a2d8ec:	7579                	lui	a0,0xffffe
  a2d8ee:	97aa                	add	a5,a5,a0
  a2d8f0:	557d                	li	a0,-1
  a2d8f2:	00f6eb63          	bltu	a3,a5,a2d908 <mfg_flash_read+0x42>
  a2d8f6:	00878733          	add	a4,a5,s0
  a2d8fa:	00e6e763          	bltu	a3,a4,a2d908 <mfg_flash_read+0x42>
  a2d8fe:	8622                	mv	a2,s0
  a2d900:	85a6                	mv	a1,s1
  a2d902:	853e                	mv	a0,a5
  a2d904:	dedfe0ef          	jal	ra,a2c6f0 <uapi_sfc_reg_read>
  a2d908:	8134                	popret	{ra,s0-s1},32

00a2d90a <mfg_flash_write_info>:
  a2d90a:	80c8                	push	{ra,s0-s10},-48
  a2d90c:	8baa                	mv	s7,a0
  a2d90e:	8aae                	mv	s5,a1
  a2d910:	89b2                	mv	s3,a2
  a2d912:	ea99                	bnez	a3,a2d928 <mfg_flash_write_info+0x1e>
  a2d914:	854e                	mv	a0,s3
  a2d916:	f7dff0ef          	jal	ra,a2d892 <mfg_malloc>
  a2d91a:	84aa                	mv	s1,a0
  a2d91c:	e955                	bnez	a0,a2d9d0 <mfg_flash_write_info+0xc6>
  a2d91e:	80000437          	lui	s0,0x80000
  a2d922:	0415                	addi	s0,s0,5 # 80000005 <_gp_+0x7f5cb7c1>
  a2d924:	8522                	mv	a0,s0
  a2d926:	80c4                	popret	{ra,s0-s10},48
  a2d928:	00c58a33          	add	s4,a1,a2
  a2d92c:	014a1793          	slli	a5,s4,0x14
  a2d930:	8952                	mv	s2,s4
  a2d932:	c791                	beqz	a5,a2d93e <mfg_flash_write_info+0x34>
  a2d934:	797d                	lui	s2,0xfffff
  a2d936:	012a7933          	and	s2,s4,s2
  a2d93a:	6785                	lui	a5,0x1
  a2d93c:	993e                	add	s2,s2,a5
  a2d93e:	6505                	lui	a0,0x1
  a2d940:	f53ff0ef          	jal	ra,a2d892 <mfg_malloc>
  a2d944:	8b2a                	mv	s6,a0
  a2d946:	dd61                	beqz	a0,a2d91e <mfg_flash_write_info+0x14>
  a2d948:	6505                	lui	a0,0x1
  a2d94a:	f49ff0ef          	jal	ra,a2d892 <mfg_malloc>
  a2d94e:	8c2a                	mv	s8,a0
  a2d950:	e509                	bnez	a0,a2d95a <mfg_flash_write_info+0x50>
  a2d952:	855a                	mv	a0,s6
  a2d954:	f5bff0ef          	jal	ra,a2d8ae <mfg_free>
  a2d958:	b7d9                	j	a2d91e <mfg_flash_write_info+0x14>
  a2d95a:	74fd                	lui	s1,0xfffff
  a2d95c:	009af4b3          	and	s1,s5,s1
  a2d960:	409a8d33          	sub	s10,s5,s1
  a2d964:	020d1763          	bnez	s10,a2d992 <mfg_flash_write_info+0x88>
  a2d968:	41490cb3          	sub	s9,s2,s4
  a2d96c:	040c9263          	bnez	s9,a2d9b0 <mfg_flash_write_info+0xa6>
  a2d970:	409905b3          	sub	a1,s2,s1
  a2d974:	8526                	mv	a0,s1
  a2d976:	f4dfe0ef          	jal	ra,a2c8c2 <uapi_sfc_reg_erase>
  a2d97a:	842a                	mv	s0,a0
  a2d97c:	e115                	bnez	a0,a2d9a0 <mfg_flash_write_info+0x96>
  a2d97e:	040d1163          	bnez	s10,a2d9c0 <mfg_flash_write_info+0xb6>
  a2d982:	000c8f63          	beqz	s9,a2d9a0 <mfg_flash_write_info+0x96>
  a2d986:	4681                	li	a3,0
  a2d988:	8666                	mv	a2,s9
  a2d98a:	85d2                	mv	a1,s4
  a2d98c:	8562                	mv	a0,s8
  a2d98e:	3fb5                	jal	ra,a2d90a <mfg_flash_write_info>
  a2d990:	a835                	j	a2d9cc <mfg_flash_write_info+0xc2>
  a2d992:	866a                	mv	a2,s10
  a2d994:	85da                	mv	a1,s6
  a2d996:	8526                	mv	a0,s1
  a2d998:	d59fe0ef          	jal	ra,a2c6f0 <uapi_sfc_reg_read>
  a2d99c:	842a                	mv	s0,a0
  a2d99e:	d569                	beqz	a0,a2d968 <mfg_flash_write_info+0x5e>
  a2d9a0:	855a                	mv	a0,s6
  a2d9a2:	f0dff0ef          	jal	ra,a2d8ae <mfg_free>
  a2d9a6:	8562                	mv	a0,s8
  a2d9a8:	f07ff0ef          	jal	ra,a2d8ae <mfg_free>
  a2d9ac:	d425                	beqz	s0,a2d914 <mfg_flash_write_info+0xa>
  a2d9ae:	bf9d                	j	a2d924 <mfg_flash_write_info+0x1a>
  a2d9b0:	8666                	mv	a2,s9
  a2d9b2:	85e2                	mv	a1,s8
  a2d9b4:	8552                	mv	a0,s4
  a2d9b6:	d3bfe0ef          	jal	ra,a2c6f0 <uapi_sfc_reg_read>
  a2d9ba:	842a                	mv	s0,a0
  a2d9bc:	f175                	bnez	a0,a2d9a0 <mfg_flash_write_info+0x96>
  a2d9be:	bf4d                	j	a2d970 <mfg_flash_write_info+0x66>
  a2d9c0:	4681                	li	a3,0
  a2d9c2:	866a                	mv	a2,s10
  a2d9c4:	85a6                	mv	a1,s1
  a2d9c6:	855a                	mv	a0,s6
  a2d9c8:	3789                	jal	ra,a2d90a <mfg_flash_write_info>
  a2d9ca:	dd45                	beqz	a0,a2d982 <mfg_flash_write_info+0x78>
  a2d9cc:	842a                	mv	s0,a0
  a2d9ce:	bfc9                	j	a2d9a0 <mfg_flash_write_info+0x96>
  a2d9d0:	864e                	mv	a2,s3
  a2d9d2:	85de                	mv	a1,s7
  a2d9d4:	8556                	mv	a0,s5
  a2d9d6:	deffe0ef          	jal	ra,a2c7c4 <uapi_sfc_reg_write>
  a2d9da:	842a                	mv	s0,a0
  a2d9dc:	e10d                	bnez	a0,a2d9fe <mfg_flash_write_info+0xf4>
  a2d9de:	00200637          	lui	a2,0x200
  a2d9e2:	86ce                	mv	a3,s3
  a2d9e4:	9656                	add	a2,a2,s5
  a2d9e6:	85ce                	mv	a1,s3
  a2d9e8:	8526                	mv	a0,s1
  a2d9ea:	0e4030ef          	jal	ra,a30ace <memcpy_s>
  a2d9ee:	842a                	mv	s0,a0
  a2d9f0:	e519                	bnez	a0,a2d9fe <mfg_flash_write_info+0xf4>
  a2d9f2:	864e                	mv	a2,s3
  a2d9f4:	85de                	mv	a1,s7
  a2d9f6:	8526                	mv	a0,s1
  a2d9f8:	af6fb0ef          	jal	ra,a28cee <memcmp>
  a2d9fc:	842a                	mv	s0,a0
  a2d9fe:	8526                	mv	a0,s1
  a2da00:	eafff0ef          	jal	ra,a2d8ae <mfg_free>
  a2da04:	b705                	j	a2d924 <mfg_flash_write_info+0x1a>

00a2da06 <mfg_flash_write>:
  a2da06:	8138                	push	{ra,s0-s1},-32
  a2da08:	84aa                	mv	s1,a0
  a2da0a:	842e                	mv	s0,a1
  a2da0c:	46b1                	li	a3,12
  a2da0e:	45b1                	li	a1,12
  a2da10:	4601                	li	a2,0
  a2da12:	0048                	addi	a0,sp,4
  a2da14:	136030ef          	jal	ra,a30b4a <memset_s>
  a2da18:	004c                	addi	a1,sp,4
  a2da1a:	02100513          	li	a0,33
  a2da1e:	2cd5                	jal	ra,a2dd12 <uapi_partition_get_info>
  a2da20:	e505                	bnez	a0,a2da48 <mfg_flash_write+0x42>
  a2da22:	47b2                	lw	a5,12(sp)
  a2da24:	45a2                	lw	a1,8(sp)
  a2da26:	00400737          	lui	a4,0x400
  a2da2a:	557d                	li	a0,-1
  a2da2c:	95be                	add	a1,a1,a5
  a2da2e:	77f9                	lui	a5,0xffffe
  a2da30:	95be                	add	a1,a1,a5
  a2da32:	00b76b63          	bltu	a4,a1,a2da48 <mfg_flash_write+0x42>
  a2da36:	008587b3          	add	a5,a1,s0
  a2da3a:	00f76763          	bltu	a4,a5,a2da48 <mfg_flash_write+0x42>
  a2da3e:	4685                	li	a3,1
  a2da40:	8622                	mv	a2,s0
  a2da42:	8526                	mv	a0,s1
  a2da44:	ec7ff0ef          	jal	ra,a2d90a <mfg_flash_write_info>
  a2da48:	8134                	popret	{ra,s0-s1},32

00a2da4a <mfg_get_ftm_run_region>:
  a2da4a:	8328                	push	{ra,s0},-64
  a2da4c:	c402                	sw	zero,8(sp)
  a2da4e:	c602                	sw	zero,12(sp)
  a2da50:	c802                	sw	zero,16(sp)
  a2da52:	c92d                	beqz	a0,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2da54:	842a                	mv	s0,a0
  a2da56:	002c                	addi	a1,sp,8
  a2da58:	02100513          	li	a0,33
  a2da5c:	2c5d                	jal	ra,a2dd12 <uapi_partition_get_info>
  a2da5e:	e13d                	bnez	a0,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2da60:	45f1                	li	a1,28
  a2da62:	8522                	mv	a0,s0
  a2da64:	e63ff0ef          	jal	ra,a2d8c6 <mfg_flash_read>
  a2da68:	ed31                	bnez	a0,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2da6a:	4732                	lw	a4,12(sp)
  a2da6c:	4c14                	lw	a3,24(s0)
  a2da6e:	002007b7          	lui	a5,0x200
  a2da72:	8f45 ba2f 061f      	l.li	a2,0x8f45ba2f
  a2da78:	97ba                	add	a5,a5,a4
  a2da7a:	04c68763          	beq	a3,a2,a2dac8 <mfg_get_ftm_run_region+0x7e>
  a2da7e:	438c                	lw	a1,0(a5)
  a2da80:	4b7c f333 069f      	l.li	a3,0x4b7cf333
  a2da86:	04d59163          	bne	a1,a3,a2dac8 <mfg_get_ftm_run_region+0x7e>
  a2da8a:	478c                	lw	a1,8(a5)
  a2da8c:	10000693          	li	a3,256
  a2da90:	02d59c63          	bne	a1,a3,a2dac8 <mfg_get_ftm_run_region+0x7e>
  a2da94:	1247a683          	lw	a3,292(a5) # 200124 <__heap_size+0x1e2b2c>
  a2da98:	4585                	li	a1,1
  a2da9a:	cc3e                	sw	a5,24(sp)
  a2da9c:	30068693          	addi	a3,a3,768 # 400300 <__heap_size+0x3e2d08>
  a2daa0:	ce3e                	sw	a5,28(sp)
  a2daa2:	ca2e                	sw	a1,20(sp)
  a2daa4:	d036                	sw	a3,32(sp)
  a2daa6:	d236                	sw	a3,36(sp)
  a2daa8:	d402                	sw	zero,40(sp)
  a2daaa:	d632                	sw	a2,44(sp)
  a2daac:	004007b7          	lui	a5,0x400
  a2dab0:	00e7ea63          	bltu	a5,a4,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2dab4:	9736                	add	a4,a4,a3
  a2dab6:	00e7e763          	bltu	a5,a4,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2daba:	45f1                	li	a1,28
  a2dabc:	0848                	addi	a0,sp,20
  a2dabe:	f49ff0ef          	jal	ra,a2da06 <mfg_flash_write>
  a2dac2:	c119                	beqz	a0,a2dac8 <mfg_get_ftm_run_region+0x7e>
  a2dac4:	4501                	li	a0,0
  a2dac6:	a809                	j	a2dad8 <mfg_get_ftm_run_region+0x8e>
  a2dac8:	45f1                	li	a1,28
  a2daca:	8522                	mv	a0,s0
  a2dacc:	dfbff0ef          	jal	ra,a2d8c6 <mfg_flash_read>
  a2dad0:	f975                	bnez	a0,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2dad2:	4008                	lw	a0,0(s0)
  a2dad4:	02f57c3b          	bgeui	a0,2,a2dac4 <mfg_get_ftm_run_region+0x7a>
  a2dad8:	8324                	popret	{ra,s0},64

00a2dada <cpu_utils_set_system_status_by_cause>:
  a2dada:	8018                	push	{ra},-16
  a2dadc:	223d                	jal	ra,a2dc0a <set_cpu_utils_reset_cause>
  a2dade:	8010                	pop	{ra},16
  a2dae0:	a8e9                	j	a2dbba <set_cpu_utils_system_boot_magic>

00a2dae2 <cpu_utils_reset_chip_with_log>:
  a2dae2:	8118                	push	{ra},-32
  a2dae4:	4501                	li	a0,0
  a2dae6:	c62e                	sw	a1,12(sp)
  a2dae8:	2a15                	jal	ra,a2dc1c <set_update_reset_cause_on_boot>
  a2daea:	45b2                	lw	a1,12(sp)
  a2daec:	852e                	mv	a0,a1
  a2daee:	fedff0ef          	jal	ra,a2dada <cpu_utils_set_system_status_by_cause>
  a2daf2:	8110                	pop	{ra},32
  a2daf4:	b14fd06f          	j	a2ae08 <hal_reboot_chip>

00a2daf8 <panic_deal>:
  a2daf8:	8458                	push	{ra,s0-s3},-96
  a2dafa:	86b2                	mv	a3,a2
  a2dafc:	892a                	mv	s2,a0
  a2dafe:	84ae                	mv	s1,a1
  a2db00:	8432                	mv	s0,a2
  a2db02:	862e                	mv	a2,a1
  a2db04:	85aa                	mv	a1,a0
  a2db06:	00a3 32d0 051f      	l.li	a0,0xa332d0
  a2db0c:	ee4fe0ef          	jal	ra,a2c1f0 <print_str>
  a2db10:	eddfb0ef          	jal	ra,a299ec <osal_irq_lock>
  a2db14:	00a0 58c4 079f      	l.li	a5,0xa058c4
  a2db1a:	2398                	lbu	a4,0(a5)
  a2db1c:	89aa                	mv	s3,a0
  a2db1e:	e321                	bnez	a4,a2db5e <panic_deal+0x66>
  a2db20:	4705                	li	a4,1
  a2db22:	a398                	sb	a4,0(a5)
  a2db24:	03210023          	sb	s2,32(sp)
  a2db28:	d226                	sw	s1,36(sp)
  a2db2a:	fa0fc0ef          	jal	ra,a2a2ca <uapi_systick_get_us>
  a2db2e:	d42a                	sw	a0,40(sp)
  a2db30:	1008                	addi	a0,sp,32
  a2db32:	d622                	sw	s0,44(sp)
  a2db34:	28d5                	jal	ra,a2dc28 <set_last_panic>
  a2db36:	02000613          	li	a2,32
  a2db3a:	4581                	li	a1,0
  a2db3c:	1008                	addi	a0,sp,32
  a2db3e:	c802                	sw	zero,16(sp)
  a2db40:	ca02                	sw	zero,20(sp)
  a2db42:	cc02                	sw	zero,24(sp)
  a2db44:	ce02                	sw	zero,28(sp)
  a2db46:	e5ffa0ef          	jal	ra,a289a4 <memset>
  a2db4a:	da22                	sw	s0,52(sp)
  a2db4c:	341027f3          	csrr	a5,mepc
  a2db50:	dc3e                	sw	a5,56(sp)
  a2db52:	878a                	mv	a5,sp
  a2db54:	0068                	addi	a0,sp,12
  a2db56:	c63e                	sw	a5,12(sp)
  a2db58:	2221                	jal	ra,a2dc60 <set_exception_info>
  a2db5a:	1008                	addi	a0,sp,32
  a2db5c:	2215                	jal	ra,a2dc80 <set_exception_stack_frame>
  a2db5e:	00a0 58c8 079f      	l.li	a5,0xa058c8
  a2db64:	439c                	lw	a5,0(a5)
  a2db66:	c391                	beqz	a5,a2db6a <panic_deal+0x72>
  a2db68:	9782                	jalr	a5
  a2db6a:	6589                	lui	a1,0x2
  a2db6c:	058d                	addi	a1,a1,3 # 2003 <ccause+0x1041>
  a2db6e:	4509                	li	a0,2
  a2db70:	f73ff0ef          	jal	ra,a2dae2 <cpu_utils_reset_chip_with_log>
  a2db74:	854e                	mv	a0,s3
  a2db76:	e7ffb0ef          	jal	ra,a299f4 <osal_irq_restore>
  a2db7a:	8454                	popret	{ra,s0-s3},96

00a2db7c <panic>:
  a2db7c:	00a3 4000 079f      	l.li	a5,0xa34000
  a2db82:	0007a303          	lw	t1,0(a5) # 400000 <__heap_size+0x3e2a08>
  a2db86:	00030563          	beqz	t1,a2db90 <panic+0x14>
  a2db8a:	ffb08613          	addi	a2,ra,-5
  a2db8e:	8302                	jr	t1
  a2db90:	8118                	push	{ra},-32
  a2db92:	4785                	li	a5,1
  a2db94:	00f107a3          	sb	a5,15(sp)
  a2db98:	00f14783          	lbu	a5,15(sp)
  a2db9c:	9f81                	uxtb	a5
  a2db9e:	ffed                	bnez	a5,a2db98 <panic+0x1c>
  a2dba0:	8114                	popret	{ra},32

00a2dba2 <duplicate_preserve_mem>:
  a2dba2:	0fc00693          	li	a3,252
  a2dba6:	00a3 4044 061f      	l.li	a2,0xa34044
  a2dbac:	0fc00593          	li	a1,252
  a2dbb0:	00a0 58cc 051f      	l.li	a0,0xa058cc
  a2dbb6:	7190206f          	j	a30ace <memcpy_s>

00a2dbba <set_cpu_utils_system_boot_magic>:
  a2dbba:	00a34737          	lui	a4,0xa34
  a2dbbe:	04470793          	addi	a5,a4,68 # a34044 <g_preserve_data_lib>
  a2dbc2:	0d87d783          	lhu	a5,216(a5)
  a2dbc6:	6689                	lui	a3,0x2
  a2dbc8:	04068613          	addi	a2,a3,64 # 2040 <ccause+0x107e>
  a2dbcc:	04470713          	addi	a4,a4,68
  a2dbd0:	02c78963          	beq	a5,a2,a2dc02 <set_cpu_utils_system_boot_magic+0x48>
  a2dbd4:	00f66c63          	bltu	a2,a5,a2dbec <set_cpu_utils_system_boot_magic+0x32>
  a2dbd8:	c78d                	beqz	a5,a2dc02 <set_cpu_utils_system_boot_magic+0x48>
  a2dbda:	0685                	addi	a3,a3,1
  a2dbdc:	02d78363          	beq	a5,a3,a2dc02 <set_cpu_utils_system_boot_magic+0x48>
  a2dbe0:	dead beaf 079f      	l.li	a5,0xdeadbeaf
  a2dbe6:	0ef72423          	sw	a5,232(a4)
  a2dbea:	8082                	ret
  a2dbec:	66a1                	lui	a3,0x8
  a2dbee:	0685                	addi	a3,a3,1 # 8001 <ccause+0x703f>
  a2dbf0:	00d78963          	beq	a5,a3,a2dc02 <set_cpu_utils_system_boot_magic+0x48>
  a2dbf4:	0000 f0f0 069f      	l.li	a3,0xf0f0
  a2dbfa:	00d78463          	beq	a5,a3,a2dc02 <set_cpu_utils_system_boot_magic+0x48>
  a2dbfe:	6691                	lui	a3,0x4
  a2dc00:	bfe9                	j	a2dbda <set_cpu_utils_system_boot_magic+0x20>
  a2dc02:	dead dead 079f      	l.li	a5,0xdeaddead
  a2dc08:	bff9                	j	a2dbe6 <set_cpu_utils_system_boot_magic+0x2c>

00a2dc0a <set_cpu_utils_reset_cause>:
  a2dc0a:	00a3 4044 079f      	l.li	a5,0xa34044
  a2dc10:	0c078d23          	sb	zero,218(a5)
  a2dc14:	0ca79c23          	sh	a0,216(a5)
  a2dc18:	f8bff06f          	j	a2dba2 <duplicate_preserve_mem>

00a2dc1c <set_update_reset_cause_on_boot>:
  a2dc1c:	00a3 4044 079f      	l.li	a5,0xa34044
  a2dc22:	0ca78d23          	sb	a0,218(a5)
  a2dc26:	8082                	ret

00a2dc28 <set_last_panic>:
  a2dc28:	8018                	push	{ra},-16
  a2dc2a:	862a                	mv	a2,a0
  a2dc2c:	00a3 4044 051f      	l.li	a0,0xa34044
  a2dc32:	46c1                	li	a3,16
  a2dc34:	45c1                	li	a1,16
  a2dc36:	0a450513          	addi	a0,a0,164 # 10a4 <ccause+0xe2>
  a2dc3a:	695020ef          	jal	ra,a30ace <memcpy_s>
  a2dc3e:	8010                	pop	{ra},16
  a2dc40:	f63ff06f          	j	a2dba2 <duplicate_preserve_mem>

00a2dc44 <set_exception_info_riscv>:
  a2dc44:	8018                	push	{ra},-16
  a2dc46:	862a                	mv	a2,a0
  a2dc48:	09000693          	li	a3,144
  a2dc4c:	09000593          	li	a1,144
  a2dc50:	00a3 4044 051f      	l.li	a0,0xa34044
  a2dc56:	679020ef          	jal	ra,a30ace <memcpy_s>
  a2dc5a:	8010                	pop	{ra},16
  a2dc5c:	f47ff06f          	j	a2dba2 <duplicate_preserve_mem>

00a2dc60 <set_exception_info>:
  a2dc60:	cd19                	beqz	a0,a2dc7e <set_exception_info+0x1e>
  a2dc62:	8018                	push	{ra},-16
  a2dc64:	862a                	mv	a2,a0
  a2dc66:	00a3 4044 051f      	l.li	a0,0xa34044
  a2dc6c:	46d1                	li	a3,20
  a2dc6e:	45d1                	li	a1,20
  a2dc70:	09050513          	addi	a0,a0,144
  a2dc74:	65b020ef          	jal	ra,a30ace <memcpy_s>
  a2dc78:	8010                	pop	{ra},16
  a2dc7a:	f29ff06f          	j	a2dba2 <duplicate_preserve_mem>
  a2dc7e:	8082                	ret

00a2dc80 <set_exception_stack_frame>:
  a2dc80:	4958                	lw	a4,20(a0)
  a2dc82:	00a3 4044 079f      	l.li	a5,0xa34044
  a2dc88:	08e7a623          	sw	a4,140(a5)
  a2dc8c:	4d18                	lw	a4,24(a0)
  a2dc8e:	cbd8                	sw	a4,20(a5)
  a2dc90:	f13ff06f          	j	a2dba2 <duplicate_preserve_mem>

00a2dc94 <uapi_partition_init>:
  a2dc94:	8048                	push	{ra,s0-s2},-16
  a2dc96:	f0eff0ef          	jal	ra,a2d3a4 <partition_get_addr>
  a2dc9a:	4118                	lw	a4,0(a0)
  a2dc9c:	4b87 a54b 079f      	l.li	a5,0x4b87a54b
  a2dca2:	06f71563          	bne	a4,a5,a2dd0c <uapi_partition_init+0x78>
  a2dca6:	842a                	mv	s0,a0
  a2dca8:	efcff0ef          	jal	ra,a2d3a4 <partition_get_addr>
  a2dcac:	892a                	mv	s2,a0
  a2dcae:	2446                	lhu	s1,12(s0)
  a2dcb0:	ef4ff0ef          	jal	ra,a2d3a4 <partition_get_addr>
  a2dcb4:	4014                	lw	a3,0(s0)
  a2dcb6:	00a06737          	lui	a4,0xa06
  a2dcba:	9c870793          	addi	a5,a4,-1592 # a059c8 <g_partition_info>
  a2dcbe:	c394                	sw	a3,0(a5)
  a2dcc0:	4054                	lw	a3,4(s0)
  a2dcc2:	9c870313          	addi	t1,a4,-1592
  a2dcc6:	c3d4                	sw	a3,4(a5)
  a2dcc8:	4414                	lw	a3,8(s0)
  a2dcca:	c794                	sw	a3,8(a5)
  a2dccc:	2474                	lbu	a3,14(s0)
  a2dcce:	c7d4                	sw	a3,12(a5)
  a2dcd0:	1006ef3b          	bltui	a3,16,a2dd0c <uapi_partition_init+0x78>
  a2dcd4:	9c870713          	addi	a4,a4,-1592
  a2dcd8:	4781                	li	a5,0
  a2dcda:	94ca                	add	s1,s1,s2
  a2dcdc:	4841                	li	a6,16
  a2dcde:	06f4861b          	addshf	a2,s1,a5,sll,3
  a2dce2:	4214                	lw	a3,0(a2)
  a2dce4:	00178593          	addi	a1,a5,1
  a2dce8:	97aa                	add	a5,a5,a0
  a2dcea:	cb14                	sw	a3,16(a4)
  a2dcec:	08b3069b          	addshf	a3,t1,a1,sll,4
  a2dcf0:	00462883          	lw	a7,4(a2) # 200004 <__heap_size+0x1e2a0c>
  a2dcf4:	2690                	lbu	a2,8(a3)
  a2dcf6:	0741                	addi	a4,a4,16
  a2dcf8:	1116261b          	orshf	a2,a2,a7,sll,8
  a2dcfc:	c690                	sw	a2,8(a3)
  a2dcfe:	37fc                	lbu	a5,15(a5)
  a2dd00:	a69c                	sb	a5,8(a3)
  a2dd02:	87ae                	mv	a5,a1
  a2dd04:	fd059de3          	bne	a1,a6,a2dcde <uapi_partition_init+0x4a>
  a2dd08:	4501                	li	a0,0
  a2dd0a:	8044                	popret	{ra,s0-s2},16
  a2dd0c:	80003537          	lui	a0,0x80003
  a2dd10:	bfed                	j	a2dd0a <uapi_partition_init+0x76>

00a2dd12 <uapi_partition_get_info>:
  a2dd12:	c1bd                	beqz	a1,a2dd78 <uapi_partition_get_info+0x66>
  a2dd14:	00a06737          	lui	a4,0xa06
  a2dd18:	9c870793          	addi	a5,a4,-1592 # a059c8 <g_partition_info>
  a2dd1c:	47d0                	lw	a2,12(a5)
  a2dd1e:	9c870713          	addi	a4,a4,-1592
  a2dd22:	4781                	li	a5,0
  a2dd24:	02c7e863          	bltu	a5,a2,a2dd54 <uapi_partition_get_info+0x42>
  a2dd28:	8138                	push	{ra,s0-s1},-32
  a2dd2a:	84aa                	mv	s1,a0
  a2dd2c:	0068                	addi	a0,sp,12
  a2dd2e:	842e                	mv	s0,a1
  a2dd30:	c602                	sw	zero,12(sp)
  a2dd32:	e7aff0ef          	jal	ra,a2d3ac <partition_get_path_map>
  a2dd36:	c919                	beqz	a0,a2dd4c <uapi_partition_get_info+0x3a>
  a2dd38:	47b2                	lw	a5,12(sp)
  a2dd3a:	cb89                	beqz	a5,a2dd4c <uapi_partition_get_info+0x3a>
  a2dd3c:	4701                	li	a4,0
  a2dd3e:	86be                	mv	a3,a5
  a2dd40:	4290                	lw	a2,0(a3)
  a2dd42:	07a1                	addi	a5,a5,8
  a2dd44:	02c49163          	bne	s1,a2,a2dd66 <uapi_partition_get_info+0x54>
  a2dd48:	42dc                	lw	a5,4(a3)
  a2dd4a:	e395                	bnez	a5,a2dd6e <uapi_partition_get_info+0x5c>
  a2dd4c:	8000 3003 051f      	l.li	a0,0x80003003
  a2dd52:	8134                	popret	{ra,s0-s1},32
  a2dd54:	0785                	addi	a5,a5,1
  a2dd56:	08f7069b          	addshf	a3,a4,a5,sll,4
  a2dd5a:	0086c803          	lbu	a6,8(a3) # 4008 <ccause+0x3046>
  a2dd5e:	02a80163          	beq	a6,a0,a2dd80 <uapi_partition_get_info+0x6e>
  a2dd62:	9f81                	uxtb	a5
  a2dd64:	b7c1                	j	a2dd24 <uapi_partition_get_info+0x12>
  a2dd66:	0705                	addi	a4,a4,1
  a2dd68:	fce51be3          	bne	a0,a4,a2dd3e <uapi_partition_get_info+0x2c>
  a2dd6c:	b7c5                	j	a2dd4c <uapi_partition_get_info+0x3a>
  a2dd6e:	4705                	li	a4,1
  a2dd70:	a018                	sb	a4,0(s0)
  a2dd72:	c05c                	sw	a5,4(s0)
  a2dd74:	4501                	li	a0,0
  a2dd76:	bff1                	j	a2dd52 <uapi_partition_get_info+0x40>
  a2dd78:	8000 3002 051f      	l.li	a0,0x80003002
  a2dd7e:	8082                	ret
  a2dd80:	00058023          	sb	zero,0(a1)
  a2dd84:	429c                	lw	a5,0(a3)
  a2dd86:	4501                	li	a0,0
  a2dd88:	c1dc                	sw	a5,4(a1)
  a2dd8a:	469c                	lw	a5,8(a3)
  a2dd8c:	83a1                	srli	a5,a5,0x8
  a2dd8e:	c59c                	sw	a5,8(a1)
  a2dd90:	8082                	ret

00a2dd92 <upg_malloc>:
  a2dd92:	8028                	push	{ra,s0},-16
  a2dd94:	842a                	mv	s0,a0
  a2dd96:	2b8d                	jal	ra,a2e308 <upg_get_func_list>
  a2dd98:	411c                	lw	a5,0(a0)
  a2dd9a:	c799                	beqz	a5,a2dda8 <upg_malloc+0x16>
  a2dd9c:	23b5                	jal	ra,a2e308 <upg_get_func_list>
  a2dd9e:	00052303          	lw	t1,0(a0) # 80003000 <_gp_+0x7f5ce7bc>
  a2dda2:	8522                	mv	a0,s0
  a2dda4:	8020                	pop	{ra,s0},16
  a2dda6:	8302                	jr	t1
  a2dda8:	4501                	li	a0,0
  a2ddaa:	8024                	popret	{ra,s0},16

00a2ddac <upg_free>:
  a2ddac:	c51d                	beqz	a0,a2ddda <upg_free+0x2e>
  a2ddae:	8038                	push	{ra,s0-s1},-16
  a2ddb0:	842a                	mv	s0,a0
  a2ddb2:	f94ff0ef          	jal	ra,a2d546 <upg_get_flash_base_addr>
  a2ddb6:	84aa                	mv	s1,a0
  a2ddb8:	f94ff0ef          	jal	ra,a2d54c <upg_get_flash_size>
  a2ddbc:	00946563          	bltu	s0,s1,a2ddc6 <upg_free+0x1a>
  a2ddc0:	94aa                	add	s1,s1,a0
  a2ddc2:	00946b63          	bltu	s0,s1,a2ddd8 <upg_free+0x2c>
  a2ddc6:	2389                	jal	ra,a2e308 <upg_get_func_list>
  a2ddc8:	415c                	lw	a5,4(a0)
  a2ddca:	c799                	beqz	a5,a2ddd8 <upg_free+0x2c>
  a2ddcc:	2b35                	jal	ra,a2e308 <upg_get_func_list>
  a2ddce:	00452303          	lw	t1,4(a0)
  a2ddd2:	8522                	mv	a0,s0
  a2ddd4:	8030                	pop	{ra,s0-s1},16
  a2ddd6:	8302                	jr	t1
  a2ddd8:	8034                	popret	{ra,s0-s1},16
  a2ddda:	8082                	ret

00a2dddc <upg_get_ctx>:
  a2dddc:	00a0 5ad8 051f      	l.li	a0,0xa05ad8
  a2dde2:	8082                	ret

00a2dde4 <upg_alloc_and_get_upgrade_flag>:
  a2dde4:	8138                	push	{ra,s0-s1},-32
  a2dde6:	84aa                	mv	s1,a0
  a2dde8:	0068                	addi	a0,sp,12
  a2ddea:	c602                	sw	zero,12(sp)
  a2ddec:	eccff0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2ddf0:	c909                	beqz	a0,a2de02 <upg_alloc_and_get_upgrade_flag+0x1e>
  a2ddf2:	842a                	mv	s0,a0
  a2ddf4:	00a3 32f8 051f      	l.li	a0,0xa332f8
  a2ddfa:	bf6fe0ef          	jal	ra,a2c1f0 <print_str>
  a2ddfe:	8522                	mv	a0,s0
  a2de00:	8134                	popret	{ra,s0-s1},32
  a2de02:	06c00513          	li	a0,108
  a2de06:	f8dff0ef          	jal	ra,a2dd92 <upg_malloc>
  a2de0a:	c088                	sw	a0,0(s1)
  a2de0c:	862a                	mv	a2,a0
  a2de0e:	e911                	bnez	a0,a2de22 <upg_alloc_and_get_upgrade_flag+0x3e>
  a2de10:	00a3 332c 051f      	l.li	a0,0xa3332c
  a2de16:	80000437          	lui	s0,0x80000
  a2de1a:	bd6fe0ef          	jal	ra,a2c1f0 <print_str>
  a2de1e:	0415                	addi	s0,s0,5 # 80000005 <_gp_+0x7f5cb7c1>
  a2de20:	bff9                	j	a2ddfe <upg_alloc_and_get_upgrade_flag+0x1a>
  a2de22:	4532                	lw	a0,12(sp)
  a2de24:	06c00593          	li	a1,108
  a2de28:	f2aff0ef          	jal	ra,a2d552 <upg_flash_read>
  a2de2c:	842a                	mv	s0,a0
  a2de2e:	d961                	beqz	a0,a2ddfe <upg_alloc_and_get_upgrade_flag+0x1a>
  a2de30:	00a3 3364 051f      	l.li	a0,0xa33364
  a2de36:	bbafe0ef          	jal	ra,a2c1f0 <print_str>
  a2de3a:	4088                	lw	a0,0(s1)
  a2de3c:	f71ff0ef          	jal	ra,a2ddac <upg_free>
  a2de40:	0004a023          	sw	zero,0(s1) # fffff000 <_gp_+0xff5ca7bc>
  a2de44:	bf6d                	j	a2ddfe <upg_alloc_and_get_upgrade_flag+0x1a>

00a2de46 <upg_get_image_info>:
  a2de46:	cd9d                	beqz	a1,a2de84 <upg_get_image_info+0x3e>
  a2de48:	8228                	push	{ra,s0},-48
  a2de4a:	842a                	mv	s0,a0
  a2de4c:	0868                	addi	a0,sp,28
  a2de4e:	c62e                	sw	a1,12(sp)
  a2de50:	ce02                	sw	zero,28(sp)
  a2de52:	e34ff0ef          	jal	ra,a2d486 <upg_get_ids_map>
  a2de56:	45b2                	lw	a1,12(sp)
  a2de58:	e509                	bnez	a0,a2de62 <upg_get_image_info+0x1c>
  a2de5a:	8000 3002 051f      	l.li	a0,0x80003002
  a2de60:	8224                	popret	{ra,s0},48
  a2de62:	47f2                	lw	a5,28(sp)
  a2de64:	dbfd                	beqz	a5,a2de5a <upg_get_image_info+0x14>
  a2de66:	4701                	li	a4,0
  a2de68:	86be                	mv	a3,a5
  a2de6a:	07a1                	addi	a5,a5,8
  a2de6c:	ff87a603          	lw	a2,-8(a5)
  a2de70:	00c41663          	bne	s0,a2,a2de7c <upg_get_image_info+0x36>
  a2de74:	22c8                	lbu	a0,4(a3)
  a2de76:	e9dff0ef          	jal	ra,a2dd12 <uapi_partition_get_info>
  a2de7a:	b7dd                	j	a2de60 <upg_get_image_info+0x1a>
  a2de7c:	0705                	addi	a4,a4,1
  a2de7e:	fee515e3          	bne	a0,a4,a2de68 <upg_get_image_info+0x22>
  a2de82:	bfe1                	j	a2de5a <upg_get_image_info+0x14>
  a2de84:	8000 3002 051f      	l.li	a0,0x80003002
  a2de8a:	8082                	ret

00a2de8c <upg_read_fota_pkg_data>:
  a2de8c:	8158                	push	{ra,s0-s3},-48
  a2de8e:	842a                	mv	s0,a0
  a2de90:	89ae                	mv	s3,a1
  a2de92:	0028                	addi	a0,sp,8
  a2de94:	006c                	addi	a1,sp,12
  a2de96:	8932                	mv	s2,a2
  a2de98:	c402                	sw	zero,8(sp)
  a2de9a:	c602                	sw	zero,12(sp)
  a2de9c:	e5eff0ef          	jal	ra,a2d4fa <upg_get_fota_partiton_area_addr>
  a2dea0:	e51d                	bnez	a0,a2dece <upg_read_fota_pkg_data+0x42>
  a2dea2:	47b2                	lw	a5,12(sp)
  a2dea4:	02f47663          	bgeu	s0,a5,a2ded0 <upg_read_fota_pkg_data+0x44>
  a2dea8:	00092483          	lw	s1,0(s2) # fffff000 <_gp_+0xff5ca7bc>
  a2deac:	c095                	beqz	s1,a2ded0 <upg_read_fota_pkg_data+0x44>
  a2deae:	00848733          	add	a4,s1,s0
  a2deb2:	00e7f463          	bgeu	a5,a4,a2deba <upg_read_fota_pkg_data+0x2e>
  a2deb6:	408784b3          	sub	s1,a5,s0
  a2deba:	4522                	lw	a0,8(sp)
  a2debc:	864e                	mv	a2,s3
  a2debe:	85a6                	mv	a1,s1
  a2dec0:	9522                	add	a0,a0,s0
  a2dec2:	c42a                	sw	a0,8(sp)
  a2dec4:	e8eff0ef          	jal	ra,a2d552 <upg_flash_read>
  a2dec8:	e119                	bnez	a0,a2dece <upg_read_fota_pkg_data+0x42>
  a2deca:	00992023          	sw	s1,0(s2)
  a2dece:	8154                	popret	{ra,s0-s3},48
  a2ded0:	8000 3042 051f      	l.li	a0,0x80003042
  a2ded6:	bfe5                	j	a2dece <upg_read_fota_pkg_data+0x42>

00a2ded8 <uapi_upg_get_storage_size>:
  a2ded8:	8128                	push	{ra,s0},-32
  a2deda:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2dee0:	239c                	lbu	a5,0(a5)
  a2dee2:	4401                	li	s0,0
  a2dee4:	cb99                	beqz	a5,a2defa <uapi_upg_get_storage_size+0x22>
  a2dee6:	006c                	addi	a1,sp,12
  a2dee8:	0028                	addi	a0,sp,8
  a2deea:	c402                	sw	zero,8(sp)
  a2deec:	c602                	sw	zero,12(sp)
  a2deee:	e0cff0ef          	jal	ra,a2d4fa <upg_get_fota_partiton_area_addr>
  a2def2:	e501                	bnez	a0,a2defa <uapi_upg_get_storage_size+0x22>
  a2def4:	47b2                	lw	a5,12(sp)
  a2def6:	7475                	lui	s0,0xffffd
  a2def8:	943e                	add	s0,s0,a5
  a2defa:	8522                	mv	a0,s0
  a2defc:	8124                	popret	{ra,s0},32

00a2defe <upg_get_partition_info>:
  a2defe:	8138                	push	{ra,s0-s1},-32
  a2df00:	c202                	sw	zero,4(sp)
  a2df02:	c402                	sw	zero,8(sp)
  a2df04:	c602                	sw	zero,12(sp)
  a2df06:	4b87 a52d 079f      	l.li	a5,0x4b87a52d
  a2df0c:	84ae                	mv	s1,a1
  a2df0e:	8432                	mv	s0,a2
  a2df10:	02f51163          	bne	a0,a5,a2df32 <upg_get_partition_info+0x34>
  a2df14:	002007b7          	lui	a5,0x200
  a2df18:	c43e                	sw	a5,8(sp)
  a2df1a:	78000793          	li	a5,1920
  a2df1e:	c63e                	sw	a5,12(sp)
  a2df20:	00414783          	lbu	a5,4(sp)
  a2df24:	ef81                	bnez	a5,a2df3c <upg_get_partition_info+0x3e>
  a2df26:	47a2                	lw	a5,8(sp)
  a2df28:	c09c                	sw	a5,0(s1)
  a2df2a:	47b2                	lw	a5,12(sp)
  a2df2c:	c01c                	sw	a5,0(s0)
  a2df2e:	4501                	li	a0,0
  a2df30:	a029                	j	a2df3a <upg_get_partition_info+0x3c>
  a2df32:	004c                	addi	a1,sp,4
  a2df34:	f13ff0ef          	jal	ra,a2de46 <upg_get_image_info>
  a2df38:	d565                	beqz	a0,a2df20 <upg_get_partition_info+0x22>
  a2df3a:	8134                	popret	{ra,s0-s1},32
  a2df3c:	0004a023          	sw	zero,0(s1)
  a2df40:	f99ff0ef          	jal	ra,a2ded8 <uapi_upg_get_storage_size>
  a2df44:	c008                	sw	a0,0(s0)
  a2df46:	b7e5                	j	a2df2e <upg_get_partition_info+0x30>

00a2df48 <upg_get_package_header>:
  a2df48:	8138                	push	{ra,s0-s1},-32
  a2df4a:	84aa                	mv	s1,a0
  a2df4c:	006c                	addi	a1,sp,12
  a2df4e:	0028                	addi	a0,sp,8
  a2df50:	c402                	sw	zero,8(sp)
  a2df52:	c602                	sw	zero,12(sp)
  a2df54:	da6ff0ef          	jal	ra,a2d4fa <upg_get_fota_partiton_area_addr>
  a2df58:	842a                	mv	s0,a0
  a2df5a:	e511                	bnez	a0,a2df66 <upg_get_package_header+0x1e>
  a2df5c:	deaff0ef          	jal	ra,a2d546 <upg_get_flash_base_addr>
  a2df60:	47a2                	lw	a5,8(sp)
  a2df62:	953e                	add	a0,a0,a5
  a2df64:	c088                	sw	a0,0(s1)
  a2df66:	8522                	mv	a0,s0
  a2df68:	8134                	popret	{ra,s0-s1},32

00a2df6a <upg_get_pkg_image_hash_table>:
  a2df6a:	8148                	push	{ra,s0-s2},-32
  a2df6c:	12052403          	lw	s0,288(a0)
  a2df70:	892e                	mv	s2,a1
  a2df72:	e019                	bnez	s0,a2df78 <upg_get_pkg_image_hash_table+0xe>
  a2df74:	20000413          	li	s0,512
  a2df78:	006c                	addi	a1,sp,12
  a2df7a:	0028                	addi	a0,sp,8
  a2df7c:	c402                	sw	zero,8(sp)
  a2df7e:	c602                	sw	zero,12(sp)
  a2df80:	d7aff0ef          	jal	ra,a2d4fa <upg_get_fota_partiton_area_addr>
  a2df84:	84aa                	mv	s1,a0
  a2df86:	e911                	bnez	a0,a2df9a <upg_get_pkg_image_hash_table+0x30>
  a2df88:	47a2                	lw	a5,8(sp)
  a2df8a:	97a2                	add	a5,a5,s0
  a2df8c:	c43e                	sw	a5,8(sp)
  a2df8e:	db8ff0ef          	jal	ra,a2d546 <upg_get_flash_base_addr>
  a2df92:	47a2                	lw	a5,8(sp)
  a2df94:	953e                	add	a0,a0,a5
  a2df96:	00a92023          	sw	a0,0(s2)
  a2df9a:	8526                	mv	a0,s1
  a2df9c:	8144                	popret	{ra,s0-s2},32

00a2df9e <upg_get_pkg_image_header>:
  a2df9e:	8148                	push	{ra,s0-s2},-32
  a2dfa0:	892a                	mv	s2,a0
  a2dfa2:	84ae                	mv	s1,a1
  a2dfa4:	0028                	addi	a0,sp,8
  a2dfa6:	006c                	addi	a1,sp,12
  a2dfa8:	c402                	sw	zero,8(sp)
  a2dfaa:	c602                	sw	zero,12(sp)
  a2dfac:	d4eff0ef          	jal	ra,a2d4fa <upg_get_fota_partiton_area_addr>
  a2dfb0:	842a                	mv	s0,a0
  a2dfb2:	e919                	bnez	a0,a2dfc8 <upg_get_pkg_image_header+0x2a>
  a2dfb4:	47a2                	lw	a5,8(sp)
  a2dfb6:	00492703          	lw	a4,4(s2)
  a2dfba:	97ba                	add	a5,a5,a4
  a2dfbc:	c43e                	sw	a5,8(sp)
  a2dfbe:	d88ff0ef          	jal	ra,a2d546 <upg_get_flash_base_addr>
  a2dfc2:	47a2                	lw	a5,8(sp)
  a2dfc4:	953e                	add	a0,a0,a5
  a2dfc6:	c088                	sw	a0,0(s1)
  a2dfc8:	8522                	mv	a0,s0
  a2dfca:	8144                	popret	{ra,s0-s2},32

00a2dfcc <upg_get_pkg_image_data>:
  a2dfcc:	8178                	push	{ra,s0-s5},-48
  a2dfce:	4544                	lw	s1,12(a0)
  a2dfd0:	8aaa                	mv	s5,a0
  a2dfd2:	842e                	mv	s0,a1
  a2dfd4:	0028                	addi	a0,sp,8
  a2dfd6:	006c                	addi	a1,sp,12
  a2dfd8:	89b2                	mv	s3,a2
  a2dfda:	8a36                	mv	s4,a3
  a2dfdc:	c402                	sw	zero,8(sp)
  a2dfde:	c602                	sw	zero,12(sp)
  a2dfe0:	d1aff0ef          	jal	ra,a2d4fa <upg_get_fota_partiton_area_addr>
  a2dfe4:	892a                	mv	s2,a0
  a2dfe6:	e121                	bnez	a0,a2e026 <upg_get_pkg_image_data+0x5a>
  a2dfe8:	00f48793          	addi	a5,s1,15
  a2dfec:	9bc1                	andi	a5,a5,-16
  a2dfee:	02f47e63          	bgeu	s0,a5,a2e02a <upg_get_pkg_image_data+0x5e>
  a2dff2:	020a0c63          	beqz	s4,a2e02a <upg_get_pkg_image_data+0x5e>
  a2dff6:	02098a63          	beqz	s3,a2e02a <upg_get_pkg_image_data+0x5e>
  a2dffa:	0009a483          	lw	s1,0(s3) # fffff000 <_gp_+0xff5ca7bc>
  a2dffe:	c495                	beqz	s1,a2e02a <upg_get_pkg_image_data+0x5e>
  a2e000:	00848733          	add	a4,s1,s0
  a2e004:	00e7f463          	bgeu	a5,a4,a2e00c <upg_get_pkg_image_data+0x40>
  a2e008:	408784b3          	sub	s1,a5,s0
  a2e00c:	47a2                	lw	a5,8(sp)
  a2e00e:	008aa503          	lw	a0,8(s5)
  a2e012:	953e                	add	a0,a0,a5
  a2e014:	942a                	add	s0,s0,a0
  a2e016:	c42a                	sw	a0,8(sp)
  a2e018:	d2eff0ef          	jal	ra,a2d546 <upg_get_flash_base_addr>
  a2e01c:	9522                	add	a0,a0,s0
  a2e01e:	00aa2023          	sw	a0,0(s4)
  a2e022:	0099a023          	sw	s1,0(s3)
  a2e026:	854a                	mv	a0,s2
  a2e028:	8174                	popret	{ra,s0-s5},48
  a2e02a:	8000 3042 091f      	l.li	s2,0x80003042
  a2e030:	bfdd                	j	a2e026 <upg_get_pkg_image_data+0x5a>

00a2e032 <upg_copy_pkg_image_data>:
  a2e032:	455c                	lw	a5,12(a0)
  a2e034:	07bd                	addi	a5,a5,15 # 20000f <__heap_size+0x1e2a17>
  a2e036:	9bc1                	andi	a5,a5,-16
  a2e038:	02f5fb63          	bgeu	a1,a5,a2e06e <upg_copy_pkg_image_data+0x3c>
  a2e03c:	ca8d                	beqz	a3,a2e06e <upg_copy_pkg_image_data+0x3c>
  a2e03e:	ca05                	beqz	a2,a2e06e <upg_copy_pkg_image_data+0x3c>
  a2e040:	00062803          	lw	a6,0(a2)
  a2e044:	02080563          	beqz	a6,a2e06e <upg_copy_pkg_image_data+0x3c>
  a2e048:	8128                	push	{ra,s0},-32
  a2e04a:	872e                	mv	a4,a1
  a2e04c:	95c2                	add	a1,a1,a6
  a2e04e:	00b7f463          	bgeu	a5,a1,a2e056 <upg_copy_pkg_image_data+0x24>
  a2e052:	40e78833          	sub	a6,a5,a4
  a2e056:	4508                	lw	a0,8(a0)
  a2e058:	8432                	mv	s0,a2
  a2e05a:	85b6                	mv	a1,a3
  a2e05c:	0070                	addi	a2,sp,12
  a2e05e:	953a                	add	a0,a0,a4
  a2e060:	c642                	sw	a6,12(sp)
  a2e062:	e2bff0ef          	jal	ra,a2de8c <upg_read_fota_pkg_data>
  a2e066:	e119                	bnez	a0,a2e06c <upg_copy_pkg_image_data+0x3a>
  a2e068:	47b2                	lw	a5,12(sp)
  a2e06a:	c01c                	sw	a5,0(s0)
  a2e06c:	8124                	popret	{ra,s0},32
  a2e06e:	8000 3042 051f      	l.li	a0,0x80003042
  a2e074:	8082                	ret

00a2e076 <upg_set_firmware_update_status>:
  a2e076:	8168                	push	{ra,s0-s4},-48
  a2e078:	cb9e 063c 079f      	l.li	a5,0xcb9e063c
  a2e07e:	02f59163          	bne	a1,a5,a2e0a0 <upg_set_firmware_update_status+0x2a>
  a2e082:	04c50513          	addi	a0,a0,76
  a2e086:	211c                	lbu	a5,0(a0)
  a2e088:	efb5                	bnez	a5,a2e104 <upg_set_firmware_update_status+0x8e>
  a2e08a:	311c                	lbu	a5,1(a0)
  a2e08c:	00150913          	addi	s2,a0,1
  a2e090:	ebe1                	bnez	a5,a2e160 <upg_set_firmware_update_status+0xea>
  a2e092:	213c                	lbu	a5,2(a0)
  a2e094:	00250913          	addi	s2,a0,2
  a2e098:	e7f1                	bnez	a5,a2e164 <upg_set_firmware_update_status+0xee>
  a2e09a:	4401                	li	s0,0
  a2e09c:	8522                	mv	a0,s0
  a2e09e:	8164                	popret	{ra,s0-s4},48
  a2e0a0:	02b5555b          	muliadd	a0,a0,a1,3
  a2e0a4:	0541                	addi	a0,a0,16
  a2e0a6:	b7c5                	j	a2e086 <upg_set_firmware_update_status+0x10>
  a2e0a8:	0441                	addi	s0,s0,16 # ffffd010 <_gp_+0xff5c87cc>
  a2e0aa:	029455db          	muliadd	a1,s0,s1,3
  a2e0ae:	00b98433          	add	s0,s3,a1
  a2e0b2:	a8a5                	j	a2e12a <upg_set_firmware_update_status+0xb4>
  a2e0b4:	010a14bb          	bnei	s4,1,a2e0c6 <upg_set_firmware_update_status+0x50>
  a2e0b8:	00094783          	lbu	a5,0(s2)
  a2e0bc:	0ff797bb          	bnei	a5,15,a2e09a <upg_set_firmware_update_status+0x24>
  a2e0c0:	00090023          	sb	zero,0(s2)
  a2e0c4:	a8b5                	j	a2e140 <upg_set_firmware_update_status+0xca>
  a2e0c6:	02fa153b          	bnei	s4,2,a2e09a <upg_set_firmware_update_status+0x24>
  a2e0ca:	448d                	li	s1,3
  a2e0cc:	413484b3          	sub	s1,s1,s3
  a2e0d0:	86a6                	mv	a3,s1
  a2e0d2:	4601                	li	a2,0
  a2e0d4:	85a6                	mv	a1,s1
  a2e0d6:	854a                	mv	a0,s2
  a2e0d8:	273020ef          	jal	ra,a30b4a <memset_s>
  a2e0dc:	a09d                	j	a2e142 <upg_set_firmware_update_status+0xcc>
  a2e0de:	02e99f3b          	bnei	s3,2,a2e09a <upg_set_firmware_update_status+0x24>
  a2e0e2:	00094783          	lbu	a5,0(s2)
  a2e0e6:	fbd5                	bnez	a5,a2e09a <upg_set_firmware_update_status+0x24>
  a2e0e8:	00a3 3418 051f      	l.li	a0,0xa33418
  a2e0ee:	902fe0ef          	jal	ra,a2c1f0 <print_str>
  a2e0f2:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2e0f8:	4735                	li	a4,13
  a2e0fa:	b3d8                	sb	a4,5(a5)
  a2e0fc:	8000 3067 041f      	l.li	s0,0x80003067
  a2e102:	bf69                	j	a2e09c <upg_set_firmware_update_status+0x26>
  a2e104:	892a                	mv	s2,a0
  a2e106:	4981                	li	s3,0
  a2e108:	0068                	addi	a0,sp,12
  a2e10a:	8a32                	mv	s4,a2
  a2e10c:	84ae                	mv	s1,a1
  a2e10e:	c602                	sw	zero,12(sp)
  a2e110:	ba8ff0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2e114:	842a                	mv	s0,a0
  a2e116:	f159                	bnez	a0,a2e09c <upg_set_firmware_update_status+0x26>
  a2e118:	cb9e 063c 079f      	l.li	a5,0xcb9e063c
  a2e11e:	4432                	lw	s0,12(sp)
  a2e120:	f8f494e3          	bne	s1,a5,a2e0a8 <upg_set_firmware_update_status+0x32>
  a2e124:	04c40413          	addi	s0,s0,76
  a2e128:	944e                	add	s0,s0,s3
  a2e12a:	f80a15e3          	bnez	s4,a2e0b4 <upg_set_firmware_update_status+0x3e>
  a2e12e:	00094703          	lbu	a4,0(s2)
  a2e132:	0ff00793          	li	a5,255
  a2e136:	f6f712e3          	bne	a4,a5,a2e09a <upg_set_firmware_update_status+0x24>
  a2e13a:	47bd                	li	a5,15
  a2e13c:	00f90023          	sb	a5,0(s2)
  a2e140:	4485                	li	s1,1
  a2e142:	8522                	mv	a0,s0
  a2e144:	4681                	li	a3,0
  a2e146:	864a                	mv	a2,s2
  a2e148:	85a6                	mv	a1,s1
  a2e14a:	cc0ff0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e14e:	842a                	mv	s0,a0
  a2e150:	d559                	beqz	a0,a2e0de <upg_set_firmware_update_status+0x68>
  a2e152:	85aa                	mv	a1,a0
  a2e154:	00a3 33e0 051f      	l.li	a0,0xa333e0
  a2e15a:	896fe0ef          	jal	ra,a2c1f0 <print_str>
  a2e15e:	bf3d                	j	a2e09c <upg_set_firmware_update_status+0x26>
  a2e160:	4985                	li	s3,1
  a2e162:	b75d                	j	a2e108 <upg_set_firmware_update_status+0x92>
  a2e164:	4989                	li	s3,2
  a2e166:	b74d                	j	a2e108 <upg_set_firmware_update_status+0x92>

00a2e168 <upg_get_image_update_status>:
  a2e168:	8128                	push	{ra,s0},-32
  a2e16a:	00a3 1d78 079f      	l.li	a5,0xa31d78
  a2e170:	239a                	lhu	a4,0(a5)
  a2e172:	23bc                	lbu	a5,2(a5)
  a2e174:	00011423          	sh	zero,8(sp)
  a2e178:	00010523          	sb	zero,10(sp)
  a2e17c:	00f10723          	sb	a5,14(sp)
  a2e180:	00e11623          	sh	a4,12(sp)
  a2e184:	cb9e 063c 079f      	l.li	a5,0xcb9e063c
  a2e18a:	04c50413          	addi	s0,a0,76
  a2e18e:	00f60563          	beq	a2,a5,a2e198 <upg_get_image_update_status+0x30>
  a2e192:	02b5545b          	muliadd	s0,a0,a1,3
  a2e196:	0441                	addi	s0,s0,16
  a2e198:	460d                	li	a2,3
  a2e19a:	002c                	addi	a1,sp,8
  a2e19c:	8522                	mv	a0,s0
  a2e19e:	b51fa0ef          	jal	ra,a28cee <memcmp>
  a2e1a2:	478d                	li	a5,3
  a2e1a4:	cd0d                	beqz	a0,a2e1de <upg_get_image_update_status+0x76>
  a2e1a6:	460d                	li	a2,3
  a2e1a8:	006c                	addi	a1,sp,12
  a2e1aa:	8522                	mv	a0,s0
  a2e1ac:	b43fa0ef          	jal	ra,a28cee <memcmp>
  a2e1b0:	4781                	li	a5,0
  a2e1b2:	c515                	beqz	a0,a2e1de <upg_get_image_update_status+0x76>
  a2e1b4:	201c                	lbu	a5,0(s0)
  a2e1b6:	4501                	li	a0,0
  a2e1b8:	eb81                	bnez	a5,a2e1c8 <upg_get_image_update_status+0x60>
  a2e1ba:	301c                	lbu	a5,1(s0)
  a2e1bc:	4505                	li	a0,1
  a2e1be:	e789                	bnez	a5,a2e1c8 <upg_get_image_update_status+0x60>
  a2e1c0:	2028                	lbu	a0,2(s0)
  a2e1c2:	00153513          	seqz	a0,a0
  a2e1c6:	0509                	addi	a0,a0,2
  a2e1c8:	942a                	add	s0,s0,a0
  a2e1ca:	2018                	lbu	a4,0(s0)
  a2e1cc:	4785                	li	a5,1
  a2e1ce:	0f07043b          	beqi	a4,15,a2e1de <upg_get_image_update_status+0x76>
  a2e1d2:	0ff00693          	li	a3,255
  a2e1d6:	4789                	li	a5,2
  a2e1d8:	00d70363          	beq	a4,a3,a2e1de <upg_get_image_update_status+0x76>
  a2e1dc:	4791                	li	a5,4
  a2e1de:	853e                	mv	a0,a5
  a2e1e0:	8124                	popret	{ra,s0},32

00a2e1e2 <upg_flash_erase_metadata_pages>:
  a2e1e2:	4501                	li	a0,0
  a2e1e4:	8082                	ret

00a2e1e6 <upg_set_temporary_result>:
  a2e1e6:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2e1ec:	b3c8                	sb	a0,5(a5)
  a2e1ee:	8082                	ret

00a2e1f0 <upg_set_update_result>:
  a2e1f0:	8118                	push	{ra},-32
  a2e1f2:	c62a                	sw	a0,12(sp)
  a2e1f4:	0028                	addi	a0,sp,8
  a2e1f6:	c402                	sw	zero,8(sp)
  a2e1f8:	ac0ff0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2e1fc:	e909                	bnez	a0,a2e20e <upg_set_update_result+0x1e>
  a2e1fe:	4522                	lw	a0,8(sp)
  a2e200:	4681                	li	a3,0
  a2e202:	0070                	addi	a2,sp,12
  a2e204:	4591                	li	a1,4
  a2e206:	05050513          	addi	a0,a0,80
  a2e20a:	c00ff0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e20e:	8114                	popret	{ra},32

00a2e210 <upg_check_image_update_complete>:
  a2e210:	8158                	push	{ra,s0-s3},-48
  a2e212:	842a                	mv	s0,a0
  a2e214:	89ae                	mv	s3,a1
  a2e216:	00011623          	sh	zero,12(sp)
  a2e21a:	00010723          	sb	zero,14(sp)
  a2e21e:	01050913          	addi	s2,a0,16
  a2e222:	4481                	li	s1,0
  a2e224:	445c                	lw	a5,12(s0)
  a2e226:	00f4ea63          	bltu	s1,a5,a2e23a <upg_check_image_update_complete+0x2a>
  a2e22a:	4505                	li	a0,1
  a2e22c:	01378f63          	beq	a5,s3,a2e24a <upg_check_image_update_complete+0x3a>
  a2e230:	04c44783          	lbu	a5,76(s0)
  a2e234:	0f07953b          	bnei	a5,15,a2e248 <upg_check_image_update_complete+0x38>
  a2e238:	a809                	j	a2e24a <upg_check_image_update_complete+0x3a>
  a2e23a:	854a                	mv	a0,s2
  a2e23c:	460d                	li	a2,3
  a2e23e:	006c                	addi	a1,sp,12
  a2e240:	aaffa0ef          	jal	ra,a28cee <memcmp>
  a2e244:	090d                	addi	s2,s2,3
  a2e246:	c119                	beqz	a0,a2e24c <upg_check_image_update_complete+0x3c>
  a2e248:	4501                	li	a0,0
  a2e24a:	8154                	popret	{ra,s0-s3},48
  a2e24c:	0485                	addi	s1,s1,1
  a2e24e:	bfd9                	j	a2e224 <upg_check_image_update_complete+0x14>

00a2e250 <upg_set_complete_flag>:
  a2e250:	8848                	push	{ra,s0-s2},-144
  a2e252:	84aa                	mv	s1,a0
  a2e254:	0068                	addi	a0,sp,12
  a2e256:	842e                	mv	s0,a1
  a2e258:	8932                	mv	s2,a2
  a2e25a:	c602                	sw	zero,12(sp)
  a2e25c:	a5cff0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2e260:	ed09                	bnez	a0,a2e27a <upg_set_complete_flag+0x2a>
  a2e262:	4532                	lw	a0,12(sp)
  a2e264:	0850                	addi	a2,sp,20
  a2e266:	06c00593          	li	a1,108
  a2e26a:	ae8ff0ef          	jal	ra,a2d552 <upg_flash_read>
  a2e26e:	c519                	beqz	a0,a2e27c <upg_set_complete_flag+0x2c>
  a2e270:	00a3 339c 051f      	l.li	a0,0xa3339c
  a2e276:	f7bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e27a:	8844                	popret	{ra,s0-s2},144
  a2e27c:	00090c63          	beqz	s2,a2e294 <upg_set_complete_flag+0x44>
  a2e280:	57e6                	lw	a5,120(sp)
  a2e282:	cb89                	beqz	a5,a2e294 <upg_set_complete_flag+0x44>
  a2e284:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2e28a:	33c8                	lbu	a0,5(a5)
  a2e28c:	f65ff0ef          	jal	ra,a2e1f0 <upg_set_update_result>
  a2e290:	4581                	li	a1,0
  a2e292:	a821                	j	a2e2aa <upg_set_complete_flag+0x5a>
  a2e294:	85a6                	mv	a1,s1
  a2e296:	0848                	addi	a0,sp,20
  a2e298:	f79ff0ef          	jal	ra,a2e210 <upg_check_image_update_complete>
  a2e29c:	e81d                	bnez	s0,a2e2d2 <upg_set_complete_flag+0x82>
  a2e29e:	e91d                	bnez	a0,a2e2d4 <upg_set_complete_flag+0x84>
  a2e2a0:	57e6                	lw	a5,120(sp)
  a2e2a2:	65c1                	lui	a1,0x10
  a2e2a4:	15fd                	addi	a1,a1,-1 # ffff <ccause+0xf03d>
  a2e2a6:	04b78d63          	beq	a5,a1,a2e300 <upg_set_complete_flag+0xb0>
  a2e2aa:	c82e                	sw	a1,16(sp)
  a2e2ac:	5a5a 5a5a 079f      	l.li	a5,0x5a5a5a5a
  a2e2b2:	4432                	lw	s0,12(sp)
  a2e2b4:	fcf583e3          	beq	a1,a5,a2e27a <upg_set_complete_flag+0x2a>
  a2e2b8:	00a3 33c0 051f      	l.li	a0,0xa333c0
  a2e2be:	f33fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e2c2:	4681                	li	a3,0
  a2e2c4:	0810                	addi	a2,sp,16
  a2e2c6:	4591                	li	a1,4
  a2e2c8:	06440513          	addi	a0,s0,100
  a2e2cc:	b3eff0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e2d0:	b76d                	j	a2e27a <upg_set_complete_flag+0x2a>
  a2e2d2:	c911                	beqz	a0,a2e2e6 <upg_set_complete_flag+0x96>
  a2e2d4:	57e6                	lw	a5,120(sp)
  a2e2d6:	cb81                	beqz	a5,a2e2e6 <upg_set_complete_flag+0x96>
  a2e2d8:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2e2de:	f455                	bnez	s0,a2e28a <upg_set_complete_flag+0x3a>
  a2e2e0:	000782a3          	sb	zero,5(a5)
  a2e2e4:	b75d                	j	a2e28a <upg_set_complete_flag+0x3a>
  a2e2e6:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2e2ec:	33dc                	lbu	a5,5(a5)
  a2e2ee:	5a5a 5a5a 059f      	l.li	a1,0x5a5a5a5a
  a2e2f4:	0de79dbb          	bnei	a5,13,a2e2aa <upg_set_complete_flag+0x5a>
  a2e2f8:	57e6                	lw	a5,120(sp)
  a2e2fa:	dbc5                	beqz	a5,a2e2aa <upg_set_complete_flag+0x5a>
  a2e2fc:	4535                	li	a0,13
  a2e2fe:	b779                	j	a2e28c <upg_set_complete_flag+0x3c>
  a2e300:	5a5a 5a5a 059f      	l.li	a1,0x5a5a5a5a
  a2e306:	b755                	j	a2e2aa <upg_set_complete_flag+0x5a>

00a2e308 <upg_get_func_list>:
  a2e308:	00a0 5ad8 051f      	l.li	a0,0xa05ad8
  a2e30e:	0521                	addi	a0,a0,8
  a2e310:	8082                	ret

00a2e312 <upg_is_inited>:
  a2e312:	00a0 5ad8 079f      	l.li	a5,0xa05ad8
  a2e318:	2388                	lbu	a0,0(a5)
  a2e31a:	8082                	ret

00a2e31c <uapi_upg_init>:
  a2e31c:	8138                	push	{ra,s0-s1},-32
  a2e31e:	00a06437          	lui	s0,0xa06
  a2e322:	ad844783          	lbu	a5,-1320(s0) # a05ad8 <g_upg_ctx>
  a2e326:	e7c9                	bnez	a5,a2e3b0 <uapi_upg_init+0x94>
  a2e328:	ad840413          	addi	s0,s0,-1320
  a2e32c:	c519                	beqz	a0,a2e33a <uapi_upg_init+0x1e>
  a2e32e:	411c                	lw	a5,0(a0)
  a2e330:	c41c                	sw	a5,8(s0)
  a2e332:	415c                	lw	a5,4(a0)
  a2e334:	c45c                	sw	a5,12(s0)
  a2e336:	451c                	lw	a5,8(a0)
  a2e338:	c81c                	sw	a5,16(s0)
  a2e33a:	47b9                	li	a5,14
  a2e33c:	b05c                	sb	a5,5(s0)
  a2e33e:	0068                	addi	a0,sp,12
  a2e340:	4785                	li	a5,1
  a2e342:	00042a23          	sw	zero,20(s0)
  a2e346:	a01c                	sb	a5,0(s0)
  a2e348:	000103a3          	sb	zero,7(sp)
  a2e34c:	c402                	sw	zero,8(sp)
  a2e34e:	c602                	sw	zero,12(sp)
  a2e350:	a95ff0ef          	jal	ra,a2dde4 <upg_alloc_and_get_upgrade_flag>
  a2e354:	448d                	li	s1,3
  a2e356:	e931                	bnez	a0,a2e3aa <uapi_upg_init+0x8e>
  a2e358:	47b2                	lw	a5,12(sp)
  a2e35a:	55aa 55aa 071f      	l.li	a4,0x55aa55aa
  a2e360:	4394                	lw	a3,0(a5)
  a2e362:	04e69063          	bne	a3,a4,a2e3a2 <uapi_upg_init+0x86>
  a2e366:	57b4                	lw	a3,104(a5)
  a2e368:	aa55 aa55 071f      	l.li	a4,0xaa55aa55
  a2e36e:	02e69a63          	bne	a3,a4,a2e3a2 <uapi_upg_init+0x86>
  a2e372:	53f8                	lw	a4,100(a5)
  a2e374:	4489                	li	s1,2
  a2e376:	e71d                	bnez	a4,a2e3a4 <uapi_upg_init+0x88>
  a2e378:	04f7c703          	lbu	a4,79(a5)
  a2e37c:	c31d                	beqz	a4,a2e3a2 <uapi_upg_init+0x86>
  a2e37e:	0028                	addi	a0,sp,8
  a2e380:	4ba4                	lw	s1,80(a5)
  a2e382:	936ff0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2e386:	ed11                	bnez	a0,a2e3a2 <uapi_upg_init+0x86>
  a2e388:	4522                	lw	a0,8(sp)
  a2e38a:	4681                	li	a3,0
  a2e38c:	00710613          	addi	a2,sp,7
  a2e390:	04f50513          	addi	a0,a0,79
  a2e394:	4585                	li	a1,1
  a2e396:	c42a                	sw	a0,8(sp)
  a2e398:	a72ff0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e39c:	009034b3          	snez	s1,s1
  a2e3a0:	c111                	beqz	a0,a2e3a4 <uapi_upg_init+0x88>
  a2e3a2:	448d                	li	s1,3
  a2e3a4:	4532                	lw	a0,12(sp)
  a2e3a6:	a07ff0ef          	jal	ra,a2ddac <upg_free>
  a2e3aa:	a044                	sb	s1,4(s0)
  a2e3ac:	4501                	li	a0,0
  a2e3ae:	8134                	popret	{ra,s0-s1},32
  a2e3b0:	8000 3041 051f      	l.li	a0,0x80003041
  a2e3b6:	bfe5                	j	a2e3ae <uapi_upg_init+0x92>

00a2e3b8 <hash_operation.isra.1.constprop.11>:
  a2e3b8:	8028                	push	{ra,s0},-16
  a2e3ba:	4108                	lw	a0,0(a0)
  a2e3bc:	02000693          	li	a3,32
  a2e3c0:	eabfb0ef          	jal	ra,a2a26a <drv_rom_cipher_sha256>
  a2e3c4:	842a                	mv	s0,a0
  a2e3c6:	c519                	beqz	a0,a2e3d4 <hash_operation.isra.1.constprop.11+0x1c>
  a2e3c8:	85aa                	mv	a1,a0
  a2e3ca:	00a3 3438 051f      	l.li	a0,0xa33438
  a2e3d0:	e21fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e3d4:	8522                	mv	a0,s0
  a2e3d6:	8024                	popret	{ra,s0},16

00a2e3d8 <verify_hash_cmp>:
  a2e3d8:	8018                	push	{ra},-16
  a2e3da:	915fa0ef          	jal	ra,a28cee <memcmp>
  a2e3de:	c901                	beqz	a0,a2e3ee <verify_hash_cmp+0x16>
  a2e3e0:	00a3 375c 051f      	l.li	a0,0xa3375c
  a2e3e6:	e0bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e3ea:	557d                	li	a0,-1
  a2e3ec:	8014                	popret	{ra},16
  a2e3ee:	4501                	li	a0,0
  a2e3f0:	bff5                	j	a2e3ec <verify_hash_cmp+0x14>

00a2e3f2 <upg_verify_hash>:
  a2e3f2:	8548                	push	{ra,s0-s2},-96
  a2e3f4:	892a                	mv	s2,a0
  a2e3f6:	84ae                	mv	s1,a1
  a2e3f8:	8432                	mv	s0,a2
  a2e3fa:	4581                	li	a1,0
  a2e3fc:	02000613          	li	a2,32
  a2e400:	1808                	addi	a0,sp,48
  a2e402:	c636                	sw	a3,12(sp)
  a2e404:	da0fa0ef          	jal	ra,a289a4 <memset>
  a2e408:	4785                	li	a5,1
  a2e40a:	1810                	addi	a2,sp,48
  a2e40c:	85a6                	mv	a1,s1
  a2e40e:	1028                	addi	a0,sp,40
  a2e410:	d44a                	sw	s2,40(sp)
  a2e412:	02f10623          	sb	a5,44(sp)
  a2e416:	fa3ff0ef          	jal	ra,a2e3b8 <hash_operation.isra.1.constprop.11>
  a2e41a:	46b2                	lw	a3,12(sp)
  a2e41c:	c909                	beqz	a0,a2e42e <upg_verify_hash+0x3c>
  a2e41e:	85aa                	mv	a1,a0
  a2e420:	00a3 36c8 051f      	l.li	a0,0xa336c8
  a2e426:	dcbfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e42a:	557d                	li	a0,-1
  a2e42c:	8544                	popret	{ra,s0-s2},96
  a2e42e:	8636                	mv	a2,a3
  a2e430:	180c                	addi	a1,sp,48
  a2e432:	8522                	mv	a0,s0
  a2e434:	fa5ff0ef          	jal	ra,a2e3d8 <verify_hash_cmp>
  a2e438:	d975                	beqz	a0,a2e42c <upg_verify_hash+0x3a>
  a2e43a:	00a3 375c 051f      	l.li	a0,0xa3375c
  a2e440:	db1fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e444:	b7dd                	j	a2e42a <upg_verify_hash+0x38>

00a2e446 <secure_authenticate>:
  a2e446:	8748                	push	{ra,s0-s2},-128
  a2e448:	57fd                	li	a5,-1
  a2e44a:	c63e                	sw	a5,12(sp)
  a2e44c:	c149                	beqz	a0,a2e4ce <secure_authenticate+0x88>
  a2e44e:	c5bd                	beqz	a1,a2e4bc <secure_authenticate+0x76>
  a2e450:	c635                	beqz	a2,a2e4bc <secure_authenticate+0x76>
  a2e452:	0884                	addi	s1,sp,80
  a2e454:	cc2a                	sw	a0,24(sp)
  a2e456:	d232                	sw	a2,36(sp)
  a2e458:	02050513          	addi	a0,a0,32
  a2e45c:	02060613          	addi	a2,a2,32
  a2e460:	842e                	mv	s0,a1
  a2e462:	02000913          	li	s2,32
  a2e466:	ce2a                	sw	a0,28(sp)
  a2e468:	d432                	sw	a2,40(sp)
  a2e46a:	02000693          	li	a3,32
  a2e46e:	05a00613          	li	a2,90
  a2e472:	02000593          	li	a1,32
  a2e476:	8526                	mv	a0,s1
  a2e478:	d04a                	sw	s2,32(sp)
  a2e47a:	d64a                	sw	s2,44(sp)
  a2e47c:	6ce020ef          	jal	ra,a30b4a <memset_s>
  a2e480:	405c                	lw	a5,4(s0)
  a2e482:	400c                	lw	a1,0(s0)
  a2e484:	8626                	mv	a2,s1
  a2e486:	c4be                	sw	a5,72(sp)
  a2e488:	00a8                	addi	a0,sp,72
  a2e48a:	4785                	li	a5,1
  a2e48c:	ca26                	sw	s1,20(sp)
  a2e48e:	c84a                	sw	s2,16(sp)
  a2e490:	04f10623          	sb	a5,76(sp)
  a2e494:	f25ff0ef          	jal	ra,a2e3b8 <hash_operation.isra.1.constprop.11>
  a2e498:	842a                	mv	s0,a0
  a2e49a:	c11d                	beqz	a0,a2e4c0 <secure_authenticate+0x7a>
  a2e49c:	85aa                	mv	a1,a0
  a2e49e:	00a3 3478 051f      	l.li	a0,0xa33478
  a2e4a4:	d4dfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e4a8:	c622                	sw	s0,12(sp)
  a2e4aa:	47b2                	lw	a5,12(sp)
  a2e4ac:	c799                	beqz	a5,a2e4ba <secure_authenticate+0x74>
  a2e4ae:	45b2                	lw	a1,12(sp)
  a2e4b0:	00a3 349c 051f      	l.li	a0,0xa3349c
  a2e4b6:	d3bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e4ba:	47b2                	lw	a5,12(sp)
  a2e4bc:	853e                	mv	a0,a5
  a2e4be:	8744                	popret	{ra,s0-s2},128
  a2e4c0:	1050                	addi	a2,sp,36
  a2e4c2:	080c                	addi	a1,sp,16
  a2e4c4:	0828                	addi	a0,sp,24
  a2e4c6:	d9dfb0ef          	jal	ra,a2a262 <drv_rom_cipher_pke_bp256r_verify>
  a2e4ca:	842a                	mv	s0,a0
  a2e4cc:	bff1                	j	a2e4a8 <secure_authenticate+0x62>
  a2e4ce:	57fd                	li	a5,-1
  a2e4d0:	b7f5                	j	a2e4bc <secure_authenticate+0x76>

00a2e4d2 <verify_fota_info.isra.4>:
  a2e4d2:	8238                	push	{ra,s0-s1},-48
  a2e4d4:	455c                	lw	a5,12(a0)
  a2e4d6:	842a                	mv	s0,a0
  a2e4d8:	0c050613          	addi	a2,a0,192
  a2e4dc:	200798bb          	bnei	a5,32,a2e4fe <verify_fota_info.isra.4+0x2c>
  a2e4e0:	00a3 3704 051f      	l.li	a0,0xa33704
  a2e4e6:	c632                	sw	a2,12(sp)
  a2e4e8:	d09fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e4ec:	4632                	lw	a2,12(sp)
  a2e4ee:	02000693          	li	a3,32
  a2e4f2:	0c000593          	li	a1,192
  a2e4f6:	8522                	mv	a0,s0
  a2e4f8:	efbff0ef          	jal	ra,a2e3f2 <upg_verify_hash>
  a2e4fc:	8234                	popret	{ra,s0-s1},48
  a2e4fe:	00a3 3730 051f      	l.li	a0,0xa33730
  a2e504:	84ae                	mv	s1,a1
  a2e506:	c632                	sw	a2,12(sp)
  a2e508:	ce9fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e50c:	4632                	lw	a2,12(sp)
  a2e50e:	0c000793          	li	a5,192
  a2e512:	082c                	addi	a1,sp,24
  a2e514:	8526                	mv	a0,s1
  a2e516:	ce22                	sw	s0,28(sp)
  a2e518:	cc3e                	sw	a5,24(sp)
  a2e51a:	f2dff0ef          	jal	ra,a2e446 <secure_authenticate>
  a2e51e:	bff9                	j	a2e4fc <verify_fota_info.isra.4+0x2a>

00a2e520 <uapi_upg_verify_file_head>:
  a2e520:	8238                	push	{ra,s0-s1},-48
  a2e522:	84aa                	mv	s1,a0
  a2e524:	defff0ef          	jal	ra,a2e312 <upg_is_inited>
  a2e528:	c169                	beqz	a0,a2e5ea <uapi_upg_verify_file_head+0xca>
  a2e52a:	8feff0ef          	jal	ra,a2d628 <upg_get_root_public_key>
  a2e52e:	c171                	beqz	a0,a2e5f2 <uapi_upg_verify_file_head+0xd2>
  a2e530:	409c                	lw	a5,0(s1)
  a2e532:	cb8d 154e 071f      	l.li	a4,0xcb8d154e
  a2e538:	04e79263          	bne	a5,a4,a2e57c <uapi_upg_verify_file_head+0x5c>
  a2e53c:	1004a703          	lw	a4,256(s1)
  a2e540:	02f71e63          	bne	a4,a5,a2e57c <uapi_upg_verify_file_head+0x5c>
  a2e544:	44dc                	lw	a5,12(s1)
  a2e546:	0c048613          	addi	a2,s1,192
  a2e54a:	201790bb          	bnei	a5,32,a2e58c <uapi_upg_verify_file_head+0x6c>
  a2e54e:	00a3 3588 051f      	l.li	a0,0xa33588
  a2e554:	c632                	sw	a2,12(sp)
  a2e556:	c9bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e55a:	4632                	lw	a2,12(sp)
  a2e55c:	02000693          	li	a3,32
  a2e560:	0c000593          	li	a1,192
  a2e564:	8526                	mv	a0,s1
  a2e566:	e8dff0ef          	jal	ra,a2e3f2 <upg_verify_hash>
  a2e56a:	842a                	mv	s0,a0
  a2e56c:	c905                	beqz	a0,a2e59c <uapi_upg_verify_file_head+0x7c>
  a2e56e:	85aa                	mv	a1,a0
  a2e570:	00a3 35b8 051f      	l.li	a0,0xa335b8
  a2e576:	c7bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e57a:	a039                	j	a2e588 <uapi_upg_verify_file_head+0x68>
  a2e57c:	00a3 3564 051f      	l.li	a0,0xa33564
  a2e582:	c6ffd0ef          	jal	ra,a2c1f0 <print_str>
  a2e586:	547d                	li	s0,-1
  a2e588:	8522                	mv	a0,s0
  a2e58a:	8234                	popret	{ra,s0-s1},48
  a2e58c:	0c000793          	li	a5,192
  a2e590:	082c                	addi	a1,sp,24
  a2e592:	ce26                	sw	s1,28(sp)
  a2e594:	cc3e                	sw	a5,24(sp)
  a2e596:	eb1ff0ef          	jal	ra,a2e446 <secure_authenticate>
  a2e59a:	bfc1                	j	a2e56a <uapi_upg_verify_file_head+0x4a>
  a2e59c:	08048593          	addi	a1,s1,128
  a2e5a0:	10048513          	addi	a0,s1,256
  a2e5a4:	f2fff0ef          	jal	ra,a2e4d2 <verify_fota_info.isra.4>
  a2e5a8:	842a                	mv	s0,a0
  a2e5aa:	c511                	beqz	a0,a2e5b6 <uapi_upg_verify_file_head+0x96>
  a2e5ac:	85aa                	mv	a1,a0
  a2e5ae:	00a3 35e8 051f      	l.li	a0,0xa335e8
  a2e5b4:	b7c9                	j	a2e576 <uapi_upg_verify_file_head+0x56>
  a2e5b6:	8526                	mv	a0,s1
  a2e5b8:	88eff0ef          	jal	ra,a2d646 <upg_check_fota_information>
  a2e5bc:	842a                	mv	s0,a0
  a2e5be:	c511                	beqz	a0,a2e5ca <uapi_upg_verify_file_head+0xaa>
  a2e5c0:	85aa                	mv	a1,a0
  a2e5c2:	00a3 3618 051f      	l.li	a0,0xa33618
  a2e5c8:	b77d                	j	a2e576 <uapi_upg_verify_file_head+0x56>
  a2e5ca:	00a0 5afc 079f      	l.li	a5,0xa05afc
  a2e5d0:	439c                	lw	a5,0(a5)
  a2e5d2:	dbdd                	beqz	a5,a2e588 <uapi_upg_verify_file_head+0x68>
  a2e5d4:	00a0 5b00 071f      	l.li	a4,0xa05b00
  a2e5da:	4310                	lw	a2,0(a4)
  a2e5dc:	07000593          	li	a1,112
  a2e5e0:	15048513          	addi	a0,s1,336
  a2e5e4:	9782                	jalr	a5
  a2e5e6:	842a                	mv	s0,a0
  a2e5e8:	b745                	j	a2e588 <uapi_upg_verify_file_head+0x68>
  a2e5ea:	8000 3040 041f      	l.li	s0,0x80003040
  a2e5f0:	bf61                	j	a2e588 <uapi_upg_verify_file_head+0x68>
  a2e5f2:	8000 3063 041f      	l.li	s0,0x80003063
  a2e5f8:	bf41                	j	a2e588 <uapi_upg_verify_file_head+0x68>

00a2e5fa <uapi_upg_verify_file_image>:
  a2e5fa:	8148                	push	{ra,s0-s2},-32
  a2e5fc:	411c                	lw	a5,0(a0)
  a2e5fe:	464f 5451 071f      	l.li	a4,0x464f5451
  a2e604:	00e78e63          	beq	a5,a4,a2e620 <uapi_upg_verify_file_image+0x26>
  a2e608:	85be                	mv	a1,a5
  a2e60a:	00a3 3654 051f      	l.li	a0,0xa33654
  a2e610:	be1fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e614:	450d                	li	a0,3
  a2e616:	bd1ff0ef          	jal	ra,a2e1e6 <upg_set_temporary_result>
  a2e61a:	547d                	li	s0,-1
  a2e61c:	8522                	mv	a0,s0
  a2e61e:	8144                	popret	{ra,s0-s2},32
  a2e620:	86b2                	mv	a3,a2
  a2e622:	862e                	mv	a2,a1
  a2e624:	0a000593          	li	a1,160
  a2e628:	84aa                	mv	s1,a0
  a2e62a:	dc9ff0ef          	jal	ra,a2e3f2 <upg_verify_hash>
  a2e62e:	842a                	mv	s0,a0
  a2e630:	c509                	beqz	a0,a2e63a <uapi_upg_verify_file_image+0x40>
  a2e632:	450d                	li	a0,3
  a2e634:	bb3ff0ef          	jal	ra,a2e1e6 <upg_set_temporary_result>
  a2e638:	b7d5                	j	a2e61c <uapi_upg_verify_file_image+0x22>
  a2e63a:	44dc                	lw	a5,12(s1)
  a2e63c:	0034                	addi	a3,sp,8
  a2e63e:	0070                	addi	a2,sp,12
  a2e640:	07bd                	addi	a5,a5,15
  a2e642:	9bc1                	andi	a5,a5,-16
  a2e644:	4581                	li	a1,0
  a2e646:	8526                	mv	a0,s1
  a2e648:	c402                	sw	zero,8(sp)
  a2e64a:	c63e                	sw	a5,12(sp)
  a2e64c:	981ff0ef          	jal	ra,a2dfcc <upg_get_pkg_image_data>
  a2e650:	842a                	mv	s0,a0
  a2e652:	e905                	bnez	a0,a2e682 <uapi_upg_verify_file_image+0x88>
  a2e654:	4522                	lw	a0,8(sp)
  a2e656:	e901                	bnez	a0,a2e666 <uapi_upg_verify_file_image+0x6c>
  a2e658:	40cc                	lw	a1,4(s1)
  a2e65a:	00a3 3694 051f      	l.li	a0,0xa33694
  a2e660:	b91fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e664:	bf65                	j	a2e61c <uapi_upg_verify_file_image+0x22>
  a2e666:	45b2                	lw	a1,12(sp)
  a2e668:	02000693          	li	a3,32
  a2e66c:	01048613          	addi	a2,s1,16
  a2e670:	d83ff0ef          	jal	ra,a2e3f2 <upg_verify_hash>
  a2e674:	892a                	mv	s2,a0
  a2e676:	d16d                	beqz	a0,a2e658 <uapi_upg_verify_file_image+0x5e>
  a2e678:	450d                	li	a0,3
  a2e67a:	b6dff0ef          	jal	ra,a2e1e6 <upg_set_temporary_result>
  a2e67e:	844a                	mv	s0,s2
  a2e680:	bf71                	j	a2e61c <uapi_upg_verify_file_image+0x22>
  a2e682:	892a                	mv	s2,a0
  a2e684:	bfd5                	j	a2e678 <uapi_upg_verify_file_image+0x7e>

00a2e686 <uapi_upg_verify_file>:
  a2e686:	8158                	push	{ra,s0-s3},-48
  a2e688:	892a                	mv	s2,a0
  a2e68a:	c402                	sw	zero,8(sp)
  a2e68c:	c87ff0ef          	jal	ra,a2e312 <upg_is_inited>
  a2e690:	c161                	beqz	a0,a2e750 <uapi_upg_verify_file+0xca>
  a2e692:	854a                	mv	a0,s2
  a2e694:	e8dff0ef          	jal	ra,a2e520 <uapi_upg_verify_file_head>
  a2e698:	842a                	mv	s0,a0
  a2e69a:	c511                	beqz	a0,a2e6a6 <uapi_upg_verify_file+0x20>
  a2e69c:	4505                	li	a0,1
  a2e69e:	b49ff0ef          	jal	ra,a2e1e6 <upg_set_temporary_result>
  a2e6a2:	8522                	mv	a0,s0
  a2e6a4:	8154                	popret	{ra,s0-s3},48
  a2e6a6:	00a3 34cc 051f      	l.li	a0,0xa334cc
  a2e6ac:	b45fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e6b0:	002c                	addi	a1,sp,8
  a2e6b2:	854a                	mv	a0,s2
  a2e6b4:	8b7ff0ef          	jal	ra,a2df6a <upg_get_pkg_image_hash_table>
  a2e6b8:	842a                	mv	s0,a0
  a2e6ba:	e119                	bnez	a0,a2e6c0 <uapi_upg_verify_file+0x3a>
  a2e6bc:	4522                	lw	a0,8(sp)
  a2e6be:	e519                	bnez	a0,a2e6cc <uapi_upg_verify_file+0x46>
  a2e6c0:	00a3 34e8 051f      	l.li	a0,0xa334e8
  a2e6c6:	b2bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e6ca:	bfe1                	j	a2e6a2 <uapi_upg_verify_file+0x1c>
  a2e6cc:	12492583          	lw	a1,292(s2)
  a2e6d0:	02000693          	li	a3,32
  a2e6d4:	12890613          	addi	a2,s2,296
  a2e6d8:	d1bff0ef          	jal	ra,a2e3f2 <upg_verify_hash>
  a2e6dc:	842a                	mv	s0,a0
  a2e6de:	c901                	beqz	a0,a2e6ee <uapi_upg_verify_file+0x68>
  a2e6e0:	4509                	li	a0,2
  a2e6e2:	b05ff0ef          	jal	ra,a2e1e6 <upg_set_temporary_result>
  a2e6e6:	4522                	lw	a0,8(sp)
  a2e6e8:	ec4ff0ef          	jal	ra,a2ddac <upg_free>
  a2e6ec:	bf5d                	j	a2e6a2 <uapi_upg_verify_file+0x1c>
  a2e6ee:	00a3 3514 051f      	l.li	a0,0xa33514
  a2e6f4:	afdfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e6f8:	44a2                	lw	s1,8(sp)
  a2e6fa:	c602                	sw	zero,12(sp)
  a2e6fc:	4981                	li	s3,0
  a2e6fe:	04b1                	addi	s1,s1,12
  a2e700:	14892783          	lw	a5,328(s2)
  a2e704:	00f9e463          	bltu	s3,a5,a2e70c <uapi_upg_verify_file+0x86>
  a2e708:	4401                	li	s0,0
  a2e70a:	a839                	j	a2e728 <uapi_upg_verify_file+0xa2>
  a2e70c:	006c                	addi	a1,sp,12
  a2e70e:	ff448513          	addi	a0,s1,-12
  a2e712:	88dff0ef          	jal	ra,a2df9e <upg_get_pkg_image_header>
  a2e716:	842a                	mv	s0,a0
  a2e718:	e119                	bnez	a0,a2e71e <uapi_upg_verify_file+0x98>
  a2e71a:	4532                	lw	a0,12(sp)
  a2e71c:	e911                	bnez	a0,a2e730 <uapi_upg_verify_file+0xaa>
  a2e71e:	00a3 353c 051f      	l.li	a0,0xa3353c
  a2e724:	acdfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e728:	4532                	lw	a0,12(sp)
  a2e72a:	e82ff0ef          	jal	ra,a2ddac <upg_free>
  a2e72e:	bf65                	j	a2e6e6 <uapi_upg_verify_file+0x60>
  a2e730:	85a6                	mv	a1,s1
  a2e732:	4685                	li	a3,1
  a2e734:	02000613          	li	a2,32
  a2e738:	ec3ff0ef          	jal	ra,a2e5fa <uapi_upg_verify_file_image>
  a2e73c:	842a                	mv	s0,a0
  a2e73e:	02c48493          	addi	s1,s1,44
  a2e742:	f17d                	bnez	a0,a2e728 <uapi_upg_verify_file+0xa2>
  a2e744:	4532                	lw	a0,12(sp)
  a2e746:	0985                	addi	s3,s3,1
  a2e748:	e64ff0ef          	jal	ra,a2ddac <upg_free>
  a2e74c:	c602                	sw	zero,12(sp)
  a2e74e:	bf4d                	j	a2e700 <uapi_upg_verify_file+0x7a>
  a2e750:	8000 3040 041f      	l.li	s0,0x80003040
  a2e756:	b7b1                	j	a2e6a2 <uapi_upg_verify_file+0x1c>

00a2e758 <uapi_upg_reset_upgrade_flag>:
  a2e758:	8218                	push	{ra},-48
  a2e75a:	c602                	sw	zero,12(sp)
  a2e75c:	bb7ff0ef          	jal	ra,a2e312 <upg_is_inited>
  a2e760:	c13d                	beqz	a0,a2e7c6 <uapi_upg_reset_upgrade_flag+0x6e>
  a2e762:	080c                	addi	a1,sp,16
  a2e764:	0068                	addi	a0,sp,12
  a2e766:	d71fe0ef          	jal	ra,a2d4d6 <upg_get_progress_status_start_addr>
  a2e76a:	ed29                	bnez	a0,a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>
  a2e76c:	0028                	addi	a0,sp,8
  a2e76e:	d4bfe0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2e772:	e929                	bnez	a0,a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>
  a2e774:	4522                	lw	a0,8(sp)
  a2e776:	0850                	addi	a2,sp,20
  a2e778:	4591                	li	a1,4
  a2e77a:	0521                	addi	a0,a0,8
  a2e77c:	ca02                	sw	zero,20(sp)
  a2e77e:	dd5fe0ef          	jal	ra,a2d552 <upg_flash_read>
  a2e782:	e129                	bnez	a0,a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>
  a2e784:	45c2                	lw	a1,16(sp)
  a2e786:	4532                	lw	a0,12(sp)
  a2e788:	dd5fe0ef          	jal	ra,a2d55c <upg_flash_erase>
  a2e78c:	ed05                	bnez	a0,a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>
  a2e78e:	4522                	lw	a0,8(sp)
  a2e790:	4681                	li	a3,0
  a2e792:	0830                	addi	a2,sp,24
  a2e794:	4591                	li	a1,4
  a2e796:	0511                	addi	a0,a0,4
  a2e798:	cc02                	sw	zero,24(sp)
  a2e79a:	e71fe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e79e:	e11d                	bnez	a0,a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>
  a2e7a0:	4522                	lw	a0,8(sp)
  a2e7a2:	55aa 55aa 079f      	l.li	a5,0x55aa55aa
  a2e7a8:	4681                	li	a3,0
  a2e7aa:	0870                	addi	a2,sp,28
  a2e7ac:	4591                	li	a1,4
  a2e7ae:	ce3e                	sw	a5,28(sp)
  a2e7b0:	e5bfe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e7b4:	e901                	bnez	a0,a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>
  a2e7b6:	4522                	lw	a0,8(sp)
  a2e7b8:	4681                	li	a3,0
  a2e7ba:	0850                	addi	a2,sp,20
  a2e7bc:	4591                	li	a1,4
  a2e7be:	0521                	addi	a0,a0,8
  a2e7c0:	e4bfe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e7c4:	8214                	popret	{ra},48
  a2e7c6:	8000 3040 051f      	l.li	a0,0x80003040
  a2e7cc:	bfe5                	j	a2e7c4 <uapi_upg_reset_upgrade_flag+0x6c>

00a2e7ce <uapi_upg_request_upgrade>:
  a2e7ce:	8148                	push	{ra,s0-s2},-32
  a2e7d0:	892a                	mv	s2,a0
  a2e7d2:	c002                	sw	zero,0(sp)
  a2e7d4:	b3fff0ef          	jal	ra,a2e312 <upg_is_inited>
  a2e7d8:	0e050363          	beqz	a0,a2e8be <uapi_upg_request_upgrade+0xf0>
  a2e7dc:	850a                	mv	a0,sp
  a2e7de:	f6aff0ef          	jal	ra,a2df48 <upg_get_package_header>
  a2e7e2:	842a                	mv	s0,a0
  a2e7e4:	e119                	bnez	a0,a2e7ea <uapi_upg_request_upgrade+0x1c>
  a2e7e6:	4502                	lw	a0,0(sp)
  a2e7e8:	e901                	bnez	a0,a2e7f8 <uapi_upg_request_upgrade+0x2a>
  a2e7ea:	00a3 3788 051f      	l.li	a0,0xa33788
  a2e7f0:	a01fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e7f4:	8522                	mv	a0,s0
  a2e7f6:	8144                	popret	{ra,s0-s2},32
  a2e7f8:	e8fff0ef          	jal	ra,a2e686 <uapi_upg_verify_file>
  a2e7fc:	842a                	mv	s0,a0
  a2e7fe:	4502                	lw	a0,0(sp)
  a2e800:	c811                	beqz	s0,a2e814 <uapi_upg_request_upgrade+0x46>
  a2e802:	daaff0ef          	jal	ra,a2ddac <upg_free>
  a2e806:	85a2                	mv	a1,s0
  a2e808:	00a3 37ac 051f      	l.li	a0,0xa337ac
  a2e80e:	9e3fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e812:	b7cd                	j	a2e7f4 <uapi_upg_request_upgrade+0x26>
  a2e814:	c602                	sw	zero,12(sp)
  a2e816:	14852483          	lw	s1,328(a0)
  a2e81a:	1504e6bb          	bltui	s1,21,a2e834 <uapi_upg_request_upgrade+0x66>
  a2e81e:	8000 3043 041f      	l.li	s0,0x80003043
  a2e824:	4502                	lw	a0,0(sp)
  a2e826:	d86ff0ef          	jal	ra,a2ddac <upg_free>
  a2e82a:	85a2                	mv	a1,s0
  a2e82c:	00a3 37dc 051f      	l.li	a0,0xa337dc
  a2e832:	bff1                	j	a2e80e <uapi_upg_request_upgrade+0x40>
  a2e834:	006c                	addi	a1,sp,12
  a2e836:	f34ff0ef          	jal	ra,a2df6a <upg_get_pkg_image_hash_table>
  a2e83a:	842a                	mv	s0,a0
  a2e83c:	ed11                	bnez	a0,a2e858 <uapi_upg_request_upgrade+0x8a>
  a2e83e:	4532                	lw	a0,12(sp)
  a2e840:	cd01                	beqz	a0,a2e858 <uapi_upg_request_upgrade+0x8a>
  a2e842:	87aa                	mv	a5,a0
  a2e844:	2c9514db          	muliadd	s1,a0,s1,44
  a2e848:	cb9e 063c 071f      	l.li	a4,0xcb9e063c
  a2e84e:	06979163          	bne	a5,s1,a2e8b0 <uapi_upg_request_upgrade+0xe2>
  a2e852:	d5aff0ef          	jal	ra,a2ddac <upg_free>
  a2e856:	a039                	j	a2e864 <uapi_upg_request_upgrade+0x96>
  a2e858:	00a3 34e8 051f      	l.li	a0,0xa334e8
  a2e85e:	993fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e862:	f069                	bnez	s0,a2e824 <uapi_upg_request_upgrade+0x56>
  a2e864:	4502                	lw	a0,0(sp)
  a2e866:	d46ff0ef          	jal	ra,a2ddac <upg_free>
  a2e86a:	0028                	addi	a0,sp,8
  a2e86c:	c222                	sw	s0,4(sp)
  a2e86e:	c402                	sw	zero,8(sp)
  a2e870:	c49fe0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2e874:	842a                	mv	s0,a0
  a2e876:	e921                	bnez	a0,a2e8c6 <uapi_upg_request_upgrade+0xf8>
  a2e878:	4522                	lw	a0,8(sp)
  a2e87a:	4681                	li	a3,0
  a2e87c:	0050                	addi	a2,sp,4
  a2e87e:	4591                	li	a1,4
  a2e880:	0531                	addi	a0,a0,12
  a2e882:	d89fe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e886:	842a                	mv	s0,a0
  a2e888:	ed1d                	bnez	a0,a2e8c6 <uapi_upg_request_upgrade+0xf8>
  a2e88a:	4522                	lw	a0,8(sp)
  a2e88c:	aa55 aa55 079f      	l.li	a5,0xaa55aa55
  a2e892:	4681                	li	a3,0
  a2e894:	0070                	addi	a2,sp,12
  a2e896:	4591                	li	a1,4
  a2e898:	06850513          	addi	a0,a0,104
  a2e89c:	c63e                	sw	a5,12(sp)
  a2e89e:	d6dfe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2e8a2:	842a                	mv	s0,a0
  a2e8a4:	e10d                	bnez	a0,a2e8c6 <uapi_upg_request_upgrade+0xf8>
  a2e8a6:	f40907e3          	beqz	s2,a2e7f4 <uapi_upg_request_upgrade+0x26>
  a2e8aa:	c6dfe0ef          	jal	ra,a2d516 <upg_reboot>
  a2e8ae:	b799                	j	a2e7f4 <uapi_upg_request_upgrade+0x26>
  a2e8b0:	4394                	lw	a3,0(a5)
  a2e8b2:	00e68363          	beq	a3,a4,a2e8b8 <uapi_upg_request_upgrade+0xea>
  a2e8b6:	0405                	addi	s0,s0,1
  a2e8b8:	02c78793          	addi	a5,a5,44
  a2e8bc:	bf49                	j	a2e84e <uapi_upg_request_upgrade+0x80>
  a2e8be:	8000 3040 041f      	l.li	s0,0x80003040
  a2e8c4:	bf05                	j	a2e7f4 <uapi_upg_request_upgrade+0x26>
  a2e8c6:	85a2                	mv	a1,s0
  a2e8c8:	00a3 3818 051f      	l.li	a0,0xa33818
  a2e8ce:	b781                	j	a2e80e <uapi_upg_request_upgrade+0x40>

00a2e8d0 <upg_encry_and_write_pkt>:
  a2e8d0:	8158                	push	{ra,s0-s3},-48
  a2e8d2:	51f4                	lw	a3,100(a1)
  a2e8d4:	c402                	sw	zero,8(sp)
  a2e8d6:	c602                	sw	zero,12(sp)
  a2e8d8:	3c78 96e1 071f      	l.li	a4,0x3c7896e1
  a2e8de:	08e69563          	bne	a3,a4,a2e968 <upg_encry_and_write_pkt+0x98>
  a2e8e2:	892e                	mv	s2,a1
  a2e8e4:	842a                	mv	s0,a0
  a2e8e6:	85b2                	mv	a1,a2
  a2e8e8:	0028                	addi	a0,sp,8
  a2e8ea:	f11fe0ef          	jal	ra,a2d7fa <upg_process_cryto_info>
  a2e8ee:	84aa                	mv	s1,a0
  a2e8f0:	e905                	bnez	a0,a2e920 <upg_encry_and_write_pkt+0x50>
  a2e8f2:	4c5c                	lw	a5,28(s0)
  a2e8f4:	00f7f993          	andi	s3,a5,15
  a2e8f8:	9bc1                	andi	a5,a5,-16
  a2e8fa:	c63e                	sw	a5,12(sp)
  a2e8fc:	c3a1                	beqz	a5,a2e93c <upg_encry_and_write_pkt+0x6c>
  a2e8fe:	4722                	lw	a4,8(sp)
  a2e900:	4c08                	lw	a0,24(s0)
  a2e902:	864a                	mv	a2,s2
  a2e904:	40e785b3          	sub	a1,a5,a4
  a2e908:	953a                	add	a0,a0,a4
  a2e90a:	f49fe0ef          	jal	ra,a2d852 <upg_encry_fota_pkt>
  a2e90e:	892a                	mv	s2,a0
  a2e910:	c911                	beqz	a0,a2e924 <upg_encry_and_write_pkt+0x54>
  a2e912:	85aa                	mv	a1,a0
  a2e914:	00a3 3284 051f      	l.li	a0,0xa33284
  a2e91a:	8d7fd0ef          	jal	ra,a2c1f0 <print_str>
  a2e91e:	84ca                	mv	s1,s2
  a2e920:	8526                	mv	a0,s1
  a2e922:	8154                	popret	{ra,s0-s3},48
  a2e924:	4014                	lw	a3,0(s0)
  a2e926:	4c0c                	lw	a1,24(s0)
  a2e928:	4408                	lw	a0,8(s0)
  a2e92a:	4701                	li	a4,0
  a2e92c:	0070                	addi	a2,sp,12
  a2e92e:	790000ef          	jal	ra,a2f0be <upg_write_new_image_data>
  a2e932:	ed0d                	bnez	a0,a2e96c <upg_encry_and_write_pkt+0x9c>
  a2e934:	441c                	lw	a5,8(s0)
  a2e936:	4732                	lw	a4,12(sp)
  a2e938:	97ba                	add	a5,a5,a4
  a2e93a:	c41c                	sw	a5,8(s0)
  a2e93c:	02098463          	beqz	s3,a2e964 <upg_encry_and_write_pkt+0x94>
  a2e940:	4c08                	lw	a0,24(s0)
  a2e942:	4632                	lw	a2,12(sp)
  a2e944:	86ce                	mv	a3,s3
  a2e946:	6591                	lui	a1,0x4
  a2e948:	962a                	add	a2,a2,a0
  a2e94a:	1bc020ef          	jal	ra,a30b06 <memmove_s>
  a2e94e:	c901                	beqz	a0,a2e95e <upg_encry_and_write_pkt+0x8e>
  a2e950:	00a3 3848 051f      	l.li	a0,0xa33848
  a2e956:	89bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e95a:	54fd                	li	s1,-1
  a2e95c:	b7d1                	j	a2e920 <upg_encry_and_write_pkt+0x50>
  a2e95e:	01342e23          	sw	s3,28(s0)
  a2e962:	bf7d                	j	a2e920 <upg_encry_and_write_pkt+0x50>
  a2e964:	00042e23          	sw	zero,28(s0)
  a2e968:	4481                	li	s1,0
  a2e96a:	bf5d                	j	a2e920 <upg_encry_and_write_pkt+0x50>
  a2e96c:	4485                	li	s1,1
  a2e96e:	bf4d                	j	a2e920 <upg_encry_and_write_pkt+0x50>

00a2e970 <upg_lzma_alloc>:
  a2e970:	8128                	push	{ra,s0},-32
  a2e972:	852e                	mv	a0,a1
  a2e974:	c62e                	sw	a1,12(sp)
  a2e976:	c1cff0ef          	jal	ra,a2dd92 <upg_malloc>
  a2e97a:	842a                	mv	s0,a0
  a2e97c:	45b2                	lw	a1,12(sp)
  a2e97e:	e511                	bnez	a0,a2e98a <upg_lzma_alloc+0x1a>
  a2e980:	00a3 3878 051f      	l.li	a0,0xa33878
  a2e986:	86bfd0ef          	jal	ra,a2c1f0 <print_str>
  a2e98a:	8522                	mv	a0,s0
  a2e98c:	8124                	popret	{ra,s0},32

00a2e98e <upg_lzma_free>:
  a2e98e:	c581                	beqz	a1,a2e996 <upg_lzma_free+0x8>
  a2e990:	852e                	mv	a0,a1
  a2e992:	c1aff06f          	j	a2ddac <upg_free>
  a2e996:	8082                	ret

00a2e998 <upg_lzma_init_buf>:
  a2e998:	8128                	push	{ra,s0},-32
  a2e99a:	842a                	mv	s0,a0
  a2e99c:	02052023          	sw	zero,32(a0)
  a2e9a0:	00052e23          	sw	zero,28(a0)
  a2e9a4:	6585                	lui	a1,0x1
  a2e9a6:	0028                	addi	a0,sp,8
  a2e9a8:	fc9ff0ef          	jal	ra,a2e970 <upg_lzma_alloc>
  a2e9ac:	c848                	sw	a0,20(s0)
  a2e9ae:	cd11                	beqz	a0,a2e9ca <upg_lzma_init_buf+0x32>
  a2e9b0:	6591                	lui	a1,0x4
  a2e9b2:	0028                	addi	a0,sp,8
  a2e9b4:	fbdff0ef          	jal	ra,a2e970 <upg_lzma_alloc>
  a2e9b8:	cc08                	sw	a0,24(s0)
  a2e9ba:	4781                	li	a5,0
  a2e9bc:	e911                	bnez	a0,a2e9d0 <upg_lzma_init_buf+0x38>
  a2e9be:	484c                	lw	a1,20(s0)
  a2e9c0:	0028                	addi	a0,sp,8
  a2e9c2:	fcdff0ef          	jal	ra,a2e98e <upg_lzma_free>
  a2e9c6:	00042a23          	sw	zero,20(s0)
  a2e9ca:	800007b7          	lui	a5,0x80000
  a2e9ce:	0795                	addi	a5,a5,5 # 80000005 <_gp_+0x7f5cb7c1>
  a2e9d0:	853e                	mv	a0,a5
  a2e9d2:	8124                	popret	{ra,s0},32

00a2e9d4 <upg_lzma_init>:
  a2e9d4:	8168                	push	{ra,s0-s4},-48
  a2e9d6:	00a2 e970 079f      	l.li	a5,0xa2e970
  a2e9dc:	c43e                	sw	a5,8(sp)
  a2e9de:	00a2 e98e 079f      	l.li	a5,0xa2e98e
  a2e9e4:	00052823          	sw	zero,16(a0)
  a2e9e8:	00052423          	sw	zero,8(a0)
  a2e9ec:	c63e                	sw	a5,12(sp)
  a2e9ee:	0506f3bb          	bgeui	a3,5,a2e9fc <upg_lzma_init+0x28>
  a2e9f2:	8000 3042 041f      	l.li	s0,0x80003042
  a2e9f8:	8522                	mv	a0,s0
  a2e9fa:	8164                	popret	{ra,s0-s4},48
  a2e9fc:	89b2                	mv	s3,a2
  a2e9fe:	8436                	mv	s0,a3
  a2ea00:	8a2e                	mv	s4,a1
  a2ea02:	0034                	addi	a3,sp,8
  a2ea04:	4615                	li	a2,5
  a2ea06:	85ce                	mv	a1,s3
  a2ea08:	84aa                	mv	s1,a0
  a2ea0a:	03c020ef          	jal	ra,a30a46 <LzmaDec_AllocateProbs>
  a2ea0e:	c939                	beqz	a0,a2ea64 <upg_lzma_init+0x90>
  a2ea10:	842a                	mv	s0,a0
  a2ea12:	b7dd                	j	a2e9f8 <upg_lzma_init+0x24>
  a2ea14:	00f98733          	add	a4,s3,a5
  a2ea18:	3358                	lbu	a4,5(a4)
  a2ea1a:	00379613          	slli	a2,a5,0x3
  a2ea1e:	0785                	addi	a5,a5,1
  a2ea20:	00c71733          	sll	a4,a4,a2
  a2ea24:	993a                	add	s2,s2,a4
  a2ea26:	fed7e7e3          	bltu	a5,a3,a2ea14 <upg_lzma_init+0x40>
  a2ea2a:	40c0                	lw	s0,4(s1)
  a2ea2c:	00897363          	bgeu	s2,s0,a2ea32 <upg_lzma_init+0x5e>
  a2ea30:	844a                	mv	s0,s2
  a2ea32:	d061                	beqz	s0,a2e9f2 <upg_lzma_init+0x1e>
  a2ea34:	85a2                	mv	a1,s0
  a2ea36:	0028                	addi	a0,sp,8
  a2ea38:	f39ff0ef          	jal	ra,a2e970 <upg_lzma_alloc>
  a2ea3c:	c888                	sw	a0,16(s1)
  a2ea3e:	cd19                	beqz	a0,a2ea5c <upg_lzma_init+0x88>
  a2ea40:	c8c0                	sw	s0,20(s1)
  a2ea42:	012a2823          	sw	s2,16(s4)
  a2ea46:	8552                	mv	a0,s4
  a2ea48:	f51ff0ef          	jal	ra,a2e998 <upg_lzma_init_buf>
  a2ea4c:	842a                	mv	s0,a0
  a2ea4e:	c105                	beqz	a0,a2ea6e <upg_lzma_init+0x9a>
  a2ea50:	488c                	lw	a1,16(s1)
  a2ea52:	0028                	addi	a0,sp,8
  a2ea54:	f3bff0ef          	jal	ra,a2e98e <upg_lzma_free>
  a2ea58:	0004a823          	sw	zero,16(s1)
  a2ea5c:	80000437          	lui	s0,0x80000
  a2ea60:	0415                	addi	s0,s0,5 # 80000005 <_gp_+0x7f5cb7c1>
  a2ea62:	bf59                	j	a2e9f8 <upg_lzma_init+0x24>
  a2ea64:	4781                	li	a5,0
  a2ea66:	4901                	li	s2,0
  a2ea68:	ffb40693          	addi	a3,s0,-5
  a2ea6c:	bf6d                	j	a2ea26 <upg_lzma_init+0x52>
  a2ea6e:	8526                	mv	a0,s1
  a2ea70:	351010ef          	jal	ra,a305c0 <LzmaDec_Init>
  a2ea74:	b751                	j	a2e9f8 <upg_lzma_init+0x24>

00a2ea76 <upg_lzma_deinit>:
  a2ea76:	8138                	push	{ra,s0-s1},-32
  a2ea78:	842e                	mv	s0,a1
  a2ea7a:	490c                	lw	a1,16(a0)
  a2ea7c:	00a2 e970 079f      	l.li	a5,0xa2e970
  a2ea82:	84aa                	mv	s1,a0
  a2ea84:	c43e                	sw	a5,8(sp)
  a2ea86:	0028                	addi	a0,sp,8
  a2ea88:	00a2 e98e 079f      	l.li	a5,0xa2e98e
  a2ea8e:	c63e                	sw	a5,12(sp)
  a2ea90:	effff0ef          	jal	ra,a2e98e <upg_lzma_free>
  a2ea94:	002c                	addi	a1,sp,8
  a2ea96:	8526                	mv	a0,s1
  a2ea98:	0004a823          	sw	zero,16(s1)
  a2ea9c:	6ff010ef          	jal	ra,a3099a <LzmaDec_FreeProbs>
  a2eaa0:	484c                	lw	a1,20(s0)
  a2eaa2:	0028                	addi	a0,sp,8
  a2eaa4:	eebff0ef          	jal	ra,a2e98e <upg_lzma_free>
  a2eaa8:	4c0c                	lw	a1,24(s0)
  a2eaaa:	00042a23          	sw	zero,20(s0)
  a2eaae:	0028                	addi	a0,sp,8
  a2eab0:	edfff0ef          	jal	ra,a2e98e <upg_lzma_free>
  a2eab4:	00042c23          	sw	zero,24(s0)
  a2eab8:	8134                	popret	{ra,s0-s1},32

00a2eaba <upg_lzma_write_image>:
  a2eaba:	8028                	push	{ra,s0},-16
  a2eabc:	51f8                	lw	a4,100(a1)
  a2eabe:	3c78 96e1 079f      	l.li	a5,0x3c7896e1
  a2eac4:	02f70263          	beq	a4,a5,a2eae8 <upg_lzma_write_image+0x2e>
  a2eac8:	842a                	mv	s0,a0
  a2eaca:	4114                	lw	a3,0(a0)
  a2eacc:	01c50613          	addi	a2,a0,28
  a2ead0:	4d0c                	lw	a1,24(a0)
  a2ead2:	4508                	lw	a0,8(a0)
  a2ead4:	4701                	li	a4,0
  a2ead6:	23e5                	jal	ra,a2f0be <upg_write_new_image_data>
  a2ead8:	e11d                	bnez	a0,a2eafe <upg_lzma_write_image+0x44>
  a2eada:	441c                	lw	a5,8(s0)
  a2eadc:	4c58                	lw	a4,28(s0)
  a2eade:	00042e23          	sw	zero,28(s0)
  a2eae2:	97ba                	add	a5,a5,a4
  a2eae4:	c41c                	sw	a5,8(s0)
  a2eae6:	8024                	popret	{ra,s0},16
  a2eae8:	de9ff0ef          	jal	ra,a2e8d0 <upg_encry_and_write_pkt>
  a2eaec:	dd6d                	beqz	a0,a2eae6 <upg_lzma_write_image+0x2c>
  a2eaee:	85aa                	mv	a1,a0
  a2eaf0:	00a3 3960 051f      	l.li	a0,0xa33960
  a2eaf6:	efafd0ef          	jal	ra,a2c1f0 <print_str>
  a2eafa:	557d                	li	a0,-1
  a2eafc:	b7ed                	j	a2eae6 <upg_lzma_write_image+0x2c>
  a2eafe:	4505                	li	a0,1
  a2eb00:	b7dd                	j	a2eae6 <upg_lzma_write_image+0x2c>

00a2eb02 <upg_lzma_decode_to_midbuf>:
  a2eb02:	81a8                	push	{ra,s0-s8},-64
  a2eb04:	0205a983          	lw	s3,32(a1) # 4020 <ccause+0x305e>
  a2eb08:	8aaa                	mv	s5,a0
  a2eb0a:	84ae                	mv	s1,a1
  a2eb0c:	8b32                	mv	s6,a2
  a2eb0e:	8bb6                	mv	s7,a3
  a2eb10:	000103a3          	sb	zero,7(sp)
  a2eb14:	4901                	li	s2,0
  a2eb16:	6a11                	lui	s4,0x4
  a2eb18:	6c05                	lui	s8,0x1
  a2eb1a:	01396463          	bltu	s2,s3,a2eb22 <upg_lzma_decode_to_midbuf+0x20>
  a2eb1e:	4501                	li	a0,0
  a2eb20:	a041                	j	a2eba0 <upg_lzma_decode_to_midbuf+0x9e>
  a2eb22:	4898                	lw	a4,16(s1)
  a2eb24:	412987b3          	sub	a5,s3,s2
  a2eb28:	c43e                	sw	a5,8(sp)
  a2eb2a:	c652                	sw	s4,12(sp)
  a2eb2c:	4781                	li	a5,0
  a2eb2e:	01477463          	bgeu	a4,s4,a2eb36 <upg_lzma_decode_to_midbuf+0x34>
  a2eb32:	c63a                	sw	a4,12(sp)
  a2eb34:	4785                	li	a5,1
  a2eb36:	4c88                	lw	a0,24(s1)
  a2eb38:	48d4                	lw	a3,20(s1)
  a2eb3a:	4ccc                	lw	a1,28(s1)
  a2eb3c:	00710813          	addi	a6,sp,7
  a2eb40:	0038                	addi	a4,sp,8
  a2eb42:	95aa                	add	a1,a1,a0
  a2eb44:	96ca                	add	a3,a3,s2
  a2eb46:	0070                	addi	a2,sp,12
  a2eb48:	8556                	mv	a0,s5
  a2eb4a:	5bd010ef          	jal	ra,a30906 <LzmaDec_DecodeToBuf>
  a2eb4e:	842a                	mv	s0,a0
  a2eb50:	c909                	beqz	a0,a2eb62 <upg_lzma_decode_to_midbuf+0x60>
  a2eb52:	85aa                	mv	a1,a0
  a2eb54:	00a3 390c 051f      	l.li	a0,0xa3390c
  a2eb5a:	e96fd0ef          	jal	ra,a2c1f0 <print_str>
  a2eb5e:	8522                	mv	a0,s0
  a2eb60:	a081                	j	a2eba0 <upg_lzma_decode_to_midbuf+0x9e>
  a2eb62:	47a2                	lw	a5,8(sp)
  a2eb64:	4532                	lw	a0,12(sp)
  a2eb66:	993e                	add	s2,s2,a5
  a2eb68:	489c                	lw	a5,16(s1)
  a2eb6a:	8f89                	sub	a5,a5,a0
  a2eb6c:	c89c                	sw	a5,16(s1)
  a2eb6e:	4cdc                	lw	a5,28(s1)
  a2eb70:	97aa                	add	a5,a5,a0
  a2eb72:	ccdc                	sw	a5,28(s1)
  a2eb74:	2321                	jal	ra,a2f07c <upg_calculate_and_notify_process>
  a2eb76:	4cdc                	lw	a5,28(s1)
  a2eb78:	40fa07b3          	sub	a5,s4,a5
  a2eb7c:	0187e663          	bltu	a5,s8,a2eb88 <upg_lzma_decode_to_midbuf+0x86>
  a2eb80:	489c                	lw	a5,16(s1)
  a2eb82:	c399                	beqz	a5,a2eb88 <upg_lzma_decode_to_midbuf+0x86>
  a2eb84:	01299f63          	bne	s3,s2,a2eba2 <upg_lzma_decode_to_midbuf+0xa0>
  a2eb88:	865e                	mv	a2,s7
  a2eb8a:	85da                	mv	a1,s6
  a2eb8c:	8526                	mv	a0,s1
  a2eb8e:	f2dff0ef          	jal	ra,a2eaba <upg_lzma_write_image>
  a2eb92:	c901                	beqz	a0,a2eba2 <upg_lzma_decode_to_midbuf+0xa0>
  a2eb94:	00a3 393c 051f      	l.li	a0,0xa3393c
  a2eb9a:	e56fd0ef          	jal	ra,a2c1f0 <print_str>
  a2eb9e:	557d                	li	a0,-1
  a2eba0:	81a4                	popret	{ra,s0-s8},64
  a2eba2:	4722                	lw	a4,8(sp)
  a2eba4:	489c                	lw	a5,16(s1)
  a2eba6:	e319                	bnez	a4,a2ebac <upg_lzma_decode_to_midbuf+0xaa>
  a2eba8:	4732                	lw	a4,12(sp)
  a2ebaa:	c319                	beqz	a4,a2ebb0 <upg_lzma_decode_to_midbuf+0xae>
  a2ebac:	dbcd                	beqz	a5,a2eb5e <upg_lzma_decode_to_midbuf+0x5c>
  a2ebae:	b7b5                	j	a2eb1a <upg_lzma_decode_to_midbuf+0x18>
  a2ebb0:	d7dd                	beqz	a5,a2eb5e <upg_lzma_decode_to_midbuf+0x5c>
  a2ebb2:	00714403          	lbu	s0,7(sp)
  a2ebb6:	147d                	addi	s0,s0,-1
  a2ebb8:	00803433          	snez	s0,s0
  a2ebbc:	b74d                	j	a2eb5e <upg_lzma_decode_to_midbuf+0x5c>

00a2ebbe <upg_lzma_decode>:
  a2ebbe:	8168                	push	{ra,s0-s4},-48
  a2ebc0:	4785                	li	a5,1
  a2ebc2:	89aa                	mv	s3,a0
  a2ebc4:	84ae                	mv	s1,a1
  a2ebc6:	8932                	mv	s2,a2
  a2ebc8:	00f105a3          	sb	a5,11(sp)
  a2ebcc:	6a05                	lui	s4,0x1
  a2ebce:	44c0                	lw	s0,12(s1)
  a2ebd0:	c015                	beqz	s0,a2ebf4 <upg_lzma_decode+0x36>
  a2ebd2:	008a7363          	bgeu	s4,s0,a2ebd8 <upg_lzma_decode+0x1a>
  a2ebd6:	6405                	lui	s0,0x1
  a2ebd8:	48cc                	lw	a1,20(s1)
  a2ebda:	40c8                	lw	a0,4(s1)
  a2ebdc:	0070                	addi	a2,sp,12
  a2ebde:	c622                	sw	s0,12(sp)
  a2ebe0:	aacff0ef          	jal	ra,a2de8c <upg_read_fota_pkg_data>
  a2ebe4:	c911                	beqz	a0,a2ebf8 <upg_lzma_decode+0x3a>
  a2ebe6:	4405                	li	s0,1
  a2ebe8:	85a2                	mv	a1,s0
  a2ebea:	00a3 38a8 051f      	l.li	a0,0xa338a8
  a2ebf0:	e00fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ebf4:	8522                	mv	a0,s0
  a2ebf6:	8164                	popret	{ra,s0-s4},48
  a2ebf8:	45b2                	lw	a1,12(sp)
  a2ebfa:	48c8                	lw	a0,20(s1)
  a2ebfc:	864a                	mv	a2,s2
  a2ebfe:	c15fe0ef          	jal	ra,a2d812 <upg_decry_fota_pkt>
  a2ec02:	e51d                	bnez	a0,a2ec30 <upg_lzma_decode+0x72>
  a2ec04:	4732                	lw	a4,12(sp)
  a2ec06:	40dc                	lw	a5,4(s1)
  a2ec08:	00b10693          	addi	a3,sp,11
  a2ec0c:	d098                	sw	a4,32(s1)
  a2ec0e:	97ba                	add	a5,a5,a4
  a2ec10:	c0dc                	sw	a5,4(s1)
  a2ec12:	44dc                	lw	a5,12(s1)
  a2ec14:	864a                	mv	a2,s2
  a2ec16:	85a6                	mv	a1,s1
  a2ec18:	8f99                	sub	a5,a5,a4
  a2ec1a:	c4dc                	sw	a5,12(s1)
  a2ec1c:	854e                	mv	a0,s3
  a2ec1e:	ee5ff0ef          	jal	ra,a2eb02 <upg_lzma_decode_to_midbuf>
  a2ec22:	842a                	mv	s0,a0
  a2ec24:	c901                	beqz	a0,a2ec34 <upg_lzma_decode+0x76>
  a2ec26:	85aa                	mv	a1,a0
  a2ec28:	00a3 38dc 051f      	l.li	a0,0xa338dc
  a2ec2e:	b7c9                	j	a2ebf0 <upg_lzma_decode+0x32>
  a2ec30:	547d                	li	s0,-1
  a2ec32:	bf5d                	j	a2ebe8 <upg_lzma_decode+0x2a>
  a2ec34:	90ffe0ef          	jal	ra,a2d542 <upg_watchdog_kick>
  a2ec38:	bf59                	j	a2ebce <upg_lzma_decode+0x10>

00a2ec3a <upg_check_first_entry>:
  a2ec3a:	8148                	push	{ra,s0-s2},-32
  a2ec3c:	00a3 1d7c 079f      	l.li	a5,0xa31d7c
  a2ec42:	239a                	lhu	a4,0(a5)
  a2ec44:	23bc                	lbu	a5,2(a5)
  a2ec46:	892a                	mv	s2,a0
  a2ec48:	00e11623          	sh	a4,12(sp)
  a2ec4c:	00f10723          	sb	a5,14(sp)
  a2ec50:	01050493          	addi	s1,a0,16
  a2ec54:	4401                	li	s0,0
  a2ec56:	00c92783          	lw	a5,12(s2)
  a2ec5a:	00f46463          	bltu	s0,a5,a2ec62 <upg_check_first_entry+0x28>
  a2ec5e:	4505                	li	a0,1
  a2ec60:	8144                	popret	{ra,s0-s2},32
  a2ec62:	8526                	mv	a0,s1
  a2ec64:	460d                	li	a2,3
  a2ec66:	006c                	addi	a1,sp,12
  a2ec68:	886fa0ef          	jal	ra,a28cee <memcmp>
  a2ec6c:	048d                	addi	s1,s1,3
  a2ec6e:	e119                	bnez	a0,a2ec74 <upg_check_first_entry+0x3a>
  a2ec70:	0405                	addi	s0,s0,1 # 1001 <ccause+0x3f>
  a2ec72:	b7d5                	j	a2ec56 <upg_check_first_entry+0x1c>
  a2ec74:	4501                	li	a0,0
  a2ec76:	b7ed                	j	a2ec60 <upg_check_first_entry+0x26>

00a2ec78 <uapi_upg_start>:
  a2ec78:	82d8                	push	{ra,s0-s11},-96
  a2ec7a:	c602                	sw	zero,12(sp)
  a2ec7c:	c802                	sw	zero,16(sp)
  a2ec7e:	e94ff0ef          	jal	ra,a2e312 <upg_is_inited>
  a2ec82:	3e050063          	beqz	a0,a2f062 <uapi_upg_start+0x3ea>
  a2ec86:	84aa                	mv	s1,a0
  a2ec88:	0068                	addi	a0,sp,12
  a2ec8a:	95aff0ef          	jal	ra,a2dde4 <upg_alloc_and_get_upgrade_flag>
  a2ec8e:	892a                	mv	s2,a0
  a2ec90:	4501                	li	a0,0
  a2ec92:	02091b63          	bnez	s2,a2ecc8 <uapi_upg_start+0x50>
  a2ec96:	47b2                	lw	a5,12(sp)
  a2ec98:	cb85                	beqz	a5,a2ecc8 <uapi_upg_start+0x50>
  a2ec9a:	4394                	lw	a3,0(a5)
  a2ec9c:	55aa 55aa 071f      	l.li	a4,0x55aa55aa
  a2eca2:	00e69a63          	bne	a3,a4,a2ecb6 <uapi_upg_start+0x3e>
  a2eca6:	57b4                	lw	a3,104(a5)
  a2eca8:	aa55 aa55 071f      	l.li	a4,0xaa55aa55
  a2ecae:	00e69463          	bne	a3,a4,a2ecb6 <uapi_upg_start+0x3e>
  a2ecb2:	53fc                	lw	a5,100(a5)
  a2ecb4:	e795                	bnez	a5,a2ece0 <uapi_upg_start+0x68>
  a2ecb6:	00a3 3990 051f      	l.li	a0,0xa33990
  a2ecbc:	d34fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ecc0:	4501                	li	a0,0
  a2ecc2:	8000 3047 091f      	l.li	s2,0x80003047
  a2ecc8:	8626                	mv	a2,s1
  a2ecca:	85ca                	mv	a1,s2
  a2eccc:	d84ff0ef          	jal	ra,a2e250 <upg_set_complete_flag>
  a2ecd0:	4532                	lw	a0,12(sp)
  a2ecd2:	8daff0ef          	jal	ra,a2ddac <upg_free>
  a2ecd6:	4542                	lw	a0,16(sp)
  a2ecd8:	8d4ff0ef          	jal	ra,a2ddac <upg_free>
  a2ecdc:	854a                	mv	a0,s2
  a2ecde:	82d4                	popret	{ra,s0-s11},96
  a2ece0:	0808                	addi	a0,sp,16
  a2ece2:	a66ff0ef          	jal	ra,a2df48 <upg_get_package_header>
  a2ece6:	892a                	mv	s2,a0
  a2ece8:	e119                	bnez	a0,a2ecee <uapi_upg_start+0x76>
  a2ecea:	47c2                	lw	a5,16(sp)
  a2ecec:	eb81                	bnez	a5,a2ecfc <uapi_upg_start+0x84>
  a2ecee:	00a3 3788 051f      	l.li	a0,0xa33788
  a2ecf4:	cfcfd0ef          	jal	ra,a2c1f0 <print_str>
  a2ecf8:	4501                	li	a0,0
  a2ecfa:	b7f9                	j	a2ecc8 <uapi_upg_start+0x50>
  a2ecfc:	4532                	lw	a0,12(sp)
  a2ecfe:	f3dff0ef          	jal	ra,a2ec3a <upg_check_first_entry>
  a2ed02:	842a                	mv	s0,a0
  a2ed04:	ed05                	bnez	a0,a2ed3c <uapi_upg_start+0xc4>
  a2ed06:	8d6ff0ef          	jal	ra,a2dddc <upg_get_ctx>
  a2ed0a:	49c2                	lw	s3,16(sp)
  a2ed0c:	cc02                	sw	zero,24(sp)
  a2ed0e:	00052e23          	sw	zero,28(a0)
  a2ed12:	02052023          	sw	zero,32(a0)
  a2ed16:	842a                	mv	s0,a0
  a2ed18:	082c                	addi	a1,sp,24
  a2ed1a:	854e                	mv	a0,s3
  a2ed1c:	4b32                	lw	s6,12(sp)
  a2ed1e:	a4cff0ef          	jal	ra,a2df6a <upg_get_pkg_image_hash_table>
  a2ed22:	892a                	mv	s2,a0
  a2ed24:	c11d                	beqz	a0,a2ed4a <uapi_upg_start+0xd2>
  a2ed26:	00a3 34e8 051f      	l.li	a0,0xa334e8
  a2ed2c:	cc4fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ed30:	04090563          	beqz	s2,a2ed7a <uapi_upg_start+0x102>
  a2ed34:	4505                	li	a0,1
  a2ed36:	cb0ff0ef          	jal	ra,a2e1e6 <upg_set_temporary_result>
  a2ed3a:	bf7d                	j	a2ecf8 <uapi_upg_start+0x80>
  a2ed3c:	4542                	lw	a0,16(sp)
  a2ed3e:	949ff0ef          	jal	ra,a2e686 <uapi_upg_verify_file>
  a2ed42:	892a                	mv	s2,a0
  a2ed44:	d169                	beqz	a0,a2ed06 <uapi_upg_start+0x8e>
  a2ed46:	84a2                	mv	s1,s0
  a2ed48:	bf45                	j	a2ecf8 <uapi_upg_start+0x80>
  a2ed4a:	47e2                	lw	a5,24(sp)
  a2ed4c:	dfe9                	beqz	a5,a2ed26 <uapi_upg_start+0xae>
  a2ed4e:	1489aa83          	lw	s5,328(s3)
  a2ed52:	4a01                	li	s4,0
  a2ed54:	4981                	li	s3,0
  a2ed56:	02c00b93          	li	s7,44
  a2ed5a:	cb9e 063c 0c1f      	l.li	s8,0xcb9e063c
  a2ed60:	4c8d                	li	s9,3
  a2ed62:	4562                	lw	a0,24(sp)
  a2ed64:	075a4863          	blt	s4,s5,a2edd4 <uapi_upg_start+0x15c>
  a2ed68:	844ff0ef          	jal	ra,a2ddac <upg_free>
  a2ed6c:	5010                	lw	a2,32(s0)
  a2ed6e:	4c4c                	lw	a1,28(s0)
  a2ed70:	00a3 39b0 051f      	l.li	a0,0xa339b0
  a2ed76:	c7afd0ef          	jal	ra,a2c1f0 <print_str>
  a2ed7a:	44c2                	lw	s1,16(sp)
  a2ed7c:	4432                	lw	s0,12(sp)
  a2ed7e:	00a3 39e4 051f      	l.li	a0,0xa339e4
  a2ed84:	1484aa83          	lw	s5,328(s1)
  a2ed88:	ca02                	sw	zero,20(sp)
  a2ed8a:	85d6                	mv	a1,s5
  a2ed8c:	c64fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ed90:	444c                	lw	a1,12(s0)
  a2ed92:	00a3 3a08 051f      	l.li	a0,0xa33a08
  a2ed98:	c58fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ed9c:	445c                	lw	a5,12(s0)
  a2ed9e:	00fa8663          	beq	s5,a5,a2edaa <uapi_upg_start+0x132>
  a2eda2:	fffa8713          	addi	a4,s5,-1
  a2eda6:	2ae79a63          	bne	a5,a4,a2f05a <uapi_upg_start+0x3e2>
  a2edaa:	4755                	li	a4,21
  a2edac:	2ae7f763          	bgeu	a5,a4,a2f05a <uapi_upg_start+0x3e2>
  a2edb0:	084c                	addi	a1,sp,20
  a2edb2:	8526                	mv	a0,s1
  a2edb4:	9b6ff0ef          	jal	ra,a2df6a <upg_get_pkg_image_hash_table>
  a2edb8:	892a                	mv	s2,a0
  a2edba:	e119                	bnez	a0,a2edc0 <uapi_upg_start+0x148>
  a2edbc:	44d2                	lw	s1,20(sp)
  a2edbe:	eca5                	bnez	s1,a2ee36 <uapi_upg_start+0x1be>
  a2edc0:	00a3 34e8 051f      	l.li	a0,0xa334e8
  a2edc6:	c2afd0ef          	jal	ra,a2c1f0 <print_str>
  a2edca:	47c2                	lw	a5,16(sp)
  a2edcc:	4481                	li	s1,0
  a2edce:	1487a503          	lw	a0,328(a5)
  a2edd2:	bddd                	j	a2ecc8 <uapi_upg_start+0x50>
  a2edd4:	037a0d33          	mul	s10,s4,s7
  a2edd8:	956a                	add	a0,a0,s10
  a2edda:	411c                	lw	a5,0(a0)
  a2eddc:	01879663          	bne	a5,s8,a2ede8 <uapi_upg_start+0x170>
  a2ede0:	19fd                	addi	s3,s3,-1
  a2ede2:	0a05                	addi	s4,s4,1 # 1001 <ccause+0x3f>
  a2ede4:	0985                	addi	s3,s3,1
  a2ede6:	bfb5                	j	a2ed62 <uapi_upg_start+0xea>
  a2ede8:	086c                	addi	a1,sp,28
  a2edea:	ce02                	sw	zero,28(sp)
  a2edec:	9b2ff0ef          	jal	ra,a2df9e <upg_get_pkg_image_header>
  a2edf0:	892a                	mv	s2,a0
  a2edf2:	e119                	bnez	a0,a2edf8 <uapi_upg_start+0x180>
  a2edf4:	47f2                	lw	a5,28(sp)
  a2edf6:	eb91                	bnez	a5,a2ee0a <uapi_upg_start+0x192>
  a2edf8:	00a3 353c 051f      	l.li	a0,0xa3353c
  a2edfe:	bf2fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ee02:	4562                	lw	a0,24(sp)
  a2ee04:	fa9fe0ef          	jal	ra,a2ddac <upg_free>
  a2ee08:	b725                	j	a2ed30 <uapi_upg_start+0xb8>
  a2ee0a:	4bfc                	lw	a5,84(a5)
  a2ee0c:	4c58                	lw	a4,28(s0)
  a2ee0e:	85ce                	mv	a1,s3
  a2ee10:	855a                	mv	a0,s6
  a2ee12:	973e                	add	a4,a4,a5
  a2ee14:	cc58                	sw	a4,28(s0)
  a2ee16:	47e2                	lw	a5,24(sp)
  a2ee18:	97ea                	add	a5,a5,s10
  a2ee1a:	4390                	lw	a2,0(a5)
  a2ee1c:	b4cff0ef          	jal	ra,a2e168 <upg_get_image_update_status>
  a2ee20:	01951763          	bne	a0,s9,a2ee2e <uapi_upg_start+0x1b6>
  a2ee24:	4772                	lw	a4,28(sp)
  a2ee26:	501c                	lw	a5,32(s0)
  a2ee28:	4b78                	lw	a4,84(a4)
  a2ee2a:	97ba                	add	a5,a5,a4
  a2ee2c:	d01c                	sw	a5,32(s0)
  a2ee2e:	4572                	lw	a0,28(sp)
  a2ee30:	f7dfe0ef          	jal	ra,a2ddac <upg_free>
  a2ee34:	b77d                	j	a2ede2 <uapi_upg_start+0x16a>
  a2ee36:	cc02                	sw	zero,24(sp)
  a2ee38:	4981                	li	s3,0
  a2ee3a:	4b01                	li	s6,0
  a2ee3c:	cb9e 063c 0a1f      	l.li	s4,0xcb9e063c
  a2ee42:	80003bb7          	lui	s7,0x80003
  a2ee46:	00a34d37          	lui	s10,0xa34
  a2ee4a:	00a34db7          	lui	s11,0xa34
  a2ee4e:	055b5963          	bge	s6,s5,a2eea0 <uapi_upg_start+0x228>
  a2ee52:	4088                	lw	a0,0(s1)
  a2ee54:	01451363          	bne	a0,s4,a2ee5a <uapi_upg_start+0x1e2>
  a2ee58:	19fd                	addi	s3,s3,-1
  a2ee5a:	e38fe0ef          	jal	ra,a2d492 <upg_img_in_set>
  a2ee5e:	cd19                	beqz	a0,a2ee7c <uapi_upg_start+0x204>
  a2ee60:	4090                	lw	a2,0(s1)
  a2ee62:	85ce                	mv	a1,s3
  a2ee64:	8522                	mv	a0,s0
  a2ee66:	b02ff0ef          	jal	ra,a2e168 <upg_get_image_update_status>
  a2ee6a:	8c2a                	mv	s8,a0
  a2ee6c:	030516bb          	bnei	a0,3,a2ee86 <uapi_upg_start+0x20e>
  a2ee70:	408c                	lw	a1,0(s1)
  a2ee72:	00a3 3a30 051f      	l.li	a0,0xa33a30
  a2ee78:	b78fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ee7c:	0b05                	addi	s6,s6,1
  a2ee7e:	0985                	addi	s3,s3,1
  a2ee80:	02c48493          	addi	s1,s1,44
  a2ee84:	b7e9                	j	a2ee4e <uapi_upg_start+0x1d6>
  a2ee86:	082c                	addi	a1,sp,24
  a2ee88:	8526                	mv	a0,s1
  a2ee8a:	914ff0ef          	jal	ra,a2df9e <upg_get_pkg_image_header>
  a2ee8e:	892a                	mv	s2,a0
  a2ee90:	e119                	bnez	a0,a2ee96 <uapi_upg_start+0x21e>
  a2ee92:	47e2                	lw	a5,24(sp)
  a2ee94:	e795                	bnez	a5,a2eec0 <uapi_upg_start+0x248>
  a2ee96:	00a3 3a60 051f      	l.li	a0,0xa33a60
  a2ee9c:	b54fd0ef          	jal	ra,a2c1f0 <print_str>
  a2eea0:	4562                	lw	a0,24(sp)
  a2eea2:	c119                	beqz	a0,a2eea8 <uapi_upg_start+0x230>
  a2eea4:	f09fe0ef          	jal	ra,a2ddac <upg_free>
  a2eea8:	00090863          	beqz	s2,a2eeb8 <uapi_upg_start+0x240>
  a2eeac:	85ca                	mv	a1,s2
  a2eeae:	00a3 3c18 051f      	l.li	a0,0xa33c18
  a2eeb4:	b3cfd0ef          	jal	ra,a2c1f0 <print_str>
  a2eeb8:	4552                	lw	a0,20(sp)
  a2eeba:	ef3fe0ef          	jal	ra,a2ddac <upg_free>
  a2eebe:	b731                	j	a2edca <uapi_upg_start+0x152>
  a2eec0:	43dc                	lw	a5,4(a5)
  a2eec2:	13478163          	beq	a5,s4,a2efe4 <uapi_upg_start+0x36c>
  a2eec6:	4601                	li	a2,0
  a2eec8:	85ce                	mv	a1,s3
  a2eeca:	8522                	mv	a0,s0
  a2eecc:	9aaff0ef          	jal	ra,a2e076 <upg_set_firmware_update_status>
  a2eed0:	892a                	mv	s2,a0
  a2eed2:	c509                	beqz	a0,a2eedc <uapi_upg_start+0x264>
  a2eed4:	00a3 3a88 051f      	l.li	a0,0xa33a88
  a2eeda:	b7c9                	j	a2ee9c <uapi_upg_start+0x224>
  a2eedc:	47e2                	lw	a5,24(sp)
  a2eede:	ab4d0513          	addi	a0,s10,-1356 # a33ab4 <g_efuse_cfg+0x120c>
  a2eee2:	43cc                	lw	a1,4(a5)
  a2eee4:	b0cfd0ef          	jal	ra,a2c1f0 <print_str>
  a2eee8:	4962                	lw	s2,24(sp)
  a2eeea:	040c1963          	bnez	s8,a2ef3c <uapi_upg_start+0x2c4>
  a2eeee:	af4ff0ef          	jal	ra,a2e1e2 <upg_flash_erase_metadata_pages>
  a2eef2:	8caa                	mv	s9,a0
  a2eef4:	c521                	beqz	a0,a2ef3c <uapi_upg_start+0x2c4>
  a2eef6:	00a3 3ae0 051f      	l.li	a0,0xa33ae0
  a2eefc:	af4fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ef00:	4c05                	li	s8,1
  a2ef02:	85e2                	mv	a1,s8
  a2ef04:	b74d8513          	addi	a0,s11,-1164 # a33b74 <g_efuse_cfg+0x12cc>
  a2ef08:	ae8fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ef0c:	8662                	mv	a2,s8
  a2ef0e:	85ce                	mv	a1,s3
  a2ef10:	8522                	mv	a0,s0
  a2ef12:	964ff0ef          	jal	ra,a2e076 <upg_set_firmware_update_status>
  a2ef16:	892a                	mv	s2,a0
  a2ef18:	000c8363          	beqz	s9,a2ef1e <uapi_upg_start+0x2a6>
  a2ef1c:	8966                	mv	s2,s9
  a2ef1e:	85ca                	mv	a1,s2
  a2ef20:	00a3 3b94 051f      	l.li	a0,0xa33b94
  a2ef26:	acafd0ef          	jal	ra,a2c1f0 <print_str>
  a2ef2a:	f6091be3          	bnez	s2,a2eea0 <uapi_upg_start+0x228>
  a2ef2e:	4562                	lw	a0,24(sp)
  a2ef30:	e7dfe0ef          	jal	ra,a2ddac <upg_free>
  a2ef34:	cc02                	sw	zero,24(sp)
  a2ef36:	e0cfe0ef          	jal	ra,a2d542 <upg_watchdog_kick>
  a2ef3a:	b789                	j	a2ee7c <uapi_upg_start+0x204>
  a2ef3c:	001c3693          	seqz	a3,s8
  a2ef40:	02000613          	li	a2,32
  a2ef44:	00c48593          	addi	a1,s1,12
  a2ef48:	854a                	mv	a0,s2
  a2ef4a:	eb0ff0ef          	jal	ra,a2e5fa <uapi_upg_verify_file_image>
  a2ef4e:	8caa                	mv	s9,a0
  a2ef50:	4c05                	li	s8,1
  a2ef52:	f945                	bnez	a0,a2ef02 <uapi_upg_start+0x28a>
  a2ef54:	00492683          	lw	a3,4(s2)
  a2ef58:	cb9e1737          	lui	a4,0xcb9e1
  a2ef5c:	82670613          	addi	a2,a4,-2010 # cb9e0826 <_gp_+0xcafabfe2>
  a2ef60:	046b8c93          	addi	s9,s7,70 # 80003046 <_gp_+0x7f5ce802>
  a2ef64:	f8c68fe3          	beq	a3,a2,a2ef02 <uapi_upg_start+0x28a>
  a2ef68:	83270713          	addi	a4,a4,-1998
  a2ef6c:	f8e68be3          	beq	a3,a4,a2ef02 <uapi_upg_start+0x28a>
  a2ef70:	06092583          	lw	a1,96(s2)
  a2ef74:	00a3 3b10 051f      	l.li	a0,0xa33b10
  a2ef7a:	a76fd0ef          	jal	ra,a2c1f0 <print_str>
  a2ef7e:	06092783          	lw	a5,96(s2)
  a2ef82:	3c78 96e1 071f      	l.li	a4,0x3c7896e1
  a2ef88:	02e79363          	bne	a5,a4,a2efae <uapi_upg_start+0x336>
  a2ef8c:	00a3 3b34 051f      	l.li	a0,0xa33b34
  a2ef92:	a5efd0ef          	jal	ra,a2c1f0 <print_str>
  a2ef96:	854a                	mv	a0,s2
  a2ef98:	f0efe0ef          	jal	ra,a2d6a6 <upg_erase_whole_image>
  a2ef9c:	8caa                	mv	s9,a0
  a2ef9e:	f135                	bnez	a0,a2ef02 <uapi_upg_start+0x28a>
  a2efa0:	854a                	mv	a0,s2
  a2efa2:	2add                	jal	ra,a2f198 <uapi_upg_compress_image_update>
  a2efa4:	00153c13          	seqz	s8,a0
  a2efa8:	8caa                	mv	s9,a0
  a2efaa:	0c05                	addi	s8,s8,1 # 1001 <ccause+0x3f>
  a2efac:	bf99                	j	a2ef02 <uapi_upg_start+0x28a>
  a2efae:	4449 4646 071f      	l.li	a4,0x44494646
  a2efb4:	00e79a63          	bne	a5,a4,a2efc8 <uapi_upg_start+0x350>
  a2efb8:	00a3 3b4c 051f      	l.li	a0,0xa33b4c
  a2efbe:	a32fd0ef          	jal	ra,a2c1f0 <print_str>
  a2efc2:	854a                	mv	a0,s2
  a2efc4:	2c3d                	jal	ra,a2f202 <uapi_upg_diff_image_update>
  a2efc6:	bff9                	j	a2efa4 <uapi_upg_start+0x32c>
  a2efc8:	00a3 3b60 051f      	l.li	a0,0xa33b60
  a2efce:	a22fd0ef          	jal	ra,a2c1f0 <print_str>
  a2efd2:	854a                	mv	a0,s2
  a2efd4:	ed2fe0ef          	jal	ra,a2d6a6 <upg_erase_whole_image>
  a2efd8:	8caa                	mv	s9,a0
  a2efda:	f20514e3          	bnez	a0,a2ef02 <uapi_upg_start+0x28a>
  a2efde:	854a                	mv	a0,s2
  a2efe0:	242d                	jal	ra,a2f20a <uapi_upg_full_image_update>
  a2efe2:	b7c9                	j	a2efa4 <uapi_upg_start+0x32c>
  a2efe4:	00a347b7          	lui	a5,0xa34
  a2efe8:	bc478513          	addi	a0,a5,-1084 # a33bc4 <g_efuse_cfg+0x131c>
  a2efec:	85d2                	mv	a1,s4
  a2efee:	a02fd0ef          	jal	ra,a2c1f0 <print_str>
  a2eff2:	47e2                	lw	a5,24(sp)
  a2eff4:	00a346b7          	lui	a3,0xa34
  a2eff8:	98c6a903          	lw	s2,-1652(a3) # a3398c <g_efuse_cfg+0x10e4>
  a2effc:	43d8                	lw	a4,4(a5)
  a2effe:	05471663          	bne	a4,s4,a2f04a <uapi_upg_start+0x3d2>
  a2f002:	4794                	lw	a3,8(a5)
  a2f004:	40d8                	lw	a4,4(s1)
  a2f006:	0868                	addi	a0,sp,28
  a2f008:	c874                	sw	a3,84(s0)
  a2f00a:	47dc                	lw	a5,12(a5)
  a2f00c:	07bd                	addi	a5,a5,15
  a2f00e:	9bc1                	andi	a5,a5,-16
  a2f010:	cc3c                	sw	a5,88(s0)
  a2f012:	01070793          	addi	a5,a4,16
  a2f016:	cc7c                	sw	a5,92(s0)
  a2f018:	02000793          	li	a5,32
  a2f01c:	d03c                	sw	a5,96(s0)
  a2f01e:	ce02                	sw	zero,28(sp)
  a2f020:	c98fe0ef          	jal	ra,a2d4b8 <upg_get_upgrade_flag_flash_start_addr>
  a2f024:	892a                	mv	s2,a0
  a2f026:	e115                	bnez	a0,a2f04a <uapi_upg_start+0x3d2>
  a2f028:	4572                	lw	a0,28(sp)
  a2f02a:	4681                	li	a3,0
  a2f02c:	05440613          	addi	a2,s0,84
  a2f030:	45c1                	li	a1,16
  a2f032:	05450513          	addi	a0,a0,84
  a2f036:	dd4fe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2f03a:	892a                	mv	s2,a0
  a2f03c:	e519                	bnez	a0,a2f04a <uapi_upg_start+0x3d2>
  a2f03e:	4601                	li	a2,0
  a2f040:	85d2                	mv	a1,s4
  a2f042:	8522                	mv	a0,s0
  a2f044:	832ff0ef          	jal	ra,a2e076 <upg_set_firmware_update_status>
  a2f048:	892a                	mv	s2,a0
  a2f04a:	00a347b7          	lui	a5,0xa34
  a2f04e:	85ca                	mv	a1,s2
  a2f050:	bec78513          	addi	a0,a5,-1044 # a33bec <g_efuse_cfg+0x1344>
  a2f054:	99cfd0ef          	jal	ra,a2c1f0 <print_str>
  a2f058:	bdd9                	j	a2ef2e <uapi_upg_start+0x2b6>
  a2f05a:	8000 3043 091f      	l.li	s2,0x80003043
  a2f060:	b3ad                	j	a2edca <uapi_upg_start+0x152>
  a2f062:	4485                	li	s1,1
  a2f064:	4501                	li	a0,0
  a2f066:	8000 3040 091f      	l.li	s2,0x80003040
  a2f06c:	b9b1                	j	a2ecc8 <uapi_upg_start+0x50>

00a2f06e <uapi_upg_register_progress_callback>:
  a2f06e:	8028                	push	{ra,s0},-16
  a2f070:	842a                	mv	s0,a0
  a2f072:	d6bfe0ef          	jal	ra,a2dddc <upg_get_ctx>
  a2f076:	cd00                	sw	s0,24(a0)
  a2f078:	4501                	li	a0,0
  a2f07a:	8024                	popret	{ra,s0},16

00a2f07c <upg_calculate_and_notify_process>:
  a2f07c:	8038                	push	{ra,s0-s1},-16
  a2f07e:	842a                	mv	s0,a0
  a2f080:	d5dfe0ef          	jal	ra,a2dddc <upg_get_ctx>
  a2f084:	84aa                	mv	s1,a0
  a2f086:	d57fe0ef          	jal	ra,a2dddc <upg_get_ctx>
  a2f08a:	4d1c                	lw	a5,24(a0)
  a2f08c:	cb85                	beqz	a5,a2f0bc <upg_calculate_and_notify_process+0x40>
  a2f08e:	5088                	lw	a0,32(s1)
  a2f090:	9522                	add	a0,a0,s0
  a2f092:	4cc0                	lw	s0,28(s1)
  a2f094:	d088                	sw	a0,32(s1)
  a2f096:	c419                	beqz	s0,a2f0a4 <upg_calculate_and_notify_process+0x28>
  a2f098:	06400793          	li	a5,100
  a2f09c:	02f50533          	mul	a0,a0,a5
  a2f0a0:	02855433          	divu	s0,a0,s0
  a2f0a4:	00a0 5b04 049f      	l.li	s1,0xa05b04
  a2f0aa:	409c                	lw	a5,0(s1)
  a2f0ac:	00878863          	beq	a5,s0,a2f0bc <upg_calculate_and_notify_process+0x40>
  a2f0b0:	d2dfe0ef          	jal	ra,a2dddc <upg_get_ctx>
  a2f0b4:	4d1c                	lw	a5,24(a0)
  a2f0b6:	8522                	mv	a0,s0
  a2f0b8:	9782                	jalr	a5
  a2f0ba:	c080                	sw	s0,0(s1)
  a2f0bc:	8034                	popret	{ra,s0-s1},16

00a2f0be <upg_write_new_image_data>:
  a2f0be:	8248                	push	{ra,s0-s2},-48
  a2f0c0:	ca02                	sw	zero,20(sp)
  a2f0c2:	cc02                	sw	zero,24(sp)
  a2f0c4:	ce02                	sw	zero,28(sp)
  a2f0c6:	4b87 a52d 079f      	l.li	a5,0x4b87a52d
  a2f0cc:	842a                	mv	s0,a0
  a2f0ce:	892e                	mv	s2,a1
  a2f0d0:	84b2                	mv	s1,a2
  a2f0d2:	02f69363          	bne	a3,a5,a2f0f8 <upg_write_new_image_data+0x3a>
  a2f0d6:	002007b7          	lui	a5,0x200
  a2f0da:	cc3e                	sw	a5,24(sp)
  a2f0dc:	78000793          	li	a5,1920
  a2f0e0:	ce3e                	sw	a5,28(sp)
  a2f0e2:	01414783          	lbu	a5,20(sp)
  a2f0e6:	e38d                	bnez	a5,a2f108 <upg_write_new_image_data+0x4a>
  a2f0e8:	4562                	lw	a0,24(sp)
  a2f0ea:	408c                	lw	a1,0(s1)
  a2f0ec:	86ba                	mv	a3,a4
  a2f0ee:	864a                	mv	a2,s2
  a2f0f0:	9522                	add	a0,a0,s0
  a2f0f2:	d18fe0ef          	jal	ra,a2d60a <upg_flash_write>
  a2f0f6:	a801                	j	a2f106 <upg_write_new_image_data+0x48>
  a2f0f8:	8536                	mv	a0,a3
  a2f0fa:	084c                	addi	a1,sp,20
  a2f0fc:	c63a                	sw	a4,12(sp)
  a2f0fe:	d49fe0ef          	jal	ra,a2de46 <upg_get_image_info>
  a2f102:	4732                	lw	a4,12(sp)
  a2f104:	dd79                	beqz	a0,a2f0e2 <upg_write_new_image_data+0x24>
  a2f106:	8244                	popret	{ra,s0-s2},48
  a2f108:	8000 3004 051f      	l.li	a0,0x80003004
  a2f10e:	bfe5                	j	a2f106 <upg_write_new_image_data+0x48>

00a2f110 <uapi_upg_lzma_ota_image>:
  a2f110:	8a58                	push	{ra,s0-s3},-192
  a2f112:	842e                	mv	s0,a1
  a2f114:	89b2                	mv	s3,a2
  a2f116:	4581                	li	a1,0
  a2f118:	02400613          	li	a2,36
  a2f11c:	84aa                	mv	s1,a0
  a2f11e:	0828                	addi	a0,sp,24
  a2f120:	8936                	mv	s2,a3
  a2f122:	c63a                	sw	a4,12(sp)
  a2f124:	881f90ef          	jal	ra,a289a4 <memset>
  a2f128:	8622                	mv	a2,s0
  a2f12a:	86ce                	mv	a3,s3
  a2f12c:	082c                	addi	a1,sp,24
  a2f12e:	1868                	addi	a0,sp,60
  a2f130:	8a5ff0ef          	jal	ra,a2e9d4 <upg_lzma_init>
  a2f134:	842a                	mv	s0,a0
  a2f136:	e915                	bnez	a0,a2f16a <uapi_upg_lzma_ota_image+0x5a>
  a2f138:	44d0                	lw	a2,12(s1)
  a2f13a:	40dc                	lw	a5,4(s1)
  a2f13c:	4732                	lw	a4,12(sp)
  a2f13e:	41360633          	sub	a2,a2,s3
  a2f142:	d232                	sw	a2,36(sp)
  a2f144:	5622                	lw	a2,40(sp)
  a2f146:	cc3e                	sw	a5,24(sp)
  a2f148:	ce3a                	sw	a4,28(sp)
  a2f14a:	d002                	sw	zero,32(sp)
  a2f14c:	02c97163          	bgeu	s2,a2,a2f16e <uapi_upg_lzma_ota_image+0x5e>
  a2f150:	85ca                	mv	a1,s2
  a2f152:	00a3 3c50 051f      	l.li	a0,0xa33c50
  a2f158:	898fd0ef          	jal	ra,a2c1f0 <print_str>
  a2f15c:	082c                	addi	a1,sp,24
  a2f15e:	1868                	addi	a0,sp,60
  a2f160:	917ff0ef          	jal	ra,a2ea76 <upg_lzma_deinit>
  a2f164:	8000 3051 041f      	l.li	s0,0x80003051
  a2f16a:	8522                	mv	a0,s0
  a2f16c:	8a54                	popret	{ra,s0-s3},192
  a2f16e:	8626                	mv	a2,s1
  a2f170:	082c                	addi	a1,sp,24
  a2f172:	1868                	addi	a0,sp,60
  a2f174:	a4bff0ef          	jal	ra,a2ebbe <upg_lzma_decode>
  a2f178:	842a                	mv	s0,a0
  a2f17a:	c911                	beqz	a0,a2f18e <uapi_upg_lzma_ota_image+0x7e>
  a2f17c:	85aa                	mv	a1,a0
  a2f17e:	00a3 3c98 051f      	l.li	a0,0xa33c98
  a2f184:	86cfd0ef          	jal	ra,a2c1f0 <print_str>
  a2f188:	8000 3062 041f      	l.li	s0,0x80003062
  a2f18e:	082c                	addi	a1,sp,24
  a2f190:	1868                	addi	a0,sp,60
  a2f192:	8e5ff0ef          	jal	ra,a2ea76 <upg_lzma_deinit>
  a2f196:	bfd1                	j	a2f16a <uapi_upg_lzma_ota_image+0x5a>

00a2f198 <uapi_upg_compress_image_update>:
  a2f198:	8258                	push	{ra,s0-s3},-64
  a2f19a:	47c1                	li	a5,16
  a2f19c:	0814                	addi	a3,sp,16
  a2f19e:	0050                	addi	a2,sp,4
  a2f1a0:	4581                	li	a1,0
  a2f1a2:	84aa                	mv	s1,a0
  a2f1a4:	00852903          	lw	s2,8(a0)
  a2f1a8:	c802                	sw	zero,16(sp)
  a2f1aa:	ca02                	sw	zero,20(sp)
  a2f1ac:	cc02                	sw	zero,24(sp)
  a2f1ae:	ce02                	sw	zero,28(sp)
  a2f1b0:	c23e                	sw	a5,4(sp)
  a2f1b2:	c402                	sw	zero,8(sp)
  a2f1b4:	c602                	sw	zero,12(sp)
  a2f1b6:	e7dfe0ef          	jal	ra,a2e032 <upg_copy_pkg_image_data>
  a2f1ba:	842a                	mv	s0,a0
  a2f1bc:	e129                	bnez	a0,a2f1fe <uapi_upg_compress_image_update+0x66>
  a2f1be:	8526                	mv	a0,s1
  a2f1c0:	cfcfe0ef          	jal	ra,a2d6bc <upg_cryto_init>
  a2f1c4:	842a                	mv	s0,a0
  a2f1c6:	ed05                	bnez	a0,a2f1fe <uapi_upg_compress_image_update+0x66>
  a2f1c8:	4592                	lw	a1,4(sp)
  a2f1ca:	8626                	mv	a2,s1
  a2f1cc:	0808                	addi	a0,sp,16
  a2f1ce:	e44fe0ef          	jal	ra,a2d812 <upg_decry_fota_pkt>
  a2f1d2:	842a                	mv	s0,a0
  a2f1d4:	e115                	bnez	a0,a2f1f8 <uapi_upg_compress_image_update+0x60>
  a2f1d6:	40c8                	lw	a0,4(s1)
  a2f1d8:	0070                	addi	a2,sp,12
  a2f1da:	002c                	addi	a1,sp,8
  a2f1dc:	4992                	lw	s3,4(sp)
  a2f1de:	d21fe0ef          	jal	ra,a2defe <upg_get_partition_info>
  a2f1e2:	842a                	mv	s0,a0
  a2f1e4:	e911                	bnez	a0,a2f1f8 <uapi_upg_compress_image_update+0x60>
  a2f1e6:	46b2                	lw	a3,12(sp)
  a2f1e8:	01298733          	add	a4,s3,s2
  a2f1ec:	4641                	li	a2,16
  a2f1ee:	080c                	addi	a1,sp,16
  a2f1f0:	8526                	mv	a0,s1
  a2f1f2:	f1fff0ef          	jal	ra,a2f110 <uapi_upg_lzma_ota_image>
  a2f1f6:	842a                	mv	s0,a0
  a2f1f8:	8526                	mv	a0,s1
  a2f1fa:	dd0fe0ef          	jal	ra,a2d7ca <upg_cryto_deinit>
  a2f1fe:	8522                	mv	a0,s0
  a2f200:	8254                	popret	{ra,s0-s3},64

00a2f202 <uapi_upg_diff_image_update>:
  a2f202:	8000 3046 051f      	l.li	a0,0x80003046
  a2f208:	8082                	ret

00a2f20a <uapi_upg_full_image_update>:
  a2f20a:	8188                	push	{ra,s0-s6},-48
  a2f20c:	00852a83          	lw	s5,8(a0)
  a2f210:	8a2a                	mv	s4,a0
  a2f212:	4148                	lw	a0,4(a0)
  a2f214:	0030                	addi	a2,sp,8
  a2f216:	004c                	addi	a1,sp,4
  a2f218:	c202                	sw	zero,4(sp)
  a2f21a:	c402                	sw	zero,8(sp)
  a2f21c:	ce3fe0ef          	jal	ra,a2defe <upg_get_partition_info>
  a2f220:	842a                	mv	s0,a0
  a2f222:	e921                	bnez	a0,a2f272 <uapi_upg_full_image_update+0x68>
  a2f224:	00ca2703          	lw	a4,12(s4)
  a2f228:	47a2                	lw	a5,8(sp)
  a2f22a:	06e7e963          	bltu	a5,a4,a2f29c <uapi_upg_full_image_update+0x92>
  a2f22e:	6505                	lui	a0,0x1
  a2f230:	c602                	sw	zero,12(sp)
  a2f232:	b61fe0ef          	jal	ra,a2dd92 <upg_malloc>
  a2f236:	84aa                	mv	s1,a0
  a2f238:	c525                	beqz	a0,a2f2a0 <uapi_upg_full_image_update+0x96>
  a2f23a:	4901                	li	s2,0
  a2f23c:	6b05                	lui	s6,0x1
  a2f23e:	00ca2783          	lw	a5,12(s4)
  a2f242:	00f96663          	bltu	s2,a5,a2f24e <uapi_upg_full_image_update+0x44>
  a2f246:	8526                	mv	a0,s1
  a2f248:	b65fe0ef          	jal	ra,a2ddac <upg_free>
  a2f24c:	a01d                	j	a2f272 <uapi_upg_full_image_update+0x68>
  a2f24e:	412787b3          	sub	a5,a5,s2
  a2f252:	00fb7363          	bgeu	s6,a5,a2f258 <uapi_upg_full_image_update+0x4e>
  a2f256:	6785                	lui	a5,0x1
  a2f258:	0070                	addi	a2,sp,12
  a2f25a:	85a6                	mv	a1,s1
  a2f25c:	01590533          	add	a0,s2,s5
  a2f260:	c63e                	sw	a5,12(sp)
  a2f262:	c2bfe0ef          	jal	ra,a2de8c <upg_read_fota_pkg_data>
  a2f266:	89aa                	mv	s3,a0
  a2f268:	c519                	beqz	a0,a2f276 <uapi_upg_full_image_update+0x6c>
  a2f26a:	8526                	mv	a0,s1
  a2f26c:	b41fe0ef          	jal	ra,a2ddac <upg_free>
  a2f270:	844e                	mv	s0,s3
  a2f272:	8522                	mv	a0,s0
  a2f274:	8184                	popret	{ra,s0-s6},48
  a2f276:	004a2683          	lw	a3,4(s4)
  a2f27a:	4701                	li	a4,0
  a2f27c:	0070                	addi	a2,sp,12
  a2f27e:	85a6                	mv	a1,s1
  a2f280:	854a                	mv	a0,s2
  a2f282:	e3dff0ef          	jal	ra,a2f0be <upg_write_new_image_data>
  a2f286:	89aa                	mv	s3,a0
  a2f288:	f16d                	bnez	a0,a2f26a <uapi_upg_full_image_update+0x60>
  a2f28a:	47b2                	lw	a5,12(sp)
  a2f28c:	dff9                	beqz	a5,a2f26a <uapi_upg_full_image_update+0x60>
  a2f28e:	993e                	add	s2,s2,a5
  a2f290:	ab2fe0ef          	jal	ra,a2d542 <upg_watchdog_kick>
  a2f294:	4532                	lw	a0,12(sp)
  a2f296:	de7ff0ef          	jal	ra,a2f07c <upg_calculate_and_notify_process>
  a2f29a:	b755                	j	a2f23e <uapi_upg_full_image_update+0x34>
  a2f29c:	547d                	li	s0,-1
  a2f29e:	bfd1                	j	a2f272 <uapi_upg_full_image_update+0x68>
  a2f2a0:	80000437          	lui	s0,0x80000
  a2f2a4:	0415                	addi	s0,s0,5 # 80000005 <_gp_+0x7f5cb7c1>
  a2f2a6:	b7f1                	j	a2f272 <uapi_upg_full_image_update+0x68>

00a2f2a8 <LzmaDec_TryDummy>:
  a2f2a8:	2138                	lbu	a4,2(a0)
  a2f2aa:	02852f83          	lw	t6,40(a0) # 1028 <ccause+0x66>
  a2f2ae:	5e7d                	li	t3,-1
  a2f2b0:	00ee1e33          	sll	t3,t3,a4
  a2f2b4:	04052e83          	lw	t4,64(a0)
  a2f2b8:	fffe4e13          	not	t3,t3
  a2f2bc:	00c52303          	lw	t1,12(a0)
  a2f2c0:	01fe7e33          	and	t3,t3,t6
  a2f2c4:	0e12                	slli	t3,t3,0x4
  a2f2c6:	02052803          	lw	a6,32(a0)
  a2f2ca:	01ce8f33          	add	t5,t4,t3
  a2f2ce:	03e30f1b          	addshf	t5,t1,t5,sll,1
  a2f2d2:	86aa                	mv	a3,a0
  a2f2d4:	515c                	lw	a5,36(a0)
  a2f2d6:	e00f0f13          	addi	t5,t5,-512
  a2f2da:	01000537          	lui	a0,0x1000
  a2f2de:	00062883          	lw	a7,0(a2)
  a2f2e2:	000f5703          	lhu	a4,0(t5)
  a2f2e6:	00a87a63          	bgeu	a6,a0,a2f2fa <LzmaDec_TryDummy+0x52>
  a2f2ea:	4501                	li	a0,0
  a2f2ec:	4115f963          	bgeu	a1,a7,a2f6fe <LzmaDec_TryDummy+0x456>
  a2f2f0:	2188                	lbu	a0,0(a1)
  a2f2f2:	0822                	slli	a6,a6,0x8
  a2f2f4:	0585                	addi	a1,a1,1
  a2f2f6:	10f5279b          	orshf	a5,a0,a5,sll,8
  a2f2fa:	00b85513          	srli	a0,a6,0xb
  a2f2fe:	02e50733          	mul	a4,a0,a4
  a2f302:	12e7f963          	bgeu	a5,a4,a2f434 <LzmaDec_TryDummy+0x18c>
  a2f306:	56c8                	lw	a0,44(a3)
  a2f308:	28030313          	addi	t1,t1,640
  a2f30c:	e119                	bnez	a0,a2f312 <LzmaDec_TryDummy+0x6a>
  a2f30e:	040f8863          	beqz	t6,a2f35e <LzmaDec_TryDummy+0xb6>
  a2f312:	0016c803          	lbu	a6,1(a3)
  a2f316:	557d                	li	a0,-1
  a2f318:	0006c283          	lbu	t0,0(a3)
  a2f31c:	01051533          	sll	a0,a0,a6
  a2f320:	0186a803          	lw	a6,24(a3)
  a2f324:	fff54513          	not	a0,a0
  a2f328:	01f57533          	and	a0,a0,t6
  a2f32c:	00551533          	sll	a0,a0,t0
  a2f330:	0106af03          	lw	t5,16(a3)
  a2f334:	fff80e13          	addi	t3,a6,-1
  a2f338:	00081563          	bnez	a6,a2f342 <LzmaDec_TryDummy+0x9a>
  a2f33c:	0146ae03          	lw	t3,20(a3)
  a2f340:	1e7d                	addi	t3,t3,-1
  a2f342:	9e7a                	add	t3,t3,t5
  a2f344:	000e4803          	lbu	a6,0(t3)
  a2f348:	4e21                	li	t3,8
  a2f34a:	405e0e33          	sub	t3,t3,t0
  a2f34e:	01c85833          	srl	a6,a6,t3
  a2f352:	9542                	add	a0,a0,a6
  a2f354:	60000813          	li	a6,1536
  a2f358:	03050533          	mul	a0,a0,a6
  a2f35c:	932a                	add	t1,t1,a0
  a2f35e:	071ef63b          	bgeui	t4,7,a2f3b6 <LzmaDec_TryDummy+0x10e>
  a2f362:	4685                	li	a3,1
  a2f364:	01000e37          	lui	t3,0x1000
  a2f368:	0ff00813          	li	a6,255
  a2f36c:	0686                	slli	a3,a3,0x1
  a2f36e:	00d30533          	add	a0,t1,a3
  a2f372:	00055e83          	lhu	t4,0(a0) # 1000000 <_gp_+0x5cb7bc>
  a2f376:	01c77963          	bgeu	a4,t3,a2f388 <LzmaDec_TryDummy+0xe0>
  a2f37a:	3915f163          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f37e:	2188                	lbu	a0,0(a1)
  a2f380:	0722                	slli	a4,a4,0x8
  a2f382:	0585                	addi	a1,a1,1
  a2f384:	10f5279b          	orshf	a5,a0,a5,sll,8
  a2f388:	00b75513          	srli	a0,a4,0xb
  a2f38c:	03d50533          	mul	a0,a0,t4
  a2f390:	02a7e163          	bltu	a5,a0,a2f3b2 <LzmaDec_TryDummy+0x10a>
  a2f394:	8f09                	sub	a4,a4,a0
  a2f396:	8f89                	sub	a5,a5,a0
  a2f398:	0685                	addi	a3,a3,1
  a2f39a:	fcd879e3          	bgeu	a6,a3,a2f36c <LzmaDec_TryDummy+0xc4>
  a2f39e:	4505                	li	a0,1
  a2f3a0:	010007b7          	lui	a5,0x1000
  a2f3a4:	00f77563          	bgeu	a4,a5,a2f3ae <LzmaDec_TryDummy+0x106>
  a2f3a8:	3515fa63          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f3ac:	0585                	addi	a1,a1,1
  a2f3ae:	c20c                	sw	a1,0(a2)
  a2f3b0:	8082                	ret
  a2f3b2:	872a                	mv	a4,a0
  a2f3b4:	b7dd                	j	a2f39a <LzmaDec_TryDummy+0xf2>
  a2f3b6:	0186ae83          	lw	t4,24(a3)
  a2f3ba:	0306ae03          	lw	t3,48(a3)
  a2f3be:	4a88                	lw	a0,16(a3)
  a2f3c0:	4801                	li	a6,0
  a2f3c2:	41ce8f33          	sub	t5,t4,t3
  a2f3c6:	01cef463          	bgeu	t4,t3,a2f3ce <LzmaDec_TryDummy+0x126>
  a2f3ca:	0146a803          	lw	a6,20(a3)
  a2f3ce:	01e506b3          	add	a3,a0,t5
  a2f3d2:	96c2                	add	a3,a3,a6
  a2f3d4:	0006ce03          	lbu	t3,0(a3)
  a2f3d8:	10000813          	li	a6,256
  a2f3dc:	4685                	li	a3,1
  a2f3de:	01000fb7          	lui	t6,0x1000
  a2f3e2:	0ff00f13          	li	t5,255
  a2f3e6:	0e06                	slli	t3,t3,0x1
  a2f3e8:	01c87eb3          	and	t4,a6,t3
  a2f3ec:	00d80533          	add	a0,a6,a3
  a2f3f0:	9576                	add	a0,a0,t4
  a2f3f2:	02a3051b          	addshf	a0,t1,a0,sll,1
  a2f3f6:	00055283          	lhu	t0,0(a0)
  a2f3fa:	01f77963          	bgeu	a4,t6,a2f40c <LzmaDec_TryDummy+0x164>
  a2f3fe:	2f15ff63          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f402:	2188                	lbu	a0,0(a1)
  a2f404:	0722                	slli	a4,a4,0x8
  a2f406:	0585                	addi	a1,a1,1
  a2f408:	10f5279b          	orshf	a5,a0,a5,sll,8
  a2f40c:	00b75513          	srli	a0,a4,0xb
  a2f410:	02550533          	mul	a0,a0,t0
  a2f414:	0686                	slli	a3,a3,0x1
  a2f416:	00a7fa63          	bgeu	a5,a0,a2f42a <LzmaDec_TryDummy+0x182>
  a2f41a:	fffe4713          	not	a4,t3
  a2f41e:	00e87833          	and	a6,a6,a4
  a2f422:	872a                	mv	a4,a0
  a2f424:	fcdf71e3          	bgeu	t5,a3,a2f3e6 <LzmaDec_TryDummy+0x13e>
  a2f428:	bf9d                	j	a2f39e <LzmaDec_TryDummy+0xf6>
  a2f42a:	8f09                	sub	a4,a4,a0
  a2f42c:	8f89                	sub	a5,a5,a0
  a2f42e:	0685                	addi	a3,a3,1
  a2f430:	8876                	mv	a6,t4
  a2f432:	bfcd                	j	a2f424 <LzmaDec_TryDummy+0x17c>
  a2f434:	0ec1                	addi	t4,t4,16
  a2f436:	40e80833          	sub	a6,a6,a4
  a2f43a:	03d30e9b          	addshf	t4,t1,t4,sll,1
  a2f43e:	010006b7          	lui	a3,0x1000
  a2f442:	8f99                	sub	a5,a5,a4
  a2f444:	000ed703          	lhu	a4,0(t4)
  a2f448:	00d87a63          	bgeu	a6,a3,a2f45c <LzmaDec_TryDummy+0x1b4>
  a2f44c:	4501                	li	a0,0
  a2f44e:	2b15f863          	bgeu	a1,a7,a2f6fe <LzmaDec_TryDummy+0x456>
  a2f452:	2194                	lbu	a3,0(a1)
  a2f454:	0822                	slli	a6,a6,0x8
  a2f456:	0585                	addi	a1,a1,1
  a2f458:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f45c:	00b85693          	srli	a3,a6,0xb
  a2f460:	02e686b3          	mul	a3,a3,a4
  a2f464:	14d7f063          	bgeu	a5,a3,a2f5a4 <LzmaDec_TryDummy+0x2fc>
  a2f468:	a0030813          	addi	a6,t1,-1536
  a2f46c:	4509                	li	a0,2
  a2f46e:	4f81                	li	t6,0
  a2f470:	01000eb7          	lui	t4,0x1000
  a2f474:	00085703          	lhu	a4,0(a6)
  a2f478:	01d6fa63          	bgeu	a3,t4,a2f48c <LzmaDec_TryDummy+0x1e4>
  a2f47c:	2915f063          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f480:	0005ce83          	lbu	t4,0(a1)
  a2f484:	06a2                	slli	a3,a3,0x8
  a2f486:	0585                	addi	a1,a1,1
  a2f488:	10fea79b          	orshf	a5,t4,a5,sll,8
  a2f48c:	00b6de93          	srli	t4,a3,0xb
  a2f490:	02ee8733          	mul	a4,t4,a4
  a2f494:	1ce7fe63          	bgeu	a5,a4,a2f670 <LzmaDec_TryDummy+0x3c8>
  a2f498:	03c8081b          	addshf	a6,a6,t3,sll,1
  a2f49c:	4681                	li	a3,0
  a2f49e:	4f21                	li	t5,8
  a2f4a0:	4e05                	li	t3,1
  a2f4a2:	010002b7          	lui	t0,0x1000
  a2f4a6:	0e06                	slli	t3,t3,0x1
  a2f4a8:	01c80eb3          	add	t4,a6,t3
  a2f4ac:	000ed383          	lhu	t2,0(t4) # 1000000 <_gp_+0x5cb7bc>
  a2f4b0:	00577a63          	bgeu	a4,t0,a2f4c4 <LzmaDec_TryDummy+0x21c>
  a2f4b4:	2515f463          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f4b8:	0005ce83          	lbu	t4,0(a1)
  a2f4bc:	0722                	slli	a4,a4,0x8
  a2f4be:	0585                	addi	a1,a1,1
  a2f4c0:	10fea79b          	orshf	a5,t4,a5,sll,8
  a2f4c4:	00b75e93          	srli	t4,a4,0xb
  a2f4c8:	027e8eb3          	mul	t4,t4,t2
  a2f4cc:	1fd7e663          	bltu	a5,t4,a2f6b8 <LzmaDec_TryDummy+0x410>
  a2f4d0:	41d70733          	sub	a4,a4,t4
  a2f4d4:	41d787b3          	sub	a5,a5,t4
  a2f4d8:	0e05                	addi	t3,t3,1 # 1000001 <_gp_+0x5cb7bd>
  a2f4da:	fdee66e3          	bltu	t3,t5,a2f4a6 <LzmaDec_TryDummy+0x1fe>
  a2f4de:	04bff0bb          	bgeui	t6,4,a2f3a0 <LzmaDec_TryDummy+0xf8>
  a2f4e2:	41e686b3          	sub	a3,a3,t5
  a2f4e6:	96f2                	add	a3,a3,t3
  a2f4e8:	20000e13          	li	t3,512
  a2f4ec:	0306f2bb          	bgeui	a3,3,a2f4f6 <LzmaDec_TryDummy+0x24e>
  a2f4f0:	0685                	addi	a3,a3,1 # 1000001 <_gp_+0x5cb7bd>
  a2f4f2:	00769e13          	slli	t3,a3,0x7
  a2f4f6:	4685                	li	a3,1
  a2f4f8:	01000f37          	lui	t5,0x1000
  a2f4fc:	03f00e93          	li	t4,63
  a2f500:	0686                	slli	a3,a3,0x1
  a2f502:	00d30833          	add	a6,t1,a3
  a2f506:	9872                	add	a6,a6,t3
  a2f508:	00085f83          	lhu	t6,0(a6)
  a2f50c:	01e77a63          	bgeu	a4,t5,a2f520 <LzmaDec_TryDummy+0x278>
  a2f510:	1f15f663          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f514:	0005c803          	lbu	a6,0(a1)
  a2f518:	0722                	slli	a4,a4,0x8
  a2f51a:	0585                	addi	a1,a1,1
  a2f51c:	10f8279b          	orshf	a5,a6,a5,sll,8
  a2f520:	00b75813          	srli	a6,a4,0xb
  a2f524:	03f80833          	mul	a6,a6,t6
  a2f528:	1907ea63          	bltu	a5,a6,a2f6bc <LzmaDec_TryDummy+0x414>
  a2f52c:	41070733          	sub	a4,a4,a6
  a2f530:	410787b3          	sub	a5,a5,a6
  a2f534:	0685                	addi	a3,a3,1
  a2f536:	fcdef5e3          	bgeu	t4,a3,a2f500 <LzmaDec_TryDummy+0x258>
  a2f53a:	fc068693          	addi	a3,a3,-64
  a2f53e:	0496e8bb          	bltui	a3,4,a2f3a0 <LzmaDec_TryDummy+0xf8>
  a2f542:	0016d813          	srli	a6,a3,0x1
  a2f546:	0e56febb          	bgeui	a3,14,a2f6c0 <LzmaDec_TryDummy+0x418>
  a2f54a:	8a85                	andi	a3,a3,1
  a2f54c:	187d                	addi	a6,a6,-1
  a2f54e:	0026e693          	ori	a3,a3,2
  a2f552:	80000e37          	lui	t3,0x80000
  a2f556:	010696b3          	sll	a3,a3,a6
  a2f55a:	980e4e13          	xori	t3,t3,-1664
  a2f55e:	96f2                	add	a3,a3,t3
  a2f560:	02d3031b          	addshf	t1,t1,a3,sll,1
  a2f564:	4e85                	li	t4,1
  a2f566:	4e05                	li	t3,1
  a2f568:	01000fb7          	lui	t6,0x1000
  a2f56c:	03c3069b          	addshf	a3,t1,t3,sll,1
  a2f570:	0006df03          	lhu	t5,0(a3)
  a2f574:	01f77963          	bgeu	a4,t6,a2f586 <LzmaDec_TryDummy+0x2de>
  a2f578:	1915f263          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f57c:	2194                	lbu	a3,0(a1)
  a2f57e:	0722                	slli	a4,a4,0x8
  a2f580:	0585                	addi	a1,a1,1
  a2f582:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f586:	00b75693          	srli	a3,a4,0xb
  a2f58a:	03e686b3          	mul	a3,a3,t5
  a2f58e:	001e9f13          	slli	t5,t4,0x1
  a2f592:	14d7ff63          	bgeu	a5,a3,a2f6f0 <LzmaDec_TryDummy+0x448>
  a2f596:	9e76                	add	t3,t3,t4
  a2f598:	8736                	mv	a4,a3
  a2f59a:	187d                	addi	a6,a6,-1
  a2f59c:	8efa                	mv	t4,t5
  a2f59e:	fc0817e3          	bnez	a6,a2f56c <LzmaDec_TryDummy+0x2c4>
  a2f5a2:	bbfd                	j	a2f3a0 <LzmaDec_TryDummy+0xf8>
  a2f5a4:	40d80733          	sub	a4,a6,a3
  a2f5a8:	8f95                	sub	a5,a5,a3
  a2f5aa:	010006b7          	lui	a3,0x1000
  a2f5ae:	018ed803          	lhu	a6,24(t4)
  a2f5b2:	00d77a63          	bgeu	a4,a3,a2f5c6 <LzmaDec_TryDummy+0x31e>
  a2f5b6:	4501                	li	a0,0
  a2f5b8:	1515f363          	bgeu	a1,a7,a2f6fe <LzmaDec_TryDummy+0x456>
  a2f5bc:	2194                	lbu	a3,0(a1)
  a2f5be:	0722                	slli	a4,a4,0x8
  a2f5c0:	0585                	addi	a1,a1,1
  a2f5c2:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f5c6:	00b75693          	srli	a3,a4,0xb
  a2f5ca:	030686b3          	mul	a3,a3,a6
  a2f5ce:	04d7f163          	bgeu	a5,a3,a2f610 <LzmaDec_TryDummy+0x368>
  a2f5d2:	777d                	lui	a4,0xfffff
  a2f5d4:	9f3a                	add	t5,t5,a4
  a2f5d6:	01000537          	lui	a0,0x1000
  a2f5da:	600f5703          	lhu	a4,1536(t5) # 1000600 <_gp_+0x5cbdbc>
  a2f5de:	00a6fa63          	bgeu	a3,a0,a2f5f2 <LzmaDec_TryDummy+0x34a>
  a2f5e2:	4501                	li	a0,0
  a2f5e4:	1115fd63          	bgeu	a1,a7,a2f6fe <LzmaDec_TryDummy+0x456>
  a2f5e8:	2188                	lbu	a0,0(a1)
  a2f5ea:	06a2                	slli	a3,a3,0x8
  a2f5ec:	0585                	addi	a1,a1,1
  a2f5ee:	10f5279b          	orshf	a5,a0,a5,sll,8
  a2f5f2:	00b6d513          	srli	a0,a3,0xb
  a2f5f6:	02e50733          	mul	a4,a0,a4
  a2f5fa:	0ee7ef63          	bltu	a5,a4,a2f6f8 <LzmaDec_TryDummy+0x450>
  a2f5fe:	8e99                	sub	a3,a3,a4
  a2f600:	8f99                	sub	a5,a5,a4
  a2f602:	ffff f600 081f      	l.li	a6,0xfffff600
  a2f608:	981a                	add	a6,a6,t1
  a2f60a:	450d                	li	a0,3
  a2f60c:	4fb1                	li	t6,12
  a2f60e:	b58d                	j	a2f470 <LzmaDec_TryDummy+0x1c8>
  a2f610:	8f15                	sub	a4,a4,a3
  a2f612:	8f95                	sub	a5,a5,a3
  a2f614:	010006b7          	lui	a3,0x1000
  a2f618:	030ed803          	lhu	a6,48(t4)
  a2f61c:	00d77a63          	bgeu	a4,a3,a2f630 <LzmaDec_TryDummy+0x388>
  a2f620:	4501                	li	a0,0
  a2f622:	0d15fe63          	bgeu	a1,a7,a2f6fe <LzmaDec_TryDummy+0x456>
  a2f626:	2194                	lbu	a3,0(a1)
  a2f628:	0722                	slli	a4,a4,0x8
  a2f62a:	0585                	addi	a1,a1,1
  a2f62c:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f630:	00b75693          	srli	a3,a4,0xb
  a2f634:	030686b3          	mul	a3,a3,a6
  a2f638:	fcd7e5e3          	bltu	a5,a3,a2f602 <LzmaDec_TryDummy+0x35a>
  a2f63c:	8f15                	sub	a4,a4,a3
  a2f63e:	8f95                	sub	a5,a5,a3
  a2f640:	010006b7          	lui	a3,0x1000
  a2f644:	048ed803          	lhu	a6,72(t4)
  a2f648:	00d77a63          	bgeu	a4,a3,a2f65c <LzmaDec_TryDummy+0x3b4>
  a2f64c:	4501                	li	a0,0
  a2f64e:	0b15f863          	bgeu	a1,a7,a2f6fe <LzmaDec_TryDummy+0x456>
  a2f652:	2194                	lbu	a3,0(a1)
  a2f654:	0722                	slli	a4,a4,0x8
  a2f656:	0585                	addi	a1,a1,1
  a2f658:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f65c:	00b75693          	srli	a3,a4,0xb
  a2f660:	030686b3          	mul	a3,a3,a6
  a2f664:	f8d7efe3          	bltu	a5,a3,a2f602 <LzmaDec_TryDummy+0x35a>
  a2f668:	8f95                	sub	a5,a5,a3
  a2f66a:	40d706b3          	sub	a3,a4,a3
  a2f66e:	bf51                	j	a2f602 <LzmaDec_TryDummy+0x35a>
  a2f670:	8e99                	sub	a3,a3,a4
  a2f672:	01000eb7          	lui	t4,0x1000
  a2f676:	8f99                	sub	a5,a5,a4
  a2f678:	01085703          	lhu	a4,16(a6)
  a2f67c:	01d6fa63          	bgeu	a3,t4,a2f690 <LzmaDec_TryDummy+0x3e8>
  a2f680:	0715fe63          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f684:	0005ce83          	lbu	t4,0(a1)
  a2f688:	06a2                	slli	a3,a3,0x8
  a2f68a:	0585                	addi	a1,a1,1
  a2f68c:	10fea79b          	orshf	a5,t4,a5,sll,8
  a2f690:	00b6de93          	srli	t4,a3,0xb
  a2f694:	02ee8733          	mul	a4,t4,a4
  a2f698:	00e7f763          	bgeu	a5,a4,a2f6a6 <LzmaDec_TryDummy+0x3fe>
  a2f69c:	0e21                	addi	t3,t3,8 # 80000008 <_gp_+0x7f5cb7c4>
  a2f69e:	03c8081b          	addshf	a6,a6,t3,sll,1
  a2f6a2:	46a1                	li	a3,8
  a2f6a4:	bbed                	j	a2f49e <LzmaDec_TryDummy+0x1f6>
  a2f6a6:	8f99                	sub	a5,a5,a4
  a2f6a8:	20080813          	addi	a6,a6,512
  a2f6ac:	40e68733          	sub	a4,a3,a4
  a2f6b0:	10000f13          	li	t5,256
  a2f6b4:	46c1                	li	a3,16
  a2f6b6:	b3ed                	j	a2f4a0 <LzmaDec_TryDummy+0x1f8>
  a2f6b8:	8776                	mv	a4,t4
  a2f6ba:	b505                	j	a2f4da <LzmaDec_TryDummy+0x232>
  a2f6bc:	8742                	mv	a4,a6
  a2f6be:	bda5                	j	a2f536 <LzmaDec_TryDummy+0x28e>
  a2f6c0:	186d                	addi	a6,a6,-5
  a2f6c2:	01000e37          	lui	t3,0x1000
  a2f6c6:	01c77963          	bgeu	a4,t3,a2f6d8 <LzmaDec_TryDummy+0x430>
  a2f6ca:	0315f963          	bgeu	a1,a7,a2f6fc <LzmaDec_TryDummy+0x454>
  a2f6ce:	2194                	lbu	a3,0(a1)
  a2f6d0:	0722                	slli	a4,a4,0x8
  a2f6d2:	0585                	addi	a1,a1,1
  a2f6d4:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f6d8:	8305                	srli	a4,a4,0x1
  a2f6da:	40e786b3          	sub	a3,a5,a4
  a2f6de:	82fd                	srli	a3,a3,0x1f
  a2f6e0:	16fd                	addi	a3,a3,-1 # ffffff <_gp_+0x5cb7bb>
  a2f6e2:	8ef9                	and	a3,a3,a4
  a2f6e4:	187d                	addi	a6,a6,-1
  a2f6e6:	8f95                	sub	a5,a5,a3
  a2f6e8:	fc081fe3          	bnez	a6,a2f6c6 <LzmaDec_TryDummy+0x41e>
  a2f6ec:	4811                	li	a6,4
  a2f6ee:	bd9d                	j	a2f564 <LzmaDec_TryDummy+0x2bc>
  a2f6f0:	8f15                	sub	a4,a4,a3
  a2f6f2:	8f95                	sub	a5,a5,a3
  a2f6f4:	9e7a                	add	t3,t3,t5
  a2f6f6:	b555                	j	a2f59a <LzmaDec_TryDummy+0x2f2>
  a2f6f8:	450d                	li	a0,3
  a2f6fa:	b15d                	j	a2f3a0 <LzmaDec_TryDummy+0xf8>
  a2f6fc:	4501                	li	a0,0
  a2f6fe:	8082                	ret

00a2f700 <LzmaDec_DecodeReal2>:
  a2f700:	711d                	addi	sp,sp,-96
  a2f702:	03010293          	addi	t0,sp,48
  a2f706:	7fe2960b          	stmia	{s0-s11},(t0)
  a2f70a:	02c52d83          	lw	s11,44(a0) # 100002c <_gp_+0x5cb7e8>
  a2f70e:	ce32                	sw	a2,28(sp)
  a2f710:	8e2a                	mv	t3,a0
  a2f712:	02852383          	lw	t2,40(a0)
  a2f716:	01852e83          	lw	t4,24(a0)
  a2f71a:	000d9b63          	bnez	s11,a2f730 <LzmaDec_DecodeReal2+0x30>
  a2f71e:	415c                	lw	a5,4(a0)
  a2f720:	41d58733          	sub	a4,a1,t4
  a2f724:	407787b3          	sub	a5,a5,t2
  a2f728:	00e7f463          	bgeu	a5,a4,a2f730 <LzmaDec_DecodeReal2+0x30>
  a2f72c:	01d785b3          	add	a1,a5,t4
  a2f730:	000e4783          	lbu	a5,0(t3) # 1000000 <_gp_+0x5cb7bc>
  a2f734:	001e4703          	lbu	a4,1(t3)
  a2f738:	002e4603          	lbu	a2,2(t3)
  a2f73c:	c63e                	sw	a5,12(sp)
  a2f73e:	46b2                	lw	a3,12(sp)
  a2f740:	10000793          	li	a5,256
  a2f744:	00e79733          	sll	a4,a5,a4
  a2f748:	00d7d7b3          	srl	a5,a5,a3
  a2f74c:	56fd                	li	a3,-1
  a2f74e:	00c696b3          	sll	a3,a3,a2
  a2f752:	fff6c693          	not	a3,a3
  a2f756:	cc36                	sw	a3,24(sp)
  a2f758:	800006b7          	lui	a3,0x80000
  a2f75c:	00ce2f83          	lw	t6,12(t3)
  a2f760:	f006c693          	xori	a3,a3,-256
  a2f764:	d036                	sw	a3,32(sp)
  a2f766:	76fd                	lui	a3,0xfffff
  a2f768:	60068693          	addi	a3,a3,1536 # fffff600 <_gp_+0xff5cadbc>
  a2f76c:	014e2c83          	lw	s9,20(t3)
  a2f770:	40f707b3          	sub	a5,a4,a5
  a2f774:	c836                	sw	a3,16(sp)
  a2f776:	96fe                	add	a3,a3,t6
  a2f778:	ca3e                	sw	a5,20(sp)
  a2f77a:	d236                	sw	a3,36(sp)
  a2f77c:	040e2f03          	lw	t5,64(t3)
  a2f780:	a00f8693          	addi	a3,t6,-1536 # fffa00 <_gp_+0x5cb1bc>
  a2f784:	030e2283          	lw	t0,48(t3)
  a2f788:	034e2403          	lw	s0,52(t3)
  a2f78c:	038e2983          	lw	s3,56(t3)
  a2f790:	03ce2d03          	lw	s10,60(t3)
  a2f794:	010e2a03          	lw	s4,16(t3)
  a2f798:	01ce2703          	lw	a4,28(t3)
  a2f79c:	020e2903          	lw	s2,32(t3)
  a2f7a0:	024e2783          	lw	a5,36(t3)
  a2f7a4:	d436                	sw	a3,40(sp)
  a2f7a6:	fffc8693          	addi	a3,s9,-1
  a2f7aa:	4881                	li	a7,0
  a2f7ac:	01000637          	lui	a2,0x1000
  a2f7b0:	0000 0800 081f      	l.li	a6,0x800
  a2f7b6:	d636                	sw	a3,44(sp)
  a2f7b8:	46e2                	lw	a3,24(sp)
  a2f7ba:	0076f533          	and	a0,a3,t2
  a2f7be:	5682                	lw	a3,32(sp)
  a2f7c0:	0512                	slli	a0,a0,0x4
  a2f7c2:	01e504b3          	add	s1,a0,t5
  a2f7c6:	94b6                	add	s1,s1,a3
  a2f7c8:	0486                	slli	s1,s1,0x1
  a2f7ca:	009f8ab3          	add	s5,t6,s1
  a2f7ce:	000ad303          	lhu	t1,0(s5)
  a2f7d2:	00c97763          	bgeu	s2,a2,a2f7e0 <LzmaDec_DecodeReal2+0xe0>
  a2f7d6:	2314                	lbu	a3,0(a4)
  a2f7d8:	0922                	slli	s2,s2,0x8
  a2f7da:	0705                	addi	a4,a4,1 # fffff001 <_gp_+0xff5ca7bd>
  a2f7dc:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2f7e0:	00b95693          	srli	a3,s2,0xb
  a2f7e4:	026686b3          	mul	a3,a3,t1
  a2f7e8:	54d7fb63          	bgeu	a5,a3,a2fd3e <LzmaDec_DecodeReal2+0x63e>
  a2f7ec:	40680533          	sub	a0,a6,t1
  a2f7f0:	4aa3031b          	addshf	t1,t1,a0,srl,5
  a2f7f4:	006a9023          	sh	t1,0(s5)
  a2f7f8:	280f8513          	addi	a0,t6,640
  a2f7fc:	00039463          	bnez	t2,a2f804 <LzmaDec_DecodeReal2+0x104>
  a2f800:	020d8563          	beqz	s11,a2f82a <LzmaDec_DecodeReal2+0x12a>
  a2f804:	00839493          	slli	s1,t2,0x8
  a2f808:	fffe8313          	addi	t1,t4,-1 # ffffff <_gp_+0x5cb7bb>
  a2f80c:	000e9363          	bnez	t4,a2f812 <LzmaDec_DecodeReal2+0x112>
  a2f810:	5332                	lw	t1,44(sp)
  a2f812:	9352                	add	t1,t1,s4
  a2f814:	00034303          	lbu	t1,0(t1)
  a2f818:	9326                	add	t1,t1,s1
  a2f81a:	44d2                	lw	s1,20(sp)
  a2f81c:	00937333          	and	t1,t1,s1
  a2f820:	44b2                	lw	s1,12(sp)
  a2f822:	00931333          	sll	t1,t1,s1
  a2f826:	0665155b          	muliadd	a0,a0,t1,6
  a2f82a:	0385                	addi	t2,t2,1
  a2f82c:	431d                	li	t1,7
  a2f82e:	246f7163          	bgeu	t5,t1,a2fa70 <LzmaDec_DecodeReal2+0x370>
  a2f832:	448d                	li	s1,3
  a2f834:	837a                	mv	t1,t5
  a2f836:	01e4f363          	bgeu	s1,t5,a2f83c <LzmaDec_DecodeReal2+0x13c>
  a2f83a:	430d                	li	t1,3
  a2f83c:	406f0f33          	sub	t5,t5,t1
  a2f840:	00255303          	lhu	t1,2(a0)
  a2f844:	00c6f763          	bgeu	a3,a2,a2f852 <LzmaDec_DecodeReal2+0x152>
  a2f848:	2304                	lbu	s1,0(a4)
  a2f84a:	06a2                	slli	a3,a3,0x8
  a2f84c:	0705                	addi	a4,a4,1
  a2f84e:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2f852:	00b6d493          	srli	s1,a3,0xb
  a2f856:	026484b3          	mul	s1,s1,t1
  a2f85a:	1697ff63          	bgeu	a5,s1,a2f9d8 <LzmaDec_DecodeReal2+0x2d8>
  a2f85e:	406806b3          	sub	a3,a6,t1
  a2f862:	4ad3031b          	addshf	t1,t1,a3,srl,5
  a2f866:	00651123          	sh	t1,2(a0)
  a2f86a:	4689                	li	a3,2
  a2f86c:	0686                	slli	a3,a3,0x1
  a2f86e:	00d50ab3          	add	s5,a0,a3
  a2f872:	000ad903          	lhu	s2,0(s5)
  a2f876:	00c4f863          	bgeu	s1,a2,a2f886 <LzmaDec_DecodeReal2+0x186>
  a2f87a:	00074303          	lbu	t1,0(a4)
  a2f87e:	04a2                	slli	s1,s1,0x8
  a2f880:	0705                	addi	a4,a4,1
  a2f882:	10f3279b          	orshf	a5,t1,a5,sll,8
  a2f886:	00b4d313          	srli	t1,s1,0xb
  a2f88a:	03230333          	mul	t1,t1,s2
  a2f88e:	1467fe63          	bgeu	a5,t1,a2f9ea <LzmaDec_DecodeReal2+0x2ea>
  a2f892:	412804b3          	sub	s1,a6,s2
  a2f896:	4a99091b          	addshf	s2,s2,s1,srl,5
  a2f89a:	012a9023          	sh	s2,0(s5)
  a2f89e:	0686                	slli	a3,a3,0x1
  a2f8a0:	00d50ab3          	add	s5,a0,a3
  a2f8a4:	000ad903          	lhu	s2,0(s5)
  a2f8a8:	00c37763          	bgeu	t1,a2,a2f8b6 <LzmaDec_DecodeReal2+0x1b6>
  a2f8ac:	2304                	lbu	s1,0(a4)
  a2f8ae:	0322                	slli	t1,t1,0x8
  a2f8b0:	0705                	addi	a4,a4,1
  a2f8b2:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2f8b6:	00b35493          	srli	s1,t1,0xb
  a2f8ba:	032484b3          	mul	s1,s1,s2
  a2f8be:	1497f063          	bgeu	a5,s1,a2f9fe <LzmaDec_DecodeReal2+0x2fe>
  a2f8c2:	41280333          	sub	t1,a6,s2
  a2f8c6:	4a69091b          	addshf	s2,s2,t1,srl,5
  a2f8ca:	012a9023          	sh	s2,0(s5)
  a2f8ce:	0686                	slli	a3,a3,0x1
  a2f8d0:	00d50ab3          	add	s5,a0,a3
  a2f8d4:	000ad903          	lhu	s2,0(s5)
  a2f8d8:	00c4f863          	bgeu	s1,a2,a2f8e8 <LzmaDec_DecodeReal2+0x1e8>
  a2f8dc:	00074303          	lbu	t1,0(a4)
  a2f8e0:	04a2                	slli	s1,s1,0x8
  a2f8e2:	0705                	addi	a4,a4,1
  a2f8e4:	10f3279b          	orshf	a5,t1,a5,sll,8
  a2f8e8:	00b4d313          	srli	t1,s1,0xb
  a2f8ec:	03230333          	mul	t1,t1,s2
  a2f8f0:	1267f063          	bgeu	a5,t1,a2fa10 <LzmaDec_DecodeReal2+0x310>
  a2f8f4:	412804b3          	sub	s1,a6,s2
  a2f8f8:	4a99091b          	addshf	s2,s2,s1,srl,5
  a2f8fc:	012a9023          	sh	s2,0(s5)
  a2f900:	0686                	slli	a3,a3,0x1
  a2f902:	00d50ab3          	add	s5,a0,a3
  a2f906:	000ad903          	lhu	s2,0(s5)
  a2f90a:	00c37763          	bgeu	t1,a2,a2f918 <LzmaDec_DecodeReal2+0x218>
  a2f90e:	2304                	lbu	s1,0(a4)
  a2f910:	0322                	slli	t1,t1,0x8
  a2f912:	0705                	addi	a4,a4,1
  a2f914:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2f918:	00b35493          	srli	s1,t1,0xb
  a2f91c:	032484b3          	mul	s1,s1,s2
  a2f920:	1097f263          	bgeu	a5,s1,a2fa24 <LzmaDec_DecodeReal2+0x324>
  a2f924:	41280333          	sub	t1,a6,s2
  a2f928:	4a69091b          	addshf	s2,s2,t1,srl,5
  a2f92c:	012a9023          	sh	s2,0(s5)
  a2f930:	0686                	slli	a3,a3,0x1
  a2f932:	00d50ab3          	add	s5,a0,a3
  a2f936:	000ad903          	lhu	s2,0(s5)
  a2f93a:	00c4f863          	bgeu	s1,a2,a2f94a <LzmaDec_DecodeReal2+0x24a>
  a2f93e:	00074303          	lbu	t1,0(a4)
  a2f942:	04a2                	slli	s1,s1,0x8
  a2f944:	0705                	addi	a4,a4,1
  a2f946:	10f3279b          	orshf	a5,t1,a5,sll,8
  a2f94a:	00b4d313          	srli	t1,s1,0xb
  a2f94e:	03230333          	mul	t1,t1,s2
  a2f952:	0e67f263          	bgeu	a5,t1,a2fa36 <LzmaDec_DecodeReal2+0x336>
  a2f956:	412804b3          	sub	s1,a6,s2
  a2f95a:	4a99091b          	addshf	s2,s2,s1,srl,5
  a2f95e:	012a9023          	sh	s2,0(s5)
  a2f962:	0686                	slli	a3,a3,0x1
  a2f964:	00d50ab3          	add	s5,a0,a3
  a2f968:	000ad903          	lhu	s2,0(s5)
  a2f96c:	00c37763          	bgeu	t1,a2,a2f97a <LzmaDec_DecodeReal2+0x27a>
  a2f970:	2304                	lbu	s1,0(a4)
  a2f972:	0322                	slli	t1,t1,0x8
  a2f974:	0705                	addi	a4,a4,1
  a2f976:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2f97a:	00b35493          	srli	s1,t1,0xb
  a2f97e:	032484b3          	mul	s1,s1,s2
  a2f982:	0c97f463          	bgeu	a5,s1,a2fa4a <LzmaDec_DecodeReal2+0x34a>
  a2f986:	41280333          	sub	t1,a6,s2
  a2f98a:	4a69091b          	addshf	s2,s2,t1,srl,5
  a2f98e:	012a9023          	sh	s2,0(s5)
  a2f992:	0686                	slli	a3,a3,0x1
  a2f994:	9536                	add	a0,a0,a3
  a2f996:	00055a83          	lhu	s5,0(a0)
  a2f99a:	00c4f863          	bgeu	s1,a2,a2f9aa <LzmaDec_DecodeReal2+0x2aa>
  a2f99e:	00074303          	lbu	t1,0(a4)
  a2f9a2:	04a2                	slli	s1,s1,0x8
  a2f9a4:	0705                	addi	a4,a4,1
  a2f9a6:	10f3279b          	orshf	a5,t1,a5,sll,8
  a2f9aa:	00b4d913          	srli	s2,s1,0xb
  a2f9ae:	03590933          	mul	s2,s2,s5
  a2f9b2:	0b27f563          	bgeu	a5,s2,a2fa5c <LzmaDec_DecodeReal2+0x35c>
  a2f9b6:	41580333          	sub	t1,a6,s5
  a2f9ba:	4a6a8a9b          	addshf	s5,s5,t1,srl,5
  a2f9be:	01551023          	sh	s5,0(a0)
  a2f9c2:	01da0533          	add	a0,s4,t4
  a2f9c6:	a114                	sb	a3,0(a0)
  a2f9c8:	0e85                	addi	t4,t4,1
  a2f9ca:	30bef9e3          	bgeu	t4,a1,a304dc <LzmaDec_DecodeReal2+0xddc>
  a2f9ce:	46f2                	lw	a3,28(sp)
  a2f9d0:	ded764e3          	bltu	a4,a3,a2f7b8 <LzmaDec_DecodeReal2+0xb8>
  a2f9d4:	3090006f          	j	a304dc <LzmaDec_DecodeReal2+0xddc>
  a2f9d8:	4a63131b          	subshf	t1,t1,t1,srl,5
  a2f9dc:	8f85                	sub	a5,a5,s1
  a2f9de:	00651123          	sh	t1,2(a0)
  a2f9e2:	409684b3          	sub	s1,a3,s1
  a2f9e6:	468d                	li	a3,3
  a2f9e8:	b551                	j	a2f86c <LzmaDec_DecodeReal2+0x16c>
  a2f9ea:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2f9ee:	406787b3          	sub	a5,a5,t1
  a2f9f2:	012a9023          	sh	s2,0(s5)
  a2f9f6:	0685                	addi	a3,a3,1
  a2f9f8:	40648333          	sub	t1,s1,t1
  a2f9fc:	b54d                	j	a2f89e <LzmaDec_DecodeReal2+0x19e>
  a2f9fe:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2fa02:	8f85                	sub	a5,a5,s1
  a2fa04:	012a9023          	sh	s2,0(s5)
  a2fa08:	0685                	addi	a3,a3,1
  a2fa0a:	409304b3          	sub	s1,t1,s1
  a2fa0e:	b5c1                	j	a2f8ce <LzmaDec_DecodeReal2+0x1ce>
  a2fa10:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2fa14:	406787b3          	sub	a5,a5,t1
  a2fa18:	012a9023          	sh	s2,0(s5)
  a2fa1c:	0685                	addi	a3,a3,1
  a2fa1e:	40648333          	sub	t1,s1,t1
  a2fa22:	bdf9                	j	a2f900 <LzmaDec_DecodeReal2+0x200>
  a2fa24:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2fa28:	8f85                	sub	a5,a5,s1
  a2fa2a:	012a9023          	sh	s2,0(s5)
  a2fa2e:	0685                	addi	a3,a3,1
  a2fa30:	409304b3          	sub	s1,t1,s1
  a2fa34:	bdf5                	j	a2f930 <LzmaDec_DecodeReal2+0x230>
  a2fa36:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2fa3a:	406787b3          	sub	a5,a5,t1
  a2fa3e:	012a9023          	sh	s2,0(s5)
  a2fa42:	0685                	addi	a3,a3,1
  a2fa44:	40648333          	sub	t1,s1,t1
  a2fa48:	bf29                	j	a2f962 <LzmaDec_DecodeReal2+0x262>
  a2fa4a:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2fa4e:	8f85                	sub	a5,a5,s1
  a2fa50:	012a9023          	sh	s2,0(s5)
  a2fa54:	0685                	addi	a3,a3,1
  a2fa56:	409304b3          	sub	s1,t1,s1
  a2fa5a:	bf25                	j	a2f992 <LzmaDec_DecodeReal2+0x292>
  a2fa5c:	4b5a9a9b          	subshf	s5,s5,s5,srl,5
  a2fa60:	412787b3          	sub	a5,a5,s2
  a2fa64:	01551023          	sh	s5,0(a0)
  a2fa68:	0685                	addi	a3,a3,1
  a2fa6a:	41248933          	sub	s2,s1,s2
  a2fa6e:	bf91                	j	a2f9c2 <LzmaDec_DecodeReal2+0x2c2>
  a2fa70:	405e8333          	sub	t1,t4,t0
  a2fa74:	4481                	li	s1,0
  a2fa76:	005ef363          	bgeu	t4,t0,a2fa7c <LzmaDec_DecodeReal2+0x37c>
  a2fa7a:	84e6                	mv	s1,s9
  a2fa7c:	9352                	add	t1,t1,s4
  a2fa7e:	9326                	add	t1,t1,s1
  a2fa80:	00034303          	lbu	t1,0(t1)
  a2fa84:	4499                	li	s1,6
  a2fa86:	0a0f71bb          	bgeui	t5,10,a2fa8c <LzmaDec_DecodeReal2+0x38c>
  a2fa8a:	448d                	li	s1,3
  a2fa8c:	0306                	slli	t1,t1,0x1
  a2fa8e:	10037b93          	andi	s7,t1,256
  a2fa92:	101b8a93          	addi	s5,s7,257
  a2fa96:	03550a9b          	addshf	s5,a0,s5,sll,1
  a2fa9a:	409f0f33          	sub	t5,t5,s1
  a2fa9e:	000ad903          	lhu	s2,0(s5)
  a2faa2:	00c6f763          	bgeu	a3,a2,a2fab0 <LzmaDec_DecodeReal2+0x3b0>
  a2faa6:	2304                	lbu	s1,0(a4)
  a2faa8:	06a2                	slli	a3,a3,0x8
  a2faaa:	0705                	addi	a4,a4,1
  a2faac:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2fab0:	00b6d493          	srli	s1,a3,0xb
  a2fab4:	032484b3          	mul	s1,s1,s2
  a2fab8:	1e97fa63          	bgeu	a5,s1,a2fcac <LzmaDec_DecodeReal2+0x5ac>
  a2fabc:	412806b3          	sub	a3,a6,s2
  a2fac0:	4ad9091b          	addshf	s2,s2,a3,srl,5
  a2fac4:	fff34b93          	not	s7,t1
  a2fac8:	012a9023          	sh	s2,0(s5)
  a2facc:	100bfb93          	andi	s7,s7,256
  a2fad0:	4689                	li	a3,2
  a2fad2:	0306                	slli	t1,t1,0x1
  a2fad4:	01737c33          	and	s8,t1,s7
  a2fad8:	00db8ab3          	add	s5,s7,a3
  a2fadc:	9ae2                	add	s5,s5,s8
  a2fade:	03550a9b          	addshf	s5,a0,s5,sll,1
  a2fae2:	000adb03          	lhu	s6,0(s5)
  a2fae6:	00c4f863          	bgeu	s1,a2,a2faf6 <LzmaDec_DecodeReal2+0x3f6>
  a2faea:	00074903          	lbu	s2,0(a4)
  a2faee:	04a2                	slli	s1,s1,0x8
  a2faf0:	0705                	addi	a4,a4,1
  a2faf2:	10f9279b          	orshf	a5,s2,a5,sll,8
  a2faf6:	00b4d913          	srli	s2,s1,0xb
  a2fafa:	03690933          	mul	s2,s2,s6
  a2fafe:	0686                	slli	a3,a3,0x1
  a2fb00:	1b27ff63          	bgeu	a5,s2,a2fcbe <LzmaDec_DecodeReal2+0x5be>
  a2fb04:	416804b3          	sub	s1,a6,s6
  a2fb08:	4a9b0b1b          	addshf	s6,s6,s1,srl,5
  a2fb0c:	fff34c13          	not	s8,t1
  a2fb10:	016a9023          	sh	s6,0(s5)
  a2fb14:	017c7c33          	and	s8,s8,s7
  a2fb18:	0306                	slli	t1,t1,0x1
  a2fb1a:	01837bb3          	and	s7,t1,s8
  a2fb1e:	00dc0ab3          	add	s5,s8,a3
  a2fb22:	9ade                	add	s5,s5,s7
  a2fb24:	03550a9b          	addshf	s5,a0,s5,sll,1
  a2fb28:	000adb03          	lhu	s6,0(s5)
  a2fb2c:	00c97763          	bgeu	s2,a2,a2fb3a <LzmaDec_DecodeReal2+0x43a>
  a2fb30:	2304                	lbu	s1,0(a4)
  a2fb32:	0922                	slli	s2,s2,0x8
  a2fb34:	0705                	addi	a4,a4,1
  a2fb36:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2fb3a:	00b95493          	srli	s1,s2,0xb
  a2fb3e:	036484b3          	mul	s1,s1,s6
  a2fb42:	0686                	slli	a3,a3,0x1
  a2fb44:	1897f763          	bgeu	a5,s1,a2fcd2 <LzmaDec_DecodeReal2+0x5d2>
  a2fb48:	41680933          	sub	s2,a6,s6
  a2fb4c:	4b2b0b1b          	addshf	s6,s6,s2,srl,5
  a2fb50:	fff34b93          	not	s7,t1
  a2fb54:	016a9023          	sh	s6,0(s5)
  a2fb58:	018bfbb3          	and	s7,s7,s8
  a2fb5c:	0306                	slli	t1,t1,0x1
  a2fb5e:	01737c33          	and	s8,t1,s7
  a2fb62:	00db8ab3          	add	s5,s7,a3
  a2fb66:	9ae2                	add	s5,s5,s8
  a2fb68:	03550a9b          	addshf	s5,a0,s5,sll,1
  a2fb6c:	000adb03          	lhu	s6,0(s5)
  a2fb70:	00c4f863          	bgeu	s1,a2,a2fb80 <LzmaDec_DecodeReal2+0x480>
  a2fb74:	00074903          	lbu	s2,0(a4)
  a2fb78:	04a2                	slli	s1,s1,0x8
  a2fb7a:	0705                	addi	a4,a4,1
  a2fb7c:	10f9279b          	orshf	a5,s2,a5,sll,8
  a2fb80:	00b4d913          	srli	s2,s1,0xb
  a2fb84:	03690933          	mul	s2,s2,s6
  a2fb88:	0686                	slli	a3,a3,0x1
  a2fb8a:	1527fd63          	bgeu	a5,s2,a2fce4 <LzmaDec_DecodeReal2+0x5e4>
  a2fb8e:	416804b3          	sub	s1,a6,s6
  a2fb92:	4a9b0b1b          	addshf	s6,s6,s1,srl,5
  a2fb96:	fff34c13          	not	s8,t1
  a2fb9a:	016a9023          	sh	s6,0(s5)
  a2fb9e:	017c7c33          	and	s8,s8,s7
  a2fba2:	0306                	slli	t1,t1,0x1
  a2fba4:	01837bb3          	and	s7,t1,s8
  a2fba8:	00dc0ab3          	add	s5,s8,a3
  a2fbac:	9ade                	add	s5,s5,s7
  a2fbae:	03550a9b          	addshf	s5,a0,s5,sll,1
  a2fbb2:	000adb03          	lhu	s6,0(s5)
  a2fbb6:	00c97763          	bgeu	s2,a2,a2fbc4 <LzmaDec_DecodeReal2+0x4c4>
  a2fbba:	2304                	lbu	s1,0(a4)
  a2fbbc:	0922                	slli	s2,s2,0x8
  a2fbbe:	0705                	addi	a4,a4,1
  a2fbc0:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2fbc4:	00b95493          	srli	s1,s2,0xb
  a2fbc8:	036484b3          	mul	s1,s1,s6
  a2fbcc:	0686                	slli	a3,a3,0x1
  a2fbce:	1297f563          	bgeu	a5,s1,a2fcf8 <LzmaDec_DecodeReal2+0x5f8>
  a2fbd2:	41680933          	sub	s2,a6,s6
  a2fbd6:	4b2b0b1b          	addshf	s6,s6,s2,srl,5
  a2fbda:	fff34b93          	not	s7,t1
  a2fbde:	016a9023          	sh	s6,0(s5)
  a2fbe2:	018bfbb3          	and	s7,s7,s8
  a2fbe6:	0306                	slli	t1,t1,0x1
  a2fbe8:	01737c33          	and	s8,t1,s7
  a2fbec:	00db8ab3          	add	s5,s7,a3
  a2fbf0:	9ae2                	add	s5,s5,s8
  a2fbf2:	03550a9b          	addshf	s5,a0,s5,sll,1
  a2fbf6:	000adb03          	lhu	s6,0(s5)
  a2fbfa:	00c4f863          	bgeu	s1,a2,a2fc0a <LzmaDec_DecodeReal2+0x50a>
  a2fbfe:	00074903          	lbu	s2,0(a4)
  a2fc02:	04a2                	slli	s1,s1,0x8
  a2fc04:	0705                	addi	a4,a4,1
  a2fc06:	10f9279b          	orshf	a5,s2,a5,sll,8
  a2fc0a:	00b4d913          	srli	s2,s1,0xb
  a2fc0e:	03690933          	mul	s2,s2,s6
  a2fc12:	0686                	slli	a3,a3,0x1
  a2fc14:	0f27fb63          	bgeu	a5,s2,a2fd0a <LzmaDec_DecodeReal2+0x60a>
  a2fc18:	416804b3          	sub	s1,a6,s6
  a2fc1c:	4a9b0b1b          	addshf	s6,s6,s1,srl,5
  a2fc20:	fff34c13          	not	s8,t1
  a2fc24:	016a9023          	sh	s6,0(s5)
  a2fc28:	017c7c33          	and	s8,s8,s7
  a2fc2c:	0306                	slli	t1,t1,0x1
  a2fc2e:	01837ab3          	and	s5,t1,s8
  a2fc32:	00dc0b33          	add	s6,s8,a3
  a2fc36:	9b56                	add	s6,s6,s5
  a2fc38:	03650b1b          	addshf	s6,a0,s6,sll,1
  a2fc3c:	000b5b83          	lhu	s7,0(s6) # 1000 <ccause+0x3e>
  a2fc40:	00c97763          	bgeu	s2,a2,a2fc4e <LzmaDec_DecodeReal2+0x54e>
  a2fc44:	2304                	lbu	s1,0(a4)
  a2fc46:	0922                	slli	s2,s2,0x8
  a2fc48:	0705                	addi	a4,a4,1
  a2fc4a:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a2fc4e:	00b95493          	srli	s1,s2,0xb
  a2fc52:	037484b3          	mul	s1,s1,s7
  a2fc56:	0686                	slli	a3,a3,0x1
  a2fc58:	0c97f363          	bgeu	a5,s1,a2fd1e <LzmaDec_DecodeReal2+0x61e>
  a2fc5c:	41780933          	sub	s2,a6,s7
  a2fc60:	4b2b8b9b          	addshf	s7,s7,s2,srl,5
  a2fc64:	fff34a93          	not	s5,t1
  a2fc68:	017b1023          	sh	s7,0(s6)
  a2fc6c:	018afab3          	and	s5,s5,s8
  a2fc70:	026ac31b          	andshf	t1,s5,t1,sll,1
  a2fc74:	9ab6                	add	s5,s5,a3
  a2fc76:	9356                	add	t1,t1,s5
  a2fc78:	0265051b          	addshf	a0,a0,t1,sll,1
  a2fc7c:	00055303          	lhu	t1,0(a0)
  a2fc80:	00c4f863          	bgeu	s1,a2,a2fc90 <LzmaDec_DecodeReal2+0x590>
  a2fc84:	00074903          	lbu	s2,0(a4)
  a2fc88:	04a2                	slli	s1,s1,0x8
  a2fc8a:	0705                	addi	a4,a4,1
  a2fc8c:	10f9279b          	orshf	a5,s2,a5,sll,8
  a2fc90:	00b4d913          	srli	s2,s1,0xb
  a2fc94:	02690933          	mul	s2,s2,t1
  a2fc98:	0686                	slli	a3,a3,0x1
  a2fc9a:	0927fb63          	bgeu	a5,s2,a2fd30 <LzmaDec_DecodeReal2+0x630>
  a2fc9e:	406804b3          	sub	s1,a6,t1
  a2fca2:	4a93031b          	addshf	t1,t1,s1,srl,5
  a2fca6:	00651023          	sh	t1,0(a0)
  a2fcaa:	bb21                	j	a2f9c2 <LzmaDec_DecodeReal2+0x2c2>
  a2fcac:	4b29191b          	subshf	s2,s2,s2,srl,5
  a2fcb0:	8f85                	sub	a5,a5,s1
  a2fcb2:	012a9023          	sh	s2,0(s5)
  a2fcb6:	409684b3          	sub	s1,a3,s1
  a2fcba:	468d                	li	a3,3
  a2fcbc:	bd19                	j	a2fad2 <LzmaDec_DecodeReal2+0x3d2>
  a2fcbe:	4b6b1b1b          	subshf	s6,s6,s6,srl,5
  a2fcc2:	412787b3          	sub	a5,a5,s2
  a2fcc6:	016a9023          	sh	s6,0(s5)
  a2fcca:	0685                	addi	a3,a3,1
  a2fccc:	41248933          	sub	s2,s1,s2
  a2fcd0:	b5a1                	j	a2fb18 <LzmaDec_DecodeReal2+0x418>
  a2fcd2:	4b6b1b1b          	subshf	s6,s6,s6,srl,5
  a2fcd6:	8f85                	sub	a5,a5,s1
  a2fcd8:	016a9023          	sh	s6,0(s5)
  a2fcdc:	0685                	addi	a3,a3,1
  a2fcde:	409904b3          	sub	s1,s2,s1
  a2fce2:	bdad                	j	a2fb5c <LzmaDec_DecodeReal2+0x45c>
  a2fce4:	4b6b1b1b          	subshf	s6,s6,s6,srl,5
  a2fce8:	412787b3          	sub	a5,a5,s2
  a2fcec:	016a9023          	sh	s6,0(s5)
  a2fcf0:	0685                	addi	a3,a3,1
  a2fcf2:	41248933          	sub	s2,s1,s2
  a2fcf6:	b575                	j	a2fba2 <LzmaDec_DecodeReal2+0x4a2>
  a2fcf8:	4b6b1b1b          	subshf	s6,s6,s6,srl,5
  a2fcfc:	8f85                	sub	a5,a5,s1
  a2fcfe:	016a9023          	sh	s6,0(s5)
  a2fd02:	0685                	addi	a3,a3,1
  a2fd04:	409904b3          	sub	s1,s2,s1
  a2fd08:	bdf9                	j	a2fbe6 <LzmaDec_DecodeReal2+0x4e6>
  a2fd0a:	4b6b1b1b          	subshf	s6,s6,s6,srl,5
  a2fd0e:	412787b3          	sub	a5,a5,s2
  a2fd12:	016a9023          	sh	s6,0(s5)
  a2fd16:	0685                	addi	a3,a3,1
  a2fd18:	41248933          	sub	s2,s1,s2
  a2fd1c:	bf01                	j	a2fc2c <LzmaDec_DecodeReal2+0x52c>
  a2fd1e:	4b7b9b9b          	subshf	s7,s7,s7,srl,5
  a2fd22:	8f85                	sub	a5,a5,s1
  a2fd24:	017b1023          	sh	s7,0(s6)
  a2fd28:	0685                	addi	a3,a3,1
  a2fd2a:	409904b3          	sub	s1,s2,s1
  a2fd2e:	b789                	j	a2fc70 <LzmaDec_DecodeReal2+0x570>
  a2fd30:	4a63131b          	subshf	t1,t1,t1,srl,5
  a2fd34:	412787b3          	sub	a5,a5,s2
  a2fd38:	00651023          	sh	t1,0(a0)
  a2fd3c:	b335                	j	a2fa68 <LzmaDec_DecodeReal2+0x368>
  a2fd3e:	4a63131b          	subshf	t1,t1,t1,srl,5
  a2fd42:	006a9023          	sh	t1,0(s5)
  a2fd46:	010f0313          	addi	t1,t5,16
  a2fd4a:	0306                	slli	t1,t1,0x1
  a2fd4c:	006f8b33          	add	s6,t6,t1
  a2fd50:	40d90933          	sub	s2,s2,a3
  a2fd54:	8f95                	sub	a5,a5,a3
  a2fd56:	000b5a83          	lhu	s5,0(s6)
  a2fd5a:	00c97763          	bgeu	s2,a2,a2fd68 <LzmaDec_DecodeReal2+0x668>
  a2fd5e:	2314                	lbu	a3,0(a4)
  a2fd60:	0922                	slli	s2,s2,0x8
  a2fd62:	0705                	addi	a4,a4,1
  a2fd64:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2fd68:	00b95693          	srli	a3,s2,0xb
  a2fd6c:	035686b3          	mul	a3,a3,s5
  a2fd70:	12d7f363          	bgeu	a5,a3,a2fe96 <LzmaDec_DecodeReal2+0x796>
  a2fd74:	415808b3          	sub	a7,a6,s5
  a2fd78:	5322                	lw	t1,40(sp)
  a2fd7a:	4b1a8a9b          	addshf	s5,s5,a7,srl,5
  a2fd7e:	015b1023          	sh	s5,0(s6)
  a2fd82:	0f31                	addi	t5,t5,12
  a2fd84:	00035483          	lhu	s1,0(t1)
  a2fd88:	00c6f863          	bgeu	a3,a2,a2fd98 <LzmaDec_DecodeReal2+0x698>
  a2fd8c:	00074883          	lbu	a7,0(a4)
  a2fd90:	06a2                	slli	a3,a3,0x8
  a2fd92:	0705                	addi	a4,a4,1
  a2fd94:	10f8a79b          	orshf	a5,a7,a5,sll,8
  a2fd98:	00b6d893          	srli	a7,a3,0xb
  a2fd9c:	029888b3          	mul	a7,a7,s1
  a2fda0:	2917f463          	bgeu	a5,a7,a30028 <LzmaDec_DecodeReal2+0x928>
  a2fda4:	409806b3          	sub	a3,a6,s1
  a2fda8:	4ad4849b          	addshf	s1,s1,a3,srl,5
  a2fdac:	00931023          	sh	s1,0(t1)
  a2fdb0:	02a3051b          	addshf	a0,t1,a0,sll,1
  a2fdb4:	2136                	lhu	a3,2(a0)
  a2fdb6:	00c8f863          	bgeu	a7,a2,a2fdc6 <LzmaDec_DecodeReal2+0x6c6>
  a2fdba:	00074303          	lbu	t1,0(a4)
  a2fdbe:	08a2                	slli	a7,a7,0x8
  a2fdc0:	0705                	addi	a4,a4,1
  a2fdc2:	10f3279b          	orshf	a5,t1,a5,sll,8
  a2fdc6:	00b8d493          	srli	s1,a7,0xb
  a2fdca:	02d484b3          	mul	s1,s1,a3
  a2fdce:	2297f263          	bgeu	a5,s1,a2fff2 <LzmaDec_DecodeReal2+0x8f2>
  a2fdd2:	40d808b3          	sub	a7,a6,a3
  a2fdd6:	4b16869b          	addshf	a3,a3,a7,srl,5
  a2fdda:	a136                	sh	a3,2(a0)
  a2fddc:	4689                	li	a3,2
  a2fdde:	0686                	slli	a3,a3,0x1
  a2fde0:	00d50933          	add	s2,a0,a3
  a2fde4:	00095303          	lhu	t1,0(s2)
  a2fde8:	00c4f863          	bgeu	s1,a2,a2fdf8 <LzmaDec_DecodeReal2+0x6f8>
  a2fdec:	00074883          	lbu	a7,0(a4)
  a2fdf0:	04a2                	slli	s1,s1,0x8
  a2fdf2:	0705                	addi	a4,a4,1
  a2fdf4:	10f8a79b          	orshf	a5,a7,a5,sll,8
  a2fdf8:	00b4d893          	srli	a7,s1,0xb
  a2fdfc:	026888b3          	mul	a7,a7,t1
  a2fe00:	2117f163          	bgeu	a5,a7,a30002 <LzmaDec_DecodeReal2+0x902>
  a2fe04:	406804b3          	sub	s1,a6,t1
  a2fe08:	4a93031b          	addshf	t1,t1,s1,srl,5
  a2fe0c:	00691023          	sh	t1,0(s2)
  a2fe10:	0686                	slli	a3,a3,0x1
  a2fe12:	9536                	add	a0,a0,a3
  a2fe14:	2106                	lhu	s1,0(a0)
  a2fe16:	00c8f863          	bgeu	a7,a2,a2fe26 <LzmaDec_DecodeReal2+0x726>
  a2fe1a:	00074303          	lbu	t1,0(a4)
  a2fe1e:	08a2                	slli	a7,a7,0x8
  a2fe20:	0705                	addi	a4,a4,1
  a2fe22:	10f3279b          	orshf	a5,t1,a5,sll,8
  a2fe26:	00b8d913          	srli	s2,a7,0xb
  a2fe2a:	02990933          	mul	s2,s2,s1
  a2fe2e:	1f27f463          	bgeu	a5,s2,a30016 <LzmaDec_DecodeReal2+0x916>
  a2fe32:	409808b3          	sub	a7,a6,s1
  a2fe36:	4b14849b          	addshf	s1,s1,a7,srl,5
  a2fe3a:	a106                	sh	s1,0(a0)
  a2fe3c:	452d                	li	a0,11
  a2fe3e:	ff868893          	addi	a7,a3,-8
  a2fe42:	35e56a63          	bltu	a0,t5,a30196 <LzmaDec_DecodeReal2+0xa96>
  a2fe46:	41d586b3          	sub	a3,a1,t4
  a2fe4a:	0889                	addi	a7,a7,2
  a2fe4c:	68068863          	beqz	a3,a304dc <LzmaDec_DecodeReal2+0xddc>
  a2fe50:	8546                	mv	a0,a7
  a2fe52:	0116f363          	bgeu	a3,a7,a2fe58 <LzmaDec_DecodeReal2+0x758>
  a2fe56:	8536                	mv	a0,a3
  a2fe58:	405e8333          	sub	t1,t4,t0
  a2fe5c:	4681                	li	a3,0
  a2fe5e:	005ef363          	bgeu	t4,t0,a2fe64 <LzmaDec_DecodeReal2+0x764>
  a2fe62:	86e6                	mv	a3,s9
  a2fe64:	969a                	add	a3,a3,t1
  a2fe66:	40dc8333          	sub	t1,s9,a3
  a2fe6a:	93aa                	add	t2,t2,a0
  a2fe6c:	40a888b3          	sub	a7,a7,a0
  a2fe70:	00ae84b3          	add	s1,t4,a0
  a2fe74:	72a36263          	bltu	t1,a0,a30598 <LzmaDec_DecodeReal2+0xe98>
  a2fe78:	01da0333          	add	t1,s4,t4
  a2fe7c:	41d686b3          	sub	a3,a3,t4
  a2fe80:	951a                	add	a0,a0,t1
  a2fe82:	8ea6                	mv	t4,s1
  a2fe84:	00d304b3          	add	s1,t1,a3
  a2fe88:	2084                	lbu	s1,0(s1)
  a2fe8a:	0305                	addi	t1,t1,1
  a2fe8c:	fe930fa3          	sb	s1,-1(t1)
  a2fe90:	fe651ae3          	bne	a0,t1,a2fe84 <LzmaDec_DecodeReal2+0x784>
  a2fe94:	be1d                	j	a2f9ca <LzmaDec_DecodeReal2+0x2ca>
  a2fe96:	4b5a9a9b          	subshf	s5,s5,s5,srl,5
  a2fe9a:	015b1023          	sh	s5,0(s6)
  a2fe9e:	01830b13          	addi	s6,t1,24
  a2fea2:	9b7e                	add	s6,s6,t6
  a2fea4:	40d90933          	sub	s2,s2,a3
  a2fea8:	8f95                	sub	a5,a5,a3
  a2feaa:	000b5a83          	lhu	s5,0(s6)
  a2feae:	00c97763          	bgeu	s2,a2,a2febc <LzmaDec_DecodeReal2+0x7bc>
  a2feb2:	2314                	lbu	a3,0(a4)
  a2feb4:	0922                	slli	s2,s2,0x8
  a2feb6:	0705                	addi	a4,a4,1
  a2feb8:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2febc:	00b95693          	srli	a3,s2,0xb
  a2fec0:	035686b3          	mul	a3,a3,s5
  a2fec4:	08d7f763          	bgeu	a5,a3,a2ff52 <LzmaDec_DecodeReal2+0x852>
  a2fec8:	41580333          	sub	t1,a6,s5
  a2fecc:	4a6a8a9b          	addshf	s5,s5,t1,srl,5
  a2fed0:	4342                	lw	t1,16(sp)
  a2fed2:	015b1023          	sh	s5,0(s6)
  a2fed6:	949a                	add	s1,s1,t1
  a2fed8:	94fe                	add	s1,s1,t6
  a2feda:	0004d303          	lhu	t1,0(s1)
  a2fede:	00c6f863          	bgeu	a3,a2,a2feee <LzmaDec_DecodeReal2+0x7ee>
  a2fee2:	00074903          	lbu	s2,0(a4)
  a2fee6:	06a2                	slli	a3,a3,0x8
  a2fee8:	0705                	addi	a4,a4,1
  a2feea:	10f9279b          	orshf	a5,s2,a5,sll,8
  a2feee:	00b6d913          	srli	s2,a3,0xb
  a2fef2:	02690933          	mul	s2,s2,t1
  a2fef6:	0327fb63          	bgeu	a5,s2,a2ff2c <LzmaDec_DecodeReal2+0x82c>
  a2fefa:	406806b3          	sub	a3,a6,t1
  a2fefe:	4ad3031b          	addshf	t1,t1,a3,srl,5
  a2ff02:	00649023          	sh	t1,0(s1)
  a2ff06:	405e86b3          	sub	a3,t4,t0
  a2ff0a:	4501                	li	a0,0
  a2ff0c:	005ef363          	bgeu	t4,t0,a2ff12 <LzmaDec_DecodeReal2+0x812>
  a2ff10:	8566                	mv	a0,s9
  a2ff12:	96d2                	add	a3,a3,s4
  a2ff14:	96aa                	add	a3,a3,a0
  a2ff16:	2288                	lbu	a0,0(a3)
  a2ff18:	01da06b3          	add	a3,s4,t4
  a2ff1c:	0385                	addi	t2,t2,1
  a2ff1e:	a288                	sb	a0,0(a3)
  a2ff20:	0e85                	addi	t4,t4,1
  a2ff22:	469d                	li	a3,7
  a2ff24:	68df7b63          	bgeu	t5,a3,a305ba <LzmaDec_DecodeReal2+0xeba>
  a2ff28:	4f25                	li	t5,9
  a2ff2a:	b445                	j	a2f9ca <LzmaDec_DecodeReal2+0x2ca>
  a2ff2c:	88a2                	mv	a7,s0
  a2ff2e:	4a63131b          	subshf	t1,t1,t1,srl,5
  a2ff32:	8416                	mv	s0,t0
  a2ff34:	412686b3          	sub	a3,a3,s2
  a2ff38:	412787b3          	sub	a5,a5,s2
  a2ff3c:	00649023          	sh	t1,0(s1)
  a2ff40:	82c6                	mv	t0,a7
  a2ff42:	072f7b3b          	bgeui	t5,7,a2ffee <LzmaDec_DecodeReal2+0x8ee>
  a2ff46:	4f21                	li	t5,8
  a2ff48:	8896                	mv	a7,t0
  a2ff4a:	5312                	lw	t1,36(sp)
  a2ff4c:	82a2                	mv	t0,s0
  a2ff4e:	8446                	mv	s0,a7
  a2ff50:	bd15                	j	a2fd84 <LzmaDec_DecodeReal2+0x684>
  a2ff52:	4b5a9a9b          	subshf	s5,s5,s5,srl,5
  a2ff56:	03030493          	addi	s1,t1,48
  a2ff5a:	015b1023          	sh	s5,0(s6)
  a2ff5e:	94fe                	add	s1,s1,t6
  a2ff60:	40d90933          	sub	s2,s2,a3
  a2ff64:	8f95                	sub	a5,a5,a3
  a2ff66:	0004d883          	lhu	a7,0(s1)
  a2ff6a:	00c97763          	bgeu	s2,a2,a2ff78 <LzmaDec_DecodeReal2+0x878>
  a2ff6e:	2314                	lbu	a3,0(a4)
  a2ff70:	0922                	slli	s2,s2,0x8
  a2ff72:	0705                	addi	a4,a4,1
  a2ff74:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2ff78:	00b95693          	srli	a3,s2,0xb
  a2ff7c:	031686b3          	mul	a3,a3,a7
  a2ff80:	00d7f963          	bgeu	a5,a3,a2ff92 <LzmaDec_DecodeReal2+0x892>
  a2ff84:	41180333          	sub	t1,a6,a7
  a2ff88:	4a68889b          	addshf	a7,a7,t1,srl,5
  a2ff8c:	01149023          	sh	a7,0(s1)
  a2ff90:	bf4d                	j	a2ff42 <LzmaDec_DecodeReal2+0x842>
  a2ff92:	4b18989b          	subshf	a7,a7,a7,srl,5
  a2ff96:	04830313          	addi	t1,t1,72
  a2ff9a:	01149023          	sh	a7,0(s1)
  a2ff9e:	937e                	add	t1,t1,t6
  a2ffa0:	40d90933          	sub	s2,s2,a3
  a2ffa4:	8f95                	sub	a5,a5,a3
  a2ffa6:	00035883          	lhu	a7,0(t1)
  a2ffaa:	00c97763          	bgeu	s2,a2,a2ffb8 <LzmaDec_DecodeReal2+0x8b8>
  a2ffae:	2314                	lbu	a3,0(a4)
  a2ffb0:	0922                	slli	s2,s2,0x8
  a2ffb2:	0705                	addi	a4,a4,1
  a2ffb4:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a2ffb8:	00b95693          	srli	a3,s2,0xb
  a2ffbc:	031686b3          	mul	a3,a3,a7
  a2ffc0:	00d7fc63          	bgeu	a5,a3,a2ffd8 <LzmaDec_DecodeReal2+0x8d8>
  a2ffc4:	411804b3          	sub	s1,a6,a7
  a2ffc8:	4a98889b          	addshf	a7,a7,s1,srl,5
  a2ffcc:	01131023          	sh	a7,0(t1)
  a2ffd0:	88a2                	mv	a7,s0
  a2ffd2:	844e                	mv	s0,s3
  a2ffd4:	89c6                	mv	s3,a7
  a2ffd6:	b7b5                	j	a2ff42 <LzmaDec_DecodeReal2+0x842>
  a2ffd8:	4b18989b          	subshf	a7,a7,a7,srl,5
  a2ffdc:	8f95                	sub	a5,a5,a3
  a2ffde:	01131023          	sh	a7,0(t1)
  a2ffe2:	40d906b3          	sub	a3,s2,a3
  a2ffe6:	88a2                	mv	a7,s0
  a2ffe8:	846a                	mv	s0,s10
  a2ffea:	8d4e                	mv	s10,s3
  a2ffec:	b7e5                	j	a2ffd4 <LzmaDec_DecodeReal2+0x8d4>
  a2ffee:	4f2d                	li	t5,11
  a2fff0:	bfa1                	j	a2ff48 <LzmaDec_DecodeReal2+0x848>
  a2fff2:	4ad6969b          	subshf	a3,a3,a3,srl,5
  a2fff6:	8f85                	sub	a5,a5,s1
  a2fff8:	a136                	sh	a3,2(a0)
  a2fffa:	409884b3          	sub	s1,a7,s1
  a2fffe:	468d                	li	a3,3
  a30000:	bbf9                	j	a2fdde <LzmaDec_DecodeReal2+0x6de>
  a30002:	4a63131b          	subshf	t1,t1,t1,srl,5
  a30006:	411787b3          	sub	a5,a5,a7
  a3000a:	00691023          	sh	t1,0(s2)
  a3000e:	0685                	addi	a3,a3,1
  a30010:	411488b3          	sub	a7,s1,a7
  a30014:	bbf5                	j	a2fe10 <LzmaDec_DecodeReal2+0x710>
  a30016:	4a94949b          	subshf	s1,s1,s1,srl,5
  a3001a:	412787b3          	sub	a5,a5,s2
  a3001e:	a106                	sh	s1,0(a0)
  a30020:	0685                	addi	a3,a3,1
  a30022:	41288933          	sub	s2,a7,s2
  a30026:	bd19                	j	a2fe3c <LzmaDec_DecodeReal2+0x73c>
  a30028:	4a94949b          	subshf	s1,s1,s1,srl,5
  a3002c:	00931023          	sh	s1,0(t1)
  a30030:	41168933          	sub	s2,a3,a7
  a30034:	411787b3          	sub	a5,a5,a7
  a30038:	01035483          	lhu	s1,16(t1)
  a3003c:	00c97763          	bgeu	s2,a2,a3004a <LzmaDec_DecodeReal2+0x94a>
  a30040:	2314                	lbu	a3,0(a4)
  a30042:	0922                	slli	s2,s2,0x8
  a30044:	0705                	addi	a4,a4,1
  a30046:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a3004a:	00b95893          	srli	a7,s2,0xb
  a3004e:	029888b3          	mul	a7,a7,s1
  a30052:	0f17f263          	bgeu	a5,a7,a30136 <LzmaDec_DecodeReal2+0xa36>
  a30056:	409806b3          	sub	a3,a6,s1
  a3005a:	4ad4849b          	addshf	s1,s1,a3,srl,5
  a3005e:	0521                	addi	a0,a0,8
  a30060:	00931823          	sh	s1,16(t1)
  a30064:	02a3031b          	addshf	t1,t1,a0,sll,1
  a30068:	00235683          	lhu	a3,2(t1)
  a3006c:	00c8f763          	bgeu	a7,a2,a3007a <LzmaDec_DecodeReal2+0x97a>
  a30070:	2308                	lbu	a0,0(a4)
  a30072:	08a2                	slli	a7,a7,0x8
  a30074:	0705                	addi	a4,a4,1
  a30076:	10f5279b          	orshf	a5,a0,a5,sll,8
  a3007a:	00b8d493          	srli	s1,a7,0xb
  a3007e:	02d484b3          	mul	s1,s1,a3
  a30082:	0697fe63          	bgeu	a5,s1,a300fe <LzmaDec_DecodeReal2+0x9fe>
  a30086:	40d80533          	sub	a0,a6,a3
  a3008a:	4aa6869b          	addshf	a3,a3,a0,srl,5
  a3008e:	00d31123          	sh	a3,2(t1)
  a30092:	4889                	li	a7,2
  a30094:	0886                	slli	a7,a7,0x1
  a30096:	01130933          	add	s2,t1,a7
  a3009a:	00095503          	lhu	a0,0(s2)
  a3009e:	00c4f763          	bgeu	s1,a2,a300ac <LzmaDec_DecodeReal2+0x9ac>
  a300a2:	2314                	lbu	a3,0(a4)
  a300a4:	04a2                	slli	s1,s1,0x8
  a300a6:	0705                	addi	a4,a4,1
  a300a8:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a300ac:	00b4d693          	srli	a3,s1,0xb
  a300b0:	02a686b3          	mul	a3,a3,a0
  a300b4:	04d7fe63          	bgeu	a5,a3,a30110 <LzmaDec_DecodeReal2+0xa10>
  a300b8:	40a804b3          	sub	s1,a6,a0
  a300bc:	4a95051b          	addshf	a0,a0,s1,srl,5
  a300c0:	00a91023          	sh	a0,0(s2)
  a300c4:	0886                	slli	a7,a7,0x1
  a300c6:	9346                	add	t1,t1,a7
  a300c8:	00035483          	lhu	s1,0(t1)
  a300cc:	00c6f763          	bgeu	a3,a2,a300da <LzmaDec_DecodeReal2+0x9da>
  a300d0:	2308                	lbu	a0,0(a4)
  a300d2:	06a2                	slli	a3,a3,0x8
  a300d4:	0705                	addi	a4,a4,1
  a300d6:	10f5279b          	orshf	a5,a0,a5,sll,8
  a300da:	00b6d913          	srli	s2,a3,0xb
  a300de:	02990933          	mul	s2,s2,s1
  a300e2:	0527f063          	bgeu	a5,s2,a30122 <LzmaDec_DecodeReal2+0xa22>
  a300e6:	409806b3          	sub	a3,a6,s1
  a300ea:	4ad4849b          	addshf	s1,s1,a3,srl,5
  a300ee:	00931023          	sh	s1,0(t1)
  a300f2:	46ad                	li	a3,11
  a300f4:	d5e6f9e3          	bgeu	a3,t5,a2fe46 <LzmaDec_DecodeReal2+0x746>
  a300f8:	20000313          	li	t1,512
  a300fc:	a06d                	j	a301a6 <LzmaDec_DecodeReal2+0xaa6>
  a300fe:	4ad6969b          	subshf	a3,a3,a3,srl,5
  a30102:	8f85                	sub	a5,a5,s1
  a30104:	00d31123          	sh	a3,2(t1)
  a30108:	409884b3          	sub	s1,a7,s1
  a3010c:	488d                	li	a7,3
  a3010e:	b759                	j	a30094 <LzmaDec_DecodeReal2+0x994>
  a30110:	4aa5151b          	subshf	a0,a0,a0,srl,5
  a30114:	8f95                	sub	a5,a5,a3
  a30116:	00a91023          	sh	a0,0(s2)
  a3011a:	0885                	addi	a7,a7,1
  a3011c:	40d486b3          	sub	a3,s1,a3
  a30120:	b755                	j	a300c4 <LzmaDec_DecodeReal2+0x9c4>
  a30122:	4a94949b          	subshf	s1,s1,s1,srl,5
  a30126:	412787b3          	sub	a5,a5,s2
  a3012a:	00931023          	sh	s1,0(t1)
  a3012e:	0885                	addi	a7,a7,1
  a30130:	41268933          	sub	s2,a3,s2
  a30134:	bf7d                	j	a300f2 <LzmaDec_DecodeReal2+0x9f2>
  a30136:	4a94949b          	subshf	s1,s1,s1,srl,5
  a3013a:	41190933          	sub	s2,s2,a7
  a3013e:	411787b3          	sub	a5,a5,a7
  a30142:	00931823          	sh	s1,16(t1)
  a30146:	4885                	li	a7,1
  a30148:	0ff00a93          	li	s5,255
  a3014c:	0886                	slli	a7,a7,0x1
  a3014e:	20088493          	addi	s1,a7,512
  a30152:	949a                	add	s1,s1,t1
  a30154:	2096                	lhu	a3,0(s1)
  a30156:	00c97763          	bgeu	s2,a2,a30164 <LzmaDec_DecodeReal2+0xa64>
  a3015a:	2308                	lbu	a0,0(a4)
  a3015c:	0922                	slli	s2,s2,0x8
  a3015e:	0705                	addi	a4,a4,1
  a30160:	10f5279b          	orshf	a5,a0,a5,sll,8
  a30164:	00b95513          	srli	a0,s2,0xb
  a30168:	02d50533          	mul	a0,a0,a3
  a3016c:	00a7fd63          	bgeu	a5,a0,a30186 <LzmaDec_DecodeReal2+0xa86>
  a30170:	40d80933          	sub	s2,a6,a3
  a30174:	4b26869b          	addshf	a3,a3,s2,srl,5
  a30178:	a096                	sh	a3,0(s1)
  a3017a:	892a                	mv	s2,a0
  a3017c:	fd1af8e3          	bgeu	s5,a7,a3014c <LzmaDec_DecodeReal2+0xa4c>
  a30180:	f1088893          	addi	a7,a7,-240
  a30184:	b7bd                	j	a300f2 <LzmaDec_DecodeReal2+0x9f2>
  a30186:	4ad6969b          	subshf	a3,a3,a3,srl,5
  a3018a:	40a90933          	sub	s2,s2,a0
  a3018e:	8f89                	sub	a5,a5,a0
  a30190:	a096                	sh	a3,0(s1)
  a30192:	0885                	addi	a7,a7,1
  a30194:	b7e5                	j	a3017c <LzmaDec_DecodeReal2+0xa7c>
  a30196:	450d                	li	a0,3
  a30198:	20000313          	li	t1,512
  a3019c:	01156563          	bltu	a0,a7,a301a6 <LzmaDec_DecodeReal2+0xaa6>
  a301a0:	16e5                	addi	a3,a3,-7
  a301a2:	00769313          	slli	t1,a3,0x7
  a301a6:	937e                	add	t1,t1,t6
  a301a8:	00235683          	lhu	a3,2(t1)
  a301ac:	00c97763          	bgeu	s2,a2,a301ba <LzmaDec_DecodeReal2+0xaba>
  a301b0:	2308                	lbu	a0,0(a4)
  a301b2:	0922                	slli	s2,s2,0x8
  a301b4:	0705                	addi	a4,a4,1
  a301b6:	10f5279b          	orshf	a5,a0,a5,sll,8
  a301ba:	00b95493          	srli	s1,s2,0xb
  a301be:	02d484b3          	mul	s1,s1,a3
  a301c2:	1897fc63          	bgeu	a5,s1,a3035a <LzmaDec_DecodeReal2+0xc5a>
  a301c6:	40d80533          	sub	a0,a6,a3
  a301ca:	4aa6869b          	addshf	a3,a3,a0,srl,5
  a301ce:	00d31123          	sh	a3,2(t1)
  a301d2:	4689                	li	a3,2
  a301d4:	0686                	slli	a3,a3,0x1
  a301d6:	00d30ab3          	add	s5,t1,a3
  a301da:	000ad903          	lhu	s2,0(s5)
  a301de:	00c4f763          	bgeu	s1,a2,a301ec <LzmaDec_DecodeReal2+0xaec>
  a301e2:	2308                	lbu	a0,0(a4)
  a301e4:	04a2                	slli	s1,s1,0x8
  a301e6:	0705                	addi	a4,a4,1
  a301e8:	10f5279b          	orshf	a5,a0,a5,sll,8
  a301ec:	00b4d513          	srli	a0,s1,0xb
  a301f0:	03250533          	mul	a0,a0,s2
  a301f4:	16a7fc63          	bgeu	a5,a0,a3036c <LzmaDec_DecodeReal2+0xc6c>
  a301f8:	412804b3          	sub	s1,a6,s2
  a301fc:	4a99091b          	addshf	s2,s2,s1,srl,5
  a30200:	012a9023          	sh	s2,0(s5)
  a30204:	0686                	slli	a3,a3,0x1
  a30206:	00d30ab3          	add	s5,t1,a3
  a3020a:	000ad903          	lhu	s2,0(s5)
  a3020e:	00c57763          	bgeu	a0,a2,a3021c <LzmaDec_DecodeReal2+0xb1c>
  a30212:	2304                	lbu	s1,0(a4)
  a30214:	0522                	slli	a0,a0,0x8
  a30216:	0705                	addi	a4,a4,1
  a30218:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a3021c:	00b55493          	srli	s1,a0,0xb
  a30220:	032484b3          	mul	s1,s1,s2
  a30224:	1497fd63          	bgeu	a5,s1,a3037e <LzmaDec_DecodeReal2+0xc7e>
  a30228:	41280533          	sub	a0,a6,s2
  a3022c:	4aa9091b          	addshf	s2,s2,a0,srl,5
  a30230:	012a9023          	sh	s2,0(s5)
  a30234:	0686                	slli	a3,a3,0x1
  a30236:	00d30ab3          	add	s5,t1,a3
  a3023a:	000ad903          	lhu	s2,0(s5)
  a3023e:	00c4f763          	bgeu	s1,a2,a3024c <LzmaDec_DecodeReal2+0xb4c>
  a30242:	2308                	lbu	a0,0(a4)
  a30244:	04a2                	slli	s1,s1,0x8
  a30246:	0705                	addi	a4,a4,1
  a30248:	10f5279b          	orshf	a5,a0,a5,sll,8
  a3024c:	00b4d513          	srli	a0,s1,0xb
  a30250:	03250533          	mul	a0,a0,s2
  a30254:	12a7fe63          	bgeu	a5,a0,a30390 <LzmaDec_DecodeReal2+0xc90>
  a30258:	412804b3          	sub	s1,a6,s2
  a3025c:	4a99091b          	addshf	s2,s2,s1,srl,5
  a30260:	012a9023          	sh	s2,0(s5)
  a30264:	0686                	slli	a3,a3,0x1
  a30266:	00d30ab3          	add	s5,t1,a3
  a3026a:	000ad903          	lhu	s2,0(s5)
  a3026e:	00c57763          	bgeu	a0,a2,a3027c <LzmaDec_DecodeReal2+0xb7c>
  a30272:	2304                	lbu	s1,0(a4)
  a30274:	0522                	slli	a0,a0,0x8
  a30276:	0705                	addi	a4,a4,1
  a30278:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a3027c:	00b55493          	srli	s1,a0,0xb
  a30280:	032484b3          	mul	s1,s1,s2
  a30284:	1097ff63          	bgeu	a5,s1,a303a2 <LzmaDec_DecodeReal2+0xca2>
  a30288:	41280533          	sub	a0,a6,s2
  a3028c:	4aa9091b          	addshf	s2,s2,a0,srl,5
  a30290:	012a9023          	sh	s2,0(s5)
  a30294:	0686                	slli	a3,a3,0x1
  a30296:	9336                	add	t1,t1,a3
  a30298:	00035503          	lhu	a0,0(t1)
  a3029c:	00c4f863          	bgeu	s1,a2,a302ac <LzmaDec_DecodeReal2+0xbac>
  a302a0:	00074903          	lbu	s2,0(a4)
  a302a4:	04a2                	slli	s1,s1,0x8
  a302a6:	0705                	addi	a4,a4,1
  a302a8:	10f9279b          	orshf	a5,s2,a5,sll,8
  a302ac:	00b4d913          	srli	s2,s1,0xb
  a302b0:	02a90933          	mul	s2,s2,a0
  a302b4:	1127f063          	bgeu	a5,s2,a303b4 <LzmaDec_DecodeReal2+0xcb4>
  a302b8:	40a804b3          	sub	s1,a6,a0
  a302bc:	4a95051b          	addshf	a0,a0,s1,srl,5
  a302c0:	00a31023          	sh	a0,0(t1)
  a302c4:	fc068693          	addi	a3,a3,-64
  a302c8:	450d                	li	a0,3
  a302ca:	06d57563          	bgeu	a0,a3,a30334 <LzmaDec_DecodeReal2+0xc34>
  a302ce:	0016f513          	andi	a0,a3,1
  a302d2:	44b5                	li	s1,13
  a302d4:	0016d313          	srli	t1,a3,0x1
  a302d8:	00256513          	ori	a0,a0,2
  a302dc:	10d4e063          	bltu	s1,a3,a303dc <LzmaDec_DecodeReal2+0xcdc>
  a302e0:	137d                	addi	t1,t1,-1
  a302e2:	00651533          	sll	a0,a0,t1
  a302e6:	0505                	addi	a0,a0,1
  a302e8:	4b85                	li	s7,1
  a302ea:	76fd                	lui	a3,0xfffff
  a302ec:	30068693          	addi	a3,a3,768 # fffff300 <_gp_+0xff5caabc>
  a302f0:	02a68b1b          	addshf	s6,a3,a0,sll,1
  a302f4:	9b7e                	add	s6,s6,t6
  a302f6:	000b5483          	lhu	s1,0(s6)
  a302fa:	00c97763          	bgeu	s2,a2,a30308 <LzmaDec_DecodeReal2+0xc08>
  a302fe:	2314                	lbu	a3,0(a4)
  a30300:	0922                	slli	s2,s2,0x8
  a30302:	0705                	addi	a4,a4,1
  a30304:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a30308:	00b95a93          	srli	s5,s2,0xb
  a3030c:	029a8ab3          	mul	s5,s5,s1
  a30310:	001b9693          	slli	a3,s7,0x1
  a30314:	0b57fa63          	bgeu	a5,s5,a303c8 <LzmaDec_DecodeReal2+0xcc8>
  a30318:	40980933          	sub	s2,a6,s1
  a3031c:	4b24849b          	addshf	s1,s1,s2,srl,5
  a30320:	009b1023          	sh	s1,0(s6)
  a30324:	955e                	add	a0,a0,s7
  a30326:	8956                	mv	s2,s5
  a30328:	137d                	addi	t1,t1,-1
  a3032a:	8bb6                	mv	s7,a3
  a3032c:	fa031fe3          	bnez	t1,a302ea <LzmaDec_DecodeReal2+0xbea>
  a30330:	40d506b3          	sub	a3,a0,a3
  a30334:	44c9                	li	s1,18
  a30336:	00168513          	addi	a0,a3,1
  a3033a:	25e4e863          	bltu	s1,t5,a3058a <LzmaDec_DecodeReal2+0xe8a>
  a3033e:	4f1d                	li	t5,7
  a30340:	831e                	mv	t1,t2
  a30342:	000d8363          	beqz	s11,a30348 <LzmaDec_DecodeReal2+0xc48>
  a30346:	836e                	mv	t1,s11
  a30348:	2466e363          	bltu	a3,t1,a3058e <LzmaDec_DecodeReal2+0xe8e>
  a3034c:	8d4e                	mv	s10,s3
  a3034e:	20288893          	addi	a7,a7,514
  a30352:	89a2                	mv	s3,s0
  a30354:	8416                	mv	s0,t0
  a30356:	82aa                	mv	t0,a0
  a30358:	a251                	j	a304dc <LzmaDec_DecodeReal2+0xddc>
  a3035a:	4ad6969b          	subshf	a3,a3,a3,srl,5
  a3035e:	8f85                	sub	a5,a5,s1
  a30360:	00d31123          	sh	a3,2(t1)
  a30364:	409904b3          	sub	s1,s2,s1
  a30368:	468d                	li	a3,3
  a3036a:	b5ad                	j	a301d4 <LzmaDec_DecodeReal2+0xad4>
  a3036c:	4b29191b          	subshf	s2,s2,s2,srl,5
  a30370:	8f89                	sub	a5,a5,a0
  a30372:	012a9023          	sh	s2,0(s5)
  a30376:	0685                	addi	a3,a3,1
  a30378:	40a48533          	sub	a0,s1,a0
  a3037c:	b561                	j	a30204 <LzmaDec_DecodeReal2+0xb04>
  a3037e:	4b29191b          	subshf	s2,s2,s2,srl,5
  a30382:	8f85                	sub	a5,a5,s1
  a30384:	012a9023          	sh	s2,0(s5)
  a30388:	0685                	addi	a3,a3,1
  a3038a:	409504b3          	sub	s1,a0,s1
  a3038e:	b55d                	j	a30234 <LzmaDec_DecodeReal2+0xb34>
  a30390:	4b29191b          	subshf	s2,s2,s2,srl,5
  a30394:	8f89                	sub	a5,a5,a0
  a30396:	012a9023          	sh	s2,0(s5)
  a3039a:	0685                	addi	a3,a3,1
  a3039c:	40a48533          	sub	a0,s1,a0
  a303a0:	b5d1                	j	a30264 <LzmaDec_DecodeReal2+0xb64>
  a303a2:	4b29191b          	subshf	s2,s2,s2,srl,5
  a303a6:	8f85                	sub	a5,a5,s1
  a303a8:	012a9023          	sh	s2,0(s5)
  a303ac:	0685                	addi	a3,a3,1
  a303ae:	409504b3          	sub	s1,a0,s1
  a303b2:	b5cd                	j	a30294 <LzmaDec_DecodeReal2+0xb94>
  a303b4:	4aa5151b          	subshf	a0,a0,a0,srl,5
  a303b8:	412787b3          	sub	a5,a5,s2
  a303bc:	00a31023          	sh	a0,0(t1)
  a303c0:	0685                	addi	a3,a3,1
  a303c2:	41248933          	sub	s2,s1,s2
  a303c6:	bdfd                	j	a302c4 <LzmaDec_DecodeReal2+0xbc4>
  a303c8:	4a94949b          	subshf	s1,s1,s1,srl,5
  a303cc:	41590933          	sub	s2,s2,s5
  a303d0:	415787b3          	sub	a5,a5,s5
  a303d4:	009b1023          	sh	s1,0(s6)
  a303d8:	9536                	add	a0,a0,a3
  a303da:	b7b9                	j	a30328 <LzmaDec_DecodeReal2+0xc28>
  a303dc:	136d                	addi	t1,t1,-5
  a303de:	00c97763          	bgeu	s2,a2,a303ec <LzmaDec_DecodeReal2+0xcec>
  a303e2:	2314                	lbu	a3,0(a4)
  a303e4:	0922                	slli	s2,s2,0x8
  a303e6:	0705                	addi	a4,a4,1
  a303e8:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a303ec:	00195913          	srli	s2,s2,0x1
  a303f0:	412787b3          	sub	a5,a5,s2
  a303f4:	41f7d493          	srai	s1,a5,0x1f
  a303f8:	02a4851b          	addshf	a0,s1,a0,sll,1
  a303fc:	137d                	addi	t1,t1,-1
  a303fe:	009974b3          	and	s1,s2,s1
  a30402:	0505                	addi	a0,a0,1
  a30404:	97a6                	add	a5,a5,s1
  a30406:	fc031ce3          	bnez	t1,a303de <LzmaDec_DecodeReal2+0xcde>
  a3040a:	0512                	slli	a0,a0,0x4
  a3040c:	002fd683          	lhu	a3,2(t6)
  a30410:	00c97863          	bgeu	s2,a2,a30420 <LzmaDec_DecodeReal2+0xd20>
  a30414:	00074303          	lbu	t1,0(a4)
  a30418:	0922                	slli	s2,s2,0x8
  a3041a:	0705                	addi	a4,a4,1
  a3041c:	10f3279b          	orshf	a5,t1,a5,sll,8
  a30420:	00b95493          	srli	s1,s2,0xb
  a30424:	02d484b3          	mul	s1,s1,a3
  a30428:	1097fc63          	bgeu	a5,s1,a30540 <LzmaDec_DecodeReal2+0xe40>
  a3042c:	40d80333          	sub	t1,a6,a3
  a30430:	4a66869b          	addshf	a3,a3,t1,srl,5
  a30434:	00df9123          	sh	a3,2(t6)
  a30438:	4689                	li	a3,2
  a3043a:	02df8a9b          	addshf	s5,t6,a3,sll,1
  a3043e:	000ad903          	lhu	s2,0(s5)
  a30442:	00c4f863          	bgeu	s1,a2,a30452 <LzmaDec_DecodeReal2+0xd52>
  a30446:	00074303          	lbu	t1,0(a4)
  a3044a:	04a2                	slli	s1,s1,0x8
  a3044c:	0705                	addi	a4,a4,1
  a3044e:	10f3279b          	orshf	a5,t1,a5,sll,8
  a30452:	00b4d313          	srli	t1,s1,0xb
  a30456:	03230333          	mul	t1,t1,s2
  a3045a:	0e67fc63          	bgeu	a5,t1,a30552 <LzmaDec_DecodeReal2+0xe52>
  a3045e:	412804b3          	sub	s1,a6,s2
  a30462:	4a99091b          	addshf	s2,s2,s1,srl,5
  a30466:	012a9023          	sh	s2,0(s5)
  a3046a:	0689                	addi	a3,a3,2
  a3046c:	02df8a9b          	addshf	s5,t6,a3,sll,1
  a30470:	000ad903          	lhu	s2,0(s5)
  a30474:	00c37763          	bgeu	t1,a2,a30482 <LzmaDec_DecodeReal2+0xd82>
  a30478:	2304                	lbu	s1,0(a4)
  a3047a:	0322                	slli	t1,t1,0x8
  a3047c:	0705                	addi	a4,a4,1
  a3047e:	10f4a79b          	orshf	a5,s1,a5,sll,8
  a30482:	00b35493          	srli	s1,t1,0xb
  a30486:	032484b3          	mul	s1,s1,s2
  a3048a:	0c97fe63          	bgeu	a5,s1,a30566 <LzmaDec_DecodeReal2+0xe66>
  a3048e:	41280333          	sub	t1,a6,s2
  a30492:	4a69091b          	addshf	s2,s2,t1,srl,5
  a30496:	012a9023          	sh	s2,0(s5)
  a3049a:	0691                	addi	a3,a3,4
  a3049c:	02df8a9b          	addshf	s5,t6,a3,sll,1
  a304a0:	000ad303          	lhu	t1,0(s5)
  a304a4:	00c4f863          	bgeu	s1,a2,a304b4 <LzmaDec_DecodeReal2+0xdb4>
  a304a8:	00074903          	lbu	s2,0(a4)
  a304ac:	04a2                	slli	s1,s1,0x8
  a304ae:	0705                	addi	a4,a4,1
  a304b0:	10f9279b          	orshf	a5,s2,a5,sll,8
  a304b4:	00b4d913          	srli	s2,s1,0xb
  a304b8:	02690933          	mul	s2,s2,t1
  a304bc:	0b27fe63          	bgeu	a5,s2,a30578 <LzmaDec_DecodeReal2+0xe78>
  a304c0:	406804b3          	sub	s1,a6,t1
  a304c4:	4a93031b          	addshf	t1,t1,s1,srl,5
  a304c8:	006a9023          	sh	t1,0(s5)
  a304cc:	16e1                	addi	a3,a3,-8
  a304ce:	8ec9                	or	a3,a3,a0
  a304d0:	557d                	li	a0,-1
  a304d2:	e6a691e3          	bne	a3,a0,a30334 <LzmaDec_DecodeReal2+0xc34>
  a304d6:	1f51                	addi	t5,t5,-12
  a304d8:	11200893          	li	a7,274
  a304dc:	010006b7          	lui	a3,0x1000
  a304e0:	00d97763          	bgeu	s2,a3,a304ee <LzmaDec_DecodeReal2+0xdee>
  a304e4:	2314                	lbu	a3,0(a4)
  a304e6:	0922                	slli	s2,s2,0x8
  a304e8:	0705                	addi	a4,a4,1
  a304ea:	10f6a79b          	orshf	a5,a3,a5,sll,8
  a304ee:	02fe2223          	sw	a5,36(t3)
  a304f2:	02ce2783          	lw	a5,44(t3)
  a304f6:	2008b513          	sltiu	a0,a7,512
  a304fa:	00ee2e23          	sw	a4,28(t3)
  a304fe:	032e2023          	sw	s2,32(t3)
  a30502:	051e2223          	sw	a7,68(t3)
  a30506:	01de2c23          	sw	t4,24(t3)
  a3050a:	027e2423          	sw	t2,40(t3)
  a3050e:	025e2823          	sw	t0,48(t3)
  a30512:	028e2a23          	sw	s0,52(t3)
  a30516:	033e2c23          	sw	s3,56(t3)
  a3051a:	03ae2e23          	sw	s10,60(t3)
  a3051e:	05ee2023          	sw	t5,64(t3)
  a30522:	00154513          	xori	a0,a0,1
  a30526:	e799                	bnez	a5,a30534 <LzmaDec_DecodeReal2+0xe34>
  a30528:	004e2783          	lw	a5,4(t3)
  a3052c:	00f3e463          	bltu	t2,a5,a30534 <LzmaDec_DecodeReal2+0xe34>
  a30530:	02fe2623          	sw	a5,44(t3)
  a30534:	03010293          	addi	t0,sp,48
  a30538:	7fe2860b          	ldmia	{s0-s11},(t0)
  a3053c:	6125                	addi	sp,sp,96
  a3053e:	8082                	ret
  a30540:	4ad6969b          	subshf	a3,a3,a3,srl,5
  a30544:	8f85                	sub	a5,a5,s1
  a30546:	00df9123          	sh	a3,2(t6)
  a3054a:	409904b3          	sub	s1,s2,s1
  a3054e:	468d                	li	a3,3
  a30550:	b5ed                	j	a3043a <LzmaDec_DecodeReal2+0xd3a>
  a30552:	4b29191b          	subshf	s2,s2,s2,srl,5
  a30556:	406787b3          	sub	a5,a5,t1
  a3055a:	012a9023          	sh	s2,0(s5)
  a3055e:	0691                	addi	a3,a3,4 # 1000004 <_gp_+0x5cb7c0>
  a30560:	40648333          	sub	t1,s1,t1
  a30564:	b721                	j	a3046c <LzmaDec_DecodeReal2+0xd6c>
  a30566:	4b29191b          	subshf	s2,s2,s2,srl,5
  a3056a:	8f85                	sub	a5,a5,s1
  a3056c:	012a9023          	sh	s2,0(s5)
  a30570:	06a1                	addi	a3,a3,8
  a30572:	409304b3          	sub	s1,t1,s1
  a30576:	b71d                	j	a3049c <LzmaDec_DecodeReal2+0xd9c>
  a30578:	4a63131b          	subshf	t1,t1,t1,srl,5
  a3057c:	412787b3          	sub	a5,a5,s2
  a30580:	006a9023          	sh	t1,0(s5)
  a30584:	41248933          	sub	s2,s1,s2
  a30588:	b799                	j	a304ce <LzmaDec_DecodeReal2+0xdce>
  a3058a:	4f29                	li	t5,10
  a3058c:	bb55                	j	a30340 <LzmaDec_DecodeReal2+0xc40>
  a3058e:	8d4e                	mv	s10,s3
  a30590:	89a2                	mv	s3,s0
  a30592:	8416                	mv	s0,t0
  a30594:	82aa                	mv	t0,a0
  a30596:	b845                	j	a2fe46 <LzmaDec_DecodeReal2+0x746>
  a30598:	00da0533          	add	a0,s4,a3
  a3059c:	00054303          	lbu	t1,0(a0)
  a305a0:	0e85                	addi	t4,t4,1
  a305a2:	01da0533          	add	a0,s4,t4
  a305a6:	fe650fa3          	sb	t1,-1(a0)
  a305aa:	0685                	addi	a3,a3,1
  a305ac:	00dc9363          	bne	s9,a3,a305b2 <LzmaDec_DecodeReal2+0xeb2>
  a305b0:	4681                	li	a3,0
  a305b2:	fe9e93e3          	bne	t4,s1,a30598 <LzmaDec_DecodeReal2+0xe98>
  a305b6:	c14ff06f          	j	a2f9ca <LzmaDec_DecodeReal2+0x2ca>
  a305ba:	4f2d                	li	t5,11
  a305bc:	c0eff06f          	j	a2f9ca <LzmaDec_DecodeReal2+0x2ca>

00a305c0 <LzmaDec_Init>:
  a305c0:	11400793          	li	a5,276
  a305c4:	00052c23          	sw	zero,24(a0)
  a305c8:	04052623          	sw	zero,76(a0)
  a305cc:	02052423          	sw	zero,40(a0)
  a305d0:	02052623          	sw	zero,44(a0)
  a305d4:	c17c                	sw	a5,68(a0)
  a305d6:	8082                	ret

00a305d8 <LzmaDec_DecodeToDic>:
  a305d8:	82d8                	push	{ra,s0-s11},-96
  a305da:	0006a983          	lw	s3,0(a3)
  a305de:	0006a023          	sw	zero,0(a3)
  a305e2:	00078023          	sb	zero,0(a5) # 1000000 <_gp_+0x5cb7bc>
  a305e6:	8dbe                	mv	s11,a5
  a305e8:	417c                	lw	a5,68(a0)
  a305ea:	8bba                	mv	s7,a4
  a305ec:	11200713          	li	a4,274
  a305f0:	842a                	mv	s0,a0
  a305f2:	8b2e                	mv	s6,a1
  a305f4:	84b2                	mv	s1,a2
  a305f6:	8936                	mv	s2,a3
  a305f8:	08f77a63          	bgeu	a4,a5,a3068c <LzmaDec_DecodeToDic+0xb4>
  a305fc:	11400713          	li	a4,276
  a30600:	0af76663          	bltu	a4,a5,a306ac <LzmaDec_DecodeToDic+0xd4>
  a30604:	4711                	li	a4,4
  a30606:	447c                	lw	a5,76(s0)
  a30608:	0c098963          	beqz	s3,a306da <LzmaDec_DecodeToDic+0x102>
  a3060c:	0af77763          	bgeu	a4,a5,a306ba <LzmaDec_DecodeToDic+0xe2>
  a30610:	05044703          	lbu	a4,80(s0)
  a30614:	e34d                	bnez	a4,a306b6 <LzmaDec_DecodeToDic+0xde>
  a30616:	0537e1bb          	bltui	a5,5,a306dc <LzmaDec_DecodeToDic+0x104>
  a3061a:	05244783          	lbu	a5,82(s0)
  a3061e:	05144703          	lbu	a4,81(s0)
  a30622:	07c2                	slli	a5,a5,0x10
  a30624:	30e7a79b          	orshf	a5,a5,a4,sll,24
  a30628:	05444703          	lbu	a4,84(s0)
  a3062c:	8fd9                	or	a5,a5,a4
  a3062e:	05344703          	lbu	a4,83(s0)
  a30632:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a30636:	5458                	lw	a4,44(s0)
  a30638:	d05c                	sw	a5,36(s0)
  a3063a:	eb01                	bnez	a4,a3064a <LzmaDec_DecodeToDic+0x72>
  a3063c:	5418                	lw	a4,40(s0)
  a3063e:	e711                	bnez	a4,a3064a <LzmaDec_DecodeToDic+0x72>
  a30640:	bfff fbff 071f      	l.li	a4,0xbffffbff
  a30646:	06f76863          	bltu	a4,a5,a306b6 <LzmaDec_DecodeToDic+0xde>
  a3064a:	4078                	lw	a4,68(s0)
  a3064c:	57fd                	li	a5,-1
  a3064e:	d01c                	sw	a5,32(s0)
  a30650:	04042623          	sw	zero,76(s0)
  a30654:	11300793          	li	a5,275
  a30658:	02e7f863          	bgeu	a5,a4,a30688 <LzmaDec_DecodeToDic+0xb0>
  a3065c:	201c                	lbu	a5,0(s0)
  a3065e:	3018                	lbu	a4,1(s0)
  a30660:	4414                	lw	a3,8(s0)
  a30662:	40000613          	li	a2,1024
  a30666:	973e                	add	a4,a4,a5
  a30668:	30000793          	li	a5,768
  a3066c:	00e797b3          	sll	a5,a5,a4
  a30670:	7c078793          	addi	a5,a5,1984
  a30674:	4701                	li	a4,0
  a30676:	06f76563          	bltu	a4,a5,a306e0 <LzmaDec_DecodeToDic+0x108>
  a3067a:	4785                	li	a5,1
  a3067c:	dc5c                	sw	a5,60(s0)
  a3067e:	dc1c                	sw	a5,56(s0)
  a30680:	d85c                	sw	a5,52(s0)
  a30682:	d81c                	sw	a5,48(s0)
  a30684:	04042023          	sw	zero,64(s0)
  a30688:	04042223          	sw	zero,68(s0)
  a3068c:	4c4d                	li	s8,19
  a3068e:	5d7d                	li	s10,-1
  a30690:	05040a93          	addi	s5,s0,80
  a30694:	4074                	lw	a3,68(s0)
  a30696:	11200793          	li	a5,274
  a3069a:	04f69b63          	bne	a3,a5,a306f0 <LzmaDec_DecodeToDic+0x118>
  a3069e:	505c                	lw	a5,36(s0)
  a306a0:	eb99                	bnez	a5,a306b6 <LzmaDec_DecodeToDic+0xde>
  a306a2:	4785                	li	a5,1
  a306a4:	00fd8023          	sb	a5,0(s11)
  a306a8:	4501                	li	a0,0
  a306aa:	82d4                	popret	{ra,s0-s11},96
  a306ac:	1ff00713          	li	a4,511
  a306b0:	452d                	li	a0,11
  a306b2:	fee78ce3          	beq	a5,a4,a306aa <LzmaDec_DecodeToDic+0xd2>
  a306b6:	4505                	li	a0,1
  a306b8:	bfcd                	j	a306aa <LzmaDec_DecodeToDic+0xd2>
  a306ba:	00178693          	addi	a3,a5,1
  a306be:	c474                	sw	a3,76(s0)
  a306c0:	0485                	addi	s1,s1,1
  a306c2:	fff4c683          	lbu	a3,-1(s1)
  a306c6:	97a2                	add	a5,a5,s0
  a306c8:	19fd                	addi	s3,s3,-1
  a306ca:	04d78823          	sb	a3,80(a5)
  a306ce:	00092783          	lw	a5,0(s2)
  a306d2:	0785                	addi	a5,a5,1
  a306d4:	00f92023          	sw	a5,0(s2)
  a306d8:	b73d                	j	a30606 <LzmaDec_DecodeToDic+0x2e>
  a306da:	fb9d                	bnez	a5,a30610 <LzmaDec_DecodeToDic+0x38>
  a306dc:	478d                	li	a5,3
  a306de:	b7d9                	j	a306a4 <LzmaDec_DecodeToDic+0xcc>
  a306e0:	a292                	sh	a2,0(a3)
  a306e2:	0705                	addi	a4,a4,1
  a306e4:	0689                	addi	a3,a3,2
  a306e6:	bf41                	j	a30676 <LzmaDec_DecodeToDic+0x9e>
  a306e8:	409989b3          	sub	s3,s3,s1
  a306ec:	84b6                	mv	s1,a3
  a306ee:	b75d                	j	a30694 <LzmaDec_DecodeToDic+0xbc>
  a306f0:	c699                	beqz	a3,a306fe <LzmaDec_DecodeToDic+0x126>
  a306f2:	4c1c                	lw	a5,24(s0)
  a306f4:	40fb0733          	sub	a4,s6,a5
  a306f8:	00d77d63          	bgeu	a4,a3,a30712 <LzmaDec_DecodeToDic+0x13a>
  a306fc:	ef01                	bnez	a4,a30714 <LzmaDec_DecodeToDic+0x13c>
  a306fe:	4c1c                	lw	a5,24(s0)
  a30700:	0767e163          	bltu	a5,s6,a30762 <LzmaDec_DecodeToDic+0x18a>
  a30704:	407c                	lw	a5,68(s0)
  a30706:	1a079a63          	bnez	a5,a308ba <LzmaDec_DecodeToDic+0x2e2>
  a3070a:	505c                	lw	a5,36(s0)
  a3070c:	e7b9                	bnez	a5,a3075a <LzmaDec_DecodeToDic+0x182>
  a3070e:	4791                	li	a5,4
  a30710:	bf51                	j	a306a4 <LzmaDec_DecodeToDic+0xcc>
  a30712:	8736                	mv	a4,a3
  a30714:	544c                	lw	a1,44(s0)
  a30716:	5410                	lw	a2,40(s0)
  a30718:	e599                	bnez	a1,a30726 <LzmaDec_DecodeToDic+0x14e>
  a3071a:	404c                	lw	a1,4(s0)
  a3071c:	40c58533          	sub	a0,a1,a2
  a30720:	00a76363          	bltu	a4,a0,a30726 <LzmaDec_DecodeToDic+0x14e>
  a30724:	d44c                	sw	a1,44(s0)
  a30726:	963a                	add	a2,a2,a4
  a30728:	d410                	sw	a2,40(s0)
  a3072a:	580c                	lw	a1,48(s0)
  a3072c:	4810                	lw	a2,16(s0)
  a3072e:	01442803          	lw	a6,20(s0)
  a30732:	8e99                	sub	a3,a3,a4
  a30734:	c074                	sw	a3,68(s0)
  a30736:	973e                	add	a4,a4,a5
  a30738:	40b78533          	sub	a0,a5,a1
  a3073c:	4681                	li	a3,0
  a3073e:	00b7f363          	bgeu	a5,a1,a30744 <LzmaDec_DecodeToDic+0x16c>
  a30742:	86c2                	mv	a3,a6
  a30744:	96b2                	add	a3,a3,a2
  a30746:	96aa                	add	a3,a3,a0
  a30748:	2288                	lbu	a0,0(a3)
  a3074a:	00f606b3          	add	a3,a2,a5
  a3074e:	0785                	addi	a5,a5,1
  a30750:	a288                	sb	a0,0(a3)
  a30752:	fee793e3          	bne	a5,a4,a30738 <LzmaDec_DecodeToDic+0x160>
  a30756:	cc1c                	sw	a5,24(s0)
  a30758:	b75d                	j	a306fe <LzmaDec_DecodeToDic+0x126>
  a3075a:	040b9863          	bnez	s7,a307aa <LzmaDec_DecodeToDic+0x1d2>
  a3075e:	4789                	li	a5,2
  a30760:	b791                	j	a306a4 <LzmaDec_DecodeToDic+0xcc>
  a30762:	4c81                	li	s9,0
  a30764:	4478                	lw	a4,76(s0)
  a30766:	10071f63          	bnez	a4,a30884 <LzmaDec_DecodeToDic+0x2ac>
  a3076a:	013c7463          	bgeu	s8,s3,a30772 <LzmaDec_DecodeToDic+0x19a>
  a3076e:	0a0c8163          	beqz	s9,a30810 <LzmaDec_DecodeToDic+0x238>
  a30772:	01348a33          	add	s4,s1,s3
  a30776:	0870                	addi	a2,sp,28
  a30778:	85a6                	mv	a1,s1
  a3077a:	8522                	mv	a0,s0
  a3077c:	ce52                	sw	s4,28(sp)
  a3077e:	b2bfe0ef          	jal	ra,a2f2a8 <LzmaDec_TryDummy>
  a30782:	e515                	bnez	a0,a307ae <LzmaDec_DecodeToDic+0x1d6>
  a30784:	1429f0bb          	bgeui	s3,20,a30806 <LzmaDec_DecodeToDic+0x22e>
  a30788:	00092783          	lw	a5,0(s2)
  a3078c:	05040413          	addi	s0,s0,80
  a30790:	97ce                	add	a5,a5,s3
  a30792:	00f92023          	sw	a5,0(s2)
  a30796:	ff342e23          	sw	s3,-4(s0)
  a3079a:	f49a01e3          	beq	s4,s1,a306dc <LzmaDec_DecodeToDic+0x104>
  a3079e:	209c                	lbu	a5,0(s1)
  a307a0:	0405                	addi	s0,s0,1
  a307a2:	0485                	addi	s1,s1,1
  a307a4:	fef40fa3          	sb	a5,-1(s0)
  a307a8:	bfcd                	j	a3079a <LzmaDec_DecodeToDic+0x1c2>
  a307aa:	4c85                	li	s9,1
  a307ac:	bf65                	j	a30764 <LzmaDec_DecodeToDic+0x18c>
  a307ae:	4a72                	lw	s4,28(sp)
  a307b0:	409a0a33          	sub	s4,s4,s1
  a307b4:	151a74bb          	bgeui	s4,21,a30806 <LzmaDec_DecodeToDic+0x22e>
  a307b8:	020c8a63          	beqz	s9,a307ec <LzmaDec_DecodeToDic+0x214>
  a307bc:	02050c3b          	beqi	a0,2,a307ec <LzmaDec_DecodeToDic+0x214>
  a307c0:	00092783          	lw	a5,0(s2)
  a307c4:	05040413          	addi	s0,s0,80
  a307c8:	97d2                	add	a5,a5,s4
  a307ca:	00f92023          	sw	a5,0(s2)
  a307ce:	ff442e23          	sw	s4,-4(s0)
  a307d2:	9a26                	add	s4,s4,s1
  a307d4:	01449663          	bne	s1,s4,a307e0 <LzmaDec_DecodeToDic+0x208>
  a307d8:	4789                	li	a5,2
  a307da:	00fd8023          	sb	a5,0(s11)
  a307de:	bde1                	j	a306b6 <LzmaDec_DecodeToDic+0xde>
  a307e0:	209c                	lbu	a5,0(s1)
  a307e2:	0405                	addi	s0,s0,1
  a307e4:	0485                	addi	s1,s1,1
  a307e6:	fef40fa3          	sb	a5,-1(s0)
  a307ea:	b7ed                	j	a307d4 <LzmaDec_DecodeToDic+0x1fc>
  a307ec:	8626                	mv	a2,s1
  a307ee:	cc44                	sw	s1,28(s0)
  a307f0:	85da                	mv	a1,s6
  a307f2:	8522                	mv	a0,s0
  a307f4:	f0dfe0ef          	jal	ra,a2f700 <LzmaDec_DecodeReal2>
  a307f8:	4c54                	lw	a3,28(s0)
  a307fa:	409684b3          	sub	s1,a3,s1
  a307fe:	01aa1e63          	bne	s4,s10,a3081a <LzmaDec_DecodeToDic+0x242>
  a30802:	0099fe63          	bgeu	s3,s1,a3081e <LzmaDec_DecodeToDic+0x246>
  a30806:	1ff00793          	li	a5,511
  a3080a:	c07c                	sw	a5,68(s0)
  a3080c:	452d                	li	a0,11
  a3080e:	bd71                	j	a306aa <LzmaDec_DecodeToDic+0xd2>
  a30810:	fec98613          	addi	a2,s3,-20
  a30814:	9626                	add	a2,a2,s1
  a30816:	5a7d                	li	s4,-1
  a30818:	bfd9                	j	a307ee <LzmaDec_DecodeToDic+0x216>
  a3081a:	ff4496e3          	bne	s1,s4,a30806 <LzmaDec_DecodeToDic+0x22e>
  a3081e:	00092783          	lw	a5,0(s2)
  a30822:	97a6                	add	a5,a5,s1
  a30824:	00f92023          	sw	a5,0(s2)
  a30828:	ec0500e3          	beqz	a0,a306e8 <LzmaDec_DecodeToDic+0x110>
  a3082c:	20000793          	li	a5,512
  a30830:	c07c                	sw	a5,68(s0)
  a30832:	b551                	j	a306b6 <LzmaDec_DecodeToDic+0xde>
  a30834:	0a05                	addi	s4,s4,1
  a30836:	40ea06b3          	sub	a3,s4,a4
  a3083a:	96a6                	add	a3,a3,s1
  a3083c:	fff6c603          	lbu	a2,-1(a3)
  a30840:	014406b3          	add	a3,s0,s4
  a30844:	04c687a3          	sb	a2,79(a3)
  a30848:	40ea06b3          	sub	a3,s4,a4
  a3084c:	074c6a63          	bltu	s8,s4,a308c0 <LzmaDec_DecodeToDic+0x2e8>
  a30850:	ff36e2e3          	bltu	a3,s3,a30834 <LzmaDec_DecodeToDic+0x25c>
  a30854:	014a8733          	add	a4,s5,s4
  a30858:	0870                	addi	a2,sp,28
  a3085a:	85d6                	mv	a1,s5
  a3085c:	8522                	mv	a0,s0
  a3085e:	c636                	sw	a3,12(sp)
  a30860:	ce3a                	sw	a4,28(sp)
  a30862:	a47fe0ef          	jal	ra,a2f2a8 <LzmaDec_TryDummy>
  a30866:	46b2                	lw	a3,12(sp)
  a30868:	e105                	bnez	a0,a30888 <LzmaDec_DecodeToDic+0x2b0>
  a3086a:	14ea773b          	bgeui	s4,20,a30806 <LzmaDec_DecodeToDic+0x22e>
  a3086e:	05442623          	sw	s4,76(s0)
  a30872:	00092783          	lw	a5,0(s2)
  a30876:	97b6                	add	a5,a5,a3
  a30878:	00f92023          	sw	a5,0(s2)
  a3087c:	478d                	li	a5,3
  a3087e:	00fd8023          	sb	a5,0(s11)
  a30882:	b525                	j	a306aa <LzmaDec_DecodeToDic+0xd2>
  a30884:	8a3a                	mv	s4,a4
  a30886:	b7c9                	j	a30848 <LzmaDec_DecodeToDic+0x270>
  a30888:	4a72                	lw	s4,28(sp)
  a3088a:	4474                	lw	a3,76(s0)
  a3088c:	415a0a33          	sub	s4,s4,s5
  a30890:	f6da6be3          	bltu	s4,a3,a30806 <LzmaDec_DecodeToDic+0x22e>
  a30894:	020c8963          	beqz	s9,a308c6 <LzmaDec_DecodeToDic+0x2ee>
  a30898:	4709                	li	a4,2
  a3089a:	02e50663          	beq	a0,a4,a308c6 <LzmaDec_DecodeToDic+0x2ee>
  a3089e:	00092783          	lw	a5,0(s2)
  a308a2:	97d2                	add	a5,a5,s4
  a308a4:	8f95                	sub	a5,a5,a3
  a308a6:	00f92023          	sw	a5,0(s2)
  a308aa:	05442623          	sw	s4,76(s0)
  a308ae:	00ed8023          	sb	a4,0(s11)
  a308b2:	b511                	j	a306b6 <LzmaDec_DecodeToDic+0xde>
  a308b4:	03478a63          	beq	a5,s4,a308e8 <LzmaDec_DecodeToDic+0x310>
  a308b8:	b7b9                	j	a30806 <LzmaDec_DecodeToDic+0x22e>
  a308ba:	ea0b82e3          	beqz	s7,a3075e <LzmaDec_DecodeToDic+0x186>
  a308be:	bf29                	j	a307d8 <LzmaDec_DecodeToDic+0x200>
  a308c0:	f80c9ae3          	bnez	s9,a30854 <LzmaDec_DecodeToDic+0x27c>
  a308c4:	5a7d                	li	s4,-1
  a308c6:	01542e23          	sw	s5,28(s0)
  a308ca:	8656                	mv	a2,s5
  a308cc:	85da                	mv	a1,s6
  a308ce:	8522                	mv	a0,s0
  a308d0:	e31fe0ef          	jal	ra,a2f700 <LzmaDec_DecodeReal2>
  a308d4:	4c5c                	lw	a5,28(s0)
  a308d6:	4478                	lw	a4,76(s0)
  a308d8:	415787b3          	sub	a5,a5,s5
  a308dc:	fc0a5ce3          	bgez	s4,a308b4 <LzmaDec_DecodeToDic+0x2dc>
  a308e0:	15c7f9bb          	bgeui	a5,21,a30806 <LzmaDec_DecodeToDic+0x22e>
  a308e4:	f2e7e1e3          	bltu	a5,a4,a30806 <LzmaDec_DecodeToDic+0x22e>
  a308e8:	8f99                	sub	a5,a5,a4
  a308ea:	00092703          	lw	a4,0(s2)
  a308ee:	00f486b3          	add	a3,s1,a5
  a308f2:	40f989b3          	sub	s3,s3,a5
  a308f6:	97ba                	add	a5,a5,a4
  a308f8:	00f92023          	sw	a5,0(s2)
  a308fc:	04042623          	sw	zero,76(s0)
  a30900:	de0506e3          	beqz	a0,a306ec <LzmaDec_DecodeToDic+0x114>
  a30904:	b725                	j	a3082c <LzmaDec_DecodeToDic+0x254>

00a30906 <LzmaDec_DecodeToBuf>:
  a30906:	82c8                	push	{ra,s0-s10},-80
  a30908:	00062903          	lw	s2,0(a2) # 1000000 <_gp_+0x5cb7bc>
  a3090c:	00072b03          	lw	s6,0(a4)
  a30910:	00062023          	sw	zero,0(a2)
  a30914:	842a                	mv	s0,a0
  a30916:	8bae                	mv	s7,a1
  a30918:	89b2                	mv	s3,a2
  a3091a:	8c36                	mv	s8,a3
  a3091c:	8a3a                	mv	s4,a4
  a3091e:	8d3e                	mv	s10,a5
  a30920:	00072023          	sw	zero,0(a4)
  a30924:	484c                	lw	a1,20(s0)
  a30926:	4c1c                	lw	a5,24(s0)
  a30928:	ce5a                	sw	s6,28(sp)
  a3092a:	00b79463          	bne	a5,a1,a30932 <LzmaDec_DecodeToBuf+0x2c>
  a3092e:	00042c23          	sw	zero,24(s0)
  a30932:	01842a83          	lw	s5,24(s0)
  a30936:	4701                	li	a4,0
  a30938:	415587b3          	sub	a5,a1,s5
  a3093c:	0127e563          	bltu	a5,s2,a30946 <LzmaDec_DecodeToBuf+0x40>
  a30940:	015905b3          	add	a1,s2,s5
  a30944:	876a                	mv	a4,s10
  a30946:	87c2                	mv	a5,a6
  a30948:	8662                	mv	a2,s8
  a3094a:	0874                	addi	a3,sp,28
  a3094c:	8522                	mv	a0,s0
  a3094e:	c642                	sw	a6,12(sp)
  a30950:	c89ff0ef          	jal	ra,a305d8 <LzmaDec_DecodeToDic>
  a30954:	4772                	lw	a4,28(sp)
  a30956:	000a2783          	lw	a5,0(s4)
  a3095a:	8caa                	mv	s9,a0
  a3095c:	855e                	mv	a0,s7
  a3095e:	97ba                	add	a5,a5,a4
  a30960:	00fa2023          	sw	a5,0(s4)
  a30964:	4c04                	lw	s1,24(s0)
  a30966:	480c                	lw	a1,16(s0)
  a30968:	9c3a                	add	s8,s8,a4
  a3096a:	415484b3          	sub	s1,s1,s5
  a3096e:	8626                	mv	a2,s1
  a30970:	95d6                	add	a1,a1,s5
  a30972:	40eb0b33          	sub	s6,s6,a4
  a30976:	8dcf80ef          	jal	ra,a28a52 <memcpy>
  a3097a:	0009a783          	lw	a5,0(s3)
  a3097e:	9ba6                	add	s7,s7,s1
  a30980:	40990933          	sub	s2,s2,s1
  a30984:	97a6                	add	a5,a5,s1
  a30986:	00f9a023          	sw	a5,0(s3)
  a3098a:	000c9663          	bnez	s9,a30996 <LzmaDec_DecodeToBuf+0x90>
  a3098e:	c481                	beqz	s1,a30996 <LzmaDec_DecodeToBuf+0x90>
  a30990:	4832                	lw	a6,12(sp)
  a30992:	f80919e3          	bnez	s2,a30924 <LzmaDec_DecodeToBuf+0x1e>
  a30996:	8566                	mv	a0,s9
  a30998:	82c4                	popret	{ra,s0-s10},80

00a3099a <LzmaDec_FreeProbs>:
  a3099a:	8028                	push	{ra,s0},-16
  a3099c:	842a                	mv	s0,a0
  a3099e:	41dc                	lw	a5,4(a1)
  a309a0:	852e                	mv	a0,a1
  a309a2:	440c                	lw	a1,8(s0)
  a309a4:	9782                	jalr	a5
  a309a6:	00042423          	sw	zero,8(s0)
  a309aa:	8024                	popret	{ra,s0},16

00a309ac <LzmaDec_AllocateProbs2.isra.2>:
  a309ac:	8048                	push	{ra,s0-s2},-16
  a309ae:	451c                	lw	a5,8(a0)
  a309b0:	962e                	add	a2,a2,a1
  a309b2:	30000493          	li	s1,768
  a309b6:	00c494b3          	sll	s1,s1,a2
  a309ba:	842a                	mv	s0,a0
  a309bc:	7c048493          	addi	s1,s1,1984
  a309c0:	c789                	beqz	a5,a309ca <LzmaDec_AllocateProbs2.isra.2+0x1e>
  a309c2:	453c                	lw	a5,72(a0)
  a309c4:	4501                	li	a0,0
  a309c6:	02f48863          	beq	s1,a5,a309f6 <LzmaDec_AllocateProbs2.isra.2+0x4a>
  a309ca:	85b6                	mv	a1,a3
  a309cc:	8522                	mv	a0,s0
  a309ce:	8936                	mv	s2,a3
  a309d0:	fcbff0ef          	jal	ra,a3099a <LzmaDec_FreeProbs>
  a309d4:	00092783          	lw	a5,0(s2)
  a309d8:	00149593          	slli	a1,s1,0x1
  a309dc:	854a                	mv	a0,s2
  a309de:	9782                	jalr	a5
  a309e0:	87aa                	mv	a5,a0
  a309e2:	c408                	sw	a0,8(s0)
  a309e4:	4509                	li	a0,2
  a309e6:	cb81                	beqz	a5,a309f6 <LzmaDec_AllocateProbs2.isra.2+0x4a>
  a309e8:	0000 0d00 051f      	l.li	a0,0xd00
  a309ee:	97aa                	add	a5,a5,a0
  a309f0:	c45c                	sw	a5,12(s0)
  a309f2:	c424                	sw	s1,72(s0)
  a309f4:	4501                	li	a0,0
  a309f6:	8044                	popret	{ra,s0-s2},16

00a309f8 <LzmaProps_Decode>:
  a309f8:	0506723b          	bgeui	a2,5,a30a00 <LzmaProps_Decode+0x8>
  a309fc:	4511                	li	a0,4
  a309fe:	8082                	ret
  a30a00:	21b8                	lbu	a4,2(a1)
  a30a02:	319c                	lbu	a5,1(a1)
  a30a04:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a30a08:	31b8                	lbu	a4,3(a1)
  a30a0a:	20e7a79b          	orshf	a5,a5,a4,sll,16
  a30a0e:	21d8                	lbu	a4,4(a1)
  a30a10:	30e7a79b          	orshf	a5,a5,a4,sll,24
  a30a14:	6705                	lui	a4,0x1
  a30a16:	00e7f363          	bgeu	a5,a4,a30a1c <LzmaProps_Decode+0x24>
  a30a1a:	6785                	lui	a5,0x1
  a30a1c:	c15c                	sw	a5,4(a0)
  a30a1e:	219c                	lbu	a5,0(a1)
  a30a20:	e1f7f73b          	bgeui	a5,225,a309fc <LzmaProps_Decode+0x4>
  a30a24:	46a5                	li	a3,9
  a30a26:	02d7f733          	remu	a4,a5,a3
  a30a2a:	a118                	sb	a4,0(a0)
  a30a2c:	02d00713          	li	a4,45
  a30a30:	02e7d733          	divu	a4,a5,a4
  a30a34:	02d7d7b3          	divu	a5,a5,a3
  a30a38:	a138                	sb	a4,2(a0)
  a30a3a:	4715                	li	a4,5
  a30a3c:	02e7f7b3          	remu	a5,a5,a4
  a30a40:	b11c                	sb	a5,1(a0)
  a30a42:	4501                	li	a0,0
  a30a44:	8082                	ret

00a30a46 <LzmaDec_AllocateProbs>:
  a30a46:	8228                	push	{ra,s0},-48
  a30a48:	842a                	mv	s0,a0
  a30a4a:	0828                	addi	a0,sp,24
  a30a4c:	c636                	sw	a3,12(sp)
  a30a4e:	fabff0ef          	jal	ra,a309f8 <LzmaProps_Decode>
  a30a52:	46b2                	lw	a3,12(sp)
  a30a54:	ed09                	bnez	a0,a30a6e <LzmaDec_AllocateProbs+0x28>
  a30a56:	01914603          	lbu	a2,25(sp)
  a30a5a:	01814583          	lbu	a1,24(sp)
  a30a5e:	8522                	mv	a0,s0
  a30a60:	f4dff0ef          	jal	ra,a309ac <LzmaDec_AllocateProbs2.isra.2>
  a30a64:	e509                	bnez	a0,a30a6e <LzmaDec_AllocateProbs+0x28>
  a30a66:	47e2                	lw	a5,24(sp)
  a30a68:	c01c                	sw	a5,0(s0)
  a30a6a:	47f2                	lw	a5,28(sp)
  a30a6c:	c05c                	sw	a5,4(s0)
  a30a6e:	8224                	popret	{ra,s0},48

00a30a70 <SecMemcpyError>:
  a30a70:	04b05b63          	blez	a1,a30ac6 <SecMemcpyError+0x56>
  a30a74:	87aa                	mv	a5,a0
  a30a76:	4859                	li	a6,22
  a30a78:	c929                	beqz	a0,a30aca <SecMemcpyError+0x5a>
  a30a7a:	8018                	push	{ra},-16
  a30a7c:	8732                	mv	a4,a2
  a30a7e:	862e                	mv	a2,a1
  a30a80:	eb01                	bnez	a4,a30a90 <SecMemcpyError+0x20>
  a30a82:	4581                	li	a1,0
  a30a84:	f21f70ef          	jal	ra,a289a4 <memset>
  a30a88:	09600813          	li	a6,150
  a30a8c:	8542                	mv	a0,a6
  a30a8e:	8014                	popret	{ra},16
  a30a90:	00d5f863          	bgeu	a1,a3,a30aa0 <SecMemcpyError+0x30>
  a30a94:	4581                	li	a1,0
  a30a96:	f0ff70ef          	jal	ra,a289a4 <memset>
  a30a9a:	0a200813          	li	a6,162
  a30a9e:	b7fd                	j	a30a8c <SecMemcpyError+0x1c>
  a30aa0:	00a77663          	bgeu	a4,a0,a30aac <SecMemcpyError+0x3c>
  a30aa4:	00d705b3          	add	a1,a4,a3
  a30aa8:	00b56863          	bltu	a0,a1,a30ab8 <SecMemcpyError+0x48>
  a30aac:	4801                	li	a6,0
  a30aae:	fce7ffe3          	bgeu	a5,a4,a30a8c <SecMemcpyError+0x1c>
  a30ab2:	96be                	add	a3,a3,a5
  a30ab4:	fcd77ce3          	bgeu	a4,a3,a30a8c <SecMemcpyError+0x1c>
  a30ab8:	4581                	li	a1,0
  a30aba:	853e                	mv	a0,a5
  a30abc:	ee9f70ef          	jal	ra,a289a4 <memset>
  a30ac0:	0b600813          	li	a6,182
  a30ac4:	b7e1                	j	a30a8c <SecMemcpyError+0x1c>
  a30ac6:	02200813          	li	a6,34
  a30aca:	8542                	mv	a0,a6
  a30acc:	8082                	ret

00a30ace <memcpy_s>:
  a30ace:	02d5e363          	bltu	a1,a3,a30af4 <memcpy_s+0x26>
  a30ad2:	c10d                	beqz	a0,a30af4 <memcpy_s+0x26>
  a30ad4:	c205                	beqz	a2,a30af4 <memcpy_s+0x26>
  a30ad6:	0005cf63          	bltz	a1,a30af4 <memcpy_s+0x26>
  a30ada:	ce89                	beqz	a3,a30af4 <memcpy_s+0x26>
  a30adc:	00a67663          	bgeu	a2,a0,a30ae8 <memcpy_s+0x1a>
  a30ae0:	00d607b3          	add	a5,a2,a3
  a30ae4:	00f57a63          	bgeu	a0,a5,a30af8 <memcpy_s+0x2a>
  a30ae8:	00c57663          	bgeu	a0,a2,a30af4 <memcpy_s+0x26>
  a30aec:	00d507b3          	add	a5,a0,a3
  a30af0:	00f67463          	bgeu	a2,a5,a30af8 <memcpy_s+0x2a>
  a30af4:	f7dff06f          	j	a30a70 <SecMemcpyError>
  a30af8:	8018                	push	{ra},-16
  a30afa:	85b2                	mv	a1,a2
  a30afc:	8636                	mv	a2,a3
  a30afe:	f55f70ef          	jal	ra,a28a52 <memcpy>
  a30b02:	4501                	li	a0,0
  a30b04:	8014                	popret	{ra},16

00a30b06 <memmove_s>:
  a30b06:	8028                	push	{ra,s0},-16
  a30b08:	02200413          	li	s0,34
  a30b0c:	00b05c63          	blez	a1,a30b24 <memmove_s+0x1e>
  a30b10:	4459                	li	s0,22
  a30b12:	c909                	beqz	a0,a30b24 <memmove_s+0x1e>
  a30b14:	87b2                	mv	a5,a2
  a30b16:	862e                	mv	a2,a1
  a30b18:	eb81                	bnez	a5,a30b28 <memmove_s+0x22>
  a30b1a:	4581                	li	a1,0
  a30b1c:	e89f70ef          	jal	ra,a289a4 <memset>
  a30b20:	09600413          	li	s0,150
  a30b24:	8522                	mv	a0,s0
  a30b26:	8024                	popret	{ra,s0},16
  a30b28:	00d5f863          	bgeu	a1,a3,a30b38 <memmove_s+0x32>
  a30b2c:	4581                	li	a1,0
  a30b2e:	e77f70ef          	jal	ra,a289a4 <memset>
  a30b32:	0a200413          	li	s0,162
  a30b36:	b7fd                	j	a30b24 <memmove_s+0x1e>
  a30b38:	4401                	li	s0,0
  a30b3a:	fef505e3          	beq	a0,a5,a30b24 <memmove_s+0x1e>
  a30b3e:	d2fd                	beqz	a3,a30b24 <memmove_s+0x1e>
  a30b40:	8636                	mv	a2,a3
  a30b42:	85be                	mv	a1,a5
  a30b44:	a06f80ef          	jal	ra,a28d4a <memmove>
  a30b48:	bff1                	j	a30b24 <memmove_s+0x1e>

00a30b4a <memset_s>:
  a30b4a:	87ae                	mv	a5,a1
  a30b4c:	0205c363          	bltz	a1,a30b72 <memset_s+0x28>
  a30b50:	8028                	push	{ra,s0},-16
  a30b52:	842a                	mv	s0,a0
  a30b54:	c911                	beqz	a0,a30b68 <memset_s+0x1e>
  a30b56:	85b2                	mv	a1,a2
  a30b58:	8636                	mv	a2,a3
  a30b5a:	02d7e063          	bltu	a5,a3,a30b7a <memset_s+0x30>
  a30b5e:	e47f70ef          	jal	ra,a289a4 <memset>
  a30b62:	4701                	li	a4,0
  a30b64:	853a                	mv	a0,a4
  a30b66:	8024                	popret	{ra,s0},16
  a30b68:	02200713          	li	a4,34
  a30b6c:	dde5                	beqz	a1,a30b64 <memset_s+0x1a>
  a30b6e:	4759                	li	a4,22
  a30b70:	bfd5                	j	a30b64 <memset_s+0x1a>
  a30b72:	02200713          	li	a4,34
  a30b76:	853a                	mv	a0,a4
  a30b78:	8082                	ret
  a30b7a:	02200713          	li	a4,34
  a30b7e:	d3fd                	beqz	a5,a30b64 <memset_s+0x1a>
  a30b80:	863e                	mv	a2,a5
  a30b82:	e23f70ef          	jal	ra,a289a4 <memset>
  a30b86:	0a200713          	li	a4,162
  a30b8a:	bfe9                	j	a30b64 <memset_s+0x1a>

00a30b8c <SecWriteMultiChar>:
  a30b8c:	8732                	mv	a4,a2
  a30b8e:	00e04663          	bgtz	a4,a30b9a <SecWriteMultiChar+0xe>
  a30b92:	429c                	lw	a5,0(a3)
  a30b94:	963e                	add	a2,a2,a5
  a30b96:	c290                	sw	a2,0(a3)
  a30b98:	8082                	ret
  a30b9a:	411c                	lw	a5,0(a0)
  a30b9c:	17fd                	addi	a5,a5,-1 # fff <ccause+0x3d>
  a30b9e:	c11c                	sw	a5,0(a0)
  a30ba0:	0007d563          	bgez	a5,a30baa <SecWriteMultiChar+0x1e>
  a30ba4:	57fd                	li	a5,-1
  a30ba6:	c29c                	sw	a5,0(a3)
  a30ba8:	8082                	ret
  a30baa:	415c                	lw	a5,4(a0)
  a30bac:	177d                	addi	a4,a4,-1 # fff <ccause+0x3d>
  a30bae:	a38c                	sb	a1,0(a5)
  a30bb0:	415c                	lw	a5,4(a0)
  a30bb2:	0785                	addi	a5,a5,1
  a30bb4:	c15c                	sw	a5,4(a0)
  a30bb6:	bfe1                	j	a30b8e <SecWriteMultiChar+0x2>

00a30bb8 <SecOutput>:
  a30bb8:	9fd8                	push	{ra,s0-s11},-560
  a30bba:	00a34ab7          	lui	s5,0xa34
  a30bbe:	cf4a8793          	addi	a5,s5,-780 # a33cf4 <g_itoaUpperDigits>
  a30bc2:	711d                	addi	sp,sp,-96
  a30bc4:	cc3e                	sw	a5,24(sp)
  a30bc6:	00a34b37          	lui	s6,0xa34
  a30bca:	47a9                	li	a5,10
  a30bcc:	8caa                	mv	s9,a0
  a30bce:	8432                	mv	s0,a2
  a30bd0:	ce02                	sw	zero,28(sp)
  a30bd2:	d002                	sw	zero,32(sp)
  a30bd4:	d202                	sw	zero,36(sp)
  a30bd6:	d43e                	sw	a5,40(sp)
  a30bd8:	d602                	sw	zero,44(sp)
  a30bda:	d802                	sw	zero,48(sp)
  a30bdc:	da02                	sw	zero,52(sp)
  a30bde:	dc02                	sw	zero,56(sp)
  a30be0:	de02                	sw	zero,60(sp)
  a30be2:	c082                	sw	zero,64(sp)
  a30be4:	c282                	sw	zero,68(sp)
  a30be6:	04011423          	sh	zero,72(sp)
  a30bea:	ca02                	sw	zero,20(sp)
  a30bec:	4701                	li	a4,0
  a30bee:	cf4a8a93          	addi	s5,s5,-780
  a30bf2:	00a3 3d08 0b9f      	l.li	s7,0xa33d08
  a30bf8:	cc0b0b13          	addi	s6,s6,-832 # a33cc0 <g_efuse_cfg+0x1418>
  a30bfc:	00a3 4004 0c1f      	l.li	s8,0xa34004
  a30c02:	00a3 3ce0 091f      	l.li	s2,0xa33ce0
  a30c08:	219c                	lbu	a5,0(a1)
  a30c0a:	c781                	beqz	a5,a30c12 <SecOutput+0x5a>
  a30c0c:	46d2                	lw	a3,20(sp)
  a30c0e:	0006d963          	bgez	a3,a30c20 <SecOutput+0x68>
  a30c12:	c319                	beqz	a4,a30c18 <SecOutput+0x60>
  a30c14:	0737163b          	bnei	a4,7,a30cec <SecOutput+0x134>
  a30c18:	4552                	lw	a0,20(sp)
  a30c1a:	25010113          	addi	sp,sp,592
  a30c1e:	80d4                	popret	{ra,s0-s11},64
  a30c20:	00fb86b3          	add	a3,s7,a5
  a30c24:	2294                	lbu	a3,0(a3)
  a30c26:	00158a13          	addi	s4,a1,1
  a30c2a:	08dbd6db          	muliadd	a3,s7,a3,9
  a30c2e:	96ba                	add	a3,a3,a4
  a30c30:	1006c983          	lbu	s3,256(a3)
  a30c34:	0829fe3b          	bgeui	s3,8,a30cec <SecOutput+0x134>
  a30c38:	053b069b          	addshf	a3,s6,s3,sll,2
  a30c3c:	4294                	lw	a3,0(a3)
  a30c3e:	8682                	jr	a3
  a30c40:	000ca703          	lw	a4,0(s9)
  a30c44:	177d                	addi	a4,a4,-1
  a30c46:	00eca023          	sw	a4,0(s9)
  a30c4a:	02074063          	bltz	a4,a30c6a <SecOutput+0xb2>
  a30c4e:	004ca703          	lw	a4,4(s9)
  a30c52:	a31c                	sb	a5,0(a4)
  a30c54:	004ca783          	lw	a5,4(s9)
  a30c58:	0785                	addi	a5,a5,1
  a30c5a:	00fca223          	sw	a5,4(s9)
  a30c5e:	47d2                	lw	a5,20(sp)
  a30c60:	0785                	addi	a5,a5,1
  a30c62:	ca3e                	sw	a5,20(sp)
  a30c64:	85d2                	mv	a1,s4
  a30c66:	874e                	mv	a4,s3
  a30c68:	b745                	j	a30c08 <SecOutput+0x50>
  a30c6a:	57fd                	li	a5,-1
  a30c6c:	bfdd                	j	a30c62 <SecOutput+0xaa>
  a30c6e:	57fd                	li	a5,-1
  a30c70:	c282                	sw	zero,68(sp)
  a30c72:	d002                	sw	zero,32(sp)
  a30c74:	d602                	sw	zero,44(sp)
  a30c76:	d802                	sw	zero,48(sp)
  a30c78:	da3e                	sw	a5,52(sp)
  a30c7a:	d202                	sw	zero,36(sp)
  a30c7c:	dc02                	sw	zero,56(sp)
  a30c7e:	de02                	sw	zero,60(sp)
  a30c80:	b7d5                	j	a30c64 <SecOutput+0xac>
  a30c82:	02b00713          	li	a4,43
  a30c86:	02e78963          	beq	a5,a4,a30cb8 <SecOutput+0x100>
  a30c8a:	00f76a63          	bltu	a4,a5,a30c9e <SecOutput+0xe6>
  a30c8e:	2007883b          	beqi	a5,32,a30cae <SecOutput+0xf6>
  a30c92:	23f794bb          	bnei	a5,35,a30c64 <SecOutput+0xac>
  a30c96:	57b2                	lw	a5,44(sp)
  a30c98:	0807e793          	ori	a5,a5,128
  a30c9c:	a821                	j	a30cb4 <SecOutput+0xfc>
  a30c9e:	2d0788bb          	beqi	a5,45,a30cc0 <SecOutput+0x108>
  a30ca2:	30f790bb          	bnei	a5,48,a30c64 <SecOutput+0xac>
  a30ca6:	57b2                	lw	a5,44(sp)
  a30ca8:	0087e793          	ori	a5,a5,8
  a30cac:	a021                	j	a30cb4 <SecOutput+0xfc>
  a30cae:	57b2                	lw	a5,44(sp)
  a30cb0:	0027e793          	ori	a5,a5,2
  a30cb4:	d63e                	sw	a5,44(sp)
  a30cb6:	b77d                	j	a30c64 <SecOutput+0xac>
  a30cb8:	57b2                	lw	a5,44(sp)
  a30cba:	0017e793          	ori	a5,a5,1
  a30cbe:	bfdd                	j	a30cb4 <SecOutput+0xfc>
  a30cc0:	57b2                	lw	a5,44(sp)
  a30cc2:	0047e793          	ori	a5,a5,4
  a30cc6:	b7fd                	j	a30cb4 <SecOutput+0xfc>
  a30cc8:	2a0793bb          	bnei	a5,42,a30cd6 <SecOutput+0x11e>
  a30ccc:	4014                	lw	a3,0(s0)
  a30cce:	0411                	addi	s0,s0,4
  a30cd0:	d836                	sw	a3,48(sp)
  a30cd2:	4685                	li	a3,1
  a30cd4:	dc36                	sw	a3,56(sp)
  a30cd6:	56e2                	lw	a3,56(sp)
  a30cd8:	e695                	bnez	a3,a30d04 <SecOutput+0x14c>
  a30cda:	030701bb          	beqi	a4,3,a30ce0 <SecOutput+0x128>
  a30cde:	d802                	sw	zero,48(sp)
  a30ce0:	56c2                	lw	a3,48(sp)
  a30ce2:	0147 ae14 071f      	l.li	a4,0x147ae14
  a30ce8:	00d75463          	bge	a4,a3,a30cf0 <SecOutput+0x138>
  a30cec:	557d                	li	a0,-1
  a30cee:	b735                	j	a30c1a <SecOutput+0x62>
  a30cf0:	00269713          	slli	a4,a3,0x2
  a30cf4:	fd078793          	addi	a5,a5,-48
  a30cf8:	9736                	add	a4,a4,a3
  a30cfa:	9f81                	uxtb	a5
  a30cfc:	02e7879b          	addshf	a5,a5,a4,sll,1
  a30d00:	d83e                	sw	a5,48(sp)
  a30d02:	b78d                	j	a30c64 <SecOutput+0xac>
  a30d04:	57c2                	lw	a5,48(sp)
  a30d06:	0007d963          	bgez	a5,a30d18 <SecOutput+0x160>
  a30d0a:	5732                	lw	a4,44(sp)
  a30d0c:	40f007b3          	neg	a5,a5
  a30d10:	d83e                	sw	a5,48(sp)
  a30d12:	00476713          	ori	a4,a4,4
  a30d16:	d63a                	sw	a4,44(sp)
  a30d18:	5742                	lw	a4,48(sp)
  a30d1a:	0ccc ccc8 079f      	l.li	a5,0xcccccc8
  a30d20:	f4e7d2e3          	bge	a5,a4,a30c64 <SecOutput+0xac>
  a30d24:	b7e1                	j	a30cec <SecOutput+0x134>
  a30d26:	da02                	sw	zero,52(sp)
  a30d28:	bf35                	j	a30c64 <SecOutput+0xac>
  a30d2a:	2a0793bb          	bnei	a5,42,a30d38 <SecOutput+0x180>
  a30d2e:	4018                	lw	a4,0(s0)
  a30d30:	0411                	addi	s0,s0,4
  a30d32:	da3a                	sw	a4,52(sp)
  a30d34:	4705                	li	a4,1
  a30d36:	de3a                	sw	a4,60(sp)
  a30d38:	56f2                	lw	a3,60(sp)
  a30d3a:	5752                	lw	a4,52(sp)
  a30d3c:	e285                	bnez	a3,a30d5c <SecOutput+0x1a4>
  a30d3e:	0147 ae14 069f      	l.li	a3,0x147ae14
  a30d44:	fae6c4e3          	blt	a3,a4,a30cec <SecOutput+0x134>
  a30d48:	00271693          	slli	a3,a4,0x2
  a30d4c:	fd078793          	addi	a5,a5,-48
  a30d50:	9736                	add	a4,a4,a3
  a30d52:	9f81                	uxtb	a5
  a30d54:	02e7879b          	addshf	a5,a5,a4,sll,1
  a30d58:	da3e                	sw	a5,52(sp)
  a30d5a:	b729                	j	a30c64 <SecOutput+0xac>
  a30d5c:	00075463          	bgez	a4,a30d64 <SecOutput+0x1ac>
  a30d60:	57fd                	li	a5,-1
  a30d62:	da3e                	sw	a5,52(sp)
  a30d64:	5752                	lw	a4,52(sp)
  a30d66:	bf55                	j	a30d1a <SecOutput+0x162>
  a30d68:	06a00713          	li	a4,106
  a30d6c:	08e78763          	beq	a5,a4,a30dfa <SecOutput+0x242>
  a30d70:	04f76063          	bltu	a4,a5,a30db0 <SecOutput+0x1f8>
  a30d74:	04c00713          	li	a4,76
  a30d78:	04e78663          	beq	a5,a4,a30dc4 <SecOutput+0x20c>
  a30d7c:	00f76e63          	bltu	a4,a5,a30d98 <SecOutput+0x1e0>
  a30d80:	49b7993b          	bnei	a5,73,a30c64 <SecOutput+0xac>
  a30d84:	319c                	lbu	a5,1(a1)
  a30d86:	36179fbb          	bnei	a5,54,a30e04 <SecOutput+0x24c>
  a30d8a:	21bc                	lbu	a5,2(a1)
  a30d8c:	34279d3b          	bnei	a5,52,a30e40 <SecOutput+0x288>
  a30d90:	00358a13          	addi	s4,a1,3
  a30d94:	6721                	lui	a4,0x8
  a30d96:	a091                	j	a30dda <SecOutput+0x222>
  a30d98:	5a078fbb          	beqi	a5,90,a30dd6 <SecOutput+0x21e>
  a30d9c:	68b7923b          	bnei	a5,104,a30c64 <SecOutput+0xac>
  a30da0:	3194                	lbu	a3,1(a1)
  a30da2:	5732                	lw	a4,44(sp)
  a30da4:	0af69763          	bne	a3,a5,a30e52 <SecOutput+0x29a>
  a30da8:	00258a13          	addi	s4,a1,2
  a30dac:	6789                	lui	a5,0x2
  a30dae:	a081                	j	a30dee <SecOutput+0x236>
  a30db0:	07400713          	li	a4,116
  a30db4:	04e78663          	beq	a5,a4,a30e00 <SecOutput+0x248>
  a30db8:	00f76b63          	bltu	a4,a5,a30dce <SecOutput+0x216>
  a30dbc:	6c07893b          	beqi	a5,108,a30de0 <SecOutput+0x228>
  a30dc0:	71a7993b          	bnei	a5,113,a30c64 <SecOutput+0xac>
  a30dc4:	57b2                	lw	a5,44(sp)
  a30dc6:	0000 1400 071f      	l.li	a4,0x1400
  a30dcc:	a801                	j	a30ddc <SecOutput+0x224>
  a30dce:	772782bb          	beqi	a5,119,a30e58 <SecOutput+0x2a0>
  a30dd2:	7aa794bb          	bnei	a5,122,a30c64 <SecOutput+0xac>
  a30dd6:	00020737          	lui	a4,0x20
  a30dda:	57b2                	lw	a5,44(sp)
  a30ddc:	8fd9                	or	a5,a5,a4
  a30dde:	bdd9                	j	a30cb4 <SecOutput+0xfc>
  a30de0:	3194                	lbu	a3,1(a1)
  a30de2:	5732                	lw	a4,44(sp)
  a30de4:	00f69763          	bne	a3,a5,a30df2 <SecOutput+0x23a>
  a30de8:	00258a13          	addi	s4,a1,2
  a30dec:	6785                	lui	a5,0x1
  a30dee:	8f5d                	or	a4,a4,a5
  a30df0:	a019                	j	a30df6 <SecOutput+0x23e>
  a30df2:	01076713          	ori	a4,a4,16
  a30df6:	d63a                	sw	a4,44(sp)
  a30df8:	b5b5                	j	a30c64 <SecOutput+0xac>
  a30dfa:	00040737          	lui	a4,0x40
  a30dfe:	bff1                	j	a30dda <SecOutput+0x222>
  a30e00:	6741                	lui	a4,0x10
  a30e02:	bfe1                	j	a30dda <SecOutput+0x222>
  a30e04:	3307963b          	bnei	a5,51,a30e1c <SecOutput+0x264>
  a30e08:	21bc                	lbu	a5,2(a1)
  a30e0a:	32079dbb          	bnei	a5,50,a30e40 <SecOutput+0x288>
  a30e0e:	57b2                	lw	a5,44(sp)
  a30e10:	7761                	lui	a4,0xffff8
  a30e12:	177d                	addi	a4,a4,-1 # ffff7fff <_gp_+0xff5c37bb>
  a30e14:	00358a13          	addi	s4,a1,3
  a30e18:	8ff9                	and	a5,a5,a4
  a30e1a:	bd69                	j	a30cb4 <SecOutput+0xfc>
  a30e1c:	f9c78713          	addi	a4,a5,-100 # f9c <__bss_size__+0x994>
  a30e20:	0ff77693          	andi	a3,a4,255
  a30e24:	1206f53b          	bgeui	a3,18,a30e38 <SecOutput+0x280>
  a30e28:	0002 0821 071f      	l.li	a4,0x20821
  a30e2e:	00d75733          	srl	a4,a4,a3
  a30e32:	8b05                	andi	a4,a4,1
  a30e34:	e20718e3          	bnez	a4,a30c64 <SecOutput+0xac>
  a30e38:	0df7f793          	andi	a5,a5,223
  a30e3c:	58878a3b          	beqi	a5,88,a30c64 <SecOutput+0xac>
  a30e40:	000ca783          	lw	a5,0(s9)
  a30e44:	17fd                	addi	a5,a5,-1
  a30e46:	00fca023          	sw	a5,0(s9)
  a30e4a:	0007dc63          	bgez	a5,a30e62 <SecOutput+0x2aa>
  a30e4e:	57fd                	li	a5,-1
  a30e50:	a02d                	j	a30e7a <SecOutput+0x2c2>
  a30e52:	02076713          	ori	a4,a4,32
  a30e56:	b745                	j	a30df6 <SecOutput+0x23e>
  a30e58:	57b2                	lw	a5,44(sp)
  a30e5a:	0000 0800 071f      	l.li	a4,0x800
  a30e60:	bfb5                	j	a30ddc <SecOutput+0x224>
  a30e62:	004ca783          	lw	a5,4(s9)
  a30e66:	04900713          	li	a4,73
  a30e6a:	a398                	sb	a4,0(a5)
  a30e6c:	004ca783          	lw	a5,4(s9)
  a30e70:	0785                	addi	a5,a5,1
  a30e72:	00fca223          	sw	a5,4(s9)
  a30e76:	47d2                	lw	a5,20(sp)
  a30e78:	0785                	addi	a5,a5,1
  a30e7a:	ca3e                	sw	a5,20(sp)
  a30e7c:	4981                	li	s3,0
  a30e7e:	b3dd                	j	a30c64 <SecOutput+0xac>
  a30e80:	6847f23b          	bgeui	a5,104,a30f88 <SecOutput+0x3d0>
  a30e84:	06500713          	li	a4,101
  a30e88:	e6e7f2e3          	bgeu	a5,a4,a30cec <SecOutput+0x134>
  a30e8c:	05300713          	li	a4,83
  a30e90:	1ae78963          	beq	a5,a4,a31042 <SecOutput+0x48a>
  a30e94:	08f76f63          	bltu	a4,a5,a30f32 <SecOutput+0x37a>
  a30e98:	04300713          	li	a4,67
  a30e9c:	14e78f63          	beq	a5,a4,a30ffa <SecOutput+0x442>
  a30ea0:	00e7e663          	bltu	a5,a4,a30eac <SecOutput+0x2f4>
  a30ea4:	fbb78793          	addi	a5,a5,-69
  a30ea8:	0397e13b          	bltui	a5,3,a30cec <SecOutput+0x134>
  a30eac:	5782                	lw	a5,32(sp)
  a30eae:	5642                	lw	a2,48(sp)
  a30eb0:	8e1d                	sub	a2,a2,a5
  a30eb2:	4796                	lw	a5,68(sp)
  a30eb4:	8e1d                	sub	a2,a2,a5
  a30eb6:	57b2                	lw	a5,44(sp)
  a30eb8:	c0b2                	sw	a2,64(sp)
  a30eba:	8bb1                	andi	a5,a5,12
  a30ebc:	eb89                	bnez	a5,a30ece <SecOutput+0x316>
  a30ebe:	00c05863          	blez	a2,a30ece <SecOutput+0x316>
  a30ec2:	0854                	addi	a3,sp,20
  a30ec4:	02000593          	li	a1,32
  a30ec8:	8566                	mv	a0,s9
  a30eca:	cc3ff0ef          	jal	ra,a30b8c <SecWriteMultiChar>
  a30ece:	4696                	lw	a3,68(sp)
  a30ed0:	00d05e63          	blez	a3,a30eec <SecOutput+0x334>
  a30ed4:	083c                	addi	a5,sp,24
  a30ed6:	00f68633          	add	a2,a3,a5
  a30eda:	000ca703          	lw	a4,0(s9)
  a30ede:	177d                	addi	a4,a4,-1
  a30ee0:	00eca023          	sw	a4,0(s9)
  a30ee4:	4a075e63          	bgez	a4,a313a0 <SecOutput+0x7e8>
  a30ee8:	57fd                	li	a5,-1
  a30eea:	ca3e                	sw	a5,20(sp)
  a30eec:	57b2                	lw	a5,44(sp)
  a30eee:	8bb1                	andi	a5,a5,12
  a30ef0:	080795bb          	bnei	a5,8,a30f06 <SecOutput+0x34e>
  a30ef4:	4606                	lw	a2,64(sp)
  a30ef6:	00c05863          	blez	a2,a30f06 <SecOutput+0x34e>
  a30efa:	0854                	addi	a3,sp,20
  a30efc:	03000593          	li	a1,48
  a30f00:	8566                	mv	a0,s9
  a30f02:	c8bff0ef          	jal	ra,a30b8c <SecWriteMultiChar>
  a30f06:	5792                	lw	a5,36(sp)
  a30f08:	4a078c63          	beqz	a5,a313c0 <SecOutput+0x808>
  a30f0c:	57fd                	li	a5,-1
  a30f0e:	ca3e                	sw	a5,20(sp)
  a30f10:	47d2                	lw	a5,20(sp)
  a30f12:	d407c9e3          	bltz	a5,a30c64 <SecOutput+0xac>
  a30f16:	57b2                	lw	a5,44(sp)
  a30f18:	8b91                	andi	a5,a5,4
  a30f1a:	d40785e3          	beqz	a5,a30c64 <SecOutput+0xac>
  a30f1e:	4606                	lw	a2,64(sp)
  a30f20:	d4c052e3          	blez	a2,a30c64 <SecOutput+0xac>
  a30f24:	0854                	addi	a3,sp,20
  a30f26:	02000593          	li	a1,32
  a30f2a:	8566                	mv	a0,s9
  a30f2c:	c61ff0ef          	jal	ra,a30b8c <SecWriteMultiChar>
  a30f30:	bb15                	j	a30c64 <SecOutput+0xac>
  a30f32:	06300713          	li	a4,99
  a30f36:	0ce78c63          	beq	a5,a4,a3100e <SecOutput+0x456>
  a30f3a:	06f76163          	bltu	a4,a5,a30f9c <SecOutput+0x3e4>
  a30f3e:	58d79bbb          	bnei	a5,88,a30eac <SecOutput+0x2f4>
  a30f42:	4741                	li	a4,16
  a30f44:	d43a                	sw	a4,40(sp)
  a30f46:	cc4a                	sw	s2,24(sp)
  a30f48:	5732                	lw	a4,44(sp)
  a30f4a:	585785bb          	beqi	a5,88,a310a0 <SecOutput+0x4e8>
  a30f4e:	7057953b          	bnei	a5,112,a310a2 <SecOutput+0x4ea>
  a30f52:	0000 4090 079f      	l.li	a5,0x4090
  a30f58:	8f5d                	or	a4,a4,a5
  a30f5a:	4789                	li	a5,2
  a30f5c:	c2be                	sw	a5,68(sp)
  a30f5e:	77e1                	lui	a5,0xffff8
  a30f60:	8307c793          	xori	a5,a5,-2000
  a30f64:	da02                	sw	zero,52(sp)
  a30f66:	d63a                	sw	a4,44(sp)
  a30f68:	04f11423          	sh	a5,72(sp)
  a30f6c:	57b2                	lw	a5,44(sp)
  a30f6e:	6725                	lui	a4,0x9
  a30f70:	8f7d                	and	a4,a4,a5
  a30f72:	16070a63          	beqz	a4,a310e6 <SecOutput+0x52e>
  a30f76:	041d                	addi	s0,s0,7
  a30f78:	ff847793          	andi	a5,s0,-8
  a30f7c:	00878413          	addi	s0,a5,8 # ffff8008 <_gp_+0xff5c37c4>
  a30f80:	4384                	lw	s1,0(a5)
  a30f82:	0047ad03          	lw	s10,4(a5)
  a30f86:	a245                	j	a31126 <SecOutput+0x56e>
  a30f88:	07000713          	li	a4,112
  a30f8c:	fae78be3          	beq	a5,a4,a30f42 <SecOutput+0x38a>
  a30f90:	02f76363          	bltu	a4,a5,a30fb6 <SecOutput+0x3fe>
  a30f94:	6907823b          	beqi	a5,105,a30f9c <SecOutput+0x3e4>
  a30f98:	6fc7953b          	bnei	a5,111,a30eac <SecOutput+0x2f4>
  a30f9c:	06900693          	li	a3,105
  a30fa0:	5732                	lw	a4,44(sp)
  a30fa2:	00d78663          	beq	a5,a3,a30fae <SecOutput+0x3f6>
  a30fa6:	10f6ed63          	bltu	a3,a5,a310c0 <SecOutput+0x508>
  a30faa:	64f790bb          	bnei	a5,100,a30f6c <SecOutput+0x3b4>
  a30fae:	04076713          	ori	a4,a4,64
  a30fb2:	d63a                	sw	a4,44(sp)
  a30fb4:	aa11                	j	a310c8 <SecOutput+0x510>
  a30fb6:	75f789bb          	beqi	a5,117,a30f9c <SecOutput+0x3e4>
  a30fba:	78e7823b          	beqi	a5,120,a30f42 <SecOutput+0x38a>
  a30fbe:	73b79bbb          	bnei	a5,115,a30eac <SecOutput+0x2f4>
  a30fc2:	57b2                	lw	a5,44(sp)
  a30fc4:	4014                	lw	a3,0(s0)
  a30fc6:	00440493          	addi	s1,s0,4
  a30fca:	ff77f713          	andi	a4,a5,-9
  a30fce:	d63a                	sw	a4,44(sp)
  a30fd0:	0000 0810 071f      	l.li	a4,0x810
  a30fd6:	8ff9                	and	a5,a5,a4
  a30fd8:	ce36                	sw	a3,28(sp)
  a30fda:	5752                	lw	a4,52(sp)
  a30fdc:	ebd9                	bnez	a5,a31072 <SecOutput+0x4ba>
  a30fde:	e689                	bnez	a3,a30fe8 <SecOutput+0x430>
  a30fe0:	00a3 400c 079f      	l.li	a5,0xa3400c
  a30fe6:	ce3e                	sw	a5,28(sp)
  a30fe8:	4572                	lw	a0,28(sp)
  a30fea:	ff171bbb          	bnei	a4,-1,a31058 <SecOutput+0x4a0>
  a30fee:	d1ff70ef          	jal	ra,a28d0c <strlen>
  a30ff2:	06055b63          	bgez	a0,a31068 <SecOutput+0x4b0>
  a30ff6:	4501                	li	a0,0
  a30ff8:	a885                	j	a31068 <SecOutput+0x4b0>
  a30ffa:	57b2                	lw	a5,44(sp)
  a30ffc:	6705                	lui	a4,0x1
  a30ffe:	83070693          	addi	a3,a4,-2000 # 830 <__bss_size__+0x228>
  a31002:	8efd                	and	a3,a3,a5
  a31004:	e689                	bnez	a3,a3100e <SecOutput+0x456>
  a31006:	80070713          	addi	a4,a4,-2048
  a3100a:	8fd9                	or	a5,a5,a4
  a3100c:	d63e                	sw	a5,44(sp)
  a3100e:	57b2                	lw	a5,44(sp)
  a31010:	4605                	li	a2,1
  a31012:	d032                	sw	a2,32(sp)
  a31014:	ff77f593          	andi	a1,a5,-9
  a31018:	d62e                	sw	a1,44(sp)
  a3101a:	0000 0810 059f      	l.li	a1,0x810
  a31020:	8fed                	and	a5,a5,a1
  a31022:	00440713          	addi	a4,s0,4
  a31026:	4014                	lw	a3,0(s0)
  a31028:	c799                	beqz	a5,a31036 <SecOutput+0x47e>
  a3102a:	00fc                	addi	a5,sp,76
  a3102c:	c6b6                	sw	a3,76(sp)
  a3102e:	ce3e                	sw	a5,28(sp)
  a31030:	d232                	sw	a2,36(sp)
  a31032:	843a                	mv	s0,a4
  a31034:	bda5                	j	a30eac <SecOutput+0x2f4>
  a31036:	00fc                	addi	a5,sp,76
  a31038:	04d10623          	sb	a3,76(sp)
  a3103c:	ce3e                	sw	a5,28(sp)
  a3103e:	d202                	sw	zero,36(sp)
  a31040:	bfcd                	j	a31032 <SecOutput+0x47a>
  a31042:	57b2                	lw	a5,44(sp)
  a31044:	6705                	lui	a4,0x1
  a31046:	83070693          	addi	a3,a4,-2000 # 830 <__bss_size__+0x228>
  a3104a:	8efd                	and	a3,a3,a5
  a3104c:	fabd                	bnez	a3,a30fc2 <SecOutput+0x40a>
  a3104e:	80070713          	addi	a4,a4,-2048
  a31052:	8fd9                	or	a5,a5,a4
  a31054:	d63e                	sw	a5,44(sp)
  a31056:	b7b5                	j	a30fc2 <SecOutput+0x40a>
  a31058:	972a                	add	a4,a4,a0
  a3105a:	87aa                	mv	a5,a0
  a3105c:	00e78463          	beq	a5,a4,a31064 <SecOutput+0x4ac>
  a31060:	2394                	lbu	a3,0(a5)
  a31062:	e691                	bnez	a3,a3106e <SecOutput+0x4b6>
  a31064:	40a78533          	sub	a0,a5,a0
  a31068:	d02a                	sw	a0,32(sp)
  a3106a:	8426                	mv	s0,s1
  a3106c:	b581                	j	a30eac <SecOutput+0x2f4>
  a3106e:	0785                	addi	a5,a5,1
  a31070:	b7f5                	j	a3105c <SecOutput+0x4a4>
  a31072:	4785                	li	a5,1
  a31074:	d23e                	sw	a5,36(sp)
  a31076:	e689                	bnez	a3,a31080 <SecOutput+0x4c8>
  a31078:	00a3 4014 079f      	l.li	a5,0xa34014
  a3107e:	ce3e                	sw	a5,28(sp)
  a31080:	46f2                	lw	a3,28(sp)
  a31082:	4781                	li	a5,0
  a31084:	00e78463          	beq	a5,a4,a3108c <SecOutput+0x4d4>
  a31088:	4290                	lw	a2,0(a3)
  a3108a:	ea01                	bnez	a2,a3109a <SecOutput+0x4e2>
  a3108c:	20000737          	lui	a4,0x20000
  a31090:	00e7e363          	bltu	a5,a4,a31096 <SecOutput+0x4de>
  a31094:	4781                	li	a5,0
  a31096:	d03e                	sw	a5,32(sp)
  a31098:	bfc9                	j	a3106a <SecOutput+0x4b2>
  a3109a:	0785                	addi	a5,a5,1
  a3109c:	0691                	addi	a3,a3,4
  a3109e:	b7dd                	j	a31084 <SecOutput+0x4cc>
  a310a0:	cc56                	sw	s5,24(sp)
  a310a2:	08077713          	andi	a4,a4,128
  a310a6:	ee070be3          	beqz	a4,a30f9c <SecOutput+0x3e4>
  a310aa:	03000713          	li	a4,48
  a310ae:	04e10423          	sb	a4,72(sp)
  a310b2:	4762                	lw	a4,24(sp)
  a310b4:	2b18                	lbu	a4,16(a4)
  a310b6:	04e104a3          	sb	a4,73(sp)
  a310ba:	4709                	li	a4,2
  a310bc:	c2ba                	sw	a4,68(sp)
  a310be:	bdf9                	j	a30f9c <SecOutput+0x3e4>
  a310c0:	6f07843b          	beqi	a5,111,a310d0 <SecOutput+0x518>
  a310c4:	75a79a3b          	bnei	a5,117,a30f6c <SecOutput+0x3b4>
  a310c8:	47a9                	li	a5,10
  a310ca:	d43e                	sw	a5,40(sp)
  a310cc:	cc4a                	sw	s2,24(sp)
  a310ce:	bd79                	j	a30f6c <SecOutput+0x3b4>
  a310d0:	47a1                	li	a5,8
  a310d2:	d43e                	sw	a5,40(sp)
  a310d4:	cc4a                	sw	s2,24(sp)
  a310d6:	08077793          	andi	a5,a4,128
  a310da:	e80789e3          	beqz	a5,a30f6c <SecOutput+0x3b4>
  a310de:	20076713          	ori	a4,a4,512
  a310e2:	d63a                	sw	a4,44(sp)
  a310e4:	b561                	j	a30f6c <SecOutput+0x3b4>
  a310e6:	0107f693          	andi	a3,a5,16
  a310ea:	0407f713          	andi	a4,a5,64
  a310ee:	c689                	beqz	a3,a310f8 <SecOutput+0x540>
  a310f0:	4004                	lw	s1,0(s0)
  a310f2:	0411                	addi	s0,s0,4
  a310f4:	cb4d                	beqz	a4,a311a6 <SecOutput+0x5ee>
  a310f6:	a065                	j	a3119e <SecOutput+0x5e6>
  a310f8:	01279693          	slli	a3,a5,0x12
  a310fc:	0806d963          	bgez	a3,a3118e <SecOutput+0x5d6>
  a31100:	4014                	lw	a3,0(s0)
  a31102:	4d01                	li	s10,0
  a31104:	0411                	addi	s0,s0,4
  a31106:	0ff6f493          	andi	s1,a3,255
  a3110a:	cf11                	beqz	a4,a31126 <SecOutput+0x56e>
  a3110c:	06e2                	slli	a3,a3,0x18
  a3110e:	86e1                	srai	a3,a3,0x18
  a31110:	0006db63          	bgez	a3,a31126 <SecOutput+0x56e>
  a31114:	fff4c493          	not	s1,s1
  a31118:	9c81                	uxtb	s1
  a3111a:	0485                	addi	s1,s1,1
  a3111c:	1007e793          	ori	a5,a5,256
  a31120:	41f4dd13          	srai	s10,s1,0x1f
  a31124:	d63e                	sw	a5,44(sp)
  a31126:	57b2                	lw	a5,44(sp)
  a31128:	8da6                	mv	s11,s1
  a3112a:	876a                	mv	a4,s10
  a3112c:	0407f693          	andi	a3,a5,64
  a31130:	ce89                	beqz	a3,a3114a <SecOutput+0x592>
  a31132:	000d5c63          	bgez	s10,a3114a <SecOutput+0x592>
  a31136:	40900db3          	neg	s11,s1
  a3113a:	01b036b3          	snez	a3,s11
  a3113e:	41a00733          	neg	a4,s10
  a31142:	1007e793          	ori	a5,a5,256
  a31146:	8f15                	sub	a4,a4,a3
  a31148:	d63e                	sw	a5,44(sp)
  a3114a:	56b2                	lw	a3,44(sp)
  a3114c:	000497b7          	lui	a5,0x49
  a31150:	8ff5                	and	a5,a5,a3
  a31152:	e391                	bnez	a5,a31156 <SecOutput+0x59e>
  a31154:	4701                	li	a4,0
  a31156:	24c10813          	addi	a6,sp,588
  a3115a:	ce42                	sw	a6,28(sp)
  a3115c:	00ede7b3          	or	a5,s11,a4
  a31160:	e3c1                	bnez	a5,a311e0 <SecOutput+0x628>
  a31162:	c282                	sw	zero,68(sp)
  a31164:	d002                	sw	zero,32(sp)
  a31166:	5752                	lw	a4,52(sp)
  a31168:	4685                	li	a3,1
  a3116a:	00074f63          	bltz	a4,a31188 <SecOutput+0x5d0>
  a3116e:	57b2                	lw	a5,44(sp)
  a31170:	01179693          	slli	a3,a5,0x11
  a31174:	0006c463          	bltz	a3,a3117c <SecOutput+0x5c4>
  a31178:	9bdd                	andi	a5,a5,-9
  a3117a:	d63e                	sw	a5,44(sp)
  a3117c:	20000793          	li	a5,512
  a31180:	00e7d363          	bge	a5,a4,a31186 <SecOutput+0x5ce>
  a31184:	da3e                	sw	a5,52(sp)
  a31186:	56d2                	lw	a3,52(sp)
  a31188:	03000613          	li	a2,48
  a3118c:	aa69                	j	a31326 <SecOutput+0x76e>
  a3118e:	0207f693          	andi	a3,a5,32
  a31192:	ce81                	beqz	a3,a311aa <SecOutput+0x5f2>
  a31194:	4004                	lw	s1,0(s0)
  a31196:	0411                	addi	s0,s0,4
  a31198:	c711                	beqz	a4,a311a4 <SecOutput+0x5ec>
  a3119a:	04c2                	slli	s1,s1,0x10
  a3119c:	84c1                	srai	s1,s1,0x10
  a3119e:	41f4dd13          	srai	s10,s1,0x1f
  a311a2:	b751                	j	a31126 <SecOutput+0x56e>
  a311a4:	9ca1                	uxth	s1
  a311a6:	4d01                	li	s10,0
  a311a8:	bfbd                	j	a31126 <SecOutput+0x56e>
  a311aa:	00f79693          	slli	a3,a5,0xf
  a311ae:	0006d763          	bgez	a3,a311bc <SecOutput+0x604>
  a311b2:	4004                	lw	s1,0(s0)
  a311b4:	0411                	addi	s0,s0,4
  a311b6:	41f4dd13          	srai	s10,s1,0x1f
  a311ba:	b7b5                	j	a31126 <SecOutput+0x56e>
  a311bc:	00e79693          	slli	a3,a5,0xe
  a311c0:	0006db63          	bgez	a3,a311d6 <SecOutput+0x61e>
  a311c4:	4004                	lw	s1,0(s0)
  a311c6:	00440793          	addi	a5,s0,4
  a311ca:	41f4dd13          	srai	s10,s1,0x1f
  a311ce:	e311                	bnez	a4,a311d2 <SecOutput+0x61a>
  a311d0:	4d01                	li	s10,0
  a311d2:	843e                	mv	s0,a5
  a311d4:	bf89                	j	a31126 <SecOutput+0x56e>
  a311d6:	00d79693          	slli	a3,a5,0xd
  a311da:	f006dbe3          	bgez	a3,a310f0 <SecOutput+0x538>
  a311de:	bb61                	j	a30f76 <SecOutput+0x3be>
  a311e0:	57a2                	lw	a5,40(sp)
  a311e2:	ef49                	bnez	a4,a3127c <SecOutput+0x6c4>
  a311e4:	0a1791bb          	bnei	a5,10,a3122a <SecOutput+0x672>
  a311e8:	46a9                	li	a3,10
  a311ea:	4625                	li	a2,9
  a311ec:	4772                	lw	a4,28(sp)
  a311ee:	fff70793          	addi	a5,a4,-1 # 1fffffff <_gp_+0x1f5cb7bb>
  a311f2:	ce3e                	sw	a5,28(sp)
  a311f4:	02ddf7b3          	remu	a5,s11,a3
  a311f8:	97ca                	add	a5,a5,s2
  a311fa:	239c                	lbu	a5,0(a5)
  a311fc:	fef70fa3          	sb	a5,-1(a4)
  a31200:	002dd793          	srli	a5,s11,0x2
  a31204:	43b7879b          	addshf	a5,a5,s11,srl,1
  a31208:	48f7879b          	addshf	a5,a5,a5,srl,4
  a3120c:	50f7879b          	addshf	a5,a5,a5,srl,8
  a31210:	60f7879b          	addshf	a5,a5,a5,srl,16
  a31214:	838d                	srli	a5,a5,0x3
  a31216:	00279513          	slli	a0,a5,0x2
  a3121a:	953e                	add	a0,a0,a5
  a3121c:	02ad951b          	subshf	a0,s11,a0,sll,1
  a31220:	04a67c63          	bgeu	a2,a0,a31278 <SecOutput+0x6c0>
  a31224:	0785                	addi	a5,a5,1 # 49001 <__heap_size+0x2ba09>
  a31226:	8dbe                	mv	s11,a5
  a31228:	b7d1                	j	a311ec <SecOutput+0x634>
  a3122a:	100789bb          	beqi	a5,16,a31250 <SecOutput+0x698>
  a3122e:	0817903b          	bnei	a5,8,a3126e <SecOutput+0x6b6>
  a31232:	4772                	lw	a4,28(sp)
  a31234:	fff70793          	addi	a5,a4,-1
  a31238:	ce3e                	sw	a5,28(sp)
  a3123a:	007df793          	andi	a5,s11,7
  a3123e:	97ca                	add	a5,a5,s2
  a31240:	239c                	lbu	a5,0(a5)
  a31242:	003ddd93          	srli	s11,s11,0x3
  a31246:	fef70fa3          	sb	a5,-1(a4)
  a3124a:	fe0d94e3          	bnez	s11,a31232 <SecOutput+0x67a>
  a3124e:	a005                	j	a3126e <SecOutput+0x6b6>
  a31250:	4772                	lw	a4,28(sp)
  a31252:	00fdf693          	andi	a3,s11,15
  a31256:	004ddd93          	srli	s11,s11,0x4
  a3125a:	fff70793          	addi	a5,a4,-1
  a3125e:	ce3e                	sw	a5,28(sp)
  a31260:	47e2                	lw	a5,24(sp)
  a31262:	97b6                	add	a5,a5,a3
  a31264:	239c                	lbu	a5,0(a5)
  a31266:	fef70fa3          	sb	a5,-1(a4)
  a3126a:	fe0d93e3          	bnez	s11,a31250 <SecOutput+0x698>
  a3126e:	47f2                	lw	a5,28(sp)
  a31270:	40f80833          	sub	a6,a6,a5
  a31274:	d042                	sw	a6,32(sp)
  a31276:	bdc5                	j	a31166 <SecOutput+0x5ae>
  a31278:	f7dd                	bnez	a5,a31226 <SecOutput+0x66e>
  a3127a:	bfd5                	j	a3126e <SecOutput+0x6b6>
  a3127c:	0a078cbb          	beqi	a5,10,a312ae <SecOutput+0x6f6>
  a31280:	10178b3b          	beqi	a5,16,a312ec <SecOutput+0x734>
  a31284:	08f79abb          	bnei	a5,8,a3126e <SecOutput+0x6b6>
  a31288:	46f2                	lw	a3,28(sp)
  a3128a:	fff68793          	addi	a5,a3,-1
  a3128e:	ce3e                	sw	a5,28(sp)
  a31290:	007df793          	andi	a5,s11,7
  a31294:	97ca                	add	a5,a5,s2
  a31296:	239c                	lbu	a5,0(a5)
  a31298:	003ddd93          	srli	s11,s11,0x3
  a3129c:	3aedad9b          	orshf	s11,s11,a4,sll,29
  a312a0:	830d                	srli	a4,a4,0x3
  a312a2:	fef68fa3          	sb	a5,-1(a3)
  a312a6:	00ede7b3          	or	a5,s11,a4
  a312aa:	fff9                	bnez	a5,a31288 <SecOutput+0x6d0>
  a312ac:	b7c9                	j	a3126e <SecOutput+0x6b6>
  a312ae:	47f2                	lw	a5,28(sp)
  a312b0:	4629                	li	a2,10
  a312b2:	856e                	mv	a0,s11
  a312b4:	fff78693          	addi	a3,a5,-1
  a312b8:	ce36                	sw	a3,28(sp)
  a312ba:	85ba                	mv	a1,a4
  a312bc:	4681                	li	a3,0
  a312be:	c642                	sw	a6,12(sp)
  a312c0:	c43e                	sw	a5,8(sp)
  a312c2:	c23a                	sw	a4,4(sp)
  a312c4:	adcf70ef          	jal	ra,a285a0 <__umoddi3>
  a312c8:	954a                	add	a0,a0,s2
  a312ca:	2114                	lbu	a3,0(a0)
  a312cc:	4712                	lw	a4,4(sp)
  a312ce:	47a2                	lw	a5,8(sp)
  a312d0:	856e                	mv	a0,s11
  a312d2:	85ba                	mv	a1,a4
  a312d4:	fed78fa3          	sb	a3,-1(a5)
  a312d8:	4629                	li	a2,10
  a312da:	4681                	li	a3,0
  a312dc:	ac0f70ef          	jal	ra,a2859c <__udivdi3>
  a312e0:	872e                	mv	a4,a1
  a312e2:	8dc9                	or	a1,a1,a0
  a312e4:	8daa                	mv	s11,a0
  a312e6:	4832                	lw	a6,12(sp)
  a312e8:	f1f9                	bnez	a1,a312ae <SecOutput+0x6f6>
  a312ea:	b751                	j	a3126e <SecOutput+0x6b6>
  a312ec:	46f2                	lw	a3,28(sp)
  a312ee:	00fdf613          	andi	a2,s11,15
  a312f2:	004ddd93          	srli	s11,s11,0x4
  a312f6:	fff68793          	addi	a5,a3,-1
  a312fa:	ce3e                	sw	a5,28(sp)
  a312fc:	47e2                	lw	a5,24(sp)
  a312fe:	38edad9b          	orshf	s11,s11,a4,sll,28
  a31302:	8311                	srli	a4,a4,0x4
  a31304:	97b2                	add	a5,a5,a2
  a31306:	239c                	lbu	a5,0(a5)
  a31308:	fef68fa3          	sb	a5,-1(a3)
  a3130c:	00ede7b3          	or	a5,s11,a4
  a31310:	fff1                	bnez	a5,a312ec <SecOutput+0x734>
  a31312:	bfb1                	j	a3126e <SecOutput+0x6b6>
  a31314:	47f2                	lw	a5,28(sp)
  a31316:	fff78713          	addi	a4,a5,-1
  a3131a:	ce3a                	sw	a4,28(sp)
  a3131c:	fec78fa3          	sb	a2,-1(a5)
  a31320:	5782                	lw	a5,32(sp)
  a31322:	0785                	addi	a5,a5,1
  a31324:	d03e                	sw	a5,32(sp)
  a31326:	5702                	lw	a4,32(sp)
  a31328:	fed746e3          	blt	a4,a3,a31314 <SecOutput+0x75c>
  a3132c:	57b2                	lw	a5,44(sp)
  a3132e:	2007f793          	andi	a5,a5,512
  a31332:	c385                	beqz	a5,a31352 <SecOutput+0x79a>
  a31334:	47f2                	lw	a5,28(sp)
  a31336:	c701                	beqz	a4,a3133e <SecOutput+0x786>
  a31338:	2398                	lbu	a4,0(a5)
  a3133a:	3007063b          	beqi	a4,48,a31352 <SecOutput+0x79a>
  a3133e:	fff78713          	addi	a4,a5,-1
  a31342:	ce3a                	sw	a4,28(sp)
  a31344:	03000713          	li	a4,48
  a31348:	fee78fa3          	sb	a4,-1(a5)
  a3134c:	5782                	lw	a5,32(sp)
  a3134e:	0785                	addi	a5,a5,1
  a31350:	d03e                	sw	a5,32(sp)
  a31352:	57b2                	lw	a5,44(sp)
  a31354:	0407f713          	andi	a4,a5,64
  a31358:	cb11                	beqz	a4,a3136c <SecOutput+0x7b4>
  a3135a:	1007f713          	andi	a4,a5,256
  a3135e:	c70d                	beqz	a4,a31388 <SecOutput+0x7d0>
  a31360:	02d00713          	li	a4,45
  a31364:	04e10423          	sb	a4,72(sp)
  a31368:	4705                	li	a4,1
  a3136a:	c2ba                	sw	a4,68(sp)
  a3136c:	01a4e4b3          	or	s1,s1,s10
  a31370:	b2049ee3          	bnez	s1,a30eac <SecOutput+0x2f4>
  a31374:	01179713          	slli	a4,a5,0x11
  a31378:	b2075ae3          	bgez	a4,a30eac <SecOutput+0x2f4>
  a3137c:	4715                	li	a4,5
  a3137e:	9bdd                	andi	a5,a5,-9
  a31380:	ce62                	sw	s8,28(sp)
  a31382:	d03a                	sw	a4,32(sp)
  a31384:	d63e                	sw	a5,44(sp)
  a31386:	b61d                	j	a30eac <SecOutput+0x2f4>
  a31388:	0017f713          	andi	a4,a5,1
  a3138c:	c701                	beqz	a4,a31394 <SecOutput+0x7dc>
  a3138e:	02b00713          	li	a4,43
  a31392:	bfc9                	j	a31364 <SecOutput+0x7ac>
  a31394:	0027f713          	andi	a4,a5,2
  a31398:	db71                	beqz	a4,a3136c <SecOutput+0x7b4>
  a3139a:	02000713          	li	a4,32
  a3139e:	b7d9                	j	a31364 <SecOutput+0x7ac>
  a313a0:	004ca703          	lw	a4,4(s9)
  a313a4:	0307c583          	lbu	a1,48(a5)
  a313a8:	0785                	addi	a5,a5,1
  a313aa:	a30c                	sb	a1,0(a4)
  a313ac:	004ca703          	lw	a4,4(s9)
  a313b0:	0705                	addi	a4,a4,1
  a313b2:	00eca223          	sw	a4,4(s9)
  a313b6:	b2f612e3          	bne	a2,a5,a30eda <SecOutput+0x322>
  a313ba:	47d2                	lw	a5,20(sp)
  a313bc:	97b6                	add	a5,a5,a3
  a313be:	b635                	j	a30eea <SecOutput+0x332>
  a313c0:	45f2                	lw	a1,28(sp)
  a313c2:	5482                	lw	s1,32(sp)
  a313c4:	000ca703          	lw	a4,0(s9)
  a313c8:	87ae                	mv	a5,a1
  a313ca:	009586b3          	add	a3,a1,s1
  a313ce:	06974963          	blt	a4,s1,a31440 <SecOutput+0x888>
  a313d2:	0c04ddbb          	bgei	s1,12,a31408 <SecOutput+0x850>
  a313d6:	87ae                	mv	a5,a1
  a313d8:	a819                	j	a313ee <SecOutput+0x836>
  a313da:	004ca703          	lw	a4,4(s9)
  a313de:	2394                	lbu	a3,0(a5)
  a313e0:	0785                	addi	a5,a5,1
  a313e2:	a314                	sb	a3,0(a4)
  a313e4:	004ca703          	lw	a4,4(s9)
  a313e8:	0705                	addi	a4,a4,1
  a313ea:	00eca223          	sw	a4,4(s9)
  a313ee:	40b78733          	sub	a4,a5,a1
  a313f2:	fe9744e3          	blt	a4,s1,a313da <SecOutput+0x822>
  a313f6:	000ca783          	lw	a5,0(s9)
  a313fa:	8f85                	sub	a5,a5,s1
  a313fc:	00fca023          	sw	a5,0(s9)
  a31400:	47d2                	lw	a5,20(sp)
  a31402:	94be                	add	s1,s1,a5
  a31404:	ca26                	sw	s1,20(sp)
  a31406:	b629                	j	a30f10 <SecOutput+0x358>
  a31408:	004ca503          	lw	a0,4(s9)
  a3140c:	8626                	mv	a2,s1
  a3140e:	e44f70ef          	jal	ra,a28a52 <memcpy>
  a31412:	004ca783          	lw	a5,4(s9)
  a31416:	97a6                	add	a5,a5,s1
  a31418:	00fca223          	sw	a5,4(s9)
  a3141c:	bfe9                	j	a313f6 <SecOutput+0x83e>
  a3141e:	000ca703          	lw	a4,0(s9)
  a31422:	177d                	addi	a4,a4,-1
  a31424:	00eca023          	sw	a4,0(s9)
  a31428:	ae0742e3          	bltz	a4,a30f0c <SecOutput+0x354>
  a3142c:	004ca703          	lw	a4,4(s9)
  a31430:	2390                	lbu	a2,0(a5)
  a31432:	0785                	addi	a5,a5,1
  a31434:	a310                	sb	a2,0(a4)
  a31436:	004ca703          	lw	a4,4(s9)
  a3143a:	0705                	addi	a4,a4,1
  a3143c:	00eca223          	sw	a4,4(s9)
  a31440:	40f68733          	sub	a4,a3,a5
  a31444:	fce04de3          	bgtz	a4,a3141e <SecOutput+0x866>
  a31448:	bf65                	j	a31400 <SecOutput+0x848>

00a3144a <SecVsnprintfImpl>:
  a3144a:	8138                	push	{ra,s0-s1},-32
  a3144c:	84ae                	mv	s1,a1
  a3144e:	842a                	mv	s0,a0
  a31450:	85b2                	mv	a1,a2
  a31452:	c62a                	sw	a0,12(sp)
  a31454:	8636                	mv	a2,a3
  a31456:	0028                	addi	a0,sp,8
  a31458:	c426                	sw	s1,8(sp)
  a3145a:	f5eff0ef          	jal	ra,a30bb8 <SecOutput>
  a3145e:	00054b63          	bltz	a0,a31474 <SecVsnprintfImpl+0x2a>
  a31462:	47a2                	lw	a5,8(sp)
  a31464:	17fd                	addi	a5,a5,-1
  a31466:	c43e                	sw	a5,8(sp)
  a31468:	0007c663          	bltz	a5,a31474 <SecVsnprintfImpl+0x2a>
  a3146c:	47b2                	lw	a5,12(sp)
  a3146e:	00078023          	sb	zero,0(a5)
  a31472:	8134                	popret	{ra,s0-s1},32
  a31474:	47a2                	lw	a5,8(sp)
  a31476:	0007d763          	bgez	a5,a31484 <SecVsnprintfImpl+0x3a>
  a3147a:	9426                	add	s0,s0,s1
  a3147c:	fe040fa3          	sb	zero,-1(s0)
  a31480:	5579                	li	a0,-2
  a31482:	bfc5                	j	a31472 <SecVsnprintfImpl+0x28>
  a31484:	00040023          	sb	zero,0(s0)
  a31488:	557d                	li	a0,-1
  a3148a:	b7e5                	j	a31472 <SecVsnprintfImpl+0x28>

00a3148c <vsnprintf_s>:
  a3148c:	8028                	push	{ra,s0},-16
  a3148e:	8832                	mv	a6,a2
  a31490:	842a                	mv	s0,a0
  a31492:	87ae                	mv	a5,a1
  a31494:	8636                	mv	a2,a3
  a31496:	ca8d                	beqz	a3,a314c8 <vsnprintf_s+0x3c>
  a31498:	e119                	bnez	a0,a3149e <vsnprintf_s+0x12>
  a3149a:	557d                	li	a0,-1
  a3149c:	8024                	popret	{ra,s0},16
  a3149e:	ddf5                	beqz	a1,a3149a <vsnprintf_s+0xe>
  a314a0:	fe05cde3          	bltz	a1,a3149a <vsnprintf_s+0xe>
  a314a4:	800008b7          	lui	a7,0x80000
  a314a8:	ffe8c893          	xori	a7,a7,-2
  a314ac:	0308e063          	bltu	a7,a6,a314cc <vsnprintf_s+0x40>
  a314b0:	86ba                	mv	a3,a4
  a314b2:	02b87263          	bgeu	a6,a1,a314d6 <vsnprintf_s+0x4a>
  a314b6:	00180593          	addi	a1,a6,1
  a314ba:	f91ff0ef          	jal	ra,a3144a <SecVsnprintfImpl>
  a314be:	fef5073b          	beqi	a0,-2,a3149a <vsnprintf_s+0xe>
  a314c2:	fc055de3          	bgez	a0,a3149c <vsnprintf_s+0x10>
  a314c6:	a029                	j	a314d0 <vsnprintf_s+0x44>
  a314c8:	d969                	beqz	a0,a3149a <vsnprintf_s+0xe>
  a314ca:	d9e1                	beqz	a1,a3149a <vsnprintf_s+0xe>
  a314cc:	fc07c7e3          	bltz	a5,a3149a <vsnprintf_s+0xe>
  a314d0:	00040023          	sb	zero,0(s0)
  a314d4:	b7d9                	j	a3149a <vsnprintf_s+0xe>
  a314d6:	f75ff0ef          	jal	ra,a3144a <SecVsnprintfImpl>
  a314da:	b7e5                	j	a314c2 <vsnprintf_s+0x36>
  a314dc:	04f9                	addi	s1,s1,30
  a314de:	0000                	unimp
  a314e0:	00000003          	lb	zero,0(zero) # 0 <__data_size__-0x1e8>
	...

00a314f0 <excp_vect_table>:
  a314f0:	d21c                	sw	a5,32(a2)
  a314f2:	00a2                	slli	ra,ra,0x8
  a314f4:	d232                	sw	a2,36(sp)
  a314f6:	00a2                	slli	ra,ra,0x8
  a314f8:	d248                	sw	a0,36(a2)
  a314fa:	00a2                	slli	ra,ra,0x8
  a314fc:	d2f8                	sw	a4,100(a3)
  a314fe:	00a2                	slli	ra,ra,0x8
  a31500:	d25e                	sw	s7,36(sp)
  a31502:	00a2                	slli	ra,ra,0x8
  a31504:	d274                	sw	a3,100(a2)
  a31506:	00a2                	slli	ra,ra,0x8
  a31508:	d28a                	sw	sp,100(sp)
  a3150a:	00a2                	slli	ra,ra,0x8
  a3150c:	d2a0                	sw	s0,96(a3)
  a3150e:	00a2                	slli	ra,ra,0x8
  a31510:	d2b6                	sw	a3,100(sp)
  a31512:	00a2                	slli	ra,ra,0x8
  a31514:	d2cc                	sw	a1,36(a3)
  a31516:	00a2                	slli	ra,ra,0x8
  a31518:	d206                	sw	ra,36(sp)
  a3151a:	00a2                	slli	ra,ra,0x8
  a3151c:	d2e2                	sw	s8,100(sp)
  a3151e:	00a2                	slli	ra,ra,0x8
  a31520:	d30e                	sw	gp,164(sp)
  a31522:	00a2                	slli	ra,ra,0x8
  a31524:	d324                	sw	s1,96(a4)
  a31526:	00a2                	slli	ra,ra,0x8
  a31528:	d206                	sw	ra,36(sp)
  a3152a:	00a2                	slli	ra,ra,0x8
  a3152c:	d33a                	sw	a4,164(sp)
  a3152e:	00a2                	slli	ra,ra,0x8
  a31530:	d350                	sw	a2,36(a4)
  a31532:	00a2                	slli	ra,ra,0x8
  a31534:	d366                	sw	s9,164(sp)
  a31536:	00a2                	slli	ra,ra,0x8

00a31538 <excp_vect_table_end>:
	...

00a31540 <trap_entry>:
  a31540:	7175                	addi	sp,sp,-144
  a31542:	d06e                	sw	s11,32(sp)
  a31544:	d26a                	sw	s10,36(sp)
  a31546:	d466                	sw	s9,40(sp)
  a31548:	d662                	sw	s8,44(sp)
  a3154a:	d85e                	sw	s7,48(sp)
  a3154c:	da5a                	sw	s6,52(sp)
  a3154e:	dc56                	sw	s5,56(sp)
  a31550:	de52                	sw	s4,60(sp)
  a31552:	c0ce                	sw	s3,64(sp)
  a31554:	c2ca                	sw	s2,68(sp)
  a31556:	c4a6                	sw	s1,72(sp)
  a31558:	c6a2                	sw	s0,76(sp)
  a3155a:	c8fe                	sw	t6,80(sp)
  a3155c:	cafa                	sw	t5,84(sp)
  a3155e:	ccf6                	sw	t4,88(sp)
  a31560:	cef2                	sw	t3,92(sp)
  a31562:	d0c6                	sw	a7,96(sp)
  a31564:	d2c2                	sw	a6,100(sp)
  a31566:	d4be                	sw	a5,104(sp)
  a31568:	d6ba                	sw	a4,108(sp)
  a3156a:	d8b6                	sw	a3,112(sp)
  a3156c:	dab2                	sw	a2,116(sp)
  a3156e:	dcae                	sw	a1,120(sp)
  a31570:	deaa                	sw	a0,124(sp)
  a31572:	c11e                	sw	t2,128(sp)
  a31574:	c31a                	sw	t1,132(sp)
  a31576:	c516                	sw	t0,136(sp)
  a31578:	c706                	sw	ra,140(sp)
  a3157a:	fc202a73          	csrr	s4,0xfc2
  a3157e:	c052                	sw	s4,0(sp)
  a31580:	342029f3          	csrr	s3,mcause
  a31584:	c24e                	sw	s3,4(sp)
  a31586:	34302973          	csrr	s2,mtval
  a3158a:	c44a                	sw	s2,8(sp)
  a3158c:	c60e                	sw	gp,12(sp)
  a3158e:	300024f3          	csrr	s1,mstatus
  a31592:	c826                	sw	s1,16(sp)
  a31594:	34102473          	csrr	s0,mepc
  a31598:	ca22                	sw	s0,20(sp)
  a3159a:	cc12                	sw	tp,24(sp)
  a3159c:	ce0a                	sw	sp,28(sp)
  a3159e:	30047073          	csrci	mstatus,8
  a315a2:	34011073          	csrw	mscratch,sp
  a315a6:	fffd4117          	auipc	sp,0xfffd4
  a315aa:	f5a10113          	addi	sp,sp,-166 # a05500 <g_flash_cmd_funcs>
  a315ae:	42a1                	li	t0,8
  a315b0:	00599463          	bne	s3,t0,a315b8 <trap_entry+0x78>
  a315b4:	f9ff606f          	j	a28552 <handle_syscall>
  a315b8:	00299293          	slli	t0,s3,0x2
  a315bc:	00000317          	auipc	t1,0x0
  a315c0:	f3430313          	addi	t1,t1,-204 # a314f0 <excp_vect_table>
  a315c4:	00000397          	auipc	t2,0x0
  a315c8:	f7438393          	addi	t2,t2,-140 # a31538 <excp_vect_table_end>
  a315cc:	34002573          	csrr	a0,mscratch
  a315d0:	929a                	add	t0,t0,t1
  a315d2:	0472ff63          	bgeu	t0,t2,a31630 <trap_entry+0xf0>
  a315d6:	0002a283          	lw	t0,0(t0) # 1000000 <_gp_+0x5cb7bc>
  a315da:	989fb0ef          	jal	ra,a2cf62 <do_hard_fault_handler>
  a315de:	34002173          	csrr	sp,mscratch
  a315e2:	6289                	lui	t0,0x2
  a315e4:	80028293          	addi	t0,t0,-2048 # 1800 <ccause+0x83e>
  a315e8:	3002a073          	csrs	mstatus,t0
  a315ec:	42d2                	lw	t0,20(sp)
  a315ee:	34129073          	csrw	mepc,t0
  a315f2:	5d82                	lw	s11,32(sp)
  a315f4:	5d12                	lw	s10,36(sp)
  a315f6:	5ca2                	lw	s9,40(sp)
  a315f8:	5c32                	lw	s8,44(sp)
  a315fa:	5bc2                	lw	s7,48(sp)
  a315fc:	5b52                	lw	s6,52(sp)
  a315fe:	5ae2                	lw	s5,56(sp)
  a31600:	5a72                	lw	s4,60(sp)
  a31602:	4986                	lw	s3,64(sp)
  a31604:	4916                	lw	s2,68(sp)
  a31606:	44a6                	lw	s1,72(sp)
  a31608:	4436                	lw	s0,76(sp)
  a3160a:	4fc6                	lw	t6,80(sp)
  a3160c:	4f56                	lw	t5,84(sp)
  a3160e:	4ee6                	lw	t4,88(sp)
  a31610:	4e76                	lw	t3,92(sp)
  a31612:	5886                	lw	a7,96(sp)
  a31614:	5816                	lw	a6,100(sp)
  a31616:	57a6                	lw	a5,104(sp)
  a31618:	5736                	lw	a4,108(sp)
  a3161a:	56c6                	lw	a3,112(sp)
  a3161c:	5656                	lw	a2,116(sp)
  a3161e:	55e6                	lw	a1,120(sp)
  a31620:	5576                	lw	a0,124(sp)
  a31622:	438a                	lw	t2,128(sp)
  a31624:	431a                	lw	t1,132(sp)
  a31626:	42aa                	lw	t0,136(sp)
  a31628:	40ba                	lw	ra,140(sp)
  a3162a:	6149                	addi	sp,sp,144
  a3162c:	30200073          	mret
  a31630:	bd7fb06f          	j	a2d206 <do_trap_unknown>
	...

00a3163c <trap_vector>:
  a3163c:	f05ff06f          	j	a31540 <trap_entry>
  a31640:	d3dfb06f          	j	a2d37c <default_handler>
  a31644:	d39fb06f          	j	a2d37c <default_handler>
  a31648:	d35fb06f          	j	a2d37c <default_handler>
  a3164c:	d31fb06f          	j	a2d37c <default_handler>
  a31650:	d2dfb06f          	j	a2d37c <default_handler>
  a31654:	d29fb06f          	j	a2d37c <default_handler>
  a31658:	d25fb06f          	j	a2d37c <default_handler>
  a3165c:	d21fb06f          	j	a2d37c <default_handler>
  a31660:	d1dfb06f          	j	a2d37c <default_handler>
  a31664:	d19fb06f          	j	a2d37c <default_handler>
  a31668:	d15fb06f          	j	a2d37c <default_handler>
  a3166c:	1700006f          	j	a317dc <nmi_vector>
  a31670:	d0dfb06f          	j	a2d37c <default_handler>
  a31674:	d09fb06f          	j	a2d37c <default_handler>
  a31678:	d05fb06f          	j	a2d37c <default_handler>
  a3167c:	d01fb06f          	j	a2d37c <default_handler>
  a31680:	cfdfb06f          	j	a2d37c <default_handler>
  a31684:	cf9fb06f          	j	a2d37c <default_handler>
  a31688:	cf5fb06f          	j	a2d37c <default_handler>
  a3168c:	cf1fb06f          	j	a2d37c <default_handler>
  a31690:	cedfb06f          	j	a2d37c <default_handler>
  a31694:	ce9fb06f          	j	a2d37c <default_handler>
  a31698:	ce5fb06f          	j	a2d37c <default_handler>
  a3169c:	ce1fb06f          	j	a2d37c <default_handler>
  a316a0:	cddfb06f          	j	a2d37c <default_handler>
  a316a4:	2000006f          	j	a318a4 <default_interrupt0_handler>
  a316a8:	2a80006f          	j	a31950 <default_interrupt1_handler>
  a316ac:	3500006f          	j	a319fc <default_interrupt2_handler>
  a316b0:	3f80006f          	j	a31aa8 <default_interrupt3_handler>
  a316b4:	4a00006f          	j	a31b54 <default_interrupt4_handler>
  a316b8:	5480006f          	j	a31c00 <default_interrupt5_handler>
  a316bc:	5f00006f          	j	a31cac <default_local_interrupt_handler>
  a316c0:	5ec0006f          	j	a31cac <default_local_interrupt_handler>
  a316c4:	5e80006f          	j	a31cac <default_local_interrupt_handler>
  a316c8:	5e40006f          	j	a31cac <default_local_interrupt_handler>
  a316cc:	5e00006f          	j	a31cac <default_local_interrupt_handler>
  a316d0:	5dc0006f          	j	a31cac <default_local_interrupt_handler>
  a316d4:	5d80006f          	j	a31cac <default_local_interrupt_handler>
  a316d8:	5d40006f          	j	a31cac <default_local_interrupt_handler>
  a316dc:	5d00006f          	j	a31cac <default_local_interrupt_handler>
  a316e0:	5cc0006f          	j	a31cac <default_local_interrupt_handler>
  a316e4:	5c80006f          	j	a31cac <default_local_interrupt_handler>
  a316e8:	5c40006f          	j	a31cac <default_local_interrupt_handler>
  a316ec:	5c00006f          	j	a31cac <default_local_interrupt_handler>
  a316f0:	5bc0006f          	j	a31cac <default_local_interrupt_handler>
  a316f4:	5b80006f          	j	a31cac <default_local_interrupt_handler>
  a316f8:	5b40006f          	j	a31cac <default_local_interrupt_handler>
  a316fc:	5b00006f          	j	a31cac <default_local_interrupt_handler>
  a31700:	5ac0006f          	j	a31cac <default_local_interrupt_handler>
  a31704:	5a80006f          	j	a31cac <default_local_interrupt_handler>
  a31708:	5a40006f          	j	a31cac <default_local_interrupt_handler>
  a3170c:	5a00006f          	j	a31cac <default_local_interrupt_handler>
  a31710:	59c0006f          	j	a31cac <default_local_interrupt_handler>
  a31714:	5980006f          	j	a31cac <default_local_interrupt_handler>
  a31718:	5940006f          	j	a31cac <default_local_interrupt_handler>
  a3171c:	5900006f          	j	a31cac <default_local_interrupt_handler>
  a31720:	58c0006f          	j	a31cac <default_local_interrupt_handler>
  a31724:	5880006f          	j	a31cac <default_local_interrupt_handler>
  a31728:	5840006f          	j	a31cac <default_local_interrupt_handler>
  a3172c:	5800006f          	j	a31cac <default_local_interrupt_handler>
  a31730:	57c0006f          	j	a31cac <default_local_interrupt_handler>
  a31734:	5780006f          	j	a31cac <default_local_interrupt_handler>
  a31738:	5740006f          	j	a31cac <default_local_interrupt_handler>
  a3173c:	5700006f          	j	a31cac <default_local_interrupt_handler>
  a31740:	56c0006f          	j	a31cac <default_local_interrupt_handler>
  a31744:	5680006f          	j	a31cac <default_local_interrupt_handler>
  a31748:	5640006f          	j	a31cac <default_local_interrupt_handler>
  a3174c:	5600006f          	j	a31cac <default_local_interrupt_handler>
  a31750:	55c0006f          	j	a31cac <default_local_interrupt_handler>
  a31754:	5580006f          	j	a31cac <default_local_interrupt_handler>
  a31758:	5540006f          	j	a31cac <default_local_interrupt_handler>
  a3175c:	5500006f          	j	a31cac <default_local_interrupt_handler>
  a31760:	54c0006f          	j	a31cac <default_local_interrupt_handler>
  a31764:	5480006f          	j	a31cac <default_local_interrupt_handler>
  a31768:	5440006f          	j	a31cac <default_local_interrupt_handler>
  a3176c:	5400006f          	j	a31cac <default_local_interrupt_handler>
  a31770:	53c0006f          	j	a31cac <default_local_interrupt_handler>
  a31774:	5380006f          	j	a31cac <default_local_interrupt_handler>
  a31778:	5340006f          	j	a31cac <default_local_interrupt_handler>
  a3177c:	5300006f          	j	a31cac <default_local_interrupt_handler>
  a31780:	52c0006f          	j	a31cac <default_local_interrupt_handler>
  a31784:	5280006f          	j	a31cac <default_local_interrupt_handler>
  a31788:	5240006f          	j	a31cac <default_local_interrupt_handler>
  a3178c:	5200006f          	j	a31cac <default_local_interrupt_handler>
  a31790:	51c0006f          	j	a31cac <default_local_interrupt_handler>
  a31794:	5180006f          	j	a31cac <default_local_interrupt_handler>
  a31798:	5140006f          	j	a31cac <default_local_interrupt_handler>
  a3179c:	5100006f          	j	a31cac <default_local_interrupt_handler>
  a317a0:	50c0006f          	j	a31cac <default_local_interrupt_handler>
  a317a4:	5080006f          	j	a31cac <default_local_interrupt_handler>
  a317a8:	5040006f          	j	a31cac <default_local_interrupt_handler>
  a317ac:	5000006f          	j	a31cac <default_local_interrupt_handler>
  a317b0:	4fc0006f          	j	a31cac <default_local_interrupt_handler>
  a317b4:	4f80006f          	j	a31cac <default_local_interrupt_handler>
  a317b8:	4f40006f          	j	a31cac <default_local_interrupt_handler>
  a317bc:	4f00006f          	j	a31cac <default_local_interrupt_handler>
  a317c0:	4ec0006f          	j	a31cac <default_local_interrupt_handler>
  a317c4:	4e80006f          	j	a31cac <default_local_interrupt_handler>
  a317c8:	4e40006f          	j	a31cac <default_local_interrupt_handler>
  a317cc:	4e00006f          	j	a31cac <default_local_interrupt_handler>
  a317d0:	4dc0006f          	j	a31cac <default_local_interrupt_handler>
  a317d4:	4d80006f          	j	a31cac <default_local_interrupt_handler>
  a317d8:	0000                	unimp
	...

00a317dc <nmi_vector>:
  a317dc:	30047073          	csrci	mstatus,8
  a317e0:	7175                	addi	sp,sp,-144
  a317e2:	d06e                	sw	s11,32(sp)
  a317e4:	d26a                	sw	s10,36(sp)
  a317e6:	d466                	sw	s9,40(sp)
  a317e8:	d662                	sw	s8,44(sp)
  a317ea:	d85e                	sw	s7,48(sp)
  a317ec:	da5a                	sw	s6,52(sp)
  a317ee:	dc56                	sw	s5,56(sp)
  a317f0:	de52                	sw	s4,60(sp)
  a317f2:	c0ce                	sw	s3,64(sp)
  a317f4:	c2ca                	sw	s2,68(sp)
  a317f6:	c4a6                	sw	s1,72(sp)
  a317f8:	c6a2                	sw	s0,76(sp)
  a317fa:	c8fe                	sw	t6,80(sp)
  a317fc:	cafa                	sw	t5,84(sp)
  a317fe:	ccf6                	sw	t4,88(sp)
  a31800:	cef2                	sw	t3,92(sp)
  a31802:	d0c6                	sw	a7,96(sp)
  a31804:	d2c2                	sw	a6,100(sp)
  a31806:	d4be                	sw	a5,104(sp)
  a31808:	d6ba                	sw	a4,108(sp)
  a3180a:	d8b6                	sw	a3,112(sp)
  a3180c:	dab2                	sw	a2,116(sp)
  a3180e:	dcae                	sw	a1,120(sp)
  a31810:	deaa                	sw	a0,124(sp)
  a31812:	c11e                	sw	t2,128(sp)
  a31814:	c31a                	sw	t1,132(sp)
  a31816:	c516                	sw	t0,136(sp)
  a31818:	c706                	sw	ra,140(sp)
  a3181a:	fc202a73          	csrr	s4,0xfc2
  a3181e:	c052                	sw	s4,0(sp)
  a31820:	342029f3          	csrr	s3,mcause
  a31824:	c24e                	sw	s3,4(sp)
  a31826:	34302973          	csrr	s2,mtval
  a3182a:	c44a                	sw	s2,8(sp)
  a3182c:	c60e                	sw	gp,12(sp)
  a3182e:	300024f3          	csrr	s1,mstatus
  a31832:	c826                	sw	s1,16(sp)
  a31834:	34102473          	csrr	s0,mepc
  a31838:	ca22                	sw	s0,20(sp)
  a3183a:	cc12                	sw	tp,24(sp)
  a3183c:	ce0a                	sw	sp,28(sp)
  a3183e:	34011073          	csrw	mscratch,sp
  a31842:	fffd4117          	auipc	sp,0xfffd4
  a31846:	8be10113          	addi	sp,sp,-1858 # a05100 <__irq_stack_top__>
  a3184a:	34002573          	csrr	a0,mscratch
  a3184e:	f14fb0ef          	jal	ra,a2cf62 <do_hard_fault_handler>
  a31852:	34002173          	csrr	sp,mscratch
  a31856:	6289                	lui	t0,0x2
  a31858:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a3185c:	3002a073          	csrs	mstatus,t0
  a31860:	42d2                	lw	t0,20(sp)
  a31862:	34129073          	csrw	mepc,t0
  a31866:	5d82                	lw	s11,32(sp)
  a31868:	5d12                	lw	s10,36(sp)
  a3186a:	5ca2                	lw	s9,40(sp)
  a3186c:	5c32                	lw	s8,44(sp)
  a3186e:	5bc2                	lw	s7,48(sp)
  a31870:	5b52                	lw	s6,52(sp)
  a31872:	5ae2                	lw	s5,56(sp)
  a31874:	5a72                	lw	s4,60(sp)
  a31876:	4986                	lw	s3,64(sp)
  a31878:	4916                	lw	s2,68(sp)
  a3187a:	44a6                	lw	s1,72(sp)
  a3187c:	4436                	lw	s0,76(sp)
  a3187e:	4fc6                	lw	t6,80(sp)
  a31880:	4f56                	lw	t5,84(sp)
  a31882:	4ee6                	lw	t4,88(sp)
  a31884:	4e76                	lw	t3,92(sp)
  a31886:	5886                	lw	a7,96(sp)
  a31888:	5816                	lw	a6,100(sp)
  a3188a:	57a6                	lw	a5,104(sp)
  a3188c:	5736                	lw	a4,108(sp)
  a3188e:	56c6                	lw	a3,112(sp)
  a31890:	5656                	lw	a2,116(sp)
  a31892:	55e6                	lw	a1,120(sp)
  a31894:	5576                	lw	a0,124(sp)
  a31896:	438a                	lw	t2,128(sp)
  a31898:	431a                	lw	t1,132(sp)
  a3189a:	42aa                	lw	t0,136(sp)
  a3189c:	40ba                	lw	ra,140(sp)
  a3189e:	6149                	addi	sp,sp,144
  a318a0:	30200073          	mret

00a318a4 <default_interrupt0_handler>:
  a318a4:	30047073          	csrci	mstatus,8
  a318a8:	7119                	addi	sp,sp,-128
  a318aa:	c006                	sw	ra,0(sp)
  a318ac:	c20a                	sw	sp,4(sp)
  a318ae:	c40e                	sw	gp,8(sp)
  a318b0:	c612                	sw	tp,12(sp)
  a318b2:	c816                	sw	t0,16(sp)
  a318b4:	ca1a                	sw	t1,20(sp)
  a318b6:	cc1e                	sw	t2,24(sp)
  a318b8:	ce22                	sw	s0,28(sp)
  a318ba:	d026                	sw	s1,32(sp)
  a318bc:	d22a                	sw	a0,36(sp)
  a318be:	d42e                	sw	a1,40(sp)
  a318c0:	d632                	sw	a2,44(sp)
  a318c2:	d836                	sw	a3,48(sp)
  a318c4:	da3a                	sw	a4,52(sp)
  a318c6:	dc3e                	sw	a5,56(sp)
  a318c8:	de42                	sw	a6,60(sp)
  a318ca:	c0c6                	sw	a7,64(sp)
  a318cc:	c2ca                	sw	s2,68(sp)
  a318ce:	c4ce                	sw	s3,72(sp)
  a318d0:	c6d2                	sw	s4,76(sp)
  a318d2:	c8d6                	sw	s5,80(sp)
  a318d4:	cada                	sw	s6,84(sp)
  a318d6:	ccde                	sw	s7,88(sp)
  a318d8:	cee2                	sw	s8,92(sp)
  a318da:	d0e6                	sw	s9,96(sp)
  a318dc:	d2ea                	sw	s10,100(sp)
  a318de:	d4ee                	sw	s11,104(sp)
  a318e0:	d6f2                	sw	t3,108(sp)
  a318e2:	d8f6                	sw	t4,112(sp)
  a318e4:	dafa                	sw	t5,116(sp)
  a318e6:	dcfe                	sw	t6,120(sp)
  a318e8:	341022f3          	csrr	t0,mepc
  a318ec:	de96                	sw	t0,124(sp)
  a318ee:	34011073          	csrw	mscratch,sp
  a318f2:	fffd4117          	auipc	sp,0xfffd4
  a318f6:	80e10113          	addi	sp,sp,-2034 # a05100 <__irq_stack_top__>
  a318fa:	c82fb0ef          	jal	ra,a2cd7c <interrupt0_handler>
  a318fe:	34002173          	csrr	sp,mscratch
  a31902:	6289                	lui	t0,0x2
  a31904:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a31908:	3002a073          	csrs	mstatus,t0
  a3190c:	52f6                	lw	t0,124(sp)
  a3190e:	34129073          	csrw	mepc,t0
  a31912:	4082                	lw	ra,0(sp)
  a31914:	42c2                	lw	t0,16(sp)
  a31916:	4352                	lw	t1,20(sp)
  a31918:	43e2                	lw	t2,24(sp)
  a3191a:	4472                	lw	s0,28(sp)
  a3191c:	5482                	lw	s1,32(sp)
  a3191e:	5512                	lw	a0,36(sp)
  a31920:	55a2                	lw	a1,40(sp)
  a31922:	5632                	lw	a2,44(sp)
  a31924:	56c2                	lw	a3,48(sp)
  a31926:	5752                	lw	a4,52(sp)
  a31928:	57e2                	lw	a5,56(sp)
  a3192a:	5872                	lw	a6,60(sp)
  a3192c:	4886                	lw	a7,64(sp)
  a3192e:	4916                	lw	s2,68(sp)
  a31930:	49a6                	lw	s3,72(sp)
  a31932:	4a36                	lw	s4,76(sp)
  a31934:	4ac6                	lw	s5,80(sp)
  a31936:	4b56                	lw	s6,84(sp)
  a31938:	4be6                	lw	s7,88(sp)
  a3193a:	4c76                	lw	s8,92(sp)
  a3193c:	5c86                	lw	s9,96(sp)
  a3193e:	5d16                	lw	s10,100(sp)
  a31940:	5da6                	lw	s11,104(sp)
  a31942:	5e36                	lw	t3,108(sp)
  a31944:	5ec6                	lw	t4,112(sp)
  a31946:	5f56                	lw	t5,116(sp)
  a31948:	5fe6                	lw	t6,120(sp)
  a3194a:	6109                	addi	sp,sp,128
  a3194c:	30200073          	mret

00a31950 <default_interrupt1_handler>:
  a31950:	30047073          	csrci	mstatus,8
  a31954:	7119                	addi	sp,sp,-128
  a31956:	c006                	sw	ra,0(sp)
  a31958:	c20a                	sw	sp,4(sp)
  a3195a:	c40e                	sw	gp,8(sp)
  a3195c:	c612                	sw	tp,12(sp)
  a3195e:	c816                	sw	t0,16(sp)
  a31960:	ca1a                	sw	t1,20(sp)
  a31962:	cc1e                	sw	t2,24(sp)
  a31964:	ce22                	sw	s0,28(sp)
  a31966:	d026                	sw	s1,32(sp)
  a31968:	d22a                	sw	a0,36(sp)
  a3196a:	d42e                	sw	a1,40(sp)
  a3196c:	d632                	sw	a2,44(sp)
  a3196e:	d836                	sw	a3,48(sp)
  a31970:	da3a                	sw	a4,52(sp)
  a31972:	dc3e                	sw	a5,56(sp)
  a31974:	de42                	sw	a6,60(sp)
  a31976:	c0c6                	sw	a7,64(sp)
  a31978:	c2ca                	sw	s2,68(sp)
  a3197a:	c4ce                	sw	s3,72(sp)
  a3197c:	c6d2                	sw	s4,76(sp)
  a3197e:	c8d6                	sw	s5,80(sp)
  a31980:	cada                	sw	s6,84(sp)
  a31982:	ccde                	sw	s7,88(sp)
  a31984:	cee2                	sw	s8,92(sp)
  a31986:	d0e6                	sw	s9,96(sp)
  a31988:	d2ea                	sw	s10,100(sp)
  a3198a:	d4ee                	sw	s11,104(sp)
  a3198c:	d6f2                	sw	t3,108(sp)
  a3198e:	d8f6                	sw	t4,112(sp)
  a31990:	dafa                	sw	t5,116(sp)
  a31992:	dcfe                	sw	t6,120(sp)
  a31994:	341022f3          	csrr	t0,mepc
  a31998:	de96                	sw	t0,124(sp)
  a3199a:	34011073          	csrw	mscratch,sp
  a3199e:	fffd3117          	auipc	sp,0xfffd3
  a319a2:	76210113          	addi	sp,sp,1890 # a05100 <__irq_stack_top__>
  a319a6:	c16fb0ef          	jal	ra,a2cdbc <interrupt1_handler>
  a319aa:	34002173          	csrr	sp,mscratch
  a319ae:	6289                	lui	t0,0x2
  a319b0:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a319b4:	3002a073          	csrs	mstatus,t0
  a319b8:	52f6                	lw	t0,124(sp)
  a319ba:	34129073          	csrw	mepc,t0
  a319be:	4082                	lw	ra,0(sp)
  a319c0:	42c2                	lw	t0,16(sp)
  a319c2:	4352                	lw	t1,20(sp)
  a319c4:	43e2                	lw	t2,24(sp)
  a319c6:	4472                	lw	s0,28(sp)
  a319c8:	5482                	lw	s1,32(sp)
  a319ca:	5512                	lw	a0,36(sp)
  a319cc:	55a2                	lw	a1,40(sp)
  a319ce:	5632                	lw	a2,44(sp)
  a319d0:	56c2                	lw	a3,48(sp)
  a319d2:	5752                	lw	a4,52(sp)
  a319d4:	57e2                	lw	a5,56(sp)
  a319d6:	5872                	lw	a6,60(sp)
  a319d8:	4886                	lw	a7,64(sp)
  a319da:	4916                	lw	s2,68(sp)
  a319dc:	49a6                	lw	s3,72(sp)
  a319de:	4a36                	lw	s4,76(sp)
  a319e0:	4ac6                	lw	s5,80(sp)
  a319e2:	4b56                	lw	s6,84(sp)
  a319e4:	4be6                	lw	s7,88(sp)
  a319e6:	4c76                	lw	s8,92(sp)
  a319e8:	5c86                	lw	s9,96(sp)
  a319ea:	5d16                	lw	s10,100(sp)
  a319ec:	5da6                	lw	s11,104(sp)
  a319ee:	5e36                	lw	t3,108(sp)
  a319f0:	5ec6                	lw	t4,112(sp)
  a319f2:	5f56                	lw	t5,116(sp)
  a319f4:	5fe6                	lw	t6,120(sp)
  a319f6:	6109                	addi	sp,sp,128
  a319f8:	30200073          	mret

00a319fc <default_interrupt2_handler>:
  a319fc:	30047073          	csrci	mstatus,8
  a31a00:	7119                	addi	sp,sp,-128
  a31a02:	c006                	sw	ra,0(sp)
  a31a04:	c20a                	sw	sp,4(sp)
  a31a06:	c40e                	sw	gp,8(sp)
  a31a08:	c612                	sw	tp,12(sp)
  a31a0a:	c816                	sw	t0,16(sp)
  a31a0c:	ca1a                	sw	t1,20(sp)
  a31a0e:	cc1e                	sw	t2,24(sp)
  a31a10:	ce22                	sw	s0,28(sp)
  a31a12:	d026                	sw	s1,32(sp)
  a31a14:	d22a                	sw	a0,36(sp)
  a31a16:	d42e                	sw	a1,40(sp)
  a31a18:	d632                	sw	a2,44(sp)
  a31a1a:	d836                	sw	a3,48(sp)
  a31a1c:	da3a                	sw	a4,52(sp)
  a31a1e:	dc3e                	sw	a5,56(sp)
  a31a20:	de42                	sw	a6,60(sp)
  a31a22:	c0c6                	sw	a7,64(sp)
  a31a24:	c2ca                	sw	s2,68(sp)
  a31a26:	c4ce                	sw	s3,72(sp)
  a31a28:	c6d2                	sw	s4,76(sp)
  a31a2a:	c8d6                	sw	s5,80(sp)
  a31a2c:	cada                	sw	s6,84(sp)
  a31a2e:	ccde                	sw	s7,88(sp)
  a31a30:	cee2                	sw	s8,92(sp)
  a31a32:	d0e6                	sw	s9,96(sp)
  a31a34:	d2ea                	sw	s10,100(sp)
  a31a36:	d4ee                	sw	s11,104(sp)
  a31a38:	d6f2                	sw	t3,108(sp)
  a31a3a:	d8f6                	sw	t4,112(sp)
  a31a3c:	dafa                	sw	t5,116(sp)
  a31a3e:	dcfe                	sw	t6,120(sp)
  a31a40:	341022f3          	csrr	t0,mepc
  a31a44:	de96                	sw	t0,124(sp)
  a31a46:	34011073          	csrw	mscratch,sp
  a31a4a:	fffd3117          	auipc	sp,0xfffd3
  a31a4e:	6b610113          	addi	sp,sp,1718 # a05100 <__irq_stack_top__>
  a31a52:	baafb0ef          	jal	ra,a2cdfc <interrupt2_handler>
  a31a56:	34002173          	csrr	sp,mscratch
  a31a5a:	6289                	lui	t0,0x2
  a31a5c:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a31a60:	3002a073          	csrs	mstatus,t0
  a31a64:	52f6                	lw	t0,124(sp)
  a31a66:	34129073          	csrw	mepc,t0
  a31a6a:	4082                	lw	ra,0(sp)
  a31a6c:	42c2                	lw	t0,16(sp)
  a31a6e:	4352                	lw	t1,20(sp)
  a31a70:	43e2                	lw	t2,24(sp)
  a31a72:	4472                	lw	s0,28(sp)
  a31a74:	5482                	lw	s1,32(sp)
  a31a76:	5512                	lw	a0,36(sp)
  a31a78:	55a2                	lw	a1,40(sp)
  a31a7a:	5632                	lw	a2,44(sp)
  a31a7c:	56c2                	lw	a3,48(sp)
  a31a7e:	5752                	lw	a4,52(sp)
  a31a80:	57e2                	lw	a5,56(sp)
  a31a82:	5872                	lw	a6,60(sp)
  a31a84:	4886                	lw	a7,64(sp)
  a31a86:	4916                	lw	s2,68(sp)
  a31a88:	49a6                	lw	s3,72(sp)
  a31a8a:	4a36                	lw	s4,76(sp)
  a31a8c:	4ac6                	lw	s5,80(sp)
  a31a8e:	4b56                	lw	s6,84(sp)
  a31a90:	4be6                	lw	s7,88(sp)
  a31a92:	4c76                	lw	s8,92(sp)
  a31a94:	5c86                	lw	s9,96(sp)
  a31a96:	5d16                	lw	s10,100(sp)
  a31a98:	5da6                	lw	s11,104(sp)
  a31a9a:	5e36                	lw	t3,108(sp)
  a31a9c:	5ec6                	lw	t4,112(sp)
  a31a9e:	5f56                	lw	t5,116(sp)
  a31aa0:	5fe6                	lw	t6,120(sp)
  a31aa2:	6109                	addi	sp,sp,128
  a31aa4:	30200073          	mret

00a31aa8 <default_interrupt3_handler>:
  a31aa8:	30047073          	csrci	mstatus,8
  a31aac:	7119                	addi	sp,sp,-128
  a31aae:	c006                	sw	ra,0(sp)
  a31ab0:	c20a                	sw	sp,4(sp)
  a31ab2:	c40e                	sw	gp,8(sp)
  a31ab4:	c612                	sw	tp,12(sp)
  a31ab6:	c816                	sw	t0,16(sp)
  a31ab8:	ca1a                	sw	t1,20(sp)
  a31aba:	cc1e                	sw	t2,24(sp)
  a31abc:	ce22                	sw	s0,28(sp)
  a31abe:	d026                	sw	s1,32(sp)
  a31ac0:	d22a                	sw	a0,36(sp)
  a31ac2:	d42e                	sw	a1,40(sp)
  a31ac4:	d632                	sw	a2,44(sp)
  a31ac6:	d836                	sw	a3,48(sp)
  a31ac8:	da3a                	sw	a4,52(sp)
  a31aca:	dc3e                	sw	a5,56(sp)
  a31acc:	de42                	sw	a6,60(sp)
  a31ace:	c0c6                	sw	a7,64(sp)
  a31ad0:	c2ca                	sw	s2,68(sp)
  a31ad2:	c4ce                	sw	s3,72(sp)
  a31ad4:	c6d2                	sw	s4,76(sp)
  a31ad6:	c8d6                	sw	s5,80(sp)
  a31ad8:	cada                	sw	s6,84(sp)
  a31ada:	ccde                	sw	s7,88(sp)
  a31adc:	cee2                	sw	s8,92(sp)
  a31ade:	d0e6                	sw	s9,96(sp)
  a31ae0:	d2ea                	sw	s10,100(sp)
  a31ae2:	d4ee                	sw	s11,104(sp)
  a31ae4:	d6f2                	sw	t3,108(sp)
  a31ae6:	d8f6                	sw	t4,112(sp)
  a31ae8:	dafa                	sw	t5,116(sp)
  a31aea:	dcfe                	sw	t6,120(sp)
  a31aec:	341022f3          	csrr	t0,mepc
  a31af0:	de96                	sw	t0,124(sp)
  a31af2:	34011073          	csrw	mscratch,sp
  a31af6:	fffd3117          	auipc	sp,0xfffd3
  a31afa:	60a10113          	addi	sp,sp,1546 # a05100 <__irq_stack_top__>
  a31afe:	b3efb0ef          	jal	ra,a2ce3c <interrupt3_handler>
  a31b02:	34002173          	csrr	sp,mscratch
  a31b06:	6289                	lui	t0,0x2
  a31b08:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a31b0c:	3002a073          	csrs	mstatus,t0
  a31b10:	52f6                	lw	t0,124(sp)
  a31b12:	34129073          	csrw	mepc,t0
  a31b16:	4082                	lw	ra,0(sp)
  a31b18:	42c2                	lw	t0,16(sp)
  a31b1a:	4352                	lw	t1,20(sp)
  a31b1c:	43e2                	lw	t2,24(sp)
  a31b1e:	4472                	lw	s0,28(sp)
  a31b20:	5482                	lw	s1,32(sp)
  a31b22:	5512                	lw	a0,36(sp)
  a31b24:	55a2                	lw	a1,40(sp)
  a31b26:	5632                	lw	a2,44(sp)
  a31b28:	56c2                	lw	a3,48(sp)
  a31b2a:	5752                	lw	a4,52(sp)
  a31b2c:	57e2                	lw	a5,56(sp)
  a31b2e:	5872                	lw	a6,60(sp)
  a31b30:	4886                	lw	a7,64(sp)
  a31b32:	4916                	lw	s2,68(sp)
  a31b34:	49a6                	lw	s3,72(sp)
  a31b36:	4a36                	lw	s4,76(sp)
  a31b38:	4ac6                	lw	s5,80(sp)
  a31b3a:	4b56                	lw	s6,84(sp)
  a31b3c:	4be6                	lw	s7,88(sp)
  a31b3e:	4c76                	lw	s8,92(sp)
  a31b40:	5c86                	lw	s9,96(sp)
  a31b42:	5d16                	lw	s10,100(sp)
  a31b44:	5da6                	lw	s11,104(sp)
  a31b46:	5e36                	lw	t3,108(sp)
  a31b48:	5ec6                	lw	t4,112(sp)
  a31b4a:	5f56                	lw	t5,116(sp)
  a31b4c:	5fe6                	lw	t6,120(sp)
  a31b4e:	6109                	addi	sp,sp,128
  a31b50:	30200073          	mret

00a31b54 <default_interrupt4_handler>:
  a31b54:	30047073          	csrci	mstatus,8
  a31b58:	7119                	addi	sp,sp,-128
  a31b5a:	c006                	sw	ra,0(sp)
  a31b5c:	c20a                	sw	sp,4(sp)
  a31b5e:	c40e                	sw	gp,8(sp)
  a31b60:	c612                	sw	tp,12(sp)
  a31b62:	c816                	sw	t0,16(sp)
  a31b64:	ca1a                	sw	t1,20(sp)
  a31b66:	cc1e                	sw	t2,24(sp)
  a31b68:	ce22                	sw	s0,28(sp)
  a31b6a:	d026                	sw	s1,32(sp)
  a31b6c:	d22a                	sw	a0,36(sp)
  a31b6e:	d42e                	sw	a1,40(sp)
  a31b70:	d632                	sw	a2,44(sp)
  a31b72:	d836                	sw	a3,48(sp)
  a31b74:	da3a                	sw	a4,52(sp)
  a31b76:	dc3e                	sw	a5,56(sp)
  a31b78:	de42                	sw	a6,60(sp)
  a31b7a:	c0c6                	sw	a7,64(sp)
  a31b7c:	c2ca                	sw	s2,68(sp)
  a31b7e:	c4ce                	sw	s3,72(sp)
  a31b80:	c6d2                	sw	s4,76(sp)
  a31b82:	c8d6                	sw	s5,80(sp)
  a31b84:	cada                	sw	s6,84(sp)
  a31b86:	ccde                	sw	s7,88(sp)
  a31b88:	cee2                	sw	s8,92(sp)
  a31b8a:	d0e6                	sw	s9,96(sp)
  a31b8c:	d2ea                	sw	s10,100(sp)
  a31b8e:	d4ee                	sw	s11,104(sp)
  a31b90:	d6f2                	sw	t3,108(sp)
  a31b92:	d8f6                	sw	t4,112(sp)
  a31b94:	dafa                	sw	t5,116(sp)
  a31b96:	dcfe                	sw	t6,120(sp)
  a31b98:	341022f3          	csrr	t0,mepc
  a31b9c:	de96                	sw	t0,124(sp)
  a31b9e:	34011073          	csrw	mscratch,sp
  a31ba2:	fffd3117          	auipc	sp,0xfffd3
  a31ba6:	55e10113          	addi	sp,sp,1374 # a05100 <__irq_stack_top__>
  a31baa:	ad2fb0ef          	jal	ra,a2ce7c <interrupt4_handler>
  a31bae:	34002173          	csrr	sp,mscratch
  a31bb2:	6289                	lui	t0,0x2
  a31bb4:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a31bb8:	3002a073          	csrs	mstatus,t0
  a31bbc:	52f6                	lw	t0,124(sp)
  a31bbe:	34129073          	csrw	mepc,t0
  a31bc2:	4082                	lw	ra,0(sp)
  a31bc4:	42c2                	lw	t0,16(sp)
  a31bc6:	4352                	lw	t1,20(sp)
  a31bc8:	43e2                	lw	t2,24(sp)
  a31bca:	4472                	lw	s0,28(sp)
  a31bcc:	5482                	lw	s1,32(sp)
  a31bce:	5512                	lw	a0,36(sp)
  a31bd0:	55a2                	lw	a1,40(sp)
  a31bd2:	5632                	lw	a2,44(sp)
  a31bd4:	56c2                	lw	a3,48(sp)
  a31bd6:	5752                	lw	a4,52(sp)
  a31bd8:	57e2                	lw	a5,56(sp)
  a31bda:	5872                	lw	a6,60(sp)
  a31bdc:	4886                	lw	a7,64(sp)
  a31bde:	4916                	lw	s2,68(sp)
  a31be0:	49a6                	lw	s3,72(sp)
  a31be2:	4a36                	lw	s4,76(sp)
  a31be4:	4ac6                	lw	s5,80(sp)
  a31be6:	4b56                	lw	s6,84(sp)
  a31be8:	4be6                	lw	s7,88(sp)
  a31bea:	4c76                	lw	s8,92(sp)
  a31bec:	5c86                	lw	s9,96(sp)
  a31bee:	5d16                	lw	s10,100(sp)
  a31bf0:	5da6                	lw	s11,104(sp)
  a31bf2:	5e36                	lw	t3,108(sp)
  a31bf4:	5ec6                	lw	t4,112(sp)
  a31bf6:	5f56                	lw	t5,116(sp)
  a31bf8:	5fe6                	lw	t6,120(sp)
  a31bfa:	6109                	addi	sp,sp,128
  a31bfc:	30200073          	mret

00a31c00 <default_interrupt5_handler>:
  a31c00:	30047073          	csrci	mstatus,8
  a31c04:	7119                	addi	sp,sp,-128
  a31c06:	c006                	sw	ra,0(sp)
  a31c08:	c20a                	sw	sp,4(sp)
  a31c0a:	c40e                	sw	gp,8(sp)
  a31c0c:	c612                	sw	tp,12(sp)
  a31c0e:	c816                	sw	t0,16(sp)
  a31c10:	ca1a                	sw	t1,20(sp)
  a31c12:	cc1e                	sw	t2,24(sp)
  a31c14:	ce22                	sw	s0,28(sp)
  a31c16:	d026                	sw	s1,32(sp)
  a31c18:	d22a                	sw	a0,36(sp)
  a31c1a:	d42e                	sw	a1,40(sp)
  a31c1c:	d632                	sw	a2,44(sp)
  a31c1e:	d836                	sw	a3,48(sp)
  a31c20:	da3a                	sw	a4,52(sp)
  a31c22:	dc3e                	sw	a5,56(sp)
  a31c24:	de42                	sw	a6,60(sp)
  a31c26:	c0c6                	sw	a7,64(sp)
  a31c28:	c2ca                	sw	s2,68(sp)
  a31c2a:	c4ce                	sw	s3,72(sp)
  a31c2c:	c6d2                	sw	s4,76(sp)
  a31c2e:	c8d6                	sw	s5,80(sp)
  a31c30:	cada                	sw	s6,84(sp)
  a31c32:	ccde                	sw	s7,88(sp)
  a31c34:	cee2                	sw	s8,92(sp)
  a31c36:	d0e6                	sw	s9,96(sp)
  a31c38:	d2ea                	sw	s10,100(sp)
  a31c3a:	d4ee                	sw	s11,104(sp)
  a31c3c:	d6f2                	sw	t3,108(sp)
  a31c3e:	d8f6                	sw	t4,112(sp)
  a31c40:	dafa                	sw	t5,116(sp)
  a31c42:	dcfe                	sw	t6,120(sp)
  a31c44:	341022f3          	csrr	t0,mepc
  a31c48:	de96                	sw	t0,124(sp)
  a31c4a:	34011073          	csrw	mscratch,sp
  a31c4e:	fffd3117          	auipc	sp,0xfffd3
  a31c52:	4b210113          	addi	sp,sp,1202 # a05100 <__irq_stack_top__>
  a31c56:	a66fb0ef          	jal	ra,a2cebc <interrupt5_handler>
  a31c5a:	34002173          	csrr	sp,mscratch
  a31c5e:	6289                	lui	t0,0x2
  a31c60:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a31c64:	3002a073          	csrs	mstatus,t0
  a31c68:	52f6                	lw	t0,124(sp)
  a31c6a:	34129073          	csrw	mepc,t0
  a31c6e:	4082                	lw	ra,0(sp)
  a31c70:	42c2                	lw	t0,16(sp)
  a31c72:	4352                	lw	t1,20(sp)
  a31c74:	43e2                	lw	t2,24(sp)
  a31c76:	4472                	lw	s0,28(sp)
  a31c78:	5482                	lw	s1,32(sp)
  a31c7a:	5512                	lw	a0,36(sp)
  a31c7c:	55a2                	lw	a1,40(sp)
  a31c7e:	5632                	lw	a2,44(sp)
  a31c80:	56c2                	lw	a3,48(sp)
  a31c82:	5752                	lw	a4,52(sp)
  a31c84:	57e2                	lw	a5,56(sp)
  a31c86:	5872                	lw	a6,60(sp)
  a31c88:	4886                	lw	a7,64(sp)
  a31c8a:	4916                	lw	s2,68(sp)
  a31c8c:	49a6                	lw	s3,72(sp)
  a31c8e:	4a36                	lw	s4,76(sp)
  a31c90:	4ac6                	lw	s5,80(sp)
  a31c92:	4b56                	lw	s6,84(sp)
  a31c94:	4be6                	lw	s7,88(sp)
  a31c96:	4c76                	lw	s8,92(sp)
  a31c98:	5c86                	lw	s9,96(sp)
  a31c9a:	5d16                	lw	s10,100(sp)
  a31c9c:	5da6                	lw	s11,104(sp)
  a31c9e:	5e36                	lw	t3,108(sp)
  a31ca0:	5ec6                	lw	t4,112(sp)
  a31ca2:	5f56                	lw	t5,116(sp)
  a31ca4:	5fe6                	lw	t6,120(sp)
  a31ca6:	6109                	addi	sp,sp,128
  a31ca8:	30200073          	mret

00a31cac <default_local_interrupt_handler>:
  a31cac:	30047073          	csrci	mstatus,8
  a31cb0:	7119                	addi	sp,sp,-128
  a31cb2:	c006                	sw	ra,0(sp)
  a31cb4:	c20a                	sw	sp,4(sp)
  a31cb6:	c40e                	sw	gp,8(sp)
  a31cb8:	c612                	sw	tp,12(sp)
  a31cba:	c816                	sw	t0,16(sp)
  a31cbc:	ca1a                	sw	t1,20(sp)
  a31cbe:	cc1e                	sw	t2,24(sp)
  a31cc0:	ce22                	sw	s0,28(sp)
  a31cc2:	d026                	sw	s1,32(sp)
  a31cc4:	d22a                	sw	a0,36(sp)
  a31cc6:	d42e                	sw	a1,40(sp)
  a31cc8:	d632                	sw	a2,44(sp)
  a31cca:	d836                	sw	a3,48(sp)
  a31ccc:	da3a                	sw	a4,52(sp)
  a31cce:	dc3e                	sw	a5,56(sp)
  a31cd0:	de42                	sw	a6,60(sp)
  a31cd2:	c0c6                	sw	a7,64(sp)
  a31cd4:	c2ca                	sw	s2,68(sp)
  a31cd6:	c4ce                	sw	s3,72(sp)
  a31cd8:	c6d2                	sw	s4,76(sp)
  a31cda:	c8d6                	sw	s5,80(sp)
  a31cdc:	cada                	sw	s6,84(sp)
  a31cde:	ccde                	sw	s7,88(sp)
  a31ce0:	cee2                	sw	s8,92(sp)
  a31ce2:	d0e6                	sw	s9,96(sp)
  a31ce4:	d2ea                	sw	s10,100(sp)
  a31ce6:	d4ee                	sw	s11,104(sp)
  a31ce8:	d6f2                	sw	t3,108(sp)
  a31cea:	d8f6                	sw	t4,112(sp)
  a31cec:	dafa                	sw	t5,116(sp)
  a31cee:	dcfe                	sw	t6,120(sp)
  a31cf0:	341022f3          	csrr	t0,mepc
  a31cf4:	de96                	sw	t0,124(sp)
  a31cf6:	34011073          	csrw	mscratch,sp
  a31cfa:	fffd3117          	auipc	sp,0xfffd3
  a31cfe:	40610113          	addi	sp,sp,1030 # a05100 <__irq_stack_top__>
  a31d02:	9fafb0ef          	jal	ra,a2cefc <local_interrupt_handler>
  a31d06:	34002173          	csrr	sp,mscratch
  a31d0a:	6289                	lui	t0,0x2
  a31d0c:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a31d10:	3002a073          	csrs	mstatus,t0
  a31d14:	52f6                	lw	t0,124(sp)
  a31d16:	34129073          	csrw	mepc,t0
  a31d1a:	4082                	lw	ra,0(sp)
  a31d1c:	42c2                	lw	t0,16(sp)
  a31d1e:	4352                	lw	t1,20(sp)
  a31d20:	43e2                	lw	t2,24(sp)
  a31d22:	4472                	lw	s0,28(sp)
  a31d24:	5482                	lw	s1,32(sp)
  a31d26:	5512                	lw	a0,36(sp)
  a31d28:	55a2                	lw	a1,40(sp)
  a31d2a:	5632                	lw	a2,44(sp)
  a31d2c:	56c2                	lw	a3,48(sp)
  a31d2e:	5752                	lw	a4,52(sp)
  a31d30:	57e2                	lw	a5,56(sp)
  a31d32:	5872                	lw	a6,60(sp)
  a31d34:	4886                	lw	a7,64(sp)
  a31d36:	4916                	lw	s2,68(sp)
  a31d38:	49a6                	lw	s3,72(sp)
  a31d3a:	4a36                	lw	s4,76(sp)
  a31d3c:	4ac6                	lw	s5,80(sp)
  a31d3e:	4b56                	lw	s6,84(sp)
  a31d40:	4be6                	lw	s7,88(sp)
  a31d42:	4c76                	lw	s8,92(sp)
  a31d44:	5c86                	lw	s9,96(sp)
  a31d46:	5d16                	lw	s10,100(sp)
  a31d48:	5da6                	lw	s11,104(sp)
  a31d4a:	5e36                	lw	t3,108(sp)
  a31d4c:	5ec6                	lw	t4,112(sp)
  a31d4e:	5f56                	lw	t5,116(sp)
  a31d50:	5fe6                	lw	t6,120(sp)
  a31d52:	6109                	addi	sp,sp,128
  a31d54:	30200073          	mret

00a31d58 <global_interrupt_lock>:
  a31d58:	30002573          	csrr	a0,mstatus
  a31d5c:	42a1                	li	t0,8
  a31d5e:	3002b073          	csrc	mstatus,t0
  a31d62:	8082                	ret

00a31d64 <global_interrupt_unlock>:
  a31d64:	30002573          	csrr	a0,mstatus
  a31d68:	42a1                	li	t0,8
  a31d6a:	3002a073          	csrs	mstatus,t0
  a31d6e:	8082                	ret

00a31d70 <global_interrupt_restore>:
  a31d70:	30051073          	csrw	mstatus,a0
  a31d74:	8082                	ret
  a31d76:	0000                	unimp
  a31d78:	ffff                	.2byte	0xffff
  a31d7a:	00ff                	.2byte	0xff
  a31d7c:	ffff                	.2byte	0xffff
  a31d7e:	00ff                	.2byte	0xff

00a31d80 <__clz_tab>:
  a31d80:	0100 0202 0303 0303 0404 0404 0404 0404     ................
  a31d90:	0505 0505 0505 0505 0505 0505 0505 0505     ................
  a31da0:	0606 0606 0606 0606 0606 0606 0606 0606     ................
  a31db0:	0606 0606 0606 0606 0606 0606 0606 0606     ................
  a31dc0:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a31dd0:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a31de0:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a31df0:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a31e00:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e10:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e20:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e30:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e40:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e50:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e60:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a31e70:	0808 0808 0808 0808 0808 0808 0808 0808     ................

00a31e80 <sfc_cfg>:
  a31e80:	0104 0000 0000 0020 0000 0080 6c46 7361     ...... .....Flas
  a31e90:	6268 6f6f 2074 6155 7472 4920 696e 2074     hboot Uart Init 
  a31ea0:	7553 6363 0021 0000 6c46 7361 6268 6f6f     Succ!...Flashboo
  a31eb0:	2074 614d 6c6c 636f 4920 696e 2074 7553     t Malloc Init Su
  a31ec0:	6363 0021 6c46 7361 2068 6e49 7469 4620     cc!.Flash Init F
  a31ed0:	6961 216c 7220 7465 3d20 0020 6c46 7361     ail! ret = .Flas
  a31ee0:	2068 6e49 7469 5320 6375 2163 0000 0000     h Init Succ!....
  a31ef0:	4653 2043 6966 2078 5253 7220 7465 3d20     SFC fix SR ret =
  a31f00:	0000 0000 7773 6d20 646f 2c65 6c20 7665     ....sw mode, lev
  a31f10:	6c65 735b 3a77 6863 7069 3a5d 0000 0000     el[sw:chip]:....
  a31f20:	7768 6d20 646f 2c65 6c20 7665 6c65 635b     hw mode, level[c
  a31f30:	6968 5d70 003a 0000 6175 6970 705f 7261     hip]:...uapi_par
  a31f40:	6974 6974 6e6f 675f 7465 695f 666e 206f     tition_get_info 
  a31f50:	6166 6c69 6465 0020 7075 5f67 6c66 7361     failed .upg_flas
  a31f60:	5f68 6572 6461 6620 6961 656c 2064 0000     h_read failed ..
  a31f70:	6f4e 6e20 6565 2064 6f74 7520 6770 6172     No need to upgra
  a31f80:	6564 2e2e 002e 0000 656e 6465 7520 6770     de......need upg
  a31f90:	6172 6564 0000 0000 2d2d 2d2d 2d2d 2d2d     rade....--------
  a31fa0:	2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d     ----------------
  a31fb0:	2d2d 0000 7075 7267 6461 2065 6166 6c69     --..upgrade fail
  a31fc0:	6465 202c 6572 6573 2074 6f6e 0077 0000     ed, reset now...
  a31fd0:	7075 7267 6461 2065 7573 6363 7365 2c73     upgrade success,
  a31fe0:	7220 7365 7465 6e20 776f 0000 6547 2074      reset now..Get 
  a31ff0:	7061 2070 6170 7472 7469 6f69 206e 6166     app partition fa
  a32000:	6c69 6465 0021 0000 6c66 7361 5f68 6e65     iled!...flash_en
  a32010:	7263 7079 2074 6964 6173 6c62 2e65 0000     crypt disable...
  a32020:	6441 7264 6e20 746f 3220 3635 7962 6574     Addr not 256byte
  a32030:	6120 696c 6e67 656d 746e 0020 6c66 7361      alignment .flas
  a32040:	5f68 6e65 7263 7079 2074 6e65 6261 656c     h_encrypt enable
  a32050:	002e 0000 6e45 7263 7079 2074 646f 6b72     ....Encrypt odrk
  a32060:	2031 7265 3d72 0000 6e45 7263 7079 2074     1 err=..Encrypt 
  a32070:	6166 6370 6520 7272 003d 0000 6e45 7263     fapc err=...Encr
  a32080:	7079 2074 7962 6170 7373 6520 7272 003d     ypt bypass err=.
  a32090:	6576 6972 7966 6120 7070 6820 6165 2064     verify app head 
  a320a0:	6166 6c69 6465 2021 6572 3d74 0000 0000     failed! ret=....
  a320b0:	6576 6972 7966 6120 7070 6220 646f 2079     verify app body 
  a320c0:	6166 6c69 6465 2121 7220 7465 003d 0000     failed!! ret=...
  a320d0:	6567 5f74 6b70 5f67 6568 6461 7265 6620     get_pkg_header f
  a320e0:	6961 2c6c 7220 7465 3d20 0020 7075 5f67     ail, ret = .upg_
  a320f0:	6576 6972 7966 6620 6961 2c6c 7220 7465     verify fail, ret
  a32100:	3d20 0020 6572 6573 2074 7075 7267 6461      = .reset upgrad
  a32110:	2065 6c66 6761 6620 6961 2c6c 7220 7465     e flag fail, ret
  a32120:	003d 0000 6572 7571 7365 2074 7075 7267     =...request upgr
  a32130:	6461 2065 6166 6c69 202c 6572 3d74 0000     ade fail, ret=..
  a32140:	7254 2079 6f66 6174 6620 7869 6120 7070     Try fota fix app
  a32150:	002e 0000 6c46 7361 6268 6f6f 2074 6162     ....Flashboot ba
  a32160:	6b63 7075 7720 726f 696b 676e 0021 0000     ckup working!...
  a32170:	6c46 7361 6268 6f6f 2074 6170 7472 7469     Flashboot partit
  a32180:	6f69 206e 6e69 6f66 6720 7465 6620 6961     ion info get fai
  a32190:	216c 0000 6552 6f63 6576 7972 6520 6172     l!..Recovery era
  a321a0:	6573 6620 6961 656c 2164 2021 6572 2074     se failed!! ret 
  a321b0:	203d 0000 6552 6f63 6576 7972 7720 6972     = ..Recovery wri
  a321c0:	6574 6620 6961 656c 2164 2021 6572 2074     te failed!! ret 
  a321d0:	203d 0000 6552 6f63 6576 7972 6f20 216b     = ..Recovery ok!
  a321e0:	0000 0000 4556 0000 6964 5f65 6469 6520     ....VE..die_id e
  a321f0:	7566 6573 725f 6165 5f64 7469 6d65 6620     fuse_read_item f
  a32200:	6961 216c 0000 0000 6964 2065 6469 6d20     ail!....die id m
  a32210:	6d65 6d63 2070 6166 6c69 0021 6d69 6761     emcmp fail!.imag
  a32220:	2065 6469 6520 7272 726f 0021 6576 7372     e id error!.vers
  a32230:	6f69 206e 6665 7375 5f65 6572 6461 695f     ion efuse_read_i
  a32240:	6574 206d 6166 6c69 0021 0000 736d 6469     tem fail!...msid
  a32250:	6320 6d6f 6170 6572 6620 6961 216c 0000      compare fail!..
  a32260:	6665 7375 5f65 6572 6461 695f 6574 206d     efuse_read_item 
  a32270:	6576 6972 7966 6520 616e 6c62 2065 6166     verify enable fa
  a32280:	6c69 0021 6576 7372 6f69 206e 6f63 706d     il!.version comp
  a32290:	7261 2065 6166 6c69 0021 0000               are fail!...

00a3229c <g_verify_table>:
  a3229c:	0000 0000 f01e 4bd2 0000 0000 0100 0000     .......K........
  a322ac:	f02d 4bd2 0000 0000 0002 0000 3c1e 4b1e     -..K.........<.K
  a322bc:	0003 0000 0102 0000 3c2d 4b1e 0003 0000     ........-<.K....
  a322cc:	0003 0000 871e 4b69 0003 0000 0103 0000     ......iK........
  a322dc:	872d 4b69 0003 0000 0004 0000 3c1e 4b1e     -.iK.........<.K
  a322ec:	0003 0000 0104 0000 3c2d 4b1e 0003 0000     ........-<.K....
  a322fc:	0005 0000 871e 4b69 0003 0000 0105 0000     ......iK........
  a3230c:	872d 4b69 0003 0000 0201 0000 a51e 4b87     -.iK...........K
  a3231c:	0004 0000 0301 0000 a52d 4b87 0004 0000     ........-..K....
  a3232c:	0006 0000 2d1e 4b0f 0002 0000 0106 0000     .....-.K........
  a3233c:	2d2d 4b0f 0002 0000 6573 7563 6572 615f     --.K....secure_a
  a3234c:	7475 6568 746e 6369 7461 2065 7264 5f76     uthenticate drv_
  a3235c:	6f72 5f6d 6963 6870 7265 735f 6168 3532     rom_cipher_sha25
  a3236c:	2036 6166 6c69 0021 6573 7563 6572 615f     6 fail!.secure_a
  a3237c:	7475 6568 746e 6369 7461 2065 7264 5f76     uthenticate drv_
  a3238c:	6f72 5f6d 6963 6870 7265 705f 656b 625f     rom_cipher_pke_b
  a3239c:	3270 3635 5f72 6576 6972 7966 6620 6961     p256r_verify fai
  a323ac:	216c 0000 6576 6972 7966 695f 616d 6567     l!..verify_image
  a323bc:	635f 646f 5f65 7261 6165 6420 7672 725f     _code_area drv_r
  a323cc:	6d6f 635f 7069 6568 5f72 6873 3261 3635     om_cipher_sha256
  a323dc:	0021 0000 6576 6972 7966 695f 616d 6567     !...verify_image
  a323ec:	635f 646f 5f65 7261 6165 6820 7361 2068     _code_area hash 
  a323fc:	656d 636d 706d 6620 6961 216c 0000 0000     memcmp fail!....
  a3240c:	6576 6972 7966 695f 616d 6567 635f 646f     verify_image_cod
  a3241c:	5f65 7261 6165 6620 6961 216c 0000 0000     e_area fail!....
  a3242c:	6576 6972 7966 695f 616d 6567 6b5f 7965     verify_image_key
  a3243c:	615f 6572 2061 6573 7563 6572 7620 7265     _area secure ver
  a3244c:	6669 2079 6964 6173 6c62 2165 0000 0000     ify disable!....
  a3245c:	6576 6972 7966 695f 616d 6567 6b5f 7965     verify_image_key
  a3246c:	615f 6572 2061 6573 7563 6572 7620 7265     _area secure ver
  a3247c:	6669 2079 7265 6f72 2172 0000 6576 6972     ify error!..veri
  a3248c:	7966 695f 616d 6567 6b5f 7965 615f 6572     fy_image_key_are
  a3249c:	2061 6f72 746f 656b 5f79 7473 7461 7375     a rootkey_status
  a324ac:	6920 766e 6c61 6469 0021 0000 6576 6972      invalid!...veri
  a324bc:	7966 695f 616d 6567 6b5f 7965 615f 6572     fy_image_key_are
  a324cc:	2061 6d69 6761 2065 6469 6520 7272 726f     a image id error
  a324dc:	0021 0000 6576 6972 7966 695f 616d 6567     !...verify_image
  a324ec:	6b5f 7965 615f 6572 2061 6573 7563 6572     _key_area secure
  a324fc:	615f 7475 6568 746e 6369 7461 2165 0000     _authenticate!..
  a3250c:	6576 6972 7966 695f 616d 6567 6b5f 7965     verify_image_key
  a3251c:	615f 6572 2061 656b 2079 6576 7372 6f69     _area key versio
  a3252c:	206e 7265 6f72 2172 0000 0000 6576 6972     n error!....veri
  a3253c:	7966 695f 616d 6567 6b5f 7965 615f 6572     fy_image_key_are
  a3254c:	2061 736d 6469 6520 7272 726f 0021 0000     a msid error!...
  a3255c:	6576 6972 7966 695f 616d 6567 6b5f 7965     verify_image_key
  a3256c:	615f 6572 2061 6964 2065 6469 6520 7272     _area die id err
  a3257c:	726f 0021 6576 6972 7966 695f 616d 6567     or!.verify_image
  a3258c:	6b5f 7965 615f 6572 2061 6166 6c69 0021     _key_area fail!.
  a3259c:	6576 6972 7966 695f 616d 6567 635f 646f     verify_image_cod
  a325ac:	5f65 6e69 6f66 7320 6365 7275 2065 6576     e_info secure ve
  a325bc:	6972 7966 6420 7369 6261 656c 0021 0000     rify disable!...
  a325cc:	6576 6972 7966 695f 616d 6567 635f 646f     verify_image_cod
  a325dc:	5f65 6e69 6f66 7320 6365 7275 2065 6576     e_info secure ve
  a325ec:	6972 7966 6520 7272 726f 0021 6576 6972     rify error!.veri
  a325fc:	7966 695f 616d 6567 635f 646f 5f65 6e69     fy_image_code_in
  a3260c:	6f66 6920 616d 6567 6920 2064 7265 6f72     fo image id erro
  a3261c:	2172 0000 6576 6972 7966 695f 616d 6567     r!..verify_image
  a3262c:	635f 646f 5f65 6e69 6f66 7320 6365 7275     _code_info secur
  a3263c:	5f65 7561 6874 6e65 6974 6163 6574 0021     e_authenticate!.
  a3264c:	6576 6972 7966 695f 616d 6567 635f 646f     verify_image_cod
  a3265c:	5f65 6e69 6f66 6b20 7965 7620 7265 6973     e_info key versi
  a3266c:	6e6f 6520 7272 726f 0021 0000 6576 6972     on error!...veri
  a3267c:	7966 695f 616d 6567 635f 646f 5f65 6e69     fy_image_code_in
  a3268c:	6f66 6d20 6973 2064 7265 6f72 2172 0000     fo msid error!..
  a3269c:	6576 6972 7966 695f 616d 6567 635f 646f     verify_image_cod
  a326ac:	5f65 6e69 6f66 6620 6961 216c 0000 0000     e_info fail!....

00a326bc <g_sha256_ival>:
  a326bc:	096a 67e6 67bb 85ae 6e3c 72f3 4fa5 3af5     j..g.g..<n.r.O.:
  a326cc:	0e51 7f52 059b 8c68 831f abd9 e05b 19cd     Q.R...h.....[...

00a326dc <g_sm3_ival>:
  a326dc:	8073 6f16 1449 b9b2 2417 d742 8ada 0006     s..oI....$B.....
  a326ec:	6fa9 bc30 3116 aa38 8de3 4dee fbb0 4e0e     .o0..18....M...N
  a326fc:	a5a4 00a2 a562 00a2 a632 00a2 a6c4 00a2     ....b...2.......
  a3270c:	a6de 00a2 b8fa 00a2 b8e4 00a2 b8dc 00a2     ................
  a3271c:	b8e4 00a2 b8e8 00a2 b8e4 00a2 b8f2 00a2     ................
  a3272c:	b8e4 00a2 b8e4 00a2 b8e4 00a2 b8e4 00a2     ................
  a3273c:	b8e4 00a2 b8e8 00a2 b8f2 00a2               ............

00a32748 <CSWTCH.8>:
  a32748:	1001 0020                                   .. .

00a3274c <g_hal_uart_ctrl_func_array>:
  a3274c:	b998 00a2 0000 0000 b92e 00a2 b920 00a2     ............ ...
  a3275c:	b912 00a2 b904 00a2 b904 00a2 b6d6 00a2     ................
  a3276c:	b6ec 00a2 b722 00a2 0000 0000 b800 00a2     ...."...........
  a3277c:	b7e0 00a2 0000 0000 0000 0000 0000 0000     ................
  a3278c:	0000 0000 b704 00a2 b678 00a2 b68a 00a2     ........x.......
  a3279c:	0000 0000                                   ....

00a327a0 <g_uart_base_addrs>:
  a327a0:	0000 4401 1000 4401 2000 4401               ...D...D. .D

00a327ac <g_default_erase_cmds>:
  a327ac:	c639 ffff 06c1 4000 0101 0400               9......@....

00a327b8 <g_default_quad_enable>:
  a327b8:	0002 0000 0000 0000                         ........

00a327c0 <g_default_read_cmds>:
  a327c0:	0019 0000                                   ....

00a327c4 <g_default_write_cmds>:
  a327c4:	0001 0000 0011 0000                         ........

00a327cc <g_flash_common_erase_cmds>:
  a327cc:	c639 ffff 06c1 4000 0291 2000 0101 0400     9......@... ....

00a327dc <g_flash_common_read_cmds>:
  a327dc:	0019 0000 4059 0000 49d9 0000 55d9 0000     ....Y@...I...U..
  a327ec:	6b59 0000 f759 0000                         Yk..Y...

00a327f4 <g_flash_common_write_cmds>:
  a327f4:	0001 0000 0011 0000 4000 0000 4000 0000     .........@...@..
  a32804:	2991 0000 4000 0000                         .)...@..

00a3280c <g_flash_gd_bus_enable>:
  a3280c:	0301 0005 0000 0301 0135 0001 0002 0000     ........5.......
  a3281c:	0000 0000                                   ....

00a32820 <g_flash_spi_info_list>:
  a32820:	40c8 0016 0000 0040 0004 0000 27dc 00a3     .@....@......'..
  a32830:	27f4 00a3 27cc 00a3 280c 00a3               .'...'...(..

00a3283c <g_flash_spi_unknown_info>:
  a3283c:	ffff 00ff 0000 0008 0003 0000 27c0 00a3     .............'..
  a3284c:	27c4 00a3 27ac 00a3 27b8 00a3 6f4e 6e20     .'...'...'..No n
  a3285c:	6565 2064 6f74 6620 7869 5320 2152 0a0d     eed to fix SR!..
  a3286c:	0000 0000 5253 6620 7869 6f20 216b 0a0d     ....SR fix ok!..
  a3287c:	0000 0000 5253 6425 305b 2578 5d78 6e20     ....SR%d[0x%x] n
  a3288c:	6565 7364 6620 7869 6e69 2c67 6520 7078     eeds fixing, exp
  a3289c:	6365 5b74 7830 7825 0d5d 000a               ect[0x%x]...

00a328a8 <g_efuse_cfg>:
  a328a8:	0000 0008 0003 0008 00a0 0003 0270 0020     ............p. .
  a328b8:	0003 0290 0008 0003 0298 0008 0003 02a0     ................
  a328c8:	0100 0003 03a0 0020 0003 03c0 0001 0003     ...... .........
  a328d8:	03e8 0008 0003 0630 0030 0003 0660 0030     ......0.0...`.0.
  a328e8:	0003 0690 0030 0003 06c0 0030 0003 06f0     ....0.....0.....
  a328f8:	0080 0003 02a0 0100 0003 046f 0001 0003     ..........o.....
  a32908:	0460 000f 0003 0470 0010 0003 0770 0030     `.....p.....p.0.
  a32918:	0003 0000 0020 0000 7830 0000 7075 6164     .... ...0x..upda
  a32928:	6574 725f 7365 7465 635f 756f 746e 0020     te_reset_count .
  a32938:	4f52 7c4d 6564 6166 6c75 5f74 6168 646e     ROM|default_hand
  a32948:	656c 2072 203a 6e69 6574 7272 7075 2074     ler : interrupt 
  a32958:	6469 5b78 6425 0a5d 0000 0000 4f52 7c4d     idx[%d].....ROM|
  a32968:	6f4f 7370 2d20 6820 7261 2064 6166 6c75     Oops - hard faul
  a32978:	0d74 000a 4f52 7c4d 7865 6563 7470 6f69     t...ROM|exceptio
  a32988:	3a6e 7825 0a0d 0000 4f52 7c4d 6f4f 7370     n:%x....ROM|Oops
  a32998:	4e3a 494d 000a 0000 4f52 7c4d 6f4f 7370     :NMI....ROM|Oops
  a329a8:	2d20 6920 736e 206e 6170 6567 6620 7561      - insn page fau
  a329b8:	746c 0a0d 0000 0000 4f52 7c4d 6f4f 7370     lt......ROM|Oops
  a329c8:	2d20 6c20 616f 2064 6170 6567 6620 7561      - load page fau
  a329d8:	746c 0a0d 0000 0000 4f52 7c4d 6f4f 7370     lt......ROM|Oops
  a329e8:	2d20 6c20 636f 206b 7075 0a0d 0000 0000      - lock up......
  a329f8:	4f52 7c4d 6f4f 7370 2d20 7320 6f74 6572     ROM|Oops - store
  a32a08:	7020 6761 2065 6166 6c75 0d74 000a 0000      page fault.....
  a32a18:	4f52 7c4d 6f4f 7370 2d20 6520 7262 6165     ROM|Oops - ebrea
  a32a28:	0d6b 000a 4f52 7c4d 6f4f 7370 2d20 6520     k...ROM|Oops - e
  a32a38:	766e 7269 6e6f 656d 746e 6320 6c61 206c     nvironment call 
  a32a48:	7266 6d6f 4d20 6d2d 646f 0d65 000a 0000     from M-mode.....
  a32a58:	4f52 7c4d 6f4f 7370 2d20 6520 766e 7269     ROM|Oops - envir
  a32a68:	6e6f 656d 746e 6320 6c61 206c 7266 6d6f     onment call from
  a32a78:	5320 6d2d 646f 0d65 000a 0000 4f52 7c4d      S-mode.....ROM|
  a32a88:	6f4f 7370 2d20 6520 766e 7269 6e6f 656d     Oops - environme
  a32a98:	746e 6320 6c61 206c 7266 6d6f 5520 6d2d     nt call from U-m
  a32aa8:	646f 0d65 000a 0000 4f52 7c4d 6f4f 7370     ode.....ROM|Oops
  a32ab8:	2d20 6920 736e 7274 6375 6974 6e6f 6120      - instruction a
  a32ac8:	6363 7365 2073 6166 6c75 0d74 000a 0000     ccess fault.....
  a32ad8:	4f52 7c4d 6f4f 7370 2d20 6920 6c6c 6765     ROM|Oops - illeg
  a32ae8:	6c61 6920 736e 7274 6375 6974 6e6f 0a0d     al instruction..
  a32af8:	0000 0000 4f52 7c4d 6f4f 7370 2d20 6920     ....ROM|Oops - i
  a32b08:	736e 7274 6375 6974 6e6f 6120 6464 6572     nstruction addre
  a32b18:	7373 6d20 7369 6c61 6769 656e 0d64 000a     ss misaligned...
  a32b28:	4f52 7c4d 6f4f 7370 2d20 6c20 616f 2064     ROM|Oops - load 
  a32b38:	6361 6563 7373 6620 7561 746c 0a0d 0000     access fault....
  a32b48:	4f52 7c4d 6f4f 7370 2d20 6c20 616f 2064     ROM|Oops - load 
  a32b58:	6461 7264 7365 2073 696d 6173 696c 6e67     address misalign
  a32b68:	6465 0a0d 0000 0000 4f52 7c4d 6f4f 7370     ed......ROM|Oops
  a32b78:	2d20 7320 6f74 6572 2820 726f 4120 4f4d      - store (or AMO
  a32b88:	2029 6361 6563 7373 6620 7561 746c 0a0d     ) access fault..
  a32b98:	0000 0000 4f52 7c4d 6f4f 7370 2d20 7320     ....ROM|Oops - s
  a32ba8:	6f74 6572 2820 726f 4120 4f4d 2029 6461     tore (or AMO) ad
  a32bb8:	7264 7365 2073 696d 6173 696c 6e67 6465     dress misaligned
  a32bc8:	0a0d 0000 4f52 7c4d 6f4f 7370 2d20 7520     ....ROM|Oops - u
  a32bd8:	6b6e 6f6e 6e77 6520 6378 7065 6974 6e6f     nknown exception
  a32be8:	0a0d 0000 4f52 7c4d 2a2a 2a2a 2a2a 2a2a     ....ROM|********
  a32bf8:	2a2a 2a2a 2a2a 7845 6563 7470 6f69 206e     ******Exception 
  a32c08:	6e49 6f66 6d72 7461 6f69 2a6e 2a2a 2a2a     Information*****
  a32c18:	2a2a 2a2a 2a2a 2a2a 202a 000a 4f52 7c4d     ********* ..ROM|
  a32c28:	7775 7845 5463 7079 2065 203d 7830 7825     uwExcType = 0x%x
  a32c38:	000a 0000 4f52 7c4d 656d 6370 2020 2020     ....ROM|mepc    
  a32c48:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32c58:	736d 6174 7574 2073 2020 3d20 3020 2578     mstatus    = 0x%
  a32c68:	0a78 0000 4f52 7c4d 746d 6176 206c 2020     x...ROM|mtval   
  a32c78:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32c88:	636d 7561 6573 2020 2020 3d20 3020 2578     mcause     = 0x%
  a32c98:	0a78 0000 4f52 7c4d 6363 7561 6573 2020     x...ROM|ccause  
  a32ca8:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32cb8:	6172 2020 2020 2020 2020 3d20 3020 2578     ra         = 0x%
  a32cc8:	0a78 0000 4f52 7c4d 7073 2020 2020 2020     x...ROM|sp      
  a32cd8:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32ce8:	7067 2020 2020 2020 2020 3d20 3020 2578     gp         = 0x%
  a32cf8:	0a78 0000 4f52 7c4d 7074 2020 2020 2020     x...ROM|tp      
  a32d08:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32d18:	3074 2020 2020 2020 2020 3d20 3020 2578     t0         = 0x%
  a32d28:	0a78 0000 4f52 7c4d 3174 2020 2020 2020     x...ROM|t1      
  a32d38:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32d48:	3274 2020 2020 2020 2020 3d20 3020 2578     t2         = 0x%
  a32d58:	0a78 0000 4f52 7c4d 3073 2020 2020 2020     x...ROM|s0      
  a32d68:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32d78:	3173 2020 2020 2020 2020 3d20 3020 2578     s1         = 0x%
  a32d88:	0a78 0000 4f52 7c4d 3061 2020 2020 2020     x...ROM|a0      
  a32d98:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32da8:	3161 2020 2020 2020 2020 3d20 3020 2578     a1         = 0x%
  a32db8:	0a78 0000 4f52 7c4d 3261 2020 2020 2020     x...ROM|a2      
  a32dc8:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32dd8:	3361 2020 2020 2020 2020 3d20 3020 2578     a3         = 0x%
  a32de8:	0a78 0000 4f52 7c4d 3461 2020 2020 2020     x...ROM|a4      
  a32df8:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32e08:	3561 2020 2020 2020 2020 3d20 3020 2578     a5         = 0x%
  a32e18:	0a78 0000 4f52 7c4d 3661 2020 2020 2020     x...ROM|a6      
  a32e28:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32e38:	3761 2020 2020 2020 2020 3d20 3020 2578     a7         = 0x%
  a32e48:	0a78 0000 4f52 7c4d 3273 2020 2020 2020     x...ROM|s2      
  a32e58:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32e68:	3373 2020 2020 2020 2020 3d20 3020 2578     s3         = 0x%
  a32e78:	0a78 0000 4f52 7c4d 3473 2020 2020 2020     x...ROM|s4      
  a32e88:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32e98:	3573 2020 2020 2020 2020 3d20 3020 2578     s5         = 0x%
  a32ea8:	0a78 0000 4f52 7c4d 3673 2020 2020 2020     x...ROM|s6      
  a32eb8:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32ec8:	3773 2020 2020 2020 2020 3d20 3020 2578     s7         = 0x%
  a32ed8:	0a78 0000 4f52 7c4d 3873 2020 2020 2020     x...ROM|s8      
  a32ee8:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32ef8:	3973 2020 2020 2020 2020 3d20 3020 2578     s9         = 0x%
  a32f08:	0a78 0000 4f52 7c4d 3173 2030 2020 2020     x...ROM|s10     
  a32f18:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32f28:	3173 2031 2020 2020 2020 3d20 3020 2578     s11        = 0x%
  a32f38:	0a78 0000 4f52 7c4d 3374 2020 2020 2020     x...ROM|t3      
  a32f48:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32f58:	3474 2020 2020 2020 2020 3d20 3020 2578     t4         = 0x%
  a32f68:	0a78 0000 4f52 7c4d 3574 2020 2020 2020     x...ROM|t5      
  a32f78:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a32f88:	3674 2020 2020 2020 2020 3d20 3020 2578     t6         = 0x%
  a32f98:	0a78 0000 4f52 7c4d 2a2a 2a2a 2a2a 2a2a     x...ROM|********
  a32fa8:	2a2a 2a2a 2a2a 7845 6563 7470 6f69 206e     ******Exception 
  a32fb8:	6e49 6f66 6d72 7461 6f69 206e 6e65 2a64     Information end*
  a32fc8:	2a2a 2a2a 2a2a 2a2a 2a2a 2a2a 202a 000a     ************* ..
  a32fd8:	4f52 7c4d 6d6e 5f69 6168 646e 656c 2072     ROM|nmi_handler 
  a32fe8:	203a 6e69 6574 7272 7075 2074 6469 5b78     : interrupt idx[
  a32ff8:	6425 0a5d 0000 0000 555b 4750 205d 6567     %d].....[UPG] ge
  a33008:	2074 736d 6469 6620 6961 2c6c 6572 3d74     t msid fail,ret=
  a33018:	7830 7825 0a0d 0000 555b 4750 205d 736d     0x%x....[UPG] ms
  a33028:	6469 7720 6f72 676e 0d21 000a 555b 4750     id wrong!...[UPG
  a33038:	205d 7270 676f 6572 7373 6320 6c61 626c     ] progress callb
  a33048:	6361 206b 6572 6967 7473 6620 6961 656c     ack regist faile
  a33058:	0d64 000a 555b 4750 205d 7075 2067 6570     d...[UPG] upg pe
  a33068:	6372 6e65 2074 203a 0000 0000 0031 0000     rcent : ....1...
  a33078:	2520 000d 555b 4750 205d 6e69 7469 6620      %..[UPG] init f
  a33088:	6961 656c 2164 0a0d 0000 0000 555b 4750     ailed!......[UPG
  a33098:	205d 6e69 7469 4f20 214b 0000 555b 4750     ] init OK!..[UPG
  a330a8:	205d 7075 5f67 6e69 7469 635f 7972 6f74     ] upg_init_cryto
  a330b8:	635f 6766 6d20 6d65 7063 5f79 2073 6e65     _cfg memcpy_s en
  a330c8:	7263 2079 6173 746c 6620 6961 2e6c 0d20     cry salt fail. .
  a330d8:	000a 0000 555b 4750 205d 7075 5f67 6e69     ....[UPG] upg_in
  a330e8:	7469 635f 7972 6f74 635f 6766 6d20 6d65     it_cryto_cfg mem
  a330f8:	7063 5f79 2073 6564 7263 2079 6173 746c     cpy_s decry salt
  a33108:	6620 6961 2e6c 0d20 000a 0000 555b 4750      fail. .....[UPG
  a33118:	205d 7075 5f67 6e69 7469 635f 7972 6f74     ] upg_init_cryto
  a33128:	635f 6766 6d20 6d65 7063 5f79 2073 6e65     _cfg memcpy_s en
  a33138:	7263 2079 7669 6620 6961 2e6c 0d20 000a     cry iv fail. ...
  a33148:	555b 4750 205d 7075 5f67 6e69 7469 635f     [UPG] upg_init_c
  a33158:	7972 6f74 635f 6766 6d20 6d65 7063 5f79     ryto_cfg memcpy_
  a33168:	2073 6564 7263 2079 7669 6620 6961 2e6c     s decry iv fail.
  a33178:	0d20 000a 555b 4750 205d 7264 5f76 6f72      ...[UPG] drv_ro
  a33188:	5f6d 6963 6870 7265 735f 6d79 5f63 6e69     m_cipher_symc_in
  a33198:	7469 6620 6961 2c6c 7220 7465 3d20 3020     it fail, ret = 0
  a331a8:	2578 2e78 0d20 000a 555b 4750 205d 7264     x%x. ...[UPG] dr
  a331b8:	5f76 6f72 5f6d 6963 6870 7265 635f 6572     v_rom_cipher_cre
  a331c8:	7461 5f65 656b 7379 6f6c 2074 6e65 7263     ate_keyslot encr
  a331d8:	2079 6166 6c69 6465 202c 6572 2074 203d     y failed, ret = 
  a331e8:	7830 7825 202e 0a0d 0000 0000 555b 4750     0x%x. ......[UPG
  a331f8:	205d 7264 5f76 6f72 5f6d 6963 6870 7265     ] drv_rom_cipher
  a33208:	635f 6572 7461 5f65 656b 7379 6f6c 2074     _create_keyslot 
  a33218:	6564 7263 2079 6166 6c69 6465 202c 6572     decry failed, re
  a33228:	2074 203d 7830 7825 202e 0a0d 0000 0000     t = 0x%x. ......
  a33238:	555b 4750 205d 7075 5f67 6564 7263 5f79     [UPG] upg_decry_
  a33248:	6f66 6174 705f 746b 643a 7672 725f 6d6f     fota_pkt:drv_rom
  a33258:	635f 7069 6568 5f72 7973 636d 645f 6365     _cipher_symc_dec
  a33268:	7972 7470 6620 6961 656c 2c64 7220 7465     rypt failed, ret
  a33278:	3d20 3020 2578 2078 0a0d 0000 555b 4750      = 0x%x ....[UPG
  a33288:	205d 7075 5f67 6e65 7263 5f79 6f66 6174     ] upg_encry_fota
  a33298:	705f 746b 643a 7672 725f 6d6f 635f 7069     _pkt:drv_rom_cip
  a332a8:	6568 5f72 7973 636d 645f 6365 7972 7470     her_symc_decrypt
  a332b8:	6620 6961 656c 2c64 7220 7465 3d20 3020      failed, ret = 0
  a332c8:	2578 2078 0a0d 0000 4f52 7c4d 705b 6e61     x%x ....ROM|[pan
  a332d8:	6369 695d 3a64 6425 632c 646f 3a65 7830     ic]id:%d,code:0x
  a332e8:	7825 632c 6c61 3a6c 7830 7825 0000 0000     %x,call:0x%x....
  a332f8:	555b 4750 205d 7075 5f67 6567 5f74 7075     [UPG] upg_get_up
  a33308:	7267 6461 5f65 6c66 6761 665f 616c 6873     grade_flag_flash
  a33318:	735f 6174 7472 615f 6464 2072 6166 6c69     _start_addr fail
  a33328:	0a0d 0000 555b 4750 205d 7075 5f67 6c61     ....[UPG] upg_al
  a33338:	6f6c 5f63 6e61 5f64 6567 5f74 7075 7267     loc_and_get_upgr
  a33348:	6461 5f65 6c66 6761 7520 6770 6d5f 6c61     ade_flag upg_mal
  a33358:	6f6c 2063 6166 6c69 0a0d 0000 555b 4750     loc fail....[UPG
  a33368:	205d 7075 5f67 6c61 6f6c 5f63 6e61 5f64     ] upg_alloc_and_
  a33378:	6567 5f74 7075 7267 6461 5f65 6c66 6761     get_upgrade_flag
  a33388:	7220 6165 2064 6c66 7361 2068 6166 6c69      read flash fail
  a33398:	0a0d 0000 555b 4750 205d 7075 5f67 6c66     ....[UPG] upg_fl
  a333a8:	7361 5f68 6572 6461 6620 616c 2067 6166     ash_read flag fa
  a333b8:	6c69 0a0d 0000 0000 555b 4750 205d 7277     il......[UPG] wr
  a333c8:	7469 2065 6f63 706d 656c 6574 203a 7830     ite complete: 0x
  a333d8:	7825 0a0d 0000 0000 555b 4750 205d 7075     %x......[UPG] up
  a333e8:	5f67 6c66 7361 5f68 7277 7469 2065 7075     g_flash_write up
  a333f8:	7267 6461 7265 6620 616c 2067 6166 6c69     grader flag fail
  a33408:	202e 6572 2074 203d 7830 7825 0a0d 0000     . ret = 0x%x....
  a33418:	555b 4750 205d 6572 7274 2079 6974 656d     [UPG] retry time
  a33428:	2073 6c61 206c 6166 6c69 6465 0a0d 0000     s all failed....
  a33438:	555b 4750 205d 6168 6873 6f5f 6570 6172     [UPG] hash_opera
  a33448:	6974 6e6f 203a 7264 5f76 6f72 5f6d 6963     tion: drv_rom_ci
  a33458:	6870 7265 685f 7361 2068 6166 6c69 7220     pher_hash fail r
  a33468:	7465 765f 6c61 3d20 3020 2578 0d78 000a     et_val = 0x%x...
  a33478:	555b 4750 205d 6163 636c 685f 7361 2068     [UPG] calc_hash 
  a33488:	6166 6c69 7220 7465 3d20 3020 2578 0d78     fail ret = 0x%x.
  a33498:	000a 0000 555b 4750 205d 6576 6972 7966     ....[UPG] verify
  a334a8:	735f 6769 616e 7574 6572 6920 2073 6166     _signature is fa
  a334b8:	6c69 202c 6572 2074 203d 7830 7825 0a0d     il, ret = 0x%x..
  a334c8:	0000 0000 555b 4750 205d 7075 2067 6576     ....[UPG] upg ve
  a334d8:	6972 7966 6820 6165 2064 4b4f 0a0d 0000     rify head OK....
  a334e8:	555b 4750 205d 7075 5f67 6567 5f74 6b70     [UPG] upg_get_pk
  a334f8:	5f67 6d69 6761 5f65 6168 6873 745f 6261     g_image_hash_tab
  a33508:	656c 6620 6961 0d6c 000a 0000 555b 4750     le fail.....[UPG
  a33518:	205d 7075 5f67 6576 6972 7966 685f 7361     ] upg_verify_has
  a33528:	2068 6d69 6761 2065 6174 6c62 2065 4b4f     h image table OK
  a33538:	0a0d 0000 555b 4750 205d 7075 5f67 6567     ....[UPG] upg_ge
  a33548:	5f74 6b70 5f67 6d69 6761 5f65 6568 6461     t_pkg_image_head
  a33558:	7265 6620 6961 0d6c 000a 0000 555b 4750     er fail.....[UPG
  a33568:	205d 7075 2067 6576 6972 7966 203a 6d69     ] upg verify: im
  a33578:	6761 2065 4449 6520 7272 726f 0a0d 0000     age ID error....
  a33588:	555b 4750 205d 6576 6972 7966 665f 746f     [UPG] verify_fot
  a33598:	5f61 656b 5f79 7261 6165 2d20 203e 6576     a_key_area -> ve
  a335a8:	6972 7966 5320 4148 3532 0d36 000a 0000     rify SHA256.....
  a335b8:	555b 4750 205d 7075 2067 6576 6972 7966     [UPG] upg verify
  a335c8:	203a 656b 2079 7261 6165 6520 7272 726f     : key area error
  a335d8:	202e 6572 2074 203d 7830 7825 0a0d 0000     . ret = 0x%x....
  a335e8:	555b 4750 205d 7075 2067 6576 6972 7966     [UPG] upg verify
  a335f8:	203a 6f66 6174 6920 666e 206f 7265 6f72     : fota info erro
  a33608:	2e72 7220 7465 3d20 3020 2578 0d78 000a     r. ret = 0x%x...
  a33618:	555b 4750 205d 7075 2067 6576 6972 7966     [UPG] upg verify
  a33628:	203a 7075 5f67 6863 6365 5f6b 6f66 6174     : upg_check_fota
  a33638:	695f 666e 726f 616d 6974 6e6f 202e 6572     _information. re
  a33648:	2074 203d 7830 7825 0a0d 0000 555b 4750     t = 0x%x....[UPG
  a33658:	205d 7075 2067 6576 6972 7966 203a 6966     ] upg verify: fi
  a33668:	656c 6920 616d 6567 6320 6568 6b63 6520     le image check e
  a33678:	7272 726f 202e 6568 6461 7265 6d5f 6761     rror. header_mag
  a33688:	6369 3d20 3020 2578 0d78 000a 555b 4750     ic = 0x%x...[UPG
  a33698:	205d 7075 2067 6576 6972 7966 203a 6d69     ] upg verify: im
  a336a8:	6761 2065 6863 6365 206b 4b4f 202e 6d69     age check OK. im
  a336b8:	6761 5f65 6469 3d20 3020 2578 0d78 000a     age_id = 0x%x...
  a336c8:	555b 4750 205d 7075 5f67 6576 6972 7966     [UPG] upg_verify
  a336d8:	685f 7361 3a68 6820 7361 5f68 706f 7265     _hash: hash_oper
  a336e8:	7461 6f69 206e 6166 6c69 7220 7465 765f     ation fail ret_v
  a336f8:	6c61 3d20 3020 2578 0d78 000a 555b 4750     al = 0x%x...[UPG
  a33708:	205d 6576 6972 7966 665f 746f 5f61 6e69     ] verify_fota_in
  a33718:	6f66 2d20 203e 6576 6972 7966 5320 4148     fo -> verify SHA
  a33728:	3532 0d36 000a 0000 555b 4750 205d 6576     256.....[UPG] ve
  a33738:	6972 7966 665f 746f 5f61 6e69 6f66 2d20     rify_fota_info -
  a33748:	203e 6576 6972 7966 7320 6769 656e 0d64     > verify signed.
  a33758:	000a 0000 555b 4750 205d 7075 5f67 6576     ....[UPG] upg_ve
  a33768:	6972 7966 685f 7361 3a68 6d20 6d65 6d63     rify_hash: memcm
  a33778:	2070 6168 6873 6620 6961 2e6c 0a0d 0000     p hash fail.....
  a33788:	555b 4750 205d 7075 5f67 6567 5f74 6170     [UPG] upg_get_pa
  a33798:	6b63 6761 5f65 6568 6461 7265 6620 6961     ckage_header fai
  a337a8:	0d6c 000a 555b 4750 205d 6175 6970 755f     l...[UPG] uapi_u
  a337b8:	6770 765f 7265 6669 5f79 6966 656c 6620     pg_verify_file f
  a337c8:	6961 2c6c 7220 7465 3d20 3020 2578 0d78     ail, ret = 0x%x.
  a337d8:	000a 0000 555b 4750 205d 7075 5f67 6567     ....[UPG] upg_ge
  a337e8:	5f74 6966 6d72 6177 6572 6e5f 6d75 6562     t_firmware_numbe
  a337f8:	5f72 6e69 705f 6361 616b 6567 6620 6961     r_in_package fai
  a33808:	2c6c 7220 7465 3d20 3020 2578 0d78 000a     l, ret = 0x%x...
  a33818:	555b 4750 205d 7075 5f67 7075 7267 6461     [UPG] upg_upgrad
  a33828:	5f65 6572 7571 7365 2074 6166 6c69 202e     e_request fail. 
  a33838:	6572 2074 203d 7830 7825 0a0d 0000 0000     ret = 0x%x......
  a33848:	555b 4750 205d 7075 5f67 6e65 7263 5f79     [UPG] upg_encry_
  a33858:	6f66 6174 705f 746b 6d3a 6d65 6f6d 6576     fota_pkt:memmove
  a33868:	735f 6620 6961 656c 2e64 0a0d 0000 0000     _s failed.......
  a33878:	555b 4750 205d 7075 5f67 7a6c 616d 615f     [UPG] upg_lzma_a
  a33888:	6c6c 636f 6620 6961 656c 2164 2121 7320     lloc failed!!! s
  a33898:	7a69 2065 203d 7830 7825 0a0d 0000 0000     ize = 0x%x......
  a338a8:	555b 4750 205d 7075 5f67 7a6c 616d 725f     [UPG] upg_lzma_r
  a338b8:	6165 5f64 6b70 5f74 6564 7263 2079 6166     ead_pkt_decry fa
  a338c8:	6c69 7220 7465 3d20 3020 2578 2e78 0a0d     il ret = 0x%x...
  a338d8:	0000 0000 555b 4750 205d 7075 5f67 7a6c     ....[UPG] upg_lz
  a338e8:	616d 645f 6365 646f 5f65 6f74 625f 6675     ma_decode_to_buf
  a338f8:	6620 6961 206c 6572 2074 203d 7830 7825      fail ret = 0x%x
  a33908:	0d2e 000a 555b 4750 205d 7a6c 616d 6564     ....[UPG] lzmade
  a33918:	5f63 6564 6f63 6564 6f74 7562 2066 6166     c_decodetobuf fa
  a33928:	6c69 7220 7465 3d20 3020 2578 2e78 0d20     il ret = 0x%x. .
  a33938:	000a 0000 555b 4750 205d 7075 5f67 7a6c     ....[UPG] upg_lz
  a33948:	616d 775f 6972 6574 695f 616d 6567 6620     ma_write_image f
  a33958:	6961 2e6c 0a0d 0000 555b 4750 205d 7075     ail.....[UPG] up
  a33968:	5f67 6e65 7263 5f79 6f66 6174 705f 746b     g_encry_fota_pkt
  a33978:	6620 6961 206c 6572 2074 203d 7830 7825      fail ret = 0x%x
  a33988:	0d20 000a 3044 8000 555b 4750 205d 6f4e      ...D0..[UPG] No
  a33998:	2074 656e 6465 7420 206f 7075 7267 6461     t need to upgrad
  a339a8:	2e65 2e2e 0a0d 0000 555b 4750 205d 6170     e.......[UPG] pa
  a339b8:	6b63 6761 2065 6e69 6f66 7420 746f 6c61     ckage info total
  a339c8:	203d 7830 7825 202c 6966 696e 6873 6465     = 0x%x, finished
  a339d8:	3d20 3020 2578 0d78 000a 0000 555b 4750      = 0x%x.....[UPG
  a339e8:	205d 7075 6164 6574 6920 616d 6567 6e20     ] update image n
  a339f8:	6d75 6562 2072 203d 7830 7825 0a0d 0000     umber = 0x%x....
  a33a08:	555b 4750 205d 7075 6164 6574 6620 7269     [UPG] update fir
  a33a18:	776d 7261 2065 756e 626d 7265 3d20 3020     mware number = 0
  a33a28:	2578 0d78 000a 0000 555b 4750 205d 6854     x%x.....[UPG] Th
  a33a38:	2065 6d69 6761 2065 6168 2073 6966 696e     e image has fini
  a33a48:	6873 6465 202e 6d69 6761 5f65 6469 3d20     shed. image_id =
  a33a58:	3020 2578 0d78 000a 555b 4750 205d 7075      0x%x...[UPG] up
  a33a68:	5f67 6567 5f74 6b70 5f67 6d69 6761 5f65     g_get_pkg_image_
  a33a78:	6568 6461 7265 6620 6961 2e6c 0a0d 0000     header fail.....
  a33a88:	555b 4750 205d 7075 5f67 6573 5f74 6966     [UPG] upg_set_fi
  a33a98:	6d72 6177 6572 755f 6470 7461 5f65 7473     rmware_update_st
  a33aa8:	7461 7375 6620 6961 0d6c 000a 555b 4750     atus fail...[UPG
  a33ab8:	205d 7473 7261 2074 6570 6672 726f 206d     ] start perform 
  a33ac8:	7075 6164 6574 6920 616d 6567 3a20 3020     update image : 0
  a33ad8:	2578 0d78 000a 0000 555b 4750 205d 7075     x%x.....[UPG] up
  a33ae8:	5f67 6c66 7361 5f68 7265 7361 5f65 656d     g_flash_erase_me
  a33af8:	6174 6164 6174 705f 6761 7365 6620 6961     tadata_pages fai
  a33b08:	2e6c 0a0d 0000 0000 555b 4750 205d 6d69     l.......[UPG] im
  a33b18:	6761 2065 6564 6f63 706d 6572 7373 665f     age decompress_f
  a33b28:	616c 3a67 3020 2578 0d78 000a 555b 4750     lag: 0x%x...[UPG
  a33b38:	205d 6564 6f63 706d 6572 7373 7520 6770     ] decompress upg
  a33b48:	0a0d 0000 555b 4750 205d 6964 6666 7520     ....[UPG] diff u
  a33b58:	6770 0a0d 0000 0000 555b 4750 205d 7566     pg......[UPG] fu
  a33b68:	6c6c 7520 6770 0a0d 0000 0000 555b 4750     ll upg......[UPG
  a33b78:	205d 7773 7469 6863 7320 6174 7574 2073     ] switch status 
  a33b88:	203d 7830 7825 0a0d 0000 0000 555b 4750     = 0x%x......[UPG
  a33b98:	205d 6570 6672 726f 206d 7075 6164 6574     ] perform update
  a33ba8:	6920 616d 6567 6f20 6576 2e72 7220 7465      image over. ret
  a33bb8:	3d20 3020 2578 0d78 000a 0000 555b 4750      = 0x%x.....[UPG
  a33bc8:	205d 7473 7261 2074 6570 6672 726f 206d     ] start perform 
  a33bd8:	564e 6920 616d 6567 3a20 3020 2578 0d78     NV image : 0x%x.
  a33be8:	000a 0000 555b 4750 205d 6570 6672 726f     ....[UPG] perfor
  a33bf8:	206d 564e 6920 616d 6567 6f20 6576 2e72     m NV image over.
  a33c08:	7220 7465 3d20 3020 2578 0d78 000a 0000      ret = 0x%x.....
  a33c18:	555b 4750 205d 7075 5f67 7270 636f 7365     [UPG] upg_proces
  a33c28:	5f73 7075 6164 6574 695f 616d 6567 745f     s_update_image_t
  a33c38:	7361 736b 6620 6961 2c6c 7220 7465 3d20     asks fail, ret =
  a33c48:	3020 2578 0d78 000a 555b 4750 205d 7061      0x%x...[UPG] ap
  a33c58:	2070 6973 657a 6920 2073 6f6e 2074 6e65     p size is not en
  a33c68:	756f 6867 2021 7061 5f70 6973 657a 3d20     ough! app_size =
  a33c78:	3020 2578 2c78 6420 6365 6d6f 7270 7365      0x%x, decompres
  a33c88:	5f73 656c 206e 203d 7830 7825 0a0d 0000     s_len = 0x%x....
  a33c98:	555b 4750 205d 7075 5f67 7a6c 616d 645f     [UPG] upg_lzma_d
  a33ca8:	6365 646f 2065 6166 6c69 7220 7465 3d20     ecode fail ret =
  a33cb8:	3020 2578 0d78 000a 0c40 00a3 0c6e 00a3      0x%x...@...n...
  a33cc8:	0c82 00a3 0cc8 00a3 0d26 00a3 0d2a 00a3     ........&...*...
  a33cd8:	0d68 00a3 0e80 00a3                         h.......

00a33ce0 <g_itoaLowerDigits>:
  a33ce0:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
  a33cf0:	0078 0000                                   x...

00a33cf4 <g_itoaUpperDigits>:
  a33cf4:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF
  a33d04:	0058 0000                                   X...

00a33d08 <stateTable.1749>:
	...
  a33d28:	0006 0600 0100 0000 0000 0603 0600 0002     ................
  a33d38:	0504 0505 0505 0505 0505 0000 0000 0000     ................
  a33d48:	0000 0800 0800 0808 0700 0000 0007 0007     ................
  a33d58:	0000 0800 0000 0000 0008 0007 0000 0000     ................
  a33d68:	0000 0800 0808 0808 0807 0007 0007 0800     ................
  a33d78:	0708 0800 0807 0700 0008 0007 0000 0000     ................
	...
  a33e08:	0800 0808 0808 0008 0100 0800 0808 0808     ................
  a33e18:	0001 0400 0404 0808 0008 0000 0303 0508     ................
  a33e28:	0808 0000 0200 0302 0505 0008 0000 0303     ................
  a33e38:	0503 0805 0000 0200 0202 0808 0008 0000     ................
  a33e48:	0606 0606 0606 0000 0700 0707 0707 0007     ................
  a33e58:	0000 0000                                   ....
