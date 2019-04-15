resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Police Job'

version '1.0.5'

server_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua',
  'server/tracker.lua',
  'server/circulation.lua',
  'server/bracelets.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'client/main.lua',
  'client/tracker.lua',
  'client/circulation.lua',
  'client/extras.lua',
  'client/bracelets.lua'
}
