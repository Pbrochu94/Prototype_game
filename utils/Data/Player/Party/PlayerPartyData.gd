extends Resource
class_name PlayerPartyData

@export var invocations : Array[UnitData] = [
	preload("res://Invocations/Samurai/SamuraiData.tres"),
	preload("res://Invocations/Archer/ArcherData.tres"),
	preload("res://Invocations/CannonDruid/CannonDruidData.tres"),
	preload("res://Invocations/BlasterDruid/BlasterDruidData.tres")
]

@export var lightShards:int
var hasBudget:bool = true 

func generateEncounter():
	var remainingBudget = lightShards
	var selectedEnemies: Array[UnitData] = []
	while remainingBudget > 0:
		var validUnit = invocations.filter(
			func(invocation):
				return invocation.cost <= remainingBudget)
		if validUnit.is_empty():
			break
		var randomEnemy = validUnit.pick_random()
		selectedEnemies.append(randomEnemy)
		remainingBudget -= randomEnemy.cost
	return selectedEnemies
