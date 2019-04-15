--------------------------------------------------
--------------------------------------------------
----    File : bracelets.lua              	  ----
----    Author : gassastsina               	  ----
----	Side : server 						  ----
----    Description : Bracelets électroniques ----
--------------------------------------------------
--------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
--Envoies les blips aux flics pour qu'ils les voient sur la map
local function addBlip()
	local playertab = {}
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.getInventoryItem('electro_bracelet').count > 0 and xPlayer.job.name ~= 'police' then
			table.insert(playertab, {xPlayers[i], xPlayer.getCoords(), GetPlayerName(xPlayers[i])})
		end
	end

	for i=1, #xPlayers, 1 do
		if ESX.GetPlayerFromId(xPlayers[i]).job.name == 'police' then
			TriggerClientEvent('bracelets:addBraceletBlip', xPlayers[i], playertab)
		end
	end
end

--Placer bracelet sur un joueur
RegisterServerEvent('esx_policejob:ElectroBracelet')
AddEventHandler('esx_policejob:ElectroBracelet', function(xPlayer)
	local xPlayerID = ESX.GetPlayerFromId(xPlayer)
	local sourceID = ESX.GetPlayerFromId(source)
	if xPlayerID.getInventoryItem('electro_bracelet').count <= 0 then
		if sourceID.getInventoryItem('electro_bracelet').count > 0 then

			sourceID.removeInventoryItem('electro_bracelet',  1)
			xPlayerID.addInventoryItem('electro_bracelet',  1)
			TriggerClientEvent('esx:showNotification', source, "~g~Vous lui avez placé un bracelet électronique")
			TriggerClientEvent('esx:showNotification', xPlayer, "Vous possédez désormait un bracelet électronique")

		else
			TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de bracelet électronique sur vous")
		end

	else
		xPlayerID.removeInventoryItem('electro_bracelet',  1)
		sourceID.addInventoryItem('electro_bracelet',  1)
		TriggerClientEvent('esx:showNotification', source, "~g~Vous lui avez enlevé un bracelet électronique")
		TriggerClientEvent('esx:showNotification', xPlayer, "~g~Vous ne possédez plus de bracelet électronique")
	end
	addBlip()
end)

--Boucle toutes les minutes
Citizen.CreateThread(function()
	while true do
		Wait(60000)
		addBlip()
	end
end)