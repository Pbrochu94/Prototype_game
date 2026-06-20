extends EncounterData
class_name CombatEncounterData


@export var encounterBudget : int 
@export var name : String 
@export var lightShardReward:int
@export var xpReward:int
@export var itemReward:int
@export var rareItemChance:float
@export var baseScene:PackedScene
@export var sceneInstance:CombatEncounter


var hasBudget:bool = true 
#@export var rewards : Array[RewardData]
#@export var isElite : bool
#@export var isMiniBoss : bool
#@export var isFinalBoss : bool


func generateEncounter(type:Enum.EncounterType):
	match type:
		Enum.EncounterType.COMBAT:
			var remainingBudget = encounterBudget
			var selectedEnemies: Array[UnitInstance] = []
			while remainingBudget > 0:
				var validEnemies = UnitDB.units.values().filter(
					func(enemy):
						return enemy.summonCost <= remainingBudget and enemy.unitRank == Enum.UnitRank.BASE
				)
				if validEnemies.is_empty():
					break
				#PICK RANDOM
				var unitPickedTag = validEnemies.pick_random().characterTag
				var unitPicked = UnitDB.createUnitInstance(unitPickedTag)
				#PICK SPECIFIC
		#		var unitPicked = validEnemies[1]
				selectedEnemies.append(unitPicked)
				remainingBudget -= unitPicked.definition.summonCost
			return selectedEnemies
		Enum.EncounterType.ELITE:
			pass
		Enum.EncounterType.MINI_BOSS:
			var remainingBudget = encounterBudget
			var selectedEnemies: Array[UnitInstance] = []
			while remainingBudget > 0:
				var validEnemies = UnitDB.units.values().filter(
					func(enemy):
						return enemy.summonCost <= remainingBudget and enemy.unitRank == Enum.UnitRank.MINI_BOSS
				)
				if validEnemies.is_empty():
					break
				#PICK RANDOM
				var unitPickedTag = validEnemies.pick_random().characterTag
				var unitPicked = UnitDB.createUnitInstance(unitPickedTag)
				#PICK SPECIFIC
		#		var unitPicked = validEnemies[1]
				selectedEnemies.append(unitPicked)
				remainingBudget -= unitPicked.definition.summonCost
			return selectedEnemies
		Enum.EncounterType.BOSS:
			pass
