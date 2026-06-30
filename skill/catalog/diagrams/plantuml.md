<!-- generated draft — needs validation -->
# plantuml (diagrams)

## Summary
PlantUML renders text markup (`@startuml…@enduml`) into UML and many other diagram types (sequence, class, activity, state, component, deployment, ER, C4, mindmap, gantt, wireframe). At its core it is a Java jar; every other binding (Python/Node/Go) either shells out to that jar or POSTs DEFLATE-encoded source to a PlantUML server. Default output is PNG; **SVG** is the diffable, scalable primary deliverable. Requires Java 11+ and (for some diagram types) Graphviz/`dot` — though the bundled **Smetana** engine removes the `dot` dependency for most layouts.

## Skills (attributed references)
| Name | Type | URL | Official? | License / Attribution |
|------|------|-----|-----------|------------------------|
| PlantUML command-line docs | official-docs | https://plantuml.com/command-line | yes | docs (site) — plantuml.com |
| PlantUML language reference / PDF guide | official-docs | https://plantuml.com/guide | yes | plantuml.com |
| plantuml/plantuml (core engine) | repo | https://github.com/plantuml/plantuml | yes | GPLv3 (LGPL/EPL/MIT/Apache dual options) — Arnaud Roques / PlantUML |
| Ashley's PlantUML community docs | community | https://plantuml-documentation.readthedocs.io/en/latest/command_line_reference.html | no | community docs — plantuml-documentation (RTD) |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| native CLI / JVM (Java 11+) | `brew install plantuml` (or download plantuml.jar) | `plantuml -tsvg diagram.puml` or `java -jar plantuml.jar -tsvg diagram.puml`; add `-Djava.awt.headless=true` on servers; `-pipe` reads stdin → stdout |
| Python (local jar wrapper) | `pip install plantuml-markdown` | `subprocess.run(['plantuml','-tsvg',f])` — note the PyPI `plantuml` package is a REMOTE client, not a local renderer |
| Python (remote server client) | `pip install plantweb` (or `plantuml` / `IPlantUML`) | `plantweb` renders via a PlantUML server (no Java); `IPlantUML` adds a `%%plantuml` Jupyter cell magic → inline SVG |
| JS/TS / Node | `npm install node-plantuml` (or `npx plantuml-cli`) | `generate(file,{format}).out.pipe(stream)`; `npx plantuml-cli -o out.svg diagram.puml` |
| any / containerized | `docker run -d -p 8080:8080 plantuml/plantuml-server:jetty` | GET `/svg/<DEFLATE+base64 encoded source>` — good for Go/Rust/other langs lacking a native lib |

## Artifact kind
**svg** — renders directly in the universal artifact shell (inline `<svg>` or `<img src>`). PNG supported as raster fallback (`-tpng`); PDF/EPS also available.

## Validation
- **install:** `brew install plantuml`
- **smoke:** `printf '@startuml\nAlice -> Bob: Hello\nBob --> Alice: Hi\n@enduml\n' | plantuml -tsvg -pipe > /tmp/puml-smoke.svg`
- **expect:** exit 0 and `/tmp/puml-smoke.svg` is a non-empty valid SVG (`head -c40` shows `<?xml`) showing a two-actor sequence diagram. Works headless on macOS; brew pulls in Java + Graphviz deps.

## Wrapper params
- output format: `-tsvg` (default, diffable/crisp) | `-tpng` | `-tpdf` | `-teps`
- `-pipe` — stdin → stdout, ideal for programmatic use
- `-o` / `--output-dir`
- `--check-syntax` — validate without rendering
- `-charset UTF-8`
- `-Djava.awt.headless=true` — server/CI rendering
- `-DPLANTUML_LIMIT_SIZE` — raise the dimension cap for large diagrams
- `-Playout=smetana` — pure-Java layout, avoids the Graphviz/`dot` dependency

## Component / explorer notes
SVG output renders directly in the default artifact shell. PNG is the raster fallback. No richer explorer is needed for a single static diagram; an interactive pan/zoom explorer only adds value for very large architecture diagrams.
