extends State
class_name Idle

@export var player:Node2D

func _onready():
	pass

func enter():
	print("Enter idle")
	player.anim.play("idle")
	player.anim.scale.x = 1

func exit():
	pass
