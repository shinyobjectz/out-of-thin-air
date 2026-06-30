<!-- generated draft — needs validation -->
# latex (documents)

## Summary
LaTeX is the dominant oota document typesetting system: you write `.tex` markup and a TeX engine (pdfTeX/XeTeX/LuaTeX, or the self-contained Rust engine Tectonic) compiles it to PDF. Primary deliverable is **PDF** — academic papers, theses, legal docs, books, beamer slides. Drivable from a native CLI plus wrappers in Python, JS/TS, Go, Rust, and via the build tool `latexmk`. Easiest headless path on macOS is **Tectonic** (single binary, auto-fetches packages, no full TeX Live install).

## Skills (attributed references)
| Skill | Type | Official | License | Notes |
|---|---|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | anthropic-skill | yes (Anthropic) | see repo | General Agent Skills repo; no dedicated standalone LaTeX skill. |
| [hameefy/claude-latex-skill](https://github.com/hameefy/claude-latex-skill) | repo | no (hameefy) | check repo | SKILL.md for compilable LaTeX in computational/applied math: theorems, proofs, algorithms, beamer. |
| [ndpvt-web/latex-document-skill](https://github.com/ndpvt-web/latex-document-skill) | repo | no (ndpvt-web) | check repo | Universal LaTeX skill: 27 templates/scripts, 26 reference guides (resume, thesis, papers, slides). |
| [flonat/claude-research (LaTeX skill)](https://github.com/flonat/claude-research/blob/main/docs/skills.md) | repo | no (flonat) | check repo | Standardizes LaTeX compile/project mgmt; enforces `out/` build dir via `.latexmkrc`. |

## Toolchains
| lang | install | invoke |
|---|---|---|
| native CLI (TeX engine) | `brew install --cask mactex-no-gui` (or `brew install texlive`) | `pdflatex doc.tex` (or `xelatex`/`lualatex`); run twice for refs/TOC |
| native CLI (modern, Rust) | `brew install tectonic` | `tectonic doc.tex` → `doc.pdf` (auto-fetches packages; best headless/CI) |
| CLI build tool | included in TeX Live / `brew install --cask mactex` | `latexmk -pdf doc.tex` (or `-xelatex`/`-pdflua`); auto-reruns until refs resolve |
| Python | `pip install pylatex` (+ a TeX engine) | `doc.generate_pdf('out', clean_tex=False, compiler='tectonic')` |
| JS/TS | `npm install node-latex` (+ a TeX engine) | stream `.tex` through local latex binary to PDF stream; WASM alt: latex.js / texlive.js |
| Go | shell out via `os/exec` | `exec.Command("tectonic", "doc.tex")` (no mature native engine) |
| Rust | `cargo add tectonic` | `tectonic::latex_to_pdf(src) -> Vec<u8>` (library API) + CLI |

## Artifact kind
**pdf** — single-document PDF output, rendered by the universal shell's embedded PDF viewer.

## Validation
- **install**: `brew install tectonic`
- **smoke**: `printf '\\documentclass{article}\\begin{document}Hello LaTeX\\end{document}' > /tmp/hello.tex && tectonic /tmp/hello.tex && ls -la /tmp/hello.pdf`
- **expect**: Tectonic fetches packages on first run, prints a few log lines, exits 0, and writes `/tmp/hello.pdf` (a one-page PDF). Fully headless on macOS, no GUI/TeX Live needed.

## Wrapper params
- `engine` — tectonic | pdflatex | xelatex | lualatex (tectonic = default for headless reproducibility)
- document class + options
- output path
- number of passes (or rely on latexmk/tectonic auto-iteration)
- bibliography backend — biber | bibtex
- synctex toggle
- Inputs: a `.tex` source string/file. Output: a `.pdf` byte stream.

## Component / explorer notes
Primary output is PDF, which the default artifact shell renders with a standard embedded PDF viewer (`<embed>`/pdf.js). No richer explorer needed for single-doc output; a multi-page/page-thumbnail PDF viewer is a nice-to-have for long documents.
