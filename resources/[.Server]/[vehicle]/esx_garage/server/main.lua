------------------------------------
------------------------------------
----    File : main.lua    		----
----    Edited by : gassastsina ----
----    Side : server        	----
----    Description : Garage 	----
------------------------------------
------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_garage:setParking')
AddEventHandler('esx_garage:setParking', function(garage, zone, vehicleProps)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

	if vehicleProps == false then

		MySQL.Async.execute('UPDATE user_parkings SET inparking=@inparking WHERE `identifier`=@identifier AND `garage`=@garage AND zone=@zone', {
			['@identifier'] = xPlayer.identifier,
			['@garage']     = garage,
			['@zone']       = zone,
			['@inparking']  = 0
		})
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('veh_released'))

	else

		local result = MySQL.Sync.fetchScalar("SELECT * FROM user_parkings WHERE identifier=@identifier AND plate=@plate", {
			['@identifier'] = xPlayer.identifier,
			['@plate']		= vehicleProps.plate
		})
		if result ~= nil then
			MySQL.Async.execute('UPDATE `user_parkings` SET `zone`=@zone, `vehicle`=@vehicle, `inparking`=@inparking WHERE `identifier`=@identifier AND `plate`=@plate', {
			--Condition
				['@identifier'] = xPlayer.identifier,
				['@plate'] 		= vehicleProps.plate,
			--SET
				['@garage']     = garage,
				['@zone']       = zone,
				['@vehicle'] 	= json.encode(vehicleProps),
				['@inparking']  = 1
			})
		else
			MySQL.Async.execute(
				'INSERT INTO `user_parkings` (`identifier`, `garage`, `zone`, `vehicle`, `inparking`, `plate`) VALUES (@identifier, @garage, @zone, @vehicle, @inparking, @plate)',
				{
					['@identifier'] = xPlayer.identifier,
					['@garage']     = garage,
					['@zone']       = zone,
					['@vehicle']    = json.encode(vehicleProps),
					['@inparking']	= 1,
					['@plate']		= vehicleProps.plate
				}, function(rowsChanged)
				end
			)
		end
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('veh_stored'))
	end
end)

RegisterServerEvent('esx_garage:updateOwnedVehicle')
 AddEventHandler('esx_garage:updateOwnedVehicle', function(vehicleProps)
 
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
 
 	MySQL.Async.fetchAll(
 		'SELECT * FROM owned_vehicles WHERE owner = @owner',
 		{
 			['@owner'] = xPlayer.identifier
 		},
 		function(result)
 
 			local foundVehicleId = nil
 
 			for i=1, #result, 1 do
 				
 				local vehicle = json.decode(result[i].vehicle)
 				
 				if vehicle.plate == vehicleProps.plate then
 					foundVehicleId = result[i].id
 					break
 				end
 
 			end
 
 			if foundVehicleId ~= nil then

 				MySQL.Async.execute(
 					'UPDATE owned_vehicles SET vehicle = @vehicle WHERE id = @id',
 					{
						['@vehicle'] = json.encode(vehicleProps),
						['@id']      = foundVehicleId
 					}
 				)
 
 			end
 
 		end
 	)
 
 end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehiclesInGarage', function(source, cb, garage)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll(
		'SELECT * FROM `user_parkings` WHERE `identifier` = @identifier AND garage = @garage AND inparking=@inparking',
		{
			['@identifier'] = xPlayer.identifier,
			['@garage']     = garage,
			['@inparking'] 	= 1
		},
		function(result)

			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					zone    = result[i].zone,
					vehicle = json.decode(result[i].vehicle)
				})
			end

			cb(vehicles)

		end
	)
end)

