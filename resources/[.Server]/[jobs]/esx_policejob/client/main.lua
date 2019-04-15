--------------------------------------
--------------------------------------
----    File : main.lua  		  ----
----    Edited by : gassastsina   ----
----    Side : client        	  ----
----    Description : Main Police ----
--------------------------------------
--------------------------------------

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

local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
GUI.Time                        = 0

--------------------------------------------ESX----------------------------------------------------------
ESX                             = nil
local PlayerData                = {}

Citizen.CreateThread(function()
  while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
  end
end)

--------------------------------------------main---------------------------------------------------------
function SetVehicleMaxMods(vehicle)

  local props = {
	modEngine       = 2,
	modBrakes       = 2,
	modTransmission = 2,
	modSuspension   = 3,
	modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function cleanPlayer(playerPed)
  SetPedArmour(playerPed, 0)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

local function setPoliceWear()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local playerPed = GetPlayerPed(-1)
		if PlayerData.job.grade_name == 'cadet-confirme' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 35, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 58, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 0, 0, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque

				SetPedArmour(playerPed, 75)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 61, 9, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 24, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 152, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 31, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 48, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 75)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end

	  	elseif PlayerData.job.grade_name == 'officer' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 35, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 122, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 0, 0, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end

			elseif PlayerData.job.grade_name == 'detective' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 35, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 122, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 0, 0, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end

			elseif PlayerData.job.grade_name == 'sergeant' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 35, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 122, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 0, 0, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end

	  	elseif PlayerData.job.grade_name == 'sergent-chef' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 31, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 122, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 0, 0, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				SetPedComponentVariation(playerPed, 10, 8, 1, 0)--calques

				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end

	  	elseif PlayerData.job.grade_name == 'lieutenant' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 31, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 122, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 27, 9, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				SetPedComponentVariation(playerPed, 10, 8, 2, 0)--calques

				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end

	  	elseif PlayerData.job.grade_name == 'boss' then

			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 31, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 130, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 27, 9, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				SetPedComponentVariation(playerPed, 10, 8, 3, 0)--calques

				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end
		else
			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 35, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 58, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 30, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 0, 0, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 55, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, -1, 0, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 121, 0, 2)--Masque
				
				SetPedArmour(playerPed, 25)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 32, 0, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 25, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 14, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				--SetPedComponentVariation(playerPed, 9, 18, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 46, 0, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 25)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end
		end
	end)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.6)
end

function OpenCloakroomMenu()

  local elements = {
	{label = _U('citizen_wear'), value = 'citizen_wear'},
	{label = _U('police_wear'), value = 'police_wear'},
	{label = _U('intervention_wear'), value = 'intervention_wear'},
	{label = _U('veste_wear'), value = 'veste_wear'},
	{label = _U('gilet_wear'), value = 'gilet_wear'}
  }
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'cloakroom',
	{
	  title    = _U('cloakroom'),
	  elements = elements,
	},
	function(data, menu)
	  menu.close()
	  cleanPlayer(playerPed)

	  if data.current.value == 'citizen_wear' then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		  local model = nil

		  if skin.sex == 0 then
			model = GetHashKey("mp_m_freemode_01")
		  else
			model = GetHashKey("mp_f_freemode_01")
		  end

		  RequestModel(model)
		  while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(1)
		  end

		  SetPlayerModel(PlayerId(), model)
		  SetModelAsNoLongerNeeded(model)

		  TriggerEvent('skinchanger:loadSkin', skin)
		  TriggerEvent('esx:restoreLoadout')
		  local playerPed = GetPlayerPed(-1)
		  SetPedArmour(playerPed, 0)
		  ClearPedBloodDamage(playerPed)
		  ResetPedVisibleDamage(playerPed)
		  ClearPedLastWeaponDamage(playerPed)
		end)
	  end


	  if data.current.value == 'police_wear' then
	  	setPoliceWear()
	  end

	  if data.current.value == 'veste_wear' then

		--ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
			--if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
				--[[SetPedComponentVariation(GetPlayerPed(-1), 9, 6, 1, 2)--Gilet
				local playerPed = GetPlayerPed(-1)
				SetPedArmour(playerPed, 100)
				--SetEntityHealth(playerPed, 200)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else]]
				local playerPed = GetPlayerPed(-1)
				SetPedComponentVariation(playerPed, 9, 26, 9, 2)--Gilet
				SetPedArmour(playerPed, 100)
				--SetEntityHealth(playerPed, 200)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			--end
		--end)
	  end

	  if data.current.value == 'gilet_wear' then

		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
		
		  SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)--Sans Gilet
		  local playerPed = GetPlayerPed(-1)
		  SetPedArmour(playerPed, 0)
		  ClearPedBloodDamage(playerPed)
		  ResetPedVisibleDamage(playerPed)
		  ClearPedLastWeaponDamage(playerPed)
		end)
	  end
	  if data.current.value == 'intervention_wear' then
	  
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

			local playerPed = GetPlayerPed(-1)
			if skin.sex == 0 then
				SetPedComponentVariation(playerPed, 4, 97, 18, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 24, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 130, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 17, 0, 0)--bras
				SetPedComponentVariation(playerPed, 9, 16, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 221, 24, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				--SetPedPropIndex(playerPed, 1, 0, 0, 1)--Lunette
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			else
				SetPedComponentVariation(playerPed, 4, 100, 18, 0)--Jean
				SetPedComponentVariation(playerPed, 6, 24, 0, 0)--Chaussure
				SetPedComponentVariation(playerPed, 8, 160, 0, 0)--Sous pull
				SetPedComponentVariation(playerPed, 3, 18, 0, 0)--bras
				SetPedComponentVariation(playerPed, 9, 17, 2, 2)--Gilet pare boule
				SetPedComponentVariation(playerPed, 11, 231, 24, 0)--Veste
				SetPedPropIndex(playerPed, 0, 59, 9, 1)--Chapeau
				--SetPedPropIndex(playerPed, 1, 27, 4, 1)--Lunette
				SetPedComponentVariation(playerPed, 1, 56, 1, 2)--Masque
				
				SetPedArmour(playerPed, 100)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
			end		
		end)
	  end
	  SetPedAsCop(GetPlayerPed(-1), true)
	  
	  CurrentAction     = 'menu_cloakroom'
	  CurrentActionMsg  = _U('open_cloackroom')
	  CurrentActionData = {}

	end,
	function(data, menu)

	  menu.close()

	  CurrentAction     = 'menu_cloakroom'
	  CurrentActionMsg  = _U('open_cloackroom')
	  CurrentActionData = {}
	end
  )

