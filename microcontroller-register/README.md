# Microcontroller Register

The register building block of the small processor, together with an alternate
implementation of its control unit. The register is a classic parallel-load
register with synchronous reset; the control unit shares its instruction set
and interface with the `microcontroller-controller` project.

## Files

| File | Module | Role |
|---|---|---|
| `src/register.v` | `register` | 8-bit parallel-load register (design) |
| `src/control.v` | `controller` | Alternate control unit (same interface as `microcontroller-controller`) |
| `tb/register_tb.v` | `register_test` | Self-checking testbench for the register |
| `sim/microcontroller-register.mpf` | — | ModelSim project for the register |
| `sim/control-unit.mpf` | — | ModelSim project for the control unit |

## Register interface

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | input | 1 | Clock |
| `rst` | input | 1 | Synchronous, active-high reset |
| `load` | input | 1 | Load enable |
| `data_in` | input | `WIDTH` | Data to load |
| `data_out` | output | `WIDTH` | Registered output |

| Parameter | Default | Description |
|---|---|---|
| `WIDTH` | 8 | Register width |

### Behavior

| Condition (rising edge) | `data_out` |
|---|---|
| `rst = 1` | Cleared to zero |
| `rst = 0`, `load = 1` | `data_in` |
| `rst = 0`, `load = 0` | Unchanged |

## Simulation

ModelSim/Questa:

- Register: open `sim/microcontroller-register.mpf`, compile, run
  `register_test`.
- Control unit: open `sim/control-unit.mpf`, compile, run `controller_test`.

```sh
iverilog -o sim.vvp src/register.v tb/register_tb.v
vvp sim.vvp
```

The register testbench loads `0x55`, `0xAA`, `0xFF`, then asserts reset and
expects `0x00`, printing `TEST PASSED` on success.

## Notes

- `sim/control-unit.mpf` compiles `src/control.v` together with
  `../../microcontroller-controller/tb/controller_tb.v`, the shared exhaustive
  testbench for this control unit interface.
- `src/register.v` was restored during the repository restructure from an
  editor backup; a `paramater` keyword typo in the backup was corrected.
- The control unit here decodes opcodes through named intermediate signals
  (`HALT`, `SKZ`, `ALUOP`, `STO`, `JMP`), whereas
  `microcontroller-controller` builds the same signals with concatenated
  assignments. The two differ at exactly one point: at phase 4 of HLT,
  `control.v` asserts `halt` without incrementing the program counter, while
  the `microcontroller-controller` version asserts both. The shared testbench
  expects both, so one of its 65 checks reports a mismatch when run against
  `control.v`.
