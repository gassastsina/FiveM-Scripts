--------------------------------------------------------------
--------------------------------------------------------------
----    File : tracker.lua                           	  ----
----    Author : gassastsina                			  ----
----	Side : server 									  ----
----    Description : Balises sur les véhicules de police ----
--------------------------------------------------------------
--------------------------------------------------------------

--------------------------------------------ESX----------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

------------------------------------------tracker--------------------------------------------------------
local Bliptab = {}
RegisterServerEvent('tracker:sendVehicle')
AddEventHandler('tracker:sendVehicle', function(vehicleX, vehicleY, vehicleZ, plate, type, VehicleDriveable)
	if VehicleDriveable then
		local alreadyGet = false
		for i = 0, #Bliptab, 1 do
			if not alreadyGet then
				if Bliptab[i] ~= nil then
					if Bliptab[i].plate == plate then
						Bliptab[i].x = vehicleX
						Bliptab[i].y = vehicleY
						Bliptab[i].z = vehicleZ
						alreadyGet = true
						break
					end
				end
				if i == #Bliptab and not alreadyGet then
					table.insert(Bliptab, {x=vehicleX, y=vehicleY, z=vehicleZ, plate=plate, type=type})
				end
			end
		end
	end
	TriggerClientEvent('tracker:callbackVehicles', source, Bliptab)
end)

RegisterServerEvent('tracker:removeVehicle')
AddEventHandler('tracker:removeVehicle', function(plate)
	for i=1, #Bliptab, 1 do
		if Bliptab[i].plate == plate then
			table.remove(Bliptab, i)
			local xPlayers = ESX.GetPlayers()
			for i=1, #xPlayers, 1 do
				if ESX.GetPlayerFromId(xPlayers[i]).job.name == 'police' then
					TriggerClientEvent('tracker:callbackVehicles', xPlayers[i], Bliptab)
				end
			end
			break
		end
	end
end)