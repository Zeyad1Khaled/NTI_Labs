# Up/Down Counter

A 2-bit up/down counter written three independent ways over the same interface,
so the implementations can be compared directly:

- **Behavioral** — arithmetic `+1`/`-1` in a single `always` block.
- **Structural** — next-state logic built from gate primitives feeding two
  instantiated D flip-flops.
- **Gate level** — the same gate network with the state registers kept in one
  `always` block.

## Files

| File | Module | Role |
|---|---|---|
| `src/behavioral.v` | `counter2_behavioral` | Behavioral implementation |
| `src/structural.v` | `counter2_structural` | Structural implementation (gate primitives + flip-flops) |
| `src/gate_level.v` | `counter2_gate` | Gate-level implementation |
| `src/d_ff.v` | `dff` | Positive-edge D flip-flop with async clear |
| `tb/counter_tb.v` | `counter_tb` | Directed testbench |
| `sim/up-down-counter.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `clock` | input | 1 | Clock |
| `reset` | input | 1 | Asynchronous, active-high reset |
| `up` | input | 1 | `1` counts up, `0` counts down |
| `count` | output | 2 | Current count |

## Next-state logic

| Condition | Next `count` |
|---|---|
| `up = 1` | `count + 1` (wraps 3 -> 0) |
| `up = 0` | `count - 1` (wraps 0 -> 3) |

The structural and gate-level variants compute this with
`d0 = ~q0`, `d1 = (up & (q1 ^ q0)) | (~up & ~(q1 ^ q0))`.

## Simulation

ModelSim/Questa: open `sim/up-down-counter.mpf`, compile, and run
`counter_tb`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench resets the counter, counts down for four cycles, then counts up
for four cycles, monitoring the count continuously.

To exercise a different implementation, edit `tb/counter_tb.v`: comment out the
`counter2_behavioral` instance and uncomment the `counter2_structural` or
`counter2_gate` instance.
