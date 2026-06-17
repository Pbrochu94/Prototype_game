extends Node
class_name ItemButton
@onready var icon = $HBoxContainer/Icon
@onready var nameLabel = $HBoxContainer/Name
@onready var amount = $HBoxContainer/Amount
@onready var targetManager = get_tree().get_first_node_in_group("target manager")
var itemData:ItemData


# Called when the node enters the scene tree for the first time.
func init(itemName:String):
	itemData = ItemDB.consumables[itemName]
	icon.texture = itemData.icon
	nameLabel.text = itemData.itemName
	amount.text = str(itemData.stack)
func onClick():
	targetManager.startItemSelection(itemData)
	print(itemData.itemName, " was used to heal")
