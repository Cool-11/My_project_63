
loaderboot.elf:     file format elf32-littleriscv


Disassembly of section .text.entry:

00a20380 <_start>:
  a20380:	0040006f          	j	a20384 <Reset_Handler>

00a20384 <Reset_Handler>:
  a20384:	fffe6297          	auipc	t0,0xfffe6
  a20388:	71028293          	addi	t0,t0,1808 # a06a94 <g_uart_prag>
  a2038c:	00050313          	mv	t1,a0
  a20390:	00058393          	mv	t2,a1

00a20394 <set_arg_loop>:
  a20394:	00032e03          	lw	t3,0(t1)
  a20398:	01c2a023          	sw	t3,0(t0)
  a2039c:	00428293          	addi	t0,t0,4
  a203a0:	00430313          	addi	t1,t1,4
  a203a4:	ffc38393          	addi	t2,t2,-4
  a203a8:	fe7046e3          	bgtz	t2,a20394 <set_arg_loop>
  a203ac:	00006297          	auipc	t0,0x6
  a203b0:	cf028293          	addi	t0,t0,-784 # a2609c <trap_vector>
  a203b4:	00128293          	addi	t0,t0,1
  a203b8:	30529073          	csrw	mtvec,t0
  a203bc:	30005073          	csrwi	mstatus,0
  a203c0:	30405073          	csrwi	mie,0
  a203c4:	fffe3197          	auipc	gp,0xfffe3
  a203c8:	91818193          	addi	gp,gp,-1768 # a02cdc <_gp_>
  a203cc:	fffe2117          	auipc	sp,0xfffe2
  a203d0:	83410113          	addi	sp,sp,-1996 # a01c00 <__stack_top__>
  a203d4:	fffe0297          	auipc	t0,0xfffe0
  a203d8:	c2c28293          	addi	t0,t0,-980 # a00000 <g_system_stack_begin>
  a203dc:	fffe2317          	auipc	t1,0xfffe2
  a203e0:	02430313          	addi	t1,t1,36 # a02400 <g_efuse_clock_period>
  a203e4:	00628c63          	beq	t0,t1,a203fc <end_set_stack_loop>
  a203e8:	efbeb3b7          	lui	t2,0xefbeb
  a203ec:	dde38393          	addi	t2,t2,-546 # efbeadde <__data_load__+0xef1c33aa>

00a203f0 <set_stack_loop>:
  a203f0:	0072a023          	sw	t2,0(t0)
  a203f4:	00428293          	addi	t0,t0,4
  a203f8:	fe62cce3          	blt	t0,t1,a203f0 <set_stack_loop>

00a203fc <end_set_stack_loop>:
  a203fc:	00000093          	li	ra,0
  a20400:	00000213          	li	tp,0
  a20404:	00000413          	li	s0,0
  a20408:	00000493          	li	s1,0
  a2040c:	00000513          	li	a0,0
  a20410:	00000593          	li	a1,0
  a20414:	00000613          	li	a2,0
  a20418:	00000693          	li	a3,0
  a2041c:	00000713          	li	a4,0
  a20420:	00000793          	li	a5,0
  a20424:	00000813          	li	a6,0
  a20428:	00000893          	li	a7,0
  a2042c:	00000913          	li	s2,0
  a20430:	00000993          	li	s3,0
  a20434:	00000a13          	li	s4,0
  a20438:	00000a93          	li	s5,0
  a2043c:	00000b13          	li	s6,0
  a20440:	00000b93          	li	s7,0
  a20444:	00000c13          	li	s8,0
  a20448:	00000c93          	li	s9,0
  a2044c:	00000d13          	li	s10,0
  a20450:	00000d93          	li	s11,0
  a20454:	00000e13          	li	t3,0
  a20458:	00000e93          	li	t4,0
  a2045c:	00000f13          	li	t5,0
  a20460:	00000f93          	li	t6,0
  a20464:	fffe2297          	auipc	t0,0xfffe2
  a20468:	f9c28293          	addi	t0,t0,-100 # a02400 <g_efuse_clock_period>
  a2046c:	00007317          	auipc	t1,0x7
  a20470:	5c830313          	addi	t1,t1,1480 # a27a34 <__data_load__>
  a20474:	0dc00393          	li	t2,220
  a20478:	00038e63          	beqz	t2,a20494 <end_set_data_loop>

00a2047c <set_data_loop>:
  a2047c:	00032e03          	lw	t3,0(t1)
  a20480:	01c2a023          	sw	t3,0(t0)
  a20484:	00428293          	addi	t0,t0,4
  a20488:	00430313          	addi	t1,t1,4
  a2048c:	ffc38393          	addi	t2,t2,-4
  a20490:	fe7046e3          	bgtz	t2,a2047c <set_data_loop>

00a20494 <end_set_data_loop>:
  a20494:	fffe2297          	auipc	t0,0xfffe2
  a20498:	14428293          	addi	t0,t0,324 # a025d8 <g_flash_cmd_funcs>
  a2049c:	fffe6317          	auipc	t1,0xfffe6
  a204a0:	5f830313          	addi	t1,t1,1528 # a06a94 <g_uart_prag>
  a204a4:	00628a63          	beq	t0,t1,a204b8 <end_clear_bss_loop>
  a204a8:	00000393          	li	t2,0

00a204ac <clear_bss_loop>:
  a204ac:	0072a023          	sw	t2,0(t0)
  a204b0:	00428293          	addi	t0,t0,4
  a204b4:	fe62cce3          	blt	t0,t1,a204ac <clear_bss_loop>

00a204b8 <end_clear_bss_loop>:
  a204b8:	74e0106f          	j	a21c06 <start_loaderboot>

00a204bc <g_ram_exception_table>:
  a204bc:	00a25fa0 00a25334 00a25334 00a25334     ._..4S..4S..4S..
  a204cc:	00a25334 00a25334 00a25334 00a25334     4S..4S..4S..4S..
  a204dc:	00a25334 00a25334 00a25334 00a25334     4S..4S..4S..4S..
  a204ec:	00a25348 00a25334 00a25334 00a25334     HS..4S..4S..4S..
  a204fc:	00a25334 00a25334 00a25334 00a25334     4S..4S..4S..4S..
  a2050c:	00a25334 00a25334 00a25334 00a25334     4S..4S..4S..4S..
  a2051c:	00a25334 00a25334 00a24f20 00a24f20     4S..4S.. O.. O..
  a2052c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2053c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2054c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2055c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2056c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2057c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2058c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a2059c:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a205ac:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a205bc:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a205cc:	00a24f20 00a24f20 00a24f20 00a24f20      O.. O.. O.. O..
  a205dc:	00a24f20 00a24f20                        O.. O..

Disassembly of section .text:

00a205f0 <exc_syscall>:
  a205f0:	8082                	ret

00a205f2 <handle_syscall>:
  a205f2:	0411                	addi	s0,s0,4
  a205f4:	c022                	sw	s0,0(sp)
  a205f6:	3fed                	jal	ra,a205f0 <exc_syscall>
  a205f8:	42d2                	lw	t0,20(sp)
  a205fa:	34129073          	csrw	mepc,t0
  a205fe:	5d82                	lw	s11,32(sp)
  a20600:	5d12                	lw	s10,36(sp)
  a20602:	5ca2                	lw	s9,40(sp)
  a20604:	5c32                	lw	s8,44(sp)
  a20606:	5bc2                	lw	s7,48(sp)
  a20608:	5b52                	lw	s6,52(sp)
  a2060a:	5ae2                	lw	s5,56(sp)
  a2060c:	5a72                	lw	s4,60(sp)
  a2060e:	4986                	lw	s3,64(sp)
  a20610:	4916                	lw	s2,68(sp)
  a20612:	44a6                	lw	s1,72(sp)
  a20614:	4436                	lw	s0,76(sp)
  a20616:	4fc6                	lw	t6,80(sp)
  a20618:	4f56                	lw	t5,84(sp)
  a2061a:	4ee6                	lw	t4,88(sp)
  a2061c:	4e76                	lw	t3,92(sp)
  a2061e:	5886                	lw	a7,96(sp)
  a20620:	5816                	lw	a6,100(sp)
  a20622:	57a6                	lw	a5,104(sp)
  a20624:	5736                	lw	a4,108(sp)
  a20626:	56c6                	lw	a3,112(sp)
  a20628:	5656                	lw	a2,116(sp)
  a2062a:	55e6                	lw	a1,120(sp)
  a2062c:	5576                	lw	a0,124(sp)
  a2062e:	438a                	lw	t2,128(sp)
  a20630:	431a                	lw	t1,132(sp)
  a20632:	42aa                	lw	t0,136(sp)
  a20634:	40ba                	lw	ra,140(sp)
  a20636:	6149                	addi	sp,sp,144
  a20638:	30200073          	mret

00a2063c <__udivdi3>:
  a2063c:	4701                	li	a4,0
  a2063e:	a039                	j	a2064c <__udivmoddi4>

00a20640 <__umoddi3>:
  a20640:	8118                	push	{ra},-32
  a20642:	0038                	addi	a4,sp,8
  a20644:	2021                	jal	ra,a2064c <__udivmoddi4>
  a20646:	4522                	lw	a0,8(sp)
  a20648:	45b2                	lw	a1,12(sp)
  a2064a:	8114                	popret	{ra},32

00a2064c <__udivmoddi4>:
  a2064c:	88b6                	mv	a7,a3
  a2064e:	8832                	mv	a6,a2
  a20650:	87aa                	mv	a5,a0
  a20652:	8e2e                	mv	t3,a1
  a20654:	eedd                	bnez	a3,a20712 <__udivmoddi4+0xc6>
  a20656:	12c5f163          	bgeu	a1,a2,a20778 <__udivmoddi4+0x12c>
  a2065a:	66c1                	lui	a3,0x10
  a2065c:	1cd66a63          	bltu	a2,a3,a20830 <__udivmoddi4+0x1e4>
  a20660:	010006b7          	lui	a3,0x1000
  a20664:	3ad66563          	bltu	a2,a3,a20a0e <__udivmoddi4+0x3c2>
  a20668:	01865313          	srli	t1,a2,0x18
  a2066c:	48e1                	li	a7,24
  a2066e:	fffe2697          	auipc	a3,0xfffe2
  a20672:	e626a683          	lw	a3,-414(a3) # a024d0 <_GLOBAL_OFFSET_TABLE_+0x4>
  a20676:	969a                	add	a3,a3,t1
  a20678:	2294                	lbu	a3,0(a3)
  a2067a:	02000313          	li	t1,32
  a2067e:	98b6                	add	a7,a7,a3
  a20680:	41130333          	sub	t1,t1,a7
  a20684:	00030c63          	beqz	t1,a2069c <__udivmoddi4+0x50>
  a20688:	006595b3          	sll	a1,a1,t1
  a2068c:	011558b3          	srl	a7,a0,a7
  a20690:	00661833          	sll	a6,a2,t1
  a20694:	00b8ee33          	or	t3,a7,a1
  a20698:	006517b3          	sll	a5,a0,t1
  a2069c:	01085e93          	srli	t4,a6,0x10
  a206a0:	03de5f33          	divu	t5,t3,t4
  a206a4:	01081613          	slli	a2,a6,0x10
  a206a8:	8241                	srli	a2,a2,0x10
  a206aa:	0107d693          	srli	a3,a5,0x10
  a206ae:	03de75b3          	remu	a1,t3,t4
  a206b2:	03e60fb3          	mul	t6,a2,t5
  a206b6:	20b6a69b          	orshf	a3,a3,a1,sll,16
  a206ba:	01f6fa63          	bgeu	a3,t6,a206ce <__udivmoddi4+0x82>
  a206be:	96c2                	add	a3,a3,a6
  a206c0:	ffff0593          	addi	a1,t5,-1
  a206c4:	0106e463          	bltu	a3,a6,a206cc <__udivmoddi4+0x80>
  a206c8:	37f6e563          	bltu	a3,t6,a20a32 <__udivmoddi4+0x3e6>
  a206cc:	8f2e                	mv	t5,a1
  a206ce:	41f685b3          	sub	a1,a3,t6
  a206d2:	03d5d533          	divu	a0,a1,t4
  a206d6:	01079693          	slli	a3,a5,0x10
  a206da:	82c1                	srli	a3,a3,0x10
  a206dc:	03d5f5b3          	remu	a1,a1,t4
  a206e0:	02a60633          	mul	a2,a2,a0
  a206e4:	20b6a79b          	orshf	a5,a3,a1,sll,16
  a206e8:	00c7fa63          	bgeu	a5,a2,a206fc <__udivmoddi4+0xb0>
  a206ec:	97c2                	add	a5,a5,a6
  a206ee:	fff50693          	addi	a3,a0,-1
  a206f2:	0107e463          	bltu	a5,a6,a206fa <__udivmoddi4+0xae>
  a206f6:	32c7eb63          	bltu	a5,a2,a20a2c <__udivmoddi4+0x3e0>
  a206fa:	8536                	mv	a0,a3
  a206fc:	8f91                	sub	a5,a5,a2
  a206fe:	21e5251b          	orshf	a0,a0,t5,sll,16
  a20702:	4581                	li	a1,0
  a20704:	c711                	beqz	a4,a20710 <__udivmoddi4+0xc4>
  a20706:	0067d7b3          	srl	a5,a5,t1
  a2070a:	c31c                	sw	a5,0(a4)
  a2070c:	00072223          	sw	zero,4(a4)
  a20710:	8082                	ret
  a20712:	00d5f963          	bgeu	a1,a3,a20724 <__udivmoddi4+0xd8>
  a20716:	12070f63          	beqz	a4,a20854 <__udivmoddi4+0x208>
  a2071a:	c308                	sw	a0,0(a4)
  a2071c:	c34c                	sw	a1,4(a4)
  a2071e:	4501                	li	a0,0
  a20720:	4581                	li	a1,0
  a20722:	8082                	ret
  a20724:	67c1                	lui	a5,0x10
  a20726:	0ef6ed63          	bltu	a3,a5,a20820 <__udivmoddi4+0x1d4>
  a2072a:	010007b7          	lui	a5,0x1000
  a2072e:	2cf6ea63          	bltu	a3,a5,a20a02 <__udivmoddi4+0x3b6>
  a20732:	0186d893          	srli	a7,a3,0x18
  a20736:	4861                	li	a6,24
  a20738:	fffe2797          	auipc	a5,0xfffe2
  a2073c:	d987a783          	lw	a5,-616(a5) # a024d0 <_GLOBAL_OFFSET_TABLE_+0x4>
  a20740:	97c6                	add	a5,a5,a7
  a20742:	0007c303          	lbu	t1,0(a5)
  a20746:	02000e93          	li	t4,32
  a2074a:	9342                	add	t1,t1,a6
  a2074c:	406e8eb3          	sub	t4,t4,t1
  a20750:	180e9563          	bnez	t4,a208da <__udivmoddi4+0x28e>
  a20754:	00b6e463          	bltu	a3,a1,a2075c <__udivmoddi4+0x110>
  a20758:	2ec56363          	bltu	a0,a2,a20a3e <__udivmoddi4+0x3f2>
  a2075c:	40c50633          	sub	a2,a0,a2
  a20760:	00c53533          	sltu	a0,a0,a2
  a20764:	8d95                	sub	a1,a1,a3
  a20766:	40a58e33          	sub	t3,a1,a0
  a2076a:	4505                	li	a0,1
  a2076c:	4581                	li	a1,0
  a2076e:	d34d                	beqz	a4,a20710 <__udivmoddi4+0xc4>
  a20770:	c310                	sw	a2,0(a4)
  a20772:	01c72223          	sw	t3,4(a4)
  a20776:	8082                	ret
  a20778:	e601                	bnez	a2,a20780 <__udivmoddi4+0x134>
  a2077a:	4685                	li	a3,1
  a2077c:	02c6d833          	divu	a6,a3,a2
  a20780:	66c1                	lui	a3,0x10
  a20782:	0cd86063          	bltu	a6,a3,a20842 <__udivmoddi4+0x1f6>
  a20786:	010006b7          	lui	a3,0x1000
  a2078a:	26d86863          	bltu	a6,a3,a209fa <__udivmoddi4+0x3ae>
  a2078e:	01885613          	srli	a2,a6,0x18
  a20792:	48e1                	li	a7,24
  a20794:	fffe2697          	auipc	a3,0xfffe2
  a20798:	d3c6a683          	lw	a3,-708(a3) # a024d0 <_GLOBAL_OFFSET_TABLE_+0x4>
  a2079c:	96b2                	add	a3,a3,a2
  a2079e:	2290                	lbu	a2,0(a3)
  a207a0:	02000313          	li	t1,32
  a207a4:	9646                	add	a2,a2,a7
  a207a6:	40c30333          	sub	t1,t1,a2
  a207aa:	0a031863          	bnez	t1,a2085a <__udivmoddi4+0x20e>
  a207ae:	01081e93          	slli	t4,a6,0x10
  a207b2:	410586b3          	sub	a3,a1,a6
  a207b6:	01085f13          	srli	t5,a6,0x10
  a207ba:	010ede93          	srli	t4,t4,0x10
  a207be:	4585                	li	a1,1
  a207c0:	0107d893          	srli	a7,a5,0x10
  a207c4:	03e6de33          	divu	t3,a3,t5
  a207c8:	03e6f6b3          	remu	a3,a3,t5
  a207cc:	03de0633          	mul	a2,t3,t4
  a207d0:	20d8a69b          	orshf	a3,a7,a3,sll,16
  a207d4:	00c6fa63          	bgeu	a3,a2,a207e8 <__udivmoddi4+0x19c>
  a207d8:	96c2                	add	a3,a3,a6
  a207da:	fffe0513          	addi	a0,t3,-1
  a207de:	0106e463          	bltu	a3,a6,a207e6 <__udivmoddi4+0x19a>
  a207e2:	24c6eb63          	bltu	a3,a2,a20a38 <__udivmoddi4+0x3ec>
  a207e6:	8e2a                	mv	t3,a0
  a207e8:	40c68633          	sub	a2,a3,a2
  a207ec:	03e65533          	divu	a0,a2,t5
  a207f0:	01079693          	slli	a3,a5,0x10
  a207f4:	82c1                	srli	a3,a3,0x10
  a207f6:	03e67633          	remu	a2,a2,t5
  a207fa:	03d508b3          	mul	a7,a0,t4
  a207fe:	20c6a79b          	orshf	a5,a3,a2,sll,16
  a20802:	0117fa63          	bgeu	a5,a7,a20816 <__udivmoddi4+0x1ca>
  a20806:	97c2                	add	a5,a5,a6
  a20808:	fff50693          	addi	a3,a0,-1
  a2080c:	0107e463          	bltu	a5,a6,a20814 <__udivmoddi4+0x1c8>
  a20810:	2117eb63          	bltu	a5,a7,a20a26 <__udivmoddi4+0x3da>
  a20814:	8536                	mv	a0,a3
  a20816:	411787b3          	sub	a5,a5,a7
  a2081a:	21c5251b          	orshf	a0,a0,t3,sll,16
  a2081e:	b5dd                	j	a20704 <__udivmoddi4+0xb8>
  a20820:	0ff00793          	li	a5,255
  a20824:	1ed7f363          	bgeu	a5,a3,a20a0a <__udivmoddi4+0x3be>
  a20828:	0086d893          	srli	a7,a3,0x8
  a2082c:	4821                	li	a6,8
  a2082e:	b729                	j	a20738 <__udivmoddi4+0xec>
  a20830:	8332                	mv	t1,a2
  a20832:	0ff00693          	li	a3,255
  a20836:	e2c6fce3          	bgeu	a3,a2,a2066e <__udivmoddi4+0x22>
  a2083a:	00865313          	srli	t1,a2,0x8
  a2083e:	48a1                	li	a7,8
  a20840:	b53d                	j	a2066e <__udivmoddi4+0x22>
  a20842:	8642                	mv	a2,a6
  a20844:	0ff00693          	li	a3,255
  a20848:	f506f6e3          	bgeu	a3,a6,a20794 <__udivmoddi4+0x148>
  a2084c:	00885613          	srli	a2,a6,0x8
  a20850:	48a1                	li	a7,8
  a20852:	b789                	j	a20794 <__udivmoddi4+0x148>
  a20854:	4581                	li	a1,0
  a20856:	4501                	li	a0,0
  a20858:	8082                	ret
  a2085a:	00681833          	sll	a6,a6,t1
  a2085e:	00c5d8b3          	srl	a7,a1,a2
  a20862:	01085f13          	srli	t5,a6,0x10
  a20866:	03e8dfb3          	divu	t6,a7,t5
  a2086a:	01081e93          	slli	t4,a6,0x10
  a2086e:	006595b3          	sll	a1,a1,t1
  a20872:	00c55633          	srl	a2,a0,a2
  a20876:	010ede93          	srli	t4,t4,0x10
  a2087a:	8e4d                	or	a2,a2,a1
  a2087c:	01065e13          	srli	t3,a2,0x10
  a20880:	006517b3          	sll	a5,a0,t1
  a20884:	03e8f8b3          	remu	a7,a7,t5
  a20888:	03fe85b3          	mul	a1,t4,t6
  a2088c:	211e251b          	orshf	a0,t3,a7,sll,16
  a20890:	00b57b63          	bgeu	a0,a1,a208a6 <__udivmoddi4+0x25a>
  a20894:	9542                	add	a0,a0,a6
  a20896:	ffff8693          	addi	a3,t6,-1
  a2089a:	19056463          	bltu	a0,a6,a20a22 <__udivmoddi4+0x3d6>
  a2089e:	18b57263          	bgeu	a0,a1,a20a22 <__udivmoddi4+0x3d6>
  a208a2:	1ff9                	addi	t6,t6,-2
  a208a4:	9542                	add	a0,a0,a6
  a208a6:	8d0d                	sub	a0,a0,a1
  a208a8:	03e558b3          	divu	a7,a0,t5
  a208ac:	9e21                	uxth	a2
  a208ae:	03e57533          	remu	a0,a0,t5
  a208b2:	031e86b3          	mul	a3,t4,a7
  a208b6:	20a6259b          	orshf	a1,a2,a0,sll,16
  a208ba:	00d5fb63          	bgeu	a1,a3,a208d0 <__udivmoddi4+0x284>
  a208be:	95c2                	add	a1,a1,a6
  a208c0:	fff88613          	addi	a2,a7,-1
  a208c4:	1505eb63          	bltu	a1,a6,a20a1a <__udivmoddi4+0x3ce>
  a208c8:	14d5f963          	bgeu	a1,a3,a20a1a <__udivmoddi4+0x3ce>
  a208cc:	18f9                	addi	a7,a7,-2
  a208ce:	95c2                	add	a1,a1,a6
  a208d0:	40d586b3          	sub	a3,a1,a3
  a208d4:	21f8a59b          	orshf	a1,a7,t6,sll,16
  a208d8:	b5e5                	j	a207c0 <__udivmoddi4+0x174>
  a208da:	00665833          	srl	a6,a2,t1
  a208de:	01d696b3          	sll	a3,a3,t4
  a208e2:	00d866b3          	or	a3,a6,a3
  a208e6:	0065d7b3          	srl	a5,a1,t1
  a208ea:	0106de13          	srli	t3,a3,0x10
  a208ee:	03c7dfb3          	divu	t6,a5,t3
  a208f2:	01069893          	slli	a7,a3,0x10
  a208f6:	0108d893          	srli	a7,a7,0x10
  a208fa:	00655833          	srl	a6,a0,t1
  a208fe:	01d51f33          	sll	t5,a0,t4
  a20902:	01d595b3          	sll	a1,a1,t4
  a20906:	00b865b3          	or	a1,a6,a1
  a2090a:	0105d813          	srli	a6,a1,0x10
  a2090e:	01d61633          	sll	a2,a2,t4
  a20912:	03c7f7b3          	remu	a5,a5,t3
  a20916:	03f88533          	mul	a0,a7,t6
  a2091a:	20f8279b          	orshf	a5,a6,a5,sll,16
  a2091e:	00a7fb63          	bgeu	a5,a0,a20934 <__udivmoddi4+0x2e8>
  a20922:	97b6                	add	a5,a5,a3
  a20924:	ffff8813          	addi	a6,t6,-1
  a20928:	0ed7eb63          	bltu	a5,a3,a20a1e <__udivmoddi4+0x3d2>
  a2092c:	0ea7f963          	bgeu	a5,a0,a20a1e <__udivmoddi4+0x3d2>
  a20930:	1ff9                	addi	t6,t6,-2
  a20932:	97b6                	add	a5,a5,a3
  a20934:	8f89                	sub	a5,a5,a0
  a20936:	03c7d533          	divu	a0,a5,t3
  a2093a:	9da1                	uxth	a1
  a2093c:	03c7f7b3          	remu	a5,a5,t3
  a20940:	02a888b3          	mul	a7,a7,a0
  a20944:	20f5a59b          	orshf	a1,a1,a5,sll,16
  a20948:	0115fb63          	bgeu	a1,a7,a2095e <__udivmoddi4+0x312>
  a2094c:	95b6                	add	a1,a1,a3
  a2094e:	fff50793          	addi	a5,a0,-1
  a20952:	0cd5e263          	bltu	a1,a3,a20a16 <__udivmoddi4+0x3ca>
  a20956:	0d15f063          	bgeu	a1,a7,a20a16 <__udivmoddi4+0x3ca>
  a2095a:	1579                	addi	a0,a0,-2
  a2095c:	95b6                	add	a1,a1,a3
  a2095e:	63c1                	lui	t2,0x10
  a20960:	21f5251b          	orshf	a0,a0,t6,sll,16
  a20964:	fff38793          	addi	a5,t2,-1 # ffff <ccause+0xf03d>
  a20968:	00f57833          	and	a6,a0,a5
  a2096c:	01055e13          	srli	t3,a0,0x10
  a20970:	8ff1                	and	a5,a5,a2
  a20972:	01065f93          	srli	t6,a2,0x10
  a20976:	02fe02b3          	mul	t0,t3,a5
  a2097a:	411588b3          	sub	a7,a1,a7
  a2097e:	03f805b3          	mul	a1,a6,t6
  a20982:	02f80833          	mul	a6,a6,a5
  a20986:	9596                	add	a1,a1,t0
  a20988:	6105859b          	addshf	a1,a1,a6,srl,16
  a2098c:	03fe0e33          	mul	t3,t3,t6
  a20990:	0055f363          	bgeu	a1,t0,a20996 <__udivmoddi4+0x34a>
  a20994:	9e1e                	add	t3,t3,t2
  a20996:	67c1                	lui	a5,0x10
  a20998:	17fd                	addi	a5,a5,-1 # ffff <ccause+0xf03d>
  a2099a:	00f5ffb3          	and	t6,a1,a5
  a2099e:	00f877b3          	and	a5,a6,a5
  a209a2:	60be081b          	addshf	a6,t3,a1,srl,16
  a209a6:	21f7879b          	addshf	a5,a5,t6,sll,16
  a209aa:	0308ed63          	bltu	a7,a6,a209e4 <__udivmoddi4+0x398>
  a209ae:	03088963          	beq	a7,a6,a209e0 <__udivmoddi4+0x394>
  a209b2:	4581                	li	a1,0
  a209b4:	d4070ee3          	beqz	a4,a20710 <__udivmoddi4+0xc4>
  a209b8:	40ff07b3          	sub	a5,t5,a5
  a209bc:	00ff3f33          	sltu	t5,t5,a5
  a209c0:	410888b3          	sub	a7,a7,a6
  a209c4:	41e888b3          	sub	a7,a7,t5
  a209c8:	00689333          	sll	t1,a7,t1
  a209cc:	01d7d7b3          	srl	a5,a5,t4
  a209d0:	00f367b3          	or	a5,t1,a5
  a209d4:	01d8d8b3          	srl	a7,a7,t4
  a209d8:	c31c                	sw	a5,0(a4)
  a209da:	01172223          	sw	a7,4(a4)
  a209de:	8082                	ret
  a209e0:	fcff79e3          	bgeu	t5,a5,a209b2 <__udivmoddi4+0x366>
  a209e4:	40c78633          	sub	a2,a5,a2
  a209e8:	00c7b7b3          	sltu	a5,a5,a2
  a209ec:	40d80833          	sub	a6,a6,a3
  a209f0:	40f80833          	sub	a6,a6,a5
  a209f4:	157d                	addi	a0,a0,-1
  a209f6:	87b2                	mv	a5,a2
  a209f8:	bf6d                	j	a209b2 <__udivmoddi4+0x366>
  a209fa:	01085613          	srli	a2,a6,0x10
  a209fe:	48c1                	li	a7,16
  a20a00:	bb51                	j	a20794 <__udivmoddi4+0x148>
  a20a02:	0106d893          	srli	a7,a3,0x10
  a20a06:	4841                	li	a6,16
  a20a08:	bb05                	j	a20738 <__udivmoddi4+0xec>
  a20a0a:	4801                	li	a6,0
  a20a0c:	b335                	j	a20738 <__udivmoddi4+0xec>
  a20a0e:	01065313          	srli	t1,a2,0x10
  a20a12:	48c1                	li	a7,16
  a20a14:	b9a9                	j	a2066e <__udivmoddi4+0x22>
  a20a16:	853e                	mv	a0,a5
  a20a18:	b799                	j	a2095e <__udivmoddi4+0x312>
  a20a1a:	88b2                	mv	a7,a2
  a20a1c:	bd55                	j	a208d0 <__udivmoddi4+0x284>
  a20a1e:	8fc2                	mv	t6,a6
  a20a20:	bf11                	j	a20934 <__udivmoddi4+0x2e8>
  a20a22:	8fb6                	mv	t6,a3
  a20a24:	b549                	j	a208a6 <__udivmoddi4+0x25a>
  a20a26:	1579                	addi	a0,a0,-2
  a20a28:	97c2                	add	a5,a5,a6
  a20a2a:	b3f5                	j	a20816 <__udivmoddi4+0x1ca>
  a20a2c:	1579                	addi	a0,a0,-2
  a20a2e:	97c2                	add	a5,a5,a6
  a20a30:	b1f1                	j	a206fc <__udivmoddi4+0xb0>
  a20a32:	1f79                	addi	t5,t5,-2
  a20a34:	96c2                	add	a3,a3,a6
  a20a36:	b961                	j	a206ce <__udivmoddi4+0x82>
  a20a38:	1e79                	addi	t3,t3,-2
  a20a3a:	96c2                	add	a3,a3,a6
  a20a3c:	b375                	j	a207e8 <__udivmoddi4+0x19c>
  a20a3e:	862a                	mv	a2,a0
  a20a40:	4501                	li	a0,0
  a20a42:	b32d                	j	a2076c <__udivmoddi4+0x120>

00a20a44 <memset>:
  a20a44:	ca59                	beqz	a2,a20ada <memset+0x96>
  a20a46:	0ff5f793          	andi	a5,a1,255
  a20a4a:	a11c                	sb	a5,0(a0)
  a20a4c:	00c50733          	add	a4,a0,a2
  a20a50:	fef70fa3          	sb	a5,-1(a4)
  a20a54:	032661bb          	bltui	a2,3,a20ada <memset+0x96>
  a20a58:	b11c                	sb	a5,1(a0)
  a20a5a:	a13c                	sb	a5,2(a0)
  a20a5c:	fef70f23          	sb	a5,-2(a4)
  a20a60:	fef70ea3          	sb	a5,-3(a4)
  a20a64:	07166dbb          	bltui	a2,7,a20ada <memset+0x96>
  a20a68:	b13c                	sb	a5,3(a0)
  a20a6a:	fef70e23          	sb	a5,-4(a4)
  a20a6e:	46a1                	li	a3,8
  a20a70:	06c6f563          	bgeu	a3,a2,a20ada <memset+0x96>
  a20a74:	40a007b3          	neg	a5,a0
  a20a78:	8b8d                	andi	a5,a5,3
  a20a7a:	00f50733          	add	a4,a0,a5
  a20a7e:	8e1d                	sub	a2,a2,a5
  a20a80:	0ff5f593          	andi	a1,a1,255
  a20a84:	0101 0101 079f      	l.li	a5,0x1010101
  a20a8a:	02f585b3          	mul	a1,a1,a5
  a20a8e:	9a71                	andi	a2,a2,-4
  a20a90:	00c707b3          	add	a5,a4,a2
  a20a94:	c30c                	sw	a1,0(a4)
  a20a96:	feb7ae23          	sw	a1,-4(a5)
  a20a9a:	04c6f063          	bgeu	a3,a2,a20ada <memset+0x96>
  a20a9e:	c34c                	sw	a1,4(a4)
  a20aa0:	c70c                	sw	a1,8(a4)
  a20aa2:	feb7aa23          	sw	a1,-12(a5)
  a20aa6:	feb7ac23          	sw	a1,-8(a5)
  a20aaa:	19066c3b          	bltui	a2,25,a20ada <memset+0x96>
  a20aae:	c74c                	sw	a1,12(a4)
  a20ab0:	cb0c                	sw	a1,16(a4)
  a20ab2:	cb4c                	sw	a1,20(a4)
  a20ab4:	cf0c                	sw	a1,24(a4)
  a20ab6:	feb7a223          	sw	a1,-28(a5)
  a20aba:	feb7a423          	sw	a1,-24(a5)
  a20abe:	feb7a623          	sw	a1,-20(a5)
  a20ac2:	feb7a823          	sw	a1,-16(a5)
  a20ac6:	00477793          	andi	a5,a4,4
  a20aca:	07e1                	addi	a5,a5,24
  a20acc:	97ba                	add	a5,a5,a4
  a20ace:	46fd                	li	a3,31
  a20ad0:	9732                	add	a4,a4,a2
  a20ad2:	40f70633          	sub	a2,a4,a5
  a20ad6:	00c6e363          	bltu	a3,a2,a20adc <memset+0x98>
  a20ada:	8082                	ret
  a20adc:	c38c                	sw	a1,0(a5)
  a20ade:	c3cc                	sw	a1,4(a5)
  a20ae0:	c78c                	sw	a1,8(a5)
  a20ae2:	c7cc                	sw	a1,12(a5)
  a20ae4:	cb8c                	sw	a1,16(a5)
  a20ae6:	cbcc                	sw	a1,20(a5)
  a20ae8:	cf8c                	sw	a1,24(a5)
  a20aea:	cfcc                	sw	a1,28(a5)
  a20aec:	02078793          	addi	a5,a5,32
  a20af0:	b7cd                	j	a20ad2 <memset+0x8e>

00a20af2 <memcpy>:
  a20af2:	87aa                	mv	a5,a0
  a20af4:	0035f713          	andi	a4,a1,3
  a20af8:	c319                	beqz	a4,a20afe <memcpy+0xc>
  a20afa:	16061963          	bnez	a2,a20c6c <memcpy+0x17a>
  a20afe:	0037f813          	andi	a6,a5,3
  a20b02:	473d                	li	a4,15
  a20b04:	18080e63          	beqz	a6,a20ca0 <memcpy+0x1ae>
  a20b08:	20166abb          	bltui	a2,32,a20b72 <memcpy+0x80>
  a20b0c:	2194                	lbu	a3,0(a1)
  a20b0e:	4198                	lw	a4,0(a1)
  a20b10:	027807bb          	beqi	a6,2,a20cee <memcpy+0x1fc>
  a20b14:	488d                	li	a7,3
  a20b16:	23180563          	beq	a6,a7,a20d40 <memcpy+0x24e>
  a20b1a:	a394                	sb	a3,0(a5)
  a20b1c:	3194                	lbu	a3,1(a1)
  a20b1e:	1675                	addi	a2,a2,-3
  a20b20:	058d                	addi	a1,a1,3
  a20b22:	b394                	sb	a3,1(a5)
  a20b24:	fff5c683          	lbu	a3,-1(a1)
  a20b28:	078d                	addi	a5,a5,3
  a20b2a:	4e41                	li	t3,16
  a20b2c:	fed78fa3          	sb	a3,-1(a5)
  a20b30:	0015a303          	lw	t1,1(a1)
  a20b34:	0055a883          	lw	a7,5(a1)
  a20b38:	1641                	addi	a2,a2,-16
  a20b3a:	00831813          	slli	a6,t1,0x8
  a20b3e:	70e8271b          	orshf	a4,a6,a4,srl,24
  a20b42:	0095a803          	lw	a6,9(a1)
  a20b46:	c398                	sw	a4,0(a5)
  a20b48:	00889693          	slli	a3,a7,0x8
  a20b4c:	00881713          	slli	a4,a6,0x8
  a20b50:	7117271b          	orshf	a4,a4,a7,srl,24
  a20b54:	c798                	sw	a4,8(a5)
  a20b56:	00d5a703          	lw	a4,13(a1)
  a20b5a:	7066a69b          	orshf	a3,a3,t1,srl,24
  a20b5e:	c3d4                	sw	a3,4(a5)
  a20b60:	00871693          	slli	a3,a4,0x8
  a20b64:	7106a69b          	orshf	a3,a3,a6,srl,24
  a20b68:	c7d4                	sw	a3,12(a5)
  a20b6a:	05c1                	addi	a1,a1,16
  a20b6c:	07c1                	addi	a5,a5,16
  a20b6e:	fcce61e3          	bltu	t3,a2,a20b30 <memcpy+0x3e>
  a20b72:	01067713          	andi	a4,a2,16
  a20b76:	c351                	beqz	a4,a20bfa <memcpy+0x108>
  a20b78:	2198                	lbu	a4,0(a1)
  a20b7a:	07c1                	addi	a5,a5,16
  a20b7c:	05c1                	addi	a1,a1,16
  a20b7e:	fee78823          	sb	a4,-16(a5)
  a20b82:	ff15c703          	lbu	a4,-15(a1)
  a20b86:	fee788a3          	sb	a4,-15(a5)
  a20b8a:	ff25c703          	lbu	a4,-14(a1)
  a20b8e:	fee78923          	sb	a4,-14(a5)
  a20b92:	ff35c703          	lbu	a4,-13(a1)
  a20b96:	fee789a3          	sb	a4,-13(a5)
  a20b9a:	ff45c703          	lbu	a4,-12(a1)
  a20b9e:	fee78a23          	sb	a4,-12(a5)
  a20ba2:	ff55c703          	lbu	a4,-11(a1)
  a20ba6:	fee78aa3          	sb	a4,-11(a5)
  a20baa:	ff65c703          	lbu	a4,-10(a1)
  a20bae:	fee78b23          	sb	a4,-10(a5)
  a20bb2:	ff75c703          	lbu	a4,-9(a1)
  a20bb6:	fee78ba3          	sb	a4,-9(a5)
  a20bba:	ff85c703          	lbu	a4,-8(a1)
  a20bbe:	fee78c23          	sb	a4,-8(a5)
  a20bc2:	ff95c703          	lbu	a4,-7(a1)
  a20bc6:	fee78ca3          	sb	a4,-7(a5)
  a20bca:	ffa5c703          	lbu	a4,-6(a1)
  a20bce:	fee78d23          	sb	a4,-6(a5)
  a20bd2:	ffb5c703          	lbu	a4,-5(a1)
  a20bd6:	fee78da3          	sb	a4,-5(a5)
  a20bda:	ffc5c703          	lbu	a4,-4(a1)
  a20bde:	fee78e23          	sb	a4,-4(a5)
  a20be2:	ffd5c703          	lbu	a4,-3(a1)
  a20be6:	fee78ea3          	sb	a4,-3(a5)
  a20bea:	ffe5c703          	lbu	a4,-2(a1)
  a20bee:	fee78f23          	sb	a4,-2(a5)
  a20bf2:	fff5c703          	lbu	a4,-1(a1)
  a20bf6:	fee78fa3          	sb	a4,-1(a5)
  a20bfa:	00867713          	andi	a4,a2,8
  a20bfe:	c331                	beqz	a4,a20c42 <memcpy+0x150>
  a20c00:	2198                	lbu	a4,0(a1)
  a20c02:	07a1                	addi	a5,a5,8
  a20c04:	05a1                	addi	a1,a1,8
  a20c06:	fee78c23          	sb	a4,-8(a5)
  a20c0a:	ff95c703          	lbu	a4,-7(a1)
  a20c0e:	fee78ca3          	sb	a4,-7(a5)
  a20c12:	ffa5c703          	lbu	a4,-6(a1)
  a20c16:	fee78d23          	sb	a4,-6(a5)
  a20c1a:	ffb5c703          	lbu	a4,-5(a1)
  a20c1e:	fee78da3          	sb	a4,-5(a5)
  a20c22:	ffc5c703          	lbu	a4,-4(a1)
  a20c26:	fee78e23          	sb	a4,-4(a5)
  a20c2a:	ffd5c703          	lbu	a4,-3(a1)
  a20c2e:	fee78ea3          	sb	a4,-3(a5)
  a20c32:	ffe5c703          	lbu	a4,-2(a1)
  a20c36:	fee78f23          	sb	a4,-2(a5)
  a20c3a:	fff5c703          	lbu	a4,-1(a1)
  a20c3e:	fee78fa3          	sb	a4,-1(a5)
  a20c42:	00467713          	andi	a4,a2,4
  a20c46:	c359                	beqz	a4,a20ccc <memcpy+0x1da>
  a20c48:	2198                	lbu	a4,0(a1)
  a20c4a:	0791                	addi	a5,a5,4
  a20c4c:	0591                	addi	a1,a1,4
  a20c4e:	fee78e23          	sb	a4,-4(a5)
  a20c52:	ffd5c703          	lbu	a4,-3(a1)
  a20c56:	fee78ea3          	sb	a4,-3(a5)
  a20c5a:	ffe5c703          	lbu	a4,-2(a1)
  a20c5e:	fee78f23          	sb	a4,-2(a5)
  a20c62:	fff5c703          	lbu	a4,-1(a1)
  a20c66:	fee78fa3          	sb	a4,-1(a5)
  a20c6a:	a08d                	j	a20ccc <memcpy+0x1da>
  a20c6c:	0585                	addi	a1,a1,1
  a20c6e:	fff5c703          	lbu	a4,-1(a1)
  a20c72:	0785                	addi	a5,a5,1
  a20c74:	167d                	addi	a2,a2,-1
  a20c76:	fee78fa3          	sb	a4,-1(a5)
  a20c7a:	bdad                	j	a20af4 <memcpy+0x2>
  a20c7c:	4194                	lw	a3,0(a1)
  a20c7e:	07c1                	addi	a5,a5,16
  a20c80:	05c1                	addi	a1,a1,16
  a20c82:	fed7a823          	sw	a3,-16(a5)
  a20c86:	ff45a683          	lw	a3,-12(a1)
  a20c8a:	1641                	addi	a2,a2,-16
  a20c8c:	fed7aa23          	sw	a3,-12(a5)
  a20c90:	ff85a683          	lw	a3,-8(a1)
  a20c94:	fed7ac23          	sw	a3,-8(a5)
  a20c98:	ffc5a683          	lw	a3,-4(a1)
  a20c9c:	fed7ae23          	sw	a3,-4(a5)
  a20ca0:	fcc76ee3          	bltu	a4,a2,a20c7c <memcpy+0x18a>
  a20ca4:	00867713          	andi	a4,a2,8
  a20ca8:	cb11                	beqz	a4,a20cbc <memcpy+0x1ca>
  a20caa:	4198                	lw	a4,0(a1)
  a20cac:	07a1                	addi	a5,a5,8
  a20cae:	05a1                	addi	a1,a1,8
  a20cb0:	fee7ac23          	sw	a4,-8(a5)
  a20cb4:	ffc5a703          	lw	a4,-4(a1)
  a20cb8:	fee7ae23          	sw	a4,-4(a5)
  a20cbc:	00467713          	andi	a4,a2,4
  a20cc0:	c711                	beqz	a4,a20ccc <memcpy+0x1da>
  a20cc2:	4198                	lw	a4,0(a1)
  a20cc4:	0791                	addi	a5,a5,4
  a20cc6:	0591                	addi	a1,a1,4
  a20cc8:	fee7ae23          	sw	a4,-4(a5)
  a20ccc:	00267713          	andi	a4,a2,2
  a20cd0:	cb11                	beqz	a4,a20ce4 <memcpy+0x1f2>
  a20cd2:	2198                	lbu	a4,0(a1)
  a20cd4:	0789                	addi	a5,a5,2
  a20cd6:	0589                	addi	a1,a1,2
  a20cd8:	fee78f23          	sb	a4,-2(a5)
  a20cdc:	fff5c703          	lbu	a4,-1(a1)
  a20ce0:	fee78fa3          	sb	a4,-1(a5)
  a20ce4:	8a05                	andi	a2,a2,1
  a20ce6:	c219                	beqz	a2,a20cec <memcpy+0x1fa>
  a20ce8:	2198                	lbu	a4,0(a1)
  a20cea:	a398                	sb	a4,0(a5)
  a20cec:	8082                	ret
  a20cee:	a394                	sb	a3,0(a5)
  a20cf0:	3194                	lbu	a3,1(a1)
  a20cf2:	1679                	addi	a2,a2,-2
  a20cf4:	0589                	addi	a1,a1,2
  a20cf6:	b394                	sb	a3,1(a5)
  a20cf8:	4e45                	li	t3,17
  a20cfa:	0789                	addi	a5,a5,2
  a20cfc:	0025a303          	lw	t1,2(a1)
  a20d00:	0065a883          	lw	a7,6(a1)
  a20d04:	1641                	addi	a2,a2,-16
  a20d06:	01031813          	slli	a6,t1,0x10
  a20d0a:	60e8271b          	orshf	a4,a6,a4,srl,16
  a20d0e:	00a5a803          	lw	a6,10(a1)
  a20d12:	c398                	sw	a4,0(a5)
  a20d14:	01089693          	slli	a3,a7,0x10
  a20d18:	01081713          	slli	a4,a6,0x10
  a20d1c:	6117271b          	orshf	a4,a4,a7,srl,16
  a20d20:	c798                	sw	a4,8(a5)
  a20d22:	00e5a703          	lw	a4,14(a1)
  a20d26:	6066a69b          	orshf	a3,a3,t1,srl,16
  a20d2a:	c3d4                	sw	a3,4(a5)
  a20d2c:	01071693          	slli	a3,a4,0x10
  a20d30:	6106a69b          	orshf	a3,a3,a6,srl,16
  a20d34:	c7d4                	sw	a3,12(a5)
  a20d36:	05c1                	addi	a1,a1,16
  a20d38:	07c1                	addi	a5,a5,16
  a20d3a:	fcce61e3          	bltu	t3,a2,a20cfc <memcpy+0x20a>
  a20d3e:	bd15                	j	a20b72 <memcpy+0x80>
  a20d40:	a394                	sb	a3,0(a5)
  a20d42:	0585                	addi	a1,a1,1
  a20d44:	167d                	addi	a2,a2,-1
  a20d46:	0785                	addi	a5,a5,1
  a20d48:	4e49                	li	t3,18
  a20d4a:	0035a303          	lw	t1,3(a1)
  a20d4e:	0075a883          	lw	a7,7(a1)
  a20d52:	1641                	addi	a2,a2,-16
  a20d54:	01831813          	slli	a6,t1,0x18
  a20d58:	50e8271b          	orshf	a4,a6,a4,srl,8
  a20d5c:	00b5a803          	lw	a6,11(a1)
  a20d60:	c398                	sw	a4,0(a5)
  a20d62:	01889693          	slli	a3,a7,0x18
  a20d66:	01881713          	slli	a4,a6,0x18
  a20d6a:	5117271b          	orshf	a4,a4,a7,srl,8
  a20d6e:	c798                	sw	a4,8(a5)
  a20d70:	00f5a703          	lw	a4,15(a1)
  a20d74:	5066a69b          	orshf	a3,a3,t1,srl,8
  a20d78:	c3d4                	sw	a3,4(a5)
  a20d7a:	01871693          	slli	a3,a4,0x18
  a20d7e:	5106a69b          	orshf	a3,a3,a6,srl,8
  a20d82:	c7d4                	sw	a3,12(a5)
  a20d84:	05c1                	addi	a1,a1,16
  a20d86:	07c1                	addi	a5,a5,16
  a20d88:	fcce61e3          	bltu	t3,a2,a20d4a <memcpy+0x258>
  a20d8c:	b3dd                	j	a20b72 <memcpy+0x80>

00a20d8e <memcmp>:
  a20d8e:	962a                	add	a2,a2,a0
  a20d90:	00c50c63          	beq	a0,a2,a20da8 <memcmp+0x1a>
  a20d94:	211c                	lbu	a5,0(a0)
  a20d96:	2198                	lbu	a4,0(a1)
  a20d98:	00e78563          	beq	a5,a4,a20da2 <memcmp+0x14>
  a20d9c:	40e78533          	sub	a0,a5,a4
  a20da0:	8082                	ret
  a20da2:	0505                	addi	a0,a0,1
  a20da4:	0585                	addi	a1,a1,1
  a20da6:	b7ed                	j	a20d90 <memcmp+0x2>
  a20da8:	4501                	li	a0,0
  a20daa:	8082                	ret

00a20dac <strlen>:
  a20dac:	87aa                	mv	a5,a0
  a20dae:	0037f713          	andi	a4,a5,3
  a20db2:	e31d                	bnez	a4,a20dd8 <strlen+0x2c>
  a20db4:	fefe feff 059f      	l.li	a1,0xfefefeff
  a20dba:	8080 8080 061f      	l.li	a2,0x80808080
  a20dc0:	4394                	lw	a3,0(a5)
  a20dc2:	00b68733          	add	a4,a3,a1
  a20dc6:	fff6c693          	not	a3,a3
  a20dca:	8f75                	and	a4,a4,a3
  a20dcc:	8f71                	and	a4,a4,a2
  a20dce:	cf01                	beqz	a4,a20de6 <strlen+0x3a>
  a20dd0:	2398                	lbu	a4,0(a5)
  a20dd2:	c709                	beqz	a4,a20ddc <strlen+0x30>
  a20dd4:	0785                	addi	a5,a5,1
  a20dd6:	bfed                	j	a20dd0 <strlen+0x24>
  a20dd8:	2398                	lbu	a4,0(a5)
  a20dda:	e701                	bnez	a4,a20de2 <strlen+0x36>
  a20ddc:	40a78533          	sub	a0,a5,a0
  a20de0:	8082                	ret
  a20de2:	0785                	addi	a5,a5,1
  a20de4:	b7e9                	j	a20dae <strlen+0x2>
  a20de6:	0791                	addi	a5,a5,4
  a20de8:	bfe1                	j	a20dc0 <strlen+0x14>

00a20dea <reset>:
  a20dea:	8018                	push	{ra},-16
  a20dec:	67d030ef          	jal	ra,a24c68 <update_reset_count>
  a20df0:	400027b7          	lui	a5,0x40002
  a20df4:	4711                	li	a4,4
  a20df6:	10e79823          	sh	a4,272(a5) # 40002110 <__data_load__+0x3f5da6dc>
  a20dfa:	a001                	j	a20dfa <reset+0x10>

00a20dfc <boot_get_flash_funcs>:
  a20dfc:	00a0 25d8 051f      	l.li	a0,0xa025d8
  a20e02:	8082                	ret

00a20e04 <boot_regist_flash_cmd>:
  a20e04:	8018                	push	{ra},-16
  a20e06:	862a                	mv	a2,a0
  a20e08:	46d1                	li	a3,20
  a20e0a:	45d1                	li	a1,20
  a20e0c:	00a0 25d8 051f      	l.li	a0,0xa025d8
  a20e12:	75a040ef          	jal	ra,a2556c <memcpy_s>
  a20e16:	c501                	beqz	a0,a20e1e <boot_regist_flash_cmd+0x1a>
  a20e18:	80000537          	lui	a0,0x80000
  a20e1c:	0511                	addi	a0,a0,4 # 80000004 <__data_load__+0x7f5d85d0>
  a20e1e:	8014                	popret	{ra},16

00a20e20 <upload_send_file_info>:
  a20e20:	8058                	push	{ra,s0-s3},-32
  a20e22:	00a0 25ec 079f      	l.li	a5,0xa025ec
  a20e28:	4380                	lw	s0,0(a5)
  a20e2a:	283c                	lbu	a5,18(s0)
  a20e2c:	01340913          	addi	s2,s0,19
  a20e30:	8bbd                	andi	a5,a5,15
  a20e32:	c799                	beqz	a5,a20e40 <upload_send_file_info+0x20>
  a20e34:	08500593          	li	a1,133
  a20e38:	854a                	mv	a0,s2
  a20e3a:	8050                	pop	{ra,s0-s3},32
  a20e3c:	4090306f          	j	a24a44 <serial_put_buf>
  a20e40:	40500693          	li	a3,1029
  a20e44:	4601                	li	a2,0
  a20e46:	40500593          	li	a1,1029
  a20e4a:	854a                	mv	a0,s2
  a20e4c:	4044                	lw	s1,4(s0)
  a20e4e:	756040ef          	jal	ra,a255a4 <memset_s>
  a20e52:	4785                	li	a5,1
  a20e54:	b83c                	sb	a5,19(s0)
  a20e56:	381c                	lbu	a5,17(s0)
  a20e58:	4410                	lw	a2,8(s0)
  a20e5a:	01640993          	addi	s3,s0,22
  a20e5e:	a85c                	sb	a5,20(s0)
  a20e60:	fff7c793          	not	a5,a5
  a20e64:	b85c                	sb	a5,21(s0)
  a20e66:	46ad                	li	a3,11
  a20e68:	08000593          	li	a1,128
  a20e6c:	854e                	mv	a0,s3
  a20e6e:	6fe040ef          	jal	ra,a2556c <memcpy_s>
  a20e72:	e529                	bnez	a0,a20ebc <upload_send_file_info+0x9c>
  a20e74:	02140793          	addi	a5,s0,33
  a20e78:	8726                	mv	a4,s1
  a20e7a:	86be                	mv	a3,a5
  a20e7c:	863e                	mv	a2,a5
  a20e7e:	4529                	li	a0,10
  a20e80:	40f605b3          	sub	a1,a2,a5
  a20e84:	02e04d63          	bgtz	a4,a20ebe <upload_send_file_info+0x9e>
  a20e88:	00b78733          	add	a4,a5,a1
  a20e8c:	82b7879b          	addshf	a5,a5,a1,sra,1
  a20e90:	177d                	addi	a4,a4,-1
  a20e92:	04f69063          	bne	a3,a5,a20ed2 <upload_send_file_info+0xb2>
  a20e96:	08000613          	li	a2,128
  a20e9a:	85ce                	mv	a1,s3
  a20e9c:	4501                	li	a0,0
  a20e9e:	227000ef          	jal	ra,a218c4 <crc16_ccitt>
  a20ea2:	00855793          	srli	a5,a0,0x8
  a20ea6:	08f40b23          	sb	a5,150(s0)
  a20eaa:	08a40ba3          	sb	a0,151(s0)
  a20eae:	08500593          	li	a1,133
  a20eb2:	854a                	mv	a0,s2
  a20eb4:	391030ef          	jal	ra,a24a44 <serial_put_buf>
  a20eb8:	4789                	li	a5,2
  a20eba:	a81c                	sb	a5,16(s0)
  a20ebc:	8054                	popret	{ra,s0-s3},32
  a20ebe:	02a765b3          	rem	a1,a4,a0
  a20ec2:	0605                	addi	a2,a2,1
  a20ec4:	03058593          	addi	a1,a1,48
  a20ec8:	feb60fa3          	sb	a1,-1(a2)
  a20ecc:	02a74733          	div	a4,a4,a0
  a20ed0:	bf45                	j	a20e80 <upload_send_file_info+0x60>
  a20ed2:	230c                	lbu	a1,0(a4)
  a20ed4:	2290                	lbu	a2,0(a3)
  a20ed6:	0685                	addi	a3,a3,1
  a20ed8:	feb68fa3          	sb	a1,-1(a3)
  a20edc:	a310                	sb	a2,0(a4)
  a20ede:	bf4d                	j	a20e90 <upload_send_file_info+0x70>

00a20ee0 <upload_send_data>:
  a20ee0:	8058                	push	{ra,s0-s3},-32
  a20ee2:	00a0 25ec 079f      	l.li	a5,0xa025ec
  a20ee8:	4380                	lw	s0,0(a5)
  a20eea:	283c                	lbu	a5,18(s0)
  a20eec:	01340913          	addi	s2,s0,19
  a20ef0:	8bbd                	andi	a5,a5,15
  a20ef2:	cf81                	beqz	a5,a20f0a <upload_send_data+0x2a>
  a20ef4:	383c                	lbu	a5,19(s0)
  a20ef6:	08500593          	li	a1,133
  a20efa:	0107823b          	beqi	a5,1,a20f02 <upload_send_data+0x22>
  a20efe:	40500593          	li	a1,1029
  a20f02:	854a                	mv	a0,s2
  a20f04:	8050                	pop	{ra,s0-s3},32
  a20f06:	33f0306f          	j	a24a44 <serial_put_buf>
  a20f0a:	445c                	lw	a5,12(s0)
  a20f0c:	4044                	lw	s1,4(s0)
  a20f0e:	4669                	li	a2,26
  a20f10:	40500693          	li	a3,1029
  a20f14:	8c9d                	sub	s1,s1,a5
  a20f16:	4795                	li	a5,5
  a20f18:	a81c                	sb	a5,16(s0)
  a20f1a:	40500593          	li	a1,1029
  a20f1e:	854a                	mv	a0,s2
  a20f20:	684040ef          	jal	ra,a255a4 <memset_s>
  a20f24:	4789                	li	a5,2
  a20f26:	b83c                	sb	a5,19(s0)
  a20f28:	381c                	lbu	a5,17(s0)
  a20f2a:	01640993          	addi	s3,s0,22
  a20f2e:	4010                	lw	a2,0(s0)
  a20f30:	0785                	addi	a5,a5,1
  a20f32:	9f81                	uxtb	a5
  a20f34:	b81c                	sb	a5,17(s0)
  a20f36:	a85c                	sb	a5,20(s0)
  a20f38:	fff7c793          	not	a5,a5
  a20f3c:	b85c                	sb	a5,21(s0)
  a20f3e:	445c                	lw	a5,12(s0)
  a20f40:	8114f13b          	bgeui	s1,129,a20f84 <upload_send_data+0xa4>
  a20f44:	4705                	li	a4,1
  a20f46:	b838                	sb	a4,19(s0)
  a20f48:	86a6                	mv	a3,s1
  a20f4a:	963e                	add	a2,a2,a5
  a20f4c:	08000593          	li	a1,128
  a20f50:	854e                	mv	a0,s3
  a20f52:	61a040ef          	jal	ra,a2556c <memcpy_s>
  a20f56:	e52d                	bnez	a0,a20fc0 <upload_send_data+0xe0>
  a20f58:	85ce                	mv	a1,s3
  a20f5a:	08000613          	li	a2,128
  a20f5e:	167000ef          	jal	ra,a218c4 <crc16_ccitt>
  a20f62:	00855793          	srli	a5,a0,0x8
  a20f66:	08f40b23          	sb	a5,150(s0)
  a20f6a:	08a40ba3          	sb	a0,151(s0)
  a20f6e:	08500593          	li	a1,133
  a20f72:	854a                	mv	a0,s2
  a20f74:	2d1030ef          	jal	ra,a24a44 <serial_put_buf>
  a20f78:	445c                	lw	a5,12(s0)
  a20f7a:	94be                	add	s1,s1,a5
  a20f7c:	c444                	sw	s1,12(s0)
  a20f7e:	8050                	pop	{ra,s0-s3},32
  a20f80:	4d10306f          	j	a24c50 <boot_wdt_kick>
  a20f84:	40000713          	li	a4,1024
  a20f88:	00977663          	bgeu	a4,s1,a20f94 <upload_send_data+0xb4>
  a20f8c:	4711                	li	a4,4
  a20f8e:	a818                	sb	a4,16(s0)
  a20f90:	40000493          	li	s1,1024
  a20f94:	86a6                	mv	a3,s1
  a20f96:	963e                	add	a2,a2,a5
  a20f98:	40000593          	li	a1,1024
  a20f9c:	854e                	mv	a0,s3
  a20f9e:	5ce040ef          	jal	ra,a2556c <memcpy_s>
  a20fa2:	ed19                	bnez	a0,a20fc0 <upload_send_data+0xe0>
  a20fa4:	85ce                	mv	a1,s3
  a20fa6:	40000613          	li	a2,1024
  a20faa:	11b000ef          	jal	ra,a218c4 <crc16_ccitt>
  a20fae:	00855793          	srli	a5,a0,0x8
  a20fb2:	40f40b23          	sb	a5,1046(s0)
  a20fb6:	40a40ba3          	sb	a0,1047(s0)
  a20fba:	40500593          	li	a1,1029
  a20fbe:	bf55                	j	a20f72 <upload_send_data+0x92>
  a20fc0:	8054                	popret	{ra,s0-s3},32

00a20fc2 <upload_send_null_info>:
  a20fc2:	8038                	push	{ra,s0-s1},-16
  a20fc4:	00a0 25ec 079f      	l.li	a5,0xa025ec
  a20fca:	4380                	lw	s0,0(a5)
  a20fcc:	08000693          	li	a3,128
  a20fd0:	4601                	li	a2,0
  a20fd2:	01340493          	addi	s1,s0,19
  a20fd6:	40500593          	li	a1,1029
  a20fda:	8526                	mv	a0,s1
  a20fdc:	5c8040ef          	jal	ra,a255a4 <memset_s>
  a20fe0:	4785                	li	a5,1
  a20fe2:	b83c                	sb	a5,19(s0)
  a20fe4:	57fd                	li	a5,-1
  a20fe6:	b85c                	sb	a5,21(s0)
  a20fe8:	08000613          	li	a2,128
  a20fec:	01640593          	addi	a1,s0,22
  a20ff0:	00040a23          	sb	zero,20(s0)
  a20ff4:	4501                	li	a0,0
  a20ff6:	0cf000ef          	jal	ra,a218c4 <crc16_ccitt>
  a20ffa:	00855793          	srli	a5,a0,0x8
  a20ffe:	08f40b23          	sb	a5,150(s0)
  a21002:	08a40ba3          	sb	a0,151(s0)
  a21006:	08500593          	li	a1,133
  a2100a:	8526                	mv	a0,s1
  a2100c:	239030ef          	jal	ra,a24a44 <serial_put_buf>
  a21010:	479d                	li	a5,7
  a21012:	a81c                	sb	a5,16(s0)
  a21014:	8034                	popret	{ra,s0-s1},16

00a21016 <download_image>:
  a21016:	8058                	push	{ra,s0-s3},-32
  a21018:	842e                	mv	s0,a1
  a2101a:	84aa                	mv	s1,a0
  a2101c:	89b2                	mv	s3,a2
  a2101e:	3bf9                	jal	ra,a20dfc <boot_get_flash_funcs>
  a21020:	892a                	mv	s2,a0
  a21022:	42f030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a21026:	ff1416bb          	bnei	s0,-1,a21080 <download_image+0x6a>
  a2102a:	5b7000ef          	jal	ra,a21de0 <loader_download_is_flash_all_erased>
  a2102e:	cd11                	beqz	a0,a2104a <download_image+0x34>
  a21030:	00c92783          	lw	a5,12(s2)
  a21034:	85a2                	mv	a1,s0
  a21036:	8526                	mv	a0,s1
  a21038:	9782                	jalr	a5
  a2103a:	cd11                	beqz	a0,a21056 <download_image+0x40>
  a2103c:	0000 3622 051f      	l.li	a0,0x3622
  a21042:	2ef030ef          	jal	ra,a24b30 <boot_put_errno>
  a21046:	557d                	li	a0,-1
  a21048:	8054                	popret	{ra,s0-s3},32
  a2104a:	00c92783          	lw	a5,12(s2)
  a2104e:	55fd                	li	a1,-1
  a21050:	9782                	jalr	a5
  a21052:	f56d                	bnez	a0,a2103c <download_image+0x26>
  a21054:	547d                	li	s0,-1
  a21056:	3fb030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a2105a:	00a2 68f0 051f      	l.li	a0,0xa268f0
  a21060:	2fb030ef          	jal	ra,a24b5a <boot_msg0>
  a21064:	05a00513          	li	a0,90
  a21068:	2cb1                	jal	ra,a212c4 <loader_ack>
  a2106a:	86ce                	mv	a3,s3
  a2106c:	4601                	li	a2,0
  a2106e:	85a2                	mv	a1,s0
  a21070:	8526                	mv	a0,s1
  a21072:	083000ef          	jal	ra,a218f4 <loader_serial_ymodem>
  a21076:	00a03533          	snez	a0,a0
  a2107a:	40a00533          	neg	a0,a0
  a2107e:	b7e9                	j	a21048 <download_image+0x32>
  a21080:	f845                	bnez	s0,a21030 <download_image+0x1a>
  a21082:	bfc9                	j	a21054 <download_image+0x3e>

00a21084 <download_factory_image>:
  a21084:	bf49                	j	a21016 <download_image>

00a21086 <upload_data>:
  a21086:	8198                	push	{ra,s0-s7},-64
  a21088:	00a02437          	lui	s0,0xa02
  a2108c:	5ec42783          	lw	a5,1516(s0) # a025ec <g_upload_ctx>
  a21090:	84aa                	mv	s1,a0
  a21092:	892e                	mv	s2,a1
  a21094:	5ec40413          	addi	s0,s0,1516
  a21098:	e791                	bnez	a5,a210a4 <upload_data+0x1e>
  a2109a:	41800513          	li	a0,1048
  a2109e:	4a3030ef          	jal	ra,a24d40 <boot_malloc>
  a210a2:	c008                	sw	a0,0(s0)
  a210a4:	4008                	lw	a0,0(s0)
  a210a6:	5bfd                	li	s7,-1
  a210a8:	c941                	beqz	a0,a21138 <upload_data+0xb2>
  a210aa:	41800693          	li	a3,1048
  a210ae:	4601                	li	a2,0
  a210b0:	41800593          	li	a1,1048
  a210b4:	4f0040ef          	jal	ra,a255a4 <memset_s>
  a210b8:	401c                	lw	a5,0(s0)
  a210ba:	00200737          	lui	a4,0x200
  a210be:	94ba                	add	s1,s1,a4
  a210c0:	c384                	sw	s1,0(a5)
  a210c2:	401c                	lw	a5,0(s0)
  a210c4:	00a2 6904 071f      	l.li	a4,0xa26904
  a210ca:	05a00513          	li	a0,90
  a210ce:	c798                	sw	a4,8(a5)
  a210d0:	4705                	li	a4,1
  a210d2:	0127a223          	sw	s2,4(a5)
  a210d6:	ab98                	sb	a4,16(a5)
  a210d8:	22f5                	jal	ra,a212c4 <loader_ack>
  a210da:	4000                	lw	s0,0(s0)
  a210dc:	0098 9680 049f      	l.li	s1,0x989680
  a210e2:	00a27937          	lui	s2,0xa27
  a210e6:	04300993          	li	s3,67
  a210ea:	8d890913          	addi	s2,s2,-1832 # a268d8 <__clz_tab+0x100>
  a210ee:	8a26                	mv	s4,s1
  a210f0:	001e 8480 0a9f      	l.li	s5,0x1e8480
  a210f6:	00f10593          	addi	a1,sp,15
  a210fa:	8526                	mv	a0,s1
  a210fc:	20d030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a21100:	8baa                	mv	s7,a0
  a21102:	f975                	bnez	a0,a210f6 <upload_data+0x70>
  a21104:	00f14b03          	lbu	s6,15(sp)
  a21108:	013b1d63          	bne	s6,s3,a21122 <upload_data+0x9c>
  a2110c:	281c                	lbu	a5,16(s0)
  a2110e:	00040923          	sb	zero,18(s0)
  a21112:	03178dbb          	beqi	a5,3,a21188 <upload_data+0x102>
  a21116:	062780bb          	beqi	a5,6,a21198 <upload_data+0x112>
  a2111a:	01f7973b          	bnei	a5,1,a210f6 <upload_data+0x70>
  a2111e:	3309                	jal	ra,a20e20 <upload_send_file_info>
  a21120:	bfd9                	j	a210f6 <upload_data+0x70>
  a21122:	060b1ebb          	bnei	s6,6,a2115c <upload_data+0xd6>
  a21126:	281c                	lbu	a5,16(s0)
  a21128:	00040923          	sb	zero,18(s0)
  a2112c:	0707943b          	bnei	a5,7,a2113c <upload_data+0xb6>
  a21130:	06400513          	li	a0,100
  a21134:	0c9030ef          	jal	ra,a249fc <mdelay>
  a21138:	855e                	mv	a0,s7
  a2113a:	8194                	popret	{ra,s0-s7},64
  a2113c:	0417833b          	beqi	a5,4,a21188 <upload_data+0x102>
  a21140:	0507843b          	beqi	a5,5,a21150 <upload_data+0xca>
  a21144:	02e79cbb          	bnei	a5,2,a210f6 <upload_data+0x70>
  a21148:	478d                	li	a5,3
  a2114a:	a81c                	sb	a5,16(s0)
  a2114c:	84d6                	mv	s1,s5
  a2114e:	b765                	j	a210f6 <upload_data+0x70>
  a21150:	4511                	li	a0,4
  a21152:	0af030ef          	jal	ra,a24a00 <serial_putc>
  a21156:	01640823          	sb	s6,16(s0)
  a2115a:	bf71                	j	a210f6 <upload_data+0x70>
  a2115c:	151b103b          	bnei	s6,21,a2119c <upload_data+0x116>
  a21160:	283c                	lbu	a5,18(s0)
  a21162:	8bbd                	andi	a5,a5,15
  a21164:	a83c                	sb	a5,18(s0)
  a21166:	283e                	lhu	a5,18(s0)
  a21168:	0785                	addi	a5,a5,1
  a2116a:	8bbd                	andi	a5,a5,15
  a2116c:	a83c                	sb	a5,18(s0)
  a2116e:	c7a9                	beqz	a5,a211b8 <upload_data+0x132>
  a21170:	281c                	lbu	a5,16(s0)
  a21172:	17f9                	addi	a5,a5,-2
  a21174:	9f81                	uxtb	a5
  a21176:	06e7f03b          	bgeui	a5,6,a210f6 <upload_data+0x70>
  a2117a:	04f9079b          	addshf	a5,s2,a5,sll,2
  a2117e:	439c                	lw	a5,0(a5)
  a21180:	8782                	jr	a5
  a21182:	3979                	jal	ra,a20e20 <upload_send_file_info>
  a21184:	84d2                	mv	s1,s4
  a21186:	bf85                	j	a210f6 <upload_data+0x70>
  a21188:	3ba1                	jal	ra,a20ee0 <upload_send_data>
  a2118a:	b7b5                	j	a210f6 <upload_data+0x70>
  a2118c:	4511                	li	a0,4
  a2118e:	073030ef          	jal	ra,a24a00 <serial_putc>
  a21192:	4799                	li	a5,6
  a21194:	a81c                	sb	a5,16(s0)
  a21196:	b785                	j	a210f6 <upload_data+0x70>
  a21198:	352d                	jal	ra,a20fc2 <upload_send_null_info>
  a2119a:	bfb1                	j	a210f6 <upload_data+0x70>
  a2119c:	18db16bb          	bnei	s6,24,a210f6 <upload_data+0x70>
  a211a0:	283c                	lbu	a5,18(s0)
  a211a2:	9bc1                	andi	a5,a5,-16
  a211a4:	a83c                	sb	a5,18(s0)
  a211a6:	481c                	lw	a5,16(s0)
  a211a8:	83d1                	srli	a5,a5,0x14
  a211aa:	0785                	addi	a5,a5,1
  a211ac:	8bbd                	andi	a5,a5,15
  a211ae:	00479713          	slli	a4,a5,0x4
  a211b2:	a838                	sb	a4,18(s0)
  a211b4:	03d790bb          	bnei	a5,3,a210f6 <upload_data+0x70>
  a211b8:	5bfd                	li	s7,-1
  a211ba:	bfbd                	j	a21138 <upload_data+0xb2>

00a211bc <loader_download_image>:
  a211bc:	8268                	push	{ra,s0-s4},-64
  a211be:	2d14                	lbu	a3,24(a0)
  a211c0:	01f10593          	addi	a1,sp,31
  a211c4:	892a                	mv	s2,a0
  a211c6:	c636                	sw	a3,12(sp)
  a211c8:	00c52a03          	lw	s4,12(a0)
  a211cc:	01052983          	lw	s3,16(a0)
  a211d0:	4944                	lw	s1,20(a0)
  a211d2:	00010fa3          	sb	zero,31(sp)
  a211d6:	415000ef          	jal	ra,a21dea <loader_erase_all_process>
  a211da:	842a                	mv	s0,a0
  a211dc:	46b2                	lw	a3,12(sp)
  a211de:	c909                	beqz	a0,a211f0 <loader_download_image+0x34>
  a211e0:	85aa                	mv	a1,a0
  a211e2:	00a2 698c 051f      	l.li	a0,0xa2698c
  a211e8:	185030ef          	jal	ra,a24b6c <boot_msg1>
  a211ec:	8522                	mv	a0,s0
  a211ee:	8264                	popret	{ra,s0-s4},64
  a211f0:	01f14783          	lbu	a5,31(sp)
  a211f4:	dfe5                	beqz	a5,a211ec <loader_download_image+0x30>
  a211f6:	00098963          	beqz	s3,a21208 <loader_download_image+0x4c>
  a211fa:	c099                	beqz	s1,a21200 <loader_download_image+0x44>
  a211fc:	0134e663          	bltu	s1,s3,a21208 <loader_download_image+0x4c>
  a21200:	004007b7          	lui	a5,0x400
  a21204:	0537f963          	bgeu	a5,s3,a21256 <loader_download_image+0x9a>
  a21208:	00a2 69a0 051f      	l.li	a0,0xa269a0
  a2120e:	14d030ef          	jal	ra,a24b5a <boot_msg0>
  a21212:	00a2 69b0 051f      	l.li	a0,0xa269b0
  a21218:	009030ef          	jal	ra,a24a20 <serial_puts>
  a2121c:	4585                	li	a1,1
  a2121e:	8552                	mv	a0,s4
  a21220:	085030ef          	jal	ra,a24aa4 <serial_puthex>
  a21224:	00a2 69c0 051f      	l.li	a0,0xa269c0
  a2122a:	7f6030ef          	jal	ra,a24a20 <serial_puts>
  a2122e:	4585                	li	a1,1
  a21230:	854e                	mv	a0,s3
  a21232:	073030ef          	jal	ra,a24aa4 <serial_puthex>
  a21236:	00a2 69cc 051f      	l.li	a0,0xa269cc
  a2123c:	7e4030ef          	jal	ra,a24a20 <serial_puts>
  a21240:	4585                	li	a1,1
  a21242:	8526                	mv	a0,s1
  a21244:	061030ef          	jal	ra,a24aa4 <serial_puthex>
  a21248:	00a2 7438 051f      	l.li	a0,0xa27438
  a2124e:	7d2030ef          	jal	ra,a24a20 <serial_puts>
  a21252:	547d                	li	s0,-1
  a21254:	bf61                	j	a211ec <loader_download_image+0x30>
  a21256:	00a94783          	lbu	a5,10(s2)
  a2125a:	00400637          	lui	a2,0x400
  a2125e:	85a6                	mv	a1,s1
  a21260:	8552                	mv	a0,s4
  a21262:	780792bb          	bnei	a5,120,a2126c <loader_download_image+0xb0>
  a21266:	3d39                	jal	ra,a21084 <download_factory_image>
  a21268:	842a                	mv	s0,a0
  a2126a:	b749                	j	a211ec <loader_download_image+0x30>
  a2126c:	336d                	jal	ra,a21016 <download_image>
  a2126e:	bfed                	j	a21268 <loader_download_image+0xac>

00a21270 <loader_upload_data>:
  a21270:	8018                	push	{ra},-16
  a21272:	454c                	lw	a1,12(a0)
  a21274:	004007b7          	lui	a5,0x400
  a21278:	fff58713          	addi	a4,a1,-1
  a2127c:	00f76963          	bltu	a4,a5,a2128e <loader_upload_data+0x1e>
  a21280:	00a2 69f0 051f      	l.li	a0,0xa269f0
  a21286:	0d5030ef          	jal	ra,a24b5a <boot_msg0>
  a2128a:	557d                	li	a0,-1
  a2128c:	8014                	popret	{ra},16
  a2128e:	4908                	lw	a0,16(a0)
  a21290:	00357713          	andi	a4,a0,3
  a21294:	c709                	beqz	a4,a2129e <loader_upload_data+0x2e>
  a21296:	00a2 6a04 051f      	l.li	a0,0xa26a04
  a2129c:	b7ed                	j	a21286 <loader_upload_data+0x16>
  a2129e:	00a58733          	add	a4,a1,a0
  a212a2:	00e7f663          	bgeu	a5,a4,a212ae <loader_upload_data+0x3e>
  a212a6:	00a2 6a18 051f      	l.li	a0,0xa26a18
  a212ac:	bfe9                	j	a21286 <loader_upload_data+0x16>
  a212ae:	8010                	pop	{ra},16
  a212b0:	bbd9                	j	a21086 <upload_data>

00a212b2 <loader_set_baudrate>:
  a212b2:	8018                	push	{ra},-16
  a212b4:	2db000ef          	jal	ra,a21d8e <uart_baudrate_rcv>
  a212b8:	c501                	beqz	a0,a212c0 <loader_set_baudrate+0xe>
  a212ba:	8010                	pop	{ra},16
  a212bc:	23b0006f          	j	a21cf6 <serial_port_set_baudrate>
  a212c0:	557d                	li	a0,-1
  a212c2:	8014                	popret	{ra},16

00a212c4 <loader_ack>:
  a212c4:	9f28                	push	{ra,s0},-512
  a212c6:	de010113          	addi	sp,sp,-544
  a212ca:	842a                	mv	s0,a0
  a212cc:	41000613          	li	a2,1040
  a212d0:	4581                	li	a1,0
  a212d2:	850a                	mv	a0,sp
  a212d4:	f70ff0ef          	jal	ra,a20a44 <memset>
  a212d8:	dead beef 079f      	l.li	a5,0xdeadbeef
  a212de:	4629                	li	a2,10
  a212e0:	c23e                	sw	a5,4(sp)
  a212e2:	00810623          	sb	s0,12(sp)
  a212e6:	1ee1 000c 079f      	l.li	a5,0x1ee1000c
  a212ec:	fff44413          	not	s0,s0
  a212f0:	004c                	addi	a1,sp,4
  a212f2:	4501                	li	a0,0
  a212f4:	c43e                	sw	a5,8(sp)
  a212f6:	008106a3          	sb	s0,13(sp)
  a212fa:	23e9                	jal	ra,a218c4 <crc16_ccitt>
  a212fc:	00815583          	lhu	a1,8(sp)
  a21300:	40a11623          	sh	a0,1036(sp)
  a21304:	0048                	addi	a0,sp,4
  a21306:	15f9                	addi	a1,a1,-2
  a21308:	73c030ef          	jal	ra,a24a44 <serial_put_buf>
  a2130c:	40c10513          	addi	a0,sp,1036
  a21310:	4589                	li	a1,2
  a21312:	732030ef          	jal	ra,a24a44 <serial_put_buf>
  a21316:	41010113          	addi	sp,sp,1040
  a2131a:	8024                	popret	{ra,s0},16

00a2131c <loader_reset>:
  a2131c:	8018                	push	{ra},-16
  a2131e:	00a2 69dc 051f      	l.li	a0,0xa269dc
  a21324:	037030ef          	jal	ra,a24b5a <boot_msg0>
  a21328:	05a00513          	li	a0,90
  a2132c:	3f61                	jal	ra,a212c4 <loader_ack>
  a2132e:	4515                	li	a0,5
  a21330:	6cc030ef          	jal	ra,a249fc <mdelay>
  a21334:	3c5d                	jal	ra,a20dea <reset>
  a21336:	4501                	li	a0,0
  a21338:	8014                	popret	{ra},16

00a2133a <cmd_loop>:
  a2133a:	8198                	push	{ra,s0-s7},-64
  a2133c:	842a                	mv	s0,a0
  a2133e:	001e 8480 099f      	l.li	s3,0x1e8480
  a21344:	dead beef 0a1f      	l.li	s4,0xdeadbeef
  a2134a:	00440913          	addi	s2,s0,4
  a2134e:	00040023          	sb	zero,0(s0)
  a21352:	00041123          	sh	zero,2(s0)
  a21356:	40c00693          	li	a3,1036
  a2135a:	4601                	li	a2,0
  a2135c:	40c00593          	li	a1,1036
  a21360:	854a                	mv	a0,s2
  a21362:	242040ef          	jal	ra,a255a4 <memset_s>
  a21366:	cd49                	beqz	a0,a21400 <cmd_loop+0xc6>
  a21368:	0a500513          	li	a0,165
  a2136c:	3fa1                	jal	ra,a212c4 <loader_ack>
  a2136e:	bff1                	j	a2134a <cmd_loop+0x10>
  a21370:	0e1030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a21374:	00b10593          	addi	a1,sp,11
  a21378:	854e                	mv	a0,s3
  a2137a:	78e030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a2137e:	8b2a                	mv	s6,a0
  a21380:	ed05                	bnez	a0,a213b8 <cmd_loop+0x7e>
  a21382:	0a85                	addi	s5,s5,1
  a21384:	0ac2                	slli	s5,s5,0x10
  a21386:	010ada93          	srli	s5,s5,0x10
  a2138a:	c489                	beqz	s1,a21394 <cmd_loop+0x5a>
  a2138c:	00042223          	sw	zero,4(s0)
  a21390:	00040023          	sb	zero,0(s0)
  a21394:	201c                	lbu	a5,0(s0)
  a21396:	00b14703          	lbu	a4,11(sp)
  a2139a:	0407fdbb          	bgeui	a5,4,a213d0 <cmd_loop+0x96>
  a2139e:	0814                	addi	a3,sp,16
  a213a0:	c652                	sw	s4,12(sp)
  a213a2:	96be                	add	a3,a3,a5
  a213a4:	ffc6c683          	lbu	a3,-4(a3)
  a213a8:	00e69b63          	bne	a3,a4,a213be <cmd_loop+0x84>
  a213ac:	97ca                	add	a5,a5,s2
  a213ae:	a394                	sb	a3,0(a5)
  a213b0:	201c                	lbu	a5,0(s0)
  a213b2:	0785                	addi	a5,a5,1 # 400001 <g_intheap_size+0x3e6aa1>
  a213b4:	a01c                	sb	a5,0(s0)
  a213b6:	4481                	li	s1,0
  a213b8:	fb7a9ce3          	bne	s5,s7,a21370 <cmd_loop+0x36>
  a213bc:	b775                	j	a21368 <cmd_loop+0x2e>
  a213be:	0ef00793          	li	a5,239
  a213c2:	4485                	li	s1,1
  a213c4:	fef71ae3          	bne	a4,a5,a213b8 <cmd_loop+0x7e>
  a213c8:	57bd                	li	a5,-17
  a213ca:	a05c                	sb	a5,4(s0)
  a213cc:	a004                	sb	s1,0(s0)
  a213ce:	b7e5                	j	a213b6 <cmd_loop+0x7c>
  a213d0:	97ca                	add	a5,a5,s2
  a213d2:	a398                	sb	a4,0(a5)
  a213d4:	201c                	lbu	a5,0(s0)
  a213d6:	c791                	beqz	a5,a213e2 <cmd_loop+0xa8>
  a213d8:	2416                	lhu	a3,8(s0)
  a213da:	40000713          	li	a4,1024
  a213de:	00d76f63          	bltu	a4,a3,a213fc <cmd_loop+0xc2>
  a213e2:	0785                	addi	a5,a5,1
  a213e4:	9f81                	uxtb	a5
  a213e6:	a01c                	sb	a5,0(s0)
  a213e8:	08f7e3bb          	bltui	a5,8,a213b6 <cmd_loop+0x7c>
  a213ec:	00041123          	sh	zero,2(s0)
  a213f0:	00c40493          	addi	s1,s0,12
  a213f4:	0001 86a0 0a9f      	l.li	s5,0x186a0
  a213fa:	a02d                	j	a21424 <cmd_loop+0xea>
  a213fc:	4485                	li	s1,1
  a213fe:	bf6d                	j	a213b8 <cmd_loop+0x7e>
  a21400:	4a81                	li	s5,0
  a21402:	4481                	li	s1,0
  a21404:	06500b93          	li	s7,101
  a21408:	bf45                	j	a213b8 <cmd_loop+0x7e>
  a2140a:	006c                	addi	a1,sp,12
  a2140c:	8556                	mv	a0,s5
  a2140e:	6fa030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a21412:	f939                	bnez	a0,a21368 <cmd_loop+0x2e>
  a21414:	203e                	lhu	a5,2(s0)
  a21416:	00178713          	addi	a4,a5,1
  a2141a:	a03a                	sh	a4,2(s0)
  a2141c:	00c14703          	lbu	a4,12(sp)
  a21420:	97a6                	add	a5,a5,s1
  a21422:	a398                	sb	a4,0(a5)
  a21424:	241e                	lhu	a5,8(s0)
  a21426:	2036                	lhu	a3,2(s0)
  a21428:	ff878713          	addi	a4,a5,-8
  a2142c:	fce6efe3          	bltu	a3,a4,a2140a <cmd_loop+0xd0>
  a21430:	ff778713          	addi	a4,a5,-9
  a21434:	9726                	add	a4,a4,s1
  a21436:	97a6                	add	a5,a5,s1
  a21438:	2314                	lbu	a3,0(a4)
  a2143a:	ff67c783          	lbu	a5,-10(a5)
  a2143e:	10d7a79b          	orshf	a5,a5,a3,sll,8
  a21442:	40f41623          	sh	a5,1036(s0)
  a21446:	00070023          	sb	zero,0(a4) # 200000 <g_intheap_size+0x1e6aa0>
  a2144a:	241e                	lhu	a5,8(s0)
  a2144c:	94be                	add	s1,s1,a5
  a2144e:	fe048b23          	sb	zero,-10(s1)
  a21452:	2412                	lhu	a2,8(s0)
  a21454:	203a                	lhu	a4,2(s0)
  a21456:	ff860793          	addi	a5,a2,-8 # 3ffff8 <g_intheap_size+0x3e6a98>
  a2145a:	f0f717e3          	bne	a4,a5,a21368 <cmd_loop+0x2e>
  a2145e:	1679                	addi	a2,a2,-2
  a21460:	85ca                	mv	a1,s2
  a21462:	4501                	li	a0,0
  a21464:	2185                	jal	ra,a218c4 <crc16_ccitt>
  a21466:	40c45783          	lhu	a5,1036(s0)
  a2146a:	eea79fe3          	bne	a5,a0,a21368 <cmd_loop+0x2e>
  a2146e:	242c                	lbu	a1,10(s0)
  a21470:	00a2 6954 079f      	l.li	a5,0xa26954
  a21476:	469d                	li	a3,7
  a21478:	2398                	lbu	a4,0(a5)
  a2147a:	02b71863          	bne	a4,a1,a214aa <cmd_loop+0x170>
  a2147e:	43d8                	lw	a4,4(a5)
  a21480:	c70d                	beqz	a4,a214aa <cmd_loop+0x170>
  a21482:	8522                	mv	a0,s0
  a21484:	9702                	jalr	a4
  a21486:	ee0511e3          	bnez	a0,a21368 <cmd_loop+0x2e>
  a2148a:	7c6030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a2148e:	05a00513          	li	a0,90
  a21492:	3d0d                	jal	ra,a212c4 <loader_ack>
  a21494:	00a2 6920 051f      	l.li	a0,0xa26920
  a2149a:	6c0030ef          	jal	ra,a24b5a <boot_msg0>
  a2149e:	00a2 6938 051f      	l.li	a0,0xa26938
  a214a4:	6b6030ef          	jal	ra,a24b5a <boot_msg0>
  a214a8:	b54d                	j	a2134a <cmd_loop+0x10>
  a214aa:	0b05                	addi	s6,s6,1
  a214ac:	07a1                	addi	a5,a5,8
  a214ae:	fcdb15e3          	bne	s6,a3,a21478 <cmd_loop+0x13e>
  a214b2:	00a2 6910 051f      	l.li	a0,0xa26910
  a214b8:	6b4030ef          	jal	ra,a24b6c <boot_msg1>
  a214bc:	b575                	j	a21368 <cmd_loop+0x2e>

00a214be <ymodem_flush>:
  a214be:	8148                	push	{ra,s0-s2},-32
  a214c0:	597d                	li	s2,-1
  a214c2:	000f 4240 049f      	l.li	s1,0xf4240
  a214c8:	547d                	li	s0,-1
  a214ca:	00f10593          	addi	a1,sp,15
  a214ce:	8526                	mv	a0,s1
  a214d0:	012107a3          	sb	s2,15(sp)
  a214d4:	634030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a214d8:	fe8519e3          	bne	a0,s0,a214ca <ymodem_flush+0xc>
  a214dc:	8144                	popret	{ra,s0-s2},32

00a214de <ymodem_get_packet>:
  a214de:	81c8                	push	{ra,s0-s10},-64
  a214e0:	57fd                	li	a5,-1
  a214e2:	00a02437          	lui	s0,0xa02
  a214e6:	00f105a3          	sb	a5,11(sp)
  a214ea:	00f10623          	sb	a5,12(sp)
  a214ee:	00f106a3          	sb	a5,13(sp)
  a214f2:	00f10723          	sb	a5,14(sp)
  a214f6:	6709                	lui	a4,0x2
  a214f8:	5f040793          	addi	a5,s0,1520 # a025f0 <g_ymodem>
  a214fc:	97ba                	add	a5,a5,a4
  a214fe:	33dc                	lbu	a5,5(a5)
  a21500:	00a04a37          	lui	s4,0xa04
  a21504:	5f040413          	addi	s0,s0,1520
  a21508:	5f0a0a13          	addi	s4,s4,1520 # a045f0 <_gp_+0x1914>
  a2150c:	c791                	beqz	a5,a21518 <ymodem_get_packet+0x3a>
  a2150e:	4519                	li	a0,6
  a21510:	4f0030ef          	jal	ra,a24a00 <serial_putc>
  a21514:	000a02a3          	sb	zero,5(s4)
  a21518:	57fd                	li	a5,-1
  a2151a:	00f107a3          	sb	a5,15(sp)
  a2151e:	4901                	li	s2,0
  a21520:	4481                	li	s1,0
  a21522:	000f 4240 0b1f      	l.li	s6,0xf4240
  a21528:	49a9                	li	s3,10
  a2152a:	4ab1                	li	s5,12
  a2152c:	4be1                	li	s7,24
  a2152e:	4c0d                	li	s8,3
  a21530:	4c89                	li	s9,2
  a21532:	4d11                	li	s10,4
  a21534:	00f10593          	addi	a1,sp,15
  a21538:	855a                	mv	a0,s6
  a2153a:	5ce030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a2153e:	c909                	beqz	a0,a21550 <ymodem_get_packet+0x72>
  a21540:	3fbd                	jal	ra,a214be <ymodem_flush>
  a21542:	4551                	li	a0,20
  a21544:	4b8030ef          	jal	ra,a249fc <mdelay>
  a21548:	c35a 69a6 049f      	l.li	s1,0xc35a69a6
  a2154e:	a8d5                	j	a21642 <ymodem_get_packet+0x164>
  a21550:	00f14783          	lbu	a5,15(sp)
  a21554:	0485                	addi	s1,s1,1
  a21556:	0d378663          	beq	a5,s3,a21622 <ymodem_get_packet+0x144>
  a2155a:	0af9e463          	bltu	s3,a5,a21602 <ymodem_get_packet+0x124>
  a2155e:	0b978f63          	beq	a5,s9,a2161c <ymodem_get_packet+0x13e>
  a21562:	0da78863          	beq	a5,s10,a21632 <ymodem_get_packet+0x154>
  a21566:	01f793bb          	bnei	a5,1,a21534 <ymodem_get_packet+0x56>
  a2156a:	08000793          	li	a5,128
  a2156e:	000f49b7          	lui	s3,0xf4
  a21572:	00d10593          	addi	a1,sp,13
  a21576:	24098513          	addi	a0,s3,576 # f4240 <g_intheap_size+0xdace0>
  a2157a:	c01c                	sw	a5,0(s0)
  a2157c:	597d                	li	s2,-1
  a2157e:	58a030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a21582:	fd2503e3          	beq	a0,s2,a21548 <ymodem_get_packet+0x6a>
  a21586:	00e10593          	addi	a1,sp,14
  a2158a:	24098513          	addi	a0,s3,576
  a2158e:	57a030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a21592:	fb250be3          	beq	a0,s2,a21548 <ymodem_get_packet+0x6a>
  a21596:	450d                	li	a0,3
  a21598:	460030ef          	jal	ra,a249f8 <udelay>
  a2159c:	400c                	lw	a1,0(s0)
  a2159e:	00a02ab7          	lui	s5,0xa02
  a215a2:	5f4a8513          	addi	a0,s5,1524 # a025f4 <g_ymodem+0x4>
  a215a6:	4d2030ef          	jal	ra,a24a78 <serial_gets>
  a215aa:	84aa                	mv	s1,a0
  a215ac:	fd51                	bnez	a0,a21548 <ymodem_get_packet+0x6a>
  a215ae:	006c                	addi	a1,sp,12
  a215b0:	24098513          	addi	a0,s3,576
  a215b4:	554030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a215b8:	f92508e3          	beq	a0,s2,a21548 <ymodem_get_packet+0x6a>
  a215bc:	00b10593          	addi	a1,sp,11
  a215c0:	24098513          	addi	a0,s3,576
  a215c4:	544030ef          	jal	ra,a24b08 <serial_getc_timeout>
  a215c8:	f92500e3          	beq	a0,s2,a21548 <ymodem_get_packet+0x6a>
  a215cc:	00e14703          	lbu	a4,14(sp)
  a215d0:	00d14783          	lbu	a5,13(sp)
  a215d4:	8fb9                	xor	a5,a5,a4
  a215d6:	0ff00713          	li	a4,255
  a215da:	06e79663          	bne	a5,a4,a21646 <ymodem_get_packet+0x168>
  a215de:	4010                	lw	a2,0(s0)
  a215e0:	5f4a8593          	addi	a1,s5,1524
  a215e4:	4501                	li	a0,0
  a215e6:	2cf9                	jal	ra,a218c4 <crc16_ccitt>
  a215e8:	00c14703          	lbu	a4,12(sp)
  a215ec:	00b14783          	lbu	a5,11(sp)
  a215f0:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a215f4:	04a79d63          	bne	a5,a0,a2164e <ymodem_get_packet+0x170>
  a215f8:	00d14783          	lbu	a5,13(sp)
  a215fc:	00fa0323          	sb	a5,6(s4)
  a21600:	a089                	j	a21642 <ymodem_get_packet+0x164>
  a21602:	03578663          	beq	a5,s5,a2162e <ymodem_get_packet+0x150>
  a21606:	0357e263          	bltu	a5,s5,a2162a <ymodem_get_packet+0x14c>
  a2160a:	f37795e3          	bne	a5,s7,a21534 <ymodem_get_packet+0x56>
  a2160e:	0905                	addi	s2,s2,1
  a21610:	f38912e3          	bne	s2,s8,a21534 <ymodem_get_packet+0x56>
  a21614:	c35a 69a7 049f      	l.li	s1,0xc35a69a7
  a2161a:	a025                	j	a21642 <ymodem_get_packet+0x164>
  a2161c:	40000793          	li	a5,1024
  a21620:	b7b9                	j	a2156e <ymodem_get_packet+0x90>
  a21622:	0000 0800 079f      	l.li	a5,0x800
  a21628:	b799                	j	a2156e <ymodem_get_packet+0x90>
  a2162a:	6785                	lui	a5,0x1
  a2162c:	b789                	j	a2156e <ymodem_get_packet+0x90>
  a2162e:	6789                	lui	a5,0x2
  a21630:	bf3d                	j	a2156e <ymodem_get_packet+0x90>
  a21632:	01c490bb          	bnei	s1,1,a21534 <ymodem_get_packet+0x56>
  a21636:	4519                	li	a0,6
  a21638:	3c8030ef          	jal	ra,a24a00 <serial_putc>
  a2163c:	c35a 69aa 049f      	l.li	s1,0xc35a69aa
  a21642:	8526                	mv	a0,s1
  a21644:	81c4                	popret	{ra,s0-s10},64
  a21646:	c35a 69a8 049f      	l.li	s1,0xc35a69a8
  a2164c:	bfdd                	j	a21642 <ymodem_get_packet+0x164>
  a2164e:	c35a 69a9 049f      	l.li	s1,0xc35a69a9
  a21654:	b7fd                	j	a21642 <ymodem_get_packet+0x164>

00a21656 <ymodem_open>:
  a21656:	8088                	push	{ra,s0-s6},-32
  a21658:	00a02937          	lui	s2,0xa02
  a2165c:	5f090793          	addi	a5,s2,1520 # a025f0 <g_ymodem>
  a21660:	6709                	lui	a4,0x2
  a21662:	0007a023          	sw	zero,0(a5) # 2000 <ccause+0x103e>
  a21666:	04300513          	li	a0,67
  a2166a:	97ba                	add	a5,a5,a4
  a2166c:	0007a423          	sw	zero,8(a5)
  a21670:	0007a623          	sw	zero,12(a5)
  a21674:	000782a3          	sb	zero,5(a5)
  a21678:	00078223          	sb	zero,4(a5)
  a2167c:	384030ef          	jal	ra,a24a00 <serial_putc>
  a21680:	5d0030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a21684:	c35a77b7          	lui	a5,0xc35a7
  a21688:	00a04437          	lui	s0,0xa04
  a2168c:	4a51                	li	s4,20
  a2168e:	5f090913          	addi	s2,s2,1520
  a21692:	5f040413          	addi	s0,s0,1520 # a045f0 <_gp_+0x1914>
  a21696:	5afd                	li	s5,-1
  a21698:	9a778b13          	addi	s6,a5,-1625 # c35a69a7 <__data_load__+0xc2b7ef73>
  a2169c:	9a678993          	addi	s3,a5,-1626
  a216a0:	1a7d                	addi	s4,s4,-1
  a216a2:	015a1563          	bne	s4,s5,a216ac <ymodem_open+0x56>
  a216a6:	54fd                	li	s1,-1
  a216a8:	8526                	mv	a0,s1
  a216aa:	8084                	popret	{ra,s0-s6},32
  a216ac:	3d0d                	jal	ra,a214de <ymodem_get_packet>
  a216ae:	84aa                	mv	s1,a0
  a216b0:	ed61                	bnez	a0,a21788 <ymodem_open+0x132>
  a216b2:	207c                	lbu	a5,6(s0)
  a216b4:	ef9d                	bnez	a5,a216f2 <ymodem_open+0x9c>
  a216b6:	450d                	li	a0,3
  a216b8:	340030ef          	jal	ra,a249f8 <udelay>
  a216bc:	00a027b7          	lui	a5,0xa02
  a216c0:	5f478793          	addi	a5,a5,1524 # a025f4 <g_ymodem+0x4>
  a216c4:	08590693          	addi	a3,s2,133
  a216c8:	0785                	addi	a5,a5,1
  a216ca:	fff7c703          	lbu	a4,-1(a5)
  a216ce:	c319                	beqz	a4,a216d4 <ymodem_open+0x7e>
  a216d0:	fed79ce3          	bne	a5,a3,a216c8 <ymodem_open+0x72>
  a216d4:	08000613          	li	a2,128
  a216d8:	02000693          	li	a3,32
  a216dc:	a019                	j	a216e2 <ymodem_open+0x8c>
  a216de:	0785                	addi	a5,a5,1
  a216e0:	167d                	addi	a2,a2,-1
  a216e2:	2398                	lbu	a4,0(a5)
  a216e4:	00d71c63          	bne	a4,a3,a216fc <ymodem_open+0xa6>
  a216e8:	fa7d                	bnez	a2,a216de <ymodem_open+0x88>
  a216ea:	00042423          	sw	zero,8(s0)
  a216ee:	4785                	li	a5,1
  a216f0:	b05c                	sb	a5,5(s0)
  a216f2:	4785                	li	a5,1
  a216f4:	b07c                	sb	a5,7(s0)
  a216f6:	00092023          	sw	zero,0(s2)
  a216fa:	b77d                	j	a216a8 <ymodem_open+0x52>
  a216fc:	4829                	li	a6,10
  a216fe:	3007163b          	bnei	a4,48,a21716 <ymodem_open+0xc0>
  a21702:	3398                	lbu	a4,1(a5)
  a21704:	0df77713          	andi	a4,a4,223
  a21708:	580713bb          	bnei	a4,88,a21716 <ymodem_open+0xc0>
  a2170c:	020662bb          	bltui	a2,2,a21716 <ymodem_open+0xc0>
  a21710:	0789                	addi	a5,a5,2
  a21712:	1679                	addi	a2,a2,-2
  a21714:	4841                	li	a6,16
  a21716:	4581                	li	a1,0
  a21718:	4325                	li	t1,9
  a2171a:	4895                	li	a7,5
  a2171c:	a801                	j	a2172c <ymodem_open+0xd6>
  a2171e:	fd068713          	addi	a4,a3,-48
  a21722:	00e86563          	bltu	a6,a4,a2172c <ymodem_open+0xd6>
  a21726:	02b805b3          	mul	a1,a6,a1
  a2172a:	95ba                	add	a1,a1,a4
  a2172c:	2398                	lbu	a4,0(a5)
  a2172e:	e705                	bnez	a4,a21756 <ymodem_open+0x100>
  a21730:	c40c                	sw	a1,8(s0)
  a21732:	010007b7          	lui	a5,0x1000
  a21736:	fab7fce3          	bgeu	a5,a1,a216ee <ymodem_open+0x98>
  a2173a:	c35a 69ac 049f      	l.li	s1,0xc35a69ac
  a21740:	b7a5                	j	a216a8 <ymodem_open+0x52>
  a21742:	fbf70713          	addi	a4,a4,-65 # 1fbf <ccause+0xffd>
  a21746:	9f01                	uxtb	a4
  a21748:	00e8e563          	bltu	a7,a4,a21752 <ymodem_open+0xfc>
  a2174c:	fc968713          	addi	a4,a3,-55
  a21750:	bfc9                	j	a21722 <ymodem_open+0xcc>
  a21752:	4701                	li	a4,0
  a21754:	bfc9                	j	a21726 <ymodem_open+0xd0>
  a21756:	de69                	beqz	a2,a21730 <ymodem_open+0xda>
  a21758:	fd070513          	addi	a0,a4,-48
  a2175c:	01871693          	slli	a3,a4,0x18
  a21760:	9d01                	uxtb	a0
  a21762:	0785                	addi	a5,a5,1 # 1000001 <__data_load__+0x5d85cd>
  a21764:	86e1                	srai	a3,a3,0x18
  a21766:	faa37ce3          	bgeu	t1,a0,a2171e <ymodem_open+0xc8>
  a2176a:	fdf77513          	andi	a0,a4,-33
  a2176e:	fbf50513          	addi	a0,a0,-65
  a21772:	9d01                	uxtb	a0
  a21774:	f2a8e9e3          	bltu	a7,a0,a216a6 <ymodem_open+0x50>
  a21778:	f9f70513          	addi	a0,a4,-97
  a2177c:	9d01                	uxtb	a0
  a2177e:	fca8e2e3          	bltu	a7,a0,a21742 <ymodem_open+0xec>
  a21782:	fa968713          	addi	a4,a3,-87
  a21786:	bf71                	j	a21722 <ymodem_open+0xcc>
  a21788:	f1650fe3          	beq	a0,s6,a216a6 <ymodem_open+0x50>
  a2178c:	f1351ae3          	bne	a0,s3,a216a0 <ymodem_open+0x4a>
  a21790:	4c0030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a21794:	4551                	li	a0,20
  a21796:	266030ef          	jal	ra,a249fc <mdelay>
  a2179a:	04300513          	li	a0,67
  a2179e:	262030ef          	jal	ra,a24a00 <serial_putc>
  a217a2:	bdfd                	j	a216a0 <ymodem_open+0x4a>

00a217a4 <ymodem_close>:
  a217a4:	8028                	push	{ra,s0},-16
  a217a6:	00a02437          	lui	s0,0xa02
  a217aa:	49444503          	lbu	a0,1172(s0) # a02494 <g_hiburn_uart>
  a217ae:	148010ef          	jal	ra,a228f6 <uapi_uart_rx_fifo_is_empty>
  a217b2:	e501                	bnez	a0,a217ba <ymodem_close+0x16>
  a217b4:	2aa030ef          	jal	ra,a24a5e <serial_getc>
  a217b8:	bfcd                	j	a217aa <ymodem_close+0x6>
  a217ba:	8024                	popret	{ra,s0},16

00a217bc <ymodem_read>:
  a217bc:	80d8                	push	{ra,s0-s11},-64
  a217be:	c35a7bb7          	lui	s7,0xc35a7
  a217c2:	00a0 25f0 091f      	l.li	s2,0xa025f0
  a217c8:	6b09                	lui	s6,0x2
  a217ca:	00a04437          	lui	s0,0xa04
  a217ce:	8aaa                	mv	s5,a0
  a217d0:	84ae                	mv	s1,a1
  a217d2:	4a01                	li	s4,0
  a217d4:	9b4a                	add	s6,s6,s2
  a217d6:	5f040413          	addi	s0,s0,1520 # a045f0 <_gp_+0x1914>
  a217da:	9a7b8c93          	addi	s9,s7,-1625 # c35a69a7 <__data_load__+0xc2b7ef73>
  a217de:	9aab8d13          	addi	s10,s7,-1622
  a217e2:	004b4783          	lbu	a5,4(s6) # 2004 <ccause+0x1042>
  a217e6:	ebdd                	bnez	a5,a2189c <ymodem_read+0xe0>
  a217e8:	c8d5                	beqz	s1,a2189c <ymodem_read+0xe0>
  a217ea:	00092783          	lw	a5,0(s2)
  a217ee:	ef9d                	bnez	a5,a2182c <ymodem_read+0x70>
  a217f0:	4c55                	li	s8,21
  a217f2:	59fd                	li	s3,-1
  a217f4:	9abb8d93          	addi	s11,s7,-1621
  a217f8:	a885                	j	a21868 <ymodem_read+0xac>
  a217fa:	31d5                	jal	ra,a214de <ymodem_get_packet>
  a217fc:	89aa                	mv	s3,a0
  a217fe:	e93d                	bnez	a0,a21874 <ymodem_read+0xb8>
  a21800:	2078                	lbu	a4,6(s0)
  a21802:	307c                	lbu	a5,7(s0)
  a21804:	04f71a63          	bne	a4,a5,a21858 <ymodem_read+0x9c>
  a21808:	4785                	li	a5,1
  a2180a:	0705                	addi	a4,a4,1
  a2180c:	b05c                	sb	a5,5(s0)
  a2180e:	b078                	sb	a4,7(s0)
  a21810:	00092783          	lw	a5,0(s2)
  a21814:	4458                	lw	a4,12(s0)
  a21816:	4414                	lw	a3,8(s0)
  a21818:	973e                	add	a4,a4,a5
  a2181a:	c458                	sw	a4,12(s0)
  a2181c:	00e6f663          	bgeu	a3,a4,a21828 <ymodem_read+0x6c>
  a21820:	97b6                	add	a5,a5,a3
  a21822:	8f99                	sub	a5,a5,a4
  a21824:	00f92023          	sw	a5,0(s2)
  a21828:	205c                	lbu	a5,4(s0)
  a2182a:	ffc5                	bnez	a5,a217e2 <ymodem_read+0x26>
  a2182c:	00092983          	lw	s3,0(s2)
  a21830:	0134f363          	bgeu	s1,s3,a21836 <ymodem_read+0x7a>
  a21834:	89a6                	mv	s3,s1
  a21836:	00a02637          	lui	a2,0xa02
  a2183a:	86ce                	mv	a3,s3
  a2183c:	5f460613          	addi	a2,a2,1524 # a025f4 <g_ymodem+0x4>
  a21840:	85a6                	mv	a1,s1
  a21842:	8556                	mv	a0,s5
  a21844:	529030ef          	jal	ra,a2556c <memcpy_s>
  a21848:	e52d                	bnez	a0,a218b2 <ymodem_read+0xf6>
  a2184a:	413484b3          	sub	s1,s1,s3
  a2184e:	9ace                	add	s5,s5,s3
  a21850:	9a4e                	add	s4,s4,s3
  a21852:	00092023          	sw	zero,0(s2)
  a21856:	b771                	j	a217e2 <ymodem_read+0x26>
  a21858:	17fd                	addi	a5,a5,-1
  a2185a:	0ff7f793          	andi	a5,a5,255
  a2185e:	04f71163          	bne	a4,a5,a218a0 <ymodem_read+0xe4>
  a21862:	4519                	li	a0,6
  a21864:	19c030ef          	jal	ra,a24a00 <serial_putc>
  a21868:	1c7d                	addi	s8,s8,-1
  a2186a:	f80c18e3          	bnez	s8,a217fa <ymodem_read+0x3e>
  a2186e:	fa098de3          	beqz	s3,a21828 <ymodem_read+0x6c>
  a21872:	a02d                	j	a2189c <ymodem_read+0xe0>
  a21874:	03950463          	beq	a0,s9,a2189c <ymodem_read+0xe0>
  a21878:	03a51563          	bne	a0,s10,a218a2 <ymodem_read+0xe6>
  a2187c:	4519                	li	a0,6
  a2187e:	182030ef          	jal	ra,a24a00 <serial_putc>
  a21882:	04300513          	li	a0,67
  a21886:	17a030ef          	jal	ra,a24a00 <serial_putc>
  a2188a:	3991                	jal	ra,a214de <ymodem_get_packet>
  a2188c:	89aa                	mv	s3,a0
  a2188e:	4519                	li	a0,6
  a21890:	170030ef          	jal	ra,a24a00 <serial_putc>
  a21894:	4785                	li	a5,1
  a21896:	a05c                	sb	a5,4(s0)
  a21898:	f40985e3          	beqz	s3,a217e2 <ymodem_read+0x26>
  a2189c:	8552                	mv	a0,s4
  a2189e:	80d4                	popret	{ra,s0-s11},64
  a218a0:	89ee                	mv	s3,s11
  a218a2:	3931                	jal	ra,a214be <ymodem_flush>
  a218a4:	04300513          	li	a0,67
  a218a8:	158030ef          	jal	ra,a24a00 <serial_putc>
  a218ac:	3a4030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a218b0:	bf65                	j	a21868 <ymodem_read+0xac>
  a218b2:	5a7d                	li	s4,-1
  a218b4:	b7e5                	j	a2189c <ymodem_read+0xe0>

00a218b6 <ymodem_get_length>:
  a218b6:	6709                	lui	a4,0x2
  a218b8:	00a0 25f0 079f      	l.li	a5,0xa025f0
  a218be:	97ba                	add	a5,a5,a4
  a218c0:	4788                	lw	a0,8(a5)
  a218c2:	8082                	ret

00a218c4 <crc16_ccitt>:
  a218c4:	4781                	li	a5,0
  a218c6:	c989                	beqz	a1,a218d8 <crc16_ccitt+0x14>
  a218c8:	ca01                	beqz	a2,a218d8 <crc16_ccitt+0x14>
  a218ca:	962e                	add	a2,a2,a1
  a218cc:	87aa                	mv	a5,a0
  a218ce:	00a2 6a3c 069f      	l.li	a3,0xa26a3c
  a218d4:	00c59463          	bne	a1,a2,a218dc <crc16_ccitt+0x18>
  a218d8:	853e                	mv	a0,a5
  a218da:	8082                	ret
  a218dc:	0585                	addi	a1,a1,1
  a218de:	fff5c703          	lbu	a4,-1(a1)
  a218e2:	50f7371b          	xorshf	a4,a4,a5,srl,8
  a218e6:	02e6871b          	addshf	a4,a3,a4,sll,1
  a218ea:	230a                	lhu	a0,0(a4)
  a218ec:	10f5379b          	xorshf	a5,a0,a5,sll,8
  a218f0:	9fa1                	uxth	a5
  a218f2:	b7cd                	j	a218d4 <crc16_ccitt+0x10>

00a218f4 <loader_serial_ymodem>:
  a218f4:	8098                	push	{ra,s0-s7},-48
  a218f6:	8aaa                	mv	s5,a0
  a218f8:	892e                	mv	s2,a1
  a218fa:	8a32                	mv	s4,a2
  a218fc:	8436                	mv	s0,a3
  a218fe:	3ba1                	jal	ra,a21656 <ymodem_open>
  a21900:	e90d                	bnez	a0,a21932 <loader_serial_ymodem+0x3e>
  a21902:	89aa                	mv	s3,a0
  a21904:	3f4d                	jal	ra,a218b6 <ymodem_get_length>
  a21906:	84aa                	mv	s1,a0
  a21908:	00aa7463          	bgeu	s4,a0,a21910 <loader_serial_ymodem+0x1c>
  a2190c:	00a47963          	bgeu	s0,a0,a2191e <loader_serial_ymodem+0x2a>
  a21910:	85a6                	mv	a1,s1
  a21912:	00a2 6c3c 051f      	l.li	a0,0xa26c3c
  a21918:	254030ef          	jal	ra,a24b6c <boot_msg1>
  a2191c:	a819                	j	a21932 <loader_serial_ymodem+0x3e>
  a2191e:	842a                	mv	s0,a0
  a21920:	06090d63          	beqz	s2,a2199a <loader_serial_ymodem+0xa6>
  a21924:	06a97b63          	bgeu	s2,a0,a2199a <loader_serial_ymodem+0xa6>
  a21928:	00a2 6c50 051f      	l.li	a0,0xa26c50
  a2192e:	22c030ef          	jal	ra,a24b5a <boot_msg0>
  a21932:	3d8d                	jal	ra,a217a4 <ymodem_close>
  a21934:	547d                	li	s0,-1
  a21936:	a085                	j	a21996 <loader_serial_ymodem+0xa2>
  a21938:	85a2                	mv	a1,s0
  a2193a:	008b7363          	bgeu	s6,s0,a21940 <loader_serial_ymodem+0x4c>
  a2193e:	6589                	lui	a1,0x2
  a21940:	600a0513          	addi	a0,s4,1536
  a21944:	3da5                	jal	ra,a217bc <ymodem_read>
  a21946:	892a                	mv	s2,a0
  a21948:	d56d                	beqz	a0,a21932 <loader_serial_ymodem+0x3e>
  a2194a:	fea464e3          	bltu	s0,a0,a21932 <loader_serial_ymodem+0x3e>
  a2194e:	caeff0ef          	jal	ra,a20dfc <boot_get_flash_funcs>
  a21952:	451c                	lw	a5,8(a0)
  a21954:	85ca                	mv	a1,s2
  a21956:	4681                	li	a3,0
  a21958:	600a0613          	addi	a2,s4,1536
  a2195c:	017a8533          	add	a0,s5,s7
  a21960:	9782                	jalr	a5
  a21962:	85aa                	mv	a1,a0
  a21964:	c509                	beqz	a0,a2196e <loader_serial_ymodem+0x7a>
  a21966:	00a2 6c68 051f      	l.li	a0,0xa26c68
  a2196c:	b775                	j	a21918 <loader_serial_ymodem+0x24>
  a2196e:	41240433          	sub	s0,s0,s2
  a21972:	99ca                	add	s3,s3,s2
  a21974:	9aca                	add	s5,s5,s2
  a21976:	2da030ef          	jal	ra,a24c50 <boot_wdt_kick>
  a2197a:	fc5d                	bnez	s0,a21938 <loader_serial_ymodem+0x44>
  a2197c:	6589                	lui	a1,0x2
  a2197e:	600a0513          	addi	a0,s4,1536
  a21982:	3d2d                	jal	ra,a217bc <ymodem_read>
  a21984:	fb3497e3          	bne	s1,s3,a21932 <loader_serial_ymodem+0x3e>
  a21988:	85a6                	mv	a1,s1
  a2198a:	00a2 6c7c 051f      	l.li	a0,0xa26c7c
  a21990:	1dc030ef          	jal	ra,a24b6c <boot_msg1>
  a21994:	3d01                	jal	ra,a217a4 <ymodem_close>
  a21996:	8522                	mv	a0,s0
  a21998:	8094                	popret	{ra,s0-s7},48
  a2199a:	00a04a37          	lui	s4,0xa04
  a2199e:	6b09                	lui	s6,0x2
  a219a0:	ffe00bb7          	lui	s7,0xffe00
  a219a4:	bfd9                	j	a2197a <loader_serial_ymodem+0x86>

00a219a6 <loader_burn_efuse>:
  a219a6:	83d8                	push	{ra,s0-s11},-112
  a219a8:	4540                	lw	s0,12(a0)
  a219aa:	4f700793          	li	a5,1271
  a219ae:	fcf40713          	addi	a4,s0,-49
  a219b2:	00e7fa63          	bgeu	a5,a4,a219c6 <loader_burn_efuse+0x20>
  a219b6:	85a2                	mv	a1,s0
  a219b8:	00a2 6c88 051f      	l.li	a0,0xa26c88
  a219be:	1ae030ef          	jal	ra,a24b6c <boot_msg1>
  a219c2:	5bfd                	li	s7,-1
  a219c4:	a02d                	j	a219ee <loader_burn_efuse+0x48>
  a219c6:	05a00513          	li	a0,90
  a219ca:	8fbff0ef          	jal	ra,a212c4 <loader_ack>
  a219ce:	52800693          	li	a3,1320
  a219d2:	03000613          	li	a2,48
  a219d6:	4581                	li	a1,0
  a219d8:	00a30537          	lui	a0,0xa30
  a219dc:	3f21                	jal	ra,a218f4 <loader_serial_ymodem>
  a219de:	8baa                	mv	s7,a0
  a219e0:	c909                	beqz	a0,a219f2 <loader_burn_efuse+0x4c>
  a219e2:	85aa                	mv	a1,a0
  a219e4:	00a2 6ca0 051f      	l.li	a0,0xa26ca0
  a219ea:	182030ef          	jal	ra,a24b6c <boot_msg1>
  a219ee:	855e                	mv	a0,s7
  a219f0:	83d4                	popret	{ra,s0-s11},112
  a219f2:	4581                	li	a1,0
  a219f4:	02000613          	li	a2,32
  a219f8:	0808                	addi	a0,sp,16
  a219fa:	84aff0ef          	jal	ra,a20a44 <memset>
  a219fe:	0a1000ef          	jal	ra,a2229e <drv_rom_cipher_init>
  a21a02:	85aa                	mv	a1,a0
  a21a04:	cd01                	beqz	a0,a21a1c <loader_burn_efuse+0x76>
  a21a06:	00a2 6cbc 051f      	l.li	a0,0xa26cbc
  a21a0c:	160030ef          	jal	ra,a24b6c <boot_msg1>
  a21a10:	00a2 6d54 051f      	l.li	a0,0xa26d54
  a21a16:	144030ef          	jal	ra,a24b5a <boot_msg0>
  a21a1a:	b765                	j	a219c2 <loader_burn_efuse+0x1c>
  a21a1c:	fe040593          	addi	a1,s0,-32
  a21a20:	00a30437          	lui	s0,0xa30
  a21a24:	02000693          	li	a3,32
  a21a28:	0810                	addi	a2,sp,16
  a21a2a:	02040513          	addi	a0,s0,32 # a30020 <__data_load__+0x85ec>
  a21a2e:	03f000ef          	jal	ra,a2226c <drv_rom_cipher_sha256>
  a21a32:	85aa                	mv	a1,a0
  a21a34:	c509                	beqz	a0,a21a3e <loader_burn_efuse+0x98>
  a21a36:	00a2 6cdc 051f      	l.li	a0,0xa26cdc
  a21a3c:	bfc1                	j	a21a0c <loader_burn_efuse+0x66>
  a21a3e:	08b000ef          	jal	ra,a222c8 <drv_rom_cipher_deinit>
  a21a42:	8baa                	mv	s7,a0
  a21a44:	c511                	beqz	a0,a21a50 <loader_burn_efuse+0xaa>
  a21a46:	85aa                	mv	a1,a0
  a21a48:	00a2 6d00 051f      	l.li	a0,0xa26d00
  a21a4e:	bf7d                	j	a21a0c <loader_burn_efuse+0x66>
  a21a50:	02000613          	li	a2,32
  a21a54:	080c                	addi	a1,sp,16
  a21a56:	00a30537          	lui	a0,0xa30
  a21a5a:	b34ff0ef          	jal	ra,a20d8e <memcmp>
  a21a5e:	c519                	beqz	a0,a21a6c <loader_burn_efuse+0xc6>
  a21a60:	00a2 6d24 051f      	l.li	a0,0xa26d24
  a21a66:	0f4030ef          	jal	ra,a24b5a <boot_msg0>
  a21a6a:	b75d                	j	a21a10 <loader_burn_efuse+0x6a>
  a21a6c:	303e                	lhu	a5,34(s0)
  a21a6e:	1407e33b          	bltui	a5,20,a21a7a <loader_burn_efuse+0xd4>
  a21a72:	00a2 6d3c 051f      	l.li	a0,0xa26d3c
  a21a78:	b7fd                	j	a21a66 <loader_burn_efuse+0xc0>
  a21a7a:	02144783          	lbu	a5,33(s0)
  a21a7e:	4c81                	li	s9,0
  a21a80:	00a30ab7          	lui	s5,0xa30
  a21a84:	943e                	add	s0,s0,a5
  a21a86:	4b05                	li	s6,1
  a21a88:	00a27a37          	lui	s4,0xa27
  a21a8c:	00a279b7          	lui	s3,0xa27
  a21a90:	00a27937          	lui	s2,0xa27
  a21a94:	00a274b7          	lui	s1,0xa27
  a21a98:	022ad783          	lhu	a5,34(s5) # a30022 <__data_load__+0x85ee>
  a21a9c:	f4fcf9e3          	bgeu	s9,a5,a219ee <loader_burn_efuse+0x48>
  a21aa0:	f20401e3          	beqz	s0,a219c2 <loader_burn_efuse+0x1c>
  a21aa4:	00245d83          	lhu	s11,2(s0)
  a21aa8:	00445d03          	lhu	s10,4(s0)
  a21aac:	00840713          	addi	a4,s0,8
  a21ab0:	8c6e                	mv	s8,s11
  a21ab2:	9d6e                	add	s10,s10,s11
  a21ab4:	41bc07b3          	sub	a5,s8,s11
  a21ab8:	9fa1                	uxth	a5
  a21aba:	01ac4a63          	blt	s8,s10,a21ace <loader_burn_efuse+0x128>
  a21abe:	301c                	lbu	a5,1(s0)
  a21ac0:	207a                	lhu	a4,6(s0)
  a21ac2:	0c85                	addi	s9,s9,1
  a21ac4:	0ffcfc93          	andi	s9,s9,255
  a21ac8:	97ba                	add	a5,a5,a4
  a21aca:	943e                	add	s0,s0,a5
  a21acc:	b7f1                	j	a21a98 <loader_burn_efuse+0xf2>
  a21ace:	46f7069b          	addshf	a3,a4,a5,srl,3
  a21ad2:	2294                	lbu	a3,0(a3)
  a21ad4:	8b9d                	andi	a5,a5,7
  a21ad6:	00fb17b3          	sll	a5,s6,a5
  a21ada:	8ff5                	and	a5,a5,a3
  a21adc:	e791                	bnez	a5,a21ae8 <loader_burn_efuse+0x142>
  a21ade:	0c05                	addi	s8,s8,1
  a21ae0:	0c42                	slli	s8,s8,0x10
  a21ae2:	010c5c13          	srli	s8,s8,0x10
  a21ae6:	b7f9                	j	a21ab4 <loader_burn_efuse+0x10e>
  a21ae8:	007c7593          	andi	a1,s8,7
  a21aec:	003c5513          	srli	a0,s8,0x3
  a21af0:	c63a                	sw	a4,12(sp)
  a21af2:	024010ef          	jal	ra,a22b16 <uapi_efuse_write_bit>
  a21af6:	4732                	lw	a4,12(sp)
  a21af8:	d17d                	beqz	a0,a21ade <loader_burn_efuse+0x138>
  a21afa:	85e6                	mv	a1,s9
  a21afc:	d70a0513          	addi	a0,s4,-656 # a26d70 <g_crc16_tab+0x334>
  a21b00:	06c030ef          	jal	ra,a24b6c <boot_msg1>
  a21b04:	d8c98513          	addi	a0,s3,-628 # a26d8c <g_crc16_tab+0x350>
  a21b08:	719020ef          	jal	ra,a24a20 <serial_puts>
  a21b0c:	202a                	lhu	a0,2(s0)
  a21b0e:	4585                	li	a1,1
  a21b10:	795020ef          	jal	ra,a24aa4 <serial_puthex>
  a21b14:	d9890513          	addi	a0,s2,-616 # a26d98 <g_crc16_tab+0x35c>
  a21b18:	709020ef          	jal	ra,a24a20 <serial_puts>
  a21b1c:	204a                	lhu	a0,4(s0)
  a21b1e:	4585                	li	a1,1
  a21b20:	785020ef          	jal	ra,a24aa4 <serial_puthex>
  a21b24:	e5848513          	addi	a0,s1,-424 # a26e58 <sfc_cfg+0x98>
  a21b28:	6f9020ef          	jal	ra,a24a20 <serial_puts>
  a21b2c:	bf49                	j	a21abe <loader_burn_efuse+0x118>

00a21b2e <loader_read_efuse>:
  a21b2e:	8258                	push	{ra,s0-s3},-64
  a21b30:	2542                	lhu	s0,12(a0)
  a21b32:	02000613          	li	a2,32
  a21b36:	4581                	li	a1,0
  a21b38:	850a                	mv	a0,sp
  a21b3a:	f0bfe0ef          	jal	ra,a20a44 <memset>
  a21b3e:	00a2 6da4 051f      	l.li	a0,0xa26da4
  a21b44:	016030ef          	jal	ra,a24b5a <boot_msg0>
  a21b48:	00a2 6d8c 051f      	l.li	a0,0xa26d8c
  a21b4e:	6d3020ef          	jal	ra,a24a20 <serial_puts>
  a21b52:	8522                	mv	a0,s0
  a21b54:	4585                	li	a1,1
  a21b56:	74f020ef          	jal	ra,a24aa4 <serial_puthex>
  a21b5a:	00a2 7438 051f      	l.li	a0,0xa27438
  a21b60:	6c1020ef          	jal	ra,a24a20 <serial_puts>
  a21b64:	130464bb          	bltui	s0,19,a21b76 <loader_read_efuse+0x48>
  a21b68:	00a2 6db0 051f      	l.li	a0,0xa26db0
  a21b6e:	7ed020ef          	jal	ra,a24b5a <boot_msg0>
  a21b72:	547d                	li	s0,-1
  a21b74:	a825                	j	a21bac <loader_read_efuse+0x7e>
  a21b76:	0ff47513          	andi	a0,s0,255
  a21b7a:	02000613          	li	a2,32
  a21b7e:	858a                	mv	a1,sp
  a21b80:	515020ef          	jal	ra,a24894 <efuse_read_item>
  a21b84:	842a                	mv	s0,a0
  a21b86:	f575                	bnez	a0,a21b72 <loader_read_efuse+0x44>
  a21b88:	4481                	li	s1,0
  a21b8a:	00a279b7          	lui	s3,0xa27
  a21b8e:	02000913          	li	s2,32
  a21b92:	009107b3          	add	a5,sp,s1
  a21b96:	2388                	lbu	a0,0(a5)
  a21b98:	4585                	li	a1,1
  a21b9a:	0485                	addi	s1,s1,1
  a21b9c:	709020ef          	jal	ra,a24aa4 <serial_puthex>
  a21ba0:	dbc98513          	addi	a0,s3,-580 # a26dbc <g_crc16_tab+0x380>
  a21ba4:	67d020ef          	jal	ra,a24a20 <serial_puts>
  a21ba8:	ff2495e3          	bne	s1,s2,a21b92 <loader_read_efuse+0x64>
  a21bac:	8522                	mv	a0,s0
  a21bae:	8254                	popret	{ra,s0-s3},64

00a21bb0 <sfc_flash_read>:
  a21bb0:	87b2                	mv	a5,a2
  a21bb2:	862e                	mv	a2,a1
  a21bb4:	85be                	mv	a1,a5
  a21bb6:	1630206f          	j	a24518 <uapi_sfc_reg_read>

00a21bba <sfc_flash_init>:
  a21bba:	00a2 6dc0 051f      	l.li	a0,0xa26dc0
  a21bc0:	0af0206f          	j	a2446e <uapi_sfc_init>

00a21bc4 <sfc_flash_erase>:
  a21bc4:	ff05923b          	bnei	a1,-1,a21bcc <sfc_flash_erase+0x8>
  a21bc8:	3e10206f          	j	a247a8 <uapi_sfc_reg_erase_chip>
  a21bcc:	ffe007b7          	lui	a5,0xffe00
  a21bd0:	953e                	add	a0,a0,a5
  a21bd2:	3190206f          	j	a246ea <uapi_sfc_reg_erase>

00a21bd6 <sfc_flash_write>:
  a21bd6:	00b508b3          	add	a7,a0,a1
  a21bda:	00800837          	lui	a6,0x800
  a21bde:	86ae                	mv	a3,a1
  a21be0:	0108f763          	bgeu	a7,a6,a21bee <sfc_flash_write+0x18>
  a21be4:	8732                	mv	a4,a2
  a21be6:	862e                	mv	a2,a1
  a21be8:	85ba                	mv	a1,a4
  a21bea:	2030206f          	j	a245ec <uapi_sfc_reg_write>
  a21bee:	8018                	push	{ra},-16
  a21bf0:	87aa                	mv	a5,a0
  a21bf2:	00200537          	lui	a0,0x200
  a21bf6:	953e                	add	a0,a0,a5
  a21bf8:	175030ef          	jal	ra,a2556c <memcpy_s>
  a21bfc:	00a03533          	snez	a0,a0
  a21c00:	40a00533          	neg	a0,a0
  a21c04:	8014                	popret	{ra},16

00a21c06 <start_loaderboot>:
  a21c06:	9f18                	push	{ra},-512
  a21c08:	db010113          	addi	sp,sp,-592
  a21c0c:	41000613          	li	a2,1040
  a21c10:	4581                	li	a1,0
  a21c12:	1808                	addi	a0,sp,48
  a21c14:	e31fe0ef          	jal	ra,a20a44 <memset>
  a21c18:	50b020ef          	jal	ra,a24922 <boot_clock_adapt>
  a21c1c:	04100513          	li	a0,65
  a21c20:	505000ef          	jal	ra,a22924 <uapi_watchdog_init>
  a21c24:	4501                	li	a0,0
  a21c26:	551000ef          	jal	ra,a22976 <uapi_watchdog_enable>
  a21c2a:	704000ef          	jal	ra,a2232e <uapi_tcxo_init>
  a21c2e:	4631                	li	a2,12
  a21c30:	00a0 6a94 059f      	l.li	a1,0xa06a94
  a21c36:	850a                	mv	a0,sp
  a21c38:	ebbfe0ef          	jal	ra,a20af2 <memcpy>
  a21c3c:	4581                	li	a1,0
  a21c3e:	850a                	mv	a0,sp
  a21c40:	77b020ef          	jal	ra,a24bba <hiburn_uart_init>
  a21c44:	00a2 6dcc 051f      	l.li	a0,0xa26dcc
  a21c4a:	711020ef          	jal	ra,a24b5a <boot_msg0>
  a21c4e:	00a2 1bba 079f      	l.li	a5,0xa21bba
  a21c54:	ce3e                	sw	a5,28(sp)
  a21c56:	00a2 1bb0 079f      	l.li	a5,0xa21bb0
  a21c5c:	d03e                	sw	a5,32(sp)
  a21c5e:	00a2 1bd6 079f      	l.li	a5,0xa21bd6
  a21c64:	d23e                	sw	a5,36(sp)
  a21c66:	0868                	addi	a0,sp,28
  a21c68:	00a2 1bc4 079f      	l.li	a5,0xa21bc4
  a21c6e:	d43e                	sw	a5,40(sp)
  a21c70:	d602                	sw	zero,44(sp)
  a21c72:	992ff0ef          	jal	ra,a20e04 <boot_regist_flash_cmd>
  a21c76:	40003737          	lui	a4,0x40003
  a21c7a:	15472783          	lw	a5,340(a4) # 40003154 <__data_load__+0x3f5db720>
  a21c7e:	010006b7          	lui	a3,0x1000
  a21c82:	4515                	li	a0,5
  a21c84:	8fd5                	or	a5,a5,a3
  a21c86:	14f72a23          	sw	a5,340(a4)
  a21c8a:	573020ef          	jal	ra,a249fc <mdelay>
  a21c8e:	3735                	jal	ra,a21bba <sfc_flash_init>
  a21c90:	c931                	beqz	a0,a21ce4 <start_loaderboot+0xde>
  a21c92:	85aa                	mv	a1,a0
  a21c94:	00a2 6de8 051f      	l.li	a0,0xa26de8
  a21c9a:	6d3020ef          	jal	ra,a24b6c <boot_msg1>
  a21c9e:	4c9020ef          	jal	ra,a24966 <switch_flash_clock_to_pll>
  a21ca2:	4f1020ef          	jal	ra,a24992 <config_sfc_ctrl_ds>
  a21ca6:	5d6020ef          	jal	ra,a2427c <sfc_port_fix_sr>
  a21caa:	85aa                	mv	a1,a0
  a21cac:	c511                	beqz	a0,a21cb8 <start_loaderboot+0xb2>
  a21cae:	00a2 6e14 051f      	l.li	a0,0xa26e14
  a21cb4:	6b9020ef          	jal	ra,a24b6c <boot_msg1>
  a21cb8:	3eb020ef          	jal	ra,a248a2 <set_efuse_period>
  a21cbc:	59b000ef          	jal	ra,a22a56 <uapi_efuse_init>
  a21cc0:	07c030ef          	jal	ra,a24d3c <boot_malloc_init>
  a21cc4:	7df020ef          	jal	ra,a24ca2 <check_chip_type>
  a21cc8:	e505                	bnez	a0,a21cf0 <start_loaderboot+0xea>
  a21cca:	05a00513          	li	a0,90
  a21cce:	df6ff0ef          	jal	ra,a212c4 <loader_ack>
  a21cd2:	00a2 6e28 051f      	l.li	a0,0xa26e28
  a21cd8:	683020ef          	jal	ra,a24b5a <boot_msg0>
  a21cdc:	1808                	addi	a0,sp,48
  a21cde:	e5cff0ef          	jal	ra,a2133a <cmd_loop>
  a21ce2:	a001                	j	a21ce2 <start_loaderboot+0xdc>
  a21ce4:	00a2 6e00 051f      	l.li	a0,0xa26e00
  a21cea:	671020ef          	jal	ra,a24b5a <boot_msg0>
  a21cee:	bf45                	j	a21c9e <start_loaderboot+0x98>
  a21cf0:	44010113          	addi	sp,sp,1088
  a21cf4:	8014                	popret	{ra},16

00a21cf6 <serial_port_set_baudrate>:
  a21cf6:	8128                	push	{ra,s0},-32
  a21cf8:	842a                	mv	s0,a0
  a21cfa:	73d020ef          	jal	ra,a24c36 <hiburn_uart_deinit>
  a21cfe:	440017b7          	lui	a5,0x44001
  a21d02:	1047a703          	lw	a4,260(a5) # 44001104 <__data_load__+0x435d96d0>
  a21d06:	fffb ffff 069f      	l.li	a3,0xfffbffff
  a21d0c:	0989 6800 059f      	l.li	a1,0x9896800
  a21d12:	8f75                	and	a4,a4,a3
  a21d14:	10e7a223          	sw	a4,260(a5)
  a21d18:	1347a703          	lw	a4,308(a5)
  a21d1c:	000406b7          	lui	a3,0x40
  a21d20:	4501                	li	a0,0
  a21d22:	00276713          	ori	a4,a4,2
  a21d26:	12e7aa23          	sw	a4,308(a5)
  a21d2a:	1047a703          	lw	a4,260(a5)
  a21d2e:	8f55                	or	a4,a4,a3
  a21d30:	10e7a223          	sw	a4,260(a5)
  a21d34:	2a2020ef          	jal	ra,a23fd6 <uart_port_set_clock_value>
  a21d38:	4631                	li	a2,12
  a21d3a:	85a2                	mv	a1,s0
  a21d3c:	850a                	mv	a0,sp
  a21d3e:	db5fe0ef          	jal	ra,a20af2 <memcpy>
  a21d42:	850a                	mv	a0,sp
  a21d44:	4581                	li	a1,0
  a21d46:	675020ef          	jal	ra,a24bba <hiburn_uart_init>
  a21d4a:	4501                	li	a0,0
  a21d4c:	8124                	popret	{ra,s0},32

00a21d4e <uart_ack>:
  a21d4e:	8038                	push	{ra,s0-s1},-16
  a21d50:	dead beef 079f      	l.li	a5,0xdeadbeef
  a21d56:	c15c                	sw	a5,4(a0)
  a21d58:	1ee1 000c 079f      	l.li	a5,0x1ee1000c
  a21d5e:	00450493          	addi	s1,a0,4 # 200004 <g_intheap_size+0x1e6aa4>
  a21d62:	c51c                	sw	a5,8(a0)
  a21d64:	05a00793          	li	a5,90
  a21d68:	842a                	mv	s0,a0
  a21d6a:	a55e                	sh	a5,12(a0)
  a21d6c:	4629                	li	a2,10
  a21d6e:	85a6                	mv	a1,s1
  a21d70:	4501                	li	a0,0
  a21d72:	3e89                	jal	ra,a218c4 <crc16_ccitt>
  a21d74:	240e                	lhu	a1,8(s0)
  a21d76:	40a41623          	sh	a0,1036(s0)
  a21d7a:	8526                	mv	a0,s1
  a21d7c:	15f9                	addi	a1,a1,-2 # 1ffe <ccause+0x103c>
  a21d7e:	4c7020ef          	jal	ra,a24a44 <serial_put_buf>
  a21d82:	4589                	li	a1,2
  a21d84:	40c40513          	addi	a0,s0,1036
  a21d88:	8030                	pop	{ra,s0-s1},16
  a21d8a:	4bb0206f          	j	a24a44 <serial_put_buf>

00a21d8e <uart_baudrate_rcv>:
  a21d8e:	9f38                	push	{ra,s0-s1},-512
  a21d90:	de010113          	addi	sp,sp,-544
  a21d94:	84aa                	mv	s1,a0
  a21d96:	41000613          	li	a2,1040
  a21d9a:	4581                	li	a1,0
  a21d9c:	850a                	mv	a0,sp
  a21d9e:	ca7fe0ef          	jal	ra,a20a44 <memset>
  a21da2:	449c                	lw	a5,8(s1)
  a21da4:	00ff ffff 071f      	l.li	a4,0xffffff
  a21daa:	4501                	li	a0,0
  a21dac:	8ff9                	and	a5,a5,a4
  a21dae:	005a 0012 071f      	l.li	a4,0x5a0012
  a21db4:	02e79363          	bne	a5,a4,a21dda <uart_baudrate_rcv+0x4c>
  a21db8:	00a06437          	lui	s0,0xa06
  a21dbc:	46a1                	li	a3,8
  a21dbe:	00c48613          	addi	a2,s1,12
  a21dc2:	45b1                	li	a1,12
  a21dc4:	60040513          	addi	a0,s0,1536 # a06600 <g_uart_param>
  a21dc8:	7a4030ef          	jal	ra,a2556c <memcpy_s>
  a21dcc:	850a                	mv	a0,sp
  a21dce:	3741                	jal	ra,a21d4e <uart_ack>
  a21dd0:	4515                	li	a0,5
  a21dd2:	42b020ef          	jal	ra,a249fc <mdelay>
  a21dd6:	60040513          	addi	a0,s0,1536
  a21dda:	41010113          	addi	sp,sp,1040
  a21dde:	8034                	popret	{ra,s0-s1},16

00a21de0 <loader_download_is_flash_all_erased>:
  a21de0:	00a0 660c 079f      	l.li	a5,0xa0660c
  a21de6:	2388                	lbu	a0,0(a5)
  a21de8:	8082                	ret

00a21dea <loader_erase_all_process>:
  a21dea:	2538                	lbu	a4,10(a0)
  a21dec:	0d200793          	li	a5,210
  a21df0:	00f70663          	beq	a4,a5,a21dfc <loader_erase_all_process+0x12>
  a21df4:	557d                	li	a0,-1
  a21df6:	8082                	ret
  a21df8:	557d                	li	a0,-1
  a21dfa:	8134                	popret	{ra,s0-s1},32
  a21dfc:	8138                	push	{ra,s0-s1},-32
  a21dfe:	4904                	lw	s1,16(a0)
  a21e00:	495c                	lw	a5,20(a0)
  a21e02:	842e                	mv	s0,a1
  a21e04:	009034b3          	snez	s1,s1
  a21e08:	ff0799bb          	bnei	a5,-1,a21e2e <loader_erase_all_process+0x44>
  a21e0c:	ff1fe0ef          	jal	ra,a20dfc <boot_get_flash_funcs>
  a21e10:	c62a                	sw	a0,12(sp)
  a21e12:	d17d                	beqz	a0,a21df8 <loader_erase_all_process+0xe>
  a21e14:	63d020ef          	jal	ra,a24c50 <boot_wdt_kick>
  a21e18:	4532                	lw	a0,12(sp)
  a21e1a:	55fd                	li	a1,-1
  a21e1c:	455c                	lw	a5,12(a0)
  a21e1e:	4501                	li	a0,0
  a21e20:	9782                	jalr	a5
  a21e22:	fd61                	bnez	a0,a21dfa <loader_erase_all_process+0x10>
  a21e24:	00a0 660c 079f      	l.li	a5,0xa0660c
  a21e2a:	4705                	li	a4,1
  a21e2c:	a398                	sb	a4,0(a5)
  a21e2e:	a004                	sb	s1,0(s0)
  a21e30:	4501                	li	a0,0
  a21e32:	b7e1                	j	a21dfa <loader_erase_all_process+0x10>

00a21e34 <non_os_enter_critical>:
  a21e34:	8038                	push	{ra,s0-s1},-16
  a21e36:	300024f3          	csrr	s1,mstatus
  a21e3a:	300477f3          	csrrci	a5,mstatus,8
  a21e3e:	00a06437          	lui	s0,0xa06
  a21e42:	61c40793          	addi	a5,s0,1564 # a0661c <g_non_os_critical_nesting>
  a21e46:	239e                	lhu	a5,0(a5)
  a21e48:	61c40413          	addi	s0,s0,1564
  a21e4c:	9fa1                	uxth	a5
  a21e4e:	eb89                	bnez	a5,a21e60 <non_os_enter_critical+0x2c>
  a21e50:	00a0 6614 079f      	l.li	a5,0xa06614
  a21e56:	439c                	lw	a5,0(a5)
  a21e58:	c781                	beqz	a5,a21e60 <non_os_enter_critical+0x2c>
  a21e5a:	8586                	mv	a1,ra
  a21e5c:	4501                	li	a0,0
  a21e5e:	9782                	jalr	a5
  a21e60:	00a0 6610 079f      	l.li	a5,0xa06610
  a21e66:	439c                	lw	a5,0(a5)
  a21e68:	c789                	beqz	a5,a21e72 <non_os_enter_critical+0x3e>
  a21e6a:	8586                	mv	a1,ra
  a21e6c:	2012                	lhu	a2,0(s0)
  a21e6e:	4501                	li	a0,0
  a21e70:	9782                	jalr	a5
  a21e72:	201e                	lhu	a5,0(s0)
  a21e74:	9fa1                	uxth	a5
  a21e76:	eb89                	bnez	a5,a21e88 <non_os_enter_critical+0x54>
  a21e78:	808d                	srli	s1,s1,0x3
  a21e7a:	0014c493          	xori	s1,s1,1
  a21e7e:	8885                	andi	s1,s1,1
  a21e80:	00a0 6618 079f      	l.li	a5,0xa06618
  a21e86:	c384                	sw	s1,0(a5)
  a21e88:	201e                	lhu	a5,0(s0)
  a21e8a:	0785                	addi	a5,a5,1
  a21e8c:	9fa1                	uxth	a5
  a21e8e:	a01e                	sh	a5,0(s0)
  a21e90:	201e                	lhu	a5,0(s0)
  a21e92:	9fa1                	uxth	a5
  a21e94:	eb81                	bnez	a5,a21ea4 <non_os_enter_critical+0x70>
  a21e96:	06300593          	li	a1,99
  a21e9a:	03100513          	li	a0,49
  a21e9e:	8030                	pop	{ra,s0-s1},16
  a21ea0:	55e0306f          	j	a253fe <panic>
  a21ea4:	0ff0000f          	fence
  a21ea8:	0ff0000f          	fence
  a21eac:	8034                	popret	{ra,s0-s1},16

00a21eae <non_os_exit_critical>:
  a21eae:	8038                	push	{ra,s0-s1},-16
  a21eb0:	00a06437          	lui	s0,0xa06
  a21eb4:	61c40793          	addi	a5,s0,1564 # a0661c <g_non_os_critical_nesting>
  a21eb8:	239e                	lhu	a5,0(a5)
  a21eba:	9fa1                	uxth	a5
  a21ebc:	eb81                	bnez	a5,a21ecc <non_os_exit_critical+0x1e>
  a21ebe:	06f00593          	li	a1,111
  a21ec2:	03100513          	li	a0,49
  a21ec6:	8030                	pop	{ra,s0-s1},16
  a21ec8:	5360306f          	j	a253fe <panic>
  a21ecc:	61c40413          	addi	s0,s0,1564
  a21ed0:	201e                	lhu	a5,0(s0)
  a21ed2:	8486                	mv	s1,ra
  a21ed4:	17fd                	addi	a5,a5,-1
  a21ed6:	9fa1                	uxth	a5
  a21ed8:	a01e                	sh	a5,0(s0)
  a21eda:	00a0 6610 079f      	l.li	a5,0xa06610
  a21ee0:	439c                	lw	a5,0(a5)
  a21ee2:	c789                	beqz	a5,a21eec <non_os_exit_critical+0x3e>
  a21ee4:	8586                	mv	a1,ra
  a21ee6:	2012                	lhu	a2,0(s0)
  a21ee8:	4505                	li	a0,1
  a21eea:	9782                	jalr	a5
  a21eec:	201e                	lhu	a5,0(s0)
  a21eee:	9fa1                	uxth	a5
  a21ef0:	e785                	bnez	a5,a21f18 <non_os_exit_critical+0x6a>
  a21ef2:	00a0 6614 079f      	l.li	a5,0xa06614
  a21ef8:	439c                	lw	a5,0(a5)
  a21efa:	c781                	beqz	a5,a21f02 <non_os_exit_critical+0x54>
  a21efc:	85a6                	mv	a1,s1
  a21efe:	4505                	li	a0,1
  a21f00:	9782                	jalr	a5
  a21f02:	00a0 6618 079f      	l.li	a5,0xa06618
  a21f08:	439c                	lw	a5,0(a5)
  a21f0a:	e399                	bnez	a5,a21f10 <non_os_exit_critical+0x62>
  a21f0c:	300467f3          	csrrsi	a5,mstatus,8
  a21f10:	0ff0000f          	fence
  a21f14:	0ff0000f          	fence
  a21f18:	8034                	popret	{ra,s0-s1},16

00a21f1a <malloc_register_funcs>:
  a21f1a:	8018                	push	{ra},-16
  a21f1c:	862a                	mv	a2,a0
  a21f1e:	46b1                	li	a3,12
  a21f20:	45b1                	li	a1,12
  a21f22:	00a0 6620 051f      	l.li	a0,0xa06620
  a21f28:	644030ef          	jal	ra,a2556c <memcpy_s>
  a21f2c:	4501                	li	a0,0
  a21f2e:	8014                	popret	{ra},16

00a21f30 <rom_malloc_init>:
  a21f30:	8038                	push	{ra,s0-s1},-16
  a21f32:	842e                	mv	s0,a1
  a21f34:	46e1                	li	a3,24
  a21f36:	4601                	li	a2,0
  a21f38:	45e1                	li	a1,24
  a21f3a:	84aa                	mv	s1,a0
  a21f3c:	668030ef          	jal	ra,a255a4 <memset_s>
  a21f40:	ff840793          	addi	a5,s0,-8
  a21f44:	00a0 662c 071f      	l.li	a4,0xa0662c
  a21f4a:	01b48513          	addi	a0,s1,27
  a21f4e:	9bf1                	andi	a5,a5,-4
  a21f50:	9971                	andi	a0,a0,-4
  a21f52:	cb1c                	sw	a5,16(a4)
  a21f54:	17e1                	addi	a5,a5,-8
  a21f56:	8f89                	sub	a5,a5,a0
  a21f58:	c748                	sw	a0,12(a4)
  a21f5a:	9fa1                	uxth	a5
  a21f5c:	a15e                	sh	a5,4(a0)
  a21f5e:	c71c                	sw	a5,8(a4)
  a21f60:	679d                	lui	a5,0x7
  a21f62:	07478793          	addi	a5,a5,116 # 7074 <ccause+0x60b2>
  a21f66:	a17e                	sh	a5,6(a0)
  a21f68:	00052023          	sw	zero,0(a0)
  a21f6c:	8034                	popret	{ra,s0-s1},16

00a21f6e <malloc_init>:
  a21f6e:	b7c9                	j	a21f30 <rom_malloc_init>

00a21f70 <rom_malloc>:
  a21f70:	00a066b7          	lui	a3,0xa06
  a21f74:	62c68793          	addi	a5,a3,1580 # a0662c <g_st_dfx>
  a21f78:	47dc                	lw	a5,12(a5)
  a21f7a:	62c68693          	addi	a3,a3,1580
  a21f7e:	e399                	bnez	a5,a21f84 <rom_malloc+0x14>
  a21f80:	4501                	li	a0,0
  a21f82:	8082                	ret
  a21f84:	dd75                	beqz	a0,a21f80 <rom_malloc+0x10>
  a21f86:	23f2                	lhu	a2,6(a5)
  a21f88:	671d                	lui	a4,0x7
  a21f8a:	07470813          	addi	a6,a4,116 # 7074 <ccause+0x60b2>
  a21f8e:	01060663          	beq	a2,a6,a21f9a <rom_malloc+0x2a>
  a21f92:	c6c70713          	addi	a4,a4,-916
  a21f96:	fee615e3          	bne	a2,a4,a21f80 <rom_malloc+0x10>
  a21f9a:	050d                	addi	a0,a0,3
  a21f9c:	9971                	andi	a0,a0,-4
  a21f9e:	671d                	lui	a4,0x7
  a21fa0:	9d21                	uxth	a0
  a21fa2:	4881                	li	a7,0
  a21fa4:	07470613          	addi	a2,a4,116 # 7074 <ccause+0x60b2>
  a21fa8:	00850813          	addi	a6,a0,8
  a21fac:	c6c70313          	addi	t1,a4,-916
  a21fb0:	0067de03          	lhu	t3,6(a5)
  a21fb4:	23da                	lhu	a4,4(a5)
  a21fb6:	04ce1263          	bne	t3,a2,a21ffa <rom_malloc+0x8a>
  a21fba:	02e87563          	bgeu	a6,a4,a21fe4 <rom_malloc+0x74>
  a21fbe:	8f09                	sub	a4,a4,a0
  a21fc0:	983e                	add	a6,a6,a5
  a21fc2:	1761                	addi	a4,a4,-8
  a21fc4:	00e81223          	sh	a4,4(a6) # 800004 <g_intheap_size+0x7e6aa4>
  a21fc8:	00c81323          	sh	a2,6(a6)
  a21fcc:	671d                	lui	a4,0x7
  a21fce:	c6c70713          	addi	a4,a4,-916 # 6c6c <ccause+0x5caa>
  a21fd2:	c38c                	sw	a1,0(a5)
  a21fd4:	a3fa                	sh	a4,6(a5)
  a21fd6:	4298                	lw	a4,0(a3)
  a21fd8:	a3ca                	sh	a0,4(a5)
  a21fda:	953a                	add	a0,a0,a4
  a21fdc:	c288                	sw	a0,0(a3)
  a21fde:	00878513          	addi	a0,a5,8
  a21fe2:	8082                	ret
  a21fe4:	00a76b63          	bltu	a4,a0,a21ffa <rom_malloc+0x8a>
  a21fe8:	661d                	lui	a2,0x7
  a21fea:	c6c60613          	addi	a2,a2,-916 # 6c6c <ccause+0x5caa>
  a21fee:	c38c                	sw	a1,0(a5)
  a21ff0:	a3f2                	sh	a2,6(a5)
  a21ff2:	4290                	lw	a2,0(a3)
  a21ff4:	9732                	add	a4,a4,a2
  a21ff6:	c298                	sw	a4,0(a3)
  a21ff8:	b7dd                	j	a21fde <rom_malloc+0x6e>
  a21ffa:	0721                	addi	a4,a4,8
  a21ffc:	97ba                	add	a5,a5,a4
  a21ffe:	4a98                	lw	a4,16(a3)
  a22000:	00e7ef63          	bltu	a5,a4,a2201e <rom_malloc+0xae>
  a22004:	f6089ee3          	bnez	a7,a21f80 <rom_malloc+0x10>
  a22008:	46d8                	lw	a4,12(a3)
  a2200a:	235e                	lhu	a5,4(a4)
  a2200c:	0106ae03          	lw	t3,16(a3)
  a22010:	07a1                	addi	a5,a5,8
  a22012:	00f708b3          	add	a7,a4,a5
  a22016:	01c8ea63          	bltu	a7,t3,a2202a <rom_malloc+0xba>
  a2201a:	46dc                	lw	a5,12(a3)
  a2201c:	4885                	li	a7,1
  a2201e:	23fa                	lhu	a4,6(a5)
  a22020:	f86708e3          	beq	a4,t1,a21fb0 <rom_malloc+0x40>
  a22024:	f8c706e3          	beq	a4,a2,a21fb0 <rom_malloc+0x40>
  a22028:	bfa1                	j	a21f80 <rom_malloc+0x10>
  a2202a:	00675e03          	lhu	t3,6(a4)
  a2202e:	00ce1b63          	bne	t3,a2,a22044 <rom_malloc+0xd4>
  a22032:	0068de03          	lhu	t3,6(a7)
  a22036:	00ce1763          	bne	t3,a2,a22044 <rom_malloc+0xd4>
  a2203a:	0048d883          	lhu	a7,4(a7)
  a2203e:	97c6                	add	a5,a5,a7
  a22040:	a35e                	sh	a5,4(a4)
  a22042:	88ba                	mv	a7,a4
  a22044:	8746                	mv	a4,a7
  a22046:	b7d1                	j	a2200a <rom_malloc+0x9a>

00a22048 <malloc>:
  a22048:	8018                	push	{ra},-16
  a2204a:	8586                	mv	a1,ra
  a2204c:	8010                	pop	{ra},16
  a2204e:	b70d                	j	a21f70 <rom_malloc>

00a22050 <rom_free>:
  a22050:	c50d                	beqz	a0,a2207a <rom_free+0x2a>
  a22052:	ffe55703          	lhu	a4,-2(a0)
  a22056:	0000 6c6c 079f      	l.li	a5,0x6c6c
  a2205c:	00f71f63          	bne	a4,a5,a2207a <rom_free+0x2a>
  a22060:	679d                	lui	a5,0x7
  a22062:	07478793          	addi	a5,a5,116 # 7074 <ccause+0x60b2>
  a22066:	fef51f23          	sh	a5,-2(a0)
  a2206a:	00a0 662c 071f      	l.li	a4,0xa0662c
  a22070:	ffc55683          	lhu	a3,-4(a0)
  a22074:	435c                	lw	a5,4(a4)
  a22076:	97b6                	add	a5,a5,a3
  a22078:	c35c                	sw	a5,4(a4)
  a2207a:	4501                	li	a0,0
  a2207c:	8082                	ret

00a2207e <free>:
  a2207e:	bfc9                	j	a22050 <rom_free>

00a22080 <osal_irq_lock>:
  a22080:	8018                	push	{ra},-16
  a22082:	3b4d                	jal	ra,a21e34 <non_os_enter_critical>
  a22084:	4501                	li	a0,0
  a22086:	8014                	popret	{ra},16

00a22088 <osal_irq_restore>:
  a22088:	b51d                	j	a21eae <non_os_exit_critical>

00a2208a <drv_rom_hash>:
  a2208a:	8e78                	push	{ra,s0-s5},-256
  a2208c:	892a                	mv	s2,a0
  a2208e:	8aae                	mv	s5,a1
  a22090:	84b2                	mv	s1,a2
  a22092:	4581                	li	a1,0
  a22094:	04000613          	li	a2,64
  a22098:	1008                	addi	a0,sp,32
  a2209a:	c63a                	sw	a4,12(sp)
  a2209c:	8a36                	mv	s4,a3
  a2209e:	843e                	mv	s0,a5
  a220a0:	9a5fe0ef          	jal	ra,a20a44 <memset>
  a220a4:	08000613          	li	a2,128
  a220a8:	4581                	li	a1,0
  a220aa:	1088                	addi	a0,sp,96
  a220ac:	999fe0ef          	jal	ra,a20a44 <memset>
  a220b0:	ce02                	sw	zero,28(sp)
  a220b2:	4732                	lw	a4,12(sp)
  a220b4:	000a9463          	bnez	s5,a220bc <drv_rom_hash+0x32>
  a220b8:	557d                	li	a0,-1
  a220ba:	8e74                	popret	{ra,s0-s5},256
  a220bc:	fe0a0ee3          	beqz	s4,a220b8 <drv_rom_hash+0x2e>
  a220c0:	010007b7          	lui	a5,0x1000
  a220c4:	fef4fae3          	bgeu	s1,a5,a220b8 <drv_rom_hash+0x2e>
  a220c8:	20f71c3b          	bnei	a4,32,a220b8 <drv_rom_hash+0x2e>
  a220cc:	0216 9100 079f      	l.li	a5,0x2169100
  a220d2:	0cf90963          	beq	s2,a5,a221a4 <drv_rom_hash+0x11a>
  a220d6:	00a2 6e5c 061f      	l.li	a2,0xa26e5c
  a220dc:	85ca                	mv	a1,s2
  a220de:	8522                	mv	a0,s0
  a220e0:	609000ef          	jal	ra,a22ee8 <hal_cipher_hash_config>
  a220e4:	f979                	bnez	a0,a220ba <drv_rom_hash+0x30>
  a220e6:	03f4f913          	andi	s2,s1,63
  a220ea:	412489b3          	sub	s3,s1,s2
  a220ee:	0a099f63          	bnez	s3,a221ac <drv_rom_hash+0x122>
  a220f2:	08000693          	li	a3,128
  a220f6:	4601                	li	a2,0
  a220f8:	08000593          	li	a1,128
  a220fc:	1088                	addi	a0,sp,96
  a220fe:	4a6030ef          	jal	ra,a255a4 <memset_s>
  a22102:	86ca                	mv	a3,s2
  a22104:	013a8633          	add	a2,s5,s3
  a22108:	08000593          	li	a1,128
  a2210c:	1088                	addi	a0,sp,96
  a2210e:	45e030ef          	jal	ra,a2556c <memcpy_s>
  a22112:	f15d                	bnez	a0,a220b8 <drv_rom_hash+0x2e>
  a22114:	119c                	addi	a5,sp,224
  a22116:	97ca                	add	a5,a5,s2
  a22118:	f8000713          	li	a4,-128
  a2211c:	f8e78023          	sb	a4,-128(a5) # ffff80 <__data_load__+0x5d854c>
  a22120:	04000993          	li	s3,64
  a22124:	3809623b          	bltui	s2,56,a2212c <drv_rom_hash+0xa2>
  a22128:	08000993          	li	s3,128
  a2212c:	00349713          	slli	a4,s1,0x3
  a22130:	01b49613          	slli	a2,s1,0x1b
  a22134:	0000 ff00 079f      	l.li	a5,0xff00
  a2213a:	50e7c79b          	andshf	a5,a5,a4,srl,8
  a2213e:	70e6261b          	orshf	a2,a2,a4,srl,24
  a22142:	8e5d                	or	a2,a2,a5
  a22144:	00ff07b7          	lui	a5,0xff0
  a22148:	1697c49b          	andshf	s1,a5,s1,sll,11
  a2214c:	8e45                	or	a2,a2,s1
  a2214e:	ffc98513          	addi	a0,s3,-4
  a22152:	109c                	addi	a5,sp,96
  a22154:	ce32                	sw	a2,28(sp)
  a22156:	4691                	li	a3,4
  a22158:	0870                	addi	a2,sp,28
  a2215a:	4591                	li	a1,4
  a2215c:	953e                	add	a0,a0,a5
  a2215e:	40e030ef          	jal	ra,a2556c <memcpy_s>
  a22162:	f939                	bnez	a0,a220b8 <drv_rom_hash+0x2e>
  a22164:	4695                	li	a3,5
  a22166:	864e                	mv	a2,s3
  a22168:	108c                	addi	a1,sp,96
  a2216a:	8522                	mv	a0,s0
  a2216c:	65f000ef          	jal	ra,a22fca <hal_cipher_hash_add_in_node>
  a22170:	f529                	bnez	a0,a220ba <drv_rom_hash+0x30>
  a22172:	4581                	li	a1,0
  a22174:	8522                	mv	a0,s0
  a22176:	6c9000ef          	jal	ra,a2303e <hal_cipher_hash_start>
  a2217a:	f121                	bnez	a0,a220ba <drv_rom_hash+0x30>
  a2217c:	04000613          	li	a2,64
  a22180:	100c                	addi	a1,sp,32
  a22182:	8522                	mv	a0,s0
  a22184:	0a4010ef          	jal	ra,a23228 <hal_cipher_hash_wait_done>
  a22188:	f90d                	bnez	a0,a220ba <drv_rom_hash+0x30>
  a2218a:	02000693          	li	a3,32
  a2218e:	1010                	addi	a2,sp,32
  a22190:	02000593          	li	a1,32
  a22194:	8552                	mv	a0,s4
  a22196:	3d6030ef          	jal	ra,a2556c <memcpy_s>
  a2219a:	00a03533          	snez	a0,a0
  a2219e:	40a00533          	neg	a0,a0
  a221a2:	bf21                	j	a220ba <drv_rom_hash+0x30>
  a221a4:	00a2 6e7c 061f      	l.li	a2,0xa26e7c
  a221aa:	bf0d                	j	a220dc <drv_rom_hash+0x52>
  a221ac:	4695                	li	a3,5
  a221ae:	864e                	mv	a2,s3
  a221b0:	85d6                	mv	a1,s5
  a221b2:	8522                	mv	a0,s0
  a221b4:	617000ef          	jal	ra,a22fca <hal_cipher_hash_add_in_node>
  a221b8:	f00511e3          	bnez	a0,a220ba <drv_rom_hash+0x30>
  a221bc:	4581                	li	a1,0
  a221be:	8522                	mv	a0,s0
  a221c0:	67f000ef          	jal	ra,a2303e <hal_cipher_hash_start>
  a221c4:	ee051be3          	bnez	a0,a220ba <drv_rom_hash+0x30>
  a221c8:	4601                	li	a2,0
  a221ca:	4581                	li	a1,0
  a221cc:	8522                	mv	a0,s0
  a221ce:	05a010ef          	jal	ra,a23228 <hal_cipher_hash_wait_done>
  a221d2:	f20500e3          	beqz	a0,a220f2 <drv_rom_hash+0x68>
  a221d6:	b5d5                	j	a220ba <drv_rom_hash+0x30>

00a221d8 <crypto_get_phys_addr>:
  a221d8:	00a0 6644 079f      	l.li	a5,0xa06644
  a221de:	0087a303          	lw	t1,8(a5) # ff0008 <__data_load__+0x5c85d4>
  a221e2:	00030363          	beqz	t1,a221e8 <crypto_get_phys_addr+0x10>
  a221e6:	8302                	jr	t1
  a221e8:	8082                	ret

00a221ea <drv_cipher_register_func>:
  a221ea:	c115                	beqz	a0,a2220e <drv_cipher_register_func+0x24>
  a221ec:	4118                	lw	a4,0(a0)
  a221ee:	00a0 6644 079f      	l.li	a5,0xa06644
  a221f4:	c398                	sw	a4,0(a5)
  a221f6:	4158                	lw	a4,4(a0)
  a221f8:	c3d8                	sw	a4,4(a5)
  a221fa:	4518                	lw	a4,8(a0)
  a221fc:	c798                	sw	a4,8(a5)
  a221fe:	4918                	lw	a4,16(a0)
  a22200:	cb98                	sw	a4,16(a5)
  a22202:	4d58                	lw	a4,28(a0)
  a22204:	cfd8                	sw	a4,28(a5)
  a22206:	5118                	lw	a4,32(a0)
  a22208:	4501                	li	a0,0
  a2220a:	d398                	sw	a4,32(a5)
  a2220c:	8082                	ret
  a2220e:	557d                	li	a0,-1
  a22210:	8082                	ret

00a22212 <crypto_get_cpu_type>:
  a22212:	00a0 6644 079f      	l.li	a5,0xa06644
  a22218:	01c7a303          	lw	t1,28(a5)
  a2221c:	00030363          	beqz	t1,a22222 <crypto_get_cpu_type+0x10>
  a22220:	8302                	jr	t1
  a22222:	4505                	li	a0,1
  a22224:	8082                	ret

00a22226 <crypto_curve_param_init>:
  a22226:	00a2 6e9c 059f      	l.li	a1,0xa26e9c
  a2222c:	00a2 6ea0 051f      	l.li	a0,0xa26ea0
  a22232:	a009                	j	a22234 <drv_cipher_pke_init_ecc_param>

00a22234 <drv_cipher_pke_init_ecc_param>:
  a22234:	00a067b7          	lui	a5,0xa06
  a22238:	7aa7ac23          	sw	a0,1976(a5) # a067b8 <g_ecc_params>
  a2223c:	00a067b7          	lui	a5,0xa06
  a22240:	7ab7aa23          	sw	a1,1972(a5) # a067b4 <g_ecc_num>
  a22244:	8082                	ret

00a22246 <drv_cipher_pke_init>:
  a22246:	8028                	push	{ra,s0},-16
  a22248:	38b000ef          	jal	ra,a22dd2 <hal_pke_init>
  a2224c:	842a                	mv	s0,a0
  a2224e:	c119                	beqz	a0,a22254 <drv_cipher_pke_init+0xe>
  a22250:	397000ef          	jal	ra,a22de6 <hal_pke_deinit>
  a22254:	8522                	mv	a0,s0
  a22256:	8024                	popret	{ra,s0},16

00a22258 <drv_cipher_pke_deinit>:
  a22258:	8118                	push	{ra},-32
  a2225a:	38d000ef          	jal	ra,a22de6 <hal_pke_deinit>
  a2225e:	e509                	bnez	a0,a22268 <drv_cipher_pke_deinit+0x10>
  a22260:	c62a                	sw	a0,12(sp)
  a22262:	3a1000ef          	jal	ra,a22e02 <hal_pke_unlock>
  a22266:	4532                	lw	a0,12(sp)
  a22268:	8114                	popret	{ra},32

00a2226a <inner_get_phys_addr>:
  a2226a:	8082                	ret

00a2226c <drv_rom_cipher_sha256>:
  a2226c:	8128                	push	{ra,s0},-32
  a2226e:	842a                	mv	s0,a0
  a22270:	4505                	li	a0,1
  a22272:	c62e                	sw	a1,12(sp)
  a22274:	c432                	sw	a2,8(sp)
  a22276:	c236                	sw	a3,4(sp)
  a22278:	689000ef          	jal	ra,a23100 <hal_hash_lock>
  a2227c:	4622                	lw	a2,8(sp)
  a2227e:	45b2                	lw	a1,12(sp)
  a22280:	4712                	lw	a4,4(sp)
  a22282:	86b2                	mv	a3,a2
  a22284:	4785                	li	a5,1
  a22286:	862e                	mv	a2,a1
  a22288:	0116 9100 051f      	l.li	a0,0x1169100
  a2228e:	85a2                	mv	a1,s0
  a22290:	3bed                	jal	ra,a2208a <drv_rom_hash>
  a22292:	842a                	mv	s0,a0
  a22294:	4505                	li	a0,1
  a22296:	3fb000ef          	jal	ra,a22e90 <hal_hash_unlock>
  a2229a:	8522                	mv	a0,s0
  a2229c:	8124                	popret	{ra,s0},32

00a2229e <drv_rom_cipher_init>:
  a2229e:	8318                	push	{ra},-64
  a222a0:	02400613          	li	a2,36
  a222a4:	4581                	li	a1,0
  a222a6:	0068                	addi	a0,sp,12
  a222a8:	f9cfe0ef          	jal	ra,a20a44 <memset>
  a222ac:	0ce010ef          	jal	ra,a2337a <hal_cipher_trng_init>
  a222b0:	3f59                	jal	ra,a22246 <drv_cipher_pke_init>
  a222b2:	385000ef          	jal	ra,a22e36 <hal_cipher_hash_init>
  a222b6:	00a2 226a 079f      	l.li	a5,0xa2226a
  a222bc:	0068                	addi	a0,sp,12
  a222be:	ca3e                	sw	a5,20(sp)
  a222c0:	372d                	jal	ra,a221ea <drv_cipher_register_func>
  a222c2:	3795                	jal	ra,a22226 <crypto_curve_param_init>
  a222c4:	4501                	li	a0,0
  a222c6:	8314                	popret	{ra},64

00a222c8 <drv_rom_cipher_deinit>:
  a222c8:	8018                	push	{ra},-16
  a222ca:	3779                	jal	ra,a22258 <drv_cipher_pke_deinit>
  a222cc:	0bc010ef          	jal	ra,a23388 <hal_cipher_trng_deinit>
  a222d0:	3e1000ef          	jal	ra,a22eb0 <hal_cipher_hash_deinit>
  a222d4:	4501                	li	a0,0
  a222d6:	8014                	popret	{ra},16

00a222d8 <uapi_systick_get_count>:
  a222d8:	8048                	push	{ra,s0-s2},-16
  a222da:	335d                	jal	ra,a22080 <osal_irq_lock>
  a222dc:	00a0 6668 079f      	l.li	a5,0xa06668
  a222e2:	239c                	lbu	a5,0(a5)
  a222e4:	e799                	bnez	a5,a222f2 <uapi_systick_get_count+0x1a>
  a222e6:	334d                	jal	ra,a22088 <osal_irq_restore>
  a222e8:	4401                	li	s0,0
  a222ea:	4481                	li	s1,0
  a222ec:	8522                	mv	a0,s0
  a222ee:	85a6                	mv	a1,s1
  a222f0:	8044                	popret	{ra,s0-s2},16
  a222f2:	892a                	mv	s2,a0
  a222f4:	545010ef          	jal	ra,a24038 <hal_systick_get_count>
  a222f8:	842a                	mv	s0,a0
  a222fa:	854a                	mv	a0,s2
  a222fc:	84ae                	mv	s1,a1
  a222fe:	3369                	jal	ra,a22088 <osal_irq_restore>
  a22300:	b7f5                	j	a222ec <uapi_systick_get_count+0x14>

00a22302 <uapi_systick_get_us>:
  a22302:	8128                	push	{ra,s0},-32
  a22304:	3fd1                	jal	ra,a222d8 <uapi_systick_get_count>
  a22306:	842a                	mv	s0,a0
  a22308:	c62e                	sw	a1,12(sp)
  a2230a:	53f010ef          	jal	ra,a24048 <systick_clock_get>
  a2230e:	45b2                	lw	a1,12(sp)
  a22310:	000f 4240 079f      	l.li	a5,0xf4240
  a22316:	02f43733          	mulhu	a4,s0,a5
  a2231a:	862a                	mv	a2,a0
  a2231c:	4681                	li	a3,0
  a2231e:	02f585b3          	mul	a1,a1,a5
  a22322:	02f40533          	mul	a0,s0,a5
  a22326:	95ba                	add	a1,a1,a4
  a22328:	b14fe0ef          	jal	ra,a2063c <__udivdi3>
  a2232c:	8124                	popret	{ra,s0},32

00a2232e <uapi_tcxo_init>:
  a2232e:	8048                	push	{ra,s0-s2},-16
  a22330:	3b81                	jal	ra,a22080 <osal_irq_lock>
  a22332:	00a0 6669 091f      	l.li	s2,0xa06669
  a22338:	00094783          	lbu	a5,0(s2)
  a2233c:	c789                	beqz	a5,a22346 <uapi_tcxo_init+0x18>
  a2233e:	33a9                	jal	ra,a22088 <osal_irq_restore>
  a22340:	4401                	li	s0,0
  a22342:	8522                	mv	a0,s0
  a22344:	8044                	popret	{ra,s0-s2},16
  a22346:	84aa                	mv	s1,a0
  a22348:	04e010ef          	jal	ra,a23396 <hal_tcxo_init>
  a2234c:	842a                	mv	s0,a0
  a2234e:	c501                	beqz	a0,a22356 <uapi_tcxo_init+0x28>
  a22350:	8526                	mv	a0,s1
  a22352:	3b1d                	jal	ra,a22088 <osal_irq_restore>
  a22354:	b7fd                	j	a22342 <uapi_tcxo_init+0x14>
  a22356:	4785                	li	a5,1
  a22358:	00f90023          	sb	a5,0(s2)
  a2235c:	bfd5                	j	a22350 <uapi_tcxo_init+0x22>

00a2235e <uapi_tcxo_get_count>:
  a2235e:	8048                	push	{ra,s0-s2},-16
  a22360:	3305                	jal	ra,a22080 <osal_irq_lock>
  a22362:	00a0 6669 079f      	l.li	a5,0xa06669
  a22368:	239c                	lbu	a5,0(a5)
  a2236a:	e799                	bnez	a5,a22378 <uapi_tcxo_get_count+0x1a>
  a2236c:	3b31                	jal	ra,a22088 <osal_irq_restore>
  a2236e:	4401                	li	s0,0
  a22370:	4481                	li	s1,0
  a22372:	8522                	mv	a0,s0
  a22374:	85a6                	mv	a1,s1
  a22376:	8044                	popret	{ra,s0-s2},16
  a22378:	892a                	mv	s2,a0
  a2237a:	048010ef          	jal	ra,a233c2 <hal_tcxo_get>
  a2237e:	842a                	mv	s0,a0
  a22380:	854a                	mv	a0,s2
  a22382:	84ae                	mv	s1,a1
  a22384:	3311                	jal	ra,a22088 <osal_irq_restore>
  a22386:	b7f5                	j	a22372 <uapi_tcxo_get_count+0x14>

00a22388 <uapi_tcxo_delay_ms>:
  a22388:	00a0 6669 079f      	l.li	a5,0xa06669
  a2238e:	239c                	lbu	a5,0(a5)
  a22390:	c3b1                	beqz	a5,a223d4 <uapi_tcxo_delay_ms+0x4c>
  a22392:	8048                	push	{ra,s0-s2},-16
  a22394:	842a                	mv	s0,a0
  a22396:	4c5010ef          	jal	ra,a2405a <tcxo_porting_ticks_per_usec_get>
  a2239a:	3e800793          	li	a5,1000
  a2239e:	02f405b3          	mul	a1,s0,a5
  a223a2:	02f43433          	mulhu	s0,s0,a5
  a223a6:	02a584b3          	mul	s1,a1,a0
  a223aa:	02a40433          	mul	s0,s0,a0
  a223ae:	02a5b5b3          	mulhu	a1,a1,a0
  a223b2:	942e                	add	s0,s0,a1
  a223b4:	376d                	jal	ra,a2235e <uapi_tcxo_get_count>
  a223b6:	00a48933          	add	s2,s1,a0
  a223ba:	009934b3          	sltu	s1,s2,s1
  a223be:	95a2                	add	a1,a1,s0
  a223c0:	94ae                	add	s1,s1,a1
  a223c2:	3f71                	jal	ra,a2235e <uapi_tcxo_get_count>
  a223c4:	fe95efe3          	bltu	a1,s1,a223c2 <uapi_tcxo_delay_ms+0x3a>
  a223c8:	00b49463          	bne	s1,a1,a223d0 <uapi_tcxo_delay_ms+0x48>
  a223cc:	ff256be3          	bltu	a0,s2,a223c2 <uapi_tcxo_delay_ms+0x3a>
  a223d0:	4501                	li	a0,0
  a223d2:	8044                	popret	{ra,s0-s2},16
  a223d4:	557d                	li	a0,-1
  a223d6:	8082                	ret

00a223d8 <uapi_tcxo_delay_us>:
  a223d8:	00a0 6669 079f      	l.li	a5,0xa06669
  a223de:	239c                	lbu	a5,0(a5)
  a223e0:	cb8d                	beqz	a5,a22412 <uapi_tcxo_delay_us+0x3a>
  a223e2:	8048                	push	{ra,s0-s2},-16
  a223e4:	842a                	mv	s0,a0
  a223e6:	475010ef          	jal	ra,a2405a <tcxo_porting_ticks_per_usec_get>
  a223ea:	02a404b3          	mul	s1,s0,a0
  a223ee:	02a43433          	mulhu	s0,s0,a0
  a223f2:	37b5                	jal	ra,a2235e <uapi_tcxo_get_count>
  a223f4:	00a48933          	add	s2,s1,a0
  a223f8:	009934b3          	sltu	s1,s2,s1
  a223fc:	942e                	add	s0,s0,a1
  a223fe:	9426                	add	s0,s0,s1
  a22400:	3fb9                	jal	ra,a2235e <uapi_tcxo_get_count>
  a22402:	fe85efe3          	bltu	a1,s0,a22400 <uapi_tcxo_delay_us+0x28>
  a22406:	00b41463          	bne	s0,a1,a2240e <uapi_tcxo_delay_us+0x36>
  a2240a:	ff256be3          	bltu	a0,s2,a22400 <uapi_tcxo_delay_us+0x28>
  a2240e:	4501                	li	a0,0
  a22410:	8044                	popret	{ra,s0-s2},16
  a22412:	557d                	li	a0,-1
  a22414:	8082                	ret

00a22416 <uart_rx_buffer_report>:
  a22416:	8038                	push	{ra,s0-s1},-16
  a22418:	00a06737          	lui	a4,0xa06
  a2241c:	67070793          	addi	a5,a4,1648 # a06670 <g_uart_rx_state_array>
  a22420:	18a797db          	muliadd	a5,a5,a0,24
  a22424:	4394                	lw	a3,0(a5)
  a22426:	862e                	mv	a2,a1
  a22428:	842a                	mv	s0,a0
  a2242a:	2bce                	lhu	a1,20(a5)
  a2242c:	67070493          	addi	s1,a4,1648
  a22430:	c299                	beqz	a3,a22436 <uart_rx_buffer_report+0x20>
  a22432:	47c8                	lw	a0,12(a5)
  a22434:	9682                	jalr	a3
  a22436:	1884945b          	muliadd	s0,s1,s0,24
  a2243a:	00041a23          	sh	zero,20(s0)
  a2243e:	8034                	popret	{ra,s0-s1},16

00a22440 <uapi_uart_param_check>:
  a22440:	0305763b          	bgeui	a0,3,a22458 <uapi_uart_param_check+0x18>
  a22444:	c991                	beqz	a1,a22458 <uapi_uart_param_check+0x18>
  a22446:	ca09                	beqz	a2,a22458 <uapi_uart_param_check+0x18>
  a22448:	00a0 666c 079f      	l.li	a5,0xa0666c
  a2244e:	953e                	add	a0,a0,a5
  a22450:	211c                	lbu	a5,0(a0)
  a22452:	c799                	beqz	a5,a22460 <uapi_uart_param_check+0x20>
  a22454:	4501                	li	a0,0
  a22456:	8082                	ret
  a22458:	80000537          	lui	a0,0x80000
  a2245c:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a2245e:	8082                	ret
  a22460:	8000 1040 051f      	l.li	a0,0x80001040
  a22466:	8082                	ret

00a22468 <uart_helper_invoke_current_fragment_callback>:
  a22468:	00a0 66b8 079f      	l.li	a5,0xa066b8
  a2246e:	4ca7955b          	muliadd	a0,a5,a0,76
  a22472:	411c                	lw	a5,0(a0)
  a22474:	0087a303          	lw	t1,8(a5)
  a22478:	00030663          	beqz	t1,a22484 <uart_helper_invoke_current_fragment_callback+0x1c>
  a2247c:	43d0                	lw	a2,4(a5)
  a2247e:	47cc                	lw	a1,12(a5)
  a22480:	4388                	lw	a0,0(a5)
  a22482:	8302                	jr	t1
  a22484:	8082                	ret

00a22486 <uart_helper_move_to_next_fragment>:
  a22486:	04c00793          	li	a5,76
  a2248a:	02f507b3          	mul	a5,a0,a5
  a2248e:	00a066b7          	lui	a3,0xa06
  a22492:	6b868713          	addi	a4,a3,1720 # a066b8 <g_uart_tx_state_array>
  a22496:	6b868693          	addi	a3,a3,1720
  a2249a:	00f705b3          	add	a1,a4,a5
  a2249e:	4190                	lw	a2,0(a1)
  a224a0:	07b1                	addi	a5,a5,12
  a224a2:	97ba                	add	a5,a5,a4
  a224a4:	0641                	addi	a2,a2,16
  a224a6:	04078713          	addi	a4,a5,64
  a224aa:	00e67b63          	bgeu	a2,a4,a224c0 <uart_helper_move_to_next_fragment+0x3a>
  a224ae:	c190                	sw	a2,0(a1)
  a224b0:	4ca6955b          	muliadd	a0,a3,a0,76
  a224b4:	251e                	lhu	a5,8(a0)
  a224b6:	00051523          	sh	zero,10(a0)
  a224ba:	17fd                	addi	a5,a5,-1
  a224bc:	a51e                	sh	a5,8(a0)
  a224be:	8082                	ret
  a224c0:	c19c                	sw	a5,0(a1)
  a224c2:	b7fd                	j	a224b0 <uart_helper_move_to_next_fragment+0x2a>

00a224c4 <uart_helper_send_next_char>:
  a224c4:	8038                	push	{ra,s0-s1},-16
  a224c6:	00a0 66b8 041f      	l.li	s0,0xa066b8
  a224cc:	4ca4145b          	muliadd	s0,s0,a0,76
  a224d0:	4004                	lw	s1,0(s0)
  a224d2:	243e                	lhu	a5,10(s0)
  a224d4:	4605                	li	a2,1
  a224d6:	408c                	lw	a1,0(s1)
  a224d8:	95be                	add	a1,a1,a5
  a224da:	7b5000ef          	jal	ra,a2348e <hal_uart_write>
  a224de:	242a                	lhu	a0,10(s0)
  a224e0:	0505                	addi	a0,a0,1
  a224e2:	9d21                	uxth	a0
  a224e4:	a42a                	sh	a0,10(s0)
  a224e6:	44dc                	lw	a5,12(s1)
  a224e8:	00f53533          	sltu	a0,a0,a5
  a224ec:	00154513          	xori	a0,a0,1
  a224f0:	8034                	popret	{ra,s0-s1},16

00a224f2 <uart_error_isr>:
  a224f2:	8148                	push	{ra,s0-s2},-32
  a224f4:	842a                	mv	s0,a0
  a224f6:	00f10613          	addi	a2,sp,15
  a224fa:	45a5                	li	a1,9
  a224fc:	00a0 6670 049f      	l.li	s1,0xa06670
  a22502:	00010723          	sb	zero,14(sp)
  a22506:	000107a3          	sb	zero,15(sp)
  a2250a:	1884995b          	muliadd	s2,s1,s0,24
  a2250e:	7a5000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a22512:	00f14783          	lbu	a5,15(sp)
  a22516:	cb99                	beqz	a5,a2252c <uart_error_isr+0x3a>
  a22518:	188494db          	muliadd	s1,s1,s0,24
  a2251c:	28de                	lhu	a5,20(s1)
  a2251e:	c791                	beqz	a5,a2252a <uart_error_isr+0x38>
  a22520:	409c                	lw	a5,0(s1)
  a22522:	c781                	beqz	a5,a2252a <uart_error_isr+0x38>
  a22524:	4585                	li	a1,1
  a22526:	8522                	mv	a0,s0
  a22528:	35fd                	jal	ra,a22416 <uart_rx_buffer_report>
  a2252a:	8144                	popret	{ra,s0-s2},32
  a2252c:	4605                	li	a2,1
  a2252e:	00e10593          	addi	a1,sp,14
  a22532:	8522                	mv	a0,s0
  a22534:	76d000ef          	jal	ra,a234a0 <hal_uart_read>
  a22538:	01495683          	lhu	a3,20(s2)
  a2253c:	00c92783          	lw	a5,12(s2)
  a22540:	00e14703          	lbu	a4,14(sp)
  a22544:	97b6                	add	a5,a5,a3
  a22546:	a398                	sb	a4,0(a5)
  a22548:	01495783          	lhu	a5,20(s2)
  a2254c:	01095703          	lhu	a4,16(s2)
  a22550:	0785                	addi	a5,a5,1
  a22552:	9fa1                	uxth	a5
  a22554:	00f91a23          	sh	a5,20(s2)
  a22558:	00e7e563          	bltu	a5,a4,a22562 <uart_error_isr+0x70>
  a2255c:	4585                	li	a1,1
  a2255e:	8522                	mv	a0,s0
  a22560:	3d5d                	jal	ra,a22416 <uart_rx_buffer_report>
  a22562:	00f10613          	addi	a2,sp,15
  a22566:	45a5                	li	a1,9
  a22568:	8522                	mv	a0,s0
  a2256a:	749000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a2256e:	b755                	j	a22512 <uart_error_isr+0x20>

00a22570 <uart_evt_callback>:
  a22570:	8158                	push	{ra,s0-s3},-48
  a22572:	15fd                	addi	a1,a1,-1
  a22574:	0ff5f793          	andi	a5,a1,255
  a22578:	0567f3bb          	bgeui	a5,5,a22706 <uart_evt_callback+0x196>
  a2257c:	00a275b7          	lui	a1,0xa27
  a22580:	ea058593          	addi	a1,a1,-352 # a26ea0 <g_crypto_ecc_params>
  a22584:	04f5859b          	addshf	a1,a1,a5,sll,2
  a22588:	419c                	lw	a5,0(a1)
  a2258a:	842a                	mv	s0,a0
  a2258c:	8782                	jr	a5
  a2258e:	00a0 66b8 049f      	l.li	s1,0xa066b8
  a22594:	000107a3          	sb	zero,15(sp)
  a22598:	4ca494db          	muliadd	s1,s1,a0,76
  a2259c:	249e                	lhu	a5,8(s1)
  a2259e:	eb81                	bnez	a5,a225ae <uart_evt_callback+0x3e>
  a225a0:	4601                	li	a2,0
  a225a2:	4589                	li	a1,2
  a225a4:	8522                	mv	a0,s0
  a225a6:	70d000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a225aa:	4501                	li	a0,0
  a225ac:	8154                	popret	{ra,s0-s3},48
  a225ae:	00f10613          	addi	a2,sp,15
  a225b2:	459d                	li	a1,7
  a225b4:	8522                	mv	a0,s0
  a225b6:	6fd000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a225ba:	00f14783          	lbu	a5,15(sp)
  a225be:	f7f5                	bnez	a5,a225aa <uart_evt_callback+0x3a>
  a225c0:	8522                	mv	a0,s0
  a225c2:	3709                	jal	ra,a224c4 <uart_helper_send_next_char>
  a225c4:	d56d                	beqz	a0,a225ae <uart_evt_callback+0x3e>
  a225c6:	8522                	mv	a0,s0
  a225c8:	3545                	jal	ra,a22468 <uart_helper_invoke_current_fragment_callback>
  a225ca:	8522                	mv	a0,s0
  a225cc:	3d6d                	jal	ra,a22486 <uart_helper_move_to_next_fragment>
  a225ce:	b7f9                	j	a2259c <uart_evt_callback+0x2c>
  a225d0:	00f10613          	addi	a2,sp,15
  a225d4:	45a5                	li	a1,9
  a225d6:	00a0 6670 049f      	l.li	s1,0xa06670
  a225dc:	00010723          	sb	zero,14(sp)
  a225e0:	000107a3          	sb	zero,15(sp)
  a225e4:	4981                	li	s3,0
  a225e6:	6cd000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a225ea:	1884995b          	muliadd	s2,s1,s0,24
  a225ee:	00f14783          	lbu	a5,15(sp)
  a225f2:	cf81                	beqz	a5,a2260a <uart_evt_callback+0x9a>
  a225f4:	188497db          	muliadd	a5,s1,s0,24
  a225f8:	2bda                	lhu	a4,20(a5)
  a225fa:	db45                	beqz	a4,a225aa <uart_evt_callback+0x3a>
  a225fc:	2bf8                	lbu	a4,22(a5)
  a225fe:	8b09                	andi	a4,a4,2
  a22600:	d74d                	beqz	a4,a225aa <uart_evt_callback+0x3a>
  a22602:	2bbe                	lhu	a5,18(a5)
  a22604:	faf9e3e3          	bltu	s3,a5,a225aa <uart_evt_callback+0x3a>
  a22608:	a071                	j	a22694 <uart_evt_callback+0x124>
  a2260a:	4605                	li	a2,1
  a2260c:	00e10593          	addi	a1,sp,14
  a22610:	8522                	mv	a0,s0
  a22612:	68f000ef          	jal	ra,a234a0 <hal_uart_read>
  a22616:	00092783          	lw	a5,0(s2)
  a2261a:	0985                	addi	s3,s3,1
  a2261c:	09c2                	slli	s3,s3,0x10
  a2261e:	0109d993          	srli	s3,s3,0x10
  a22622:	eb81                	bnez	a5,a22632 <uart_evt_callback+0xc2>
  a22624:	00f10613          	addi	a2,sp,15
  a22628:	45a5                	li	a1,9
  a2262a:	8522                	mv	a0,s0
  a2262c:	687000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a22630:	bf7d                	j	a225ee <uart_evt_callback+0x7e>
  a22632:	01495683          	lhu	a3,20(s2)
  a22636:	00c92783          	lw	a5,12(s2)
  a2263a:	00e14703          	lbu	a4,14(sp)
  a2263e:	97b6                	add	a5,a5,a3
  a22640:	a398                	sb	a4,0(a5)
  a22642:	01495783          	lhu	a5,20(s2)
  a22646:	01095703          	lhu	a4,16(s2)
  a2264a:	0785                	addi	a5,a5,1
  a2264c:	9fa1                	uxth	a5
  a2264e:	00f91a23          	sh	a5,20(s2)
  a22652:	fce7e9e3          	bltu	a5,a4,a22624 <uart_evt_callback+0xb4>
  a22656:	4581                	li	a1,0
  a22658:	8522                	mv	a0,s0
  a2265a:	3b75                	jal	ra,a22416 <uart_rx_buffer_report>
  a2265c:	b7e1                	j	a22624 <uart_evt_callback+0xb4>
  a2265e:	00f10613          	addi	a2,sp,15
  a22662:	45a5                	li	a1,9
  a22664:	00a0 6670 049f      	l.li	s1,0xa06670
  a2266a:	00010723          	sb	zero,14(sp)
  a2266e:	000107a3          	sb	zero,15(sp)
  a22672:	4981                	li	s3,0
  a22674:	63f000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a22678:	1884995b          	muliadd	s2,s1,s0,24
  a2267c:	00f14783          	lbu	a5,15(sp)
  a22680:	cf91                	beqz	a5,a2269c <uart_evt_callback+0x12c>
  a22682:	188497db          	muliadd	a5,s1,s0,24
  a22686:	2bda                	lhu	a4,20(a5)
  a22688:	f20701e3          	beqz	a4,a225aa <uart_evt_callback+0x3a>
  a2268c:	2bf8                	lbu	a4,22(a5)
  a2268e:	00177693          	andi	a3,a4,1
  a22692:	d6b5                	beqz	a3,a225fe <uart_evt_callback+0x8e>
  a22694:	4581                	li	a1,0
  a22696:	8522                	mv	a0,s0
  a22698:	3bbd                	jal	ra,a22416 <uart_rx_buffer_report>
  a2269a:	bf01                	j	a225aa <uart_evt_callback+0x3a>
  a2269c:	4605                	li	a2,1
  a2269e:	00e10593          	addi	a1,sp,14
  a226a2:	8522                	mv	a0,s0
  a226a4:	5fd000ef          	jal	ra,a234a0 <hal_uart_read>
  a226a8:	00092783          	lw	a5,0(s2)
  a226ac:	0985                	addi	s3,s3,1
  a226ae:	09c2                	slli	s3,s3,0x10
  a226b0:	0109d993          	srli	s3,s3,0x10
  a226b4:	eb81                	bnez	a5,a226c4 <uart_evt_callback+0x154>
  a226b6:	00f10613          	addi	a2,sp,15
  a226ba:	45a5                	li	a1,9
  a226bc:	8522                	mv	a0,s0
  a226be:	5f5000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a226c2:	bf6d                	j	a2267c <uart_evt_callback+0x10c>
  a226c4:	01495683          	lhu	a3,20(s2)
  a226c8:	00c92783          	lw	a5,12(s2)
  a226cc:	00e14703          	lbu	a4,14(sp)
  a226d0:	97b6                	add	a5,a5,a3
  a226d2:	a398                	sb	a4,0(a5)
  a226d4:	01495783          	lhu	a5,20(s2)
  a226d8:	01095703          	lhu	a4,16(s2)
  a226dc:	0785                	addi	a5,a5,1
  a226de:	9fa1                	uxth	a5
  a226e0:	00f91a23          	sh	a5,20(s2)
  a226e4:	fce7e9e3          	bltu	a5,a4,a226b6 <uart_evt_callback+0x146>
  a226e8:	4581                	li	a1,0
  a226ea:	8522                	mv	a0,s0
  a226ec:	332d                	jal	ra,a22416 <uart_rx_buffer_report>
  a226ee:	b7e1                	j	a226b6 <uart_evt_callback+0x146>
  a226f0:	00a0 6670 079f      	l.li	a5,0xa06670
  a226f6:	18a797db          	muliadd	a5,a5,a0,24
  a226fa:	43dc                	lw	a5,4(a5)
  a226fc:	c781                	beqz	a5,a22704 <uart_evt_callback+0x194>
  a226fe:	4581                	li	a1,0
  a22700:	4501                	li	a0,0
  a22702:	9782                	jalr	a5
  a22704:	8522                	mv	a0,s0
  a22706:	33f5                	jal	ra,a224f2 <uart_error_isr>
  a22708:	b54d                	j	a225aa <uart_evt_callback+0x3a>
  a2270a:	00a0 6670 079f      	l.li	a5,0xa06670
  a22710:	18a797db          	muliadd	a5,a5,a0,24
  a22714:	479c                	lw	a5,8(a5)
  a22716:	b7dd                	j	a226fc <uart_evt_callback+0x18c>

00a22718 <uapi_uart_init>:
  a22718:	8158                	push	{ra,s0-s3},-48
  a2271a:	4789                	li	a5,2
  a2271c:	0aa7ed63          	bltu	a5,a0,a227d6 <uapi_uart_init+0xbe>
  a22720:	c9dd                	beqz	a1,a227d6 <uapi_uart_init+0xbe>
  a22722:	0015c883          	lbu	a7,1(a1)
  a22726:	07200813          	li	a6,114
  a2272a:	0b186663          	bltu	a6,a7,a227d6 <uapi_uart_init+0xbe>
  a2272e:	0005c883          	lbu	a7,0(a1)
  a22732:	0b186263          	bltu	a6,a7,a227d6 <uapi_uart_init+0xbe>
  a22736:	c245                	beqz	a2,a227d6 <uapi_uart_init+0xbe>
  a22738:	00464803          	lbu	a6,4(a2)
  a2273c:	042876bb          	bgeui	a6,4,a227d6 <uapi_uart_init+0xbe>
  a22740:	00664803          	lbu	a6,6(a2)
  a22744:	0907e963          	bltu	a5,a6,a227d6 <uapi_uart_init+0xbe>
  a22748:	325c                	lbu	a5,5(a2)
  a2274a:	0227f33b          	bgeui	a5,2,a227d6 <uapi_uart_init+0xbe>
  a2274e:	00a06937          	lui	s2,0xa06
  a22752:	66c90793          	addi	a5,s2,1644 # a0666c <g_uart_inited>
  a22756:	97aa                	add	a5,a5,a0
  a22758:	239c                	lbu	a5,0(a5)
  a2275a:	84aa                	mv	s1,a0
  a2275c:	66c90913          	addi	s2,s2,1644
  a22760:	4401                	li	s0,0
  a22762:	eba5                	bnez	a5,a227d2 <uapi_uart_init+0xba>
  a22764:	89ba                	mv	s3,a4
  a22766:	c636                	sw	a3,12(sp)
  a22768:	8432                	mv	s0,a2
  a2276a:	c42e                	sw	a1,8(sp)
  a2276c:	07f010ef          	jal	ra,a23fea <uart_port_config_pinmux>
  a22770:	06098763          	beqz	s3,a227de <uapi_uart_init+0xc6>
  a22774:	0009a683          	lw	a3,0(s3)
  a22778:	c2bd                	beqz	a3,a227de <uapi_uart_init+0xc6>
  a2277a:	0049a703          	lw	a4,4(s3)
  a2277e:	c325                	beqz	a4,a227de <uapi_uart_init+0xc6>
  a22780:	04c00513          	li	a0,76
  a22784:	02a48533          	mul	a0,s1,a0
  a22788:	00a0 6670 071f      	l.li	a4,0xa06670
  a2278e:	1897175b          	muliadd	a4,a4,s1,24
  a22792:	c754                	sw	a3,12(a4)
  a22794:	0049a683          	lw	a3,4(s3)
  a22798:	47b2                	lw	a5,12(sp)
  a2279a:	4622                	lw	a2,8(sp)
  a2279c:	ab16                	sh	a3,16(a4)
  a2279e:	00a0 66b8 071f      	l.li	a4,0xa066b8
  a227a4:	86a2                	mv	a3,s0
  a227a6:	00c50593          	addi	a1,a0,12
  a227aa:	95ba                	add	a1,a1,a4
  a227ac:	972a                	add	a4,a4,a0
  a227ae:	c30c                	sw	a1,0(a4)
  a227b0:	c34c                	sw	a1,4(a4)
  a227b2:	8526                	mv	a0,s1
  a227b4:	4711                	li	a4,4
  a227b6:	00a2 2570 059f      	l.li	a1,0xa22570
  a227bc:	483000ef          	jal	ra,a2343e <hal_uart_init>
  a227c0:	842a                	mv	s0,a0
  a227c2:	e901                	bnez	a0,a227d2 <uapi_uart_init+0xba>
  a227c4:	9926                	add	s2,s2,s1
  a227c6:	4785                	li	a5,1
  a227c8:	8526                	mv	a0,s1
  a227ca:	00f90023          	sb	a5,0(s2)
  a227ce:	02d010ef          	jal	ra,a23ffa <uart_port_register_irq>
  a227d2:	8522                	mv	a0,s0
  a227d4:	8154                	popret	{ra,s0-s3},48
  a227d6:	80000437          	lui	s0,0x80000
  a227da:	0405                	addi	s0,s0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a227dc:	bfdd                	j	a227d2 <uapi_uart_init+0xba>
  a227de:	8000 1044 041f      	l.li	s0,0x80001044
  a227e4:	b7fd                	j	a227d2 <uapi_uart_init+0xba>

00a227e6 <uapi_uart_deinit>:
  a227e6:	8048                	push	{ra,s0-s2},-16
  a227e8:	031575bb          	bgeui	a0,3,a2283e <uapi_uart_deinit+0x58>
  a227ec:	00a0 666c 091f      	l.li	s2,0xa0666c
  a227f2:	992a                	add	s2,s2,a0
  a227f4:	00094783          	lbu	a5,0(s2)
  a227f8:	842a                	mv	s0,a0
  a227fa:	4481                	li	s1,0
  a227fc:	cf9d                	beqz	a5,a2283a <uapi_uart_deinit+0x54>
  a227fe:	47f000ef          	jal	ra,a2347c <hal_uart_deinit>
  a22802:	84aa                	mv	s1,a0
  a22804:	8522                	mv	a0,s0
  a22806:	7f6010ef          	jal	ra,a23ffc <uart_port_unregister_irq>
  a2280a:	00a0 6670 051f      	l.li	a0,0xa06670
  a22810:	46e1                	li	a3,24
  a22812:	4601                	li	a2,0
  a22814:	45e1                	li	a1,24
  a22816:	1885155b          	muliadd	a0,a0,s0,24
  a2281a:	58b020ef          	jal	ra,a255a4 <memset_s>
  a2281e:	00a0 66b8 051f      	l.li	a0,0xa066b8
  a22824:	04c00693          	li	a3,76
  a22828:	4601                	li	a2,0
  a2282a:	04c00593          	li	a1,76
  a2282e:	4c85155b          	muliadd	a0,a0,s0,76
  a22832:	573020ef          	jal	ra,a255a4 <memset_s>
  a22836:	00090023          	sb	zero,0(s2)
  a2283a:	8526                	mv	a0,s1
  a2283c:	8044                	popret	{ra,s0-s2},16
  a2283e:	800004b7          	lui	s1,0x80000
  a22842:	0485                	addi	s1,s1,1 # 80000001 <__data_load__+0x7f5d85cd>
  a22844:	bfdd                	j	a2283a <uapi_uart_deinit+0x54>

00a22846 <uapi_uart_write>:
  a22846:	8178                	push	{ra,s0-s5},-48
  a22848:	84aa                	mv	s1,a0
  a2284a:	8a2e                	mv	s4,a1
  a2284c:	89b2                	mv	s3,a2
  a2284e:	000107a3          	sb	zero,15(sp)
  a22852:	befff0ef          	jal	ra,a22440 <uapi_uart_param_check>
  a22856:	892a                	mv	s2,a0
  a22858:	ed19                	bnez	a0,a22876 <uapi_uart_write+0x30>
  a2285a:	8526                	mv	a0,s1
  a2285c:	7d2010ef          	jal	ra,a2402e <uart_porting_lock>
  a22860:	8aaa                	mv	s5,a0
  a22862:	99d2                	add	s3,s3,s4
  a22864:	8452                	mv	s0,s4
  a22866:	41440933          	sub	s2,s0,s4
  a2286a:	00899863          	bne	s3,s0,a2287a <uapi_uart_write+0x34>
  a2286e:	85d6                	mv	a1,s5
  a22870:	8526                	mv	a0,s1
  a22872:	7c0010ef          	jal	ra,a24032 <uart_porting_unlock>
  a22876:	854a                	mv	a0,s2
  a22878:	8174                	popret	{ra,s0-s5},48
  a2287a:	00f10613          	addi	a2,sp,15
  a2287e:	459d                	li	a1,7
  a22880:	8526                	mv	a0,s1
  a22882:	431000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a22886:	00f14783          	lbu	a5,15(sp)
  a2288a:	f3e5                	bnez	a5,a2286a <uapi_uart_write+0x24>
  a2288c:	85a2                	mv	a1,s0
  a2288e:	00140913          	addi	s2,s0,1
  a22892:	4605                	li	a2,1
  a22894:	8526                	mv	a0,s1
  a22896:	3f9000ef          	jal	ra,a2348e <hal_uart_write>
  a2289a:	844a                	mv	s0,s2
  a2289c:	b7e9                	j	a22866 <uapi_uart_write+0x20>

00a2289e <uapi_uart_read>:
  a2289e:	8178                	push	{ra,s0-s5},-48
  a228a0:	84aa                	mv	s1,a0
  a228a2:	8a2e                	mv	s4,a1
  a228a4:	89b2                	mv	s3,a2
  a228a6:	b9bff0ef          	jal	ra,a22440 <uapi_uart_param_check>
  a228aa:	892a                	mv	s2,a0
  a228ac:	e10d                	bnez	a0,a228ce <uapi_uart_read+0x30>
  a228ae:	8526                	mv	a0,s1
  a228b0:	000107a3          	sb	zero,15(sp)
  a228b4:	77a010ef          	jal	ra,a2402e <uart_porting_lock>
  a228b8:	8aaa                	mv	s5,a0
  a228ba:	99d2                	add	s3,s3,s4
  a228bc:	8452                	mv	s0,s4
  a228be:	41440933          	sub	s2,s0,s4
  a228c2:	00899863          	bne	s3,s0,a228d2 <uapi_uart_read+0x34>
  a228c6:	85d6                	mv	a1,s5
  a228c8:	8526                	mv	a0,s1
  a228ca:	768010ef          	jal	ra,a24032 <uart_porting_unlock>
  a228ce:	854a                	mv	a0,s2
  a228d0:	8174                	popret	{ra,s0-s5},48
  a228d2:	00f10613          	addi	a2,sp,15
  a228d6:	45a5                	li	a1,9
  a228d8:	8526                	mv	a0,s1
  a228da:	3d9000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a228de:	00f14783          	lbu	a5,15(sp)
  a228e2:	f3e5                	bnez	a5,a228c2 <uapi_uart_read+0x24>
  a228e4:	85a2                	mv	a1,s0
  a228e6:	00140913          	addi	s2,s0,1
  a228ea:	4605                	li	a2,1
  a228ec:	8526                	mv	a0,s1
  a228ee:	3b3000ef          	jal	ra,a234a0 <hal_uart_read>
  a228f2:	844a                	mv	s0,s2
  a228f4:	b7e9                	j	a228be <uapi_uart_read+0x20>

00a228f6 <uapi_uart_rx_fifo_is_empty>:
  a228f6:	03057a3b          	bgeui	a0,3,a2291e <uapi_uart_rx_fifo_is_empty+0x28>
  a228fa:	00a0 666c 079f      	l.li	a5,0xa0666c
  a22900:	97aa                	add	a5,a5,a0
  a22902:	239c                	lbu	a5,0(a5)
  a22904:	cf91                	beqz	a5,a22920 <uapi_uart_rx_fifo_is_empty+0x2a>
  a22906:	8118                	push	{ra},-32
  a22908:	00f10613          	addi	a2,sp,15
  a2290c:	45a5                	li	a1,9
  a2290e:	000107a3          	sb	zero,15(sp)
  a22912:	3a1000ef          	jal	ra,a234b2 <hal_uart_ctrl>
  a22916:	00f14783          	lbu	a5,15(sp)
  a2291a:	853e                	mv	a0,a5
  a2291c:	8114                	popret	{ra},32
  a2291e:	4781                	li	a5,0
  a22920:	853e                	mv	a0,a5
  a22922:	8082                	ret

00a22924 <uapi_watchdog_init>:
  a22924:	8058                	push	{ra,s0-s3},-32
  a22926:	89aa                	mv	s3,a0
  a22928:	746010ef          	jal	ra,a2406e <watchdog_port_register_hal_funcs>
  a2292c:	752010ef          	jal	ra,a2407e <watchdog_port_register_irq>
  a22930:	f50ff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22934:	84aa                	mv	s1,a0
  a22936:	7c7000ef          	jal	ra,a238fc <hal_watchdog_get_funcs>
  a2293a:	411c                	lw	a5,0(a0)
  a2293c:	00a0 679c 091f      	l.li	s2,0xa0679c
  a22942:	00a92023          	sw	a0,0(s2)
  a22946:	9782                	jalr	a5
  a22948:	c519                	beqz	a0,a22956 <uapi_watchdog_init+0x32>
  a2294a:	842a                	mv	s0,a0
  a2294c:	8526                	mv	a0,s1
  a2294e:	f3aff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22952:	8522                	mv	a0,s0
  a22954:	8054                	popret	{ra,s0-s3},32
  a22956:	00092783          	lw	a5,0(s2)
  a2295a:	854e                	mv	a0,s3
  a2295c:	479c                	lw	a5,8(a5)
  a2295e:	9782                	jalr	a5
  a22960:	842a                	mv	s0,a0
  a22962:	8526                	mv	a0,s1
  a22964:	f24ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22968:	f46d                	bnez	s0,a22952 <uapi_watchdog_init+0x2e>
  a2296a:	00a0 67a1 079f      	l.li	a5,0xa067a1
  a22970:	4705                	li	a4,1
  a22972:	a398                	sb	a4,0(a5)
  a22974:	bff9                	j	a22952 <uapi_watchdog_init+0x2e>

00a22976 <uapi_watchdog_enable>:
  a22976:	00a0 67a1 079f      	l.li	a5,0xa067a1
  a2297c:	239c                	lbu	a5,0(a5)
  a2297e:	cb9d                	beqz	a5,a229b4 <uapi_watchdog_enable+0x3e>
  a22980:	8048                	push	{ra,s0-s2},-16
  a22982:	4485                	li	s1,1
  a22984:	57fd                	li	a5,-1
  a22986:	02a4e563          	bltu	s1,a0,a229b0 <uapi_watchdog_enable+0x3a>
  a2298a:	842a                	mv	s0,a0
  a2298c:	ef4ff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22990:	00a0 679c 079f      	l.li	a5,0xa0679c
  a22996:	439c                	lw	a5,0(a5)
  a22998:	892a                	mv	s2,a0
  a2299a:	8522                	mv	a0,s0
  a2299c:	4b9c                	lw	a5,16(a5)
  a2299e:	9782                	jalr	a5
  a229a0:	854a                	mv	a0,s2
  a229a2:	ee6ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a229a6:	00a0 67a0 079f      	l.li	a5,0xa067a0
  a229ac:	a384                	sb	s1,0(a5)
  a229ae:	4781                	li	a5,0
  a229b0:	853e                	mv	a0,a5
  a229b2:	8044                	popret	{ra,s0-s2},16
  a229b4:	57fd                	li	a5,-1
  a229b6:	853e                	mv	a0,a5
  a229b8:	8082                	ret

00a229ba <uapi_watchdog_disable>:
  a229ba:	00a0 67a1 079f      	l.li	a5,0xa067a1
  a229c0:	239c                	lbu	a5,0(a5)
  a229c2:	e399                	bnez	a5,a229c8 <uapi_watchdog_disable+0xe>
  a229c4:	557d                	li	a0,-1
  a229c6:	8082                	ret
  a229c8:	8118                	push	{ra},-32
  a229ca:	eb6ff0ef          	jal	ra,a22080 <osal_irq_lock>
  a229ce:	00a0 679c 079f      	l.li	a5,0xa0679c
  a229d4:	439c                	lw	a5,0(a5)
  a229d6:	c62a                	sw	a0,12(sp)
  a229d8:	4bdc                	lw	a5,20(a5)
  a229da:	9782                	jalr	a5
  a229dc:	4532                	lw	a0,12(sp)
  a229de:	eaaff0ef          	jal	ra,a22088 <osal_irq_restore>
  a229e2:	00a0 67a0 079f      	l.li	a5,0xa067a0
  a229e8:	00078023          	sb	zero,0(a5)
  a229ec:	4501                	li	a0,0
  a229ee:	8114                	popret	{ra},32

00a229f0 <uapi_watchdog_deinit>:
  a229f0:	00a067b7          	lui	a5,0xa06
  a229f4:	7a17c703          	lbu	a4,1953(a5) # a067a1 <g_watchdog_inited>
  a229f8:	c71d                	beqz	a4,a22a26 <uapi_watchdog_deinit+0x36>
  a229fa:	8028                	push	{ra,s0},-16
  a229fc:	7a178413          	addi	s0,a5,1953
  a22a00:	00a0 67a0 079f      	l.li	a5,0xa067a0
  a22a06:	239c                	lbu	a5,0(a5)
  a22a08:	c391                	beqz	a5,a22a0c <uapi_watchdog_deinit+0x1c>
  a22a0a:	3f45                	jal	ra,a229ba <uapi_watchdog_disable>
  a22a0c:	00a0 679c 079f      	l.li	a5,0xa0679c
  a22a12:	439c                	lw	a5,0(a5)
  a22a14:	c399                	beqz	a5,a22a1a <uapi_watchdog_deinit+0x2a>
  a22a16:	43dc                	lw	a5,4(a5)
  a22a18:	9782                	jalr	a5
  a22a1a:	660010ef          	jal	ra,a2407a <watchdog_port_unregister_hal_funcs>
  a22a1e:	4501                	li	a0,0
  a22a20:	00040023          	sb	zero,0(s0)
  a22a24:	8024                	popret	{ra,s0},16
  a22a26:	4501                	li	a0,0
  a22a28:	8082                	ret

00a22a2a <uapi_watchdog_kick>:
  a22a2a:	00a0 67a0 079f      	l.li	a5,0xa067a0
  a22a30:	239c                	lbu	a5,0(a5)
  a22a32:	e399                	bnez	a5,a22a38 <uapi_watchdog_kick+0xe>
  a22a34:	557d                	li	a0,-1
  a22a36:	8082                	ret
  a22a38:	8118                	push	{ra},-32
  a22a3a:	e46ff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22a3e:	00a0 679c 079f      	l.li	a5,0xa0679c
  a22a44:	439c                	lw	a5,0(a5)
  a22a46:	c62a                	sw	a0,12(sp)
  a22a48:	4f9c                	lw	a5,24(a5)
  a22a4a:	9782                	jalr	a5
  a22a4c:	4532                	lw	a0,12(sp)
  a22a4e:	e3aff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22a52:	4501                	li	a0,0
  a22a54:	8114                	popret	{ra},32

00a22a56 <uapi_efuse_init>:
  a22a56:	8018                	push	{ra},-16
  a22a58:	627010ef          	jal	ra,a2487e <efuse_port_register_hal_funcs>
  a22a5c:	22a9                	jal	ra,a22ba6 <hal_efuse_get_funcs>
  a22a5e:	00052303          	lw	t1,0(a0)
  a22a62:	8010                	pop	{ra},16
  a22a64:	8302                	jr	t1

00a22a66 <uapi_efuse_read_bit>:
  a22a66:	8168                	push	{ra,s0-s4},-48
  a22a68:	000107a3          	sb	zero,15(sp)
  a22a6c:	547d                	li	s0,-1
  a22a6e:	0ff00793          	li	a5,255
  a22a72:	02b7ee63          	bltu	a5,a1,a22aae <uapi_efuse_read_bit+0x48>
  a22a76:	cd05                	beqz	a0,a22aae <uapi_efuse_read_bit+0x48>
  a22a78:	08067dbb          	bgeui	a2,8,a22aae <uapi_efuse_read_bit+0x48>
  a22a7c:	842e                	mv	s0,a1
  a22a7e:	8932                	mv	s2,a2
  a22a80:	84aa                	mv	s1,a0
  a22a82:	2215                	jal	ra,a22ba6 <hal_efuse_get_funcs>
  a22a84:	8a2a                	mv	s4,a0
  a22a86:	dfaff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22a8a:	010a2783          	lw	a5,16(s4)
  a22a8e:	89aa                	mv	s3,a0
  a22a90:	00f10593          	addi	a1,sp,15
  a22a94:	8522                	mv	a0,s0
  a22a96:	9782                	jalr	a5
  a22a98:	842a                	mv	s0,a0
  a22a9a:	ed01                	bnez	a0,a22ab2 <uapi_efuse_read_bit+0x4c>
  a22a9c:	00f14783          	lbu	a5,15(sp)
  a22aa0:	854e                	mv	a0,s3
  a22aa2:	4127d633          	sra	a2,a5,s2
  a22aa6:	8a05                	andi	a2,a2,1
  a22aa8:	a090                	sb	a2,0(s1)
  a22aaa:	ddeff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22aae:	8522                	mv	a0,s0
  a22ab0:	8164                	popret	{ra,s0-s4},48
  a22ab2:	854e                	mv	a0,s3
  a22ab4:	dd4ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22ab8:	547d                	li	s0,-1
  a22aba:	bfd5                	j	a22aae <uapi_efuse_read_bit+0x48>

00a22abc <uapi_efuse_read_buffer>:
  a22abc:	8088                	push	{ra,s0-s6},-32
  a22abe:	547d                	li	s0,-1
  a22ac0:	c231                	beqz	a2,a22b04 <uapi_efuse_read_buffer+0x48>
  a22ac2:	0ff00793          	li	a5,255
  a22ac6:	02b7ef63          	bltu	a5,a1,a22b04 <uapi_efuse_read_buffer+0x48>
  a22aca:	00c587b3          	add	a5,a1,a2
  a22ace:	10000713          	li	a4,256
  a22ad2:	02f76963          	bltu	a4,a5,a22b04 <uapi_efuse_read_buffer+0x48>
  a22ad6:	c51d                	beqz	a0,a22b04 <uapi_efuse_read_buffer+0x48>
  a22ad8:	8932                	mv	s2,a2
  a22ada:	89ae                	mv	s3,a1
  a22adc:	8a2a                	mv	s4,a0
  a22ade:	20e1                	jal	ra,a22ba6 <hal_efuse_get_funcs>
  a22ae0:	8b2a                	mv	s6,a0
  a22ae2:	d9eff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22ae6:	8aaa                	mv	s5,a0
  a22ae8:	4481                	li	s1,0
  a22aea:	010b2783          	lw	a5,16(s6) # 2010 <ccause+0x104e>
  a22aee:	009a05b3          	add	a1,s4,s1
  a22af2:	00998533          	add	a0,s3,s1
  a22af6:	9782                	jalr	a5
  a22af8:	842a                	mv	s0,a0
  a22afa:	c519                	beqz	a0,a22b08 <uapi_efuse_read_buffer+0x4c>
  a22afc:	8556                	mv	a0,s5
  a22afe:	d8aff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22b02:	547d                	li	s0,-1
  a22b04:	8522                	mv	a0,s0
  a22b06:	8084                	popret	{ra,s0-s6},32
  a22b08:	0485                	addi	s1,s1,1
  a22b0a:	ff24e0e3          	bltu	s1,s2,a22aea <uapi_efuse_read_buffer+0x2e>
  a22b0e:	8556                	mv	a0,s5
  a22b10:	d78ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22b14:	bfc5                	j	a22b04 <uapi_efuse_read_buffer+0x48>

00a22b16 <uapi_efuse_write_bit>:
  a22b16:	8168                	push	{ra,s0-s4},-48
  a22b18:	547d                	li	s0,-1
  a22b1a:	0ff00793          	li	a5,255
  a22b1e:	04a7e463          	bltu	a5,a0,a22b66 <uapi_efuse_write_bit+0x50>
  a22b22:	0815f13b          	bgeui	a1,8,a22b66 <uapi_efuse_write_bit+0x50>
  a22b26:	892e                	mv	s2,a1
  a22b28:	84aa                	mv	s1,a0
  a22b2a:	000107a3          	sb	zero,15(sp)
  a22b2e:	28a5                	jal	ra,a22ba6 <hal_efuse_get_funcs>
  a22b30:	8a2a                	mv	s4,a0
  a22b32:	d4eff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22b36:	010a2783          	lw	a5,16(s4)
  a22b3a:	89aa                	mv	s3,a0
  a22b3c:	00f10593          	addi	a1,sp,15
  a22b40:	8526                	mv	a0,s1
  a22b42:	9782                	jalr	a5
  a22b44:	c509                	beqz	a0,a22b4e <uapi_efuse_write_bit+0x38>
  a22b46:	854e                	mv	a0,s3
  a22b48:	d40ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22b4c:	a829                	j	a22b66 <uapi_efuse_write_bit+0x50>
  a22b4e:	00f14783          	lbu	a5,15(sp)
  a22b52:	0127d7b3          	srl	a5,a5,s2
  a22b56:	8b85                	andi	a5,a5,1
  a22b58:	cb89                	beqz	a5,a22b6a <uapi_efuse_write_bit+0x54>
  a22b5a:	854e                	mv	a0,s3
  a22b5c:	80000437          	lui	s0,0x80000
  a22b60:	d28ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22b64:	0405                	addi	s0,s0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a22b66:	8522                	mv	a0,s0
  a22b68:	8164                	popret	{ra,s0-s4},48
  a22b6a:	8526                	mv	a0,s1
  a22b6c:	51f010ef          	jal	ra,a2488a <hal_efuse_get_region>
  a22b70:	4585                	li	a1,1
  a22b72:	01ca2783          	lw	a5,28(s4)
  a22b76:	012595b3          	sll	a1,a1,s2
  a22b7a:	862a                	mv	a2,a0
  a22b7c:	9d81                	uxtb	a1
  a22b7e:	8526                	mv	a0,s1
  a22b80:	9782                	jalr	a5
  a22b82:	842a                	mv	s0,a0
  a22b84:	854e                	mv	a0,s3
  a22b86:	d069                	beqz	s0,a22b48 <uapi_efuse_write_bit+0x32>
  a22b88:	d00ff0ef          	jal	ra,a22088 <osal_irq_restore>
  a22b8c:	547d                	li	s0,-1
  a22b8e:	bfe1                	j	a22b66 <uapi_efuse_write_bit+0x50>

00a22b90 <hal_efuse_register_funcs>:
  a22b90:	c519                	beqz	a0,a22b9e <hal_efuse_register_funcs+0xe>
  a22b92:	00a0 67a4 079f      	l.li	a5,0xa067a4
  a22b98:	c388                	sw	a0,0(a5)
  a22b9a:	4501                	li	a0,0
  a22b9c:	8082                	ret
  a22b9e:	80000537          	lui	a0,0x80000
  a22ba2:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a22ba4:	8082                	ret

00a22ba6 <hal_efuse_get_funcs>:
  a22ba6:	00a0 67a4 079f      	l.li	a5,0xa067a4
  a22bac:	4388                	lw	a0,0(a5)
  a22bae:	8082                	ret

00a22bb0 <hal_efuse_deinit>:
  a22bb0:	00a0 67a8 079f      	l.li	a5,0xa067a8
  a22bb6:	00078023          	sb	zero,0(a5)
  a22bba:	8082                	ret

00a22bbc <hal_efuse_get_writeread_addr>:
  a22bbc:	8038                	push	{ra,s0-s1},-16
  a22bbe:	84aa                	mv	s1,a0
  a22bc0:	4cb010ef          	jal	ra,a2488a <hal_efuse_get_region>
  a22bc4:	842a                	mv	s0,a0
  a22bc6:	8526                	mv	a0,s1
  a22bc8:	4c9010ef          	jal	ra,a24890 <hal_efuse_get_byte_offset>
  a22bcc:	00a0 2490 079f      	l.li	a5,0xa02490
  a22bd2:	0487879b          	addshf	a5,a5,s0,sll,2
  a22bd6:	439c                	lw	a5,0(a5)
  a22bd8:	8105                	srli	a0,a0,0x1
  a22bda:	9d21                	uxth	a0
  a22bdc:	04a7851b          	addshf	a0,a5,a0,sll,2
  a22be0:	8034                	popret	{ra,s0-s1},16

00a22be2 <hal_efuse_init>:
  a22be2:	8018                	push	{ra},-16
  a22be4:	4501                	li	a0,0
  a22be6:	2255                	jal	ra,a22d8a <hal_efuse_regs_init>
  a22be8:	00a067b7          	lui	a5,0xa06
  a22bec:	7b07a703          	lw	a4,1968(a5) # a067b0 <g_efuse_regs>
  a22bf0:	00a0 2400 069f      	l.li	a3,0xa02400
  a22bf6:	2294                	lbu	a3,0(a3)
  a22bf8:	435c                	lw	a5,4(a4)
  a22bfa:	4501                	li	a0,0
  a22bfc:	f007f793          	andi	a5,a5,-256
  a22c00:	8fd5                	or	a5,a5,a3
  a22c02:	c35c                	sw	a5,4(a4)
  a22c04:	00a0 67a8 079f      	l.li	a5,0xa067a8
  a22c0a:	4705                	li	a4,1
  a22c0c:	a398                	sb	a4,0(a5)
  a22c0e:	8014                	popret	{ra},16

00a22c10 <hal_efuse_read_byte>:
  a22c10:	00a0 67a8 079f      	l.li	a5,0xa067a8
  a22c16:	239c                	lbu	a5,0(a5)
  a22c18:	c7a1                	beqz	a5,a22c60 <hal_efuse_read_byte+0x50>
  a22c1a:	8048                	push	{ra,s0-s2},-16
  a22c1c:	842a                	mv	s0,a0
  a22c1e:	0ff00793          	li	a5,255
  a22c22:	04a7e363          	bltu	a5,a0,a22c68 <hal_efuse_read_byte+0x58>
  a22c26:	c1a9                	beqz	a1,a22c68 <hal_efuse_read_byte+0x58>
  a22c28:	84ae                	mv	s1,a1
  a22c2a:	3f49                	jal	ra,a22bbc <hal_efuse_get_writeread_addr>
  a22c2c:	892a                	mv	s2,a0
  a22c2e:	8522                	mv	a0,s0
  a22c30:	45b010ef          	jal	ra,a2488a <hal_efuse_get_region>
  a22c34:	00a0 67b0 079f      	l.li	a5,0xa067b0
  a22c3a:	04a7851b          	addshf	a0,a5,a0,sll,2
  a22c3e:	4118                	lw	a4,0(a0)
  a22c40:	76c1                	lui	a3,0xffff0
  a22c42:	8805                	andi	s0,s0,1
  a22c44:	431c                	lw	a5,0(a4)
  a22c46:	8ff5                	and	a5,a5,a3
  a22c48:	0000 5a5a 069f      	l.li	a3,0x5a5a
  a22c4e:	8fd5                	or	a5,a5,a3
  a22c50:	c31c                	sw	a5,0(a4)
  a22c52:	00092783          	lw	a5,0(s2)
  a22c56:	c011                	beqz	s0,a22c5a <hal_efuse_read_byte+0x4a>
  a22c58:	83a1                	srli	a5,a5,0x8
  a22c5a:	a09c                	sb	a5,0(s1)
  a22c5c:	4501                	li	a0,0
  a22c5e:	8044                	popret	{ra,s0-s2},16
  a22c60:	8000 1391 051f      	l.li	a0,0x80001391
  a22c66:	8082                	ret
  a22c68:	80000537          	lui	a0,0x80000
  a22c6c:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a22c6e:	bfc5                	j	a22c5e <hal_efuse_read_byte+0x4e>

00a22c70 <hal_efuse_get_die_id>:
  a22c70:	00a0 67a8 079f      	l.li	a5,0xa067a8
  a22c76:	239c                	lbu	a5,0(a5)
  a22c78:	ef99                	bnez	a5,a22c96 <hal_efuse_get_die_id+0x26>
  a22c7a:	8000 1391 051f      	l.li	a0,0x80001391
  a22c80:	8082                	ret
  a22c82:	008905b3          	add	a1,s2,s0
  a22c86:	8522                	mv	a0,s0
  a22c88:	3761                	jal	ra,a22c10 <hal_efuse_read_byte>
  a22c8a:	e919                	bnez	a0,a22ca0 <hal_efuse_get_die_id+0x30>
  a22c8c:	0405                	addi	s0,s0,1
  a22c8e:	fe946ae3          	bltu	s0,s1,a22c82 <hal_efuse_get_die_id+0x12>
  a22c92:	4501                	li	a0,0
  a22c94:	8044                	popret	{ra,s0-s2},16
  a22c96:	8048                	push	{ra,s0-s2},-16
  a22c98:	892a                	mv	s2,a0
  a22c9a:	84ae                	mv	s1,a1
  a22c9c:	4401                	li	s0,0
  a22c9e:	bfc5                	j	a22c8e <hal_efuse_get_die_id+0x1e>
  a22ca0:	557d                	li	a0,-1
  a22ca2:	bfcd                	j	a22c94 <hal_efuse_get_die_id+0x24>

00a22ca4 <hal_efuse_write_operation>:
  a22ca4:	00a0 67a8 079f      	l.li	a5,0xa067a8
  a22caa:	239c                	lbu	a5,0(a5)
  a22cac:	c3c1                	beqz	a5,a22d2c <hal_efuse_write_operation+0x88>
  a22cae:	8058                	push	{ra,s0-s3},-32
  a22cb0:	842a                	mv	s0,a0
  a22cb2:	0ff00793          	li	a5,255
  a22cb6:	06a7ef63          	bltu	a5,a0,a22d34 <hal_efuse_write_operation+0x90>
  a22cba:	00a064b7          	lui	s1,0xa06
  a22cbe:	892e                	mv	s2,a1
  a22cc0:	7b048993          	addi	s3,s1,1968 # a067b0 <g_efuse_regs>
  a22cc4:	3c7010ef          	jal	ra,a2488a <hal_efuse_get_region>
  a22cc8:	04a9851b          	addshf	a0,s3,a0,sll,2
  a22ccc:	4118                	lw	a4,0(a0)
  a22cce:	76c1                	lui	a3,0xffff0
  a22cd0:	8522                	mv	a0,s0
  a22cd2:	431c                	lw	a5,0(a4)
  a22cd4:	7b048493          	addi	s1,s1,1968
  a22cd8:	8ff5                	and	a5,a5,a3
  a22cda:	0000 a5a5 069f      	l.li	a3,0xa5a5
  a22ce0:	8fd5                	or	a5,a5,a3
  a22ce2:	c31c                	sw	a5,0(a4)
  a22ce4:	3a7010ef          	jal	ra,a2488a <hal_efuse_get_region>
  a22ce8:	04a9851b          	addshf	a0,s3,a0,sll,2
  a22cec:	4118                	lw	a4,0(a0)
  a22cee:	06400513          	li	a0,100
  a22cf2:	475c                	lw	a5,12(a4)
  a22cf4:	0017e793          	ori	a5,a5,1
  a22cf8:	c75c                	sw	a5,12(a4)
  a22cfa:	edeff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a22cfe:	8522                	mv	a0,s0
  a22d00:	3d75                	jal	ra,a22bbc <hal_efuse_get_writeread_addr>
  a22d02:	00147793          	andi	a5,s0,1
  a22d06:	c391                	beqz	a5,a22d0a <hal_efuse_write_operation+0x66>
  a22d08:	0922                	slli	s2,s2,0x8
  a22d0a:	01252023          	sw	s2,0(a0)
  a22d0e:	8522                	mv	a0,s0
  a22d10:	37b010ef          	jal	ra,a2488a <hal_efuse_get_region>
  a22d14:	04a4849b          	addshf	s1,s1,a0,sll,2
  a22d18:	4098                	lw	a4,0(s1)
  a22d1a:	06400513          	li	a0,100
  a22d1e:	475c                	lw	a5,12(a4)
  a22d20:	9bf9                	andi	a5,a5,-2
  a22d22:	c75c                	sw	a5,12(a4)
  a22d24:	eb4ff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a22d28:	4501                	li	a0,0
  a22d2a:	8054                	popret	{ra,s0-s3},32
  a22d2c:	8000 1391 051f      	l.li	a0,0x80001391
  a22d32:	8082                	ret
  a22d34:	80000537          	lui	a0,0x80000
  a22d38:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a22d3a:	bfc5                	j	a22d2a <hal_efuse_write_operation+0x86>

00a22d3c <hal_efuse_write_buffer_operation>:
  a22d3c:	00a0 67a8 079f      	l.li	a5,0xa067a8
  a22d42:	239c                	lbu	a5,0(a5)
  a22d44:	c795                	beqz	a5,a22d70 <hal_efuse_write_buffer_operation+0x34>
  a22d46:	8058                	push	{ra,s0-s3},-32
  a22d48:	89b2                	mv	s3,a2
  a22d4a:	842e                	mv	s0,a1
  a22d4c:	84ae                	mv	s1,a1
  a22d4e:	40b50933          	sub	s2,a0,a1
  a22d52:	408487b3          	sub	a5,s1,s0
  a22d56:	0137e463          	bltu	a5,s3,a22d5e <hal_efuse_write_buffer_operation+0x22>
  a22d5a:	4501                	li	a0,0
  a22d5c:	8054                	popret	{ra,s0-s3},32
  a22d5e:	208c                	lbu	a1,0(s1)
  a22d60:	00990533          	add	a0,s2,s1
  a22d64:	4601                	li	a2,0
  a22d66:	3f3d                	jal	ra,a22ca4 <hal_efuse_write_operation>
  a22d68:	0485                	addi	s1,s1,1
  a22d6a:	d565                	beqz	a0,a22d52 <hal_efuse_write_buffer_operation+0x16>
  a22d6c:	557d                	li	a0,-1
  a22d6e:	b7fd                	j	a22d5c <hal_efuse_write_buffer_operation+0x20>
  a22d70:	8000 1391 051f      	l.li	a0,0x80001391
  a22d76:	8082                	ret

00a22d78 <hal_efuse_set_clock_period>:
  a22d78:	00a0 2400 079f      	l.li	a5,0xa02400
  a22d7e:	c388                	sw	a0,0(a5)
  a22d80:	8082                	ret

00a22d82 <hal_efuse_funcs_get>:
  a22d82:	00a0 2404 051f      	l.li	a0,0xa02404
  a22d88:	8082                	ret

00a22d8a <hal_efuse_regs_init>:
  a22d8a:	02a04763          	bgtz	a0,a22db8 <hal_efuse_regs_init+0x2e>
  a22d8e:	050a                	slli	a0,a0,0x2
  a22d90:	00a0 2488 071f      	l.li	a4,0xa02488
  a22d96:	00a0 67b0 079f      	l.li	a5,0xa067b0
  a22d9c:	97aa                	add	a5,a5,a0
  a22d9e:	953a                	add	a0,a0,a4
  a22da0:	4118                	lw	a4,0(a0)
  a22da2:	4501                	li	a0,0
  a22da4:	c398                	sw	a4,0(a5)
  a22da6:	00a027b7          	lui	a5,0xa02
  a22daa:	48c7a703          	lw	a4,1164(a5) # a0248c <g_efuse_boot_done_addr>
  a22dae:	00a0 67ac 079f      	l.li	a5,0xa067ac
  a22db4:	c398                	sw	a4,0(a5)
  a22db6:	8082                	ret
  a22db8:	557d                	li	a0,-1
  a22dba:	8082                	ret

00a22dbc <hal_reboot_chip>:
  a22dbc:	8018                	push	{ra},-16
  a22dbe:	ac2ff0ef          	jal	ra,a22080 <osal_irq_lock>
  a22dc2:	678020ef          	jal	ra,a2543a <set_cpu_utils_system_boot_magic>
  a22dc6:	331010ef          	jal	ra,a248f6 <reboot_port_reboot_chip>
  a22dca:	a001                	j	a22dca <hal_reboot_chip+0xe>

00a22dcc <crypto_cache_flush>:
  a22dcc:	8082                	ret

00a22dce <crypto_wait_func_is_support>:
  a22dce:	4501                	li	a0,0
  a22dd0:	8082                	ret

00a22dd2 <hal_pke_init>:
  a22dd2:	00a0 67bc 079f      	l.li	a5,0xa067bc
  a22dd8:	4394                	lw	a3,0(a5)
  a22dda:	4705                	li	a4,1
  a22ddc:	00e68363          	beq	a3,a4,a22de2 <hal_pke_init+0x10>
  a22de0:	c398                	sw	a4,0(a5)
  a22de2:	4501                	li	a0,0
  a22de4:	8082                	ret

00a22de6 <hal_pke_deinit>:
  a22de6:	00a0 67bc 079f      	l.li	a5,0xa067bc
  a22dec:	4398                	lw	a4,0(a5)
  a22dee:	0107133b          	bnei	a4,1,a22dfa <hal_pke_deinit+0x14>
  a22df2:	0007a023          	sw	zero,0(a5)
  a22df6:	4501                	li	a0,0
  a22df8:	8082                	ret
  a22dfa:	6530 0002 051f      	l.li	a0,0x65300002
  a22e00:	8082                	ret

00a22e02 <hal_pke_unlock>:
  a22e02:	44111737          	lui	a4,0x44111
  a22e06:	81072783          	lw	a5,-2032(a4) # 44110810 <__data_load__+0x436e8ddc>
  a22e0a:	0037e793          	ori	a5,a5,3
  a22e0e:	80f72823          	sw	a5,-2032(a4)
  a22e12:	0ff0000f          	fence
  a22e16:	8082                	ret

00a22e18 <hal_hash_condition>:
  a22e18:	411c                	lw	a5,0(a0)
  a22e1a:	00a0 67c4 071f      	l.li	a4,0xa067c4
  a22e20:	1cf717db          	muliadd	a5,a4,a5,28
  a22e24:	3bd8                	lbu	a4,21(a5)
  a22e26:	0107133b          	bnei	a4,1,a22e32 <hal_hash_condition+0x1a>
  a22e2a:	00078aa3          	sb	zero,21(a5)
  a22e2e:	4505                	li	a0,1
  a22e30:	8082                	ret
  a22e32:	4501                	li	a0,0
  a22e34:	8082                	ret

00a22e36 <hal_cipher_hash_init>:
  a22e36:	8048                	push	{ra,s0-s2},-16
  a22e38:	00a0 67c0 049f      	l.li	s1,0xa067c0
  a22e3e:	209c                	lbu	a5,0(s1)
  a22e40:	4905                	li	s2,1
  a22e42:	05278563          	beq	a5,s2,a22e8c <hal_cipher_hash_init+0x56>
  a22e46:	00a06537          	lui	a0,0xa06
  a22e4a:	7c450413          	addi	s0,a0,1988 # a067c4 <g_hash_hard_ctx>
  a22e4e:	05400693          	li	a3,84
  a22e52:	4601                	li	a2,0
  a22e54:	05400593          	li	a1,84
  a22e58:	7c450513          	addi	a0,a0,1988
  a22e5c:	748020ef          	jal	ra,a255a4 <memset_s>
  a22e60:	00a0 6818 079f      	l.li	a5,0xa06818
  a22e66:	4709                	li	a4,2
  a22e68:	02078693          	addi	a3,a5,32
  a22e6c:	c01c                	sw	a5,0(s0)
  a22e6e:	04078793          	addi	a5,a5,64
  a22e72:	c418                	sw	a4,8(s0)
  a22e74:	00042223          	sw	zero,4(s0)
  a22e78:	cc54                	sw	a3,28(s0)
  a22e7a:	d058                	sw	a4,36(s0)
  a22e7c:	02042023          	sw	zero,32(s0)
  a22e80:	dc1c                	sw	a5,56(s0)
  a22e82:	c038                	sw	a4,64(s0)
  a22e84:	02042e23          	sw	zero,60(s0)
  a22e88:	01248023          	sb	s2,0(s1)
  a22e8c:	4501                	li	a0,0
  a22e8e:	8044                	popret	{ra,s0-s2},16

00a22e90 <hal_hash_unlock>:
  a22e90:	441007b7          	lui	a5,0x44100
  a22e94:	43b8                	lw	a4,64(a5)
  a22e96:	00251693          	slli	a3,a0,0x2
  a22e9a:	453d                	li	a0,15
  a22e9c:	00d51533          	sll	a0,a0,a3
  a22ea0:	fff54513          	not	a0,a0
  a22ea4:	8d79                	and	a0,a0,a4
  a22ea6:	c3a8                	sw	a0,64(a5)
  a22ea8:	0ff0000f          	fence
  a22eac:	4501                	li	a0,0
  a22eae:	8082                	ret

00a22eb0 <hal_cipher_hash_deinit>:
  a22eb0:	8038                	push	{ra,s0-s1},-16
  a22eb2:	00a0 67c0 041f      	l.li	s0,0xa067c0
  a22eb8:	201c                	lbu	a5,0(s0)
  a22eba:	c78d                	beqz	a5,a22ee4 <hal_cipher_hash_deinit+0x34>
  a22ebc:	00a0 67c4 079f      	l.li	a5,0xa067c4
  a22ec2:	4501                	li	a0,0
  a22ec4:	4384                	lw	s1,0(a5)
  a22ec6:	37e9                	jal	ra,a22e90 <hal_hash_unlock>
  a22ec8:	4505                	li	a0,1
  a22eca:	37d9                	jal	ra,a22e90 <hal_hash_unlock>
  a22ecc:	4509                	li	a0,2
  a22ece:	37c9                	jal	ra,a22e90 <hal_hash_unlock>
  a22ed0:	06000693          	li	a3,96
  a22ed4:	4601                	li	a2,0
  a22ed6:	06000593          	li	a1,96
  a22eda:	8526                	mv	a0,s1
  a22edc:	6c8020ef          	jal	ra,a255a4 <memset_s>
  a22ee0:	00040023          	sb	zero,0(s0)
  a22ee4:	4501                	li	a0,0
  a22ee6:	8034                	popret	{ra,s0-s1},16

00a22ee8 <hal_cipher_hash_config>:
  a22ee8:	00a0 67c0 079f      	l.li	a5,0xa067c0
  a22eee:	239c                	lbu	a5,0(a5)
  a22ef0:	872a                	mv	a4,a0
  a22ef2:	557d                	li	a0,-1
  a22ef4:	01279a3b          	bnei	a5,1,a22f9c <hal_cipher_hash_config+0xb4>
  a22ef8:	0437743b          	bgeui	a4,4,a22fc8 <hal_cipher_hash_config+0xe0>
  a22efc:	c671                	beqz	a2,a22fc8 <hal_cipher_hash_config+0xe0>
  a22efe:	0125d793          	srli	a5,a1,0x12
  a22f02:	00a276b7          	lui	a3,0xa27
  a22f06:	03c7f793          	andi	a5,a5,60
  a22f0a:	eb468693          	addi	a3,a3,-332 # a26eb4 <g_crypto_ecc_params+0x14>
  a22f0e:	97b6                	add	a5,a5,a3
  a22f10:	439c                	lw	a5,0(a5)
  a22f12:	8782                	jr	a5
  a22f14:	02000693          	li	a3,32
  a22f18:	45ad                	li	a1,11
  a22f1a:	4501                	li	a0,0
  a22f1c:	a829                	j	a22f36 <hal_cipher_hash_config+0x4e>
  a22f1e:	81e1                	srli	a1,a1,0x18
  a22f20:	89bd                	andi	a1,a1,15
  a22f22:	0125853b          	beqi	a1,1,a22fb6 <hal_cipher_hash_config+0xce>
  a22f26:	022586bb          	beqi	a1,2,a22fc0 <hal_cipher_hash_config+0xd8>
  a22f2a:	557d                	li	a0,-1
  a22f2c:	8082                	ret
  a22f2e:	04000693          	li	a3,64
  a22f32:	45ad                	li	a1,11
  a22f34:	450d                	li	a0,3
  a22f36:	00ff ffff 081f      	l.li	a6,0xffffff
  a22f3c:	010707b3          	add	a5,a4,a6
  a22f40:	4410 5110 081f      	l.li	a6,0x44105110
  a22f46:	10f8081b          	addshf	a6,a6,a5,sll,8
  a22f4a:	00082783          	lw	a5,0(a6)
  a22f4e:	ff0f ffff 089f      	l.li	a7,0xff0fffff
  a22f54:	0117f7b3          	and	a5,a5,a7
  a22f58:	28a7a79b          	orshf	a5,a5,a0,sll,20
  a22f5c:	fff0 ffff 051f      	l.li	a0,0xfff0ffff
  a22f62:	8fe9                	and	a5,a5,a0
  a22f64:	20b7a79b          	orshf	a5,a5,a1,sll,16
  a22f68:	00f82023          	sw	a5,0(a6)
  a22f6c:	0ff0000f          	fence
  a22f70:	4410a537          	lui	a0,0x4410a
  a22f74:	071e                	slli	a4,a4,0x7
  a22f76:	00450593          	addi	a1,a0,4 # 4410a004 <__data_load__+0x436e25d0>
  a22f7a:	95ba                	add	a1,a1,a4
  a22f7c:	8289                	srli	a3,a3,0x2
  a22f7e:	972a                	add	a4,a4,a0
  a22f80:	4781                	li	a5,0
  a22f82:	c19c                	sw	a5,0(a1)
  a22f84:	0ff0000f          	fence
  a22f88:	4208                	lw	a0,0(a2)
  a22f8a:	c308                	sw	a0,0(a4)
  a22f8c:	0ff0000f          	fence
  a22f90:	0785                	addi	a5,a5,1 # 44100001 <__data_load__+0x436d85cd>
  a22f92:	0611                	addi	a2,a2,4
  a22f94:	fef697e3          	bne	a3,a5,a22f82 <hal_cipher_hash_config+0x9a>
  a22f98:	4501                	li	a0,0
  a22f9a:	8082                	ret
  a22f9c:	8082                	ret
  a22f9e:	6520 0003 051f      	l.li	a0,0x65200003
  a22fa4:	8082                	ret
  a22fa6:	46d1                	li	a3,20
  a22fa8:	45a9                	li	a1,10
  a22faa:	bf85                	j	a22f1a <hal_cipher_hash_config+0x32>
  a22fac:	04000693          	li	a3,64
  a22fb0:	45ad                	li	a1,11
  a22fb2:	4509                	li	a0,2
  a22fb4:	b749                	j	a22f36 <hal_cipher_hash_config+0x4e>
  a22fb6:	02000693          	li	a3,32
  a22fba:	45ad                	li	a1,11
  a22fbc:	4505                	li	a0,1
  a22fbe:	bfa5                	j	a22f36 <hal_cipher_hash_config+0x4e>
  a22fc0:	02000693          	li	a3,32
  a22fc4:	45b1                	li	a1,12
  a22fc6:	bf91                	j	a22f1a <hal_cipher_hash_config+0x32>
  a22fc8:	8082                	ret

00a22fca <hal_cipher_hash_add_in_node>:
  a22fca:	c5b5                	beqz	a1,a23036 <hal_cipher_hash_add_in_node+0x6c>
  a22fcc:	8068                	push	{ra,s0-s4},-32
  a22fce:	00a0 67c4 041f      	l.li	s0,0xa067c4
  a22fd4:	1ca4145b          	muliadd	s0,s0,a0,28
  a22fd8:	4058                	lw	a4,4(s0)
  a22fda:	8936                	mv	s2,a3
  a22fdc:	4414                	lw	a3,8(s0)
  a22fde:	00170793          	addi	a5,a4,1
  a22fe2:	4004                	lw	s1,0(s0)
  a22fe4:	02d7f7b3          	remu	a5,a5,a3
  a22fe8:	8a32                	mv	s4,a2
  a22fea:	08e4849b          	addshf	s1,s1,a4,sll,4
  a22fee:	89ae                	mv	s3,a1
  a22ff0:	46c1                	li	a3,16
  a22ff2:	4601                	li	a2,0
  a22ff4:	45c1                	li	a1,16
  a22ff6:	8526                	mv	a0,s1
  a22ff8:	c05c                	sw	a5,4(s0)
  a22ffa:	5aa020ef          	jal	ra,a255a4 <memset_s>
  a22ffe:	409c                	lw	a5,0(s1)
  a23000:	00197693          	andi	a3,s2,1
  a23004:	00497913          	andi	s2,s2,4
  a23008:	9bf1                	andi	a5,a5,-4
  a2300a:	01203733          	snez	a4,s2
  a2300e:	8fd5                	or	a5,a5,a3
  a23010:	02e7a79b          	orshf	a5,a5,a4,sll,1
  a23014:	c09c                	sw	a5,0(s1)
  a23016:	24dc                	lbu	a5,12(s1)
  a23018:	0134a423          	sw	s3,8(s1)
  a2301c:	0144a223          	sw	s4,4(s1)
  a23020:	9bc1                	andi	a5,a5,-16
  a23022:	a4dc                	sb	a5,12(s1)
  a23024:	00090663          	beqz	s2,a23030 <hal_cipher_hash_add_in_node+0x66>
  a23028:	4785                	li	a5,1
  a2302a:	b87c                	sb	a5,23(s0)
  a2302c:	4501                	li	a0,0
  a2302e:	8064                	popret	{ra,s0-s4},32
  a23030:	00040ba3          	sb	zero,23(s0)
  a23034:	bfe5                	j	a2302c <hal_cipher_hash_add_in_node+0x62>
  a23036:	6520 00a4 051f      	l.li	a0,0x652000a4
  a2303c:	8082                	ret

00a2303e <hal_cipher_hash_start>:
  a2303e:	8068                	push	{ra,s0-s4},-32
  a23040:	00a069b7          	lui	s3,0xa06
  a23044:	7c498913          	addi	s2,s3,1988 # a067c4 <g_hash_hard_ctx>
  a23048:	1ca9195b          	muliadd	s2,s2,a0,28
  a2304c:	01092783          	lw	a5,16(s2)
  a23050:	4a05                	li	s4,1
  a23052:	842a                	mv	s0,a0
  a23054:	00aa14b3          	sll	s1,s4,a0
  a23058:	7c498993          	addi	s3,s3,1988
  a2305c:	cbad                	beqz	a5,a230ce <hal_cipher_hash_start+0x90>
  a2305e:	c9a5                	beqz	a1,a230ce <hal_cipher_hash_start+0x90>
  a23060:	01494783          	lbu	a5,20(s2)
  a23064:	c7ad                	beqz	a5,a230ce <hal_cipher_hash_start+0x90>
  a23066:	d69ff0ef          	jal	ra,a22dce <crypto_wait_func_is_support>
  a2306a:	c135                	beqz	a0,a230ce <hal_cipher_hash_start+0x90>
  a2306c:	00090aa3          	sb	zero,21(s2)
  a23070:	01490b23          	sb	s4,22(s2)
  a23074:	441087b7          	lui	a5,0x44108
  a23078:	6047a703          	lw	a4,1540(a5) # 44108604 <__data_load__+0x436e0bd0>
  a2307c:	8cd9                	or	s1,s1,a4
  a2307e:	6097a223          	sw	s1,1540(a5)
  a23082:	0ff0000f          	fence
  a23086:	00ff ffff 091f      	l.li	s2,0xffffff
  a2308c:	012407b3          	add	a5,s0,s2
  a23090:	4410 5130 091f      	l.li	s2,0x44105130
  a23096:	10f9091b          	addshf	s2,s2,a5,sll,8
  a2309a:	00092703          	lw	a4,0(s2)
  a2309e:	1c89945b          	muliadd	s0,s3,s0,28
  a230a2:	4414                	lw	a3,8(s0)
  a230a4:	0ff77793          	andi	a5,a4,255
  a230a8:	0785                	addi	a5,a5,1
  a230aa:	02d7f7b3          	remu	a5,a5,a3
  a230ae:	4008                	lw	a0,0(s0)
  a230b0:	f0077713          	andi	a4,a4,-256
  a230b4:	02000593          	li	a1,32
  a230b8:	9f81                	uxtb	a5
  a230ba:	00f764b3          	or	s1,a4,a5
  a230be:	d0fff0ef          	jal	ra,a22dcc <crypto_cache_flush>
  a230c2:	00992023          	sw	s1,0(s2)
  a230c6:	0ff0000f          	fence
  a230ca:	4501                	li	a0,0
  a230cc:	8064                	popret	{ra,s0-s4},32
  a230ce:	1c8997db          	muliadd	a5,s3,s0,28
  a230d2:	00078b23          	sb	zero,22(a5)
  a230d6:	441087b7          	lui	a5,0x44108
  a230da:	6047a703          	lw	a4,1540(a5) # 44108604 <__data_load__+0x436e0bd0>
  a230de:	fff4c493          	not	s1,s1
  a230e2:	8cf9                	and	s1,s1,a4
  a230e4:	bf69                	j	a2307e <hal_cipher_hash_start+0x40>

00a230e6 <hal_cipher_hash_done_try>:
  a230e6:	44108737          	lui	a4,0x44108
  a230ea:	60072683          	lw	a3,1536(a4) # 44108600 <__data_load__+0x436e0bcc>
  a230ee:	4785                	li	a5,1
  a230f0:	00a79533          	sll	a0,a5,a0
  a230f4:	8d75                	and	a0,a0,a3
  a230f6:	60a72023          	sw	a0,1536(a4)
  a230fa:	0ff0000f          	fence
  a230fe:	8082                	ret

00a23100 <hal_hash_lock>:
  a23100:	fff50793          	addi	a5,a0,-1
  a23104:	0347f03b          	bgeui	a5,3,a23204 <hal_hash_lock+0x104>
  a23108:	8058                	push	{ra,s0-s3},-32
  a2310a:	842a                	mv	s0,a0
  a2310c:	906ff0ef          	jal	ra,a22212 <crypto_get_cpu_type>
  a23110:	44100737          	lui	a4,0x44100
  a23114:	432c                	lw	a1,64(a4)
  a23116:	00241693          	slli	a3,s0,0x2
  a2311a:	00153513          	seqz	a0,a0
  a2311e:	00d5d633          	srl	a2,a1,a3
  a23122:	8a3d                	andi	a2,a2,15
  a23124:	0505                	addi	a0,a0,1
  a23126:	c609                	beqz	a2,a23130 <hal_hash_lock+0x30>
  a23128:	6520 0005 051f      	l.li	a0,0x65200005
  a2312e:	8054                	popret	{ra,s0-s3},32
  a23130:	00d517b3          	sll	a5,a0,a3
  a23134:	8fcd                	or	a5,a5,a1
  a23136:	c33c                	sw	a5,64(a4)
  a23138:	0ff0000f          	fence
  a2313c:	433c                	lw	a5,64(a4)
  a2313e:	00d7d7b3          	srl	a5,a5,a3
  a23142:	8bbd                	andi	a5,a5,15
  a23144:	fef512e3          	bne	a0,a5,a23128 <hal_hash_lock+0x28>
  a23148:	441086b7          	lui	a3,0x44108
  a2314c:	6046a603          	lw	a2,1540(a3) # 44108604 <__data_load__+0x436e0bd0>
  a23150:	4485                	li	s1,1
  a23152:	008494b3          	sll	s1,s1,s0
  a23156:	fff4c793          	not	a5,s1
  a2315a:	8ff1                	and	a5,a5,a2
  a2315c:	60f6a223          	sw	a5,1540(a3)
  a23160:	0ff0000f          	fence
  a23164:	d724                	sw	s1,104(a4)
  a23166:	0ff0000f          	fence
  a2316a:	0098 9680 091f      	l.li	s2,0x989680
  a23170:	441009b7          	lui	s3,0x44100
  a23174:	0149a783          	lw	a5,20(s3) # 44100014 <__data_load__+0x436d85e0>
  a23178:	8fe5                	and	a5,a5,s1
  a2317a:	cba5                	beqz	a5,a231ea <hal_hash_lock+0xea>
  a2317c:	0099aa23          	sw	s1,20(s3)
  a23180:	0ff0000f          	fence
  a23184:	80000937          	lui	s2,0x80000
  a23188:	88aff0ef          	jal	ra,a22212 <crypto_get_cpu_type>
  a2318c:	e535                	bnez	a0,a231f8 <hal_hash_lock+0xf8>
  a2318e:	50096913          	ori	s2,s2,1280
  a23192:	0044 1050 049f      	l.li	s1,0x441050
  a23198:	94a2                	add	s1,s1,s0
  a2319a:	04a2                	slli	s1,s1,0x8
  a2319c:	0124a023          	sw	s2,0(s1)
  a231a0:	0ff0000f          	fence
  a231a4:	00a0 67c4 091f      	l.li	s2,0xa067c4
  a231aa:	1c89195b          	muliadd	s2,s2,s0,28
  a231ae:	00092503          	lw	a0,0(s2) # 80000000 <__data_load__+0x7f5d85cc>
  a231b2:	826ff0ef          	jal	ra,a221d8 <crypto_get_phys_addr>
  a231b6:	d0c8                	sw	a0,36(s1)
  a231b8:	0ff0000f          	fence
  a231bc:	0204a023          	sw	zero,32(s1)
  a231c0:	0ff0000f          	fence
  a231c4:	4789                	li	a5,2
  a231c6:	d4dc                	sw	a5,44(s1)
  a231c8:	0ff0000f          	fence
  a231cc:	8522                	mv	a0,s0
  a231ce:	3f21                	jal	ra,a230e6 <hal_cipher_hash_done_try>
  a231d0:	00092503          	lw	a0,0(s2)
  a231d4:	00092223          	sw	zero,4(s2)
  a231d8:	02000693          	li	a3,32
  a231dc:	4601                	li	a2,0
  a231de:	02000593          	li	a1,32
  a231e2:	3c2020ef          	jal	ra,a255a4 <memset_s>
  a231e6:	4501                	li	a0,0
  a231e8:	b799                	j	a2312e <hal_hash_lock+0x2e>
  a231ea:	4505                	li	a0,1
  a231ec:	197d                	addi	s2,s2,-1
  a231ee:	9eaff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a231f2:	f80911e3          	bnez	s2,a23174 <hal_hash_lock+0x74>
  a231f6:	b779                	j	a23184 <hal_hash_lock+0x84>
  a231f8:	0000 0a00 079f      	l.li	a5,0xa00
  a231fe:	00f96933          	or	s2,s2,a5
  a23202:	bf41                	j	a23192 <hal_hash_lock+0x92>
  a23204:	557d                	li	a0,-1
  a23206:	8082                	ret

00a23208 <hal_hash_debug_chn>:
  a23208:	030577bb          	bgeui	a0,3,a23226 <hal_hash_debug_chn+0x1e>
  a2320c:	4410 a004 079f      	l.li	a5,0x4410a004
  a23212:	0ea7851b          	addshf	a0,a5,a0,sll,7
  a23216:	4741                	li	a4,16
  a23218:	4781                	li	a5,0
  a2321a:	c11c                	sw	a5,0(a0)
  a2321c:	0ff0000f          	fence
  a23220:	0785                	addi	a5,a5,1
  a23222:	fee79ce3          	bne	a5,a4,a2321a <hal_hash_debug_chn+0x12>
  a23226:	8082                	ret

00a23228 <hal_cipher_hash_wait_done>:
  a23228:	4446783b          	bgeui	a2,68,a23348 <hal_cipher_hash_wait_done+0x120>
  a2322c:	81a8                	push	{ra,s0-s8},-64
  a2322e:	00a0 67c4 079f      	l.li	a5,0xa067c4
  a23234:	1ca797db          	muliadd	a5,a5,a0,28
  a23238:	3bf8                	lbu	a4,23(a5)
  a2323a:	89b2                	mv	s3,a2
  a2323c:	892e                	mv	s2,a1
  a2323e:	842a                	mv	s0,a0
  a23240:	cf41                	beqz	a4,a232d8 <hal_cipher_hash_wait_done+0xb0>
  a23242:	2bf8                	lbu	a4,22(a5)
  a23244:	c62a                	sw	a0,12(sp)
  a23246:	4481                	li	s1,0
  a23248:	0117193b          	bnei	a4,1,a232ac <hal_cipher_hash_wait_done+0x84>
  a2324c:	4b98                	lw	a4,16(a5)
  a2324e:	cf39                	beqz	a4,a232ac <hal_cipher_hash_wait_done+0x84>
  a23250:	4f94                	lw	a3,24(a5)
  a23252:	47c8                	lw	a0,12(a5)
  a23254:	0070                	addi	a2,sp,12
  a23256:	00a2 2e18 059f      	l.li	a1,0xa22e18
  a2325c:	9702                	jalr	a4
  a2325e:	0ca04663          	bgtz	a0,a2332a <hal_cipher_hash_wait_done+0x102>
  a23262:	441007b7          	lui	a5,0x44100
  a23266:	43bc                	lw	a5,64(a5)
  a23268:	8522                	mv	a0,s0
  a2326a:	3f79                	jal	ra,a23208 <hal_hash_debug_chn>
  a2326c:	6520 00b2 051f      	l.li	a0,0x652000b2
  a23272:	44108737          	lui	a4,0x44108
  a23276:	60472683          	lw	a3,1540(a4) # 44108604 <__data_load__+0x436e0bd0>
  a2327a:	4785                	li	a5,1
  a2327c:	008797b3          	sll	a5,a5,s0
  a23280:	fff7c793          	not	a5,a5
  a23284:	8ff5                	and	a5,a5,a3
  a23286:	60f72223          	sw	a5,1540(a4)
  a2328a:	0ff0000f          	fence
  a2328e:	00090e63          	beqz	s2,a232aa <hal_cipher_hash_wait_done+0x82>
  a23292:	4410a7b7          	lui	a5,0x4410a
  a23296:	041e                	slli	s0,s0,0x7
  a23298:	00478713          	addi	a4,a5,4 # 4410a004 <__data_load__+0x436e25d0>
  a2329c:	9722                	add	a4,a4,s0
  a2329e:	0029d993          	srli	s3,s3,0x2
  a232a2:	943e                	add	s0,s0,a5
  a232a4:	4781                	li	a5,0
  a232a6:	08f99863          	bne	s3,a5,a23336 <hal_cipher_hash_wait_done+0x10e>
  a232aa:	81a4                	popret	{ra,s0-s8},64
  a232ac:	3e800a93          	li	s5,1000
  a232b0:	0000 1770 0a1f      	l.li	s4,0x1770
  a232b6:	4532                	lw	a0,12(sp)
  a232b8:	353d                	jal	ra,a230e6 <hal_cipher_hash_done_try>
  a232ba:	c119                	beqz	a0,a232c0 <hal_cipher_hash_wait_done+0x98>
  a232bc:	4501                	li	a0,0
  a232be:	bf55                	j	a23272 <hal_cipher_hash_wait_done+0x4a>
  a232c0:	4505                	li	a0,1
  a232c2:	009ae863          	bltu	s5,s1,a232d2 <hal_cipher_hash_wait_done+0xaa>
  a232c6:	912ff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a232ca:	0485                	addi	s1,s1,1
  a232cc:	ff4495e3          	bne	s1,s4,a232b6 <hal_cipher_hash_wait_done+0x8e>
  a232d0:	bf49                	j	a23262 <hal_cipher_hash_wait_done+0x3a>
  a232d2:	8b6ff0ef          	jal	ra,a22388 <uapi_tcxo_delay_ms>
  a232d6:	bfd5                	j	a232ca <hal_cipher_hash_wait_done+0xa2>
  a232d8:	00ff ffff 049f      	l.li	s1,0xffffff
  a232de:	441057b7          	lui	a5,0x44105
  a232e2:	94aa                	add	s1,s1,a0
  a232e4:	04a2                	slli	s1,s1,0x8
  a232e6:	13478b13          	addi	s6,a5,308 # 44105134 <__data_load__+0x436dd700>
  a232ea:	13078793          	addi	a5,a5,304
  a232ee:	9b26                	add	s6,s6,s1
  a232f0:	00f48a33          	add	s4,s1,a5
  a232f4:	4a81                	li	s5,0
  a232f6:	3e800c13          	li	s8,1000
  a232fa:	0000 1770 0b9f      	l.li	s7,0x1770
  a23300:	000b2703          	lw	a4,0(s6)
  a23304:	000a2783          	lw	a5,0(s4)
  a23308:	4505                	li	a0,1
  a2330a:	04f70163          	beq	a4,a5,a2334c <hal_cipher_hash_wait_done+0x124>
  a2330e:	015c6863          	bltu	s8,s5,a2331e <hal_cipher_hash_wait_done+0xf6>
  a23312:	8c6ff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a23316:	0a85                	addi	s5,s5,1
  a23318:	ff7a94e3          	bne	s5,s7,a23300 <hal_cipher_hash_wait_done+0xd8>
  a2331c:	b799                	j	a23262 <hal_cipher_hash_wait_done+0x3a>
  a2331e:	86aff0ef          	jal	ra,a22388 <uapi_tcxo_delay_ms>
  a23322:	bfd5                	j	a23316 <hal_cipher_hash_wait_done+0xee>
  a23324:	864ff0ef          	jal	ra,a22388 <uapi_tcxo_delay_ms>
  a23328:	a0a9                	j	a23372 <hal_cipher_hash_wait_done+0x14a>
  a2332a:	6520 00b2 079f      	l.li	a5,0x652000b2
  a23330:	f8f516e3          	bne	a0,a5,a232bc <hal_cipher_hash_wait_done+0x94>
  a23334:	b73d                	j	a23262 <hal_cipher_hash_wait_done+0x3a>
  a23336:	c31c                	sw	a5,0(a4)
  a23338:	0ff0000f          	fence
  a2333c:	4014                	lw	a3,0(s0)
  a2333e:	0785                	addi	a5,a5,1
  a23340:	0911                	addi	s2,s2,4
  a23342:	fed92e23          	sw	a3,-4(s2)
  a23346:	b785                	j	a232a6 <hal_cipher_hash_wait_done+0x7e>
  a23348:	557d                	li	a0,-1
  a2334a:	8082                	ret
  a2334c:	88cff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a23350:	4410 51c0 079f      	l.li	a5,0x441051c0
  a23356:	4a01                	li	s4,0
  a23358:	94be                	add	s1,s1,a5
  a2335a:	3e800b13          	li	s6,1000
  a2335e:	0000 1770 0a9f      	l.li	s5,0x1770
  a23364:	409c                	lw	a5,0(s1)
  a23366:	dbb9                	beqz	a5,a232bc <hal_cipher_hash_wait_done+0x94>
  a23368:	4505                	li	a0,1
  a2336a:	fb4b6de3          	bltu	s6,s4,a23324 <hal_cipher_hash_wait_done+0xfc>
  a2336e:	86aff0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a23372:	0a05                	addi	s4,s4,1
  a23374:	ff5a18e3          	bne	s4,s5,a23364 <hal_cipher_hash_wait_done+0x13c>
  a23378:	b5ed                	j	a23262 <hal_cipher_hash_wait_done+0x3a>

00a2337a <hal_cipher_trng_init>:
  a2337a:	00a0 6878 079f      	l.li	a5,0xa06878
  a23380:	4705                	li	a4,1
  a23382:	a398                	sb	a4,0(a5)
  a23384:	4501                	li	a0,0
  a23386:	8082                	ret

00a23388 <hal_cipher_trng_deinit>:
  a23388:	00a0 6878 079f      	l.li	a5,0xa06878
  a2338e:	00078023          	sb	zero,0(a5)
  a23392:	4501                	li	a0,0
  a23394:	8082                	ret

00a23396 <hal_tcxo_init>:
  a23396:	8018                	push	{ra},-16
  a23398:	28a9                	jal	ra,a233f2 <hal_tcxo_v150_regs_init>
  a2339a:	e105                	bnez	a0,a233ba <hal_tcxo_init+0x24>
  a2339c:	00a07737          	lui	a4,0xa07
  a233a0:	87c72683          	lw	a3,-1924(a4) # a0687c <g_tcxo_regs>
  a233a4:	429c                	lw	a5,0(a3)
  a233a6:	0047e793          	ori	a5,a5,4
  a233aa:	c29c                	sw	a5,0(a3)
  a233ac:	87c72703          	lw	a4,-1924(a4)
  a233b0:	431c                	lw	a5,0(a4)
  a233b2:	0027e793          	ori	a5,a5,2
  a233b6:	c31c                	sw	a5,0(a4)
  a233b8:	8014                	popret	{ra},16
  a233ba:	8000 1180 051f      	l.li	a0,0x80001180
  a233c0:	bfe5                	j	a233b8 <hal_tcxo_init+0x22>

00a233c2 <hal_tcxo_get>:
  a233c2:	00a077b7          	lui	a5,0xa07
  a233c6:	87c7a683          	lw	a3,-1924(a5) # a0687c <g_tcxo_regs>
  a233ca:	4605                	li	a2,1
  a233cc:	4298                	lw	a4,0(a3)
  a233ce:	00176713          	ori	a4,a4,1
  a233d2:	c298                	sw	a4,0(a3)
  a233d4:	56fd                	li	a3,-1
  a233d6:	873e                	mv	a4,a5
  a233d8:	87c72783          	lw	a5,-1924(a4)
  a233dc:	439c                	lw	a5,0(a5)
  a233de:	8391                	srli	a5,a5,0x4
  a233e0:	8b85                	andi	a5,a5,1
  a233e2:	00c78763          	beq	a5,a2,a233f0 <hal_tcxo_get+0x2e>
  a233e6:	16fd                	addi	a3,a3,-1
  a233e8:	fae5                	bnez	a3,a233d8 <hal_tcxo_get+0x16>
  a233ea:	4501                	li	a0,0
  a233ec:	4581                	li	a1,0
  a233ee:	8082                	ret
  a233f0:	a00d                	j	a23412 <hal_tcxo_reg_count_get>

00a233f2 <hal_tcxo_v150_regs_init>:
  a233f2:	8018                	push	{ra},-16
  a233f4:	45f000ef          	jal	ra,a24052 <tcxo_porting_base_addr_get>
  a233f8:	c909                	beqz	a0,a2340a <hal_tcxo_v150_regs_init+0x18>
  a233fa:	459000ef          	jal	ra,a24052 <tcxo_porting_base_addr_get>
  a233fe:	00a0 687c 079f      	l.li	a5,0xa0687c
  a23404:	c388                	sw	a0,0(a5)
  a23406:	4501                	li	a0,0
  a23408:	8014                	popret	{ra},16
  a2340a:	8000 1180 051f      	l.li	a0,0x80001180
  a23410:	bfe5                	j	a23408 <hal_tcxo_v150_regs_init+0x16>

00a23412 <hal_tcxo_reg_count_get>:
  a23412:	00a0 687c 079f      	l.li	a5,0xa0687c
  a23418:	439c                	lw	a5,0(a5)
  a2341a:	478c                	lw	a1,8(a5)
  a2341c:	43c8                	lw	a0,4(a5)
  a2341e:	8082                	ret

00a23420 <hal_uart_register_funcs>:
  a23420:	030575bb          	bgeui	a0,3,a23436 <hal_uart_register_funcs+0x16>
  a23424:	c989                	beqz	a1,a23436 <hal_uart_register_funcs+0x16>
  a23426:	00a0 6880 079f      	l.li	a5,0xa06880
  a2342c:	04a7851b          	addshf	a0,a5,a0,sll,2
  a23430:	c10c                	sw	a1,0(a0)
  a23432:	4501                	li	a0,0
  a23434:	8082                	ret
  a23436:	80000537          	lui	a0,0x80000
  a2343a:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a2343c:	8082                	ret

00a2343e <hal_uart_init>:
  a2343e:	8228                	push	{ra,s0},-48
  a23440:	842a                	mv	s0,a0
  a23442:	ce2e                	sw	a1,28(sp)
  a23444:	cc32                	sw	a2,24(sp)
  a23446:	ca36                	sw	a3,20(sp)
  a23448:	c83a                	sw	a4,16(sp)
  a2344a:	c63e                	sw	a5,12(sp)
  a2344c:	379000ef          	jal	ra,a23fc4 <uart_port_register_hal_funcs>
  a23450:	00a0 6880 051f      	l.li	a0,0xa06880
  a23456:	0485051b          	addshf	a0,a0,s0,sll,2
  a2345a:	4108                	lw	a0,0(a0)
  a2345c:	cd01                	beqz	a0,a23474 <hal_uart_init+0x36>
  a2345e:	46d2                	lw	a3,20(sp)
  a23460:	ca91                	beqz	a3,a23474 <hal_uart_init+0x36>
  a23462:	00052303          	lw	t1,0(a0)
  a23466:	47b2                	lw	a5,12(sp)
  a23468:	4742                	lw	a4,16(sp)
  a2346a:	4662                	lw	a2,24(sp)
  a2346c:	45f2                	lw	a1,28(sp)
  a2346e:	8522                	mv	a0,s0
  a23470:	8220                	pop	{ra,s0},48
  a23472:	8302                	jr	t1
  a23474:	8000 1047 051f      	l.li	a0,0x80001047
  a2347a:	8224                	popret	{ra,s0},48

00a2347c <hal_uart_deinit>:
  a2347c:	00a0 6880 079f      	l.li	a5,0xa06880
  a23482:	04a7879b          	addshf	a5,a5,a0,sll,2
  a23486:	439c                	lw	a5,0(a5)
  a23488:	0047a303          	lw	t1,4(a5)
  a2348c:	8302                	jr	t1

00a2348e <hal_uart_write>:
  a2348e:	00a0 6880 079f      	l.li	a5,0xa06880
  a23494:	04a7879b          	addshf	a5,a5,a0,sll,2
  a23498:	439c                	lw	a5,0(a5)
  a2349a:	00c7a303          	lw	t1,12(a5)
  a2349e:	8302                	jr	t1

00a234a0 <hal_uart_read>:
  a234a0:	00a0 6880 079f      	l.li	a5,0xa06880
  a234a6:	04a7879b          	addshf	a5,a5,a0,sll,2
  a234aa:	439c                	lw	a5,0(a5)
  a234ac:	0107a303          	lw	t1,16(a5)
  a234b0:	8302                	jr	t1

00a234b2 <hal_uart_ctrl>:
  a234b2:	00a0 6880 079f      	l.li	a5,0xa06880
  a234b8:	04a7879b          	addshf	a5,a5,a0,sll,2
  a234bc:	439c                	lw	a5,0(a5)
  a234be:	c781                	beqz	a5,a234c6 <hal_uart_ctrl+0x14>
  a234c0:	0087a303          	lw	t1,8(a5)
  a234c4:	8302                	jr	t1
  a234c6:	8000 1047 051f      	l.li	a0,0x80001047
  a234cc:	8082                	ret

00a234ce <hal_uart_v151_ctrl_get_rxfifo_passnum>:
  a234ce:	c609                	beqz	a2,a234d8 <hal_uart_v151_ctrl_get_rxfifo_passnum+0xa>
  a234d0:	57fd                	li	a5,-1
  a234d2:	c21c                	sw	a5,0(a2)
  a234d4:	4501                	li	a0,0
  a234d6:	8082                	ret
  a234d8:	80000537          	lui	a0,0x80000
  a234dc:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a234de:	8082                	ret

00a234e0 <hal_uart_v151_get_uart_rxfifo_threshold>:
  a234e0:	00a0 68a8 079f      	l.li	a5,0xa068a8
  a234e6:	953e                	add	a0,a0,a5
  a234e8:	2114                	lbu	a3,0(a0)
  a234ea:	03e00713          	li	a4,62
  a234ee:	0306f3bb          	bgeui	a3,3,a234fc <hal_uart_v151_get_uart_rxfifo_threshold+0x1c>
  a234f2:	00a2 6f2c 079f      	l.li	a5,0xa26f2c
  a234f8:	97b6                	add	a5,a5,a3
  a234fa:	2398                	lbu	a4,0(a5)
  a234fc:	c218                	sw	a4,0(a2)
  a234fe:	4501                	li	a0,0
  a23500:	8082                	ret

00a23502 <hal_uart_v151_deinit>:
  a23502:	00a0 688c 079f      	l.li	a5,0xa0688c
  a23508:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2350c:	00052023          	sw	zero,0(a0)
  a23510:	4501                	li	a0,0
  a23512:	8082                	ret

00a23514 <hal_uart_set_diven>:
  a23514:	00a0 689c 079f      	l.li	a5,0xa0689c
  a2351a:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2351e:	4118                	lw	a4,0(a0)
  a23520:	8985                	andi	a1,a1,1
  a23522:	471c                	lw	a5,8(a4)
  a23524:	9bf9                	andi	a5,a5,-2
  a23526:	8fcd                	or	a5,a5,a1
  a23528:	c71c                	sw	a5,8(a4)
  a2352a:	8082                	ret

00a2352c <hal_uart_is_tx_fifo_full>:
  a2352c:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23532:	04a7851b          	addshf	a0,a5,a0,sll,2
  a23536:	411c                	lw	a5,0(a0)
  a23538:	4501                	li	a0,0
  a2353a:	43fc                	lw	a5,68(a5)
  a2353c:	8b85                	andi	a5,a5,1
  a2353e:	a21c                	sb	a5,0(a2)
  a23540:	8082                	ret

00a23542 <hal_uart_is_tx_fifo_empty>:
  a23542:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23548:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2354c:	411c                	lw	a5,0(a0)
  a2354e:	4501                	li	a0,0
  a23550:	43fc                	lw	a5,68(a5)
  a23552:	8385                	srli	a5,a5,0x1
  a23554:	8b85                	andi	a5,a5,1
  a23556:	a21c                	sb	a5,0(a2)
  a23558:	8082                	ret

00a2355a <hal_uart_is_busy>:
  a2355a:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23560:	04a7851b          	addshf	a0,a5,a0,sll,2
  a23564:	411c                	lw	a5,0(a0)
  a23566:	4501                	li	a0,0
  a23568:	43fc                	lw	a5,68(a5)
  a2356a:	9f81                	uxtb	a5
  a2356c:	8385                	srli	a5,a5,0x1
  a2356e:	0017c793          	xori	a5,a5,1
  a23572:	8b85                	andi	a5,a5,1
  a23574:	a21c                	sb	a5,0(a2)
  a23576:	8082                	ret

00a23578 <hal_uart_is_rx_fifo_empty>:
  a23578:	00a0 689c 079f      	l.li	a5,0xa0689c
  a2357e:	04a7851b          	addshf	a0,a5,a0,sll,2
  a23582:	411c                	lw	a5,0(a0)
  a23584:	4501                	li	a0,0
  a23586:	43fc                	lw	a5,68(a5)
  a23588:	838d                	srli	a5,a5,0x3
  a2358a:	8b85                	andi	a5,a5,1
  a2358c:	a21c                	sb	a5,0(a2)
  a2358e:	8082                	ret

00a23590 <hal_uart_v151_write>:
  a23590:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23596:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2359a:	e219                	bnez	a2,a235a0 <hal_uart_v151_write+0x10>
  a2359c:	4501                	li	a0,0
  a2359e:	8082                	ret
  a235a0:	4118                	lw	a4,0(a0)
  a235a2:	437c                	lw	a5,68(a4)
  a235a4:	8b85                	andi	a5,a5,1
  a235a6:	fbf5                	bnez	a5,a2359a <hal_uart_v151_write+0xa>
  a235a8:	0585                	addi	a1,a1,1
  a235aa:	fff5c783          	lbu	a5,-1(a1)
  a235ae:	167d                	addi	a2,a2,-1
  a235b0:	9e21                	uxth	a2
  a235b2:	c35c                	sw	a5,4(a4)
  a235b4:	b7dd                	j	a2359a <hal_uart_v151_write+0xa>

00a235b6 <hal_uart_v151_read>:
  a235b6:	00a0 689c 071f      	l.li	a4,0xa0689c
  a235bc:	4781                	li	a5,0
  a235be:	04a7051b          	addshf	a0,a4,a0,sll,2
  a235c2:	00c7c463          	blt	a5,a2,a235ca <hal_uart_v151_read+0x14>
  a235c6:	853e                	mv	a0,a5
  a235c8:	8082                	ret
  a235ca:	4114                	lw	a3,0(a0)
  a235cc:	42f8                	lw	a4,68(a3)
  a235ce:	8b21                	andi	a4,a4,8
  a235d0:	fb7d                	bnez	a4,a235c6 <hal_uart_v151_read+0x10>
  a235d2:	42d4                	lw	a3,4(a3)
  a235d4:	00f58733          	add	a4,a1,a5
  a235d8:	0785                	addi	a5,a5,1
  a235da:	a314                	sb	a3,0(a4)
  a235dc:	b7dd                	j	a235c2 <hal_uart_v151_read+0xc>

00a235de <hal_uart_v151_ctrl>:
  a235de:	00a2 6f30 079f      	l.li	a5,0xa26f30
  a235e4:	04b7879b          	addshf	a5,a5,a1,sll,2
  a235e8:	0007a303          	lw	t1,0(a5)
  a235ec:	00030363          	beqz	t1,a235f2 <hal_uart_v151_ctrl+0x14>
  a235f0:	8302                	jr	t1
  a235f2:	8000 1047 051f      	l.li	a0,0x80001047
  a235f8:	8082                	ret

00a235fa <hal_uart_init_fifo>:
  a235fa:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23600:	04a7879b          	addshf	a5,a5,a0,sll,2
  a23604:	4398                	lw	a4,0(a5)
  a23606:	0035f693          	andi	a3,a1,3
  a2360a:	535c                	lw	a5,36(a4)
  a2360c:	9bcd                	andi	a5,a5,-13
  a2360e:	04d7a79b          	orshf	a5,a5,a3,sll,2
  a23612:	9bf1                	andi	a5,a5,-4
  a23614:	00367693          	andi	a3,a2,3
  a23618:	8fd5                	or	a5,a5,a3
  a2361a:	0107e793          	ori	a5,a5,16
  a2361e:	d35c                	sw	a5,36(a4)
  a23620:	00a0 68a8 079f      	l.li	a5,0xa068a8
  a23626:	97aa                	add	a5,a5,a0
  a23628:	a38c                	sb	a1,0(a5)
  a2362a:	00a0 68ac 079f      	l.li	a5,0xa068ac
  a23630:	953e                	add	a0,a0,a5
  a23632:	a110                	sb	a2,0(a0)
  a23634:	8082                	ret

00a23636 <hal_uart_v151_ctrl_set_txfifo_int_level>:
  a23636:	0406633b          	bltui	a2,4,a23642 <hal_uart_v151_ctrl_set_txfifo_int_level+0xc>
  a2363a:	80000537          	lui	a0,0x80000
  a2363e:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a23640:	8082                	ret
  a23642:	8018                	push	{ra},-16
  a23644:	00a0 68a8 079f      	l.li	a5,0xa068a8
  a2364a:	97aa                	add	a5,a5,a0
  a2364c:	238c                	lbu	a1,0(a5)
  a2364e:	9e01                	uxtb	a2
  a23650:	376d                	jal	ra,a235fa <hal_uart_init_fifo>
  a23652:	4501                	li	a0,0
  a23654:	8014                	popret	{ra},16

00a23656 <hal_uart_v151_ctrl_set_rxfifo_int_level>:
  a23656:	0406633b          	bltui	a2,4,a23662 <hal_uart_v151_ctrl_set_rxfifo_int_level+0xc>
  a2365a:	80000537          	lui	a0,0x80000
  a2365e:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a23660:	8082                	ret
  a23662:	8018                	push	{ra},-16
  a23664:	00a0 68ac 079f      	l.li	a5,0xa068ac
  a2366a:	97aa                	add	a5,a5,a0
  a2366c:	85b2                	mv	a1,a2
  a2366e:	2390                	lbu	a2,0(a5)
  a23670:	9d81                	uxtb	a1
  a23672:	3761                	jal	ra,a235fa <hal_uart_init_fifo>
  a23674:	4501                	li	a0,0
  a23676:	8014                	popret	{ra},16

00a23678 <hal_uart_set_baud_rate>:
  a23678:	c1a9                	beqz	a1,a236ba <hal_uart_set_baud_rate+0x42>
  a2367a:	8048                	push	{ra,s0-s2},-16
  a2367c:	0592                	slli	a1,a1,0x4
  a2367e:	02b67433          	remu	s0,a2,a1
  a23682:	892a                	mv	s2,a0
  a23684:	02b654b3          	divu	s1,a2,a1
  a23688:	041a                	slli	s0,s0,0x6
  a2368a:	02b45433          	divu	s0,s0,a1
  a2368e:	4585                	li	a1,1
  a23690:	3551                	jal	ra,a23514 <hal_uart_set_diven>
  a23692:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23698:	0527879b          	addshf	a5,a5,s2,sll,2
  a2369c:	439c                	lw	a5,0(a5)
  a2369e:	0ff4f713          	andi	a4,s1,255
  a236a2:	9ca1                	uxth	s1
  a236a4:	cb98                	sw	a4,16(a5)
  a236a6:	80a1                	srli	s1,s1,0x8
  a236a8:	c7c4                	sw	s1,12(a5)
  a236aa:	4581                	li	a1,0
  a236ac:	854a                	mv	a0,s2
  a236ae:	03f47413          	andi	s0,s0,63
  a236b2:	cbc0                	sw	s0,20(a5)
  a236b4:	8040                	pop	{ra,s0-s2},16
  a236b6:	e5fff06f          	j	a23514 <hal_uart_set_diven>
  a236ba:	8082                	ret

00a236bc <hal_uart_set_data_bits>:
  a236bc:	00a0 689c 079f      	l.li	a5,0xa0689c
  a236c2:	04a7851b          	addshf	a0,a5,a0,sll,2
  a236c6:	4118                	lw	a4,0(a0)
  a236c8:	898d                	andi	a1,a1,3
  a236ca:	471c                	lw	a5,8(a4)
  a236cc:	9bcd                	andi	a5,a5,-13
  a236ce:	04b7a79b          	orshf	a5,a5,a1,sll,2
  a236d2:	c71c                	sw	a5,8(a4)
  a236d4:	8082                	ret

00a236d6 <hal_uart_set_stop_bits>:
  a236d6:	00a0 689c 079f      	l.li	a5,0xa0689c
  a236dc:	04a7851b          	addshf	a0,a5,a0,sll,2
  a236e0:	4118                	lw	a4,0(a0)
  a236e2:	8985                	andi	a1,a1,1
  a236e4:	471c                	lw	a5,8(a4)
  a236e6:	f7f7f793          	andi	a5,a5,-129
  a236ea:	0eb7a79b          	orshf	a5,a5,a1,sll,7
  a236ee:	c71c                	sw	a5,8(a4)
  a236f0:	8082                	ret

00a236f2 <hal_uart_auto_flow_ctl_en>:
  a236f2:	00a0 689c 079f      	l.li	a5,0xa0689c
  a236f8:	04a7851b          	addshf	a0,a5,a0,sll,2
  a236fc:	4118                	lw	a4,0(a0)
  a236fe:	8985                	andi	a1,a1,1
  a23700:	575c                	lw	a5,44(a4)
  a23702:	9be9                	andi	a5,a5,-6
  a23704:	8fcd                	or	a5,a5,a1
  a23706:	04b7a59b          	orshf	a1,a5,a1,sll,2
  a2370a:	d74c                	sw	a1,44(a4)
  a2370c:	8082                	ret

00a2370e <hal_uart_enable_interrupt>:
  a2370e:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23714:	04a7851b          	addshf	a0,a5,a0,sll,2
  a23718:	4114                	lw	a3,0(a0)
  a2371a:	4e9c                	lw	a5,24(a3)
  a2371c:	0e05f73b          	bgeui	a1,14,a23738 <hal_uart_enable_interrupt+0x2a>
  a23720:	00a27737          	lui	a4,0xa27
  a23724:	ef470713          	addi	a4,a4,-268 # a26ef4 <g_crypto_ecc_params+0x54>
  a23728:	04b7059b          	addshf	a1,a4,a1,sll,2
  a2372c:	4198                	lw	a4,0(a1)
  a2372e:	8702                	jr	a4
  a23730:	8a05                	andi	a2,a2,1
  a23732:	9bdd                	andi	a5,a5,-9
  a23734:	06c7a79b          	orshf	a5,a5,a2,sll,3
  a23738:	ce9c                	sw	a5,24(a3)
  a2373a:	8082                	ret
  a2373c:	8a05                	andi	a2,a2,1
  a2373e:	9bed                	andi	a5,a5,-5
  a23740:	04c7a79b          	orshf	a5,a5,a2,sll,2
  a23744:	bfd5                	j	a23738 <hal_uart_enable_interrupt+0x2a>
  a23746:	8a05                	andi	a2,a2,1
  a23748:	9bf9                	andi	a5,a5,-2
  a2374a:	8fd1                	or	a5,a5,a2
  a2374c:	b7f5                	j	a23738 <hal_uart_enable_interrupt+0x2a>
  a2374e:	8a05                	andi	a2,a2,1
  a23750:	9bf5                	andi	a5,a5,-3
  a23752:	02c7a79b          	orshf	a5,a5,a2,sll,1
  a23756:	b7cd                	j	a23738 <hal_uart_enable_interrupt+0x2a>

00a23758 <hal_uart_en_para_err_int>:
  a23758:	8018                	push	{ra},-16
  a2375a:	00c03633          	snez	a2,a2
  a2375e:	45b5                	li	a1,13
  a23760:	377d                	jal	ra,a2370e <hal_uart_enable_interrupt>
  a23762:	4501                	li	a0,0
  a23764:	8014                	popret	{ra},16

00a23766 <hal_uart_en_idle_int>:
  a23766:	8018                	push	{ra},-16
  a23768:	00c03633          	snez	a2,a2
  a2376c:	45b1                	li	a1,12
  a2376e:	3745                	jal	ra,a2370e <hal_uart_enable_interrupt>
  a23770:	4501                	li	a0,0
  a23772:	8014                	popret	{ra},16

00a23774 <hal_uart_en_rx_int>:
  a23774:	8018                	push	{ra},-16
  a23776:	00c03633          	snez	a2,a2
  a2377a:	4591                	li	a1,4
  a2377c:	3f49                	jal	ra,a2370e <hal_uart_enable_interrupt>
  a2377e:	4501                	li	a0,0
  a23780:	8014                	popret	{ra},16

00a23782 <hal_uart_en_tx_int>:
  a23782:	8018                	push	{ra},-16
  a23784:	00c03633          	snez	a2,a2
  a23788:	4589                	li	a1,2
  a2378a:	3751                	jal	ra,a2370e <hal_uart_enable_interrupt>
  a2378c:	4501                	li	a0,0
  a2378e:	8014                	popret	{ra},16

00a23790 <hal_uart_check_en>:
  a23790:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23796:	04a7851b          	addshf	a0,a5,a0,sll,2
  a2379a:	4118                	lw	a4,0(a0)
  a2379c:	8985                	andi	a1,a1,1
  a2379e:	471c                	lw	a5,8(a4)
  a237a0:	fdf7f793          	andi	a5,a5,-33
  a237a4:	0ab7a79b          	orshf	a5,a5,a1,sll,5
  a237a8:	c71c                	sw	a5,8(a4)
  a237aa:	8082                	ret

00a237ac <hal_uart_parity_en>:
  a237ac:	00a0 689c 079f      	l.li	a5,0xa0689c
  a237b2:	04a7851b          	addshf	a0,a5,a0,sll,2
  a237b6:	4118                	lw	a4,0(a0)
  a237b8:	8985                	andi	a1,a1,1
  a237ba:	471c                	lw	a5,8(a4)
  a237bc:	9bbd                	andi	a5,a5,-17
  a237be:	08b7a79b          	orshf	a5,a5,a1,sll,4
  a237c2:	c71c                	sw	a5,8(a4)
  a237c4:	8082                	ret

00a237c6 <hal_uart_set_parity>:
  a237c6:	8028                	push	{ra,s0},-16
  a237c8:	842a                	mv	s0,a0
  a237ca:	0105873b          	beqi	a1,1,a237e6 <hal_uart_set_parity+0x20>
  a237ce:	c581                	beqz	a1,a237d6 <hal_uart_set_parity+0x10>
  a237d0:	020582bb          	beqi	a1,2,a237da <hal_uart_set_parity+0x14>
  a237d4:	8024                	popret	{ra,s0},16
  a237d6:	8020                	pop	{ra,s0},16
  a237d8:	bf65                	j	a23790 <hal_uart_check_en>
  a237da:	4585                	li	a1,1
  a237dc:	3f55                	jal	ra,a23790 <hal_uart_check_en>
  a237de:	4585                	li	a1,1
  a237e0:	8522                	mv	a0,s0
  a237e2:	8020                	pop	{ra,s0},16
  a237e4:	b7e1                	j	a237ac <hal_uart_parity_en>
  a237e6:	376d                	jal	ra,a23790 <hal_uart_check_en>
  a237e8:	4581                	li	a1,0
  a237ea:	bfdd                	j	a237e0 <hal_uart_set_parity+0x1a>

00a237ec <hal_uart_v151_ctrl_set_attr>:
  a237ec:	8138                	push	{ra,s0-s1},-32
  a237ee:	224c                	lbu	a1,4(a2)
  a237f0:	84b2                	mv	s1,a2
  a237f2:	842a                	mv	s0,a0
  a237f4:	35e1                	jal	ra,a236bc <hal_uart_set_data_bits>
  a237f6:	30cc                	lbu	a1,5(s1)
  a237f8:	8522                	mv	a0,s0
  a237fa:	3df1                	jal	ra,a236d6 <hal_uart_set_stop_bits>
  a237fc:	20ec                	lbu	a1,6(s1)
  a237fe:	8522                	mv	a0,s0
  a23800:	37d9                	jal	ra,a237c6 <hal_uart_set_parity>
  a23802:	408c                	lw	a1,0(s1)
  a23804:	8522                	mv	a0,s0
  a23806:	c62e                	sw	a1,12(sp)
  a23808:	7d8000ef          	jal	ra,a23fe0 <uart_port_get_clock_value>
  a2380c:	45b2                	lw	a1,12(sp)
  a2380e:	862a                	mv	a2,a0
  a23810:	8522                	mv	a0,s0
  a23812:	e67ff0ef          	jal	ra,a23678 <hal_uart_set_baud_rate>
  a23816:	4501                	li	a0,0
  a23818:	8134                	popret	{ra,s0-s1},32

00a2381a <hal_uart_tx_pause_en>:
  a2381a:	00a0 689c 079f      	l.li	a5,0xa0689c
  a23820:	04a7851b          	addshf	a0,a5,a0,sll,2
  a23824:	4118                	lw	a4,0(a0)
  a23826:	8985                	andi	a1,a1,1
  a23828:	4b3c                	lw	a5,80(a4)
  a2382a:	9bf9                	andi	a5,a5,-2
  a2382c:	8fcd                	or	a5,a5,a1
  a2382e:	cb3c                	sw	a5,80(a4)
  a23830:	8082                	ret

00a23832 <hal_uart_v151_init>:
  a23832:	8168                	push	{ra,s0-s4},-48
  a23834:	84b6                	mv	s1,a3
  a23836:	00251913          	slli	s2,a0,0x2
  a2383a:	00a2 6f84 069f      	l.li	a3,0xa26f84
  a23840:	8a2e                	mv	s4,a1
  a23842:	012685b3          	add	a1,a3,s2
  a23846:	418c                	lw	a1,0(a1)
  a23848:	4294                	lw	a3,0(a3)
  a2384a:	89ba                	mv	s3,a4
  a2384c:	00a0 689c 071f      	l.li	a4,0xa0689c
  a23852:	01270633          	add	a2,a4,s2
  a23856:	c20c                	sw	a1,0(a2)
  a23858:	c314                	sw	a3,0(a4)
  a2385a:	20cc                	lbu	a1,4(s1)
  a2385c:	00a0 6898 071f      	l.li	a4,0xa06898
  a23862:	972a                	add	a4,a4,a0
  a23864:	c63e                	sw	a5,12(sp)
  a23866:	00070023          	sb	zero,0(a4)
  a2386a:	842a                	mv	s0,a0
  a2386c:	e51ff0ef          	jal	ra,a236bc <hal_uart_set_data_bits>
  a23870:	30cc                	lbu	a1,5(s1)
  a23872:	8522                	mv	a0,s0
  a23874:	e63ff0ef          	jal	ra,a236d6 <hal_uart_set_stop_bits>
  a23878:	20ec                	lbu	a1,6(s1)
  a2387a:	8522                	mv	a0,s0
  a2387c:	37a9                	jal	ra,a237c6 <hal_uart_set_parity>
  a2387e:	4581                	li	a1,0
  a23880:	8522                	mv	a0,s0
  a23882:	3f61                	jal	ra,a2381a <hal_uart_tx_pause_en>
  a23884:	408c                	lw	a1,0(s1)
  a23886:	8522                	mv	a0,s0
  a23888:	c42e                	sw	a1,8(sp)
  a2388a:	756000ef          	jal	ra,a23fe0 <uart_port_get_clock_value>
  a2388e:	45a2                	lw	a1,8(sp)
  a23890:	862a                	mv	a2,a0
  a23892:	8522                	mv	a0,s0
  a23894:	de5ff0ef          	jal	ra,a23678 <hal_uart_set_baud_rate>
  a23898:	4529                	li	a0,10
  a2389a:	b3ffe0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a2389e:	47b2                	lw	a5,12(sp)
  a238a0:	c78d                	beqz	a5,a238ca <hal_uart_v151_init+0x98>
  a238a2:	3390                	lbu	a2,1(a5)
  a238a4:	33ac                	lbu	a1,3(a5)
  a238a6:	8522                	mv	a0,s0
  a238a8:	d53ff0ef          	jal	ra,a235fa <hal_uart_init_fifo>
  a238ac:	00a0 688c 079f      	l.li	a5,0xa0688c
  a238b2:	97ca                	add	a5,a5,s2
  a238b4:	0147a023          	sw	s4,0(a5)
  a238b8:	4585                	li	a1,1
  a238ba:	030981bb          	beqi	s3,3,a238c0 <hal_uart_v151_init+0x8e>
  a238be:	4581                	li	a1,0
  a238c0:	8522                	mv	a0,s0
  a238c2:	e31ff0ef          	jal	ra,a236f2 <hal_uart_auto_flow_ctl_en>
  a238c6:	4501                	li	a0,0
  a238c8:	8164                	popret	{ra,s0-s4},48
  a238ca:	4605                	li	a2,1
  a238cc:	4585                	li	a1,1
  a238ce:	bfe1                	j	a238a6 <hal_uart_v151_init+0x74>

00a238d0 <hal_uart_v151_funcs_get>:
  a238d0:	00a0 2430 051f      	l.li	a0,0xa02430
  a238d6:	8082                	ret

00a238d8 <hal_watchdog_register_funcs>:
  a238d8:	c519                	beqz	a0,a238e6 <hal_watchdog_register_funcs+0xe>
  a238da:	00a0 68b0 079f      	l.li	a5,0xa068b0
  a238e0:	c388                	sw	a0,0(a5)
  a238e2:	4501                	li	a0,0
  a238e4:	8082                	ret
  a238e6:	80000537          	lui	a0,0x80000
  a238ea:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a238ec:	8082                	ret

00a238ee <hal_watchdog_unregister_funcs>:
  a238ee:	00a0 68b0 079f      	l.li	a5,0xa068b0
  a238f4:	0007a023          	sw	zero,0(a5)
  a238f8:	4501                	li	a0,0
  a238fa:	8082                	ret

00a238fc <hal_watchdog_get_funcs>:
  a238fc:	00a0 68b0 079f      	l.li	a5,0xa068b0
  a23902:	4388                	lw	a0,0(a5)
  a23904:	8082                	ret

00a23906 <hal_watchdog_regs_init>:
  a23906:	00a027b7          	lui	a5,0xa02
  a2390a:	4787a783          	lw	a5,1144(a5) # a02478 <g_watchdog_base_addr>
  a2390e:	c799                	beqz	a5,a2391c <hal_watchdog_regs_init+0x16>
  a23910:	00a0 68b4 071f      	l.li	a4,0xa068b4
  a23916:	c31c                	sw	a5,0(a4)
  a23918:	4501                	li	a0,0
  a2391a:	8082                	ret
  a2391c:	8000 1200 051f      	l.li	a0,0x80001200
  a23922:	8082                	ret

00a23924 <hal_watchdog_regs_deinit>:
  a23924:	00a0 68b4 079f      	l.li	a5,0xa068b4
  a2392a:	0007a023          	sw	zero,0(a5)
  a2392e:	8082                	ret

00a23930 <hal_watchdog_v151_kick>:
  a23930:	00a077b7          	lui	a5,0xa07
  a23934:	8b47a783          	lw	a5,-1868(a5) # a068b4 <g_watchdog_regs>
  a23938:	5a5a 5a5a 071f      	l.li	a4,0x5a5a5a5a
  a2393e:	c798                	sw	a4,8(a5)
  a23940:	8082                	ret

00a23942 <hal_watchdog_v151_get_attr>:
  a23942:	00a0 68bc 079f      	l.li	a5,0xa068bc
  a23948:	4388                	lw	a0,0(a5)
  a2394a:	8082                	ret

00a2394c <hal_register_watchdog_v151_callback>:
  a2394c:	00a0 68b8 079f      	l.li	a5,0xa068b8
  a23952:	c388                	sw	a0,0(a5)
  a23954:	8082                	ret

00a23956 <hal_watchdog_v151_deinit>:
  a23956:	b7f9                	j	a23924 <hal_watchdog_regs_deinit>

00a23958 <hal_watchdog_v151_init>:
  a23958:	b77d                	j	a23906 <hal_watchdog_regs_init>

00a2395a <hal_watchdog_v151_get_left_time>:
  a2395a:	8038                	push	{ra,s0-s1},-16
  a2395c:	00a077b7          	lui	a5,0xa07
  a23960:	8b47a683          	lw	a3,-1868(a5) # a068b4 <g_watchdog_regs>
  a23964:	7d100493          	li	s1,2001
  a23968:	843e                	mv	s0,a5
  a2396a:	5698                	lw	a4,40(a3)
  a2396c:	00176713          	ori	a4,a4,1
  a23970:	d698                	sw	a4,40(a3)
  a23972:	8b442703          	lw	a4,-1868(s0)
  a23976:	571c                	lw	a5,40(a4)
  a23978:	8385                	srli	a5,a5,0x1
  a2397a:	8b85                	andi	a5,a5,1
  a2397c:	cf99                	beqz	a5,a2399a <hal_watchdog_v151_get_left_time+0x40>
  a2397e:	4b40                	lw	s0,20(a4)
  a23980:	716000ef          	jal	ra,a24096 <watchdog_port_get_clock>
  a23984:	3e800793          	li	a5,1000
  a23988:	862a                	mv	a2,a0
  a2398a:	02f435b3          	mulhu	a1,s0,a5
  a2398e:	4681                	li	a3,0
  a23990:	02f40533          	mul	a0,s0,a5
  a23994:	ca9fc0ef          	jal	ra,a2063c <__udivdi3>
  a23998:	8034                	popret	{ra,s0-s1},16
  a2399a:	14fd                	addi	s1,s1,-1
  a2399c:	c489                	beqz	s1,a239a6 <hal_watchdog_v151_get_left_time+0x4c>
  a2399e:	4505                	li	a0,1
  a239a0:	a39fe0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a239a4:	b7f9                	j	a23972 <hal_watchdog_v151_get_left_time+0x18>
  a239a6:	4501                	li	a0,0
  a239a8:	bfc5                	j	a23998 <hal_watchdog_v151_get_left_time+0x3e>

00a239aa <hal_watchdog_v151_clear_interrupt>:
  a239aa:	00a077b7          	lui	a5,0xa07
  a239ae:	8b47a703          	lw	a4,-1868(a5) # a068b4 <g_watchdog_regs>
  a239b2:	475c                	lw	a5,12(a4)
  a239b4:	0017e793          	ori	a5,a5,1
  a239b8:	c75c                	sw	a5,12(a4)
  a239ba:	8082                	ret

00a239bc <hal_watchdog_v151_disable>:
  a239bc:	8018                	push	{ra},-16
  a239be:	37f5                	jal	ra,a239aa <hal_watchdog_v151_clear_interrupt>
  a239c0:	00a077b7          	lui	a5,0xa07
  a239c4:	8b47a703          	lw	a4,-1868(a5) # a068b4 <g_watchdog_regs>
  a239c8:	4b1c                	lw	a5,16(a4)
  a239ca:	9bf9                	andi	a5,a5,-2
  a239cc:	cb1c                	sw	a5,16(a4)
  a239ce:	8014                	popret	{ra},16

00a239d0 <hal_watchdog_v151_set_attr>:
  a239d0:	8048                	push	{ra,s0-s2},-16
  a239d2:	84aa                	mv	s1,a0
  a239d4:	6c2000ef          	jal	ra,a24096 <watchdog_port_get_clock>
  a239d8:	e489                	bnez	s1,a239e2 <hal_watchdog_v151_set_attr+0x12>
  a239da:	80000537          	lui	a0,0x80000
  a239de:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a239e0:	8044                	popret	{ra,s0-s2},16
  a239e2:	02950433          	mul	s0,a0,s1
  a239e6:	02945933          	divu	s2,s0,s1
  a239ea:	6ac000ef          	jal	ra,a24096 <watchdog_port_get_clock>
  a239ee:	fea916e3          	bne	s2,a0,a239da <hal_watchdog_v151_set_attr+0xa>
  a239f2:	fff46a3b          	bltui	s0,255,a239da <hal_watchdog_v151_set_attr+0xa>
  a239f6:	00a0 68bc 079f      	l.li	a5,0xa068bc
  a239fc:	00a07937          	lui	s2,0xa07
  a23a00:	c384                	sw	s1,0(a5)
  a23a02:	8b492783          	lw	a5,-1868(s2) # a068b4 <g_watchdog_regs>
  a23a06:	5a5a 5a5a 049f      	l.li	s1,0x5a5a5a5a
  a23a0c:	f0047413          	andi	s0,s0,-256
  a23a10:	c384                	sw	s1,0(a5)
  a23a12:	376d                	jal	ra,a239bc <hal_watchdog_v151_disable>
  a23a14:	8b492783          	lw	a5,-1868(s2)
  a23a18:	4b98                	lw	a4,16(a5)
  a23a1a:	00476713          	ori	a4,a4,4
  a23a1e:	cb98                	sw	a4,16(a5)
  a23a20:	4b98                	lw	a4,16(a5)
  a23a22:	fbf77713          	andi	a4,a4,-65
  a23a26:	cb98                	sw	a4,16(a5)
  a23a28:	4b98                	lw	a4,16(a5)
  a23a2a:	03876713          	ori	a4,a4,56
  a23a2e:	cb98                	sw	a4,16(a5)
  a23a30:	43c8                	lw	a0,4(a5)
  a23a32:	0ff57513          	andi	a0,a0,255
  a23a36:	8c49                	or	s0,s0,a0
  a23a38:	c3c0                	sw	s0,4(a5)
  a23a3a:	c784                	sw	s1,8(a5)
  a23a3c:	4501                	li	a0,0
  a23a3e:	b74d                	j	a239e0 <hal_watchdog_v151_set_attr+0x10>

00a23a40 <hal_watchdog_v151_enable>:
  a23a40:	8128                	push	{ra,s0},-32
  a23a42:	c62a                	sw	a0,12(sp)
  a23a44:	3fa5                	jal	ra,a239bc <hal_watchdog_v151_disable>
  a23a46:	4532                	lw	a0,12(sp)
  a23a48:	00a07437          	lui	s0,0xa07
  a23a4c:	e10d                	bnez	a0,a23a6e <hal_watchdog_v151_enable+0x2e>
  a23a4e:	8b442703          	lw	a4,-1868(s0) # a068b4 <g_watchdog_regs>
  a23a52:	4b1c                	lw	a5,16(a4)
  a23a54:	f7f7f793          	andi	a5,a5,-129
  a23a58:	cb1c                	sw	a5,16(a4)
  a23a5a:	3f81                	jal	ra,a239aa <hal_watchdog_v151_clear_interrupt>
  a23a5c:	8b442703          	lw	a4,-1868(s0)
  a23a60:	4b1c                	lw	a5,16(a4)
  a23a62:	0017e793          	ori	a5,a5,1
  a23a66:	cb1c                	sw	a5,16(a4)
  a23a68:	8120                	pop	{ra,s0},32
  a23a6a:	ec7ff06f          	j	a23930 <hal_watchdog_v151_kick>
  a23a6e:	01f51b3b          	bnei	a0,1,a23a5a <hal_watchdog_v151_enable+0x1a>
  a23a72:	8b442703          	lw	a4,-1868(s0)
  a23a76:	4b1c                	lw	a5,16(a4)
  a23a78:	0807e793          	ori	a5,a5,128
  a23a7c:	bff1                	j	a23a58 <hal_watchdog_v151_enable+0x18>

00a23a7e <hal_watchdog_v151_funcs_get>:
  a23a7e:	00a0 2448 051f      	l.li	a0,0xa02448
  a23a84:	8082                	ret

00a23a86 <hal_sfc_regs_init>:
  a23a86:	8058                	push	{ra,s0-s3},-32
  a23a88:	2d2d                	jal	ra,a240c2 <sfc_port_get_sfc_global_conf_base_addr>
  a23a8a:	00a0 68d0 099f      	l.li	s3,0xa068d0
  a23a90:	00a9a023          	sw	a0,0(s3)
  a23a94:	00a0 68c4 091f      	l.li	s2,0xa068c4
  a23a9a:	2d05                	jal	ra,a240ca <sfc_port_get_sfc_bus_regs_base_addr>
  a23a9c:	00a92023          	sw	a0,0(s2)
  a23aa0:	00a0 68c0 049f      	l.li	s1,0xa068c0
  a23aa6:	2535                	jal	ra,a240d2 <sfc_port_get_sfc_bus_dma_regs_base_addr>
  a23aa8:	c088                	sw	a0,0(s1)
  a23aaa:	00a0 68cc 041f      	l.li	s0,0xa068cc
  a23ab0:	252d                	jal	ra,a240da <sfc_port_get_sfc_cmd_regs_base_addr>
  a23ab2:	c008                	sw	a0,0(s0)
  a23ab4:	253d                	jal	ra,a240e2 <sfc_port_get_sfc_cmd_databuf_base_addr>
  a23ab6:	00a0 68c8 079f      	l.li	a5,0xa068c8
  a23abc:	c388                	sw	a0,0(a5)
  a23abe:	0009a783          	lw	a5,0(s3)
  a23ac2:	cb99                	beqz	a5,a23ad8 <hal_sfc_regs_init+0x52>
  a23ac4:	00092783          	lw	a5,0(s2)
  a23ac8:	cb81                	beqz	a5,a23ad8 <hal_sfc_regs_init+0x52>
  a23aca:	409c                	lw	a5,0(s1)
  a23acc:	c791                	beqz	a5,a23ad8 <hal_sfc_regs_init+0x52>
  a23ace:	401c                	lw	a5,0(s0)
  a23ad0:	c781                	beqz	a5,a23ad8 <hal_sfc_regs_init+0x52>
  a23ad2:	c119                	beqz	a0,a23ad8 <hal_sfc_regs_init+0x52>
  a23ad4:	4501                	li	a0,0
  a23ad6:	8054                	popret	{ra,s0-s3},32
  a23ad8:	8000 1343 051f      	l.li	a0,0x80001343
  a23ade:	bfe5                	j	a23ad6 <hal_sfc_regs_init+0x50>

00a23ae0 <hal_sfc_regs_set_cmd_addr>:
  a23ae0:	00a077b7          	lui	a5,0xa07
  a23ae4:	8cc7a683          	lw	a3,-1844(a5) # a068cc <g_sfc_cmd_regs>
  a23ae8:	3fff ffff 071f      	l.li	a4,0x3fffffff
  a23aee:	8d79                	and	a0,a0,a4
  a23af0:	46dc                	lw	a5,12(a3)
  a23af2:	c0000737          	lui	a4,0xc0000
  a23af6:	8ff9                	and	a5,a5,a4
  a23af8:	8fc9                	or	a5,a5,a0
  a23afa:	c6dc                	sw	a5,12(a3)
  a23afc:	8082                	ret

00a23afe <hal_sfc_regs_wait_ready.constprop.3>:
  a23afe:	8158                	push	{ra,s0-s3},-48
  a23b00:	2bd5                	jal	ra,a240f4 <sfc_port_get_delay_times>
  a23b02:	84aa                	mv	s1,a0
  a23b04:	23dd                	jal	ra,a240ea <sfc_port_get_delay_once_time>
  a23b06:	4792                	lw	a5,4(sp)
  a23b08:	ffff c7ff 071f      	l.li	a4,0xffffc7ff
  a23b0e:	892a                	mv	s2,a0
  a23b10:	8077f793          	andi	a5,a5,-2041
  a23b14:	0287e793          	ori	a5,a5,40
  a23b18:	8ff9                	and	a5,a5,a4
  a23b1a:	c23e                	sw	a5,4(sp)
  a23b1c:	4785                	li	a5,1
  a23b1e:	c43e                	sw	a5,8(sp)
  a23b20:	c602                	sw	zero,12(sp)
  a23b22:	4401                	li	s0,0
  a23b24:	00a079b7          	lui	s3,0xa07
  a23b28:	0048                	addi	a0,sp,4
  a23b2a:	26ad                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23b2c:	4601                	li	a2,0
  a23b2e:	4585                	li	a1,1
  a23b30:	4505                	li	a0,1
  a23b32:	2e69                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23b34:	26d9                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23b36:	8c89a783          	lw	a5,-1848(s3) # a068c8 <g_sfc_cmd_databuf>
  a23b3a:	439c                	lw	a5,0(a5)
  a23b3c:	8b85                	andi	a5,a5,1
  a23b3e:	cf91                	beqz	a5,a23b5a <hal_sfc_regs_wait_ready.constprop.3+0x5c>
  a23b40:	854a                	mv	a0,s2
  a23b42:	897fe0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a23b46:	00140793          	addi	a5,s0,1
  a23b4a:	00946663          	bltu	s0,s1,a23b56 <hal_sfc_regs_wait_ready.constprop.3+0x58>
  a23b4e:	8000 1344 051f      	l.li	a0,0x80001344
  a23b54:	8154                	popret	{ra,s0-s3},48
  a23b56:	843e                	mv	s0,a5
  a23b58:	bfc1                	j	a23b28 <hal_sfc_regs_wait_ready.constprop.3+0x2a>
  a23b5a:	4501                	li	a0,0
  a23b5c:	bfe5                	j	a23b54 <hal_sfc_regs_wait_ready.constprop.3+0x56>

00a23b5e <hal_sfc_execute_type_cmd>:
  a23b5e:	8148                	push	{ra,s0-s2},-32
  a23b60:	219c                	lbu	a5,0(a1)
  a23b62:	842a                	mv	s0,a0
  a23b64:	892e                	mv	s2,a1
  a23b66:	078e                	slli	a5,a5,0x3
  a23b68:	0017e793          	ori	a5,a5,1
  a23b6c:	c23e                	sw	a5,4(sp)
  a23b6e:	fff50793          	addi	a5,a0,-1
  a23b72:	c43e                	sw	a5,8(sp)
  a23b74:	c602                	sw	zero,12(sp)
  a23b76:	3761                	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23b78:	84aa                	mv	s1,a0
  a23b7a:	e50d                	bnez	a0,a23ba4 <hal_sfc_execute_type_cmd+0x46>
  a23b7c:	0048                	addi	a0,sp,4
  a23b7e:	2e19                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23b80:	4785                	li	a5,1
  a23b82:	c002                	sw	zero,0(sp)
  a23b84:	0287e263          	bltu	a5,s0,a23ba8 <hal_sfc_execute_type_cmd+0x4a>
  a23b88:	00a077b7          	lui	a5,0xa07
  a23b8c:	8c87a783          	lw	a5,-1848(a5) # a068c8 <g_sfc_cmd_databuf>
  a23b90:	4702                	lw	a4,0(sp)
  a23b92:	00243593          	sltiu	a1,s0,2
  a23b96:	4601                	li	a2,0
  a23b98:	c398                	sw	a4,0(a5)
  a23b9a:	0015c593          	xori	a1,a1,1
  a23b9e:	4501                	li	a0,0
  a23ba0:	2635                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23ba2:	2ea1                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23ba4:	8526                	mv	a0,s1
  a23ba6:	8144                	popret	{ra,s0-s2},32
  a23ba8:	00f906b3          	add	a3,s2,a5
  a23bac:	2294                	lbu	a3,0(a3)
  a23bae:	00f10733          	add	a4,sp,a5
  a23bb2:	0785                	addi	a5,a5,1
  a23bb4:	fed70fa3          	sb	a3,-1(a4) # bfffffff <__data_load__+0xbf5d85cb>
  a23bb8:	b7f1                	j	a23b84 <hal_sfc_execute_type_cmd+0x26>

00a23bba <hal_sfc_write_enable>:
  a23bba:	8118                	push	{ra},-32
  a23bbc:	f43ff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23bc0:	4799                	li	a5,6
  a23bc2:	006c                	addi	a1,sp,12
  a23bc4:	4505                	li	a0,1
  a23bc6:	00f10623          	sb	a5,12(sp)
  a23bca:	3f51                	jal	ra,a23b5e <hal_sfc_execute_type_cmd>
  a23bcc:	e119                	bnez	a0,a23bd2 <hal_sfc_write_enable+0x18>
  a23bce:	f31ff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23bd2:	8114                	popret	{ra},32

00a23bd4 <hal_sfc_reg_write_once>:
  a23bd4:	8648                	push	{ra,s0-s2},-112
  a23bd6:	c636                	sw	a3,12(sp)
  a23bd8:	892a                	mv	s2,a0
  a23bda:	84ae                	mv	s1,a1
  a23bdc:	8432                	mv	s0,a2
  a23bde:	3ff1                	jal	ra,a23bba <hal_sfc_write_enable>
  a23be0:	87aa                	mv	a5,a0
  a23be2:	46b2                	lw	a3,12(sp)
  a23be4:	e939                	bnez	a0,a23c3a <hal_sfc_reg_write_once+0x66>
  a23be6:	ca36                	sw	a3,20(sp)
  a23be8:	0848                	addi	a0,sp,20
  a23bea:	82b9                	srli	a3,a3,0xe
  a23bec:	ce36                	sw	a3,28(sp)
  a23bee:	cc22                	sw	s0,24(sp)
  a23bf0:	2455                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23bf2:	854a                	mv	a0,s2
  a23bf4:	eedff0ef          	jal	ra,a23ae0 <hal_sfc_regs_set_cmd_addr>
  a23bf8:	86a2                	mv	a3,s0
  a23bfa:	8626                	mv	a2,s1
  a23bfc:	04000593          	li	a1,64
  a23c00:	1008                	addi	a0,sp,32
  a23c02:	16b010ef          	jal	ra,a2556c <memcpy_s>
  a23c06:	57fd                	li	a5,-1
  a23c08:	e90d                	bnez	a0,a23c3a <hal_sfc_reg_write_once+0x66>
  a23c0a:	00347613          	andi	a2,s0,3
  a23c0e:	00c03633          	snez	a2,a2
  a23c12:	4486061b          	addshf	a2,a2,s0,srl,2
  a23c16:	9e21                	uxth	a2
  a23c18:	101c                	addi	a5,sp,32
  a23c1a:	4701                	li	a4,0
  a23c1c:	00a075b7          	lui	a1,0xa07
  a23c20:	01071693          	slli	a3,a4,0x10
  a23c24:	82c1                	srli	a3,a3,0x10
  a23c26:	00c6ec63          	bltu	a3,a2,a23c3e <hal_sfc_reg_write_once+0x6a>
  a23c2a:	4605                	li	a2,1
  a23c2c:	4585                	li	a1,1
  a23c2e:	4501                	li	a0,0
  a23c30:	2c71                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23c32:	24e1                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23c34:	ecbff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23c38:	87aa                	mv	a5,a0
  a23c3a:	853e                	mv	a0,a5
  a23c3c:	8644                	popret	{ra,s0-s2},112
  a23c3e:	8c85a683          	lw	a3,-1848(a1) # a068c8 <g_sfc_cmd_databuf>
  a23c42:	4388                	lw	a0,0(a5)
  a23c44:	0791                	addi	a5,a5,4
  a23c46:	04e6869b          	addshf	a3,a3,a4,sll,2
  a23c4a:	c288                	sw	a0,0(a3)
  a23c4c:	0705                	addi	a4,a4,1
  a23c4e:	bfc9                	j	a23c20 <hal_sfc_reg_write_once+0x4c>

00a23c50 <hal_sfc_get_flash_id>:
  a23c50:	8128                	push	{ra,s0},-32
  a23c52:	842a                	mv	s0,a0
  a23c54:	e33ff0ef          	jal	ra,a23a86 <hal_sfc_regs_init>
  a23c58:	ea7ff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23c5c:	e91d                	bnez	a0,a23c92 <hal_sfc_get_flash_id+0x42>
  a23c5e:	4631                	li	a2,12
  a23c60:	00a2 5f38 059f      	l.li	a1,0xa25f38
  a23c66:	0048                	addi	a0,sp,4
  a23c68:	e8bfc0ef          	jal	ra,a20af2 <memcpy>
  a23c6c:	0048                	addi	a0,sp,4
  a23c6e:	241d                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23c70:	4601                	li	a2,0
  a23c72:	4585                	li	a1,1
  a23c74:	4505                	li	a0,1
  a23c76:	2c99                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23c78:	2449                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23c7a:	00a077b7          	lui	a5,0xa07
  a23c7e:	8c87a783          	lw	a5,-1848(a5) # a068c8 <g_sfc_cmd_databuf>
  a23c82:	00ff ffff 071f      	l.li	a4,0xffffff
  a23c88:	439c                	lw	a5,0(a5)
  a23c8a:	8ff9                	and	a5,a5,a4
  a23c8c:	c01c                	sw	a5,0(s0)
  a23c8e:	e71ff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23c92:	8124                	popret	{ra,s0},32

00a23c94 <hal_sfc_init>:
  a23c94:	67c1                	lui	a5,0x10
  a23c96:	0cf66c63          	bltu	a2,a5,a23d6e <hal_sfc_init+0xda>
  a23c9a:	8198                	push	{ra,s0-s7},-64
  a23c9c:	4940                	lw	s0,20(a0)
  a23c9e:	84b2                	mv	s1,a2
  a23ca0:	89ae                	mv	s3,a1
  a23ca2:	892a                	mv	s2,a0
  a23ca4:	4a05                	li	s4,1
  a23ca6:	00a07ab7          	lui	s5,0xa07
  a23caa:	e025                	bnez	s0,a23d0a <hal_sfc_init+0x76>
  a23cac:	00a077b7          	lui	a5,0xa07
  a23cb0:	8c47a683          	lw	a3,-1852(a5) # a068c4 <g_sfc_bus_regs>
  a23cb4:	0109d993          	srli	s3,s3,0x10
  a23cb8:	00f4d613          	srli	a2,s1,0xf
  a23cbc:	4e9c                	lw	a5,24(a3)
  a23cbe:	4701                	li	a4,0
  a23cc0:	01079593          	slli	a1,a5,0x10
  a23cc4:	81c1                	srli	a1,a1,0x10
  a23cc6:	2135a59b          	orshf	a1,a1,s3,sll,16
  a23cca:	ce8c                	sw	a1,24(a3)
  a23ccc:	00167793          	andi	a5,a2,1
  a23cd0:	cfc1                	beqz	a5,a23d68 <hal_sfc_init+0xd4>
  a23cd2:	4a9c                	lw	a5,16(a3)
  a23cd4:	ffff f0ff 061f      	l.li	a2,0xfffff0ff
  a23cda:	8b3d                	andi	a4,a4,15
  a23cdc:	8ff1                	and	a5,a5,a2
  a23cde:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a23ce2:	ca9c                	sw	a5,16(a3)
  a23ce4:	00492503          	lw	a0,4(s2)
  a23ce8:	240d                	jal	ra,a23f0a <hal_sfc_regs_set_bus_read>
  a23cea:	00c92503          	lw	a0,12(s2)
  a23cee:	7f857793          	andi	a5,a0,2040
  a23cf2:	c391                	beqz	a5,a23cf6 <hal_sfc_init+0x62>
  a23cf4:	2c89                	jal	ra,a23f46 <hal_sfc_regs_set_bus_write>
  a23cf6:	00a077b7          	lui	a5,0xa07
  a23cfa:	8d07a783          	lw	a5,-1840(a5) # a068d0 <g_sfc_global_conf_regs>
  a23cfe:	4705                	li	a4,1
  a23d00:	cb98                	sw	a4,16(a5)
  a23d02:	dfdff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23d06:	4501                	li	a0,0
  a23d08:	a00d                	j	a23d2a <hal_sfc_init+0x96>
  a23d0a:	201c                	lbu	a5,0(s0)
  a23d0c:	03478063          	beq	a5,s4,a23d2c <hal_sfc_init+0x98>
  a23d10:	c799                	beqz	a5,a23d1e <hal_sfc_init+0x8a>
  a23d12:	02e786bb          	beqi	a5,2,a23cac <hal_sfc_init+0x18>
  a23d16:	8000 1345 051f      	l.li	a0,0x80001345
  a23d1c:	a039                	j	a23d2a <hal_sfc_init+0x96>
  a23d1e:	3008                	lbu	a0,1(s0)
  a23d20:	00240593          	addi	a1,s0,2
  a23d24:	e3bff0ef          	jal	ra,a23b5e <hal_sfc_execute_type_cmd>
  a23d28:	cd15                	beqz	a0,a23d64 <hal_sfc_init+0xd0>
  a23d2a:	8194                	popret	{ra,s0-s7},64
  a23d2c:	2038                	lbu	a4,2(s0)
  a23d2e:	00344b83          	lbu	s7,3(s0)
  a23d32:	00444b03          	lbu	s6,4(s0)
  a23d36:	070e                	slli	a4,a4,0x3
  a23d38:	00176713          	ori	a4,a4,1
  a23d3c:	c23a                	sw	a4,4(sp)
  a23d3e:	c452                	sw	s4,8(sp)
  a23d40:	c602                	sw	zero,12(sp)
  a23d42:	dbdff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23d46:	0048                	addi	a0,sp,4
  a23d48:	22b1                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23d4a:	4601                	li	a2,0
  a23d4c:	4585                	li	a1,1
  a23d4e:	4505                	li	a0,1
  a23d50:	2ab5                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23d52:	2265                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23d54:	8c8aa783          	lw	a5,-1848(s5) # a068c8 <g_sfc_cmd_databuf>
  a23d58:	439c                	lw	a5,0(a5)
  a23d5a:	0177d7b3          	srl	a5,a5,s7
  a23d5e:	8b85                	andi	a5,a5,1
  a23d60:	fb679be3          	bne	a5,s6,a23d16 <hal_sfc_init+0x82>
  a23d64:	0419                	addi	s0,s0,6
  a23d66:	b791                	j	a23caa <hal_sfc_init+0x16>
  a23d68:	8205                	srli	a2,a2,0x1
  a23d6a:	0705                	addi	a4,a4,1
  a23d6c:	b785                	j	a23ccc <hal_sfc_init+0x38>
  a23d6e:	80000537          	lui	a0,0x80000
  a23d72:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a23d74:	8082                	ret

00a23d76 <hal_sfc_reg_read>:
  a23d76:	8588                	push	{ra,s0-s6},-112
  a23d78:	89aa                	mv	s3,a0
  a23d7a:	8a2e                	mv	s4,a1
  a23d7c:	84b2                	mv	s1,a2
  a23d7e:	04000413          	li	s0,64
  a23d82:	00e6da93          	srli	s5,a3,0xe
  a23d86:	8936                	mv	s2,a3
  a23d88:	00a07b37          	lui	s6,0xa07
  a23d8c:	e099                	bnez	s1,a23d92 <hal_sfc_reg_read+0x1c>
  a23d8e:	4501                	li	a0,0
  a23d90:	a8a1                	j	a23de8 <hal_sfc_reg_read+0x72>
  a23d92:	d6dff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23d96:	e929                	bnez	a0,a23de8 <hal_sfc_reg_read+0x72>
  a23d98:	0084f363          	bgeu	s1,s0,a23d9e <hal_sfc_reg_read+0x28>
  a23d9c:	8426                	mv	s0,s1
  a23d9e:	0048                	addi	a0,sp,4
  a23da0:	c24a                	sw	s2,4(sp)
  a23da2:	c422                	sw	s0,8(sp)
  a23da4:	c656                	sw	s5,12(sp)
  a23da6:	20fd                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23da8:	854e                	mv	a0,s3
  a23daa:	d37ff0ef          	jal	ra,a23ae0 <hal_sfc_regs_set_cmd_addr>
  a23dae:	4605                	li	a2,1
  a23db0:	4505                	li	a0,1
  a23db2:	4585                	li	a1,1
  a23db4:	2a21                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23db6:	2291                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23db8:	00347793          	andi	a5,s0,3
  a23dbc:	00f037b3          	snez	a5,a5
  a23dc0:	8c8b2503          	lw	a0,-1848(s6) # a068c8 <g_sfc_cmd_databuf>
  a23dc4:	4487879b          	addshf	a5,a5,s0,srl,2
  a23dc8:	0814                	addi	a3,sp,16
  a23dca:	9fa1                	uxth	a5
  a23dcc:	4701                	li	a4,0
  a23dce:	8636                	mv	a2,a3
  a23dd0:	01071593          	slli	a1,a4,0x10
  a23dd4:	81c1                	srli	a1,a1,0x10
  a23dd6:	00f5ea63          	bltu	a1,a5,a23dea <hal_sfc_reg_read+0x74>
  a23dda:	86a2                	mv	a3,s0
  a23ddc:	85a2                	mv	a1,s0
  a23dde:	8552                	mv	a0,s4
  a23de0:	78c010ef          	jal	ra,a2556c <memcpy_s>
  a23de4:	c919                	beqz	a0,a23dfa <hal_sfc_reg_read+0x84>
  a23de6:	557d                	li	a0,-1
  a23de8:	8584                	popret	{ra,s0-s6},112
  a23dea:	04e5059b          	addshf	a1,a0,a4,sll,2
  a23dee:	418c                	lw	a1,0(a1)
  a23df0:	0705                	addi	a4,a4,1
  a23df2:	0691                	addi	a3,a3,4
  a23df4:	feb6ae23          	sw	a1,-4(a3)
  a23df8:	bfe1                	j	a23dd0 <hal_sfc_reg_read+0x5a>
  a23dfa:	99a2                	add	s3,s3,s0
  a23dfc:	9a22                	add	s4,s4,s0
  a23dfe:	8c81                	sub	s1,s1,s0
  a23e00:	b771                	j	a23d8c <hal_sfc_reg_read+0x16>

00a23e02 <hal_sfc_reg_write>:
  a23e02:	8088                	push	{ra,s0-s6},-32
  a23e04:	03f57793          	andi	a5,a0,63
  a23e08:	04000413          	li	s0,64
  a23e0c:	8c1d                	sub	s0,s0,a5
  a23e0e:	89aa                	mv	s3,a0
  a23e10:	892e                	mv	s2,a1
  a23e12:	84b2                	mv	s1,a2
  a23e14:	8ab6                	mv	s5,a3
  a23e16:	00867363          	bgeu	a2,s0,a23e1c <hal_sfc_reg_write+0x1a>
  a23e1a:	8432                	mv	s0,a2
  a23e1c:	86d6                	mv	a3,s5
  a23e1e:	8622                	mv	a2,s0
  a23e20:	85ca                	mv	a1,s2
  a23e22:	854e                	mv	a0,s3
  a23e24:	db1ff0ef          	jal	ra,a23bd4 <hal_sfc_reg_write_once>
  a23e28:	8a2a                	mv	s4,a0
  a23e2a:	e905                	bnez	a0,a23e5a <hal_sfc_reg_write+0x58>
  a23e2c:	8c81                	sub	s1,s1,s0
  a23e2e:	c495                	beqz	s1,a23e5a <hal_sfc_reg_write+0x58>
  a23e30:	9922                	add	s2,s2,s0
  a23e32:	04000b13          	li	s6,64
  a23e36:	944e                	add	s0,s0,s3
  a23e38:	89a6                	mv	s3,s1
  a23e3a:	009b7463          	bgeu	s6,s1,a23e42 <hal_sfc_reg_write+0x40>
  a23e3e:	04000993          	li	s3,64
  a23e42:	86d6                	mv	a3,s5
  a23e44:	864e                	mv	a2,s3
  a23e46:	85ca                	mv	a1,s2
  a23e48:	8522                	mv	a0,s0
  a23e4a:	d8bff0ef          	jal	ra,a23bd4 <hal_sfc_reg_write_once>
  a23e4e:	e901                	bnez	a0,a23e5e <hal_sfc_reg_write+0x5c>
  a23e50:	413484b3          	sub	s1,s1,s3
  a23e54:	994e                	add	s2,s2,s3
  a23e56:	944e                	add	s0,s0,s3
  a23e58:	f0e5                	bnez	s1,a23e38 <hal_sfc_reg_write+0x36>
  a23e5a:	8552                	mv	a0,s4
  a23e5c:	8084                	popret	{ra,s0-s6},32
  a23e5e:	8a2a                	mv	s4,a0
  a23e60:	bfed                	j	a23e5a <hal_sfc_reg_write+0x58>

00a23e62 <hal_sfc_reg_erase>:
  a23e62:	8238                	push	{ra,s0-s1},-48
  a23e64:	c62e                	sw	a1,12(sp)
  a23e66:	84aa                	mv	s1,a0
  a23e68:	8432                	mv	s0,a2
  a23e6a:	d51ff0ef          	jal	ra,a23bba <hal_sfc_write_enable>
  a23e6e:	45b2                	lw	a1,12(sp)
  a23e70:	e10d                	bnez	a0,a23e92 <hal_sfc_reg_erase+0x30>
  a23e72:	0848                	addi	a0,sp,20
  a23e74:	ca2e                	sw	a1,20(sp)
  a23e76:	cc02                	sw	zero,24(sp)
  a23e78:	ce02                	sw	zero,28(sp)
  a23e7a:	2829                	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a23e7c:	8526                	mv	a0,s1
  a23e7e:	c63ff0ef          	jal	ra,a23ae0 <hal_sfc_regs_set_cmd_addr>
  a23e82:	00144613          	xori	a2,s0,1
  a23e86:	4581                	li	a1,0
  a23e88:	4501                	li	a0,0
  a23e8a:	2089                	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a23e8c:	20bd                	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a23e8e:	c71ff0ef          	jal	ra,a23afe <hal_sfc_regs_wait_ready.constprop.3>
  a23e92:	8234                	popret	{ra,s0-s1},48

00a23e94 <hal_sfc_regs_set_opt>:
  a23e94:	00a077b7          	lui	a5,0xa07
  a23e98:	8cc7a603          	lw	a2,-1844(a5) # a068cc <g_sfc_cmd_regs>
  a23e9c:	411c                	lw	a5,0(a0)
  a23e9e:	450c                	lw	a1,8(a0)
  a23ea0:	4618                	lw	a4,8(a2)
  a23ea2:	0037d693          	srli	a3,a5,0x3
  a23ea6:	9e81                	uxtb	a3
  a23ea8:	f0077713          	andi	a4,a4,-256
  a23eac:	8f55                	or	a4,a4,a3
  a23eae:	4154                	lw	a3,4(a0)
  a23eb0:	83ad                	srli	a5,a5,0xb
  a23eb2:	8b9d                	andi	a5,a5,7
  a23eb4:	899d                	andi	a1,a1,7
  a23eb6:	07c6                	slli	a5,a5,0x11
  a23eb8:	16fd                	addi	a3,a3,-1
  a23eba:	03f6f693          	andi	a3,a3,63
  a23ebe:	08b7a79b          	orshf	a5,a5,a1,sll,4
  a23ec2:	12d7a79b          	orshf	a5,a5,a3,sll,9
  a23ec6:	c618                	sw	a4,8(a2)
  a23ec8:	c21c                	sw	a5,0(a2)
  a23eca:	8082                	ret

00a23ecc <hal_sfc_regs_set_opt_attr>:
  a23ecc:	00a077b7          	lui	a5,0xa07
  a23ed0:	8cc7a703          	lw	a4,-1844(a5) # a068cc <g_sfc_cmd_regs>
  a23ed4:	8905                	andi	a0,a0,1
  a23ed6:	8985                	andi	a1,a1,1
  a23ed8:	431c                	lw	a5,0(a4)
  a23eda:	8a05                	andi	a2,a2,1
  a23edc:	eff7f793          	andi	a5,a5,-257
  a23ee0:	10a7a79b          	orshf	a5,a5,a0,sll,8
  a23ee4:	f7f7f793          	andi	a5,a5,-129
  a23ee8:	0eb7a79b          	orshf	a5,a5,a1,sll,7
  a23eec:	9bdd                	andi	a5,a5,-9
  a23eee:	06c7a79b          	orshf	a5,a5,a2,sll,3
  a23ef2:	0037e793          	ori	a5,a5,3
  a23ef6:	c31c                	sw	a5,0(a4)
  a23ef8:	8082                	ret

00a23efa <hal_sfc_regs_wait_config>:
  a23efa:	00a077b7          	lui	a5,0xa07
  a23efe:	8cc7a703          	lw	a4,-1844(a5) # a068cc <g_sfc_cmd_regs>
  a23f02:	431c                	lw	a5,0(a4)
  a23f04:	8b85                	andi	a5,a5,1
  a23f06:	fff5                	bnez	a5,a23f02 <hal_sfc_regs_wait_config+0x8>
  a23f08:	8082                	ret

00a23f0a <hal_sfc_regs_set_bus_read>:
  a23f0a:	00a077b7          	lui	a5,0xa07
  a23f0e:	8c47a603          	lw	a2,-1852(a5) # a068c4 <g_sfc_bus_regs>
  a23f12:	80000737          	lui	a4,0x80000
  a23f16:	ffff 00ff 069f      	l.li	a3,0xffff00ff
  a23f1c:	421c                	lw	a5,0(a2)
  a23f1e:	8fd9                	or	a5,a5,a4
  a23f20:	00355713          	srli	a4,a0,0x3
  a23f24:	9f01                	uxtb	a4
  a23f26:	8ff5                	and	a5,a5,a3
  a23f28:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a23f2c:	00b55693          	srli	a3,a0,0xb
  a23f30:	8a9d                	andi	a3,a3,7
  a23f32:	812d                	srli	a0,a0,0xb
  a23f34:	fc07f793          	andi	a5,a5,-64
  a23f38:	03857713          	andi	a4,a0,56
  a23f3c:	00d7e533          	or	a0,a5,a3
  a23f40:	8d59                	or	a0,a0,a4
  a23f42:	c208                	sw	a0,0(a2)
  a23f44:	8082                	ret

00a23f46 <hal_sfc_regs_set_bus_write>:
  a23f46:	00a077b7          	lui	a5,0xa07
  a23f4a:	8c47a683          	lw	a3,-1852(a5) # a068c4 <g_sfc_bus_regs>
  a23f4e:	00355713          	srli	a4,a0,0x3
  a23f52:	c03f ffff 061f      	l.li	a2,0xc03fffff
  a23f58:	429c                	lw	a5,0(a3)
  a23f5a:	9f01                	uxtb	a4
  a23f5c:	812d                	srli	a0,a0,0xb
  a23f5e:	8ff1                	and	a5,a5,a2
  a23f60:	2ce7a79b          	orshf	a5,a5,a4,sll,22
  a23f64:	fff8 ffff 071f      	l.li	a4,0xfff8ffff
  a23f6a:	8ff9                	and	a5,a5,a4
  a23f6c:	891d                	andi	a0,a0,7
  a23f6e:	20a7a79b          	orshf	a5,a5,a0,sll,16
  a23f72:	40000737          	lui	a4,0x40000
  a23f76:	8fd9                	or	a5,a5,a4
  a23f78:	c29c                	sw	a5,0(a3)
  a23f7a:	8082                	ret

00a23f7c <print_str_inner>:
  a23f7c:	8028                	push	{ra,s0},-16
  a23f7e:	00a07437          	lui	s0,0xa07
  a23f82:	872e                	mv	a4,a1
  a23f84:	86aa                	mv	a3,a0
  a23f86:	07f00613          	li	a2,127
  a23f8a:	08000593          	li	a1,128
  a23f8e:	8d840513          	addi	a0,s0,-1832 # a068d8 <str_buf.3002>
  a23f92:	755010ef          	jal	ra,a25ee6 <vsnprintf_s>
  a23f96:	8d840793          	addi	a5,s0,-1832
  a23f9a:	862a                	mv	a2,a0
  a23f9c:	ff0513bb          	bnei	a0,-1,a23faa <print_str_inner+0x2e>
  a23fa0:	2398                	lbu	a4,0(a5)
  a23fa2:	07f00613          	li	a2,127
  a23fa6:	e311                	bnez	a4,a23faa <print_str_inner+0x2e>
  a23fa8:	8024                	popret	{ra,s0},16
  a23faa:	97b2                	add	a5,a5,a2
  a23fac:	00078023          	sb	zero,0(a5)
  a23fb0:	00a0 68d4 079f      	l.li	a5,0xa068d4
  a23fb6:	2388                	lbu	a0,0(a5)
  a23fb8:	4681                	li	a3,0
  a23fba:	8d840593          	addi	a1,s0,-1832
  a23fbe:	8020                	pop	{ra,s0},16
  a23fc0:	887fe06f          	j	a22846 <uapi_uart_write>

00a23fc4 <uart_port_register_hal_funcs>:
  a23fc4:	8028                	push	{ra,s0},-16
  a23fc6:	842a                	mv	s0,a0
  a23fc8:	909ff0ef          	jal	ra,a238d0 <hal_uart_v151_funcs_get>
  a23fcc:	85aa                	mv	a1,a0
  a23fce:	8522                	mv	a0,s0
  a23fd0:	8020                	pop	{ra,s0},16
  a23fd2:	c4eff06f          	j	a23420 <hal_uart_register_funcs>

00a23fd6 <uart_port_set_clock_value>:
  a23fd6:	00a0 246c 079f      	l.li	a5,0xa0246c
  a23fdc:	c38c                	sw	a1,0(a5)
  a23fde:	8082                	ret

00a23fe0 <uart_port_get_clock_value>:
  a23fe0:	00a0 246c 079f      	l.li	a5,0xa0246c
  a23fe6:	4388                	lw	a0,0(a5)
  a23fe8:	8082                	ret

00a23fea <uart_port_config_pinmux>:
  a23fea:	020513bb          	bnei	a0,2,a23ff8 <uart_port_config_pinmux+0xe>
  a23fee:	4400d7b7          	lui	a5,0x4400d
  a23ff2:	4705                	li	a4,1
  a23ff4:	db98                	sw	a4,48(a5)
  a23ff6:	dbd8                	sw	a4,52(a5)
  a23ff8:	8082                	ret

00a23ffa <uart_port_register_irq>:
  a23ffa:	8082                	ret

00a23ffc <uart_port_unregister_irq>:
  a23ffc:	8082                	ret

00a23ffe <print_str>:
  a23ffe:	7139                	addi	sp,sp,-64
  a24000:	ce06                	sw	ra,28(sp)
  a24002:	cc22                	sw	s0,24(sp)
  a24004:	d22e                	sw	a1,36(sp)
  a24006:	d432                	sw	a2,40(sp)
  a24008:	d636                	sw	a3,44(sp)
  a2400a:	d83a                	sw	a4,48(sp)
  a2400c:	da3e                	sw	a5,52(sp)
  a2400e:	dc42                	sw	a6,56(sp)
  a24010:	de46                	sw	a7,60(sp)
  a24012:	c911                	beqz	a0,a24026 <print_str+0x28>
  a24014:	842a                	mv	s0,a0
  a24016:	d97fc0ef          	jal	ra,a20dac <strlen>
  a2401a:	c511                	beqz	a0,a24026 <print_str+0x28>
  a2401c:	104c                	addi	a1,sp,36
  a2401e:	8522                	mv	a0,s0
  a24020:	c62e                	sw	a1,12(sp)
  a24022:	f5bff0ef          	jal	ra,a23f7c <print_str_inner>
  a24026:	40f2                	lw	ra,28(sp)
  a24028:	4462                	lw	s0,24(sp)
  a2402a:	6121                	addi	sp,sp,64
  a2402c:	8082                	ret

00a2402e <uart_porting_lock>:
  a2402e:	852fe06f          	j	a22080 <osal_irq_lock>

00a24032 <uart_porting_unlock>:
  a24032:	852e                	mv	a0,a1
  a24034:	854fe06f          	j	a22088 <osal_irq_restore>

00a24038 <hal_systick_get_count>:
  a24038:	400057b7          	lui	a5,0x40005
  a2403c:	4fd8                	lw	a4,28(a5)
  a2403e:	4f98                	lw	a4,24(a5)
  a24040:	4fc8                	lw	a0,28(a5)
  a24042:	4f8c                	lw	a1,24(a5)
  a24044:	9da1                	uxth	a1
  a24046:	8082                	ret

00a24048 <systick_clock_get>:
  a24048:	00a0 2470 079f      	l.li	a5,0xa02470
  a2404e:	4388                	lw	a0,0(a5)
  a24050:	8082                	ret

00a24052 <tcxo_porting_base_addr_get>:
  a24052:	4400 04c0 051f      	l.li	a0,0x440004c0
  a24058:	8082                	ret

00a2405a <tcxo_porting_ticks_per_usec_get>:
  a2405a:	00a0 2474 079f      	l.li	a5,0xa02474
  a24060:	4388                	lw	a0,0(a5)
  a24062:	8082                	ret

00a24064 <tcxo_porting_ticks_per_usec_set>:
  a24064:	00a0 2474 079f      	l.li	a5,0xa02474
  a2406a:	c388                	sw	a0,0(a5)
  a2406c:	8082                	ret

00a2406e <watchdog_port_register_hal_funcs>:
  a2406e:	8018                	push	{ra},-16
  a24070:	a0fff0ef          	jal	ra,a23a7e <hal_watchdog_v151_funcs_get>
  a24074:	8010                	pop	{ra},16
  a24076:	863ff06f          	j	a238d8 <hal_watchdog_register_funcs>

00a2407a <watchdog_port_unregister_hal_funcs>:
  a2407a:	875ff06f          	j	a238ee <hal_watchdog_unregister_funcs>

00a2407e <watchdog_port_register_irq>:
  a2407e:	8082                	ret

00a24080 <watchdog_port_set_clock>:
  a24080:	8028                	push	{ra,s0},-16
  a24082:	842a                	mv	s0,a0
  a24084:	ffdfd0ef          	jal	ra,a22080 <osal_irq_lock>
  a24088:	00a0 247c 079f      	l.li	a5,0xa0247c
  a2408e:	c380                	sw	s0,0(a5)
  a24090:	8020                	pop	{ra,s0},16
  a24092:	ff7fd06f          	j	a22088 <osal_irq_restore>

00a24096 <watchdog_port_get_clock>:
  a24096:	00a0 247c 079f      	l.li	a5,0xa0247c
  a2409c:	4388                	lw	a0,0(a5)
  a2409e:	8082                	ret

00a240a0 <sfc_port_get_flash_spi_infos>:
  a240a0:	00a2 7004 051f      	l.li	a0,0xa27004
  a240a6:	8082                	ret

00a240a8 <sfc_port_get_flash_num>:
  a240a8:	4505                	li	a0,1
  a240aa:	8082                	ret

00a240ac <sfc_port_get_unknown_flash_info>:
  a240ac:	00a2 7020 051f      	l.li	a0,0xa27020
  a240b2:	8082                	ret

00a240b4 <sfc_port_get_sfc_start_addr>:
  a240b4:	00200537          	lui	a0,0x200
  a240b8:	8082                	ret

00a240ba <sfc_port_get_sfc_end_addr>:
  a240ba:	009f ffff 051f      	l.li	a0,0x9fffff
  a240c0:	8082                	ret

00a240c2 <sfc_port_get_sfc_global_conf_base_addr>:
  a240c2:	4800 0100 051f      	l.li	a0,0x48000100
  a240c8:	8082                	ret

00a240ca <sfc_port_get_sfc_bus_regs_base_addr>:
  a240ca:	4800 0200 051f      	l.li	a0,0x48000200
  a240d0:	8082                	ret

00a240d2 <sfc_port_get_sfc_bus_dma_regs_base_addr>:
  a240d2:	4800 0240 051f      	l.li	a0,0x48000240
  a240d8:	8082                	ret

00a240da <sfc_port_get_sfc_cmd_regs_base_addr>:
  a240da:	4800 0300 051f      	l.li	a0,0x48000300
  a240e0:	8082                	ret

00a240e2 <sfc_port_get_sfc_cmd_databuf_base_addr>:
  a240e2:	4800 0400 051f      	l.li	a0,0x48000400
  a240e8:	8082                	ret

00a240ea <sfc_port_get_delay_once_time>:
  a240ea:	00a0 2480 079f      	l.li	a5,0xa02480
  a240f0:	4388                	lw	a0,0(a5)
  a240f2:	8082                	ret

00a240f4 <sfc_port_get_delay_times>:
  a240f4:	00a0 2484 079f      	l.li	a5,0xa02484
  a240fa:	4388                	lw	a0,0(a5)
  a240fc:	8082                	ret

00a240fe <sfc_port_lock_init>:
  a240fe:	8082                	ret

00a24100 <sfc_port_lock>:
  a24100:	4501                	li	a0,0
  a24102:	8082                	ret

00a24104 <sfc_port_unlock>:
  a24104:	8082                	ret

00a24106 <hal_sfc_regs_wait_ready.constprop.0>:
  a24106:	8158                	push	{ra,s0-s3},-48
  a24108:	fedff0ef          	jal	ra,a240f4 <sfc_port_get_delay_times>
  a2410c:	84aa                	mv	s1,a0
  a2410e:	fddff0ef          	jal	ra,a240ea <sfc_port_get_delay_once_time>
  a24112:	02800793          	li	a5,40
  a24116:	c23e                	sw	a5,4(sp)
  a24118:	4785                	li	a5,1
  a2411a:	892a                	mv	s2,a0
  a2411c:	c602                	sw	zero,12(sp)
  a2411e:	c43e                	sw	a5,8(sp)
  a24120:	4401                	li	s0,0
  a24122:	00a079b7          	lui	s3,0xa07
  a24126:	0048                	addi	a0,sp,4
  a24128:	d6dff0ef          	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a2412c:	4601                	li	a2,0
  a2412e:	4585                	li	a1,1
  a24130:	4505                	li	a0,1
  a24132:	d9bff0ef          	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a24136:	dc5ff0ef          	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a2413a:	8c89a783          	lw	a5,-1848(s3) # a068c8 <g_sfc_cmd_databuf>
  a2413e:	439c                	lw	a5,0(a5)
  a24140:	8b85                	andi	a5,a5,1
  a24142:	cf91                	beqz	a5,a2415e <hal_sfc_regs_wait_ready.constprop.0+0x58>
  a24144:	854a                	mv	a0,s2
  a24146:	a92fe0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a2414a:	00140793          	addi	a5,s0,1
  a2414e:	00946663          	bltu	s0,s1,a2415a <hal_sfc_regs_wait_ready.constprop.0+0x54>
  a24152:	8000 1344 051f      	l.li	a0,0x80001344
  a24158:	8154                	popret	{ra,s0-s3},48
  a2415a:	843e                	mv	s0,a5
  a2415c:	b7e9                	j	a24126 <hal_sfc_regs_wait_ready.constprop.0+0x20>
  a2415e:	4501                	li	a0,0
  a24160:	bfe5                	j	a24158 <hal_sfc_regs_wait_ready.constprop.0+0x52>

00a24162 <sfc_port_write_sr>:
  a24162:	8148                	push	{ra,s0-s2},-32
  a24164:	892a                	mv	s2,a0
  a24166:	842e                	mv	s0,a1
  a24168:	84b2                	mv	s1,a2
  a2416a:	f9dff0ef          	jal	ra,a24106 <hal_sfc_regs_wait_ready.constprop.0>
  a2416e:	4792                	lw	a5,4(sp)
  a24170:	4719                	li	a4,6
  a24172:	9be1                	andi	a5,a5,-8
  a24174:	0017e793          	ori	a5,a5,1
  a24178:	c23e                	sw	a5,4(sp)
  a2417a:	00090463          	beqz	s2,a24182 <sfc_port_write_sr+0x20>
  a2417e:	05000713          	li	a4,80
  a24182:	4792                	lw	a5,4(sp)
  a24184:	0048                	addi	a0,sp,4
  a24186:	c402                	sw	zero,8(sp)
  a24188:	8077f793          	andi	a5,a5,-2041
  a2418c:	06e7a79b          	orshf	a5,a5,a4,sll,3
  a24190:	7ff7f793          	andi	a5,a5,2047
  a24194:	c23e                	sw	a5,4(sp)
  a24196:	c602                	sw	zero,12(sp)
  a24198:	cfdff0ef          	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a2419c:	4601                	li	a2,0
  a2419e:	4581                	li	a1,0
  a241a0:	4501                	li	a0,0
  a241a2:	d2bff0ef          	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a241a6:	d55ff0ef          	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a241aa:	4785                	li	a5,1
  a241ac:	c43e                	sw	a5,8(sp)
  a241ae:	00a077b7          	lui	a5,0xa07
  a241b2:	8c87a783          	lw	a5,-1848(a5) # a068c8 <g_sfc_cmd_databuf>
  a241b6:	040e                	slli	s0,s0,0x3
  a241b8:	00146413          	ori	s0,s0,1
  a241bc:	c222                	sw	s0,4(sp)
  a241be:	c602                	sw	zero,12(sp)
  a241c0:	c384                	sw	s1,0(a5)
  a241c2:	0048                	addi	a0,sp,4
  a241c4:	cd1ff0ef          	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a241c8:	4601                	li	a2,0
  a241ca:	4585                	li	a1,1
  a241cc:	4501                	li	a0,0
  a241ce:	cffff0ef          	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a241d2:	d29ff0ef          	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a241d6:	8144                	popret	{ra,s0-s2},32

00a241d8 <sfc_port_read_sr>:
  a241d8:	8118                	push	{ra},-32
  a241da:	9d01                	uxtb	a0
  a241dc:	4785                	li	a5,1
  a241de:	050e                	slli	a0,a0,0x3
  a241e0:	c43e                	sw	a5,8(sp)
  a241e2:	c602                	sw	zero,12(sp)
  a241e4:	c22a                	sw	a0,4(sp)
  a241e6:	f21ff0ef          	jal	ra,a24106 <hal_sfc_regs_wait_ready.constprop.0>
  a241ea:	0048                	addi	a0,sp,4
  a241ec:	ca9ff0ef          	jal	ra,a23e94 <hal_sfc_regs_set_opt>
  a241f0:	4601                	li	a2,0
  a241f2:	4585                	li	a1,1
  a241f4:	4505                	li	a0,1
  a241f6:	cd7ff0ef          	jal	ra,a23ecc <hal_sfc_regs_set_opt_attr>
  a241fa:	d01ff0ef          	jal	ra,a23efa <hal_sfc_regs_wait_config>
  a241fe:	00a077b7          	lui	a5,0xa07
  a24202:	8c87a783          	lw	a5,-1848(a5) # a068c8 <g_sfc_cmd_databuf>
  a24206:	4388                	lw	a0,0(a5)
  a24208:	8114                	popret	{ra},32

00a2420a <sfc_port_write_lock>:
  a2420a:	000207b7          	lui	a5,0x20
  a2420e:	00f56863          	bltu	a0,a5,a2421e <sfc_port_write_lock+0x14>
  a24212:	004007b7          	lui	a5,0x400
  a24216:	00b7ec63          	bltu	a5,a1,a2422e <sfc_port_write_lock+0x24>
  a2421a:	4781                	li	a5,0
  a2421c:	a005                	j	a2423c <sfc_port_write_lock+0x32>
  a2421e:	67a1                	lui	a5,0x8
  a24220:	00f56963          	bltu	a0,a5,a24232 <sfc_port_write_lock+0x28>
  a24224:	00400737          	lui	a4,0x400
  a24228:	4785                	li	a5,1
  a2422a:	00b77963          	bgeu	a4,a1,a2423c <sfc_port_write_lock+0x32>
  a2422e:	4501                	li	a0,0
  a24230:	8082                	ret
  a24232:	004007b7          	lui	a5,0x400
  a24236:	feb7ece3          	bltu	a5,a1,a2422e <sfc_port_write_lock+0x24>
  a2423a:	4789                	li	a5,2
  a2423c:	8018                	push	{ra},-16
  a2423e:	00a2 703c 071f      	l.li	a4,0xa2703c
  a24244:	0cf717db          	muliadd	a5,a4,a5,12
  a24248:	3390                	lbu	a2,1(a5)
  a2424a:	4585                	li	a1,1
  a2424c:	4505                	li	a0,1
  a2424e:	f15ff0ef          	jal	ra,a24162 <sfc_port_write_sr>
  a24252:	4609                	li	a2,2
  a24254:	03100593          	li	a1,49
  a24258:	4505                	li	a0,1
  a2425a:	f09ff0ef          	jal	ra,a24162 <sfc_port_write_sr>
  a2425e:	4501                	li	a0,0
  a24260:	8014                	popret	{ra},16

00a24262 <sfc_port_write_unlock>:
  a24262:	8018                	push	{ra},-16
  a24264:	4671                	li	a2,28
  a24266:	4585                	li	a1,1
  a24268:	4505                	li	a0,1
  a2426a:	ef9ff0ef          	jal	ra,a24162 <sfc_port_write_sr>
  a2426e:	4609                	li	a2,2
  a24270:	03100593          	li	a1,49
  a24274:	4505                	li	a0,1
  a24276:	8010                	pop	{ra},16
  a24278:	eebff06f          	j	a24162 <sfc_port_write_sr>

00a2427c <sfc_port_fix_sr>:
  a2427c:	8118                	push	{ra},-32
  a2427e:	0068                	addi	a0,sp,12
  a24280:	c602                	sw	zero,12(sp)
  a24282:	9cfff0ef          	jal	ra,a23c50 <hal_sfc_get_flash_id>
  a24286:	e901                	bnez	a0,a24296 <sfc_port_fix_sr+0x1a>
  a24288:	4732                	lw	a4,12(sp)
  a2428a:	0016 40c8 079f      	l.li	a5,0x1640c8
  a24290:	00f71463          	bne	a4,a5,a24298 <sfc_port_fix_sr+0x1c>
  a24294:	2079                	jal	ra,a24322 <sfc_port_fix_sr_gd25q32>
  a24296:	8114                	popret	{ra},32
  a24298:	80000537          	lui	a0,0x80000
  a2429c:	0509                	addi	a0,a0,2 # 80000002 <__data_load__+0x7f5d85ce>
  a2429e:	bfe5                	j	a24296 <sfc_port_fix_sr+0x1a>

00a242a0 <sfc_port_gd25q32_read_sr>:
  a242a0:	8078                	push	{ra,s0-s5},-32
  a242a2:	892a                	mv	s2,a0
  a242a4:	448d                	li	s1,3
  a242a6:	4995                	li	s3,5
  a242a8:	03500a13          	li	s4,53
  a242ac:	00a27ab7          	lui	s5,0xa27
  a242b0:	854a                	mv	a0,s2
  a242b2:	f27ff0ef          	jal	ra,a241d8 <sfc_port_read_sr>
  a242b6:	0ff57413          	andi	s0,a0,255
  a242ba:	03391f63          	bne	s2,s3,a242f8 <sfc_port_gd25q32_read_sr+0x58>
  a242be:	09c47413          	andi	s0,s0,156
  a242c2:	1411                	addi	s0,s0,-28
  a242c4:	00143413          	seqz	s0,s0
  a242c8:	4585                	li	a1,1
  a242ca:	46f1                	li	a3,28
  a242cc:	e419                	bnez	s0,a242da <sfc_port_gd25q32_read_sr+0x3a>
  a242ce:	0ff57613          	andi	a2,a0,255
  a242d2:	088a8513          	addi	a0,s5,136 # a27088 <g_sfc_protect_cfg+0x4c>
  a242d6:	d29ff0ef          	jal	ra,a23ffe <print_str>
  a242da:	884fe0ef          	jal	ra,a2235e <uapi_tcxo_get_count>
  a242de:	06400613          	li	a2,100
  a242e2:	4681                	li	a3,0
  a242e4:	b5cfc0ef          	jal	ra,a20640 <__umoddi3>
  a242e8:	0505                	addi	a0,a0,1
  a242ea:	8eefe0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a242ee:	c805                	beqz	s0,a2431e <sfc_port_gd25q32_read_sr+0x7e>
  a242f0:	14fd                	addi	s1,s1,-1
  a242f2:	fcdd                	bnez	s1,a242b0 <sfc_port_gd25q32_read_sr+0x10>
  a242f4:	4501                	li	a0,0
  a242f6:	8074                	popret	{ra,s0-s5},32
  a242f8:	01491a63          	bne	s2,s4,a2430c <sfc_port_gd25q32_read_sr+0x6c>
  a242fc:	04347413          	andi	s0,s0,67
  a24300:	1479                	addi	s0,s0,-2
  a24302:	00143413          	seqz	s0,s0
  a24306:	4589                	li	a1,2
  a24308:	4689                	li	a3,2
  a2430a:	b7c9                	j	a242cc <sfc_port_gd25q32_read_sr+0x2c>
  a2430c:	06147413          	andi	s0,s0,97
  a24310:	1401                	addi	s0,s0,-32
  a24312:	00143413          	seqz	s0,s0
  a24316:	458d                	li	a1,3
  a24318:	02000693          	li	a3,32
  a2431c:	bf45                	j	a242cc <sfc_port_gd25q32_read_sr+0x2c>
  a2431e:	557d                	li	a0,-1
  a24320:	bfd9                	j	a242f6 <sfc_port_gd25q32_read_sr+0x56>

00a24322 <sfc_port_fix_sr_gd25q32>:
  a24322:	8068                	push	{ra,s0-s4},-32
  a24324:	4481                	li	s1,0
  a24326:	498d                	li	s3,3
  a24328:	4515                	li	a0,5
  a2432a:	f77ff0ef          	jal	ra,a242a0 <sfc_port_gd25q32_read_sr>
  a2432e:	8a2a                	mv	s4,a0
  a24330:	03500513          	li	a0,53
  a24334:	f6dff0ef          	jal	ra,a242a0 <sfc_port_gd25q32_read_sr>
  a24338:	892a                	mv	s2,a0
  a2433a:	4555                	li	a0,21
  a2433c:	f65ff0ef          	jal	ra,a242a0 <sfc_port_gd25q32_read_sr>
  a24340:	842a                	mv	s0,a0
  a24342:	040a1763          	bnez	s4,a24390 <sfc_port_fix_sr_gd25q32+0x6e>
  a24346:	02090863          	beqz	s2,a24376 <sfc_port_fix_sr_gd25q32+0x54>
  a2434a:	4609                	li	a2,2
  a2434c:	03100593          	li	a1,49
  a24350:	4501                	li	a0,0
  a24352:	e11ff0ef          	jal	ra,a24162 <sfc_port_write_sr>
  a24356:	c419                	beqz	s0,a24364 <sfc_port_fix_sr_gd25q32+0x42>
  a24358:	02000613          	li	a2,32
  a2435c:	45c5                	li	a1,17
  a2435e:	4501                	li	a0,0
  a24360:	e03ff0ef          	jal	ra,a24162 <sfc_port_write_sr>
  a24364:	03c00513          	li	a0,60
  a24368:	0485                	addi	s1,s1,1
  a2436a:	81efe0ef          	jal	ra,a22388 <uapi_tcxo_delay_ms>
  a2436e:	fb349de3          	bne	s1,s3,a24328 <sfc_port_fix_sr_gd25q32+0x6>
  a24372:	547d                	li	s0,-1
  a24374:	a801                	j	a24384 <sfc_port_fix_sr_gd25q32+0x62>
  a24376:	f16d                	bnez	a0,a24358 <sfc_port_fix_sr_gd25q32+0x36>
  a24378:	e881                	bnez	s1,a24388 <sfc_port_fix_sr_gd25q32+0x66>
  a2437a:	00a2 7060 051f      	l.li	a0,0xa27060
  a24380:	7da000ef          	jal	ra,a24b5a <boot_msg0>
  a24384:	8522                	mv	a0,s0
  a24386:	8064                	popret	{ra,s0-s4},32
  a24388:	00a2 7078 051f      	l.li	a0,0xa27078
  a2438e:	bfcd                	j	a24380 <sfc_port_fix_sr_gd25q32+0x5e>
  a24390:	4671                	li	a2,28
  a24392:	4585                	li	a1,1
  a24394:	4501                	li	a0,0
  a24396:	dcdff0ef          	jal	ra,a24162 <sfc_port_write_sr>
  a2439a:	fa090ee3          	beqz	s2,a24356 <sfc_port_fix_sr_gd25q32+0x34>
  a2439e:	b775                	j	a2434a <sfc_port_fix_sr_gd25q32+0x28>

00a243a0 <build_flash_ctrl>:
  a243a0:	455c                	lw	a5,12(a0)
  a243a2:	04b7859b          	addshf	a1,a5,a1,sll,2
  a243a6:	4194                	lw	a3,0(a1)
  a243a8:	491c                	lw	a5,16(a0)
  a243aa:	04c7861b          	addshf	a2,a5,a2,sll,2
  a243ae:	0076f793          	andi	a5,a3,7
  a243b2:	4218                	lw	a4,0(a2)
  a243b4:	01079bbb          	bnei	a5,1,a243e2 <build_flash_ctrl+0x42>
  a243b8:	8b1d                	andi	a4,a4,7
  a243ba:	02f71463          	bne	a4,a5,a243e2 <build_flash_ctrl+0x42>
  a243be:	00a0 6958 079f      	l.li	a5,0xa06958
  a243c4:	c3d4                	sw	a3,4(a5)
  a243c6:	4214                	lw	a3,0(a2)
  a243c8:	c7d4                	sw	a3,12(a5)
  a243ca:	4954                	lw	a3,20(a0)
  a243cc:	cb94                	sw	a3,16(a5)
  a243ce:	4154                	lw	a3,4(a0)
  a243d0:	c394                	sw	a3,0(a5)
  a243d2:	4514                	lw	a3,8(a0)
  a243d4:	00d77b63          	bgeu	a4,a3,a243ea <build_flash_ctrl+0x4a>
  a243d8:	4d18                	lw	a4,24(a0)
  a243da:	c794                	sw	a3,8(a5)
  a243dc:	4501                	li	a0,0
  a243de:	cbd8                	sw	a4,20(a5)
  a243e0:	8082                	ret
  a243e2:	8000 1346 051f      	l.li	a0,0x80001346
  a243e8:	8082                	ret
  a243ea:	8000 1349 051f      	l.li	a0,0x80001349
  a243f0:	8082                	ret

00a243f2 <check_opt_param>:
  a243f2:	00a0 6970 079f      	l.li	a5,0xa06970
  a243f8:	239c                	lbu	a5,0(a5)
  a243fa:	cf99                	beqz	a5,a24418 <check_opt_param+0x26>
  a243fc:	00a0 6958 071f      	l.li	a4,0xa06958
  a24402:	4318                	lw	a4,0(a4)
  a24404:	00b507b3          	add	a5,a0,a1
  a24408:	00f76c63          	bltu	a4,a5,a24420 <check_opt_param+0x2e>
  a2440c:	00f57a63          	bgeu	a0,a5,a24420 <check_opt_param+0x2e>
  a24410:	00b7e863          	bltu	a5,a1,a24420 <check_opt_param+0x2e>
  a24414:	4501                	li	a0,0
  a24416:	8082                	ret
  a24418:	8000 1340 051f      	l.li	a0,0x80001340
  a2441e:	8082                	ret
  a24420:	80000537          	lui	a0,0x80000
  a24424:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a24426:	8082                	ret

00a24428 <check_init_param>:
  a24428:	8078                	push	{ra,s0-s5},-32
  a2442a:	00452a83          	lw	s5,4(a0)
  a2442e:	00a07937          	lui	s2,0xa07
  a24432:	89aa                	mv	s3,a0
  a24434:	95892403          	lw	s0,-1704(s2) # a06958 <g_flash_ctrl>
  a24438:	00852a03          	lw	s4,8(a0)
  a2443c:	c79ff0ef          	jal	ra,a240b4 <sfc_port_get_sfc_start_addr>
  a24440:	00aaf663          	bgeu	s5,a0,a2444c <check_init_param+0x24>
  a24444:	8000 1342 051f      	l.li	a0,0x80001342
  a2444a:	8074                	popret	{ra,s0-s5},32
  a2444c:	95890913          	addi	s2,s2,-1704
  a24450:	008a7363          	bgeu	s4,s0,a24456 <check_init_param+0x2e>
  a24454:	8452                	mv	s0,s4
  a24456:	0049a483          	lw	s1,4(s3)
  a2445a:	14fd                	addi	s1,s1,-1
  a2445c:	94a2                	add	s1,s1,s0
  a2445e:	c5dff0ef          	jal	ra,a240ba <sfc_port_get_sfc_end_addr>
  a24462:	fe9561e3          	bltu	a0,s1,a24444 <check_init_param+0x1c>
  a24466:	00892023          	sw	s0,0(s2)
  a2446a:	4501                	li	a0,0
  a2446c:	bff9                	j	a2444a <check_init_param+0x22>

00a2446e <uapi_sfc_init>:
  a2446e:	00a077b7          	lui	a5,0xa07
  a24472:	9707c703          	lbu	a4,-1680(a5) # a06970 <g_sfc_inited>
  a24476:	ef59                	bnez	a4,a24514 <uapi_sfc_init+0xa6>
  a24478:	8258                	push	{ra,s0-s3},-64
  a2447a:	842a                	mv	s0,a0
  a2447c:	97078913          	addi	s2,a5,-1680
  a24480:	c7fff0ef          	jal	ra,a240fe <sfc_port_lock_init>
  a24484:	0868                	addi	a0,sp,28
  a24486:	fcaff0ef          	jal	ra,a23c50 <hal_sfc_get_flash_id>
  a2448a:	e151                	bnez	a0,a2450e <uapi_sfc_init+0xa0>
  a2448c:	200c                	lbu	a1,0(s0)
  a2448e:	3010                	lbu	a2,1(s0)
  a24490:	49f2                	lw	s3,28(sp)
  a24492:	c62e                	sw	a1,12(sp)
  a24494:	c432                	sw	a2,8(sp)
  a24496:	c0bff0ef          	jal	ra,a240a0 <sfc_port_get_flash_spi_infos>
  a2449a:	84aa                	mv	s1,a0
  a2449c:	c0dff0ef          	jal	ra,a240a8 <sfc_port_get_flash_num>
  a244a0:	4622                	lw	a2,8(sp)
  a244a2:	45b2                	lw	a1,12(sp)
  a244a4:	86aa                	mv	a3,a0
  a244a6:	87a6                	mv	a5,s1
  a244a8:	4701                	li	a4,0
  a244aa:	04e69963          	bne	a3,a4,a244fc <uapi_sfc_init+0x8e>
  a244ae:	bffff0ef          	jal	ra,a240ac <sfc_port_get_unknown_flash_info>
  a244b2:	4605                	li	a2,1
  a244b4:	4581                	li	a1,0
  a244b6:	eebff0ef          	jal	ra,a243a0 <build_flash_ctrl>
  a244ba:	e931                	bnez	a0,a2450e <uapi_sfc_init+0xa0>
  a244bc:	00a0 6971 079f      	l.li	a5,0xa06971
  a244c2:	4705                	li	a4,1
  a244c4:	a398                	sb	a4,0(a5)
  a244c6:	8522                	mv	a0,s0
  a244c8:	f61ff0ef          	jal	ra,a24428 <check_init_param>
  a244cc:	e129                	bnez	a0,a2450e <uapi_sfc_init+0xa0>
  a244ce:	00a07537          	lui	a0,0xa07
  a244d2:	95852603          	lw	a2,-1704(a0) # a06958 <g_flash_ctrl>
  a244d6:	404c                	lw	a1,4(s0)
  a244d8:	95850513          	addi	a0,a0,-1704
  a244dc:	fb8ff0ef          	jal	ra,a23c94 <hal_sfc_init>
  a244e0:	e51d                	bnez	a0,a2450e <uapi_sfc_init+0xa0>
  a244e2:	4785                	li	a5,1
  a244e4:	00f90023          	sb	a5,0(s2)
  a244e8:	00a0 6971 079f      	l.li	a5,0xa06971
  a244ee:	239c                	lbu	a5,0(a5)
  a244f0:	4501                	li	a0,0
  a244f2:	cf91                	beqz	a5,a2450e <uapi_sfc_init+0xa0>
  a244f4:	8000 1341 051f      	l.li	a0,0x80001341
  a244fa:	a811                	j	a2450e <uapi_sfc_init+0xa0>
  a244fc:	853e                	mv	a0,a5
  a244fe:	07f1                	addi	a5,a5,28
  a24500:	fe47a803          	lw	a6,-28(a5)
  a24504:	01099663          	bne	s3,a6,a24510 <uapi_sfc_init+0xa2>
  a24508:	e99ff0ef          	jal	ra,a243a0 <build_flash_ctrl>
  a2450c:	dd4d                	beqz	a0,a244c6 <uapi_sfc_init+0x58>
  a2450e:	8254                	popret	{ra,s0-s3},64
  a24510:	0705                	addi	a4,a4,1 # 400001 <g_intheap_size+0x3e6aa1>
  a24512:	bf61                	j	a244aa <uapi_sfc_init+0x3c>
  a24514:	4501                	li	a0,0
  a24516:	8082                	ret

00a24518 <uapi_sfc_reg_read>:
  a24518:	8188                	push	{ra,s0-s6},-48
  a2451a:	8a2e                	mv	s4,a1
  a2451c:	85b2                	mv	a1,a2
  a2451e:	892a                	mv	s2,a0
  a24520:	84b2                	mv	s1,a2
  a24522:	ed1ff0ef          	jal	ra,a243f2 <check_opt_param>
  a24526:	e13d                	bnez	a0,a2458c <uapi_sfc_reg_read+0x74>
  a24528:	bd9ff0ef          	jal	ra,a24100 <sfc_port_lock>
  a2452c:	00397b13          	andi	s6,s2,3
  a24530:	8aaa                	mv	s5,a0
  a24532:	060b0263          	beqz	s6,a24596 <uapi_sfc_reg_read+0x7e>
  a24536:	4791                	li	a5,4
  a24538:	416787b3          	sub	a5,a5,s6
  a2453c:	41690933          	sub	s2,s2,s6
  a24540:	0ff4f993          	andi	s3,s1,255
  a24544:	00f4e763          	bltu	s1,a5,a24552 <uapi_sfc_reg_read+0x3a>
  a24548:	4991                	li	s3,4
  a2454a:	416989b3          	sub	s3,s3,s6
  a2454e:	0ff9f993          	andi	s3,s3,255
  a24552:	00a0 6958 079f      	l.li	a5,0xa06958
  a24558:	43d4                	lw	a3,4(a5)
  a2455a:	4611                	li	a2,4
  a2455c:	006c                	addi	a1,sp,12
  a2455e:	854a                	mv	a0,s2
  a24560:	c602                	sw	zero,12(sp)
  a24562:	815ff0ef          	jal	ra,a23d76 <hal_sfc_reg_read>
  a24566:	842a                	mv	s0,a0
  a24568:	ed11                	bnez	a0,a24584 <uapi_sfc_reg_read+0x6c>
  a2456a:	007c                	addi	a5,sp,12
  a2456c:	86ce                	mv	a3,s3
  a2456e:	01678633          	add	a2,a5,s6
  a24572:	85ce                	mv	a1,s3
  a24574:	8552                	mv	a0,s4
  a24576:	7f7000ef          	jal	ra,a2556c <memcpy_s>
  a2457a:	c911                	beqz	a0,a2458e <uapi_sfc_reg_read+0x76>
  a2457c:	80000537          	lui	a0,0x80000
  a24580:	00450413          	addi	s0,a0,4 # 80000004 <__data_load__+0x7f5d85d0>
  a24584:	8556                	mv	a0,s5
  a24586:	b7fff0ef          	jal	ra,a24104 <sfc_port_unlock>
  a2458a:	8522                	mv	a0,s0
  a2458c:	8184                	popret	{ra,s0-s6},48
  a2458e:	0911                	addi	s2,s2,4
  a24590:	9a4e                	add	s4,s4,s3
  a24592:	413484b3          	sub	s1,s1,s3
  a24596:	ffc4f993          	andi	s3,s1,-4
  a2459a:	02098163          	beqz	s3,a245bc <uapi_sfc_reg_read+0xa4>
  a2459e:	00a0 6958 079f      	l.li	a5,0xa06958
  a245a4:	43d4                	lw	a3,4(a5)
  a245a6:	864e                	mv	a2,s3
  a245a8:	85d2                	mv	a1,s4
  a245aa:	854a                	mv	a0,s2
  a245ac:	fcaff0ef          	jal	ra,a23d76 <hal_sfc_reg_read>
  a245b0:	842a                	mv	s0,a0
  a245b2:	f969                	bnez	a0,a24584 <uapi_sfc_reg_read+0x6c>
  a245b4:	9a4e                	add	s4,s4,s3
  a245b6:	994e                	add	s2,s2,s3
  a245b8:	413484b3          	sub	s1,s1,s3
  a245bc:	4401                	li	s0,0
  a245be:	d0f9                	beqz	s1,a24584 <uapi_sfc_reg_read+0x6c>
  a245c0:	00a0 6958 079f      	l.li	a5,0xa06958
  a245c6:	43d4                	lw	a3,4(a5)
  a245c8:	4611                	li	a2,4
  a245ca:	006c                	addi	a1,sp,12
  a245cc:	854a                	mv	a0,s2
  a245ce:	c602                	sw	zero,12(sp)
  a245d0:	fa6ff0ef          	jal	ra,a23d76 <hal_sfc_reg_read>
  a245d4:	842a                	mv	s0,a0
  a245d6:	86a6                	mv	a3,s1
  a245d8:	0070                	addi	a2,sp,12
  a245da:	85a6                	mv	a1,s1
  a245dc:	8552                	mv	a0,s4
  a245de:	78f000ef          	jal	ra,a2556c <memcpy_s>
  a245e2:	d14d                	beqz	a0,a24584 <uapi_sfc_reg_read+0x6c>
  a245e4:	80000437          	lui	s0,0x80000
  a245e8:	0411                	addi	s0,s0,4 # 80000004 <__data_load__+0x7f5d85d0>
  a245ea:	bf69                	j	a24584 <uapi_sfc_reg_read+0x6c>

00a245ec <uapi_sfc_reg_write>:
  a245ec:	8198                	push	{ra,s0-s7},-64
  a245ee:	8a2e                	mv	s4,a1
  a245f0:	85b2                	mv	a1,a2
  a245f2:	84aa                	mv	s1,a0
  a245f4:	8932                	mv	s2,a2
  a245f6:	dfdff0ef          	jal	ra,a243f2 <check_opt_param>
  a245fa:	842a                	mv	s0,a0
  a245fc:	e571                	bnez	a0,a246c8 <uapi_sfc_reg_write+0xdc>
  a245fe:	012485b3          	add	a1,s1,s2
  a24602:	8526                	mv	a0,s1
  a24604:	c07ff0ef          	jal	ra,a2420a <sfc_port_write_lock>
  a24608:	0034fa93          	andi	s5,s1,3
  a2460c:	8b2a                	mv	s6,a0
  a2460e:	060a8863          	beqz	s5,a2467e <uapi_sfc_reg_write+0x92>
  a24612:	4791                	li	a5,4
  a24614:	415787b3          	sub	a5,a5,s5
  a24618:	415484b3          	sub	s1,s1,s5
  a2461c:	0ff97993          	andi	s3,s2,255
  a24620:	00f96763          	bltu	s2,a5,a2462e <uapi_sfc_reg_write+0x42>
  a24624:	4991                	li	s3,4
  a24626:	415989b3          	sub	s3,s3,s5
  a2462a:	0ff9f993          	andi	s3,s3,255
  a2462e:	00a0 6958 0b9f      	l.li	s7,0xa06958
  a24634:	004ba683          	lw	a3,4(s7) # ffe00004 <__data_load__+0xff3d85d0>
  a24638:	4611                	li	a2,4
  a2463a:	006c                	addi	a1,sp,12
  a2463c:	8526                	mv	a0,s1
  a2463e:	f38ff0ef          	jal	ra,a23d76 <hal_sfc_reg_read>
  a24642:	842a                	mv	s0,a0
  a24644:	ed09                	bnez	a0,a2465e <uapi_sfc_reg_write+0x72>
  a24646:	007c                	addi	a5,sp,12
  a24648:	86ce                	mv	a3,s3
  a2464a:	8652                	mv	a2,s4
  a2464c:	85ce                	mv	a1,s3
  a2464e:	01578533          	add	a0,a5,s5
  a24652:	71b000ef          	jal	ra,a2556c <memcpy_s>
  a24656:	c901                	beqz	a0,a24666 <uapi_sfc_reg_write+0x7a>
  a24658:	80000437          	lui	s0,0x80000
  a2465c:	0411                	addi	s0,s0,4 # 80000004 <__data_load__+0x7f5d85d0>
  a2465e:	855a                	mv	a0,s6
  a24660:	c03ff0ef          	jal	ra,a24262 <sfc_port_write_unlock>
  a24664:	a095                	j	a246c8 <uapi_sfc_reg_write+0xdc>
  a24666:	00cba683          	lw	a3,12(s7)
  a2466a:	8526                	mv	a0,s1
  a2466c:	4611                	li	a2,4
  a2466e:	006c                	addi	a1,sp,12
  a24670:	f92ff0ef          	jal	ra,a23e02 <hal_sfc_reg_write>
  a24674:	842a                	mv	s0,a0
  a24676:	0491                	addi	s1,s1,4
  a24678:	9a4e                	add	s4,s4,s3
  a2467a:	41390933          	sub	s2,s2,s3
  a2467e:	ffc97993          	andi	s3,s2,-4
  a24682:	fc71                	bnez	s0,a2465e <uapi_sfc_reg_write+0x72>
  a24684:	02098063          	beqz	s3,a246a4 <uapi_sfc_reg_write+0xb8>
  a24688:	00a0 6958 079f      	l.li	a5,0xa06958
  a2468e:	47d4                	lw	a3,12(a5)
  a24690:	85d2                	mv	a1,s4
  a24692:	8526                	mv	a0,s1
  a24694:	864e                	mv	a2,s3
  a24696:	f6cff0ef          	jal	ra,a23e02 <hal_sfc_reg_write>
  a2469a:	9a4e                	add	s4,s4,s3
  a2469c:	94ce                	add	s1,s1,s3
  a2469e:	41390933          	sub	s2,s2,s3
  a246a2:	e131                	bnez	a0,a246e6 <uapi_sfc_reg_write+0xfa>
  a246a4:	fa090de3          	beqz	s2,a2465e <uapi_sfc_reg_write+0x72>
  a246a8:	00a0 6958 041f      	l.li	s0,0xa06958
  a246ae:	4054                	lw	a3,4(s0)
  a246b0:	4611                	li	a2,4
  a246b2:	006c                	addi	a1,sp,12
  a246b4:	8526                	mv	a0,s1
  a246b6:	ec0ff0ef          	jal	ra,a23d76 <hal_sfc_reg_read>
  a246ba:	c909                	beqz	a0,a246cc <uapi_sfc_reg_write+0xe0>
  a246bc:	855a                	mv	a0,s6
  a246be:	80000437          	lui	s0,0x80000
  a246c2:	ba1ff0ef          	jal	ra,a24262 <sfc_port_write_unlock>
  a246c6:	0411                	addi	s0,s0,4 # 80000004 <__data_load__+0x7f5d85d0>
  a246c8:	8522                	mv	a0,s0
  a246ca:	8194                	popret	{ra,s0-s7},64
  a246cc:	86ca                	mv	a3,s2
  a246ce:	8652                	mv	a2,s4
  a246d0:	4591                	li	a1,4
  a246d2:	0068                	addi	a0,sp,12
  a246d4:	699000ef          	jal	ra,a2556c <memcpy_s>
  a246d8:	f175                	bnez	a0,a246bc <uapi_sfc_reg_write+0xd0>
  a246da:	4454                	lw	a3,12(s0)
  a246dc:	4611                	li	a2,4
  a246de:	006c                	addi	a1,sp,12
  a246e0:	8526                	mv	a0,s1
  a246e2:	f20ff0ef          	jal	ra,a23e02 <hal_sfc_reg_write>
  a246e6:	842a                	mv	s0,a0
  a246e8:	bf9d                	j	a2465e <uapi_sfc_reg_write+0x72>

00a246ea <uapi_sfc_reg_erase>:
  a246ea:	80a8                	push	{ra,s0-s8},-48
  a246ec:	892a                	mv	s2,a0
  a246ee:	842e                	mv	s0,a1
  a246f0:	d03ff0ef          	jal	ra,a243f2 <check_opt_param>
  a246f4:	e921                	bnez	a0,a24744 <uapi_sfc_reg_erase+0x5a>
  a246f6:	008905b3          	add	a1,s2,s0
  a246fa:	77fd                	lui	a5,0xfffff
  a246fc:	01459713          	slli	a4,a1,0x14
  a24700:	00f974b3          	and	s1,s2,a5
  a24704:	cf41                	beqz	a4,a2479c <uapi_sfc_reg_erase+0xb2>
  a24706:	8fed                	and	a5,a5,a1
  a24708:	6705                	lui	a4,0x1
  a2470a:	80000537          	lui	a0,0x80000
  a2470e:	97ba                	add	a5,a5,a4
  a24710:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a24712:	02991963          	bne	s2,s1,a24744 <uapi_sfc_reg_erase+0x5a>
  a24716:	02f59763          	bne	a1,a5,a24744 <uapi_sfc_reg_erase+0x5a>
  a2471a:	8526                	mv	a0,s1
  a2471c:	40958a33          	sub	s4,a1,s1
  a24720:	6b11                	lui	s6,0x4
  a24722:	ae9ff0ef          	jal	ra,a2420a <sfc_port_write_lock>
  a24726:	8c2a                	mv	s8,a0
  a24728:	4901                	li	s2,0
  a2472a:	4981                	li	s3,0
  a2472c:	4a81                	li	s5,0
  a2472e:	00a0 6958 0b9f      	l.li	s7,0xa06958
  a24734:	1b7d                	addi	s6,s6,-1 # 3fff <ccause+0x303d>
  a24736:	040a1d63          	bnez	s4,a24790 <uapi_sfc_reg_erase+0xa6>
  a2473a:	4401                	li	s0,0
  a2473c:	8562                	mv	a0,s8
  a2473e:	b25ff0ef          	jal	ra,a24262 <sfc_port_write_unlock>
  a24742:	8522                	mv	a0,s0
  a24744:	80a4                	popret	{ra,s0-s8},48
  a24746:	010ba703          	lw	a4,16(s7)
  a2474a:	04f7071b          	addshf	a4,a4,a5,sll,2
  a2474e:	00072903          	lw	s2,0(a4) # 1000 <ccause+0x3e>
  a24752:	00e95993          	srli	s3,s2,0xe
  a24756:	8ace                	mv	s5,s3
  a24758:	013a6663          	bltu	s4,s3,a24764 <uapi_sfc_reg_erase+0x7a>
  a2475c:	fff98713          	addi	a4,s3,-1
  a24760:	8f65                	and	a4,a4,s1
  a24762:	cb01                	beqz	a4,a24772 <uapi_sfc_reg_erase+0x88>
  a24764:	0785                	addi	a5,a5,1 # fffff001 <__data_load__+0xff5d75cd>
  a24766:	008ba703          	lw	a4,8(s7)
  a2476a:	fce7eee3          	bltu	a5,a4,a24746 <uapi_sfc_reg_erase+0x5c>
  a2476e:	02e78363          	beq	a5,a4,a24794 <uapi_sfc_reg_erase+0xaa>
  a24772:	01697933          	and	s2,s2,s6
  a24776:	1d39291b          	orshf	s2,s2,s3,sll,14
  a2477a:	4601                	li	a2,0
  a2477c:	85ca                	mv	a1,s2
  a2477e:	8526                	mv	a0,s1
  a24780:	ee2ff0ef          	jal	ra,a23e62 <hal_sfc_reg_erase>
  a24784:	842a                	mv	s0,a0
  a24786:	f95d                	bnez	a0,a2473c <uapi_sfc_reg_erase+0x52>
  a24788:	415a0a33          	sub	s4,s4,s5
  a2478c:	94d6                	add	s1,s1,s5
  a2478e:	b765                	j	a24736 <uapi_sfc_reg_erase+0x4c>
  a24790:	4785                	li	a5,1
  a24792:	bfd1                	j	a24766 <uapi_sfc_reg_erase+0x7c>
  a24794:	8000 1347 041f      	l.li	s0,0x80001347
  a2479a:	b74d                	j	a2473c <uapi_sfc_reg_erase+0x52>
  a2479c:	f6990fe3          	beq	s2,s1,a2471a <uapi_sfc_reg_erase+0x30>
  a247a0:	80000537          	lui	a0,0x80000
  a247a4:	0505                	addi	a0,a0,1 # 80000001 <__data_load__+0x7f5d85cd>
  a247a6:	bf79                	j	a24744 <uapi_sfc_reg_erase+0x5a>

00a247a8 <uapi_sfc_reg_erase_chip>:
  a247a8:	8038                	push	{ra,s0-s1},-16
  a247aa:	00a0 6970 079f      	l.li	a5,0xa06970
  a247b0:	239c                	lbu	a5,0(a5)
  a247b2:	c795                	beqz	a5,a247de <uapi_sfc_reg_erase_chip+0x36>
  a247b4:	004005b7          	lui	a1,0x400
  a247b8:	4501                	li	a0,0
  a247ba:	a51ff0ef          	jal	ra,a2420a <sfc_port_write_lock>
  a247be:	00a0 6958 079f      	l.li	a5,0xa06958
  a247c4:	4b9c                	lw	a5,16(a5)
  a247c6:	84aa                	mv	s1,a0
  a247c8:	4605                	li	a2,1
  a247ca:	438c                	lw	a1,0(a5)
  a247cc:	4501                	li	a0,0
  a247ce:	e94ff0ef          	jal	ra,a23e62 <hal_sfc_reg_erase>
  a247d2:	842a                	mv	s0,a0
  a247d4:	8526                	mv	a0,s1
  a247d6:	a8dff0ef          	jal	ra,a24262 <sfc_port_write_unlock>
  a247da:	8522                	mv	a0,s0
  a247dc:	8034                	popret	{ra,s0-s1},16
  a247de:	8000 1340 041f      	l.li	s0,0x80001340
  a247e4:	bfdd                	j	a247da <uapi_sfc_reg_erase_chip+0x32>

00a247e6 <efuse_read_item.part.1>:
  a247e6:	8188                	push	{ra,s0-s6},-48
  a247e8:	00a2 70b0 079f      	l.li	a5,0xa270b0
  a247ee:	06a7955b          	muliadd	a0,a5,a0,6
  a247f2:	2126                	lhu	s1,2(a0)
  a247f4:	00748a13          	addi	s4,s1,7
  a247f8:	003a5a13          	srli	s4,s4,0x3
  a247fc:	07466f63          	bltu	a2,s4,a2487a <efuse_read_item.part.1+0x94>
  a24800:	00055903          	lhu	s2,0(a0)
  a24804:	86b2                	mv	a3,a2
  a24806:	89ae                	mv	s3,a1
  a24808:	4601                	li	a2,0
  a2480a:	85b6                	mv	a1,a3
  a2480c:	854e                	mv	a0,s3
  a2480e:	597000ef          	jal	ra,a255a4 <memset_s>
  a24812:	009967b3          	or	a5,s2,s1
  a24816:	8b9d                	andi	a5,a5,7
  a24818:	844a                	mv	s0,s2
  a2481a:	cb91                	beqz	a5,a2482e <efuse_read_item.part.1+0x48>
  a2481c:	6a41                	lui	s4,0x10
  a2481e:	94ca                	add	s1,s1,s2
  a24820:	4aa1                	li	s5,8
  a24822:	1a7d                	addi	s4,s4,-1 # ffff <ccause+0xf03d>
  a24824:	4b05                	li	s6,1
  a24826:	00944b63          	blt	s0,s1,a2483c <efuse_read_item.part.1+0x56>
  a2482a:	4501                	li	a0,0
  a2482c:	a039                	j	a2483a <efuse_read_item.part.1+0x54>
  a2482e:	8652                	mv	a2,s4
  a24830:	00395593          	srli	a1,s2,0x3
  a24834:	854e                	mv	a0,s3
  a24836:	a86fe0ef          	jal	ra,a22abc <uapi_efuse_read_buffer>
  a2483a:	8184                	popret	{ra,s0-s6},48
  a2483c:	00747613          	andi	a2,s0,7
  a24840:	00345593          	srli	a1,s0,0x3
  a24844:	00f10513          	addi	a0,sp,15
  a24848:	a1efe0ef          	jal	ra,a22a66 <uapi_efuse_read_bit>
  a2484c:	f57d                	bnez	a0,a2483a <efuse_read_item.part.1+0x54>
  a2484e:	00f14783          	lbu	a5,15(sp)
  a24852:	c38d                	beqz	a5,a24874 <efuse_read_item.part.1+0x8e>
  a24854:	412407b3          	sub	a5,s0,s2
  a24858:	0357c733          	div	a4,a5,s5
  a2485c:	0357e7b3          	rem	a5,a5,s5
  a24860:	01477733          	and	a4,a4,s4
  a24864:	974e                	add	a4,a4,s3
  a24866:	2314                	lbu	a3,0(a4)
  a24868:	0147f7b3          	and	a5,a5,s4
  a2486c:	00fb17b3          	sll	a5,s6,a5
  a24870:	8fd5                	or	a5,a5,a3
  a24872:	a31c                	sb	a5,0(a4)
  a24874:	0405                	addi	s0,s0,1
  a24876:	9c21                	uxth	s0
  a24878:	b77d                	j	a24826 <efuse_read_item.part.1+0x40>
  a2487a:	557d                	li	a0,-1
  a2487c:	bf7d                	j	a2483a <efuse_read_item.part.1+0x54>

00a2487e <efuse_port_register_hal_funcs>:
  a2487e:	8018                	push	{ra},-16
  a24880:	d02fe0ef          	jal	ra,a22d82 <hal_efuse_funcs_get>
  a24884:	8010                	pop	{ra},16
  a24886:	b0afe06f          	j	a22b90 <hal_efuse_register_funcs>

00a2488a <hal_efuse_get_region>:
  a2488a:	8121                	srli	a0,a0,0x8
  a2488c:	9d01                	uxtb	a0
  a2488e:	8082                	ret

00a24890 <hal_efuse_get_byte_offset>:
  a24890:	9d01                	uxtb	a0
  a24892:	8082                	ret

00a24894 <efuse_read_item>:
  a24894:	c589                	beqz	a1,a2489e <efuse_read_item+0xa>
  a24896:	1305723b          	bgeui	a0,19,a2489e <efuse_read_item+0xa>
  a2489a:	f4dff06f          	j	a247e6 <efuse_read_item.part.1>
  a2489e:	557d                	li	a0,-1
  a248a0:	8082                	ret

00a248a2 <set_efuse_period>:
  a248a2:	8018                	push	{ra},-16
  a248a4:	2895                	jal	ra,a24918 <get_tcxo_freq>
  a248a6:	010513bb          	bnei	a0,1,a248b4 <set_efuse_period+0x12>
  a248aa:	02900513          	li	a0,41
  a248ae:	8010                	pop	{ra},16
  a248b0:	cc8fe06f          	j	a22d78 <hal_efuse_set_clock_period>
  a248b4:	4565                	li	a0,25
  a248b6:	bfe5                	j	a248ae <set_efuse_period+0xc>

00a248b8 <malloc_port>:
  a248b8:	f90fd06f          	j	a22048 <malloc>

00a248bc <malloc_port_init>:
  a248bc:	8118                	push	{ra},-32
  a248be:	00a2 1f6e 079f      	l.li	a5,0xa21f6e
  a248c4:	c23e                	sw	a5,4(sp)
  a248c6:	00a2 207e 079f      	l.li	a5,0xa2207e
  a248cc:	c63e                	sw	a5,12(sp)
  a248ce:	0048                	addi	a0,sp,4
  a248d0:	00a2 48b8 079f      	l.li	a5,0xa248b8
  a248d6:	c43e                	sw	a5,8(sp)
  a248d8:	e42fd0ef          	jal	ra,a21f1a <malloc_register_funcs>
  a248dc:	00a07537          	lui	a0,0xa07
  a248e0:	0001 9560 079f      	l.li	a5,0x19560
  a248e6:	aa050593          	addi	a1,a0,-1376 # a06aa0 <__boot_uart_end__>
  a248ea:	95be                	add	a1,a1,a5
  a248ec:	aa050513          	addi	a0,a0,-1376
  a248f0:	e7efd0ef          	jal	ra,a21f6e <malloc_init>
  a248f4:	8114                	popret	{ra},32

00a248f6 <reboot_port_reboot_chip>:
  a248f6:	8018                	push	{ra},-16
  a248f8:	8f8fe0ef          	jal	ra,a229f0 <uapi_watchdog_deinit>
  a248fc:	0000 0bb8 051f      	l.li	a0,0xbb8
  a24902:	ad7fd0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a24906:	40002737          	lui	a4,0x40002
  a2490a:	11072783          	lw	a5,272(a4) # 40002110 <__data_load__+0x3f5da6dc>
  a2490e:	0047e793          	ori	a5,a5,4
  a24912:	10f72823          	sw	a5,272(a4)
  a24916:	8014                	popret	{ra},16

00a24918 <get_tcxo_freq>:
  a24918:	400007b7          	lui	a5,0x40000
  a2491c:	4bc8                	lw	a0,20(a5)
  a2491e:	8905                	andi	a0,a0,1
  a24920:	8082                	ret

00a24922 <boot_clock_adapt>:
  a24922:	8028                	push	{ra,s0},-16
  a24924:	ff5ff0ef          	jal	ra,a24918 <get_tcxo_freq>
  a24928:	010518bb          	bnei	a0,1,a2494a <boot_clock_adapt+0x28>
  a2492c:	016e3437          	lui	s0,0x16e3
  a24930:	60040593          	addi	a1,s0,1536 # 16e3600 <__data_load__+0xcbbbcc>
  a24934:	4501                	li	a0,0
  a24936:	ea0ff0ef          	jal	ra,a23fd6 <uart_port_set_clock_value>
  a2493a:	4561                	li	a0,24
  a2493c:	f28ff0ef          	jal	ra,a24064 <tcxo_porting_ticks_per_usec_set>
  a24940:	60040513          	addi	a0,s0,1536
  a24944:	8020                	pop	{ra,s0},16
  a24946:	f3aff06f          	j	a24080 <watchdog_port_set_clock>
  a2494a:	02626437          	lui	s0,0x2626
  a2494e:	a0040593          	addi	a1,s0,-1536 # 2625a00 <__data_load__+0x1bfdfcc>
  a24952:	4501                	li	a0,0
  a24954:	e82ff0ef          	jal	ra,a23fd6 <uart_port_set_clock_value>
  a24958:	02800513          	li	a0,40
  a2495c:	f08ff0ef          	jal	ra,a24064 <tcxo_porting_ticks_per_usec_set>
  a24960:	a0040513          	addi	a0,s0,-1536
  a24964:	b7c5                	j	a24944 <boot_clock_adapt+0x22>

00a24966 <switch_flash_clock_to_pll>:
  a24966:	8028                	push	{ra,s0},-16
  a24968:	40003437          	lui	s0,0x40003
  a2496c:	4785                	li	a5,1
  a2496e:	4af42223          	sw	a5,1188(s0) # 400034a4 <__data_load__+0x3f5dba70>
  a24972:	4505                	li	a0,1
  a24974:	a65fd0ef          	jal	ra,a223d8 <uapi_tcxo_delay_us>
  a24978:	478d                	li	a5,3
  a2497a:	4af42223          	sw	a5,1188(s0)
  a2497e:	44001737          	lui	a4,0x44001
  a24982:	13472783          	lw	a5,308(a4) # 44001134 <__data_load__+0x435d9700>
  a24986:	000406b7          	lui	a3,0x40
  a2498a:	8fd5                	or	a5,a5,a3
  a2498c:	12f72a23          	sw	a5,308(a4)
  a24990:	8024                	popret	{ra,s0},16

00a24992 <config_sfc_ctrl_ds>:
  a24992:	4400e7b7          	lui	a5,0x4400e
  a24996:	8687a703          	lw	a4,-1944(a5) # 4400d868 <__data_load__+0x435e5e34>
  a2499a:	f8f77713          	andi	a4,a4,-113
  a2499e:	03076713          	ori	a4,a4,48
  a249a2:	86e7a423          	sw	a4,-1944(a5)
  a249a6:	86c7a703          	lw	a4,-1940(a5)
  a249aa:	f8f77713          	andi	a4,a4,-113
  a249ae:	02076713          	ori	a4,a4,32
  a249b2:	86e7a623          	sw	a4,-1940(a5)
  a249b6:	8707a703          	lw	a4,-1936(a5)
  a249ba:	f8f77713          	andi	a4,a4,-113
  a249be:	02076713          	ori	a4,a4,32
  a249c2:	86e7a823          	sw	a4,-1936(a5)
  a249c6:	8747a703          	lw	a4,-1932(a5)
  a249ca:	f8f77713          	andi	a4,a4,-113
  a249ce:	02076713          	ori	a4,a4,32
  a249d2:	86e7aa23          	sw	a4,-1932(a5)
  a249d6:	8787a703          	lw	a4,-1928(a5)
  a249da:	f8f77713          	andi	a4,a4,-113
  a249de:	02076713          	ori	a4,a4,32
  a249e2:	86e7ac23          	sw	a4,-1928(a5)
  a249e6:	87c7a703          	lw	a4,-1924(a5)
  a249ea:	f8f77713          	andi	a4,a4,-113
  a249ee:	02076713          	ori	a4,a4,32
  a249f2:	86e7ae23          	sw	a4,-1924(a5)
  a249f6:	8082                	ret

00a249f8 <udelay>:
  a249f8:	9e1fd06f          	j	a223d8 <uapi_tcxo_delay_us>

00a249fc <mdelay>:
  a249fc:	98dfd06f          	j	a22388 <uapi_tcxo_delay_ms>

00a24a00 <serial_putc>:
  a24a00:	8118                	push	{ra},-32
  a24a02:	00a0 6973 079f      	l.li	a5,0xa06973
  a24a08:	239c                	lbu	a5,0(a5)
  a24a0a:	00a107a3          	sb	a0,15(sp)
  a24a0e:	eb81                	bnez	a5,a24a1e <serial_putc+0x1e>
  a24a10:	4689                	li	a3,2
  a24a12:	4605                	li	a2,1
  a24a14:	00f10593          	addi	a1,sp,15
  a24a18:	4501                	li	a0,0
  a24a1a:	e2dfd0ef          	jal	ra,a22846 <uapi_uart_write>
  a24a1e:	8114                	popret	{ra},32

00a24a20 <serial_puts>:
  a24a20:	00a0 6973 079f      	l.li	a5,0xa06973
  a24a26:	239c                	lbu	a5,0(a5)
  a24a28:	ef89                	bnez	a5,a24a42 <serial_puts+0x22>
  a24a2a:	8118                	push	{ra},-32
  a24a2c:	c62a                	sw	a0,12(sp)
  a24a2e:	b7efc0ef          	jal	ra,a20dac <strlen>
  a24a32:	45b2                	lw	a1,12(sp)
  a24a34:	862a                	mv	a2,a0
  a24a36:	7d000693          	li	a3,2000
  a24a3a:	4501                	li	a0,0
  a24a3c:	8110                	pop	{ra},32
  a24a3e:	e09fd06f          	j	a22846 <uapi_uart_write>
  a24a42:	8082                	ret

00a24a44 <serial_put_buf>:
  a24a44:	00a0 6973 079f      	l.li	a5,0xa06973
  a24a4a:	239c                	lbu	a5,0(a5)
  a24a4c:	862e                	mv	a2,a1
  a24a4e:	e799                	bnez	a5,a24a5c <serial_put_buf+0x18>
  a24a50:	85aa                	mv	a1,a0
  a24a52:	7d000693          	li	a3,2000
  a24a56:	4501                	li	a0,0
  a24a58:	deffd06f          	j	a22846 <uapi_uart_write>
  a24a5c:	8082                	ret

00a24a5e <serial_getc>:
  a24a5e:	8118                	push	{ra},-32
  a24a60:	4689                	li	a3,2
  a24a62:	4605                	li	a2,1
  a24a64:	00f10593          	addi	a1,sp,15
  a24a68:	4501                	li	a0,0
  a24a6a:	000107a3          	sb	zero,15(sp)
  a24a6e:	e31fd0ef          	jal	ra,a2289e <uapi_uart_read>
  a24a72:	00f14503          	lbu	a0,15(sp)
  a24a76:	8114                	popret	{ra},32

00a24a78 <serial_gets>:
  a24a78:	c11d                	beqz	a0,a24a9e <serial_gets+0x26>
  a24a7a:	87aa                	mv	a5,a0
  a24a7c:	557d                	li	a0,-1
  a24a7e:	c195                	beqz	a1,a24aa2 <serial_gets+0x2a>
  a24a80:	8028                	push	{ra,s0},-16
  a24a82:	842e                	mv	s0,a1
  a24a84:	7d000693          	li	a3,2000
  a24a88:	85be                	mv	a1,a5
  a24a8a:	8622                	mv	a2,s0
  a24a8c:	4501                	li	a0,0
  a24a8e:	e11fd0ef          	jal	ra,a2289e <uapi_uart_read>
  a24a92:	8d01                	sub	a0,a0,s0
  a24a94:	00a03533          	snez	a0,a0
  a24a98:	40a00533          	neg	a0,a0
  a24a9c:	8024                	popret	{ra,s0},16
  a24a9e:	557d                	li	a0,-1
  a24aa0:	8082                	ret
  a24aa2:	8082                	ret

00a24aa4 <serial_puthex>:
  a24aa4:	00a0 6973 079f      	l.li	a5,0xa06973
  a24aaa:	239c                	lbu	a5,0(a5)
  a24aac:	efa9                	bnez	a5,a24b06 <serial_puthex+0x62>
  a24aae:	8098                	push	{ra,s0-s7},-48
  a24ab0:	84aa                	mv	s1,a0
  a24ab2:	00a2 712c 051f      	l.li	a0,0xa2712c
  a24ab8:	8a2e                	mv	s4,a1
  a24aba:	4401                	li	s0,0
  a24abc:	f65ff0ef          	jal	ra,a24a20 <serial_puts>
  a24ac0:	4901                	li	s2,0
  a24ac2:	4aa5                	li	s5,9
  a24ac4:	4b1d                	li	s6,7
  a24ac6:	03000b93          	li	s7,48
  a24aca:	49a1                	li	s3,8
  a24acc:	01c4d713          	srli	a4,s1,0x1c
  a24ad0:	0ff77793          	andi	a5,a4,255
  a24ad4:	03078513          	addi	a0,a5,48
  a24ad8:	00eaf463          	bgeu	s5,a4,a24ae0 <serial_puthex+0x3c>
  a24adc:	03778513          	addi	a0,a5,55
  a24ae0:	0492                	slli	s1,s1,0x4
  a24ae2:	000a0563          	beqz	s4,a24aec <serial_puthex+0x48>
  a24ae6:	f1bff0ef          	jal	ra,a24a00 <serial_putc>
  a24aea:	a811                	j	a24afe <serial_puthex+0x5a>
  a24aec:	fe091de3          	bnez	s2,a24ae6 <serial_puthex+0x42>
  a24af0:	ff640be3          	beq	s0,s6,a24ae6 <serial_puthex+0x42>
  a24af4:	01750563          	beq	a0,s7,a24afe <serial_puthex+0x5a>
  a24af8:	f09ff0ef          	jal	ra,a24a00 <serial_putc>
  a24afc:	4905                	li	s2,1
  a24afe:	0405                	addi	s0,s0,1
  a24b00:	fd3416e3          	bne	s0,s3,a24acc <serial_puthex+0x28>
  a24b04:	8094                	popret	{ra,s0-s7},48
  a24b06:	8082                	ret

00a24b08 <serial_getc_timeout>:
  a24b08:	8048                	push	{ra,s0-s2},-16
  a24b0a:	84aa                	mv	s1,a0
  a24b0c:	892e                	mv	s2,a1
  a24b0e:	4401                	li	s0,0
  a24b10:	00941463          	bne	s0,s1,a24b18 <serial_getc_timeout+0x10>
  a24b14:	557d                	li	a0,-1
  a24b16:	a811                	j	a24b2a <serial_getc_timeout+0x22>
  a24b18:	4501                	li	a0,0
  a24b1a:	dddfd0ef          	jal	ra,a228f6 <uapi_uart_rx_fifo_is_empty>
  a24b1e:	e519                	bnez	a0,a24b2c <serial_getc_timeout+0x24>
  a24b20:	f3fff0ef          	jal	ra,a24a5e <serial_getc>
  a24b24:	00a90023          	sb	a0,0(s2)
  a24b28:	4501                	li	a0,0
  a24b2a:	8044                	popret	{ra,s0-s2},16
  a24b2c:	0405                	addi	s0,s0,1
  a24b2e:	b7cd                	j	a24b10 <serial_getc_timeout+0x8>

00a24b30 <boot_put_errno>:
  a24b30:	8028                	push	{ra,s0},-16
  a24b32:	842a                	mv	s0,a0
  a24b34:	00a2 7124 051f      	l.li	a0,0xa27124
  a24b3a:	ee7ff0ef          	jal	ra,a24a20 <serial_puts>
  a24b3e:	4581                	li	a1,0
  a24b40:	8522                	mv	a0,s0
  a24b42:	f63ff0ef          	jal	ra,a24aa4 <serial_puthex>
  a24b46:	00a2 6e58 051f      	l.li	a0,0xa26e58
  a24b4c:	ed5ff0ef          	jal	ra,a24a20 <serial_puts>
  a24b50:	06400513          	li	a0,100
  a24b54:	8020                	pop	{ra,s0},16
  a24b56:	ea7ff06f          	j	a249fc <mdelay>

00a24b5a <boot_msg0>:
  a24b5a:	8018                	push	{ra},-16
  a24b5c:	ec5ff0ef          	jal	ra,a24a20 <serial_puts>
  a24b60:	00a2 7438 051f      	l.li	a0,0xa27438
  a24b66:	8010                	pop	{ra},16
  a24b68:	eb9ff06f          	j	a24a20 <serial_puts>

00a24b6c <boot_msg1>:
  a24b6c:	8028                	push	{ra,s0},-16
  a24b6e:	842e                	mv	s0,a1
  a24b70:	eb1ff0ef          	jal	ra,a24a20 <serial_puts>
  a24b74:	8522                	mv	a0,s0
  a24b76:	4581                	li	a1,0
  a24b78:	f2dff0ef          	jal	ra,a24aa4 <serial_puthex>
  a24b7c:	00a2 7438 051f      	l.li	a0,0xa27438
  a24b82:	8020                	pop	{ra,s0},16
  a24b84:	e9dff06f          	j	a24a20 <serial_puts>

00a24b88 <boot_msg2>:
  a24b88:	8128                	push	{ra,s0},-32
  a24b8a:	842e                	mv	s0,a1
  a24b8c:	c632                	sw	a2,12(sp)
  a24b8e:	e93ff0ef          	jal	ra,a24a20 <serial_puts>
  a24b92:	4581                	li	a1,0
  a24b94:	8522                	mv	a0,s0
  a24b96:	f0fff0ef          	jal	ra,a24aa4 <serial_puthex>
  a24b9a:	00a2 7180 051f      	l.li	a0,0xa27180
  a24ba0:	e81ff0ef          	jal	ra,a24a20 <serial_puts>
  a24ba4:	4632                	lw	a2,12(sp)
  a24ba6:	4581                	li	a1,0
  a24ba8:	8532                	mv	a0,a2
  a24baa:	efbff0ef          	jal	ra,a24aa4 <serial_puthex>
  a24bae:	00a2 7438 051f      	l.li	a0,0xa27438
  a24bb4:	8120                	pop	{ra,s0},32
  a24bb6:	e6bff06f          	j	a24a20 <serial_puts>

00a24bba <hiburn_uart_init>:
  a24bba:	8228                	push	{ra,s0},-48
  a24bbc:	00a0 2494 079f      	l.li	a5,0xa02494
  a24bc2:	00078023          	sb	zero,0(a5)
  a24bc6:	02900793          	li	a5,41
  a24bca:	00f10623          	sb	a5,12(sp)
  a24bce:	07300793          	li	a5,115
  a24bd2:	00f107a3          	sb	a5,15(sp)
  a24bd6:	00f10723          	sb	a5,14(sp)
  a24bda:	411c                	lw	a5,0(a0)
  a24bdc:	02a00713          	li	a4,42
  a24be0:	00e106a3          	sb	a4,13(sp)
  a24be4:	c83e                	sw	a5,16(sp)
  a24be6:	215c                	lbu	a5,4(a0)
  a24be8:	2178                	lbu	a4,6(a0)
  a24bea:	00010423          	sb	zero,8(sp)
  a24bee:	17ed                	addi	a5,a5,-5
  a24bf0:	00f10a23          	sb	a5,20(sp)
  a24bf4:	fff70793          	addi	a5,a4,-1
  a24bf8:	9f81                	uxtb	a5
  a24bfa:	0207fdbb          	bgeui	a5,2,a24c30 <hiburn_uart_init+0x76>
  a24bfe:	00e10b23          	sb	a4,22(sp)
  a24c02:	315c                	lbu	a5,5(a0)
  a24c04:	4405                	li	s0,1
  a24c06:	0838                	addi	a4,sp,24
  a24c08:	17fd                	addi	a5,a5,-1
  a24c0a:	00f10aa3          	sb	a5,21(sp)
  a24c0e:	4681                	li	a3,0
  a24c10:	003c                	addi	a5,sp,8
  a24c12:	0810                	addi	a2,sp,16
  a24c14:	006c                	addi	a1,sp,12
  a24c16:	4501                	li	a0,0
  a24c18:	cc3e                	sw	a5,24(sp)
  a24c1a:	ce22                	sw	s0,28(sp)
  a24c1c:	afdfd0ef          	jal	ra,a22718 <uapi_uart_init>
  a24c20:	4501                	li	a0,0
  a24c22:	bdaff0ef          	jal	ra,a23ffc <uart_port_unregister_irq>
  a24c26:	00a0 6972 079f      	l.li	a5,0xa06972
  a24c2c:	a380                	sb	s0,0(a5)
  a24c2e:	8224                	popret	{ra,s0},48
  a24c30:	00010b23          	sb	zero,22(sp)
  a24c34:	b7f9                	j	a24c02 <hiburn_uart_init+0x48>

00a24c36 <hiburn_uart_deinit>:
  a24c36:	8018                	push	{ra},-16
  a24c38:	00a0 2494 079f      	l.li	a5,0xa02494
  a24c3e:	2388                	lbu	a0,0(a5)
  a24c40:	ba7fd0ef          	jal	ra,a227e6 <uapi_uart_deinit>
  a24c44:	00a0 6972 079f      	l.li	a5,0xa06972
  a24c4a:	00078023          	sb	zero,0(a5)
  a24c4e:	8014                	popret	{ra},16

00a24c50 <boot_wdt_kick>:
  a24c50:	ddbfd06f          	j	a22a2a <uapi_watchdog_kick>

00a24c54 <set_reset_count>:
  a24c54:	40000737          	lui	a4,0x40000
  a24c58:	471c                	lw	a5,8(a4)
  a24c5a:	893d                	andi	a0,a0,15
  a24c5c:	f0f7f793          	andi	a5,a5,-241
  a24c60:	08a7a79b          	orshf	a5,a5,a0,sll,4
  a24c64:	c71c                	sw	a5,8(a4)
  a24c66:	8082                	ret

00a24c68 <update_reset_count>:
  a24c68:	8038                	push	{ra,s0-s1},-16
  a24c6a:	400007b7          	lui	a5,0x40000
  a24c6e:	4780                	lw	s0,8(a5)
  a24c70:	00a2 7130 051f      	l.li	a0,0xa27130
  a24c76:	8011                	srli	s0,s0,0x4
  a24c78:	883d                	andi	s0,s0,15
  a24c7a:	00140493          	addi	s1,s0,1
  a24c7e:	85a6                	mv	a1,s1
  a24c80:	eedff0ef          	jal	ra,a24b6c <boot_msg1>
  a24c84:	06400513          	li	a0,100
  a24c88:	f00fd0ef          	jal	ra,a22388 <uapi_tcxo_delay_ms>
  a24c8c:	0f04033b          	beqi	s0,15,a24c98 <update_reset_count+0x30>
  a24c90:	8526                	mv	a0,s1
  a24c92:	8030                	pop	{ra,s0-s1},16
  a24c94:	fc1ff06f          	j	a24c54 <set_reset_count>
  a24c98:	d23fd0ef          	jal	ra,a229ba <uapi_watchdog_disable>
  a24c9c:	10500073          	wfi
  a24ca0:	a001                	j	a24ca0 <update_reset_count+0x38>

00a24ca2 <check_chip_type>:
  a24ca2:	8228                	push	{ra,s0},-48
  a24ca4:	00a2 0080 079f      	l.li	a5,0xa20080
  a24caa:	53c0                	lw	s0,36(a5)
  a24cac:	c451                	beqz	s0,a24d38 <check_chip_type+0x96>
  a24cae:	00b10593          	addi	a1,sp,11
  a24cb2:	4605                	li	a2,1
  a24cb4:	4521                	li	a0,8
  a24cb6:	000105a3          	sb	zero,11(sp)
  a24cba:	bdbff0ef          	jal	ra,a24894 <efuse_read_item>
  a24cbe:	85aa                	mv	a1,a0
  a24cc0:	c901                	beqz	a0,a24cd0 <check_chip_type+0x2e>
  a24cc2:	00a2 7144 051f      	l.li	a0,0xa27144
  a24cc8:	ea5ff0ef          	jal	ra,a24b6c <boot_msg1>
  a24ccc:	557d                	li	a0,-1
  a24cce:	8224                	popret	{ra,s0},48
  a24cd0:	00b14783          	lbu	a5,11(sp)
  a24cd4:	0037f713          	andi	a4,a5,3
  a24cd8:	c319                	beqz	a4,a24cde <check_chip_type+0x3c>
  a24cda:	8bb1                	andi	a5,a5,12
  a24cdc:	c3a9                	beqz	a5,a24d1e <check_chip_type+0x7c>
  a24cde:	006c                	addi	a1,sp,12
  a24ce0:	4651                	li	a2,20
  a24ce2:	4505                	li	a0,1
  a24ce4:	c602                	sw	zero,12(sp)
  a24ce6:	c802                	sw	zero,16(sp)
  a24ce8:	ca02                	sw	zero,20(sp)
  a24cea:	cc02                	sw	zero,24(sp)
  a24cec:	ce02                	sw	zero,28(sp)
  a24cee:	ba7ff0ef          	jal	ra,a24894 <efuse_read_item>
  a24cf2:	85aa                	mv	a1,a0
  a24cf4:	c509                	beqz	a0,a24cfe <check_chip_type+0x5c>
  a24cf6:	00a2 7164 051f      	l.li	a0,0xa27164
  a24cfc:	b7f1                	j	a24cc8 <check_chip_type+0x26>
  a24cfe:	01514703          	lbu	a4,21(sp)
  a24d02:	01414783          	lbu	a5,20(sp)
  a24d06:	06300593          	li	a1,99
  a24d0a:	10e7a79b          	orshf	a5,a5,a4,sll,8
  a24d0e:	6721                	lui	a4,0x8
  a24d10:	177d                	addi	a4,a4,-1 # 7fff <ccause+0x703d>
  a24d12:	8ff9                	and	a5,a5,a4
  a24d14:	0000 3058 071f      	l.li	a4,0x3058
  a24d1a:	00e79463          	bne	a5,a4,a24d22 <check_chip_type+0x80>
  a24d1e:	63e00593          	li	a1,1598
  a24d22:	00b40b63          	beq	s0,a1,a24d38 <check_chip_type+0x96>
  a24d26:	8622                	mv	a2,s0
  a24d28:	00a2 7184 051f      	l.li	a0,0xa27184
  a24d2e:	e5bff0ef          	jal	ra,a24b88 <boot_msg2>
  a24d32:	c89fd0ef          	jal	ra,a229ba <uapi_watchdog_disable>
  a24d36:	a001                	j	a24d36 <check_chip_type+0x94>
  a24d38:	4501                	li	a0,0
  a24d3a:	bf51                	j	a24cce <check_chip_type+0x2c>

00a24d3c <boot_malloc_init>:
  a24d3c:	b81ff06f          	j	a248bc <malloc_port_init>

00a24d40 <boot_malloc>:
  a24d40:	b08fd06f          	j	a22048 <malloc>

00a24d44 <interrupt0_handler>:
  a24d44:	8028                	push	{ra,s0},-16
  a24d46:	040007b7          	lui	a5,0x4000
  a24d4a:	3047b7f3          	csrrc	a5,mie,a5
  a24d4e:	00a07437          	lui	s0,0xa07
  a24d52:	97440713          	addi	a4,s0,-1676 # a06974 <g_interrupt_running>
  a24d56:	431c                	lw	a5,0(a4)
  a24d58:	97440413          	addi	s0,s0,-1676
  a24d5c:	0785                	addi	a5,a5,1 # 4000001 <__data_load__+0x35d85cd>
  a24d5e:	c31c                	sw	a5,0(a4)
  a24d60:	22c9                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24d62:	5538                	lw	a4,104(a0)
  a24d64:	00a2 5334 079f      	l.li	a5,0xa25334
  a24d6a:	00f70563          	beq	a4,a5,a24d74 <interrupt0_handler+0x30>
  a24d6e:	2a55                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24d70:	553c                	lw	a5,104(a0)
  a24d72:	9782                	jalr	a5
  a24d74:	040007b7          	lui	a5,0x4000
  a24d78:	3047a7f3          	csrrs	a5,mie,a5
  a24d7c:	401c                	lw	a5,0(s0)
  a24d7e:	17fd                	addi	a5,a5,-1 # 3ffffff <__data_load__+0x35d85cb>
  a24d80:	c01c                	sw	a5,0(s0)
  a24d82:	8024                	popret	{ra,s0},16

00a24d84 <interrupt1_handler>:
  a24d84:	8028                	push	{ra,s0},-16
  a24d86:	080007b7          	lui	a5,0x8000
  a24d8a:	3047b7f3          	csrrc	a5,mie,a5
  a24d8e:	00a07437          	lui	s0,0xa07
  a24d92:	97440713          	addi	a4,s0,-1676 # a06974 <g_interrupt_running>
  a24d96:	431c                	lw	a5,0(a4)
  a24d98:	97440413          	addi	s0,s0,-1676
  a24d9c:	0785                	addi	a5,a5,1 # 8000001 <__data_load__+0x75d85cd>
  a24d9e:	c31c                	sw	a5,0(a4)
  a24da0:	2249                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24da2:	5578                	lw	a4,108(a0)
  a24da4:	00a2 5334 079f      	l.li	a5,0xa25334
  a24daa:	00f70563          	beq	a4,a5,a24db4 <interrupt1_handler+0x30>
  a24dae:	2a95                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24db0:	557c                	lw	a5,108(a0)
  a24db2:	9782                	jalr	a5
  a24db4:	080007b7          	lui	a5,0x8000
  a24db8:	3047a7f3          	csrrs	a5,mie,a5
  a24dbc:	401c                	lw	a5,0(s0)
  a24dbe:	17fd                	addi	a5,a5,-1 # 7ffffff <__data_load__+0x75d85cb>
  a24dc0:	c01c                	sw	a5,0(s0)
  a24dc2:	8024                	popret	{ra,s0},16

00a24dc4 <interrupt2_handler>:
  a24dc4:	8028                	push	{ra,s0},-16
  a24dc6:	100007b7          	lui	a5,0x10000
  a24dca:	3047b7f3          	csrrc	a5,mie,a5
  a24dce:	00a07437          	lui	s0,0xa07
  a24dd2:	97440713          	addi	a4,s0,-1676 # a06974 <g_interrupt_running>
  a24dd6:	431c                	lw	a5,0(a4)
  a24dd8:	97440413          	addi	s0,s0,-1676
  a24ddc:	0785                	addi	a5,a5,1 # 10000001 <__data_load__+0xf5d85cd>
  a24dde:	c31c                	sw	a5,0(a4)
  a24de0:	2289                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24de2:	5938                	lw	a4,112(a0)
  a24de4:	00a2 5334 079f      	l.li	a5,0xa25334
  a24dea:	00f70563          	beq	a4,a5,a24df4 <interrupt2_handler+0x30>
  a24dee:	2a15                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24df0:	593c                	lw	a5,112(a0)
  a24df2:	9782                	jalr	a5
  a24df4:	100007b7          	lui	a5,0x10000
  a24df8:	3047a7f3          	csrrs	a5,mie,a5
  a24dfc:	401c                	lw	a5,0(s0)
  a24dfe:	17fd                	addi	a5,a5,-1 # fffffff <__data_load__+0xf5d85cb>
  a24e00:	c01c                	sw	a5,0(s0)
  a24e02:	8024                	popret	{ra,s0},16

00a24e04 <interrupt3_handler>:
  a24e04:	8028                	push	{ra,s0},-16
  a24e06:	200007b7          	lui	a5,0x20000
  a24e0a:	3047b7f3          	csrrc	a5,mie,a5
  a24e0e:	00a07437          	lui	s0,0xa07
  a24e12:	97440713          	addi	a4,s0,-1676 # a06974 <g_interrupt_running>
  a24e16:	431c                	lw	a5,0(a4)
  a24e18:	97440413          	addi	s0,s0,-1676
  a24e1c:	0785                	addi	a5,a5,1 # 20000001 <__data_load__+0x1f5d85cd>
  a24e1e:	c31c                	sw	a5,0(a4)
  a24e20:	2209                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24e22:	5978                	lw	a4,116(a0)
  a24e24:	00a2 5334 079f      	l.li	a5,0xa25334
  a24e2a:	00f70563          	beq	a4,a5,a24e34 <interrupt3_handler+0x30>
  a24e2e:	28d5                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24e30:	597c                	lw	a5,116(a0)
  a24e32:	9782                	jalr	a5
  a24e34:	200007b7          	lui	a5,0x20000
  a24e38:	3047a7f3          	csrrs	a5,mie,a5
  a24e3c:	401c                	lw	a5,0(s0)
  a24e3e:	17fd                	addi	a5,a5,-1 # 1fffffff <__data_load__+0x1f5d85cb>
  a24e40:	c01c                	sw	a5,0(s0)
  a24e42:	8024                	popret	{ra,s0},16

00a24e44 <interrupt4_handler>:
  a24e44:	8028                	push	{ra,s0},-16
  a24e46:	400007b7          	lui	a5,0x40000
  a24e4a:	3047b7f3          	csrrc	a5,mie,a5
  a24e4e:	00a07437          	lui	s0,0xa07
  a24e52:	97440713          	addi	a4,s0,-1676 # a06974 <g_interrupt_running>
  a24e56:	431c                	lw	a5,0(a4)
  a24e58:	97440413          	addi	s0,s0,-1676
  a24e5c:	0785                	addi	a5,a5,1 # 40000001 <__data_load__+0x3f5d85cd>
  a24e5e:	c31c                	sw	a5,0(a4)
  a24e60:	20c9                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24e62:	5d38                	lw	a4,120(a0)
  a24e64:	00a2 5334 079f      	l.li	a5,0xa25334
  a24e6a:	00f70563          	beq	a4,a5,a24e74 <interrupt4_handler+0x30>
  a24e6e:	2855                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24e70:	5d3c                	lw	a5,120(a0)
  a24e72:	9782                	jalr	a5
  a24e74:	400007b7          	lui	a5,0x40000
  a24e78:	3047a7f3          	csrrs	a5,mie,a5
  a24e7c:	401c                	lw	a5,0(s0)
  a24e7e:	17fd                	addi	a5,a5,-1 # 3fffffff <__data_load__+0x3f5d85cb>
  a24e80:	c01c                	sw	a5,0(s0)
  a24e82:	8024                	popret	{ra,s0},16

00a24e84 <interrupt5_handler>:
  a24e84:	8028                	push	{ra,s0},-16
  a24e86:	800007b7          	lui	a5,0x80000
  a24e8a:	3047b7f3          	csrrc	a5,mie,a5
  a24e8e:	00a07437          	lui	s0,0xa07
  a24e92:	97440713          	addi	a4,s0,-1676 # a06974 <g_interrupt_running>
  a24e96:	431c                	lw	a5,0(a4)
  a24e98:	97440413          	addi	s0,s0,-1676
  a24e9c:	0785                	addi	a5,a5,1 # 80000001 <__data_load__+0x7f5d85cd>
  a24e9e:	c31c                	sw	a5,0(a4)
  a24ea0:	2049                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24ea2:	5d78                	lw	a4,124(a0)
  a24ea4:	00a2 5334 079f      	l.li	a5,0xa25334
  a24eaa:	00f70563          	beq	a4,a5,a24eb4 <interrupt5_handler+0x30>
  a24eae:	2895                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24eb0:	5d7c                	lw	a5,124(a0)
  a24eb2:	9782                	jalr	a5
  a24eb4:	800007b7          	lui	a5,0x80000
  a24eb8:	3047a7f3          	csrrs	a5,mie,a5
  a24ebc:	401c                	lw	a5,0(s0)
  a24ebe:	17fd                	addi	a5,a5,-1 # 7fffffff <__data_load__+0x7f5d85cb>
  a24ec0:	c01c                	sw	a5,0(s0)
  a24ec2:	8024                	popret	{ra,s0},16

00a24ec4 <local_interrupt_handler>:
  a24ec4:	8038                	push	{ra,s0-s1},-16
  a24ec6:	0f3010ef          	jal	ra,a267b8 <global_interrupt_lock>
  a24eca:	00a074b7          	lui	s1,0xa07
  a24ece:	97448713          	addi	a4,s1,-1676 # a06974 <g_interrupt_running>
  a24ed2:	431c                	lw	a5,0(a4)
  a24ed4:	0785                	addi	a5,a5,1
  a24ed6:	c31c                	sw	a5,0(a4)
  a24ed8:	0f9010ef          	jal	ra,a267d0 <global_interrupt_restore>
  a24edc:	34202473          	csrr	s0,mcause
  a24ee0:	2089                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24ee2:	6785                	lui	a5,0x1
  a24ee4:	17fd                	addi	a5,a5,-1 # fff <ccause+0x3d>
  a24ee6:	8c7d                	and	s0,s0,a5
  a24ee8:	040a                	slli	s0,s0,0x2
  a24eea:	9522                	add	a0,a0,s0
  a24eec:	4118                	lw	a4,0(a0)
  a24eee:	00a2 4f20 079f      	l.li	a5,0xa24f20
  a24ef4:	97448493          	addi	s1,s1,-1676
  a24ef8:	00f70663          	beq	a4,a5,a24f04 <local_interrupt_handler+0x40>
  a24efc:	201d                	jal	ra,a24f22 <isr_get_ramexceptiontable_addr>
  a24efe:	9522                	add	a0,a0,s0
  a24f00:	411c                	lw	a5,0(a0)
  a24f02:	9782                	jalr	a5
  a24f04:	0b5010ef          	jal	ra,a267b8 <global_interrupt_lock>
  a24f08:	409c                	lw	a5,0(s1)
  a24f0a:	17fd                	addi	a5,a5,-1
  a24f0c:	c09c                	sw	a5,0(s1)
  a24f0e:	8030                	pop	{ra,s0-s1},16
  a24f10:	0c10106f          	j	a267d0 <global_interrupt_restore>

00a24f14 <interrupt_number_get>:
  a24f14:	34202573          	csrr	a0,mcause
  a24f18:	6785                	lui	a5,0x1
  a24f1a:	17fd                	addi	a5,a5,-1 # fff <ccause+0x3d>
  a24f1c:	8d7d                	and	a0,a0,a5
  a24f1e:	8082                	ret

00a24f20 <b_sub_monitor_handler>:
  a24f20:	a001                	j	a24f20 <b_sub_monitor_handler>

00a24f22 <isr_get_ramexceptiontable_addr>:
  a24f22:	00a2 04bc 051f      	l.li	a0,0xa204bc
  a24f28:	8082                	ret

00a24f2a <do_hard_fault_handler>:
  a24f2a:	c939                	beqz	a0,a24f80 <do_hard_fault_handler+0x56>
  a24f2c:	8038                	push	{ra,s0-s1},-16
  a24f2e:	4144                	lw	s1,4(a0)
  a24f30:	842a                	mv	s0,a0
  a24f32:	00a2 71ec 051f      	l.li	a0,0xa271ec
  a24f38:	85a6                	mv	a1,s1
  a24f3a:	8c4ff0ef          	jal	ra,a23ffe <print_str>
  a24f3e:	800007b7          	lui	a5,0x80000
  a24f42:	07b1                	addi	a5,a5,12 # 8000000c <__data_load__+0x7f5d85d8>
  a24f44:	02f49b63          	bne	s1,a5,a24f7a <do_hard_fault_handler+0x50>
  a24f48:	00a2 7200 051f      	l.li	a0,0xa27200
  a24f4e:	8b0ff0ef          	jal	ra,a23ffe <print_str>
  a24f52:	6509                	lui	a0,0x2
  a24f54:	0521                	addi	a0,a0,8 # 2008 <ccause+0x1046>
  a24f56:	2119                	jal	ra,a2535c <cpu_utils_set_system_status_by_cause>
  a24f58:	4c5c                	lw	a5,28(s0)
  a24f5a:	8522                	mv	a0,s0
  a24f5c:	07c1                	addi	a5,a5,16
  a24f5e:	cc5c                	sw	a5,28(s0)
  a24f60:	238d                	jal	ra,a254c2 <set_exception_info_riscv>
  a24f62:	00a0 698c 079f      	l.li	a5,0xa0698c
  a24f68:	439c                	lw	a5,0(a5)
  a24f6a:	c781                	beqz	a5,a24f72 <do_hard_fault_handler+0x48>
  a24f6c:	85a2                	mv	a1,s0
  a24f6e:	8526                	mv	a0,s1
  a24f70:	9782                	jalr	a5
  a24f72:	4501                	li	a0,0
  a24f74:	8030                	pop	{ra,s0-s1},16
  a24f76:	a01fd06f          	j	a22976 <uapi_watchdog_enable>
  a24f7a:	6509                	lui	a0,0x2
  a24f7c:	0511                	addi	a0,a0,4 # 2004 <ccause+0x1042>
  a24f7e:	bfe1                	j	a24f56 <do_hard_fault_handler+0x2c>
  a24f80:	8082                	ret

00a24f82 <exc_info_display.part.3>:
  a24f82:	8028                	push	{ra,s0},-16
  a24f84:	842a                	mv	s0,a0
  a24f86:	00a2 745c 051f      	l.li	a0,0xa2745c
  a24f8c:	872ff0ef          	jal	ra,a23ffe <print_str>
  a24f90:	202e                	lhu	a1,2(s0)
  a24f92:	00a2 7494 051f      	l.li	a0,0xa27494
  a24f98:	866ff0ef          	jal	ra,a23ffe <print_str>
  a24f9c:	481c                	lw	a5,16(s0)
  a24f9e:	00a2 74ac 051f      	l.li	a0,0xa274ac
  a24fa4:	4bcc                	lw	a1,20(a5)
  a24fa6:	858ff0ef          	jal	ra,a23ffe <print_str>
  a24faa:	481c                	lw	a5,16(s0)
  a24fac:	00a2 74c4 051f      	l.li	a0,0xa274c4
  a24fb2:	4b8c                	lw	a1,16(a5)
  a24fb4:	84aff0ef          	jal	ra,a23ffe <print_str>
  a24fb8:	481c                	lw	a5,16(s0)
  a24fba:	00a2 74dc 051f      	l.li	a0,0xa274dc
  a24fc0:	478c                	lw	a1,8(a5)
  a24fc2:	83cff0ef          	jal	ra,a23ffe <print_str>
  a24fc6:	481c                	lw	a5,16(s0)
  a24fc8:	00a2 74f4 051f      	l.li	a0,0xa274f4
  a24fce:	43cc                	lw	a1,4(a5)
  a24fd0:	82eff0ef          	jal	ra,a23ffe <print_str>
  a24fd4:	481c                	lw	a5,16(s0)
  a24fd6:	00a2 750c 051f      	l.li	a0,0xa2750c
  a24fdc:	438c                	lw	a1,0(a5)
  a24fde:	820ff0ef          	jal	ra,a23ffe <print_str>
  a24fe2:	481c                	lw	a5,16(s0)
  a24fe4:	00a2 7524 051f      	l.li	a0,0xa27524
  a24fea:	08c7a583          	lw	a1,140(a5)
  a24fee:	810ff0ef          	jal	ra,a23ffe <print_str>
  a24ff2:	481c                	lw	a5,16(s0)
  a24ff4:	00a2 753c 051f      	l.li	a0,0xa2753c
  a24ffa:	4fcc                	lw	a1,28(a5)
  a24ffc:	802ff0ef          	jal	ra,a23ffe <print_str>
  a25000:	481c                	lw	a5,16(s0)
  a25002:	00a2 7554 051f      	l.li	a0,0xa27554
  a25008:	47cc                	lw	a1,12(a5)
  a2500a:	ff5fe0ef          	jal	ra,a23ffe <print_str>
  a2500e:	481c                	lw	a5,16(s0)
  a25010:	00a2 756c 051f      	l.li	a0,0xa2756c
  a25016:	4f8c                	lw	a1,24(a5)
  a25018:	fe7fe0ef          	jal	ra,a23ffe <print_str>
  a2501c:	481c                	lw	a5,16(s0)
  a2501e:	00a2 7584 051f      	l.li	a0,0xa27584
  a25024:	0887a583          	lw	a1,136(a5)
  a25028:	fd7fe0ef          	jal	ra,a23ffe <print_str>
  a2502c:	481c                	lw	a5,16(s0)
  a2502e:	00a2 759c 051f      	l.li	a0,0xa2759c
  a25034:	0847a583          	lw	a1,132(a5)
  a25038:	fc7fe0ef          	jal	ra,a23ffe <print_str>
  a2503c:	481c                	lw	a5,16(s0)
  a2503e:	00a2 75b4 051f      	l.li	a0,0xa275b4
  a25044:	0807a583          	lw	a1,128(a5)
  a25048:	fb7fe0ef          	jal	ra,a23ffe <print_str>
  a2504c:	481c                	lw	a5,16(s0)
  a2504e:	00a2 75cc 051f      	l.li	a0,0xa275cc
  a25054:	47ec                	lw	a1,76(a5)
  a25056:	fa9fe0ef          	jal	ra,a23ffe <print_str>
  a2505a:	481c                	lw	a5,16(s0)
  a2505c:	00a2 75e4 051f      	l.li	a0,0xa275e4
  a25062:	47ac                	lw	a1,72(a5)
  a25064:	f9bfe0ef          	jal	ra,a23ffe <print_str>
  a25068:	481c                	lw	a5,16(s0)
  a2506a:	00a2 75fc 051f      	l.li	a0,0xa275fc
  a25070:	5fec                	lw	a1,124(a5)
  a25072:	f8dfe0ef          	jal	ra,a23ffe <print_str>
  a25076:	481c                	lw	a5,16(s0)
  a25078:	00a2 7614 051f      	l.li	a0,0xa27614
  a2507e:	5fac                	lw	a1,120(a5)
  a25080:	f7ffe0ef          	jal	ra,a23ffe <print_str>
  a25084:	481c                	lw	a5,16(s0)
  a25086:	00a2 762c 051f      	l.li	a0,0xa2762c
  a2508c:	5bec                	lw	a1,116(a5)
  a2508e:	f71fe0ef          	jal	ra,a23ffe <print_str>
  a25092:	481c                	lw	a5,16(s0)
  a25094:	00a2 7644 051f      	l.li	a0,0xa27644
  a2509a:	5bac                	lw	a1,112(a5)
  a2509c:	f63fe0ef          	jal	ra,a23ffe <print_str>
  a250a0:	481c                	lw	a5,16(s0)
  a250a2:	00a2 765c 051f      	l.li	a0,0xa2765c
  a250a8:	57ec                	lw	a1,108(a5)
  a250aa:	f55fe0ef          	jal	ra,a23ffe <print_str>
  a250ae:	481c                	lw	a5,16(s0)
  a250b0:	00a2 7674 051f      	l.li	a0,0xa27674
  a250b6:	57ac                	lw	a1,104(a5)
  a250b8:	f47fe0ef          	jal	ra,a23ffe <print_str>
  a250bc:	481c                	lw	a5,16(s0)
  a250be:	00a2 768c 051f      	l.li	a0,0xa2768c
  a250c4:	53ec                	lw	a1,100(a5)
  a250c6:	f39fe0ef          	jal	ra,a23ffe <print_str>
  a250ca:	481c                	lw	a5,16(s0)
  a250cc:	00a2 76a4 051f      	l.li	a0,0xa276a4
  a250d2:	53ac                	lw	a1,96(a5)
  a250d4:	f2bfe0ef          	jal	ra,a23ffe <print_str>
  a250d8:	481c                	lw	a5,16(s0)
  a250da:	00a2 76bc 051f      	l.li	a0,0xa276bc
  a250e0:	43ec                	lw	a1,68(a5)
  a250e2:	f1dfe0ef          	jal	ra,a23ffe <print_str>
  a250e6:	481c                	lw	a5,16(s0)
  a250e8:	00a2 76d4 051f      	l.li	a0,0xa276d4
  a250ee:	43ac                	lw	a1,64(a5)
  a250f0:	f0ffe0ef          	jal	ra,a23ffe <print_str>
  a250f4:	481c                	lw	a5,16(s0)
  a250f6:	00a2 76ec 051f      	l.li	a0,0xa276ec
  a250fc:	5fcc                	lw	a1,60(a5)
  a250fe:	f01fe0ef          	jal	ra,a23ffe <print_str>
  a25102:	481c                	lw	a5,16(s0)
  a25104:	00a2 7704 051f      	l.li	a0,0xa27704
  a2510a:	5f8c                	lw	a1,56(a5)
  a2510c:	ef3fe0ef          	jal	ra,a23ffe <print_str>
  a25110:	481c                	lw	a5,16(s0)
  a25112:	00a2 771c 051f      	l.li	a0,0xa2771c
  a25118:	5bcc                	lw	a1,52(a5)
  a2511a:	ee5fe0ef          	jal	ra,a23ffe <print_str>
  a2511e:	481c                	lw	a5,16(s0)
  a25120:	00a2 7734 051f      	l.li	a0,0xa27734
  a25126:	5b8c                	lw	a1,48(a5)
  a25128:	ed7fe0ef          	jal	ra,a23ffe <print_str>
  a2512c:	481c                	lw	a5,16(s0)
  a2512e:	00a2 774c 051f      	l.li	a0,0xa2774c
  a25134:	57cc                	lw	a1,44(a5)
  a25136:	ec9fe0ef          	jal	ra,a23ffe <print_str>
  a2513a:	481c                	lw	a5,16(s0)
  a2513c:	00a2 7764 051f      	l.li	a0,0xa27764
  a25142:	578c                	lw	a1,40(a5)
  a25144:	ebbfe0ef          	jal	ra,a23ffe <print_str>
  a25148:	481c                	lw	a5,16(s0)
  a2514a:	00a2 777c 051f      	l.li	a0,0xa2777c
  a25150:	53cc                	lw	a1,36(a5)
  a25152:	eadfe0ef          	jal	ra,a23ffe <print_str>
  a25156:	481c                	lw	a5,16(s0)
  a25158:	00a2 7794 051f      	l.li	a0,0xa27794
  a2515e:	538c                	lw	a1,32(a5)
  a25160:	e9ffe0ef          	jal	ra,a23ffe <print_str>
  a25164:	481c                	lw	a5,16(s0)
  a25166:	00a2 77ac 051f      	l.li	a0,0xa277ac
  a2516c:	4fec                	lw	a1,92(a5)
  a2516e:	e91fe0ef          	jal	ra,a23ffe <print_str>
  a25172:	481c                	lw	a5,16(s0)
  a25174:	00a2 77c4 051f      	l.li	a0,0xa277c4
  a2517a:	4fac                	lw	a1,88(a5)
  a2517c:	e83fe0ef          	jal	ra,a23ffe <print_str>
  a25180:	481c                	lw	a5,16(s0)
  a25182:	00a2 77dc 051f      	l.li	a0,0xa277dc
  a25188:	4bec                	lw	a1,84(a5)
  a2518a:	e75fe0ef          	jal	ra,a23ffe <print_str>
  a2518e:	481c                	lw	a5,16(s0)
  a25190:	00a2 77f4 051f      	l.li	a0,0xa277f4
  a25196:	4bac                	lw	a1,80(a5)
  a25198:	e67fe0ef          	jal	ra,a23ffe <print_str>
  a2519c:	00a2 780c 051f      	l.li	a0,0xa2780c
  a251a2:	8020                	pop	{ra,s0},16
  a251a4:	e5bfe06f          	j	a23ffe <print_str>

00a251a8 <do_process_exception>:
  a251a8:	4154                	lw	a3,4(a0)
  a251aa:	00a077b7          	lui	a5,0xa07
  a251ae:	97878713          	addi	a4,a5,-1672 # a06978 <g_exc_info>
  a251b2:	cb08                	sw	a0,16(a4)
  a251b4:	97878513          	addi	a0,a5,-1672
  a251b8:	a336                	sh	a3,2(a4)
  a251ba:	dc9ff06f          	j	a24f82 <exc_info_display.part.3>

00a251be <do_trap_unknown>:
  a251be:	8028                	push	{ra,s0},-16
  a251c0:	842a                	mv	s0,a0
  a251c2:	00a2 743c 051f      	l.li	a0,0xa2743c
  a251c8:	e37fe0ef          	jal	ra,a23ffe <print_str>
  a251cc:	8522                	mv	a0,s0
  a251ce:	8020                	pop	{ra,s0},16
  a251d0:	fd9ff06f          	j	a251a8 <do_process_exception>

00a251d4 <do_trap_insn_misaligned>:
  a251d4:	8028                	push	{ra,s0},-16
  a251d6:	842a                	mv	s0,a0
  a251d8:	00a2 736c 051f      	l.li	a0,0xa2736c
  a251de:	e21fe0ef          	jal	ra,a23ffe <print_str>
  a251e2:	8522                	mv	a0,s0
  a251e4:	8020                	pop	{ra,s0},16
  a251e6:	fc3ff06f          	j	a251a8 <do_process_exception>

00a251ea <do_trap_insn_fault>:
  a251ea:	8028                	push	{ra,s0},-16
  a251ec:	842a                	mv	s0,a0
  a251ee:	00a2 7320 051f      	l.li	a0,0xa27320
  a251f4:	e0bfe0ef          	jal	ra,a23ffe <print_str>
  a251f8:	8522                	mv	a0,s0
  a251fa:	8020                	pop	{ra,s0},16
  a251fc:	fadff06f          	j	a251a8 <do_process_exception>

00a25200 <do_trap_insn_illegal>:
  a25200:	8028                	push	{ra,s0},-16
  a25202:	842a                	mv	s0,a0
  a25204:	00a2 7348 051f      	l.li	a0,0xa27348
  a2520a:	df5fe0ef          	jal	ra,a23ffe <print_str>
  a2520e:	8522                	mv	a0,s0
  a25210:	8020                	pop	{ra,s0},16
  a25212:	f97ff06f          	j	a251a8 <do_process_exception>

00a25216 <do_trap_load_misaligned>:
  a25216:	8028                	push	{ra,s0},-16
  a25218:	842a                	mv	s0,a0
  a2521a:	00a2 73b8 051f      	l.li	a0,0xa273b8
  a25220:	ddffe0ef          	jal	ra,a23ffe <print_str>
  a25224:	8522                	mv	a0,s0
  a25226:	8020                	pop	{ra,s0},16
  a25228:	f81ff06f          	j	a251a8 <do_process_exception>

00a2522c <do_trap_load_fault>:
  a2522c:	8028                	push	{ra,s0},-16
  a2522e:	842a                	mv	s0,a0
  a25230:	00a2 7398 051f      	l.li	a0,0xa27398
  a25236:	dc9fe0ef          	jal	ra,a23ffe <print_str>
  a2523a:	8522                	mv	a0,s0
  a2523c:	8020                	pop	{ra,s0},16
  a2523e:	f6bff06f          	j	a251a8 <do_process_exception>

00a25242 <do_trap_store_misaligned>:
  a25242:	8028                	push	{ra,s0},-16
  a25244:	842a                	mv	s0,a0
  a25246:	00a2 740c 051f      	l.li	a0,0xa2740c
  a2524c:	db3fe0ef          	jal	ra,a23ffe <print_str>
  a25250:	8522                	mv	a0,s0
  a25252:	8020                	pop	{ra,s0},16
  a25254:	f55ff06f          	j	a251a8 <do_process_exception>

00a25258 <do_trap_store_fault>:
  a25258:	8028                	push	{ra,s0},-16
  a2525a:	842a                	mv	s0,a0
  a2525c:	00a2 73e0 051f      	l.li	a0,0xa273e0
  a25262:	d9dfe0ef          	jal	ra,a23ffe <print_str>
  a25266:	8522                	mv	a0,s0
  a25268:	8020                	pop	{ra,s0},16
  a2526a:	f3fff06f          	j	a251a8 <do_process_exception>

00a2526e <do_trap_ecall_u>:
  a2526e:	8028                	push	{ra,s0},-16
  a25270:	842a                	mv	s0,a0
  a25272:	00a2 72f4 051f      	l.li	a0,0xa272f4
  a25278:	d87fe0ef          	jal	ra,a23ffe <print_str>
  a2527c:	8522                	mv	a0,s0
  a2527e:	8020                	pop	{ra,s0},16
  a25280:	f29ff06f          	j	a251a8 <do_process_exception>

00a25284 <do_trap_ecall_s>:
  a25284:	8028                	push	{ra,s0},-16
  a25286:	842a                	mv	s0,a0
  a25288:	00a2 72c8 051f      	l.li	a0,0xa272c8
  a2528e:	d71fe0ef          	jal	ra,a23ffe <print_str>
  a25292:	8522                	mv	a0,s0
  a25294:	8020                	pop	{ra,s0},16
  a25296:	f13ff06f          	j	a251a8 <do_process_exception>

00a2529a <do_trap_ecall_m>:
  a2529a:	8028                	push	{ra,s0},-16
  a2529c:	842a                	mv	s0,a0
  a2529e:	00a2 729c 051f      	l.li	a0,0xa2729c
  a252a4:	d5bfe0ef          	jal	ra,a23ffe <print_str>
  a252a8:	8522                	mv	a0,s0
  a252aa:	8020                	pop	{ra,s0},16
  a252ac:	efdff06f          	j	a251a8 <do_process_exception>

00a252b0 <do_trap_break>:
  a252b0:	8028                	push	{ra,s0},-16
  a252b2:	842a                	mv	s0,a0
  a252b4:	00a2 7288 051f      	l.li	a0,0xa27288
  a252ba:	d45fe0ef          	jal	ra,a23ffe <print_str>
  a252be:	8522                	mv	a0,s0
  a252c0:	8020                	pop	{ra,s0},16
  a252c2:	ee7ff06f          	j	a251a8 <do_process_exception>

00a252c6 <do_insn_page_fault>:
  a252c6:	8028                	push	{ra,s0},-16
  a252c8:	842a                	mv	s0,a0
  a252ca:	00a2 7210 051f      	l.li	a0,0xa27210
  a252d0:	d2ffe0ef          	jal	ra,a23ffe <print_str>
  a252d4:	8522                	mv	a0,s0
  a252d6:	8020                	pop	{ra,s0},16
  a252d8:	ed1ff06f          	j	a251a8 <do_process_exception>

00a252dc <do_load_page_fault>:
  a252dc:	8028                	push	{ra,s0},-16
  a252de:	842a                	mv	s0,a0
  a252e0:	00a2 7230 051f      	l.li	a0,0xa27230
  a252e6:	d19fe0ef          	jal	ra,a23ffe <print_str>
  a252ea:	8522                	mv	a0,s0
  a252ec:	8020                	pop	{ra,s0},16
  a252ee:	ebbff06f          	j	a251a8 <do_process_exception>

00a252f2 <do_store_page_fault>:
  a252f2:	8028                	push	{ra,s0},-16
  a252f4:	842a                	mv	s0,a0
  a252f6:	00a2 7268 051f      	l.li	a0,0xa27268
  a252fc:	d03fe0ef          	jal	ra,a23ffe <print_str>
  a25300:	8522                	mv	a0,s0
  a25302:	8020                	pop	{ra,s0},16
  a25304:	ea5ff06f          	j	a251a8 <do_process_exception>

00a25308 <do_hard_fault>:
  a25308:	8028                	push	{ra,s0},-16
  a2530a:	842a                	mv	s0,a0
  a2530c:	00a2 71d4 051f      	l.li	a0,0xa271d4
  a25312:	cedfe0ef          	jal	ra,a23ffe <print_str>
  a25316:	8522                	mv	a0,s0
  a25318:	8020                	pop	{ra,s0},16
  a2531a:	e8fff06f          	j	a251a8 <do_process_exception>

00a2531e <do_lockup>:
  a2531e:	8028                	push	{ra,s0},-16
  a25320:	842a                	mv	s0,a0
  a25322:	00a2 7250 051f      	l.li	a0,0xa27250
  a25328:	cd7fe0ef          	jal	ra,a23ffe <print_str>
  a2532c:	8522                	mv	a0,s0
  a2532e:	8020                	pop	{ra,s0},16
  a25330:	e79ff06f          	j	a251a8 <do_process_exception>

00a25334 <default_handler>:
  a25334:	8018                	push	{ra},-16
  a25336:	bdfff0ef          	jal	ra,a24f14 <interrupt_number_get>
  a2533a:	85aa                	mv	a1,a0
  a2533c:	00a2 71a8 051f      	l.li	a0,0xa271a8
  a25342:	cbdfe0ef          	jal	ra,a23ffe <print_str>
  a25346:	a001                	j	a25346 <default_handler+0x12>

00a25348 <nmi_handler>:
  a25348:	8018                	push	{ra},-16
  a2534a:	bcbff0ef          	jal	ra,a24f14 <interrupt_number_get>
  a2534e:	85aa                	mv	a1,a0
  a25350:	00a2 7848 051f      	l.li	a0,0xa27848
  a25356:	ca9fe0ef          	jal	ra,a23ffe <print_str>
  a2535a:	a001                	j	a2535a <nmi_handler+0x12>

00a2535c <cpu_utils_set_system_status_by_cause>:
  a2535c:	8018                	push	{ra},-16
  a2535e:	2235                	jal	ra,a2548a <set_cpu_utils_reset_cause>
  a25360:	8010                	pop	{ra},16
  a25362:	a8e1                	j	a2543a <set_cpu_utils_system_boot_magic>

00a25364 <cpu_utils_reset_chip_with_log>:
  a25364:	8118                	push	{ra},-32
  a25366:	4501                	li	a0,0
  a25368:	c62e                	sw	a1,12(sp)
  a2536a:	2a0d                	jal	ra,a2549c <set_update_reset_cause_on_boot>
  a2536c:	45b2                	lw	a1,12(sp)
  a2536e:	852e                	mv	a0,a1
  a25370:	fedff0ef          	jal	ra,a2535c <cpu_utils_set_system_status_by_cause>
  a25374:	8110                	pop	{ra},32
  a25376:	a47fd06f          	j	a22dbc <hal_reboot_chip>

00a2537a <panic_deal>:
  a2537a:	8458                	push	{ra,s0-s3},-96
  a2537c:	86b2                	mv	a3,a2
  a2537e:	892a                	mv	s2,a0
  a25380:	84ae                	mv	s1,a1
  a25382:	8432                	mv	s0,a2
  a25384:	862e                	mv	a2,a1
  a25386:	85aa                	mv	a1,a0
  a25388:	00a2 7870 051f      	l.li	a0,0xa27870
  a2538e:	c71fe0ef          	jal	ra,a23ffe <print_str>
  a25392:	ceffc0ef          	jal	ra,a22080 <osal_irq_lock>
  a25396:	00a0 6990 079f      	l.li	a5,0xa06990
  a2539c:	2398                	lbu	a4,0(a5)
  a2539e:	89aa                	mv	s3,a0
  a253a0:	e321                	bnez	a4,a253e0 <panic_deal+0x66>
  a253a2:	4705                	li	a4,1
  a253a4:	a398                	sb	a4,0(a5)
  a253a6:	03210023          	sb	s2,32(sp)
  a253aa:	d226                	sw	s1,36(sp)
  a253ac:	f57fc0ef          	jal	ra,a22302 <uapi_systick_get_us>
  a253b0:	d42a                	sw	a0,40(sp)
  a253b2:	1008                	addi	a0,sp,32
  a253b4:	d622                	sw	s0,44(sp)
  a253b6:	28cd                	jal	ra,a254a8 <set_last_panic>
  a253b8:	02000613          	li	a2,32
  a253bc:	4581                	li	a1,0
  a253be:	1008                	addi	a0,sp,32
  a253c0:	c802                	sw	zero,16(sp)
  a253c2:	ca02                	sw	zero,20(sp)
  a253c4:	cc02                	sw	zero,24(sp)
  a253c6:	ce02                	sw	zero,28(sp)
  a253c8:	e7cfb0ef          	jal	ra,a20a44 <memset>
  a253cc:	da22                	sw	s0,52(sp)
  a253ce:	341027f3          	csrr	a5,mepc
  a253d2:	dc3e                	sw	a5,56(sp)
  a253d4:	878a                	mv	a5,sp
  a253d6:	0068                	addi	a0,sp,12
  a253d8:	c63e                	sw	a5,12(sp)
  a253da:	2209                	jal	ra,a254dc <set_exception_info>
  a253dc:	1008                	addi	a0,sp,32
  a253de:	2a31                	jal	ra,a254fa <set_exception_stack_frame>
  a253e0:	00a0 6994 079f      	l.li	a5,0xa06994
  a253e6:	439c                	lw	a5,0(a5)
  a253e8:	c391                	beqz	a5,a253ec <panic_deal+0x72>
  a253ea:	9782                	jalr	a5
  a253ec:	6589                	lui	a1,0x2
  a253ee:	058d                	addi	a1,a1,3 # 2003 <ccause+0x1041>
  a253f0:	4509                	li	a0,2
  a253f2:	f73ff0ef          	jal	ra,a25364 <cpu_utils_reset_chip_with_log>
  a253f6:	854e                	mv	a0,s3
  a253f8:	c91fc0ef          	jal	ra,a22088 <osal_irq_restore>
  a253fc:	8454                	popret	{ra,s0-s3},96

00a253fe <panic>:
  a253fe:	00a0 2498 079f      	l.li	a5,0xa02498
  a25404:	0007a303          	lw	t1,0(a5)
  a25408:	00030563          	beqz	t1,a25412 <panic+0x14>
  a2540c:	ffb08613          	addi	a2,ra,-5
  a25410:	8302                	jr	t1
  a25412:	8118                	push	{ra},-32
  a25414:	4785                	li	a5,1
  a25416:	00f107a3          	sb	a5,15(sp)
  a2541a:	00f14783          	lbu	a5,15(sp)
  a2541e:	9f81                	uxtb	a5
  a25420:	ffed                	bnez	a5,a2541a <panic+0x1c>
  a25422:	8114                	popret	{ra},32

00a25424 <duplicate_preserve_mem>:
  a25424:	0fc00693          	li	a3,252
  a25428:	00a0 24dc 061f      	l.li	a2,0xa024dc
  a2542e:	0fc00593          	li	a1,252
  a25432:	00a0 6998 051f      	l.li	a0,0xa06998
  a25438:	aa15                	j	a2556c <memcpy_s>

00a2543a <set_cpu_utils_system_boot_magic>:
  a2543a:	00a02737          	lui	a4,0xa02
  a2543e:	4dc70793          	addi	a5,a4,1244 # a024dc <g_preserve_data_lib>
  a25442:	0d87d783          	lhu	a5,216(a5)
  a25446:	6689                	lui	a3,0x2
  a25448:	04068613          	addi	a2,a3,64 # 2040 <ccause+0x107e>
  a2544c:	4dc70713          	addi	a4,a4,1244
  a25450:	02c78963          	beq	a5,a2,a25482 <set_cpu_utils_system_boot_magic+0x48>
  a25454:	00f66c63          	bltu	a2,a5,a2546c <set_cpu_utils_system_boot_magic+0x32>
  a25458:	c78d                	beqz	a5,a25482 <set_cpu_utils_system_boot_magic+0x48>
  a2545a:	0685                	addi	a3,a3,1
  a2545c:	02d78363          	beq	a5,a3,a25482 <set_cpu_utils_system_boot_magic+0x48>
  a25460:	dead beaf 079f      	l.li	a5,0xdeadbeaf
  a25466:	0ef72423          	sw	a5,232(a4)
  a2546a:	8082                	ret
  a2546c:	66a1                	lui	a3,0x8
  a2546e:	0685                	addi	a3,a3,1 # 8001 <ccause+0x703f>
  a25470:	00d78963          	beq	a5,a3,a25482 <set_cpu_utils_system_boot_magic+0x48>
  a25474:	0000 f0f0 069f      	l.li	a3,0xf0f0
  a2547a:	00d78463          	beq	a5,a3,a25482 <set_cpu_utils_system_boot_magic+0x48>
  a2547e:	6691                	lui	a3,0x4
  a25480:	bfe9                	j	a2545a <set_cpu_utils_system_boot_magic+0x20>
  a25482:	dead dead 079f      	l.li	a5,0xdeaddead
  a25488:	bff9                	j	a25466 <set_cpu_utils_system_boot_magic+0x2c>

00a2548a <set_cpu_utils_reset_cause>:
  a2548a:	00a0 24dc 079f      	l.li	a5,0xa024dc
  a25490:	0c078d23          	sb	zero,218(a5)
  a25494:	0ca79c23          	sh	a0,216(a5)
  a25498:	f8dff06f          	j	a25424 <duplicate_preserve_mem>

00a2549c <set_update_reset_cause_on_boot>:
  a2549c:	00a0 24dc 079f      	l.li	a5,0xa024dc
  a254a2:	0ca78d23          	sb	a0,218(a5)
  a254a6:	8082                	ret

00a254a8 <set_last_panic>:
  a254a8:	8018                	push	{ra},-16
  a254aa:	862a                	mv	a2,a0
  a254ac:	00a0 24dc 051f      	l.li	a0,0xa024dc
  a254b2:	46c1                	li	a3,16
  a254b4:	45c1                	li	a1,16
  a254b6:	0a450513          	addi	a0,a0,164
  a254ba:	284d                	jal	ra,a2556c <memcpy_s>
  a254bc:	8010                	pop	{ra},16
  a254be:	f67ff06f          	j	a25424 <duplicate_preserve_mem>

00a254c2 <set_exception_info_riscv>:
  a254c2:	8018                	push	{ra},-16
  a254c4:	862a                	mv	a2,a0
  a254c6:	09000693          	li	a3,144
  a254ca:	09000593          	li	a1,144
  a254ce:	00a0 24dc 051f      	l.li	a0,0xa024dc
  a254d4:	2861                	jal	ra,a2556c <memcpy_s>
  a254d6:	8010                	pop	{ra},16
  a254d8:	f4dff06f          	j	a25424 <duplicate_preserve_mem>

00a254dc <set_exception_info>:
  a254dc:	cd11                	beqz	a0,a254f8 <set_exception_info+0x1c>
  a254de:	8018                	push	{ra},-16
  a254e0:	862a                	mv	a2,a0
  a254e2:	00a0 24dc 051f      	l.li	a0,0xa024dc
  a254e8:	46d1                	li	a3,20
  a254ea:	45d1                	li	a1,20
  a254ec:	09050513          	addi	a0,a0,144
  a254f0:	28b5                	jal	ra,a2556c <memcpy_s>
  a254f2:	8010                	pop	{ra},16
  a254f4:	f31ff06f          	j	a25424 <duplicate_preserve_mem>
  a254f8:	8082                	ret

00a254fa <set_exception_stack_frame>:
  a254fa:	4958                	lw	a4,20(a0)
  a254fc:	00a0 24dc 079f      	l.li	a5,0xa024dc
  a25502:	08e7a623          	sw	a4,140(a5)
  a25506:	4d18                	lw	a4,24(a0)
  a25508:	cbd8                	sw	a4,20(a5)
  a2550a:	f1bff06f          	j	a25424 <duplicate_preserve_mem>

00a2550e <SecMemcpyError>:
  a2550e:	04b05b63          	blez	a1,a25564 <SecMemcpyError+0x56>
  a25512:	87aa                	mv	a5,a0
  a25514:	4859                	li	a6,22
  a25516:	c929                	beqz	a0,a25568 <SecMemcpyError+0x5a>
  a25518:	8018                	push	{ra},-16
  a2551a:	8732                	mv	a4,a2
  a2551c:	862e                	mv	a2,a1
  a2551e:	eb01                	bnez	a4,a2552e <SecMemcpyError+0x20>
  a25520:	4581                	li	a1,0
  a25522:	d22fb0ef          	jal	ra,a20a44 <memset>
  a25526:	09600813          	li	a6,150
  a2552a:	8542                	mv	a0,a6
  a2552c:	8014                	popret	{ra},16
  a2552e:	00d5f863          	bgeu	a1,a3,a2553e <SecMemcpyError+0x30>
  a25532:	4581                	li	a1,0
  a25534:	d10fb0ef          	jal	ra,a20a44 <memset>
  a25538:	0a200813          	li	a6,162
  a2553c:	b7fd                	j	a2552a <SecMemcpyError+0x1c>
  a2553e:	00a77663          	bgeu	a4,a0,a2554a <SecMemcpyError+0x3c>
  a25542:	00d705b3          	add	a1,a4,a3
  a25546:	00b56863          	bltu	a0,a1,a25556 <SecMemcpyError+0x48>
  a2554a:	4801                	li	a6,0
  a2554c:	fce7ffe3          	bgeu	a5,a4,a2552a <SecMemcpyError+0x1c>
  a25550:	96be                	add	a3,a3,a5
  a25552:	fcd77ce3          	bgeu	a4,a3,a2552a <SecMemcpyError+0x1c>
  a25556:	4581                	li	a1,0
  a25558:	853e                	mv	a0,a5
  a2555a:	ceafb0ef          	jal	ra,a20a44 <memset>
  a2555e:	0b600813          	li	a6,182
  a25562:	b7e1                	j	a2552a <SecMemcpyError+0x1c>
  a25564:	02200813          	li	a6,34
  a25568:	8542                	mv	a0,a6
  a2556a:	8082                	ret

00a2556c <memcpy_s>:
  a2556c:	02d5e363          	bltu	a1,a3,a25592 <memcpy_s+0x26>
  a25570:	c10d                	beqz	a0,a25592 <memcpy_s+0x26>
  a25572:	c205                	beqz	a2,a25592 <memcpy_s+0x26>
  a25574:	0005cf63          	bltz	a1,a25592 <memcpy_s+0x26>
  a25578:	ce89                	beqz	a3,a25592 <memcpy_s+0x26>
  a2557a:	00a67663          	bgeu	a2,a0,a25586 <memcpy_s+0x1a>
  a2557e:	00d607b3          	add	a5,a2,a3
  a25582:	00f57a63          	bgeu	a0,a5,a25596 <memcpy_s+0x2a>
  a25586:	00c57663          	bgeu	a0,a2,a25592 <memcpy_s+0x26>
  a2558a:	00d507b3          	add	a5,a0,a3
  a2558e:	00f67463          	bgeu	a2,a5,a25596 <memcpy_s+0x2a>
  a25592:	f7dff06f          	j	a2550e <SecMemcpyError>
  a25596:	8018                	push	{ra},-16
  a25598:	85b2                	mv	a1,a2
  a2559a:	8636                	mv	a2,a3
  a2559c:	d56fb0ef          	jal	ra,a20af2 <memcpy>
  a255a0:	4501                	li	a0,0
  a255a2:	8014                	popret	{ra},16

00a255a4 <memset_s>:
  a255a4:	87ae                	mv	a5,a1
  a255a6:	0205c363          	bltz	a1,a255cc <memset_s+0x28>
  a255aa:	8028                	push	{ra,s0},-16
  a255ac:	842a                	mv	s0,a0
  a255ae:	c911                	beqz	a0,a255c2 <memset_s+0x1e>
  a255b0:	85b2                	mv	a1,a2
  a255b2:	8636                	mv	a2,a3
  a255b4:	02d7e063          	bltu	a5,a3,a255d4 <memset_s+0x30>
  a255b8:	c8cfb0ef          	jal	ra,a20a44 <memset>
  a255bc:	4701                	li	a4,0
  a255be:	853a                	mv	a0,a4
  a255c0:	8024                	popret	{ra,s0},16
  a255c2:	02200713          	li	a4,34
  a255c6:	dde5                	beqz	a1,a255be <memset_s+0x1a>
  a255c8:	4759                	li	a4,22
  a255ca:	bfd5                	j	a255be <memset_s+0x1a>
  a255cc:	02200713          	li	a4,34
  a255d0:	853a                	mv	a0,a4
  a255d2:	8082                	ret
  a255d4:	02200713          	li	a4,34
  a255d8:	d3fd                	beqz	a5,a255be <memset_s+0x1a>
  a255da:	863e                	mv	a2,a5
  a255dc:	c68fb0ef          	jal	ra,a20a44 <memset>
  a255e0:	0a200713          	li	a4,162
  a255e4:	bfe9                	j	a255be <memset_s+0x1a>

00a255e6 <SecWriteMultiChar>:
  a255e6:	8732                	mv	a4,a2
  a255e8:	00e04663          	bgtz	a4,a255f4 <SecWriteMultiChar+0xe>
  a255ec:	429c                	lw	a5,0(a3)
  a255ee:	963e                	add	a2,a2,a5
  a255f0:	c290                	sw	a2,0(a3)
  a255f2:	8082                	ret
  a255f4:	411c                	lw	a5,0(a0)
  a255f6:	17fd                	addi	a5,a5,-1
  a255f8:	c11c                	sw	a5,0(a0)
  a255fa:	0007d563          	bgez	a5,a25604 <SecWriteMultiChar+0x1e>
  a255fe:	57fd                	li	a5,-1
  a25600:	c29c                	sw	a5,0(a3)
  a25602:	8082                	ret
  a25604:	415c                	lw	a5,4(a0)
  a25606:	177d                	addi	a4,a4,-1
  a25608:	a38c                	sb	a1,0(a5)
  a2560a:	415c                	lw	a5,4(a0)
  a2560c:	0785                	addi	a5,a5,1
  a2560e:	c15c                	sw	a5,4(a0)
  a25610:	bfe1                	j	a255e8 <SecWriteMultiChar+0x2>

00a25612 <SecOutput>:
  a25612:	9fd8                	push	{ra,s0-s11},-560
  a25614:	00a28ab7          	lui	s5,0xa28
  a25618:	8cca8793          	addi	a5,s5,-1844 # a278cc <g_itoaUpperDigits>
  a2561c:	711d                	addi	sp,sp,-96
  a2561e:	cc3e                	sw	a5,24(sp)
  a25620:	00a28b37          	lui	s6,0xa28
  a25624:	47a9                	li	a5,10
  a25626:	8caa                	mv	s9,a0
  a25628:	8432                	mv	s0,a2
  a2562a:	ce02                	sw	zero,28(sp)
  a2562c:	d002                	sw	zero,32(sp)
  a2562e:	d202                	sw	zero,36(sp)
  a25630:	d43e                	sw	a5,40(sp)
  a25632:	d602                	sw	zero,44(sp)
  a25634:	d802                	sw	zero,48(sp)
  a25636:	da02                	sw	zero,52(sp)
  a25638:	dc02                	sw	zero,56(sp)
  a2563a:	de02                	sw	zero,60(sp)
  a2563c:	c082                	sw	zero,64(sp)
  a2563e:	c282                	sw	zero,68(sp)
  a25640:	04011423          	sh	zero,72(sp)
  a25644:	ca02                	sw	zero,20(sp)
  a25646:	4701                	li	a4,0
  a25648:	8cca8a93          	addi	s5,s5,-1844
  a2564c:	00a2 78e0 0b9f      	l.li	s7,0xa278e0
  a25652:	898b0b13          	addi	s6,s6,-1896 # a27898 <g_efuse_cfg+0x7e8>
  a25656:	00a0 249c 0c1f      	l.li	s8,0xa0249c
  a2565c:	00a2 78b8 091f      	l.li	s2,0xa278b8
  a25662:	219c                	lbu	a5,0(a1)
  a25664:	c781                	beqz	a5,a2566c <SecOutput+0x5a>
  a25666:	46d2                	lw	a3,20(sp)
  a25668:	0006d963          	bgez	a3,a2567a <SecOutput+0x68>
  a2566c:	c319                	beqz	a4,a25672 <SecOutput+0x60>
  a2566e:	0737163b          	bnei	a4,7,a25746 <SecOutput+0x134>
  a25672:	4552                	lw	a0,20(sp)
  a25674:	25010113          	addi	sp,sp,592
  a25678:	80d4                	popret	{ra,s0-s11},64
  a2567a:	00fb86b3          	add	a3,s7,a5
  a2567e:	2294                	lbu	a3,0(a3)
  a25680:	00158a13          	addi	s4,a1,1
  a25684:	08dbd6db          	muliadd	a3,s7,a3,9
  a25688:	96ba                	add	a3,a3,a4
  a2568a:	1006c983          	lbu	s3,256(a3) # 4100 <ccause+0x313e>
  a2568e:	0829fe3b          	bgeui	s3,8,a25746 <SecOutput+0x134>
  a25692:	053b069b          	addshf	a3,s6,s3,sll,2
  a25696:	4294                	lw	a3,0(a3)
  a25698:	8682                	jr	a3
  a2569a:	000ca703          	lw	a4,0(s9)
  a2569e:	177d                	addi	a4,a4,-1
  a256a0:	00eca023          	sw	a4,0(s9)
  a256a4:	02074063          	bltz	a4,a256c4 <SecOutput+0xb2>
  a256a8:	004ca703          	lw	a4,4(s9)
  a256ac:	a31c                	sb	a5,0(a4)
  a256ae:	004ca783          	lw	a5,4(s9)
  a256b2:	0785                	addi	a5,a5,1
  a256b4:	00fca223          	sw	a5,4(s9)
  a256b8:	47d2                	lw	a5,20(sp)
  a256ba:	0785                	addi	a5,a5,1
  a256bc:	ca3e                	sw	a5,20(sp)
  a256be:	85d2                	mv	a1,s4
  a256c0:	874e                	mv	a4,s3
  a256c2:	b745                	j	a25662 <SecOutput+0x50>
  a256c4:	57fd                	li	a5,-1
  a256c6:	bfdd                	j	a256bc <SecOutput+0xaa>
  a256c8:	57fd                	li	a5,-1
  a256ca:	c282                	sw	zero,68(sp)
  a256cc:	d002                	sw	zero,32(sp)
  a256ce:	d602                	sw	zero,44(sp)
  a256d0:	d802                	sw	zero,48(sp)
  a256d2:	da3e                	sw	a5,52(sp)
  a256d4:	d202                	sw	zero,36(sp)
  a256d6:	dc02                	sw	zero,56(sp)
  a256d8:	de02                	sw	zero,60(sp)
  a256da:	b7d5                	j	a256be <SecOutput+0xac>
  a256dc:	02b00713          	li	a4,43
  a256e0:	02e78963          	beq	a5,a4,a25712 <SecOutput+0x100>
  a256e4:	00f76a63          	bltu	a4,a5,a256f8 <SecOutput+0xe6>
  a256e8:	2007883b          	beqi	a5,32,a25708 <SecOutput+0xf6>
  a256ec:	23f794bb          	bnei	a5,35,a256be <SecOutput+0xac>
  a256f0:	57b2                	lw	a5,44(sp)
  a256f2:	0807e793          	ori	a5,a5,128
  a256f6:	a821                	j	a2570e <SecOutput+0xfc>
  a256f8:	2d0788bb          	beqi	a5,45,a2571a <SecOutput+0x108>
  a256fc:	30f790bb          	bnei	a5,48,a256be <SecOutput+0xac>
  a25700:	57b2                	lw	a5,44(sp)
  a25702:	0087e793          	ori	a5,a5,8
  a25706:	a021                	j	a2570e <SecOutput+0xfc>
  a25708:	57b2                	lw	a5,44(sp)
  a2570a:	0027e793          	ori	a5,a5,2
  a2570e:	d63e                	sw	a5,44(sp)
  a25710:	b77d                	j	a256be <SecOutput+0xac>
  a25712:	57b2                	lw	a5,44(sp)
  a25714:	0017e793          	ori	a5,a5,1
  a25718:	bfdd                	j	a2570e <SecOutput+0xfc>
  a2571a:	57b2                	lw	a5,44(sp)
  a2571c:	0047e793          	ori	a5,a5,4
  a25720:	b7fd                	j	a2570e <SecOutput+0xfc>
  a25722:	2a0793bb          	bnei	a5,42,a25730 <SecOutput+0x11e>
  a25726:	4014                	lw	a3,0(s0)
  a25728:	0411                	addi	s0,s0,4
  a2572a:	d836                	sw	a3,48(sp)
  a2572c:	4685                	li	a3,1
  a2572e:	dc36                	sw	a3,56(sp)
  a25730:	56e2                	lw	a3,56(sp)
  a25732:	e695                	bnez	a3,a2575e <SecOutput+0x14c>
  a25734:	030701bb          	beqi	a4,3,a2573a <SecOutput+0x128>
  a25738:	d802                	sw	zero,48(sp)
  a2573a:	56c2                	lw	a3,48(sp)
  a2573c:	0147 ae14 071f      	l.li	a4,0x147ae14
  a25742:	00d75463          	bge	a4,a3,a2574a <SecOutput+0x138>
  a25746:	557d                	li	a0,-1
  a25748:	b735                	j	a25674 <SecOutput+0x62>
  a2574a:	00269713          	slli	a4,a3,0x2
  a2574e:	fd078793          	addi	a5,a5,-48
  a25752:	9736                	add	a4,a4,a3
  a25754:	9f81                	uxtb	a5
  a25756:	02e7879b          	addshf	a5,a5,a4,sll,1
  a2575a:	d83e                	sw	a5,48(sp)
  a2575c:	b78d                	j	a256be <SecOutput+0xac>
  a2575e:	57c2                	lw	a5,48(sp)
  a25760:	0007d963          	bgez	a5,a25772 <SecOutput+0x160>
  a25764:	5732                	lw	a4,44(sp)
  a25766:	40f007b3          	neg	a5,a5
  a2576a:	d83e                	sw	a5,48(sp)
  a2576c:	00476713          	ori	a4,a4,4
  a25770:	d63a                	sw	a4,44(sp)
  a25772:	5742                	lw	a4,48(sp)
  a25774:	0ccc ccc8 079f      	l.li	a5,0xcccccc8
  a2577a:	f4e7d2e3          	bge	a5,a4,a256be <SecOutput+0xac>
  a2577e:	b7e1                	j	a25746 <SecOutput+0x134>
  a25780:	da02                	sw	zero,52(sp)
  a25782:	bf35                	j	a256be <SecOutput+0xac>
  a25784:	2a0793bb          	bnei	a5,42,a25792 <SecOutput+0x180>
  a25788:	4018                	lw	a4,0(s0)
  a2578a:	0411                	addi	s0,s0,4
  a2578c:	da3a                	sw	a4,52(sp)
  a2578e:	4705                	li	a4,1
  a25790:	de3a                	sw	a4,60(sp)
  a25792:	56f2                	lw	a3,60(sp)
  a25794:	5752                	lw	a4,52(sp)
  a25796:	e285                	bnez	a3,a257b6 <SecOutput+0x1a4>
  a25798:	0147 ae14 069f      	l.li	a3,0x147ae14
  a2579e:	fae6c4e3          	blt	a3,a4,a25746 <SecOutput+0x134>
  a257a2:	00271693          	slli	a3,a4,0x2
  a257a6:	fd078793          	addi	a5,a5,-48
  a257aa:	9736                	add	a4,a4,a3
  a257ac:	9f81                	uxtb	a5
  a257ae:	02e7879b          	addshf	a5,a5,a4,sll,1
  a257b2:	da3e                	sw	a5,52(sp)
  a257b4:	b729                	j	a256be <SecOutput+0xac>
  a257b6:	00075463          	bgez	a4,a257be <SecOutput+0x1ac>
  a257ba:	57fd                	li	a5,-1
  a257bc:	da3e                	sw	a5,52(sp)
  a257be:	5752                	lw	a4,52(sp)
  a257c0:	bf55                	j	a25774 <SecOutput+0x162>
  a257c2:	06a00713          	li	a4,106
  a257c6:	08e78763          	beq	a5,a4,a25854 <SecOutput+0x242>
  a257ca:	04f76063          	bltu	a4,a5,a2580a <SecOutput+0x1f8>
  a257ce:	04c00713          	li	a4,76
  a257d2:	04e78663          	beq	a5,a4,a2581e <SecOutput+0x20c>
  a257d6:	00f76e63          	bltu	a4,a5,a257f2 <SecOutput+0x1e0>
  a257da:	49b7993b          	bnei	a5,73,a256be <SecOutput+0xac>
  a257de:	319c                	lbu	a5,1(a1)
  a257e0:	36179fbb          	bnei	a5,54,a2585e <SecOutput+0x24c>
  a257e4:	21bc                	lbu	a5,2(a1)
  a257e6:	34279d3b          	bnei	a5,52,a2589a <SecOutput+0x288>
  a257ea:	00358a13          	addi	s4,a1,3
  a257ee:	6721                	lui	a4,0x8
  a257f0:	a091                	j	a25834 <SecOutput+0x222>
  a257f2:	5a078fbb          	beqi	a5,90,a25830 <SecOutput+0x21e>
  a257f6:	68b7923b          	bnei	a5,104,a256be <SecOutput+0xac>
  a257fa:	3194                	lbu	a3,1(a1)
  a257fc:	5732                	lw	a4,44(sp)
  a257fe:	0af69763          	bne	a3,a5,a258ac <SecOutput+0x29a>
  a25802:	00258a13          	addi	s4,a1,2
  a25806:	6789                	lui	a5,0x2
  a25808:	a081                	j	a25848 <SecOutput+0x236>
  a2580a:	07400713          	li	a4,116
  a2580e:	04e78663          	beq	a5,a4,a2585a <SecOutput+0x248>
  a25812:	00f76b63          	bltu	a4,a5,a25828 <SecOutput+0x216>
  a25816:	6c07893b          	beqi	a5,108,a2583a <SecOutput+0x228>
  a2581a:	71a7993b          	bnei	a5,113,a256be <SecOutput+0xac>
  a2581e:	57b2                	lw	a5,44(sp)
  a25820:	0000 1400 071f      	l.li	a4,0x1400
  a25826:	a801                	j	a25836 <SecOutput+0x224>
  a25828:	772782bb          	beqi	a5,119,a258b2 <SecOutput+0x2a0>
  a2582c:	7aa794bb          	bnei	a5,122,a256be <SecOutput+0xac>
  a25830:	00020737          	lui	a4,0x20
  a25834:	57b2                	lw	a5,44(sp)
  a25836:	8fd9                	or	a5,a5,a4
  a25838:	bdd9                	j	a2570e <SecOutput+0xfc>
  a2583a:	3194                	lbu	a3,1(a1)
  a2583c:	5732                	lw	a4,44(sp)
  a2583e:	00f69763          	bne	a3,a5,a2584c <SecOutput+0x23a>
  a25842:	00258a13          	addi	s4,a1,2
  a25846:	6785                	lui	a5,0x1
  a25848:	8f5d                	or	a4,a4,a5
  a2584a:	a019                	j	a25850 <SecOutput+0x23e>
  a2584c:	01076713          	ori	a4,a4,16
  a25850:	d63a                	sw	a4,44(sp)
  a25852:	b5b5                	j	a256be <SecOutput+0xac>
  a25854:	00040737          	lui	a4,0x40
  a25858:	bff1                	j	a25834 <SecOutput+0x222>
  a2585a:	6741                	lui	a4,0x10
  a2585c:	bfe1                	j	a25834 <SecOutput+0x222>
  a2585e:	3307963b          	bnei	a5,51,a25876 <SecOutput+0x264>
  a25862:	21bc                	lbu	a5,2(a1)
  a25864:	32079dbb          	bnei	a5,50,a2589a <SecOutput+0x288>
  a25868:	57b2                	lw	a5,44(sp)
  a2586a:	7761                	lui	a4,0xffff8
  a2586c:	177d                	addi	a4,a4,-1 # ffff7fff <__data_load__+0xff5d05cb>
  a2586e:	00358a13          	addi	s4,a1,3
  a25872:	8ff9                	and	a5,a5,a4
  a25874:	bd69                	j	a2570e <SecOutput+0xfc>
  a25876:	f9c78713          	addi	a4,a5,-100 # f9c <__data_size__+0xec0>
  a2587a:	0ff77693          	andi	a3,a4,255
  a2587e:	1206f53b          	bgeui	a3,18,a25892 <SecOutput+0x280>
  a25882:	0002 0821 071f      	l.li	a4,0x20821
  a25888:	00d75733          	srl	a4,a4,a3
  a2588c:	8b05                	andi	a4,a4,1
  a2588e:	e20718e3          	bnez	a4,a256be <SecOutput+0xac>
  a25892:	0df7f793          	andi	a5,a5,223
  a25896:	58878a3b          	beqi	a5,88,a256be <SecOutput+0xac>
  a2589a:	000ca783          	lw	a5,0(s9)
  a2589e:	17fd                	addi	a5,a5,-1
  a258a0:	00fca023          	sw	a5,0(s9)
  a258a4:	0007dc63          	bgez	a5,a258bc <SecOutput+0x2aa>
  a258a8:	57fd                	li	a5,-1
  a258aa:	a02d                	j	a258d4 <SecOutput+0x2c2>
  a258ac:	02076713          	ori	a4,a4,32
  a258b0:	b745                	j	a25850 <SecOutput+0x23e>
  a258b2:	57b2                	lw	a5,44(sp)
  a258b4:	0000 0800 071f      	l.li	a4,0x800
  a258ba:	bfb5                	j	a25836 <SecOutput+0x224>
  a258bc:	004ca783          	lw	a5,4(s9)
  a258c0:	04900713          	li	a4,73
  a258c4:	a398                	sb	a4,0(a5)
  a258c6:	004ca783          	lw	a5,4(s9)
  a258ca:	0785                	addi	a5,a5,1
  a258cc:	00fca223          	sw	a5,4(s9)
  a258d0:	47d2                	lw	a5,20(sp)
  a258d2:	0785                	addi	a5,a5,1
  a258d4:	ca3e                	sw	a5,20(sp)
  a258d6:	4981                	li	s3,0
  a258d8:	b3dd                	j	a256be <SecOutput+0xac>
  a258da:	6847f23b          	bgeui	a5,104,a259e2 <SecOutput+0x3d0>
  a258de:	06500713          	li	a4,101
  a258e2:	e6e7f2e3          	bgeu	a5,a4,a25746 <SecOutput+0x134>
  a258e6:	05300713          	li	a4,83
  a258ea:	1ae78963          	beq	a5,a4,a25a9c <SecOutput+0x48a>
  a258ee:	08f76f63          	bltu	a4,a5,a2598c <SecOutput+0x37a>
  a258f2:	04300713          	li	a4,67
  a258f6:	14e78f63          	beq	a5,a4,a25a54 <SecOutput+0x442>
  a258fa:	00e7e663          	bltu	a5,a4,a25906 <SecOutput+0x2f4>
  a258fe:	fbb78793          	addi	a5,a5,-69
  a25902:	0397e13b          	bltui	a5,3,a25746 <SecOutput+0x134>
  a25906:	5782                	lw	a5,32(sp)
  a25908:	5642                	lw	a2,48(sp)
  a2590a:	8e1d                	sub	a2,a2,a5
  a2590c:	4796                	lw	a5,68(sp)
  a2590e:	8e1d                	sub	a2,a2,a5
  a25910:	57b2                	lw	a5,44(sp)
  a25912:	c0b2                	sw	a2,64(sp)
  a25914:	8bb1                	andi	a5,a5,12
  a25916:	eb89                	bnez	a5,a25928 <SecOutput+0x316>
  a25918:	00c05863          	blez	a2,a25928 <SecOutput+0x316>
  a2591c:	0854                	addi	a3,sp,20
  a2591e:	02000593          	li	a1,32
  a25922:	8566                	mv	a0,s9
  a25924:	cc3ff0ef          	jal	ra,a255e6 <SecWriteMultiChar>
  a25928:	4696                	lw	a3,68(sp)
  a2592a:	00d05e63          	blez	a3,a25946 <SecOutput+0x334>
  a2592e:	083c                	addi	a5,sp,24
  a25930:	00f68633          	add	a2,a3,a5
  a25934:	000ca703          	lw	a4,0(s9)
  a25938:	177d                	addi	a4,a4,-1
  a2593a:	00eca023          	sw	a4,0(s9)
  a2593e:	4a075e63          	bgez	a4,a25dfa <SecOutput+0x7e8>
  a25942:	57fd                	li	a5,-1
  a25944:	ca3e                	sw	a5,20(sp)
  a25946:	57b2                	lw	a5,44(sp)
  a25948:	8bb1                	andi	a5,a5,12
  a2594a:	080795bb          	bnei	a5,8,a25960 <SecOutput+0x34e>
  a2594e:	4606                	lw	a2,64(sp)
  a25950:	00c05863          	blez	a2,a25960 <SecOutput+0x34e>
  a25954:	0854                	addi	a3,sp,20
  a25956:	03000593          	li	a1,48
  a2595a:	8566                	mv	a0,s9
  a2595c:	c8bff0ef          	jal	ra,a255e6 <SecWriteMultiChar>
  a25960:	5792                	lw	a5,36(sp)
  a25962:	4a078c63          	beqz	a5,a25e1a <SecOutput+0x808>
  a25966:	57fd                	li	a5,-1
  a25968:	ca3e                	sw	a5,20(sp)
  a2596a:	47d2                	lw	a5,20(sp)
  a2596c:	d407c9e3          	bltz	a5,a256be <SecOutput+0xac>
  a25970:	57b2                	lw	a5,44(sp)
  a25972:	8b91                	andi	a5,a5,4
  a25974:	d40785e3          	beqz	a5,a256be <SecOutput+0xac>
  a25978:	4606                	lw	a2,64(sp)
  a2597a:	d4c052e3          	blez	a2,a256be <SecOutput+0xac>
  a2597e:	0854                	addi	a3,sp,20
  a25980:	02000593          	li	a1,32
  a25984:	8566                	mv	a0,s9
  a25986:	c61ff0ef          	jal	ra,a255e6 <SecWriteMultiChar>
  a2598a:	bb15                	j	a256be <SecOutput+0xac>
  a2598c:	06300713          	li	a4,99
  a25990:	0ce78c63          	beq	a5,a4,a25a68 <SecOutput+0x456>
  a25994:	06f76163          	bltu	a4,a5,a259f6 <SecOutput+0x3e4>
  a25998:	58d79bbb          	bnei	a5,88,a25906 <SecOutput+0x2f4>
  a2599c:	4741                	li	a4,16
  a2599e:	d43a                	sw	a4,40(sp)
  a259a0:	cc4a                	sw	s2,24(sp)
  a259a2:	5732                	lw	a4,44(sp)
  a259a4:	585785bb          	beqi	a5,88,a25afa <SecOutput+0x4e8>
  a259a8:	7057953b          	bnei	a5,112,a25afc <SecOutput+0x4ea>
  a259ac:	0000 4090 079f      	l.li	a5,0x4090
  a259b2:	8f5d                	or	a4,a4,a5
  a259b4:	4789                	li	a5,2
  a259b6:	c2be                	sw	a5,68(sp)
  a259b8:	77e1                	lui	a5,0xffff8
  a259ba:	8307c793          	xori	a5,a5,-2000
  a259be:	da02                	sw	zero,52(sp)
  a259c0:	d63a                	sw	a4,44(sp)
  a259c2:	04f11423          	sh	a5,72(sp)
  a259c6:	57b2                	lw	a5,44(sp)
  a259c8:	6725                	lui	a4,0x9
  a259ca:	8f7d                	and	a4,a4,a5
  a259cc:	16070a63          	beqz	a4,a25b40 <SecOutput+0x52e>
  a259d0:	041d                	addi	s0,s0,7
  a259d2:	ff847793          	andi	a5,s0,-8
  a259d6:	00878413          	addi	s0,a5,8 # ffff8008 <__data_load__+0xff5d05d4>
  a259da:	4384                	lw	s1,0(a5)
  a259dc:	0047ad03          	lw	s10,4(a5)
  a259e0:	a245                	j	a25b80 <SecOutput+0x56e>
  a259e2:	07000713          	li	a4,112
  a259e6:	fae78be3          	beq	a5,a4,a2599c <SecOutput+0x38a>
  a259ea:	02f76363          	bltu	a4,a5,a25a10 <SecOutput+0x3fe>
  a259ee:	6907823b          	beqi	a5,105,a259f6 <SecOutput+0x3e4>
  a259f2:	6fc7953b          	bnei	a5,111,a25906 <SecOutput+0x2f4>
  a259f6:	06900693          	li	a3,105
  a259fa:	5732                	lw	a4,44(sp)
  a259fc:	00d78663          	beq	a5,a3,a25a08 <SecOutput+0x3f6>
  a25a00:	10f6ed63          	bltu	a3,a5,a25b1a <SecOutput+0x508>
  a25a04:	64f790bb          	bnei	a5,100,a259c6 <SecOutput+0x3b4>
  a25a08:	04076713          	ori	a4,a4,64
  a25a0c:	d63a                	sw	a4,44(sp)
  a25a0e:	aa11                	j	a25b22 <SecOutput+0x510>
  a25a10:	75f789bb          	beqi	a5,117,a259f6 <SecOutput+0x3e4>
  a25a14:	78e7823b          	beqi	a5,120,a2599c <SecOutput+0x38a>
  a25a18:	73b79bbb          	bnei	a5,115,a25906 <SecOutput+0x2f4>
  a25a1c:	57b2                	lw	a5,44(sp)
  a25a1e:	4014                	lw	a3,0(s0)
  a25a20:	00440493          	addi	s1,s0,4
  a25a24:	ff77f713          	andi	a4,a5,-9
  a25a28:	d63a                	sw	a4,44(sp)
  a25a2a:	0000 0810 071f      	l.li	a4,0x810
  a25a30:	8ff9                	and	a5,a5,a4
  a25a32:	ce36                	sw	a3,28(sp)
  a25a34:	5752                	lw	a4,52(sp)
  a25a36:	ebd9                	bnez	a5,a25acc <SecOutput+0x4ba>
  a25a38:	e689                	bnez	a3,a25a42 <SecOutput+0x430>
  a25a3a:	00a0 24a4 079f      	l.li	a5,0xa024a4
  a25a40:	ce3e                	sw	a5,28(sp)
  a25a42:	4572                	lw	a0,28(sp)
  a25a44:	ff171bbb          	bnei	a4,-1,a25ab2 <SecOutput+0x4a0>
  a25a48:	b64fb0ef          	jal	ra,a20dac <strlen>
  a25a4c:	06055b63          	bgez	a0,a25ac2 <SecOutput+0x4b0>
  a25a50:	4501                	li	a0,0
  a25a52:	a885                	j	a25ac2 <SecOutput+0x4b0>
  a25a54:	57b2                	lw	a5,44(sp)
  a25a56:	6705                	lui	a4,0x1
  a25a58:	83070693          	addi	a3,a4,-2000 # 830 <__data_size__+0x754>
  a25a5c:	8efd                	and	a3,a3,a5
  a25a5e:	e689                	bnez	a3,a25a68 <SecOutput+0x456>
  a25a60:	80070713          	addi	a4,a4,-2048
  a25a64:	8fd9                	or	a5,a5,a4
  a25a66:	d63e                	sw	a5,44(sp)
  a25a68:	57b2                	lw	a5,44(sp)
  a25a6a:	4605                	li	a2,1
  a25a6c:	d032                	sw	a2,32(sp)
  a25a6e:	ff77f593          	andi	a1,a5,-9
  a25a72:	d62e                	sw	a1,44(sp)
  a25a74:	0000 0810 059f      	l.li	a1,0x810
  a25a7a:	8fed                	and	a5,a5,a1
  a25a7c:	00440713          	addi	a4,s0,4
  a25a80:	4014                	lw	a3,0(s0)
  a25a82:	c799                	beqz	a5,a25a90 <SecOutput+0x47e>
  a25a84:	00fc                	addi	a5,sp,76
  a25a86:	c6b6                	sw	a3,76(sp)
  a25a88:	ce3e                	sw	a5,28(sp)
  a25a8a:	d232                	sw	a2,36(sp)
  a25a8c:	843a                	mv	s0,a4
  a25a8e:	bda5                	j	a25906 <SecOutput+0x2f4>
  a25a90:	00fc                	addi	a5,sp,76
  a25a92:	04d10623          	sb	a3,76(sp)
  a25a96:	ce3e                	sw	a5,28(sp)
  a25a98:	d202                	sw	zero,36(sp)
  a25a9a:	bfcd                	j	a25a8c <SecOutput+0x47a>
  a25a9c:	57b2                	lw	a5,44(sp)
  a25a9e:	6705                	lui	a4,0x1
  a25aa0:	83070693          	addi	a3,a4,-2000 # 830 <__data_size__+0x754>
  a25aa4:	8efd                	and	a3,a3,a5
  a25aa6:	fabd                	bnez	a3,a25a1c <SecOutput+0x40a>
  a25aa8:	80070713          	addi	a4,a4,-2048
  a25aac:	8fd9                	or	a5,a5,a4
  a25aae:	d63e                	sw	a5,44(sp)
  a25ab0:	b7b5                	j	a25a1c <SecOutput+0x40a>
  a25ab2:	972a                	add	a4,a4,a0
  a25ab4:	87aa                	mv	a5,a0
  a25ab6:	00e78463          	beq	a5,a4,a25abe <SecOutput+0x4ac>
  a25aba:	2394                	lbu	a3,0(a5)
  a25abc:	e691                	bnez	a3,a25ac8 <SecOutput+0x4b6>
  a25abe:	40a78533          	sub	a0,a5,a0
  a25ac2:	d02a                	sw	a0,32(sp)
  a25ac4:	8426                	mv	s0,s1
  a25ac6:	b581                	j	a25906 <SecOutput+0x2f4>
  a25ac8:	0785                	addi	a5,a5,1
  a25aca:	b7f5                	j	a25ab6 <SecOutput+0x4a4>
  a25acc:	4785                	li	a5,1
  a25ace:	d23e                	sw	a5,36(sp)
  a25ad0:	e689                	bnez	a3,a25ada <SecOutput+0x4c8>
  a25ad2:	00a0 24ac 079f      	l.li	a5,0xa024ac
  a25ad8:	ce3e                	sw	a5,28(sp)
  a25ada:	46f2                	lw	a3,28(sp)
  a25adc:	4781                	li	a5,0
  a25ade:	00e78463          	beq	a5,a4,a25ae6 <SecOutput+0x4d4>
  a25ae2:	4290                	lw	a2,0(a3)
  a25ae4:	ea01                	bnez	a2,a25af4 <SecOutput+0x4e2>
  a25ae6:	20000737          	lui	a4,0x20000
  a25aea:	00e7e363          	bltu	a5,a4,a25af0 <SecOutput+0x4de>
  a25aee:	4781                	li	a5,0
  a25af0:	d03e                	sw	a5,32(sp)
  a25af2:	bfc9                	j	a25ac4 <SecOutput+0x4b2>
  a25af4:	0785                	addi	a5,a5,1
  a25af6:	0691                	addi	a3,a3,4
  a25af8:	b7dd                	j	a25ade <SecOutput+0x4cc>
  a25afa:	cc56                	sw	s5,24(sp)
  a25afc:	08077713          	andi	a4,a4,128
  a25b00:	ee070be3          	beqz	a4,a259f6 <SecOutput+0x3e4>
  a25b04:	03000713          	li	a4,48
  a25b08:	04e10423          	sb	a4,72(sp)
  a25b0c:	4762                	lw	a4,24(sp)
  a25b0e:	2b18                	lbu	a4,16(a4)
  a25b10:	04e104a3          	sb	a4,73(sp)
  a25b14:	4709                	li	a4,2
  a25b16:	c2ba                	sw	a4,68(sp)
  a25b18:	bdf9                	j	a259f6 <SecOutput+0x3e4>
  a25b1a:	6f07843b          	beqi	a5,111,a25b2a <SecOutput+0x518>
  a25b1e:	75a79a3b          	bnei	a5,117,a259c6 <SecOutput+0x3b4>
  a25b22:	47a9                	li	a5,10
  a25b24:	d43e                	sw	a5,40(sp)
  a25b26:	cc4a                	sw	s2,24(sp)
  a25b28:	bd79                	j	a259c6 <SecOutput+0x3b4>
  a25b2a:	47a1                	li	a5,8
  a25b2c:	d43e                	sw	a5,40(sp)
  a25b2e:	cc4a                	sw	s2,24(sp)
  a25b30:	08077793          	andi	a5,a4,128
  a25b34:	e80789e3          	beqz	a5,a259c6 <SecOutput+0x3b4>
  a25b38:	20076713          	ori	a4,a4,512
  a25b3c:	d63a                	sw	a4,44(sp)
  a25b3e:	b561                	j	a259c6 <SecOutput+0x3b4>
  a25b40:	0107f693          	andi	a3,a5,16
  a25b44:	0407f713          	andi	a4,a5,64
  a25b48:	c689                	beqz	a3,a25b52 <SecOutput+0x540>
  a25b4a:	4004                	lw	s1,0(s0)
  a25b4c:	0411                	addi	s0,s0,4
  a25b4e:	cb4d                	beqz	a4,a25c00 <SecOutput+0x5ee>
  a25b50:	a065                	j	a25bf8 <SecOutput+0x5e6>
  a25b52:	01279693          	slli	a3,a5,0x12
  a25b56:	0806d963          	bgez	a3,a25be8 <SecOutput+0x5d6>
  a25b5a:	4014                	lw	a3,0(s0)
  a25b5c:	4d01                	li	s10,0
  a25b5e:	0411                	addi	s0,s0,4
  a25b60:	0ff6f493          	andi	s1,a3,255
  a25b64:	cf11                	beqz	a4,a25b80 <SecOutput+0x56e>
  a25b66:	06e2                	slli	a3,a3,0x18
  a25b68:	86e1                	srai	a3,a3,0x18
  a25b6a:	0006db63          	bgez	a3,a25b80 <SecOutput+0x56e>
  a25b6e:	fff4c493          	not	s1,s1
  a25b72:	9c81                	uxtb	s1
  a25b74:	0485                	addi	s1,s1,1
  a25b76:	1007e793          	ori	a5,a5,256
  a25b7a:	41f4dd13          	srai	s10,s1,0x1f
  a25b7e:	d63e                	sw	a5,44(sp)
  a25b80:	57b2                	lw	a5,44(sp)
  a25b82:	8da6                	mv	s11,s1
  a25b84:	876a                	mv	a4,s10
  a25b86:	0407f693          	andi	a3,a5,64
  a25b8a:	ce89                	beqz	a3,a25ba4 <SecOutput+0x592>
  a25b8c:	000d5c63          	bgez	s10,a25ba4 <SecOutput+0x592>
  a25b90:	40900db3          	neg	s11,s1
  a25b94:	01b036b3          	snez	a3,s11
  a25b98:	41a00733          	neg	a4,s10
  a25b9c:	1007e793          	ori	a5,a5,256
  a25ba0:	8f15                	sub	a4,a4,a3
  a25ba2:	d63e                	sw	a5,44(sp)
  a25ba4:	56b2                	lw	a3,44(sp)
  a25ba6:	000497b7          	lui	a5,0x49
  a25baa:	8ff5                	and	a5,a5,a3
  a25bac:	e391                	bnez	a5,a25bb0 <SecOutput+0x59e>
  a25bae:	4701                	li	a4,0
  a25bb0:	24c10813          	addi	a6,sp,588
  a25bb4:	ce42                	sw	a6,28(sp)
  a25bb6:	00ede7b3          	or	a5,s11,a4
  a25bba:	e3c1                	bnez	a5,a25c3a <SecOutput+0x628>
  a25bbc:	c282                	sw	zero,68(sp)
  a25bbe:	d002                	sw	zero,32(sp)
  a25bc0:	5752                	lw	a4,52(sp)
  a25bc2:	4685                	li	a3,1
  a25bc4:	00074f63          	bltz	a4,a25be2 <SecOutput+0x5d0>
  a25bc8:	57b2                	lw	a5,44(sp)
  a25bca:	01179693          	slli	a3,a5,0x11
  a25bce:	0006c463          	bltz	a3,a25bd6 <SecOutput+0x5c4>
  a25bd2:	9bdd                	andi	a5,a5,-9
  a25bd4:	d63e                	sw	a5,44(sp)
  a25bd6:	20000793          	li	a5,512
  a25bda:	00e7d363          	bge	a5,a4,a25be0 <SecOutput+0x5ce>
  a25bde:	da3e                	sw	a5,52(sp)
  a25be0:	56d2                	lw	a3,52(sp)
  a25be2:	03000613          	li	a2,48
  a25be6:	aa69                	j	a25d80 <SecOutput+0x76e>
  a25be8:	0207f693          	andi	a3,a5,32
  a25bec:	ce81                	beqz	a3,a25c04 <SecOutput+0x5f2>
  a25bee:	4004                	lw	s1,0(s0)
  a25bf0:	0411                	addi	s0,s0,4
  a25bf2:	c711                	beqz	a4,a25bfe <SecOutput+0x5ec>
  a25bf4:	04c2                	slli	s1,s1,0x10
  a25bf6:	84c1                	srai	s1,s1,0x10
  a25bf8:	41f4dd13          	srai	s10,s1,0x1f
  a25bfc:	b751                	j	a25b80 <SecOutput+0x56e>
  a25bfe:	9ca1                	uxth	s1
  a25c00:	4d01                	li	s10,0
  a25c02:	bfbd                	j	a25b80 <SecOutput+0x56e>
  a25c04:	00f79693          	slli	a3,a5,0xf
  a25c08:	0006d763          	bgez	a3,a25c16 <SecOutput+0x604>
  a25c0c:	4004                	lw	s1,0(s0)
  a25c0e:	0411                	addi	s0,s0,4
  a25c10:	41f4dd13          	srai	s10,s1,0x1f
  a25c14:	b7b5                	j	a25b80 <SecOutput+0x56e>
  a25c16:	00e79693          	slli	a3,a5,0xe
  a25c1a:	0006db63          	bgez	a3,a25c30 <SecOutput+0x61e>
  a25c1e:	4004                	lw	s1,0(s0)
  a25c20:	00440793          	addi	a5,s0,4
  a25c24:	41f4dd13          	srai	s10,s1,0x1f
  a25c28:	e311                	bnez	a4,a25c2c <SecOutput+0x61a>
  a25c2a:	4d01                	li	s10,0
  a25c2c:	843e                	mv	s0,a5
  a25c2e:	bf89                	j	a25b80 <SecOutput+0x56e>
  a25c30:	00d79693          	slli	a3,a5,0xd
  a25c34:	f006dbe3          	bgez	a3,a25b4a <SecOutput+0x538>
  a25c38:	bb61                	j	a259d0 <SecOutput+0x3be>
  a25c3a:	57a2                	lw	a5,40(sp)
  a25c3c:	ef49                	bnez	a4,a25cd6 <SecOutput+0x6c4>
  a25c3e:	0a1791bb          	bnei	a5,10,a25c84 <SecOutput+0x672>
  a25c42:	46a9                	li	a3,10
  a25c44:	4625                	li	a2,9
  a25c46:	4772                	lw	a4,28(sp)
  a25c48:	fff70793          	addi	a5,a4,-1 # 1fffffff <__data_load__+0x1f5d85cb>
  a25c4c:	ce3e                	sw	a5,28(sp)
  a25c4e:	02ddf7b3          	remu	a5,s11,a3
  a25c52:	97ca                	add	a5,a5,s2
  a25c54:	239c                	lbu	a5,0(a5)
  a25c56:	fef70fa3          	sb	a5,-1(a4)
  a25c5a:	002dd793          	srli	a5,s11,0x2
  a25c5e:	43b7879b          	addshf	a5,a5,s11,srl,1
  a25c62:	48f7879b          	addshf	a5,a5,a5,srl,4
  a25c66:	50f7879b          	addshf	a5,a5,a5,srl,8
  a25c6a:	60f7879b          	addshf	a5,a5,a5,srl,16
  a25c6e:	838d                	srli	a5,a5,0x3
  a25c70:	00279513          	slli	a0,a5,0x2
  a25c74:	953e                	add	a0,a0,a5
  a25c76:	02ad951b          	subshf	a0,s11,a0,sll,1
  a25c7a:	04a67c63          	bgeu	a2,a0,a25cd2 <SecOutput+0x6c0>
  a25c7e:	0785                	addi	a5,a5,1 # 49001 <g_intheap_size+0x2faa1>
  a25c80:	8dbe                	mv	s11,a5
  a25c82:	b7d1                	j	a25c46 <SecOutput+0x634>
  a25c84:	100789bb          	beqi	a5,16,a25caa <SecOutput+0x698>
  a25c88:	0817903b          	bnei	a5,8,a25cc8 <SecOutput+0x6b6>
  a25c8c:	4772                	lw	a4,28(sp)
  a25c8e:	fff70793          	addi	a5,a4,-1
  a25c92:	ce3e                	sw	a5,28(sp)
  a25c94:	007df793          	andi	a5,s11,7
  a25c98:	97ca                	add	a5,a5,s2
  a25c9a:	239c                	lbu	a5,0(a5)
  a25c9c:	003ddd93          	srli	s11,s11,0x3
  a25ca0:	fef70fa3          	sb	a5,-1(a4)
  a25ca4:	fe0d94e3          	bnez	s11,a25c8c <SecOutput+0x67a>
  a25ca8:	a005                	j	a25cc8 <SecOutput+0x6b6>
  a25caa:	4772                	lw	a4,28(sp)
  a25cac:	00fdf693          	andi	a3,s11,15
  a25cb0:	004ddd93          	srli	s11,s11,0x4
  a25cb4:	fff70793          	addi	a5,a4,-1
  a25cb8:	ce3e                	sw	a5,28(sp)
  a25cba:	47e2                	lw	a5,24(sp)
  a25cbc:	97b6                	add	a5,a5,a3
  a25cbe:	239c                	lbu	a5,0(a5)
  a25cc0:	fef70fa3          	sb	a5,-1(a4)
  a25cc4:	fe0d93e3          	bnez	s11,a25caa <SecOutput+0x698>
  a25cc8:	47f2                	lw	a5,28(sp)
  a25cca:	40f80833          	sub	a6,a6,a5
  a25cce:	d042                	sw	a6,32(sp)
  a25cd0:	bdc5                	j	a25bc0 <SecOutput+0x5ae>
  a25cd2:	f7dd                	bnez	a5,a25c80 <SecOutput+0x66e>
  a25cd4:	bfd5                	j	a25cc8 <SecOutput+0x6b6>
  a25cd6:	0a078cbb          	beqi	a5,10,a25d08 <SecOutput+0x6f6>
  a25cda:	10178b3b          	beqi	a5,16,a25d46 <SecOutput+0x734>
  a25cde:	08f79abb          	bnei	a5,8,a25cc8 <SecOutput+0x6b6>
  a25ce2:	46f2                	lw	a3,28(sp)
  a25ce4:	fff68793          	addi	a5,a3,-1
  a25ce8:	ce3e                	sw	a5,28(sp)
  a25cea:	007df793          	andi	a5,s11,7
  a25cee:	97ca                	add	a5,a5,s2
  a25cf0:	239c                	lbu	a5,0(a5)
  a25cf2:	003ddd93          	srli	s11,s11,0x3
  a25cf6:	3aedad9b          	orshf	s11,s11,a4,sll,29
  a25cfa:	830d                	srli	a4,a4,0x3
  a25cfc:	fef68fa3          	sb	a5,-1(a3)
  a25d00:	00ede7b3          	or	a5,s11,a4
  a25d04:	fff9                	bnez	a5,a25ce2 <SecOutput+0x6d0>
  a25d06:	b7c9                	j	a25cc8 <SecOutput+0x6b6>
  a25d08:	47f2                	lw	a5,28(sp)
  a25d0a:	4629                	li	a2,10
  a25d0c:	856e                	mv	a0,s11
  a25d0e:	fff78693          	addi	a3,a5,-1
  a25d12:	ce36                	sw	a3,28(sp)
  a25d14:	85ba                	mv	a1,a4
  a25d16:	4681                	li	a3,0
  a25d18:	c642                	sw	a6,12(sp)
  a25d1a:	c43e                	sw	a5,8(sp)
  a25d1c:	c23a                	sw	a4,4(sp)
  a25d1e:	923fa0ef          	jal	ra,a20640 <__umoddi3>
  a25d22:	954a                	add	a0,a0,s2
  a25d24:	2114                	lbu	a3,0(a0)
  a25d26:	4712                	lw	a4,4(sp)
  a25d28:	47a2                	lw	a5,8(sp)
  a25d2a:	856e                	mv	a0,s11
  a25d2c:	85ba                	mv	a1,a4
  a25d2e:	fed78fa3          	sb	a3,-1(a5)
  a25d32:	4629                	li	a2,10
  a25d34:	4681                	li	a3,0
  a25d36:	907fa0ef          	jal	ra,a2063c <__udivdi3>
  a25d3a:	872e                	mv	a4,a1
  a25d3c:	8dc9                	or	a1,a1,a0
  a25d3e:	8daa                	mv	s11,a0
  a25d40:	4832                	lw	a6,12(sp)
  a25d42:	f1f9                	bnez	a1,a25d08 <SecOutput+0x6f6>
  a25d44:	b751                	j	a25cc8 <SecOutput+0x6b6>
  a25d46:	46f2                	lw	a3,28(sp)
  a25d48:	00fdf613          	andi	a2,s11,15
  a25d4c:	004ddd93          	srli	s11,s11,0x4
  a25d50:	fff68793          	addi	a5,a3,-1
  a25d54:	ce3e                	sw	a5,28(sp)
  a25d56:	47e2                	lw	a5,24(sp)
  a25d58:	38edad9b          	orshf	s11,s11,a4,sll,28
  a25d5c:	8311                	srli	a4,a4,0x4
  a25d5e:	97b2                	add	a5,a5,a2
  a25d60:	239c                	lbu	a5,0(a5)
  a25d62:	fef68fa3          	sb	a5,-1(a3)
  a25d66:	00ede7b3          	or	a5,s11,a4
  a25d6a:	fff1                	bnez	a5,a25d46 <SecOutput+0x734>
  a25d6c:	bfb1                	j	a25cc8 <SecOutput+0x6b6>
  a25d6e:	47f2                	lw	a5,28(sp)
  a25d70:	fff78713          	addi	a4,a5,-1
  a25d74:	ce3a                	sw	a4,28(sp)
  a25d76:	fec78fa3          	sb	a2,-1(a5)
  a25d7a:	5782                	lw	a5,32(sp)
  a25d7c:	0785                	addi	a5,a5,1
  a25d7e:	d03e                	sw	a5,32(sp)
  a25d80:	5702                	lw	a4,32(sp)
  a25d82:	fed746e3          	blt	a4,a3,a25d6e <SecOutput+0x75c>
  a25d86:	57b2                	lw	a5,44(sp)
  a25d88:	2007f793          	andi	a5,a5,512
  a25d8c:	c385                	beqz	a5,a25dac <SecOutput+0x79a>
  a25d8e:	47f2                	lw	a5,28(sp)
  a25d90:	c701                	beqz	a4,a25d98 <SecOutput+0x786>
  a25d92:	2398                	lbu	a4,0(a5)
  a25d94:	3007063b          	beqi	a4,48,a25dac <SecOutput+0x79a>
  a25d98:	fff78713          	addi	a4,a5,-1
  a25d9c:	ce3a                	sw	a4,28(sp)
  a25d9e:	03000713          	li	a4,48
  a25da2:	fee78fa3          	sb	a4,-1(a5)
  a25da6:	5782                	lw	a5,32(sp)
  a25da8:	0785                	addi	a5,a5,1
  a25daa:	d03e                	sw	a5,32(sp)
  a25dac:	57b2                	lw	a5,44(sp)
  a25dae:	0407f713          	andi	a4,a5,64
  a25db2:	cb11                	beqz	a4,a25dc6 <SecOutput+0x7b4>
  a25db4:	1007f713          	andi	a4,a5,256
  a25db8:	c70d                	beqz	a4,a25de2 <SecOutput+0x7d0>
  a25dba:	02d00713          	li	a4,45
  a25dbe:	04e10423          	sb	a4,72(sp)
  a25dc2:	4705                	li	a4,1
  a25dc4:	c2ba                	sw	a4,68(sp)
  a25dc6:	01a4e4b3          	or	s1,s1,s10
  a25dca:	b2049ee3          	bnez	s1,a25906 <SecOutput+0x2f4>
  a25dce:	01179713          	slli	a4,a5,0x11
  a25dd2:	b2075ae3          	bgez	a4,a25906 <SecOutput+0x2f4>
  a25dd6:	4715                	li	a4,5
  a25dd8:	9bdd                	andi	a5,a5,-9
  a25dda:	ce62                	sw	s8,28(sp)
  a25ddc:	d03a                	sw	a4,32(sp)
  a25dde:	d63e                	sw	a5,44(sp)
  a25de0:	b61d                	j	a25906 <SecOutput+0x2f4>
  a25de2:	0017f713          	andi	a4,a5,1
  a25de6:	c701                	beqz	a4,a25dee <SecOutput+0x7dc>
  a25de8:	02b00713          	li	a4,43
  a25dec:	bfc9                	j	a25dbe <SecOutput+0x7ac>
  a25dee:	0027f713          	andi	a4,a5,2
  a25df2:	db71                	beqz	a4,a25dc6 <SecOutput+0x7b4>
  a25df4:	02000713          	li	a4,32
  a25df8:	b7d9                	j	a25dbe <SecOutput+0x7ac>
  a25dfa:	004ca703          	lw	a4,4(s9)
  a25dfe:	0307c583          	lbu	a1,48(a5)
  a25e02:	0785                	addi	a5,a5,1
  a25e04:	a30c                	sb	a1,0(a4)
  a25e06:	004ca703          	lw	a4,4(s9)
  a25e0a:	0705                	addi	a4,a4,1
  a25e0c:	00eca223          	sw	a4,4(s9)
  a25e10:	b2f612e3          	bne	a2,a5,a25934 <SecOutput+0x322>
  a25e14:	47d2                	lw	a5,20(sp)
  a25e16:	97b6                	add	a5,a5,a3
  a25e18:	b635                	j	a25944 <SecOutput+0x332>
  a25e1a:	45f2                	lw	a1,28(sp)
  a25e1c:	5482                	lw	s1,32(sp)
  a25e1e:	000ca703          	lw	a4,0(s9)
  a25e22:	87ae                	mv	a5,a1
  a25e24:	009586b3          	add	a3,a1,s1
  a25e28:	06974963          	blt	a4,s1,a25e9a <SecOutput+0x888>
  a25e2c:	0c04ddbb          	bgei	s1,12,a25e62 <SecOutput+0x850>
  a25e30:	87ae                	mv	a5,a1
  a25e32:	a819                	j	a25e48 <SecOutput+0x836>
  a25e34:	004ca703          	lw	a4,4(s9)
  a25e38:	2394                	lbu	a3,0(a5)
  a25e3a:	0785                	addi	a5,a5,1
  a25e3c:	a314                	sb	a3,0(a4)
  a25e3e:	004ca703          	lw	a4,4(s9)
  a25e42:	0705                	addi	a4,a4,1
  a25e44:	00eca223          	sw	a4,4(s9)
  a25e48:	40b78733          	sub	a4,a5,a1
  a25e4c:	fe9744e3          	blt	a4,s1,a25e34 <SecOutput+0x822>
  a25e50:	000ca783          	lw	a5,0(s9)
  a25e54:	8f85                	sub	a5,a5,s1
  a25e56:	00fca023          	sw	a5,0(s9)
  a25e5a:	47d2                	lw	a5,20(sp)
  a25e5c:	94be                	add	s1,s1,a5
  a25e5e:	ca26                	sw	s1,20(sp)
  a25e60:	b629                	j	a2596a <SecOutput+0x358>
  a25e62:	004ca503          	lw	a0,4(s9)
  a25e66:	8626                	mv	a2,s1
  a25e68:	c8bfa0ef          	jal	ra,a20af2 <memcpy>
  a25e6c:	004ca783          	lw	a5,4(s9)
  a25e70:	97a6                	add	a5,a5,s1
  a25e72:	00fca223          	sw	a5,4(s9)
  a25e76:	bfe9                	j	a25e50 <SecOutput+0x83e>
  a25e78:	000ca703          	lw	a4,0(s9)
  a25e7c:	177d                	addi	a4,a4,-1
  a25e7e:	00eca023          	sw	a4,0(s9)
  a25e82:	ae0742e3          	bltz	a4,a25966 <SecOutput+0x354>
  a25e86:	004ca703          	lw	a4,4(s9)
  a25e8a:	2390                	lbu	a2,0(a5)
  a25e8c:	0785                	addi	a5,a5,1
  a25e8e:	a310                	sb	a2,0(a4)
  a25e90:	004ca703          	lw	a4,4(s9)
  a25e94:	0705                	addi	a4,a4,1
  a25e96:	00eca223          	sw	a4,4(s9)
  a25e9a:	40f68733          	sub	a4,a3,a5
  a25e9e:	fce04de3          	bgtz	a4,a25e78 <SecOutput+0x866>
  a25ea2:	bf65                	j	a25e5a <SecOutput+0x848>

00a25ea4 <SecVsnprintfImpl>:
  a25ea4:	8138                	push	{ra,s0-s1},-32
  a25ea6:	84ae                	mv	s1,a1
  a25ea8:	842a                	mv	s0,a0
  a25eaa:	85b2                	mv	a1,a2
  a25eac:	c62a                	sw	a0,12(sp)
  a25eae:	8636                	mv	a2,a3
  a25eb0:	0028                	addi	a0,sp,8
  a25eb2:	c426                	sw	s1,8(sp)
  a25eb4:	f5eff0ef          	jal	ra,a25612 <SecOutput>
  a25eb8:	00054b63          	bltz	a0,a25ece <SecVsnprintfImpl+0x2a>
  a25ebc:	47a2                	lw	a5,8(sp)
  a25ebe:	17fd                	addi	a5,a5,-1
  a25ec0:	c43e                	sw	a5,8(sp)
  a25ec2:	0007c663          	bltz	a5,a25ece <SecVsnprintfImpl+0x2a>
  a25ec6:	47b2                	lw	a5,12(sp)
  a25ec8:	00078023          	sb	zero,0(a5)
  a25ecc:	8134                	popret	{ra,s0-s1},32
  a25ece:	47a2                	lw	a5,8(sp)
  a25ed0:	0007d763          	bgez	a5,a25ede <SecVsnprintfImpl+0x3a>
  a25ed4:	9426                	add	s0,s0,s1
  a25ed6:	fe040fa3          	sb	zero,-1(s0)
  a25eda:	5579                	li	a0,-2
  a25edc:	bfc5                	j	a25ecc <SecVsnprintfImpl+0x28>
  a25ede:	00040023          	sb	zero,0(s0)
  a25ee2:	557d                	li	a0,-1
  a25ee4:	b7e5                	j	a25ecc <SecVsnprintfImpl+0x28>

00a25ee6 <vsnprintf_s>:
  a25ee6:	8028                	push	{ra,s0},-16
  a25ee8:	8832                	mv	a6,a2
  a25eea:	842a                	mv	s0,a0
  a25eec:	87ae                	mv	a5,a1
  a25eee:	8636                	mv	a2,a3
  a25ef0:	ca8d                	beqz	a3,a25f22 <vsnprintf_s+0x3c>
  a25ef2:	e119                	bnez	a0,a25ef8 <vsnprintf_s+0x12>
  a25ef4:	557d                	li	a0,-1
  a25ef6:	8024                	popret	{ra,s0},16
  a25ef8:	ddf5                	beqz	a1,a25ef4 <vsnprintf_s+0xe>
  a25efa:	fe05cde3          	bltz	a1,a25ef4 <vsnprintf_s+0xe>
  a25efe:	800008b7          	lui	a7,0x80000
  a25f02:	ffe8c893          	xori	a7,a7,-2
  a25f06:	0308e063          	bltu	a7,a6,a25f26 <vsnprintf_s+0x40>
  a25f0a:	86ba                	mv	a3,a4
  a25f0c:	02b87263          	bgeu	a6,a1,a25f30 <vsnprintf_s+0x4a>
  a25f10:	00180593          	addi	a1,a6,1
  a25f14:	f91ff0ef          	jal	ra,a25ea4 <SecVsnprintfImpl>
  a25f18:	fef5073b          	beqi	a0,-2,a25ef4 <vsnprintf_s+0xe>
  a25f1c:	fc055de3          	bgez	a0,a25ef6 <vsnprintf_s+0x10>
  a25f20:	a029                	j	a25f2a <vsnprintf_s+0x44>
  a25f22:	d969                	beqz	a0,a25ef4 <vsnprintf_s+0xe>
  a25f24:	d9e1                	beqz	a1,a25ef4 <vsnprintf_s+0xe>
  a25f26:	fc07c7e3          	bltz	a5,a25ef4 <vsnprintf_s+0xe>
  a25f2a:	00040023          	sb	zero,0(s0)
  a25f2e:	b7d9                	j	a25ef4 <vsnprintf_s+0xe>
  a25f30:	f75ff0ef          	jal	ra,a25ea4 <SecVsnprintfImpl>
  a25f34:	b7e5                	j	a25f1c <vsnprintf_s+0x36>
  a25f36:	0000                	unimp
  a25f38:	04f9                	addi	s1,s1,30
  a25f3a:	0000                	unimp
  a25f3c:	00000003          	lb	zero,0(zero) # 0 <__data_size__-0xdc>
	...

00a25f50 <excp_vect_table>:
  a25f50:	51d4                	lw	a3,36(a1)
  a25f52:	00a2                	slli	ra,ra,0x8
  a25f54:	51ea                	lw	gp,184(sp)
  a25f56:	00a2                	slli	ra,ra,0x8
  a25f58:	5200                	lw	s0,32(a2)
  a25f5a:	00a2                	slli	ra,ra,0x8
  a25f5c:	52b0                	lw	a2,96(a3)
  a25f5e:	00a2                	slli	ra,ra,0x8
  a25f60:	5216                	lw	tp,100(sp)
  a25f62:	00a2                	slli	ra,ra,0x8
  a25f64:	522c                	lw	a1,96(a2)
  a25f66:	00a2                	slli	ra,ra,0x8
  a25f68:	5242                	lw	tp,48(sp)
  a25f6a:	00a2                	slli	ra,ra,0x8
  a25f6c:	5258                	lw	a4,36(a2)
  a25f6e:	00a2                	slli	ra,ra,0x8
  a25f70:	526e                	lw	tp,248(sp)
  a25f72:	00a2                	slli	ra,ra,0x8
  a25f74:	5284                	lw	s1,32(a3)
  a25f76:	00a2                	slli	ra,ra,0x8
  a25f78:	51be                	lw	gp,236(sp)
  a25f7a:	00a2                	slli	ra,ra,0x8
  a25f7c:	529a                	lw	t0,164(sp)
  a25f7e:	00a2                	slli	ra,ra,0x8
  a25f80:	52c6                	lw	t0,112(sp)
  a25f82:	00a2                	slli	ra,ra,0x8
  a25f84:	52dc                	lw	a5,36(a3)
  a25f86:	00a2                	slli	ra,ra,0x8
  a25f88:	51be                	lw	gp,236(sp)
  a25f8a:	00a2                	slli	ra,ra,0x8
  a25f8c:	52f2                	lw	t0,60(sp)
  a25f8e:	00a2                	slli	ra,ra,0x8
  a25f90:	5308                	lw	a0,32(a4)
  a25f92:	00a2                	slli	ra,ra,0x8
  a25f94:	531e                	lw	t1,228(sp)
  a25f96:	00a2                	slli	ra,ra,0x8

00a25f98 <excp_vect_table_end>:
	...

00a25fa0 <trap_entry>:
  a25fa0:	7175                	addi	sp,sp,-144
  a25fa2:	d06e                	sw	s11,32(sp)
  a25fa4:	d26a                	sw	s10,36(sp)
  a25fa6:	d466                	sw	s9,40(sp)
  a25fa8:	d662                	sw	s8,44(sp)
  a25faa:	d85e                	sw	s7,48(sp)
  a25fac:	da5a                	sw	s6,52(sp)
  a25fae:	dc56                	sw	s5,56(sp)
  a25fb0:	de52                	sw	s4,60(sp)
  a25fb2:	c0ce                	sw	s3,64(sp)
  a25fb4:	c2ca                	sw	s2,68(sp)
  a25fb6:	c4a6                	sw	s1,72(sp)
  a25fb8:	c6a2                	sw	s0,76(sp)
  a25fba:	c8fe                	sw	t6,80(sp)
  a25fbc:	cafa                	sw	t5,84(sp)
  a25fbe:	ccf6                	sw	t4,88(sp)
  a25fc0:	cef2                	sw	t3,92(sp)
  a25fc2:	d0c6                	sw	a7,96(sp)
  a25fc4:	d2c2                	sw	a6,100(sp)
  a25fc6:	d4be                	sw	a5,104(sp)
  a25fc8:	d6ba                	sw	a4,108(sp)
  a25fca:	d8b6                	sw	a3,112(sp)
  a25fcc:	dab2                	sw	a2,116(sp)
  a25fce:	dcae                	sw	a1,120(sp)
  a25fd0:	deaa                	sw	a0,124(sp)
  a25fd2:	c11e                	sw	t2,128(sp)
  a25fd4:	c31a                	sw	t1,132(sp)
  a25fd6:	c516                	sw	t0,136(sp)
  a25fd8:	c706                	sw	ra,140(sp)
  a25fda:	fc202a73          	csrr	s4,0xfc2
  a25fde:	c052                	sw	s4,0(sp)
  a25fe0:	342029f3          	csrr	s3,mcause
  a25fe4:	c24e                	sw	s3,4(sp)
  a25fe6:	34302973          	csrr	s2,mtval
  a25fea:	c44a                	sw	s2,8(sp)
  a25fec:	c60e                	sw	gp,12(sp)
  a25fee:	300024f3          	csrr	s1,mstatus
  a25ff2:	c826                	sw	s1,16(sp)
  a25ff4:	34102473          	csrr	s0,mepc
  a25ff8:	ca22                	sw	s0,20(sp)
  a25ffa:	cc12                	sw	tp,24(sp)
  a25ffc:	ce0a                	sw	sp,28(sp)
  a25ffe:	30047073          	csrci	mstatus,8
  a26002:	34011073          	csrw	mscratch,sp
  a26006:	fffdc117          	auipc	sp,0xfffdc
  a2600a:	3fa10113          	addi	sp,sp,1018 # a02400 <g_efuse_clock_period>
  a2600e:	42a1                	li	t0,8
  a26010:	00599463          	bne	s3,t0,a26018 <trap_entry+0x78>
  a26014:	ddefa06f          	j	a205f2 <handle_syscall>
  a26018:	00299293          	slli	t0,s3,0x2
  a2601c:	00000317          	auipc	t1,0x0
  a26020:	f3430313          	addi	t1,t1,-204 # a25f50 <excp_vect_table>
  a26024:	00000397          	auipc	t2,0x0
  a26028:	f7438393          	addi	t2,t2,-140 # a25f98 <excp_vect_table_end>
  a2602c:	34002573          	csrr	a0,mscratch
  a26030:	929a                	add	t0,t0,t1
  a26032:	0472ff63          	bgeu	t0,t2,a26090 <trap_entry+0xf0>
  a26036:	0002a283          	lw	t0,0(t0)
  a2603a:	ef1fe0ef          	jal	ra,a24f2a <do_hard_fault_handler>
  a2603e:	34002173          	csrr	sp,mscratch
  a26042:	6289                	lui	t0,0x2
  a26044:	80028293          	addi	t0,t0,-2048 # 1800 <ccause+0x83e>
  a26048:	3002a073          	csrs	mstatus,t0
  a2604c:	42d2                	lw	t0,20(sp)
  a2604e:	34129073          	csrw	mepc,t0
  a26052:	5d82                	lw	s11,32(sp)
  a26054:	5d12                	lw	s10,36(sp)
  a26056:	5ca2                	lw	s9,40(sp)
  a26058:	5c32                	lw	s8,44(sp)
  a2605a:	5bc2                	lw	s7,48(sp)
  a2605c:	5b52                	lw	s6,52(sp)
  a2605e:	5ae2                	lw	s5,56(sp)
  a26060:	5a72                	lw	s4,60(sp)
  a26062:	4986                	lw	s3,64(sp)
  a26064:	4916                	lw	s2,68(sp)
  a26066:	44a6                	lw	s1,72(sp)
  a26068:	4436                	lw	s0,76(sp)
  a2606a:	4fc6                	lw	t6,80(sp)
  a2606c:	4f56                	lw	t5,84(sp)
  a2606e:	4ee6                	lw	t4,88(sp)
  a26070:	4e76                	lw	t3,92(sp)
  a26072:	5886                	lw	a7,96(sp)
  a26074:	5816                	lw	a6,100(sp)
  a26076:	57a6                	lw	a5,104(sp)
  a26078:	5736                	lw	a4,108(sp)
  a2607a:	56c6                	lw	a3,112(sp)
  a2607c:	5656                	lw	a2,116(sp)
  a2607e:	55e6                	lw	a1,120(sp)
  a26080:	5576                	lw	a0,124(sp)
  a26082:	438a                	lw	t2,128(sp)
  a26084:	431a                	lw	t1,132(sp)
  a26086:	42aa                	lw	t0,136(sp)
  a26088:	40ba                	lw	ra,140(sp)
  a2608a:	6149                	addi	sp,sp,144
  a2608c:	30200073          	mret
  a26090:	92eff06f          	j	a251be <do_trap_unknown>
	...

00a2609c <trap_vector>:
  a2609c:	f05ff06f          	j	a25fa0 <trap_entry>
  a260a0:	a94ff06f          	j	a25334 <default_handler>
  a260a4:	a90ff06f          	j	a25334 <default_handler>
  a260a8:	a8cff06f          	j	a25334 <default_handler>
  a260ac:	a88ff06f          	j	a25334 <default_handler>
  a260b0:	a84ff06f          	j	a25334 <default_handler>
  a260b4:	a80ff06f          	j	a25334 <default_handler>
  a260b8:	a7cff06f          	j	a25334 <default_handler>
  a260bc:	a78ff06f          	j	a25334 <default_handler>
  a260c0:	a74ff06f          	j	a25334 <default_handler>
  a260c4:	a70ff06f          	j	a25334 <default_handler>
  a260c8:	a6cff06f          	j	a25334 <default_handler>
  a260cc:	1700006f          	j	a2623c <nmi_vector>
  a260d0:	a64ff06f          	j	a25334 <default_handler>
  a260d4:	a60ff06f          	j	a25334 <default_handler>
  a260d8:	a5cff06f          	j	a25334 <default_handler>
  a260dc:	a58ff06f          	j	a25334 <default_handler>
  a260e0:	a54ff06f          	j	a25334 <default_handler>
  a260e4:	a50ff06f          	j	a25334 <default_handler>
  a260e8:	a4cff06f          	j	a25334 <default_handler>
  a260ec:	a48ff06f          	j	a25334 <default_handler>
  a260f0:	a44ff06f          	j	a25334 <default_handler>
  a260f4:	a40ff06f          	j	a25334 <default_handler>
  a260f8:	a3cff06f          	j	a25334 <default_handler>
  a260fc:	a38ff06f          	j	a25334 <default_handler>
  a26100:	a34ff06f          	j	a25334 <default_handler>
  a26104:	2000006f          	j	a26304 <default_interrupt0_handler>
  a26108:	2a80006f          	j	a263b0 <default_interrupt1_handler>
  a2610c:	3500006f          	j	a2645c <default_interrupt2_handler>
  a26110:	3f80006f          	j	a26508 <default_interrupt3_handler>
  a26114:	4a00006f          	j	a265b4 <default_interrupt4_handler>
  a26118:	5480006f          	j	a26660 <default_interrupt5_handler>
  a2611c:	5f00006f          	j	a2670c <default_local_interrupt_handler>
  a26120:	5ec0006f          	j	a2670c <default_local_interrupt_handler>
  a26124:	5e80006f          	j	a2670c <default_local_interrupt_handler>
  a26128:	5e40006f          	j	a2670c <default_local_interrupt_handler>
  a2612c:	5e00006f          	j	a2670c <default_local_interrupt_handler>
  a26130:	5dc0006f          	j	a2670c <default_local_interrupt_handler>
  a26134:	5d80006f          	j	a2670c <default_local_interrupt_handler>
  a26138:	5d40006f          	j	a2670c <default_local_interrupt_handler>
  a2613c:	5d00006f          	j	a2670c <default_local_interrupt_handler>
  a26140:	5cc0006f          	j	a2670c <default_local_interrupt_handler>
  a26144:	5c80006f          	j	a2670c <default_local_interrupt_handler>
  a26148:	5c40006f          	j	a2670c <default_local_interrupt_handler>
  a2614c:	5c00006f          	j	a2670c <default_local_interrupt_handler>
  a26150:	5bc0006f          	j	a2670c <default_local_interrupt_handler>
  a26154:	5b80006f          	j	a2670c <default_local_interrupt_handler>
  a26158:	5b40006f          	j	a2670c <default_local_interrupt_handler>
  a2615c:	5b00006f          	j	a2670c <default_local_interrupt_handler>
  a26160:	5ac0006f          	j	a2670c <default_local_interrupt_handler>
  a26164:	5a80006f          	j	a2670c <default_local_interrupt_handler>
  a26168:	5a40006f          	j	a2670c <default_local_interrupt_handler>
  a2616c:	5a00006f          	j	a2670c <default_local_interrupt_handler>
  a26170:	59c0006f          	j	a2670c <default_local_interrupt_handler>
  a26174:	5980006f          	j	a2670c <default_local_interrupt_handler>
  a26178:	5940006f          	j	a2670c <default_local_interrupt_handler>
  a2617c:	5900006f          	j	a2670c <default_local_interrupt_handler>
  a26180:	58c0006f          	j	a2670c <default_local_interrupt_handler>
  a26184:	5880006f          	j	a2670c <default_local_interrupt_handler>
  a26188:	5840006f          	j	a2670c <default_local_interrupt_handler>
  a2618c:	5800006f          	j	a2670c <default_local_interrupt_handler>
  a26190:	57c0006f          	j	a2670c <default_local_interrupt_handler>
  a26194:	5780006f          	j	a2670c <default_local_interrupt_handler>
  a26198:	5740006f          	j	a2670c <default_local_interrupt_handler>
  a2619c:	5700006f          	j	a2670c <default_local_interrupt_handler>
  a261a0:	56c0006f          	j	a2670c <default_local_interrupt_handler>
  a261a4:	5680006f          	j	a2670c <default_local_interrupt_handler>
  a261a8:	5640006f          	j	a2670c <default_local_interrupt_handler>
  a261ac:	5600006f          	j	a2670c <default_local_interrupt_handler>
  a261b0:	55c0006f          	j	a2670c <default_local_interrupt_handler>
  a261b4:	5580006f          	j	a2670c <default_local_interrupt_handler>
  a261b8:	5540006f          	j	a2670c <default_local_interrupt_handler>
  a261bc:	5500006f          	j	a2670c <default_local_interrupt_handler>
  a261c0:	54c0006f          	j	a2670c <default_local_interrupt_handler>
  a261c4:	5480006f          	j	a2670c <default_local_interrupt_handler>
  a261c8:	5440006f          	j	a2670c <default_local_interrupt_handler>
  a261cc:	5400006f          	j	a2670c <default_local_interrupt_handler>
  a261d0:	53c0006f          	j	a2670c <default_local_interrupt_handler>
  a261d4:	5380006f          	j	a2670c <default_local_interrupt_handler>
  a261d8:	5340006f          	j	a2670c <default_local_interrupt_handler>
  a261dc:	5300006f          	j	a2670c <default_local_interrupt_handler>
  a261e0:	52c0006f          	j	a2670c <default_local_interrupt_handler>
  a261e4:	5280006f          	j	a2670c <default_local_interrupt_handler>
  a261e8:	5240006f          	j	a2670c <default_local_interrupt_handler>
  a261ec:	5200006f          	j	a2670c <default_local_interrupt_handler>
  a261f0:	51c0006f          	j	a2670c <default_local_interrupt_handler>
  a261f4:	5180006f          	j	a2670c <default_local_interrupt_handler>
  a261f8:	5140006f          	j	a2670c <default_local_interrupt_handler>
  a261fc:	5100006f          	j	a2670c <default_local_interrupt_handler>
  a26200:	50c0006f          	j	a2670c <default_local_interrupt_handler>
  a26204:	5080006f          	j	a2670c <default_local_interrupt_handler>
  a26208:	5040006f          	j	a2670c <default_local_interrupt_handler>
  a2620c:	5000006f          	j	a2670c <default_local_interrupt_handler>
  a26210:	4fc0006f          	j	a2670c <default_local_interrupt_handler>
  a26214:	4f80006f          	j	a2670c <default_local_interrupt_handler>
  a26218:	4f40006f          	j	a2670c <default_local_interrupt_handler>
  a2621c:	4f00006f          	j	a2670c <default_local_interrupt_handler>
  a26220:	4ec0006f          	j	a2670c <default_local_interrupt_handler>
  a26224:	4e80006f          	j	a2670c <default_local_interrupt_handler>
  a26228:	4e40006f          	j	a2670c <default_local_interrupt_handler>
  a2622c:	4e00006f          	j	a2670c <default_local_interrupt_handler>
  a26230:	4dc0006f          	j	a2670c <default_local_interrupt_handler>
  a26234:	4d80006f          	j	a2670c <default_local_interrupt_handler>
  a26238:	0000                	unimp
	...

00a2623c <nmi_vector>:
  a2623c:	30047073          	csrci	mstatus,8
  a26240:	7175                	addi	sp,sp,-144
  a26242:	d06e                	sw	s11,32(sp)
  a26244:	d26a                	sw	s10,36(sp)
  a26246:	d466                	sw	s9,40(sp)
  a26248:	d662                	sw	s8,44(sp)
  a2624a:	d85e                	sw	s7,48(sp)
  a2624c:	da5a                	sw	s6,52(sp)
  a2624e:	dc56                	sw	s5,56(sp)
  a26250:	de52                	sw	s4,60(sp)
  a26252:	c0ce                	sw	s3,64(sp)
  a26254:	c2ca                	sw	s2,68(sp)
  a26256:	c4a6                	sw	s1,72(sp)
  a26258:	c6a2                	sw	s0,76(sp)
  a2625a:	c8fe                	sw	t6,80(sp)
  a2625c:	cafa                	sw	t5,84(sp)
  a2625e:	ccf6                	sw	t4,88(sp)
  a26260:	cef2                	sw	t3,92(sp)
  a26262:	d0c6                	sw	a7,96(sp)
  a26264:	d2c2                	sw	a6,100(sp)
  a26266:	d4be                	sw	a5,104(sp)
  a26268:	d6ba                	sw	a4,108(sp)
  a2626a:	d8b6                	sw	a3,112(sp)
  a2626c:	dab2                	sw	a2,116(sp)
  a2626e:	dcae                	sw	a1,120(sp)
  a26270:	deaa                	sw	a0,124(sp)
  a26272:	c11e                	sw	t2,128(sp)
  a26274:	c31a                	sw	t1,132(sp)
  a26276:	c516                	sw	t0,136(sp)
  a26278:	c706                	sw	ra,140(sp)
  a2627a:	fc202a73          	csrr	s4,0xfc2
  a2627e:	c052                	sw	s4,0(sp)
  a26280:	342029f3          	csrr	s3,mcause
  a26284:	c24e                	sw	s3,4(sp)
  a26286:	34302973          	csrr	s2,mtval
  a2628a:	c44a                	sw	s2,8(sp)
  a2628c:	c60e                	sw	gp,12(sp)
  a2628e:	300024f3          	csrr	s1,mstatus
  a26292:	c826                	sw	s1,16(sp)
  a26294:	34102473          	csrr	s0,mepc
  a26298:	ca22                	sw	s0,20(sp)
  a2629a:	cc12                	sw	tp,24(sp)
  a2629c:	ce0a                	sw	sp,28(sp)
  a2629e:	34011073          	csrw	mscratch,sp
  a262a2:	fffdc117          	auipc	sp,0xfffdc
  a262a6:	d5e10113          	addi	sp,sp,-674 # a02000 <__irq_stack_top__>
  a262aa:	34002573          	csrr	a0,mscratch
  a262ae:	c7dfe0ef          	jal	ra,a24f2a <do_hard_fault_handler>
  a262b2:	34002173          	csrr	sp,mscratch
  a262b6:	6289                	lui	t0,0x2
  a262b8:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a262bc:	3002a073          	csrs	mstatus,t0
  a262c0:	42d2                	lw	t0,20(sp)
  a262c2:	34129073          	csrw	mepc,t0
  a262c6:	5d82                	lw	s11,32(sp)
  a262c8:	5d12                	lw	s10,36(sp)
  a262ca:	5ca2                	lw	s9,40(sp)
  a262cc:	5c32                	lw	s8,44(sp)
  a262ce:	5bc2                	lw	s7,48(sp)
  a262d0:	5b52                	lw	s6,52(sp)
  a262d2:	5ae2                	lw	s5,56(sp)
  a262d4:	5a72                	lw	s4,60(sp)
  a262d6:	4986                	lw	s3,64(sp)
  a262d8:	4916                	lw	s2,68(sp)
  a262da:	44a6                	lw	s1,72(sp)
  a262dc:	4436                	lw	s0,76(sp)
  a262de:	4fc6                	lw	t6,80(sp)
  a262e0:	4f56                	lw	t5,84(sp)
  a262e2:	4ee6                	lw	t4,88(sp)
  a262e4:	4e76                	lw	t3,92(sp)
  a262e6:	5886                	lw	a7,96(sp)
  a262e8:	5816                	lw	a6,100(sp)
  a262ea:	57a6                	lw	a5,104(sp)
  a262ec:	5736                	lw	a4,108(sp)
  a262ee:	56c6                	lw	a3,112(sp)
  a262f0:	5656                	lw	a2,116(sp)
  a262f2:	55e6                	lw	a1,120(sp)
  a262f4:	5576                	lw	a0,124(sp)
  a262f6:	438a                	lw	t2,128(sp)
  a262f8:	431a                	lw	t1,132(sp)
  a262fa:	42aa                	lw	t0,136(sp)
  a262fc:	40ba                	lw	ra,140(sp)
  a262fe:	6149                	addi	sp,sp,144
  a26300:	30200073          	mret

00a26304 <default_interrupt0_handler>:
  a26304:	30047073          	csrci	mstatus,8
  a26308:	7119                	addi	sp,sp,-128
  a2630a:	c006                	sw	ra,0(sp)
  a2630c:	c20a                	sw	sp,4(sp)
  a2630e:	c40e                	sw	gp,8(sp)
  a26310:	c612                	sw	tp,12(sp)
  a26312:	c816                	sw	t0,16(sp)
  a26314:	ca1a                	sw	t1,20(sp)
  a26316:	cc1e                	sw	t2,24(sp)
  a26318:	ce22                	sw	s0,28(sp)
  a2631a:	d026                	sw	s1,32(sp)
  a2631c:	d22a                	sw	a0,36(sp)
  a2631e:	d42e                	sw	a1,40(sp)
  a26320:	d632                	sw	a2,44(sp)
  a26322:	d836                	sw	a3,48(sp)
  a26324:	da3a                	sw	a4,52(sp)
  a26326:	dc3e                	sw	a5,56(sp)
  a26328:	de42                	sw	a6,60(sp)
  a2632a:	c0c6                	sw	a7,64(sp)
  a2632c:	c2ca                	sw	s2,68(sp)
  a2632e:	c4ce                	sw	s3,72(sp)
  a26330:	c6d2                	sw	s4,76(sp)
  a26332:	c8d6                	sw	s5,80(sp)
  a26334:	cada                	sw	s6,84(sp)
  a26336:	ccde                	sw	s7,88(sp)
  a26338:	cee2                	sw	s8,92(sp)
  a2633a:	d0e6                	sw	s9,96(sp)
  a2633c:	d2ea                	sw	s10,100(sp)
  a2633e:	d4ee                	sw	s11,104(sp)
  a26340:	d6f2                	sw	t3,108(sp)
  a26342:	d8f6                	sw	t4,112(sp)
  a26344:	dafa                	sw	t5,116(sp)
  a26346:	dcfe                	sw	t6,120(sp)
  a26348:	341022f3          	csrr	t0,mepc
  a2634c:	de96                	sw	t0,124(sp)
  a2634e:	34011073          	csrw	mscratch,sp
  a26352:	fffdc117          	auipc	sp,0xfffdc
  a26356:	cae10113          	addi	sp,sp,-850 # a02000 <__irq_stack_top__>
  a2635a:	9ebfe0ef          	jal	ra,a24d44 <interrupt0_handler>
  a2635e:	34002173          	csrr	sp,mscratch
  a26362:	6289                	lui	t0,0x2
  a26364:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a26368:	3002a073          	csrs	mstatus,t0
  a2636c:	52f6                	lw	t0,124(sp)
  a2636e:	34129073          	csrw	mepc,t0
  a26372:	4082                	lw	ra,0(sp)
  a26374:	42c2                	lw	t0,16(sp)
  a26376:	4352                	lw	t1,20(sp)
  a26378:	43e2                	lw	t2,24(sp)
  a2637a:	4472                	lw	s0,28(sp)
  a2637c:	5482                	lw	s1,32(sp)
  a2637e:	5512                	lw	a0,36(sp)
  a26380:	55a2                	lw	a1,40(sp)
  a26382:	5632                	lw	a2,44(sp)
  a26384:	56c2                	lw	a3,48(sp)
  a26386:	5752                	lw	a4,52(sp)
  a26388:	57e2                	lw	a5,56(sp)
  a2638a:	5872                	lw	a6,60(sp)
  a2638c:	4886                	lw	a7,64(sp)
  a2638e:	4916                	lw	s2,68(sp)
  a26390:	49a6                	lw	s3,72(sp)
  a26392:	4a36                	lw	s4,76(sp)
  a26394:	4ac6                	lw	s5,80(sp)
  a26396:	4b56                	lw	s6,84(sp)
  a26398:	4be6                	lw	s7,88(sp)
  a2639a:	4c76                	lw	s8,92(sp)
  a2639c:	5c86                	lw	s9,96(sp)
  a2639e:	5d16                	lw	s10,100(sp)
  a263a0:	5da6                	lw	s11,104(sp)
  a263a2:	5e36                	lw	t3,108(sp)
  a263a4:	5ec6                	lw	t4,112(sp)
  a263a6:	5f56                	lw	t5,116(sp)
  a263a8:	5fe6                	lw	t6,120(sp)
  a263aa:	6109                	addi	sp,sp,128
  a263ac:	30200073          	mret

00a263b0 <default_interrupt1_handler>:
  a263b0:	30047073          	csrci	mstatus,8
  a263b4:	7119                	addi	sp,sp,-128
  a263b6:	c006                	sw	ra,0(sp)
  a263b8:	c20a                	sw	sp,4(sp)
  a263ba:	c40e                	sw	gp,8(sp)
  a263bc:	c612                	sw	tp,12(sp)
  a263be:	c816                	sw	t0,16(sp)
  a263c0:	ca1a                	sw	t1,20(sp)
  a263c2:	cc1e                	sw	t2,24(sp)
  a263c4:	ce22                	sw	s0,28(sp)
  a263c6:	d026                	sw	s1,32(sp)
  a263c8:	d22a                	sw	a0,36(sp)
  a263ca:	d42e                	sw	a1,40(sp)
  a263cc:	d632                	sw	a2,44(sp)
  a263ce:	d836                	sw	a3,48(sp)
  a263d0:	da3a                	sw	a4,52(sp)
  a263d2:	dc3e                	sw	a5,56(sp)
  a263d4:	de42                	sw	a6,60(sp)
  a263d6:	c0c6                	sw	a7,64(sp)
  a263d8:	c2ca                	sw	s2,68(sp)
  a263da:	c4ce                	sw	s3,72(sp)
  a263dc:	c6d2                	sw	s4,76(sp)
  a263de:	c8d6                	sw	s5,80(sp)
  a263e0:	cada                	sw	s6,84(sp)
  a263e2:	ccde                	sw	s7,88(sp)
  a263e4:	cee2                	sw	s8,92(sp)
  a263e6:	d0e6                	sw	s9,96(sp)
  a263e8:	d2ea                	sw	s10,100(sp)
  a263ea:	d4ee                	sw	s11,104(sp)
  a263ec:	d6f2                	sw	t3,108(sp)
  a263ee:	d8f6                	sw	t4,112(sp)
  a263f0:	dafa                	sw	t5,116(sp)
  a263f2:	dcfe                	sw	t6,120(sp)
  a263f4:	341022f3          	csrr	t0,mepc
  a263f8:	de96                	sw	t0,124(sp)
  a263fa:	34011073          	csrw	mscratch,sp
  a263fe:	fffdc117          	auipc	sp,0xfffdc
  a26402:	c0210113          	addi	sp,sp,-1022 # a02000 <__irq_stack_top__>
  a26406:	97ffe0ef          	jal	ra,a24d84 <interrupt1_handler>
  a2640a:	34002173          	csrr	sp,mscratch
  a2640e:	6289                	lui	t0,0x2
  a26410:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a26414:	3002a073          	csrs	mstatus,t0
  a26418:	52f6                	lw	t0,124(sp)
  a2641a:	34129073          	csrw	mepc,t0
  a2641e:	4082                	lw	ra,0(sp)
  a26420:	42c2                	lw	t0,16(sp)
  a26422:	4352                	lw	t1,20(sp)
  a26424:	43e2                	lw	t2,24(sp)
  a26426:	4472                	lw	s0,28(sp)
  a26428:	5482                	lw	s1,32(sp)
  a2642a:	5512                	lw	a0,36(sp)
  a2642c:	55a2                	lw	a1,40(sp)
  a2642e:	5632                	lw	a2,44(sp)
  a26430:	56c2                	lw	a3,48(sp)
  a26432:	5752                	lw	a4,52(sp)
  a26434:	57e2                	lw	a5,56(sp)
  a26436:	5872                	lw	a6,60(sp)
  a26438:	4886                	lw	a7,64(sp)
  a2643a:	4916                	lw	s2,68(sp)
  a2643c:	49a6                	lw	s3,72(sp)
  a2643e:	4a36                	lw	s4,76(sp)
  a26440:	4ac6                	lw	s5,80(sp)
  a26442:	4b56                	lw	s6,84(sp)
  a26444:	4be6                	lw	s7,88(sp)
  a26446:	4c76                	lw	s8,92(sp)
  a26448:	5c86                	lw	s9,96(sp)
  a2644a:	5d16                	lw	s10,100(sp)
  a2644c:	5da6                	lw	s11,104(sp)
  a2644e:	5e36                	lw	t3,108(sp)
  a26450:	5ec6                	lw	t4,112(sp)
  a26452:	5f56                	lw	t5,116(sp)
  a26454:	5fe6                	lw	t6,120(sp)
  a26456:	6109                	addi	sp,sp,128
  a26458:	30200073          	mret

00a2645c <default_interrupt2_handler>:
  a2645c:	30047073          	csrci	mstatus,8
  a26460:	7119                	addi	sp,sp,-128
  a26462:	c006                	sw	ra,0(sp)
  a26464:	c20a                	sw	sp,4(sp)
  a26466:	c40e                	sw	gp,8(sp)
  a26468:	c612                	sw	tp,12(sp)
  a2646a:	c816                	sw	t0,16(sp)
  a2646c:	ca1a                	sw	t1,20(sp)
  a2646e:	cc1e                	sw	t2,24(sp)
  a26470:	ce22                	sw	s0,28(sp)
  a26472:	d026                	sw	s1,32(sp)
  a26474:	d22a                	sw	a0,36(sp)
  a26476:	d42e                	sw	a1,40(sp)
  a26478:	d632                	sw	a2,44(sp)
  a2647a:	d836                	sw	a3,48(sp)
  a2647c:	da3a                	sw	a4,52(sp)
  a2647e:	dc3e                	sw	a5,56(sp)
  a26480:	de42                	sw	a6,60(sp)
  a26482:	c0c6                	sw	a7,64(sp)
  a26484:	c2ca                	sw	s2,68(sp)
  a26486:	c4ce                	sw	s3,72(sp)
  a26488:	c6d2                	sw	s4,76(sp)
  a2648a:	c8d6                	sw	s5,80(sp)
  a2648c:	cada                	sw	s6,84(sp)
  a2648e:	ccde                	sw	s7,88(sp)
  a26490:	cee2                	sw	s8,92(sp)
  a26492:	d0e6                	sw	s9,96(sp)
  a26494:	d2ea                	sw	s10,100(sp)
  a26496:	d4ee                	sw	s11,104(sp)
  a26498:	d6f2                	sw	t3,108(sp)
  a2649a:	d8f6                	sw	t4,112(sp)
  a2649c:	dafa                	sw	t5,116(sp)
  a2649e:	dcfe                	sw	t6,120(sp)
  a264a0:	341022f3          	csrr	t0,mepc
  a264a4:	de96                	sw	t0,124(sp)
  a264a6:	34011073          	csrw	mscratch,sp
  a264aa:	fffdc117          	auipc	sp,0xfffdc
  a264ae:	b5610113          	addi	sp,sp,-1194 # a02000 <__irq_stack_top__>
  a264b2:	913fe0ef          	jal	ra,a24dc4 <interrupt2_handler>
  a264b6:	34002173          	csrr	sp,mscratch
  a264ba:	6289                	lui	t0,0x2
  a264bc:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a264c0:	3002a073          	csrs	mstatus,t0
  a264c4:	52f6                	lw	t0,124(sp)
  a264c6:	34129073          	csrw	mepc,t0
  a264ca:	4082                	lw	ra,0(sp)
  a264cc:	42c2                	lw	t0,16(sp)
  a264ce:	4352                	lw	t1,20(sp)
  a264d0:	43e2                	lw	t2,24(sp)
  a264d2:	4472                	lw	s0,28(sp)
  a264d4:	5482                	lw	s1,32(sp)
  a264d6:	5512                	lw	a0,36(sp)
  a264d8:	55a2                	lw	a1,40(sp)
  a264da:	5632                	lw	a2,44(sp)
  a264dc:	56c2                	lw	a3,48(sp)
  a264de:	5752                	lw	a4,52(sp)
  a264e0:	57e2                	lw	a5,56(sp)
  a264e2:	5872                	lw	a6,60(sp)
  a264e4:	4886                	lw	a7,64(sp)
  a264e6:	4916                	lw	s2,68(sp)
  a264e8:	49a6                	lw	s3,72(sp)
  a264ea:	4a36                	lw	s4,76(sp)
  a264ec:	4ac6                	lw	s5,80(sp)
  a264ee:	4b56                	lw	s6,84(sp)
  a264f0:	4be6                	lw	s7,88(sp)
  a264f2:	4c76                	lw	s8,92(sp)
  a264f4:	5c86                	lw	s9,96(sp)
  a264f6:	5d16                	lw	s10,100(sp)
  a264f8:	5da6                	lw	s11,104(sp)
  a264fa:	5e36                	lw	t3,108(sp)
  a264fc:	5ec6                	lw	t4,112(sp)
  a264fe:	5f56                	lw	t5,116(sp)
  a26500:	5fe6                	lw	t6,120(sp)
  a26502:	6109                	addi	sp,sp,128
  a26504:	30200073          	mret

00a26508 <default_interrupt3_handler>:
  a26508:	30047073          	csrci	mstatus,8
  a2650c:	7119                	addi	sp,sp,-128
  a2650e:	c006                	sw	ra,0(sp)
  a26510:	c20a                	sw	sp,4(sp)
  a26512:	c40e                	sw	gp,8(sp)
  a26514:	c612                	sw	tp,12(sp)
  a26516:	c816                	sw	t0,16(sp)
  a26518:	ca1a                	sw	t1,20(sp)
  a2651a:	cc1e                	sw	t2,24(sp)
  a2651c:	ce22                	sw	s0,28(sp)
  a2651e:	d026                	sw	s1,32(sp)
  a26520:	d22a                	sw	a0,36(sp)
  a26522:	d42e                	sw	a1,40(sp)
  a26524:	d632                	sw	a2,44(sp)
  a26526:	d836                	sw	a3,48(sp)
  a26528:	da3a                	sw	a4,52(sp)
  a2652a:	dc3e                	sw	a5,56(sp)
  a2652c:	de42                	sw	a6,60(sp)
  a2652e:	c0c6                	sw	a7,64(sp)
  a26530:	c2ca                	sw	s2,68(sp)
  a26532:	c4ce                	sw	s3,72(sp)
  a26534:	c6d2                	sw	s4,76(sp)
  a26536:	c8d6                	sw	s5,80(sp)
  a26538:	cada                	sw	s6,84(sp)
  a2653a:	ccde                	sw	s7,88(sp)
  a2653c:	cee2                	sw	s8,92(sp)
  a2653e:	d0e6                	sw	s9,96(sp)
  a26540:	d2ea                	sw	s10,100(sp)
  a26542:	d4ee                	sw	s11,104(sp)
  a26544:	d6f2                	sw	t3,108(sp)
  a26546:	d8f6                	sw	t4,112(sp)
  a26548:	dafa                	sw	t5,116(sp)
  a2654a:	dcfe                	sw	t6,120(sp)
  a2654c:	341022f3          	csrr	t0,mepc
  a26550:	de96                	sw	t0,124(sp)
  a26552:	34011073          	csrw	mscratch,sp
  a26556:	fffdc117          	auipc	sp,0xfffdc
  a2655a:	aaa10113          	addi	sp,sp,-1366 # a02000 <__irq_stack_top__>
  a2655e:	8a7fe0ef          	jal	ra,a24e04 <interrupt3_handler>
  a26562:	34002173          	csrr	sp,mscratch
  a26566:	6289                	lui	t0,0x2
  a26568:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a2656c:	3002a073          	csrs	mstatus,t0
  a26570:	52f6                	lw	t0,124(sp)
  a26572:	34129073          	csrw	mepc,t0
  a26576:	4082                	lw	ra,0(sp)
  a26578:	42c2                	lw	t0,16(sp)
  a2657a:	4352                	lw	t1,20(sp)
  a2657c:	43e2                	lw	t2,24(sp)
  a2657e:	4472                	lw	s0,28(sp)
  a26580:	5482                	lw	s1,32(sp)
  a26582:	5512                	lw	a0,36(sp)
  a26584:	55a2                	lw	a1,40(sp)
  a26586:	5632                	lw	a2,44(sp)
  a26588:	56c2                	lw	a3,48(sp)
  a2658a:	5752                	lw	a4,52(sp)
  a2658c:	57e2                	lw	a5,56(sp)
  a2658e:	5872                	lw	a6,60(sp)
  a26590:	4886                	lw	a7,64(sp)
  a26592:	4916                	lw	s2,68(sp)
  a26594:	49a6                	lw	s3,72(sp)
  a26596:	4a36                	lw	s4,76(sp)
  a26598:	4ac6                	lw	s5,80(sp)
  a2659a:	4b56                	lw	s6,84(sp)
  a2659c:	4be6                	lw	s7,88(sp)
  a2659e:	4c76                	lw	s8,92(sp)
  a265a0:	5c86                	lw	s9,96(sp)
  a265a2:	5d16                	lw	s10,100(sp)
  a265a4:	5da6                	lw	s11,104(sp)
  a265a6:	5e36                	lw	t3,108(sp)
  a265a8:	5ec6                	lw	t4,112(sp)
  a265aa:	5f56                	lw	t5,116(sp)
  a265ac:	5fe6                	lw	t6,120(sp)
  a265ae:	6109                	addi	sp,sp,128
  a265b0:	30200073          	mret

00a265b4 <default_interrupt4_handler>:
  a265b4:	30047073          	csrci	mstatus,8
  a265b8:	7119                	addi	sp,sp,-128
  a265ba:	c006                	sw	ra,0(sp)
  a265bc:	c20a                	sw	sp,4(sp)
  a265be:	c40e                	sw	gp,8(sp)
  a265c0:	c612                	sw	tp,12(sp)
  a265c2:	c816                	sw	t0,16(sp)
  a265c4:	ca1a                	sw	t1,20(sp)
  a265c6:	cc1e                	sw	t2,24(sp)
  a265c8:	ce22                	sw	s0,28(sp)
  a265ca:	d026                	sw	s1,32(sp)
  a265cc:	d22a                	sw	a0,36(sp)
  a265ce:	d42e                	sw	a1,40(sp)
  a265d0:	d632                	sw	a2,44(sp)
  a265d2:	d836                	sw	a3,48(sp)
  a265d4:	da3a                	sw	a4,52(sp)
  a265d6:	dc3e                	sw	a5,56(sp)
  a265d8:	de42                	sw	a6,60(sp)
  a265da:	c0c6                	sw	a7,64(sp)
  a265dc:	c2ca                	sw	s2,68(sp)
  a265de:	c4ce                	sw	s3,72(sp)
  a265e0:	c6d2                	sw	s4,76(sp)
  a265e2:	c8d6                	sw	s5,80(sp)
  a265e4:	cada                	sw	s6,84(sp)
  a265e6:	ccde                	sw	s7,88(sp)
  a265e8:	cee2                	sw	s8,92(sp)
  a265ea:	d0e6                	sw	s9,96(sp)
  a265ec:	d2ea                	sw	s10,100(sp)
  a265ee:	d4ee                	sw	s11,104(sp)
  a265f0:	d6f2                	sw	t3,108(sp)
  a265f2:	d8f6                	sw	t4,112(sp)
  a265f4:	dafa                	sw	t5,116(sp)
  a265f6:	dcfe                	sw	t6,120(sp)
  a265f8:	341022f3          	csrr	t0,mepc
  a265fc:	de96                	sw	t0,124(sp)
  a265fe:	34011073          	csrw	mscratch,sp
  a26602:	fffdc117          	auipc	sp,0xfffdc
  a26606:	9fe10113          	addi	sp,sp,-1538 # a02000 <__irq_stack_top__>
  a2660a:	83bfe0ef          	jal	ra,a24e44 <interrupt4_handler>
  a2660e:	34002173          	csrr	sp,mscratch
  a26612:	6289                	lui	t0,0x2
  a26614:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a26618:	3002a073          	csrs	mstatus,t0
  a2661c:	52f6                	lw	t0,124(sp)
  a2661e:	34129073          	csrw	mepc,t0
  a26622:	4082                	lw	ra,0(sp)
  a26624:	42c2                	lw	t0,16(sp)
  a26626:	4352                	lw	t1,20(sp)
  a26628:	43e2                	lw	t2,24(sp)
  a2662a:	4472                	lw	s0,28(sp)
  a2662c:	5482                	lw	s1,32(sp)
  a2662e:	5512                	lw	a0,36(sp)
  a26630:	55a2                	lw	a1,40(sp)
  a26632:	5632                	lw	a2,44(sp)
  a26634:	56c2                	lw	a3,48(sp)
  a26636:	5752                	lw	a4,52(sp)
  a26638:	57e2                	lw	a5,56(sp)
  a2663a:	5872                	lw	a6,60(sp)
  a2663c:	4886                	lw	a7,64(sp)
  a2663e:	4916                	lw	s2,68(sp)
  a26640:	49a6                	lw	s3,72(sp)
  a26642:	4a36                	lw	s4,76(sp)
  a26644:	4ac6                	lw	s5,80(sp)
  a26646:	4b56                	lw	s6,84(sp)
  a26648:	4be6                	lw	s7,88(sp)
  a2664a:	4c76                	lw	s8,92(sp)
  a2664c:	5c86                	lw	s9,96(sp)
  a2664e:	5d16                	lw	s10,100(sp)
  a26650:	5da6                	lw	s11,104(sp)
  a26652:	5e36                	lw	t3,108(sp)
  a26654:	5ec6                	lw	t4,112(sp)
  a26656:	5f56                	lw	t5,116(sp)
  a26658:	5fe6                	lw	t6,120(sp)
  a2665a:	6109                	addi	sp,sp,128
  a2665c:	30200073          	mret

00a26660 <default_interrupt5_handler>:
  a26660:	30047073          	csrci	mstatus,8
  a26664:	7119                	addi	sp,sp,-128
  a26666:	c006                	sw	ra,0(sp)
  a26668:	c20a                	sw	sp,4(sp)
  a2666a:	c40e                	sw	gp,8(sp)
  a2666c:	c612                	sw	tp,12(sp)
  a2666e:	c816                	sw	t0,16(sp)
  a26670:	ca1a                	sw	t1,20(sp)
  a26672:	cc1e                	sw	t2,24(sp)
  a26674:	ce22                	sw	s0,28(sp)
  a26676:	d026                	sw	s1,32(sp)
  a26678:	d22a                	sw	a0,36(sp)
  a2667a:	d42e                	sw	a1,40(sp)
  a2667c:	d632                	sw	a2,44(sp)
  a2667e:	d836                	sw	a3,48(sp)
  a26680:	da3a                	sw	a4,52(sp)
  a26682:	dc3e                	sw	a5,56(sp)
  a26684:	de42                	sw	a6,60(sp)
  a26686:	c0c6                	sw	a7,64(sp)
  a26688:	c2ca                	sw	s2,68(sp)
  a2668a:	c4ce                	sw	s3,72(sp)
  a2668c:	c6d2                	sw	s4,76(sp)
  a2668e:	c8d6                	sw	s5,80(sp)
  a26690:	cada                	sw	s6,84(sp)
  a26692:	ccde                	sw	s7,88(sp)
  a26694:	cee2                	sw	s8,92(sp)
  a26696:	d0e6                	sw	s9,96(sp)
  a26698:	d2ea                	sw	s10,100(sp)
  a2669a:	d4ee                	sw	s11,104(sp)
  a2669c:	d6f2                	sw	t3,108(sp)
  a2669e:	d8f6                	sw	t4,112(sp)
  a266a0:	dafa                	sw	t5,116(sp)
  a266a2:	dcfe                	sw	t6,120(sp)
  a266a4:	341022f3          	csrr	t0,mepc
  a266a8:	de96                	sw	t0,124(sp)
  a266aa:	34011073          	csrw	mscratch,sp
  a266ae:	fffdc117          	auipc	sp,0xfffdc
  a266b2:	95210113          	addi	sp,sp,-1710 # a02000 <__irq_stack_top__>
  a266b6:	fcefe0ef          	jal	ra,a24e84 <interrupt5_handler>
  a266ba:	34002173          	csrr	sp,mscratch
  a266be:	6289                	lui	t0,0x2
  a266c0:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a266c4:	3002a073          	csrs	mstatus,t0
  a266c8:	52f6                	lw	t0,124(sp)
  a266ca:	34129073          	csrw	mepc,t0
  a266ce:	4082                	lw	ra,0(sp)
  a266d0:	42c2                	lw	t0,16(sp)
  a266d2:	4352                	lw	t1,20(sp)
  a266d4:	43e2                	lw	t2,24(sp)
  a266d6:	4472                	lw	s0,28(sp)
  a266d8:	5482                	lw	s1,32(sp)
  a266da:	5512                	lw	a0,36(sp)
  a266dc:	55a2                	lw	a1,40(sp)
  a266de:	5632                	lw	a2,44(sp)
  a266e0:	56c2                	lw	a3,48(sp)
  a266e2:	5752                	lw	a4,52(sp)
  a266e4:	57e2                	lw	a5,56(sp)
  a266e6:	5872                	lw	a6,60(sp)
  a266e8:	4886                	lw	a7,64(sp)
  a266ea:	4916                	lw	s2,68(sp)
  a266ec:	49a6                	lw	s3,72(sp)
  a266ee:	4a36                	lw	s4,76(sp)
  a266f0:	4ac6                	lw	s5,80(sp)
  a266f2:	4b56                	lw	s6,84(sp)
  a266f4:	4be6                	lw	s7,88(sp)
  a266f6:	4c76                	lw	s8,92(sp)
  a266f8:	5c86                	lw	s9,96(sp)
  a266fa:	5d16                	lw	s10,100(sp)
  a266fc:	5da6                	lw	s11,104(sp)
  a266fe:	5e36                	lw	t3,108(sp)
  a26700:	5ec6                	lw	t4,112(sp)
  a26702:	5f56                	lw	t5,116(sp)
  a26704:	5fe6                	lw	t6,120(sp)
  a26706:	6109                	addi	sp,sp,128
  a26708:	30200073          	mret

00a2670c <default_local_interrupt_handler>:
  a2670c:	30047073          	csrci	mstatus,8
  a26710:	7119                	addi	sp,sp,-128
  a26712:	c006                	sw	ra,0(sp)
  a26714:	c20a                	sw	sp,4(sp)
  a26716:	c40e                	sw	gp,8(sp)
  a26718:	c612                	sw	tp,12(sp)
  a2671a:	c816                	sw	t0,16(sp)
  a2671c:	ca1a                	sw	t1,20(sp)
  a2671e:	cc1e                	sw	t2,24(sp)
  a26720:	ce22                	sw	s0,28(sp)
  a26722:	d026                	sw	s1,32(sp)
  a26724:	d22a                	sw	a0,36(sp)
  a26726:	d42e                	sw	a1,40(sp)
  a26728:	d632                	sw	a2,44(sp)
  a2672a:	d836                	sw	a3,48(sp)
  a2672c:	da3a                	sw	a4,52(sp)
  a2672e:	dc3e                	sw	a5,56(sp)
  a26730:	de42                	sw	a6,60(sp)
  a26732:	c0c6                	sw	a7,64(sp)
  a26734:	c2ca                	sw	s2,68(sp)
  a26736:	c4ce                	sw	s3,72(sp)
  a26738:	c6d2                	sw	s4,76(sp)
  a2673a:	c8d6                	sw	s5,80(sp)
  a2673c:	cada                	sw	s6,84(sp)
  a2673e:	ccde                	sw	s7,88(sp)
  a26740:	cee2                	sw	s8,92(sp)
  a26742:	d0e6                	sw	s9,96(sp)
  a26744:	d2ea                	sw	s10,100(sp)
  a26746:	d4ee                	sw	s11,104(sp)
  a26748:	d6f2                	sw	t3,108(sp)
  a2674a:	d8f6                	sw	t4,112(sp)
  a2674c:	dafa                	sw	t5,116(sp)
  a2674e:	dcfe                	sw	t6,120(sp)
  a26750:	341022f3          	csrr	t0,mepc
  a26754:	de96                	sw	t0,124(sp)
  a26756:	34011073          	csrw	mscratch,sp
  a2675a:	fffdc117          	auipc	sp,0xfffdc
  a2675e:	8a610113          	addi	sp,sp,-1882 # a02000 <__irq_stack_top__>
  a26762:	f62fe0ef          	jal	ra,a24ec4 <local_interrupt_handler>
  a26766:	34002173          	csrr	sp,mscratch
  a2676a:	6289                	lui	t0,0x2
  a2676c:	88028293          	addi	t0,t0,-1920 # 1880 <ccause+0x8be>
  a26770:	3002a073          	csrs	mstatus,t0
  a26774:	52f6                	lw	t0,124(sp)
  a26776:	34129073          	csrw	mepc,t0
  a2677a:	4082                	lw	ra,0(sp)
  a2677c:	42c2                	lw	t0,16(sp)
  a2677e:	4352                	lw	t1,20(sp)
  a26780:	43e2                	lw	t2,24(sp)
  a26782:	4472                	lw	s0,28(sp)
  a26784:	5482                	lw	s1,32(sp)
  a26786:	5512                	lw	a0,36(sp)
  a26788:	55a2                	lw	a1,40(sp)
  a2678a:	5632                	lw	a2,44(sp)
  a2678c:	56c2                	lw	a3,48(sp)
  a2678e:	5752                	lw	a4,52(sp)
  a26790:	57e2                	lw	a5,56(sp)
  a26792:	5872                	lw	a6,60(sp)
  a26794:	4886                	lw	a7,64(sp)
  a26796:	4916                	lw	s2,68(sp)
  a26798:	49a6                	lw	s3,72(sp)
  a2679a:	4a36                	lw	s4,76(sp)
  a2679c:	4ac6                	lw	s5,80(sp)
  a2679e:	4b56                	lw	s6,84(sp)
  a267a0:	4be6                	lw	s7,88(sp)
  a267a2:	4c76                	lw	s8,92(sp)
  a267a4:	5c86                	lw	s9,96(sp)
  a267a6:	5d16                	lw	s10,100(sp)
  a267a8:	5da6                	lw	s11,104(sp)
  a267aa:	5e36                	lw	t3,108(sp)
  a267ac:	5ec6                	lw	t4,112(sp)
  a267ae:	5f56                	lw	t5,116(sp)
  a267b0:	5fe6                	lw	t6,120(sp)
  a267b2:	6109                	addi	sp,sp,128
  a267b4:	30200073          	mret

00a267b8 <global_interrupt_lock>:
  a267b8:	30002573          	csrr	a0,mstatus
  a267bc:	42a1                	li	t0,8
  a267be:	3002b073          	csrc	mstatus,t0
  a267c2:	8082                	ret

00a267c4 <global_interrupt_unlock>:
  a267c4:	30002573          	csrr	a0,mstatus
  a267c8:	42a1                	li	t0,8
  a267ca:	3002a073          	csrs	mstatus,t0
  a267ce:	8082                	ret

00a267d0 <global_interrupt_restore>:
  a267d0:	30051073          	csrw	mstatus,a0
  a267d4:	8082                	ret
	...

00a267d8 <__clz_tab>:
  a267d8:	0100 0202 0303 0303 0404 0404 0404 0404     ................
  a267e8:	0505 0505 0505 0505 0505 0505 0505 0505     ................
  a267f8:	0606 0606 0606 0606 0606 0606 0606 0606     ................
  a26808:	0606 0606 0606 0606 0606 0606 0606 0606     ................
  a26818:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a26828:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a26838:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a26848:	0707 0707 0707 0707 0707 0707 0707 0707     ................
  a26858:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a26868:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a26878:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a26888:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a26898:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a268a8:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a268b8:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a268c8:	0808 0808 0808 0808 0808 0808 0808 0808     ................
  a268d8:	1182 00a2 10f6 00a2 1188 00a2 1188 00a2     ................
  a268e8:	118c 00a2 1198 00a2 6552 6461 2079 6f66     ........Ready fo
  a268f8:	2072 6f64 6e77 6f6c 6461 0000 7075 6f6c     r download..uplo
  a26908:	6461 622e 6e69 0000 6e55 7573 7070 726f     ad.bin..Unsuppor
  a26918:	2074 4d43 3a44 0000 7845 6365 7475 6f69     t CMD:..Executio
  a26928:	206e 7553 6363 7365 6673 6c75 0000 0000     n Successful....
  a26938:	3d3d 3d3d 3d3d 3d3d 3d3d 3d3d 3d3d 3d3d     ================
  a26948:	3d3d 3d3d 3d3d 3d3d 003d 0000               =========...

00a26954 <g_loader_cmdtable>:
  a26954:	00d2 0000 11bc 00a2 0087 0000 131c 00a2     ................
  a26964:	0078 0000 11bc 00a2 00c3 0000 19a6 00a2     x...............
  a26974:	00a5 0000 1b2e 00a2 00b4 0000 1270 00a2     ............p...
  a26984:	005a 0000 12b2 00a2 6843 7069 4520 6172     Z.......Chip Era
  a26994:	6573 6620 6961 756c 6572 0021 6e49 6176     se failure!.Inva
  a269a4:	696c 2064 6170 6172 736d 0000 6f64 6e77     lid params..down
  a269b4:	6f6c 6461 615f 6464 2072 0000 6620 6c69     load_addr .. fil
  a269c4:	5f65 656c 206e 0000 6520 6172 6573 735f     e_len .. erase_s
  a269d4:	7a69 2065 0000 0000 520a 7365 7465 6420     ize .....Reset d
  a269e4:	7665 6369 2e65 2e2e 000a 0000 7055 6f6c     evice.......Uplo
  a269f4:	6461 6c20 6e65 7467 2068 7265 6f72 0072     ad length error.
  a26a04:	7055 6f6c 6461 6120 6464 2072 7265 6f72     Upload addr erro
  a26a14:	0072 0000 7055 6f6c 6461 6120 6464 2072     r...Upload addr 
  a26a24:	7865 6563 6465 2073 6c66 7361 2068 6163     exceeds flash ca
  a26a34:	6170 6963 7974 0000                         pacity..

00a26a3c <g_crc16_tab>:
  a26a3c:	0000 1021 2042 3063 4084 50a5 60c6 70e7     ..!.B c0.@.P.`.p
  a26a4c:	8108 9129 a14a b16b c18c d1ad e1ce f1ef     ..).J.k.........
  a26a5c:	1231 0210 3273 2252 52b5 4294 72f7 62d6     1...s2R".R.B.r.b
  a26a6c:	9339 8318 b37b a35a d3bd c39c f3ff e3de     9...{.Z.........
  a26a7c:	2462 3443 0420 1401 64e6 74c7 44a4 5485     b$C4 ....d.t.D.T
  a26a8c:	a56a b54b 8528 9509 e5ee f5cf c5ac d58d     j.K.(...........
  a26a9c:	3653 2672 1611 0630 76d7 66f6 5695 46b4     S6r&..0..v.f.V.F
  a26aac:	b75b a77a 9719 8738 f7df e7fe d79d c7bc     [.z...8.........
  a26abc:	48c4 58e5 6886 78a7 0840 1861 2802 3823     .H.X.h.x@.a..(#8
  a26acc:	c9cc d9ed e98e f9af 8948 9969 a90a b92b     ........H.i...+.
  a26adc:	5af5 4ad4 7ab7 6a96 1a71 0a50 3a33 2a12     .Z.J.z.jq.P.3:.*
  a26aec:	dbfd cbdc fbbf eb9e 9b79 8b58 bb3b ab1a     ........y.X.;...
  a26afc:	6ca6 7c87 4ce4 5cc5 2c22 3c03 0c60 1c41     .l.|.L.\",.<`.A.
  a26b0c:	edae fd8f cdec ddcd ad2a bd0b 8d68 9d49     ........*...h.I.
  a26b1c:	7e97 6eb6 5ed5 4ef4 3e13 2e32 1e51 0e70     .~.n.^.N.>2.Q.p.
  a26b2c:	ff9f efbe dfdd cffc bf1b af3a 9f59 8f78     ..........:.Y.x.
  a26b3c:	9188 81a9 b1ca a1eb d10c c12d f14e e16f     ..........-.N.o.
  a26b4c:	1080 00a1 30c2 20e3 5004 4025 7046 6067     .....0. .P%@Fpg`
  a26b5c:	83b9 9398 a3fb b3da c33d d31c e37f f35e     ........=.....^.
  a26b6c:	02b1 1290 22f3 32d2 4235 5214 6277 7256     .....".25B.RwbVr
  a26b7c:	b5ea a5cb 95a8 8589 f56e e54f d52c c50d     ........n.O.,...
  a26b8c:	34e2 24c3 14a0 0481 7466 6447 5424 4405     .4.$....ftGd$T.D
  a26b9c:	a7db b7fa 8799 97b8 e75f f77e c71d d73c     ........_.~...<.
  a26bac:	26d3 36f2 0691 16b0 6657 7676 4615 5634     .&.6....Wfvv.F4V
  a26bbc:	d94c c96d f90e e92f 99c8 89e9 b98a a9ab     L.m.../.........
  a26bcc:	5844 4865 7806 6827 18c0 08e1 3882 28a3     DXeH.x'h.....8.(
  a26bdc:	cb7d db5c eb3f fb1e 8bf9 9bd8 abbb bb9a     }.\.?...........
  a26bec:	4a75 5a54 6a37 7a16 0af1 1ad0 2ab3 3a92     uJTZ7j.z.....*.:
  a26bfc:	fd2e ed0f dd6c cd4d bdaa ad8b 9de8 8dc9     ....l.M.........
  a26c0c:	7c26 6c07 5c64 4c45 3ca2 2c83 1ce0 0cc1     &|.ld\EL.<.,....
  a26c1c:	ef1f ff3e cf5d df7c af9b bfba 8fd9 9ff8     ..>.].|.........
  a26c2c:	6e17 7e36 4e55 5e74 2e93 3eb2 0ed1 1ef0     .n6~UNt^...>....
  a26c3c:	6966 656c 6c20 6e65 7467 2068 7265 2072     file length err 
  a26c4c:	203a 0000 6966 656c 735f 7a69 2065 203e     : ..file_size > 
  a26c5c:	7265 7361 5f65 6973 657a 0000 6c66 7361     erase_size..flas
  a26c6c:	2068 7277 7469 2065 6166 6c69 0000 0000     h write fail....
  a26c7c:	6f74 6174 206c 6973 657a 003a 6946 656c     total size:.File
  a26c8c:	6c20 6e65 7467 2068 7265 6f72 2072 203a      length error : 
  a26c9c:	0000 0000 6f4c 6461 2079 6665 7375 2065     ....Loady efuse 
  a26cac:	6966 656c 6620 6961 656c 3a64 0000 0000     file failed:....
  a26cbc:	7264 5f76 6f72 5f6d 6963 6870 7265 695f     drv_rom_cipher_i
  a26ccc:	696e 2074 2121 2021 6572 2074 203d 0000     nit !!! ret = ..
  a26cdc:	7264 5f76 6f72 5f6d 6963 6870 7265 735f     drv_rom_cipher_s
  a26cec:	6168 3532 2036 2121 2021 6572 2074 203d     ha256 !!! ret = 
  a26cfc:	0000 0000 7264 5f76 6f72 5f6d 6963 6870     ....drv_rom_ciph
  a26d0c:	7265 645f 6965 696e 2074 2121 2021 6572     er_deinit !!! re
  a26d1c:	2074 203d 0000 0000 6168 6873 6320 6d6f     t = ....hash com
  a26d2c:	706d 7261 2065 6166 6c69 2121 0021 0000     mpare fail!!!...
  a26d3c:	7865 6563 6465 6520 7566 6573 6920 646e     exceed efuse ind
  a26d4c:	7865 2121 0021 0000 6645 7375 2065 6f63     ex!!!...Efuse co
  a26d5c:	666e 6769 6620 6c69 2065 6e69 6176 696c     nfig file invali
  a26d6c:	0064 0000 6665 7375 2065 7277 7469 2065     d...efuse write 
  a26d7c:	7265 6f72 2c72 6920 646e 7865 003a 0000     error, index:...
  a26d8c:	7453 7261 2074 6962 3a74 0020 6c20 6e65     Start bit: . len
  a26d9c:	6228 7469 2973 003d 6645 7375 2065 6572     (bits)=.Efuse re
  a26dac:	6461 0000 6150 6172 736d 6520 7272 0000     ad..Params err..
  a26dbc:	2020 0000                                     ..

00a26dc0 <sfc_cfg>:
  a26dc0:	0104 0000 0000 0020 0000 0080 6f4c 6461     ...... .....Load
  a26dd0:	6f62 746f 5520 7261 2074 6e49 7469 5320     boot Uart Init S
  a26de0:	6375 2163 0000 0000 6c46 7361 2068 6e49     ucc!....Flash In
  a26df0:	7469 4620 6961 216c 7220 7465 3d20 0020     it Fail! ret = .
  a26e00:	6c46 7361 2068 6e49 7469 5320 6375 2163     Flash Init Succ!
  a26e10:	0000 0000 4653 2043 6966 2078 5253 7220     ....SFC fix SR r
  a26e20:	7465 3d20 0000 0000 3d3d 3d3d 3d3d 3d3d     et =....========
  a26e30:	3d3d 3d3d 3d3d 3d3d 4c20 616f 2064 6d43     ======== Load Cm
  a26e40:	2064 6f4c 706f 3d20 3d3d 3d3d 3d3d 3d3d     d Loop =========
  a26e50:	3d3d 3d3d 3d3d 0d3d 000a 0000               =======.....

00a26e5c <g_sha256_ival>:
  a26e5c:	096a 67e6 67bb 85ae 6e3c 72f3 4fa5 3af5     j..g.g..<n.r.O.:
  a26e6c:	0e51 7f52 059b 8c68 831f abd9 e05b 19cd     Q.R...h.....[...

00a26e7c <g_sm3_ival>:
  a26e7c:	8073 6f16 1449 b9b2 2417 d742 8ada 0006     s..oI....$B.....
  a26e8c:	6fa9 bc30 3116 aa38 8de3 4dee fbb0 4e0e     .o0..18....M...N

00a26e9c <g_crypto_ecc_num>:
  a26e9c:	0000 0000                                   ....

00a26ea0 <g_crypto_ecc_params>:
  a26ea0:	25d0 00a2 258e 00a2 265e 00a2 26f0 00a2     .%...%..^&...&..
  a26eb0:	270a 00a2 2f14 00a2 2f1e 00a2 2fac 00a2     .'.../.../.../..
  a26ec0:	2f2e 00a2 2f9e 00a2 2f9e 00a2 2f9e 00a2     ./.../.../.../..
  a26ed0:	2f9e 00a2 2f9e 00a2 2f9e 00a2 2f9e 00a2     ./.../.../.../..
  a26ee0:	2f9e 00a2 2f9e 00a2 2f9e 00a2 2f9e 00a2     ./.../.../.../..
  a26ef0:	2fa6 00a2 374e 00a2 3738 00a2 3730 00a2     ./..N7..87..07..
  a26f00:	3738 00a2 373c 00a2 3738 00a2 3746 00a2     87..<7..87..F7..
  a26f10:	3738 00a2 3738 00a2 3738 00a2 3738 00a2     87..87..87..87..
  a26f20:	3738 00a2 373c 00a2 3746 00a2               87..<7..F7..

00a26f2c <CSWTCH.8>:
  a26f2c:	1001 0020                                   .. .

00a26f30 <g_hal_uart_ctrl_func_array>:
  a26f30:	37ec 00a2 0000 0000 3782 00a2 3774 00a2     .7.......7..t7..
  a26f40:	3766 00a2 3758 00a2 3758 00a2 352c 00a2     f7..X7..X7..,5..
  a26f50:	3542 00a2 3578 00a2 0000 0000 3656 00a2     B5..x5......V6..
  a26f60:	3636 00a2 0000 0000 0000 0000 0000 0000     66..............
  a26f70:	0000 0000 355a 00a2 34ce 00a2 34e0 00a2     ....Z5...4...4..
  a26f80:	0000 0000                                   ....

00a26f84 <g_uart_base_addrs>:
  a26f84:	0000 4401 1000 4401 2000 4401               ...D...D. .D

00a26f90 <g_default_erase_cmds>:
  a26f90:	c639 ffff 06c1 4000 0101 0400               9......@....

00a26f9c <g_default_quad_enable>:
  a26f9c:	0002 0000 0000 0000                         ........

00a26fa4 <g_default_read_cmds>:
  a26fa4:	0019 0000                                   ....

00a26fa8 <g_default_write_cmds>:
  a26fa8:	0001 0000 0011 0000                         ........

00a26fb0 <g_flash_common_erase_cmds>:
  a26fb0:	c639 ffff 06c1 4000 0291 2000 0101 0400     9......@... ....

00a26fc0 <g_flash_common_read_cmds>:
  a26fc0:	0019 0000 4059 0000 49d9 0000 55d9 0000     ....Y@...I...U..
  a26fd0:	6b59 0000 f759 0000                         Yk..Y...

00a26fd8 <g_flash_common_write_cmds>:
  a26fd8:	0001 0000 0011 0000 4000 0000 4000 0000     .........@...@..
  a26fe8:	2991 0000 4000 0000                         .)...@..

00a26ff0 <g_flash_gd_bus_enable>:
  a26ff0:	0301 0005 0000 0301 0135 0001 0002 0000     ........5.......
  a27000:	0000 0000                                   ....

00a27004 <g_flash_spi_info_list>:
  a27004:	40c8 0016 0000 0040 0004 0000 6fc0 00a2     .@....@......o..
  a27014:	6fd8 00a2 6fb0 00a2 6ff0 00a2               .o...o...o..

00a27020 <g_flash_spi_unknown_info>:
  a27020:	ffff 00ff 0000 0008 0003 0000 6fa4 00a2     .............o..
  a27030:	6fa8 00a2 6f90 00a2 6f9c 00a2               .o...o...o..

00a2703c <g_sfc_protect_cfg>:
  a2703c:	2802 0000 0000 0002 0000 0040 7802 0000     .(........@..x..
  a2704c:	8000 0000 0000 0040 0002 0000 0000 0000     ......@.........
  a2705c:	0000 0040 6f4e 6e20 6565 2064 6f74 6620     ..@.No need to f
  a2706c:	7869 5320 2152 0a0d 0000 0000 5253 6620     ix SR!......SR f
  a2707c:	7869 6f20 216b 0a0d 0000 0000 5253 6425     ix ok!......SR%d
  a2708c:	305b 2578 5d78 6e20 6565 7364 6620 7869     [0x%x] needs fix
  a2709c:	6e69 2c67 6520 7078 6365 5b74 7830 7825     ing, expect[0x%x
  a270ac:	0d5d 000a                                   ]...

00a270b0 <g_efuse_cfg>:
  a270b0:	0000 0008 0003 0008 00a0 0003 0270 0020     ............p. .
  a270c0:	0003 0290 0008 0003 0298 0008 0003 02a0     ................
  a270d0:	0100 0003 03a0 0020 0003 03c0 0001 0003     ...... .........
  a270e0:	03e8 0008 0003 0630 0030 0003 0660 0030     ......0.0...`.0.
  a270f0:	0003 0690 0030 0003 06c0 0030 0003 06f0     ....0.....0.....
  a27100:	0080 0003 02a0 0100 0003 046f 0001 0003     ..........o.....
  a27110:	0460 000f 0003 0470 0010 0003 0770 0030     `.....p.....p.0.
  a27120:	0003 0000 650a 7272 6f6e 003d 7830 0000     .....errno=.0x..
  a27130:	7075 6164 6574 725f 7365 7465 635f 756f     update_reset_cou
  a27140:	746e 0020 6572 6461 6520 7566 6573 7420     nt .read efuse t
  a27150:	7079 5f65 6469 6520 7272 2021 6572 2074     ype_id err! ret 
  a27160:	203d 0000 6572 6461 6520 7566 6573 6420     = ..read efuse d
  a27170:	6569 695f 2064 7265 2172 7220 7465 3d20     ie_id err! ret =
  a27180:	0020 0000 6863 6365 5f6b 6863 7069 745f      ...check_chip_t
  a27190:	7079 2065 7265 2072 655b 7566 6573 703a     ype err [efuse:p
  a271a0:	746b 3a5d 0000 0000 4f52 7c4d 6564 6166     kt]:....ROM|defa
  a271b0:	6c75 5f74 6168 646e 656c 2072 203a 6e69     ult_handler : in
  a271c0:	6574 7272 7075 2074 6469 5b78 6425 0a5d     terrupt idx[%d].
  a271d0:	0000 0000 4f52 7c4d 6f4f 7370 2d20 6820     ....ROM|Oops - h
  a271e0:	7261 2064 6166 6c75 0d74 000a 4f52 7c4d     ard fault...ROM|
  a271f0:	7865 6563 7470 6f69 3a6e 7825 0a0d 0000     exception:%x....
  a27200:	4f52 7c4d 6f4f 7370 4e3a 494d 000a 0000     ROM|Oops:NMI....
  a27210:	4f52 7c4d 6f4f 7370 2d20 6920 736e 206e     ROM|Oops - insn 
  a27220:	6170 6567 6620 7561 746c 0a0d 0000 0000     page fault......
  a27230:	4f52 7c4d 6f4f 7370 2d20 6c20 616f 2064     ROM|Oops - load 
  a27240:	6170 6567 6620 7561 746c 0a0d 0000 0000     page fault......
  a27250:	4f52 7c4d 6f4f 7370 2d20 6c20 636f 206b     ROM|Oops - lock 
  a27260:	7075 0a0d 0000 0000 4f52 7c4d 6f4f 7370     up......ROM|Oops
  a27270:	2d20 7320 6f74 6572 7020 6761 2065 6166      - store page fa
  a27280:	6c75 0d74 000a 0000 4f52 7c4d 6f4f 7370     ult.....ROM|Oops
  a27290:	2d20 6520 7262 6165 0d6b 000a 4f52 7c4d      - ebreak...ROM|
  a272a0:	6f4f 7370 2d20 6520 766e 7269 6e6f 656d     Oops - environme
  a272b0:	746e 6320 6c61 206c 7266 6d6f 4d20 6d2d     nt call from M-m
  a272c0:	646f 0d65 000a 0000 4f52 7c4d 6f4f 7370     ode.....ROM|Oops
  a272d0:	2d20 6520 766e 7269 6e6f 656d 746e 6320      - environment c
  a272e0:	6c61 206c 7266 6d6f 5320 6d2d 646f 0d65     all from S-mode.
  a272f0:	000a 0000 4f52 7c4d 6f4f 7370 2d20 6520     ....ROM|Oops - e
  a27300:	766e 7269 6e6f 656d 746e 6320 6c61 206c     nvironment call 
  a27310:	7266 6d6f 5520 6d2d 646f 0d65 000a 0000     from U-mode.....
  a27320:	4f52 7c4d 6f4f 7370 2d20 6920 736e 7274     ROM|Oops - instr
  a27330:	6375 6974 6e6f 6120 6363 7365 2073 6166     uction access fa
  a27340:	6c75 0d74 000a 0000 4f52 7c4d 6f4f 7370     ult.....ROM|Oops
  a27350:	2d20 6920 6c6c 6765 6c61 6920 736e 7274      - illegal instr
  a27360:	6375 6974 6e6f 0a0d 0000 0000 4f52 7c4d     uction......ROM|
  a27370:	6f4f 7370 2d20 6920 736e 7274 6375 6974     Oops - instructi
  a27380:	6e6f 6120 6464 6572 7373 6d20 7369 6c61     on address misal
  a27390:	6769 656e 0d64 000a 4f52 7c4d 6f4f 7370     igned...ROM|Oops
  a273a0:	2d20 6c20 616f 2064 6361 6563 7373 6620      - load access f
  a273b0:	7561 746c 0a0d 0000 4f52 7c4d 6f4f 7370     ault....ROM|Oops
  a273c0:	2d20 6c20 616f 2064 6461 7264 7365 2073      - load address 
  a273d0:	696d 6173 696c 6e67 6465 0a0d 0000 0000     misaligned......
  a273e0:	4f52 7c4d 6f4f 7370 2d20 7320 6f74 6572     ROM|Oops - store
  a273f0:	2820 726f 4120 4f4d 2029 6361 6563 7373      (or AMO) access
  a27400:	6620 7561 746c 0a0d 0000 0000 4f52 7c4d      fault......ROM|
  a27410:	6f4f 7370 2d20 7320 6f74 6572 2820 726f     Oops - store (or
  a27420:	4120 4f4d 2029 6461 7264 7365 2073 696d      AMO) address mi
  a27430:	6173 696c 6e67 6465 0a0d 0000 4f52 7c4d     saligned....ROM|
  a27440:	6f4f 7370 2d20 7520 6b6e 6f6e 6e77 6520     Oops - unknown e
  a27450:	6378 7065 6974 6e6f 0a0d 0000 4f52 7c4d     xception....ROM|
  a27460:	2a2a 2a2a 2a2a 2a2a 2a2a 2a2a 2a2a 7845     **************Ex
  a27470:	6563 7470 6f69 206e 6e49 6f66 6d72 7461     ception Informat
  a27480:	6f69 2a6e 2a2a 2a2a 2a2a 2a2a 2a2a 2a2a     ion*************
  a27490:	202a 000a 4f52 7c4d 7775 7845 5463 7079     * ..ROM|uwExcTyp
  a274a0:	2065 203d 7830 7825 000a 0000 4f52 7c4d     e = 0x%x....ROM|
  a274b0:	656d 6370 2020 2020 2020 3d20 3020 2578     mepc       = 0x%
  a274c0:	0a78 0000 4f52 7c4d 736d 6174 7574 2073     x...ROM|mstatus 
  a274d0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a274e0:	746d 6176 206c 2020 2020 3d20 3020 2578     mtval      = 0x%
  a274f0:	0a78 0000 4f52 7c4d 636d 7561 6573 2020     x...ROM|mcause  
  a27500:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27510:	6363 7561 6573 2020 2020 3d20 3020 2578     ccause     = 0x%
  a27520:	0a78 0000 4f52 7c4d 6172 2020 2020 2020     x...ROM|ra      
  a27530:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27540:	7073 2020 2020 2020 2020 3d20 3020 2578     sp         = 0x%
  a27550:	0a78 0000 4f52 7c4d 7067 2020 2020 2020     x...ROM|gp      
  a27560:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27570:	7074 2020 2020 2020 2020 3d20 3020 2578     tp         = 0x%
  a27580:	0a78 0000 4f52 7c4d 3074 2020 2020 2020     x...ROM|t0      
  a27590:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a275a0:	3174 2020 2020 2020 2020 3d20 3020 2578     t1         = 0x%
  a275b0:	0a78 0000 4f52 7c4d 3274 2020 2020 2020     x...ROM|t2      
  a275c0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a275d0:	3073 2020 2020 2020 2020 3d20 3020 2578     s0         = 0x%
  a275e0:	0a78 0000 4f52 7c4d 3173 2020 2020 2020     x...ROM|s1      
  a275f0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27600:	3061 2020 2020 2020 2020 3d20 3020 2578     a0         = 0x%
  a27610:	0a78 0000 4f52 7c4d 3161 2020 2020 2020     x...ROM|a1      
  a27620:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27630:	3261 2020 2020 2020 2020 3d20 3020 2578     a2         = 0x%
  a27640:	0a78 0000 4f52 7c4d 3361 2020 2020 2020     x...ROM|a3      
  a27650:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27660:	3461 2020 2020 2020 2020 3d20 3020 2578     a4         = 0x%
  a27670:	0a78 0000 4f52 7c4d 3561 2020 2020 2020     x...ROM|a5      
  a27680:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27690:	3661 2020 2020 2020 2020 3d20 3020 2578     a6         = 0x%
  a276a0:	0a78 0000 4f52 7c4d 3761 2020 2020 2020     x...ROM|a7      
  a276b0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a276c0:	3273 2020 2020 2020 2020 3d20 3020 2578     s2         = 0x%
  a276d0:	0a78 0000 4f52 7c4d 3373 2020 2020 2020     x...ROM|s3      
  a276e0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a276f0:	3473 2020 2020 2020 2020 3d20 3020 2578     s4         = 0x%
  a27700:	0a78 0000 4f52 7c4d 3573 2020 2020 2020     x...ROM|s5      
  a27710:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27720:	3673 2020 2020 2020 2020 3d20 3020 2578     s6         = 0x%
  a27730:	0a78 0000 4f52 7c4d 3773 2020 2020 2020     x...ROM|s7      
  a27740:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27750:	3873 2020 2020 2020 2020 3d20 3020 2578     s8         = 0x%
  a27760:	0a78 0000 4f52 7c4d 3973 2020 2020 2020     x...ROM|s9      
  a27770:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27780:	3173 2030 2020 2020 2020 3d20 3020 2578     s10        = 0x%
  a27790:	0a78 0000 4f52 7c4d 3173 2031 2020 2020     x...ROM|s11     
  a277a0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a277b0:	3374 2020 2020 2020 2020 3d20 3020 2578     t3         = 0x%
  a277c0:	0a78 0000 4f52 7c4d 3474 2020 2020 2020     x...ROM|t4      
  a277d0:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a277e0:	3574 2020 2020 2020 2020 3d20 3020 2578     t5         = 0x%
  a277f0:	0a78 0000 4f52 7c4d 3674 2020 2020 2020     x...ROM|t6      
  a27800:	2020 3d20 3020 2578 0a78 0000 4f52 7c4d        = 0x%x...ROM|
  a27810:	2a2a 2a2a 2a2a 2a2a 2a2a 2a2a 2a2a 7845     **************Ex
  a27820:	6563 7470 6f69 206e 6e49 6f66 6d72 7461     ception Informat
  a27830:	6f69 206e 6e65 2a64 2a2a 2a2a 2a2a 2a2a     ion end*********
  a27840:	2a2a 2a2a 202a 000a 4f52 7c4d 6d6e 5f69     ***** ..ROM|nmi_
  a27850:	6168 646e 656c 2072 203a 6e69 6574 7272     handler : interr
  a27860:	7075 2074 6469 5b78 6425 0a5d 0000 0000     upt idx[%d].....
  a27870:	4f52 7c4d 705b 6e61 6369 695d 3a64 6425     ROM|[panic]id:%d
  a27880:	632c 646f 3a65 7830 7825 632c 6c61 3a6c     ,code:0x%x,call:
  a27890:	7830 7825 0000 0000 569a 00a2 56c8 00a2     0x%x.....V...V..
  a278a0:	56dc 00a2 5722 00a2 5780 00a2 5784 00a2     .V.."W...W...W..
  a278b0:	57c2 00a2 58da 00a2                         .W...X..

00a278b8 <g_itoaLowerDigits>:
  a278b8:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef
  a278c8:	0078 0000                                   x...

00a278cc <g_itoaUpperDigits>:
  a278cc:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF
  a278dc:	0058 0000                                   X...

00a278e0 <stateTable.1749>:
	...
  a27900:	0006 0600 0100 0000 0000 0603 0600 0002     ................
  a27910:	0504 0505 0505 0505 0505 0000 0000 0000     ................
  a27920:	0000 0800 0800 0808 0700 0000 0007 0007     ................
  a27930:	0000 0800 0000 0000 0008 0007 0000 0000     ................
  a27940:	0000 0800 0808 0808 0807 0007 0007 0800     ................
  a27950:	0708 0800 0807 0700 0008 0007 0000 0000     ................
	...
  a279e0:	0800 0808 0808 0008 0100 0800 0808 0808     ................
  a279f0:	0001 0400 0404 0808 0008 0000 0303 0508     ................
  a27a00:	0808 0000 0200 0302 0505 0008 0000 0303     ................
  a27a10:	0503 0805 0000 0200 0202 0808 0008 0000     ................
  a27a20:	0606 0606 0606 0000 0700 0707 0707 0007     ................
  a27a30:	0000 0000                                   ....
