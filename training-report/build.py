#!/usr/bin/env python3
"""Build the NTI training report PDF.

Usage:  python3 build.py [output.pdf]
Regenerate figures first with:  python3 tools/make_figs.py && python3 tools/vcd_wave.py <vcd> && python3 tools/highlight.py
"""
import os
import sys
import typst

HERE = os.path.dirname(os.path.abspath(__file__))
FONTS = [os.path.join(HERE, "assets", "fonts")]
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "NTI_Training_Report_Zeyad_Khaled.pdf")

typst.compile(os.path.join(HERE, "main.typ"), output=OUT, font_paths=FONTS)
print("built", OUT)
