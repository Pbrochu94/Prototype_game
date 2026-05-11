extends State
class_name IdleState


func _onready():
	pass

func enter():
	owner.anim.play("idle")
	if owner.faction == Enum.Faction.PLAYER:
		owner.orientSprite(1)
	else:
		owner.orientSprite(-1)

func update(delta):
	pass

func exit():
	pass

