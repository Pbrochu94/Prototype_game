extends Resource
class_name PlayerPartyData

const invocations : Array[UnitData] = [
	preload("res://Invocations/Samurai/SamuraiData.tres"),
	preload("res://Invocations/Archer/ArcherData.tres"),
	preload("res://Invocations/CannonDruid/CannonDruidData.tres"),
	preload("res://Invocations/BlasterDruid/BlasterDruidData.tres")
]

@export var lightShards:int
var hasBudget:bool = true 

func generateParty():
	var remainingBudget = lightShards
	var selectedUnits: Array[UnitData] = []
	while remainingBudget > 0:
		var validUnits = invocations.filter(
			func(invocation):
				return invocation.cost <= remainingBudget)
		if validUnits.is_empty():
			break
		#PICK RANDOM
#		var unitPicked = validUnits.pick_random()
		#PICK SPECIFIC
		var unitPicked = validUnits[3]
		selectedUnits.append(unitPicked)
		remainingBudget -= unitPicked.cost
	return selectedUnits
