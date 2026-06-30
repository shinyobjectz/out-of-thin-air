# chart.xkcd

`slug: chart-xkcd` · `category: diagrams` · `artifactKind: svg` · `confidence: medium`

## Summary

chart.xkcd (timqian/chart.xkcd) is an MIT-licensed JavaScript charting library that renders "sketchy / hand-drawn / cartoony" XKCD-styled charts as inline SVG in the DOM. Latest npm release v2.0.12 (2026-06-16). It exposes chart classes on the global `chartXkcd` object — `Line`, `Bar`, `StackedBar`, `XY`, `Pie` (and `Radar`) — each constructed as `new chartXkcd.Line(svgNode, config)`.

The library is browser/DOM-only (it needs an `<svg>` element and `document`), so for OOTA's deterministic, headless, version-controllable authoring you write a small JS config script and drive it through a headless browser (Puppeteer/Playwright) to serialize the rendered `<svg>` (or rasterize to PNG). The chart config (labels, datasets, options) is the deterministic source artifact. No official Anthropic/Claude skill exists; community wrappers (Vue, React) exist but are not needed for headless SVG emission.

## Skills

| Skill | Type | Official | License | URL | Attribution |
|---|---|---|---|---|---|
| chart.xkcd official docs + examples | official-docs | yes | MIT | https://timqian.com/chart.xkcd/ | timqian (Tim Qian), github.com/timqian/chart.xkcd |
| chart.xkcd README / src | repo | yes | MIT | https://github.com/timqian/chart.xkcd | timqian, MIT License |
| chart.xkcd-vue (community wrapper) | community-wrapper | no | MIT | https://github.com/shiyiya/chart.xkcd-vue | shiyiya |
| chart.xkcd-react (community wrapper) | community-wrapper | no | MIT | https://github.com/obiwankenoobi/chart.xkcd-react | obiwankenoobi |

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JavaScript/Node.js (Puppeteer) | `npm i chart.xkcd puppeteer` | `node render.js` — load chart.xkcd.min.js into a headless page, run `new chartXkcd.Line(svg, config)`, read `svg.outerHTML` for SVG (or `page.screenshot` for PNG) |
| Browser (CDN, no build) | `<script src="https://cdn.jsdelivr.net/npm/chart.xkcd@2/dist/chart.xkcd.min.js"></script>` | author a single self-contained HTML file with an `<svg>` node + inline config script; render headlessly to capture SVG/PNG. No npm needed |

Primary/only driver is the Node + headless-browser path. chart.xkcd is browser-DOM-only. Bundle chart.xkcd locally (npm) rather than CDN for hermetic/offline builds.

## Artifact kind

`svg` (vector, diff-able). `png` is a secondary raster fallback via `page.screenshot`.

## Validation

- **install**: `mkdir /tmp/xkcd && cd /tmp/xkcd && npm init -y >/dev/null 2>&1 && npm i chart.xkcd puppeteer`
- **smoke**: Write `render.js` that launches puppeteer headless, `setContent` with an `<svg class="c"></svg>` plus the bundled `node_modules/chart.xkcd/dist/chart.xkcd.min.js`, evaluates `new chartXkcd.Line(document.querySelector('.c'), {title:'t', data:{labels:['a','b','c'], datasets:[{label:'x', data:[1,2,3]}]}})`, then writes `document.querySelector('.c').outerHTML` to `out.svg` (or `page.screenshot` to `out.png`). Run `node render.js`.
- **expect**: A non-empty `out.svg` (~tens of KB) containing `<svg ...><path.../>` hand-drawn chart markup, or `out.png` raster. Runs fully headless on macOS with no display.

## Wrapper params

- `diagrams.title` (text) — chart title
- `diagrams.chartType` (select: Line, Bar, StackedBar, XY, Pie, Radar) — chart class
- `diagrams.xLabel` / `diagrams.yLabel` (text) — axis labels
- `diagrams.config` (textarea, bound to `src/chart.config.json`) — labels + datasets source artifact

## Component/explorer notes

chart.xkcd plots SVG into a provided `<svg>` DOM node. The deterministic, version-controllable artifact is the chart config object (`title`/`xLabel`/`yLabel`, `data.labels`, `data.datasets[{label,data,color}]`, `options`). Classes: `chartXkcd.Line`, `.Bar`, `.StackedBar`, `.XY`, `.Pie` (`.Radar` in some builds).

The "sketchy" look uses SVG roughness/jitter and an embedded xkcd-style font (xkcd-script) bundled in the library — no separate font install required for SVG output, but the font must be embedded for portable rendering. The hand-drawn distortion uses pseudo-random jitter, so byte-for-byte SVG output may vary run to run unless a seed is fixed; treat the config as canonical source and re-rendering as reproducible-enough rather than bit-identical (hence medium confidence on strict determinism). For tighter determinism: pin viewport size, disable animation, and consider seeding the RNG.
