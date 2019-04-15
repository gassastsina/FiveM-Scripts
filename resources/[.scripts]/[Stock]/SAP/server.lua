---------------------------------------------
---------------------------------------------
----    File : server.lua              	 ----
----    Author : gassastsina             ----
----	Side : server 					 ----
----    Description : San Andreas Petrol ----
---------------------------------------------
---------------------------------------------

------------------------------------------------ESX------------------------------------------------------
ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------------------main------------------------------------------------------
TriggerEvent('esx_society:registerSociety', 'sap', 'San Andreas Petrol', 'society_sap', 'society_sap', 'society_sap', {type = 'private'})

RegisterServerEvent('nb:openMenuSAP')
AddEventHandler('nb:openMenuSAP', function()
	local _source = source
	MySQL.Async.fetchAll("SELECT * FROM `gas_stations` WHERE 1", {}, function(result)
		TriggerClientEvent('SAP:openMenuSAP', _source, result)
	end)
end)

ESX.RegisterServerCallback('SAP:getStations', function(source, cb)
	MySQL.Async.fetchAll("SELECT * FROM `gas_stations` WHERE 1", {}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('SAP:removePetrolFromStation')
AddEventHandler('SAP:removePetrolFromStation', function(index, quantity)
	MySQL.Async.execute('UPDATE `gas_stations` SET `quantity`=`quantity` - '..quantity..' WHERE `stationNumber`=@stationNumber', {
		['@stationNumber'] = index
	})
end)

-----------------------------------------------RUN-------------------------------------------------------
--Sell to stations
local PlayersSellingPetrol = {}
local function SellPetrol(_source, station)
	SetTimeout(10000, function()
		if PlayersSellingPetrol[_source] then
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer.getInventoryItem('essence').count > 0 then
				xPlayer.removeInventoryItem('essence', 1)
				MySQL.Async.execute('UPDATE `gas_stations` SET `quantity`=`quantity` + 100 WHERE `stationNumber`=@stationNumber', {
					['@stationNumber'] = station.stationNumber
				})
		        xPlayer.addMoney(100)
				TriggerEvent('esx_addonaccount:getSharedAccount', "society_sap", function(account)
					account.addMoney(20)
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'essence à livrer")
			end
		end
	end)
end

RegisterServerEvent('SAP:StartSellPetrol')
AddEventHandler('SAP:StartSellPetrol', function(station)
	local _source = source
	TriggerEvent('SAP:stopSelling', _source)
	Wait(1000)
	PlayersSellingPetrol[_source] = true
	TriggerClientEvent('esx:showNotification', _source, "~y~Livraison d'essence~s~ en cours...")
	SellPetrol(_source, station)
end)

--Petrol cans treatment
local PlayersTreatmentPetrolCan = {}
local function TreatmentPetrolCans(_source)
	SetTimeout(4000, function()
		if PlayersTreatmentPetrolCan[_source] then
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer.getInventoryItem('essence').count > 0 and xPlayer.getInventoryItem('petrol_can').count > 0 then
				xPlayer.removeInventoryItem('essence', 1)
				xPlayer.removeInventoryItem('petrol_can', 1)
				xPlayer.addWeapon("WEAPON_PETROLCAN", 250)
				TriggerClientEvent('essence:buyCan', _source)

				TriggerClientEvent('SAP:SetInMarker', _source, false)
			else
				TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'essence ou de jerricans")
			end
		end
	end)
end

RegisterServerEvent('SAP:StartTreatmentPetrolCan')
AddEventHandler('SAP:StartTreatmentPetrolCan', function()
	local _source = source
	TriggerEvent('SAP:StopFarming', _source)
	Wait(1000)
	PlayersTreatmentPetrolCan[_source] = true
	TriggerClientEvent('esx:showNotification', _source, "~y~Remplissage des jerricans en cours...")
	TreatmentPetrolCans(_source)
end)

RegisterServerEvent('SAP:StopFarming')
AddEventHandler('SAP:StopFarming', function(player)
	PlayersSellingPetrol[source or player] 		= false
	PlayersTreatmentPetrolCan[source or player] = false
end)