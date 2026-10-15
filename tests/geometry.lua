package.path = '../qblib/test/?.lua;' .. package.path
local net = require('mocks').install()
local invoker = 'qbhousing'
function GetCurrentResourceName() return 'qbinterior' end
function GetInvokingResource() return invoker end
dofile('../qblib/build/initiate.lua')
dofile('../qblib/modules/util/shared.lua')
dofile('../qblib/local/resources/client.lua')
local provided, entities, released, fades = {}, {}, 0, 0
exports = function(name, handler) provided[name] = handler end
function vector4(x, y, z, w) return { x = x, y = y, z = z, w = w } end
function CreateObjectNoOffset() entities[91] = true; return 91 end
function DoesEntityExist(entity) return entities[entity] == true end
function DeleteEntity(entity) entities[entity] = nil end
function FreezeEntityPosition() end
QB.visuals = { fade = function() fades = fades + 1 end }
local stopWhileLoading = false
QB.stream = { loadModel = function(_, callback)
    if stopWhileLoading then net.fire('onClientResourceStop', 'qbhousing') end
    callback(123)
    released = released + 1
    return 123
end }
dofile('client/main.lua')
local checks = 0
local function check(value, message) assert(value, message); checks = checks + 1 end
local result = provided.createGeometry({ x = 1, y = 2, z = 3 }, { x = 4, y = 5, z = 6 }, 'shell_v16low')
check(result[1][1] == 91 and entities[91], 'geometry returns its owned object')
check(released == 1 and fades == 0, 'geometry uses the releasing model callback and never invokes the entry fade')
invoker = 'foreign'
check(provided.removeGeometry(result[1]) == false and entities[91], 'foreign resources cannot remove this geometry')
invoker = 'qbhousing'
check(provided.removeGeometry(result[1]) == true and not entities[91], 'owner removes geometry explicitly')
provided.createGeometry({ x = 1, y = 2, z = 3 }, {}, 'shell_v16low')
net.fire('onClientResourceStop', 'qbhousing')
check(not entities[91], 'owner stop removes geometry')
stopWhileLoading = true
check(provided.createGeometry({ x = 1, y = 2, z = 3 }, {}, 'shell_v16low') == false and not entities[91], 'owner stop during streaming cannot leave a late shell')
check(provided.createGeometry({ x = math.huge, y = 2, z = 3 }, {}, 'shell_v16low') == false, 'non-finite shell origins are rejected')
print(('qbinterior geometry: %d checks passed'):format(checks))
