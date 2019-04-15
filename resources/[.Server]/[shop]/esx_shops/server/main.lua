ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function()

	MySQL.Async.fetchAll(
		'SELECT * FROM items',
		{},
		function(result)

			for i=1, #result, 1 do
				ItemsLabels[result[i].name] = result[i].label
			end--

		end
	)

end)

ESX.RegisterServerCallback('esx_shop:requestDBItems', function(source, cb)

	MySQL.Async.fetchAll(
		'SELECT * FROM shops',
		{},
		function(result)

			local shopItems  = {}

			for i=1, #result, 1 do

				if shopItems[result[i].name] == nil then
					shopItems[result[i].name] = {}
				end

				table.insert(shopItems[result[i].name], {
					name  = result[i].item,
					price = result[i].price,
					label = ItemsLabels[result[i].item]
				})

			end
			print('GetItemShop')

			cb(shopItems)

		end
	)

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
	--Weapons weight
	if not IsFoodItem(item) then
		local weaponList = ESX.GetWeaponList
		for i=1, #weaponList, 1 do
			for x=1, #xPlayer.loadout, 1 do
				if weaponList[i].name == xPlayer.loadout[x].name then
			  		totalWeight = totalWeight + weaponList[i].weight
				end
			end
		end
		return totalWeight
	end
	return totalFoodWeight
end

RegisterServerEvent('esx_shop:buyItem')
AddEventHandler('esx_shop:buyItem', function(itemName, price, qty)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= price*qty then
		if getPlayerWeight(xPlayer, itemName) + xPlayer.getInventoryItem(itemName).limit*qty <= 10000 then
			xPlayer.removeMoney(price*qty)
			xPlayer.addInventoryItem(itemName, qty)

			TriggerClientEvent('esx:showNotification', _source, _U('bought')..qty.." ".. ItemsLabels[itemName])
			TriggerEvent('logs:write', 'Achète '..qty..' '..itemName..' pour '..price..'$', _source)
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez de place sur vous")
			TriggerEvent('logs:write', "A essayé d'acheter un/une "..ItemsLabels[itemName].."mais n'avait pas assez de place", _source)
		end

	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end

end)
