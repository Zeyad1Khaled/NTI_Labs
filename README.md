# NTI Labs

A collection of digital design projects written in Verilog. The repository contains
ten self-contained projects covering combinational logic, sequential logic,
finite-state machines, memory structures, and a small processor control unit.
Every project ships its design sources, a testbench where one exists, and a
ModelSim/QuestaSim project file.

## Repository layout

Each project follows the same structure:

```
<project>/
  src/    Design sources (RTL modules)
  tb/     Testbenches
  sim/    ModelSim/Questa project file (.mpf) and waveform output (.vcd)
```

## Projects

| Project | Description | Top-level module |
|---|---|---|
| [multiplexer-2-to-1](multiplexer-2-to-1/) | Parameterized 2-to-1 multiplexer with a self-checking testbench. | `multiplexor` |
| [tri-state-driver](tri-state-driver/) | Parameterized bus driver that presents high-impedance when disabled. | `driver` |
| [arithmetic-logic-unit](arithmetic-logic-unit/) | 8-bit ALU with eight opcodes (add, and, xor, pass-through) and a zero flag. | `alu` |
| [serial-datapath](serial-datapath/) | Integrated datapath: RAM streams instructions through a PISO/SIPO serial link into an ALU. | `TOP_MODULE` |
| [bidirectional-memory](bidirectional-memory/) | 32 x 8 memory with a single bidirectional (inout) data bus and read/write control. | `memory` |
| [up-down-counter](up-down-counter/) | 2-bit up/down counter implemented three ways: behavioral, structural, and gate-level. | `counter2_behavioral` |
| [sequence-detector-110101](sequence-detector-110101/) | Overlapping and non-overlapping FSM detectors for the serial pattern 110101. | `overlapping`, `nonoverlapping` |
| [stream-parity-generator](stream-parity-generator/) | Serial stream parity generator producing the XOR parity of a sliding 8-bit window. | `stream_parity_gen` |
| [microcontroller-controller](microcontroller-controller/) | Control unit for an 8-instruction processor (HLT, SKZ, ADD, AND, XOR, LDA, STO, JMP) with a complete opcode/phase testbench. | `controller` |
| [microcontroller-register](microcontroller-register/) | Parallel-load register with an alternate control-unit implementation sharing the same instruction set. | `register`, `controller` |

The [archives](archives/) directory preserves the original submission bundles
(`.rar`) for reference.

## Simulation

### ModelSim / QuestaSim

Every project includes a prepared project file under `sim/`. In ModelSim or
QuestaSim use **File > Open Project**, select the `.mpf` file, compile in the
given order, and run the testbench listed in the project README. The project
files reference sources with paths relative to their own location, so they work
from any checkout directory.

### Icarus Verilog

Projects can also be simulated from the command line with
[Icarus Verilog](https://github.com/steveicarus/iverilog):

```sh
cd <project>
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

Self-checking testbenches print `TEST PASSED` on success.

## Conventions

- Source files use lowercase names; Verilog module names are preserved as
  originally written.
- One design goal per project directory; no project depends on another, with a
  single documented exception (see `microcontroller-register`).
- Generated simulation artifacts are excluded through `.gitignore`.

## History

The repository was restructured from its original flat layout. The table below
maps previous locations to their current names.

| Original location | Current project |
|---|---|
| `Lab3_2_MUX/` | `multiplexer-2-to-1/` |
| `Lab3&4/` | `serial-datapath/` |
| `Lab4_2_Driver/` | `tri-state-driver/` |
| `Lab5_2_ALU/` | `arithmetic-logic-unit/` |
| `Lab7_2_Register/` | `microcontroller-register/` |
| `Bidirectional_memory_lab8/` | `bidirectional-memory/` |
| `Controller/` | `microcontroller-controller/` |
| `Overlapping_Nonoverlapping/` | `sequence-detector-110101/` |
| `Up_DN_Counter/` | `up-down-counter/` |
| `stream_parity_gen/` | `stream-parity-generator/` |
| `Combined_Assignments.rar` | `archives/combined-assignments.rar` |

Corrections applied during the restructure:

- `microcontroller-register/src/register.v` was restored from its editor backup
  (the file itself had never been uploaded) and a `paramater` keyword typo was
  corrected.
- `sequence-detector-110101/src/nonoverlapping.v` declared a module named
  `overlapping`, identical to its sibling file; it was renamed to
  `nonoverlapping` so both variants can be compiled together.
- Testbench modules were renamed to match their files (`Tb` to `counter_tb`,
  `TOP_MODULE_tb` to `top_module_tb`, `Parity_TBs` to `parity_tb`).
- The multiplexer port range was corrected from `[WIDTH:0]` to `[WIDTH-1:0]`
  to match its parameterization.
- ModelSim project file paths were rewritten from machine-specific absolute
  paths (`D:/NTI/...`) to portable relative paths.
