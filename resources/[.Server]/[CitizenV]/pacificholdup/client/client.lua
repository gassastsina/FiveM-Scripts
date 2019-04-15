-----------------------------------------------
-----------------------------------------------
----    File : client.lua       		   ----
----    Author : gassastsina    		   ----
----    Side : client         			   ----
----    Description : Pacific Bank hold up ----
-----------------------------------------------
-----------------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
local PlayerData = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end
end)

-----------------------------------------------main------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	ESX.TriggerServerCallback('pacificholdup:IsAlarmHacked', function(alarm)
		if alarm then
			TriggerEvent("alarm:PlayWithinDistance", Config.Alarm.Distance, Config.Alarm.File, Config.DrillChests[chest])
		end
	end)
	Wait(5000)
	ESX.TriggerServerCallback('pacificholdup:IsSetDoor', function(door)
		if door then
			TriggerServerEvent("pacificholdup:setDoor")
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

local function hasEnteredMarker(part)
    if part == 'Computer' then
    	if PlayerData.job == nil or PlayerData.job.name == 'police' then
	        CurrentAction     = 'computer_alarm'
	        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour stopper l'alarme"
	    else
	        CurrentAction     = 'computer'
	        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'ordinateur"
	    end
    elseif part == 'DoorHack' then
        CurrentAction     = 'door_hack'
        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour pirater le porte"
    elseif part == 'Melt' then
        CurrentAction     = 'melt'
        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour fondre les lingots"
    end
end

local function hackComputer(success)
    TriggerEvent('mhacking:hide')
	if success then
		ESX.TriggerServerCallback('pacificholdup:getComputerPassword', function(password)
			TriggerEvent('pNotify:SetQueueMax', "topleft", 1)
			TriggerEvent('pNotify:SendNotification', {
		        text = "Mot de passe : "..password,
		        type = "success",
		        timeout = 30000,
		        layout = "topLeft",
		        queue = "topleft"
		  	})
			print("Mot de passe de l'ordinateur de la Pacific Bank : "..password)
		end)
	else
		TriggerEvent('pNotify:SetQueueMax', "left", 1)
		TriggerEvent('pNotify:SendNotification', {
	        text = "ERREUR",
	        type = "error",
	        timeout = 3000,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	end
	TriggerServerEvent('pacificholdup:removeHackPhone')
    CurrentAction     = 'computer'
    CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'ordinateur"
end

local function hackAlarm(success)
    TriggerEvent('mhacking:hide')
	TriggerServerEvent('pacificholdup:AlarmHacked', success)
	TriggerEvent('pNotify:SetQueueMax', "left", 1)
	if success then
		TriggerEvent('pNotify:SendNotification', {
	        text = "L'alarme a été désactivée",
	        type = "success",
	        timeout = 2500,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	else
		TriggerEvent('pNotify:SendNotification', {
	        text = "L'alarme vient de se verrouiller",
	        type = "error",
	        timeout = 3000,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	end
	CurrentAction     = 'computer'
	CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'ordinateur"
end

local function hackDoor(success)
    TriggerEvent('mhacking:hide')
	TriggerEvent('pNotify:SetQueueMax', "left", 1)
	if success then
		TriggerServerEvent('pacificholdup:setDoor')
		TriggerEvent('pNotify:SendNotification', {
	        text = "La porte vient de s'ouvrir",
	        type = "success",
	        timeout = 2500,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	else
		TriggerEvent('pNotify:SendNotification', {
	        text = "ERREUR",
	        type = "error",
	        timeout = 3000,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	end
	TriggerServerEvent('pacificholdup:removeHackPhone')
end

RegisterNetEvent('pacificholdup:setDoor')
AddEventHandler('pacificholdup:setDoor', function()
	local door = ESX.Game.GetClosestObject({"V_ILEV_BK_VAULTDOOR"}, {x = 255.22, y = 223.97, z = 102.40})
	SetEntityHeading(door, 20)
	FreezeEntityPosition(door, true)
end)

local canDrill 		   = true
local function StartQTH(chest)
	TriggerEvent('pNotify:SetQueueMax', "left", 2)
	TriggerEvent('pNotify:SendNotification', {
        text = "Vous percez le coffre...",
        type = "info",
        timeout = 1800,
        layout = "centerLeft",
        queue = "left"
  	})
	local SuccessLimit     = 0.08 -- Maxim 0.1 (high value, low success chances)
	local AnimationSpeed   = 0.0033
	local TimerAnimation   = 0.1
	local BarAnimation 	   = 0
	while not IsControlJustPressed(0, 38) and not IsControlJustPressed(0, 22) do
		Wait(5)
		DrawRect(0.5, 0.1+0.005,TimerAnimation,0.005,255,255,0,255)
		DrawRect(0.5, 0.1,0.1,0.01,0,0,0,255)
		TimerAnimation = TimerAnimation - 0.0008
		if BarAnimation >= SuccessLimit then
			DrawRect(0.5, 0.1, BarAnimation,0.01,102,255,102,150)
		else
			DrawRect(0.5, 0.1, BarAnimation,0.01,255,51,51,150)
		end
		if BarAnimation <= 0 then
			up = true
		end
		if BarAnimation >= 0.1 then
			up = false
		end
		if not up then
			BarAnimation = BarAnimation - AnimationSpeed
		else
			BarAnimation = BarAnimation + AnimationSpeed
		end
		if TimerAnimation <= 0 then
			BarAnimation = 0
			break
		end
	end
	TimerAnimation = 0.1
	if BarAnimation >= SuccessLimit then
		TriggerEvent('pNotify:SendNotification', {
	        text = "Vous avez percé la cerrure",
	        type = "success",
	        timeout = 2000,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	  	TriggerServerEvent('pacificholdup:getChestReward', chest)
	else
		TriggerEvent('pNotify:SendNotification', {
	        text = "Vous avez bousillé la serrure, on ne peut plus l'ouvrir",
	        type = "error",
	        timeout = 2500,
	        layout = "centerLeft",
	        queue = "left"
	  	})
	end
	canDrill = true
	ClearPedTasks(GetPlayerPed(-1))
	Wait(1000)
end

local function Computer()
	local elements = {{label = "Entrer le code", value = 'password'}}
	ESX.TriggerServerCallback('pacificholdup:GetItemQuantity', function(quantity)
		if quantity > 0 then
			table.insert(elements, {label = "Pirater le code", value = 'hack'})
		end
		ESX.TriggerServerCallback('pacificholdup:IsAlarmHacked', function(alarm)
			if not alarm and quantity > 0 then
				table.insert(elements, {label = "Pirater l'alarme", value = 'alarm'})
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_computer', {
					title    = 'Ordinateur',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == 'password' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'checkout_password', {
							title = "Mot de passe"
						},
						function(data2, menu2)
							ESX.TriggerServerCallback('pacificholdup:getComputerPassword', function(password)
								TriggerEvent('pNotify:SetQueueMax', "left", 1)
								if json.encode(data2.value) == json.encode(password) then
									menu2.close()
									TriggerEvent('pNotify:SendNotification', {
									    text = "Mot de passe correct",
									    type = "success",
									    timeout = 2500,
									    layout = "centerLeft",
									    queue = "left"
									})
									TriggerServerEvent('logs:write', "A entré le bon mot de passe pour l'ordinateur de la Pacific Bank ("..password..")")

									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_cameras', {
											title    = 'Caméras',
											elements = Config.Cameras,
										},
										function(data, menu)
											ESX.UI.Menu.CloseAll()
											WatchCam(data.current.value)
											TriggerServerEvent('logs:write', "Regarde la caméra "..data.current.label)
										end,
										function(data, menu)
											menu.close()
										end
									)
								else
									TriggerEvent('pNotify:SendNotification', {
									    text = "Mot de passe incorrect",
									    type = "error",
									    timeout = 3000,
									    layout = "centerLeft",
									    queue = "left"
									})
									TriggerServerEvent('logs:write', "S'est trompé de mot de passe pour l'ordinateur de la Pacific Bank (Correct : "..password.." - Incorrect : "..data2.value..")")
								end
							end)
						end,
						function(data2, menu2)
							menu2.close()
						end)
					elseif data.current.value == 'hack' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start", 4, 20, hackComputer)
					elseif data.current.value == 'alarm' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start", 4, 20, hackAlarm)
					end
				end,
				function(data, menu)
					menu.close()
			        CurrentAction     = 'computer'
			        CurrentActionMsg  = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'ordinateur"
				end
			)
		end)
	end, 'hack_phone')
end

Citizen.CreateThread(function()
	while ESX == nil do Wait(5000) end
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
        local isInMarker     = false
        local currentPart    = nil
		for k,v in pairs(Config.Zones) do
			DrawMarker(Config.MarkerType, v.Pos.x,  v.Pos.y,  v.Pos.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            if Vdist(coords.x, coords.y, coords.z, v.Pos.x,  v.Pos.y,  v.Pos.z) < Config.MarkerSize.x then
                isInMarker     = true
                currentPart    = k
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
            TriggerServerEvent('pacificholdup:stop')
        end


        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustPressed(0, 38) then --Appuie sur E
	    		ESX.TriggerServerCallback('pacificholdup:getCops', function(cops)
	    			if cops >= Config.MinCops then
		                if CurrentAction == 'computer' then
							Computer()
							CurrentAction = nil
						elseif CurrentAction == 'computer_alarm' then
							TriggerServerEvent('esx_holdupbank:alarmStop')
							CurrentAction = nil
						elseif CurrentAction == 'door_hack' then
					        ESX.TriggerServerCallback('pacificholdup:GetItemQuantity', function(quantity)
					        	if quantity > 0 then
					        		ESX.UI.Menu.CloseAll()
									TriggerEvent("mhacking:show")
									TriggerEvent("mhacking:start", 4, 20, hackDoor)
									CurrentAction = nil
								else
									ESX.ShowNotification("Vous n'avez pas de téléhpone pour pirater la porte")
								end
							end, 'hack_phone')
						elseif CurrentAction == 'melt' then
							TriggerServerEvent('pacificholdup:MeltJargon')
							CurrentAction = nil
						end
					else
						ESX.ShowNotification("~r~Il doit y avoir minimum "..Config.MinCops.." policiers en ville pour braquer la Pacific Bank")
					end
				end)
            end
        end

        if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and canDrill then
	        for i=1, #Config.DrillChests, 1 do
	        	if Config.DrillChests[i].available and Vdist(coords.x, coords.y, coords.z, Config.DrillChests[i].x, Config.DrillChests[i].y, Config.DrillChests[i].z) < Config.DrawMarker then
					DrawMarker(Config.MarkerType, Config.DrillChests[i].x, Config.DrillChests[i].y, Config.DrillChests[i].z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					if Vdist(coords.x, coords.y, coords.z, Config.DrillChests[i].x, Config.DrillChests[i].y, Config.DrillChests[i].z) < 0.5 then
			            SetTextComponentFormat('STRING')
			            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour percer ce coffre")
			            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						if IsControlJustPressed(0, 38) then
        					ESX.TriggerServerCallback('pacificholdup:GetItemQuantity', function(quantity)
        						if quantity > 0 then
									SetEntityCoordsNoOffset(GetPlayerPed(-1), Config.DrillChests[i].x, Config.DrillChests[i].y, Config.DrillChests[i].z)
									SetEntityHeading(GetPlayerPed(-1), Config.DrillChests[i].heading)
									TaskStartScenarioInPlace(GetPlayerPed(PlayerId()), "WORLD_HUMAN_WELDING", 0, true)
									TriggerServerEvent('pacificholdup:notAvailable', i)
									canDrill = false
									StartQTH(i)
								else
									ESX.ShowNotification("~r~Tu n'as pas de perceuse")
								end
							end, 'drill')
							Wait(2000)
							break
						end
					end
				end
	        end
	    end
  	end
end)

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
	while true do
		Wait(5000)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and Vdist(coords.x, coords.y, coords.z, Config.EnterWithWeapon.Pos.x, Config.EnterWithWeapon.Pos.y, Config.EnterWithWeapon.Pos.z) < Config.EnterWithWeapon.Radius and IsNotWeapon() then
			TriggerServerEvent('pacificholdup:startAlarm')
			TriggerServerEvent('logs:write', "Est armé dans la Pacific Bank")
		end
	end
end)


RegisterNetEvent('pacificholdup:cantRobChest')
AddEventHandler('pacificholdup:cantRobChest', function(chest)
    Config.DrillChests[chest].available = false
end)

RegisterNetEvent('pacificholdup:AlertPolice')
AddEventHandler('pacificholdup:AlertPolice', function(message, blipBool)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(message);
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "Pacific Bank", "Alarme", message);
	DrawNotification(true, false)

	if blipBool then
	    local blipRobbery = AddBlipForCoord(Config.EnterWithWeapon.Pos.x, Config.EnterWithWeapon.Pos.y, Config.EnterWithWeapon.Pos.z)
	    SetBlipSprite(blipRobbery , 161)
	    SetBlipScale(blipRobbery , 2.0)
	    SetBlipColour(blipRobbery, 3)
	    PulseBlip(blipRobbery)
	    while Vdist(GetEntityCoords(GetPlayerPed(-1), false), Config.EnterWithWeapon.Pos.x, Config.EnterWithWeapon.Pos.y, Config.EnterWithWeapon.Pos.z) > Config.EnterWithWeapon.Radius+100 do
	    	Wait(1000)
	    end
	    RemoveBlip(blipRobbery)
	end
end)