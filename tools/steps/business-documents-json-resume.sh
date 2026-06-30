#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" business-documents.title "My Resume")"
NAME="$(param "$SESSION" business-documents.name "Jane Doe")"
THEME="$(param "$SESSION" business-documents.theme "jsonresume-theme-even")"
FORMAT="$(param "$SESSION" business-documents.format "html")"

cat > "$OUT/resume.json" <<EOF
{
  "\$schema": "https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json",
  "basics": {
    "name": "$NAME",
    "label": "$TITLE",
    "email": "jane@example.com",
    "summary": "Deterministic resume rendered from JSON Resume schema.",
    "location": { "city": "San Francisco", "countryCode": "US" }
  },
  "work": [
    {
      "name": "Acme Inc",
      "position": "Engineer",
      "startDate": "2022-01-01",
      "summary": "Built things.",
      "highlights": ["Shipped a thing"]
    }
  ],
  "education": [
    {
      "institution": "State University",
      "area": "Computer Science",
      "studyType": "BSc",
      "startDate": "2016-09-01",
      "endDate": "2020-06-01"
    }
  ],
  "skills": [
    { "name": "Engineering", "keywords": ["Systems", "Tooling"] }
  ]
}
EOF
echo "  wrote out/resume.json"

if command -v resumed &>/dev/null; then
  resumed validate "$OUT/resume.json"
  if [ "$FORMAT" = "pdf" ]; then
    resumed render "$OUT/resume.json" --theme "$THEME" --format pdf --output "$OUT/resume.pdf" \
      && echo "  rendered out/resume.pdf"
  else
    resumed render "$OUT/resume.json" --theme "$THEME" --output "$OUT/resume.html" \
      && echo "  rendered out/resume.html"
  fi
else
  echo "  hint: npm install -g resumed && npm install $THEME, then resumed render out/resume.json --theme $THEME --output out/resume.html (add --format pdf + npm install puppeteer for PDF)"
fi
