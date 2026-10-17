#import "styles.typ": *

// ── 4 Foundations of digital IC design ─────────────────────────────────────
= Foundations of digital IC design <ch-foundations>

This chapter summarises the _Introduction to Digital IC Design_ course
(Eng. Omar Mostafa Aladawy): why chips exist, how CMOS makes them possible, what limits
them (power, delay), and how a design travels from specification to silicon or to an FPGA
bitstream.

== From vacuum tubes to systems-on-chip

#imgfig("assets/fig/ic-era.svg",
  [Six decades of integration. Each node marks a discontinuity: the vacuum-tube computers
  of the 1940s, the transistor (Bell Labs, 1947), the first integrated circuits
  (Kilby at Texas Instruments, 1958; Noyce at Fairchild, 1959), Moore's 1965 observation,
  the microprocessor era, and today's systems-on-chip and field-programmable devices.])
<fig-era>

Figure #ref(<fig-era>) places the course's historical introduction on a single axis. The
engineering content of that history is Moore's law: Gordon Moore observed in 1965 that the
number of transistors per chip doubles roughly every two years, and the industry has since
treated that observation as a roadmap. The consequences a designer feels are economic as
much as physical — transistors are effectively free, wires and power are not — which is why
modern courses start with technology and power before any logic is written. The course also
classified ICs (analog, digital, mixed-signal; SSI through VLSI) and contrasted the two
implementation vehicles used throughout the training:

#tbl(
  [ASIC versus FPGA — the two implementation vehicles discussed in the course],
  (left, auto, auto),
  ([Aspect], [ASIC], [FPGA]),
  ([Meaning], [Application-specific IC], [Field-programmable gate array]),
  ([Fabric], [Fixed at mask time], [Configurable logic blocks, programmable routing]),
  ([Unit cost / NRE], [Low unit cost, very high NRE], [No NRE, higher unit cost]),
  ([Performance, power], [Best], [Good; overhead of programmability]),
  ([Time to market], [Months (tape-out)], [Hours (bitstream)]),
  ([Role in training], [Reference flow (#ref(<sec-asic>))], [Working vehicle for all labs and the capstone]),
)

== CMOS: the technology under everything <sec-cmos>

#imgfig("assets/fig/cmos-inverter.svg",
  [The CMOS inverter and its steady-state behaviour. A PMOS transistor pulls the output to
  VDD while a NMOS transistor pulls it to GND; the two gates are driven by the same input.
  The table records that exactly one device conducts in steady state, which is the origin
  of CMOS's near-zero static power.])
<fig-cmos>

The course derived digital logic from the MOSFET: a voltage-controlled switch. An NMOS
transistor conducts when its gate is high; a PMOS conducts when its gate is low.
Figure #ref(<fig-cmos>) shows the primitive gate of the whole technology, the CMOS
inverter, together with the property that makes CMOS dominant: in steady state exactly one
of the complementary devices is on, so no direct path exists from VDD to GND and static
current is only leakage. The course followed the inverter through its voltage-transfer
characteristic and noise margins, then through the transmission gate (a parallel NMOS/PMOS
pair used as a bidirectional switch), and showed how latches and edge-triggered flip-flops
are assembled from transmission gates and inverters — the same structures that reappear in
the static-timing-analysis module of #ref(<ch-sta>).

== Power, delay and the cost of speed <sec-power>

Power dissipation was split into two families with different remedies:

#bullets(
  [[*Static power*] — leakage through supposedly-off transistors (subthreshold leakage, gate
    leakage). Remedies: power gating with sleep transistors, multi-threshold cells.],
  [[*Dynamic power*] — charging and discharging of load capacitances at every transition,
    plus short-circuit and glitching current during switching. Remedy set: clock gating,
    voltage and frequency scaling, and reducing switching activity.],
)

The governing relation for switching power, used repeatedly in the course and in the
capstone design reviews, is

#eq(tag: "4.1")[P\_dyn = alpha · C · V^2 · f]

with activity factor $alpha$, switched capacitance $C$, supply $V$ and clock frequency $f$.
Because the supply enters squared, voltage scaling is the strongest lever; because
frequency and activity enter linearly, clock gating and balanced logic (trees instead of
chains, as the RTL course showed for a 4-input XOR) buy power and delay at once. Delay was
introduced through propagation delay, and the timing contract of sequential logic through
setup, hold, recovery and removal times — defined here physically and revisited
analytically in #ref(<ch-sta>).

== The ASIC design flow <sec-asic>

#imgfig("assets/fig/asic-flow.svg",
  [The ASIC flow as taught in the course, split into front-end and back-end. The front-end
  turns a specification into verified RTL and then into a gate-level netlist through logic
  synthesis; the back-end turns the netlist into geometry — floorplan, placement, clock-tree
  synthesis, routing — and closes timing and physical verification before tape-out. The
  horizontal arrow is the netlist hand-off between the two halves.])
<fig-asic>

Figure #ref(<fig-asic>) is the course's map of the front-end/back-end flow. Three stages
received emphasis because they reappear in every later module: *logic synthesis*, which
translates and optimises RTL onto a cell library (and therefore makes coding style a
hardware decision); *static timing analysis*, which proves timing closure without
simulation (#ref(<ch-sta>)); and *physical verification* (DRC/LVS) before tape-out.
The course stressed that incomplete or inaccurate constraints make every downstream step
meaningless — a point returned to in the XDC laboratory.

== The FPGA design flow <sec-fpga>

#imgfig("assets/fig/fpga-flow.svg",
  [The FPGA flow used for every deliverable of the training: RTL is simulated against a
  testbench, synthesised into LUTs and flip-flops, placed and routed inside the fabric, and
  compiled to a bitstream. The dashed return path is the discipline of the course: a failing
  waveform sends the design back to RTL, never forward to the board.])
<fig-fpga>

Figure #ref(<fig-fpga>) shows the flow actually executed during the training. An FPGA
replaces mask steps with configuration memory: configurable logic blocks, programmable
routing and I/O blocks, loaded from a bitstream. The practical difference from the ASIC
flow, for a trainee, is iteration speed — hours instead of months — and the absolute
centrality of simulation: with no silicon to blame, the waveform is the only witness. All
ten laboratories and the capstone of #ref(<ch-project>) followed exactly this loop,
with the dashed feedback exercised many times.
