extends Node2D

@onready var buttons = [
	$HBoxContainer/CombatNode1,
	$HBoxContainer/CombatNode2,
	$HBoxContainer/VBoxContainer/SpellEncounter1,
	$HBoxContainer/VBoxContainer/CombatNode3,
	$HBoxContainer/CombatNode4,
	$HBoxContainer/CombatNode5
]

func _ready():
	print(RunManager.getPlayerInfo())
	for i in buttons.size():
		buttons[i].disabled = !RunManager.nodes[i]["unlocked"]

func combatNode1Clicked():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 0
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 1")


func combatNode2Clicked():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 1
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 2")


func spellNode1Clicked():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 2
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/SpellEncounterScene.tscn")
	print("ENTERING SPELL SCENE 3")

func combatNode3Clicked():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 3
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 2")

func combatNode4Clicked():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 4
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING COMBAT SCENE 4")

func combatNode5Clicked():
	RunManager.createSummonerInstance()
	RunManager.currentNode = 5
	RunManager.currentEncounterData = RunManager.nodes[RunManager.currentNode]["encounter data"]
	get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
	print("ENTERING BOSS SCENE")


