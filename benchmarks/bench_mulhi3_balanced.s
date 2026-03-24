	.global mulhi3_balanced
    .include "reta_or_ret.s"

    .sect ".mulhi3_balanced"

	.space 4
mulhi3_balanced:                           ; @mulhi3_enter
; %bb.0:
	sub	#10, r1
	mov	r12, 8(r1)
	mov	r13, 6(r1)
	clr	2(r1)
	clr	0(r1)
	mov	6(r1), r12
	tst	r12
	jge	mulhi3_trampoline_14
; cache boundary
	jmp	.LBB0_1
mulhi3_trampoline_14:
	jmp .LBB0_14
	nop
	nop
; cache boundary
.LBB0_1:
	mov	6(r1), r12
	clr	r13
	sub	r12, r13
; cache boundary
	mov	r13, 6(r1)
	mov	#1, 2(r1)
; cache boundary
	bic	#42, r3
	jmp	.LBB0_2
	nop
; cache boundary
	nop
	nop
	nop
	nop
; cache boundary
.LBB0_14:
	;bic	#42, r3
	mov	6(r1), r12
	bic	#1, r3
	bic	#1, r3
; cache boundary
	mov	r12, 6(r1)
	mov	#0, 2(r1) ; store to 2(r1)
; cache boundary
	bic	#42, r3
	jmp	.LBB0_2
	nop
; cache boundary
	nop
	nop
	nop
	nop
; cache boundary
.LBB0_2:
	clr.b	5(r1)
.LBB0_3:                                ; =>This Inner Loop Header: Depth=1
	mov.b	5(r1), r12
	sxt	r12
	cmp	#16, r12
	jhs	.LBB0_10 ; loop condition, doesn't need balancing
.LBB0_4:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	6(r1), r12
	tst	r12
	jeq	LBB0_15_trmp
	jmp	.LBB0_5
LBB0_15_trmp:
	jmp .LBB0_15
	nop
	nop
	; maybe space here
.LBB0_15:                               ;   in Loop: Header=BB0_3 Depth=1
	mov	6(r1), r3
	bic	#1, r3
	jmp LBB0_16_trmp
; cache boundary
LBB0_16_trmp:
	jmp	.LBB0_16
	nop
	nop
	nop
; cache boundary
.LBB0_16:                               ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r13
	mov	@r1, r12
; cache boundary
	add r3, r3
	mov r13, 8(r1) ; store to 8(r1)
	mov	r12, 0(r1) ; store to 0(r1)
; cache boundary
	mov	6(r1), r12
	rra r3
	mov	r12, 6(r1) ; store to 6(r1)
; cache boundary
	jmp	.LBB0_18 ; this needs to be balanced with the other two
	nop
	nop
; cache boundary
.LBB0_5:                                ;   in Loop: Header=BB0_3 Depth=1
	mov.b	6(r1), r12
	bit.b	#1, r12
	jeq	mulhi3_trampoline_7
; cache boundary
	jmp	.LBB0_6
mulhi3_trampoline_7:
	jmp .LBB0_7
	nop
	nop
; cache boundary
.LBB0_6:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r12
	mov	0(r1), r13
; cache boundary
	add	r12, r13
	mov r12, 8(r1) ; store to 8(r1)
	mov	r13, 0(r1)
	; cache boundary
	mov	6(r1), r12
	rra r3
	mov	r12, 6(r1) ; store to 6(r1)
; cache boundary
	jmp	.LBB0_17
; cache boundary
	nop
	nop
.LBB0_7:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r12
	mov	@r1, r13
; cache boundary
	add	r12, r12
	mov	r12, 8(r1)
	mov r13, 0(r1) ; store to 0(r1)
; cache boundary
	mov	6(r1), r12
	rra	r12
	mov	r12, 6(r1)
	jmp	.LBB0_18
; cache boundary
	nop
	nop
.LBB0_17:                               ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r12
	add	r12, r12
	mov	r12, 8(r1)
; cache boundary
	mov	6(r1), r12
	rra	r12
	mov	r12, 6(r1)
	jmp	.LBB0_9
	nop
; cache boundary
	nop
	nop
	nop
	nop
.LBB0_18:                               ;   in Loop: Header=BB0_3 Depth=1
	mov	8(r1), r12
	bic	#1, r3
	mov	r12, 8(r1) ; store to 8(r1)
; cache boundary
	mov	6(r1), r12
	bic	#1, r3
	mov	r12, 6(r1) ; store to 6(r1)
	jmp	.LBB0_9
; cache boundary
	nop
	nop
	nop
	nop
	nop
; cache boundary should be here, but it's not
.LBB0_9:                                ;   in Loop: Header=BB0_3 Depth=1
	mov.b	5(r1), r12
	inc.b	r12
	mov.b	r12, 5(r1)
	jmp	.LBB0_3
.LBB0_10:
	mov	2(r1), r12
	nop
	nop
	tst	r12
	jeq	LBB0_12_trmp
	jmp	.LBB0_11
LBB0_12_trmp:
	jmp .LBB0_12
	nop
	nop
.LBB0_11:
	mov	0(r1), r13
	clr	r12
	sub	r13, r12
	jmp	.LBB0_13
	nop
	nop
	nop
	nop
.LBB0_12:
	mov	0(r1), r12
	clr r3
	sub r3, r3
	jmp	.LBB0_13
	nop
	nop
	nop
	nop
.LBB0_13:
	add	#10, r1
    reta_or_ret
