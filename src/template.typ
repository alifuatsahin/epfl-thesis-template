#import "@preview/equate:0.3.2": equate
#import "@preview/wrap-it:0.1.1": wrap-content as wrap_content_original

#let small = 10pt
#let normal = 11pt
#let large = 13pt
#let Large = 15pt
#let LARGE = 18pt
#let huge = 25pt

#let in-appendix-part = state("in-appendix-part", false)
#let is-main-matter = state("is-main-matter", false)

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
  ref-color: rgb("#010101"), // rgb("#0061A6"),
  cite-color: rgb("#007070"),
  language: "en",
  region: "GB",
  body,
) = {
  let is-book = doc-type == "book"

  show <nonumber>: set heading(numbering: none)
  
  /* --- 1. General Document Setup --- */
  set document(title: title, author: name)
  set text(font: main-font, size: 11pt, lang: language, region: region)

  /* --- 1. Paragraph & Typography Setup --- */
  set par(
    justify: true,
    linebreaks: "optimized",
    
    first-line-indent: 1.8em, 
    spacing: 0.8em,          
    
    leading: 0.65em,
  )

  set text(costs: (orphan: 100%, widow: 100%))

  /* --- 2. Page & Header Setup --- */
  set page(
    paper: "a4",
    margin: (x: 25mm, y: 25mm, top: 30mm),
    numbering: "i",

    // HEADER: Only show in Main Matter (Arabic numerals + Chapter name)
    header: context {
      let main = is-main-matter.at(here())
      let curr-page = here().page()

      let headings-on-page = query(heading.where(level: 1))
        .filter(it => it.location().page() == curr-page)
      
      let is-chapter-page = headings-on-page.len() > 0

      let target-heading = if is-chapter-page {
        headings-on-page.first()
      } else {
        query(heading.where(level: 1).before(here())).at(-1, default: none)
      }
      
      // Only show header if we are in main matter AND not on a chapter start page
      if main and curr-page > 1 and (not is-chapter-page or not is-book) {
        if target-heading != none {
          set text(size: 11pt, font: main-font, weight: "bold")
          stack(
            dir: ltr,
            target-heading.body,
            h(1fr),
            counter(page).display(),
          )
          v(-0.5em)
          line(length: 100%, stroke: 0.5pt)
        }
      }
    }
  )

  /* --- 3. Typography & Code Styling --- */
  show raw: set text(font: mono-font, size: 0.9em, tracking: -0.03em)
  show quote: set text(font: mono-font, style: "italic")
  show regex(" - "): [ #sym.dash ]

  /* --- 4. Heading & Numbering Logic --- */
  let head-num = if is-book { "1.1.1" } else { "1.1" }
  let eq-num = if is-book { (..n) => numbering("(1.1)", counter(heading).get().first(), ..n) } 
               else { (..n) => numbering("(1)", ..n) }

  set heading(numbering: head-num)
  set math.equation(numbering: eq-num, supplement: [Eq.])
  set figure(numbering: head-num)

  // Level 2 & 3 Styling
  show heading.where(level: 2): it => {
    if not is-book { return it }
    set text(size: 1.3em, weight: "bold", font: main-font, hyphenate: false)
    it
  }
  show heading.where(level: 3): it => {
    if not is-book { return it }
    set text(size: 1.1em, weight: "semibold", font: main-font, hyphenate: false)
    it
  }

  // Chapter Logic (Level 1)
  show heading.where(level: 1): it => {
    context {
      let main = is-main-matter.get()
      
      if is-book or not main {
        // Reset counters for sections on new chapters
        counter(math.equation).update(0)
        counter(figure.where(kind: image)).update(0)
        counter(figure.where(kind: table)).update(0)

        pagebreak(weak: true)
        v(3em)
        
        align(right)[
          #if it.numbering != none {
            set text(size: 6em, weight: "bold", font: main-font, hyphenate: false)
            counter(heading).display(it.numbering)
          }

          #block(width: 100%)[
            #set par(justify: false)
            #set text(size: 2em, weight: "bold", font: main-font, hyphenate: false)
            #it.body
          ]
        ]
        v(3em)
      } else {
        v(1.5em, weak: true)
        it
        v(1em, weak: true)
      }
    }
  }

  /* --- 5. References & Citations --- */
  show cite: it => {
    show regex("\d+"): set text(fill: cite-color, weight: "bold", font: main-font)
    it
  }

  show ref: it => {
    if it.supplement == none {
      return text(fill: ref-color, it, font: main-font)
    }

    let el = it.element
    if el == none { return it }

    context {
      let supp = if it.supplement != auto {
        it.supplement // User provided custom supplement: @label[Supp]
      } else if it.form == "page" {
        [page]       // Match Version 1: Force "page" for page refs
      } else if el.has("supplement") {
        el.supplement // Use default: "Figure", "Table", etc.
      } else {
        ""
      }

      link(el.location())[#if supp not in ("", []) [#supp~]#ref(it.target, supplement: none, form: it.form)]
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

  /* --- 7. Table of Contents (Outline) --- */
  show outline.entry.where(level: 1): it => {
    v(1.5em, weak: true)
    
    // Check if the entry is pointing to a heading.
    // Figures and Tables will have a different 'func' (element type).
    if it.element.func() == heading {
      strong(it)
    } else {
      // This will apply to Figures and Tables in their outlines
      it
    }
  }
  
  set outline(indent: 2em)

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
  set math.equation(supplement: "Eq.")
  show math.equation: set text(font: math-font, size: normal)
  show: equate.with(breakable: false, sub-numbering: false)

  // the "Grouped Reference" handler
  show math.equation.where(block: true): it => {
    let label-str = if it.has("label") { str(it.label) } else { "" }
    
    if label-str.starts-with("eqgrp:") {
      grid(
        columns: (1fr, auto, 1fr),
        column-gutter: 0pt,
        align: horizon,
        [],             // Left spacer
        
        math.equation(it.body, block: true, numbering: none), 
        
        // The number on the right
        align(right, context {
          let num = counter(math.equation).display(it.numbering)
          [#num]
        })
      )
    } else {
      it
    }
  }

  body
}

#let appendix(body) = {
  in-appendix-part.update(true)
  set heading(numbering: "A.1", supplement: [Appendix])
  
  counter(heading).update(0)

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
  school: school,
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
      #set par(justify: false)
      #stack(
        spacing: 2em,
        text(fill: white, size: 40pt, weight: "bold", font: font-type, hyphenate: false)[#title],
        if subtitle != none {
          text(fill: white, size: 20pt, weight: "light", font: font-type, hyphenate: false)[#subtitle]
        },
        // line(length: 10%, stroke: 2pt + white),
        text(fill: white, size: 24pt, weight: "extralight", font: font-type, hyphenate: false)[#name]
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
  supervisors: (), // Expected as a list of strings or pairs
  thesis-committee: (), // Expected as a list of strings or pairs
  publicity-statement: "An electronic version of this thesis is available at",
  defense-statement: "to be defended publicly on",
  thesis-type: none,
  font-type: "Segoe UI",
) = {
  set page(numbering: none, footer: none, margin: 2.5cm)
  set text(font: font-type, lang: "en")
  let supervisors = if type(supervisors) == array { supervisors } else { (supervisors,) }
  let thesis-committee = if type(thesis-committee) == array { thesis-committee } else { (thesis-committee,) }

  // 1. Header / Top Section
  align(center)[
    #v(1fr)
    
    // Title Section
    #block(width: 100%)[
      #set par(justify: false)
      #text(
        size: 40pt, 
        weight: "extralight", 
        font: font-type, 
        hyphenate: false // Prevents breaking words in two
      )[#title]
    ]
    
    #if subtitle != none {
      v(2em)
      block(width: 100%)[
        #set par(justify: false) // Prevents the gaps between words
        #text(
          size: 24pt, 
          weight: "light", 
          fill: gray.darken(50%), 
          font: font-type,
          hyphenate: false
        )[#subtitle]
      ]
    }
    
    #v(2em)
    #text(size: 12pt)[by]
    #v(1em)
    
    #text(size: 24pt, weight: "extralight", font: font-type)[#name]
    
    #v(2em)
    #text(size: 12pt, font: font-type)[
      #if thesis-type != none {
        strong(thesis-type)
        [\ ]
      }
      #if degree != none [
        to obtain the degree of #degree \
      ]
      at the #school \
      #defense-statement #defense-date
    ]
    
    // Metadata Section (Student Info & Committee)
    #v(2fr) 

    #align(center)[
      #block(width: auto)[
        #set align(left) // Keep text inside the block left-aligned
        #set text(size: 11pt)
        
        #grid(
          columns: (auto, auto), // Two columns: Labels and Values
          column-gutter: 2.5em,
          row-gutter: 0.8em,
          
          ..if student-number != none {
            (
            strong("Student number:"), 
            [#student-number],
            )
          },

          ..if project-duration != none {
            (
            strong("Project duration:"), 
            [#project-duration],
            )
          },

          // Conditional spreading for Supervisors
          ..if supervisors.len() > 1 {
            (
              strong("Supervisors:"), 
              stack(spacing: 0.8em, ..supervisors.map(member => [#member]))
            )
          }
          else if supervisors.len() == 1 {
            (
              strong("Supervisor:"), 
              [#supervisors.first()]
            )
          },
          
          // Conditional spreading for Committee
          ..if thesis-committee.len() > 0 {
            (
              strong("Thesis committee:"),
              stack(spacing: 0.8em, ..thesis-committee.map(member => [#member]))
            )
          }
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

#let mainmatter(body) = {
  is-main-matter.update(true)
  show heading.where(level: 2): set heading(outlined: true)
  show heading.where(level: 3): set heading(outlined: true)
  pagebreak(weak: true)
  counter(page).update(1)
  set page(numbering: "1", footer: none)
  body
}

#let frontmatter(body) = {
  is-main-matter.update(false)
  show heading.where(level: 2): set heading(outlined: false)
  show heading.where(level: 3): set heading(outlined: false)
  pagebreak(weak: true)
  counter(page).update(1)
  set page(numbering: "i")
  body
}