# markup

Structured text / rich documents authored as markup → html/pdf (deterministic, diffable; not GUI editors).

Author content as plain-text markup, render to HTML (primary artifact) deterministically. PDF is a downstream step (headless print / dedicated PDF backend) where noted. All tools are diffable, version-control friendly, no GUI editors.

## Build matrix

| Tool | Kind | Toolchains | Primary skill | Status |
|------|------|-----------|---------------|--------|
| [mdx](./mdx.md) | html | javascript/node, javascript/vite, javascript/webpack-next | [MDX official docs](https://mdxjs.com/docs/) (official) | ok |
| [markdoc](./markdoc.md) | html | javascript/node | [Markdoc getting started](https://markdoc.dev/docs/getting-started) (official) | ok |
| [asciidoc](./asciidoc.md) | html | ruby, node | [Asciidoctor](https://docs.asciidoctor.org/asciidoctor/latest/) (official) | ok |
| [rst](./rst.md) | html | python:docutils, python:rst2pdf, python:sphinx | [Docutils](https://docutils.sourceforge.io/docs/) (official) | ok |
| [astro-content](./astro-content.md) | html | node | [Content collections guide](https://docs.astro.build/en/guides/content-collections/) (official) | ok |

## Notes

- Primary artifact is `html` across all tools. PDF is downstream-only (puppeteer/wkhtmltopdf headless print, or a dedicated backend such as `asciidoctor-pdf` / `rst2pdf`).
- Step scripts are bash-3.2-safe and never run heavy inline builds (npm/gem/pip install or framework build); they scaffold inputs + a render driver and print install/build hints, gated on dependency presence.
- Catalog entries marked as generated drafts may still need validation against a live build; see each `./<tool>.md` for its validation state.
