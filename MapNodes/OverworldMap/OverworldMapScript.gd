extends Node2D

@onready var buttons = [
	$HBoxContainer/CombatNode1,
	$HBoxContainer/CombatNode2,
	$HBoxContainer/CombatNode3,
	$HBoxContainer/CombatNode4,
	$HBoxContainer/CombatNode5
]

func _ready():
	print(RunManager.getPlayerInfo())
	for i in buttons.size():
		buttons[i].disabled = !RunManager.nodes[i]["unlocked"]

func node1Pressed():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 0
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 1")


func node2Pressed():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 1
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/SpellEncounterScene.tscn")
	print("ENTERING SPELL SCENE 2")


func node3Pressed():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 2
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 3")


func node4Pressed():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 3
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 4")

func node5Pressed():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 4
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING BOSS SCENE")


