# generated draft — needs validation
#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" data-visualization.title "Observable Plot")"

cat > "$OUT/plot.mjs" <<EOF
import * as Plot from "@observablehq/plot";
import {JSDOM} from "jsdom";
import {writeFileSync} from "node:fs";
const data=[{x:1,y:2},{x:2,y:4},{x:3,y:1},{x:4,y:5}];
const svg=Plot.plot({
  title:"$TITLE",
  document:new JSDOM("").window.document,
  marks:[Plot.line(data,{x:"x",y:"y"}),Plot.dot(data,{x:"x",y:"y"})]
});
const el=svg.tagName.toLowerCase()==="svg"?svg:svg.querySelector("svg");
el.setAttributeNS("http://www.w3.org/2000/xmlns/","xmlns","http://www.w3.org/2000/svg");
el.setAttributeNS("http://www.w3.org/2000/xmlns/","xmlns:xlink","http://www.w3.org/1999/xlink");
writeFileSync("$OUT/plot.svg",el.outerHTML);
console.log("bytes",el.outerHTML.length);
EOF
echo "  wrote out/plot.mjs"

if command -v node &>/dev/null; then
  ( cd "$OUT" && npm init -y >/dev/null 2>&1 && npm install @observablehq/plot d3 jsdom >/dev/null 2>&1 && node plot.mjs ) \
    && echo "  rendered out/plot.svg"
else
  echo "  hint: install Node.js, then: npm install @observablehq/plot d3 jsdom && node plot.mjs"
fi
