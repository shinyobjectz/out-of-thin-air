#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" motion-graphics.title "Hello GSAP")"
DURATION="$(param "$SESSION" motion-graphics.duration "2")"
FPS="$(param "$SESSION" motion-graphics.fps "60")"

cat > "$OUT/scene.html" <<EOF
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
  html,body{margin:0;width:1920px;height:1080px;background:#0b0d12;overflow:hidden}
  #box{position:absolute;top:480px;left:120px;width:120px;height:120px;
       background:#41d6c3;border-radius:16px}
  #title{position:absolute;top:80px;left:120px;color:#fff;
          font:600 64px/1 system-ui,sans-serif}
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
</head>
<body>
  <div id="title">$TITLE</div>
  <div id="box"></div>
  <script>
    // single global timeline the renderer can scrub frame-by-frame
    gsap.globalTimeline.clear();
    gsap.to('#box', { x: 1500, rotation: 360, duration: $DURATION, ease: 'power1.inOut' });
  </script>
</body>
</html>
EOF
echo "  wrote out/scene.html"

if command -v gsap-video-export &>/dev/null; then
  gsap-video-export "$OUT/scene.html" --output "$OUT/scene.mp4" --fps "$FPS" && echo "  rendered out/scene.mp4"
else
  echo "  hint: npm install -g gsap-video-export && (command -v ffmpeg || brew install ffmpeg), then gsap-video-export $OUT/scene.html --output $OUT/scene.mp4"
fi
