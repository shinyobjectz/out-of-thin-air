#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" data-visualization.title "wt vs mpg")"
EXT="$(param "$SESSION" data-visualization.ext "png")"
DPI="$(param "$SESSION" data-visualization.dpi "150")"

cat > "$OUT/plot.R" <<EOF
library(ggplot2)
set.seed(1)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "${TITLE}")
ggsave("${OUT}/plot.${EXT}", p, width = 6, height = 4, units = "in", dpi = ${DPI})
EOF
echo "  wrote out/plot.R"

if command -v Rscript &>/dev/null; then
  Rscript "$OUT/plot.R" && echo "  rendered out/plot.${EXT}"
else
  echo "  hint: brew install r && Rscript -e 'install.packages(c(\"ggplot2\",\"svglite\"), repos=\"https://cloud.r-project.org\")' then Rscript $OUT/plot.R"
fi
