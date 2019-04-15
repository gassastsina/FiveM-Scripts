-----------------------------------------
-----------------------------------------
----    File : client.lua       	 ----
----    Author: gassastsina     	 ----
----	Side : client 		 		 ----
----    Description : Vehicle loader ----
-----------------------------------------
-----------------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	Wait(30000)
  	TriggerServerEvent('vehiclesLoader:getVehicles')
end)

RegisterNetEvent('vehiclesLoader:loadVehicles')
AddEventHandler('vehiclesLoader:loadVehicles', function(vehicles)
  	for i=1, #Config.Vehicles, 1 do
  		table.insert(vehicles, GetHashKey(Config.Vehicles[i]))
  	end
	Wait(30000)
  	for i=1, #vehicles, 1 do
    	RequestModel(vehicles[i])
    	while not HasModelLoaded(vehicles[i]) do
    		Wait(1000)
    	end
    	Wait(3000)
    end
end)