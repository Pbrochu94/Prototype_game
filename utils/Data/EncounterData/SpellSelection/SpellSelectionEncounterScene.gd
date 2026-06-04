extends BaseNonCombatEncounter
class_name SpellSelectionEncounter

func summonerIntroCompleted():
	super()
	generateRandomSpells(RunManager.spellSlot)
	#spell cards appears

func generateRandomSpells(nmbOfSpells:int):
	print("generating random cards")
	var spell= RunManager.allSpells.values().pick_random()
	add_child(spell.cardScene.instantiate())