end

function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then

	local elements = {
	  {label = _U('get_weapon'), value = 'get_weapon'},
	  {label = _U('put_weapon'), value = 'put_weapon'},
	  {label = 'Prendre Objet',  value = 'get_stock'},
	  {label = 'Déposer Objet',  value = 'put_stock'}
	}

	if PlayerData.job.grade_name == 'boss' then
	  table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
	  table.insert(elements, {label = _U('weaponcategorie3'), value = 'addcategorie3'})
	  table.insert(elements, {label = 'Prendre Objet Illégal',  value = 'get_stock2'})
	  table.insert(elements, {label = 'Déposer Objet Illégal',  value = 'put_stock2'})
	  table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory',
	  {
		title    = _U('armory'),
		elements = elements,
	  },
	  function(data, menu)

		local player, distance = ESX.Game.GetClosestPlayer()

		if data.current.value == 'get_weapon' then
		  OpenGetWeaponMenu()
		end

		if data.current.value == 'put_weapon' then
		  OpenPutWeaponMenu()
		end

		if data.current.value == 'buy_weapons' then
		  OpenBuyWeaponsMenu(station)
		end

		if data.current.value == 'put_stock' then
		  OpenPutStocksMenu()
		end

		if data.current.value == 'get_stock' then
		  OpenGetStocksMenu()
		end
	
	if data.current.value == 'put_stock2' then
		  OpenPutStocksMenu2()
		end

		if data.current.value == 'get_stock2' then
		  OpenGetStocksMenu2()
		end

	if data.current.value == 'boss_actions' then
		TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
			menu.close()
		end)
	end
	

		if data.current.value == 'addcategorie3' then
			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('esx_policejob:addcategorie3', GetPlayerServerId(player))
			else
		  		ESX.ShowNotification(_U('no_players_nearby'))
		  	end
		end

	  end,
	  function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	  end
	)

  else

	local elements = {}

	for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
	  local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
	  table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory',
	  {
		title    = _U('armory'),
		elements = elements,
	  },
	  function(data, menu)
		local weapon = data.current.value
		TriggerServerEvent('esx_policejob:giveWeapon', weapon,  1000)
	  end,
	  function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}

	  end
	)

  end

end

function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()
  if Config.EnableSocietyOwnedVehicles then

	local elements = {}
	ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

	  for i=1, #garageVehicles, 1 do
		table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
	  end

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_spawner',
		{
		  title    = _U('vehicle_menu'),
		  elements = elements,
		},
		function(data, menu)
			menu.close()

			local vehicleProps = data.current.value
			ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 90.0, function(vehicle)
			ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
			TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	  		TriggerEvent('esx_key:getVehiclesKey', vehicleProps.plate)
		  end)

		  TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', vehicleProps)

		end,
		function(data, menu)

		  menu.close()

		  CurrentAction     = 'menu_vehicle_spawner'
		  CurrentActionMsg  = _U('vehicle_spawner')
		  CurrentActionData = {station = station, partNum = partNum}

		end
	  )

	end, 'police')

  else

	local elements = {}

	table.insert(elements, { label = 'Vélo', value = 'fixter' })
	table.insert(elements, { label = 'Cruiser', value = 'police' })
	table.insert(elements, { label = 'Sheriff Cruiser', value = 'sheriff' })

	if PlayerData.job.grade_name == 'officer' then
	  table.insert(elements, { label = 'Interceptor', value = 'police3'})
	end

	if PlayerData.job.grade_name == 'sergeant' then
	  table.insert(elements, { label = 'Sheriff SUV', value = 'sheriff2'})
	  table.insert(elements, { label = 'Interceptor', value = 'police3'})
	  table.insert(elements, { label = 'Buffalo', value = 'police2'})
	  table.insert(elements, { label = 'Moto', value = 'policeb'})
	  table.insert(elements, { label = 'Bus pénitentiaire', value = 'pbus'})
	  table.insert(elements, { label = 'Bus de transport', value = 'policet'})
	  table.insert(elements, { label = 'Antiémeute', value = 'riot'})
	end

	if PlayerData.job.grade_name == 'lieutenant' then
	  table.insert(elements, { label = 'Sheriff SUV', value = 'sheriff2'})
	  table.insert(elements, { label = 'Interceptor', value = 'police3'})
	  table.insert(elements, { label = 'Buffalo', value = 'police2'})
	  table.insert(elements, { label = 'Moto', value = 'policeb'})
	  table.insert(elements, { label = 'Bus pénitentiaire', value = 'pbus'})
	  table.insert(elements, { label = 'Bus de transport', value = 'policet'})
	  table.insert(elements, { label = 'Antiémeute', value = 'riot'})
	  table.insert(elements, { label = 'FBI', value = 'fbi'})
	  table.insert(elements, { label = 'FBI SUV', value = 'fbi2'})
	end

	if PlayerData.job.grade_name == 'boss' then
	  table.insert(elements, { label = 'Sheriff SUV', value = 'sheriff2'})
	  table.insert(elements, { label = 'Interceptor', value = 'police3'})
	  table.insert(elements, { label = 'Buffalo', value = 'police2'})
	  table.insert(elements, { label = 'Moto', value = 'policeb'})
	  table.insert(elements, { label = 'Bus pénitentiaire', value = 'pbus'})
	  table.insert(elements, { label = 'Bus de transport', value = 'policet'})
	  table.insert(elements, { label = 'Antiémeute', value = 'riot'})
	  table.insert(elements, { label = 'FBI', value = 'fbi'})
	  table.insert(elements, { label = 'FBI SUV', value = 'fbi2'})
	  table.insert(elements, { label = 'Voiture Banalisée ', value = 'police4'})
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'vehicle_spawner',
	  {
		title    = _U('vehicle_menu'),
		--align    = 'top-left',
		elements = elements,
	  },
	  function(data, menu)

		menu.close()

		local model = data.current.value

		local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

		if not DoesEntityExist(vehicle) then

		  local playerPed = GetPlayerPed(-1)

		  if Config.MaxInService == -1 then

			ESX.Game.SpawnVehicle(model, {
			  x = vehicles[partNum].SpawnPoint.x,
			  y = vehicles[partNum].SpawnPoint.y,
			  z = vehicles[partNum].SpawnPoint.z
			}, vehicles[partNum].Heading, function(vehicle)
			  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			  SetVehicleMaxMods(vehicle)
		  TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			end)

		  else

			ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

			  if canTakeService then

				ESX.Game.SpawnVehicle(model, {
				  x = vehicles[partNum].SpawnPoint.x,
				  y = vehicles[partNum].SpawnPoint.y,
				  z = vehicles[partNum].SpawnPoint.z
				}, vehicles[partNum].Heading, function(vehicle)
				  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				  SetVehicleMaxMods(vehicle)
		  TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				end)

			  else
				ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
			  end

			end, 'police')

		  end

		  Citizen.Wait(2000)
			  TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))

		else
		  ESX.ShowNotification(_U('vehicle_out'))
		end

	  end,
	  function(data, menu)

		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}

	  end
	)
  end
