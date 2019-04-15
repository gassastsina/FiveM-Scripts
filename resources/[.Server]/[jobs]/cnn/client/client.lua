---------------------------------
---------------------------------
----    File : client.lua    ----
----    Author : gassastsina ----
----    Side : client        ----
----    Description : CNN 	 ----
---------------------------------
---------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX = nil
local PlayerData                = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-----------------------------------------------main------------------------------------------------------
-- Create blips
local function setBlip()
	if PlayerData.job ~= nil and PlayerData.job.name == 'reporter' then
		--Blip Farm
		local blip = AddBlipForCoord(Config.Journaliste.Farm.Pos.x, Config.Journaliste.Farm.Pos.y, Config.Journaliste.Farm.Pos.z)
	  	SetBlipSprite (blip, Config.Journaliste.Farm.Blip)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString(_U('prinery'))
	  	EndTextCommandSetBlipName(blip)


		--Blip ordinateur
		blip = AddBlipForCoord(Config.Journaliste.getMission.Pos.x, Config.Journaliste.getMission.Pos.y, Config.Journaliste.getMission.Pos.z)
	  	SetBlipSprite (blip, Config.Journaliste.getMission.Blip)
	  	SetBlipDisplay(blip, 4)
	  	SetBlipScale  (blip, 1.2)
	  	SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString(_U('computer'))
	  	EndTextCommandSetBlipName(blip)
	end


	--Blip CNN
	local blip = AddBlipForCoord(Config.Journaliste.BossActions.x, Config.Journaliste.BossActions.y, Config.Journaliste.BossActions.z)
  	SetBlipSprite (blip, 184)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.0)
  	SetBlipColour (blip, 1)
  	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString(_U('map_blip'))
  	EndTextCommandSetBlipName(blip)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    setBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    setBlip()
end)

RegisterNetEvent('nb:openMenuReporter')
AddEventHandler('nb:openMenuReporter', function()
	ESX.UI.Menu.CloseAll()

	local menutab = {{label = _U('animations'),	value = 'animations'}}

	if PlayerData.job.grade_name == 'drh' or PlayerData.job.grade_name == 'boss' then
		table.insert(menutab, 1, {label = _U('bill'), value = 'bill'})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menu',
		{
			title    = 'Journaliste',
			elements = menutab,
		},
		function(data, menu)

			if data.current.value == 'bill' and (PlayerData.job.grade_name == 'drh' or PlayerData.job.grade_name == 'boss') then

		        ESX.UI.Menu.Open(
		        	'dialog', GetCurrentResourceName(), 'bill',
		        	{
		            	title = _U('invoice_amount')
		        	},
		        	function(data, menu)

		            	local amount = tonumber(data.value)

		            	if amount == nil then
		            		ESX.ShowNotification(_U('amount_invalid'))
		            	else
							menu.close()
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
		                		ESX.ShowNotification(_U('no_players_near'))
		            		else
		                		TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_cnn', 'Journaliste', amount)
		            		end
		            	end
		          	end,
		        	function(data, menu)
		        		menu.close()
		        	end
		        )

			elseif data.current.value == 'animations' then

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'animations',
					{
						title    = _U('animations'),
						elements = {
						  	{label = _U('paparazzi'),  	 value = 'paparazzi'},
						  	{label = _U('camera'),  	 value = 'prop_v_cam_01'},
						  	{label = _U('camerafixe'), value = 'p_tv_cam_02_s'},
						  	{label = _U('chair'), value = 'hei_prop_heist_off_chair'},
						  	{label = _U('projector1'), value = 'prop_kino_light_03'},
						  	{label = _U('projector2'), value = 'prop_kino_light_02'},
						  	{label = _U('antenna'), value = 'prop_satdish_l_02'},
						  	{label = _U('greenscreen'), value = 'prop_ld_greenscreen_01'},
						  	{label = _U('table'), value = 'v_ilev_liconftable_sml'}
						},
					},
					function(data2, menu2)

						if data2.current.value == 'paparazzi' then
							TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_PAPARAZZI', 0, true)
							while not (IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9)) do
								Wait(100)
							end
							ClearPedTasks(GetPlayerPed(-1))

						--Objets
						else

							local model     = data2.current.value
							local coords    = GetEntityCoords(GetPlayerPed(-1))
							local forward   = GetEntityForwardVector(GetPlayerPed(-1))
							local x, y, z   = table.unpack(coords + forward * 2)

							if model == 'prop_v_cam_01' then
								RequestAnimDict('missmic_4premiere')
								while not HasAnimDictLoaded('missmic_4premiere') do
									Citizen.Wait(10)
								end

								x = x
								y = y
								z = z
							end

							ESX.Game.SpawnObject(model, {
								x = x,
								y = y,
								z = z
							}, function(obj)
								if model ~= 'prop_v_cam_01' then
									SetEntityHeading(obj, GetEntityHeading(GetPlayerPed(-1)) + 180)
									PlaceObjectOnGroundProperly(obj)
									FreezeEntityPosition(obj, true)
									deleteModel(obj)
								else
									AttachEntityToEntity(obj, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.1, 0.0, -0.1, -101.0, 14.0, -67.0, true, false, false, true, 1, true)
									local play = true
									while play do
										Wait(10)
										TaskPlayAnim(GetPlayerPed(-1), 'missmic_4premiere', 'movie_prem_01_m_a', 8.0, 1, -1, 50, 0.5, false, false, false)

										if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 33) or IsControlJustPressed(1, 35) or IsControlJustPressed(1, 73) then
											DeleteObject(obj)
											ClearPedTasksImmediately(GetPlayerPed(-1))
											play = false
										end
									end
								end
							end)
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

