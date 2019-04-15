ESX          = nil
local IsDead = false
local IsAnimated = false
local inAnim = false
local bool = false
local bool1 = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)

AddEventHandler('playerSpawned', function()

	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F',
		function(status)
			return true
		end,
		function(status)
			status.remove(200)
		end
	)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1',
		function(status)
			return true
		end,
		function(status)
			status.remove(250)
		end
	)

	Citizen.CreateThread(function()

		while true do

			Wait(1000)

			local playerPed  = GetPlayerPed(-1)
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				
				if status.val == 0 then

					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end

				end

			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				
				if status.val == 0 then

					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end

				end

			end)

			if health ~= prevHealth then
				SetEntityHealth(playerPed,  health)
			end

		end

	end)

	Citizen.CreateThread(function()

		while true do

			Wait(0)

			local playerPed = GetPlayerPed(-1)
			
			if IsEntityDead(playerPed) and not IsDead then
				IsDead = true
			end

		end

	end)

end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
    if not IsAnimated then
		DeleteObject(propburger)
		DeleteObject(propwater)
		SetEntityAsNoLongerNeeded(propwater)
		DeleteObject(propbeer)
		DeleteObject(propvodka)
		DeleteObject(propwhiskey)
		local prop_name = prop_name or 'prop_cs_hotdog_01'
    	IsAnimated = true
	    local playerPed = GetPlayerPed(-1)
	    Citizen.CreateThread(function()
	        local x,y,z = table.unpack(GetEntityCoords(playerPed))
	        propburger = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
	        AttachEntityToEntity(propburger, playerPed, GetPedBoneIndex(playerPed, 18905), 0.13, -0.0, 0.02, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	        RequestAnimDict('mp_player_inteat@burger')
	        while not HasAnimDictLoaded('mp_player_inteat@burger') do
	            Wait(0)
	        end
	        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, 24000, 49, 0, 0, 0, 0)
	        Wait(15000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
	        DeleteObject(propburger)
	    end)
	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		DeleteObject(propburger)
		DeleteObject(propwater)
		SetEntityAsNoLongerNeeded(propwater)
		DeleteObject(propbeer)
		DeleteObject(propvodka)
		DeleteObject(propwhiskey)
		local prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			propwater = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)			
	        AttachEntityToEntity(propwater, playerPed, GetPedBoneIndex(playerPed, 18905), 0.10, 0.0, 0.011, 300.0, 100.0, 0.0, true, true, false, true, 1, true)
			RequestAnimDict('mp_player_intdrink')  
			while not HasAnimDictLoaded('mp_player_intdrink') do
				Wait(0)
			end
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 22000, 49, 0, 0, 0, 0)
			Wait(10000)
	        IsAnimated = false
	        ClearPedSecondaryTask(playerPed)
			DeleteObject(propwater)
		end)
	end
end)



RegisterNetEvent('esx_basicneeds:onDrinkbeer')
AddEventHandler('esx_basicneeds:onDrinkbeer', function(prop_name)
  if not IsAnimated then
	DeleteObject(propburger)
	DeleteObject(propwater)
	SetEntityAsNoLongerNeeded(propwater)
	DeleteObject(propbeer)
	DeleteObject(propvodka)
	DeleteObject(propwhiskey)
	local prop_name = prop_name or 'prop_cs_beer_bot_01'
	IsAnimated = true
	local playerPed = GetPlayerPed(-1)
	Citizen.CreateThread(function()
      local x,y,z = table.unpack(GetEntityCoords(playerPed))
      propbeer = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)     
          AttachEntityToEntity(propbeer, playerPed, GetPedBoneIndex(playerPed, 18905), 0.09, -0.04, 0.011, 300.0, 100.0, 0.0, true, true, false, true, 1, true)
      RequestAnimDict('mp_player_intdrink')  
      while not HasAnimDictLoaded('mp_player_intdrink') do
        Wait(0)
      end
      TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 15000, 49, 0, 0, 0, 0)
      Wait(13000)
          IsAnimated = false
          ClearPedSecondaryTask(playerPed)
      
      inAnim = true
      Citizen.Wait(60000)
      ClearPedTasks(GetPlayerPed(-1))
      inAnim = false
      SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
      SetPedIsDrunk(GetPlayerPed(-1), true)
      bool = true
      Citizen.Wait(120000)
      ResetPedMovementClipset(GetPlayerPed(-1), 0)
      SetPedIsDrunk(GetPlayerPed(-1), false)
      bool = false
      DeleteObject(propbeer)
    end)
  end
end)



RegisterNetEvent('esx_basicneeds:onDrinkvodka')
AddEventHandler('esx_basicneeds:onDrinkvodka', function(prop_name)
  if not IsAnimated then
    DeleteObject(propburger)
    DeleteObject(propwater)
	SetEntityAsNoLongerNeeded(propwater)
    DeleteObject(propbeer)
    DeleteObject(propvodka)
    DeleteObject(propwhiskey)
    local prop_name = prop_name or 'prop_beer_bison'
    IsAnimated = true
    local playerPed = GetPlayerPed(-1)
    Citizen.CreateThread(function()
      local x,y,z = table.unpack(GetEntityCoords(playerPed))
      propvodka = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)     
      AttachEntityToEntity(propvodka, playerPed, GetPedBoneIndex(playerPed, 18905), 0.04, -0.12, 0.038, 300.0, 100.0, 0.0, true, true, false, true, 1, true)
      RequestAnimDict('mp_player_intdrink')
      while not HasAnimDictLoaded('mp_player_intdrink') do
        Wait(0)
      end
      TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 15000, 49, 0, 0, 0, 0)
      Wait(16000)
          IsAnimated = false
          ClearPedSecondaryTask(playerPed)
      
      inAnim = true
      Citizen.Wait(30000)
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)
      ClearPedTasks(GetPlayerPed(-1))
      inAnim = false
      SetTimecycleModifier("spectator5")
      SetPedMotionBlur(GetPlayerPed(-1), true)
      SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
      SetPedIsDrunk(GetPlayerPed(-1), true)
      DoScreenFadeIn(1000)
      bool1 = true
      Citizen.Wait(120000)
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      ClearTimecycleModifier()
      ResetScenarioTypesEnabled()
      ResetPedMovementClipset(GetPlayerPed(-1), 0)
      SetPedIsDrunk(GetPlayerPed(-1), false)
      SetPedMotionBlur(GetPlayerPed(-1), false)
      bool1 = false
      DeleteObject(propvodka)
    end)
  end
