"""Generate all vector figures for the NTI training report."""
import os
from figlib import (Fig, INK, NAVY, BLUE, LBLUE, LBLUE2, GOLD, GRAY, LGRAY,
                    GREEN, RED, PURPLE, WHITE, MONO, SANS, DISP)

OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "fig")
os.makedirs(OUT, exist_ok=True)


def save(fig, name):
    fig.save(os.path.join(OUT, name))
    print("wrote", name)


# ---------------------------------------------------------------- 1 timeline
def timeline():
    f = Fig(1000, 400, bg=WHITE)
    f.title_band("Training timeline — 6 July to 6 August 2026 (120 hours, online)", "NTI × ITIDA")
    x0, x1 = 175, 965
    span = x1 - x0
    def X(w):  # w in weeks (0..4)
        return x0 + w / 4.0 * span
    y0 = 74
    for i, (l1, l2) in enumerate([("WEEK 1", "Jul 6–10"), ("WEEK 2", "Jul 11–17"),
                                  ("WEEK 3", "Jul 18–24"), ("WEEK 4–5", "Jul 25 – Aug 6")]):
        xa, xb = X(i), X(i + 1)
        f.rect(xa + 3, y0, xb - xa - 6, 40, fill=NAVY if i % 2 == 0 else BLUE, stroke="none", rx=8)
        f.disp((xa + xb) / 2, y0 + 17, l1, size=14, fill=WHITE, anchor="middle", weight="700")
        f.text((xa + xb) / 2, y0 + 33, l2, size=12, fill="#CFE0F0", anchor="middle")
    lanes = [
        ("Lectures", [
            (0.0, 1.0, "Intro to Digital IC Design", BLUE),
            (1.35, 0.45, "FSM", BLUE),
            (2.0, 0.75, "Static Timing Analysis", BLUE),
            (0.0, 1.3, "RTL Design Course (Verilog)", NAVY),
        ]),
    ]
    rows = [
        ("Lectures", [(0.0, 1.0, "Intro to Digital IC Design", BLUE),
                      (0.0, 1.3, "RTL Design Course (Verilog)", NAVY),
                      (1.35, 0.45, "FSM", BLUE),
                      (2.0, 0.75, "Static Timing Analysis", NAVY)]),
        ("Hands-on labs", [(1.0, 0.7, "Labs 3–8: MUX→memory", BLUE),
                           (1.7, 0.45, "Funcs & tasks", NAVY),
                           (2.15, 0.8, "Counters · seq-det · STA", BLUE)]),
        ("Capstone project", [(2.03, 0.2, "Proposal", GOLD),
                              (2.25, 0.6, "ECU suite RTL+TB", NAVY),
                              (2.87, 0.35, "Review", BLUE)]),
        ("Report & discussion", [(3.22, 0.78, "Report writing & defence", NAVY)]),
    ]
    y = y0 + 58
    for label, bars in rows:
        f.disp(30, y + 18, label, size=14.5, fill=INK, weight="700")
        sublane = 0
        placed = []
        for (start, wspan, text, col) in bars:
            # simple overlap avoidance: two sublanes per row
            lane = 0
            for p in placed:
                if p[0] == lane and not (start + wspan < p[1] or start > p[2]):
                    lane = 1
            placed.append((lane, start, start + wspan))
            yy = y + lane * 26
            xa, xb = X(start), X(start + wspan)
            f.rect(xa, yy, xb - xa - 4, 23, fill=col, stroke="none", rx=6, op=0.93)
            if xb - xa > 80:
                f.text(xa + 8, yy + 16, text, size=11.5, fill=WHITE)
        y += 58
    f.line(x0, y + 4, x1, y + 4, stroke=LGRAY, sw=1.6)
    for pos, l1, l2 in [(0, "Jul 6", "kick-off"), (1, "Jul 11", "labs start"), (2.03, "Jul 19", "proposal"),
                        (2.62, "Jul 23", "project due"), (4, "Aug 6", "close-out")]:
        x = X(pos)
        f.circle(x, y + 4, 6, fill=GOLD, stroke=NAVY, sw=2)
        f.text(x, y + 28, l1, size=12.5, fill=NAVY, anchor="middle", weight="600", family=DISP)
        f.text(x, y + 44, l2, size=11.5, fill=GRAY, anchor="middle")
    save(f, "timeline.svg")


