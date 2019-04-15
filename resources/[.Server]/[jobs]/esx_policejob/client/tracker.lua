--------------------------------------------------------------
--------------------------------------------------------------
----    File : tracker.lua                           	  ----
----    Author : gassastsina                			  ----
----	Side : client 									  ----
----    Description : Balises sur les véhicules de police ----
--------------------------------------------------------------
--------------------------------------------------------------


----------------------------------------------PlayerJob--------------------------------------------------------
local PlayerData = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

---------------------------------------------------main--------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Wait(Config.Blip.Actualisation)
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		local coords = GetEntityCoords(vehicle, true)
		if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			if GetEntityModel(vehicle) == GetHashKey('policeb') then
				TriggerServerEvent('tracker:sendVehicle', coords.x, coords.y, coords.z, GetVehicleNumberPlateText(vehicle), 'bike', IsVehicleDriveable(vehicle, true))

			elseif GetEntityModel(vehicle) == GetHashKey('polmav') or GetEntityModel(vehicle) == GetHashKey('buzzard2') then
				TriggerServerEvent('tracker:sendVehicle', coords.x, coords.y, coords.z, GetVehicleNumberPlateText(vehicle), 'helicopter', IsVehicleDriveable(vehicle, true))

			elseif (IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) or GetEntityModel(vehicle) == GetHashKey('riot') or GetEntityModel(vehicle) == GetHashKey('pbus')) and GetEntityModel(vehicle) ~= GetHashKey('policeold2') then
				TriggerServerEvent('tracker:sendVehicle', coords.x, coords.y, coords.z, GetVehicleNumberPlateText(vehicle), 'car', IsVehicleDriveable(vehicle, true))
			end
		end
		local computer = Config.PoliceStations['LSPD'].OthersActions[1]
		coords = GetEntityCoords(GetPlayerPed(-1), true)
		if Vdist(coords.x, coords.y, coords.z, computer.x, computer.y, computer.z) < Config.Blip.Computer and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			TriggerServerEvent('tracker:sendVehicle', nil, nil, nil, nil, nil, false)
		end
	end
end)

local lastBliptab = {}
RegisterNetEvent('tracker:callbackVehicles')
AddEventHandler('tracker:callbackVehicles', function(Bliptab)
	--Remove all blips
	for i=0, #lastBliptab, 1 do
		RemoveBlip(lastBliptab[i])
	end
	lastBliptab = {}

	--Add blips
	for i=1, #Bliptab, 1 do
		local blip = AddBlipForCoord(Bliptab[i].x, Bliptab[i].y, Bliptab[i].z)
		SetBlipDisplay(blip, 2)

		if Bliptab[i].type == 'car' then
			SetBlipSprite(blip, Config.Blip.Vehicles)

		elseif Bliptab[i].type == 'helicopter' then
			SetBlipSprite(blip, Config.Blip.Helicopters)
			SetBlipColour(blip, Config.Blip.HelicoptersColor)

		elseif Bliptab[i].type == 'bike' then
			SetBlipSprite(blip, Config.Blip.Bikes)
		end
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(Bliptab[i].plate)
		EndTextCommandSetBlipName(blip)
		table.insert(lastBliptab, blip)
	end
end)