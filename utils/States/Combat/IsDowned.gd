extends State
class_name IsDowned

func _onready():
	pass

func enter():
	owner.anim.play("downed")

func _process(delta):
	pass

func update(delta):
	pass

func exit():
	pass
