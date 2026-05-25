extends BasePartyManager
class_name EnemyPartyManager

@onready var encounter : CombatEncounterData = preload("res://utils/Data/EncounterData/Combat/LV1/CombatEncounterLV1Data.tres")


func init():
	super()
	partyFaction = Enum.Faction.ENEMY
	loadTeam()
	addEnemyToParty()
	placeEnemies()

func loadTeam():
	var generatedEnemies = encounter.generateEncounter()
	for enemyData in generatedEnemies:
		var enemy = enemyData.scene.instantiate()
		party.append(enemy)

func addEnemyToParty():
	for i in range(party.size()):
		var enemy = party[i]
		var numberNameTag = str(i+1)
		enemy.characterName +=  " enemy " + numberNameTag 
		aliveCount += 1
		enemy.currentCombatScene = currentCombatScene
		addUnitConnections(enemy)
	currentlyAliveCharacters = party

func placeEnemies():
	for i in range(party.size()):
		var enemy = party[i]
		enemy.faction = Enum.Faction.ENEMY
		currentCombatScene.add_child(enemy)
		if i < currentCombatScene.enemyAnchors.size():
			enemy.global_position = currentCombatScene.enemyAnchors[i].global_position
			enemy.startingPosition = currentCombatScene.enemyAnchors[i].global_position
