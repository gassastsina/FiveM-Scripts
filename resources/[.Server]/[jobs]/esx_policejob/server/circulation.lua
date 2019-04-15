------------------------------------------------
------------------------------------------------
----    File : circulation.lua              ----
----    Author: gassastsina               	----
----	Side : server 						----
----    Description : Bloque la circulation ----
------------------------------------------------
------------------------------------------------

--------------------------------------------ESX----------------------------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----------------------------------------circulation------------------------------------------------------
local stopList = {}
RegisterServerEvent('circulation:addStop')
AddEventHandler('circulation:addStop', function(x, y, z, street)
	table.insert(stopList, {coords={x=x, y=y, z=z}, street=street})
	sendBackStopList()
end)

ESX.RegisterServerCallback('circulation:getStopList', function(source, cb)
	cb(stopList)
end)

RegisterServerEvent('circulation:removeStop')
AddEventHandler('circulation:removeStop', function(i)
	table.remove(stopList, i)
	sendBackStopList()
end)

function sendBackStopList()
	local tempCoords = {}
	for i=1, #stopList, 1 do
		table.insert(tempCoords, stopList[i].coords)
	end
	TriggerClientEvent('circulation:ClearArea', -1, tempCoords)
end