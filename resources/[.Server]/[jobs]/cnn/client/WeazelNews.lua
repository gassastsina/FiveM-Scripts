----------------------------------
----------------------------------
----    File : WeazelNews.lua ----
----    Author : gassastsina  ----
----    Side : client         ----
----    Description : CNN 	  ----
----------------------------------
----------------------------------

local WeazelNewsCam = false

RegisterNetEvent('cnn:WeazelNewsStart')
AddEventHandler('cnn:WeazelNewsStart', function(msg)
	TriggerEvent('esx:ShowHUD', false, 0.0)
	introSoundStart()
	SetTimecycleModifier("CAMERA_BW")
	SetTimecycleModifierStrength(0.3)
	local scaleform = RequestScaleformMovie("breaking_news")

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	WeazelNewsCam = true
	Citizen.CreateThread(function()
		while WeazelNewsCam and not IsEntityDead(GetPlayerPed(-1)) do
			if IsControlJustPressed(0, 177) then -- Disable cam
				TriggerEvent('cnn:WeazelNewsStop')
			end
			HideHUDThisFrame()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			displayTitle(msg)
			Citizen.Wait(10)
		end
	end)
	Wait(15000)
	TriggerEvent('cnn:WeazelNewsStop')
end)

function displayTitle(msg)
	SetTextFont(8)
	SetTextProportional(false)
	SetTextScale(0.7, 0.7)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	SetTextEntry("STRING")
	AddTextComponentString(msg)
	DrawText(0.4, 0.8)
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

RegisterNetEvent('cnn:WeazelNewsStop')
AddEventHandler('cnn:WeazelNewsStop', function()
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	WeazelNewsCam = false
	introSoundStop()
	
	ClearTimecycleModifier()
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	TriggerEvent('esx:ShowHUD', true, 1.0)
end)


--This part is from InteractSound by Scott
function introSoundStart()
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = 'intro',
        transactionVolume   = Config.Journaliste.Message.IntroSoundVolume
    })
end
--This part has been edited by gassastsina to be adapted to InteractSound to stop the current sound
function introSoundStop()
    SendNUIMessage({
        transactionType     = 'stop'
    })
end