------------------------------------
------------------------------------
----    File : client.lua   	----
----    Edited by : gassastsina	----
----	Side : client 			----
----    Description : Menu 		----
------------------------------------
------------------------------------

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
local key = {}
ESX = nil
local GUI                       = {}
GUI.Time                        = 0
local PlayerData              = {}
local inAnim = false
local selfie = 0
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)
RegisterNetEvent("esx:returnkey")
AddEventHandler("esx:returnkey",function (newkey)
	local i = #key
	local duplicatekey = false
	while i>=0 do
		Wait(0)
		if newkey == key[i] then
			duplicatekey = true
			break
		end
		i = i -1
	end
	if duplicatekey == false then
		table.insert(key,newkey)
		TriggerEvent('esx:showNotification', "Vous avez recu une clé de voiture ("..newkey..")")
		TriggerEvent('giveKeyAtKeyMaster', newkey)
	end
end)
AddEventHandler('esx_key:giveVehiclesKey', function(plate)
	local x  = #plate
	TriggerEvent('esx:showNotification', plate[x])
	table.insert(key, plate[x])
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(50)
    end
end)

function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end


function GiveKeyAtPlayer(key) -- j'crois que ca marche mais j'suis solo donc j'peu pas test
	local key = key
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local closestPlayer1 = (GetPlayerServerId(closestPlayer))
	if closestPlayer ~= nil and key ~= nil and closestDistance < 3.0 then
		TriggerServerEvent('esx:givekey', closestPlayer1, key)
		ESX.ShowNotification('Vous avez donné des clés')
	else
		ESX.ShowNotification('Aucun joueur à proximité')
	end				
end

local function SearchBodyMenu()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance < 1.5 then
		ESX.TriggerServerCallback('menu:getOtherPlayerData', function(data)
			local elements = {}
			local blackMoney = 0

			for i=1, #data.accounts, 1 do
			  if data.accounts[i].name == 'black_money' then
				blackMoney = data.accounts[i].money
			  end
			end

			table.insert(elements, {
			  label          = 'Argent sale : ' .. blackMoney..'$',
			  value          = 'black_money',
			  itemType       = 'item_account',
			  amount         = blackMoney
			})

			table.insert(elements, {label = '<span style="color:red;">==== Armes ====</span>', value = nil})

			for i=1, #data.weapons, 1 do
			  table.insert(elements, {
				label          = ESX.GetWeaponLabel(data.weapons[i].name),
				value          = data.weapons[i].name,
				itemType       = 'item_weapon',
				amount         = data.ammo
			  })
			end

			table.insert(elements, {label = '<span style="color:green;">=== Inventaire ===</span>', value = nil})

			for i=1, #data.inventory, 1 do
			  if data.inventory[i].count > 0 then
				table.insert(elements, {
				  label          = data.inventory[i].count .. 'x ' .. data.inventory[i].label,
				  value          = data.inventory[i].name,
				  itemType       = 'item_standard',
				  amount         = data.inventory[i].count
				})
			  end
			end

			TriggerServerEvent('menu:warnSearchingBody', GetPlayerServerId(player))
			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'body_search',
			  {
				title    = 'Fouille',
				elements = elements,
			  },
			  function(data, menu)

				local itemType = data.current.itemType
				local itemName = data.current.value
				local amount   = data.current.amount

				if data.current.value ~= nil then
				  TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				  OpenBodySearchMenu(player)
				end

			  end,
			  function(data, menu)
				menu.close()
			  end
			)

		end, GetPlayerServerId(player))
	else
		TriggerEvent('esx:showNotification', "~r~Aucun joueur trouvé à proximité")
	end
end

local function CivilMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'donuts_machine_menu', {
			title    = 'Civil',
			elements = {
				{label = "Fouiller une personne", value = 'search_body'}
			},
		},
		function(data, menu)
			if data.current.value == 'search_body' then
				SearchBodyMenu()
			end
		end,
		function(data, menu)
		  menu.close()
		end
	)
end

function OpenPersonnelMenu()
	ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group

		local elements = {}

		if PlayerData.job ~= nil then
			if PlayerData.job.name == 'police'  then
				table.insert(elements, {label = 'LSPD', value = 'menuperso_police'})
			
			elseif PlayerData.job.name == 'ambulance'  then
				table.insert(elements, {label = 'EMS', value = 'menuperso_medic'})
		    
		    elseif PlayerData.job.name == 'mecano'  then
				table.insert(elements, {label = 'Mecano', value = 'menuperso_mecano'})
			
			elseif PlayerData.job.name == 'reporter'  then
				table.insert(elements, {label = 'Journaliste', value = 'menuperso_journaliste'})
			
			elseif PlayerData.job.name == 'foodtruck'  then
				table.insert(elements, {label = 'Salvatoré', value = 'menuperso_foodtruck'})
			
			elseif PlayerData.job.name == 'lospolloshermanos'  then
				table.insert(elements, {label = 'Los Pollos Hermanos', value = 'menuperso_lospolloshermanos'})
			
			elseif PlayerData.job.name == 'sap'  then
				table.insert(elements, {label = 'San Andreas Petrol', value = 'menuperso_sap'})
			end


