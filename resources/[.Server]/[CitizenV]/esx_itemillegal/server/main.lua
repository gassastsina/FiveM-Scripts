----------------------------------------
----------------------------------------
----    File : main.lua       		----
----    Edited by : gassastsina    	----
----    Side : client         		----
----    Description : Gang handcuff	----
----------------------------------------
----------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
RegisterServerEvent('esx_itemillegal:handcuff')
AddEventHandler('esx_itemillegal:handcuff', function(target, item)
  TriggerClientEvent('esx_itemillegal:'..item, target)
end)

ESX.RegisterUsableItem('serflex', function(source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('serflex', 1)

	TriggerClientEvent('esx_itemillegal:getClosestPlayer', _source, 'serflex')
    TriggerClientEvent('esx:showNotification', _source, _U('used_one_serflex'))
	TriggerEvent('logs:write', "A utilisé un serflex", _source)
end)

ESX.RegisterUsableItem('cutting_pince', function(source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cutting_pince', 1)

	TriggerClientEvent('esx_itemillegal:getClosestPlayer', _source, 'cutting_pince')
    TriggerClientEvent('esx:showNotification', _source, _U('used_one_pince'))
	TriggerEvent('logs:write', "A utilisé une Pince coupante", _source)
end)

RegisterServerEvent('esx_itemillegal:buyItem')
AddEventHandler('esx_itemillegal:buyItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, 1)
	xPlayer.removeMoney(Config.Price[item])
	TriggerEvent('logs:write', "A acheté un "..item.." pour "..Config.Price[item].."$", source)
end)