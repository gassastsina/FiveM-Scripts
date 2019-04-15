--------------------------------------
--------------------------------------
----    File : server.lua      	  ----
----    Author: gassastsina       ----
----	Side : server 			  ----
----    Description : Informateur ----
--------------------------------------
--------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
local wichPNJ = nil
ESX.RegisterServerCallback('informant:getPNJ', function(source, cb, n)
	if wichPNJ == nil then
		wichPNJ = n
	end
	cb(wichPNJ)
end)

ESX.RegisterServerCallback('informant:getWichDrugPoint', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source).getIdentifier()
	MySQL.Async.fetchAll("SELECT * FROM `user_points` WHERE `identifier`=@identifier", {['@identifier'] = xPlayer},
		function(result)
			if result[1] ~= nil then
				if result[1].point <= #Config.Points['drug'] then
					cb(result[1].point)
				else
					TriggerClientEvent('esx:showNotification', _source, 'Tu as déjà toute les informations que je connais')
					cb(result[1].point)
				end
			else
				cb(1)
			end
		end
	)
end)

RegisterServerEvent('informant:buyDrug')
AddEventHandler('informant:buyDrug', function(point)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source).getIdentifier()
	MySQL.Async.fetchAll("SELECT * FROM `user_points` WHERE `identifier`=@identifier", {['@identifier'] = xPlayer},
		function(result)
			if result[1] ~= nil then
				if result[1].point <= #Config.Points['drug'] then
					if result[1].point == point then
						MySQL.Sync.execute("UPDATE user_points SET point=@point WHERE identifier=@identifier", {
							['@identifier'] = xPlayer,
							['@point'] = result[1].point + 1
					    })
					end
				end
			else
				MySQL.Async.execute('INSERT INTO user_points (identifier, point) VALUES (@identifier, @point)', {
				  ['@identifier']  = xPlayer,
				  ['@point'] = 2
				},
				function(rowsChanged)
					if cb ~= nil then cb() end
				end)
			end
		end
	)
end)

ESX.RegisterServerCallback('informant:getPlayerMoney', function(source, cb)
	cb(ESX.GetPlayerFromId(source).getMoney())
end)

RegisterServerEvent('informant:buyInformation')
AddEventHandler('informant:buyInformation', function(price)
	ESX.GetPlayerFromId(source).removeMoney(price)
end)


RegisterServerEvent('informant:reward')
AddEventHandler('informant:reward', function(price)
	ESX.GetPlayerFromId(source).addAccountMoney('black_money', price)
end)


--Receiver
local alreadyReceive = {}
ESX.RegisterServerCallback('informant:receiverCheckAlreadyRun', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source).getIdentifier()
	for i=0, #alreadyReceive, 1 do
		if xPlayer == alreadyReceive[i] then
			TriggerClientEvent('esx:showNotification', source, "Tu m'as déjà ramené un véhicule pour aujourd'hui, n'en abuse pas mon petit, reviens demain")
			break
		elseif i == #alreadyReceive then
			table.insert(alreadyReceive, xPlayer)
			local random = math.random(1, #Config.Points['receiver'].vehicles)
			cb(Config.Points['receiver'].vehicles[random])
			break
		end
	end
end)

local runningReceiver = {}
RegisterServerEvent('informant:stockReceiverRun')
AddEventHandler('informant:stockReceiverRun', function(vehicle, destination)
	table.insert(runningReceiver, {player = ESX.GetPlayerFromId(source).getIdentifier(), vehicle = vehicle, destination = destination})
end)

ESX.RegisterServerCallback('informant:getIsPlayerRunningReceive', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source).getIdentifier()
	for i=1, #runningReceiver, 1 do
		if runningReceiver[i].player == xPlayer then
			cb(runningReceiver[i].vehicle, runningReceiver[i].destination)
		elseif i == #runningReceiver then
			cb(nil, nil)
		end
	end
end)

RegisterServerEvent('informant:removeReceiveRunningAndreward')
AddEventHandler('informant:removeReceiveRunningAndreward', function(price, plate)
	local _source = source
	TriggerEvent('logs:write', 'Vient de livrer au receleur un véhicule ('..plate..') pour '..tostring(price)..'$', _source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney('black_money', price)
	local identifier = xPlayer.getIdentifier()
	for i=1, #runningReceiver, 1 do
		if runningReceiver[i].player == identifier then
			table.remove(runningReceiver, i)
		end
	end
	MySQL.Async.fetchAll('SELECT * FROM `user_parkings` WHERE `plate`=@plate', {
			['@plate']	= plate
		}, function(vehicleProperties)
 			if json.decode(vehicleProperties[1].vehicle).plate == plate then
 				MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE vehicle=@vehicle', {
					['@vehicle'] = vehicleProperties[1].vehicle
				}, function(result)
	 				TriggerEvent('logs:write', "<@&464073491952697344> Vient de vendre son véhicule personnel au receleur "..tostring(result[1].vehicle), _source)
					MySQL.Async.execute('DELETE FROM `owned_vehicles` WHERE `vehicle`=@vehicle LIMIT 1', {
				        ['@vehicle'] = result[1].vehicle
				    })
					MySQL.Async.execute('DELETE FROM `user_parkings` WHERE `plate`=@plate LIMIT 1', {
				        ['@plate'] = plate
				    })
				end)
 			elseif vehicleProperties == nil then
 				print("informant : Le véhicule n'appartient pas à "..GetPlayerName(player))
 			end
 		end
 	)
end)

RegisterServerEvent('informant:addInventoryItem')
AddEventHandler('informant:addInventoryItem', function(item, count)
	ESX.GetPlayerFromId(source).addInventoryItem(item, count)
end)

ESX.RegisterServerCallback('informant:getCopsNumber', function(source, cb, item)
	local cops = 0
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
    cb(cops)
end)