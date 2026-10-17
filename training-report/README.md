# NTI Training Report — *Digital IC Design Using FPGA*

Field-training report of **Zeyad Khaled Abd Elhamid** (Capital University, Faculty of
Engineering, Electronics & Communication Engineering, 3rd year, ID 2224800358) for the
National Telecommunication Institute (NTI) × ITIDA summer training
*Digital IC Design Using FPGA* (6 July – 6 August, 120 h, online).

The report follows the structure demanded by the programme's *Training Report*
instructions: cover page with full identification data, table of contents, abstract,
numbered sections, explanatory text for every figure, conclusion, appendices and
references.

## Build

The report is typeset with [Typst](https://typst.app) (Python package `typst`).

```bash
pip install --break-system-packages typst pygments cairosvg   # cairosvg only for proofing
python3 build.py            # -> NTI_Training_Report_Zeyad_Khaled.pdf
```

`build.py` compiles `main.typ` with the fonts bundled in `assets/fonts`
(Montserrat, Fira Sans, JetBrains Mono — SIL Open Font License, see
`assets/fonts/LICENSE-NOTE.md`).

## Layout of this directory

| Path | Purpose |
| --- | --- |
| `main.typ` | document entry point: cover page + includes of all parts inside the `#doc[...]` styling scope |
| `src/styles.typ` | palette, page/heading/figure styling and the helper functions (`imgfig`, `tbl`, `vcode`, `note`, `keybox`, `eq`, …) |
| `src/01-front.typ … 11-back.typ` | the chapters, front matter, appendices and references |
| `assets/fig/*.svg` | the 21 diagrams, block schematics, state diagrams and ModelSim waveform extracts |
| `snippets/*.typ` | syntax-highlighted Verilog/XDC listings (Typst markup) |
| `tools/figlib.py` | tiny SVG drawing library (title bands, arrows, FSM bubbles, bus arrows) |
| `tools/make_figs.py` | regenerates every diagram in `assets/fig/` |
| `tools/vcd_wave.py` | renders waveform figures from the real ModelSim VCD dump `../serial-datapath/sim/top_module_tb.vcd` |
| `tools/highlight.py` | Pygments → Typst-markup converter producing `snippets/*.typ` |
| `build.py` | one-command PDF build |

Regenerate derived assets with:

```bash
cd tools
python3 make_figs.py                                  # all SVG diagrams
python3 vcd_wave.py ../../serial-datapath/sim/top_module_tb.vcd   # waveform figures
python3 highlight.py                                  # code listings
cd .. && python3 build.py
```

Source code discussed in the report lives in the laboratory repositories at the root of
this repository (`multiplexor-2-to-1/`, `tri-state-driver/`, …, `serial-datapath/`) and in
the capstone workspace `alyhamdy879/FPGA-labs-project`.