end

function OpenHelicopterSpawnerMenu(station, partNum)
 
	local elements = {}
	local vehicles = Config.PoliceStations[station].Helicopters
 
	for i=1, #Config.PoliceStations[station].AuthorizedHelicopters do
		local vehicle = Config.PoliceStations[station].AuthorizedHelicopters[i]
		elements[#elements+1] = {label = vehicle.label, value = vehicle.name}
	end
 
	ESX.UI.Menu.CloseAll()
 
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'helicopter_spawner',
		{
			title    = _U('helicopter_menu'),
			--align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
 
			menu.close()
 
			local model = data.current.value
 
			local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

			if not DoesEntityExist(vehicle) then
 
				local playerPed = GetPlayerPed(-1)
 
				if Config.MaxInService == -1  then
					ESX.Game.SpawnVehicle(model, {
						x = vehicles[partNum].SpawnPoint.x, 
						y = vehicles[partNum].SpawnPoint.y, 
						z = vehicles[partNum].SpawnPoint.z
					}, vehicles[partNum].Heading, function(vehicle)
						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						SetVehicleMaxMods(vehicle)
						SetVehicleLivery(vehicle, 0)
						TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				
						Citizen.Wait(2000)
				TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
					end)
 
				else
					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if canTakeService then
 
							ESX.Game.SpawnVehicle(model, {
								x = vehicles[partNum].SpawnPoint.x, 
								y = vehicles[partNum].SpawnPoint.y, 
								z = vehicles[partNum].SpawnPoint.z
							}, vehicles[partNum].Heading, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
								SetVehicleMaxMods(vehicle)
								SetVehicleLivery(vehicle, 0)
								TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				
								Citizen.Wait(2000)
					TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
							end)
 
						else
							ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
						end
 
					end, 'police')
				end

			else
				ESX.ShowNotification(_U('helicopter_out'))
			end
 
		end,
		function(data, menu)
 
			menu.close()
 
			CurrentAction     = 'menu_helicopter_spawner'
			CurrentActionMsg  = _U('helicopter_spawner')
			CurrentActionData = {station = station, partNum = partNum}
 
		end
	)
 
end

function OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'police_actions',
	{
	  title    = 'LSPD',
	  elements = {
		{label = _U('citizen_interaction'), value = 'citizen_interaction'},
		{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
		{label = _U('object_spawner'),      value = 'object_spawner'},
	  },
	},
	function(data, menu)

	  if data.current.value == 'citizen_interaction' then

	  	local elements = {
			{label = _U('search'),          value = 'body_search'},
			{label = _U('handcuff'),    	  value = 'handcuff'},
			{label = _U('drag'),      	  value = 'drag'},
			{label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
			{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
			{label = _U('permis_interaction'), value = 'permis_interaction'},
			{label = _U('fine'),            value = 'fine'},
	  		{label = _U('fac'),  			  value = 'billing'},
	  		{label = 'Bracelet électronique', value = 'electro_bracelet'}
		}
		if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'lieutenant' then
			table.insert(elements, {label = 'Distribuer un badge', value = 'badge'})
		end
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'citizen_interaction',
		  {
			title    = _U('citizen_interaction'),
			elements = elements,
		  },
		  function(data2, menu2)

			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then

			  if data2.current.value == 'body_search' then
				OpenBodySearchMenu(GetPlayerServerId(player))
			  end

			  if data2.current.value == 'handcuff' then
				TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
			  end

			  if data2.current.value == 'drag' then
				TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
			  end

			  if data2.current.value == 'put_in_vehicle' then
				TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
			  end

			  if data2.current.value == 'out_the_vehicle' then
				  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
			  end

			  if data2.current.value == 'fine' then
				OpenFineMenu(player)
			  end

			  if data2.current.value == 'electro_bracelet' then
			  	TriggerServerEvent('esx_policejob:ElectroBracelet', GetPlayerServerId(player))
			  end

			  if data2.current.value == 'badge' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = 'Numéro du badge'
					},
					function(data, menu)
						TriggerServerEvent('esx_policejob:setBadgeNumber', GetPlayerServerId(player), tonumber(data.value))
						menu.close()
					end,
					function(data, menu)
						menu.close()
					end
				)
			  end

			  if data2.current.value == 'billing' then

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)
							
						local amount = tonumber(data.value)

						if amount == nil then
							ESX.ShowNotification('Montant ~r~~h~invalide')
						else

							menu.close()

							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun ~r~~h~joueur à proximité')
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_police', 'LSPD', amount)
							end
									
						end

					end,
					function(data, menu)
						menu.close()
					end
				)

			  end

			  if data2.current.value == 'permis_interaction' then
			  	TriggerServerEvent('esx_policejob:getLicensesPoints', GetPlayerServerId(player))
			  end
			else
			  ESX.ShowNotification(_U('no_players_nearby'))
			end

		  end,
		  function(data2, menu2)
			menu2.close()
			OpenPoliceActionsMenu()
		  end
		)

	  end

	  if data.current.value == 'vehicle_interaction' then
	  	local elements = {}
	  	if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)) then
			table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
		end
	  	table.insert(elements, {label = 'Circulation', value = 'circulation'})
	  	if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
	  		table.insert(elements, {label = "Déployer l'ALPR", value = 'alpr'})
	  	end
			--{label = _U('pick_lock'),    value = 'hijack_vehicle'},

		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'vehicle_interaction',
		  {
			title    = _U('vehicle_interaction'),
			elements = elements,
		  },
		  function(data2, menu2)

			local vehicle   = GetClosestVehicle(GetEntityCoords(playerPed),  3.0,  0,  71)

			if data2.current.value == 'circulation' then
				TriggerEvent('circulation:stopMenu')
			
			elseif data2.current.value == 'alpr' then
				TriggerEvent('wk:radarRC')
				ESX.UI.Menu.CloseAll()

			elseif data2.current.value == 'vehicle_infos' then
				OpenVehicleInfosMenu()
			
			elseif DoesEntityExist(vehicle) then

			  local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

			  if data2.current.value == 'hijack_vehicle' then

				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)

				if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

				  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

				  if DoesEntityExist(vehicle) then

					Citizen.CreateThread(function()

					  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

					  Wait(20000)

					  ClearPedTasksImmediately(playerPed)

					  SetVehicleDoorsLocked(vehicle, 1)
					  SetVehicleDoorsLockedForAllPlayers(vehicle, false)

					  TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

					end)

				  end

				end

			  end

			else
			  ESX.ShowNotification(_U('no_vehicles_nearby'))
			end

		  end,
		  function(data2, menu2)
			menu2.close()
		  end
		)

	  end

	  if data.current.value == 'object_spawner' then

		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'citizen_interaction',
		  {
			title    = _U('traffic_interaction'),
			--align    = 'top-left',
			elements = {
			  {label = _U('cone'),     value = 'prop_roadcone02a'},
			  {label = _U('barrier'), value = 'prop_barrier_work06a'},
			  {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
			  {label = _U('box'),   value = 'prop_boxpile_07d'},
			  {label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
			},
		  },
		  function(data2, menu2)


			local model     = data2.current.value
			local playerPed = GetPlayerPed(-1)
			local coords    = GetEntityCoords(playerPed)
			local forward   = GetEntityForwardVector(playerPed)
			local x, y, z   = table.unpack(coords + forward * 1.0)

			if model == 'prop_roadcone02a' then
			  z = z - 2.0
			end

			ESX.Game.SpawnObject(model, {
			  x = x,
			  y = y,
			  z = z
			}, function(obj)
			  SetEntityHeading(obj, GetEntityHeading(playerPed))
			  PlaceObjectOnGroundProperly(obj)
			end)

		  end,
		  function(data2, menu2)
			menu2.close()
		  end
		)

	  end

	end,
	function(data, menu)

	  menu.close()

	end
  )

end

RegisterNetEvent('esx_policejob:getLicensesPoints')
AddEventHandler('esx_policejob:getLicensesPoints', function(player, points)
	ESX.TriggerServerCallback('esx_license:getLicenses', function(data)

		local elements = {}
	  	if data.licenses ~= nil then
			table.insert(elements, {label = 'Retirer des points', value = 'remove_points'})
			for i=1, #data.licenses, 1 do
			  table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
			end
	  	end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'permis_interaction', {
			title    = _U('permis_interaction')..' ('..tostring(points)..' points)',
			elements = elements,
		  },

		  function(data, menu)

			if data.current.value == 'remove_points' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nbr_remove_points', {
						title = "Nombre de points à enlever"
					},
					function(data2, menu2)
						menu2.close()
						TriggerServerEvent('esx_policejob:removepoint', player, tonumber(data2.value))
						Wait(500)
						TriggerServerEvent('esx_policejob:getLicensesPoints', player)
						menu.close()
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end

			if data.current.value == 'weaponlicense' then
				TriggerServerEvent('esx_policejob:weaponlicense', player)
				menu.close()
			end

			if data.current.value == 'weaponlicense2' then
				TriggerServerEvent('esx_policejob:weaponlicense2', player)
				menu.close()
			end

			if data.current.value == 'drive' or data.current.value == 'drive_bike' or data.current.value == 'drive_truck' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'permis_interaction', {
					title    = 'Lui retirer le permis ?',
					elements = {
						{label = 'Oui', value = true},
						{label = 'Non', value = false}
					}}, function(data2, menu2)
						menu2.close()
						if data2.current.value then
							TriggerServerEvent('esx_license:removeLicense', player, data.current.value)
						end
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end
		  end,
		  function(data, menu)
			menu.close()
		  end
		)

	end, player)
