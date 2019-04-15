----------------------------------------
----------------------------------------
----    File : client.lua       	----
----    Edited by : gassastsina    	----
----    Side : client         		----
----    Description : Hold up bank 	----
----------------------------------------
----------------------------------------

local holdingup = false
local bank = ""
local secondsRemaining = 0
local blipRobbery = nil
local bool = false
local selectedBank = nil

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

local PlayerData = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local function hack(success)
    TriggerEvent('mhacking:hide')
    if success then
        TriggerEvent('esx:showNotification', "Le déchiffrage de l'alarme est valide !")
	else
        TriggerEvent('esx:showNotification', 'Le déchiffrage a échoué !')
    end
    TriggerServerEvent('esx_holdupbank:IsAlarmHacked', selectedBank, success)
	selectedBank = nil
end

RegisterNetEvent('esx_holdupbank:currentlyrobbing')
AddEventHandler('esx_holdupbank:currentlyrobbing', function(robb)
	holdingup = true
	bank = robb
	secondsRemaining = 600
end)

RegisterNetEvent('esx_holdupbank:killblip')
AddEventHandler('esx_holdupbank:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdupbank:setblip')
AddEventHandler('esx_holdupbank:setblip', function(position, bank)
	SetNotificationTextEntry("STRING");
	AddTextComponentString("L'alarme vient de se déclancher");
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "Braquage de banque", bank, "L'alarme vient de se déclancher");
	DrawNotification(true, false)

    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdupbank:toofarlocal')
AddEventHandler('esx_holdupbank:toofarlocal', function()
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	bool = false
	TriggerServerEvent('esx_holdupbank:alarmStop')
end)

RegisterNetEvent('esx_holdupbank:robberycomplete')
AddEventHandler('esx_holdupbank:robberycomplete', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete') .. Banks[bank].reward)
	bank = ""
	secondsRemaining = 0
	bool = false
	ClearPedTasks(GetPlayerPed(PlayerId(-1)))
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Banks)do
		local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
		SetBlipSprite(blip, 255)--156
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 75)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('bank_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	local alreadyHack = false
	Wait(3000)
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(Banks)do

			if Vdist(pos.x, pos.y, pos.z, v.position.x, v.position.y, v.position.z) < 15.0 then
				if not holdingup then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, v.position.x, v.position.y, v.position.z) < 1.0)then
						if PlayerData.job.name ~= 'police' then
							DisplayHelpText(_U('press_to_rob') .. v.nameofbank)
						else
							DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour désactiver l'alarme de la banque " .. v.nameofbank)
						end
						if IsControlJustReleased(0, 38) then
							if PlayerData.job.name ~= 'police' then
								TriggerServerEvent('esx_holdupbank:copsChecker', k)
								bool = true
							else
								if k == "blainecounty" then
									TriggerEvent('esx_holdupbank:alarmStop')
								else
									TriggerServerEvent('esx_holdupbank:stopBlaineCountyAlarm')
								end
							end
						end
					end
				end
			end

			if not alreadyHack and Vdist(pos.x, pos.y, pos.z, v.Alarm.x, v.Alarm.y, v.Alarm.z) < 15.0 then
				if not holdingup then
					if(Vdist(pos.x, pos.y, pos.z, v.Alarm.x, v.Alarm.y, v.Alarm.z) < 1.0)then
						if PlayerData.job.name ~= 'police' then
							ESX.TriggerServerCallback('esx_holdupbank:canHackAlarm', function(quantity, alreadyHacked)
								if quantity > 0 and not alreadyHacked then
									DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour pirater l'alarme de la banque ~b~" .. v.nameofbank)
									if IsControlJustReleased(0, 38) then
										incircle = true
										selectedBank = k
										TriggerEvent("mhacking:show")
										TriggerEvent("mhacking:start", 4, 20, hack)
										alreadyHack = true
									end
								end
							end, k)
						end
					end
				end
			end
		end

		if holdingup then

			drawTxt(0.70, 1.44, 1.0,1.0,0.4, _U('robbery_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)

			local pos2 = Banks[bank].position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > Banks[bank].robberyDistance)then
				TriggerServerEvent('esx_holdupbank:toofar', bank)
			end
			if bool then
				TaskStartScenarioInPlace(GetPlayerPed(PlayerId()), "WORLD_HUMAN_WELDING", 0, false)
				bool = false
			elseif IsControlJustPressed(0, 32) or IsControlJustPressed(0, 8) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 9) then
				--ClearPedTasks(GetPlayerPed(PlayerId()))
				--SetPedToRagdoll(GetPlayerPed(PlayerId()), 1, 1, 2, true, true, false)
			end
		end

		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx_holdupbank:setBlaineCountyAlarm')
AddEventHandler('esx_holdupbank:setBlaineCountyAlarm', function(alarm)
	if alarm then
		while not PrepareAlarm("PALETO_BAY_SCORE_ALARM") do
			Citizen.Wait(1000)
		end
		StartAlarm("PALETO_BAY_SCORE_ALARM", true)
	else
		StopAlarm("PALETO_BAY_SCORE_ALARM", true)
	end
end)