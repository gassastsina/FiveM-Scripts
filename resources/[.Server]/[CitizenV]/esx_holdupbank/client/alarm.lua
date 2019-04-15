local loop = true
function alwaysSound(soundFile)
    SetTimeout(9000, function()
        if loop then
            SendNUIMessage({
                transactionType     = 'playSound',
                transactionFile     = soundFile,
                transactionVolume   = Config.AlarmSound
            })
            alwaysSound(soundFile)
        end
    end)
end

function loop(loop, lCoords, eCoords, maxDistance, soundFile)
	local soundVolume = Config.AlarmSound
    local maxSoundVolume = soundVolume
    alwaysSound(soundFile)
    while loop do
        Wait(100)
        local lCoords = GetEntityCoords(GetPlayerPed(-1))
        local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)

        if distIs <= maxDistance then
            soundVolume = maxSoundVolume/(maxDistance/(maxDistance-distIs))
        end
        SendNUIMessage({
            transactionType     = 'loop',
            transactionVolume   = Config.AlarmSound
        })
    end
end

RegisterNetEvent('alarm:PlayWithinDistance')
AddEventHandler('alarm:PlayWithinDistance', function(maxDistance, soundFile, eCoords)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)

    if distIs <= maxDistance then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = Config.AlarmSound
        })
        loop(loop, lCoords, eCoords, maxDistance, soundFile)
    end
end)

RegisterNetEvent('alarm:stop')
AddEventHandler('alarm:stop', function()
    loop = false
    SendNUIMessage({
        transactionType     = 'stop'
    })
end)