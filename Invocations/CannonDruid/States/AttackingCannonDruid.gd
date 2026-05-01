extends State
class_name AttackingCannonDruid

var attack:Attack
var element:String

func _onready():
	pass

func enter():
	attack = owner.attackSelected
	element = attack.element
	var attackName:String = attack.attackName
	owner.anim.play(attackName)
	print("Character: ", owner, "attacks :", owner.target, " for ", attack.damage, " ", attack.element)
	owner.target.receiveDamage(attack, element)

func update(delta):
	pass

func exit():
	pass
