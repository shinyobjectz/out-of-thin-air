# A-Frame (ar-vr)

<!-- generated draft — needs validation -->

## Summary
A-Frame is an open-source (MIT) declarative web framework for building 3D/AR/VR (WebXR) scenes as plain HTML markup on top of three.js. Maintained by aframevr; latest 1.8.0 (June 2026). Authors describe scenes with custom HTML entities (`<a-scene>`, `<a-box>`, `<a-sphere>`, components as attributes) — fully deterministic and version-controllable, a perfect fit for OOTA's `html` deliverable. The canonical artifact is a self-contained `.html` file (CDN script tag) that renders in any WebXR/WebGL browser. It can also be driven headlessly via Chrome/Puppeteer to emit a still frame (PNG), but the HTML markup itself is the product.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| A-Frame WebXR (claudedesignskills) | community | no | see repo (MIT-style collection) | https://github.com/freshtechbro/claudedesignskills |
| A-Frame Official Documentation (LLM reference) | official-docs | yes | docs CC / framework MIT | https://aframe.io/docs/1.8.0/introduction/ |
| XR Immersive Developer / XR Developer skills | community | no | per marketplace listing | https://mcpmarket.com/tools/skills/xr-immersive-developer |

Attribution:
- freshtechbro/claudedesignskills — community Claude Code skill collection; includes an A-Frame WebXR skill with a `scene_generator.py` for A-Frame scene boilerplate.
- aframevr — canonical docs for HTML markup, components, and the registry.
- community WebXR skills covering A-Frame, three.js, Babylon.js spatial interactions.

## Toolchains
| Lang | Install | Invoke / Notes |
|------|---------|----------------|
| HTML/JavaScript (browser, any WebXR/WebGL) | No install — CDN `<script src="https://aframe.io/releases/1.8.0/aframe.min.js"></script>` | Primary path. Write declarative HTML; open the `.html` in a browser. This IS the deterministic deliverable. |
| JavaScript/Node (npm) | `npm install --save aframe` | Bundler-based projects: `import AFRAME from 'aframe'`; build with webpack/vite for a self-contained HTML/JS artifact. |
| JavaScript/Node + headless Chromium | `npm install puppeteer` | Headless capture path. Launch Chromium (`headless:'new'` + `--use-gl=angle`), `page.goto(file://scene.html)`, wait for `a-scene` `hasLoaded`, then `page.screenshot` → PNG. Only needed for image deliverable. |

## Artifact kind
`html` — a single self-contained `.html` file is the canonical deliverable.

## Validation
Install / setup:
```bash
mkdir -p /tmp/aframe-smoke && printf '%s' '<!doctype html><html><head><script src="https://aframe.io/releases/1.8.0/aframe.min.js"></script></head><body><a-scene><a-box position="-1 0.5 -3" rotation="0 45 0" color="#4CC3D9"></a-box><a-sphere position="0 1.25 -5" radius="1.25" color="#EF2D5E"></a-sphere><a-sky color="#ECECEC"></a-sky></a-scene></body></html>' > /tmp/aframe-smoke/scene.html
```
Smoke:
```bash
# HTML deliverable: file exists and is valid markup (deterministic, no network needed to author)
test -s /tmp/aframe-smoke/scene.html && grep -q '<a-scene>' /tmp/aframe-smoke/scene.html && echo OK
# Optional image render (headless, needs network for CDN + puppeteer):
# cd /tmp/aframe-smoke && npm i puppeteer && node -e "const p=require('puppeteer');(async()=>{const b=await p.launch({headless:'new',args:['--use-gl=angle','--enable-webgl','--ignore-gpu-blocklist']});const pg=await b.newPage();await pg.setViewport({width:800,height:600});await pg.goto('file:///tmp/aframe-smoke/scene.html');await pg.waitForFunction(()=>document.querySelector('a-scene')&&document.querySelector('a-scene').hasLoaded);await new Promise(r=>setTimeout(r,800));await pg.screenshot({path:'out.png'});await b.close();})()"
```
Expect: `scene.html` is created and prints `OK`. Optional headless step writes `out.png` (~800x600) showing a cyan box and red sphere on a light-gray sky. Headless WebGL canvas capture on macOS may need `--use-gl`/`--ignore-gpu-blocklist` and a render delay to avoid blank frames.

## Wrapper params
- `ar-vr.title` (text) — scene title.
- `ar-vr.box_color` (color) — primitive box color.
- `ar-vr.sphere_color` (color) — primitive sphere color.
- `ar-vr.sky_color` (color) — background sky color.

## Component / explorer notes
A-Frame's unit of authorship is declarative HTML custom elements: `<a-scene>` root plus entities (`<a-entity>`, primitives like `<a-box>`, `<a-sphere>`, `<a-sky>`, `<a-camera>`, `<a-light>`) configured via component attributes (position, rotation, geometry, material, animation). The full entity-component registry is documented per version at aframe.io/docs/1.8.0. Scenes are 100% text/markup — diffable and version-controllable. Custom behavior registers as JS components (`AFRAME.registerComponent`) but pure-markup scenes need zero JS. For OOTA, treat the `.html` file as the component output: a single deterministic file referencing a pinned CDN version (pin 1.8.0, avoid `latest`) for reproducibility. A-Frame is not a CLI tool — there is no native headless renderer; all headless output goes through a browser engine.
