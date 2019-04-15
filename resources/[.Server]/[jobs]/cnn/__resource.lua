--Get latest manifest version : https://wiki.fivem.net/wiki/Resource_manifest_versions
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script {
    '@es_extended/locale.lua',
    'locales/fr.lua',
    'config.lua',
	'client/client.lua',
	'client/WeazelNews.lua'
}
server_script {
    '@es_extended/locale.lua',
    'locales/fr.lua',
    'config.lua',
	'server/server.lua'
}

--This part is from InteractSound by Scott
-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/intro.ogg'
})
