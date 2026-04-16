extends State
class_name WalkBack

@export var player:Node2D

func enter():
	player.isWalking = true
	player.anim.play("walk")
	player.anim.scale.x = -1

func exit():
	player.isWalking = false
	emit_signal("turnFinished")
