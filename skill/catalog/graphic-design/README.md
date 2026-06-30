# graphic-design

Imperative/declarative 2D vector design → svg/pdf/png (print deliverables).

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|------------|---------------|-----------|--------|----------|-------|
| [Satori](./satori.md) | svg | satori (Node 16+ / Bun / Deno), satori + @resvg/resvg-wasm (edge), @resvg/resvg-js (SVG→PNG) | Satori README + API docs | yes | ok | yes | yes |
| [DrawBot](./drawbot.md) | pdf | Python/drawbot-skia (Skia, headless CLI, recommended), Python/drawBot (macOS-only, CoreGraphics/AppKit) | (none) | no | ok | yes | yes |
| [SVG.js](./svg-js.md) | svg | JS/TS Node: @svgdotjs/svg.js + svgdom | SVG.js official docs (v3.2) | yes | ok | yes | yes |
| [Cairo](./cairo.md) | image | pycairo, CairoSVG, cairocffi | (none) | no | ok | yes | yes |
| [Paper.js](./paper-js.md) | svg | paper-jsdom (Node headless), paper-jsdom-canvas (Node + node-canvas raster), paper (browser/Electron) | Paper.js Reference / Tutorials | yes | ok | yes | yes |
| [nannou](./nannou.md) | image | Rust (native cargo/rustc, stable) | (none) | no | ok | yes | yes |

## Multi-toolchain notes

- **Satori** — primary deliverable is SVG; pipe through `@resvg/resvg-js` (or `@resvg/resvg-wasm` on edge) for PNG. CommonJS `require('satori')` needs `.default`. Headless, no browser. Runs under Node/Bun/Deno.
- **DrawBot** — `drawbot-skia` CLI is the recommended headless route (cross-platform Skia); output extension selects the emitter, no `saveImage()` in CLI scripts. `drawBot` (drawbot.com) is macOS-only (CoreGraphics/AppKit) and a superset of the skia API. No official skill; community generative-art skills target p5.js.
- **SVG.js** — headless via `svgdom`; deterministic, byte-identical output across runs.
- **Cairo** — `pycairo` is the imperative surface API (PNG); `CairoSVG` transcodes SVG→PNG/PDF. Native deps via `brew install cairo pkg-config libffi`. Headless, no display server.
- **Paper.js** — `paper-jsdom` for deterministic headless SVG (no native deps); `paper-jsdom-canvas` adds node-canvas raster; `paper` for browser/Electron.
- **nannou** — Rust/wgpu; PNG only via `window.capture_frame` (no native SVG/video). macOS headless caveat: winit+wgpu/Metal need a display context, capture_frame has LoopMode issues (#525, #830) — not guaranteed headless.

## Validation order

Cheapest / most-reliable installs first:

1. **SVG.js** — single `npm install @svgdotjs/svg.js svgdom`, no native deps, deterministic.
2. **Paper.js** — `npm install paper-jsdom`, no native deps, deterministic SVG.
3. **Satori** — npm install + one font download (Inter TTF), headless.
4. **DrawBot** — `pip install drawbot-skia`, headless CLI, cross-platform.
5. **Cairo** — needs `brew install cairo pkg-config libffi` then pip; native build can fail.
6. **nannou** — Rust toolchain + cargo build (heavy); needs display context on macOS, not guaranteed headless.

## Explorer needs

Default shell suffices for all six (file-emitting, headless or graceful-degrading). Richer-explorer candidates:

- **nannou** — wgpu/Metal window + display context; benefits from a GUI/display-capable explorer on macOS rather than plain headless shell.
- **DrawBot / Cairo** — native toolchains (Skia, libcairo + pkg-config) want a build-capable explorer with system libs preinstalled.
