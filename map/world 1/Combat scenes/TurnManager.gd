extends Node


var currentTurn = "player"
var currentCombatScene 
var player 
var enemy 

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	player = currentCombatScene.player
	enemy = currentCombatScene.enemy
	start_combat()

func start_combat():
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

