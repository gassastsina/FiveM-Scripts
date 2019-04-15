------------------------------------------------
------------------------------------------------
----    File : circulation.lua 				----
----    Author: gassastsina					----
----	Side : client 						----
----	Description : Bloque la circulation ----
------------------------------------------------
------------------------------------------------

--------------------------------------------ESX----------------------------------------------------------
ESX                             = nil
local PlayerData                = {}

Citizen.CreateThread(function()
  while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(10)
  end
end)

----------------------------------------circulation------------------------------------------------------
RegisterNetEvent('circulation:stopMenu')
AddEventHandler('circulation:stopMenu', function()
	ESX.TriggerServerCallback('circulation:getStopList', function(stopList)
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'circulation',
			{
				title    = 'Circulation',
				align    = 'top-left',
				elements = {
					{label = 'Bloquer la circulation', value = 'stop'},
					{label = 'Routes bloquées ('..#stopList..')', value = 'stop_list'}
				},
			},
			function(data2, menu2)

				if data2.current.value == 'stop' then
					local coords = GetEntityCoords(GetPlayerPed(-1), false)
					TriggerServerEvent('circulation:addStop', coords.x, coords.y, coords.z, GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)))
					TriggerEvent('esx:showNotification', 'Vous venez de bloquer la rue à la circulation')
					TriggerEvent('circulation:stopMenu')
				
				elseif data2.current.value == 'stop_list' then
					stopListMenu()
				end

			end,
			function(data2, menu2)
				menu2.close()
			end
		)
	end)
end)

function stopListMenu()
	local elements = {}
	ESX.TriggerServerCallback('circulation:getStopList', function(stopList)
		for i=0, #stopList, 1 do
			if stopList[i] ~= nil then
				table.insert(elements, {label = stopList[i].street, value = i})
			end
		end
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'stop_list',
			{
				title    = 'Routes bloquées ('..#stopList..')',
				align    = 'top-left',
				elements = elements,
			},
			function(data3, menu3)

				TriggerServerEvent('circulation:removeStop', data3.current.value)
				stopListMenu()

			end,
			function(data3, menu3)
				menu3.close()
			end
		)
	end)
end

local circulationStop = {}
RegisterNetEvent('circulation:ClearArea')
AddEventHandler('circulation:ClearArea', function(list)
	circulationStop = list
	if circulationStop == nil then
		clearArea(coords)
	end
end)


Citizen.CreateThread(function()
	clearArea()
end)
function clearArea(coords)
	while circulationStop ~= nil do
		Wait(10)
		for i=1, #circulationStop, 1 do
			ClearAreaOfVehicles(circulationStop[i].x, circulationStop[i].y, circulationStop[i].z, Config.Circulation.ClearAreaRadius, false, false, false, false, false)
			ClearAreaOfPeds(circulationStop[i].x, circulationStop[i].y, circulationStop[i].z, Config.Circulation.ClearAreaRadius)
		end
	end
end