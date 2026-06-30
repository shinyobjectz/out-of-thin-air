<!-- generated draft — needs validation -->
# cadquery (cad)

## Summary
CadQuery is a Python parametric CAD scripting framework built on the OpenCASCADE (OCCT) kernel. You describe solids with a fluent Python API (`Workplane().box(...).hole(...)`) and export to lossless B-rep CAD formats (STEP, DXF, IGES) plus mesh formats (STL, 3MF, AMF, VRML, glTF). The primary deliverable is a 3D solid model. Python is the only first-class driver; other languages reach it via subprocess or a community MCP server. Headless on macOS works fine for model build/export; only interactive 3D preview needs a viewer (CQ-editor / jupyter-cadquery).

## Skills
- **flowful-ai/cad-skill (parametric-3d-printing)** — community — https://github.com/flowful-ai/cad-skill — attribution: flowful-ai — license: see repo (check LICENSE; community skill)
- **CadQuery official docs (readthedocs)** — official — https://cadquery.readthedocs.io/ — attribution: CadQuery project
- **rishigundakaram cad-query MCP server** — community — https://github.com/rishigundakaram/cad-query-workspace — attribution: rishigundakaram — license: see repo
- **cq-kit helper library** — community — https://github.com/michaelgale/cq-kit — attribution: Michael Gale — license: MIT

## Toolchains
| lang | install | invoke |
| --- | --- | --- |
| Python (CPython 3.9–3.12) | `pip install cadquery` (fallback: `conda install -c conda-forge cadquery`) | `import cadquery as cq`; build with `Workplane`; export via `.export()` or `cq.exporters.export(...)` |
| CLI / native (shell) | `pip install cq-cli` | `cq-cli --infile model.py --outfile out.step --format STEP` (headless runner; no export code needed) |
| any (JS/TS, Go, Rust…) | `git clone https://github.com/rishigundakaram/cad-query-workspace` | Drive via subprocess to a Python script or the community MCP server. No native bindings outside Python; JS users often pick Replicad instead. |

## Artifact kind
**model3d** — primary deliverable is a 3D solid model. STEP/IGES B-rep is the canonical CAD output; tessellate to STL/3MF/glTF for browser/print.

## Validation
- **install:** `python3 -m venv /tmp/cqenv && /tmp/cqenv/bin/pip install cadquery`
- **smoke:** `/tmp/cqenv/bin/python -c "import cadquery as cq; cq.exporters.export(cq.Workplane().box(10,10,10).faces('>Z').hole(4), '/tmp/box.step'); cq.exporters.export(cq.Workplane().box(10,10,10), '/tmp/box.stl')"`
- **expect:** Exits 0; writes `/tmp/box.step` (ASCII STEP, ISO-10303-21 header) and `/tmp/box.stl` (binary/ASCII mesh). Verify with `head -c 40 /tmp/box.step` showing `ISO-10303-21`. Fully headless — no GUI/display needed.

## Wrapper params
Expose:
- **output format** — STEP (CAD interchange), STL/3MF (printing), glTF (web preview)
- **mesh tolerance** — `linearDeflection` / `angularDeflection` for STL quality vs. file size
- **parametric dimensions** — length / width / height / hole-dia / wall-thickness; these drive the parametric script the agent writes
Render a glTF/STL alongside the canonical STEP.

## Component / explorer notes
The default model3d shell can render STL/3MF/glTF mesh directly in a standard three.js / model-viewer. STEP/IGES B-rep output is NOT browser-renderable as-is — tessellate to STL or glTF for the shell (glTF gives best web fidelity). A richer explorer (orbit, section, dimensions, parameter sliders) is nice-to-have but not required.
