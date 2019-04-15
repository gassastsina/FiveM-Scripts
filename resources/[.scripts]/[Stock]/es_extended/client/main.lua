local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local GUI           = {}
GUI.Time            = 0
local LoadoutLoaded = false
local IsPaused      = false
local PlayerSpawned = false
local LastLoadout   = {}
local Pickups       = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  
  ESX.PlayerLoaded  = true
  ESX.PlayerData    = xPlayer

  for i=1, #xPlayer.accounts, 1 do
    if xPlayer.accounts[i].name == 'black_money' then
      local accountTpl = '<div><img src="img/accounts/bank.png"/>&nbsp;{{money}}</div>'

      ESX.UI.HUD.RegisterElement('account_bank', i-1, 0, accountTpl, {
        money = 0
      })

      ESX.UI.HUD.UpdateElement('account_bank', {
        money = xPlayer.accounts[i].money + xPlayer.money
      })
    end
  end
  --[[
  local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

  if xPlayer.job.grade_label == '' then
    jobTpl = '<div>{{job_label}}</div>'
  end

  ESX.UI.HUD.RegisterElement('job', #xPlayer.accounts, 0, jobTpl, {
    job_label   = '',
    grade_label = ''
  })

  ESX.UI.HUD.UpdateElement('job', {
    job_label   = xPlayer.job.label,
    grade_label = xPlayer.job.grade_label
  })]]
end)

AddEventHandler('playerSpawned', function()

  Citizen.CreateThread(function()

    while not ESX.PlayerLoaded do
      Citizen.Wait(10)
    end

    -- Restore position
    if ESX.PlayerData.lastPosition ~= nil then
      SetEntityCoords(GetPlayerPed(-1),  ESX.PlayerData.lastPosition.x,  ESX.PlayerData.lastPosition.y,  ESX.PlayerData.lastPosition.z)
    end

    -- Restore loadout
    TriggerEvent('esx:restoreLoadout')

    LoadoutLoaded = true
    PlayerSpawned = true

  end)

end)

AddEventHandler('skinchanger:loadDefaultModel', function()
  LoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
  while not ESX.PlayerLoaded do
    Citizen.Wait(0)
  end

  TriggerEvent('esx:restoreLoadout')
end)

local weaponsAccessories = {}
RegisterNetEvent('esx:restoreLoadout')
AddEventHandler('esx:restoreLoadout', function()
  local playerPed = GetPlayerPed(-1)

  --print('DEBUG esx:restoreLoadout   :   '..json.encode(ESX.PlayerData.loadout))
  RemoveAllPedWeapons(playerPed, true)

  for i=1, #ESX.PlayerData.loadout, 1 do
    local weaponHash = GetHashKey(ESX.PlayerData.loadout[i].name)
    GiveWeaponToPed(playerPed, weaponHash, ESX.PlayerData.loadout[i].ammo, false, false)

    --Components + tint
    TriggerServerEvent('weaponsAccessories:getAccessories', ESX.PlayerData.loadout[i].name, 'restore', nil, ESX.PlayerData.loadout[i])
  end

  LoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)

  for i=1, #ESX.PlayerData.accounts, 1 do
    if ESX.PlayerData.accounts[i].name == account.name then
      ESX.PlayerData.accounts[i] = account
    end
  end

  TriggerEvent('esx:updateHUDMoney')
end)

RegisterNetEvent('esx:updateHUDMoney')
AddEventHandler('esx:updateHUDMoney', function()
    for i=1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money' then
            ESX.UI.HUD.UpdateElement('account_bank', {
              money = ESX.PlayerData.accounts[i].money + ESX.PlayerData.money
            })
        end
    end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
  	ESX.PlayerData.money = money
	TriggerEvent('esx:updateHUDMoney')
end)

local function getPlayerWeight(item)
	local totalWeight = 0
	local totalFoodWeight = 0
	--Player inventory weight
	local inventory = ESX.PlayerData.inventory
	for i=1, #inventory, 1 do
		if inventory[i].count > 0 then
			if not IsFoodItem(inventory[i].name) then
		  		totalWeight = totalWeight + inventory[i].limit*inventory[i].count
		  	else
		  		totalFoodWeight = totalFoodWeight + inventory[i].limit*inventory[i].count
		  	end
		end
	end
	if IsFoodItem(item) then
		return totalFoodWeight
	end
	return totalWeight
