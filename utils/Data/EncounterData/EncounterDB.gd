extends Node

var idCounter:int = 0

const encounters = {
	"combatLV0": {
		"type":Enum.EncounterType.COMBAT,
		"level":0,
		"data": preload("res://utils/Data/EncounterData/Combat/Tutorial/CombatLV0Res.tres"), 
		"node": preload("res://Overworld/Nodes/Combat/CombatNormal.tscn")
		},
	"combatLV1": {
		"type":Enum.EncounterType.COMBAT,
		"level":1,
		"data": preload("res://utils/Data/EncounterData/Combat/LV1/CombatEncounterLV1Data.tres"), 
		"node": preload("res://Overworld/Nodes/Combat/CombatNormal.tscn")
		},
	"combatLV2": {
		"type":Enum.EncounterType.COMBAT,
		"level":2,
		"data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres"), 
		"node": preload("res://Overworld/Nodes/Combat/CombatNormal.tscn")
		},
#	"combatElite": {
#		"type":Enum.EncounterType.ELITE,
#		"data": preload("res://utils/Data/EncounterData/Combat/LV2/CombatEncounterLV2DataRes.tres"), 
#		"node": preload("res://Overworld/Nodes/Sprites/BaseCombatNode.tscn")
#		},
	"combatMiniBoss": {
		"type":Enum.EncounterType.MINI_BOSS,
		"level":null,
		"data": preload("res://utils/Data/EncounterData/Combat/MiniBoss/MiniBossEncounter.tres"), 
#		"node": preload("res://Overworld/Nodes/Combat/CombatNormal.tscn")
		},
	"spellEncounterBase": {
		"type":Enum.EncounterType.SPELL,
		"level":null,
		"data": preload("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/BasicSpellEncounterRes.tres"), 
		"node": preload("res://Overworld/Nodes/SpellEncounter/BaseSpellEncounterNode.tscn")
		},
}

func createEncounter(type:Enum.EncounterType):
	var encounter = pickRandomEncounter(type)
	initEncounterData(encounter)
	return encounter


func pickRandomEncounter(type:Enum.EncounterType):
	print("AHHH ",Enum.EncounterType.keys()[type])
	var validEncounters:Array
	for encounterName in encounters:
		if encounters[encounterName].type == type:
			print(Enum.EncounterType.keys()[encounters[encounterName].type])
			validEncounters.append(encounters[encounterName])
	return validEncounters.pick_random().data.duplicate(true)
func initEncounterData(encounter:EncounterData):
	encounter.id = generateEncounterID() 
func generateEncounterID() -> int:
	idCounter += 1
	return idCounter


