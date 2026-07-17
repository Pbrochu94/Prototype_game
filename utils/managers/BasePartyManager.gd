extends Node
class_name BasePartyManager


#NODES
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene = get_tree().get_first_node_in_group("combat scene")
#VARIABLES
var party:Array[UnitInstance]
var partyInstances:Array[BaseUnitScript]
var aliveCount:int
var currentlyAliveCharacters:Array[UnitInstance]
var partyFaction

#SIGNALS
signal partyDead

func init():
	connectSignals()

#INIT
func connectSignals():
	turnManager.playOutroAnim.connect(outroAnim)
#PARTY HANDLERS
func onCharacterDeath(character:UnitInstance):
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

func assignUnitFaction(character:UnitInstance):
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

func addUnitConnections(character:Node2D):
	character.isDowned.connect(onCharacterDeath)

func getPartyInfo():
	var infoArray:Array
	for unit in party:
		infoArray.append(unit.getUnitInfo)
	return infoArray

func placeUnit():
	for unit in party:
		unit.scene.currentCombatScene = currentCombatScene
		addUnitConnections(unit.scene)
	for i in range(party.size()):
		currentCombatScene.add_child(party[i].scene)
		if partyFaction == Enum.Faction.PLAYER:
			if i < currentCombatScene.playerAnchors.size():
				partyInstances[i].global_position = currentCombatScene.playerAnchors[i].global_position
				partyInstances[i].startingPosition = currentCombatScene.playerAnchors[i].global_position
		else:
			if i < currentCombatScene.enemyAnchors.size():
				partyInstances[i].global_position = currentCombatScene.enemyAnchors[i].global_position
				partyInstances[i].startingPosition = currentCombatScene.enemyAnchors[i].global_position

func addUnitToPartyInstances():
		for i in range(party.size()):
			var unit = party[i]
			partyInstances.append(unit.scene)
