extends State
class_name DownedState

func _onready():
	pass

func enter():
	owner.anim.play("downed")
	owner.isDead = true
	owner.emit_signal("isDowned", owner)

func update(delta):
	pass

func exit():
	pass
