fx_version 'cerulean'
game 'gta5'

name 'garaje'
description ' Garage UI - Interfață garaj cu imagini '
author 'JOKERNEBUN'
version '0.0.1'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@qbx_core/modules/lib.lua', -- necesar pentru qbx.spawnVehicle
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/images/vehicles/*.webp',
}

dependencies {
    'ox_lib',
    'qbx_core',
   
}
