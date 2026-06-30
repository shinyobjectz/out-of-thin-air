<!-- generated draft — needs validation -->
# Markdoc (Stripe's Markdown superset)

## Summary

**Markdoc** is Stripe's open-source (MIT) Markdown superset: a declarative
authoring framework that extends Markdown with `{% tags %}`, annotations, and
variables. It parses source to an AST, transforms it against a config (custom
tags/nodes/functions), and renders **deterministically**. The primary artifact
is **HTML** via the built-in string renderer (`Markdoc.renderers.html`); static
and dynamic **React** renderers also exist.

Markdoc is a **Node library, NOT a CLI app** — there is no official `markdoc`
binary. Headless OOTA use therefore requires a tiny Node driver script
(`parse → transform → render → writeFile`). The HTML renderer emits a *fragment*
(no `<html>`/`<head>`), so the driver wraps it in a minimal doc shell. Content
is machine-readable and diffable, fitting OOTA's deterministic markup→html lane.
PDF is a downstream step: render HTML, then pipe through headless-Chrome
(puppeteer `page.pdf()`) or `wkhtmltopdf` (out of scope for the core package).

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| Markdoc getting started (official docs) | docs | yes | MIT | https://markdoc.dev/docs/getting-started |
| Markdoc overview / spec | docs | yes | MIT | https://markdoc.dev/docs/overview |
| markdoc/markdoc (source repo) | repo | yes | MIT | https://github.com/markdoc/markdoc |
| Stripe.dev: How Stripe builds interactive docs with Markdoc | article | yes | n/a | https://stripe.dev/blog/markdoc |
| Next.js plugin (`@markdoc/next.js`) | plugin | yes | MIT | https://markdoc.dev/docs/nextjs |

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| javascript/node | `npm install @markdoc/markdoc` | `node driver.js` — `Markdoc.parse(src)` → `Markdoc.transform(ast, config)` → `Markdoc.renderers.html(tree)` → wrap + `fs.writeFileSync` |

## Artifact kind

**html** (primary). The string renderer emits an HTML fragment; the driver adds
a doctype/`<head>`/`<body>` shell. React renderers (`Markdoc.renderers.react`)
available for interactivity; PDF is a downstream headless-Chrome step.

## Validation

- **install**: `npm install @markdoc/markdoc`
- **smoke**:
  ```
  node -e "const M=require('@markdoc/markdoc');const src='# Hello {% \$name %}\n\nA **Markdoc** doc.';const ast=M.parse(src);const tree=M.transform(ast,{variables:{name:'OOTA'}});const frag=M.renderers.html(tree);require('fs').writeFileSync('out.html','<!doctype html><html><head><meta charset=utf-8></head><body>'+frag+'</body></html>');console.log('wrote out.html')"
  ```
- **expect**: Process prints `wrote out.html` and creates `out.html` containing
  an `<h1>Hello OOTA</h1>` and a `<p>` with `<strong>Markdoc</strong>`; exit 0.

## Wrapper params

| Param | Default | Notes |
|-------|---------|-------|
| `markup.title` | `Hello OOTA` | document `<title>` + H1; passed as a Markdoc variable |
| `markup.name` | `OOTA` | sample variable substituted via `{% $name %}` |
| `markup.body` | sample paragraph | first paragraph body text |

## Notes

- No official CLI — always supply a driver script (`require`/`import`
  `@markdoc/markdoc`).
- Custom `{% tags %}` must be registered in the `transform` config (`tags`,
  `nodes`, `functions`); unknown tags otherwise warn/error.
- `renderers.html` → fragment only; the wrapper adds the doc shell.
- ESM and CJS both supported (`import Markdoc from '@markdoc/markdoc'` or
  `require`). Pin Node per repo `.node-version`.
- PDF lane: render HTML, then `puppeteer page.pdf()` or `wkhtmltopdf`.
