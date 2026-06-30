# GSAP (motion-graphics)

<!-- generated draft — needs validation -->

## Summary

GSAP (GreenSock Animation Platform) is a JavaScript animation library that drives DOM/SVG/canvas/WebGL via a deterministic, scriptable timeline. As of April 2025 (post-Webflow acquisition) it is 100% free — including all former Club plugins (SplitText, MorphSVG, DrawSVG, ScrollTrigger, ScrollSmoother, Inertia) and commercial use.

For OOTA it is authored as version-controllable HTML/JS markup. Its primary deterministic deliverable is **video**: a GSAP timeline can be scrubbed frame-by-frame in headless Chrome and encoded to MP4 (e.g. `gsap-video-export`), making it fully deterministic and reproducible rather than wall-clock dependent. It can also stand alone as an animated HTML artifact.

## Skills

| Resource | Type | Official | URL | License / Attribution |
|---|---|---|---|---|
| greensock/gsap-skills (Official AI skills for GSAP) | skill-repo | official | https://github.com/greensock/gsap-skills | Check repo LICENSE (GreenSock-published; GSAP itself is now standard no-charge license). Install: `npx skills add https://github.com/greensock/gsap-skills`. Includes llms.txt skill index + modules: core API, timelines, ScrollTrigger, plugins, React, performance. Compatible with Claude Code, Cursor, Codex, Copilot. |
| GSAP official docs | docs | official | https://gsap.com/docs/v3/ | GreenSock. Pricing/license now 100% free: https://gsap.com/pricing/ |
| Webflow GSAP-free announcement | reference | official | https://webflow.com/blog/gsap-becomes-free | Webflow blog — confirms free incl. commercial use since April 2025 |

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JavaScript/TypeScript (Browser / Node ESM) | `npm install gsap` | `import { gsap } from 'gsap'` — core + all plugins (ScrollTrigger, SplitText, MorphSVG, DrawSVG…) bundled free; authored as deterministic HTML/JS |
| JavaScript CLI render (Node + headless Chrome + FFmpeg) | `npm install -g gsap-video-export` (+ `brew install ffmpeg`) | `gsap-video-export <url-or-file>` — scrubs global timeline frame-by-frame, pipes to FFmpeg; defaults 1920x1080 60fps H.264 `video.mp4`; also importable as ESM |
| JavaScript alt render (Node + Puppeteer + FFmpeg) | `git clone https://github.com/dtinth/html5-animation-video-renderer` | Generic `seekToFrame(frame)` headless frame-grab pipeline; works with GSAP for 1080p60 deterministic output |

## Artifact kind

**video** — primary deterministic deliverable (frame-stepped MP4). Secondary: **html** (live animated page).

## Validation

- **install**: `npm install -g gsap-video-export && (command -v ffmpeg || brew install ffmpeg) && command -v google-chrome >/dev/null || true`
- **smoke**: Create a minimal `smoke.html` that loads gsap from CDN and builds a single global timeline, e.g. `gsap.to('#box',{x:400,rotation:360,duration:2})` on a 1920x1080 page with a colored `#box` div. Then run: `gsap-video-export ./smoke.html --output out.mp4` (frame-by-frame scrub through the timeline in headless Chrome, encoded by ffmpeg).
- **expect**: An `out.mp4` (~2s, 1920x1080, 60fps, H.264) is written; `ffprobe out.mp4` reports a valid H.264 stream with expected duration/resolution. Output is byte-stable across runs because frames are scrubbed deterministically rather than captured in real time.

## Wrapper params

- `motion-graphics.title` (text) — scene title / label.
- `motion-graphics.duration` (range) — timeline duration in seconds.
- `motion-graphics.fps` (select) — frame rate (30/60).
- `motion-graphics.source` (textarea, bound to `src/scene.html`) — the GSAP HTML scene with one global timeline.

## Component / explorer notes

GSAP timelines are deterministic when driven by an explicit time/progress value (`timeline.progress(t)` or `seekToFrame`) rather than the wall clock — this is what makes headless frame-stepping reproducible. Author each deliverable as a single self-contained HTML file: GSAP via npm-bundled or pinned CDN version, scene markup, and one global/exported timeline the renderer can scrub. **Pin the gsap version** to keep renders reproducible. Avoid `random()` / `Date.now()` / non-seeded jitter, or seed them. All former paid plugins are free, so ScrollTrigger/SplitText/MorphSVG can be used without license gating — but ScrollTrigger is scroll-driven, so for video convert scroll progress to a tween the renderer can scrub.

Primary OOTA wrapper: a render verb that takes an HTML file containing a pinned GSAP version + a single global timeline and runs `gsap-video-export` (or a Puppeteer+FFmpeg frame-stepper) headless on macOS to emit MP4. The wrapper should (1) inject/lint that a global `gsap.globalTimeline` (or named export) exists; (2) set page size, fps, duration explicitly; (3) shell out to ffmpeg for encode; (4) optionally support secondary artifactKind `html` to ship the live animated page. For SVG-only morph/draw deliverables the same HTML can be frame-stepped to image sequences. Note GSAP itself ships no headless renderer — that is supplied by the wrapper via gsap-video-export/Puppeteer.
