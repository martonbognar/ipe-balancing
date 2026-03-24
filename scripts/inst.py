#!/usr/bin/env python3

import re
import argparse
import sys
import os

# -------------------------------------------------
# Addressing mode detection
# -------------------------------------------------

HEX_16 = re.compile(r'^(0x[0-9a-fA-F]{1,4}|[0-9A-Fa-f]{1,4}h)$')

def detect_mode(operand: str):
    operand = operand.strip().lower()

    # Immediate
    if operand.startswith('#'):
        return '#N'

    # Indirect autoincrement
    if operand.startswith('@') and operand.endswith('+'):
        return '@Rn+'

    # Indirect
    if operand.startswith('@'):
        return '@Rn'

    # Indexed
    if re.match(r'\d+\(r\d+\)', operand):
        return 'x(Rn)'

    # Absolute
    if operand.startswith('&'):
        return '&EDE'

    if HEX_16.match(operand):
        return 'EDE'

    # Registers
    if operand == 'r0':
        return 'PC'

    if re.fullmatch(r'r[1-9]\d*', operand):
        return 'Rm'

    raise ValueError(f"Unknown addressing mode: {operand}")


# -------------------------------------------------
# Timing table
# (cycles, length, footnote_1)
# -------------------------------------------------

TIMING_TABLE = {
    # -------- Source Rm --------
    ('Rm', 'Rm'):      (1, 1, False),
    ('Rm', 'PC'):      (3, 1, False),
    ('Rm', 'x(Rn)'):   (4, 2, True),
    ('Rm', 'EDE'):     (4, 2, True),
    ('Rm', '&EDE'):    (4, 2, True),

    # -------- Source @Rn --------
    ('@Rn', 'Rm'):     (2, 1, False),
    ('@Rn', 'PC'):     (4, 1, False),
    ('@Rn', 'x(Rn)'):  (5, 2, True),
    ('@Rn', 'EDE'):    (5, 2, True),
    ('@Rn', '&EDE'):   (5, 2, True),

    # -------- Source @Rn+ --------
    ('@Rn+', 'Rm'):    (2, 1, False),
    ('@Rn+', 'PC'):    (4, 1, False),
    ('@Rn+', 'x(Rn)'): (5, 2, True),
    ('@Rn+', 'EDE'):   (5, 2, True),
    ('@Rn+', '&EDE'):  (5, 2, True),

    # -------- Source #N --------
    ('#N', 'Rm'):      (2, 2, False),
    ('#N', 'PC'):      (3, 2, False),
    ('#N', 'x(Rn)'):   (5, 3, True),
    ('#N', 'EDE'):     (5, 3, True),
    ('#N', '&EDE'):    (5, 3, True),

    # -------- Source x(Rn) --------
    ('x(Rn)', 'Rm'):     (3, 2, False),
    ('x(Rn)', 'PC'):     (5, 2, False),
    ('x(Rn)', 'x(Rn)'):  (6, 3, True),
    ('x(Rn)', 'EDE'):    (6, 3, True),
    ('x(Rn)', '&EDE'):   (6, 3, True),

    # -------- Source EDE --------
    ('EDE', 'Rm'):     (3, 2, False),
    ('EDE', 'PC'):     (5, 2, False),
    ('EDE', 'x(Rn)'):  (6, 3, True),
    ('EDE', 'EDE'):    (6, 3, True),
    ('EDE', '&EDE'):   (6, 3, True),

    # -------- Source &EDE --------
    ('&EDE', 'Rm'):    (3, 2, False),
    ('&EDE', 'PC'):    (5, 2, False),
    ('&EDE', 'x(Rn)'): (6, 3, True),
    ('&EDE', 'EDE'):   (6, 3, True),
    ('&EDE', '&EDE'):  (6, 3, True),
}

# -------------------------------------------------
# Single-operand timing table
# (cycles, length)
# -------------------------------------------------

