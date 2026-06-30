# Out Of Thin Air (OOTA) ✨

Conjure any deliverable — decks, video, audio, diagrams, docs, 3D, games, music,
maps, ad creative — from plain, version-controlled source. You describe it; OOTA
runs the right toolchain headlessly and shows the result in one universal browser
shell.

Every artifact reduces to one of **8 render kinds**, so a single shell renders
every medium and adding a tool is just mapping its output to a kind.

## Quickstart

```bash
oota serve                              # serve on its own nexus (:4010)
oota scaffold diagrams d2 "My diagram"  # wire a session to one tool chain
oota run my-diagram                     # run the chain → out/
oota open my-diagram                    # print the artifact-shell URL
oota help
```

The `oota` CLI is a Bun/TypeScript package in [`oota/`](./oota). OOTA serves on
its **own** nexus — never bundled into a host server.

## Layout

| Path | What |
|------|------|
| `oota/` | the `oota` CLI package (bin `oota`) |
| `cli/` | worktop UI + the `oota` HTTP API (`server :oota_api`) |
| `components/artifact/` | the universal artifact shell (renders all 8 kinds) |
| `wrappers/` | one `.work` per tool — controls + render notes |
| `tools/` + `tools/steps/` | host runners; one step script per `<category>-<tool>` |
| `skill/` | agent skill + `skill/catalog/` per-tool dossiers (full sources) |
| `eval/` | blind agent scenarios |
| `docs/` | design + research docs |

---

## Tool directory

The source of truth for "how to make each thing." Each row's full source list
(official + community skills, toolchains, validation) lives in
`skill/catalog/<category>/<tool>.md`.

**Render kind** &nbsp; 🎬 video &nbsp; 🔊 audio &nbsp; 📄 pdf &nbsp; 🖼️ image &nbsp; ✒️ svg &nbsp; 🌐 html &nbsp; 🧊 model3d &nbsp; 📝 text
**Source** &nbsp; 🟢 Claude/Anthropic skill &nbsp; 📘 official docs &nbsp; 📦 official repo &nbsp; 🌿 community skill/repo

### 🖥️ Presentations & documents

