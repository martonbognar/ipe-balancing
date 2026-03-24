    .global switch8_balanced
    .include "reta_or_ret.s"

    .sect ".switch8_balanced"

switch8_balanced:                           ; @switch8_case
; %bb.0:
	sub	#2, r1
	mov.b	r12, 1(r1)
	mov.b	1(r1), r12
; cache boundary
	mov r12, r13
	add	#-1, r12
	add	r12, r12
	mov	.LJTI0_0(r12), r12
	br	r12
	nop
	nop
	nop
	nop
	nop
; cache boundary * 2
.LBB0_2:
	mov #1, r12
	mov #42, r3
	mov r12, 0(r1)
	; mov.b	#1, 0(r1)
	; mov	#42, &dma_dummy_data
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_3:
	mov #2, r12
	mov #42, r3
	mov r12, 0(r1)
	; mov.b	#2, 0(r1)
	; mov	#42, &dma_dummy_data
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_4:
	mov #1, r3
	mov #3, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#3, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_5:
	mov #4, r12
	mov #42, r3
	mov r12, 0(r1)
	; mov.b	#4, 0(r1)
	; mov	#42, &dma_dummy_data
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_6:
	mov #1, r3
	mov #5, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#5, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_7:
	mov #1, r3
	mov #6, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#6, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_8:
	mov #1, r3
	mov #7, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#7, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_9:
	mov #8, r12
	mov #42, r3
	mov r12, 0(r1)
	; mov.b	#8, 0(r1)
	; mov	#42, &dma_dummy_data
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_10:
	mov #1, r3
	mov #9, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#9, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_11:
	mov #1, r3
	mov #10, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#10, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_12:
	mov #1, r3
	mov #11, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#11, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_13:
	mov #1, r3
	mov #12, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#12, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_14:
	mov #1, r3
	mov #13, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#13, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_15:
	mov #1, r3
	mov #14, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#14, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_16:
	mov #1, r3
	mov #15, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#15, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_17:
	mov #1, r3
	mov #16, r12
	mov r12, 0(r1)
	; mov	#1, &dma_dummy_data
	; mov.b	#16, 0(r1)
	; bic	#42, r3
	jmp	.LBB0_18
	nop
	nop
.LBB0_20:
	mov	#1, r3
	mov	#42, r3
	mov r13, 0(r1)
	jmp	.LBB0_18
	nop
	nop
; cache boundary
.LBB0_18:
	mov.b	0(r1), r12
	add	#2, r1
    reta_or_ret


dummy_target:
	.short .LBB0_20
.LJTI0_0:
	.short	.LBB0_2
	.short	.LBB0_3
	.short	.LBB0_4
	.short	.LBB0_5
	.short	.LBB0_6
	.short	.LBB0_7
	.short	.LBB0_8
	.short	.LBB0_9
	.short	.LBB0_10
	.short	.LBB0_11
	.short	.LBB0_12
	.short	.LBB0_13
	.short	.LBB0_14
	.short	.LBB0_15
	.short	.LBB0_16
	.short	.LBB0_17

; dma_dummy_data:
;     .word 0x5
