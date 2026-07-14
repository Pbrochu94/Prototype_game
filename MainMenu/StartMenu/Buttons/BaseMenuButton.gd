extends Node
class_name BaseMenuButton

@onready var button = self
@onready var sizeControl = get_parent()

func _ready():
	sizeControl.pivot_offset = sizeControl.size / 2.0

func OnHover():
	sizeControl.scale = Vector2(1.2, 1.2)


func onMouseExit():
	sizeControl.scale = Vector2(1.0, 1.0)


func onClick():
	print("starting game")
	RunManager.init()
	RunManager.changeScene(RunManager.currentScene)
#	RunManager.changeScene(RunManager.currentWorld)
