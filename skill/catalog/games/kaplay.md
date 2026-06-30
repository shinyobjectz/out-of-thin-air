# kaplay (games)

<!-- generated draft — needs validation -->

## Summary

KAPLAY (formerly Kaboom.js) is an MIT-licensed, fun-first 2D HTML5 game library for JavaScript/TypeScript. It renders to a WebGL/canvas inside the browser, so its deterministic, version-controllable deliverable is a self-contained HTML game bundle (source code → static HTML/JS via a bundler). Latest is the 4000.x alpha line (4000.0.0-alpha.27.1, May 2026); the stable line is 3001.x. There is NO official Anthropic/Claude skill, no published llms.txt, and no native headless/CLI renderer — it is driven as a code library and bootstrapped with the official `create-kaplay` scaffolder. Headless rendering for OOTA must go through a headless-Chromium step (Playwright/Puppeteer) loading the built HTML; the library exposes a `screenshot()`/`download()` API for image capture but only inside a running browser context.

## Skills

| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| KAPLAY official docs (API reference + guides) | official-docs | https://kaplayjs.com/docs/ | yes | MIT (docs site) | KAPLAY team (kaplayjs) |
| kaplayjs/kaplay source repository | official-repo | https://github.com/kaplayjs/kaplay | yes | MIT | KAPLAY team (kaplayjs) |
| create-kaplay official project scaffolder | official-cli | https://github.com/kaplayjs/create-kaplay | yes | MIT | KAPLAY team (kaplayjs) |

## Toolchains

| Lang | Install | Invoke / Notes |
|------|---------|----------------|
| JavaScript / TypeScript (Node >=18 + bundler; browser is target) | `npm install kaplay` | Primary path. Import `kaplay`, bundle with Vite/esbuild → static HTML+JS. Bootstrap full project: `npx create-kaplay my-game` (Vite dev server :5173). No-build: CDN `<script src="https://unpkg.com/kaplay@3001/dist/kaplay.js">` then `kaplay()`. |
| JavaScript / TypeScript (Bun) | `bun add kaplay` | Bun works for install/bundle; still targets browser canvas at runtime. |
| Headless capture harness (deterministic render) | `npm install -D playwright && npx playwright install chromium` | Wrapper layer, not a KAPLAY feature. Load built HTML in headless Chromium, wait for first frame, `page.screenshot()` or read canvas via `screenshot()`/`download()` to emit PNG; or ship the HTML bundle as the artifact. |

## Artifact kind

`html` — self-contained interactive game bundle (canvas + WebGL inside a DOM). Deterministic at source/markup level; visual output is frame-based and animated.

## Validation

- **install**: `mkdir kp && cd kp && npm init -y && npm install kaplay esbuild`
- **smoke**: Create `main.js`:
  ```js
  import kaplay from "kaplay";
  const k = kaplay();
  k.add([k.rect(120,80), k.pos(80,40), k.color(255,80,120)]);
  k.add([k.text("OOTA"), k.pos(80,140)]);
  ```
  then `npx esbuild main.js --bundle --format=iife --outfile=game.js` and write an `index.html` with `<canvas>` + `game.js`. Optional PNG proof: Playwright script that loads `index.html` headless and `page.screenshot({path:'frame.png'})`.
- **expect**: esbuild produces `game.js` with no errors; opening `index.html` headless renders a pink rectangle + "OOTA" text; optional Playwright run writes a non-empty `frame.png` (~tens of KB). Works headless on macOS with bundled Chromium.

## Wrapper params

- `games.title` (text) — text drawn in the scene.
- `games.width` / `games.height` (range) — canvas dimensions.
- `games.seed` (text) — RNG seed for reproducible frames.

## Component / explorer notes

KAPLAY's deliverable is an interactive browser game, not a one-shot static asset. Runtime is canvas+WebGL inside a DOM, so "rendering" = executing the bundle in a browser. Classify the artifact as `html`. It is deterministic at source level but visual output is animated; pin RNG seeds and capture a fixed frame for a reproducible image. The library exposes `screenshot()` and `download()` for export, but only from within a live browser context. An OOTA wrapper should: (1) treat KAPLAY source + an `index.html` shell as the version-controlled input; (2) bundle deterministically with esbuild/Vite to a single HTML+JS artifact; (3) for image/video kinds, add a headless-Chromium step that loads the bundle, advances to a seeded frame, and emits PNG (image) or a recorded canvas stream (video via ffmpeg). Pin the kaplay version (3001.x stable vs 4000.x alpha — alpha API may shift) and pin RNG seed for reproducibility. No official skill/llms.txt exists, so the wrapper carries its own usage prompts.
