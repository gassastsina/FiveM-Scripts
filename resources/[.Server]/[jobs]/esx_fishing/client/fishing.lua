------------------------------------
------------------------------------
----    File : fishing.lua    	----
----    Edited by : gassastsina ----
----    Side : client        	----
----    Description : Fishing	----
------------------------------------
------------------------------------

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
ESX                    = nil
local PlayerData 	   = {}
--local Caught_KEY       = Keys['E']
--local SuccessLimit     = 0.09 -- Maxim 0.1 (high value, low success chances)
--local AnimationSpeed   = 0.0040
local ShowChatMSG      = true -- or false

local IsFishing        = false
--local CFish            = false
--local BarAnimation     = 0
--local Faketimer        = 0
--local RunCodeOnly1Time = true
--local PosX             = 0.5
--local PosY             = 0.1
--local TimerAnimation   = 0.1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

-- Init playerdata & job
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	setBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	setBlip()
end)

-- end init playerdata & job

--[[function text(x,y,scale,text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(255,255,255,255)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end]]

--[[function FishGUI(bool)
	if not bool then return end
	DrawRect(PosX,PosY+0.005,TimerAnimation,0.005,255,255,0,255)
	DrawRect(PosX,PosY,0.1,0.01,0,0,0,255)
	TimerAnimation = TimerAnimation - 0.0001025
	if BarAnimation >= SuccessLimit then
		DrawRect(PosX,PosY,BarAnimation,0.01,102,255,102,150)
	else
		DrawRect(PosX,PosY,BarAnimation,0.01,255,51,51,150)
	end
	if BarAnimation <= 0 then
		up = true
	end
	if BarAnimation >= PosY then
		up = false
	end
	if not up then
		BarAnimation = BarAnimation - AnimationSpeed
	else
		BarAnimation = BarAnimation + AnimationSpeed
	end
	text(0.4,0.05,0.35, "Vous en avez un, ferrez-le en appuyant sur [E]")
end]]

function PlayAnim(ped,base,sub,nr,time) 
	Citizen.CreateThread(function() 
		RequestAnimDict(base) 
		while not HasAnimDictLoaded(base) do 
			Citizen.Wait(1) 
		end
		if IsEntityPlayingAnim(ped, base, sub, 3) then
			ClearPedSecondaryTask(ped) 
		else
			for i = 1,nr do 
				TaskPlayAnim(ped, base, sub, 8.0, -8, -1, 16, 0, 0, 0, 0) 
				Citizen.Wait(time) 
			end 
		end 
	end) 
end

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(GetPlayerPed(-1), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPlayerPed(-1),2))
	AttachEntityToEntity(obj,  GetPlayerPed(-1),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end

RegisterNetEvent('esx_fishing:startFishing')
AddEventHandler('esx_fishing:startFishing', function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
		if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			if not IsPedSwimming(GetPlayerPed(-1)) then
				local coords = GetEntityCoords(GetPlayerPed(-1), true)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Harvest.x, Config.Fisherman.Harvest.y, Config.Fisherman.Harvest.z) < Config.Fisherman.Harvest.size then
					if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
						ESX.UI.Menu.Close('default', 'es_extended', 'inventory')
					end

					if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item') then
						ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item')
					end

					IsFishing = true
					if ShowChatMSG then ESX.ShowNotification("Vous avez lancé votre appât, attendez qu'un poisson morde ...") end
					--RunCodeOnly1Time = true
					--BarAnimation = 0
					TriggerServerEvent('farms:Harvest', 'fish', 1, 6000)

				else
					ESX.ShowNotification("~r~Vous n'êtes pas dans une zone de pêche")
				end
			else
				ESX.ShowNotification('Action impossible')
			end
		else
			ESX.ShowNotification('Action impossible')
		end
	else
		ESX.ShowNotification("Vous devez etre poissonier pour pêcher.")
	end
end)

RegisterNetEvent('esx_fishing:onEatFish')
AddEventHandler('esx_fishing:onEatFish', function()
	SetEntityHealth(GetPlayerPed(-1),  GetEntityHealth(GetPlayerPed(-1)) + 25)
end)

