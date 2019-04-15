--------------------------------------------------
--------------------------------------------------
----    File : gift_s.lua                 	  ----
----    Author: gassastsina               	  ----
----	Side : server 		 			  	  ----
----    Description : Open gift for christmas ----
--------------------------------------------------
--------------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('gift_surprise', function(source)
	TriggerClientEvent('noël:ChristmasSong', source)
	TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
	TriggerClientEvent('pNotify:SendNotification', source, {
        text = "Tu as gagné...",
        type = "success",
        timeout = 18600,
        layout = "centerLeft",
        queue = "left"
  	})
    Wait(18600)
	if ESX.GetPlayerFromId(source).getInventoryItem('gift_surprise').count > 0 then
		MySQL.Async.fetchAll("SELECT * FROM `items` WHERE `rare`=@rare AND `can_remove`=@can_remove",
		{
			['@rare'] = 0,
			['@can_remove'] = 1
		}, function(result)
			local item = result[math.random(1, #result)]
			local number = math.random(1, 5)
			ESX.GetPlayerFromId(source).addInventoryItem(item.name, number)
			TriggerClientEvent('esx:showNotification', source, "~g~Tu as gagné "..number.." "..item.label)
		end)
	else
		TriggerClientEvent('esx:showNotification', source, "Tu n'as plus de cadeaux :(")
	end
end)

ESX.RegisterUsableItem('gift_christmas', function(source)
	TriggerClientEvent('noël:ChristmasSong', source)
	TriggerClientEvent('pNotify:SetQueueMax', source, "left", 1)
	TriggerClientEvent('pNotify:SendNotification', source, {
        text = "Tu as gagné...",
        type = "success",
        timeout = 18600,
        layout = "centerLeft",
        queue = "left"
  	})
    Wait(18600)
	if ESX.GetPlayerFromId(source).getInventoryItem('gift_christmas').count > 0 then
		local item = Config.ChritmasItems[math.random(1, #Config.ChritmasItems)]
		if Config.ChritmasItems[math.random(1, #Config.ChritmasItems)].type ~= 'money' then
			local number = math.random(1, 5)
			ESX.GetPlayerFromId(source).addInventoryItem(item.name, number)
			TriggerClientEvent('esx:showNotification', source, "~g~Tu as gagné "..number.." "..item.label)
		else
			ESX.GetPlayerFromId(source).addMoney(item.name)
			TriggerClientEvent('esx:showNotification', source, "~g~Tu as gagné "..item.label)
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Tu n'as plus de cadeaux :(")
	end
end)