end)

function OpenPermisCardMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

	  local elements = {}
	  if data.licenses ~= nil then

		table.insert(elements, {label = '--- Licenses ---', value = nil})

		for i=1, #data.licenses, 1 do
		  table.insert(elements, {label = data.licenses[i].label, value = nil})
		end
	  end

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'permis_interaction',
		{
		  title    = _U('permis_interaction'),
		  elements = elements,
		},
		function(data, menu)

		end,
		function(data, menu)
		  menu.close()
		end
	  )

	end, player)
end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

	  local jobLabel    = nil
	  local sexLabel    = nil
	  local sex         = nil
	  local dobLabel    = nil
	  local heightLabel = nil
	  local idLabel     = nil

	  if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
		jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
	  else
		jobLabel = 'Job : ' .. data.job.label
	  end

	  if data.sex ~= nil then
		if (data.sex == 'm') or (data.sex == 'M') then
		  sex = 'Male'
		else
		  sex = 'Female'
		end
		sexLabel = 'Sex : ' .. sex
	  else
		sexLabel = 'Sex : Unknown'
	  end

	  if data.dob ~= nil then
		dobLabel = 'DOB : ' .. data.dob
	  else
		dobLabel = 'DOB : Unknown'
	  end

	  if data.height ~= nil then
		heightLabel = 'Height : ' .. data.height
	  else
		heightLabel = 'Height : Unknown'
	  end

	  if data.name ~= nil then
		idLabel = 'ID : ' .. data.name
	  else
		idLabel = 'ID : Unknown'
	  end

	  local elements = {
		{label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
		{label = sexLabel,    value = nil},
		{label = dobLabel,    value = nil},
		{label = heightLabel, value = nil},
		{label = jobLabel,    value = nil},
		{label = idLabel,     value = nil},
	  }

	  if data.drunk ~= nil then
		table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
	  end

	  if data.licenses ~= nil then

		table.insert(elements, {label = '--- Licenses ---', value = nil})

		for i=1, #data.licenses, 1 do
		  table.insert(elements, {label = data.licenses[i].label, value = nil})
		end

	  end

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'citizen_interaction',
		{
		  title    = _U('citizen_interaction'),
		  elements = elements,
		},
		function(data, menu)

		end,
		function(data, menu)
		  menu.close()
		end
	  )

	end, GetPlayerServerId(player))

  else

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

	  local jobLabel = nil

	  if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
		jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
	  else
		jobLabel = 'Job : ' .. data.job.label
	  end

		local elements = {
		  {label = _U('name') .. data.name, value = nil},
		  {label = jobLabel,              value = nil},
		}

	  if data.drunk ~= nil then
		table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
	  end

	  if data.licenses ~= nil then

		table.insert(elements, {label = '--- Licenses ---', value = nil})

		for i=1, #data.licenses, 1 do
		  table.insert(elements, {label = data.licenses[i].label, value = nil})
		end

	  end

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'citizen_interaction',
		{
		  title    = _U('citizen_interaction'),
		  elements = elements,
		},
		function(data, menu)

		end,
		function(data, menu)
		  menu.close()
		end
	  )

	end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)
  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

	local elements = {}
	local blackMoney = 0

	for i=1, #data.accounts, 1 do
	  if data.accounts[i].name == 'black_money' then
		blackMoney = data.accounts[i].money
	  end
	end

	table.insert(elements, {
	  label          = _U('confiscate_dirty') .. blackMoney,
	  value          = 'black_money',
	  itemType       = 'item_account',
	  amount         = blackMoney
	})

	table.insert(elements, {label = '--- Armes ---', value = nil})

	for i=1, #data.weapons, 1 do
	  table.insert(elements, {
		label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
		value          = data.weapons[i].name,
		itemType       = 'item_weapon',
		amount         = data.ammo,
	  })
	end

	table.insert(elements, {label = _U('inventory_label'), value = nil})

	for i=1, #data.inventory, 1 do
	  if data.inventory[i].count > 0 then
		table.insert(elements, {
		  label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
		  value          = data.inventory[i].name,
		  itemType       = 'item_standard',
		  amount         = data.inventory[i].count,
		})
	  end
	end

	TriggerServerEvent('menu:warnSearchingBody', player)
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'body_search',
	  {
		title    = _U('search'),
		elements = elements,
	  },
	  function(data, menu)

		local itemType = data.current.itemType
		local itemName = data.current.value
		local amount   = data.current.amount

		if data.current.value ~= nil then

		  TriggerServerEvent('esx_policejob:confiscatePlayerItem', player, itemType, itemName, amount)

		  OpenBodySearchMenu(player)

		end

	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  end, player)
end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'fine',
	{
	  title    = _U('fine'),
	  elements = {
		{label = _U('traffic_offense'),   value = 0},
		{label = _U('minor_offense'),     value = 1},
		{label = _U('average_offense'),   value = 2},
		{label = _U('major_offense'),     value = 3}
	  },
	},
	function(data, menu)

	  OpenFineCategoryMenu(player, data.current.value)

	end,
	function(data, menu)
	  menu.close()
	end
  )

end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)

	local elements = {}

	for i=1, #fines, 1 do
	  table.insert(elements, {
		label     = fines[i].label .. ' $' .. fines[i].amount,
		value     = fines[i].id,
		amount    = fines[i].amount,
		fineLabel = fines[i].label
	  })
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'fine_category',
	  {
		title    = _U('fine'),
		--align    = 'top-left',
		elements = elements,
	  },
	  function(data, menu)

		local label  = data.current.fineLabel
		local amount = data.current.amount

		menu.close()

		if Config.EnablePlayerManagement then
		  TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. label, amount)
		else
		  TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. label, amount)
		end

		ESX.SetTimeout(300, function()
		  OpenFineCategoryMenu(player, category)
		end)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end, category)

