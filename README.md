# Out Of Thin Air (OOTA)

Conjure any deliverable — decks, video, audio, diagrams, docs, 3D, games, music,
maps, ad creative — from plain, version-controlled source. You describe it; OOTA
runs the right toolchain headlessly and shows the result in one universal browser
shell.

Every artifact reduces to one of **8 render kinds** (`video · audio · pdf ·
image · svg · html · model3d · text`), so a single shell renders every medium and
adding a tool is just mapping its output to a kind.

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
| `skill/` | agent skill + `skill/catalog/` per-tool dossiers (full attributed sources) |
| `eval/` | blind agent scenarios |
| `docs/` | design + research docs |

---

## Source directory

Where each tool's "how to do it" lives — the primary skill repo or official docs
per shipped tool. Each tool's full source list (official + community skills,
toolchains, validation) is in `skill/catalog/<category>/<tool>.md`.

### Shipped

**presentations** — [marp](https://github.com/marp-team/marp-cli) · [slidev](https://github.com/yoanbernabeu/slidev-skills) · [reveal.js](https://revealjs.com/) · [spectacle](https://github.com/FormidableLabs/spectacle) · [quarto](https://quarto.org/docs/presentations/revealjs/) · [deckary](https://deckary.com)

**video** — [remotion](https://www.remotion.dev/docs/) · [hyperframes](https://github.com/heygen-com/hyperframes) · [motion-canvas](https://github.com/motion-canvas/motion-canvas) · [manim](https://github.com/Yusuke710/manim-skill)

**audio** — [tts-local (kokoro)](https://github.com/hexgrad/kokoro)

**diagrams** — [mermaid](https://github.com/WH-2099/mermaid-skill) · [d2](https://d2lang.com/) · [plantuml](https://plantuml.com/command-line) · [structurizr](https://docs.structurizr.com/cli) · [python-diagrams](https://diagrams.mingrammer.com/)

**cad** — [cadquery](https://github.com/flowful-ai/cad-skill) · [openscad](https://github.com/mitsuhiko/agent-stuff) · [freecad](https://wiki.freecad.org/Scripting)

**electronics** — [skidl](https://devbisme.github.io/skidl/) · [kicad-api](https://dev-docs.kicad.org/en/apis-and-binding/ipc-api/)

**documents** — [typst](https://github.com/lucifer1004/claude-skill-typst) · [latex](https://www.latex-project.org/help/documentation/) · [context](https://wiki.contextgarden.net/Main_Page)

**creative** — [p5js](https://p5js.org/reference/) · [processing](https://processing.org/reference/) · [openframeworks](https://openframeworks.cc/documentation/) · [threejs](https://threejs.org/docs/)

**music** — [sonic-pi](https://sonic-pi.net/tutorial.html) · [tone-js](https://tonejs.github.io/docs/) · [tidal-cycles](https://tidalcycles.org/docs/) · [supercollider](https://doc.sccode.org/Guides/Non-Realtime-Synthesis.html) · [alda](https://alda.io/docs/)

**notation** — [lilypond](https://lilypond.org/doc/)

**fiction** — [ink](https://github.com/inkle/ink) · [twine](https://twinery.org/cookbook/) · [choicescript](https://www.choiceofgames.com/make-your-own-games/choicescript-intro/) · [renpy](https://www.renpy.org/doc/html/)

**games** — [pico8](https://www.lexaloffle.com/pico8_manual.txt) · [tic80](https://github.com/nesbox/TIC-80/wiki) · [love2d](https://love2d.org/wiki/Main_Page)

**typography** — [fontparts](https://fontparts.robotools.dev/) · [metafont](https://www.tug.org/metafont.html)

**textiles** — [turtlestitch](https://www.turtlestitch.org/) · [knitout](https://textiles-lab.github.io/knitout/knitout.html)

**generative-text** — [tracery](https://github.com/galaxykate/tracery)

### Researched — proposed, not yet built

From [docs/catalog-expansion.md](docs/catalog-expansion.md) (13 new categories +
additions to existing). Best source per new category:

**motion-graphics** — [Motion Canvas](https://motioncanvas.io/docs/) · Lottie · GSAP · anime.js · Theatre.js
**graphic-design** — [Satori](https://github.com/vercel/satori) · DrawBot · SVG.js · Cairo · Paper.js · Nannou
**data-visualization** — [Vega-Lite](https://vega.github.io/vega-lite/docs/) · Observable Plot · Matplotlib · gnuplot · Plotly
**maps-geo** — [MapLibre GL](https://maplibre.org/maplibre-gl-js/docs/) · deck.gl · Leaflet · Folium · OSMnx · prettymapp
**3d-shaders** — [Blender (bpy)](https://docs.blender.org/api/current/) · OpenUSD · glslViewer · A-Frame · POV-Ray
**web-ui-prototypes** — tldraw SDK · Satori · Storybook + Playwright · [frontend-design skill]
**image-processing** — [ImageMagick](https://imagemagick.org/script/command-line-processing.php) · G'MIC · sharp · Pillow · libvips
**infographics-posters** — Vega-Lite · DrawBot · drawsvg · Typst · p5.riso
**social-formats** — [Satori / @vercel/og](https://github.com/vercel/satori) · Playwright · resvg-js
**ar-vr** — [A-Frame](https://aframe.io/docs/) · `<model-viewer>` · usd_from_gltf · PlayCanvas · Babylon.js
**business-documents** — [Typst invoice-maker](https://typst.app/universe/package/invoice-maker/) · RML/ReportLab · Segno · python-barcode · WeasyPrint
**advertising-creative** — [MJML](https://documentation.mjml.io/) · react-email · Maizzle · Satori · AMPHTML ads
**comics-illustration** — [comicgen](https://github.com/gramener/comicgen) · Rough.js

Additions to shipped categories (games: Godot/raylib/Pyxel/Phaser/kaplay/Bevy/Defold;
video: Revideo; creative: Paper.js/Nannou/Theatre.js/anime.js; documents:
ReportLab/WeasyPrint; diagrams: Excalidraw/chart.xkcd/roughViz) — see the
expansion doc for sources.

---

## Docs

- [docs/oota-migration.md](docs/oota-migration.md) — repo/CLI history.
- [docs/universal-shell-plan.md](docs/universal-shell-plan.md) — the universal artifact shell design.
- [docs/catalog-expansion.md](docs/catalog-expansion.md) — proposed new categories/tools (full source tables).
- [docs/research-survey.md](docs/research-survey.md) — original research survey.
