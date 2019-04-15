----------------------------------------
----------------------------------------
----    File : client.lua         	----
----    Author: gassastsina       	----
----	Side : client 		 	  	----
----    Description : Jewel heist 	----
----------------------------------------
----------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
local PlayerData                = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end
end)

-----------------------------------------------main-------------------------------------------------------
local NPC = nil
local function spawnNPC()
    RequestModel(GetHashKey(Config.NPC.Model))
    while not HasModelLoaded(GetHashKey(Config.NPC.Model)) do
    	Wait(1000)
    end
    NPC = CreatePed(5, GetHashKey(Config.NPC.Model), Config.NPC.Pos.x, Config.NPC.Pos.y, Config.NPC.Pos.z, GetEntityHeading(GetPlayerPed(-1)), true, true)
    SetEntityAsMissionEntity(NPC)
    TaskStandStill(NPC, -1)

    TriggerServerEvent('jewelheist:NPCSpawned')
	Wait(5000)
	while DoesEntityExist(NPC) do
		Wait(5000)
	end
	SetEntityAsNoLongerNeeded(NPC)
	spawnNPC()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    ESX.TriggerServerCallback('jewelheist:getIsAlarmRinging', function(alarm)
    	if alarm then
			while not PrepareAlarm("JEWEL_STORE_HEIST_ALARMS") do
				Citizen.Wait(1000)
			end
			StartAlarm("JEWEL_STORE_HEIST_ALARMS", true)
		end
    end)

	local blip = AddBlipForCoord(Config.InsideJewelery.x, Config.InsideJewelery.y, Config.InsideJewelery.z)
	SetBlipSprite(blip, 439)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, 1.2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Bijouterie")
	SetBlipColour(blip, 46)
  	EndTextCommandSetBlipName(blip)

  	ESX.TriggerServerCallback('jewelheist:getIsNPCSpawned', function(pnj)
  		if pnj then
  			local n = 0
		  	while GetEntityModel(NPC) ~= GetHashKey(Config.NPC.Model) and n < 100 do
		  		Wait(1000)
		    	NPC, distance = ESX.Game.GetClosestPed(Config.NPC.Pos, {Config.NPC.Model})
		    	n = n + 1
		  	end
		  	if n >= 100 then
				spawnNPC()
		  	end
		  	print('DEBUG jewelheist :')
		    print(GetEntityModel(NPC))
		    print(GetHashKey(Config.NPC.Model))
		else
			spawnNPC()
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local HasAlreadyEnteredMarker   = false
local LastPart                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''

local IsGetCheckoutPassword = false

local function hasEnteredMarker(part)
    if part == 'HackAlarm' then
    	ESX.TriggerServerCallback('jewelheist:getItemAmount', function(qtty)
          if qtty > 0 then
	        CurrentAction     = 'hack_alarm'
	        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour hacker l'alarme"
          end
      end, 'hack_phone')
    elseif part == 'CopStopAlarm' then
    	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and IsAlarmPlaying("JEWEL_STORE_HEIST_ALARMS") then
	        CurrentAction     = 'cop_stop_alarm'
	        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour arrêter l'alarme"
	    end

    elseif part == 'Checkout' then
		ESX.TriggerServerCallback('jewelheist:getCheckoutHeisting', function(heisted)
			if heisted then
		        CurrentAction     = 'checkout_heist'
		        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour braquer la caisse"
				TriggerServerEvent('logs:write', "Est sur le point de braquer la caisse de la bijouterie")
			else
		        CurrentAction     = 'checkout_password'
		        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour entrer le mot de passe de la caisse"
		    end
	    end)
    elseif part == 'TakingHostage' then
    	if Vdist(GetEntityCoords(NPC, true), Config.NPC.NegoDesk.x, Config.NPC.NegoDesk.y, Config.NPC.NegoDesk.z) < 2.0 and not IsEntityPlayingAnim(NPC, "random@arrests@busted", "idle_a", 3) then
	        CurrentAction     = 'taking_hostage'
	        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour prendre en otage la gérante"
	    end
    elseif part == 'InteractWithNPC' then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			if ((skin.sex == 0 and GetPedDrawableVariation(GetPlayerPed(-1), 11) == 56 and GetPedDrawableVariation(GetPlayerPed(-1), 8) == 59) or --Homme
				(skin.sex == 1 and GetPedDrawableVariation(GetPlayerPed(-1), 11) == 49 and GetPedDrawableVariation(GetPlayerPed(-1), 8) == 36)) and	  --Femme
				Vdist(GetEntityCoords(NPC, true), Config.NPC.NegoDesk.x, Config.NPC.NegoDesk.y, Config.NPC.NegoDesk.z) > 2.0
			then
		        CurrentAction     = 'interact_with_npc'
		        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour négocier des peintures sur le batiment"
		        TaskLookAtEntity(NPC, GetPlayerPed(-1), -1, 2048, 3)
			end
		end)
    end
