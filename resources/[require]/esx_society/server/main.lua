------------------------------------------
------------------------------------------
----    File : main.lua            	  ----
----    Edited by : gassastsina       ----
----    Side : server          		  ----
----    Description : Society manager ----
------------------------------------------
------------------------------------------

ESX                 = nil
Jobs                = {}
RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetSociety(name)
  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      return RegisteredSocieties[i]
    end
  end
end

AddEventHandler('onMySQLReady', function()

  local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

  for i=1, #result, 1 do
    Jobs[result[i].name]        = result[i]
    Jobs[result[i].name].grades = {}
  end

  local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

  for i=1, #result2, 1 do
    Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
  end

end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)

  local found = false

  local society = {
    name      = name,
    label     = label,
    account   = account,
    datastore = datastore,
    inventory = inventory,
    data      = data,
  }

  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      found                  = true
      RegisteredSocieties[i] = society
      break
    end
  end

  if not found then
    table.insert(RegisteredSocieties, society)
  end

end)

AddEventHandler('esx_society:getSocieties', function(cb)
  cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
  cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)

    if amount > 0 and account.money >= amount then

		account.removeMoney(amount)
		xPlayer.addMoney(amount)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', amount))
		TriggerEvent('logs:write', "A retiré "..amount.."$ de la société "..society, source)

    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
    end

  end)

end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  if amount > 0 and xPlayer.get('money') >= amount then

    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
      xPlayer.removeMoney(amount)
      account.addMoney(amount)
    end)

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', amount))
	TriggerEvent('logs:write', "A déposé "..amount.."$ à la société "..society.label, source)


  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end
end)

RegisterServerEvent('esx_society:GetBlackMoney')
AddEventHandler('esx_society:GetBlackMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)

    if amount > 0 and account.get('black_money') >= amount then

		account.removeAccountMoney('black_money', amount)
		xPlayer.addAccountMoney('black_money', amount)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', amount))
		TriggerEvent('logs:write', "A retiré "..amount.."$ d'argent sale de la société "..society, source)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
    end
  end)
end)

RegisterServerEvent('esx_society:PutBlackMoney')
AddEventHandler('esx_society:PutBlackMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  society = GetSociety(society)

  if amount > 0 and xPlayer.getAccount('black_money').money >= amount then

    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
    	print(json.encode(account))
      xPlayer.removeAccountMoney('black_money', amount)
      account.addMoney('black_money', amount)
    end)

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', amount))
	TriggerEvent('logs:write', "A déposé "..amount.."$ d'argent sale à la société "..society.label, source)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end
end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if amount > 0 and account.money >= amount then

    xPlayer.removeAccountMoney('black_money', amount)

      MySQL.Async.execute(
        'INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@society']    = society,
          ['@amount']     = amount
        },
        function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', amount))
			TriggerEvent('logs:write', "Blanchi "..amount.."$ par la société "..society, _source)

        end
      )

  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end

end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    local garage = store.get('garage') or {}
    table.insert(garage, vehicle)
    store.set('garage', garage)
  end)
	TriggerEvent('logs:write', "A garé le véhicule ("..vehicle.plate..") dans le garage de la société "..societyName, source)

end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    
    local garage = store.get('garage') or {}

    for i=1, #garage, 1 do
      if garage[i].plate == vehicle.plate then
        table.remove(garage, i)
		TriggerEvent('logs:write', "A sorti le véhicule ("..vehicle.plate..") du garage de la société "..societyName, source)
        break
      end
    end

    store.set('garage', garage)

  end)

end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
  local society = GetSociety(societyName)
  if society ~= nil then
    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
      cb(account.money)
    end)
  else
    cb(0)
  end

