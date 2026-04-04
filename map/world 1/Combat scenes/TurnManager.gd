extends Node

@onready var player 
@onready var playerAnchor = get_parent().get_node("PlayerAnchor")
@onready var enemy 
@onready var enemyAnchor = get_parent().get_node("EnemyAnchor")
var currentTurn = "player"

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	player = get_parent().get_node("PlayerCombat")
	enemy = get_parent().get_node("MinorGunEnemyCombat")
	start_combat()
	#print(enemy)

func start_combat():
	player.intro(playerAnchor)
	enemy.intro(enemyAnchor)
	enemy.combatScene = self
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

