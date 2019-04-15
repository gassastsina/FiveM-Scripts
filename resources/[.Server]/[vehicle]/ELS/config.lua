vcf_files = {
	"police.xml",
	"police2.xml",
	"police3.xml",
	"police4.xml",
	"policeb.xml",
	"sheriff.xml",
	"fbi.xml",
	"fbi2.xml",
	"ambulance.xml",
	"riot.xml",
	"policet.xml",
	"firetruk.xml",
	"pranger.xml",
	"policeold1.xml",
	"policeold2.xml"
}

pattern_files = {
	"WIGWAG.xml",
	"WIGWAG3.xml",
	"FAST.xml",
	"COMPLEX.xml",
	"BACKFOURTH.xml",
	"BACKFOURTH2.xml",
	"T_ADVIS_RIGHT_LEFT.xml",
	"T_ADVIS_LEFT_RIGHT.xml",
	"T_ADVIS_BACKFOURTH.xml",
	"WIGWAG5.xml"
}

modelsWithTrafficAdvisor = {
	"police",
    "police2",
    "police3",
	"police4",
	"police5",
    "policeold1",
    "policeold2",
	"fbi",
	"fbi2",
	"ambulance"
}

modelsWithFireSiren =
{
	"firetruk"
}


modelsWithAmbWarnSiren =
{
	"ambulance",
	"policeold2"
}

stagethreewithsiren = false
playButtonPressSounds = true
vehicleStageThreeAdvisor = {
	"police",
    "police2",
    "police3",
	"police4",
    "fbi",
    "fbi2",
    "policeold1",
    "policeold2"
}


vehicleSyncDistance = 200
envirementLightBrightness = 0.4

build = "master"

shared = {
	horn = 86,
}

keyboard = {
	modifyKey = 132,
	stageChange = 85,
	guiKey = 243,
	takedown = 245,
	siren = {
		tone_one = 157,
		tone_two = 158,
		tone_three = 160,
		dual_toggle = 164,
		dual_one = 165,
		dual_two = 159,
		dual_three = 161,
	},
	pattern = {
		primary = 246,
		secondary = 303,
		advisor = 182,
	},
}

controller = {
	modifyKey = 73,
	stageChange = 80,
	takedown = 74,
	siren = {
		tone_one = 173,
		tone_two = 85,
		tone_three = 172,
	},
}