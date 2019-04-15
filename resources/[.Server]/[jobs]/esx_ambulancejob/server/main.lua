------------------------------------
------------------------------------
----    File : main.lua    		----
----    Edited by : gassastsina ----
----    Side : server        	----
----    Description : EMS 	 	----
------------------------------------
------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.addMoney(Config.ReviveReward)
	TriggerClientEvent('esx_ambulancejob:revive', target)
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
  TriggerClientEvent('esx_ambulancejob:heal', target, type)
end)

--TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				if not xPlayer.inventory[i].rare then
					xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
				end
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	if Config.RespawnFine then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_fine', Config.RespawnFineAmount))
		xPlayer.removeAccountMoney('bank', Config.RespawnFineAmount)
	end

	cb()
end)

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	cb(ESX.GetPlayerFromId(source).getInventoryItem(item).count)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.removeInventoryItem(item, 1)
  if item == 'bandage' then
    TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
  elseif item == 'medikit' then
    TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
  end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local limit = xPlayer.getInventoryItem(item).limit
  local delta = 1
  local qtty = xPlayer.getInventoryItem(item).count
  if limit ~= -1 then
    delta = limit - qtty
  end
  if qtty < limit then
    xPlayer.addInventoryItem(item, delta)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
  end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'admin', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print('esx_ambulancejob: ' .. GetPlayerName(source) .. ' is reviving '..GetPlayerName(tonumber(args[1])))
			TriggerEvent('logs:write', "Revive "..GetPlayerName(tonumber(args[1])), source)
			TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]))
		end
	else
		TriggerEvent('logs:write', "Se revive", source)
		TriggerClientEvent('esx_ambulancejob:revive', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = _U('revive_help'), params = {{name = 'id'}}})

ESX.RegisterUsableItem('medikit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ambulance' or EMSNumberChecker() <= 0 then
		xPlayer.removeInventoryItem('medikit', 1)
		TriggerClientEvent('esx_ambulancejob:useKit', _source, 'big')
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	else
		TriggerClientEvent('esx:showNotification', _source, 'Une EMS est en ville, appelez la !')
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ambulance' or EMSNumberChecker() <= 0 then
		xPlayer.removeInventoryItem('bandage', 1)
		TriggerClientEvent('esx_ambulancejob:useKit', _source, 'small')
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	else
		TriggerClientEvent('esx:showNotification', _source, 'Une EMS est en ville, appelez la !')
	end
end)

function EMSNumberChecker()
	local ems = 0
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		if ESX.GetPlayerFromId(xPlayers[i]).job.name == 'ambulance' then
			ems = ems + 1
		end
	end
	return ems
end

