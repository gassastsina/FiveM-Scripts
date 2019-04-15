-- Client Base Scripts

server_script '@mysql-async/lib/MySQL.lua'
server_script 'coffee_s.lua'
client_script 'pointing.lua'
client_script 'neverwanted.lua'
client_script 'surrender.lua'
client_script 'stamina.lua'
client_script 'ragdoll.lua'
client_script 'coffee.lua'
client_script 'emotemenu.lua'
client_script 'bagmoney.lua'
server_script 'bagmoney_sv.lua'
client_script 'ko_client.lua'
client_script 'rpname_c.lua'
server_script 'rpname_s.lua'
client_script 'crouch.lua'
client_script 'pnj.lua'
client_script 'paycheck.lua'


ui_page('html/index.html')

files({
    'html/index.html',
    'html/sounds/on.ogg',
    'html/sounds/off.ogg'
})