#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" business-documents.title "Invoice")"
INVOICE_ID="$(param "$SESSION" business-documents.invoice_id "2026-001")"
BILLER="$(param "$SESSION" business-documents.biller "Out Of Thin Air")"
RECIPIENT="$(param "$SESSION" business-documents.recipient "Acme")"
ITEM="$(param "$SESSION" business-documents.item_description "Consulting")"
RATE="$(param "$SESSION" business-documents.hourly_rate "100")"

cat > "$OUT/invoice.typ" <<EOF
#import "@preview/invoice-maker:1.1.0": *
#show: invoice.with(
  language: "en",
  title: "$TITLE",
  banner-image: none,
  invoice-id: "$INVOICE_ID",
  issuing-date: "2026-06-30",
  due-date: "2026-07-14",
  biller: ( name: "$BILLER", vat-id: "DE123", address: ( country: "USA" ) ),
  recipient: ( name: "$RECIPIENT", address: ( country: "USA" ) ),
  hourly-rate: $RATE,
  items: ( ( description: "$ITEM", quantity: 3, ), ),
)
EOF
echo "  wrote out/invoice.typ"

if command -v typst &>/dev/null; then
  typst compile "$OUT/invoice.typ" "$OUT/invoice.pdf" && echo "  rendered out/invoice.pdf"
else
  echo "  hint: brew install typst (or cargo install --locked typst-cli), then: typst compile out/invoice.typ out/invoice.pdf"
fi