--[[Citizen.CreateThread(function()
	Wait(5000)
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		while IsFishing do
			local nbr = 8
			local long = 3000
			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Harvest.x, Config.Fisherman.Harvest.y, Config.Fisherman.Harvest.z) < Config.Fisherman.Harvest.size then
				nbr = 2
				SuccessLimit = 0.04
			else
				SuccessLimit = 0.08
			end
			local time = nbr*long
			TaskStandStill(GetPlayerPed(-1), time+2000)
			FishRod = AttachEntityToPed('prop_fishing_rod_01', 60309, 0, 0, 0, 0, 0, 0)
			PlayAnim(GetPlayerPed(-1),'amb@world_human_stand_fishing@base','base', nbr, long)
			Citizen.Wait(time)
			CFish = true
			IsFishing = false
		end

		while CFish do
			Citizen.Wait(1)
			FishGUI(true)
			if RunCodeOnly1Time then
				Faketimer = 1
				PlayAnim(GetPlayerPed(-1),'amb@world_human_stand_fishing@idle_a','idle_c',1,0) -- 10sec
				RunCodeOnly1Time = false
			end
			if TimerAnimation <= 0 then
				CFish = false
				TimerAnimation = 0.1
				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
				Citizen.Wait(200)
				DeleteEntity(FishRod)
				if ShowChatMSG then 
					TriggerEvent('pNotify:SetQueueMax', "left", 1)
					TriggerEvent('pNotify:SendNotification', {
				        text = "Le poisson s'est échappé...",
				        type = "error",
				        timeout = 2300,
				        layout = "centerLeft",
				        queue = "left"
				  	})
				end
				TriggerServerEvent('esx_fishing:removeInventoryItem','bait', 1)
				StopOrStart()
			end
			if IsControlJustPressed(1, Caught_KEY) then
				if BarAnimation >= SuccessLimit then
					CFish = false
					TimerAnimation = 0.1
					if ShowChatMSG then
						TriggerEvent('pNotify:SetQueueMax', "left", 1)
						TriggerEvent('pNotify:SendNotification', {
					        text = "Vous avez attrapé un poisson !",
					        type = "success",
					        timeout = 2300,
					        layout = "centerLeft",
					        queue = "left"
					  	})
					end
					StopAnimTask(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)

					TriggerServerEvent('esx_fishing:caughtFish')
					StopOrStart()

				else
					CFish = false
					TimerAnimation = 0.1
					StopAnimTask(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
					if ShowChatMSG then
						TriggerEvent('pNotify:SetQueueMax', "left", 1)
						TriggerEvent('pNotify:SendNotification', {
					        text = "Le poisson s'est échappé...",
					        type = "error",
					        timeout = 2300,
					        layout = "centerLeft",
					        queue = "left"
					  	})
					end
					TriggerServerEvent('esx_fishing:removeInventoryItem','bait', 1)
					StopOrStart()
				end
			end
		end
	end
end)]]

--[[function StopOrStart()
	local count = 0
	while not IsControlJustPressed(0, 73) and not IsControlJustPressed(0, 323) and count < 400 do
		Wait(1)
		count = count + 1
        HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour continuer de pecher ou ~INPUT_VEH_DUCK~ pour arreter")
		if IsControlJustPressed(0, 38) then
			TriggerEvent('esx_fishing:startFishing')
			break
		end
	end
end]]

--[[Citizen.CreateThread(function() -- Thread for  timer
	while true do 
		Citizen.Wait(1000)
		Faketimer = Faketimer + 1 
	end 
end)]]

