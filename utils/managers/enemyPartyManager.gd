extends Node

#VARIABLES
var party:Array[Node2D]
var aliveCount:int
var currentlyAliveCharacters:Array[Node2D]

#SIGNALS
signal partyDead

# Called when the node enters the scene tree for the first time.
func _ready():
#	for partyMember in get_tree().get_nodes_in_group("enemy"):
#		party.append(partyMember)
#		partyMember.isDowned.connect(onCharacterDeath)
#		aliveCount += 1
#		print(party, aliveCount)
	loadRandomTeam()
	currentlyAliveCharacters = party

#PARTY HANDLERS
func onCharacterDeath(character:Node2D):
	aliveCount -= 1
	currentlyAliveCharacters = party.filter(
		func(character):
			return not character.isDead
	)
	print("Currently alive enemies: ", currentlyAliveCharacters)
	if aliveCount <= 0:
		emit_signal("partyDead")

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
		var character = allCharacters[2].instantiate()
		character.faction = character.Faction.ENEMY
		character.isDowned.connect(onCharacterDeath)
		aliveCount += 1
		party.append(character)
