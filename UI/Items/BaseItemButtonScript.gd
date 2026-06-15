extends Node
class_name ItemButton
@onready var icon = $HBoxContainer/Icon
@onready var nameLabel = $HBoxContainer/Name
@onready var amount = $HBoxContainer/Amount
var itemData:ItemData


# Called when the node enters the scene tree for the first time.
func init():
	icon.texture = itemData.icon
	nameLabel.text = itemData.itemName
	amount.text = RunManager.inventory[itemData.itemName]["amount"]
