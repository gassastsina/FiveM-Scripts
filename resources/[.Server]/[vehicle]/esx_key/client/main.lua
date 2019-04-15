-------------------------------------------------------------------------
--							By Vakeros								   --
--							#Version 1.00			   				   --
--							#lastEdit 01/09/17					       -- 
-------------------------------------------------------------------------



local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX               = nil
local key = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_key:getVehiclesKey', function(newkey) -- Sorti du garage
	local i = #key
	local duplicatekey = false
	while i>=0 do
		Wait(50)
		if newkey == key[i] then
			duplicatekey = true
			break
		end
		i = i -1
	end
	if duplicatekey == false then
		table.insert(key, newkey)
		TriggerEvent('esx_key:giveVehiclesKey', key)
	end
end)
AddEventHandler('giveKeyAtKeyMaster', function(newkey) -- donner clé
 	table.insert(key, newkey)
end)

Citizen.CreateThread(function()
	while true do
		local distance = 10
		Citizen.Wait(18)
		local player = GetPlayerPed(-1)
		if IsControlJustPressed(0,  Keys["U"]) then
			local playerPos = GetEntityCoords( GetPlayerPed(-1), 1 )
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(PlayerId())))

		 	local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( GetPlayerPed(-1), 0.0, 10.000, 0.0 )
			local v = GetVehicleInDirection( playerPos, inFrontOfPlayer )
			if not DoesEntityExist(v) then
				v = GetVehiclePedIsIn(player, true)
				local vX,vY,vZ = table.unpack(GetEntityCoords(v,1))
				if DoesEntityExist(v) then
					  distance  = GetDistanceBetweenCoords(x,y, z, vX, vY, vZ, true)
				end
			else
				distance = 1
			end
			if DoesEntityExist(v) and distance < 3  then
              	local currentPlate = GetVehicleNumberPlateText(v)
         
              	local i = #key
         		--Citizen.Trace(key[1].."  "..currentPlate)
              	while i > 0 do -- ouais ouasi boucle while j'ai un bug chelou avec la for mais la while ca marche nickel
              		Wait(50)
              		if key[i] == currentPlate then
              			local lockStatus = GetVehicleDoorLockStatus(v)
              			if lockStatus == 1 or lockStatus == 0 then
              				lockStatus = SetVehicleDoorsLocked(v, 2)
                       		SetVehicleDoorsLockedForPlayer(v, PlayerId(), false)
							SendNUIMessage({
						        transactionType     = 'playSound',
						        transactionFile     = 'lock',
						        transactionVolume   = 0.1
						    })
                       		Notify("~r~Vehicule fermer")
							TriggerServerEvent('logs:write', 'Ferme son véhicule ('..currentPlate..')')
              			else
              				lockStatus = SetVehicleDoorsLocked(v, 1)
							SendNUIMessage({
						        transactionType     = 'playSound',
						        transactionFile     = 'unlock',
						        transactionVolume   = 0.1
						    })
              				Notify("~g~Vehicule ouvert")
							TriggerServerEvent('logs:write', 'Ouvre son véhicule ('..currentPlate..')')
              			end
              			break
              		end
              		i = i-1
				end
            else
            	Notify("Aucun vehicule proche de vous")
            end
		end
	end
end)

function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end