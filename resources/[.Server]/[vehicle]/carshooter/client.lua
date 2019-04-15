-------------------------------------------------------------------
-------------------------------------------------------------------
----    File : client.lua    								   ----
----    Author : gassastsina 								   ----
----    Side : client        								   ----
----    Description : Disable shooting in a car for the driver ----
-------------------------------------------------------------------
-------------------------------------------------------------------

Citizen.CreateThread(function()
	local MaxSpeedCanFire = 40	--km/h
	while true do
		Wait(35)
	    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and
	    	GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and
	    	GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6 > MaxSpeedCanFire
	    	then
	    	DisablePlayerFiring(GetPlayerPed(-1), true)
	    end
  	end
end)