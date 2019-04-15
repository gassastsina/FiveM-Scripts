------------------------------------------------
------------------------------------------------
----    File : server.lua    				----
----    Author : Vakeros 					----
----    Edited by : gassastsina 			----
----    Side : client        				----
----    Description : Vehicle inventory 	----
------------------------------------------------
------------------------------------------------

ESX = nil
local plate = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback('esx_inv_veh:getPlayerInv', function(source, cb)
  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })
end)
ESX.RegisterServerCallback('esx_inv_veh:getVehicleInv', function(source, cb)
	local _source = source
	local items = nil
 	MySQL.Async.fetchAll('SELECT * FROM `vehicle_inventory` WHERE `plate` = @plate AND `type` = @type', {
			['@plate'] = plate,
			['@type'] = 0
		},
		function(result)
			local itemsWeight = {}
			for i=1, #result, 1 do
				table.insert(itemsWeight, {item = result[i].items, weight = ESX.GetPlayerFromId(_source).getInventoryItem(result[i].items).limit})
			end
			cb(result, itemsWeight)
		end
	)
end)

ESX.RegisterServerCallback('esx_inv_veh:getVehicleWeapon', function(source, cb)
	local items = nil
 	MySQL.Async.fetchAll(
		'SELECT * FROM `vehicle_inventory` WHERE `plate` = @plate AND `type` = @type' ,
		{
			['@plate'] = plate,
			['@type'] = 1
		},
		function(result)
			
		  cb({
		    items = result
		  })
	end)
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

RegisterServerEvent('esx_inv_veh:takeItemFromVehicle')
AddEventHandler('esx_inv_veh:takeItemFromVehicle', function(plate, items, count)
	--print(items)
	--print(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local countInv = xPlayer.getInventoryItem(items)
	if getPlayerWeight(xPlayer, items) + countInv.limit*count <= 10000 then
		--print(countInv)
		MySQL.Async.fetchAll(
		'SELECT * FROM `vehicle_inventory` WHERE `plate` = @plate AND items = @items LIMIT 1' ,
		{
			['@plate'] = plate,
			['@items'] = items
		},
		function(result)
			
			if result[1].quantity >= count then
				if result[1].quantity > count then

					local value = result[1].quantity - count
					MySQL.Async.execute(
						'UPDATE `vehicle_inventory` SET `quantity`=@count WHERE  `plate`=@plate AND `items` = @items',
						{
							['@count'] = value,
							['@plate'] = plate,
							['@items'] = items
						}
					)
					xPlayer.addInventoryItem(items, count)
				elseif result[1].quantity == count then
					MySQL.Async.execute(
							'DELETE FROM vehicle_inventory WHERE `plate`=@plate AND `items` = @items',
							{
								['@plate'] = plate,
								['@items'] = items
							}
						)
					xPlayer.addInventoryItem(items, count)
				end
				TriggerEvent('logs:write', 'Sort '..count..' '..items..' du véhicule ('..plate..')', _source)
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne te prends pas pour Hulk s'il te plait")
	end
end)

RegisterServerEvent('esx_inv_veh:takeweaponFromVehicle')
AddEventHandler('esx_inv_veh:takeweaponFromVehicle', function(plate, weapon, ammo)
	--print(items)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local weaponsList = ESX.GetWeaponList()
	for i=1, #weaponsList, 1 do
		if weaponsList[i].name == weapon then
			MySQL.Async.fetchAll(
				'SELECT * FROM `vehicle_inventory` WHERE `plate` = @plate AND items = @items LIMIT 1' ,
				{
					['@plate'] = plate,
					['@items'] = weapon
				},
				function(result)
					if result[1].items ~= nil then
						MySQL.Async.execute(
							'DELETE FROM vehicle_inventory WHERE `plate`=@plate AND `items`=@weapon LIMIT 1',
							{
							    ['@plate'] 	= plate,
								['@weapon'] = weapon
							}
						)
						xPlayer.addWeapon(weapon, 500)
						TriggerEvent('weaponsAccessories:getAccessories', json.decode(result[1].loadout).name, 'set', _source, json.decode(result[1].loadout))
						TriggerEvent('logs:write', "Sort l'arme ("..weapon..") du véhicule ("..plate..")", _source)
					end
				end)
			break
		end
	end
end)

RegisterServerEvent('esx_inv_veh:getPlate')
AddEventHandler('esx_inv_veh:getPlate',function(platex)
	plate = platex
end)

RegisterServerEvent('esx_inv_veh:getPlayerInv')
AddEventHandler('esx_inv_veh:getPlayerInv',function()
	TriggerClientEvent('esx_inv_veh:getPlayerInvCallBack', ESX.GetPlayerFromId(source).getInventory())
end)

RegisterServerEvent('esx_inv_veh:putItemIntoVehicle')
AddEventHandler('esx_inv_veh:putItemIntoVehicle',function(plate, items, count, useCapacity, maxCapacity)	
	  --print("put "..items.." in vehicle("..plate..")quantity = " ..count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM `vehicle_inventory` WHERE `plate` = @plate AND items = @items LIMIT 1', {
			['@plate'] = plate,
			['@items'] = items
		},
		function(result)
			if useCapacity + xPlayer.getInventoryItem(items).limit*count <= maxCapacity then

				xPlayer.removeInventoryItem(items, count)
				if result[1] ~= nil then
						count = result[1].quantity + count

						--print(count) -- valeur demandé ok
						MySQL.Async.execute(
							'UPDATE `vehicle_inventory` SET `quantity`=@quantity WHERE  `plate`=@plate AND `items` = @items',
							{
								['@quantity'] = count, 
								['@plate'] = plate,
								['@items'] = items
							}
						)
				else
					MySQL.Async.execute(
						'INSERT INTO `vehicle_inventory` (`plate`, `items`, quantity,type) VALUES (@plate, @items, @quantity,@type)',
						{
							['@plate'] = plate,
							['@items']     = items,
							['@type']     = 0,
							['@quantity']       = count

						}, function(rowsChanged)
							
						end
					)
				end
				TriggerEvent('logs:write', 'Met '..count..' '..items..' dand le véhicule ('..plate..')', _source)
			else 
				TriggerClientEvent('esx:showNotification', _source, '~r~Le véhicule ne peut pas en prendre autant')
			end
		end)
end)

RegisterServerEvent('esx_inv_veh:putWeaponIntoVehicle')
AddEventHandler('esx_inv_veh:putWeaponIntoVehicle', function(weapon, ammo)	
	--print("put "..weapon.." in vehicle ("..plate..")")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	for i=1, #xPlayer.loadout, 1 do
		if xPlayer.loadout[i].name == weapon then
			MySQL.Async.execute(
				'INSERT INTO `vehicle_inventory` (`plate`, `items`, `quantity`, type, loadout) VALUES (@plate, @items, @quantity, @type, @loadout)',
				{
					['@plate'] 	  = plate,
					['@items']    = weapon,
					['@quantity'] = ammo,
					['@type']     = 1,
					['@loadout']  = json.encode(xPlayer.loadout[i])
				},
				function(rowsChanged)
				end
			)
		end
	end
	TriggerEvent('logs:write', 'Met une arme ('..weapon..') dans le véhicule ('..plate..')', _source)
	xPlayer.removeWeapon(weapon)
end)