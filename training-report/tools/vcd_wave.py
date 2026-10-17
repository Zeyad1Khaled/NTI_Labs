"""Parse a ModelSim VCD and render publication-quality digital waveforms as SVG."""
import re
import sys
from figlib import Fig, INK, NAVY, BLUE, LBLUE, GRAY, LGRAY, GOLD, RED, WHITE, MONO


def parse_vcd(path):
    vars_ = {}          # id -> (scope, name, width)
    scope_stack = []
    events = {}         # id -> list of (time, value_str)
    t = 0
    with open(path, errors="ignore") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            if line.startswith("$scope"):
                scope_stack.append(line.split()[2])
            elif line.startswith("$upscope"):
                scope_stack.pop()
            elif line.startswith("$var"):
                p = line.split()
                width, vid, name = int(p[2]), p[3], p[4]
                bit = p[5] if len(p) > 6 else None
                if vid not in vars_:      # first declaration wins (ModelSim reuses ids for aliases)
                    vars_[vid] = (".".join(scope_stack), name, width, bit)
            elif line.startswith("#"):
                t = int(line[1:])
            elif line[0] in "01xXzZ":
                vid = line[1:]
                events.setdefault(vid, []).append((t, line[0]))
            elif line[0] == "b":
                val, vid = line.split()
                events.setdefault(vid, []).append((t, val))
    return vars_, events


def build_bus(vars_, events, scope, name, width):
    """Reconstruct a bus from bit-blasted ids; returns sorted [(t, int_or_None)]."""
    bits = {}
    for vid, (sc, nm, w, bit) in vars_.items():
        if sc == scope and nm == name and bit is not None:
            idx = int(re.sub(r"\D", "", bit))
            bits[idx] = vid
    if not bits:
        for vid, (sc, nm, w, b) in vars_.items():
            if sc == scope and nm == name and b is None and w == width:
                return [(t, int(v, 2) if set(v) <= set("01") else None)
                        for t, v in events.get(vid, [])]
        return []
    changes = {}
    for idx, vid in bits.items():
        for t, v in events.get(vid, []):
            changes.setdefault(t, {})[idx] = v
    times = sorted(changes)
    cur = {i: "x" for i in bits}
    out = []
    for t in times:
        cur.update(changes[t])
        s = "".join(cur.get(i, "x") for i in sorted(bits, reverse=True))
        out.append((t, None if set(s) - set("01") else int(s, 2)))
    return out


def value_at(series, t):
    v = None
    for tt, vv in series:
        if tt <= t:
            v = vv
        else:
            break
    return v


def render(path, lanes, t0, t1, fname, title, unit="ns", scale=1000.0):
    """lanes: list of (label, series, kind) kind in {'bit','bus'}; series sorted [(t,val)]."""
    W = 1000
    left, right = 150, 975
    lane_h = 46
    H = 90 + lane_h * len(lanes) + 46
    f = Fig(W, H)
    f.title_band(title, "ModelSim / QuestaSim simulation")

    def X(t):
        return left + (t - t0) / (t1 - t0) * (right - left)

    y = 96
    # grid
    step = (t1 - t0) / 8
    for i in range(9):
        gx = X(t0 + i * step)
        f.line(gx, 90, gx, H - 40, stroke=LGRAY, sw=0.8, dash="3 4")
        f.mono(gx, H - 24, f"{(t0 + i * step)/scale:.0f}", size=11, fill=GRAY, anchor="middle")
    f.mono(right, H - 8, f"time ({unit})", size=11, fill=GRAY, anchor="end")
    for label, series, kind in lanes:
        f.mono(20, y + lane_h / 2 + 4, label, size=13.5, fill=INK, weight="600")
        f.line(left, y + lane_h - 6, right, y + lane_h - 6, stroke=LGRAY, sw=0.7)
        if kind == "bit":
            hi, lo = y + 8, y + lane_h - 12
            pts = []
            prev = value_at(series, t0)
            pts.append((X(t0), hi if prev == "1" or prev == 1 else lo))
            for t, v in series:
                if t < t0:
                    continue
                if t > t1:
                    break
                yy = hi if v in ("1", 1) else lo
                if pts and pts[-1][1] != yy:
                    pts.append((X(t), pts[-1][1]))
                pts.append((X(t), yy))
            pts.append((X(t1), pts[-1][1]))
            f.polyline(pts, stroke=NAVY, sw=2.2)
        else:
            top, bot = y + 8, y + lane_h - 12
            mid = (top + bot) / 2
            prev = value_at(series, t0)
            seg_start = t0
            segs = []
            for t, v in series + [(t1, None)]:
                if t < t0:
                    prev = v if t >= 0 else prev
                    continue
                if v != prev:
                    segs.append((seg_start, min(t, t1), prev))
                    seg_start = t
                    prev = v
                if t > t1:
                    break
            for a, b, v in segs:
                if b <= a:
                    continue
                xa, xb = X(a), X(b)
                if v is None:
                    f.line(xa, mid, xb, mid, stroke=RED, sw=2, dash="4 4")
                else:
                    f.polyline([(xa + 5, top), (xb - 5, top), (xb - 5, bot), (xa + 5, bot), (xa + 5, top)],
                               stroke=BLUE, sw=2)
                    f.line(xa, top, xa + 5, mid, stroke=BLUE, sw=2)
                    f.line(xa, bot, xa + 5, mid, stroke=BLUE, sw=2)
                    f.line(xb - 5, mid, xb, top, stroke=BLUE, sw=2)
                    f.line(xb - 5, mid, xb, bot, stroke=BLUE, sw=2)
                    txt = f"{v:X}"
                    if (xb - xa) > 26:
                        f.text((xa + xb) / 2, mid + 4.5, txt, size=12, fill=NAVY, anchor="middle",
                               family=MONO, weight="600")
        y += lane_h
    f.save(fname)
    print("wrote", fname)


