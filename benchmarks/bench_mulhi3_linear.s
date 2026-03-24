	.global mulhi3_linear


    .include "reta_or_ret.s"
    .sect ".mulhi3_linear"

mulhi3_linear:                           ; @mulhi3_enter
; %bb.0:
	sub	#26, r1
	mov	r12, 24(r1)
	mov	r13, 22(r1)
	clr	18(r1)
	clr	16(r1)
	clr	14(r1)
	mov	14(r1), r12
	clr	r13
	clr	r14
	sub	r12, r14
	mov	r14, 12(r1)
	mov	12(r1), r12
	inv	r12
	mov	r12, 10(r1)
	mov	22(r1), r12
	sub	r12, r13
	mov	12(r1), r14
	and	r14, r13
	mov	10(r1), r14
	and	r14, r12
	bis	r12, r13
	mov	r13, 22(r1)
	mov	12(r1), r12
	and	#1, r12
	mov	18(r1), r13
	mov	10(r1), r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 18(r1)
	clr.b	21(r1)
	jmp	.LBB0_1
.LBB0_1:                                ; =>This Inner Loop Header: Depth=1
	mov.b	21(r1), r12
	sxt	r12
	cmp	#16, r12
	jhs	.LBB0_4
	jmp	.LBB0_2
.LBB0_2:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	22(r1), r12
	mov	r12, 8(r1)
	mov	22(r1), r13
	mov	8(r1), r14
	clr	r12
	clr	r15
	sub	r14, r15
	and	r15, r13
	and	#1, r13
	mov	r13, 6(r1)
	mov	16(r1), r13
	mov	24(r1), r14
	mov	r13, r15
	add	r14, r15
	mov	6(r1), r14
	clr	r11
	sub	r14, r11
	and	r11, r15
	add	#-1, r14
	bis	r14, r13
	bis	r13, r15
	mov	r15, 16(r1)
	mov	24(r1), r13
	mov	r13, r14
	add	r14, r14
	mov	8(r1), r15
	clr	r11
	sub	r15, r11
	and	r11, r14
	add	#-1, r15
	and	r15, r13
	bis	r13, r14
	mov	r14, 24(r1)
	mov	22(r1), r13
	mov	r13, r14
	rra	r14
	mov	8(r1), r15
	sub	r15, r12
	and	r12, r14
	add	#-1, r15
	and	r15, r13
	bis	r13, r14
	mov	r14, 22(r1)
	jmp	.LBB0_3
.LBB0_3:                                ;   in Loop: Header=BB0_1 Depth=1
	mov.b	21(r1), r12
	inc.b	r12
	mov.b	r12, 21(r1)
	jmp	.LBB0_1
.LBB0_4:
	mov	18(r1), r12
	mov	r12, 4(r1)
	mov	4(r1), r12
	clr	r13
	clr	r14
	sub	r12, r14
	mov	r14, 2(r1)
	mov	2(r1), r12
	inv	r12
	mov	r12, 0(r1)
	mov	16(r1), r12
	sub	r12, r13
	mov	2(r1), r14
	and	r14, r13
	mov	0(r1), r14
	and	r14, r12
	bis	r12, r13
	mov	r13, 16(r1)
	mov	16(r1), r12
	add	#26, r1
    reta_or_ret
