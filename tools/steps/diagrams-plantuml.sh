#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "Hello Sequence")"
FORMAT="$(param "$SESSION" diagrams.format "svg")"
LAYOUT="$(param "$SESSION" diagrams.layout "dot")"

mkdir -p "$OUT/src"
cat > "$OUT/src/diagram.puml" <<EOF
@startuml
title $TITLE
Alice -> Bob: Hello
Bob --> Alice: Hi
@enduml
EOF
echo "  wrote out/src/diagram.puml"

if command -v plantuml &>/dev/null; then
  LAYOUT_FLAG=""
  [ "$LAYOUT" = "smetana" ] && LAYOUT_FLAG="-Playout=smetana"
  plantuml "-t${FORMAT}" $LAYOUT_FLAG -Djava.awt.headless=true -charset UTF-8 -o "$OUT" "$OUT/src/diagram.puml" \
    && echo "  rendered out/diagram.${FORMAT}"
else
  echo "  hint: brew install plantuml  then  plantuml -t${FORMAT} $OUT/src/diagram.puml"
fi
