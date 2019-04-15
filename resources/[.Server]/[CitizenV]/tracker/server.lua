-----------------------------------
-----------------------------------
----    File : server.lua      ----
----    Author : gassastsina   ----
----    Side : server          ----
----    Description : Trackers ----
-----------------------------------
-----------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
ESX.RegisterUsableItem('tracker', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('tracker').count > 0 then
		TriggerClientEvent('tracker:setTarget', source)
	end
end)

ESX.RegisterUsableItem('hack_phone', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('hack_phone').count > 0 then
		TriggerClientEvent('mtracker:start', source)
	end
end)

RegisterServerEvent('tracker:removeTracker')
AddEventHandler('tracker:removeTracker', function()
	ESX.GetPlayerFromId(source).removeInventoryItem('tracker', 1)
end)