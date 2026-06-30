<!-- generated draft — needs validation -->
# usd_from_gltf (usdcat) — ar-vr / usd-from-gltf

## Summary
usd_from_gltf (UFG) is Google's native C++ library + CLI + USD import plugin that converts glTF 2.0 (`.gltf` / `.glb`) into Pixar USD assets, primarily `.usdz` for iOS AR Quick Look. The deterministic, version-controllable source artifact is the glTF (JSON-text `.gltf` + textures/buffers, or binary `.glb`); UFG is a pure render/transform step that emits a single `.usdz` (artifact kind **model3d**). Conversion is deterministic for a given input + flag set, and the CLI is ~10-15x faster than Python alternatives.

The upstream repo was **archived (read-only) on 2024-06-06** and is "not an officially supported Google product." There is no easy native macOS build (you must compile Pixar USD from source), so the practical headless macOS path is the community Docker image `leon/usd-from-gltf`, which wraps UFG + USD. Pair with `usdcat` (ships with Pixar USD) to dump the result to `.usda` text for diff/version control, and `usdchecker` for AR-compatibility validation. Apache-2.0. No official Anthropic/Claude skill; no strong dedicated community skill — only README docs and Docker wrappers.

## Skills
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| google/usd_from_gltf (README + tools) | docs+cli | https://github.com/google/usd_from_gltf | official | Apache-2.0 | Google (archived 2024-06-06; not an officially supported Google product) |
| leon/docker-gltf-to-udsz (Docker wrapper, headless macOS path) | community-docker | https://github.com/leon/docker-gltf-to-udsz | community | MIT | Leon Radley — Docker Hub image `leon/usd-from-gltf` |
| marlon360/gltf-to-usdz-service (Docker service wrapper) | community-docker | https://github.com/marlon360/gltf-to-usdz-service | community | MIT | marlon360 |
| pablode/guc (alternate glTF→USD converter, MaterialX) | community-alternative | https://github.com/pablode/guc | community | Apache-2.0 | pablode — actively maintained alternative if archived UFG is a blocker |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| C++ / CLI (via Docker) | `docker pull leon/usd-from-gltf:latest` | `docker run --rm -v "$PWD":/usr/app leon/usd-from-gltf:latest in.glb out.usdz` |
| C++ / CLI (native) | build Pixar USD from source; `brew install nasm`; `pip install pillow`; `python {UFG_SRC}/tools/ufginstall/ufginstall.py {UFG_BUILD} {USD} --testdata` | `{UFG_BUILD}/bin/usd_from_gltf in.glb out.usdz` (needs `PXR_PLUGINPATH_NAME` + `(DY)LD_LIBRARY_PATH`) |
| USD text inspect | ships with Pixar USD | `usdcat out.usdz` → dumps `.usda`; `usdchecker out.usdz` validates AR-compat |

## Artifact kind
**model3d** — the primary deliverable is a single `.usdz` asset for iOS AR Quick Look (validates in macOS Quick Look / Reality Composer / `usdchecker`).

## Validation
- **install**: Use Docker (only reliable headless path on macOS — native build requires compiling Pixar USD from source). `docker pull leon/usd-from-gltf:latest`. (Native alt: build USD per its README, `brew install nasm`, `pip install pillow`, then `python {UFG_SRC}/tools/ufginstall/ufginstall.py {UFG_BUILD} {USD} --testdata`.)
- **smoke**: `mkdir -p /tmp/ufg && cd /tmp/ufg && curl -L -o box.glb https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Box/glTF-Binary/Box.glb && docker run --rm -v "$PWD":/usr/app leon/usd-from-gltf:latest box.glb box.usdz && ls -l box.usdz && file box.usdz`
- **expect**: Command exits 0 and `box.usdz` is created (non-zero size, typically a few KB). `file box.usdz` reports a Zip archive (USDZ is an uncompressed zip container). Optionally `usdchecker box.usdz` (if Pixar USD tools present) reports the asset is AR-compatible / passes.

## Wrapper params
- `ar-vr.title` (text) — asset title / output basename.
- `ar-vr.source` (textarea, bound to `src/model.gltf`) — the deterministic glTF 2.0 source (JSON text).
- `ar-vr.output_format` (select: usdz, usda) — `usdz` for AR delivery, `usda` for text inspection.

## Component / explorer notes
Pipeline role: author/version a glTF 2.0 asset (text `.gltf` + textures/buffers, or `.glb`) as the deterministic source, then run UFG as a pure transform to emit `.usdz`. Notable flags: `--output_format` (usda/usdz), Draco-compressed mesh reading, embedded binary data support. UFG warns rather than fails on unsupported glTF extensions, so a wrapper should parse warnings and surface exit code + stderr. Pin the Docker image digest for determinism. Recommended wrapper contract: take a glTF/glb path + output path, mount cwd into the container, invoke `usd_from_gltf in.glb out.usdz`, return the `.usdz`; provide a batch mode (iterate `*.glb`) and a second verb running `usdcat out.usdz` for snapshot diffing. Alternates if archived status becomes a blocker: `guc` (pablode/guc, MaterialX) or Apple `usdzconvert`.
