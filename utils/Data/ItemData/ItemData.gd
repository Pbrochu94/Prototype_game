extends Resource
class_name ItemData
@export var itemName: String
@export var description: String
@export var icon: Texture2D
@export var stack: int 
@export var maxStack: int = 99
@export var amount: int 
@export var partyAffected: Enum.targetPartySelection

func use(target):
	print("healed ", target, " for ", amount, " hp")
	target.heal(amount)
