---------------------------------------
---------------------------------------
----    File : main.lua  		   ----
----    Edited by : gassastsina    ----
----    Side : client/server   	   ----
----    Description : Weapons shop ----
---------------------------------------
---------------------------------------

Config                = {}
Config.DrawDistance   = 100
Config.Size           = { x = 1.5, y = 1.5, z = 1.5 }
Config.Color          = { r = 0, g = 128, b = 255 }
Config.Type           = 1
Config.Locale         = 'fr'
Config.EnableLicense  = true -- only turn this on if you are using esx_license
Config.LicensePrice   = 4000

Config.Zones = {

    GunShop = {
        legal = 0,
        Items = {},
        Pos   = {
            { x = -662.180,   y = -934.961,   z = 20.829 },
            { x = 810.25,     y = -2157.60,   z = 28.62 },
            { x = 1693.44,    y = 3760.16,    z = 33.71 },
            { x = -330.24,    y = 6083.88,    z = 30.45 },
            { x = 252.63,     y = -50.00,     z = 68.94 },
            { x = 22.09,      y = -1107.28,   z = 28.80 },
            { x = 2567.69,    y = 294.38,     z = 107.73},
            { x = -1117.58,   y = 2698.61,    z = 17.55 },
            { x = 842.44,     y = -1033.42,   z = 27.19 }
        }
    },

    BlackWeashop = {
        legal = 1,
        Items = {},
        Pos   = {
            {x = 0.0,   y = 0.0,  z = -100.0}
        }
    },
    
    BlackItems = {
       	legal = 1,
    	Items = {
	    	{label 	= 'Kit de démarrage', 	name = 'carstarter_kit', 	price = 250},
	    	{label 	= 'Serflex', 			name = 'serflex', 			price = 500},
	    	{label 	= 'Pince coupante', 	name = 'cutting_pince', 	price = 400},
	    	{label 	= 'Téléphone de hack 📱', name = 'hack_phone', 		price = 2500},

	    	{label 	= 'Silencieux', name = 'suppressor', 				price = 4000},
	    	{label 	= 'Lampe torche', name = 'flashlight', 				price = 2500},
	    	{label 	= 'Poignée', name = 'grip', 						price = 2000},
	    	{label 	= 'Viseur', name = 'scope', 						price = 2000},
	    	{label 	= 'Chargeur grande capacité', name = 'clip2', 		price = 4000},
	    	{label 	= 'Chargeur très grand capacité', name = 'clip3', 	price = 5500}
	    },
        Pos   = {
            {x = 0.0,   y = 0.0,  z = -100.0}
        }
    }
}