AddEventHandler('onMySQLReady', function()
	Wait(2000)
	MySQL.Async.fetchAll('SELECT * FROM `user_parkings` WHERE 1', nil,
		function(vehicles)
			local vehiclesFromGarages = {}
			for i=1, #vehicles, 1 do
				if vehicles[i].plate ~= nil then
					table.insert(vehiclesFromGarages, {plate = vehicles[i].plate, garage = vehicles[i].garage, zone = vehicles[i].zone})
				end
			end
			MySQL.Async.execute('DELETE FROM `user_parkings` WHERE 1', nil, function()
				MySQL.Async.fetchAll('SELECT * FROM `datastore_data` WHERE 1', nil,
					function(result)
						local vehiclesInGarages = {}
						for i=1, #result, 1 do
							if json.decode(result[i].data).garage ~= nil then
								for k=1, #json.decode(result[i].data).garage, 1 do
									if json.decode(result[i].data).garage[k].plate ~= nil then
										table.insert(vehiclesInGarages, json.decode(result[i].data).garage[k].plate)
									end
								end
							end
						end
						MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE 1', nil, function(result2)
							for i=1, #result2, 1 do
								if json.decode(result2[i].vehicle).plate ~= nil then
									local vehicleFound = false
									for k=1, #vehiclesInGarages, 1 do
										if json.decode(result2[i].vehicle).plate ~= vehiclesInGarages[k] and not vehicleFound then
											for x=1, #vehiclesFromGarages, 1 do
												if vehiclesFromGarages[x].plate == json.decode(result2[i].vehicle).plate and not vehicleFound then
													vehicleFound = true
													MySQL.Async.execute(
														'INSERT INTO `user_parkings` (`identifier`, `garage`, `zone`, `vehicle`, `inparking`, `plate`) VALUES (@identifier, @garage, @zone, @vehicle, @inparking, @plate)', {
															['@identifier'] = result2[i].owner,
															['@garage']     = vehiclesFromGarages[x].garage,
															['@zone']       = vehiclesFromGarages[x].zone,
															['@vehicle']    = result2[i].vehicle,
															['@inparking']	= 1,
															['@plate']		= json.decode(result2[i].vehicle).plate
														}, function()
														end
													)
													break
												end
											end
										end
									end
								end
							end

							SetTimeout(3000, function()
								MySQL.Async.fetchAll('SELECT * FROM `user_parkings` WHERE 1', nil, function(vehiclesRest)
									for i=1, #result2, 1 do
										if json.decode(result2[i].vehicle).plate ~= nil then
											local IsInGarage = false
											for x=1, #vehiclesInGarages, 1 do
												for k=1, #vehiclesRest, 1 do
													if json.decode(result2[i].vehicle).plate == vehiclesRest[k].plate or json.decode(result2[i].vehicle).plate == vehiclesInGarages[x] then
														IsInGarage = true
														break
													end
												end
												if not IsInGarage then
													MySQL.Async.fetchAll('SELECT * FROM `user_parkings` WHERE `identifier`=@identifier', {
															['@identifier'] = result2[i].owner
														},
														function(result3)
															local garage = 'MiltonDrive'
															local place = 1
															if result3 ~= nil and json.encode(result3) ~= '[]' then
																local placeFound = false
																for y, v in pairs(Config.Garages) do
																	for k=1, #v.Parkings, 1 do
																		for j=1, #result3, 1 do
																			if result3[j].zone == k or placeFound then
																				break
																			elseif j == #result3  and not placeFound then
																				placeFound = true
																				place = k
																				garage = y
																				break
																			end
																		end
																	end
																end
															end
															MySQL.Async.execute(
																'INSERT INTO `user_parkings` (`identifier`, `garage`, `zone`, `vehicle`, `inparking`, `plate`) VALUES (@identifier, @garage, @zone, @vehicle, @inparking, @plate)', {
																	['@identifier'] = result2[i].owner,
																	['@garage']     = garage,
																	['@zone']       = place,
																	['@vehicle']    = result2[i].vehicle,
																	['@inparking']	= 1,
																	['@plate']		= json.decode(result2[i].vehicle).plate
																}, function()
																end
															)
														end
													)
													break
												end
											end
										end
									end
								end)
							end)
						end)
					end
				)
			end)
		end
	)
end)