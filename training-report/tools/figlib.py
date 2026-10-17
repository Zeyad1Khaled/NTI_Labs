"""Minimal SVG drawing helper library for the NTI training report figures.

Consistent visual language:
  - NTI blue / Capital navy palette with gold accent
  - Montserrat for block labels, Fira Sans for prose labels, JetBrains Mono for signals
"""

INK = "#16324F"        # dark ink
NAVY = "#0B3C6E"       # capital navy
BLUE = "#1B6EB4"       # NTI blue
LBLUE = "#E8F1FA"      # light blue fill
LBLUE2 = "#F4F8FC"     # lighter fill
GOLD = "#C9A227"       # capital gold
GRAY = "#5B6B7B"       # secondary text
LGRAY = "#D7E0E9"      # rules
GREEN = "#2E7D5B"
RED = "#C0392B"
PURPLE = "#6B4FA0"
WHITE = "#FFFFFF"

SANS = "Fira Sans"
DISP = "Montserrat"
MONO = "JetBrains Mono"


def esc(s):
    return (str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


class Fig:
    def __init__(self, w, h, bg=WHITE):
        self.w = w
        self.h = h
        self.el = []
        self.bg = bg

    # ---------- primitives ----------
    def raw(self, s):
        self.el.append(s)

    def rect(self, x, y, w, h, fill="none", stroke="none", sw=2, rx=0, dash=None, op=1):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        o = f' opacity="{op}"' if op != 1 else ""
        self.el.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" '
            f'stroke="{stroke}" stroke-width="{sw}"{d}{o}/>')

    def line(self, x1, y1, x2, y2, stroke=INK, sw=2, dash=None, cap="round"):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.el.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{stroke}" '
            f'stroke-width="{sw}" stroke-linecap="{cap}"{d}/>')

    def polyline(self, pts, stroke=INK, sw=2, fill="none", dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        p = " ".join(f"{a},{b}" for a, b in pts)
        self.el.append(f'<polyline points="{p}" fill="{fill}" stroke="{stroke}" '
                       f'stroke-width="{sw}" stroke-linejoin="round" stroke-linecap="round"{d}/>')

    def circle(self, x, y, r, fill="none", stroke=INK, sw=2):
        self.el.append(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"/>')

    def text(self, x, y, s, size=18, fill=INK, family=SANS, weight=None, anchor="start",
             style=None, spacing=None):
        w = f' font-weight="{weight}"' if weight else ""
        st = f' font-style="{style}"' if style else ""
        sp = f' letter-spacing="{spacing}"' if spacing else ""
        self.el.append(
            f'<text x="{x}" y="{y}" font-family="{family}" font-size="{size}" fill="{fill}" '
            f'text-anchor="{anchor}"{w}{st}{sp}>{esc(s)}</text>')

    def mono(self, x, y, s, size=16, fill=INK, anchor="start", weight=None):
        self.text(x, y, s, size=size, fill=fill, family=MONO, anchor=anchor, weight=weight)

    def disp(self, x, y, s, size=20, fill=NAVY, anchor="start", weight="600", spacing=None):
        self.text(x, y, s, size=size, fill=fill, family=DISP, anchor=anchor, weight=weight, spacing=spacing)

    # ---------- composite ----------
    def arrow(self, x1, y1, x2, y2, stroke=INK, sw=2.2, label=None, lsize=15, lfill=GRAY,
              loff=(0, -7), anchor="middle", dash=None, head=True):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        m = ' marker-end="url(#ah)"' if head else ""
        self.el.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{stroke}" stroke-width="{sw}"{d}{m}/>')
        if label:
            lx = (x1 + x2) / 2 + loff[0]
            ly = (y1 + y2) / 2 + loff[1]
            self.text(lx, ly, label, size=lsize, fill=lfill, anchor=anchor, family=MONO)

    def box(self, x, y, w, h, label, sub=None, fill=LBLUE, stroke=BLUE, sw=2.4, rx=10,
            lsize=21, ssize=14.5, lfill=NAVY, sfill=GRAY, lweight="600"):
        self.rect(x, y, w, h, fill=fill, stroke=stroke, sw=sw, rx=rx)
        cy = y + h / 2
        if sub:
            self.disp(x + w / 2, cy - 4, label, size=lsize, fill=lfill, anchor="middle", weight=lweight)
            self.text(x + w / 2, cy + 18, sub, size=ssize, fill=sfill, anchor="middle")
        else:
            self.disp(x + w / 2, cy + lsize * 0.36, label, size=lsize, fill=lfill, anchor="middle", weight=lweight)

    def pill(self, x, y, w, h, label, fill=NAVY, color=WHITE, size=15, weight="600"):
        self.rect(x, y, w, h, fill=fill, stroke="none", rx=h / 2)
        self.disp(x + w / 2, y + h / 2 + size * 0.36, label, size=size, fill=color, anchor="middle", weight=weight)

    def chip(self, x, y, label, fill=LBLUE, stroke=BLUE, color=NAVY, size=14, pad=10, h=26, weight="600"):
        w = len(label) * size * 0.62 + pad * 2
        self.rect(x, y, w, h, fill=fill, stroke=stroke, sw=1.4, rx=h / 2)
        self.disp(x + w / 2, y + h / 2 + size * 0.36, label, size=size, fill=color, anchor="middle", weight=weight)
        return w

    def title_band(self, text, sub=None):
        self.rect(0, 0, self.w, 46, fill=NAVY, stroke="none")
        self.rect(0, 46, self.w, 4, fill=GOLD, stroke="none")
        self.disp(24, 30, text, size=21, fill=WHITE, weight="700")
        if sub and len(text) < 62:
            self.text(self.w - 24, 30, sub, size=14, fill="#BFD6EA", anchor="end")

    def save(self, path, viewbox=None):
        defs = f'''<defs>
<marker id="ah" viewBox="0 0 10 10" refX="8.6" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
<path d="M 0 0.6 L 9.4 5 L 0 9.4 z" fill="{INK}"/>
</marker>
<marker id="ahb" viewBox="0 0 10 10" refX="8.6" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse">
<path d="M 0 0.6 L 9.4 5 L 0 9.4 z" fill="{BLUE}"/>
</marker>
</defs>'''
        vx, vy, vw, vh = viewbox if viewbox else (0, 0, self.w, self.h)
        svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{vw}" height="{vh}" '
               f'viewBox="{vx} {vy} {vw} {vh}">\n{defs}\n'
               f'<rect width="{self.w}" height="{self.h}" fill="{self.bg}"/>\n'
               + "\n".join(self.el) + "\n</svg>\n")
        with open(path, "w") as f:
            f.write(svg)
        return path