# ---------------------------------------------------------------- 2 ic era
def ic_era():
    f = Fig(1000, 250)
    f.title_band("Six decades of integration: from valves to systems-on-chip", "Introduction to Digital IC Design")
    y = 130
    f.line(60, y, 940, y, stroke=LGRAY, sw=3)
    eras = [
        (90, "1940s", "Vacuum tubes", "room-sized computers,\nkilowatts per gate", RED),
        (255, "1947", "Transistor", "Bardeen, Brattain &\nShockley, Bell Labs", GOLD),
        (420, "1958–59", "First IC", "Kilby (TI) & Noyce\n(Fairchild)", BLUE),
        (585, "1965", "Moore's Law", "count doubles\n~ every 2 years", NAVY),
        (750, "1970s→", "Microprocessor", "CPU on a chip,\nCAD + HDLs appear", PURPLE),
        (905, "Today", "SoC / FPGA", "billions of devices,\nreconfigurable silicon", GREEN),
    ]
    for i, (x, yr, name, desc, col) in enumerate(eras):
        up = i % 2 == 0
        f.circle(x, y, 8, fill=col, stroke=WHITE, sw=2.5)
        yy = y - 26 if up else y + 40
        f.line(x, y - 10 if up else y + 10, x, yy + (8 if up else -14), stroke=col, sw=1.8)
        f.disp(x, yy, yr, size=16, fill=col, anchor="middle", weight="700")
        f.disp(x, yy - 20 if up else yy + 20, name, size=15, fill=INK, anchor="middle", weight="600")
        for j, dl in enumerate(desc.split("\n")):
            f.text(x, (yy - 40 if up else yy + 38) + j * 15, dl, size=11.5, fill=GRAY, anchor="middle")
    save(f, "ic-era.svg")


# ---------------------------------------------------------------- 3 asic flow
def asic_flow():
    f = Fig(1000, 430)
    f.title_band("The ASIC design flow — front-end vs back-end", "Introduction to Digital IC Design · Part 4")
    f.rect(30, 70, 450, 320, fill=LBLUE2, stroke=BLUE, sw=1.6, rx=12, dash="6 4")
    f.rect(520, 70, 450, 320, fill="#FBF7EA", stroke=GOLD, sw=1.6, rx=12, dash="6 4")
    f.pill(48, 84, 120, 26, "FRONT-END", fill=BLUE)
    f.pill(538, 84, 120, 26, "BACK-END", fill=GOLD)
    fe = ["Specification", "RTL design (Verilog)", "Functional verification", "Logic synthesis",
          "Gate-level verification"]
    be = ["Floorplanning", "Placement", "Clock-tree synthesis", "Routing",
          "Parasitic extraction", "STA sign-off", "DRC / LVS → tape-out"]
    x, y = 60, 124
    for i, s in enumerate(fe):
        f.box(x, y, 190, 38, s, fill=WHITE, stroke=BLUE, lsize=15)
        if i:
            f.arrow(x + 95, y - 12, x + 95, y - 1, sw=2)
        y += 50
    x2, y2 = 830, 124
    for i, s in enumerate(be):
        f.box(x2 - 190, y2, 190, 30, s, fill=WHITE, stroke=GOLD, lsize=13.5)
        if i:
            f.arrow(x2 - 95, y2 - 10, x2 - 95, y2 - 1, sw=2)
        y2 += 38
    f.arrow(155, 316, 155, 402, sw=2)
    f.arrow(155, 402, 735, 402, sw=2)
    f.arrow(735, 402, 735, 388, sw=2)
    f.text(445, 420, "netlist hand-off", size=13, fill=GRAY, anchor="middle", family=MONO)
    save(f, "asic-flow.svg")


# ---------------------------------------------------------------- 4 fpga flow
def fpga_flow():
    f = Fig(1000, 260)
    f.title_band("The FPGA design flow used throughout the training", "RTL → bitstream")
    steps = [("RTL design", "Verilog / SystemVerilog", BLUE),
             ("Simulation", "ModelSim / Questa · Icarus", NAVY),
             ("Synthesis", "RTL → LUTs & FFs", BLUE),
             ("Place & route", "inside the FPGA fabric", NAVY),
             ("Bitstream", ".bit / .bin generation", BLUE),
             ("On-board test", "program & verify", GREEN)]
    x, y, w, h, gap = 34, 110, 140, 62, 22
    for i, (t, s, col) in enumerate(steps):
        xx = x + i * (w + gap)
        f.box(xx, y, w, h, t, s, fill=LBLUE if col != GREEN else "#E7F4EC",
              stroke=col, lsize=16, ssize=11.5)
        if i:
            f.arrow(xx - gap + 2, y + h / 2, xx - 3, y + h / 2, sw=2.4)
    # verification loop
    f.polyline([(x + w + gap + w / 2, y + h + 0), (x + w + gap + w / 2, y + h + 34),
                (x + w / 2, y + h + 34), (x + w / 2, y + h + 3)], stroke=RED, sw=2, dash="7 5")
    f.text((x + w / 2 + x + w + gap + w / 2) / 2, y + h + 52, "fails? → fix RTL and re-simulate",
           size=13, fill=RED, anchor="middle", family=MONO)
    save(f, "fpga-flow.svg")


