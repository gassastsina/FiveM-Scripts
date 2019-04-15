----------------------------------------------
----------------------------------------------
----    File : config.lua                 ----
----    Author : gassastsina              ----
----	Side : client/server 			  ----
----    Description : Los Pollos Hermanos ----
----------------------------------------------
----------------------------------------------

-----------------------------------------------config-------------------------------------------------------
Config              = {}
Config.DrawDistance = 50.0
Config.MarkerType   = 1
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 0.7}
Config.Zones = {
	--LosPollosHermanos run
	MethToPollos = {
		MarkerColor = {r = 0, g = 0, b = 255},
		Pos 		= {x = 2129.221, y = 4770.687, z = 39.970}
	},
	PollosToMeth = {
		MarkerColor = {r = 0, g = 0, b = 255},
		Pos 		= {x = -937.131, y = -2931.408, z = 12.945}
	},

	GrapeseedInventory = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos 		= {x = 2120.846, y = 4782.868, z = 39.970}
	},
	LSInventory = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos 		= {x = -941.284, y = -2954.576, z = 18.845}
	},


	Garage = {
		MarkerColor = {r = 99, g = 208, b = 0},
		Pos = {x = -896.4297, y = -198.2100, z = 37.2928},
		SpawnPoint = {x = -898.9990, y = -202.0442, z = 37.2928},
		Heading = 69.630
	},
	DeleteVehicle = {
		MarkerColor = {r = 99, g = 208, b = 0},
		Pos = {x = -898.9990, y = -202.0442, z = 37.2928}
	},

	Market = {
		MarkerColor = {r = 239, g = 114, b = 0},
		Pos = {x = 614.6173, y = 2784.3300, z = 42.4812}
	},
	BossActions = {
		MarkerColor = {r = 253, g = 220, b = 12},
		Pos = {x = -897.4615, y = -237.6340, z = 38.8182}
	},
	Cloakroom = {
		MarkerColor = {r = 253, g = 220, b = 12},
		Pos = {x = -894.8315, y = -233.7243, z = 38.8188}
	},
	ItemChest = {
		MarkerColor = {r = 253, g = 220, b = 12},
		Pos = {x = -895.0423, y = -231.7485, z = 39.8190}
	},

	--Transformations
	PotatoesToChips = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos = {x = -897.5647, y = -232.2692, z = 38.8189}
	},
	BreadAndChickenAndVegegeToBurger = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos = {x = -898.7326, y = -233.6888, z = 38.8186}
	},
	MilkToMilshake = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos = {x = -898.0534, y = -229.6244, z = 38.8188}
	},
	ChickenToNuggets = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos = {x = -900.0942, y = -234.7113, z = 38.8184}
	},
	CoffeeMachine = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos = {x = -900.4530, y = -230.6409, z = 38.8186} 
	},
	DonutsMachine = {
		MarkerColor = {r = 253, g = 106, b = 2},
		Pos = {x = -904.2149, y = -235.4668, z = 39.8182}
	}
}

Config.Market = {
    {label = 'Pomme de terre', item = 'potato', price = 1},
    {label = 'Pain', item = 'bread', price = 1},
    {label = 'Légumes', item = 'vegetables', price = 1},
    {label = 'Café', item = 'coffee', price = 1},
    {label = 'Coca', item = 'cola', price = 1},
    {label = 'Sprunk', item = 'sprunk', price = 1},
    {label = 'Monster', item = 'monster', price = 1},
    {label = 'Lait', item = 'milk', price = 1},
    {label = 'Bière', item = 'beer', price = 2},
    {label = 'Cognac', item = 'cognak', price = 10},
    {label = 'Whisky', item = 'whiskey', price = 10},
    {label = 'Rhum', item = 'rum', price = 10},
    {label = 'Eau', item = 'water', price = 1},
    {label = 'Tequila', item = 'tequila', price = 10}
}

Config.CoffeeMachineMenu = {
	{label = 'Café vanille', toItem = 'coffee_vanilla'},
	{label = 'Café au Lait', toItem = 'coffee_milk'},
	{label = 'Café au chocolat', toItem = 'coffee_choco'},
	{label = 'Pingui coffee', toItem = 'coffee_iced'},
	{label = 'Chocolat chaud', toItem = 'hot_chocolate'},
	{label = 'Café framboise', toItem = 'raspberry_coffee'},
	{label = 'Café Manche', toItem = 'coffee_manche'}
}

Config.DonutsMachineMenu = {
	{label = 'Donut vanille', toItem = 'donut_vanilla'},
	{label = 'Donut chocolat', toItem = 'donut_choco'},
	{label = 'Pingui donut', toItem = 'donut_iced'},
	{label = 'Donut framboise', toItem = 'raspberry_donut'},
	{label = 'Donut fraise', toItem = 'strawberry_donut'},
	{label = 'Donut Manche', toItem = 'donut_manche'}
}

Config.Shop = {
	MarkerColor = {r = 253, g = 220, b = 12},
	Pos = {x = -906.3983, y = -233.8658, z = 38.8181},
	DefaultPrice = 10,
	ItemsPrice = {
		{name = 'burger', price = 10},
		{name = 'tacos', price = 9},
		{name = 'panini', price = 8},
		{name = 'pain', price = 7},
		{name = 'nugget', price = 2},
		{name = 'chips', price = 5},
		{name = 'milkshake', price = 8},
		{name = 'milk', price = 2},
		{name = 'vegetables', price = 4},
		{name = 'coffee', price = 7},
		{name = 'coffee_milk', price = 8},
		{name = 'coffee_vanilla', price = 10},
		{name = 'coffee_choco', price = 10},
		{name = 'coffee_iced', price = 10},
		{name = 'raspberry_coffee', price = 10},
		{name = 'coffee_manche', price = 10},
		{name = 'hot_chocolate', price = 7},
		{name = 'cola', price = 5},
		{name = 'sprunk', price = 5},
		{name = 'monster', price = 6},
		{name = 'water', price = 5},
		{name = 'beer', price = 15},
		{name = 'cognak', price = 20},
		{name = 'whiskey', price = 30},
		{name = 'rum', price = 30},
		{name = 'tequila', price = 30},
		{name = 'rum', price = 30},
		{name = 'donut_vanilla', price = 5},
		{name = 'donut_choco', price = 5},
		{name = 'donut_iced', price = 5},
		{name = 'raspberry_donut', price = 5},
		{name = 'strawberry_donut', price = 5},
		{name = 'donut_manche', price = 5}


	}
}