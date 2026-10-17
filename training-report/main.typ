// ── NTI Summer Training Report — main document ─────────────────────────────
#import "src/styles.typ": *

#doc[
#show figure.where(kind: "table"): set figure(supplement: [Table])
#show figure.where(kind: image): set figure(supplement: [Figure])

// ════════════════ COVER ════════════════
#page(margin: 0pt, header: none, footer: none)[
  #set text(font: sans, fill: ink)
  // top band
  #block(width: 100%, height: 2.6cm, fill: navy)[]
  #block(width: 100%, height: 2.2mm, fill: gold)[]
  #v(0.9cm)
  #grid(columns: (1fr, auto, 1fr), inset: (x: 2.2cm),
    align(left + horizon, image("assets/logos/capital.png", height: 3.4cm)),
    [],
    align(right + horizon, image("assets/logos/nti.png", height: 3.0cm)),
  )
  #v(0.55cm)
  #align(center)[
    #set text(font: disp, fill: navy)
    #text(size: 12.5pt, weight: "semibold", tracking: 1.6pt)[CAPITAL UNIVERSITY · FACULTY OF ENGINEERING]
    #v(2pt)
    #text(size: 10.5pt, fill: gray, font: sans)[Electronics and Communication Engineering Department]
  ]
  #v(0.75cm)
  #align(center)[
    #text(font: disp, size: 27pt, weight: "bold", fill: navy)[Digital IC Design Using FPGA]
    #v(4pt)
    #text(font: disp, size: 14pt, weight: "medium", fill: nblue)[Summer Field-Training Report]
    #v(8pt)
    #block(width: 5.2cm, height: 1.1mm, fill: gold)
    #v(8pt)
    #text(size: 11pt, fill: gray)[Delivered online by the National Telecommunication Institute (NTI) \
      in collaboration with the Information Technology Industry Development Agency (ITIDA)]
  ]
  #v(0.85cm)
  #align(center)[
    #block(fill: xlblue, stroke: 0.8pt + lgray, radius: 8pt, inset: (x: 16pt, y: 12pt), width: 14.6cm)[
      #set text(size: 9.6pt)
      #set par(justify: false)
      #grid(columns: (auto, 1fr, auto, 1fr), column-gutter: 8pt, row-gutter: 5pt,
        text(weight: "bold", fill: navy)[Student:], [Zeyad Khaled Abd Elhamid],
        text(weight: "bold", fill: navy)[University ID:], [2224800358],
        text(weight: "bold", fill: navy)[Faculty:], [Engineering],
        text(weight: "bold", fill: navy)[Academic year:], [Third year],
        text(weight: "bold", fill: navy)[Department:], [Electronics \& Communication Eng. (ECE)],
        text(weight: "bold", fill: navy)[University:], [Capital University],
      )
    ]
    #v(5pt)
    #block(fill: lblue, stroke: 0.8pt + rgb("#B9D3EA"), radius: 8pt, inset: (x: 16pt, y: 12pt), width: 14.6cm)[
      #set text(size: 9.6pt)
      #set par(justify: false)
      #grid(columns: (auto, 1fr, auto, 1fr), column-gutter: 8pt, row-gutter: 5pt,
        text(weight: "bold", fill: navy)[Training:], [Digital IC Design Using FPGA],
        text(weight: "bold", fill: navy)[Mode:], [Online],
        text(weight: "bold", fill: navy)[Period:], [6 July – 6 August 2026],
        text(weight: "bold", fill: navy)[Duration:], [120 hours],
        text(weight: "bold", fill: navy)[Organization:], [National Telecommunication Institute (NTI)],
        text(weight: "bold", fill: navy)[Collaboration:], [NTI × ITIDA],
      )
    ]
  ]
  #v(0.6cm)
  #align(center)[
    #set text(size: 9.4pt)
    #text(weight: "bold", fill: navy)[Supervisor: ] Eng. Mohammed Salah Aboshosha
    #v(2pt)
    #text(weight: "bold", fill: navy)[Instructors: ] Eng. Omar Mostafa Aladawy · Eng. Mohammed Salah Aboshosha
  ]
  #v(1fr)
  #block(width: 100%, height: 2.2mm, fill: gold)[]
  #block(width: 100%, height: 1.5cm, fill: navy)[
    #align(center)[#set text(fill: white, size: 9.5pt, font: sans)
      #v(4.5mm)National Telecommunication Institute · Egypt · nti.sci.eg · Summer 2026]
  ]
]

// ════════════════ FRONT MATTER ════════════════
#include "src/01-front.typ"

// ════════════════ BODY ════════════════

#include "src/02-intro.typ"
#include "src/03-program.typ"
#include "src/04-foundations.typ"
#include "src/05-rtl.typ"
#include "src/06-fsm.typ"
#include "src/07-sta.typ"
#include "src/08-labs.typ"
#include "src/09-project.typ"
#include "src/10-eval.typ"
#include "src/11-back.typ"
]
