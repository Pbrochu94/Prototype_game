extends State
class_name AttackingState

#VARIABLES
@onready var player = owner
var atkStat:int
var attack:Ability
var element:String
var target:Node2D

#ENUMS
enum AbilityType{
	ATTACK,
	HEAL,
	SELFHEAL,
	BUFF,
	DEBUFF
}

func _onready():
	pass

func enter():
	target = owner.target
	attack = owner.attackSelected
	element = attack.element
	match attack.type:
		AbilityType.ATTACK:
			atkStat = owner.atk
			var damageOutput:int = atkStat + attack.damage
			var attackName:String = attack.attackName
			owner.anim.play(attackName)
			print("Character: ", owner, "attacks :", target, " for ", damageOutput, " ", attack.element)
			target.receiveDamage(damageOutput, element)
		AbilityType.DEBUFF:
			print(attack.attackName)
			player.anim.play(attack.attackName)
			print("Target: ", target.characterName, " deffense is ", target.deff)
			target.deff -= convertPourcentage(target.deff,attack.deffDebuff)
			print("Target: ", target.characterName, " after debuff ", target.deff)


func update(delta):
	pass

func exit():
	pass

func convertPourcentage(baseStat:int, amount:int):
	var amountInPercent:float = float(amount)/100
	return baseStat * amountInPercent
