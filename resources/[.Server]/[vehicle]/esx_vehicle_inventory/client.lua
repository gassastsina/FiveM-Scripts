-------------------------------------------------------------------------
--							By Vakeros								   --
--               			Edited by gassastsina 				   	   --
--							#Version 1.2							   --
--               			#Description vehicle inventory		   	   --
--							#lastEdit 02/06/18					       --
-------------------------------------------------------------------------

ESX = nil
local vehicleInv = nil
local inventory = {}
local plate = nil
local useCapacity = 0
local maxCapacity = 0
local defaultCapacity = 20000 -- default if config do not exist for this vehicle
local invWeapon = nil
local v = nil
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
local config = {
	
--Super
	{model = 'ADDER',maxCapacity = 6000},
	{model = 'BANSHEE2',maxCapacity = 6000},
	{model = 'BULLET',maxCapacity = 6000},
	{model = 'CHEETAH',maxCapacity = 6000},
	{model = 'ENTITYXF',maxCapacity = 6000},
	{model = 'SHEAVA',maxCapacity = 6000},	--ETR1
	{model = 'FMJ',maxCapacity = 6000},
	{model = 'INFERNUS',maxCapacity = 6000},
	{model = 'OSIRIS',maxCapacity = 6000},
	{model = 'PFISTER811',maxCapacity = 6000},
	{model = 'LE7B',maxCapacity = 6000},
	{model = 'REAPER',maxCapacity = 6000},
	{model = 'SULTANRS',maxCapacity = 6000},
	{model = 'T20',maxCapacity = 6000},
	{model = 'TURISMOR',maxCapacity = 6000},
	{model = 'TYRUS',maxCapacity = 6000},
	{model = 'VACCA',maxCapacity = 6000},
	{model = 'VOLTIC',maxCapacity = 6000},
	{model = 'PROTOTIPO',maxCapacity = 6000},
	{model = 'ZENTORNO',maxCapacity = 6000},
	{model = 'XA21',maxCapacity = 6000},
	{model = 'NERO',maxCapacity = 6000},
	{model = 'TEMPESTA',maxCapacity = 6000},
	{model = 'GP1',maxCapacity = 6000},
	{model = 'VAGNER',maxCapacity = 6000},
	{model = 'SPECTER2',maxCapacity = 6000},
	{model = 'ITALIGTB',maxCapacity = 6000},
	{model = 'ITALIGTB2',maxCapacity = 6000},
	{model = 'NERO2',maxCapacity = 6000},

	--Sport Classic
	{model = 'BTYPE',maxCapacity = 9000},		--classic
	{model = 'BTYPE2',maxCapacity = 8000},	--hotroad
	{model = 'BTYPE3',maxCapacity = 9000},	--luxe
	{model = 'CASCO',maxCapacity = 6000},
	{model = 'COQUETTE2',maxCapacity = 6000},
	{model = 'MANAMA',maxCapacity = 6500},
	{model = 'MONROE',maxCapacity = 6000},
	{model = 'PIGALLE',maxCapacity = 6000},
	{model = 'STINGER',maxCapacity = 5000},
	{model = 'STINGERGT',maxCapacity = 5000},
	{model = 'ZTYPE',maxCapacity = 6000},
	{model = 'FELTZER3',maxCapacity = 6000},
	{model = 'TORERO',maxCapacity = 7000},
	{model = 'TURISMO2',maxCapacity = 6000},
	{model = 'INFERNUS2',maxCapacity = 6500},
	{model = 'TORNADO',maxCapacity = 4000},
	{model = 'TORNADO2',maxCapacity = 4000},
	{model = 'CHEETAH2',maxCapacity = 8000},


	--Sport
	{model = 'SCHAFTER3',maxCapacity = 5000},
	{model = 'RAPIDGT',maxCapacity = 5000},
	{model = 'PENUMBRA',maxCapacity = 5500},
	{model = 'OMNIS',maxCapacity = 4000},
	{model = 'MASSACRO2',maxCapacity = 5000},
	{model = 'MASSACRO',maxCapacity = 5000},
	{model = 'MAMBA',maxCapacity = 5000},
	{model = 'LYNX',maxCapacity = 5000},
	{model = 'FUTO',maxCapacity = 5500},
	{model = 'RAPIDGT2',maxCapacity = 5500},
	{model = 'SEVEN70',maxCapacity = 5000},
	{model = 'SULTAN',maxCapacity = 8000},
	{model = 'SURANO',maxCapacity = 5000},
	{model = 'TROPOS',maxCapacity = 5500},
	{model = 'VERLIERER2',maxCapacity = 5500},
	{model = 'RUSTON',maxCapacity = 5000},
	{model = 'SPECTER',maxCapacity = 5000},
	{model = 'KURUMA',maxCapacity = 7000},
	{model = 'BESTIAGTS',maxCapacity = 7500},
	{model = 'ELEGY',maxCapacity = 6500},
	{model = 'NINEF',maxCapacity = 4000},
	{model = 'NINEF2',maxCapacity = 4000},
	{model = 'ALPHA',maxCapacity = 4500},
	{model = 'CARBONIZZARE',maxCapacity = 7500},
	{model = 'COMET2',maxCapacity = 7000},
	{model = 'COQUETTE',maxCapacity = 7000},
	{model = 'KHAMELION',maxCapacity = 4000},
	{model = 'JESTER2',maxCapacity = 5000},
	{model = 'JESTER',maxCapacity = 5000},
	{model = 'FUSILADE',maxCapacity = 5500},
	{model = 'FUROREGT',maxCapacity = 4500},
	{model = 'TAMPA2',maxCapacity = 5000},
	{model = 'ELEGY2',maxCapacity = 6000},
	{model = 'FELTZER2',maxCapacity = 5500},
	{model = 'SCHWARZER',maxCapacity = 5500},
	{model = 'BANSHEE',maxCapacity = 5500},

	--SUV
	{model = 'GRANGER',maxCapacity = 18000},
	{model = 'FQ2',maxCapacity = 12000},
	{model = 'ROCOTO',maxCapacity = 14000},
	{model = 'SEMINOLE',maxCapacity = 14000},
	{model = 'XLS',maxCapacity = 16000},
	{model = 'MESA',maxCapacity = 16000},
	{model = 'BALLER2',maxCapacity = 13000},
	{model = 'GRESLEY',maxCapacity = 12000},
	{model = 'HUNTLEY',maxCapacity = 13000},
	{model = 'LANDSTALKER',maxCapacity = 12000},
	{model = 'PATRIOT',maxCapacity = 16000},
	{model = 'MESA3',maxCapacity = 16000},
	{model = 'BALLER3',maxCapacity = 16000},
	{model = 'RADI',maxCapacity = 7000},
	{model = 'DUBSTA',maxCapacity = 14000},
	{model = 'CAVALCADE2',maxCapacity = 13000},
	{model = 'CONTENDER',maxCapacity = 19000},
	{model = 'DUBSTA2',maxCapacity = 13000},


	--Muscle
	{model = 'BLADE',maxCapacity = 3000},
	{model = 'BUCCANEER',maxCapacity = 3000},
	{model = 'BUCCANEER2',maxCapacity = 3000},
	{model = 'BUFFALO',maxCapacity = 5000},
	{model = 'BUFFALO2',maxCapacity = 5000},
	{model = 'CHINO',maxCapacity = 3000},
	{model = 'CHINO2',maxCapacity = 3000},
	{model = 'COQUETTE3',maxCapacity = 4000},
	{model = 'DOMINATOR',maxCapacity = 7000},
	{model = 'DUKES',maxCapacity = 3000},
	{model = 'FACTION',maxCapacity = 4000},
	{model = 'FACTION2',maxCapacity = 4000},
	{model = 'FACTION3',maxCapacity = 4000},
	{model = 'GAUNTLET',maxCapacity = 7000},
	{model = 'HOTKNIFE',maxCapacity = 5000},
	{model = 'NIGHTSHADE',maxCapacity = 4000},
	{model = 'PHOENIX',maxCapacity = 4000},
	{model = 'PICADOR',maxCapacity = 3000},
	{model = 'SABREGT',maxCapacity = 5000},
	{model = 'SABREGT2',maxCapacity = 5000},
	{model = 'TAMPA',maxCapacity = 4000},
	{model = 'VIRGO',maxCapacity = 3000},
	{model = 'VIGERO',maxCapacity = 3000},
	{model = 'VOODOO',maxCapacity = 2000},
	{model = 'VIRGO2',maxCapacity = 3000},
	{model = 'VIRGO3',maxCapacity = 3000},
	{model = 'VOODOO2',maxCapacity = 2000},

	--Off Road
	{model = 'BIFTA',maxCapacity = 1000},
	{model = 'BFINJECT',maxCapacity = 3000},
	{model = 'BRAWLER',maxCapacity = 5000},
	{model = 'DUBSTA3',maxCapacity = 15000},
	{model = 'DUNE',maxCapacity = 12000},
	{model = 'GUARDIAN',maxCapacity = 12000},
	{model = 'REBEL2',maxCapacity = 13000},
	{model = 'SANDKING',maxCapacity = 8000},
	{model = 'TROPHYTRUCK',maxCapacity = 7000},
	{model = 'TROPHYTRUCK2',maxCapacity = 7000},
	{model = 'REBEL',maxCapacity = 13000},
	{model = 'KALAHARI',maxCapacity = 7000},
	{model = 'RATLOADER',maxCapacity = 4000},
	{model = 'SANDKING2',maxCapacity = 16000},

	--Compact
	{model = 'BLISTA',maxCapacity = 8000},
	{model = 'ISSI2',maxCapacity = 5000},
	{model = 'PANTO',maxCapacity = 2000},
	{model = 'PRAIRIE',maxCapacity = 3000},
	{model = 'BRIOSO',maxCapacity = 5000},

	--Moto
	{model = 'AKUMA',maxCapacity = 500},
	{model = 'AVARUS',maxCapacity = 500},
	{model = 'BAGGER',maxCapacity = 500},
	{model = 'BATI',maxCapacity = 500},
	{model = 'BATI2',maxCapacity = 500},
	{model = 'BF400',maxCapacity = 500},
	{model = 'CARBONRS',maxCapacity = 500},
	{model = 'CHIMERA',maxCapacity = 500},
	{model = 'CLIFFHANGER',maxCapacity = 500},
	{model = 'DAEMON',maxCapacity = 500},
	{model = 'DAEMON2',maxCapacity = 500},
	{model = 'DEFILER',maxCapacity = 500},
	{model = 'DOUBLE',maxCapacity = 500},
	{model = 'ENDURO',maxCapacity = 500},
	{model = 'ESSKEY',maxCapacity = 500},
	{model = 'FAGGIO',maxCapacity = 500},
	{model = 'GARGOYLE',maxCapacity = 500},
	{model = 'HAKUCHOU',maxCapacity = 500},
	{model = 'HAKUCHOU2',maxCapacity = 500},
	{model = 'HEXER',maxCapacity = 500},
	{model = 'INNOVATION',maxCapacity = 500},
	{model = 'MANCHEZ',maxCapacity = 500},
	{model = 'NEMESIS',maxCapacity = 500},
	{model = 'NIGHTBLADE',maxCapacity = 500},
	{model = 'SANCHEZ',maxCapacity = 500},
	{model = 'SANCHEZ2',maxCapacity = 500},
	{model = 'SANCTUS',maxCapacity = 500},
	{model = 'SOVEREIGN',maxCapacity = 500},
	{model = 'THRUST',maxCapacity = 500},
	{model = 'VADER',maxCapacity = 500},
	{model = 'FAGGIO',maxCapacity = 500},
	{model = 'FAGGIO2',maxCapacity = 500},
	{model = 'VORTEX',maxCapacity = 500},
	{model = 'WOLFSBANE',maxCapacity = 500},
	{model = 'ZOMBIEA',maxCapacity = 500},
	{model = 'ZOMBIEB',maxCapacity = 500},
	{model = 'PCJ',maxCapacity = 500},
	{model = 'RUFFIAN',maxCapacity = 500},
	{model = 'FCR',maxCapacity = 500},
	{model = 'FCR2',maxCapacity = 500},
	{model = 'DIABLOUS',maxCapacity = 500},
	{model = 'DIABLOUS2',maxCapacity = 500},

	--Coupe
	{model = 'COGCABRIO',maxCapacity = 4000},
	{model = 'EXEMPLAR',maxCapacity = 5000},
	{model = 'F620',maxCapacity = 3000},
	{model = 'FELON',maxCapacity = 4000},
	{model = 'FELON2',maxCapacity = 3000},
	{model = 'JACKAL',maxCapacity = 3000},
	{model = 'ORACLE2',maxCapacity = 3000},
	{model = 'SENTINEL',maxCapacity = 5000},
	{model = 'SENTINEL2',maxCapacity = 4000},
	{model = 'WINDSOR',maxCapacity = 3000},
	{model = 'WINDSOR2',maxCapacity = 3000},
	{model = 'ZION',maxCapacity = 4000},
	{model = 'ZION2',maxCapacity = 4000},

	--Sedans
	{model = 'ASEA',maxCapacity = 4000},
	{model = 'COGNOSCENTI',maxCapacity = 5000},
	{model = 'EMPEROR',maxCapacity = 2000},
	{model = 'FUGITIVE',maxCapacity = 4000},
	{model = 'GLENDALE',maxCapacity = 3000},
	{model = 'INTRUDER',maxCapacity = 3000},
	{model = 'PREMIER',maxCapacity = 3000},
	{model = 'PRIMO2',maxCapacity = 3000},
	{model = 'REGINA',maxCapacity = 3000},
	{model = 'SCHAFTER2',maxCapacity = 3000},
	{model = 'STRETCH',maxCapacity = 4000},
	{model = 'SUPERD',maxCapacity = 4000},
	{model = 'TAILGATER',maxCapacity = 3000},
	{model = 'WASHINGTON',maxCapacity = 4000},
	{model = 'WARRENER',maxCapacity = 2000},
	{model = 'ASTEROPE',maxCapacity = 3000},

	--Vans
	{model = 'BISON',maxCapacity = 15000},
	{model = 'BOBCATXL',maxCapacity = 16000},
	{model = 'BURRITO3',maxCapacity = 21000},
	{model = 'GBURRITO',maxCapacity = 21000},
	{model = 'CAMPER',maxCapacity = 25000},
	{model = 'GBURRITO2',maxCapacity = 21000},
	{model = 'JOURNEY',maxCapacity = 24000},
	{model = 'MINIVAN',maxCapacity = 10000},
	{model = 'MOONBEAM',maxCapacity = 13000},
	{model = 'MOONBEAM2',maxCapacity = 13000},
	{model = 'PARADISE',maxCapacity = 23000},
	{model = 'RUMPO',maxCapacity = 23000},
	{model = 'RUMPO3',maxCapacity = 22000},
	{model = 'SURFER',maxCapacity = 10000},
	{model = 'YOUGA',maxCapacity = 19000},
	{model = 'YOUGA2',maxCapacity = 20000},
	{model = 'MINIVAN2',maxCapacity = 10000},
	{model = 'RATLOADER2',maxCapacity = 7000},
	{model = 'SLAMVAN3',maxCapacity = 7000},

	--Utilitaires
	
	{model = 'MULE',maxCapacity = 80000},
	{model = 'BENSON',maxCapacity = 100000},
	{model = 'HAULER',maxCapacity = 2000}, --camion SAP
	{model = 'TRAILERS_FOR_TRUCKS',maxCapacity = 80000}, --conteneur SAP
	{model = 'TANKER',maxCapacity = 100000}, --conteneur SAP2
	{model = 'TUG',maxCapacity = 160000}, --Bateau momo
	{model = 'PHANTOM',maxCapacity = 2000}, --camion bucheron  
	{model = 'TRAILER',maxCapacity = 80000}, --remorque bucheron
	
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
RegisterNetEvent('esx_inv_veh:getPlayerInv')
AddEventHandler('esx_inv_veh:getPlayerInv',function(inv)
	inv = inventory
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if IsControlJustPressed(0, Keys['T']) then
			GetVehicle()
		end
	end
end)

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

function notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end
function depositweapon()
	local selectitem = nil
	
    local elements = {}
	local playerPed  = GetPlayerPed(-1)
	local weaponList = ESX.GetWeaponList()
	local ammo = 0
	for i=1, #weaponList, 1 do

		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {label = weaponList[i].label..' - '..weaponList[i].weight..'g', value = weaponList[i].name, ammo = ammo})
		end
	end
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'depositweapon',
      {
        title    = 'Votre inventaire',
        elements = elements
      },
      function(data, menu)
        local weaponName = data.current.value
        TriggerServerEvent('esx_inv_veh:getPlate', plate)
		TriggerServerEvent('esx_inv_veh:putWeaponIntoVehicle', weaponName, ammo)
		menu.close()	
      end,
      function(data, menu)
        menu.close()
      end

  	)
