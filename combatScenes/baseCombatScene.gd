extends Node2D

@onready var combatScene = self
@onready var playerAnchor = get_node("PlayerAnchor")
@onready var enemyAnchor = get_node("EnemyAnchor")
var player 
var enemy 
var turnManager 


# Called when the node enters the scene tree for the first time.
func _ready():
	turnManager = get_tree().get_first_node_in_group("turn manager")
	player = get_tree().get_first_node_in_group("player")
	enemy = get_tree().get_first_node_in_group("enemy")
	turnManager.currentCombatScene = combatScene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
