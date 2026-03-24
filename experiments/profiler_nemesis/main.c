#include "msp430fr5969.h"
#include <msp430.h>
#include <stdio.h>
#include <stdint.h>

// profiling is implemented in `profiler.s`

void profile(void);
extern uint16_t latencies_1;
uint16_t *one_latencies = &latencies_1;
extern uint16_t latencies_2;
uint16_t *two_latencies = &latencies_2;
extern uint16_t latencies_3;
uint16_t *three_latencies = &latencies_3;

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer

    profile();

    unsigned i;

    puts("One word instructions:\n");
    i = 0;
    while (one_latencies[i] != 0) {
        printf("%d\n", one_latencies[i]);
        ++i;
    }

    puts("Two word instructions:\n");
    i = 0;
    while (two_latencies[i] != 0) {
        printf("%d\n", two_latencies[i]);
        ++i;
    }

    puts("Three word instructions:\n");
    i = 0;
    while (three_latencies[i] != 0) {
        printf("%d\n", three_latencies[i]);
        ++i;
    }

    return 0;
}
