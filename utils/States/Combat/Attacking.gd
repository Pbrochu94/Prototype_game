extends State
class_name AttackingState

#VARIABLES
@onready var unit = owner
var atkStat:int
var attack:Ability
var element:String
var target:Node2D

func _onready():
	pass

func enter():
	target = owner.target
	attack = owner.attackSelected
	element = attack.element
	var attackName:String = attack.attackName
	match attack.type:
		#IF ATTACK
		Enum.AbilityType.ATTACK:
			var atkStat = owner.stats["atk"]
			var damageOutput:int = atkStat + attack.damage
			owner.anim.play(attackName)
			target.receiveDamage(owner,attack,damageOutput)
			#IF ATTACK HAS AOE SPLASH DAMAGE
			if attack.focusType == Enum.FocusType.ENEMY_AOE:
				print("SPLASH DAMAGE")
				for ally in target.partyManager.currentlyAliveCharacters:
					if ally != target:
						var splashDamage = attack.splashDamage + atkStat
						ally.receiveDamage(owner,attack,splashDamage)
						print(ally.characterName, " received ", attack.splashDamage, " of splash damage")
						print(ally, " stats after AOE: ", ally.getUnitInfo())
		Enum.AbilityType.EFFECT:
			target.applyEffect(attack)
			print(attack.attackName)
			unit.anim.play(attack.attackName)


func update(delta):
	pass

func exit():
	pass


