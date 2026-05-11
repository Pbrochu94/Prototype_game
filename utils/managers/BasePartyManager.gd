extends Node
class_name BasePartyManager


#NODES
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
#VARIABLES
var party:Array[Node2D]
var aliveCount:int
var currentlyAliveCharacters:Array[Node2D]
var partyFaction

#SIGNALS
signal partyDead

# Called when the node enters the scene tree for the first time.
func _ready():
	print(turnManager)
	connectSignals()
	currentlyAliveCharacters = party

#INIT
func connectSignals():
	turnManager.playOutroAnim.connect(outroAnim)
#PARTY HANDLERS
func onCharacterDeath(character:Node2D):
	aliveCount -= 1
	currentlyAliveCharacters = party.filter(
		func(character):
			return not character.isDead
	)
	print("Remaining party characters alive : ", currentlyAliveCharacters)
	if aliveCount <= 0:
		turnManager.fightIsOver = true
		turnManager.playerLost = true
func outroAnim():
	for character in currentlyAliveCharacters:
		character.setState("outro")
#TEST DATA
var allCharacters:Array[PackedScene] = [
	preload("res://Invocations/Samurai/SamuraiScene.tscn"),
	preload("res://Invocations/CannonDruid/CannonDruidCombat.tscn"),
	preload("res://Invocations/Archer/ArcherCombat.tscn"),
	preload("res://Invocations/BlasterDruid/BlasterDruidCombat.tscn")
]
func loadRandomTeam():
	for i in range(1):
		#Random characters
#		var character = allCharacters.pick_random().instantiate()
		#Specific character to test
		var character = allCharacters[3].instantiate()
		assignUnitFaction(character)
		addUnitToParty(character)
		addUnitConnections(character)

func assignUnitFaction(character:Node2D):
	character.faction = partyFaction

func addUnitToParty(character:Node2D):
	aliveCount += 1
	party.append(character)

func addUnitConnections(character:Node2D):
	character.isDowned.connect(onCharacterDeath)
