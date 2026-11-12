---
title: Exports
sidebar_position: 4
---

# Exports

All exports are client-side. Handlers are in `client/main.lua` and `client/optional.lua`.

## Geometry exports (`kora_interior` only)

### createGeometry

```lua
local result, reason = exports.kora_interior:createGeometry(origin, exitOffset, model, placement)
```

| Argument | Description |
| --- | --- |
| `origin` | Table or vector with finite numeric `x`, `y`, `z`. Where the object is created. |
| `exitOffset` | Any value; it is returned unchanged as `exit` in the result and is not used otherwise. |
| `model` | Model name string or integer hash. Must be valid (`IsModelValid`). |
| `placement` | Optional `'legacy'` (`CreateObject`) or `'centered'` (`CreateObjectNoOffset`). Omitted: `Config.DefaultGeometryPlacement`. |

Returns `{ { entity }, { exit = exitOffset } }` on success, or `false, reason`. Failure reasons: `Invalid shell origin.`, `Invalid shell placement mode.`, `A shell model is required.`, `Unknown shell model.`, or `Shell geometry could not be created.` (or the model-loading error).

The entity is created non-networked, frozen, and the model is released after creation. The player is not faded or moved. The entity is owned by the invoking resource (`GetInvokingResource()`, falling back to `kora_interior`) and is deleted when that resource stops. If the owner stops while the model is loading, the shell is not created.

### removeGeometry

```lua
local ok, reason = exports.kora_interior:removeGeometry(objects)
```

`objects` is the first element of a `createGeometry` result (a list of entities). Returns `true` after deleting them. Returns `false, reason` if `objects` is not a table, or if any entity is not owned by the calling resource (in which case nothing is deleted).

## Legacy exports

### createShell

```lua
local result, reason = exports.kora_interior:createShell(spawn, exit, model)
```

Exported under `kora_interior` only (not `qb-interior`). Loads the model, creates it with `CreateObject` at `spawn`, freezes it, releases the model, then fades the screen and teleports the player to `spawn + exit` with heading `exit.w` (or `exit.h`, or 0). Returns `{ { object }, { exit = exit } }` or `false, reason`. The created object is not tracked for cleanup and is not owned by any resource; remove it with `DespawnInterior`.

### DespawnInterior

```lua
exports.kora_interior:DespawnInterior(objects, cb)
```

Also `exports['qb-interior']:DespawnInterior`. Deletes every existing entity in `objects` and then calls `cb` if given.

### Shell factories

Every entry in the [Shell catalog](./shell-catalog.md) is an export of the form `exports.kora_interior:CreateTier1House(spawn)`, also available as `exports['qb-interior']:CreateTier1House(spawn)`. Each calls `createShell(spawn, exit, model)` with a fixed model and exit. The result is `{ { object }, { exit = vector4 } }`. `CreateApartmentFurnished` additionally adds `clothes`, `stash` and `logout` to the second table.

Optional factories (from `client/optional.lua`) call `exports[GetCurrentResourceName()]:createShell`, so they behave the same as the bundled ones.
