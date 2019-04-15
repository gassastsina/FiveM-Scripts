------------------------------------
------------------------------------
----    File : BossActions.lua  ----
----    Edited by : gassastsina ----
----    Side : client        	----
----    Description : Jobs 	 	----
------------------------------------
------------------------------------

local PlayerData 	   = {}

local function IsSlaughterer()
	if PlayerData.job.name == 'slaughterer' and PlayerData.job.grade_name == 'boss' then
		local InMarker = false
		while true do
			Citizen.Wait(10)
			local coords = GetEntityCoords(GetPlayerPed(-1))

			if Vdist(coords.x, coords.y, coords.z, -68.927, 6255.486, 31.090) < 3.0 then
	            SetTextComponentFormat("STRING")
				AddTextComponentString("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

	            if IsControlJustPressed(1, 38) then
					TriggerEvent('esx_society:openBossMenu', 'slaughterer', function(data, menu)
			        	menu.close()
			        end)
				end
	        elseif InMarker then
	        	InMarker = false
			end
		end
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	IsSlaughterer()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	IsSlaughterer()
end)