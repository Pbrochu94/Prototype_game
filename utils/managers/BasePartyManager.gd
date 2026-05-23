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
		if partyFaction == Enum.Faction.PLAYER:
			turnManager.playerLost = true
		else:
			turnManager.playerWon = true
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
	var characterCount = 0
	match partyFaction:
		Enum.Faction.PLAYER:
			for i in range(3):
				characterCount += 1
				#Random characters
				var character = allCharacters.pick_random().instantiate()
				#Specific character to test
#				var character = allCharacters[0].instantiate()
				assignUnitFaction(character)
				addUnitToParty(character)
				addUnitConnections(character)
				if character.faction == Enum.Faction.PLAYER:
					character.characterName += " summon "
				else:
					character.characterName += " enemy "
				character.characterName += str(characterCount)
		Enum.Faction.ENEMY:
			for i in range(3):
				characterCount += 1
				#Random characters
				var character = allCharacters.pick_random().instantiate()
				#Specific character to test
#				var character = allCharacters[3].instantiate()
				assignUnitFaction(character)
				addUnitToParty(character)
				addUnitConnections(character)
				if character.faction == Enum.Faction.PLAYER:
					character.characterName += " summon "
				else:
					character.characterName += " enemy "
				character.characterName += str(characterCount)

func assignUnitFaction(character:Node2D):
	character.faction = partyFaction

func addUnitToParty(character:Node2D):
	aliveCount += 1
	party.append(character)
	currentlyAliveCharacters.append(character)

func addUnitConnections(character:Node2D):
	character.isDowned.connect(onCharacterDeath)

func getPartyInfo():
	var infoArray:Array
	for unit in party:
		infoArray.append(unit.getUnitInfo)
	return infoArray
