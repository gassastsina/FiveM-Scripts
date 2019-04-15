-------------------------------------------------------------
-------------------------------------------------------------
----    File : client.lua       		   				 ----
----    Author : gassastsina    		   				 ----
----    Side : client         			   				 ----
----    Description : Player spawn with switch animation ----
-------------------------------------------------------------
-------------------------------------------------------------

Citizen.CreateThread(function()
	TriggerServerEvent('PlayerSpawn:getPlayerReSpawnCoords')
end)

local spawned = false
AddEventHandler('PlayerSpawn:SwitchPlayerAnimation', function()
	spawned = true
end)

local loaded = false
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    loaded = true
end)

RegisterNetEvent('PlayerSpawn:getPlayerReSpawnCoords')
AddEventHandler('PlayerSpawn:getPlayerReSpawnCoords', function(position)
	RequestModel(-835930287)
	while not HasModelLoaded(-835930287) do
		Wait(500)
	end
	local ped = CreatePed(1, -835930287, -75.0, -820.0, 500.0, true, true)
	SetEntityAsMissionEntity(ped, false, false)
	SetEntityVisible(ped, false, false)
	FreezeEntityPosition(ped, true)

	local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)
	SetCamRot(cam, -90.0, 0.0, 0.0, true)
	SetCamCoord(cam, -75.0, -820.0, 1500.0)
	SetCamFov(cam, 110.0)
	SetEntityHeading(GetPlayerPed(-1), 0.0)

	while not spawned do
		Wait(1)
	end

	TriggerEvent('esx:ShowHUD', false, 0.0)
	DoScreenFadeIn(3000)
	Wait(6000)
	while not loaded do
		Wait(200)
	end
	local coords = GetEntityCoords(GetPlayerPed(-1), false)
	if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, position.x, position.y, position.z, false) < 20.0 then
		SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z, 0.0, 0.0, 0.0, false)
	end
	if position.heading ~= nil then
		SetEntityHeading(GetPlayerPed(-1), position.heading)
	end
	StartPlayerSwitch(ped, GetPlayerPed(-1), 0, GetIdealPlayerSwitchType(-75.0, -820.0, 3000.0, position.x, position.y, position.z))
	
	Wait(4000)
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
	SetEntityVisible(GetPlayerPed(-1), true)
	while IsPlayerSwitchInProgress() do
		Wait(100)
	end
	DeleteEntity(ped)
	SetEntityAsNoLongerNeeded(ped)
	TriggerEvent('esx:ShowHUD', true, 1.0)
end)