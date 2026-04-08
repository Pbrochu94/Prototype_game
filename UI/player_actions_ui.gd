extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var attackBtn = $Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	attackBtn.pressed.connect(attackIsPressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ItemsPressed():
	print("Items") # Replace with function body.


func abilitiesPressed():
	print("Abilities") # Replace with function body.



func attackIsPressed():
	print("ATTACK")
