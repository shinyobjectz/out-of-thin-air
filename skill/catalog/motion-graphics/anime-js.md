<!-- generated draft — needs validation -->
# anime.js (motion-graphics)

## Summary
anime.js (npm `animejs`, v4.5.0, MIT, by Julian Garnier) is a lightweight (~10KB gzip) ES-module JS animation engine. It animates DOM/CSS, SVG (incl. path morphing/draw), DOM attributes, and plain JS objects, with timelines, staggers, spring easing, scroll triggers, and draggable. It is browser-oriented and does NOT render to a file by itself.

For OOTA's deterministic, version-controllable headless pipeline, anime.js is driven inside a headless Chromium (Playwright/Puppeteer): set animations to `paused`, manually seek the timeline clock (`anim.seek(ms)` / `anim.currentTime`) at fixed frame intervals, screenshot each frame, then assemble with ffmpeg. The manual-seek clock makes frame-accurate determinism achievable — no reliance on real wall-clock RAF timing.

Primary OOTA deliverable kind: **video** (frame-captured animation). HTML (self-contained animated page) is the secondary viable kind. Source markup/script is plain JS+HTML, fully version-controllable.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| animejs-skills (BowTiedSwan) | claude-skill | community | MIT | https://github.com/BowTiedSwan/animejs-skills |
| animejs-best-practices (davidosemwegie) | reference-skill | community | see repo | https://github.com/davidosemwegie/animejs-best-practices |
| claudedesignskills/animejs (freshtechbro) | claude-skill | community | see repo | https://github.com/freshtechbro/claudedesignskills |
| Official documentation | docs | official | MIT (project) | https://animejs.com/documentation/ |

Attribution:
- **animejs-skills (BowTiedSwan)** — Comprehensive Claude Code skill for anime.js v4: core animate API, timelines, staggers, SVG utils, text split, scroll, draggable, easing, math helpers. Install: `npx skills add bowtiedswan/animejs-skills` (or curl one-liner to `~/.claude/skills/animejs/`).
- **animejs-best-practices (davidosemwegie)** — Reference/skill: anime.js v4 + Web Animations API best practices and patterns for AI coding assistants.
- **claudedesignskills/animejs (freshtechbro)** — Community collection of Claude Code skills for web dev (3D, animation, interactive); includes an animejs skill.
- **Official documentation** — Official anime.js v4 docs (Julian Garnier). No official Anthropic skill or llms.txt published as of 2026-06.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JS/TS (headless browser host) | `npm install animejs playwright && npx playwright install chromium` | Node orchestrates Playwright/Puppeteer: load page, set anim `paused:true`, loop `anim.seek(frame/fps*1000)` + `page.screenshot`, then ffmpeg frames->mp4. PRIMARY path. ESM `import {animate,createTimeline} from 'animejs'`. |
| JS (pure Node, no browser) | `npm install animejs` | Loads in Node but no DOM — can only tween plain JS objects to text/data output, not visual frames. NOT the OOTA visual path. |
| HTML/CSS (UMD CDN) | `<script src="https://cdn.jsdelivr.net/npm/animejs/dist/bundles/anime.umd.min.js"></script>` | For artifactKind=html: a single self-contained `.html` that loads anime.js and runs the animation live. Version-controllable plain markup. |

## Artifact kind
**video** — frame-captured animation assembled to mp4. Secondary: html (self-contained animated page).

## Validation
- **install**: `mkdir -p /tmp/anime-smoke && cd /tmp/anime-smoke && npm init -y && npm install animejs playwright && npx playwright install chromium && (command -v ffmpeg || brew install ffmpeg)`
- **smoke**: Create `scene.html` that loads anime.js UMD, a 200x200 SVG circle, and a paused timeline translating x 0->150 over 1000ms. Node script (`capture.mjs`) launches headless chromium, loads scene.html, then for f in 0..29: `page.evaluate(t => window.tl.seek(t), f/30*1000)`; `page.screenshot({path:` + "`frame_${f}.png`" + `, clip:{x:0,y:0,width:200,height:200}})`; then `ffmpeg -framerate 30 -i frame_%d.png -pix_fmt yuv420p out.mp4`. Run: `node capture.mjs`.
- **expect**: 30 deterministic PNG frames then `out.mp4` (~1s, 30fps, 200x200). Re-running yields byte-identical frames because the clock is seeked, not real-time. Headless on macOS (Apple Silicon) works via bundled Chromium; no GPU/display needed.

## Wrapper params
- `motion-graphics.title` (text) — scene title.
- `motion-graphics.fps` (range) — capture frame rate.
- `motion-graphics.duration` (range) — timeline duration ms.

## Component / explorer notes
anime.js is a render-less animation ENGINE — it mutates DOM/SVG/CSS/object properties over a timeline; it has no built-in file output, canvas rasterizer, or video encoder. Determinism hinges on disabling autoplay (`paused:true`) and stepping the timeline manually via `anim.seek(ms)` / `anim.currentTime` rather than letting requestAnimationFrame advance from wall-clock. v4 is ESM-first with tree-shaking and built-in TS types (~10KB gzip).

Strengths for motion-graphics: timelines, grid/stagger, spring & custom easing, SVG path morph + line draw, text splitting. It does NOT do 3D (pair with three.js/WebGL) and is not a layout/diagram tool.

OOTA must supply the headless harness anime.js lacks: (1) an HTML scene template that loads anime.js (pin a version via CDN or vendored bundle for reproducible builds) and exposes the timeline on `window`; (2) a Playwright/Puppeteer frame-capture driver that seeks the clock at fixed fps and screenshots a fixed clip rect; (3) ffmpeg assembly to the target container. Pin chromium + animejs versions for byte-stable renders. Disable RAF-driven autoplay. For an html-kind deliverable, skip capture/ffmpeg and emit the self-contained `.html`. Stagger is deterministic given fixed element counts. Await font loading before the first screenshot to avoid flaky frames.
