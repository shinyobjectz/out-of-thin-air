<!-- generated draft — needs validation -->
# Babylon.js (NullEngine) (ar-vr)

## Summary
Babylon.js `NullEngine` is the headless variant of the Babylon.js WebGL engine. It
instantiates a full scene graph (meshes, cameras, lights, materials, animations) in
Node.js with no canvas and no WebGL context, then serializes deterministically to
glTF/GLB via `@babylonjs/serializers` (`GLTF2Export`). This makes it a
code-authored, version-controllable path to the **model3d** artifact kind — the
scene is plain JS/TS, so it is diff-able and reproducible.

Caveat: because `NullEngine` has no GPU/WebGL context it cannot read pixel data, so
procedurally-generated/baked textures often fail to export with "failed to read
pixels". Geometry, transforms, node hierarchy, and materials referencing
pre-existing image buffers export reliably. `NullEngine` is also widely used as a
headless test/animation engine. There is NO official Anthropic/Claude skill — rely
on official Babylon.js docs.

Primary deliverable kind: **model3d** (`.glb` / `.gltf`). It is NOT a raster
image/video renderer — for pixels you'd need Babylon Native or a WebGL-capable
headless path (out of scope).

## Skills
| Name | Type | Official | URL | License |
|---|---|---|---|---|
| No official Anthropic/Claude skill | none | no | https://github.com/anthropics/skills | n/a |
| Babylon.js Server-Side / NullEngine docs | docs | yes | https://doc.babylonjs.com/advanced_topics/serverSide | Apache-2.0 (docs CC-BY) |
| glTF Exporter docs | docs | yes | https://doc.babylonjs.com/features/featuresDeepDive/Exporters/glTFExporter | Apache-2.0 |
| NullEngine API reference (typedoc) | docs | yes | https://doc.babylonjs.com/typedoc/classes/BABYLON.NullEngine | Apache-2.0 |
| Headless specs with NullEngine (community guide) | tutorial | no | https://kmitov.com/posts/how-to-do-headless-specs-with-the-babylon-js-nullengine/ | n/a |
| NullEngine GLB export with textures workaround (forum) | thread | no | https://forum.babylonjs.com/t/nullengine-glb-export-with-textures-workaround/62541 | n/a |

Attribution: BabylonJS team (Apache-2.0); community guide by Kiril Mitov; forum thread Babylon.js community.

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| JavaScript/TypeScript (canonical) | `npm install @babylonjs/core @babylonjs/serializers` | `new NullEngine()` → `new Scene(engine)` → add meshes/cameras/lights → `await GLTF2Export.GLBAsync(scene, name)` → write returned glb data to disk |
| JavaScript (UMD, plain script) | `npm install babylonjs babylonjs-serializers` | Same flow via `BABYLON.NullEngine` / `BABYLON.GLTF2Export`; works in plain CJS Node scripts |

Node.js >=18. Pin `@babylonjs/core` and `@babylonjs/serializers` to the **same
major/minor** version.

## Artifact kind
**model3d** — `.glb` / `.gltf` produced by `GLTF2Export`. Scene authored entirely
in code so it is diff-able / version-controllable.

## Validation
- **install:** `mkdir bjs && cd bjs && npm init -y && npm pkg set type=module && npm install @babylonjs/core @babylonjs/serializers`
- **smoke:** `node smoke.mjs` where `smoke.mjs`:
  ```js
  import { NullEngine, Scene, ArcRotateCamera, HemisphericLight, MeshBuilder, Vector3 } from '@babylonjs/core';
  import { GLTF2Export } from '@babylonjs/serializers';
  import { writeFileSync } from 'node:fs';
  const engine = new NullEngine();
  const scene = new Scene(engine);
  new ArcRotateCamera('cam', 1, 1, 4, Vector3.Zero(), scene);
  new HemisphericLight('l', new Vector3(0,1,0), scene);
  MeshBuilder.CreateSphere('s', { diameter: 1 }, scene);
  const glb = await GLTF2Export.GLBAsync(scene, 'out');
  glb.glTFFiles['out.glb'].arrayBuffer().then(b => writeFileSync('out.glb', Buffer.from(b)));
  ```
- **expect:** Writes `out.glb` (binary glTF, magic bytes `glTF`, ~1-3KB) containing
  the sphere mesh + camera + light. Validate with:
  `node -e "console.log(require('fs').readFileSync('out.glb').slice(0,4).toString())"`
  → prints `glTF`. Fully headless on macOS, no GPU. Geometry export deterministic;
  baked/procedural textures may throw "failed to read pixels".

## Wrapper params
- `ar-vr.title` — model name / glTF root name
- `ar-vr.primitive` — mesh primitive to build (sphere | box | torus | cylinder)
- `ar-vr.scene_spec` — JS scene builder source `build(scene)` (bind to `src/scene.mjs`)
- `ar-vr.diameter` — primitive size
- `ar-vr.format` — output format (glb | gltf)

## Component / explorer notes
The deterministic deliverable is **model3d** via `GLTF2Export`. Wrap as a Node CLI:
input = a JS/TS scene module exporting `build(scene)`; output = `.glb` written to a
deterministic path. Pin `@babylonjs/core` and `@babylonjs/serializers` to a matched
major/minor. Pre-bake/inline any required textures as image buffers loaded BEFORE
export, or keep materials texture-light — `NullEngine` has no WebGL context so
pixel readback of procedural/baked textures fails. For reproducibility, set fixed
mesh subdivisions and avoid random seeds. `GLBAsync` return shape varies by version
(a `glTFFiles` map of Blob-like entries) — read via `.arrayBuffer()`. Strength:
programmatic mesh generation, glTF merging/composition, transform/material
authoring. NOT an image/video renderer.
