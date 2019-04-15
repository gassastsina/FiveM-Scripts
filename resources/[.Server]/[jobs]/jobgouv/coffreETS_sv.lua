ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



---------------------------
--item bucheron

RegisterServerEvent('esx_lumberjack:getStockItem')
AddEventHandler('esx_lumberjack:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lumberjack', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, ('Quantité invalide'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, ('Retrait de ') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_lumberjack:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lumberjack', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_lumberjack:putStockItems')
AddEventHandler('esx_lumberjack:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lumberjack', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, ('Quantité invalide'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, ('Ajout de ') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_lumberjack:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)


---

---------------------------
--item fuel


RegisterServerEvent('esx_fuel:getStockItem')
AddEventHandler('esx_fuel:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fuel', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, ('Quantité invalide'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, ('Retrait de ') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_fuel:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fuel', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_fuel:putStockItems')
AddEventHandler('esx_fuel:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fuel', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, ('Quantité invalide'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, ('Ajout de ') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_fuel:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
---

