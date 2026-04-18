extends State
class_name Attacking


func _onready():
	pass

func enter():
	owner.anim.play("attack")
	owner.target.hp -= owner.attackSelected.damage
#	owner.anim.scale.x = 1

func update(delta):
	pass

func exit():
	print("Enemy hp after hit: ", owner.target.hp)
