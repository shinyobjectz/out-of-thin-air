<!-- generated draft — needs validation -->
# Typst invoice-maker

slug: `typst-invoice` · category: `business-documents` · artifact kind: `pdf`

## Summary

`invoice-maker` is an official Typst Universe template package (Adrian Sieber, ISC license, v1.1.0) that renders a beautiful PDF invoice from a simple declarative data record (`.typ` or `.yaml`). Supports taxes, discounts, cancellations, multilingual EN/DE, and custom banners/colors/fonts. It is driven by the Typst compiler (Apache-2.0), a single Rust binary that deterministically compiles `.typ` markup to PDF headlessly. The whole pipeline is text-in / PDF-out, version-controllable, and reproducible — a clean OOTA fit. Primary deliverable: a PDF invoice.

## Skills

| Name | Type | Official | License | URL | Attribution |
|------|------|----------|---------|-----|-------------|
| typst-claude-skill | community | no | check repo (MIT-style) | https://github.com/ChanMeng666/typst-claude-skill | ChanMeng666 — Claude Code skill: full Typst language + CLI reference + 9 templates |
| claude-skill-typst | community | no | check repo | https://github.com/lucifer1004/claude-skill-typst | lucifer1004 — Typst skill for agents; also on agentskills.so |
| Typst LLM skill file | community | no | — | https://forum.typst.app/t/llm-skill-file-for-claude-code-codex-etc/8397 | Typst community forum — canonical LLM/agent skill file thread |
| Typst official docs | official-docs | yes | — | https://typst.app/docs/ | Typst GmbH — language + reference docs |
| invoice-maker package docs | official-docs | yes | ISC | https://typst.app/universe/package/invoice-maker/ | Adrian Sieber — the package being researched |

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| Rust / native binary (primary) | `brew install typst` (or `cargo install --locked typst-cli`) | `typst compile invoice.typ out.pdf` |
| JavaScript / Node | `npm install --global typst` (or `npx typst --help`) | `typst compile invoice.typ out.pdf` / `typst.compile()` |
| Rust (library) | `cargo add typst-pdf` | embed compilation in a Rust program |

Native binary is ~40MB, ideal for headless/CI. Apache-2.0. Universe packages (`@preview/invoice-maker`) auto-download on first compile.

## Artifact kind

`pdf` — the universal shell renders the compiled invoice PDF.

## Validation

Install:
```bash
brew install typst && typst --version
```

Smoke:
```bash
mkdir -p /tmp/inv && cat > /tmp/inv/invoice.typ <<'EOF'
#import "@preview/invoice-maker:1.1.0": *
#show: invoice.with(
  language: "en",
  title: "Invoice",
  banner-image: none,
  invoice-id: "2026-001",
  issuing-date: "2026-06-30",
  due-date: "2026-07-14",
  biller: ( name: "Out Of Thin Air", vat-id: "DE123", address: ( country: "USA" ) ),
  recipient: ( name: "Acme", address: ( country: "USA" ) ),
  hourly-rate: 100,
  items: ( ( description: "Consulting", quantity: 3, ), ),
)
EOF
typst compile /tmp/inv/invoice.typ /tmp/inv/invoice.pdf && ls -la /tmp/inv/invoice.pdf
```

Expect: `typst compile` exits 0 and writes a non-empty valid PDF. First run fetches `invoice-maker` from the `@preview` registry. Field names must match the package record (see Universe README); adjust keys if compile errors. Fully headless on macOS, no GUI/network beyond initial package fetch.

## Wrapper params

- `business-documents.title` — invoice title (text)
- `business-documents.invoice_id` — invoice ID (text)
- `business-documents.biller` — biller name (text)
- `business-documents.recipient` — recipient name (text)
- `business-documents.item_description` — line-item description (text)
- `business-documents.hourly_rate` — rate (range/text)

## Component / explorer notes

Deliverable = a single `.typ` source (optionally + a `.yaml` data file) that imports `@preview/invoice-maker` and calls `invoice.with(record)`. Fully deterministic: same source → byte-stable PDF. Keep data (`.yaml`) separate from layout (`.typ`) for clean diffs. Pin the package version (`invoice-maker:1.1.0`) for reproducibility — the README example pins 1.0.0 but current is 1.1.0; use 1.1.0.

Wrapper invokes `typst compile invoice.typ out.pdf`. Data-driven runs: `typst compile --input customer="$(cat data.json)" main.typ`. Batch by looping over data files (parallelizable). Prefer the brew/cargo native binary; the npm `typst` package is the Node-native alternative. First compile needs network to fetch the `@preview` package; pre-warm the cache (`~/.cache/typst`) or vendor it for airgapped CI.
