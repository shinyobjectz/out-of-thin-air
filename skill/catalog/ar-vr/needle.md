<!-- generated draft — needs validation -->
# Needle Engine (ar-vr)

## Summary
Needle Engine is a web-based 3D/AR/VR runtime built on a fork of three.js with WebXR, physics, networking, and animation. Scenes are authored as TypeScript/JS source plus glTF assets and built via Vite into a self-contained static web app (HTML/JS/wasm). The primary deterministic, version-controllable deliverable is an **HTML bundle** that renders a 3D/WebXR experience in any browser; a secondary path exports scenes to glTF/USDZ (model3d). As of v5.0.0 (March 2026) it supports full WebXR AR on iOS via ARKit App Clips. Standalone usage is npm/Vite-driven and the production build is fully headless (Node, no browser).

## Skills
- **Needle Engine AI Skill** — official, open source (GitHub `needle-tools/ai`). https://engine.needle.tools/docs/ai/ — install `npx skills add needle-tools/ai`; auto-installs via the Vite plugin when using `@needle-tools/engine`. Curated docs + API refs; supports Claude Code, Cursor, Copilot, Codex, Gemini CLI, Windsurf. Attribution: Needle Tools GmbH.
- **Needle MCP Server** — official, open source. https://engine.needle.tools/docs/ai/ — connects AI tools to running 3D projects via the Needle Inspector: semantic doc search, live scene inspection, natural-language object editing, debugging.
- **llms.txt / llms-full.txt** — official docs. https://cloud.needle.tools/llms.txt (full: https://cloud.needle.tools/llms-full.txt). LLM-ready docs.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| TypeScript/JS (primary, headless) | `npm create needle@latest` (scaffolds Vite+TS+Needle), then `npm install` | dev `npm run dev`; build `npm run build` -> static `dist/` |
| C# (Unity editor) | Unity Package Manager `com.needle.engine` | export GameObjects/scenes to glTF on save (GUI, not headless) |
| Python (Blender add-on) | install Needle Engine add-on in Blender | export scenes to web-optimized glTF (GUI, not headless) |
| CLI (Node) | `npm i -g needle-cloud` | automate asset upload + glTF compression as a build/batch step |

## Artifact kind
**html** — the deliverable is an interactive web app. Deterministic source = TS/JS + glTF assets; renderable artifact = build output `dist/index.html` bundle. A secondary export path produces model3d (glTF/USDZ) when only a 3D asset is wanted. True single-frame headless render to image/video is NOT first-class; OOTA's "renders headlessly to a file" is satisfied at the build step (emitting the HTML bundle), not via offscreen frame capture.

## Validation
- **install**: `npm create needle@latest oota-needle-smoke -- --template three` then `cd oota-needle-smoke && npm install`
- **smoke**: `npm run build` (Vite production build, headless on macOS — Node only, no browser/display)
- **expect**: Build completes and emits a static bundle at `dist/` containing `index.html` plus hashed JS/wasm assets; opening `dist/index.html` in a WebXR-capable browser renders the 3D scene. `dist/` is the deterministic, version-controllable HTML deliverable.

## Wrapper params
- `ar-vr.title` (text) — page/experience title.
- `ar-vr.scene` (textarea, bound to `src/main.ts`) — Needle/three scene source.
- Pin `@needle-tools/engine` and `three` versions in `package.json` for determinism (engine forks three; let the template pick the matching three version).

## Component / explorer notes
Wrap the standalone npm/Vite path (`npm create needle` -> `npm run build`) — fully scriptable and headless, ideal for CI/version control. Skip Unity/Blender editor integrations for an automated pipeline (GUI required). The official AI skill auto-installs via the Vite plugin, so a wrapper using `@needle-tools/engine` gets agent context for free. Commit `src/` + assets, treat `dist/` as the build artifact (do not commit). For pixel-output kinds you'd need an extra headless-browser capture pass (Playwright/puppeteer), non-trivial for WebXR. Deploy: static bundle drops onto any host or Needle Cloud.
