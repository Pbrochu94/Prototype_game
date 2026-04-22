extends State
class_name Attacking

var attack:Attack
func _onready():
	pass

func enter():
	attack = owner.attackSelected
	var attackName:String = attack.attackName
	owner.anim.play(attackName)
	owner.target.receiveDamage(attack)

func update(delta):
	pass

func exit():
	pass
