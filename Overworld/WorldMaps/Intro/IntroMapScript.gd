extends Node2D
class_name IntroMap

var encounters:Array[EncounterData]
var nodeScenes:Array
@onready var nodeAnchors=[
	$Anchors/Node,
	$Anchors/Node2,
	$Anchors/Node3,
	$Anchors/Node4,
	$Anchors/Node5,
	$Anchors/Node6,
	$Anchors/Node7,
]


func _ready():
	print(RunManager.getPlayerInfo())
	for i in range(7):
		encounters.append(EncounterDB.createEncounter(Enum.EncounterType.COMBAT))
	generateWorldNodes(encounters.size())
	for i in nodeScenes.size():
		nodeScenes[i].unlocked = true


#func combatNode1Clicked():
#	enterNode(0)
#
#
#func combatNode2Clicked():
#	enterNode(1)
#
#
#func spellNode1Clicked():
#	enterNode(2)
#
#func combatNode3Clicked():
#	enterNode(3)
#
#func combatNode4Clicked():
#	enterNode(4)
#
#func healNode1Clicked():
#	enterNode(5)
#
#func combatNode5Clicked():
#	enterNode(6)

func generateWorldNodes(amount:int):
	for encounter in encounters:
		var encounterNode = encounter.overworldNodeScene.instantiate()
		nodeScenes.append(encounterNode)
	placeWorldNodes()

func placeWorldNodes():
	var anchorCounter=0
	for scene in nodeScenes:
		add_child(scene)
		scene.global_position = nodeAnchors[anchorCounter].global_position
		anchorCounter += 1
#func enterNode(nodeId:int):
#	if RunManager.nodes[nodeId]["completed"]:
#		print("Level completed !")
#		return
#	RunManager.createSummonerInstance()
#	RunManager.currentNode = nodeId
#	RunManager.currentEncounterData = RunManager.nodes[nodeId]["encounter data"]
#	match  RunManager.nodes[nodeId]["type"]:
#		Enum.EncounterType.COMBAT:
#			get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
#			print("ENTERING COMBAT SCENE Id:", nodeId)
#		Enum.EncounterType.SPELL:
#			print("ENTERING SPELL SCENE Id:", nodeId)
#			get_tree().change_scene_to_file("res://utils/Data/EncounterData/SpellSelection/BasicSpellEncounter/SpellEncounterScene.tscn")
#		Enum.EncounterType.BOSS:
#			print("ENTERING BOSS SCENE Id:", nodeId)
#			get_tree().change_scene_to_file("res://MapNodes/Combat/CombatEncounterScene.tscn")
#		Enum.EncounterType.HEAL:
#			print("ENTERING HEAL SCENE Id:", nodeId)
#			get_tree().change_scene_to_file("res://utils/Data/EncounterData/HealEncounter/HealEncounterCaveScene.tscn")




