extends Node
class_name BaseSpellCard


@onready var card = self
@export var spellTag:String
signal spellSelected

func init():
	pass

func onClicking(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed :
		print("Clicked on card")
#		var chosenSpell:SummonerSpell = RunManager.allSpells[spellTag]
		RunManager.addNewSpell(spellTag)
		emit_signal("spellSelected")

func onHover():
	card.scale *= 1.10

func onMouseExit():
	card.scale /= 1.10
