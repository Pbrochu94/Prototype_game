extends BasePartyManager

@onready var playerParty : PlayerPartyData = preload("res://utils/Data/Player/Party/PlayerPartyData.tres")

func init():
	super()
	partyFaction = Enum.Faction.PLAYER
	loadTeam()
	addUnitToParty()


#func loadFirstTeam():
#	for unitData in RunManager.currentParty:
#		var unitScene = unitData.scene.instantiate()
#		unitScene.stats = unitScene.stats.duplicate(true)
#		party.append(unitScene)

#func loadTeam():
#	for unitData in RunManager.currentParty:
#		var unit = unitData.scene.instantiate()
#		unit.stats = unitData.stats
#		party.append(unit)

func loadTeam():
	for unit in RunManager.currentParty:
		party.append(unit.scene.instantiate())
func addUnitToParty():
	for i in range(party.size()):
		var unit = party[i]
		var numberNameTag = str(i+1)
		unit.stats.characterName +=  " player " + numberNameTag 
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
