#import "styles.typ": *

// ── 8 Hands-on laboratories ────────────────────────────────────────────────
= Hands-on laboratories: what I designed and verified <ch-labs>

This chapter is the core of the report: the ten laboratory deliverables of the training,
each presented as it was worked — specification, design, code, simulation evidence and the
lesson taken. All sources, testbenches and ModelSim projects live in the repository
`Zeyad1Khaled/NTI_Labs` (#ref(<app-repos>)); every testbench is self-checking and
prints `TEST PASSED` on success. Waveform extracts in #ref(<sec-lab-datapath>)
are real ModelSim VCD dumps from that repository.

#tbl(
  [Laboratory programme at a glance],
  (auto, left, left, left),
  ([\#], [Laboratory], [Key concepts exercised], [Repository project]),
  ([1], [Parameterised 2:1 multiplexer], [modules, parameters, level-sensitive blocks], [`multiplexer-2-to-1`]),
  ([2], [Tri-state bus driver], [high-impedance `z`, replication, buses], [`tri-state-driver`]),
  ([3], [8-bit ALU, eight opcodes], [operators, `case`, reduction equality], [`arithmetic-logic-unit`]),
  ([4], [Serial datapath RAM–PISO–SIPO–ALU], [hierarchy, handshaking, serial links], [`serial-datapath`]),
  ([5], [Bidirectional-port memory], [`inout` nets, read/write arbitration], [`bidirectional-memory`]),
  ([6], [Generic register], [non-blocking assignment, synchronous reset], [`microcontroller-register`]),
  ([7], [VeriRISC control unit], [`case` over phases, combinational control], [`microcontroller-controller`]),
  ([8], [2-bit up/down counter, three styles], [behavioural vs structural vs gate-level], [`up-down-counter`]),
  ([9], [110101 sequence detector (Moore)], [FSM states, overlapping detection], [`sequence-detector-110101`]),
  ([10], [Stream parity generator], [functions inside synthesizable code], [`stream-parity-generator`]),
)

== Laboratory 1 — Parameterised 2:1 multiplexer <sec-lab-mux>

#lead[Specification.] The address multiplexer of a small CPU selects the instruction
address during fetch and the operand address during execute. Its width is parameterised
(default 5); `sel = 0` passes `in0`, `sel = 1` passes `in1`.

#imgfig("assets/fig/mux.svg",
  [Block diagram of Laboratory 1 as drawn on the lab sheet: two 5-bit data inputs, a
  1-bit select and a 5-bit output; the width is a module parameter, so the same source
  serves any address width.])
<fig-mux>

#vcode("multiplexer-2-to-1/src/mux.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/mux.typ"))

#lead[Result and lesson.] The design passes its self-checking testbench for both select
values and for a re-parameterised width of 12. The lesson is the first of the course: a
level-sensitive `always @(*)` block with a complete if/else synthesises to a multiplexer —
the `if` *is* hardware selection, and the parameter makes the hardware scalable without a
second source file.

== Laboratory 2 — Tri-state bus driver <sec-lab-driver>

#lead[Specification.] An 8-bit (parameterised) driver presents `data_in` on `data_out`
while `data_en` is true and releases the bus to high impedance otherwise — the construct
that lets several devices share wires.

#imgfig("assets/fig/driver.svg",
  [Laboratory 2 block diagram. When disabled the output is not a value but an absence of
  one: the replicated literal `{WIDTH{1'bz}}` drives every bit of the bus to `z`.])
<fig-driver>

#vcode("tri-state-driver/src/driver.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/driver.typ"))

#lead[Result and lesson.] The testbench verifies the driven values and, with a second
driver on the same wire, that a disabled driver truly releases the bus. The lesson is the
net/variable boundary of Section 5.2: only a net (`wire`) can be high-impedance or
multi-driven, and the replication idiom `{WIDTH{1'bz}}` is the portable way to release a
parameterised bus.

== Laboratory 3 — 8-bit ALU with eight opcodes <sec-lab-alu>

#lead[Specification.] The ALU executes the eight VeriRISC instructions on 8-bit operands,
selected by a 3-bit opcode, and reports asynchronously whether operand A is zero.

#imgfig("assets/fig/alu.svg",
  [Laboratory 3 block diagram: two 8-bit operands and a 3-bit opcode enter; an 8-bit
  result and the zero flag leave. The zero flag is asynchronous — pure combinational
  reduction equality on `in_a`.])
<fig-alu>

