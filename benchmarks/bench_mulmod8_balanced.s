	.global mulmod8_balanced
    .include "reta_or_ret.s"

    .sect ".mulmod8_balanced"

	.space 4

mulmod8_balanced:                          ; @mulmod8_enter
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
	jne dummy_mulmod_2
	jmp	.LBB0_1
dummy_mulmod_2:
	jmp	.LBB0_2
	nop
	nop
; cache boundary
.LBB0_1:
	mov	2(r1), r12
	mov	#257, r13
; cache boundary
	sub	r12, r13
	mov	r13, 4(r1)
	jmp	.LBB0_9
; cache boundary
.LBB0_9:
	jmp nxt9
	nop
	nop
	nop
nxt9:
	mov	4(r1), r12
	bic	#42, r3
	bic	#1, r3
	mov	r12, 4(r1) ; store to 4(r1)
	mov	2(r1), r3
	call	#_ndd___mspabi_mpyi_mb
	mov 0(r1), r12
	mov	r12, 0(r1) ; store to 0(r1)
	mov	0(r1), r3
	mov 2(r1), r12
	mov	r12, 2(r1) ; store to 2(r1)
	mov	@r1, r3
	bic	#1, r3
	bic	#1, r3
	mov 4(r1), r12
	mov	r12, 4(r1) ; store to 4(r1)
	mov	2(r1), r3
	mov	4(r1), r12
	bic	#1, r3
	bic	#1, r3
	bic	#1, r3
	bic	#1, r3
	nop
	jmp	.LBB0_10_c ; 33 w
.LBB0_10_c:
	jmp .LBB0_10
	nop
	nop
	nop
.LBB0_10:
	bic	#1, r3
	bic	#1, r3
	mov	r12, 4(r1) ; store to 4(r1)
	jmp	.LBB0_14

	nop
	nop
	nop
	nop
	nop
	nop
	nop
; this should correspond to _1
.LBB0_2:
	mov	2(r1), r13
	bic	#42, r3
; cache boundary
	tst	r13
	mov	r12, 4(r1) ; store to 4(r1)  (was in r12 before)
	jne	.LBB0_4_tramp
	jmp	.LBB0_3
.LBB0_4_tramp:
	jmp .LBB0_4
	nop
	nop
; this needs to correspond to _4 and _9
.LBB0_3:
	mov	4(r1), r12
	mov	#257, r13
	sub	r12, r13
	mov	r13, 4(r1)
	mov	2(r1), r3
	call	#_ndd___mspabi_mpyi_mb
	mov 0(r1), r12
	mov	r12, 0(r1) ; store to 0(r1)
	mov	0(r1), r3
	mov 2(r1), r12
	mov	r12, 2(r1) ; store to 2(r1)
	mov	@r1, r3
	bic	#1, r3
	bic	#1, r3
	mov 4(r1), r12
	mov	r12, 4(r1) ; store to 4(r1)
	mov	2(r1), r3
	mov	4(r1), r12
	bic	#1, r3
	bic	#1, r3
	bic	#1, r3
	bic	#1, r3
	nop
	jmp	.LBB0_7_c
.LBB0_7_c:
	jmp .LBB0_7
	nop
	nop
	nop
.LBB0_7:
	bic	#1, r3
	bic	#1, r3
	mov	r12, 4(r1) ; store to 4(r1)
	jmp	.LBB0_14
	nop
	nop
	nop
.LBB0_4:
	mov	4(r1), r12
	bic	#42, r3
	bic	#1, r3
	mov	r12, 4(r1) ; store to 4(r1)
	mov	2(r1), r13
	call	#_nds___mspabi_mpyi_mb
	mov 0(r1), r3
	mov	r12, 0(r1)
	mov.b	0(r1), r12
	mov 2(r1), r3
	mov	r12, 2(r1)
	mov	0(r1), r12
	swpb	r12
	sxt	r12
	mov 4(r1), r3
	mov	r12, 4(r1)
	mov	2(r1), r14
	mov	4(r1), r15
	mov	r14, r12
	sub	r15, r12
	mov	#1, r13
	cmp	r15, r14
	nop
	jl	.LBB0_6_dum
	jmp .L6c
.LBB0_6_dum:
	jmp .LBB0_6
	nop
	nop
; %bb.5:
.L6c:
	clr	r13
	add	r13, r12
	mov	r12, 4(r1)
	jmp	.LBB0_14
	nop
	nop
	nop
.LBB0_6:
	add	r13, r12
	bic	#1, r3
	mov	r12, 4(r1)
	jmp	.LBB0_14
	nop
	nop
	nop
.LBB0_14:
	mov.b	4(r1), r12
	add	#6, r1
    reta_or_ret


_ndd___mspabi_mpyi_mb:
_nds___mspabi_mpyi_mb:
	CMP.W	#0, R13
  JGE	.MPY2
	MOV.B	#0, R14
	SUB.W	R13, R14
	MOV.W	R14, R13
	MOV.B	#1, R11
  JMP .MPY3
.MPY2:
	MOV.W R9, R9
	MOV.W R9, R9
	MOV.W R9, R9
	MOV.B	#0, R11
	JMP	.MPY3
.MPY3:
	MOV.B	#16, R15
	MOV.B	#0, R14
.MPY6:
	BIT.W	#1, R13
  JEQ	.MPY4
	ADD.W	R12, R14
	JMP .MPY5
.MPY4:
	MOV.W R9, R9
	JMP	.MPY5
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
