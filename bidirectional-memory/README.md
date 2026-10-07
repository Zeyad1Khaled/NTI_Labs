# Bidirectional Memory

A 32 x 8 memory whose data port is a single bidirectional (`inout`) bus. The
memory drives the bus during reads, samples the bus during writes, and releases
the bus to high impedance otherwise — the classic shared-bus memory interface.

## Files

| File | Module | Role |
|---|---|---|
| `src/memory.v` | `memory` | Bidirectional memory (design) |
| `tb/memory_tb.v` | `memory_test` | Self-checking testbench |
| `sim/bidirectional-memory.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | input | 1 | Clock |
| `wr` | input | 1 | Write enable |
| `rd` | input | 1 | Read enable |
| `addr` | input | `AWIDTH` | Word address |
| `data` | inout | `DWIDTH` | Shared bidirectional data bus |

| Parameter | Default | Description |
|---|---|---|
| `AWIDTH` | 5 | Address width (32 words) |
| `DWIDTH` | 8 | Data width |

## Behavior

| `wr` | `rd` | Action |
|---|---|---|
| 1 | 0 | Latch `data` into `memory[addr]` on the rising clock edge |
| 0 | 1 | Drive `data` with `memory[addr]` |
| 0 | 0 | Release `data` (high impedance) |

`wr` and `rd` are mutually exclusive; writes are ignored while `rd` is high.

## Simulation

ModelSim/Questa: open `sim/bidirectional-memory.mpf`, compile, and run
`memory_test`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench writes and verifies both boundary addresses, then sweeps the
entire array (ascending data into descending addresses) and reads it all back.
It prints `TEST PASSED` on success.
