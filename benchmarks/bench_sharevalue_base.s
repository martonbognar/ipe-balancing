	.global sharevalue
    .include "reta_or_ret.s"

    .sect ".sharevalue_base"

sharevalue:                       ; @sharevalue_enter
; %bb.0:
	sub	#14, r1
	mov	r12, 12(r1)
	mov	r13, 10(r1)
	mov	r14, 8(r1)
	clr	6(r1)
	clr	4(r1)
	jmp	.LBB0_1
.LBB0_1:                                ; =>This Inner Loop Header: Depth=1
	mov	4(r1), r12
	mov	8(r1), r13
	cmp	r13, r12
	jge	.LBB0_5
	jmp	.LBB0_2
.LBB0_2:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	12(r1), r12
	mov	4(r1), r13
	add	r13, r13
	add	r13, r12
	mov	0(r12), r12
	mov	r12, 2(r1)
	mov	2(r1), r12
	call	#lookupVal
	mov	10(r1), r13
	mov	4(r1), r14
	add	r14, r14
	add	r14, r13
	mov	0(r13), r13
	call	#__mspabi_mpyi_sharevalue
	mov	r12, 0(r1)
	mov	2(r1), r12
	cmp	#42, r12
	jne	.LBB0_4
	jmp	.LBB0_3
.LBB0_3:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	6(r1), r12
	mov	0(r1), r13
	add	r13, r12
	mov	r12, 6(r1)
	jmp	.LBB0_4
.LBB0_4:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	4(r1), r12
	inc	r12
	mov	r12, 4(r1)
	jmp	.LBB0_1
.LBB0_5:
	mov	6(r1), r12
	add	#14, r1
    reta_or_ret

lookupVal:                              ; @lookupVal
; %bb.0:
	sub	#2, r1
	mov	r12, 0(r1)
	mov	#7, r12
	add	#2, r1
	ret

__mspabi_mpyi_sharevalue:
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
	MOV.W R9, R9
	JMP	.MPY5
