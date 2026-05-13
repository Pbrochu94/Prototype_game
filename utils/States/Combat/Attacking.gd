extends State
class_name AttackingState

#VARIABLES
@onready var unit = owner
var atkStat:int
var attackSelected:Ability
var attackName:String
var attacksDict:Dictionary
var element:String
var target:Node2D


func _onready():
	pass

func enter():
	target = owner.target
	attackSelected = owner.attackSelected
	attackName = attackSelected.attackName
	attacksDict = unit.attacks
	element = attackSelected.element
	var attackName:String = attackSelected.attackName
	if attacksDict[attackName]["cooldown"] > 0:
		var cooldown:int = attacksDict[attackName]["cooldown"]
		print(attackName, " goes on a ", cooldown, " turn cooldown")
		attacksDict[attackName]["currentCooldown"] = cooldown
		attacksDict[attackName]["justUsed"] = true
		print(attacksDict[attackName])
	match attackSelected.type:
		#IF ATTACK
		Enum.AbilityType.ATTACK:
			var atkStat = owner.stats["atk"]
			var damageOutput:int = atkStat + attackSelected.damage
			owner.anim.play(attackName)
			target.receiveDamage(owner,attackSelected,damageOutput)
			#IF ATTACK HAS AOE SPLASH DAMAGE
			if attackSelected.focusType == Enum.FocusType.ENEMY_AOE:
				print("SPLASH DAMAGE")
				for ally in target.partyManager.currentlyAliveCharacters:
					if ally != target:
						var splashDamage = attackSelected.splashDamage + atkStat
						ally.receiveDamage(owner,attackSelected,splashDamage)
						print(ally.characterName, " received ", attackSelected.splashDamage, " of splash damage")
						print(ally, " stats after AOE: ", ally.getUnitInfo())
		Enum.AbilityType.EFFECT:
			target.applyEffect(attackSelected)
			print(attackSelected.attackName)
			unit.anim.play(attackSelected.attackName)


func update(delta):
	pass

func exit():
	pass


