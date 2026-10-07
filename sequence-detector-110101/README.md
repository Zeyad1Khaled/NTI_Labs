# Sequence Detector 110101

Two finite-state machine detectors for the serial bit pattern `110101`,
presented side by side so the difference between overlapping and
non-overlapping recognition is explicit. Input arrives one bit per clock; the
output is asserted while the machine sits in the match state.

- **Overlapping detector** — after a match, the machine keeps the suffix of the
  received stream, so a new match can reuse bits from the previous one
  (for example `1101010110101` contains two detectable matches).
- **Non-overlapping detector** — after a match, the machine restarts from the
  idle state and no bits are reused.

## Files

| File | Module | Role |
|---|---|---|
| `src/overlapping.v` | `overlapping` | Overlapping detector (design) |
| `src/nonoverlapping.v` | `nonoverlapping` | Non-overlapping detector (design) |
| `sim/sequence-detector-110101.mpf` | — | ModelSim project |

## Interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | input | 1 | Clock |
| `rst` | input | 1 | Asynchronous, active-high reset |
| `din` | input | 1 | Serial input bit |
| `seq_detected` | output | 1 | High while the pattern has been matched |

## State encoding

| State | Meaning (bits received so far) |
|---|---|
| `s0` | (empty) |
| `s1` | `1` |
| `s2` | `11` |
| `s3` | `110` |
| `s4` | `1101` |
| `s5` | `11010` |
| `s6` | `110101` (match) |

The two files differ only in the `s6` transition: the overlapping detector
moves to `s2` on `din = 1` (keeping the trailing `11` as a prefix for the next
match), while the non-overlapping detector always returns to `s0`.

## Notes

- Both files originally declared a module named `overlapping`; the
  non-overlapping variant was renamed to `nonoverlapping` so both can be
  compiled in one library.
- No testbench is included for this project; a simulation script can drive
  `din` with a bit sequence and inspect `seq_detected`.

## Simulation

ModelSim/Questa: open `sim/sequence-detector-110101.mpf` and compile both
sources.

```sh
iverilog -o sim.vvp src/*.v
```
