<!-- generated draft — needs validation -->
# reveal.js (presentations)

## Summary
reveal.js is an open-source HTML presentation framework (hakimel/reveal.js, MIT). A deck is an `index.html` of nested `<section>` slides; it renders as a self-contained, navigable HTML web app with syntax-highlighted code (highlight.js plugin), speaker notes (S key opens a second window), fragments, transitions, and themes. Primary deliverable is **HTML**; PDF is a first-class secondary export (built-in `?print-pdf` mode + browser print, or headless via DeckTape/Puppeteer). Authoring paths range from raw HTML to Markdown (reveal-md, MkSlides) to literate docs (Quarto, Pandoc).

## Skills (attributed references)
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| reveal.js official docs | official-docs | https://revealjs.com/ | yes | MIT | Hakim El Hattab & contributors |
| hakimel/reveal.js (canonical repo + README) | repo | https://github.com/hakimel/reveal.js | yes | MIT | Hakim El Hattab |
| webpro/reveal-md (Markdown → reveal.js CLI; maintenance-only) | community | https://github.com/webpro/reveal-md | no | MIT | Lars Kappert (webpro) |
| MkSlides (Python, MkDocs-style successor to reveal-md) | community | https://github.com/MkSlides/mkslides | no | MIT | MkSlides project |
| astefanutti/decktape (headless PDF exporter) | community | https://github.com/astefanutti/decktape | no | MIT | Antonio Stefanutti |
| Quarto reveal.js format docs (literate → reveal.js) | official-docs | https://quarto.org/docs/presentations/revealjs/ | no | docs CC / Quarto GPL-2.0 | Posit, PBC |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JS/TS (native) | `npm install reveal.js` (or clone repo + `npm i`) | author `index.html` with `.reveal > .slides > section`; `Reveal.initialize()`; dev: `npm start` → http://localhost:8000 |
| Node CLI (Markdown) | `npm install -g reveal-md` | `reveal-md slides.md` (live); `reveal-md slides.md --static _site`; PDF: `reveal-md slides.md --print out.pdf` |
| Python | `pip install mkslides` | `mkslides serve slides.md` / `mkslides build slides.md` |
| Python/R/Julia (literate) | `brew install quarto` | `quarto render talk.qmd --to revealjs` → talk.html |
| Any (Markdown → HTML) | `brew install pandoc` | `pandoc -t revealjs -s slides.md -o slides.html` |
| Node CLI (PDF export) | `npm install -g decktape` | `decktape reveal --fragments http://localhost:8000 out.pdf` |

## Artifact kind
**html** — primary deliverable is a standalone interactive HTML deck that runs in any browser. PDF is a secondary flattened export (`?print-pdf` or DeckTape).

## Validation
- **install**: `npm install -g reveal-md`
- **smoke**: `printf '# Hello\n\nreveal.js smoke\n\n---\n\n## Slide 2\n\n- bullet\n' > /tmp/deck.md && reveal-md /tmp/deck.md --static /tmp/deck-out && ls /tmp/deck-out/index.html`
- **expect**: Exits 0 and writes a self-contained static site at `/tmp/deck-out/` with `index.html` (rendered reveal.js HTML deck) plus bundled `_assets/` CSS+JS. Headless on macOS — no GUI needed for static export. For PDF: `reveal-md /tmp/deck.md --print /tmp/deck.pdf` spins up headless Chromium.

## Wrapper params
- `theme` — black/white/league/beige/sky/night/serif/simple/solarized/dracula/moon/blood
- `transition` — slide/fade/convex/concave/zoom/none
- `highlightTheme` — highlight.js code theme
- `controls`, `progress`, `slideNumber`, `hash` — UI toggles
- `printPdf` — flag for static/PDF export (`?print-pdf` / DeckTape)
- Markdown paths add `--theme`, `--highlight-theme`, `--css`, `--static <dir>` (reveal-md); DeckTape adds `--fragments`, `--size`, `--slides`.

## Component / explorer notes
The default HTML artifact shell renders it directly — output is a standalone HTML deck that runs in any browser; no richer explorer needed. For a gallery/preview surface, an iframe wrapper is enough. Speaker-notes view opens a second window (S key); PDF export is reached via the `?print-pdf` URL fragment.
