extends Node2D

@onready var buttons = [
	$VBoxContainer/CombatNode1,
	$VBoxContainer/CombatNode2,
	$VBoxContainer/CombatNode3,
	$VBoxContainer/CombatNode4
]

func _ready():
	print(getPlayerInfo())
	for i in buttons.size():
		buttons[i].disabled = !RunManager.nodes[i]["unlocked"]

func node1Pressed():
	RunManager.currentNode = 0
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 1")


func node2Pressed():
	RunManager.currentNode = 1
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 2")


func node3Pressed():
	RunManager.currentNode = 2
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 3")


func node4Pressed():
	RunManager.currentNode = 3
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 4")

func node5Pressed():
	RunManager.currentNode = 4
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING BOSS SCENE")

func getPlayerInfo():
	var playerInfo: Dictionary = {
		"light shards": RunManager.currentLightShard,
		"xp": RunManager.currentXp
	}
	return playerInfo
