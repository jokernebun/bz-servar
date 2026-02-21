fx_version 'cerulean'
game 'gta5'

name 'bz_core'
description 'BZ Framework - Core'
version '1.0.0'
author 'BZ Dev'

shared_scripts {
    'shared/config.lua',
    'shared/jobs.lua',
    'shared/items.lua',
    'shared/utils.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/player.lua',
    'server/commands.lua',
    'server/callbacks.lua',
}

client_scripts {
    'client/main.lua',
    'client/callbacks.lua',
}

lua54 'yes'
