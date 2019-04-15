--------------------------------------------------------
--------------------------------------------------------
----    File : extras.lua                           ----
----    Author: gassastsina & ElisOu                ----
----	Side : client 								----
----    Description : Gère les extras d'un véhicule ----
--------------------------------------------------------
--------------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX 					= nil
local PlayerData 		= {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-----------------------------------------------main-------------------------------------------------------
Citizen.CreateThread(function()  
	while true do
		Wait(10)
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                local coords = GetEntityCoords(GetPlayerPed(-1), true)
                local pos = Config.PoliceStations['LSPD'].Extras

                if Vdist(coords.x, coords.y, coords.z, pos.x, pos.y, pos.z) < Config.DrawDistance then
                    DrawMarker(Config.MarkerType, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2, 2, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                    
                    if Vdist(coords.x, coords.y, coords.z, pos.x, pos.y, pos.z) < Config.MarkerSize.x then
                        SetTextComponentFormat('STRING')
                        AddTextComponentString('Appuyez sur ~INPUT_CONTEXT~ pour gérer votre véhicule')
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        if IsControlJustPressed(1, 38) then
						    local elements = {}
						    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
						    for i=0, 14, 1 do
						        if DoesExtraExist(vehicle, i) then
						            table.insert(elements, {label = 'Extra '..i, value = i})
						        end
						    end

						    ESX.UI.Menu.CloseAll()
						    ESX.UI.Menu.Open(
						        'default', GetCurrentResourceName(), 'name',
						        {
						            title    = 'Gestion du véhicule',
						            elements = elements
						        },
						        function(data, menu)
						            if IsVehicleExtraTurnedOn(vehicle, data.current.value) then
						                SetVehicleExtra(vehicle, data.current.value, 1)
						            else
						                SetVehicleExtra(vehicle, data.current.value, 0)
						            end
						        end,
						        function(data, menu)
						            menu.close()
						        end
						    )
                        end
                    end
                end
            end
		end
	end
end)