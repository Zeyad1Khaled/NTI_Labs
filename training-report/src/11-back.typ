#import "styles.typ": *

// ── References & appendices ────────────────────────────────────────────────
= References

#set par(justify: false)
#enum(
  [O. M. Aladawy, _Introduction to Digital IC Design_, lecture slides, NTI × ITIDA summer training, July 2026 (79 slides).],
  [M. Salah, _Digital Design using FPGA — RTL Design Course_, lecture slides, NTI × ITIDA summer training, July 2026 (203 slides).],
  [M. Salah, _Digital Design using FPGA_ — Verilog depth sessions: data types, hierarchy, procedural blocks, blocking vs non-blocking (11–12 July); `case` variants, functions and tasks (13–14 July); finite-state machines (16 July), NTI, 2026.],
  [M. Salah and A. Abdelazeem, _Static Timing Analysis_ module: timing arcs and unateness, transmission gates, latches and flip-flops, setup/hold, timing paths and slack, NTI, July 2026.],
  [NTI, _Semi-Project Laboratory Sheets 3–9 and the Counter Lab_: modelling an address multiplexor; modelling a data driver; modelling the ALU; modelling a controller; modelling a generic register; modelling a single-bidirectional-port memory; modelling a generic counter; designing a 2-bit up/down counter, NTI, July 2026.],
  [NTI, _Final Project — Group Formation and Proposal Requirements_, announcement, 18 July 2026.],
  [Z. K. Abd Elhamid, _NTI Labs_ — laboratory repository: designs, testbenches and ModelSim projects for all ten labs, GitHub: `Zeyad1Khaled/NTI_Labs`, 2026.],
  [A. Hamdy et al., _FPGA-labs-project_ — session workspace and capstone suite (RTL, testbenches, XDC lab, project report), GitHub: `alyhamdy879/FPGA-labs-project`, 2026.],
  [A. Waheed, A. Hamdy, Z. Khaled, A. Mohamed, A. Amr, _Advanced Automotive ECU: Performance Tuning and Safety Systems_, project proposal and report, NTI project recognition, July 2026.],
  [IEEE Standard for Verilog Hardware Description Language, IEEE Std 1364-2001 (Verilog-2001), and IEEE Std 1800 (SystemVerilog) — language references for the constructs used.],
  [Mentor Graphics, _ModelSim/QuestaSim User Documentation_, v10.1d — simulation environment used throughout.],
)

#heading(level: 1, numbering: n => "A", supplement: [Appendix])[Repository guide and reproduction]
<app-repos>

All laboratory artefacts are preserved in two public repositories:

#tbl(
  [Repositories accompanying this report],
  (left, left, left),
  ([Repository], [Contents], [Use]),
  ([`Zeyad1Khaled/NTI_Labs`], [Ten project directories (`src/`, `tb/`, `sim/` per project), README with layout and history, original submission archives], [Primary evidence for #ref(<ch-labs>)]),
  ([`alyhamdy879/FPGA-labs-project`], [Dated session folders (11\_7 … 22\_7), lab PDFs, XDC lab, capstone `project/` with RTL, testbenches, presentation and report], [Session log cross-check; #ref(<ch-project>)]),
)

Each project in `NTI_Labs` follows one layout — `src/` for RTL, `tb/` for testbenches,
`sim/` for the prepared ModelSim/Questa project (`.mpf`) and waveform dumps — and can be
simulated either by opening the `.mpf` in ModelSim/Questa or from the command line with
Icarus Verilog:

#vcode("Reproducing any laboratory simulation", "NTI_Labs README", [
  #set text(font: mono, size: 8pt)
  \# cd \<project\> #linebreak()
  iverilog -o sim.vvp src/\*.v tb/\*.v #linebreak()
  vvp sim.vvp #h(1.2em) #text(fill: gray, style: "italic")[\/\/ self-checking benches print TEST PASSED]
])

#heading(level: 1, numbering: n => "B", supplement: [Appendix])[Laboratory-to-repository mapping]
<app-map>

#tbl(
  [Full mapping of sessions, laboratories, sources and concepts],
  (left, left, left, left),
  ([Session], [Laboratory / deliverable], [Repository path], [Concepts]),
  ([11 Jul], [Lab 3 — address multiplexor], [`NTI_Labs/multiplexer-2-to-1`], [parameters, level-sensitive blocks]),
  ([11 Jul], [Lab 4 — tri-state driver], [`NTI_Labs/tri-state-driver`], [`z` state, replication]),
  ([11 Jul], [Lab 5 — ALU], [`NTI_Labs/arithmetic-logic-unit`], [operators, `case`]),
  ([12 Jul], [Lab 6 — VeriRISC controller], [`NTI_Labs/microcontroller-controller`], [phase decode, control table]),
  ([12 Jul], [Lab 7 — generic register], [`NTI_Labs/microcontroller-register`], [non-blocking, sync reset]),
  ([13 Jul], [`casex`/`casez` experiments], [`FPGA-labs-project/13_7`], [wildcard matching]),
  ([13–14 Jul], [Lab 10 — stream parity (functions)], [`NTI_Labs/stream-parity-generator`], [functions in RTL]),
  ([14–15 Jul], [Lab 8 — bidirectional memory], [`NTI_Labs/bidirectional-memory`], [`inout`, arbitration]),
  ([14–15 Jul], [Lab 9 — generic counter], [`FPGA-labs-project/14_7`], [blocking + non-blocking mix]),
  ([16 Jul], [FSM lab — Moore/Mealy machines], [`FPGA-labs-project/16_7`], [state diagrams, encoding]),
  ([19 Jul], [Counter in three styles; edge detectors; 110101 detector], [`NTI_Labs/up-down-counter`, `NTI_Labs/sequence-detector-110101`, `FPGA-labs-project/19_7`], [modelling styles, FSM]),
  ([20 Jul], [Switch debouncer], [`FPGA-labs-project/20_7`], [synchronisation, saturation counter]),
  ([22 Jul], [STA constraint lab (XDC)], [`FPGA-labs-project/22_7`], [clocks, delays, slack]),
  ([19–23 Jul], [Capstone ECU suite (team)], [`FPGA-labs-project/project`], [full flow]),
)

