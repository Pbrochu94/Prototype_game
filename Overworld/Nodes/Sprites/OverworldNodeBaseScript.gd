extends Node
class_name OverworldNode
@onready var anim = $AnimatedSprite2D
@onready var overworld = get_tree().get_first_node_in_group("overworld")

var encounterData:EncounterData
var unlocked:bool = false
var completed:bool = false
var id:int 
var previousNodes:Array[int]
var nextNodes:Array[int]
var encounterType:Enum.EncounterType


func onHover():
	if unlocked:
		anim.modulate = Color(1.5, 1.5, 1.5)
		print(id)
#		anim.scale = Vector2(1.1, 1.1)




func onMouseExit():
	if unlocked:
		anim.modulate = Color(1, 1, 1)
		print("unhover")
		anim.scale = Vector2(1, 1)



func onClick(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and unlocked:
		print("clicked")
		overworld.enterNode(id)
