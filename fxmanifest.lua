fx_version 'cerulean'
game 'gta5'

author 'notstomped'
description 'Phone Tracking Script'
version '1.0.0'

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.json',
  'server/main.lua'
}

shared_script '@es_extended/imports.lua'

client_scripts {
  '@es_extended/locale.lua',
  'config.json',
  'client/main.lua'
}
dependencies {
  'es_extended',
  'mysql-async'
}
