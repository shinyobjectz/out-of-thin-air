<!-- generated draft — needs validation -->
# WeasyPrint

- **slug**: `weasyprint`
- **category**: `business-documents`
- **artifact kind**: `pdf`
- **confidence**: high

## Summary

WeasyPrint is a BSD-licensed Python visual rendering engine that converts HTML+CSS into PDF (and PNG). It implements CSS Paged Media (page boxes, `@page`, running headers/footers, page counters), flexbox and grid, and deliberately does NOT execute JavaScript — making renders fully deterministic and reproducible from version-controlled HTML/CSS + data. Ideal OOTA fit for business documents: invoices, reports, statements, certificates. Latest line is v69.x (released Feb 2026), requires Python >=3.10. Driven headlessly via the `weasyprint` CLI or the Python API; commonly paired with a templating layer (Jinja2) that injects data into HTML before rendering. Native deps Pango/cairo/GDK-PixBuf/libffi must be present (Homebrew on macOS).

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| anthropics/skills — document skills (pdf) | official-skill-repo | yes | See repo LICENSE (Anthropic Agent Skills) | https://github.com/anthropics/skills |
| WeasyPrint official documentation (CourtBouillon) | official-docs | yes | BSD-3-Clause (project) | https://doc.courtbouillon.org/weasyprint/stable/ |
| resume-forge / community HTML+Jinja2→WeasyPrint pattern | community-skill | no | Varies (per-repo, often MIT) | https://github.com/anthropics/skills |

Attribution:
- **anthropics/skills**: Anthropic. Public Agent Skills repository; document skills cover pdf/docx/pptx/xlsx. The HTML-to-PDF generation path uses WeasyPrint with Jinja2 templating.
- **CourtBouillon docs**: Kozea / CourtBouillon. Canonical install + First Steps + API/CLI reference for v69.0.
- **community pattern**: Jinja2 injects data into an HTML template, WeasyPrint renders to PDF. Widely documented; verify individual repo license before reuse.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython >=3.10) | `brew install python3 cairo pango gdk-pixbuf libffi && python3 -m venv venv && source venv/bin/activate && pip install weasyprint` | CLI: `weasyprint input.html output.pdf` · Python: `from weasyprint import HTML; HTML('in.html').write_pdf('out.pdf')` |

Notes: package is `weasyprint` (PyPI, v69.x). Also `HTML(string=...)`, `HTML(url=...)`, and separate `CSS(...)` stylesheets. `weasyprint --info` for diagnostics. No JS execution = deterministic.

## Artifact kind

`pdf` — primary deliverable. The deterministic, version-controllable source is HTML + CSS (optionally a Jinja2/`.html.j2` template + a JSON/YAML data file).

## Validation

- **install**: `brew install python3 cairo pango gdk-pixbuf libffi && python3 -m venv /tmp/wp && source /tmp/wp/bin/activate && pip install weasyprint`
- **smoke**: `source /tmp/wp/bin/activate && printf '<!doctype html><style>@page{size:A4;margin:2cm}h1{color:#0a5}</style><h1>OOTA WeasyPrint smoke</h1><p>Deterministic PDF.</p>' > /tmp/wp.html && weasyprint /tmp/wp.html /tmp/wp.pdf && file /tmp/wp.pdf`
- **expect**: Exit 0; `/tmp/wp.pdf` exists; `file` reports `PDF document, version 1.x`. Fully headless, no display server, no network needed for local HTML.

## Wrapper params

- `business-documents.title` — document title (text)
- `business-documents.body` — body HTML/markup (textarea, bound to `src/document.html`)
- `business-documents.page_size` — page size (select: A4, Letter, Legal)
- `business-documents.accent` — accent color (color)

## Component / explorer notes

CSS Paged Media is the load-bearing feature: use `@page` for size/margins/marks, running elements + `position:running()` for repeating headers/footers, and `counter(page)`/`counter(pages)` for "Page X of Y". Flexbox and CSS Grid are supported; web fonts via `@font-face` (local files preferred for reproducibility). No JS, no canvas, no external runtime fetch at render time — same input always yields the same PDF.

Wrapping: data file + HTML/Jinja2 template -> render step -> single CLI invocation `weasyprint template_rendered.html out.pdf` (or Python `HTML(...).write_pdf(...)`). Pin `weasyprint==69.*` and native libs (Pango/cairo) for byte-stable output; font rendering can shift across Pango versions so vendor fonts and pin the toolchain in CI/Docker. macOS gotcha: WeasyPrint needs the Homebrew Pango/cairo dylibs on the library path — if `weasyprint --info` errors on libgobject/libpango, ensure Homebrew libs are discoverable (DYLD/`brew --prefix`). No headless-browser/Chromium dependency, unlike Puppeteer-based HTML-to-PDF — lighter and more deterministic, at the cost of no JS-driven content.
