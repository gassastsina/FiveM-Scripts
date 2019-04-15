------------------------------------------------
------------------------------------------------
----    File : client.lua            		----
----    Author: gassastsina             	----
----	Side : client 						----
----    Description : Gère le véhicule V2	----
------------------------------------------------
------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX           = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(50)
  end
end)

-----------------------------------------------main-------------------------------------------------------
local key = {}
local vehiclesEngines = {}

local function ToggleCarEngine(vehicle, plate)
	ESX.TriggerServerCallback('vehicleManager:getEngines', function(serverEngine, engines)
		vehiclesEngines = engines
		if serverEngine then
			TriggerEvent('esx:showNotification', 'Moteur ~g~allumé')
		else
			TriggerEvent('esx:showNotification', 'Moteur ~r~éteint')
		end
		SetVehicleEngineOn(vehicle, serverEngine, false, false)
	end, plate, GetIsVehicleEngineRunning(vehicle))
end

local function StartVehicleManagment()
	local frontLeft_window 	= true
	local frontRight_window = true
	local backLeft_window 	= true
	local backRight_window 	= true
	local all_windows		= true
	while true do
		Wait(20)
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)  then
			if GetIsVehicleEngineRunning(vehicle) then
				for i=0, #vehiclesEngines, 1 do
					if vehiclesEngines[i] ~= nil then
						if vehiclesEngines[i].plate == GetVehicleNumberPlateText(vehicle) then
							if vehiclesEngines[i].engine then
								SetVehicleEngineOn(vehicle, false, true, true)
							end
							break
						end
					end
					if i == #vehiclesEngines and Vdist(GetEntityCoords(GetPlayerPed(-1), false), -47.6, -1097.2, 26.2) > 4.0 then
						TriggerServerEvent('vehicleManager:addNewVehicle', GetVehicleNumberPlateText(vehicle))
						SetVehicleEngineOn(vehicle, false, true, true)
					end
				end
			end
		elseif not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and not GetIsVehicleEngineRunning(vehicle) then
			for i=1, #vehiclesEngines, 1 do
				if vehiclesEngines[i].plate == GetVehicleNumberPlateText(vehicle) then
					if not vehiclesEngines[i].engine then
						SetVehicleEngineOn(vehicle, not vehiclesEngines[i].engine, true, false)
					end
					break
				end
			end
		end
  		if IsControlJustPressed(1, 244) then
  			SetVehicleIndicatorLights(vehicle, 0, false)
  			SetVehicleIndicatorLights(vehicle, 1, false)
			for i=0, #key, 1 do
				if key[i] == GetVehicleNumberPlateText(vehicle) then
		  			ToggleCarEngine(vehicle, key[i])
					break
				elseif i == #key then
					TriggerEvent('esx:showNotification', "Vous n'avez pas la clé de ce véhicule")
				end
			end
  		
  		elseif IsControlPressed(1, 96) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
  			if IsControlJustPressed(1, 117) then
  				if GetVehicleDoorAngleRatio(vehicle, 0) <= 0.0 then
  					SetVehicleDoorOpen(vehicle, 0, false, false)
  				else
	  				SetVehicleDoorShut(vehicle, 0, false)
	  			end

  			elseif IsControlJustPressed(1, 118) then
  				if GetVehicleDoorAngleRatio(vehicle, 1) <= 0.0 then
  					SetVehicleDoorOpen(vehicle, 1, false, false)
  				else
	  				SetVehicleDoorShut(vehicle, 1, false)
	  			end

  			elseif IsControlJustPressed(1, 108) then
  				if GetVehicleDoorAngleRatio(vehicle, 2) <= 0.0 then
  					SetVehicleDoorOpen(vehicle, 2, false, false)
  				else
	  				SetVehicleDoorShut(vehicle, 2, false)
	  			end

  			elseif IsControlJustPressed(1, 107) then
  				if GetVehicleDoorAngleRatio(vehicle, 3) <= 0.0 then
  					SetVehicleDoorOpen(vehicle, 3, false, false)
  				else
	  				SetVehicleDoorShut(vehicle, 3, false)
	  			end

  			elseif IsControlJustPressed(1, 60) then
  				if GetVehicleDoorAngleRatio(vehicle, 5) <= 0.0 then
  					SetVehicleDoorOpen(vehicle, 5, false, false)
  				else
	  				SetVehicleDoorShut(vehicle, 5, false)
	  			end

  			elseif IsControlJustPressed(1, 61) then
  				if GetVehicleDoorAngleRatio(vehicle, 4) <= 0.0 then
  					SetVehicleDoorOpen(vehicle, 4, false, false)
  				else
	  				SetVehicleDoorShut(vehicle, 4, false)
	  			end
  			end

		elseif IsControlPressed(1, 97) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
  			if IsControlJustPressed(1, 117) then
  				if frontLeft_window then
  					RollDownWindow(vehicle, 0)
  				else
  					RollUpWindow(vehicle, 0)
  				end
  				frontLeft_window = not frontLeft_window

  			elseif IsControlJustPressed(1, 118) then
  				if frontRight_window then
  					RollDownWindow(vehicle, 1)
  				else
  					RollUpWindow(vehicle, 1)
  				end
  				frontRight_window = not frontRight_window

  			elseif IsControlJustPressed(1, 108) then
  				if backLeft_window then
  					RollDownWindow(vehicle, 2)
  				else
  					RollUpWindow(vehicle, 2)
  				end
  				backLeft_window = not backLeft_window

  			elseif IsControlJustPressed(1, 107) then
  				if backRight_window then
  					RollDownWindow(vehicle, 3)
  				else
  					RollUpWindow(vehicle, 3)
  				end
  				backRight_window = not backRight_window


  			elseif IsControlJustPressed(1, 61) then
  				if all_windows then
  					for i=0, 3, 1 do
	  					RollUpWindow(vehicle, i)
	  				end
  				else
  					RollDownWindows(vehicle)
  				end
  				all_windows = not all_windows
				frontLeft_window 	= all_windows
				frontRight_window 	= all_windows
				backLeft_window 	= all_windows
				backRight_window 	= all_windows
  			end
		end
  	end
