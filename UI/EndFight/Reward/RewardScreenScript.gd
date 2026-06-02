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
	currentCombatScene.targetManager.invocationSelectionEnded()
	RunManager.nodes[RunManager.currentNode]["completed"] = true
	var nextNode = RunManager.currentNode + 1
	if nextNode < RunManager.nodes.size():
		RunManager.nodes[nextNode]["unlocked"] = true
		get_tree().change_scene_to_file("res://MapNodes/OverworldMap/OverworldMap.tscn")

func gainReward():
	var lightShardsGained = currentCombatScene.combatEncounterData.lightShardReward
	var xpGained = currentCombatScene.combatEncounterData.xpReward
	RunManager.currentLightShards += lightShardsGained
	RunManager.currentXp += currentCombatScene.combatEncounterData.xpReward
	print("You gain: ", lightShardsGained, " light shards")
	print("You gain: ", xpGained, " xp")


func open():
	connectSignals()
	visible = true
	gainReward()
	choosingInvocation()
func choosingInvocation():
#	RunManager.addUnitToParty(UnitDB.firstWorldUnits.pick_random())
	currentCombatScene.targetManager.invocationSelectionStarted()
func summon(unit:UnitDefinition):
	if RunManager.currentParty.size() >= 5:
		print("party is currently full: ", RunManager.currentParty)
		return
	var hasEnoughLightShards:bool = calculateSummonCost(unit.summonCost)
	if hasEnoughLightShards:
		var lightShardsBeforePayment = RunManager.currentLightShards 
		RunManager.currentLightShards -= unit.summonCost
		var unitNameTag = unit.characterTag
		var summon = UnitDB.firstWorldUnits.get(unitNameTag)
		RunManager.addUnitToParty(summon)
		print("Player current lightshards : ", lightShardsBeforePayment," -> ", RunManager.currentLightShards)
	else:
		print(unit.summonCost, " light shards is needed to invoke, player only has: ", RunManager.currentLightShards)
func calculateSummonCost(unitCost:int):
	if RunManager.currentLightShards >= unitCost:
		return true
	else:
		return false
