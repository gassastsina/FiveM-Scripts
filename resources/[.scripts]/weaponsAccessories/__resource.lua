--Get latest manifest version : https://wiki.fivem.net/wiki/Resource_manifest_versions
client_script {
	'client.lua',
	'config.lua'
}
server_script {
	'server.lua',
	'config.lua',
	'@mysql-async/lib/MySQL.lua'
}