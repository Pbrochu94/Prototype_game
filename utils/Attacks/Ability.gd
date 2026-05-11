extends Resource
class_name Ability

@export var attackName: String
@export var damage: int
@export var type:Enum.AbilityType
@export var focus:Enum.FocusType
@export var healAmount:int
@export var cooldown: int
@export var element: String
@export var hitboxName:String
@export var statsAffected:Array[String]
@export var effectAmount:int
#@export var atkBuff:int
#@export var deffBuff:int
#@export var spdBuff:int
#@export var atkDebuff:int
#@export var deffDebuff:int
#@export var spdDebuff:int
@export var needToMove:bool
@export var effectDuration:int
@export var statusEffect:Enum.StatusEffect



