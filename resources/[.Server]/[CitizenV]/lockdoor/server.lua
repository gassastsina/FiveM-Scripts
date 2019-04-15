----------------------------------------
----------------------------------------
----    File : server.lua         	----
----    Edited by : gassastsina     ----
----	Side : server 		 	  	----
----    Description : Lock doors 	----
----------------------------------------
----------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local doorList = {

	--LSPD
    -- Mission Row To locker room & roof
    [1] = { ["objName"] = "v_ilev_ph_gendoor004", ["x"]= 449.69815063477, ["y"]= -986.46911621094,["z"]= 30.689594268799,["locked"]= true,["txtX"]=450.104,["txtY"]=-986.388,["txtZ"]=31.739},
    -- Mission Row Armory
    [2] = { ["objName"] = "v_ilev_arm_secdoor", ["x"]= 452.61877441406, ["y"]= -982.7021484375,["z"]= 30.689598083496,["locked"]= true,["txtX"]=453.079,["txtY"]=-982.600,["txtZ"]=31.739},
    -- Mission Row Captain Office
    [3] = { ["objName"] = "v_ilev_ph_gendoor002", ["x"]= 447.23818969727, ["y"]= -980.63006591797,["z"]= 30.689598083496,["locked"]= true,["txtX"]=447.200,["txtY"]=-980.010,["txtZ"]=31.739},
    -- Mission Row To downstairs right
    [4] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 443.97, ["y"]= -989.033,["z"]= 30.6896,["locked"]= true,["txtX"]=444.020,["txtY"]=-989.445,["txtZ"]=31.739},
    -- Mission Row To downstairs left
    [5] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 445.37, ["y"]= -988.705,["z"]= 30.6896,["locked"]= true,["txtX"]=445.350,["txtY"]=-989.445,["txtZ"]=31.739},
    -- Mission Row Main cells
    [6] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 464.0, ["y"]= -992.265,["z"]= 24.9149,["locked"]= true,["txtX"]=463.465,["txtY"]=-992.664,["txtZ"]=25.064},
    -- Mission Row Cell 1
    [7] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.381, ["y"]= -993.651,["z"]= 24.9149,["locked"]= true,["txtX"]=461.806,["txtY"]=-993.308,["txtZ"]=25.064},
    -- Mission Row Cell 2
    [8] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.331, ["y"]= -998.152,["z"]= 24.9149,["locked"]= true,["txtX"]=461.806,["txtY"]=-998.800,["txtZ"]=25.064},
    -- Mission Row Cell 3
    [9] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.704, ["y"]= -1001.92,["z"]= 24.9149,["locked"]= true,["txtX"]=461.806,["txtY"]=-1002.450,["txtZ"]=25.064},
    -- Mission Row Backdoor in
    [10] = { ["objName"] = "v_ilev_gtdoor", ["x"]= 464.126, ["y"]= -1002.78,["z"]= 24.9149,["locked"]= true,["txtX"]=464.100,["txtY"]=-1003.538,["txtZ"]=26.064},
    -- Mission Row Backdoor out
    [11] = { ["objName"] = "v_ilev_gtdoor", ["x"]= 464.18, ["y"]= -1004.31,["z"]= 24.9152,["locked"]= true,["txtX"]=464.100,["txtY"]=-1003.538,["txtZ"]=26.064},
    -- Mission Row Rooftop In
    [12] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 465.467, ["y"]= -983.446,["z"]= 43.6918,["locked"]= true,["txtX"]=464.361,["txtY"]=-984.050,["txtZ"]=44.834},
    -- Mission Row Rooftop Out
    [13] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 462.979, ["y"]= -984.163,["z"]= 43.6919,["locked"]= true,["txtX"]=464.361,["txtY"]=-984.050,["txtZ"]=44.834},
    --[12] = { ["objName"] = "v_ilev_ph_door01", ["x"]= 434.691, ["y"]= -981.348,["z"]= 30.71304,["locked"]= true,["txtX"]=434.691,["txtY"]=-981.348,["txtZ"]=31.71304},
    --[13] = { ["objName"] = "v_ilev_ph_door002", ["x"]= 434.691, ["y"]= -982.515,["z"]= 30.71304,["locked"]= true,["txtX"]=434.691,["txtY"]=-982.515,["txtZ"]=31.71304},
    [14] = { ["objName"] = "v_ilev_arm_secdoor", ["x"]= 461.243, ["y"]= -986.013,["z"]= 30.68958,["locked"]= true,["txtX"]=461.243,["txtY"]=-986.013,["txtZ"]=31.68958},   
    --Mission Row Backdoor ToGoOut left
    [15] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 469.254, ["y"]= -1014.541,["z"]= 26.38638,["locked"]= true,["txtX"]=469.254,["txtY"]=-1014.541,["txtZ"]=27.38638}, 
    --Mission Row Backdoor ToGoOut right
    [16] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 468.096, ["y"]= -1014.444,["z"]= 26.38638,["locked"]= true,["txtX"]=468.096,["txtY"]=-1014.444,["txtZ"]=27.38638}, 
    [17] = { ["objName"] = "v_ilev_fibl_door02", ["x"]= 106.033, ["y"]= -743.697,["z"]= 45.7547,["locked"]= false,["txtX"]=106.033,["txtY"]=-743.697,["txtZ"]=46.7547},
    [18] = { ["objName"] = "v_ilev_fibl_door01", ["x"]= 105.737, ["y"]= -745.605,["z"]= 45.7547,["locked"]= false,["txtX"]=105.737,["txtY"]=-745.605,["txtZ"]=46.7547},



	--EMS (29 portes)
  	--Portes salles d'opération
  		--Porte double salle 1
    [19] = { ["objName"] = "v_ilev_cor_doorglassb", ["x"]= 252.6880, ["y"]= -1361.462, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 253.1658, ["txtY"]= -1360.995, ["txtZ"]= 25.2618}, 
    [20] = { ["objName"] = "v_ilev_cor_doorglassa", ["x"]= 254.3432, ["y"]= -1359.489, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 253.9427, ["txtY"]= -1360.032, ["txtZ"]= 25.2618},
    	--Porte double intermédiaire
    [21] = { ["objName"] = "v_ilev_cor_doorglassb", ["x"]= 255.8076, ["y"]= -1347.615, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 255.8076, ["txtY"]= -1347.615, ["txtZ"]= 25.2618},
    [22] = { ["objName"] = "v_ilev_cor_doorglassa", ["x"]= 257.2964, ["y"]= -1348.851, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 256.7359, ["txtY"]= -1348.358, ["txtZ"]= 25.2618},
    	--Porte double salle 2
    [23] = { ["objName"] = "v_ilev_cor_doorglassb", ["x"]= 266.3800, ["y"]= -1345.190, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 266.3800, ["txtY"]= -1345.190, ["txtZ"]= 25.2618},
    [24] = { ["objName"] = "v_ilev_cor_doorglassa", ["x"]= 267.4242, ["y"]= -1343.900, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 267.0009, ["txtY"]= -1344.465, ["txtZ"]= 25.2618},
     	--Porte double Morgue 1
    [25] = { ["objName"] = "v_ilev_cor_doorglassb", ["x"]= 281.9346, ["y"]= -1342.907, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 282.3973, ["txtY"]= -1342.400, ["txtZ"]= 25.2618},
    [26] = { ["objName"] = "v_ilev_cor_doorglassa", ["x"]= 283.5889, ["y"]= -1340.935, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 283.1524, ["txtY"]= -1341.390, ["txtZ"]= 25.2618},
    	--Porte double Morgue 2
    [27] = { ["objName"] = "v_ilev_cor_doorglassb", ["x"]= 287.2377, ["y"]= -1343.992, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 286.8344, ["txtY"]= -1344.575, ["txtZ"]= 25.2618},
    [28] = { ["objName"] = "v_ilev_cor_doorglassa", ["x"]= 285.5790, ["y"]= -1345.969, ["z"]= 24.6818, ["locked"]= true, ["txtX"]= 286.0154, ["txtY"]= -1345.431, ["txtZ"]= 25.2618},

 	--Portes coupes feux
 		--porte double Morgue
    [29] = { ["objName"] = "v_ilev_cor_firedoor", ["x"]= 251.1092, ["y"]= -1365.283, ["z"]= 24.5515, ["locked"]= true, ["txtX"]= 251.6383, ["txtY"]= -1365.649, ["txtZ"]= 25.2615},
    [30] = { ["objName"] = "v_ilev_cor_firedoor", ["x"]= 252.8711, ["y"]= -1366.762, ["z"]= 24.5515, ["locked"]= true, ["txtX"]= 252.3883, ["txtY"]= -1366.278, ["txtZ"]= 25.2615},
    	--porte double Étage 1
    [31] = { ["objName"] = "v_ilev_cor_firedoor", ["x"]= 251.1092, ["y"]= -1365.283, ["z"]= 29.6700, ["locked"]= true, ["txtX"]= 251.3508, ["txtY"]= -1365.737, ["txtZ"]= 29.4700},
    [32] = { ["objName"] = "v_ilev_cor_firedoor", ["x"]= 252.8711, ["y"]= -1366.762, ["z"]= 29.6700, ["locked"]= true, ["txtX"]= 252.3228, ["txtY"]= -1366.340, ["txtZ"]= 29.4700},
 		--porte double Étage 2
    [33] = { ["objName"] = "v_ilev_cor_firedoor", ["x"]= 251.1092, ["y"]= -1365.283, ["z"]= 39.5540, ["locked"]= true, ["txtX"]= 251.5053, ["txtY"]= -1365.596, ["txtZ"]= 40.2540},
    [34] = { ["objName"] = "v_ilev_cor_firedoor", ["x"]= 252.8711, ["y"]= -1366.762, ["z"]= 39.5540, ["locked"]= true, ["txtX"]= 252.3365, ["txtY"]= -1366.278, ["txtZ"]= 40.2540},

    --Portes vitrées
    [35] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 261.2114, ["y"]= -1380.822, ["z"]= 39.7376, ["locked"]= true, ["txtX"]= 260.6456, ["txtY"]= -1380.306, ["txtZ"]= 40.2376},

    [36] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 256.5603, ["y"]= -1377.418, ["z"]= 39.7376, ["locked"]= true, ["txtX"]= 255.8556, ["txtY"]= -1377.415, ["txtZ"]= 40.2376},
     	--Porte double
    [37] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 249.5471, ["y"]= -1383.741, ["z"]= 39.7443, ["locked"]= true, ["txtX"]= 249.0702, ["txtY"]= -1384.269, ["txtZ"]= 40.2443},    
    [38] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 247.8884, ["y"]= -1385.718, ["z"]= 39.7443, ["locked"]= true, ["txtX"]= 248.3118, ["txtY"]= -1385.150, ["txtZ"]= 40.2443},
     	--Porte double
    [39] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 245.1914, ["y"]= -1383.455, ["z"]= 39.7434, ["locked"]= true, ["txtX"]= 245.7383, ["txtY"]= -1382.896, ["txtZ"]= 40.2434},    
    [40] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 246.8501, ["y"]= -1381.478, ["z"]= 39.7434, ["locked"]= true, ["txtX"]= 246.4919, ["txtY"]= -1382.010, ["txtZ"]= 40.2434},
     	--Porte double
    [41] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 250.1048, ["y"]= -1370.228, ["z"]= 39.7376, ["locked"]= true, ["txtX"]= 249.5839, ["txtY"]= -1369.737, ["txtZ"]= 40.2376},
    [42] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 248.1280, ["y"]= -1368.569, ["z"]= 39.7376, ["locked"]= true, ["txtX"]= 248.7075, ["txtY"]= -1369.038, ["txtZ"]= 40.2376},
     	--Porte double
    [43] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 237.6615, ["y"]= -1373.768, ["z"]= 39.7443, ["locked"]= true, ["txtX"]= 237.1571, ["txtY"]= -1374.371, ["txtZ"]= 40.2443},    
    [44] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 236.0029, ["y"]= -1375.745, ["z"]= 39.7443, ["locked"]= true, ["txtX"]= 236.3792, ["txtY"]= -1375.258, ["txtZ"]= 40.2443},
     	--Porte double
    [45] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 239.2153, ["y"]= -1363.457, ["z"]= 39.7376, ["locked"]= true, ["txtX"]= 239.7205, ["txtY"]= -1362.908, ["txtZ"]= 40.2376},
    [46] = { ["objName"] = "v_ilev_cor_darkdoor", ["x"]= 240.8714, ["y"]= -1361.484, ["z"]= 39.7376, ["locked"]= true, ["txtX"]= 240.4947, ["txtY"]= -1361.896, ["txtZ"]= 40.2376},

    --Porte Bureau
    [47] = { ["objName"] = "v_ilev_cor_offdoora", ["x"]= 236.7773, ["y"]= -1367.314, ["z"]= 39.6795, ["locked"]= true, ["txtX"]= 236.8605, ["txtY"]= -1367.920, ["txtZ"]= 40.2795},
}

RegisterServerEvent("lockdoor:updateDoorStatus")
AddEventHandler("lockdoor:updateDoorStatus", function(door)
    doorList = door
    TriggerClientEvent('lockdoor:updateDoorStatusCb', -1, doorList)
end)

ESX.RegisterServerCallback('lockdoor:getStatusDoor', function(source, cb) 
    cb(doorList)
end)