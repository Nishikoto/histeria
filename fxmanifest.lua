fx_version 'cerulean'
game 'gta5'

name 'Histeria'
description 'Ban System'
version '1.2.2'
author 'Nishikoto'
repository 'https://github.com/Nishikoto/histeria'
lua54 'yes'
license 'MIT'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'Common/config.lua',
}

client_scripts {
    'Client/menu.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'Server/triggers.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
}