RegisterServerEvent('esx_ambulancejob:firstSpawn')
AddEventHandler('esx_ambulancejob:firstSpawn', function()
	local _source    = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchScalar('SELECT isDead FROM users WHERE identifier=@identifier',
	{
		['@identifier'] = identifier
	}, function(isDead)
		if isDead == 1 then
			print('esx_ambulancejob: ' .. GetPlayerName(_source) .. ' (' .. identifier .. ') attempted combat logging!')
			TriggerClientEvent('esx_ambulancejob:requestDeath', _source)
		end
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local _source = source
	MySQL.Sync.execute("UPDATE users SET isDead=@isDead WHERE identifier=@identifier",
	{
		['@identifier'] = GetPlayerIdentifiers(_source)[1],
		['@isDead'] = isDead
	})
end)



--------------------------------------------Run----------------------------------------------------------
local PlayersHarvestingString = {}
local PlayersHarvestingProduct = {}
local PlayersTreatmentString 	= {}
local PlayersTreatmentProduct 	= {}

local FoodItems = {}
AddEventHandler('esx:GetFoodItemsList', function(FoodItemsList)
	FoodItems = FoodItemsList
end)

local function IsFoodItem(item)
	for i=1, #FoodItems, 1 do
		if FoodItems[i] == item then
			return true
		end
	end
	return false
end

local function getPlayerWeight(xPlayer, item)
	local totalWeight = 0
	local totalFoodWeight = 0
	--Player inventory weight
	for i=1, #xPlayer.inventory, 1 do
		if xPlayer.inventory[i].count > 0 then
			if not IsFoodItem(xPlayer.inventory[i].name) then
		  		totalWeight = totalWeight + xPlayer.inventory[i].limit*xPlayer.inventory[i].count
		  	else
		  		totalFoodWeight = totalFoodWeight + xPlayer.inventory[i].limit*xPlayer.inventory[i].count
		  	end
		end
	end
	if IsFoodItem(item) then
		return totalFoodWeight
	end
	return totalWeight
end

local function HarvestString(source)
	SetTimeout(8000, function()
		if PlayersHarvestingString[source] then
			local xPlayer  = ESX.GetPlayerFromId(source)
			if getPlayerWeight(xPlayer, 'whool') + xPlayer.getInventoryItem('whool').limit <= 10000 then
				ESX.GetPlayerFromId(source).addInventoryItem('whool', 1)
				HarvestString(source)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas en prendre plus sur vous')
			end
		end
	end)
end

RegisterServerEvent('esx_ambulancejob:startHarvestString')
AddEventHandler('esx_ambulancejob:startHarvestString', function()
	stopHarvestString()
	PlayersHarvestingString[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Récolte de Nylon~s~ en cours...')
	HarvestString(source)
end)

function stopHarvestString()
	PlayersHarvestingString[source] = false
end



local function HarvestProduct(source)
	SetTimeout(8000, function()
		if PlayersHarvestingProduct[source] then
			local xPlayer  = ESX.GetPlayerFromId(source)
			if getPlayerWeight(xPlayer, 'product') + xPlayer.getInventoryItem('product').limit <= 10000 then
				ESX.GetPlayerFromId(source).addInventoryItem('product', 1)
				HarvestProduct(source)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas en prendre plus sur vous')
			end
		end
	end)
end

RegisterServerEvent('esx_ambulancejob:startHarvestProduct')
AddEventHandler('esx_ambulancejob:startHarvestProduct', function()
	stopHarvestProduct()
	PlayersHarvestingProduct[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Récolte de Produits~s~ en cours...')
	HarvestProduct(source)
end)

function stopHarvestProduct()
	PlayersHarvestingProduct[source] = false
end



local function TreatmentString(source)
	SetTimeout(8000, function()
		if PlayersTreatmentString[source] then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local StringQuantity = xPlayer.getInventoryItem('whool').count

			if StringQuantity > 0 then
				if getPlayerWeight(xPlayer, 'fabric_medic') + xPlayer.getInventoryItem('fabric_medic').limit - xPlayer.getInventoryItem('whool').limit <= 10000 then
					xPlayer.removeInventoryItem('whool', 1)
					xPlayer.addInventoryItem('fabric_medic', 1)
					TreatmentString(source)
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas en prendre plus sur vous')
				end
			else
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de Nylon pour traiter")
			end
		end
	end)
end

RegisterServerEvent('esx_ambulancejob:startTreatmentString')
AddEventHandler('esx_ambulancejob:startTreatmentString', function()
	stopTreatmentString()
	PlayersTreatmentString[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Traitement de Tissus~s~ en cours...')
	TreatmentString(source)
end)

function stopTreatmentString()
	PlayersTreatmentString[source] = false
end



local function TreatmentProduct(source, data)
	SetTimeout(10000, function()
		if PlayersTreatmentProduct[source] then

			if data.value == 'bandage' then
				TreatmentProductSelectedItem(2, 4, data, source)
			elseif data.value == 'medikit' then
				TreatmentProductSelectedItem(4, 4, data, source)
			end
		end
	end)
end

function TreatmentProductSelectedItem(minProduct, minString, data, source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local ProductQuantity = xPlayer.getInventoryItem('product').count
	local StringQuantity = xPlayer.getInventoryItem('fabric_medic').count

	if ProductQuantity >= minProduct and StringQuantity >= minString then
		if getPlayerWeight(xPlayer, data.value) + xPlayer.getInventoryItem(data.value).limit - xPlayer.getInventoryItem('fabric_medic').limit*minString - xPlayer.getInventoryItem('product').limit*minProduct <= 10000 then
			xPlayer.removeInventoryItem('fabric_medic', minString)
			xPlayer.removeInventoryItem('product', minProduct)
			xPlayer.addInventoryItem(data.value, 2)
	        TriggerClientEvent('esx:showNotification', source, 'Vous avez traité ~g~un '..data.label..'~s~')
			TreatmentProduct(source, data)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas en prendre plus sur vous')
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de Tissus ou de Produit pour traiter")
	end
end

RegisterServerEvent('esx_ambulancejob:startTreatmentProduct')
AddEventHandler('esx_ambulancejob:startTreatmentProduct', function(data)
	stopTreatmentProduct()
	PlayersTreatmentProduct[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Traitement de '..data.label..'~s~ en cours...')
	TreatmentProduct(source, data)
end)

function stopTreatmentProduct()
	PlayersTreatmentProduct[source] = false
end


RegisterServerEvent('esx_ambulancejob:stopFarming')
AddEventHandler('esx_ambulancejob:stopFarming', function()
	stopHarvestString()
	stopHarvestProduct()
	stopTreatmentString()
	stopTreatmentProduct()
	Wait(500)
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
  TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
end)