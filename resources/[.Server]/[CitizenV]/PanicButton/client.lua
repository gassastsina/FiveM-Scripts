----------------------------------------
----------------------------------------
----    File : client.lua 			----
----    Author : gassastsina		----
----	Side : client 				----
----    Description : Panic Button 	----
----------------------------------------
----------------------------------------

--------------------------------------------ESX----------------------------------------------------------
local PlayerData 	= {}
ESX                	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
   	PlayerData.job = job
end)

--------------------------------------------main---------------------------------------------------------
local sender = false
Citizen.CreateThread(function()
   	while true do
   		Wait(10)
   		if IsControlJustPressed(1, 56) then
			if PlayerData.job.name == 'police' then
                local myPos = GetEntityCoords(GetPlayerPed(-1))
		        TriggerServerEvent("PanicButton:Code99", 'GPS: ' .. myPos.x .. ', ' .. myPos.y)
		        sender = true
				TriggerServerEvent('logs:write', "A activé le Panic Button")
		        Wait(7000)
		    end
      	end
   end
end)


RegisterNetEvent('PanicButton:notification')
AddEventHandler('PanicButton:notification', function(name, coords)
	SetNotificationTextEntry("STRING");
	AddTextComponentString("Un Panic Button a été déclenché, toutes les unités doivent répondre en Code 3");
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "Code 99", name, "Un Panic Button a été déclenché, toutes les unités doivent répondre en Code 3");
	DrawNotification(true, false)
    
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = "PanicButton",
        transactionVolume   = 0.4
    })
    Wait(360)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = "PanicButton",
        transactionVolume   = 0.4
    })
    Wait(360)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = "PanicButton",
        transactionVolume   = 0.4
    })

	if not sender then
		SetNewWaypoint(coords.x, coords.y)
	end
	sender = false
end)