#import "@preview/modern-epfl-thesis:0.1.0": *
#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": num, numrange, qty, qtyrange
#import "@preview/zero:0.5.0"


#let main-font = "Segoe UI" // or any other font you prefer (e.g., "Suisse Int'l" if you want to get the template look.) (Default: "Segoe UI")
#let math-font = "New Computer Modern Math" // or any other math font you prefer (default: "New Computer Modern Math")
#let mono-font = "Consolas" // or any other font you prefer (e.g., "Suisse Int'l Mono" if you want to get the template look.) (Default: "Consolas")
#let doc-type = "book" // report, book

#let thesis-title = "The Title of the Thesis" // Your Thesis Title Here
#let thesis-subtitle = "The Lab Name / Subtitle Goes Here" // Your Lab or Department Here or Subtitle Here
#let author-name = "Author Name" // Your Full Name Here
#let background-img = image("./img/rlc-cover1.jpg") // use image("path/to/your/image.jpg")
#let portfolio-url = "https://your-portfolio-link.com" // Your Portfolio or Personal Website URL Here
#let student-number = "123456" // Your Student Number Here
#let project-duration = "Feb 2025 - June 2025" // Your Project Duration Here
#let degree = "Master of Science in Mechanical Engineering" // Your Degree Here
#let defense-date = datetime(day: 30, month: 6, year: 2025) // Your Defense Date Here

#let supervisor-name = "Prof. Dr. Bugra Koku" // Your Supervisor's Name Here
#let thesis-committee-names = (
  [Prof. Dr. Eres Soylemez],
  [Prof. Dr. Turgut Tumer],
  [Prof. Dr. Kemal Ozgoren]
) // Your Thesis Committee Members Here

// 1. Create the Cover Page
#makecoverpage(
  title: thesis-title,
  subtitle: thesis-subtitle,
  name: author-name,
  img: background-img,
  font-type: main-font
)

// 2. Setup the Document Base logic
#show: base.with(
  doc-type: doc-type,
  title: thesis-title,
  name: author-name,
  main-font: main-font,
  math-font: math-font,
  mono-font: mono-font,
)

// 3. Title Page (Interior)
#maketitlepage(
  title: thesis-title,
  subtitle: thesis-subtitle,
  name: author-name,
  url: portfolio-url,
  student-number: student-number,
  project-duration: project-duration,
  supervisor: supervisor-name,
  thesis-committee: thesis-committee-names,
  font-type: main-font,
  defense-date: defense-date,
  degree: degree,
)

#show: frontmatter

#outline(indent: auto)
// #outline(title: "List of Figures", target: figure.where(kind: image))
// #outline(title: "List of Tables", target: figure.where(kind: table))

#show: mainmatter

// 4. Content
#include "./sections/0-default.typ" // Comment out this line when you start writing
#include "./sections/1-introduction.typ"
#include "./sections/2-theory.typ"
#include "./sections/3-methodology.typ"
#include "./sections/4-results.typ"
#include "./sections/5-conclusion.typ"

#bibliography(
  "references.bib",
  title: [References],
  style: "ieee",
)

#show: appendix

#include "sections/6-appendix.typ"