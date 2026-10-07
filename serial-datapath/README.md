# Serial Datapath

An integrated datapath that moves 20-bit instruction words from RAM to an ALU
over a serial link. Words are written into RAM in parallel, read out one at a
time, shifted serially through a PISO/SIPO pair, and executed by the ALU. The
project demonstrates how parallel memory and a narrow serial interconnect can
be combined into a complete processing path.

## Data flow

```
                 serial link
  RAM  --parallel-->  PISO  ---------->  SIPO  --parallel-->  ALU
 (20b)               (parallel-to-      (serial-to-            (8b result)
                      serial)            parallel)
```

1. The testbench writes one 20-bit word into RAM (`wr_en = 1`).
2. The PISO raises `en`; the RAM performs a read and returns the word with
   `valid`.
3. The PISO shifts the word out MSB-first over `WIDTH` cycles and increments
   its address counter for the next word.
4. The SIPO reassembles the serial stream into a 20-bit parallel word.
5. The ALU executes using the fields of that word.

## Files

| File | Module | Role |
|---|---|---|
| `src/top_module.v` | `TOP_MODULE` | Top level, wires the four blocks |
| `src/ram.v` | `RAM` | 256 x 20 synchronous RAM |
| `src/piso.v` | `PISO` | Parallel-in/serial-out serializer with address counter |
| `src/sipo.v` | `SIPO` | Serial-in/parallel-out deserializer |
| `src/alu.v` | `ALU` | 8-bit ALU with enable and zero flag |
| `tb/top_module_tb.v` | `top_module_tb` | Directed testbench |
| `sim/serial-datapath.mpf` | — | ModelSim project |
| `sim/top_module_tb.vcd` | — | Recorded waveform of the testbench run |

## Instruction word format

The 20-bit word stored in RAM is interpreted by the ALU as follows:

| Bits | Field |
|---|---|
| `[19]` | ALU enable |
| `[18:16]` | ALU opcode (see `arithmetic-logic-unit` project) |
| `[15:8]` | Operand A |
| `[7:0]` | Operand B |

The testbench writes `{1'b1, 3'b000, 8'd3, 8'd2}` to address 1, which enables
the ALU and selects `3 + 2`.

## Key parameters

| Parameter | Default | Description |
|---|---|---|
| `WIDTH` | 20 | Instruction word width |
| `Addr_width` | 8 | RAM address width (256 words) |
| `ALU_OUT` | 8 | ALU result width |

## Simulation

ModelSim/Questa: open `sim/serial-datapath.mpf`, compile in the listed order,
and run `top_module_tb`.

```sh
iverilog -o sim.vvp src/*.v tb/*.v
vvp sim.vvp
```

The testbench writes the instruction, waits for two PISO read passes, and
prints internal handshake state (`RAM valid`, `PISO addr`, `ALU out`, and
others) for inspection.

## Notes

- The PISO reports its progress with `$display` on every clock edge; this is
  intentional trace output from the original development flow.
- The RAM clears its entire array asynchronously on reset.
