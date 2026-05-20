extends Node2D
class_name BaseSpellScript
@onready var anim = $SpritePivot/AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("appear")


func onAnimationFinished():
	match anim:
		"appear":
			anim.play("active")
		"disapear":
			pass
			#Will remove object from unit instanciate
