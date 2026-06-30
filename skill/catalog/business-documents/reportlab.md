# RML (ReportLab)

<!-- generated draft — needs validation -->

slug: `reportlab` · category: `business-documents` · artifact kind: `pdf`

## Summary

ReportLab is the canonical open-source Python library for generating PDFs programmatically. You drive it from Python code (deterministic, version-controllable) and it renders a PDF headlessly with no browser or display server. It works at two levels: a low-level canvas API (`reportlab.pdfgen.canvas`) for absolute-positioned drawing, and a high-level page-layout engine (Platypus: `reportlab.platypus`) for flowable documents with paragraphs, tables, charts, and automatic pagination. Latest version 5.0.0 (released 2026-06-18), BSD-licensed core, Python 3.9-3.14. Ideal for OOTA business documents (invoices, reports, statements) where output must be deterministic and diffable from code.

## Skills

| Skill | Type | Official | License | URL |
|---|---|---|---|---|
| anthropics/skills — pdf | official | yes | See repo (Anthropic) | https://github.com/anthropics/skills/blob/main/skills/pdf/SKILL.md |
| ReportLab official docs / User Guide | official-docs | yes | BSD (library) | https://docs.reportlab.com/ |
| VoltAgent/awesome-agent-skills + travisvn/awesome-claude-skills | community | no | MIT (lists) | https://github.com/travisvn/awesome-claude-skills |

Attribution:
- **anthropics/skills — pdf**: Anthropic official Agent Skills repository. The PDF skill explicitly uses ReportLab for PDF generation (and pypdf/pdfplumber for parsing). Installable as a Claude Code plugin marketplace (document-skills).
- **ReportLab official docs**: ReportLab Inc. official documentation and User Guide (reportlab-userguide.pdf).
- **Community catalogs**: Community-curated skill catalogs referencing document-generation skills.

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| Python (CPython 3.9-3.14) | `pip install reportlab` | `python make_doc.py` |

Notes: Core PDF generation; invoke as a Python script. Add `pip install pillow` for non-JPEG image embedding. Optional extras: `pip install "reportlab[accel,pycairo,bidi,shaping]"` for the C accelerator, cairo rendering, and RTL/complex-script text shaping. No browser/headless display required — pure code-to-PDF.

## Artifact kind

`pdf` — the primary deliverable is a rendered PDF document.

## Validation

Install:
```bash
python3 -m venv /tmp/rl && /tmp/rl/bin/pip install reportlab
```

Smoke:
```bash
/tmp/rl/bin/python -c "from reportlab.lib.pagesizes import letter; from reportlab.pdfgen import canvas; c=canvas.Canvas('/tmp/oota_rl.pdf', pagesize=letter); c.setFont('Helvetica',24); c.drawString(72,720,'OOTA ReportLab smoke test'); c.showPage(); c.save()" && file /tmp/oota_rl.pdf
```

Expect: Command exits 0 and `file` reports `/tmp/oota_rl.pdf: PDF document, version 1.x` — a valid one-page PDF written deterministically with no display server. Runs headless on macOS.

## Wrapper params

- `business-documents.title` (text) — document title / heading.

Wrap as a single Python entrypoint that takes structured input (JSON/dict) and writes a PDF path — keeps the deliverable code-driven and diffable. For byte-stable diffs across runs, override the document creation timestamp (`canvas.setProducer` / set info date, or post-process) since ReportLab stamps CreationDate/ModDate by default. Pin `reportlab==5.0.0` in requirements for reproducibility. For tables/reports, prefer Platypus flowables over raw canvas so pagination is automatic. Bundle fonts alongside the script and `registerFont` at startup to avoid host-font drift. Pillow is a soft dependency — include it if embedding PNG/other raster images.

## Component / explorer notes

Two authoring altitudes. Low-level: `reportlab.pdfgen.canvas.Canvas` for pixel-precise placement (`drawString`, `line`, `rect`, `drawImage`) — best for fixed-layout forms/labels. High-level: Platypus (`reportlab.platypus`) with flowables — `Paragraph`, `Table`, `Spacer`, `Image`, `PageBreak` — assembled into a `SimpleDocTemplate`/`BaseDocTemplate` with `PageTemplates`/`Frames` for auto-flowing multi-page docs. Styling via `reportlab.lib.styles` (`ParagraphStyle`, `getSampleStyleSheet`) and `TableStyle`. Charts/graphics via `reportlab.graphics` (`Drawing`, shapes, `renderPDF`). Fonts: built-in Type1 base-14; register TTFs via `pdfmetrics.registerFont` + `TTFont`. Output is fully deterministic given fixed input (set canvas metadata/timestamps if byte-identical reproducibility is required, since the PDF embeds a creation date by default).
