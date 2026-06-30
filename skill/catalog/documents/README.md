# documents

Typesetting/publishing tools — academic, legal, and long-form documents compiled to PDF (and SVG/PNG where supported).

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [typst](./typst.md) | pdf | native CLI, Python, JS/Node, JS/WASM, React, Rust, R | [claude-skill-typst](https://github.com/) | no | ok | yes | pre-existing (untouched) |
| [latex](./latex.md) | pdf | tectonic (CLI), pdflatex/xelatex/lualatex, latexmk, Python (pylatex), JS/TS (node-latex), Rust (tectonic crate), Go (os/exec) | [ndpvt-web/latex-document-skill](https://github.com/) | no | ok | yes | yes |
| [context](./context.md) | pdf | native CLI LMTX (LuaMetaTeX), TeX Live (mactex), Lua-embedded | [ConTeXt Garden Wiki](https://wiki.contextgarden.net/Main_Page) | yes | ok | yes | yes |

## Multi-toolchain notes

- **typst** — richest binding surface: native CLI, **Python** (`typst.compile()`), **JS/Node** (`@myriaddreamin/typst-ts-node-compiler`), **JS/WASM** (`typst.ts`), **React** (`typst.react`), **Rust** (`typst`+`typst-pdf`), **R** (`typr`).
- **latex** — broad shell-out + binding coverage: **Python** (pylatex), **JS/TS** (node-latex), **Rust** (tectonic crate), **Go** (os/exec). Default engine is Tectonic (auto-fetches packages, headless).
- **context** — narrowest: native CLI only (LMTX / TeX Live), with Lua embedded inside LMTX via `\startluacode`. No Py/Go/JS-TS/React bindings.

## VALIDATION ORDER

Cheapest/most-reliable installs first:

1. **typst** — single static binary via `brew install typst`, no network at compile time, instant smoke (`typst compile hello.typ`). Most reliable.
2. **latex** — `brew install tectonic`; first run fetches packages over network but is otherwise headless and deterministic.
3. **context** — heaviest: LMTX zip download + `install.sh` + `source tex/setuptex` (or full mactex cask). Validate last.

## EXPLORER NEEDS

None. All three tools emit PDF (typst also SVG/PNG) — the default artifact shell (PDF/page viewer) is sufficient. No richer explorer (3D orbit, playable canvas, etc.) required for this category.

## Dossiers

- [typst](./typst.md)
- [latex](./latex.md)
- [context](./context.md)
