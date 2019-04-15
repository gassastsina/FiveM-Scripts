----------------------------------------------
----------------------------------------------
----    File : server.lua                 ----
----    Author: gassastsina               ----
----	Side : server 					  ----
----    Description : Los Pollos Hermanos ----
----------------------------------------------
----------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
ESX.RegisterServerCallback('LosPollosHermanos:getStockItems', function(source, cb, area)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lospolloshermanos_'..area, function(inventory)
    cb(inventory.items)
  end)
end)

TriggerEvent('esx_society:registerSociety', 'lospolloshermanos', 'Los Pollos Hermanos', 'society_lospolloshermanos', 'society_lospolloshermanos', 'society_lospolloshermanos', {type = 'private'})


--------------------------------------------Coffre-------------------------------------------------------
ESX.RegisterServerCallback('LosPollosHermanos:getPlayerInventory', function(source, cb)
  cb(ESX.GetPlayerFromId(source).inventory)
end)

RegisterServerEvent('LosPollosHermanos:getStockItem')
AddEventHandler('LosPollosHermanos:getStockItem', function(itemName, count, area)

  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lospolloshermanos_'..area, function(inventory)

    local item = inventory.getItem(itemName)
    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité ~r~invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)
  end)
end)

RegisterServerEvent('LosPollosHermanos:putStockItem')
AddEventHandler('LosPollosHermanos:putStockItem', function(itemName, count, area)

  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lospolloshermanos_'..area, function(inventory)

    local item = inventory.getItem(itemName)
    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité ~r~invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouté x' .. count .. ' ' .. item.label)
  end)
end)

--------------------------------------------Run----------------------------------------------------------
local PlayersMethToPollos = {}
local PlayersPollosToMeth = {}
local PlayersBurger		  = {}
local PlayersPanini		  = {}
local PlayersTacos		  = {}

---------------MethToPollos----------------
local function MethToPollos(source)
	SetTimeout(5000, function()
		if PlayersMethToPollos[source] then
			local xPlayer  = ESX.GetPlayerFromId(source)
			local MethQuantity = xPlayer.getInventoryItem('meth').count
			local PollosQuantity = xPlayer.getInventoryItem('slaughtered_chicken').count

			if MethQuantity >= 2 and PollosQuantity > 0 then
				xPlayer.removeInventoryItem('meth', 2)
				xPlayer.removeInventoryItem('slaughtered_chicken', 1)
				xPlayer.addInventoryItem('meth_pollos', 1)
				MethToPollos(source)
			else
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de Méthamphétamine o de Pollos à dissimuler")
			end
		end
	end)
end

