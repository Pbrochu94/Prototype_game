extends Node


const consumables : Dictionary = {
	"light potion": {
		"res":preload("res://utils/Data/ItemData/Consumable/LightPotion.tres"),
		"chance": 50
	}
}

const currency:Dictionary = {
	Enum.CurrencyType.LIGHT_SHARD : {
		
	}
}

func createItemInstance():
	pass
