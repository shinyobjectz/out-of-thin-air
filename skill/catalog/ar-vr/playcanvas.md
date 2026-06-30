<!-- generated draft — needs validation -->
# PlayCanvas (ar-vr)

## Summary
PlayCanvas is an open-source (MIT) JavaScript 3D engine built on WebGL / WebGPU / WebXR and glTF 2.0. For OOTA it authors a deterministic, version-controllable WebGL/WebXR scene in JS/TS that ships as a self-contained HTML+JS bundle (primary artifact kind: **html**). The engine runs in the browser; headless visual rendering is NOT supported natively in Node.js (it falls back to a `NullGraphicsDevice` that produces no pixels), so the realistic headless validation path is Playwright / headless-Chrome (SwiftShader software WebGL) screenshotting the page to a PNG. Node.js + jsdom mode is for logic / asset-processing / tests only, not frame output. Category is `ar-vr` due to first-class WebXR support. Confidence: medium — headless-to-file rendering requires an external browser harness, not the engine itself.

## Skills
| Name | Type | Official | License | URL |
| --- | --- | --- | --- | --- |
| PlayCanvas Editor MCP Server | mcp | yes (official) | MIT | https://github.com/playcanvas/editor-mcp-server |
| (none) Anthropic/Claude skill or llms.txt | none | no | n/a | https://github.com/playcanvas/engine |

- **PlayCanvas Editor MCP Server** — PlayCanvas (official). MCP server that drives the cloud PlayCanvas Editor via LLM — 20+ tools for entity hierarchy, components, assets, scripts, materials, store search, viewport screenshots. NOTE: automates the interactive Editor, not a headless deterministic code->file pipeline; useful for authoring, not for OOTA's deterministic render step.
- **No first-party Anthropic skill or published llms.txt** found as of 2026-06. Engine API docs: https://api.playcanvas.com — user manual: https://developer.playcanvas.com .

## Toolchains
| Lang | Install | Invoke / notes |
| --- | --- | --- |
| JS/TS (Browser, WebGL2/WebGPU/WebXR) | `npm install playcanvas` | Primary mode. Author a `pc.AppBase`/`pc.Application` scene, bundle (Vite/esbuild/rollup) into a single HTML+JS deliverable. ESM; also via CDN `https://code.playcanvas.com/playcanvas-stable.min.js`. Deterministic, version-controllable source. |
| JS/TS (Node.js 18+) | `npm install --save-dev playcanvas jsdom` | Headless logic mode (https://developer.playcanvas.com/user-manual/engine/running-in-node/). jsdom shims DOM + `new pc.NullGraphicsDevice()`. Runs simulation / asset-processing / unit tests but renders NO pixels — cannot emit image/video. |
| JS/TS (Headless Chromium via Playwright/Puppeteer) | `npm install -D playwright && npx playwright install chromium` | Realistic OOTA render-to-file harness. Load bundled HTML in headless Chrome w/ software WebGL (SwiftShader), then `page.screenshot()` -> PNG. Works headless on macOS. |

## Artifact kind
**html** — a self-contained HTML page that boots a `pc.AppBase`, loads glTF/GLB assets, and runs the WebGL/WebXR render loop.

## Validation
- **install**: `mkdir pc-smoke && cd pc-smoke && npm init -y && npm i -D playcanvas playwright && npx playwright install chromium`
- **smoke**: Create `index.html` that loads playcanvas (CDN or bundled), creates a `pc.AppBase` on a canvas, adds a camera + light + a box model entity, and calls `app.start()`; then a Node Playwright script: launch chromium headless with `['--use-gl=swiftshader','--enable-unsafe-swiftshader']`, `page.goto('file://.../index.html')`, wait ~500ms for the render loop, `await page.screenshot({path:'out.png'})`.
- **expect**: `out.png` written (>5KB) showing a shaded 3D cube on the configured clear-color background; no WebGL-context errors in console. Confirms deterministic source -> headless image on macOS.

## Wrapper params
- `ar-vr.title` (text) — scene title.
- `ar-vr.clear_color` (color) — render clear color / background.

## Component / explorer notes
PlayCanvas is a runtime 3D/WebXR engine, not a render-to-file generator. The deterministic OOTA artifact is the authored scene source (JS/TS + glTF/GLB assets) bundled into a self-contained HTML page. glTF 2.0 (GLB) is the asset interchange format (Draco/Meshopt/Basis supported). Determinism holds at the source/markup level; pixel-level determinism across GPUs is not guaranteed — pin a software rasterizer (SwiftShader) for reproducible screenshots. Engine is MIT-licensed (github.com/playcanvas/engine). Wrap as: (1) author scene in TS against `playcanvas`; (2) bundle to one HTML file (inline JS, assets as data-URI or sibling .glb); (3) for headless capture, drive via Playwright headless Chromium with `--use-gl=swiftshader`/`--enable-unsafe-swiftshader`, screenshot to PNG (image) or frames -> ffmpeg (video). Node+jsdom NullGraphicsDevice is for non-visual checks only. Do NOT rely on the engine alone to emit a file — it has no built-in file render output.
