----------------------------------------------
----------------------------------------------
----    File : client.lua       		  ----
----    Author: gassastsina     		  ----
----	Side : client 		 			  ----
----    Description : Weapons accessories ----
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

local PlayerData = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('weaponsAccessories:updateLoadoutFromESXServer')
AddEventHandler('weaponsAccessories:updateLoadoutFromESXServer', function(loadout)
	PlayerData.loadout = loadout
end)

--------------------------------------------main---------------------------------------------------------
RegisterNetEvent('weaponsAccessories:pickup')
AddEventHandler('weaponsAccessories:pickup', function(pickup, weaponName, x, y, z)
	while DoesEntityExist(pickup) do
		Wait(100)
	end
	local coords = GetEntityCoords(GetPlayerPed(-1), true)
	if Vdist(x, y, z, coords.x, coords.y, coords.z) <= 2.0 then
		TriggerServerEvent('weaponsAccessories:gotPickup', weaponName, x, y, z)
	end
end)


RegisterNetEvent('weaponsAccessories:getSelectedWeapon')
AddEventHandler('weaponsAccessories:getSelectedWeapon', function(item)
    local inventory = PlayerData.inventory
    for i=1, #inventory, 1 do
        if inventory[i].name == item then
            if inventory[i].count > 0 then
              TriggerServerEvent('weaponsAccessories:putItems', GetSelectedPedWeapon(GetPlayerPed(-1)), item)
            else
              TriggerEvent('esx:showNotification', "Vous n'avez plus cette accessoire")
            end
        end
    end
end)

RegisterNetEvent('weaponsAccessories:setAccessories')
AddEventHandler('weaponsAccessories:setAccessories', function(accessories, loadout, part, IsGotAccessorie)
    local weaponHash = GetHashKey(loadout.name)
    if part == 'menu' then
        for i=1, 3, 1 do
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.clip..'_0'..i))
        end
        accessories.clip = accessories.clip..'_0'..loadout.clip+1
    end

    RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.suppressor))
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.flashlight))
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.grip))
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.scope))
    RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.clip))

    SetPedWeaponTintIndex(GetPlayerPed(-1), weaponHash, loadout.tint)

    if loadout.suppressor ~= false and IsGotAccessorie.suppressor then
      GiveWeaponComponentToPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.suppressor))
      if Config.Debug then
        print('DEBUG weaponsAccessories : set suppressor')
      end
    end
    if loadout.flashlight ~= false and IsGotAccessorie.flashlight then
      GiveWeaponComponentToPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.flashlight))
      if Config.Debug then
        print('DEBUG weaponsAccessories : set flashlight')
      end
    end
    if loadout.grip ~= false and IsGotAccessorie.grip then
      GiveWeaponComponentToPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.grip))
      if Config.Debug then
        print('DEBUG weaponsAccessories : set grip')
      end
    end
    if loadout.scope ~= false and IsGotAccessorie.scope then
      GiveWeaponComponentToPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.scope))
      if Config.Debug then
        print('DEBUG weaponsAccessories : set scope')
      end
    end
    if loadout.clip ~= 0 and IsGotAccessorie['clip'..loadout.clip+1] then
      GiveWeaponComponentToPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.clip))
      if Config.Debug then
        print('DEBUG weaponsAccessories : set clip')
      end
    end
    if loadout.carving ~= false then
      GiveWeaponComponentToPed(GetPlayerPed(-1), weaponHash, GetHashKey(accessories.carving))
      if Config.Debug then
        print('DEBUG weaponsAccessories : set carving')
      end
    end

	TriggerEvent('weaponsAccessories:updateLoadout', loadout)
end)

--------------------------------------------shop---------------------------------------------------------
RegisterNetEvent('weaponsAccessories:ShopMenu')
AddEventHandler('weaponsAccessories:ShopMenu', function()
    local elements = {}
    for i=0, #PlayerData.loadout, 1 do
        if PlayerData.loadout[i] ~= nil then
            table.insert(elements, {label = PlayerData.loadout[i].label, value = PlayerData.loadout[i].name, tint = PlayerData.loadout[i].tint, carving = PlayerData.loadout[i].carving})
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop',
    {
        title  = 'Teintes / Gravure',
        elements = elements
    }, function(data, menu)

        weaponTintAndCarving(data.current.label, data.current.value, data.current.tint, data.current.carving)

    end, function(data, menu)
        menu.close()
        TriggerEvent('weaponsAccessories:ShopMenu')
    end
    )
end)

