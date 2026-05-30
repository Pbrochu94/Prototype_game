extends Control

var currentCombatScene:CombatEncounter

func init():
	visible = false
	

func buttonPressed():
	RunManager.nodes[RunManager.currentNode]["completed"] = true
	var nextNode = RunManager.currentNode + 1
	if nextNode < RunManager.nodes.size():
		RunManager.nodes[nextNode]["unlocked"] = true
		get_tree().change_scene_to_file("res://MapNodes/OverworldMap/OverworldMap.tscn")

func gainReward():
	var lightShardGained = currentCombatScene.combatEncounterData.lightShardReward
	var xpGained = currentCombatScene.combatEncounterData.xpReward
	RunManager.currentLightShard += lightShardGained
	RunManager.currentXp += currentCombatScene.combatEncounterData.xpReward
	print("You gain: ", lightShardGained, " light shards")
	print("You gain: ", xpGained, " xp")


func open():
	visible = true
	if currentCombatScene.playerPartyManager.party.size() < 3:
		choosingInvocation()
	gainReward()

func choosingInvocation():
	RunManager.addUnitToParty(UnitDB.firstWorldUnits.pick_random())
