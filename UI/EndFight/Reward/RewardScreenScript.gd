extends Control

var currentScene:CombatEncounter
@onready var continueButton:Button =  $CenterContainer/ColorRect/VBoxContainer/Button
@onready var rewardManager = get_tree().get_first_node_in_group("reward manager")

func init():
	visible = false

func connectSignals():
	for enemy in currentScene.enemyPartyManager.partyInstances:
		enemy.selectedForSummon.connect(RunManager.summon)
func buttonPressed():
	currentScene.playerPartyManager.removeUnitsFromParties()
	currentScene.targetManager.invocationSelectionEnded()
	RunManager.unlockNextNode()

func gainReward():
	var xpGained = currentScene.combatEncounterData.xpReward
	RunManager.currentXp += currentScene.combatEncounterData.xpReward
	print("You gain: ", xpGained, " xp")


func open():
	connectSignals()
	visible = true
	rewardManager.init(currentScene.encounterData)
	rewardManager.grantReward()
	#IN THE FUTURE NEED TO WAIT UNTIL REWARD IS GIVEN BEFORE MOVING ALONG WITH THE CODE
	RunManager.removeDownedAllyFromParty()
	choosingInvocation()
	print(RunManager.getPlayerInfo())
func choosingInvocation():
#	RunManager.addUnitToParty(UnitDB.firstWorldUnits.pick_random())
	currentScene.targetManager.invocationSelectionStarted()


