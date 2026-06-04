extends BaseNonCombatEncounter
class_name SpellSelectionEncounter

func summonerIntroCompleted():
	super()
	generateRandomSpells(RunManager.spellSlot)
	#spell cards appears

func generateRandomSpells(nmbOfSpells:int):
	print("generating random cards")
	var spells:Array
	for i in range(nmbOfSpells):
		var spellData = RunManager.allSpells.values().pick_random()
		var spellCard = spellData["scene"].instantiate()
		spells.append(spellCard)
		add_child(spellCard)
		print(spellCard.global_position)
		print(RunManager.summoner.sceneInstance.global_position)
