-----------------------------------------------
-----------------------------------------------
----    File : server.lua       		   ----
----    Author : gassastsina    		   ----
----    Side : server         			   ----
----    Description : Pacific Bank hold up ----
-----------------------------------------------
-----------------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local FoodItems = {}
AddEventHandler('esx:GetFoodItemsList', function(FoodItemsList)
	FoodItems = FoodItemsList
end)

-----------------------------------------------main------------------------------------------------------
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

local function AlertPolice(message, blipBool)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('pacificholdup:AlertPolice', xPlayers[i], message, blipBool)
		end
	end
end

RegisterServerEvent('pacificholdup:getChestReward')
AddEventHandler('pacificholdup:getChestReward', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local type = ''
	if math.random(1, 20) == 1 then
		type = 'Rare'
	else
		type = 'Items'
	end
	local random = math.random(1, #Config.ChestRewards[type])
	local itemCount = math.random(Config.ChestRewards[type][random].min, Config.ChestRewards[type][random].max)
	if getPlayerWeight(xPlayer, Config.ChestRewards[type][random].name) + xPlayer.getInventoryItem(Config.ChestRewards[type][random].name).limit*itemCount <= 10000 then
		xPlayer.addInventoryItem(Config.ChestRewards[type][random].name, itemCount)
	else
		TriggerClientEvent('esx:showNotification', "~r~Tu n'as pas assez de place")
	end
	if math.random(1, 3) == 1 then
		xPlayer.removeInventoryItem('drill', 1)
		TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
		TriggerClientEvent('pNotify:SendNotification', source, {
	        text = "La perceuse a cassée",
	        type = "warning",
	        timeout = 3000,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	  	TriggerEvent('logs:write', "Vient de casser sa perceuse en perçant un coffre de la Pacific Bank", source)
	end
	local BlackMoney = math.random(Config.ChestRewards.BlackMoney['min'], Config.ChestRewards.BlackMoney['max'])
	xPlayer.addAccountMoney('black_money', BlackMoney)
	TriggerEvent('logs:write', "Vient de percer un coffre et vient de récupérer "..itemCount.." "..Config.ChestRewards.Items[random].name.." et "..BlackMoney.."$", source)
end)

local AlarmHacked 	= nil
local AlarmRinging 	= false
RegisterServerEvent('pacificholdup:notAvailable')
AddEventHandler('pacificholdup:notAvailable', function(chest)
	Config.DrillChests[chest].available = false
	TriggerClientEvent('pacificholdup:cantRobChest', -1, chest)
	if AlarmHacked == false or AlarmHacked == nil then
		if not AlarmRinging then
			TriggerClientEvent("alarm:PlayWithinDistance", -1, Config.Alarm.Distance, Config.Alarm.File, Config.DrillChests[chest])
		end
		AlertPolice("Braquage de banque", true)
		AlarmRinging = true
	end
end)

ESX.RegisterServerCallback('pacificholdup:GetItemQuantity', function(source, cb, item)
	cb(ESX.GetPlayerFromId(source).getInventoryItem(item).count)
end)

local ComputerPassword = ESX.GetRandomString(8)
ESX.RegisterServerCallback('pacificholdup:getComputerPassword', function(source, cb)
	cb(ComputerPassword)
end)

RegisterServerEvent('pacificholdup:removeHackPhone')
AddEventHandler('pacificholdup:removeHackPhone', function()
	ESX.GetPlayerFromId(source).removeInventoryItem('hack_phone', 1)
end)

ESX.RegisterServerCallback('pacificholdup:IsAlarmHacked', function(source, cb)
	cb(AlarmHacked)
end)

RegisterServerEvent('pacificholdup:AlarmHacked')
AddEventHandler('pacificholdup:AlarmHacked', function(success)
	ESX.GetPlayerFromId(source).removeInventoryItem('hack_phone', 1)
	AlarmHacked = success
	if success then
		Wait(Config.HackAlarmSuccess)
		AlertPolice("L'alarme a été désactivée", false)
	else
		Wait(Config.HackAlarmError)
		AlertPolice("L'alarme a subit un disfonctionnement", false)
	end
end)

ESX.RegisterServerCallback('pacificholdup:getCops', function(source, cb)
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

RegisterServerEvent('pacificholdup:startAlarm')
AddEventHandler('pacificholdup:startAlarm', function()
	if AlarmHacked == false or AlarmHacked == nil then
		if not AlarmRinging then
			TriggerClientEvent("alarm:PlayWithinDistance", -1, Config.Alarm.Distance, Config.Alarm.File, Config.EnterWithWeapon.Pos)
		end
		AlertPolice("Un Homme est armé", true)
		AlarmRinging = true
	end
end)

local IsSetDoor = false
RegisterServerEvent('pacificholdup:setDoor')
AddEventHandler('pacificholdup:setDoor', function()
	TriggerClientEvent('pacificholdup:setDoor', -1)
	IsSetDoor = true
end)

ESX.RegisterServerCallback('pacificholdup:IsSetDoor', function(source, cb)
	cb(IsSetDoor)
end)

local PlayersSelling = {}
local function Sell(_source)
	SetTimeout(4000, function()
		if PlayersSelling[_source] then

			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer.getInventoryItem('jargon').count > 0 then
				xPlayer.removeInventoryItem('jargon', 1)
				xPlayer.addAccountMoney('black_money', 10000)
				Sell(_source)
			else
				TriggerClientEvent('esx:showNotification', _source, "Vous n'en avez pas assez pour vendre")
			end
		end
	end)
end

RegisterServerEvent('pacificholdup:MeltJargon')
AddEventHandler('pacificholdup:MeltJargon', function()
	local _source = source
	TriggerEvent('pacificholdup:stop', _source)
	TriggerClientEvent('esx:showNotification', _source, '~y~Vente~s~ en cours...')
	Wait(1000)
	PlayersSelling[_source] = true
	Sell(_source)
end)

RegisterServerEvent('pacificholdup:stop')
AddEventHandler('pacificholdup:stop', function()
	PlayersSelling[source] = false
end)