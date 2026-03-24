# Utility scripts

- `calculate_overheads.py`: calculates the benchmark overheads in code size and execution time (see the [top-level README](../README.md) for more details).
- `inst.py`: used to generate the initial list of instructions (`<size>-word.s`) with `-generate`, and checking mismatches in the lengths with `-compare`. You can find an example output in [`compare_output.txt`](./compare_output.txt). This file is used by SCF-MSP to check for timing leakage in binaries based on the profiling results of both the timer and the Nemesis strategies.
