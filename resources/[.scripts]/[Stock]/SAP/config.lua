---------------------------------------------
---------------------------------------------
----    File : config.lua       		 ----
----    Author: gassastsina     		 ----
----	Side : client/server 		 	 ----
----    Description : San Andreas Petrol ----
---------------------------------------------
---------------------------------------------

Config              = {}
Config.DrawDistance = 50.0
Config.MarkerType   = 1
Config.MarkerSize   = {x = 2.2, y = 2.2, z = 0.5}
Config.MarkerColor  = {r = 102, g = 51, b = 0}

Config.SAP = {

	OnService = {x = -43.4985, y = -2520.0122, z = 6.3942}, 

	Vehicles = {
		Spawner 		  = {x = -48.1399, y = -2508.4235, z = 6.3961},
		SpawnPoint 		  = {x = -46.1953, y = -2499.2116, z = 5.0183},
		Heading    		  = 229.025,
		Deleter 		  = {x = -65.1285, y = -2525.4155, z = 5.0100}, --Même que le spawn
		MarkerSizeDeleter = 5,
		Trailer 		  = {x = -53.514, y = -2493.228, z = 6.000}
	},

	Harvest 			= {x = 2768.4575, y = 1709.6086, z = 23.6247},
	JerryCanHarvest 	= {x = 2880.7326, y = 4418.8842, z = 48.6267},
	JerryCanTreatment 	= {x = 566.1223, y = -1835.9257, z = 24.3319},

	BossActions = {x = -59.3559, y = -2518.6276, z = 6.4011} --Coffre
}