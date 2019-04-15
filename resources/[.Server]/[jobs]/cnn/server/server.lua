---------------------------------
---------------------------------
----    File : server.lua    ----
----    Author : gassastsina ----
----    Side : server        ----
----    Description : CNN 	 ----
---------------------------------
---------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX 						   		= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
--Runs
local PlayersHarvesting = {}
local PlayersSelling 	= {}

local FoodItems = {}
AddEventHandler('esx:GetFoodItemsList', function(FoodItemsList)
	FoodItems = FoodItemsList
end)

TriggerEvent('esx_society:registerSociety', 'cnn', 'Journaliste', 'society_cnn', 'society_cnn', 'society_cnn', {type = 'private'})

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

local function Harvest(source)
	SetTimeout(5000, function()
		if PlayersHarvesting[source] then
			local xPlayer  = ESX.GetPlayerFromId(source)
			if getPlayerWeight(xPlayer, Config.Journaliste.ItemsNames.Newspaper) + xPlayer.getInventoryItem(Config.Journaliste.ItemsNames.Newspaper).limit <= 10000 then
				ESX.GetPlayerFromId(source).addInventoryItem(Config.Journaliste.ItemsNames.Newspaper, 1)
				Harvest(source)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas prendre plus de journaux sur vous')
			end
		end
	end)
end

RegisterServerEvent('cnn:startHarvestArticle')
AddEventHandler('cnn:startHarvestArticle', function()
	local _source = source
	PlayersHarvesting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('printing_in_prog'))
	Harvest(_source)
end)

RegisterServerEvent('cnn:stopHarvestArticle')
AddEventHandler('cnn:stopHarvestArticle', function()
	PlayersHarvesting[source] = false
end)

local function Sell(source)
	SetTimeout(3000, function()
		if PlayersSelling[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local newspaperQuantity = xPlayer.getInventoryItem(Config.Journaliste.ItemsNames.Newspaper).count

			if newspaperQuantity > 0 then
				xPlayer.removeInventoryItem(Config.Journaliste.ItemsNames.Newspaper, 1)
		        xPlayer.addMoney(Config.SellWorker)
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cnn', function(account)
					account.addMoney(Config.SellCompany)
				end)
		        TriggerClientEvent('esx:showNotification', source, _U('sold_newspaper'))
				Sell(source)
			else
				TriggerClientEvent('esx:showNotification', source, _U('no_newspaper_sale'))
			end
		end
	end)
end

RegisterServerEvent('cnn:startSellNewspaper')
AddEventHandler('cnn:startSellNewspaper', function()
	local _source = source
	PlayersSelling[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
	Sell(_source)
end)

RegisterServerEvent('cnn:stopSellNewspaper')
AddEventHandler('cnn:stopSellNewspaper', function()
	local _source = source
	PlayersSelling[_source] = false
end)

RegisterServerEvent('cnn:WeazelNews')
AddEventHandler('cnn:WeazelNews', function(msg)
	TriggerClientEvent('cnn:WeazelNewsStart', -1, msg)
	SetTimeout(Config.Journaliste.Message.Duration, function()
		TriggerClientEvent('cnn:WeazelNewsStop', -1)
	end)
end)