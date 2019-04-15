-----------------------------------------------
-----------------------------------------------
----    File : config.lua       		   ----
----    Author : gassastsina    		   ----
----    Side : client/server   			   ----
----    Description : Pacific Bank hold up ----
-----------------------------------------------
-----------------------------------------------

Config = {}
Config.MarkerSize 	= {x = 1.5, y = 1.5, z = 0.3}
Config.MarkerColor 	= {r = 0, g = 255, b = 0}
Config.DrawMarker 	= 20
Config.MarkerType 	= 1

Config.MinCops = 0
Config.HackAlarmSuccess = 40000
Config.HackAlarmError 	= 0

Config.ChestRewards = {
	Items = {
		{name = 'jewel', min = 1, max = 25}
	},
	Rare = {
		{name = 'jargon', min = 1, max = 1}
	},
	BlackMoney = {min = 500, max = 2000}
}

Config.DrillChests = {
	--Left before door
	{x = 257.647, y = 218.423, z = 101.683, heading = 343.695, available = true},
	{x = 258.389, y = 218.160, z = 101.683, heading = 343.480, available = true},
	{x = 258.885, y = 218.039, z = 101.683, heading = 342.576, available = true},
	{x = 259.329, y = 217.793, z = 101.683, heading = 338.389, available = true},
	{x = 259.808, y = 217.628, z = 101.683, heading = 346.067, available = true},
	{x = 260.239, y = 217.509, z = 101.683, heading = 339.224, available = true},
	{x = 260.712, y = 217.231, z = 101.683, heading = 343.683, available = true},
	{x = 261.348, y = 217.056, z = 101.683, heading = 337.962, available = true},
	--Right before door
	{x = 256.598, y = 214.939, z = 101.683, heading = 159.780, available = true},
	{x = 257.263, y = 214.751, z = 101.683, heading = 160.520, available = true},
	{x = 257.743, y = 214.600, z = 101.683, heading = 158.207, available = true},
	{x = 258.169, y = 214.490, z = 101.683, heading = 158.071, available = true},
	{x = 258.552, y = 214.323, z = 101.683, heading = 160.111, available = true},
	{x = 259.024, y = 214.128, z = 101.683, heading = 159.672, available = true},
	{x = 259.447, y = 213.920, z = 101.683, heading = 158.348, available = true},
	{x = 260.159, y = 213.702, z = 101.683, heading = 160.827, available = true},
	--Left after door
	{x = 263.050, y = 216.585, z = 101.683, heading = 342.118, available = true},
	{x = 263.567, y = 216.293, z = 101.683, heading = 342.398, available = true},
	{x = 264.043, y = 216.107, z = 101.683, heading = 338.683, available = true},
	{x = 264.396, y = 215.938, z = 101.683, heading = 337.921, available = true},
	{x = 264.807, y = 215.793, z = 101.683, heading = 338.974, available = true},
	{x = 265.226, y = 215.601, z = 101.683, heading = 339.508, available = true},
	{x = 265.616, y = 215.426, z = 101.683, heading = 340.668, available = true},
	{x = 266.185, y = 215.365, z = 101.683, heading = 340.874, available = true},
	--Right after door
	{x = 261.826, y = 213.234, z = 101.683, heading = 158.718, available = true},
	{x = 262.420, y = 212.869, z = 101.683, heading = 160.720, available = true},
	{x = 262.798, y = 212.664, z = 101.683, heading = 159.387, available = true},
	{x = 263.119, y = 212.529, z = 101.683, heading = 158.015, available = true},
	{x = 263.642, y = 212.490, z = 101.683, heading = 166.403, available = true},
	{x = 264.032, y = 212.299, z = 101.683, heading = 163.924, available = true},
	{x = 264.454, y = 212.080, z = 101.683, heading = 159.298, available = true},
	{x = 265.091, y = 211.879, z = 101.683, heading = 161.016, available = true},
	--Front after door
	{x = 266.393, y = 215.011, z = 101.683, heading = 251.126, available = true},
	{x = 266.127, y = 214.515, z = 101.683, heading = 248.383, available = true},
	{x = 265.959, y = 214.159, z = 101.683, heading = 249.545, available = true},
	{x = 265.828, y = 213.830, z = 101.683, heading = 250.504, available = true},
	{x = 265.677, y = 213.382, z = 101.683, heading = 248.716, available = true},
	{x = 265.501, y = 213.033, z = 101.683, heading = 251.294, available = true},
	{x = 265.331, y = 212.631, z = 101.683, heading = 251.671, available = true},
	{x = 265.172, y = 212.103, z = 101.683, heading = 250.567, available = true},
	--Others
	{x = 261.854, y = 220.585, z = 101.683, heading = 156.751, available = true},
	{x = 262.444, y = 220.327, z = 101.683, heading = 158.522, available = true},
	{x = 263.141, y = 220.116, z = 101.683, heading = 101.683, available = true},

	{x = 249.102, y = 230.090, z = 106.287, heading = 337.875, available = true},
	{x = 248.479, y = 230.395, z = 106.287, heading = 340.706, available = true},
	{x = 245.369, y = 231.587, z = 106.287, heading = 343.051, available = true},
	{x = 244.638, y = 231.844, z = 106.287, heading = 338.223, available = true},
	{x = 244.069, y = 232.026, z = 106.287, heading = 342.308, available = true},
	{x = 243.496, y = 232.371, z = 106.287, heading = 342.239, available = true},
	{x = 242.770, y = 231.098, z = 106.287, heading = 69.724, available = true},
	{x = 242.455, y = 230.439, z = 106.287, heading = 70.485, available = true},
	{x = 242.368, y = 229.870, z = 106.287, heading = 69.477, available = true},
	{x = 241.994, y = 229.268, z = 106.287, heading = 70.070, available = true},

	{x = 262.447, y = 211.134, z = 110.288, heading = 69.724, available = true},

	{x = 263.624, y = 208.921, z = 110.288, heading = 336.364, available = true},
	{x = 264.291, y = 208.712, z = 110.288, heading = 337.887, available = true},
	{x = 249.140, y = 208.039, z = 110.283, heading = 161.723, available = true},
	{x = 243.544, y = 210.240, z = 110.283, heading = 158.717, available = true},
	{x = 232.484, y = 218.798, z = 110.283, heading = 69.104, available = true}
}

