--------------------------------------
--------------------------------------
----    File : main.lua  		  ----
----    Edited by : gassastsina   ----
----    Side : client        	  ----
----    Description : Main Police ----
--------------------------------------
--------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

--TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'police2', 'Police2', 'society_police2', 'society_police2', 'society_police2', {type = 'private'})

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
    local playerItemCount = targetXPlayer.getInventoryItem(itemName).count

    if playerItemCount <= amount then
      targetXPlayer.removeInventoryItem(itemName, amount)
      sourceXPlayer.addInventoryItem(itemName, amount)
    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
  TriggerClientEvent('esx_policejob:handcuff', target)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_policejob:drag', target, _source)
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
  TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)
    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_policejob:getStockItem2')
AddEventHandler('esx_policejob:getStockItem2', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police2', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_policejob:putStockItems2')
AddEventHandler('esx_policejob:putStockItems2', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police2', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)

	if source ~= target then
	  if Config.EnableESXIdentity then

	    local xPlayer = ESX.GetPlayerFromId(target)

	    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
	      ['@identifier'] = xPlayer.identifier
	    })

	    local user   	= result[1]
	    local firstname = user['firstname']
	    local lastname  = user['lastname']
	    local sex       = user['sex']
	    local dob       = user['dateofbirth']
	    local height    = user['height'] .. " Inches"

	    local data = {
	      name        = GetPlayerName(target),
	      job         = xPlayer.job,
	      inventory   = xPlayer.inventory,
	      accounts    = xPlayer.accounts,
	      weapons     = xPlayer.loadout,
	      firstname   = firstname,
	      lastname    = lastname,
	      sex         = sex,
	      dob         = dob,
	      height      = height
	    }

	    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

	      if status ~= nil then
	        data.drunk = math.floor(status.percent)
	      end

	    end)

	    if Config.EnableLicenses then

	      TriggerEvent('esx_license:getLicenses', target, function(licenses)
	        data.licenses = licenses
	        cb(data)
	      end)

	    else
	      cb(data)
	    end

	  else

	    local xPlayer = ESX.GetPlayerFromId(target)

	    local data = {
	      name       = GetPlayerName(target),
	      job        = xPlayer.job,
	      inventory  = xPlayer.inventory,
	      accounts   = xPlayer.accounts,
	      weapons    = xPlayer.loadout
	    }

	    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

	      if status ~= nil then
	        data.drunk = status.getPercent()
	      end

	    end)

	    TriggerEvent('esx_license:getLicenses', target, function(licenses)
	      data.licenses = licenses
	    end)

	    cb(data)

	  end
	end
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	plate = string.upper(plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName)

  	local xPlayer = ESX.GetPlayerFromId(source)
	for i=1, #xPlayer.loadout, 1 do
		if xPlayer.loadout[i].name == weaponName then
			if xPlayer.loadout[i].suppressor then xPlayer.addInventoryItem('suppressor', 1) end
			if xPlayer.loadout[i].flashlight then xPlayer.addInventoryItem('flashlight', 1) end
			if xPlayer.loadout[i].grip 		 then xPlayer.addInventoryItem('grip', 1) 		end
			if xPlayer.loadout[i].scope 	 then xPlayer.addInventoryItem('scope', 1) 		end
			if xPlayer.loadout[i].clip == 1  then xPlayer.addInventoryItem('clip2', 1) 		elseif
				xPlayer.loadout[i].clip == 2  then xPlayer.addInventoryItem('clip3', 1) 	end
			break
		end
	end

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)
     cb()

  end)
end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)

  ESX.GetPlayerFromId(source).addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_policejob:getStockItems2', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police2', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
  cb({
    items = ESX.GetPlayerFromId(source).inventory
  })
end)

RegisterServerEvent('esx_policejob:weaponlicense') --Lui retire son weapon coté Bdd
AddEventHandler('esx_policejob:weaponlicense', function(target, type, cb)

	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.execute('DELETE FROM user_licenses WHERE type=@type AND owner=@owner', {
	  ['@type']  = "weapon",
	  ['@owner'] = targetXPlayer.identifier
	},
	function(rowsChanged)
	  if cb ~= nil then
	    cb()
	  end
	end
	)

	TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('confpermis') .. _U('weapon') .. _U('from2') .. targetXPlayer.name)
	TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('confpermis2') .. _U('weapon2'))
end)

RegisterServerEvent('esx_policejob:weaponlicense2') --Lui retire son weapcategorie3 coter Bdd
AddEventHandler('esx_policejob:weaponlicense2', function(target, type, cb)
  
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  MySQL.Async.execute(
    'DELETE FROM user_licenses WHERE type=@type AND owner=@owner',
    {
      ['@type']  = "weapcategorie3",
      ['@owner'] = targetXPlayer.identifier
    },
    function(rowsChanged)
      if cb ~= nil then
        cb()
      end
    end
  )

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('confpermis') .. _U('weapon3') .. _U('from2') .. targetXPlayer.name)
  TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('confpermis2') .. _U('weapon4'))

end)

RegisterServerEvent('esx_policejob:addcategorie3') --Lui retire son Code coté db
AddEventHandler('esx_policejob:addcategorie3', function(target, type, cb)
  
  local xPlayer = ESX.GetPlayerFromId(target)
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  MySQL.Async.execute(
    'INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)',
    {
      ['@type']  = 'weapcategorie3',
      ['@owner'] = xPlayer.identifier
    },
    function(rowsChanged)
      if cb ~= nil then
        cb()
      end
    end
  )


  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('addpermis') .. _U('from2') .. xPlayer.name)
  TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('addpermis2'))

end)

RegisterServerEvent('esx_policejob:removepoint')  --Enlève des points sur le permis
AddEventHandler('esx_policejob:removepoint', function(target, points)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
    MySQL.Sync.execute("UPDATE users SET licence_points=licence_points -"..points.." WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier
    })
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
          ['@identifier'] = xPlayer.identifier
        },
        function(license)
        	TriggerClientEvent('esx:showNotification', _source, "Vous avez retiré "..points.." points sur son permis")
        	TriggerClientEvent('esx:showNotification', target, "Vous avez perdu "..points.." points sur votre permis")
		    if license[1][licence_points] <= 0 then
		        TriggerClientEvent('esx:showNotification', target, "~r~Vous n'avez plus de points sur votre permis")
		    end
        end
    )
end)


RegisterServerEvent('esx_policejob:getLicensesPoints')
AddEventHandler('esx_policejob:getLicensesPoints', function(target)
	local _source = source
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
          ['@identifier'] = ESX.GetPlayerFromId(target).identifier
        },
        function(result)
            TriggerClientEvent('esx_policejob:getLicensesPoints', _source, target, result[1].licence_points)
        end
    )
end)


RegisterServerEvent('esx_policejob:setBadgeNumber')
AddEventHandler('esx_policejob:setBadgeNumber', function(player, number)
	local xPlayer = ESX.GetPlayerFromId(player)
	if xPlayer.job.name == 'police' then
	    MySQL.Sync.execute("UPDATE users SET matricule=@matricule WHERE identifier=@identifier", {
	        ['@identifier'] = xPlayer.getIdentifier(),
	        ['@matricule']	= number
	    })
	else
		TriggerClientEvent('esx:showNotification', '~r~La personne ne fait pas partie de la police', source)
	end
end)