<!-- generated draft — needs validation -->
# OSMnx (`osmnx`) — maps-geo

## Summary
OSMnx is a pure-Python library (v2.1.0, Feb 2026) by Geoff Boeing for downloading, modeling, analyzing, and visualizing street networks and other geospatial features from OpenStreetMap. Built on NetworkX + GeoPandas. It renders headlessly via matplotlib's Agg backend to a static image file (PNG default; SVG/PDF via filepath extension). Primary OOTA deliverable: an **image** (figure-ground / street-network plot). It also emits SVG (vector) and PDF; data outputs (GraphML, GeoPackage, OSM XML) are non-image but reproducible.

Determinism caveat: OSM is a live, mutable dataset, so identical code can return different geometry over time. For reproducible/version-controllable output, pin inputs by caching responses (`ox.settings.use_cache=True`) and committing a saved GraphML/GeoPackage snapshot, then plot from the saved graph rather than re-querying.

## Skills
| Resource | Type | Official | URL | License | Attribution |
|---|---|---|---|---|---|
| OSMnx official documentation (ReadTheDocs) | official-docs | yes | https://osmnx.readthedocs.io/en/stable/ | MIT (project) | Geoff Boeing / gboeing |
| osmnx-examples (official Jupyter notebook gallery) | community-repo | yes | https://github.com/gboeing/osmnx-examples | MIT | Geoff Boeing |
| OSMnx source repository | source | yes | https://github.com/gboeing/osmnx | MIT | Geoff Boeing |
| No official Anthropic/Claude skill found | none | no | — | — | As of June 2026 no Anthropic-published or notable community Claude skill targets OSMnx specifically. |

## Toolchains
| Lang | Install | Invoke |
|---|---|---|
| Python (CPython 3.9+) | `pip install osmnx` (or `conda create -n ox -c conda-forge osmnx`) | `import osmnx as ox` |

Pure Python; depends on numpy, pandas, geopandas, networkx, shapely, requests, matplotlib. conda-forge is recommended by upstream to resolve GEOS/GDAL native deps cleanly. PyPI install works on macOS arm64; geopandas wheels bundle GEOS/GDAL/PROJ so no Homebrew needed for the smoke test. Pin `osmnx>=2,<3` (many pre-2.0 function names changed).

## Artifact kind
**image** — `ox.plot_graph(G, save=True, filepath=..., dpi=...)` produces a matplotlib figure; format inferred from extension (.png raster, .svg/.pdf vector).

## Validation
- **install:** `python3 -m venv /tmp/oxv && /tmp/oxv/bin/pip install osmnx matplotlib`
- **smoke:** `MPLBACKEND=Agg /tmp/oxv/bin/python -c "import osmnx as ox; G=ox.graph_from_place('Piedmont, California, USA', network_type='drive'); fig,ax=ox.plot_graph(G, show=False, close=True, save=True, filepath='/tmp/oxmap.png', dpi=150); print('ok')" && ls -la /tmp/oxmap.png`
- **expect:** Network downloaded from OSM Overpass API; `/tmp/oxmap.png` written (black-background street-network figure, ~100KB–1MB). Requires network access for the OSM API call; the render itself is fully headless via the Agg backend. Swap filepath extension to `.svg` for vector output.

## Wrapper params
- `maps-geo.place` — OSM place query (text)
- `maps-geo.network_type` — drive | walk | bike | all (select)
- `maps-geo.dpi` — output resolution (range)
- `maps-geo.bgcolor` — figure background (color)

## Component / explorer notes
Primary render path: `ox.plot_graph(G, save=True, filepath=..., dpi=...)`. Use `show=False, close=True` for headless batch. Set `MPLBACKEND=Agg` and `ox.settings.use_cache=True` for deterministic, headless re-runs. Network access required at data-fetch time (Overpass/Nominatim APIs); rendering is offline. To keep deliverables version-controllable, commit the OSM snapshot (GraphML/GeoPackage) alongside the plotting script and regenerate the image as a build artifact. Related plot fns: `plot_figure_ground`, `plot_graph_route`, `plot_orientation` (polar histogram), and `plot_graph_folium` for interactive HTML (`.save('map.html')`). For vector OOTA output, render to `.svg`.
