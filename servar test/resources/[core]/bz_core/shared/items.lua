BZ = BZ or {}
BZ.Items = {}

-- ============================================================
-- DEFINITII ITEME
-- name = cheia unica, label = ce vede jucatorul
-- weight = grame, usable = poate fi folosit, stackable = se pot stivui
-- ============================================================

-- GENERALE
BZ.Items['water']          = { name='water',          label='Apa Plata',         weight=500,   usable=true,  stackable=true,  description='Hidrateaza-te.' }
BZ.Items['bread']          = { name='bread',          label='Paine',             weight=400,   usable=true,  stackable=true,  description='O franzeluta proaspata.' }
BZ.Items['sandwich']       = { name='sandwich',       label='Sandwich',          weight=300,   usable=true,  stackable=true,  description='Un sandwich delicios.' }
BZ.Items['coffee']         = { name='coffee',         label='Cafea',             weight=250,   usable=true,  stackable=true,  description='Te trezeste.' }
BZ.Items['energy_drink']   = { name='energy_drink',   label='Bautura Energizanta',weight=300,  usable=true,  stackable=true,  description='Stamina +.' }

-- MEDICAL
BZ.Items['bandage']        = { name='bandage',        label='Bandaj',            weight=100,   usable=true,  stackable=true,  description='Opreste sangerarea.' }
BZ.Items['firstaid']       = { name='firstaid',       label='Trusa Prim Ajutor', weight=500,   usable=true,  stackable=false, description='Recupereaza viata.' }
BZ.Items['morphine']       = { name='morphine',       label='Morfina',           weight=50,    usable=true,  stackable=true,  description='Calmeaza durerea. (Ambulanta)' }
BZ.Items['defib']          = { name='defib',          label='Defibrilator',      weight=2000,  usable=true,  stackable=false, description='Resusciteaza un jucator.' }
BZ.Items['splint']         = { name='splint',         label='Atela',             weight=300,   usable=true,  stackable=true,  description='Stabilizeaza fractura.' }

-- POLITIE
BZ.Items['handcuffs']      = { name='handcuffs',      label='Catuse',            weight=500,   usable=true,  stackable=false, description='Pentru infractori.' }
BZ.Items['radio']          = { name='radio',          label='Radio Politie',     weight=400,   usable=true,  stackable=false, description='Comunicare interna.' }
BZ.Items['taser']          = { name='taser',          label='Taser',             weight=600,   usable=true,  stackable=false, description='Imobilizeaza tinta.' }
BZ.Items['ticket']         = { name='ticket',         label='Amenda',            weight=10,    usable=false, stackable=true,  description='Amenda de circulatie.' }
BZ.Items['evidence_bag']   = { name='evidence_bag',   label='Punga Probe',       weight=100,   usable=false, stackable=true,  description='Stocheaza probe.' }

-- MECANIC
BZ.Items['wrench']         = { name='wrench',         label='Cheie Franceza',    weight=1000,  usable=true,  stackable=false, description='Repara vehicule.' }
BZ.Items['repair_kit']     = { name='repair_kit',     label='Kit Reparatie',     weight=2000,  usable=true,  stackable=false, description='Repara complet vehiculul.' }
BZ.Items['engine_oil']     = { name='engine_oil',     label='Ulei Motor',        weight=1500,  usable=true,  stackable=false, description='Schimba uleiul.' }
BZ.Items['tire_kit']       = { name='tire_kit',       label='Kit Anvelope',      weight=3000,  usable=true,  stackable=false, description='Repara anvelopele.' }
BZ.Items['fuel_can']       = { name='fuel_can',       label='Bidon Combustibil', weight=4000,  usable=true,  stackable=false, description='5L benzina.' }

-- DROGURI
BZ.Items['weed']           = { name='weed',           label='Iarba',             weight=30,    usable=true,  stackable=true,  description='...',  illegal=true }
BZ.Items['weed_seed']      = { name='weed_seed',      label='Samanta Iarba',     weight=10,    usable=false, stackable=true,  description='Planteaza.',  illegal=true }
BZ.Items['cocaine']        = { name='cocaine',        label='Cocaina',           weight=50,    usable=true,  stackable=true,  description='...',  illegal=true }
BZ.Items['cocaine_bag']    = { name='cocaine_bag',    label='Punga Cocaina',     weight=100,   usable=false, stackable=true,  description='...',  illegal=true }
BZ.Items['meth']           = { name='meth',           label='Meth',              weight=40,    usable=true,  stackable=true,  description='...',  illegal=true }
BZ.Items['meth_ingredient']= { name='meth_ingredient',label='Ingrediente Meth',  weight=200,   usable=false, stackable=true,  description='...',  illegal=true }

