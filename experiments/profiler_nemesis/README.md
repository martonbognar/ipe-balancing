# Nemesis profiler

This project profiles the latency of all instructions using interrupts.
The profiled instructions are stored in the `<size>-word.s` assembly files, grouped by word size of the instruction.
For each instruction, the script in `profiler.s` performs a jump to the instruction, scheduling an interrupt to arrive right after the instruction starts executing.
This way, the interrupt latency will reveal the execution time of the given instruction.
For an example output, see [`output.txt`](./output.txt).

To match these traces with the instructions and compare with other timing sources, see [the README of the `scripts` directory](../../scripts/README.md).
