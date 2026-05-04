extends Node


#VARIABLES
var party:Array[Node2D]
var aliveCount:int
var currentlyAliveCharacters:Array[Node2D]

#SIGNALS
signal partyDead

# Called when the node enters the scene tree for the first time.
func _ready():
	loadRandomTeam()
	currentlyAliveCharacters = party

#PARTY HANDLERS
func onCharacterDeath(character:Node2D):
	aliveCount -= 1
	currentlyAliveCharacters = party.filter(
		func(character):
			return not character.isDead
	)
	print("Currently alive characters: ", currentlyAliveCharacters)
	if aliveCount <= 0:
		emit_signal("partyDead")

#TEST DATA
var allCharacters:Array[PackedScene] = [
	preload("res://Invocations/Samurai/SamuraiScene.tscn"),
	preload("res://Invocations/CannonDruid/CannonDruidCombat.tscn")
]
func loadRandomTeam():
	for i in range(2):
		var character = allCharacters.pick_random().instantiate()
		character.faction = character.Faction.SUMMON
		character.isDowned.connect(onCharacterDeath)
		aliveCount += 1
		print(party, aliveCount)
		party.append(character)
