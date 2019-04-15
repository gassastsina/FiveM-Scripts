-------------------------------------------------------------------------
--							By Vakeros								   --
--							#Version 1.00			   				   --
--							#lastEdit 01/09/17					       -- 
-------------------------------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("esx:givekey")
AddEventHandler("esx:givekey", function(closestPlayer, key)
	--print(closestPlayer)
	--print(key)
	TriggerClientEvent('esx:returnkey', closestPlayer, key)
end)
