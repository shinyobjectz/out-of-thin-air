# presentations

Slide decks / technical talks — author code/Markdown, get syntax-highlighted, exportable decks (HTML primary, PDF/PPTX secondary).

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|------|---------------|------------|----------------------|-----------|--------|----------|-------|
| [marp](./marp.md) | html | npm/npx, lib (marp-core), brew, scoop, docker, prebuilt binary | [@marp-team/marp-cli](https://github.com/marp-team/marp-cli) (MIT) | yes | ok | yes | yes |
| [slidev](./slidev.md) | html | JS/TS Node>=18 (npm/npx) | [slidev-skills](https://sli.dev) | no | ok | yes | yes |
| [reveal.js](./reveal.js.md) | html | JS/TS native, Node CLI (reveal-md), Python (mkslides), Quarto, Pandoc, PDF (decktape) | [reveal.js docs](https://revealjs.com/) | yes | ok | yes | yes |
| [spectacle](./spectacle.md) | html | JS/TS React, MDX, decktape (PDF), ox-spectacle (Emacs/Org) | [FormidableLabs/spectacle](https://github.com/FormidableLabs/spectacle) (MIT) | yes | ok | yes | yes |
| [quarto](./quarto.md) | html | native CLI (brew), Python, R, Julia, Node | [Quarto reveal.js guide](https://quarto.org/docs/presentations/revealjs/) | yes | ok | yes | yes |
| [deckary](./deckary.md) | pdf | PowerPoint add-in (no CLI); fallback Marp/Slidev (Node) | [Deckary](https://deckary.com) (proprietary, GUI-only) | no | partial | yes | yes |

## Multi-toolchain notes

- **Python**: reveal.js (via `mkslides`), quarto (`pip install quarto-cli`).
- **R / Julia**: quarto (`quarto::quarto_render`, Julia + jupyter).
- **JS/TS (Node)**: marp, slidev (Node-only), reveal.js (`reveal-md`), spectacle, deckary fallbacks.
- **React**: spectacle (decks authored as React `<Deck>` in TSX/MDX).
- **native CLI binary**: marp (brew/scoop/docker/prebuilt), quarto (brew binary).
- **Markdown-first**: marp, slidev, reveal.js (`reveal-md`/pandoc), quarto (`.qmd`).
- **Pandoc/Quarto bridges**: reveal.js can be produced from both pandoc and quarto.
- slidev is the only strictly **JS/TS/Node-only** engine (no native/Py path).

## VALIDATION ORDER

Cheapest/most-reliable first (pure-Node HTML emit, no headless browser), heaviest last:

1. **marp** — `npx @marp-team/marp-cli deck.md -o deck.html`; self-contained HTML, no browser needed. Most reliable.
2. **reveal.js** — `npm i -g reveal-md` then `reveal-md deck.md --static out`; static site, headless on macOS.
3. **quarto** — `brew install quarto` (or `pip install quarto-cli`) then `quarto render deck.qmd --to revealjs --embed-resources`; single binary, self-contained HTML.
4. **spectacle** — Vite scaffold + `npm install spectacle` + `npm run build`; emits dist/index.html (PDF needs decktape + running dev server).
5. **slidev** — needs `playwright-chromium` for export; HTML build cheap, PDF/PPTX export heaviest in the set.
6. **deckary** — no headless/CLI entrypoint; only the Marp/Slidev fallback is validatable. Validate last / as fallback only.

## EXPLORER NEEDS

All five working tools deliver an interactive HTML deck — they want a **navigable slide explorer** (keyboard arrow-key advance, slide-thumbnail/overview grid, presenter-notes pane) beyond a static artifact shell rather than the default single-pane viewer. slidev and spectacle especially benefit (live SPA / React deck with transitions). deckary's true deliverable is a binary `.pptx` that the universal shell cannot render — it degrades to a Marp-emitted PDF; no rich explorer applies.

## Dossiers

- [marp](./marp.md)
- [slidev](./slidev.md)
- [reveal.js](./reveal.js.md)
- [spectacle](./spectacle.md)
- [quarto](./quarto.md)
- [deckary](./deckary.md)
