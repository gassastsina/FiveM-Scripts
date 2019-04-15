----------------------------------------------
----------------------------------------------
----    File : config.lua                 ----
----    Author : gassastsina              ----
----	Side : client/server 			  ----
----    Description : Jewel heist config  ----
----------------------------------------------
----------------------------------------------

-----------------------------------------------config-------------------------------------------------------
Config              = {}
Config.DrawDistance = 30.0
Config.MarkerType   = 1
Config.MarkerSize   = {x = 1.0, y = 1.0, z = 0.5}
Config.Zones = {
	HackAlarm = {
		Pos = {x = -622.843, y = -215.983, z = 53.544}
	},
	CopStopAlarm = {
		Pos = {x = -619.918, y = -224.607, z = 38.057}
	},

	InteractWithNPC = {
		Pos = {x = -628.407, y = -231.806, z = 38.057}
	},
	TakingHostage = {
		Pos = {x = -629.578, y = -228.379, z = 38.057}
	},
	Checkout = {
		Pos 		= {x = -622.538, y = -230.128, z = 38.057},
		MarkerColor = {r = 255, g = 0, b = 0}
	}
}
Config.InsideJewelery 		= {x = -622.254, y = -231.004, z = 38.000}
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

Config.NPC = {
	Model 	 = "a_f_y_hipster_04",
	Pos 	 = {x = -629.311, y = -231.051, z = 38.057},
	NegoDesk = {x = -631.101, y = -229.541, z = 38.057, heading = 304.758}
}

Config.WaitingStopAlarmBeforeCallPoliceSuccess 	= 80000 --in ms
Config.WaitingStopAlarmBeforeCallPoliceError 	= 20000 --in ms
Config.WaitingHostageBeforeCallPolice 		 	= 80000  --in ms
Config.MinCops 									= 2

Config.MarkerWorkerWearsColor = {r = 128, g = 64, b = 0}
Config.WorkerWears = {
	{x = -592.209, y = -288.772, z = 50.324, available = true},
	{x = -593.439, y = -295.965, z = 50.324, available = true},
	{x = -596.399, y = -295.969, z = 41.680, available = true},
	{x = -583.486, y = -285.301, z = 41.694, available = true},
	{x = -587.875, y = -290.624, z = 41.694, available = true},
	{x = -588.839, y = -279.707, z = 35.455, available = true},
	{x = -593.852, y = -285.801, z = 35.455, available = true},
	{x = -587.788, y = -289.969, z = 35.455, available = true}
}

Config.MarkerJewelsColor = {r = 0, g = 200, b = 0}
Config.Jewels = {
	{x = -626.6257, y = -235.7413, z = 38.0570, heading = 43.0382, 	available = true, animation = "smash_case_f"},
	{x = -628.1213, y = -233.5830, z = 38.0570, heading = 213.5411, available = true, animation = "fp_smash_case_tray_b"},
	{x = -626.8104, y = -238.2834, z = 38.0570, heading = 208.3076, available = true, animation = "smash_case"},
	{x = -625.8685, y = -237.5227, z = 38.0570, heading = 216.2156, available = true, animation = "smash_case_f"},
	{x = -624.7695, y = -231.3039, z = 38.0570, heading = 300.0002, available = true, animation = "fp_smash_case_tray_a"},
	{x = -623.7507, y = -227.4629, z = 38.0570, heading = 30.5537, 	available = true, animation = "smash_case_d"},
	{x = -620.6380, y = -226.6928, z = 38.0570, heading = 306.1712, available = true, animation = "smash_case_necklace_skull"},
	{x = -620.8178, y = -228.3448, z = 38.0570, heading = 125.4378, available = true, animation = "smash_case_f"},
	{x = -617.6530, y = -230.7206, z = 38.0570, heading = 305.6206, available = true, animation = "smash_case_c"},
	{x = -619.3549, y = -233.2498, z = 38.0570, heading = 217.8916, available = true, animation = "smash_case_tray_b"},
	{x = -623.4026, y = -233.1554, z = 38.0570, heading = 312.3325, available = true, animation = "fp_smash_case_necklace_skull"},
	{x = -624.7411, y = -228.1270, z = 38.0570, heading = 35.9838, 	available = true, animation = "fp_smash_case_necklace"},
	{x = -627.2317, y = -232.8540, z = 38.0570, heading = 216.9923,	available = true, animation = "fp_smash_case_d"},
	{x = -625.5570, y = -234.9145, z = 38.0570, heading = 35.3309,	available = true, animation = "fp_smash_case_e"},
	{x = -619.3651, y = -230.0797, z = 38.0570, heading = 125.7983,	available = true, animation = "smash_case_b"},
	{x = -620.4178, y = -234.1366, z = 38.0570, heading = 220.8086,	available = true, animation = "smash_case_tray_a"},
	{x = -620.0124, y = -227.7765, z = 38.0570, heading = 305.0222,	available = true, animation = "fp_smash_case_necklace"},
	{x = -618.6061, y = -229.7664, z = 38.0570, heading = 308.5602,	available = true, animation = "smash_case_f"},
	{x = -624.4846, y = -224.2989, z = 38.0570, heading = 340.0570,	available = true, animation = "smash_case"},
	{x = -625.6005, y = -224.1664, z = 38.0570, heading = 6.4373,	available = true, animation = "smash_case_necklace"},
	{x = -626.5312, y = -224.6142, z = 38.0570, heading = 32.6716,	available = true, animation = "fp_smash_case_d"},
	{x = -627.1663, y = -225.3824, z = 38.0570, heading = 73.5604,	available = true, animation = "fp_smash_case_tray_a"},
	{x = -619.5891, y = -237.1064, z = 38.0570, heading = 157.1209,	available = true, animation = "smash_case_c"},
	{x = -627.3095, y = -226.3622, z = 38.0570, heading = 108.6671,	available = true, animation = "smash_case_b"},
	{x = -616.8196, y = -235.0934, z = 38.0570, heading = 284.3877,	available = true, animation = "smash_case_d"},
	{x = -616.9377, y = -236.1235, z = 38.0570, heading = 255.0134,	available = true, animation = "smash_case_necklace"},
	{x = -617.6423, y = -237.1058, z = 38.0570, heading = 227.6588,	available = true, animation = "smash_case_tray_a"},
	{x = -618.5753, y = -237.2276, z = 38.0570, heading = 184.2593,	available = true, animation = "smash_case_d"}
}