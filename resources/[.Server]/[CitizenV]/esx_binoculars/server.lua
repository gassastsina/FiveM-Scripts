-------------------------------------
-------------------------------------
----    File : server.lua        ----
----    Author : gassastsina     ----
----    Side : server         	 ----
----    Description : Binoculars ----
-------------------------------------
-------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
ESX.RegisterUsableItem("binoculars", function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('binoculars').count > 0 then
		TriggerClientEvent('esx_binoculars:use', source)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas de jumelles sur vous")
	end
end)