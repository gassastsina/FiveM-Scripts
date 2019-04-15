local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local UseGlasses                 = false
local IsDead                  = false
local PlayerData                = {}

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)


function OpenTenueshopMenu()
	local elements = {}
	table.insert(elements, {label = "Casque",    value = "helmet1"})
	table.insert(elements, {label = "Lunette",    value = "glasses1"})
	table.insert(elements, {label = "Gilet",    value = "gilet1"})	
	table.insert(elements, {label = "Masque",    value = "mask1"})		
	table.insert(elements, {label = "Haut",    value = "body1"})	
	table.insert(elements, {label = "Bas",    value = "pants1"})
	table.insert(elements, {label = "Chaussure",    value = "shoes1"})	
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'tenue1_menu',
		{
			title    = 'Achat de Tenue',
			elements = elements
		},
		function(data, menu)

			if data.current.value == "helmet1" then
				OpenShopHelmetMenu()
			end

			if data.current.value == "glasses1" then
				OpenShopGlassesMenu()
			end

			if data.current.value == "mask1" then
				OpenShopMaskMenu()
			end

			if data.current.value == "body1" then
				OpenShopBodyMenu()
			end

			if data.current.value == "pants1" then
				OpenShopPantsMenu()
			end

			if data.current.value == "shoes1" then
				OpenShopShoesMenu()
			end
			if data.current.value == "gilet1" then
				OpenShopGiletMenu()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)	
end

function OpenShopShoesMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)

				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_shoes:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_shoes:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_shoes:saveGlasses', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					
					SetPedPropIndex(GetPlayerPed(-1), 1, -1, 0, 0)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'shoes_1',
		'shoes_2',
	})

end


function OpenShopGlassesMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)

				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_glasses:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_glasses:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_glasses:saveGlasses', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					
					SetPedPropIndex(GetPlayerPed(-1), 1, -1, 0, 0)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'glasses_1',
		'glasses_2',
	})

end

function OpenShopPantsMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)

				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_pants:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_pants:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_pants:saveGlasses', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					
					SetPedPropIndex(GetPlayerPed(-1), 1, -1, 0, 0)
				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'pants_1',
		'pants_2',
	})

end

function OpenShopBodyMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)

				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_body:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_body:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_body:saveGlasses', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					SetPedPropIndex(GetPlayerPed(-1), 1, -1, 0, 0)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'arms',
		'torso_1',
		'torso_2',
		'tshirt_1', 
		'tshirt_2',
	})

end

function OpenShopHelmetMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_helmet:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_helmet:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_helmet:saveHelmet', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then
	
					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					ClearPedProp(GetPlayerPed(-1), 0)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'helmet_1',
		'helmet_2',
	})
end

function OpenShopGiletMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)

				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_gilet:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_gilet:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_gilet:saveGilet', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then
	
					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				
					ClearPedProp(GetPlayerPed(-1), 0)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'bproof_1',
		'bproof_2',
	})

end

function OpenShopMaskMenu()

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data2, menu2)

				menu2.close()

				if data2.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_mask:checkMoney', function(hasEnoughMoney)

						if hasEnoughMoney then
							
							TriggerServerEvent('esx_mask:pay')

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_mask:saveMask', skin)
							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
						
						end

					end)

				end

				if data2.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end,
			function(data2, menu2)

				menu2.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)
	end, {
		'mask_1',
		'mask_2',
	})
end


AddEventHandler('playerSpawned', function()
	IsDead = false
end)

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
	TriggerEvent('esx_ambulancejob:onPlayerDeath')
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
	TriggerEvent('esx_ambulancejob:onPlayerDeath')
end)

AddEventHandler('esx_ambulancejob:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx_shoes:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = {}
end)

AddEventHandler('esx_shoes:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
local bool = false
	while true do
		
		Wait(0)
		
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_shoes:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shoes:hasExitedMarker', LastZone)
		end
		if IsControlJustPressed(0, 289) then
			if bool == false then
				SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 0)
				bool = true 
			else
				ClearPedProp(GetPlayerPed(-1), 2)
				bool = false
			end
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) then
				
				if CurrentAction == 'shop_menu' then
					OpenTenueshopMenu()
				end

				CurrentAction = nil
			end
		end
	end
