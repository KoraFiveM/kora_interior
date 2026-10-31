package.path = '../kora_lib/test/?.lua;' .. package.path
local net = require('mocks').install()
local invoker = 'kora_housing'
function GetCurrentResourceName() return 'kora_interior' end
function GetInvokingResource() return invoker end
dofile('../kora_lib/build/initiate.lua')
dofile('../kora_lib/modules/util/shared.lua')
dofile('../kora_lib/local/resources/client.lua')
local provided, entities, released, fades, created = {}, {}, 0, 0, {}
exports = function(name, handler) provided[name] = handler end
function vector4(x, y, z, w) return { x = x, y = y, z = z, w = w } end
function CreateObjectNoOffset(_,x,y,z) entities[91] = true; created[#created+1]={'centered',x,y,z}; return 91 end
function CreateObject(_,x,y,z) entities[91] = true; created[#created+1]={'legacy',x,y,z}; return 91 end
function DoesEntityExist(entity) return entities[entity] == true end
function DeleteEntity(entity) entities[entity] = nil end
function FreezeEntityPosition() end
Kora.visuals = { fade = function() fades = fades + 1 end }
local stopWhileLoading = false
Kora.stream = { loadModel = function(_, callback)
    if stopWhileLoading then net.fire('onClientResourceStop', 'kora_housing') end
    callback(123)
    released = released + 1
    return 123
end }
Kora.compat = dofile('../kora_lib/compat/provider.lua')()
dofile('client/main.lua')
local checks = 0
local function check(value, message) assert(value, message); checks = checks + 1 end
local result = provided.createGeometry({ x = 1, y = 2, z = 3 }, { x = 4, y = 5, z = 6 }, 'shell_v16low')
check(result[1][1] == 91 and entities[91], 'geometry returns its owned object')
check(released == 1 and fades == 0, 'geometry uses the releasing model callback and never invokes the entry fade')
check(created[1][1] == 'centered' and created[1][4] == 3, 'default geometry retains exact no-offset origin')
invoker = 'foreign'
check(provided.removeGeometry(result[1]) == false and entities[91], 'foreign resources cannot remove this geometry')
invoker = 'kora_housing'
check(provided.removeGeometry(result[1]) == true and not entities[91], 'owner removes geometry explicitly')
local legacy = provided.createGeometry({ x = 1, y = 2, z = -27 }, {z=1}, 'standardmotel_shell', 'legacy')
check(legacy[1][1] == 91 and created[#created][1] == 'legacy' and created[#created][4] == -27, 'legacy geometry uses the same native and unmodified origin as stock factories')
check(legacy[2].exit.z == 1 and fades == 0, 'legacy geometry retains POI and never teleports')
check(provided.createGeometry({x=1,y=2,z=3}, {}, 'shell_v16low', 'guess') == false, 'unrecognized placement does not create geometry')
provided.createGeometry({ x = 1, y = 2, z = 3 }, {}, 'shell_v16low')
net.fire('onClientResourceStop', 'kora_housing')
check(not entities[91], 'owner stop removes geometry')
stopWhileLoading = true
check(provided.createGeometry({ x = 1, y = 2, z = 3 }, {}, 'shell_v16low') == false and not entities[91], 'owner stop during streaming cannot leave a late shell')
check(provided.createGeometry({ x = math.huge, y = 2, z = 3 }, {}, 'shell_v16low') == false, 'non-finite shell origins are rejected')
print(('qbinterior geometry: %d checks passed'):format(checks))
