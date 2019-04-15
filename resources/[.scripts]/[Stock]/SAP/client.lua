---------------------------------------------
---------------------------------------------
----    File : client.lua              	 ----
----    Author : gassastsina             ----
----	Side : client 					 ----
----    Description : San Andreas Petrol ----
---------------------------------------------
---------------------------------------------

--------------------------------------------ESX----------------------------------------------------------
ESX = nil
PlayerData = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

-----------------------------------------------main-------------------------------------------------------
local function setBlip()
	local blip = AddBlipForCoord(Config.SAP.OnService.x, Config.SAP.OnService.y, Config.SAP.OnService.z)
  	SetBlipSprite (blip, 361)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.0)
  	SetBlipColour (blip, 21)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('San Andreas Petrol')
  	EndTextCommandSetBlipName(blip)

  	if PlayerData.job.name == 'sap' then
		blip = AddBlipForCoord(Config.SAP.Harvest.x, Config.SAP.Harvest.y, Config.SAP.Harvest.z)
	  	SetBlipSprite (blip, 361)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.0)
	  	SetBlipColour (blip, 21)
	  	SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString("Récolte d'essence")
	  	EndTextCommandSetBlipName(blip)
	  	
		blip = AddBlipForCoord(Config.SAP.JerryCanHarvest.x, Config.SAP.JerryCanHarvest.y, Config.SAP.JerryCanHarvest.z)
	  	SetBlipSprite (blip, 361)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.0)
	  	SetBlipColour (blip, 21)
	  	SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Récolte de jerricans')
	  	EndTextCommandSetBlipName(blip)
	  	
		blip = AddBlipForCoord(Config.SAP.JerryCanTreatment.x, Config.SAP.JerryCanTreatment.y, Config.SAP.JerryCanTreatment.z)
	  	SetBlipSprite (blip, 361)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.0)
	  	SetBlipColour (blip, 21)
	  	SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString("Traitement des jerricans")
	  	EndTextCommandSetBlipName(blip)
  	end
end

local GasStations = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	setBlip()
	ESX.TriggerServerCallback('SAP:getStations', function(stations)
		GasStations = stations
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	setBlip()
end)

local isInService = false
local function OnService()
	if isInService then
		TriggerServerEvent("player:serviceOff", "sap")
	else
		TriggerServerEvent("player:serviceOn", "sap")
	end
	isInService = not isInService

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = 'Vestiaire',
			elements = {
				{label = 'Tenue civile', value = 'citizen_wear'},
				{label = 'Tenue de travail', value = 'working_wear'}
			}
		},
		function(data, menu)
			menu.close()

			if data.current.value == 'citizen_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

			elseif data.current.value == 'working_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local ped = GetPlayerPed(-1)
					ClearPedProp(ped, 0)
					if skin.sex == 0 then --Homme
						SetPedComponentVariation(ped, 8, 15, 0, 0)--T-Shirt
						SetPedComponentVariation(ped, 11, 248, 19, 0)--Torse
						SetPedComponentVariation(ped, 3, 50, 0, 0)--Bras
				        SetPedComponentVariation(ped, 4, 9, 7, 0)--Jambes
						SetPedComponentVariation(ped, 6, 12, 6, 0)--Chaussures
						SetPedPropIndex(ped, 0, 0, 3, 0)
					else --Femme
						SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--T-Shirt
						SetPedComponentVariation(GetPlayerPed(-1), 11, 256, 19, 0)--Torse
						SetPedComponentVariation(GetPlayerPed(-1), 3, 51, 0, 0)--Bras
				        SetPedComponentVariation(GetPlayerPed(-1), 4, 41, 2, 0)--Jambes
						SetPedComponentVariation(GetPlayerPed(-1), 6, 52, 3, 0)--Chaussures
						SetPedPropIndex(ped, 0, 0, 3, 0)
					end
				end)
			end
			menu.close()
		end
	)
end

