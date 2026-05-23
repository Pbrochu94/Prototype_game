extends EncounterData
class_name CombatEncounterData

var enemies : Array[UnitData] = [
	preload("res://Invocations/Samurai/SamuraiData.tres"),
	preload("res://Invocations/Archer/ArcherData.tres"),
	preload("res://Invocations/CannonDruid/CannonDruidData.tres"),
	preload("res://Invocations/BlasterDruid/BlasterDruidData.tres")
]

@export var encounterBudget : int 
var hasBudget:bool = true 
#@export var rewards : Array[RewardData]
#@export var isElite : bool
#@export var isMiniBoss : bool
#@export var isFinalBoss : bool


func generateEncounter():
	var remainingBudget = encounterBudget
	var selectedEnemies: Array[UnitData] = []
	while remainingBudget > 0:
		var validEnemies = enemies.filter(
			func(enemy):
				return enemy.cost <= remainingBudget)
		if validEnemies.is_empty():
			break
		var randomEnemy = validEnemies.pick_random()
		selectedEnemies.append(randomEnemy)
		remainingBudget -= randomEnemy.cost
	return selectedEnemies
