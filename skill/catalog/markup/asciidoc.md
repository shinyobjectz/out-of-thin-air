<!-- generated draft — needs validation -->
# AsciiDoc (Asciidoctor)

## Summary

AsciiDoc is a plain-text markup language; **Asciidoctor** is the canonical,
fast, MIT-licensed Ruby text processor that converts AsciiDoc to HTML5
(default), DocBook, and man pages. The companion **asciidoctor-pdf** gem adds
PDF output. Conversion is fully CLI-driven, headless, and deterministic — the
default HTML5 backend produces a self-contained standalone document with no
extra dependencies. A JS port (`@asciidoctor/core` + `@asciidoctor/cli`) exists
for Node-only environments but cannot emit PDF natively.

Primary OOTA artifact is **HTML** — zero extra deps, single command, instantly
viewable. PDF is reserved for explicit paginated/print deliverables.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| Asciidoctor (`asciidoctor` gem) | cli | yes | MIT | https://github.com/asciidoctor/asciidoctor |
| Asciidoctor PDF (`asciidoctor-pdf` gem) | cli | yes | MIT | https://github.com/asciidoctor/asciidoctor-pdf |
| Asciidoctor Docs (official manual) | docs | yes | MIT | https://docs.asciidoctor.org/asciidoctor/latest/ |
| Asciidoctor PDF install/usage docs | docs | yes | MIT | https://docs.asciidoctor.org/pdf-converter/latest/ |
| asciidoctor.js (Node port) | library | yes | MIT | https://docs.asciidoctor.org/asciidoctor.js/latest/ |

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| ruby | `gem install asciidoctor` (HTML/DocBook/man — built in); `gem install asciidoctor-pdf` (adds PDF). Needs Ruby >= 2.7 | `asciidoctor doc.adoc` → `doc.html`; `asciidoctor-pdf doc.adoc` → `doc.pdf`; `-o OUT` sets output path, `-b html5` forces backend |
| node | `npm i -g @asciidoctor/cli @asciidoctor/core` (HTML only — no native PDF) | `asciidoctor doc.adoc -o doc.html` |

## Artifact kind

**html** (primary). Default backend is `html5`, standalone with embedded CSS.
PDF (`pdf` kind) available via the separate asciidoctor-pdf gem.

## Validation

- **install**: `gem install asciidoctor`
- **smoke**:
  ```
  printf '= Hello OOTA\nAuthor Name\n\n== Intro\n\nThis is *AsciiDoc* rendered by Asciidoctor.\n\n* one\n* two\n' > /tmp/oota.adoc \
    && asciidoctor -o /tmp/oota.html /tmp/oota.adoc && test -s /tmp/oota.html && echo OK
  ```
- **expect**: Exit 0; `/tmp/oota.html` exists and is non-empty (complete
  standalone HTML5 doc containing `<h1>Hello OOTA</h1>`). For PDF:
  `gem install asciidoctor-pdf && asciidoctor-pdf -o /tmp/oota.pdf /tmp/oota.adoc`
  produces a valid PDF.

## Wrapper params

| Param | Default | Notes |
|-------|---------|-------|
| `markup.title` | `Hello OOTA` | document title (`= Title`) |
| `markup.author` | `OOTA Author` | author line |
| `markup.body` | sample paragraph | first section body text |

## Notes

- Output goes next to input unless `-o` given; `-D` sets output dir.
- HTML output is diffable; suppress the footer's last-updated timestamp with
  `-a nofooter` or `-a last-update-label!` for reproducible builds.
- `-e/--embedded` emits an HTML fragment instead of a standalone doc.
- PDF path is Ruby-only — the npm/asciidoctor.js port cannot emit PDF.
