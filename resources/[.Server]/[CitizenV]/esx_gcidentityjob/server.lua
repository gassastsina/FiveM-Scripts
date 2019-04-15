-----------------------------------------
-----------------------------------------
----    File : server.lua       	 ----
----    Author : Jonathan D @ Gannon ----
----    Edited 1 by : Chubbs (ADRP)	 ----
----    Edited 2 by : gassastsina 	 ----
----    Side : server         		 ----
----    Description : Job Identity 	 ----
-----------------------------------------
-----------------------------------------

ESX 						   		= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function getIdentity(source, callback)
	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier", {['@identifier'] = identifier},
	function(result)
	    if result[1]['lastname'] ~= nil then
			local data = {
				identifier  = result[1]['identifier'],
				lastname    = result[1]['lastname'],	--Nom
				firstname   = result[1]['firstname'],	--Prénom
				job_name   	= ESX.GetPlayerFromId(_source).job.name or result[1]['job'],
				job        	= result[1]['job'],
				grade_num   = result[1]['job_grade'],
				grade       = result[1]['job_grade'],
				phone       = tostring(result[1]['phone_number']),
				matricule	= tostring(result[1]['matricule'])
			}
			MySQL.Async.fetchAll("SELECT * FROM `job_grades` WHERE `job_name`=@job_name AND `grade`=@grade", {['@job_name'] = data.job_name, ['@grade'] = data.grade_num},
			function(result2)
				data.grade = result2[1]['label']

				MySQL.Async.fetchAll("SELECT * FROM `jobs` WHERE `name`=@name", {['@name'] = data.job_name},
				function(result3)
					data.job = result3[1]['label']
					callback(data)
				end)
			end)
		else
			local data = {
				identifier  = '',
				lastname    = '',
				firstname 	= '',
				job_name 	= '',
				job   		= '',
				grade_num   = '',
				grade       = '',
				phone     	= '',
				matricule  	= ''
			}
			callback(data)
	    end
	end)
end



RegisterServerEvent('esx_gcidentityjob:openShareIdentity')
AddEventHandler('esx_gcidentityjob:openShareIdentity',function(other)
	local _source = source
	local player = tonumber(other)
    TriggerEvent('logs:write', 'Montre sa carte de job à '..GetPlayerName(player), source)
    getIdentity(source, function(data)
        TriggerClientEvent('esx_gcidentityjob:showItentity', player, {
            nom 		= data.lastname,
            prenom 		= data.firstname,
            job_name	= data.job_name,
            job 		= data.job,
            grade_num 	= data.grade_num,
            grade 		= data.grade,
            phone 		= data.phone,
            matricule 	= data.matricule
        }, _source)
    end)
end)

RegisterServerEvent('esx_gcidentityjob:openMeIdentity')
AddEventHandler('esx_gcidentityjob:openMeIdentity', function()
    TriggerEvent('logs:write', 'Regarde sa carte de job', source)
	local player = source
    getIdentity(source, function(data)
        TriggerClientEvent('esx_gcidentityjob:showItentity', player, {
            nom 		= data.lastname,
            prenom 		= data.firstname,
            job_name	= data.job_name,
            job 		= data.job,
            grade_num 	= data.grade_num,
            grade 		= data.grade,
            phone 		= data.phone,
            matricule 	= data.matricule
        }, 'me')
    end)
end)