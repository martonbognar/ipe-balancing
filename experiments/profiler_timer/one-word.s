    .global one_word
    .global end_one_word
    .global RAM_LOCATION, FRAM_LOCATION
    .sect ".TI.persistent"
one_word:
    MOV @r6+,r5
    MOV @r6,r5
    MOV r5,r5
    ADDC @r6+,r5
    ADDC @r6,r5
    ADDC r5,r5
    SUB @r6+,r5
    SUB @r6,r5
    SUB r5,r5
    ADD @r6+,r5
    ADD @r6,r5
    ADD r5,r5
    AND @r6+,r5
    AND @r6,r5
    AND r5,r5
    SUBC @r6+,r5
    SUBC @r6,r5
    SUBC r5,r5
    XOR @r6+,r5
    XOR @r6,r5
    XOR r5,r5
    BIC @r6+,r5
    BIC @r6,r5
    BIC r5,r5
    BIT @r6+,r5
    BIT @r6,r5
    BIT r5,r5
    DADD @r6+,r5
    DADD @r6,r5
    DADD r5,r5
    BIS @r6+,r5
    BIS @r6,r5
    BIS r5,r5
    CMP @r6+,r5
    CMP @r6,r5
    CMP r5,r5
    RRA @r6+
    RRA @r6
    RRA r5
    RRC @r6+
    RRC @r6
    RRC r5
    SXT @r6+
    SXT @r6
    SXT r5
    SWPB @r6+
    SWPB @r6
    SWPB r5
    PUSH @r6+
    PUSH @r6
    PUSH r5
    JMP target_0
target_0:
    JL target_1
target_1:
    JEQ target_2
target_2:
    JN target_3
target_3:
    JNZ target_4
target_4:
    JZ target_5
target_5:
    JGE target_6
target_6:
    JC target_7
target_7:
    JNC target_8
target_8:
    JNE target_9
target_9:
    MOV #1,r5
    ADDC #1,r5
    SUB #1,r5
    ADD #1,r5
    AND #1,r5
    SUBC #1,r5
    XOR #1,r5
    BIC #1,r5
    BIT #1,r5
    DADD #1,r5
    BIS #1,r5
    CMP #1,r5
    PUSH #1
end_one_word:
    nop
