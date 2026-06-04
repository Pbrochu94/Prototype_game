extends BaseNonCombatEncounter
class_name SpellSelectionEncounter
@onready var cardAnchors = [
	$SpellCardAnchor1,
	$SpellCardAnchor2,
	$SpellCardAnchor3,
	$SpellCardAnchor4,
	$SpellCardAnchor5
]


func summonerIntroCompleted():
	super()
	generateRandomSpells(RunManager.nmbOfSpellChoice)
	#spell cards appears

func generateRandomSpells(nmbOfSpells:int):
	var cardCounter:int
	print("generating random cards")
	var spells:Array
	for i in range(nmbOfSpells):
		var spellData = RunManager.allSpells.values().pick_random()
		var spellCard = spellData["scene"].instantiate()
		spells.append(spellCard)
		add_child(spellCard)
		spellCard.global_position = cardAnchors[cardCounter].global_position
		cardCounter += 1
