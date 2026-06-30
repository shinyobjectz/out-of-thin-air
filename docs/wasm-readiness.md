# WASM-Readiness: Render Libraries in the Out-of-Thin-Air Shell

## Intro

Out-of-Thin-Air (OOTA) renders inside the **Workbooks WASM substrate**. The
substrate's compile/runtime facts that gate every tool below:

- **Toolchains:** clang C/C++ ✓, Zig ✓, **Rust ✗ (BLOCKED in-sandbox)**.
- **Language palette:** Python (Pyodide), Ruby (ruby.wasm), Lua, Go (wasm),
  JavaScript.
- **JS engines:** **StarlingMonkey** and **QuickBEAM/qjs** — bare engines with
  **no DOM / no Canvas / no WebGL** unless run in OOTA's real browser surface.
- **Component model** for wiring wasm modules into the shell's render kinds
  (`html`, `svg`, `image`, `pdf`, `audio`, `model3d`, `text`).

**Goal:** get every render library into wasm running inside the shell — either
js-native (runs on the browser's own JS engine), a prebuilt `.wasm` artifact, a
Pyodide wheel, or a clang/Zig clean-room compile. Rust-only libs are the
structural gap.

A key distinction throughout: most "js-native" tools need the **browser's** DOM /
Canvas / WebGL — they run in OOTA's real browser shell, **not** in a headless
qjs/QuickBEAM engine. That is a non-issue because OOTA renders in-browser.

---

## SUMMARY

**128 tools probed.**

### By tier

| Tier | Count |
|---|---|
| js-native | 65 |
| prebuilt-wasm | 28 |
| python-pyodide | 16 |
| hard-impractical | 11 |
| compile-c-cpp | 5 |
| rust-blocked | 2 |
| compile-go | 1 |

### By browser verdict

| Verdict | Count |
|---|---|
| runs-now | 75 |
| port-available | 31 |
| needs-prebuilt | 7 |
| compilable | 3 |
| needs-env | 2 |
| impractical | 10 |

**75 run now** (drop-in today). **10 impractical** (proprietary or
unportable-toolchain). The remaining 43 are a spectrum of porting effort
(prebuilt artifact to fetch → Pyodide micropip → C/C++ clang build →
external Rust prebuild).

---

## MATRIX (grouped by category)

Columns: tool | tier | wasm artifact (link) | effort | verdict | probe result.

### presentations

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| marp | js-native | [marp-core 4.3.0](https://registry.npmjs.org/@marp-team/marp-core/-/marp-core-4.3.0.tgz) | none | runs-now | marp-core 4.3.0 + marpit 3.2.1; pure JS markdown-it, no native deps |
| slidev | js-native | — | medium | needs-prebuilt | @slidev/cli 52.16.0; Vite/Vue/Rollup compile is Node-only — must pre-build to static HTML; @slidev/parser parses only |
| reveal.js | js-native | [reveal.js 6.0.1](https://registry.npmjs.org/reveal.js/-/reveal.js-6.0.1.tgz) | none | runs-now | v6.0.1, plain JS/CSS, runs as-is in html kind |
| spectacle | js-native | [spectacle](https://www.npmjs.com/package/spectacle) | low | runs-now | v10.2.3; all deps pure-JS; needs react/react-dom |
| quarto | prebuilt-wasm | [pandoc-wasm 1.1.0](https://www.npmjs.com/package/pandoc-wasm) | medium | port-available | pandoc-wasm covers Pandoc conversion only; full quarto CLI (Deno+Lua filters+shortcodes) not ported |
| deckary | hard-impractical | — | blocked | impractical | npm 404; closed-source SaaS PowerPoint add-in, no render lib |

### video

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| remotion | js-native | — | low | runs-now | v4.0.484; @remotion/webcodecs uses browser WebCodecs API; native render pipeline NOT wasm-portable |
| hyperframes | js-native | [@ffmpeg/core 0.12.10](https://registry.npmjs.org/@ffmpeg/core/-/core-0.12.10.tgz) | none | runs-now | compositions are HTML/CSS/JS; only final encode needs ffmpeg.wasm |
| motion-canvas | js-native | — | none | runs-now | @motion-canvas/core 3.17.2, pure JS; needs real Canvas/WebGL |
| revideo | js-native | [@revideo/core 0.10.4](https://registry.npmjs.org/@revideo/core/-/core-0.10.4.tgz) | low | runs-now | 0.10.4; Canvas2D/WebGL render; ffmpeg.wasm for export |
| manim | python-pyodide | [manim-web 0.1.8](https://pypi.org/project/manim-web/) | medium | port-available | manim_web wheel pure-python, pyodide-loadable; partial fork — no Pango/Text, SVG frames not encoded video |

### audio

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| tts-local | prebuilt-wasm | [kokoro-js](https://www.npmjs.com/package/kokoro-js) | low | port-available | kokoro-js 1.2.1, sherpa-onnx 1.13.3, piper-wasm 1.0.0; onnxruntime-web WASM TTS |

### diagrams

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| mermaid | js-native | [mermaid 11.16.0](https://registry.npmjs.org/mermaid/-/mermaid-11.16.0.tgz) | none | runs-now | 11.16.0, d3+DOMPurify; needs browser DOM (getBBox), svg kind |
| d2 | prebuilt-wasm | [@terrastruct/d2](https://www.npmjs.com/package/@terrastruct/d2) | low | runs-now | 0.1.33, ~60MB tarball with bundled d2.wasm worker → SVG |
| plantuml | prebuilt-wasm | [plantuml.js](https://github.com/plantuml/plantuml.js) / [plantuml-wasm](https://plantuml-wasm.pages.dev/) | low | port-available | not on npm; TeaVM Java→JS + Graphviz.wasm (or CheerpJ deploy, HTTP 200); vendor from GitHub |
| structurizr | js-native | [structurizr-typescript 1.0.15](https://registry.npmjs.org/structurizr-typescript/-/structurizr-typescript-1.0.15.tgz) | low | runs-now | pure JS (crypto-js dep); builds C4 model but no SVG paint — pair with elkjs / @hpcc-js/wasm Graphviz |
| python-diagrams | python-pyodide | [@hpcc-js/wasm 2.34.2](https://www.npmjs.com/package/@hpcc-js/wasm) | medium | needs-env | Graphviz WASM renders valid SVG; diagrams pure-python but shells out to `dot` — intercept to DOT→@hpcc-js/wasm, mount icon PNGs |
| excalidraw | js-native | — | low | runs-now | 0.18.1; React component, needs real DOM (no SSR) |
| chart-xkcd | js-native | — | none | runs-now | 2.0.12, zero deps, D3 inlined → SVG |
| roughviz | js-native | [rough-viz 2.0.5](https://registry.npmjs.org/rough-viz/-/rough-viz-2.0.5.tgz) | none | runs-now | 2.0.5; d3 + roughjs, pure JS → sketchy SVG |

### cad

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| cadquery | python-pyodide | [OCP.wasm](https://github.com/yeicor/OCP.wasm) / opencascade.js 1.1.1 | medium | port-available | build123d is proven runner on same OCP wrapper; cadquery "mostly works", no published bundle; manual Pyodide bootstrap |
| openscad | prebuilt-wasm | [openscad-wasm 0.0.4](https://registry.npmjs.org/openscad-wasm/-/openscad-wasm-0.0.4.tgz) | low | port-available | Emscripten module, .scad→STL→model3d; official port powers openscad-playground |
| freecad | prebuilt-wasm | [occt-import-js 0.0.23](https://www.npmjs.com/package/occt-import-js) | medium | port-available | FreeCAD app has no wasm port; only OCCT kernel — render FreeCAD-exported STEP/IGES via occt-import-js + three.js |

### electronics

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| skidl | python-pyodide | [skidl 2.2.3](https://pypi.org/project/skidl/) | medium | port-available | sdist-only pure-python; core deps micropip-installable; graphviz/kinet2pcb render paths blocked in Pyodide (netlist text only) |
| kicad-api | js-native | [kicanvas.js](https://kicanvas.org/kicanvas/kicanvas.js) | none | runs-now | hosted JS bundle (not npm), HTTP 200; parses .kicad_sch/.kicad_pcb → WebGL; viewer not full KiCad API |

### documents

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| typst | prebuilt-wasm | [@myriaddreamin/typst.ts](https://www.npmjs.com/package/@myriaddreamin/typst.ts) | low | port-available | web-compiler + renderer 0.7.0 wasm; .typ→SVG/canvas in browser |
| latex | prebuilt-wasm | [swiftlatexpdftex.wasm](https://www.swiftlatex.com/swiftlatexpdftex.wasm) | medium | port-available | SwiftLaTeX pdfTeX, content-type application/wasm, HTTP 200; needs self-hosted TeX Live package cache + worker JS |
| context | js-native | — | none | runs-now | marked 18.0.5 pure-JS zero-dep markdown → html |
| basil-js | hard-impractical | — | blocked | impractical | requires Adobe InDesign + ExtendScript host; npm "basil.js" is unrelated localstorage lib |

### creative

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| p5js | js-native | — | none | runs-now | p5 2.3.0, pure JS → canvas |
| processing | js-native | [p5 2.3.0](https://registry.npmjs.org/p5/-/p5-2.3.0.tgz) | none | runs-now | Processing-proper is Java; canonical browser path is p5.js |
| threejs | js-native | [three 0.185.0](https://registry.npmjs.org/three/-/three-0.185.0.tgz) | none | runs-now | 0.185.0, pure JS, native WebGL/WebGPU |
| threejs-headless | js-native | [three 0.185.0](https://registry.npmjs.org/three/-/three-0.185.0.tgz) | none | runs-now | stock three.js ESM → model3d canvas |
| openframeworks | compile-c-cpp | [OF Emscripten](https://openframeworks.cc/setup/emscripten/) | high | compilable | emcc NOT in sandbox; must compile whole C++ framework; GL backend needs browser WebGL canvas |

### music

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| sonic-pi | prebuilt-wasm | [samaaron/supersonic](https://github.com/samaaron/supersonic) | medium | port-available | scsynth→AudioWorklet (needs SharedArrayBuffer/COOP-COEP); Ruby DSL layer must be reimplemented; npm "supersonic" is unrelated |
| tone-js | js-native | [tone 15.1.22](https://registry.npmjs.org/tone/-/tone-15.1.22.tgz) | none | runs-now | 15.1.22, pure JS over Web Audio API |
| tidal-cycles | js-native | [@strudel/web](https://www.npmjs.com/package/@strudel/web) | none | runs-now | @strudel/web 1.3.0 ports Tidal pattern lang to JS + Web Audio |
| supercollider | prebuilt-wasm | [scsynth-wasm-builds](https://github.com/rd--/scsynth-wasm-builds) | medium | port-available | scsynth.wasm ~1.94MB, HTTP 200; server only, no sclang — drive via OSC; needs AudioWorklet+SAB |
| alda | compile-go | [alda.wasm](https://alda.io/assets/wasm/alda.wasm) | low | runs-now | Go wasm parses Alda→OSC/MIDI (HTTP 200); no synth — route to JS soundfont synth |

### notation

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| lilypond | hard-impractical | — | blocked | impractical | engine needs GNU Guile (Scheme VM+GC+JIT)+Python+Pango+Ghostscript, none wasm-ported; one community attempt stalled. Alt: Verovio wasm (different syntax) |

### fiction

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| ink | js-native | [inkjs 2.4.0](https://registry.npmjs.org/inkjs/-/inkjs-2.4.0.tgz) | none | runs-now | 2.4.0, zero deps; Compiler+Story load & instantiate in node — runs in qjs |
| twine | js-native | [extwee](https://www.npmjs.com/package/extwee) | none | runs-now | extwee 2.3.18 compiles Twee→standalone HTML; story formats are browser JS |
| choicescript | js-native | [choicescript 1.2.0](https://registry.npmjs.org/choicescript/-/choicescript-1.2.0.tgz) | none | runs-now | 1.2.0, pure JS, no native deps |
| renpy | prebuilt-wasm | [renpyweb](https://github.com/renpy/renpyweb) | medium | port-available | Build>Web Emscripten target → index.html+.wasm+data on canvas; whole-engine bundle, not per-kind renderer |

### games

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| pico8 | hard-impractical | — | blocked | impractical | npm 404; proprietary Lexaloffle; wasm only from paid export. Open alt: TIC-80 |
| tic80 | prebuilt-wasm | [TIC-80](https://github.com/nesbox/TIC-80) | low | port-available | tic80.com/play live (HTTP 200); no stable standalone .wasm — build via emscripten or extract from site; C source clang-compilable |
| love2d | prebuilt-wasm | [love.js 11.4.1](https://registry.npmjs.org/love.js/-/love.js-11.4.1.tgz) | low | port-available | love.js 11.4.1 emits love.wasm+game.js; Lua 5.1 (no LuaJIT), WebGL canvas in iframe |
| godot | prebuilt-wasm | [godot.editor.wasm](https://editor.godotengine.org/releases/latest/godot.editor.wasm) | low | port-available | HTTP 200, ~45MB, application/wasm; WebGL2 canvas, needs COOP/COEP for threads |
| raylib | compile-c-cpp | [raylib 5.5 wasm](https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_webassembly.zip) | medium | port-available | prebuilt libraylib (HTTP 200); needs emcc (NOT in sandbox) + WebGL; bare clang/wasmtime can't render GL |
| pyxel | python-pyodide | [pyxel.js](https://cdn.jsdelivr.net/gh/kitao/pyxel/wasm/pyxel.js) | none | runs-now | pyxel 2.9.6; official wasm loader HTTP 200; runs under Pyodide → canvas |
| phaser | js-native | [phaser 4.2.0](https://registry.npmjs.org/phaser/-/phaser-4.2.0.tgz) | none | runs-now | 4.2.0, pure JS WebGL2/Canvas2D |
| kaplay | js-native | — | none | runs-now | 3001.0.19, pure JS ESM/CJS → WebGL/Canvas2D |
| bevy | rust-blocked | — | blocked | needs-prebuilt | Rust→wasm BLOCKED in sandbox; no prebuilt port (bespoke per-app .wasm); needs WebGPU+GPU |
| defold | hard-impractical | — | blocked | needs-prebuilt | no reusable lib; bob.jar Emscripten pipeline produces per-game .wasm only |
| arcade | python-pyodide | [arcade-web](https://github.com/pythonarcade/arcade-web) | blocked | needs-prebuilt | mainline needs pyglet GL window + pymunk C-ext (no Pyodide backend); arcade-web port pre-alpha, not on PyPI |

### typography

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| fontparts | python-pyodide | [fontParts](https://pypi.org/project/fontParts/) | low | port-available | pure-python wheel; booleanOperations dep needs pyclipper (C-ext) Pyodide wheel for boolean-ops; core works |
| metafont | compile-c-cpp | — | high | compilable | no prebuilt mf wasm; web2js/SwiftLaTeX cover only TeX/pdfTeX; build web2c→C then clang→wasm |

### textiles

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| turtlestitch | js-native | [turtlestitch](https://github.com/backface/turtlestitch) | none | runs-now | live (HTTP 200), Snap!+Three.js, SVG/canvas |
| knitout | js-native | — | none | runs-now | knitout-live-visualizer pure client JS/HTML5 canvas, no wasm/build tooling |

### generative-text

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| tracery | js-native | [tracery-grammar 2.8.4](https://registry.npmjs.org/tracery-grammar/-/tracery-grammar-2.8.4.tgz) | none | runs-now | 2.8.4; createGrammar+flatten succeeded → text kind |

### motion-graphics

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| lottie | prebuilt-wasm | [@lottiefiles/dotlottie-web 0.75.0](https://registry.npmjs.org/@lottiefiles/dotlottie-web/-/dotlottie-web-0.75.0.tgz) | low | runs-now | tarball contains dotlottie-player.wasm (ThorVG) + webgl/webgpu; lottie-web 5.13.0 JS fallback |
| gsap | js-native | — | none | runs-now | 3.15.0, pure JS, animates DOM/CSS/SVG/canvas |
| anime-js | js-native | [animejs 4.5.0](https://registry.npmjs.org/animejs/-/animejs-4.5.0.tgz) | none | runs-now | 4.5.0 pure ESM, DOM/SVG/CSS |
| theatre-js | js-native | — | none | runs-now | @theatre/core 0.7.2, pure TS/JS |
| svg-smil | js-native | — | none | runs-now | plain SMIL markup; browser native SVG engine plays it, svg kind |

### graphic-design

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| satori | js-native | [satori](https://www.npmjs.com/package/satori) | none | runs-now | imports cleanly; pure JS + yoga wasm → SVG |
| drawbot | hard-impractical | [canvaskit-wasm](https://www.npmjs.com/package/canvaskit-wasm) (Skia backend only) | blocked | impractical | canonical drawbot binds Apple PyObjC/CoreText/Quartz (macOS); skia fork needs skia-python (not in pyodide) |
| svg-js | js-native | — | none | runs-now | @svgdotjs/svg.js 3.2.5, pure JS DOM SVG |
| cairo | prebuilt-wasm | [cairo-wasm](https://github.com/cairo-wasm) / [Cairo.wasm](https://github.com/Ckimchris/Cairo.wasm) | medium | port-available | no npm pkg (404); GitHub source/build configs only; pulls pixman/freetype/fontconfig — build step required |
| paper-js | js-native | [paper 0.12.18](https://registry.npmjs.org/paper/-/paper-0.12.18.tgz) | none | runs-now | 0.12.18, browser build maps node/jsdom to false |
| nannou | rust-blocked | — | blocked | needs-prebuilt | Rust framework, no npm/.wasm; sandbox Rust→wasm BLOCKED; web target experimental, per-sketch compile |

### data-visualization

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| vega-lite | js-native | — | none | runs-now | vega-lite 6.4.3 + vega 6.2.0 + vega-embed 7.1.0, pure JS → SVG/Canvas |
| observable-plot | js-native | — | none | runs-now | @observablehq/plot 0.6.17, d3 deps, pure ESM → SVG/HTML |
| matplotlib | python-pyodide | [matplotlib wasm wheel](https://cdn.jsdelivr.net/pyodide/v0.27.0/full/matplotlib-3.8.4-cp312-cp312-pyodide_2024_0_wasm32.whl) | low | runs-now | bundled in Pyodide; Agg savefig PNG/SVG or interactive HTML5 backend |
| ggplot2 | prebuilt-wasm | [ggplot2_3.5.1.tgz](https://repo.r-wasm.org/bin/emscripten/contrib/4.4/ggplot2_3.5.1.tgz) | low | port-available | webR 0.2.0; ggplot2 binary 4.2MB HTTP 200; R compiled to wasm ~30MB; SVG device |
| gnuplot | prebuilt-wasm | [gnuplot-wasm 0.1.0](https://registry.npmjs.org/gnuplot-wasm/-/gnuplot-wasm-0.1.0.tgz) | low | port-available | v0.1.0 ~2MB, `set terminal svg` → svg; old, may need emscripten rebuild |
| plotly | js-native | — | low | runs-now | plotly.js 3.6.0, pure JS (D3+regl); WebGL traces need real GPU; needs browser DOM |
| echarts | js-native | [echarts](https://www.npmjs.com/package/echarts) | low | runs-now | headless SSR svg render confirmed (renderToSVGString, no DOM/canvas) |

### maps-geo

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| maplibre-gl | js-native | — | none | runs-now | 5.24.0; WebGL canvas, needs real browser GL |
| mapbox-gl | js-native | — | none | runs-now | 3.25.0; proprietary license + access token; WebGL2, needs browser DOM |
| deck.gl | js-native | — | none | runs-now | 9.3.5, pure JS @deck.gl/@luma.gl; WebGL2 |
| kepler.gl | js-native | — | medium | runs-now | 3.3.0-alpha.1; heavy React18+Redux+deck.gl+MapLibre; needs real DOM+WebGL |
| leaflet | js-native | — | none | runs-now | 1.9.4, pure JS, DOM/Canvas/SVG |
| folium | python-pyodide | folium pure-py wheel + [Leaflet](https://unpkg.com/leaflet) | low | runs-now | folium 0.20.0 pure-python; get_root().render()→HTML, Leaflet draws |
| osmnx | python-pyodide | [@hpcc-js/wasm + Pyodide geo stack](https://pyodide.org/en/stable/usage/packages-in-pyodide.html) | low | port-available | osmnx 2.1.0 pure-python; geopandas/shapely/networkx/matplotlib prebuilt; live OSM/Overpass CORS-gated — use prefetched data |
| prettymapp | python-pyodide | [Pyodide geo stack](https://cdn.jsdelivr.net/pyodide/v0.27.0/full/) | medium | needs-env | version-pin conflicts (prettymapp 0.6.0 wants matplotlib>=3.10.8 vs Pyodide 3.8.4); needs micropip override + pyodide-http |

### 3d-shaders

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| blender | hard-impractical | — | blocked | impractical | multi-MLOC C++ desktop app; Cycles/EEVEE need GPU APIs; no wasm port. Use three.js + exported glTF |
| openusd | prebuilt-wasm | [usd-viewer](https://github.com/needle-tools/usd-viewer) / [three-usdz-loader 1.0.9](https://registry.npmjs.org/three-usdz-loader/-/three-usdz-loader-1.0.9.tgz) | low | port-available | three-usdz-loader 1.0.9 on npm; assemble three.js + USD wasm (multi-MB) yourself |
| glslviewer | js-native | [glslCanvas](https://www.npmjs.com/package/glslCanvas) | low | runs-now | glslCanvas 0.2.6 JS runtime on WebGL2 canvas |
| shadertoy | js-native | [shadertoy-react 1.1.2](https://registry.npmjs.org/shadertoy-react/-/shadertoy-react-1.1.2.tgz) | none | runs-now | 1.1.2 pure-JS WebGL shim |
| povray | compile-c-cpp | — | high | needs-prebuilt | no port; large C++ + Boost + POSIX-thread SMP; emscripten build needs Boost+pthreads/SAB+FS shim |

### web-ui-prototypes

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| tldraw | js-native | — | none | runs-now | 5.1.1; React lib, needs real DOM+react-dom |
| storybook | js-native | — | medium | needs-prebuilt | 10.4.6; runtime preview is browser JS but stories need Node Vite/webpack build — consume prebuilt static export |
| playwright | hard-impractical | — | none | impractical | not a renderer; Node/Python automation spawning native browsers over CDP |
| frontend-design | js-native | — | none | runs-now | generated HTML/CSS → html kind; JS via QuickBEAM |

### image-processing

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| imagemagick | prebuilt-wasm | [@imagemagick/magick-wasm 0.0.41](https://registry.npmjs.org/@imagemagick/magick-wasm/-/magick-wasm-0.0.41.tgz) | low | runs-now | 0.0.41; initializeImageMagick → read/convert/resize → image kind |
| gmic | compile-c-cpp | [gmic.js](https://github.com/fta2012/gmic.js) (old PoC) | high | compilable | no maintained artifact; compile libgmic with emscripten (threading/SIMD/fftw/zlib) |
| sharp | prebuilt-wasm | [wasm-vips 0.0.18](https://registry.npmjs.org/wasm-vips/-/wasm-vips-0.0.18.tgz) | low | port-available | sharp N-API addon not wasm; target wasm-vips (same libvips); SIMD+threads need COOP/COEP |
| pillow | python-pyodide | [pillow wasm wheel](https://cdn.jsdelivr.net/pyodide/v0.27.0/full/pillow-10.2.0-cp312-cp312-pyodide_2024_0_wasm32.whl) | none | runs-now | prebuilt in Pyodide; `from PIL import Image` works |
| libvips | prebuilt-wasm | [wasm-vips](https://www.npmjs.com/package/wasm-vips) | low | runs-now | 0.0.18, HTTP 200; threaded build needs SAB (COOP/COEP); single-threaded fallback |
| gegl | hard-impractical | — | blocked | impractical | depends on GLib/GObject/GIO + babl; GObject type system + main loop don't port; no port exists |

### infographics-posters

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| drawsvg | python-pyodide | [drawsvg 2.4.1](https://pypi.org/project/drawsvg/) | low | port-available | pure-python wheel; micropip → d.as_svg(); raster/MP4 extras native (cairoSVG) unavailable |
| p5-riso | js-native | [p5](https://www.npmjs.com/package/p5) + [p5.riso](https://github.com/antiboredom/p5.riso) | none | runs-now | p5 2.3.0 + riso.js (GitHub-hosted), pure JS → canvas |

### social-formats

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| vercel-og | prebuilt-wasm | [@resvg/resvg-wasm 2.6.2](https://registry.npmjs.org/@resvg/resvg-wasm/-/resvg-wasm-2.6.2.tgz) | low | runs-now | satori (JSX→SVG via yoga-wasm) + resvg-wasm 2.6.2 (SVG→PNG); image kind |
| resvg-js | prebuilt-wasm | [@resvg/resvg-wasm 2.6.2](https://www.npmjs.com/package/@resvg/resvg-wasm) | none | runs-now | 2.6.2 ~2.5MB with index_bg.wasm; initWasm → render().asPng() |
| open-carrusel | js-native | — | none | runs-now | slide HTML/CSS native; replace Puppeteer export with canvas/Blitz capture |

### ar-vr

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| a-frame | js-native | [aframe 1.8.0](https://registry.npmjs.org/aframe/-/aframe-1.8.0.tgz) | none | runs-now | 1.8.0, three.js WebXR; needs browser WebGL/WebXR |
| model-viewer | js-native | — | none | runs-now | @google/model-viewer 4.3.1, three.js+lit+WebGL; model3d kind |
| usd-from-gltf | prebuilt-wasm | [@needle-tools/usd](https://www.npmjs.com/package/@needle-tools/usd) | medium | port-available | converter (Google C++) not on npm/no wasm; @needle-tools/usd is proprietary (license); convert glTF→USDZ offline |
| needle | js-native | [@needle-tools/engine](https://www.npmjs.com/package/@needle-tools/engine) | low | runs-now | 5.1.2, TS on three.js; needs browser canvas/WebGL |
| playcanvas | js-native | — | none | runs-now | 2.20.3, pure JS; optional Ammo/Draco wasm side-modules prebuilt |
| babylon-js | js-native | [@babylonjs/core](https://www.npmjs.com/package/@babylonjs/core) | none | runs-now | 9.14.0; WebGL2/WebGPU canvas |

### business-documents

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| typst-invoice | prebuilt-wasm | [typst-ts-renderer](https://www.npmjs.com/package/@myriaddreamin/typst-ts-renderer) | low | port-available | typst.ts 0.7.0; web-compiler+renderer wasm; .typ→SVG/PDF |
| reportlab | python-pyodide | reportlab-5.0.0 pure-py wheel + [Pyodide Pillow](https://pyodide.org/en/stable/usage/packages-in-pyodide.html) | low | port-available | pure-python (no .so); not in Pyodide prebuilt list — micropip; C accel extras unavailable, pure fallbacks cover core PDF |
| rendercv | prebuilt-wasm | [typst-ts-web-compiler 0.7.0](https://registry.npmjs.org/@myriaddreamin/typst-ts-web-compiler/-/typst-ts-web-compiler-0.7.0.tgz) | medium | port-available | two-stage: rendercv YAML→Typst in Pyodide, then Typst wasm compiler → PDF; supply fonts to VFS |
| json-resume | js-native | — | none | runs-now | jsonresume-theme render() → full HTML; PDF export (Puppeteer) skipped — html kind covers it |
| segno | python-pyodide | [segno 1.6.6](https://pypi.org/project/segno/) | none | runs-now | pure-python no deps; micropip → make().save(svg) |
| python-barcode | python-pyodide | [python-barcode 0.16.1](https://pypi.org/project/python-barcode/) | low | port-available | pure-python; SVGWriter default (no deps); PNG needs Pillow (in Pyodide) |
| zpl-labelary | prebuilt-wasm | [zpl-renderer-js 3.4.0](https://www.npmjs.com/package/zpl-renderer-js) | low | runs-now | 3.4.0 ~28MB wasm inlined; render(zpl)→PNG in worker → image |
| weasyprint | hard-impractical | — | blocked | impractical | runtime dlopen of native libpango/harfbuzz/fontconfig + Pillow C-ext; not in Pyodide, no port |

### advertising-creative

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| mjml | js-native | [mjml-browser](https://www.npmjs.com/package/mjml-browser) | none | runs-now | mjml-browser 5.4.0; mjml2html resolves (html 3941 chars, 0 errors) |
| react-email | js-native | [@react-email/render 2.0.9](https://registry.npmjs.org/@react-email/render/-/render-2.0.9.tgz) | low | runs-now | 2.0.9, pure-JS deps; renderToStaticMarkup → html |
| maizzle | js-native | [@maizzle/framework](https://www.npmjs.com/package/@maizzle/framework) + [@tailwindcss/oxide-wasm](https://www.npmjs.com/package/@tailwindcss/oxide-wasm) | medium | port-available | v6.0.3 render() pure JS but Tailwind v4 oxide is native Rust napi — swap oxide-wasm or precompile CSS |
| amphtml-ads | js-native | [amp4ads-v0.js](https://cdn.ampproject.org/amp4ads-v0.js) | none | runs-now | AMP CDN-only (not npm), HTTP 200; browser-native JS, needs real DOM |
| htmlcsstoimage | hard-impractical | [html-to-image](https://registry.npmjs.org/html-to-image/-/html-to-image-1.11.13.tgz) (alt) | blocked | impractical | closed SaaS = server headless Chromium; substitute html-to-image/html2canvas on the shell's own DOM |

### comics-illustration

| tool | tier | wasm artifact | effort | verdict | probe |
|---|---|---|---|---|---|
| comicgen | js-native | [comicgen 1.9.9](https://www.npmjs.com/package/comicgen) | none | runs-now | 1.9.9, zero .wasm; returns assembled SVG; host character layer assets offline |
| rough-js | js-native | — | none | runs-now | roughjs 4.6.6, pure JS → svg/canvas |
| balloon-css | js-native | [balloon-css 1.2.0](https://registry.npmjs.org/balloon-css/-/balloon-css-1.2.0.tgz) | none | runs-now | 1.2.0 pure CSS, zero deps, data-balloon attrs |

---

## QUICK WINS (build order)

### Tier 0 — drop-in today, zero effort (runs-now / effort none)

Pure-JS or already-prebuilt-wasm, no build step. Wire straight into a render kind:

- **Markup/SVG/text:** context (marked), mermaid, structurizr, chart-xkcd, roughviz,
  excalidraw, svg-js, svg-smil, comicgen, rough-js, balloon-css, tracery, frontend-design.
- **Presentations:** marp, reveal.js.
- **Charts:** vega-lite, observable-plot.
- **Motion:** gsap, anime-js, theatre-js.
- **Canvas/WebGL (browser shell):** p5js, processing, p5-riso, threejs, threejs-headless,
  motion-canvas, phaser, kaplay, glslviewer, shadertoy, turtlestitch, knitout, paper-js.
- **3D/AR-VR:** a-frame, model-viewer, playcanvas, babylon-js.
- **Maps:** maplibre-gl, mapbox-gl (token), deck.gl, leaflet.
- **Fiction:** ink, twine, choicescript.
- **Email/ads:** mjml, amphtml-ads.
- **Prebuilt wasm, runs-now:** resvg-js, libvips, imagemagick, lottie, zpl-labelary, d2.
- **Pyodide, runs-now:** pillow, matplotlib, folium, segno, pyxel.
- **Editors:** kicad-api (kicanvas).

### Tier 1 — low-effort wires (effort low, runs-now/port-available)

- spectacle, revideo, hyperframes (+ffmpeg.wasm), remotion (WebCodecs), echarts (SSR),
  json-resume, react-email, satori/vercel-og pipeline.
- Prebuilt-wasm fetch+host: typst, typst-invoice, openusd, openscad, gnuplot, ggplot2 (webR),
  sharp (wasm-vips), tts-local (kokoro-js), tic80, love2d, godot.
- Pyodide micropip: drawsvg, python-barcode, reportlab, osmnx, fontparts, skidl (netlist).

### Tier 2 — medium (build/two-stage)

slidev (pre-build), storybook (static export), quarto (pandoc-wasm), latex (SwiftLaTeX +
TeX Live cache), plantuml (TeaVM vendor), cairo (emscripten build), sonic-pi/supercollider
(AudioWorklet+SAB), manim (manim-web), cadquery/freecad (OCP.wasm), renpy (Web export),
rendercv, maizzle (oxide-wasm), usd-from-gltf (offline convert), python-diagrams/prettymapp
(needs-env wiring).

### Tier 3 — heavy compile (C/C++ via emscripten; emcc not yet in sandbox)

raylib, openframeworks, metafont, gmic, povray. clang is present; **emcc must be added** for
the WebGL-canvas targets (raylib, openframeworks).

---

## GAPS

### rust-blocked (Rust→wasm BLOCKED in sandbox)

| tool | escape hatch |
|---|---|
| **bevy** (games) | No prebuilt port — every app is a bespoke `.wasm`. Needs external Rust prebuild + WebGPU/GPU. No generic drop-in. |
| **nannou** (graphic-design) | No npm/.wasm; web target experimental, per-sketch compile. Must supply prebuilt `.wasm` externally. |

Note: several **prebuilt-wasm** tools are Rust-under-the-hood but already shipped as artifacts,
so they sidestep the block: **typst / typst.ts**, **resvg-js**, **d2** (Go+wasm), and Tailwind's
**@tailwindcss/oxide-wasm** (used by maizzle). The pattern: when a Rust lib publishes a prebuilt
`.wasm` on npm, it is usable; only libs requiring in-sandbox `rustc` are blocked.

### hard-impractical (10 — proprietary or unportable toolchain)

| tool | why |
|---|---|
| **deckary** | Closed-source SaaS PowerPoint add-in; no render lib (npm 404). |
| **pico8** | Proprietary Lexaloffle; wasm only from paid per-cart export. Open alt: TIC-80. |
| **drawbot** | Binds Apple PyObjC/CoreText/Quartz (macOS); skia fork needs skia-python (not in Pyodide). |
| **basil-js** | Requires Adobe InDesign + ExtendScript host. |
| **lilypond** | Engine needs GNU Guile (Scheme VM + GC + JIT) + Python + Pango + Ghostscript; none wasm-ported; one attempt stalled. Alt: Verovio wasm (different syntax). |
| **blender** | Multi-MLOC C++ desktop app; Cycles/EEVEE need GPU APIs; no port. Use three.js + exported glTF. |
| **gegl** | Depends on GLib/GObject/GIO + babl; GObject type system + main loop don't port to wasm. |
| **weasyprint** | Runtime dlopen of native libpango/harfbuzz/fontconfig + Pillow C-ext; not in Pyodide, no port. |
| **playwright** | Not a renderer — Node/Python automation spawning native browsers over CDP. |
| **htmlcsstoimage** | Closed SaaS = server headless Chromium. Substitute html-to-image/html2canvas on the shell's own DOM. |

Plus **defold** (hard-impractical tier, verdict needs-prebuilt): no reusable render lib; bob.jar
Emscripten pipeline emits a per-game `.wasm` only — must pre-export each game externally.
