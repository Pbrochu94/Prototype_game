extends Node2D
class_name BaseSpellScript
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var caster = get_tree().get_first_node_in_group("summoner")
@onready var targets:Array[Node2D] = caster.targets
var targetsPosition:Array[Vector2]
var projectileSpeed:int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("AHHHH", targets)
	for unit in targets:
		targetsPosition.append(unit.global_position)
	anim.animation_finished.connect(onAnimationFinished)
	anim.play("appear")

func exit():
	anim.play("disapear")

func onAnimationFinished():
	match anim.animation:
		"appear":
			anim.play("active")
		"disapear":
			queue_free()
