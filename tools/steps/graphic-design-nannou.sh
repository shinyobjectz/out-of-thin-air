#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" graphic-design.title "Nannou Sketch")"
SIZE="$(param "$SESSION" graphic-design.size "512")"
BG="$(param "$SESSION" graphic-design.bg "BLACK")"
FG="$(param "$SESSION" graphic-design.fg "STEELBLUE")"

mkdir -p "$OUT/nannou_smoke/src"

cat > "$OUT/nannou_smoke/Cargo.toml" <<EOF
[package]
name = "nannou_smoke"
version = "0.1.0"
edition = "2021"

[dependencies]
nannou = "0.19"
EOF

cat > "$OUT/nannou_smoke/src/main.rs" <<EOF
// $TITLE
use nannou::prelude::*;
fn main(){ nannou::sketch(view).size($SIZE,$SIZE).run(); }
fn view(app:&App, frame:Frame){
    let draw=app.draw();
    draw.background().color($BG);
    draw.ellipse().x_y(0.0,0.0).radius(($SIZE as f32)/4.0).color($FG);
    draw.to_frame(app,&frame).unwrap();
    let path=app.project_path().unwrap().join("out.png");
    app.main_window().capture_frame(path);
}
EOF
echo "  wrote out/nannou_smoke/src/main.rs"

echo "  scaffold only - build: (cd out/nannou_smoke && cargo run --release) -> out.png"