# ---------------------------------------------------------------- 5 cmos inverter
def cmos():
    f = Fig(1000, 330)
    f.title_band("The CMOS inverter: complementary pull-up / pull-down pair", "CMOS technology")
    cx = 300
    f.mono(cx, 84, "VDD", size=16, fill=RED, anchor="middle", weight="600")
    f.line(cx, 90, cx, 110, stroke=INK, sw=2.4)
    # PMOS
    f.circle(cx, 132, 22, fill=LBLUE, stroke=NAVY, sw=2.4)
    f.line(cx - 22, 132, cx - 40, 132, stroke=INK, sw=2.4)
    f.line(cx, 110, cx, 122, stroke=INK, sw=2.4)
    f.line(cx, 142, cx, 158, stroke=INK, sw=2.4)
    f.text(cx + 32, 128, "PMOS", size=14, fill=NAVY, family=MONO)
    f.text(cx + 32, 145, "(pull-up)", size=12, fill=GRAY, family=MONO)
    # NMOS
    f.circle(cx, 180, 22, fill="#E7F4EC", stroke=GREEN, sw=2.4)
    f.line(cx - 22, 180, cx - 40, 180, stroke=INK, sw=2.4)
    f.line(cx, 158, cx, 170, stroke=INK, sw=2.4)
    f.line(cx, 190, cx, 212, stroke=INK, sw=2.4)
    f.text(cx + 32, 176, "NMOS", size=14, fill=GREEN, family=MONO)
    f.text(cx + 32, 193, "(pull-down)", size=12, fill=GRAY, family=MONO)
    f.line(cx - 40, 132, cx - 40, 180, stroke=INK, sw=2.4)
    f.line(cx - 40, 156, cx - 90, 156, stroke=INK, sw=2.4)
    f.mono(cx - 96, 161, "in", size=16, fill=INK, anchor="end", weight="600")
    f.circle(cx, 156, 4, fill=INK, stroke="none")
    f.line(cx, 156, cx + 90, 156, stroke=INK, sw=2.4)
    f.mono(cx + 96, 161, "out", size=16, fill=INK, weight="600")
    # gnd
    f.line(cx - 16, 212, cx + 16, 212, stroke=INK, sw=2.4)
    f.line(cx - 10, 218, cx + 10, 218, stroke=INK, sw=2.4)
    f.line(cx - 4, 224, cx + 4, 224, stroke=INK, sw=2.4)
    f.mono(cx, 244, "GND", size=16, fill=GRAY, anchor="middle", weight="600")
    # truth table
    tx = 560
    f.disp(tx, 105, "Steady-state behaviour", size=17, fill=NAVY, weight="700")
    rows = [("in", "out", "ON device", True), ("0", "1", "PMOS", False), ("1", "0", "NMOS", False)]
    yy = 122
    for i, (a, b, c, hdr) in enumerate(rows):
        fill = NAVY if hdr else (WHITE if i % 2 else LBLUE2)
        col = WHITE if hdr else INK
        f.rect(tx, yy, 380, 34, fill=fill, stroke=LGRAY, sw=1)
        f.mono(tx + 40, yy + 22, a, size=15, fill=col, anchor="middle", weight="600")
        f.mono(tx + 120, yy + 22, b, size=15, fill=col, anchor="middle", weight="600")
        f.text(tx + 250, yy + 22, c, size=14, fill=col, anchor="middle", family=MONO)
        yy += 34
    f.text(tx, yy + 30, "Exactly one transistor conducts in steady state →", size=13.5, fill=GRAY)
    f.text(tx, yy + 48, "near-zero static power; power is spent only on switching.", size=13.5, fill=GRAY)
    save(f, "cmos-inverter.svg")


