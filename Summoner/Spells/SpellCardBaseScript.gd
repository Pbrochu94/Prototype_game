extends Node
class_name BaseSpellCard


@onready var card = self
@export var spellTag:String

func init():
	pass

func onClicking(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed :
		print("Clicked on card")
		var chosenSpell:SummonerSpell = RunManager.allSpells[spellTag]
		RunManager.summoner.sceneInstance.addNewSpell(chosenSpell)

func onHover():
	card.scale = Vector2(1.1, 1.1)

func onMouseExit():
	card.scale = Vector2(1, 1)
