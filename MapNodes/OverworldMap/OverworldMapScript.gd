extends Node2D

@onready var buttons = [
	$VBoxContainer/CombatNode1,
	$VBoxContainer/CombatNode2,
	$VBoxContainer/CombatNode3,
	$VBoxContainer/CombatNode4
]

func _ready():
	for i in buttons.size():
		buttons[i].disabled = !RunManager.nodes[i]["unlocked"]

func node1Pressed():
	RunManager.currentNode = 0
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
