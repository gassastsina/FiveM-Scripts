resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Identity'

version '1.1.0'

ui_page 'html/index.html'
files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/img/natif.png',
	'html/img/avion.png',
	'html/img/bateau.png',
	'html/img/cursor.png',
	'html/fonts/pricedown.ttf',
	'html/fonts/Nickainley.otf',
	'html/fonts/birds.ttf',
	'html/fonts/OrangeBlossoms.ttf'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'