end

function IsFoodItem(item)
	for i=1, #Config.FoodItems, 1 do
		if Config.FoodItems[i] == item then
			return true
		end
	end
	return false
end

local function selectMaxInventoryWeight(item)
	if IsFoodItem(item) then
		return Config.MaxFoodInventoryWeight
	end
	return Config.MaxInventoryWeight
end

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)

  for i=1, #ESX.PlayerData.inventory, 1 do
    if ESX.PlayerData.inventory[i].name == item.name then
      	ESX.PlayerData.inventory[i] = item
    end
  end

  ESX.UI.ShowInventoryItemNotification(true, item, count)

  if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
    ESX.ShowInventory()
  end

end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)

  for i=1, #ESX.PlayerData.inventory, 1 do
    if ESX.PlayerData.inventory[i].name == item.name then
      ESX.PlayerData.inventory[i] = item
    end
  end

  ESX.UI.ShowInventoryItemNotification(false, item, count)

  if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
    ESX.ShowInventory()
  end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = GetPlayerPed(-1)
	local weaponHash = GetHashKey(weaponName)

  	for i=1, #Config.Weapons, 1 do
  		if Config.Weapons[i].name == weaponName then
			GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
			SetPedAmmo(playerPed, weaponHash, ammo) -- remove leftover ammo
			break
		end
	end
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
  local playerPed  = GetPlayerPed(-1)
  local weaponHash = GetHashKey(weaponName)

  RemoveWeaponFromPed(playerPed,  weaponHash)
  SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)

  pos.x = pos.x + 0.0
  pos.y = pos.y + 0.0
  pos.z = pos.z + 0.0

  RequestCollisionAtCoord(pos.x, pos.y, pos.z)

  while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
    RequestCollisionAtCoord(pos.x, pos.y, pos.z)
    Citizen.Wait(0)
  end

  SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.UI.HUD.UpdateElement('job', {
    job_label   = job.label,
    grade_label = job.grade_label
  })
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)

  Citizen.CreateThread(function()
    LoadMpDlcMaps()
    EnableMpDlcMaps(true)
    RequestIpl(name)
  end)

end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)

  Citizen.CreateThread(function()
    RemoveIpl(name)
  end)

end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)

  Citizen.CreateThread(function()

    local pid = PlayerPedId()

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
      Wait(0)
    end

    TaskPlayAnim(pid, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)

  end)

end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)

  Citizen.CreateThread(function()

    local playerPed = GetPlayerPed(-1)

    TaskStartScenarioInPlace(playerPed, emote, 0, false);
    Wait(20000)
    ClearPedTasks(playerPed)

  end)

end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
    TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
  end)

end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  local forward   = GetEntityForwardVector(playerPed)
  local x, y, z   = table.unpack(coords + forward * 1.0)

  ESX.Game.SpawnObject(model, {
    x = x,
    y = y,
    z = z
  }, function(obj)
    SetEntityHeading(obj, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(obj)
  end)

end)

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, player)
  local ped     = GetPlayerPed(GetPlayerFromServerId(player))
  local coords  = GetEntityCoords(ped)
  local forward = GetEntityForwardVector(ped)
  local x, y, z = table.unpack(coords + forward * -2.0)

  ESX.Game.SpawnLocalObject('hei_prop_hei_paper_bag', {
      x = x,
      y = y,
      z = z - 2.0,
    }, function(obj)

    SetEntityAsMissionEntity(obj,  true,  false)

    PlaceObjectOnGroundProperly(obj)

    Pickups[id] = {
      id = id,
      obj = obj,
      label = label,
      inRange = false,
      coords = {
        x = x,
        y = y,
        z = z
      },
    }

  end)

end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
  ESX.Game.DeleteObject(Pickups[id].obj)
  Pickups[id] = nil
end)

