----------------------------------------------
----------------------------------------------
----    File : config.lua       		  ----
----    Author: gassastsina     		  ----
----	Side : client/server 			  ----
----    Description : Weapons accessories ----
----------------------------------------------
----------------------------------------------

Config = {
	Accessories = {
	    {toggle = true, value = 'suppressor', label = 'Silencieux', price = 500},
	    {toggle = true, value = 'flashlight', label = 'Lampe torche', price = 500},
	    {toggle = true, value = 'grip', label = 'Poignée', price = 500},
	    {toggle = true, value = 'scope', label = 'Viseur', price = 500},
	    {toggle = false, value = 'clip1', label = 'Chargeur normal', price = 500},
	    {toggle = true, value = 'clip2', label = 'Chargeur grande capacité', price = 800},
	    {toggle = true, value = 'clip3', label = 'Chargeur très grand capacité', price = 1000}
	},
	Wallpapers = {
	    {toggle = true, value = 0, label = 'Sans teinte', price = 100},
	    {toggle = true, value = 1, label = 'Vert', price = 500},
	    {toggle = true, value = 2, label = 'Or', price = 500},
	    {toggle = true, value = 3, label = 'Rose', price = 500},
	    {toggle = true, value = 4, label = 'Militaire', price = 500},
	    {toggle = true, value = 5, label = 'LSPD', price = 500},
	    {toggle = true, value = 6, label = 'Orange', price = 500},
	    {toggle = true, value = 7, label = 'Platine', price = 1000},

	    {toggle = true, value = 'carving', label = 'Gravure', price = 2000}
	}
}

Config.WhitelistWeapon = {
	"WEAPON_PISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_SMG",
	"WEAPON_MICROSMG",
	"WEAPON_ASSAULTSMG",
	"WEAPON_GUSENBERG",
	"WEAPON_COMBATPDW",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_CARBINERIFLE",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER"
}

Config.Debug = false