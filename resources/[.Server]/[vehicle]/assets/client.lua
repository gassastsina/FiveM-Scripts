local plate = {}
Citizen.CreateThread(function()
	while true do
		Wait(5000)
		local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
		if GetEntityModel(vehicle) == GetHashKey('sheriff') and canSetSound(GetVehicleNumberPlateText(vehicle)) then
			SetVehicleAudio(vehicle, 'T20')
		end
	end
end)

function canSetSound(vehicle)
	for i=0, #plate, 1 do
		if vehicle == plate[i] then
			return false
		elseif i == #plate then
			table.insert(plate, vehicle)
			return true
		end
	end
end