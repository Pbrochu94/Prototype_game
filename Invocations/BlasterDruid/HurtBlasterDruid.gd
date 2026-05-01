extends State
class_name HurtBlasterDruid

func _onready():
	pass

func enter():
	owner.anim.play("hurt")
#	owner.anim.connect("animation_finished", Callable(self, "animFinished"), CONNECT_ONE_SHOT)

func update(delta):
	pass

func exit():
	pass

#func animFinished():
#	if owner.anim.animation == "hurt":
#		if owner.currentHp <= 0:
#			owner.stateMachine.setState(owner.stateMachine.states["downed"])
#		else:
#			owner.stateMachine.setState(owner.stateMachine.states["idle"])

