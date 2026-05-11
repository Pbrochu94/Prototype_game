extends State
class_name AttackingState

#VARIABLES
@onready var player = owner
var atkStat:int
var attack:Ability
var element:String
var target:Node2D


enum StatusEffect {
	BUFF,
	DEBUFF,
	POISON,
	BURN,
	FREEZE
}

func _onready():
	pass

func enter():
	target = owner.target
	attack = owner.attackSelected
	element = attack.element
	match attack.type:
		Enum.AbilityType.ATTACK:
			atkStat = owner.stats["atk"]
			var damageOutput:int = atkStat + attack.damage
			var attackName:String = attack.attackName
			owner.anim.play(attackName)
			print("Character: ", owner, "attacks :", target, " for ", damageOutput, " ", attack.element)
			target.receiveDamage(damageOutput, element)
		Enum.AbilityType.EFFECT:
			target.applyEffect(attack)
			print(attack.attackName)
			player.anim.play(attack.attackName)


func update(delta):
	pass

func exit():
	pass


