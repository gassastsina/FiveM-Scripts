----------------------------------------------
----------------------------------------------
----    File : server.lua                 ----
----    Author: gassastsina               ----
----	Side : server 					  ----
----    Description : Weed Grow 		  ----
----------------------------------------------
----------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
local plantations = {}
ESX.RegisterUsableItem('weed', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('weed').count > 0 then
		local coords = xPlayer.getCoords()
		table.insert(plantations, {step = 1, timer = Config.Weed.TimerByStep, coords = coords, canHarvest = true})
		TriggerClientEvent('weedGrow:plant', -1, false, 1, coords, source)
		xPlayer.removeInventoryItem('weed', 1)
	end
end)
ESX.RegisterUsableItem('water_can_full', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('water_can_full').count > 0 then
		TriggerClientEvent('weedGrow:WaterCanFull', source)
	end
end)
ESX.RegisterUsableItem('water_can_empty', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('water_can_empty').count > 0 then
		TriggerClientEvent('weedGrow:WaterCanEmpty', source)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		for i=1, #plantations, 1 do
			if plantations[i].timer > 0 then
				plantations[i].timer = plantations[i].timer - 1
			end
			if plantations[i].timer <= 0 then
				if plantations[i].step < 3 then
					plantations[i].step = plantations[i].step + 1
					TriggerClientEvent('weedGrow:plant', -1, true, plantations[i].step or "prop_weed_01", plantations[i].coords)
					TriggerClientEvent('weedGrow:getPlantations', -1, plantations)
					plantations[i].timer = Config.Weed.TimerByStep
				end
			end
		end
	end
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

local function harvest(count, _source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	if getPlayerWeight(xPlayer, "weed2") + count*xPlayer.getInventoryItem('weed2').limit <= 10000 then
		xPlayer.addInventoryItem('weed2', count)
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Tu n'as pas assez de place sur toi")
	end
end

local function deletePlant(coords, step)
	for i=1, #plantations, 1 do
		if json.encode(plantations[i].coords) == json.encode(coords) and plantations[i].step == step then
			table.remove(plantations, i)
			break
		end
	end
	TriggerClientEvent('weedGrow:getPlantations', -1, plantations)
end

RegisterServerEvent('weedGrow:harvest')
AddEventHandler('weedGrow:harvest', function(plantation)
	if plantation.step >= 3 then
		harvest(math.random(8, 10), source)
	elseif plantation.step == 2 then
		harvest(math.random(3, 7), source)
	end
	deletePlant(plantation.coords, plantation.step)
end)

RegisterServerEvent('weedGrow:getPlantations')
AddEventHandler('weedGrow:getPlantations', function()
	TriggerClientEvent('weedGrow:getPlantations', source, plantations)
end)

RegisterServerEvent('weedGrow:changeCoords')
AddEventHandler('weedGrow:changeCoords', function(FromCoords, ToCoords)
	for i=1, #plantations, 1 do
		if json.encode(plantations[i].coords) == json.encode(FromCoords) then
			plantations[i].coords = ToCoords
			break
		end
	end
	TriggerClientEvent('weedGrow:getPlantations', -1, plantations)
end)

RegisterServerEvent('weedGrow:cantPlant')
AddEventHandler('weedGrow:cantPlant', function(coords, step)
	deletePlant(coords, step)
end)

RegisterServerEvent('weedGrow:WaterCan')
AddEventHandler('weedGrow:WaterCan', function(coords)
	for i=1, #plantations, 1 do
		if json.encode(plantations[i].coords) == json.encode(coords) then
			xPlayer.removeInventoryItem('water_can_full', 1)
			xPlayer.addInventoryItem('water_can_empty', 1)
			Wait(4000)
			if plantations[i].timer - 700 > 5 then
				plantations[i].timer = plantations[i].timer - 700
			else
				plantations[i].timer = 20
			end
			break
		end
	end
end)

RegisterServerEvent('weedGrow:TransformEmptyToFullWaterCan')
AddEventHandler('weedGrow:TransformEmptyToFullWaterCan', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	if getPlayerWeight(xPlayer, "water_can_full") - xPlayer.getInventoryItem('water_can_empty').limit + xPlayer.getInventoryItem('water_can_full').limit <= 10000 then
		TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
		TriggerClientEvent('pNotify:SendNotification', source, {
		    text = "Vous remplissez l'arrosoir...",
		    type = "info",
		    timeout = 4000,
		    layout = "centerLeft",
		    queue = "left"
		})
		Wait(4000)
		xPlayer.removeInventoryItem('water_can_empty', 1)
		xPlayer.addInventoryItem('water_can_full', 1)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez de place sur vous")
	end
end)

RegisterServerEvent('weedGrow:playerLoaded')
AddEventHandler('weedGrow:playerLoaded', function()
	TriggerClientEvent('weedGrow:playerLoaded', source, plantations)
end)