# kepler.gl

## Summary
kepler.gl is an open-source (MIT; Vis.gl / OpenJS Foundation, originally Uber) WebGL geospatial visualization tool for large-scale point / arc / hexbin / heatmap / trip / GeoJSON maps. For OOTA the deterministic path is the Python `keplergl` Jupyter-widget package's `save_to_html()` method, which templates a dataset plus a JSON style/config into a single self-contained interactive HTML file (deck.gl / Mapbox-GL bundle inlined). It runs fully headless — no browser, no display, no network at build time — so given identical data + config the emitted HTML is reproducible and version-controllable. The JSON config (camera viewport, layers, color scales, filters) is the version-controllable spec; the CSV / GeoJSON / DataFrame is the data input. A parallel JS path exists (npm `kepler.gl`, a React/Redux component) but it only renders inside a live browser/WebGL DOM and is not headless-deterministic, so it is secondary.

## Skills
- [kepler.gl official documentation](https://docs.kepler.gl/) — docs, official, MIT — kepler.gl / Vis.gl (OpenJS Foundation), originally Uber
- [keplergl-jupyter user guide (save_to_html, add_data, config)](https://docs.kepler.gl/docs/keplergl-jupyter) — docs, official, MIT — kepler.gl / Vis.gl
- [keplergl/kepler.gl GitHub repo (source, examples, bindings/kepler.gl-jupyter)](https://github.com/keplergl/kepler.gl) — repo, official, MIT — Vis.gl / OpenJS Foundation

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython 3.8+) — **PRIMARY** | `pip install keplergl pandas` | `KeplerGl(data=..., config=...).save_to_html(file_name='map.html', read_only=True)` — self-contained interactive HTML, no browser or kernel required; deterministic for fixed data+config |
| JavaScript/TypeScript (Node 18+ / browser) — secondary | `npm install kepler.gl react react-dom redux react-redux react-palm` | React/Redux component + reducer; renders only in a live browser DOM (WebGL), not headless-deterministic. Use for app embedding, not OOTA. Config exportable as JSON from the running app |

## Artifact kind
**html** — primary deliverable is a single self-contained interactive HTML map written headlessly via `save_to_html()`.

## Validation
- **install:** `pip install keplergl pandas`
- **smoke:** `python3 -c "import pandas as pd; from keplergl import KeplerGl; df=pd.DataFrame({'lat':[37.77,40.71,34.05],'lng':[-122.42,-74.0,-118.24],'val':[1,2,3]}); m=KeplerGl(height=600); m.add_data(data=df, name='pts'); m.save_to_html(file_name='out_map.html'); print('ok')"`
- **expect:** Prints `ok` (and `Map saved to out_map.html!`) with NO browser launched; creates `out_map.html` (typically several MB, self-contained with inlined deck.gl/mapbox bundle + embedded data+config). Open in a browser to see an interactive pannable/zoomable point map. Fully headless on macOS — no display server, no Jupyter kernel, no network needed for the write.

## Wrapper params
- `maps-geo.title` — map title
- `maps-geo.data` — path to data file (CSV / GeoJSON), bound to a source file
- `maps-geo.config` — path to kepler.gl JSON config (viewport, layers, color scales, filters)
- `maps-geo.lat` / `maps-geo.lng` / `maps-geo.zoom` — default viewport when no config supplied

## Component / explorer notes
OOTA component accepts (a) the data payload — CSV / GeoJSON / pandas DataFrame / WKT — and (b) a kepler.gl JSON config object that fully pins the visual: map viewport (lat/lng/zoom/bearing/pitch), layer definitions, color scales, filters, basemap style. Config is the deterministic spec; capture it once interactively (`m.config` after arranging a map, or the app's export-config JSON) then commit it. Pass `read_only=True` to `save_to_html` to lock the exported map UI. Basemap tiles are fetched at VIEW time from Mapbox/Carto (not at build time), so the rendered HTML needs network when opened; the file emission itself is offline/deterministic. For a no-tile-dependency map, use a Carto/positron style or a data-only deck layer.

Wrapper = thin Python CLI: read data file + config.json -> `KeplerGl(data, config)` -> `save_to_html(out.html, read_only=True)`. Pin `keplergl==0.3.7` and pandas for reproducibility; add geopandas only if GeoDataFrame/shapefile input is needed. No headless browser, Xvfb, or Node toolchain required for the html artifact — the key advantage over the JS path. Static raster (png) is NOT built-in headlessly (image export only exists in the browser UI export modal, GitHub issue #974) and would require a separate puppeteer/playwright screenshot step — treat png as out of scope; html is the supported kind.
