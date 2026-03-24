	.global bsl_linear

    .include "reta_or_ret.s"
    .sect ".bsl_linear"

bsl_linear:                      ; @BSL430_unlock_BSL
; %bb.0:
	sub	#18, r1
	mov	r12, 16(r1)
	clr	12(r1)
	mov	#Lstr, 8(r1)
	clr	14(r1)
	jmp	.LBB0_1
.LBB0_1:                                ; =>This Inner Loop Header: Depth=1
	mov	14(r1), r12
	cmp	#17, r12
	jhs	.LBB0_4
	jmp	.LBB0_2
.LBB0_2:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	8(r1), r12
	mov.b	0(r12), r12
	sxt	r12
	mov	16(r1), r13
	mov	14(r1), r14
	add	r14, r13
	mov.b	0(r13), r13
	sxt	r13
	cmp	r13, r12
	mov	r2, r12
	rra	r12
	mov	#1, r13
	bic	r12, r13
	mov	r13, 6(r1)
	mov	12(r1), r12
	mov	r12, r13
	bis	#64, r13
	mov	6(r1), r14
	clr	r15
	sub	r14, r15
	and	r15, r13
	add	#-1, r14
	and	r14, r12
	bis	r12, r13
	mov	r13, 12(r1)
	jmp	.LBB0_3
.LBB0_3:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	14(r1), r12
	inc	r12
	mov	r12, 14(r1)
	mov	8(r1), r12
	inc	r12
	mov	r12, 8(r1)
	jmp	.LBB0_1
.LBB0_4:
	mov	12(r1), r12
	tst	r12
	mov	r2, r12
	rra	r12
	and	#1, r12
	mov	r12, 4(r1)
	mov	4(r1), r12
	clr	r13
	sub	r12, r13
	mov	r13, 2(r1)
	mov	2(r1), r12
	inv	r12
	mov	r12, 0(r1)
	mov	2(r1), r12
	and	#-23132, r12
	mov	&LockedStatus, r13
	mov	0(r1), r14
	mov	r13, r15
	and	r14, r15
	bis	r15, r12
	bis	r12, r13
	mov	r13, &LockedStatus
	mov	10(r1), r12
	mov	0(r1), r13
	and	r13, r12
	mov	r12, 10(r1)
	mov	&LockedStatus, r12
	mov	0(r1), r13
	mov	r12, r14
	and	r13, r14
	bis	r14, r12
	mov	r12, &LockedStatus
	mov	2(r1), r12
	and	#5, r12
	mov	10(r1), r13
	mov	0(r1), r14
	and	r14, r13
	bis	r13, r12
	mov	r12, 10(r1)
	mov.b	10(r1), r12
	sxt	r12
	add	#18, r1
    reta_or_ret

Lstr:
	.cstring	"0123456789ABCDEF"
LockedStatus:
	.short	0
