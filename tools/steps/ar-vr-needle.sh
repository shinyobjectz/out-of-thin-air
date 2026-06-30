#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" ar-vr.title "Needle Scene")"

# Minimal valid Needle Engine standalone source: an HTML entry + a TS scene.
cat > "$OUT/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>$TITLE</title>
</head>
<body style="margin:0">
  <needle-engine></needle-engine>
  <script type="module" src="./src/main.ts"></script>
</body>
</html>
EOF

mkdir -p "$OUT/src"
cat > "$OUT/src/main.ts" <<'EOF'
import { onStart } from "@needle-tools/engine";
import * as THREE from "three";

onStart((context) => {
  const scene = context.scene;
  const geometry = new THREE.BoxGeometry(1, 1, 1);
  const material = new THREE.MeshStandardMaterial({ color: 0x44aa88 });
  const cube = new THREE.Mesh(geometry, material);
  scene.add(cube);

  const light = new THREE.DirectionalLight(0xffffff, 1);
  light.position.set(2, 3, 4);
  scene.add(light);
});
EOF

cat > "$OUT/package.json" <<EOF
{
  "name": "oota-needle",
  "private": true,
  "type": "module",
  "scripts": { "dev": "vite", "build": "vite build" },
  "dependencies": {
    "@needle-tools/engine": "*",
    "three": "*"
  },
  "devDependencies": { "vite": "*" }
}
EOF

echo "  wrote out/index.html + out/src/main.ts + out/package.json"

echo "  scaffold only - build: (cd out && npm install && npm run build) -> dist/"