RegisterNetEvent('esx:pickupWeapon')
AddEventHandler('esx:pickupWeapon', function(weaponPickup, weaponName, ammo)

  local ped          = GetPlayerPed(-1)
  local playerPedPos = GetEntityCoords(ped, true)
  local pickup = CreateAmbientPickup(GetHashKey(weaponPickup), playerPedPos.x + 2.0, playerPedPos.y, playerPedPos.z + 0.5, 0, ammo, 1, false, true)
  local coords = GetEntityCoords(pickup, false)
  TriggerServerEvent('weaponsAccessories:pickup', weaponName, pickup, coords.x, coords.y, coords.z)
  
end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)

  model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  local forward   = GetEntityForwardVector(playerPed)
  local x, y, z   = table.unpack(coords + forward * 1.0)

  Citizen.CreateThread(function()

    RequestModel(model)

    while not HasModelLoaded(model)  do
      Citizen.Wait(1)
    end

    CreatePed(5,  model,  x,  y,  z,  0.0,  true,  false)

  end)

end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsPedInAnyVehicle(playerPed,  false) then

    local vehicle = GetVehiclePedIsIn(playerPed,  false)
    ESX.Game.DeleteVehicle(vehicle)

  elseif IsAnyVehicleNearPoint(coords.x,  coords.y,  coords.z,  5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
    ESX.Game.DeleteVehicle(vehicle)

  end

end)


-- Pause menu disable HUD display
Citizen.CreateThread(function()
  local HUD = false
  while true do
    Citizen.Wait(15)

    if IsPauseMenuActive() and not IsPaused then
      IsPaused = true
      TriggerEvent('esx:ShowHUD', false, 0.0)
    elseif not IsPauseMenuActive() and IsPaused then
      IsPaused = false
      if not HUD then
        TriggerEvent('esx:ShowHUD', true, 1.0)
      end
    end

    if IsControlJustPressed(1, 57) then
	    HUD = not HUD
	    if HUD then
    		TriggerEvent('esx:ShowHUD', false, 0.0)
    	else
    		TriggerEvent('esx:ShowHUD', true, 1.0)
    	end
    end
  end
end)

AddEventHandler('esx:ShowHUD', function(bool, hud, minimap)
  	TriggerEvent('es:setMoneyDisplay', hud)
  	ESX.UI.HUD.SetDisplay(hud)
  	if minimap == nil or minimap then
    	DisplayRadar(hud)
    end
end)

-- Save loadout
Citizen.CreateThread(function()
	Citizen.Wait(5000)

  while true do
    Wait(1000)

    local playerPed      = GetPlayerPed(-1)
    local loadout        = {}
    local loadoutChanged = false

    if IsPedDeadOrDying(playerPed) then
      LoadoutLoaded = false
    end

    for i=1, #Config.Weapons, 1 do

        local weaponHash = GetHashKey(Config.Weapons[i].name)

        if HasPedGotWeapon(playerPed,  weaponHash,  false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then

            local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)

            if LastLoadout[Config.Weapons[i].name] == nil or LastLoadout[Config.Weapons[i].name] ~= ammo then
              loadoutChanged = true
            end

            LastLoadout[Config.Weapons[i].name] = ammo

            --Components + tint
            weaponsAccessories = nil
            TriggerServerEvent('weaponsAccessories:getAccessories', Config.Weapons[i].name, 'save', nil, ESX.PlayerData.loadout)
            while weaponsAccessories == nil do
                Wait(100)
            end

            setClipLevel(weaponHash)
            local playerped = GetPlayerPed(-1)
            table.insert(loadout, {
                name  = Config.Weapons[i].name,
                ammo  = ammo,
                label = Config.Weapons[i].label,
                tint       = GetPedWeaponTintIndex(playerPed, weaponHash),
                suppressor = HasPedGotWeaponComponent(playerPed, weaponHash, GetHashKey(weaponsAccessories.suppressor)),
                flashlight = HasPedGotWeaponComponent(playerPed, weaponHash, GetHashKey(weaponsAccessories.flashlight)),
                grip       = HasPedGotWeaponComponent(playerPed, weaponHash, GetHashKey(weaponsAccessories.grip)),
                scope      = HasPedGotWeaponComponent(playerPed, weaponHash, GetHashKey(weaponsAccessories.scope)),
                clip       = weaponsAccessories.clipLevel,
                carving    = HasPedGotWeaponComponent(playerPed, weaponHash, GetHashKey(weaponsAccessories.carving))
            })
        else

            if LastLoadout[Config.Weapons[i].name] ~= nil then
              loadoutChanged = true
            end
            LastLoadout[Config.Weapons[i].name] = nil

        end

    end

    if loadoutChanged and LoadoutLoaded then
		ESX.PlayerData.loadout = loadout
		TriggerServerEvent('esx:updateLoadout', loadout)
    end

  end
end)

