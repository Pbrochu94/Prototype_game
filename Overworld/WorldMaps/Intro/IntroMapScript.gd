extends Node2D
class_name IntroMap


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
	generateEncounterNodes(RunManager.worldEncounters.size())


func generateEncounterNodes(amount:int):
	for encounter in RunManager.worldEncounters:
		var encounterNode = encounter.overworldNodeScene.instantiate()
		encounterNode.encounterData = encounter
		nodeScenes.append(encounterNode)
	placeWorldNodes()

func placeWorldNodes():
	var anchorCounter=0
	for scene in nodeScenes:
		add_child(scene)
		scene.global_position = nodeAnchors[anchorCounter].global_position
		anchorCounter += 1
func enterNode(encounterData:EncounterData):
	RunManager.createSummonerInstance()
	RunManager.currentNodeId = encounterData.id
	RunManager.currentEncounterData = encounterData
	get_tree().change_scene_to_packed(encounterData.baseScene)




