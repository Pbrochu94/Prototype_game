extends State
class_name Attack


var attackName:String
var damage:int

func enter():
	owner.anim.play("attack")

func _init(name:String,damage:int):
	self.name = name
	self.damage = damage
