extends BasePartyManager
class_name EnemyPartyManager

@onready var encounter : CombatEncounterData = preload("res://utils/Data/EncounterData/Combat/CombatEncounterLV1Resource.tres")
func _ready():
	super()
	partyFaction = Enum.Faction.ENEMY
#	loadRandomTeam()
	print(encounter)
	loadTeam()

func loadTeam():
	var generatedEnemies = encounter.generateEncounter()
	for enemyData in generatedEnemies:
		var enemy = enemyData.scene.instantiate()
		add_child(enemy)
