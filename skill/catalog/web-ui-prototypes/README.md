# web-ui-prototypes

UI / components / prototypes authored as code, then headless-screenshotted or exported to image / svg / pdf / html.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [tldraw SDK](./tldraw.md) | svg | tldraw (npm React SDK); @kitschpatrol/tldraw-cli (Node + Puppeteer headless) | tldraw llms.txt docs (official) | yes | ok | yes | yes |
| [Storybook + Playwright](./storybook.md) | image | JS/TS (Node >= 18) | webapp-testing | yes | ok | yes | yes |
| [Playwright (HTML → screenshot)](./playwright.md) | image | JS/TS (Node >= 18); Python (>= 3.9) | webapp-testing | yes | ok | yes | yes |
| [frontend-design (Tailwind/shadcn)](./frontend-design.md) | html | html/css; JS/TS | frontend-design | yes | ok | yes | yes |

All four tools: official skill backing, all three build files (dossier / wrapper / step) freshly created, none pre-existed or skipped.

## Multi-toolchain notes

- **tldraw**: two distinct npm packages — the in-app React SDK (authoring) and the standalone `@kitschpatrol/tldraw-cli` (headless export). Export path needs a browser DOM (Puppeteer/Chromium), not pure Node. Step graceful-degrades: tldraw CLI > npx > install hint.
- **Playwright**: dual-language (Node JS/TS and Python). Either binds Chromium; pick by host project language. Step degrades gracefully when `node_modules/playwright` absent.
- **Storybook**: Node-only; stories + config are JS/TS. Pairs Storybook static build with Playwright/test-runner for the screenshot.
- **frontend-design**: HTML/CSS first; emits a self-contained `out/page.html` and degrades render via headless Chrome/Chromium with an install hint. JS/TS only when shadcn/Vite scaffold is used.

Every tool in this category ultimately depends on a real browser DOM for the visual artifact. None render purely in Node.

## Validation order

Cheapest / most-reliable installs first:

1. **frontend-design** — author static HTML, render via system headless Chrome (already on macOS). No npm install needed for the bare HTML path; lowest setup cost, highest reliability.
2. **Playwright (HTML → screenshot)** — `npm i -D playwright && npx playwright install chromium`. Single Chromium download, smoke is a one-liner `setContent` + `screenshot`.
3. **tldraw** — `npm i -g @kitschpatrol/tldraw-cli`; export a minimal `.tldr` to SVG/PNG. Pulls its own headless browser; ~1-2s startup.
4. **Storybook + Playwright** — heaviest: scaffold Storybook, add test-runner, `npx playwright install`, build static, serve, then screenshot/test-storybook. Most moving parts; validate last.

## Explorer needs

All four want a richer explorer than the default shell: each produces a visual artifact (svg/image/html) that must be rendered in a real browser DOM to validate. A headless-Chromium-backed explorer (or the Chrome DevTools MCP) that can open the emitted file and capture a screenshot is required for true verification — the shell alone can only confirm the file exists and is non-empty.
