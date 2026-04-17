extends State
class_name WalkBack


func enter():
	owner.isWalking = true
	owner.anim.play("walk")
	owner.anim.scale.x = -1

func exit():
	owner.isWalking = false
	emit_signal("turnFinished")
