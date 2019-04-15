----------------------------------------------
----------------------------------------------
----    File : client.lua                 ----
----    Author: gassastsina               ----
----	Side : client 		 			  ----
----    Description : Weed Grow 		  ----
----------------------------------------------
----------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end
end)

-----------------------------------------------main-------------------------------------------------------
local plantations = {}
RegisterNetEvent('weedGrow:plant')
AddEventHandler('weedGrow:plant', function(deleteLastObject, weed, coords, _source)
	if deleteLastObject then
		local object, distance = ESX.Game.GetClosestObject(Config.Weed.Plants[weed-1] or 'prop_weed_02', coords)
		if distance < 1.5 then
			ESX.Game.DeleteObject(object)
		end
	end
	local x = coords.x
	local y = coords.y
	local z = coords.z
	local canPlant = true
	if _source == GetPlayerServerId(PlayerId()) then
  		ESX.UI.Menu.CloseAll()
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
		Wait(10000)
		ClearPedTasks(GetPlayerPed(-1))
		x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.1, 0.4, 0.0))
		for i=1, #plantations, 1 do
			if Vdist(x, y, z, plantations[i].coords.x, plantations[i].coords.y, plantations[i].coords.z) <= 1.5 then
				TriggerEvent('pNotify:SetQueueMax', "left", 1)
				TriggerEvent('pNotify:SendNotification', {
				    text = "Tu ne peux pas planter ici il y a les racines de celle d'à côtée",
				    type = "error",
				    timeout = 3000,
				    layout = "centerLeft",
				    queue = "left"
				})
				canPlant = false
				TriggerServerEvent('weedGrow:cantPlant', coords, weed)
				break
			end
		end
		if canPlant then
			TriggerServerEvent('weedGrow:changeCoords', coords, {x=x, y=y, z=z})
		end
	end
	if canPlant then
		ESX.Game.SpawnLocalObject(Config.Weed.Plants[weed], {x=x, y=y, z=z}, function(obj)
		    PlaceObjectOnGroundProperly(obj)
		    FreezeEntityPosition(obj, true)
	  	end)
	end
end)

local function startChecking()
	while true do
		Wait(10)
		if plantations ~= nil and plantations ~= {} then
			local coords = GetEntityCoords(GetPlayerPed(-1), true)
			for i=1, #plantations, 1 do
				if plantations[i].canHarvest and plantations[i].step ~= 1 and Vdist(coords.x, coords.y, coords.z, plantations[i].coords.x, plantations[i].coords.y, plantations[i].coords.z) < 1.5 then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour récolter des feuilles de weed "..plantations[i].step.."/3")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					if IsControlJustPressed(1, 38) then
						local object, distance = ESX.Game.GetClosestObject(Config.Weed.Plants[plantations[i].step] or "prop_weed_01")
						if distance < 1.5 then
							RequestAnimDict("amb@prop_human_bum_bin@idle_b")
							while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do Wait(100) end
							TaskPlayAnim(PlayerPedId(),"amb@prop_human_bum_bin@idle_b","idle_d", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)

							TriggerEvent('pNotify:SetQueueMax', "left", 1)
							TriggerEvent('pNotify:SendNotification', {
							    text = "Récolte de feuilles de weed "..plantations[i].step.."/3",
							    type = "success",
							    timeout = 8000,
							    layout = "centerLeft",
							    queue = "left"
							})
							Wait(8300)
							StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
							plantations[i].canHarvest = false
							TriggerServerEvent('weedGrow:harvest', plantations[i])
							ESX.Game.DeleteObject(object)
						end
					end
				end
			end
		end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	Wait(1000)
	TriggerServerEvent('weedGrow:playerLoaded')
end)

RegisterNetEvent('weedGrow:playerLoaded')
AddEventHandler('weedGrow:playerLoaded', function(plantationsList)
	plantations = plantationsList
	for i=1, #plantations, 1 do
		TriggerEvent('weedGrow:plant', false, plantations[i].step, plantations[i].coords)
		Wait(800)
	end
    startChecking()
end)

RegisterNetEvent('weedGrow:getPlantations')
AddEventHandler('weedGrow:getPlantations', function(plantationsList)
	plantations = plantationsList
end)

RegisterNetEvent('weedGrow:WaterCanFull')
AddEventHandler('weedGrow:WaterCanFull', function()
	local coords = GetEntityCoords(GetPlayerPed(-1), true)
	for i=1, #plantations, 1 do
		if Vdist(coords.x, coords.y, coords.z, plantations[i].coords.x, plantations[i].coords.y, plantations[i].coords.z) <= 3.0 then
			RequestAnimDict("amb@prop_human_bum_bin@idle_b")
			while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do Wait(100) end

			TriggerEvent('pNotify:SetQueueMax', "left", 1)
			TriggerEvent('pNotify:SendNotification', {
			    text = "Vous arrosez la plante...",
			    type = "info",
			    timeout = 4000,
			    layout = "centerLeft",
			    queue = "left"
			})
			TriggerServerEvent('weedGrow:WaterCan', plantations[i].coords)
			TaskPlayAnim(PlayerPedId(),"amb@prop_human_bum_bin@idle_b","idle_d", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)
			Wait(4000)
			StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
		end
	end
end)

RegisterNetEvent('weedGrow:WaterCanEmpty')
AddEventHandler('weedGrow:WaterCanEmpty', function()
	if not IsPedSwimming(GetPlayerPed(-1)) and IsEntityInWater(GetPlayerPed(-1)) then
		RequestAnimDict("amb@prop_human_bum_bin@idle_b")
		while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do Wait(100) end

		TriggerServerEvent('weedGrow:TransformEmptyToFullWaterCan')
		TaskPlayAnim(PlayerPedId(),"amb@prop_human_bum_bin@idle_b","idle_d", 100.0, 200.0, 0.3, 1, 0.2, 0, 0, 0)
		Wait(4000)
		StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
	else
		TriggerEvent('pNotify:SetQueueMax', "left", 1)
		TriggerEvent('pNotify:SendNotification', {
		    text = "Vous devez être dans l'eau pour remplir l'arrosoir",
		    type = "error",
		    timeout = 2000,
		    layout = "centerLeft",
		    queue = "left"
		})
	end
end)