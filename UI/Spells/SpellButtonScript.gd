extends Node
signal summonerSpellSelected(spell:SummonerSpell)
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
@onready var targetManager = get_tree().get_first_node_in_group("target manager")

func _ready():
	summonerSpellSelected.connect(turnManager.onSpellSelected)

func onHovered():
	pass


func onMouseExit():
	pass # Replace with function body.


func onClick():
	targetManager.cancelSelection()
	print("3",RunManager.learnedSpells[self.text])
	emit_signal("summonerSpellSelected", RunManager.learnedSpells[self.text])
