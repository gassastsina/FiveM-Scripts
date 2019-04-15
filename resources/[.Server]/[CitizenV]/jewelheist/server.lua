----------------------------------------
----------------------------------------
----    File : server.lua         	----
----    Author: gassastsina       	----
----	Side : server 		 	  	----
----    Description : Jewel heist 	----
----------------------------------------
----------------------------------------

--------------------------------------------------ESX-----------------------------------------------------------
ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--------------------------------------------------main----------------------------------------------------------
ESX.RegisterServerCallback('jewelheist:getItemAmount', function(source, cb, item)
    cb(ESX.GetPlayerFromId(source).getInventoryItem(item).count)
end)

local TakingHostage = false
local HackedAlarm = -1
local IsAlarmRinging = false
RegisterServerEvent('jewelheist:tryToHackAlarm')
AddEventHandler('jewelheist:tryToHackAlarm', function(alarm)
	HackedAlarm = alarm
	ESX.GetPlayerFromId(source).removeInventoryItem("hack_phone", 1)
	local message = ''
	if alarm then
		Wait(Config.WaitingStopAlarmBeforeCallPoliceSuccess)
		message = "L'alarme a été désactivée"
	else
		Wait(Config.WaitingStopAlarmBeforeCallPoliceError)
		message = "Un disfonctionnement de l'alarme est suvenu"
	end
	TriggerEvent('jewelheist:callCopsToAlarm', message)
end)

RegisterServerEvent('jewelheist:callCopsToAlarm')
AddEventHandler('jewelheist:callCopsToAlarm', function(message)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
 			TriggerClientEvent('jewelheist:callCopsToAlarm', xPlayers[i], message)
		end
	end
end)

ESX.RegisterServerCallback('jewelheist:getAlarmStatus', function(source, cb)
	if HackedAlarm == -1 then
    	cb(true)
    elseif HackedAlarm == false then
		TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
		TriggerClientEvent('pNotify:SendNotification', source, {
		    text = "L'alarme est verrouillée",
		    type = "error",
		    timeout = 5000,
		    layout = "centerLeft",
		    queue = "left"
		})
	elseif HackedAlarm == true then
		TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
		TriggerClientEvent('pNotify:SendNotification', source, {
		    text = "L'alarme subit un disfonctionnement",
		    type = "error",
		    timeout = 5000,
		    layout = "centerLeft",
		    queue = "left"
		})
    end
    cb(false)
end)

ESX.RegisterServerCallback('jewelheist:IsAvailable', function(source, cb, wearNum)
	cb(Config.WorkerWears[wearNum].available)
end)

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

RegisterServerEvent('jewelheist:caseHeisted')
AddEventHandler('jewelheist:caseHeisted', function(case)
	local jewels = math.random(5, 10)
	local xPlayer = ESX.GetPlayerFromId(source)
	if getPlayerWeight(xPlayer, 'jewel') + xPlayer.getInventoryItem('jewel').limit*jewels <= 10000 then
		xPlayer.addInventoryItem('jewel', jewels)
		Config.Jewels[case].available = false
		TriggerClientEvent('jewelheist:caseHeisted', -1, case)
		TriggerEvent('logs:write', "Vient d'obtenir "..jewels.." bijoux en braquant la bijouterie", source)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous ne pouvez pas prendre plus sur vous")
	end
end)

RegisterServerEvent('jewelheist:setAlarm')
AddEventHandler('jewelheist:setAlarm', function(alarm, force, message)
	if (HackedAlarm == -1 or HackedAlarm == false or TakingHostage == false) or force then
		if message ~= nil then
			TriggerEvent('jewelheist:callCopsToAlarm', message)
		end
		TriggerClientEvent('jewelheist:setAlarm', -1, alarm)
		IsAlarmRinging = alarm
	end
end)

ESX.RegisterServerCallback('jewelheist:getIsAlarmRinging', function(source, cb)
	cb(IsAlarmRinging)
end)

ESX.RegisterServerCallback('jewelheist:GetCopsNum', function(source, cb)
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


--------------------------------------------------checkout----------------------------------------------------------
local CheckoutHeisted  = false
local CheckoutPassword = ESX.GetRandomString(8)
local CheckoutMoney    = math.random(15000, 20000)

ESX.RegisterServerCallback('jewelheist:getCheckoutPassword', function(source, cb)
	cb(CheckoutPassword)
end)

ESX.RegisterServerCallback('jewelheist:getCheckoutHeisting', function(source, cb)
	cb(CheckoutHeisted)
end)

RegisterServerEvent('jewelheist:CheckoutHeisted')
AddEventHandler('jewelheist:CheckoutHeisted', function()
	CheckoutHeisted = true
end)

RegisterServerEvent('jewelheist:HeistCheckout')
AddEventHandler('jewelheist:HeistCheckout', function()
	if CheckoutMoney > 0 then
		local moneylist = {10, 20, 50, 100}
		local money = moneylist[math.random(1, #moneylist)]*10
		if money <= CheckoutMoney then
			ESX.GetPlayerFromId(source).addAccountMoney("black_money", money)
			CheckoutMoney = CheckoutMoney - money
			TriggerClientEvent('esx:showNotification', source, "Vous avez récupéré ~r~"..money.."$~s~ d'argent sale")
		else
			ESX.GetPlayerFromId(source).addAccountMoney("black_money", CheckoutMoney)
			TriggerClientEvent('esx:showNotification', source, "Vous avez récupéré ~r~"..CheckoutMoney.."$~s~ d'argent sale")
			CheckoutMoney = 0
		end
	else
		TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
		TriggerClientEvent('pNotify:SendNotification', source, {
		    text = "La caisse est vide",
		    type = "error",
		    timeout = 2000,
		    layout = "centerLeft",
		    queue = "left"
		})
	end
end)


-----------------------------------------------------NPC----------------------------------------------------------
local isNPCSpawned = false
ESX.RegisterServerCallback('jewelheist:getIsNPCSpawned', function(source, cb)
	cb(isNPCSpawned)
end)

RegisterServerEvent('jewelheist:NPCSpawned')
AddEventHandler('jewelheist:NPCSpawned', function()
	isNPCSpawned = true
end)

RegisterServerEvent('jewelheist:setTakingHostage')
AddEventHandler('jewelheist:setTakingHostage', function()
	TakingHostage = true
	Wait(Config.WaitingHostageBeforeCallPolice)
	if not IsAlarmRinging then
		TriggerEvent('jewelheist:callCopsToAlarm', "Aucune réponse de la gérante")
		TriggerEvent('jewelheist:setAlarm', true, false)
	end
end)

ESX.RegisterServerCallback('jewelheist:getTakingHostage', function(source, cb)
	cb(TakingHostage)
end)