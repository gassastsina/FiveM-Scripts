----------------------------------------
----------------------------------------
----    File : main.lua       		----
----    Edited by : gassastsina    	----
----    Side : client         		----
----    Description : Gang handcuff	----
----------------------------------------
----------------------------------------

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

local IsHandcuffed = false
RegisterNetEvent('esx_itemillegal:serflex')
AddEventHandler('esx_itemillegal:serflex', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')
      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      --FreezeEntityPosition(playerPed,  false)

    else
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      --FreezeEntityPosition(playerPed, false)
    end
end)

RegisterNetEvent('esx_itemillegal:cutting_pince')
AddEventHandler('esx_itemillegal:cutting_pince', function()

	IsHandcuffed    = not IsHandcuffed;
	local playerPed = GetPlayerPed(-1)

	if IsHandcuffed then
	  
	  RequestAnimDict('mp_arresting')
	  while not HasAnimDictLoaded('mp_arresting') do
	    Wait(100)
	  end
	  
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
		SetEnableHandcuffs(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, false)
		--FreezeEntityPosition(playerPed, false)

	else
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed,  true)
		--FreezeEntityPosition(playerPed, false)
	end
end)

RegisterNetEvent('esx_itemillegal:getClosestPlayer')
AddEventHandler('esx_itemillegal:getClosestPlayer', function(item)
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3.0 then
    	TriggerServerEvent('esx_itemillegal:handcuff', GetPlayerServerId(player), item)
    else
		ESX.ShowNotification(_U('no_players_nearby'))
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(40)
		local coords = GetEntityCoords(GetPlayerPed(-1), true)
		if Vdist(Config.Store.x, Config.Store.y, Config.Store.z, coords.x, coords.y, coords.z)	< 2.0 then
			SetTextComponentFormat('STRING')
            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour marchander")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(0, 38) then
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choice_item',
                    {
	                    title    = 'Marchand',
	                    elements = Config.StoreMenu,
                    },
                    function(data, menu)
            			TriggerServerEvent('esx_itemillegal:buyItem', data.current.item)
                    end,
                    function(data, menu)
                        menu.close()
                    end
                )
            end
		end
	end
end)