end

function OpenVehicleInfosMenu()

	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'write_plate_number',
		{
			title = 'Plaque du véhicule'
		},
		function(data, menu)

			--local msg = tostring(data.value)
			menu.close()
			ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)

				local elements = {}
				table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})
				if infos.owner == nil then
				  table.insert(elements, {label = _U('owner_unknown'), value = nil})
				else
				  table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'vehicle_infos',
					{
						title    = _U('vehicle_info'),
						--align    = 'top-left',
						elements = elements,
					},
					nil,
					function(data, menu)
					menu.close()
					end
				)

			end, data.value)
		end,
		function(data, menu)
			menu.close()
		end
	)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

	local elements = {}

	for i=1, #weapons, 1 do
	  if weapons[i].count > 0 then
		table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
	  end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
		title    = _U('get_weapon_menu'),
		elements = elements,
	  },
	  function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
		  OpenGetWeaponMenu()
		end, data.current.value)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

	local weaponHash = GetHashKey(weaponList[i].name)

	if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
	  local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
	  table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
	end

  end

  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'armory_put_weapon',
	{
	  title    = _U('put_weapon_menu'),
	  elements = elements,
	},
	function(data, menu)
	  menu.close()

	  ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
		OpenPutWeaponMenu()
	  end, data.current.value)

	end,
	function(data, menu)
	  menu.close()
	end
  )

end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

	local elements = {}

	for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do

	  local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
	  local count  = 0

	  for i=1, #weapons, 1 do
		if weapons[i].name == weapon.name then
		  count = weapons[i].count
		  break
		end
	  end

	  table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_buy_weapons',
	  {
		title    = _U('buy_weapon_menu'),
		--align    = 'top-left',
		elements = elements,
	  },
	  function(data, menu)

		ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)

		  if hasEnoughMoney then
			ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
			  OpenBuyWeaponsMenu(station)
			end, data.current.value)
		  else
			ESX.ShowNotification(_U('not_enough_money'))
		  end

		end, data.current.price)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end)

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)

	local elements = {}
	for i=1, #items, 1 do
		if items[i].count > 0 then
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'stocks_menu',
	  {
		title    = _U('police_stock'),
		elements = elements
	  },
	  function(data, menu)

		local itemName = data.current.value

		ESX.UI.Menu.Open(
		  'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
		  {
			title = _U('quantity')
		  },
		  function(data2, menu2)

			local count = tonumber(data2.value)

			if count == nil then
			  ESX.ShowNotification(_U('quantity_invalid'))
			else
			  menu2.close()
			  menu.close()
			  OpenGetStocksMenu()

			  TriggerServerEvent('esx_policejob:getStockItem', itemName, count)
			end

		  end,
		  function(data2, menu2)
			menu2.close()
		  end
		)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

	local elements = {}
	for i=1, #inventory.items, 1 do
	  local item = inventory.items[i]
	  if item.count > 0 then
		table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
	  end
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'stocks_menu',
	  {
		title    = _U('inventory'),
		elements = elements
	  },
	  function(data, menu)

		local itemName = data.current.value

		ESX.UI.Menu.Open(
		  'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
		  {
			title = _U('quantity')
		  },
		  function(data2, menu2)

			local count = tonumber(data2.value)

			if count == nil then
			  ESX.ShowNotification(_U('quantity_invalid'))
			else
			  menu2.close()
			  menu.close()
			  OpenPutStocksMenu()

			  TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
			end

		  end,
		  function(data2, menu2)
			menu2.close()
		  end
		)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end)

end

function OpenGetStocksMenu2()

  ESX.TriggerServerCallback('esx_policejob:getStockItems2', function(items)

	--print(json.encode(items))

	local elements = {}

	for i=1, #items, 1 do
		if items[i].count > 0 then
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end
	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'stocks_menu',
	  {
		title    = _U('police_stock'),
		elements = elements
	  },
	  function(data, menu)

		local itemName = data.current.value

		ESX.UI.Menu.Open(
		  'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
		  {
			title = _U('quantity')
		  },
		  function(data2, menu2)

			local count = tonumber(data2.value)

			if count == nil then
			  ESX.ShowNotification(_U('quantity_invalid'))
			else
			  menu2.close()
			  menu.close()
			  OpenGetStocksMenu2()

			  TriggerServerEvent('esx_policejob:getStockItem2', itemName, count)
			end

		  end,
		  function(data2, menu2)
			menu2.close()
		  end
		)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end)

end

