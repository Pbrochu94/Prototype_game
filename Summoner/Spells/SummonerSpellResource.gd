extends Resource
class_name SummonerSpell

@export var spellName: String
@export var damage: int
@export var type:Enum.SpellType
@export var focusType:Enum.FocusType
@export var healAmount:int
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
@export var numberOfTargets:int
@export var spellScene:PackedScene
@export var startingAnimPoint:Enum.SummonerSpellStartingPoint
@export var isDamagingSpell:bool = false
@export var effectRes:Effect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

