extends Control

var currentCombatScene:CombatEncounter
@onready var continueButton:Button =  $CenterContainer/ColorRect/VBoxContainer/Button

func init():
	visible = false

func connectSignals():
	for enemy in currentCombatScene.enemyPartyManager.partyInstances:
		enemy.selectedForSummon.connect(RunManager.summon)
func buttonPressed():
	currentCombatScene.playerPartyManager.removeUnitsFromParties()
	currentCombatScene.targetManager.invocationSelectionEnded()
	RunManager.unlockNextNode()

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
	RunManager.removeDownedAllyFromParty()
	choosingInvocation()
	print(RunManager.getPlayerInfo())
func choosingInvocation():
#	RunManager.addUnitToParty(UnitDB.firstWorldUnits.pick_random())
	currentCombatScene.targetManager.invocationSelectionStarted()


