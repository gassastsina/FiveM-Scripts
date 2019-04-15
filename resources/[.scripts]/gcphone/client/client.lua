--====================================================================================
-- #Author : Jonathan D @ Gannon
-- #Edited by : gassastsina 
--====================================================================================

----------------------------------------------ESX--------------------------------------------------------
ESX           = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end
end)

local PlayerData              = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

 
-- Configuration
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' },
}
local KeyOpenClose = 19
local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
--====================================================================================
--  
--====================================================================================
 
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, KeyOpenClose) then
      ESX.TriggerServerCallback('gcphone:getItemAmount', function(quantity)
          if quantity > 0 then
				TooglePhone()
          else
			TriggerEvent('esx:showNotification', "Vous n'avez pas de téléphone")
          end
      end, 'phone')
    end
    if menuIsOpen == true then
      for _, value in ipairs(KeyToucheCloseEvent) do
        if IsControlJustPressed(1, value.code) then
          SendNUIMessage({keyUp = value.event})
        end
      end
    end
  end
end)

 
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("gcPhone:myPhoneNumber")
AddEventHandler("gcPhone:myPhoneNumber", function(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end)

RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message, contact, phone, txt)
  -- SendNUIMessage({event = 'updateMessages', messages = messages})
  SendNUIMessage({event = 'newMessage', message = message})
  if message.owner == 0 then
	SetNotificationTextEntry("STRING");
	AddTextComponentString(txt);
	SetNotificationMessage("CHAR_CHAT_CALL", "CHAR_CHAT_CALL", true, 1, contact, phone, txt);
	DrawNotification(true, false)
    DrawNotification(false, false)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
  end
end)

RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(bank)
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end)
--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
    TriggerServerEvent('gcPhone:addContact', display, num)
end

function deleteContact(num) 
    TriggerServerEvent('gcPhone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
  TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('gcPhone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('gcPhone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gcPhone:requestAllContact')
end























--====================================================================================
--  Function client | Appels
--====================================================================================
local inCall = false
local aminCall = false

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall)
  SendNUIMessage({event = 'waitingCall', infoCall = infoCall})
  if infoCall.transmitter_num == myPhoneNumber then
    aminCall = true
    ePhoneStartCall()
  end
end)

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall)
	if inCall == false then
		inCall = true
		NetworkSetVoiceChannel(infoCall.id + 1)
		NetworkSetTalkerProximity(0.0)
	end
	if aminCall == false then
		aminCall = true
		ePhoneStartCall()
	end
	if infoCall.job ~= nil and infoCall.receiver_src ~= GetPlayerServerId(GetPlayerPed(-1)) then
		TriggerServerEvent('gcPhone:rejectCallFromService', infoCall)
	end
	SendNUIMessage({event = 'acceptCall', infoCall = infoCall})
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)
	--print('rejectCall')
	--print(json.encode(infoCall))
  if inCall == true then
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
    NetworkSetTalkerProximity(5.001)
  end
  if aminCall == true then
    ePhoneStopCall()
    aminCall = false
  end
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)


RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)

function startCall (phone_number)
  TriggerServerEvent('gcPhone:startCall', phone_number)
end

function acceptCall (infoCall)
  TriggerServerEvent('gcPhone:acceptCall', infoCall)
  --print('acceptCall')
  --print(json.encode(infoCall))
end

function rejectCall(infoCall)
  TriggerServerEvent('gcPhone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
	--print('ignoreCall')
	--print(json.encode(infoCall))
  TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('gcPhone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end
  

--====================================================================================
--  Event - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall)
  cb()
end)

RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)

RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)




















--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
function tprint (t, s)
  for k, v in pairs(t) do
      local kfmt = '["' .. tostring(k) ..'"]'
      if type(k) ~= 'string' then
          kfmt = '[' .. k .. ']'
      end
      local vfmt = '"'.. tostring(v) ..'"'
      if type(v) == 'table' then
          tprint(v, (s or '')..kfmt)
      else
          if type(v) ~= 'string' then
              vfmt = tostring(v)
          end
          print(type(t)..(s or '')..kfmt..' = '..vfmt)
      end
  end
end
RegisterNUICallback('log', function(data, cb)
  -- print(data)
  -- tprint(data)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)
RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local text = data.text or ''
  
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
  while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
      text = GetOnscreenKeyboardResult()
  end
  cb(json.encode({text = text}))
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEntityCoords(GetPlayerPed(-1))
    data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
  end
  TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
end)

RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
end)

RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('gcPhone:deleteContact', data.id)
end)

RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)

RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)
RegisterNUICallback('callEvent', function(data, cb)
  local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
  if data.eventName ~= 'cancel' then
  	ESX.TriggerServerCallback('gcphone:jobMemberChecker', function(member)
  		if member > 0 or data.eventName == "taxi" or data.eventName == "RESPAWN" then
		    if data.data ~= nil then 
		      TriggerServerEvent("call:makeCall", "police", {x=plyPos.x,y=plyPos.y,z=plyPos.z},ResultMotifAdd,GetPlayerServerId(player))
		      TriggerServerEvent("call:makeCall", data.eventName, {x=plyPos.x,y=plyPos.y,z=plyPos.z}, data.data, GetPlayerServerId(player))
		      if data.eventName == "police" then
		        ShowNotificationMenuCivil2("~h~Vous avez appelé la ~b~Police")
		        TriggerServerEvent("gcPhone:sendGPSToService", data.eventName, 'GPS: ' .. plyPos.x .. ', ' .. plyPos.y)
		      elseif data.eventName == "taxi" then
		        TriggerEvent('fs_taxi:callTaxi')
		      elseif data.eventName == "mecano" then
		        ShowNotificationMenuCivil2("~h~Vous avez appelé un ~b~Dépanneur")
		      elseif data.eventName == "reporter" then
		        ShowNotificationMenuCivil2("~h~Vous avez appelé un ~b~Journaliste")
		      elseif data.eventName == "lospolloshermanos" then
		        ShowNotificationMenuCivil2("~h~Vous avez appelé ~b~Los Pollos Hermanos")
		      elseif data.eventName == "ambulance" then
		        ShowNotificationMenuCivil2("~h~Vous avez appelé les ~b~URGENCES")
		        TriggerServerEvent("gcPhone:sendGPSToService", data.eventName, 'GPS: ' .. plyPos.x .. ', ' .. plyPos.y)
		      end
		      TriggerServerEvent('gcphone:sendToJob', data.eventName)


		    else
		      local limit = data.limit or 255
		      local text = data.text or ''
		      if data.eventName ~= "RESPAWN" then
		        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
		        while (UpdateOnscreenKeyboard() == 0) do
		            DisableAllControlActions(0);
		            Wait(0);
		        end
		        if (GetOnscreenKeyboardResult()) then
		            text = GetOnscreenKeyboardResult()
		        end
		        TriggerServerEvent("call:makeCall", data.eventName, {x=plyPos.x,y=plyPos.y,z=plyPos.z}, text, GetPlayerServerId(player))
		        if data.eventName == "police" then
		          ShowNotificationMenuCivil2("~h~Vous avez envoyé un SMS à la ~b~Police")
		          TriggerServerEvent("gcPhone:sendGPSToService", data.eventName, 'GPS: ' .. plyPos.x .. ', ' .. plyPos.y)
		        elseif data.eventName == "taxi" then
		          TriggerEvent('fs_taxi:callTaxi')
		        elseif data.eventName == "mecano" then
		          ShowNotificationMenuCivil2("~h~Vous avez envoyé un SMS aux ~b~Dépanneurs")
		        elseif data.eventName == "reporter" then
		          ShowNotificationMenuCivil2("~h~Vous avez envoyé un SMS aux ~b~Journalistes")
		      	elseif data.eventName == "lospolloshermanos" then
		        	ShowNotificationMenuCivil2("~h~Vous avez envoyé un SMS à ~b~Los Pollos Hermanos")
		        elseif data.eventName == "ambulance" then
		          ShowNotificationMenuCivil2("~h~Vous avez appelé les ~b~URGENCES")
		          TriggerServerEvent("gcPhone:sendGPSToService", data.eventName, 'GPS: ' .. plyPos.x .. ', ' .. plyPos.y)
		        end
				TriggerServerEvent("gcPhone:sendGPSToService", data.eventName, text)
		      else
		          	TriggerServerEvent("gcPhone:sendGPSToService", 'ambulance', "Cette personne a besoin d'une réanimation")
		          	TriggerServerEvent("gcPhone:sendGPSToService", 'ambulance', 'GPS: ' .. plyPos.x .. ', ' .. plyPos.y)
		        	ShowNotificationMenuCivil2("~h~Vous avez appelé les ~b~URGENCES")
		      end
		    end
		else
			TriggerEvent('esx:showNotification', "Aucun personnel n'est actuellement disposé à vous répondre, veuillez nous recontacter ultérieurement")
		end
	end, data.eventName)
    cb()
  end
end)

RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('gcPhone:deleteALL')
  cb()
end)

function TooglePhone() 
  menuIsOpen = not menuIsOpen
  SendNUIMessage({show = menuIsOpen})
  if menuIsOpen == true then 
    ePhoneInAnim()
  else
    ePhoneOutAnim()
  end
end

RegisterNUICallback('takePhoto', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  cb()
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  ePhoneOutAnim()
  cb()
end)

AddEventHandler('onClientResourceStart', function(res)
    --ClearPedTasksImmediately(GetPlayerPed(-1))
    DoScreenFadeIn(300)
    if res == "gcphone" then
        TriggerServerEvent('gcPhone:allUpdate')
    end
end)


----------------------------------
---------- GESTION APPEL ---------
----------------------------------


--
---- VDK_CALL ???
RegisterNetEvent('callService')
AddEventHandler("callService", function(type)
  print('Try callService', type)
	local limit = 120
	local defautText = ""
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defautText, "", "", "", limit)
	while (UpdateOnscreenKeyboard() == 0) do
	  DisableAllControlActions(0);
	  Wait(0);
	 end
	if (GetOnscreenKeyboardResult()) then
		local msg = GetOnscreenKeyboardResult()
    local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
		TriggerServerEvent("call:makeCall", type, {
			x = plyPos.x,
			y = plyPos.y,
			z = plyPos.z
		}, msg)
	end
end)
--

function ShowNotificationMenuCivil2(text)
	TriggerEvent('esx:showNotification', text)
end

function openTelephone()
  TriggerEvent('NB:closeAllSubMenu')
  TriggerEvent('NB:closeAllMenu')
  TriggerEvent('NB:closeMenuKey')
  
  TriggerEvent('NB:openMenuTelephone')
end

RegisterNetEvent("gcPhone:sendToClientStartCall")
AddEventHandler("gcPhone:sendToClientStartCall", function(num, job)
	TriggerServerEvent('gcPhone:startCall', num, job)
end)