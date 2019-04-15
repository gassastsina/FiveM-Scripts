--------------------------------------
--------------------------------------
----    File : config.lua      	  ----
----    Author: gassastsina       ----
----	Side : client/server	  ----
----    Description : Informateur ----
--------------------------------------
--------------------------------------

-----------------------------------------------main-------------------------------------------------------
Config = {}

Config.PNJSpawn = {
	{x = 75.535, y = -1970.193, z = 20.125, heading = 137.717},
	{x = 76.620, y = -1948.324, z = 21.174, heading = 276.530},
	{x = 47.179, y = -1933.104, z = 21.904, heading = 111.608},
	{x = -3.079, y = -1821.538, z = 29.543, heading = 227.765}
}

Config.Menu = {
	{label = "Vendeur illégal", name = 'illegalseller' , price = 5000, x = 1538.9041, y = 3595.4633, z = 38.7664, heading = 199.3293, blipSprite = 188, id = 2, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "player_two"},
	{label = "Vendeur d'armes", name = 'illegalweapon' , price = 8000, x = 1095.4165, y = -3102.1872, z = -38.9999, xM = 1206.2615, yM = -3116.7260, zM = 5.5403, heading = 10.4973, blipSprite = 188, id = 1, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01"},
	{label = "Drogues", name = 'drug', price = 1500, x = 373.2053, y = -1788.1741, z = 29.0954, heading = 132.1968, blipSprite = 499, id = 3, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01"},
	{label = "Go Fast", name = 'go_fast', price = 3000, x = 37.7279, y = -1404.0662, z = 29.3399, heading = 178.2836, blipSprite = 488, id = 4, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "U_M_Y_Antonb"},
	{label = "Trafic d'êtres humains", name = 'pussy', price = 8000, x = 1007.218, y = -2891.2485, z = 39.1569, heading = 119.6502, blipSprite = 458, id = 5, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "IG_Popov"},
	{label = "Receleur", name = 'receiver', price = 3000, x = 65.4859, y = 6662.8906, z = 31.7868, heading = 338.0144, blipSprite = 500, id = 6, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "IG_Hao"}
}

Config.MinCopsToGoFast 	= 1
Config.MinCopsToPussy 	= 2

Config.Points = {
	drug = {
		{label = 'Weed', price = 1000, data = {
				{x = 2211.5788, y = 5577.3828, z = 53.8228, label = 'Récolte', blipSprite = 496},
				{x = -45.7015, y = 1918.9345, z = 195.3614, label = 'Traitement', blipSprite = 496}
			}
		},
		{label = 'Coke', price = 3000, data = {
				{x = 778.2449, y = 4184.2373, z = 41.7892, label = 'Récolte', blipSprite = 497},
				{x = 388.3090, y = 3586.7998, z = 33.2922, label = 'Traitement', blipSprite = 497}
			}
		},
		{label = 'LSD', price = 5000, data = {
				{x = 369.0342, y = 3407.6547, z = 36.4035, label = 'Récolte', blipSprite = 501},
				{x = 2454.8198, y = 4069.3515, z = 38.0646, label = 'Traitement', blipSprite = 501}
			}
		},
	},

	go_fast = {
		spawnsVehicle = {
			{x = 553.5201, y = -1777.2474, z = 29.1734, heading = 154.5491},
			{x = 283.9825, y = -1929.1433, z = 25.7924, heading = 227.7779},
			{x = 449.4863, y = -1885.0455, z = 26.8516, heading = 305.0695},
			{x = 30.4805, y = -1762.1965, z = 29.3024, heading = 40.0185},
			{x = -2353.8798, y = 274.4221, z = 166.4387, heading = 20.0000},
			{x = 963.4440, y = -1856.6257, z = 31.1968, heading = 84.0150},
			{x = -1153.5538, y = -1562.3927, z = 4.3376, heading = 8.4337}

		},
		vehicles = {
			{model = 'oracle', reward = 1000},
			{model = 'fugitive', reward = 1000},
			{model = 'schafter2', reward = 1000},
			{model = 'schafter3', reward = 1000},
			{model = 'tailgater', reward = 1000},
			{model = 'kuruma', reward = 1000},
			{model = 'sultan', reward = 1000},
			{model = 'schwarzer', reward = 1000}
		},
		timer = 120,	--Timer before sitting in vehicle from 100m (in seconds)
		timeToSell = 300000,	--Time to go to sell the car at the destination (in ms)
		destinations = {
			{x = 1731.5660, y = 3310.8359, z = 40.2235},
			{x = 1685.5173, y = 6435.0776, z = 31.3463},
			{x = 205.1595, y = 2798.1418, z = 44.6551},
			{x = -744.3114, y = 5537.5522, z = 32.4856},
			{x = 2879.4226, y = 4488.2216, z = 47.2410},
			{x = 718.7788, y = 4177.5415, z = 39.7091}
		}
	},

	pussy = {
		spawnsVehicle = {x = 988.02696, y = -2970.3911, z = 5.9007, heading = 169.5898},
		vehicleModel = 'mule3',
		getNPC = {--x, y, z ⇒ où le véhicule doit être |||| Sx, Sy, Sz ⇒ où les moldus spawns
			{x = 1504.9564, y = 3761.8662, z = 32.9889, Sx = 1514.3338, Sy = 3784.5156, Sz = 33.4680},
			{x = 33.0184, y = 3714.5417, z = 38.5270, Sx = 40.6572, Sy = 3715.5947, Sz = 38.6770},
			{x = 2714.6457, y = 4146.4243, z = 42.6853, Sx = 2728.0739, Sy = 4142.1860, Sz = 43.2879}
		},
		destinations = {--x, y, z ⇒ où le véhicule doit être |||| Dx, Dy, Dz ⇒ où les moldus se deletent
			{x = 757.8892, y = -3195.0385, z = 5.0731, Dx = 752.9439, Dy = -3198.3398, Dz = 5.0731},
			{x = -403.5109, y = 194.3771, z = 81.2667, Dx = -372.3668, Dy = 193.5941, Dz = 82.6566},
			{x = 969.9994, y = -0.6847, z = 80.9908, Dx = 966.9351, Dy = 1.9134, Dz = 80.9908}
		},
		NPCModel = {
			'a_f_y_hipster_04',
			'a_f_y_juggalo_01',
			's_f_y_hooker_01',
			's_f_y_hooker_02',
			's_f_y_hooker_03',
			'a_f_y_rurmeth_01',
			'a_m_m_tranvest_01'
		},
		priceByNPC = 1000
	},

	receiver = {
		vehicles = {
			{model = 'exemplar',	label = "Mitsubishi Lancer Evolution"},    
			{model = 'f620', 		label = "Aston Martin Vanquish"},
			{model = 'sentinel',	label = "BMW M2"},
			{model = 'banshee', 	label = "Porsche 718"},
			{model = 'zentorno',	label = "Pegassi Zentorno"}
		},
		destinations = {
			{x = 1731.5660, y = 3310.8359, z = 41.2235},
			{x = 1685.5173, y = 6435.0776, z = 32.3463},
			{x = 205.1595, y = 2798.1418, z = 45.6551},
			{x = -744.3114, y = 5537.5522, z = 33.4856},
			{x = 2879.4226, y = 4488.2216, z = 48.2410},
			{x = 718.7788, y = 4177.5415, z = 40.7091}
		}
	}
}