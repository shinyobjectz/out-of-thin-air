# fiction — Interactive fiction / branching narrative (stateful)

Author stateful, choice-driven stories — branching narratives, visual novels, and choice-of-games text adventures — that compile to a self-contained playable HTML artifact.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|------|--------------|-----------|----------------------|-----------|--------|----------|-------|
| [ink](./ink.md) | html | native .NET CLI (inklecate), JS/TS (inkjs), Rust (bladeink), Python (inkcpp-py), C++ (inkcpp), C#/Unity, Java (blade-ink) | [Writing With Ink (full language guide)](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md) | yes | ok | yes | yes (pre-existing) |
| [twine](./twine.md) | html | Go CLI (tweego, canonical), Node (extwee), Ruby (twee2), GUI (Twine 2) | [Tweego documentation](https://www.motoslave.net/tweego/docs/) | yes | ok | yes | yes |
| [choicescript](./choicescript.md) | html | JS/Node git (dfabulich/choicescript), npm CLI (unverified), browser (no-runtime) | [dfabulich/choicescript](https://github.com/dfabulich/choicescript) | yes | ok | yes | yes |
| [renpy](./renpy.md) | html | Python — Ren'Py SDK only (bundled interpreter, no PyPI; renpy.sh) | [Ren'Py Documentation (Reference Manual)](https://www.renpy.org/doc/html/) | yes | ok | yes | yes |

All four emit `html` as the playable artifact kind. ink/renpy compile through an intermediate (ink→JSON, renpy→.rpy/lint); twine/choicescript compile straight to a self-contained HTML file.

## Multi-toolchain notes

- **ink** — widest reach. Py (`inkcpp-py`), JS/TS (`inkjs`), Rust (`bladeink`), C++, C#/Unity, Java, plus native .NET CLI (`inklecate`). React-friendly via inkjs in the browser. Best pick when the host language matters.
- **twine** — Go (canonical `tweego`), Node (`extwee`), Ruby (`twee2`), plus the GUI editor. No Python/Rust path.
- **choicescript** — JS/Node only (git clone preferred; npm CLI unverified). Browser no-runtime compile path. No Py/Go/Rust/native.
- **renpy** — Python only, and only via the bundled SDK interpreter (no PyPI package). No JS/Go/Rust path; not a library you embed.

## VALIDATION ORDER

Cheapest / most reliable installs first:

1. **ink** — `npm i inkjs inklecate`; pure npm, no native toolchain, headless smoke (compile + Continue/currentChoices). Most reliable.
2. **twine** — single macOS binary download + `storyformats/`; one-shot `tweego -f harlowe-3 -o play.html`. No package manager but trivial.
3. **choicescript** — `git clone` + `node compile.js`; needs the repo but no build step; quicktest.js gates it.
4. **renpy** — heaviest: ~hundreds-of-MB SDK tar.bz2 download, then `renpy.sh ... lint`. Slowest install, validate last.

## EXPLORER NEEDS

All four render to an HTML artifact, but each wants a **playable interactive canvas** beyond a static-preview shell — the artifact is only meaningful when clicked through:

- **ink / twine / choicescript** — branching-text player: render passage/choice text, make choices clickable, track state across turns. The default artifact shell works if it can serve and interact with the compiled HTML.
- **renpy** — richest explorer need: visual-novel runtime (sprites, backgrounds, menus, save/load). The HTML5/WASM web build needs a full canvas player, not a text shell. Headless reviewability falls back to the `.rpy` script + lint report.

No 3D/orbit needs in this category; the shared requirement is a stateful click-through player.

## Dossiers

- [ink](./ink.md)
- [twine](./twine.md)
- [choicescript](./choicescript.md)
- [renpy](./renpy.md)
