extends State
class_name Idle


func _onready():
	pass

func enter():
	owner.anim.play("idle")
#	owner.anim.scale.x = 1

func update(delta):
	pass

func exit():
	pass

