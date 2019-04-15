ESX              = nil
local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function RemoveOwnedVehicle (plate)
  MySQL.Async.fetchAll(
    'SELECT * FROM owned_vehicles',
    {},
    function (result)
      for i=1, #result, 1 do
        local vehicleProps = json.decode(result[i].vehicle)

        if vehicleProps.plate == plate then
          MySQL.Async.execute(
            'DELETE FROM owned_vehicles WHERE id = @id',
            { ['@id'] = result[i].id }
          )
        end
      end
    end
  )
end

AddEventHandler('onMySQLReady', function()

	Categories       = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles   = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

	for i=1, #vehicles, 1 do

		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
			end
		end

		table.insert(Vehicles, vehicle)

	end

end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function(vehicleProps, x)
	local vehicleProps = vehicleProps
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = "MiltonDrive"
    local zone = 0
	
	MySQL.Async.execute(
		'INSERT INTO owned_vehicles (vehicle, owner) VALUES (@vehicle, @owner)',
		{
			['@vehicle'] = json.encode(vehicleProps),
			['@owner']   = xPlayer.identifier
		},
		function(rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, 'Le véhicule ' .. vehicleProps.plate .. ' vous appartient désormais')
		end
	)

	MySQL.Async.fetchAll(
		'SELECT * FROM user_parkings WHERE identifier = @identifier ',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)
			local x = 1
			local bool = true
			local  found = false
			while bool do
				found = false		
				for i = 1, #result, 1 do
					--print(result[i].zone)
					if result[i].zone == x then
						found = true
					end
				end
				if found then
					x = x +1
				else
					bool = false
				end
			end
				--print("Zone = "..x)
		end
	)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps)

	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute(
		'INSERT INTO owned_vehicles (vehicle, owner) VALUES (@vehicle, @owner)',
		{
			['@vehicle'] = json.encode(vehicleProps),
			['@owner']   = xPlayer.identifier
		},
		function(rowsChanged)
			TriggerClientEvent('esx:showNotification', playerId, 'Le véhicule ' .. vehicleProps.plate .. ' vous appartient désormait')
		end
	)
end)

RegisterServerEvent('esx_vehicleshop:sellVehicle')
AddEventHandler('esx_vehicleshop:sellVehicle', function(vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicle
		},
		function(result)

			local id    = result[1].id
			local price = result[1].price

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = id
				}
			)
			xPlayer.addMoney(price)
		end
	)
end)

RegisterServerEvent('esx_vehicleshop:rentVehicle')
AddEventHandler('esx_vehicleshop:rentVehicle', function(vehicle, plate, playerName, basePrice, rentPrice, target)

	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll(
		'SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1',
		{
			['@vehicle'] = vehicle
		},
		function(result)

			local id     = result[1].id
			local price  = result[1].price
			local owner  = xPlayer.identifier

			MySQL.Async.execute(
				'DELETE FROM cardealer_vehicles WHERE id = @id',
				{
					['@id'] = id
				}
			)
			
			MySQL.Async.execute(
				'INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)',
				{
					['@vehicle']     = vehicle,
					['@plate']       = plate,
					['@player_name'] = playerName,
					['@base_price']  = basePrice,
					['@rent_price']  = rentPrice,
					['@owner']       = owner
				}
			)

		end
	)

end)

RegisterServerEvent('esx_vehicleshop:setVehicleForAllPlayers')
AddEventHandler('esx_vehicleshop:setVehicleForAllPlayers', function(props, x, y, z, radius)
	TriggerClientEvent('esx_vehicleshop:setVehicle', -1, props, x, y, z, radius)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil
	local zone = 0
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result)
			zone = #result 
							
			for i=1, #Vehicles, 1 do
				if Vehicles[i].model == vehicleModel then
					vehicleData = Vehicles[i]
					break
				end
			end

			if xPlayer.getBank() >= vehicleData.price then
				xPlayer.removeAccountMoney('bank', vehicleData.price)
				cb(true)
			else
				cb(false)
			end
		end
	)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicleSociety', function(source, cb, vehicleModel)
	
	local vehicleData = nil
	local zone = 0
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result)

			zone = #result 
			zone = zone +1
		end
	)

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)

		if account.money >= vehicleData.price and zone <= 10 then

			account.removeMoney(vehicleData.price)

			MySQL.Async.execute(
				'INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)',
				{
					['@vehicle'] = vehicleData.model,
					['@price']   = vehicleData.price
				}
			)

			cb(true)
		else
			cb(false)
		end

	end)

end)

ESX.RegisterServerCallback('esx_vehicleshop:getPersonnalVehicles', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result)

			local vehicles = {}

			for i=1, #result, 1 do
				local vehicleData = json.decode(result[i].vehicle)
				table.insert(vehicles, vehicleData)
			end

			cb(vehicles)

		end
	)

