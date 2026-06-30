# ar-vr

Declarative WebXR scenes + glTF⇄USDZ asset pipelines → `html` / `model3d` deliverables.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|------------|---------------|-----------|--------|----------|-------|
| [A-Frame](./a-frame.md) | html | HTML/JS (CDN); Node (npm aframe); Node+Puppeteer (headless capture) | A-Frame Official Documentation (LLM reference) | yes | ok | yes | yes |
| [model-viewer](./model-viewer.md) | html | JS/HTML (browser); Node (Puppeteer); Python (Playwright) | modelviewer.dev docs | yes | ok | yes | yes |
| [usd_from_gltf](./usd-from-gltf.md) | model3d | C++/CLI via Docker; C++/CLI native (Pixar USD); usdcat/usdchecker | google/usd_from_gltf README + tools | yes | ok | yes | yes |
| [Needle Engine](./needle.md) | html | TS/JS (Node+Vite); C# (Unity); Python (Blender); needle-cloud CLI | Needle Engine AI Skill | yes | ok | yes | yes |
| [PlayCanvas](./playcanvas.md) | html | JS/TS browser (WebGL/WebGPU/WebXR); Node+jsdom (NullGraphicsDevice); Playwright headless Chromium | PlayCanvas Editor MCP Server | yes | ok | yes | yes |
| [Babylon.js (NullEngine)](./babylon-js.md) | model3d | TS/JS (@babylonjs/core + serializers, Node>=18); UMD (babylonjs + serializers) | Babylon.js Server-Side / NullEngine docs | no | ok | yes | yes |

## Multi-toolchain notes

- **html is the dominant deliverable.** A-Frame, model-viewer, Needle, and PlayCanvas all ship a self-contained/bundled web page as the canonical artifact; a rendered PNG is a *downstream*, optional step gated on a headless browser being present. All four step scripts graceful-degrade (emit the markup/source, skip capture if the browser harness is absent).
- **model3d path is for asset conversion, not rendering.** usd_from_gltf is the glTF→USDZ converter (Docker is the recommended headless macOS route; upstream archived 2024-06-06). Babylon NullEngine exports `.glb`/`.gltf` headlessly — but has **no WebGL context**, so procedural/baked textures fail (`failed to read pixels`); geometry, transforms, and hierarchy export reliably.
- **Pin versions.** A-Frame pins the 1.8.0 CDN; Babylon requires `@babylonjs/core` and `@babylonjs/serializers` matched on major/minor.
- **GUI integrations skipped** as non-headless: Needle's Unity (C#) and Blender (Python) authoring paths are documented but only the npm/Vite headless build is wrapped. PlayCanvas Editor MCP is authoring-only (not a deterministic render).
- **Two tools lack a first-party Anthropic skill** (`skillOfficial:false` effectively): PlayCanvas (only the Editor MCP, authoring) and Babylon.js (grounded on server-side/NullEngine docs).

## Validation order

Cheapest / most reliable installs first:

1. **A-Frame** — no install; pure file write + grep. Deterministic, zero deps.
2. **Babylon.js (NullEngine)** — `npm install @babylonjs/core @babylonjs/serializers`; headless node, no browser/GPU. Deterministic glb magic-byte check.
3. **model-viewer** — `npm install puppeteer` + curl a sample glb; headless Chromium screenshot.
4. **PlayCanvas** — `npm i playcanvas playwright && npx playwright install chromium`; headless Chromium + SwiftShader screenshot.
5. **Needle Engine** — `npm create needle@latest … && npm install && npm run build`; scaffolds a full project then builds a static bundle.
6. **usd_from_gltf** — `docker pull leon/usd-from-gltf`; heaviest (Docker daemon required), but the recommended headless macOS route.

## Explorer needs

Tools that want a richer explorer than the default shell:

- **model-viewer, PlayCanvas, A-Frame (PNG step), Needle** — need a **headless browser** (Puppeteer/Playwright Chromium, or a WebXR-capable browser for Needle's interactive bundle) to visually verify the rendered scene; PlayCanvas additionally needs SwiftShader (`--use-gl=swiftshader`) for GPU-less capture.
- **usd_from_gltf** — needs a **Docker** runtime (daemon) for the headless conversion; optional `usdchecker`/`usdcat` from a Pixar USD build for AR-compat validation + text inspection.
- **Babylon.js (NullEngine)** — needs nothing beyond Node; the default shell suffices.
