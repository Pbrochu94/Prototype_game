extends Resource
class_name Ability

@export var attackName: String
@export var damage: int
@export var type:AbilityType
@export var focus:FocusType
@export var healAmount:int
@export var cooldown: int
@export var element: String
@export var hitboxName:String
@export var atkBuff:int
@export var deffBuff:int
@export var spdBuff:int
@export var atkDebuff:int
@export var deffDebuff:int
@export var spdDebuff:int
@export var needToMove:bool
@export var duration:int




#ENUMS
enum AbilityType {
	ATTACK,
	HEAL,
	SELFHEAL,
	BUFF,
	DEBUFF
}

enum FocusType {
	SELF,
	ENEMY,
	ENEMY_MULTIPLE,
	ALLY,
	ALLY_MULTIPLE,
	AOE
}

