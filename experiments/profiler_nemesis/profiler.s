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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set up the registers and memory addresses used by the profiled instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
value_setup .macro target
    mov target, &RAM_LOCATION
    mov target, &FRAM_LOCATION
    mova target, r6
    mova target, r5
    .endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; start an interrupt timer that will hit after the nop slide and an additional `br` instruction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start_interrupt_timer_with_delay .macro
    mov #0x4, &TA0CTL
    mov #0x10, &TA0CCR0
    mov #0x216, &TA0CTL
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    .endm

    .sect ".data"
RAM_LOCATION:
    .word 0

    .sect ".TI.persistent"
FRAM_LOCATION:
    .word 0
    .word 0

    ; .sect ".text"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; space to save latencies of one-word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
latencies_1:
    .space 250

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; fake stack management for the profiled instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
saved_r1:
    .word 0
    .word 0

fake_stack:
    .space 500

realign_sp .macro
    mova #fake_stack+250, r1
    .endm

save_sp .macro
    mova r1, &saved_r1
    realign_sp
    .endm

restore_sp .macro
    mova &saved_r1, r1
    .endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; profiling code starts here: iteratively goes through all 1-, 2-, and 3- word instructions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .sect ".att_ram_code"
profile:

profile_1_word:
    ; set up stack, registers
    save_sp
    mova #latencies_1, r10  ; r10: location to write latency
    mova #one_word, r11     ; r11: location to jump to
    mova #2, r12            ; r12: current word length
    mova #continue_1, r13   ; r13: location to jump to after ISR
continue_1:
    cmpa #end_one_word, r11 ; jump to the next profiling step when reaching the last 1-word instruction
    jeq profile_2_word
    nop
    eint
    nop
    value_setup #FRAM_LOCATION
    realign_sp
    start_interrupt_timer_with_delay

    bra r11

profile_2_word:
    ; set up stack, registers
    restore_sp
    save_sp
    mova #latencies_2, r10  ; r10: location to write latency
    mova #two_word, r11     ; r11: location to jump to
    mova #4, r12            ; r12: current word length
    mova #continue_2, r13   ; r13: location to jump to after ISR
continue_2:
    cmpa #end_two_word, r11 ; jump to the next profiling step when reaching the last 2-word instruction
    jeq profile_3_word
    nop
    eint
    nop
    value_setup #FRAM_LOCATION
    realign_sp
    start_interrupt_timer_with_delay

    bra r11

profile_3_word:
    ; set up stack, registers
    restore_sp
    save_sp
    mova #latencies_3, r10  ; r10: location to write latency
    mova #three_word, r11   ; r11: location to jump to
    mova #6, r12            ; r12: current word length
    mova #continue_3, r13   ; r13: location to jump to after ISR
continue_3:
    cmpa #end_three_word, r11 ; jump to the end when reaching the last 3-word instruction
    jeq end
    nop
    eint
    nop
    value_setup #FRAM_LOCATION
    realign_sp
    start_interrupt_timer_with_delay

    bra r11

end:
    restore_sp
    reta

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; interrupt handler that executes after every profiled instruction, saving the obtained timing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
irq_handler:
    mov #0x0, &TA0CTL
    mov &TA0R, 0(r10) ; save timer value
    adda #2, r10
    adda r12, r11   ; previous target + increment = next target
    adda #8, r1     ; compensate for lost stack space
    nop
    eint
    nop
    bra r13
    nop


    .sect ".int44"
iv_45:
    .word irq_handler
