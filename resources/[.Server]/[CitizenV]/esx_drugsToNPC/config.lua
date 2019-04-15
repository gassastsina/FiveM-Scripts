------------------------------------------------
------------------------------------------------
----    File : config.lua       			----
----    Author : gassastsina    			----
----    Side : client & server 				----
----    Description : Sell drugs to NPCs 	----
------------------------------------------------
------------------------------------------------

Config = {}
Config.Drugs = {--A trier du plus cher au moins cher
	{name = "meth6", 	priceMin = 100,	priceMax = 120},
	{name = "lsd5", 	priceMin = 55,	priceMax = 65},
	{name = "coke6", 	priceMin = 55,	priceMax = 65},
	{name = "weed5", 	priceMin = 25, 	priceMax = 35},

	{name = "jewel", 	priceMin = 50, priceMax = 100}
}

Config.MinCopsToSell = 1

Config.Zones = {
	enable = false,
	['meth6'] = {
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = }
	},
	['lsd5'] = {
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = }
	},
	['coke6'] = {
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = }
	},
	['weed5'] = {
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = },
		{x = , y = , z = , radius = , multiplier = }
	}
}