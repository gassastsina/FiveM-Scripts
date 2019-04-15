--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ NPC Spawn @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
local generalLoaded = false
local PlayingAnim = false
 
local ShopClerk = {
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ NPC DRUGS / WEASHOP / BLANCHIMENT @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    --{id = 1, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "ig_terry", x = -1109.06,   y =-1640.59,  z = 2.64067, heading = 264.900115966797},
    --{id = 2, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "csb_chef", x = -2167.18,   y =5197.13,  z = 16.8804, heading = 464.900115966797},
    --{id = 3, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x13532244, modelHash = "g_m_y_salvagoon_01", x = 1300.92,   y =-1620.12,  z = 54.225, heading = 264.900115966797},
    {id = 4, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "s_m_y_ammucity_01", x = 23.9778,   y =-1105.55,  z = 29.797, heading = 464.900115966797}, --Ammunation centre ville
    --{id = 5, VoiceName = "GENERIC_HI", Ambiance = "THELOST", Weapon = 0x1D073A89, modelHash = "g_f_y_lost_01", x=985.764, y=-144.831, z=74.214, heading = 464.900115966797},
    --{id = 6, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "csb_porndudes", x=-1513.09, y=137.784, z=55.6529, heading = 264.900115966797},  
    {id = 7, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "g_m_m_chemwork_01", x=2434.76, y=4969.02, z=41.3476, heading = 464.900115966797},--Labo meth O'neil
    --{id = 8, VoiceName = "GENERIC_HI", Ambiance = "THELOST", Weapon = 0x1D073A89, modelHash = "a_m_o_acult_02", x=-1150.55, y=4940.92, z=222.269, heading = 264.900115966797},
    --{id = 9, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "mp_m_exarmy_01", x=1233.95, y=1876.34,  z=78.9667, heading = 64.900115966797},
    --{id = 10, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "a_m_o_tramp_01", x=525.089, y=-950.206,  z=19.7689, heading = 64.900115966797},
    --{id = 11, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "ig_solomon", x = 460.723, y = -746.35, z = 26.3591, heading = 364.900115966797},
    --{id = 12, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01", x =-1624.64, y =-1098.094,  z =13.01883, heading = 50.900115966797},
    --{id = 13, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01", x=-1556.50, y=-416.93, z=38.09, heading = 85.69},
    --{id = 14, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01", x=988.633,y=-141.129,z=73.09, heading = 61.40},
    --{id = 15, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01", x=372.57,y=-790.25,z=29.28, heading = 96.86},
    --{id = 16, VoiceName = "GENERIC_HI", Ambiance = "AMMUCITY", Weapon = 0x1D073A89, modelHash = "S_M_Y_Dealer_01",x =-1360.7835693359, y =-757.40844726563, z =22.304618835449, heading = 250.900115966797},
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
}
 
-- Blip
-- Citizen.CreateThread(function()
    -- for k,v in pairs(ShopClerk)do
        -- local blip = AddBlipForCoord(v.x, v.y, v.z)
        -- SetBlipSprite(blip, v.BlipID)
        -- SetBlipScale(blip, 0.8)
        -- SetBlipAsShortRange(blip, true)
        -- BeginTextCommandSetBlipName("STRING")
        -- AddTextComponentString(v.name)
        -- EndTextCommandSetBlipName(blip)
    -- end
-- end)
 
 
-- Spawn NPC
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
   
    if (not generalLoaded) then
     
      for i=1, #ShopClerk do
        RequestModel(GetHashKey(ShopClerk[i].modelHash))
        while not HasModelLoaded(GetHashKey(ShopClerk[i].modelHash)) do
          Wait(1)
        end
       
        ShopClerk[i].id = CreatePed(2, ShopClerk[i].modelHash, ShopClerk[i].x, ShopClerk[i].y, ShopClerk[i].z, ShopClerk[i].heading, false, true)
        SetPedFleeAttributes(ShopClerk[i].id, 0, 0)
        SetAmbientVoiceName(ShopClerk[i].id, ShopClerk[i].Ambiance)
        SetPedDropsWeaponsWhenDead(ShopClerk[i].id, false)
        SetPedDiesWhenInjured(ShopClerk[i].id, false)
        GiveWeaponToPed(ShopClerk[i].id, ShopClerk[i].Weapon, 2800, false, true)
       
      end
      generalLoaded = true
       
    end
   
  end
end)
 
 
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
        RequestAnimDict("random@shop_gunstore")
        while (not HasAnimDictLoaded("random@shop_gunstore")) do
            Citizen.Wait(0)
        end
       
        for i=1, #ShopClerk do
            distance = GetDistanceBetweenCoords(ShopClerk[i].x, ShopClerk[i].y, ShopClerk[i].z, GetEntityCoords(GetPlayerPed(-1)))
            if distance < 4 and PlayingAnim ~= true then
                TaskPlayAnim(ShopClerk[i].id,"random@shop_gunstore","_greeting", 1.0, -1.0, 4000, 0, 1, true, true, true)
                PlayAmbientSpeech1(ShopClerk[i].id, ShopClerk[i].VoiceName, "SPEECH_PARAMS_FORCE", 1)
                PlayingAnim = true
                Citizen.Wait(4000)
                if PlayingAnim == true then
                    TaskPlayAnim(ShopClerk[i].id,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
                    Citizen.Wait(40000)
                end
            else
               
                --TaskPlayAnim(ShopClerk[i].id,"random@shop_gunstore","_idle", 1.0, -1.0, -1, 0, 1, true, true, true)
            end
            if distance > 5.5 and distance < 6 then
                PlayingAnim = false
            end
 
 
        end
  end
end)








---------------------------------------------------------------------------------
---antigang
local relationshipTypes = {
"PLAYER",
--"CIVMALE",
--"CIVFEMALE",
"COP",
"SECURITY_GUARD",
"PRIVATE_SECURITY",
"FIREMAN",
"GANG_1",
"GANG_2",
"GANG_9",
"GANG_10",
"AMBIENT_GANG_LOST",
"AMBIENT_GANG_MEXICAN",
"AMBIENT_GANG_FAMILY",
"AMBIENT_GANG_BALLAS",
"AMBIENT_GANG_MARABUNTE",
"AMBIENT_GANG_CULT",
"AMBIENT_GANG_SALVA",
"AMBIENT_GANG_WEICHENG",
"AMBIENT_GANG_HILLBILLY",
"DEALER",
"HATES_PLAYER",
"HEN",
--"WILD_ANIMAL",
--"SHARK",
--"COUGAR",
"NO_RELATIONSHIP",
"SPECIAL",
"MISSION2",
"MISSION3",
"MISSION4",
"MISSION5",
"MISSION6",
"MISSION7",
"MISSION8",
"ARMY",
--"GUARD_DOG",
"AGGRESSIVE_INVESTIGATE",
"MEDIC",
--a"CAT",
}

local RELATIONSHIP_HATE = 1

Citizen.CreateThread(function()
    while true do
        Wait(50)

        for _, group in ipairs(relationshipTypes) do
            -- not sure about argument order, players don't have AI so only one of these should be needed
            SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey('PLAYER'), GetHashKey(group))
            SetRelationshipBetweenGroups(RELATIONSHIP_HATE, GetHashKey(group), GetHashKey('PLAYER'))
        end
    end
end)