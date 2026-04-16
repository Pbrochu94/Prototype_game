extends State
class_name PlayerIntro

@export var player:Node2D
signal introFinished

func _onready():
	pass

func enter():
	owner.isWalking = true
	owner.anim.play("walk")

func _process(delta):
	owner.walk(delta, player.startingPosition)

func exit():
	owner.isWalking = false
