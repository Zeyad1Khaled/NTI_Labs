#import "styles.typ": *

// ── 5 RTL design with Verilog ───────────────────────────────────────────────
= RTL design with Verilog <ch-rtl>

This chapter condenses the _RTL Design Course_ and the Verilog-depth lectures of
11–15 July: the language constructs used by every laboratory in #ref(<ch-labs>),
and the semantic rules — assignment semantics, inference rules, procedural constructs —
that decide whether a description becomes the intended hardware.

== Abstraction levels and modelling styles

Register-transfer level (RTL) sits between behavioural specification and gate netlists: it
describes how data moves between registers and what combinational logic transforms it on
the way. The course compared three modelling styles for the same hardware and made the
point that style is a hardware decision, not a taste:

#imgfig("assets/fig/modeling.svg",
  [The same specification expressed in the three Verilog modelling styles. *Structural*
  code instantiates gates and modules explicitly; *dataflow* code writes continuous
  assignments as Boolean equations; *behavioural* code describes what the circuit does
  inside procedural blocks and leaves synthesis to infer the structure.])
<fig-modeling>

Figure #ref(<fig-modeling>) contrasts the three styles. Structural descriptions give
control and mirror hierarchy; dataflow descriptions are compact for combinational logic;
behavioural descriptions scale to algorithms and state machines. The laboratories used all
three deliberately — the counter lab of #ref(<sec-lab-counter>) implements one
specification in each style and compares the results.

== Data types: nets, variables, parameters

Verilog's value objects fall into three groups, and confusing the first two is the classic
beginner error:

#tbl(
  [The three groups of Verilog value objects, as taught on 11–12 July],
  (left, auto, left),
  ([Group], [Represents], [Members and notes]),
  ([Nets (`wire`)], [Physical connections between components], [`supply0/1`, `tri/wire`, `tri0/1`, `wand/triand`, `wor/trior`, `trireg`; driven continuously; required for `inout` buses]),
  ([Variables (`reg`)], [Abstract storage in behavioural code], [`reg`, `integer`, `real`, `time`; updated by procedural assignment; *not* automatically a flip-flop]),
  ([Parameters], [Compile-time constants], [`parameter`, `localparam`, `specparam`; the basis of every parameterised lab (widths, depths, opcodes)]),
)

The rule repeated through the labs: a `reg` becomes a flip-flop only when assigned inside an
edge-triggered procedural block; assigned inside a level-sensitive block it becomes
combinational logic — or an unintended latch if a path is left unassigned.

== Procedural blocks, events and assignment semantics

Two procedural blocks exist: `always`, the synthesizable workhorse that loops forever, and
`initial`, a simulation-only construct used by every testbench. Blocks synchronise through
event controls (`@(posedge clk)`, `@(*)` / `@*`), and multiple blocks execute concurrently —
the language's model of parallel hardware. The single most emphasised rule of the course
concerns the two assignment operators:

#tbl(
  [Blocking versus non-blocking assignment — the rule set drilled in the labs],
  (left, auto, auto),
  ([Aspect], [Blocking `=`], [Non-blocking `<=`]),
  ([Execution], [Statement completes before the next begins], [RHS sampled now, update scheduled at end of time step]),
  ([Intended hardware], [Combinational logic (level-sensitive blocks)], [Registers (edge-triggered blocks)]),
  ([Multiple assignments to one variable], [Last write wins, in order], [Last scheduled update wins — order-independent]),
  ([Golden rule], [Use in `always @(*)`], [Use in `always @(posedge clk)`; never mix in one block]),
)

The sequential-adder example of the course made the danger concrete: mixing the two
operators inside one clocked block silently reorders hardware, producing a circuit that
simulates like the intent but synthesises differently. All laboratory code in this report
follows the golden rule.

== Conditional constructs: `if`, `case`, `casex`, `casez`

The `case` family received dedicated attention on 13 July because the three variants differ
in how they treat unknown (`x`) and high-impedance (`z`) bits:

#tbl(
  [Behaviour of the case variants with respect to x and z bits],
  (left, auto, auto),
  ([Variant], [Treatment of x / z in items], [Guidance from the course]),
  ([`case`], [Exact match; x and z are compared literally], [Default for RTL and for checking real values]),
  ([`casex`], [x, z and `?` are wildcards in both expression and items], [Concise for encoders/decoders; hides initialisation problems — not recommended]),
  ([`casez`], [Only z and `?` are wildcards; x still matches exactly], [Preferred wildcard form; safer for uninitialised RTL; useful in testbenches]),
)

== Functions and tasks

The 13–14 July modules separated the two reusable procedural constructs, and the parity lab
(#ref(<sec-lab-parity>)) put functions to work inside synthesizable code:

#tbl(
  [Functions versus tasks],
  (left, auto, auto),
  ([Aspect], [Function], [Task]),
  ([Simulation time], [Never — no `#`, `@`, `wait`], [May consume time freely]),
  ([Returns], [Exactly one value, via its own name], [Zero or many, via `output`/`inout` arguments]),
  ([May call], [Functions only], [Tasks and functions]),
  ([Synthesizable], [Yes, when purely combinational], [Generally no — testbench stimulus and checkers]),
  ([Storage], [`static` by default; `automatic` gives per-call frames], [Same rule; `task automatic` required for re-entrant calls]),
)

A take-home exercise asked for the failure mode of static functions under re-entrant calls;
the answer — a second overlapping invocation overwrites the single static copy of the
locals, which `automatic` storage prevents — was demonstrated with a fork/join testbench.

== Operators, literals and synthesis-aware coding

The course catalogued Verilog's operator families (arithmetic, logical, bitwise,
reduction, shift, equality, conditional), its sized literal syntax (a width, a base letter
and the digits, e.g. `8'hFF` or `4'b1010`), concatenation and replication. Two synthesis lessons
accompanied them. First, the same function can synthesise to different hardware: three
4-bit adders written with different constraints produced different adder architectures.
Second, structure matters even for pure combinational logic — a 4-input XOR built as a
balanced tree of 2-input gates beats a chain in delay, at a small area cost, and a single
4-input cell beats both in area. Power entered here through glitching: unbalanced chains
glitch more, and glitches are pure wasted energy (Equation 4.1).

== Sequential building blocks

Latches were presented as level-sensitive transparency — useful inside CMOS cells, dangerous
in RTL because an incomplete `if` or `case` infers one silently; the course's remedy is
complete assignments in every level-sensitive block. Edge-triggered D flip-flops then
provide the state of the machine, with synchronous versus asynchronous reset as a design
choice (asynchronous acts immediately, synchronous keeps reset inside the clock domain).
Counters, shift registers and RAMs (modelled as two-dimensional arrays) completed the
vocabulary; all appear as laboratories in #ref(<ch-labs>).

== Testbenches and verification discipline

The final part of the course treated verification as a first-class activity. A testbench
instantiates the design under test (DUT), generates clock and reset, applies stimulus —
fixed, looped or randomised with `$random` — and observes results through
`$display`/`$monitor`/`$strobe` or, better, through self-checking tasks that compare against
expected values and report `TEST PASSED`/`TEST FAILED`. Waveform dumping
(`$dumpfile`/`$dumpvars`) makes every run reviewable. The verification loop of
Figure #ref(<fig-fpga>) is exactly this discipline, and every repository testbench in
#ref(<ch-labs>) is self-checking.
