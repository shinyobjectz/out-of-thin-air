# frontend-design (Tailwind/shadcn)

**Slug:** `frontend-design` · **Category:** `web-ui-prototypes` · **Artifact kind:** `html`

## Summary

`frontend-design` is an official Anthropic Claude Skill (Apache-2.0) that is pure
design **guidance** — no scripts, no bundled code. It steers Claude toward
distinctive, non-templated UI: an opinionated palette/typography/layout, a single
"signature" element, restraint, and intentional copy. It produces deterministic,
version-controllable HTML/CSS/JSX markup.

For OOTA the deliverable kind is `html` — a self-contained page or component that
renders headlessly in any browser/Chromium. The "Tailwind/shadcn" framing names the
styling stack you typically pair with it: Tailwind CSS v4 utilities + shadcn/ui
component source dropped into your project via the shadcn CLI (both Node/npm-driven).
The skill itself is framework-agnostic guidance, so the toolchain is whatever you
render the markup with: a browser for plain HTML, or Node + Tailwind + shadcn for
component-based pages.

Workflow the skill enforces: brainstorm → plan (token system: 4–6 hex palette,
2+ typefaces, layout concept, signature element) → critique → build → critique.

## Skills

| Name | Type | Official | License | Source |
|------|------|----------|---------|--------|
| frontend-design | skill | **Official (Anthropic)** | Apache-2.0 | https://github.com/anthropics/claude-code |
| shadcn/ui | component-library | Community (shadcn, Vercel-adjacent) | MIT | https://ui.shadcn.com/docs/cli |
| Tailwind CSS | css-framework | Community (Tailwind Labs) | MIT | https://ui.shadcn.com/docs/tailwind-v4 |

- **frontend-design** — local copy at
  `/Users/shinyobjectz/.claude/plugins/marketplaces/claude-plugins-official/plugins/frontend-design/skills/frontend-design/SKILL.md`
  (LICENSE.txt = Apache 2.0). Guidance-only; no executable assets.
- **shadcn/ui** — companion component source. CLI v4 (March 2026) supports Tailwind v4 /
  React 19. Copy-in source model, not a runtime dep.
- **Tailwind CSS** — v4 uses the `@theme` directive; `shadcn init` adds an `@import` for
  shared utilities.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| html/css | none — plain `.html` renders directly | open in Chromium headless to snapshot |
| javascript/typescript (Node >=18) | `npx shadcn@latest init` then `npx shadcn@latest add button card …` and `npm i tailwindcss@4` | build to static HTML via Vite/Next (`npm run build`) |

Simplest path: skill emits a single self-contained HTML+CSS file, no build step.
Component path: Node + Vite/Next + Tailwind v4 + shadcn → static HTML.

## Artifact kind

`html` — self-contained page/component markup + CSS. Renders headlessly in any
browser/Chromium for snapshots.

## Validation

- **install:**
  `npm create vite@latest demo -- --template react-ts && cd demo && npm i && npm i tailwindcss@4 @tailwindcss/vite && npx shadcn@latest init -d && npx shadcn@latest add button`
- **smoke:** build a page from the guidance and emit a static file (`npm run build`,
  verify `dist/index.html`); OR no-build path — render a hand-authored page headless:
  `'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --headless --disable-gpu --screenshot=out.png --window-size=1280,800 file:///abs/path/page.html`
- **expect:** a non-empty `out.png` (or `dist/index.html`) produced headlessly with no
  errors; the page reflects the planned token system (palette/type/signature). Exit 0.

## Wrapper params

- `web-ui-prototypes.title` (text) — page/headline title.
- `web-ui-prototypes.concept` (textarea) — layout concept + signature element plan.
- `web-ui-prototypes.palette` (text) — 4–6 hex palette.
- `web-ui-prototypes.accent` (color) — primary accent color.

## Component / explorer notes

Primary deliverable = `html`. The skill is guidance, not a generator: it constrains
every color/type decision to an explicit token plan and avoids the three AI-default
looks (cream+serif+terracotta; near-black+acid accent; broadsheet hairline).

Determinism: pin font sources (self-host or pinned CDN), avoid randomized animation
seeds, commit emitted HTML/CSS so renders are reproducible. Quality floor it enforces:
responsive to mobile, visible keyboard focus, `prefers-reduced-motion` respected.

Wrapper treats this as an html-kind producer with two render modes: (1) no-build —
author one self-contained `.html`, snapshot via headless Chrome on macOS; (2)
component build — Node + Vite/Next + Tailwind v4 + shadcn, `npm run build` then
snapshot. Keep `node_modules` out of version control; commit source markup +
`components.json` + pinned versions. The skill carries no binaries — the wrapper only
surfaces SKILL.md guidance and supplies the chosen render toolchain. Watch CSS
specificity collisions (class vs element selectors) flagged in the skill.