end

RegisterNetEvent('vehicleManager:startVehicleByKit')
AddEventHandler('vehicleManager:startVehicleByKit', function(engines)
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
		ESX.UI.Menu.CloseAll()
		local WaitingTime = math.random(2000, 8000)
		TriggerEvent('pNotify:SetQueueMax', "left", 1)
		TriggerEvent('pNotify:SendNotification', {
	        text = "Démarrage en cours...",
	        type = "warning",
	        timeout = WaitingTime,
	        layout = "centerLeft",
	        queue = "left"
	  	})
		Wait(WaitingTime)
		if math.random(1, 5) ~= 1 then
			ToggleCarEngine(GetVehiclePedIsIn(GetPlayerPed(-1), false), GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
			TriggerEvent('pNotify:SetQueueMax', "left", 1)
			TriggerEvent('pNotify:SendNotification', {
		        text = "Le kit de démarrage a fonctionné",
		        type = "success",
		        timeout = 2000,
		        layout = "centerLeft",
		        queue = "left"
		  	})
		else
			TriggerEvent('pNotify:SetQueueMax', "left", 1)
			TriggerEvent('pNotify:SendNotification', {
		        text = "Le kit de démarrage a échoué",
		        type = "error",
		        timeout = 3000,
		        layout = "centerLeft",
		        queue = "left"
		  	})
		end
		TriggerServerEvent('vehicleManager:removeItem', 'carstarter_kit')
	else
		TriggerEvent('esx:showNotification', 'Tu dois être dans un véhicule pour utiliser un kit de démarrage')
	end
end)

local showHUD = true
local function drawTxt(msg, x, y, g, b)
	if showHUD then
		if y == 0.95 then
			HideHudComponentThisFrame(9) -- Street name
		end
		SetTextFont(4)
		SetTextProportional(false)
		SetTextScale(0.6, 0.6)
		SetTextColour(255, g, b, 255)
		SetTextDropShadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(msg)
		DrawText(x, y)
	end
end

local function StartShowSpeed()
	Wait(5000)
	local alwaysOn = false
	local canDrawTxt = false
	local message = ''
	local maxSpeed = 70
	local x = 0.87
	while true do
		Wait(10)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(ped, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
			if IsControlPressed(1, 97) then
				local vehicle = GetVehiclePedIsIn(ped, false)
				if not canDrawTxt and not alwaysOn then
					message = 'Limiteur de vitesse'
					x = 0.87
					canDrawTxt = true
					local tempSpeed = maxSpeed
					Citizen.CreateThread(function()
						Wait(700)
						if maxSpeed == tempSpeed then
							if GetEntitySpeed(vehicle) > maxSpeed/3.6 then
								message = 'Limiteur de vitesse : ~r~'..maxSpeed..'km/h'
							else
								message = 'Limiteur de vitesse : ~g~'..maxSpeed..'km/h'
							end
							x = 0.83
						end
					end)
				end
				if IsControlJustPressed(1, 10) then --PAGEUP
					if maxSpeed < 150 then
						maxSpeed = maxSpeed + 10
						if GetEntitySpeed(vehicle) > maxSpeed/3.6 then
							message = 'Limiteur : ~r~'..maxSpeed..'km/h'
						else
							message = 'Limiteur : ~g~'..maxSpeed..'km/h'
						end
						x = 0.89
					end

				elseif IsControlJustPressed(1, 11) then --PAGEDOWN
					if maxSpeed > 0 then
						maxSpeed = maxSpeed - 10
						if GetEntitySpeed(vehicle) > maxSpeed/3.6 then
							message = 'Limiteur : ~r~'..maxSpeed..'km/h'
						else
							message = 'Limiteur : ~g~'..maxSpeed..'km/h'
						end
						x = 0.89
					end

				elseif IsControlJustPressed(1, 201) then --ACCEPT
					SetEntityMaxSpeed(vehicle, 300/3.6)
					Wait(100)
					SetEntityMaxSpeed(vehicle, (maxSpeed)/3.6)
					message = 'Limiteur ~g~activé ~w~à ~b~'..maxSpeed..'km/h'
					x = 0.86
					Citizen.CreateThread(function()
						local tempSpeed = maxSpeed
						Wait(2500)
						if tempSpeed == maxSpeed then
							message = maxSpeed..'km/h'
							x = 0.93
						end
					end)
					alwaysOn = true

				elseif IsControlJustPressed(1, 202) then --CANCEL
					SetEntityMaxSpeed(vehicle, 300/3.6)
					message = 'Limiteur ~r~désactivé'
					x = 0.88
					Citizen.CreateThread(function()
						Wait(2500)
						canDrawTxt = false
						alwaysOn = false
					end)
				end
			elseif IsControlJustReleased(1, 97) then
				canDrawTxt = false
			end
			if canDrawTxt or alwaysOn then
				drawTxt(message, x, 0.95, 255, 255)
			end
		else
			SetEntityMaxSpeed(GetVehiclePedIsIn(ped, true), 300/3.6)
			message = 'Limiteur ~r~désactivé'
			x = 0.88
			Citizen.CreateThread(function()
				Wait(2500)
				canDrawTxt = false
				alwaysOn = false
			end)
		end
		if IsPedSittingInAnyVehicle(ped) then
			local speed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(ped, false))*3.6)
			if speed >= 151 then
				drawTxt(speed..' km/h', 0.18, 0.92, 0, 0)
			else
				drawTxt(speed..' km/h', 0.18, 0.92, 255, 255)
			end
		end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	Citizen.CreateThread(function()
    	StartShowSpeed()
    end)
    StartVehicleManagment()
end)

AddEventHandler('esx_key:giveVehiclesKey', function(plate)
	key = plate
end)

AddEventHandler('giveKeyAtKeyMaster', function(plate)
 	table.insert(key, plate)
end)

AddEventHandler('esx:ShowHUD', function(HUD)
    showHUD = HUD
end)

RegisterNetEvent('vehicleManager:updateEngines')
AddEventHandler('vehicleManager:updateEngines', function(engines)
	vehiclesEngines = engines
end)

RegisterNetEvent('vehicleManager:getVehiclesKey')
AddEventHandler('vehicleManager:getVehiclesKey', function()
	local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
	TriggerEvent('esx_key:getVehiclesKey', plate)
  	TriggerServerEvent('logs:write', "Vient de se give les clées du véhicule ("..plate..")")
end)