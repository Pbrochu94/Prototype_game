extends Node2D

@onready var combatScene = self
@onready var playerActionBox = $PlayerActionsUI
@onready var playerAnchor = get_node("PlayerAnchor")
@onready var enemyAnchor = get_node("EnemyAnchor")
var player:Node2D 
var enemy:Node2D 
var turnManager:Node
var playerStartingPosition:Vector2
var enemyStartingPosition:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	playerActionBox.visible = false
	turnManager = get_tree().get_first_node_in_group("turn manager")
	player = get_tree().get_first_node_in_group("player")
	enemy = get_tree().get_first_node_in_group("enemy")
	playerStartingPosition = playerAnchor.global_position
	enemyStartingPosition = enemyAnchor.global_position
	player.currentCombatScene = combatScene
	turnManager.currentCombatScene = combatScene
	print(playerActionBox.global_position)
	print(player.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
