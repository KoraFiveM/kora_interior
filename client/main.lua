local IsNew = false

RegisterNetEvent('qb-interior:client:SetNewState', function(bool)
    IsNew = bool
end)

exports('DespawnInterior', function(objects, cb)
    for _, obj in pairs(objects) do
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    cb()
end)

local function CreateShell(spawn, exit, model)
    print(('Creating shell at spawn: %s with exit: %s and model: %s'):format(tostring(spawn), tostring(exit), tostring(model)))
    local objects = {}
    local poi = { exit = exit }
    local modelHash = type(model) == 'string' and joaat(model) or model
    QB.stream.loadModel(modelHash)
    local house = CreateObject(modelHash, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
    objects[#objects + 1] = house
    QB.visuals.fade(vector3(spawn.x + exit.x, spawn.y + exit.y, spawn.z + exit.z))
    return { objects, poi }
end

exports('CreateShell', function(spawn, exit, model)
    return CreateShell(spawn, exit, model)
end)

-- Starting Apartment

exports('CreateApartmentFurnished', function(spawn)
    local exit = vector4(1.5, -10.0, 0.0, 358.50)
    local shell = CreateShell(spawn, exit, 'furnitured_midapart')
    local objects, poi = shell[1], shell[2]

    poi.clothes = vector4(-6.028, -9.5, 1.2, 2.263)
    poi.stash = vector4(-7.305, -3.922, 0.5, 2.263)
    poi.logout = vector4(-0.8, 1.0, 1.0, 2.263)

    if IsNew then
        SetTimeout(750, function()
            TriggerEvent('qb-clothes:client:CreateFirstCharacter')
            IsNew = false
        end)
    end

    return { objects, poi }
end)

exports('CreateHouseRobbery', function(spawn)
    local shell = CreateShell(spawn, vector4(1.46, -10.33, 1.06, 0.39), 'furnitured_midapart')
    return { shell[1], shell[2] }
end)

local SHELLS = {
    CreateApartmentShell   = { model = 'shell_v16low',        exit = vector4(4.693, -6.015, 1.11, 358.634) },
    CreateTier1House       = { model = 'shell_v16mid',        exit = vector4(1.561, -14.305, 1.147, 2.263) },
    CreateTrevorsShell     = { model = 'shell_trevor',        exit = vector4(0.374, -3.789, 2.428, 358.633) },
    CreateCaravanShell     = { model = 'shell_trailer',       exit = vector4(-1.4, -2.1, 3.3, 358.633972168) },
    CreateLesterShell      = { model = 'shell_lester',        exit = vector4(-1.780, -0.795, 1.1, 270.30) },
    CreateRanchShell       = { model = 'shell_ranch',         exit = vector4(-1.257, -5.469, 2.5, 270.57) },
    CreateContainer        = { model = 'container_shell',     exit = vector4(0.08, -5.73, 1.24, 359.32) },
    CreateFurniMid         = { model = 'furnitured_midapart', exit = vector4(1.46, -10.33, 1.06, 0.39) },
    CreateFurniMotelModern = { model = 'modernhotel_shell',   exit = vector4(4.98, 4.35, 1.16, 179.79) },
    CreateFranklinAunt     = { model = 'shell_frankaunt',     exit = vector4(-0.36, -5.89, 1.70, 358.21) },
    CreateGarageMed        = { model = 'shell_garagemed',     exit = vector4(13.90, 1.63, 1.0, 87.05) },
    CreateMichael          = { model = 'shell_michael',       exit = vector4(-9.49, 5.54, 9.91, 270.86) },
    CreateOffice1          = { model = 'shell_office1',       exit = vector4(1.88, 5.06, 2.05, 180.07) },
    CreateStore1           = { model = 'shell_store1',        exit = vector4(-2.61, -4.73, 1.08, 1.0) },
    CreateWarehouse1       = { model = 'shell_warehouse1',    exit = vector4(-8.95, 0.51, 1.04, 268.82) },
}

for exportName, def in pairs(SHELLS) do
    exports(exportName, function(spawn)
        print(spawn)
        return CreateShell(spawn, def.exit, def.model)
    end)
end