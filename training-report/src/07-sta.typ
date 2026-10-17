#import "styles.typ": *

// ── 7 Static timing analysis ───────────────────────────────────────────────
= Static timing analysis <ch-sta>

The closing technical module (22 July, material co-authored by Eng. Mohammed Salah
Aboshosha and Eng. Ahmed Abdelazeem) taught static timing analysis (STA): proving that a
circuit meets its timing constraints *without simulation*. This chapter follows the
module's own order: why STA exists, the vocabulary of arcs and unateness, the device-level
origin of setup and hold, and finally paths, slack and constraints — closed by the XDC
laboratory.

== Why STA

#bullets(
  [[*It verifies timing.*] It checks timing between synchronous clocks; it does not verify
    functionality — that remains simulation's job.],
  [[*It is exhaustive.*] Formal, mathematical path analysis replaces vectors: every path is
    examined, not only the stimulated ones.],
  [[*It is fast.*] Orders of magnitude faster than gate-level simulation, and further still
    from transistor-level simulation.],
  [[*It is path-based and constraint-driven.*] STA identifies timing paths and computes the
    arcs inside them; a path without a constraint is, by default, not reported at all — so
    incomplete constraints silently blind the analysis.],
)

== Timing arcs and unateness

A *timing arc* is a path from each input to each output of a cell. Combinational cells have
an arc per input-output pair; a flip-flop has a delay arc from clock to Q and constraint
arcs (setup/hold checks) from clock to D; a latch has a clock-to-Q arc and a transparent
D-to-Q arc. *Unateness* classifies how an output responds to an input transition:

#tbl(
  [Unateness classes with the lecture's cell examples],
  (left, auto, left),
  ([Class], [Rule], [Example cells]),
  ([Positive unate], [Output transition follows the input transition (rise→rise, fall→fall)], [AND, OR, buffer]),
  ([Negative unate], [Output transition inverts the input transition (rise→fall, fall→rise)], [NAND, NOR, inverter]),
  ([Non-unate], [Output direction cannot be deduced from the input direction alone; other inputs decide], [XOR, XNOR, mux select]),
)

Unateness lets the analyser propagate only the transitions that matter, which is a large
part of why STA is fast.

== From transistors to setup and hold <sec-sta-devices>

#imgfig("assets/fig/setup-hold.svg",
  [The setup and hold windows. The dashed vertical line is the capturing clock edge; the
  data waveform must stop changing t\_setup before that edge and may resume only t\_hold
  after it. Data transitions inside either window risk metastability at the capturing
  flop.])
<fig-setuphold>

The module rebuilt storage from devices upward: the transmission gate (parallel PMOS/NMOS
with complementary gates, giving an almost constant on-resistance bidirectional switch);
the level-sensitive D latch built from two transmission gates and two inverters,
transparent while its clock level is active; and the edge-triggered D flip-flop obtained by
cascading a negative and a positive latch, so data moves only at the active edge. From that
circuitry follow the three parameters used everywhere afterwards: t\_cq (clock-to-Q delay,
different for rising and falling outputs), t\_setup (data must arrive this early *before*
the edge) and t\_hold (data must remain stable this long *after* the edge).
Figure #ref(<fig-setuphold>) draws the two windows around a capturing edge; violating
either means the capturing latch may resolve to a metastable level between logic 0 and 1.

The module then introduced the *launch* and *capture* edges: the launch edge clocks data
out of the source flop, the capture edge samples it at the destination flop one period
later. All constraint arithmetic of the next section is bookkeeping between these two edges.

== Paths, constraints and slack <sec-sta-paths>

#imgfig("assets/fig/sta-path.svg",
  [A register-to-register timing path: launch flip-flop, combinational cloud, capture
  flip-flop, with the shared clock underneath. The start point of a path is an input port
  or a clock pin of a sequential cell; the end point is an output port or a data pin of a
  sequential cell. The four path classes taught in the module are listed below.])
<fig-stapath>

A *timing path* chains every arc from a start point to an end point; the module distinguishes
input→register, register→register, register→output and pure combinational input→output
paths (chips in Figure #ref(<fig-stapath>)). Path delay is simply the sum of cell delays
(from the library's delay model) and net delays (from layout parasitics or a wire-load
model). Against that arrival time, the constraint defines a required time, and their
difference is *slack* — the currency of timing closure:

#eq(tag: "7.1")[slack\_setup = T\_required − T\_arrival  ,  slack\_hold = T\_arrival − T\_required]

For the register-to-register path of Figure #ref(<fig-stapath>) the module derived the two
checks that every later lab and the capstone were measured against:

#eq(tag: "7.2")[T\_clk + T\_skew  ≥  T\_c2q + T\_comb + T\_setup   (setup / max path)]
#eq(tag: "7.3")[T\_c2q + T\_comb  ≥  T\_hold + T\_skew            (hold / min path)]

with direct analogues for input-to-register paths (input delay models the outside launch
logic as an equivalent t\_c2q plus combinational delay) and register-to-output paths (output
delay models the outside capture logic as an equivalent setup requirement). Negative slack
on a max path means the clock period is unachievable; negative slack on a min path means
hold violations, which — unlike setup violations — cannot be fixed by slowing the clock.

== Constraint writing laboratory (XDC) <sec-sta-lab>

The module's laboratory applied the theory to a small design, `timing_paths.v`, containing
one register-to-register path, one input-to-register path, one register-to-output path and
one pure combinational path — deliberately one of each class. Constraints were written in
XDC for Vivado, parameterised as percentages of a 10 ns clock period so that every delay
budget is derived, not guessed:

#vcode("timing_paths.xdc (excerpt)", "FPGA-labs-project/22_7", include("../snippets/xdc.typ"))

The exercise closed the loop of #ref(<sec-asic>): the same four commands
(`create_clock`, `set_input_delay`, `set_output_delay`, `set_max_delay`/`set_min_delay`)
that make STA meaningful in an ASIC sign-off are what make synthesis optimise the right
paths on an FPGA. Reviewing the reported slack of each of the four paths against
Equations 7.1–7.3 was the final laboratory act of the technical programme.
