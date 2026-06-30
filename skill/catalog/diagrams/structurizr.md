<!-- generated draft — needs validation -->
# Structurizr (diagrams)

## Summary
Structurizr is a C4-model "diagrams as code" toolset. You author a software
architecture model in the Structurizr DSL (`.dsl`) or as workspace JSON, then
export views to other text/diagram formats. The Structurizr CLI (a Java app)
exports DSL/JSON to PlantUML, Mermaid, WebSequenceDiagrams, Ilograph, DOT, JSON,
etc. The CLI's primary deliverable is **text** (diagram-as-code source such as
`.puml`/`.mmd`) — it cannot render PNG/SVG itself (rendering is browser-based).
To get an image, pipe the exported PlantUML/Mermaid into their renderers, or
run Structurizr Lite for an interactive browser view. The DSL itself is the
diffable code artifact.

## Skills
| Name | Type | URL | Official | License |
|------|------|-----|----------|---------|
| Structurizr CLI docs (install + export) | official-docs | https://docs.structurizr.com/cli | yes | docs free; CLI Apache-2.0 |
| Structurizr DSL language reference | official-docs | https://docs.structurizr.com/dsl | yes | Apache-2.0 |
| Getting started: DSL → PlantUML/Mermaid | official-docs | https://docs.structurizr.com/getting-started/export-diagrams-as-code | yes | — |
| Community tooling index (ports + plugins) | official-docs | https://docs.structurizr.com/community | yes | — |
| pystructurizr (Python DSL for C4) | repo | https://github.com/nielsvanspauwen/pystructurizr | community | MIT |
| structurizr-python (client/library) | repo | https://structurizr-python.readthedocs.io/ | community | Apache-2.0 |
| Simon Brown: Getting started with the Structurizr CLI | community | https://dev.to/simonbrown/getting-started-with-the-structurizr-cli-10c2 | community | — |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| CLI (Java) | `brew install structurizr-cli` (needs Java 17+) | `structurizr.sh export -workspace workspace.dsl -format mermaid -output ./out` |
| Java | Maven Central: `com.structurizr:structurizr-core` + `structurizr-dsl` | build model programmatically, export via `StructurizrPlantUMLExporter`/`MermaidExporter` |
| Python | `pip install pystructurizr` | `python -m pystructurizr.cli dump --view <module>` |
| Go | `go get goa.design/model/...` | `mdl` tool: define C4 in Go, emit Structurizr-compatible JSON |
| TS/JS / .NET / PHP / Ruby | per-port (npm/nuget/composer/gem) | community ports, all emit open workspace JSON |

Also: `scoop install structurizr-cli`, or download the zip from
`structurizr/cli` GitHub releases. Use `structurizr.bat` on Windows.

## Artifact kind
**text** — the CLI emits diagram-as-code source (`.mmd`, `.puml`, `.dot`,
`.json`). The DSL `.dsl` itself is the diffable artifact. A visual image needs a
downstream render (mermaid-cli, PlantUML jar) or Structurizr Lite.

## Validation
- **install**: `brew install structurizr-cli` (macOS; requires Java 17+ — `brew install temurin` if missing)
- **smoke**:
  ```bash
  printf 'workspace {\n  model {\n    u = person "User"\n    s = softwareSystem "System"\n    u -> s "Uses"\n  }\n  views {\n    systemContext s {\n      include *\n      autolayout lr\n    }\n  }\n}\n' > workspace.dsl
  structurizr.sh export -workspace workspace.dsl -format mermaid -output ./out
  ls ./out
  ```
- **expect**: exits 0 and writes a `.mmd` Mermaid file (e.g.
  `./out/structurizr-SystemContext.mmd`) containing C4 graph text. Headless on
  macOS — no browser needed since output is text. To get an image, pipe the
  `.mmd` to `mmdc` (`npm i -g @mermaid-js/mermaid-cli`) or export
  `-format plantuml` and render with the PlantUML jar. The CLI cannot produce
  PNG/SVG directly.

## Wrapper params
- `diagrams.title` (text) — workspace name.
- `diagrams.format` (select) — export target: `mermaid`, `plantuml`,
  `plantuml/c4plantuml`, `plantuml/structurizr`, `websequencediagrams`,
  `ilograph`, `dot`, `json`.
- `diagrams.view` (select) — view type to scaffold: systemContext, container,
  component.

Key CLI export params: `-workspace` (path to `.dsl`/`.json`), `-format`,
`-output` (output dir).

## Component / explorer notes
CLI output is diagram-as-code text — not directly rendered images. The universal
text shell renders the DSL source and exported PlantUML/Mermaid fine, but a true
visual diagram needs a second render step (PlantUML server/CLI, mermaid-cli, or
the Structurizr Lite web UI). For an interactive/visual explorer, run
**Structurizr Lite** (`docker run -it --rm -p 8080:8080 -v $PWD:/usr/local/structurizr structurizr/lite`)
which serves the model with auto-layout in a browser — richer than a static
shell. To chain to PNG/SVG: `structurizr export` → `mmdc` (Mermaid) or the
PlantUML jar (PlantUML).
