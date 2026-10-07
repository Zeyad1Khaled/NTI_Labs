# Tri-State Bus Driver

A parameterized bus driver with an enable input. When enabled it forwards the
input word to the bus; when disabled it releases the bus by driving all bits to
high impedance (`z`). This is the standard cell used to place multiple sources
on a shared bus.

## Files

| File | Module | Role |
|---|---|---|
| `src/driver.v` | `driver` | Tri-state driver (design) |
| `tb/driver_tb.v` | `driver_test` | Self-checking testbench |
| `sim/tri-state-driver.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `data_in` | input | `WIDTH` | Data to drive onto the bus |
| `data_en` | input | 1 | Bus enable (active high) |
| `data_out` | output | `WIDTH` | Bus value, or all `z` when disabled |

`WIDTH` has no default value and must be overridden at instantiation; the
testbench uses `WIDTH = 8`.

## Behavior

| `data_en` | `data_out` |
|---|---|
| 1 | `data_in` |
| 0 | `{WIDTH{1'bz}}` |

## Simulation

ModelSim/Questa: open `sim/tri-state-driver.mpf`, compile, and run
`driver_test`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench verifies the high-impedance state and two driven values, and
prints `TEST PASSED` on success.
