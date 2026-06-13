extends State
class_name DownedState

func _onready():
	pass

func enter():
	owner.anim.play("downed")
	owner.z_index = 0
	owner.emit_signal("isDowned", owner)

func update(delta):
	pass

func exit():
	owner.z_index = 1
