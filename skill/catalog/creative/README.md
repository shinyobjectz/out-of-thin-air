# creative — Generative art / creative coding (canvas, WebGL)

Tools for algorithmic art, generative sketches, and real-time graphics that render to a canvas, WebGL, or native GL surface.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|------|---------------|------------|----------------------|-----------|--------|----------|-------|
| [p5js](./p5js.md) | html | JS browser (CDN/npm p5), JS Node headless (node-p5), puppeteer | algorithmic-art (Generative p5.js art) | no | ok | yes | yes |
| [processing](./processing.md) | image | Java native (processing-java), JS browser (p5), Node headless (node-p5), puppeteer | [Anthropic p5.js algorithmic-art](https://github.com/anthropics/skills) | yes | ok | yes | yes |
| [openframeworks](./openframeworks.md) | html | C++/OpenGL native, JS/WebGL (Emscripten), Python (ofxPython), Lua/Python/JS (swig) | openFrameworks official docs | yes | ok | yes | yes |
| [threejs](./threejs.md) | html | JS/TS browser (npm/CDN importmap), React/TSX (@react-three/fiber), Python (pythreejs), Node headless (puppeteer) | [three.js official docs](https://threejs.org/docs/) | yes | ok | yes | yes |

## Multi-toolchain notes

- **JS/TS (browser)**: all four tools. p5js and threejs are JS-native; processing and openFrameworks expose JS/WebGL paths.
- **Node headless render**: p5js (node-p5), processing (node-p5), threejs (puppeteer + ANGLE/SwiftShader), openframeworks (Emscripten/WebGL, lower confidence).
- **React/TSX**: threejs only (@react-three/fiber).
- **Python**: openframeworks (ofxPython/swig), threejs (pythreejs in Jupyter).
- **Native (C++/Java)**: openframeworks (C++/OpenGL, canonical), processing (Java via processing-java, canonical but headless-fiddly on macOS).
- **Lua**: openframeworks (swig-openframeworks).

## VALIDATION ORDER

Cheapest / most reliable headless install first:

1. **p5js** — `npm install node-p5`; renders PNG headless on macOS, no display. Most reliable.
2. **processing** — `npm install node-p5` (same path); native processing-java is canonical but headless-fiddly, so validate via node-p5.
3. **threejs** — `npm install three puppeteer`; headless WebGL via ANGLE/SwiftShader, heavier install but reliable.
4. **openframeworks** — clone + `download_libs.sh` + native build; needs GL context, headless unsupported on macOS (Vulkan or Linux+XVFB). Slowest, lowest headless confidence. Validate last.

## EXPLORER NEEDS

- **threejs**: wants a richer explorer than the static artifact shell — interactive WebGL canvas with OrbitControls (3D orbit/pan/zoom). Default scaffold ships a self-animating cube + OrbitControls.
- **openframeworks**: WebGL/Emscripten deliverable benefits from an interactive canvas host; native path needs a real GL window.
- **p5js / processing**: a playable/animating canvas (start/stop, seed reroll, framerate) is nicer than a static image, but the still-PNG artifact suffices for validation.

## Dossiers

- [./p5js.md](./p5js.md)
- [./processing.md](./processing.md)
- [./openframeworks.md](./openframeworks.md)
- [./threejs.md](./threejs.md)
