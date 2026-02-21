fx_version 'cerulean'
game 'gta5'

name 'bz_inventory'
description 'BZ Inventory System'
version '1.0.0'

shared_scripts { '@bz_core/shared/items.lua' }

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts { 'client/main.lua' }

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

lua54 'yes'
