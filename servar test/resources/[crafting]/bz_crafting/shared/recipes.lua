BZ = BZ or {}
BZ.Crafting = {}

-- ============================================================
-- MESE DE CRAFTING
-- Fiecare masa are locatie si retete proprii
-- ============================================================

BZ.Crafting.Tables = {

    -- ============================================================
    -- MASA GENERALA (spawn city)
    -- ============================================================
    ['general'] = {
        label    = 'Masa Lucru',
        icon     = '🔨',
        location = { x = 224.0, y = -967.0, z = 30.0 },
        recipes  = {
            {
                result      = 'firstaid',
                resultCount = 1,
                label       = 'Trusa Prim Ajutor',
                icon        = '🏥',
                description = 'Recupereaza HP complet',
                time        = 8000,
                ingredients = {
                    { item='bandage', count=3 },
                    { item='cloth',   count=2 },
                },
            },
            {
                result      = 'rope',
                resultCount = 2,
                label       = 'Franghie',
                icon        = '🪢',
                description = 'Util in diverse situatii',
                time        = 3000,
                ingredients = {
                    { item='cloth', count=4 },
                },
            },
            {
                result      = 'bandage',
                resultCount = 3,
                label       = 'Bandaje (x3)',
                icon        = '🩹',
                description = 'Opreste sangerarea',
                time        = 4000,
                ingredients = {
                    { item='cloth', count=2 },
                },
            },
            {
                result      = 'screwdriver',
                resultCount = 1,
                label       = 'Surubelnita',
                icon        = '🔩',
                description = 'Util pentru reparatii',
                time        = 4000,
                ingredients = {
                    { item='iron_bar', count=1 },
                    { item='plastic',  count=1 },
                },
            },
        },
    },

    -- ============================================================
    -- ATELIER MECANIC
    -- ============================================================
    ['mechanic'] = {
        label    = 'Atelier Mecanic',
        icon     = '🔧',
        location = { x = -351.0, y = -133.0, z = 39.0 },
        jobRequired = 'mechanic',
        recipes  = {
            {
                result      = 'repair_kit',
                resultCount = 1,
                label       = 'Kit Reparatie',
                icon        = '🛠️',
                description = 'Repara complet un vehicul',
                time        = 12000,
                ingredients = {
                    { item='iron_bar',  count=3 },
                    { item='wrench',    count=0 },  -- nu consuma, doar verifica
                    { item='spring',    count=2 },
                    { item='plastic',   count=2 },
                },
            },
            {
                result      = 'tire_kit',
                resultCount = 1,
                label       = 'Kit Anvelope',
                icon        = '🚗',
                description = 'Repara anvelopele',
                time        = 8000,
                ingredients = {
                    { item='iron_bar', count=2 },
                    { item='plastic',  count=3 },
                },
            },
            {
                result      = 'fuel_can',
                resultCount = 1,
                label       = 'Bidon Combustibil',
                icon        = '⛽',
                description = '5L benzina',
                time        = 5000,
                ingredients = {
                    { item='plastic',  count=2 },
                    { item='iron_bar', count=1 },
                },
            },
        },
    },

    -- ============================================================
    -- LAB DROGURI (ilegal)
    -- ============================================================
    ['drug_lab'] = {
        label    = 'Laborator Clandestin',
        icon     = '🔮',
        location = { x = 1385.0, y = 3614.0, z = 35.0 },
        blip     = false,  -- nu apare pe harta
        recipes  = {
            {
                result      = 'weed',
                resultCount = 5,
                label       = 'Iarba (x5)',
                icon        = '🌿',
                description = 'Produs ilegal',
                time        = 10000,
                illegal     = true,
                ingredients = {
                    { item='weed_seed', count=3 },
                },
            },
            {
                result      = 'cocaine',
                resultCount = 2,
                label       = 'Cocaina (x2)',
                icon        = '❄️',
                description = 'Produs ilegal',
                time        = 15000,
                illegal     = true,
                ingredients = {
                    { item='cocaine_bag',      count=3 },
                    { item='meth_ingredient',  count=1 },
                },
            },
            {
                result      = 'meth',
                resultCount = 3,
                label       = 'Meth (x3)',
                icon        = '🔮',
                description = 'Produs ilegal',
                time        = 18000,
                illegal     = true,
                ingredients = {
                    { item='meth_ingredient', count=4 },
                },
            },
        },
    },

    -- ============================================================
    -- ARMURIER (ilegal)
    -- ============================================================
    ['gunsmith'] = {
        label    = 'Atelier Arme',
        icon     = '🔫',
        location = { x = 813.0, y = -2157.0, z = 29.0 },
        blip     = false,
        recipes  = {
            {
                result      = 'ammo_9mm',
                resultCount = 20,
                label       = 'Munitie 9mm (x20)',
                icon        = '🔴',
                description = 'Gloante de pistol',
                time        = 8000,
                illegal     = true,
                ingredients = {
                    { item='gunpowder',  count=2 },
                    { item='copper_wire',count=1 },
                    { item='steel',      count=1 },
                },
            },
            {
                result      = 'ammo_rifle',
                resultCount = 10,
                label       = 'Munitie Pusca (x10)',
                icon        = '🔴',
                description = 'Gloante pentru pusca',
                time        = 10000,
                illegal     = true,
                ingredients = {
                    { item='gunpowder',  count=3 },
                    { item='steel',      count=2 },
                    { item='copper_wire',count=1 },
                },
            },
            {
                result      = 'lockpick',
                resultCount = 2,
                label       = 'Spargator (x2)',
                icon        = '🔑',
                description = 'Sparge incuietori',
                time        = 6000,
                illegal     = true,
                ingredients = {
                    { item='iron_bar',  count=2 },
                    { item='spring',    count=1 },
                },
            },
        },
    },

    -- ============================================================
    -- ELECTRONICA
    -- ============================================================
    ['electronics'] = {
        label    = 'Atelier Electronic',
        icon     = '🔋',
        location = { x = 117.0, y = -1080.0, z = 29.0 },
        recipes  = {
            {
                result      = 'electronics',
                resultCount = 1,
                label       = 'Componente Electr.',
                icon        = '🔋',
                description = 'Electronice de calitate',
                time        = 6000,
                ingredients = {
                    { item='copper_wire', count=3 },
                    { item='plastic',     count=2 },
                    { item='glass',       count=1 },
                },
            },
            {
                result      = 'phone',
                resultCount = 1,
                label       = 'Telefon',
                icon        = '📱',
                description = 'Smartphone functional',
                time        = 10000,
                ingredients = {
                    { item='electronics', count=3 },
                    { item='glass',       count=2 },
                    { item='plastic',     count=1 },
                },
            },
        },
    },
}