function deleteModel(obj)
	Citizen.CreateThread(function()
		while DoesEntityExist(obj) do
			Wait(10)
			local coords = GetEntityCoords(GetPlayerPed(-1), true)
			local modelCoords = GetEntityCoords(obj, true)
			if Vdist(coords.x, coords.y, coords.z, modelCoords.x,  modelCoords.y,  modelCoords.z) < Config.MarkerSize.x+1 then
				SetTextComponentFormat('STRING')
				AddTextComponentString(_U('deleteModel'))
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(1, 38) then
					DeleteEntity(obj)
				end
			end
		end
	end)
end

local isInService = false
local HasAlreadyEnteredMarker   = false
local LastPart                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
--Runs
local onjob 	= false
local deliveryblip = nil
local area = nil

Citizen.CreateThread(function()
	Wait(5000)
	while true do
		Wait(5)

		local coords    	 = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker     = false
		local currentPart    = nil
		local v 			 = Config.Journaliste

		--Don't need reporter job
		if Vdist(coords.x, coords.y, coords.z, v.MeetingRoom.Out.x,  v.MeetingRoom.Out.y,  v.MeetingRoom.Out.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'MeetingRoomOut'
		
		elseif Vdist(coords.x, coords.y, coords.z, v.MeetingRoom.In.x,  v.MeetingRoom.In.y,  v.MeetingRoom.In.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'MeetingRoomIn'
		end

		--Lift
		if Vdist(coords.x, coords.y, coords.z, v.Lift.DownLeft.x,  v.Lift.DownLeft.y,  v.Lift.DownLeft.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'LiftDownLeft'
		
		elseif Vdist(coords.x, coords.y, coords.z, v.Lift.FloorLeft.x,  v.Lift.FloorLeft.y,  v.Lift.FloorLeft.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'LiftFloorLeft'
		
		elseif Vdist(coords.x, coords.y, coords.z, v.Lift.DownRight.x,  v.Lift.DownRight.y,  v.Lift.DownRight.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'LiftDownRight'
		
		elseif Vdist(coords.x, coords.y, coords.z, v.Lift.FloorRight.x,  v.Lift.FloorRight.y,  v.Lift.FloorRight.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'LiftFloorRight'
		
		elseif Vdist(coords.x, coords.y, coords.z, v.Lift.Roof.x,  v.Lift.Roof.y,  v.Lift.Roof.z) < Config.MarkerSize.x then
			isInMarker     = true
			currentPart    = 'LiftRoof'
		end


		--Need reporter job
		if PlayerData.job ~= nil and PlayerData.job.name == 'reporter' then
			--Display markers
			if Vdist(coords.x, coords.y, coords.z, v.OnService.x,  v.OnService.y,  v.OnService.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.OnService.x, v.OnService.y, v.OnService.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, v.OnService.x,  v.OnService.y,  v.OnService.z) < Config.MarkerSize.x then
					isInMarker     = true
					currentPart    = 'OnService'
				end
			end

			if Vdist(coords.x, coords.y, coords.z, v.Vehicles.Spawner.x,  v.Vehicles.Spawner.y,  v.Vehicles.Spawner.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Vehicles.Spawner.x, v.Vehicles.Spawner.y, v.Vehicles.Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, v.Vehicles.Spawner.x,  v.Vehicles.Spawner.y,  v.Vehicles.Spawner.z) < Config.MarkerSize.x then
					isInMarker     = true
					currentPart    = 'VehicleSpawner'
				end
			end

			if not onjob and Vdist(coords.x, coords.y, coords.z, v.getMission.Pos.x,  v.getMission.Pos.y,  v.getMission.Pos.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.getMission.Pos.x, v.getMission.Pos.y, v.getMission.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if not onjob and Vdist(coords.x, coords.y, coords.z, v.getMission.Pos.x,  v.getMission.Pos.y,  v.getMission.Pos.z) < Config.MarkerSize.x then
					isInMarker     = true
					currentPart    = 'getMission'
				end
			
			elseif onjob and Vdist(coords.x, coords.y, coords.z, Config.Journaliste.Destinations[area].x,  Config.Journaliste.Destinations[area].y,  Config.Journaliste.Destinations[area].z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Journaliste.Destinations[area].x, Config.Journaliste.Destinations[area].y, Config.Journaliste.Destinations[area].z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, Config.Journaliste.Destinations[area].x,  Config.Journaliste.Destinations[area].y,  Config.Journaliste.Destinations[area].z) < Config.MarkerSize.x then
					isInMarker     = true
					currentPart    = 'destination'
				end
			end

			if Vdist(coords.x, coords.y, coords.z, v.Farm.Pos.x,  v.Farm.Pos.y,  v.Farm.Pos.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Farm.Pos.x, v.Farm.Pos.y, v.Farm.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if Vdist(coords.x, coords.y, coords.z, v.Farm.Pos.x,  v.Farm.Pos.y,  v.Farm.Pos.z) < Config.MarkerSize.x then
					isInMarker     = true
					currentPart    = 'ArticleFarm'
				end
			end

			if (GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey('contender') or GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey('rumpo2')) and Vdist(coords.x, coords.y, coords.z, v.Extra.Pos.x,  v.Extra.Pos.y,  v.Extra.Pos.z) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Extra.Pos.x, v.Extra.Pos.y, v.Extra.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Extra.MarkerSize, v.Extra.MarkerSize, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				if (GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey('contender') or GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey('rumpo2')) and Vdist(coords.x, coords.y, coords.z, v.Extra.Pos.x,  v.Extra.Pos.y,  v.Extra.Pos.z) < v.Extra.MarkerSize then
					isInMarker     = true
					currentPart    = 'extra'
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
				if Vdist(coords.x, coords.y, coords.z, v.BossActions.x,  v.BossActions.y,  v.BossActions.z) < Config.DrawDistance then
					DrawMarker(Config.MarkerType, v.BossActions.x, v.BossActions.y, v.BossActions.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
				if Vdist(coords.x, coords.y, coords.z, v.BossActions.x,  v.BossActions.y,  v.BossActions.z) < Config.MarkerSize.x then
					isInMarker     = true
					currentPart    = 'BossActions'
				end
			end

			--Exit/Enter Marker
			if Vdist(coords.x, coords.y, coords.z, v.Vehicles.Deleter.x,  v.Vehicles.Deleter.y,  v.Vehicles.Deleter.z) < v.Vehicles.MarkerSizeDeleter then
				isInMarker     = true
				currentPart    = 'VehicleDeleter'
			end

			if Vdist(coords.x, coords.y, coords.z, v.Helicopters.Deleter.x,  v.Helicopters.Deleter.y,  v.Helicopters.Deleter.z) < v.Helicopters.MarkerSizeDeleter then
				isInMarker     = true
				currentPart    = 'HelicopterDeleter'
			end

			if IsControlJustReleased(1, 178) then --DEL
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'weazel_news_title',
					{
						title = _U('message_to_population')
					},
					function(data, menu)

						local msg = tostring(data.value)
						menu.close()
						TriggerServerEvent('cnn:WeazelNews', msg)
					end,
					function(data, menu)
						menu.close()
					end
				)
			end
		end


		--Second part
		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and LastPart ~= currentPart) then
			
			if LastPart ~= nil and LastPart ~= currentPart then
				CurrentAction = nil
				hasExited = true
				stopRunning(currentPart)
			end

			HasAlreadyEnteredMarker = true
			LastPart                = currentPart
			
			hasEnteredMarker(currentPart)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			
			TriggerServerEvent('cnn:stopSellNewspaper')
			TriggerServerEvent('cnn:stopHarvestArticle')
			HasAlreadyEnteredMarker = false
			CurrentAction = nil
		end


		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustPressed(0, 38) then --Appuie sur E
				if CurrentAction == 'menu_OnService' then
					OnService()
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_helicopter' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_MeetingRoomOut' then
					SetEntityCoords(GetPlayerPed(-1), v.MeetingRoom.In.x, v.MeetingRoom.In.y, v.MeetingRoom.In.z, false, false, false, false)
				elseif CurrentAction == 'menu_MeetingRoomIn' then
					SetEntityCoords(GetPlayerPed(-1), v.MeetingRoom.Out.x, v.MeetingRoom.Out.y, v.MeetingRoom.Out.z, false, false, false, false)
				elseif CurrentAction == 'menu_extra' then
					if GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey('contender') then
						if IsVehicleExtraTurnedOn(CurrentActionData.vehicle, 1) then
							SetVehicleExtra(CurrentActionData.vehicle, 1, 1)
						else
							SetVehicleExtra(CurrentActionData.vehicle, 1, 0)
						end

						elseif GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey('rumpo2') then
							rumpo2ExtrasMenu(CurrentActionData.vehicle)
						end

				--Runs
				elseif CurrentAction == 'article_harvest' then
					TriggerServerEvent('cnn:startHarvestArticle')
					CurrentAction = nil
				elseif CurrentAction == 'get_Mission' then
					getMission()
				elseif CurrentAction == 'destination_sell' then
					TriggerServerEvent('cnn:startSellNewspaper')
					RemoveBlip(deliveryblip)
					CurrentAction = nil
				--Coffre
				elseif CurrentAction == 'menu_boss_actions' then
					TriggerEvent('esx_society:openBossMenu', 'cnn', function(data, menu)
			        	menu.close()
			        end)
				end
				--CurrentAction = nil
			end
		end
	end
end)
--Fin boucle principale


function rumpo2ExtrasMenu(vehicle)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menu_extra',
		{
			title    = _U('manager_menu'),
			elements = {
				{value = 2, label = _U('antenna_1')},
				{value = 3, label = _U('antenna_2')}
			},
		},
		function(data, menu)
			if IsVehicleExtraTurnedOn(vehicle, data.current.value) then
				SetVehicleExtra(vehicle, data.current.value, 1)
			else
				SetVehicleExtra(vehicle, data.current.value, 0)
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction     = 'menu_extra'
			CurrentActionMsg  = _U('set_extra')
			CurrentActionData = {vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)}
		end
	)
end

function getMission()
	area = math.random(1, #Config.Journaliste.Destinations)
	deliveryblip = AddBlipForCoord(Config.Journaliste.Destinations[area].x, Config.Journaliste.Destinations[area].y, Config.Journaliste.Destinations[area].z)
	SetBlipSprite(deliveryblip, Config.Journaliste.Resell.Blip)
		BeginTextCommandSetBlipName("STRING")
	  	AddTextComponentString(_U('mission_destination'))
	  	EndTextCommandSetBlipName(blip)
	SetNewWaypoint(Config.Journaliste.Destinations[area].x, Config.Journaliste.Destinations[area].y)
	TriggerEvent('esx:showNotification', _U('go_mission'))
	onjob = true
end

function stopRunning(cercle)
	if cercle == 'ArticleFarm' or cercle == 'ResellNewspaper' then
		TriggerServerEvent('cnn:stopSellNewspaper')
		TriggerServerEvent('cnn:stopHarvestArticle')
		RemoveBlip(deliveryblip)
		onjob = false
	end
end

function hasEnteredMarker(part)

	if part == 'OnService' then
		CurrentAction     = 'menu_OnService'
		CurrentActionMsg  = _U('open_OnService')
		CurrentActionData = {}

	elseif part == 'MeetingRoomOut' then
		CurrentAction     = 'menu_MeetingRoomOut'
		CurrentActionMsg  = _U('open_MeetingRoomOut')
		CurrentActionData = {}
	elseif part == 'MeetingRoomIn' then
		CurrentAction     = 'menu_MeetingRoomIn'
		CurrentActionMsg  = _U('open_MeetingRoomIn')
		CurrentActionData = {}

	elseif part == 'VehicleSpawner' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {}

	elseif part == 'HelicopterDeleter' then
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		
		if IsPedInAnyVehicle(GetPlayerPed(-1),  false) and GetEntityModel(vehicle) == GetHashKey('maverick') and DoesEntityExist(vehicle) then
			CurrentAction     = 'delete_helicopter'
			CurrentActionMsg  = _U("delete_helico")
			CurrentActionData = {vehicle = vehicle}
		end

	elseif part == 'VehicleDeleter' then

		if IsPedInAnyVehicle(GetPlayerPed(-1),  false) then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('delete_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end
		end

	elseif part == 'extra' then
		CurrentAction     = 'menu_extra'
		CurrentActionMsg  = _U('set_extra')
		CurrentActionData = {vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)}

	--Lift
	elseif part == 'LiftDownLeft' then
		TeleportFadeEffect(Config.Journaliste.FromLift.FloorLeft)
		SetEntityHeading(GetPlayerPed(-1), 28.34)

	elseif part == 'LiftFloorLeft' then
		TeleportFadeEffect(Config.Journaliste.FromLift.DownLeft)
		SetEntityHeading(GetPlayerPed(-1), 28.34)

	elseif part == 'LiftDownRight' then
		HelicopterSpawner()
		TeleportFadeEffect(Config.Journaliste.FromLift.Roof)
		SetEntityHeading(GetPlayerPed(-1), 295.0)

	elseif part == 'LiftFloorRight' then
		HelicopterSpawner()
		TeleportFadeEffect(Config.Journaliste.FromLift.Roof)
		SetEntityHeading(GetPlayerPed(-1), 295.0)

	elseif part == 'LiftRoof' then
		TeleportFadeEffect(Config.Journaliste.FromLift.DownRight)
		SetEntityHeading(GetPlayerPed(-1), 28.34)

	--Runs
	elseif part == 'ArticleFarm' then
		CurrentAction     = 'article_harvest'
		CurrentActionMsg  = _U('press_process_newspaper')
		CurrentActionData = {}
	elseif part == 'getMission' then
       	CurrentAction     = 'get_Mission'
		CurrentActionMsg  = _U('get_mission')
		CurrentActionData = {}
	elseif part == 'destination' then
       	CurrentAction     = 'destination_sell'
		CurrentActionMsg  = _U('press_sell_newspaper')
		CurrentActionData = {}

	--Coffre
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end

function TeleportFadeEffect(coords)

	DoScreenFadeOut(700)
	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	ESX.Game.Teleport(GetPlayerPed(-1), coords, function()
		DoScreenFadeIn(700)
	end)

end

function OnService()
	if isInService then
		TriggerServerEvent("player:serviceOff", "reporter")
	else
		TriggerServerEvent("player:serviceOn", "reporter")
	end
	isInService = not isInService

	ESX.UI.Menu.CloseAll()
	local elements = {{label = _U('citizen_wear'), value = 'citizen_wear'}}
	if PlayerData.job.grade_name == 'recruit' then
		table.insert(elements, {label = _U('recruit_wear'), value = 'recruit_wear'})
	else
		table.insert(elements, {label = _U('reporter_wear'), value = 'reporter_wear'})
		table.insert(elements, {label = _U('suit_wear'), value = 'suit_wear'})
		table.insert(elements, {label = _U('inter_wear'), value = 'inter_wear'})
	end
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = elements
		},
		function(data, menu)
			menu.close()

			if data.current.value == 'citizen_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

			elseif data.current.value == 'recruit_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

					ClearPedProp(GetPlayerPed(-1), 0)
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--T-Shirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 39, 0, 0)--Torse
					SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 0)--Bras
			        SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 0, 0)--Jambes
					SetPedComponentVariation(GetPlayerPed(-1), 6, 8, 1, 0)--Chaussures
					SetPedPropIndex(GetPlayerPed(-1), 0, 0, 0, 0)--Casque
					SetPedPropIndex(GetPlayerPed(-1), 1, 7, 0, 0)--Lunette
				end)

			elseif data.current.value == 'reporter_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

					ClearPedProp(GetPlayerPed(-1), 0)
					SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 1, 0)--T-Shirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 76, 0, 0)--Torse
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 0)--Bras
			        SetPedComponentVariation(GetPlayerPed(-1), 4, 22, 0, 0)--Jambes
					SetPedComponentVariation(GetPlayerPed(-1), 6, 20, 0, 0)--Chaussures
					SetPedPropIndex(GetPlayerPed(-1), 0, 7, 1, 0)--Casque
					SetPedPropIndex(GetPlayerPed(-1), 1, 17, 0, 0)--Lunette
				end)

			elseif data.current.value == 'suit_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

					ClearPedProp(GetPlayerPed(-1), 0)
					SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 1, 0)--T-Shirt
					SetPedComponentVariation(GetPlayerPed(-1), 11, 99, 4, 0)--Torse
					SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 0)--Bras
			        SetPedComponentVariation(GetPlayerPed(-1), 4, 48, 0, 0)--Jambes
					SetPedComponentVariation(GetPlayerPed(-1), 6, 40, 6, 0)--Chaussures
					SetPedPropIndex(GetPlayerPed(-1), 0, 25, 2, 0)--Casque
					SetPedPropIndex(GetPlayerPed(-1), 1, 17, 4, 0)--Lunette
				end)

			elseif data.current.value == 'inter_wear' then --Ajout de tenue par grades
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

					ClearPedProp(GetPlayerPed(-1), 0)
			        SetPedComponentVariation(GetPlayerPed(-1), 4, 48, 0, 0)--Jambes
					SetPedComponentVariation(GetPlayerPed(-1), 6, 23, 2, 0)--Chaussures
					SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--T-Shirt
					SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 0)--Bras
					SetPedComponentVariation(GetPlayerPed(-1), 9, 16, 0, 0)--Gilet pare boule
					SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 2, 0)--Torse
					SetPedPropIndex(GetPlayerPed(-1), 0, 59, 5, 0)--Casque
					SetPedPropIndex(GetPlayerPed(-1), 1, 17, 4, 0)--Lunette
			        SetPedArmour(GetPlayerPed(-1), 80)
				end)
			end
		end
	)
