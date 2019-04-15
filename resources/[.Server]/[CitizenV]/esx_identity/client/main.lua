local guiEnabled = false
local myIdentity = {}
local myIdentifiers = {}
local hasIdentity = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function EnableGui(state, type)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = type,
		enable = state
	})
end

RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
	EnableGui(true, "enableui")
end)

RegisterNetEvent('esx_identity:identityCheck')
AddEventHandler('esx_identity:identityCheck', function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNetEvent('esx_identity:saveID')
AddEventHandler('esx_identity:saveID', function(data)
	myIdentifiers = data
end)

RegisterNUICallback('escape', function(data, cb)
	if hasIdentity then
		EnableGui(false, "enableui")
		Wait(100)
		EnableGui(false, "display_natif")
		Wait(100)
		EnableGui(false, "display_plane")
		Wait(100)
		EnableGui(false, "display_boat")
	else
		TriggerEvent('chat:addMessage', { args = { '^1[IDENTITY]', '^1You must create your first character in order to play' } })
	end
end)

RegisterNUICallback('register', function(data, cb)
	local reason = ""
	myIdentity = data
	for theData, value in pairs(myIdentity) do
		if theData == "firstname" or theData == "lastname" then
			reason = verifyName(value)
			
			if reason ~= "" then
				break
			end
		elseif theData == "dateofbirth" then
			if value == "invalid" then
				reason = "~r~Date d'anniversaire invalide"
				break
			end
		elseif theData == "height" then
			local height = tonumber(value)
			if height then
				if height > 200 or height < 140 then
					reason = "~r~Taille invalide"
					break
				end
			else
				reason = "~r~Taille invalide"
				break
			end
		end
	end
	
	if reason == "" then
		TriggerEvent('esx:ShowHUD', false, 0.0)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		TriggerServerEvent('esx_identity:setIdentity', data, myIdentifiers)
		EnableGui(false, "enableui")
		Citizen.Wait(2000)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'origin_menu', {
			title = "Choisissez l'arrivé de votre personnage",
			elements = {
				{label = "Natif",  value = 'natif'},
				{label = "Avion", value = 'plane'},
				{label = "Bateau", value = 'boat'}
			}
		}, function(data, menu)
			menu.close()

			DoScreenFadeOut(2000)
			while not IsScreenFadedOut() do
				Citizen.Wait(100)
			end

			local TPToOrigin = Config.Zones[data.current.value]

			ESX.Game.Teleport(GetPlayerPed(-1), TPToOrigin.Pos, function()
				SendNUIMessage({
					type = "display_"..data.current.value,
					enable 	= true
				})
				local haveVehicle = false
				local vehicleProperties = nil
				for i=1, #TPToOrigin.Vehicle.Pos, 1 do
					if not IsAnyVehicleNearPoint(TPToOrigin.Vehicle.Pos[i].x, TPToOrigin.Vehicle.Pos[i].y, TPToOrigin.Vehicle.Pos[i].z,  4.0) then
						ESX.Game.SpawnVehicle(TPToOrigin.Vehicle.Model, TPToOrigin.Vehicle.Pos[i], TPToOrigin.Vehicle.Pos[i].heading, function(vehicle)
						  	haveVehicle = true
							vehicleProperties = ESX.Game.GetVehicleProperties(vehicle)
							while vehicleProperties.plate == nil do
								vehicleProperties.plate = GetVehicleNumberPlateText(vehicle)
								Wait(10)
							end
							TriggerEvent('esx_key:getVehiclesKey', vehicleProperties.plate)
							TriggerEvent("advancedFuel:setEssence", 90, vehicleProperties.plate, GetDisplayNameFromVehicleModel(vehicleProperties.model))
							
							local blip = AddBlipForEntity(vehicle)
						  	SetBlipSprite (blip, 225)
						  	SetBlipDisplay(blip, 4)
						  	SetBlipScale  (blip, 1.0)
						  	SetBlipAsShortRange(blip, true)
							
							BeginTextCommandSetBlipName("STRING")
						  	AddTextComponentString('Véhicule')
						  	EndTextCommandSetBlipName(blip)
							TriggerServerEvent('esx_identity:addMoneyAndItems', TPToOrigin.Bank, TPToOrigin.Money, TPToOrigin.Items, vehicleProperties)
						end)
						Wait(200)
						break
					end
				end
				if not haveVehicle then
					TriggerServerEvent('esx_identity:addMoneyAndItems', TPToOrigin.Bank, TPToOrigin.Money, TPToOrigin.Items, vehicleProperties)
				end

				Citizen.CreateThread(function()
					while not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) do
						Wait(500)
					end
					TriggerEvent('esx:showNotification', "Pour mettre votre ceinture, appuyez sur ~b~L")
					while not IsControlJustReleased(0, 182) do
						Wait(1)
					end
					Wait(1000)
					TriggerEvent('esx:showNotification', "Les clées du véhicule vous ont été données en arrivant en ville")
					TriggerEvent('esx:showNotification', "Vous pouvez donc ~g~démarrer~s~ le moteur en appuyant sur ~b~M")

					Citizen.CreateThread(function()
						Wait(30000)
						TriggerEvent('esx:showNotification', "Vous pouvez voir vos clées dans le menu ~b~Y")
					end)
					while not IsDisabledControlJustPressed(0, 75) do
						Wait(1)
					end
					TriggerEvent('esx:showNotification', "Pour ~r~sortir~s~ de votre véhicule vous devez d'abord enlever votre ceinture en appuyant sur ~b~L")
					while IsPedSittingInAnyVehicle(GetPlayerPed(-1)) do
						Wait(500)
					end
					TriggerEvent('esx:showNotification', "N'oubliez pas d'~r~éteindre~s~ le moteur pour ne pas perdre de l'essence en appuyer sur ~b~M")
				end)

				DoScreenFadeIn(15000)
			end)
			Wait(10000)
			while not IsControlJustPressed(1, 177) do
				Wait(5)
			end
			SendNUIMessage({
				type = "display_"..data.current.value,
				enable 	= false
			})
			Wait(1000)
			FreezeEntityPosition(GetPlayerPed(-1), false)
			TriggerEvent('esx_skin:openSaveableMenu', myIdentifiers.id)
			TriggerEvent('esx:ShowHUD', true, 1.0)
		end,
		function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification(reason)
	end
end)

Citizen.CreateThread(function()
	while true do
		if guiEnabled then
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		end
		Citizen.Wait(10)
	end
end)

function verifyName(name)
	-- Don't allow short user names
	local nameLength = string.len(name)
	if nameLength > 25 or nameLength < 2 then
		return '~r~Votre nom est trop grand ou trop court'
	end
	
	-- Don't allow special characters (doesn't always work)
	local count = 0
	for i in name:gmatch('[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]') do
		count = count + 1
	end
	if count ~= nameLength then
		return '~r~Votre nom contient des caractères non valide'
	end
	
	-- Does the player carry a first and last name?
	-- 
	-- Example:
	-- Allowed:     'Bob Joe'
	-- Not allowed: 'Bob'
	-- Not allowed: 'Bob joe'
	local spacesInName    = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, '%S+') do
	
		if string.match(word, '%u') then
			spacesWithUpper = spacesWithUpper + 1
		end
	
		spacesInName = spacesInName + 1
	end
	
	if spacesInName > 2 then
		return 'Votre nom contient plus de 2 espaces'
	end
	
	if spacesWithUpper ~= spacesInName then
		return 'Votre nom doit commencer avec une majuscule'
	end
	
	return ''
end