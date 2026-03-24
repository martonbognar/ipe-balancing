    .global TA0R
    .global TA0CCTL0
    .global TA0CCR0
    .global TA0CTL

    .global evict

    .global locality_test
    .global locality_latencies_start

    .global replacement_test
    .global replacement_latencies_start

    .global write_tests
    .global write_latencies_start

    .global code_tests
    .global code_latencies_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro to determine the access time of an address in FRAM
;
; param: register identifier containing the address to load
; returns the latency in r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
access_time_addr_in_reg .macro reg
    mov #0x4, &TA0CTL
    mov #0x224, &TA0CTL
    mov @reg, r15
    mov #0, &TA0CTL
    mov &TA0R, r15
    .endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; start of FRAM block, this is where we put the data we want to reside in the cache
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .sect ".TI.persistent"
block0:
    .space 8
block1:
    .space 8
block2:
    .space 8
block3:
    .space 8
block4:
    .space 8
block5:
    .space 8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; small program in FRAM used to determine the effect of code execution on the cache
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .sect ".text_aligned"
codeblock0:
    cmp r7, r8
    nop
    nop
    jeq codeblock3

codeblock1:
    br r9
    nop
    nop
    nop

codeblock2:
    nop
    nop
    nop
    nop

codeblock3:
    br r9
    nop
    nop
    nop

codeblock_b0:
    cmp r7, r8
    nop
    jeq codeblock1
    nop

codeblock_b1:
    br r9
    nop
    nop
    nop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; start of RAM block, everything else (code + data) that should not affect the cache state comes here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .sect ".test_ram_code"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; experiment results
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

locality_latencies_start:
    .space 24  ; 12 words, storing latencies of 12 consecutive accesses

replacement_latencies_start:
    .space 4   ; 2 words

write_latencies_start:
    .space 6   ; 3 words for (1)+(2)+(3)

code_latencies_start:
    .space 24

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; locality test: access consecutive addresses, see which ones are prefetched
;
; expected output: 5 4 4 4 5 4 4 4 5 ...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
count:
    .word 0
locality_test:
    mov #0, &count
    calla #evict
    mov #block0, r11
locality_loop:
    mov #locality_latencies_start, r14
    add &count, r14
    access_time_addr_in_reg r11
    mov r15, 0(r14)
    add #2, &count
    add #2, r11
    cmp #24, &count
    jne locality_loop
    reta


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; replacement test: simple check for the replacement policy
;
; expected output: 4 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
replacement_test:
    calla #evict

    mov &block0, r3 ; fill in way 0
    mov &block2, r3 ; fill in way 1
    mov &block0, r3 ; refresh way 0
    mov &block4, r3 ; replace one of the ways
    mov #block0, r11
    access_time_addr_in_reg r11 ; check whether original way 0 is cached
    mov r15, &replacement_latencies_start

    calla #evict

    mov &block0, r3 ; fill in way 0
    mov &block2, r3 ; fill in way 1
    mov &block0, r3 ; refresh way 0
    mov &block4, r3 ; replace one of the ways
    mov #block2, r11
    access_time_addr_in_reg r11 ; check whether original way 1 is cached
    mov r15, &replacement_latencies_start+2

    reta

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; write policy test:
; (1) does it fetch written lines into the cache
; (2) does it invalidate lines that are in the cache
; (3) does the cache first refill invalidated lines or stick to the policy based on reads

; expected outputs: (1) 5 (2) 5 (3) 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
write_tests:
    calla #evict

    ; test (1)
    mov #42, &block0 ; store to address
    mov #block0, r11
    access_time_addr_in_reg r11 ; check whether address is cached
    mov r15, &write_latencies_start

    calla #evict

    ; test (2)
    mov &block0, r11 ; cache address
    mov #42, &block0 ; store to address
    mov #block0, r11
    access_time_addr_in_reg r11 ; check whether address is cached
    mov r15, &write_latencies_start+2

    calla #evict

    ; test (3)
    mov &block0, r3 ; fill in way 0
    mov &block2, r3 ; fill in way 1
    mov #42, &block2  ; invalidate way 1
    mov &block4, r3
    mov #block0, r11
    access_time_addr_in_reg r11 ; check whether original way 0 is cached
    mov r15, &write_latencies_start+4

    reta

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; code effect tests:
; see README for description and expected output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code_tests:
    calla #evict

    ; test (1) forward jump taken
    mov #42, r7
    mov #42, r8
    mov #continue_1, r9
    bra #codeblock0

continue_1:
    ; test values
    mova #codeblock0, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start
    mova #codeblock1, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+2
    mova #codeblock2, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+4
    mova #codeblock3, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+6

    calla #evict

    ; test (2) forward jump not taken
    mov #42, r7
    mov #43, r8
    mov #continue_2, r9
    bra #codeblock0

continue_2:
    ; test values
    mova #codeblock0, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+8
    mova #codeblock1, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+10
    mova #codeblock2, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+12
    mova #codeblock3, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+14

    calla #evict

    ; test (3) backward jump taken
    mov #42, r7
    mov #42, r8
    mov #continue_b1, r9
    bra #codeblock_b0

continue_b1:
    mova #codeblock_b1, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+16
    mova #codeblock1, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+18

    calla #evict

    ; test (4) backward jump not taken
    mov #42, r7
    mov #43, r8
    mov #continue_b2, r9
    bra #codeblock_b0

continue_b2:
    mova #codeblock_b1, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+20
    mova #codeblock1, r11
    access_time_addr_in_reg r11
    mov r15, &code_latencies_start+22

    reta
