resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

dependency 'essentialmode'

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/client.lua',
	'client/alarm.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/server.lua',
}


ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/sounds/burglarbell.ogg'
})