#import "styles.typ": *

// ── 6 Finite-state machines ────────────────────────────────────────────────
= Finite-state machines <ch-fsm>

The FSM module (16 and 19 July) supplied the design technique behind the sequence-detector
lab, the debouncer, the capstone controllers and — conceptually — every controller written
during the training.

== What an FSM is and why it matters

A finite-state machine models a system that transits among a finite number of internal
states, with each transition determined by the current state and the external inputs.
Unlike regular sequential circuits (counters, shifters) whose next-state logic is
structured, an FSM's next-state logic is built from scratch — "random" logic — which is
precisely why it can implement arbitrary control policies. In practice the FSM is the
*controller* of a digital system: it examines commands and status flags and asserts the
control signals that steer a datapath of regular components. Every lab controller in
#ref(<ch-labs>) — the VeriRISC control unit, the PISO sequencer, the capstone ECUs —
is an instance of this pattern.

== Moore versus Mealy

#tbl(
  [Moore and Mealy machines compared, as tabulated in the FSM lecture],
  (left, auto, auto),
  ([Feature], [Moore], [Mealy]),
  ([Output depends on], [Current state only], [Current state and inputs]),
  ([Output timing], [Changes only with state (clock edges)], [May change immediately with inputs]),
  ([States needed], [Usually more], [Typically fewer]),
  ([Glitch susceptibility], [Lower — outputs stable between edges], [Higher — outputs react to inputs]),
  ([Reaction speed], [One cycle later], [Same cycle]),
  ([Typical use], [Control FSMs where stability matters], [Protocol/datapath FSMs needing fast reaction]),
)

The lecture's worked pair — a Moore traffic-light controller and a Mealy sequence detector —
made the trade-off tangible, and the laboratory of #ref(<sec-lab-seq>) implements
both detector flavours so the difference can be read on a waveform.

== Representation: state diagrams and ASM charts

An FSM is specified graphically before it is coded. State diagrams draw states as annotated
circles and transitions as arcs labelled with the input condition that fires them; Moore
outputs live inside the circle, Mealy outputs on the arcs. Algorithmic-state-machine (ASM)
charts pack the same information into a flowchart-like form — one state box per state with
a single exit, decision boxes testing conditions, conditional output boxes for Mealy
outputs — which scales better when transition conditions grow complex. The detector of
Figure #ref(<fig-fsmseq>) is drawn as a state diagram because its conditions are single
bits.

== Coding an FSM in Verilog

The lecture's development procedure mirrors that of any sequential circuit — separate the
state register, then derive next-state and output logic — with five code segments:
state encoding, register/signal declaration, the state register itself, the next-state
logic following the diagram, and the output logic. The recommended idiom is three
procedural blocks: a clocked block for the state register, a level-sensitive block for the
next state, and (for Moore machines) a third block or assignment for outputs.

#tbl(
  [State-encoding techniques and their trade-offs],
  (left, auto, auto, left),
  ([Encoding], [Flip-flops for N states], [Strengths], [Weaknesses / use]),
  ([Binary], [ceil(log2(N))], [Minimal area], [Deeper decode logic; small FSMs]),
  ([One-hot], [N], [Shallow, fast next-state logic; easy debug; FPGA-friendly], [Many flip-flops; power in large FSMs]),
  ([Gray], [ceil(log2(N))], [One bit changes per transition: low switching power], [Only helps sequential traversal]),
)

On FPGAs the abundant register file makes one-hot encoding usually the best trade, while
binary encoding protects area in ASIC designs — a decision the capstone controllers resolve
explicitly in their design notes.
