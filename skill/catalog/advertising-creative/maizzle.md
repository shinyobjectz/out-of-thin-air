# maizzle — advertising-creative

## Summary
Maizzle is an open-source (MIT) framework for building production-ready, cross-client HTML emails. Modern versions (v5, 2025) are Vite-powered and author templates with Vue Single-File Components + Tailwind CSS; the toolchain is Node.js-only, driven via the `maizzle` CLI (or the JS library API / a Vite plugin). `maizzle build` compiles templates to deterministic, email-safe HTML with inlined CSS, Outlook fallbacks, and email-client-friendly class names — a fit for OOTA's deterministic, version-controllable, headless-rendering model. Output deliverable kind is HTML. It renders fully headlessly (no browser needed for the build itself; the dev `serve` uses a local server only for preview).

## Skills
- **No official Maizzle Claude skill / llms.txt** — none (official: no). <https://maizzle.com/docs> — Maizzle docs (canonical reference for an agent; no packaged skill exists). License: MIT (framework/docs). No Anthropic-official or Maizzle-official Agent Skill or llms.txt found as of 2026-06. Use the official docs as grounding context.
- **Community HTML-email skills (MJML-based, not Maizzle)** — community (official: no). <https://github.com/coreyhaines31/marketingskills> — closest community analog for HTML-email generation, but targets MJML, not Maizzle. License: see repo (typically MIT). No verified Maizzle-specific community skill found.

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| JS/TS (Node.js) — `maizzle` CLI | `npx maizzle new maizzle/maizzle my-emails --install` or `npm install -g maizzle` | `maizzle build production`; also `maizzle new`, `maizzle serve`/`dev`, `maizzle make:template\|layout\|component\|config`, `maizzle prepare` |
| JS/TS (Node.js) — `@maizzle/framework` library | `npm install @maizzle/framework` | import and call `build()` to compile programmatically (deterministic, headless path) |
| JS/TS (Node.js + Vite) — Maizzle Vite plugin | add Maizzle as a Vite plugin in an existing Vite/Laravel/Nuxt/SvelteKit/Astro app | same Node runtime; optional integration mode |

Node-only; no other language runtime drives it. Node LTS, v18+ recommended.

## Artifact kind
**html** — self-contained, email-client-safe HTML document.

## Validation
- **install**: `npx maizzle new maizzle/maizzle smoke-emails --install && cd smoke-emails`
- **smoke**: `npx maizzle build production`
- **expect**: Build completes with no browser; compiled `.html` files (inlined CSS, Outlook fallbacks) are emitted to the build output dir (default `build_production/`). Verify at least one file exists: `ls build_production/**/*.html`. Fully headless on macOS; requires Node.js.

## Wrapper params
- `advertising-creative.title` (text) — email subject/heading.
- `advertising-creative.preheader` (text) — preview text.
- `advertising-creative.body` (textarea) — main email copy.
- `advertising-creative.cta` (text) — call-to-action label.

## Component / explorer notes
Deliverable is a self-contained, email-client-safe HTML document: CSS inlined, email-safe class names, Outlook (MSO) conditional fallbacks, optional plaintext sibling. Modern v5 authors components as Vue SFCs + Tailwind utility classes that compile away at build time — emitted HTML carries no runtime JS/Vue dependency, so it is deterministic and self-contained for sending via any ESP. Older v3/v4 used PostHTML components rather than Vue; pin the version since the authoring model differs.

Drive via CLI `maizzle build <env>` or library `build()` for fully deterministic, headless builds — no headless browser required. For OOTA, treat the project dir (templates, layouts, components, config.*.js, tailwind config) as version-controlled source and `build_<env>/` HTML as the rendered artifact. Pin Maizzle major in package.json: v5 = Vue+Tailwind+Vite; v3/v4 = PostHTML — wrapper logic and templates are not interchangeable across that boundary. `maizzle serve` is preview-only (local HTTP), not needed in a headless render pipeline.
