#!/usr/bin/env python3

import re
import os
from statistics import geometric_mean

class Benchmark:
    def __init__(self, name: str) -> None:
        self.name = name
        self.results: dict[str, dict[str, int]] = {}
        for variant in ["base", "linear", "balanced"]:
            self.results[variant] = {
            "time": 0,
            "size": 0,
        }

    def __str__(self) -> str:
        return str(self.results)

    def __repr__(self) -> str:
        return str(self)

benchmarks = {name: Benchmark(name) for name in ["bsl", "mulhi3", "mulmod8", "sharevalue", "switch16", "switch8"]}

map_file = os.path.join(os.path.dirname(__file__), "../benchmarks/Debug/benchmarks.map")
time_output = os.path.join(os.path.dirname(__file__), "../benchmarks/output.txt")

try:
    map = open(map_file)
except FileNotFoundError:
    print("Missing map file: you first need to compile the benchmarks project (follow the README)!")
else:
    with map:
        for line in map:
            m = re.match(r"bench_([a-z0-9\_]+)\.obj\s+(\d+)", line.strip())
            if m:
                benchmark = m.group(1).split("_")
                name = benchmark[0]
                variant = benchmark[1]
                size = int(m.group(2))
                benchmarks[name].results[variant]["size"] = size

with open(time_output) as output:
    for line in output:
        m = re.match(r"MSP430: (\w+) [\d]+:[\s]+Baseline (\d+), Linear (\d+), Balanced (\d+)", line.strip())
        if m:
            name = m.group(1)
            baseline = int(m.group(2))
            linear = int(m.group(3))
            balanced = int(m.group(4))
            benchmarks[name].results["base"]["time"] = baseline
            benchmarks[name].results["linear"]["time"] = linear
            benchmarks[name].results["balanced"]["time"] = balanced

size_lin_ratios: list[float] = []
size_bal_ratios: list[float] = []
time_lin_ratios: list[float] = []
time_bal_ratios: list[float] = []

print(f"{'':<12} {'Binary size':^21} {'Execution time':^26}")
print(f"{'Name':<12} {'Vuln.':>6} {'Lin.':>6} {'Bal.':>6} {'Vuln.':>10} {'Lin.':>8} {'Bal.':>6}")
print("-" * 72)

for name, vals in [(benchmark.name, benchmark.results) for benchmark in benchmarks.values()]:
    base = vals['base']
    linear = vals['linear']
    balanced = vals['balanced']

    # Ratios vs base
    size_lin_ratios.append(linear['size'] / base['size'])
    size_bal_ratios.append(balanced['size'] / base['size'])
    time_lin_ratios.append(linear['time'] / base['time'])
    time_bal_ratios.append(balanced['time'] / base['time'])

    print(f"{name:<12} "
          f"{base['size']:>6} {linear['size']:>6} {balanced['size']:>6} "
          f"{base['time']:>10} {linear['time']:>8} {balanced['time']:>6}")

gm_size_lin = geometric_mean(size_lin_ratios)
gm_size_bal = geometric_mean(size_bal_ratios)
gm_time_lin = geometric_mean(time_lin_ratios)
gm_time_bal = geometric_mean(time_bal_ratios)

print("-" * 72)

print(f"{'overhead':<12} "
      f"{'':>6} {gm_size_lin:>6.2f}x {gm_size_bal:>5.2f}x "
      f"{'':>10} {gm_time_lin:>7.2f}x {gm_time_bal:>5.2f}x")
