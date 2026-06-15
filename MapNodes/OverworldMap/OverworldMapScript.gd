extends Node2D

@onready var buttons = [
	$HBoxContainer/CombatNode1,
	$HBoxContainer/CombatNode2,
	$HBoxContainer/VBoxContainer/SpellEncounter1,
	$HBoxContainer/VBoxContainer/CombatNode3,
	$HBoxContainer/CombatNode4,
	$HBoxContainer/HealNode1,
	$HBoxContainer/CombatNode5
]

func _ready():
	print(RunManager.getPlayerInfo())
	for i in buttons.size():
		buttons[i].disabled = !RunManager.nodes[i]["unlocked"]

func combatNode1Clicked():
	enterNode(0)


func combatNode2Clicked():
	enterNode(1)


func spellNode1Clicked():
	enterNode(2)

func combatNode3Clicked():
	enterNode(3)

func combatNode4Clicked():
	enterNode(4)

func healNode1Clicked():
	enterNode(5)

func combatNode5Clicked():
	enterNode(6)

func enterNode(nodeId:int):
	if RunManager.nodes[nodeId]["completed"]:
		print("Level completed !")
		return
	RunManager.createSummonerInstance()
	RunManager.currentNode = nodeId
	RunManager.currentEncounterData = RunManager.nodes[nodeId]["encounter data"]
	match  RunManager.nodes[nodeId]["type"]:
		Enum.EncounterType.COMBAT:
			get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
			print("ENTERING COMBAT SCENE Id:", nodeId)
		Enum.EncounterType.SPELL:
			print("ENTERING SPELL SCENE Id:", nodeId)
			get_tree().change_scene_to_file("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/SpellEncounterScene.tscn")
		Enum.EncounterType.BOSS:
			print("ENTERING BOSS SCENE Id:", nodeId)
			get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
		Enum.EncounterType.HEAL:
			print("ENTERING HEAL SCENE Id:", nodeId)
			get_tree().change_scene_to_file("res://utils/Data/EncounterData/HealEncounter/HealEncounterCaveScene.tscn")




