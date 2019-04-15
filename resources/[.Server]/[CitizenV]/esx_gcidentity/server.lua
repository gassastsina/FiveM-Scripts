-----------------------------------------
-----------------------------------------
----    File : server.lua       	 ----
----    Author : Jonathan D @ Gannon ----
----    Edited 1 by : Chubbs (ADRP)	 ----
----    Edited 2 by : gassastsina 	 ----
----    Side : server         		 ----
----    Description : Identity 		 ----
-----------------------------------------
-----------------------------------------

function getIdentity(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier", {['@identifier'] = identifier},
  function(result)
    if result[1]['firstname'] ~= nil then
      local data = {
        identifier    = result[1]['identifier'],
        firstname     = result[1]['firstname'],
        lastname      = result[1]['lastname'],
        dateofbirth   = result[1]['dateofbirth'],
        sex           = result[1]['sex'],
        height        = result[1]['height'],
        job        = result[1]['numCard'],
      }
      callback(data)
    else
      local data = {
        identifier    = '',
        firstname     = '',
        lastname      = '',
        dateofbirth   = '',
        sex           = '',
        height        = ''
      }
      callback(data)
    end
  end)
end




RegisterServerEvent('gc:openIdentity')
AddEventHandler('gc:openIdentity',function(other)
	local _source = source
	local player = tonumber(other)
    getIdentity(source, function(data)
        local gender
        if data.sex == "m" then
            gender = "h"
        elseif data.sex == "f" then
            gender = "f"
        end
        TriggerClientEvent('gc:showItentity', player, {
            nom = data.lastname,
            prenom = data.firstname,
            dateNaissance = tostring(data.dateofbirth),
            sexe = gender,
            jobs = data.job,
            taille = data.height,
            id = identifier
        }, _source)
    end)
	TriggerEvent('logs:write', "A montré sa carte d'identité à "..GetPlayerName(player), _source)
end)

RegisterServerEvent('gc:openMeIdentity')
AddEventHandler('gc:openMeIdentity',function()
	local player = source
    getIdentity(source, function(data)
        local gender
        if data.sex == "m" then
            gender = "h"
        elseif data.sex == "f" then
            gender = "f"
        end
        TriggerClientEvent('gc:showItentity', player, {
            nom = data.lastname,
            prenom = data.firstname,
            dateNaissance = tostring(data.dateofbirth),
            sexe = gender,
            jobs = data.job,
            taille = data.height,
            id = identifier
        }, 'me')
    end)
	TriggerEvent('logs:write', "Regarde sa carte d'identité", source)
end)