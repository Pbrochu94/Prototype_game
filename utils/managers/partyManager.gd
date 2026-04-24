extends Node

var party:Array
var aliveCount:int
signal partyDead

# Called when the node enters the scene tree for the first time.
func _ready():
	for partyMember in get_tree().get_nodes_in_group("party member"):
		party.append(partyMember)
		partyMember.isDowned.connect(onCharacterDeath)
		aliveCount += 1
		print(party, aliveCount)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onCharacterDeath():
	aliveCount -= 1
	if aliveCount <= 0:
		emit_signal("partyDead")
