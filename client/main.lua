local IsNew = false

local ownedGeometry, stopped = {}, {}
local geometry = QB.resources.registry(function(entity)
    ownedGeometry[entity] = nil
    if DoesEntityExist(entity) then DeleteEntity(entity) end
end)

-- Shared housing scenes need geometry without the legacy entry teleport.
exports('createGeometry', function(spawn, exit, model)
    local owner = GetInvokingResource() or GetCurrentResourceName()
    local generation = stopped[owner]
    for _, axis in ipairs({ 'x', 'y', 'z' }) do
        if not spawn or not QB.util.isFiniteNumber(spawn[axis]) then return false, 'Invalid shell origin.' end
    end
    local entity
    local loaded, err = QB.stream.loadModel(model, function(hash)
        if stopped[owner] ~= generation then return end
        entity = CreateObjectNoOffset(hash, spawn.x, spawn.y, spawn.z, false, false, false)
        if not entity or entity == 0 or not DoesEntityExist(entity) then entity = nil; return end
        FreezeEntityPosition(entity, true)
        geometry.track(owner, entity)
        ownedGeometry[entity] = true
    end)
    if not loaded or not entity then return false, err or 'Shell geometry could not be created.' end
    return { { entity }, { exit = exit } }
end)

exports('removeGeometry', function(objects)
    if type(objects) ~= 'table' then return false, 'Shell objects are required.' end
    local owner = GetInvokingResource() or GetCurrentResourceName()
    for _, entity in ipairs(objects) do
        if geometry.owner(entity) ~= owner then return false, 'Shell geometry belongs to another resource.' end
    end
    for _, entity in ipairs(objects) do
        geometry.untrack(entity)
        ownedGeometry[entity] = nil
        if DoesEntityExist(entity) then DeleteEntity(entity) end
    end
    return true
end)

AddEventHandler('onClientResourceStop', function(resource)
    stopped[resource] = (stopped[resource] or 0) + 1
    if resource ~= GetCurrentResourceName() then return end
    for entity in pairs(ownedGeometry) do
        if DoesEntityExist(entity) then DeleteEntity(entity) end
    end
    ownedGeometry = {}
end)

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

local function createShell(spawn, exit, model)
    local objects = {}
    local poi = { exit = exit }
    local modelHash = type(model) == 'string' and joaat(model) or model
    QB.stream.loadModel(modelHash)
    local house = CreateObject(modelHash, spawn.x, spawn.y, spawn.z, false, false, false)
    SetModelAsNoLongerNeeded(modelHash)
    FreezeEntityPosition(house, true)
    objects[#objects + 1] = house
    QB.visuals.fade(vector3(spawn.x + exit.x, spawn.y + exit.y, spawn.z + exit.z))
    return { objects, poi }
end

exports('createShell', function(spawn, exit, model)
    return createShell(spawn, exit, model)
end)

-- Starting Apartment

exports('CreateApartmentFurnished', function(spawn)
    local exit = vector4(1.5, -10.0, 0.0, 358.50)
    local shell = createShell(spawn, exit, 'furnitured_midapart')
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
    local shell = createShell(spawn, vector4(1.46, -10.33, 1.06, 0.39), 'furnitured_midapart')
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
        return createShell(spawn, def.exit, def.model)
    end)
end
