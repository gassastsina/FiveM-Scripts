--------------------------------------------------------
--------------------------------------------------------
----    File : cam.lua       						----
----    Author : gassastsina    					----
----    Side : client         						----
----    Description : Cameras in the Pacific Bank 	----
--------------------------------------------------------
--------------------------------------------------------

-----------------------------------------------ESX-------------------------------------------------------
ESX           = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1000)
  end
end)

-----------------------------------------------main------------------------------------------------------
local fov_max = 10.0
local fov_min = 170.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 1.0 -- camera zoom speed
local speed_lr = 6.0 -- speed by which the camera pans left-right 
local speed_ud = 6.0 -- speed by which the camera pans up-down
local fov = (fov_max+fov_min)*0.5

local function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

local function HandleZoom(cam)
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

local function HideHUDThisFrame()
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

function WatchCam(camera)
	TriggerEvent('esx:ShowHUD', false, 0.0)
	SetTimecycleModifier("secret_camera")
	SetTimecycleModifierStrength(0.3)
	local scaleform = RequestScaleformMovie("security_camera")

	while not HasScaleformMovieLoaded(scaleform) do
		Wait(100)
	end

	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

	for i=1, #Config.Cameras, 1 do
		if Config.Cameras[i].value == camera then
			SetCamCoord(cam, Config.Cameras[i].x, Config.Cameras[i].y, Config.Cameras[i].z)
			SetCamRot(cam, 0.0, 0.0, Config.Cameras[i].heading)
		end
	end
	SetCamFov(cam, fov)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
	PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
	PopScaleformMovieFunctionVoid()

	local camNum = camera
	while not IsControlJustPressed(0, 177) and not IsEntityDead(GetPlayerPed(-1)) do
		Wait(10)
		if IsControlJustPressed(0, 174) or IsControlJustPressed(0, 173) then -- Toggle Helicam
			camNum = camNum - 1
			if camNum < 1 then
				camNum = Config.MaxCam
			end
			break
		elseif IsControlJustPressed(0, 175) or IsControlJustPressed(0, 27) then -- Toggle Helicam
			camNum = camNum + 1
			if camNum > Config.MaxCam then
				camNum = 1
			end
			break
		end
		CheckInputRotation(cam, (1.0/(fov_max-fov_min))*(fov-fov_min))
		HandleZoom(cam)
		HideHUDThisFrame()
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	ClearTimecycleModifier()
	fov = (fov_max+fov_min)*0.5
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cam, false)
	if camera ~= camNum then
		WatchCam(camNum)
	end
	TriggerEvent('esx:ShowHUD', true, 1.0)
end