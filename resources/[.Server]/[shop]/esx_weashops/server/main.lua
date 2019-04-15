---------------------------------------
---------------------------------------
----    File : main.lua  		   ----
----    Edited by : gassastsina    ----
----    Side : server        	   ----
----    Description : Weapons shop ----
---------------------------------------
---------------------------------------

ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function LoadLicenses (source)
  TriggerEvent('esx_license:getLicenses', source, function (licenses)
    TriggerClientEvent('esx_weashop:loadLicenses', source, licenses)
  end)
end

if Config.EnableLicense == true then
  AddEventHandler('esx:playerLoaded', function (source)
    LoadLicenses(source)
  end)
end

RegisterServerEvent('esx_weashop:buyLicense')
AddEventHandler('esx_weashop:buyLicense', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.get('money') >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)

		TriggerEvent('esx_license:addLicense', _source, 'weapon', function ()
			LoadLicenses(_source)
			xPlayer.addInventoryItem('weapon', 1)
			TriggerEvent('logs:write', "Achète une license d'arme", _source)
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end
end)

ESX.RegisterServerCallback('esx_weashop:requestDBItems', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM weashops',
	{}, function(result)
		local shopItems  = {}
		for i=1, #result, 1 do

			if shopItems[result[i].name] == nil then
				shopItems[result[i].name] = {}
			end

			table.insert(shopItems[result[i].name], {
				name  = result[i].item,
				price = result[i].price,
				label = ESX.GetWeaponLabel(result[i].item)
			})

		end

		cb(shopItems)

	end
	)
end)

local function BuyInBlackShop(itemName, price, _source, type, label, xPlayer)
	if type == 'weapons' then
		xPlayer.addWeapon(itemName, 42)
		TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
		TriggerEvent('logs:write', "Achète l'arme illégale "..ESX.GetWeaponLabel(itemName)..' pour '..price.."$ d'argent sale", _source)
	elseif type == 'items' then
		xPlayer.addInventoryItem(itemName, 1)
		TriggerClientEvent('esx:showNotification', _source, 'Vous avez acheter une '..label)
		TriggerEvent('logs:write', "Achète l'item illégale "..label..' pour '..price.."$ d'argent sale", _source)
	end
end

RegisterServerEvent('esx_weashop:buyItem')
AddEventHandler('esx_weashop:buyItem', function(itemName, price, zone, type, label)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	
	if zone ~= "GunShop" then
		if account.money >= price then
			xPlayer.removeAccountMoney('black_money', price)
			BuyInBlackShop(itemName, price, _source, type, label, xPlayer)
		
		elseif xPlayer.get('money') >= price then
			xPlayer.removeMoney(price)
			BuyInBlackShop(itemName, price, _source, type, label, xPlayer)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_black'))
		end
	else
		if xPlayer.get('money') >= price then
			xPlayer.removeMoney(price)
			xPlayer.addWeapon(itemName, 42)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
			TriggerEvent('logs:write', "Achète l'arme légale "..ESX.GetWeaponLabel(itemName)..' pour '..price.."$ d'argent propre", _source)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
		end
	end
end)

ESX.RegisterServerCallback('esx_outlawalert:getAmmuNationsCoords',function(source, cb)
	cb(Config.Zones['GunShop'].Pos)
end)

RegisterServerEvent('esx_weashop:removeMoneyToChangeNum')
AddEventHandler('esx_weashop:removeMoneyToChangeNum', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('black_money').money >= money then
		xPlayer.removeAccountMoney('black_money', money)
		TriggerEvent('gcphone:ChangeNum', source)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~J'veux qu'on me paye en argent sale")
	end
end)