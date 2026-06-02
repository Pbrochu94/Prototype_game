extends Node
#NODES & TRACKING
var currentNode:int
var currentEncounterData:EncounterData = preload("res://utils/Data/EncounterData/Combat/Tutorial/CombatLV0Res.tres")
#var currentEncounterData:EncounterData
#PROGRESS TRACKING
var currentParty:Array[UnitDefinition] 
var currentLightShards:int
var currentXp:int
#STARTING KIT
var startingUnit:UnitDefinition = UnitDB.firstWorldUnits["samurai"].duplicate(true)
const startingLightShards:int = 0


func _ready():
	currentParty.append(startingUnit)
#	for i in range(3):
#		addUnitToParty(UnitDB.firstWorldUnits.pick_random())

var nodes = [
	{
		"id": 0,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": true,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/Tutorial/CombatLV0Res.tres")
	},
	{
		"id": 1,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV1/CombatEncounterLV1Data.tres")
	},
	{
		"id": 2,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	},
	{
		"id": 3,
		"type": Enum.EncounterType.COMBAT,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	},
	{
		"id": 4,
		"type": Enum.EncounterType.BOSS,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/MiniBoss/MiniBossEncounter.tres")
	}
]

func addUnitToParty(unit:UnitDefinition):
	var unitData = unit.duplicate(true)
	currentParty.append(unitData)
