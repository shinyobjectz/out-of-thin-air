<!-- generated draft — needs validation -->
# resvg-js

Category: `social-formats` · Slug: `resvg-js` · Artifact kind: **image** (PNG)

## Summary

resvg-js (`@resvg/resvg-js`) is a high-performance SVG renderer/toolkit: a Rust-based `resvg` engine bound to JS via napi-rs (native), plus a pure WebAssembly backend. It rasterizes static SVG markup into deterministic PNG bitmaps with options for fit/scale, background color, cropping, and custom/system font loading.

Strong fit for OOTA social-formats deliverables: author SVG (deterministic, version-controllable markup), render headlessly to a fixed-size PNG (OG images, social cards) with no browser. Primary deliverable = image (PNG). Latest stable v2.6.2 (Mar 2024). License MPL-2.0.

Note: resvg targets the **static SVG subset** — no SMIL animation, no embedded JS, limited filter support. It is a still-image renderer, not an animation tool. No official Anthropic/Claude skill exists; drive via the documented Node/Deno/Bun API.

## Skills

| Skill / doc | Type | Official | License | Attribution | URL |
|---|---|---|---|---|---|
| resvg-js README + docs | documentation | official | MPL-2.0 | yisibl / resvg-js contributors | https://github.com/yisibl/resvg-js |
| @resvg/resvg-js npm package page | documentation | official | MPL-2.0 | yisibl | https://www.npmjs.com/package/@resvg/resvg-js |
| resvg (upstream Rust engine, linebender/resvg) | documentation | official | MPL-2.0 | RazrFalcon / Linebender | https://github.com/linebender/resvg |

## Toolchains

| Lang | Runtime | Install | Invoke / notes |
|---|---|---|---|
| JS/TS | Node.js 12–22 (native napi-rs binding) | `npm i @resvg/resvg-js` | Primary path. Prebuilt native binaries per-platform incl. macOS arm64/x64. `import { Resvg } from '@resvg/resvg-js'; new Resvg(svg, opts).render().asPng()`. |
| JS/TS | Bun 0.8.1+ | `bun add @resvg/resvg-js` | Same npm package, runs unmodified; Node-compatible API. |
| JS/TS | Deno 1.26.1+ | `import { Resvg } from 'npm:@resvg/resvg-js'` | `npm:` specifier; native binding. |
| JS/TS | WebAssembly (browser / edge / no-native) | `npm i @resvg/resvg-wasm` | Pure WASM backend for CF Workers, browser, sandboxes. Requires `initWasm()` before use. |

## Artifact kind

**image** — primary deliverable is a rasterized PNG bitmap. SVG is the source; PNG is the output the universal shell renders.

## Validation

**Install**
```bash
mkdir /tmp/resvg-smoke && cd /tmp/resvg-smoke && npm init -y && npm i @resvg/resvg-js
```

**Smoke** — write `smoke.mjs`:
```js
import { Resvg } from '@resvg/resvg-js';
import { writeFileSync } from 'node:fs';
const svg = '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="100"><rect width="200" height="100" fill="#0af"/><text x="20" y="55" font-size="24" fill="#fff">OOTA</text></svg>';
const r = new Resvg(svg, { fitTo: { mode: 'width', value: 400 } });
writeFileSync('out.png', r.render().asPng());
console.log(r.render().asPng().length);
```
then: `node smoke.mjs`

**Expect** — exits 0, prints a positive byte count, writes `/tmp/resvg-smoke/out.png` — a 400x200 PNG (verify: `file out.png` → `PNG image data, 400 x 200`). Runs fully headless on macOS, no browser/display.

## Wrapper params

Thin wrapper: take an SVG string/Buffer + `RenderOptions`, return PNG Buffer. Key options:

- `fitTo`: `{ mode: 'width'|'height'|'zoom'|'original', value }`
- `background`: CSS color (supports alpha)
- `crop`
- `font`: `{ fontFiles: [...], loadSystemFonts: bool, defaultFontFamily }`
- `dpi`
- `textRendering` / `shapeRendering` / `imageRendering`

Output is PNG only (`asPng()`); for JPEG/WebP/resize pipe through `sharp`. `render()` also exposes `width`/`height` and `innerBBox`/`getBBox()` for layout. For deterministic CI builds set `loadSystemFonts: false` and ship explicit `fontFiles`. Use `@resvg/resvg-wasm` for sandboxed/edge runtimes without native addons.

## Component / explorer notes

Author deterministic SVG markup as source-of-truth (text, shapes, paths, gradients). Keep pinned to resvg's supported static SVG subset: NO SMIL/CSS animation, NO embedded JavaScript, partial SVG filter support, CSS via presentation attributes/inline styles only (no external stylesheets). Embed fonts explicitly via the `font` option (`fontFiles` / `loadSystemFonts: false`) so output is byte-stable across machines — relying on system fonts breaks determinism. Use external bitmap refs as data URIs to keep a single self-contained input.
