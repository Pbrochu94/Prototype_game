extends BasePartyManager

@onready var encounter : PlayerPartyData = preload("res://utils/Data/Player/Party/PlayerPartyData.tres")

func init():
	super()
	partyFaction = Enum.Faction.PLAYER
	loadTeam()
	addUnitToParty()


func loadTeam():
	var generatedUnits = encounter.generateEncounter()
	for unitData in generatedUnits:
		var unit = unitData.scene.instantiate()
		party.append(unit)

func addUnitToParty():
	for i in range(party.size()):
		var unit = party[i]
		aliveCount += 1
		unit.currentCombatScene = currentCombatScene
		addUnitConnections(unit)
	currentlyAliveCharacters = party

func placeUnit():
	for i in range(party.size()):
		var unit = party[i]
		unit.faction = Enum.Faction.PLAYER
		currentCombatScene.add_child(unit)
		if i < currentCombatScene.enemyAnchors.size():
			unit.global_position = currentCombatScene.playerAnchors[i].global_position
			unit.startingPosition = currentCombatScene.playerAnchors[i].global_position
