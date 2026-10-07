# 2-to-1 Multiplexer

A parameterized 2-to-1 multiplexer. A single select line chooses between two
`WIDTH`-bit input channels, implemented as combinational logic with an
`always @(*)` block.

## Files

| File | Module | Role |
|---|---|---|
| `src/mux.v` | `multiplexor` | Multiplexer (design) |
| `tb/multiplexor_tb.v` | `multiplexor_test` | Self-checking testbench |
| `sim/multiplexer-2-to-1.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `in0` | input | `WIDTH` | Channel selected when `sel = 0` |
| `in1` | input | `WIDTH` | Channel selected when `sel = 1` |
| `sel` | input | 1 | Channel select |
| `mux_out` | output | `WIDTH` | Selected channel |

`WIDTH` has no default value and must be overridden at instantiation; the
testbench uses `WIDTH = 5`.

## Behavior

| `sel` | `mux_out` |
|---|---|
| 0 | `in0` |
| 1 | `in1` |

## Simulation

ModelSim/Questa: open `sim/multiplexer-2-to-1.mpf`, compile, and run
`multiplexor_test`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench applies four vector checks and prints `TEST PASSED` on success.
