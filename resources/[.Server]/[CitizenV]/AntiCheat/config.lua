Config = {
	{
		scanEveryMs = 3000, -- waiting time between 2 scan in MS (1000ms = 1s)
		scanAcEnable = true, --i'm not sure if is possible stop client script maybe yes this scan is checking if anticheat client is running
		scanSystem = 1, --1 == scan every time ,2 == require players vote 'runAC'(f8) or chat commands '/runAC' to exec client scan or enable by admin
		requireVote = 5, -- Vote count by player require to enable anticheat (is you use scanSytem = 2)
		action = 1, -- 1 == ban , 2 == kick ,3 == ban + crash + screamer [require interact sound]
		txtLogs = true, --create logs in txt file 
		discordLogs = {use = true, webHook = 'https://discordapp.com/api/webhooks/xxx/xxx'} , --create discord logs
		advertAdmin = true, --advert all admin connected on server if any player get banned/kick by anticheat [recommended if you use action = 2]
		adminDiscordID = " <@&000000000000000000>",
		scanGodMod = true, --scan if any player use godmod [if you have some script use godmod disable it (exemple: paintball ...)]
		scanflying = false, --scan if any player is flying
		adminBypass = false,--scan admin
		scanWeapon = true, --scan if any player use blacklist weapon
		scanVehicle = true, --scan if any player drive blacklist vehicle
		scanModel = true, --scan if any player is blacklist ped model
		scanVpn = true, --check if using vpn
		scanAntiTp = false,
		blackListWeapon = { --insert here blackList weapon
			{model = "WEAPON_RPG"},
			{model = "AIRSTRIKE_ROCKET"},
			{model = "WEAPON_APPISTOL"},
			{model = "WEAPON_MG"},
			{model = "WEAPON_COMBATMG"},
			{model = "WEAPON_BULLPUPSHOTGUN"},
			{model = "WEAPON_PASSENGER_ROCKET"},
			{model = "WEAPON_AIRSTRIKE_ROCKET"},
			{model = "WEAPON_STINGER"},
			{model = "WEAPON_MINIGUN"},
			{model = "WEAPON_VEHICLE_ROCKET"},
			{model = "WEAPON_RAILGUN"},
			{model = "WEAPON_EXPLOSION"}
		},
		blackListVehicle= { --insert here blackList vehicle
			{model = "annihilator"},
			{model = "boattrailer"},
			{model = "buzzard"},
			{model = "titan"}
			},
		blackListModel = { --insert here blackList ped model
			{model = "a_c_chickenhawk"},
			{model = "a_c_pigeon"}
		},
		blackListIp = { --cyberghost
			{ip = '79.141.173.22'},
			{ip = '84.19.169.231'},
			{ip = '84.19.169.162'},
			{ip = '217.114.211.242'},
			{ip = '82.195.234.50'},
			{ip = '84.19.169.168'},
			{ip = '194.187.251.3'}
		},
	},
}