# comics-illustration

Sequential art / illustration as code — deterministic, headless generation of comic characters, sketchy vector art, and paneled speech-bubble layouts to SVG/PNG/HTML.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Official? | Status | Wrapper? | Step? |
|------|------|-----------|---------------|-----------|--------|----------|-------|
| [comicgen](./comicgen.md) | svg | JS/Node (npm comicgen); HTTP/REST (hosted, non-hermetic); HTML (uifactory web component) | none | no | ok | yes | yes |
| [Rough.js](./rough-js.md) | svg | JS/TS (Node >=14, roughjs); JS browser/DOM (roughjs + jsdom) | rough-stuff/rough (repo + wiki) | no | ok | yes | yes |
| [CSS Grid + balloon.css](./balloon-css.md) | html | HTML/CSS; JS/Node | balloon.css (library, not a skill) | no | ok | yes | yes |

## Multi-toolchain notes

- **comicgen** — npm module is the deterministic, zero-network primary driver (identical params → byte-identical SVG). PNG is secondary via resvg-js/sharp. Hosted REST (`curl localhost:3000/v1/comic` against comicserver) is a non-hermetic fallback only. Assets ship via Git LFS, so self-host clones need `git-lfs`. Bubbles, layout, and multi-character composition are NOT core primitives — the wrapper must compose them.
- **Rough.js** — headless deterministic path is `rough.generator()` + `toPaths()` (zero extra deps); the step emits a minimal valid SVG then graceful-degrades to a real render when `node` + `node_modules/roughjs` are present. A `seed` is required on every shape for byte-stable output. Browser/DOM path needs jsdom.
- **balloon.css** — deliverable is static HTML consuming a vendored `balloon.min.css`; step vendors the CSS via curl and graceful-degrades to a Playwright raster.

## Validation order (cheapest / most reliable first)

1. **Rough.js** — `npm install roughjs` in a scratch dir; pure-Node generator path, no network at smoke time, byte-stable with seed.
2. **comicgen** — `npm install comicgen` then `node -e` render to `out.svg`; deterministic but pulls Git LFS assets.
3. **CSS Grid + balloon.css** — `curl` vendors `balloon.min.css`; requires network fetch and (for raster) a browser, so least hermetic.

## Explorer needs

- **comicgen** and **CSS Grid + balloon.css** benefit from a richer explorer than the default shell: a headless browser (Playwright/Chromium) to visually verify rendered SVG characters and the forced-open tooltip bubbles / CSS Grid panel layout. Rough.js validates fine in the plain shell (text SVG diff).
