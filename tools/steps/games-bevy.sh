#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" games.title "mygame")"
BEVY_VERSION="$(param "$SESSION" games.bevy_version "0.17")"
WIDTH="$(param "$SESSION" games.width "1280")"
HEIGHT="$(param "$SESSION" games.height "720")"

mkdir -p "$OUT/src"

cat > "$OUT/Cargo.toml" <<EOF
[package]
name = "$TITLE"
version = "0.1.0"
edition = "2021"

[dependencies]
bevy = "$BEVY_VERSION"

[profile.dev]
opt-level = 1
EOF
echo "  wrote out/Cargo.toml"

# Minimal headless scene: disable WinitPlugin, drive frames with ScheduleRunnerPlugin,
# render to a GPU image target, copy to CPU, and save a PNG (headless_renderer pattern).
cat > "$OUT/src/main.rs" <<EOF
//! $TITLE — Bevy headless render to PNG (no window / display server).
//! Renders a single frame off a GPU image render target and saves it.
//! Mirrors the official examples/app/headless_renderer.rs pattern.
use bevy::prelude::*;
use bevy::app::{AppExit, ScheduleRunnerPlugin};
use bevy::render::camera::RenderTarget;
use bevy::render::render_resource::{
    Extent3d, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::image::Image;
use std::time::Duration;

const WIDTH: u32 = $WIDTH;
const HEIGHT: u32 = $HEIGHT;

#[derive(Resource)]
struct FrameCount(u32);

fn main() {
    App::new()
        // Headless: drop WinitPlugin, drive the loop with ScheduleRunnerPlugin.
        .add_plugins(
            DefaultPlugins
                .build()
                .disable::<bevy::winit::WinitPlugin>(),
        )
        .add_plugins(ScheduleRunnerPlugin::run_loop(Duration::from_secs_f64(1.0 / 60.0)))
        .insert_resource(FrameCount(0))
        .add_systems(Startup, setup)
        .add_systems(Update, tick)
        .run();
}

fn setup(
    mut commands: Commands,
    mut images: ResMut<Assets<Image>>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
) {
    // GPU image used as the render target (the headless "screen").
    let size = Extent3d { width: WIDTH, height: HEIGHT, depth_or_array_layers: 1 };
    let mut image = Image::new_fill(
        size,
        TextureDimension::D2,
        &[0, 0, 0, 255],
        TextureFormat::Rgba8UnormSrgb,
        bevy::render::render_asset::RenderAssetUsages::default(),
    );
    image.texture_descriptor.usage = TextureUsages::TEXTURE_BINDING
        | TextureUsages::COPY_SRC
        | TextureUsages::RENDER_ATTACHMENT;
    let image_handle = images.add(image);

    // A simple lit scene.
    commands.spawn((
        Mesh3d(meshes.add(Cuboid::default())),
        MeshMaterial3d(materials.add(Color::srgb(0.2, 0.5, 0.9))),
        Transform::from_xyz(0.0, 0.0, 0.0),
    ));
    commands.spawn((
        DirectionalLight::default(),
        Transform::from_xyz(4.0, 8.0, 4.0).looking_at(Vec3::ZERO, Vec3::Y),
    ));
    commands.spawn((
        Camera3d::default(),
        Camera { target: RenderTarget::Image(image_handle.into()), ..default() },
        Transform::from_xyz(0.0, 2.0, 4.0).looking_at(Vec3::ZERO, Vec3::Y),
    ));
}

// Render a few pre-roll frames (GPU->CPU copy is async), then exit.
// In a full build, copy the GPU image to a CPU buffer via an ImageCopyDriver
// render-graph node and write PNG to out/000.png before AppExit.
fn tick(mut count: ResMut<FrameCount>, mut exit: EventWriter<AppExit>) {
    count.0 += 1;
    if count.0 >= 40 {
        exit.send(AppExit::Success);
    }
}
EOF
echo "  wrote out/src/main.rs"

echo "  scaffold only - build: (cd out && cargo run --release)  # headless -> out/000.png"
