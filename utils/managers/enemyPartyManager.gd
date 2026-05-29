extends BasePartyManager
#class_name EnemyPartyManager

var encounter : CombatEncounterData 


func init():
	super()
	partyFaction = Enum.Faction.ENEMY
	currentCombatScene = get_tree().get_first_node_in_group("combat scene")
	encounter = currentCombatScene.combatEncounterData
	loadTeam()
	addEnemyToParty()
	addUnitToPartyInstances()
	placeUnit()

func loadTeam():
	var generatedEnemies = encounter.generateEncounter()
	print(generatedEnemies)
	for enemyData in generatedEnemies:
#		var enemy = enemyData.scene.instantiate()
#		enemy.stats = enemy.stats.duplicate(true)
		party.append(enemyData)
	print("AAAHHH", party)

func addEnemyToParty():
	for i in range(party.size()):
		var enemy = party[i]
		var numberNameTag = str(i+1)
		enemy.characterName +=  " enemy " + numberNameTag 
		aliveCount += 1
	currentlyAliveCharacters = partyInstances

func addUnitToPartyInstances():
		for i in range(party.size()):
			var unit = party[i]
			var unitScene = unit.scene.instantiate()
			unitScene.stats = unit
			unitScene.faction = Enum.Faction.ENEMY
			partyInstances.append(unitScene)

func placeUnit():
	for instance in partyInstances:
		instance.currentCombatScene = currentCombatScene
		addUnitConnections(instance)
	for i in range(partyInstances.size()):
#		var unitData = party[i]
#		var unitScene = unitData.scene.instantiate()
#		unitScene.currentCombatScene = currentCombatScene
#		addUnitConnections(unitScene)
#		print(unitScene)
#		unitScene.stats = unitData
##		unitScene.faction = Enum.Faction.PLAYER
		currentCombatScene.add_child(partyInstances[i])
		if i < currentCombatScene.enemyAnchors.size():
			partyInstances[i].global_position = currentCombatScene.enemyAnchors[i].global_position
			partyInstances[i].startingPosition = currentCombatScene.enemyAnchors[i].global_position

