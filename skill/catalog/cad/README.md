# cad

Parametric 3D models — enclosures, mechanical parts. Code-defined geometry exported to B-rep (STEP) or mesh (STL/glTF) artifacts.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [cadquery](./cadquery.md) | model3d | Python, CLI (cq-cli), any (git+subprocess/MCP) | [flowful-ai/cad-skill](https://github.com/flowful-ai/cad-skill) | no | ok | yes (pre-existing) | yes (pre-existing) |
| [openscad](./openscad.md) | model3d | native CLI, Python (solidpython2/openpyscad/pythonopenscad), JS/TS (openscad-wasm), shell | [mitsuhiko/agent-stuff](https://github.com/mitsuhiko/agent-stuff) | no | ok | yes | yes |
| [freecad](./freecad.md) | model3d | Python (freecadcmd), native CLI (FreeCADCmd), JS/Go/Rust (shell-out) | [FreeCAD Scripting Basics](https://wiki.freecad.org/Scripting) | yes | ok | yes | yes |

## Multi-toolchain notes

- **Python**: all three (cadquery native Py, openscad via solidpython2/openpyscad/pythonopenscad, freecad via freecadcmd).
- **native CLI**: openscad (`openscad -o`), freecad (`FreeCADCmd`), cadquery (`cq-cli`).
- **JS/TS**: openscad only, via `openscad-wasm` (npm) — browser/Node capable, no binary.
- **Go/Rust**: freecad via shell-out to a generated `model.py`; cadquery via git-clone + subprocess/MCP.
- **React**: none ship a first-class React toolchain; render in-browser via openscad-wasm or by tessellating STEP/STL into a viewer.
- All three are headless-capable for geometry export. openscad PNG preview is native-only on macOS (app bundle).

## VALIDATION ORDER

Cheapest/most-reliable installs first:

1. **cadquery** — pure `pip install` into a venv, fully headless, no GUI app or cask. Fastest to provision and smoke-test (STEP + STL).
2. **openscad** — `brew install --cask openscad`; STL export headless, PNG preview needs the macOS app bundle binary.
3. **freecad** — `brew install --cask freecad`; heaviest download, headless via app-bundle `FreeCADCmd`.

## EXPLORER NEEDS

All three emit `model3d` artifacts that warrant a **3D orbit viewer** beyond the default artifact shell — load tessellated STL/glTF (STEP tessellated client-side), orbit/pan/zoom, wireframe toggle, dimension readout. openscad additionally produces a 2D PNG preview that the default image shell can render.

## Dossiers

- [cadquery](./cadquery.md)
- [openscad](./openscad.md)
- [freecad](./freecad.md)