------------------------------------------------------------------------------------------
			if (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh') then
				table.insert(elements, {label = 'Gestion des employés', value = 'menuperso_grade'})
			end
		end
------------------------------------------------------------------------------------------
	
		table.insert(elements, {label = 'Inventaire', value = 'menuperso_moi_inventaire'})
		table.insert(elements, {label = 'Animations', value = 'menuperso_actions'})
		table.insert(elements, {label = 'Mes papiers', value = 'menuperso_moi_papiers'})
		table.insert(elements, {label = 'Tenue', value = 'menuperso_tenue'})
		if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' then
			table.insert(elements, {label = 'Civil', value = 'menuperso_civil'})
		end
		table.insert(elements, {label = 'Accessoires', value = 'menuperso_accessories'})
		table.insert(elements, {label = 'Clé de voiture', value = 'menuperso_carkey'})
		
		if playergroup == 'mod' or playergroup == 'admin' or playergroup == 'superadmin' or playergroup =='_dev' then
			table.insert(elements, {label = 'Modération', value = 'menuperso_modo'})
		end
		
			GUI.Time = GetGameTimer()
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'menu_perso',
			{
				title    = 'Menu Personnel',
				elements = elements
			},
			function(data, menu)
				if data.current.value == 'menuperso_police' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuPolice')
				end
			   	if data.current.value == 'menuperso_mecano' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuMecano')
				end

				if data.current.value == 'menuperso_civil' then
					CivilMenu()
				end

				if data.current.value == 'menuperso_banker' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuBanker')
				end

				if data.current.value == 'menuperso_medic' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuAmbulance')
				end
				if data.current.value == 'menuperso_tenue' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openTenueMenu')
				end
				if data.current.value == 'menuperso_foodtruck' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuFoodtruck')
				end
				if data.current.value == 'menuperso_lospolloshermanos' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuLosPollosHermanos')
				end
				if data.current.value == 'menuperso_journaliste' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerEvent('nb:openMenuReporter')
				end
				if data.current.value == 'menuperso_sap' then
						TriggerEvent('nb:closeAllSubMenu')
						TriggerEvent('nb:closeAllMenu')
						TriggerServerEvent('nb:openMenuSAP')
				end

				local elements = {}
				ESX.TriggerServerCallback('menu:GetPlayerIdentifier', function(identifier)
				
					if playergroup == 'mod' then
						table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
						table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
						--table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
						--table.insert(elements, {label = 'No Clip',										value = 'menuperso_modo_no_clip'})
						--table.insert(elements, {label = 'GodMode',									value = 'menuperso_modo_godmode'})
						--table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
						--table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
						--table.insert(elements, {label = 'Spawn véhicule',							value = 'menuperso_modo_vehicle_spawn'})
						--table.insert(elements, {label = 'Flip véhicule',								value = 'menuperso_modo_vehicle_flip'})
						-- table.insert(elements, {label = 'Se give des $ argent',						value = 'menuperso_modo_give_money'})
						-- table.insert(elements, {label = 'Se give des $ en banque',						value = 'menuperso_modo_give_moneybank'})
						-- table.insert(elements, {label = 'Se give des $ argent sale',						value = 'menuperso_modo_give_moneydirty'})
						table.insert(elements, {label = 'Afficher/Cacher Coordonnées',		value = 'menuperso_modo_showcoord'})
						table.insert(elements, {label = 'Afficher/Cacher nom des joueurs',	value = 'menuperso_modo_showname'})
						--table.insert(elements, {label = 'TP sur le marker',							value = 'menuperso_modo_tp_marcker'})
						--table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
						--table.insert(elements, {label = 'Spéc la personne [WIP]',						value = 'menuperso_modo_spec_player'})
						table.insert(elements, {label = 'Changer Skin',									value = 'menuperso_modo_changer_skin'})
						--table.insert(elements, {label = 'Save Skin',									value = 'menuperso_modo_save_skin'})
					end
				
					if playergroup == 'admin' then
						table.insert(elements, {label = 'TP sur le marker',							value = 'menuperso_modo_tp_marcker'})
						table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
						table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
						--table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
						table.insert(elements, {label = 'No Clip',										value = 'menuperso_modo_no_clip'})
						table.insert(elements, {label = 'GodMode',									value = 'menuperso_modo_godmode'})
						table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
						table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
						table.insert(elements, {label = 'Spawn véhicule',							value = 'menuperso_modo_vehicle_spawn'})
						table.insert(elements, {label = 'Flip véhicule',								value = 'menuperso_modo_vehicle_flip'})
						table.insert(elements, {label = 'Se give des $ argent',						value = 'menuperso_modo_give_money'})
						table.insert(elements, {label = 'Se give des $ en banque',						value = 'menuperso_modo_give_moneybank'})
						table.insert(elements, {label = 'Se give des $ argent sale',						value = 'menuperso_modo_give_moneydirty'})
						table.insert(elements, {label = 'Afficher/Cacher Coordonnées',		value = 'menuperso_modo_showcoord'})
						table.insert(elements, {label = 'Afficher/Cacher nom des joueurs',	value = 'menuperso_modo_showname'})				
						table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
						--table.insert(elements, {label = 'Spéc la personne [WIP]',						value = 'menuperso_modo_spec_player'})
						table.insert(elements, {label = 'Changer Skin',									value = 'menuperso_modo_changer_skin'})
						table.insert(elements, {label = 'Save Skin',									value = 'menuperso_modo_save_skin'})
					end
				
					if playergroup == 'superadmin' or playergroup == '_dev' then
						table.insert(elements, {label = 'TP sur le marker',							value = 'menuperso_modo_tp_marcker'})
						table.insert(elements, {label = 'Afficher/Cacher Coordonnées',		value = 'menuperso_modo_showcoord'})
						table.insert(elements, {label = 'Afficher/Cacher nom des joueurs',	value = 'menuperso_modo_showname'})
						table.insert(elements, {label = 'No Clip',										value = 'menuperso_modo_no_clip'})
						table.insert(elements, {label = 'GodMode',									value = 'menuperso_modo_godmode'})
						table.insert(elements, {label = 'Mode fantôme',								value = 'menuperso_modo_mode_fantome'})
						table.insert(elements, {label = 'TP sur joueur',    							value = 'menuperso_modo_tp_toplayer'})
						table.insert(elements, {label = 'TP joueur sur moi',             			value = 'menuperso_modo_tp_playertome'})
						table.insert(elements, {label = 'TP sur coordonées [WIP]',						value = 'menuperso_modo_tp_pos'})
						table.insert(elements, {label = 'Réparer véhicule',							value = 'menuperso_modo_vehicle_repair'})
						table.insert(elements, {label = 'Spawn véhicule',							value = 'menuperso_modo_vehicle_spawn'})
						table.insert(elements, {label = 'Flip véhicule',								value = 'menuperso_modo_vehicle_flip'})
						table.insert(elements, {label = 'Se give des $ argent',						value = 'menuperso_modo_give_money'})
						table.insert(elements, {label = 'Se give des $ en banque',						value = 'menuperso_modo_give_moneybank'})
						table.insert(elements, {label = 'Se give des $ argent sale',						value = 'menuperso_modo_give_moneydirty'})
						table.insert(elements, {label = 'Soigner la personne',					value = 'menuperso_modo_heal_player'})
						table.insert(elements, {label = 'Spéc la personne [WIP]',						value = 'menuperso_modo_spec_player'})
						table.insert(elements, {label = 'Changer Skin',									value = 'menuperso_modo_changer_skin'})
						table.insert(elements, {label = 'Save Skin',									value = 'menuperso_modo_save_skin'})
					end

					if data.current.value == 'menuperso_modo' then
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'menuperso_modo',
							{
								title    = 'Modération',
								elements = elements
							},
							function(data2, menu2)

								if data2.current.value == 'menuperso_modo_tp_toplayer' then
									admin_tp_toplayer()
								end

								if data2.current.value == 'menuperso_modo_tp_playertome' then
									admin_tp_playertome()
								end

								if data2.current.value == 'menuperso_modo_tp_pos' then
									admin_tp_pos()
								end

								if data2.current.value == 'menuperso_modo_no_clip' then
									admin_no_clip()
								end

								if data2.current.value == 'menuperso_modo_godmode' then
									admin_godmode()
								end

								if data2.current.value == 'menuperso_modo_mode_fantome' then
									admin_mode_fantome()
								end

								if data2.current.value == 'menuperso_modo_vehicle_repair' then
									admin_vehicle_repair()
								end

								if data2.current.value == 'menuperso_modo_vehicle_spawn' then
									admin_vehicle_spawn()
								end

								if data2.current.value == 'menuperso_modo_vehicle_flip' then
									admin_vehicle_flip()
								end

								if data2.current.value == 'menuperso_modo_give_money' then
									admin_give_money()
								end

								if data2.current.value == 'menuperso_modo_give_moneybank' then
									admin_give_bank()
								end

								if data2.current.value == 'menuperso_modo_give_moneydirty' then
									admin_give_dirty()
								end

								if data2.current.value == 'menuperso_modo_showcoord' then
									modo_showcoord()
								end

								if data2.current.value == 'menuperso_modo_showname' then
									modo_showname()
								end

								if data2.current.value == 'menuperso_modo_tp_marcker' then
									admin_tp_marcker()
								end

								if data2.current.value == 'menuperso_modo_heal_player' then
									admin_heal_player()
								end

								if data2.current.value == 'menuperso_modo_spec_player' then
									admin_spec_player()
								end

								if data2.current.value == 'menuperso_modo_changer_skin' then
									changer_skin()
								end
								
							end,
							function(data2, menu2)
								menu2.close()
							end
						)
					end
				end)
				if data.current.value == 'menuperso_carkey' then
					local elements1 = {}
					local x = 0
					while x <= #key do
						if key[x] ~= nil then
							table.insert(elements1, {label = 'Clé de voiture ('..key[x]..')',  value = 'menuperso_key'..key[x]})
						end
						x = x +1
					end
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_key',
						{
							title    = 'Vos clés',
							--align    = 'top-left',
							elements = elements1	

						},
						function(data2, menu2)
							for i=0, #key, 1 do
								if key[i] ~= nil then
								    if data2.current.value == 'menuperso_key'..key[i] then
								  		GiveKeyAtPlayer(key[i])
								     end
								end
							end

						end,
						function(data2, menu2)
							menu2.close()
						end
						
					)
				end

				if data.current.value == 'menuperso_actions' then

					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_actions',
						{
							title    = 'Animation',
							--align    = 'top-left',
							elements = {
								--{label = 'Annuler animation',  value = 'menuperso_actions__annuler'},
								{label = 'Divers',  value = 'menuperso_actions_Others'},
								{label = 'Travails',  value = 'menuperso_actions_Travail'},
								{label = 'Saluts',  value = 'menuperso_actions_Salute'},
								{label = 'Humeurs',  value = 'menuperso_actions_Humor'},
								{label = 'Festives',  value = 'menuperso_actions_Festives'},
								{label = 'Démarche',  value = 'menuperso_actions_demarche'},
								
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_actions__annuler' then
								local ped = GetPlayerPed(-1);
								if ped then
									ClearPedTasks(ped);
								end
							end

							if data2.current.value == 'menuperso_actions_Salute' then
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'menuperso_actions_Salute',
									{
										title    = 'Animations de salutations',
										--align    = 'top-left',
										elements = {
											{label = 'Saluer',  value = 'menuperso_actions_Salute_saluer'},
											--{label = '',     value = ''},
											{label = 'Serrer la main',     value = 'menuperso_actions_Salute_serrerlamain'},
											--{label = '',     value = ''},
											{label = 'Tape m\'en 5',     value = 'menuperso_actions_Salute_tapeen5'},
											--{label = '',     value = ''},
											{label = 'Salut militaire Americain',  value = 'menuperso_actions_Salute_salutmilitaire'},
											--{label = '',     value = ''},
											{label = 'Tchek',     value = 'menuperso_actions_Salute_tchek'},
											--{label = '',     value = ''},
											{label = 'Salut Bandit',     value = 'menuperso_actions_Salute_salutbandit'},
										},
									},
									function(data3, menu3)

										if data3.current.value == 'menuperso_actions_Salute_saluer' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_hello" })
										end

										if data3.current.value == 'menuperso_actions_Salute_serrerlamain' then
											inAnim = true
											animsAction({ lib = "mp_common", anim = "givetake1_a" })
										end

										if data3.current.value == 'menuperso_actions_Salute_tapeen5' then
											inAnim = true
											animsAction({ lib = "mp_ped_interaction", anim = "highfive_guy_a" })
										end

										if data3.current.value == 'menuperso_actions_Salute_salutmilitaire' then
											inAnim = true
											animsAction({ lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute" })
										end

										if data3.current.value == 'menuperso_actions_Salute_tchek' then
											inAnim = true
											animsAction({ lib = "mp_ped_interaction", anim = "handshake_guy_a" })
										end

										if data3.current.value == 'menuperso_actions_Salute_salutbandit' then
											inAnim = true
											animsAction({ lib = "mp_ped_interaction", anim = "hugs_guy_a" })
										end

									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_actions_Humor' then
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'menuperso_actions_Humor',
									{
										title    = 'Animation d\'Humeurs',
										--align    = 'top-left',
										elements = {
											{label = 'Facepalm',  value = 'menuperso_actions_Humor_facepalm'},
											--{label = '',     value = ''},
											{label = 'Féliciter',  value = 'menuperso_actions_Humor_feliciter'},
											--{label = '',     value = ''},
											{label = 'Doigt d\'honneur',  value = 'menuperso_actions_Humor_doightdhonneur'},
											--{label = '',     value = ''},
											{label = 'Super',     value = 'menuperso_actions_Humor_super'},
											--{label = '',     value = ''},
											{label = 'On se bat ?',  value = 'menuperso_actions_Humor_bat'},
											--{label = '',     value = ''},
											{label = 'Calme-toi',     value = 'menuperso_actions_Humor_calmetoi'},
											--{label = '',     value = ''},
											{label = 'Avoir peur',  value = 'menuperso_actions_Humor_avoirpeur'},
											--{label = '',     value = ''},
											{label = 'C\'est pas possible !',  value = 'menuperso_actions_Humor_cestpaspossible'},
											--{label = '',     value = ''},
											{label = 'Enlacer',  value = 'menuperso_actions_Humor_enlacer'},
											--{label = '',     value = ''},
											{label = 'Branleur',  value = 'menuperso_actions_Humor_branleur'},
											--{label = '',     value = ''},
											{label = 'Balle dans la tête',  value = 'menuperso_actions_Humor_balledanslatete'},
											--{label = '',     value = ''},
											{label = 'Jouer de la musique',  value = 'menuperso_actions_Humor_jouerdelamusique'},
											--{label = '',     value = ''},
											{label = 'Toi',  value = 'menuperso_actions_Humor_toi'},
											--{label = '',     value = ''},
											{label = 'Viens',     value = 'menuperso_actions_Humor_viens'},
											--{label = '',     value = ''},
											{label = 'Qu\'est ce qui a ?',     value = 'menuperso_actions_Humor_mais'},
											--{label = '',     value = ''},
											{label = 'A moi',  value = 'menuperso_actions_Humor_amoi'},
											--{label = '',     value = ''},
											{label = 'Je le savais, putain',  value = 'menuperso_actions_Humor_putain'},
											--{label = '',     value = ''},
											{label = 'Mais qu\'est ce que j\'ai fait ?',  value = 'menuperso_actions_Humor_fait'},
										},
									},
									function(data3, menu3)

										if data3.current.value == 'menuperso_actions_Humor_feliciter' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_CHEERING" })
										end

										if data3.current.value == 'menuperso_actions_Humor_super' then
											inAnim = true
											animsAction({ lib = "anim@mp_player_intcelebrationmale@thumbs_up", anim = "thumbs_up" })
										end

										if data3.current.value == 'menuperso_actions_Humor_calmetoi' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_easy_now" })
										end

										if data3.current.value == 'menuperso_actions_Humor_avoirpeur' then
											inAnim = true
											animsAction({ lib = "amb@code_human_cower_stand@female@idle_a", anim = "idle_c" })
										end

										if data3.current.value == 'menuperso_actions_Humor_cestpaspossible' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_damn" })
										end

										if data3.current.value == 'menuperso_actions_Humor_enlacer' then
											inAnim = true
											animsAction({ lib = "mp_ped_interaction", anim = "kisses_guy_a" })
										end

										if data3.current.value == 'menuperso_actions_Humor_doightdhonneur' then
											inAnim = true
											animsAction({ lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter" })
										end

										if data3.current.value == 'menuperso_actions_Humor_branleur' then
											inAnim = true
											animsAction({ lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01" })
										end

										if data3.current.value == 'menuperso_actions_Humor_balledanslatete' then
											inAnim = true
											animsAction({ lib = "mp_suicide", anim = "pistol" })
										end

										if data3.current.value == 'menuperso_actions_Humor_jouerdelamusique' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_MUSICIAN" })
										end

										if data3.current.value == 'menuperso_actions_Humor_toi' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_point" })
										end

										if data3.current.value == 'menuperso_actions_Humor_viens' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft" })
										end

										if data3.current.value == 'menuperso_actions_Humor_mais' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on" })
										end

										if data3.current.value == 'menuperso_actions_Humor_amoi' then
											inAnim = true
											animsAction({ lib = "gestures@m@standing@casual", anim = "gesture_me" })
										end

										if data3.current.value == 'menuperso_actions_Humor_putain' then
											inAnim = true
											animsAction({ lib = "anim@am_hold_up@male", anim = "shoplift_high" })
										end

										if data3.current.value == 'menuperso_actions_Humor_facepalm' then
											inAnim = true
											animsAction({ lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm" })
										end

										if data3.current.value == 'menuperso_actions_Humor_fait' then
											inAnim = true
											animsAction({ lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a" })
										end

										if data3.current.value == 'menuperso_actions_Humor_bat' then
											inAnim = true
											animsAction({ lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e" })
										end

									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end
							
							if data2.current.value == 'menuperso_actions_demarche' then
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'menuperso_actions_demarche',
									{
										title    = 'Démarche',
										--align    = 'top-left',
										elements = {
											{label = "Reset", value = 'menuperso_actions_Humor_Reset'},

											{label = "Normal M", value = 'menuperso_actions_Humor_Normalm'},
											--{label = '',     value = ''},
											{label = "Normal F", value = 'menuperso_actions_Humor_Normalf'},
											--{label = '',     value = ''},
											{label = "Depressif", value = 'menuperso_actions_Humor_depressif'},
											--{label = '',     value = ''},
											{label = "Business",value = 'menuperso_actions_Humor_business'},
											--{label = '',     value = ''},
											{label = "Casual",  value = 'menuperso_actions_Humor_casual'},
											--{label = '',     value = ''},
											{label = "Trop mange",  value = 'menuperso_actions_Humor_manger'},
											--{label = '',     value = ''},
											{label = "Hipster",  value = 'menuperso_actions_Humor_hipster'},
											--{label = '',     value = ''},
											{label = "Blesse", value = 'menuperso_actions_Humor_Blesse'},
											--{label = '',     value = ''},
											{label = "Intimide", value = 'menuperso_actions_Humor_Intimide'},
											--{label = '',     value = ''},
											{label = "Hobo", value = 'menuperso_actions_Humor_hobo'},
											--{label = '',     value = ''},
											{label = "Malheureux", value = 'menuperso_actions_Humor_malheureux'},
											--{label = '',     value = ''},
											{label = "Muscle",   value = 'menuperso_actions_Humor_muscle'},
											--{label = '',     value = ''},
											{label = "Choc",  value = 'menuperso_actions_Humor_choc'},
											--{label = '',     value = ''},
											{label = "Sombre",  value = 'menuperso_actions_Humor_sombre'},
											--{label = '',     value = ''},
											{label = "Fatigue", value = 'menuperso_actions_Humor_fatigue'},
											--{label = '',     value = ''},
											{label = "Pressee",  value = 'menuperso_actions_Humor_pressee'},
											--{label = '',     value = ''},
											{label = "Fier", value = 'menuperso_actions_Humor_fier'},
											--{label = '',     value = ''},
											{label = "Petite course",  value = 'menuperso_actions_Humor_run'},
											--{label = '',     value = ''},
											{label = "Impertinent",  value = 'menuperso_actions_Humor_inpertinent'},
											--{label = '',     value = ''},
											{label = "Arrogante", value = 'menuperso_actions_Humor_arrogante'},
										
										},
									},

									function(data3, menu3)

										if data3.current.value == 'menuperso_actions_Humor_Reset' then
											ResetPedMovementClipset(GetPlayerPed(-1), 0)
										end

										if data3.current.value == 'menuperso_actions_Humor_Normalm' then
											startAttitude({lib = "move_m@confident", anim = "move_m@confident"})
										end

										if data3.current.value == 'menuperso_actions_Humor_Normalf' then
											startAttitude({lib = "move_f@heels@c", anim = "move_f@heels@c"})
										end

										if data3.current.value == 'menuperso_actions_Humor_depressif' then
											startAttitude({lib = "move_m@depressed@a", anim = "move_m@depressed@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_business' then
											startAttitude({lib = "move_m@business@a", anim = "move_m@business@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_casual' then
											startAttitude({lib = "move_m@casual@a", anim = "move_m@casual@a"})
										end


										if data3.current.value == 'menuperso_actions_Humor_manger' then
											startAttitude({lib = "move_m@fat@a", anim = "move_m@fat@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_hipster' then
											startAttitude({lib = "move_m@hipster@a", anim = "move_m@hipster@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_Blesse' then
											startAttitude({lib = "move_m@injured", anim = "move_m@injured"})
										end

										if data3.current.value == 'menuperso_actions_Humor_Intimide' then
											startAttitude({lib = "move_m@hurry@a", anim = "move_m@hurry@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_hobo' then
											startAttitude({lib = "move_m@hobo@a", anim = "move_m@hobo@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_malheureux' then
											startAttitude({lib = "move_m@sad@a", anim = "move_m@sad@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_muscle' then
											startAttitude({lib = "move_m@muscle@a", anim = "move_m@muscle@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_choc' then
											startAttitude({lib = "move_m@shocked@a", anim = "move_m@shocked@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_sombre' then
											startAttitude({lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_fatigue' then
											startAttitude({lib = "move_m@buzzed", anim = "move_m@buzzed"})
										end

										if data3.current.value == 'menuperso_actions_Humor_pressee' then
											startAttitude({lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"})
										end

										if data3.current.value == 'menuperso_actions_Humor_fier' then
											startAttitude({lib = "move_m@money", anim = "move_m@money"})
										end

										if data3.current.value == 'menuperso_actions_Humor_run' then
											startAttitude({lib = "move_m@quick", anim = "move_m@quick"})
										end

										if data3.current.value == 'menuperso_actions_Humor_inpertinent' then
											startAttitude({lib = "move_f@sassy", anim = "move_f@sassy"})
										end

										if data3.current.value == 'menuperso_actions_Humor_arrogante' then
											startAttitude({lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"})
										end

									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_actions_Travail' then
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'menuperso_actions_Travail',
									{
										title    = 'Animations de travail',
										elements = {
											{label = 'Tenir sa ceinture',     value = 'menuperso_actions_Travail_ceinture'},
											{label = 'Garde du corps',     value = 'menuperso_actions_Guard_Stand'},
											{label = 'Prendre des notes',  value = 'menuperso_actions_Travail_prendredesnotes'},
											--{label = 'Pêcheur',  value = 'menuperso_actions_Travail_pecheur'},
											{label = 'Préparer à manger',  value = 'menuperso_actions_Others_mangerrrrrrr'},
											--{label = '',     value = ''},
											{label = 'Agriculteur',     value = 'menuperso_actions_Travail_agriculteur'},
											--{label = '',     value = ''},
											--{label = 'Dépanneur',     value = 'menuperso_actions_Travail_depanneur'},
											--{label = '',     value = ''},
											--{label = '',     value = ''},
											{label = 'Inspecter',  value = 'menuperso_actions_Travail_inspecter'},
											--{label = '',     value = ''},
											--{label = 'Se rendre à la police',  value = 'menuperso_actions_Travail_serendrealapolice'},
											--{label = '',     value = ''},
											--{label = 'Réparer sous le véhicule',     value = 'menuperso_actions_Travail_reparersouslevehicule'},
											--{label = '',     value = ''},
											--{label = 'Réparer le moteur',     value = 'menuperso_actions_Travail_reparerlemoteur'},
											--{label = '',     value = ''},
											{label = 'Enquêter',  value = 'menuperso_actions_Travail_enqueter'},
											--{label = '',     value = ''},
											{label = 'Parler à la radio',  value = 'menuperso_actions_Travail_parleralaradio'},
											--{label = '',     value = ''},
											{label = 'Faire la circulation',  value = 'menuperso_actions_Travail_fairelacirculation'},
											--{label = '',     value = ''},
											{label = 'Tenir un ballet',  value = 'menuperso_actions_Janitor'},
											--{label = '',     value = ''},
											{label = 'Observer la personne à terre',     value = 'menuperso_actions_Travail_persoaterre'},
											{label = 'Calmer la foule',     value = 'menuperso_actions_Police_Crowd_Control'},
											--{label = '',     value = ''},
											{label = 'Parler au client',  value = 'menuperso_actions_Travail_parlerauclient'},
											--{label = '',     value = ''},
											{label = 'Donner une facture au client',  value = 'menuperso_actions_Travail_factureclient'},
											--{label = '',     value = ''},
											{label = 'Donner les courses',  value = 'menuperso_actions_Travail_lescourses'},
											--{label = '',     value = ''},
											{label = 'Servir un shot',     value = 'menuperso_actions_Travail_shot'},
											--{label = '',     value = ''},
											{label = 'Coup de marteau',  value = 'menuperso_actions_Travail_marteauabomberleverre'},
										},
									},
									function(data3, menu3)

										if data3.current.value == 'menuperso_actions_Travail_ceinture' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_COP_IDLES" })
										end

										if data3.current.value == 'menuperso_actions_Others_mangerrrrrrr' then
											inAnim = true
											animsActionScenario({ anim = "PROP_HUMAN_BBQ" })
										end

										if data3.current.value == 'menuperso_actions_Janitor' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_JANITOR" })
										end

										if data3.current.value == 'menuperso_actions_Guard_Stand' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_GUARD_STAND" })
										end

										if data3.current.value == 'menuperso_actions_Travail_agriculteur' then
											inAnim = true
											animsActionScenario({anim = "world_human_gardener_plant" })
										end

										if data3.current.value == 'menuperso_actions_Travail_depanneur' then
											inAnim = true
											animsActionScenario({anim = "world_human_vehicle_mechanic" })
										end

										if data3.current.value == 'menuperso_actions_Travail_prendredesnotes' then
											ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
												inAnim = true
												if skin.sex == 0 then
													animsActionScenario({anim = "WORLD_HUMAN_CLIPBOARD" })
												else
													animsActionScenario({anim = "CODE_HUMAN_MEDIC_TIME_OF_DEATH" })
												end
											end)
										end

										if data3.current.value == 'menuperso_actions_Travail_inspecter' then
											inAnim = true
											animsActionScenario({anim = "CODE_HUMAN_MEDIC_KNEEL" })
										end

										if data3.current.value == 'menuperso_actions_Travail_serendrealapolice' then
											inAnim = true
											animsAction({ lib = "random@arrests@busted", anim = "idle_c" })
										end

										if data3.current.value == 'menuperso_actions_Travail_reparersouslevehicule' then
											inAnim = true
											animsActionScenario({anim = "world_human_vehicle_mechanic" })
										end

										if data3.current.value == 'menuperso_actions_Travail_reparerlemoteur' then
											inAnim = true
											animsAction({ lib = "mini@repair", anim = "fixing_a_ped" })
										end

										if data3.current.value == 'menuperso_actions_Travail_enqueter' then
											inAnim = true
											animsAction({ lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f" })
										end

										if data3.current.value == 'menuperso_actions_Travail_parleralaradio' then
											inAnim = true
											animsAction({ lib = "random@arrests", anim = "generic_radio_chatter" })
										end

										if data3.current.value == 'menuperso_actions_Travail_fairelacirculation' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT" })
										end

										if data3.current.value == 'menuperso_actions_Travail_jumelles' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_BINOCULARS" })
										end

										if data3.current.value == 'menuperso_actions_Travail_persoaterre' then
											inAnim = true
											animsActionScenario({anim = "CODE_HUMAN_MEDIC_KNEEL" })
										end

										if data3.current.value == 'menuperso_actions_Police_Crowd_Control' then
											inAnim = true
											animsActionScenario({anim = "CODE_HUMAN_POLICE_CROWD_CONTROL" })
										end

										if data3.current.value == 'menuperso_actions_Travail_parlerauclient' then
											inAnim = true
											animsAction({ lib = "oddjobs@taxi@driver", anim = "leanover_idle" })
										end

										if data3.current.value == 'menuperso_actions_Travail_factureclient' then
											inAnim = true
											animsAction({ lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger" })
										end

										if data3.current.value == 'menuperso_actions_Travail_lescourses' then
											inAnim = true
											animsAction({ lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper" })
										end

										if data3.current.value == 'menuperso_actions_Travail_shot' then
											inAnim = true
											animsAction({ lib = "mini@drinking", anim = "shots_barman_b" })
										end

										if data3.current.value == 'menuperso_actions_Travail_marteauabomberleverre' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_HAMMERING" })
										end

									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_actions_Festives' then
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'menuperso_actions_Festives',
									{
										title    = 'Animations festives',
										--align    = 'top-left',
										elements = {
											{label = 'Danser',  value = 'menuperso_actions_Festives_danser'},
											--{label = '',     value = ''},
											{label = 'Dance1',  value = 'menuperso_actions_Festives_dance1'},
											--{label = '',     value = ''},
											{label = 'Dance2',  value = 'menuperso_actions_Festives_dance2'},
											--{label = '',     value = ''},
											{label = 'Dance3',  value = 'menuperso_actions_Festives_dance3'},
											--{label = '',     value = ''},
											{label = 'Dance4',  value = 'menuperso_actions_Festives_dance5'},
											--{label = '',     value = ''},
											{label = 'Dance5',  value = 'menuperso_actions_Festives_dance6'},
											--{label = '',     value = ''},
											{label = 'Dance6',  value = 'menuperso_actions_Festives_dance7'},
											{label = 'Dance7',  value = 'menuperso_actions_Festives_dance11'},
											--{label = '',     value = ''},
											{label = 'Femme Dance1',  value = 'menuperso_actions_Festives_dance10'},
											--{label = '',     value = ''},
											{label = 'Femme Dance2',  value = 'menuperso_actions_Festives_dance4'},
											--{label = '',     value = ''},
											{label = 'Femme Dance3',  value = 'menuperso_actions_Festives_dance9'},
											--{label = '',     value = ''},
											{label = 'Jouer de la musique',     value = 'menuperso_actions_Festives_jouerdelamusique'},
											--{label = '',     value = ''},
											{label = 'Boire une bière',     value = 'menuperso_actions_Festives_boireunebiere'},
											--{label = '',     value = ''},
											{label = 'Air Guitar',  value = 'menuperso_actions_Festives_airguitar'},
											--{label = '',     value = ''},
											{label = 'Faire le Dj',  value = 'menuperso_actions_Festives_dj'},
											--{label = '',     value = ''},
											--{label = 'Bière en zik',  value = 'menuperso_actions_Festives_bierenzik'},
											--{label = '',     value = ''},
											{label = 'Air shagging',  value = 'menuperso_actions_Festives_airshagging'},
											--{label = '',     value = ''},
											{label = 'Rock and roll',  value = 'menuperso_actions_Festives_rockandroll'},
											--{label = '',     value = ''},
											{label = 'Bourré sur place',  value = 'menuperso_actions_Festives_bourresurplace'},
											--{label = '',     value = ''},
											{label = 'Vomir en voiture',  value = 'menuperso_actions_Festives_vomirenvoiture'},
										},
									},
									function(data3, menu3)

										if data3.current.value == 'menuperso_actions_Festives_danser' then
											inAnim = true
											animsAction({ lib = "amb@world_human_partying@female@partying_beer@base", anim = "base" })
										end

										if data3.current.value == 'menuperso_actions_Festives_jouerdelamusique' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_MUSICIAN" })
										end

										if data3.current.value == 'menuperso_actions_Festives_boireunebiere' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_DRINKING" })
										end

										if data3.current.value == 'menuperso_actions_Festives_airguitar' then
											inAnim = true
											animsAction({ lib = "anim@mp_player_intcelebrationfemale@air_guitar", anim = "air_guitar" })
										end

										if data3.current.value == 'menuperso_actions_Festives_dj' then
											inAnim = true
											animsAction({ lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj" })
										end

										if data3.current.value == 'menuperso_actions_Festives_bierenzik' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_PARTYING" })
										end

										if data3.current.value == 'menuperso_actions_Festives_airshagging' then
											inAnim = true
											animsAction({ lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging" })
										end

										if data3.current.value == 'menuperso_actions_Festives_rockandroll' then
											inAnim = true
											animsAction({ lib = "mp_player_int_upperrock", anim = "mp_player_int_rock" })
										end

										if data3.current.value == 'menuperso_actions_Festives_bourresurplace' then
											inAnim = true
											animsAction({ lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a" })
										end

										if data3.current.value == 'menuperso_actions_Festives_vomirenvoiture' then
											inAnim = true
											animsAction({ lib = "oddjobs@taxi@tie", anim = "vomit_outside" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance1' then
											inAnim = true
											animsAction({ lib = "missfbi3_sniping", anim = "dance_m_default" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance2' then
											inAnim = true
											animsAction({ lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance3' then
											inAnim = true
											animsAction({ lib = "special_ped@mountain_dancer@monologue_4@monologue_4a", anim = "mnt_dnc_verse" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance4' then
											inAnim = true
											animsAction({ lib = "mp_am_stripper", anim = "lap_dance_girl" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance5' then
											inAnim = true
											animsAction({ lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance6' then
											inAnim = true
											animsAction({ lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance7' then
											inAnim = true
											animsAction({ lib = "special_ped@mountain_dancer@monologue_1@monologue_1a", anim = "mtn_dnc_if_you_want_to_get_to_heaven" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance8' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@pole_dance@pole_dance2", anim = "pd_dance_02" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance9' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance11' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_STRIP_WATCH_STAND" })
										end
										if data3.current.value == 'menuperso_actions_Festives_dance10' then
											inAnim = true
											animsAction({ lib = "oddjobs@assassinate@multi@yachttarget@lapdance", anim = "yacht_ld_f" })
										end

									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end

							if data2.current.value == 'menuperso_actions_Others' then
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'menuperso_actions_Others',
									{
										title    = 'Animations diverses',
										--align    = 'top-left',
										elements = {
											{label = '',     value = ''},
											{label = '[R P]',     value = ''},
											{label = 'S\'asseoir par terre',     value = 'menuperso_actions_Others_sasseoirparterre'},
											{label = 'S\'asseoir sur une chaise',     value = 'menuperso_actions_Others_sasseoir'},
											--{label = 'Boire un café',  value = 'menuperso_actions_Others_boireuncafe'},
											{label = 'Attendre contre un mur',     value = 'menuperso_actions_Others_attendre'},
											{label = 'Mains sur la tête',     value = 'menuperso_actions_Others_hands_on_head'},
											{label = 'Position de fouille',     value = 'menuperso_actions_Others_positiondefouille'},
											{label = 'Écouter à la porte',  value = 'menuperso_actions_Others_fouille'},
											{label = 'Prendre un selfie',     value = 'menuperso_actions_Others_prendreunselfie'},
											{label = 'Se Coucher sur le dos',  value = 'menuperso_actions_Others_surledos'},
											{label = 'Se Coucher sur le ventre',  value = 'menuperso_actions_Others_ventre'},
											{label = 'Lever les mains',     value = 'menuperso_actions_Others_leverlesmains'},
											{label = 'Nettoyer quelque chose',     value = 'menuperso_actions_Others_nettoyerquelquechose'},
											{label = 'Se gratter les couilles',     value = 'menuperso_actions_Others_segratterlesc'},
											{label = 'Trainer dans la rue',     value = 'menuperso_actions_Hang_Out_Street'},
											{label = 'Faire la manche',     value = 'menuperso_actions_Others_manche'},
											{label = 'Faire la statue',  value = 'menuperso_actions_Others_statue'},
											{label = 'Ecouter à une porte',  value = 'menuperso_actions_Others_uneporte'},
											{label = '',     value = ''},
											{label = '[S P O R T]',     value = ''},
											{label = 'Faire des pompes',     value = 'menuperso_actions_Others_fairedespompes'},
											{label = 'Faire du yoga',     value = 'menuperso_actions_Others_faireduyoga'},
											{label = 'Faire du jogging',     value = 'menuperso_actions_Others_fairedujogging'},
											{label = 'Montrer tes muscles',     value = 'menuperso_actions_Others_fairedesetirements'},
											{label = 'Barre de musculation',  value = 'menuperso_actions_Others_muscu'},
											{label = 'Faire des pompes',  value = 'menuperso_actions_Others_pompes'},
											{label = 'Faire les abdo',  value = 'menuperso_actions_Others_crunch'},
											{label = '',     value = ''},
											--{label = '[F U M E R]',     value = ''},
											--{label = 'Fumer une clope',     value = 'menuperso_actions_Others_fumeruneclope'},
											--{label = 'Fumer un joint',  value = 'menuperso_actions_Others_fumerunjoint'},
											--{label = '',     value = ''},
											{label = '[P E G I  18+]',     value = ''},
											{label = 'Racoller',     value = 'menuperso_actions_Others_racoller'},
											{label = 'Racoller 2',     value = 'menuperso_actions_Others_racoller2'},
											{label = 'Se faire sucer en voiture',     value = 'menuperso_actions_Others_sucer'},
											{label = 'Sucer une personne en voiture',     value = 'menuperso_actions_Others_sucerune'},
											{label = 'Faire l\'amour en voiture (homme)',     value = 'menuperso_actions_Others_homme'},
											{label = 'Se faire agrandir le trou dans la voiture',     value = 'menuperso_actions_Others_letrou'},
											--{label = 'Se gratter les couilles',     value = 'menuperso_actions_Others_segratter'},
											{label = 'Faire du charme',     value = 'menuperso_actions_Others_charme'},
											{label = 'Pose Tchoin',     value = 'menuperso_actions_Others_tchoin'},
											{label = 'Montrer sa poitrine',     value = 'menuperso_actions_Others_poitrine'},
											{label = 'Strip-tease 1',     value = 'menuperso_actions_Others_strip'},
											{label = 'Strip-tease 2',     value = 'menuperso_actions_Others_tease'},
											{label = 'Strip-tease au sol',     value = 'menuperso_actions_Others_ausol'},
											{label = '',     value = ''},
											
										},
									},
									function(data3, menu3)

										if data3.current.value == 'menuperso_actions_Others_hands_on_head' then
											TriggerEvent('KneelHU')
										end

										if data3.current.value == 'menuperso_actions_Others_fumeruneclope' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_SMOKING" })
										end

										if data3.current.value == 'menuperso_actions_Others_fairedespompes' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_PUSH_UPS" })
										end

										if data3.current.value == 'menuperso_actions_Others_regarderauxjumelles' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_BINOCULARS" })
										end

										if data3.current.value == 'menuperso_actions_Others_faireduyoga' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_YOGA" })
										end

										if data3.current.value == 'menuperso_actions_Others_fairelastatut' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_HUMAN_STATUE" })
										end

										if data3.current.value == 'menuperso_actions_Others_fairedujogging' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_JOG_STANDING" })
										end

										if data3.current.value == 'menuperso_actions_Others_fairedesetirements' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_MUSCLE_FLEX" })
										end

										if data3.current.value == 'menuperso_actions_Others_racoller' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS" })
										end

										if data3.current.value == 'menuperso_actions_Others_racoller2' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS" })
										end

										if data3.current.value == 'menuperso_actions_Others_sasseoir' then
											inAnim = true
											animsAction({ lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle" })
										end

										if data3.current.value == 'menuperso_actions_Others_sasseoirparterre' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_PICNIC" })
										end

										if data3.current.value == 'menuperso_actions_Others_attendre' then
											inAnim = true
											animsActionScenario({ anim = "world_human_leaning" })
										end

										if data3.current.value == 'menuperso_actions_Others_nettoyerquelquechose' then
											inAnim = true
											animsActionScenario({ anim = "world_human_maid_clean" })
										end

										if data3.current.value == 'menuperso_actions_Others_leverlesmains' then
											inAnim = true
											animsAction({ lib = "random@mugging3", anim = "handsup_standing_base" })
										end

										if data3.current.value == 'menuperso_actions_Others_positiondefouille' then
											inAnim = true
											animsAction({ lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female" })
										end

										if data3.current.value == 'menuperso_actions_Others_segratterlesc' then
											inAnim = true
											animsAction({ lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch" })
										end

										if data3.current.value == 'menuperso_actions_Hang_Out_Street' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_HANG_OUT_STREET" })
										end

										if data3.current.value == 'menuperso_actions_Others_prendreunselfie' then
											inAnim = true
											if selfie == 0 then
												animsActionScenario({ anim = "world_human_tourist_mobile" })
												selfie = selfie + 1
											else
												animsActionScenario({anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING" })
												selfie = 0
											end
										end

										if data3.current.value == 'menuperso_actions_Others_fumerunjoint' then
											inAnim = true
											animsActionScenario({anim = "WORLD_HUMAN_SMOKING_POT" })
										end

										if data3.current.value == 'menuperso_actions_Others_manche' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_BUM_FREEWAY" })
										end

										if data3.current.value == 'menuperso_actions_Others_statue' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_HUMAN_STATUE" })
										end

										if data3.current.value == 'menuperso_actions_Others_muscu' then
											inAnim = true
											animsAction({ lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base" })
										end

										if data3.current.value == 'menuperso_actions_Others_pompes' then
											inAnim = true
											animsAction({ lib = "amb@world_human_push_ups@male@base", anim = "base" })
										end

										if data3.current.value == 'menuperso_actions_Others_crunch' then
											inAnim = true
											animsAction({ lib = "amb@world_human_sit_ups@male@base", anim = "base" })
										end

										if data3.current.value == 'menuperso_actions_Others_surledos' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_SUNBATHE_BACK" })
										end

										if data3.current.value == 'menuperso_actions_Others_ventre' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_SUNBATHE" })
										end

										if data3.current.value == 'menuperso_actions_Others_fouille' then
											inAnim = true
											animsAction({ lib = "mini@safe_cracking", anim = "idle_base" })
										end

										if data3.current.value == 'menuperso_actions_Others_prendreuncafe' then
										inAnim = true
											animsAction({ lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a" })
										end

										if data3.current.value == 'menuperso_actions_Others_sucer' then
											inAnim = true
											animsAction({ lib = "oddjobs@towing", anim = "m_blow_job_loop" })
										end

										if data3.current.value == 'menuperso_actions_Others_sucerune' then
											inAnim = true
											animsAction({ lib = "oddjobs@towing", anim = "f_blow_job_loop" })
										end

										if data3.current.value == 'menuperso_actions_Others_homme' then
											inAnim = true
											animsAction({ lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player" })
										end

										if data3.current.value == 'menuperso_actions_Others_letrou' then
											inAnim = true
											animsAction({ lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female" })
										end

										if data3.current.value == 'menuperso_actions_Others_segratter' then
											inAnim = true
											animsAction({ lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch" })
										end

										if data3.current.value == 'menuperso_actions_Others_charme' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02" })
										end

										if data3.current.value == 'menuperso_actions_Others_tchoin' then
											inAnim = true
											animsActionScenario({ anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS" })
										end

										if data3.current.value == 'menuperso_actions_Others_poitrine' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b" })
										end

										if data3.current.value == 'menuperso_actions_Others_strip' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f" })
										end

										if data3.current.value == 'menuperso_actions_Others_tease' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2" })
										end

										if data3.current.value == 'menuperso_actions_Others_ausol' then
											inAnim = true
											animsAction({ lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3" })
										end

									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end
							
							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)

				end
			    if data.current.value == 'menuperso_moi_inventaire' then
					openInventaire()
				end
				if data.current.value == 'menuperso_accessories' then
					TriggerEvent('weaponsAccessories:accessoriesMenu')
				end
				if data.current.value == 'menuperso_moi_papiers' then
					local elements = {
						{label = 'Voir mon passport', value = 'menuperso_moi_carte'},
						{label = 'Montrer mon passport', value = 'menuperso_moi_carte2'},
					}
					if PlayerData.job.name ~= "unemployed" then
						table.insert(elements, {label = 'Voir ma carte de job', value = 'menuperso_moi_carte_job'})
						table.insert(elements, {label = 'Montrer ma carte de job', value = 'menuperso_moi_carte2_job'})
					end
					table.insert(elements, {label = 'Mes factures', value = 'menuperso_moi_factures'})
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_moi',
						{
							title    = 'Mes papiers',
							elements = elements
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_moi_carte' then
								TriggerServerEvent('gc:openMeIdentity')
							
							elseif data2.current.value == 'menuperso_moi_carte2' then
								TriggerEvent('esx_gcidentity:showOtherItentity')

							elseif data2.current.value == 'menuperso_moi_carte_job' then
								TriggerServerEvent('esx_gcidentityjob:openMeIdentity')
							
							elseif data2.current.value == 'menuperso_moi_carte2_job' then
								TriggerEvent('esx_gcidentityjob:shareItentity')

							elseif data2.current.value == 'menuperso_moi_factures' then
								openFacture()
							end
				
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
				end
				if data.current.value == 'menuperso_grade' then
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'menuperso_grade',
						{
							title    = 'Grade',
							elements = {
								{label = 'Recruter',     value = 'menuperso_grade_recruter'},
								{label = 'Virer',              value = 'menuperso_grade_virer'},
								{label = 'Promouvoir', value = 'menuperso_grade_promouvoir'},
								{label = 'Destituer',  value = 'menuperso_grade_destituer'}
							},
						},
						function(data2, menu2)

							if data2.current.value == 'menuperso_grade_recruter' then
								if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh' then
									local job =  PlayerData.job.name
									local grade = 0
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.showNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('esx:recruterplayer', GetPlayerServerId(closestPlayer), job, grade)
									end

								else
									TriggerEvent('esx:showNotification', "Vous n'avez pas les ~r~droits~w~.")
								end
							end

							if data2.current.value == 'menuperso_grade_virer' then
								if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh' then
										local job =  PlayerData.job.name
										local grade = 0
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.showNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('esx:virerplayer', GetPlayerServerId(closestPlayer))
									end

								else
									TriggerEvent('esx:showNotification', "Vous n'avez pas les ~r~droits~w~.")
								end
								
							end

							if data2.current.value == 'menuperso_grade_promouvoir' then

								if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.showNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('esx:promouvoirplayer', GetPlayerServerId(closestPlayer))
									end

								else
									TriggerEvent('esx:showNotification', "Vous n'avez pas les ~r~droits~w~.")
								end
								
							end
							
							if data2.current.value == 'menuperso_grade_destituer' then

								if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'drh' then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.showNotification("Aucun joueur à proximité")
									else
										TriggerServerEvent('esx:destituerplayer', GetPlayerServerId(closestPlayer))
									end

								else
									TriggerEvent('esx:showNotification', "Vous n'avez pas les ~r~droits~w~.")
								end
								
								
							end

							
						end,
						function(data2, menu2)
							menu2.close()
						end
					)

				end
			end,
			function(data, menu)
				menu.close()
			end
		)

	end)

end

---------------------------------------------------------------------------Me concernant

function openTelephone()
	TriggerEvent('nb:closeAllSubMenu')
	TriggerEvent('nb:closeAllMenu')
	TriggerEvent('nb:openMenuTelephone')
end

function openInventaire()
	TriggerEvent('nb:closeAllSubMenu')
	TriggerEvent('nb:closeAllMenu')
	--TriggerEvent('nb:openMenuInventaire')
	ESX.ShowInventory()
end

function openFacture()
	TriggerEvent('nb:closeAllSubMenu')
	TriggerEvent('nb:closeAllMenu')
	TriggerEvent('nb:openMenuFactures')
end

---------------------------------------------------------------------------Actions

local playAnim = false
local dataAnim = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if inAnim == true then
			if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9) then
				inAnim = false
				playAnim = false
				ClearPedTasks(GetPlayerPed(-1))
				TriggerEvent('ft_animation:ClFinish')
			end
		end
	end
end)

function animsAction(animObj)

		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then -- Ckeck if ped exist
					dataAnim = animObj

					-- Play Animation
					RequestAnimDict(dataAnim.lib)
					while not HasAnimDictLoaded(dataAnim.lib) do
						Citizen.Wait(0)
					end
					if HasAnimDictLoaded(dataAnim.lib) then
						local flag = 1
						if dataAnim.loop ~= nil and dataAnim.loop then
							flag = 1
						elseif dataAnim.move ~= nil and dataAnim.move then
							flag = 49
						end

						TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
						playAnimation = true
					end

					-- Wait end annimation
					while true do
						Citizen.Wait(0)
						if inAnim == true then
							if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9) then
								inAnim = false
								playAnim = false
								ClearPedTasks(GetPlayerPed(-1))
								TriggerEvent('ft_animation:ClFinish')
								break
							end
						end
					end
				end -- end ped exist
			end
		end)
end

function startAttitude(animObj)
 	Citizen.CreateThread(function()
	
	    local playerPed = GetPlayerPed(-1)
		dataAnim = animObj
	    RequestAnimSet(dataAnim.lib)
	      
	    while not HasAnimSetLoaded(dataAnim.lib) do
	        Citizen.Wait(0)
	    end
	    SetPedMovementClipset(playerPed, dataAnim.lib, true)
	end)

end

function animsActionScenario(animObj)
	if (IsInVehicle()) then
		local source = GetPlayerServerId();
		TriggerEvent('esx:showNotification', "Sortez de votre véhicule pour faire cela !")
	else
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then
					dataAnim = animObj
					TaskStartScenarioInPlace(playerPed, dataAnim.anim, 0, true)
					playAnimation = true
				end
			end
		end)
	end
end

-- Verifie si le joueurs est dans un vehicule ou pas
function IsInVehicle()
	local ply = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

---------------------------------------------------------------------------------------------------------
--NB : Fermeture des sous menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('nb:openMenuPersonnel')
AddEventHandler('nb:openMenuPersonnel', function()
	OpenPersonnelMenu()
end)

RegisterNetEvent('nb:closeMenuPersonnel')
AddEventHandler('nb:closeMenuPersonnel', function()

	if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_moi') then
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_moi')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions') then
		if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Salute') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Salute')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Humor') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Humor')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Travail') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Travail')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Festives') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Festives')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Others') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions_Others')
		end
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_actions')
		
	elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule') then
		if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule_ouvrirportes') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_vehicule_ouvrirportes')
		elseif ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule_fermerportes') then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_vehicule_fermerportes')
		end
		ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'menuperso_vehicule')		
	end
end)

--------------------------------------------------------------------------------------------
-- NB : gestion des touches menu
--------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Wait(0)
--------------------------------------------------------------------------------------------
-- Menu personnel -> nb_menuperso
--------------------------------------------------------------------------------------------
		
		if (IsControlPressed(0,  Keys["Y"]) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuPersonnel')
			GUI.Time  = GetGameTimer()
		end
		
		if (IsControlPressed(0,  Keys["Y"]) and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time  = GetGameTimer()
		end
		
--------------------------------------- MANETTE
		
		if (IsControlPressed(1, Keys["SPACE"]) and IsControlPressed(0, Keys["TOP"]) and not ESX.UI.Menu.IsOpen('default',  GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuPersonnel')
			GUI.Time  = GetGameTimer()
		end
		
		if (IsControlPressed(1, Keys["SPACE"]) and IsControlPressed(0, Keys["TOP"]) and ESX.UI.Menu.IsOpen('default',  GetCurrentResourceName(), 'menu_perso') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time  = GetGameTimer()
		end

--------------------------------------------------------------------------------------------
-- Menu inventaire -> es_extended
--------------------------------------------------------------------------------------------

		if (IsControlPressed(1, Keys["LEFTSHIFT"]) and IsControlPressed(0, Keys["G"]) and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') and (GetGameTimer() - GUI.Time) > 150)  then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuInventaire')
			GUI.Time = GetGameTimer()
		end
		
		if (IsControlPressed(1, Keys["LEFTSHIFT"]) and IsControlPressed(0, Keys["G"]) and ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') and (GetGameTimer() - GUI.Time) > 150)  then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time  = GetGameTimer()
		end

--------------------------------------------------------------------------------------------
-- Menu telephone -> esx_phone
--------------------------------------------------------------------------------------------
		
		if (IsControlPressed(1, Keys["LEFTALT"]) and not ESX.UI.Menu.IsOpen('phone', 'esx_phone', 'main') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuTelephone')
			GUI.Time = GetGameTimer()
		end
		
		if (IsControlPressed(1, Keys["LEFTALT"]) and not ESX.UI.Menu.IsOpen('phone', 'esx_phone', 'main') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time = GetGameTimer()
		end

--------------------------------------------------------------------------------------------
-- Menu factures -> esx_billing
--------------------------------------------------------------------------------------------
		
		if (IsControlPressed(1, Keys["LEFTSHIFT"]) and IsControlPressed(0, Keys["Y"]) and not ESX.UI.Menu.IsOpen('default', 'esx_billing', 'billing') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuFactures')
			GUI.Time = GetGameTimer()
		end

		if (IsControlPressed(1, Keys["LEFTSHIFT"]) and IsControlPressed(0, Keys["Y"]) and ESX.UI.Menu.IsOpen('default', 'esx_billing', 'billing') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time = GetGameTimer()
		end

--------------------------------------------------------------------------------------------
-- Menu ambulance -> esx_ambulancejob
--------------------------------------------------------------------------------------------

		if (IsControlPressed(0, Keys["F6"]) and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and not ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'mobile_ambulance_actions') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuAmbulance')
			GUI.Time = GetGameTimer()
		end

		if (IsControlPressed(0, Keys["F6"]) and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'mobile_ambulance_actions') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time = GetGameTimer()
		end
		
--------------------------------------- MANETTE
		
		if (IsControlPressed(1, Keys["SPACE"]) and IsControlPressed(0, Keys["DOWN"]) and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and not ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'mobile_ambulance_actions') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			TriggerEvent('nb:openMenuAmbulance')
			GUI.Time  = GetGameTimer()
		end
		
		if (IsControlPressed(1, Keys["SPACE"]) and IsControlPressed(0, Keys["DOWN"]) and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' and ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'mobile_ambulance_actions') and (GetGameTimer() - GUI.Time) > 150) then
			TriggerEvent('nb:closeAllSubMenu')
			TriggerEvent('nb:closeAllMenu')
			GUI.Time  = GetGameTimer()
		end

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
	end
end)

RegisterNetEvent('nb:closeAllSubMenu')
AddEventHandler('nb:closeAllSubMenu', function()
	TriggerEvent('nb:closeMenuAmbulance')
	TriggerEvent('nb:closeMenuPolice')
	TriggerEvent('nb:closeMenuInventaire')
	TriggerEvent('nb:closeMenuPersonnel')
end)

RegisterNetEvent('nb:closeAllMenu')
AddEventHandler('nb:closeAllMenu', function()
	ESX.UI.Menu.CloseAll()
end)


---------------------------------------------------------------------------Modération


RegisterNetEvent('NB:goTpMarcker')
AddEventHandler('NB:goTpMarcker', function()
	admin_tp_marcker()
end)


function changer_skin()
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end


-- GOTO JOUEUR
function admin_tp_toplayer()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez l'id du joueur...")
	inputgoto = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputgoto == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputgoto = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputgoto = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputgoto = 0
			end
		end
		if inputgoto == 2 then
        --local x,y,z = getPosition()
		local gotoply = GetOnscreenKeyboardResult()
        --local tplayer = GetPlayerPed(GetPlayerFromServerId(id))
        --x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(gotoply) , true))
        -- x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(gotoply) , true)))
        -- SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1, 0, 0, 1)
	    local playerPed = GetPlayerPed(-1)
	    local teleportPed = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(gotoply))))
	    SetEntityCoords(playerPed, teleportPed)
		
        inputgoto = 0
		end
	end
end)
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez l'id du joueur...")
	inputteleport = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputteleport == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputteleport = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputteleport = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputteleport = 0
			end
		end
		if inputteleport == 2 then
		local teleportply = GetOnscreenKeyboardResult()
	    local playerPed = GetPlayerFromServerId(tonumber(teleportply))
	    local teleportPed = GetEntityCoords(GetPlayerPed(-1))
	    SetEntityCoords(playerPed, teleportPed)
		inputteleport = 0
		end
	end
end)
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez la position...")
	inputpos = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputpos == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputpos = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputpos = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputpos = 0
			end
		end
		if inputpos == 2 then
			local pos = GetOnscreenKeyboardResult() -- GetOnscreenKeyboardResult RECUPERE LA POSITION RENTRER PAR LE JOUEUR
			local _,_,x,y,z = string.find( pos or "0,0,0", "([%d%.]+),([%d%.]+),([%d%.]+)" )
			
			--SetEntityCoords(GetPlayerPed(-1), x, y, z)
		    SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001) -- TP LE JOUEUR A LA POSITION
			inputpos = 0
		end
	end
end)
-- FIN TP A POSITION

-- FONCTION NOCLIP 
local noclip = false
local noclip_speed = 1.0

function admin_no_clip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- activé
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, false, false)
	TriggerEvent('esx:showNotification', "Noclip ~g~activé")
  else -- désactivé
    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
	TriggerEvent('esx:showNotification', "Noclip ~r~désactivé")
  end
end

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

-- noclip/invisible
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if noclip then
      local ped = GetPlayerPed(-1)
      local x,y,z = getPosition()
      local dx,dy,dz = getCamDirection()
      local speed = noclip_speed

      -- reset du velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

      -- aller vers le haut
      if IsControlPressed(0,32) then -- MOVE UP
        x = x+speed*dx
        y = y+speed*dy
        z = z+speed*dz
      end

      -- aller vers le bas
      if IsControlPressed(0,269) then -- MOVE DOWN
        x = x-speed*dx
        y = y-speed*dy
        z = z-speed*dz
      end

      SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
    end
  end
end)
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
  godmode = not godmode
  local ped = GetPlayerPed(-1)
  
  if godmode then -- activé
		SetEntityInvincible(GetPlayerPed(-1), true)
		TriggerEvent('esx:showNotification', "GodMode ~g~activé")
	else
		SetEntityInvincible(GetPlayerPed(-1), false)
		TriggerEvent('esx:showNotification', "GodMode ~r~désactivé")
  end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
  invisible = not invisible
  local ped = GetPlayerPed(-1)
  
  if invisible then -- activé
		SetEntityVisible(ped, false, false)
		TriggerEvent('esx:showNotification', "Mode fantôme : activé")
	else
		SetEntityVisible(ped, true, false)
		TriggerEvent('esx:showNotification', "Mode fantôme : désactivé")
  end
end
-- FIN INVISIBLE

-- Réparer vehicule
function admin_vehicle_repair()

    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsUsing(ped)
	
		SetVehicleFixed(car)
		SetVehicleDirtLevel(car, 0.0)

end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez le nom du véhicule...")
	inputvehicle = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputvehicle == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputvehicle = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputvehicle = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputvehicle = 0
			end
		end
		if inputvehicle == 2 then
		local vehicleidd = GetOnscreenKeyboardResult()

				local car = GetHashKey(vehicleidd)
				
				Citizen.CreateThread(function()
					Citizen.Wait(10)
					RequestModel(car)
					while not HasModelLoaded(car) do
						Citizen.Wait(0)
					end
                    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
					veh = CreateVehicle(car, x,y,z, 0.0, true, false)
					SetEntityVelocity(veh, 2000)
					SetVehicleOnGroundProperly(veh)
					SetVehicleHasBeenOwnedByPlayer(veh,true)
					local id = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(id, true)
					SetVehRadioStation(veh, "OFF")
					SetPedIntoVehicle(GetPlayerPed(-1),  veh,  -1)
					TriggerEvent('esx:showNotification', "Véhicule spawn, bonne route")
				end)
		
        inputvehicle = 0
		end
	end
end)
-- FIN Spawn vehicule

-- Spawn vehicule
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputvehicle == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputvehicle = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputvehicle = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputvehicle = 0
			end
		end
		if inputvehicle == 2 then
		local vehicleidd = GetOnscreenKeyboardResult()

				local car = GetHashKey(vehicleidd)
				
				Citizen.CreateThread(function()
					Citizen.Wait(10)
					RequestModel(car)
					while not HasModelLoaded(car) do
						Citizen.Wait(0)
					end
                    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
					veh = CreateVehicle(car, x,y,z, 0.0, true, false)
					SetEntityVelocity(veh, 2000)
					SetVehicleOnGroundProperly(veh)
					SetVehicleHasBeenOwnedByPlayer(veh,true)
					local id = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(id, true)
					SetVehRadioStation(veh, "OFF")
					SetPedIntoVehicle(GetPlayerPed(-1),  veh,  -1)
					TriggerEvent('esx:showNotification', "Véhicule spawn, bonne route")
				end)
		
        inputvehicle = 0
		end
	end
end)
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
	if carTargetDep ~= nil then
			platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
	end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
	
	SetEntityCoords(carTargetDep, playerCoords)
	
	TriggerEvent('esx:showNotification', "Voiture retourné")

end
-- FIN flipVehicle

-- GIVE DE L'ARGENT
function admin_give_money()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez le montant a vous GIVE...")
	inputmoney = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoney == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoney = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoney = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoney = 0
			end
		end
		if inputmoney == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('AdminMenu:giveCash', money)
			inputmoney = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez le montant a vous GIVE...")
	inputmoneybank = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneybank == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneybank = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneybank = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneybank = 0
			end
		end
		if inputmoneybank == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('AdminMenu:giveBank', money)
			inputmoneybank = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez le montant a vous GIVE...")
	inputmoneydirty = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputmoneydirty == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputmoneydirty = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputmoneydirty = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputmoneydirty = 0
			end
		end
		if inputmoneydirty == 2 then
			local repMoney = GetOnscreenKeyboardResult()
			local money = tonumber(repMoney)
			
			TriggerServerEvent('AdminMenu:giveDirtyMoney', money)
			inputmoneydirty = 0
		end
	end
end)
-- FIN GIVE DE L'ARGENT SALE

-- Afficher Coord
function modo_showcoord()
	if showcoord then
		showcoord = false
	else
		showcoord = true
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		
		if showcoord then
			local playerPos = GetEntityCoords(GetPlayerPed(-1))
			local playerHeading = GetEntityHeading(GetPlayerPed(-1))
			Text("~r~X~s~: " ..playerPos.x.." ~b~Y~s~: " ..playerPos.y.." ~g~Z~s~: " ..playerPos.z.." ~y~Angle~s~: " ..playerHeading.."")
		end
		
	end
end)
-- FIN Afficher Coord

-- Afficher Nom
function modo_showname()
	if showname then
		showname = false
	else
		TriggerEvent('esx:showNotification', "Ouvrir et fermer le menu pause pour afficher les nom")
		showname = true
	end
end

Citizen.CreateThread(function()
	while true do
		Wait( 1 )
		if showname then
			for id = 0, 200 do
				if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
					ped = GetPlayerPed( id )
					blip = GetBlipFromEntity( ped )
					headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, (GetPlayerServerId( id )..' - '..GetPlayerName( id )), false, false, "", false )
				end
			end
		else
			for id = 0, 200 do
				if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
					ped = GetPlayerPed( id )
					blip = GetBlipFromEntity( ped )
					headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, (' '), false, false, "", false )
				end
			end
		end
	end
end)
-- FIN Afficher Nom

-- TP MARCKER
function admin_tp_marcker()
	
	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playergroup = group
		
		if playergroup == 'admin' or playergroup == 'superadmin' or playergroup == '_dev' then
			local playerPed = GetPlayerPed(-1)
			local WaypointHandle = GetFirstBlipInfoId(8)
			if DoesBlipExist(WaypointHandle) then
				local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
				--SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, coord.z, false, false, false, true)
				SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
				TriggerEvent('esx:showNotification', "Téléporté sur le marcker !")
			else
				TriggerEvent('esx:showNotification', "Pas de marcker sur la map !")
			end
		end
		
	end)
end
-- FIN TP MARCKER

-- HEAL JOUEUR
function admin_heal_player()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez l'id du joueur...")
	inputheal = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputheal == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputheal = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				inputheal = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputheal = 0
			end
		end
		if inputheal == 2 then
		local healply = GetOnscreenKeyboardResult()
		TriggerServerEvent('esx_ambulancejob:revive', healply)
		
        inputheal = 0
		end
	end
end)
-- FIN HEAL JOUEUR

-- SPEC JOUEUR
function admin_spec_player()
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	TriggerEvent('esx:showNotification', "~b~Entrez l'id du joueur...")
	inputspec = 1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if inputspec == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				inputspec = 0
			elseif UpdateOnscreenKeyboard() == 1 then
					inputspec = 2
			elseif UpdateOnscreenKeyboard() == 2 then
				inputspec = 0
			end
		end
		if inputspec == 2 then
		local target = GetOnscreenKeyboardResult()
		
		TriggerEvent('es_camera:spectate', source, target)
		
        inputspec = 0
		end
	end
end)
-- FIN SPEC JOUEUR