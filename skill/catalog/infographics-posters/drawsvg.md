# drawsvg

## Summary
drawsvg (`cduck/drawsvg`, v2.x, MIT) is a Python 3 library for programmatically
generating SVG vector images, animations, and interactive Jupyter widgets. Its
pure-Python SVG output requires no external dependencies, making it deterministic
and version-controllable: the same script always emits identical SVG markup. An
optional Cairo backend adds PNG/MP4/GIF rasterization. The primary deliverable
kind is **SVG**. No official Anthropic skill exists; only generic community SVG
skills, none drawsvg-specific. The source repo migrated to
`tangled.org/cduck.me/drawsvg`, but the GitHub mirror + PyPI remain canonical.

## Skills
| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| No official Anthropic/Claude drawsvg skill | none | no | n/a | https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview |
| SVG Specialist (generic SVG/SVGO, not drawsvg-specific) | community | no | unspecified | https://mcpmarket.com/tools/skills/svg-specialist |
| svg-drawing (renders SVG code to PNG for iteration) | community | no | unspecified | https://smithery.ai/skills/possumworx/svg-drawing |

Attributions: Anthropic Agent Skills docs (no drawsvg skill published);
mcpmarket.com community listing; possumworx via Smithery.

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.8+) | `python3 -m pip install "drawsvg~=2.0"` (SVG only, no native deps); for PNG/MP4/GIF: `python3 -m pip install "drawsvg[all]~=2.0"` plus system Cairo (`brew install cairo` on macOS) | `python3 build.py` — `import drawsvg as draw`; build a `draw.Drawing(...)`, append elements, call `d.save_svg('out.svg')` |

Only driver. Headless and deterministic for SVG output (no browser/GPU).
PNG/MP4 paths shell out to Cairo/FFmpeg.

## Artifact kind
**svg** — primitive vector deliverable: charts, infographics, posters, diagrams
as deterministic, diff-friendly vector markup.

## Validation
- **install**: `python3 -m pip install "drawsvg~=2.0"`
- **smoke**: `python3 -c "import drawsvg as draw; d=draw.Drawing(200,100,origin='center'); d.append(draw.Circle(0,0,30,fill='red',stroke='black')); d.append(draw.Text('OOTA',16,0,-40,center=True)); d.save_svg('/tmp/oota_drawsvg.svg'); print('ok')" && head -c 200 /tmp/oota_drawsvg.svg`
- **expect**: Prints `ok` and writes `/tmp/oota_drawsvg.svg` — a valid `<svg ...>`
  document (200x100) containing a red circle and 'OOTA' text. No Cairo needed for
  SVG; runs fully headless on macOS.

## Wrapper params
- `infographics-posters.title` (text) — poster/diagram title text.

## Component / explorer notes
SVG primitive deliverable: charts, infographics, posters, diagrams as
deterministic vector markup. Core API: `Drawing(width,height,origin)`, shape
elements (`Circle`, `Rectangle`, `Lines`, `Path`, `Ellipse`), `Text`, gradients,
patterns, clip paths, groups (`Group`), and transforms. Animations via animate
elements and per-frame frame functions. Output via `save_svg()` / `as_svg()`
(string) — both fully deterministic and diff-friendly for version control. v2.x
uses snake_case API (breaking change from v1.x camelCase).

Wrap as a thin Python module exposing a `build(params) -> writes .svg` function;
OOTA drives it via `python build.py`. Keep to SVG-only output (no Cairo) for
hermetic, dependency-light, byte-deterministic renders. If raster export is
needed downstream, run a separate rasterize step (cairosvg or resvg) rather than
coupling `drawsvg[all]` + system Cairo into the authoring path. Pin
`drawsvg~=2.0` to avoid v1/v2 API drift. Set explicit width/height/origin and
avoid time/random in scripts to preserve determinism.
