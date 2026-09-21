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
    return {objects, poi}
end

local SHELLS = {
    -- Medium Housing Shells V1 -- https://www.k4mb1maps.com/package/4672307
    CreateMedium2               = { model = 'shell_medium2',                exit = vector4(6.04, 0.34, 1.03, 357.99) },
    CreateMedium3               = { model = 'shell_medium3',                exit = vector4(3.32, 1.23, 2.57, 273.46) },

    -- Modern Housing Shells V1 -- https://www.k4mb1maps.com/package/4673169
    CreateBanham                = { model = 'shell_banham',                 exit = vector4(-3.26, -1.63, 6.25, 90.49) },
    CreateWestons               = { model = 'shell_westons',                exit = vector4(4.29, 10.59, 6.95, 183.60) },
    CreateWestons2              = { model = 'shell_westons2',               exit = vector4(-1.76, 10.62, 6.95, 179.20) },

    -- Classic Housing Shells V1 -- https://www.k4mb1maps.com/package/4673140
    CreateClassicHouse          = { model = 'classichouse_shell',           exit = vector4(4.78, -2.11, 5.26, 87.93) },
    CreateClassicHouse2         = { model = 'classichouse2_shell',          exit = vector4(4.78, -2.09, 5.26, 90.58) },
    CreateClassicHouse3         = { model = 'classichouse3_shell',          exit = vector4(4.78, -2.12, 5.26, 91.60) },

    -- Highend Housing Shells V1 -- https://www.k4mb1maps.com/package/4673131
    CreateHighend1              = { model = 'shell_apartment1',             exit = vector4(-2.23, 9.01, 8.69, 178.81) },
    CreateHighend2              = { model = 'shell_apartment2',             exit = vector4(-2.25, 9.00, 8.69, 177.86) },
    CreateHighend3              = { model = 'shell_apartment3',             exit = vector4(11.75, 4.55, 8.13, 129.16) },

    -- Deluxe Housing Shells V1 -- https://www.k4mb1maps.com/package/4673159
    CreateHighend               = { model = 'shell_highend',                exit = vector4(-22.37, -0.33, 7.26, 267.73) },
    CreateHighendV2             = { model = 'shell_highendv2',              exit = vector4(-10.51, 0.86, 6.56, 270.38) },

    -- Stash House Shells -- https://www.k4mb1maps.com/package/4673273
    CreateStashHouse            = { model = 'stashhouse_shell',             exit = vector4(20.88, -0.40, 15.42, 86.54) },
    CreateStashHouse2           = { model = 'stashhouse2_shell',            exit = vector4(-1.98, 2.26, 1.0, 263.81) },

    -- Garage Shells -- https://www.k4mb1maps.com/package/4673177
    CreateGarageLow             = { model = 'shell_garages',                exit = vector4(5.85, 3.86, 1.0, 180.05) },
    CreateGarageHigh            = { model = 'shell_garagel',                exit = vector4(12.02, -14.30, 0.99, 89.42) },

    -- Office Shells -- https://www.k4mb1maps.com/package/4673258
    CreateOffice2               = { model = 'shell_office2',                exit = vector4(3.66, -1.94, 1.26, 92.73) },
    CreateOfficeBig             = { model = 'shell_officebig',              exit = vector4(-12.48, 1.91, 5.30, 175.13) },

    -- Store Shells -- https://www.k4mb1maps.com/package/4673264
    CreateBarber                = { model = 'shell_barber',                 exit = vector4(1.54, 5.40, 1.0, 175.27) },
    CreateGunstore              = { model = 'shell_gunstore',               exit = vector4(-1.02, -5.43, 1.03, 359.77) },
    CreateStore2                = { model = 'shell_store2',                 exit = vector4(-0.64, -5.07, 1.02, 1.91) },
    CreateStore3                = { model = 'shell_store3',                 exit = vector4(-0.14, -7.87, 2.01, 358.15) },

    -- Warehouse Shells -- https://www.k4mb1maps.com/package/4673185
    CreateWarehouse2            = { model = 'shell_warehouse2',             exit = vector4(12.51, -0.01, 1.03, 94.52) },
    CreateWarehouse3            = { model = 'shell_warehouse3',             exit = vector4(2.61, -1.65, 1.00, 85.2) },

    -- Highend Lab Shells -- https://www.k4mb1maps.com/package/4698329
    CreateK4Coke                = { model = 'k4coke_shell',                 exit = vector4(-11.06, -2.52, 22.64, 272.51) },
    CreateK4Meth                = { model = 'k4meth_shell',                 exit = vector4(-11.06, -2.48, 9.47, 277.54) },
    CreateK4Weed                = { model = 'k4weed_shell',                 exit = vector4(-11.05, -2.50, 20.96, 283.97) },

    -- Furnished Stash House Shells -- https://www.k4mb1maps.com/package/4672293
    CreateContainer2            = { model = 'container2_shell',             exit = vector4(0.02, -5.37, 1.12, 355.28) },
    CreateFurniStash1           = { model = 'stashhouse1_shell',            exit = vector4(21.41, -0.52, 19.33, 85.84) },
    CreateFurniStash3           = { model = 'stashhouse3_shell',            exit = vector4(-0.003, 5.5, 3.04, 180.77) },

    -- Furnished Housing Shells -- https://www.k4mb1maps.com/package/4672272
    CreateFurniLow              = { model = 'furnitured_lowapart',          exit = vector4(5.05, -1.39, 3.0, 357.14) },
    CreateFurniMotel            = { model = 'furnitured_motel',             exit = vector4(-1.51, -3.99, 1.08, 1.28) },

    -- Furnished Motel Shells -- https://www.k4mb1maps.com/package/4672296
    CreateFurniMotelClassic     = { model = 'classicmotel_shell',           exit = vector4(0.045, -3.707, 1.05, 351.86) },
    CreateFurniMotelHigh        = { model = 'highendmotel_shell',           exit = vector4(3.21, 3.50, 1.16, 178.23) },

    -- Furnished Modern Hotels -- https://www.k4mb1maps.com/package/4672290
    CreateFurniMotelModern2     = { model = 'modernhotel2_shell',           exit = vector4(4.87, 4.38, 1.16, 176.40) },
    CreateFurniMotelModern3     = { model = 'modernhotel3_shell',           exit = vector4(4.95, 4.38, 1.16, 176.01) },

    -- Drug Lab Shells -- https://www.k4mb1maps.com/package/4672285
    CreateCoke                  = { model = 'shell_coke1',                  exit = vector4(-6.24, 8.48, 1.00, 179.30) },
    CreateCoke2                 = { model = 'shell_coke2',                  exit = vector4(-6.32, 8.60, 1.03, 179.23) },
    CreateMeth                  = { model = 'shell_meth',                   exit = vector4(-6.39, 8.54, 1.03, 178.84) },
    CreateWeed                  = { model = 'shell_weed',                   exit = vector4(17.46, 11.71, 1.01, 88.37) },
    CreateWeed2                 = { model = 'shell_weed2',                  exit = vector4(17.85, 11.75, 1.01, 88.11) },

    -- Mansion Housing Shells -- https://www.k4mb1maps.com/package/4783251
    CreateMansion                = { model = 'k4_mansion_shell',            exit = vector4(-0.32, -0.68, 7.86, 178.98) },
    CreateMansion2               = { model = 'k4_mansion2_shell',           exit = vector4(-0.32, -0.57, 7.86, 178.74) },
    CreateMansion3               = { model = 'k4_mansion3_shell',           exit = vector4(-0.18, -0.57, 7.86, 180.76) },

    -- Empty Hotel Shells -- https://www.k4mb1maps.com/package/4811134
    CreateHotel1                 = { model = 'k4_hotel1_shell',             exit = vector4(4.94, 4.39, 1.17, 177.55) },
    CreateHotel2                 = { model = 'k4_hotel2_shell',             exit = vector4(4.99, 4.39, 1.17, 178.62) },
    CreateHotel3                 = { model = 'k4_hotel3_shell',             exit = vector4(4.90, 4.39, 1.17, 182.13) },

    -- Empty Motel Shells -- https://www.k4mb1maps.com/package/4811137
    CreateMotel1                 = { model = 'k4_motel1_shell',             exit = vector4(-0.46, -2.46, 1.00, 274.07) },
    CreateMotel2                 = { model = 'k4_motel2_shell',             exit = vector4(0.06, -3.75, 1.05, 359.40) },
    CreateMotel3                 = { model = 'k4_motel3_shell',             exit = vector4(3.13, 3.50, 1.16, 182.53) },

    -- Default Shells V2 -- https://www.k4mb1maps.com/package/5015832
    CreateV2Default1             = { model = 'default_housing1_k4mb1',      exit = vector4(-2.32, -0.63, 1.60, 272.87) },
    CreateV2Default2             = { model = 'default_housing2_k4mb1',      exit = vector4(-5.14, -5.05, 3.18, 270.61) },
    CreateV2Default3             = { model = 'default_housing3_k4mb1',      exit = vector4(-1.35, -2.06, 1.11, 1.14) },
    CreateV2Default4             = { model = 'default_housing4_k4mb1',      exit = vector4(0.13, -3.85, 1.09, 1.71) },
    CreateV2Default5             = { model = 'default_housing5_k4mb1',      exit = vector4(1.42, -14.34, 1.14, 0.87) },
    CreateV2Default6             = { model = 'default_housing6_k4mb1',      exit = vector4(4.75, -6.49, 1.03, 359.60) },

    -- Deluxe Shells V2 -- https://www.k4mb1maps.com/package/5043817
    CreateV2Deluxe1              = { model = 'deluxe_housing1_k4mb1',       exit = vector4(-22.28, -0.45, 7.26, 268.97) },
    CreateV2Deluxe2              = { model = 'deluxe_housing2_k4mb1',       exit = vector4(-10.30, 0.87, 6.55, 274.91) },
    CreateV2Deluxe3              = { model = 'deluxe_housing3_k4mb1',       exit = vector4(-9.37, 5.66, 1.08, 270.04) },

    -- Highend Shells V2 -- https://www.k4mb1maps.com/package/5043819
    CreateV2HighEnd1             = { model = 'highend_housing1_k4mb1',      exit = vector4(-2.22, 9.02, 8.69, 182.64) },
    CreateV2HighEnd2             = { model = 'highend_housing2_k4mb1',      exit = vector4(-2.22, 8.97, 8.69, 171.95) },
    CreateV2HighEnd3             = { model = 'highend_housing3_k4mb1',      exit = vector4(11.48, 4.50, 6.42, 128.15) },

    -- Medium Shells V2 -- https://www.k4mb1maps.com/package/5043821
    CreateV2Medium1              = { model = 'medium_housing1_k4mb1',       exit = vector4(-0.24, -5.66, 1.71, 1.5) },
    CreateV2Medium2              = { model = 'medium_housing2_k4mb1',       exit = vector4(6.04, 0.34, 1.03, 357.99) },
    CreateV2Medium3              = { model = 'medium_housing3_k4mb1',       exit = vector4(3.42, 1.18, 1.01, 274.17) },

    -- Modern Shells V2 -- https://www.k4mb1maps.com/package/5043818
    CreateV2Modern1              = { model = 'modern_housing1_k4mb1',       exit = vector4(4.29, 10.52, 6.30, 178.92) },
    CreateV2Modern2              = { model = 'modern_housing2_k4mb1',       exit = vector4(-1.76, 10.37, 6.30, 184.71) },
    CreateV2Modern3              = { model = 'modern_housing3_k4mb1',       exit = vector4(-3.39, -1.45, 5.65, 90.77) },

    -- K4mb1 Vinewood V2 Shells -- https://www.k4mb1maps.com/package/5251329
    VineWoodHouse1               = { model = 'vinewood_housing1_k4mb1',     exit = vector4(11.86, -2.73, 3.96, 2.11) },
    VineWoodHouse2               = { model = 'vinewood_housing2_k4mb1',     exit = vector4(1.57, 4.96, 9.63, 2.11) },
    VineWoodHouse3               = { model = 'vinewood_housing3_k4mb1',     exit = vector4(3.41, 7.11, 2.76, 2.11) },

    -- K4mb1 September Update
    CreateK4GunWarehouse         = { model = 'gunworkshop_k4mb1',           exit = vector4(0.29, 4.74, -0.0, 179.603271) },
    CreateK4LuxuryHouse1         = { model = 'luxury_housing1_k4mb1',       exit = vector4(-6.344482, -1.034912, 3.0, 268.09) },
    CreateK4LuxuryHouse2         = { model = 'luxury_housing2_k4mb1',       exit = vector4(-6.344482, -1.034912, 3.0, 268.09) }, -- same exit as House1 in source; verify if intentional
    CreateK4LuxuryHouse3         = { model = 'luxury_housing3_k4mb1',       exit = vector4(-6.344482, -1.034912, 3.0, 268.09) }, -- same exit as House1 in source; verify if intentional
    CreateK4LuxuryHouse4         = { model = 'luxury_housing4_k4mb1',       exit = vector4(-6.344482, -1.034912, 3.0, 268.09) }, -- same exit as House1 in source; verify if intentional
    CreateK4ManorHouse           = { model = 'manor_housing1_k4mb1',        exit = vector4(6.839844, -9.136841, 13.0, 359.318207) },
    CreateK4Garage1              = { model = 'new_garages1_k4mb1',          exit = vector4(0.000366, 14.130432, 1.827162, 183.492355) },
    CreateK4Garage2              = { model = 'new_garages2_k4mb1',          exit = vector4(-3.737671, -0.096680, 1.427162, 268.669922) },
    CreateK4Garage3              = { model = 'new_garages3_k4mb1',          exit = vector4(-3.737671, -0.096680, 1.427162, 268.669922) }, -- same exit as Garage2 in source; verify if intentional
    CreateK4Garage4              = { model = 'new_garages4_k4mb1',          exit = vector4(8.806641, 1.580383, 1.439952, 93.087669) },
    CreateK4Safehouse            = { model = 'safehouse_k4mb1',             exit = vector4(-5.317017, 1.031738, 1.439952, 269.149353) },
    CreateK4Warehouse            = { model = 'warehouse_k4mb1',             exit = vector4(13.414185, -7.386108, 2.539952, 90.148018) },

    -- New Garages -- https://www.k4mb1maps.com/package/5294668
    CreateK4NewGarage            = { model = 'new_garages1_k4mb1',          exit = vector4(-0.010498, 13.742065, 5.216461, 180.0) },
    CreateK4NewGarage2           = { model = 'new_garages2_k4mb1',          exit = vector4(-3.885496, 0.018372, 0.119728, 271.723022) },
    CreateK4NewGarage3           = { model = 'new_garages3_k4mb1',          exit = vector4(-3.557486, -0.223755, 0.113129, 269.100739) },
    CreateK4NewGarage4           = { model = 'new_garages4_k4mb1',          exit = vector4(8.948175, 1.714355, 0.049950, 95.899307) },

    -- Basement Shells
    CreateK4Basement             = { model = 'k4mb1_basement1_shell',       exit = vector4(-5.08, -4.33, 5.90, 3.45) },
    CreateK4Basement1            = { model = 'k4mb1_basement2_shell',       exit = vector4(-5.08, -4.33, 5.90, 3.45) },
    CreateK4Basement2            = { model = 'k4mb1_basement3_shell',       exit = vector4(-5.08, -4.33, 5.90, 3.45) },
    CreateK4Basement3            = { model = 'k4mb1_basement4_shell',       exit = vector4(-5.08, -4.33, 5.90, 3.45) },
    CreateK4Basement4            = { model = 'k4mb1_basement5_shell',       exit = vector4(-5.08, -4.33, 5.90, 3.45) },

    -- Casino Hotel
    CreateK4CasinoHotel          = { model = 'k4mb1_casinohotel_shell',     exit = vector4(-3.03, -0.03, 0.10, 266.89) },

    -- New Houses
    CreateK4House1               = { model = 'k4mb1_house1_shell',          exit = vector4(-8.33, 1.01, 2.02, 270.22) },
    CreateK4House2               = { model = 'k4mb1_house2_shell',          exit = vector4(-8.33, 1.01, 2.02, 270.22) }, -- same exit as House1 in source; verify if intentional
    CreateK4House3               = { model = 'k4mb1_house3_shell',          exit = vector4(9.00, -7.43, 2.02, 1.04) },
    CreateK4House4               = { model = 'k4mb1_house4_shell',          exit = vector4(-2.22, -2.50, 0.70, 357.22) },

    -- Furnished Offices
    CreateFurnishedOffice1       = { model = 'k4mb1_furnishedoffice1_shell', exit = vector4(3.33, -2.05, 1.39, 92.20) },
    CreateFurnishedOffice2       = { model = 'k4mb1_furnishedoffice2_shell', exit = vector4(4.42, 3.54, 1.36, 179.63) },
    CreateFurnishedOffice3       = { model = 'k4mb1_furnishedoffice3_shell', exit = vector4(-0.66, 5.81, 1.51, 90.57) },
    CreateFurnishedOffice4       = { model = 'k4mb1_furnishedoffice4_shell', exit = vector4(8.60, -2.28, 1.56, 91.17) },
    CreateFurnishedOffice5       = { model = 'k4mb1_furnishedoffice5_shell', exit = vector4(3.19, -13.87, 1.26, 2.37) },

    -- Hood House
    CreateHoodHouse              = { model = 'k4mb1_hoodhouse1_shell',      exit = vector4(-2.49, -7.38, 2.01, 93.19) },

    -- Laundry Shell
    CreateLaundry                = { model = 'k4mb1_laundry_shell',         exit = vector4(10.45, -5.70, 3.37, 5.13) },

    -- Paleto House
    CreatePaletoHouse            = { model = 'k4mb1_palhouse1_shell',       exit = vector4(-0.92, 5.65, 3.34, 90.05) },

    -- Sandy House
    CreateSandyHouse             = { model = 'k4mb1_sandyhouse1_shell',     exit = vector4(1.65, -4.60, 3.19, 2.53) },

    -- Empty House
    CreateEmptyHouse             = { model = 'kambi_emptyhouse1',           exit = vector4(-0.42, -2.35, 1.91, 271.88) },

    -- Furnished House
    CreateFurnishedHouse         = { model = 'kambi_furnishedhouse1',       exit = vector4(-0.47, -2.38, 1.90, 274.87) },
}

for exportName, def in pairs(SHELLS) do
    exports(exportName, function(spawn)
        return createShell(spawn, def.exit, def.model)
    end)
end