# ---------------------------------------------------------------- 6 modeling styles
def modeling():
    f = Fig(1000, 300)
    f.title_band("One specification, three Verilog modelling styles", "RTL design course · Part 3")
    cols = [("Structural", "explicit gates / instances", BLUE),
            ("Dataflow", "continuous assign equations", NAVY),
            ("Behavioural", "always blocks & algorithms", PURPLE)]
    x = 40
    for name, sub, col in cols:
        f.rect(x, 76, 300, 200, fill=LBLUE2, stroke=col, sw=2, rx=12)
        f.pill(x + 18, 92, 130, 26, name.upper(), fill=col)
        f.text(x + 18, 140, sub, size=13, fill=GRAY)
        x += 320
    # structural sketch: and/or gates
    bx = 70
    f.polyline([(bx, 175), (bx + 26, 175)], stroke=INK, sw=2)
    f.polyline([(bx, 205), (bx + 26, 205)], stroke=INK, sw=2)
    f.rect(bx + 26, 172, 34, 36, fill=WHITE, stroke=INK, sw=2, rx=4)
    f.text(bx + 43, 195, "&", size=18, fill=INK, anchor="middle", family=MONO)
    f.polyline([(bx + 60, 190), (bx + 90, 190)], stroke=INK, sw=2)
    f.rect(bx + 90, 172, 34, 36, fill=WHITE, stroke=INK, sw=2, rx=4)
    f.text(bx + 107, 195, "≥1", size=14, fill=INK, anchor="middle", family=MONO)
    f.polyline([(bx + 124, 190), (bx + 150, 190)], stroke=INK, sw=2)
    f.mono(bx + 10, 165, "a, b, c …", size=12, fill=GRAY)
    f.mono(bx + 152, 182, "y", size=13, fill=INK)
    f.mono(bx, 250, "and U1 (.y(n1), .a(a), .b(b));", size=11.5, fill=GRAY)
    # dataflow sketch
    dx = 390
    f.mono(dx, 185, "assign y = (a & b) | c;", size=15, fill=NAVY, weight="600")
    f.polyline([(dx, 205), (dx + 210, 205)], stroke=NAVY, sw=2)
    f.polyline([(dx + 60, 205), (dx + 60, 225), (dx + 150, 225), (dx + 150, 205)], stroke=NAVY, sw=1.6, dash="4 4")
    f.text(dx, 250, "outputs are continuous functions of inputs", size=11.5, fill=GRAY)
    # behavioural sketch
    px = 700
    f.mono(px, 178, "always @(posedge clk)", size=14, fill=PURPLE, weight="600")
    f.mono(px, 198, "  if (en) q <= d;", size=14, fill=INK)
    f.mono(px, 218, "  else  q <= q;", size=14, fill=INK)
    f.text(px, 250, "describes behaviour; synthesis infers hardware", size=11.5, fill=GRAY)
    save(f, "modeling.svg")


# ---------------------------------------------------------------- helper block diagrams
def io_block(name, fname, inputs, outputs, w=980, h=250, note=None, params=None):
    """inputs/outputs: list of (label, width_or_None)."""
    f = Fig(w, h)
    bw, bh = 300, 150
    bx, by = (w - bw) / 2, (h - bh) / 2 + (10 if not note else 0)
    f.box(bx, by, bw, bh, name, params, fill=LBLUE, stroke=BLUE, sw=3, rx=14, lsize=26, ssize=15)
    n = max(len(inputs), len(outputs))
    for i, (lab, wd) in enumerate(inputs):
        y = by + bh * (i + 1) / (len(inputs) + 1)
        f.arrow(bx - 130, y, bx - 4, y, sw=2.4)
        f.mono(bx - 136, y + 5, lab, size=15, fill=INK, anchor="end", weight="600")
        if wd:
            f.pill(bx - 62, y - 22, 40, 18, wd, fill=NAVY, size=11)
    for i, (lab, wd) in enumerate(outputs):
        y = by + bh * (i + 1) / (len(outputs) + 1)
        f.arrow(bx + bw + 4, y, bx + bw + 130, y, sw=2.4)
        f.mono(bx + bw + 136, y + 5, lab, size=15, fill=INK, weight="600")
        if wd:
            f.pill(bx + bw + 22, y - 22, 40, 18, wd, fill=NAVY, size=11)
    if note:
        f.text(w / 2, h - 12, note, size=13, fill=GRAY, anchor="middle")
    f.save(os.path.join(OUT, fname), viewbox=(95, 0, w - 190, h))
    print("wrote", fname)


