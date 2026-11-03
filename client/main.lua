local function legacyExport(name, handler)
    exports(name, handler)
    Kora.compat.provideExport('qb-interior', name, handler)
end

local IsNew = false

local ownedGeometry, stopped = {}, {}
local geometry = Kora.resources.registry(function(entity)
    ownedGeometry[entity] = nil
    if DoesEntityExist(entity) then DeleteEntity(entity) end
end)

local MISSING_MODEL = 'Shell model is not installed.'

-- Kora.stream.loadModel asserts on an unknown model, so an optional shell pack
-- that is not installed must be caught before loading (F#311, F#312).
local function installedModel(model)
    local hash = type(model) == 'string' and model ~= '' and joaat(model) or model
    if math.type(hash) ~= 'integer' then return nil end
    -- Natives always exist in game. Some downstream headless suites (kora_housing)
    -- load this file without the stubs, so a missing native is treated as installed.
    if IsModelInCdimage and not IsModelInCdimage(hash) then return nil end
    if IsModelValid and not IsModelValid(hash) then return nil end
    return hash
end

-- Shared housing scenes need geometry without the legacy entry teleport.
exports('createGeometry', function(spawn, exit, model, placement)
    local owner = GetInvokingResource() or GetCurrentResourceName()
    local generation = stopped[owner]
    for _, axis in ipairs({ 'x', 'y', 'z' }) do
        if not spawn or not Kora.util.isFiniteNumber(spawn[axis]) then return false, 'Invalid shell origin.' end
    end
    if placement ~= nil and placement ~= 'centered' and placement ~= 'legacy' then return false, 'Invalid shell placement mode.' end
    local modelHash = installedModel(model)
    if not modelHash then return false, MISSING_MODEL end
    local entity
    local loaded, err = Kora.stream.loadModel(modelHash, function(hash)
        if stopped[owner] ~= generation then return end
        -- Stock factories use CreateObject's model offset; centered native scenes
        -- deliberately keep their existing CreateObjectNoOffset contract.
        local create = placement == 'legacy' and CreateObject or CreateObjectNoOffset
        entity = create(hash, spawn.x, spawn.y, spawn.z, false, false, false)
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

-- Stock apartments scripts set this before CreateApartmentFurnished so a new
-- character gets the first-character clothing menu (kora_clothing's event).
RegisterNetEvent('qb-interior:client:SetNewState', function(bool)
    IsNew = bool == true
end)

-- Deletes the objects a legacy factory returned. Geometry another resource owns
-- is left alone; ours (or untracked handles, as stock allowed) is removed.
legacyExport('DespawnInterior', function(objects, cb)
    local owner = GetInvokingResource() or GetCurrentResourceName()
    if type(objects) == 'table' then
        for _, obj in pairs(objects) do
            local tracked = geometry.owner(obj)
            if tracked == nil or tracked == owner then
                geometry.untrack(obj)
                ownedGeometry[obj] = nil
                if DoesEntityExist(obj) then DeleteEntity(obj) end
            end
        end
    end
    if type(cb) == 'function' then cb() end
end)

-- Legacy factory: creates the shell, fades the player to the exit and returns
-- { objects, poi }, or false, reason when the model is missing or the object
-- could not be created (without moving the player). The shell is owned by the
-- invoking resource and removed when it (or kora_interior) stops.
local function createShell(spawn, exit, model)
    local modelHash = installedModel(model)
    if not modelHash then return false, MISSING_MODEL end
    if not Kora.stream.loadModel(modelHash) then return false, 'Shell model could not be loaded.' end
    local house = CreateObject(modelHash, spawn.x, spawn.y, spawn.z, false, false, false)
    SetModelAsNoLongerNeeded(modelHash)
    if not house or house == 0 or not DoesEntityExist(house) then return false, 'Shell geometry could not be created.' end
    FreezeEntityPosition(house, true)
    geometry.track(GetInvokingResource() or GetCurrentResourceName(), house)
    ownedGeometry[house] = true
    Kora.visuals.fade(vector4(spawn.x + exit.x, spawn.y + exit.y, spawn.z + exit.z, exit.w or exit.h or 0))
    return { { house }, { exit = exit } }
end

-- Shared with client/optional.lua so its factories call it directly.
KoraInterior = { createShell = createShell }

exports('createShell', createShell)

legacyExport('CreateApartmentFurnished', function(spawn)
    local exit = vector4(1.5, -10.0, 0.0, 358.50)
    local shell, err = createShell(spawn, exit, 'furnitured_midapart')
    if not shell then return false, err end
    local poi = shell[2]

    poi.clothes = vector4(-6.028, -9.5, 1.2, 2.263)
    poi.stash = vector4(-7.305, -3.922, 0.5, 2.263)
    poi.logout = vector4(-0.8, 1.0, 1.0, 2.263)

    if IsNew then
        SetTimeout(750, function()
            TriggerEvent('qb-clothing:client:CreateFirstCharacter')
            IsNew = false
        end)
    end

    return shell
end)

legacyExport('CreateHouseRobbery', function(spawn)
    return createShell(spawn, vector4(1.46, -10.33, 1.06, 0.39), 'furnitured_midapart')
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
    CreateGarageMed        = { model = 'shell_garagem',     exit = vector4(13.90, 1.63, 1.0, 87.05) },
    CreateMichael          = { model = 'shell_michael',       exit = vector4(-9.49, 5.54, 9.91, 270.86) },
    CreateOffice1          = { model = 'shell_office1',       exit = vector4(1.88, 5.06, 2.05, 180.07) },
    CreateStore1           = { model = 'shell_store1',        exit = vector4(-2.61, -4.73, 1.08, 1.0) },
    CreateFurniMotelStandard = { model = 'standardmotel_shell', exit = vector4(-0.43, -2.51, 1.0, 271.29) },
    CreateWarehouse1       = { model = 'shell_warehouse1',    exit = vector4(-8.95, 0.51, 1.04, 268.82) },
}

for exportName, def in pairs(SHELLS) do
    legacyExport(exportName, function(spawn)
        return createShell(spawn, def.exit, def.model)
    end)
end
