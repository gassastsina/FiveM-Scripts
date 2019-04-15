ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local xPlayer = nil
RegisterServerEvent("rpname")
AddEventHandler("rpname", function(name)
	 xPlayer = ESX.GetPlayerFromId(source)
 	 local name = name
   			MySQL.Async.execute(
				'UPDATE `users` SET `name` = @name WHERE `identifier` = @identifier',
				{
					['@identifier'] = xPlayer.identifier,
					['@name']       = name
				},
				function()
				
				end
			)
end)

