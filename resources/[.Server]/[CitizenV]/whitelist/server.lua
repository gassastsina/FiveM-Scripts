-- Script made by Havanna (http://steamcommunity.com/id/HavannaPC/)
-- Edited by gassastsina
AddEventHandler( "playerConnecting", function(name, setReason)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	local hour = tonumber(os.date('%H', os.time()))
	if not isWhiteListed(identifier) and (hour >= 20 or hour <= 8) then
		setReason("Le serveur est whitelisté de 20h à 8h (H FR), pour vous faire whitelist, rejoignez nous sur le discord ou si vous l'êtes déjà, essayez de redémarrer Steam + FiveM")
		--setReason("Vous n'êtes pas whitelist sur le serveur, rejoignez nous sur le discord : discord.gg/xxxxxxx")
		print("(" .. identifier .. ") " .. name .. " has been kicked because he is not WhiteListed")
		TriggerEvent('logs:write', "A essayé de se connecter sans être whitelist", nil, name, GetPlayerIdentifiers(_source)[1])
		CancelEvent()
    end
end)

-- Chat Command to add someone in WhiteList
TriggerEvent('es:addGroupCommand', 'wladd', "admin", function(source, args, user)
	if #args == 2 then
		if isWhiteListed(args[2]) then
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " is already whitelisted!")
		else
			addWhiteList(args[2])
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " has been whitelisted!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect identifier!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Chat Command to remove someone in WhiteList
TriggerEvent('es:addGroupCommand', 'wlremove', "admin", function(source, args, user)
	if #args == 2 then
		if isWhiteListed(args[2]) then
			removeWhiteList(args[2])
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " is no longer whitelisted!")
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, args[2] .. " is not whitelisted from!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect identifier!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

function addWhiteList(identifier)
	MySQL.Sync.execute("INSERT INTO user_whitelist (`identifier`, `whitelisted`) VALUES (@identifier, @whitelisted)",{['@identifier'] = identifier, ['@whitelisted'] = 1})
end

function removeWhiteList(identifier)
	MySQL.Sync.execute("DELETE FROM user_whitelist WHERE identifier = @identifier", {['@identifier'] = identifier})
end

function isWhiteListed(identifier)
	local result = MySQL.Sync.fetchScalar("SELECT identifier FROM whitelist WHERE identifier = @username ", {['@username'] = identifier})
	if result then
		return true
	end
	return false
end

-- Rcon command to add/remove someone in WhiteList
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'wladd' then
		if #args ~= 1 then
			RconPrint("Usage: whitelistadd [identifier]\n")
			CancelEvent()
			return
		end
		if isWhiteListed(args[1]) then
			RconPrint(args[1] .. " is already whitelisted!\n")
			CancelEvent()
		else
			addWhiteList(args[1])
			RconPrint(args[1] .. " has been whitelisted!\n")
			CancelEvent()
		end
	elseif commandName == 'wlremove' then
		if #args ~= 1 then
			RconPrint("Usage: whitelistremove [identifier]\n")
			CancelEvent()
			return
		end
		if isWhiteListed(args[1]) then
			removeWhiteList(args[1])
			RconPrint(args[1] .. " is no longer whitelisted!\n")
			CancelEvent()
		else
			RconPrint(args[1] .. " is not whitelisted!\n")
			CancelEvent()
		end
	end
end)