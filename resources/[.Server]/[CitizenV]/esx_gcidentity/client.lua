--====================================================================================
-- #Author: Jonathan D @ Gannon
-- #Edited: Chubbs (ADRP)
--====================================================================================

-----------------------------------------
-----------------------------------------
----    File : client.lua       	 ----
----    Author : Jonathan D @ Gannon ----
----    Edited 1 by : Chubbs (ADRP)	 ----
----    Edited 2 by : gassastsina 	 ----
----    Side : client         		 ----
----    Description : Identity 		 ----
-----------------------------------------
-----------------------------------------

-- Configuration
local KeyToucheClose = 177 -- PhoneCancel
local distMaxCheck = 3
-- Variable | 0 close | 1 Identity | 2 register
local menuIsOpen = 0
 
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if menuIsOpen ~= 0 then
      if IsControlJustPressed(1, KeyToucheClose) and menuIsOpen == 1 then
        closeGui()
      elseif menuIsOpen == 2 then
        local ply = GetPlayerPed(-1)
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisablePlayerFiring(ply, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 106, true)
        DisableControlAction(0,KeyToucheClose,true)
        if IsDisabledControlJustReleased(0, 142) then
          SendNUIMessage({method = "clickGui"})
        end
      end
    end
  end
end)

--====================================================================================
--  User Event
--====================================================================================
RegisterNetEvent("esx_gcidentity:showOtherItentity")
AddEventHandler("esx_gcidentity:showOtherItentity", function()
    local t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent('gc:openIdentity', GetPlayerServerId(t))
    end
end)

--====================================================================================
--  Gestion des evenements Server
--====================================================================================
RegisterNetEvent("gc:showItentity")
AddEventHandler("gc:showItentity", function(data, ped)
  	if ped == 'me' then
  		ped = GetPlayerPed(-1)
  	else
  		ped = GetPlayerPed(GetPlayerFromServerId(ped))
  	end
	local handle = RegisterPedheadshot(ped)
	while not IsPedheadshotReady(handle) do
		Wait(100)
	end
	local headshot = GetPedheadshotTxdString(handle)
  	openGuiIdentity(data)
	while menuIsOpen == 1 and not IsControlJustPressed(1, KeyToucheClose) do
		Wait(10)
		DrawSprite(headshot, headshot, 0.713, 0.225, 0.055, 0.120, 0.0, 255, 255, 255, 1000)
	end
end)


--====================================================================================
--  Gestion UI
--====================================================================================
function openGuiIdentity(data)
  --SetNuiFocus(true)
  SendNUIMessage({method = 'openGuiIdentity',  data = data})
  Citizen.Trace('Data : ' .. json.encode(data))
  menuIsOpen = 1
end


function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end
 
--====================================================================================
--  Utils function
--====================================================================================
function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
  local players = GetPlayers()
  local closestDistance = -1
  local closestPlayer = -1
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  
  for index,value in ipairs(players) do
    local target = GetPlayerPed(value)
    if(target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
      if(closestDistance == -1 or closestDistance > distance) then
        closestPlayer = value
        closestDistance = distance
      end
    end
  end
  
  return closestPlayer, closestDistance
end
