extends Node2D
class_name BaseSpellScript
@onready var anim = $SpritePivot/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation_finished.connect(onAnimationFinished)
	anim.play("appear")

func exit():
	anim.play("disapear")

func onAnimationFinished():
	match anim.animation:
		"appear":
			anim.play("active")
		"disapear":
			queue_free()
