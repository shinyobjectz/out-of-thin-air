<!-- generated draft — needs validation -->
# three.js (headless render)

slug: `threejs-headless` · category: `creative` · artifact kind: `image`

## Summary

three.js is a JavaScript 3D library. Driven headlessly (no browser window) it renders a
deterministic scene graph to a PNG image on the server. Two viable headless paths:

1. **headless-gl (`gl` npm package)** — supplies a windowless WebGL context that three.js
   `WebGLRenderer` draws into. Pixels are read back with `gl.readPixels` and encoded to PNG
   with `pngjs`/`sharp`. Works out-of-the-box on macOS via prebuilt binaries; CPU/SwiftShader
   software path on headless servers (Xvfb only needed on Linux).
2. **Puppeteer + headless Chrome** — loads an HTML page running three.js and screenshots the
   canvas. Needed for WebGL2/WebGPU features that `gl` (WebGL 1.0.3 only) cannot provide.

CRITICAL DETERMINISM CAVEAT: modern three.js (r163+) dropped the WebGL1 renderer, so the
headless-gl path requires pinning an older three (canonical gist uses `three@0.124.0`) or using
the Puppeteer path. Software rasterization also differs subtly from GPU output, so pin three +
gl versions and the renderer path for reproducible bytes.

Primary deliverable = a still PNG image. A frame loop + ffmpeg can extend it to video, but that
is secondary.

## Skills

| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| three.js Manual & Docs | documentation | https://threejs.org/manual/ | official | MIT | three.js authors / mrdoob (docs MIT-licensed) |
| three.js (mrdoob/three.js repo) | library-source | https://github.com/mrdoob/three.js | official | MIT | three.js authors |
| stackgl/headless-gl (`gl`) | community-repo | https://github.com/stackgl/headless-gl | community | BSD-2-Clause | stackgl contributors |
| bldrs-ai/headless-three | community-repo | https://github.com/bldrs-ai/headless-three | community | AGPL-3.0 | bldrs.ai |

## Toolchains

| Lang | Install | Invoke | Notes |
|------|---------|--------|-------|
| JS/TS (Node >=18) | `npm install three@0.124.0 gl@^8 pngjs` | `node render.js` | headless-gl path. `gl` = windowless WebGL 1.0.3; macOS prebuilt binaries, no Xvfb. Pin older three with WebGL1 renderer. |
| JS/TS (Node >=18 + headless Chromium) | `npm install three puppeteer` | `node render-puppeteer.js` | Browser path for current three.js / WebGL2 / WebGPU. SwiftShader software path is reliable headless default (GPU accel can yield black frames). |

## Artifact kind

`image` — a still PNG. (Multi-frame PNG sequence + ffmpeg = optional video extension.)

## Validation

**Install**
```bash
mkdir /tmp/three-headless && cd /tmp/three-headless && npm init -y && npm install three@0.124.0 gl@^8 pngjs
```

**Smoke**
```bash
node -e "const THREE=require('three');const createGL=require('gl');const {PNG}=require('pngjs');const fs=require('fs');const W=256,H=256;const canvas={width:W,height:H,addEventListener(){},removeEventListener(){}};const ctx=createGL(W,H,{preserveDrawingBuffer:true});const renderer=new THREE.WebGLRenderer({canvas,context:ctx,antialias:false});renderer.setSize(W,H);const scene=new THREE.Scene();scene.background=new THREE.Color(0x202040);const cam=new THREE.PerspectiveCamera(50,1,0.1,100);cam.position.z=3;const mesh=new THREE.Mesh(new THREE.BoxGeometry(1,1,1),new THREE.MeshStandardMaterial({color:0xff8800}));scene.add(mesh);mesh.rotation.set(0.6,0.8,0);const l=new THREE.DirectionalLight(0xffffff,1.2);l.position.set(2,3,4);scene.add(l);scene.add(new THREE.AmbientLight(0xffffff,0.4));renderer.render(scene,cam);const px=new Uint8Array(W*H*4);ctx.readPixels(0,0,W,H,ctx.RGBA,ctx.UNSIGNED_BYTE,px);const png=new PNG({width:W,height:H});for(let y=0;y<H;y++){for(let x=0;x<W*4;x++){png.data[y*W*4+x]=px[(H-1-y)*W*4+x];}}png.pack().pipe(fs.createWriteStream('out.png')).on('finish',()=>console.log('wrote out.png'));"
```

**Expect** — Writes `/tmp/three-headless/out.png`, a 256x256 PNG showing an orange lit cube on a
dark blue background. Verify with `file out.png` (reports `PNG image data, 256 x 256`). Runs with
no display/window on macOS.

## Wrapper params

- `creative.title` — label/title for the render.
- Scene-builder module (JS/TS) describing Scene + Camera + Meshes/Materials/Lights.
- Width / Height of the framebuffer.
- Path selector: headless-gl (WebGL1, pin `three@0.124.0`) vs puppeteer (current three / WebGL2).

Wrapper responsibilities: pin versions on the chosen path, set W/H, run `renderer.render`, read
pixels (`gl.readPixels` for headless-gl; `canvas.toDataURL`/`page.screenshot` for puppeteer),
vertically flip framebuffer rows, encode via pngjs/sharp. Force software/SwiftShader path for
headless determinism — do not rely on host GPU. For video, render a PNG sequence then pipe
through ffmpeg as a separate step.

## Component / explorer notes

three.js author code is a deterministic scene description: build Scene + Camera + Meshes /
Materials / Lights in JS, call `renderer.render(scene, camera)`. Output is fully reproducible
given pinned three + gl versions, fixed camera/transform values, and avoidance of
nondeterministic inputs (`Math.random`, `Date`, animation time) — drive any animation by an
explicit frame index. Source is plain version-controllable `.js`/`.ts`. For multi-frame output,
loop the frame index and emit a numbered PNG sequence. Detect required path by three version +
features used (WebGL2/WebGPU → puppeteer; classic WebGL1 → gl).
