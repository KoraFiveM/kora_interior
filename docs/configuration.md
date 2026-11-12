---
title: Configuration
sidebar_position: 2
---

# Configuration

`config.lua` is loaded as a shared script and defines one option.

| Option | Default | Description |
| --- | --- | --- |
| `Config.DefaultGeometryPlacement` | `'legacy'` | Placement mode `createGeometry` uses when the caller passes no `placement` argument. `'legacy'` uses `CreateObject` (same as the stock factories); `'centered'` uses `CreateObjectNoOffset`. |

`client/main.lua` reads it only when no placement argument is given; if `Config` were missing it falls back to `'centered'`, but `config.lua` always defines it. Any other value than `'legacy'` makes `createGeometry` use `CreateObjectNoOffset`, so keep it to one of the two documented values.

Shell models, exit offsets and the factory list are not configurable; they are hard-coded in `client/main.lua` and `client/optional.lua` (see [Shell catalog](./shell-catalog.md)).