end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function(source, cb)

	MySQL.Async.fetchAll(
		'SELECT * FROM cardealer_vehicles ORDER BY vehicle ASC',
		{},
		function(result)

			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					name  = result[i].vehicle,
					price = result[i].price
				})
			end

			cb(vehicles)

		end
	)

end)

ESX.RegisterServerCallback('esx_vehicleshop:getRentedVehicles', function(source, cb)

	MySQL.Async.fetchAll(
		'SELECT * FROM rented_vehicles ORDER BY player_name ASC',
		{},
		function(result)

			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					name       = result[i].vehicle,
					plate      = result[i].plate,
					playerName = result[i].player_name
				})
			end

			cb(vehicles)

		end
	)

end)

ESX.RegisterServerCallback('esx_vehicleshop:giveBackVehicle', function(source, cb, plate)

	MySQL.Async.fetchAll(
		'SELECT * FROM rented_vehicles WHERE plate = @plate LIMIT 1',
		{
			['@plate'] = plate
		},
		function(result)

			if #result > 0 then

				local id        = result[1].id
				local vehicle   = result[1].vehicle
				local plate     = result[1].plate
				local basePrice = result[1].base_price

				MySQL.Async.execute(
					'INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)',
					{
						['@vehicle'] = vehicle,
						['@price']   = basePrice
					}
				)

				MySQL.Async.execute(
					'DELETE FROM rented_vehicles WHERE id = @id',
					{
						['@id'] = id
					}
				)

				RemoveOwnedVehicle(plate)

				cb(true)

			else
				cb(false)
			end

		end
	)

end)

ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function(source, cb, plate, price)
	local _source = source
	local plate = plate
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@owner', {
			['@owner'] = identifier
		},
		function(result)
			for i=1, #result, 1 do
				if json.decode(result[i].vehicle).plate == plate then
					xPlayer.addMoney(price)
					RemoveOwnedVehicle(plate)
					MySQL.Async.execute('DELETE FROM user_parkings WHERE plate = @plate', {
						['@plate'] = plate
					})
 					TriggerEvent("logs:write", 'A vendu son véhicule ('..plate.. ') pour '.. price..'$', _source)
					cb(true)
					break
				elseif i == #result then
 					TriggerEvent("logs:write", "N'a pas réussi à vendre son véhicule ("..plate..") à "..price.."$", _source)
					cb(false)
				end
			end
		end
	)
end)

TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message, anon)

	local xPlayer  = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	if phoneNumber == 'cardealer' then
		for i=1, #xPlayers, 1 do
            local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer2.job.name == 'cardealer' then
				TriggerClientEvent('esx_phone:onMessage', xPlayer2.source, xPlayer.get('phoneNumber'), message, xPlayer.get('coords'), anon, 'player')
			end
		end
	end
	
end)

if Config.EnablePvCommand then

	TriggerEvent('es:addCommand', 'pv', function(source, args, user)
		TriggerClientEvent('esx_vehicleshop:openPersonnalVehicleMenu', source)
	end, {help = 'Sortir un véhicule personnel'})

end

function PayRent(d, h, m)

	MySQL.Async.fetchAll(
		'SELECT * FROM users',
		{},
		function(_users)

			local prevMoney = {}
			local newMoney  = {}

			for i=1, #_users, 1 do
				prevMoney[_users[i].identifier] = _users[i].money
				newMoney[_users[i].identifier]  = _users[i].money
			end

			MySQL.Async.fetchAll(
				'SELECT * FROM rented_vehicles',
				{},
				function(result)

					local xPlayers = ESX.GetPlayers()

					for i=1, #result, 1 do

						local foundPlayer = false
						local xPlayer     = nil

						for i=1, #xPlayers, 1 do
            				local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
							if xPlayer2.identifier == result[i].owner then
								foundPlayer = true
								xPlayer     = xPlayer2
							end
						end

						if foundPlayer then

							xPlayer.removeMoney(result[i].rent_price)
							TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ~g~payé~s~ votre location de véhicule : ~g~$' .. result[i].rent_price)
						
						else
							newMoney[result[i].owner] = newMoney[result[i].owner] - result[i].rent_price
						end

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
							account.addMoney(result[i].rent_price)
						end)

					end

					for k,v in pairs(prevMoney) do
						if v ~= newMoney[k] then

							MySQL.Async.execute(
								'UPDATE users SET money = @money WHERE identifier = @identifier',
								{
									['@money']      = newMoney[k],
									['@identifier'] = k
								}
							)

						end
					end

				end
			)

		end
	)

end

TriggerEvent('cron:runAt', 22, 00, PayRent)
