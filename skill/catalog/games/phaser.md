<!-- generated draft — needs validation -->
# Phaser

## Summary
Phaser is a free, open-source (MIT) 2D HTML5 game framework for desktop and mobile web, rendering via Canvas and WebGL. Current release v4.2.1 (June 2026). Games are authored in JavaScript or TypeScript and run in the browser. The natural OOTA deliverable is a self-contained **HTML** page that loads Phaser and a game scene — deterministic and version-controllable at the source level. Phaser also supports a HEADLESS render type plus jsdom + node-canvas for server-side execution that can emit single-frame PNG snapshots (`renderer.snapshot` / `canvas.toBuffer`), but that path is finicky and best-effort. Confidence: medium — HTML output is rock-solid; headless image capture is supported but brittle across versions.

## Skills
- **phaser (game-creator collection)** — community, unofficial — https://crossaitools.com/skills/opusgamelabs/game-creator/phaser — license: unspecified (check repo) — attribution: opusgamelabs / game-creator skill collection
- **phaser-gamedev** — community, unofficial — https://lobehub.com/skills/pmarashian-cursor-agent-skills-phaser-gamedev — license: unspecified (check repo) — attribution: pmarashian/cursor-agent-skills
- **Phaser Game Development (Claude Code skill)** — community, unofficial — https://mcpmarket.com/tools/skills/phaser-game-development — license: unspecified — attribution: MCP Market listing
- **Official Phaser API + docs** — official-docs — https://docs.phaser.io/api-documentation/api-documentation — license: MIT (framework) — attribution: Phaser Studio Inc.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript | `npm install phaser` | Include Phaser via CDN (`https://cdn.jsdelivr.net/npm/phaser@4/dist/phaser.min.js`) or node_modules in an HTML file; `new Phaser.Game({type: Phaser.AUTO, scene})` boots the game in the page. |
| TypeScript | `npm install phaser typescript vite` | Phaser ships full TS definitions; official Vite/React/Vue/Svelte templates exist. Build to a static HTML+JS bundle. |
| JavaScript (headless/server) | `npm install phaser jsdom canvas` | Run with `type: Phaser.HEADLESS` (logic only) or Canvas renderer under jsdom + node-canvas for offscreen draw; capture a frame with `game.renderer.snapshot(...)` or `canvas.toBuffer('image/png')` → `fs.writeFile`. Brittle; pin versions. |

## Artifact kind
**html** — the primary deliverable is a single committable `index.html` (plus optional bundled JS/asset folder) that boots a `Phaser.Game` and renders a scene in-browser. Deterministic at the source level.

## Validation
- **install**: `mkdir -p /tmp/phaser-smoke && cd /tmp/phaser-smoke && npm init -y && npm install phaser`
- **smoke**: Write `index.html` that loads phaser (node_modules or CDN) with a single Scene whose `create()` draws a rectangle and text, then render headlessly: `npx playwright install chromium && node -e "const{chromium}=require('playwright');(async()=>{const b=await chromium.launch();const p=await b.newPage();await p.goto('file:///tmp/phaser-smoke/index.html');await p.waitForTimeout(1000);await p.screenshot({path:'/tmp/phaser-smoke/out.png'});await b.close();})()"`
- **expect**: `out.png` exists (non-zero PNG) showing the rendered Phaser canvas with the drawn rectangle + text; `index.html` is the deterministic, committable deliverable. Runs headless on macOS with no display.

## Wrapper params
- `games.title` (text) — game title shown in the scene.
- `games.cdn` (text) — Phaser CDN/version pin (default `phaser@4.2.1`).

## Component / explorer notes
Primary deliverable = a single committable `index.html` (plus optional bundled JS/asset folder) that boots a `Phaser.Game` and renders a scene in-browser. Deterministic at source level; runtime visuals depend on the game loop, so for a fixed image OOTA should drive the page with a headless browser (Playwright/Puppeteer) and snapshot a frame, or pause the loop after a known tick. Phaser's HEADLESS mode runs logic without producing pixels — use the **Canvas renderer** (not HEADLESS) when an image is the goal. Wrap as: (1) html generator emitting `index.html` embedding Phaser (CDN-pinned to `phaser@4.2.1` or vendored) + the scene script — the default OOTA artifact; (2) optional image variant running Playwright/Puppeteer headless to screenshot the canvas at a deterministic tick. Avoid the jsdom+node-canvas route as the default (version-fragile, no WebGL); prefer real headless Chromium for fidelity. Pin Phaser and browser versions for reproducibility.
