fx_version 'cerulean'
game 'gta5'

provide 'qb-interior'
lua54 'yes'
-- Keep the legacy resource name resolvable for exports['qbinterior'] callers.
provide 'qbinterior'
author 'Kakarot'
description 'Collection of shell models with exports for creating them'
version '1.2.0'
this_is_a_map 'yes'

dependency 'kora_lib'

shared_scripts {
    'config.lua'
}

client_scripts {
    '@kora_lib/init.lua',
    'client/main.lua',
    'client/optional.lua'
}

files {
    'stream/starter_shells_k4mb1.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/starter_shells_k4mb1.ytyp'
