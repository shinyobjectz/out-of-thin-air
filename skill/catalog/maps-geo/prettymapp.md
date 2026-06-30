<!-- generated draft — needs validation -->
# prettymapp

## Summary
prettymapp is an MIT-licensed Python package (and Streamlit webapp) that renders beautiful stylized maps from OpenStreetMap data. It is a speed-focused rewrite of marceloprates/prettymaps, built on osmnx + geopandas + matplotlib + shapely. Output is produced via matplotlib's `savefig`, so it emits raster (PNG/JPG) or vector (SVG/PDF) headlessly. There is no CLI — it is driven purely from Python.

Network access to OSM/Overpass + a geocoder (Nominatim) is required at render time, so output is only deterministic when inputs **and** OSM responses are stable. For true reproducibility, snapshot the fetched geometries (`GeoDataFrame`) to a file (parquet/pickle) and replot from it.

No official Anthropic/Claude skill exists; OOTA authors a thin Python wrapper that takes address/coords + radius + style and writes an image file.

## Skills
| Name | Type | Official | License | URL | Attribution |
|------|------|----------|---------|-----|-------------|
| prettymapp | repo | community | MIT | https://github.com/chrieke/prettymapp | Christoph Rieke (chrieke); rewrite of prettymaps by Marcelo Prates |
| prettymapp (PyPI) | package | official | MIT | https://pypi.org/project/prettymapp/ | chrieke |
| prettymaps (upstream original) | repo | community | AGPL-3.0 | https://github.com/marceloprates/prettymaps | Marcelo Prates — more featureful but AGPL; prettymapp is the MIT-friendly fork OOTA should prefer |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.9+) | `pip install prettymapp` | `from prettymapp.geo import get_aoi; from prettymapp.osm import get_osm_geometries; from prettymapp.plotting import Plot; from prettymapp.settings import STYLES` — render with matplotlib `Agg` backend, save via `fig.savefig(...)` |

Pulls osmnx, geopandas, matplotlib, shapely (heavy GEOS/PROJ via wheels — pin versions in a lockfile). The Streamlit webapp is optional (`streamlit run`) and not needed for headless file emit.

## Artifact kind
**image** — primary deliverable is a single styled map render (PNG/JPG raster; .svg/.pdf vector via savefig extension).

## Validation
- **install:** `python3 -m venv /tmp/pmapp && /tmp/pmapp/bin/pip install prettymapp`
- **smoke:**
  ```bash
  MPLBACKEND=Agg /tmp/pmapp/bin/python -c "from prettymapp.geo import get_aoi; from prettymapp.osm import get_osm_geometries; from prettymapp.plotting import Plot; from prettymapp.settings import STYLES; aoi=get_aoi(address='Praça Ferreira do Amaral, Macau', radius=1100, rectangular=False); df=get_osm_geometries(aoi=aoi); fig=Plot(df=df, aoi_bounds=aoi.bounds, draw_settings=STYLES['Peach']).plot_all(); fig.savefig('/tmp/pmapp/map.png', dpi=150)" && ls -la /tmp/pmapp/map.png
  ```
- **expect:** Command exits 0 and `/tmp/pmapp/map.png` is a non-empty PNG of a styled Macau street map. Requires network (Nominatim geocode + Overpass/OSM fetch). savefig path can be `.svg` or `.pdf` for vector output. macOS headless OK via `MPLBACKEND=Agg`.

## Wrapper params
- `maps-geo.address` (text) — address geocoded via Nominatim, or empty to use lat/lon.
- `maps-geo.radius` (range) — fetch radius in meters.
- `maps-geo.style` (select) — Peach / Auburn / Citrus / Flannel.
- `maps-geo.rectangular` (toggle) — rectangular vs circular AOI.
- `maps-geo.format` (select) — png / jpg / svg / pdf (controls savefig kind).

## Component / explorer notes
Deliverable is a single map image. The component picks AOI (address geocoded via Nominatim, or explicit lat/lon), radius, rectangular flag, and a style from `STYLES` (Peach/Auburn/Citrus/Flannel) or a custom `draw_settings` dict. matplotlib savefig extension controls kind: `.png`/`.jpg` (raster), `.svg`/`.pdf` (vector). Custom styles are plain declarative dicts (perimeter/streets/building colors, widths) — a good fit for version control.

For version-control determinism, snapshot the fetched `GeoDataFrame` to parquet/pickle and replot from it so the render no longer depends on live OSM. Force headless with `MPLBACKEND=Agg` or `matplotlib.use('Agg')`. Add retry + a cached-geometries mode for reproducible builds given the runtime network dependency on Nominatim + Overpass.
