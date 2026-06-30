<!-- generated draft — needs validation -->
# Lottie (puppeteer-lottie-cli)

- **slug**: `lottie`
- **category**: motion-graphics
- **artifact kind**: video
- **confidence**: medium

## Summary

`puppeteer-lottie-cli` is a Node CLI that drives headless Chromium (Puppeteer) to render a Lottie/Bodymovin animation JSON file frame-by-frame, then pipes frames to ffmpeg (MP4) or gifski (GIF), or writes a PNG/JPG image sequence. The input is deterministic, version-controllable JSON (the Lottie format, IANA-registered in 2025 as `video/lottie+json`, `.lot`); the CLI produces a fixed-output video/GIF/image. Because it renders via real `lottie-web` in Chromium, svg/canvas/html renderer features are fully supported.

Caveat: the package is essentially unmaintained (latest v1.0.9, last published ~5 years ago) and pins old Puppeteer; it still works but may need a recent Node + manual Chromium handling. Primary OOTA deliverable kind is **video** (MP4); GIF and image-sequence are secondary outputs from the same tool.

## Skills

| Skill | Type | Official | License | URL |
|---|---|---|---|---|
| No official Anthropic/Claude skill | none | no | n/a | https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview |
| transitive-bullshit/puppeteer-lottie-cli (canonical CLI repo; README = de-facto skill doc) | community-repo | no | MIT | https://github.com/transitive-bullshit/puppeteer-lottie-cli |
| Lottie format spec + docs (authoring reference for input JSON) | official-docs | yes | open spec | https://lottie.github.io/lottie-spec/ |

- Companion Node library: https://github.com/transitive-bullshit/puppeteer-lottie
- Developer docs: https://developers.lottiefiles.com/
- Attribution: Travis Fischer (transitive-bullshit); Lottie Animation Community / LottieFiles. No Anthropic-authored skill exists for Lottie as of 2026-06.

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JavaScript/Node.js (CLI) | `npm install -g puppeteer-lottie-cli` + `brew install ffmpeg gifski` | `puppeteer-lottie -i anim.json -o out.mp4 [-w W -h H -b '#fff' -q]` (output kind inferred from `-o` extension: `.mp4`/`.gif`/`.png`/`.jpg` or `frame-%d.png` sequence) |
| JavaScript/Node.js (programmatic) | `npm install puppeteer-lottie` | `const renderLottie = require('puppeteer-lottie'); await renderLottie({ path:'anim.json', output:'out.mp4', width, height })` |

Runtime: Node.js (>=10; use current LTS), headless Chromium via Puppeteer.

## Artifact kind

**video** — primary deliverable is an MP4 muxed by ffmpeg from rendered frames. Secondary: GIF (gifski) and image sequence (PNG/JPG) from the same engine.

## Validation

- **install**: `npm install -g puppeteer-lottie-cli && brew install ffmpeg gifski`
- **smoke**: `curl -sL https://raw.githubusercontent.com/transitive-bullshit/puppeteer-lottie/master/fixtures/bodymovin.json -o /tmp/anim.json && puppeteer-lottie -i /tmp/anim.json -o /tmp/out.mp4 --width 512 && ls -l /tmp/out.mp4`
- **expect**: Headless Chromium renders frames, ffmpeg muxes them, and `/tmp/out.mp4` is a non-empty playable MP4 (`ls` size > 0). Swap `-o /tmp/out.gif` to exercise gifski, or `-o '/tmp/frame-%d.png'` for a deterministic image sequence.

## Wrapper params

- `motion-graphics.title` — text label embedded in the source/animation metadata
- `motion-graphics.width` — render width (px)
- `motion-graphics.height` — render height (px)
- `motion-graphics.background` — background color
- `motion-graphics.format` — output kind selector (mp4 / gif / png sequence)

Output kind is selected purely by the `-o` file extension, so the wrapper maps kind → extension (video=`.mp4`, image=`.png`/`frame-%d.png`, gif=`.gif`).

## Component / explorer notes

- Deliverable authored as Lottie/Bodymovin JSON — fully deterministic, diffable, version-controllable vector animation (IANA `video/lottie+json`, `.lot`/`.json`). Same JSON renders identically across runs; design lives in the JSON, not the renderer.
- Source the JSON from After Effects + Bodymovin export, `lottie-web` tooling, or hand-edited keyframes. `dotLottie` (`.lottie`) is the newer zipped container but this CLI consumes plain `.json`.
- Wrapper preflight cautions: tool is ~5 years stale and bundles an old Puppeteer/Chromium — on Apple Silicon / recent macOS you may need `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD` + `PUPPETEER_EXECUTABLE_PATH` pointing at a system Chrome, or fork-bump puppeteer. MP4 needs `ffmpeg` on PATH; GIF needs `gifski` on PATH — both runtime-resolved, so preflight-check them.
- For long-term reliability consider Playwright-based or `@lottiefiles/lottie` renderers as a more-maintained engine behind the same JSON contract.