RegisterServerEvent('LosPollosHermanos:MethToPollos')
AddEventHandler('LosPollosHermanos:MethToPollos', function()
	PlayersMethToPollos[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Dissimulation de la Méthamphétamine~s~ en cours...')
	MethToPollos(source)
end)


---------------PollosToMeth----------------
local function PollosToMeth(source)
	SetTimeout(4000, function()
		if PlayersPollosToMeth[source] then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local MethPollosQuantity = xPlayer.getInventoryItem('meth_pollos').count

			if MethPollosQuantity > 0 then
				xPlayer.removeInventoryItem('meth_pollos', 1)
				xPlayer.addInventoryItem('meth', 2)
				xPlayer.addInventoryItem('slaughtered_chicken', 1)
				PollosToMeth(source)
			else
				TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de Méthamphétamine dissimulée pour la retirer")
			end
		end
	end)
end

RegisterServerEvent('LosPollosHermanos:PollosToMeth')
AddEventHandler('LosPollosHermanos:PollosToMeth', function()
	PlayersPollosToMeth[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Retrait de la Méthamphétamine~s~ en cours...')
	PollosToMeth(source)
end)


RegisterServerEvent('LosPollosHermanos:stopRunning')
AddEventHandler('LosPollosHermanos:stopRunning', function()
	PlayersMethToPollos[source] = false
	PlayersPollosToMeth[source] = false
	PlayersBurger[source] 		= false
	PlayersPanini[source]		= false
	PlayersTacos[source]		= false
end)


-------------------Burger------------------
local function Burger(source)
	SetTimeout(8000, function()
		if PlayersBurger[source] then

			local xPlayer  = ESX.GetPlayerFromId(source)

			if xPlayer.getInventoryItem('bread').count >= 2 and xPlayer.getInventoryItem('slaughtered_chicken').count > 0 and xPlayer.getInventoryItem('vegetables').count > 0 then
				xPlayer.removeInventoryItem('bread', 2)
				xPlayer.removeInventoryItem('slaughtered_chicken', 1)
				xPlayer.removeInventoryItem('vegetables', 2)
				xPlayer.addInventoryItem('burger', 1)
				Burger(source)
			else
				TriggerClientEvent('esx:showNotification', source, "Il vous manque un ingrédient")
			end
		end
	end)
end

RegisterServerEvent('LosPollosHermanos:Burger')
AddEventHandler('LosPollosHermanos:Burger', function()
	PlayersBurger[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Préparation du Burger~s~ en cours...')
	Burger(source)
end)


-------------------Panini------------------
local function Panini(source)
	SetTimeout(6000, function()
		if PlayersPanini[source] then

			local xPlayer  = ESX.GetPlayerFromId(source)

			if xPlayer.getInventoryItem('bread').count > 0 and xPlayer.getInventoryItem('slaughtered_chicken').count > 0 and xPlayer.getInventoryItem('vegetables').count >= 2 then
				xPlayer.removeInventoryItem('bread', 1)
				xPlayer.removeInventoryItem('slaughtered_chicken', 1)
				xPlayer.removeInventoryItem('vegetables', 2)
				xPlayer.addInventoryItem('panini', 1)
				Panini(source)
			else
				TriggerClientEvent('esx:showNotification', source, "Il vous manque un ingrédient")
			end
		end
	end)
end

RegisterServerEvent('LosPollosHermanos:Panini')
AddEventHandler('LosPollosHermanos:Panini', function()
	PlayersPanini[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Préparation du Panini~s~ en cours...')
	Panini(source)
end)


-------------------Tacos-------------------
local function Tacos(source)
	SetTimeout(7000, function()
		if PlayersTacos[source] then

			local xPlayer  = ESX.GetPlayerFromId(source)
			if xPlayer.getInventoryItem('bread').count > 0 and xPlayer.getInventoryItem('slaughtered_chicken').count >= 2 and xPlayer.getInventoryItem('vegetables').count > 0 then
				xPlayer.removeInventoryItem('bread', 1)
				xPlayer.removeInventoryItem('slaughtered_chicken', 1)
				xPlayer.removeInventoryItem('vegetables', 2)
				xPlayer.addInventoryItem('tacos', 1)
				Tacos(source)
			else
				TriggerClientEvent('esx:showNotification', source, "Il vous manque un ingrédient")
			end
		end
	end)
end

RegisterServerEvent('LosPollosHermanos:Tacos')
AddEventHandler('LosPollosHermanos:Tacos', function()
	PlayersTacos[source] = true
	TriggerClientEvent('esx:showNotification', source, '~y~Préparation du Tacos~s~ en cours...')
	Tacos(source)
end)


----------------------------------------------Market-----------------------------------------------------
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

RegisterServerEvent('LosPollosHermanos:Market')
AddEventHandler('LosPollosHermanos:Market', function(item, price)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
		if getPlayerWeight(xPlayer, item) + xPlayer.getInventoryItem(item).limit <= 10000 then
			xPlayer.addInventoryItem(item, 1)
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Vous ne pouvez pas en prendre plus sur vous')
		end
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
	end
end)


-----------------------------------------------Shop------------------------------------------------------
RegisterServerEvent('LosPollosHermanos:buyItemFromShop')
AddEventHandler('LosPollosHermanos:buyItemFromShop', function(itemName, price)
	local _source = source
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lospolloshermanos_shop', function(inventory)
		if inventory.getItem(itemName).count > 0 then
			local xPlayer  = ESX.GetPlayerFromId(source)
			if xPlayer.getMoney() > price and getPlayerWeight(xPlayer, itemName) + xPlayer.getInventoryItem(itemName).limit <= 10000 then
				inventory.removeItem(itemName, 1)
				xPlayer.addInventoryItem(itemName, 1)
				xPlayer.removeMoney(price)
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_lospolloshermanos_job', function(account)
					account.addMoney(price)
				end)
			else
				TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent ou de place")
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "Cet article n'est plus en stock")
		end
	end)
end)


RegisterServerEvent('LosPollosHermanos:putItemInShop')
AddEventHandler('LosPollosHermanos:putItemInShop', function(itemName, count)
  	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lospolloshermanos_shop', function(inventory)

		local xPlayer = ESX.GetPlayerFromId(source)
	    if xPlayer.getInventoryItem(itemName).count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
	    	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouté x' .. count .. ' ' .. inventory.getItem(itemName).label..' au shop')
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus assez de "..inventory.getItem(itemName).label)
		end
  	end)
end)

ESX.RegisterServerCallback('LosPollosHermanos:getShopInventory', function(source, cb)
  	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lospolloshermanos_shop', function(inventory)
	    cb(inventory.items)
  	end)
end)

