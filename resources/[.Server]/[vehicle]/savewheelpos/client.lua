Citizen.CreateThread(function()
    local angle = 0.0
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if DoesEntityExist(veh) then
            local tangle = GetVehicleSteeringAngle(veh)
            if tangle > 10.0 or tangle < -10.0 then
                angle = tangle
            end
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
            if GetEntitySpeed(veh) < 0.1 and DoesEntityExist(vehicle) and not GetIsTaskActive(PlayerPedId(), 151) then
                SetVehicleSteeringAngle(GetVehiclePedIsIn(PlayerPedId(), true), angle)
            end
        end
    end
end)