def lab_blocks():
    io_block("multiplexor", "mux.svg",
             [("in0", "5"), ("in1", "5"), ("sel", None)], [("mux_out", "5")],
             h=240, note="sel = 0 → in0 passes · sel = 1 → in1 passes · WIDTH parameterised (default 5)",
             params="#(parameter WIDTH = 5)")
    io_block("driver", "driver.svg",
             [("data_in", "8"), ("data_en", None)], [("data_out", "8")],
             h=220, note="data_en = 1 → data_out = data_in · data_en = 0 → data_out = 8'bz (high impedance)",
             params="#(parameter WIDTH = 8)")
    io_block("alu", "alu.svg",
             [("in_a", "8"), ("in_b", "8"), ("opcode", "3")],
             [("alu_out", "8"), ("a_is_zero", "1")],
             h=260, note="eight opcodes: HLT SKZ ADD AND XOR LDA STO JMP · a_is_zero = (in_a == 0)",
             params="#(parameter WIDTH = 8)")
    io_block("memory", "memory.svg",
             [("addr", "5"), ("wr / rd", None), ("clk", None)], [("data (inout)", "8")],
             h=250, note="single bidirectional data port · write on posedge clk when wr · drive bus only when rd",
             params="#(AWIDTH = 5, DWIDTH = 8)")
    io_block("register", "register.svg",
             [("data_in", "8"), ("load", None), ("clk / rst", None)], [("data_out", "8")],
             h=240, note="parallel-load register · synchronous active-high reset · serves as IR and accumulator",
             params="#(parameter WIDTH = 8)")
    io_block("stream_parity_gen", "parity.svg",
             [("clk / reset", None), ("serial_in", "1")], [("parity_out", "1")],
             h=220, note="8-bit sliding window shift register · parity computed by a Verilog function ( ^in )",
             params=None)
    io_block("counter2", "counter.svg",
             [("clock", None), ("reset", None), ("up", None)], [("count", "2")],
             h=240, note="2-bit up/down counter · implemented behaviourally, structurally and at gate level",
             params=None)


# ---------------------------------------------------------------- datapath
def datapath():
    f = Fig(1000, 340)
    f.title_band("Integrated serial datapath: RAM → PISO → serial link → SIPO → ALU", "Labs 3 & 4 capstone lab")
    y = 150
    blocks = [("RAM", "32 × 20\ninstruction memory", 60),
              ("PISO", "parallel-in\nserial-out", 285),
              ("SIPO", "serial-in\nparallel-out", 510),
              ("ALU", "opcode decode\n+ execute", 735)]
    for name, sub, x in blocks:
        f.box(x, y, 170, 90, name, sub.replace("\n", " · "), fill=LBLUE, stroke=BLUE, sw=2.6, rx=12, lsize=22, ssize=12)
    f.arrow(230, y + 40, 283, y + 40, sw=2.6)
    f.text(256, y + 28, "ram_dout", size=11.5, fill=GRAY, anchor="middle", family=MONO)
    f.text(256, y + 16, "[19:0]", size=10.5, fill=GRAY, anchor="middle", family=MONO)
    f.arrow(230, y + 66, 283, y + 66, sw=1.8, dash="5 4")
    f.text(256, y + 82, "ram_valid", size=10.5, fill=GRAY, anchor="middle", family=MONO)
    f.arrow(455, y + 45, 508, y + 45, sw=2.6)
    f.text(481, y + 28, "PISO_out", size=11.5, fill=GRAY, anchor="middle", family=MONO)
    f.text(481, y + 16, "1 bit", size=10.5, fill=GRAY, anchor="middle", family=MONO)
    f.arrow(680, y + 45, 733, y + 45, sw=2.6)
    f.text(706, y + 28, "parallel_out", size=11.5, fill=GRAY, anchor="middle", family=MONO)
    f.text(706, y + 16, "[19:0]", size=10.5, fill=GRAY, anchor="middle", family=MONO)
    # control feedback
    f.polyline([(370, y + 90), (370, y + 130), (145, y + 130), (145, y + 92)], stroke=RED, sw=2, dash="6 5")
    f.text(258, y + 148, "en / piso_addr — PISO steers the RAM read address", size=12.5, fill=RED, anchor="middle", family=MONO)
    # word format
    fy = 62
    f.disp(60, fy, "20-bit instruction word", size=15, fill=NAVY, weight="700")
    segs = [("19", "alu_en", 60, 120, GOLD), ("18:16", "opcode", 180, 200, NAVY),
            ("15:8", "in_a", 380, 260, BLUE), ("7:0", "in_b", 640, 260, "#7FA8CE")]
    for bits, name, x, w, col in segs:
        f.rect(x, fy + 10, w, 34, fill=col, stroke="none", rx=4, op=0.9)
        f.text(x + w / 2, fy + 26, name, size=13, fill=WHITE, anchor="middle", family=MONO, weight="600")
        f.text(x + w / 2, fy + 56, f"[{bits}]", size=11.5, fill=GRAY, anchor="middle", family=MONO)
    save(f, "datapath.svg")