end)

local function shoes()

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		local ped = GetPlayerPed(-1)
		if (skin.sex == 0 and GetPedDrawableVariation(ped, 6) == 34) or (skin.sex == 1 and GetPedDrawableVariation(ped, 6) == 35) then
			local cloths = getCloths()
			ESX.TriggerServerCallback('esx_shoes:getGlasses', function(hasShoes, shoesSkin)
				TriggerEvent('skinchanger:loadClothes', skin, {
					shoes_1 = shoesSkin.shoes_1,
					shoes_2 = shoesSkin.shoes_2
				})
				setCloths({cloths.helmet1, cloths.helmet2}, {cloths.mask1, cloths.mask2}, {cloths.glasses1, cloths.glasses2}, cloths.arm, {cloths.armor1, cloths.armor2}, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, {cloths.pant1, cloths.pant2}, false)
			end)
		else
			if skin.sex == 0 then
				SetPedComponentVariation(ped, 6, 34, 0, 0)
			else
				SetPedComponentVariation(ped, 6, 35, 0, 0)
			end
		end
	end)
end
	
local function pants()

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		local ped = GetPlayerPed(-1)
		if (skin.sex == 0 and GetPedDrawableVariation(ped, 4) == 21) or (skin.sex == 1 and GetPedDrawableVariation(ped, 4) == 15) then
			ESX.TriggerServerCallback('esx_pants:getGlasses', function(hasPants, pantsSkin)
				local cloths = getCloths()
				TriggerEvent('skinchanger:loadClothes', skin, {
					pants_1 = pantsSkin.pants_1,
					pants_2 = pantsSkin.pants_2
				})
				setCloths({cloths.helmet1, cloths.helmet2}, {cloths.mask1, cloths.mask2}, {cloths.glasses1, cloths.glasses2}, cloths.arm, {cloths.armor1, cloths.armor2}, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, false, {cloths.shoe1, cloths.shoe2})
			end)
		else

			if skin.sex == 0 then
				SetPedComponentVariation(ped, 4, 21, 0, 0)
		  	else
				SetPedComponentVariation(ped, 4, 15, 0, 0)
			end
		end
  	end)
end
		
local function glasses()

	if GetPedPropIndex(GetPlayerPed(-1), 1) ~= -1 then
		ClearPedProp(GetPlayerPed(-1), 1)
	else
		TriggerEvent('skinchanger:getSkin', function(skin)
			ESX.TriggerServerCallback('esx_glasses:getGlasses', function(hasGlasses, glassesSkin)
				local cloths = getCloths()
				TriggerEvent('skinchanger:loadClothes', skin, {
					glasses_1 = glassesSkin.glasses_1,
					glasses_2 = glassesSkin.glasses_2
				})
				setCloths({cloths.helmet1, cloths.helmet2}, {cloths.mask1, cloths.mask2}, false, cloths.arm, {cloths.armor1, cloths.armor2}, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, {cloths.pant1, cloths.pant2}, {cloths.shoe1, cloths.shoe2})
			end)
		end)
	end
end			

local function helmet()

	if GetPedPropIndex(GetPlayerPed(-1), 0) ~= -1 then
		ClearPedProp(GetPlayerPed(-1), 0) -- Helmets
	else

		TriggerEvent('skinchanger:getSkin', function(skin)
			ESX.TriggerServerCallback('esx_helmet:getHelmet', function(hasHelmet, helmetSkin)
				local cloths = getCloths()
				TriggerEvent('skinchanger:loadClothes', skin, {
					helmet_1 = helmetSkin.helmet_1,
					helmet_2 = helmetSkin.helmet_2
				})
				setCloths(false, {cloths.mask1, cloths.mask2}, {cloths.glasses1, cloths.glasses2}, cloths.arm, {cloths.armor1, cloths.armor2}, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, {cloths.pant1, cloths.pant2}, {cloths.shoe1, cloths.shoe2})
			end)
		end)
	end
