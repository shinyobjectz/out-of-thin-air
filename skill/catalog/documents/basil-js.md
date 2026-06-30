# basil.js (InDesign)

slug: `basil-js` · category: `documents` · artifact kind: `pdf` · OOTA confidence: **LOW**

## Summary

basil.js is an MIT-licensed JavaScript library that ports the spirit of Processing/p5.js to Adobe InDesign, letting designers script generative and data-driven layouts inside InDesign and export them (primarily to PDF). It is a creative-coding wrapper over InDesign's ExtendScript DOM.

**Primary OOTA concern:** basil.js cannot run standalone. It requires a licensed, installed copy of Adobe InDesign (a proprietary GUI desktop app, macOS/Windows only). There is no open-source, CI-friendly headless renderer. "Headless" is only the InDesign app launched with `-noui -run script.jsx` — still the full licensed app, and poorly documented for basil.js. The SCRIPT (plain `.jsx`/`.js` text) is deterministic and version-controllable; the RENDER step depends on a non-free, non-headless binary — a poor fit for OOTA's deterministic headless-render model.

The tool itself is real, maintained-ish (last tagged release 1.0.10, 2016; active `develop` branch with "b-less" syntax), and well-attested.

## Skills / docs

| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| basil.js official site / tutorials | docs | https://basiljs.ch | official | MIT | basil.js team (basiljs.ch) |
| basil.js dev docs (b-less syntax) | docs | https://basiljs2.netlify.app/ | official | MIT | basil.js team |
| basiljs/basil.js (source + wiki + examples) | repo | https://github.com/basiljs/basil.js | official | MIT | basiljs org |
| vladysolonyi/indesign-scripts (community BasilJS scripts) | repo | https://github.com/vladysolonyi/indesign-scripts | community | see repo | vladysolonyi |

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript (Adobe ExtendScript / ES3-era), runtime = Adobe InDesign CS5+ (proprietary, not free, not truly headless) | Install licensed Adobe InDesign. Download basil.js from https://github.com/basiljs/basil.js (or basiljs2.netlify.app/download). Place `basil.js` + your script into InDesign's Scripts Panel folder: `~/Library/Preferences/Adobe InDesign/<ver>/<locale>/Scripts/Scripts Panel/` (macOS). | Interactive: double-click the script in InDesign's Scripts panel, or run via Adobe ExtendScript Toolkit / VS Code ExtendScript Debugger targeting InDesign. Batch/"headless": `"/Applications/Adobe InDesign 2025/Adobe InDesign 2025.app/Contents/MacOS/Adobe InDesign 2025" -noui -run /path/to/script.jsx` — still the full licensed GUI app; no daemon/server mode. |

Note: a `package.json` exists in the repo but is for dev tooling, NOT an npm-runnable renderer. There is no node/CLI path that renders without InDesign.

## Artifact kind

**pdf** — print/editorial layout is the canonical output. InDesign can also export images (PNG/JPG) and EPUB/HTML, but PDF is the canonical print-design deliverable.

## Validation

- **install:** Requires a licensed Adobe InDesign install on macOS (no free/headless substitute). Copy `basil.js` and a `script.jsx` into InDesign's "Scripts Panel" folder.
- **smoke:** A `script.jsx` using basil.js that creates a doc, draws a rect/text, then exports PDF: `var f = new File('~/Desktop/basil-smoke.pdf'); app.activeDocument.exportFile(ExportFormat.PDF_TYPE, f);`. Run via Scripts panel, or `"/Applications/Adobe InDesign 2025/Adobe InDesign 2025.app/Contents/MacOS/Adobe InDesign 2025" -noui -run /path/to/script.jsx`.
- **expect:** `basil-smoke.pdf` written to `~/Desktop`. NOTE: cannot be validated in a standard headless CI/sandbox without an interactive, licensed InDesign — unverifiable in OOTA's headless-macOS target.

## Wrapper params

- `documents.title` (text) — document title used in the generated layout.

## Component / explorer notes

Deliverable is a PDF (print/editorial layout). The basil.js script (`.jsx`/`.js`) is plain text and fully version-controllable; only the render is non-deterministic-environment-bound. NOT recommended as an OOTA generator without caveats: the render path hard-requires a proprietary, GUI, license-gated Adobe InDesign with no genuine headless/server mode (`-noui -run` still boots the full app and cannot run in a clean CI container or sandbox). For deterministic, headless code-to-PDF in OOTA, prefer Typst/LaTeX/Paged.js/WeasyPrint. Consider basil.js only when targeting genuine InDesign-native print workflows on a provisioned design workstation.
