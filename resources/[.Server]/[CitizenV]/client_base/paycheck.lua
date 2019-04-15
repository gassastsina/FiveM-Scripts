
ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
PlayerData.job = job
end)
RegisterNetEvent('esx_pay:payCheck')
AddEventHandler('esx_pay:payCheck',function( payCheck)
	local payCheck = payCheck
	if PlayerData.job ~= nil and PlayerData.job.name == 'police'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'police', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'lo'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'lo', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'banker'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'banker', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'ambulance'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'ambulance', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'taxi'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'taxi', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'bus'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'bus', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'elitas'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'elitas', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'foodtruck'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'foodtruck', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'etat'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'etat', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'realestateagent'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'realestateagent', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'mecano'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'mecano', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'justice'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'etat', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'reporter'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'etat', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'securoserv'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'etat', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'secretservice'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'etat', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'fuel'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'fuel', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'lumberjack'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'lumberjack', payCheck) 
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'patriot'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'patriot', payCheck)
	elseif PlayerData.job ~= nil and PlayerData.job.name == 'unemployed'  then
		TriggerServerEvent('esx_society:withdrawMoney', 'etat', payCheck)
	end
end)