local InMarker = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(6)
		if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
			local coords = GetEntityCoords(GetPlayerPed(-1), true)
			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Harvest.x, Config.Fisherman.Harvest.y, Config.Fisherman.Harvest.z) < Config.Fisherman.Harvest.size + 150.0 then
				DrawMarker(Config.MarkerType, Config.Fisherman.Harvest.x, Config.Fisherman.Harvest.y, Config.Fisherman.Harvest.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Fisherman.Harvest.size, Config.Fisherman.Harvest.size, 5.0, 0, 0, 255, 100, false, true, 2, false, false, false, false)
				if IsFishing and Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Harvest.x, Config.Fisherman.Harvest.y, Config.Fisherman.Harvest.z) > Config.Fisherman.Harvest.size then
					TriggerServerEvent('farms:stop')
					IsFishing = false
					--DeleteEntity(FishRod)
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.HarvestGazBottles.x, Config.Fisherman.HarvestGazBottles.y, Config.Fisherman.HarvestGazBottles.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Fisherman.HarvestGazBottles.x, Config.Fisherman.HarvestGazBottles.y, Config.Fisherman.HarvestGazBottles.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.HarvestGazBottles.x, Config.Fisherman.HarvestGazBottles.y, Config.Fisherman.HarvestGazBottles.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour préparer une bouteille de gaz")
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('farms:Harvest', 'gazbottle_plunge', 1, 10000)
		            	InMarker = true
		            	Wait(1000)
		            end
		        elseif InMarker then
		        	TriggerServerEvent('farms:stop')
		        	InMarker = false
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.HarvestPlungeWear.x, Config.Fisherman.HarvestPlungeWear.y, Config.Fisherman.HarvestPlungeWear.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Fisherman.HarvestPlungeWear.x, Config.Fisherman.HarvestPlungeWear.y, Config.Fisherman.HarvestPlungeWear.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.HarvestPlungeWear.x, Config.Fisherman.HarvestPlungeWear.y, Config.Fisherman.HarvestPlungeWear.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour préparer une tenue de plongée")
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('farms:Harvest', 'plunge_wear', 1, 10000)
		            	InMarker = true
		            	Wait(1000)
		            end
		        elseif InMarker then
		        	TriggerServerEvent('farms:stop')
		        	InMarker = false
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Treatment.x, Config.Fisherman.Treatment.y, Config.Fisherman.Treatment.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.Fisherman.Treatment.x, Config.Fisherman.Treatment.y, Config.Fisherman.Treatment.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Treatment.x, Config.Fisherman.Treatment.y, Config.Fisherman.Treatment.z) < Config.MarkerSize.x then
					if not InMarker then
			            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour congeler le poisson")
			        end
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('farms:Treatment', 'fish', 1, 'frozen_fish', 1, 1000)
		            	InMarker = true
		            	Wait(1000)
		            end
		        elseif InMarker then
		        	TriggerServerEvent('farms:stop')
		        	InMarker = false
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Sell.x, Config.Fisherman.Sell.y, Config.Fisherman.Sell.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.Fisherman.Sell.x, Config.Fisherman.Sell.y, Config.Fisherman.Sell.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Sell.x, Config.Fisherman.Sell.y, Config.Fisherman.Sell.z) < Config.MarkerSize.x then
					if not InMarker then
			            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour vendre le poisson")
			        end
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('farms:Sell', 'frozen_fish', 1, 10, 8, 'society_fisherman', 1000)
		            	InMarker = true
		            	Wait(1000)
		            end
		        elseif InMarker then
		        	TriggerServerEvent('farms:stop')
		        	InMarker = false
				end
			end

			
			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.BossActions.x, Config.Fisherman.BossActions.y, Config.Fisherman.BossActions.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Fisherman.BossActions.x, Config.Fisherman.BossActions.y, Config.Fisherman.BossActions.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.BossActions.x, Config.Fisherman.BossActions.y, Config.Fisherman.BossActions.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour gérer l'entreprise")
		            if IsControlJustPressed(1, 38) then
		            	if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh' then
							TriggerEvent('esx_society:openBossMenu', 'fisherman', function(data, menu)
					        	menu.close()
					        end)
				        elseif PlayerData.job.grade_name ~= 'sailor' then
							TriggerEvent('esx_society:openBossMenu', 'fisherman', function(data, menu)
					        	menu.close()
					        end, {	chest 	  = true,
								    withdraw  = false,
								    deposit   = true,
								    wash      = false,	--Blanchiment désactivé
								    employees = false,
								    grades    = false 	--Salaire désactivé
							})
				        else
							TriggerEvent('esx_society:openBossMenu', 'fisherman', function(data, menu)
					        	menu.close()
					        end, {	chest 	  = true,
								    withdraw  = false,
								    deposit   = false,
								    wash      = false,	--Blanchiment désactivé
								    employees = false,
								    grades    = false 	--Salaire désactivé
							})
				        end
	            	InMarker = true
	            end
	        elseif InMarker then
	        	InMarker = false
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Vehicles.Spawner.x, Config.Fisherman.Vehicles.Spawner.y, Config.Fisherman.Vehicles.Spawner.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Fisherman.Vehicles.Spawner.x, Config.Fisherman.Vehicles.Spawner.y, Config.Fisherman.Vehicles.Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Vehicles.Spawner.x, Config.Fisherman.Vehicles.Spawner.y, Config.Fisherman.Vehicles.Spawner.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule")
		            if IsControlJustPressed(1, 38) then
						ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

							local elements = {}
							for i=1, #garageVehicles, 1 do
								if garageVehicles[i].plate ~= nil then
									table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
								end
							end
							ESX.UI.Menu.CloseAll()
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
								  title    = 'Garage de véhicules',
								  elements = elements,
								},
								function(data, menu)
									menu.close()

									local vehicleProps = data.current.value
									ESX.Game.SpawnVehicle(vehicleProps.model, Config.Fisherman.Vehicles.SpawnPoint, Config.Fisherman.Vehicles.Heading, function(vehicle)
										ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
										TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
										TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
										TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
										TriggerServerEvent('esx_society:removeVehicleFromGarage', 'fisherman', vehicleProps)
									end)
								end,
								function(data, menu)
								  menu.close()
								end
							)

						end, 'fisherman')
		            	InMarker = true
		            end
		        elseif InMarker then
		        	InMarker = false
				end
			end

			if IsPedInAnyVehicle(GetPlayerPed(-1), true) and Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Vehicles.Deleter.x, Config.Fisherman.Vehicles.Deleter.y, Config.Fisherman.Vehicles.Deleter.z) < Config.Fisherman.Vehicles.MarkerSizeDeleter then
	            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour ranger un véhicule")
	            if IsControlJustPressed(1, 38) then
                	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),  false)
                	local vehicleProperties = ESX.Game.GetVehicleProperties(vehicle)
                	if vehicleProperties.plate == nil then
                		vehicleProperties.plate = GetVehicleNumberPlateText(vehicle)
                	end
					TriggerServerEvent('esx_society:putVehicleInGarage', 'fisherman', vehicleProperties)
					ESX.Game.DeleteVehicle(vehicle)
	            end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Boat.Spawner.x, Config.Fisherman.Boat.Spawner.y, Config.Fisherman.Boat.Spawner.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Fisherman.Boat.Spawner.x, Config.Fisherman.Boat.Spawner.y, Config.Fisherman.Boat.Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Boat.Spawner.x, Config.Fisherman.Boat.Spawner.y, Config.Fisherman.Boat.Spawner.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule")
		            if IsControlJustPressed(1, 38) then
						ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

							local elements = {}
							for i=1, #garageVehicles, 1 do
								table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
							end
							ESX.UI.Menu.CloseAll()
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
								  title    = 'Garage de bateaux',
								  elements = elements,
								},
								function(data, menu)
									menu.close()

									local vehicleProps = data.current.value
									ESX.Game.SpawnVehicle(vehicleProps.model, Config.Fisherman.Boat.SpawnPoint, Config.Fisherman.Boat.Heading, function(vehicle)
										ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
										TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
										TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
										TriggerServerEvent('esx_society:removeVehicleFromGarage', 'fisherman2', vehicleProps)
									end)
								end,
								function(data, menu)
								  menu.close()
								end
							)

						end, 'fisherman2')
		            	InMarker = true
		            end
		        elseif InMarker then
		        	InMarker = false
				end
			end

			if IsPedInAnyBoat(GetPlayerPed(-1)) and Vdist(coords.x, coords.y, coords.z, Config.Fisherman.Boat.Deleter.x, Config.Fisherman.Boat.Deleter.y, Config.Fisherman.Boat.Deleter.z) < Config.Fisherman.Boat.MarkerSizeDeleter then
	            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour ranger un véhicule")
	            if IsControlJustPressed(1, 38) then
                	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),  false)
					TriggerServerEvent('esx_society:putVehicleInGarage', 'fisherman2', ESX.Game.GetVehicleProperties(vehicle))
					ESX.Game.DeleteVehicle(vehicle)
					SetEntityCoords(GetPlayerPed(-1), -1612.98, 5262.23, 3.97, 0.0, 0.0, 0.0, false)
	            end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.OnService.x, Config.Fisherman.OnService.y, Config.Fisherman.OnService.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Fisherman.OnService.x, Config.Fisherman.OnService.y, Config.Fisherman.OnService.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Fisherman.OnService.x, Config.Fisherman.OnService.y, Config.Fisherman.OnService.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour vous changer")
		            if IsControlJustPressed(1, 38) then
		            	OnService()
		            	InMarker = true
		            end
		        elseif InMarker then
		        	InMarker = false
				end
			end
		end
	end
