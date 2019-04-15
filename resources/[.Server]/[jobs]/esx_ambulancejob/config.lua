------------------------------------
------------------------------------
----    File : config.lua    	----
----    Edited by : gassastsina ----
----    Side : client/server    ----
----    Description : EMS 	 	----
------------------------------------
------------------------------------

Config                            = {}

Config.DrawDistance               = 50.0
Config.MarkerColor                = { r = 102, g = 0, b = 102 }
Config.MarkerSize                 = { x = 2.0, y = 2.0, z = 1.0 }
Config.ReviveReward               = 700  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders
Config.Locale                     = 'fr'

local second = 1000
local minute = 60 * second

-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 15 * minute

-- How much time before a menu opens to ask the player if he wants to respawn at hospital now
-- The player is not obliged to select YES, but he will be auto respawn
-- at the end of RespawnDelayAfterRPDeath just above.
Config.RespawnToHospitalMenuTimer   = true
Config.MenuRespawnToHospitalDelay   = 5 * minute

Config.EnablePlayerManagement       = true
Config.EnableSocietyOwnedVehicles   = false

Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = false
Config.RemoveItemsAfterRPDeath      = false

-- Will display a timer that shows RespawnDelayAfterRPDeath time remaining
Config.ShowDeathTimer               = false

-- Will allow to respawn at any time, don't use with RespawnToHospitalMenuTimer enabled!
Config.EarlyRespawn                 = false
-- The player can have a fine (on bank account)
Config.RespawnFine                  = true
Config.RespawnFineAmount            = 400

Config.Blip = {
	Pos     = { x = 307.76, y = -1433.47, z = 28.97 },
	Sprite  = 61,
	Display = 4,
	Scale   = 1.2,
	Colour  = 2,
}

Config.HelicopterSpawner = {
	SpawnPoint = { x = 313.33, y = -1465.2, z = 45.5 },
	Heading    = 0.0
}

-- https://wiki.fivem.net/wiki/Vehicles
Config.AuthorizedVehicles = {
	{model = 'ambulance', label = 'Ambulance'},
	{model = 'policeold2', label = 'Ford Utility'}
}

Config.Zones = {

	HospitalToRoof = {
		Pos	= { x = 247.1314, y = -1371.7596, z = 24.0000 },
		Type = -1
	},

	HospitalInteriorInside2 = { -- Roof
		Pos	= { x = 248.7,	y = -1369.7, z = 29.0 },
		Type = -1
	},

	HospitalInteriorEntering1 = { -- Main entrance
		Pos	= { x = 294.6152, y = -1448.1935, z = 28.9666 },
		Type = 1
	},

	--[[HospitalInteriorInside1 = {
		Pos	= { x = 272.8, y = -1358.8, z = 23.5 },
		Type = -1
	},

	HospitalInteriorOutside1 = {
		Pos	= { x = 295.8, y = -1446.5, z = 28.9 },
		Type = -1
	},]]

	HospitalInteriorExit1 = {
		Pos	= { x = 275.4644, y = -1361.0747, z = 23.5378 },
		Type = 1
	},

	--[[HospitalInteriorEntering2 = { -- Lift go to the roof
		Pos	= { x = 247.1, y = -1371.4, z = 23.5 },
		Type = 1
	},]]

	--[[HospitalInteriorOutside2 = { -- Lift back from roof
		Pos	= { x = 249.1,	y = -1369.6, z = 23.5 },
		Type = -1
	},]]

	--[[HospitalInteriorExit2 = { -- Roof entrance
		Pos	= { x = 335.5, y = -1432.0, z = 45.5 },
		Type = 1
	},]]

	AmbulanceActions = { -- Cloakroom
		Pos	= { x = 268.4, y = -1363.330, z = 23.5 },
		Type = 1
	},

	VehicleSpawner = {
		Pos	= { x = 307.76, y = -1433.47, z = 28.97 },
		Type = 1
	},

	VehicleSpawnPoint = {
		Pos	= { x = 304.87, y = -1437.69, z = 28.80 },
		Type = -1
	},

	VehicleDeleter = {
		Pos	= { x = 327.67, y = -1481.1, z = 28.83 },
		Type = 1
	},

	Pharmacy = {
		Pos	= { x = 230.13, y = -1366.18, z = 38.53 },
		Type = 1
	},

	ParkingDoorGoOutInside = {
		Pos	= { x = 234.56, y = -1373.77, z = 20.97 },
		Type = 1
	},

	ParkingDoorGoOutOutside = {
		Pos	= { x = 320.98, y = -1478.62, z = 28.81 },
		Type = -1
	},

	ParkingDoorGoInInside = {
		Pos	= { x = 238.64, y = -1368.48, z = 23.53 },
		Type = -1
	},

	ParkingDoorGoInOutside = {
		Pos	= { x = 317.97, y = -1476.13, z = 28.97 },
		Type = 1
	},

	--[[StairsGoTopTop = {
		Pos	= { x = 251.91, y = -1363.3, z = 38.53 },
		Type = -1
	},

	StairsGoTopBottom = {
		Pos	= { x = 237.45, y = -1373.89, z = 26.30 },
		Type = -1
	},

	StairsGoBottomTop = {
		Pos	= { x = 256.58, y = -1357.7, z = 37.30 },
		Type = -1
	},

	StairsGoBottomBottom = {
		Pos	= { x = 235.45, y = -1372.89, z = 26.30 },
		Type = -1
	},]]
----------------------------Run---------------------------
	FarmString = {
		Pos	= { x = 2309.360, y = 4885.748, z = 40.808 },
		Type = 1,
		Blip = 17,
		BlipColor = 49,
		Name = 'Récolte de Nilon'
	},

	FarmProduct = {
		Pos	= { x = -428.32, y = -455.168, z = 31.521 },
		Type = 1,
		Blip = 17,
		BlipColor = 49,
		Name = 'Récolte de Produits'
	},

	TreatmentString = {
		Pos	= { x = 68.133, y = -1569.221, z = 28.60 },
		Type = 1,
		Blip = 18,
		BlipColor = 49,
		Name = 'Traitement de Nilon'
	},

	TreatmentProduct = {
		Pos	= { x = 3535.090, y = 3659.973, z = 27.122 },
		Type = 1,
		Blip = 19,
		BlipColor = 49,
		Name = 'Traitement'
	}
}