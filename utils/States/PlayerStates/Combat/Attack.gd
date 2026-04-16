extends State
class_name Attack

@export var player:Node2D
var attackName:String
var damage:int

func enter():
	player.anim.play("attack")

func _init(name:String,damage:int):
	self.name = name
	self.damage = damage
