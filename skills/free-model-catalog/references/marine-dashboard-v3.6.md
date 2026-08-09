# Marine Dashboard v3.6 — session notes

## Versioned file convention
Each iteration creates a new file (`v3.5.html` → `v3.6.html` → `v3.7.html`). Base file is stable; working copy is mutated. No in-place edits to named versions. This preserves clean diffs and lets the user compare versions without git.

## County selector refactor pattern
When adding a top-level selector (county, region, category) to an existing flat-list dashboard:
1. Replace the flat `const SITES = [...]` with `const COUNTIES = { "Name": { sites: [...] }, ... }`.
2. Add a county chip strip above the site strip.
3. `currentSites = COUNTIES[currentCounty].sites`; `currentSite = currentSites[0]`.
4. `rebuildSiteStrip()` clears and rebuilds the site strip when county changes.
5. Replace ALL bare `SITES` references with `currentSites` (or `COUNTIES[currentCounty].sites`).
6. Verify no `SITES[` or `SITES.map` remain in the JS.
7. Verify `<div>` tags stay balanced after structural edits.

## AI-friendly surf report block
Embed a hidden structured-data section so an LLM can read the page state directly:
```html
<div id="ai-surf-report" style="display:none; white-space: pre-wrap; font-family: monospace;"></div>
```
Update it from **every** code path that mutates the visible summary:
- `updateLiveObs()` → observations
- `renderForecast()` → 5-day forecast rows
- `renderDetail()` → hourly surf rows
- `renderTide()` → tide chart state

Write **JSON**, not prose. Include: `generated` timestamp, current selection context, observations, forecast/hourly arrays, and derived ratings. This lets an LLM produce a natural-language surf summary from the DOM without custom scraping logic.

## NOAA data quirks (SE FL Atlantic)
- `forecastGridData` is fragile; single endpoint, occasional downtime.
- Tide API: `api.tidesandcurrents.noaa.gov` — uses local standard time (`lst_ldt`), intervals `hilo`.
- Observations: chain `points → observationStations → /observations/latest`.
- Wind direction vs beach facing: offshore window is site-specific (`offshoreLo`, `offshoreHi`), wraps at 360°.

## Live surf outlook pattern (current session)
Palm Beach County, summer doldrums: 1–2ft, 3–4s period, 9–12kt offshore. Offshore wind clean but zero swell energy → all slots rate FLAT/V.POOR. Needs Gulf Stream swell or tropical system to fire.