# Control-Flow Balancing for Texas Instruments IPE

This repository contains the code for our paper "Control-Flow Balancing for Texas Instruments IPE", published at SysTEX'26.
The code is split into four directories:

- `benchmarks`: the project running performance benchmarks on the microcontroller.
- `experiments`: reverse engineering and profiling experiments.
- `scf-msp`: the source code of the extended binary analysis tool.
- `scripts`: Python utility scripts for the evaluation.

We tested all our experiments on the MSP430FR5969 chip.

## Installation

- For building and running experiments on the microcontroller, you need to install the Texas Instruments [CCS IDE](https://www.ti.com/tool/CCSTUDIO#downloads). We tested our projects with version 20.4.1., but expect newer versions to also be compatible.
- For SCF-MSP, you need an installation of Python 3, optionally creating a virtual environment:
   ```shell-session
   python3 -m venv .venv
   source .venv/bin/activate
   ```

   Afterwards, install the package dependencies as follows:
   ```shell-session
   pip install -r scf-msp/requirements.txt
   ```

## Security and performance evaluation

To run the performance evaluation, you need to build the [`benchmarks`](./benchmarks/) project in CCS.
This is sufficient to measure the code size and to run the security evaluation.

### Benchmarks

We use a subset of the benchmarks from Winderix et al., the programs `bsl`, `mulhi3`, `mulmod8`, `sharevalue`, `switch16`, and `switch8`.
For each program, we have three variants, `<name>` is the baseline vulnerable code, `<name>.linear` is the version linearized using the compiler of Winderix et al., and `<name>.balanced` is the version balanced using our approach.

### Security validation

After the build, the security evaluation can be run from the `scf-msp` directory using the command below:

```shell-session
(.venv) user@host:~$ cd scf-msp
(.venv) user@host:~/scf-msp$ ./run_all_cache.sh --minimal
             ipe_tests/bsl.balanced.json	Architectural 🗲
                      ipe_tests/bsl.json	Cache 🗲
               ipe_tests/bsl.linear.json	Architectural 🗲
          ipe_tests/mulhi3.balanced.json	Architectural 🗲
                   ipe_tests/mulhi3.json	Cache 🗲
            ipe_tests/mulhi3.linear.json	Architectural 🗲
         ipe_tests/mulmod8.balanced.json	Architectural 🗲
                  ipe_tests/mulmod8.json	Cache 🗲
           ipe_tests/mulmod8.linear.json	Architectural 🗲
      ipe_tests/sharevalue.balanced.json	Architectural 🗲
               ipe_tests/sharevalue.json	Cache 🗲
        ipe_tests/sharevalue.linear.json	Architectural 🗲
        ipe_tests/switch16.balanced.json	Architectural 🗲
                 ipe_tests/switch16.json	Cache 🗲
          ipe_tests/switch16.linear.json	Architectural 🗲
         ipe_tests/switch8.balanced.json	Architectural 🗲
                  ipe_tests/switch8.json	Cache 🗲
           ipe_tests/switch8.linear.json	Architectural 🗲
```

The expected output shows cache leakage for all baseline benchmarks, but not for the linearized or balanced versions.
For the purposes of our paper, the other warnings of SCF-MSP can be ignored.

The analysis can also be run on a single benchmark by passing its JSON configuration to the `scf-msp/main.py` file.
The JSON configurations specify the name of the analyzed function and the security labels of its arguments.

```shell-session
(.venv) user@host:~/scf-msp$ ./main.py ipe_tests/switch16.linear.json
          ipe_tests/switch16.linear.json        {
  "result": "INFORMATION_LEAK",
  "result_code": 1,
  "execution_point": null,
  "unique_ret": "True"
}
```

For more details on the usage of SCF-MSP and our extensions to it, see [`scf-msp/README.md`](scf-msp/README.md).

### Code size and execution time

For convenience, we provide the script `scripts/calculate_overheads.py` that recreates Table 1 from our paper based on the memory map in `benchmarks/Debug/benchmarks.map` (size) and the sample output of running the benchmarks in `benchmarks/output.txt` (speed).

```shell-session
user@host:~$ ./scripts/calculate_overheads.py
                  Binary size            Execution time
Name          Vuln.   Lin.   Bal.      Vuln.     Lin.   Bal.
------------------------------------------------------------------------
bsl             162    270    202        880     1295    946
mulhi3          166    308    398        789     1639   1202
mulmod8         232    424    498         92      493    372
sharevalue      230    252    252        234     3523   3423
switch16        184    670    346         41      429     40
switch8         184    670    344         41      429     40
------------------------------------------------------------------------
overhead              2.08x  1.71x               5.48x  2.13x
```

## Running code on the microcontroller

To build and run the projects on the microcontroller, we use the Texas Instruments CCS IDE.
To open projects in the IDE, open the application, then choose `File -> Import Projects...` and open the directory of the project you would like to use (e.g., `benchmarks`).
Once the project is open, it can be built with `Project -> Build All` or run on the microcontroller with `Run -> Debug Project`.

For more details on the different projects, please refer to the `README.md` files included in their directories.

> [!WARNING]
> Due to some limitations of SCF-MSP, the benchmark code needs to be modified before it can run on the board. Open [`benchmarks/reta_or_ret.s`](./benchmarks/reta_or_ret.s), and change the `ret` instruction to `reta`. Afterwards, run `Project -> Clean Projects`. Now, the project can be loaded to the board with `Run -> Debug Project`. To run the security analysis again, you need to change the instruction back to `ret` and run `Project -> Clean Projects`, followed by `Project -> Build All`.

## Reverse engineering and profiling

The `experiments` directory contains three projects: `cache_behavior` showcases our reverse engineering efforts of the cache's behavior, and `profiler_nemesis` and `profiler_timer` show how we applied the existing profiling approach to our black-box setting.
All projects contain a `README.md` and an `output.txt` with a sample output, and can be run on the board using the same commands as noted above.