-- CRAFTING MATERIALE
BZ.Items['iron_ore']       = { name='iron_ore',       label='Minereu Fier',      weight=2000,  usable=false, stackable=true,  description='Materie prima.' }
BZ.Items['iron_bar']       = { name='iron_bar',       label='Bara Fier',         weight=3000,  usable=false, stackable=true,  description='Fier prelucrat.' }
BZ.Items['copper_ore']     = { name='copper_ore',     label='Minereu Cupru',     weight=1500,  usable=false, stackable=true,  description='Materie prima.' }
BZ.Items['copper_wire']    = { name='copper_wire',    label='Sarma Cupru',       weight=200,   usable=false, stackable=true,  description='Conductor electric.' }
BZ.Items['plastic']        = { name='plastic',        label='Plastic',           weight=100,   usable=false, stackable=true,  description='Material plastic.' }
BZ.Items['spring']         = { name='spring',         label='Arc',               weight=100,   usable=false, stackable=true,  description='Component mecanic.' }
BZ.Items['steel']          = { name='steel',          label='Otel',              weight=3500,  usable=false, stackable=true,  description='Otel de calitate.' }
BZ.Items['cloth']          = { name='cloth',          label='Panza',             weight=300,   usable=false, stackable=true,  description='Material textil.' }
BZ.Items['electronics']    = { name='electronics',    label='Componente Electr.',weight=500,   usable=false, stackable=true,  description='Electronice.' }
BZ.Items['glass']          = { name='glass',          label='Sticla',            weight=800,   usable=false, stackable=true,  description='Sticla rezistenta.' }

-- ARME (crafting)
BZ.Items['pistol_parts']   = { name='pistol_parts',   label='Piese Pistol',      weight=800,   usable=false, stackable=true,  description='Piesele unui pistol.',  illegal=true }
BZ.Items['ammo_9mm']       = { name='ammo_9mm',       label='Munitie 9mm',       weight=30,    usable=false, stackable=true,  description='20 gloante 9mm.',  illegal=true }
BZ.Items['ammo_rifle']     = { name='ammo_rifle',     label='Munitie Pusca',     weight=50,    usable=false, stackable=true,  description='20 gloante pusca.',  illegal=true }
BZ.Items['gunpowder']      = { name='gunpowder',      label='Praf de Pusca',     weight=200,   usable=false, stackable=true,  description='Exploziv.',  illegal=true }

-- DIVERSE
BZ.Items['lockpick']       = { name='lockpick',       label='Spargator',         weight=100,   usable=true,  stackable=true,  description='Sparge incuietori.',  illegal=true }
BZ.Items['phone']          = { name='phone',          label='Telefon',           weight=200,   usable=true,  stackable=false, description='iPhone 13.' }
BZ.Items['id_card']        = { name='id_card',        label='Buletin',           weight=50,    usable=true,  stackable=false, description='Cartea ta de identitate.' }
BZ.Items['drivers_license']= { name='drivers_license',label='Permis Auto',       weight=30,    usable=true,  stackable=false, description='Dreptul de a conduce.' }
BZ.Items['screwdriver']    = { name='screwdriver',    label='Surubelnita',       weight=300,   usable=true,  stackable=false, description='Util pentru reparatii.' }
BZ.Items['lighter']        = { name='lighter',        label='Bricheta',          weight=50,    usable=true,  stackable=false, description='Foc.' }
BZ.Items['rope']           = { name='rope',           label='Franghie',          weight=500,   usable=false, stackable=true,  description='Util in diverse situatii.' }
BZ.Items['garbage_bag']    = { name='garbage_bag',    label='Sac Gunoi',         weight=1000,  usable=false, stackable=true,  description='Pentru gunoi.' }
BZ.Items['package']        = { name='package',        label='Colet',             weight=2000,  usable=false, stackable=false, description='Un pachet sigilat.' }

-- HRANA AVANSATA
BZ.Items['pizza']          = { name='pizza',          label='Pizza',             weight=600,   usable=true,  stackable=true,  description='Delicioasa.' }
BZ.Items['burger']         = { name='burger',         label='Burger',            weight=400,   usable=true,  stackable=true,  description='Fast food.' }
BZ.Items['cola']           = { name='cola',           label='Cola',              weight=350,   usable=true,  stackable=true,  description='Racoritoare.' }
BZ.Items['beer']           = { name='beer',           label='Bere',              weight=500,   usable=true,  stackable=true,  description='Alcool.' }
