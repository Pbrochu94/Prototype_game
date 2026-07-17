extends BasePartyManager
#class_name EnemyPartyManager

var encounter : EncounterData 


func init():
	super()
	partyFaction = Enum.Faction.ENEMY
	currentCombatScene = get_tree().get_first_node_in_group("combat scene")
	encounter = currentCombatScene.encounterData
	loadTeam()
	addEnemyToParty()
	addUnitToPartyInstances()
	placeUnit()

func loadTeam():
	if currentCombatScene.encounterData.isScripted:
#		var enemies:Array[UnitInstance]
		for unit in currentCombatScene.encounterData.scriptedUnits:
			var unitInstance = UnitDB.createUnitInstance(unit.characterTag)
			party.append(unitInstance)
	else:
		var generatedEnemies = encounter.generateEncounter(currentCombatScene.encounterData.encounterType)
		for enemyData in generatedEnemies:
			party.append(enemyData)

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
			var unitScene = unit.definition.scene.instantiate()
			unit.scene = unitScene
			#HERE TO CORRECT AFTER SEPARATING STATS
			unitScene.stats = unit
			unitScene.definition = unit.definition
			unitScene.faction = Enum.Faction.ENEMY
			partyInstances.append(unitScene)

func placeUnit():
	for instance in partyInstances:
		instance.currentCombatScene = currentCombatScene
		addUnitConnections(instance)
	for i in range(partyInstances.size()):
		currentCombatScene.add_child(partyInstances[i])
		if i < currentCombatScene.enemyAnchors.size():
			partyInstances[i].global_position = currentCombatScene.enemyAnchors[i].global_position
			partyInstances[i].startingPosition = currentCombatScene.enemyAnchors[i].global_position