function weaponTintAndCarving(weaponLabel, weaponName, weaponTint, weaponCarving)
    if not weaponCarving then
        TriggerEvent('esx:showNotification', "Une fois une gravure appliquée, vous ne pourrez plus l'enlever")
    end
    local elements = {}
    for i=1, #Config.Wallpapers, 1 do
        if Config.Wallpapers[i].value ~= 'carving' then
            if Config.Wallpapers[i].value ~= weaponTint then
                table.insert(elements, {label = Config.Wallpapers[i].label, value = Config.Wallpapers[i].value, price = Config.Wallpapers[i].price})
            else
                table.insert(elements, {label = Config.Wallpapers[i].label..' - <span style="color:green;">Appliquée </span>', value = Config.Wallpapers[i].value, price = Config.Wallpapers[i].price})
            end
        else
            if weaponCarving then
                table.insert(elements, {label = Config.Wallpapers[i].label..' - <span style="color:green;">Gravé </span>', value = Config.Wallpapers[i].value, price = Config.Wallpapers[i].price})
            else
                table.insert(elements, {label = Config.Wallpapers[i].label, value = Config.Wallpapers[i].value, price = Config.Wallpapers[i].price})
            end
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop',
    {
        title  = weaponLabel,
        elements = elements
    }, function(data, menu)

        if not weaponCarving then
            if data.current.value ~= 'carving' then
                SetPedWeaponTintIndex(GetPlayerPed(-1), GetHashKey(weaponName), data.current.value)
                weaponTintAndCarving(weaponLabel, weaponName, data.current.value, weaponCarving)
            else
                weaponTintAndCarving(weaponLabel, weaponName, weaponTint, not weaponCarving)
            end
            TriggerEvent('weaponsAccessories:updateTintCarving', weaponName, data.current.value)
            TriggerServerEvent('weaponsAccessories:removeMoney', data.current.price)
        else
            TriggerEvent('esx:showNotification', 'Vous ne pouvez plus changer ni la teinte, ni la gravure')
        end

    end, function(data, menu)
        menu.close()
        tintShopMenu()
    end
    )
end



--------------------------------------------Menu---------------------------------------------------------
RegisterNetEvent('weaponsAccessories:accessoriesMenu')
AddEventHandler('weaponsAccessories:accessoriesMenu', function()
    local elements = {}
    for i=1, #PlayerData.loadout, 1 do
        if PlayerData.loadout[i] ~= nil then
            table.insert(elements, {label = PlayerData.loadout[i].label or PlayerData.loadout[i].name, value = PlayerData.loadout[i].name})
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapons_menu', {
        title  = title,
        elements = elements
    }, function(data, menu)
    	menu.close()
	    elements = {}
	    for i=1, #PlayerData.loadout, 1 do
	        if PlayerData.loadout[i].name == data.current.value then
	        	if PlayerData.loadout[i].suppressor then table.insert(elements, {label = "Silencieux",		value = 'suppressor'}) end
	        	if PlayerData.loadout[i].flashlight then table.insert(elements, {label = "Lampe torche", 	value = 'flashlight'}) end
	        	if PlayerData.loadout[i].grip 		then table.insert(elements, {label = "Poignée", 		value = 'grip'}) 	   end
	        	if PlayerData.loadout[i].scope 		then table.insert(elements, {label = "Viseur", 			value = 'scope'}) 	   end
	        	if PlayerData.loadout[i].clip == 1	then table.insert(elements, {label = "Chargeur grande capacité", value = 'clip2'}) elseif
	        	   PlayerData.loadout[i].clip == 2	then table.insert(elements, {label = "Chargeur très grand capacité", value = 'clip3'}) end
	        	   break
	        end
	    end

	    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'accessories_menu', {
	        title  = title,
	        elements = elements
	    }, function(data2, menu2)
	    	menu2.close()
	        TriggerEvent('weaponsAccessories:useAccessorie', data2.current.value, data.current.value)

	    end, function(data2, menu2)
	        menu2.close()
	        TriggerEvent('weaponsAccessories:accessoriesMenu')
	    end
	    )

    end, function(data, menu)
        menu.close()
        TriggerEvent('nb:openMenuPersonnel')
    end
    )
end)

-------------------------------------------------Use-items----------------------------------------------------
RegisterNetEvent('weaponsAccessories:useAccessorie')
AddEventHandler('weaponsAccessories:useAccessorie', function(accessorie, MenuWeapon)
	local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
	if MenuWeapon ~= nil then
		weapon = GetHashKey(MenuWeapon)
	end
	if weapon ~= nil then

		if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item') then
			ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item')
		end
		if not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			ESX.ShowInventory()
		end
		for i=1, #PlayerData.loadout, 1 do
			if GetHashKey(PlayerData.loadout[i].name) == weapon then
				if accessorie ~= 'clip1' and accessorie ~= 'clip2' and accessorie ~= 'clip3' then
					PlayerData.loadout[i][accessorie] = not PlayerData.loadout[i][accessorie]
					if PlayerData.loadout[i][accessorie] then
						TriggerServerEvent('weaponsAccessories:getAccessories', PlayerData.loadout[i].name, 'menu', source, PlayerData.loadout[i], nil, accessorie)
					else
						TriggerServerEvent('weaponsAccessories:getAccessories', PlayerData.loadout[i].name, 'menu', source, PlayerData.loadout[i], accessorie, nil)
					end
				else
					local clipLevel = tonumber(string.sub(accessorie, 5, 5))-1
					if PlayerData.loadout[i].clip ~= clipLevel then
						local lastAccessorie = 'clip'..PlayerData.loadout[i].clip+1
						PlayerData.loadout[i].clip = clipLevel
						TriggerServerEvent('weaponsAccessories:getAccessories', PlayerData.loadout[i].name, 'menu', source, PlayerData.loadout[i], lastAccessorie, 'clip'..clipLevel+1)
					else
						ESX.TriggerServerCallback('weaponsAccessories:getItemCount', function(qty)
							if qty > 0 then
								local lastAccessorie = 'clip'..PlayerData.loadout[i].clip+1
								PlayerData.loadout[i].clip = 0
								TriggerServerEvent('weaponsAccessories:getAccessories', PlayerData.loadout[i].name, 'menu', source, PlayerData.loadout[i], lastAccessorie, 'clip1')
							end
						end, 'clip1')
					end
				end
			end
		end
	end
end)