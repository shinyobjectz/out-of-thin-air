# Satori (HTML/CSS → SVG)

slug: `satori` · category: `graphic-design` · artifactKind: `svg`

## Summary

Satori (`vercel/satori`, MPL-2.0, v0.27.0 as of Apr 2026) is a deterministic JS/TS
library that converts a JSX/HTML + inline-CSS element tree into an SVG string. It
implements a Flexbox subset (same engine lineage as Yoga/React Native) plus
typography, gradients, and borders — it is NOT a full CSS engine. Pure JavaScript
with no native deps, so it runs identically in Node, Bun, Deno, the browser, Web
Workers, and edge runtimes (Cloudflare Workers, Vercel Edge).

Output is a stable SVG string: given the same input and the same embedded fonts it
is byte-deterministic, making it ideal for version-controllable headless rendering.
Fonts must be supplied explicitly as ArrayBuffer/Buffer (TTF/OTF/WOFF; WOFF2 NOT
supported) — there is no system-font fallback, which is exactly what guarantees
determinism. The primary deliverable is SVG; the common downstream is SVG→PNG via
`@resvg/resvg-js` (or `resvg-wasm` on edge). No official Anthropic/Claude skill
exists; usage is well documented in Vercel's OG-image docs and community recipes.

## Skills

| Name | Type | Official | License | Attribution | URL |
|------|------|----------|---------|-------------|-----|
| Satori README + API docs | docs | official | MPL-2.0 | Vercel, Inc. | https://github.com/vercel/satori |
| Vercel OG Image Generation docs (`@vercel/og` wraps Satori) | docs | official | docs | Vercel, Inc. | https://vercel.com/docs/og-image-generation |
| satori-html — raw HTML string → Satori VNode (no JSX) | community-adapter | community | MIT | Nate Moore (natemoo-re) | https://github.com/natemoo-re/satori-html |
| Generate Image From HTML Using Satori and Resvg | community-guide | community | article | Anas Rin | https://dev.to/anasrin/generate-image-from-html-using-satori-and-resvg-46j6 |
| 6 Pitfalls of Satori + resvg-wasm on Cloudflare Workers | community-guide | community | article | devoresyah | https://dev.to/devoresyah/6-pitfalls-of-dynamic-og-image-generation-on-cloudflare-workers-satori-resvg-wasm-1kle |

## Toolchains

| Lang | Runtime | Install | Invoke |
|------|---------|---------|--------|
| JS/TS | Node.js 16+ | `npm install satori` | `const svg = await satori(element, { width, height, fonts: [{name,data,weight,style}] })` — element is JSX or a satori-html VNode; returns SVG string; `fonts` mandatory |
| JS/TS | Bun | `bun add satori` | runs unchanged; read fonts via `Bun.file()`/`readFileSync`, then `await satori(...)` |
| JS/TS | Deno | `import satori from 'npm:satori'` | `deno run --allow-read script.ts`; same API |
| JS/TS | Edge (CF Workers / Vercel Edge) | `npm install satori @resvg/resvg-wasm` | pure-JS path; pair with resvg-wasm (`initWasm` once) since native resvg-js is unavailable on Workers |
| JS/TS | Node.js (SVG→PNG step) | `npm install @resvg/resvg-js` | `new Resvg(svg).render().asPng()` to rasterize; or use sharp |

## Artifact kind

`svg` — Satori's primary deliverable is a stable SVG string. PNG is an optional
downstream rasterization via resvg.

## Validation

Install:
```bash
mkdir -p /tmp/satori-smoke && cd /tmp/satori-smoke && npm init -y >/dev/null 2>&1 \
  && npm install satori satori-html @resvg/resvg-js >/dev/null 2>&1 \
  && curl -sL -o font.ttf https://github.com/google/fonts/raw/main/ofl/inter/static/Inter-Regular.ttf
```

Smoke:
```bash
node -e "const fs=require('fs');const satori=require('satori').default;const {html}=require('satori-html');const {Resvg}=require('@resvg/resvg-js');(async()=>{const m=html\`<div style=\"width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#0b1021;color:#fff;font-size:48px\">Out Of Thin Air</div>\`;const svg=await satori(m,{width:600,height:315,fonts:[{name:'Inter',data:fs.readFileSync('font.ttf'),weight:400,style:'normal'}]});fs.writeFileSync('out.svg',svg);fs.writeFileSync('out.png',new Resvg(svg).render().asPng());console.log('ok');})()"
```

Expect: prints `ok`; emits `/tmp/satori-smoke/out.svg` (valid `<svg>` string with
`<path>` glyph data) and `out.png` (600x315 raster). Fully headless on macOS, no
browser/display needed. Note: `.default` is needed in CommonJS `require`; ESM uses
a default import.

## Wrapper params

The OOTA wrapper should take a component module + props + an explicit font manifest
(paths to TTF/OTF/WOFF bundled in-repo, never system fonts) + `{width,height}`; call
`satori()` to produce the SVG deliverable (primary `artifactKind=svg`), writing it
deterministically to disk; and optionally pipe SVG→PNG via `@resvg/resvg-js` (Node)
or `@resvg/resvg-wasm` (edge). Pin satori + resvg versions and check fonts into the
repo to guarantee byte-stable output. Prefer satori-html for HTML-string inputs so
authors needn't compile JSX. `@vercel/og` bundles satori+resvg but is
Vercel-runtime-flavored; raw satori + resvg-js is the portable headless choice.
Watch: WOFF2 unsupported (convert to WOFF/TTF first); non-flex multi-child nodes
throw; remote images add nondeterminism (inline as data URIs).

## Component / explorer notes

A Satori "component" is a pure, stateless JSX element (or satori-html VNode) styled
with INLINE CSS only — no `className`/stylesheets, no `useState`/`useEffect`/
`dangerouslySetInnerHTML`. Layout is Flexbox-only (default display is `flex`;
elements with >1 child must declare `display:flex`). Supports a subset: flexbox,
`position` absolute/relative, background gradients, borders, border-radius,
box-shadow, transforms, text/typography, `img` (data: or remote URL), and `svg`.
Every font used must be passed explicitly in `fonts[]`; emoji needs a
`graphemeImages`/`loadAdditionalAsset` handler. Author as code: keep components as
`.tsx` files returning a JSX tree, or as HTML template strings via satori-html — both
version-controllable and deterministic.
