#import "styles.typ": *

// ── Abstract, acknowledgement, contents ────────────────────────────────────
#heading(level: 1, numbering: none)[Abstract] #h(1em) #text(size: 9pt, fill: gray, style: "italic")[ملخص التقرير]

This report documents the summer field training _Digital IC Design Using FPGA_, a 120-hour
online programme delivered between 6 July and 6 August 2026 by the National
Telecommunication Institute (NTI) in collaboration with ITIDA, and completed as part of the
third-year requirements of the Electronics and Communication Engineering Department,
Faculty of Engineering, Capital University.

The training carried the author from the physics of the transistor to register-transfer
design of the silicon that surrounds us. It opened with the history and economics of
integrated circuits, CMOS technology, power and timing fundamentals, and a walk through
the ASIC and FPGA implementation flows. The core of the programme was hands-on: ten
progressive Verilog laboratories — a parameterised multiplexer, a tri-state bus driver, an
8-bit ALU, an integrated RAM–PISO–SIPO–ALU serial datapath, a bidirectional-port memory, a
generic register and control unit, up/down counters in three modelling styles, an
overlapping 110101 sequence detector and a function-based stream parity generator — each
designed, simulated and self-checked in ModelSim/QuestaSim and preserved in a public Git
repository. Supporting modules covered finite-state-machine theory and coding styles, and
static timing analysis from timing arcs and unateness to setup/hold constraints, slack and
XDC constraint writing. The programme closed with a team capstone: an FPGA-based automotive
ECU suite of five parallel, synthesizable controllers (ABS/traction, RPM limiting, active
spoiler, ultrasonic parking assist and multi-mode drive control), all verified with
self-checking testbenches.

Beyond the technical content, the report reflects on the organisation, the responsibilities
carried during the training, the competencies acquired, and an honest evaluation of the
experience — its strengths, its difficulties and the lessons taken from both.

#v(4pt)
#text(weight: "bold", size: 9.4pt, fill: navy)[Keywords: ] #text(size: 9.4pt)[Verilog, RTL design, FPGA, digital IC design, FSM, static timing analysis, ModelSim, testbench, CMOS, ECU.]

#v(6pt)
#keybox("Acknowledgement")[
  I thank the National Telecommunication Institute and ITIDA for offering this training free
  of charge to engineering students, and my supervisor Eng. Mohammed Salah Aboshosha and
  instructor Eng. Omar Mostafa Aladawy for lectures that never lost the thread between
  transistor physics and working RTL, for patient code reviews, and for lab sheets written
  the way industry writes specifications. I thank my capstone teammates — Amr Waheed, Aly
  Hamdy, Abdelrahman Mohamed and Adham Amr — for long debugging sessions, and my family for
  four weeks of tolerated absence.
]

#v(4pt)
#heading(level: 1, numbering: none)[Contents]
#outline(title: none, depth: 2)

#v(4pt)
#heading(level: 1, numbering: none)[List of Figures]
#outline(title: none, target: figure.where(kind: image), depth: 1)

#heading(level: 1, numbering: none)[List of Tables]
#outline(title: none, target: figure.where(kind: "table"), depth: 1)
