extends State
class_name IdleBlasterDruid


func _onready():
	pass

func enter():
	owner.scale.x = 1
	owner.anim.play("idle")
	if owner.is_in_group("enemy"):
		owner.orientSprite(owner.facingPlayer)

func update(delta):
	pass

func exit():
	pass

