----------------------------------------------
----------------------------------------------
----    File : client.lua                 ----
----    Author: gassastsina               ----
----	Side : client 		 			  ----
----    Description : Los Pollos Hermanos ----
----------------------------------------------
----------------------------------------------

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
	local blip = AddBlipForCoord(Config.Shop.Pos.x, Config.Shop.Pos.y, Config.Shop.Pos.z)
  	SetBlipSprite (blip, 280)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.3)
  	SetBlipColour (blip, 17)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString('Los Pollos Hermanos')
  	EndTextCommandSetBlipName(blip)

	if PlayerData.job.name == 'lospolloshermanos' then
		blip = AddBlipForCoord(Config.Zones.Market.Pos.x, Config.Zones.Market.Pos.y, Config.Zones.Market.Pos.z)
	  	SetBlipSprite (blip, 52)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.1)
	  	SetBlipColour (blip, 17)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString('Market')
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
    --[[if part == 'MethToPollos' then
        CurrentAction     = 'meth_to_pollos'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour dissimuler de la Méthamphétamine en los Pollos'
    elseif part == 'PollosToMeth' then
        CurrentAction     = 'pollos_to_meth'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour retirer la Méthamphétamine de los Pollos'
    elseif part == 'GrapeseedInventory' then
        CurrentAction     = 'grapeseed_inventory'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'
    elseif part == 'LSInventory' then
        CurrentAction     = 'ls_inventory'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'




    else]]if part == 'Garage' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'garage'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage'
    elseif part == 'DeleteVehicle' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule dans le garage'
    elseif part == 'Market' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'market'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le market'
    elseif part == 'BossActions' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'boss_actions'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre'
    elseif part == 'Cloakroom' then
        CurrentAction     = 'cloakroom'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire'
    elseif part == 'ItemChest' then
        CurrentAction     = 'item_chest'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre'
        


        --Transformations
    elseif part == 'PotatoesToChips' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'potatoes_to_chips'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour transformer les Pommes de terre en Frites'
    elseif part == 'BreadAndChickenAndVegegeToBurger' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'bread_and_chicken_and_vegege_to_burger'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour faire FastFood'
    elseif part == 'MilkToMilshake' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'milk_to_milshake'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour faire un Milkshake'
    elseif part == 'ChickenToNuggets' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'chicken_to_nuggets'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour transformer le Poulet en Nuggets'
    elseif part == 'CoffeeMachine' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'coffee_machine'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour personnaliser votre café'
    elseif part == 'DonutsMachine' and PlayerData.job.name == 'lospolloshermanos' then
        CurrentAction     = 'donuts_machine'
        CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour prendre un donut'
    end
end

local function OpenInventoryMenu(area, label)

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'choice_inventory_menu',
        {
	        title    = 'Coffre '..label,
	        elements = {
	          {label = 'Déposer un item', value = 'put'},
	          {label = 'Récupérer un item', value = 'get'}
	        },
        },
        function(data, menu)

            if data.current.value == 'put' then
                PutInventory(area, label)
            elseif data.current.value == 'get' then
                GetInventory(area, label)
            end
        end,
        function(data, menu)
            menu.close()
            CurrentAction     = 'grapeseed_inventory'
            CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au coffre'
            

        end
    )
end


local function GetInventory(area, label)
    ESX.TriggerServerCallback('LosPollosHermanos:getStockItems', function(items)

        local elements = {}
        for i=1, #items, 1 do
            if items[i].count > 0 then
                table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
            end
        end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'stocks_menu',
          {
            title    = 'Coffre '..label,
            elements = elements
          },
          function(data, menu)

            local itemName = data.current.value
            ESX.UI.Menu.Open(
              'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
              {
                title = 'Quantité'
              },
              function(data2, menu2)

                local count = tonumber(data2.value)

                if count == nil then
                  ESX.ShowNotification('Quantité ~r~invalide')
                else
                    menu2.close()
                    TriggerServerEvent('LosPollosHermanos:getStockItem', itemName, count, area)
                    GetInventory(area, label)
                end

              end,
              function(data2, menu2)
                menu2.close()
              end
            )

          end,
          function(data, menu)
            menu.close()
            OpenInventoryMenu(area, label)
          end
        )

    end, area)
end

local function PutInventory(area, label)

    ESX.TriggerServerCallback('LosPollosHermanos:getPlayerInventory', function(items)

        local elements = {}
        for i=1, #items, 1 do
            if items[i].count > 0 then
                table.insert(elements, {label = items[i].label .. ' x' .. items[i].count, type = 'item_standard', value = items[i].name})
            end
        end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'stocks_menu',
          {
            title    = 'Coffre '..label,
            elements = elements
          },
          function(data, menu)

            local itemName = data.current.value

            ESX.UI.Menu.Open(
              'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
              {
                title = 'Quantité'
              },
              function(data2, menu2)

                local count = tonumber(data2.value)
                if count == nil then
                  ESX.ShowNotification('Quantité ~r~invalide')
                else
                  menu2.close()
                  TriggerServerEvent('LosPollosHermanos:putStockItem', itemName, count, area)
                  PutInventory(area, label)
                end

              end,
              function(data2, menu2)
                menu2.close()
              end
            )

          end,
          function(data, menu)
            menu.close()
            OpenInventoryMenu(area, label)
          end
        )
    end)
