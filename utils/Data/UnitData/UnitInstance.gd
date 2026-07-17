extends Resource
class_name UnitInstance

@export var definition: UnitDefinition
@export var characterName:String 
@export var characterTag:String 
@export var maxHp:int 
@export var currentHp:int 
@export var speed:int 
@export var baseSpeed:int 
@export var deff:int
@export var baseDeff:int 
@export var atk:int
@export var baseAtk:int 
@export var scene:Node2D
@export var element:Enum.Element
@export var attacks:Array[Ability]
@export var walkSpeed:int
var faction:Enum.Faction
var isDead:bool
var activeEffects:Array[Effect] = []

#------------------------------EFFECTS-----------------------------------------
var hasRetaliation:bool = false

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

func getUnitInfo():
	var effectSummaries = []
	for effect in activeEffects:
		match effect.type:
			Enum.StatusEffect.STAT_MODIFIER:
						var effectSummary:Dictionary
						effectSummary["name"] = effect.name
						effectSummary["amount %"] = effect.amount if "amount" in effect else ""
						effectSummary["amount digit"] = effect.digitAmount
						effectSummary["duration"] = effect.duration
						effectSummaries.append(effectSummary)
			Enum.StatusEffect.RETALIATION:
						var effectSummary:Dictionary
						effectSummary["name"] = effect.name
						effectSummary["amount"] = effect.amount if "amount" in effect else ""
						effectSummary["duration"] = effect.duration
						effectSummaries.append(effectSummary)
			Enum.StatusEffect.INVULNERABLE:
						var effectSummary:Dictionary
						effectSummary["name"] = effect.name
						effectSummary["duration"] = effect.duration
						effectSummaries.append(effectSummary)
		var effectSummary = {}
	var attacks = []
	for attack in attacks:
		attacks.append(attack)
	return {
		"Name": characterName,
		"Stats": {
			"currentHp": currentHp,
			"atk":atk,
			"deff":deff,
			"speed":speed
		},
		"Active effects": effectSummaries,
		"Attacks": attacks,
#		"State": currentState,
#		"z": z_index
	}
