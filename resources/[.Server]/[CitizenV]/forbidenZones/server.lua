--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----    File : server.lua                                                   ----
----    Author: gassastsina                                                 ----
----	Side : server 														----
----    Description : Alerte la police quand un joueur rentre dans une zone ----
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX 						   		= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main-------------------------------------------------------
RegisterServerEvent('forbidenZones:enterInZone')
AddEventHandler('forbidenZones:enterInZone', function(sex, i)
    local xPlayers = ESX.GetPlayers()
    for x=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[x])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('forbidenZones:enterInZone', xPlayers[x], sex, i)
        end
    end
end)