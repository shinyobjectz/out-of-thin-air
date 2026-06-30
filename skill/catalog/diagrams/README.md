# diagrams

Architecture/system diagrams as text — diffable source compiled to SVG/PNG.

## Build matrix

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|-----------|---------------|-----------|--------|----------|-------|
| [mermaid](./mermaid.md) | svg | JS/TS CLI (mmdc), JS/TS lib, React, Python (mermaid-py), Python no-Node, HTTP (mermaid.ink) | mermaid (WH-2099 Claude Code skill) | no | ok | yes | yes |
| [d2](./d2.md) | svg | native CLI, Go (d2lib), JS/TS (WASM), React | [anthropics/skills](https://github.com/anthropics/skills) | yes | ok | yes | yes |
| [plantuml](./plantuml.md) | svg | native CLI/JVM, Python local (plantuml-markdown), Python remote (plantweb), Node, Docker server | [PlantUML CLI docs](https://plantuml.com/command-line) | yes | ok | yes | yes |
| [structurizr](./structurizr.md) | text | CLI (Java), Java, Python (pystructurizr), Go (mdl), TS/.NET/PHP/Ruby ports | [Structurizr CLI docs](https://docs.structurizr.com/cli) | yes | ok | yes | yes |
| [python-diagrams](./python-diagrams.md) | image | Python (CPython 3.7+ + Graphviz) | [Diagrams docs](https://diagrams.mingrammer.com/) | yes | ok | yes | yes |

## Multi-toolchain notes

- **Polyglot (Py/Go/JS-TS/React/native):** d2 (native/Go/JS-WASM/React), mermaid (JS-TS/React/Python/HTTP).
- **Native + Python + Node + Docker:** plantuml.
- **Most language ports:** structurizr (CLI/Java/Python/Go + community TS/.NET/PHP/Ruby), but all emit workspace JSON / diagram-as-code, not images.
- **Python-only:** python-diagrams (single Python toolchain; needs Graphviz `dot` on PATH).

## Validation order

Cheapest/most-reliable installs first:

1. **d2** — single pure-Go binary, headless render, no browser/JVM/Node. Most reliable.
2. **python-diagrams** — `pip install diagrams` + `brew install graphviz`; fast, but needs `dot` binary on PATH.
3. **mermaid** — `npm install -g @mermaid-js/mermaid-cli` (mmdc); pulls headless Chromium.
4. **plantuml** — `brew install plantuml`; requires JVM.
5. **structurizr** — `brew install structurizr-cli` + Java 17+; emits text only (.mmd/.puml), then must chain mmdc or PlantUML to render images.

## Explorer needs

Default artifact shell (open SVG/PNG in browser) is sufficient for mermaid, d2, plantuml, python-diagrams.

- **structurizr** wants a richer explorer: **Structurizr Lite** (`docker structurizr/lite`, port 8080) for interactive C4 model navigation across views. The CLI alone cannot render images — it produces diagram-as-code text only.

## Dossiers

- [./mermaid.md](./mermaid.md)
- [./d2.md](./d2.md)
- [./plantuml.md](./plantuml.md)
- [./structurizr.md](./structurizr.md)
- [./python-diagrams.md](./python-diagrams.md)
