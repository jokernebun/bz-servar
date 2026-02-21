fx_version 'cerulean'
game 'gta5'

name 'bz_banking'
description 'BZ Banking System'
version '1.0.0'

shared_scripts { '@bz_core/shared/config.lua' }

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