end)

function HelpMsg(msg)
	SetTextComponentFormat('STRING')
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Create blips
function setBlip()
	--Blip Fishing Captain
	local blip = AddBlipForCoord(Config.Fisherman.OnService.x, Config.Fisherman.OnService.y, Config.Fisherman.OnService.z)
  	SetBlipSprite (blip, 356)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.2)
  	SetBlipColour (blip, 38)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('Fishing Captain')
  	EndTextCommandSetBlipName(blip)

	if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
		--Blip Farm
		blip = AddBlipForCoord(Config.Fisherman.Harvest.x, Config.Fisherman.Harvest.y, Config.Fisherman.Harvest.z)
	  	SetBlipSprite (blip, 68)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
  		SetBlipColour (blip, 38)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Récolte de poissons')
	  	EndTextCommandSetBlipName(blip)


		--Blip traitement
		blip = AddBlipForCoord(Config.Fisherman.Treatment.x, Config.Fisherman.Treatment.y, Config.Fisherman.Treatment.z)
	  	SetBlipSprite (blip, 365)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
  		SetBlipColour (blip, 38)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Fridgit')
	  	EndTextCommandSetBlipName(blip)


		--Blip vente
		blip = AddBlipForCoord(Config.Fisherman.Sell.x, Config.Fisherman.Sell.y, Config.Fisherman.Sell.z)
	  	SetBlipSprite (blip, 371)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
  		SetBlipColour (blip, 38)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('LA SPADA')
	  	EndTextCommandSetBlipName(blip)


		--Blip plunge wear
		blip = AddBlipForCoord(Config.Fisherman.HarvestGazBottles.x, Config.Fisherman.HarvestGazBottles.y, Config.Fisherman.HarvestGazBottles.z)
	  	SetBlipSprite (blip, 356)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
  		SetBlipColour (blip, 38)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Préparation de bouteilles de gaz')
	  	EndTextCommandSetBlipName(blip)


		--Blip gaz bottles
		blip = AddBlipForCoord(Config.Fisherman.HarvestPlungeWear.x, Config.Fisherman.HarvestPlungeWear.y, Config.Fisherman.HarvestPlungeWear.z)
	  	SetBlipSprite (blip, 356)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
  		SetBlipColour (blip, 38)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Préparation de tenues de plongés')
	  	EndTextCommandSetBlipName(blip)
	end