#heading(level: 1, numbering: n => "C", supplement: [Appendix])[Daily training log]
<app-log>

Hours per session as recorded in the training log; the total equals the contracted
120 hours.

#tbl(
  [Day-by-day log of the training (6 July – 6 August 2026)],
  (left, left, auto),
  ([Date], [Session content], [Hours]),
  ([Mon 6 Jul], [Opening; course overview; IC history, Moore's law, ASIC vs FPGA], [4]),
  ([Tue 7 Jul], [Semiconductor and CMOS fundamentals; inverter, VTC, noise margins], [4]),
  ([Tue 8 Jul], [Power dissipation; transmission gates, latches, flip-flops; timing parameters], [4]),
  ([Thu 9 Jul], [ASIC flow; FPGA architecture and flow; clocks and timing intro], [4]),
  ([Fri 10 Jul], [RTL course: gates, number systems, module syntax, modelling styles], [4]),
  ([Sat 11 Jul], [Data types, hierarchy, procedural blocks, BA vs NBA; Labs 3–5 (MUX, driver, ALU)], [5]),
  ([Sun 12 Jul], [Labs 6–7 (controller, register); controller testbench completion], [5]),
  ([Mon 13 Jul], [BA/NBA review; `casex`/`casez`; functions; parity lab start], [5]),
  ([Tue 14 Jul], [Tasks (static vs automatic, disable); counter and memory labs], [5]),
  ([Wed 15 Jul], [Memory testbench review; parity generator with generate; lab close-out], [4]),
  ([Thu 16 Jul], [FSM lecture: Moore/Mealy, diagrams, ASM, encoding; FSM lab], [5]),
  ([Sun 19 Jul], [Counters in three styles; Moore/Mealy edge detectors; sequence detector; *project proposal*], [5]),
  ([Mon 20 Jul], [Sequence detector completion; debouncer; testbench hardening], [4]),
  ([Tue 21 Jul], [Capstone implementation: ABS/TCS and RPM limiter modules], [4]),
  ([Wed 22 Jul], [STA lecture: arcs, unateness, setup/hold, paths, slack; XDC lab], [5]),
  ([Thu 23 Jul], [Capstone implementation: spoiler, parking, drive-mode modules; *submission*], [5]),
  ([Sun 26 Jul], [Capstone verification: testbench completion and waveform review], [4]),
  ([Mon 27 Jul], [Capstone verification: randomised stimulus and fixes], [4]),
  ([Tue 28 Jul], [Project presentation and demo video preparation], [4]),
  ([Wed 29 Jul], [Repository restructure: layouts, READMEs, portable ModelSim paths], [4]),
  ([Thu 30 Jul], [Repository review with supervisor; corrections applied], [4]),
  ([Sat 1 Aug], [Report writing: scientific chapters and figure drafting], [4]),
  ([Sun 2 Aug], [Report writing: laboratory chapter with waveforms], [4]),
  ([Mon 3 Aug], [Report writing: project chapter, evaluation, appendices], [4]),
  ([Tue 4 Aug], [Full re-simulation of all labs for report evidence], [4]),
  ([Wed 5 Aug], [Report review against faculty instructions; formatting pass], [4]),
  ([Thu 6 Aug], [Discussion preparation; final review; *training close-out*], [3]),
  ([*Total*], [], [*120*]),
)
