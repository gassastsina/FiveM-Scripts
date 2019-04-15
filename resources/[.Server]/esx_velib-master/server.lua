ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_velib:TakeVelib')
AddEventHandler('esx_velib:TakeVelib',function()
	ESX.GetPlayerFromId(source).removeMoney(140)
end)

RegisterServerEvent('esx_velib:rentedVehicle')
AddEventHandler('esx_velib:rentedVehicle',function()
	ESX.GetPlayerFromId(source).addMoney(100)
end)