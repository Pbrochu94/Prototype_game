extends State
class_name EndingTurn


func _onready():
	pass

func enter():
	owner.anim.play("idle")
	#Make the enemy face left and the player face right
	if owner.is_in_group("enemy"):
		owner.anim.scale.x = -1
	else:
		owner.anim.scale.x = 1
	exit()

func update(delta):
	pass

func exit():
	owner.stateMachine.setState(owner.stateMachine.states["idle"])

