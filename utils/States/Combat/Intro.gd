extends State
class_name Intro

signal introFinished

func _onready():
	pass

func enter():
	owner.isWalking = true
	owner.anim.play("walk")
	if owner.is_in_group("enemy"):
		owner.spriteOrientation.scale.x = -1

func _process(delta):
	owner.walk(delta, owner.startingPosition)

func exit():
	owner.isWalking = false
