BZ = BZ or {}
BZ.Config = {}

-- ============================================================
-- CONFIGURARE GENERALA
-- ============================================================
BZ.Config.ServerName   = "BZ RolePlay"
BZ.Config.Locale       = "ro"
BZ.Config.MaxChars     = GetConvar('bz:maxCharacters', '3') + 0
BZ.Config.Whitelist    = GetConvar('bz:enableWhitelist', 'false') == 'true'
BZ.Config.DevMode      = GetConvar('bz:devMode', 'false') == 'true'

-- Bani la start
BZ.Config.StartCash    = GetConvar('bz:startCash', '5000') + 0
BZ.Config.StartBank    = GetConvar('bz:startBank', '10000') + 0

-- ============================================================
-- SPAWN POINTS (dupa selectia personajului)
-- ============================================================
BZ.Config.SpawnPoints = {
    hotel = { x = -1037.0, y = -2738.0, z = 20.2, h = 325.0, label = "Hotel del Perro" },
    motel = { x = 325.7,   y = -167.0,  z = 87.7, h = 340.0, label = "Motel Sandy Shores" },
    beach = { x = -1393.0, y = -617.0,  z = 30.5, h = 205.0, label = "Plaja Del Perro" },
}

BZ.Config.DefaultSpawn = "hotel"

-- ============================================================
-- LOCATII ATM
-- ============================================================
BZ.Config.ATMs = {
    { x = 148.6,   y = -1036.6, z = 29.4  },
    { x = -350.0,  y = -48.0,   z = 49.0  },
    { x = 243.1,   y = 226.0,   z = 106.3 },
    { x = -1393.0, y = -585.0,  z = 30.0  },
    { x = -2963.0, y = 481.0,   z = 15.7  },
    { x = 1734.0,  y = 6415.0,  z = 35.0  },
}

-- ============================================================
-- LOCATII BANCA
-- ============================================================
BZ.Config.Banks = {
    {
        label  = "Fleeca Bank - Centrum",
        x = 149.0, y = -1044.0, z = 29.4,
        h = 340.0,
    },
    {
        label  = "Pacific Standard Bank",
        x = 258.0, y = 220.0, z = 106.3,
        h = 160.0,
    },
    {
        label  = "Blaine County Savings",
        x = 1175.0, y = 2706.0, z = 38.1,
        h = 180.0,
    },
}

-- ============================================================
-- CONFIGURARE HUD
-- ============================================================
BZ.Config.HUD = {
    showMinimap   = true,
    showCompass   = true,
    showMoney     = true,
    showJob       = true,
    speedometer   = true,
    metric        = true,  -- km/h in loc de mph
}

-- ============================================================
-- CONFIGURARE VOCE
-- ============================================================
BZ.Config.Voice = {
    defaultRange = 3.0,  -- metrii
    maxRange     = 15.0,
}
