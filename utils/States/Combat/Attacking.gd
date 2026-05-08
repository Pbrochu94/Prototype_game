extends State
class_name AttackingState

var atkStat:int
var attack:Ability
var element:String

func _onready():
	pass

func enter():
	atkStat = owner.atk
	attack = owner.attackSelected
	element = attack.element
	var damageOutput:int = atkStat + attack.damage
	var attackName:String = attack.attackName
	owner.anim.play(attackName)
	print("Character: ", owner, "attacks :", owner.target, " for ", damageOutput, " ", attack.element)
	owner.target.receiveDamage(damageOutput, element)

func update(delta):
	pass

func exit():
	pass
