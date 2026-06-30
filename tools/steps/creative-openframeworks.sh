#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" creative.title "openFrameworks Sketch")"
PLATFORM="$(param "$SESSION" creative.platform "emscripten")"
WIDTH="$(param "$SESSION" creative.width "1024")"
HEIGHT="$(param "$SESSION" creative.height "768")"
FRAMERATE="$(param "$SESSION" creative.framerate "60")"
BACKGROUND="$(param "$SESSION" creative.background "#141414")"
FILL="$(param "$SESSION" creative.fill "#ff7800")"

mkdir -p "$OUT/src"

# minimal valid openFrameworks app (C++ source: ofApp.h / ofApp.cpp / main.cpp)
cat > "$OUT/src/ofApp.h" <<EOF
#pragma once
#include "ofMain.h"

class ofApp : public ofBaseApp {
public:
    void setup() override;
    void update() override;
    void draw() override;
};
EOF

cat > "$OUT/src/ofApp.cpp" <<EOF
// ${TITLE} — openFrameworks app
#include "ofApp.h"

void ofApp::setup() {
    ofSetWindowTitle("${TITLE}");
    ofSetFrameRate(${FRAMERATE});
    ofSetBackgroundColor(ofColor::fromHex(0x${BACKGROUND#\#}));
}

void ofApp::update() {}

void ofApp::draw() {
    ofSetColor(ofColor::fromHex(0x${FILL#\#}));
    ofNoFill();
    ofSetLineWidth(2);
    float t = ofGetElapsedTimef();
    float cx = ofGetWidth() * 0.5f, cy = ofGetHeight() * 0.5f;
    int n = 24;
    for (int i = 0; i < n; i++) {
        float a = (TWO_PI / n) * i + t;
        float r = (std::min(ofGetWidth(), ofGetHeight()) / 3.0f)
                  * (0.6f + 0.4f * ofNoise(i, t));
        ofDrawCircle(cx + cosf(a) * r, cy + sinf(a) * r, 14);
    }
}
EOF

cat > "$OUT/src/main.cpp" <<EOF
#include "ofMain.h"
#include "ofApp.h"

int main() {
    ofSetupOpenGL(${WIDTH}, ${HEIGHT}, OF_WINDOW);
    ofRunApp(new ofApp());
}
EOF

# host shell for the WebGL/wasm artifact (filled in by the emscripten build output)
cat > "$OUT/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${TITLE}</title>
  <style>html,body{margin:0;background:${BACKGROUND};display:flex;justify-content:center;align-items:center;min-height:100vh}
  canvas{display:block;background:${BACKGROUND}}</style>
</head>
<body>
  <!-- emmake build emits the runtime + .wasm; this canvas hosts it -->
  <canvas id="canvas" width="${WIDTH}" height="${HEIGHT}"></canvas>
  <script>var Module = { canvas: document.getElementById('canvas') };</script>
  <!-- after \`emmake make\`, include the generated loader, e.g.: -->
  <!-- <script src="${TITLE// /_}.js"></script> -->
</body>
</html>
EOF

echo "  wrote out/src/ofApp.h"
echo "  wrote out/src/ofApp.cpp"
echo "  wrote out/src/main.cpp"
echo "  wrote out/index.html"

# graceful render: build WebGL via emsdk if present, else hint
if [[ "$PLATFORM" == "emscripten" ]] && command -v emmake &>/dev/null; then
  echo "  emmake found — run \`emmake make\` in a generated OF emscripten project to emit .wasm/.js into out/"
elif command -v make &>/dev/null && [[ -n "${OF_ROOT:-}" ]]; then
  echo "  OF_ROOT set — scaffold a project (projectGenerator) then \`make -j4 && make RunRelease\`"
else
  echo "  hint: install openFrameworks (git clone --depth 1 https://github.com/openframeworks/openFrameworks && cd openFrameworks/scripts/osx && ./download_libs.sh),"
  echo "        then for the WebGL artifact set up emsdk (https://openframeworks.cc/setup/emscripten/) and run \`emmake make\`"
fi
