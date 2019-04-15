-------------------------------------------------
-------------------------------------------------
----    File : client.lua                 	 ----
----    Author: gassastsina               	 ----
----	Side : client 		 			  	 ----
----    Description : Fuck in a car with NPC ----
-------------------------------------------------
-------------------------------------------------

ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1000)
  end
end)

local function PlayAnim(dataAnim, ped)
	RequestAnimDict(dataAnim.lib)
	while not HasAnimDictLoaded(dataAnim.lib) do
		Citizen.Wait(0)
	end
	if HasAnimDictLoaded(dataAnim.lib) then
		TaskPlayAnim(ped, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, 49, 0, 0, 0, 0)
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(15)
		local handle, ped = FindFirstPed()
		local success
		repeat
		    success, ped = FindNextPed(handle)
		    local player = GetPlayerPed(-1)
	        if IsPedSittingInAnyVehicle(player) and IsControlJustPressed(1, 86) then
				local playerloc = GetEntityCoords(player, true)
				local pos = GetEntityCoords(ped)
              	if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc.x, playerloc.y, playerloc.z, true) <= 10 then
				    if DoesEntityExist(ped) and not IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and GetPedType(ped) ~= 28 and ped ~= player and ped ~= oldped then
				    	negotiating = true
				    	local pedModel = GetEntityModel(ped)
				    	for i=1, Config.ModelList, 1 do
				    		if pedModel == Config.ModelList[i] then
								oldped = ped
								SetEntityAsMissionEntity(ped)
								ClearPedTasks(ped)
								local vehicle = GetVehiclePedIsIn(player, true)
								TaskEnterVehicle(NPCs[i], vehicle, -1, 0, 1.4, 1, 0)
								while not IsPedSittingInVehicle(ped, vehicle) and not GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc.x, playerloc.y, playerloc.z, false) <= 15 do
									playerloc = GetEntityCoords(player, true)
									pos = GetEntityCoords(ped)
									Wait(500)
								end
								Wait(1000)
								while IsPedSittingInVehicle(ped, vehicle) do
									if IsPedSittingInVehicle(player, vehicle) then
							            SetTextComponentFormat('STRING')
							            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour demander un service")
							            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
							            if IsControlJustPressed(1, 38) then
					                    	ESX.UI.Menu.CloseAll()
							                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choice_service', {
							                    title    = 'Services',
							                    elements = {
							                    	{label = "Se faire sucer", 	value = 'suck'},
							                    	{label = "Faire l'amour", 	value = 'fuck'},
							                    	{label = "Arrêter", 		value = 'stop'},
							                    	{label = "Lui demander de quitter le véhicule", value = 'leave'}
							                    },
							                },
						                    function(data, menu)
						                    	menu.close()
						                    	if data.current.value == 'suck' then
						                    		PlayAnim({lib = "oddjobs@towing", anim = "f_blow_job_loop"}, ped)
						                    		PlayAnim({lib = "oddjobs@towing", anim = "m_blow_job_loop"}, player)

						                    	elseif data.current.value == 'fuck' then
						                    		PlayAnim({lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}, ped)
						                    		PlayAnim({lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}, player)

						                    	elseif data.current.value == 'leave' then
													ClearPedTasks(ped)
													ClearPedTasks(player)
													Wait(1000)
					            					TaskLeaveAnyVehicle(ped, 0, 0)
						                    	else
													ClearPedTasks(ped)
													ClearPedTasks(player)
						                    	end
						                    end,
						                    function(data, menu)
						                        menu.close()
						                    end)
							            end
						            end
								end
					        	Wait(10)
					        	break
					        end
					    end
			        end
		        end
	        end
		until not success
		EndFindPed(handle)
	end
end)