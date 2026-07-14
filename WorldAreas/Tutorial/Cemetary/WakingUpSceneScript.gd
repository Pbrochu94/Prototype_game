extends Node2D

@export var wakeUpDialogue: DialogueRes
# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.startDialogue(wakeUpDialogue)
