fx_version 'cerulean'
game 'gta5'
name 'bz_trucker'
description 'BZ Trucker Job'
version '1.0.0'
shared_scripts { '@bz_core/shared/config.lua', '@bz_core/shared/jobs.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { 'client/main.lua' }
lua54 'yes'
