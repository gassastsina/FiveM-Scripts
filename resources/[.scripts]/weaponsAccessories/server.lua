----------------------------------------------
----------------------------------------------
----    File : server.lua       		  ----
----    Author: gassastsina     		  ----
----	Side : server 		 			  ----
----    Description : Weapons accessories ----
----------------------------------------------
----------------------------------------------

----------------------------------------------ESX--------------------------------------------------------
ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---------------------------------------------Updates-----------------------------------------------------
RegisterServerEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(loadout)
	TriggerClientEvent('weaponsAccessories:updateLoadoutFromESXServer', source, loadout)
end)

--------------------------------------------Shop---------------------------------------------------------
RegisterNetEvent('weaponsAccessories:removeMoney')
AddEventHandler('weaponsAccessories:removeMoney', function(price)
	ESX.GetPlayerFromId(source).removeMoney(price)
end)


--------------------------------------------menu---------------------------------------------------------
ESX.RegisterUsableItem('suppressor', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('suppressor').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'suppressor')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Silencieux~s~ sur vous")
	end
end)

ESX.RegisterUsableItem('flashlight', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('flashlight').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'flashlight')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Lampe torche~s~ sur vous")
	end
end)

ESX.RegisterUsableItem('grip', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('grip').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'grip')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Poignée~s~ sur vous")
	end
end)

ESX.RegisterUsableItem('scope', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('scope').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'scope')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Viseur~s~ sur vous")
	end
end)

ESX.RegisterUsableItem('clip1', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('clip1').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'clip1')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Chargeur normal~s~ sur vous")
	end
end)

ESX.RegisterUsableItem('clip2', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('clip2').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'clip2')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Chargeur grande capacité~s~ sur vous")
	end
end)

ESX.RegisterUsableItem('clip3', function(source)
	if ESX.GetPlayerFromId(source).getInventoryItem('clip3').count > 0 then
		TriggerClientEvent('weaponsAccessories:useAccessorie', source, 'clip3')
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ~r~n'avez pas~s~ de ~b~Chargeur très grand capacité~s~ sur vous")
	end
end)

ESX.RegisterServerCallback('weaponsAccessories:getItemCount', function(source, cb, item)
	cb(ESX.GetPlayerFromId(source).getInventoryItem(item).count)
end)



-------------------------------------------Échange-entre-joueurs-----------------------------------------
--Stockage du loadout de l'arme juste avant de la jeter
local droppedList = {}
RegisterNetEvent('weaponsAccessories:pickupLoadout')
AddEventHandler('weaponsAccessories:pickupLoadout', function(weaponName, xPlayer)
	for i=1, #xPlayer.loadout, 1 do
		if xPlayer.loadout[i].name == weaponName then
			table.insert(droppedList, xPlayer.loadout[i])
		end
	end
end)

--Envoie à tout les joueurs le pickup pour check la zone
RegisterNetEvent('weaponsAccessories:pickup')
AddEventHandler('weaponsAccessories:pickup', function(weaponName, pickupDropped, x, y, z)
	TriggerClientEvent('weaponsAccessories:pickup', -1, pickupDropped, weaponName, x, y, z)
end)

--Récupérer une arme au sol
RegisterNetEvent('weaponsAccessories:gotPickup')
AddEventHandler('weaponsAccessories:gotPickup', function(weaponName, x, y, z)
	for i=1, #droppedList, 1 do
		if droppedList[i].name == weaponName then
			TriggerEvent('weaponsAccessories:getAccessories', droppedList[i].name, 'set', source, droppedList[i])
			table.remove(droppedList, i)
			break
		end
	end
end)

--Update le loadout d'un joueur
RegisterNetEvent('weaponsAccessories:giveWeapon')
AddEventHandler('weaponsAccessories:giveWeapon', function(loadout, weaponName, to)
	for i=1, #loadout, 1 do
		if loadout[i].name == weaponName then
			Wait(1000)
			TriggerEvent('weaponsAccessories:getAccessories', loadout[i].name, 'set', to, loadout[i])
			Wait(1000)
			TriggerClientEvent('weaponsAccessories:updateLoadout', to, loadout[i])
			break
		end
	end
end)


