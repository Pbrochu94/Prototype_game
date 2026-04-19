extends State
class_name Attacking


func _onready():
	pass

func enter():
	var attackName:String = owner.attackSelected.attackName
	owner.anim.play(attackName)
	owner.target.hp -= owner.attackSelected.damage

func update(delta):
	pass

func exit():
	print("Enemy hp after hit: ", owner.target.hp)