end


local function BasicSpawnVehicle(vehicle)
	SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)--Primary color
	SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)--Secondary color
	TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
	TaskWarpPedIntoVehicle(GetPlayerPed(-1),  vehicle,  -1)
end

function OpenVehicleSpawnerMenu()

	local elements = {}
	local vehicles = Config.Journaliste.Vehicles

	if PlayerData.job.grade_name == 'reporter' or PlayerData.job.grade_name == 'drh' or PlayerData.job.grade_name == 'boss' then
		table.insert(elements, Config.Journaliste.AuthorizedVehicles[1])
		table.insert(elements, Config.Journaliste.AuthorizedVehicles[4])
		table.insert(elements, Config.Journaliste.AuthorizedVehicles[5])
		if PlayerData.job.grade_name == 'drh' or PlayerData.job.grade_name == 'boss' then
			table.insert(elements, Config.Journaliste.AuthorizedVehicles[2])
		end
	end
	table.insert(elements, Config.Journaliste.AuthorizedVehicles[3])

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menu_spawner',
		{
			title    = _U('vehicle_menu'),
			elements = elements,
		},
		function(data, menu)

			menu.close()
			local model = data.current.value

			if model == 'rumpo' then
				ESX.Game.SpawnVehicle(model, {
					x = vehicles.SpawnPoint.x, 
					y = vehicles.SpawnPoint.y, 
					z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
					SetVehicleLivery(vehicle, 0) --Livery
					BasicSpawnVehicle(vehicle)
				end)

			elseif model == 'faggio' then
				ESX.Game.SpawnVehicle(model, {
					x = vehicles.SpawnPoint.x, 
					y = vehicles.SpawnPoint.y, 
					z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
					BasicSpawnVehicle(vehicle)
				end)

			elseif model == 'contender' then
				ESX.Game.SpawnVehicle(model, {
					x = vehicles.SpawnPoint.x, 
					y = vehicles.SpawnPoint.y, 
					z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
					SetVehicleMod(vehicle, 14, 0, false)--Horn
					BasicSpawnVehicle(vehicle)
				end)

			elseif model == 'rumpo2' then
				ESX.Game.SpawnVehicle(model, {
					x = vehicles.SpawnPoint.x, 
					y = vehicles.SpawnPoint.y, 
					z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
					BasicSpawnVehicle(vehicle)
				end)

			elseif model == 'rallytruck' then
				ESX.Game.SpawnVehicle(model, {
					x = vehicles.SpawnPoint.x, 
					y = vehicles.SpawnPoint.y, 
					z = vehicles.SpawnPoint.z
				}, vehicles.Heading, function(vehicle)
					BasicSpawnVehicle(vehicle)
				end)
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = _U('vehicle_spawner')
			CurrentActionData = {}
		end
	)
end

function HelicopterSpawner()
	local helicopters = Config.Journaliste.Helicopters
	if not IsAnyVehicleNearPoint(helicopters.SpawnPoint.x, helicopters.SpawnPoint.y, helicopters.SpawnPoint.z,  4.0) then
		ESX.Game.SpawnVehicle('maverick', {
			x = helicopters.SpawnPoint.x, 
			y = helicopters.SpawnPoint.y, 
			z = helicopters.SpawnPoint.z
		}, helicopters.Heading, function(vehicle)
			SetVehicleModKit(vehicle, 0)
			SetVehicleCustomPrimaryColour(vehicle, 255, 0, 0)--Primary color
			SetVehicleCustomSecondaryColour(vehicle, 255, 0, 0)--Secondary color
			TriggerEvent('esx_key:getVehiclesKey', GetVehicleNumberPlateText(vehicle))
		end)
	else
		print("CNN : Un véhicule a bloqué le spawn de l'hélicoptère")
	end
end