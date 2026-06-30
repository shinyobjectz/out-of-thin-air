<!-- generated draft — needs validation -->
# comicgen

`comics-illustration / comicgen` — open-source comic-character SVG generator (Gramener).

## Summary

Comicgen (by Gramener) is an open-source, MIT-licensed comic-character generator. It maps a small set of named parameters (character name, camera angle, emotion, pose) to a fixed, pre-authored SVG of a cartoon character. Output is fully deterministic — identical params always emit byte-identical SVG markup — so it fits OOTA's version-controllable-code model: you commit a JSON/JS spec of characters+params and render headlessly to SVG (or rasterize to PNG).

It is NOT a generative-AI/diffusion tool; it composes layered SVG assets. Driven from Node (npm `comicgen` module + `comicserver` CLI), a hosted REST endpoint (`gramener.com/comicgen/v1/comic`), or a browser web component. Primary deliverable is SVG (PNG is a secondary rasterized form). Best for data-storytelling panels, illustrated docs, and dialogue strips rather than free-form AI comic art.

## Skills

_None._ No first-party or community OOTA skill ships for comicgen. License: **MIT** (Gramener comicgen). Asset library is shipped via **Git LFS** — a self-host clone needs `git-lfs` to pull the artwork.

## Toolchains

| lang | install | invoke |
|------|---------|--------|
| JavaScript/Node (>=14) | `npm install comicgen` (or `npm install -g comicgen` for the `comicserver` CLI; repo clone needs `git` + `git-lfs` to fetch SVG assets) | `const comicgen=require('comicgen'); const svg=comicgen({name:'ava',emotion:'cry',pose:'angry'});` returns an SVG string synchronously, no network. CLI: `comicserver` serves `http://localhost:3000/`. Docker: `docker run -p3000:3000 -it gramener/comicgen`. |
| HTTP/any (hosted REST, non-hermetic) | n/a | `GET https://gramener.com/comicgen/v1/comic?name=ethan&angle=side&emotion=wink&pose=normal` -> SVG (or `&ext=png`). Network-dependent; fallback only, not for reproducible builds. |
| HTML (browser, uifactory web component) | `<script src="https://cdn.jsdelivr.net/npm/uifactory@1.18.0/dist/uifactory.min.js" import="@comic-gen"></script>` | `<comic-gen name=ethan angle=side emotion=wink pose=normal ext=svg></comic-gen>`. Needs a DOM; not headless without a browser engine. `ext=png` for raster. |

**Preferred driver:** the npm module (synchronous, zero-network, deterministic).

## Artifact kind

**svg** (primary). PNG is a secondary rasterized form via resvg-js or sharp.

## Validation

- **install:** `npm install comicgen`
- **smoke:** `node -e "const c=require('comicgen'); const fs=require('fs'); const svg=c({name:'ava',emotion:'cry',pose:'angry'}); fs.writeFileSync('out.svg', svg); console.log('bytes', svg.length);"`
- **expect:** Creates `./out.svg` containing valid `<svg>...</svg>` markup for the Ava character (crying, angry pose); the same params always produce identical bytes. Open in any browser/Preview on macOS to view. (If npm asset paths require the server, fall back to: `comicserver &` then `curl 'http://localhost:3000/v1/comic?name=ava&emotion=cry&pose=angry' -o out.svg`.)

## Wrapper params

- `comics-illustration.title` (text) — strip / document title.
- `comics-illustration.name` (select: ava, ethan, dey, aryan) — character.
- `comics-illustration.angle` (select: front, side) — camera angle.
- `comics-illustration.emotion` (select: normal, cry, wink, smile, angry) — facial emotion.
- `comics-illustration.pose` (select: normal, angry, explaining) — body pose.
- `comics-illustration.dialogue` (text) — author-supplied speech-bubble text (composed outside the core SVG primitive).

## Component / explorer notes

A "comic" is authored as one or more character invocations: each panel = `{name, angle, emotion, pose, optionally width/x/y}`. Characters (ava, ethan, dey, aryan…) each expose a fixed enumerated set of angles/emotions/poses; the cross-product yields thousands of deterministic combinations.

Speech bubbles, panel layout, and multi-character scenes are NOT provided by the core SVG primitive — you compose them yourself by wrapping/positioning the returned SVG fragments inside an outer SVG or HTML grid (author-supplied `<text>`/`<path>` bubbles). Determinism is total: no seed, no model, params fully define output. Pin the comicgen version and vendor the LFS assets to keep builds reproducible and offline.
