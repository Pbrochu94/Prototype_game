extends State
class_name Idle

@export var player:Node2D

func enter():
	player.anim.play("idle")
	player.anim.scale.x = 1