function setClipLevel(weaponHash)
	if weaponsAccessories.clip ~= nil then
	    if HasPedGotWeaponComponent(GetPlayerPed(-1), weaponHash, GetHashKey(weaponsAccessories.clip..'_01')) then
	        weaponsAccessories.clipLevel = 0
	        return

	    elseif HasPedGotWeaponComponent(GetPlayerPed(-1), weaponHash, GetHashKey(weaponsAccessories.clip..'_02')) then
	        weaponsAccessories.clipLevel = 1
	        return

	    elseif HasPedGotWeaponComponent(GetPlayerPed(-1), weaponHash, GetHashKey(weaponsAccessories.clip..'_03')) then
	        weaponsAccessories.clipLevel = 2
	        return

	    elseif Config.EnableDebug then
	        print("ERROR es_extended : clipLevel didn't set")
	    end
	end
end

RegisterNetEvent('weaponsAccessories:updateLoadout')
AddEventHandler('weaponsAccessories:updateLoadout', function(sourceLoadout)
    local weaponAlreadyExist = false
    local n = nil
    for i=1, #ESX.PlayerData.loadout, 1 do
        if ESX.PlayerData.loadout[i].name == sourceLoadout.name then
            weaponAlreadyExist = true
            n = i
            break
        end
    end
    if weaponAlreadyExist then
        --print('DEBUG updateLoadout : '..json.encode(ESX.PlayerData.loadout[n]))
        ESX.PlayerData.loadout[n] = sourceLoadout
    else
        table.insert(ESX.PlayerData.loadout, sourceLoadout)
    end
    TriggerServerEvent('esx:updateLoadout', ESX.PlayerData.loadout)
end)

RegisterNetEvent('weaponsAccessories:updateTintCarving')
AddEventHandler('weaponsAccessories:updateTintCarving', function(weaponName, tint)
    for i=1, #ESX.PlayerData.loadout, 1 do
        if ESX.PlayerData.loadout[i].name == weaponName then
            if tint ~= 'carving' then
                ESX.PlayerData.loadout[i].tint = tint
            else
                ESX.PlayerData.loadout[i].carving = true
                TriggerEvent('esx:restoreLoadout')
            end
            TriggerServerEvent('esx:updateLoadout', ESX.PlayerData.loadout)
        end
    end
end)

RegisterNetEvent('weaponsAccessories:registerAccessories')
AddEventHandler('weaponsAccessories:registerAccessories', function(accessories)
    weaponsAccessories = accessories
end)

-- Dot above head
if Config.ShowDotAbovePlayer then

  Citizen.CreateThread(function()
    while true do

      Citizen.Wait(0)

      local players = ESX.Game.GetPlayers()

      for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
          local ped    = GetPlayerPed(players[i])
          local headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, ('·'), false, false, '', false)
        end
      end

    end
  end)

end

-- Pickups
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    for k,v in pairs(Pickups) do

      local distance = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  v.coords.x,  v.coords.y,  v.coords.z,  true)

      if distance <= 5.0 then

        ESX.Game.Utils.DrawText3D({
          x = v.coords.x,
          y = v.coords.y,
          z = v.coords.z + 0.25
        }, v.label)

      end

      if distance <= 1.0 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) then
        TriggerServerEvent('esx:onPickup', v.id)
        v.inRange = true
      end

    end

  end
end)

-- Last position
Citizen.CreateThread(function()

  while true do

    Citizen.Wait(1000)

    if ESX ~= nil and ESX.PlayerLoaded and PlayerSpawned then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      if not IsEntityDead(playerPed) then
        ESX.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
      end

    end

  end

end)

Citizen.CreateThread(function()

  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)

    if IsEntityDead(playerPed) and PlayerSpawned then
      PlayerSpawned = false
    end
  end

end)