function OpenPutStocksMenu2()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

	local elements = {}

	for i=1, #inventory.items, 1 do

	  local item = inventory.items[i]

	  if item.count > 0 then
		table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
	  end

	end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'stocks_menu',
	  {
		title    = _U('inventory'),
		elements = elements
	  },
	  function(data, menu)

		local itemName = data.current.value

		ESX.UI.Menu.Open(
		  'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
		  {
			title = _U('quantity')
		  },
		  function(data2, menu2)

			local count = tonumber(data2.value)

			if count == nil then
			  ESX.ShowNotification(_U('quantity_invalid'))
			else
			  menu2.close()
			  menu.close()
			  OpenPutStocksMenu2()

			  TriggerServerEvent('esx_policejob:putStockItems2', itemName, count)
			end

		  end,
		  function(data2, menu2)
			menu2.close()
		  end
		)

	  end,
	  function(data, menu)
		menu.close()
	  end
	)

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
	CurrentAction     = 'menu_cloakroom'
	CurrentActionMsg  = _U('open_cloackroom')
	CurrentActionData = {}
  end

  if part == 'Armory' then
	CurrentAction     = 'menu_armory'
	CurrentActionMsg  = _U('open_armory')
	CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
	CurrentAction     = 'menu_vehicle_spawner'
	CurrentActionMsg  = _U('vehicle_spawner')
	CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then
	CurrentAction     = 'menu_helicopter_spawner'
	CurrentActionMsg  = _U('helicopter_spawner')
	CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'VehicleDeleter' then

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then

	  local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))

	  if DoesEntityExist(vehicle) then
		CurrentAction     = 'delete_vehicle'
		CurrentActionMsg  = _U('store_vehicle')
		CurrentActionData = {vehicle = vehicle}
	  end

	end

  end
  
  if part == 'HelicoDeleter' then

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then

	  local vehicle = GetVehiclePedIsIn(playerPed, false)

	  if DoesEntityExist(vehicle) then
		CurrentAction     = 'delete_helico'
		CurrentActionMsg  = _U('store_helicopter')
		CurrentActionData = {vehicle = vehicle}
	  end

	end

  end
  
  if part == 'others_actions' then
	CurrentAction     = 'others_actions'
	CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l'ordinateur"
	CurrentActionData = {}
  end

  if part == 'BossActions' then
	CurrentAction     = 'menu_boss_actions'
	CurrentActionMsg  = _U('open_bossmenu')
	CurrentActionData = {}
  end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
	CurrentAction     = 'remove_entity'
	CurrentActionMsg  = _U('remove_object')
	CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then

	  local vehicle = GetVehiclePedIsIn(playerPed)

	  for i=0, 7, 1 do
		SetVehicleTyreBurst(vehicle,  i,  true,  1000)
	  end

	end

  end

end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
	CurrentAction = nil
  end

end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

	if IsHandcuffed then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			if skin.sex == 0 then
				SetPedComponentVariation(GetPlayerPed(-1), 7, 41, 0, 0)
			else
				SetPedComponentVariation(GetPlayerPed(-1), 7, 25, 0, 0)
			end
		end)
	  RequestAnimDict('mp_arresting')

	  while not HasAnimDictLoaded('mp_arresting') do
		Wait(100)
	  end

	  TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	  SetEnableHandcuffs(playerPed, true)
	  SetPedCanPlayGestureAnims(playerPed, false)
	  --FreezeEntityPosition(playerPed,  true)

	else
		SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 0)
	  ClearPedSecondaryTask(playerPed)
	  SetEnableHandcuffs(playerPed, false)
	  SetPedCanPlayGestureAnims(playerPed,  true)
	  --FreezeEntityPosition(playerPed, false)

	end

  end)
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
	Wait(0)
	if IsHandcuffed then
	  if IsDragged then
		local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
		local myped = GetPlayerPed(-1)
		AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	  else
		DetachEntity(GetPlayerPed(-1), true, false)
	  end
	end
  end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

	local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

	if DoesEntityExist(vehicle) then

	  local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
	  local freeSeat = nil

	  for i=maxSeats - 1, 0, -1 do
		if IsVehicleSeatFree(vehicle,  i) then
		  freeSeat = i
		  break
		end
	  end

	  if freeSeat ~= nil then
		TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
	  end

	end

  end

end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
	Wait(3)
	if IsHandcuffed then
	  DisableControlAction(0, 142, true) -- MeleeAttackAlternate
	  --DisableControlAction(0, 30,  true) -- MoveLeftRight
	  --DisableControlAction(0, 31,  true) -- MoveUpDown
	  DisableControlAction(0, 24,  true) -- Shoot
	  DisableControlAction(0, 92,  true) -- Shoot in car
	  --DisableControlAction(0, 75,  true) -- Leave Vehicle
	  DisableControlAction(0, 323,  true) -- Hands Up X
	  DisableControlAction(0, 246,  true) -- Y Menu
	  DisableControlAction(0, 170,  true) -- Radio
	  DisableControlAction(0, 288,  true) -- Selfie
	  DisableControlAction(0, 25,  true) -- Aim
	end
  end
end)

-- Create blips
Citizen.CreateThread(function()
	Wait(3000)
  for k,v in pairs(Config.PoliceStations) do

	local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

	SetBlipSprite (blip, v.Blip.Sprite)
	SetBlipDisplay(blip, v.Blip.Display)
	SetBlipScale  (blip, v.Blip.Scale)
	SetBlipColour (blip, v.Blip.Colour)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('map_blip'))
	EndTextCommandSetBlipName(blip)

  end

end)

