--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----    File : client.lua                                                   ----
----    Author : gassastsina                                                ----
----	Side : client 														----
----    Description : Alerte la police quand un joueur rentre dans une zone ----
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
local PlayerData                = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(50)
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
local inZone = {}
Citizen.CreateThread(function()
    Wait(1000)
	while true do
		Wait(3000)
        local coords = GetEntityCoords(GetPlayerPed(-1), false)
        for i=1, #Config.Zones, 1 do
            if Vdist(coords.x, coords.y, coords.z, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z) < Config.Zones[i].Distance then
                if not inZone[i] then
                    inZone[i] = true

                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) or IsPedInAnyHeli(GetPlayerPed(-1)) then
                    	local vehicle = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                        if  (vehicle ~= GetHashKey('ambulance') and vehicle ~= GetHashKey('policeold2') or Config.Zones[i].label ~= 'Humane Labs and Research')
                        and vehicle ~= GetHashKey('polmav')
                        and (vehicle ~= GetHashKey('jet') or Config.Zones[i].label ~= 'Los Santos Airport')
                        and not IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
                            callPolice(i)
                        end
                    else
                        callPolice(i)
                    end
					TriggerServerEvent('logs:write', "Est rentré dans : "..Config.Zones[i].label)
                end
            elseif inZone[i] then
                inZone[i] = false
            end
        end
  	end
end)

function callPolice(i)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin.sex == 0 then
            TriggerServerEvent('forbidenZones:enterInZone', "Homme", i)
        elseif skin.sex == 1 then
            TriggerServerEvent('forbidenZones:enterInZone', "Femme", i)
        end
    end)
end

RegisterNetEvent('forbidenZones:enterInZone')
AddEventHandler('forbidenZones:enterInZone', function(sex, i)
    SetNotificationTextEntry("STRING");
    AddTextComponentString("Une personne s'est approchée d'une zone interdite");
    SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, Config.Zones[i].label, sex, "Une personne s'est approchée d'une zone interdite");
    DrawNotification(true, false)
end)