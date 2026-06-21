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

func generateWorldNodes(amount:int):
	var previousEncounter
	for encounter in encounters:
		var encounterNode = encounter.overworldNodeScene.instantiate()
		if previousEncounter:
			encounterNode.previousNodes.append(previousEncounter)
			previousEncounter.nextNodes.append(encounterNode)
		encounterNode.encounterData = encounter
		nodeScenes.append(encounterNode)
		previousEncounter = encounterNode
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