end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)

  if Config.EnableESXIdentity then
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC',
      { ['@job'] = society },
      function (results)
        local employees = {}

        for i=1, #results, 1 do
          table.insert(employees, {
            name        = results[i].firstname .. ' ' .. results[i].lastname,
            identifier  = results[i].identifier,
            job = {
              name        = results[i].job,
              label       = Jobs[results[i].job].label,
              grade       = results[i].job_grade,
              grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
              grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  else
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job = @job ORDER BY job_grade DESC',
      { ['@job'] = society },
      function (result)
        local employees = {}

        for i=1, #result, 1 do
          table.insert(employees, {
            name        = result[i].name,
            identifier  = result[i].identifier,
            job = {
              name        = result[i].job,
              label       = Jobs[result[i].job].label,
              grade       = result[i].job_grade,
              grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
              grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  end
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)

  local job    = json.decode(json.encode(Jobs[society]))
  local grades = {}

  for k,v in pairs(job.grades) do
    table.insert(grades, v)
  end

  table.sort(grades, function(a, b)
    return a.grade < b.grade
  end)

  job.grades = grades

  cb(job)

end)


ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)

	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	if xPlayer ~= nil then
		xPlayer.setJob(job, grade)
		
		if type == 'hire' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_hired', job))
		elseif type == 'promote' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_promoted'))
		elseif type == 'fire' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_fired', xPlayer.getJob().label))
		end
	end

	MySQL.Async.execute(
		'UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier',
		{
			['@job']        = job,
			['@job_grade']  = grade,
			['@identifier'] = identifier
		},
		function(rowsChanged)
			cb()
		end
	)

end)

ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)

  MySQL.Async.execute(
    'UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade',
    {
      ['@salary']   = salary,
      ['@job_name'] = job,
      ['@grade']    = grade
    },
    function(rowsChanged)

      Jobs[job].grades[tostring(grade)].salary = salary

      local xPlayers = ESX.GetPlayers()

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == job and xPlayer.job.grade == grade then
          xPlayer.setJob(job, grade)
        end

      end

      cb()
    end
  )

end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)

  local xPlayers = ESX.GetPlayers()
  local players  = {}

  for i=1, #xPlayers, 1 do

    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

    table.insert(players, {
      source     = xPlayer.source,
      identifier = xPlayer.identifier,
      name       = xPlayer.name,
      job        = xPlayer.job
    })

  end

  cb(players)

end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', GetSociety(societyName).datastore, function(store)
    local garage = store.get('garage') or {}
    cb(garage)
  end)

end)

function WashMoneyCRON()
	MySQL.Async.fetchAll(
	'SELECT * FROM society_moneywash', {},
	function(result)
		for i=1, #result, 1 do

			-- add society money
			local society = GetSociety(result[i].society)
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
			end)

			-- send notification if player is online
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)
			if xPlayer ~= nil then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered', result[i].amount))
			end

			MySQL.Async.execute('DELETE FROM society_moneywash WHERE id = @id',
			{
				['@id'] = result[i].id
			})
		end
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)


----------------------------------------COFFRE----------------------------------------------------
ESX.RegisterServerCallback('esx_society:getStockItems', function(source, cb, society)
  TriggerEvent('esx_addoninventory:getSharedInventory', GetSociety(society).inventory, function(inventory)
    cb(inventory.items)
  end)
end)

ESX.RegisterServerCallback('esx_society:getPlayerInventory', function(source, cb)
  cb(ESX.GetPlayerFromId(source).inventory)
end)
local FoodItems = {}
AddEventHandler('esx:GetFoodItemsList', function(FoodItemsList)
	FoodItems = FoodItemsList
end)

local function IsFoodItem(item)
	for i=1, #FoodItems, 1 do
		if FoodItems[i] == item then
			return true
		end
	end
	return false
end

local function getPlayerWeight(xPlayer, item)
	local totalWeight = 0
	local totalFoodWeight = 0
	--Player inventory weight
	for i=1, #xPlayer.inventory, 1 do
		if xPlayer.inventory[i].count > 0 then
			if not IsFoodItem(xPlayer.inventory[i].name) then
		  		totalWeight = totalWeight + xPlayer.inventory[i].limit*xPlayer.inventory[i].count
		  	else
		  		totalFoodWeight = totalFoodWeight + xPlayer.inventory[i].limit*xPlayer.inventory[i].count
		  	end
		end
	end
	if IsFoodItem(item) then
		return totalFoodWeight
	end
	return totalWeight
end

RegisterServerEvent('esx_society:getStockItem')
AddEventHandler('esx_society:getStockItem', function(itemName, count, society)

  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', GetSociety(society).inventory, function(inventory)

    local item = inventory.getItem(itemName)
    if item.count >= count and getPlayerWeight(xPlayer, itemName) + count*xPlayer.getInventoryItem(itemName).limit <= 10000 then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
		TriggerEvent('logs:write', "A retiré "..count.." "..itemName.." du coffre de la société "..society, source)
    	TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré x' .. count .. ' ' .. item.label)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité ~r~invalide')
    end
  end)
end)

RegisterServerEvent('esx_society:putStockItem')
AddEventHandler('esx_society:putStockItem', function(itemName, count, society)

  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', GetSociety(society).inventory, function(inventory)

    local item = inventory.getItem(itemName)
    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
		TriggerEvent('logs:write', "A déposé "..count.." "..itemName.." dans le coffre de la société "..society, source)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité ~r~invalide')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouté x' .. count .. ' ' .. item.label)
  end)
end)