--Donuts
RegisterServerEvent('LosPollosHermanos:buyDonut')
AddEventHandler('LosPollosHermanos:buyDonut', function(itemName)
	ESX.GetPlayerFromId(source).addInventoryItem(itemName, 1)
end)


--Items
ESX.RegisterUsableItem('burger', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('burger').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_cs_burger_01")
		TriggerClientEvent('esx_status:add', source, 'hunger', 800000)
		ESX.GetPlayerFromId(source).removeInventoryItem('burger', 1)
	end
end)

ESX.RegisterUsableItem('chips', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('chips').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_food_cb_chips")
		TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
		ESX.GetPlayerFromId(source).removeInventoryItem('chips', 1)
	end
end)

ESX.RegisterUsableItem('donuts', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('donuts').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
		ESX.GetPlayerFromId(source).removeInventoryItem('donuts', 1)
	end
end)

ESX.RegisterUsableItem('milk', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('milk').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrink', source, "v_res_tt_milk")
		TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
		ESX.GetPlayerFromId(source).removeInventoryItem('milk', 1)
	end
end)

ESX.RegisterUsableItem('milkshake', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('milkshake').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrink', source, "v_ret_fh_bscup")
		TriggerClientEvent('esx_status:add', source, 'thirst', 380000)
		ESX.GetPlayerFromId(source).removeInventoryItem('milkshake', 1)
	end
end)

ESX.RegisterUsableItem('nugget', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('nugget').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_food_cb_nugets")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('nugget', 1)
	end
end)

ESX.RegisterUsableItem('panini', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('panini').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_sandwich_01")
		TriggerClientEvent('esx_status:add', source, 'hunger', 650000)
		ESX.GetPlayerFromId(source).removeInventoryItem('panini', 1)
	end
end)

ESX.RegisterUsableItem('monster', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('monster').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrink', source, "prop_energy_drink")
		TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
		ESX.GetPlayerFromId(source).removeInventoryItem('monster', 1)
	end
end)

ESX.RegisterUsableItem('sprunk', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('sprunk').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrink', source, "prop_ld_can_01b")
		TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
		ESX.GetPlayerFromId(source).removeInventoryItem('sprunk', 1)
	end
end)

ESX.RegisterUsableItem('tacos', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('tacos').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_taco_01")
		TriggerClientEvent('esx_status:add', source, 'hunger', 700000)
		ESX.GetPlayerFromId(source).removeInventoryItem('tacos', 1)
	end
end)

ESX.RegisterUsableItem('vegetables', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('vegetables').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_veg_crop_03_cab")
		TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
		ESX.GetPlayerFromId(source).removeInventoryItem('vegetables', 1)
	end
end)

ESX.RegisterUsableItem('cola', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('cola').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrink', source, "prop_ecola_can")
		TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
		ESX.GetPlayerFromId(source).removeInventoryItem('cola', 1)
	end
end)

ESX.RegisterUsableItem('coffee_vanilla', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('coffee_vanilla').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source, source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('coffee_vanilla', 1)
	end
end)

ESX.RegisterUsableItem('coffee_milk', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('coffee_milk').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('coffee_milk', 1)
	end
end)

ESX.RegisterUsableItem('coffee_choco', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('coffee_choco').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('coffee_choco', 1)
	end
end)

ESX.RegisterUsableItem('coffee_iced', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('coffee_iced').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('coffee_iced', 1)
	end
end)

ESX.RegisterUsableItem('hot_chocolate', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('hot_chocolate').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('hot_chocolate', 1)
	end
end)

ESX.RegisterUsableItem('raspberry_coffee', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('raspberry_coffee').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('raspberry_coffee', 1)
	end
end)

ESX.RegisterUsableItem('coffee_manche', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('coffee_manche').count > 0 then
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('coffee_manche', 1)
	end
end)

ESX.RegisterUsableItem('donut_vanilla', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('donut_vanilla').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('donut_vanilla', 1)
	end
end)

ESX.RegisterUsableItem('strawberry_donut', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('strawberry_donut').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('strawberry_donut', 1)
	end
end)

ESX.RegisterUsableItem('donut_choco', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('donut_choco').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('donut_choco', 1)
	end
end)

ESX.RegisterUsableItem('donut_iced', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('donut_iced').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('donut_iced', 1)
	end
end)

ESX.RegisterUsableItem('raspberry_donut', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('raspberry_donut').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('raspberry_donut', 1)
	end
end)

ESX.RegisterUsableItem('donut_manche', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('donut_manche').count > 0 then
		TriggerClientEvent('esx_basicneeds:onEat', source, "prop_donut_02")
		TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
		ESX.GetPlayerFromId(source).removeInventoryItem('donut_manche', 1)
	end
end)