end

local function OpenGarageMenu()
	ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

		local elements = {}
		for i=1, #garageVehicles, 1 do
			if GetDisplayNameFromVehicleModel(garageVehicles[i].model) ~= nil and garageVehicles[i].plate ~= nil and garageVehicles[i] ~= nil then
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
			else
				print('ERROR LosPollosHermanos : nil value')
			end
		end
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			  title    = 'Garage de véhicules',
			  elements = elements,
			},
			function(data, menu)
				menu.close()

				local vehicleProps = data.current.value
				ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.Garage.SpawnPoint, Config.Zones.Garage.Heading, function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
					TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
					TriggerEvent("advancedFuel:setEssence", 75, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'lospolloshermanos', vehicleProps)
				end)
			end,
			function(data, menu)
			  menu.close()
			end
		)

	end, 'lospolloshermanos')
end

local function OpenMarketMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'market_menu', {
		  title    = 'Market',
		  elements = Config.Market,
		},
		function(data, menu)
			TriggerServerEvent('LosPollosHermanos:Market', data.current.item, data.current.price)
		end,
		function(data, menu)
		  menu.close()
		end
	)
end

local function OpenCoffeeMachineMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'coffee_machine_menu', {
			title    = 'Coffee Machine',
			elements = Config.CoffeeMachineMenu,
		},
		function(data, menu)
			TriggerServerEvent('farms:Treatment', 'coffee', 1, data.current.toItem, 1, 3000)
		end,
		function(data, menu)
		  menu.close()
		end
	)
end

local function OpenDonutseMachineMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'donuts_machine_menu', {
			title    = 'Donuts Machine',
			elements = Config.DonutsMachineMenu,
		},
		function(data, menu)
			TriggerServerEvent('LosPollosHermanos:buyDonut', data.current.toItem)
		end,
		function(data, menu)
		  menu.close()
		end
	)
end

local function Cloakroom()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_menu', {
		title    = 'Vestiaire',
		elements = {
			{label = 'Tenue civile', value = 'citizen_wear'},
			{label = 'Tenue de travail', value = 'worker_wear'}
		}
	},
	function(data, menu)
		menu.close()
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)

		elseif data.current.value == 'worker_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

				local ped = GetPlayerPed(-1)
				ClearPedProp(ped, 0)
				if PlayerData.job.grade_name == 'boss' then
					if skin.sex == 0 then --Homme
						SetPedComponentVariation(ped, 8, 15, 0, 0)--T-Shirt
	                    SetPedComponentVariation(ped, 11, 26, 4, 0)--Torse
	                    SetPedComponentVariation(ped, 3, 11, 0, 0)--Bras
	                    SetPedComponentVariation(ped, 4, 24, 6, 0)--Jambes
	                    SetPedComponentVariation(ped, 6, 20, 0, 0)--Chaussures
						SetPedComponentVariation(ped, 7, 38, 0, 0)--accessoires
					else --Femme
						SetPedComponentVariation(ped, 8, 15, 0, 0)--T-Shirt
	                    SetPedComponentVariation(ped, 11, 14, 11, 0)--Torse
	                    SetPedComponentVariation(ped, 3, 14, 0, 0)--Bras
	                    SetPedComponentVariation(ped, 4, 4, 8, 0)--Jambes
	                    SetPedComponentVariation(ped, 6, 27, 0, 0)--Chaussures
					end
				else
					if skin.sex == 0 then --Homme
						SetPedComponentVariation(ped, 8, 15, 0, 0)--T-Shirt
                        SetPedComponentVariation(ped, 11, 9, 15, 0)--Torse
                        SetPedComponentVariation(ped, 3, 0, 0, 0)--Bras
                        SetPedComponentVariation(ped, 4, 10, 0, 0)--Jambes
                        SetPedComponentVariation(ped, 6, 7, 2, 0)--Chaussures
                        SetPedComponentVariation(ped, 7, 0, 0, 0)--accessoires
					else --Femme
						SetPedComponentVariation(ped, 8, 15, 0, 0)--T-Shirt
	                    SetPedComponentVariation(ped, 11, 14, 11, 0)--Torse
	                    SetPedComponentVariation(ped, 3, 14, 0, 0)--Bras
	                    SetPedComponentVariation(ped, 4, 4, 8, 0)--Jambes
	                    SetPedComponentVariation(ped, 6, 27, 0, 0)--Chaussures
					end
				end
			end)
		end
	end)
