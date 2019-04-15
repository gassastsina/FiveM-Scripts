--By Vakeros
--Last edit 02/09/17

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('firstConnectionName', function()
	while true do
		Wait(0)

		Notify("Indiquez votre Nom rp")
		 local result = nil
		 local result1 = nil
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
		--isplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
	    while (UpdateOnscreenKeyboard() == 0) do
	        DisableAllControlActions(0);
	        Wait(0);
	    end
	    if (GetOnscreenKeyboardResult()) then
	         result = GetOnscreenKeyboardResult()
	      --  TriggerServerEvent('rpname',result)
	    end
	    Notify("Indiquez votre Prenom rp")
	    	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
		--isplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
	    while (UpdateOnscreenKeyboard() == 0) do
	        DisableAllControlActions(0);
	        Wait(0);
	    end
	    if (GetOnscreenKeyboardResult()) then
	        result1 = GetOnscreenKeyboardResult()

	    end
	    Notify("~r~ Confirmé que votre Nom rp est : \""..result.."\" et votre Prenom rp est : \""..result1.."\" oui/non ")
	    DisplayOnscreenKeyboard(1, "CELL_EMASH_BODF	", "", "", "", "", "", 30)
		--isplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
	    while (UpdateOnscreenKeyboard() == 0) do
	        DisableAllControlActions(0);
	        Wait(0);
	    end
	    if (GetOnscreenKeyboardResult()) then
	        local confirm = GetOnscreenKeyboardResult()
	        if confirm == "oui" then
	        	  local name = result .. " ".. result1
	      		  TriggerServerEvent('rpname',name)
	      		  Notify("~g~ Bienvenue sur le serveur Los Santos Nights ! Bon jeu à vous")
	      		  break
	        end
	        --local name = result .. " ".. result1
	        TriggerServerEvent('rpname',name)
	        --Citizen.Trace(name)
	    end
	 end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end