end

function depositItem()
	

	local selectitem = nil
	

 	 ESX.TriggerServerCallback('esx_inv_veh:getPlayerInv', function(inventory)
  		
    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label..' - '..item.limit .. 'g x' .. item.count, type = 'item_standard', value = item.name , countMax = item.count})
      end

    end
       TriggerServerEvent('esx_inv_veh:getPlate', plate)
       ESX.TriggerServerCallback('esx_inv_veh:getVehicleInv', function(inventory, itemsWeight)
			useCapacity = 0
		   	for i=1, #inventory, 1 do
		   		for x=1, #itemsWeight, 1 do
		   			if itemsWeight[x].item == inventory[i].items then
						useCapacity = useCapacity + itemsWeight[x].weight*inventory[i].quantity
						break
					end
				end
			end
		end)


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu2',
      {
        title    = 'Votre inventaire (véhicule: '..tostring(useCapacity/1000)..'/'..tostring(maxCapacity/1000)..'kg)' ,
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        local quantity = data.current.countMax
        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count2',
          {
            title = 'quantité'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil or count < 0 or count > quantity then
              ESX.ShowNotification('quantité invalide')
            else
            		
			    --ESX.ShowNotification('use capacity: '..useCapacity..' maxCapacity: '.. maxCapacity)
			   	if useCapacity <= maxCapacity then
			   		if GetDistanceBetweenCoords(GetEntityCoords(v, true), GetEntityCoords(GetPlayerPed(-1), true), true) < 5 or (Vdist(GetEntityCoords(v, true), GetEntityCoords(GetPlayerPed(-1))) < 7.0 and GetEntityModel(v) == GetHashKey('TUG')) then
    					TriggerServerEvent('esx_inv_veh:putItemIntoVehicle', plate, itemName, count, useCapacity, maxCapacity)
    				end
    			else
    				 ESX.ShowNotification("Ce véhicule ne peux prendre que "..tostring(maxCapacity/1000).."kg")
    			end
			
				
            	 menu2.close()
            	menu.close()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)
end
function deposit()
	local elements = {}
	table.insert(elements, {label = 'Depot d\'item', value = "item"})
	table.insert(elements, {label = 'Dépot d\'arme', value = "weapon"})
 	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Votre inventaire',
        elements = elements
      },
      	function(data, menu)
      		if data.current.value == "weapon" then
      			depositweapon()
      		else
				depositItem()
	 		end
	 	end,
	 	function(data, menu)
	 		menu.close()
	  	end)
