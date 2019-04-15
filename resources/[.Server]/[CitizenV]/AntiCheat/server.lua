ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local status = true
local enableAcVote = 0

local allPlayers = {}
local antiCheatRunning = true
local banlist = {}

ESX.RegisterServerCallback('AntiCheat:GetAntiCheatStatus', function(source, cb)	
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	if group ~= 'user' and Config[1].adminBypass then
		cb(false)
	else
		cb(status)
	end
end)

local function txtLogs(reason, identifier)
	file = io.open( "resources/[.Server]/[CitizenV]/AntiCheat/AntiCheatLogs.txt", "a")
	local time = os.date()
    if file then
        file:write('['..time..'] '..identifier..' : '..reason)
        file:write("\n")
    end
    file:close()
end

RegisterServerEvent("AntiCheat:antiCheatIsRunning")
AddEventHandler("AntiCheat:antiCheatIsRunning", function()
	antiCheatRunning = true
end)

AddEventHandler('onMySQLReady', function()
	MySQL.Async.fetchAll('SELECT * FROM `banlist`', {},
		function(result)
			banlist = result
		end
	)
end)

local function advertAdmin(message)
	for i = 1 , #allPlayers do
		local xPlayer = ESX.GetPlayerFromId(allPlayers[i])
		if xPlayer.getGroup() ~= 'user' then
			TriggerClientEvent('esx:showNotification', xPlayer.source, message)
		end
	end
end
local function ban(xPlayer,reason)
	local ip = GetPlayerEP(xPlayer.source)
	print(ip)
	MySQL.Async.execute(
		'INSERT INTO `banlist` (`identifier`, `reason`, `ip`) VALUES (@identifier, @reason,@ip)',
		{
			['@identifier'] = xPlayer.identifier,
			['@reason']     = reason,
			['@ip'] = ip

		}, function(rowsChanged)
			table.insert(banlist,{identifier = xPlayer.identifier,reason = reason,ip = ip})	
			if Config[1].action == 2 then
				xPlayer.kick(reason)	
			end
		end
	)
	TriggerEvent('es_admin:ban', xPlayer.source)
end

AddEventHandler("playerConnecting", function(name, setReason)
	local _source = source
	MySQL.Async.fetchAll('SELECT * FROM `banlist`', {},
		function(result)
			banlist = result
		end
	)
	--local identifier = GetPlayerIdentifiers(_source)[1]
	local ip = GetPlayerEP(_source)
	--print(ip)
	if banlist ~= nil then
		for i=1, #banlist do
			if banlist[i].identifier == GetPlayerIdentifiers(_source)[1] or banlist[i].ip == ip then
				TriggerEvent('logs:writeWhiteoutPlayer', Config[1].adminDiscordID.." A essayé de se connecté alors qu'il est ban : "..tostring(json.encode(GetPlayerIdentifiers(_source))))
				setReason('Vous êtes ban de ce serveur : '..banlist[i].reason)
				CancelEvent()
				break
			--elseif identifier == nil then
				--setReason("Steam is required")
				--CancelEvent()
			end
		end
	end
	if Config[1].scanVpn then
		for i = 1 ,#Config[1].blackListIp do
			if Config[1].blackListIp[i].ip == ip then
				TriggerEvent('logs:write', Config[1].adminDiscordID.." A essayé de se connecté avec un VPN : "..tostring(GetPlayerIdentifiers(_source)), _source)
				setReason('Les VPN ne sont pas autorisés sur le serveur')
				CancelEvent()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while Config[1].scanAcEnable do
		Wait(Config[1].scanEveryMs)
		if status then
			allPlayers = ESX.GetPlayers()
			for i = 1, #allPlayers do
				--print('checkIfAntiCheatClientIsRunnig')
				local xPlayer = ESX.GetPlayerFromId(allPlayers[i])
				antiCheatRunning = false
				TriggerClientEvent('checkAntiCheatRunning', allPlayers[i])
				for y=1,10 do
		 			Citizen.Wait(1000)
		 			if antiCheatRunning then
		 				break
		 			end
				end
				if not antiCheatRunning then
					TriggerEvent('logs:write', Config[1].adminDiscordID.." L'AntiCheat ne tourne pas. Il a probablement été désactivé par le joueur ou par une erreur du script", allPlayers[i])
					if Config[1].txtLogs then
						txtLogs("L'AntiCheat ne tourne pas. Il a probablement été désactivé par le joueur ou par une erreur du script", xPlayer.identifier)
					end
					--[[if Config[1].discordLogs.use then
						sendToDiscord(xPlayer.identifier..' AntiCheat Client Is Not Running probably disable by the player or scripting error The player is only kicked')
					end]]
					if Config[1].advertAdmin then
						advertAdmin('~r~'..xPlayer.identifier..' Un cheateur a été détecté')
					end
					if xPlayer.getGroup() ~= 'user' or not Config[1].adminBypass then
						xPlayer.kick("Une erreur de l'AntiCheat est survenue")
					end
				end
			end
		end
	end
end)



--[[AddEventHandler("chatMessage",function(Source,Name,Msg)
	if Msg:sub(1,6) == "/runAC" then
		local _source = Source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local time = os.time()
		if xPlayer.getGroup() ~= 'user' then
			print('Starting antiCheat request [ '..time..' ]')
			status = true
			TriggerClientEvent('AntiCheat:updateStatus',-1,status)
			if Config[1].txtLogs then
				txtLogs(xPlayer.identifier,' Starting antiCheat request [ '..time..' ]')
			end
			if Config[1].discordLogs.use then
				sendToDiscord(' Starting antiCheat request [ '..time..' ]')
			end
			TriggerEvent('AntiCheat:StartCheck')
		end
	elseif Msg:sub(1,12) == "/stopAC" then
		if xPlayer.getGroup() ~= 'user' then
			status = false
			print('stop antiCheat request ')
			TriggerClientEvent('AntiCheat:updateStatus',-1,status)
			enableAcVote = 0
			if Config[1].txtLogs then
				txtLogs(xPlayer.identifier,'stop antiCheat request [ '..time..' ]')
			end
			if Config[1].discordLogs.use then
				sendToDiscord(xPlayer.identifier..' stop antiCheat request  [ '..time..' ]')
			end
		end
	end
end)]]

RegisterServerEvent("AntiCheat:flagPlayer")
AddEventHandler("AntiCheat:flagPlayer", function(reason)
	local reason = reason
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if Config[1].action == 1 or Config[1].action == 3 then
		ban(xPlayer,"Nous avons détecté un cheat")

	elseif Config[1].action == 2 then
		xPlayer.kick("Nous avons détecté un cheat")
	end
	if Config[1].discordLogs.use then
		--local time = os.date()
		--sendToDiscord(GetPlayerName(source..': '..Config.discordLogs.webWook,reason..' ['..time..'] '))
		TriggerEvent('logs:write', Config[1].adminDiscordID.." "..reason, _source)
	end
	if Config[1].txtLogs then
		txtLogs(reason, xPlayer.identifier)
	end
end)