#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" creative.title "Generative Sketch")"
WIDTH="$(param "$SESSION" creative.width "600")"
HEIGHT="$(param "$SESSION" creative.height "600")"
SEED="$(param "$SESSION" creative.seed "42")"
PALETTE="$(param "$SESSION" creative.palette "#141414")"
FILL="$(param "$SESSION" creative.fill "#ff7800")"
FRAMERATE="$(param "$SESSION" creative.framerate "30")"

mkdir -p "$OUT/src"

# minimal valid p5 sketch (browser deliverable)
cat > "$OUT/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${TITLE}</title>
  <script src="https://cdn.jsdelivr.net/npm/p5/lib/p5.min.js"></script>
  <style>html,body{margin:0;background:${PALETTE};display:flex;justify-content:center;align-items:center;min-height:100vh}</style>
</head>
<body>
  <script src="src/sketch.js"></script>
</body>
</html>
EOF

cat > "$OUT/src/sketch.js" <<EOF
// ${TITLE} — p5.js sketch
let W = ${WIDTH}, H = ${HEIGHT};

function setup() {
  createCanvas(W, H);
  randomSeed(${SEED});
  noiseSeed(${SEED});
  frameRate(${FRAMERATE});
}

function draw() {
  background('${PALETTE}');
  fill('${FILL}');
  noStroke();
  let t = frameCount * 0.01;
  for (let i = 0; i < 24; i++) {
    let a = (TWO_PI / 24) * i + t;
    let r = (min(W, H) / 3) * (0.6 + 0.4 * noise(i, t));
    ellipse(W / 2 + cos(a) * r, H / 2 + sin(a) * r, 28);
  }
}
EOF

echo "  wrote out/index.html"
echo "  wrote out/src/sketch.js"

# graceful render: headless PNG via node-p5 if available, else hint
if node -e "require.resolve('node-p5')" &>/dev/null; then
  node -e "const p5=require('node-p5');p5.createSketch(p=>{p.setup=()=>{const c=p.createCanvas(${WIDTH},${HEIGHT});p.randomSeed(${SEED});p.noiseSeed(${SEED});p.background('${PALETTE}');p.noStroke();p.fill('${FILL}');for(let i=0;i<24;i++){const a=(p.TWO_PI/24)*i;const r=(Math.min(${WIDTH},${HEIGHT})/3)*(0.6+0.4*p.noise(i,0));p.ellipse(${WIDTH}/2+Math.cos(a)*r,${HEIGHT}/2+Math.sin(a)*r,28);}p.saveCanvas(c,'${OUT}/preview','png').then(()=>process.exit(0));};});" \
    && echo "  rendered out/preview.png"
else
  echo "  hint: open out/index.html in a browser; for headless PNG: npm install node-p5 then re-run this step"
fi
