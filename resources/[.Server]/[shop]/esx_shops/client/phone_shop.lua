local function startShop()
	while true do
		Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1), false)
        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) and Vdist(coords.x, coords.y, coords.z, 213.72, -917.50, 30.69) < 3.0 then
            SetTextComponentFormat('STRING')
            AddTextComponentString('Appuyez sur ~INPUT_CONTEXT~ pour acheter un téléphone à 400$')
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(1, 38) then
			    TriggerServerEvent('esx_shop:buyItem', 'phone', 400, 1)
            end
        end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	local blip = AddBlipForCoord(213.72, -917.50, 30.69)
  	SetBlipSprite (blip, 521)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.0)
  	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString("Magasin électronique")
  	EndTextCommandSetBlipName(blip)

	Wait(10000)
    startShop()
end)