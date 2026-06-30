<!-- generated draft — needs validation -->
# data-visualization / echarts — Apache ECharts

## Summary

Apache ECharts is an open-source (Apache 2.0) JS charting library. For OOTA's
deterministic, headless, version-controllable model, the key feature is built-in
**SSR** (ECharts 5.3.0+): `init(null, null, {renderer:'svg', ssr:true, width, height})`
then `renderToSVGString()` emits a clean, animation-free SVG string with ZERO
native dependencies — fully deterministic and headless on macOS, no
browser/Chromium needed. The chart spec is a JSON `option` object (the ideal
version-controllable input). PNG output is available via node-canvas (`canvas`
npm pkg, needs native deps) or by rasterizing the SSR SVG with resvg/sharp.
Primary OOTA artifact kind: **svg** (deterministic vector). No official Anthropic
skill exists; community skills + a community MCP server (hustcc/mcp-echarts) wrap it.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| ECharts Handbook — Server Side Rendering | official-docs | yes (Apache ECharts / apache/echarts) | Apache-2.0 | https://apache.github.io/echarts-handbook/en/how-to/cross-platform/server/ |
| hustcc/mcp-echarts (MCP server; png/svg/option) | mcp-server | no (community, hustcc) | MIT | https://github.com/hustcc/mcp-echarts |
| echarts Claude Code skill (vamseeachanta/workspace-hub) | community-skill | no (community) | unspecified | https://crossaitools.com/skills/vamseeachanta/workspace-hub/echarts |

Wrap the official handbook SSR pattern directly; treat the community skill/MCP as references only.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| JS/TS (Node 18+) — canonical | `npm install echarts` | `echarts.init(null,null,{renderer:'svg',ssr:true,width,height})` → `setOption(opt)` → `renderToSVGString()` → write `.svg`. Zero native deps, deterministic, headless. |
| JS/TS (Node 18+) — PNG via node-canvas | `npm install echarts canvas` | `createCanvas(w,h)` → `echarts.init(canvas)` → `canvas.toBuffer('image/png')`. Needs native deps: `brew install pkg-config cairo pango libpng jpeg giflib librsvg`. |
| JS/TS (Node 18+) — MCP | `npx -y mcp-echarts` | Community MCP server; emits png/svg/option. Agent-driven, not needed for deterministic file gen. |
| shell — SVG→PNG raster | `npm install @resvg/resvg-js` | Rasterize the deterministic SSR SVG to PNG headlessly without node-canvas native build (prebuilt binaries). |

## Artifact kind

**svg** — deterministic, text-based, diff-friendly vector. `ssr:true` disables
animation so output is static/reproducible. For PNG/PDF kinds, pipe the SVG
through `@resvg/resvg-js` rather than node-canvas to avoid macOS cairo build friction.

## Validation

- **install**: `mkdir /tmp/echarts-smoke && cd /tmp/echarts-smoke && npm init -y && npm install echarts`
- **smoke**:
  ```bash
  node -e "const e=require('echarts');const c=e.init(null,null,{renderer:'svg',ssr:true,width:400,height:300});c.setOption({xAxis:{type:'category',data:['A','B','C']},yAxis:{type:'value'},series:[{type:'bar',data:[3,1,2]}]});require('fs').writeFileSync('chart.svg',c.renderToSVGString());c.dispose();console.log('wrote chart.svg');"
  ```
- **expect**: Exits 0, prints `wrote chart.svg`, and `chart.svg` exists as valid
  `<svg>` markup (`head -c 5 chart.svg` => `<svg `). Identical bytes across runs
  (deterministic, no animation in ssr mode). No browser/display required.

## Wrapper params

- `data-visualization.title` (text) — chart title
- `data-visualization.type` (select: bar/line/pie/scatter) — series type
- `data-visualization.width` / `data-visualization.height` (range) — SVG dims (MUST be explicit in SSR; no DOM to measure)
- `data-visualization.option` (textarea, file-bound) — the ECharts `option` JSON, version-controllable source of truth

## Component / explorer notes

Deliverable component is the ECharts `option` JSON object (series/axes/grid/etc.) —
the version-controllable source of truth. Render target is a single self-contained
SVG. `ssr:true` disables animation for static/deterministic output. 20+ chart types,
supports 100k+ points. Width/height MUST be set explicitly in SSR (no DOM to measure).
Pin `echarts >=5.3.0` in package.json for SSR + reproducibility.
