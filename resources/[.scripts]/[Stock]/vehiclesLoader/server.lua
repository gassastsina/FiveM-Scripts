-----------------------------------------
-----------------------------------------
----    File : server.lua       	 ----
----    Author: gassastsina     	 ----
----	Side : server 		 		 ----
----    Description : Vehicle loader ----
-----------------------------------------
-----------------------------------------

RegisterServerEvent('vehiclesLoader:getVehicles')
AddEventHandler('vehiclesLoader:getVehicles', function()
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM `owned_vehicles` WHERE `identifier`=@identifier", {['@identifier'] = GetPlayerIdentifiers(_source)[1]}, function(result)
		for i=1, result, 1 do
			table.insert(vehicles, result[i].vehicle.model)
		end
	end)
	TriggerClientEvent('vehiclesLoader:loadVehicles', source, vehicles)
end)