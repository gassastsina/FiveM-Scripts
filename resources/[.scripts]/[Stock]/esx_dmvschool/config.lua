--------------------------------------------
--------------------------------------------
----    File : config.lua        		----
----    Edited : gassastsina & Elis0u   ----
----	Side : client/server 		 	----
----    Description : Licenses Config	----
--------------------------------------------
--------------------------------------------

Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 5
Config.SpeedMultiplier = 3.6
Config.Locale          = 'fr'
Config.SpeedError      = 5

Config.Prices = {
  dmv         = 250,
  drive       = 750,
  drive_bike  = 2000,
  drive_truck = 3250
}

Config.VehicleModels = {
  drive       = 'blista',
  drive_bike  = 'esskey',
  drive_truck = 'mule3'
}

Config.SpeedLimits = {
  residence = 80,
  town      = 110,
  freeway   = 130
}

Config.Zones = {

  DMVSchool = {
    Pos   = {x = 305.926, y = -1162.679, z = 28.2919},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 0, g = 128, b = 255},
    Type  = 1
  },

  VehicleSpawnPoint = {
    Pos   = {x = 315.227, y = -1154.767, z = 29.291},
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 0, g = 128, b = 255},
    Type  = -1
  },

}

Config.CheckPoints = {

  {
    Pos = {x = 315.678, y = -1140.872, z = 28.204},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('residence')

      DrawMissionText(_U('start_stop_cont') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
    end
  },

  {
    Pos = {x = 303.080, y = -1115.574, z = 28.265},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_right'), 5000)
    end
  },

  {
    Pos = {x = 303.247, y = -1071.736, z = 28.267},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      Citizen.CreateThread(function()
        DrawMissionText(_U('see_left'), 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(3000)
        FreezeEntityPosition(vehicle, false)
      end)
    end
  },

  {
    Pos = {x = 349.247, y = -1054.168, z = 28.209},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_left'), 5000)
    end
  },

  {
    Pos = {x = 401.308, y = -1024.913, z = 28.222},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('lets_cont'), 5000)
    end
  },

  {
    Pos = {x = 407.652, y = -756.882, z = 28.119},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_left'), 5000)
    end
  },

  {
    Pos = {x = 408.600, y = -691.439, z = 28.070},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('cont_nice'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(3000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 382.538, y = -670.343, z = 28.029},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_right'), 5000)
    end
  },

  {
    Pos = {x = 491.042, y = -474.600, z = 27.538},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('freeway')

      DrawMissionText(_U('lets_highway') .. Config.SpeedLimits['freeway'] .. 'km/h', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 825.323, y = 56.049, z = 65.597},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_right'), 5000)
    end
  },

  {
    Pos = {x = 1073.348, y = 320.593, z = 88.450},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      DrawMissionText(_U('next_turn_left_vit') .. Config.SpeedLimits['town'] .. 'km/h', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 1103.783, y = 421.508, z = 90.236},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('lets_cont'), 5000)
    end
  },

  {
    Pos = {x = 1038.478, y = 480.287, z = 94.027},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('lets_cont'), 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(3000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = 946.940, y = 525.165, z = 112.428},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_left'), 5000)
    end
  },

  {
    Pos = {x = 912.950, y = 480.684, z = 119.951},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('lets_cont'), 5000)
    end
  },

  {  Pos = {x = 798.044, y = 343.255, z = 114.850},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_right'), 5000)
    end
  },


  {  Pos = {x = 650.607, y = 362.450, z = 110.894},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType = ('residence')

      DrawMissionText(_U('lets_cont_vit') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {  Pos = {x = 327.541, y = 563.431, z = 153.316},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_left'), 5000)
    end
  },

  {  Pos = {x = 266.830, y = 554.285, z = 142.003},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('residence')

      DrawMissionText(_U('road_finish') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
    end
  },

  {  Pos = {x = 253.316, y = 406.021, z = 114.379},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('lets_cont'), 5000)
    end
  },

  {  Pos = {x = 153.360, y = 68.156, z = 79.462},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_left'), 5000)
    end
  },

  {  Pos = {x = 224.278, y = -66.511, z = 68.163},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_right'), 5000)
    end
  },

  {  Pos = {x = 237.200, y = -185.785, z = 54.202},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('lets_cont'), 5000)
    end
  },

  {  Pos = {x = 78.632, y = -995.215, z = 28.229},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('road_almost'), 5000)
    end
  },

  {  Pos = {x = 338.216, y = -1060.601, z = 28.175},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_turn_right'), 5000)
    end
  },

  {  Pos = {x = 324.430, y = -1133.499, z = 28.254},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('car_parking'), 5000)
    end
  },

  {
    Pos = {x = 336.903, y = -1153.661, z = 28.114},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      ESX.Game.DeleteVehicle(vehicle)
    end
  },

}