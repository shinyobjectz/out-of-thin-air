# spectacle — presentations (code-as-HTML)

## Summary
Spectacle is a React/JSX-based presentation library by Formidable/Nearform. Decks are
authored as React components (or MDX) and run as an HTML/JS web app — the PRIMARY deliverable
is **HTML**: a live, navigable browser deck with syntax-highlighted code via the `<CodePane>`
component and live code demos. PDF is a secondary export path (built-in `?exportMode=true`
print view, or headless-Chrome tools like `decktape`). No official Anthropic/Claude `SKILL.md`
exists; docs are conventional web docs, not an `llms.txt`.

## Skills (attributed references)
| Type | Name | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| repo | FormidableLabs/spectacle (source + README + docs) | https://github.com/FormidableLabs/spectacle | official | MIT | Formidable Labs |
| official-docs | Spectacle documentation site | https://commerce.nearform.com/open-source/spectacle/ | official | MIT | Formidable/Nearform |
| repo | spectacle-renderer (DEPRECATED headless-Chrome PDF renderer, ~9yr unmaintained) | https://github.com/FormidableLabs/spectacle-renderer | official | MIT | Formidable Labs |
| community | decktape — generic HTML-deck → PDF exporter (supports Spectacle) | https://github.com/astefanutti/decktape | community | MIT | Antonin Stefanutti |
| community | ox-spectacle — Emacs Org-mode exporter to Spectacle.js HTML | https://github.com/lorniu/ox-spectacle | community | GPL-3.0 | lorniu |

## Toolchains
| lang | install | invoke |
|---|---|---|
| JS/TS (React) | `npm install spectacle react react-dom` | Author deck as JSX (`import { Deck, Slide, Heading, CodePane } from 'spectacle'`); bundle/serve with Vite/CRA/webpack to emit the HTML deck |
| MDX | `npx degit FormidableLabs/spectacle/examples/mdx my-deck` | Write slides in Markdown/MDX separated by `---`; spectacle compiles to the same React deck |
| Native CLI (PDF export) | `npm install -g decktape` | `decktape automatic <built-deck-url> out.pdf` — drives the running HTML deck via Puppeteer, rasterizes slides to PDF |
| Emacs Lisp / Org | `(use-package ox-spectacle)` from MELPA/github | Org-mode export backend → self-contained Spectacle.js HTML |

## Artifact kind
**html** — primary deliverable is a live HTML/JS web app (navigable browser deck). PDF is secondary.

## Validation
- **install**: `npm create vite@latest deck -- --template react-ts && cd deck && npm install && npm install spectacle`
- **smoke**: Replace `src/App.tsx` with a minimal Deck (`import { Deck, Slide, Heading } from 'spectacle'; export default ()=> <Deck><Slide><Heading>Hi</Heading></Slide></Deck>`), then `npm run build` (emits `dist/index.html`). For PDF: `npm run dev &` then `npx -y decktape automatic http://localhost:5173/ deck.pdf`.
- **expect**: `npm run build` produces `dist/` with `index.html` + JS bundle rendering the navigable deck (arrow keys advance). `decktape` produces `deck.pdf` with one page per slide. Both run headless on macOS (decktape bundles Chromium).

## Wrapper params
- `theme` — colors/fonts via the `theme` prop
- `template` — footer / slide-number overlay
- `transition` — slide animation
- `<CodePane>` — `language` + `highlightRanges` + `autoFillHeight` for code slides
- `?exportMode=true` / printMode URL flag — built-in print/overview view
- For PDF: decktape `--size` and `--pause` flags

## Component / explorer notes
Primary artifact is a live HTML/JS web app, not a static file — the default HTML artifact shell
renders the built `index.html` bundle, but interactive features (keyboard nav, presenter mode,
live code panes, animations) want a real browser/iframe explorer rather than a flat HTML
snapshot. Syntax highlighting comes from the `<CodePane>` component at runtime.
