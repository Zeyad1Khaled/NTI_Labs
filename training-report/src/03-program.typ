#import "styles.typ": *

// ── 3 The training programme ────────────────────────────────────────────────
= The training programme <ch-program>

== Schedule and phases

#imgfig("assets/fig/timeline.svg",
  [The five-week training plan. Lecture blocks (Introduction to Digital IC Design, the RTL
  Design Course, finite-state machines and static timing analysis) alternate with laboratory
  blocks; the capstone project proposal, implementation and review occupy week three onward,
  and the closing days are reserved for report writing and discussion preparation.
  Milestones are marked on the lower axis.])
<fig-timeline>

The programme divides naturally into four phases, as the timeline of
Figure #ref(<fig-timeline>) shows. The first week builds foundations: the history and
economics of integrated circuits, CMOS device physics, power and timing fundamentals, and
the ASIC and FPGA implementation flows, together with the opening chapters of the RTL
course (logic gates, number systems, module syntax and modelling styles). The second week
is the laboratory core: data types and hierarchy, procedural blocks and assignment
semantics, then Labs 3–8 — multiplexer, tri-state driver, ALU, controller, register and
memory — followed by the case-statement variants, functions and tasks, and the FSM lecture
with its state-diagram and encoding techniques. The third week deepens both threads:
counters in three modelling styles, Mealy/Moore edge detectors, the 110101 sequence
detector, a switch-debouncer design, and the static-timing-analysis module closed by a
constraint-writing laboratory in XDC; the same week carries the capstone proposal
(19 July) and submission (23 July). The remaining days until 6 August were used to polish
the project presentation, re-verify all waveforms, and prepare this report and the faculty
discussion.


== Workload

The 120 contracted hours split roughly equally between taught material, supervised
laboratory work and project work:

#tbl(
  [Distribution of the 120 training hours],
  (left, auto, left),
  ([Activity], [Hours], [Evidence in this report]),
  ([Live lectures and reviewed material], [48], [#ref(<ch-foundations>) to #ref(<ch-sta>)]),
  ([Laboratory implementation and simulation], [48], [#ref(<ch-labs>), Appendix B]),
  ([Capstone project (team of five)], [16], [#ref(<ch-project>)]),
  ([Report writing, review, discussion prep], [8], [This document; Appendix C]),
  ([*Total*], [*120*], [—]),
)

A day-by-day log of sessions, topics and hours is given in #ref(<app-log>); it is
consistent with the commit history of the laboratory repository, whose directories are
named by session date (11\_7, 12\_7, … 22\_7).

== Toolchain and working method

All design work was performed with a professional flow mirrored at home:

#tbl(
  [Tools used during the training and their role],
  (left, left),
  ([Tool], [Role in the training]),
  ([ModelSim / QuestaSim 10.1d], [Primary simulator: prepared `.mpf` projects per lab, waveform review, VCD dumps]),
  ([Icarus Verilog + GTKWave], [Command-line cross-checks of every lab (`iverilog -o sim.vvp src/*.v tb/*.v`)]),
  ([AMD Vivado], [Synthesis experiments and the XDC constraint laboratory of #ref(<sec-sta-lab>)]),
  ([Git / GitHub], [Version control of all designs; two public repositories (#ref(<app-repos>))]),
  ([Verilog-2001 / SystemVerilog], [Description language of all labs and the capstone]),
)

The working method enforced by the lab sheets — and adopted for the whole training — was:
read the specification and its block diagram; name ports exactly as the diagram does;
write the RTL; simulate against the supplied testbench; extend the testbench with
self-checks; only then commit. Waveform screenshots and console logs were kept as evidence
for each lab, and several of them appear in #ref(<ch-labs>).