end)

RegisterNetEvent('esx_basicneeds:onDrinkwhiskey')
AddEventHandler('esx_basicneeds:onDrinkwhiskey', function(prop_name)
  if not IsAnimated then
    DeleteObject(propburger)
    DeleteObject(propwater)
	SetEntityAsNoLongerNeeded(propwater)
    DeleteObject(propbeer)
    DeleteObject(propvodka)
    DeleteObject(propwhiskey)
    local prop_name = prop_name or 'p_whiskey_bottle_s'
    IsAnimated = true
    local playerPed = GetPlayerPed(-1)
    Citizen.CreateThread(function()
      local x,y,z = table.unpack(GetEntityCoords(playerPed))
      propwhiskey = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)     
          AttachEntityToEntity(propwhiskey, playerPed, GetPedBoneIndex(playerPed, 18905), 0.09, -0.05, 0.031, 300.0, 100.0, 0.0, true, true, false, true, 1, true)
      RequestAnimDict('mp_player_intdrink')  
      while not HasAnimDictLoaded('mp_player_intdrink') do
        Wait(0)
      end
      TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 15000, 49, 0, 0, 0, 0)
      Wait(16000)
          IsAnimated = false
          ClearPedSecondaryTask(playerPed)
      inAnim = truea
      Citizen.Wait(30000)
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)
      ClearPedTasks(GetPlayerPed(-1))
      inAnim = false
      SetTimecycleModifier("spectator5")
      SetPedMotionBlur(GetPlayerPed(-1), true)
      SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
      SetPedIsDrunk(GetPlayerPed(-1), true)
      DoScreenFadeIn(1000)
      bool = true
      Citizen.Wait(120000)
      DoScreenFadeOut(1000)
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      ClearTimecycleModifier()
      ResetScenarioTypesEnabled()
      ResetPedMovementClipset(GetPlayerPed(-1), 0)
      SetPedIsDrunk(GetPlayerPed(-1), false)
      SetPedMotionBlur(GetPlayerPed(-1), false)
      bool = false
      DeleteObject(propwhiskey)
    end)
  end
end)

RegisterNetEvent('esx_basicneeds:cigarette')
AddEventHandler('esx_basicneeds:cigarette', function()

  	--[[local pid = PlayerPedId()
  	RequestAnimDict("amb@world_human_drinking@coffee@male@idle_a")
    while not HasAnimDictLoaded("amb@world_human_drinking@coffee@male@idle_a") do
      Wait(100)
    end]]
    
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING", 0, true)
   	inAnim = true
end)


RegisterNetEvent('esx_basicneeds:onDrinkCoffee')
AddEventHandler('esx_basicneeds:onDrinkCoffee', function()
	if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			if skin.sex == 0 then
			    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_AA_COFFEE", 0, true)
			else
				RequestAnimDict("amb@world_human_aa_coffee@base")
			    while not HasAnimDictLoaded("amb@world_human_aa_coffee@base") do
			      Wait(100)
			    end
			    local playerPed = GetPlayerPed(-1)
			    local x,y,z = table.unpack(GetEntityCoords(playerPed))
				propwater = CreateObject(GetHashKey("prop_fib_coffee"), x, y, z+0.2,  true,  true, true)
				SetEntityAsMissionEntity(propwater)
				AttachEntityToEntity(propwater, playerPed, GetPedBoneIndex(playerPed, 18905), 0.13, 0.06, 0.05, 120.0, -70.0, 214.0, true, true, false, true, 1, true)
				TaskPlayAnim(playerPed, 'amb@world_human_aa_coffee@base', 'base', 8.0, -8, 24000, 49, 0, 0, 0, 0)
			end
			inAnim = true
			--Citizen.Wait(90000)
			--ClearPedTasks(GetPlayerPed(-1))
			--inAnim = false
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if inAnim then
			if IsControlJustPressed(0, 32) or IsControlJustPressed(0, 8) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 9) then
				ClearPedTasks(GetPlayerPed(PlayerId()))
      			DeleteObject(propwater)
      			SetEntityAsNoLongerNeeded(propwater)
				inAnim = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Wait(1000)
		while bool do
		    Wait(0)
		    if IsControlJustPressed(0, 22) then
		      SetPedToRagdoll(GetPlayerPed(PlayerId()), 1000, 1000, 0, true, true, false)
		    end
		end
	end
end)


 
Citizen.CreateThread(function()
  	while true do
    	Wait(1000)
	    while bool1 do
	        Wait(math.random(15000, 30000))
	        SetPedToRagdoll(GetPlayerPed(PlayerId()), 8000, 8000, 0, true, true, false)
	    end
  	end
end)
