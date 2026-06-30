#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" markup.title "Hello OOTA")"
AUTHOR="$(param "$SESSION" markup.author "OOTA Author")"
BODY="$(param "$SESSION" markup.body "This is *AsciiDoc* rendered by Asciidoctor.")"

cat > "$OUT/oota.adoc" <<EOF
= ${TITLE}
${AUTHOR}

== Intro

${BODY}

* one
* two
EOF
echo "  wrote out/oota.adoc"

if command -v asciidoctor &>/dev/null; then
  asciidoctor -a nofooter -o "$OUT/oota.html" "$OUT/oota.adoc" && echo "  rendered out/oota.html"
else
  echo "  hint: gem install asciidoctor && asciidoctor -o $OUT/oota.html $OUT/oota.adoc"
  echo "  hint (pdf): gem install asciidoctor-pdf && asciidoctor-pdf -o $OUT/oota.pdf $OUT/oota.adoc"
fi