#tbl(
  [Opcode encoding and operations of the laboratory ALU],
  (left, auto, left, left),
  ([Instruction], [Opcode], [Operation], [Result]),
  ([HLT], [`000`], [pass A], [`in_a => alu_out`]),
  ([SKZ], [`001`], [pass A (skip if zero elsewhere)], [`in_a => alu_out`]),
  ([ADD], [`010`], [addition], [`in_a + in_b => alu_out`]),
  ([AND], [`011`], [bitwise AND], [`in_a & in_b => alu_out`]),
  ([XOR], [`100`], [bitwise XOR], [`in_a ^ in_b => alu_out`]),
  ([LDA], [`101`], [pass B], [`in_b => alu_out`]),
  ([STO], [`110`], [pass A], [`in_a => alu_out`]),
  ([JMP], [`111`], [pass A], [`in_a => alu_out`]),
)

#vcode("arithmetic-logic-unit/src/alu.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/alu.typ"))

#lead[Result and lesson.] All eight opcodes plus the zero flag are checked exhaustively on
directed vectors and randomised operands. The lesson is operator-level synthesis: one
`case` over the opcode becomes an 8:1 multiplexer of operator outputs, and the asynchronous
zero flag (`a_is_zero = (in_a == 0)`) shows that a reduction equality is real comparison
hardware, not code.

== Laboratory 4 — Integrated serial datapath (RAM → PISO → SIPO → ALU) <sec-lab-datapath>

#lead[Specification.] The capstone laboratory of the RTL module: instruction words stored
in a RAM are streamed *bit-serially* over a single wire into a shift register that
re-assembles them, and the completed word is executed by the ALU of Laboratory 3 — one
integrated `TOP_MODULE`.

#imgfig("assets/fig/datapath.svg",
  [The integrated datapath. The RAM holds 20-bit words; the PISO serialises a word under
  its own handshake (`en`, `ram_valid`) and even steers the RAM read address
  (`piso_addr`); the SIPO re-assembles the stream into `parallel_out`; the ALU decodes
  bit 19 as enable, bits 18:16 as opcode and the two bytes as operands, exactly as the
  word-format band on top shows.])
<fig-datapath>

#vcode("serial-datapath/src/top_module.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/topmodule.typ"))

The design is four modules and a handful of handshakes, and it is where the training's
concepts first had to work *together*: hierarchy and named port connection, two clocked
state machines (PISO bit counter, SIPO shift counter), a parameterised RAM, and the ALU —
with `en`/`valid` pairs playing the role of cheap readiness protocols.

#imgfig("assets/fig/wave-fetch.svg",
  [ModelSim extract of one serial fetch (repository VCD dump). While `en` is high the PISO
  loads `ram_dout` (word `0x80302`: enable, opcode ADD, operands 3 and 2) and then clocks
  it out on `PISO_out` one bit per cycle; `parallel_out` visibly assembles in the SIPO
  shift register, bit by bit, until the full word stands at the end of the burst.])
<fig-wavefetch>

#imgfig("assets/fig/wave-exec.svg",
  [ModelSim extract of consecutive executions from the same dump. `word_num` advances as
  each word completes; `out[7:0]` updates with each ALU execution, and `a_is_zero` pulses
  exactly on the words whose result is zero — the self-checking testbench's expectations
  reproduced on silicon-time waveforms.])
<fig-waveexec>

#lead[Result and lesson.] Figures #ref(<fig-wavefetch>) and #ref(<fig-waveexec>) are actual
simulation dumps: the fetch burst, the assembled word and the per-word results all match
the testbench log (`OUT`, `ZERO`, `PISO addr` printed per pass). The lesson is systemic:
serialisation buys wires at the price of latency and protocol discipline, and a handshake
signal that is almost right produces a datapath that is wrong once per thousand words —
which is exactly what the first debugging session taught.

== Laboratory 5 — Single-bidirectional-port memory <sec-lab-memory>

#lead[Specification.] A 32 × 8 memory with one bidirectional data port: write on the
rising clock edge when `wr` is asserted; drive the bus combinationally when `rd` is
asserted; never both at once.

#imgfig("assets/fig/memory.svg",
  [Laboratory 5 block diagram. The single `data` port is an `inout` net: an input during
  writes, an output during reads, and high impedance otherwise — the electrical reason the
  port must be a net rather than a variable.])
<fig-memory>

#vcode("bidirectional-memory/src/memory.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/memory.typ"))

#lead[Result and lesson.] The testbench writes a pattern, reads it back, and probes the bus
in the idle state to confirm `z`. Two lessons: `inout` ports force the net side of the
type system, and a bidirectional bus makes arbitration a design obligation — the
`wr && !rd` guard and the conditional drive are the whole protocol.

== Laboratory 6 — Generic register and Laboratory 7 — VeriRISC control unit <sec-lab-regctl>

