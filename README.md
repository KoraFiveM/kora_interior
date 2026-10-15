# qb-interior

**Shells provided by K4MB1**

https://www.k4mb1maps.com/

https://discord.gg/JrjkacM

`exports.qbinterior:createGeometry(origin, exitOffset, model)` returns
`{ objects, { exit = exitOffset } }` or `false, reason`. It creates frozen,
local shell geometry without fading or moving the player. Models are released
after creation; objects are owned by the invoking resource and removed when it
stops. Call `exports.qbinterior:removeGeometry(objects)` to release them sooner.
Legacy `createShell` and named shell exports retain their entry teleport.

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
