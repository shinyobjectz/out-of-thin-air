# three.js (creative)

## Summary
Three.js is the dominant JavaScript WebGL/WebGPU 3D library. Its primary deliverable is an interactive HTML page — a browser canvas driven by JS/TS. It embeds directly in a single HTML file via CDN/importmap, or is driven from React (react-three-fiber), Python notebooks (pythreejs), and rendered headlessly to PNG via Puppeteer/headless Chrome. There is no first-party "PNG export CLI"; offline image/video output is done by headless-browser screenshot or canvas capture.

## Skills
| Skill | Type | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| three.js docs (manual + examples + API) | official-docs | https://threejs.org/docs/ | official | MIT (docs/code) | three.js / mrdoob |
| webgpu-claude-skill (Three.js WebGPU + TSL) | repo | https://github.com/dgreenheck/webgpu-claude-skill | community | check repo (MIT-style) | dgreenheck |
| CloudAI-X/threejs-skills | repo | https://github.com/cloudai-x/threejs-skills | community | check repo | CloudAI-X |
| claude-skills-threejs-ecs-ts (Three.js + ECS + R3F + TS) | repo | https://github.com/Nice-Wolf-Studio/claude-skills-threejs-ecs-ts | community | check repo | Nice-Wolf-Studio |
| ck:threejs (ClaudeKit skill) | community | https://docs.claudekit.cc/docs/engineer/skills/threejs/ | community | ClaudeKit | ClaudeKit |

## Toolchains
| lang | install | invoke |
|---|---|---|
| JS/TS (browser, primary) | `npm install three` | `import * as THREE from 'three'` — or zero-build CDN importmap `<script type="importmap">{"imports":{"three":"https://unpkg.com/three@0.169.0/build/three.module.js"}}</script>`; addons under `three/addons/` (OrbitControls, GLTFLoader...) |
| React/TSX | `npm install three @react-three/fiber` | declarative scene graph; pair with `@react-three/drei` helpers |
| Python | `pip install pythreejs` | Jupyter-widgets bridge; renders in notebook output (not standalone) |
| Node (headless render to image) | `npm install puppeteer three` | load HTML/JS scene in headless Chromium, `page.screenshot({path})` for PNG; use `--use-gl=angle --enable-unsafe-swiftshader` for software GL |

## Artifact kind
`html` — an interactive HTML/WebGL canvas. Static or self-animating scenes render fine in the default HTML shell; an explorer (orbit/zoom, GLTF loading, animation scrubbing, param panel) adds value for inspectable 3D content.

## Validation
- **install:** `npm install three puppeteer`
- **smoke:** write `scene.html` importing three from CDN, render a green cube to a 400x400 canvas, then:
  `node -e "const p=require('puppeteer');(async()=>{const b=await p.launch({headless:'new',args:['--use-gl=angle','--enable-unsafe-swiftshader']});const pg=await b.newPage();await pg.goto('file://'+process.cwd()+'/scene.html');await new Promise(r=>setTimeout(r,1500));await pg.screenshot({path:'out.png'});await b.close();})()"`
- **expect:** `out.png` written (~400x400) showing the rendered 3D cube; nonzero file size confirms WebGL rendered headless via ANGLE/SwiftShader on macOS.

## Wrapper params
canvas width/height + devicePixelRatio, camera fov/position, background/clear color, OrbitControls on/off, renderer antialias, animation loop on/off; for headless capture: output resolution, settle/delay ms before screenshot, PNG vs JPEG; for model viewing: GLTF/GLB URL.

## Component / explorer notes
Primary artifact is an interactive HTML/WebGL canvas. A plain HTML shell renders single-file CDN/importmap scenes (cube, scene, model viewer) fine. A richer explorer adds value for orbit/zoom, GLTF model loading, animation playback scrubbing, and a code/param panel. Default HTML shell suffices for static or self-animating scenes; an explorer is preferable for inspectable 3D content.
