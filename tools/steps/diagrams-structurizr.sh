# generated draft — needs validation
#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" diagrams.title "My System")"
FORMAT="$(param "$SESSION" diagrams.format "mermaid")"

mkdir -p "$OUT/src"

cat > "$OUT/src/workspace.dsl" <<EOF
workspace "$TITLE" {
  model {
    u = person "User"
    s = softwareSystem "$TITLE" {
      web = container "Web App"
      db = container "Database"
    }
    u -> web "Uses"
    web -> db "Reads from and writes to"
  }
  views {
    systemContext s {
      include *
      autolayout lr
    }
    container s {
      include *
      autolayout lr
    }
  }
}
EOF
echo "  wrote out/src/workspace.dsl"

# graceful render: export DSL -> diagram-as-code text if the CLI is present
if command -v structurizr.sh &>/dev/null; then
  structurizr.sh export -workspace "$OUT/src/workspace.dsl" -format "$FORMAT" -output "$OUT/out" \
    && echo "  rendered out/out/ ($FORMAT diagram-as-code)"
elif command -v structurizr &>/dev/null; then
  structurizr export -workspace "$OUT/src/workspace.dsl" -format "$FORMAT" -output "$OUT/out" \
    && echo "  rendered out/out/ ($FORMAT diagram-as-code)"
else
  echo "  hint: brew install structurizr-cli (needs Java 17+: brew install temurin), then"
  echo "        structurizr.sh export -workspace out/src/workspace.dsl -format $FORMAT -output out/out"
  echo "  hint: image render — mmdc (npm i -g @mermaid-js/mermaid-cli) for mermaid, or the PlantUML jar"
fi
