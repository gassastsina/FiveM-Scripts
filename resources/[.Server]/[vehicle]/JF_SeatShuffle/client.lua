--[[ SEAT SHUFFLE ]]--
--[[ BY JAF ]]--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(33)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and
			GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) and
			IsVehicleSeatFree(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) and
			GetIsTaskActive(GetPlayerPed(-1), 165) and not IsControlPressed(1, 23) and not IsControlPressed(1, 80) then
			SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
		end
	end
end)