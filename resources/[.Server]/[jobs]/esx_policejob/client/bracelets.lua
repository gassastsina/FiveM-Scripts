------------------------------------------------
------------------------------------------------
----    File : bracelets.lua              	----
----    Author : gassastsina               	----
----	Side : client 						----
----    Description : Bracelet électronique ----
------------------------------------------------
------------------------------------------------

-----------------------------------------------main-------------------------------------------------------

--Fait appel à la suppression de tout les blips et place les nouveaux
local lastBlips = {}
RegisterNetEvent('bracelets:addBraceletBlip')
AddEventHandler('bracelets:addBraceletBlip', function(players)
	for i=1, #lastBlips, 1 do
		RemoveBlip(lastBlips[i])
	end
	
	Wait(2000)
	if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)) or Vdist(GetEntityCoords(GetPlayerPed(-1)), Config.PoliceStations['LSPD'].OthersActions[1].x, Config.PoliceStations['LSPD'].OthersActions[1].y, Config.PoliceStations['LSPD'].OthersActions[1].z) < 10.0 then
		for i=1, #players, 1 do
			local blip = AddBlipForCoord(players[i][2].x, players[i][2].y, players[i][2].z)

		    SetBlipSprite (blip, 178)
		    SetBlipDisplay(blip, 4)
		    SetBlipScale  (blip, 1.2)
		    SetBlipColour (blip, 1)
		    SetBlipAsShortRange(blip, false)

		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString(players[i][3])
		    EndTextCommandSetBlipName(blip)
		  	table.insert(lastBlips, blip)
		end
	end
end)