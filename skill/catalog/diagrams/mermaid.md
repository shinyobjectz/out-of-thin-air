<!-- generated draft — needs validation -->
# mermaid (diagrams)

## Summary
Mermaid is a JavaScript text-to-diagram tool: write diagrams in a markdown-like DSL
(flowchart, sequence, class, ER, state, Gantt, gitgraph, C4, mindmap, etc.) and render
them to SVG/PNG/PDF. Source is diffable plain text. Primary deliverable is **SVG** (vector).
The reference renderer (mermaid.js / mermaid-cli `mmdc`) uses headless Chromium via puppeteer.
Most language wrappers ultimately call the JS lib, the `mmdc` CLI, or the `mermaid.ink` HTTP service.

## Skills
| Skill | Type | Official | URL | License |
|---|---|---|---|---|
| mermaid (Claude Code skill, installed) | community | no | https://github.com/WH-2099/mermaid-skill | check repo (MIT typical) — WH-2099 |
| mermaid-diagram-skill | community | no | https://github.com/mgranberry/mermaid-diagram-skill | check repo — mgranberry |
| design-doc-mermaid | community | no | https://github.com/SpillwaveSolutions/design-doc-mermaid | check repo — SpillwaveSolutions |
| Official Mermaid docs | official-docs | yes | https://mermaid.js.org/intro/ | MIT (docs/site) — mermaid-js org |
| mermaid-cli README/docs | official-docs | yes | https://github.com/mermaid-js/mermaid-cli | MIT — mermaid-js org |

## Toolchains
| lang | install | invoke |
|---|---|---|
| JS/TS (CLI, canonical) | `npm install -g @mermaid-js/mermaid-cli` | `mmdc -i in.mmd -o out.svg` (or `.png`/`.pdf`); `npx -p @mermaid-js/mermaid-cli mmdc -i in.mmd -o out.svg` to avoid global install |
| JS/TS (browser/lib) | `npm install mermaid` | `import mermaid from 'mermaid'; mermaid.render('id', def)` → SVG string |
| React | `npm install mermaid react-mermaid2` | render via `mermaid.run()` or wrapper component |
| Python (HTTP) | `pip install mermaid-py` | `import mermaid as md; md.Mermaid(definition)` — defaults to mermaid.ink; can self-host via docker |
| Python (no Node) | `pip install mmdc` | PhantomJS via phasma, renders SVG with no Node/npm/Chromium (CI-friendly) — github.com/mohammadraziei/mmdc |
| HTTP / any | none (REST) | base64-encode diagram, `GET https://mermaid.ink/svg/<base64>` or `/img/<base64>` |
| Native CLI (no Node) | use `mmdc` (Node) | pure-native full renderers limited; use Python mmdc/phasma or mermaid.ink for headless-no-Node |

## Artifact kind
**svg** — self-contained vector. Renders inline in the universal artifact shell, no viewer needed.

## Validation
- **install:** `npm install -g @mermaid-js/mermaid-cli`
- **smoke:** `printf 'flowchart TD\n A[Start] --> B{ok?}\n B -->|yes| C[Done]\n B -->|no| A\n' > /tmp/d.mmd && mmdc -i /tmp/d.mmd -o /tmp/d.svg && ls -la /tmp/d.svg`
- **expect:** `/tmp/d.svg` is created (valid SVG, opens in any browser). `mmdc` downloads/uses headless Chromium via puppeteer; works headless on macOS. For PNG use `-o /tmp/d.png`. If puppeteer chromium issues arise, pass a puppeteer config (`-p`) pointing at an installed Chrome.

## Wrapper params
Key `mmdc` flags worth exposing:
- `-i` input (or `-` for stdin), `-o` output (extension picks format: `.svg`/`.png`/`.pdf`), `-e` explicit format
- `-t` theme (`default`/`dark`/`forest`/`neutral`)
- `-b` background (e.g. `transparent` or `white`)
- `-w` width, `-H` height, `-s` scale (PNG resolution)
- `-c` JSON mermaid config file, `-p` puppeteer config JSON (sandbox/executablePath)
- `-C` custom CSS, `-I` icon packs
For embedding prefer SVG; for PNG quality expose `-s`/`-w`/`-H`.

## Component / explorer notes
Default artifact shell renders SVG inline directly — no special viewer needed; the SVG is
self-contained vector. For large/interactive diagrams (pan/zoom on big flowcharts or C4 maps)
a richer explorer with zoom helps but is optional. HTML embedding via the mermaid JS lib gives
live re-render.
