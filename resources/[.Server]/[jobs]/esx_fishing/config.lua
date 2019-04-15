------------------------------------
------------------------------------
----    File : config.lua    	----
----    Edited by : gassastsina ----
----    Side : client/server    ----
----    Description : Fishing 	----
------------------------------------
------------------------------------

Config                        = {}
Config.DrawDistance           = 50.0
Config.MarkerType             = 1
Config.MarkerSize             = {x = 1.8, y = 1.8, z = 0.5}
Config.MarkerColor            = {r = 0, g = 0, b = 255}

Config.Fisherman = {

	OnService = {x = -1600.8594, y = 5204.4550, z = 3.3100}, 

	Vehicles = {
		Spawner 			= {x = -1575.7760, y = 5173.6210, z = 18.5626},
		SpawnPoint 			= {x = -1577.2128, y = 5162.3017, z = 19.6611},
		Heading    			= 185.1952,
		Deleter 			= {x = -1577.2128, y = 5162.3017, z = 19.6611}, --Même que le spawn
		MarkerSizeDeleter	= 6
	},

	Boat = {
		Spawner 			= {x = -1609.5587, y = 5260.8959, z = 2.9741},
		SpawnPoint 			= {x = -1614.9999, y = 5267.9999, z = 1.0000},
		Heading    			= 295.00,
		Deleter 			= {x = -1614.9999, y = 5267.9999, z = 1.0000}, --Même que le spawn
		MarkerSizeDeleter	= 5
	},

	HarvestGazBottles = {x = -1303.2321, y = -1369.5134, z = 3.509},
	HarvestPlungeWear = {x = 714.2399, y = 4103.3051, z = 34.7851},
	Harvest 	= {x = -1809.0000, y = 6059.0000, z = 2.0000, size = 90.0}, 
	Treatment 	= {x = 970.3112, y = -1628.9051, z = 29.1106},
	Sell 		= {x = -1040.0965, y = -1396.7770, z = 4.5531},

	BossActions = {x = -1592.6247, y = 5203.1127, z = 3.3100} --Coffre
}