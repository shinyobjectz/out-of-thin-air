# business-documents

Business artifacts — invoices, resumes/CVs, shipping labels, QR codes, and barcodes — authored as version-controlled markup + data and compiled into a deliverable: `pdf`, `svg`, or raster `image`. Headless and offline-leaning where possible.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [Typst invoice-maker](./typst-invoice.md) | pdf | Rust/native (typst CLI, brew/cargo); JS/Node (typst wrapper); Rust lib (typst-pdf) | typst-claude-skill | no | ok | yes | yes |
| [RML (ReportLab)](./reportlab.md) | pdf | Python (CPython 3.9-3.14, pip install reportlab) | anthropics/skills — pdf | yes | ok | yes | yes |
| [rendercv](./rendercv.md) | pdf | Python (CPython >=3.12) | rendercv-skill | yes | ok | yes | yes |
| [JSON Resume](./json-resume.md) | pdf | resumed (Node >=18); resume-cli (Node, puppeteer); jsonresume-theme-* | json-resume (none) | no | ok | yes | yes |
| [Segno (QR)](./segno.md) | svg | Python; Shell/CLI | heuer/segno | yes | ok | yes | yes |
| [python-barcode](./python-barcode.md) | svg | Python | none | no | ok | yes | yes |
| [ZPL (Labelary)](./zpl-labelary.md) | image | shell/curl; JS; Rust; Ruby | Labelary ZPL Label API | yes | ok | yes | yes |
| [WeasyPrint](./weasyprint.md) | pdf | Python (CPython >=3.10, pip install weasyprint==69.*) | anthropics/skills — pdf | yes | ok | yes | yes |

## Multi-toolchain notes

- **Markup-source PDF generators split native vs Python.** Typst compiles a `.typ` source through a Rust native binary (CLI via brew/cargo, or the `typst-pdf` lib, or an npm wrapper) — first run fetches the pinned `@preview/invoice-maker:1.1.0` package. WeasyPrint renders HTML+CSS through CPython but depends on native cairo/pango/gdk-pixbuf system libs. ReportLab (RML) is pure CPython, no system libs, the most portable PDF path.
- **Resume tools are YAML/JSON source → derived PDF.** rendercv version-controls a `cv.yaml` (cv + design keys; themes: classic, sb2nov, engineeringresumes, engineeringclasses, moderncv) and is CPython-only. JSON Resume version-controls a schema-validated `resume.json`; rendering is Node — `resumed` (MIT, pure render fn, HTML) is the light path, PDF needs `resume-cli`/puppeteer (bundled Chromium).
- **Code/label encoders emit SVG deterministically.** Segno (pure-Python, zero-dep, BSD-3) and python-barcode (default `SVGWriter`, zero-dep) both produce byte-reproducible SVG when error/mask (Segno) or symbology params are pinned; raster PNG is an optional fallback (Pillow `[images]` extra for python-barcode). ZPL renders via the Labelary HTTP API (`curl`/JS/Ruby clients) or an offline `labelize` Rust renderer; output is a raster `image` (PNG, e.g. 8dpmm 4x6 → 1200x1800) with PDF available via `format`.

## Validation order

Cheapest / most reliable installs first; defer native-lib, network, and browser-dependent ones:

1. **Segno** — single `pip install segno`, zero-dep, fully headless/offline, byte-deterministic. Best smoke baseline.
2. **python-barcode** — single `pip install python-barcode`, zero-dep SVG, headless/offline, deterministic.
3. **ReportLab (RML)** — single `pip install reportlab`, pure CPython, no system libs, headless PDF.
4. **rendercv** — `pip install "rendercv[full]"`, CPython >=3.12, headless; heavier dependency tree than bare ReportLab.
5. **ZPL (Labelary)** — trivial offline `printf` to author `.zpl`; render needs either the Labelary HTTP API (network) or the offline `labelize` Rust binary.
6. **JSON Resume** — `npm i -g resumed` for HTML is light; PDF path pulls puppeteer + Chromium (heavy).
7. **Typst** — native binary install (`brew install typst`); first compile fetches the invoice-maker package over network.
8. **WeasyPrint** — heaviest: needs `brew install cairo pango gdk-pixbuf libffi` system libs before the pip install. Validate last.

## Explorer needs

Most tools run in the default shell. Richer explorers wanted by:

- **JSON Resume** — PDF rendering needs a headless-browser explorer (resume-cli bundles puppeteer/Chromium); the HTML path runs in the default shell.
- **WeasyPrint** — needs a runtime with native cairo/pango/gdk-pixbuf/libffi system libraries present; the bare default shell lacks them.
- **Typst** — needs a native-binary-capable runtime (typst CLI) plus network egress on first compile to fetch the pinned `@preview/invoice-maker` package.
- **ZPL (Labelary)** — needs network egress to `api.labelary.com`, OR an explorer with the offline `labelize` Rust renderer installed to stay headless/offline.

## Tool dossiers

- [typst-invoice.md](./typst-invoice.md)
- [reportlab.md](./reportlab.md)
- [rendercv.md](./rendercv.md)
- [json-resume.md](./json-resume.md)
- [segno.md](./segno.md)
- [python-barcode.md](./python-barcode.md)
- [zpl-labelary.md](./zpl-labelary.md)
- [weasyprint.md](./weasyprint.md)
