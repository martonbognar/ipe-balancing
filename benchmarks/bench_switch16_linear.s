	.global switch16_linear
    .include "reta_or_ret.s"

    .sect ".switch16_linear"

switch16_linear:                          ; @switch16_case
; %bb.0:
	sub	#4, r1
	mov.b	r12, 3(r1)
	mov.b	3(r1), r12
	cmp.b	#1, r12
	mov	r2, r12
	rra	r12
	and	#1, r12
	mov	r12, 0(r1)
	mov	0(r1), r13
	clr	r12
	clr	r14
	sub	r13, r14
	and	#1, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#2, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#2, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#3, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#3, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#4, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#4, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#5, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#5, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#6, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#6, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#7, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#7, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#8, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#8, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#9, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#9, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#10, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#10, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#11, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#11, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#12, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#12, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#13, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#13, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#14, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#14, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#15, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	clr	r14
	sub	r13, r14
	and	#15, r14
	mov.b	2(r1), r15
	add	#-1, r13
	and	r13, r15
	bis	r15, r14
	mov.b	r14, 2(r1)
	mov.b	3(r1), r13
	cmp.b	#16, r13
	mov	r2, r13
	rra	r13
	and	#1, r13
	mov	r13, 0(r1)
	mov	0(r1), r13
	sub	r13, r12
	and	#16, r12
	mov.b	2(r1), r14
	add	#-1, r13
	and	r13, r14
	bis	r14, r12
	mov.b	r12, 2(r1)
	mov.b	2(r1), r12
	add	#4, r1
    reta_or_ret
