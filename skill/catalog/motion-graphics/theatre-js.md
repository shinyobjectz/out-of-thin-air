<!-- generated draft — needs validation -->
# Theatre.js (`theatre-js`)

## Summary
Theatre.js is a JavaScript/TypeScript animation library + visual motion-design editor for the web. Architecture splits into a runtime (`@theatre/core`, Apache-2.0) and a browser-only editor (`@theatre/studio`, AGPL-3.0); the editor is design-time only and your shipped/render bundle must include only core. Animation state (keyframes, tweaks, sequences) is authored visually in studio, then EXPORTED as a version-controllable JSON file. That JSON is the deterministic, git-trackable artifact OOTA cares about: core re-runs it identically via `getProject(name, {state: json})`.

Theatre.js does NOT render pixels itself — it drives values (DOM/SVG props, THREE.js objects, or any JS variable) over a timeline via `sheet.sequence` and `onValuesChange` callbacks. To produce a video deliverable you drive a renderer (THREE.js/Canvas/DOM) with core, step the sequence deterministically (`seq.position = frame/fps`), capture each frame, and encode with ffmpeg — all headless via Puppeteer/Playwright + headless Chromium on macOS. `seq.attachAudio()` syncs an audio track for real-time playback (not used in frame-stepped capture; audio is muxed at encode time). For OOTA, the JSON state + a deterministic frame-stepping driver script = reproducible video output. Pure Theatre.js has no built-in headless exporter, so the capture/encode wrapper is custom.

## Skills
| Skill | Type | Official | License | Attribution | URL |
|---|---|---|---|---|---|
| chadpowers-superbowl-theatrejs-cinematics | community | no | check repo (community, unverified) | shyamsridhar123 (via LobeHub skills index) | https://lobehub.com/skills/shyamsridhar123-chadpowers-superbowl-theatrejs-cinematics |
| Theatre.js Official Docs (manual + API reference) | docs | yes | docs CC-style; code Apache-2.0 (@theatre/core) | Theatre.js / Aria Minaei | https://www.theatrejs.com/docs/latest |

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| JavaScript/TypeScript (Node.js >=16 + headless Chromium for capture) | `npm i @theatre/core @theatre/studio @theatre/r3f three && npm i -D puppeteer` | `getProject('Proj',{state}).sheet('Scene')`; `obj=sheet.object('id',{...})`; `obj.onValuesChange(v=>applyToRenderer(v))`; then deterministic capture loop sets `sheet.sequence.position=f/fps` per frame instead of `sequence.play()` (play() is real-time, non-deterministic for capture). |

Notes: Only `@theatre/core` (Apache-2.0) is needed at render time; `@theatre/studio` (AGPL-3.0) is design-time only and MUST be excluded from any shipped/render bundle. `@theatre/r3f` wires Theatre to react-three-fiber. Author visually → export `state.json`.

## Artifact kind
`video` — frame-stepped capture of a renderer driven by core, encoded to mp4/webm via ffmpeg.

## Validation
- **install:** `mkdir tjs && cd tjs && npm init -y && npm i @theatre/core three && npm i -D puppeteer && (command -v ffmpeg || brew install ffmpeg)`
- **smoke:** Headless on macOS: load a minimal HTML that imports `@theatre/core`, creates a project from an inline state JSON, an object with prop `{x}`, and `onValuesChange` writing x to a canvas rect. In Node+Puppeteer launch headless Chromium; for f in 0..30 set `window.__seq.position=f/30`, screenshot `frame_$f.png`; then `ffmpeg -framerate 30 -i frame_%d.png -pix_fmt yuv420p out.mp4`.
- **expect:** `out.mp4` written (~1s, 30 frames) showing the rect animating left→right deterministically; re-running yields byte-identical frames since position is stepped (not wall-clock `play()`).

## Wrapper params
- `motion-graphics.title` (text) — title / project name.
- `motion-graphics.fps` (range) — frames per second for capture.
- `motion-graphics.duration` (text/range) — seconds to capture.
- `motion-graphics.state` (textarea, file-bound to exported `state.json`) — the deterministic Theatre project state.

## Component / explorer notes
Theatre.js is a value-driver, not a renderer — the unit of work is a Sheet of Objects whose props are keyframed over a Sequence. Deterministic artifact = the exported project state JSON (stable, diff-able, git-trackable). Re-run identically with `getProject(name,{state})`. The animated target (THREE.js scene, SVG, DOM) is a separate component the JSON drives via `onValuesChange`. The r3f package wires Theatre to react-three-fiber scene graph. Editing the JSON by hand is possible but it's normally regenerated from the studio editor.

No native headless/video export exists in Theatre.js. Build a wrapper: (1) a render page that constructs the renderer + binds core state, exposing `sheet.sequence` on `window`; (2) a Node driver (Puppeteer/Playwright) that steps `sheet.sequence.position` frame-by-frame (deterministic — avoid `sequence.play()`, which is real-time) and screenshots each frame; (3) ffmpeg to encode PNG frames to mp4/webm and mux any `attachAudio` track. This converts Theatre's interactive runtime into a deterministic headless video pipeline suitable for OOTA. studio (AGPL-3.0) must be excluded from any shipped/render bundle; only `@theatre/core` (Apache-2.0) is needed for playback.
