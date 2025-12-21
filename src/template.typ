#import "@preview/equate:0.3.2": equate
#import "@preview/wrap-it:0.1.1": wrap-content as wrap_content_original

#let small = 10pt
#let normal = 11pt
#let large = 13pt
#let Large = 15pt
#let LARGE = 18pt
#let huge = 25pt

#let in-appendix-part = state("in-appendix-part", false)

#let school = "École Polytechnique Fédérale de Lausanne"

#let cover_day = image("./epfl/rlc-cover1.jpg")
#let cover_night = image("./epfl/rlc-cover2.jpg")

#let epfl-logo-black = image("./epfl/logo-black.png")
#let epfl-logo-white = image("./epfl/logo-white.png")
#let epfl-logo-red = image("./epfl/logo-red.png")

#let base(
  doc-type: "book", // "book" or "article"
  title: none,
  name: none,
  main-font: "Segoe UI",
  math-font: "New Computer Modern Math",
  mono-font: "Consolas",
  accent-color: blue.darken(20%),
  ref-color: blue,
  cite-color: olive,
  language: "en",
  region: "GB",
  body,
) = {
  
  /* --- 1. General Document Setup --- */
  set document(title: title, author: name)
  set text(font: main-font, size: 11pt, lang: language, region: region)
  
  // Modern paragraph spacing
  set par(
    justify: true,
    first-line-indent: 1.8em,
    spacing: 0.8em,
    leading: 0.7em,
  )

  /* --- 2. Page & Header Setup --- */
  set page(
    paper: "a4",
    margin: (x: 25mm, y: 25mm, top: 30mm),
    numbering: "i",
    header: context {
      // Don't show header on title pages or start of chapters
      let curr-page = here().page()
      let is-chapter-page = query(heading.where(level: 1))
        .any(it => it.location().page() == curr-page)
      
      if curr-page > 1 and not is-chapter-page {
        let headings = query(heading.where(level: 1).before(here()))
        if headings.len() > 0 {
          let last = headings.last()
          let num = if last.numbering != none {
            counter(heading).at(last.location()).at(0)
          }
          
          set text(size: 11pt, font: main-font, weight: "bold")
          stack(
            dir: ltr,
            last.body,
            h(1fr),
            // rightheader
            counter(page).display(),
          )
          line(length: 100%, stroke: 1pt)
        }
      }
    }
  )

  /* --- 3. Typography & Code Styling --- */
  show raw: set text(font: mono-font, size: 0.9em, tracking: -0.03em)
  show quote: set text(font: mono-font, style: "italic")
  show regex(" - "): [ #sym.dash ]

  /* --- 4. Heading & Numbering Logic --- */
  let is-book = doc-type == "book"
  let head-num = if is-book { "1.1.1" } else { "1.1" }
  let eq-num = if is-book { (..n) => numbering("(1.1)", counter(heading).get().first(), ..n) } 
               else { (..n) => numbering("(1)", ..n) }

  set heading(numbering: head-num)
  set math.equation(numbering: eq-num, supplement: [Eq.])
  set figure(numbering: head-num)

  // Level 2 & 3 Styling
  show heading.where(level: 2): it => {
    if not is-book { return it }
    set text(size: 1.3em, weight: "bold", font: main-font)
  }
  show heading.where(level: 3): it => {
    if not is-book { return it }
    set text(size: 1.1em, weight: "semibold", font: main-font)
  }
  //     ]
  //   } else { it }
  // }

  // Chapter Logic (Level 1)
  show heading.where(level: 1): it => {
    if not is-book { return it }
    
    // Reset counters for sections on new chapters
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)

    pagebreak(weak: true)
    v(3em)
    
    // Wrap everything in a right-aligned block
    align(right)[
      // 1. The Number (Top)
      #if it.numbering != none {
        set text(size:6em, weight: "bold", font: main-font)
        // We use context to get the current heading number
        context counter(heading).display(it.numbering)
      }

      // 2. The Title (Bottom)
      #block(width: 100%)[
        #set text(size: 2em, weight: "bold")
        #it.body
      ]
    ]
    
    v(3em)
  }

  /* --- 5. References & Citations --- */
  show cite: it => {
    show regex("\d+"): set text(fill: cite-color, weight: "bold", font: main-font)
    it
  }

  show ref: it => {
    let el = it.element
    if el == none { return it }
    
    // Auto-parentheses for equations
    if el.func() == math.equation {
      link(it.target)[#text(fill: ref-color)[(#it.target)]]
    } else {
      // Color the number part of the reference
      let supp = el.supplement
      let num = context numbering(el.numbering, ..el.counter.at(it.target))
      link(it.target)[#supp~#text(fill: ref-color, num)]
    }
  }

/* --- 6. Figures & Tables --- */
  let figure-gap = 1.5em // Adjust this for more/less space around images

  show figure: it => {
    set align(center)
    
    // 1. Logic for figures with NO placement (inline in text)
    if it.placement == none {
      block(width: 100%, inset: (y: figure-gap))[
        #it
      ]
    } 
    // 2. Logic for figures forced to the TOP
    else if it.placement == top {
      // We only want spacing at the BOTTOM to push text away
      block(width: 100%, inset: (bottom: figure-gap))[
        #it
      ]
    } 
    // 3. Logic for figures forced to the BOTTOM
    else if it.placement == bottom {
      // We only want spacing at the TOP to push text away from the figure
      block(width: 100%, inset: (top: figure-gap))[
        #it
      ]
    } 
    else {
      it
    }
  }

  show figure.caption: c => block(inset: (x: 1em))[
    #set text(size: 0.9em, font: main-font)
    #strong[#c.supplement #context c.counter.display(c.numbering)#c.separator]
    #c.body
  ]

  show figure.where(kind: table): set figure.caption(position: top)

  // Table captions on top, others on bottom
  show figure.where(kind: table): set figure.caption(position: top)
  
  show figure: it => {
    set align(center)
    v(1em)
    it
    v(1em)
  }

  /* --- 7. Table of Contents (Outline) --- */
  show outline.entry.where(level: 1): it => {
    // v(1.5em, weak: true)
    strong(it)
  }
  
  // set outline(indent: 2em, fill: repeat([#h(4pt) . #h(4pt)]))

  /* --- 8. Lists --- */
  set list(
    indent: 1em,
    marker: (
      text(fill: accent-color, font: main-font)[•],
      text(fill: accent-color, font: main-font)[‣],
      [--],
    ),
  )

  /* --- 9. Math Equation Formatting --- */
  show math.equation: set text(font: math-font, size: normal)
  show: equate.with(breakable: false, sub-numbering: false)
  set math.equation(supplement: "Eq.")

  body
}

#let appendix(body) = {
  in-appendix-part.update(true)
  set heading(numbering: "A.1", supplement: [Appendix])
  
  counter(heading).update(0)

  // We use context to get the current chapter letter safely
  set math.equation(numbering: n => {
    context {
      let chap = counter(heading).at(here()).first()
      numbering("(A.1)", chap, n)
    }
  })

  set figure(numbering: n => {
    context {
      let chap = counter(heading).at(here()).first()
      numbering("A.1", chap, n)
    }
  })

  body
}