# ---------------------------------------------------------------- micro block
def micro():
    f = Fig(1000, 330)
    f.title_band("VeriRISC-style control unit and register file", "Labs 6 & 7")
    f.box(150, 110, 240, 130, "controller", "phase decode · opcode · zero", fill=LBLUE,
          stroke=BLUE, sw=2.6, rx=12, lsize=22, ssize=13)
    f.box(640, 110, 240, 130, "register", "parallel load · sync reset", fill=LBLUE,
          stroke=BLUE, sw=2.6, rx=12, lsize=22, ssize=13)
    for lab, y in [("opcode[2:0]", 140), ("phase[2:0]", 175), ("zero", 210)]:
        f.arrow(96, y, 146, y, sw=2.2)
        f.mono(92, y + 4, lab, size=13, fill=INK, anchor="end")
    # control bus
    f.polyline([(390, 175), (470, 175)], stroke=INK, sw=4)
    f.text(430, 160, "9 control lines", size=12, fill=GRAY, anchor="middle", family=MONO)
    f.polyline([(470, 175), (470, 140), (636, 140)], stroke=INK, sw=2.2)
    f.mono(560, 132, "ld_ir / ld_ac (load)", size=12, fill=GRAY, anchor="middle")
    f.polyline([(470, 175), (470, 265), (760, 265), (760, 244)], stroke=INK, sw=2.2, dash="6 5")
    f.text(635, 282, "sel · rd · wr · data_e · inc_pc · ld_pc · halt → datapath & memory",
           size=12, fill=GRAY, anchor="middle", family=MONO)
    f.arrow(560, 110, 560, 110, sw=0)
    f.el.pop()
    f.arrow(560, 90, 636, 120, sw=0)
    f.el.pop()
    f.mono(900, 155, "data_out[7:0]", size=13.5, fill=INK)
    f.arrow(880, 150, 896, 150, sw=2.4)
    f.mono(700, 78, "data_in[7:0]", size=13.5, fill=INK, anchor="middle")
    f.arrow(700, 84, 700, 106, sw=2.4)
    f.text(60, 315, "case (phase) decodes the fetch/execute phases; combinational conditions on opcode and zero drive every control line.",
           size=13, fill=GRAY)
    save(f, "micro.svg")