-------------------------------------Récupère-le-nom-des-accessoires-------------------------------------
local function checkWhitelistWeapons(weapon)
	if weapon ~= nil then
		for i=1, #Config.WhitelistWeapon, 1 do
			if weapon == Config.WhitelistWeapon[i] then
				return true
			end
		end
	end
	return false
end

RegisterServerEvent('weaponsAccessories:getAccessories')
AddEventHandler('weaponsAccessories:getAccessories', function(weapon, part, to, loadout, lastAccessorie, newAccessorie)
	
	local list = {
		suppressor = nil,
		flashlight = nil,
		grip 	   = nil,
		scope 	   = nil,
		clip 	   = nil,
		clipLevel  = 0,
		carving    = nil
	}

	local IsGotAccessorie = {}

	if checkWhitelistWeapons(weapon) then
		
		if weapon == "WEAPON_PISTOL" then
			 list.suppressor = "component_at_pi_supp_02"
			 list.flashlight = "COMPONENT_AT_PI_FLSH"
			 list.clip 		 = "COMPONENT_PISTOL_CLIP"
			 list.carving 	 = "COMPONENT_PISTOL_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_PISTOL50" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_PI_FLSH"
			 list.clip 		 = "COMPONENT_PISTOL50_CLIP"
			 list.carving 	 = "COMPONENT_PISTOL50_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_COMBATPISTOL" then
			 list.suppressor = "COMPONENT_AT_PI_SUPP"
			 list.flashlight = "COMPONENT_AT_PI_FLSH"
			 list.clip 		 = "COMPONENT_COMBATPISTOL_CLIP"
			 list.carving 	 = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_APPISTOL" then
			 list.suppressor = "COMPONENT_AT_PI_SUPP"
			 list.flashlight = "COMPONENT_AT_PI_FLSH"
			 list.clip 		 = "COMPONENT_APPISTOL_CLIP"
			 list.carving 	 = "COMPONENT_APPISTOL_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_SNSPISTOL" then
			 list.clip 		 = "COMPONENT_SNSPISTOL_CLIP"
			 list.carving 	 = "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_HEAVYPISTOL" then
			 list.suppressor = "COMPONENT_AT_PI_SUPP"
			 list.flashlight = "COMPONENT_AT_PI_FLSH"
			 list.clip 		 = "COMPONENT_HEAVYPISTOL_CLIP"
			 list.carving 	 = "COMPONENT_HEAVYPISTOL_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_VINTAGEPISTOL" then
			 list.suppressor = "COMPONENT_AT_PI_SUPP"
			 list.clip 		 = "COMPONENT_VINTAGEPISTOL_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_SMG" then
			 list.suppressor = "COMPONENT_AT_PI_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MACRO_02"
			 list.clip 		 = "COMPONENT_SMG_CLIP"
			 list.carving 	 = "COMPONENT_SMG_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}

		elseif weapon == "WEAPON_MICROSMG" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_PI_FLSH"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MACRO"
			 list.clip 		 = "COMPONENT_MICROSMG_CLIP"
			 list.carving 	 = "COMPONENT_MICROSMG_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_ASSAULTSMG" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MACRO"
			 list.clip 		 = "COMPONENT_ASSAULTSMG_CLIP"
			 list.carving 	 = "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_GUSENBERG" then
			 list.clip 		 = "COMPONENT_GUSENBERG_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_COMBATPDW" then
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.scope 	 = "COMPONENT_AT_SCOPE_SMALL"
			 list.clip 		 = "COMPONENT_COMBATPDW_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}
			
		elseif weapon == "WEAPON_MG" then
			 list.scope 	 = "COMPONENT_AT_SCOPE_SMALL_02"
			 list.clip 		 = "COMPONENT_MG_CLIP"
			 list.carving 	 = "COMPONENT_MG_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_COMBATMG" then
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MEDIUM"
			 list.clip 		 = "COMPONENT_COMBATMG_CLIP"
			 list.carving 	 = "COMPONENT_MG_COMBATMG_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}

		elseif weapon == "WEAPON_ASSAULTRIFLE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MACRO"
			 list.clip 		 = "COMPONENT_ASSAULTRIFLE_CLIP"
			 list.carving 	 = "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}
			
		elseif weapon == "WEAPON_CARBINERIFLE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MEDIUM"
			 list.clip 		 = "COMPONENT_CARBINERIFLE_CLIP"
			 list.carving 	 = "COMPONENT_CARBINERIFLE_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}
			
		elseif weapon == "WEAPON_ADVANCEDRIFLE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.scope 	 = "COMPONENT_AT_SCOPE_SMALL"
			 list.clip 		 = "COMPONENT_ADVANCEDRIFLE_CLIP"
			 list.carving 	 = "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_SPECIALCARBINE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MEDIUM"
			 list.clip 		 = "COMPONENT_SPECIALCARBINE_CLIP"
			 list.carving 	 = "COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}
			
		elseif weapon == "WEAPON_BULLPUPRIFLE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.scope 	 = "COMPONENT_AT_SCOPE_SMALL"
			 list.clip 		 = "COMPONENT_BULLPUPRIFLE_CLIP"
			 list.carving 	 = "COMPONENT_BULLPUPRIFLE_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_COMPACTRIFLE" then
			 list.clip 		 = "COMPONENT_COMPACTRIFLE_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}
			
		elseif weapon == "WEAPON_ASSAULTSHOTGUN" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.clip 		 = "COMPONENT_ASSAULTSHOTGUN_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_HEAVYSHOTGUN" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.clip 		 = "COMPONENT_HEAVYSHOTGUN_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = true
			}
			
		elseif weapon == "WEAPON_BULLPUPSHOTGUN" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 IsGotAccessorie = {
			 	clip1 = false,
			 	clip2 = false,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_SAWNOFFSHOTGUN" then
			 list.carving 	 = "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = false,
			 	clip2 = false,
			 	clip3 = false
			}
			 
		elseif weapon == "WEAPON_PUMPSHOTGUN" then
			 list.suppressor = "COMPONENT_AT_SR_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.carving 	 = "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER"
			 IsGotAccessorie = {
			 	clip1 = false,
			 	clip2 = false,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_MARKSMANRIFLE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP"
			 list.flashlight = "COMPONENT_AT_AR_FLSH"
			 list.grip 		 = "COMPONENT_AT_AR_AFGRIP"
			 list.clip 		 = "COMPONENT_MARKSMANRIFLE_CLIP"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = true,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_SNIPERRIFLE" then
			 list.suppressor = "COMPONENT_AT_AR_SUPP_02"
			 list.scope 	 = "COMPONENT_AT_SCOPE_MAX"
			 list.carving 	 = "COMPONENT_SNIPERRIFLE_VARMOD_LUXE"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = false,
			 	clip3 = false
			}
			
		elseif weapon == "WEAPON_HEAVYSNIPER" then
			 list.scope 	 = "COMPONENT_AT_SCOPE_MAX"
			 IsGotAccessorie = {
			 	clip1 = true,
			 	clip2 = false,
			 	clip3 = false
			}
			
		elseif Config.Debug then
			print("ERROR weaponsAccessories : L'arme n'est pas répertoriée ("..weapon..")")
		end

		if list.clip ~= nil and (part == 'set' or part == 'restore') then
			list.clip = list.clip..'_0'..loadout.clip+1
		end
	end

	IsGotAccessorie.suppressor = list.suppressor ~= nil
	IsGotAccessorie.flashlight = list.flashlight ~= nil
	IsGotAccessorie.grip 	   = list.grip ~= nil
	IsGotAccessorie.scope 	   = list.scope ~= nil

	if part == 'save' then
		TriggerClientEvent('weaponsAccessories:registerAccessories', source, list)
	elseif part == 'restore' then
		TriggerClientEvent('weaponsAccessories:setAccessories', source, list, loadout, part, IsGotAccessorie)
	elseif part == 'set' then
		TriggerClientEvent('weaponsAccessories:setAccessories', to, list, loadout, part, IsGotAccessorie)
	elseif part == 'menu' then
		if IsGotAccessorie[newAccessorie] or newAccessorie == nil then
			local xPlayer = ESX.GetPlayerFromId(source)
			if newAccessorie ~= nil then
				xPlayer.removeInventoryItem(newAccessorie, 1)
			end
			if lastAccessorie ~= nil then
				xPlayer.addInventoryItem(lastAccessorie, 1)
			end
			TriggerClientEvent('weaponsAccessories:setAccessories', source, list, loadout, part, IsGotAccessorie)
		else
			TriggerClientEvent('esx:showNotification', "~r~Tu ne peux pas mettre cet accessoire sur cette arme", source)
		end
	end
end)