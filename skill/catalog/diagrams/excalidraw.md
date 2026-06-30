<!-- generated draft — needs validation -->
# Excalidraw (@excalidraw/utils)

- **Slug:** `excalidraw`
- **Category:** `diagrams`
- **Artifact kind:** `svg` (raster `png` also supported)

## Summary

Excalidraw is a hand-drawn-style whiteboard/diagram tool. Diagrams are stored as a
deterministic, version-controllable JSON document (`.excalidraw` — a flat array of shape
elements + `appState`). The official `@excalidraw/utils` package (UMD/ESM) exposes
`exportToSvg` / `exportToBlob` / `exportToCanvas` to render that JSON to SVG or raster.

The official utils assume a browser DOM, so the practical deterministic headless path on
macOS is the community CLI `@swiftlysingh/excalidraw-cli` (MIT), which wraps
`@excalidraw/utils` with bundled fonts and a DOM shim and emits `.svg` / `.png` from
`.excalidraw` JSON via a single command. Primary deliverable kind: **svg** (raster png also
supported).

## Skills

| Skill | Type | Official | License | URL | Attribution |
|---|---|---|---|---|---|
| Excalidraw Export Utilities (developer docs) | docs | yes | MIT | https://docs.excalidraw.com/docs/@excalidraw/excalidraw/api/utils/export | Excalidraw — docs.excalidraw.com |
| `@excalidraw/utils` (npm package) | library-docs | yes | MIT | https://www.npmjs.com/package/@excalidraw/utils | Excalidraw / excalidraw GitHub org |
| excalidraw-render-mcp (headless render MCP) | community-repo | no | see repo | https://github.com/bassimeledath/excalidraw-render-mcp | bassimeledath |
| No official Anthropic/Claude skill exists for Excalidraw as of 2026-06 | note | no | n/a | https://docs.excalidraw.com/docs/@excalidraw/excalidraw/api/utils/export | research note |

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JS/TS (Node >=20.19) | `npm install -g @swiftlysingh/excalidraw-cli` (or `brew tap swiftlysingh/tap && brew install excalidraw-cli`) | `excalidraw-cli convert diagram.excalidraw --format svg` — or Node API `import { convertToSVG, convertToPNG, createFlowchartFromJSON } from '@swiftlysingh/excalidraw-cli'`. MIT; bundles fonts + DOM shim, runs headless on macOS with no browser. **Recommended deterministic path.** |
| JS/TS (browser DOM assumed) | `npm install @excalidraw/utils` | `import { exportToSvg, exportToBlob, exportToCanvas } from '@excalidraw/utils'`; `exportToSvg({elements, appState, files, exportPadding})` -> `Promise<SVGElement>`. Designed for the browser; in raw Node you must supply jsdom + a canvas polyfill (node-canvas) and globals — fragile, prefer the CLI. |
| JS/TS (Node) | `npm install -g excalidraw_export` (Timmmm) | Alternative CLI; exports `.excalidraw` to SVG and optionally PDF with working fonts. Use if PDF output is needed. |

## Artifact kind

`svg` — `exportToSvg` renders `elements[]` to an `<svg>` document. Raster `png` available via
`exportToBlob` / `--format png --scale 2`; PDF via `excalidraw_export`.

## Validation

**Install:**
```bash
npm install -g @swiftlysingh/excalidraw-cli
```

**Smoke:**
```bash
cat > /tmp/d.excalidraw <<'EOF'
{"type":"excalidraw","version":2,"source":"https://excalidraw.com","elements":[{"id":"a","type":"rectangle","x":100,"y":100,"width":200,"height":100,"angle":0,"strokeColor":"#1e1e1e","backgroundColor":"#a5d8ff","fillStyle":"solid","strokeWidth":2,"strokeStyle":"solid","roughness":1,"opacity":100,"seed":1,"version":1,"versionNonce":1,"isDeleted":false,"groupIds":[],"boundElements":[],"updated":1,"link":null,"locked":false}],"appState":{"viewBackgroundColor":"#ffffff"},"files":{}}
EOF
excalidraw-cli convert /tmp/d.excalidraw --format svg --output /tmp/d.svg && head -c 200 /tmp/d.svg
```

**Expect:** Exit 0; `/tmp/d.svg` created containing a valid `<svg ...>` root with a
hand-drawn-style blue rectangle path. `head` prints the SVG XML/`<svg>` opening tag. Output is
deterministic for a fixed `seed`/`version` and version-controllable.

## Wrapper params

- `diagrams.title` (text) — diagram title / label seed.

## Component / explorer notes

Deliverable source-of-truth is the `.excalidraw` JSON: a `type:"excalidraw"` document with a
flat `elements[]` array (each shape carries explicit x/y/width/height/seed/strokeColor/etc.), an
`appState` (viewBackgroundColor, etc.), and a `files` map for embedded images. Fully
deterministic and diff-friendly. The `seed`/`versionNonce` fields drive the rough.js hand-drawn
jitter; **pin them for byte-stable renders**. `exportToSvg` renders elements->SVG;
`exportToBlob`->png/jpeg; `exportToCanvas` for custom compositing.

OOTA wrapper should author/emit the `.excalidraw` JSON, then shell out to
`excalidraw-cli convert <file> --format svg --output <out>` for the primary svg artifact (add
`--format png --scale 2` for raster, or `excalidraw_export` for PDF). Prefer the CLI over calling
`@excalidraw/utils` directly — the official utils need a browser DOM, so raw-Node use requires
jsdom + node-canvas shims and is fragile. Helpers `convertToSVG()` / `convertToPNG()` /
`createFlowchartFromJSON()` are available for an in-process Node path if avoiding a subprocess.
