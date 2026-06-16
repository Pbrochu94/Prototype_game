extends Node
class_name ItemButton
@onready var icon = $HBoxContainer/Icon
@onready var nameLabel = $HBoxContainer/Name
@onready var amount = $HBoxContainer/Amount
var itemData:ItemData


# Called when the node enters the scene tree for the first time.
func init(itemName:String):
	print(itemData)
	print(ItemDB.consumables[itemName])
	itemData = ItemDB.consumables[itemName]
	icon.texture = itemData.icon
	nameLabel.text = itemData.itemName
	amount.text = str(itemData.amount)
	print(nameLabel)
	print(amount)
	print(nameLabel.get_path())
	print(amount.get_path())
