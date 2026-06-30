<!-- generated draft — needs validation -->
# freecad (cad)

## Summary
FreeCAD is an open-source parametric 3D CAD modeler. Its automation surface is
Python: the entire application is scriptable via the `FreeCAD`/`Part`/`Mesh`/`Sketcher`
modules, runnable headless through the `freecadcmd` (a.k.a. `FreeCADCmd`) console
binary. The primary deliverable is a 3D model — a parametric `.FCStd`, or an exported
STEP/IGES/BREP for CAD interchange and STL/OBJ/GLTF for mesh. There is no official
Anthropic skill, but a strong ecosystem of MCP servers and an AI workbench connect
FreeCAD to Claude. Drive it primarily from Python; the native CLI is `freecadcmd`.
Other languages can only orchestrate by shelling out to `freecadcmd` with a generated
`.py` script.

## Skills (attributed references)
| name | type | official | license | url |
|------|------|----------|---------|-----|
| FreeCAD Scripting Basics | official docs | yes | docs CC-BY | https://wiki.freecad.org/Scripting |
| FreeCAD Headless / FreeCADCmd | official docs | yes | docs CC-BY | https://wiki.freecad.org/Headless_FreeCAD |
| ghbalf/freecad-ai | repo | community | check repo (LGPL-style addon) | https://github.com/ghbalf/freecad-ai |
| neka-nat/freecad-mcp | repo | community | MIT | https://github.com/neka-nat/freecad-mcp |
| bonninr/freecad_mcp | repo | community | check repo | https://github.com/bonninr/freecad_mcp |
| proximile/FreeCAD-MCP | repo | community (multi-model, Docker headless, Vision AI) | check repo | https://github.com/proximile/FreeCAD-MCP |
| spkane/freecad-addon-robust-mcp-server | repo | community (robust MCP bridge addon) | check repo | https://github.com/spkane/freecad-addon-robust-mcp-server |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Python (primary) | `brew install --cask freecad` or `conda create -n fc freecad -c conda-forge` | `freecadcmd script.py` (binary: `/Applications/FreeCAD.app/Contents/Resources/bin/FreeCADCmd` on macOS); in-script `import FreeCAD, Part, Mesh` |
| native CLI | `brew install --cask freecad` | `freecadcmd path/to/script.py` — headless console executor, takes a `.py` argument |
| JS/TS, Go, Rust, etc. | install FreeCAD as above | no native bindings — generate a `.py` and `subprocess` → `freecadcmd generated.py`; MCP servers wrap this for agent use |

Notes: prefer conda-forge `freecad` for a python-importable build; unofficial pip
wheels are unreliable. Everything routes through Python — there is no standalone
non-Python command language.

## Artifact kind
**model3d** — primary output is a 3D solid/mesh. Export STL/GLB for the standard
model3d viewer.

## Validation
- install: `brew install --cask freecad`
- smoke:
  ```bash
  FCBIN="/Applications/FreeCAD.app/Contents/Resources/bin/FreeCADCmd"
  printf 'import Part\nbox=Part.makeBox(10,10,10)\nbox.exportStep("/tmp/box.step")\nimport Mesh\nMesh.Mesh(box.tessellate(0.1)).write("/tmp/box.stl")\n' > /tmp/fc_smoke.py
  "$FCBIN" /tmp/fc_smoke.py
  ls -l /tmp/box.step /tmp/box.stl
  ```
- expect: headless run prints the FreeCAD startup banner and writes `/tmp/box.step`
  (ASCII STEP, a few KB) and `/tmp/box.stl`. Both files exist and are non-empty. Works
  without a display on macOS.

## Wrapper params
- `cad.title` — document/object name.
- `cad.format` — output format (step/iges/brep for CAD interchange; stl/obj/gltf for mesh).
- `cad.tolerance` — tessellation tolerance for mesh export (`Part.tessellate(0.1)`; smaller = finer).
- For parametric workflows, expose named dimensions / spreadsheet cells so models stay editable.
- Run via `freecadcmd` for headless/CI; full GUI only needed for interactive sketching.

## Component / explorer notes
The default model3d artifact shell can render exported STL/OBJ/GLTF (convert
STEP→mesh via the Mesh module or export GLTF). For parametric `.FCStd` inspection you
want a richer explorer (feature tree, sketches, constraints) — a plain mesh viewer
loses the parametric history. For most agent deliverables, export STL/GLB and use the
standard model3d viewer.
