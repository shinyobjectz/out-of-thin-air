<!-- generated draft — needs validation -->
# Observable Plot (`observable-plot`)

## Summary
Observable Plot is a free, open-source JavaScript library by Observable HQ for exploratory data visualization, implementing a layered grammar of graphics (marks, scales, transforms). Latest release v0.6.17 (Feb 14, 2025), ISC license. It renders deterministically to SVG headless in Node via JSDOM: pass a JSDOM document to `Plot.plot({document})` and serialize with `outerHTML`. Output class names are deterministically generated (not random) specifically to support SSR and external-stylesheet overrides, making output version-controllable. SSR is practical for simple/small-data plots; very large/geo plots are better client-rendered. For raster output, post-process SVG with sharp/resvg/Puppeteer.

## Skills
| Name | Type | URL | Official | License |
|------|------|-----|----------|---------|
| Observable Plot Visualization | skill | https://mcpmarket.com/tools/skills/observable-plot-visualization | community (MCP Market listing; not Anthropic/Observable) | unspecified |
| Observable Plot official docs | docs | https://observablehq.com/plot/ | official (Observable HQ) | ISC (library) |
| observablehq/plot GitHub repo | repo | https://github.com/observablehq/plot | official (Observable HQ) | ISC |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/Node.js (ESM) | `npm install @observablehq/plot d3 jsdom` | `node smoke.mjs` — `Plot.plot({document, marks})` then `svg.outerHTML`. Primary/only first-class driver. ESM only. Works under bun (`bun install`/`bun run`). |

## Artifact kind
`svg` — primary deliverable is a serialized standalone SVG document.

## Validation
**Install:**
```bash
mkdir -p /tmp/plot-smoke && cd /tmp/plot-smoke && npm init -y >/dev/null 2>&1 && npm install @observablehq/plot d3 jsdom >/dev/null 2>&1
```
**Smoke** (`smoke.mjs`):
```js
import * as Plot from "@observablehq/plot";
import {JSDOM} from "jsdom";
import {writeFileSync} from "node:fs";
const data=[{x:1,y:2},{x:2,y:4},{x:3,y:1},{x:4,y:5}];
const svg=Plot.plot({document:new JSDOM("").window.document,marks:[Plot.line(data,{x:"x",y:"y"}),Plot.dot(data,{x:"x",y:"y"})]});
svg.setAttributeNS("http://www.w3.org/2000/xmlns/","xmlns","http://www.w3.org/2000/svg");
svg.setAttributeNS("http://www.w3.org/2000/xmlns/","xmlns:xlink","http://www.w3.org/1999/xlink");
writeFileSync("out.svg",svg.outerHTML);
console.log("bytes",svg.outerHTML.length);
```
Run: `node smoke.mjs`

**Expect:** Exits 0, writes `/tmp/plot-smoke/out.svg` containing a `<svg ...>` element with `xmlns` set and `<path>`/`<circle>` marks; prints a positive byte count. File opens as valid SVG headless on macOS (e.g. `qlmanage -p out.svg`).

## Wrapper params
- `data-visualization.title` (text) — chart title / artifact name.

Wrap as a Node ESM script that takes a JSON/CSV data file + a spec and emits a `.svg` to stdout or a path. For PDF/PNG kinds, chain a deterministic rasterizer: `@resvg/resvg-js` or `sharp` for PNG, or `svg-to-pdf`, rather than Puppeteer (headless Chrome adds nondeterminism). Keep the spec as version-controlled JS/JSON so the deliverable is reproducible.

## Component / explorer notes
`Plot.plot()` can return either a bare `<svg>` (when there is no legend/figure wrapper) or an HTML `<figure>` containing the SVG plus title/caption/swatch legends. For a clean SVG artifact, avoid color legends/titles, or set `className` and extract the inner SVG. Deterministic class names (since the SSR improvements) keep output diffable; pin `@observablehq/plot` and `d3` versions for reproducibility. Fonts: JSDOM has no layout engine, so text metrics use Plot's estimator — output is stable but tick/label spacing differs slightly from browser rendering.

**SSR gotchas:** must add `xmlns`/`xmlns:xlink` attributes manually (shown in smoke) for standalone-valid SVG; building a plot without the `document` option throws in Node since there is no `window.document`.