Config.Zones = {
	Computer = {
		Pos = {x = 261.245, y = 204.746, z = 110.287}
	},
	DoorHack = {
		Pos = {x = 253.358, y = 228.402, z = 101.683}
	},
	Melt 	= {
		Pos = {x = 1110.338, y = -2006.701, z = 30.934}
	}
}

Config.Alarm = {
	Distance = 300,
	File 	 = 'burglarbell'
}

Config.Cameras = {
	{label = "Entrée 1", 		x = 233.03, y = 221.65, z = 108.00, heading = 209.07, value = 1},
	{label = "Entrée 2", 		x = 263.09, y = 206.02, z = 108.00, heading = 118.00, value = 2},
	{label = "Entrée 3", 		x = 266.67, y = 215.88, z = 108.00, heading = 125.92, value = 3},
	{label = "Hall 1", 			x = 241.68, y = 214.59, z = 108.00, heading = 318.87, value = 4},
	{label = "Hall 2", 			x = 255.54, y = 205.72, z = 108.00, heading = 27.17, value = 5},
	{label = "Escalier Coffre", x = 269.69, y = 223.67, z = 108.00, heading = 109.73, value = 6},
	{label = "Coffre", 			x = 252.05, y = 225.47, z = 104.00, heading = 259.30, value = 7},
	{label = "RDC Bureaux",		x = 260.93, y = 220.30, z = 110.00, heading = 60.43, value = 8},
	{label = "Bureaux 1",		x = 258.39, y = 204.83, z = 114.00, heading = 339.65, value = 9},
	{label = "Bureaux 2",		x = 261.95, y = 218.05, z = 114.00, heading = 197.28, value = 10},
	{label = "RDC Escalier 1", 	x = 240.17, y = 229.71, z = 108.00, heading = 95.84, value = 11},
	{label = "Escalier 1", 		x = 239.51, y = 227.97, z = 114.00, heading = 20.72, value = 12},
	{label = "Escalier 2", 		x = 269.68, y = 223.67, z = 114.00, heading = 112.12, value = 13},
	{label = "Étage 1",			x = 235.38, y = 227.58, z = 114.00, heading = 202.43, value = 14},
	{label = "Étage 2",			x = 255.23, y = 205.82, z = 114.00, heading = 27.88, value = 15}
}
Config.MaxCam = 15

Config.EnterWithWeapon = {
	Pos 	= {x = 252.0, y = 221.0, z = 106.0},
	Radius 	= 17.0
}
Config.BlacklistedWeapons 	= {
	'WEAPON_UNARMED',
	'WEAPON_FLASHLIGHT',
	'WEAPON_FIREEXTINGUISHER',
	'WEAPON_PETROLCAN',
	'WEAPON_SNOWBALL',
	'WEAPON_BALL',
	'WEAPON_FLARE',
	'GADGET_PARACHUTE',
	'GADGET_NIGHTVISION'
}