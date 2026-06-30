# mdx (markup)

## Summary
MDX is an authorable format that embeds JSX/components inside Markdown, compiled to JavaScript by the official `@mdx-js/*` toolchain. MDX itself is a **compiler, not a renderer**: `@mdx-js/mdx`'s `compile()` turns `.mdx` into ESM JavaScript that exports a component; you then render that component with a JSX runtime (React/Preact/Vue) to produce HTML. The primary deterministic artifact is **HTML** (PDF only via a downstream HTML→PDF step). For static sites it is consumed via bundler plugins (`@mdx-js/rollup` for Vite, `@mdx-js/loader` for webpack/Next.js, `@mdx-js/esbuild`). The simplest headless file-emission path: compile MDX with `@mdx-js/mdx` (`evaluate`) then `renderToStaticMarkup` from `react-dom/server`, writing an `.html` file. ESM-only, Node 16+. MIT licensed. SECURITY: MDX executes arbitrary JS/JSX from the document — only compile trusted authors' input.

## Skills
| Name | Type | Official | URL | License | Notes |
|------|------|----------|-----|---------|-------|
| MDX official docs | documentation | yes | https://mdxjs.com/docs/ | MIT | Canonical docs hub: syntax, usage, guides. |
| MDX getting started | documentation | yes | https://mdxjs.com/docs/getting-started/ | MIT | Integrations matrix (Vite, Next, esbuild, Node). |
| @mdx-js/mdx compile/evaluate API | documentation | yes | https://mdxjs.com/packages/mdx/ | MIT | `compile()`, `evaluate()`, `run()` API reference. |
| mdx-js/mdx GitHub | repo | yes | https://github.com/mdx-js/mdx | MIT | Source, packages, issue tracker. |
| Next.js MDX guide | community-docs | no | https://nextjs.org/docs/app/guides/mdx | MIT | `@next/mdx` + `@mdx-js/loader` integration. |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| javascript/node | `npm i @mdx-js/mdx react react-dom` | `node render.mjs` — `evaluate(mdx)` → `renderToStaticMarkup` → `.html` |
| javascript/vite | `npm i -D @mdx-js/rollup && npm i react react-dom` | `vite build` — `@mdx-js/rollup` plugin compiles `.mdx`, bundled to html |
| javascript/webpack-next | `npm i -D @mdx-js/loader @next/mdx` | `next build` — `@mdx-js/loader` compiles `.mdx` |

ESM-only — use `package.json` `"type": "module"` or `.mjs` files. Use `evaluate()` for one-shot in-process rendering; use `compile()` to emit `.js` artifacts. Pin `@mdx-js/mdx@^3`, `react@^18`/`react-dom@^18` (matching majors) for reproducibility.

## Artifact kind
`html` — primary deliverable is rendered HTML. PDF is not native; pipe emitted HTML through a downstream HTML→PDF tool (weasyprint / playwright).

## Validation
- **install**: `npm init -y && npm pkg set type=module && npm i @mdx-js/mdx@^3 react@^18 react-dom@^18`
- **smoke**:
  ```bash
  cat > render.mjs <<'EOF'
  import {evaluate} from '@mdx-js/mdx';
  import * as runtime from 'react/jsx-runtime';
  import React from 'react';
  import {renderToStaticMarkup} from 'react-dom/server';
  import {writeFileSync} from 'node:fs';
  const src = '# Hello\n\nThis is **MDX** with <abbr title="x">JSX</abbr>.';
  const {default: Content} = await evaluate(src, {...runtime, baseUrl: import.meta.url});
  const html = '<!doctype html><meta charset=utf-8>' + renderToStaticMarkup(React.createElement(Content));
  writeFileSync('out.html', html);
  console.log('wrote out.html', html.length);
  EOF
  node render.mjs && test -f out.html && head -c 120 out.html
  ```
- **expect**: Writes `out.html` containing `<h1>Hello</h1>` and `<strong>MDX</strong>`; `wrote out.html` logged with non-zero length.

## Wrapper params
- `markup.title` — HTML document title.
- `markup.source` — MDX source (`src/page.mdx`).

## Component / explorer notes
MDX is a compiler producing ESM JS that exports a component. HTML requires a JSX runtime render step — `react-dom/server` `renderToStaticMarkup` is the simplest deterministic headless path. For React 19 the `jsx-runtime` import path is unchanged. Custom components are injected at render time via the `components` prop (MDX provider pattern). For static sites, prefer bundler plugins (`@mdx-js/rollup`, `@mdx-js/loader`, `@mdx-js/esbuild`) which compile `.mdx` as part of the build graph.
