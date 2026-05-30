extends Node
class_name AbilityVisual

@onready var anim = $SpritePivot/AnimatedSprite2D


signal spellFinishedCasting

# Called when the node enters the scene tree for the first time.
func _ready():
	self.z_index = 1
	anim.play("appear")

func exit():
	pass

func onAnimationFinished():
	match anim.animation:
		"appear":
			anim.play("active")
		"active":
			anim.play("disapear")
		"disapear":
			queue_free()
