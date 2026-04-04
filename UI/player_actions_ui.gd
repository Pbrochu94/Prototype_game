extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


