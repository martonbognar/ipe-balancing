    .global switch8


    .include "reta_or_ret.s"

    .sect ".switch8_base"

switch8:                           ; @switch8_case
; %bb.0:
        sub     #2, r1
        mov.b   r12, 1(r1)
        mov.b   1(r1), r12
        add     #-1, r12
        cmp     #16, r12
        jhs     .LBB0_18
; %bb.1:
        add     r12, r12
        mov     .LJTI0_0(r12), r12
        br      r12
.LBB0_2:
        mov.b   #1, 0(r1)
        jmp     .LBB0_18
.LBB0_3:
        mov.b   #2, 0(r1)
        jmp     .LBB0_18
.LBB0_4:
        mov.b   #3, 0(r1)
        jmp     .LBB0_18
.LBB0_5:
        mov.b   #4, 0(r1)
        jmp     .LBB0_18
.LBB0_6:
        mov.b   #5, 0(r1)
        jmp     .LBB0_18
.LBB0_7:
        mov.b   #6, 0(r1)
        jmp     .LBB0_18
.LBB0_8:
        mov.b   #7, 0(r1)
        jmp     .LBB0_18
.LBB0_9:
        mov.b   #8, 0(r1)
        jmp     .LBB0_18
.LBB0_10:
        mov.b   #9, 0(r1)
        jmp     .LBB0_18
.LBB0_11:
        mov.b   #10, 0(r1)
        jmp     .LBB0_18
.LBB0_12:
        mov.b   #11, 0(r1)
        jmp     .LBB0_18
.LBB0_13:
        mov.b   #12, 0(r1)
        jmp     .LBB0_18
.LBB0_14:
        mov.b   #13, 0(r1)
        jmp     .LBB0_18
.LBB0_15:
        mov.b   #14, 0(r1)
        jmp     .LBB0_18
.LBB0_16:
        mov.b   #15, 0(r1)
        jmp     .LBB0_18
.LBB0_17:
        mov.b   #16, 0(r1)
        jmp     .LBB0_18
.LBB0_18:
        mov.b   0(r1), r12
        add     #2, r1
    reta_or_ret

.LJTI0_0:
        .short  .LBB0_2
        .short  .LBB0_3
        .short  .LBB0_4
        .short  .LBB0_5
        .short  .LBB0_6
        .short  .LBB0_7
        .short  .LBB0_8
        .short  .LBB0_9
        .short  .LBB0_10
        .short  .LBB0_11
        .short  .LBB0_12
        .short  .LBB0_13
        .short  .LBB0_14
        .short  .LBB0_15
        .short  .LBB0_16
        .short  .LBB0_17
