------------------------------------
------------------------------------
----    File : client.lua       ----
----    Edited by : gassastsina ----
----    Side : client         	----
----    Description : Teleports ----
------------------------------------
------------------------------------

ESX                             = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5)
	end
end)

Citizen.CreateThread(function()                                      
    while true do
    Wait(1000)
    --du 1er a gauche vers 49 eme
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 136.053, -761.473, 45.752, true) < 1.599 then --X:5309.519 Y:-5212.375 Z:83.522
            DoScreenFadeOut(1000)
            while IsScreenFadingOut() do Citizen.Wait(0) end
            NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
            Wait(1000)
            SetEntityCoords(GetPlayerPed(-1), 137.990, -765.063, 242.152)
            SetEntityHeading(GetPlayerPed(-1), 0.000)
            NetworkFadeInEntity(GetPlayerPed(-1), 0)
            Wait(1000)
            SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
            DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end

        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 151.580+5, -761.257+3.9, 258.152, true) < 1.599 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 141.19, -766.283, 45.752)
           SetEntityHeading(GetPlayerPed(-1), 0.000)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 138.926, -763.032, 45.752, true) < 1.599 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 151.191, -762.269, 258.152)
           SetEntityHeading(GetPlayerPed(-1), 0.000)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 137.836-2.4, -765.824+3.5, 242.152-1, true) < 1.599 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 141.19, -766.283, 45.752)
           SetEntityHeading(GetPlayerPed(-1), 0.000)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 115.212, -742.180, 258.152, true) < 1.599 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 139.385, -771.626, 250.172)
           SetEntityHeading(GetPlayerPed(-1), 0.000)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 115.230, -733.917, 250.166, true) < 1.599 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 151.682, -761.526, 258.152)
           SetEntityHeading(GetPlayerPed(-1), 0.000)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        --club comédy
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -430.170, 261.787, 83.004, true) < 1.0 then
          --DoScreenFadeOut(1000)
          --while IsScreenFadingOut() do Citizen.Wait(0) end
           --NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           --Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -458.581, 284.575, 78.521)
           SetEntityHeading(GetPlayerPed(-1), 261.7565 )
           --NetworkFadeInEntity(GetPlayerPed(-1), 0)
           --Wait(1000)
           --SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
          -- DoScreenFadeIn(1000)
           -- while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(10000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -458.581, 284.575, 78.521, true) < 1.0 then
         -- DoScreenFadeOut(1000)
         -- while IsScreenFadingOut() do Citizen.Wait(0) end
          -- NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
          -- Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -430.170, 261.787, 83.004)
           SetEntityHeading(GetPlayerPed(-1), 174.000 )
          -- NetworkFadeInEntity(GetPlayerPed(-1), 0)
          -- Wait(1000)
           --SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           --DoScreenFadeIn(1000)
           -- while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(10000)
        end
    end
end)
---------------------------------------------------------------------------------------------------------
----------------------------------------------BAHAMAS----------------------------------------------------
---------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()   
  local blip = AddBlipForCoord(135.828, -1288.242, 28.269)
  SetBlipSprite (blip, 93)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.0)
  SetBlipColour (blip, 0)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Bar")
  EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()   
  local blip = AddBlipForCoord(-1393.409, -606.624, 29.319)
  SetBlipSprite (blip, 93)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.0)
  SetBlipColour (blip, 0)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Bar")
  EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()   
  local blip = AddBlipForCoord(-561.798, 289.825, 80.176)
  SetBlipSprite (blip, 93)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 1.0)
  SetBlipColour (blip, 0)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Bar")
  EndTextCommandSetBlipName(blip)
end)