end

local function gloves()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if GetPedDrawableVariation(GetPlayerPed(-1), 3) ~= 5 then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 0)
		else

			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_body:getGlasses', function(hasBody, BodySkin)
					local cloths = getCloths()
					TriggerEvent('skinchanger:loadClothes', skin, {
						arms = BodySkin.arms,
					})
					setCloths({cloths.helmet1, cloths.helmet2}, {cloths.glasses1, cloths.glasses2}, {cloths.glasses1, cloths.glasses2}, false, {cloths.armor1, cloths.armor2}, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, {cloths.pant1, cloths.pant2}, {cloths.shoe1, cloths.shoe2})
				end)
			end)
		end
	end)
end

local function mask()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if GetPedDrawableVariation(GetPlayerPed(-1), 1) ~= 0 then
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)
		else

			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_mask:getMask', function(hasMask, maskSkin)
					local cloths = getCloths()
					TriggerEvent('skinchanger:loadClothes', skin, {
						mask_1 = maskSkin.mask_1,
						mask_2 = maskSkin.mask_2
					})
					setCloths({cloths.helmet1, cloths.helmet2}, false, {cloths.glasses1, cloths.glasses2}, cloths.arm, {cloths.armor1, cloths.armor2}, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, {cloths.pant1, cloths.pant2}, {cloths.shoe1, cloths.shoe2})
				end)
			end)
		end
	end)
end

local function body()

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		local ped = GetPlayerPed(-1)
		if (skin.sex == 0 and GetPedDrawableVariation(ped, 3) == 15 and GetPedDrawableVariation(ped, 11) == 91 and GetPedDrawableVariation(ped, 8) == 15) or
			(skin.sex == 1 and GetPedDrawableVariation(ped, 3) == 15 and GetPedDrawableVariation(ped, 11) == 15 and GetPedDrawableVariation(ped, 8) == 34) then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_body:getGlasses', function(hasBody, BodySkin)
					local cloths = getCloths()
					TriggerEvent('skinchanger:loadClothes', skin, {
						arms = BodySkin.arms,
						torso_1 = BodySkin.torso_1,
						torso_2 = BodySkin.torso_2,
						tshirt_1 = BodySkin.tshirt_1,
						tshirt_2 = BodySkin.tshirt_2
					})
					setCloths({cloths.helmet1, cloths.helmet2}, {cloths.mask1, cloths.mask2}, {cloths.glasses1, cloths.glasses2}, false, {cloths.armor1, cloths.armor2}, false, false, {cloths.pant1, cloths.pant2}, {cloths.shoe1, cloths.shoe2})
				end)
			end)
		else
			if skin.sex == 0 then
				SetPedComponentVariation(ped, 3, 15, 0, 0)
				SetPedComponentVariation(ped, 11, 91, 0, 0)
				SetPedComponentVariation(ped, 8, 15, 0, 0)
			else
				SetPedComponentVariation(ped, 3, 15, 0, 0)
				SetPedComponentVariation(ped, 11, 15, 0, 0)
				SetPedComponentVariation(ped, 8, 34, 0, 0)
			end
		end
	end)
end

local function gilet()

	if GetPedDrawableVariation(GetPlayerPed(-1), 9) ~= 0 then
		SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 0)
		SetPedArmour(GetPlayerPed(-1), 0)

	else
		TriggerEvent('skinchanger:getSkin', function(skin)
			ESX.TriggerServerCallback('esx_gilet:getGilet', function(hasGilet, giletSkin)
				local cloths = getCloths()
				TriggerEvent('skinchanger:loadClothes', skin, {
					bproof_1 = giletSkin.bproof_1,
					bproof_2 = giletSkin.bproof_2
				})
				setCloths({cloths.helmet1, cloths.helmet2}, {cloths.mask1, cloths.mask2}, {cloths.glasses1, cloths.glasses2}, cloths.arm, false, {cloths.torse1, cloths.torse2}, {cloths.tshirt1, cloths.tshirt2}, {cloths.pant1, cloths.pant2}, {cloths.shoe1, cloths.shoe2})
				SetPedArmour(GetPlayerPed(-1), 70)
			end)
		end)
	end
