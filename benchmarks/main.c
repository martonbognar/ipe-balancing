#include <msp430.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

const bool check_correctness = false;
const bool high_frequency = false;

char bsl(char *);
char bsl_linear(char *);
char bsl_balanced(char *);

int mulhi3(int, int);
int mulhi3_linear(int, int);
int mulhi3_balanced(int, int);

int mulmod8(int, int);
int mulmod8_linear(int, int);
int mulmod8_balanced(int, int);

int sharevalue(int[], int[], int);
int sharevalue_linear(int[], int[], int);
int sharevalue_balanced(int[], int[], int);

int switch16(int);
int switch16_linear(int);
int switch16_balanced(int);

int switch8(int);
int switch8_linear(int);
int switch8_balanced(int);

#define size (4 * 2 * 2)  // 4 words * 2 ways * 2 sets
volatile int dummy_array[size] = {0};

inline void evict(void) {
  int i;
  for (i = 0; i < size; ++i) {
    if (dummy_array[i] != 33) {
      dummy_array[i] = 33;
    }
  }
}

inline void timer_start() {
  TA0CTL = 0x4;
  TA0CTL = 0x224;
}

inline int timer_value() {
  TA0CTL = 0;
  return TA0R;
}

void run_bsl() {
  int baseline_res, linear_res, balanced_res;
  int baseline_tim, linear_tim, balanced_tim;

  char password[] = "0123456789ABCDEF";

  evict();
  timer_start();
  baseline_res = bsl(password);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = bsl_linear(password);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = bsl_balanced(password);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("bsl 1:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  password[2] = 'X';

  evict();
  timer_start();
  baseline_res = bsl(password);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = bsl_linear(password);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = bsl_balanced(password);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("bsl 2:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  password[7] = 'X';
  password[8] = 'X';

  evict();
  timer_start();
  baseline_res = bsl(password);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = bsl_linear(password);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = bsl_balanced(password);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("bsl 3:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  password[10] = 'X';
  password[11] = 'X';

  evict();
  timer_start();
  baseline_res = bsl(password);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = bsl_linear(password);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = bsl_balanced(password);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("bsl 4:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);
}

void run_mulhi3() {
  int baseline_res, linear_res, balanced_res;
  int baseline_tim, linear_tim, balanced_tim;

  evict();
  timer_start();
  baseline_res = mulhi3(0, 0);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulhi3_linear(0, 0);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulhi3_balanced(0, 0);
  balanced_tim = timer_value();

  if (check_correctness) {
    // if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    // }
  }

  printf("mulhi3 1:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  evict();
  timer_start();
  baseline_res = mulhi3(1, 1);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulhi3_linear(1, 1);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulhi3_balanced(1, 1);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("mulhi3 2:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  evict();
  timer_start();
  baseline_res = mulhi3(3, 63);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulhi3_linear(3, 63);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulhi3_balanced(3, 63);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("mulhi3 3:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  evict();
  timer_start();
  baseline_res = mulhi3(3, 255);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulhi3_linear(3, 255);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulhi3_balanced(3, 255);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("mulhi3 4:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);
}

void run_mulmod8() {
  int baseline_res, linear_res, balanced_res;
  int baseline_tim, linear_tim, balanced_tim;

  evict();
  timer_start();
  baseline_res = mulmod8(512, 5);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulmod8_linear(512, 5);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulmod8_balanced(512, 5);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("mulmod8 1:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  evict();
  timer_start();
  baseline_res = mulmod8(5, 512);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulmod8_linear(5, 512);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulmod8_balanced(5, 512);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("mulmod8 2:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  evict();
  timer_start();
  baseline_res = mulmod8(127, 5);
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = mulmod8_linear(127, 5);
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = mulmod8_balanced(127, 5);
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("mulmod8 3:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);
}

void run_sharevalue() {
  int baseline_res, linear_res, balanced_res;
  int baseline_tim, linear_tim, balanced_tim;

  int ids1[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  int ids2[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 42};
  int qty[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

  evict();
  timer_start();
  baseline_res = sharevalue(ids1, qty, sizeof(ids1) / sizeof(ids1[0]));
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = sharevalue_linear(ids1, qty, sizeof(ids1) / sizeof(ids1[0]));
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = sharevalue_balanced(ids1, qty, sizeof(ids1) / sizeof(ids1[0]));
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("sharevalue 1:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);

  evict();
  timer_start();
  baseline_res = sharevalue(ids2, qty, sizeof(ids2) / sizeof(ids2[0]));
  baseline_tim = timer_value();

  evict();
  timer_start();
  linear_res = sharevalue_linear(ids2, qty, sizeof(ids2) / sizeof(ids2[0]));
  linear_tim = timer_value();

  evict();
  timer_start();
  balanced_res = sharevalue_balanced(ids2, qty, sizeof(ids2) / sizeof(ids2[0]));
  balanced_tim = timer_value();

  if (check_correctness) {
    if (baseline_res != linear_res || linear_res != balanced_res) {
      printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
    }
  }

  printf("sharevalue 2:\t Baseline %d, Linear %d, Balanced %d\n", baseline_tim, linear_tim, balanced_tim);
}

void run_switch16() {
  int baseline_res, linear_res, balanced_res;
  int baseline_tim, linear_tim, balanced_tim;

  int param;
  for (param = 0; param <= 16; ++param) {
    evict();
    timer_start();
    baseline_res = switch16(param);
    baseline_tim = timer_value();

    evict();
    timer_start();
    linear_res = switch16_linear(param);
    linear_tim = timer_value();

    evict();
    timer_start();
    balanced_res = switch16_balanced(param);
    balanced_tim = timer_value();

    if (check_correctness) {
      if (baseline_res != linear_res || linear_res != balanced_res) {
        printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
      }
    }

    printf("switch16 %d:\t Baseline %d, Linear %d, Balanced %d\n", param, baseline_tim, linear_tim, balanced_tim);
  }
}

void run_switch8() {
  int baseline_res, linear_res, balanced_res;
  int baseline_tim, linear_tim, balanced_tim;

  int param;
  for (param = 0; param <= 16; ++param) {
    evict();
    timer_start();
    baseline_res = switch8(param);
    baseline_tim = timer_value();

    evict();
    timer_start();
    linear_res = switch8_linear(param);
    linear_tim = timer_value();

    evict();
    timer_start();
    balanced_res = switch8_balanced(param);
    balanced_tim = timer_value();

    if (check_correctness) {
      if (baseline_res != linear_res || linear_res != balanced_res) {
        printf("Incorrect result! (%d, %d, %d)\n", baseline_res, linear_res, balanced_res);
      }
    }

    printf("switch8 %d:\t Baseline %d, Linear %d, Balanced %d\n", param, baseline_tim, linear_tim, balanced_tim);
  }
}

void main(void) {
  WDTCTL = WDTPW | WDTHOLD; // stop watchdog timer

  CSCTL0_H = PMMPW_H;
  FRCTL0 = FRCTLPW | NWAITS_0;
  CSCTL1 = DCOFSEL_2;

  if (high_frequency) {
    // increase frequency to make cache visible
    FRCTL0 = FRCTLPW | NWAITS_1;
    CSCTL1 = DCORSEL | DCOFSEL_4;
    CSCTL3 = DIVS_0 | DIVM_0;
  }

  run_bsl();
  run_mulhi3();
  run_mulmod8();
  run_sharevalue();
  run_switch16();
  run_switch8();
}
