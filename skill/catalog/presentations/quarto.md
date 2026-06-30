<!-- generated draft — needs validation -->
# quarto — presentations

## Summary
Quarto is an open-source scientific/technical publishing system from Posit (Deno-based CLI bundling Pandoc). For the **presentations** category its primary output is a **reveal.js HTML slide deck** rendered from a Markdown `.qmd` file. Syntax-highlighted code, incremental reveals, speaker notes, transitions, and live executable code (Python/R/Julia/Observable) are first-class. Secondary exports: PDF (via Decktape/Chromium) and PowerPoint `.pptx`. No official Anthropic skill exists, but Quarto publishes official `llms.txt` AI docs and a highly structured docs site.

## Skills
| Name | Type | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| Quarto reveal.js presentations guide | official-docs | https://quarto.org/docs/presentations/revealjs/ | yes | Quarto docs / CC site content; tool MIT/GPL-2.0 | Posit, PBC (quarto-dev) |
| Quarto revealjs format reference (all options) | official-docs | https://quarto.org/docs/reference/formats/presentations/revealjs.html | yes | Quarto docs | Posit, PBC |
| Quarto llms.txt AI-friendly docs | llms.txt | https://quarto.org/llms.txt | yes | site content | Posit, PBC (confirm exact path; generated when a site sets `format: html: llms-text: true`) |
| llmstxt-to-skills (convert llms.txt → SKILL.md) | community | https://github.com/JoshJarabek7/llmstxt-to-skills | no | see repo | JoshJarabek7 |

## Toolchains
| lang | install | invoke |
|---|---|---|
| native CLI (bundled Deno + Pandoc) | `brew install quarto` (or installer from quarto.org/docs/get-started) | `quarto render slides.qmd --to revealjs` ; `quarto preview slides.qmd` (live reload) ; `quarto render slides.qmd --to pdf` |
| Python | `pip install quarto-cli` (PyPI wrapper downloads binary); `pip install jupyter` for embedded Python | `quarto render slides.qmd --to revealjs` or `python -m quarto render slides.qmd` |
| R | `install.packages("quarto")` (also needs Quarto CLI on PATH) | `quarto::quarto_render("slides.qmd")` (knitr engine runs R chunks) |
| Julia | install Quarto CLI; add `jupyter` or QuartoNotebookRunner | `quarto render slides.qmd` (Julia cells via Jupyter/native engine) |
| JS/TS (Node) | download Quarto CLI binary (no official npm wrapper) | invoke `quarto` via child_process; Observable JS cells run natively, no Node needed |

## Artifact kind
**html** — a self-navigable reveal.js deck (`deck.html` + `deck_files/` asset dir). Use `--embed-resources` for a single portable self-contained `.html` (no `_files` dir), ideal for the universal shell iframe. Interactive: arrow-key nav, fragments, speaker-notes overlay (`s`).

## Validation
- **install**: `brew install quarto`  (macOS; or `pip install quarto-cli`)
- **smoke**:
  ```bash
  printf -- '---\ntitle: Demo\nformat: revealjs\n---\n\n## Slide 1\n\n- hello\n\n## Slide 2\n' > deck.qmd && quarto render deck.qmd --to revealjs
  ```
- **expect**: produces `deck.html` (self-navigable reveal.js deck) plus a `deck_files/` asset dir in cwd. Open in browser; arrow keys advance slides. Headless on macOS; no embedded code execution unless a code engine is used (a `python` block requires `jupyter` installed — use a code-free deck for the smoke test).

## Wrapper params
- `format` — revealjs | pptx | pdf (`--to`)
- `--output` / `--output-dir`
- `--embed-resources` — self-contained single-file `.html`
- `theme` — built-in revealjs themes or custom SCSS
- front-matter: `incremental`, `slide-number`, `code-line-numbers`, `highlight-style`, `transition`, `footer`/`logo`, `smaller`, `scrollable`
- PDF export of revealjs deck uses Decktape/Chromium path

## Component / explorer notes
Primary deliverable is a self-contained reveal.js HTML deck — the default HTML artifact shell renders it directly in an iframe (interactive JS: keyboard nav, fragments, speaker-notes overlay `s`). Use `--embed-resources` to produce a single portable `.html` with no `_files` dir, ideal for the shell. A richer explorer is not required; PDF/pptx are secondary exports.
