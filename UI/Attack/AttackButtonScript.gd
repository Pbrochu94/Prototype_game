extends Node

@onready var turnManager = get_tree().get_first_node_in_group("turn manager")

var currentlyPlayingUnit:BaseUnitScript
var attackLinked:Ability

signal attackSelected(attack:Ability)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onClick():
	if attackLinked.currentCooldown > 0:
		print(attackLinked.attackName, " is on cooldown for ", attackLinked.currentCooldown, " turn")
		return
	emit_signal("attackSelected", attackLinked)
