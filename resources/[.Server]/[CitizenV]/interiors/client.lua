----------------------------------------------
----------------------------------------------
----    File : client.lua      			  ----
----    Author: gassastsina       		  ----
----	Side : client 			  		  ----
----    Description : Teleport like doors ----
----------------------------------------------
----------------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX                           = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

-----------------------------------------------main------------------------------------------------------
Citizen.CreateThread(function()
	Wait(5000)
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		for k,v in pairs(Config.Zones) do
			if Vdist(coords.x, coords.y, coords.z, v.From.x, v.From.y, v.From.z) < Config.MarkerSize then
				SetTextComponentFormat('STRING')
				AddTextComponentString('Appuyez sur ~INPUT_CONTEXT~ pour franchir la porte')
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then
					TeleportFadeEffect(v.To)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	--Mairie
	local blip = AddBlipForCoord(Config.Zones.CityHallEnter1.From.x, Config.Zones.CityHallEnter1.From.y, Config.Zones.CityHallEnter1.From.z)
  	SetBlipSprite (blip, 419)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.1)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('Mairie')
  	EndTextCommandSetBlipName(blip)


	--Tribunal
	blip = AddBlipForCoord(Config.Zones.CourtsBuldingEnter1.From.x, Config.Zones.CourtsBuldingEnter1.From.y, Config.Zones.CourtsBuldingEnter1.From.z)
  	SetBlipSprite (blip, 285)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.1)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('Tribunal')
  	EndTextCommandSetBlipName(blip)
end)

function TeleportFadeEffect(coords)
	DoScreenFadeOut(700)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end

	ESX.Game.Teleport(GetPlayerPed(-1), coords, function()
		DoScreenFadeIn(700)
	end)
end