# ---------------------------------------------------------------- fsm seq detector
def fsm_seq():
    f = Fig(1000, 430)
    f.title_band("Moore state diagram — overlapping detector for the sequence 110101", "Lab 9 · FSM")
    R = 33
    st = {"S0": (100, 250), "S1": (240, 160), "S2": (380, 250), "S3": (520, 160),
          "S4": (660, 250), "S5": (800, 160), "S6": (880, 320)}
    prog = {"S0": "–", "S1": "1", "S2": "11", "S3": "110", "S4": "1101", "S5": "11010", "S6": "110101 ✓"}
    for s, (x, y) in st.items():
        col = GREEN if s == "S6" else BLUE
        f.circle(x, y, R, fill=LBLUE if s != "S6" else "#E7F4EC", stroke=col, sw=2.8)
        f.disp(x, y - 1, s, size=16, fill=NAVY, anchor="middle", weight="700")
        f.text(x, y + 16, prog[s], size=11, fill=GRAY, anchor="middle", family=MONO)

    def trimmed(a, b, lab, loff=(0, -8), col=INK):
        x1, y1 = st[a]
        x2, y2 = st[b]
        import math
        dx, dy = x2 - x1, y2 - y1
        L = math.hypot(dx, dy)
        ux, uy = dx / L, dy / L
        sx, sy = x1 + ux * (R + 2), y1 + uy * (R + 2)
        ex, ey = x2 - ux * (R + 6), y2 - uy * (R + 6)
        f.arrow(sx, sy, ex, ey, stroke=col, sw=2.2)
        f.text((sx + ex) / 2 + loff[0], (sy + ey) / 2 + loff[1], lab, size=13, fill=col,
               anchor="middle", family=MONO, weight="600")

    def curve(p0, p1, c, lab, col=GRAY, lpos=0.5, loff=(0, 0)):
        f.raw(f'<path d="M {p0[0]} {p0[1]} Q {c[0]} {c[1]} {p1[0]} {p1[1]}" fill="none" '
              f'stroke="{col}" stroke-width="2.2" marker-end="url(#ah)"/>')
        mx = (p0[0] + 2 * c[0] + p1[0]) / 4
        my = (p0[1] + 2 * c[1] + p1[1]) / 4
        f.text(mx + loff[0], my + loff[1], lab, size=12.5, fill=col, anchor="middle",
               family=MONO, weight="600")

    trimmed("S0", "S1", "1")
    trimmed("S1", "S2", "1")
    trimmed("S2", "S3", "0")
    trimmed("S3", "S4", "1")
    trimmed("S4", "S5", "0")
    trimmed("S5", "S6", "1", loff=(12, 0))
    # resets / fallbacks back to S0
    curve((240, 193), (100, 218), (170, 250), "0", col=GRAY, loff=(0, 14))
    curve((520, 193), (110, 280), (300, 350), "0", col=GRAY, loff=(0, 16))
    curve((800, 193), (120, 282), (450, 400), "0", col=GRAY, loff=(0, 16))
    # self loops
    f.raw(f'<path d="M 362 222 Q 380 182 398 222" fill="none" stroke="{GRAY}" stroke-width="2.2" marker-end="url(#ah)"/>')
    f.text(380, 176, "0", size=13, fill=GRAY, anchor="middle", family=MONO, weight="600")
    f.raw(f'<path d="M 642 222 Q 660 182 678 222" fill="none" stroke="{GRAY}" stroke-width="2.2" marker-end="url(#ah)"/>')
    f.text(660, 176, "1", size=13, fill=GRAY, anchor="middle", family=MONO, weight="600")
    # overlap return S6 -> S2
    curve((848, 330), (400, 275), (620, 380), "1  (overlap: “11” reused)", col=GREEN, loff=(0, 18))
    f.text(880, 372, "S6 asserts seq_detected", size=12.5, fill=GREEN, anchor="middle", family=MONO)
    f.text(880, 388, "for one clock cycle", size=12.5, fill=GREEN, anchor="middle", family=MONO)
    f.text(100, 300, "reset → S0", size=12.5, fill=GRAY, anchor="middle", family=MONO)
    save(f, "fsm-seq.svg")


# ---------------------------------------------------------------- STA path
def sta_path():
    f = Fig(1000, 330)
    f.title_band("Register-to-register timing path and the four path classes", "Static timing analysis")
    y = 130
    f.box(90, y, 130, 90, "FF1", "launch", fill=LBLUE, stroke=BLUE, sw=2.6, rx=10, lsize=20, ssize=12)
    f.rect(330, y + 10, 200, 70, fill="#F3EDFA", stroke=PURPLE, sw=2.4, rx=30)
    f.disp(430, y + 40, "combinational", size=16, fill=PURPLE, anchor="middle", weight="600")
    f.disp(430, y + 60, "cloud", size=16, fill=PURPLE, anchor="middle", weight="600")
    f.box(640, y, 130, 90, "FF2", "capture", fill=LBLUE, stroke=BLUE, sw=2.6, rx=10, lsize=20, ssize=12)
    f.arrow(220, y + 45, 326, y + 45, sw=2.6, label="tCK2Q", loff=(0, -10), lsize=13)
    f.arrow(530, y + 45, 636, y + 45, sw=2.6, label="Tcomb", loff=(0, -10), lsize=13)
    f.polyline([(155, y + 90), (155, y + 122), (705, y + 122), (705, y + 92)], stroke=GOLD, sw=2.4)
    f.text(430, y + 140, "clk (skew = Δ between launch and capture edges)", size=13, fill=GOLD, anchor="middle", family=MONO)
    f.mono(90, y - 14, "start point: clock pin of FF1", size=12.5, fill=GRAY)
    f.mono(640, y - 14, "end point: D pin of FF2", size=12.5, fill=GRAY)
    yy = 292
    classes = [("input → register", BLUE), ("register → register", NAVY),
               ("register → output", PURPLE), ("input → output (pure comb.)", GOLD)]
    x = 60
    for name, col in classes:
        w = f.chip(x, yy, name, fill=WHITE, stroke=col, color=col, size=13.5, h=30)
        x += w + 16
    save(f, "sta-path.svg")


