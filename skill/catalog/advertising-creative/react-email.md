# react-email

## Summary

React Email (by Resend) is an open-source MIT framework for authoring responsive
HTML emails as React/TypeScript components. Templates render deterministically and
headlessly to email-client-safe HTML (and plain-text) strings via the
`@react-email/render` `render()` utility, or to static `.html` files via the
`email export` CLI command. This fits OOTA's model perfectly: deliverables are
version-controllable JSX/TSX source that compile to a single self-contained HTML
artifact with no runtime, network, or browser dependency. Runs on Node.js, Bun, and
Deno. Primary artifact kind is **html**.

## Skills

- **No official Anthropic/Claude skill** (`type: none`, `official: false`)
  - Source: https://github.com/resend/react-email
  - License: MIT
  - Attribution: Resend — `resend/react-email`. No Anthropic Skill or community
    Claude skill repo found as of 2026-06; agents drive it directly via the
    documented `render()` API and CLI.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| TS/JS (Node.js >=18) | `npm install -E react-email @react-email/render @react-email/components react react-dom` | `import { render } from '@react-email/render'; const html = await render(<Email/>, { pretty: true });` — async. Plain text via `render(comp, { plainText: true })`. CLI static export: `npx email export --outDir out --pretty`. Dev preview: `npx email dev`. |
| TS/JS (Bun) | `bun add @react-email/render @react-email/components react react-dom` | `bun run script.tsx` calling `await render(<Email/>)`. |
| TS/JS (Deno) | `deno add npm:@react-email/render npm:@react-email/components npm:react` | Import via `npm:@react-email/render`. Browser use needs web-streams-polyfill; Node/Bun/Deno do not. |

## Artifact kind

**html** — inline-styled, table-based HTML tuned for email clients (Gmail, Outlook,
Apple Mail). A self-contained single file, no runtime/network/browser dependency.

## Validation

- **Install:**
  ```bash
  mkdir -p /tmp/rev && cd /tmp/rev && npm init -y >/dev/null 2>&1 && \
  npm install -E @react-email/render @react-email/components react react-dom typescript tsx >/dev/null 2>&1
  ```
- **Smoke:**
  ```bash
  cat > /tmp/rev/email.tsx <<'EOF'
  import { render } from '@react-email/render';
  import { Html, Button, Text } from '@react-email/components';
  import { writeFileSync } from 'node:fs';
  const Email = () => (<Html><Text>Hello OOTA</Text><Button href="https://example.com">Buy</Button></Html>);
  const html = await render(<Email/>, { pretty: true });
  writeFileSync('/tmp/rev/out.html', html);
  console.log('bytes:', html.length);
  EOF
  cd /tmp/rev && npx tsx email.tsx
  ```
- **Expect:** Command exits 0, prints a positive byte count, and `/tmp/rev/out.html`
  exists containing a full `<!DOCTYPE html>...<table>`-based email with the
  `Hello OOTA` text and an anchor button. Fully headless on macOS — no browser, no
  network.

## Wrapper params

- `advertising-creative.title` (text) — heading/preview text for the email.
- `advertising-creative.body` (textarea) — body copy.
- `advertising-creative.cta_label` (text) — button label.
- `advertising-creative.cta_href` (text) — button link.
- `advertising-creative.source` (file → `src/email.tsx`) — the template source,
  editable in-place.

Recommended wrapper: a tiny tsx entry script (run via `tsx`/`bun`/`deno`) that imports
the template, calls `await render(component, { pretty: true })`, and writes the string
to a target `.html` path — full control over output filename and props. The
`email export` CLI is the alternative (scans `./emails`, writes `./out/*.html`,
`--pretty`/`--plainText`/`--minify`) but is less flexible for single-file/props-driven
output. `render()` is async — wrapper must await it. For a plain-text companion, emit
a second file with `{ plainText: true }`.

## Component / explorer notes

Deliverable source is a React component tree built from `@react-email/components`
primitives (Html, Head, Body, Container, Section, Row, Column, Button, Text, Heading,
Img, Hr, Link, Preview, Tailwind). Output is inline-styled, table-based HTML.
Determinism: `render()` is pure given props — same input yields identical HTML, so
artifacts are diff-able and version-controllable. Pass data via component props at
render time rather than templating strings. The Tailwind component compiles utility
classes to inline styles at render (still deterministic). No browser/Chromium needed
(unlike PDF/image tools), so headless macOS execution is trivial.
