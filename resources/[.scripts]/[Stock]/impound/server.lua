------------------------------------
------------------------------------
----    File : server.lua       ----
----    Author: gassastsina     ----
----	Side : server 		 	----
----    Description : Fourrière ----
------------------------------------
------------------------------------

ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('impound:getVehicles', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local MenuList = {}
	MySQL.Async.fetchAll('SELECT * FROM `impound` WHERE identifier=@identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(vehicles)
 			for i=1, #vehicles, 1 do
 				table.insert(MenuList, {decode = json.decode(vehicles[i].vehicle), encode = vehicles[i].vehicle})
 			end
 			cb(MenuList)
 		end
 	)
end)

RegisterServerEvent('impound:removeVehicle')
AddEventHandler('impound:removeVehicle', function(vehicle, vehiclesPrice)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('DELETE FROM impound WHERE `identifier`=@identifier AND `vehicle`=@vehicle', {
        ['@identifier'] = xPlayer.identifier,
        ['@vehicle']	= vehicle
    })
    for i=1, #vehiclesPrice, 1 do
		if vehiclesPrice[i].model == json.decode(vehicle.model) then
		    xPlayer.removeMoney(vehiclesPrice[i].price*0.8/100)
		    break
		end
	end
end)