Citizen.CreateThread(function()
SetMaxWantedLevel(0)
DisablePlayerVehicleRewards(GetPlayerPed(-1))
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            SetPoliceIgnorePlayer(PlayerId(), true)
            SetDispatchCopsForPlayer(PlayerId(), false)
            SetDitchPoliceModels()
        end

        local playerPed = GetPlayerPed(-1)
        local playerLocalisation = GetEntityCoords(playerPed)
        --ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
        DisablePlayerVehicleRewards(PlayerId(-1))
    end
end)

Citizen.CreateThread(function()
    for i = 1, 12 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
end)