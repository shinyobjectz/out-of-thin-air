<!-- generated draft — needs validation -->
# open-carrusel

## Summary
Open Carrusel (repo `Hainrixz/open-carrusel`, by tododeia / founder Enrique Rocha) is an MIT-licensed, AI-powered Instagram carousel builder. You chat with Claude (via the Claude CLI subprocess) to author slides as body-level HTML/CSS; the app renders each slide headlessly with Puppeteer (headless Chromium) and exports PNGs at exact Instagram pixel dimensions, then zips them via Archiver. Slides are deterministic HTML/CSS markup → screenshot, so the primary deliverable is **image (PNG)**. Fully local: data lives in `/data` and `/public/uploads`, nothing is sent to external cloud.

Three fixed aspect ratios:
- 1:1 → 1080×1080
- 4:5 → 1080×1350
- 9:16 → 1080×1920

## Skills
- **open-carrusel built-in Claude Code slash commands** (`/start`, `/stop`, `/reset`, `/doctor`) — community, **not** an Anthropic-published skill. License MIT. URL: https://github.com/Hainrixz/open-carrusel
  - Attribution: Hainrixz/open-carrusel (tododeia / Enrique Rocha). Project-local Claude Code commands shipped in the repo. `/start` bootstraps install+seed+dev server; designed to be driven from Claude Code.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| TypeScript/JavaScript (Node.js v20+) | `git clone https://github.com/Hainrixz/open-carrusel.git && cd open-carrusel && npm run setup` | `npm run dev` → http://localhost:3000 (Next.js 16 Turbopack, React 19, Tailwind v4, Radix UI, @dnd-kit, async-mutex) |
| Headless Chromium via Puppeteer | included by `npm run setup` (Puppeteer downloads its own Chromium) | `wrapSlideHtml()` in `src/lib/slide-html.ts` wraps body-level HTML into a full doc; Puppeteer screenshots each slide at exact Instagram dimensions to PNG |
| Natural language / agent (Claude CLI subprocess) | install Claude Code, run `claude` in repo, type `/start` | the AI agent that generates slide HTML/CSS is invoked as a Claude CLI subprocess — optional driver, not required for headless export |

## Artifact kind
**image** (PNG). A carousel is N PNGs zipped. The intermediate slide HTML/CSS is the authoring layer, not the deliverable.

## Validation
- **Install:** `git clone https://github.com/Hainrixz/open-carrusel.git && cd open-carrusel && npm run setup`
- **Smoke:** `npm run dev` (http://localhost:3000), create/seed a slide, trigger one-click export; or directly drive the `src/lib` export path: load a body-level HTML slide, run the Puppeteer screenshot at 1080×1080. Headless on macOS works since Puppeteer bundles Chromium.
- **Expect:** a PNG (or zip of PNGs) at exact Instagram dimensions, e.g. 1080×1080 for 1:1. Verify with `sips -g pixelWidth -g pixelHeight export.png` showing `pixelWidth: 1080 / pixelHeight: 1080`.

## Wrapper params
- `social-formats.title` (text) — slide headline/title text.
- `social-formats.ratio` (select: 1:1, 4:5, 9:16) → maps to 1080×1080 / 1080×1350 / 1080×1920.
- `social-formats.bg` (color) — slide background.
- `social-formats.body` (textarea, bound to `src/slide.html`) — body-level HTML/CSS markup for the slide.

## Component / explorer notes
Deliverable = Instagram carousel slides authored as deterministic body-level HTML/CSS (no `html`/`head` tags; wrapped by `wrapSlideHtml`). Brand config (name, palette, fonts, logo, style keywords) stored locally and read before each generation for on-brand output. Per-slide version history (undo). Each slide is independently version-controllable markup → a single PNG. A clean wrapper can bypass the Next.js UI: take slide HTML strings, apply `wrapSlideHtml`-equivalent wrapping, screenshot at the chosen Instagram dimension headlessly, emit PNG(s). Requires Node 20+ and Puppeteer's Chromium (auto-downloaded). MIT license permits embedding/forking.