#let wrap-content(
  fixed,
  to-wrap,
  alignment: top + left,
  size: auto,
  ..grid-kwargs,
) = {
  // Modifying the wrap-content function from the wrap-it package for extra styling.
  // Wrap caption to figure width and text align left

  show figure: it => {
    let w = measure(it.body).width

    show figure.caption: cap => box(width: w, [
      #set par(justify: true)
      #set align(left)
      #cap
    ])
    it
  }

  wrap_content_original(fixed, to-wrap, align: alignment, size: size, ..grid-kwargs)
}

#let chem(body) = {
  // Only subscript digits if they follow a letter (element) or a closing parenthesis
  show regex("([a-zA-Z\)])(\d+)"): it => {
    it.text.slice(0, 1) // The letter
    sub(it.text.slice(1)) // The number
  }
  body
}

#let doubleline = table.hline.with(stroke: stroke(thickness: 4pt, paint: tiling(
  size: (30pt, 5pt),
  [#rect(width: auto, height: 3pt, stroke: (y: 1pt + black))],
)))

#let makecoverpage(
  title: "Document Title",
  subtitle: none,
  name: none,
  font-type: "Segoe UI",
  img: cover_night,
  accent-fill: rgb(0, 0, 0, 120), // 120/255 opacity
) = {
  set page(margin: 0pt, numbering: none)
  
  // Background Image
  if img != none {
    place(center + horizon)[
      // We use set image to ensure the background covers the page
      #set image(width: 100%, height: 100%, fit: "cover")
      #img
    ]
  }

  // Sidebar Label (Rotated)
  place(left + horizon, dx: -3.2cm)[
    #rotate(-90deg, origin: center)[
      #text(fill: white, font: font-type, size: 10pt, weight: "bold")[#smallcaps(school)]
    ]
  ]

  // Main Title Box
  place(top, dy: 15%)[
    #block(
      fill: accent-fill,
      width: 100%,
      inset: (x: 50pt, y: 40pt),
      breakable: false
    )[
      #set align(left)
      #stack(
        spacing: 2em,
        text(fill: white, size: 40pt, weight: "bold", font: font-type)[#title],
        if subtitle != none {
          text(fill: white, size: 20pt, weight: "light", font: font-type)[#subtitle]
        },
        // line(length: 10%, stroke: 2pt + white),
        text(fill: white, size: 24pt, weight: "extralight", font: font-type)[#name]
      )
    ]
  ]

  // Logo at bottom
  place(bottom + left, dx: 1cm, dy: -1cm)[
  // This set rule resizes the pre-loaded image variable
  #set image(width: 5cm)
  #epfl-logo-white

      
  ]
}

