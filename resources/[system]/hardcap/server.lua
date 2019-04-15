----------------------------------------------main--------------------------------------------------------
local playerCount = 0
local list = {}

RegisterServerEvent('hardcap:playerActivated')
AddEventHandler('hardcap:playerActivated', function()
  if not list[source] then
    playerCount = playerCount + 1
    list[source] = true
  end
end)

AddEventHandler('playerDropped', function()
	if list[source] then
		playerCount = playerCount - 1
		list[source] = nil
	end
end)

AddEventHandler('playerConnecting', function(name, setReason)
	local cv = GetConvarInt('sv_maxclients', 32)

	print('Connecting: ' .. name)
	local identifiers = GetPlayerIdentifiers(source)
	if identifiers[3] ~= nil then
		identifiers = identifiers[1]
	else
		identifiers = identifiers[2]
	end
	TriggerEvent('logs:write', "Connecting...", source, name, json.encode(identifiers))

	if playerCount >= cv then
		print('Full. :('..tostring(playerCount)..'/'..tostring(cv)..")")
		TriggerEvent('logs:write', "A essayé de se connecter alors que le serveur est full ("..tostring(playerCount)..'/'..tostring(cv)..")", source, name, json.encode(identifiers))

		setReason('LS Nights est actuellement complet, merci de réessayer ultérieurement et de ne pas spam la connection (' .. tostring(cv) .. ' joueurs).')
		CancelEvent()
	end
end)