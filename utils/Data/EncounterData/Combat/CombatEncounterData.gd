extends EncounterData
class_name CombatEncounterData


@export var encounterBudget : int 
@export var name : String 
@export var lightShardReward:int
@export var xpReward:int
@export var itemReward:int
@export var rareItemChance:float

var hasBudget:bool = true 
#@export var rewards : Array[RewardData]
#@export var isElite : bool
#@export var isMiniBoss : bool
#@export var isFinalBoss : bool


func generateEncounter(type:Enum.EncounterType):
	match type:
		Enum.EncounterType.COMBAT:
			var remainingBudget = encounterBudget
			var selectedEnemies: Array[UnitDefinition] = []
			while remainingBudget > 0:
				var validEnemies = UnitDB.firstWorldUnits.values().filter(
					func(enemy):
						return enemy.summonCost <= remainingBudget)
				if validEnemies.is_empty():
					break
				#PICK RANDOM
				var unitPicked = validEnemies.pick_random().duplicate(true)
				#PICK SPECIFIC
		#		var unitPicked = validEnemies[1]
				selectedEnemies.append(unitPicked)
				remainingBudget -= unitPicked.summonCost
			return selectedEnemies
		Enum.EncounterType.ELITE:
			pass
		Enum.EncounterType.MINI_BOSS:
			var remainingBudget = encounterBudget
			var selectedEnemies: Array[UnitDefinition] = []
			while remainingBudget > 0:
				var validEnemies = UnitDB.firstWorldMiniBosses.values().filter(
					func(enemy):
						return enemy.summonCost <= remainingBudget)
				if validEnemies.is_empty():
					break
				#PICK RANDOM
				var unitPicked = validEnemies.pick_random().duplicate(true)
				#PICK SPECIFIC
		#		var unitPicked = validEnemies[1]
				selectedEnemies.append(unitPicked)
				remainingBudget -= unitPicked.summonCost
			return selectedEnemies
		Enum.EncounterType.BOSS:
			pass
