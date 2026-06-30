# infographics-posters

Data-driven infographics + generative print/poster layout → svg/pdf/png.

## Build matrix

| tool | kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [drawsvg](./drawsvg.md) | svg | Python (CPython 3.8+) — `pip install drawsvg~=2.0` → `python3 build.py` | No official Anthropic/Claude drawsvg skill | no | ok | yes | yes |
| [p5.riso](./p5-riso.md) | image | JS (Browser/p5.js); JS/TS (Node + headless Chromium / puppeteer) | p5.riso official docs + tutorials | yes | ok | yes | yes |

## Multi-toolchain notes

- **drawsvg** — single, hermetic Python path. SVG-only authoring with **no Cairo** dependency; renders headless on macOS. Pin `drawsvg~=2.0` (v2 uses the snake_case API). Avoid `time`/`random` for byte-determinism. Single control surface: `infographics-posters.title`.
- **p5.riso** — browser-only library; **no npm package and no native Node renderer**. Vendor `lib/riso.js` + `p5.js` and drive headless Chromium (puppeteer) to rasterize the canvas via `canvas.toDataURL`. **SVG/PDF unsupported — image (PNG) only.** Step script graceful-degrades to a hint when puppeteer is absent.
  - **License caveat (surfaced in all artifacts):** Anti-Capitalist Software License (ACSL 1.4) — **not OSI-permissive**. Restricts use to individuals / non-profit / worker-owned orgs and bars law-enforcement/military use.

## Validation order

Cheapest / most-reliable first:

1. **drawsvg** — `python3 -m pip install "drawsvg~=2.0"`, then one-liner smoke writes `/tmp/oota_drawsvg.svg`. No Cairo, no browser, fully headless. Fast and deterministic.
2. **p5.riso** — heavier: `npm i puppeteer` (downloads Chromium) + vendoring `riso.js` and `p5.min.js`, then headless render to `out.png`. Validate last; degrades to a hint if puppeteer missing.

## Explorer needs

- **drawsvg** — default shell is sufficient (Python one-liner / `build.py`).
- **p5.riso** — wants a richer explorer than the default shell: a headless-Chromium harness (puppeteer) to load the p5 sketch and capture the canvas. A plain shell cannot render the browser-only library.

## Tools

- [drawsvg](./drawsvg.md)
- [p5.riso](./p5-riso.md)
