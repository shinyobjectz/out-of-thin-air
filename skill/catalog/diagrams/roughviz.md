# roughViz (diagrams)

## Summary
roughViz (npm: `rough-viz`) is a reusable JS charting library by Jared Wilber for sketchy/hand-drawn-styled charts in the browser. Built on D3v5 + rough.js + handy. Chart types: Bar, Horizontal Bar (BarH), Donut, Pie, Line, Scatter, StackedBar. Renders an inline `<svg>` into a DOM container via D3; data comes from inline `{labels, values}` objects or CSV/TSV. Latest npm 2.0.5. Primary deliverable kind = **SVG** (the chart is an inline `<svg>` drawn with rough.js paths).

Determinism caveat: rough.js randomizes stroke jitter; roughViz does NOT expose a documented `seed`, so renders vary run-to-run unless you pin/patch rough.js's seed or post-process. Treat the authored input (HTML/JS config or Python script) as the version-controlled source; render headlessly via a browser engine to extract the SVG.

## Skills
- **No official Anthropic/Claude skill** — none exists as of 2026-06. Canonical reference is the upstream repo README + Observable examples. Repo: https://github.com/jwilber/roughViz — MIT (c) 2019 Jared Wilber.
- **roughViz.js Examples (Observable notebook)** — reference, author-maintained (official to author). https://observablehq.com/@jwilber/roughviz-examples — ISC/Observable. Jared Wilber's live examples of every chart type.
- **react-roughviz** — community wrapper (not official). https://github.com/Chris927/react-roughviz — MIT, Chris927. React component wrapper.
- **py-roughviz** — community wrapper (not official). https://github.com/Lvyn/py-roughviz — MIT, Lvyn. Python wrapper that emits a standalone HTML file embedding the roughViz CDN call.

## Toolchains
| Lang | Install | Invoke |
| --- | --- | --- |
| JavaScript (browser) | CDN: `<script src="https://unpkg.com/rough-viz@2.0.5"></script>` | `new roughViz.Bar({element:'#viz', data:{labels:['a','b'],values:[10,20]}})`. Global `roughViz`. Needs a DOM. |
| JavaScript (Node/bundler) | `npm install rough-viz` | `import roughViz from 'rough-viz'`. Render into a real/emulated DOM (Vite/webpack browser bundle). |
| Python | `pip install py-roughviz` | `from roughviz.charts.bar import Bar; chart=Bar(data={...}); chart.to_html('out.html')`. Emits self-contained HTML referencing the CDN; SVG produced when HTML loads in a browser. |
| JavaScript (React) | `npm install react-roughviz` | `<Bar data={...} />` components. |
| JavaScript (Vue) | `npm install vue-roughviz` | Vue component wrapper. |

## Artifact kind
**svg** — the deliverable is an inline `<svg>` chart drawn with rough.js hand-drawn paths.

## Validation
- **Install:** `npm init -y && npm install -D playwright && npx playwright install chromium`
- **Smoke:** write `render.mjs`:
  ```js
  import { chromium } from 'playwright';
  import { writeFileSync } from 'node:fs';
  const html = `<!doctype html><html><body><div id="viz"></div>
  <script src="https://unpkg.com/rough-viz@2.0.5"></script>
  <script>new roughViz.Bar({element:'#viz',data:{labels:['A','B','C'],values:[10,20,15]},title:'demo'});</script>
  </body></html>`;
  const b = await chromium.launch();
  const p = await b.newPage();
  await p.setContent(html, { waitUntil: 'networkidle' });
  await p.waitForSelector('#viz svg');
  const svg = await p.$eval('#viz svg', el => el.outerHTML);
  writeFileSync('chart.svg', svg);
  await b.close();
  ```
  Then `node render.mjs`.
- **Expect:** writes `chart.svg` containing an `<svg>` with rough.js hand-drawn `<path>` elements for a 3-bar chart, non-empty (>2KB). Byte output is NOT bit-stable across runs because rough.js jitter is unseeded; structure/bar-count is stable.

## Wrapper params
- `diagrams.title` (text) — chart title.
- `diagrams.type` (select: bar, barh, donut, pie, line, scatter, stackedbar) — chart type.
- `diagrams.labels` (text) — comma-separated labels.
- `diagrams.values` (text) — comma-separated values.
- `diagrams.roughness` (range) — stroke roughness.
- `diagrams.colors` (text) — comma-separated palette.

## Component/explorer notes
Deliverable is an inline SVG chart. roughViz needs a DOM (D3 selection + SVG); it cannot render in bare Node. Headless paths: (1) Playwright/Puppeteer + CDN HTML then extract `#viz svg` (recommended), or (2) py-roughviz `to_html()` to emit an HTML file then headless-render it.

DETERMINISM GAP: rough.js applies random stroke perturbation; roughViz 2.0.5 does not surface rough.js's `seed`, so successive renders differ pixel/path-wise. For reproducible/version-controllable SVG either monkey-patch rough.js (set a fixed `seed`/override `Math.random` before construction) or commit the authored config (JS/Python source) rather than the SVG. Fonts default to Gaegu/Indie Flower (Google Fonts); embed/inline fonts for offline determinism. Options of note: `roughness`, `fillStyle`, `fillWeight`, `strokeWidth`, `colors`, `font`.
