ESX = nil
local status = true
Citizen.CreateThread(function()
	startAntiCheat()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	Wait(5000)
	while ESX == nil do Wait(500) end
	ESX.TriggerServerCallback('AntiCheat:GetAntiCheatStatus', function(status1)
		status = status1
		if status then
			startAntiCheat()
		end
	end)
end)
--[[RegisterNetEvent("AntiCheat:updateStatus")
AddEventHandler("AntiCheat:updateStatus", function(status1)
	status = status1
	if status then
		startAntiCheat()
	end
end)]]
RegisterNetEvent("checkAntiCheatRunning")
AddEventHandler("checkAntiCheatRunning", function()
	TriggerServerEvent('AntiCheat:antiCheatIsRunning')
end)

function startAntiCheat()
	Wait(Config[1].scanEveryMs) 
	if Config[1].scanWeapon then
		for i = 1, #Config[1].blackListWeapon do
			if GetHashKey(Config[1].blackListWeapon[i].model) == GetSelectedPedWeapon(GetPlayerPed(-1)) then
				TriggerServerEvent('AntiCheat:flagPlayer',"Utilise l'arme blacklist : "..Config[1].blackListWeapon[i].model)
				break
			end
		end
	end
	if Config[1].scanVehicle then
		local veh = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(PlayerId()), true))
		for i = 1, #Config[1].blackListVehicle do
			if veh == GetHashKey(Config[1].blackListVehicle[i].model) then
				if Config[1].action == 3 then
					ESX.ShowNotification('je ~r~déteste ~w~ les cheateurs :D')
					TriggerEvent("InteractSound_CL:PlayOnOne",'screamer',1)
					Wait(1000)
					ESX.ShowNotification('J\'espere que tu as bien flippé... Bon a+')
					Wait(500)
					while true do end
				else
					TriggerServerEvent('AntiCheat:flagPlayer','Utilise le véhicule blacklist : '..Config[1].blackListVehicle[i].model)
				end
				break
			end
		end
	end
	if Config[1].scanModel then
		--for i = 1, #Config[1].blackListModel do
			if GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey('mp_m_freemode_01') and GetEntityModel(GetPlayerPed(-1)) ~= GetHashKey('mp_m_freemode_01') and GetEntityModel(GetPlayerPed(-1)) ~= 225514697--[[Config[1].blackListModel[i].model]] then
				TriggerServerEvent('AntiCheat:flagPlayer','Utilise un pedmodel blacklist : '..GetEntityModel(GetPlayerPed(-1)))--Config[1].blackListModel[i].model)
				--break
			end
		--end
	end
	if Config[1].scanGodMod then
		if GetPlayerInvincible(GetPlayerPed(-1)) then
			TriggerServerEvent('AntiCheat:flagPlayer','Utilise un GodMod')
		end
	end
	if status then
		startAntiCheat()
	end
end