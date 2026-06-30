# MJML

## Summary

MJML (`mjmlio/mjml`) is an MIT-licensed open-source markup language by Mailjet
that transpiles semantic `<mj-*>` XML into responsive, cross-client HTML email
(nested tables + inline CSS, Outlook ghost-tables/VML). It is deterministic:
identical `.mjml` input compiles to identical `.html`, so source is
version-controllable and renders headlessly with no browser or network. Current
stable is v5.4.0 (2026-06-29). The primary deliverable is an HTML file. Driven
from Node.js via the `mjml` CLI or the `mjml2html()` Node API; a Rust/Python port
(MRML / mjml-python) exists for non-Node runtimes. Verified headless on macOS:
`npx mjml` compiled a template to a ~3.7KB HTML file containing nested `<table>`
markup.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| skill-email-html-mjml | claude-skill | community | check repo (community) | https://github.com/framix-team/skill-email-html-mjml |
| MJML Official Documentation | docs | official | — | https://documentation.mjml.io/ |
| mjmlio/mjml | repo | official | MIT | https://github.com/mjmlio/mjml |

- **skill-email-html-mjml** — framix-team community Claude Code skill: generate
  cross-client HTML email with MJML, Outlook-safe, Gmail-optimized, WCAG 2.1 AA.
- **MJML Official Documentation** — Mailjet / mjmlio official MJML docs
  (components, CLI options, Node API).
- **mjmlio/mjml** — Mailjet / mjmlio canonical source repository.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript/Node.js (>=14) | `npm install -g mjml` (or `npx -y mjml`) | CLI: `mjml input.mjml -o output.html` (`-w` watch, `-s` stdout, `--config.minify`). Node API: `import mjml2html from 'mjml'; const { html } = mjml2html(src)`. Canonical/reference implementation. |
| Python (CPython 3.8+) | `pip install mjml` | MRML port w/ Python bindings, no Node: `from mjml import mjml_to_html; mjml_to_html(open('t.mjml').read())`. Component subset vs JS reference — verify parity for advanced templates. |
| Rust (native) | `cargo add mrml` | MRML crate (jdrouet/mrml) — fast Rust reimplementation powering the Python bindings; usable as library/CLI. |

## Artifact kind

`html` — the primary deliverable is a self-contained inline-CSS HTML email file.

## Validation

- **install**: `npx -y mjml --version` # prints mjml-core: 5.4.0 / mjml-cli: 5.4.0
- **smoke**: `printf '<mjml><mj-body><mj-section><mj-column><mj-text>Hello</mj-text></mj-column></mj-section></mj-body></mjml>' > t.mjml && npx -y mjml t.mjml -o t.html`
- **expect**: Creates `t.html` (~3.7KB) of valid responsive email HTML containing
  nested `<table>` elements and inline CSS; exit 0, no browser/network required.
  Verified on macOS (Darwin 24.6.0).

## Wrapper params

- `advertising-creative.title` — email headline / preview title (text).
- Wrap the Node CLI: take a `.mjml` source path, run `mjml <in> -o <out>` (or
  `mjml -i < in > out` for stdin/stdout piping), capture exit code and stderr.
  MJML emits parse/validation warnings without failing — surface them.
- For zero-Node environments use the Python `mjml` (MRML) package as a drop-in
  `mjml_to_html(str) -> str`, but gate on component coverage.
- Pin the version (`mjml@5.4.0`) for deterministic, reproducible output across
  machines. No headless browser, no fonts, no network needed — pure transpile.

## Component / explorer notes

Deliverable is an HTML email file. Authoring unit is a single `.mjml` document
using semantic components: `mjml > mj-body > mj-section > mj-column >
mj-text/mj-image/mj-button`, plus `mj-head` (`mj-attributes`, `mj-style`,
`mj-font`) for global styling. Layout is column-based (responsive stacking on
mobile is automatic). Reusable fragments via `mj-include`. Output is
self-contained inline-CSS HTML safe to paste into any ESP / advertising email
platform.
