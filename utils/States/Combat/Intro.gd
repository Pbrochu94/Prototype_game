extends State
class_name IntroState

signal introFinished

func _onready():
	pass

func enter():
	owner.isWalking = true
	owner.anim.play("walk")

func update(delta):
	owner.walk(delta, owner.startingPosition)

func exit():
	owner.isWalking = false
