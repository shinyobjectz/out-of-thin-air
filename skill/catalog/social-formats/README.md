# social-formats

Fixed-spec social creative (OG cards, carousel slides, story frames) rendered to image/SVG at exact platform dimensions.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [@vercel/og](./vercel-og.md) | image | TS/JS (Node >=18, Edge/Workers); TS/JS (Next.js App Router via `next/og`) | vercel/og official docs | yes | ok | yes | yes |
| [resvg-js](./resvg-js.md) | image | JS/TS (Node 12-22, native napi-rs); Bun 0.8.1+; Deno 1.26.1+; WASM (`@resvg/resvg-wasm`) | resvg-js README + docs | yes | ok | yes | yes |
| [open-carrusel](./open-carrusel.md) | image | TS/JS (Node v20+); headless Chromium via Puppeteer; Claude CLI subprocess | open-carrusel built-in slash commands (`/start`, `/stop`, `/reset`, `/doctor`) | no | ok | yes | yes |

All three emit `image` artifacts (PNG). HTML/CSS or SVG is the authoring/source layer; the image is the deliverable.

## Multi-toolchain notes

- **@vercel/og** — same `ImageResponse` (Satori + Resvg, no Chromium) runs headless plain-Node, Edge/Workers, or wired into Next.js App Router via `next/og`. Determinism caveat: pass local `fonts[]` for offline / byte-stable output; default remote font fetch is non-deterministic.
- **resvg-js** — one API across Node (native napi-rs prebuilds), Bun, Deno, and a WASM build for browsers/locked-down runtimes. Native path is fastest; WASM path is the portability fallback when native binaries can't load. `loadSystemFonts` toggle governs font resolution.
- **open-carrusel** — heaviest stack: needs Node v20+, a headless Chromium (Puppeteer), and a Claude CLI subprocess for the authoring loop. The step degrades to a standalone Puppeteer screenshot of body-level slide HTML when the full app isn't running.

## Validation order

Cheapest / most reliable first:

1. **resvg-js** — `npm i @resvg/resvg-js`; single native dep, fully headless on macOS, no browser. Smoke: render SVG -> 400x200 PNG, assert PNG magic + byte count.
2. **@vercel/og** — `npm i @vercel/og react`; pure-JS Satori+Resvg, no Chromium. Smoke: `node smoke.mjs` writes `out.png` 1200x630; verify `file` reports `PNG image data, 1200 x 630`. (Supply local fonts to avoid network during smoke.)
3. **open-carrusel** — heaviest: `git clone` + `npm run setup`, pulls Chromium and depends on Claude CLI. Smoke: `npm run dev` seed+export, or Puppeteer screenshot at 1080x1080; verify `sips -g pixelWidth -g pixelHeight slide.png`.

## Explorer needs

- **resvg-js**, **@vercel/og** — default shell explorer suffices; headless, no GUI, deterministic byte output once fonts are local.
- **open-carrusel** — wants a richer explorer than the default shell: headless Chromium (Puppeteer) plus a Claude CLI subprocess and the dev server on `http://localhost:3000`. Provision a browser-capable environment for the full authoring loop; the Puppeteer-screenshot fallback is the shell-only degradation path.

## Tool dossiers

- [./vercel-og.md](./vercel-og.md)
- [./resvg-js.md](./resvg-js.md)
- [./open-carrusel.md](./open-carrusel.md)
