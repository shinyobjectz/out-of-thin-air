# ZPL (Labelary)

slug: `zpl-labelary` · category: `business-documents` · artifact kind: **image**

## Summary

ZPL (Zebra Programming Language) is a deterministic, plain-text label markup. Labelary is a free, web-accessible ZPL rendering engine (REST API, no key/signup) that renders ZPL source to PNG (default), PDF, and other formats. ZPL is authored as version-controllable markup (`^XA…^XZ` blocks); Labelary (hosted API) or local engines (labelize Rust, Justintime50/labelary Node) render it headlessly to a raster image or PDF.

Primary OOTA deliverable = **image** (PNG label). PDF is the multi-label / print-ready alternate. Source markup (`.zpl`) is fully deterministic and diffable.

## Skills

| Skill | Type | Official | License | Attribution | URL |
|-------|------|----------|---------|-------------|-----|
| Labelary ZPL Label API (service docs) | official-docs | yes | Proprietary (free API, no key; 3 req/s & 5000/day free tier) | Labelary | https://labelary.com/service.html |
| An Introduction to ZPL (ZPL primer) | official-docs | yes | Proprietary | Labelary | https://labelary.com/zpl.html |
| Justintime50/labelary (Node CLI: ZPL → PNG/PDF via API) | community-repo | no | MIT | Justin Paulin | https://github.com/Justintime50/labelary |
| labelize (Rust engine: parse ZPL/EPL → PNG/PDF, offline) | community-repo | no | Open-source (see repo) | GOODBOY008 | https://github.com/GOODBOY008/labelize |
| rjocoleman/labelary (Ruby gem wrapping web service) | community-repo | no | MIT | Robert Coleman | https://github.com/rjocoleman/labelary |
| zpl-labelary-preview (VS Code live preview) | community-repo | no | MIT | Dmytro Vasin | https://github.com/DmytroVasin/zpl-labelary-preview |

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| shell/curl | none — curl ships with macOS | `curl --request POST 'http://api.labelary.com/v1/printers/8dpmm/labels/4x6/0/' --data-binary @label.zpl > label.png` |
| JavaScript (Node) | `npm i -g labelary` | `labelary` (converts ZPL files to PNG/PDF via Labelary API) |
| Rust | `cargo install --git https://github.com/GOODBOY008/labelize` | `labelize render input.zpl -o out.png` (offline, no network) |
| Ruby | `gem install labelary` | Labelary client renders ZPL string to PNG/PDF |

Notes:
- **curl** is the canonical driver. `dpmm` ∈ {6,8,12,24}; width/height in inches; index base-0 (omit for multi-label PDF). `Accept: image/png` (default) or `application/pdf`. No API key for the free tier.
- **labelize** (Rust) is a fully offline ZPL/EPL renderer — best for deterministic CI without hitting the hosted API.
- Node + Ruby tools are network-dependent (wrap the hosted API).

## Artifact kind

**image** — the primary deliverable is a rendered PNG label (one ZPL block → one label). Choose **pdf** when packing multiple labels or wanting print-ready output.

## Validation

Install (macOS, headless; curl preinstalled, no API key):
```bash
printf '^XA^CFA,50^FO100,100^FDHello OOTA^FS^XZ' > /tmp/label.zpl
```

Smoke:
```bash
curl --silent --request POST 'http://api.labelary.com/v1/printers/8dpmm/labels/4x6/0/' \
  --data-binary @/tmp/label.zpl --output /tmp/label.png && file /tmp/label.png
```

Expect: `/tmp/label.png` exists and `file` reports `PNG image data, 1200 x 1800` (8dpmm × 4×6in). For PDF: add `--header 'Accept: application/pdf'`, omit the index, output `label.pdf` → `PDF document`. Offline alternative: `labelize render /tmp/label.zpl -o /tmp/label.png` (no network).

## Wrapper params

- `business-documents.title` (text) — label text content.
- `business-documents.dpmm` (select: 6/8/12/24) — dots per mm; 8dpmm = 203dpi thermal default.
- `business-documents.width` / `business-documents.height` (text, inches) — physical label size; pins reproducible pixel dims.
- `business-documents.format` (select: png/pdf) — PNG = 1 label/request (index); PDF packs all labels (omit index).

## Component / explorer notes

Deliverable is a label: author `.zpl` markup (deterministic plain text, `^XA…^XZ` blocks, `^FO` position, `^FD` data, `^BC` barcodes). One ZPL block = one label. Render at fixed dpmm and physical inches so output pixel dims are reproducible.

Two render paths: (1) hosted Labelary REST API — zero install, but network-dependent and rate-limited (3 req/s, 5000/day), non-hermetic for strict CI; (2) labelize (Rust) — offline, hermetic, deterministic, preferred for reproducible headless builds. Wrap as: input = `*.zpl` source files; params = dpmm + width + height + format(png|pdf); output = rendered file. Pin dpmm/dimensions in config for byte-stable renders. Enable the Labelary linter via the `X-Linter` header (or labelize parse errors) to validate ZPL before render.
