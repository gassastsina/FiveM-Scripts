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
--[[
    File: emotemenu.lua
    Author: Kévin "Boby" cinquini
    Description: animationmap + phone

    Edited by : gassastsina
--]]

------------------------------------------------------------------ESX----------------------------------------------------------------------------
ESX           = nil
local PlayerData    = {}
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

------------------------------------------------------------------main---------------------------------------------------------------------------
Citizen.CreateThread(function()
	local animMap = false
	local BigMap = 1
	while true do
		Wait(10)
---------------------------------------------map----------------------------------------
		if not animMap then
			if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 199) then
				if not IsPedInAnyVehicle(GetPlayerPed(PlayerId()), true) then
					TaskStartScenarioInPlace(GetPlayerPed(PlayerId()), "WORLD_HUMAN_TOURIST_MAP", 0, true)
					animMap = true
				end
			end
		end
		if animMap then
			if IsControlJustPressed(0, 32) or IsControlJustPressed(0, 8) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 9) then
				ClearPedTasks(GetPlayerPed(PlayerId()))
				--SetPedToRagdoll(GetPlayerPed(PlayerId()), 1, 1, 2, true, true, false)
				animMap = false
			end
		end
---------------------------------------------radio----------------------------------------

		if IsControlJustPressed(0, 170) then
			if not IsPlayerFreeAiming(PlayerId()) then
				while not HasAnimDictLoaded('random@arrests') do
					RequestAnimDict('random@arrests')
					Citizen.Wait(100)
				end
				TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
			end
			SendNUIMessage({
		        transactionType     = 'playSound',
		        transactionFile     = 'on',
		        transactionVolume   = 0.1
		    })


		elseif IsControlJustReleased(0, 170) then
			ClearPedTasks(GetPlayerPed(-1))
			SendNUIMessage({
		        transactionType     = 'playSound',
		        transactionFile     = 'off',
		        transactionVolume   = 0.1
		    })
		end
---------------------------------------------photo----------------------------------------
		if IsControlJustPressed(0, 288) then
			if not IsPedInAnyVehicle(GetPlayerPed(PlayerId()), true) then
				TaskStartScenarioInPlace(GetPlayerPed(PlayerId()), "WORLD_HUMAN_MOBILE_FILM_SHOCKING", 0, true)
				Wait(2000)
				ClearPedTasks(GetPlayerPed(PlayerId()))
			end
		end
---------------------------------------------GigMap----------------------------------------
		if IsControlJustPressed(1, 20) then
			if BigMap < 3 then
				BigMap = BigMap + 1
			else
				BigMap = 1
			end

			if BigMap == 1 then
				SetRadarBigmapEnabled(false, false)
				TriggerEvent('esx:ShowHUD', true, 1.0, false)
			elseif BigMap == 2 then
				SetRadarBigmapEnabled(true, false)
				TriggerEvent('esx:ShowHUD', false, 0.0, false)
			elseif BigMap == 3 then
				SetRadarBigmapEnabled(true, true)
			end
		end
	end	
end)

----------------------------------HOLD WEAPON HOLSTER ANIMATION----------------------------
Citizen.CreateThread( function()
	while true do 
		Citizen.Wait(30)
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local ped = PlayerPedId()
			if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(PlayerPedId(), true) and not IsPlayerFreeAiming(PlayerId()) then
				if IsControlJustPressed(0, 167) then
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
					while not HasAnimDictLoaded('reaction@intimidation@cop@unarmed') do
						RequestAnimDict('reaction@intimidation@cop@unarmed')
						Citizen.Wait(100)
					end
					TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
					
					while not IsControlJustReleased(0, 167) do
						Wait(0)
						if IsControlJustPressed(1, 24) or IsControlJustPressed(1, 25) then
							if checkIfGotWeapon("WEAPON_COMBATPISTOL") then
								SetCurrentPedWeapon(ped, GetHashKey("WEAPON_COMBATPISTOL"), true)
							elseif checkIfGotWeapon("WEAPON_PISTOL") then
								SetCurrentPedWeapon(ped, GetHashKey("WEAPON_PISTOL"), true)
							else
								SetCurrentPedWeapon(ped, GetBestPedWeapon(ped, 0), true)
							end
							DisableControlAction(0, 24, false)
							break
						end
					end
					ClearPedTasks(ped)
				end
			end
		end
	end
end)

function checkIfGotWeapon(weapon)
	for i=1, #PlayerData.loadout, 1 do
		if PlayerData.loadout[i].name == weapon then
			return true
		end
	end
	return false
end

