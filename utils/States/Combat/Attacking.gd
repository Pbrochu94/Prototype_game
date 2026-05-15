extends State
class_name AttackingState

#VARIABLES


func _onready():
	pass

func enter():
	owner.anim.play(owner.attackSelected.attackName)


func update(delta):
	pass

func exit():
	pass


