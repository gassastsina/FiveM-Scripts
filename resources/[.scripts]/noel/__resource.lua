resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937' 
 
this_is_a_map 'yes' 

client_scripts {
	'snowball.lua',
	'gift.lua'
}

server_scripts {
	'config.lua',
	'gift_s.lua'
}

ui_page('html/index.html')
files({
    'html/index.html',
    'html/sounds/christmas.ogg'
})