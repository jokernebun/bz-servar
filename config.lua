Config = {}

-- Folosit doar de comanda /dvgaraj: garajul în care ajung mașinile șterse (orice cheie din Config.Garages)
Config.DvStoredGarage = 'pdmgarage'

-- Distanța la care se deschide meniul garaj
Config.GarageZoneRadius = 15.0
Config.GarageInteractRadius = 2.5
Config.DropOffRadius = 1.5

-- Modelul „hologramă” afișat deasupra punctului unde apeși [E] (model mic = hologramă mică)
Config.PreviewModel = 'brioso'
-- Cât de sus plutește holograma (metri deasupra solului)
Config.PreviewFloatHeight = 1.0

-- Debug zone (poly)
Config.DebugPoly = false

-- Stările de vehicul (compatibile cu tabela player_vehicles)
Config.VehicleState = {
    OUT = 0,
    GARAGED = 1,
    IMPOUNDED = 2,
}

-- Tipuri simple de garaj (doar pentru UI / logic basic)
Config.GarageType = {
    NORMAL = 'normal',
    DEPOT = 'depot',
}

-- Toate garajele (copiate din qbx_garages/config/server.lua, simplificate)
-- Poți adăuga / modifica aici fără să depinzi de resource-ul qbx_garages.
Config.Garages = {
    -- PDM – garaj public
    pdmgarage = {
        label = 'PDM Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(-59.28, -1116.88, 25.43, 262.71),
                spawn = vec4(-53.31, -1116.52, 25.43, 32.66),
            },
        },
    },

    -- Public Garages
    motelgarage = {
        label = 'Motel Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(275.58, -344.74, 45.17, 70.0),
                spawn = vec4(271.26, -342.32, 44.7, 159.97),
            }
        },
    },
    sapcounsel = {
        label = 'San Andreas Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(-330.67, -781.12, 33.96, 40.46),
                spawn = vec4(-337.11, -775.34, 33.56, 132.09),
            }
        },
    },
    spanishave = {
        label = 'Spanish Ave Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(-1160.46, -741.04, 19.95, 41.26),
                spawn = vec4(-1165.38, -747.65, 18.94, 40.45),
            }
        },
    },
    caears24 = {
        label = 'Caears 24 Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(68.08, 13.15, 69.21, 160.44),
                spawn = vec4(72.61, 11.72, 68.47, 157.59),
            },
        },
    },
    littleseoul = {
        label = 'Little Seoul Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(-463.51, -808.2, 30.54, 0.0),
                spawn = vec4(-472.24, -813.61, 30.3, 179.88),
            }
        },
    },
    lagunapi = {
        label = 'Laguna Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(363.85, 297.97, 103.5, 341.39),
                spawn = vec4(367.41, 297.02, 103.2, 341.08),
            }
        },
    },
    airportp = {
        label = 'Airport Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(-796.07, -2023.26, 9.17, 55.18),
                spawn = vec4(-793.35, -2020.62, 8.51, 58.42),
            }
        },
    },
    beachp = {
        label = 'Beach Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(-1184.21, -1509.65, 4.65, 303.72),
                spawn = vec4(-1184.4, -1501.88, 4.39, 214.7),
            }
        },
    },
    themotorhotel = {
        label = 'The Motor Hotel Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(1137.77, 2663.54, 37.9, 0.0),
                spawn = vec4(1137.56, 2674.19, 38.17, 359.95),
            }
        },
    },
    liqourparking = {
        label = 'Liqour Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(960.68, 3609.32, 32.98, 268.97),
                spawn = vec4(960.48, 3605.71, 32.98, 87.09),
            }
        },
    },
    shoreparking = {
        label = 'Shore Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(1726.9, 3710.38, 34.26, 22.54),
                spawn = vec4(1728.65, 3714.85, 34.18, 21.26),
            }
        },
    },
    haanparking = {
        label = 'Bell Farms Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(78.34, 6418.74, 31.28, 0),
                spawn = vec4(70.71, 6425.16, 30.92, 68.5),
            }
        },
    },
    dumbogarage = {
        label = 'Dumbo Private Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(157.26, -3240.00, 7.00, 0),
                spawn = vec4(165.32, -3236.10, 5.93, 268.5),
            }
        },
    },
    pillboxgarage = {
        label = 'Pillbox Garage Parking',
        type = Config.GarageType.NORMAL,
        vehicleType = 'car',
        skipGarageCheck = true,
        accessPoints = {
            {
                coords = vec4(218.66, -804.08, 30.75, 65.69),
                spawn = vec4(229.33, -805.01, 30.54, 156.79),
            }
        },
    },
}

