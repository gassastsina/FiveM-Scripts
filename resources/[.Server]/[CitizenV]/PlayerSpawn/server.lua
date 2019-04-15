-------------------------------------------------------------
-------------------------------------------------------------
----    File : server.lua       		   				 ----
----    Author : gassastsina    		   				 ----
----    Side : server         			   				 ----
----    Description : Player spawn with switch animation ----
-------------------------------------------------------------
-------------------------------------------------------------

RegisterServerEvent('PlayerSpawn:getPlayerReSpawnCoords')
AddEventHandler('PlayerSpawn:getPlayerReSpawnCoords', function()
	local _source = source
	--[[MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier=@identifier', {['@identifier'] = GetPlayerIdentifiers(_source)[1]}, function(result)
		if result[1].vip == 1 then]]
			MySQL.Async.fetchAll('SELECT `position` FROM users WHERE identifier=@identifier', {
		      ['@identifier'] = GetPlayerIdentifiers(_source)[1]
		    },
		    function(position)
				if position[1] ~= nil then
		      		TriggerClientEvent('PlayerSpawn:getPlayerReSpawnCoords', _source, json.decode(position[1].position))
				else
					TriggerClientEvent('PlayerSpawn:getPlayerReSpawnCoords', _source, { x = 402.865, y = -996.782, z = -99.000, heading = 177.000 })
				end
		    end
		  	)
		--[[else
			DropPlayer(_source, 'Reviens Vendredi à 20h ;)')
		end
	end)]]
end)