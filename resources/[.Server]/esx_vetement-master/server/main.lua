
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
----pay
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
RegisterServerEvent('esx_shoes:pay')
AddEventHandler('esx_shoes:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)

RegisterServerEvent('esx_helmet:pay')
AddEventHandler('esx_helmet:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)

RegisterServerEvent('esx_mask:pay')
AddEventHandler('esx_mask:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)

RegisterServerEvent('esx_body:pay')
AddEventHandler('esx_body:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)

RegisterServerEvent('esx_glasses:pay')
AddEventHandler('esx_glasses:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)

RegisterServerEvent('esx_pants:pay')
AddEventHandler('esx_pants:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)

RegisterServerEvent('esx_gilet:pay')
AddEventHandler('esx_gilet:pay', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)

	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. '$' .. Config.Price)

end)
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
---fin pay

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--save
RegisterServerEvent('esx_shoes:saveGlasses')
AddEventHandler('esx_shoes:saveGlasses', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_shoes', xPlayer.identifier, function(store)
		
		store.set('hasShoes', true)
		
		store.set('skin', {
			shoes_1 = skin.shoes_1,
			shoes_2 = skin.shoes_2
		})

	end)

end)
RegisterServerEvent('esx_mask:saveMask')
AddEventHandler('esx_mask:saveMask', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_mask', xPlayer.identifier, function(store)
		
		store.set('hasMask', true)
		
		store.set('skin', {
			mask_1 = skin.mask_1,
			mask_2 = skin.mask_2
		})

	end)

end)
RegisterServerEvent('esx_body:saveGlasses')
AddEventHandler('esx_body:saveGlasses', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_body', xPlayer.identifier, function(store)
		
		store.set('hasBody', true)
		
		store.set('skin', {
			arms = skin.arms,
			torso_1 = skin.torso_1,
			torso_2 = skin.torso_2,
			tshirt_1 = skin.tshirt_1,
			tshirt_2 = skin.tshirt_2
		})

	end)

end)
RegisterServerEvent('esx_helmet:saveHelmet')
AddEventHandler('esx_helmet:saveHelmet', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_helmet', xPlayer.identifier, function(store)
		
		store.set('hasHelmet', true)
		
		store.set('skin', {
			helmet_1 = skin.helmet_1,
			helmet_2 = skin.helmet_2
		})

	end)

end)
RegisterServerEvent('esx_glasses:saveGlasses')
AddEventHandler('esx_glasses:saveGlasses', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_glasses', xPlayer.identifier, function(store)
		
		store.set('hasGlasses', true)
		
		store.set('skin', {
			glasses_1 = skin.glasses_1,
			glasses_2 = skin.glasses_2
		})

	end)

end)
RegisterServerEvent('esx_pants:saveGlasses')
AddEventHandler('esx_pants:saveGlasses', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_pants', xPlayer.identifier, function(store)
		
		store.set('hasPants', true)
		
		store.set('skin', {
			pants_1 = skin.pants_1,
			pants_2 = skin.pants_2
		})

	end)

end)

RegisterServerEvent('esx_gilet:saveGilet')
AddEventHandler('esx_gilet:saveGilet', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_gilet', xPlayer.identifier, function(store)
		
		store.set('hasGilet', true)
		
		store.set('skin', {
			bproof_1 = skin.bproof_1,
			bproof_2 = skin.bproof_2
		})

	end)

end)
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--check money
ESX.RegisterServerCallback('esx_shoes:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
ESX.RegisterServerCallback('esx_mask:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
ESX.RegisterServerCallback('esx_body:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
ESX.RegisterServerCallback('esx_helmet:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
ESX.RegisterServerCallback('esx_glasses:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
ESX.RegisterServerCallback('esx_pants:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
ESX.RegisterServerCallback('esx_gilet:checkMoney', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--Get

ESX.RegisterServerCallback('esx_shoes:getGlasses', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_shoes', xPlayer.identifier, function(store)
		
		local hasShoes = (store.get('hasShoes') and store.get('hasShoes') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasShoes, skin)

	end)

end)

ESX.RegisterServerCallback('esx_mask:getMask', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_mask', xPlayer.identifier, function(store)
		
		local hasMask = (store.get('hasMask') and store.get('hasMask') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasMask, skin)

	end)

end)

ESX.RegisterServerCallback('esx_body:getGlasses', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_body', xPlayer.identifier, function(store)
		
		local hasBody = (store.get('hasBody') and store.get('hasBody') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasBody, skin)

	end)

end)

ESX.RegisterServerCallback('esx_helmet:getHelmet', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_helmet', xPlayer.identifier, function(store)
		
		local hasHelmet = (store.get('hasHelmet') and store.get('hasHelmet') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasHelmet, skin)

	end)

end)

ESX.RegisterServerCallback('esx_glasses:getGlasses', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_glasses', xPlayer.identifier, function(store)
		
		local hasGlasses = (store.get('hasGlasses') and store.get('hasGlasses') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasGlasses, skin)

	end)

end)

ESX.RegisterServerCallback('esx_pants:getGlasses', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_pants', xPlayer.identifier, function(store)
		
		local hasPants = (store.get('hasPants') and store.get('hasPants') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasPants, skin)

	end)

end)

ESX.RegisterServerCallback('esx_gilet:getGilet', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_gilet', xPlayer.identifier, function(store)
		
		local hasGilet = (store.get('hasGilet') and store.get('hasGilet') or false)
		local skin    = (store.get('skin')    and store.get('skin')    or {})

		cb(hasGilet, skin)

	end)

end)
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------