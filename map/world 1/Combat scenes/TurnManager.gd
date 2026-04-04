extends Node

@onready var player = get_node("PlayerCombat")
@onready var playerAnchor = get_parent().get_node("PlayerAnchor")
var enemy
var currentTurn = "player"

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	start_combat()

func start_combat():
	player = get_parent().get_node("PlayerCombat")
	#enemy = get_parent().get_node("EnemyCombat")
	player.intro(playerAnchor)
	startPlayerTurn()

func startPlayerTurn():
	currentTurn = "player"
	player.startTurn()

func end_player_turn():
	start_enemy_turn()

func start_enemy_turn():
	currentTurn = "enemy"
	enemy.start_turn()

func end_enemy_turn():
	startPlayerTurn()

