--------------------------------
--------------------------------
----    File : client.lua   ----
----    Author: gassastsina	----
----	Side : client 		----
----    Description : Logs 	----
--------------------------------
--------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	TriggerServerEvent('logs:write', "Connected and Loaded")
end)