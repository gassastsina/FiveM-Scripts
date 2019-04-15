
ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local spawnpoint = {
    {x = -1045.040,y = -2732.138,z = 20.169},
    {x = 334.226,y = -949.978,z = 29.553},
    {x = 234.809,y = -751.805,z = 30.825},
    {x = -373.199,y = -88.190,z = 45.663},
    {x = -1508.473,y = -432.004,z = 35.446},
    {x = -892.374,y = -349.415,z = 35.534},
    {x = -805.025,y = 707.507,z = 146.700},
    {x = -809.168,y = 370.482,z = 87.876},
    {x = -1237.122,y = 477.890,z = 92.734},
    {x = 1.777,y = 542.691,z = 174.464},
    {x = 339.858,y = 484.417,z = 150.719},
    {x = 217.736,y = -171.044,z = 56.321},
    {x = 352.070,y = -1467.244,z = 29.281},
    {x = -297.969,y = -990.199,z = 31.080},
    {x = -1107.189,y = -1692.767,z = 4.374},
    {x = 229.986,y = -1542.252,z = 29.412}
}

local velib = false
local veh = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
--BLIP
Citizen.CreateThread(function()
	for i = 1 , #spawnpoint, 1 do		
		local blip = AddBlipForCoord(spawnpoint[i].x,spawnpoint[i].y,spawnpoint[i].z)
		SetBlipSprite (blip, 226)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 63)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vélib")
		EndTextCommandSetBlipName(blip)
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		for i = 1 , #spawnpoint ,1 do
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			DrawMarker(1, spawnpoint[i].x,spawnpoint[i].y,spawnpoint[i].z -1 , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.3001, 255, 255, 0,165, 0, 0, 0,0)
			if GetDistanceBetweenCoords(coord, spawnpoint[i].x,spawnpoint[i].y,spawnpoint[i].z, false) < 5 then
				if velib == false then
					DisplayHelpText("appuyez sur ~INPUT_CONTEXT~ pour prendre un velib")
					if IsControlJustPressed(0, Keys['E'])  then
						take_velib(i)
					end
				elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
					DisplayHelpText("appuyez sur ~INPUT_CONTEXT~ pour rendre le velib")
					if IsControlJustPressed(0, Keys['E'])  then
						delet_velib(coord)
					end
				end
			end
		end

	end
end)
--function
function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function take_velib(value)
		local value = value
		local elements = {}
		table.insert(elements, {label = 'BMX (50$ et 100$ de caution)',             					value = "bmx"})
		table.insert(elements, {label = 'VTT (50$ et 100$ de caution)',             					value = "Scorcher"})
		table.insert(elements, {label = 'BICYCLETTE (50$ et 100$ de caution)',             					value = "Cruiser"})
		table.insert(elements, {label = 'VELO DE COURSE (50$ et 100$ de caution)',             					value = "Fixter"})
		ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'velib_menu',
	    {
		    title    = 'Velib',
			elements = elements
	    },
		function(data, menu)
			TriggerServerEvent('esx_velib:TakeVelib')
			local model = GetHashKey(data.current.value)
			RequestModel(model)
			Citizen.CreateThread(function()
					while not HasModelLoaded(model) do
						Wait(1)
						end
					end)
						ESX.Game.SpawnVehicle(data.current.value, {x = spawnpoint[value].x, y = spawnpoint[value].y, z = spawnpoint[value].z}, 90.0, function(vehicle1)
						end)
						veh = vehicle1
						--local vehicle = CreateVehicle(model,{x = coord.x, y = coord.y, z = coord.z}, 90.0, true, false)
						velib = true
						SetEntityAsMissionEntity(veh, true, true)
						menu.close()
		end,
		function(data, menu)
			menu.close()
		end)
	
end
function delet_velib(coord)
	local ped = GetPlayerPed( -1 )
	local vehicle   = GetVehiclePedIsIn(ped,  false)
	if GetDistanceBetweenCoords(coord, GetEntityCoords(veh, true),false) and IsPedInVehicle(ped, vehicle, false) then
		TriggerServerEvent('esx_velib:rentedVehicle')
		deleteCar( vehicle )
		SetEntityAsNoLongerNeeded(vehicle)
		ESX.ShowNotification("Vous avez récupéré la caution")
		velib = false
	end
end


function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end
