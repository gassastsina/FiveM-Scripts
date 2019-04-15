ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bread'))

end)

ESX.RegisterUsableItem('water', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_water'))

end)

ESX.RegisterUsableItem('beer', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrinkbeer', _source)
    TriggerClientEvent('esx:showNotification', _source,('~o~Vous buvez une bierre'))

end)

ESX.RegisterUsableItem('vodka', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrinkvodka', _source)
    TriggerClientEvent('esx:showNotification', _source,('~r~Vous buvez une bouteille de Vodka'))

end)

ESX.RegisterUsableItem('whiskey', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('whiskey', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrinkwhiskey', _source)
    TriggerClientEvent('esx:showNotification', _source,('~r~Vous buvez une bouteille de Whisky'))

end)

ESX.RegisterUsableItem('cigarette', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cigarette', 1)

	TriggerClientEvent('esx_basicneeds:cigarette', _source)
    TriggerClientEvent('esx:showNotification', _source,('~g~Vous fumez une cigarette'))

end)
ESX.RegisterUsableItem('coffee', function(source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('coffee', 1)

		TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
		TriggerClientEvent('esx_basicneeds:onDrinkCoffee', _source)
		TriggerClientEvent('esx:showNotification', _source, ('~g~Vous buvez un café'))

end)

ESX.RegisterUsableItem('cognak', function(source)
	local _source = source
	ESX.GetPlayerFromId(_source).removeInventoryItem('cognak', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkwhiskey', _source, "prop_bottle_cognac")
	TriggerClientEvent('esx:showNotification', _source, ('~g~Vous buvez une bouteille de cognak'))
end)

ESX.RegisterUsableItem('rum', function(source)
	local _source = source
	ESX.GetPlayerFromId(_source).removeInventoryItem('rum', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkwhiskey', _source, "prop_rum_bottle")
	TriggerClientEvent('esx:showNotification', _source, ('~g~Vous buvez une bouteille de rhum'))
end)

ESX.RegisterUsableItem('tequila', function(source)
	local _source = source
	ESX.GetPlayerFromId(_source).removeInventoryItem('tequila', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkwhiskey', _source, "prop_tequila_bottle")
	TriggerClientEvent('esx:showNotification', _source, ('~g~Vous buvez une bouteille de tequila'))
end)