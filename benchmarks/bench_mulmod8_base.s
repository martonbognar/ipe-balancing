	.global mulmod8
    .include "reta_or_ret.s"

    .sect ".mulmod8_base"

mulmod8:                          ; @mulmod8_enter
; %bb.0:
	sub	#6, r1
	mov	r12, 4(r1)
	mov	r13, 2(r1)
	mov.b	4(r1), r12
	mov	r12, 4(r1)
	mov.b	2(r1), r12
	mov	r12, 2(r1)
	mov	4(r1), r12
	tst	r12
	jne	.LBB0_2
	jmp	.LBB0_1
.LBB0_1:
	mov	2(r1), r12
	mov	#257, r13
	sub	r12, r13
	mov	r13, 4(r1)
	jmp	.LBB0_8
.LBB0_2:
	mov	2(r1), r12
	tst	r12
	jne	.LBB0_4
	jmp	.LBB0_3
.LBB0_3:
	mov	4(r1), r12
	mov	#257, r13
	sub	r12, r13
	mov	r13, 4(r1)
	jmp	.LBB0_7
.LBB0_4:
	mov	4(r1), r12
	mov	2(r1), r13
	call	#__mspabi_mpyi_mulmod8
	mov	r12, 0(r1)
	mov.b	0(r1), r12
	mov	r12, 2(r1)
	mov	0(r1), r12
	swpb	r12
	sxt	r12
	mov	r12, 4(r1)
	mov	2(r1), r14
	mov	4(r1), r15
	mov	r14, r12
	sub	r15, r12
	mov	#1, r13
	cmp	r15, r14
	jl	.LBB0_6
; %bb.5:
	clr	r13
.LBB0_6:
	add	r13, r12
	mov	r12, 4(r1)
	jmp	.LBB0_7
.LBB0_7:
	jmp	.LBB0_8
.LBB0_8:
	mov.b	4(r1), r12
	add	#6, r1
    reta_or_ret

__mspabi_mpyi_mulmod8:
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
