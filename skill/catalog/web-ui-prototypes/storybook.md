<!-- generated draft — needs validation -->
# Storybook + Playwright

slug: `storybook` · category: `web-ui-prototypes`

## Summary

Storybook authors UI components as isolated, version-controllable stories (deterministic `.stories.tsx/jsx` or `.mdx` files with args/decorators/play functions). Playwright drives a headless Chromium against a built/served Storybook to render each story and capture deterministic PNG screenshots — either via Playwright directly (`page.screenshot` / `toHaveScreenshot`) or via `@storybook/test-runner`, which transforms each story into an executable headless test (renders, runs the play function, asserts no errors).

Storybook 9 (2025) shifted its built-in test addon from the Jest+Playwright test-runner to a Vitest browser-mode addon (also Playwright/Chromium-backed). The standalone `@storybook/test-runner` (Jest+Playwright) is still maintained and is the canonical headless image path for OOTA.

Primary deliverable = deterministic component screenshots (**image**). Stories are HTML/JS markup; the headless render output is the image artifact.

## Skills

| Name | Type | Official | URL | License/Attribution |
|------|------|----------|-----|---------------------|
| webapp-testing | official-skill | yes | https://github.com/anthropics/skills | Anthropic official skills repo — Playwright-based web app testing skill (closest official match; no Storybook-specific official skill exists) |
| playwright-skill | community-skill | no | https://github.com/lackeyjb/playwright-skill | lackeyjb/playwright-skill — community Claude Code skill; writes+executes Playwright automation on the fly, returns screenshots/console output (check repo LICENSE) |
| Storybook test-runner docs | official-docs | yes | https://storybook.js.org/docs/writing-tests/integrations/test-runner | Storybook official docs (storybookjs/test-runner: https://github.com/storybookjs/test-runner). Portable stories for Playwright CT: https://storybook.js.org/docs/api/portable-stories/portable-stories-playwright |

No official Storybook Claude skill exists — community/docs only.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/TypeScript (Node.js >= 18 LTS; npm/yarn/pnpm) | `npm create storybook@latest` (scaffold); `npm i -D @storybook/test-runner playwright`; `npx playwright install --with-deps chromium` | Build: `npx storybook build -o storybook-static`. Headless screenshots: `npx test-storybook --ci` (test-runner) OR `npx playwright test` (raw Playwright against served Storybook). |

Playwright also has Python/.NET/Java bindings, but Storybook stories/config are JS/TS only, so the wrapper is Node-only. Node is the sole first-class driver.

## Artifact kind

**image** — deterministic PNG screenshots of rendered stories.

## Validation

Install:
```bash
npm create storybook@latest -- --yes my-sb && cd my-sb \
  && npm i -D @storybook/test-runner && npx playwright install --with-deps chromium
```

Smoke (build static Storybook, serve headlessly, screenshot one story to PNG):
```bash
npx storybook build -o storybook-static
npx http-server storybook-static -p 6006 &
npx wait-on tcp:6006
node -e "const {chromium}=require('playwright');(async()=>{const b=await chromium.launch();const p=await b.newPage();await p.goto('http://localhost:6006/iframe.html?id=example-button--primary&viewMode=story');await p.waitForSelector('#storybook-root button');await p.screenshot({path:'button-primary.png'});await b.close();})()"
# Alternative full-suite headless run:
npx test-storybook --ci --url http://localhost:6006
```

Expect: `button-primary.png` written to disk (deterministic PNG of the rendered Button/Primary story), exit code 0. test-storybook path prints PASS per story. Runs headless on macOS (Chromium from `playwright install`).

## Wrapper params

- `web-ui-prototypes.title` — story/component display title (text).
- `web-ui-prototypes.label` — button/label text rendered in the demo story (text).
- `web-ui-prototypes.viewport` — screenshot viewport width (range/select), for deterministic framing.

## Component / explorer notes

Deliverables authored as Storybook stories: `.stories.tsx/jsx` (or `.mdx`) = deterministic, version-controllable component definitions with args/decorators/play functions. A play function (Storybook-instrumented Testing Library + Vitest/Jest) runs after render to script interactions, so screenshots can capture post-interaction states deterministically. Components are framework-bound (React/Vue/Svelte/Angular/web-components).

Two driving modes:
1. `@storybook/test-runner`: Jest runner + Playwright/Chromium; transforms each story into a headless test. Add a `postVisit` hook calling `page.screenshot()` (or jest-image-snapshot / `toHaveScreenshot`) for visual snapshots.
2. Raw Playwright: navigate to `/iframe.html?id=<story-id>&viewMode=story` against a served `storybook-static`, then `page.screenshot` or `expect(page).toHaveScreenshot()` for VRT.

Storybook 9 replaced the built-in addon with a Vitest browser-mode addon (also Playwright-backed); the standalone test-runner remains the simplest headless image generator. Portable Stories API (Storybook 8.1+) lets stories run directly in Playwright Component Tests (React 18+/Vue3 experimental).

Determinism caveats: disable animations, pin fonts/locale/timezone, fix viewport, seed any randomness to keep screenshots byte-stable. For OOTA: pin Chromium version, run `--ci`, output PNGs to a tracked dir; the `.stories` files + screenshots are the version-controllable pair.
