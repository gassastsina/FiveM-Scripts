------------------------------------
------------------------------------
----    File : client.lua       ----
----    Author : gassastsina    ----
----    Side : client         	----
----    Description : Drugs 	----
------------------------------------
------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
local PlayerData                = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

----------------------------------------------------effects----------------------------------------------
local drugged = false
local function Drug(effect)
	Citizen.CreateThread(function()
		while drugged do
			Wait(500)
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.017)
		end
	end)
	Citizen.CreateThread(function()
		while drugged do
			Wait(180)
			if IsControlJustPressed(1, 141) or IsControlJustPressed(1, 142) or IsControlJustPressed(1, 143) or IsControlJustPressed(1, 22) then
				Wait(400)
				SetPedToRagdoll(GetPlayerPed(PlayerId()), 1300, 1300, 0, true, true, false)
			end
		end
	end)
	if not drugged then		
		RequestAnimSet("move_m@drunk@verydrunk")
		while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
			Wait(100)
		end
		ClearPedTasks(ped)
		DoScreenFadeOut(1000)
		Wait(1000)
		local ped = GetPlayerPed(-1)

		SetPedMovementClipset(ped, "move_m@drunk@verydrunk", true)
		SetTimecycleModifier("spectator5")
		SetPedMotionBlur(ped, true)
		SetPedIsDrunk(ped, true)
		drugged = true
      	DoScreenFadeIn(800)

		Wait(effect)

		DoScreenFadeOut(900)
		Wait(900)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(ped, 0)
		SetPedIsDrunk(ped, false)
		SetPedMotionBlur(ped, false)
		drugged = false
		DoScreenFadeIn(1000)
	end
end

-----------------------------------------------main-------------------------------------------------------
Citizen.CreateThread(function()
	local farming = {}
	while true do
		Wait(8)
		if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' then
			local coords = GetEntityCoords(GetPlayerPed(-1), false)
			for i=1, #Config.Points, 1 do
				if Vdist(coords.x, coords.y, coords.z, Config.Points[i].x, Config.Points[i].y, Config.Points[i].z) < Config.DrawDistance then
					if not farming[i] and Config.Points[i].actionType ~= 'harvest' then
						DrawMarker(1, Config.Points[i].x, Config.Points[i].y, Config.Points[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
					if Vdist(coords.x, coords.y, coords.z, Config.Points[i].x, Config.Points[i].y, Config.Points[i].z) < Config.MarkerSize.x then
						if not farming[i] then
				            SetTextComponentFormat('STRING')
				            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour "..Config.Points[i].actionTypeLabel.." de la "..Config.Points[i].drugType)
				            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				        end
				  		if not farming[i] and IsControlJustReleased(1, 38) then
				  			farming[i] = true
				        	if Config.Points[i].actionType == 'harvest' then
				        		TriggerServerEvent('farms:Harvest', Config.Points[i].item, Config.Points[i].count, Config.Points[i].time)
				        	elseif Config.Points[i].actionType == 'treatment' then
				        		TriggerServerEvent('farms:Treatment', Config.Points[i].fromItem, Config.Points[i].fromCount, Config.Points[i].toItem, Config.Points[i].toCount, Config.Points[i].time)

				        		if Config.Points[i].fromItem ~= 'weed' and Config.Points[i].fromItem ~= 'weed2' and Config.Points[i].fromItem ~= 'weed3' and Config.Points[i].fromItem ~= 'weed4' then
				        			local effect = Config.MaxDrugTime
				        			local DrugStep = Config.MaxDrugTime/15
				        			local ped = GetPlayerPed(-1)
				        			if GetPedDrawableVariation(ped, 1) == 38 or GetPedDrawableVariation(ped, 1) == 46 or GetPedDrawableVariation(ped, 1) == 129 or GetPedDrawableVariation(ped, 1) == 130 or GetPedPropIndex(ped, 1) == 26 then --Masque
				        				effect = effect - DrugStep*5
				        			end
				        			if GetPedDrawableVariation(ped, 11) == 67 then --Torse
				        				effect = effect - DrugStep*3
				        			end
				        			if GetPedDrawableVariation(ped, 4) == 40 then --Jambes
				        				effect = effect - DrugStep*2
				        			end
				        			if GetPedDrawableVariation(ped, 6) ~= 58 and GetPedDrawableVariation(ped, 6) ~= 42 and GetPedDrawableVariation(ped, 6) ~= 41 and GetPedDrawableVariation(ped, 6) ~= 36 and GetPedDrawableVariation(ped, 6) ~= 34 and GetPedDrawableVariation(ped, 6) ~= 30 and GetPedDrawableVariation(ped, 6) ~= 23 and GetPedDrawableVariation(ped, 6) ~= 16 and GetPedDrawableVariation(ped, 6) ~= 6 and GetPedDrawableVariation(ped, 6) ~= 5 and GetPedDrawableVariation(ped, 6) ~= 3 and GetPedDrawableVariation(ped, 6) ~= 1 then --Chaussures
				        				effect = effect - DrugStep*1
				        			end
				        			if GetPedDrawableVariation(ped, 3) == 16 or (GetPedDrawableVariation(ped, 3) >= 63 and GetPedDrawableVariation(ped, 3) <= 73) or (GetPedDrawableVariation(ped, 3) >= 85 and GetPedDrawableVariation(ped, 3) <= 95) or GetPedDrawableVariation(ped, 3) == 119 or GetPedDrawableVariation(ped, 3) == 121 or GetPedDrawableVariation(ped, 3) == 126 or GetPedDrawableVariation(ped, 3) == 128 or GetPedDrawableVariation(ped, 3) == 133 or GetPedDrawableVariation(ped, 3) == 135 then --Gants
				        				effect = effect - DrugStep*4
				        			end
				        			Citizen.CreateThread(function()
				        				if effect > 0 then
											Wait(300000)
											Drug(effect)
										end
				        			end)
				        		end
				        	else
				        		print("ERROR drugs : Can't find actionType")
				        	end
				        	break
				        end
			        elseif farming[i] then
			        	TriggerServerEvent('farms:stop')
			        	farming[i] = false
				    end
				end
			end
		end
  	end
end)