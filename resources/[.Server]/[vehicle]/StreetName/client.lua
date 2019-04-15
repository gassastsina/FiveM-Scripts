------------------------------------------------------------
------------------------------------------------------------
----    File : client.lua    							----
----    Edited by : gassastsina 						----
----    Side : client        							----
----    Description : Display street name on the screen ----
------------------------------------------------------------
------------------------------------------------------------

local showHUD = true
Citizen.CreateThread(function()
while true do
		Wait(10)
	    if showHUD then
			SetTextFont(0)
	        SetTextProportional(1)
	        SetTextScale(0.0, 0.35)
	        SetTextColour(255, 255, 255, 255)
	        SetTextDropshadow(0, 0, 0, 0, 255)
	        SetTextEdge(1, 0, 0, 0, 255)
	        SetTextDropShadow()
	        SetTextOutline()
	        SetTextCentre(true)
	        SetTextEntry("STRING")

			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z))
			
			AddTextComponentString(streetName)
	        DrawText(0.09, 0.77)
	    end
	end
end)

AddEventHandler('esx:ShowHUD', function(HUD)
    showHUD = HUD
end)