end

Citizen.CreateThread(function()
    Wait(5000)
	while true do
		Wait(10)
        local isInMarker     = false
        local currentPart    = nil
  		if PlayerData.job ~= nil and PlayerData.job.name == 'lospolloshermanos' then
	        local coords         = GetEntityCoords(GetPlayerPed(-1))
            --Display markers
            for k,v in pairs(Config.Zones) do
                if Vdist(coords.x, coords.y, coords.z, v.Pos.x,  v.Pos.y,  v.Pos.z) < Config.MarkerSize.x then
                    isInMarker     = true
                    currentPart    = k
                end
            end
        end


        --Second part
        local hasExited = false
        --print(isInMarker and LastPart ~= currentPart)
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
            
            TriggerServerEvent('LosPollosHermanos:stopRunning')
            TriggerServerEvent('farms:stop')
            HasAlreadyEnteredMarker = false
            CurrentAction = nil
        end


        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustPressed(0, 38) then --Appuie sur E
                if CurrentAction == 'meth_to_pollos' then
                    TriggerServerEvent('LosPollosHermanos:MethToPollos')
                elseif CurrentAction == 'pollos_to_meth' then
                    TriggerServerEvent('LosPollosHermanos:PollosToMeth')

                elseif CurrentAction == 'grapeseed_inventory' then
                    OpenInventoryMenu('grapeseed', 'Grapeseed')
                elseif CurrentAction == 'ls_inventory' then
                    OpenInventoryMenu('ls', 'Los Santos')


                elseif CurrentAction == 'garage' then
                    OpenGarageMenu()
                elseif CurrentAction == 'delete_vehicle' then
                	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),  false)
					TriggerServerEvent('esx_society:putVehicleInGarage', 'lospolloshermanos', ESX.Game.GetVehicleProperties(vehicle))
					ESX.Game.DeleteVehicle(vehicle)

                elseif CurrentAction == 'market' then
                    OpenMarketMenu()
                elseif CurrentAction == 'boss_actions' then
                	if  PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh' then
						TriggerEvent('esx_society:openBossMenu', 'lospolloshermanos', function(data, menu)
				        	menu.close()
				        end, {	chest 	  = false,
							    withdraw  = true,
							    deposit   = true,
							    wash      = false,	--Blanchiment désactivé
							    employees = false,
							    grades    = false 	--Salaire désactivé
							 }
						)
					else
						TriggerEvent('esx_society:openBossMenu', 'lospolloshermanos', function(data, menu)
				        	menu.close()
				        end, {	chest 	  = false,
							    withdraw  = false,
							    deposit   = true,
							    wash      = false,	--Blanchiment désactivé
							    employees = false,
							    grades    = false 	--Salaire désactivé
							 }
						)
					end
                elseif CurrentAction == 'cloakroom' then
                    Cloakroom()
                elseif CurrentAction == 'item_chest' then
                    TriggerEvent('esx_society:openBossMenu', 'lospolloshermanos', function(data, menu)
			        	menu.close()
			        end, {	chest 	  = true,
						    withdraw  = false,
						    deposit   = false,
						    wash      = false,	--Blanchiment désactivé
						    employees = false,
						    grades    = false 	--Salaire désactivé
						  }
					)

                    --Transformations
                elseif CurrentAction == 'potatoes_to_chips' then
                    TriggerServerEvent('farms:Treatment', 'potato', 1, 'chips', 2, 5000)
                elseif CurrentAction == 'bread_and_chicken_and_vegege_to_burger' then
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'donuts_machine_menu', {
							title    = 'Recettes',
							elements = {
								{label = 'Burger', value = 'burger'},
								{label = 'Panini', value = 'panini'},
								{label = 'Tacos', value = 'tacos'}
							},
						},
						function(data, menu)
							if data.current.value == 'burger' then
                				TriggerServerEvent('LosPollosHermanos:Burger')
                			elseif data.current.value == 'panini' then
                				TriggerServerEvent('LosPollosHermanos:Panini')
                			elseif data.current.value == 'tacos' then
                				TriggerServerEvent('LosPollosHermanos:Tacos')
                			end
						end,
						function(data, menu)
						  menu.close()
						end
					)
                elseif CurrentAction == 'milk_to_milshake' then
                    TriggerServerEvent('farms:Treatment', 'milk', 1, 'milkshake', 1, 7000)
                elseif CurrentAction == 'chicken_to_nuggets' then
                    TriggerServerEvent('farms:Treatment', 'slaughtered_chicken', 1, 'nugget', 5, 10000)
                elseif CurrentAction == 'coffee_machine' then
                    OpenCoffeeMachineMenu()
                elseif CurrentAction == 'donuts_machine' then
                    OpenDonutseMachineMenu()
                end
                CurrentAction = nil
            end
        end
  	end
