extends State
class_name DownedArcher

func _onready():
	pass

func enter():
	owner.anim.play("downed")
	owner.isDead = true
	owner.emit_signal("isDowned", owner)

func _process(delta):
	pass

func update(delta):
	pass

func exit():
	pass
