#import "styles.typ": *

// ── 1 Introduction · 2 The training organisation ───────────────────────────
= Introduction

== Overview of the training

The summer field training _Digital IC Design Using FPGA_ is an intensive, practice-first
programme in digital integrated-circuit design. Over five weeks and 120 hours it follows the
path a design engineer actually walks: devices and technology first, then the language of
hardware description, then simulation and verification discipline, then the timing closure
that decides whether a design ships, and finally a team project that puts all of it to work
on a realistic problem. Lectures were delivered live online, and every lecture block was
immediately followed by laboratory work in which the same concepts were re-derived as
Verilog source, testbenches and waveforms.

== Goals and objectives

The training strategy pursued four goals, each of which translates into concrete outcomes
evidenced later in this report:

#bullets(
  [[*Foundations.*] Understand what an integrated circuit is, how CMOS technology makes
    digital logic cheap and fast, and how power, delay and area trade against each other
    (#ref(<ch-foundations>)).],
  [[*Design language.*] Become fluent in Verilog as a _hardware_ description language: data
    types, hierarchy, procedural blocks, blocking versus non-blocking assignment,
    functions, tasks, generate constructs and finite-state machines — and know which
    constructs synthesise into which hardware (#ref(<ch-rtl>), #ref(<ch-fsm>)).],
  [[*Verification discipline.*] Treat simulation as the primary proof of correctness: write
    self-checking testbenches, read waveforms critically, and use static timing analysis to
    reason about setup, hold and slack without simulating (#ref(<ch-sta>),
    #ref(<ch-labs>)).],
  [[*Engineering practice.*] Work from written specifications, keep designs in version
    control, deliver a team capstone project on schedule, and document everything
    (#ref(<ch-labs>) to #ref(<ch-project>)).],
)

== Scope and structure of this report

The report follows the faculty's training-report instructions: a cover page with the full
identification data, a table of contents, an abstract, numbered titled sections, figures
with explanatory text, and appendices. #ref(<ch-org>) introduces the hosting
organisation; #ref(<ch-program>) describes the programme schedule and workload;
#ref(<ch-foundations>) to #ref(<ch-sta>) present the scientific content learned;
#ref(<ch-labs>) documents the hands-on laboratories with design code and simulation
results; #ref(<ch-project>) presents the capstone project; Chapters
#ref(<ch-skills>)–#ref(<ch-conclusion>) evaluate the experience and conclude. Appendices
list the code repositories, the laboratory-to-repository mapping and the daily training log.

= The training organisation <ch-org>

== The National Telecommunication Institute (NTI)

The National Telecommunication Institute (NTI) is the training arm of Egypt's
telecommunication sector: a public institute that converts engineering graduates and
students into industry-ready specialists in communications, networks, embedded systems and
chip design. NTI runs its programmes as condensed versions of real engineering work —
specification sheets, design reviews, tool flows and deadlines — which is exactly the
culture encountered during this training: lab sheets read like industrial design
specifications, and deliverables were reviewed against them.

== Collaboration with ITIDA

The programme was delivered in collaboration with the Information Technology Industry
Development Agency (ITIDA), the agency responsible for developing Egypt's electronics and
embedded-software industry. The NTI × ITIDA frame gives the training its explicit purpose:
to build a national pool of engineers able to work in digital IC design — a field the
initiative treats as strategic. For students this meant curricula written against current
industry flows (RTL → synthesis → timing closure) rather than against exam syllabi.

== The part of the organisation I worked with

Within NTI, the training belongs to the embedded systems and VLSI training track. The track
supplied the lecture material (_Introduction to Digital IC Design_ and the _RTL Design
Course_, plus FSM and static-timing-analysis modules), the laboratory sheets (Labs 1–9 and
the counter lab), the simulation environment guidance (ModelSim/QuestaSim project flows,
with Icarus Verilog and Vivado as alternatives), and the project-recognition scheme under
which the capstone of #ref(<ch-project>) was submitted and reviewed.

== Delivery mode, team and responsibilities

The training ran fully online: live lectures with shared slides and whiteboard, followed by
self-paced laboratory work in a local ModelSim/QuestaSim installation, with design sources
kept in Git repositories and reviewed asynchronously by the instruction team.

#tbl(
  [Training team and points of contact],
  (left, left, left),
  ([Role], [Name], [Contribution]),
  ([Supervisor], [Eng. Mohammed Salah Aboshosha], [Overall supervision; Verilog and FSM lectures; lab reviews; STA module (co-author)]),
  ([Instructor], [Eng. Omar Mostafa Aladawy], [_Introduction to Digital IC Design_ course: devices, CMOS, power, ASIC/FPGA flows]),
  ([Instructor], [Eng. Mohammed Salah Aboshosha], [_RTL Design Course_, procedural blocks, functions/tasks, counter and FSM labs]),
  ([STA module], [Eng. Ahmed Abdelazeem (co-author)], [Static timing analysis material: arcs, unateness, constraints, slack]),
  ([Organisation], [NTI × ITIDA], [Curriculum, lab sheets, project recognition, discussion sessions]),
)

My responsibilities as a trainee were, in the order the programme demanded them: to attend
and prepare for lectures; to implement every laboratory from its specification sheet without
reference solutions; to write and extend testbenches until each design passed its
self-checks; to maintain a personal repository of all designs, testbenches and simulation
projects; to co-design two of the five capstone ECU modules and verify them; and finally to
write this report and prepare for the faculty discussion.