if __name__ == "__main__":
    vcd = sys.argv[1] if len(sys.argv) > 1 else "../../serial-datapath/sim/top_module_tb.vcd"
    vars_, events = parse_vcd(vcd)
    SC = "TOP_MODULE_tb"
    clk = events[[v for v, s in vars_.items() if s[0] == SC and s[1] == "clk"][0]]
    wr = events[[v for v, s in vars_.items() if s[0] == SC and s[1] == "wr_en"][0]]
    din = build_bus(vars_, events, SC, "din", 20)
    out = build_bus(vars_, events, SC, "out", 8)
    az = events[[v for v, s in vars_.items() if s[1] == "a_is_zero"][0]]
    DU = "TOP_MODULE_tb.DUT"
    en = sorted(e for v in {v for v, s in vars_.items() if s[1] == "en"} for e in events.get(v, []))
    piso = sorted(e for v in {v for v, s in vars_.items() if s[1] in ("PISO_out", "serial_out")}
                  for e in events.get(v, []))
    par = build_bus(vars_, events, DU, "parallel_out", 20)
    if not par:
        par = build_bus(vars_, events, "TOP_MODULE_tb.DUT.U3", "parallel_out", 20)
    out = out or build_bus(vars_, events, DU, "out", 8)

    ram = build_bus(vars_, events, "TOP_MODULE_tb.DUT", "ram_dout", 20)
    paddr = build_bus(vars_, events, "TOP_MODULE_tb.DUT", "piso_addr", 8)
    wnum = build_bus(vars_, events, SC, "word_num", 32)

    # window 1: serial fetch of one instruction word (pass 2)
    en_times = [t for t, v in en if v == "1"]
    t0 = en_times[1] - 4000
    t1 = en_times[1] + 125000
    render(vcd, [("clk", clk, "bit"), ("en (load)", en, "bit"), ("PISO_out", piso, "bit"),
                 ("ram_dout", ram, "bus"), ("piso_addr", paddr, "bus"),
                 ("parallel_out", par, "bus")],
           t0, t1, "../assets/fig/wave-fetch.svg",
           "Simulation extract 1 — bit-serial fetch of one 20-bit instruction word")

    # window 2: consecutive executions
    t0 = en_times[4] - 4000
    t1 = en_times[7] + 40000
    render(vcd, [("clk", clk, "bit"), ("word_num", wnum, "bus"),
                 ("out[7:0]", out, "bus"), ("a_is_zero", az, "bit")],
           t0, t1, "../assets/fig/wave-exec.svg",
           "Simulation extract 2 — instruction words executed back-to-back")
    print("ok")
