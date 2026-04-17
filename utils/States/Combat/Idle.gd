extends State
class_name Idle


func _onready():
	pass

func enter():
	print("Enter idle")
	owner.anim.play("idle")
#	owner.anim.scale.x = 1

func exit():
	pass
