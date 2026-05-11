extends BasePartyManager


func _ready():
	super()
	partyFaction = Enum.Faction.PLAYER
	loadRandomTeam()


