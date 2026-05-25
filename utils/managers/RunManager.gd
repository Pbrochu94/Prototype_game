extends Node
#NODES & TRACKING
var currentNode:int
var currentEncounterData:EncounterData

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
		"type": Enum.EncounterType.BOSS,
		"completed": false,
		"unlocked": false,
		"encounter data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres")
	}
]
