extends Node2D

@onready var respawnAnchor = $RespawnAnchor
@onready var summoner = RunManager.summoner.roamingSceneInstance
@export var wakeUpDialogue: DialogueRes
# Called when the node enters the scene tree for the first time.
func _ready():
#	DialogueManager.startDialogue(wakeUpDialogue)
	pass
func spawnSummoner():
	summoner.global_position = respawnAnchor.global_position
	summoner.spawn()
