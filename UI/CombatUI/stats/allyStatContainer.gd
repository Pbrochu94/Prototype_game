extends Control


@onready var partyContainer = self
var party:Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	for character in get_tree().get_nodes_in_group("character"):
		party.append(character)
	populateBox()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populateBox():
	for char in party:
		var ui = preload("res://UI/CombatUI/stats/AllyStat.tscn").instantiate()
		ui.scale = Vector2(1,1)
		ui.position = Vector2.ZERO
		partyContainer.add_child(ui)
		ui.setup(char)
