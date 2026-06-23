extends Node
class_name OverworldNode
@onready var anim = $AnimatedSprite2D
@onready var overworld = get_tree().get_first_node_in_group("overworld")

var encounterData:EncounterData
var id:int 
var previousNodes:Array
var nextNodes:Array
var encounterType:Enum.EncounterType

func _ready():
	if encounterData.completed == true:
		anim.play("completed")
	else:
		anim.play("active")


func onHover():
	if encounterData.unlocked and not encounterData.completed:
		match encounterData.encounterType:
			Enum.EncounterType.COMBAT,Enum.EncounterType.SPELL,Enum.EncounterType.ELITE,Enum.EncounterType.BOSS, Enum.EncounterType.MINI_BOSS:
				anim.modulate = Color(1.5, 1.5, 1.5)
			Enum.EncounterType.HEAL:
				anim.modulate = Color(1.2, 1.2, 1.2)
	elif encounterData.completed:
		print("Encounter completed")
	print(getNodeDetail())


func onMouseExit():
	if encounterData.unlocked:
		anim.modulate = Color(1, 1, 1)
#		anim.scale = Vector2(0.5, 0.5)
	elif encounterData.completed:
		print("Encounter completed")
		print(getNodeDetail())



func onClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and encounterData.completed:
		print("Already completed !")
	elif event is InputEventMouseButton and event.pressed and encounterData.unlocked:
		overworld.enterNode(encounterData)

func getNodeDetail() -> Dictionary:
	var previousEncounterIds:Array
	var nextEncounterIds:Array
	for encounter in encounterData.previousEncounters:
		previousEncounterIds.append(encounter.id)
	for encounter in encounterData.nextEncounters:
		nextEncounterIds.append(encounter.id)
	var dict = {
		"Encounter Type": Enum.EncounterType.keys()[encounterData.encounterType],
		"Id": encounterData.id,
		"Previous encounters": previousEncounterIds,
		"Next encounters": nextEncounterIds,
		"Completed": encounterData.completed,
		"Unlocked": encounterData.unlocked
	}
	return dict


