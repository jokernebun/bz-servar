-- Apex Tuning config
-- Zonele de tuning (garaje) - aceleași ca în qbx_customs (doar din aceste zone se poate deschide tuning-ul, sau prin /tuning pentru staff/fondator)
Config = {}

Config.OpenKey = 'e'
Config.AllowAnyVehicle = true
Config.Messages = {
    NotInVehicle = '[Apex Tuning] Intră în mașină.',
    NotInZone = '[Apex Tuning] Poți folosi tuning-ul doar în garajele de tuning.',
    NotAllowed = 'Nu ai acces la comanda /tuning.',
}

-- Comanda /tuning este doar pentru staff / fondator (setează ace permission în server.cfg: add_ace group.fondator apex_tuning.staff allow)
Config.StaffAcePermission = 'apex_tuning.staff'

-- Zone poligonale (garaje tuning). La toate: intri cu mașina și apeși E.
-- Fiecare zonă are poligon + radius (fallback): dacă ești în raza de X m de centru, ești în garaj.
Config.Zones = {
    -- Los Santos Customs - Vinewood
    {
        points = {
            vector3(-344.36, -121.92, 38.60),
            vector3(-319.43, -130.65, 38.60),
            vector3(-324.77, -147.93, 38.60),
            vector3(-348.59, -139.1, 38.60),
        },
        radius = 28.0,
    },
    -- Los Santos Customs - Airport
    {
        points = {
            vector3(-1147.7, -1990.31, 13.15),
            vector3(-1171.05, -2013.96, 13.15),
            vector3(-1158.38, -2026.03, 13.15),
            vector3(-1139.17, -2007.18, 13.15),
            vector3(-1144.73, -1992.89, 13.15),
        },
        radius = 30.0,
    },
    -- Los Santos Customs - East
    {
        points = {
            vector3(724.93, -1092.04, 22.15),
            vector3(738.52, -1094.83, 22.15),
            vector3(737.36, -1064.56, 22.15),
            vector3(724.14, -1063.71, 22.15),
        },
        radius = 28.0,
    },
    -- Sandy Shores
    {
        points = {
            vector3(1172.12, 2644.76, 38.55),
            vector3(1171.39, 2635.66, 38.55),
            vector3(1189.77, 2636.08, 38.55),
            vector3(1189.74, 2644.07, 38.55),
        },
        radius = 28.0,
    },
    -- Paleto
    {
        points = {
            vector3(115.55, 6625.32, 31.75),
            vector3(109.19, 6631.69, 31.75),
            vector3(97.39, 6620.02, 31.75),
            vector3(102.72, 6613.48, 31.75),
        },
        radius = 28.0,
    },
    -- Benny's Motorworks
    {
        points = {
            vector3(-200.0, -1308.0, 30.85),
            vector3(-231.0, -1316.0, 30.85),
            vector3(-231.0, -1337.0, 30.85),
            vector3(-211.0, -1344.0, 30.85),
            vector3(-192.0, -1318.0, 30.85),
            vector3(-192.0, -1311.0, 30.85),
        },
        radius = 30.0,
    },
}
