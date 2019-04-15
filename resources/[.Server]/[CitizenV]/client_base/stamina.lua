--ENLEVER LA STAMINA
Citizen.CreateThread(function()
	while true do
		RestorePlayerStamina(PlayerId(), 1.0)
		Citizen.Wait(0)
	end
end)

--[[neige
Citizen.CreateThread(function()
    while true do
		
		SetWeatherTypePersist("XMAS")
        SetWeatherTypeNowPersist("XMAS")
        SetWeatherTypeNow("XMAS")
        SetOverrideWeather("XMAS")
    	
		Citizen.Wait(1)
	end
end)]]

--[[local inAnim = false
local weaponHash = GetHashKey("WEAPON_SNOWBALL")
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0, 27) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
			animsAction()
			
			Wait(2000)
			GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 1, false, true)

		end
		if inAnim then
			
			GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 1, false, true)
			Wait(2000)
		end	
	end

end)]]
function animsAction()

		Citizen.CreateThread(function()
			if not inAnim then
				local playerPed = GetPlayerPed(-1);
				if DoesEntityExist(playerPed) then -- Ckeck if ped exist
					-- Play Animation
					RequestAnimDict("pickup_object")
					while not HasAnimDictLoaded("pickup_object") do
						Citizen.Wait(0)
					end
					if HasAnimDictLoaded("pickup_object") then
						TaskPlayAnim(playerPed, "pickup_object", "pickup_low", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
						inAnim = true
					end

					-- Wait end annimation
					while true do
						Citizen.Wait(0)
						if inAnim == true then
							if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9) then
								inAnim = false
								ClearPedTasks(GetPlayerPed(-1))
								break
							end
						end
					end
				end -- end ped exist
			end
		end)
end