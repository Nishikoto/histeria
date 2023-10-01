fx_version 'cerulean'
game 'gta5'

name 'Histeria'
description 'Sytem of Ban and Anti-Cheat'
version '1.0.0'
author 'Nishikoto'
repository 'https://github.com/Nishikoto/histeria'
lua54 'yes'
license 'MIT'

shared_scripts {
    '@ox_lib/init.lua',
    '@jClassLib/init.lua',
    '@jBlipLib/init.lua',
    'Common/config.lua',
}

client_scripts {
    'Client/menu.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'Server/triggers.lua',
    'Server/start.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
    'jClassLib',
    'jBlipLib'
}