----------------------------------HOLSTER/UNHOLSTER PISTOL----------------------------
Citizen.CreateThread(function()
	local getWeapon = false
	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local ped = PlayerPedId()
			if DoesEntityExist( ped ) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) then
				if (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPISTOL")) then
					if getWeapon then
						flicWeaponAnimation()
						getWeapon = false
					end
				elseif not (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPISTOL")) then
					if not getWeapon then
						flicWeaponAnimation()
						getWeapon = true
					end
				end
			end
		end
	end
end)

function flicWeaponAnimation()
	while not HasAnimDictLoaded('rcmjosh4') do
		RequestAnimDict('rcmjosh4')
		Citizen.Wait(0)
	end
	TaskPlayAnim(GetPlayerPed(-1), "rcmjosh4", "josh_leadout_cop2", 500.0, 5.0, -1, 48, 10, 0, 0, 0 )
	Citizen.Wait(600)
	ClearPedTasks(GetPlayerPed(-1))
end

-------------------------------------------------------------------------------------------
--[[
--arest annim
local annimarest = false
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustPressed(0, 157) then
			TriggerEvent('KneelHU')
			Wait(6000)
		end
	end
end)]]

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


AddEventHandler( 'KneelHU', function()

   local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) and not IsPedInAnyVehicle(GetPlayerPed(PlayerId()), true) then 
        loadAnimDict( "random@arrests" )
		loadAnimDict( "random@arrests@busted" )
		if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then
			TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (3000)
            TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
            Wait(2000)
            annimarest = false
        else
        	annimarest = true
            TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (4000)
            TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (500)
			TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
        end     
    end
end )

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_a", 3) or annimarest  then
			DisableControlAction(0, 323, true)
			DisableControlAction(1, Keys["ESC"], true)
			--[[DisableControlAction(1, Keys["F2"], true)
			DisableControlAction(1, Keys["F3"], true)
			DisableControlAction(1, Keys["F5"], true)
			DisableControlAction(1, Keys["F6"], true)
			DisableControlAction(1, Keys["F7"], true)
			DisableControlAction(1, Keys["F8"], true)
			DisableControlAction(1, Keys["F9"], true)
			DisableControlAction(1, Keys["F10"], true)
			DisableControlAction(1, Keys["~"], true)
			DisableControlAction(1, Keys["1"], true)
			DisableControlAction(1, Keys["2"], true)
			DisableControlAction(1, Keys["3"], true)
			DisableControlAction(1, Keys["4"], true)
			DisableControlAction(1, Keys["5"], true)
			DisableControlAction(1, Keys["6"], true)
			DisableControlAction(1, Keys["7"], true)
			DisableControlAction(1, Keys["8"], true)
			DisableControlAction(1, Keys["9"], true)
			DisableControlAction(1, Keys["-"], true)
			DisableControlAction(1, Keys["="], true)]]
			DisableControlAction(1, Keys["BACKSPACE"], true)
			--DisableControlAction(1, Keys["TAB"], true)
			DisableControlAction(1, Keys["Q"], true)
			--DisableControlAction(1, Keys["W"], true)
			DisableControlAction(1, Keys["E"], true)
			DisableControlAction(1, Keys["R"], true)
			DisableControlAction(1, Keys["T"], true)
			--DisableControlAction(1, Keys["Y"], true)
			DisableControlAction(1, Keys["U"], true)
			DisableControlAction(1, Keys["P"], true)
			--[[DisableControlAction(1, Keys["["], true)
			DisableControlAction(1, Keys["]"], true)
			DisableControlAction(1, Keys["ENTER"], true)
			DisableControlAction(1, Keys["LEFTSHIFT"], true)]]
			DisableControlAction(1, Keys["Z"], true)
			DisableControlAction(1, Keys["X"], true)
			--[[DisableControlAction(1, Keys["C"], true)
			DisableControlAction(1, Keys["V"], true)
			DisableControlAction(1, Keys["B"], true)]]
			DisableControlAction(1, Keys["M"], true)
			--[[DisableControlAction(1, Keys[","], true)
			DisableControlAction(1, Keys["."], true)
			DisableControlAction(1, Keys["LEFTCTRL"], true)
			DisableControlAction(1, Keys["LEFTALT"], true)
			DisableControlAction(1, Keys["SPACE"], true)
			DisableControlAction(1, Keys["RIGHTCTRL"], true)
			DisableControlAction(1, Keys["HOME"], true)
			DisableControlAction(1, Keys["PAGEUP"], true)
			DisableControlAction(1, Keys["PAGEDOWN"], true)
			DisableControlAction(1, Keys["DELETE"], true)
			DisableControlAction(1, Keys["LEFT"], true)
			DisableControlAction(1, Keys["RIGHT"], true)
			DisableControlAction(1, Keys["TOP"], true)
			DisableControlAction(1, Keys["DOWN"], true)
			DisableControlAction(1, Keys["NENTER"], true)
			DisableControlAction(1, Keys["N4"], true)
			DisableControlAction(1, Keys["N5"], true)
			DisableControlAction(1, Keys["N6"], true)
			DisableControlAction(1, Keys["N+"], true)
			DisableControlAction(1, Keys["N-"], true)
			DisableControlAction(1, Keys["N7"], true)
			DisableControlAction(1, Keys["N8"], true)
			DisableControlAction(1, Keys["N9"], true)]]
		end
	end
end)