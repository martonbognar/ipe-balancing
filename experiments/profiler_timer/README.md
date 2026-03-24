# Timer profiler

This project profiles the latency of all instructions using basic timer measurements.
The profiled instructions are stored in the `<size>-word.s` assembly files, grouped by word size of the instruction.
For each instruction, the script in `profiler.s` copies it between two instructions that perform the timer measurement.
For an example output, see [`output.txt`](./output.txt).

To match these traces with the instructions and compare with other timing sources, see [the README of the `scripts` directory](../../scripts/README.md).