SINGLE_OPERAND_TABLE: dict[str, dict[str, int | None]] = {
    # mode     RRA/RRC/SWPB/SXT   PUSH   CALL   length
    'Rm':     {'ALU': 1, 'PUSH': 3, 'CALL': 4, 'len': 1},
    '@Rn':    {'ALU': 3, 'PUSH': 3, 'CALL': 4, 'len': 1},
    '@Rn+':   {'ALU': 3, 'PUSH': 3, 'CALL': 4, 'len': 1},
    '#N':     {'ALU': None, 'PUSH': 3, 'CALL': 4, 'len': 2},
    'x(Rn)':  {'ALU': 4, 'PUSH': 4, 'CALL': 5, 'len': 2},
    'EDE':    {'ALU': 4, 'PUSH': 4, 'CALL': 5, 'len': 2},
    '&EDE':   {'ALU': 4, 'PUSH': 4, 'CALL': 6, 'len': 2},
}

# -------------------------------------------------
# Instruction analysis
# -------------------------------------------------

DOUBLE_OPERAND_MNEMONICS = {
    "MOV",
    "ADD",
    "ADDC",
    "SUB",
    "SUBC",
    "CMP",
    "DADD",
    "BIT",
    "BIC",
    "BIS",
    "XOR",
    "AND",
}

FOOTNOTE_MNEMONICS = {'MOV', 'BIT', 'CMP'}

SINGLE_ALU_MNEMONICS = {'RRA', 'RRC', 'SWPB', 'SXT'}
PUSH_MNEMONIC = 'PUSH'
CALL_MNEMONIC = 'CALL'

# -------------------------------------------------
# Special instructions
# -------------------------------------------------

NO_OPERAND_INSTRUCTIONS = {
    'RET':  {'cycles': 4, 'length': 1},
    'RETI': {'cycles': 5, 'length': 1},
}

JUMP_MNEMONICS = {
    'JEQ', 'JZ',
    'JNE', 'JNZ',
    'JC', 'JNC',
    'JN',
    'JGE',
    'JL',
    'JMP',
}


def analyze_instruction(instruction: str) -> dict[str, int]:
    parts = instruction.split()
    mnemonic = parts[0].upper()

    # -------------------------------------------------
    # NO OPERAND (RET / RETI)
    # -------------------------------------------------
    if mnemonic in NO_OPERAND_INSTRUCTIONS:
        return NO_OPERAND_INSTRUCTIONS[mnemonic]

    # -------------------------------------------------
    # JUMP INSTRUCTIONS (fixed timing)
    # -------------------------------------------------
    if mnemonic in JUMP_MNEMONICS:
        return {
            "cycles": 2,
            "length": 1
        }

    # -------------------------------------------------
    # SINGLE OPERAND
    # -------------------------------------------------
    if len(parts) == 2 and ',' not in parts[1]:
        operand = parts[1]
        mode = detect_mode(operand)

        if mode not in SINGLE_OPERAND_TABLE:
            raise ValueError(f"No timing data for {mnemonic} {mode}")

        entry = SINGLE_OPERAND_TABLE[mode]

        if mnemonic in SINGLE_ALU_MNEMONICS:
            cycles = entry['ALU']
            if cycles is None:
                raise ValueError(f"{mnemonic} not valid with {mode}")

        elif mnemonic == 'PUSH':
            cycles = entry['PUSH']

        elif mnemonic == 'CALL':
            cycles = entry['CALL']

        else:
            raise ValueError(f"Unknown single-operand instruction: {mnemonic}")

        return {
            "cycles": cycles,
            "length": entry['len']
        }

    # -------------------------------------------------
    # DOUBLE OPERAND
    # -------------------------------------------------
    mnemonic, operands = instruction.split(maxsplit=1)
    mnemonic = mnemonic.upper()

    src, dst = [o.strip() for o in operands.split(',')]

    src_mode = detect_mode(src)
    dst_mode = detect_mode(dst)

    key = (src_mode, dst_mode)
    if key not in TIMING_TABLE:
        raise ValueError(f"No timing data for {src_mode} -> {dst_mode}")

    cycles, length, footnote_1 = TIMING_TABLE[key]

    if footnote_1 and mnemonic in {'MOV', 'BIT', 'CMP'}:
        cycles -= 1

    return {
        "cycles": cycles,
        "length": length
    }


OPERAND_REPRESENTATIVES = {
    'Rm': ['r5',],
    'PC': ['r0',],
    '@Rn': ['@r6',],
    '@Rn+': ['@r6+',],
    '#N': ['#1', '#42'],
    'x(Rn)': ['0(r6)',],
    'EDE': ['0x1000', '0x5000'],
    '&EDE': ['&RAM_LOCATION', '&FRAM_LOCATION'],
}

