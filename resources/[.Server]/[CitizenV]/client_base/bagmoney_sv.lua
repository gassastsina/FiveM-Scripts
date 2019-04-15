ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('getMoneyS')
AddEventHandler('getMoneyS', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then	
		local source = source
		local account = xPlayer.getAccount('black_money')
		local money = xPlayer.getMoney()

		TriggerClientEvent('moneyget',source, money)
		TriggerClientEvent('moneygetB',source,	account.money)
		--print(account.money)
		--print(money .."$")     
	end 
end)