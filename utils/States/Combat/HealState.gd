extends State
class_name HealState

var attackSelected:Ability
var characterMaxHp:int
var characterCurrentHp:int
var target:Node2D
var attackName:String
var attacksDict:Dictionary

func enter():
	attackSelected = owner.attackSelected
	attackName = attackSelected.attackName
	attacksDict = owner.attacks
	target = owner.target
	if attacksDict[attackName]["cooldown"] >  0:
		var cooldown:int = attacksDict[attackName]["cooldown"]
		print(attackName, " goes on a ", cooldown, " turn cooldown")
		attacksDict[attackName]["currentCooldown"] = cooldown
		attacksDict[attackName]["justUsed"] = true
		print(attacksDict[attackName])
	if attackSelected.focusType == Enum.FocusType.SELF:
		target.anim.play(attackSelected.attackName.to_lower())
	else:
		target = owner.target
		target.anim.play("heal")
	characterMaxHp = target.stats["maxHp"]
	characterCurrentHp = target.statsv2.currentHp
	owner.anim.play(attackSelected.attackName.to_lower())
	characterCurrentHp += attackSelected.effectRes.amount
	healStopsToMaxHp()

func update(delta):
	pass

func exit():
	print("Hp BEFORE heal: ",owner.statsv2.currentHp)
	owner.statsv2.currentHp = characterCurrentHp
	print("Hp AFTER heal: ",owner.statsv2.currentHp)

func healStopsToMaxHp():
	if characterCurrentHp > characterMaxHp:
		characterCurrentHp = characterMaxHp

