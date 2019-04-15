------------------------------------------------
------------------------------------------------
----    File : paycheck_company.lua        	----
----    Edited : gassastsina     			----
----	Side : server 						----
----    Description : Paycheck to companies ----
------------------------------------------------
------------------------------------------------

ESX.StartPayCheck = function ()

	function payCheck ()
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
		  	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		  	if xPlayer.job.grade_name == 'interim' or xPlayer.job.grade_name == 'rsa' or xPlayer.job.grade_name == 'employee' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'police' or xPlayer.job.name == 'etat' or xPlayer.job.name == 'justice' then -- Si il n'est pas dans une société, je prends chez l'état
		    	if xPlayer.job.grade_salary > 0 then
		      		xPlayer.addAccountMoney('bank',xPlayer.job.grade_salary)
		    		TriggerClientEvent('esx:showNotification', xPlayer.source, ('L\'état vous a payé ') .. '~g~$' .. xPlayer.job.grade_salary)
					TriggerEvent('logs:write', "Vient de recevoir son salaire de l'état", xPlayer.source)
		    	end
		    	
		  	elseif xPlayer.job.grade_salary > 0 then -- Sinon je prends l'argent dans la société
				local societyName = xPlayer.job.name
				if societyName == 'reporter' then
					societyName = 'cnn'
				end
		    	TriggerEvent('esx_society:getSociety', societyName, function (society)
			    	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
				    	if account.money >= xPlayer.job.grade_salary then
							xPlayer.addAccountMoney('bank',xPlayer.job.grade_salary)
							account.removeMoney(xPlayer.job.grade_salary)
							TriggerEvent('logs:write', "Vient de recevoir son salaire de l'entreprise", xPlayer.source)
							TriggerClientEvent('esx:showNotification', xPlayer.source, ('Votre entreprise vous a payé ') .. '~g~$' .. xPlayer.job.grade_salary)
				    	else
				      		TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Votre entreprise n\'a plus d\'argent pour vous payer !')
				    	end
			  		end)
		  		end)
			end
			TriggerEvent('logs:writeWhiteoutPlayer', "Le salaire vient d'être retiré des entreprises")
		end

    SetTimeout(Config.PaycheckInterval, payCheck)
  	end
  	SetTimeout(Config.PaycheckInterval, payCheck)
end