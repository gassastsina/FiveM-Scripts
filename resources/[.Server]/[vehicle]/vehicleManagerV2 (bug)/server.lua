-----------------------------------------------------
-----------------------------------------------------
----    File : server.lua				  		 ----
----    Author: gassastsina               		 ----
----	Side : server 							 ----
----    Description : Synchronise les moteurs V2 ----
-----------------------------------------------------
-----------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
local vehicles = {}
ESX.RegisterServerCallback('vehicleManager:getEngines', function(source, cb, plate, engine)
	for i=0, #vehicles, 1 do
		if vehicles[i] ~= nil and vehicles[i].plate == plate then
			vehicles[i].engine = not vehicles[i].engine
			sendToClient(source)
			cb(not vehicles[i].engine, vehicles)
			break
		elseif i == #vehicles then
			table.insert(vehicles, {plate = plate, engine = not engine})
			sendToClient(source)
			cb(not engine, vehicles)
			break
		end
	end
end)

function sendToClient(_source)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		if xPlayers[i] ~= _source then
			TriggerClientEvent('vehicleManager:updateEngines', xPlayers[i], vehicles)
		end
	end
end

RegisterServerEvent('vehicleManager:addNewVehicle')
AddEventHandler('vehicleManager:addNewVehicle', function(plate)
	table.insert(vehicles, {plate = plate, engine = true})
	TriggerClientEvent('vehicleManager:updateEngines', -1, vehicles)
end)

ESX.RegisterUsableItem('carstarter_kit', function(source)
	TriggerClientEvent('vehicleManager:startVehicleByKit', source)
end)

RegisterServerEvent('vehicleManager:removeItem')
AddEventHandler('vehicleManager:removeItem', function(item)
	ESX.GetPlayerFromId(source).removeInventoryItem(item, 1)
end)


TriggerEvent('es:addGroupCommand', 'givekey', 'admin', function(source, args, user)

  TriggerClientEvent('vehicleManager:getVehiclesKey', source)

end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Permissions insuffisantes")
end)