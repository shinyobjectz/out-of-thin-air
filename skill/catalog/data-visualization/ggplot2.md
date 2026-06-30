# ggplot2

/ category: data-visualization · slug: `ggplot2` · artifact kind: **image**

## Summary

ggplot2 is the R grammar-of-graphics plotting package. Plots are authored as
deterministic R code and rendered headlessly to file via `ggsave()`, which
selects the output device from the file extension (PNG, PDF, SVG, JPEG, TIFF,
EPS, BMP). Primary deliverable is a raster image (PNG); vector PDF/SVG are also
fully supported. Current version 4.0.1 (Nov 2025); 4.0.0 (Sept 2025) rewrote the
object system from S3 to S7 and added layer defaults in themes. Runs headless on
macOS with no display server. R is the only driver runtime; output is
deterministic given fixed data and seed.

## Skills

| Name | Type | Official | License | URL |
|---|---|---|---|---|
| llm-r-skills (ggplot2 skill) | community | no | MIT (verify repo LICENSE) | https://github.com/jsperger/llm-r-skills — attribution: jsperger |
| posit-dev/skills (alt-text) | official-adjacent | yes | MIT | https://github.com/posit-dev/skills — attribution: Posit PBC |
| ggplot2 reference docs | official-docs | yes | MIT (package), docs CC | https://ggplot2.tidyverse.org/reference/ggsave.html — attribution: tidyverse / Posit |

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| R (Rscript, R >= 4.x) | `brew install r && Rscript -e 'install.packages(c("ggplot2","svglite"), repos="https://cloud.r-project.org")'` | `Rscript script.R` |

Notes: invoke headlessly with `Rscript script.R`. `ggsave()` picks the device
from the extension and never opens a display. For SVG output the `svglite`
package is recommended (cleaner than the base `svg` device). No X11/display
needed on macOS.

## Artifact kind

**image** — deliverable is a single static plot file (PNG default; PDF/SVG
vector via extension swap).

## Validation

- **install**: `brew install r && Rscript -e 'install.packages(c("ggplot2","svglite"), repos="https://cloud.r-project.org")'`
- **smoke**: `Rscript -e 'library(ggplot2); p <- ggplot(mtcars, aes(wt, mpg)) + geom_point(); ggsave("out.png", p, width=6, height=4, dpi=150)'`
- **expect**: exit 0, `out.png` created (~tens of KB PNG scatter plot, 900x600px
  at 150 dpi). Swap extension to `out.pdf` / `out.svg` for deterministic vector
  output.

## Wrapper params

- `data-visualization.title` (text) — plot title.
- `data-visualization.ext` (select: png/pdf/svg) — output device via extension.
- `data-visualization.dpi` (select: 72/150/300/320) — screen/150/print/retina.
- `data-visualization.code` (textarea, file-bound) — the R plot script.

## Component / explorer notes

Deliverable is one static plot file. One R script per figure;
`ggsave(filename, plot, width, height, units, dpi)` is the headless render
entrypoint. Determinism: fix random seed (`set.seed`) and pin data; vector
output is byte-stable given same ggplot2/svglite version. Pin package versions
(`renv`) for reproducibility since 4.0.0 changed defaults. Wrap as: write R
script -> `Rscript script.R` -> assert output file exists and non-empty. Default
to PNG; expose extension to switch to pdf/svg. Validate R is on PATH
(`brew install r`). For SVG ensure `svglite` installed. DPI presets:
retina=320, print=300, screen=72.
