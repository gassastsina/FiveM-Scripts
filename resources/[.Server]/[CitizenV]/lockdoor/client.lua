-- [[-----------------------------------------------------------------------

    -- fivem_doors - Open/Close doors at Mission Row Police Departement and Innocence Boulevard Mortuary
    -- Script By SGTGunner version 1.0
    -- Edited By gassastsina

    -- Main Client file

-- ---------------------------------------------------------------------]]--
ESX                           = nil

local PlayerData              = {}
local doorList = {}

RegisterNetEvent('lockdoor:updateDoorStatusCb')
AddEventHandler('lockdoor:updateDoorStatusCb', function(door)
	doorList = door
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(300)
	end
    ESX.TriggerServerCallback('lockdoor:getStatusDoor', function(door)
        doorList = door
    end)
end)

local function DrawText3d(x, y, z, text, status)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.2, 0.2)
        SetTextFont(0)
        SetTextProportional(1)
        if status then
        	SetTextColour(255, 0, 0, 255)
        else
        	SetTextColour(0, 255, 0, 255)
        end
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local function drawTextStatusDoor(i)
    if doorList[i]["locked"] then
        DrawText3d(doorList[i]["txtX"], doorList[i]["txtY"], doorList[i]["txtZ"], "[E] pour ouvrir la porte", doorList[i]["locked"])
    else
        DrawText3d(doorList[i]["txtX"], doorList[i]["txtY"], doorList[i]["txtZ"], "[E] pour fermer la porte", doorList[i]["locked"])
    end
end


Citizen.CreateThread(function()
    Wait(3000)
    while true do
        Citizen.Wait(5)
        for i = 1, #doorList do
            local playerCoords = GetEntityCoords( GetPlayerPed(-1) )
            local playerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], true)

            if playerDistance < 10.0 then
	            if playerDistance < 2.0 and PlayerData.job ~= nil then

	                if i <= 18 and PlayerData.job.name == 'police' then
	                    drawTextStatusDoor(i)

	                elseif i > 18 and PlayerData.job.name == 'ambulance' then
	                    drawTextStatusDoor(i)
	                end

	                if IsControlJustPressed(1, 51) then
	                    if PlayerData.job.name == 'police' then
	                        --LSPD

	                        if(i==10 or i==11) then
	                            doorList[10]["locked"] = not doorList[10]["locked"]
	                            doorList[11]["locked"] = not doorList[11]["locked"]
	                        elseif(i==12 or i==13) then
	                            doorList[12]["locked"] = not doorList[12]["locked"]
	                            doorList[13]["locked"] = not doorList[13]["locked"]
	                        elseif(i==4 or i==5) then
	                            doorList[4]["locked"] = not doorList[4]["locked"]
	                            doorList[5]["locked"] = not doorList[5]["locked"]
	                        elseif(i==15 or i==16) then
	                            doorList[15]["locked"] = not doorList[15]["locked"]
	                            doorList[16]["locked"] = not doorList[16]["locked"]
	                        elseif i <= 18 then
	                            doorList[i]["locked"] = not doorList[i]["locked"]
	                        end
	                    
	                    elseif PlayerData.job.name == 'ambulance' then
	                        --EMS
	                        --Portes salles d'opération
	                        if(i==19 or i==20) then
	                            doorList[19]["locked"] = not doorList[19]["locked"]
	                            doorList[20]["locked"] = not doorList[20]["locked"]
	                        elseif(i==21 or i==22) then
	                            doorList[21]["locked"] = not doorList[21]["locked"]
	                            doorList[22]["locked"] = not doorList[22]["locked"]
	                        elseif(i==23 or i==24) then
	                            doorList[23]["locked"] = not doorList[23]["locked"]
	                            doorList[24]["locked"] = not doorList[24]["locked"]
	                        elseif(i==25 or i==26) then
	                            doorList[25]["locked"] = not doorList[25]["locked"]
	                            doorList[26]["locked"] = not doorList[26]["locked"]
	                        elseif(i==27 or i==28) then
	                            doorList[27]["locked"] = not doorList[27]["locked"]
	                            doorList[28]["locked"] = not doorList[28]["locked"]
	                        --Portes coupes feux
	                        elseif(i==29 or i==30) then
	                            doorList[29]["locked"] = not doorList[29]["locked"]
	                            doorList[30]["locked"] = not doorList[30]["locked"]
	                        elseif(i==31 or i==32) then
	                            doorList[31]["locked"] = not doorList[31]["locked"]
	                            doorList[32]["locked"] = not doorList[32]["locked"]
	                        elseif(i==33 or i==34) then
	                            doorList[33]["locked"] = not doorList[33]["locked"]
	                            doorList[34]["locked"] = not doorList[34]["locked"]
	                        --Portes vitrés
	                        elseif(i==37 or i==38) then
	                            doorList[37]["locked"] = not doorList[37]["locked"]
	                            doorList[38]["locked"] = not doorList[38]["locked"]
	                        elseif(i==39 or i==40) then
	                            doorList[39]["locked"] = not doorList[39]["locked"]
	                            doorList[40]["locked"] = not doorList[40]["locked"]
	                        elseif(i==41 or i==42) then
	                            doorList[41]["locked"] = not doorList[41]["locked"]
	                            doorList[42]["locked"] = not doorList[42]["locked"]
	                        elseif(i==43 or i==44) then
	                            doorList[43]["locked"] = not doorList[43]["locked"]
	                            doorList[44]["locked"] = not doorList[44]["locked"]
	                        elseif(i==45 or i==46) then
	                            doorList[45]["locked"] = not doorList[45]["locked"]
	                            doorList[46]["locked"] = not doorList[46]["locked"]
	                        elseif i >= 19 then
	                            doorList[i]["locked"] = not doorList[i]["locked"]
	                        end
	                    end
	                    TriggerServerEvent('lockdoor:updateDoorStatus', doorList)
	                    Citizen.Wait(100)
	                end
	            end
                FreezeEntityPosition(GetClosestObjectOfType(doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], 1.0, GetHashKey(doorList[i]["objName"]), false, false, false), doorList[i]["locked"])
            end
        end
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