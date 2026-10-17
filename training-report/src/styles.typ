// ── NTI Training Report — style system ─────────────────────────────────────
#let navy   = rgb("#0B3C6E")
#let nblue  = rgb("#1B6EB4")
#let lblue  = rgb("#E8F1FA")
#let xlblue = rgb("#F4F8FC")
#let gold   = rgb("#C9A227")
#let ink    = rgb("#16324F")
#let gray   = rgb("#5B6B7B")
#let lgray  = rgb("#D7E0E9")
#let green  = rgb("#2E7D5B")
#let red    = rgb("#C0392B")

#let sans = "Fira Sans"
#let disp = "Montserrat"
#let mono = "JetBrains Mono"

// ── page furniture ──────────────────────────────────────────────────────────
#let report-title = "Digital IC Design Using FPGA — Summer Training Report"

#let heading-at-here() = {
  let hs = query(selector(heading).before(here()))
  if hs.len() > 0 [#hs.at(-1).body] else [Front matter]
}

#let doc(body) = {
  set page(
    paper: "a4",
    margin: (top: 2.1cm, bottom: 1.7cm, x: 2.05cm),
    header-ascent: 0.5cm,
    footer-descent: 0.5cm,
    header: context {
      if true [
        #set text(size: 8pt, fill: gray, font: sans)
        #grid(columns: (1fr, 1fr),
          [#emph[Digital IC Design Using FPGA] — training report],
          align(right)[#context heading-at-here()])
        #v(-3pt)
        #line(length: 100%, stroke: 0.7pt + lgray)
      ]
    },
    footer: context [
      #set text(size: 8pt, fill: gray, font: sans)
      #line(length: 100%, stroke: 0.7pt + lgray)
      #v(2pt)
      #grid(columns: (1fr, auto, 1fr),
        [NTI × ITIDA · Summer 2026],
        [Page #counter(page).display() of #counter(page).final().first()],
        align(right)[Z. K. Abd Elhamid · 2224800358])
    ],
  )
  set text(font: sans, size: 10.2pt, fill: ink, lang: "en")
  set par(justify: true, leading: 0.62em, first-line-indent: 0em)
  set heading(numbering: "1.1")
  show heading.where(level: 1): set heading(supplement: [Chapter])
  show heading.where(level: 2): set heading(supplement: [Section])
  show heading.where(level: 3): set heading(supplement: [Subsection])
  show heading: set text(font: disp, fill: navy)
  show heading.where(level: 1): set text(size: 17pt, weight: "bold")
  show heading.where(level: 2): set text(size: 13pt, weight: "semibold", fill: nblue)
  show heading.where(level: 3): set text(size: 11.2pt, weight: "semibold", fill: rgb("#2A5F9E"))
  set figure.caption(position: bottom)
  show figure.caption: set text(size: 8.8pt, fill: gray)
  show figure.caption.where(kind: image): set text(size: 8.8pt)
  set figure(placement: auto)
  body
}



// ── figures ─────────────────────────────────────────────────────────────────
#let imgfig(path, caption, width: 100%) = figure(
  image("../" + path, width: width),
  caption: caption,
)

// ── tables ──────────────────────────────────────────────────────────────────
#let tbl(cap, aligns, header, ..rows) = {
  let body = rows.pos().map(r => r.map(cell => {
    let c = if type(cell) == content { cell } else { [cell] }
    return text(size: 8.8pt)[#c]
  }))
  figure(
    kind: "table",
    table(
      columns: aligns.len(),
      align: aligns,
      fill: (x, y) => if y == 0 { navy } else if calc.rem(y, 2) == 1 { xlblue } else { white },
      stroke: 0.6pt + lgray,
      inset: (x: 7pt, y: 5pt),
      table.header(..header.map(h => text(weight: "bold", fill: white, size: 8.8pt)[#h])),
      ..body.flatten(),
    ),
    caption: cap,
  )
}

// ── code listings ───────────────────────────────────────────────────────────
#let vcode(title, tag, body) = block(
  width: 100%,
  fill: xlblue,
  stroke: (top: 1.6pt + nblue, rest: 0.6pt + lgray),
  inset: 0pt,
  breakable: true,
)[
  #block(fill: lblue, inset: (x: 8pt, y: 4pt), width: 100%)[
    #set text(font: mono, size: 8.2pt, fill: navy, weight: "bold")
    #grid(columns: (1fr, auto), [#title], align(right)[#text(fill: gray, weight: "regular")[#tag]])
  ]
  #block(inset: (x: 8pt, y: 6pt), width: 100%)[
    #set text(font: mono, size: 7.5pt, fill: ink)
    #set par(leading: 0.42em)
    #body
  ]
]

// ── callouts ────────────────────────────────────────────────────────────────
#let note(title, body) = block(
  width: 100%,
  fill: lblue,
  stroke: (left: 2.6pt + nblue, rest: 0.6pt + lblue),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 6pt),
)[
  #set par(justify: false)
  #text(weight: "bold", fill: navy, font: disp, size: 9.6pt)[#title]
  #v(2pt)
  #set text(size: 9.4pt)
  #body
  par()
]

#let keybox(title, body) = block(
  width: 100%,
  fill: rgb("#FBF7EA"),
  stroke: (left: 2.6pt + gold, rest: 0.6pt + rgb("#EADFC0")),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 6pt),
)[
  #set par(justify: false)
  #text(weight: "bold", fill: rgb("#8A6D14"), font: disp, size: 9.6pt)[#title]
  #v(2pt)
  #set text(size: 9.4pt)
  #body
  par()
]

// equation display
#let eq(body, tag: none) = align(center, block(
  inset: (y: 4pt),
)[#set text(size: 10.4pt, fill: navy, weight: "semibold")
#body #if tag != none [ (#tag)]])

// small caps lead-in for paragraphs
#let lead(s) = text(weight: "bold", fill: navy, font: disp, size: 9.8pt)[#s ]

// bullet styling
#let bullets(..items) = {
  show list: set list(marker: box(width: 5pt, height: 5pt, fill: nblue, radius: 1pt), indent: 12pt, spacing: 0.35em)
  list(..items.pos())
}
