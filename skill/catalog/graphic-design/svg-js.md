<!-- generated draft — needs validation -->
# SVG.js — graphic-design / svg-js

## Summary
SVG.js is a lightweight, dependency-free JavaScript library for creating, manipulating, and animating SVG with terse, readable syntax (current stable v3.2.x; repo last updated Sept 2025). It is fully deterministic and version-controllable: you author imperative JS that builds an SVG DOM and serialize it to a `.svg` string. Headless rendering on macOS works via the companion `svgdom` package (MIT, v0.1.23), a minimal DOM implementation that lets SVG.js run in Node with no browser — `registerWindow(window, window.document)` then `canvas.svg()` emits the markup. Same script yields byte-identical output, ideal for version control. Good fit for OOTA programmatic vector graphics, logos, charts, and diagrams where exact byte-stable output matters.

## Skills
- [SVG.js official documentation (v3.2)](https://svgjs.dev/docs/3.2/) — docs, **official**, MIT, svgdotjs org / Wout Fierens
- [svg.js GitHub repository](https://github.com/svgdotjs/svg.js) — repo, **official**, MIT, svgdotjs org
- [svgdom — headless DOM for SVG.js on Node.js](https://github.com/svgdotjs/svgdom) — repo, **official**, MIT, svgdotjs org

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/TypeScript (Node.js) | `npm install @svgdotjs/svg.js svgdom` | `import {createSVGWindow} from 'svgdom'; import {SVG, registerWindow} from '@svgdotjs/svg.js'; const w=createSVGWindow(); registerWindow(w, w.document); const c=SVG(w.document.documentElement); ...; const out=c.svg();` |

No browser, no native binaries required. svg.js also runs in-browser via `<script>` or bundlers, but the OOTA path is the Node/svgdom route.

## Artifact kind
`svg` — single `.svg` file from `canvas.svg()` serialization.

## Validation
- **install**: `npm install @svgdotjs/svg.js svgdom`
- **smoke**:
  ```bash
  node --input-type=module -e "import {createSVGWindow} from 'svgdom'; import {SVG, registerWindow} from '@svgdotjs/svg.js'; import {writeFileSync} from 'fs'; const w=createSVGWindow(); registerWindow(w, w.document); const c=SVG(w.document.documentElement); c.size(200,200); c.rect(100,100).fill('#ffcc00').move(50,50); c.circle(60).fill('#3366ff').center(100,100); writeFileSync('out.svg', c.svg()); console.log('wrote out.svg');"
  ```
- **expect**: Exits 0, prints `wrote out.svg`, and writes a valid `out.svg` (`<svg ...><rect.../><circle.../></svg>`) that opens in any browser/Preview on macOS showing a yellow square with a blue circle. Deterministic byte-identical output across runs.

## Wrapper params
- `graphic-design.title` (text) — design title / label.
- `graphic-design.width`, `graphic-design.height` (range/text) — canvas dimensions.
- `graphic-design.fill` (color) — primary fill color.

Wrap as a Node ESM script taking params (dimensions, colors, data) and writing one `.svg` to a target path. Pin `@svgdotjs/svg.js` (^3.2) and `svgdom` (^0.1.23) for reproducibility.

## Component / explorer notes
Deliverable is a single `.svg` file (the `canvas.svg()` / `node.outerHTML` serialization). Output is deterministic and diff-friendly. For pure shape/path/gradient graphics no font setup is needed. If text bounding-box geometry or text-on-path is used, svgdom needs explicit font config (`config.setFontDir().setFontFamilyMappings({...}).preloadFonts()`); it ships Open Sans-Regular as default, and bold/italic variants must be registered with `.ttf` mappings. svgdom known limits: `querySelector` supports only a subset of pseudo-classes/selectors, and font metrics depend on preloaded fonts — keep text minimal or load fonts deterministically. To rasterize to image kind instead of svg, pipe the SVG through `sharp` or `resvg-js` downstream.
