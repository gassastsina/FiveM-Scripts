------------------------------------------------
------------------------------------------------
----    File : server.lua       			----
----    Author : Onlyserenity    			----
----    Edited by : gassastsina    			----
----    Side : server         				----
----    Description : Sell drugs to NPCs 	----
------------------------------------------------
------------------------------------------------

ESX 						   		= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sellDrugToNPC:getItem')
AddEventHandler('sellDrugToNPC:getItem', function()
	local cops = 0
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	if cops >= Config.MinCopsToSell then
	    for i=1, #Config.Drugs, 1 do
	    	local drug = ESX.GetPlayerFromId(source).getInventoryItem(Config.Drugs[i].name)
			if drug.count > 0 then
				TriggerClientEvent('sellDrugToNPC:startNegociations', source, {label = drug.label, name = drug.name, qty = drug.count})
				break
			elseif i == #Config.Drugs then
				TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
				TriggerClientEvent('pNotify:SendNotification', source, {
				    text = "Tu n'as pas ce que je veux",
				    type = "warning",
				    timeout = math.random(1000, 3000),
				    layout = "centerLeft",
				    queue = "left"
				})
				TriggerClientEvent('sellDrugToNPC:stopNegociation', source)
				break
			end
		end
	else
		TriggerClientEvent('pNotify:SetQueueMax', "left", source, 1)
		TriggerClientEvent('pNotify:SendNotification', source, {
	        text = "Il n'y a pas assez de policiers en ville",
	        type = "error",
	        timeout = 3000,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	end
end)

RegisterServerEvent('sellDrugToNPC:sendToPolice')
AddEventHandler('sellDrugToNPC:sendToPolice', function(x, y, street)
	local messages = {
		"Quelqu'un vend de la drogue",
		"Ils essayent de me vendre de la drogue",
		"Il y a un revendeur de drogue",
		"Il y a un vendeur à la sauvette",
		"Quelqu'un a essayé de me vendre de la drogue",
		"Vous devriez vous occuper un peu de la drogue par ici",
		"La drogue se vend par ici",
		"De la drogue est vendu",
		"De la drogue est proposé à la vente"
	}
	messages =  messages[math.random(1, #messages)]

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		if ESX.GetPlayerFromId(xPlayers[i]).job.name == 'police' then
			TriggerClientEvent('sellDrugToNPC:sendToPolice', xPlayers[i], messages, street, x, y)
		end
	end
	TriggerEvent('logs:write', "A alerté la police d'une vente de drogue sur "..street.." (x = "..x..", y = "..y..")", source)
end)

RegisterServerEvent('sellDrugToNPC:selled')
AddEventHandler('sellDrugToNPC:selled', function(item, number, price)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, number)
	for i=1, #Config.Drugs, 1 do
		if Config.Drugs[i].name == item then
			xPlayer.addAccountMoney("black_money", price)
			TriggerEvent('logs:write', "Vient de vendre "..number.." "..item.." pour "..price.."$", source)
	        break
	    end
	end
end)

ESX.RegisterServerCallback('sellDrugToNPC:getCopsNumber', function(source, cb, item)
end)