extends Node
class_name BaseDoor

@onready var doorSprite = get_parent()
@onready var detectArea = self
var destination

var playerIn := false

func onBodyEntered(body):
	if body.is_in_group("summoner"):
		playerIn = true

func onBodyExited(body):
	if body.is_in_group("summoner"):
		playerIn = false

func _process(_delta):
	if playerIn and Input.is_action_just_pressed("interact"):
		RunManager.changeScene(destination)
