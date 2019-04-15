-----------------------------------------------
-----------------------------------------------
----    File : config.lua  	   			   ----
----    Author : gassastsina   			   ----
----    Side : client        	  		   ----
----    Description : Rendall Air Delivery ----
-----------------------------------------------
-----------------------------------------------

Config                            = {}
Config.DrawDistance               = 80.0
Config.MarkerType                 = 1
Config.MarkerSize                 = {x = 2.0, y = 2.0, z = 0.8}
Config.Zones = {
	HarvestMarchandise = {
		MarkerColor = {r = 255, g = 215, b = 0},
		Pos 		= {x = 1375.286, y = 3005.154, z = 41.004}
	},

	SellMarchandise = {
		MarkerColor = {r = 255, g = 215, b = 0},
		Pos 		= {x = -1378.281, y = -2683.967, z = 13.945}
	},

	Garage = {
		MarkerColor = {r = 0, g = 51, b = 255},
		Pos = {x = -1285.0077, y = -3420.8438, z = 13.9402},
		SpawnPoint = {x = -1275.8501, y = -3387.7690, z = 14.7000},
		Heading = 329.4073
	},
	DeleteVehicle = {
		MarkerColor = nil,
		Pos = {x = -1275.8501, y = -3387.7690, z = 14.7000}
	},

	Cloakroom = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos 		= {x = -1235.6345, y = -3391.8826, z = 13.9505}
	},

	BossAction = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos 		= {x = -1238.3721, y = -3394.4597, z = 13.9505}
	}
}