--unicorn coontoir
Citizen.CreateThread(function()                                      
    while true do
        Wait(0)
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1388.312, -587.017, 30.218, true) < 0.5 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -1390.779, -590.754, 30.319)
           SetEntityHeading(GetPlayerPed(-1), 118.835399 )
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1387.414, -588.336, 30.319, true) < 0.9 then
          DoScreenFadeOut(700)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(700)
           SetEntityCoords(GetPlayerPed(-1), -1389.838, -584.956, 30.222)
           SetEntityHeading(GetPlayerPed(-1), 32.157516 )
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(700)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(700)
            while IsScreenFadingIn() do Citizen.Wait(10) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1381.118, -632.681, 30.819, true) < 0.8 then
          --DoScreenFadeOut(1000)
          --while IsScreenFadingOut() do Citizen.Wait(0) end
           --NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           --Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -1379.446, -630.914, 30.819)
           SetEntityHeading(GetPlayerPed(-1), 300.000 )
           --NetworkFadeInEntity(GetPlayerPed(-1), 0)
           --Wait(1000)
           --SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
          -- DoScreenFadeIn(1000)
           -- while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(5000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1379.446, -630.914, 30.819, true) < 1.0 then
         -- DoScreenFadeOut(1000)
         -- while IsScreenFadingOut() do Citizen.Wait(0) end
          -- NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
          -- Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -1381.118, -632.681, 30.819)
           SetEntityHeading(GetPlayerPed(-1), 32.157516 )
          -- NetworkFadeInEntity(GetPlayerPed(-1), 0)
          -- Wait(1000)
           --SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           --DoScreenFadeIn(1000)
           -- while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(5000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1371.507, -626.111, 30.819, true) < 0.8 then
          --DoScreenFadeOut(1000)
          --while IsScreenFadingOut() do Citizen.Wait(0) end
           --NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           --Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -1385.286, -606.486, 30.319)
           SetEntityHeading(GetPlayerPed(-1), 125.15247 )
           --NetworkFadeInEntity(GetPlayerPed(-1), 0)
           --Wait(1000)
           --SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
          -- DoScreenFadeIn(1000)
           -- while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(5000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1385.286, -606.486, 30.319, true) < 0.8 then
         -- DoScreenFadeOut(1000)
         -- while IsScreenFadingOut() do Citizen.Wait(0) end
          -- NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
          -- Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -1371.507, -626.111, 30.819)
           SetEntityHeading(GetPlayerPed(-1), 308.75811 )
          -- NetworkFadeInEntity(GetPlayerPed(-1), 0)
          -- Wait(1000)
           --SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           --DoScreenFadeIn(1000)
           -- while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(5000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1386.263, -627.412, 30.819, true) < 0.5 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), -1393.722, -641.198, 28.673)
           SetEntityHeading(GetPlayerPed(-1), 126.28659)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 133.227, -1293.628, 29.269, true) < 0.5 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 132.663, -1287.546, 29.271)
           SetEntityHeading(GetPlayerPed(-1), 33.3449935)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(5000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 132.201, -1290.636, 29.269, true) < 0.5 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 133.227, -1293.628, 29.269)
           SetEntityHeading(GetPlayerPed(-1), 126.187561)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(5000)
        end
        ---assensceur pour la maison de pinkman
        --[[if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 248.661, -1369.917, 29.647, true) < 2.0 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 247.176, -1371.760, 24.537)
           SetEntityHeading(GetPlayerPed(-1), 321.278)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(10000)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 247.176, -1371.760, 24.537, true) < 2.0 then
          DoScreenFadeOut(1000)
          while IsScreenFadingOut() do Citizen.Wait(0) end
           NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
           Wait(1000)
           SetEntityCoords(GetPlayerPed(-1), 248.661, -1369.917, 29.647)
           SetEntityHeading(GetPlayerPed(-1), 321.278)
           NetworkFadeInEntity(GetPlayerPed(-1), 0)
           Wait(1000)
           SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
           DoScreenFadeIn(1000)
            while IsScreenFadingIn() do Citizen.Wait(0) end
            Wait(10000)
        end]]
        --tennue pinkman malade
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 245.920, -1352.677, 24.537, true) < 1.0 then
      	DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour mettre la tenue de patient")
      	if IsControlJustPressed(0,38) then
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
      		if skin.sex == 0 then
          		ClearPedProp(GetPlayerPed(-1), 0)
          		SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 0)--bras
          		SetPedComponentVariation(GetPlayerPed(-1), 4, 56, 0, 0)--Jean
          		SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 0)--Chaussure
          		SetPedComponentVariation(GetPlayerPed(-1), 8, 57, 4, 0)--tshirt
          		SetPedComponentVariation(GetPlayerPed(-1), 11, 114, 0, 0)--Veste
         		SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 0)--chain
          		--SetPedComponentVariation(GetPlayerPed(-1), 1, 98, 0, 0)--masque
          	else
          		ClearPedProp(GetPlayerPed(-1), 0)
          		SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 0)--bras
          		SetPedComponentVariation(GetPlayerPed(-1), 4, 57, 0, 0)--Jean
          		SetPedComponentVariation(GetPlayerPed(-1), 6, 35, 0, 0)--Chaussure
          		SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 0)--tshirt
          		SetPedComponentVariation(GetPlayerPed(-1), 11, 105, 0, 0)--Veste
         		SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 0)--chain
          		--SetPedComponentVariation(GetPlayerPed(-1), 1, 98, 0, 0)--masque
          	  end
            end)
      	  end
      	end
        -------------------------------------------------
    end
end)

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end




