# p5.js — creative

## Summary
p5.js is a JS creative-coding library (Processing lineage) for canvas/WebGL generative art, animation, and interactive sketches. The primary deliverable is an interactive HTML+canvas sketch driven by the `setup()`/`draw()` loop. It can also export PNG/SVG frames, GIF/WebM video, and run headless in Node via node-canvas ports for offline frame rendering.

## Skills
| Skill | Type | Official | URL | License |
|-------|------|----------|-----|---------|
| algorithmic-art (Generative p5.js art) | community | no | https://github.com/travisvn/awesome-claude-skills | Check repo (typically MIT) |
| p5.js official reference + tutorials | official-docs | yes | https://p5js.org/reference/ | CC / project docs |
| Getting Started with Node.js (p5 headless) | official-docs | yes | https://p5js.org/tutorials/getting-started-with-nodejs/ | project docs |

Attribution:
- **algorithmic-art** — listed/maintained via the community awesome-claude-skills index; most-starred creative Claude skill. Covers p5.js seeded PRNG, flow fields, particle systems, and PNG/SVG/GIF/WebM export with interactive parameter controls.
- **p5.js reference** — Processing Foundation official docs; canonical (not LLM-specific) API reference.
- **Node.js tutorial** — official p5.js guide for server-side / headless usage.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JS/TS (browser) | `npm install p5` or CDN `<script src="https://cdn.jsdelivr.net/npm/p5/lib/p5.min.js">` | Write `setup()`/`draw()`; open `index.html`. Canonical interactive HTML deliverable. |
| JS (Node headless) | `npm install node-p5` | `p5.createSketch(...)` + `saveCanvas()` to write PNG offline; no browser. |
| JS (Node headless, alt) | `npm install @ericrav/p5.node` | Runs sketches server-side via node-canvas/jsdom, exposes p5 globals. |
| JS (Node headless, alt) | `npm install p5js-node` | Another node-canvas p5 port for drawing in Node. |
| JS (browser automation) | `npm install puppeteer` | Drive headless Chromium running the sketch; screenshot/extract canvas. Most faithful to browser WebGL. |

## Artifact kind
`html` — the primary deliverable is a single `index.html` loading p5 from CDN with an inline sketch (setup/draw). The universal HTML shell renders this directly.

## Validation
- **install**: `npm install node-p5`
- **smoke**: `node -e "const p5=require('node-p5');p5.createSketch(p=>{p.setup=()=>{const c=p.createCanvas(400,400);p.background(20);p.fill(255,120,0);p.ellipse(200,200,200);p.saveCanvas(c,'out','png').then(()=>process.exit(0));};});"`
- **expect**: Writes `out.png` (400x400, dark background with an orange circle) to cwd; headless, no browser/display needed on macOS.

## Wrapper params
Expose: canvas width/height, random seed (`randomSeed`/`noiseSeed` for reproducibility), color palette, frameRate, and export format (PNG/SVG via p5.svg, GIF/WebM via `saveGif`/CCapture). For headless rendering: output dir + frame count.

## Component / explorer notes
The default HTML artifact shell renders the canonical browser sketch fine (single `index.html` + p5 CDN script). A richer explorer adds value for parameter sliders, seed control, and frame/GIF export buttons; the algorithmic-art skill already ships interactive parameter controls.
