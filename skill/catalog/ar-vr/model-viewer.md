<!-- generated draft — needs validation -->
# model-viewer (ar-vr)

## Summary
Google's `<model-viewer>` is an open-source (Apache-2.0) custom HTML web component
that renders interactive 3D models (glTF/GLB) in any evergreen browser via three.js,
with optional AR handoff. For OOTA the deterministic deliverable is the HTML markup
itself: a single declarative `<model-viewer src="model.glb">` element is
version-controllable, renders headlessly in Chromium, and the component exposes
`toBlob()`/`toDataURL()` plus a `load` event so a headless Chrome driver can
deterministically export a PNG poster (image kind) once the model finishes loading.
No CLI ships for one-off rendering; you drive it through a headless browser
(Puppeteer/Playwright). Primary kind = html; downstreams to image via screenshot.

## Skills
- **No official Anthropic/Claude skill** (none / not official) — As of 2026-06, no
  model-viewer skill in Anthropic's skills repo or community registries
  (VoltAgent/awesome-agent-skills, txtskills). https://github.com/anthropics/skills — license: n/a
- **Official docs site, modelviewer.dev** (docs / official) — Google Inc.; attributes,
  properties, events, editor. https://modelviewer.dev/ (docs at /docs) — license: Apache-2.0
- **google/model-viewer GitHub** (repo / official) — Google Inc.; render-fidelity-tools
  package documents the Puppeteer-based headless screenshot/golden pipeline.
  https://github.com/google/model-viewer — license: Apache-2.0

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JavaScript/HTML (browser) | `npm install @google/model-viewer` (or CDN `<script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/4.0.0/model-viewer.min.js">`) | Author `<model-viewer src="foo.glb" camera-controls auto-rotate>` markup — this IS the deterministic deliverable |
| Node.js (headless Chromium) | `npm install puppeteer @google/model-viewer` | Load the html, await element `load`, then `page.screenshot()` / `element.toBlob()` → deterministic PNG (same as render-fidelity-tools goldens) |
| Python (headless Chromium) | `pip install playwright && python -m playwright install chromium` | `page.goto(file://…)`, `wait_for_function` on `modelViewer.loaded`, `page.screenshot()`. No Python binding; Python only orchestrates the browser |

## Artifact kind
`html` (primary; the version-controllable `<model-viewer>` markup). Downstreams to
`image` via headless-Chromium screenshot of the loaded element.

## Validation
**install:**
```bash
mkdir -p /tmp/mv && cd /tmp/mv && npm init -y >/dev/null 2>&1 && npm install puppeteer >/dev/null 2>&1 && curl -sL -o astronaut.glb https://modelviewer.dev/shared-assets/models/Astronaut.glb
```
**smoke:** write `scene.html` (model-viewer CDN module + pinned `camera-orbit`,
`exposure`, `interaction-prompt="none"`) and `shoot.mjs` (Puppeteer launch, viewport
600x600 @2x, goto file://, `waitForFunction(() => document.getElementById('mv').loaded===true)`,
`el.screenshot({path:'/tmp/mv/out.png'})`), then `node /tmp/mv/shoot.mjs && file /tmp/mv/out.png`.
**expect:** console prints `wrote /tmp/mv/out.png` and `file` reports a PNG image
(1200x1200 px at deviceScaleFactor 2) showing the Astronaut on a dark background.
The standalone `scene.html` is itself the version-controllable html deliverable; the
PNG is the headless-rendered image artifact.

## Wrapper params
- `ar-vr.title` (text) — document title
- `ar-vr.src` (text) — glb/gltf model URL or path
- `ar-vr.camera_orbit` (text) — pinned pose, e.g. `30deg 75deg 4m`
- `ar-vr.exposure` (range) — lighting exposure
- `ar-vr.background` (color) — scene background

## Component / explorer notes
`<model-viewer>` is a Custom Element, not a React/Vue component — works in any
framework or plain HTML once the module script loads. Determinism levers: pin
`camera-orbit`, `camera-target`, `field-of-view`, `exposure` so the frame is
reproducible; set `interaction-prompt="none"` and disable `auto-rotate` to freeze the
pose. The element fires `load`, exposes boolean `.loaded` and async
`.toBlob({mimeType,qualityArgument,idealAspect})` / `.toDataURL()` for poster export.
Environment/lighting (`environment-image`, `skybox-image`, `shadow-intensity`) affect
output and must be pinned for byte-stable renders. Supports glTF 2.0 / GLB; three.js +
PBR under the hood. Wait on `modelViewer.loaded===true` (NOT just DOMContentLoaded —
three.js decode is async). GPU rasterization drift between machines means golden tests
should use perceptual/threshold diffing (mirrors google's render-fidelity-tools, which
needs ImageMagick), not exact-hash. No standalone CLI — the headless-browser harness is
mandatory for any non-interactive render.