#lead[Specification.] One register definition serves as instruction register and
accumulator: 8-bit parallel load under `load`, synchronous active-high reset. The control
unit decodes opcode, fetch/execute phase and the zero flag into nine control signals.

#imgfig("assets/fig/register.svg",
  [The generic register of Laboratory 6: clocked load with synchronous reset — the
  canonical non-blocking-assignment storage element.])
<fig-register>

#imgfig("assets/fig/micro.svg",
  [How the two laboratories compose: the controller's nine control lines are pure
  combinational functions of `opcode`, `phase` and `zero`; the load lines (`ld_ir`,
  `ld_ac`) clock data into register instances, while the remaining lines steer the
  datapath and memory around them.])
<fig-micro>

#vcode("microcontroller-register/src/register.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/register.typ"))

#vcode("microcontroller-controller/src/controller.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/controller.typ"))

#lead[Result and lesson.] The controller testbench walks every opcode through every phase
and compares all nine control lines against the specification table — the most complete
self-check written during the training. The lesson is the controller/datapath split of
#ref(<ch-fsm>): a `case` over phases *is* a state machine, and writing the control
table first made the RTL almost mechanical.

== Laboratory 8 — 2-bit up/down counter in three modelling styles <sec-lab-counter>

#lead[Specification.] One circuit, three descriptions: behavioural (one procedural block),
gate-level (hand-derived next-state equations on primitives), and structural (instantiated
D flip-flops and gates), plus a shared testbench and a function/task-based variant.

#imgfig("assets/fig/counter.svg",
  [The counter interface shared by all three implementations: clock, asynchronous
  active-high reset, direction input and a 2-bit count. Identical ports are what make the
  three styles comparable under one testbench.])
<fig-counter>

#vcode("up-down-counter/src/behavioral.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/counter.typ"))

#lead[Result and lesson.] All three netlists count up, count down and reset identically;
the behavioural source is eight lines where the gate-level source is thirty. The lesson is
abstraction as productivity: identical behaviour, radically different maintenance cost —
and the gate-level detour is what made the synthesised result of the behavioural version
legible afterwards.

== Laboratory 9 — Overlapping 110101 sequence detector <sec-lab-seq>

#lead[Specification.] Detect the serial pattern 110101 on `din`, in both overlapping and
non-overlapping flavours, as a clocked Moore machine.

#imgfig("assets/fig/fsm-seq.svg",
  [Moore state diagram of the overlapping detector. Each state records how much of the
  target pattern has been matched; a mismatch falls back to the longest state that is
  still a valid prefix (grey arcs), which is precisely what makes detection overlapping.
  State S6 asserts `seq_detected` for one clock cycle and, on a further `1`, re-enters S2
  because the suffix “11” is already a prefix of the next match.])
<fig-fsmseq>

#vcode("sequence-detector-110101/src/overlapping.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/seqdet.typ"))

#lead[Result and lesson.] Both detectors pass streams containing back-to-back and
overlapping occurrences; the Moore output appears one cycle after the final bit, exactly as
#ref(<ch-fsm>) predicts. The lesson is design-before-code: drawing the fallback
arcs correctly (each mismatch returns to the longest matching prefix) is the entire
difficulty, and the three-block FSM idiom turned the diagram into RTL without further
decisions.

== Laboratory 10 — Stream parity generator using functions <sec-lab-parity>

#lead[Specification.] Compute the even parity of a sliding 8-bit window over a serial
stream, using a Verilog *function* for the parity reduction.

#imgfig("assets/fig/parity.svg",
  [Laboratory 10 block diagram: each clock shifts `serial_in` into an 8-bit window; the
  parity function (a one-line XOR reduction) evaluates combinationally on the next window
  value and is registered onto `parity_out`.])
<fig-parity>

#vcode("stream-parity-generator/src/stream_parity_gen.v", "Zeyad1Khaled/NTI_Labs", include("../snippets/parity.typ"))

#lead[Result and lesson.] The testbench streams random bits and compares against a
testbench-side reference model. The lesson is the place of functions in synthesizable
code: a zero-delay, single-value abstraction that keeps RTL readable without changing the
hardware — here, a XOR tree over eight window bits.

== Laboratory 11 — Switch debouncer and edge detectors <sec-lab-debounce>

The session of 19–20 July added two small but formative designs: rising-edge detectors as
Moore and Mealy machines (the Mealy version reacting in the same cycle, the Moore one
cycle later — the table of #ref(<ch-fsm>) observed live), and a switch debouncer
that filters a bouncing input with a saturation counter before registering the clean
level. Both sit in the team repository's dated session folders and reinforced the same
point: metastability-adjacent, real-world inputs demand deliberate synchronisation, not
hope.
