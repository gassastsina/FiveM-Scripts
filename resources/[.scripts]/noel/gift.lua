RegisterNetEvent('noël:ChristmasSong')
AddEventHandler('noël:ChristmasSong', function(item)
	SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = 'christmas',
        transactionVolume   = 0.1
    })
end)