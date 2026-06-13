extends State
class_name AttackingState

#VARIABLES


func _onready():
	pass

func enter():
	owner.anim.play(owner.attackSelected.attackName)
	owner.z_index = 2


func update(delta):
	pass

func exit():
	owner.z_index = 1


