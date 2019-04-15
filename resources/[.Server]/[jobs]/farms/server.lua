-------------------------------------------------
-------------------------------------------------
----    File : server.lua                    ----
----    Author : gassastsina                 ----
----	Side : server 						 ----
----    Description : Automatisation du farm ----
-------------------------------------------------
-------------------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
local PlayersHarvesting = {}
local PlayersTreatment 	= {}
local PlayersSelling	= {}

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

local function Harvest(_source, item, count, time)
	local xPlayer  = ESX.GetPlayerFromId(_source)
	SetTimeout(time, function()
		if PlayersHarvesting[_source] then
			if getPlayerWeight(xPlayer, item) + xPlayer.getInventoryItem(item).limit*count <= 10000 then
				xPlayer.addInventoryItem(item, count)
				Harvest(_source, item, count, time)
			else
				TriggerEvent('farms:stop', _source)
				TriggerClientEvent('esx:showNotification', _source, '~r~Vous ne pouvez pas en prendre plus sur vous')
			end
		end
	end)
end

RegisterServerEvent('farms:Harvest')
AddEventHandler('farms:Harvest', function(item, count, time)
	local _source = source
	TriggerEvent('farms:stop', _source)
	Wait(100)
	if not PlayersHarvesting[_source] then
		TriggerClientEvent('esx:showNotification', _source, '~y~Récolte de '..ESX.GetPlayerFromId(_source).getInventoryItem(item).label..'~s~ en cours...')
		Wait(1000)
		PlayersHarvesting[_source] = true
		Harvest(_source, item, count, time)
	else
		TriggerClientEvent('esx:showNotification', _source, "Tu viens d'arrêter de récolter")
	end
end)


local function Treatment(_source, fromItem, fromCount, toItem, toCount, time)
	SetTimeout(time, function()
		if PlayersTreatment[_source] == true then

			local xPlayer  = ESX.GetPlayerFromId(_source)
			local inventoryToItemStats = xPlayer.getInventoryItem(toItem)
			if xPlayer.getInventoryItem(fromItem).count >= fromCount then
				if getPlayerWeight(xPlayer, toItem) + inventoryToItemStats.limit*toCount - xPlayer.getInventoryItem(fromItem).limit*fromCount <= 10000 then
					xPlayer.removeInventoryItem(fromItem, fromCount)
					xPlayer.addInventoryItem(toItem, toCount)
					Treatment(_source, fromItem, fromCount, toItem, toCount, time)
				else
					TriggerEvent('farms:stop', _source)
					TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez plus de place sur vous")
				end
			else
				TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez de "..xPlayer.getInventoryItem(fromItem).label)
			end
		end
	end)
end

RegisterServerEvent('farms:Treatment')
AddEventHandler('farms:Treatment', function(fromItem, fromCount, toItem, toCount, time)
	local _source = source
	TriggerEvent('farms:stop', _source)
	Wait(100)
	if not PlayersTreatment[_source] then
		TriggerClientEvent('esx:showNotification', _source, '~y~Traitement~s~ en cours...')
		Wait(1000)
		PlayersTreatment[_source] = true
		Treatment(_source, fromItem, fromCount, toItem, toCount, time)
	else
		TriggerClientEvent('esx:showNotification', _source, "Tu viens d'arrêter de traiter")
	end
end)

local function Sell(_source, item, count, playerPrice, societyPrice, society, time)
	SetTimeout(time, function()
		if PlayersSelling[_source] then
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer.getInventoryItem(item).count > 0 then
				xPlayer.removeInventoryItem(item, count)
		        xPlayer.addMoney(playerPrice)
		        if societyPrice ~= nil and society ~= nil then
					TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
						account.addMoney(societyPrice)
					end)
		        end
				Sell(_source, item, count, playerPrice, societyPrice, society, time)
			else
				TriggerEvent('farms:stop', _source)
				TriggerClientEvent('esx:showNotification', _source, "Vous n'en avez pas assez pour vendre")
			end
		end
	end)
end

RegisterServerEvent('farms:Sell')
AddEventHandler('farms:Sell', function(item, count, playerPrice, societyPrice, society, time)
	local _source = source
	TriggerEvent('farms:stop', _source)
	Wait(100)
	if not PlayersTreatment[_source] then
		TriggerClientEvent('esx:showNotification', _source, '~y~Vente~s~ en cours...')
		PlayersSelling[_source] = true
		Wait(1000)
		Sell(_source, item, count, playerPrice, societyPrice, society, time)
	else
		TriggerClientEvent('esx:showNotification', _source, "Tu viens d'arrêter de vendre")
	end
end)


RegisterServerEvent('farms:stop')
AddEventHandler('farms:stop', function(player)
	PlayersHarvesting[player or source] = false
	PlayersTreatment[player or source]  = false
	PlayersSelling[player or source]	= false
end)