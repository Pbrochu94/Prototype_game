extends State
class_name Hurt

func _onready():
	pass

func enter():
	owner.anim.play("hurt")

func update(delta):
	pass

func exit():
	pass
