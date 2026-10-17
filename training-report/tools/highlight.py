"""Convert Verilog sources into syntax-highlighted Typst markup snippets (Pygments)."""
import os
import sys
from pygments import highlight
from pygments.lexers import VerilogLexer, TclLexer
from pygments.token import (Token, Comment, Keyword, Name, Number, String,
                            Punctuation, Operator, Generic)
from pygments.formatter import Formatter

ESC = {"\\": "\\\\", "#": "\\#", "[": "\\[", "]": "\\]", "$": "\\$", "*": "\\*",
       "_": "\\_", "`": "\\`", "~": "\\~", "<": "\\<", ">": "\\>", "@": "\\@"}


def esc(s):
    out = "".join(ESC.get(c, c) for c in s)
    return out.replace("//", "\\/\\/")


COLORS = {
    Comment: ("#5F7183", True, False),
    Comment.Preproc: ("#B7791F", False, True),
    Keyword: ("#0B3C6E", False, True),
    Keyword.Type: ("#0F7B6C", False, True),
    Name: ("#22303C", False, False),
    Number: ("#7A3E9D", False, False),
    String: ("#2E7D32", False, False),
    Operator: ("#44546A", False, False),
    Punctuation: ("#44546A", False, False),
}


def style_for(ttype):
    while ttype not in COLORS and ttype.parent:
        ttype = ttype.parent
    return COLORS.get(ttype, ("#22303C", False, False))


NBSP = "\u00a0"


class TypstFormatter(Formatter):
    def format(self, tokensource, outfile):
        out = []
        at_line_start = True
        for ttype, value in tokensource:
            if value == "":
                continue
            if "\n" in value:
                segs = value.split("\n")
                for si, seg in enumerate(segs):
                    if si > 0:
                        out.append("#linebreak()\n")
                        at_line_start = True
                    if seg == "":
                        continue
                    if at_line_start and seg.startswith(" "):
                        seg = seg.replace(" ", NBSP)
                    at_line_start = False
                    color, ital, bold = style_for(ttype)
                    attrs = 'fill: rgb("' + color[1:] + '")'
                    extra = []
                    if ital:
                        extra.append("style: \"italic\"")
                    if bold:
                        extra.append("weight: \"bold\"")
                    if extra:
                        attrs += ", " + ", ".join(extra)
                    out.append(f"#text({attrs})[{esc(seg)}]")
                continue
            if at_line_start and value.startswith(" "):
                value = value.replace(" ", NBSP)
            at_line_start = False
            color, ital, bold = style_for(ttype)
            attrs = 'fill: rgb("' + color[1:] + '")'
            extra = []
            if ital:
                extra.append("style: \"italic\"")
            if bold:
                extra.append("weight: \"bold\"")
            if extra:
                attrs += ", " + ", ".join(extra)
            out.append(f"#text({attrs})[{esc(value)}]")
        outfile.write("".join(out))


def convert(src_path, out_path):
    code = open(src_path).read()
    lex = TclLexer() if src_path.endswith(".xdc") else VerilogLexer()
    with open(out_path, "w") as fh:
        highlight(code, lex, TypstFormatter(), fh)
    print("highlighted", src_path, "->", out_path)


SNIPPETS = [
    ("multiplexer-2-to-1/src/mux.v", "mux"),
    ("tri-state-driver/src/driver.v", "driver"),
    ("arithmetic-logic-unit/src/alu.v", "alu"),
    ("serial-datapath/src/top_module.v", "topmodule"),
    ("bidirectional-memory/src/memory.v", "memory"),
    ("microcontroller-register/src/register.v", "register"),
    ("microcontroller-controller/src/controller.v", "controller"),
    ("up-down-counter/src/behavioral.v", "counter"),
    ("sequence-detector-110101/src/overlapping.v", "seqdet"),
    ("stream-parity-generator/src/stream_parity_gen.v", "parity"),
]

EXT = [
    ("/tmp/fpga-proj/22_7/timing_paths.xdc", "xdc"),
    ("/tmp/fpga-proj/project/rtl/Drive_Mode_Controller.v", "drive"),
    ("/tmp/fpga-proj/project/rtl/Smart_RPM_Limiter.v", "rpm"),
]

if __name__ == "__main__":
    base = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
    outdir = os.path.join(os.path.dirname(__file__), "..", "snippets")
    os.makedirs(outdir, exist_ok=True)
    for rel, name in SNIPPETS:
        convert(os.path.join(base, rel), os.path.join(outdir, name + ".typ"))
    for abs_p, name in EXT:
        convert(abs_p, os.path.join(outdir, name + ".typ"))
