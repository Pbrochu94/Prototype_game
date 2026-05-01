extends Node

#VARIABLES
var party:Array[Node2D]
var aliveCount:int
var currentlyAliveCharacters:Array[Node2D]

#SIGNALS
signal partyDead

# Called when the node enters the scene tree for the first time.
func _ready():
	for partyMember in get_tree().get_nodes_in_group("enemy"):
		party.append(partyMember)
		partyMember.isDowned.connect(onCharacterDeath)
		aliveCount += 1
		print(party, aliveCount)
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
