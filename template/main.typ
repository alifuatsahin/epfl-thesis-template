#import "@preview/epfl-thesis:0.1.0": *
#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": num, numrange, qty, qtyrange
#import "@preview/zero:0.5.0"


// 1. Create the Cover Page
#makecoverpage(
  title: "Title of The Thesis",
  subtitle: "The Lab Name / Subtitle Goes Here",
  name: "Author Name",
  img: image("./img/rlc-cover1.jpg"), // 'cover_day' or 'cover_night' for EPFL campus images otherwise use image("path/to/your/image.jpg")
  font-type: "Segoe UI" // or any other font you prefer (e.g., "Suisse Int'l" if you want to get the template look.
)

// 2. Setup the Document Base logic
#show: base.with(
  doc-type: "book", // report, book
  title: "Title of The Thesis",
  name: "Author Name",
  main-font: "Segoe UI", // or any other font you prefer (e.g., "Suisse Int'l" if you want to get the template look.)
  math-font: "New Computer Modern Math", // or any other math font you prefer
  mono-font: "Consolas", // or any other mono font you prefer (e.g., "Suisse Int'l Mono" if you want the template look.)
)

// 3. Title Page (Interior)
#maketitlepage(
  title: "Title of The Thesis",
  subtitle: "Catchy Subtitle or Lab Here",
  name: "Author Name",
  url: "https://your-portfolio-link.com",
  student-number: "123456",
  project-duration: "Feb 2024 - June 2024",
  supervisor: "Prof. Dr. Bugra Koku",
  thesis-committee: (
    [Prof. Dr. Eres Soylemez],
    [Prof. Dr. Turgut Tumer],
    [Prof. Dr. Kemal Ozgoren]
  ),
  font-type: "Segoe UI" // or any other font you prefer (e.g., "Suisse Int'l" if you want to get the template look.
)

#set page(numbering: "i")
#context counter(page).update(1)

#outline()

#set page(numbering: none)
#context counter(page).update(1)

// 4. Content
#include "./sections/0-default.typ" // Comment out this line when you start writing
#include "./sections/1-introduction.typ"
#include "./sections/2-theory.typ"
#include "./sections/3-methodology.typ"
#include "./sections/4-results.typ"
#include "./sections/5-conclusion.typ"