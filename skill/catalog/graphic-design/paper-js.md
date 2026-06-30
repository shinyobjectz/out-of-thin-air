<!-- generated draft — needs validation -->
# Paper.js (`paper-js`) — graphic-design

## Summary
Paper.js is an open-source vector graphics scripting framework built on HTML5 Canvas. It offers a Scene Graph / DOM with paths, beziers, boolean operations, path simplification, and Adobe-style blend modes. It is deterministic and code-driven (plain JS scripts), making it well-suited for OOTA. For headless, version-controllable rendering it ships the `paper-jsdom` package (jsdom-backed) which imports and exports SVG without a browser — the primary deterministic deliverable is an **SVG file**. A heavier `paper-jsdom-canvas` variant adds raster PNG output via node-canvas (requires native Cairo/Pango). Current stable release is **0.12.18 (MIT)**.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| No official Anthropic/Claude skill | none | no | n/a | — |
| Paper.js Reference / Tutorials (official docs) | documentation | yes | MIT (project) | https://paperjs.org/reference/global/ |
| paperjs/paper.js (canonical source repo) | repository | yes | MIT | https://github.com/paperjs/paper.js |

Attribution: Paper.js by Jürg Lehni (@lehni) & Jonathan Puckey (@puckey). No Anthropic-published or community Claude Agent Skill found for Paper.js as of 2026-06.

## Toolchains
| Lang | Install | Invoke / notes |
|------|---------|----------------|
| JS/Node.js (headless) | `npm install paper-jsdom` | jsdom-backed; SVG import/export only (no canvas raster). Pin `paper@0.12.18`. `node script.js` where script `require('paper-jsdom')`, builds geometry, then `paper.project.exportSVG({asString:true})`. |
| JS/Node.js + node-canvas | `npm install paper-jsdom-canvas` | Adds raster (PNG) via node-canvas; needs native Cairo+Pango (`brew install pkg-config cairo pango libpng jpeg giflib librsvg`). Heavier; only for PNG output. |
| JS (browser) | `npm install paper` (or CDN `paper-full.min.js`) | Browser/Electron build. Supports PaperScript via `<script type="text/paperscript">`. Not needed for headless OOTA. |

## Artifact kind
**svg** — primary deterministic deliverable. Same script yields byte-stable SVG (no randomness unless author uses `Math.random`). For raster, prefer `exportSVG` over canvas for version control; downstream rasterize via resvg/sharp if image kind needed.

## Validation
- **install:** `mkdir paperjs-smoke && cd paperjs-smoke && npm init -y && npm install paper-jsdom`
- **smoke:** `node -e "const paper=require('paper-jsdom');paper.setup(new paper.Size(200,200));new paper.Path.Circle({center:[100,100],radius:80,fillColor:'tomato'});require('fs').writeFileSync('out.svg',paper.project.exportSVG({asString:true}));"`
- **expect:** Writes `out.svg` (~591 bytes) — valid `<svg version="1.1" ... width="200" height="200" viewBox="0,0,200,200">` containing a filled circle path. Verified headless on macOS (darwin 24.6) with paper-jsdom 0.12.18, no browser, no native deps.

## Wrapper params
- `graphic-design.title` (text) — title/label drawn as point text.
- `graphic-design.width` / `graphic-design.height` (range) — canvas size for `paper.setup`.
- `graphic-design.fill` (color) — primary fill color.
- `graphic-design.script` (textarea, bound to `src/scene.js`) — JS scene body building geometry.

## Component / explorer notes
Build geometry imperatively (`Path`, `Path.Circle`, `CompoundPath`, `Group`, `Layer`), set styles, then `exportSVG`. Boolean ops (`unite`/`subtract`/`intersect`), `path.simplify()`, and `PointText` items are all serializable to SVG. Use `require('paper-jsdom')` (NOT `'paper'`) for headless — `'paper'` alone has no DOM and `exportSVG` will fail in Node. Always call `paper.setup(size)` before building. Pin `paper-jsdom` and `paper` to identical 0.12.x versions to avoid the well-known peer-version mismatch. Avoid `paper-jsdom-canvas` unless raster PNG is required.
