extends Node
class_name BasePartyManager


#NODES
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene = get_tree().get_first_node_in_group("combat scene")
#VARIABLES
var party:Array[UnitInstance]
var partyInstances:Array[BaseUnitScript]
var aliveCount:int
var currentlyAliveCharacters:Array[BaseUnitScript]
var partyFaction

#SIGNALS
signal partyDead

func init():
	connectSignals()

#INIT
func connectSignals():
	turnManager.playOutroAnim.connect(outroAnim)
#PARTY HANDLERS
func onCharacterDeath(character:BaseUnitScript):
	aliveCount -= 1
	removeUnitFromQ(character)
	currentlyAliveCharacters = partyInstances.filter(
		func(character):
			return not character.isDead
	)
	print("Remaining party characters alive : ", currentlyAliveCharacters)
	if aliveCount <= 0:
		turnManager.fightIsOver = true
		if partyFaction == Enum.Faction.PLAYER:
			turnManager.playerLost = true
		else:
			turnManager.playerWon = true
func outroAnim():
	for character in currentlyAliveCharacters:
		character.setState("outro")
#TEST DATA

func assignUnitFaction(character:BaseUnitScript):
	character.faction = partyFaction

func removeUnitFromQ(character):
	var scene = character.stats.scene
	scene.isSelectable()
	turnManager.playOrder.erase(scene)

func removeUnitsFromParties():
	for unit in party:
		if unit.scene.isDead:
			partyInstances.erase(unit.scene)
			party.erase(unit)
			RunManager.currentParty.erase(unit)
			unit.scene.queue_free()

func addUnitConnections(character:BaseUnitScript):
	character.isDowned.connect(onCharacterDeath)

func getPartyInfo():
	var infoArray:Array
	for unit in party:
		infoArray.append(unit.getUnitInfo)
	return infoArray
