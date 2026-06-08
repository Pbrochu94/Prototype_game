extends Node
signal summonerSpellSelected(spell:SummonerSpell)
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
@onready var targetManager = get_tree().get_first_node_in_group("target manager")
var spellLinked

func init():
	summonerSpellSelected.connect(turnManager.onSpellSelected)
	spellLinked = RunManager.learnedSpells[self.text]

func onHovered():
	pass


func onMouseExit():
	pass # Replace with function body.


func onClick():
	targetManager.cancelSelection()
	if spellLinked.currentCooldown > 0:
		print("Spell ", self.text, " is on cooldown for ", spellLinked.currentCooldown, " turn.")
		return
	print("Selected summoner spell: ", self.text)
	emit_signal("summonerSpellSelected", RunManager.learnedSpells[self.text])
