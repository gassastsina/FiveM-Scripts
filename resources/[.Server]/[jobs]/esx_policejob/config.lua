--------------------------------------
--------------------------------------
----    File : config.lua  		  ----
----    Edited by : gassastsina   ----
----    Side : client/server      ----
----    Description : Main Police ----
--------------------------------------
--------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.7 }
Config.MarkerColor                = { r = 0, g = 128, b = 255 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = true
Config.EnableLicenses             = true
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.PoliceStations = {

  LSPD = {

    Blip = {
      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      {name = 'WEAPON_FLARE',            price = 125},--flare 
      {name = 'WEAPON_FIREEXTINGUISHER', price = 300},--extincteur 
      {name = 'WEAPON_NIGHTSTICK',       price = 500},--matraque 
      {name = 'WEAPON_STUNGUN',          price = 1200},--taser 
      {name = 'WEAPON_COMBATPISTOL',     price = 2800},--pistolet de combat 
      {name = 'WEAPON_PISTOL_MK2',       price = 3500},--pistolet MK2 
      {name = 'WEAPON_PUMPSHOTGUN',  price = 4500},--fusil à pompe 
      {name = 'WEAPON_SMG',        	 price = 10000},--mitraillette 
      {name = 'WEAPON_COMBATPDW',        price = 10000},--adp de combat 
      {name = 'WEAPON_CARBINERIFLE', price = 10000},--carabine 
      {name = 'WEAPON_SPECIALCARBINE',price = 10000},--carabine spéciale (G36C) 
      {name = 'WEAPON_ADVANCEDRIFLE',    price = 14000},--fusil amélioré
      {name = 'WEAPON_MARKSMANRIFLE_MK2',price = 12500},--fusil à lunette MK2
      {name = 'WEAPON_SMOKEGRENADE',     price = 2500},--lacrymo 
      {name = 'WEAPON_STICKYBOMB',       price = 15000},--bombe collante 
      {name = 'GADGET_PARACHUTE',        price = 2000}--parachute 
    },

    AuthorizedVehicles = {
      { name = 'police',  label = 'Véhicule de patrouille 1' },
      { name = 'police2', label = 'Véhicule de patrouille 2' },
      { name = 'police3', label = 'Véhicule de patrouille 3' },
      { name = 'police4', label = 'Véhicule civil' },
      { name = 'policeb', label = 'Moto' },
      { name = 'policet', label = 'Van de transport' },
    },
	
    AuthorizedHelicopters = {
		{name = 'polmav' , label = 'Helicoptere de police'},
		--{name = 'buzzard2', label = 'Hélicoptère d\'intervention'},
    },
	
    Cloakrooms = {
      { x = 452.600, y = -993.306, z = 29.750 }
    },

    Armories = {
      { x = 458.554, y = -979.773, z = 29.689 }
    },

    Vehicles = {
      {
        Spawner    = { x = 454.69, y = -1017.4, z = 27.430 },
        SpawnPoint = { x = 438.42, y = -1018.3, z = 27.757 },
        Heading    = 90.0
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 456.0, y = -984.12, z = 42.69 },
        SpawnPoint = { x = 449.3, y = -981.14, z = 42.69 },
        Heading    = 0.0
      }
    },

    VehicleDeleters = {
      { x = 462.74, y = -1014.4, z = 27.065 },
      { x = 462.40, y = -1019.7, z = 27.104 }
    },
	
    HelicoDeleters = {	
	  {x = 449.3, y = -981.14, z = 42.69}
    },

    BossActions = {
      { x = 448.417, y = -973.208, z = 29.689 }
    },

    Extras = {x = 445.94, y = -1025.58, z = 27.65},

    OthersActions = {
		{x = 440.34, y = -975.70, z = 29.69},
	}
  },
}

Config.Blip = {      
    Vehicles         = 58,
    Bikes            = 348,
    Helicopters      = 43,
    HelicoptersColor = 30,

    Actualisation    = 10000,    --Time between 2 blips actualisations (ms) (Small value can make some lags)
    Computer         = 10.0     --Distance auround the station computer to get blips
}

Config.Circulation = {
    ClearAreaRadius = 200
}