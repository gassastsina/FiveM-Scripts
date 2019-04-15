--------------------------------
--------------------------------
----    File : server.lua   ----
----    Author: gassastsina	----
----	Side : server 		----
----    Description : Logs 	----
--------------------------------
--------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---------------------------------------------main--------------------------------------------------------
local function GetPlayerIP(_source)
	if ESX.GetPlayerFromId(_source).getGroup() == 'user' then
		return GetPlayerIdentifiers(_source)[3]
	end
	return ""
end

RegisterServerEvent("logs:write")
AddEventHandler("logs:write", function(message, player, name, identifiers)
	local xPlayer = player or source

	if identifiers == nil then
		identifiers = ESX.GetPlayerFromId(xPlayer).getIdentifier()
	end
	message = (name or GetPlayerName(xPlayer)).." ("..identifiers..") : "..message
	PerformHttpRequest('https://discordapp.com/api/webhooks/000000000000000000/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', function(err, text, headers) end, 'POST', json.encode({username = 'LOGS', content = message}), { ['Content-Type'] = 'application/json' })

    local file = io.open("logs.txt", "a")
	if file then
		message = "["..os.date("%c").."] ("..GetPlayerIP(xPlayer)..") "..message
 		--print(message)
  		file:write(message)
  		file:write("\n")
        file:close()
	end
end)

RegisterServerEvent("logs:writeServerOnly")
AddEventHandler("logs:writeServerOnly", function(message, player)
	local xPlayer = player or source

    local file = io.open("logs.txt", "a")
	if file then
		message = "["..os.date("%c").."] ("..GetPlayerIP(xPlayer)..") "..GetPlayerName(xPlayer).." ("..ESX.GetPlayerFromId(xPlayer).getIdentifier()..") : "..message
 		--print(message)
  		file:write(message)
  		file:write("\n")
        file:close()
	end
end)

RegisterServerEvent("logs:writeWhiteoutPlayer")
AddEventHandler("logs:writeWhiteoutPlayer", function(message)
	PerformHttpRequest('https://discordapp.com/api/webhooks/000000000000000000/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', function(err, text, headers) end, 'POST', json.encode({username = 'LOGS', content = message}), { ['Content-Type'] = 'application/json' })

    local file = io.open("logs.txt", "a")
	if file then
		message = "["..os.date("%c").."] "..message
 		--print(message)
  		file:write(message)
  		file:write("\n")
        file:close()
	end
end)


Citizen.CreateThread(function()
	TriggerEvent('logs:writeWhiteoutPlayer', '==============================================================================')
	Wait(60)
	TriggerEvent('logs:writeWhiteoutPlayer', '==============================================================================')
	Wait(60)
	TriggerEvent('logs:writeWhiteoutPlayer', '					                                              SERVER STARTING...')
	Wait(60)
	TriggerEvent('logs:writeWhiteoutPlayer', '==============================================================================')
	Wait(60)
	TriggerEvent('logs:writeWhiteoutPlayer', '==============================================================================')
end)