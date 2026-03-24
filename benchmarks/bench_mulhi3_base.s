	.global mulhi3
    .include "reta_or_ret.s"

    .sect ".mulhi3_base"

mulhi3:                           ; @mulhi3_enter
; %bb.0:
	sub	#10, r1
	mov	r12, 8(r1)
	mov	r13, 6(r1)
	clr	2(r1)
	clr	0(r1)
	mov	6(r1), r12
	tst	r12
	jge	.LBB0_2
	jmp	.LBB0_1
.LBB0_1:
	mov	6(r1), r12
	clr	r13
	sub	r12, r13
	mov	r13, 6(r1)
	mov	#1, 2(r1)
	jmp	.LBB0_2
.LBB0_2:
	clr.b	5(r1)
	jmp	.LBB0_3
.LBB0_3:                                ; =>This Inner Loop Header: Depth=1
	mov.b	5(r1), r12
	sxt	r12
	cmp	#16, r12
	jhs	.LBB0_10
	jmp	.LBB0_4
.LBB0_4:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	6(r1), r12
	tst	r12
	jeq	.LBB0_8
	jmp	.LBB0_5
.LBB0_5:                                ;   in Loop: Header=BB0_3 Depth=1
	mov.b	6(r1), r12
	bit.b	#1, r12
	jeq	.LBB0_7
	jmp	.LBB0_6
.LBB0_6:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r12
	mov	0(r1), r13
	add	r12, r13
	mov	r13, 0(r1)
	jmp	.LBB0_7
.LBB0_7:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r12
	add	r12, r12
	mov	r12, 8(r1)
	mov	6(r1), r12
	rra	r12
	mov	r12, 6(r1)
	jmp	.LBB0_8
.LBB0_8:                                ;   in Loop: Header=BB0_3 Depth=1
	jmp	.LBB0_9
.LBB0_9:                                ;   in Loop: Header=BB0_3 Depth=1
	mov.b	5(r1), r12
	inc.b	r12
	mov.b	r12, 5(r1)
	jmp	.LBB0_3
.LBB0_10:
	mov	2(r1), r12
	tst	r12
	jeq	.LBB0_12
	jmp	.LBB0_11
.LBB0_11:
	mov	0(r1), r13
	clr	r12
	sub	r13, r12
	jmp	.LBB0_13
.LBB0_12:
	mov	0(r1), r12
	jmp	.LBB0_13
.LBB0_13:
	add	#10, r1
    reta_or_ret
