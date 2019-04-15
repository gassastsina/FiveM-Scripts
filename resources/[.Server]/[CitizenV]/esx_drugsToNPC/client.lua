--===============================================
--= Drug Script- Onlyserenity				 	=
--===============================================

------------------------------------------------
------------------------------------------------
----    File : client.lua       			----
----    Author : Onlyserenity    			----
----    Edited by : gassastsina    			----
----    Side : client         				----
----    Description : Sell drugs to NPCs 	----
------------------------------------------------
------------------------------------------------


ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

local negotiating = false
local oldped = nil
Citizen.CreateThread(function()
	while true do
		Wait(20)
		local handle, ped = FindFirstPed()
		local success
		repeat
		    success, ped = FindNextPed(handle)
	        if IsControlJustPressed(1, 74) then
				local playerloc = GetEntityCoords(GetPlayerPed(-1), true)
				local pos = GetEntityCoords(ped)
              	if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc.x, playerloc.y, playerloc.z, true) <= 4 then
		            local pedType = GetPedType(ped)
				    if DoesEntityExist(ped) and not IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and pedType ~= 28 and ped ~= GetPlayerPed(-1) and ped ~= oldped and not negotiating then
				    	negotiating = true
				    	local canCallPolice = true
				    	if pedType == 6 and pedType == 20 and pedType == 21 and pedType == 27 and pedType == 29 then
					    	TriggerServerEvent('sellDrugToNPC:sendToPolice', playerloc.x, playerloc.y, GetStreetNameFromHashKey(GetStreetNameAtCoord(playerloc.x, playerloc.y, playerloc.z)))
				    		canCallPolice = false
				    	end
						oldped = ped
						SetEntityAsMissionEntity(ped)
						ClearPedTasks(ped)
						FreezeEntityPosition(ped, true)
						if math.random(1, 2) == 1 then
							TriggerEvent('pNotify:SetQueueMax', "left", 1)
							TriggerEvent('pNotify:SendNotification', {
						        text = "J'veux pas de ta merde",
						        type = "warning",
						        timeout = math.random(1200, 3500),
						        layout = "centerLeft",
						        queue = "left"
						  	})
							UnFreezePed(ped)
							if math.random(1, 3) == 1 and canCallPolice then
								Wait(2000)
						    	TriggerServerEvent('sellDrugToNPC:sendToPolice', playerloc.x, playerloc.y, GetStreetNameFromHashKey(GetStreetNameAtCoord(playerloc.x, playerloc.y, playerloc.z)))
							end
							negotiating = false
						else
							TaskStandStill(ped, 9.0)
							TriggerServerEvent('sellDrugToNPC:getItem')
						end
			        	Wait(10)
			        end
		        end
	        end
		until not success
		EndFindPed(handle)
	end
end)


RegisterNetEvent('sellDrugToNPC:startNegociations')
AddEventHandler('sellDrugToNPC:startNegociations', function(item)
	local secondsRemaining = 10

	Citizen.CreateThread(function()
		while secondsRemaining > 0 do
			Wait(1000)
			secondsRemaining = secondsRemaining - 1
		end
	end)
	while secondsRemaining > 0 do
		Wait(10)
		if negotiating then
		    drawTxt(0.90, 1.40, 1.0, 1.0, 0.4, "Négociations en cours : ~b~" .. secondsRemaining .. "~w~ secondes", 255, 255, 255, 255)
		    
		    local playerloc = GetEntityCoords(GetPlayerPed(-1), true)
		    local pedCoords = GetEntityCoords(oldped, true)
		    if GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, playerloc.x, playerloc.y, playerloc.z, true) > 5.0 then
				TriggerEvent('pNotify:SetQueueMax', "left", 1)
				TriggerEvent('pNotify:SendNotification', {
				    text = "C'est ça, dégages ! Connard !",
				    type = "warning",
				    timeout = math.random(1000, 3500),
				    layout = "centerLeft",
				    queue = "left"
				})
				negotiating = false
				UnFreezePed(oldped)
				break
		    end
		end
	end
	if negotiating then
		negotiating = false
		local number = nil
		if item.qty < 6 then
			number = math.random(1, item.qty)
		else
			number = math.random(1, 6)
		end
		local price = nil
		for i=1, #Config.Drugs, 1 do
			if Config.Drugs[i].name == item.name then
		        price = math.random(Config.Drugs[i].priceMin, Config.Drugs[i].priceMax)*number
		        break
		    end
		end
		TriggerEvent('pNotify:SetQueueMax', "left", 1)
		TriggerEvent('pNotify:SendNotification', {
		    text = number.." "..item.label.." - "..price.."$",
		    type = "success",
		    timeout = math.random(1000, 3000),
		    layout = "centerLeft",
		    queue = "left"
		})
		if Config.Zones.enable then
			for i=1, Config.Zones[item.name], 1 do
				if Vdist(GetEntityCoords(GetPlayerPed(-1), true), Config.Zones[item.name][i].x, Config.Zones[item.name][i].y, Config.Zones[item.name][i].z) < Config.Zones[item.name][i].radius then
					price = price * Config.Zones[item.name][i].multiplier
				end
			end
		end
		TriggerServerEvent('sellDrugToNPC:selled', item.name, number, price)
		--[[RequestAnimDict("amb@prop_human_bum_bin@idle_b")
		while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do Citizen.Wait(100) end
		local pid = PlayerPedId()
		TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
		Wait(750)
		StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)]]
		UnFreezePed(oldped)
	end
end)

RegisterNetEvent('sellDrugToNPC:stopNegociation')
AddEventHandler('sellDrugToNPC:stopNegociation', function()
	negotiating = false
	UnFreezePed(oldped)
end)

function UnFreezePed(pedToUnFreeze)
	FreezeEntityPosition(pedToUnFreeze, false)
	ClearPedTasks(pedToUnFreeze)
	SetPedAsNoLongerNeeded(pedToUnFreeze)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if(outline)then
	  SetTextOutline()
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('sellDrugToNPC:sendToPolice')
AddEventHandler('sellDrugToNPC:sendToPolice', function(message, street, x, y)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(message);
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "Vente de drogue", street, message);
	DrawNotification(true, false)

	if not IsWaypointActive() then
		SetNewWaypoint(x, y)
	end
end)