extends Node

var party:Array[Node2D]
var aliveCount:int
var currentlyAliveCharacters:Array[Node2D]
signal partyDead

# Called when the node enters the scene tree for the first time.
func _ready():
	for partyMember in get_tree().get_nodes_in_group("enemy"):
		party.append(partyMember)
		partyMember.isDowned.connect(onCharacterDeath)
		aliveCount += 1
		print(party, aliveCount)
	currentlyAliveCharacters = party



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onCharacterDeath(character:Node2D):
	aliveCount -= 1
	currentlyAliveCharacters = party.filter(
		func(character):
			return not character.isDead
	)
	print("Currently alive enemies: ", currentlyAliveCharacters)
	if aliveCount <= 0:
		emit_signal("partyDead")