end

local function CheckoutEnterPassword()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'checkout_password', {
			title = "Mot de passe"
		},
		function(data, menu)
			ESX.TriggerServerCallback('jewelheist:getCheckoutPassword', function(password)
				if json.encode(data.value) == json.encode(password) then
					menu.close()
					TriggerEvent('pNotify:SetQueueMax', "left", 1)
					TriggerEvent('pNotify:SendNotification', {
					    text = "Mot de passe correct",
					    type = "success",
					    timeout = 2500,
					    layout = "centerLeft",
					    queue = "left"
					})
					TriggerServerEvent('jewelheist:CheckoutHeisted')
					hasEnteredMarker('Checkout')
					TriggerServerEvent('logs:write', "A entré le bon mot de passe pour la caisse de la bijouterie ("..password..")")
				else
					TriggerEvent('pNotify:SetQueueMax', "left", 1)
					TriggerEvent('pNotify:SendNotification', {
					    text = "Mot de passe incorrect",
					    type = "error",
					    timeout = 3000,
					    layout = "centerLeft",
					    queue = "left"
					})
					TriggerServerEvent('logs:write', "S'est trompé de mot de passe pour la caisse de la bijouterie (Correct : "..password.." - Incorrect : "..data.value..")")
				end
			end)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 

local function TakeHostageAnims()
	if DoesEntityExist(NPC) and not IsEntityDead(NPC) then
        loadAnimDict("random@arrests")
		loadAnimDict("random@arrests@busted")
		SetEntityHeading(NPC, Config.NPC.NegoDesk.heading)
		while not HasAnimDictLoaded("random@arrests") or not HasAnimDictLoaded("random@arrests@busted") do
			Wait(100)
		end
		while not GetEntityPlayerIsFreeAimingAt(PlayerId(), NPC) do
            SetTextComponentFormat('STRING')
            AddTextComponentString("Pointez la gérante avec une arme")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			Wait(10)
		end

        TaskPlayAnim(NPC, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
		Wait (4000)
        TaskPlayAnim(NPC, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
		Wait (500)
		TaskPlayAnim(NPC, "random@arrests@busted", "enter", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
		Wait (1000)
		TaskPlayAnim(NPC, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )

        TriggerServerEvent('jewelheist:setTakingHostage')
		TriggerServerEvent('logs:write', "Vient de mettre à genou la gérante de la bijouterie")

        Citizen.CreateThread(function()
	        while DoesEntityExist(NPC) and not IsEntityDead(NPC) and IsEntityPlayingAnim(NPC, "random@arrests@busted", "idle_a", 3) and not IsGetCheckoutPassword do
	        	Wait(10)
	        	if Vdist(GetEntityCoords(GetPlayerPed(-1), true), Config.Zones.TakingHostage.Pos.x, Config.Zones.TakingHostage.Pos.y, Config.Zones.TakingHostage.Pos.z) < Config.MarkerSize.x then
		            SetTextComponentFormat('STRING')
		            AddTextComponentString("Intimidez la gérante en tirant pour obtenir des informations")
		            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		            if IsPedShooting(GetPlayerPed(-1)) then
		            	if math.random(1, 40) == 1 then
		            		ESX.TriggerServerCallback('jewelheist:getCheckoutPassword', function(password)
								SetNotificationTextEntry("STRING");
								AddTextComponentString(password);
								SetNotificationMessage("CHAR_DEFAULT", "CHAR_DEFAULT", true, 1, "Vangelico", "Gérante", password);
								IsGetCheckoutPassword = true
								TriggerServerEvent('logs:write', "Vient de récupérer le mot de passe pour caisse de la bijouterie : "..password)
		            		end)
							break
		            	end
		            end
		        end
	        end
	    end)
    end
end

local function hack(success)
    TriggerEvent('mhacking:hide')
	TriggerEvent('pNotify:SetQueueMax', "left", 1)
    if success then
		TriggerEvent('pNotify:SendNotification', {
		    text = "L'alarme a été désactivée",
		    type = "success",
		    timeout = 4000,
		    layout = "centerLeft",
		    queue = "left"
		})
		TriggerServerEvent('logs:write', "Vient de désactiver l'alarme de la bijouterie")
	else
		TriggerEvent('pNotify:SendNotification', {
		    text = "L'alarme vient de se verrouiller",
		    type = "error",
		    timeout = 5000,
		    layout = "centerLeft",
		    queue = "left"
		})
		TriggerServerEvent('logs:write', "Vient de verrouiller l'alarme de la bijouterie")
    end
    TriggerServerEvent('jewelheist:tryToHackAlarm', success)
end

local function IsNotWeapon()
	local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
	for i=1, #Config.BlacklistedWeapons, 1 do
		if GetHashKey(Config.BlacklistedWeapons[i]) == weapon then
			return false
		end
	end
	return true
end

Citizen.CreateThread(function()
	while ESX == nil do Wait(5000) end
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
        local isInMarker     = false
        local currentPart    = nil
		for k,v in pairs(Config.Zones) do
			if k == 'Checkout' and IsGetCheckoutPassword then
				DrawMarker(Config.MarkerType, v.Pos.x,  v.Pos.y,  v.Pos.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, v.MarkerColor.r, v.MarkerColor.g, v.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
            if Vdist(coords.x, coords.y, coords.z, v.Pos.x,  v.Pos.y,  v.Pos.z) < Config.MarkerSize.x then
                isInMarker     = true
                currentPart    = k
            end
        end

        if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and Vdist(coords.x, coords.y, coords.z, Config.InsideJewelery.x, Config.InsideJewelery.y, Config.InsideJewelery.z) < 10.0 then
	        if not IsAlarmPlaying("JEWEL_STORE_HEIST_ALARMS") and IsNotWeapon() then
				TriggerServerEvent('jewelheist:setAlarm', true, true, "L'alarme vient de se déclencher")
				TriggerServerEvent('logs:write', "Vient de rentrer armé dans la bijouterie")
				Wait(500)
	        end
        end


        --Second part
        local hasExited = false

        if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and LastPart ~= currentPart) then
            
            if LastPart ~= nil and LastPart ~= currentPart then
                CurrentAction = nil
                hasExited = true
            end

            HasAlreadyEnteredMarker = true
            LastPart                = currentPart
            
            hasEnteredMarker(currentPart)
        end

        if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
            
            HasAlreadyEnteredMarker = false
            CurrentAction = nil
        end


        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustPressed(0, 38) then --Appuie sur E
            	ESX.TriggerServerCallback('jewelheist:GetCopsNum', function(cops)
            		if cops >= Config.MinCops then
		                if CurrentAction == 'hack_alarm' then
		                	ESX.TriggerServerCallback('jewelheist:getAlarmStatus', function(alarm)
		                		if alarm then
									TriggerEvent("mhacking:show")
									TriggerEvent("mhacking:start", 4, 20, hack)
								end
							end)
		                	CurrentAction = nil
		                elseif CurrentAction == 'cop_stop_alarm' then
				            TriggerServerEvent('jewelheist:setAlarm', false, false, "Un Agent de police vient d'arrêter l'alarme")
		                	CurrentAction = nil
							TriggerServerEvent('logs:write', "Vient d'arrêter l'alarme de la bijouterie")

		                elseif CurrentAction == 'checkout_heist' then
		                    TriggerServerEvent('jewelheist:HeistCheckout')
		                elseif CurrentAction == 'checkout_password' then
		                    CheckoutEnterPassword()
		                	CurrentAction = nil
		                elseif CurrentAction == 'taking_hostage' then
		                    TakeHostageAnims()
		                	CurrentAction = nil
		                elseif CurrentAction == 'interact_with_npc' then
		                    TaskGoToCoordAnyMeans(NPC, Config.NPC.NegoDesk.x, Config.NPC.NegoDesk.y, Config.NPC.NegoDesk.z, 1.2, 0, 0, "move_m@business@a", 0.0)
		                	CurrentAction = nil
		                end
		            else
		            	ESX.ShowNotification("Il doit y avoir minimum ~r~"..Config.MinCops.." policiers~s~ en ville pour braquer la bijouterie")
		            end
                end)
            end
        end
  	end
end)


local function setWorkerWear()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local ped = GetPlayerPed(-1)
		ClearPedProp(ped, 0)
		if skin.sex == 0 then --Homme
			SetPedComponentVariation(ped, 8, 59, 1, 0)--T-Shirt
			SetPedComponentVariation(ped, 11, 56, 0, 0)--Torse
			SetPedComponentVariation(ped, 3, 99, 0, 0)--Bras
	        SetPedComponentVariation(ped, 4, 9, 5, 0)--Jambes
			SetPedComponentVariation(ped, 6, 71, 6, 0)--Chaussures
		else --Femme
			SetPedComponentVariation(ped, 8, 36, 1, 0)--T-Shirt
			SetPedComponentVariation(ped, 11, 49, 0, 0)--Torse
			SetPedComponentVariation(ped, 3, 83, 0, 0)--Bras
	        SetPedComponentVariation(ped, 4, 45, 0, 0)--Jambes
			SetPedComponentVariation(ped, 6, 52, 3, 0)--Chaussures
		end
		TriggerServerEvent('logs:write', "Vient de prendre une tenue d'ouvrier près de la bijouterie")
	end)
end

Citizen.CreateThread(function()
	Wait(10000)
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		for i=1, #Config.WorkerWears, 1 do
			if Config.WorkerWears[i].available and Vdist(coords.x, coords.y, coords.z, Config.WorkerWears[i].x, Config.WorkerWears[i].y, Config.WorkerWears[i].z) < Config.DrawDistance then
				if Vdist(coords.x, coords.y, coords.z, Config.WorkerWears[i].x, Config.WorkerWears[i].y, Config.WorkerWears[i].z) < Config.MarkerSize.x then
		            SetTextComponentFormat('STRING')
		            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour chercher une tenue d'ouvrier")
		            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		            if IsControlJustPressed(0, 38) then
						TriggerEvent('pNotify:SetQueueMax', "left", 1)
						TriggerEvent('pNotify:SendNotification', {
						    text = "Fouille...",
						    type = "warning",
						    timeout = 5000,
						    layout = "centerLeft",
						    queue = "left"
						})
						ESX.TriggerServerCallback('jewelheist:IsAvailable', function(available)
							Wait(5000)
							if available then
			            		setWorkerWear()
			            		TriggerServerEvent('jewelheist:unavailable')
								TriggerEvent('pNotify:SetQueueMax', "left", 1)
								TriggerEvent('pNotify:SendNotification', {
								    text = "Vous avez récupéré une tenue d'ouvrier",
								    type = "success",
								    timeout = 3000,
								    layout = "centerLeft",
								    queue = "left"
								})
			            	else
								TriggerEvent('pNotify:SetQueueMax', "left", 1)
								TriggerEvent('pNotify:SendNotification', {
								    text = "Il n'y a pas de tenue d'ouvrier ici",
								    type = "error",
								    timeout = 1000,
								    layout = "centerLeft",
								    queue = "left"
								})
			            	end
			            end, i)
			            Config.WorkerWears[i].available = false
		            end
				end
			end
		end

		for i=1, #Config.Jewels, 1 do
			if Config.Jewels[i].available and Vdist(coords.x, coords.y, coords.z, Config.Jewels[i].x, Config.Jewels[i].y, Config.Jewels[i].z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Jewels[i].x, Config.Jewels[i].y, Config.Jewels[i].z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerJewelsColor.r, Config.MarkerJewelsColor.g, Config.MarkerJewelsColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Jewels[i].x, Config.Jewels[i].y, Config.Jewels[i].z) < Config.MarkerSize.x then
		            SetTextComponentFormat('STRING')
		            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour prendre les bijoux")
		            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		            if IsControlJustPressed(0, 38) then
		            	ESX.TriggerServerCallback('jewelheist:GetCopsNum', function(cops)
		            		if cops >= Config.MinCops then
				            	if not IsAlarmPlaying("JEWEL_STORE_HEIST_ALARMS") then
				            		TriggerServerEvent('jewelheist:setAlarm', true, false, "L'alarme vient de se déclencher")
				            	end
				            	RequestAnimDict("missheist_jewel")
				            	SetEntityCoordsNoOffset(GetPlayerPed(-1), Config.Jewels[i].x, Config.Jewels[i].y, Config.Jewels[i].z)
				            	SetEntityHeading(GetPlayerPed(-1), Config.Jewels[i].heading)
					        	while not HasAnimDictLoaded("missheist_jewel") do
					        		Wait(10)
					        	end
				        		TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", Config.Jewels[i].animation, 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
				        		Wait(500)
				        		while IsEntityPlayingAnim(GetPlayerPed(-1), "missheist_jewel", Config.Jewels[i].animation, 3) do
					        		Wait(100)
					        	end
				            	TriggerServerEvent('jewelheist:caseHeisted', i)
				            else
				            	ESX.ShowNotification("Il doit y avoir minimum ~r~"..Config.MinCops.." policiers~s~ en ville pour braquer la bijouterie")
				            end
		                end)
		            end
		        end
		    end
		end
	end
end)

RegisterNetEvent('jewelheist:caseHeisted')
AddEventHandler('jewelheist:caseHeisted', function(case)
	Config.Jewels[case].available = false
end)

RegisterNetEvent('jewelheist:callCopsToAlarm')
AddEventHandler('jewelheist:callCopsToAlarm', function(msg)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(msg);
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "Vangelico", "Alarme", msg);
end)

RegisterNetEvent('jewelheist:setAlarm')
AddEventHandler('jewelheist:setAlarm', function(alarm)
	if alarm then
		if not IsAlarmPlaying("JEWEL_STORE_HEIST_ALARMS") then
			while not PrepareAlarm("JEWEL_STORE_HEIST_ALARMS") do
				Citizen.Wait(100)
			end
			StartAlarm("JEWEL_STORE_HEIST_ALARMS", true)
		end
	else
		StopAlarm("JEWEL_STORE_HEIST_ALARMS", true)
	end
end)