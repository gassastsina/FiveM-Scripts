----------------------------------------
----------------------------------------
----    File : server.lua       	----
----    Edited by : gassastsina    	----
----    Side : server         		----
----    Description : Hold up bank 	----
----------------------------------------
----------------------------------------

local rob = false
local robbers = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdupbank:toofar')
AddEventHandler('esx_holdupbank:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
			TriggerClientEvent('esx_holdupbank:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('esx_holdupbank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled') .. Banks[robb].nameofbank)
	end
	Banks[robb].NumberOfRobbingPlayers = 0
end)

local function SignalPolice(bank)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		if ESX.GetPlayerFromId(xPlayers[i]).job.name == 'police' then
			TriggerClientEvent('esx_holdupbank:setblip', xPlayers[i], bank.position, bank.nameofbank)
		end
	end
end

local function RobBank(robb, _source)
	if Banks[robb] then
		local bank = Banks[robb]

		if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('already_robbed') .. (1800 - (os.time() - bank.lastrobbed)) .. _U('seconds'))
			return
		end

		if not rob then
			rob = true
			SignalPolice(bank)

			local time = os.date()
			TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob') .. bank.nameofbank .. _U('do_not_move'))

			if not bank.AlarmHacked then
				if robb ~= "blainecounty" then
		    		TriggerClientEvent("alarm:PlayWithinDistance", -1, Config.AlarmDistance, "burglarbell", bank.position)
		    	else
		    		TriggerClientEvent('esx_holdupbank:setBlaineCountyAlarm', -1, true)
		    	end
		    end
			TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))
			TriggerClientEvent('esx:showNotification', _source, _U('hold_pos'))
			TriggerClientEvent('esx_holdupbank:currentlyrobbing', _source, robb)
			bank.lastrobbed = os.time()
			robbers[_source] = robb
			local savedSource = _source
			TriggerEvent('logs:write', 'Braque la banque '..bank.nameofbank, _source)
			SetTimeout(bank.robberyTime, function()

				if(robbers[savedSource])then
					rob = false
					TriggerClientEvent('esx_holdupbank:robberycomplete', savedSource, job)
					TriggerEvent('esx_holdupbank:alarmStop')

					ESX.GetPlayerFromId(_source).addAccountMoney('black_money', bank.reward)
					local xPlayers = ESX.GetPlayers()
					for i=1, #xPlayers, 1 do
						local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.job.name == 'police' then
							TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at') .. bank.nameofbank)
							TriggerClientEvent('esx_holdupbank:killblip', xPlayers[i])
						end
					end
					bank.NumberOfRobbingPlayers = 0
				end
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end

local function robChecker(source, selectedBank)
	local bank = Banks[selectedBank]
	local alreadyRobbed = false
	if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then
		TriggerClientEvent('esx:showNotification', source, 'Une tentative de braquage a déjà été faite sur cette banque')
		TriggerClientEvent('esx:showNotification', source, 'Le coffre a été mit en sécurité')
		TriggerClientEvent('esx:showNotification', source, _U('already_robbed') .. (1800 - (os.time() - bank.lastrobbed)) .. _U('seconds'))
		alreadyRobbed = true
	else
		ESX.GetPlayerFromId(source).removeInventoryItem('drill', 1)
		RobBank(selectedBank, source)
	end
end

RegisterServerEvent('esx_holdupbank:copsChecker')
AddEventHandler('esx_holdupbank:copsChecker', function(bank)
	local cops = 0
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end

	local ConfigBank = Banks[bank]
	if cops >= ConfigBank.NumberOfCopsRequired then
		if ESX.GetPlayerFromId(source).getInventoryItem('drill').count > 0 then
			robChecker(source, bank)
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Pour braquer cette banque vous devez avoir une perceuse")
		end
	else
		TriggerClientEvent('esx:showNotification', source, 'Pour braquer cette banque il faut minimum "..ConfigBank.NumberOfCopsRequired.." policiers')
	end
end)

RegisterServerEvent('esx_holdupbank:alreadyRobbed')
AddEventHandler('esx_holdupbank:alreadyRobbed', function(bank)
	Banks[bank].lastrobbed = os.time()
end)

RegisterServerEvent('esx_holdupbank:alarmStop')
AddEventHandler('esx_holdupbank:alarmStop', function()
	TriggerClientEvent('alarm:stop', -1)
end)

ESX.RegisterServerCallback('esx_holdupbank:canHackAlarm', function(source, cb, bank)
	cb(ESX.GetPlayerFromId(source).getInventoryItem('hack_phone').count, Banks[bank].AlarmHacked)
end)

RegisterServerEvent('esx_holdupbank:IsAlarmHacked')
AddEventHandler('esx_holdupbank:IsAlarmHacked', function(bank, success)
	ESX.GetPlayerFromId(source).removeInventoryItem('hack_phone', 1)
	if success then
		Banks[bank].AlarmHacked = true
		Wait(Banks[bank].AlarmHackedTimeBeforeCallPolice)
	end
	if robb ~= "blainecounty" then
		TriggerClientEvent("alarm:PlayWithinDistance", -1, Config.AlarmDistance, "burglarbell", Banks[bank].position)
	else
		TriggerClientEvent('esx_holdupbank:setBlaineCountyAlarm', -1, true)
	end
	SignalPolice(Banks[bank])
end)

RegisterServerEvent('esx_holdupbank:stopBlaineCountyAlarm')
AddEventHandler('esx_holdupbank:stopBlaineCountyAlarm', function()
	TriggerClientEvent('esx_holdupbank:setBlaineCountyAlarm', -1, false)
end)