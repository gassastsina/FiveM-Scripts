ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)




function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	Wait(1500)
	while true do
		Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'etat' then
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			if GetDistanceBetweenCoords(coord, 107.41, -743.84, 242.152, true) < 1 then
				--if PlayerData.job.name == 'etat' and PlayerData.job.grade_name == 'boss' then
						DisplayHelpText("appuyer sur  ~INPUT_CONTEXT~ pour ouvrir le coffre")
		  			if IsControlJustPressed(0, 38) then
		  				roomMenu()
		  			end
				--end
			end
		--elseif PlayerData.job.name ~= nil then
			--break
		--end
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
-------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	Wait(1500)
	while true do
		Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
		--if PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack' then
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			DrawMarker(1, 1218.826,-1266.92, 36.423 -1 , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.3001, 255, 255, 0,165, 0, 0, 0,0)
			if GetDistanceBetweenCoords(coord, 1218.826,-1266.92, 36.423, true) < 1 then
				--if PlayerData.job.name == 'lumberjack' and PlayerData.job.grade_name == 'boss' then
						DisplayHelpText("appuyer sur  ~INPUT_CONTEXT~ pour ouvrir le coffre")
		  			if IsControlJustPressed(0, 38) then
		  				roomMenubucheron()
		  			end
				--end
			end
		--elseif PlayerData.job.name ~= nil then
			--break
		--end
		end
	end
end)

function roomMenubucheron()

	local elements = {}

	table.insert(elements, {label = 'Retirer argent société', value = 'withdraw_society_money'})
	table.insert(elements, {label = 'Déposer argent ',        value = 'deposit_money'})
	table.insert(elements, {label = 'Déposer items',				  value = 'put_stock'})
	table.insert(elements, {label = 'Prendre items', 				  value = 'get_stock'})	
    	

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'bucheron_actions',
		{
			title    = 'Bucheron',
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			
			if data.current.value == 'put_stock' then
        		OpenPutStocksMenubu()
      		end

      		if data.current.value == 'get_stock' then
        		OpenGetStocksMenubu()
      		end

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
							TriggerServerEvent('esx_society:withdrawMoney', 'lumberjack', amount)
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
							TriggerServerEvent('esx_society:depositMoney', 'lumberjack', amount)
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

function OpenGetStocksMenubu()

  ESX.TriggerServerCallback('esx_lumberjack:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Bucheron Stock',
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = ('Quantité')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(('Quantité invalide'))
            else
              menu2.close()
              menu.close()
              --OpenGetStocksMenu()

              TriggerServerEvent('esx_lumberjack:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenubu()

  ESX.TriggerServerCallback('esx_lumberjack:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = ('Inventaire'),
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = ('Quantité')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(('Quantité invalide'))
            else
              menu2.close()
              menu.close()
              --OpenPutStocksMenu()

              TriggerServerEvent('esx_lumberjack:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

---------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	Wait(1500)
	while true do
		Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'fuel' then
		--if PlayerData.job ~= nil and PlayerData.job.name == 'fuel' then
			local coord = GetEntityCoords(GetPlayerPed(-1), true)
			DrawMarker(1, 977.043,-103.026,74.845 -1 , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.3001, 255, 255, 0,165, 0, 0, 0,0)
			if GetDistanceBetweenCoords(coord, 977.043,-103.026,74.845, true) < 1 then
				--if PlayerData.job.name == 'fuel' and PlayerData.job.grade_name == 'boss' then
						DisplayHelpText("appuyer sur  ~INPUT_CONTEXT~ pour ouvrir le coffre")
		  			if IsControlJustPressed(0, 38) then
		  				roomMenuFuel()
		  			end
				--end
			end
		--elseif PlayerData.job.name ~= nil then
			--break
		--end
		end
	end
end)

function roomMenuFuel()

	local elements = {}

	table.insert(elements, {label = 'Retirer argent société', 		  value = 'withdraw_society_money'})
	table.insert(elements, {label = 'Déposer argent ',        		  value = 'deposit_money'})
	table.insert(elements, {label = 'Déposer items',				  value = 'put_stock'})
	table.insert(elements, {label = 'Prendre items', 				  value = 'get_stock'})	
    	

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fuel_actions',
		{
			title    = 'Raffineur',
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			
			if data.current.value == 'put_stock' then
        		OpenPutStocksMenufuel()
      		end

      		if data.current.value == 'get_stock' then
        		OpenGetStocksMenufuel()
      		end
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
							TriggerServerEvent('esx_society:withdrawMoney', 'fuel', amount)
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
							TriggerServerEvent('esx_society:depositMoney', 'fuel', amount)
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

function OpenGetStocksMenufuel()

  ESX.TriggerServerCallback('esx_fuel:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Raffineur Stock',
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = ('Quantité')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(('Quantité invalide'))
            else
              menu2.close()
              menu.close()
              --OpenGetStocksMenu()

              TriggerServerEvent('esx_fuel:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenufuel()

  ESX.TriggerServerCallback('esx_fuel:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = ('Inventaire'),
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = ('Quantité')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(('Quantité invalide'))
            else
              menu2.close()
              menu.close()
              --OpenPutStocksMenu()

              TriggerServerEvent('esx_fuel:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end
--------------------