DOUBLE_OPERAND_SRC_MODES = {
    'Rm', '@Rn', '@Rn+', '#N', 'x(Rn)', '&EDE'  # , 'EDE'
}

DOUBLE_OPERAND_DST_MODES = {
    'Rm', 'x(Rn)', '&EDE'  # , 'EDE', 'PC'
}

SINGLE_OPERAND_MODES = {
    'Rm', '@Rn', '@Rn+', '#N', 'x(Rn)', '&EDE'  # , 'EDE'
}

double_operand_combinations: list[str] = []

for mnemonic in DOUBLE_OPERAND_MNEMONICS:
    for src_mode in DOUBLE_OPERAND_SRC_MODES:
        for dst_mode in DOUBLE_OPERAND_DST_MODES:
            key = (src_mode, dst_mode)

            # Only keep combinations that actually exist in the timing table
            if key not in TIMING_TABLE:
                continue

            for concrete_src in OPERAND_REPRESENTATIVES[src_mode]:
                for concrete_dst in OPERAND_REPRESENTATIVES[dst_mode]:
                    double_operand_combinations.append(
                        f"{mnemonic} {concrete_src},{concrete_dst}"
                    )

single_operand_combinations: list[str] = []

# ALU-type single operand instructions
for mnemonic in SINGLE_ALU_MNEMONICS:
    for mode in SINGLE_OPERAND_MODES:
        entry = SINGLE_OPERAND_TABLE.get(mode)
        if entry and entry['ALU'] is not None:
            for op in OPERAND_REPRESENTATIVES[mode]:
                single_operand_combinations.append(f"{mnemonic} {op}")

# PUSH
for mode in SINGLE_OPERAND_MODES:
    entry = SINGLE_OPERAND_TABLE.get(mode)
    if entry:
        for op in OPERAND_REPRESENTATIVES[mode]:
            single_operand_combinations.append(f"PUSH {op}")

# CALL
for mode in SINGLE_OPERAND_MODES:
    entry = SINGLE_OPERAND_TABLE.get(mode)
    if entry:
        for op in OPERAND_REPRESENTATIVES[mode]:
            single_operand_combinations.append(f"CALL {op}")

# Jumps (label operand, timing-independent)
for mnemonic in JUMP_MNEMONICS:
    single_operand_combinations.append(f"{mnemonic} +2")


no_operand_combinations = list(NO_OPERAND_INSTRUCTIONS.keys())


def dump_instruction_timings() -> list[str]:
    all_instructions = []
    print("=== DOUBLE-OPERAND INSTRUCTIONS ===")
    for instr in double_operand_combinations:
        try:
            result = analyze_instruction(instr)
            print(
                f"{instr:<30} -> cycles={result['cycles']}, length={result['length']}")
            all_instructions.append({
                'inst': instr,
                'cycles': result['cycles'],
                'length': result['length']
            })
        except Exception as e:
            print(f"{instr:<30} -> ERROR: {e}")

    print("\n=== SINGLE-OPERAND INSTRUCTIONS ===")
    for instr in single_operand_combinations:
        try:
            result = analyze_instruction(instr)
            print(
                f"{instr:<30} -> cycles={result['cycles']}, length={result['length']}")
            all_instructions.append({
                'inst': instr,
                'cycles': result['cycles'],
                'length': result['length']
            })
        except Exception as e:
            print(f"{instr:<30} -> ERROR: {e}")

    print("\n=== NO-OPERAND INSTRUCTIONS ===")
    for instr in no_operand_combinations:
        try:
            result = analyze_instruction(instr)
            print(
                f"{instr:<30} -> cycles={result['cycles']}, length={result['length']}")
            all_instructions.append({
                'inst': instr,
                'cycles': result['cycles'],
                'length': result['length']
            })
        except Exception as e:
            print(f"{instr:<30} -> ERROR: {e}")

    return all_instructions

