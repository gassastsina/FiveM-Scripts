RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setCallback)
  	local identifiers = GetPlayerIdentifiers(source)
  	local steamID = string.upper(string.sub(identifiers[1], 7))

  	if(string.sub(identifiers[1], 1, 5) ~= "steam") then
		setCallback("Steam est obligatoire pour rejoindre notre serveur !")
		TriggerEvent('logs:write', "A essayé de se connecter sans steam", source)
		CancelEvent()
	end
end)