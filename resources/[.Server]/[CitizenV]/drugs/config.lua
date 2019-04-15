------------------------------------
------------------------------------
----    File : config.lua       ----
----    Author : gassastsina    ----
----    Side : client         	----
----    Description : Drugs 	----
------------------------------------
------------------------------------

-----------------------------------------------main-------------------------------------------------------
Config = {}
Config.DrawDistance = 30
Config.MarkerColor = {r = 8, g = 122, b = 21}
Config.MarkerSize 	= {x = 2.0, y = 2.0, z = 0.5}

Config.Points = {
	--Weed
	{actionTypeLabel = 'récolter', actionType = 'harvest', drugType = 'pied de chanvre', x = 2215.9997, y = 5578.0366, z = 52.8220, item = 'weed', count = 1, time = 2500},
	{actionTypeLabel = 'couper', actionType = 'treatment', drugType = 'branches de cannabis', x = 1057.5432, y = -3197.2822, z = -40.1300, fromItem = 'weed', fromCount = 1, toItem = 'weed2', toCount = 1, time = 2000},
	{actionTypeLabel = 'sécher', actionType = 'treatment', drugType = 'branches de cannabis', x = 1040.6887, y = -3202.3173, z = -39.1642, fromItem = 'weed2', fromCount = 1, toItem = 'weed3', toCount = 1, time = 3000},
	{actionTypeLabel = 'récupérer', actionType = 'treatment', drugType = 'cannabis', x = 1037.5354, y = -3205.2607, z = -39.1702, fromItem = 'weed3', fromCount = 2, toItem = 'weed4', toCount = 1, time = 2500},
	{actionTypeLabel = 'couper', actionType = 'treatment', drugType = 'cannabis', x = 1064.6806, y = -3189.2656, z = -40.1472, fromItem = 'weed4', fromCount = 1, toItem = 'weed5', toCount = 1, time = 2500},
				--weed= plan de chanvre / weed2= branches coupés / weed3= branches séchés / weed4= cannabis pure / weed5= cannabis
	--Coke
	{actionTypeLabel = 'récolter', actionType = 'harvest', drugType = 'feuille de coca', x = 778.2449, y = 4184.2373, z = 40.7892, item = 'coke', count = 1, time = 3000},
	{actionTypeLabel = 'émincer', actionType = 'treatment', drugType = 'feuille de coca', x = 1087.2162, y = -3196.3051, z = -39.9900, fromItem = 'coke', fromCount = 1, toItem = 'coke2', toCount = 1, time = 3000},
	{actionTypeLabel = 'ajouter', actionType = 'treatment', drugType = 'liant', x = 1091.4218, y = -3196.5693, z = -39.9934, fromItem = 'coke2', fromCount = 1, toItem = 'coke3', toCount = 1, time = 3000},
	{actionTypeLabel = 'ajouter', actionType = 'treatment', drugType = 'ammoniac', x = 1099.5534, y = -3195.0507, z = -39.9934, fromItem = 'coke3', fromCount = 1, toItem = 'coke4', toCount = 1, time = 2500},
	{actionTypeLabel = 'couper', actionType = 'treatment', drugType = 'essence', x = 1101.8909, y = -3193.6748, z = -39.9934, fromItem = 'coke4', fromCount = 2, toItem = 'coke5', toCount = 1, time = 3000},
	{actionTypeLabel = 'chauffer', actionType = 'treatment', drugType = 'cocaïne impure', x = 1099.3221, y = -3198.9577, z = -39.9934, fromItem = 'coke5', fromCount = 1, toItem = 'coke6', toCount = 1, time = 3000},
				--coke= feuilles de coca / coke2= feuilles de coca coupées / coke3= mixture de coca / coke4= cristaux de coca  / coke5= cocaine allongée / coke6= cocaïne pure

	--LSD
	{actionTypeLabel = 'récolter', actionType = 'harvest', drugType = 'diéthylamine', x = 369.0342, y = 3407.6547, z = 35.4035, item = 'lsd', count = 1, time = 3000},
	{actionTypeLabel = 'ajouter', actionType = 'treatment', drugType = 'acide lysergique', x = 2483.6313, y = 4085.0537, z = -25.4197, fromItem = 'lsd', fromCount = 1, toItem = 'lsd2', toCount = 1, time = 3000},
	{actionTypeLabel = 'chauffer', actionType = 'treatment', drugType = "l'acide", x = 2488.1206, y = 4087.0944, z = -25.4197, fromItem = 'lsd2', fromCount = 1, toItem = 'lsd3', toCount = 1, time = 3000},
	{actionTypeLabel = 'imbiber', actionType = 'treatment', drugType = 'LSD', x = 2486.5417, y = 4083.1218, z = -25.4197, fromItem = 'lsd3', fromCount = 2, toItem = 'lsd4', toCount = 1, time = 3000},
	{actionTypeLabel = 'emballer', actionType = 'treatment', drugType = 'LSD', x = 2488.8498, y = 4081.9460, z = -25.4197, fromItem = 'lsd4', fromCount = 1, toItem = 'lsd5', toCount = 1, time = 3000},
				--lsd= diéthylamine / lsd2= produits chimiques / lsd3= LSD liquide / lsd4= buvard de LSD / lsd5= paquet de LSD 
	--Meth				
	{actionTypeLabel = 'Récupérer', actionType = 'harvest', drugType = 'méthanol', x = 1012.6333, y = -3196.6660, z = -39.9931, item = 'meth', count = 1, time = 2500},
	{actionTypeLabel = 'mélanger', actionType = 'treatment', drugType = 'acétone', x = 1014.6732, y = -3198.5598, z = -39.9931, fromItem = 'meth', fromCount = 1, toItem = 'meth2', toCount = 1, time = 3000},
	{actionTypeLabel = 'ajouter', actionType = 'treatment', drugType = 'pseudophédrine', x = 1010.9924, y = -3199.9184, z = -39.9931, fromItem = 'meth2', fromCount = 1, toItem = 'meth3', toCount = 1, time = 3000},
	{actionTypeLabel = 'distiler', actionType = 'treatment', drugType = 'iodine', x = 1008.1365, y = -3199.3608, z = -39.9931, fromItem = 'meth3', fromCount = 1, toItem = 'meth4', toCount = 1, time = 3000},
	{actionTypeLabel = 'distiler', actionType = 'treatment', drugType = 'phospore rouge', x = 1005.7948, y = -3200.3930, z = -39.5193, fromItem = 'meth4', fromCount = 2, toItem = 'meth5', toCount = 1, time = 3000},
	{actionTypeLabel = 'réduire', actionType = 'treatment', drugType = 'aluminium', x = 1002.9605, y = -3200.0983, z = -39.9931, fromItem = 'meth5', fromCount = 1, toItem = 'meth6', toCount = 1, time = 3000}
				--meth1= méthanol / meth2= mélange chimique / meth3= méthamphétamine liquide / meth4= méthamphétamine pure / meth5= bloc de méthamphétamine / meth6= méthamphétamine
}
--Appuyez sur E pour (actionTypeLabel) de la (drugType)

Config.MaxDrugTime 	= 600000