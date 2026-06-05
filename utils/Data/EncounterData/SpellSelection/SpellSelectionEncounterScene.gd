extends BaseNonCombatEncounter
class_name SpellSelectionEncounter
@onready var cardAnchors = [
	$SpellCardAnchor1,
	$SpellCardAnchor2,
	$SpellCardAnchor3,
	$SpellCardAnchor4,
	$SpellCardAnchor5
]
var cardScenes:Array

func summonerIntroCompleted():
	super()
	generateRandomSpells(RunManager.nmbOfSpellChoice)
	connectSignals()
	#spell cards appears
func connectSignals():
	super()

func generateRandomSpells(nmbOfSpells:int):
	var cardCounter:int
	print("generating random cards")
	var availableSpells:Array
	for spell in RunManager.allSpells:
		availableSpells.append(spell)
	for i in range(nmbOfSpells):
		var spellData = availableSpells.pick_random()
		availableSpells.erase(spellData)
		var cardInstance = RunManager.allSpells[spellData]["scene"].instantiate()
		add_child(cardInstance)
		cardScenes.append(cardInstance)
		cardInstance.global_position = cardAnchors[cardCounter].global_position
		cardCounter += 1