end

local isInService = false
function OnService()
	if isInService then
		TriggerServerEvent("player:serviceOff", "fisherman")
	else
		TriggerServerEvent("player:serviceOn", "fisherman")
	end
	isInService = not isInService

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = 'Vestiaire',
			elements = {
				{label = 'Tenue civile', value = 'citizen_wear'},
				{label = 'Tenue de pêcheur', value = 'fisher_wear'},
				{label = 'Tenue de prospection', value = 'prospecting_wear'}
			}
		},
		function(data, menu)
			menu.close()

			if data.current.value == 'citizen_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

			elseif data.current.value == 'fisher_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

					ClearPedProp(GetPlayerPed(-1), 0)
					if skin.sex == 0 then --Homme
						SetPedComponentVariation(GetPlayerPed(-1), 8, 44, 0, 0)--T-Shirt
						SetPedComponentVariation(GetPlayerPed(-1), 11, 69, 0, 0)--Torse
						SetPedComponentVariation(GetPlayerPed(-1), 3, 64, 0, 0)--Bras
				        SetPedComponentVariation(GetPlayerPed(-1), 4, 36, 0, 0)--Jambes
						SetPedComponentVariation(GetPlayerPed(-1), 6, 54, 0, 0)--Chaussures
					else --Femme
						SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 2, 0)--T-Shirt
						SetPedComponentVariation(GetPlayerPed(-1), 11, 63, 0, 0)--Torse
						SetPedComponentVariation(GetPlayerPed(-1), 3, 78, 0, 0)--Bras
				        SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)--Jambes
						SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--Chaussures
					end
				end)

			elseif data.current.value == 'prospecting_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

					ClearPedProp(GetPlayerPed(-1), 0)
					if skin.sex == 0 then --Homme
						SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--T-Shirt
						SetPedComponentVariation(GetPlayerPed(-1), 11, 146, 6, 0)--Torse
						SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 0)--Bras
				        SetPedComponentVariation(GetPlayerPed(-1), 4, 17, 5, 0)--Jambes
						SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 5, 0)--Chaussures
					else --Femme
						SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 0)--T-Shirt
						SetPedComponentVariation(GetPlayerPed(-1), 11, 141, 1, 0)--Torse
						SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 0)--Bras
				        SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 8, 0)--Jambes
						SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 7, 0)--Chaussures
					end
				end)
			end
		end
	)