local function HelpMsg(msg)
	SetTextComponentFormat('STRING')
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local InMarker = false
Citizen.CreateThread(function()
	while ESX == nil do
		Wait(10)
	end
	local alreadySell = {}
	ESX.TriggerServerCallback('SAP:getStations', function(stations)
		GasStations = stations
		for i=1, #GasStations, 1 do
			alreadySell[i] = true
		end
	end)
	while true do
		Citizen.Wait(10)
		if PlayerData.job ~= nil and PlayerData.job.name == 'sap' then
			local coords = GetEntityCoords(GetPlayerPed(-1), true)

			if Vdist(coords.x, coords.y, coords.z, Config.SAP.Harvest.x, Config.SAP.Harvest.y, Config.SAP.Harvest.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.SAP.Harvest.x, Config.SAP.Harvest.y, Config.SAP.Harvest.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x+2, Config.MarkerSize.y+1, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if not InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.Harvest.x, Config.SAP.Harvest.y, Config.SAP.Harvest.z) < Config.MarkerSize.x+2 then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour pomper de l'essence")
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('farms:Harvest', 'essence', 1, 4000)
		            	InMarker = true
		            end
		        elseif InMarker then
		        	TriggerServerEvent('farms:stop')
		        	InMarker = false
				end
			end

			for i=1, #GasStations, 1 do
				if alreadySell[i] and Vdist(coords.x, coords.y, coords.z, GasStations[i].x, GasStations[i].y, GasStations[i].z) < Config.DrawDistance then
					if not InMarker then
						DrawMarker(Config.MarkerType, GasStations[i].x, GasStations[i].y, GasStations[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, 255, 255, 0, 100, false, true, 2, false, false, false, false)
					end
					if not InMarker and Vdist(coords.x, coords.y, coords.z, GasStations[i].x, GasStations[i].y, GasStations[i].z) < Config.MarkerSize.x then
			            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour livrer l'essence")
			            if IsControlJustPressed(1, 38) then
			            	TriggerServerEvent('SAP:StartSellPetrol', GasStations[i])
			            	Citizen.CreateThread(function()
								alreadySell[i] = false
								for i=0, 600, 1 do
									Wait(1000)
								end
								alreadySell[i] = true
			            	end)
			            	InMarker = true

			            end
			        elseif InMarker then
			        	TriggerServerEvent('SAP:StopFarming')
			        	InMarker = false
					end
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.SAP.JerryCanHarvest.x, Config.SAP.JerryCanHarvest.y, Config.SAP.JerryCanHarvest.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.SAP.JerryCanHarvest.x, Config.SAP.JerryCanHarvest.y, Config.SAP.JerryCanHarvest.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if not InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.JerryCanHarvest.x, Config.SAP.JerryCanHarvest.y, Config.SAP.JerryCanHarvest.z) <= Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour récupérer des jerricans")
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('farms:Harvest', 'petrol_can', 1, 4000)
		            	InMarker = true
		            end
		        elseif InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.JerryCanHarvest.x, Config.SAP.JerryCanHarvest.y, Config.SAP.JerryCanHarvest.z) > Config.MarkerSize.x then
		        	TriggerServerEvent('farms:stop')
		        	InMarker = false
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.SAP.JerryCanTreatment.x, Config.SAP.JerryCanTreatment.y, Config.SAP.JerryCanTreatment.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.SAP.JerryCanTreatment.x, Config.SAP.JerryCanTreatment.y, Config.SAP.JerryCanTreatment.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if not InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.JerryCanTreatment.x, Config.SAP.JerryCanTreatment.y, Config.SAP.JerryCanTreatment.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour remplir les jerricans d'essence")
		            if IsControlJustPressed(1, 38) then
		            	TriggerServerEvent('SAP:StartTreatmentPetrolCan')
		            	InMarker = true
		            end
		        elseif InMarker then
		        	TriggerServerEvent('SAP:StopFarming')
		        	InMarker = false
				end
			end

			if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
				if Vdist(coords.x, coords.y, coords.z, Config.SAP.BossActions.x, Config.SAP.BossActions.y, Config.SAP.BossActions.z) < Config.DrawDistance then
					if not InMarker then
						DrawMarker(Config.MarkerType, Config.SAP.BossActions.x, Config.SAP.BossActions.y, Config.SAP.BossActions.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
					if not InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.BossActions.x, Config.SAP.BossActions.y, Config.SAP.BossActions.z) < Config.MarkerSize.x then
			            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour gérer l'entreprise")
			            if IsControlJustPressed(1, 38) then
							TriggerEvent('esx_society:openBossMenu', 'sap', function(data, menu)
					        	menu.close()
					        end)
		            	InMarker = true
		            end
		        elseif InMarker then
		        	InMarker = false
					end
				end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.SAP.Vehicles.Spawner.x, Config.SAP.Vehicles.Spawner.y, Config.SAP.Vehicles.Spawner.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.SAP.Vehicles.Spawner.x, Config.SAP.Vehicles.Spawner.y, Config.SAP.Vehicles.Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if not InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.Vehicles.Spawner.x, Config.SAP.Vehicles.Spawner.y, Config.SAP.Vehicles.Spawner.z) < Config.MarkerSize.x then
		            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule")
		            if IsControlJustPressed(1, 38) then
						ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

							local elements = {}
							for i=1, #garageVehicles, 1 do
								table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
							end
							ESX.UI.Menu.CloseAll()
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
								  title    = 'Garage de véhicules',
								  elements = elements,
								},
								function(data, menu)
									menu.close()

									local vehicleProps = data.current.value
									ESX.Game.SpawnVehicle(vehicleProps.model, Config.SAP.Vehicles.SpawnPoint, Config.SAP.Vehicles.Heading, function(vehicle)
										ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
										TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
										TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
										TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
										TriggerServerEvent('esx_society:removeVehicleFromGarage', 'sap', vehicleProps)
										while true do
											Wait(10)
		            						HelpMsg("Appuyez sur Y pour sortir une remorque sinon appuyez sur N")
											DisableControlAction(0, 246, true)
											DisableControlAction(0, 249, true)
											if IsDisabledControlPressed(0, 246) then --Yes
												ESX.Game.SpawnVehicle('TANKER', Config.SAP.Vehicles.Trailer, GetEntityHeading(vehicle), function(trailer)
													TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(trailer))
												end)
												break
											elseif IsDisabledControlPressed(0, 249) then --No
												break
											end
										end
									end)
								end,
								function(data, menu)
								  menu.close()
								end
							)
						end, 'sap')
		            	InMarker = true
		            end
		        elseif InMarker then
		        	InMarker = false
				end
			end

			if IsPedInAnyVehicle(GetPlayerPed(-1), true) and Vdist(coords.x, coords.y, coords.z, Config.SAP.Vehicles.Deleter.x, Config.SAP.Vehicles.Deleter.y, Config.SAP.Vehicles.Deleter.z) < Config.SAP.Vehicles.MarkerSizeDeleter then
	            HelpMsg("Appuyez sur ~INPUT_CONTEXT~ pour ranger un véhicule")
	            if IsControlJustPressed(1, 38) then
                	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),  false)
					TriggerServerEvent('esx_society:putVehicleInGarage', 'sap', ESX.Game.GetVehicleProperties(vehicle))
					ESX.Game.DeleteVehicle(vehicle)
	            end
			end

			if Vdist(coords.x, coords.y, coords.z, Config.SAP.OnService.x, Config.SAP.OnService.y, Config.SAP.OnService.z) < Config.DrawDistance then
				if not InMarker then
					DrawMarker(Config.MarkerType, Config.SAP.OnService.x, Config.SAP.OnService.y, Config.SAP.OnService.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if not InMarker and Vdist(coords.x, coords.y, coords.z, Config.SAP.OnService.x, Config.SAP.OnService.y, Config.SAP.OnService.z) < Config.MarkerSize.x then
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

RegisterNetEvent('SAP:SetInMarker')
AddEventHandler('SAP:SetInMarker', function(marker)
	InMarker = marker
end)


RegisterNetEvent('SAP:openMenuSAP')
AddEventHandler('SAP:openMenuSAP', function(stations)
	local elements = {}
	for i=1, #stations, 1 do
		table.insert(elements, {label = stations[i].label.." ("..stations[i].quantity.."L)", qty = stations[i].quantity, x = stations[i].x, y = stations[i].y})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sap_menu', {
			title    = 'San Andreas Petrol',
			elements = elements
		},
		function(data, menu)
			menu.close()
			SetNewWaypoint(data.current.x, data.current.y)
		end,
		function(data, menu)
			menu.close()
		end
	)
end)