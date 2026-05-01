extends State
class_name IdleCannonDruid


func _onready():
	pass

func enter():
	owner.anim.play("idle")
	if owner.is_in_group("enemy"):
		owner.orientSprite(owner.facingPlayer)

func update(delta):
	pass

func exit():
	pass