end

RegisterNetEvent('esx_fishing:setGazBottle')
AddEventHandler('esx_fishing:setGazBottle', function()
	local playerPed  = GetPlayerPed(-1)
	SetEnableScuba(playerPed, true)
	SetPedMaxTimeUnderwater(playerPed, 700.0)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then --Homme
			SetPedPropIndex(playerPed, 1, 26, 2, 1)
		else
			SetPedPropIndex(playerPed, 1, 28, 4, 1)
		end
	end)
	local coords     = GetEntityCoords(playerPed)
	ESX.Game.SpawnObject('p_michael_scuba_tank_s', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 24818), -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)

		while not IsControlPressed(0, 21) or not IsControlJustPressed(0, 244) do
			Wait(20)
		end
		SetEnableScuba(playerPed, false)
		DeleteObject(object)
	end)
end)

RegisterNetEvent('esx_fishing:setPlungeWear')
AddEventHandler('esx_fishing:setPlungeWear', function()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		ClearPedProp(GetPlayerPed(-1), 0)
		if skin.sex == 0 then --Homme
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--T-Shirt
			SetPedComponentVariation(GetPlayerPed(-1), 11, 243, 2, 0)--Torse
			SetPedComponentVariation(GetPlayerPed(-1), 3, 86, 0, 0)--Bras
		    SetPedComponentVariation(GetPlayerPed(-1), 4, 94, 2, 0)--Jambes
			SetPedComponentVariation(GetPlayerPed(-1), 6, 67, 2, 0)--Chaussures
			SetPedComponentVariation(GetPlayerPed(-1), 1, 122, 1, 0)--Masque
		else --Femme
			SetPedComponentVariation(GetPlayerPed(-1), 8, 3, 0, 0)--T-Shirt
			SetPedComponentVariation(GetPlayerPed(-1), 11, 251, 4, 0)--Torse
			SetPedComponentVariation(GetPlayerPed(-1), 3, 52, 0, 0)--Bras
		    SetPedComponentVariation(GetPlayerPed(-1), 4, 97, 4, 0)--Jambes
			SetPedComponentVariation(GetPlayerPed(-1), 6, 70, 4, 0)--Chaussures
			SetPedComponentVariation(GetPlayerPed(-1), 1, 122, 4, 0)--Masque
		end
	end)
end)