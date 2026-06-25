extends Resource
class_name UnitInstance

@export var definition: UnitDefinition
@export var characterName:String 
@export var characterTag:String 
@export var maxHp:int 
@export var currentHp:int 
@export var speed:int 
@export var baseSpeed:int 
#@export var attacks:Dictionary = {}
#@export var attackSelected:Ability
@export var deff:int
@export var baseDeff:int 
@export var atk:int
@export var baseAtk:int 
@export var sceneInstance:Node2D
@export var element:Enum.Element
@export var attacks:Array[Ability]
@export var walkSpeed:int

func getInfo():
	var summary = {
		"Name":characterName,
		"Current hp":currentHp,
		"Max hp":maxHp,
		"speed":speed,
		"Base speed":baseSpeed,
		"Atk": atk,
		"Base atk": baseAtk,
		"Deff":deff,
		"Base deff": baseDeff 
	}
	return summary
