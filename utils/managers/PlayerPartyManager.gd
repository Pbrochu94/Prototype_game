extends BasePartyManager

@onready var playerParty : PlayerPartyData = preload("res://utils/Data/Player/Party/PlayerPartyData.tres")

func init():
	super()
	partyFaction = Enum.Faction.PLAYER
	addUnitToParty()
	addUnitToPartyInstances()


func addUnitToParty():
	for unit in RunManager.currentParty:
		party.append(unit)
	for i in range(party.size()):
		var unit = party[i]
		aliveCount += 1
		var numberNameTag = str(i+1)
		var unitScene = unit.scene.instantiate()
		unit.characterName +=  " player " + numberNameTag 
		unitScene.faction = Enum.Faction.PLAYER
	currentlyAliveCharacters = partyInstances

func addUnitToPartyInstances():
		for i in range(party.size()):
			var unit = party[i]
			var unitScene = unit.scene.instantiate()
			unit.sceneInstance = unitScene
			unitScene.stats = unit
			partyInstances.append(unitScene)

func placeUnit():
	for instance in partyInstances:
		instance.currentCombatScene = currentCombatScene
		addUnitConnections(instance)
	for i in range(partyInstances.size()):
		currentCombatScene.add_child(partyInstances[i])
		if i < currentCombatScene.playerAnchors.size():
			partyInstances[i].global_position = currentCombatScene.playerAnchors[i].global_position
			partyInstances[i].startingPosition = currentCombatScene.playerAnchors[i].global_position
