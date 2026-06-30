#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" business-documents.title "Test User")"
THEME="$(param "$SESSION" business-documents.theme "classic")"

cat > "$OUT/cv.yaml" <<EOF
cv:
  name: $TITLE
  email: ${TITLE// /.}@example.com
  sections:
    summary:
      - Experienced professional with a track record of shipping deterministic, version-controlled documents.
    experience:
      - company: Example Co
        position: Senior Engineer
        start_date: 2022-01
        end_date: present
        highlights:
          - Built reproducible CV pipelines from plain YAML source.
design:
  theme: $THEME
EOF
echo "  wrote out/cv.yaml"

if command -v rendercv &>/dev/null; then
  rendercv render "$OUT/cv.yaml" --output-folder-name "$OUT/rendercv_output" \
    && echo "  rendered out/rendercv_output/cv.pdf"
else
  echo "  hint: pip install \"rendercv[full]\" then rendercv render \"$OUT/cv.yaml\" --output-folder-name \"$OUT/rendercv_output\""
fi
