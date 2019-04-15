RegisterServerEvent("client_base_coffee:buy")
AddEventHandler("client_base_coffee:buy", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(1)
	xPlayer.addInventoryItem('coffee', 1)
end)