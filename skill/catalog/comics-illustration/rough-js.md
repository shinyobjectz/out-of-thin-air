<!-- generated draft — needs validation -->
# Rough.js (`rough-js`) — comics-illustration

## Summary
Rough.js is a small (<9kB gzip), MIT-licensed JS graphics library by Preet Shihn that renders
primitives — lines, curves, arcs, polygons, circles, ellipses, and arbitrary SVG paths — in a
hand-drawn, sketchy style. Latest version 4.6.6 (npm). It runs in two modes: a DOM-coupled renderer
(`rough.svg(svgEl)` / `rough.canvas(canvasEl)`) and a headless, DOM-free generator
(`rough.generator()`) whose drawables convert to plain SVG path `d` strings via `generator.toPaths()`
— ideal for OOTA's deterministic, headless, file-emitting workflow.

CRITICAL for determinism: rough.js perturbs geometry with PRNG randomness by default. Pass a fixed
integer `seed` (e.g. `{seed: 42, roughness: 2}`) on every shape to get byte-stable,
version-controllable SVG across runs. The primary deliverable is an SVG document.

## Skills
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| rough-stuff/rough repo + wiki API docs | docs | https://github.com/rough-stuff/rough/wiki | official | MIT | Preet Shihn / rough-stuff |
| Rough.js homepage + examples | docs | https://roughjs.com/ | official | MIT | Preet Shihn |
| svg2roughjs (sketchify existing SVG) | library | https://github.com/fskpf/svg2roughjs | community | MIT | fskpf |

No official Anthropic/Claude skill exists. Document the generator+toPaths recipe inline.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/TypeScript (Node >=14) | `npm install roughjs` | Headless/deterministic: `import rough from 'roughjs'; const g = rough.generator(); const d = g.rectangle(x,y,w,h,{seed:42,fill:'red'}); g.toPaths(d)` → array of `{d,stroke,fill,strokeWidth,fillStyle}`; assemble into an `<svg>` string and write to disk. NO DOM/jsdom needed. ESM + CJS both shipped. |
| JavaScript (browser/DOM) | `npm install roughjs jsdom` | DOM renderer: `rough.svg(svgElement)` returns an instance whose `.rectangle()/.circle()/etc` return real `<path>` SVGNodes. In Node supply an element from `new JSDOM().window.document`. `rough.canvas(canvasEl)` targets HTMLCanvasElement (node-canvas) for raster. |

## Artifact kind
`svg` — a self-contained SVG document of sketchy `<path>` elements.

## Validation
- Install: `mkdir rt && cd rt && npm init -y && npm install roughjs`
- Smoke:
  ```bash
  node --input-type=module -e "import rough from 'roughjs'; import {writeFileSync} from 'fs'; const g=rough.generator(); const r=g.rectangle(10,10,180,100,{seed:42,roughness:2,fill:'red'}); const body=g.toPaths(r).map(p=>'<path d=\"'+p.d+'\" stroke=\"'+p.stroke+'\" fill=\"'+p.fill+'\" stroke-width=\"'+p.strokeWidth+'\"/>').join(''); writeFileSync('out.svg','<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"120\">'+body+'</svg>'); console.log('wrote out.svg');"
  ```
- Expect: Exit 0, prints `wrote out.svg`; `out.svg` (~16KB) is a valid standalone SVG with sketchy
  `<path>` elements. Re-running with the same seed produces byte-identical output. Verified on macOS,
  Node, headless, no DOM.

## Wrapper params
- `comics-illustration.title` (text) — label/comment for the artifact.
- `comics-illustration.seed` (text) — fixed integer seed; REQUIRED for deterministic, diffable output.
- `comics-illustration.roughness` (range) — sketchiness amount.
- `comics-illustration.fill` (color) — fill color.
- `comics-illustration.fillStyle` (select) — hachure | solid | zigzag | cross-hatch | dots | dashed | zigzag-line | sunburst.

## Component / explorer notes
Use `rough.generator()` (DOM-free) as the OOTA component — it returns Drawable objects, and
`generator.toPaths(drawable)` yields plain SVG path data the wrapper stitches into a self-contained
`<svg>`. Generator API mirrors the renderers: `line, rectangle, ellipse, circle, linearPath, polygon,
arc, curve, path(svgPathString)`. Options that matter: `seed` (REQUIRED for determinism), `roughness`,
`bowing`, `stroke`, `strokeWidth`, `fill`, `fillStyle`, `fillWeight`, `hachureAngle`, `hachureGap`.
`fillStyle` additions (dashed/sunburst/zigzag-line) landed in 3.1.0.

Wrapper strategy (preferred): generator + manual SVG string assembly — zero extra deps, fully
headless, deterministic with seed. rough.js does NOT emit a complete SVG document, only path
fragments; the wrapper must serialize each path's `d/stroke/fill/strokeWidth` and wrap in an
`<svg xmlns width height>` root. Alternative: jsdom-backed `rough.svg(svgEl)` then serialize via
XMLSerializer/outerHTML (adds jsdom). For raster/PNG use `rough.canvas()` over node-canvas, but SVG
is the canonical deterministic deliverable. Always thread a fixed seed through every shape.