#### presentations
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| marp | 🌐📄 | native, JS | 📦 [marp-cli](https://github.com/marp-team/marp-cli) |
| slidev | 🌐 | JS/TS | 🌿 [slidev-skills](https://github.com/yoanbernabeu/slidev-skills) |
| reveal.js | 🌐 | JS, native | 📘 [revealjs.com](https://revealjs.com/) |
| spectacle | 🌐 | React | 📦 [spectacle](https://github.com/FormidableLabs/spectacle) |
| quarto | 🌐📄 | native, Py/R | 📘 [quarto](https://quarto.org/docs/presentations/revealjs/) |
| deckary | 🌐 | native | 📘 [deckary.com](https://deckary.com) |

#### documents
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| typst | 📄 | native, Rust | 🌿 [claude-skill-typst](https://github.com/lucifer1004/claude-skill-typst) |
| latex | 📄 | native | 📘 [latex-project](https://www.latex-project.org/help/documentation/) |
| context | 📄 | native | 📘 [contextgarden](https://wiki.contextgarden.net/Main_Page) |
| basil.js | 📄 | JS (InDesign) | 📘 [basiljs](https://basiljs.basislab.org/) |

#### business-documents
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| typst-invoice | 📄 | Typst | 📦 [invoice-maker](https://typst.app/universe/package/invoice-maker/) |
| reportlab (RML) | 📄 | Python | 📘 [reportlab](https://docs.reportlab.com/rml/userguide/Chapter_1_Introduction/) |
| rendercv | 📄 | Python | 📦 [rendercv](https://github.com/rendercv/rendercv) |
| json-resume | 📄 | JS | 📘 [jsonresume](https://jsonresume.org/) |
| weasyprint | 📄 | Python | 📘 [weasyprint](https://weasyprint.org/) |
| segno | ✒️ | Python | 📦 [segno](https://github.com/heuer/segno) (QR) |
| python-barcode | ✒️ | Python | 📦 [python-barcode](https://github.com/WhyNotHugo/python-barcode) |
| zpl-labelary | 🖼️ | any (HTTP) | 📘 [labelary](https://labelary.com/) |

### 🎞️ Motion & video

#### video
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| remotion | 🎬 | React/TS | 📘 [remotion docs](https://www.remotion.dev/docs/) |
| hyperframes | 🌐🎬 | HTML/GSAP | 📦 [hyperframes](https://github.com/heygen-com/hyperframes) |
| manim | 🎬 | Python | 🌿 [manim-skill](https://github.com/Yusuke710/manim-skill) |
| revideo | 🎬 | TS | 📘 [re.video](https://docs.re.video/) |

#### motion-graphics
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| motion-canvas | 🎬 | TS | 📘 [motioncanvas.io](https://motioncanvas.io/docs/) |
| lottie | 🎬 | JSON, JS | 📦 [lottie](https://github.com/airbnb/lottie-web) |
| gsap | 🌐 | JS | 📘 [gsap docs](https://gsap.com/docs/v3/) |
| anime.js | 🌐 | JS | 📦 [anime](https://github.com/juliangarnier/anime) |
| theatre.js | 🌐 | JS/TS | 📘 [theatrejs](https://www.theatrejs.com/docs/latest) |
| svg-smil | ✒️ | SVG/XML | 📘 [MDN SMIL](https://developer.mozilla.org/en-US/docs/Web/SVG/SVG_animation_with_SMIL) |

### 📊 Diagrams, data & maps

#### diagrams
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| mermaid | ✒️ | native, JS | 🌿 [mermaid-skill](https://github.com/WH-2099/mermaid-skill) |
| d2 | ✒️ | native, Go, JS | 📘 [d2lang.com](https://d2lang.com/) |
| plantuml | ✒️ | native (Java) | 📘 [plantuml CLI](https://plantuml.com/command-line) |
| structurizr | ✒️ | native, DSL | 📘 [structurizr](https://docs.structurizr.com/cli) |
| python-diagrams | 🖼️ | Python | 📘 [diagrams](https://diagrams.mingrammer.com/) |
| excalidraw | ✒️ | JS | 📘 [@excalidraw/utils](https://docs.excalidraw.com/docs/@excalidraw/excalidraw/api/utils/export) |
| chart.xkcd | ✒️ | JS | 📦 [chart.xkcd](https://github.com/timqian/chart.xkcd) |
| roughviz | ✒️ | JS | 📦 [roughViz](https://github.com/jwilber/roughViz) |

#### data-visualization
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| vega-lite | ✒️ | spec, Py/JS | 📘 [vega-lite](https://vega.github.io/vega-lite/docs/) |
| observable-plot | ✒️ | JS | 📦 [plot](https://github.com/observablehq/plot) |
| matplotlib | 🖼️ | Python | 📘 [matplotlib](https://matplotlib.org/) |
| ggplot2 | 🖼️ | R | 📘 [ggplot2](https://ggplot2.tidyverse.org/) |
| gnuplot | ✒️ | native | 📘 [gnuplot](http://www.gnuplot.info/documentation.html) |
| plotly | 🖼️🌐 | Py/JS/R | 📘 [plotly](https://plotly.com/python/) |
| echarts | 🌐✒️ | JS | 📘 [echarts](https://echarts.apache.org/en/index.html) |

#### infographics-posters
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| drawsvg | ✒️ | Python | 📦 [drawsvg](https://github.com/cduck/drawsvg) |
| p5.riso | 🖼️ | JS | 📦 [p5.riso](https://github.com/antiboredom/p5.riso) |

#### maps-geo
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| maplibre-gl | 🌐 | JS | 📘 [maplibre](https://maplibre.org/maplibre-gl-js/docs/) |
| mapbox-gl | 🌐 | JS | 📘 [mapbox](https://docs.mapbox.com/mapbox-gl-js/) (token) |
| deck.gl | 🌐 | JS | 📘 [deck.gl](https://deck.gl/docs) |
| kepler.gl | 🌐 | JS | 📦 [kepler.gl](https://github.com/keplergl/kepler.gl) |
| leaflet | 🌐 | JS | 📘 [leaflet](https://leafletjs.com/reference.html) |
| folium | 🌐 | Python | 📦 [folium](https://github.com/python-visualization/folium) |
| osmnx | 🖼️ | Python | 📦 [osmnx](https://github.com/gboeing/osmnx) |
| prettymapp | 🖼️ | Python | 📦 [prettymapp](https://github.com/chrieke/prettymapp) |

### 🎨 Design, image & marketing

#### graphic-design
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| satori | ✒️ | JS/TS | 📦 [satori](https://github.com/vercel/satori) |
| drawbot | 📄🖼️ | Python | 📘 [drawbot](https://www.drawbot.com/) |
| svg.js | ✒️ | JS | 📘 [svgjs](https://svgjs.dev/docs/3.2/) |
| cairo | 🖼️✒️ | Py/C | 📘 [cairosvg](https://cairosvg.org/) |
| paper.js | ✒️ | JS | 📘 [paperjs](http://paperjs.org/reference/) |
| nannou | 🖼️ | Rust | 📘 [nannou](https://guide.nannou.cc/) |

#### image-processing
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| imagemagick | 🖼️ | native (MSL) | 📘 [imagemagick](https://imagemagick.org/script/command-line-processing.php) |
| gmic | 🖼️ | native | 📘 [gmic](https://gmic.eu/) |
| sharp | 🖼️ | JS | 📘 [sharp](https://sharp.pixelplumbing.com/) |
| pillow | 🖼️ | Python | 📘 [pillow](https://pillow.readthedocs.io/) |
| libvips | 🖼️ | native, bindings | 📘 [libvips](https://www.libvips.org/) |
| gegl | 🖼️ | native | 📘 [gegl](https://gegl.org/) |

#### social-formats
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| @vercel/og | 🖼️ | JS/TS | 📘 [vercel/og](https://vercel.com/docs/functions/og-image-generation) |
| resvg-js | 🖼️ | JS | 📦 [resvg-js](https://github.com/yisibl/resvg-js) |
| open-carrusel | 🖼️ | JS | 🌿 community (see dossier) |

#### advertising-creative
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| mjml | 🌐 | JS/native | 📘 [mjml](https://documentation.mjml.io/) |
| react-email | 🌐 | React | 📘 [react.email](https://react.email/docs) |
| maizzle | 🌐 | JS | 📘 [maizzle](https://maizzle.com/docs) |
| amphtml-ads | 🌐 | HTML | 📘 [amp ads](https://amp.dev/documentation/guides-and-tutorials/develop/advertise_amphtml) |
| htmlcsstoimage | 🖼️ | any (HTTP) | 📘 [htmlcsstoimage](https://htmlcsstoimage.com/) |

#### comics-illustration
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| comicgen | ✒️ | JS | 📦 [comicgen](https://github.com/gramener/comicgen) |
| rough.js | ✒️ | JS | 📦 [rough](https://github.com/rough-stuff/rough) |
| balloon-css | 🌐 | CSS | 📦 [balloon.css](https://github.com/kazzkiq/balloon.css) |

#### web-ui-prototypes
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| tldraw | ✒️ | React | 📦 [tldraw](https://github.com/tldraw/tldraw) |
| storybook | 🖼️ | JS + Playwright | 📘 [storybook](https://storybook.js.org/docs) |
| playwright | 🖼️ | JS/Py/native | 📘 [playwright](https://playwright.dev/) |
| frontend-design | 🌐 | HTML/Tailwind | 🟢 frontend-design skill |

### 🧊 3D & spatial

#### 3d-shaders
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| blender | 🖼️🎬 | Python (bpy) | 📘 [blender bpy](https://docs.blender.org/api/current/) |
| openusd | 🧊 | Py/C++ | 📦 [OpenUSD](https://github.com/PixarAnimationStudios/OpenUSD) |
| glslviewer | 🖼️ | GLSL | 📦 [glslViewer](https://github.com/patriciogonzalezvivo/glslViewer) |
| shadertoy | ✒️🖼️ | GLSL | 📘 [shadertoy](https://www.shadertoy.com/) |
| povray | 🖼️ | SDL | 📘 [povray](https://www.povray.org/documentation/) |

#### ar-vr
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| a-frame | 🌐 | HTML/JS | 📘 [aframe](https://aframe.io/docs/) |
| model-viewer | 🌐🧊 | HTML | 📘 [modelviewer.dev](https://modelviewer.dev/) |
| usd-from-gltf | 🧊 | native | 📦 [usd_from_gltf](https://github.com/google/usd_from_gltf) |
| needle | 🌐 | JS | 📘 [needle](https://needle.tools/) |
| playcanvas | 🌐 | JS | 📘 [playcanvas](https://developer.playcanvas.com/) |
| babylon.js | 🌐🖼️ | JS/TS | 📘 [babylonjs](https://doc.babylonjs.com/) |

#### cad
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| cadquery | 🧊 | Python | 🌿 [cad-skill](https://github.com/flowful-ai/cad-skill) |
| openscad | 🧊 | SCAD/native | 🌿 [agent-stuff](https://github.com/mitsuhiko/agent-stuff) |
| freecad | 🧊 | Python | 📘 [freecad scripting](https://wiki.freecad.org/Scripting) |

#### electronics
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| skidl | ✒️ | Python | 📘 [skidl](https://devbisme.github.io/skidl/) |
| kicad-api | ✒️ | Python | 📘 [kicad ipc-api](https://dev-docs.kicad.org/en/apis-and-binding/ipc-api/) |

### 🔊 Audio, music & notation

#### audio
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| tts-local | 🔊 | Python (HF) | 📦 [kokoro](https://github.com/hexgrad/kokoro) |

#### music
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| sonic-pi | 🔊 | Ruby | 📘 [sonic-pi](https://sonic-pi.net/tutorial.html) |
| tone.js | 🔊 | JS | 📘 [tonejs](https://tonejs.github.io/docs/) |
| tidal-cycles | 🔊 | Haskell | 📘 [tidalcycles](https://tidalcycles.org/docs/) |
| supercollider | 🔊 | sclang | 📘 [supercollider](https://doc.sccode.org/Guides/Non-Realtime-Synthesis.html) |
| alda | 🔊 | Alda DSL | 📘 [alda](https://alda.io/docs/) |

#### notation
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| lilypond | 📄✒️ | LilyPond | 📘 [lilypond](https://lilypond.org/doc/) |

### 🕹️ Interactive

#### games
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| pico8 | 🌐🖼️ | Lua | 📘 [pico-8 manual](https://www.lexaloffle.com/pico8_manual.txt) |
| tic80 | 🌐 | Lua/JS/… | 📦 [TIC-80 wiki](https://github.com/nesbox/TIC-80/wiki) |
| love2d | 🌐 | Lua | 📘 [love2d wiki](https://love2d.org/wiki/Main_Page) |
| godot | 🌐 | GDScript/C# | 📘 [godot CLI](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) |
| raylib | 🖼️ | C/bindings | 📦 [raylib](https://github.com/raysan5/raylib) |
| pyxel | 🎬 | Python | 📦 [pyxel](https://github.com/kitao/pyxel) |
| phaser | 🌐 | JS/TS | 📘 [phaser](https://docs.phaser.io/phaser/getting-started) |
| kaplay | 🌐 | JS/TS | 📘 [kaplay](https://kaplayjs.com/) |
| bevy | 🖼️ | Rust | 📘 [bevy](https://bevyengine.org/learn/quick-start/) |
| defold | 🌐 | Lua | 📘 [defold](https://defold.com/manuals/bundling/) |
| arcade | 🖼️ | Python | 📘 [arcade](https://api.arcade.academy/en/latest/) |

#### fiction
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| ink | 🌐 | ink/Unity | 📦 [ink](https://github.com/inkle/ink) |
| twine | 🌐 | Twee | 📘 [twine cookbook](https://twinery.org/cookbook/) |
| choicescript | 🌐 | ChoiceScript | 📘 [choicescript](https://www.choiceofgames.com/make-your-own-games/choicescript-intro/) |
| renpy | 🌐 | Ren'Py/Python | 📘 [renpy](https://www.renpy.org/doc/html/) |

### 🧶 Generative & physical

#### creative
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| p5js | 🌐🖼️ | JS | 📘 [p5 reference](https://p5js.org/reference/) |
| processing | 🖼️ | Java/Py | 📘 [processing](https://processing.org/reference/) |
| openframeworks | 🖼️ | C++ | 📘 [openframeworks](https://openframeworks.cc/documentation/) |
| three.js | 🌐🖼️ | JS | 📘 [three.js](https://threejs.org/docs/) |
| three.js (headless) | 🖼️ | JS (Node) | 📦 [headless-threejs](https://github.com/Dylan-Kentish/headless-threejs) |

#### typography
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| fontparts | 📄 | Python | 📘 [fontparts](https://fontparts.robotools.dev/) |
| metafont | 🖼️ | MetaFont | 📘 [metafont](https://www.tug.org/metafont.html) |

#### textiles
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| turtlestitch | ✒️ | blocks/JS | 📘 [turtlestitch](https://www.turtlestitch.org/) |
| knitout | ✒️ | knitout | 📘 [knitout](https://textiles-lab.github.io/knitout/knitout.html) |

#### generative-text
| Tool | Kind | Stacks | Source |
|------|------|--------|--------|
| tracery | 📝 | JS/grammar | 📦 [tracery](https://github.com/galaxykate/tracery) |

---

## Docs

- [docs/oota-migration.md](docs/oota-migration.md) — repo/CLI history.
- [docs/universal-shell-plan.md](docs/universal-shell-plan.md) — the universal artifact shell design.
- [docs/catalog-expansion.md](docs/catalog-expansion.md) — category-expansion source tables.
- [docs/research-survey.md](docs/research-survey.md) — original research survey.
