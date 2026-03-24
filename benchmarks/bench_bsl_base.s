	.global bsl
    .include "reta_or_ret.s"

    .sect ".bsl_base"

bsl:                      ; @BSL430_unlock_BSL
; %bb.0:
	sub	#10, r1
	mov	r12, 8(r1)
	clr	4(r1)
	mov	#Lstr, 0(r1)
	clr	6(r1)
	jmp	.LBB0_1
.LBB0_1:                                ; =>This Inner Loop Header: Depth=1
	mov	6(r1), r12
	cmp	#17, r12
	jhs	.LBB0_6
	jmp	.LBB0_2
.LBB0_2:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	0(r1), r12
	mov.b	0(r12), r12
	sxt	r12
	mov	8(r1), r13
	mov	6(r1), r14
	add	r14, r13
	mov.b	0(r13), r13
	sxt	r13
	cmp	r13, r12
	jeq	.LBB0_4
	jmp	.LBB0_3
.LBB0_3:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	4(r1), r12
	bis	#64, r12
	mov	r12, 4(r1)
	jmp	.LBB0_4
.LBB0_4:                                ;   in Loop: Header=BB0_1 Depth=1
	jmp	.LBB0_5
.LBB0_5:                                ;   in Loop: Header=BB0_1 Depth=1
	mov	6(r1), r12
	inc	r12
	mov	r12, 6(r1)
	mov	0(r1), r12
	inc	r12
	mov	r12, 0(r1)
	jmp	.LBB0_1
.LBB0_6:
	mov	4(r1), r12
	tst	r12
	jne	.LBB0_8
	jmp	.LBB0_7
.LBB0_7:
	mov	#-23132, &LockedStatus
	clr	2(r1)
	jmp	.LBB0_9
.LBB0_8:
	clr	&LockedStatus
	mov	#5, 2(r1)
	jmp	.LBB0_9
.LBB0_9:
	mov.b	2(r1), r12
	sxt	r12
	add	#10, r1
    reta_or_ret

Lstr:
	.cstring	"0123456789ABCDEF"
LockedStatus:
	.short	0
