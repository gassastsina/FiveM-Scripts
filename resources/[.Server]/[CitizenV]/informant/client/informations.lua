------------------------------------
------------------------------------
----    File : informations.lua ----
----    Author: gassastsina     ----
----	Side : client 			----
----    Description : Missions 	----
------------------------------------
------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX           = nil
local PlayerData    = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(50)
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-----------------------------------------------main-------------------------------------------------------
local function heyPNJ()
    local PlayingAnim = false
    while true do
        Citizen.Wait(100)
        RequestAnimDict("random@shop_gunstore")
        while not HasAnimDictLoaded("random@shop_gunstore") do
            Citizen.Wait(100)
        end
        for i=1, #Config.Menu, 1 do
	        distance = GetDistanceBetweenCoords(Config.Menu[i].x, Config.Menu[i].y, Config.Menu[i].z, GetEntityCoords(GetPlayerPed(-1)))
	        if distance < 4 and not PlayingAnim and Config.Menu[i].id ~= nil then
	            TaskPlayAnim(Config.Menu[i].id,"random@shop_gunstore","_greeting", 1.0, -1.0, 4000, 0, 1, true, true, true)
	            PlayAmbientSpeech1(Config.Menu[i].id, Config.Menu[i].VoiceName, "SPEECH_PARAMS_FORCE", 1)
	            PlayingAnim = true
	            Citizen.Wait(4000)
	            if PlayingAnim then
	                TaskPlayAnim(Config.Menu[i].id,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
	                Citizen.Wait(40000)
	            end
	        --else
	            --TaskPlayAnim(Config.Menu[i].id,"random@shop_gunstore","_idle", 1.0, -1.0, -1, 0, 1, true, true, true)
	        end
	        if distance > 5.5 and distance < 6 then
	            PlayingAnim = false
	        end
	    end
    end
end

local function Receiver(vehicle, destination)
	while not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) or GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= GetHashKey(vehicle.model) do
		Wait(500)
	end
	SetNotificationTextEntry("STRING");
	AddTextComponentString("Bien joué, tu as récupéré le véhicule. Maintenant emmène le là-bas");
	SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Receleur", vehicle.label, "Bien joué, tu as récupéré le véhicule. Maintenant emmène le là-bas");
	DrawNotification(true, false)
    local blip = AddBlipForCoord(destination.x, destination.y, destination.z)
	SetBlipRoute(blip, true)
	SetBlipSprite(blip, 315)
	SetBlipRouteColour(blip, 85)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Destination receleur")
    EndTextCommandSetBlipName(blip)
	running = true
  	while running do
  		Wait(200)
  		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
	  		local coords = GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), true), true)
	  		if Vdist(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z) < 3.0 then
		        local DeliverieVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				SetVehicleUndriveable(DeliverieVehicle, true)
			    Citizen.CreateThread(function()
            		while GetEntitySpeed(DeliverieVehicle) > 1.0 do
            			Wait(200)
            		end
					FreezeEntityPosition(DeliverieVehicle, true)
			    end)
				SetVehicleEngineOn(DeliverieVehicle, false, false, false)
				ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
			        for i=1, #vehicles, 1 do
						if GetEntityModel(DeliverieVehicle) == GetHashKey(vehicles[i].model) and GetEntityModel(DeliverieVehicle) == GetHashKey(vehicle.model) then
							local price = math.ceil((vehicles[i].price*5)/100)
			        		TriggerServerEvent('informant:removeReceiveRunningAndreward', price, GetVehicleNumberPlateText(DeliverieVehicle))
			        		running = false
			        		RemoveBlip(blip)
							SetNotificationTextEntry("STRING");
							AddTextComponentString("Merci, les clients seront contents");
							SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Receleur", '~g~'..price..'$', "Merci, les clients seront contents");

			            	Citizen.CreateThread(function()
			            		Wait(60000)
			            		while GetEntitySpeed(DeliverieVehicle) > 1.0 do
			            			Wait(200)
			            		end
			            		DeleteVehicle(DeliverieVehicle)
			            	end)
							break
						end
					end
				end)
	  		end
	  	end
  	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.TriggerServerCallback('informant:getIsPlayerRunningReceive', function(vehicle, destination)
		if vehicle ~= nil and destination ~= nil then
			SetNotificationTextEntry("STRING");
			AddTextComponentString("Oublies pas, tu dois me ramener un véhicule");
			SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Receleur", vehicle.label, "Oublies pas, tu dois me ramener un véhicule");
			DrawNotification(true, false)
	        Citizen.CreateThread(function()
				Receiver(vehicle, destination)
			end)
		end
	end)

    for i=1, #Config.Menu, 1 do
    	if Config.Menu[i].id ~= nil then
		    RequestModel(GetHashKey(Config.Menu[i].modelHash))
		    while not HasModelLoaded(GetHashKey(Config.Menu[i].modelHash)) do
		      Wait(500)
		    end

	        Config.Menu[i].id = CreatePed(2, Config.Menu[i].modelHash, Config.Menu[i].x, Config.Menu[i].y, Config.Menu[i].z, Config.Menu[i].heading, false, true)
	        SetPedFleeAttributes(Config.Menu[i].id, 0, 0)
	        SetAmbientVoiceName(Config.Menu[i].id, Config.Menu[i].Ambiance)
	        SetPedDropsWeaponsWhenDead(Config.Menu[i].id, false)
	        SetPedDiesWhenInjured(Config.Menu[i].id, false)
	        GiveWeaponToPed(Config.Menu[i].id, Config.Menu[i].Weapon, 2800, false, true)
	    end
    end
    PlayerData = xPlayer
    heyPNJ()
