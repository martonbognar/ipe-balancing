    .global TA0R
    .global TA0CCTL0
    .global TA0CCR0
    .global TA0CTL

    .global RAM_LOCATION, FRAM_LOCATION

    .global profile
    .global latencies_1
    .global latencies_2
    .global latencies_3

    .global one_word
    .global end_one_word
    .global two_word
    .global end_two_word
    .global three_word
    .global end_three_word

timer_start .macro
    mov #0x4, &TA0CTL
    mov #0x224, &TA0CTL
    .endm

timer_stop .macro
    mov #0, &TA0CTL
    mov &TA0R, r15
    .endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set up the registers and memory addresses used by the profiled instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
value_setup .macro target
    mov target, &RAM_LOCATION
    mov target, &FRAM_LOCATION
    mov target, r6
    mov target, r5
    .endm

    .sect ".data"
RAM_LOCATION:
    .word 0

    .sect ".prof_fram_code"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; space to save latencies of one-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
latencies_1:
    .space 500

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; space to save latencies of two-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
latencies_2:
    .space 500

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; space to save latencies of three-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
latencies_3:
    .space 500

FRAM_LOCATION:
    .word 0
    .space 64

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; fake stack management for the profiled instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
saved_r1:
    .word 0
    .word 0
    .space 64

fake_stack:
    .space 500

save_sp .macro
    mova r1, &saved_r1
    mova #fake_stack+250, r1
    .endm

restore_sp .macro
    mova &saved_r1, r1
    .endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; top-level function to profile all instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
profile:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; profile all one-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
profile_1_word:
    save_sp
    mova #one_word, r12
    mova #latencies_1, r13
loop_1:
    mov @r12, &placeholder_1
    value_setup #FRAM_LOCATION
    timer_start
    nop
placeholder_1:
    .space 2  ;;;; this is where the currently profiled instruction is copied
next_loc_1:
    nop
    timer_stop
    mova r15, 0(r13)
    adda #2, r12
    adda #2, r13
    cmpa #end_one_word, r12 ; jump to the next profiling step when reaching the last 1-word instruction
    jne loop_1
    restore_sp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; profile all two-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
profile_2_word:
    save_sp
    mova #two_word, r12
    mova #latencies_2, r13
loop_2:
    mov @r12, &placeholder_2
    adda #2, r12
    mov @r12, &placeholder_2+2
    value_setup #FRAM_LOCATION
    timer_start
    nop
placeholder_2:
    .space 4  ;;;; this is where the currently profiled instruction is copied
next_loc_2:
    nop
    timer_stop
    mov r15, 0(r13)
    adda #2, r13
    adda #2, r12
    cmpa #end_two_word, r12 ; jump to the next profiling step when reaching the last 2-word instruction
    jne loop_2
    restore_sp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; profile all three-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
profile_3_word:
    save_sp
    mova #three_word, r12
    mova #latencies_3, r13
loop_3:
    mov @r12, &placeholder_3
    adda #2, r12
    mov @r12, &placeholder_2+2
    adda #2, r12
    mov @r12, &placeholder_2+4
    value_setup #FRAM_LOCATION
    timer_start
    nop
placeholder_3:
    .space 6  ;;;; this is where the currently profiled instruction is copied
next_loc_3:
    nop
    timer_stop
    mov r15, 0(r13)
    adda #2, r13
    adda #2, r12
    cmpa #end_three_word, r12 ; jump to the end when reaching the last 3-word instruction
    jne loop_3
    restore_sp

    reta
