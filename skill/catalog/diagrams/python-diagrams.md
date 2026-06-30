<!-- generated draft — needs validation -->
# python-diagrams (mingrammer/diagrams)

## Summary
python-diagrams is a Python "Diagram as Code" library for prototyping cloud/system architecture diagrams. You write Python that instantiates provider nodes (AWS/GCP/Azure/K8s/on-prem/SaaS/programming icons) and connect them with `>>` / `<<` / `-` operators; rendering is done by Graphviz under the hood. Primary deliverable is a rendered raster image (PNG by default), with SVG/JPG/PDF/DOT also supported via the `outformat` arg. No live web UI — output is a static image file. Python-only (Graphviz is the native render engine); no first-class Go/JS/Rust bindings.

## Skills
| type | name | url | official | license | attribution |
|------|------|-----|----------|---------|-------------|
| official-docs | Diagrams official documentation | https://diagrams.mingrammer.com/ | official | MIT (project license) | mingrammer (Min-gyu Kim) |
| repo | mingrammer/diagrams (source + examples + node catalog) | https://github.com/mingrammer/diagrams | official | MIT | mingrammer |
| community | No dedicated Anthropic/Claude SKILL.md exists for python-diagrams; closest diagram skills target Mermaid (WH-2099/mermaid-skill) and Excalidraw (coleam00/excalidraw-diagram-skill) — different tools. No llms.txt published for diagrams.mingrammer.com. | https://github.com/coleam00/excalidraw-diagram-skill | community | see repo | — |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Python (CPython 3.7+) | `brew install graphviz && pip install diagrams` (or `uv pip install diagrams` / `poetry add diagrams`) | `python arch.py` — the `Diagram` context manager renders the image file on `__exit__` |

Notes: Only first-class toolchain. Requires the Graphviz system binary (`dot`) on PATH — pip does NOT bundle it. If you see `failed to execute dot`, Graphviz is not installed/on PATH.

## Artifact kind
`image` — the primary deliverable is a single PNG/SVG file with a fixed Graphviz-produced canvas layout. The universal image shell renders it directly (PNG inline, SVG inline).

## Validation
- **install**: `brew install graphviz && python3 -m pip install diagrams`
- **smoke**:
  ```bash
  python3 -c "from diagrams import Diagram; from diagrams.aws.compute import EC2; from diagrams.aws.database import RDS
  with Diagram('smoke', filename='smoke', outformat='png', show=False):
      EC2('web') >> RDS('db')"
  ```
- **expect**: Exit 0 and a file `smoke.png` (~tens of KB) in cwd showing an EC2 node connected by an arrow to an RDS node. Use `outformat='svg'` for `smoke.svg`. Runs fully headless on macOS (`show=False` prevents auto-open).

## Wrapper params
- `diagrams.title` — diagram name (also the heading on the canvas).
- `diagrams.outformat` — `png` | `svg` | `jpg` | `pdf` | `dot` (default `png`).
- `diagrams.direction` — graph flow: `TB` | `BT` | `LR` | `RL` (default `LR`).
- `Diagram(show=False)` — always set for headless runs (suppresses auto-open).
- `filename` — output basename (extension added per `outformat`).
- Advanced: `graph_attr` / `node_attr` / `edge_attr` dicts for Graphviz styling (fontsize, bgcolor, splines), `curvestyle`, `Cluster()` for grouping/subgraphs, `Edge(label=, color=, style=)` for annotated connections.

## Component / explorer notes
Output is a single static file with a fixed canvas layout. The default image artifact shell renders it directly. No interactivity, zoom, or pan is generated; for very large architectures a richer SVG pan/zoom explorer would help but is not required. Prefer SVG output when diffability/crispness matters; PNG is the default and most portable for headless macOS.
