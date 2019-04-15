Config = {}
Config.Locale = 'fr'
Config.AlarmDistance = 240
Config.AlarmSound = 0.1

Banks = {
	["fleeca"] = {
		position = { ['x'] = 147.04908752441, ['y'] = -1044.9448242188, ['z'] = 29.36802482605 },
		Alarm = {x = 135.38, y = -1047.38, z = 29.15},
		reward = math.random(100000,140000),
		nameofbank = "Fleeca Bank (Vespucci Boulevard)",
		lastrobbed = 0,
		NumberOfCopsRequired = 3,
		AlarmHackedTimeBeforeCallPolice = 85000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 120000
	},
	["fleeca2"] = {
		position = { ['x'] = -2957.6674804688, ['y'] = 481.45776367188, ['z'] = 15.697026252747 },
		Alarm = {x = -2947.47, y = 481.30, z = 15.26},
		reward = math.random(80000,100000),
		nameofbank = "Fleeca Bank (Great Ocean Highway)",
		lastrobbed = 0,
		NumberOfCopsRequired = 2,
		AlarmHackedTimeBeforeCallPolice = 100000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 180000
	},
	["fleeca3"] = {
		position = { ['x'] = -1211.3022804688, ['y'] = -335.45776367188, ['z'] = 37.787026252747 },
		Alarm = {x = -1216.52, y = -332.69, z = 42.12},
		reward = math.random(100000,140000),
		nameofbank = "Fleeca Bank (Boulevard Del Perro)",
		lastrobbed = 0,
		NumberOfCopsRequired = 3,
		AlarmHackedTimeBeforeCallPolice = 60000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 120000
	},
	["fleeca4"] = {
		position = { ['x'] = 311.5424804688, ['y'] = -283.41776367188, ['z'] = 54.164026252747 },
		Alarm = {x = 309.47, y = -279.40, z = 54.16},
		reward = math.random(100000,140000),
		nameofbank = "Fleeca Bank (Popular Street)",
		lastrobbed = 0,
		NumberOfCopsRequired = 3,
		AlarmHackedTimeBeforeCallPolice = 60000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 120000
	},
	["fleeca5"] = {
		position = { ['x'] = -353.6037804688, ['y'] = -54.18776367188, ['z'] = 49.037026252747 },
		Alarm = {x = -356.73, y = -49.98, z = 54.42},
		reward = math.random(100000,140000),
		nameofbank = "Fleeca Bank (Hawick Avenue)",
		lastrobbed = 0,
		NumberOfCopsRequired = 3,
		AlarmHackedTimeBeforeCallPolice = 60000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 120000
	},
	["fleeca6"] = {
		position = { ['x'] = 1176.52, ['y'] = 2712.07, ['z'] = 38.10 },
		Alarm = {x = 1204.50, y = 2709.65, z = 38.00},
		reward = math.random(50000,75000),
		nameofbank = "Fleeca Bank (Route 68)",
		lastrobbed = 0,
		NumberOfCopsRequired = 2,
		AlarmHackedTimeBeforeCallPolice = 30000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 90000
	},
	["blainecounty"] = {
		position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
		Alarm = {x = -96.941, y = 6475.385, z = 31.428},
		reward = math.random(900000,1200000),
		nameofbank = "Blaine County Savings",
		lastrobbed = 0,
		NumberOfCopsRequired = 4,
		AlarmHackedTimeBeforeCallPolice = 120000,
		AlarmHacked = false,
		robberyDistance = 9,
		robberyTime = 600000
	}
}