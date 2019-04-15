-----------------------------------
-----------------------------------
----    File : client.lua      ----
----    Author : gassastsina   ----
----    Side : client          ----
----    Description : Trackers ----
-----------------------------------
-----------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end
end)

-----------------------------------------------main------------------------------------------------------
local function GetVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

RegisterNetEvent('tracker:setTarget')
AddEventHandler('tracker:setTarget', function()
	local coords 		= GetEntityCoords(GetPlayerPed(-1), true)
	local vehicle 		= GetVehicleInDirection(coords, GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 10.000, 0.0 )) or ESX.Game.GetClosestVehicle()
	local vehicleCoords = GetEntityCoords(vehicle, true)
	if vehicle ~= nil and Vdist(coords.x, coords.y, coords.z, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z) < 2.0 then
		SetEntityAsMissionEntity(vehicle)
		TriggerEvent('pNotify:SetQueueMax', "left", 1)
		TriggerEvent('pNotify:SendNotification', {
		    text = "Balise placée",
		    type = "success",
		    timeout = 3000,
		    layout = "centerLeft",
		    queue = "left"
		})
		TriggerEvent('mtracker:settargets', vehicle)
		TriggerServerEvent('tracker:removeTracker')
	else
		ESX.ShowNotification("~r~Vehicle introuvable")
	end
end)