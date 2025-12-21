# Unofficial EPFL Typst Academic Template

A professional, modern Typst template for theses, reports, and articles. While styled after the **EPFL (École Polytechnique Fédérale de Lausanne)** visual identity, this is an **unofficial** template and is not endorsed by the institution.

## ⚠️ Disclaimer & License
* **Disclaimer:** This template is **not** officially associated with EPFL.
* **License:** Licensed under the **MIT License**.
* **Fonts:** All required fonts (Suisse Int'l, Suisse Int'l Mono, etc.) are provided in the `src/epfl` directory.

---

## Installation (Local Package)

To use this template as a library across multiple projects, install it as a local package:

1. **Locate your local package directory:**
   - **macOS:** `~/Library/Application Support/typst/packages/local/`
   - **Windows:** `%APPDATA%\typst\packages\local\`
   - **Linux:** `~/.local/share/typst/packages/local/`

2. **Create the versioned folder:**
   Create a folder named `epfl-thesis/0.1.0/` inside the `local` directory.

3. **Copy files:**
   Place the `src/` folder, `template/` folder, and `typst.toml` into that directory.

4. **Initialize a project:**
   You can now start a new project instantly using:
   ```bash
   typst init @local/epfl-thesis:0.1.0 my-thesis
   ```

---

## Project Structure

```text
.
├── typst.toml          # Package metadata
├── src/                # Library logic
│   ├── lib.typ         # Main library entrypoint
│   ├── template.typ    # Layout definitions
│   └── epfl/           # Assets (Logos & Fonts)
├── template/           # Boilerplate for users
│   ├── main.typ        # Main document entrypoint
│   └── sections/       # Example content (Introduction, etc.)
└── README.md
```

---

## Usage

If you use `typst init`, it will generate a `main.typ` for you. To use the library functions manually:

```typst
#import "@local/epfl-thesis:0.1.0": *

#show: base.with(
  doc-type: "book",
  title: "My Research",
  name: "Your Name",
)

// Helpers provided by the template
#makecoverpage(
  title: "A Study in Typst", 
  name: "Ali Fuat Sahin", 
  img: "src/epfl/rlc-cover2.jpg"
)

#maketitlepage(
  title: "A Study in Typst",
  name: "Ali Fuat Sahin",
  supervisor: "Prof. Jane Doe"
)

= Introduction
Refer to the `template/sections/` folder for a modular way to organize your thesis.
```

---

## Features

- **Dual Modes:** Use `doc-type: "book"` for chapters/theses or `doc-type: "article"` for reports.
- **Scientific Utilities:**
    - `chem()`: Automatic chemical formula formatting (e.g., `chem[H2O]`).
    - `wrap-content()`: Advanced image wrapping where captions automatically match the figure width.
- **EPFL Branding:** Pre-configured cover pages, title pages, and institutional colors.
- **Appendices:** A dedicated `#appendix()` environment that resets counters and handles "A.1" numbering.

## Fonts & Logos

This template includes the "Suisse Int'l" font family (EPFL's branding font) and various versions of the EPFL logo (black, white, red) located in `src/epfl/`. 

If you have the fonts and want to use these fonts locally with the Typst CLI:
```bash
typst compile main.typ --font-path ./src/epfl
```

## License 

This work is based on [EPFL-Report-Template](https://github.com/Vector04/tudelft-thesis-template/tree/master) and [tudelft-thesis-template](https://github.com/batuhanfaik/EPFL-Report-Template) and licensed under MIT license.
