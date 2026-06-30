<!-- generated draft — needs validation -->
# openFrameworks (creative)

## Summary
openFrameworks is a community-developed, cross-platform C++ toolkit for creative coding, built on OpenGL. The core is C++; apps can be driven from JS/WebGL via Emscripten and scripted from Python/Lua/JS through SWIG-based community addons. Its native deliverable is a realtime interactive graphics window. The most portable shareable artifact is an Emscripten WebGL/HTML build (`index.html` + `.wasm` + `.js`), with rendered frames -> PNG/video as the offline output. No official Claude/Anthropic skill or `llms.txt` exists; docs are human-facing on openframeworks.cc. Fully headless smoke on macOS is awkward (needs a GL context), so validation confidence is lower.

## Skills
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| openFrameworks official documentation | official-docs | https://openframeworks.cc/documentation/ | yes | site content; framework MIT | openFrameworks community |
| openFrameworks learning tutorials | official-docs | https://openframeworks.cc/learning/ | yes | CC / site | openFrameworks community |
| openFrameworks GitHub (source + README guides) | repo | https://github.com/openframeworks/openFrameworks | yes | MIT | openframeworks/openFrameworks |
| (none) dedicated Claude SKILL.md / llms.txt | community | https://github.com/openframeworks/openFrameworks | no | n/a | searched; none located as of 2026-06 |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| C++ (native, primary) | `git clone --depth 1 https://github.com/openframeworks/openFrameworks && cd openFrameworks/scripts/osx && ./download_libs.sh` | Generate project with `projectGenerator`; in a project dir run `make && make RunRelease`. Edit `ofApp.cpp` setup()/update()/draw(). |
| JS / WebGL (browser) | `git clone https://github.com/emscripten-core/emsdk && ./emsdk install latest && ./emsdk activate latest`; configure OF per https://openframeworks.cc/setup/emscripten/ | `emmake make` -> outputs `index.html` + `.wasm` + `.js` to serve (the canvas/WebGL artifact). |
| Python | `git clone https://github.com/chaosct/ofxPython` into `openFrameworks/addons/`, add to project via projectGenerator | Embeds CPython inside an OF app, exposes OF draw calls. Not a pip package. |
| Lua / Python / JS (scripting) | `git submodule add https://github.com/danomatika/swig-openframeworks` in a wrapper addon; run included Makefile | Centralized SWIG interface used by ofxLua / ofxPython / ofxJavaScript. Community-maintained. |
| CLI tooling | build projectGenerator commandLine target from https://github.com/openframeworks/projectGenerator | `./projectGenerator -o<OF_ROOT> -p osx myApp` scaffolds a buildable project headlessly. |

## Artifact kind
**html** — the renderable, portable form is the Emscripten WebGL build (`index.html` + `.wasm`), hostable in a canvas/iframe shell. Native C++ apps do not render in the universal shell; offline runs emit PNG frame sequences (image/video) via `ofImage::grabScreen` / FBO saves.

## Validation
- **install:** `git clone --depth 1 https://github.com/openframeworks/openFrameworks && cd openFrameworks/scripts/osx && ./download_libs.sh`
- **smoke:** `cd examples/graphics/graphicsExample && make -j4 && make RunRelease` — then in `ofApp::draw()` add `ofImage img; img.grabScreen(0,0,ofGetWidth(),ofGetHeight()); img.save("out.png");` to produce `bin/data/out.png`.
- **expect:** A native window opens rendering the example; `out.png` written under `bin/data/`. Fully headless on macOS is not natively supported (needs a GL/window context); use the Vulkan renderer or Linux + XVFB for true offline frame dumps. Confidence lower for headless-only environments.

## Wrapper params
Target platform (osx/emscripten/linux), window size (`ofSetWindowShape` / WIDTH/HEIGHT), frame rate (`ofSetFrameRate`), background color, and the user's setup()/update()/draw() body. For headless/offline render: number of frames to dump, FBO resolution, output path/format. For the WebGL path: emsdk version + an HTTP serve port.

## Component / explorer notes
The bare text shell will NOT render a native OF app. Renderable form is the Emscripten WebGL build (`index.html` + `.wasm`), hostable in an iframe canvas. For offline runs, OF emits PNG frame sequences (`ofImage::grabScreen` / FBO saves) that compose into image or video — a canvas-iframe explorer (wasm build) or an image/video viewer (frame dumps) fits better than the plain text shell.
