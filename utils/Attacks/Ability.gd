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
@export var atkDebuff:int
@export var deffDebuff:int
@export var spdDebuff:int




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
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
