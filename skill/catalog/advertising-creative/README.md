# advertising-creative — Marketing/ad creative as code

Ad and marketing creative authored as code → render to email HTML, OG images, banners, and ad units.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|------|---------------|------------|----------------------|-----------|--------|----------|-------|
| [MJML](./mjml.md) | html | JS/Node (primary CLI); Python + Rust bindings | skill-email-html-mjml (community, not official) | no | ok | yes | yes |
| [react-email](./react-email.md) | html | Node / Bun / Deno (JSX → HTML via @react-email/render) | none (no official Anthropic/Claude skill) | no | ok | yes | yes |
| [maizzle](./maizzle.md) | html | Node-only: maizzle CLI, @maizzle/framework lib, Vite plugin | none (use maizzle.com/docs; no skill/llms.txt) | no | ok | yes | yes |
| [amphtml-ads](./amphtml-ads.md) | html | JS/Node (amphtml-validator) | AMPHTML/AMP4ADS docs (ampproject/amphtml, amp.dev) | no | ok | yes | yes |
| [htmlcsstoimage](./htmlcsstoimage.md) | image | shell/JS/Python/Ruby/PHP/C#/Go/VB.NET (HTTP clients) | HTML/CSS to Image MCP Server | yes | ok | yes | yes |

## Multi-toolchain notes

- **MJML** — JS/Node is the primary path (`npx mjml`); Python and Rust bindings exist but the Node CLI is canonical. Wrapper binds `advertising-creative.source` to `src/email.mjml`.
- **react-email** — JSX/TSX authored, rendered to static email HTML via `@react-email/render`. Any JS runtime (Node/Bun/Deno) works; step uses `npx tsx`.
- **maizzle** — Node-only (v18+). Pin the major: v5 = Vue SFC + Tailwind + Vite; v3/v4 = PostHTML — NOT interchangeable. Step ships a static `email.html` always-valid deliverable plus a v5 `template.html` source.
- **amphtml-ads** — single self-contained AMP4ADS `.html`; no build step. Validation is a pure markup pass/fail via `amphtml-validator`, no headless browser.
- **htmlcsstoimage** — only `image`-kind tool here. Hosted SaaS (hcti.io), NOT a local renderer: render needs API key + network round-trip and returns a CDN URL. Many language clients are just HTTP wrappers. Step degrades to writing `creative.html` source when `HCTI_USER`/`HCTI_KEY` unset.

Four of five tools are Node/JS-centric and emit HTML; only htmlcsstoimage produces a raster image (and is the only one needing credentials + network).

## VALIDATION ORDER

Cheapest / most-reliable installs first:

1. **amphtml-ads** — `npm i -g amphtml-validator`; pure markup pass/fail on a static `.html`, no build, no browser, fully offline. Most CI-friendly.
2. **MJML** — `npx -y mjml`; one CLI, renders headless to responsive HTML (~3.7KB) in one step, no network at render time.
3. **react-email** — `npm install` a handful of packages then `npx tsx`; headless, no browser, but heavier dependency install.
4. **maizzle** — `npx maizzle new ... --install` scaffolds a full project; build is headless but install is the largest. Pin the major version.
5. **htmlcsstoimage** — last: requires HCTI_USER/HCTI_KEY credentials + live network round-trip (free tier 50/mo). NOT fully offline; only validatable with secrets present.

## EXPLORER NEEDS

- **htmlcsstoimage** — wants a richer explorer than the default shell: render is a remote SaaS call returning a CDN image URL, so a fetch/preview surface (and credential plumbing) beats a pure local artifact shell.
- **maizzle / react-email / MJML** — HTML output benefits from an email-preview surface (rendered inbox view), but the default shell suffices for the build artifact.
- **amphtml-ads** — default shell is sufficient; validator output is plain pass/fail text.

## Dossiers

- [MJML](./mjml.md)
- [react-email](./react-email.md)
- [maizzle](./maizzle.md)
- [amphtml-ads](./amphtml-ads.md)
- [htmlcsstoimage](./htmlcsstoimage.md)
