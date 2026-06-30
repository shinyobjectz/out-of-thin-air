# generated draft — needs validation
#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" motion-graphics.title "Theatre Scene")"
FPS="$(param "$SESSION" motion-graphics.fps "30")"
DURATION="$(param "$SESSION" motion-graphics.duration "1")"

# Minimal valid Theatre.js project state JSON (the deterministic, git-trackable artifact).
cat > "$OUT/state.json" <<EOF
{
  "sheetsById": {
    "Scene": {
      "staticOverrides": { "byObject": {} },
      "sequence": {
        "subUnitsPerUnit": ${FPS},
        "length": ${DURATION},
        "type": "PositionalSequence",
        "tracksByObject": {
          "rect": {
            "trackData": {
              "x-track": {
                "type": "BasicKeyframedTrack",
                "__debugName": "rect:[\"x\"]",
                "keyframes": [
                  { "id": "kf0", "position": 0, "connectedRight": true, "handles": [0.5,1,0.5,0], "type": "bezier", "value": 0 },
                  { "id": "kf1", "position": ${DURATION}, "connectedRight": false, "handles": [0.5,1,0.5,0], "type": "bezier", "value": 1 }
                ]
              }
            },
            "trackIdByPropPath": { "[\"x\"]": "x-track" }
          }
        }
      }
    }
  },
  "definitionVersion": "0.4.0",
  "revisionHistory": []
}
EOF
echo "  wrote out/state.json"

# Minimal render page that binds @theatre/core to a canvas and exposes the sequence for frame-stepping.
cat > "$OUT/render.html" <<'EOF'
<!doctype html><meta charset="utf-8"><canvas id="c" width="320" height="120"></canvas>
<script type="module">
import { getProject } from 'https://esm.sh/@theatre/core';
const state = await (await fetch('./state.json')).json();
const proj = getProject('${TITLE}', { state });
const sheet = proj.sheet('Scene');
const obj = sheet.object('rect', { x: 0 });
const ctx = document.getElementById('c').getContext('2d');
obj.onValuesChange(v => { ctx.clearRect(0,0,320,120); ctx.fillRect(v.x*280, 40, 40, 40); });
window.__seq = sheet.sequence; // driver steps __seq.position per frame (NOT play())
</script>
EOF
echo "  wrote out/render.html"

# Graceful-degrade render: deterministic frame-step capture + ffmpeg encode.
if command -v node &>/dev/null && command -v ffmpeg &>/dev/null; then
  echo "  hint: node capture.js (step window.__seq.position=f/${FPS}, screenshot frame_%d.png), then:"
  echo "        ffmpeg -framerate ${FPS} -i frame_%d.png -pix_fmt yuv420p \"$OUT/out.mp4\""
else
  echo "  hint: npm i @theatre/core three && npm i -D puppeteer && brew install ffmpeg, then run the capture+encode pipeline"
fi
