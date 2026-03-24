# Cache behavior experiments

This project runs different experiments (from `tests.s`) on the microcontroller to determine the characteristics of the cache.
In this document, we list the experiments and their expected outputs.
Except for the last test, all code runs from RAM to avoid polluting the cache; only data accesses have an impact on the cache state.

In all cases, a latency of 4 cycles represents a cache hit, while 5 signifies a cache miss.

## Locality test

This test accesses words in an array consecutively.
As one cache block is documented to hold four words, we expect every fourth access to take an extra cycle as it fetches the new block into the cache, while all other accesses hit the cached block, resulting in a shorter access time.

Expected output:

```
Locality results: 5 4 4 4 | 5 4 4 4 | 5 4 4 4
```

## Replacement test

This test identifies the replacement policy for the two ways in one cache set.
Two measurements are performed.
First, we access blocks that map to the same set: block 0, block 2, block 0, block 4; then measure access to block 0, which is still cached because it was accessed more recently than block 2.
Second, we perform the same accesses: block 0, block 2, block 0, block 4; then measure access to block 2, which has been evicted by the access to block 4.

Expected output:

```
MSP430: Replacement results: 4 5
```

## Write policy test

This test checks three properties.
First, we write to a block that is currently not cached and check whether this access brings it into the cache.
Second, we bring block 0 into the cache and overwrite a word in it, then check whether it is still in the cache.
Third, we check the effect of stores on the replacement policy.
We access block 0 and block 2, then store to block 2, invalidating it.
Then, we access block 4 and check the access time to block 0 to see if it was replaced in the cache (for being the older entry) or the invalidated block 2.


Expected output:

```
MSP430: Write results: 5 5 5
```

## Code execution test

The last test checks the impact of branch instructions on the cache.
All tests are performed on the following code, located in FRAM:

```
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
```

Expected output of the combined tests:

```
MSP430: Code results: 4 4 5 4 | 4 4 5 4 | 5 4 | 4 4
```

### First test

In the first test, we test a taken forward branch by executing `codeblock0` with a true condition, which will jump to `codeblock3`, the first instruction of which exits the program.
Afterwards, we test the latencies to blocks 0, 1, 2, and 3.
All blocks except for 2 are cached, which shows that block1 was still fetched despite the taken branch.

### Second test

The second test repeats the first setup, but this time the branch is not taken, which makes the program exit already at the start of block 1.
Despite this effect, block 3 is cached, showing that the target of the branch is always fetched.

### Third test

This test starts executing at block b0, testing a backwards jump, which is taken in this case, jumping to block 1.
Afterwards, the access times to block b1 and block 1 are tested, showing that b1 is not cached as the jump was taken.

### Fourth test

This test repeats the third test, but this time the jump is not taken, showing that the target was still fetched, together with block b1 this time.
