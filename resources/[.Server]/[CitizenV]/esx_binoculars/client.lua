-------------------------------------------------------------------------
--               			From mraes & Cr4zZyBipBiip			   	   --
--							By ZAUB1								   --
--							Edited by gassastsina					   --
--               			#Description binoculars				  	   --
--							#lastEdit 02/06/18					       --
-------------------------------------------------------------------------

--CONFIG--
local fov_max = 3.0
local fov_min = 50.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 1.0 -- camera zoom speed
local speed_lr = 6.0 -- speed by which the camera pans left-right 
local speed_ud = 6.0 -- speed by which the camera pans up-down

local helicam = false
local fov = (fov_max+fov_min)*0.5

ESX           = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(50)
  end
end)

--EVENTS--
RegisterNetEvent('esx_binoculars:use')
AddEventHandler('esx_binoculars:use', function()
	ESX.UI.Menu.CloseAll()
	if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

		Citizen.CreateThread(function()
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
			PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		end)
		Wait(2000)
	end
	TriggerEvent('esx:ShowHUD', false, 0.0)

	SetTimecycleModifier("telescope")
	SetTimecycleModifierStrength(0.3)
	local scaleform = RequestScaleformMovie("binoculars")

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

	AttachCamToEntity(cam, GetPlayerPed(-1), 0.0, 0.4, 0.7, true)
	SetCamRot(cam, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)))
	SetCamFov(cam, fov)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
	PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
	PopScaleformMovieFunctionVoid()

	helicam = true
	--print('scaleform is loading')
	while helicam and not IsEntityDead(GetPlayerPed(-1)) do

		if IsControlJustPressed(0, 177) then -- Toggle Helicam

			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			ClearPedTasks(GetPlayerPed(-1))
			helicam = false
		end
		CheckInputRotation(cam, (1.0/(fov_max-fov_min))*(fov-fov_min))
		HandleZoom(cam)
		HideHUDThisFrame()
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(10)

	end

	ClearTimecycleModifier()
	fov = (fov_max+fov_min)*0.5
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cam, false)
	helicam = false
	TriggerEvent('esx:ShowHUD', true, 1.0)
end)

--FUNCTIONS--
function HideHUDThisFrame()
	HideHelpTextThisFrame()
	DisableRadarThisFrame()
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

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(29, 97) and fov < fov_min then -- Scrollup
		local zoomStep = 5*(fov/15)
		fov = math.max(fov - zoomspeed, fov + zoomStep)

	elseif IsControlJustPressed(29, 96) and fov > fov_max then
		local zoomStep = 5*(fov/15)
		fov = math.min(fov + zoomspeed, fov - zoomStep) -- ScrollDown
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.03) -- Smoothing of camera zoom
end