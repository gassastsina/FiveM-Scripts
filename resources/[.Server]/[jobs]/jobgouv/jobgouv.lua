ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	Wait(1500)
	while true do
		Wait(0)
		if PlayerData.job.name == 'etat' then
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			if GetDistanceBetweenCoords(coord, 107.41, -743.84, 242.152, true) < 1 then
				if PlayerData.job.name == 'etat' and PlayerData.job.grade_name == 'boss' then
						DisplayHelpText("appuyer sur  ~INPUT_CONTEXT~ pour ouvrir le coffre")
		  			if IsControlJustPressed(0, 38) then
		  				roomMenu()
		  			end
				end
			end
		elseif PlayerData.job.name ~= nil then
			break
		end
	end
end)

function roomMenu()

	local elements = {}

	table.insert(elements, {label = 'Retirer argent société', value = 'withdraw_society_money'})
	table.insert(elements, {label = 'Déposer argent ',        value = 'deposit_money'})

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'patriot_actions',
		{
			title    = 'Président',
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			

			if data.current.value == 'withdraw_society_money' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'withdraw_society_money_amount',
					{
						title = 'Montant du retrait'
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
						else
							menu.close()
							TriggerServerEvent('esx_society:withdrawMoney', 'etat', amount)
						end
					end,
					function(data, menu)
						menu.close()
					end
				)
			end

			if data.current.value == 'deposit_money' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'deposit_money_amount',
					{
						title = 'Montant du dépôt'
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
						else
							menu.close()
							TriggerServerEvent('esx_society:depositMoney', 'etat', amount)
						end
					end,
					function(data, menu)
						menu.close()
					end
				)
			end	
	
		end,
		function(data, menu)
				menu.close()
		end

	)

end