# processing — creative

## Summary
Processing is a Java-based creative-coding language/IDE for generative art and visualization. Its primary deliverable is a rendered raster image — a single frame written via `saveFrame()` / `save()` — though it also produces animation/video frame sequences and interactive sketches. The native toolchain is the `processing-java` CLI bundled with the Processing app; headless export on macOS/CI typically needs a display context (wrap with `xvfb-run` on Linux). For agent/headless and web workflows the dominant modern path is its JS sibling **p5.js** (rendered to an HTML5 canvas), which can be driven server-side via node-canvas ports (`node-p5`) or a headless browser — the easiest route to a still PNG on macOS with no display.

Confidence: medium. "Processing" the brand spans the Java IDE (`processing-java`) and the p5.js ecosystem; this dossier keeps Processing/Java native as the canonical tool and uses `node-p5` as the headless render/validation fallback.

## Skills
| Skill | Type | Official | URL | License |
|-------|------|----------|-----|---------|
| Anthropic p5.js algorithmic-art skill | anthropic-skill | yes | https://github.com/anthropics/skills | see anthropics/skills repo (MIT/Apache-style) |
| p5.js official reference + for-LLM docs | official-docs | yes | https://p5js.org/reference/ | docs CC-BY-SA; library LGPL-2.1 |
| Processing official reference | official-docs | yes | https://processing.org/reference/ | docs CC-BY-NC-SA; core GPL/LGPL |
| p5.js MCP server / editor | community | no | https://adilmoujahid.com/posts/2025/06/mcp-server-p5js-editor/ | see repo |

Attribution:
- **Anthropic p5.js algorithmic-art skill** — Anthropic-bundled creative-coding skill covering seeded randomness, parameter exploration, flow fields, and particle systems.
- **p5.js reference** — Processing Foundation / p5.js; canonical API reference plus for-LLM docs.
- **Processing reference** — Processing Foundation; canonical Java-side API reference.
- **p5.js MCP server/editor** — Adil Moujahid; natural-language p5.js editor driven via MCP (community).

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Java / native CLI | Download Processing from https://processing.org/download ; on macOS install the `processing-java` helper (Tools menu) | `processing-java --sketch=/path/to/sketch --output=/tmp/out --force --run` with `saveFrame()`/`exit()` in the sketch. Canonical native toolchain; headless on Linux/CI wraps with `xvfb-run`. |
| JS/TS (browser) | `npm install p5` or CDN `<script src="https://cdn.jsdelivr.net/npm/p5/lib/p5.min.js">` | Sketch draws to canvas; `saveCanvas(c,'out','png')` triggers a download. Primary interactive/web target. |
| Node.js (headless port) | `npm install node-p5` | Server-side p5 port (2D only, no WebGL/3D/input). `p.saveCanvas(canvas,'out','png')` writes a file directly — best headless image export on macOS. |
| Node.js (headless browser) | `npm install puppeteer` | Render full p5.js (incl. WebGL) in headless Chromium, then `page.screenshot()` / read `canvas.toDataURL()`. Heaviest, highest fidelity for 3D/WebGL. |

## Artifact kind
`image` — the default deliverable is a single rendered PNG frame (`saveFrame()`/`save()` in Processing, `saveCanvas()` in p5). The universal image shell renders this directly. Animation frame sequences and interactive sketches are secondary outputs.

## Validation
- **install**: `npm install node-p5`
- **smoke**: `node -e "const p5=require('node-p5');function sketch(p){p.setup=function(){const c=p.createCanvas(400,400);p.background(20);p.noStroke();for(let i=0;i<200;i++){p.fill(p.random(255),p.random(255),p.random(255),150);p.ellipse(p.random(400),p.random(400),p.random(10,60));}p.saveCanvas(c,'out','png').then(()=>process.exit(0));};}p5.createSketch(sketch);"`
- **expect**: Writes `out.png` (400x400) of random colored circles to the cwd and exits 0. Confirms headless p5 rendering works on macOS with no display.

## Wrapper params
Expose: random seed (`randomSeed()`/`noiseSeed()` for reproducibility), canvas width/height, frame index to capture, background/palette, and sketch-specific generative params (particle count, noise scale, flow-field resolution). For animation: fps + frame count. A headless toggle selects save-and-exit vs. interactive run.

## Component / explorer notes
The default deliverable is a still PNG, which the standard image artifact shell renders directly. But the live value of Processing/p5.js is the interactive/animated sketch — a richer explorer (HTML canvas + play/pause + parameter sliders) better showcases generative output. For static dossier purposes, exporting one representative frame to PNG is the safe primary artifact.