#let maketitlepage(
  title: "Thesis Title",
  subtitle: none,
  name: "Author Name",
  degree: "Master of Science in Mechanical Engineering",
  school: "École polytechnique fédérale de Lausanne",
  url: none,
  defense-date: datetime.today().display("[day] [month repr:long] [year]"),
  student-number: none,
  project-duration: none,
  supervisor: none,
  thesis-committee: (), // Expected as a list of strings or pairs
  publicity-statement: "An electronic version of this thesis is available at",
  font-type: "Segoe UI",
) = {
  set page(numbering: none, footer: none, margin: 2.5cm)
  set text(font: font-type, lang: "en")

  // 1. Header / Top Section
  align(center)[
    #v(1fr)
    
    // Title Section
    #text(size: 40pt, weight: "extralight", font: font-type)[#title]
    
    #if subtitle != none {
      v(0.5em)
      text(size: 24pt, weight: "light", fill: gray.darken(50%), font: font-type)[#subtitle]
    }
    
    #v(2em)
    #text(size: 12pt)[by]
    #v(1em)
    
    #text(size: 24pt, weight: "extralight", font: font-type)[#name]
    
    #v(2em)
    #text(size: 12pt, font: font-type)[
      to obtain the degree of #degree \
      at the #school \
      to be defended publicly on #defense-date
    ]
    
    // 2. Metadata Section (Student Info & Committee)
    #v(2fr) 

    // This 'align' centers the whole block horizontally
    #align(center)[
      // The 'block' ensures the grid only takes as much space as it needs
      #block(width: auto)[
        #set align(left) // Keep text inside the block left-aligned
        #set text(size: 11pt)
        
        #grid(
          columns: (auto, auto), // Two columns: Labels and Values
          column-gutter: 2.5em,
          row-gutter: 0.8em,
          
          strong("Student number:"), [#student-number],
          strong("Project duration:"), [#project-duration],
          strong("Supervisor:"), [#supervisor],
          
          // Thesis Committee Label
          strong("Thesis committee:"), 
          
          // Committee Members list
          stack(
            spacing: 0.8em,
            ..thesis-committee.map(member => [#member])
          )
        )
      ]
    ]

    #v(1.5fr)
    
    // 3. Footer / URL / Logo
    #if url != none {
      text(size: 9pt, fill: gray.darken(30%), font: font-type)[
        #publicity-statement #link(url)
      ]
    } else {
      text(size: 9pt, fill: gray.darken(30%), font: font-type)[#publicity-statement]
    }
    
    #v(2em)
    
    #set image(width: 5cm)
    #epfl-logo-black
    #v(1em)
  ]
}