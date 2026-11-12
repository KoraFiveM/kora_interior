> [!WARNING]
> **Kora Framework is in alpha and actively being developed.**
>
> This resource is a work in progress. Features may be incomplete or unstable,
> and APIs, configuration, and behavior may change. It is not ready for production use.
>
> **Help shape Kora:** try it out, share feedback, report bugs through this
> repository’s Issues, and contribute improvements through pull requests.

# qb-interior

**Shells provided by K4MB1**

https://www.k4mb1maps.com/

https://discord.gg/JrjkacM

`exports.kora_interior:createGeometry(origin, exitOffset, model, placement)` returns
`{ objects, { exit = exitOffset } }` or `false, reason`. It creates frozen,
local shell geometry without fading or moving the player. Models are released
after creation; objects are owned by the invoking resource and removed when it
stops. Call `exports.kora_interior:removeGeometry(objects)` to release them sooner.
Legacy `createShell` and named shell exports retain their entry teleport and authored heading.
The optional placement is `centered` (`CreateObjectNoOffset`) or
`legacy` (`CreateObject`, matching stock factories). When omitted it follows
`Config.DefaultGeometryPlacement` (default `legacy`). Neither geometry mode
teleports. The model offset must not be guessed from an exit coordinate.

The bundled standard motel is available as `CreateFurniMotelStandard`; the
optional `CreateFurniMotel` remains a separate model. `CreateGarageMed` uses the
actual bundled `shell_garagem` archetype. See [asset evidence and placement limits](docs/shell-geometry.md).

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

Full documentation: see [docs/](docs/index.md).
