<!-- generated draft — needs validation -->

# rst (markup)

## Summary

reStructuredText (RST) is a plaintext markup language processed by **Docutils**
(the reference implementation) and extended by **Sphinx**. Source `.rst` files are
deterministic and diffable. Docutils ships small front-end CLIs — the modern unified
`docutils` command (added in docutils 0.21, 2024) plus always-present legacy entry
points `rst2html`, `rst2html5`, `rst2latex`, etc. — that render RST to HTML5, LaTeX,
XML, ODT, and man pages. The primary OOTA deliverable is **HTML** (single command,
no external deps, pure-Python, fully headless — emits a self-contained file in one
shot). PDF is available via `rst2pdf` (ReportLab, pure-Python, no LaTeX) or via
`rst2latex` + a TeX toolchain. Use Sphinx only for multi-file projects, cross-refs,
theming, or a docs site.

## Skills

| Name | Type | Official | URL | License/Attribution |
| --- | --- | --- | --- | --- |
| Docutils (reference RST impl — ships rst2html/rst2html5/docutils CLIs) | official-docs | yes | https://docutils.sourceforge.io/docs/user/tools.html | Public Domain (most modules) / BSD-2-Clause (some); see docutils COPYING |
| reStructuredText Markup Spec (Docutils) | official-docs | yes | https://docutils.sourceforge.io/rst.html | Public Domain |
| Sphinx reStructuredText Primer | official-docs | yes | https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html | BSD-2-Clause (Sphinx) |
| rst2pdf (RST → PDF via ReportLab, no LaTeX) | official-docs | yes | https://rst2pdf.org/ | MIT |
| rst2html5 (HTML5 front end) | community-pkg | no | https://pypi.org/project/rst2html5/ | MIT |

Primary skill: **Docutils** (official) — https://docutils.sourceforge.io/docs/user/tools.html

## Toolchains

| lang | install | invoke |
| --- | --- | --- |
| Python (Docutils) | `pip install docutils` | `docutils --writer=html5 input.rst output.html`; legacy: `rst2html5 input.rst output.html`; `rst2html input.rst > output.html` |
| Python (rst2pdf) | `pipx install rst2pdf` | `rst2pdf input.rst -o output.pdf` (pure-Python ReportLab, no LaTeX) |
| Python (Sphinx) | `pip install sphinx` | `sphinx-build -b html sourcedir builddir`; `-b latexpdf` for PDF via TeX |

## Artifact kind

**html** — the universal shell renders the emitted HTML5 file directly. PDF is a
secondary deliverable via rst2pdf (no TeX) or rst2latex + TeX.

## Validation

- **install:** `pip install docutils`
- **smoke:** `printf 'Title\n=====\n\nHello **RST**.\n' > /tmp/oota.rst && docutils --writer=html5 /tmp/oota.rst /tmp/oota.html && test -s /tmp/oota.html && echo OK`
- **expect:** Exit 0, prints `OK`, `/tmp/oota.html` exists as a self-contained HTML5
  file containing the heading and bold text. On docutils <0.21 the unified `docutils`
  command may be absent — use `rst2html5 /tmp/oota.rst /tmp/oota.html` or
  `rst2html /tmp/oota.rst > /tmp/oota.html` instead. Pure-Python, no system libs,
  fully headless/offline.

## Wrapper params

- input `.rst` path/content
- output path
- writer/format (html5 | html | latex | pdf)
- PDF backend (rst2pdf | rst2latex+TeX)
- stylesheet (`--stylesheet`) / embed-stylesheet
- doctitle / report-level
- Sphinx project mode (multi-file, cross-refs, theming)

## Component / explorer notes

Primary output is a single self-contained HTML5 file — rendered directly by the
default artifact shell's HTML viewer. No richer explorer needed for single-file
docs. PDF (via rst2pdf) routes to the PDF viewer; Sphinx multi-file builds produce
a directory site that a static-file browser can serve.
