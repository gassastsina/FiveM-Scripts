--Vakeros
-- coord des machines a café
local config = {
    {x = 435.9211, y = -985.613, z = 30.6895},
    {x = 233.2404, y = -424.2742, z = -117.1996},
    {x = 285.3684, y = -281.9219, z = 53.9400}
}
Citizen.CreateThread(function()
	local zone = false
	while true do
		zone = false
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i = 1, #config do
			if GetDistanceBetweenCoords(coords, config[i].x, config[i].y, config[i].z, true) < 0.5 then
				 zone = true
			end
		end
		Wait(0)
		
		if zone then
			SetTextComponentFormat("STRING")
			AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour acheter un café 5$")
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustPressed(1,38) then
				Wait(300)
				TriggerServerEvent('client_base_coffee:buy')
			end
		end
	end
end)
local function DisplayHelpText(str)
end