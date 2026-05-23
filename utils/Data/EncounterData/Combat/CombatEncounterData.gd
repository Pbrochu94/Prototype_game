extends EncounterData
class_name CombatEncounterData

@export var enemies : Array[EnemyData] = [
	preload("res://Invocations/Samurai/SamuraiData.tres")
]

@export var encounterBudget : int 
var hasBudget:bool = true 
#@export var rewards : Array[RewardData]
#@export var isElite : bool
#@export var isMiniBoss : bool
#@export var isFinalBoss : bool


#func _ready():
#	encounterType = Enum.EncounterType.COMBAT
#	var generatedEnemies = generateEncounter()
#	for enemyData in generatedEnemies:
#		var enemy = enemyData.scene.instantiate()


func generateEncounter():
	var remainingBudget = encounterBudget
	var selectedEnemies: Array[EnemyData] = []
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
