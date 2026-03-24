#include <msp430.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include "driverlib.h"

// all test functions and arrays for capturing the results are in `tests.s`

void locality_test(void);
extern uint16_t locality_latencies_start;
uint16_t *locality_latencies = &locality_latencies_start;

void write_tests(void);
extern uint16_t write_latencies_start;
uint16_t *write_latencies = &write_latencies_start;

void replacement_test(void);
extern uint16_t replacement_latencies_start;
uint16_t *replacement_latencies = &replacement_latencies_start;

void code_tests(void);
extern uint16_t code_latencies_start;
uint16_t *code_latencies = &code_latencies_start;

int evict(void) {
    int i;
    int dummy = 0;
    for (i = 0; i < 200; ++i) {
        dummy += *((int *) 0x5500 + i);
    }
    return dummy;
}

void main (void)
{
    WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer

    CSCTL0_H = PMMPW_H;
    FRCTL0 = FRCTLPW | NWAITS_0;
    CSCTL1 = DCOFSEL_2;

    // increase frequency to make cache visible
    FRCTL0 = FRCTLPW | NWAITS_1;
    CSCTL1 = DCORSEL | DCOFSEL_4;
    CSCTL3 = DIVS_0 | DIVM_0;

    locality_test();
    replacement_test();
    write_tests();
    code_tests();

    char locality_result[60] = "Locality results:";
    char replacement_result[30] = "Replacement results:";
    char write_result[50] = "Write results:";
    char code_result[50] = "Code results:";

    int i = 0;
    int num_result = 12;
    for (i = 0; i < num_result; ++i) {
        char buf[3];
        sprintf(buf, " %d", locality_latencies[i]);
        strcat(locality_result, buf);
        if (i % 4 == 3 && i != num_result - 1) {
            strcat(locality_result, " |");
        }
    }
    puts(locality_result);

    for (i = 0; i < 2; ++i) {
        char buf[3];
        sprintf(buf, " %d", replacement_latencies[i]);
        strcat(replacement_result, buf);
    }
    puts(replacement_result);

    for (i = 0; i < 3; ++i) {
        char buf[3];
        sprintf(buf, " %d", write_latencies[i]);
        strcat(write_result, buf);
    }
    puts(write_result);

    num_result = 12;
    for (i = 0; i < 12; ++i) {
        char buf[3];
        sprintf(buf, " %d", code_latencies[i]);
        strcat(code_result, buf);
        if (i == 3 || i == 7 || i == 9) {
            strcat(code_result, " |");
        }
    }
    puts(code_result);
}
