ESX                           = nil
local PlayerData              = {}
Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
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

--Config
local timer = 1 --in minutes - Set the time during the player is outlaw
local showOutlaw = true --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = false --Set if show when player do carjacking
local meleeAlert = false --Set if show when player fight in melee
local blipGunTime = 40 --in second
local blipMeleeTime = 2 --in second
local blipJackingTime = 30 -- in second
local showcopsmisbehave = true  --show notification when cops steal too
--End config

local timing = timer * 60000 --Don't touche it

--GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        Notify(alert)
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
            return
        end
    end
end)

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(tx, ty, tz)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if carJackingAlert then
			local transT = 250
			local thiefBlip = AddBlipForCoord(tx, ty, tz)
			SetBlipSprite(thiefBlip,  10)
			SetBlipColour(thiefBlip,  1)
			SetBlipAlpha(thiefBlip,  transT)
			SetBlipAsShortRange(thiefBlip,  1)
			while transT ~= 0 do
				Wait(blipJackingTime * 4)
				transT = transT - 1
				SetBlipAlpha(thiefBlip,  transT)
				if transT == 0 then
					SetBlipSprite(thiefBlip,  2)
					return
				end
			end
			
		end
	end
end)

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(gx, gy, gz)
	if gunshotAlert then
		local transG = 250
		local gunshotBlip = AddBlipForCoord(gx, gy, gz)
		SetBlipSprite(gunshotBlip,  10)
		SetBlipColour(gunshotBlip,  1)
		SetBlipAlpha(gunshotBlip,  transG)
		SetBlipAsShortRange(gunshotBlip,  false)
		while transG ~= 0 do
			Wait(blipGunTime * 4)
			transG = transG - 1
			SetBlipAlpha(gunshotBlip,  transG)
			if transG == 0 then
				SetBlipSprite(gunshotBlip,  2)
				return
			end
		end
	   
	end
end)

--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue]]

-- Citizen.CreateThread( function()
    -- while true do
        -- Wait(0)
        -- if showOutlaw then
            -- for i = 0, 31 do
				-- if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
					-- if DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 2 and GetPlayerPed(i) ~= GetPlayerPed(-1) then
						-- gamerTagId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(i), ".", false, false, "", 0 )
						-- Citizen.InvokeNative(0xCF228E2AA03099C3, gamerTagId, 0) --Show a star
						-- Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, true) --Active gamerTagId
						-- Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 1) --White star
					-- elseif DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 1 then
						-- Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 255) -- Set Color to 255
						-- Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, false) --Unactive gamerTagId
					-- end
				-- end
            -- end
        -- end
    -- end
-- end)

Citizen.CreateThread( function()
    while true do
        Wait(100)
        if DecorGetInt(GetPlayerPed(-1), "IsOutlaw") == 2 then
            Wait( math.ceil(timing) )
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
        end
    end
end)

--[[Citizen.CreateThread(function()
    while true do
        Wait(0)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
	        	local peds   = ESX.Game.GetPeds()
				for i=1, #peds, 1 do
					if IsPedHuman(peds[i]) and not IsPedAPlayer(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(peds[i], true), GetEntityCoords(GetPlayerPed(-1), true), true) < 80 then
						bool = true
						break
					end
				end
			if bool then
				TriggerServerEvent('eden_garage:debug', "carjacking!")
				Wait(3000)
				DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)
				local vehicle =GetVehiclePedIsIn(playerPed,false)
				local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
				if PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave == false then
				elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave then
					ESX.TriggerServerCallback('esx_outlawalert:ownvehicle',function(valid)
						if (valid) then
						else
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
								local sex = nil
								if skin.sex == 0 then
									sex = "un homme"
								else
									sex = "une femme"
								end
								TriggerServerEvent('thiefInProgressPos', plyPos.x, plyPos.y, plyPos.z)
								local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
								local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
								local vehName2 = GetLabelText(vehName)
								if s2 == 0 then
									if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
										TriggerServerEvent('thiefInProgressS1police', street1, vehName2, sex)
									else
										TriggerServerEvent('thiefInProgressS1', street1, vehName2, sex)
									end
								elseif s2 ~= 0 then
									if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
										TriggerServerEvent('thiefInProgressPolice', street1, street2, vehName2, sex)
									else
										TriggerServerEvent('thiefInProgress', street1, street2, vehName2, sex)
									end
								end
							end)
						end
					end, vehicleProps)
				else
					ESX.TriggerServerCallback('esx_outlawalert:ownvehicle',function(valid)
						if (valid) then
						else
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
								local sex = nil
								if skin.sex == 0 then
									sex = "un homme"
								else
									sex = "une femme"
								end
								TriggerServerEvent('thiefInProgressPos', plyPos.x, plyPos.y, plyPos.z)
								local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
								local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
								local vehName2 = GetLabelText(vehName)
								if s2 == 0 then
									TriggerServerEvent('thiefInProgressS1', street1, vehName2, sex)
								elseif s2 ~= 0 then
									TriggerServerEvent('thiefInProgress', street1, street2, vehName2, sex)
								end
							end)
						end
					end,vehicleProps)
				end
			end
        end
    end
end)]]

local AmmuNations = {}
local function AmmuNation(coords)
	for i=1, #AmmuNations, 1 do
		if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, AmmuNations[i].x, AmmuNations[i].y, AmmuNations[i].z, false) < 30.0 then
			return true
		end
	end
	return false
end

Citizen.CreateThread( function()
	Wait(20000)
	while ESX == nil do Wait(100) end
	ESX.TriggerServerCallback('esx_outlawalert:getAmmuNationsCoords', function(coords)
		AmmuNations = coords
	end)
	local distance = 0
    while true do
        Wait(5)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        --local bool = false -- GET_CURRENT_PED_WEAPON
        if IsPedShooting(GetPlayerPed(-1))  then
        	local peds   = ESX.Game.GetPeds()
        	if IsPedCurrentWeaponSilenced(GetPlayerPed(-1),true) then
        		distance = 50
        		local jeweleryCorods = {x = -622.254, y = -231.004, z = 38.000}
        		if Vdist(GetEntityCoords(GetPlayerPed(-1), false), jeweleryCorods.x, jeweleryCorods.y, jeweleryCorods.z) <= 10.0 then
        			distance = 0
        		end
        	else
        		distance = 100
        	end
        	--if not GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_Molotov',true) and not GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_MACHETE',true) and not  GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_Knife',true) and not GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_Bat',true) and not GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_KNUCKLE',true) and not GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_Flashlight',true) and not GetCurrentPedWeapon(GetPlayerPed(-1),'WEAPON_FIREEXTINGUISHER',true) then
				for i=1, #peds, 1 do
					if IsPedHuman(peds[i]) and not IsPedAPlayer(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(peds[i], true), GetEntityCoords(GetPlayerPed(-1), true), true) < distance then
						   --DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
							--if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and not AmmuNation(plyPos) then
								local sex = 'une personne'
								TriggerServerEvent('gunshotInProgressPos', plyPos.x, plyPos.y, plyPos.z)
								if s2 == 0 then
									TriggerServerEvent('gunshotInProgressS1', street1, sex)
								elseif s2 ~= 0 then
									TriggerServerEvent("gunshotInProgress", street1, street2, sex)
								end
							--end
						break
					end
				end
			--end
        end
    end
end)