-- Display markers
Citizen.CreateThread(function()
  while true do

	Wait(10)

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

		local coords    = GetEntityCoords(GetPlayerPed(-1))

	  	for k,v in pairs(Config.PoliceStations) do

			for i=1, #v.Cloakrooms, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			for i=1, #v.Armories, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			for i=1, #v.Vehicles, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end
			
			for i=1, #v.Helicopters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			for i=1, #v.VehicleDeleters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end
		
			for i=1, #v.HelicoDeleters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.HelicoDeleters[i].x,  v.HelicoDeleters[i].y,  v.HelicoDeleters[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.HelicoDeleters[i].x, v.HelicoDeleters[i].y, v.HelicoDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 7.0, 7.0, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

			  for i=1, #v.BossActions, 1 do
				if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
				  DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
			  end

			end

			for i=1, #v.OthersActions, 1 do
			  if GetDistanceBetweenCoords(coords,  v.OthersActions[i].x,  v.OthersActions[i].y,  v.OthersActions[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.OthersActions[i].x, v.OthersActions[i].y, v.OthersActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

	  	end

	end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do
	Wait(0)

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

		local playerPed      = GetPlayerPed(-1)
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil

	  	for k,v in pairs(Config.PoliceStations) do

			for i=1, #v.Cloakrooms, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Cloakroom'
				currentPartNum = i
			  end
			end

			for i=1, #v.Armories, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Armory'
				currentPartNum = i
			  end
			end

			for i=1, #v.Vehicles, 1 do

			  if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawner'
				currentPartNum = i
			  end

			  if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawnPoint'
				currentPartNum = i
			  end

			end

			for i=1, #v.Helicopters, 1 do

			  if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicopterSpawner'
				currentPartNum = i
			  end

			  if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicopterSpawnPoint'
				currentPartNum = i
			  end

			end

			for i=1, #v.VehicleDeleters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleDeleter'
				currentPartNum = i
			  end
			end
		
			for i=1, #v.HelicoDeleters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.HelicoDeleters[i].x,  v.HelicoDeleters[i].y,  v.HelicoDeleters[i].z,  true) < 7.0 then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicoDeleter'
				currentPartNum = i
			  end
			end

			if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

			  for i=1, #v.BossActions, 1 do
				if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
				  isInMarker     = true
				  currentStation = k
				  currentPart    = 'BossActions'
				  currentPartNum = i
				end
			  end

			end
		
			for i=1, #v.OthersActions, 1 do
			  if GetDistanceBetweenCoords(coords,  v.OthersActions[i].x,  v.OthersActions[i].y,  v.OthersActions[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'others_actions'
				currentPartNum = i
			  end
			end

		end

	  local hasExited = false

	  if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

		if
		  (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
		  (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
		then
		  TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
		  hasExited = true
		end

		HasAlreadyEnteredMarker = true
		LastStation             = currentStation
		LastPart                = currentPart
		LastPartNum             = currentPartNum

		TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
	  end

	  if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

		HasAlreadyEnteredMarker = false

		TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
	  end

	end

  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()

  local trackedEntities = {
	'prop_roadcone02a',
	'prop_barrier_work06a',
	'p_ld_stinger_s',
	'prop_boxpile_07d',
	'hei_prop_cash_crate_half_full'
  }

  while true do

	Citizen.Wait(0)

	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	local closestDistance = -1
	local closestEntity   = nil

	for i=1, #trackedEntities, 1 do

	  local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

	  if DoesEntityExist(object) then

		local objCoords = GetEntityCoords(object)
		local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

		if closestDistance == -1 or closestDistance > distance then
		  closestDistance = distance
		  closestEntity   = object
		end

	  end

	end

	if closestDistance ~= -1 and closestDistance <= 3.0 then

	  if LastEntity ~= closestEntity then
		TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
		LastEntity = closestEntity
	  end

	else

	  if LastEntity ~= nil then
		TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
		LastEntity = nil
	  end

	end

  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

	Citizen.Wait(0)

	if CurrentAction ~= nil then

	  SetTextComponentFormat('STRING')
	  AddTextComponentString(CurrentActionMsg)
	  DisplayHelpTextFromStringLabel(0, 0, 1, -1)

	  if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (GetGameTimer() - GUI.Time) > 150 then

		if CurrentAction == 'menu_cloakroom' then
		  OpenCloakroomMenu()
		end

		if CurrentAction == 'menu_armory' then
		  OpenArmoryMenu(CurrentActionData.station)
		end

		if CurrentAction == 'menu_vehicle_spawner' then
		  OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		end
		
		if CurrentAction == 'menu_helicopter_spawner' then
			OpenHelicopterSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		end

		if CurrentAction == 'delete_vehicle' then

		  if Config.EnableSocietyOwnedVehicles then

			TriggerServerEvent('esx_society:putVehicleInGarage', 'police', ESX.Game.GetVehicleProperties(CurrentActionData.vehicle))

		  else

			if
			  GetEntityModel(vehicle) == GetHashKey('police')  or
			  GetEntityModel(vehicle) == GetHashKey('police2') or
			  GetEntityModel(vehicle) == GetHashKey('police3') or
			  GetEntityModel(vehicle) == GetHashKey('police4') or
			  GetEntityModel(vehicle) == GetHashKey('policeb') or
			  GetEntityModel(vehicle) == GetHashKey('policet')
			then
			  TriggerServerEvent('esx_service:disableService', 'police')
			end

		  end

		  TriggerServerEvent('tracker:removeVehicle', GetVehicleNumberPlateText(CurrentActionData.vehicle))
		  ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		end
  
		if CurrentAction == 'delete_helico' then
			TriggerServerEvent('tracker:removeVehicle', GetVehicleNumberPlateText(CurrentActionData.vehicle))
		  	ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		end
  
		if CurrentAction == 'others_actions' then
			ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choice_menu',
                {
	                title    = 'Ordinateur',
	                elements = {
	                	{label = "Vérifier une plaque d'immatriculation", value = 'plate'}
	                },
                },
                function(data, menu)

                	if data.current.value == 'plate' then
                		OpenVehicleInfosMenu()
                	end

                end,
                function(data, menu)
                    menu.close()
                end
            )
		end

		if CurrentAction == 'menu_boss_actions' then

		  ESX.UI.Menu.CloseAll()
		  TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)

			menu.close()
			CurrentAction     = 'menu_boss_actions'
			CurrentActionMsg  = _U('open_bossmenu')
			CurrentActionData = {}

		  end)

		end

		if CurrentAction == 'remove_entity' then
		  DeleteEntity(CurrentActionData.entity)
		end

		CurrentAction = nil
		GUI.Time      = GetGameTimer()

	  end

	end

	--[[if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
	  OpenPoliceActionsMenu()
	  GUI.Time = GetGameTimer()
	end]]

  end
end)

RegisterNetEvent('nb:openMenuPolice')
AddEventHandler('nb:openMenuPolice', function()
  OpenPoliceActionsMenu()
end)