end)

local function GoFast()
	ESX.TriggerServerCallback('informant:getCopsNumber', function(cops)
		if cops >= Config.MinCopsToGoFast then
			local GoFastConfig = Config.Points['go_fast']
		    local spawnLocalisation = math.random(1, #GoFastConfig.spawnsVehicle)
			local blip = AddBlipForCoord(GoFastConfig.spawnsVehicle[spawnLocalisation].x, GoFastConfig.spawnsVehicle[spawnLocalisation].y, GoFastConfig.spawnsVehicle[spawnLocalisation].z)
			SetBlipRoute(blip, true)
			SetBlipSprite(blip, 490)
			SetBlipRouteColour(blip, 4)
		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString("Véhicule de Go Fast")
		    EndTextCommandSetBlipName(blip)
		    running = true
		    while running do
		    	Wait(0)
			    local coords = GetEntityCoords(GetPlayerPed(-1), true)
			    if Vdist(coords.x, coords.y, coords.z, GoFastConfig.spawnsVehicle[spawnLocalisation].x, GoFastConfig.spawnsVehicle[spawnLocalisation].y, GoFastConfig.spawnsVehicle[spawnLocalisation].z) < 100.0 then
				    if not IsAnyVehicleNearPoint(GoFastConfig.spawnsVehicle[spawnLocalisation].x, GoFastConfig.spawnsVehicle[spawnLocalisation].y, GoFastConfig.spawnsVehicle[spawnLocalisation].z,  4.0) then
				    	local selectedVehicle = math.random(1, #GoFastConfig.vehicles)
				    	local vehicle = nil
						ESX.Game.SpawnVehicle(GoFastConfig.vehicles[selectedVehicle].model, {
							x = GoFastConfig.spawnsVehicle[spawnLocalisation].x,
							y = GoFastConfig.spawnsVehicle[spawnLocalisation].y,
							z = GoFastConfig.spawnsVehicle[spawnLocalisation].z
						}, GoFastConfig.spawnsVehicle[spawnLocalisation].heading, function(veh)
							vehicle = veh
							TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(veh))
						end)
						local timer = GoFastConfig.timer
						while not IsPedSittingInVehicle(GetPlayerPed(-1), vehicle) do
							Wait(1000)
							timer = timer - 1
							if timer <= 0 then
								ESX.Game.DeleteVehicle(vehicle)
								RemoveBlip(blip)
								SetNotificationTextEntry("STRING");
								AddTextComponentString("Tu as été trop lent, quelqu'un a prit le véhicule avant toi !");
								SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Go Fast", "ÉCHEC", "Tu as été trop lent, quelqu'un a prit le véhicule avant toi !");
								DrawNotification(true, false)
								running = false
								break
							end
						end
						if IsPedSittingInVehicle(GetPlayerPed(-1), vehicle) then
							local destination = math.random(1, #GoFastConfig.destinations)
							SetNotificationTextEntry("STRING");
							AddTextComponentString("T'arrêtes pas tu as fait la moitié du taff");
							SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Go Fast", "Allez allez allez, Go go go !", "T'arrêtes pas tu as fait la moitié du taff");
							DrawNotification(true, false)
							RemoveBlip(blip)
							blip = AddBlipForCoord(GoFastConfig.destinations[destination].x, GoFastConfig.destinations[destination].y, GoFastConfig.destinations[destination].z)
							SetBlipRoute(blip, true)
							SetBlipSprite(blip, 490)
							SetBlipRouteColour(blip, 4)
						    BeginTextCommandSetBlipName("STRING")
						    AddTextComponentString("Destination Final")
						    EndTextCommandSetBlipName(blip)

							TriggerEvent('pNotify:SetQueueMax', "left", 1)
							TriggerEvent('pNotify:SendNotification', {
						        text = "Il te reste "..tostring(GoFastConfig.timeToSell/60000).." minutes",
						        type = "warning",
						        timeout = 5000,
						        layout = "centerLeft",
						        queue = "left"
						  	})
							TriggerEvent('pNotify:SetQueueMax', "topLeft", 1)
							TriggerEvent('pNotify:SendNotification', {
						        text = "Go Fast",
						        type = "alert",
						        timeout = GoFastConfig.timeToSell,
						        layout = "topLeft",
						        queue = "topLeft"
						  	})

							Citizen.CreateThread(function()
								Wait(GoFastConfig.timeToSell)
								running = false
								TriggerEvent('pNotify:SetQueueMax', "left", 1)
								TriggerEvent('pNotify:SendNotification', {
							        text = "Tu es trop lent, tu sers vraiment à rien !",
							        type = "error",
							        timeout = 5000,
							        layout = "centerLeft",
							        queue = "left"
							  	})
								RemoveBlip(blip)
							end)

							while running do
								Wait(10)
								local vehicleCoords = GetEntityCoords(vehicle, true)
								DrawMarker(1, GoFastConfig.destinations[destination].x, GoFastConfig.destinations[destination].y, GoFastConfig.destinations[destination].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 0.7, 255, 255, 255, 100, false, true, 2, false, false, false, false)
								if Vdist(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, GoFastConfig.destinations[destination].x, GoFastConfig.destinations[destination].y, GoFastConfig.destinations[destination].z) < 3.0 then
									running = false
									RemoveBlip(blip)
									SetNotificationTextEntry("STRING");
									AddTextComponentString("Merci mec, laisse la là, maintenant on s'en occupe");
									SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Go Fast", "~g~"..tostring(GoFastConfig.vehicles[selectedVehicle].reward).."$", "Merci mec, laisse la là, maintenant on s'en occupe");
									DrawNotification(true, false)
									TriggerServerEvent('informant:reward', GoFastConfig.vehicles[selectedVehicle].reward)
									SetVehicleUndriveable(vehicle, true)
									SetVehicleEngineOn(vehicle, false, false, false)
									Citizen.CreateThread(function()
					            		while GetEntitySpeed(vehicle) > 1.0 do
					            			Wait(200)
					            		end
					            		FreezeEntityPosition(vehicle, true)
					            	end)

			                    	Citizen.CreateThread(function()
					            		Wait(60000)
					            		while GetEntitySpeed(vehicle) > 1.0 do
					            			Wait(200)
					            		end
					            		DeleteVehicle(vehicle)
					            	end)
								end
							end
						end
				    else
						SetNotificationTextEntry("STRING");
						AddTextComponentString("Tu as été trop lent, quelqu'un a prit le véhicule avant toi !");
						SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Go Fast", "ÉCHEC", "Tu as été trop lent, quelqu'un a prit le véhicule avant toi !");
						DrawNotification(true, false)
				    	GoFast()
				    	break
				    end
				end
			end
		else
			SetNotificationTextEntry("STRING");
			AddTextComponentString("~r~Il n'y a pas assez de policiers en ville");
			SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Go Fast", "Policiers", "~r~Il n'y a pas assez de policiers en ville");
			DrawNotification(true, false)
		end
	end)
end

RegisterNetEvent('informant:stopGoFast')
AddEventHandler('informant:stopGoFast', function()
	running = false
	SetNotificationTextEntry("STRING");
	AddTextComponentString("Tu me déçoies, bouges toi plus le cu la prochaine fois !");
	SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Go Fast", "ÉCHEC", "Tu me déçoies, bouges toi plus le cu la prochaine fois !");
	DrawNotification(true, false)
end)

local function HumanTraffic()
	ESX.TriggerServerCallback('informant:getCopsNumber', function(cops)
		if cops >= Config.MinCopsToPussy then
			local HumanTrafficConfig = Config.Points['pussy']
		    local truck = nil
		    if not IsAnyVehicleNearPoint(HumanTrafficConfig.spawnsVehicle.x, HumanTrafficConfig.spawnsVehicle.y, HumanTrafficConfig.spawnsVehicle.z,  4.0) then
				ESX.Game.SpawnVehicle(HumanTrafficConfig.vehicleModel, {
					x = HumanTrafficConfig.spawnsVehicle.x,
					y = HumanTrafficConfig.spawnsVehicle.y,
					z = HumanTrafficConfig.spawnsVehicle.z
				}, HumanTrafficConfig.spawnsVehicle.heading, function(vehicle)
					truck = vehicle
					TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
				end)
		    	running = true
			    local blip = AddBlipForCoord(HumanTrafficConfig.spawnsVehicle.x, HumanTrafficConfig.spawnsVehicle.y, HumanTrafficConfig.spawnsVehicle.z)
				SetBlipRoute(blip, true)
				SetBlipSprite(blip, 458)
				SetBlipRouteColour(blip, 17)
			    BeginTextCommandSetBlipName("STRING")
			    AddTextComponentString("Camion")
			    EndTextCommandSetBlipName(blip)
				while not IsPedSittingInVehicle(GetPlayerPed(-1), truck) do
					Wait(200)
				end
				RemoveBlip(blip)
		    else
				SetNotificationTextEntry("STRING");
				AddTextComponentString("Dégages la zone, je peux pas sortir le camion");
				SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Trafic d'êtres humains", "Zone encombrée", "Dégages la zone, je peux pas sortir le camion");
				DrawNotification(true, false)
		    	HumanTraffic()
		    	return
		    end
		    local NPCPoint = math.random(1, #HumanTrafficConfig.getNPC)
		    local blip = AddBlipForCoord(HumanTrafficConfig.getNPC[NPCPoint].x, HumanTrafficConfig.getNPC[NPCPoint].y, HumanTrafficConfig.getNPC[NPCPoint].z)
			SetBlipRoute(blip, true)
			SetBlipSprite(blip, 458)
			SetBlipRouteColour(blip, 17)
		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString("Marchandise")
		    EndTextCommandSetBlipName(blip)

			local totalPrice = 0
		    while running do
		    	Wait(20)
				DrawMarker(1, HumanTrafficConfig.getNPC[NPCPoint].x, HumanTrafficConfig.getNPC[NPCPoint].y, HumanTrafficConfig.getNPC[NPCPoint].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 0.7, 255, 108, 0, 100, false, true, 2, false, false, false, false)
			    local coords = GetEntityCoords(truck, true)
			    if Vdist(coords.x, coords.y, coords.z, HumanTrafficConfig.getNPC[NPCPoint].x, HumanTrafficConfig.getNPC[NPCPoint].y, HumanTrafficConfig.getNPC[NPCPoint].z) < 4.0 then
			    	coords = GetEntityCoords(GetPlayerPed(-1), true)
					DrawMarker(1, HumanTrafficConfig.getNPC[NPCPoint].Sx, HumanTrafficConfig.getNPC[NPCPoint].Sy, HumanTrafficConfig.getNPC[NPCPoint].Sz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 108, 0, 100, false, true, 2, false, false, false, false)
			    	if Vdist(coords.x, coords.y, coords.z, HumanTrafficConfig.getNPC[NPCPoint].Sx, HumanTrafficConfig.getNPC[NPCPoint].Sy, HumanTrafficConfig.getNPC[NPCPoint].Sz) < 1.5 then
			            SetTextComponentFormat('STRING')
			            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour récupérer la marchandise")
			            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			            if IsControlJustPressed(1, 38) then
			            	local NPCs = {}
			            	for i=1, math.random(1, 3), 1 do
								local pedModel = HumanTrafficConfig.NPCModel[math.random(1, #HumanTrafficConfig.NPCModel)]
								RequestModel(GetHashKey(pedModel))
							    while not HasModelLoaded(GetHashKey(pedModel)) do
							    	print('Informant : Loading ped : '..pedModel..'...')
							    	Wait(1500)
							    end
								local ped = CreatePed(math.random(0, 5), pedModel, HumanTrafficConfig.getNPC[NPCPoint].Sx, HumanTrafficConfig.getNPC[NPCPoint].Sy, HumanTrafficConfig.getNPC[NPCPoint].Sz, GetEntityHeading(GetPlayerPed(-1)), true, true)
								local n = 50
								while not DoesEntityExist(ped) do
									if n <= 0 then
										ped = CreatePed(math.random(0, 5), pedModel, HumanTrafficConfig.getNPC[NPCPoint].Sx, HumanTrafficConfig.getNPC[NPCPoint].Sy, HumanTrafficConfig.getNPC[NPCPoint].Sz, GetEntityHeading(GetPlayerPed(-1)), true, true)
										break
									end
									Wait(100)
									n = n - 1
								end
								SetEntityAsMissionEntity(ped)
								SetPedMovementClipset(ped, "move_m@buzzed", 1.0)
								TaskFollowToOffsetOfEntity(ped, GetPlayerPed(-1), 1.0, 1.0, 0.0, 1.4, -1, 10.0, true)
								SetPedMovementClipset(ped, "move_m@buzzed", 1.0)
								table.insert(NPCs, ped)
			            	end
			            	RemoveBlip(blip)
			            	while not IsPedSittingInVehicle(GetPlayerPed(-1), truck) do
			            		Wait(200)
			            	end
			            	local destination = HumanTrafficConfig.destinations[math.random(1, #HumanTrafficConfig.destinations)]
						    blip = AddBlipForCoord(destination.x, destination.y, destination.z)
							SetBlipRoute(blip, true)
							SetBlipSprite(blip, 458)
							SetBlipRouteColour(blip, 17)
						    BeginTextCommandSetBlipName("STRING")
						    AddTextComponentString("Marchandise")
						    EndTextCommandSetBlipName(blip)
			            	while running do
			            		Wait(20)
			            		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			            			local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
				            		for i=1, #NPCs, 1 do
				            			if not IsPedInVehicle(NPCs[i], vehicle, false) then
				            				ClearPedTasks(NPCs[i])
				            				if IsVehicleSeatFree(vehicle, 2) then
					            				TaskEnterVehicle(NPCs[i], vehicle, -1, 2, 1.4, 1, 0)
					            			elseif IsVehicleSeatFree(vehicle, 1) then
					            				TaskEnterVehicle(NPCs[i], vehicle, -1, 1, 1.4, 1, 0)
					            			elseif IsVehicleSeatFree(vehicle, 0) then
					            				TaskEnterVehicle(NPCs[i], vehicle, -1, 0, 1.4, 1, 0)
					            				Wait(1000)
					            			else
					            				TaskEnterVehicle(NPCs[i], vehicle, -1, -2, 1.4, 1, 0)
					            			end
					            		end
				            		end
			            		else
				            		for i=1, #NPCs, 1 do
				            			if IsPedInAnyVehicle(NPCs[i], false) then
				            				TaskLeaveAnyVehicle(NPCs[i], 0, 0)
				            				Citizen.CreateThread(function()
					            				Wait(2000)
												SetPedMovementClipset(NPCs[i], "move_m@buzzed", 1.0)
												TaskFollowToOffsetOfEntity(NPCs[i], GetPlayerPed(-1), 1.0, 1.0, 0.0, 1.4, -1, 10.0, true)
												SetPedMovementClipset(NPCs[i], "move_m@buzzed", 1.0)
											end)
				            			end
				            		end
			            		end
			            		coords = GetEntityCoords(GetPlayerPed(-1), true)
			            		if Vdist(coords.x, coords.y, coords.z, destination.Dx, destination.Dy, destination.Dz) < 1.5 then
						            SetTextComponentFormat('STRING')
						            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ appeler la marchandise")
						            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						            if IsControlJustPressed(1, 38) then
			            				for i=1, #NPCs, 1 do
			            					if IsPedInAnyVehicle(NPCs[i], false) then
			            						TaskLeaveAnyVehicle(NPCs[i], 0, 0)
			            					else
						            			TaskGoToCoordAnyMeans(NPCs[i], destination.Dx, destination.Dy, destination.Dz, 1.7, 0, 0, "move_m@depressed@a", 0.0)
						            		end
											SetPedMovementClipset(NPCs[i], "move_m@buzzed", 1.0)
						            	end
						            end
			            		end
			            		DrawMarker(1, destination.x, destination.y, destination.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 0.7, 255, 108, 0, 100, false, true, 2, false, false, false, false)
			            		coords = GetEntityCoords(truck, true)
			            		if Vdist(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z) < 4.0 then
				            		DrawMarker(1, destination.Dx, destination.Dy, destination.Dz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 0.5, 255, 108, 0, 100, false, true, 2, false, false, false, false)
				            		for i=1, #NPCs, 1 do
				            			coords = GetEntityCoords(NPCs[i], true)
				            			if Vdist(coords.x, coords.y, coords.z, destination.Dx, destination.Dy, destination.Dz) < 2.0 then
				            				SetEntityAsNoLongerNeeded(NPCs[i])
				            				DeleteEntity(NPCs[i])
				            				table.remove(NPCs, i)
				            				TriggerServerEvent('informant:reward', HumanTrafficConfig.priceByNPC)
				            				totalPrice = totalPrice + HumanTrafficConfig.priceByNPC
											SetNotificationTextEntry("STRING");
											AddTextComponentString("Tu as livré un packet");
											SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Trafic d'êtres humains", "~g~"..tostring(HumanTrafficConfig.priceByNPC).."$", "Tu as livré un packet");
											DrawNotification(true, false)

											if json.encode(NPCs) == '[]' then
						            			running = false
						            			SetVehicleUndriveable(truck, true)
						            			FreezeEntityPosition(truck, true)
						            			SetVehicleEngineOn(truck, false, false, false)
												SetNotificationTextEntry("STRING");
												AddTextComponentString("Tu as livré toute la marchandise");
												SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Trafic d'êtres humains", "~b~"..tostring(totalPrice).."$", "Tu as livré toute la marchandise");
												DrawNotification(true, false)
												RemoveBlip(blip)
						                    	Citizen.CreateThread(function()
								            		Wait(60000)
								            		while GetEntitySpeed(vehicle) > 1.0 do
								            			Wait(200)
								            		end
								            		DeleteVehicle(vehicle)
								            	end)
						                    	break
											end
				            			end
				            		end
				            	end
			            	end
			            end
			    	end
			    end
			end
		else
			SetNotificationTextEntry("STRING");
			AddTextComponentString("~r~Il n'y a pas assez de policiers en ville");
			SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Trafic d'êtres humains", "Policiers", "~r~Il n'y a pas assez de policiers en ville");
			DrawNotification(true, false)
		end
	end)
end

local running = false
Citizen.CreateThread(function()
    Wait(4000)
    local openedMenu = false
    while true do
        Wait(15)
        for i=1, #Config.Menu, 1 do
	        if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and Config.Menu[i].id ~= nil and not openedMenu and Vdist(Config.Menu[i].x, Config.Menu[i].y, Config.Menu[i].z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
	        	if not running then
		            SetTextComponentFormat('STRING')
		            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour parler à l'informateur de "..Config.Menu[i].label)
		            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		            if IsControlJustPressed(1, 38) then
		            	openedMenu = true
	                    if Config.Menu[i].name == 'drug' then
			                ESX.TriggerServerCallback('informant:getWichDrugPoint', function(point)
			                	local elements = {}
			                	if point > #Config.Points['drug'] then
			                		point = #Config.Points['drug']
			                	end
			                	for x=1, point, 1 do
			                		table.insert(elements, {label = Config.Points['drug'][x].label.." - <span style='color:green;'>"..Config.Points['drug'][x].price.."$</span>", price = Config.Points['drug'][x].price, value = Config.Points['drug'][x].data, point = x})
			                	end
		                    	ESX.UI.Menu.CloseAll()
				                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choice_information', {
				                    title    = 'Informateur de '..Config.Menu[i].label,
				                    elements = elements,
				                },
			                    function(data, menu)
			                    	menu.close()
		                    		TriggerServerEvent('informant:buyDrug', data.current.point)
		                    		local information = data.current.value
		                    		for i=1, #information, 1 do
					                    local blip = AddBlipForCoord(information[i].x, information[i].y, information[i].z)
					                    SetBlipSprite (blip, information[i].blipSprite)
					                    SetBlipDisplay(blip, 4)
					                    SetBlipScale  (blip, 1.2)
					                    SetBlipAsShortRange(blip, true)
					                    
					                    BeginTextCommandSetBlipName("STRING")
					                    AddTextComponentString(information[i].label)
					                    EndTextCommandSetBlipName(blip)
					                end

		                    		TriggerServerEvent('informant:buyInformation', data.current.price)
									SetNotificationTextEntry("STRING");
									AddTextComponentString("Bon farm, par contre fais attention aux flics, on s'est jamais vu, jamais parlé");
									SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Informateur de drogue", Config.Points['drug'][data.current.point].label, "Bon farm, par contre fais attention aux flics, on s'est jamais vu, jamais parlé");
									DrawNotification(true, false)
									SetNotificationTextEntry("STRING");
									AddTextComponentString("Souviens-toi en, c'est comme ton copain, rien n'est gratuit");
									SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Informateur de drogue", Config.Points['drug'][data.current.point].label, "Par contre souviens-toi en, c'est comme ton copain, rien n'est gratuit");
									DrawNotification(true, false)
			                    end,
			                    function(data, menu)
			                        menu.close()
			                    end)
			                end)
			                
	                    elseif Config.Menu[i].name == 'illegalseller' then
	                    	TriggerEvent('informant:openIllegalSeller', 'BlackItems')
			                
	                    elseif Config.Menu[i].name == 'illegalweapon' then
	                    	TriggerEvent('informant:openIllegalSeller', 'BlackWeashop')
			                
	                    elseif Config.Menu[i].name == 'go_fast' then
							SetNotificationTextEntry("STRING");
							AddTextComponentString("Fais vite avant que quelqu'un prenne le véhicule !");
							SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Informateur", "Go Fast", "Fais vite avant que quelqu'un prenne le véhicule !");
							DrawNotification(true, false)
	                    	Citizen.CreateThread(function()
	                    		GoFast()
	                    	end)
			                
	                    elseif Config.Menu[i].name == 'pussy' then
							SetNotificationTextEntry("STRING");
							AddTextComponentString("Prends le camion et vas chercher la marchandise !");
							SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Trafic d'êtres humains", "Let's go !", "Prends le camion et vas chercher la marchandise !");
							DrawNotification(true, false)
	                    	Citizen.CreateThread(function()
	                    		HumanTraffic()
	                    	end)
			                
	                    elseif Config.Menu[i].name == 'receiver' then
	                    	ESX.TriggerServerCallback('informant:receiverCheckAlreadyRun', function(vehicle)
	                    		print('informant : Véhicule à récupérer : '..vehicle.label..' ('..vehicle.model..')')
								SetNotificationTextEntry("STRING");
								AddTextComponentString("Vas récupérer ce véhicule");
								SetNotificationMessage("CHAR_LESTER_DEATHWISH", "CHAR_LESTER_DEATHWISH", true, 1, "Receleur", vehicle.label, "Vas récupérer ce véhicule");
								DrawNotification(true, false)
	                    		Wait(5000)
								TriggerEvent('pNotify:SetQueueMax', "topLeft", 1)
								TriggerEvent('pNotify:SendNotification', {
							        text = vehicle.label,
							        type = "alert",
							        timeout = 900000,
							        layout = "topLeft",
							        queue = "topLeft"
							  	})
							  	local destination = Config.Points['receiver'].destinations[math.random(1, #Config.Points['receiver'].destinations)]
							  	TriggerServerEvent('informant:stockReceiverRun', vehicle, destination)
							  	TriggerServerEvent('informant:addInventoryItem', "carstarter_kit", 3)
	                    		Citizen.CreateThread(function()
							  		Receiver(vehicle, destination)
							  	end)
	                    	end)
	                    end
	                    Wait(5000)
	                    openedMenu = false
		            end
		        else
		            SetTextComponentFormat('STRING')
		            AddTextComponentString("Te fous pas d'ma gueule j'sais que t'es déjà en mission")
		            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		        end
		    end
	    end
    end
end)