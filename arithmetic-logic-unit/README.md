# Arithmetic Logic Unit

An 8-bit arithmetic logic unit with a three-bit opcode and a zero-detect flag.
The unit is purely combinational: the result and the `a_is_zero` flag settle
from the current inputs alone.

## Files

| File | Module | Role |
|---|---|---|
| `src/alu.v` | `alu` | ALU (design) |
| `tb/alu_tb.v` | `alu_test` | Self-checking testbench |
| `sim/arithmetic-logic-unit.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `in_a` | input | `WIDTH` | Operand A |
| `in_b` | input | `WIDTH` | Operand B |
| `opcode` | input | 3 | Operation select |
| `alu_out` | output | `WIDTH` | Operation result |
| `a_is_zero` | output | 1 | High when `in_a == 0` |

`WIDTH` defaults to 8.

## Opcode map

| `opcode` | Operation |
|---|---|
| `000` | Pass A |
| `001` | Pass A |
| `010` | `in_a + in_b` |
| `011` | `in_a & in_b` |
| `100` | `in_a ^ in_b` |
| `101` | Pass B |
| `110` | Pass A |
| `111` | Pass A |

## Simulation

ModelSim/Questa: open `sim/arithmetic-logic-unit.mpf`, compile, and run
`alu_test`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench exercises all eight opcodes plus the zero-flag case and prints
`TEST PASSED` on success.