def generate():
    all_inst = dump_instruction_timings()

    print("one-word instructions")
    with open('one-word.s', 'wt') as fl:
        fl.writelines([
            "    .global one_word\n",
            "    .global end_one_word\n",
            "    .global RAM_LOCATION, FRAM_LOCATION\n",
            "one_word:\n",
        ])
        fl.writelines([
            f"    {inst['inst']}\n" for inst in all_inst if inst['length'] == 1
        ])
        fl.writelines([
            "end_one_word:\n",
            "    nop\n",
        ])

    print("two-word instructions")
    with open('two-word.s', 'wt') as fl:
        fl.writelines([
            "    .global two_word\n",
            "    .global end_two_word\n",
            "    .global RAM_LOCATION, FRAM_LOCATION\n",
            "two_word:\n",
        ])
        fl.writelines([
            f"    {inst['inst']}\n" for inst in all_inst if inst['length'] == 2
        ])
        fl.writelines([
            "end_two_word:\n",
            "    nop\n",
        ])

    print("three-word instructions")
    with open('three-word.s', 'wt') as fl:
        fl.writelines([
            "    .global three_word\n",
            "    .global end_three_word\n",
            "    .global RAM_LOCATION, FRAM_LOCATION\n",
            "three_word:\n",
        ])
        fl.writelines([
            f"    {inst['inst']}\n" for inst in all_inst if inst['length'] == 3
        ])
        fl.writelines([
            "end_three_word:\n",
            "    nop\n",
        ])

def compare():
    inst: dict[str, list[str]] = {
        'one': [],
        'two': [],
        'three': [],
    }

    basic: dict[str, list[int]] = {
        'one': [],
        'two': [],
        'three': [],
    }

    doc: dict[str, list[int]] = {
        'one': [],
        'two': [],
        'three': [],
    }

    nemesis: dict[str, list[int]] = {
        'one': [],
        'two': [],
        'three': [],
    }

    keys = ['one', 'two', 'three']

    for key in keys:
        for line in open(os.path.join(os.path.dirname(__file__), f'../experiments/profiler_timer/{key}-word.s')):
            if re.match(r'[A-Z]', line.strip()):
                inst[key].append(line.strip())

    for key in keys:
        for instruction in inst[key]:
            result = analyze_instruction(instruction)
            doc[key].append(result['cycles'])

    key = 'one'
    for line in open(os.path.join(os.path.dirname(__file__), '../experiments/profiler_timer/output.txt')):
        if line.strip().startswith("MSP430: Two"):
            key = 'two'
        if line.strip().startswith("MSP430: Three"):
            key = 'three'
        m = re.match(r'MSP430: (\d+)', line.strip())
        if m:
            basic[key].append(int(m.group(1)))

    key = 'one'
    for line in open(os.path.join(os.path.dirname(__file__), '../experiments/profiler_nemesis/output.txt')):
        if line.strip().startswith("MSP430: Two"):
            key = 'two'
        if line.strip().startswith("MSP430: Three"):
            key = 'three'
        m = re.match(r'MSP430: (\d+)', line.strip())
        if m:
            nemesis[key].append(int(m.group(1)))

    # heuristic: lowest recoded cycle count should be 1

    baseline_basic = min(basic['one'])
    baseline_nemesis = min(nemesis['one'])

    for key in keys:
        for (i, x) in enumerate(basic[key]):
            basic[key][i] = x - baseline_basic + 1
        for (i, x) in enumerate(nemesis[key]):
            nemesis[key][i] = x - baseline_nemesis + 1

    # print results and count mismatches
    doc_basic_mismatch = 0
    basic_nemesis_mismatch = 0

    for key in keys:
        for (i, x) in enumerate(inst[key]):
            cycles_doc = doc[key][i]
            cycles_basic = basic[key][i]
            cycles_nemesis = nemesis[key][i]
            print(f"{x:>40} {cycles_doc} {cycles_basic} {cycles_nemesis} {"!!" if cycles_doc != cycles_basic else "  "} {"xx" if cycles_basic != cycles_nemesis else ""}")
            if cycles_doc != cycles_basic:
                doc_basic_mismatch += 1
            if cycles_basic != cycles_nemesis:
                basic_nemesis_mismatch += 1

    print(f"Total doc mismatches: {doc_basic_mismatch}, Nemesis mismatches: {basic_nemesis_mismatch}")

def parse_args():
    parser = argparse.ArgumentParser(
        description="Generate instruction timing files and compare timing results."
    )
    parser.add_argument(
        '-generate',
        action='store_true',
        help='generate instruction timing files'
    )
    parser.add_argument(
        '-compare',
        action='store_true',
        help='compare timing results'
    )
    if len(sys.argv) < 2:
        parser.print_usage()
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    if args.generate:
        generate()
    if args.compare:
        compare()
