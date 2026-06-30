<!-- generated draft — needs validation -->

# typst (documents)

## Summary

Typst is a modern markup-based typesetting system (Apache-2.0, Rust) — a TeX
alternative for academic, legal, and long-form documents. The primary deliverable
is **PDF**; it also exports SVG and PNG. It ships as a self-contained binary (no
TeX install needed), with incremental compilation and a scriptable markup language.
Drivable from the native CLI plus Python, JS/TS/Node, browser WASM, React/Angular,
and Rust crates.

## Skills

| Name | Type | Official | URL | License/Attribution |
| --- | --- | --- | --- | --- |
| claude-skill-typst | community skill | no | https://github.com/lucifer1004/claude-skill-typst | check repo; by lucifer1004 (GitHub). SKILL.md router with basics.md + package/template dev tables |
| Typst official docs llms.txt | llms.txt | yes | https://typst.app/docs/llms.txt | Typst GmbH (docs site) |
| Typst Documentation (Overview/Reference) | official-docs | yes | https://typst.app/docs/ | Typst GmbH — Apache-2.0 (compiler) |
| Typst in Production guide | community | no | https://typst-in-production.com/ | community web guide |

Primary skill: **claude-skill-typst** (community) — https://github.com/lucifer1004/claude-skill-typst

## Toolchains

| lang | install | invoke |
| --- | --- | --- |
| native CLI | `brew install typst` | `typst compile file.typ` (→ file.pdf); `typst compile in.typ out.pdf`; `typst watch file.typ`; `typst compile --format png/svg` |
| Python | `pip install typst` | `import typst; typst.compile('hello.typ', output='hello.pdf')` (also `format='png'/'svg'`, ppi, bytes I/O, Compiler class, query/eval, sys_inputs) |
| JS/TS (Node) | `npm i @myriaddreamin/typst-ts-node-compiler` | native NAPI compiler; compile/render to PDF/SVG/PNG |
| JS (browser/WASM) | `npm i @myriaddreamin/typst.ts` | `import { $typst } from '@myriaddreamin/typst.ts'; await $typst.svg({ mainContent: 'Hello, typst!' })` |
| React | `npm i @myriaddreamin/typst.react` | React component wrapper around typst.ts (Angular variant + vite-plugin-typst exist) |
| Rust | `cargo add typst typst-pdf` | build a `typst::World`, compile, then `typst_pdf::pdf()` |
| R | `install.packages('typr')` | render Typst from R; also via Quarto (`format: typst`) |

## Artifact kind

**pdf** — the universal shell's PDF viewer renders it directly. SVG/PNG export
also available for inline image embedding.

## Validation

- **install:** `brew install typst`
- **smoke:** `printf '= Hello\nThis is *Typst*.\n' > /tmp/hello.typ && typst compile /tmp/hello.typ /tmp/hello.pdf && ls -la /tmp/hello.pdf`
- **expect:** Exit 0, `/tmp/hello.pdf` created (valid one-page PDF). Verify with
  `file /tmp/hello.pdf` → 'PDF document'. Works fully headless/offline on macOS.
  For an image instead: `typst compile --format png /tmp/hello.typ /tmp/hello.png`.

## Wrapper params

- input `.typ` path/content
- output path
- format (pdf | png | svg)
- ppi / resolution (raster)
- `--root` (project root for imports)
- `--font-path`
- sys_inputs (`--input key=value`) for parametrized templates
- PDF reproducibility timestamp
- multi-file projects supported (dict of filename→bytes in Python)

## Component / explorer notes

Primary output is PDF — rendered directly by the default artifact shell's PDF
viewer. SVG/PNG export also available for inline image embedding. No richer
explorer needed beyond a standard PDF/page viewer; a multi-page navigator helps
for long documents.