end

function withdrawItem()
	TriggerServerEvent('esx_inv_veh:getPlate',plate)
	ESX.TriggerServerCallback('esx_inv_veh:getVehicleInv', function(inventory, itemsWeight)

    local elements = {}

    for i=1, #inventory, 1 do

      local item = inventory[i]
  		if item ~= nil then
	   		for x=1, #itemsWeight, 1 do
	   			if itemsWeight[x].item == item.items then
	        		table.insert(elements, {label = item.items..' - '..itemsWeight[x].weight.. 'g x' .. item.quantity, type = 'item_standard', value = item.items})
					break
				end
			end
      	end

    end
    local random = math.random(0,1500)
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu52',
      {
        title    = 'Inventaire véhicule',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count42',
          {
            title = 'quantité'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil or count == 0 or count < 0 then
              ESX.ShowNotification('quantité invalide')
            else
              menu2.close()
              menu.close()
             	Citizen.CreateThread(function()
             	 Wait(random)
             	end)
                if GetDistanceBetweenCoords(GetEntityCoords(v, true), GetEntityCoords(GetPlayerPed(-1), true), true) < 5 or (Vdist(GetEntityCoords(v, true), GetEntityCoords(GetPlayerPed(-1))) < 7.0 and GetEntityModel(v) == GetHashKey('TUG')) then 
         			TriggerServerEvent('esx_inv_veh:takeItemFromVehicle',plate,itemName, count)
         		end
            end
          end,
          function(data2, menu2)
            menu2.close()
          end
        )
      end,
      function(data, menu)
        menu.close()
      end
    )

  end)
