extends Resource
class_name Ability

@export var attackName: String
@export var damage: int
@export var type:Enum.AbilityType
@export var focusType:Enum.FocusType
@export var healAmount:int
@export var numberOfTargets:int
@export var element: String
@export var hitboxName:String
@export var statsAffected:Array[String]
@export var effectAmount:int
@export var needToMove:bool
@export var effectDuration:int
@export var statusEffect:Enum.StatusEffect
@export var splashDamage:int
@export var cooldown: int
@export var currentCooldown:int

