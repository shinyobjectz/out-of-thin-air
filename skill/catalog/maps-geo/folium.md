# folium (maps-geo)

## Summary
Folium is a Python library wrapping Leaflet.js to render interactive, pannable/zoomable web maps. You build the map declaratively in Python (markers, popups, GeoJSON layers, choropleths, tile layers) and call `m.save("map.html")` to emit a single self-contained HTML file with inline JS/CSS — deterministic and version-controllable. Current release 0.20.0 (2025-06-16), MIT licensed, Python >=3.9. The `save` step renders headlessly on macOS with no browser/display (it just serializes templated HTML). Note: basemap tiles are fetched from remote providers (OpenStreetMap etc.) at view time in the browser, so the saved HTML is structurally deterministic but the rendered basemap depends on a live tile server unless you point at local/static tiles.

## Skills
| Name | Type | Official | URL | License | Notes |
|------|------|----------|-----|---------|-------|
| No official Anthropic/Claude skill | none | no | https://docs.anthropic.com/en/docs/agents-and-tools/agent-skills/overview | N/A | No Folium-specific Anthropic-authored skill as of 2026-06. Drive directly via the Python toolchain. |
| Folium Official Documentation (user guide + API) | docs | yes | https://python-visualization.github.io/folium/latest/ | MIT (code) | Canonical reference for Map, Marker, GeoJson, Choropleth, TileLayer, save(). |
| Folium GitHub repository | source | yes | https://github.com/python-visualization/folium | MIT | Source, examples/ directory, issue tracker. |
| Real Python: Create Web Maps From Your Data | community-guide | no | https://realpython.com/python-folium-web-maps-from-data/ | Editorial (read-only) | End-to-end tutorial covering markers, choropleths, HTML export. |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| Python (CPython >=3.9) | `pip install folium` (alt: `conda install -c conda-forge folium`) | `import folium; m = folium.Map(...); m.save('out.html')` |

Only supported driver. Optional deps: pandas/geopandas for choropleth + GeoJSON data binding. Pin `folium==0.20.0` for build reproducibility.

## Artifact kind
`html` — primary deliverable is a self-contained interactive HTML map.

## Validation
- **install**: `python3 -m venv /tmp/folium-venv && /tmp/folium-venv/bin/pip install folium`
- **smoke**: `/tmp/folium-venv/bin/python3 -c "import folium; m=folium.Map(location=[37.77,-122.42], zoom_start=12); folium.Marker([37.77,-122.42], popup='SF', tooltip='click').add_to(m); m.save('/tmp/folium_map.html'); print('OK')" && test -s /tmp/folium_map.html && head -c 200 /tmp/folium_map.html`
- **expect**: Prints OK; `/tmp/folium_map.html` exists and is non-empty (~tens of KB) containing a `<!DOCTYPE html>` doc with embedded Leaflet JS/CSS and a leaflet map div. Opening it in a browser shows an interactive San Francisco map with one marker. The save step runs fully headless (no display/browser); only live viewing fetches remote tiles.

## Wrapper params
- `maps-geo.title` — map document title.
- `maps-geo.lat` / `maps-geo.lon` — center coordinates.
- `maps-geo.zoom` — initial zoom level.
- `maps-geo.tiles` — tile provider (OpenStreetMap, CartoDB positron, etc.).

## Component / explorer notes
`Map` is the root component. Add layers/features via `.add_to(map)`: Marker, CircleMarker, Popup, Tooltip, Icon, GeoJson, Choropleth, TileLayer, LayerControl, FeatureGroup, and plugins (`folium.plugins`: MarkerCluster, HeatMap, TimestampedGeoJson, Fullscreen, MiniMap). Data binding via pandas/geopandas dataframes (`key_on` + `columns` for choropleths). Output is one HTML file with Leaflet bundled by the template. For reproducible/offline rendering, pin tiles to a local tileset or static raster and fix the map view. For static PNG/PDF, headless-screenshot the saved HTML (Playwright/Selenium) since Folium only emits HTML.
