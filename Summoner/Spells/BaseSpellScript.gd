extends Node2D
class_name BaseSpellScript
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var caster = get_tree().get_first_node_in_group("summoner")


var targets:Array[UnitInstance] 
var targetsPosition:Array[Vector2]
var projectileSpeed:float
var acceleration :float
var deceleration :float
var minSpeed:float
var maxSpeed :float
var isMoving:bool = false
var spellSelected
@export var spellRes:SummonerSpell

signal spellFinishedCasting

# Called when the node enters the scene tree for the first time.
func _ready():
	targets = caster.targets.duplicate()
	z_index = 1
	spellSelected = caster.spellSelected
	spellFinishedCasting.connect(caster.endingTurn)
	anim.animation_finished.connect(onAnimationFinished)
	anim.play("appear")

func exit():
	anim.play("disapear")
	if spellSelected.isDamagingSpell:
		await anim.animation_finished
		emit_signal("spellFinishedCasting")

func onAnimationFinished():
	match anim.animation:
		"appear":
			anim.play("active")
			isMoving = true
		"disapear":
			queue_free()
