ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local enableDepositWithdrawTransferCommand = true -- Enable or disable commands /deposit, /withdraw and /transfer
local commandAway = true -- Set to false if you moved your commands to another file

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  local source = source
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Valeur trop grande^0")
        CancelEvent()
      else
      	if(tonumber(rounded) <= tonumber(user.getMoney())) then
			user.removeMoney(rounded)
			user.addBank(rounded)
			local balance = user.getBank()
			TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Dépôt de: ~g~".. rounded .."$. ~n~~s~Nouveau solde: ~g~$" .. balance)
			TriggerClientEvent("banking:addBalance", source, rounded)
			TriggerClientEvent("banking:addBalance", source, rounded)
			TriggerClientEvent("banking:updateBalance", source, balance)
			TriggerEvent('logs:write', "A déposé "..rounded.."$ à la banque, son nouveau solde est de "..balance..'$', source)
			CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous n'avez pas assez d'argent^0")
          CancelEvent()
        end
      end
  end)
end)

RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
  local source = source
    TriggerEvent('es:getPlayerFromId', source, function(user)
    user.removeBank(amount)
    local balance = user.getBank()
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Nouveau solde: ~g~$" .. balance)
		TriggerClientEvent("banking:removeBalance", source, amount)
    TriggerClientEvent("banking:updateBalance", source, balance)
		CancelEvent()
    end)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  local source = source
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Valeur trop élevée! 999.999.999$ maximum^0")
        CancelEvent()
      else
        local balance = user.getBank()
        if(tonumber(rounded) <= tonumber(balance)) then
          user.removeBank(rounded)
          user.addMoney(rounded)
          balance = user.getBank()
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Retrait de: ~g~".. rounded .."$. ~n~~s~Nouveau solde: ~g~$" .. balance)
          TriggerClientEvent("banking:removeBalance", source, rounded)
          TriggerClientEvent("banking:updateBalance", source, balance)
			TriggerEvent('logs:write', "A retiré "..rounded.."$, son nouveau solde est de "..balance..'$', source)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous n'avez pas assez d'argent sur votre compte^0")
          CancelEvent()
        end
      end
  end)
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
    local source = source
    fromPlayer = source
  if tonumber(fromPlayer) == tonumber(toPlayer) then
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Tu ne peux pas te donner de l'argent^0")
    CancelEvent()
  else
    TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Valeur trop grande^0")
          CancelEvent()
        else
          local bankbalance = user.getBank()
				print('Player balance: ' .. bankbalance .. '  Send: ' .. rounded)
          if(tonumber(rounded) <= tonumber(bankbalance)) then
            user.removeBank(rounded)
            local new_balance = user.getBank()
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Transféré: ~r~-$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:removeBalance", source, rounded)
			TriggerEvent('logs:write', "A Transféré "..rounded.."$ à "..GetPlayerName(toPlayer)..", son nouveau solde est de "..new_balance..'$', fromPlayer)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
                user2.addBank(rounded)
                new_balance2 = user2.getBank()
                TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Reçu: ~g~$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance2)
                TriggerClientEvent("banking:updateBalance", toPlayer, new_balance2)
                TriggerClientEvent("banking:addBalance", toPlayer, rounded)
				TriggerEvent('logs:write', "A reçu un transfère de "..rounded.."$ de la par de "..GetPlayerName(fromPlayer)..", son nouveau solde est de "..new_balance2..'$', toPlayer)
                CancelEvent()
            end)
            CancelEvent()
          else
            TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous n'avez pas assez d'argent sur votre compte^0")
            CancelEvent()
          end
        end
    end)
  end
end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
  local source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.getMoney()) >= tonumber(amount)) then
			local player = user.identifier
			user.removeMoney(amount)
			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
				recipient.addMoney(amount)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent donne: ~r~-$".. amount .." ~n~~s~Porte-feuille: ~g~$" .. user.getMoney())
				TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent recu: ~g~$".. amount .." ~n~~s~Porte-feuille: ~g~$" .. recipient.getMoney())
				TriggerEvent('logs:write', "A donné "..amount.."$ de cash à "..GetPlayerName(toPlayer), source)
			end)
		else
			if (tonumber(user.money) < tonumber(amount)) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent^0")
        CancelEvent()
			end
		end
	end)
end)

RegisterServerEvent('bank:givedirty')
AddEventHandler('bank:givedirty', function(toPlayer, amount)
  local source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.getDirtyMoney()) >= tonumber(amount)) then
			user.removeDirtyMoney(amount)
			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
				recipient.addDirtyMoney(amount)
        local new_balance = user.getDirtyMoney()
        local new_balance2 = recipient.getDirtyMoney()
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Tu as donné ~r~".. amount .."$~n~ d'argent sale.~n~~s~ Porte-feuille: ~g~$" .. new_balance)
				TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Tu as reçu ~g~".. amount .."$~n~ d'argent sale.~n~~s~ Porte-feuille: ~g~$" .. new_balance2)
				TriggerEvent('logs:write', "A donné "..amount.."$ de cash sale à "..GetPlayerName(toPlayer), source)
			end)
		else
			if (tonumber(user.getDirtyMoney()) < tonumber(amount)) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Tu n'as pas assez d'argent^0")
        CancelEvent()
			end
		end
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
  local source = source
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local balance = user.getBank()
            local result = "NIQUE TA MERE SQL"
            TriggerClientEvent("banking:updateBalance", source, balance, result)    
    end)
end)
--[[RegisterServerEvent('GetBalanceAndName')
AddEventHandler('GetBalanceAndName', function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  print(xPlayer.identifier)
 --   local balance = user.getBank()
        MySQL.Async.fetchAll(
          'SELECT * FROM `users` WHERE `identifier` = @identifier' ,
        {
            ['@identifier'] = xPlayer.identifier
        },
        function(result)
            --local name = result[1].name
            --local balance = result[1].bank
            TriggerClientEvent("banking:updateBalance",result[1].bank, result[1].name)
            print(result[1].name)
            print(result[1].bank)
        end    
    )
end)]]
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

