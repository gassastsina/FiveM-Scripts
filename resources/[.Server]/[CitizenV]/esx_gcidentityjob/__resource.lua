-- resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',

	'html/img/card_police_0.png',
	'html/img/card_police_1.png',
	'html/img/card_police_2.png',
	'html/img/card_police_3.png',
	'html/img/card_police_4.png',
	'html/img/card_police_5.png',
	'html/img/card_police_6.png',
	'html/img/card_police_7.png',

	'html/img/card_ambulance.png',
	'html/img/card_interim.png',
	'html/img/card_reporter.png',
	'html/img/card_slaughterer.png',
	'html/img/card_mecano.png',
	'html/img/card_sap.png',
	'html/img/card_rad.png',

	'html/img/card_fisherman_0.png',
	'html/img/card_fisherman_1.png',
	'html/img/card_fisherman_2.png',
	'html/img/card_fisherman_3.png',

	'html/img/card_lospolloshermanos_0.png',
	'html/img/card_lospolloshermanos_1.png',
	'html/img/card_lospolloshermanos_2.png',

	'html/img/cursor.png',
	'html/fonts/NeueHaasGroteskTextProBold.woff'
}

client_script {
	"client.lua"
}


server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}

