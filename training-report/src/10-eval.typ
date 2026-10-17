#import "styles.typ": *

// ── 10 Skills · 11 Evaluation · 12 Conclusion ──────────────────────────────
= Competencies acquired <ch-skills>

The table maps each competency claimed by this report to the artefact that evidences it.

#tbl(
  [Competency map: what was learned and where it is evidenced],
  (left, left, left),
  ([Competency], [Level reached], [Evidence]),
  ([CMOS/IC fundamentals], [Can explain device→gate→chip trade-offs (power, delay, area)], [#ref(<ch-foundations>); course quick-checks]),
  ([Verilog RTL], [Fluent: styles, parameters, hierarchy, assignment semantics], [All lab sources, #ref(<ch-labs>)]),
  ([Sequential design], [Counters, registers, RAMs, reset strategies without latches], [Labs 5–8]),
  ([FSM design], [Diagram → three-block RTL, Moore/Mealy choice, encoding choice], [Lab 9, capstone controllers]),
  ([Verification], [Self-checking testbenches, randomised stimulus, waveform reading], [All testbenches; Figures #ref(<fig-wavefetch>)–#ref(<fig-waveexec>)]),
  ([Static timing analysis], [Arcs, unateness, setup/hold, slack, XDC constraints], [#ref(<ch-sta>); XDC lab]),
  ([Tooling], [ModelSim/Questa projects, Icarus CLI, Vivado synthesis, VCD review], [#ref(<ch-program>) toolchain table]),
  ([Engineering practice], [Spec-first work, Git versioning, code review, team delivery], [Repositories; capstone of #ref(<ch-project>)]),
)

= Evaluation of the experience <ch-eval>

== What worked well

The training's strongest feature is its *specification culture*. Every lab arrived as a
written spec with a block diagram, port names and a verification expectation — the format
industry uses — so the habit formed early of designing from a document rather than from a
solution. The second strength is sequencing: each lecture block was immediately consumed by
a lab that used it, which is why concepts like non-blocking assignment arrived as debugging
lessons rather than as slides. The third is the verification emphasis: self-checking
testbenches turned "it looks right on the waveform" into "it prints TEST PASSED", and the
repository keeps that evidence reviewable. Finally, the team capstone reproduced a real
engineering constraint — a fixed proposal date, a fixed submission date, five people, one
repository — and the review session treated the designs as products, not homework.

== Difficulties encountered, objectively

#bullets(
  [[*Assignment semantics.*] The first datapath bug was a blocking assignment inside a
    clocked block: simulation and intent agreed, the synthesised structure did not. Fixing
    it cost an evening and produced the personal rule now stated in Section 5.3.],
  [[*Bidirectional buses.*] Laboratory 5's `inout` port fought every instinct: driving it
    from a procedural block compiled, simulated wrong, and only the net/variable model of
    Section 5.2 explained why.],
  [[*Handshake debugging.*] In Laboratory 4 a one-cycle-too-early `valid` corrupted roughly
    one word in a thousand; finding it required reading the waveform at the protocol
    level, not the code level — a skill the training explicitly set out to teach.],
  [[*Online delivery.*] The fully online mode saved travel and made recordings revisitable,
    but it taxed hands-on moments: no bench, no board for most of the programme, and
    debugging help arrived asynchronously. Mitigations adopted: office-hour slots, a shared
    team chat for waveform screenshots, and local FPGA demos at the end.],
  [[*Scope pressure.*] Five capstone modules in four days after a full lab week stretched
    the team; two modules were deliberately simplified (spoiler slew window, parking zone
    count) and the simplifications are documented in the project notes rather than hidden.],
)

== Reflection on my own performance

I attended all sessions, delivered every laboratory from its specification without
reference solutions, and kept the repository commit-by-commit in session order — which is
why #ref(<app-log>) can be cross-checked against commit dates. My strongest
contributions were the integrated datapath and the control-unit testbench; my weakest
moment was underestimating the capstone's integration cost and discovering it on the
proposal day. If I repeated the training I would start the project repository on day one
and route every lab through the same continuous-integration habit I built only in week
three. On balance the experience moved me from writing Verilog to *designing hardware in
Verilog*: the language became a means, and the waveform became the argument.

= Conclusion and future work <ch-conclusion>

The 120-hour NTI × ITIDA training delivered what its title promises: a complete first pass
over digital IC design as practised today. It began with the physics and economics of
CMOS, crossed the abstraction layers through Verilog RTL, established verification and
timing closure as non-negotiable disciplines, and ended with a team capstone that put five
synthesizable controllers on an FPGA and proved them cycle-accurate. The laboratories,
waveforms and code preserved in the accompanying repositories (Appendix
#ref(<app-repos>)) are the durable product of that month; this report is its account.

The natural continuation is the back-end half of Figure #ref(<fig-asic>): physical design
and sign-off in a real technology node, constraint-driven synthesis at scale, and formal
verification; on the verification side, moving from self-checking testbenches to
constrained-random methodologies (UVM); and on the hardware side, porting the capstone
suite from simulation to a physical board with real sensors and actuators. The training
ended, in the best sense, by making those next steps concrete and scheduled.
