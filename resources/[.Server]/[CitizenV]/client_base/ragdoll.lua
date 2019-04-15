--[[
    File: ragdoll.lua
    Author: Kévin "Boby" cinquini
    Description: Bwwaa
--]]

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if IsControlPressed(0, 243) then
			local checkVehiclePlayer = IsPedInAnyVehicle(GetPlayerPed(PlayerId()), true)
			if not checkVehiclePlayer then
				SetPedToRagdoll(GetPlayerPed(PlayerId()), 2300, 2300, 0, true, true, false)
			end
		end
	end	
end)