---
title: kora_interior
sidebar_position: 1
---

# kora_interior

`kora_interior` is a client-side shell library for Kora housing-style resources. It bundles 16 K4MB1 shell models (streamed from `stream/`), and exports factories that spawn a shell object at a caller-supplied origin, plus a newer pair of geometry exports (`createGeometry` and `removeGeometry`) that spawn a shell without teleporting the player. It also registers 109 factories for optional shell packs that are not included. It has no server code, no commands, no database use and no UI.

The resource declares `provide 'qb-interior'`, and every factory plus `DespawnInterior` is also exported under the `qb-interior` resource name through `Kora.compat.provideExport`, so QBCore-era callers keep working. The manifest sets `this_is_a_map 'yes'`. Shell models are credited to K4MB1 (`author` in `fxmanifest.lua`).

Current version: see `version` in `fxmanifest.lua`.

## Features

- **Legacy shell factories** - `CreateApartmentShell`, `CreateTier1House`, `CreateMichael` and others create the shell with `CreateObject`, freeze it, fade the screen and teleport the player to the shell exit. See [Shell catalog](./shell-catalog.md).
- **Native geometry exports** - `createGeometry` and `removeGeometry` create and remove a frozen local shell with no fade or teleport, owned by the calling resource. See [Exports](./exports.md).
- **Ownership cleanup** - geometry created through `createGeometry` is deleted when the owning resource stops, and when `kora_interior` itself stops.
- **Placement modes** - `legacy` (`CreateObject`) or `centered` (`CreateObjectNoOffset`), defaulting to `Config.DefaultGeometryPlacement`. See [Configuration](./configuration.md) and [Shell geometry](./shell-geometry.md).
- **Bundled asset report** - model-local bounds for the 16 bundled archetypes in `bundled-shell-bounds.json`.

## Requirements

| Resource | Used for |
| --- | --- |
| [kora_lib](https://github.com/KoraFiveM/kora_lib) | Declared with `dependency`. Provides `Kora.stream.loadModel`, `Kora.visuals.fade`, `Kora.resources.registry`, `Kora.compat.provideExport` and `Kora.util.isFiniteNumber` |

`qb-clothes` is only triggered as a client event (`qb-clothes:client:CreateFirstCharacter`) by `CreateApartmentFurnished`; it is not a dependency. In this repository only `kora_robberies` (which declares `dependency 'kora_interior'`) was found calling the exports.

## Installation

1. Place the resource in your resources folder.
2. Ensure it after `kora_lib` and before any resource that calls it:

   ```cfg
   ensure kora_lib
   ensure kora_interior
   ```

3. No SQL import and no locale files are needed.
4. For the optional factories, install and stream the matching shell packs separately. See [Troubleshooting](./troubleshooting.md).

## Testing

See [Testing](./testing.md).

## Pages

- [Configuration](./configuration.md) - the single `Config` option
- [Exports](./exports.md) - `createGeometry`, `removeGeometry`, `createShell`, `DespawnInterior` and the factory exports
- [Shell catalog](./shell-catalog.md) - every factory with model name and exit offset
- [Events](./events.md) - the one client event this resource listens to and the one it triggers
- [Shell geometry](./shell-geometry.md) - bundled asset evidence and placement limits
- [Testing](./testing.md) - offline tests and QA scenarios
- [Troubleshooting](./troubleshooting.md) - known caveats and common problems

This resource registers no commands, no server events, no items, no ACE permissions and uses no database tables.
