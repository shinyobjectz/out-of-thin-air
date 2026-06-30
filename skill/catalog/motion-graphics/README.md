# motion-graphics

Code-authored timeline animation + declarative motion markup → video / SVG / HTML.

## Build Matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [Motion Canvas](./motion-canvas.md) | video | TypeScript/JS (Node/npm); headless render (Puppeteer/Playwright, community) | motion-canvas (community Claude Code skill) | no | ok | yes | yes |
| [Lottie](./lottie.md) | video | JS/Node (puppeteer-lottie-cli); JS/Node (puppeteer-lottie lib) | transitive-bullshit/puppeteer-lottie-cli | no | ok | yes | yes |
| [GSAP](./gsap.md) | video | gsap (npm, browser/node ESM); gsap-video-export (node + headless Chrome + ffmpeg); html5-animation-video-renderer (Puppeteer + ffmpeg) | greensock/gsap-skills | yes | ok | yes | yes |
| [anime.js](./anime-js.md) | video | JS/TS + Playwright headless Chromium (primary); pure Node (data-only); HTML/CSS UMD CDN | animejs-skills (BowTiedSwan) | no | ok | yes | yes |
| [Theatre.js](./theatre-js.md) | video | JS/TS (Node ≥16 + headless Chromium) | chadpowers-superbowl-theatrejs-cinematics | no | ok | yes | yes |
| [SVG SMIL](./svg-smil.md) | svg | markup/none; librsvg/rsvg-convert; resvg/resvg-js; svg-video (Puppeteer+ffmpeg) | svg-animations (supermemoryai/skills) | no | ok | yes | yes |

## Multi-toolchain notes

Every tool here is browser-native animation; turning it into a deterministic video means
driving a headless browser and muxing frames with ffmpeg. Pick a toolchain by render path:

- **No official headless CLI** — Motion Canvas (GH #415/#1218), anime.js, Theatre.js. These
  are render-less / studio-first engines. The OOTA harness disables autoplay and *seeks/steps*
  the clock (`seek(ms)`, `seq.position`, `tl.seek`) under Playwright/Puppeteer, screenshots a
  fixed clip per frame, then ffmpeg-encodes. Stepping (not `play()`) is what makes re-runs
  byte-identical.
- **Bundled headless CLI** — Lottie (`puppeteer-lottie-cli`) and GSAP (`gsap-video-export`)
  ship a one-shot CLI that owns the Chromium + ffmpeg pipeline; just feed JSON / HTML.
- **Static vs animated SVG** — SVG SMIL artifact is one self-contained `.svg`. Static renderers
  (rsvg-convert, resvg) only emit **t=0** and never run the SMIL timeline; only a headless
  browser (svg-video/Puppeteer) plays the clock to produce motion video.
- **Licensing carve-outs** — Theatre.js ships only `@theatre/core` (Apache-2.0) in the render
  bundle; `@theatre/studio` (AGPL-3.0) is excluded. GSAP is the lone official skill.

## Validation order

Cheapest / most-reliable installs first:

1. **SVG SMIL** — `brew install librsvg ffmpeg`; static `rsvg-convert` smoke needs no browser.
2. **Lottie** — `npm i -g puppeteer-lottie-cli` + `brew install ffmpeg gifski`; bundled CLI, minimal JSON fixture.
3. **GSAP** — `npm i -g gsap-video-export` + ffmpeg + Chrome; bundled CLI, single HTML scene.
4. **anime.js** — npm + `playwright install chromium` + ffmpeg; seek-and-screenshot harness.
5. **Theatre.js** — npm (`@theatre/core` three) + puppeteer + ffmpeg; custom frame-step driver.
6. **Motion Canvas** — `npm create @motion-canvas` + `@motion-canvas/ffmpeg`; heaviest scaffold and **no official headless render** (needs community browser driver).

## Explorer needs

Default shell is fine for SVG SMIL (it edits a single `.svg` textarea via the wrapper).
The four browser-driven video engines (Motion Canvas, anime.js, Theatre.js, GSAP) and Lottie
would benefit from a richer explorer than the bare shell: a live HTML/scene preview pane plus a
frame scrubber, since their value is in seeing the timeline before the (slow) headless render.
Motion Canvas specifically wants its own editor/preview surface given it has no CLI render path.

## Tools

- [./motion-canvas.md](./motion-canvas.md)
- [./lottie.md](./lottie.md)
- [./gsap.md](./gsap.md)
- [./anime-js.md](./anime-js.md)
- [./theatre-js.md](./theatre-js.md)
- [./svg-smil.md](./svg-smil.md)
