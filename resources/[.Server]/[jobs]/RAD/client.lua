------------------------------------------------
------------------------------------------------
----    File : client.lua                 	----
----    Author : Mirii & gassastsina      	----
----	Side : client 						----
----    Description : Rendall Air Delivery 	----
------------------------------------------------
------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX           = nil
local PlayerData    = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(50)
  end
end)

-- Create blips
local function setBlip()
	local blip = AddBlipForCoord(Config.Zones.Garage.Pos.x, Config.Zones.Garage.Pos.y, Config.Zones.Garage.Pos.z)
  	SetBlipSprite (blip, 307)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.2)
  	SetBlipColour (blip, 3)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('American Airlines Group')
  	EndTextCommandSetBlipName(blip)

  	if PlayerData.job.name == 'rad' then
		blip = AddBlipForCoord(Config.Zones.HarvestMarchandise.Pos.x, Config.Zones.HarvestMarchandise.Pos.y, Config.Zones.HarvestMarchandise.Pos.z)
	  	SetBlipSprite (blip, 478)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.0)
	  	SetBlipColour (blip, 21)
	  	SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Récolte')
	  	EndTextCommandSetBlipName(blip)

		blip = AddBlipForCoord(Config.Zones.SellMarchandise.Pos.x, Config.Zones.SellMarchandise.Pos.y, Config.Zones.SellMarchandise.Pos.z)
	  	SetBlipSprite (blip, 478)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.0)
	  	SetBlipColour (blip, 21)
	  	SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Vente')
	  	EndTextCommandSetBlipName(blip)
  	end
end

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

-----------------------------------------------main-------------------------------------------------------

local HasAlreadyEnteredMarker   = false
local LastPart                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''

local function hasEnteredMarker(part)
    if part == 'HarvestMarchandise' then
        CurrentAction     = 'harvest_marchandise'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour récuperer la marchandise'
    elseif part == 'SellMarchandise' then
        CurrentAction     = 'sell_marchandise'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vendre la marchandise'

    elseif part == 'Garage' then
        CurrentAction     = 'garage'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage'
    elseif part == 'DeleteVehicle' and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger votre véhicule'

    elseif part == 'Cloakroom' then
        CurrentAction     = 'cloakroom'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire'
    elseif part == 'BossAction' then
        CurrentAction     = 'boss_action'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre'
    end
end

local function OpenGarageVehiclesMenu()
	ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

		local elements = {}
		for i=1, #garageVehicles, 1 do
			table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
		end
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			  title    = 'Garage',
			  elements = elements,
			},
			function(data, menu)
				menu.close()

				local vehicleProps = data.current.value
				ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.Garage.SpawnPoint, Config.Zones.Garage.Heading, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
					TriggerEvent('esx_key:getVehiclesKey', vehicleProps.plate)
					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'rad', vehicleProps)
				end)
			end,
			function(data, menu)
			  menu.close()
			end
		)
	end, 'rad')
end

local function Cloakroom()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_menu', {
		title    = 'Vestiaire',
		elements = {
			{label = 'Tenue civile', value = 'citizen_wear'},
			{label = 'Tenue de pilote', value = 'worker_wear'}
		}
	},
	function(data, menu)
		menu.close()
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)

		elseif data.current.value == 'worker_wear' then
			SetPedPropIndex(GetPlayerPed(-1), 0, 19, 0, 0)--Casque
			--[[ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

				local ped = GetPlayerPed(-1)
				ClearPedProp(ped, 0)
				if skin.sex == 0 then --Homme
					SetPedComponentVariation(ped, 8, 44, 0, 0)--T-Shirt
					SetPedComponentVariation(ped, 11, 69, 0, 0)--Torse
					SetPedComponentVariation(ped, 3, 66, 0, 0)--Bras
			        SetPedComponentVariation(ped, 4, 36, 0, 0)--Jambes
					SetPedComponentVariation(ped, 6, 54, 0, 0)--Chaussures
				else --Femme
					SetPedComponentVariation(ped, 8, 59, 2, 0)--T-Shirt
					SetPedComponentVariation(ped, 11, 63, 0, 0)--Torse
					SetPedComponentVariation(ped, 3, 78, 0, 0)--Bras
			        SetPedComponentVariation(ped, 4, 35, 0, 0)--Jambes
					SetPedComponentVariation(ped, 6, 24, 0, 0)--Chaussures
				end]]

			--end)
		end
	end,
	function(data, menu)
	  menu.close()
	end)
end

local function MarkerSize(part)
	if part == 'DeleteVehicle' then
		return 5
	end
	return Config.MarkerSize.x
end

Citizen.CreateThread(function()
    Wait(5000)
	while true do
		Wait(10)
        local coords         = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker     = false
        local currentPart    = nil
  		if PlayerData.job ~= nil and PlayerData.job.name == 'rad' then
            for k,v in pairs(Config.Zones) do
                if Vdist(coords.x, coords.y, coords.z, v.Pos.x,  v.Pos.y,  v.Pos.z) < Config.DrawDistance then
                	if v.MarkerColor ~= nil then
                    	DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, v.MarkerColor.r, v.MarkerColor.g, v.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                    end
                    if Vdist(coords.x, coords.y, coords.z, v.Pos.x,  v.Pos.y,  v.Pos.z) < MarkerSize(k) then
                        isInMarker     = true
                        currentPart    = k
                    end
                end
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
            TriggerServerEvent('farms:stop')
            HasAlreadyEnteredMarker = false
            CurrentAction = nil
        end

        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustPressed(0, 38) then --Appuie sur E
                if CurrentAction == 'harvest_marchandise' then
                    TriggerServerEvent('farms:Harvest', 'marchandise', 1, 5000)
                elseif CurrentAction == 'sell_marchandise' then
                    TriggerServerEvent('farms:Sell', 'marchandise', 1, 90, 50, 'society_rad', 4000)

                elseif CurrentAction == 'garage' then
                    OpenGarageVehiclesMenu()
                elseif CurrentAction == 'delete_vehicle' then
                	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),  false)
                	local vehicleProperties = ESX.Game.GetVehicleProperties(vehicle)
                	if vehicleProperties.plate ~= nil then
						TriggerServerEvent('esx_society:putVehicleInGarage', 'rad', vehicleProperties)
						ESX.Game.DeleteVehicle(vehicle)
					end
                elseif CurrentAction == 'boss_action' then
                	if  PlayerData.job.grade_name == 'boss' then
						TriggerEvent('esx_society:openBossMenu', 'rad', function(data, menu)
				        	menu.close()
				        end)
					end
                elseif CurrentAction == 'cloakroom' then
                    Cloakroom()
                end
                CurrentAction = nil
            end
        end
  	end
end)