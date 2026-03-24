	.global mulmod8_linear
    .include "reta_or_ret.s"

    .sect ".mulmod8_linear"

mulmod8_linear:                          ; @mulmod8_enter
; %bb.0:
	push	r10
	sub	#18, r1
	mov	r12, 16(r1)
	mov	r13, 14(r1)
	mov.b	16(r1), r12
	mov	r12, 16(r1)
	mov.b	14(r1), r12
	mov	r12, 14(r1)
	mov	16(r1), r12
	tst	r12
	mov	r2, r12
	rra	r12
	and	#1, r12
	mov	r12, 10(r1)
	mov	14(r1), r13
	mov	#257, r12
	mov	#257, r14
	sub	r13, r14
	mov	10(r1), r13
	clr	r10
	clr	r15
	sub	r13, r15
	and	r15, r14
	mov	16(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov	r14, 16(r1)
	mov	14(r1), r13
	tst	r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 8(r1)
	mov	16(r1), r13
	sub	r13, r12
	mov	8(r1), r14
	clr	r15
	sub	r14, r15
	and	r15, r12
	add	#-1, r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 16(r1)
	mov	16(r1), r12
	tst	r12
	mov	r2, r12
	rra	r12
	mov	14(r1), r13
	tst	r13
	mov	r2, r13
	rra	r13
	inv	r13
	bic	r12, r13
	and	#1, r13
	mov	r13, 6(r1)
	mov	6(r1), r12
	clr	r13
	sub	r12, r13
	mov	r13, 4(r1)
	mov	4(r1), r12
	inv	r12
	mov	r12, 2(r1)
	mov	16(r1), r12
	mov	14(r1), r13
	call	#__mspabi_mpyi_mulmod8_l
	mov	4(r1), r13
	and	r13, r12
	mov	12(r1), r13
	mov	2(r1), r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 12(r1)
	mov.b	12(r1), r12
	mov.b	4(r1), r13
	and	r13, r12
	mov	14(r1), r13
	mov	2(r1), r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 14(r1)
	mov	12(r1), r12
	swpb	r12
	sxt	r12
	mov	4(r1), r13
	and	r13, r12
	mov	16(r1), r13
	mov	2(r1), r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 16(r1)
	mov	14(r1), r12
	mov	16(r1), r13
	sub	r13, r12
	and	#-32768, r12
	mov	r12, 0(r1)
	mov	14(r1), r12
	mov	16(r1), r13
	sub	r13, r12
	mov	4(r1), r14
	and	r14, r12
	mov	2(r1), r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 16(r1)
	mov	0(r1), r12
	sub	r12, r10
	and	#1, r10
	mov	16(r1), r12
	add	r10, r12
	mov	r12, 16(r1)
	mov.b	16(r1), r12
	add	#18, r1
	pop	r10
    reta_or_ret

__mspabi_mpyi_mulmod8_l:
	CMP.W	#0, R13
  JGE	.MPY2
	MOV.B	#0, R14
	SUB.W	R13, R14
	MOV.W	R14, R13
	MOV.B	#1, R11
  JMP .MPY3
.MPY3:
	MOV.B	#16, R15
	MOV.B	#0, R14
.MPY6:
	BIT.W	#1, R13
  JEQ	.MPY4
	ADD.W	R12, R14
	JMP .MPY5
.MPY5:
	ADD.W	R12, R12
	RRA.W	R13
	ADD.B	#-1, R15
	AND	#0xff, R15
	CMP.W	#0, R15
  JNE	.MPY6
	CMP.W	#0, R11
  JEQ	.MPY1
	MOV.B	#0, R12
	SUB.W	R14, R12
	MOV.W	R12, R14
  JMP .MPY7
.MPY1:
	MOV.W R9, R9
	MOV.W R9, R9
	MOV.W R9, R9
  JMP .MPY7
.MPY7:
	MOV.W	R14, R12
	RET
.MPY2:
	MOV.W R9, R9
	MOV.W R9, R9
	MOV.W R9, R9
	MOV.B	#0, R11
	JMP	.MPY3
.MPY4:
	MOV.B R9, R9
	JMP	.MPY5
