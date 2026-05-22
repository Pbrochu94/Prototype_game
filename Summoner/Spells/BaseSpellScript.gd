extends Node2D
class_name BaseSpellScript
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var caster = get_tree().get_first_node_in_group("summoner")
var targets:Array[Node2D] 
var targetsPosition:Array[Vector2]
var projectileSpeed:float
var acceleration :float
var deceleration :float
var minSpeed:float
var maxSpeed :float
var isMoving:bool = false
var spellSelected

signal spellFinishedCasting

# Called when the node enters the scene tree for the first time.
func _ready():
	targets = caster.targets.duplicate()
	z_index = 1
	spellSelected = caster.spellSelected
	spellFinishedCasting.connect(caster.endingTurn)
#	for unit in targets:
#		targetsPosition.append(unit.global_position)
	anim.animation_finished.connect(onAnimationFinished)
	anim.play("appear")

func exit():
	anim.play("disapear")

func onAnimationFinished():
	match anim.animation:
		"appear":
			anim.play("active")
			isMoving = true
		"disapear":
			queue_free()
