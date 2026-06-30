#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" creative.title "sketch")"
ENGINE="$(param "$SESSION" creative.engine "node-p5")"
WIDTH="$(param "$SESSION" creative.width "800")"
HEIGHT="$(param "$SESSION" creative.height "800")"
SEED="$(param "$SESSION" creative.seed "42")"
COUNT="$(param "$SESSION" creative.count "200")"
BG="$(param "$SESSION" creative.bg "#141414")"

mkdir -p "$OUT/src"

# --- headless p5.js render script (node-p5) ---
cat > "$OUT/src/render.js" <<EOF
// $TITLE — headless p5.js generative sketch (node-p5)
const p5 = require('node-p5');

const W = $WIDTH, H = $HEIGHT, SEED = $SEED, COUNT = $COUNT, BG = '$BG';

function sketch(p) {
  p.setup = function () {
    const c = p.createCanvas(W, H);
    p.randomSeed(SEED);
    p.noiseSeed(SEED);
    p.background(BG);
    p.noStroke();
    for (let i = 0; i < COUNT; i++) {
      const n = p.noise(i * 0.05);
      p.fill(p.random(255), p.random(255), p.random(255), 150);
      p.ellipse(p.random(W), p.random(H), p.random(10, 60) * (0.5 + n));
    }
    p.saveCanvas(c, 'sketch', 'png').then(() => process.exit(0));
  };
}

p5.createSketch(sketch);
EOF
echo "  wrote out/src/render.js"

# --- native Processing sketch (saveFrame + exit) ---
mkdir -p "$OUT/src/processing"
cat > "$OUT/src/processing/processing.pde" <<EOF
// $TITLE — native Processing sketch
void setup() {
  size($WIDTH, $HEIGHT);
  randomSeed($SEED);
  noiseSeed($SEED);
  background(unhex("FF" + "${BG//#/}"));
  noStroke();
  for (int i = 0; i < $COUNT; i++) {
    fill(random(255), random(255), random(255), 150);
    float n = noise(i * 0.05);
    ellipse(random(width), random(height), random(10, 60) * (0.5 + n), random(10, 60) * (0.5 + n));
  }
  saveFrame("sketch.png");
  exit();
}
EOF
echo "  wrote out/src/processing/processing.pde"

# graceful render: prefer node-p5 (headless, no display); else native processing-java; else hint
if [ "$ENGINE" = "processing-java" ] && command -v processing-java &>/dev/null; then
  processing-java --sketch="$OUT/src/processing" --output="$OUT/.p5build" --force --run \
    && cp "$OUT/src/processing/sketch.png" "$OUT/sketch.png" 2>/dev/null || true
  [ -f "$OUT/sketch.png" ] && echo "  rendered out/sketch.png" || echo "  hint: processing-java produced no frame; check saveFrame path"
elif command -v node &>/dev/null && [ -d "$OUT/node_modules/node-p5" -o -d "node_modules/node-p5" ]; then
  ( cd "$OUT" && node src/render.js ) && echo "  rendered out/sketch.png"
else
  echo "  hint: npm install node-p5 && (cd $OUT && node src/render.js)"
  echo "  hint: or install Processing (https://processing.org/download) and run: processing-java --sketch=$OUT/src/processing --output=/tmp/p5out --force --run"
fi
