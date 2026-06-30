# Playwright (HTML → screenshot)

- **slug**: `playwright`
- **category**: `web-ui-prototypes`
- **artifact kind**: `image`

## Summary

Playwright is a headless browser-automation framework (Chromium/Firefox/WebKit) from Microsoft. For OOTA it serves as a deterministic HTML→image renderer: author HTML/CSS as version-controlled source, load it headlessly via `page.setContent()` or a `file://` / `data:` URL, then call `page.screenshot({path})` to emit a PNG/JPEG. Supports viewport, `fullPage`, and element-clipped captures.

Determinism is achievable by pinning viewport size, `deviceScaleFactor`, disabling animations (`animations:'disabled'`), and pinning the browser version via the Playwright package lockfile. Drivable from Node (`npm playwright`) and Python (`pip playwright`), both fully supported on macOS headless.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| webapp-testing (Anthropic official skills) | skill | official | See repo LICENSE (Anthropic) | https://github.com/anthropics/skills |
| playwright-skill | skill | community | See repo (MIT-style community) | https://github.com/lackeyjb/playwright-skill |
| Playwright Plugin (Claude) | plugin | official | Anthropic plugin marketplace | https://claude.com/plugins/playwright |
| Playwright official docs — Screenshots | docs | official | Apache-2.0 (Playwright) | https://playwright.dev/docs/screenshots |

- **webapp-testing** — Anthropic public Agent Skills repo; writes/runs Playwright (or Puppeteer) headlessly and captures screenshots.
- **playwright-skill** — lackeyjb community Claude Code skill/plugin; Claude writes and executes Playwright automation on-the-fly, returns screenshots + console output.
- **Playwright Plugin (Claude)** — Anthropic official plugin exposing navigate/click/fill/screenshot/PDF/custom-script capabilities.
- **Playwright docs — Screenshots** — Microsoft; `page.screenshot` / `locator.screenshot`, `fullPage`, `clip` options.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/TypeScript (Node.js >=18) | `npm i -D playwright && npx playwright install chromium` | `node script.js` — `chromium.launch()`, `page.setContent(html)`, `page.screenshot({path:'out.png'})`. Browser binaries downloaded by `playwright install`. |
| Python (>=3.9) | `pip install playwright && playwright install chromium` | `python script.py` — `sync_playwright()`, `page.set_content(html)`, `page.screenshot(path='out.png')`. Headless by default. |

## Artifact kind

`image` — primary deliverable is a raster image (PNG default; JPEG/WebP optional via `type`/`quality`). Source of truth is the HTML/CSS markup (deterministic, version-controllable); the screenshot is the rendered build artifact.

## Validation

- **install**: `npm i -D playwright && npx playwright install chromium`
- **smoke**:
  ```bash
  node -e "const{chromium}=require('playwright');(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:800,height:600}});await p.setContent('<html><body style=\"font:48px sans-serif;display:grid;place-items:center;height:100vh;margin:0;background:#0b1020;color:#7ee\">OOTA</body></html>');await p.screenshot({path:'oota.png'});await b.close();})()"
  ```
- **expect**: Exits 0 and writes `oota.png` (800x600 PNG) in cwd; `file oota.png` reports `PNG image data, 800 x 600`. Fully headless, no display needed on macOS.

## Wrapper params

- `web-ui-prototypes.title` — text, page title/headline rendered into the HTML.
- `web-ui-prototypes.width` — viewport width (px).
- `web-ui-prototypes.height` — viewport height (px).
- `web-ui-prototypes.full_page` — toggle full-page capture.

## Component / explorer notes

For pixel determinism: pin viewport + `deviceScaleFactor`, set `animations:'disabled'` in screenshot opts, avoid system-font fallback by embedding/bundling fonts, and freeze the Playwright + Chromium version via package-lock so the renderer is reproducible across machines.

Thin wrapper: a small script (Node or Python) takes an HTML file path, loads it via `setContent` or a `file://` URL, and emits a screenshot to a deterministic output path. CLI shape: `render.js <input.html> <output.png> [--width N --height N --full-page]`. Can also emit PDF (`page.pdf`, Chromium-only) if the pdf kind is wanted instead of image. Treat HTML as the committed source and the PNG as a regenerable artifact (gitignore or store separately). Browser binary install (`playwright install chromium`) is a prerequisite step, not bundled with the npm/pip package.
