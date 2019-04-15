------------------------------------
------------------------------------
----    File : main.lua    		----
----    Edited by : gassastsina ----
----    Side : server        	----
----    Description : Fishing 	----
------------------------------------
------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

RegisterServerEvent('esx_fishing:caughtFish')
AddEventHandler('esx_fishing:caughtFish', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
	--print(getPlayerWeight(xPlayer, 'fish') + xPlayer.getInventoryItem('fish').limit)
	--TriggerClientEvent('esx:showNotification', source, getPlayerWeight(xPlayer, 'fish') + xPlayer.getInventoryItem('fish').limit)
	if getPlayerWeight(xPlayer, 'fish') + xPlayer.getInventoryItem('fish').limit <= 10000 then
		xPlayer.addInventoryItem('fish', 1)
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas pécher plus de poissons')
	end
end)

TriggerEvent('esx_society:registerSociety', 'fisherman', 'Pêcheur', 'society_fisherman', 'society_fisherman', 'society_fisherman', {type = 'private'})
TriggerEvent('esx_society:registerSociety', 'fisherman2', 'Pêcheur', 'society_fisherman2', 'society_fisherman2', 'society_fisherman2', {type = 'private'})

ESX.RegisterUsableItem('fishing_rod', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('bait').count > 0 then
		TriggerClientEvent('esx_fishing:startFishing', source)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Tu n'as pas assez d'appats de poissons.")
	end
end)

ESX.RegisterUsableItem('gazbottle_plunge', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('gazbottle_plunge').count > 0 then
		TriggerClientEvent('esx_fishing:setGazBottle', source)
		ESX.GetPlayerFromId(source).removeInventoryItem('gazbottle_plunge', 1)
	end
end)

ESX.RegisterUsableItem('plunge_wear', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('plunge_wear').count > 0 then
		TriggerClientEvent('esx_fishing:setPlungeWear', source)
		ESX.GetPlayerFromId(source).removeInventoryItem('plunge_wear', 1)
	end
end)


RegisterServerEvent('esx_fishing:removeInventoryItem')
AddEventHandler('esx_fishing:removeInventoryItem', function(item, quantity)
	ESX.GetPlayerFromId(source).removeInventoryItem(item, quantity)
end)