# ---------------------------------------------------------------- setup/hold wave
def setup_hold():
    f = Fig(1000, 320)
    f.title_band("Setup and hold windows around the capturing clock edge", "STA · timing parameters")
    x0, x1 = 120, 880
    yc, yd = 120, 210
    edge = 520
    # clk
    f.mono(40, yc + 6, "clk", size=15, fill=INK, weight="600")
    pts = [(x0, yc + 40)]
    t = x0
    while t < x1:
        pts += [(t, yc + 40), (t, yc), (t + 60, yc), (t + 60, yc + 40)]
        t += 120
    f.polyline(pts, stroke=NAVY, sw=2.6)
    f.line(edge, yc - 18, edge, yd + 60, stroke=RED, sw=1.8, dash="6 5")
    f.text(edge, yc - 26, "capturing edge", size=12.5, fill=RED, anchor="middle", family=MONO)
    # data
    f.mono(40, yd + 6, "D", size=15, fill=INK, weight="600")
    f.polyline([(x0, yd + 40), (300, yd + 40), (300, yd), (430, yd), (430, yd + 40),
                (610, yd + 40), (610, yd), (x1, yd)], stroke=BLUE, sw=2.6)
    f.text(360, yd - 10, "data may change", size=12, fill=GRAY, anchor="middle", family=MONO)
    f.text(700, yd - 10, "data may change", size=12, fill=GRAY, anchor="middle", family=MONO)
    # windows
    f.rect(430, yd + 52, edge - 430, 26, fill="#FBE9E7", stroke=RED, sw=1.6, rx=4)
    f.text((430 + edge) / 2, yd + 70, "tsetup", size=13, fill=RED, anchor="middle", family=MONO, weight="600")
    f.rect(edge, yd + 52, 610 - edge, 26, fill="#E8F5E9", stroke=GREEN, sw=1.6, rx=4)
    f.text((edge + 610) / 2, yd + 70, "thold", size=13, fill=GREEN, anchor="middle", family=MONO, weight="600")
    f.text(520, 300, "data must be stable from tsetup before until thold after the active edge — otherwise the flop may go metastable",
           size=13, fill=GRAY, anchor="middle")
    save(f, "setup-hold.svg")


# ---------------------------------------------------------------- ecu architecture
def ecu():
    f = Fig(1000, 430)
    f.title_band("Capstone: five dedicated hardware ECUs running in parallel on one FPGA", "Final project")
    f.rect(40, 70, 190, 330, fill=LBLUE2, stroke=BLUE, sw=1.8, rx=12, dash="6 4")
    f.disp(135, 96, "SENSORS", size=15, fill=BLUE, anchor="middle", weight="700")
    sens = ["wheel speed ×2", "brake pedal", "throttle", "engine RPM", "ultrasonic echo", "mode dial"]
    for i, s in enumerate(sens):
        f.text(60, 128 + i * 42, "• " + s, size=13.5, fill=INK)
    f.rect(290, 70, 420, 330, fill="#EFF5EB", stroke=GREEN, sw=2, rx=12)
    f.disp(500, 96, "FPGA FABRIC — one clock, true parallelism", size=14.5, fill=GREEN, anchor="middle", weight="700")
    mods = [("ABS + Traction", "wheel-slip compare · pulse brake"),
            ("Smart RPM limiter", "launch · soft cut · hard cut"),
            ("Active spoiler", "speed stages · air-brake"),
            ("Parking assist", "echo timing · zone alerts"),
            ("Drive-mode ctrl", "LUT per mode · slew limit")]
    for i, (n, s) in enumerate(mods):
        y = 112 + i * 57
        f.box(310, y, 380, 48, n, s, fill=WHITE, stroke=GREEN, sw=2, rx=9, lsize=15.5, ssize=11.5, lfill="#1E5B3C")
    f.rect(770, 70, 190, 330, fill=LBLUE2, stroke=BLUE, sw=1.8, rx=12, dash="6 4")
    f.disp(865, 96, "ACTUATORS", size=15, fill=BLUE, anchor="middle", weight="700")
    act = ["brake PWM", "spark / fuel cut", "servo PWM", "LEDs + buzzer", "motor PWM"]
    for i, s in enumerate(act):
        f.text(790, 140 + i * 52, "• " + s, size=13.5, fill=INK)
    for i in range(5):
        y = 136 + i * 57
        f.arrow(232, 200 + (i - 2) * 26, 306, y, sw=1.6, head=True)
        f.arrow(694, y, 766, 200 + (i - 2) * 26, sw=1.6)
    save(f, "ecu-arch.svg")


if __name__ == "__main__":
    timeline()
    ic_era()
    asic_flow()
    fpga_flow()
    cmos()
    modeling()
    lab_blocks()
    datapath()
    micro()
    fsm_seq()
    sta_path()
    setup_hold()
    ecu()
    print("all figures done")
