extends State
class_name GetInPosition

@export var player:Node2D

func enter():
	player.isWalking = true
	player.anim.play("walk")

func exit():
	player.isWalking = false
