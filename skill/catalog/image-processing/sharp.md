# sharp

## Summary

`sharp` is the fastest Node.js image-processing module — a high-level binding over the libvips C library. It reads JPEG/PNG/WebP/AVIF/GIF/TIFF/SVG and writes raster image files (plus raw pixel buffers): resize, rotate, extract, composite, recolor, and format-convert at 4-5x ImageMagick speed with low memory. Fully deterministic and headless, which makes it ideal for code-authored image deliverables in OOTA. Native prebuilt binaries ship for macOS (x64 + arm64), so no system libvips install is required.

Latest release 0.35.2 (verified via local install, June 2026). Requires Node `^18.17.0` or `>=20.3.0` with Node-API v9. It is **not** a CLI and **not** a Python tool — driven exclusively from the Node.js / JS-runtime ecosystem.

## Skills

| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| anthropics/skills (Agent Skills repo) | skill-repo | https://github.com/anthropics/skills | official | varies per skill (many Apache-2.0) | Anthropic. No dedicated sharp skill exists; image-processing covered ad hoc. |
| sharp official documentation (pixelplumbing) | docs | https://sharp.pixelplumbing.com/ | official | Apache-2.0 (project) | Lovell Fuller and contributors |
| travisvn/awesome-claude-skills | community-skill-list | https://github.com/travisvn/awesome-claude-skills | community | see repo | Community-curated; no sharp-specific skill listed as of 2026. |

## Toolchains

| Lang | Runtime | Install | Invoke |
|------|---------|---------|--------|
| JavaScript/TypeScript | Node.js (`^18.17.0` or `>=20.3.0`, Node-API v9) | `npm install sharp` | `require('sharp')` / `import sharp from 'sharp'`. Prebuilt libvips auto-downloads for macOS arm64+x64 — no Homebrew libvips. Verified on macOS arm64 (Node v25.6.1). |
| JavaScript/TypeScript | Bun | `bun add sharp` | Works via Bun's Node-API compatibility; same require/import API. |
| JavaScript/TypeScript | Deno | `import sharp from 'npm:sharp'` | Deno npm compat layer; needs `--allow-read`/`--allow-write`/`--allow-ffi`. |

## Artifact kind

**image** — primary deliverable is a raster image file (PNG/JPEG/WebP/AVIF/GIF/TIFF) written via `.toFile()`.

## Validation

**Install**
```bash
mkdir -p /tmp/sharptest && cd /tmp/sharptest && npm init -y && npm install sharp
```

**Smoke**
```bash
node -e "const sharp=require('sharp');sharp({create:{width:200,height:120,channels:3,background:{r:30,g:144,b:255}}}).png().toFile('/tmp/sharp_out.png').then(async()=>{const m=await sharp('/tmp/sharp_out.png').metadata();console.log(m.format,m.width,m.height)});"
```

**Expect**
Prints `png 200 120` and `/tmp/sharp_out.png` exists as a valid 200x120 8-bit RGB PNG (`file(1)` confirms `PNG image data, 200 x 120, 8-bit/color RGB`). Runs fully headless, no display server. Verified June 2026 with sharp 0.35.2 on macOS arm64.

## Wrapper params

- `image-processing.title` — label/text used by demo source.
- `image-processing.width` / `image-processing.height` — output dimensions.
- `image-processing.format` — output codec (png/jpeg/webp/avif).
- `image-processing.background` — fill color.

A thin wrapper is a small Node script (ESM or CJS) taking input path(s) + params and calling the fluent `sharp()` chain ending in `.toFile(out)`.

## Component / explorer notes

Deterministic given identical input + options, so it version-controls cleanly as a build step (commit the source script + inputs, regenerate outputs). Sharp does **not** author vector/SVG output (it rasterizes SVG input) and is not a renderer for HTML/video — pair it with a renderer when those kinds are needed. Common OOTA role: a post-processing/transcoding stage (resize, format-convert, composite watermark/overlay, generate thumbnails/social cards, flatten layers) downstream of an SVG/HTML/canvas generator.

**Wrapper gotchas:** (1) sharp is ESM-unfriendly for `NODE_PATH` — install locally in the project, do not rely on a global install resolved via `NODE_PATH` (ESM `ERR_MODULE_NOT_FOUND`). (2) Its package.json blocks the `./package.json` export subpath, so read the version another way. (3) Operations are async (Promise-based); await before reading metadata. (4) For reproducible builds, pin compression effort/quality flags explicitly since codec defaults can shift across libvips versions. Apache-2.0 licensed.
