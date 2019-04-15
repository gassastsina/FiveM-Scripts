------------------------------------
------------------------------------
----    File : slaughterer.lua  ----
----    Edited by : gassastsina ----
----    Side : client        	----
----    Description : Jobs 	 	----
------------------------------------
------------------------------------

Config.Jobs.slaughterer = {
  BlipInfos = {
    Sprite = 256,
    Color = 5
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "benson",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {
    CloakRoom = {
      Pos   = {x = -74.768, y = 6250.986, z = 30.090},
      Size  = {x = 2.2, y = 2.2, z = 0.7},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = true,
      Name  = _U('s_slaughter_locker'),
      Type  = "cloakroom",
      Hint  = _U('cloak_change'),
    },

    AliveChicken = {
      Pos   = {x = -62.9018, y = 6241.46, z = 30.0901},
      Size  = {x = 2.0, y = 2.0, z = 0.7},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = _U('s_hen'),
      Type  = "work",
      Item  = {
        {
          name   = _U('s_alive_chicken'),
          db_name= "alive_chicken",
          time   = 1000,
          max    = -1,
          add    = 1,
          remove = 1,
          requires = "nothing",
          requires_name = "Nothing",
          drop   = 100
        }
      },
      Hint  = _U('s_catch_hen')
    },

    SlaughterHouse = {
      Pos   = {x = -77.641, y = 6229.589, z = 30.092},
      Size  = {x = 1.5, y = 1.5, z = 0.6},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = _U('s_slaughtered'),
      Type  = "work",
      Item  = {
        {
          name   = _U('s_slaughtered_chicken'),
          db_name= "slaughtered_chicken",
          time   = 1000,
          max    = -1,
          add    = 1,
          remove = 1,
          requires = "alive_chicken",
          requires_name = _U('s_alive_chicken'),
          drop   = 100
        }
      },
      Hint  = _U('s_chop_animal')
    },

    Packaging = {
      Pos   = {x = -101.978, y = 6208.799, z = 30.025},
      Size  = {x = 2.0, y = 2.0, z = 0.7},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = _U('s_package'),
      Type  = "work",
      Item  = {
        {
          name   = _U('s_packagechicken'),
          db_name= "packaged_chicken",
          time   = 1500,
          max    = -1,
          add    = 4,
          remove = 1,
          requires = "slaughtered_chicken",
          requires_name = _U('s_unpackaged'),
          drop   = 100
        }
      },
      Hint  = _U('s_unpackaged_button')
    },

    VehicleSpawner = {
      Pos   = {x = -113.317, y = 6242.799, z = 30.322},
      Size  = {x = 2.0, y = 2.0, z = 0.7},
      Color = {r = 204, g = 204, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = _U('spawn_veh'),
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = _U('spawn_veh_button'),
      Caution = 0
    },

    VehicleSpawnPoint = {
      Pos   = {x = -107.57363891602, y = 6249.5004882813, z = 31.294954299900},
      Size  = {x = 2.0, y = 2.0, z = 0.7},
      Marker= -1,
      Blip  = false,
      Name  = _U('service_vh'),
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 33.7618637
    },

    VehicleDeletePoint = {
      Pos   = {x = -107.57363891602, y = 6249.5004882813, z = 31.294954299900},
      Size  = {x = 7.0, y = 7.0, z = 1.0},
      Color = {r = 255, g = 0, b = 0},
      Marker= -1,
      Blip  = false,
      Name  = _U('return_vh'),
      Type  = "vehdelete",
      Hint  = _U('return_vh_button'),
      Spawner = 1,
      Caution = 0,
      GPS = 0,
      Teleport = 0
    },

    Delivery = {
      Pos   = {x = -865.4023, y = -225.4530, z = 38.6070},
      Color = {r = 204, g = 204, b = 0},
      Size  = {x = 1.5, y = 1.5, z = 1.0},
      Marker= 1,
      Blip  = true,
      Name  = _U('delivery_point'),
      Type  = "delivery",
      Spawner = 1,
      Item  = {
        {
          name   = _U('delivery'),
          time   = 1000,
          remove = 1,
          max    = -1, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
          price  = 2,
          requires = "packaged_chicken",
          requires_name = _U('s_packagechicken'),
          drop   = 100
        }
      },
      Hint  = _U('s_deliver')
    }
  }
}
