------------------------------------
------------------------------------
----    File : client.lua       ----
----    Author: gassastsina     ----
----	Side : client 		 	----
----    Description : Fourrière ----
------------------------------------
------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	local blip = AddBlipForCoord(Config.Zones.Menu.x, Config.Zones.Menu.y, Config.Zones.Menu.z)
  	SetBlipSprite (blip, 88)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.0)
  	SetBlipColour (blip, 56)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('Fourrière')
  	EndTextCommandSetBlipName(blip)
end)


-----------------------------------------------main-------------------------------------------------------
Citizen.CreateThread(function()
	Wait(5000)
	local isInMarker = false
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		if Vdist(coords.x, coords.y, coords.z, Config.Zones.Menu.x, Config.Zones.Menu.y, Config.Zones.Menu.z) < Config.DrawDistance then
			if not isInMarker then
				DrawMarker(1, Config.Zones.Menu.x, Config.Zones.Menu.y, Config.Zones.Menu.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
			if Vdist(coords.x, coords.y, coords.z, Config.Zones.Menu.x, Config.Zones.Menu.y, Config.Zones.Menu.z) < Config.MarkerSize.x then
				if not isInMarker then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour regarder les véhicules")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				end
				if not isInMarker and IsControlJustPressed(1, 38) then
					ESX.TriggerServerCallback('impound:getVehicles', function(vehicles)
						local elements = {}
						for i=1, #vehicles, 1 do
							if vehicles[i].decode.plate ~= nil then
								table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].decode.model) .. ' [' .. vehicles[i].decode.plate .. ']', value = vehicles[i].decode, encode = vehicles[i].encode})
							else
								table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].decode.model) .. ' [INCONNUE]', value = vehicles[i].decode, encode = vehicles[i].encode})
							end
						end
						isInMarker = true
						ESX.UI.Menu.CloseAll()
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impound_menu', {
								title    = 'Fourrière',
								elements = elements,
							},
							function(data, menu)
							  	menu.close()
								local vehicleProps = data.current.value
								ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.SpawnPoint, Config.Zones.Heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
									TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
									if vehicleProps.plate ~= nil then
										TriggerEvent('esx_key:getVehiclesKey', vehicleProps.plate)
									end
									TriggerEvent("advancedFuel:setEssence", 40, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
									ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
										TriggerServerEvent('impound:removeVehicle', data.current.encode, vehicles)
									end)
								end)
							end,
							function(data, menu)
							  menu.close()
							  isInMarker = false
							end
						)
					end)
				end
			elseif isInMarker then
				isInMarker = false
			end
        end
  	end
end)