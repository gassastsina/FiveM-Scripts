--------------------------------------
--------------------------------------
----    File : informant.lua      ----
----    Author: gassastsina       ----
----	Side : client 			  ----
----    Description : Informateur ----
--------------------------------------
--------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX           = nil
local PlayerData    = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-----------------------------------------------main-------------------------------------------------------
local pnj = {id = 1, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01", x=0.0, y=0.0, z=0.0, heading = 0.0}

local function heyPNJ()
    local PlayingAnim = false
    while true do
        Citizen.Wait(10)
        RequestAnimDict("random@shop_gunstore")
        while not HasAnimDictLoaded("random@shop_gunstore") do
            Citizen.Wait(10)
        end

        distance = GetDistanceBetweenCoords(pnj.x, pnj.y, pnj.z, GetEntityCoords(GetPlayerPed(-1)))
        if distance < 4 and not PlayingAnim then
            TaskPlayAnim(pnj.id,"random@shop_gunstore","_greeting", 1.0, -1.0, 4000, 0, 1, true, true, true)
            PlayAmbientSpeech1(pnj.id, pnj.VoiceName, "SPEECH_PARAMS_FORCE", 1)
            PlayingAnim = true
            Citizen.Wait(4000)
            if PlayingAnim == true then
                TaskPlayAnim(pnj.id,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
                Citizen.Wait(40000)
            end
        else
           
            --TaskPlayAnim(pnj.id,"random@shop_gunstore","_idle", 1.0, -1.0, -1, 0, 1, true, true, true)
        end
        if distance > 5.5 and distance < 6 then
            PlayingAnim = false
        end
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

    RequestModel(GetHashKey(pnj.modelHash))
    while not HasModelLoaded(GetHashKey(pnj.modelHash)) do
    	Wait(500)
    end
    ESX.TriggerServerCallback('informant:getPNJ', function(wichPNJ)
        pnj.x = Config.PNJSpawn[wichPNJ].x
        pnj.y = Config.PNJSpawn[wichPNJ].y
        pnj.z = Config.PNJSpawn[wichPNJ].z
        pnj.heading = Config.PNJSpawn[wichPNJ].heading

        pnj.id = CreatePed(2, pnj.modelHash, pnj.x, pnj.y, pnj.z, pnj.heading, false, true)
        SetPedFleeAttributes(pnj.id, 0, 0)
        SetAmbientVoiceName(pnj.id, pnj.Ambiance)
        SetPedDropsWeaponsWhenDead(pnj.id, false)
        SetPedDiesWhenInjured(pnj.id, false)
        GiveWeaponToPed(pnj.id, pnj.Weapon, 2800, false, true)

        PlayerData = xPlayer
        heyPNJ()
    end, math.random(1, #Config.PNJSpawn))
end)

Citizen.CreateThread(function()
    Wait(3000)
    local openedMenu = false
    while true do
        Wait(15)
        if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and not openedMenu and Vdist(pnj.x, pnj.y, pnj.z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
            SetTextComponentFormat('STRING')
            AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour parler à l'informateur")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(1, 38) then
                openedMenu = true
            	local elements = {}
            	for i=1, #Config.Menu, 1 do
            		if Config.Menu[i].name ~= 'illegalweapon' then
            			table.insert(elements, {realLabel = Config.Menu[i].label, label = Config.Menu[i].label.." - <span style='color:green;'>"..Config.Menu[i].price.."$</span>", x = Config.Menu[i].x, y = Config.Menu[i].y, z = Config.Menu[i].z, blipSprite = Config.Menu[i].blipSprite, price = Config.Menu[i].price, name = Config.Menu[i].name})
            		else
            			table.insert(elements, {realLabel = Config.Menu[i].label, label = Config.Menu[i].label.." - <span style='color:green;'>"..Config.Menu[i].price.."$</span>", x = Config.Menu[i].xM, y = Config.Menu[i].yM, z = Config.Menu[i].zM, blipSprite = Config.Menu[i].blipSprite, price = Config.Menu[i].price, name = Config.Menu[i].name})
            		end
            	end
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choice_information', {
                    title    = 'Informateur',
                    elements = elements,
                    },
                    function(data, menu)
                        local information = data.current
                        local blip = AddBlipForCoord(information.x, information.y, information.z)
                        ESX.TriggerServerCallback('informant:getPlayerMoney', function(PlayerMoney)
                        	if PlayerMoney >= information.price then
		                        SetBlipSprite (blip, information.blipSprite)
		                        SetBlipDisplay(blip, 4)
		                        SetBlipScale  (blip, 1.2)
		                        SetBlipAsShortRange(blip, true)

		                        BeginTextCommandSetBlipName("STRING")
		                        AddTextComponentString('Informateur de '..information.label)
		                        EndTextCommandSetBlipName(blip)
		                        
		                        if information.name == 'pussy' then
									BeginTextCommandSetBlipName("STRING")
			                        AddTextComponentString("Trafic d'êtres humains")
			                        EndTextCommandSetBlipName(blip)
		                        end

		                        TriggerServerEvent('informant:buyInformation', information.price)
		                        TriggerEvent('esx:showNotification', "Tiens, vas voir là-bas, il te donnera plus d'infos sur le/la "..information.realLabel)
		                        TriggerEvent('esx:showNotification', "Par contre souviens-toi en, chez moi rien n'est gratuit")
		                        if not IsWaypointActive() then
		                        	SetNewWaypoint(information.x, information.y)
		                        end
		                    else
		                    	TriggerEvent('esx:showNotification', "~r~Vous n'avez pas assez d'argent")
		                    end
	                    end)
                        menu.close()
                        openedMenu = false
                    end,
                    function(data, menu)
                        menu.close()
                        openedMenu = false
                    end
                )
            end
        elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' and Vdist(pnj.x, pnj.y, pnj.z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
        	TriggerEvent('esx:showNotification', "Dégages, j'parle pas aux condés")
        end
    end
end)