end

function withdrawWeapon()
	TriggerServerEvent('esx_inv_veh:getPlate',plate)
	ESX.TriggerServerCallback('esx_inv_veh:getVehicleWeapon', function(inventory)

    local elements = {}

	local weaponList = ESX.GetWeaponList()
    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]
  		if item ~= nil then
			for x=1, #weaponList, 1 do
				if weaponList[x].name == item.items then
        			table.insert(elements, {label = ESX.GetWeaponLabel(item.items)..' - '..weaponList[x].weight..'g', value = item.items})
        			break
        		end
        	end
      	end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'withdrawWeapon',
      {
        title    = 'Inventaire véhicule',
        elements = elements
      },
      function(data, menu)
      	local random = math.random(0, 1500)
      	Citizen.CreateThread(function()
             Wait(random)
        end)
        local itemName = data.current.value
        TriggerServerEvent('esx_inv_veh:takeweaponFromVehicle',plate,itemName, count)
        menu.close()
      end,
      function(data, menu)
        menu.close()
      end
    )

  end)
end

function GetVehicle()
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(PlayerId())))
    v = ESX.Game.GetClosestVehicle()
    Vcoords = GetEntityCoords(v, true)
	if DoesEntityExist(v) then

		if Vdist(x, y, z, Vcoords.x, Vcoords.y, Vcoords.z) < 3.4 or (Vdist(x, y, z, Vcoords.x, Vcoords.y, Vcoords.z) < 7.0 and GetEntityModel(v) == GetHashKey('TUG')) then
			local isClose = GetVehicleDoorLockStatus(v)
			if isClose == 1 or isClose == 0 then
				SetVehicleDoorOpen(v, 5, false, false)
				SetPedCanPlayGestureAnims(GetPlayerPed(-1), false)
				ESX.UI.Menu.CloseAll()
				plate = GetVehicleNumberPlateText(v)
				local model = GetDisplayNameFromVehicleModel(GetEntityModel(v))
				local found = false
				for i = 1 , #config ,1 do
					
					if config[i].model == model  then
						maxCapacity = config[i].maxCapacity
						found = true
					end
				end
				if not found then
					maxCapacity = defaultCapacity
				end
			
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Inventory',
					{
						title = 'Inventaire véhicule ('..tostring(maxCapacity/1000)..'kg)',
						elements = {
							{label = 'déposer', value = "depositItem"},
							{label = 'Récupérer', value = "withdrawItem"}
						}
					},
				    function(data, menu) --Submit Cb
				    	if data.current.value == "depositItem" then
				    		deposit()
				    	elseif data.current.value == "withdrawItem" then
		                	withdraw()
		                end
		        	end,
		       		function(data, menu) --Cancel Cb
		                menu.close()
		                SetVehicleDoorShut(v, 5, false)
		                SetPedCanPlayGestureAnims(GetPlayerPed(-1), true)
		        	end,
		       		function(data, menu) --Change Cb
		                --print(data.current.value)
		       		end
				)
			else
				ESX.ShowNotification("le véhicule est fermé")
			end
		else
			ESX.ShowNotification("Aucun véhicule proche") 
		end
	end
end

function withdraw()
	local elements = {}
	table.insert(elements, {label = 'Récupéré item', value = "item"})
	table.insert(elements, {label = 'Récupéré arme', value = "weapon"})
 	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Votre inventaire',
        elements = elements
      },
      	function(data, menu)
      		if data.current.value == "weapon" then
      			withdrawWeapon()
      		else
				withdrawItem()
	 		end
	 	end,
	 	function(data, menu)
	 		menu.close()
	  	end)
end