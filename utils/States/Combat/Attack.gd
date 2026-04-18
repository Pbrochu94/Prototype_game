extends State
class_name Attacking


func _onready():
	pass

func enter():
	owner.anim.play("attack")
#	owner.anim.scale.x = 1

func update(delta):
	pass

func exit():
	pass
