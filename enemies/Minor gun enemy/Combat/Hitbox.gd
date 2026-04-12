extends Area2D

@onready var parentEnemy = get_tree().get_nodes_in_group("enemy")
var playerIsSelectingTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#INPUT LISTENERS
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
			if playerIsSelectingTarget:
				print("Player clicked on enemy")



#CHECKS
func checkIfSelectionPhase(CombatScene:Node2D):
	pass
