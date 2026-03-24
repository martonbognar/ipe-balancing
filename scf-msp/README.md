# SCF-MSP430

Installing the dependencies of the tool:

```bash
$ python3 -m venv .venv
$ source .venv/bin/activate
$ pip install -r requirements.txt
```

## Creating input files

SCF-MSP takes an input file in JSON format.
It contains the path to the binary file, the starting function, a list of the starting function’s parameters and return values.
The parameters are listed in the `parameters` array, with `size` and `confidential` referring to the size and the security level of each function argument in order.
For additional documentation, we refer to the original [SCF-MSP]() repository and paper.
In our work, we used the existing JSON files associated with the benchmarks of Winderix et al.

### Input JSON example

We assume a function `int func(int secret, int public)` in a binary file `compiled.elf`. The corresponding JSON file could be the following:

```json
{
    "file": "compiled.elf",
    "starting_function": "func",
    "timing_sensitive": true,
    "parameters": [
        {
            "size": 1,
            "confidential": true
        },
        {
            "size": 1,
            "confidential": false
        }
    ],
    "memory": false,
    "result": {
        "size": 1,
        "confidential": true,
        "memory": false
    }
}
```

## Running the benchmark

The JSON files for our work are listed in the `ipe_tests` directory.

To run one program:

```bash
$ ./main.py ipe_tests/bsl.balanced.json --debug # or pass --info or --warning or --error
```

To run all (hardened + unhardened) programs:

```bash
$ ./run_all_cache.sh --minimal
```

Run with `--minimal` to suppress the details of the analysis and only print the result.

## Code extensions

For our work, we mostly modified the checks performed on branching instructions in the tool.
In `scfmsp/controlflowanalysis/instructions/AbstractInstructionBranching.py`, we added checks for leakage through the cache or MPU regions between the two sides of the branch (`have_cache` and `have_mpu` methods).
The cache leakage checks make use of our cache model defined in `scfmsp/sidechannelverifier/CacheModel.py`, which tracks the evolution of the cache state.
