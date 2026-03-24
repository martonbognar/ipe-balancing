# Benchmarks

This project contains benchmarks from prior work ([1], [2]), which can be run on the microcontroller to evaluate the performance and the security of the balancing approach.

## Structure

The benchmark suite is made up of the following programs: `bsl`, `mulhi3`, `mulmod8`, `sharevalue`, `switch16`, and `switch8`.
For each program, we have three variants, `<name>` is the baseline vulnerable code, `<name>.linear` is the version linearized using the compiler from prior work, and `<name>.balanced` is the version balanced using our approach.
The different variants are found in the `bench_<name>_<variant>.s` assembly files.
Moreover, `main.c` contains the test setup, which runs the benchmarks with different inputs and reports the results.

## Options

`main.c` also contains two flags at the top: `check_correctness` and `high_frequency`.
The first flag enables comparing the results of the benchmarks to find functional errors.
During our analysis, we discovered incorrect results in the benchmarks obtained from prior work, we are currently investigating these.
The second flag increases the frequency of the device to make the effects of the cache visible.

## Running the code

For instructions on running the benchmarks, please refer to the [top-level README](../README.md), particularly regarding the necessary change in `reta_or_ret.s`.
