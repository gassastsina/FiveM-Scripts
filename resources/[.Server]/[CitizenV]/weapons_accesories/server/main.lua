ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('silencieux', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)	
    TriggerClientEvent('esx_basicneeds:silencieux', source)
	
end)

ESX.RegisterUsableItem('scope', function(source)
    local xPlayer = ESX.GetPlayerFromId(source) 
    TriggerClientEvent('esx_basicneeds:scope', source)
    
end)

ESX.RegisterUsableItem('flashlight', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)	
	
    TriggerClientEvent('esx_basicneeds:flashlight', source)
	
end)

ESX.RegisterUsableItem('grip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
		
    TriggerClientEvent('esx_basicneeds:grip', source)
	
end)


ESX.RegisterUsableItem('yusuf', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('esx_basicneeds:yusuf', source)

end)

