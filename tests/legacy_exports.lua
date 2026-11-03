package.path = '../kora_lib/test/?.lua;' .. package.path
local net = require('mocks').install()
function GetCurrentResourceName() return 'kora_interior' end
function GetInvokingResource() return 'legacy-consumer' end
dofile('../kora_lib/build/initiate.lua')
dofile('../kora_lib/modules/util/shared.lua')
dofile('../kora_lib/local/resources/client.lua')
Kora.compat = dofile('../kora_lib/compat/provider.lua')()
local provided, entities, released, fades, created = {}, {}, 0, {}, {}
exports = setmetatable({}, { __call = function(_, name, fn) provided[name] = fn end,
    __index = function() return setmetatable({}, { __index = function(_, name)
        return function(_, ...) return provided[name](...) end
    end }) end })
function vector4(x,y,z,w) return {x=x,y=y,z=z,w=w} end
function vector3(x,y,z) return {x=x,y=y,z=z} end
local names, missing = {}, {}
function joaat(model) local hash = 0; for i = 1, #model do hash = (hash * 31 + model:byte(i)) % 2147483647 end; names[hash] = model; return hash end
function IsModelInCdimage(hash) return not missing[names[hash]] end
function IsModelValid(hash) return not missing[names[hash]] end
function CreateObjectNoOffset(model,x,y,z) return CreateObject(model,x,y,z) end
function CreateObject(model,x,y,z) entities[#entities+1] = true; created[#created+1]={names[model] or model,x,y,z}; return #entities end
function DoesEntityExist(entity) return entities[entity] == true end
function DeleteEntity(entity) entities[entity] = false end
function SetModelAsNoLongerNeeded() released = released + 1 end
function FreezeEntityPosition() end
Kora.visuals = {fade = function(position) fades[#fades+1] = position end}
Kora.stream = {loadModel = function(model, cb) if cb then cb(model) end return 123 end}
dofile('client/main.lua')
dofile('client/optional.lua')
local checks = 0
local function check(value, message) assert(value, message); checks = checks+1 end
local function legacy(name)
    local handler
    net.fire('__cfx_export_qb-interior_'..name, function(fn) handler = fn end)
    return handler
end
local count = 0
for name, fn in pairs(provided) do
    if name ~= 'createGeometry' and name ~= 'removeGeometry' and name ~= 'createShell' then
        check(legacy(name) == fn, 'same shell handler for '..name); count=count+1
    end
end
check(count > 90, 'all existing shell factories registered')
local result = legacy('CreateApartmentFurnished')({x=10,y=20,z=30})
check(type(result[1])=='table' and entities[result[1][1]], 'created real object')
check(result[2].exit and result[2].clothes and result[2].stash and result[2].logout, 'legacy POI return shape')
check(released==1 and #fades==1, 'model released and entry fade applied')
local optional = legacy('CreateFurnishedHouse')({x=0,y=0,z=0})
check(entities[optional[1][1]] and optional[2].exit, 'optional factory reaches native createShell')
for _, name in ipairs({'CreateGarageMed', 'CreateFurniMotelStandard'}) do
    local shell = legacy(name)({x=10,y=20,z=-30})
    local expected = name == 'CreateGarageMed' and 'shell_garagem' or 'standardmotel_shell'
    check(created[#created][1] == expected and created[#created][4] == -30, name .. ' uses the bundled archetype and original spawn')
    local asset = io.open('stream/' .. expected .. '.ydr', 'rb')
    check(asset ~= nil, name .. ' model exists in the bundled pack'); if asset then asset:close() end
    check(shell[2].exit.w == (name == 'CreateGarageMed' and 87.05 or 271.29), name .. ' retains authored heading')
end
local standard = legacy('CreateFurniMotelStandard')({x=10,y=20,z=-30})
check(fades[#fades].w == 271.29, 'entry fade preserves the authored heading')
check(standard[2].exit.x == -0.43 and standard[2].exit.y == -2.51 and standard[2].exit.z == 1, 'standard motel retains authored exit offset')
legacy('CreateFurniMotel')({x=10,y=20,z=-30})
check(created[#created][1] == 'furnitured_motel', 'optional furnished motel remains distinct from bundled standard motel')
local callback = false
legacy('DespawnInterior')(result[1], function() callback=true end)
check(not entities[result[1][1]] and callback, 'despawn deletes object and finishes callback')
-- F#313: no callback is fine, and geometry owned by another resource is left alone.
local own = legacy('CreateTier1House')({x=0,y=0,z=0})
check(pcall(legacy('DespawnInterior'), own[1]) and not entities[own[1][1]], 'despawn without a callback does not error')
local realInvoker = GetInvokingResource
function GetInvokingResource() return 'kora_housing' end
local foreign = provided.createGeometry({x=0,y=0,z=0}, {}, 'shell_v16low')
GetInvokingResource = realInvoker
legacy('DespawnInterior')(foreign[1])
check(entities[foreign[1][1]], 'despawn leaves geometry owned by another resource')
-- F#311/F#312: a missing optional shell returns false, reason without teleporting or creating anything.
missing.shell_banham = true
local before, fadesBefore = #created, #fades
local ok, shell, reason = pcall(legacy('CreateBanham'), {x=0,y=0,z=0})
check(ok and shell == false and reason == 'Shell model is not installed.', 'missing shell model returns false, reason')
check(#created == before and #fades == fadesBefore, 'missing shell model never creates an object or fades')
local okGeo, geo, geoReason = pcall(provided.createGeometry, {x=0,y=0,z=0}, {}, 'shell_banham')
check(okGeo and geo == false and geoReason == 'Shell model is not installed.', 'createGeometry reports a missing model instead of raising')
missing.shell_banham = nil
-- F#312: legacy shells are owned by the caller and removed when it stops.
local tracked = legacy('CreateTier1House')({x=0,y=0,z=0})
net.fire('onClientResourceStop', 'legacy-consumer')
check(not entities[tracked[1][1]], 'caller stop removes legacy shells')
-- F#314: first-character clothing goes to the event kora_clothing handles.
local triggered, timeouts, realTrigger = {}, {}, TriggerEvent
function SetTimeout(_, fn) timeouts[#timeouts+1] = fn end
net.fire('qb-interior:client:SetNewState', true)
legacy('CreateApartmentFurnished')({x=0,y=0,z=0})
function TriggerEvent(name) triggered[#triggered+1] = name end
for _, fn in ipairs(timeouts) do fn() end
TriggerEvent = realTrigger
check(triggered[1] == 'qb-clothing:client:CreateFirstCharacter', 'new characters open the kora_clothing first-character menu')
print(('qbinterior legacy exports: %d checks passed'):format(checks))
