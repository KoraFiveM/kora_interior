# kora_interior

Shell interiors for Kora housing, robberies and apartments. It also provides `qb-interior` / `qbinterior`, so stock callers keep working.

**Shells provided by K4MB1**

https://www.k4mb1maps.com/

https://discord.gg/JrjkacM

`exports.kora_interior:createGeometry(origin, exitOffset, model, placement)` returns
`{ objects, { exit = exitOffset } }` or `false, reason`. It creates frozen,
local shell geometry without fading or moving the player. Models are released
after creation; objects are owned by the invoking resource and removed when it
stops. Call `exports.kora_interior:removeGeometry(objects)` to release them sooner.
Legacy `createShell` and named shell exports retain their entry teleport and authored heading.
They return `false, reason` without moving the player when the shell model isn't installed
(for example an optional K4MB1 pack). Shells they create are owned by the calling resource
and removed when it stops. `DespawnInterior(objects, cb)` never deletes geometry another
resource owns, and `cb` is optional.
The optional placement is `centered` (default, `CreateObjectNoOffset`) or
`legacy` (`CreateObject`, matching stock factories). Neither geometry mode
teleports. The model offset must not be guessed from an exit coordinate.

The bundled standard motel is available as `CreateFurniMotelStandard`; the
optional `CreateFurniMotel` remains a separate model. `CreateGarageMed` uses the
actual bundled `shell_garagem` archetype. See [asset evidence and placement limits](docs/SHELL_GEOMETRY.md).

![image](https://user-images.githubusercontent.com/57848836/158275226-e80563dc-5b71-4883-a485-997878b8d440.png)

# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

Existing shell factories and `DespawnInterior` are also exported under `qb-interior`, using the same handlers and legacy object/POI return shapes. Native geometry ownership helpers remain under `kora_interior`. Optional shell models still require their corresponding installed assets; registering a factory does not install a paid or external shell pack.
