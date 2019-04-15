-----------------------------------------
-----------------------------------------
----    File : server.lua            ----
----    Author : gassastsina         ----
----    Side : server          		 ----
----    Description : Alerte tempête ----
-----------------------------------------
-----------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
function checkreboot()
	local date_local = os.date('%H:%M:%S', os.time())
	if date_local == '07:25:00' or date_local == '19:25:00' then
		TriggerClientEvent('reboot:startRain', -1)
	elseif date_local == '07:36:00' or date_local == '19:36:00' then
		TriggerClientEvent('reboot:startThunder', -1)
	elseif date_local == '07:40:00' or date_local == '19:40:00' then
		TriggerClientEvent('reboot:startThunder', -1)
		TriggerClientEvent('reboot:startAlarm', -1)
	elseif date_local == '07:45:00' or date_local == '19:45:00' then
		TriggerClientEvent('cnn:WeazelNewsStart', -1, 'ALERTE TEMPÊTE, veuillez suivre les procédures')

	elseif date_local == '07:50:00' or date_local == '19:50:00' then
		TriggerClientEvent('esx:showNotification', -1, "~r~Le serveur reboot automatiquement dans 10 minutes !")
	elseif date_local == '07:55:00' or date_local == '19:55:00' then
		TriggerClientEvent('esx:showNotification', -1, "~r~Le serveur reboot automatiquement dans 5 minutes  ! Pensez à vous déconnecter !")
	elseif date_local == '07:59:40' or date_local == '19:59:40' then
		ESX.SavePlayers()
	end
end

function restart_server()
	SetTimeout(1000, function()
		checkreboot()
		restart_server()
	end)
end
restart_server()

RegisterNetEvent('reboot:checkStatus')
AddEventHandler('reboot:checkStatus', function()
	local heure = os.date('%H', os.time())
	if heure == '07' or heure == '19' then
		local minute = tonumber(os.date('%M', os.time()))
		if minute >= 30 then
			TriggerClientEvent('reboot:startThunder', source)
			if minute >= 35 then
				TriggerClientEvent('reboot:startAlarm', source)
			end
		else
			TriggerClientEvent('reboot:startRain', -1)
		end
		Wait(45000)
		TriggerClientEvent('cnn:WeazelNewsStart', source, 'Alerte tempete veuillez suivre les procedures respectivent')
	end
end)