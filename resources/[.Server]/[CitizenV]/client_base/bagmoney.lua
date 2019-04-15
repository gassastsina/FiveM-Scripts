ESX               = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

local moneycash = 0
local moneyblack = 0

RegisterNetEvent("moneyget")
AddEventHandler("moneyget", function(money)
    moneycash = money
end)

RegisterNetEvent("moneygetB")
AddEventHandler("moneygetB", function(black)
    moneyblack = black
end)


Citizen.CreateThread(function()
    while true do
		TriggerServerEvent('getMoneyS')
		Wait(5000)
        if moneycash + moneyblack >= 25000 then
            SetPedComponentVariation(GetPlayerPed(-1), 5, 45, 0, 0)--sac
        else 
            SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0)--sac
        end
    end
end)