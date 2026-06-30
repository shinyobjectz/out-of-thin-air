# video — Deterministic motion graphics

Frame-accurate, data-driven motion graphics: code defines every frame, render is reproducible.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|------|---------------|------------|----------------------|-----------|--------|----------|-------|
| [remotion](./remotion.md) | video | JS/TS React (local author+render); native CLI; Lambda clients (Py/Go/Rust/PHP) | remotion-best-practices (bundled local skill) | yes | ok | yes | yes |
| [hyperframes](./hyperframes.md) | video | JS/TS Node CLI (Node>=22 + FFmpeg) | [hyperframes](https://github.com/heygen-com/hyperframes) | yes | ok | yes | yes |
| [motion-canvas](./motion-canvas.md) | video | JS/TS only (editor @ localhost:9000, FFmpeg exporter) | motion-canvas (community, apoorvlathey) | no | ok | yes | yes |
| [manim](./manim.md) | video | Python/ManimCE (primary); Python/manimgl (3b1b) | [Yusuke710/manim-skill](https://github.com/Yusuke710/manim-skill) | no | ok | yes | yes |

## Multi-toolchain notes

- **remotion** — widest reach. JS/TS React is the primary local author+render path; native `npx remotion` CLI; Py/Go/Rust/PHP exist only as Lambda remote-render clients (no local render).
- **hyperframes** — JS/TS only, single Node CLI path. Requires Node>=22 + FFmpeg.
- **motion-canvas** — JS/TS only. No headless render CLI (issues #415/#1218); CI needs a community Puppeteer driver.
- **manim** — Python only, two non-interchangeable forks: ManimCE (primary) and manimgl (3b1b). Renders headless.

No Go/Rust local authoring in this category; remotion is the only tool exposing non-JS surfaces (and only via Lambda).

## VALIDATION ORDER

Cheapest/most-reliable installs first:

1. **manim** — `pip install manim` + FFmpeg; renders fully headless, fast smoke (`-ql` circle to mp4). Most CI-friendly.
2. **remotion** — `npx create-video --blank` + npm install; headless Chromium + FFmpeg, headless render works on macOS.
3. **hyperframes** — `npm i -g hyperframes` (Node>=22 + FFmpeg); `hyperframes doctor` gates env before render. Headless Chrome.
4. **motion-canvas** — last: no headless render CLI, smoke requires browser editor at localhost:9000 + manual RENDER click; CI needs community driver.

## EXPLORER NEEDS

- **motion-canvas** — wants a richer explorer: browser-driven editor at `localhost:9000` with a playable/scrubbable canvas; no headless artifact-shell render path.
- **hyperframes** — benefits from a studio/preview surface (`hyperframes preview`) beyond the default shell.
- remotion / manim — default artifact shell (mp4 output) is sufficient; remotion also offers `npx remotion studio` if interactive preview is wanted.

## Dossiers

- [remotion](./remotion.md)
- [hyperframes](./hyperframes.md)
- [motion-canvas](./motion-canvas.md)
- [manim](./manim.md)