end

function OpenTenueMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tenue_menu', {
		title    = 'Tenue',
		elements = {
			{label = "Récupérer ses vetements", value = "reload"},
			{label = "Casque",   value = "helmet"},
			{label = "Lunette",  value = "glasses"},
			{label = "Gants",   value = "gloves"},
			{label = "Masque",   value = "mask"},
			{label = "Gilet",    value = "gilet"},
			{label = "Haut",     value = "body"},
			{label = "Bas", 	 value = "pants"},
			{label = "Chaussure",value = "shoes"}
		}
	},
	function(data, menu)

		if data.current.value == "helmet" then
			helmet()
		
		elseif data.current.value == "glasses" then
			glasses()
		
		elseif data.current.value == "mask" then
			mask()
		
		elseif data.current.value == "gloves" then
			gloves()
		
		elseif data.current.value == "body" then
			body()
		
		elseif data.current.value == "pants" then
			pants()
		
		elseif data.current.value == "shoes" then
			shoes()
		
		elseif data.current.value == "gilet" then
			gilet()
		
		elseif data.current.value == "reload" then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end)	
end

RegisterNetEvent('nb:openTenueMenu')
AddEventHandler('nb:openTenueMenu', function()
	OpenTenueMenu()
end)

function getCloths()
	local ped = GetPlayerPed(-1)
	local cloths = {
		helmet1 = GetPedPropIndex(ped, 0),
		helmet2 = GetPedPropTextureIndex(ped, 0),

		mask1 	= GetPedDrawableVariation(ped, 1),
		mask2 	= GetPedTextureVariation(ped, 1),

		glasses1 = GetPedPropIndex(ped, 1),
		glasses2 = GetPedPropTextureIndex(ped, 1),

		arm 	= GetPedDrawableVariation(ped, 3),

		armor1 	= GetPedDrawableVariation(ped, 9),
		armor2 	= GetPedTextureVariation(ped, 9),

		torse1 	= GetPedDrawableVariation(ped, 11),
		torse2 	= GetPedTextureVariation(ped, 11),
		
		tshirt1 = GetPedDrawableVariation(ped, 8),
		tshirt2 = GetPedTextureVariation(ped, 8),
		
		pant1 	= GetPedDrawableVariation(ped, 4),
		pant2 	= GetPedTextureVariation(ped, 4),
		
		shoe1 	= GetPedDrawableVariation(ped, 6),
		shoe2 	= GetPedTextureVariation(ped, 6)
	}
	return cloths
end

function setCloths(helmet, mask, glasses, arm, armor, torse, tshirt, pant, shoes)
	local ped = GetPlayerPed(-1)
	if helmet ~= false then
		SetPedPropIndex(ped, 0, helmet[1], helmet[2], 0)
	end
	if mask ~= false then
		SetPedComponentVariation(ped, 1, mask[1], mask[2], 0)
	end
	if glasses ~= false then
		SetPedPropIndex(ped, 1, glasses[1], glasses[2], 0)
	end
	if arm ~= false then
		SetPedComponentVariation(ped, 3, arm, 0, 0)
	end
	if armor ~= false then
		SetPedComponentVariation(ped, 9, armor[1], armor[2], 0)
	end
	if torse ~= false then
		SetPedComponentVariation(ped, 11, torse[1], torse[2], 0)
	end
	if tshirt ~= false then
		SetPedComponentVariation(ped, 8, tshirt[1], tshirt[2], 0)
	end
	if pant ~= false then
		SetPedComponentVariation(ped, 4, pant[1], pant[2], 0)
	end
	if shoes ~= false then
		SetPedComponentVariation(ped, 6, shoes[1], shoes[2], 0)
	end
end