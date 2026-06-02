extends Resource
class_name PlayerPartyData


@export var lightShards:int
var hasBudget:bool = true 

#func generateParty():
#	var remainingBudget = lightShards
#	var selectedUnits: Array[UnitData] = []
#	while remainingBudget > 0:
#		var validUnits = UnitDB.firstWorldUnits.filter(
#			func(invocation):
#				return invocation.summoneCost <= remainingBudget)
#		if validUnits.is_empty():
#			break
#		#PICK RANDOM
##		var unitPicked = validUnits.pick_random()
#		#PICK SPECIFIC
#		var unitPicked = validUnits[1]
#		selectedUnits.append(unitPicked)
#		remainingBudget -= unitPicked.summonCost
#	return selectedUnits
