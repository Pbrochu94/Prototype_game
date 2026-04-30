extends State
class_name AttackingBlasterDruid

var attack:Attack
var element:String

func _onready():
	pass

func enter():
	attack = owner.attackSelected
	element = attack.element
	var attackName:String = attack.attackName
	owner.anim.play(attackName)
	owner.target.receiveDamage(attack, element)

func update(delta):
	pass

func exit():
	pass
