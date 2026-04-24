extends State
class_name Downed

func _onready():
	pass

func enter():
	owner.anim.play("downed")
	owner.emit_signal("isDowned")

func _process(delta):
	pass

func update(delta):
	pass

func exit():
	pass
