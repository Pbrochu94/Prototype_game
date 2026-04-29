extends Resource
class_name Weapon

@export var name: String
@export var element:String
@export var attacks:Dictionary= {
	"sword slash 1" : preload("res://utils/Attacks/MainCharacter/Weapons/LightSword/LightSlash1.tres"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
