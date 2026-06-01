extends Control

var currentCombatScene:CombatEncounter
@onready var continueButton:Button =  $CenterContainer/ColorRect/VBoxContainer/Button

func init():
	visible = false

func connectSignals():
	for enemy in currentCombatScene.enemyPartyManager.partyInstances:
		enemy.selectedForSummon.connect(summon)
func buttonPressed():
	currentCombatScene.playerPartyManager.removeUnitsFromParties()
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
	connectSignals()
	visible = true
	if currentCombatScene.playerPartyManager.party.size() < 3:
		choosingInvocation()
	gainReward()
func choosingInvocation():
#	RunManager.addUnitToParty(UnitDB.firstWorldUnits.pick_random())
	currentCombatScene.targetManager.invocationSelectionStarted()
func summon(unit:UnitDefinition):
	var hasEnoughLightShards:bool = calculateSummonCost(unit.summonCost)
	if hasEnoughLightShards:
		RunManager.addUnitToParty(unit)
	else:
		print(unit.summonCost, " light shards is needed to invoke, player only has: ", RunManager.currentLightShard)
func calculateSummonCost(unitCost:int):
	if RunManager.currentLightShard >= unitCost:
		RunManager.currentLightShard -= unitCost
		return true
	else:
		return false
