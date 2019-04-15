--[[
    File: surrender.lua
    Author: Kévin "Boby" cinquini
    Description: surrender 
--]]


Citizen.CreateThread(function()
	local noSurrender = true
	while true do
		Wait(10)
		if IsControlJustPressed(0, 323) then
			local checkVehiclePlayer = IsPedInAnyVehicle(GetPlayerPed(PlayerId()), true)
			if not checkVehiclePlayer then
				if noSurrender then
					TaskHandsUp(GetPlayerPed(PlayerId()), -1, -1, false)
					SetPedToRagdoll(GetPlayerPed(PlayerId()), 1, 1, 2, true, true, false)
					noSurrender = false
				else
					ClearPedTasks(GetPlayerPed(PlayerId()))
					noSurrender = true
				end
			end
		end
	end
end)