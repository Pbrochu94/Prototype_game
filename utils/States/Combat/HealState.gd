extends State
class_name HealState

var attackSelected:Ability
var characterMaxHp:int
var characterCurrentHp:int
var target:Node2D

func enter():
	attackSelected = owner.attackSelected
	if attackSelected.focusType == Enum.FocusType.SELF:
		target = owner
		target.anim.play(attackSelected.attackName.to_lower())
	else:
		target = owner.target
		target.anim.play("heal")
	characterMaxHp = target.stats["maxHp"]
	characterCurrentHp = target.stats["currentHp"]
	owner.anim.play(attackSelected.attackName.to_lower())
	characterCurrentHp += attackSelected.healAmount
	healStopsToMaxHp()

func update(delta):
	pass

func exit():
	print("Hp BEFORE heal: ",owner.stats["currentHp"])
	owner.stats["currentHp"] = characterCurrentHp
	print("Hp AFTER heal: ",owner.stats["currentHp"])

func healStopsToMaxHp():
	if characterCurrentHp > characterMaxHp:
		characterCurrentHp = characterMaxHp

