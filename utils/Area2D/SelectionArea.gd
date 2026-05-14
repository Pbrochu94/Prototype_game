extends Area2D

@onready var character = get_parent()
var playerIsSelectingTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#INPUT LISTENERS
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
			if playerIsSelectingTarget:
				pass


#CHECKS
func checkIfSelectionPhase(CombatScene:Node2D):
	pass
