extends Node
class_name OverworldNode
@onready var anim = $AnimatedSprite2D
@onready var overworld = get_tree().get_first_node_in_group("overworld")

var encounterData:EncounterData
var completed:bool = false
var id:int 
var previousNodes:Array
var nextNodes:Array
var encounterType:Enum.EncounterType


func onHover():
	if encounterData.unlocked:
		anim.modulate = Color(1.5, 1.5, 1.5)
		print(getNodeDetail())




func onMouseExit():
	if encounterData.unlocked:
		anim.modulate = Color(1, 1, 1)
		anim.scale = Vector2(1, 1)



func onClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and encounterData.unlocked:
		overworld.enterNode(encounterData)

func getNodeDetail() -> Dictionary:
	var previousEncounterIds:Array
	var nextEncounterIds:Array
	for encounter in encounterData.previousEncounters:
		previousEncounterIds.append(encounter.id)
	for encounter in encounterData.nextEncounters:
		nextEncounterIds.append(encounter.id)
	var dict = {
		"Encounter Type": encounterData.encounterType,
		"Id": encounterData.id,
		"Previous encounters": previousEncounterIds,
		"Next encounters": nextEncounterIds
	}
	return dict
