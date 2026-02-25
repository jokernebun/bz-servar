fx_version 'cerulean'
game 'gta5'

name 'apex_tuning'
dependencies { 'oxmysql', 'qbx_core' }
description 'Apex Tuning - Meniu tuning vehicule'
version '1.0.0'
author 'Joker'

shared_scripts {
    'config.lua'
}
client_scripts {
    'client.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}
