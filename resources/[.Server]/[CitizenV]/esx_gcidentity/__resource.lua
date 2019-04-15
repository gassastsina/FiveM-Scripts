--Get latest manifest_version : https://docs.fivem.net/scripting-reference/resource-manifest/resource-manifest/
-- resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-----------------------------------------
-----------------------------------------
----    File : client.lua       	 ----
----    Author : Jonathan D @ Gannon ----
----    Edited 1 by : Chubbs (ADRP)	 ----
----    Edited 2 by : gassastsina 	 ----
----    Side : client         		 ----
----    Description : Identity 		 ----
-----------------------------------------
-----------------------------------------

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/identity_card.png',
	'html/cursor.png'
}

client_script {
	"client.lua"
}


server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}

