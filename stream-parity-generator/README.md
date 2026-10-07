# Serial Stream Parity Generator

A serial parity generator that maintains a sliding 8-bit window over an
incoming bit stream and continuously reports the XOR (even) parity of that
window. The parity of a frame is valid once all eight of its bits have been
sampled.

## Files

| File | Module | Role |
|---|---|---|
| `src/stream_parity_gen.v` | `stream_parity_gen` | Parity generator (design) |
| `tb/parity_tb.v` | `parity_tb` | Self-checking testbench |
| `sim/stream-parity-generator.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | input | 1 | Clock |
| `reset` | input | 1 | Synchronous, active-high reset |
| `serial_in` | input | 1 | Serial input bit |
| `parity_out` | output | 1 | XOR parity of the most recent 8-bit window |

## Behavior

On every rising edge the 8-bit shift register ingests `serial_in` (newest bit
at position 0) and `parity_out` is registered as the reduction XOR of
`{shift_register[6:0], serial_in}` — that is, the parity of the new 8-bit
window. Reset clears both the register and the parity output.

Frames are presented MSB first: the testbench shifts in bit 7 down to bit 0,
then checks `parity_out` one cycle later.

## Simulation

ModelSim/Questa: open `sim/stream-parity-generator.mpf`, compile, and run
`parity_tb`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench drives three frames (`0000_0111`, `0010_0111`, `0000_0001`) and
reports a pass or failure line for each.

## Note

The testbench contains commented-out experiments from the original development
session; they are preserved as-is.
