# Microcontroller Control Unit

The control unit for a small processor with eight instructions. The unit is a
pure decoder: it takes the current instruction opcode, a three-bit phase
(execution step) and the accumulator zero flag, and produces the register and
bus control signals for that step. An exhaustive testbench verifies every
opcode/phase combination.

## Instructions

| Opcode | Mnemonic | Action |
|---|---|---|
| `0` | HLT | Halt the machine |
| `1` | SKZ | Skip next instruction if accumulator is zero |
| `2` | ADD | Add memory operand to accumulator |
| `3` | AND | AND memory operand with accumulator |
| `4` | XOR | XOR memory operand with accumulator |
| `5` | LDA | Load accumulator from memory |
| `6` | STO | Store accumulator to memory |
| `7` | JMP | Jump (load program counter) |

## Phases

Each instruction progresses through eight phases:

| Phase | Name | Activity |
|---|---|---|
| 0 | INST_ADDR | Present instruction address (`sel`) |
| 1 | INST_FETCH | Read instruction from memory (`rd`) |
| 2 | INST_LOAD | Load instruction register (`ld_ir`) |
| 3 | IDLE | Buffer phase |
| 4 | OP_ADDR | Increment PC; assert `halt` for HLT |
| 5 | OP_FETCH | Read operand (ALU instructions) |
| 6 | ALU_OP | Operand on bus; `ld_pc` for JMP, `data_e` for STO, `inc_pc` for taken SKZ |
| 7 | STORE | Write back: `ld_ac`, `wr`, or `ld_pc` |

## Files

| File | Module | Role |
|---|---|---|
| `src/controller.v` | `controller` | Control unit (design) |
| `tb/controller_tb.v` | `controller_test` | Exhaustive self-checking testbench |
| `sim/microcontroller-controller.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Description |
|---|---|---|
| `opcode[2:0]` | input | Current instruction opcode |
| `phase[2:0]` | input | Current execution phase |
| `zero` | input | Accumulator-is-zero flag |
| `sel` | output | Drive instruction address onto the memory address path |
| `rd` | output | Enable memory output onto the data bus |
| `ld_ir` | output | Load instruction register |
| `inc_pc` | output | Increment program counter |
| `halt` | output | Halt the machine |
| `ld_pc` | output | Load program counter from the data bus |
| `data_e` | output | Enable accumulator output onto the data bus |
| `ld_ac` | output | Load accumulator from the data bus |
| `wr` | output | Write the data bus to memory |

All outputs are combinational and default low for each phase; only the signals
listed for the current opcode/phase are asserted.

## Simulation

ModelSim/Questa: open `sim/microcontroller-controller.mpf`, compile, and run
`controller_test`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench walks all eight opcodes through all eight phases, checking the
nine control outputs at every step, and prints `TEST PASSED` on success.

## Relationship to `microcontroller-register`

The `microcontroller-register` project contains an alternate implementation of
this same control unit (`control.v`) with an identical interface, written with
named decode terms instead of concatenated assignments. The two implementations
are interchangeable against this testbench.
