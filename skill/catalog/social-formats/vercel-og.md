<!-- generated draft — needs validation -->
# @vercel/og (`vercel-og`) — social-formats

## Summary
`@vercel/og` turns JSX/HTML + a CSS subset into a PNG. It wraps Satori (HTML/CSS → SVG) and Resvg (SVG → PNG) behind an `ImageResponse` class. Primary use: dynamic Open Graph / social card images (recommended 1200×630). Marketed for Vercel Edge/Node functions and bundled into Next.js App Router as `next/og`, but `ImageResponse` extends the web `Response`, so in plain Node you can `await new ImageResponse(jsx, opts).arrayBuffer()` and write the bytes to a `.png` headlessly and deterministically (supply `fonts` explicitly for reproducible output). Latest npm 0.11.1 (~Feb 2026). No headless Chromium needed (~500KB, Satori + Resvg). For OOTA the deliverable is a deterministic image authored as version-controllable JSX/CSS.

## Skills / Docs
| Name | Type | URL | Official | License / Attribution |
|---|---|---|---|---|
| vercel/og official docs | documentation | https://vercel.com/docs/og-image-generation | official | Vercel docs — Vercel Inc. |
| vercel/og API reference | documentation | https://vercel.com/docs/og-image-generation/og-image-api | official | Vercel docs — Vercel Inc. |
| vercel/satori (core HTML/CSS→SVG engine) | repo | https://github.com/vercel/satori | official | MPL-2.0 — Vercel Inc. |
| @vercel/og on npm | package | https://www.npmjs.com/package/@vercel/og | official | Apache-2.0 — Vercel Inc. |

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| TS/JS (Node ≥18, also Edge/Workers) | `npm i @vercel/og react` | `import { ImageResponse } from '@vercel/og'`; build JSX; `const png = Buffer.from(await new ImageResponse(el,{width:1200,height:630,fonts:[...]}).arrayBuffer()); fs.writeFileSync('out.png', png)` |
| TS/JS (Next.js App Router) | bundled, no install | `import { ImageResponse } from 'next/og'`; return `new ImageResponse(...)` from `app/api/og/route.tsx` or `opengraph-image.tsx`. Pages Router + Node runtime NOT supported — use Edge runtime. |

For determinism pass explicit `fonts` (ttf/otf preferred) rather than runtime Google Fonts subsetting. Standalone driver = plain Node script, no framework.

## Artifact kind
**image** (PNG). SVG can be obtained one layer down via the `satori` package directly if an SVG deliverable is wanted instead.

## Validation
- **install**: `mkdir -p /tmp/og-smoke && cd /tmp/og-smoke && npm init -y >/dev/null 2>&1 && npm i @vercel/og react >/dev/null 2>&1`
- **smoke**: create `smoke.mjs` that builds a `div` element via `React.createElement`, instantiates `new ImageResponse(el,{width:1200,height:630})`, `Buffer.from(await res.arrayBuffer())`, `writeFileSync('out.png', buf)`, logs byte count + first 8 bytes. Run `node smoke.mjs && file out.png`.
- **expect**: writes `/tmp/og-smoke/out.png`; nonzero byte count, PNG magic `89504e470d0a1a0a`; `file` reports `PNG image data, 1200 x 630`. Note: without an explicit `fonts[]` entry @vercel/og fetches a default font over the network at runtime — supply a local ttf for fully offline/deterministic runs.

## Wrapper params
- `social-formats.title` (text) — card headline.
- `social-formats.subtitle` (text) — secondary line.
- `social-formats.bg` (color) — background.
- `social-formats.fg` (color) — text color.

## Component / explorer notes
Author the OG card as a JSX/TSX component using only the supported subset: `display:flex` (no grid), absolute positioning, flexbox layout, text wrap/center, nested `<img>`. Pass dynamic content (title, avatar URL) as props for reuse and diff-friendliness. Bundle fonts as committed ttf/otf and pass via `fonts` for byte-stable output. Keep total assets (JSX+CSS+fonts+images) under the 500KB bundle limit if targeting Vercel functions (no limit as a local Node script). Tailwind works via the experimental `tw` prop but inline style objects are most deterministic. macOS headless-clean: no GPU/Chromium dependency.
