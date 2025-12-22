# 🎓 Modern EPFL Thesis (Unofficial Typst Template)

[![Typst Version](https://img.shields.io/badge/Typst-0.12.0+-0074D9.svg)](https://typst.app)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/alifuatsahin/epfl-thesis-template/pulls)

A professional, modern Typst template for theses, reports, and articles. While styled after the **EPFL (École Polytechnique Fédérale de Lausanne)** visual identity, this is an **unofficial** template and is not endorsed by the institution.

[**📂 View Demo PDF**](https://github.com/alifuatsahin/epfl-thesis-template/blob/main/template/main.pdf) | [**🐞 Report a Bug**](https://github.com/alifuatsahin/epfl-thesis-template/issues) | [**✨ Request Feature**](https://github.com/alifuatsahin/epfl-thesis-template/issues)

---

## ✨ Previews
*Click on any image to view the full PDF.*

| Cover Page | Title Page | Main Text (Book) | Main Text (Report) |
| :---: | :---: | :---: | :---: |
| [![Cover](assets/preview-cover.png)](./template/main.pdf) | [![Title](assets/preview-title.png)](./template/main.pdf) | [![Book](assets/preview-book.png)](./template/main.pdf) | [![Report](assets/preview-report.png)](./template/main.pdf) |

---

## 🚀 Quick Start

### 🌐 Using Typst Web App
1. Create a new project on [Typst.app](https://typst.app).
2. Click on **Packages** and search for `modern-epfl-thesis`.
3. Select **Create project from this template**.

### 💻 Using Typst CLI
If the package is not yet on the official `@preview` registry, install it locally:

```bash
# 1. Clone to local packages (macOS/Linux)
git clone https://github.com/alifuatsahin/epfl-thesis-template.git ~/.local/share/typst/packages/preview/modern-epfl-thesis/0.1.0

# 1. Clone to local packages (Windows PowerShell)
git clone https://github.com/alifuatsahin/epfl-thesis-template.git $env:APPDATA\typst\packages\preview\modern-epfl-thesis\0.1.0

# 2. Initialize and Compile
typst init @preview/modern-epfl-thesis:0.1.0 my-thesis
cd my-thesis
typst watch main.typ
```

---

## 🛠 Features

- **🎯 Dual Modes:** Toggle between `doc-type: "book"` (chapters) and `doc-type: "report"` (continuous sections).
- **🧪 Science-Ready:**
    - `chem("H2O")`: Powered by `mhchem` logic for chemical formulas.
    - `wrap-content()`: Advanced figure wrapping where captions match image widths automatically.
- **🎨 EPFL Identity:** Official Swiss Red (`#FF0000`) accents and "Suisse Int'l" font integration.
- **📚 Modular Structure:** Pre-organized folders for sections, bibtex, and appendices.
- **🔢 Smart Numbering:** Handles complex appendix numbering (e.g., A.1, B.2) out of the box.

---

## 📖 Usage Guide

```typst
#import "@preview/modern-epfl-thesis:0.1.0": *

#show: base.with(
  doc-type: "book",         // "book" or "report"
  title: "Neural Network Optimization in Cryo-EM",
  author: "Claude Shannon", 
  supervisor: "Prof. Jane Doe",
  date: "December 2023",
)

// High-impact cover page
#makecoverpage(
  title: "Neural Network Optimization", 
  name: "Claude Shannon", 
  img: image("src/epfl/rlc-cover2.jpg")
)

#maketitlepage()

// Example of advanced figure wrapping
#wrap-content(
  image("assets/data.png", width: 60%),
  [This caption will automatically wrap at the 60% width of the image.],
  [Your paragraph text continues here, flowing beautifully around the figure...]
)
```

### Layout Comparison
| Parameter | `doc-type: "book"` | `doc-type: "report"` |
| :--- | :--- | :--- |
| **Hierarchy** | Uses `=` for Chapters | Uses `=` for Sections |
| **Page Breaks** | New chapter starts on new page | Continuous flow |
| **Ideal For** | Master/PhD Thesis | Semester Projects / Lab Reports |

---

## 📂 Project Structure

```text
.
├── typst.toml          # Package metadata
├── src/                # Internal Logic & Assets
│   ├── lib.typ         # API Entrypoint
│   └── epfl/           # Official Logos (.svg)
├── template/           # Your Workspace
│   ├── main.typ        # Main file to compile
│   ├── references.bib  # Bibliography
│   └── sections/       # Chapter files (Introduction.typ, etc.)
└── README.md
```

---

## ⚠️ Disclaimer & Fonts

*   **Disclaimer:** This project is **not** officially affiliated with EPFL. 
*   **Fonts:** For the official look, install **Suisse Int'l**. If not found, the template will fallback to **Segoe UI** (Windows) or **Inter/Linux Libertine**.

## 📄 License

Based on [EPFL-Report-Template](https://github.com/batuhanfaik/EPFL-Report-Template).
Licensed under the **MIT License**.
