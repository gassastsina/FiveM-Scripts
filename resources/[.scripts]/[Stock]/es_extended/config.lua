-------------------------------------
-------------------------------------
----    File : config.lua        ----
----    Edited : gassastsina     ----
----	Side : client/server 	 ----
----    Description : ESX Config ----
-------------------------------------
-------------------------------------

Config                          = {}
Config.MaxPlayers               = 32
Config.Accounts                 = { 'bank', 'black_money' }
Config.AccountLabels            = { bank = 'Banque', black_money = 'Argent Sale' } -- French
-- Config.AccountLabels            = { bank = 'Bank', black_money = 'Dirty Money' } -- English
Config.PaycheckInterval         = 10 * 60000
Config.ShowDotAbovePlayer       = false
Config.DisableWantedLevel       = true
Config.RemoveInventoryItemDelay = 1 * 3000
Config.RemoveWeaponItemDelay 	= 1 * 30000
Config.EnableWeaponPickup       = true
Config.MaxInventoryWeight 		= 10000	--in g
Config.MaxFoodInventoryWeight 	= 10000	--in g
Config.Locale                   = 'fr'
Config.EnableDebug              = false

Config.FoodItems = {'bread', 'binoculars', 'vegetables', 'milk', 'fixkit', 'carokit', 'carotool', 'fixtool', 'water', 'donuts', 'donut_iced', 'donut_choco', 'donut_manche', 'raspberry_donut', 'donut_vanilla', 'burger', 'alcootest',  'beer', 'chips', 'cigarette', 'raspberry_coffee', 'coffee_vanilla', 'hot_chocolate', 'coffee_iced', 'coffee_milk', 'coffee_choco', 'cofee_manche', 'cognak', 'cola', 'croquettes', 'cutting_pince', 'milkshake', 'nugget', 'panini', 'whiskey', 'tacos', 'tequila', 'tiquet', 'richard', 'rum', 'sprunk', 'phone', 'vodka', 'fishing_rod', 'sevenup', 'monster', 'bait', 'petrol_can', 'drill'}
Config.DrugItems = {'tracker', 'electro_bracelet', 'carstarter_kit', 'coke', 'coke2', 'coke3', 'coke4', 'coke5', 'coke6', 'cutting_pince', 'hack_phone', 'lsd', 'lsd2', 'lsd3', 'lsd4', 'lsd5', 'meth', 'meth2', 'meth3', 'meth4', 'meth5', 'meth6', 'serflex', 'weed', 'weed2', 'weed3', 'weed4', 'weed5', 'jewel', 'jargon'}