end)

AddEventHandler('nb:openMenuLosPollosHermanos', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lospolloshermanos_menu', {
			title    = 'Los Pollos Hermanos',
			elements = {
				{label = 'Facture', value = 'bill'}
			},
		},
		function(data, menu)
			if data.current.value == 'bill' then
				ESX.UI.Menu.Open(
		        	'dialog', GetCurrentResourceName(), 'bill_menu',
		        	{
		            	title = "Montant de la facture"
		        	},
		        	function(data, menu2)

		            	local amount = tonumber(data.value)
		            	if amount == nil then
		            		ESX.ShowNotification('Montant invalide')
		            	else
							menu2.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 2.0 then
		                		ESX.ShowNotification('~r~Aucun joueur trouvé à proximité')
		            		else
		                		TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_lospolloshermanos', 'Los Pollos Hermanos', amount)
		            		end
		            	end
		          	end,
		        	function(data, menu2)
		        		menu2.close()
		        	end
		        )
			end
		end,
		function(data, menu)
		  menu.close()
		end
	)
end)


Citizen.CreateThread(function()
	local isInMarker = false
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		if Vdist(coords.x, coords.y, coords.z, Config.Shop.Pos.x, Config.Shop.Pos.y, Config.Shop.Pos.z) < Config.DrawDistance then
			if not isInMarker then
				DrawMarker(Config.MarkerType, Config.Shop.Pos.x, Config.Shop.Pos.y, Config.Shop.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.Shop.MarkerColor.r, Config.Shop.MarkerColor.g, Config.Shop.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
			if Vdist(coords.x, coords.y, coords.z, Config.Shop.Pos.x, Config.Shop.Pos.y, Config.Shop.Pos.z) < Config.MarkerSize.x then
				if not isInMarker then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le shop")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				end
				if not isInMarker and IsControlJustPressed(1, 38) then
					ESX.TriggerServerCallback('LosPollosHermanos:getShopInventory', function(Inventory)
						local elements = {}
						for i=1, #Inventory, 1 do
							local ItemPrice = Config.Shop.DefaultPrice
							for x=1, #Config.Shop.ItemsPrice, 1 do
								if Config.Shop.ItemsPrice[x].name == Inventory[i].name then
									ItemPrice = Config.Shop.ItemsPrice[x].price
								end
							end
							if Inventory[i].count > 0 then
								if PlayerData.job.name ~= 'lospolloshermanos' then
									table.insert(elements, {label = Inventory[i].label..' - <span style="color:green;">'..ItemPrice.."$</span>", item = Inventory[i].name, price = ItemPrice})
								else
									table.insert(elements, {label = Inventory[i].count.."x "..Inventory[i].label..' - <span style="color:green;">'..ItemPrice.."$</span>", item = Inventory[i].name, price = ItemPrice})
								end
							end
						end
						if PlayerData.job.name == 'lospolloshermanos' then
							table.insert(elements, {label = 'Remplir le stock', item = 'put'})
						end
						isInMarker = true
						ESX.UI.Menu.CloseAll()
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_menu', {
								title    = 'Shop',
								elements = elements,
							},
							function(data, menu)
								if data.current.item == 'put' then
									ESX.TriggerServerCallback('LosPollosHermanos:getPlayerInventory', function(items)

								        elements = {}
								        for i=1, #items, 1 do
								            if items[i].count > 0 then
								                table.insert(elements, {label = items[i].label .. ' x' .. items[i].count, type = 'item_standard', value = items[i].name})
								            end
								        end

								        ESX.UI.Menu.Open(
								          'default', GetCurrentResourceName(), 'stocks_menu',
								          {
								            title    = 'Inventaire',
								            elements = elements
								          },
								          function(data3, menu3)
								          	elements = {}
								            local itemName = data3.current.value

								            ESX.UI.Menu.Open(
								              'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
								              {
								                title = 'Quantité'
								              },
								              function(data2, menu2)

								                local count = tonumber(data2.value)
								                if count == nil then
								                  ESX.ShowNotification('Quantité ~r~invalide')
								                else
								                  menu2.close()
								                  TriggerServerEvent('LosPollosHermanos:putItemInShop', itemName, count)
								                end

								              end,
								              function(data2, menu2)
								                menu2.close()
								              end
								            )

								          end,
								          function(data3, menu3)
								            menu3.close()
								          end
								        )
								    end)
								else
									TriggerServerEvent('LosPollosHermanos:buyItemFromShop', data.current.item, data.current.price)
								end
							end,
							function(data, menu)
							  menu.close()
							  isInMarker = false
							end
						)
					end)
				end
			elseif isInMarker then
				isInMarker = false
			end
		end
	end
end)