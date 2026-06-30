#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "Thin Air")"
VARIANT="$(param "$SESSION" games.variant "debug")"

# --- minimal valid Defold project skeleton (plain text / protobuf / INI) ---
mkdir -p "$OUT/src/main"

cat > "$OUT/game.project" <<EOF
[project]
title = $TITLE
version = 1.0
write_log = 0

[bootstrap]
main_collection = /src/main/main.collectionc

[display]
width = 960
height = 540

[script]
shared_state = 1
EOF

cat > "$OUT/src/main/main.collection" <<'EOF'
name: "main"
instances {
  id: "logic"
  prototype: "/src/main/main.go"
}
scale_along_z: 0
EOF

cat > "$OUT/src/main/main.go" <<'EOF'
components {
  id: "main"
  component: "/src/main/main.script"
}
EOF

# games.script control may override this file via the wrapper binding
cat > "$OUT/src/main/main.script" <<'EOF'
function init(self)
    msg.post(".", "acquire_input_focus")
    print("Defold: thin-air game online")
end

function update(self, dt)
end
EOF

echo "  wrote out/game.project + src/main/{main.collection,main.go,main.script}"

# --- graceful-degrade render: HTML5/wasm-web bundle via bob.jar ---
if command -v java &>/dev/null && [ -f /tmp/bob.jar ]; then
  ( cd "$OUT" && java -jar /tmp/bob.jar --archive --platform wasm-web --variant "$VARIANT" \
      resolve distclean build bundle ) \
    && echo "  rendered out/build/default/*/index.html"
else
  echo "  hint: brew install --cask temurin@25 && curl -L -o /tmp/bob.jar https://github.com/defold/defold/releases/latest/download/bob.jar"
  echo "  then: (cd \"$OUT\" && java -jar /tmp/bob.jar --archive --platform wasm-web --variant $VARIANT resolve distclean build bundle)"
fi
