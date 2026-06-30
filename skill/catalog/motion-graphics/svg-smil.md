# SVG SMIL animation

## Summary
SVG SMIL is declarative animation embedded directly in SVG markup via animation elements (`animate`, `animateTransform`, `animateMotion`, `animateColor`, `set`). The deliverable is a single deterministic, version-controllable `.svg` file — animation logic lives inside the markup with no external CSS/JS dependency, so it animates even when loaded as an `<img>` or CSS background. Browser support is universal across Chrome/Edge/Firefox/Safari/iOS (only IE never supported it); Chrome filed an intent-to-deprecate in 2016 but suspended it after pushback, and SMIL remains fully shipped (~2.5% of page loads) as of 2025/2026.

Headless rendering splits two ways:
1. **STATIC frame** — librsvg (`rsvg-convert`) and resvg/resvg-js are static-only SVG renderers that emit the initial (t=0) frame to PNG/PDF. Useful for validating well-formedness and rendering a poster, but they DO NOT execute SMIL timelines.
2. **ANIMATED video** — a headless browser (Puppeteer/Chromium) is required to actually play the SMIL timeline, capture frames, and pipe through ffmpeg to mp4 (e.g. jcubic/svg-video, which auto-detects SMIL durations).

## Skills
- **svg-animations (supermemoryai/skills)** — community, NOT official. <https://github.com/supermemoryai/skills/blob/main/svg-animations/SKILL.md>. License: unknown (no LICENSE file visible in repo). Covers SMIL, CSS-driven SVG animation, path drawing, shape morphing, motion paths, gradients, masks, filters.
- **svg-creator-skill (upbrew-tech)** — community, NOT official. <https://github.com/upbrew-tech/svg-creator-skill>. License: see repo LICENSE. Generates production SVG illustrations/characters/animations with CSS/SMIL, render-verify-fix loop; works with Claude/Codex/Cursor/Windsurf.
- **Anthropic official skills repo** — reference, official. <https://github.com/anthropics/skills>. License: per-skill. No dedicated SMIL skill found; general skills-authoring reference.
- **MDN: SVG animation with SMIL** — docs, official. <https://developer.mozilla.org/en-US/docs/Web/SVG/Guides/SVG_animation_with_SMIL>. License: CC-BY-SA. Canonical element/attribute reference.
- **W3C SVG Animations spec** — docs, official. <https://svgwg.org/specs/animations/>. License: W3C Document License. Normative spec.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| markup/none | n/a — author plain XML/SVG text | the `.svg` file IS the artifact; no compiler needed (canonical OOTA path) |
| shell (librsvg) | `brew install librsvg` | `rsvg-convert -o out.png in.svg` — renders t=0 static frame; IGNORES SMIL timeline |
| rust/js (resvg) | `npm i @resvg/resvg-js` OR `cargo install resvg` | static-subset raster of initial state; no animation, no script |
| node (svg-video) | `npm install -g svg-video` (Node 22+, `brew install ffmpeg`) | `svg-video input.svg output.mp4` — headless Chromium auto-detects SMIL duration, records, encodes mp4 |

## Artifact kind
**svg** — the primary deliverable is one self-contained `.svg` file.

## Validation
**install:** `brew install librsvg ffmpeg && npm install -g svg-video`

**smoke:** Write `anim.svg`:
```xml
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="40" height="40" fill="#e63"><animateTransform attributeName="transform" type="translate" from="0 80" to="160 80" dur="2s" repeatCount="indefinite"/></rect></svg>
```
Then (A) static-frame validation: `rsvg-convert -o frame.png anim.svg`; and (B) animated video: `svg-video anim.svg anim.mp4`.

**expect:** (A) `frame.png` written, a 200x200 PNG showing the rect at its initial position (proves SVG is well-formed and renders). (B) `anim.mp4` written, a ~2s clip showing the rect sliding left→right (proves the SMIL timeline executes). `file anim.mp4` reports an MP4/H.264 container; `ffprobe anim.mp4` shows duration ~2s.

## Wrapper params
Two render modes must be exposed. STATIC mode (`rsvg-convert`/resvg) is the fast deterministic validator and poster-frame generator but only ever sees t=0 — never use it to "verify animation", only that the SVG parses and the initial composition is correct. ANIMATED mode requires a headless-Chromium pipeline (svg-video, or a custom Puppeteer loop calling `svg.setCurrentTime(t)` per frame + screenshots + ffmpeg) because only a browser implements the SMIL clock. For frame-exact deterministic capture prefer the setCurrentTime stepping approach over real-time screen recording (svg-video records in real time, which can drop/duplicate frames). macOS: librsvg and ffmpeg are brew-installable; svg-video needs Node 22+ and bundles Chromium via Puppeteer. resvg/rsvg are explicitly static-subset — they will never animate.

## Component / explorer notes
A SMIL deliverable is one self-contained `.svg`. Core elements: `<animate>` (any attribute), `<animateTransform>` (translate/scale/rotate/skew), `<animateMotion>` (path-following, pair with `<mpath xlink:href>`), `<set>` (discrete value at a time), `<animateColor>` (deprecated — use `<animate attributeName="fill">`). Timing controls (`begin`, `dur`, `end`, `repeatCount`, `fill="freeze"`, `keyTimes`/`keySplines` for easing, `begin="other.end"` for chaining) make complex sequenced motion fully declarative and reproducible — every render is byte-identical to the markup, ideal for version control and headless reproducibility. No randomness, no wall-clock dependence (timeline is relative to document start).
