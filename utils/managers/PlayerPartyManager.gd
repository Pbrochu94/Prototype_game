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
		print(unit)
		aliveCount += 1
		var numberNameTag = str(i+1)
		var unitScene = unit.definition.scene.instantiate()
		unit.characterName = unit.definition.characterName
		unit.characterName +=  " player " + numberNameTag 
		unitScene.faction = Enum.Faction.PLAYER
	currentlyAliveCharacters = party




