extends State
class_name Hurt

func _onready():
	pass

func enter():
	owner.anim.play("hurt")
	owner.anim.connect("animation_finished", Callable(self, "animFinished"), CONNECT_ONE_SHOT)

func update(delta):
	pass

func exit():
	pass

func animFinished():
	if owner.currentHp <= 0:
		owner.stateMachine.setState(owner.stateMachine.states["downed"])
