extends Control


#NODES
@onready var inventoryMenu = self
@onready var targetManager = get_tree().get_first_node_in_group("target manager")
@onready var closeBtn = $ColorRect/Close
@onready var scrollContainer = $ColorRect/ScrollContainer/VBoxContainer
var choiceMenuParent:Control

#SIGNALS
signal spellSelected(spellIndex:int)
signal cancelSelection

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in RunManager.inventory:
		var buttonScene = preload("res://UI/Items/BaseItemButtonScene.tscn").instantiate()
		buttonScene.itemData = RunManager.inventory[item]
		scrollContainer.add_child(buttonScene)
		buttonScene.init(RunManager.inventory[item].itemName)
	connectSignals()

func connectSignals():
	pass

func open():
	self.visible = true
	for child in self.get_children():
		child.visible = true

func close():
	targetManager.cancelSelection()
	self.visible = false
	for child in inventoryMenu.get_children():
		child.visible = false
	emit_signal("cancelSelection")
