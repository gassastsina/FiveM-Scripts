-----------------------------------
-----------------------------------
----    File : paycheck.lua    ----
----    Edited : gassastsina   ----
----	Side : server 		   ----
----    Description : Paycheck ----
-----------------------------------
-----------------------------------

ESX.StartPayCheck = function()
  function payCheck()
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do

      local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
      if xPlayer.job.grade_salary > 0 then
        xPlayer.addBank(xPlayer.job.grade_salary)

        if xPlayer.job.grade_name == 'interim' then
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rec_help') .. '~g~$' .. xPlayer.job.grade_salary)
        else
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rec_salary') .. '~g~$' .. xPlayer.job.grade_salary)
        end
      end

    end
	TriggerEvent('logs:writeWhiteoutPlayer', "Le salaire vient d'être retiré des entreprises")

    SetTimeout(Config.PaycheckInterval, payCheck)
  end
  SetTimeout(Config.PaycheckInterval, payCheck)
end