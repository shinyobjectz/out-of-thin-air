#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" textiles.title "Hello Knitout")"
CARRIERS="$(param "$SESSION" textiles.carriers "1 2 3")"
MACHINE="$(param "$SESSION" textiles.machine "SWG091N2")"
GAUGE="$(param "$SESSION" textiles.gauge "15")"
WIDTH="$(param "$SESSION" textiles.width "10")"
ROWS="$(param "$SESSION" textiles.rows "10")"

mkdir -p "$OUT/src"

# Minimal VALID knitout: magic header, ;; comment header, bring carrier 1 in,
# knit a small swatch, take it out. Carrier 1 is the first token in CARRIERS.
CARRIER1="${CARRIERS%% *}"
{
  echo ';!knitout-2'
  echo ";;Machine: ${MACHINE}"
  echo ";;Gauge: ${GAUGE}"
  echo ";;Carriers: ${CARRIERS}"
  echo ";;Yarn-${CARRIER1}: 50-50 ${TITLE}"
  echo ";;Position: Center"
  echo "inhook ${CARRIER1}"
  for ((r=0; r<ROWS; r++)); do
    if (( r % 2 == 0 )); then dir='+'; else dir='-'; fi
    line="$dir"
    if [[ "$dir" == '+' ]]; then
      for ((n=0; n<WIDTH; n++)); do line+=" knit + f${n} ${CARRIER1};"; done
    else
      for ((n=WIDTH-1; n>=0; n--)); do line+=" knit - f${n} ${CARRIER1};"; done
    fi
    # emit each stitch on its own line (one op per line is the canonical form)
    if (( r % 2 == 0 )); then
      for ((n=0; n<WIDTH; n++)); do echo "knit + f${n} ${CARRIER1}"; done
    else
      for ((n=WIDTH-1; n>=0; n--)); do echo "knit - f${n} ${CARRIER1}"; done
    fi
  done
  echo "outhook ${CARRIER1}"
} > "$OUT/src/out.k"
echo "  wrote out/src/out.k"

# Graceful render: if the Node knitout frontend is available, validate by round-tripping;
# otherwise print an install hint.
if command -v node &>/dev/null && node -e "require.resolve('knitout')" &>/dev/null; then
  node -e "const k=require('knitout');const cs='${CARRIERS}'.split(/\s+/);const w=new k.Writer({carriers:cs});w.inhook(cs[0]);for(let n=0;n<${WIDTH};n++)w.knit('+','f'+n,cs[0]);w.outhook(cs[0]);w.write('$OUT/out.k')" \
    && echo "  rendered out/out.k (validated via knitout frontend)"
else
  echo "  hint: npm i knitout  then re-run; inspect out/src/out.k at https://textiles-lab.github.io/knitout-live-visualizer/"
fi
